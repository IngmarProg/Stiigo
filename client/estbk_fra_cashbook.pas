unit estbk_fra_cashbook;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, LCLType, LCLproc, Forms, Dialogs,
  Controls, StdCtrls, Buttons, estbk_uivisualinit, EditBtn, ExtCtrls, Menus,
  ComCtrls, ZDataset, estbk_fra_template, estbk_lib_commoncls, estbk_lib_commonevents,
  estbk_clientdatamodule, estbk_lib_commonaccprop, estbk_types, estbk_sqlclientcollection, estbk_reportsqlcollection,
  estbk_reportconst, estbk_globvars, estbk_utilities, estbk_strmsg,
  estbk_fra_customer, estbk_frm_choosecustmer, rxlookup, LR_Class, LR_DBSet, DB, LR_DSet,
  LR_BarC, LR_Desgn, LR_View, lr_e_csv, lr_e_pdf;

type

  { TframeCashbook }

  TframeCashbook = class(Tfra_template)
    btnClean: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnOutput: TBitBtn;
    btnReport: TBitBtn;
    cmbPreDefPer: TComboBox;
    reportdata: TfrDBDataSet;
    frReport: TfrReport;
    lblPerStart: TLabel;
    lblPerEnd: TLabel;
    lcpCashRegAccount: TRxDBLookupCombo;
    mnuItemCsv: TMenuItem;
    mnuItemPdfFile: TMenuItem;
    mnuItemScreen: TMenuItem;
    popupReportType: TPopupMenu;
    qryAccountsDs: TDatasource;
    dtEditEnd: TDateEdit;
    dtEditStart: TDateEdit;
    edtClientCode: TEdit;
    edtCustNameAndRegCode: TEdit;
    grpCashbook: TGroupBox;
    Label1: TLabel;
    lblCustId: TLabel;
    lblPermisc: TLabel;
    qryCashbookEntrys: TZQuery;
    qryAccounts: TZQuery;
    saveRep: TSaveDialog;
    procedure btnCleanClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure cmbPreDefPerChange(Sender: TObject);
    procedure dtEditStartExit(Sender: TObject);
    procedure edtClientCodeChange(Sender: TObject);
    procedure edtClientCodeExit(Sender: TObject);
    procedure edtClientCodeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtClientCodeKeyPress(Sender: TObject; var Key: char);
    procedure frReportGetValue(const ParName: string; var ParValue: variant);
    procedure lcpCashRegAccountClosePopupNotif(Sender: TObject; SearchResult: boolean);
    procedure lcpCashRegAccountKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure lcpCashRegAccountSelect(Sender: TObject);
    procedure mnuItemScreenClick(Sender: TObject);

  private

    FInDocCount: integer;
    FOutDocCount: integer;
    FFinalBalance: double;
    // ---
    FreportDefPath: AStr;
    FLastClientcode: AStr;
    FSelectedClientId: integer;

    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    // --
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure assignClientData(const pClient: TClientData);
  public
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
    // RTTI teema;
  published
    property reportDefPath: AStr read FreportDefPath write FreportDefPath;
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

const
  CIndxPaymentStatus_undefined = 0;
  CIndxPaymentStatus_confirmed = 1;
  CIndxPaymentStatus_unconfirmed = 2;

{ TframeCashbook }



procedure TframeCashbook.assignClientData(const pClient: TClientData);
var
  pTemp: AStr;
begin
  if not assigned(pClient) then
  begin
    edtClientCode.Text := '';
    edtCustNameAndRegCode.Text := '';

    self.FLastClientcode := '';
    self.FSelectedClientId := 0;
  end
  else
  begin
    pTemp := pClient.FCustFullName;
    if trim(pClient.FCustRegNr) <> '' then
      pTemp := pTemp + '(' + pClient.FCustRegNr + ')';


    // ---
    edtCustNameAndRegCode.Text := pTemp;
    edtClientCode.Text := pClient.FClientCode;

    self.FSelectedClientId := pClient.FClientId;
    self.FLastClientcode := pClient.FClientCode;
  end;
end;

