unit estbk_accperiods;

{$mode objfpc}{$H+}
//{$i estbk_defs.inc}
// 06.11.2009 Ingmar
// üldiselt ülejäänud adminni osad tuleb ka framede peale ehitada !
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, Buttons,
  DBGrids, DBCtrls, EditBtn,
  estbk_datamodule, estbk_sqlcollection,
  estbk_types, Graphics, LCLType, estbk_lib_commonevents,
  estbk_utilities, estbk_globvars, estbk_strmsg, DB, estbk_frm_numerators,
  ZDataset, ZSequence, ZSqlUpdate, Controls, ExtCtrls, Grids;
//RTTICtrls
type

  { TframeAccPeriods }

  TframeAccPeriods = class(TFrame)
    accEntrys: TDBGrid;
    pchkboxAccPer: TCheckBox;
    dbChkBoxClose: TCheckBox;
    dbEdtPerName: TDBEdit;
    dtEdtEnd: TDateEdit;
    dtEdtStart: TDateEdit;
    lblDateEnd: TLabel;
    lblDateStart: TLabel;
    lblPerName: TLabel;
    mrline3: TBevel;
    mrline4: TBevel;
    qryAccPeriodsDS: TDatasource;
    qryAccPeriods: TZQuery;
    qryAccPeriodsSeq: TZSequence;
    qryAccPeriodsUpdSQL: TZUpdateSQL;
    qryVerifySQL: TZQuery;
    procedure accEntrysCellClick(Column: TColumn);
    procedure accEntrysDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure accEntrysEditButtonClick(Sender: TObject);
    procedure accEntrysKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure accEntrysSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
    procedure dbChkBoxCloseClick(Sender: TObject);
    procedure dbEdtPerNameKeyPress(Sender: TObject; var Key: char);
    procedure dtEdtEndAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure dtEdtStartExit(Sender: TObject);
    procedure pchkboxAccPerChange(Sender: TObject);
    procedure qryAccPeriodsAfterCancel(DataSet: TDataSet);
    procedure qryAccPeriodsAfterEdit(DataSet: TDataSet);
    procedure qryAccPeriodsAfterInsert(DataSet: TDataSet);
    procedure qryAccPeriodsAfterScroll(DataSet: TDataSet);
    procedure qryAccPeriodsBeforeDelete(DataSet: TDataSet);
    procedure qryAccPeriodsBeforeScroll(DataSet: TDataSet);
  private
    //FFrameKillSignal:  TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FDataChangedNotif: TNotifyEvent;

    //FLastMaxPeriodDt: TDate;
    //FLastMaxPeriodDtSval: TDate;
    // kui tühistatakse sisestus saame vana väärtuse taastada !!!! pigem qry skännimine oleks väga väga väga tobe
    // ---
    FPriorEndDate: TDateTime; // eelmise elemendi viimane kuupäev
    fSkipDateEventHand: boolean;
    FSkipScrollEvent: boolean;
    FDataNotSaved: boolean;
    FNewRecordCreated: boolean;
    FCompanyId: integer;
    procedure callNumEditor;
    procedure generateNumerators;
    function verifyRecord(const ds: TDataset; const verifName: boolean = True): boolean;
    procedure setCompanyId(const v: integer);
  public
    property companyId: integer read FCompanyId write setCompanyId;
    property dataNotSaved: boolean read FDataNotSaved;
    // --------
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onDataChangeNotif: TNotifyEvent read FDataChangedNotif write FDataChangedNotif;

    procedure triggerCancelEvent;
    procedure triggerSaveEvent;
    procedure triggerNewRecEvent;


    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation



uses Dialogs, dateutils;

const
  CDaysInYear = 365;
  CCol_name = 0;
  CCol_start = 1;
  CCol_end = 2;
  CCol_status = 3;
  CCol_numVals = 4;


