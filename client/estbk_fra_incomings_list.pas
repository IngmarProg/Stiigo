unit estbk_fra_incomings_list;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Buttons, StdCtrls, Dialogs, Math, Graphics, estbk_fra_template, estbk_settings,
  estbk_uivisualinit, estbk_strmsg, estbk_clientdatamodule, estbk_types, estbk_reportconst, estbk_fra_customer, estbk_frm_choosecustmer,
  estbk_utilities, LCLType, EditBtn, ExtCtrls, DBGrids, estbk_globvars, estbk_sqlclientcollection, estbk_lib_commoncls,
  estbk_lib_commonevents, estbk_lib_deleteaccitems, ZDataset, rxlookup, DB, Grids;

type

  { TframeIncomingsList }

  TframeIncomingsList = class(Tfra_template)
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    btnClean: TBitBtn;
    btnClose: TBitBtn;
    btnNewIncoming: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnSrc: TBitBtn;
    cmbPreDefPer: TComboBox;
    cmbStaatus: TComboBox;
    qrySearchDs: TDatasource;
    qrySearch: TZReadOnlyQuery;
    qryBanksDs: TDatasource;
    edtIncNumber: TEdit;
    lblIncNr: TLabel;
    lblStatus: TLabel;
    cmbSource: TComboBox;
    dtEditEnd: TDateEdit;
    dtEditStart: TDateEdit;
    lblIncType: TLabel;
    edtRefNr: TEdit;
    lblRefNr: TLabel;
    edtIncBankFilename: TEdit;
    edtClientId: TEdit;
    edtCustNameAndAddr: TEdit;
    lblBankAcc1: TLabel;
    lblCustId: TLabel;
    lblBank: TLabel;
    lblPerEnd: TLabel;
    lblPermisc: TLabel;
    lblPerStart: TLabel;
    parentPanel: TPanel;
    incomingGrid: TDBGrid;
    gppBoxIncomings: TGroupBox;
    rxLookupBanks: TRxDBLookupCombo;
    qryBanks: TZReadOnlyQuery;
    procedure btnCleanClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewIncomingClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnSrcClick(Sender: TObject);
    procedure cmbPreDefPerChange(Sender: TObject);
    procedure dtEditStartExit(Sender: TObject);
    procedure edtClientIdExit(Sender: TObject);
    procedure edtClientIdKeyPress(Sender: TObject; var Key: char);
    procedure incomingGridDblClick(Sender: TObject);
    procedure incomingGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure incomingGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure incomingGridKeyPress(Sender: TObject; var Key: char);
    procedure incomingGridPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
    procedure lblBankAcc1Click(Sender: TObject);
    procedure rxLookupBanksChange(Sender: TObject);
    procedure rxLookupBanksClosePopupNotif(Sender: TObject; SearchResult: boolean);
  private
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FLastClientCode: AStr;
    FLastClientId: integer;
    // ---
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure assignClientData(const pClient: TClientData);
  public
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
    // RTTI probleem
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

const
  CCmbUndefinedComboVal = 0;

const
  CCmbStatusVerified = 1;
  CCmbStatusUnVerified = 2;

const
  CCmbIncAddedManually = 1;
  CCmbIncFromFile = 2;

const
  CCol_Bank_name = 0;
  CCol_Incomenr = 1;
  CCol_Account_coding = 2;
  CCol_IncomeDate = 3;
  CCol_PaidBy = 4;
  CCol_Sum = 5;
  CCol_Currency = 6;
  CCol_Currency_ovr = 7;
  CCol_Status = 8;
  CCol_Descr = 9;
  CCol_RefNr = 10;

procedure TframeIncomingsList.btnCloseClick(Sender: TObject);
begin
  if assigned(self.onFrameKillSignal) then
    onFrameKillSignal(self);
end;

procedure TframeIncomingsList.btnNewIncomingClick(Sender: TObject);
begin
  self.onFrameDataEvent(self, __frameCreateNewIncoming, -1, nil);
end;

procedure TframeIncomingsList.btnOpenClientListClick(Sender: TObject);
var
  pClient: TClientData;
begin
  try
    pClient := estbk_frm_choosecustmer.__chooseClient(edtClientId.Text);
    // ---
    assignClientData(pClient);
  finally
    FreeAndNil(pClient);
  end;
end;

procedure TframeIncomingsList.btnSrcClick(Sender: TObject);
var
  pAccountId: integer;
  pIncDateStart: TDatetime;
  pIncDateEnd: TDatetime;
  pStatus: byte;
  pSource: byte;
