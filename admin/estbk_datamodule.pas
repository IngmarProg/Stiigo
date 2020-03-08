unit estbk_datamodule;

{$mode objfpc}{$H+}
{$I estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Dialogs,
  ZConnection, estbk_dbcompability, estbk_lib_databaseschema, estbk_types, estbk_progressform, estbk_strmsg,
  estbk_utilities, DB, ZDataset, ZSqlUpdate, ZSequence, estbk_sqlcollection, estbk_globvars, estbk_permissions,
  {$ifdef linux}cwstring,{$endif}
  DOM, XMLRead, XMLWrite;

type

  { TadmDatamodule }

  TadmDatamodule = class(TDataModule)
    admTempQuery: TZQuery;
    admTempQuery2: TZQuery;
    admWorkerMgmSeq: TZSequence;
    admWorkerMgmSql: TZUpdateSQL;
    admConnection: TZConnection;
    admCompListUpSql: TZUpdateSQL;
    admCompListSeq: TZSequence;
    admBufferedRolePermRelations: TZQuery;
    qryVatSeq: TZSequence;
    qryFormLinesSeq: TZSequence;

    procedure DataModuleCreate(Sender: TObject);
  protected
    procedure fixTables;
    procedure addSeqTriggers;
    procedure insertAllPreDefConfVars;
    procedure __intassignNewAccRecNr(const pAccMrecId: integer; const pNewnr: integer; const pTransDescr: AStr = '');
    procedure __intdeleteCompanyNumerators(const pCompanyId: integer);
    procedure __intreCreateNumerator(const pNumType: AStr; const pNumVal: integer; const pCompanyId: integer);
    procedure __intAddNewNumVal(const pNumType: AStr; const pNumVal: integer; const pCompanyId: integer);
  public
    procedure assignRolePermissions(var AErrors: AStr);
    function findActiveLanguage: AStr;
    function remapNumerators(const pCompanyId: integer): boolean;
    function pgCollation(const pTempl0Collation: AStr): AStr; // ainult postgre puhul !


    // kõik seaded; käibemaksud; riigid; jne jne; TODO: et saaks ka muutujate nimekirja täiustada !
    function insertPreDefValsFromConfFile: boolean;
    // seoses struktuuride uuendamisega on mõttekas teda publikuna hoida, et estbk_upgrademodule saaks teda välja kutsuda !
    procedure addFncTriggers(const pCreateTriggers: boolean = True);

    // ----------
    procedure connect(const shost: AStr; const sport: integer; const susername: AStr; const spassword: AStr);

    // 16.08.2009 ingmar kontrollime üle tabelid ja struktuurid...kontrollib, kas tabelid loodud, kui autocreate, siis nad luuakse
    function validateTables(const autoCreate: boolean; var emsg: AStr; var template0Collation: AStr; // ainult Postgre puhul olemas
      const eparam: boolean): boolean;
  end;

var
  admDatamodule: TadmDatamodule;

implementation

uses estadmin_form, estbk_settings;

function TadmDatamodule.findActiveLanguage: AStr;
begin
  // @@
  with admTempQuery, SQL do
    try
      Close;
      Clear;
      Add(estbk_sqlcollection._SQLFindActiveLanguage);
      Open;
      Result := FieldByName('item_value').AsString;
    finally
      Close;
      Clear;
    end;
end;


procedure TadmDatamodule.__intassignNewAccRecNr(const pAccMrecId: integer; const pNewnr: integer; const pTransDescr: AStr = '');
begin
  with admTempQuery2, SQL do
    try
      Close;
      Clear;
      if pTransDescr = '' then
      begin
        add('UPDATE accounting_register');
        add('SET entrynumber=:entrynumber');
        add('WHERE id=:id');
      end
      else
      begin
        add('UPDATE accounting_register');
        add('SET entrynumber=:entrynumber,transdescr=:transdescr');
        add('WHERE id=:id');
        ParamByname('transdescr').AsString := pTransDescr;
      end;


      ParamByname('entrynumber').AsString := IntToStr(pNewnr);
      ParamByname('id').AsInteger := pAccMrecId;
      execSQL;
    finally
      // --
      Close;
      Clear;
    end;
end;


procedure TadmDatamodule.__intdeleteCompanyNumerators(const pCompanyId: integer);
begin
  with admTempQuery2, SQL do
    try
      Close;
      Clear;
      add('DELETE FROM numerators WHERE company_id=' + IntToStr(pCompanyId));
      ExecSQL;
    finally
      // --
      Close;
      Clear;
    end;
end;


procedure TadmDatamodule.__intreCreateNumerator(const pNumType: AStr; const pNumVal: integer; const pCompanyId: integer);
var
  pParamCheck: boolean;
begin
  with admTempQuery2, SQL do
    try
      pParamCheck := paramCheck;
      paramCheck := True;
      Close;
      Clear;
      add('INSERT INTO numerators(cr_num_val,cr_num_start,cr_num_type,cr_version,rec_changed,accounting_period_id,company_id)');
      add('VALUES(:cr_num_val,:cr_num_start,:cr_num_type,:cr_version,:rec_changed,:accounting_period_id,:company_id)');
      paramByname('cr_num_val').AsInteger := pNumVal;
      paramByname('cr_num_start').AsInteger := 1;
      paramByname('cr_num_type').AsString := pNumType;
      paramByname('cr_version').AsInteger := 1;
      paramByname('rec_changed').AsDateTime := now;
      paramByname('accounting_period_id').AsInteger := 0;
      paramByname('company_id').AsInteger := pCompanyId;
      execSQL;
    finally
      paramCheck := pParamCheck;
      Close;
      Clear;
    end;
end;

// nüüd numeraatorile reset !
procedure TadmDatamodule.__intAddNewNumVal(const pNumType: AStr; const pNumVal: integer; const pCompanyId: integer);
begin
  with admTempQuery2, SQL do
    try
      Close;
      Clear;
      Add('UPDATE numerators');
      Add('SET cr_num_val=:numval');
      Add('WHERE company_id=:company_id');
      Add('  AND cr_num_type=:crnumtype');

      ParamByname('company_id').AsInteger := pCompanyId;
      ParamByname('numval').AsInteger := pNumVal;
      ParamByname('crnumtype').AsString := pNumType;
      ExecSQL;
    finally
      Close;
      Clear;
    end;
end;

// @@@
// 24.01.2013 Ingmar; alustab 1 peale
function TadmDatamodule.remapNumerators(const pCompanyId: integer): boolean;
const
  CBillTypes: array[0..3] of AStr = (estbk_types._CItemSaleBill,
    estbk_types._CItemPurchBill,
    estbk_types._CItemCreditBill,
    estbk_types._CItemPrepaymentBill);
var
  pParamCheck: boolean;
  i: integer;
  pAccNr: integer;
  pNumType: AStr;
  pCSRegNr: integer;
  pCsNrDescr: AStr;
  pDescr: AStr;
begin
  Result := False;
  with admTempQuery, SQL do
    try
      pParamCheck := ParamCheck;
      ParamCheck := True;
      Close;
      Clear;
      add(estbk_sqlcollection._SQLSelectACPVar);
      paramByname('company_id').AsInteger := pCompanyId;
      Open;
      if FieldByName('id').AsInteger > 0 then
      begin
        Dialogs.messageDlg(estbk_strmsg.SECantRenumber, mtError, [mbOK], 0);
        Exit;
      end;


      if Dialogs.messageDlg(estbk_strmsg.SConfDoWePerformRenr, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        Exit;



      try
        admConnection.StartTransaction;
        // trigger esmalt maha !
        Close;
        Clear;
        SQL.Text := 'ALTER TABLE accounting_register DISABLE TRIGGER USER';
        execSQL;

        // leiame maksimaalsed numeraatorid, kui miskit pekki sisemiselt vahepeal läinud
        Close;
        Clear;
        Add('SELECT MAX(cr_num_val) as mxval,cr_num_type');
        Add('FROM  numerators');
        Add('WHERE company_id=' + IntToStr(pCompanyId));
        Add('GROUP BY cr_num_type');
        Open;
        // -- vol kaks ja nüüd kustutame kõik selle firma numeraatorid !
        self.__intdeleteCompanyNumerators(pCompanyId);
        // --
        First;
        while not EOF do
        begin
          self.__intreCreateNumerator(FieldByName('cr_num_type').AsString, FieldByName('mxval').AsInteger, pCompanyId);
          Next;
        end;



        // ARVED ------------------------------------------------------

        // ESMALT arved korda !
        Close;
        Clear;
        Add('SELECT id,accounting_register_id');
        Add('FROM bills');
        Add('WHERE bill_type=:billtype');
        Add('  AND company_id=:company_id');
        Add('  AND rec_deleted=''f''');
        Add(' ORDER BY id ASC ');

        for i := low(CBillTypes) to high(CBillTypes) do
        begin
          ParamByname('company_id').AsInteger := pCompanyId;
          ParamByname('billtype').AsString := CBillTypes[i];
          Open;
          First;
          pAccNr := 0;
          while not EOF do
          begin
            Inc(pAccNr);
            self.__intassignNewAccRecNr(FieldByName('accounting_register_id').AsInteger, pAccNr);
            // ---
            Next;
          end; // ---



          if CBillTypes[i] = estbk_types._CItemSaleBill then
            pNumType := TNumeratorTypesSDescr[estbk_types.CAccSBill_rec_nr]
          else
          if CBillTypes[i] = estbk_types._CItemPurchBill then
            pNumType := TNumeratorTypesSDescr[estbk_types.CAccPBill_rec_nr]
          else
          if CBillTypes[i] = estbk_types._CItemCreditBill then
            pNumType := TNumeratorTypesSDescr[estbk_types.CAccCBill_rec_nr]
          else
          if CBillTypes[i] = estbk_types._CItemPrepaymentBill then
            pNumType := TNumeratorTypesSDescr[estbk_types.CAccRBill_rec_nr];

          self.__intAddNewNumVal(pNumType, pAccNr, pCompanyId);
          // ---
        end;


        // LAEKUMISED ------------------------------------------------------

        Close;
        Clear;
        Add('SELECT id,accounting_register_id');
        Add('FROM incomings');
        Add('WHERE company_id=:company_id');
        Add(' AND status NOT LIKE ''%D%''');
        Add(' AND incomings_bank_id>0 ');
        Add(' AND cash_register_id=0 ');
        Add(' AND rec_deleted=''f''');
        Add(' ORDER BY id ASC ');
        ParamByname('company_id').AsInteger := pCompanyId;
        Open;
        First;
        pAccNr := 0;
        while not EOF do
        begin
          Inc(pAccNr);
          self.__intassignNewAccRecNr(FieldByName('accounting_register_id').AsInteger, pAccNr);
          Next;
        end;


        self.__intAddNewNumVal(TNumeratorTypesSDescr[estbk_types.CAccInc_rec_nr], pAccNr, pCompanyId);

        // TASUMISED  ------------------------------------------------------
        Close;
        Clear;
        Add('SELECT id,accounting_register_id');
        Add('FROM payment');
        Add('WHERE company_id=:company_id');
        Add('  AND template=''f''');
        Add('  AND rec_deleted=''f''');
        Add('  AND payment_type=''P''');
        Add('ORDER BY id ASC');
        ParamByname('company_id').AsInteger := pCompanyId;
        Open;
        First;
        pAccNr := 0;
        while not EOF do
        begin
          Inc(pAccNr);
          self.__intassignNewAccRecNr(FieldByName('accounting_register_id').AsInteger, pAccNr);
          Next;
        end;



        self.__intAddNewNumVal(TNumeratorTypesSDescr[estbk_types.CAccPmt_rec_nr], pAccNr, pCompanyId);

        pCSRegNr := 0;
        // KASSA  ------------------------------------------------------
        // Väljamineku order !
        Close;
        Clear;
        Add('SELECT p.id,r.transdescr,r.entrynumber,p.accounting_register_id');
        Add('FROM payment p');
        Add('INNER JOIN accounting_register r ON');
        Add('r.id=p.accounting_register_id');
        Add('WHERE p.payment_type=''R''');
        Add(' AND p.template=''f''');
        Add(' AND p.status NOT LIKE ''%D%''');
        Add(' AND r.transdescr NOT LIKE ''Sisse%''');
        Add('ORDER BY p.id ASC');
        Open;
        First;
        pAccNr := 0;
        while not EOF do
        begin
          Inc(pAccNr);
          Inc(pCSRegNr);
          pDescr := format('Väljamineku order %d', [pCSRegNr]);
          self.__intassignNewAccRecNr(FieldByName('accounting_register_id').AsInteger, pAccNr, pDescr);
          Next;
        end;


        self.__intAddNewNumVal(TNumeratorTypesSDescr[estbk_types.CAccCro_rec_nr], pAccNr, pCompanyId);  // VÄLJA

        // Sissetuleku orderid !
        Close;
        Clear;
        Add('SELECT p.id,r.transdescr,r.entrynumber,p.accounting_register_id');
        Add('FROM payment p');
        Add('INNER JOIN accounting_register r ON');
        Add('r.id=p.accounting_register_id');
        Add('WHERE p.payment_type=''R''');
        Add(' AND p.template=''f''');
        Add(' AND p.status NOT LIKE ''%D%''');
        Add(' AND r.transdescr LIKE ''Sisse%''');
        Add('ORDER BY p.id ASC');
        Open;
        First;
        pAccNr := 0;
        while not EOF do
        begin
          Inc(pAccNr);
          Inc(pCSRegNr);
          pDescr := format('Sissetuleku order %d', [pCSRegNr]);
          self.__intassignNewAccRecNr(FieldByName('accounting_register_id').AsInteger, pAccNr, pDescr);
          Next;
        end;


        self.__intAddNewNumVal(TNumeratorTypesSDescr[estbk_types.CAccCri_rec_nr], pAccNr, pCompanyId);  // SISSE
        self.__intAddNewNumVal(TNumeratorTypesSDescr[estbk_types.CCSRegister_doc_recnr], pCSRegNr, pCompanyId);


        // ja tagasi
        Close;
        Clear;
        SQL.Text := 'ALTER TABLE accounting_register ENABLE TRIGGER USER';
        execSQL;
        admConnection.Commit;
        Result := True;
        // ---
        Dialogs.ShowMessage(estbk_strmsg.SCommDone);
      except
        on e: Exception do
        begin
          try
            admConnection.Rollback;
          except
          end;
          Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
        end;
      end; // ---
    finally
      Close;
      Clear;
      // ---
      ParamCheck := pParamCheck;
    end;
end;

// @@@
procedure TadmDatamodule.DataModuleCreate(Sender: TObject);
begin
  admCompListUpSql.InsertSQL.add(estbk_sqlcollection._SQLInsertCompany);
  admCompListUpSql.ModifySQL.add(estbk_sqlcollection._SQLUpdateCompany);

  // tüütajad...ptui töötajad
  admWorkerMgmSql.InsertSQL.add(estbk_sqlcollection._SQLInsertWorker);
  admWorkerMgmSql.ModifySQL.add(estbk_sqlcollection._SQLUpdateWorker);

  admBufferedRolePermRelations.SQL.add(estbk_sqlcollection._SQLAllRolePermissions);
end;


procedure TadmDatamodule.fixTables;
var
  i: TCTablenames;
begin

  if sqlp.currentBackEnd = __postGre then
    for i := low(TCTablenames) to high(TCTablenames) do
      with admTempQuery, SQL do
        try
          try
            Close;
            Clear;
            add(format('VACUUM FULL %s', [CTable_names[i]]));
            execSQL;

            Close;
            Clear;
            add(format('REINDEX TABLE %s', [CTable_names[i]]));
            execSQL;

          finally
            Close;
            Clear;
          end;
          // --
        except
        end;
end;

procedure TadmDatamodule.connect(const shost: AStr; const sport: integer; const susername: AStr; const spassword: AStr);
begin
  self.admConnection.User := susername;
  self.admConnection.Password := spassword;
  // ---

  self.admConnection.Protocol := estbk_dbcompability.sqlp.getCurrentBackEndProtocol;
  estbk_dbcompability.sqlp.initPropertiesByBackend(self.admConnection.Properties);
  self.admConnection.Database := estbk_dbcompability.sqlp._getDefaultDatabaseName;
  self.admConnection.HostName := shost;
  self.admConnection.Port := sport;

  self.admConnection.Connect;

  // --- ka MYSQL puhul peab ütlema, et ühendus on UTF8 ka Postgre
  with admTempQuery, SQL do
  begin
    Close;
    Clear;
    add(estbk_dbcompability.sqlp._aquireUTF8ConnectionSQL);
    execSQL;
  end;



  // ---
  // 0 adminn
  glob_worker_id := 0;
end;

function TadmDatamodule.insertPreDefValsFromConfFile: boolean;
var
  FConfDoc: TXMLDocument;
  FStrcFailure: boolean;

  FSubChildNode: TDomNode;
  FChildNode: TDomNode;
  FChildNode2: TDomNode;
  FAttrNode: TDomNode;
  FAttrNode2: TDomNode;

  FAttrName: AStr;
  FAttrVal1: AStr;
  FAttrVal2: AStr;
  FVatPerc: double;

  i, j: cardinal;
  FOrigPchkStatus: boolean;
begin
  FStrcFailure := False;
  Result := False;

  try
    FOrigPchkStatus := admTempQuery.paramCheck;
    admTempQuery.paramCheck := True;


    FConfDoc := nil;
    ReadXMLFile(FConfDoc, 'stiigo_preconf.xml');


    if assigned(FConfDoc.DocumentElement) then
    begin

      //FChildNode  :=FConfDoc.DocumentElement.FirstChild;
      FSubChildNode := FConfDoc.DocumentElement;
      FStrcFailure := not (assigned(FSubChildNode) and (ansilowercase(FSubChildNode.NodeName) = 'conf'));

      if not FStrcFailure then
      begin
        for i := 0 to FSubChildNode.ChildNodes.Count - 1 do
        begin
          FChildNode := FSubChildNode.ChildNodes.Item[i];
          if assigned(FChildNode) then
            //  ===============================================================
            // 06.04.2011 Ingmar
            //  ===============================================================
            if (ansilowercase(FChildNode.NodeName) = 'banks') then
            begin
              // <item swift="HABAEE2X" lcode="767" accprefix="22,11">Swedbank AS</item>
              FChildNode := FChildNode.FirstChild;

              // kõiki teisi tage hetkel ignoreerime, mitte ei karju viga !
              while assigned(FChildNode) do
              begin

                if (ansilowercase(FChildNode.Nodename) = 'item') then
                begin
                  FStrcFailure := not assigned(FChildNode.Attributes);
                  if FStrcFailure then
                    exit;

                  FAttrNode := FChildNode.Attributes.GetNamedItem('swift');
                  FAttrNode2 := FChildNode.Attributes.GetNamedItem('lcode');
                  FStrcFailure := (not assigned(FAttrNode) and not assigned(FAttrNode)) or
                    (assigned(FAttrNode) and (length(trim(FAttrNode.TextContent)) = 0)) or
                    (assigned(FAttrNode2) and (length(trim(FAttrNode2.TextContent)) = 0)) or
                    (length(trim(FChildNode.TextContent)) = 0);
                  if FStrcFailure then
                    exit;



                  // kirjutame pangad ära...
                  with admTempQuery, SQL do
                  begin
                    Close;
                    Clear;
                    add(estbk_sqlcollection._SQLInsertBanks);
                    parambyname('bank_name').AsString := copy(trim(utf8encode(FChildNode.TextContent)), 1, 45);
                    if assigned(FAttrNode) then
                      parambyname('swift').AsString := copy(trim(utf8encode(FAttrNode.TextContent)), 1, 10)
                    else
                      parambyname('swift').AsString := '';

                    if assigned(FAttrNode2) then
                      parambyname('lcode').AsString := copy(trim(utf8encode(FAttrNode2.TextContent)), 1, 5)
                    else
                      parambyname('lcode').AsString := '';
                    parambyname('company_id').AsInteger := 0;
                    parambyname('rec_changed').AsDateTime := now;
                    parambyname('rec_changedby').AsInteger := 0;
                    parambyname('rec_addedby').AsInteger := 0;
                    execSQL;
                  end;

                  // ---
                end;

                // ---
                FChildNode := FChildNode.NextSibling;
              end; // ---
            end
            else
            //  ===============================================================
            // 05.12.2009 Ingmar
            //  ===============================================================
            if (ansilowercase(FChildNode.NodeName) = 'vat') then
            begin
              FChildNode := FChildNode.FirstChild;

              // kõiki teisi tage hetkel ignoreerime, mitte ei karju viga !
              while assigned(FChildNode) do
              begin

                if (ansilowercase(FChildNode.Nodename) = 'item') then
                begin
                  FStrcFailure := not assigned(FChildNode.Attributes);
                  if FStrcFailure then
                    exit;


                  FAttrNode := FChildNode.Attributes.GetNamedItem('name');
                  FStrcFailure := not assigned(FAttrNode) or (length(trim(FAttrNode.TextContent)) = 0) or
                    (length(trim(FChildNode.TextContent)) = 0);
                  if FStrcFailure then
                    exit;

                  // käibemaksu nimi
                  FAttrVal1 := trim(utf8encode(FAttrNode.TextContent));
                  FAttrNode := FChildNode.Attributes.GetNamedItem('countrycode');
                  if not assigned(FAttrNode) or (length(trim(FAttrNode.TextContent)) = 0) then
                    FAttrVal2 := estbk_types.CDefaultCountry
                  else
                    FAttrVal2 := copy(trim(utf8encode(FAttrNode.TextContent)), 1, 3);
                  FVatPerc := strtofloatdef(FChildNode.TextContent, -1);
                  // 19.03.2010 ingmar; lubame negatiivset VAT, siis ei vöeta seda peale
                  //if  FVatPerc<0 then
                  //    exit;

                  FAttrNode := FChildNode.Attributes.GetNamedItem('default');

                  // ----------------------------------------------
                  // kirjutame baasi
                  // ----------------------------------------------

                  with admTempQuery, SQL do
                  begin
                    Close;
                    Clear;
                    add(estbk_sqlcollection._SQLInsertNewVATZValue);
                    paramByname('id').AsInteger := admDatamodule.qryVatSeq.GetNextValue;
                    paramByname('description').AsString := FAttrVal1;
                    paramByname('country_code').AsString := FAttrVal2;
                    paramByname('perc').AsFloat := FVatPerc;
                    // 22.11.2010 Ingmar
                    paramByname('base_rec_id').Value := null;

                    if FVatPerc >= 0 then
                      paramByname('flags').AsInteger := 0
                    else
                      paramByname('flags').AsInteger := estbk_types._CVtmode_dontAdd;


                    // ---
                    if assigned(FAttrNode) and (estbk_utilities.isTrueVal(FAttrNode.textContent)) then
                      paramByname('defaultvat').AsString := 't'
                    else
                      paramByname('defaultvat').AsString := 'f';
                    execSQL;
                  end;

                end;
                // ---
                FChildNode := FChildNode.NextSibling;
              end;
            end
            else
            //  ===============================================================
            if (ansilowercase(FChildNode.NodeName) = 'systemvar') then
            begin
              FChildNode := FChildNode.FirstChild;
              // kõiki teisi tage hetkel ignoreerime, mitte ei karju viga !
              while assigned(FChildNode) do
              begin

                if (ansilowercase(FChildNode.Nodename) = 'var') then
                begin
                  FStrcFailure := not assigned(FChildNode.Attributes);
                  if FStrcFailure then
                    exit;

                  //for j:=0 to FChildNode.Attributes.Count-1 do
                  FAttrNode := FChildNode.Attributes.GetNamedItem('name');

                  FStrcFailure := not assigned(FAttrNode) or (length(trim(FAttrNode.TextContent)) = 0) or
                    (length(trim(FChildNode.TextContent)) = 0);
                  if FStrcFailure then
                    exit;

                  // ----------------------------------------------
                  // kirjutame baasi
                  // ----------------------------------------------
                  with admTempQuery, SQL do
                  begin
                    Close;
                    Clear;
                    add(estbk_sqlcollection._SQLInsertNewSystemConfValue);
                    paramByname('var_name').AsString := trim(utf8encode(FAttrNode.TextContent));
                    paramByname('var_val').AsString := trim(utf8encode(FChildNode.TextContent));
                    paramByname('var_misc').AsInteger := 0;
                    execSQL;
                  end;
                  // ----------------------------------------------
                end;
                // ---
                FChildNode := FChildNode.NextSibling;
              end;
              // ---
            end
            else
            //  ===============================================================
            if (ansilowercase(FChildNode.NodeName) = 'classificators') then
            begin

              FChildNode := FChildNode.FirstChild;
              while assigned(FChildNode) do
              begin
                if (ansilowercase(FChildNode.NodeName) = 'items') then
                begin
                  FStrcFailure := not assigned(FChildNode.Attributes);
                  if FStrcFailure then
                    exit;
                  FAttrNode := FChildNode.Attributes.GetNamedItem('collectioname');

                  FStrcFailure := not assigned(FAttrNode) or (length(trim(FAttrNode.TextContent)) = 0);
                  if FStrcFailure then
                    exit;

                  FAttrName := trim(FAttrNode.TextContent);
                  //FChildNode:=FChildNode.ChildNodes.Item[j];
                  FChildNode2 := FChildNode.FirstChild;
                  while assigned(FChildNode2) do
                  begin

                    if (ansilowercase(FChildNode2.nodename) = 'item') then
                    begin

                      FStrcFailure := not assigned(FChildNode2.Attributes);
                      if FStrcFailure then
                        exit;

                      FAttrNode := FChildNode2.Attributes.GetNamedItem('shortid');
                      FAttrNode2 := FChildNode2.Attributes.GetNamedItem('value');

                      FStrcFailure := (not assigned(FAttrNode) and not assigned(FAttrNode2)) or
                        (length(trim(FChildNode2.TextContent)) = 0) or
                        // mingi kirjeldus peab real olema ! <item shortid="AR">Arve</item>
                        (assigned(FAttrNode) and (length(trim(FAttrNode.TextContent)) = 0)) or
                        (assigned(FAttrNode2) and (length(trim(FAttrNode2.TextContent)) = 0));
                      if FStrcFailure then
                        exit;

                      // ----------------------------------------------
                      // kirjutame baasi
                      // ----------------------------------------------

                      with admTempQuery, SQL do
                      begin

                        Close;
                        Clear;
                        add(estbk_sqlcollection._SQLInsertNewClassificator);
                        paramByname('type_').AsString := trim(FAttrName);
                        paramByname('name').AsString := trim(utf8encode(FChildNode2.TextContent));

                        if assigned(FAttrNode) then
                          paramByname('shortidef').AsString := trim(utf8encode(FAttrNode.TextContent))
                        else
                          paramByname('shortidef').AsString := '';
                        // ---

                        if assigned(FAttrNode2) then
                          paramByname('value').AsString := trim(utf8encode(FAttrNode2.TextContent))
                        else
                          paramByname('value').AsString := '';
                        paramByname('weight').AsInteger := 0;
                        execSQL;
                      end;

                      // ----------
                    end; {else
                                begin
                                  FStrcFailure:=true;
                                  exit;
                                end;}

                    FChildNode2 := FChildNode2.nextSibling;
                    // ---
                  end;
                end;

                //  ===============================================================
                // ---
                FChildNode := FChildNode.NextSibling;
              end;
              // --------
            end;
        end;
      end;
      // ---
    end;



    // kõik korras...
    Result := True;

  finally
    if assigned(FConfDoc) then
      FreeAndNil(FConfDoc);

    admTempQuery.paramCheck := FOrigPchkStatus;

    if FStrcFailure then
      raise Exception.Create(estbk_strmsg.SEConfFileNotValid);
  end;
end;


//  ------------------------------------------------------
// LAEME andmed baasi
// TODO: üldiselt conf muutujad käibemaks ja muud spetsiifilised andmed võtame failist;
procedure TadmDatamodule.insertAllPreDefConfVars;
var
  i: estbk_permissions.TPermIdentType;
  j: estbk_types.TCNumeratorTypes;
begin
  with admTempQuery, SQL do
    try
      paramCheck := True;


      // kirjutame hardcoded õigused baasi !!!   popp sõna õiguste maatriksi..neo oled see sina...
      for i := low(TPermIdentType) to high(TPermIdentType) do
      begin
        Close;
        Clear;
        add(estbk_sqlcollection._SQLInsertNewPermission);
        paramByname('system_alias').AsString := estbk_permissions.TPermDescrShortTerms[i];
        paramByname('description').AsString := estbk_permissions.TPermDescrLongTerms[i];
        paramByname('type_').AsString := '';
        execSQL;
      end;

      // kirjutame baasi vaikenumeraatorid
      for j := low(TNumeratorTypesSDescr) to high(TNumeratorTypesSDescr) do
      begin
        Close;
        Clear;
        add(estbk_sqlcollection._SQLInsertNumerators);
        paramByName('cr_num_val').AsInteger := 0;
        paramByName('cr_num_start').AsInteger := 1;
        paramByName('cr_num_type').AsString := estbk_types.TNumeratorTypesSDescr[j];
        paramByName('cr_vrange_start').AsInteger := 0;
        paramByName('cr_vrange_end').AsInteger := 0;
        paramByName('cr_version').AsInteger := 1;
        paramByName('company_id').AsInteger := 0; // vaikeseaded !!!!
        execSQL;
      end;


      // -------
      // kirjutame tabelisse ära schema versiooni;
      Close;
      Clear;
      add(estbk_sqlcollection._SQLInsertNewConfValueSimple);
      paramByname('var_name').AsString := estbk_types.CSchemaVer;
      paramByname('var_val').AsString := '';
      paramByname('var_misc').AsInteger := estbk_types.CCurrentDatabaseSchemaId;
      //paramByname('user_id').asInteger:=0;
      execSQL;


      // ------
      // viimase õiguse ID kirjuta tabelisse, hiljem lihtsam vaadata, mida vaja juurde lisada uuendustega, mida mitte
      Close;
      Clear;
      add(estbk_sqlcollection._SQLInsertNewConfValueSimple);
      paramByname('var_name').AsString := estbk_types.CSchemaLastPerm;
      paramByname('var_val').AsString := '';
      paramByname('var_misc').AsInteger := Ord(high(TPermIdentType));
      //paramByname('user_id').asInteger:=0;
      execSQL;




      // Postgres pole dualit !!!!
      // 26.03.2010 Ingmar
      // --
      // -- süsteemne tüüp, et ZEOS'ga booleani osa korda saada
      Close;
      Clear;
      add('insert into __int_systemtypes(bbool,int4,bint)');
      add('values(''f'',0,0)');
      execSQL;

      Close;
      Clear;
      add('insert into __int_systemtypes(bbool,int4,bint)');
      add('values(''t'',1,1)');
      execSQL;




      // kasutaja nr üks !!!! ADMIN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      Close;
      Clear;
      add(estbk_sqlcollection._SQLInsertDummyAdminRec);
      execSQL;


      // ------------------------------------------------------
      // laeme failist ka eeldefineeritud andmed
      // ------------------------------------------------------
      // http://www.iso.org/iso/currency_codes_list-1

      if not self.insertPreDefValsFromConfFile then
        raise Exception.Create(estbk_strmsg.SEConfFileIsInvalid);




    finally
      Close;
      Clear;
    end;
  // ---------
end;

// TODO: yldiselt anna vöimalus, et saab valida collationiks C; ini failis saaks override teha
function TadmDatamodule.pgCollation(const pTempl0Collation: AStr): AStr;
var
  pMarker: integer;
begin
  // result:='C';
  Result := '';
  if (estbk_dbcompability.sqlp.currentBackEnd = __postGre) then
  begin
    Result := trim(pTempl0Collation);
    // linuxiga ei tööta !
    if Result = '' then
      Result := ' C '; // soovitav collation !
    pMarker := pos(',', Result);
    if pMarker = 0 then
      pMarker := pos('.', Result);
    // ---
    // või Linuxil en_US.UTF-8
    if pMarker > 0 then
    begin
      Result := copy(Result, 1, pMarker - 1);
      // http://webcache.googleusercontent.com/search?q=cache:5dtlZgDsuNMJ:www.postgresql.org/docs/8.3/static/multibyte.html+&cd=1&hl=et&ct=clnk&gl=ee
      // et_EE puhul nõuab LC_TYPE latin1 kodeeringut !!!
      // 26.03.2013 Ingmar; Linux server
      // if (ansiuppercase(result)='ET_EE') then
      // result:='LATIN1';
      // result:='LATIN9';
    end
    else
      Result := pTempl0Collation;
  end;
end;

procedure TadmDatamodule.addFncTriggers(const pCreateTriggers: boolean = True);
var
  pParamCheck: boolean;
begin
  with admTempQuery, SQL do
    try
      pParamCheck := ParamCheck;
      ParamCheck := False;

      if (estbk_dbcompability.sqlp.currentBackEnd = __postGre) then
      begin
        // --  http://onlamp.com/pub/a/onlamp/2006/05/11/postgresql-plpgsql.html
        Close;
        Clear;
        add('SELECT 1 as lang FROM pg_catalog.pg_language WHERE lanname = ''plpgsql''');
        Open;

        if FieldByName('lang').AsInteger <> 1 then
        begin
          Close;
          Clear;
          // add('createlang plpgsql '+estbk_types.CProjectDatabaseNameDef+';');
          add('CREATE LANGUAGE plpgsql;');
          execSQL;
        end;



        Close;
        Clear;
        add('CREATE OR REPLACE FUNCTION art_amount_mgr()');
        add('RETURNS trigger AS');
        add('$BODY$');
        add('declare');
        add('  sumdelta  numeric(19,4);');
        add('  currtotal numeric(19,4);');
        add('  pitemId integer;');
        add('BEGIN');
        add('     sumdelta:=0;');
        add('IF  (TG_OP=''UPDATE'') THEN');
              {
              add('SELECT INTO sumdelta quantity');
              add('FROM inventory_documents');
              add('WHERE id = OLD.id;');
              add('pitemId:=OLD.inventory_id;');
              add('');
              add('IF NOT(FOUND) THEN');
              add('RAISE EXCEPTION ''ERR:-1'';');
              add('RETURN NULL;');
              add('END IF;');

              add('sumdelta:=sumdelta-OLD.quantity;');
              }

        add('IF (NEW.quantity<>OLD.quantity) THEN');
        add(' IF (NEW.quantity>0) THEN');
        add('     sumdelta:=-(OLD.quantity-NEW.quantity);');
        add(' ELSE');
        add('     sumdelta:=NEW.quantity;');
        add(' END IF;');
        add('END IF;');


        add('ELSEIF (TG_OP=''INSERT'') THEN');
        add('pitemId:=NEW.inventory_id;');
        add('sumdelta:=NEW.quantity;');
        add('END IF;');

        add('SELECT INTO currtotal current_quantity');
        add('FROM inventory WHERE id= NEW.inventory_id;');

        add('IF NOT(FOUND) THEN');
        add('RAISE EXCEPTION ''ERR:-1'';');
        add('RETURN NULL;');
        add('END IF;');

        add('currtotal:=currtotal+sumdelta;');
        add('IF (currtotal<0) THEN');
        add('RAISE EXCEPTION ''ERR:1'';');
        add('RETURN NULL;');
        add('END IF;');

        add('IF (sumdelta=0) THEN');
        add('RETURN NEW;');
        add('END IF;');

        add('UPDATE inventory');
        add('SET current_quantity=currtotal');
        add('WHERE  id=pitemId;');

        add('RETURN NEW;');
        add('END;');

        add('$BODY$ LANGUAGE plpgsql;');

        //add('LANGUAGE ''plpgsql'' VOLATILE');
        //add('COST 100;');
        //add('ALTER FUNCTION art_amount_mgr() OWNER TO postgres;');
        // ---
        execSQL;



        // teisel juhul lihtsalt uuendatakse funktsioonide definitsioone; ntx upgrade !
        if pCreateTriggers then
        begin
          Close;
          Clear;
          add('CREATE TRIGGER art_amount_mgr_trg_i AFTER INSERT'); // BEFORE
          add('ON inventory_documents  FOR  EACH ROW');
          add('EXECUTE PROCEDURE  art_amount_mgr()');
          execSQL;


          Close;
          Clear;
          add('CREATE TRIGGER art_amount_mgr_trg_u BEFORE UPDATE');  // AFTER
          add('ON inventory_documents  FOR  EACH ROW');
          add('EXECUTE PROCEDURE  art_amount_mgr()');
          execSQL;
        end; // ---



        // 30.03.2011 Ingmar; mis point ise neid arve staatusi leiutada ! Trigger on selleks !
        Close;
        Clear;
        add('CREATE OR REPLACE FUNCTION bill_payment_status()');
        add('RETURNS trigger AS');
        add('$BODY$');
        add(' declare ');
        add(' topay  numeric(19,4);');
        add(' paid numeric(19,4);');
        add('BEGIN');
        add('      topay:=0;');
        add('      paid:=0;');
        add(' IF  (TG_OP=''UPDATE'') THEN');
        add('      topay:=NEW.totalsum+NEW.roundsum+NEW.vatsum+NEW.fine;');
        add('      paid:=NEW.incomesum+NEW.prepaidsum+NEW.uprepaidsum+NEW.crprepaidsum;');

              {
              // 02.08.2011 Ingmar; juhtus selline viga, et kui arve oli negatiivne ja uuendati, siis trigger pani rõõmsalt tasutud...
              // SEST paid>=-7.82 !!!!
              add('      IF ((paid>0.00) AND (paid>=topay)) THEN');
              add('          NEW.payment_status:=''R'';');
              add('      ELSEIF ((paid>0.00) AND (paid<topay)) THEN');
              add('          NEW.payment_status:=''P'';');
              add('      ELSE');
              add('          NEW.payment_status:='''';');
              add('      END IF;');
              }

        // 30.08.2011 Ingmar
        add('      IF ((paid<>0.00) AND (paid-topay>=0.00)) THEN');
        add('           NEW.payment_status:=''R'';');
        add('      ELSEIF (paid<>0.00)  THEN');
        add('          NEW.payment_status:=''P'';');
        add('      ELSE');
        add('          NEW.payment_status:='''';');
        add('      END IF;');

        add(' END IF;');
        // ---
        add('      RETURN NEW;');
        add('END;');
        add('$BODY$ LANGUAGE plpgsql;');
        // ---
        execSQL;

        if pCreateTriggers then
        begin
          Close;
          Clear;
          add('CREATE TRIGGER bill_payment_status_u');
          add('BEFORE UPDATE');
          add('ON bills  FOR EACH ROW');
          add('EXECUTE PROCEDURE bill_payment_status()');
          execSQL;
        end; // ---


        Close;
        Clear;
        add('CREATE OR REPLACE FUNCTION order_payment_status()');
        add('RETURNS trigger AS');
        add('$BODY$');

        add('declare');
        add('  topay  numeric(19,4);');
        add('  paid numeric(19,4);');
        add('  BEGIN');
        add('    topay:=0;');
        add('    paid:=0;');
        add('    IF  (TG_OP=''UPDATE'') THEN');
        add('          topay:=NEW.order_sum+NEW.order_roundsum+NEW.order_vatsum;');
        add('          paid:=NEW.paid_sum;');
        add('      IF (paid>=topay) THEN');
        add('          NEW.payment_status:=''R'';');
        add('      ELSEIF ((paid>0.00) AND (paid<topay)) THEN');
        add('          NEW.payment_status:=''P'';');
        add('      ELSE');
        add('          NEW.payment_status:='''';');
        add('      END IF;');
        add('    END IF;');
        add('    RETURN NEW;');

        add('END;');
        add('$BODY$ LANGUAGE plpgsql;');
        // ---
        execSQL;

        if pCreateTriggers then
        begin
          Close;
          Clear;
          add('CREATE TRIGGER order_payment_status_u');
          add('BEFORE UPDATE');
          add('ON orders  FOR EACH ROW');
          add('EXECUTE PROCEDURE order_payment_status()');
          execSQL;
        end;

        // @@@ 23.04.2012 Ingmar
        Close;
        Clear;
        add('CREATE OR REPLACE FUNCTION acc_uniq_nrv_fnc()');
        add('RETURNS TRIGGER');
        add('AS');
        add('$acc_uniq_nr$');
        add('DECLARE');
        add(' acc_rid int4;');
        add(' acc_descr varchar(255);');
        add(' acc_entrynr varchar(20);');
        add('BEGIN');
        add('IF (TG_OP=''INSERT'')  THEN');
        add('    SELECT a.id,a.transdescr,a.entrynumber');
        add('    INTO acc_rid,acc_descr,acc_entrynr');
        add('    FROM');
        add('     (SELECT a.id,a.transdescr,a.entrynumber');
        add('      FROM accounting_register a');
        add('      WHERE a.company_id=NEW.company_id');
        add('        AND a.entrynumber=NEW.entrynumber');
        add('        AND a.type_<>''R'''); // 11.05.2012 Ingmar; kassaga see jama, et ma anname sama tüübi mõlemale kirjele !
        add('        AND a.type_=NEW.type_');
        add('        AND a.accounting_period_id=NEW.accounting_period_id');
        add('        AND a.template=''f''');
        add('        AND a.rec_deleted=''f''');
        add('     UNION');
        add('     SELECT a.id,a.transdescr,a.entrynumber');
        add('     FROM accounting_register a');
        add('     WHERE a.company_id=NEW.company_id');
        add('        AND a.entrynumber=NEW.entrynumber');
        add('        AND a.type_=''R'''); // võtame kassa kirjed ja üritame kirjelduse esimese tähe järgi kindlaks teha, mis probleem on
        add('        AND COALESCE(SUBSTRING (a.transdescr,1,1),'''')=COALESCE(SUBSTRING (NEW.transdescr,1,1),'''')');
        add('        AND a.type_=NEW.type_');
        add('        AND a.accounting_period_id=NEW.accounting_period_id');
        add('        AND a.template=''f''');
        add('        AND a.rec_deleted=''f'') as a;');
        add('     IF FOUND THEN');
        add('        RAISE EXCEPTION ''Sama numbriga kanne on juba olemas % [%]'',acc_entrynr,acc_descr;');
        add('    return NULL;');
        add('ELSE');
        add('    return NEW;');
        add('END IF;');
        add('ELSEIF ((TG_OP=''UPDATE'') AND ((NEW.entrynumber<>OLD.entrynumber) OR (NEW.accounting_period_id<>OLD.accounting_period_id)))  THEN');
        add('    SELECT a.id,a.transdescr,a.entrynumber');
        add('    INTO acc_rid,acc_descr,acc_entrynr');
        add('    FROM(');
        add('    SELECT a.id,a.transdescr,a.entrynumber');
        add('    FROM accounting_register a');
        add('    WHERE a.company_id=NEW.company_id');
        add('       AND a.entrynumber=NEW.entrynumber');
        add('       AND a.type_<>''R''');
        add('       AND a.type_=NEW.type_');
        add('       AND a.accounting_period_id=NEW.accounting_period_id');
        add('       AND a.template=''f''');
        add('       AND a.rec_deleted=''f''');
        add('       AND a.id<>OLD.id');
        add('    UNION');
        add('    SELECT a.id,a.transdescr,a.entrynumber');
        add('    FROM accounting_register a');
        add('    WHERE a.company_id=NEW.company_id');
        add('       AND a.entrynumber=NEW.entrynumber');
        add('       AND a.type_=''R''');
        // 11.05.2012 Ingmar; NB see omamoodi häkk, aga võimaldab kiiresti tuvastada kassa laekumise tüübi; PS kompatiiblus kaob !!!
        add('       AND COALESCE(SUBSTRING (a.transdescr,1,1),'''')=COALESCE(SUBSTRING (NEW.transdescr,1,1),'''')');
        add('       AND a.type_=NEW.type_');
        add('       AND a.accounting_period_id=NEW.accounting_period_id');
        add('       AND a.template=''f''');
        add('       AND a.rec_deleted=''f''');
        add('       AND a.id<>OLD.id');
        add('    ) as a;');
        add('    IF FOUND THEN');
        add('    RAISE EXCEPTION ''Sama numbriga kanne on juba olemas % [%]'',acc_entrynr,acc_descr;');
        add('    return NULL;');
        add('ELSE');
        add('    return NEW;');
        add('END IF;');
        add('END IF;');
        add('    return NEW;');
        add('END;');
        add('$acc_uniq_nr$ LANGUAGE plpgsql;');
        // ---
        execSQL;



        if pCreateTriggers then
        begin
          Close;
          Clear;
          add('CREATE TRIGGER acc_uniq_nr_trig');
          add('BEFORE INSERT OR UPDATE ON accounting_register');
          add('FOR EACH ROW EXECUTE PROCEDURE acc_uniq_nrv_fnc();');
          execSQL;
          // löön kaheks triggerid 24.04.2012 Ingmar
              {
              close;
              clear;
              add('CREATE TRIGGER acc_uniq_nr_trig_ins');
              add('BEFORE INSERT');
              add('ON accounting_register');
              add('FOR EACH ROW');
              add('EXECUTE PROCEDURE acc_uniq_nrv_fnc();');
              execSQL;

              close;
              clear;
              add('CREATE TRIGGER acc_uniq_nr_trig_upt');
              add('AFTER UPDATE');
              add('ON accounting_register');
              add('FOR EACH ROW');
              add('EXECUTE PROCEDURE acc_uniq_nrv_fnc();');
              execSQL;}
        end;

      end; // POSTGRE TRIGERID !!!!



    finally
      Close;
      Clear;

      ParamCheck := pParamCheck;
    end; // ---
end;

procedure TadmDatamodule.addSeqTriggers;
begin
  // --
end;

// 02.10.2017 Ingmar
procedure TadmDatamodule.assignRolePermissions(var AErrors: AStr);
var
  ptbl: estbk_dbcompability.TCTablenames;
  permSql: string;
begin
  // aga publicut rollile ei luba !!!
  {
    close;
    clear;
    add(format(CSQLRemAllPermFromPublic,[CProjectRolename]));
    execSQL;
  }
  AErrors := '';
  // teoorias saaksime teha ühe suure selectina, elu näidanud, et kui N db backendi, siis parem asju ükshaaval teha
  for ptbl := low(TCTablenames) to high(TCTablenames) do
    try
      permSql := '';
      case ptbl of
        // neid tabeleid saab kasutaja AINULT lugeda
        __sccompany,
        __scuser_permission_descr,
        __scuser_permissions,
        __scrole,
        __scrole_permissions,
        __scrole_userroles,
        __scuser_company_acclist,
        __scVAT,
        //__scbanks,
        __scsystemconf:
          permSql := format(CSQLGrantPermission, [CSQLSelect, estbk_dbcompability.CTable_names[ptbl], CProjectRolename]);
        __sclocked_objects,
        __scnumeratorcache: // 10.05.2011 Ingmar
          permSql := format(CSQLGrantPermission, [CSQLSelect + ',' + CSQLUpdate + ',' + CSQLInsert + ',' + CSQLDelete,
            estbk_dbcompability.CTable_names[ptbl], CProjectRolename]);

        // select ja väike update
        __scusers:
          permSql := format(CSQLGrantPermission, [CSQLSelect + ',' + CSQLUpdate, estbk_dbcompability.CTable_names[ptbl], CProjectRolename]);
        else
          permSql := format(CSQLGrantPermission, [CSQLSelect + ',' + CSQLUpdate + ',' + CSQLInsert,
            estbk_dbcompability.CTable_names[ptbl], CProjectRolename]);
      end;

      admTempQuery.Close;
      admTempQuery.sql.Clear;
      admTempQuery.sql.add(permSql);
      admTempQuery.execSQL;

    except
      on E: Exception do
        AErrors := AErrors + #13#10 + E.Message;
    end;
end;

function TadmDatamodule.validateTables(const autoCreate: boolean; var emsg: AStr; var template0Collation: AStr; const eparam: boolean): boolean;
  // ALTER TABLE public.chg OWNER TO postgres;

var
  i: integer;
  pChkProgress: Tform_progress;
  pItemList: TAStrList;
  pTmpBfrList: TAStrList; // uuendamisel vajalik
  pUserIsAdmin: boolean;

  pEstBkTables: estbk_dbcompability.TCTablenames;
  pEstBkTableDefs: estbk_lib_databaseschema.TEstbk_databaseschema;
  pTmpRez, permSql, emsg2: AStr;
  pDatabaseCreated: boolean; // kas just tegime ka uue andmebaasi...
  pt: TStringList;
begin
  template0Collation := '';
  try
    // 30.08.2009 Ingmar; firebird sisuliselt teeb kõik transaktsioonide sees ntx. isegi tavaline select !
    self.admConnection.StartTransaction;
    try
      Result := False;
      pDatabaseCreated := False;
      emsg := '';
      pEstBkTableDefs := nil;
      //pChkProgress:=Tform_progress.create(nil,SCValidatingTables,0,ord(estbk_dbcompability.__endmarker),false);
      pChkProgress := Tform_progress.Create(nil, Ord(low(estbk_dbcompability.TCTablenames)), Ord(high(estbk_dbcompability.TCTablenames)), False);
      pChkProgress.statusBarText := SCValidatingTables;


      pItemList := TAStrList.Create;
      pTmpBfrList := TAStrList.Create;

      // ...siis vajame täielikke definitsioone...
      if autoCreate then
        pEstBkTableDefs := estbk_lib_databaseschema.TEstbk_databaseschema.Create(estbk_dbcompability.sqlp.currentBackEnd);


      // --
      pUserIsAdmin := False;
      admTempQuery.ParamCheck := False;
      // --- progress UI..tegelikkuses seda kuvame ainult tabelite puhul..progressi siis
      pChkProgress.Show;

      // kas kasutaja admin
      with admTempQuery, SQL do
      begin
        Close;
        Clear;
        pTmpRez := estbk_dbcompability.sqlp._isUserAdminSQL;
        add(pTmpRez);
        Open;

        pUserIsAdmin := not EOF and isTrueVal(admTempQuery.fields.fieldbynumber(1).AsString);
        // ...kui pole adminn, siis pole ka midagi siin teha...head päeva...
        //if  autoCreate and not pUserIsAdmin then
        if not pUserIsAdmin then
        begin
          emsg := SENoRightsToCreateDbObj;
          Exit;
        end;
      end;

      // --- loetleme baasid...
      with admTempQuery, SQL do
      begin
        // template0Collation:=estbk_types.CPostRequiredCollationAndCType;
        // siin tuleks läbi versiooni string kontrollida, kumb on kumb
        template0Collation := 'C';
        Close;
        Clear;
        pTmpRez := estbk_dbcompability.sqlp._getDatabaseNamesSQL;
        add(pTmpRez);
        Open;

        while not EOF do
        begin
          // vaatame, millist collationi toetatakse
          if (estbk_dbcompability.sqlp.currentBackEnd = __postGre) and
            (pos('template0', ansilowercase(admTempQuery.FieldByName('databasename').AsString)) > 0) then
            template0Collation := admTempQuery.FieldByName('datcollate').AsString;
          pItemList.add(admTempQuery.FieldByName('databasename').AsString); // ..võiks ju kohe exceptioni tõstatada...aga saab ka rahulikumalt
          Next;
          // ---
        end;

        // 26.03.2013 Ingmar; muidu ei saanud linuxis baasi loodud automaatselt; silveri näide
        // template0Collation:=stringreplace(template0Collation,'et_EE.UTF-8','et_EE',[]);
        //  ..andmebaasi pole loodud...
        if pItemList.indexof(__dbNameOverride(CProjectDatabaseNameDef)) = -1 then
        begin

          if not autoCreate then
          begin
            emsg := format(SEDatabaseNotCreated, [__dbNameOverride(CProjectDatabaseNameDef)]);
            Exit;
          end
          else
            // ...loome puuduva baasikese...juhul, kui me muidugit adminn
          begin
            Close;
            Clear;
            // 02.09.2009 Ingmar
            // --- ehk siis ei soovita süsteemset collationi kasutada, tahtlik tegevus, eks admin ise teab, mida teeeb
            if eparam and (estbk_dbcompability.sqlp.currentBackEnd = __postGre) then
            begin
              // Linux tarbeks tuleb ikkagit default collation valida ! en_US.UTF-8
              pTmpRez := estbk_dbcompability.sqlp._create_databaseSQL(__dbNameOverride(estbk_types.CProjectDatabaseNameDef),
                self.pgCollation(template0Collation)) + ' TEMPLATE template0 ';
            end
            else
              pTmpRez := estbk_dbcompability.sqlp._create_databaseSQL;

            // 26.03.2013 Ingmar
            // -- häkk linuxi toetamiseks; linuxi puhul ei aita automaatsed tuvastused ja scriptid, paneme hardcoded koodi
            if (AnsiUpperCase(self.pgCollation(template0Collation)) = 'ET_EE') then
              pTmpRez :=
                'CREATE DATABASE estbk WITH TEMPLATE=template0 LC_COLLATE=''et_EE.UTF-8'' LC_CTYPE=''et_EE.UTF-8'' OWNER="postgres" ENCODING=''UNICODE''';

            Add(pTmpRez);
            execSQL;
            pDatabaseCreated := True;
          end;
        end;
        // --- väga rumal, et andmebaasi saaks seadistada peame uuesti andmebaasiga ühenduma...ohjah
        admConnection.Disconnect;
        //..paneme paika meie DEFAULT andmebaasi !!!!
        admConnection.Database := __dbNameOverride(CProjectDatabaseNameDef);
        admConnection.Connect; // --

        // 02.04.2015 Ingmar
        if FindCmdLineSwitch('fix', ['-', '/'], True) then
          FixTables();

        // ----------
        pItemList.Clear;
        Close;
        Clear;
        pTmpRez := estbk_dbcompability.sqlp._getAllTablesSQL;
        Add(pTmpRez);
        Open;
        while not EOF do
        begin
          pItemList.add(FieldByName('tablename').AsString);
          Next;
        end;


        // teeme valmis ROLLI !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if pDatabaseCreated then
          with admTempQuery, SQL do
          begin
            Close;
            Clear;
            add(format(_CSQLCreateRole, [CProjectRolename]));
            execSQL;
          end;

        for pEstBkTables := low(estbk_dbcompability.TCTablenames) to high(estbk_dbcompability.TCTablenames) do
        begin
          pChkProgress.doStepping(Ord(pEstBkTables));
          application.ProcessMessages;
          // ----
          sleep(10);

          if estbk_dbcompability.CTable_names[pEstBkTables] = '' then // endmarker/või hetkel defineerimata schema !
            Continue;

          if pItemList.indexOf(estbk_dbcompability.CTable_names[pEstBkTables]) = -1 then
          begin
            // ...antud juhul nägemist...
            if not autoCreate then
            begin
              emsg := format(SESomeTablesAreMissing, [estbk_dbcompability.CTable_names[pEstBkTables]]);
              Exit;
            end
            else

              // ------------------------------------------------------------
              // ...üks suur tabelite loomine käib...schemad tulevad failist estbk_tables
              // ------------------------------------------------------------

              with admTempQuery, SQL do
                if Length(pEstBkTableDefs.TableDefs[pEstBkTables]) > 0 then // ...testi ajal on ka defineerimata tabeleid !
                begin
                  // SEQUENCE
                  // ...tabelile ka autonumber...kellel sequence, kellel identity...jne...
                  Close;
                  Clear;
                  pTmpRez := pEstBkTableDefs.__createAutonumberSQL(pEstBkTables);
                  add(pTmpRez);
                  // ..siin peidame vea, kuna seq võib tõesti eksisteerida !!!
                  if length(pTmpRez) > 0 then
                    try
                      execSQL;

                      // kuna estbk_role on suht piiratud õigustega kasutaja, siis peame ka seq objektile õigused andma
                      if pDatabaseCreated then
                      begin
                        Close;
                        Clear;
                        pTmpRez := CTable_names[pEstBkTables] + '_id_seq';
                        add(format(estbk_sqlcollection.CSQLGrantPermission, [' SELECT, UPDATE ', ' SEQUENCE ' +
                          pTmpRez, estbk_types.CProjectRolename]));


                        execSQL;
                      end; // ---
                    except
                    end;

                  // SEQUENCE TRIGGER; ntx Firebirdis
                  Close;
                  Clear;
                  pTmpRez := pEstBkTableDefs.__createSeqTriggerSQL(pEstBkTables);
                  add(pTmpRez);
                  // Siin peidame vea, kuna seq võib tõesti eksisteerida !!!
                  if length(pTmpRez) > 0 then
                    try
                      execSQL;
                    except
                    end;

                  // TABELID
                  Close;
                  Clear;
                  pTmpRez := pEstBkTableDefs.TableDefs[pEstBkTables];
                  add(pTmpRez); // loeme klassist välja tabeli tervik definitsiooni
                  execSQL;

                  // INDEKSID
                  pEstBkTableDefs.__generateIndexSQL(pEstBkTables, pTmpBfrList);
                  for i := 0 to pTmpBfrList.Count - 1 do
                    if length(pTmpBfrList.Strings[i]) > 0 then
                    begin
                      Close;
                      Clear;
                      add(pTmpBfrList.Strings[i]);
                      execSQL;
                    end;
                end; // Length(pEstBkTableDefs.TableDefs[pEstBkTables])> 0
          end; // pItemList.indexOf(estbk_dbcompability.CTable_names[pEstBkTables]) = -1
        end; // for pEstBkTables:=low(estbk_dbcompability.TCTablenames) to high(estbk_dbcompability.TCTablenames) do
      end; // with admTempQuery,SQL do


      // --- vaikeseaded ka paika default konf muutuja; õigused jne
      // andmebaas olemas nüüd paneme kõik itemid paika
      // --------------------------------
      // just loodi andmebaas !!!!
      // me ise otsustame, et public on liialt avar õigus vaid ise hakkame andma; võtame publicult kõik privileegid ära

      if pDatabaseCreated then
      begin
        emsg2 := '';
        assignRolePermissions(emsg2);
        if emsg2 <> '' then
          messageDlg(emsg2, mtError, [mbOK], 0);


        // aga publicut rollile ei luba !!!
        {
        close;
        clear;
        add(format(CSQLRemAllPermFromPublic,[CProjectRolename]));
        execSQL;
        }

        // --- üldse rolli ohutu seadistamine !!!!
        // eelseaded publicule paika !!!
        FreeAndNil(pTmpBfrList); // taaskasutus...mõtleme muutujate suhtes roheliselt...
        // loob uue instansi !!!
        pTmpBfrList := estbk_sqlcollection._CSQLDbPrePublicRevokes;

        // elu õpetanud seda, et täida kõik SQL käsud eraldi, mis siis, et ; ntx lubab mitut batchi
        // muudab db layerit jne jne. see enam ei toimu
        if assigned(pTmpBfrList) then
          with admTempQuery, SQL do
            for i := 0 to pTmpBfrList.Count - 1 do
            begin
              Close;
              Clear;
              add(pTmpBfrList.Strings[i]);
              execSQL;
            end;

        // -------------------------------------------------------
        // VIEW
        // viimaseks üks väga tähtis..õiguste view
        // -------------------------------------------------------

        with admTempQuery, SQL do
        begin
          // õiguste view
          Close;
          Clear;
          add(estbk_sqlcollection._SQLCreatePermView);
          execSQL;


          // SELECT õigused ka !
          Close;
          Clear;
          add(format(CSQLGrantPermission, [CSQLSelect, 'v_permissions', CProjectRolename]));
          execSQL;


          // kontode algsaldode view
          Close;
          Clear;
          add(estbk_sqlcollection._SQLCreateAccInitBalanceView);
          execSQL;



          // SELECT õigused ka !
          Close;
          Clear;
          add(format(CSQLGrantPermission, [CSQLSelect, 'v_accinitbalance', CProjectRolename]));
          execSQL;
        end;

        // -----------------------------------
        // TRIGGERID paika !

        self.addFncTriggers;
        self.addSeqTriggers;

        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // ---- algseadistame ka tabelid ära; muutujad / õigused jne jne
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        self.insertAllPreDefConfVars;
      end;


      // ...himalaja tipp leitud...
      Result := True;
      self.admConnection.Commit;

    finally

      // ikka transaktsioon elus ?!? midagi viltu läinud
      if self.admConnection.inTransaction then
        try
          self.admConnection.Rollback;
        except
        end;

      if pChkProgress.Visible then
        pChkProgress.Close;

      FreeAndNil(pChkProgress);
      FreeAndNil(pItemList);
      FreeAndNil(pTmpBfrList);

      if Assigned(pEstBkTableDefs) then
        FreeAndNil(pEstBkTableDefs);

      admTempQuery.Close;
      admTempQuery.SQL.Clear;
    end;

    // ----
  except
    on e: Exception do
      emsg := IntToStr(Ord(pEstBkTables)) + ':' + e.message;
  end;
end;

initialization
  {$I estbk_datamodule.ctrs}

end.