constructor TframeAccPeriods.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  //estbk_uivisualinit.__preparevisual(self);
  // ---


  // ---------
  qryAccPeriodsSeq.SequenceName := 'accounting_period_id_seq';
  qryAccPeriodsSeq.connection := estbk_datamodule.admDatamodule.admConnection;

  qryAccPeriods.SequenceField := 'id';
  qryAccPeriods.connection := estbk_datamodule.admDatamodule.admConnection;
  qryVerifySQL.connection := estbk_datamodule.admDatamodule.admConnection;

  qryAccPeriodsUpdSQL.InsertSQL.Clear;
  qryAccPeriodsUpdSQL.InsertSQL.Add(estbk_sqlcollection._SQLInsertNewAccPer);

  qryAccPeriodsUpdSQL.ModifySQL.Clear;
  qryAccPeriodsUpdSQL.ModifySQL.Add(estbk_sqlcollection._SQLUpdateAccPer);

  qryAccPeriodsUpdSQL.deleteSQL.Clear;
  qryAccPeriodsUpdSQL.deleteSQL.Add(estbk_sqlcollection._SQLDeleteAccPer);
end;

destructor TframeAccPeriods.Destroy;
begin
  inherited Destroy;
end;


procedure TframeAccPeriods.dtEdtStartExit(Sender: TObject);
var
  fVdate: TDatetime;
  fDateStr: AStr;
  pOpenRec: boolean;
begin

  if not self.fSkipDateEventHand then
    try
      self.fSkipDateEventHand := True;
      // ---
      fVdate := Now;
      fDateStr := trim(TDateEdit(Sender).Text);


      if (fDateStr <> '') then
        if not validateMiscDateEntry(fDateStr, fVDate) then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);

          if TDateEdit(Sender).CanFocus then
            TDateEdit(Sender).SetFocus;
          exit;
        end
        else
          TDateEdit(Sender).Text := datetostr(fVDate);


      // ---
      if qryAccPeriods.active then // and TDateEdit(Sender).focused
        try
          self.FSkipScrollEvent := True;
          pOpenRec := not (qryAccPeriods.State in [dsInsert, dsEdit]);
          if pOpenRec then
            qryAccPeriods.Edit;



          // esmalt teeme lihtkontrolli; taastame vana väärtuse - tühja väärtust lihtsalt ei luba !
          if (fDateStr = '') then
          begin
            if Sender = self.dtEdtStart then
            begin
              TDateEdit(Sender).Date := qryAccPeriods.FieldByName('period_start').AsDateTime;
              TDateEdit(Sender).Text := datetostr(qryAccPeriods.FieldByName('period_start').AsDateTime);
            end
            else
            // ---
            if not qryAccPeriods.FieldByName('period_end').isNull then
            begin
              TDateEdit(Sender).Date := qryAccPeriods.FieldByName('period_end').AsDateTime;
              TDateEdit(Sender).Text := datetostr(qryAccPeriods.FieldByName('period_end').AsDateTime);
            end;
          end
          else
          if Sender = self.dtEdtStart then
            qryAccPeriods.FieldByName('period_start').AsDateTime := fVDate
          else
            qryAccPeriods.FieldByName('period_end').AsDateTime := fVDate;


        finally
          if pOpenRec then
            qryAccPeriods.Post;

          self.FSkipScrollEvent := False;
        end;

      self.accEntrys.Repaint;
      // -------

    finally
      self.fSkipDateEventHand := False;
    end;
end;

procedure TframeAccPeriods.pchkboxAccPerChange(Sender: TObject);
var
  b: boolean;