procedure TframeCashbook.btnOpenClientListClick(Sender: TObject);
var
  pClient: TClientData;
begin
  try
    pClient := estbk_frm_choosecustmer.__chooseClient(edtClientCode.Text);
    assignClientData(pClient);

    if cmbPreDefPer.CanFocus then
      cmbPreDefPer.SetFocus;
  finally
    FreeAndNil(pClient);
  end;
end;

procedure TframeCashbook.btnOutputClick(Sender: TObject);
var
  pFindPOwner: TWincontrol;
begin
  pFindPOwner := self.Parent;
  while assigned(pFindPOwner) do
  begin
    if (pFindPOwner is TPageControl) or (pFindPOwner is TForm) then
      break;

    // ---
    pFindPOwner := pFindPOwner.Parent;
  end;

  popupReportType.PopUp(TForm(pFindPOwner).left + TSpeedButton(Sender).left + TSpeedButton(Sender).Width + 1,
    TForm(pFindPOwner).top + TSpeedButton(Sender).top + TSpeedButton(Sender).Height + 118);
end;

procedure TframeCashbook.btnReportClick(Sender: TObject);

var
  pCursor: TCursor;
  pAccountId: integer;
  pAccArr: TADynIntArray;
  pBfrTable: AStr;
  pDtStart: TDatetime;
  pDtEnd: TDatetime;
  pSql: AStr;
  pRepFile: AStr;
  pFileName: AStr;

begin
  self.FInDocCount := 0;
  self.FOutDocCount := 0;
  self.FFinalBalance := 0.00;

  pDtStart := CZStartDate1980;
  pDtEnd := CZEndDate2050;

  if trim(dtEditStart.Text) <> '' then
    pDtStart := dtEditStart.Date;

  if trim(dtEditEnd.Text) <> '' then
    pDtEnd := dtEditEnd.Date;


  if (trim(dtEditStart.Text) <> '') and (trim(dtEditEnd.Text) <> '') and (pDtStart > pDtEnd) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEStartDateQtEndDate, mtError, [mbOK], 0);
    if dtEditStart.CanFocus then
      dtEditStart.SetFocus;
    Exit;
  end;


  if (trim(dtEditStart.Text) <> '') and (pDtStart > now) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEDateInFuture, mtError, [mbOK], 0);
    if dtEditStart.CanFocus then
      dtEditStart.SetFocus;
    Exit;
  end;


  // ---
  try
    pCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    with qryCashbookEntrys, SQL do
      try
        // kompatiiblus postgre jaoks...ja ka firebird; muidu poleks transaktsiooni vaja !
        dmodule.primConnection.StartTransaction;

        setlength(pAccArr, 1);
        if trim(lcpCashRegAccount.Text) <> '' then
          pAccountId := qryAccounts.FieldByName('id').AsInteger
        else
          pAccountId := _ac.sysAccountId[_accCashRegister];

        pAccArr[0] := pAccountId;
        pBfrTable := 'creg';
        Close;
        Clear;


        add(estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart1(estbk_globvars.glob_company_id, pBfrTable, pAccArr));
        execsql;

        // 22.03.2012 Ingmar
        Close;
        Clear;
        add(estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart2(estbk_globvars.glob_company_id, pBfrTable, pDtStart, pDtEnd));
        execsql;

        Close;
        Clear;
        add(estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart3(estbk_globvars.glob_company_id, pBfrTable));
        execsql;

        // SISSETULEKU ORDER
        pSql := estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart4(estbk_globvars.glob_company_id,
          pBfrTable, True, estbk_types._dsReceiptVoucherDocId, self.FSelectedClientId,
          //cmbCashRegPmtStatus.ItemIndex,
          // ---
          pDtStart, pDtEnd);

        Close;
        Clear;
        add(pSql);
        execsql;


        // VÄLJAMINEKU ORDER
        Close;
        Clear;
        pSql := estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart4(estbk_globvars.glob_company_id,
          pBfrTable, True, estbk_types._dsPaymentVoucherDocId, self.FSelectedClientId,
          //cmbCashRegPmtStatus.ItemIndex,
          // ---
          pDtStart, pDtEnd);







        add(pSql);
        execsql;


        Close;
        Clear;
        add(_CSQLRepCashBookFinalQrt(pBfrTable));
        Open;

        dmodule.primConnection.Commit;

        if qryCashbookEntrys.EOF then
          messageDlg(estbk_strmsg.SEQryRetNoData, mtInformation, [mbOK], 0)
        else
        begin
          self.FFinalBalance := FieldByName('init_balance').AsFloat;
          pRepFile := includetrailingbackslash(self.reportDefPath) + estbk_reportconst.CCashRegisterReportFilename;
          if not fileExists(pRepFile) then
            raise Exception.CreateFmt(estbk_strmsg.SEReportDataFileNotFound, [pRepFile]);

          Screen.Cursor := pCursor;
          frReport.LoadFromFile(pRepFile);
          frReport.ShowProgress := True;
          if mnuItemScreen.Checked then
          begin
            //frReport.PrepareReport:=true;
            frReport.ShowReport;

          end
          else
          // http://lazarus.developpez.com/cours/lazreport/
          // TfrTextExportFilter
          // TfrHTMExport
          if mnuItemPdfFile.Checked then
          begin
            // TODO
            pFileName := stringreplace(dtEditStart.Text, '.', '', [rfReplaceAll]) + '_' +
              stringreplace(dtEditEnd.Text, '.', '', [rfReplaceAll]);

            saveRep.FileName := format(CSCashBookFile, [pFileName]) + '.pdf';
            if saveRep.Execute then
            begin
              if frReport.PrepareReport then
                frReport.ExportTo(TFrTNPDFExportFilter, saveRep.Files.Strings[0]);
            end;
            // ----
          end
          else
          if mnuItemCsv.Checked then
          begin
            // TODO
            pFileName := stringreplace(dtEditStart.Text, '.', '', [rfReplaceAll]) + '_' +
              stringreplace(dtEditEnd.Text, '.', '', [rfReplaceAll]);

            saveRep.FileName := format(CSCashBookFile, [pFileName]) + '.csv';
            if saveRep.Execute then
            begin
              if frReport.PrepareReport then
                frReport.ExportTo(TfrCSVExportFilter, saveRep.Files.Strings[0]);
            end;

            // ----
          end;
        end;
        // ---
      except
        on e: Exception do
        begin
          if dmodule.primConnection.InTransaction then
            try
              dmodule.primConnection.RollBack;
            except
            end;
          Dialogs.MessageDlg(format(estbk_strmsg.SECantCreateReport, [e.Message]), mtError, [mbOK], 0);
        end;
      end;

  finally
    Screen.Cursor := pCursor;
  end;