begin
  if ((Trim(edtClientId.Text) = '') and (Trim(edtRefNr.Text) = '') and (Trim(edtIncNumber.Text) = '') and
    (Trim(rxLookupBanks.Text) = '') and (Trim(edtIncBankFilename.Text) = '') and (Trim(dtEditStart.Text) = '') and
    (Trim(dtEditEnd.Text) = '') and (cmbStaatus.ItemIndex < 1) and
    // 08.09.2016 Ingmar; lubame ka staatuse järgi otsida, ntx kinnitatud kinnitamata laekumised
    (cmbSource.ItemIndex < 1) and (cmbPreDefPer.ItemIndex < 1)) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SESrcParamsIncomplete, mtError, [mbOK], 0);
    if edtClientId.CanFocus then
      edtClientId.SetFocus;
    Exit;
  end;


  if ((Trim(dtEditStart.Text) <> '') and (Trim(dtEditEnd.Text) <> '') and (dtEditStart.Date > dtEditEnd.Date)) or
    (dtEditStart.Date > now) or (dtEditEnd.Date > now) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEIncorrectCriteria, mtError, [mbOK], 0);
    if dtEditStart.CanFocus then
      dtEditStart.SetFocus;
    Exit;
  end;



  // ---
  pIncDateStart := NaN;
  if dtEditStart.Text <> '' then
    pIncDateStart := dtEditStart.Date;

  pIncDateEnd := NaN;
  if dtEditEnd.Text <> '' then
    pIncDateEnd := dtEditEnd.Date;

  pAccountId := -1;
  if Trim(rxLookupBanks.Text) <> '' then
    pAccountId := qryBanks.FieldByName('id').AsInteger;

  pStatus := byte(PtrUInt(cmbStaatus.Items.Objects[cmbStaatus.ItemIndex]));
  pSource := byte(PtrUInt(cmbSource.Items.Objects[cmbSource.ItemIndex]));

  qrySearch.Close;
  qrySearch.SQL.Clear;
  qrySearch.SQL.add(estbk_sqlclientcollection._SQLSrcIncomings(estbk_globvars.glob_company_id,
    //strtoIntdef(edtClientId.text,0),
    self.FLastClientId,
    edtRefNr.Text,
    edtIncNumber.Text,
    pAccountId,
    edtIncBankFilename.Text,
    pSource, pStatus,
    pIncDateStart,
    pIncDateEnd));

  qrySearch.Open;
  qrySearch.First;
  if qrySearch.EOF then
  begin
    Dialogs.MessageDlg(estbk_strmsg.SEQryRetNoData, mtError, [mbOK], 0);
    Exit;
  end;
end;

procedure TframeIncomingsList.cmbPreDefPerChange(Sender: TObject);
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

procedure TframeIncomingsList.dtEditStartExit(Sender: TObject);
var
  fVdate: TDatetime;
  fDateStr: AStr;
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

procedure TframeIncomingsList.assignClientData(const pClient: TClientData);
var
  pData: AStr;

begin
  if not assigned(pClient) then
  begin
    edtCustNameAndAddr.Text := '';
    edtClientId.Text := '';
    self.FLastClientId := 0;
    self.FLastClientCode := '';
  end
  else
  begin
    pData := trim(pClient.FCustFullName);
    if trim(pClient.FCustRegNr) <> '' then
      pData := pData + ' (' + pClient.FCustRegNr + ')';

    edtCustNameAndAddr.Text := pData;
    edtClientId.Text := pClient.FClientCode;// inttostr(pClient.FClientId);

    // --
    self.FLastClientId := pClient.FClientId;
    self.FLastClientCode := pClient.FClientCode;

  end;
end;

procedure TframeIncomingsList.edtClientIdExit(Sender: TObject);
var
  pClient: TClientData;
begin
  pClient := nil;

  with TEdit(Sender) do
    if Text <> '' then
      try

        // ---
        if self.FLastClientCode <> Text then
        begin
          pClient := estbk_fra_customer.getClientDataWUI(Text);
          self.assignClientData(pClient);
        end;

      finally
        if assigned(pClient) then
          FreeAndNil(pClient);
      end
    else
      self.assignClientData(nil);
end;

procedure TframeIncomingsList.btnCleanClick(Sender: TObject);
begin
  self.FLastClientCode := '';
  // ---
  estbk_utilities.clearControlsWithTextValue(gppBoxIncomings);


  edtCustNameAndAddr.Text := '';
  rxLookupBanks.Text := '';
  rxLookupBanks.Value := '';


  dtEditStart.Date := now;
  dtEditEnd.Date := now;

  dtEditStart.Text := '';
  dtEditEnd.Text := '';


  cmbSource.ItemIndex := 0;
  cmbPreDefPer.ItemIndex := 0;
  cmbStaatus.ItemIndex := 0;

  if edtClientId.CanFocus then
    edtClientId.SetFocus;

  qrySearch.Close;
  qrySearch.SQL.Clear;
  qrySearch.SQL.add(estbk_sqlclientcollection._SQLSrcIncomings(estbk_globvars.glob_company_id));
  qrySearch.Open;
end;

procedure TframeIncomingsList.edtClientIdKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeIncomingsList.incomingGridDblClick(Sender: TObject);
begin
  if assigned(self.FFrameDataEvent) and not qrySearch.isEmpty then
    self.FFrameDataEvent(Self, __frameOpenIncoming, qrySearch.FieldByName('parent_entry_id').AsInteger);
end;

procedure TframeIncomingsList.incomingGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
var
  pData: AStr;
  pts: TTextStyle;