begin

  if Tcheckbox(Sender).Focused and (Tcheckbox(Sender).tag = -1) then
    try
      Tcheckbox(Sender).tag := 1;
      if Tcheckbox(Sender).Checked then
        try

          if (qryAccPeriods.RecordCount > 0) and (Dialogs.messageDlg(estbk_strmsg.SCNumeratorConversions, mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
          begin
            Tcheckbox(Sender).Checked := False;
            Exit;
          end;

          // -- peame olemasoleva rp. aasta ennem ära salvestama !
          if qryAccPeriods.FieldByName('id').AsInteger <= 0 then
          begin

            Dialogs.messageDlg(estbk_strmsg.SCSaveAccPeriod, mtError, [mbOK], 0);
            Tcheckbox(Sender).Checked := not Tcheckbox(Sender).Checked;
            Exit;
          end; // --

          admDatamodule.admConnection.StartTransaction; // -- !!!

          qryVerifySQL.Close;
          qryVerifySQL.SQL.Clear;
          qryVerifySQL.SQL.Text := estbk_sqlcollection._SQLStaticNumToAccPerTypeNum(self.FCompanyId);
          qryVerifySQL.ExecSQL;

          // -- ja loome nüüd ka kirje, mis näitab, et meil nüüd firma numeraatorid maj. aasta põhised !
          qryVerifySQL.Close;
          qryVerifySQL.SQL.Clear;
          qryVerifySQL.SQL.Text := estbk_sqlcollection._SQLInsertAPCtype;
          qryVerifySQL.ParamByName('company_id').AsInteger := self.FCompanyId;
          qryVerifySQL.ExecSQL;

          Tcheckbox(Sender).Enabled := False;
          accEntrys.Columns.Items[CCol_numVals].Visible := True;

          admDatamodule.admConnection.Commit; // ---

        except
          on e: Exception do
          begin
            if admDatamodule.admConnection.InTransaction then
              try
                admDatamodule.admConnection.Rollback;
              except
              end;
            // ---
            Dialogs.MessageDlg(format(estbk_strmsg.SESaveFailed, [e.Message]), mtError, [mbOK], 0);
          end;
        end;

      // --
    finally
      Tcheckbox(Sender).tag := -1;
      qryVerifySQL.Close;
      qryVerifySQL.SQL.Clear;
      // --
    end;
end;

procedure TframeAccPeriods.qryAccPeriodsAfterCancel(DataSet: TDataSet);
begin

  // lipud maha
  self.FDataNotSaved := False;
  self.FNewRecordCreated := False;

  // ------------------
  //btnNew.Enabled    := True;
  //btnSave.Enabled   := False;
  //btnCancel.Enabled := False;

  dtEdtStart.Enabled := False;
  dtEdtEnd.Enabled := False;
  dbChkBoxClose.Enabled := True;

  if accEntrys.CanFocus then
    accEntrys.SetFocus;
end;


procedure TframeAccPeriods.qryAccPeriodsAfterScroll(DataSet: TDataSet);
var
  pBookMark: TBookMark;
  pOpenRec: boolean;
  pDtEnd: TDatetime;
begin

  if DataSet.Active and not FSkipScrollEvent then
    try

      dtEdtStart.date := now;
      dtEdtStart.Text := '';
      dtEdtEnd.date := now;
      dtEdtEnd.Text := '';


      pBookMark := DataSet.GetBookmark;
      Dataset.DisableControls;

      //self.FPriorEndDate:=now;
      self.FSkipScrollEvent := True;

      //Dataset.Prior;
      // ---

      if not DataSet.FieldByName('period_end').isNull then
        self.FPriorEndDate := DataSet.FieldByName('period_end').AsDateTime;
      Dataset.Next;



      if not Dataset.EOF then
      begin

        // -- peame eelmisele majandusaastale siis panema lõpu kuupäeva
        if DataSet.FieldByName('period_end').isNull then
        begin

          // 15.07.2012 Ingmar; arvesta ka sellega, et olemas liigaastad !
          if dateutils.DaysBetween(DataSet.FieldByName('period_start').AsDateTime, dateutils.StartOfAYear(
            YearOf(DataSet.FieldByName('period_start').AsDateTime))) = 0 then
            pDtEnd := dateutils.EndOfAYear(YearOf(DataSet.FieldByName('period_start').AsDateTime))
          else
            pDtEnd := dateutils.incDay(DataSet.FieldByName('period_start').AsDateTime, CDaysInYear); // ?!? kas see tõesti korrektne
          // --
          if self.FNewRecordCreated then
          begin
            // 15.07.2012 Ingmar; milleks see vajalik oli ?
            //pDtEnd := pDtEnd - 1;
            DataSet.Edit;
            DataSet.FieldByName('period_end').AsDateTime := pDtEnd;
            DataSet.Post;
          end; // ---



          // ---
          self.FPriorEndDate := pDtEnd;
        end
        else
          self.FPriorEndDate := DataSet.FieldByName('period_end').AsDateTime;
      end;
      //Label1.caption:=datetostr(self.FPriorEndDate);

    finally

      DataSet.GotoBookmark(pBookMark);
      if self.FNewRecordCreated then
      begin
        DataSet.First;


        // ---
        pOpenRec := not (DataSet.State in [dsEdit, dsInsert]);
        if pOpenRec then
          DataSet.Edit;


        DataSet.FieldByName('period_start').AsDateTime := self.FPriorEndDate + 1;
        if pOpenRec then
          DataSet.Post;
      end;

      // ---
      Dataset.EnableControls;
      // ----------

      //      pBtn:=accEntrys.EditorByStyle( cbsButton) as TButton;
      //   if assigned(pBtn) and accEntrys.Focused and pBtn.CanFocus then
      //   if pBtn.CanFocus then
      //      pBtn.SetFocus;
      //      pBtn.Caption:='...';


      dtEdtStart.Enabled := DataSet.RecordCount = 1;
      dtEdtEnd.Enabled := self.FNewRecordCreated or (DataSet.RecordCount = 1) or
        (DataSet.RecNo = 1) or (not DataSet.EOF and
        DataSet.FieldByName('period_end').IsNull);
      // viimane aktiivne kirje !
      // ---
      //btnSave.Enabled:=self.FDataNotSaved;
      //btnCancel.Enabled:=self.FDataNotSaved;

      if not DataSet.EOF then
      begin
        dtEdtStart.date := DataSet.FieldByName('period_start').AsDateTime;
        if not self.FNewRecordCreated then
        begin

          if not DataSet.FieldByName('period_end').isNull then
          begin
            dtEdtEnd.date := DataSet.FieldByName('period_end').AsDateTime;
            dtEdtEnd.Text := datetostr(dtEdtEnd.date);
          end;
          // ---
        end
        else
        begin
          dtEdtEnd.date := now;
          dtEdtEnd.Text := '';
        end;

        // ---
      end;



      dbChkBoxClose.Enabled := not self.FNewRecordCreated;
      dbChkBoxClose.Checked := AnsiUpperCase(DataSet.FieldByName('status').AsString) = 'C';

      self.FSkipScrollEvent := False;
      //accEntrys.SelectedIndex:=accEntrys.Columns.Items[4].Index;
      //accEntrys.SelectedColumn:=accEntrys.Columns.Items[4];
    end;// ---

end;

procedure TframeAccPeriods.qryAccPeriodsBeforeDelete(DataSet: TDataSet);
begin
  //      if  not (qryAccPeriods.state in [dsEdit,dsInsert]) then
end;


procedure TframeAccPeriods.qryAccPeriodsBeforeScroll(DataSet: TDataSet);
begin
  // ----- küsime salvestuse kohta !!!
  if not self.FSkipScrollEvent and self.FDataNotSaved then
  begin
    // kontrollid läbiti, aga nüüd peame ka kuvama dialoogi, et andmed salvestataks !!
    Dialogs.messageDlg(estbk_strmsg.SConfBfScrollSaveChg, mtInformation, [mbOK], 0);
    // self.verifyRecord(Dataset);
    abort;
  end;
end;

procedure TframeAccPeriods.qryAccPeriodsAfterEdit(DataSet: TDataSet);
begin
  DataSet.FieldByName('rec_changed').AsDateTime := now;
  DataSet.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  DataSet.FieldByName('company_id').AsInteger := self.FCompanyId;
  //estbk_globvars.glob_company_id;
  // --
  // if not self.FSkipScrollEvent then
  begin

    if assigned(onDataChangeNotif) then
      onDataChangeNotif(self);
    // ----
    self.FDataNotSaved := True;

  end;

  //self.btnSave.Enabled:=true;
  //self.btnCancel.Enabled:=true;
end;

procedure TframeAccPeriods.qryAccPeriodsAfterInsert(DataSet: TDataSet);
begin

  DataSet.FieldByName('status').AsString := 'O';
  // -----------
  DataSet.FieldByName('rec_changed').AsDateTime := now;
  DataSet.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  DataSet.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
  DataSet.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  DataSet.FieldByName('company_id').AsInteger := self.FCompanyId;
  //estbk_globvars.glob_company_id;




  // marker püsti, kui cancel tehakse, siis lihtsam taastada eelmist seisu
  self.dbChkBoxClose.Enabled := False;
  self.dbChkBoxClose.Checked := False;

  estbk_utilities.changeWCtrlEnabledStatus(self, True);

  // ----
  self.FDataNotSaved := True;
  self.FNewRecordCreated := True;

  if assigned(onDataChangeNotif) then
    onDataChangeNotif(self);
end;

procedure TframeAccPeriods.dbEdtPerNameKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeAccPeriods.dtEdtEndAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
begin

  TDateEdit(Sender).Text := datetostr(ADate);
  self.dtEdtStartExit(Sender);
  AcceptDate := True;
end;



procedure TframeAccPeriods.setCompanyId(const v: integer);
var
  b: boolean;
begin

  self.FCompanyId := v;
  if v > 0 then
  begin

    try
      self.FSkipScrollEvent := True;
      qryAccPeriods.Close;
      qryAccPeriods.SQL.Clear;

      qryAccPeriods.SQL.add(estbk_sqlcollection._SQLGetAccListODesc);
      qryAccPeriods.paramByName('company_id').AsInteger := v;
      //     qryAccPeriods.FieldDefs.Add('statusdescr',ftString,25);
      //     qryAccPeriods.FieldByName('statusdescr').DataType:=ftString;
      //     qryAccPeriods.FieldByName('statusdescr').Size:=25;
      qryAccPeriods.Open;
      // ------------
      estbk_utilities.changeWCtrlEnabledStatus(self, not qryAccPeriods.EOF);
      self.Enabled := True;



      dtEdtStart.date := now;
      dtEdtStart.Text := '';

      dtEdtEnd.date := now;
      dtEdtEnd.Text := '';

      //btnNewPeriod.Enabled:=true;
      self.FPriorEndDate := now - 1;
      // ---
      // 06.04.2012 Ingmar; peame ka kontrollima, kas numeraatorid majandusaasta põhised,
      // kui jah, siis märgistame checkboxi / samas ka disableme !
      // pchkboxAccPer

      with qryVerifySQL, SQL do
        try
          Close;
          Clear;
          add(estbk_sqlcollection._SQLSelectACPVar);
          paramByname('company_id').AsInteger := v;
          Open;
          b := (FieldByName('var_val').AsString = '1');
        finally
          Close;
          Clear;
        end;

      // @@@
      pchkboxAccPer.Enabled := not b;
      pchkboxAccPer.Checked := b;
      accEntrys.Columns.Items[accEntrys.Columns.Count - 1].Visible := b;

    finally
      self.FSkipScrollEvent := False;
      qryAccPeriods.First;

      //self.qryAccPeriodsAfterScroll(qryAccPeriods);
    end;
    // ----

  end;

  // lipp maha !!
  self.FDataNotSaved := False;
  self.FNewRecordCreated := False;

end;

function TframeAccPeriods.verifyRecord(const ds: TDataset; const verifName: boolean = True): boolean;
begin
  Result := False;
  with ds do
  begin
    if ds.EOF then
      exit;


    // --- jama ikka ei luba sisestada !!!
    if not FieldByName('period_end').isNull and (FieldByName('period_start').AsDateTime > FieldByName('period_end').AsDateTime) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEStartDateQtEndDate, mtError, [mbOK], 0);

      if self.dtEdtStart.CanFocus then
        self.dtEdtStart.SetFocus;

      abort;
    end;


    //if (ds.RecordCount>1) and (FieldByName('period_start').AsDateTime <> dateutils.incDay(self.FPriorEndDate, 1)) then
    if (ds.RecNo <> ds.RecordCount) and (dateutils.DaysBetween(FieldByName('period_start').AsDateTime,
      dateutils.incDay(self.FPriorEndDate, 1)) <> 0) then
      //      (FieldByName('period_start').AsDateTime <> dateutils.incDay(self.FPriorEndDate, 1)) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEAccStartPerLtMaxPer, mtError, [mbOK], 0);

      if self.dtEdtStart.Canfocus then
        self.dtEdtStart.SetFocus;

      abort;
    end;
  {
  Küsimus selline, et miks ei saa lisada majandusaastat, mis on pikem kui 12 kuud? Asutamisel nt võib majandusaasta pikkuseks olla kuni 18 kuud.
}

    if not FieldByName('period_end').isNull and (dateUtils.MonthsBetween(FieldByName('period_end').AsDateTime,
      FieldByName('period_start').AsDateTime) > 18) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEAccPeriodLgThen, mtError, [mbOK], 0);
      if self.dtEdtEnd.CanFocus then
        self.dtEdtEnd.SetFocus;

      abort;
    end;


    if verifName and (trim(FieldByName('accname').AsString) = '') then
    begin
      Dialogs.messageDlg(estbk_strmsg.SENameIsMissing, mtError, [mbOK], 0);
      if self.dbEdtPerName.CanFocus then
        self.dbEdtPerName.SetFocus;

      abort;
    end;

    // ---
    Result := True;
  end;
