unit estbk_lib_incomings;
// TODO SQLid paremini loetavaks koodi, Lazaruse uus versioon muutis formateeringud valeks
{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface
// viimane assert #1
uses
  Classes, SysUtils, Contnrs, Strutils, DB,
  estbk_types, estbk_strmsg, estbk_lib_rep_errorcodes, estbk_lib_commoncls, estbk_lib_commonaccprop,
  estbk_utilities, estbk_globvars, estbk_lib_erprtwriter, estbk_dbcompability, estbk_lib_bankfiledefs,
  estbk_sqlclientcollection, LCLIntf, LCLType, Controls, dateutils, LCLProc, ZDataset, ZConnection, ZSequence, Variants,
  estbk_crc32, estbk_lib_mapdatatypes, Math, Dialogs;

type
  TIncomings_base = class(TBankFileReader)
  protected
    FWorkerQry: TZQuery;
    FTempQry: TZQuery;
    FIncomeSessionSeq: TZSequence;
    //FImpFileSeq  : TZSequence;
    FReportWriter: TStatusRepWriter;
    FTempTableCreated: boolean;
    FTemptableIncomeLines: AStr;
    FTemptableIncomeItems: AStr;

    procedure createMiscLines(const pTableIncLines: AStr; const pTableIncItems: AStr);

    procedure verifyDataSQL(const pTableName: AStr);
    // üritame selgituse kaudu leida arve või tellimuse !
    procedure detectBill_OrderDataFromDescr(const pTableName: AStr);

    procedure assignIncomeNumbers(const pTableIncLines: AStr);
    procedure fillItemsTable(const pTableIncLines: AStr; const pTableIncItems: AStr);

    procedure addSavedItemsToBfrTable(const pTableIncLines: AStr; const pTableIncItems: AStr);

    procedure addClientUnpaidItemsToBfrTable(const pTableIncLines: AStr; const pTableIncItems: AStr; const pClientId: integer = -1);

    procedure processIncomeEntrys(const pBufferedData: TObjectList; const pFileName: AStr; const pMD5: AStr;
      const pBankId: integer = 0; const pBankCode: AStr = ''; const pIncomingFromFile: boolean = True); override;
    // st. et sisestatakse laekumise faili !
  public
    // misc
    property incomeLinesTempTableName: AStr read FTemptableIncomeLines; // ajutine tabel, kus sees kõik failist tulnud kirjed
    property incomeItemsTempTableName: AStr read FTemptableIncomeItems;
    function translateIntErrorCodeToMsg(const pErrCode: integer): AStr;

    // --
    function createIncomeSessionId(const pFileMode: boolean = True): integer;


    // käsitsi laekumistel puhul peame "dummy" dataseti tegema ! nagu öeldakse lööme arved/tellimused teise tabelisse
    procedure createTempIncomeTables(var pIncomeLinesTable: AStr; var pIncomeItemsTable: AStr // laekumise reaga seotud arved/tellimused
      );
    procedure dropTempIncomeDataTables(); // --

    // --- uus feat !
    function processPredefinedRecords(const pDataLines: TObjectList; const pBankId: integer; const pBankCode: AStr; var pError: Astr): boolean;
    // käsitsi sisestatud laekumised !!!

    // 20.03.2011 korras kirjetele kinnitatud staatused
    procedure markOkIncomingsAsVerified;

    // 28.12.2010 Ingmar
    procedure loadIncomings(const pId: integer; const pIdAsSessionID: boolean = True);
    procedure reUpdateCachedItems();
    procedure fetchItemPmtData(const pItemId: integer; const pItemType: integer; var pPaid: double; var pToPay: double);
    // 02.02.2011 Ingmar; selgus väline klass vajab samuti (laekumiste käsitsi sisetus) sisuliselt wrapper;
    // ehk siis antud klienti tasumata arved / tellimused sisestatakse ajutisse tabelisse
    procedure getClientUnpaidItems(const pClientID: integer; const pDeletePrvItems: boolean = False);

    // kirjutab vigaste kirjete info faili;
    procedure writeErrReport();

    // -- st kui muidu incomings_import_sessions tabelisse luuakse igakord uus kirje;
    // -- kui pFileMode = false; siis tehakse vaid üks sessiooni kirje, mille alla kogutakse kõik päeva laekumiste sisestused; st "käsitöö"
    constructor Create(const pConnection: TZConnection);
    destructor Destroy; override;
  end;

implementation

uses estbk_lib_bankfilesconverr, estbk_clientdatamodule;

const
  CItemsTemptableCommonFld = ' item_type,item_id,item_nr,client_id,payment_sum,payment_sum_conv,paid,to_pay,item_currency,' +
    ' item_currency_ovr,item_currency_ovr_idt,curr_diff,item_due_date,account_id,' +
    ' account_coding,account_currency,pguid,incoming_id,lsitemhlp,payment_sum_origfromfile';

// int -> ecode -> emsg
function TIncomings_base.translateIntErrorCodeToMsg(const pErrCode: integer): AStr;
var
  pStrCode: AStr;
begin
  Result := '';
  // -- see veakoodide ristkodeerimine täiesti tobe, tulevikus kasuta ainult inti või varchari !!!
  if (pErrCode >= Low(CIncErrTranslate)) and (pErrCode <= High(CIncErrTranslate)) then
  begin
    pStrCode := CIncErrTranslate[pErrCode];
    // küsime pika kirjelduse, mis seotud antud raportikoodiga !
    Result := estbk_lib_rep_errorcodes.fndReportCodeLongDescr(pStrCode);
  end;
end;

//procedure TIncomings_base.writeErrReport(const pTempTableName: AStr);
procedure TIncomings_base.writeErrReport();
var
  pTempErrCode: integer;
begin
  if self.FTemptableIncomeLines = '' then
    exit;

  // tõlgime veakoodid ümber
  with self.FWorkerQry, SQL do
    try
      Close;
      Clear;
      add(format('SELECT * FROM %s WHERE errorcode<>%d ORDER BY errorcode DESC', [self.FTemptableIncomeLines, CDataOK]));
      Open;
      First;


      while not EOF do
      begin
        pTempErrCode := FieldByName('errorcode').AsInteger;
        assert(((pTempErrCode >= low(CIncErrTranslate)) and (pTempErrCode <= high(CIncErrTranslate))), '#1');
        self.internalLogWrite(CIncErrTranslate[pTempErrCode], '', FieldByName('line_nr').AsInteger, '', 0);
        // ---
        Next;
      end; // ---
    finally
      Close;
      Clear;
    end;
end;

// TODO; viia regexp peale !!!!
procedure TIncomings_base.detectBill_OrderDataFromDescr(const pTableName: AStr);
var
  // tuvastame kirjelduse järgi, mida makstakse !
  pDescr: AStr;
  pBillNr: AStr;
  pBuildBillSrcPhList: TADynStrArray;
  pBuildOrderSrcPhList: TADynStrArray;

  pOrdNr: AStr;

begin
  with self.FWorkerQry, SQL do
    try
      Close;
      Clear;
      add('SELECT *');
      add(format('FROM %s', [pTableName]));
      add(format('WHERE errorcode=%d', [CDataOK]));
      add('  AND COALESCE(item_id,0)=0');
      Open;

      First;

      // --
      pBuildBillSrcPhList := estbk_utilities.conv_strToStrDynArray(estbk_globvars.glob_inc_billSrcPhrases);
      pBuildOrderSrcPhList := estbk_utilities.conv_strToStrDynArray(estbk_globvars.glob_inc_orderSrcPhrases);


      // ----------
      FTempQry.SQL.Add(format('UPDATE %s SET data=:data,item_type=:item_type WHERE recnr=:recnr', [pTableName]));
      // ----------


      while not EOF do
      begin
        pDescr := FieldByName('description').AsString;


        // proovime esmalt leida arve nr.
        estbk_utilities.extractDescr(pDescr, pBuildBillSrcPhList, pBillNr);
        pBillNr := trim(pBillNr);

        // üritame leida ehk on tellimus
        if pBillNr = '' then
          estbk_utilities.extractDescr(pDescr, pBuildOrderSrcPhList, pOrdNr);
        pOrdNr := trim(pOrdNr);

        // ---
        if pBillNr <> '' then
        begin
          FTempQry.ParamByName('item_type').AsInteger := CResolvedDataType_asBill;
          FTempQry.ParamByName('data').AsString := pBillNr;
        end
        else
        if pOrdNr <> '' then
        begin
          FTempQry.ParamByName('item_type').AsInteger := CResolvedDataType_asOrder;
          FTempQry.ParamByName('data').AsString := pOrdNr;
        end
        else
        begin
          FTempQry.ParamByName('item_type').AsInteger := -1;
          FTempQry.ParamByName('data').AsString := '';
        end;

        FTempQry.ParamByName('recnr').AsInteger := FieldByName('recnr').AsInteger;
        FTempQry.ExecSQL;
        // ---
        Next;
      end;


    finally
      FWorkerQry.Close;
      FWorkerQry.SQL.Clear;
      // --
      FTempQry.Close;
      FTempQry.SQL.Clear;
    end;
end;


procedure TIncomings_base.createMiscLines(const pTableIncLines: AStr; const pTableIncItems: AStr);
begin
  with self.FWorkerQry, SQL do
  begin
    Close;
    Clear;
    add(format('INSERT INTO %s', [pTableIncItems]));
    add('(item_type,item_currency,item_currency_ovr,item_currency_ovr_idt,curr_diff,payment_sum,payment_sum_conv,');
    add(' pguid,account_id,account_coding,account_currency,item_nr)');
    add('SELECT :item_type,:item_currency,:item_currency_ovr,:item_currency_ovr_idt,');
    add(':curr_diff,:payment_sum,:payment_sum_conv,s.pguid,a.id,a.account_coding,a.default_currency,a.account_name');

    add(format('FROM %s s', [pTableIncLines]));
    add('LEFT OUTER JOIN accounts a ON ');
    add('a.id=:default_acc_id');
    add('WHERE NOT EXISTS');
    add('(');
    add(format('  SELECT p.* FROM %s p WHERE p.pguid=s.pguid', [pTableIncItems]));
    add(')');

    // informatiivne osa !
    // fieldbyname('item_nr').AsString:=estbk_strmsg.SCIncInforLine;
    // fieldbyname('client_id').AsInteger:=pClient;
    paramByname('item_type').AsInteger := estbk_lib_bankfiledefs.CResolvedDataType_asMisc;
    paramByname('item_currency').AsString := estbk_globvars.glob_baseCurrency;
    paramByname('item_currency_ovr').AsFloat := 1.000;
    paramByname('item_currency_ovr_idt').AsFloat := 1.000;
    paramByname('curr_diff').AsFloat := 0;
    paramByname('payment_sum').AsFloat := 0;
    paramByname('payment_sum_conv').AsFloat := 0;
    //paramByname('pguid').AsString:=pGuid;
    paramByname('default_acc_id').AsInteger := _ac.sysAccountId[_accPrepayment];
    execSQL;
  end;
end;

// need on standard eelkontrollid/uuendamised, kui andmed; kunagi oli napaks kala, kus provider hakkas iga reaga sqli preparema ! nüüd enam pole
// NAPAKAD päringud on siin selletõttu, et tahtsin hoida kompatiiblust firebirdiga, mille tegelt pole vähimat pointi
procedure TIncomings_base.verifyDataSQL(const pTableName: AStr);
var
  pSQL: AStr;
begin
  with self.FWorkerQry, SQL do
  begin
    // leiame panga id
    Close;
    Clear;
    psql := Format(' UPDATE %s' + ' SET bank_id=(SELECT b.id FROM banks b WHERE bank_code ILIKE b.swift AND b.company_id=%d)' +
      ' WHERE COALESCE(bank_code) <> ''''', [pTableName, estbk_globvars.glob_company_id]);
    add(pSQL);
    execSQL;

    // köige kindlam on leida klient viitenumbri järgi
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET client_id=(SELECT MAX(r.client_id) ' + '                  FROM referencenumbers r ' +
      '                  WHERE r.refnumber=%s.payer_refnumber ' + '                    AND r.company_id=%d ' +  // 22.04.2012 Ingmar; puudus firma !
      '                    AND r.rec_deleted=''f'') ' + ' WHERE %s.payer_refnumber<>''''' + '    AND COALESCE(client_id,0)=0 ' +
      '    AND errorcode=%d ', [pTableName, pTableName, estbk_globvars.glob_company_id, pTableName, CDataOK]);
    add(pSQL);
    execSQL;


    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET client_id=(SELECT MAX(c.id) ' + '                FROM client c ' +
      '                WHERE c.regnr=%s.payer_refnumber ' + '                  AND c.company_id=%d ' +  // 22.04.2012 Ingmar; puudus firma !
      '                  AND c.rec_deleted=''f'') ' + ' WHERE %s.payer_refnumber<>''''' + '    AND COALESCE(client_id,0)=0 ' +
      '    AND errorcode=%d ', [pTableName, pTableName, estbk_globvars.glob_company_id, pTableName, CDataOK]);
    add(pSQL);
    execSQL;

    // referencenumbers
    // anname esimese veakoodi ! sellise viitenumbriga klienti pole/vale viitenumber
    // 17.12.2017 Ingmar; swed paneb siia mingi kuupäeva jura ja kui meil niigi pole klientidel viite nr toetatud, siis mis point seda koodi lubada hetkel !
    // Näide:
    // <Ntry>
    //    <NtryRef>2017113000194636-1</NtryRef>
    //    <AcctSvcrRef>2017113000194636-1</AcctSvcrRef
    //    <NtryDtls>
    //      <TxDtls>
    //        <Refs>
    //          <AcctSvcrRef>2017113000194636-1</AcctSvcrRef>
    //          <EndToEndId>NOTPROVIDED</EndToEndId>
    //        </Refs>
    {$MESSAGE INFO '************* Kui kasutajate viitenr toetus tuleb, siis see koht üle vaadata !'}
    {
    close;
    clear;
    pSQL := format(' UPDATE %s ' +
                   ' SET errorcode=%d ' +
                   ' WHERE %s.payer_refnumber<>'''''+
                   '    AND COALESCE(client_id,0)=0 ',
                   [pTableName, CErrIncRefNrNotFound, pTableName]);
    add(pSQL);
    execSQL;
   }

    // arvega või tellimusega seotud muutuvad viitenumbrid; tuleks kontrollida kas arve suletud ?!?!?
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET item_type=%d,' + '     item_id=(SELECT r.bill_id' +
      '                  FROM referencenumbers r' + '                  WHERE r.refnumber=%s.payer_refnumber ' +
      '                    AND r.bill_id>0 ' + '                    AND r.fixed=''f''' + '                    AND r.rec_deleted=''f''' +
      '                    AND NOT exists(SELECT b.id ' + '                                   FROM bills b ' +
      '                                   WHERE b.id= r.bill_id ' +
      // '                                     AND b.credit_bill_id=0 '+ 18.03.2011 Ingmar; ntx osaline kreeditarve
      '                                     AND b.rec_deleted=''f'')' + '                  ) ' +
      ' WHERE %s.payer_refnumber<>''''' + '  AND  errorcode=%d ', [pTableName, CResolvedDataType_asBill, pTableName, pTableName, CDataOK]);
    add(pSQL);
    execSQL;

    // tellimusega seotud muutuvad viitenumbrid
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET item_type=%d,' + '     item_id=(SELECT r.order_id' +
      '                  FROM referencenumbers r ' + '                  WHERE r.refnumber=%s.payer_refnumber ' +
      '                    AND r.order_id>0 ' + '                    AND r.fixed=''f''' + '                    AND r.rec_deleted=''f''' +
      '                    AND NOT exists(SELECT o.id ' + '                                   FROM orders o ' +
      '                                   WHERE o.id= r.order_id ' + '                                     AND o.rec_deleted=''f'')' +
      '                  ) ' + ' WHERE %s.payer_refnumber<>''''' + '  AND  errorcode=%d ', [pTableName,
      CResolvedDataType_asOrder, pTableName, pTableName, CDataOK]);
    add(pSQL);
    execSQL;

    // add peame yhe stringina andma, kuna ntx ado puhul hakatakse igat rida preparema !
    // samas tuleb nii kirjutada, et firebirdi kompatiiblus ära ei kaoks ! ilma updates joinimata
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET  client_id=(SELECT c1.id ' + '              FROM client c1 ' +
      '              WHERE c1.srcval=%s.srcval)' + ' WHERE (SELECT COUNT(c.id) ' + '        FROM client c ' +
      '        WHERE c.srcval=%s.srcval)=1' + '    AND COALESCE(client_id,0)=0 ' + '    AND errorcode=%d ',
      [pTableName, pTableName, pTableName, CDataOK]);
    add(pSQL);
    execSQL;


    // vöimalik CRC32 kollisioon, sest seal puudub 100% unikaalsus
    // proovime täispika nimega; samas vöib olla kaks yhesuguse nimega klienti !!!
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET client_id=(SELECT c1.id ' + '                FROM client c1 ' +
      '                 WHERE c1.srcval=%s.srcval ' + '                   AND c1.name=%s.fullname ' +
      '                   AND c1.company_id=%d )' + ' WHERE ((SELECT COUNT(c.id) ' + '         FROM client c ' +
      '         WHERE c.srcval=%s.srcval' + '         )>1) ' + '    AND ((SELECT COUNT(c2.id) ' + '          FROM client c2 ' +
      '          WHERE ' + '              c2.srcval=%s.srcval ' + '          AND c2.name=%s.fullname ' +
      '          AND c2.company_id = %d) =1) ' + '    AND COALESCE(client_id,0)=0 ' + '    AND errorcode=%d ',
      [pTableName, pTableName, pTableName, glob_company_id, pTableName, pTableName, pTableName, glob_company_id, CDataOK]);
    add(pSQL);
    execSQL;


    // Proovime eraldi nime osadega ja pole sama nimi; Firebird kompatiiblus tagada !
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET client_id=(SELECT c1.id ' + '                FROM client c1 ' +
      '                WHERE c1.srcval=%s.srcval ' + '                  AND c1.name=%s.firstname ' +
      '                  AND c1.lastname=%s.lastname ' + '                  AND c1.company_id=%d) ' +
      ' WHERE ((SELECT COUNT(c.id) ' + '         FROM client c ' + '         WHERE c.srcval=%s.srcval)>1) ' +
      '   AND ((SELECT COUNT(c1.id) ' + '                FROM client c1 ' + '                WHERE c1.srcval=%s.srcval ' +
      '                  AND c1.name=%s.firstname ' + '                  AND c1.lastname=%s.lastname' +
      '                  AND c1.company_id=%d)=1) ' + '   AND COALESCE(client_id,0)=0 ' + '   AND errorcode=%d ',
      [pTableName, pTableName, pTableName, pTableName, glob_company_id, pTableName, pTableName, pTableName, pTableName, glob_company_id, CDataOK]);
    add(pSQL);
    execSQL;


    // 18.03.2011 Ingmar
    // kõik meganummi...aga pank saadab perekonnanimi eesnimi; ja me ei tea millal firma või eraisik
    // 17.12.2017 Ingmar;
    // Nime otsimine peab olema firmapõhine
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET client_id=(SELECT c1.id ' + '                FROM client c1 ' +
      '                WHERE c1.company_id=%d' + '                  AND c1.name=%s.lastname ' +
      '                  AND c1.lastname=%s.firstname) ' + ' WHERE        ((SELECT COUNT(c1.id) ' +
      '                FROM  client c1 ' + '                WHERE c1.company_id=%d ' + '                  AND c1.name=%s.lastname ' +
      '                  AND c1.lastname=%s.firstname)=1) ' + '    AND COALESCE(client_id,0)=0 ' + '    AND errorcode=%d ',
      [pTableName, glob_company_id, pTableName, pTableName, glob_company_id, pTableName, pTableName, CDataOK]);
    add(pSQL);
    execSQL;

    // ehk leiame selle kontoga seotud kliendi; varasem laekumine...
    // samas võiks seostatud arve või tellimuse kaudu ka liikuda, kui ikka kliendi ID 0 !!!
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET client_id=(SELECT (i.client_id) ' +
      //  MAX(i.client_id) !!! ära kasuta sest max annab alati resulti rea !
      '                FROM incomings_bank b ' + '                INNER JOIN incomings i ON  ' +
      '                i.incomings_bank_id=b.id AND i.status NOT LIKE ''%%D%%''' + '                WHERE b.bank_account=%s.bank_account ' +
      '                  AND b.bank_account<>''''' + '                UNION ' + '                SELECT (i1.client_id) ' +
      '                FROM incomings_bank b1 ' + '                INNER JOIN incomings i1 ON ' +
      '                i1.incomings_bank_id=b1.id AND i1.status NOT LIKE ''%%D%%''' +
      '                WHERE b1.bank_account_iban=%s.bank_account_iban ' + '                  AND b1.bank_account_iban<>''''' +
      '                )' + ' WHERE  COALESCE(client_id,0)=0 ' + '    AND errorcode=%d ', [pTableName, pTableName, pTableName, CDataOK]);
    add(pSQL);
    execSQL;

    // klienti ei leitud...
    Close;
    Clear;
    pSQL := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE COALESCE(%s.client_id,0)=0 ' + '   AND errorcode=%d ',
      [pTableName, CErrIncCustNotFound, pTableName, CDataOK]);
    add(pSQL);
    execSQL;


    // -----------------------------------------------------------------------
    // -- üritame nüüd olla selgituse võlurid; kindlasti tulevikus asi intelligentseks teha !
    // src by keyword...
    // -----------------------------------------------------------------------

    self.detectBill_OrderDataFromDescr(pTableName);

    // -----------------------------------------------------------------------
    // 24.06.2010 ingmar
    // -- üritame leida arve...ja jälle peame firebird tüüpi update tegema, ilma joinideta
    Close;
    Clear;
    pSql := format('UPDATE %s ' + 'SET item_id=(SELECT ' + estbk_dbcompability.sqlp._getHdrLimitRowsSQL(1, 0) +
      ' b.id ' + '                 FROM bills b ' + '                 WHERE b.bill_number=%s.data ' +
      '                  AND NOT b.status LIKE ''%%D%%'' ' + '                  AND b.client_id=%s.client_id ' +
      //'                  AND b.credit_bill_id=0 '+ // kreeditarvele me tasumist ei luba ! 18.03.2011 Ingmar pane hoopis arvetüüp paike ost või müük !
      estbk_dbcompability.sqlp._getFtrLimitRowsSQL(1, 0) + '                  ) ' + 'WHERE EXISTS( ' +
      '             SELECT b.id ' + '             FROM bills b ' + '             WHERE b.bill_number=%s.data ' +
      '               AND NOT b.status LIKE ''%%D%%'' ' + '               AND b.client_id=%s.client_id ' +
      '            ) ' + '  AND %s.item_type=%d ' + '  AND %s.errorcode=%d ' + '  AND %s.item_id=0',
      [pTableName, pTableName, pTableName, pTableName, pTableName, pTableName, CResolvedDataType_asBill, pTableName, CDataOK, pTableName]);
    add(pSql);
    execSQL;


    // ARVE võlakonto
    Close;
    Clear;
    pSql := format('UPDATE %s ' + 'SET account_id=(SELECT b.dc_account_id ' + '                FROM bills b ' +
      '                WHERE b.id=%s.item_id) ' + 'WHERE %s.item_id>0 ' + '  AND %s.item_type=%d ' + '  AND %s.account_id=0 ' +
      '  AND %s.errorcode= %d ', [pTableName, pTableName, pTableName, pTableName, CResolvedDataType_asBill, pTableName, pTableName, CDataOK]);
    add(pSql);
    execSQL;


    // --- tellimus ka
    Close;
    Clear;
    pSql := format('UPDATE %s ' + 'SET item_id=(SELECT ' + estbk_dbcompability.sqlp._getHdrLimitRowsSQL(1, 0) +
      ' o.id ' + '                 FROM orders o ' + '                 WHERE o.order_nr=%s.data ' +
      '                  AND NOT o.status LIKE ''%%D%%'' ' + '                  AND o.client_id=%s.client_id) ' +
      'WHERE EXISTS( ' + '             SELECT o.id ' + '             FROM orders o' + '             WHERE o.order_nr=%s.data ' +
      '               AND NOT o.status LIKE ''%%D%%'' ' + '               AND o.client_id=%s.client_id ' +
      estbk_dbcompability.sqlp._getFtrLimitRowsSQL(1, 0) + '            ) ' + '  AND %s.item_type=%d ' +
      '  AND %s.errorcode=%d ' + '  AND %s.item_id=0', [pTableName, pTableName, pTableName, pTableName, pTableName,
      pTableName, CResolvedDataType_asOrder, pTableName, CDataOK, pTableName]);
    add(pSql);
    execSQL;


    // tellimusel on vaikimisi konto alati ETTEMAKSU konto
    Close;
    Clear;
    pSql := format('UPDATE %s ' + 'SET account_id=%d ' + 'WHERE %s.item_id>0 ' + '  AND %s.item_type=%d ' +
      '  AND %s.account_id=0 ' + '  AND %s.errorcode=%d ', [pTableName, _ac.sysAccountId[_accPrepayment], pTableName,
      pTableName, CResolvedDataType_asOrder, pTableName, pTableName, CDataOK]);
    add(pSql);
    execSQL;

    // Ikkagit tuleb omakorda ülekontrollida, kas selline laekumine juba olemas !!!
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE EXISTS( ' + '                SELECT b1.id ' +
      '                FROM incomings_bank b1 ' + '                INNER JOIN incomings i1 ON ' +
      '                i1.incomings_bank_id=b1.id AND i1.status NOT LIKE ''%%D%%''' +
      '                WHERE b1.bank_archcode=%s.bank_archcode ' + '                  AND %s.bank_archcode<>'''') ',
      // 25.08.2011 Ingmar; tühja pangatunnust ei kontrolli !
      //              '   AND errorcode=%d ',
      [pTableName, CErrIncAlreadyExists, pTableName, pTableName]); // CDataOK
    add(pSql);
    execSQL;

    // kirjutame ka veakoodid ära
    // ---
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE errorcode=%d ' + '   AND item_type=%d ' +
      '   AND item_id=0 ', [pTableName, CErrIncBillWNrNotFound, CDataOK, CResolvedDataType_asBill]);
    add(pSql);
    execSQL;

    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE errorcode=%d ' + '   AND item_type=%d ' +
      '   AND item_id=0 ', [pTableName, CErrIncOrderWNrNotFound, CDataOK, CResolvedDataType_asOrder]);
    add(pSql);
    execSQL;


    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE errorcode=%d ' + '   AND item_type=%d ' +
      '   AND item_id=0 ', [pTableName, CErrIncOrderWNrNotFound, CDataOK, CResolvedDataType_asOrder]);
    add(pSql);
    execSQL;

    // ei suutnud selgituse järgi tuvastada, millega tegu
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE errorcode=%d ' + '   AND item_type<1 ',
      [pTableName, CErrIncCantResPayment, CDataOK]);
    add(pSql);
    execSQL;


    // ikka UPDATE  Firebird stiilis !
    // ARVE valuuta !
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET item_currency=(SELECT b.currency FROM bills b WHERE b.id=%s.item_id) ' +
      ' WHERE errorcode=%d ' + '   AND item_type=%d ' + '   AND item_id>0 ', [pTableName, pTableName, CDataOK, CResolvedDataType_asBill]);
    add(pSql);
    execSQL;


    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET item_currency_ovr=(SELECT b.currency_drate_ovr FROM bills b WHERE b.id=%s.item_id) ' +
      ' WHERE errorcode=%d ' + '   AND item_type=%d ' + '   AND item_id>0 ', [pTableName, pTableName, CDataOK, CResolvedDataType_asBill]);
    add(pSql);
    execSQL;


    // TELLIMUSE valuuta !
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET item_currency=(SELECT o.currency FROM orders o WHERE o.id=%s.item_id) ' +
      ' WHERE errorcode=%d ' + '   AND item_type=%d ' + '   AND item_id>0 ', [pTableName, pTableName, CDataOK, CResolvedDataType_asOrder]);
    add(pSql);
    execSQL;


    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET item_currency=(SELECT o.currency_drate_ovr FROM orders o WHERE o.id=%s.item_id) ' +
      ' WHERE errorcode=%d ' + '   AND item_type=%d ' + '   AND item_id>0 ', [pTableName, pTableName, CDataOK, CResolvedDataType_asOrder]);
    add(pSql);
    execSQL;


    // -- 27.06.2010 Ingmar; peame ka kontrollima, kas selline pangakonto on meie süsteemis
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE errorcode=%d ' + '   AND NOT EXISTS( ' +
      '                  SELECT a.id ' + '                  FROM accounts a ' + '                  INNER JOIN banks b ON ' +
      '                  b.id=a.bank_id ' +
      '                  WHERE ((a.account_nr=%s.receiver_account_number) OR (a.account_nr_iban=%s.receiver_account_number))' +
      '                   AND  a.bank_id>0 ' + '                   AND  a.rec_deleted=''f'') ', [pTableName,
      CErrIncRecvBankAccountNotFound, CDataOK, pTableName, pTableName]);
    add(pSql);
    execSQL;

    // -----------------------------------------------------------------------
    // raamatupidamislik konto külge ! PANK
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET bank_bk_account_id=(SELECT a.id ' + '                         FROM accounts a ' +
      '                         INNER JOIN banks b ON ' + '                         b.id=a.bank_id ' +
      '                         WHERE ((a.account_nr=%s.receiver_account_number) OR (a.account_nr_iban=%s.receiver_account_number)) ' +
      '                          AND  a.bank_id>0 ' + '                          AND  a.default_currency=%s.currency ' +
      '                          AND  a.rec_deleted=''f'') ' + ' WHERE errorcode <> %d ' + '   AND bank_bk_account_id=0 ',
      [pTableName, pTableName, pTableName, pTableName, CErrIncValidAccPeriodNotFound]);
    // CErrIncBillWNrNotFound  / CErrIncOrderWNrNotFound / CErrIncCantResPayment miks ma need veakoodid panin siia ?
    add(pSql);
    execSQL;

    // 29.12.2010 Ingmar
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET bank_bk_account_currency=(SELECT a.default_currency ' +
      '                               FROM accounts a ' + '                               WHERE a.id=%s.bank_bk_account_id ' +
      '                          AND  a.rec_deleted=''f'') ' + ' WHERE bank_bk_account_id>0 ', [pTableName, pTableName]);
    add(pSql);
    execSQL;

    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE errorcode in (%d,%d,%d,%d) ' +
      '   AND ((COALESCE(account_id,0)=0) and (COALESCE(bank_bk_account_id,0)=0))', [pTableName, CErrIncCantDetermAccount,
      CDataOK, CErrIncBillWNrNotFound, CErrIncOrderWNrNotFound, CErrIncValidAccPeriodNotFound, CErrIncCantResPayment]);

    add(pSql);
    execSQL;


    // http://www.developeando.com/2008/12/firebird-21-update-or-insert.html
    // et miks ei saa ühe updatega teha...meil vaja ka FIREBIRD toetust, siiani ei toetatud seal update, kus oli FROM väli ka sees !
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET account_currency=(SELECT a.default_currency ' + '                       FROM accounts a ' +
      '                       WHERE a.id=%s.account_id)', [pTableName, pTableName]);

    add(pSql);
    execSQL;


    // ARVE
    // --- makstava elemendi summat vaja teada saada
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET to_pay=(SELECT ' + '             (CASE ' +
      '                WHEN COALESCE(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum-b.uprepaidsum,0.00)>=0.00 THEN ' +
      '                     CAST(COALESCE(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum-b.uprepaidsum,0.00) AS ' +
      TEstbk_MapDataTypes.__MapMoneyType() + ')' + '              ELSE ' + '                     CAST(0.00 AS ' +
      TEstbk_MapDataTypes.__MapMoneyType() + ')' + '              END)' + '              FROM bills b ' +
      '              WHERE b.id=%s.item_id ' + '                AND NOT b.status LIKE ''%%D%%'') ' + ' WHERE errorcode=%d ' +
      '   AND item_type=%d ' + '   AND item_id>0 ', [pTableName, pTableName, CDataOK, CResolvedDataType_asBill]);
    add(pSql);
    execSQL;


    // TELLIMUS
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET to_pay=(SELECT COALESCE(o.order_sum+o.order_roundsum+o.order_vatsum-o.paid_sum,0) ' +
      '             FROM orders o ' + '             WHERE o.id=%s.item_id ' + '               AND NOT o.status LIKE ''%%D%%'') ' +
      ' WHERE errorcode=%d ' + '   AND item_type=%d ' + '   AND item_id>0 ', [pTableName, pTableName, CDataOK, CResolvedDataType_asOrder]);
    add(pSql);
    execSQL;

    // 10.07.2010 Ingmar; kliendi ettemaksu konto
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET client_prpaccount_id=(SELECT COALESCE(c.prepayment_account_id,0) ' +
      '                           FROM client c ' + '                           WHERE c.id=%s.client_id ' +
      '                             AND NOT c.rec_deleted=''f'') ' + ' WHERE errorcode=%d ' + '   AND client_id<>0 ',
      [pTableName, pTableName, CDataOK]);
    add(pSql);
    execSQL;


    // gridis kuvamisel näha pangakontot
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET bank_bk_account_coding=(SELECT a.account_coding FROM accounts a WHERE a.id=%s.bank_bk_account_id)',
      [pTableName, pTableName]);
    add(pSql);
    execSQL;



    // 02.01.2011 Ingmar
    //  -- vaatame, kas laekumine läheb sobivasse rp perioodi !
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET acc_period_id=COALESCE((SELECT id ' + '                             FROM accounting_period ' +
      '                             WHERE %s.payment_date BETWEEN period_start AND COALESCE(period_end,period_start+999 ) ' +
      '                              AND NOT status LIKE ''%%C%%''' + '                              AND company_id=%d),0)',
      [pTableName, pTableName, estbk_globvars.glob_company_id]);
    add(pSQL);
    execSQL;


    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET errorcode=%d ' + ' WHERE acc_period_id=0 ', [pTableName, CErrIncValidAccPeriodNotFound]);
    add(pSQL);
    execSQL;

    // 02.01.2011 Ingmar
    // kinnitus eemaldada vigastel kirjetel !
    Close;
    Clear;
    pSql := format(' UPDATE %s ' + ' SET status='''' ' + ' WHERE errorcode<>%d ', [pTableName, CDataOK]);
    add(pSQL);
    execSQL;

    // 25.08.2011 Ingmar
    Close;
    Clear;
    add('SELECT * FROM ' + pTableName);
    Open;

    if RecordCount < 1 then
      Dialogs.messageDlg(estbk_strmsg.SEIncIncomesNotFound, mtInformation, [mbOK], 0);
    Close;
  end; // ---
end;


function TIncomings_base.createIncomeSessionId(const pFileMode: boolean = True): integer;
var
  pAddNewSessionRec: boolean;
begin
  Result := 0;
  with  FWorkerQry, SQL do
  begin
    pAddNewSessionRec := pFileMode;


    // otsime tänase kuupäevaga laekumiste sessiooni / käsitsi sisestus !
    if not pFileMode then
    begin
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectSessionPerDate);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('created').AsString := estbk_utilities.datetoOdbcStr(date);
      Open;

      Result := FieldByName('id').AsInteger;
      pAddNewSessionRec := Result = 0;
    end;


    // ---
    if pAddNewSessionRec then
    begin

      // failiinfo
      Result := self.FIncomeSessionSeq.GetNextValue;

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLInsertIncomingsSessions);
      paramByname('id').AsInteger := Result;
      //paramByname('bank_id').AsInteger := 0;
      paramByname('session_name').AsString := datetostr(date);
      paramByname('filename').AsString := Copy(self.FCurrBankFile, 1, 512);

      if not pFileMode then
        paramByname('type_').AsString := estbk_types.CIncSrcFromBank
      else
        paramByname('type_').AsString := estbk_types.CIncSrcManual;
      paramByname('created').AsDateTime := date;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      execSQL;

    end;
    // ---
  end;
end;


// loob ajutised puhvertabelid
procedure TIncomings_base.createTempIncomeTables(var pIncomeLinesTable: AStr; var pIncomeItemsTable: AStr);
var
  pSQL: AStr;
begin
  with self.FWorkerQry, SQL do
    if not self.FTempTableCreated then
    begin

      // ---
      // CAST ja andmetyyp pole alati parim lahendus, köige parem on kasutada sama tabeli schemat
      pSQL := ' SELECT ' + ' id as incomings_bank_id,' + // ehk siis pangalaekumise ID mitte sessiooni oma !
        ' bank_code, ' + ' bank_archcode,' + ' id as client_id, ' + ' payer_name as fullname,' + ' payer_name as firstname,' +
        // peame nö nime kaheks lööma, et saaks indeksit kasutada !
        ' payer_name as lastname,' + ' payer_refnumber,' + ' payer_mk_nr,' +  // dok. nr
        ' payment_sum,' + ' payment_date,' +  // maksmise kuupäev
        ' incoming_date,' + // millal reaalselt laekus
        ' bank_account,' + // maksja konto nr !
        ' bank_account_iban,' + // maksja konto nr !

        ' currency,' +  // makse valuuta
        ' currency_drate_ovr, ' + // panga poolt edastatud valuutakurss !

        ' description,' + // panga kirjeldus
        ' id as errorcode, ' + ' receiver_account_number,' +  // antud juhul tegemist meie pangakonto nr
        ' receiver_account_number_iban,' +

        // 25.06.2010 Ingmar; siin peab BIG olema !
        '(SELECT bint FROM __int_systemtypes WHERE bbool=''t'') as srcval,' +
        //' id as srcval, '+
        ' description as data, ' + ' payment_date  as item_date, ' + // arve või tellimuse kuupäev
        ' payer_mk_nr   as item_nr,' + // arve / tellimuse nr

        // leitud element
        ' id as item_id, ' + ' currency     as item_currency,' +// arve / tellimuse valuuta !
        ' payment_sum  as item_currency_ovr,' + // arvele / tellimusele lisatud kurss !
        ' id           as item_type, ' + ' incoming_date as item_due_date,' + // arve / tellimuse maksetähtaeg

        ' id as account_id,' +              // võlakonto; arve / tellimus
        ' currency as account_currency,' +  // arve / tellimuse konto valuuta

        ' id as bank_bk_account_id,' + //  panga kontoga ja valuutaga seotud raamatupidamislik konto
        ' bank_account_iban as bank_bk_account_coding,' + // rp. kontokood vajalik vaid kuvamiseks
        ' currency as bank_bk_account_currency,' + // pangakontoga seotud rp. konto valuuta

        ' id as bank_id,' + // panga tabel; puhtalt informatiivne
        ' id as recnr, ' + ' id as acc_period_id, ' +        // raamatupidamisperiood
        ' id as client_prpaccount_id, ' + // 10.07.2010 Ingmar; kliendile määratud ettemaksu konto !
        ' payment_sum as to_pay, ' +

        // leitud arve/tellimuse tunnus
        ' id as line_nr, ' +    // vigade aruande jaoks !
        ' id as incoming_id, ' + // viitab laekunud objektidele; st eelnevalt salvestatud laekumine

        ' id as acc_reg_id,  ' + // ntx kande muutmisel viitab rp.aluskirjele
        ' bank_account_iban as acc_reg_incnr,' + // laekumise nr = ehk siis kande nr

        ' bank_account_iban as pguid, ' +// GUID on 38 märki
        ' status, ' +      // 07.12.2010 staatus; kas avatud või suletud !
        ' rec_deleted as newrecord, ' +  // 07.12.2010 Ingmar;

        ' bank_account_iban as account_coding, ' + // arvega / tellimusega seotud konto kood
        ' bank_account_iban as bank_bk_coding, ' + // pangaga seotud rp. konto
        ' status as rec_type, ' + // kas laekumine on pandud peale käsitsi või on failist; üldiselt nii = '' siis failidest / muidu käsitsi
        ' service_charges, ' + ' payment_sum as payment_sum_origfromfile' + // algne summa failist AS IS
        ' FROM ' + estbk_dbcompability.CTable_names[__scincomings_bank] + ' WHERE 0=1';


      pIncomeLinesTable := 'tmp';
      pSql := estbk_dbcompability.sqlp._create_temptable(pIncomeLinesTable, pSQL, True, False);
      Close;
      Clear;
      add(pSql);
      execSQL;



      // multiple cmd ei pruugi läbi minna erinevate backendidega, teeme eraldi qryde abil
      Close;
      Clear;
      add(format('CREATE INDEX ptmp_idx_' + inttohex(random(32000), 10) + ' ON %s (item_type)', [pIncomeLinesTable]));
      execSQL;

      Close;
      Clear;
      add(format('CREATE INDEX ptmp_idx1_' + inttohex(random(32000), 10) + ' ON %s (recnr)', [pIncomeLinesTable]));
      execSQL;

      Close;
      Clear;
      add(format('CREATE INDEX ptmp_idx2_' + inttohex(random(32000), 10) + ' ON %s (item_id)', [pIncomeLinesTable]));
      execSQL;

      Close;
      Clear;
      add(format('CREATE INDEX ptmp_idx3_' + inttohex(random(32000), 10) + ' ON %s (data)', [pIncomeLinesTable]));
      execSQL;



        { 09.12.2010 Ingmar; õues väike tormike ;)
          ühe laekumisega seotud n elementi, need tuleb ka ära kirjeldada !
          Need tabelid on sarnased, sest faili puhul nö ühe reana lihtsam andmeid sisse lugeda.
          Teine tabel sisuliselt sisaldab arveid / tellimusi, mis seotud laekumiste reaga, seotud rohkem käsitsi sisestusega.
          Failide puhul on suht 1:1 seos !
        }

      Close;
      Clear;


      // ---
      pSQL := ' SELECT ' +
        //' status as item_type, '+// elemendi tüüp arve / tellimus
        ' id as item_type, ' +  // estbk_bankfilesconverr-> CResolvedDataType_asBill  = 1;  CResolvedDataType_asOrder = 2;
        ' id as item_id, ' +   // tasutud elemendi ID
        ' currency      as item_currency,' +// arve / tellimuse valuuta
        ' payment_sum   as item_currency_ovr,' +     // arvele lisatud kurss !
        ' payment_sum   as item_currency_ovr_idt,' + // kui arvega tehakse konversioon, siis võetakse arve hetke valuutakurss
        ' payment_sum   as curr_diff,' + // siis hoiame kursivahet (ala arve on USD / laekumine GBP) issanda loomaaed on suur
        ' payment_sum   as payment_sum_conv,' + // siis väljal hoiame siis konverteeritud summat ntx arve usd, gbp tasuti
        ' payment_date  as item_date, ' + // arve või tellimuse kuupäev
        ' bank_account_iban   as item_nr,' + // arve / tellimuse nr
        ' incoming_date as item_due_date,' + // arve / tellimuse maksmise tähtaeg
        ' id as client_id, ' +  // kliendiid
        ' id as account_id,' + //  arve / tellimusega seotud konto võlakonto ntx

        ' bank_account_iban as account_coding, ' + // rp. konto pikk kood
        ' currency as account_currency, ' +        // konto vaikimisi valuuta

        ' payment_sum as paid,' +   // eelnevalt tasutud
        ' payment_sum as to_pay,' + // tasuda
        ' payment_sum,' +           // tasuti !!!

        ' bank_account_iban as pguid, ' +// GUID on 38 märki; unikaalne seos
        ' id as incoming_id, ' +      // tasumist kirjeldav rida                '

        ' rec_deleted as lsitemhlp, ' + // gridis saame teada, et kas element võeti peale või mitte
        ' payment_sum as payment_sum_origfromfile ' + // failide sissetõmbamisel, et ikka algne summa säiliks
        ' FROM ' + estbk_dbcompability.CTable_names[__scincomings_bank] + ' WHERE 0=1';

      pIncomeItemsTable := 'tmp2';
      pSql := estbk_dbcompability.sqlp._create_temptable(pIncomeItemsTable, pSQL, True, False);
      Close;
      Clear;
      add(pSql);
      execSQL;


      Close;
      Clear;
      add(format('CREATE INDEX ptmp2_idx_' + inttohex(random(32000), 10) + ' ON %s (pguid)', [pIncomeLinesTable]));
      execSQL;



      // jätame meelde loodud ajutiste tabelite nimed !
      self.FTemptableIncomeLines := pIncomeLinesTable;
      self.FTemptableIncomeItems := pIncomeItemsTable;
      self.FTempTableCreated := True;
    end
    else
    begin
      pIncomeLinesTable := self.FTemptableIncomeLines;
      pIncomeItemsTable := self.FTemptableIncomeItems;

      self.FTempTableCreated := True;
      Close;
      Clear;
      add(format('DELETE FROM %s', [pIncomeLinesTable]));  // truncate ei tööta firebird puhul !
      execSQL;

      Close;
      Clear;
      add(format('DELETE FROM %s', [pIncomeItemsTable]));
      execSQL;
    end;
end;

procedure TIncomings_base.dropTempIncomeDataTables();
begin
  if self.FTempTableCreated then
    with self.FWorkerQry, SQL do
      try
        Close;
        Clear;
        add(format('DROP TABLE %s', [self.FTemptableIncomeLines]));

        self.FTemptableIncomeLines := '';
        self.FTempTableCreated := False;
        // --
        execSQL;

        Close;
        Clear;
        add(format('DROP TABLE %s', [self.FTemptableIncomeItems]));
        // --
        execSQL;
      except
      end;
  // ---
end;

// teha funktsioon postgres, mis seeria nr annaks; samas siis välistame suht firebirdi ja mysqli hmmm....
// TODO parem kood; omistame siin laekumise nr
procedure TIncomings_base.assignIncomeNumbers(const pTableIncLines: AStr);
var
  pIncomeNum: AStr;
begin
  // FTempQry
  with self.FWorkerQry, SQL do
    try
      Close;
      Clear;
      add(format('SELECT * FROM %s WHERE errorcode<>%d', [pTableIncLines, CErrIncAlreadyExists]));
      Open;
      First;


      // --
      FTempQry.Close;
      FTempQry.SQL.Clear;
      FTempQry.SQL.add(format('UPDATE %s', [pTableIncLines]));
      FTempQry.SQL.add('SET acc_reg_incnr=:acc_reg_incnr');
      FTempQry.SQL.Add('WHERE pguid=:pguid');

      // ---
      while not EOF do
      begin

        //  ---
        if length(trim(FieldByName('pguid').AsString)) > 0 then
        begin

          if FieldByName('client_id').AsString <> '' then
            FTempQry.ParamByName('pguid').AsString := FieldByName('pguid').AsString + '#' + FieldByName('client_id').AsString
          // 23.10.2011 Ingmar; guid sisaldab ka kliendi ID !
          else
            FTempQry.ParamByName('pguid').AsString := FieldByName('pguid').AsString;
          // 01.03.2012 Ingmar; numeraatorite reform
          pIncomeNum := dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', FieldByName('incoming_date').AsDateTime,
            False, estbk_types.CAccInc_rec_nr);
          FTempQry.ParamByName('acc_reg_incnr').AsString := pIncomeNum;
          // 23.08.2011 Ingmar
          FTempQry.ExecSQL;
          dmodule.markNumeratorValAsUsed(PtrUInt(self), estbk_types.CAccInc_rec_nr, pIncomeNum, FieldByName('incoming_date').AsDateTime);
          // meil pole midagi teha, peame kõik kande nr märkima kasutatuks
        end;

        // --
        Next;
      end;




    finally
      Close;
      Clear;
      // --
      FTempQry.Close;
      FTempQry.SQL.Clear;
    end;
end;

// ---
{
 Täidab arvete / tellimuste tabeli; faili sisestuse puhul kopeeritakse põhitabelist need andmed !

  * 09.12.2010 Ingmar
  * Kuna failist saabunud kirjed loetakse alati automaatselt uuteks kirjeteks st kui veatöötlusest läbi saanud
  * antud juhul puudub laekumise ID ja kande ID
}
procedure TIncomings_base.FillItemsTable(const pTableIncLines: AStr; const pTableIncItems: AStr);
begin
  with self.FWorkerQry, SQL do
    try

      Close;
      Clear;
      add(format('INSERT INTO %s (%s)', [pTableIncItems, CItemsTemptableCommonFld]));
      add('SELECT item_type, item_id, '''' as item_nr,client_id,payment_sum,0.00,0.00,');
      add('to_pay, item_currency,item_currency_ovr,item_currency_ovr,0.00,item_due_date,account_id,');
      add(''''' as account_coding,account_currency,pguid,0,''t'',payment_sum');

      // -----------
      // item_currency_ovr; arvega seotud valuuta kurss
      // item_currency_ovr_idt; arve valuuta kurss tänase päevase seisuga

      add(format('FROM %s', [pTableIncLines]));
      add(format('WHERE (errorcode in (%d,%d))', [CDataOK, CErrIncValidAccPeriodNotFound]));
      add('  AND item_id>0');
      // --
      execSQL;

      // -- jällegit, et tulevikus ka FIREBIRD'i saaks toetada, siis pole võimalik teha joiniga update
      Close;
      Clear;
      add(format('UPDATE %s', [pTableIncItems]));
      add(format('SET item_nr=(SELECT bill_number FROM bills WHERE id=%s.item_id),', [pTableIncItems]));
      add(format('    item_date=(SELECT bill_date FROM bills WHERE id=%s.item_id)', [pTableIncItems]));
      add(format('WHERE  item_type=%d', [CResolvedDataType_asBill]));
      execSQL;


      Close;
      Clear;
      add(format('UPDATE %s', [pTableIncItems]));
      add(format('SET item_nr=(SELECT order_nr FROM orders WHERE id=%s.item_id),', [pTableIncItems]));
      add(format('    item_date=(SELECT order_date FROM orders WHERE id=%s.item_id)', [pTableIncItems]));
      add(format('WHERE  item_type=%d', [CResolvedDataType_asOrder]));
      execSQL;


      Close;
      Clear;
      add(format('UPDATE %s', [pTableIncItems]));
      add(format('SET  account_coding=(SELECT a.account_coding FROM accounts a WHERE a.id=%s.account_id)', [pTableIncItems]));
      execSQL;

      // 27.12.2010 Ingmar
      // kliendi tasumata arved / tellimused; st kuvame kõik !
      addClientUnpaidItemsToBfrTable(pTableIncLines, pTableIncItems);
    finally
      Close;
      Clear;
    end;
end;


procedure TIncomings_base.processIncomeEntrys(const pBufferedData: TObjectList; const pFileName: AStr; const pMD5: AStr;
  // 29.11.2010 Ingmar; seoses käsitsi sisestusega ! override
  const pBankId: integer = 0; const pBankCode: AStr = ''; const pIncomingFromFile: boolean = True);

var
  i, pPos: integer;
  pImpSessId: integer;
  pRecNr: integer;

  j: TBankDataFields;
  pBline: TBankFieldData;

  pCurrRate: currency;
  pLastOkSp: integer;
  pCalcSrvVal: longword;
  pSQL: AStr;
  pFullBankAccOverview: AStr;
  pTableIncLines: AStr; // laekumiste read;
  pTableIncItems: AStr; // laekumistega seotud elemendid; kui failist hetkel 1-1 seos, siis käsitsi võib laekumisele peale panna mitu arvet/tellimust
  //  pTmpSQL  : TAStrList;
  pFirstname: AStr;
  pLastname: AStr;
  pTmpStr: AStr;
begin

  with self.FWorkerQry, SQL do
    try


      // kui käsitsi, siis võib olla ju tabel loodud !
      if pIncomingFromFile then
        self.createTempIncomeTables(pTableIncLines, pTableIncItems);

      try

        // sisuliselt laekumiste read; dubleerime tabeleid, sest meil kordades lihtsam asju lugeda ühte tabelisse
        // kui lugemisel mõlemat tabelit täita ja sünkroniseerida...uhh
        Close;
        Clear;
        pSql := (format('INSERT INTO %s', [pTableIncLines]));
        pSql := pSql + '(';
        pSql := pSql + '  bank_code,bank_archcode,firstname,lastname,fullname,payer_refnumber,';
        pSql := pSql + '  payer_mk_nr,payment_sum,payment_date,incoming_date,';
        pSql := pSql + '  account_id,bank_bk_account_id,bank_id,bank_account,bank_account_iban,currency,description,line_nr,receiver_account_number,';
        pSql := pSql +
          '  currency_drate_ovr,errorcode,client_id,srcval,recnr,pguid,data,item_type,item_id,status,newrecord,service_charges,payment_sum_origfromfile';
        pSql := pSql + ')';


        pSql := pSql + 'VALUES';
        pSql := pSql + '(';
        pSql := pSql + '  :bank_code,:bank_archcode,:firstname,:lastname,:fullname,:payer_refnumber,';
        pSql := pSql + '  :payer_mk_nr,:payment_sum,:payment_date,:incoming_date,';
        pSql := pSql +
          '  :account_id,:bank_bk_account_id,:bank_id,:bank_account,:bank_account_iban,:currency,:description,:line_nr,:receiver_account_number,:currency_drate_ovr,';
        pSql := pSql + '  :errorcode,:client_id,:srcval,:recnr,:pguid,:data,:item_type,:item_id,:status,:newrecord,:service_charges,:payment_sum_origfromfile';
        pSql := pSql + ')';
        add(pSql);

        paramByname('errorcode').AsInteger := 0;
        paramByname('data').AsString := '';

        paramByname('item_type').AsInteger := 0;
        paramByname('item_id').AsInteger := 0;
        paramByname('line_nr').AsInteger := 0; // vajalik vigade aruande jaoks !
        paramByname('client_id').AsInteger := 0;

        // 29.11.2010 Ingmar
        paramByname('bank_id').AsInteger := pBankId;
        paramByname('bank_code').AsString := Copy(pBankCode, 1, 8); // 8 kohaline bic !

        paramByname('firstname').AsString := '';
        paramByname('lastname').AsString := '';
        paramByname('payer_refnumber').AsString := '';
        paramByname('bank_account').AsString := '';
        paramByname('bank_account_iban').AsString := '';
        paramByname('currency').AsString := estbk_globvars.glob_baseCurrency;
        paramByname('description').AsString := '';
        paramByname('receiver_account_number').AsString := '';
        paramByname('payment_sum').asCurrency := 0;
        paramByname('payment_sum_origfromfile').asCurrency := 0;
        paramByname('currency_drate_ovr').asCurrency := 1.00;

        // raamatupudamisliku konto id; pank
        paramByname('account_id').AsInteger := 0;
        paramByname('bank_bk_account_id').AsInteger := 0;

        // TODO pangateenustasud !
        paramByname('service_charges').AsFloat := 0.00;


        // faili kirjed alguses paneme koheselt kinnitatuks ! kujuta ette 500 rida ja pead hakkama käsitsi kõiki kinnitama
        paramByname('newrecord').AsString := SCFalseTrue[True];
        if pIncomingFromFile then
          paramByname('status').AsString := estbk_types.CIncomeRecStatusClosed
        else
          paramByname('status').AsString := '';

        pCalcSrvVal := 0;
        pRecNr := 0;

        for  i := 0 to pBufferedData.Count - 1 do
          if pBufferedData.Items[i] is TBankFieldData then
          begin
            paramByname('item_id').AsInteger := 0;
            paramByname('client_id').AsInteger := 0;
            paramByname('item_type').AsInteger := 0;

            // --
            pBline := pBufferedData.Items[i] as TBankFieldData;
            for j := low(TBankDataFields) to high(TBankDataFields) do
            begin
              // andmed tulevad otse failist, ei luba failide override !
              if pIncomingFromFile and (j in ([fld_predef_client_id, fld_predef_bill_id, fld_predef_order_id,
                fld_new_record_flag, fld_record_status_flag])) then
                continue;

              case j of
                fld_bank_archcode: paramByname('bank_archcode').AsString := Copy(pBline.Data[j], 1, 128);
                fld_bank_code: paramByname('bank_code').AsString := Copy(pBline.Data[j], 1, 8); // 8 kohaline bic !
                fld_payer_name:
                begin
                  pCalcSrvVal := 0;
                  pFirstname := '';
                  pLastname := '';
                  // samas firma nime puhul loogika läheb metsa AS METSAVEOD JA POJAD
                  pTmpStr := trim(UpperCase(Copy(pBline.Data[j], 1, 255)));
                  pTmpStr := estbk_utilities.stripExtraSpaces(pTmpStr);
                  if pTmpStr <> '' then
                    estbk_crc32.CRC32(@pTmpStr[1], length(pTmpStr), pCalcSrvVal);
                  paramByname('fullname').AsString := pTmpStr;
                  // algsed andmed
                  // CRC32 srcval peal ei garanteeri nime unikaalsust !
                  // vaid nii suudame kiirema päringu vaid teha

                  // miks nii teeme, tykeldame nime,
                  // pöhjuseks vana hea  upper, muidu erinevate andmebaasidega
                  // pean hakkama collatione möistatama; concat andmebaasides saatanast
                  pPos := 1;
                  pLastOkSp := pPos;
                  // RPosEX vöib ära kaotada kompatiibluse delphiga
                  pPos := PosEx(#32, pTmpStr, pPos);

                  while pPos > 0 do
                  begin
                    pLastOkSp := pPos;
                    pPos := PosEx(#32, pTmpStr, pPos + 1);
                  end;

                  if pLastOkSp <= 1 then
                    pFirstname := pTmpStr
                  else
                  begin
                    // byte by byte copy  kompatiiblus ei tohiks kaduda
                    pFirstname := copy(pTmpStr, 1, pLastOkSp - 1);
                    system.Delete(pTmpStr, 1, pLastOkSp);
                    pLastname := trim(pTmpStr);
                  end;

                  // 01.09.2016 Ingmar; workaround, see tükeldamine keerab asjad väga metsa
                  if (AnsiUpperCase(pFirstname) = 'AS') or (AnsiUpperCase(pFirstname) = 'OÜ') or
                    (AnsiUpperCase(pLastname) = 'AS') or (AnsiUpperCase(pLastname) = 'OÜ') then
                  begin
                    paramByname('firstname').AsString := '';
                    paramByname('lastname').AsString := pFirstname + #32 + pLastname;
                  end
                  else
                  begin
                    paramByname('firstname').AsString := pFirstname;
                    // algsed andmed
                    paramByname('lastname').AsString := pLastname;
                  end;
                  // algsed andmed
                  // paramByname('srcval').asLargeInt:=0;
                  // pean tobeda casti tegema, muidu kompilaator hakkab leiutama
                  paramByname('srcval').AsLargeInt := int64(pCalcSrvVal);
                end;
                fld_payer_refnumber: paramByname('payer_refnumber').AsString := trim(Copy(pBline.Data[j], 1, 30));
                fld_payer_payer_mk_nr: paramByname('payer_mk_nr').AsString := Copy(pBline.Data[j], 1, 20);
                fld_payment_sum:
                begin
                  paramByname('payment_sum').asCurrency := pBline.Data[j];
                  paramByname('payment_sum_origfromfile').asCurrency := paramByname('payment_sum').asCurrency;
                end;

                //fld_incoming_date,
                fld_payment_date:
                begin
                  paramByname('payment_date').AsDateTime := pBline.Data[j];
                  paramByname('incoming_date').AsDateTime := pBline.Data[j];
                end;

                fld_payer_account: paramByname('bank_account').AsString := UpperCase(Copy(pBline.Data[j], 1, 45));
                fld_payer_account_iban: paramByname('bank_account_iban').AsString := UpperCase(Copy(pBline.Data[j], 1, 45));
                fld_currency:
                begin
                  if trim(copy(pBline.Data[j], 1, 3)) <> '' then
                    paramByname('currency').AsString := copy(pBline.Data[j], 1, 3)
                  else
                    paramByname('currency').AsString := estbk_globvars.glob_baseCurrency;
                end;

                fld_currency_drate_ovr:
                begin
                  pCurrRate := pBline.Data[j];
                  if pCurrRate = 0 then
                    pCurrRate := 1;
                  paramByname('currency_drate_ovr').asCurrency := pCurrRate;
                end;

                fld_description: paramByname('description').AsString := trim(Copy(pBline.Data[j], 1, 255));
                // 26.06.2010 Ingmar; ehk failis on kontonumber, millele laekus raha !!!
                fld_receiver_account_number:
                begin
                  paramByname('receiver_account_number').AsString := trim(Copy(pBline.Data[j], 1, 45));
                end;




                // 28.11.2010 Ingmar
                // seoses käsitsi märkimisega !
                fld_predef_client_id: paramByname('client_id').AsInteger := StrToIntDef(trim(pBline.Data[j]), 0);

                fld_predef_bill_id:
                begin
                  paramByname('item_id').AsInteger := StrToIntDef(trim(pBline.Data[j]), 0);
                  paramByname('item_type').AsInteger := CResolvedDataType_asBill;
                end;

                fld_predef_order_id:
                begin
                  paramByname('item_id').AsInteger := StrToIntDef(trim(pBline.Data[j]), 0);
                  paramByname('item_type').AsInteger := CResolvedDataType_asOrder;
                end;

                fld_new_record_flag:
                begin
                  paramByname('newrecord').AsString := trim(pBline.Data[j]);
                end;

                fld_record_status_flag:
                begin
                  paramByname('status').AsString := trim(pBline.Data[j]);
                end;
              end;
            end;


            Inc(pRecNr);


            // --
            paramByname('pguid').AsString := estbk_utilities.uGuid36;
            paramByname('line_nr').AsInteger := pBline.linenr;
            paramByname('recnr').AsInteger := pRecNr;

            // andmed ajutisse tabelisse
            execSQL;
          end;


        // erinevad andmebaasi kontrollpäringud !
        verifyDataSQL(pTableIncLines);

        // --------------------------------------------------------------------
        // kirjutame andmed logisse !
        // --------------------------------------------------------------------
        writeErrReport();
        // --------------------------------------------------------------------

        // 18.03.2011 Ingmar
        createMiscLines(pTableIncLines, pTableIncItems);
        // sisuliselt, et ühilduks käsitsi sisestusega, kopeerime põhiridadelt kirjed teise tabelisse !
        fillItemsTable(pTableIncLines, pTableIncItems);
        // AssignIncomeNumbers(pTableIncLines); 07.09.2016 Ingmar; miks me siin kande nr omistame !?!?!?
      finally
        Close;
        Clear;
      end;



    except
      on e: Exception do
      begin
        if self.FWorkerQry.Connection.InTransaction then
          try
            self.FWorkerQry.Connection.Rollback;
          except
          end; // ntx trigger tõmbas transaktsiooni tagasi !
        raise Exception.Create(e.message);
        // lihtsalt raise ei pruugi korrektselt töötada !
      end;
    end;
end;



function TIncomings_base.processPredefinedRecords(const pDataLines: TObjectList; const pBankId: integer;
  const pBankCode: AStr; var pError: Astr): boolean;
const
  CManualIncomesFilename = 'laekumine';

begin
  Result := False;
  pError := '';

  if assigned(pDataLines) and (pDataLines.Count > 0) then
    try
      self.processIncomeEntrys(pDataLines, SCIncDummyFilename + '-' + datetimetostr(now), datetimetostr(now), pBankId, pBankCode, False);
      Result := True;
    except
      on e: Exception do
        pError := e.message;
    end;
end;


procedure TIncomings_base.addSavedItemsToBfrTable(const pTableIncLines: AStr; const pTableIncItems: AStr);
var
  i: integer;
begin
  with self.FWorkerQry, SQL do
    try

      // 28.02.2011 Ingmar
      // varia rea puhul on asjad lihtsustatud
      Close;
      Clear;
      add(format('INSERT INTO %s (%s)', [pTableIncItems, CItemsTemptableCommonFld]));

      add('SELECT ');
      add(format('%d,i.id,a.account_name,i.client_id,i.income_sum,i.conv_income_sum,', [CResolvedDataType_asMisc]));
      add('null,null,i.currency,i.conv_currency_drate_ovr,');
      add('i.conv_currency_drate_ovr,0.00,null,a.id,'); // 0.00 kursivahe !
      add('a.account_coding,a.default_currency,k.pguid,i.id,CAST(''t'' AS ' + TEstbk_MapDataTypes.__MapModBoolean() + '),i.income_sum');

      add(format('FROM %s k', [pTableIncLines]));    //  incoming_bank_id
      add('INNER JOIN incomings i ON ');
      add('(i.incomings_bank_id=k.incomings_bank_id) AND (i.bill_id=0) AND (i.order_id=0) AND NOT i.status LIKE ''%D%'' AND i.rec_deleted=''f''');
      add('INNER JOIN accounts a ON ');
      add('a.id=i.account_id');
      execSQL;


      // kahjuks...peame uuesti inserdi tegema, sest varia RIDA PEAB alati olema !
      Close;
      Clear;
      add(format('INSERT INTO %s (%s)', [pTableIncItems, CItemsTemptableCommonFld]));

      add('SELECT ');
      add(format('%d,0 as incoming_id,a.account_name,k.client_id,0.00 as income_sum,0.00 as conv_income_sum,', [CResolvedDataType_asMisc]));
      add(format('null,null,%s as currency,1.000 as conv_currency_drate_ovr,', [QuotedStr(estbk_globvars.glob_baseCurrency)]));
      add('1.000,0.00,null,a.id,'); // 0.00 kursivahe !
      add('a.account_coding,a.default_currency,k.pguid,0,CAST(''f'' AS ' + TEstbk_MapDataTypes.__MapModBoolean() + '),0.00');


      add(format('FROM %s k', [pTableIncLines]));    //  incoming_bank_id
      add('INNER JOIN accounts a ON ');
      add(format('a.id=%d', [_ac.sysAccountId[_accPrepayment]]));
      add(format('WHERE NOT EXISTS(SELECT k1.*  FROM %s k1 WHERE k1.pguid=k.pguid AND k1.client_id=k.client_id AND k1.item_type=%d)',
        [pTableIncItems, CResolvedDataType_asMisc]));
      execSQL;


      Close;
      Clear;
      add(format('INSERT INTO %s (%s)', [pTableIncItems, CItemsTemptableCommonFld]));
      // -----------

      add('SELECT ');
      add(format('%d,b.id,b.bill_number,b.client_id,i.income_sum,i.conv_income_sum,b.incomesum,', [CResolvedDataType_asBill]));
      //    add('(CASE WHEN');
      add('(');
      //add('   CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum-b.uprepaidsum AS '+TEstbk_MapDataTypes.__MapMoneyType()+')+');
      //add('   CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+')>=0.00 THEN');

      add('     CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum-b.uprepaidsum AS ' +
        TEstbk_MapDataTypes.__MapMoneyType() + ')+');
      add('     CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS ' + TEstbk_MapDataTypes.__MapMoneyType() + ')');
      add(') as topay,');
      //  add(' ELSE');
      //    add('     CAST(0.00 AS '+TEstbk_MapDataTypes.__MapMoneyType()+')');
      //  add(' END) as topay,');


      add(' b.currency,b.currency_drate_ovr,');
      add(' i.conv_currency_drate_ovr,0.00,b.due_date,b.dc_account_id,'); // 0.00 kursivahe !
      add(' a.account_coding,a.default_currency,k.pguid,i.id,CAST(''t'' AS ' + TEstbk_MapDataTypes.__MapModBoolean() + '),i.income_sum');

      add(format('FROM %s k', [pTableIncLines]));    //  incoming_bank_id
      add('INNER JOIN incomings i ON ');
      add('(i.incomings_bank_id=k.incomings_bank_id) AND (i.bill_id>0) AND NOT i.status LIKE ''%D%'' AND i.rec_deleted=''f''');
      add('INNER JOIN bills b ON ');
      add('b.id=i.bill_id');

      // 28.03.2011
      Add(' LEFT OUTER JOIN  bills ccb ON ');
      Add('ccb.id=b.credit_bill_id');
      Add(format('  AND ccb.bill_type=%s', [QuotedStr(estbk_types._CItemCreditBill)]));
      Add('  AND ccb.status LIKE ''%C%''');
      Add('  AND ccb.rec_deleted=''f''');

      add(format('    AND  b.company_id=%d', [estbk_globvars.glob_company_id]));
      //add('     AND  NOT  b.status LIKE ''%'+estbk_types.CRecIsCanceled+'%''');
      add('     AND  b.rec_deleted=''f''');
      add('INNER JOIN accounts a ON ');
      add('a.id=i.account_id');
      execSQL;

      // tellimused
      Close;
      Clear;
      add(format('INSERT INTO %s (%s)', [pTableIncItems, CItemsTemptableCommonFld]));
      // -------------


      add('SELECT ');
      add(format('%d,o.id,o.order_nr,o.client_id,i.income_sum,i.conv_income_sum,', [CResolvedDataType_asOrder]));
      add(' o.paid_sum,'); // tasutud
      add('CAST(');
      add(' (CASE WHEN (o.order_sum+o.order_roundsum+o.order_vatsum-o.paid_sum)<0 THEN 0'); // tasuda / ettemaks !
      add('  ELSE ');
      add('      o.order_sum+o.order_roundsum+o.order_vatsum-o.paid_sum ');
      add('  END) AS ' + TEstbk_MapDataTypes.__MapMoneyType() + ') as to_pay,');
      add(' o.currency,o.currency_drate_ovr,i.conv_income_sum,0.00,o.order_prp_due_date as due_date, a.id,'); // 0.00 ümmardus
      add(' a.account_coding,a.default_currency,k.pguid,i.id,CAST(''t'' AS ' + TEstbk_MapDataTypes.__MapModBoolean() + '),i.income_sum');


      add(format('FROM %s k', [pTableIncLines]));    //  incoming_bank_id
      add('INNER JOIN incomings i ON ');
      add('(i.incomings_bank_id=k.incomings_bank_id) AND (i.order_id>0) AND NOT i.status LIKE ''%D%'' AND i.rec_deleted=''f''');
      add('INNER JOIN orders o ON ');
      add(format('o.id=i.order_id AND o.company_id=%d', [estbk_globvars.glob_company_id]));
      //add('     AND NOT  o.status LIKE ''%'+estbk_types.CRecIsCanceled+'%''');
      add('     AND o.rec_deleted=''f''');
      add('INNER JOIN accounts a ON ');
      add('a.id=i.account_id');
      execSQL;



      // update jälle firebird stiilis !
      // 28.01.2011 Ingmar; ntx meil on arve GBP 1.253 kuupäev 12.12.2010; siis meil vaja teada kurssi GBP seisuga, millal tuli laekumine;
      Close;
      Clear;
      add(format('UPDATE %s', [pTableIncItems]));
      add('SET item_currency_ovr_idt=');
      add('(COALESCE((SELECT c.curr_rate FROM currency_exc c ');
      add(format('INNER JOIN %s l ON ', [pTableIncLines]));
      add(format('l.pguid=%s.pguid', [pTableIncItems]));
      add(format(' WHERE %s.item_currency<>%s AND c.curr_name=%s.item_currency AND c.curr_date=l.payment_date),0.00))',
        [pTableIncItems, QuotedStr(estbk_globvars.glob_baseCurrency), pTableIncItems]));
      execSQL;

      Close;
      Clear;
      add(format('UPDATE %s', [pTableIncItems]));
      add('SET item_currency_ovr_idt=1.00');
      add(format(' WHERE item_currency=%s', [QuotedStr(estbk_globvars.glob_baseCurrency)]));
      execSQL;

    finally
      Close;
      Clear;
    end;
