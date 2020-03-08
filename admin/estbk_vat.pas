unit estbk_vat;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, ExtCtrls, DBGrids, StdCtrls,
  DbCtrls, rxlookup, Controls, Buttons, estbk_utilities, estbk_datamodule,
  estbk_globvars, estbk_sqlcollection, estbk_types, estbk_lib_commonevents,
  estbk_strmsg, ZDataset, ZSequence, ZSqlUpdate, db, rxpopupunit,ZAbstractRODataset;

type

  { TframeVATs }

  TframeVATs = class(TFrame)
    dblComboVat_ipvat: TRxDBLookupCombo;
    ptrnVat50perc: TCheckBox;
    qryAccNVat: TDatasource;
    qryAccIVat: TDatasource;
    qryAccountsPurchVat: TZReadOnlyQuery;
    qryVatDs: TDatasource;
    lblSaleVat: TLabel;
    lblSaleVat1: TLabel;
    ptrnVat: TCheckBox;
    dbEdtVatName: TDBEdit;
    dbEdtVatPerc: TDBEdit;
    gridVat: TDBGrid;
    lblVatname: TLabel;
    lblVatPerc: TLabel;
    leftPanel: TPanel;
    qryWorker: TZQuery;
    rightPanel: TPanel;
    dblComboVat_svat: TRxDBLookupCombo;
    Splitter1: TSplitter;
    qryVat: TZQuery;
    qryAccountsSaleVat: TZReadOnlyQuery;
    dummy: TZUpdateSQL;
    procedure dbEdtVatPercKeyPress(Sender: TObject; var Key: char);
    procedure dbEdtVatNameKeyPress(Sender: TObject; var Key: char);
    procedure dblComboVat_svatClosePopupNotif(Sender: TObject);
    procedure dblComboVat_svatLookupTitleColClick(column: tcolumn);
    procedure dblComboVat_svatSelect(Sender: TObject);
    procedure ptrnVatChange(Sender: TObject);
    procedure qryAccountsSaleVatFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure qryVatAfterEdit(DataSet: TDataSet);
    procedure qryVatAfterScroll(DataSet: TDataSet);
    procedure qryVatBeforePost(DataSet: TDataSet);
  private
    FParentKeyNotif   : TKeyNotEvent;
    FDataChangedNotif : TNotifyEvent;
    // --
    FSkipScrollEvent : Boolean;
    FDataNotSaved : Boolean;
    FNewRecordCreated: Boolean;
    FCompanyId : Integer;
    procedure setCompanyId(const v: integer);
  public
    property  companyId    : integer read FCompanyId write setCompanyId;
    property  dataNotSaved : boolean read FDataNotSaved;

    // --------
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onDataChangeNotif    : TNotifyEvent read FDataChangedNotif write FDataChangedNotif;

    procedure triggerCancelEvent;
    procedure triggerSaveEvent;
    procedure triggerNewRecEvent;

  end; 

implementation
uses dialogs,variants;
{ TframeVATs }

procedure TframeVATs.dbEdtVatNameKeyPress(Sender: TObject; var Key: char);
var
     wctrl: TWinControl;
begin
  if key = #13 then
  begin
     wctrl := Sender as TWinControl;
     //    wctrl.FindNextControl();
     SelectNext(wctrl, True, True);
     key := #0;
  end;
end;

procedure TframeVATs.dbEdtVatPercKeyPress(Sender: TObject; var Key: char);
var
    wctrl: TWinControl;
begin

  if key = #13 then
  begin
       wctrl := Sender as TWinControl;
       //    wctrl.FindNextControl();
       SelectNext(wctrl, True, True);
       key := #0;
  end else
  if key='+' then
     key:=#0
  else
    estbk_utilities.edit_verifyNumericEntry(Sender as TCustomEdit,Key,true);
  //if  (ord(key)>=32) and ((not TDbEdit(Sender).Field.IsValidChar(key)) or (key='+')) then // ärme luba märke ! (key in  ['+','-']
  //     key:=#0;
end;

procedure TframeVATs.dblComboVat_svatClosePopupNotif(Sender: TObject);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeVATs.dblComboVat_svatLookupTitleColClick(column: tcolumn);
begin
  if assigned(column.Field) and assigned(column.Field.DataSet)  then
    begin

          TZQuery(column.Field.DataSet).SortedFields:=column.FieldName;
      if (column.ValueChecked='') or (column.ValueChecked='0') then
        begin
          TZQuery(column.Field.DataSet).SortType:=stAscending;
          column.ValueChecked:='1';
        end else
        begin
          TZQuery(column.Field.DataSet).SortType:=stDescending;
          column.ValueChecked:='0';
        end;
    end;
end;