end;



procedure TframeAccPeriods.dbChkBoxCloseClick(Sender: TObject);
var
  pStat: AStr;
  pOpenrec: boolean;
begin
{
   if TCheckbox(Sender).checked then
    if dialogs.MessageDlg(estbk_clientstrmsg.SConfCloseAccRecord,
                          mtConfirmation,
                          [mbYes,MbNo],0)=mrYes then
}
  if TCheckbox(Sender).Focused then
    try
      self.FSkipScrollEvent := True;

      pOpenrec := not (qryAccPeriods.state in [dsInsert, dsEdit]);
      if pOpenrec then
        qryAccPeriods.Edit;

      // ---
      pStat := AnsiUpperCase(qryAccPeriods.FieldByName('status').AsString);
      case TCheckBox(Sender).Checked of
        True: qryAccPeriods.FieldByName('status').AsString := 'C';
        False: qryAccPeriods.FieldByName('status').AsString := 'O';
      end;

      // ---
      if pOpenrec then
        qryAccPeriods.Post;
      accEntrys.Repaint;

      // ---
    finally
      self.FSkipScrollEvent := False;
    end;
end;

// tühistame sisestuse !
procedure TframeAccPeriods.triggerCancelEvent;
begin
  try
    self.FSkipScrollEvent := True;
    qryAccPeriods.CancelUpdates;
  finally
    self.FSkipScrollEvent := False;
  end;

  self.FNewRecordCreated := False;
  self.FDataNotSaved := False;



  dtEdtEnd.Enabled := False;
  dtEdtEnd.date := date;
  dtEdtEnd.Text := '';

  self.qryAccPeriodsAfterScroll(qryAccPeriods);
  estbk_utilities.changeWCtrlEnabledStatus(self, not qryAccPeriods.EOF);

  self.Enabled := True;
  dtEdtStart.Enabled := qryAccPeriods.RecordCount = 1;