end;


// 17.09.2011 Ingmar
procedure TIncomings_base.reUpdateCachedItems();
begin
  with self.FWorkerQry, SQL do
    try
      Close;
      Clear;
      add(format('UPDATE %s', [self.FTemptableIncomeItems]));
      // et oleks Firebird kompatiiblusega !
      add(format('SET paid=(SELECT b.incomesum FROM bills b WHERE b.id=%s.item_id),', [self.FTemptableIncomeItems]));
      add('to_pay=(SELECT ');
      add('CAST(b1.totalsum+b1.roundsum+b1.vatsum+b1.fine-b1.incomesum-b1.prepaidsum+b1.uprepaidsum AS ' +
        TEstbk_MapDataTypes.__MapMoneyType() + ')+');
      add('CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS ' + TEstbk_MapDataTypes.__MapMoneyType() + ')');
      add('FROM bills b1');
      add('LEFT OUTER JOIN  bills ccb ON ');
      add('ccb.id=b1.credit_bill_id');
      add(format('AND ccb.bill_type=%s', [QuotedStr(estbk_types._CItemCreditBill)]));
      add('AND ccb.status LIKE ''%C%''');
      add('AND ccb.rec_deleted=''f''');
      add(format('WHERE b1.id=%s.item_id)', [self.FTemptableIncomeItems]));
      add(format('WHERE item_type=%d', [CResolvedDataType_asBill]));
      execSQL;

    finally
      Close;
      Clear;
    end;