procedure TframeVATs.triggerCancelEvent;
begin
  self.FDataNotSaved:=false;
  self.FNewRecordCreated:=false;
  qryVat.CancelUpdates;
end;

procedure TframeVATs.triggerSaveEvent;
var
  pVatSeqId : Integer;
  pDefVatStatus    : AStr;
  pCreateNewRec    : Boolean;
  pHistoryRec      : Integer; // baasekirje ajalugu tuleb jätkata !
  pBookmark        : TBookmark;
  pOrigUpdtStatus  : TUpdateStatusSet;
begin
 try
        self.FSkipScrollEvent:=true;

    if (qryVat.State in [dsInsert,dsEdit]) then
        qryVat.Post;


        qryVat.DisableControls;
        pBookmark:=qryVat.GetBookmark;

        // --------------------------------------------
        // esmalt leiame uued kirjed !

        pOrigUpdtStatus:=qryVat.ShowRecordTypes;
        qryVat.ShowRecordTypes:=[usInserted,usModified];
        qryVat.First;

 while  not qryVat.EOF do
     begin

                  pCreateNewRec:=false;
                  pHistoryRec:=0;
                  // TupdateSQL meid ei aitaks siin !
             case qryVat.UpdateStatus of
               usInserted : begin
                                pCreateNewRec:=true;
                            end;

               // nüüd peame vaatama, mis ikka reaalselt muutus !!!
               // kui lihtsalt muutus nimetus, siis me ei tee uut käibemaksu kirjet !
               usModified : begin
                                // ilma vartostr võrdluseta tekkisid variant vead !
                                pCreateNewRec:=(vartostr(qryVat.FieldByName('vat_account_id_s').oldValue)<>
                                                vartostr(qryVat.FieldByName('vat_account_id_s').newValue)) or

                                               (vartostr(qryVat.FieldByName('vat_account_id_i').oldValue)<>
                                                vartostr(qryVat.FieldByName('vat_account_id_i').newValue)) or

                                               (vartostr(qryVat.FieldByName('vat_account_id_p').oldValue)<>
                                                vartostr(qryVat.FieldByName('vat_account_id_p').newValue)) or

                                               (vartostr(qryVat.FieldByName('vatflags').oldValue)<>
                                                vartostr(qryVat.FieldByName('vatflags').newValue)) or

                                               (vartostr(qryVat.FieldByName('oprc').oldValue)<>
                                                vartostr(qryVat.FieldByName('oprc').newValue));

                                // ---
                                qryWorker.Close;
                                qryWorker.SQL.Clear;


                                // vana väärtus siin juba kadunud !
                                // showmessage(qryVat.FieldByName('perc').asString+' x '+vartostr(qryVat.FieldByName('perc').value)+' '+vartostr(qryVat.FieldByName('perc').newValue)+' '+
                                // vartostr(qryVat.FieldByName('perc').oldValue));


                            // muutusid kriitilised parameetrid, tuleb tekitada uus käibemaksu kirje !
                            if  pCreateNewRec then
                              begin
                                 qryWorker.SQL.add(estbk_sqlcollection._SQLUpdtasVatPreviousRec);
                              if qryVat.FieldByName('base_rec_id').AsInteger=0 then
                                 pHistoryRec:=qryVat.FieldByName('id').asInteger
                              else
                                 pHistoryRec:=qryVat.FieldByName('base_rec_id').asInteger;
                              end else
                              begin
                                 qryWorker.SQL.add(estbk_sqlcollection._SQLUpdtVatDescr);
                                 qryWorker.parambyname('description').AsString:=qryVat.FieldByName('description').AsString;
                              end;


                                 // ---
                                 qryWorker.parambyname('id').asInteger:=qryVat.FieldByName('id').AsInteger;
                                 qryWorker.parambyname('rec_changed').asDatetime:=now;
                                 qryWorker.parambyname('rec_changedby').asInteger:=estbk_globvars.glob_worker_id;
                                 qryWorker.execSQL;

                            end;
             end;

         // ---
         if pCreateNewRec then
           begin
                      // ---
                      qryWorker.Close;
                      qryWorker.SQL.Clear;
                      qryWorker.SQL.add(estbk_sqlcollection._SQLInsertNewVATZValue2);

                      // -- omistame ise ID; ilma automaatse seq abimeheta
                      pVatSeqId:=admDatamodule.qryVatSeq.GetNextValue;
                      // --
                      qryVat.Edit;
                      qryVat.FieldByName('id').AsInteger:=pVatSeqId;
                      qryVat.Post;

                      // kirjutame baasi ära
                      qryWorker.parambyname('id').asInteger:=pVatSeqId;
                      qryWorker.parambyname('description').asString:=qryVat.FieldByName('description').AsString;
                      qryWorker.parambyname('perc').AsCurrency:=qryVat.FieldByName('oprc').AsCurrency;
                      qryWorker.parambyname('country_code').asString:=estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;

                      // vaikimise käibemaks, ntx meil 20%
                      pDefVatStatus:=trim(qryVat.FieldByName('defaultvat').asString);
                  if  pDefVatStatus='' then
                      pDefVatStatus:=estbk_types.SCFalseTrue[false];


                      // 26.06.2010 ingmar
                      // fix; miskitpärast paneb zeos true puhul str väärtuseks True;False;
                      pDefVatStatus:=copy(pDefVatStatus,1,1);


                      // kontod ka paika !
                      qryWorker.parambyname('vat_account_id_s').asInteger:=qryVat.FieldByName('vat_account_id_s').asInteger;
                      qryWorker.parambyname('vat_account_id_i').asInteger:=qryVat.FieldByName('vat_account_id_i').asInteger;
                      qryWorker.parambyname('vat_account_id_p').asInteger:=qryVat.FieldByName('vat_account_id_p').asInteger;


                      qryWorker.parambyname('defaultvat').asString:=pDefVatStatus;
                      qryWorker.parambyname('flags').asInteger:=qryVat.FieldByName('vatflags').asInteger;  //qryVat.FieldByName('vatflags').asInteger;




                  if  pHistoryRec=0 then
                      pHistoryRec:=pVatSeqId;


                      // --
                      qryWorker.parambyname('base_rec_id').asInteger:=pHistoryRec;

                      qryWorker.parambyname('rec_changed').asDatetime:=now;
                      qryWorker.parambyname('rec_changedby').asInteger:=estbk_globvars.glob_worker_id;
                      qryWorker.parambyname('rec_addedby').asInteger:=estbk_globvars.glob_worker_id;

                      qryWorker.parambyname('company_id').asInteger:=self.FCompanyId;
                      qryWorker.execSQL;

           end;


          // ----
          qryVat.Next;
     end;


 finally

        qryVat.CommitUpdates;
        //qryVat.ApplyUpdates;


        qryVat.ShowRecordTypes:=pOrigUpdtStatus;
        qryVat.EnableControls;
        qryVat.Refresh;

     // ---
     if assigned(pBookmark) then
       begin
        qryVat.GotoBookmark(pBookmark);
        qryVat.FreeBookmark(pBookmark);
       end;





        // --
        self.FSkipScrollEvent:=false;

        qryWorker.Close;
        qryWorker.SQL.Clear;
        // ---


        dblComboVat_svat.Value:=qryVat.FieldByName('vat_account_id_s').asString;
        dblComboVat_ipvat.Value:=qryVat.FieldByName('vat_account_id_i').asString;
 end;


  self.FDataNotSaved:=false;
  self.FNewRecordCreated:=false;