end;



procedure TframeAccPeriods.generateNumerators;
var
  pAccWithNPeriod: TADynIntArray;
  i: integer;
begin
  with qryVerifySQL, SQL do
    try
      Close;
      Clear;
      Add(estbk_sqlcollection._SQLSelectMissingANumItems);
      paramByname('company_id').AsInteger := self.FCompanyId;
      Open;
      First;
      pAccWithNPeriod := nil;
      while not EOF do
      begin
        setlength(pAccWithNPeriod, length(pAccWithNPeriod) + 1);
        pAccWithNPeriod[high(pAccWithNPeriod)] := FieldByName('id').AsInteger;
        Next;
      end;

      // ---
      for i := low(pAccWithNPeriod) to high(pAccWithNPeriod) do
      begin
        Close;
        Clear;
        SQL.Text := estbk_sqlcollection._SQLStaticNumToAccPerTypeNumExt(self.FCompanyId, pAccWithNPeriod[i]);
        execSQL;
      end;
      // ---
    finally
      Close;
      Clear;
    end;
end;

procedure TframeAccPeriods.triggerSaveEvent;
begin
  if not self.FDataNotSaved or not self.verifyRecord(qryAccPeriods) then
    exit;

  with estbk_datamodule.admDatamodule do
  begin
           {
           try
             qryAccPeriods.ShowRecordTypes:=[usModified,usInserted];
           finally
             qryAccPeriods.ShowRecordTypes:=[usModified,usInserted,usUnModified];
           end;
           }

    // -----
    //admConnection.StartTransaction;

    qryAccPeriods.ApplyUpdates;
    qryAccPeriods.CommitUpdates;



    // ------
    //admConnection.Commit;
    self.FNewRecordCreated := False;
    // ---
    //TBitBtn(Sender).Enabled := False;
    //btnCancel.Enabled := False;
    //btnNew.Enabled    := True;

    if accEntrys.CanFocus then
      accEntrys.SetFocus;


    //btnNewPeriod.Enabled := True;
    // lipp maha !
    self.FDataNotSaved := False;

    // ---
    self.qryAccPeriodsAfterScroll(qryAccPeriods);
    // 14.04.2012 Ingmar; selline asi, kui numeraatorid maj.aasta põhised, peame ka numeraatorid genereerima !
    if pchkboxAccPer.Checked then
      self.generateNumerators();

           {
            on e: Exception do
            begin
              if admConnection.inTransaction then
                try
                  admConnection.Rollback
                except
                end;
              Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]),mtError, [mbOK], 0);
            end;
            }
    // ---
  end;