end;

procedure TframeCashbook.btnCleanClick(Sender: TObject);
begin
  estbk_utilities.clearControlsWithTextValue(grpCashbook);

  // reset
  qryAccounts.Locate('id', _ac.sysAccountId[_accCashRegister], []);
  lcpCashRegAccount.Value := IntToStr(_ac.sysAccountId[_accCashRegister]);
  lcpCashRegAccount.Text := '';


  //   cmbPreDefPer.ItemIndex:=1;
  //   cmbPreDefPer.OnChange(cmbPreDefPer);
  //   cmbCashRegPmtStatus.ItemIndex:=0;

  if edtClientCode.CanFocus then
    edtClientCode.SetFocus;


  edtCustNameAndRegCode.Text := '';
  FLastClientcode := '';
  FSelectedClientId := 0;


  dtEditStart.Date := now;
  dtEditEnd.Date := now;
end;

procedure TframeCashbook.cmbPreDefPerChange(Sender: TObject);
var
  pDtType: estbk_types.TdtPeriod;
  pdtStart: TDatetime;
  pdtEnd: TDatetime;
  zVal: boolean;
begin
  zVal := True;
  with TComboBox(Sender) do
    if ItemIndex >= 0 then
    begin
      pDtType := estbk_types.TdtPeriod(cardinal(Items.Objects[ItemIndex]));
      if pDtType <> cdt_undefined then
      begin
        estbk_utilities.decodeDtRange(pDtType, pdtStart, pdtEnd);

        dtEditStart.date := pdtStart;
        dtEditEnd.date := pdtEnd;

        dtEditStart.Text := datetostr(pdtStart);
        dtEditEnd.Text := datetostr(pdtEnd);
        zVal := False;
      end;
    end;

  // ----
  if zVal then
  begin
    dtEditStart.date := now;
    dtEditEnd.date := now;

    dtEditStart.Text := '';
    dtEditEnd.Text := '';
  end;