end;

procedure TIncomings_base.fetchItemPmtData(const pItemId: integer; const pItemType: integer; var pPaid: double; var pToPay: double);
begin
  pPaid := 0.00;
  pToPay := 0.00;
  with self.FWorkerQry, SQL do
    try
      Close;
      Clear;
      add(format('SELECT paid,to_pay FROM %s WHERE item_id=%d AND item_type=%d', [self.FTemptableIncomeItems, pItemId, pItemType]));
      Open;
      pPaid := FieldByName('paid').AsFloat;
      pToPay := FieldByName('to_pay').AsFloat;
    finally
      Close;
      Clear;
    end; // ---
end;

procedure TIncomings_base.addClientUnpaidItemsToBfrTable(const pTableIncLines: AStr; const pTableIncItems: AStr; const pClientId: integer = -1);
begin
  with self.FWorkerQry, SQL do
    try
      // #ARVED
      // esmalt tasumata arved !
      Close;
      Clear;
      add(format('INSERT INTO %s (%s)', [pTableIncItems, CItemsTemptableCommonFld]));
      // --
      add('SELECT  ');
      add(format('%d,b.id,b.bill_number,b.client_id,0.00,0.00,b.incomesum,', [CResolvedDataType_asBill]));

      // add('(CASE WHEN ');
      add('(');
      //add('   CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum-b.uprepaidsum AS '+TEstbk_MapDataTypes.__MapMoneyType()+')+');
      //add('   CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+')>0.00 THEN');
      // --  31.03.2011 Ingmar
      add('     CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum AS ' +
        TEstbk_MapDataTypes.__MapMoneyType() + ')+');
      add('     CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS ' + TEstbk_MapDataTypes.__MapMoneyType() + ')');
      add(') as to_pay,');
      //add(' ELSE ');
      //add('     CAST(0.00 AS '+TEstbk_MapDataTypes.__MapMoneyType()+')');
      //add(' END)  as to_pay,');
      add('b.currency,b.currency_drate_ovr,0.00,0.00,b.due_date,b.dc_account_id,');
      add('a.account_coding,a.default_currency,'''',0,CAST(''f'' AS ' + TEstbk_MapDataTypes.__MapModBoolean() + '),b.incomesum');
      add('FROM bills b ');

      // 28.03.2011
      add(' LEFT OUTER JOIN  bills ccb ON ');
      add('ccb.id=b.credit_bill_id');
      add(format('  AND ccb.bill_type=%s', [QuotedStr(estbk_types._CItemCreditBill)]));
      add('  AND ccb.status LIKE ''%C%''');
      add('  AND ccb.rec_deleted=''f''');

      add('INNER JOIN accounts a ON ');
      add('a.id=b.dc_account_id');



      // bugi; sama elementi ei tohi uuesti lisada !
      add('WHERE ');

      // kliendiga ei piira
      if pClientId = -1 then
        add(format('b.client_id IN (SELECT DISTINCT k.client_id FROM %s k)', [pTableIncLines]))
      else
        add(format('b.client_id=%d', [pClientId]));


      add(format('     AND b.company_id=%d', [estbk_globvars.glob_company_id]));
      add('     AND  NOT  b.payment_status LIKE ''%' + estbk_types.CBillPaymentOk + '%''');
      add('     AND  b.rec_deleted=''f''');
      add('     AND  b.status=''' + estbk_types.CRecIsClosed + '''');
      //add('     AND  NOT  b.status LIKE ''%'+estbk_types.CRecIsCanceled+'%''');



      add(format('AND NOT EXISTS(SELECT p.item_id FROM %s p WHERE p.client_id=b.client_id AND p.item_id=b.id AND p.item_type=%d)',
        [pTableIncItems, CResolvedDataType_asBill]));
      // add(format('   AND k.pguid=(SELECT k.pguid FROM %s fx WHERE fx.client_id=k.client_id AND fx.pguid<k.pguid)',[pTableIncLines]));

      add('    AND b.bill_type=''' + estbk_types._CItemSaleBill + '''');

      // -----------
      add('UNION');
      // -----------

      // #TELLIMUSED
      add('SELECT ');
      add(format('%d,o.id,o.order_nr,o.client_id,0.00,0.00,', [CResolvedDataType_asOrder]));
      add(' o.paid_sum,'); // tasutud

      add('CAST(');
      add(' (CASE WHEN (o.order_sum+o.order_roundsum+o.order_vatsum-o.paid_sum)<0 THEN 0'); // tasuda / ettemaks !
      add('  ELSE ');
      add('      o.order_sum+o.order_roundsum+o.order_vatsum-o.paid_sum ');
      add('  END) AS ' + TEstbk_MapDataTypes.__MapMoneyType() + ') as to_pay,');

      add(' o.currency,o.currency_drate_ovr,0.00,0.00,o.order_prp_due_date as due_date,');
      add(' a.id,a.account_coding,a.default_currency,'''',0,CAST(''f'' AS ' + TEstbk_MapDataTypes.__MapModBoolean() + '),0.00');
      add('FROM orders o');
      // tellimusel on alati ettemaksukonto ! tellimuse valuuta peaks ühtima konto valuutaga ?!
      add('INNER JOIN accounts a ON ');
      add(format('a.id=%d', [_ac.sysAccountId[estbk_types._accPrepayment]]));
      add('WHERE ');

      // kliendiga ei piira
      if pClientId = -1 then
        add(format('o.client_id IN (SELECT DISTINCT k.client_id FROM %s k)', [pTableIncLines]))
      else
        add(format('o.client_id=%d', [pClientId]));

      add(format('     AND o.company_id=%d', [estbk_globvars.glob_company_id]));
      add('     AND NOT  o.payment_status LIKE ''%' + estbk_types.COrderPaymentOk + '%''');
      add('     AND NOT  o.status LIKE ''%' + estbk_types.CRecIsCanceled + '%''');
      add('     AND o.rec_deleted=''f''');
      add(format('     AND NOT EXISTS(SELECT p.item_id FROM %s p WHERE p.client_id=o.client_id AND p.item_id=o.id AND p.item_type=%d)',
        [pTableIncItems, CResolvedDataType_asOrder]));
      // 28.02.2011 Ingmar
      add(format('     AND o.order_type=%s', [QuotedStr(estbk_types._COAsSaleOrder)])); // LAEKUMISED lähevad müügitellimusele !

      // --
      add('ORDER BY due_date ASC');
      execSQL;




      //close; clear; add('select * from '+pTableIncItems+' where item_nr=''756'''); open;
      //showmessage(floattostr(fieldbyname('item_currency_ovr').AsFloat)+' '+fieldbyname('item_id').AsString);


      // update jälle firebird stiilis !
      // 28.01.2011 Ingmar; ntx meil on arve GBP 1.253 kuupäev 12.12.2010; siis meil vaja teada kurssi GBP seisuga, millal tuli laekumine;
      Close;
      Clear;
      add(format('UPDATE %s', [pTableIncItems]));
      add('SET item_currency_ovr_idt=');
      add('(COALESCE((SELECT c.curr_rate FROM currency_exc c ');
      add(format('INNER JOIN %s l ON ', [pTableIncLines]));
      add(format('l.pguid=%s.pguid', [pTableIncItems]));
      add(format(' WHERE %s.item_currency<>%s AND c.curr_name=%s.item_currency AND c.curr_date=l.payment_date),0.00))',
        [pTableIncItems, QuotedStr(estbk_globvars.glob_baseCurrency), pTableIncItems]));
      execSQL;


      Close;
      Clear;
      add(format('UPDATE %s', [pTableIncItems]));
      add('SET item_currency_ovr_idt=1.00');
      add(format(' WHERE item_currency=%s', [QuotedStr(estbk_globvars.glob_baseCurrency)]));
      execSQL;


    finally
      Close;
      Clear;
    end;