end;

procedure TframeAccPeriods.triggerNewRecEvent;
begin

  // btnSave.Enabled   := True;
  //btnCancel.Enabled := True;
  if dbEdtPerName.CanFocus then
    dbEdtPerName.SetFocus;

  dbChkBoxClose.Checked := False;
  dbChkBoxClose.Enabled := False;

  dtEdtStart.Enabled := True;
  dtEdtEnd.Enabled := True;


  self.FSkipScrollEvent := True;
  qryAccPeriods.First;
  self.FSkipScrollEvent := False;

  self.FNewRecordCreated := True;
  qryAccPeriods.Insert;
  // -----
  //  TBitBtn(Sender).Enabled := False;
end;



procedure TframeAccPeriods.accEntrysDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
{
  gdSelected     The cell is currently selected.
  gdFocused     The cell has input focus.
  gdFixed     The cell is in the fixed region of the grid.
  Canvas.Brush.Color:=clHighlight
  }
// Canvas.TextOut(rect.Left,rect.top,'TEST');
//  accEntrys(Sender).DefaultDrawColumnCell(rect,DataCol,Column,State);
var
  pStatus: AStr;
  pFieldVal: AStr;
  //TextTop, TextLeft : integer;
begin

  //  (Sender as TDBGrid).Canvas.Brush.Color := RGB(191, 255, 223);
  //   DBGrid.Canvas.LineTo(Rect.Right, Rect.Top);
  with (Sender as TDBGrid) do
  begin

    // nupp, mis tõmbab majandusaastad tööle
    if Columns.Count - 1 = DataCol then
    begin
      TDbGrid(Sender).DefaultDrawColumnCell(rect, DataCol, Column, State);
      Exit;
    end;

    // ---
    if (gdSelected in State) then
    begin
      // Canvas.Brush.Color:=RGB(191, 255, 223)
      Brush.Color := clBackGround;
      Font.Color := clWhite;
    end
    else
    begin
      Canvas.Brush.Color := clWindow;
      Font.Color := clBlack;
    end;

    // --------
    Canvas.FillRect(Rect);
    if Columns.Count - 2 = DataCol then // staatus väli ! (3)
    begin
      // dekodeerime staatused
      pFieldVal := trim(AnsiUpperCase(Column.Field.AsString));
      // pStatus:=estbk_clientstrmsg.CSAccStatusOpen;
      if (Sender as TDBGrid).DataSource.dataSet.EOF then
        pStatus := ''
      else
      if (pFieldVal = '') or (pFieldVal = estbk_types.CRecIsOpen) then // avatud
        pStatus := estbk_strmsg.CSStatusOpen
      else
      if (pFieldVal = estbk_types.CRecIsClosed) then // suletud
        pStatus := estbk_strmsg.CSStatusClosed
      else
      if (pFieldVal = estbk_types.CRecIsCanceled) then // kustutatud?
        pStatus := estbk_strmsg.CSStatusDeleted
      else
        pStatus := '';
      Canvas.TextOut(Rect.left + 2, Rect.top + 2, pStatus);
    end
    else
    if assigned(Column.Field) then
      Canvas.TextOut(Rect.left + 2, Rect.top + 2, Column.Field.AsString)
    else
      Canvas.TextOut(Rect.left + 2, Rect.top + 2, '');
    // ---
  end;