end;

procedure TframeCashbook.dtEditStartExit(Sender: TObject);
var
  fVdate: TDatetime;
  fDateStr: AStr;
  b: boolean;
begin
  fVdate := Now;
  fDateStr := TDateEdit(Sender).Text;

  if (trim(fDateStr) <> '') then
    if not validateMiscDateEntry(fDateStr, fVDate) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
      TDateEdit(Sender).SetFocus;
      exit;
    end
    else
      TDateEdit(Sender).Text := datetostr(fVDate);
end;

procedure TframeCashbook.edtClientCodeChange(Sender: TObject);
begin
  with TEdit(Sender) do
    if Focused then
    begin
      if trim(Text) = '' then
      begin
        self.FSelectedClientId := 0;
        edtCustNameAndRegCode.Text := '';
      end;
    end; // --
end;

procedure TframeCashbook.edtClientCodeExit(Sender: TObject);
var
  pClient: TClientData;
begin
  pClient := nil;
  with TEdit(Sender) do
    if Text <> '' then
      try
        if self.FLastClientcode <> Text then
        begin
          pClient := estbk_fra_customer.getClientDataWUI(Text);
          self.assignClientData(pClient);
        end;

      finally
        FreeAndNil(pClient);
      end
    else
      self.assignClientData(pClient);
end;

procedure TframeCashbook.edtClientCodeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    self.btnOpenClientListClick(btnOpenClientList);
    key := 0;
  end;
end;

procedure TframeCashbook.edtClientCodeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeCashbook.frReportGetValue(const ParName: string; var ParValue: variant);
const
  SCAccountInitBalance = '@scaccountinitbalance';
  SCperiod = '@scperiod';
  SCCashregAccCode = '@sccashregacccode';
  SCCashregLongname = '@sccashreglongname';

  SCTrandate = '@sctrandate';
  SCClientname = '@scclientname';
  SCDescr = '@scdescr';
  SCcompname = '@sccompname';

  SCIncr = '@scincr';
  SCOutr = '@scoutr';
  SCAccountFinalBalance = '@scaccountfinalbalance';

  SCInDocCnt = '@scindoccnt';
  SCOutDocCnt = '@scoutdoccnt';

var
  pLowParam: AStr;
  pTemp: AStr;