end;

procedure TIncomings_base.markOkIncomingsAsVerified;
var
  pIncLinesTable: AStr;
begin
  pIncLinesTable := self.FTemptableIncomeLines;
  with self.FWorkerQry, SQL do
    try
      Close;
      Clear;
      add(format('UPDATE %s', [pIncLinesTable]));
      add(format('SET status=%s', [QuotedStr(estbk_types.CIncomeRecStatusClosed)]));
      add(format('WHERE errorcode=%d', [CDataOK]));
      add('  AND payment_sum>0.00');
      execSQL;
    finally
      Close;
      Clear;
    end;
end;


procedure TIncomings_base.loadIncomings(const pId: integer; const pIdAsSessionID: boolean = True);
var
  pIncLTempTable: AStr;
  pIncITempTable: AStr;
begin
  with self.FWorkerQry, SQL do
    try
      // otseselt see kontroll polegi vajalik !
      if pIdAsSessionID then
      begin
        Close;
        Clear;
        add(format('SELECT id FROM incomings_sessions WHERE id=%d AND company_id=%d', [pId, estbk_globvars.glob_company_id]));
        Open;

        if RecordCount < 1 then
          raise Exception.Create(estbk_strmsg.SEIncNotFound);
      end;

      // ----
      self.createTempIncomeTables(pIncLTempTable, pIncITempTable);


          (*
          CREATE TABLE test(
           id serial NOT NULL,
           guid uuid DEFAULT (md5(((currval('test_id_seq'::regclass) || ''::text) || now())))::uuid,
          ) WITH (OIDS=FALSE);

          *)

      Close;
      Clear;
      add(format('INSERT INTO %s( incomings_bank_id,bank_id,bank_code,bank_archcode,firstname,lastname,fullname,payer_refnumber,',
        [pIncLTempTable]));
      add('payer_mk_nr,payment_sum,payment_date,incoming_date,account_id,bank_bk_account_id,bank_bk_account_coding,');
      add('bank_account,bank_account_iban,currency,description,receiver_account_number,');
      add('currency_drate_ovr,errorcode,srcval,recnr,pguid,data,item_type,item_id,status,newrecord,client_id,acc_reg_id,service_charges)');

      // --- bank_bk_account_coding; pangaga seotud rp. konto !
      add('SELECT  b.id,b.bank_id,b.bank_code,b.bank_archcode,c.name,c.lastname,(CASE WHEN COALESCE(b.payer_name,'''') != '''' THEN b.payer_name ELSE c.name END) payer_name,b.payer_refnumber,');
      add('b.payer_mk_nr,b.payment_sum,b.payment_date,b.incoming_date,0,b.bank_bk_account_id,a.account_coding,');
      add('b.bank_account,b.bank_account_iban,b.currency,b.description,b.receiver_account_number,');
      add('b.currency_drate_ovr,0,0,0,'''','''',0,0,b.status,CAST(''f'' AS ' + TEstbk_MapDataTypes.__MapModBoolean() + '),b.client_id,');
      // 31.12.2010 Ingmar; hurraaaa täna öösel paneme euro asjad üles EEle...disaster
      // viide peakirjele on incomings juures !
      add('(SELECT MAX(i.accounting_register_id) FROM incomings i WHERE i.incomings_bank_id>0 AND NOT i.status LIKE ''%D%'' AND i.incomings_bank_id=b.id),');
      // 01.09.2011 Ingmar
      add('b.service_charges');
      add('FROM incomings_bank b');
      add('LEFT OUTER JOIN client c ON ');
      add('c.id=b.client_id');
      add('INNER JOIN accounts a ON ');
      add('a.id=b.bank_bk_account_id');
      add('WHERE ');
      if pIdAsSessionID then
        add(format(' b.incomings_session_id=%d', [pId]))
      else
        add(format(' b.id=%d', [pId]));

      add('ORDER BY b.id');
      execSQL;

      // laekumise nr / kande number !
      // jälle firebirdi kompatiibluse jaoks teeme jälle subselecti !
      Close;
      Clear;
      add(format('UPDATE %s', [pIncLTempTable]));
      add(format('SET acc_reg_incnr=(SELECT a.entrynumber FROM accounting_register a WHERE a.id=%s.acc_reg_id)', [pIncLTempTable]));
      execSQL;


      // TODO; see tõsiselt totakas koht ümber mõelda, see üliaeglane ja jabur !?!
      // Disaini viga, miks eelgenereeritud GUID andmebaasi ei pannud ! 4 üheaegset projekti hakkab vist ajudele...
      Close;
      Clear;
      add(format('SELECT incomings_bank_id FROM %s', [pIncLTempTable]));
      Open;
      First;



      self.FTempQry.Close;
      self.FTempQry.SQL.Clear;
      self.FTempQry.SQL.Add(format('UPDATE %s SET pguid=:pguid WHERE incomings_bank_id=:incomings_bank_id', [pIncLTempTable]));


      while not EOF do
      begin
        self.FTempQry.paramByname('incomings_bank_id').AsInteger := FieldByName('incomings_bank_id').AsInteger;
        self.FTempQry.paramByname('pguid').AsString := estbk_utilities.uGuid36;
        self.FTempQry.ExecSQL;

        Next;
      end; // ---

      // varem salvestatud laekumised
      self.addSavedItemsToBfrTable(pIncLTempTable, pIncITempTable);
      // ehk siis arved ja laekumised, millele pole veel laekumist märgitud !
      self.addClientUnpaidItemsToBfrTable(pIncLTempTable, pIncITempTable);
    finally
      Close;
      Clear;

      self.FTempQry.Close;
      self.FTempQry.SQL.Clear;
    end;