end;

procedure TframeVATs.triggerNewRecEvent;
begin
   qryVat.First;
   qryVat.Insert;
   // ----
   self.FDataNotSaved     := True;
   self.FNewRecordCreated := True;

if assigned(onDataChangeNotif) then
   onDataChangeNotif(self);

if dbEdtVatName.CanFocus then
   dbEdtVatName.SetFocus;


end;

procedure TframeVATs.dblComboVat_svatSelect(Sender: TObject);
begin
  // --
end;

procedure TframeVATs.ptrnVatChange(Sender: TObject);
var
   pNewSess  : Boolean;
   pVatFlags : Integer;
begin
  // kuna meil multiplatvormne kood; siis tdbcheckbox ei tööta, osades backendides pole lihtsalt booleani !
  with TCheckbox(sender) do
  if Focused then
   try

      pNewSess:=not (qryVat.State in [dsInsert,dsEdit]);
   if pNewSess then
      qryVat.Edit;
      pVatFlags:=qryVat.FieldByName('vatflags').AsInteger;

   // 19.04.2015 Ingmar
   if Sender = ptrnVat then // pöördkäibemaks
     case Checked of
       true  : pVatFlags:=pVatFlags or estbk_types._CVtmode_turnover_tax;
       false : pVatFlags:=pVatFlags and not estbk_types._CVtmode_turnover_tax;
     end else
   if Sender = ptrnVat50perc then
     case Checked of
      true  : pVatFlags:=pVatFlags or estbk_types._CVtmode_carVAT50;
      false : pVatFlags:=pVatFlags and not estbk_types._CVtmode_carVAT50;
     end;





   // 06.04.2011 ingmar; Ei arvesta...
   if qryVat.FieldByName('oprc').AsFloat<0 then
      pVatFlags:=pVatFlags or estbk_types._CVtmode_dontAdd
   else
      pVatFlags:=pVatFlags and not estbk_types._CVtmode_dontAdd;

      // @@@
      qryVat.FieldByName('vatflags').AsInteger:=pVatFlags;
   finally

   if pNewSess then
      qryVat.Post;
   end;