end;


procedure TframeAccPeriods.callNumEditor;
begin
  TformNumerators.showAndCreate(self.FCompanyId, qryAccPeriods.FieldByName('id').AsInteger);
end;

procedure TframeAccPeriods.accEntrysCellClick(Column: TColumn);
begin

  if Column.Index = accEntrys.Columns.Count - 1 then
    self.callNumEditor;
end;

procedure TframeAccPeriods.accEntrysEditButtonClick(Sender: TObject);
begin
  self.callNumEditor;
end;

procedure TframeAccPeriods.accEntrysKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if TDbGrid(Sender).SelectedRows.Count < 1 then
    TDbGrid(Sender).SelectedRows.CurrentRowSelected := True;

  if (key = VK_DELETE) and (Shift = [ssCtrl]) and (TDbGrid(Sender).SelectedRows.Count = 1) and not qryAccPeriods.EOF and
    (qryAccPeriods.RecNo = 1) then
  begin
    key := 0;
    // kui kustutada, siis kustutada...
    if Dialogs.messageDlg(estbk_strmsg.SEAccPeriodDeleteRecord, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin

      // --
      if not (qryAccPeriods.State in [dsEdit, dsInsert]) then
        qryAccPeriods.Edit;


      // jätame ikka meelde ka, kes meil see suur kustutaja on...
      qryAccPeriods.FieldByName('rec_changed').AsDateTime := now;
      qryAccPeriods.FieldByName('rec_changedby').AsInteger :=
        estbk_globvars.glob_worker_id;
      qryAccPeriods.FieldByName('rec_deletedby').AsInteger :=
        estbk_globvars.glob_worker_id;
      qryAccPeriods.FieldByName('rec_deleted').AsBoolean := True;
      qryAccPeriods.Post;
      //---
      qryAccPeriods.Delete;


      self.qryAccPeriodsAfterScroll(qryAccPeriods);
    end;
    // ---
  end;
end;

procedure TframeAccPeriods.accEntrysSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
begin
  // --
end;


initialization
  {$I estbk_accperiods.ctrs}

end.