begin

  pData := '';
  with TDbGrid(Sender) do
  begin
    Canvas.FillRect(Rect);
    pts := Canvas.TextStyle;
    pts.Alignment := taLeftJustify;
    Canvas.TextStyle := pts;
    if qrySearch.RecordCount < 1 then
    begin
      Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, '');
      Exit;
    end;



    // ---
    if assigned(Column.Field) then
    begin
      pData := Column.Field.AsString;
      // --
      if (DataCol = CCol_Sum) then
      begin
        pts := Canvas.TextStyle;
        pts.Alignment := taRightJustify;
        Canvas.TextStyle := pts;
        Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, trim(format(estbk_types.CCurrentMoneyFmt2, [Column.Field.AsFloat])) + #32, Canvas.TextStyle);
      end
      else
      if (DataCol = CCol_Currency_ovr) then
      begin
        pts := Canvas.TextStyle;
        pts.Alignment := taRightJustify;
        Canvas.TextStyle := pts;
        Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, trim(format(estbk_types.CCurrentAmFmt4, [Column.Field.AsFloat])) + #32, Canvas.TextStyle);
      end
      else
      if (DataCol = CCol_Status) then
      begin
        if pos(estbk_types.CRecIsClosed, Column.Field.AsString) > 0 then
          pData := estbk_strmsg.SCStatusConfirmed
        else
          pData := estbk_strmsg.SCStatusUnConfirmed;
        // --
        Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, pData);
      end
      else
        Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, pData);
    end
    else
      Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, pData);
  end;
  // --
end;

procedure TframeIncomingsList.incomingGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if qrySearch.Active and (qrySearch.RecordCount > 0) then
    if key = VK_DELETE then
    begin
      if _deleteAccItems(qrySearch.FieldByName('parent_entry_id').AsInteger, qrySearch.FieldByName(
        'income_number').AsString, cbDeleteIncoming) then
      begin
        //btnSrc.OnClick(btnSrc);
        qrySearch.Active := False;
        qrySearch.Active := True;
      end;

      key := 0;
    end;
end;

procedure TframeIncomingsList.incomingGridKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    self.incomingGridDblClick(Sender);
    key := #0;
  end;
end;

procedure TframeIncomingsList.incomingGridPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin
  // --
  with TDbGrid(Sender) do
    if assigned(DataSource) then
    begin

      if (gdSelected in AState) then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end
      else
      if (pos(estbk_types.CRecIsClosed, DataSource.Dataset.FieldByName('status').AsString) = 0) then
        Canvas.Brush.Color := glob_userSettings.uvc_colors[uvc_gridColorForUnconfirmedItems]
      else
        Canvas.Brush.Color := clWindow;
    end; // ---
end;

procedure TframeIncomingsList.lblBankAcc1Click(Sender: TObject);
begin

end;

procedure TframeIncomingsList.rxLookupBanksChange(Sender: TObject);
begin
  // --
end;

procedure TframeIncomingsList.rxLookupBanksClosePopupNotif(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

function TframeIncomingsList.getDataLoadStatus: boolean;
begin
end;

procedure TframeIncomingsList.setDataLoadStatus(const v: boolean);
begin
  qryBanks.Close;
  qryBanks.SQL.Clear;

  qrySearch.Close;
  qrySearch.SQL.Clear;

  if v then
  begin
    qryBanks.Connection := estbk_clientdatamodule.dmodule.primConnection;
    //      qryAccounts.Connection:=estbk_clientdatamodule.dmodule.primConnection;
    qrySearch.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qrySearch.SQL.add(estbk_sqlclientcollection._SQLSrcIncomings(estbk_globvars.glob_company_id));
    qrySearch.Open;

    qryBanks.SQL.Add(estbk_sqlclientcollection._SQLSelectAccountsWithBankData);
    qryBanks.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryBanks.Open;

  end
  else
  begin
    qryBanks.Connection := nil;
    //      qryAccounts.Connection:=nil;
    qrySearch.Connection := nil;
  end;
end;

constructor TframeIncomingsList.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);

  cmbStaatus.Items.AddObject(estbk_strmsg.SUnDefComboChoise, TObject(CCmbUndefinedComboVal));
  cmbStaatus.Items.AddObject(estbk_strmsg.SCStatusConfirmed, TObject(CCmbStatusVerified));
  cmbStaatus.Items.AddObject(estbk_strmsg.SCStatusUnConfirmed, TObject(CCmbStatusUnVerified));
  cmbStaatus.ItemIndex := 0;

  estbk_reportconst.fillReportDtPer(TAStrings(cmbPreDefPer.items));


  cmbSource.Items.AddObject(estbk_strmsg.SUnDefComboChoise, TObject(CCmbUndefinedComboVal));
  cmbSource.Items.AddObject(estbk_strmsg.SCSourceFile, TObject(CCmbIncFromFile));
  cmbSource.Items.AddObject(estbk_strmsg.SCSourceManual, TObject(CCmbIncAddedManually));
  cmbSource.ItemIndex := 0;

end;

destructor TframeIncomingsList.Destroy;
begin
  inherited Destroy;
end;


initialization
  {$I estbk_fra_incomings_list.ctrs}

end.