end;



procedure TframeVATs.qryAccountsSaleVatFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept:=(DataSet.FieldByName('flags').asInteger and CAccFlagsClosed)<>CAccFlagsClosed;
end;

procedure TframeVATs.qryVatAfterEdit(DataSet: TDataSet);
begin
 if self.FSkipScrollEvent then
    exit;


 if assigned(onDataChangeNotif) then
    onDataChangeNotif(self);
    self.FDataNotSaved := True;
end;

procedure TframeVATs.qryVatAfterScroll(DataSet: TDataSet);
begin
 if self.FSkipScrollEvent or DataSet.eof then
    Exit;

    // pöördkäibemaksu tunnus
    ptrnVat.Checked := (DataSet.FieldByname('vatflags').AsInteger and estbk_types._CVtmode_turnover_tax)=_CVtmode_turnover_tax;
    // 18.04.2015 Ingmar; autokäibemaks
    ptrnVat50perc.Checked := (DataSet.FieldByname('vatflags').AsInteger and estbk_types._CVtmode_carVAT50)=_CVtmode_carVAT50;

    // midagi imelikku lookup ei tööta õigesti scrollimisel
    // dblComboVat_svat.Value:=DataSet.FieldByname('vat_account_id_s').asString;
    // dblComboVat_ipvat.Value:=DataSet.FieldByname('vat_account_id_i').asString;
    // Memo1.Lines.add(format('%s %s',[DataSet.FieldByname('vat_account_id_s').asString,DataSet.FieldByname('vat_account_id_i').asString]));
end;

procedure TframeVATs.qryVatBeforePost(DataSet: TDataSet);
begin
 if self.FSkipScrollEvent then
    Exit;

 // 06.04.2011 Ingmar; igasugune negatiivse märgiga KM, siis seda käibemaksu ei arvestata; programmis konverteeritakse see neg number 0 peale !
 // Negatiivsus pigem nö marker !
 {
 if (DataSet.fieldbyname('oprc').AsFloat<0) or  (DataSet.fieldbyname('oprc').AsFloat>100) then
    begin
     if dbEdtVatPerc.CanFocus then
        dbEdtVatPerc.SetFocus;

        dialogs.messageDlg(estbk_strmsg.SEVATPercIsnotValid,mterror,[mbOk],0);
        abort;
    end;
  }

  if (trim(DataSet.fieldbyname('description').AsString)='') then
    begin
     if dbEdtVatName.CanFocus then
        dbEdtVatName.SetFocus;

        dialogs.messageDlg(estbk_strmsg.SEVATNameIsTooShort,mterror,[mbOk],0);
        abort;
    end;



end;



procedure TframeVATs.setCompanyId(const v: integer);
begin

  self.FCompanyId := v;
  if v > 0 then
  begin

    try
      self.FSkipScrollEvent := True;
      qryVat.Close;
      qryVat.SQL.Clear;

      qryVat.SQL.add(estbk_sqlcollection._CSQLGetVAT);
      qryVat.paramByName('company_id').AsInteger := v;
      qryVat.Open;



      qryAccountsSaleVat.Filtered:=false;
      qryAccountsSaleVat.Close;
      qryAccountsSaleVat.SQL.Clear;

      qryAccountsSaleVat.SQL.add(estbk_sqlcollection._CSQLGetAllAccounts);
      qryAccountsSaleVat.paramByName('company_id').AsInteger := v;
      qryAccountsSaleVat.Open;
      qryAccountsSaleVat.Filtered:=true;


      // miskitpärast läks kogu lookupcombondus lolliks, kui oli üks query ja selle küljes N+1 datasetti :(
      qryAccountsPurchVat.Filtered:=false;
      qryAccountsPurchVat.Close;
      qryAccountsPurchVat.SQL.Clear;
      //qryAccountsPurchVat.Connection:=estbk_datamodule.admDatamodule.admConnection;

      qryAccountsPurchVat.SQL.add(estbk_sqlcollection._CSQLGetAllAccounts);
      qryAccountsPurchVat.paramByName('company_id').AsInteger := v;
      qryAccountsPurchVat.Open;
      qryAccountsPurchVat.Filtered:=true;





      // ------------
      estbk_utilities.changeWCtrlEnabledStatus(self, not qryVat.EOF);
      self.Enabled := True;

    finally
      self.FSkipScrollEvent := False;
      qryVat.First;
    end;
    // ----

  end;

  self.FDataNotSaved     := False;
  self.FNewRecordCreated := False;
end;

initialization
  {$I estbk_vat.ctrs}

end.