begin
  // ---
  if pos('@', parname) > 0 then
  begin
    ParValue := '';
    pLowParam := ansilowercase(ParName);
    if pLowParam = SCAccountInitBalance then
      ParValue := format(CCurrentMoneyFmt2, [qryCashbookEntrys.FieldByName('init_balance').AsFloat])
    else
    if pLowParam = SCperiod then
    begin
      pTemp := '';
      if dtEditStart.Text <> '' then
        pTemp := datetostr(dtEditStart.date) + ' - ';

      if dtEditEnd.Text <> '' then
      begin
        if pTemp = '' then
          pTemp := ' - ';
        pTemp := pTemp + datetostr(dtEditEnd.date);
      end;
      // ---
      ParValue := pTemp;
    end
    else
    if pLowParam = SCCashregAccCode then // KASSA
      ParValue := qryCashbookEntrys.FieldByName('account_coding').AsString
    else
    if pLowParam = SCCashregLongname then // KASSA konto pikk nimi
      ParValue := qryCashbookEntrys.FieldByName('account_name').AsString
    else
    if pLowParam = SCTrandate then
      ParValue := datetostr(qryCashbookEntrys.FieldByName('trdate').AsDateTime)
    else
    if pLowParam = SCClientname then
      ParValue := trim(qryCashbookEntrys.FieldByName('firstname').AsString + ' ' + qryCashbookEntrys.FieldByName('lastname').AsString)
    else
    if pLowParam = SCDescr then
      ParValue := trim(qryCashbookEntrys.FieldByName('descr').AsString)
    // kande kirjeldus; per rida ! longdescr on kogu kirjeldus, mis maksega seotud !
    else
    if pLowParam = SCcompname then
      ParValue := estbk_globvars.glob_currcompname
    else
    if ((pLowParam = SCIncr) or (pLowParam = SCOutr)) then
    begin
      if (qryCashbookEntrys.FieldByName('srline').AsInteger = 2) and (pLowParam = SCIncr) then // tunnus sissetuleku order !
      begin
        ParValue := format(CCurrentMoneyFmt2, [qryCashbookEntrys.FieldByName('incr').AsFloat]);
        self.FFinalBalance := self.FFinalBalance + qryCashbookEntrys.FieldByName('incr').AsFloat;
        Inc(self.FInDocCount);
      end
      else
      if (qryCashbookEntrys.FieldByName('srline').AsInteger = 3) and (pLowParam = SCOutr) then // tunnus väljamineku order !
      begin
        ParValue := format(CCurrentMoneyFmt2, [qryCashbookEntrys.FieldByName('outr').AsFloat]);
        //self.FFinalBalance:=self.FFinalBalance+qryCashbookEntrys.FieldByName('outr').AsFloat;
        self.FFinalBalance := self.FFinalBalance - qryCashbookEntrys.FieldByName('outr').AsFloat;
        Inc(self.FOutDocCount);
      end
      else
        ParValue := '';
    end
    else // --
    if pLowParam = SCAccountFinalBalance then
      ParValue := format(CCurrentMoneyFmt2, [self.FFinalBalance])
    else
    if pLowParam = SCInDocCnt then
      ParValue := IntToStr(self.FInDocCount)
    else
    if pLowParam = SCOutDocCnt then
      ParValue := IntToStr(self.FOutDocCount);
  end;
end;

procedure TframeCashbook.lcpCashRegAccountClosePopupNotif(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeCashbook.lcpCashRegAccountKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  estbk_utilities.rxLibKeyDownHelper(Sender as TRxDbLookupCombo, key, Shift);
end;

procedure TframeCashbook.lcpCashRegAccountSelect(Sender: TObject);
var
  pcode: AStr;
begin
  pcode := qryAccounts.FieldByName('account_coding').AsString;
  lcpCashRegAccount.Hint := pcode;
  lcpCashRegAccount.Text := pcode;
end;

procedure TframeCashbook.mnuItemScreenClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to self.popupReportType.Items.Count - 1 do
    self.popupReportType.Items[i].Checked := False;
  TMenuItem(Sender).Checked := True;

  if btnReport.CanFocus then
    btnReport.SetFocus;
end;


function TframeCashbook.getDataLoadStatus: boolean;
begin
  Result := qryCashbookEntrys.Active;
end;

procedure TframeCashbook.setDataLoadStatus(const v: boolean);
begin
  qryCashbookEntrys.Close;
  qryCashbookEntrys.SQL.Clear;

  qryAccounts.Close;
  qryAccounts.SQL.Clear;

  if v then
  begin
    qryCashbookEntrys.Connection := dmodule.primConnection;
    qryAccounts.Connection := dmodule.primConnection;
    qryAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    qryAccounts.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryAccounts.Active := v;
    qryAccounts.Locate('id', _ac.sysAccountId[_accCashRegister], []);
    lcpCashRegAccount.Value := IntToStr(_ac.sysAccountId[_accCashRegister]);
    lcpCashRegAccount.Text := '';
  end
  else
    qryCashbookEntrys.Connection := nil;
end;


constructor TframeCashbook.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);


  estbk_reportconst.fillReportDtPer(TAStrings(cmbPreDefPer.items));
  cmbPreDefPer.ItemIndex := 1;
  cmbPreDefPer.OnChange(cmbPreDefPer);
  //   cmbCashRegPmtStatus.ItemIndex:=0;
end;


destructor TframeCashbook.Destroy;
begin
  inherited Destroy;
end;

initialization
  {$I estbk_fra_cashbook.ctrs}

end.