end;


procedure TIncomings_base.getClientUnpaidItems(const pClientId: integer; const pDeletePrvItems: boolean = False);
begin
  // 17.09.2011 Ingmar; vajadusel saame reseti teha elementidele
  if pDeletePrvItems then
    with self.FWorkerQry, SQL do
      try
        Close;
        Clear;
        add(format('DELETE FROM %s WHERE client_id=%d', [self.FTemptableIncomeItems, pClientId]));
        execSQL;
      finally
        Close;
        Clear;
      end;

  // # internal !
  addClientUnpaidItemsToBfrTable(FTemptableIncomeLines, FTemptableIncomeItems, pClientId);
end;

constructor TIncomings_base.Create(const pConnection: TZConnection);
begin
  FReportWriter := TStatusRepWriter.Create(pConnection, estbk_lib_rep_errorcodes.CID_IncomeFilesOp);
  // ---
  inherited Create(FReportWriter);

  // väljad, mis failis peavad kindlasti olema
  // 25.08.2011 Ingmar; eemaldasin fld_payer_name kohustulikkuse, asi selles, et intresside puhul maksa nimi puudub !
  FRequiredFields := [fld_payment_date, fld_payment_sum, fld_bank_archcode, fld_receiver_account_number];

  // 20.03.2011 Ingmar; fld_payer_account hetkel võtsin ära kohustuslikkuse, et laekumisel konto peab olema teada


  FWorkerQry := TZQuery.Create(nil);
  FWorkerQry.Connection := pConnection;

  FTempQry := TZQuery.Create(nil);
  FTempQry.Connection := pConnection;

  // ---
  FIncomeSessionSeq := TZSequence.Create(nil);
  FIncomeSessionSeq.Connection := pConnection;
  FIncomeSessionSeq.SequenceName := 'incomings_sessions_id_seq';

  //FImpFileSeq := TZSequence.Create(nil);
  //FImpFileSeq.Connection := pConnection;
  //FImpFileSeq.SequenceName := 'incomings_import_sessions_id_seq';
end;

destructor TIncomings_base.Destroy;
begin
  self.dropTempIncomeDataTables();

  FreeAndNil(FBankFileDefsColl);
  FreeAndNil(FReportWriter);
  FreeAndNil(FIncomeSessionSeq);
  FreeAndNil(FWorkerQry);
  FreeAndNil(FTempQry);
  //FreeAndNil(FImpFileSeq);
  inherited Destroy;
end;

end.