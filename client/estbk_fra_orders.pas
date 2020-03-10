unit estbk_fra_orders;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, ComCtrls, ExtCtrls, Grids,
  StdCtrls, Controls, Graphics, TypInfo, Clipbrd, estbk_fra_template, estbk_uivisualinit,
  estbk_strmsg, estbk_clientdatamodule, estbk_types, LCLIntf, LCLType, Dialogs,
  Buttons, EditBtn, estbk_frm_choosecustmer, estbk_fra_customer,
  estbk_sqlclientcollection, rxdbgrid, rxlookup, rxpopupunit, Contnrs, LCLProc,
  estbk_settings, estbk_globvars, estbk_utilities, estbk_frame_chooseaddr, estbk_reportconst,
  estbk_lib_commonevents, estbk_lib_commoncls, LR_DBSet, LR_Class, DB, memds, ZDataset,
  ZSequence;

type
  TframeOrders = class(Tfra_template)
    bh1: TBevel;
    bh2: TBevel;
    bh3: TBevel;
    bh4: TBevel;
    bh5: TBevel;
    btnPrint: TBitBtn;
    btnNewOrder: TBitBtn;
    btnClose: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnPeformTask: TBitBtn;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    bv1: TBevel;
    bv2: TBevel;
    bv3: TBevel;
    bv4: TBevel;
    bv5: TBevel;
    cmbVerified: TCheckBox;
    cmbChannelType: TComboBox;
    cmbOrderPlacedBy: TComboBox;
    cmbCountry: TComboBox;
    cmbWarehouse: TComboBox;
    cmbPerfAction: TComboBox;
    cmbSupplCont: TComboBox;
    edtVatSumTotal: TEdit;
    edtSumTotalWVat: TEdit;
    frrepdataset: TfrDBDataSet;
    frreport: TfrReport;
    lblvattotal: TLabel;
    lbltotalosum: TLabel;
    frrepmemdataset: TMemDataset;
    qryVatDs: TDatasource;
    dbOrderDate: TDateEdit;
    dbPrePaymentDuedate: TDateEdit;
    dummyTabFix: TEdit;
    edtSumtotal: TEdit;
    edtAparmNr: TEdit;
    edtContName: TEdit;
    edtCPersonPhone: TEdit;
    edtEMail: TEdit;
    edtHousenr: TEdit;
    edtMobPhone: TEdit;
    edtOrderNr: TEdit;
    edtPostalIndx: TEdit;
    edtCPersonEmail: TEdit;
    edtPrepaymentPerc: TEdit;
    edtVerifOrdernr: TEdit;
    lblOrderEvents: TLabel;
    lbltotalSum: TLabel;
    lblActionToPerform: TLabel;
    lblCPersonPhone: TLabel;
    lblOrdDt: TLabel;
    lblOrderAddedBy: TLabel;
    lblCustCountry: TLabel;
    lblEmail: TLabel;
    lblHousenr: TLabel;
    lblHousenr1: TLabel;
    lblHousenr2: TLabel;
    lblOrderToWarehouse: TLabel;
    lblOrdNr: TLabel;
    lblPhone: TLabel;
    lblPostalIdx: TLabel;
    lblPrepaimentDue: TLabel;
    lblPrepaymentPerc: TLabel;
    lblSec1: TLabel;
    lblSec3: TLabel;
    lblCPersonEmail: TLabel;
    lstboxOrderInfr: TListBox;
    pactPanel: TPanel;
    lblVerifOrdernr: TLabel;
    pInformationPanel: TPanel;
    pOrderData: TPanel;
    pOrdppanel: TPanel;
    qryArticlesDs: TDatasource;
    edtBillSumTotalBc: TEdit;
    edtBillSumTotalBco: TEdit;
    edtChannelUsed: TEdit;
    edtRoundBc: TEdit;
    edtRoundBco: TEdit;
    edtSumWOVatBc: TEdit;
    edtSumWOVatBco: TEdit;
    edtSupplierCode: TEdit;
    edtSupplMiscContact: TEdit;
    edtVatSumBc: TEdit;
    edtVatSumBco: TEdit;
    gridOrderLines: TStringGrid;
    grpOrder: TGroupBox;
    lblChannel: TLabel;
    lblChannelType: TLabel;
    lblSec2: TLabel;
    lblBillSumTotal: TLabel;
    lblSec4: TLabel;
    lbSupplMiscContact: TLabel;
    lblSupplAddr: TLabel;
    lblSupplId: TLabel;
    lblTotalSumWVat: TLabel;
    lblVatSum: TLabel;
    lblVatSum1: TLabel;
    pOrderChannelPanel: TPanel;
    pSupplPanel: TPanel;
    pMainPanel: TPanel;
    panelbottom: TPanel;
    qryArticles: TZQuery;
    qryOrderLinesSeq: TZSequence;
    qryVat: TZQuery;
    tabBillLines: TTabSheet;
    qryRWOrder: TZQuery;
    qryHelper: TZQuery;
    qryOrderSeq: TZSequence;
    lazFocusFix: TTimer;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewOrderClick(Sender: TObject);

    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnPeformTaskClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cmbPerfActionChange(Sender: TObject);
    procedure cmbSupplContChange(Sender: TObject);
    procedure cmbVerifiedChange(Sender: TObject);
    procedure dbOrderDateExit(Sender: TObject);
    procedure edtContNameKeyPress(Sender: TObject; var Key: char);
    procedure edtSupplierCodeExit(Sender: TObject);
    procedure edtSupplierCodeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtVerifOrdernrKeyPress(Sender: TObject; var Key: char);
    procedure frreportBeginBand(Band: TfrBand);
    procedure frreportEnterRect(Memo: TStringList; View: TfrView);
    procedure frreportGetValue(const ParName: string; var ParValue: variant);
    procedure gridOrderLinesClick(Sender: TObject);
    procedure gridOrderLinesDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure gridOrderLinesEditingDone(Sender: TObject);
    procedure gridOrderLinesEnter(Sender: TObject);
    procedure gridOrderLinesExit(Sender: TObject);
    procedure gridOrderLinesKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure gridOrderLinesKeyPress(Sender: TObject; var Key: char);
    procedure gridOrderLinesPickListSelect(Sender: TObject);
    procedure gridOrderLinesPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
    procedure gridOrderLinesSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
    procedure gridOrderLinesSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure gridOrderLinesSelection(Sender: TObject; aCol, aRow: integer);
    // --
    procedure OnMiscChange(Sender: TObject);
    procedure lazFocusFixTimer(Sender: TObject);

  protected
    // tellimuse read, mis kustutada
    FDeletedOrderLines: TObjectList;
    FReportFtrData: TAStrlist;

    FOrderWasClosed: boolean;
    FNewOrderRecord: boolean;
    FDataNotSaved: boolean;
    FLoadedOrderId: integer;
    FWarehouseId: integer;
    // ---
    FPaCurrColPos: integer;
    FPaCurrRowPos: integer;
    FDefaultCountryIndx: integer;
    FGridReadOnly: boolean;
    FSkipLookupChangeEvent: boolean;
    // 18.08.2010 Ingmar; lazaruse naljakas kala ? miks uude lahtrisse liikumine tekitab ka noole nupp vasakule ja paremale
    // seal nagu hiire klikkimisega pole mingit seost
    FKeyboardEventTriggered: boolean;
    FOrderType: TCOrderType;
    FClientSupplData: TClientData; // -- !

    FFrmAddr: TFrameAddrPicker;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FReqCurrUpdate: TRequestForCurrUpdate;

    FArticles: TRxDBLookupCombo;
    FVAT: TRxDBLookupCombo;

    FSkipOnChangeEvent: boolean;
    FRepDefFile: AStr;

    function getOrderNumber(const pReloadFlag: boolean): AStr;
    // lazaruse uus ver. tõi probleemi ehk editingdone ei rakendu, kui ntx lihtsalt sealt pealt ära liikuda, klikkides hiirega mujal mingit controli !
    procedure onEditingExitFix(Sender: TObject);

    procedure setOrderTYype(const v: TCOrderType);
    procedure enableDisablePTaskCtrls(const bStatus: boolean);
    procedure addOnChangeHandlers(const pParentCtrl: TWincontrol);
    procedure deleteOrderEntry(const pRow: integer);

    procedure doCleanup;
    // --

    procedure changecomboObjStatus(const b: boolean);
    function calculateSumTotal(): double;
    function calculateVatSumTotal(): double;

    procedure cleanInformationPanel;


    function calcRowCheckSum(const rowNr: integer): integer;
    procedure setCountryCode(const code: AStr);
    function buildOrderStatusStr: AStr;

    function verifyCurrentOrderStatus: boolean;
    function verifyOrderData(const pCollection: TCollection): boolean;
    function saveOrder: boolean;
    procedure loadWareHouseList;

    // ---
    procedure onLookupComboSelect(Sender: TObject);
    procedure onLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
    procedure onLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);

    procedure loadDefaultCSAddrData;
    procedure loadContactPersons(const pClientId: integer);
    procedure displayCSData(const pCSData: TClientData; const pSupplMode: boolean = True);
    function getRptFooterSummaryData(const labels: boolean = True): AStr;
    function getRptNotes: AStr;

    procedure updateFooterOrderSummary;

    // ---
    procedure calcOrderLineArtTotalPrice(const pOrderItem: TVerifiedOrderDataLines; var pArtTotalPrice: double; var pArtVat: double);
    procedure convertOrderDataToDynDataset(const pOrderItemsCollection: TCollection);
    procedure createReportDatasetDef;
    procedure clearReportDataset;
    procedure buildRptFooterStrList(const pOrderLines: TCollection; const pFtrData: TAStrlist);

  private

    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure setWarehouse(const v: integer);
  public
    procedure callCreateNewOrder;

    procedure refreshArticleList;
    procedure refreshInformationPanel(const orderID: integer);

    procedure openOrder(const orderID: integer);
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published // RTTI probleem
    // aruandluse path
    property reportDefPath: AStr read FRepDefFile write FRepDefFile;

    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property onAskCurrencyDownload: TRequestForCurrUpdate read FReqCurrUpdate write FReqCurrUpdate;
    // ---
    property orderType: TCOrderType read FOrderType write setOrderTYype;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
    property warehouseId: integer read FWarehouseId write setWarehouse; // peame õiged artiklid valima !
  end;

{

[reportdata."artcode"]
[reportdata."artdescr"]
[reportdata."artunit"]
[@SVartQty]
[@SVartItemPrice]
[@SVartItemDisc]
[@SVartLineSum]
[@SVOrdernr]
[@SVOrderSummaryLb]
[@SVBillSummaryVb]
[@SVOrdertNotes]
[@SCOrderName]
[@SVCustVatNr]
[@SCustaddr]
[@SCustregcode]
[@SCustname]
[@SCSndCapt]
[@CVCompCont]
[@CVCompAddr]
[@CVComprq]
[@CVCompName]
}



implementation

uses Math;

const
  CLeftHiddenCorn = -200;
  // ---
  CCol_Article = 1; // meie artiklid
  CCol_ArtSPCode = 2; // hankija artikli kood
  CCol_ArtLongDescr = 3;
  CCol_ArtUnit = 4;
  CCol_ArtAmount = 5;
  CCol_ArtPrice = 6;
  CCol_VatId = 7;
  CCol_VatSum = 8;
  CCol_ArtSumTotal = 9;
  CCol_LastImgCol = 10;



const
  // CValSendOrderPerEmail = 1;
  // CValOrderVerified     = 2;
  CValDoPrepayment = 1;
  CValAddPrepaymentBill = 2;
  CValCreateBillFromOrder = 3;

procedure TframeOrders.onEditingExitFix(Sender: TObject);
begin
  if not self.FGridReadOnly then
    gridOrderLinesEditingDone(self.gridOrderLines);
end;

procedure TframeOrders.callCreateNewOrder;
begin
  if btnNewOrder.Enabled then
    btnNewOrder.OnClick(btnNewOrder);
end;



procedure TframeOrders.setOrderTYype(const v: TCOrderType);
var
  b: boolean;
  pTemp: integer;
begin


  Assert(not (csLoading in self.ComponentState), '#1');
  FOrderType := v;
  b := (v = _coSaleOrder);
  lblPrepaimentDue.Visible := b;
  lblPrepaymentPerc.Visible := b;
  dbPrePaymentDuedate.Visible := b;
  edtPrepaymentPerc.Visible := b;

  // nö algväärtustamine, et pärast asjad toimiks nagu peab !
  pOrderData.Top := 4;
  pOrderData.Left := 1;

  pSupplPanel.Top := 84;
  pSupplPanel.Left := 1;

  pOrderChannelPanel.Top := 180;
  pOrderChannelPanel.Left := 1;

  pOrdppanel.Top := 4;
  pOrdppanel.Left := 390;

  pActPanel.Top := 248;
  pActPanel.Left := 385;

  grpOrder.Height := 321;

  panelbottom.Left := 5;
  panelbottom.Top := 324;

  pInformationPanel.Left := 390;
  pInformationPanel.Top := 140;



  case v of
    _coPurchOrder:
    begin
      grpOrder.Caption := estbk_strmsg.SCaptPurchaseOrder;
      pSupplPanel.Top := dbPrePaymentDuedate.Top + 7;
      pOrderChannelPanel.Top := pOrdppanel.Top - 2;  //;
      pOrderChannelPanel.Left := pOrdppanel.Left + 10;
      pOrdppanel.Visible := False;


      pInformationPanel.Top := pOrderChannelPanel.Top + pOrderChannelPanel.Height - 5;
      pInformationPanel.Left := pOrderChannelPanel.Left + 2;
      //pInformationPanel.Width:=200;
      pInformationPanel.Height := 97;


      // -- nö kaotame tühja ala
      grpOrder.Height := grpOrder.Height - 25;

      panelbottom.Top := panelbottom.Top - 35;
      panelbottom.Height := panelbottom.Height + 24;

      // kompilaator pahandab, kui teha prop. liitmised
      pTemp := pOrderChannelPanel.Top + pOrderChannelPanel.Height;
      //pactPanel.Top:=pTemp+75;
      pactPanel.Top := pTemp + 89;
      pactPanel.Visible := True;
      //pactPanel.Top:=pOrderChannelPanel.Top+pOrderChannelPanel.Height+8;
      pactPanel.Left := pOrderChannelPanel.Left + 1;
    end;

    _coSaleOrder:
    begin
      grpOrder.Caption := estbk_strmsg.SCaptSaleOrder;
      pSupplPanel.Visible := False;
      pOrderChannelPanel.Top := pSupplPanel.Top;
    end;
  end;

  // ---
end;

// standard proc !
function TframeOrders.getDataLoadStatus: boolean;
begin
  Result := True;
end;

procedure TframeOrders.setWarehouse(const v: integer);
begin
  self.FWarehouseId := v;
  // !!! aga ta peab olema eelnevalt avatud !!! sest loaddata pole muidu toimunud !
  if qryArticles.active then
  begin
    qryArticles.Close;
    qryArticles.SQL.Clear;
    qryArticles.SQL.Add(estbk_sqlclientcollection._SQLGetArticles);
    qryArticles.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryArticles.ParamByName('warehouse_id').AsInteger := self.FWarehouseId;

    // 12.03.2011 Ingmar; kuvame vaid "tavalisi" artikleid
    qryArticles.Filtered := False;
    qryArticles.Filter := 'special_type_flags=0';
    qryArticles.Filtered := True;


    qryArticles.Open;

    // ----
    self.loadWareHouseList;

  end;
end;

procedure TframeOrders.setDataLoadStatus(const v: boolean);
var
  pIntDsClass: TIntIDAndCTypes;
begin
  qryRWOrder.Close;
  qryRWOrder.SQL.Clear;

  qryHelper.Close;
  qryHelper.SQL.Clear;

  qryArticles.Close;
  qryArticles.SQL.Clear;

  qryVat.Close;
  qryVat.SQL.Clear;

  // ---
  clearComboObjects(cmbChannelType);
  cmbChannelType.Clear;

  if v then
  begin
    qryRWOrder.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryHelper.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryOrderSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryOrderLinesSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryArticles.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryVat.Connection := estbk_clientdatamodule.dmodule.primConnection;

    cmbCountry.ItemIndex := self.FDefaultCountryIndx;
    FFrmAddr.loadData := True;
    // --- laeme kanalid


    qryVat.SQL.Add(estbk_sqlclientcollection._CSQLGetVAT);
    qryVat.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryVat.Open;

    with qryHelper, SQL do
      try



        // küsime ühikud
        Close;
        Clear;
        add(estbk_sqlclientcollection._CSQLAmountNames);
        Open;
        First;
        while not EOF do
        begin
          gridOrderLines.Columns.Items[CCol_ArtUnit - 1].PickList.AddObject(FieldByName('amountname').AsString,
            TObject(cardinal(FieldByName('id').AsInteger)));
          Next;
        end;


        // millise kanali kaudu tellimus vormistati !
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLSelectOrderChannel);
        Open;

        cmbChannelType.AddItem(estbk_strmsg.SUnDefComboChoise, nil);
        while not EOF do
        begin

          pIntDsClass := TIntIDAndCTypes.Create;
          pIntDsClass.id := FieldByName('id').AsInteger;
          pIntDsClass.clf := FieldByName('idtype').AsString;

          cmbChannelType.AddItem(FieldByName('chname').AsString, pIntDsClass);
          Next;
        end;


        qryArticles.SQL.Add(estbk_sqlclientcollection._SQLGetArticles);
        qryArticles.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        qryArticles.ParamByName('warehouse_id').AsInteger := self.FWarehouseId;
        qryArticles.Open;

        qryArticles.Filtered := False;
        qryArticles.Filter := 'special_type_flags=0';
        qryArticles.Filtered := True;

        // --
        if cmbChannelType.items.Count > 1 then
          cmbChannelType.ItemIndex := 1;
        cmbChannelType.Style := csDropDownList;



        self.loadWareHouseList;
      finally
        Close;
        Clear;
      end;
    // ---
  end
  else
  begin
    qryVat.Connection := nil;
    qryOrderSeq.Connection := nil;
    qryOrderLinesSeq.Connection := nil;
    qryRWOrder.Connection := nil;
    qryHelper.Connection := nil;
    qryArticles.Connection := nil;

  end;
end;

procedure TframeOrders.enableDisablePTaskCtrls(const bStatus: boolean);
begin

  if cmbPerfAction.items.Count > 0 then
    cmbPerfAction.ItemIndex := 0;


  //    estbk_utilities.changeWCtrlEnabledStatus(lblActionToPerform,bStatus, 0);
  lblActionToPerform.Enabled := bStatus;
  estbk_utilities.changeWCtrlEnabledStatus(btnPeformTask, bStatus, 0);
  estbk_utilities.changeWCtrlEnabledStatus(cmbPerfAction, bStatus, 0);
end;

procedure TframeOrders.OnMiscChange(Sender: TObject);
var
  b: boolean;
begin

  b := not assigned(Sender);
  // --
  if not b then
    if Sender is TDateEdit then
      b := TDateEdit(Sender).Focused
    else
    if Sender is TCustomComboBox then
      b := TCustomComboBox(Sender).Focused
    else
    if Sender is TCustomEdit then
      b := TCustomEdit(Sender).Focused
    else
      b := Sender is TPickListCellEditor;

  // ---
  if b and not self.FGridReadOnly and not cmbVerified.Checked then
  begin
    btnSave.Enabled := True;
    btnCancel.Enabled := True;
    btnNewOrder.Enabled := False;
  end;
end;

procedure TframeOrders.lazFocusFixTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  if (gridOrderLines.Editor = self.FArticles) and self.FArticles.CanFocus then
    self.FArticles.SetFocus
  else
  if (gridOrderLines.Editor = self.FVAT) and self.FVAT.CanFocus then
    self.FVAT.SetFocus
  else
  if (gridOrderLines.Editor is TStringCellEditor) and TStringCellEditor(gridOrderLines.Editor).CanFocus then
    gridOrderLines.Editor.SetFocus;
end;

procedure TframeOrders.addOnChangeHandlers(const pParentCtrl: TWincontrol);
var
  i: integer;
  //pNotif : TNotifyEvent;
  //ppInfo : PPropInfo;
  Method: TMethod;
begin
  for i := 0 to pParentCtrl.ControlCount - 1 do
  begin
    // --
    if IsPublishedProp(pParentCtrl.Controls[i], 'OnChange') then
    begin
      Method.Code := self.MethodAddress('OnMiscChange');
      Method.Data := self;

      if GetOrdProp(pParentCtrl.Controls[i], 'OnChange') = 0 then
        SetMethodProp(pParentCtrl.Controls[i], 'OnChange', Method);
    end;

    if pParentCtrl.Controls[i] is TWinControl then
      addOnChangeHandlers(pParentCtrl.Controls[i] as TWinControl);
  end;
end;


procedure TframeOrders.deleteOrderEntry(const pRow: integer);
var
  pRowHasData: boolean;
  pOrdClass: TOrderDataClass;
  i, j: integer;
begin
  if pRow >= 1 then
  begin
    pRowHasData := False;
    // kas üldse on midagi kustutada...
    for i := 0 to gridOrderLines.Col do
    begin
      pRowHasData := trim(gridOrderLines.Cells[i, pRow]) <> '';
      if pRowHasData then
        break;
    end;

    // --

    pOrdClass := gridOrderLines.Objects[CCol_Article, pRow] as TOrderDataClass;
    pRowHasData := pRowHasData or assigned(pOrdClass);
    if pRowHasData and (Dialogs.messageDlg(estbk_strmsg.SConfDeleteOrderLine, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      // -- järelikult olemasolev rida, peame ka kustutamise baasis ära tegema, kui salvestatakse !
      if pOrdClass.FOrderLineID > 0 then
        self.FDeletedOrderLines.Add(pOrdClass)
      else
      begin
        gridOrderLines.Objects[CCol_Article, pRow].Free;
        gridOrderLines.Objects[CCol_Article, pRow] := nil;
      end;

      if assigned(gridOrderLines.Objects[CCol_VatId, pRow]) then
      begin
        gridOrderLines.Objects[CCol_VatId, pRow].Free;
        gridOrderLines.Objects[CCol_VatId, pRow] := nil;
      end;

      gridOrderLines.Clean(CCol_Article, pRow, CCol_ArtSumTotal, pRow, [gzNormal]);
      for i := pRow to gridOrderLines.rowcount - 2 do
      begin
        for j := 0 to gridOrderLines.colcount - 1 do
        begin
          if (j in [CCol_Article, CCol_VatId]) then
            self.gridOrderLines.Objects[j, i] := self.gridOrderLines.Objects[j, i + 1];
          self.gridOrderLines.Cells[j, i] := self.gridOrderLines.Cells[j, i + 1];
        end;
      end;




      // 08.08.2010 Ingmar, et mingit tobedust ei kuvataks !
      if self.FArticles.Visible then
        try
          self.FSkipLookupChangeEvent := True;
          self.FArticles.Text := '';
          self.FArticles.Value := '';
        finally
          self.FSkipLookupChangeEvent := False;
        end;

      // ...
      if self.FVAT.Visible then
        try
          self.FSkipLookupChangeEvent := True;
          self.FVAT.Text := '';
          self.FVAT.Value := '';
        finally
          self.FSkipLookupChangeEvent := False;
        end;




      // teavitame ka muudatusest !
      self.OnMiscChange(nil);

      // ---
      self.gridOrderLines.Row := self.gridOrderLines.Row + 1;
      self.gridOrderLines.Row := self.gridOrderLines.Row - 1;


      if self.gridOrderLines.Col = CCol_Article then
      begin
        if self.gridOrderLines.canFocus then
          self.gridOrderLines.SetFocus;

        if self.FArticles.CanFocus then
          self.FArticles.SetFocus;
      end
      else
      if self.gridOrderLines.Col = CCol_VatId then
      begin
        if self.gridOrderLines.canFocus then
          self.gridOrderLines.SetFocus;

        if self.FVAT.CanFocus then
          self.FVAT.SetFocus;
      end;
      // ---
    end;
  end;
end;

procedure TframeOrders.doCleanup;
begin
  try
    panelbottom.Color := estbk_types.MyFavOceanBlue;

    self.FSkipLookupChangeEvent := True;
    self.FKeyboardEventTriggered := False;
    self.FSkipOnChangeEvent := True;

    gridOrderLines.Row := 1;
    gridOrderLines.Col := 1;

    // --
    estbk_utilities.clearControlsWithTextValue(grpOrder);

    dbPrePaymentDuedate.date := now + estbk_globvars.glob_orderprepayment_wdays;
    //dbPrePaymentDuedate.text:='';
    dbOrderDate.date := now;
    edtPrepaymentPerc.Text := IntToStr(estbk_globvars.glob_orderprepayment_mperc);
    //edtSupplierCode.text:='';
    //edtSupplMiscContact.text:='';
    if cmbChannelType.items.Count > 0 then
      cmbChannelType.ItemIndex := 0;

    cmbPerfAction.ItemIndex := 0;
    //cmbPerfAction.Enabled:=true;
    estbk_utilities.changeWCtrlEnabledStatus(cmbPerfAction, False, 0);



    estbk_utilities.clearControlsWithTextValue(pOrderChannelPanel);
    estbk_utilities.clearControlsWithTextValue(pOrdppanel);


    estbk_utilities.clearControlsWithTextValue(pSupplPanel);
    estbk_utilities.clearControlsWithTextValue(pSupplPanel, 999);


    lstboxOrderInfr.Clear;
    edtOrderNr.Text := '';
    //    dbOrderDate.Text:='';

    edtSupplMiscContact.Text := '';
    edtSupplMiscContact.Hint := '';
    edtCPersonEmail.Text := '';
    edtCPersonPhone.Text := '';



    cmbVerified.Checked := False;


    if pOrdppanel.Visible then
    begin
      cmbCountry.ItemIndex := self.FDefaultCountryIndx;

      if FFrmAddr.loadData then
      begin
        FFrmAddr.country := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;
        FFrmAddr.countyID := 0;
        FFrmAddr.cityID := 0;
        FFrmAddr.streetID := 0;
      end;
    end; // ---

    //edtHousenr.text:='';
    //edtAparmNr.text:='';
    // edtPostalIndx.text:='';
    // edtMobPhone.text:='';
    //edtEMail.text:='';

    self.FNewOrderRecord := False;
    self.FDataNotSaved := False;
    self.FOrderWasClosed := False;
    self.FLoadedOrderId := 0;

    //if cmbChannelType.items.count>1 then
    cmbChannelType.ItemIndex := 0;

    if qryArticles.active then
      qryArticles.First;

    // ---
    self.gridOrderLines.Clean(CCol_Article, 1, CCol_ArtSumTotal, gridOrderLines.Rowcount - 1, [gzNormal]);
    self.gridOrderLines.Editor := TStringCellEditor(self.gridOrderLines.EditorByStyle(cbsAuto));



    // vaikimisi paneme tegevused kinni; avatakse kas peale uue arve salvestamist või vana tellimuse muutmist
    self.enableDisablePTaskCtrls(False);

    if cmbWarehouse.Items.Count > 0 then
      cmbWarehouse.ItemIndex := 0;



    if assigned(self.FArticles) then
    begin
      self.FArticles.Text := '';
      self.FArticles.Value := '';
    end;

    // ---
  finally
    self.FSkipOnChangeEvent := False;
    self.FSkipLookupChangeEvent := False;
  end;


  edtSumtotal.Text := '';
  edtVatSumTotal.Text := '';
  edtSumTotalWVat.Text := '';
  FReportFtrData.Clear;
  //     estbk_utilities.changeWCtrlEnabledStatus(leftPanel, not qryWarehouse.EOF, 0);
end;

procedure TframeOrders.setCountryCode(const code: AStr);
var
  i: integer;
begin
  cmbCountry.ItemIndex := self.FDefaultCountryIndx;
  for i := 0 to cmbCountry.items.Count - 1 do
    if estbk_globvars.glob_preDefCountryCodes.names[cardinal(cmbCountry.Items.Objects[i])] = code then
    begin
      cmbCountry.ItemIndex := i;
      break;
    end;
end;

function TframeOrders.calcRowCheckSum(const rowNr: integer): integer;
begin
  with gridOrderLines do
    Result := estbk_utilities.hashpjw(Cells[CCol_ArtSPCode, rowNr] + Cells[CCol_ArtLongDescr, rowNr] +
      Cells[CCol_ArtUnit, rowNr] + Cells[CCol_ArtAmount, rowNr] + Cells[CCol_ArtPrice, rowNr] + Cells[CCol_ArtSumTotal, rowNr] +
      Cells[CCol_VatId, rowNr]);
end;


procedure TframeOrders.changecomboObjStatus(const b: boolean);
begin
  cmbChannelType.Enabled := b;
  cmbOrderPlacedBy.Enabled := b;
  cmbCountry.Enabled := b;
  cmbWarehouse.Enabled := b;
  cmbSupplCont.Enabled := b;
  btnOpenClientList.Enabled := b;
  //   cmbPerfAction: TComboBox;
end;

// summa käibemaksuta !
function TframeOrders.calculateSumTotal(): double;
var
  i: integer;
  b: boolean;
begin
  Result := 0;
  try

    b := False;
    for i := 0 to gridOrderLines.RowCount - 1 do
      if (gridOrderLines.Cells[CCol_ArtSumTotal, i] <> '') then
      begin
        Result := Result + strtofloatdef(gridOrderLines.Cells[CCol_ArtSumTotal, i], 0);
        b := True;
      end;

    // -- alati kuvame visuaalselt summat
    if b then
      edtSumtotal.Text := trim(format(CCurrentMoneyFmt2, [Result]))
    else
      edtSumtotal.Text := '';
  except
    edtSumtotal.Text := estbk_strmsg.SEErr;
  end;
  // --
end;

function TframeOrders.calculateVatSumTotal(): double;
var
  i: integer;
  b: boolean;
begin
  Result := 0;

  try
    b := False;
    for i := 0 to gridOrderLines.RowCount - 1 do
      if (gridOrderLines.Cells[CCol_VatSum, i] <> '') then
      begin
        Result := Result + strtofloatdef(gridOrderLines.Cells[CCol_VatSum, i], 0);
        b := True;
      end;

    // -- alati kuvame visuaalselt summat
    if b then
      edtVatSumTotal.Text := trim(format(CCurrentMoneyFmt2, [Result]))
    else
      edtVatSumTotal.Text := '';
  except
    edtVatSumTotal.Text := estbk_strmsg.SEErr;
  end;
end;


procedure TframeOrders.cleanInformationPanel;
var
  i: integer;
begin
  for i := 0 to lstboxOrderInfr.Items.Count - 1 do
    if assigned(lstboxOrderInfr.Items.Objects[i]) then
    begin
      lstboxOrderInfr.Items.Objects[i].Free;
      lstboxOrderInfr.Items.Objects[i] := nil;
    end;

  // --
  lstboxOrderInfr.Clear;
end;

procedure TframeOrders.refreshInformationPanel(const orderID: integer);
var
  pItemStr: AStr;
  pStatusStr: AStr;
begin
  self.cleanInformationPanel;

  // if  orderID>0 then
  with qryHelper, SQL do
    try
      Close;
      Clear;
      // -- vaatame, kas tellimused tasutud...
      add(estbk_sqlclientcollection._SQLSelectOrderPmtData);
      // CPmtOrder_order;CPmtOrder_bill
      paramByname('item_type').AsString := estbk_types.CCommTypeAsOrder;

      //28.10.2010 Ingmar; teisel juhul kasutame olemasolevat ID'd
      if orderID > 0 then
        paramByname('item_id').AsInteger := orderID
      else
        paramByname('item_id').AsInteger := self.FLoadedOrderId;
      Open;
      pStatusStr := '';

      while not EOF do
      begin
        //  if  fieldbyname('payment_nr').asString
        //if estbk_utilities.isTrueVal(FieldByname('payment_confirmed').asString) then
        if pos(estbk_types.CPaymentRecStatusClosed, FieldByName('status').AsString) > 0 then
          pStatusStr := estbk_strmsg.SCStatusConfirmed
        else
          pStatusStr := estbk_strmsg.SCStatusUnConfirmed;
        pItemStr := format(SOrderPmtOrdData, [pStatusStr + #32 + FieldByName('payment_nr').AsString + '/' +
          datetostr(FieldByName('payment_date').AsDateTime) + #32 + format(CCurrentMoneyFmt2, [FieldByName('isum').asCurrency]) +
          #32 + FieldByName('currency').AsString]);

        lstboxOrderInfr.Items.Add(pItemStr);
        Next;
      end;

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLGetOrderBillingData(orderID, estbk_globvars.glob_company_id));
      Open;
      while not EOF do
      begin

        if pos(FieldByName('status').AsString, estbk_types.CRecIsClosed) > 0 then
          pStatusStr := estbk_strmsg.SCStatusConfirmed
        else
          pStatusStr := estbk_strmsg.SCStatusUnConfirmed;
        pItemStr := estbk_types.CLongBillName2[estbk_utilities.billTypeFromStr(FieldByName('bill_type').AsString)];
        pItemStr := pItemStr + #32 + '(' + FieldByName('bill_number').AsString + '/' + datetostr(FieldByName('bill_date').AsDateTime) +
          #32 + format(CCurrentMoneyFmt2, [FieldByName('totalsum').asCurrency + FieldByName('roundsum').asCurrency +
          FieldByName('vatsum').asCurrency]) + #32 + FieldByName('currency').AsString + #32 + pStatusStr + ')';

        lstboxOrderInfr.Items.Add(#32 + pItemStr);
        Next;
      end;

      // ---
      lstboxOrderInfr.ItemIndex := 0;

    finally
      Close;
      Clear;
    end;
end;

procedure TframeOrders.refreshArticleList;
begin
  qryArticles.Active := False;
  qryArticles.Active := True;
end;

procedure TframeOrders.openOrder(const orderID: integer);
var
  i: TCOrderType;
  j, k, pRowNr: integer;
  pWarehouseId: integer;
  pSalePersonId: integer;
  pCPersonId: integer;
  pCalc: double;
  // -- sisemine kontroll, et ridade summa = ikka tellimuse kogusummaga ilma KM'ta; võimaldab varakult vigu leida
  pChkCalcSumTotal: double;
  pChkCalcVatTotal: double;

  pOrdType: AStr;
  b: boolean;
  pCSData: TClientData;
  pOrdClass: TOrderDataClass;
  pVatClass: TVatDataClass2;

begin
  self.lazFocusFix.Enabled := False;
  self.doCleanup;

  with qryHelper, SQL do
    try
      self.FSkipLookupChangeEvent := True;

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectOrder);
      paramByname('id').AsInteger := orderId;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;


      // summa summaarium
      pChkCalcSumTotal := FieldByName('order_sum').asCurrency + FieldByName('order_vatsum').asCurrency;

      edtSumtotal.Text := trim(format(CCurrentMoneyFmt2, [FieldByName('order_sum').asCurrency]));
      edtVatSumTotal.Text := trim(format(CCurrentMoneyFmt2, [FieldByName('order_vatsum').asCurrency]));
      edtSumTotalWVat.Text := trim(format(CCurrentMoneyFmt2, [pChkCalcSumTotal]));

      // ---
      pChkCalcSumTotal := 0;
      pChkCalcVatTotal := 0;
      if EOF then
      begin
        self.FLoadedOrderId := -1;

        estbk_utilities.changeWCtrlEnabledStatus(pSupplPanel, False, 0);
        estbk_utilities.changeWCtrlEnabledStatus(pOrderChannelPanel, False, 0);
        estbk_utilities.changeWCtrlEnabledStatus(pOrdppanel, False, 0);
        estbk_utilities.changeWCtrlEnabledStatus(pOrderData, False, 0);
        estbk_utilities.changeWCtrlEnabledStatus(lstboxOrderInfr, False, 0);


        cmbVerified.Enabled := False;

        Exit; // !!!
      end;



      self.FLoadedOrderId := orderId;
      pOrdType := AnsiUpperCase(FieldByName('order_type').AsString);
      for i := low(TCOrderType) to high(TCOrderType) do
        if SCOrderTypes[i] = pOrdType then
        begin
          //self.OrderType:=i; !!! order type määrab meil disaini ära st setorder võiks vaid korra kutsuda...
          Self.FOrderType := i;
          break;
        end;

      // ------
      cmbChannelType.ItemIndex := 0;
      for j := 0 to cmbChannelType.items.Count - 1 do
        if assigned(cmbChannelType.items.objects[j]) and (TIntIDAndCTypes(cmbChannelType.items.objects[j]).id =
          FieldByName('order_channel_id').AsInteger) then
        begin
          cmbChannelType.ItemIndex := j;
          break;
        end;


      self.FFrmAddr.Enabled := True;




      // 08.08.2010 Ingmar
      pWarehouseId := FieldByName('warehouse_id').AsInteger;
      pSalePersonId := FieldByName('saleperson_id').AsInteger;

      edtChannelUsed.Text := FieldByName('order_channel').AsString;
      // ------
      edtOrderNr.Text := FieldByName('order_nr').AsString;
      dbOrderDate.date := FieldByName('order_date').AsDateTime;
      dbOrderDate.Text := datetostr(dbOrderDate.date);


      cmbVerified.Checked := pos(estbk_types.COrderVerified, FieldByName('status').AsString) > 0;
      // jätame meelde originaalstaatuse !
      self.FOrderWasClosed := cmbVerified.Checked;



      if not FieldByName('order_prp_due_date').isNull then
      begin
        dbPrePaymentDuedate.date := FieldByName('order_prp_due_date').AsDateTime;
        dbPrePaymentDuedate.Text := datetostr(dbPrePaymentDuedate.date);
      end
      else
      begin
        dbPrePaymentDuedate.date := FieldByName('order_date').AsDateTime;
        dbPrePaymentDuedate.Text := '';
      end;

      if not FieldByName('order_prp_perc').isNull then
      begin
        if FieldByName('order_prp_perc').AsFloat > 0 then
          edtPrepaymentPerc.Text := floatToStr(FieldByName('order_prp_perc').AsFloat)
        else
          edtPrepaymentPerc.Text := '';
      end
      else
        edtPrepaymentPerc.Text := '';

      // ---
      self.FFrmAddr.country := FieldByName('countrycode').AsString;
      self.FFrmAddr.countyId := FieldByName('county_id').AsInteger;
      self.FFrmAddr.cityId := FieldByName('city_id').AsInteger;
      self.FFrmAddr.streetId := FieldByName('street_id').AsInteger;

      edtContName.Text := FieldByName('contact').AsString;
      edtHousenr.Text := FieldByName('house_nr').AsString;
      edtAparmNr.Text := FieldByName('apartment_nr').AsString;
      edtPostalIndx.Text := FieldByName('zipcode').AsString;
      edtMobPhone.Text := FieldByName('phone').AsString;
      edtEMail.Text := FieldByName('email').AsString;




      // ----
      if self.OrderType = _coPurchOrder then
      begin

        //   edtSupplierCode.Text:=fieldbyname('client_id').asString;
        if assigned(self.FClientSupplData) then
          FreeAndNil(self.FClientSupplData);


        pCSData := estbk_fra_customer.getClientDataWUI_uniq(FieldByName('client_id').AsInteger);
        edtSupplierCode.Text := pCSData.FClientCode; // 11.02.2011 Ingmar

        pCPersonId := FieldByName('order_ccperson_id').AsInteger;
        self.loadContactPersons(FieldByName('client_id').AsInteger);
        displayCSData(pCSData, (self.OrderType = _coPurchOrder));




        cmbSupplCont.ItemIndex := 0;
        for k := 0 to cmbSupplCont.Items.Count - 1 do
          if assigned(cmbSupplCont.Items.Objects[k]) then
            if TClientContactPersonData(cmbSupplCont.Items.Objects[k]).FCId = pCPersonId then
            begin
              cmbSupplCont.ItemIndex := k;
              cmbSupplCont.OnChange(cmbSupplCont);
              break;
            end;
      end;



      // ---
      // laeme tellimuse read !
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectOrderLines);
      paramByname('order_id').AsInteger := orderID;
      Open;
      First;

      pRowNr := 1;
      while not EOF do
      begin
        pOrdClass := TOrderDataClass.Create;
        pOrdClass.FOrderLineId := FieldByName('id').AsInteger;
        gridOrderLines.Objects[CCol_Article, pRowNr] := pOrdClass;

        if FieldByName('item_id').AsInteger > 0 then
        begin
          gridOrderLines.Cells[CCol_Article, pRowNr] := FieldByName('item_code').AsString;
          if pRownr = 1 then
            self.FArticles.Text := FieldByName('item_code').AsString;
        end
        else
          gridOrderLines.Cells[CCol_Article, pRowNr] := ''; // meie tootekood !
        // ---

        gridOrderLines.Cells[CCol_ArtSPCode, pRowNr] := FieldByName('partcode').AsString; // hankija tootekood
        gridOrderLines.Cells[CCol_ArtLongDescr, pRowNr] := FieldByName('descr').AsString;
        gridOrderLines.Cells[CCol_ArtUnit, pRowNr] := FieldByName('unit').AsString;


        gridOrderLines.Cells[CCol_ArtAmount, pRowNr] := trim(format(CCurrentAmFmt3, [FieldByName('quantity').AsFloat]));
        gridOrderLines.Cells[CCol_ArtPrice, pRowNr] := trim(format(CCurrentMoneyFmt2, [FieldByName('price').asCurrency]));


        pCalc := FieldByName('price').asCurrency * FieldByName('quantity').AsFloat;

        pChkCalcSumTotal := pChkCalcSumTotal + pCalc; // kontroll !
        gridOrderLines.Cells[CCol_ArtSumTotal, pRowNr] := trim(format(CCurrentMoneyFmt2, [pCalc]));

        // --
        pChkCalcVatTotal := pChkCalcVatTotal + FieldByName('vat_rsum').asCurrency;
        gridOrderLines.Cells[CCol_VatSum, pRowNr] := trim(format(CCurrentMoneyFmt2, [FieldByName('vat_rsum').asCurrency]));


        if FieldByName('vat_id').AsInteger > 0 then
        begin
          pVatClass := TVatDataClass2.Create;
          pVatClass.FVatId := FieldByName('vat_id').AsInteger;
          pVatClass.FVatPerc := FieldByName('vat_perc').AsFloat;
          pVatClass.FVatLongDescr := FieldByName('vat_descr').AsString;
          pVatClass.FVatFlags := FieldByName('vat_flags').AsInteger;

          gridOrderLines.Objects[CCol_VatId, pRowNr] := pVatClass;
          gridOrderLines.Cells[CCol_VatId, pRowNr] := FieldByName('vat_descr').AsString;
        end;



        pOrdClass.FOrderLineChkSum := calcRowCheckSum(pRowNr);
        pOrdClass.FArtId := FieldByName('item_id').AsInteger;

        Inc(pRowNr);
        Next;
      end;
      // ---
    finally
      self.FSkipLookupChangeEvent := False;


      Close;
      Clear;
    end;



  // 18.08.2010 Ingmar; infopaneel
  self.refreshInformationPanel(orderID);
  assert(edtSumTotalWVat.Text = trim(format(CCurrentMoneyFmt2, [pChkCalcSumTotal + pChkCalcVatTotal])), '#3');


  // --- siin ohutu omistada !
  self.warehouseId := pWarehouseId;



  estbk_utilities.changeWCtrlEnabledStatus(pSupplPanel, True, 0);
  estbk_utilities.changeWCtrlEnabledStatus(pOrderChannelPanel, True, 0);
  estbk_utilities.changeWCtrlEnabledStatus(pOrdppanel, True, 0);
  estbk_utilities.changeWCtrlEnabledStatus(pOrderData, True, 0);
  estbk_utilities.changeWCtrlEnabledStatus(pInformationPanel, True, 0);


  cmbVerified.Enabled := True;


  b := cmbVerified.Checked;
  estbk_utilities.changeWCtrlReadOnlyStatus(pSupplPanel, b, 0);
  estbk_utilities.changeWCtrlReadOnlyStatus(pOrderChannelPanel, b, 0);
  estbk_utilities.changeWCtrlReadOnlyStatus(pOrdppanel, b, 0);
  estbk_utilities.changeWCtrlReadOnlyStatus(pOrderData, b, 0);


  self.changecomboObjStatus(not b);
  self.enableDisablePTaskCtrls(b);

  // kui kinnitatud tellimus, siis niisama muuta ei saa !!!!
  self.FGridReadOnly := b;

  //  btnAddNewOrder.enabled:=true;
  btnCancel.Enabled := False;
  btnSave.Enabled := False;

  btnPrint.Enabled := True;
  btnNewOrder.Enabled := True;
  self.pActPanel.Visible := True;


  // 09.08.2010 Ingmar
  if not self.FGridReadOnly then
  begin
    self.gridOrderLines.Editor := self.FArticles;
    self.gridOrderLines.row := 1;
    self.gridOrderLines.col := 1;

  end;
end;

procedure TframeOrders.dbOrderDateExit(Sender: TObject);
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
  // 01.03.2012 Ingmar
  edtOrderNr.Text := self.getOrderNumber(True);
end;

procedure TframeOrders.edtContNameKeyPress(Sender: TObject; var Key: char);
begin

end;


procedure TframeOrders.loadContactPersons(const pClientId: integer);
var
  pNewCData: TClientContactPersonData;
begin

  // ---
  with qryHelper, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectClientCPersons);
      paramByname('client_id').AsInteger := pClientId;
      Open;

      while not EOF do
      begin
        pNewCData := TClientContactPersonData.Create;
        pNewCData.FCId := FieldByName('id').AsInteger;
        // pNewCData.Fcname:=fieldByname('cname').asString;
        pNewCData.Fcaddr := FieldByName('caddr').AsString;
        pNewCData.Fcphone := FieldByName('cphone').AsString;
        pNewCData.Fcemail := FieldByName('cemail').AsString;

        cmbSupplCont.AddItem(FieldByName('cname').AsString, pNewCData);

        Next;
      end;
    finally
      Close;
      Clear;
    end;
end;

procedure TframeOrders.displayCSData(const pCSData: TClientData; const pSupplMode: boolean = True);
var
  pContact: AStr;
  pDummy: TClientContactPersonData;
begin
  case pSupplMode of
    True:
    begin

      if assigned(self.FClientSupplData) then
        FreeAndNil(self.FClientSupplData);

      // --
      if assigned(pCSData) then
      begin

        self.FClientSupplData := pCSData;
        edtSupplierCode.Text := pCSData.FClientCode; // inttostr(pCSData.FClientId);

        pContact := pCSData.FCustFullName + ' / ' + estbk_utilities.miscGenBuildAddr(pCSData.FCustJCountry,
          pCSData.FCustJCounty, pCSData.FCustJCity, pCSData.FCustJStreet, pCSData.FCustJHouseNr, pCSData.FCustJApartNr,
          pCSData.FCustJZipCode);

        edtSupplMiscContact.Text := pContact;
        edtSupplMiscContact.Hint := pContact;

        // TODO !!!!!!
        //edtSupplCont.Text:=pContacts;
        edtCPersonEmail.Text := pCSData.FCustEmail;
        edtCPersonPhone.Text := pCSData.FCustPhone;

        pDummy := TClientContactPersonData.Create;
        pDummy.Fcemail := pCSData.FCustEmail;
        pDummy.Fcphone := pCSData.FCustPhone;

        clearComboObjects(cmbSupplCont);
        cmbSupplCont.Clear;
        cmbSupplCont.AddItem(estbk_strmsg.SUnDefComboChoise, pDummy);
        self.loadContactPersons(pCSData.FClientId);
        self.OnMiscChange(nil);
      end
      else
      begin
        edtSupplierCode.Text := '';
        edtSupplMiscContact.Text := '';

        edtCPersonEmail.Text := '';
        edtCPersonPhone.Text := '';
        estbk_utilities.clearComboObjects(cmbSupplCont);
        cmbSupplCont.Clear;
        self.OnMiscChange(nil);
      end;
      // ---
    end;

    // -- !!
    False: ;
  end;
  // ---
end;

procedure TframeOrders.edtSupplierCodeExit(Sender: TObject);
var
  pnewCust: TClientData;
begin
  with TEdit(Sender) do
  begin
    if (Text = '') then
      self.displayCSData(nil)
    else
    if not assigned(FClientSupplData) or (strtointdef(Text, -1) <> self.FClientSupplData.FClientId) then
    begin
      //pnewCust:=estbk_customer.geTClientDataWUI(strtointdef(text,-1));
      pnewCust := estbk_fra_customer.getClientDataWUI(Text);
      self.displayCSData(pnewCust);
    end;
  end;
end;

procedure TframeOrders.edtSupplierCodeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    self.btnOpenClientListClick(btnOpenClientList);
    key := 0;
  end;
end;

procedure TframeOrders.edtVerifOrdernrKeyPress(Sender: TObject; var Key: char);
begin

  case Key of
    ^C:
    begin
      if assigned(Clipbrd.Clipboard) and (TListBox(Sender).ItemIndex >= 0) then
        Clipbrd.Clipboard.AsText := TListBox(Sender).Items.Strings[TListBox(Sender).ItemIndex];

      key := #0;
    end;
    #13:
    begin
      SelectNext(Sender as twincontrol, True, True);
      key := #0;
    end;
  end;
  // ---
end;

procedure TframeOrders.frreportBeginBand(Band: TfrBand);
begin
  // ---
end;

procedure TframeOrders.frreportEnterRect(Memo: TStringList; View: TfrView);
begin
  // ---
end;


function TframeOrders.getRptFooterSummaryData(const labels: boolean = True): AStr;
var
  i: integer;
begin
  Result := '';

  for i := 0 to self.FReportFtrData.Count - 1 do
    case labels of
      True: Result := Result + self.FReportFtrData.Names[i] + ':' + CRLF;
      False: Result := Result + self.FReportFtrData.ValueFromIndex[i] + CRLF;
    end;
end;

// lisainfo jaluses; ntx Tellimuse koostas
function TframeOrders.getRptNotes: AStr;
begin
  Result := '';
end;

procedure TframeOrders.frreportGetValue(const ParName: string; var ParValue: variant);
const
  // -- firma rekvisiidid
  _CVCompname = '@cvcompname'; // @1
  _CVComprq = '@cvcomprq';   // @2
  _CVCompAddr = '@cvcompaddr'; // @3
  _CVCompCont = '@cvcompcont'; // @4

  // --
  _CSCustAddr = '@scustaddr';    // hankija või tellija aadress
  _CSCustRegCode = '@scustregcode'; // hankija reg.kood
  _CSCustName = '@scustname';    // hankija nimi
  _CSCustDType = '@scsndcapt';    // ostutellimuse puhul on infoks hankija, müügitellimuse puhul klient

  _CSVartQty = '@svartqty';  //[@SVartQty]
  _CSVartItemPrice = '@svartitemprice';
  _CSVartItemDisc = '@svartitemdisc'; // hetkel veel ei toeta, see tekib müügitellimusele !
  _CSVartLineSum = '@svartlinesum'; // reasumma; artikli hind / allahindlus

  _CSOrdername = '@scordername';   // lihtsalt lisainfo, kas müügi või ostutellimus; paremal poolt päises
  _CSOrdernr = '@svordernr'; // tellimuse nr paremal pool
  _CSOrderdate = '@svorderdate'; // kuupäev
  _CSDueDate = '@svduedate';

  _CSOrderSummaryLb = '@svordersummarylb'; // vasakpoolne osa, kus summade kirjeldused jne
  _CSOrderSummaryVb = '@svordersummaryvb'; // parempoolne osa koos summadega

  _CSOrderNotes = '@svordertnotes';

const
  pTagArray: array[1..19] of AStr = (
    _CVCompname,   // @1
    _CVComprq,     // @2
    _CVCompAddr,   // @3
    _CVCompCont,   // @4
    // --
    _CSCustAddr,   // @5
    _CSCustRegCode,// @6
    _CSCustName,   // @7
    _CSCustDType,  // @8

    // --
    _CSVartQty,    // @9
    _CSVartItemPrice, // @10
    _CSVartItemDisc,  // @11
    _CSVartLineSum,   // @12

    _CSOrdername,     // @13
    _CSOrdernr,       // @14
    _CSOrderdate,     // @15
    _CSDueDate,       // @16

    _CSOrderSummaryLb, // @17
    _CSOrderSummaryVb, // @18
    _CSOrderNotes      // @19
    );

var
  prm: AStr;
  i, paramIndx: integer;

begin

  paramIndx := -1;
  prm := ansilowercase(ParName);
  if (pos('@', prm) = 0) or not assigned(self.FClientSupplData) then
    exit;


  for i := low(pTagArray) to high(pTagArray) do
    if pTagArray[i] = prm then
    begin
      paramIndx := i;
      break;
    end;




  case paramIndx of
    1: ParValue := estbk_globvars.glob_currcompname;        // _CVCompname
    2: ParValue := estbk_globvars.glob_currcompregcode;          // _CVComprq
    3: ParValue := estbk_globvars.glob_currcompaddr; // _CVCompAddr
    4: ParValue := estbk_globvars.glob_currcompcontacts;  // _CVCompCont
    // kliendi aadress
    5: ParValue := estbk_utilities.miscGenBuildAddr(self.FClientSupplData.FCustJCountry, self.FClientSupplData.FCustJCounty,
        self.FClientSupplData.FCustJCity, self.FClientSupplData.FCustJStreet, self.FClientSupplData.FCustJHouseNr,
        self.FClientSupplData.FCustJApartNr, self.FClientSupplData.FCustJZipCode, addr_orderfmt); // _CSCustAddr
    6: if self.FClientSupplData.FCustType = 'L' then // ainult jur. isiku puhul
        ParValue := self.FClientSupplData.FCustRegNr
      else
        ParValue := ''; // _CSCustRegCode

    7: ParValue := self.FClientSupplData.FCustFullNameRev; // _CSCustName
    8: case self.FOrderType of   // _CSCustDType
        _coPurchOrder: ParValue := estbk_strmsg.SCOrderCaptSuppl;
        _coSaleOrder: ParValue := estbk_strmsg.SCOrderCaptBuyer;
      end;

    9: ParValue := smartFloatFmt(frrepmemdataset.FieldByName('artqty').AsFloat, CCurrentAmFmt3);  // _CSVartQty
    10: ParValue := format(CCurrentMoneyFmt2, [frrepmemdataset.FieldByName('artprice').AsFloat]);  // _CSVartItemPrice
    11:
    begin   // _CSVartItemDisc
      if frrepmemdataset.FieldByName('artdiscount').AsFloat > 0 then
        ParValue := format('%d %%', [round(frrepmemdataset.FieldByName('artdiscount').AsFloat)])
      else
        ParValue := '';
    end;
    12: ParValue := format(estbk_types.CCurrentMoneyFmt2, [frrepmemdataset.FieldByName('artpricetotal').AsFloat]);   // _CSVartLineSum

    13: ParValue := SCOrderLongDescr[self.FOrderType];   // _CSOrdername

    14: ParValue := edtOrderNr.Text;   // _CSOrdernr;
    15: ParValue := datetostr(dbOrderDate.date);   // _CSOrderdate
    16: ParValue := '';   // _CSDueDate

    // --------------------------------------------------------------------------
    //  18: ParValue:=format(CCurrentMoneyFmt2,[qInvoiceMemDataset.FieldByname('artprice').asFloat]); // _CVArtItemPrice
    17: ParValue := getRptFooterSummaryData(True); // _CSOrderSummaryLb
    18: ParValue := getRptFooterSummaryData(False); // _CSOrderSummaryVb
    19: ParValue := getRptNotes(); // _CSOrderNotes
  end;
end;


procedure TframeOrders.gridOrderLinesClick(Sender: TObject);
begin
 {
     // --
 if  self.FKeyboardEventTriggered then
   begin
     self.FKeyboardEventTriggered:=false;
     exit;
   end;

 if  not (gridOrderLines.Col in [CCol_Article,CCol_VatId]) and gridOrderLines.CanFocus then
     gridOrderLines.setFocus;
  }
end;

procedure TframeOrders.gridOrderLinesDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin

  with TStringGrid(Sender) do
    if (aRow = 0) and (aCol > 0) then
    begin
      Canvas.FillRect(aRect);
      Canvas.TextOut(aRect.Left + 5, aRect.Top + 3, Columns.Items[aCol - 1].Title.Caption);
    end
    else
    if (gdFocused in aState) and (aCol = CCol_Article) then
    begin
      FArticles.Left := (aRect.Left + TStringGrid(Sender).Left) - 2;
      FArticles.Top := aRect.Top;
      FArticles.Width := (aRect.Right - aRect.Left) - 1;
      FArticles.Height := (aRect.Bottom - aRect.Top) + -3;
    end
    else
    if (gdFocused in aState) and (aCol = CCol_VatId) then
    begin
      FVAT.Left := (aRect.Left + TStringGrid(Sender).Left) - 2;
      FVAT.Top := aRect.Top;
      FVAT.Width := (aRect.Right - aRect.Left) - 1;
      FVAT.Height := (aRect.Bottom - aRect.Top) + -3;
    end
    else
    begin
      DefaultDrawCell(aCol, aRow, aRect, aState);
    end;
  //Canvas.TextOut(aRect.Left+5, aRect.Top+3,Cells[aCol,aRow]);

end;


// arvutab ridade pealt summa kokku; tulevikus peab vist jätma võimaluse, et saab ka neid lõppsummasid muuta !
procedure TframeOrders.updateFooterOrderSummary;
var
  pSumWA: double;
  pSumVat: double;
begin

  pSumWA := self.calculateSumTotal();
  pSumVat := self.calculateVatSumTotal();

  // ---
  try
    if edtSumtotal.Text <> '' then // muul juhul on mingi arvutusliku jamaga tegemist !
      edtSumTotalWVat.Text := trim(format(CCurrentMoneyFmt2, [pSumWA + pSumVat]))
    else
      edtSumTotalWVat.Text := '';
  except
    edtSumTotalWVat.Text := estbk_strmsg.SEErr;
  end;
end;

procedure TframeOrders.gridOrderLinesEditingDone(Sender: TObject);
var
  pTempVal: double;
  pCalcVat: double;
  pClsSum: boolean;
begin

  if self.FPaCurrColPos in [CCol_ArtAmount, CCol_ArtPrice, CCol_VatId] then
    with TStringGrid(Sender) do
    begin
      Cells[Col, FPaCurrRowPos] := trim(Cells[Col, FPaCurrRowPos]);
      if Cells[Col, FPaCurrRowPos] <> '' then
        case self.FPaCurrColPos of
          CCol_ArtAmount:
          begin
            pTempVal := strtofloatdef(Cells[Col, FPaCurrRowPos], 0);
            Cells[Col, Row] := trim(format(CCurrentAmFmt3, [pTempVal]));
          end;

          CCol_ArtPrice:
          begin
            pTempVal := strtofloatdef(Cells[Col, FPaCurrRowPos], 0);
            Cells[Col, Row] := trim(format(CCurrentMoneyFmt2, [pTempVal]));
          end;

        end
      else
      begin
        Cells[CCol_VatSum, FPaCurrRowPos] := '';
        Cells[CCol_ArtSumTotal, FPaCurrRowPos] := '';
      end;



      // nii lööme nüüd reasumma kokku
      if (trim(Cells[CCol_ArtAmount, FPaCurrRowPos]) <> '') and (trim(Cells[CCol_ArtPrice, FPaCurrRowPos]) <> '') then
        try
          pTempVal := roundto(strtofloatdef(Cells[CCol_ArtAmount, Row], 0) * strtofloatdef(Cells[CCol_ArtPrice, FPaCurrRowPos], 0), Z2);
          Cells[CCol_ArtSumTotal, FPaCurrRowPos] := trim(format(CCurrentMoneyFmt2, [pTempVal]));
          // 08.09.2010 Ingmar
          if assigned(Objects[CCol_VatId, FPaCurrRowPos]) then
            pCalcVat := roundto(pTempVal * (TVatDataClass2(Objects[CCol_VatId, FPaCurrRowPos]).FVatPerc / 100), Z2)
          else
            pCalcVat := 0;
          Cells[CCol_VatSum, FPaCurrRowPos] := trim(format(CCurrentMoneyFmt2, [pCalcVat]));
        except
          Cells[CCol_ArtSumTotal, FPaCurrRowPos] := estbk_strmsg.SEErr;
        end;
      // ---
    end; // -->


  self.updateFooterOrderSummary;
end;

procedure TframeOrders.gridOrderLinesEnter(Sender: TObject);
begin

  with TStringGrid(Sender) do
    Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto));

end;

procedure TframeOrders.gridOrderLinesExit(Sender: TObject);
begin
  self.lazFocusFix.Enabled := False;
  self.updateFooterOrderSummary;
end;

procedure TframeOrders.gridOrderLinesKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin

  self.FKeyboardEventTriggered := True;

  with gridOrderLines do
    case key of
      VK_DELETE: if not self.FGridReadOnly and (Shift = [ssCtrl]) then
        begin
          deleteOrderEntry(self.FPaCurrRowPos);
          key := 0;
        end;
      // CCol_LastImgCol
      VK_RETURN:  // if  Col= CCol_ArtSumTotal then
        // ---
      begin

        if (Col + 1 < ColCount - 1) then
          Col := Col + 1
        else
        if Row + 1 <= RowCount then
        begin
          Row := Row + 1;
          Col := 1;
        end;

        key := 0;
      end; // ---
    end;
end;

procedure TframeOrders.gridOrderLinesKeyPress(Sender: TObject; var Key: char);
var
  pData: AStr;
  pCPos, CFracPartLen: integer;
begin
  if (key = ^V) then
  begin
    key := #0; // paste keelame ära, ennem kui ei tea, kuidas kontrollida uute andmete sisu
    exit;
  end;




  if self.FPaCurrColPos in [CCol_ArtAmount, CCol_ArtPrice, CCol_VatSum] then
    with TStringGrid(Sender) do
      if assigned(Editor) then
      begin
        if key = '-' then
          key := #0
        else
        begin
          // nö select all ja talle override
          if (TCustomEdit(TStringGrid(Sender).Editor).SelLength = length(TCustomEdit(TStringGrid(Sender).Editor).Text)) and
            ((key in ['0'..'9', '+', '-']) or (Ord(key) <= 13)) then
            exit;

          if length(TCustomEdit(TStringGrid(Sender).Editor).Text) > 12 then
          begin
            key := #0;
            exit;
          end;

          if Ord(key) > 13 then
          begin
            CFracPartLen := 2;
            if self.FPaCurrColPos = CCol_ArtAmount then
              Inc(CFracPartLen);

            pCPos := pos('.', Cells[Col, Row]);
            if pCPos = 0 then
              pCPos := pos(',', Cells[Col, Row]);


            if pCPos > 0 then
            begin
              pData := system.copy(Cells[Col, Row], pCPos + 1, length(Cells[Col, Row]) - pCPos + 1);
              if length(pData) = CFracPartLen then
              begin
                key := #0;
                exit;
              end;
            end;
          end;

          // -----
          estbk_utilities.edit_verifyNumericEntry(Editor as TCustomEdit, key, True);
        end;
      end;
end;

procedure TframeOrders.gridOrderLinesPickListSelect(Sender: TObject);
begin
  self.OnMiscChange(TStringGrid(Sender).Editor);
end;

procedure TframeOrders.gridOrderLinesPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
var
  pts: TTextStyle;
begin
  pts := TStringGrid(Sender).Canvas.TextStyle;
  //  nagu arvetes
  if aCol in [CCol_ArtPrice, CCol_ArtAmount, CCol_ArtSumTotal] then
    pts.Alignment := taRightJustify
  else
    pts.Alignment := taLeftJustify;

  with TStringGrid(Sender).Canvas.Brush do
    if (aRow = 0) or (aCol = 0) then
      Color := clBtnFace
    else
    if aCol in [CCol_ArtSumTotal, CCol_VatSum] then
      Color := estbk_types.MyFavGray
    else
      Color := clWindow;
  TStringGrid(Sender).Canvas.TextStyle := pts;
end;

procedure TframeOrders.gridOrderLinesSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
begin

end;

procedure TframeOrders.gridOrderLinesSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
var
  //b : Boolean;
  pItemId: integer;
begin

  self.FPaCurrColPos := aCol;
  self.FPaCurrRowPos := aRow;


  //self.FArticles.Enabled:=false;


  // ---
  self.lazFocusFix.Enabled := False;

  // 18.08.2010 Ingmar; mingi jama, picklist jääb lahti ?
  //TStringGrid(Sender).EditorByStyle(cbsPicklist).Visible:=false;




  // ---
  if self.FGridReadOnly then
  begin
    Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto));
    Editor.Color := glob_userSettings.uvc_colors[uvc_activeGridEditorColor];
    TCustomEdit(Editor).ReadOnly := True;
    Exit;
  end;


  // ----
  //b:=(aCol=CCol_Article);
  //FArticles.Visible :=b;
  //FArticles.Enabled :=b;

  case aCol of
    CCol_Article:
    begin

      if not self.FSkipLookupChangeEvent then
        try
          self.FSkipLookupChangeEvent := True;

          self.FArticles.Enabled := True;
          self.FArticles.Text := '';
          self.FArticles.Value := '';

          Editor := self.FArticles;

          if assigned(gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
          begin

            pItemId := TOrderDataClass(gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtId;
            if (pItemId > 0) and (FArticles.LookupSource.DataSet.Locate('id', integer(pItemId), [])) then
              FArticles.Text := FArticles.LookupSource.DataSet.FieldByName('artcode').AsString;

          end;

                           {
                        if gridOrderLines.Canfocus then
                           gridOrderLines.SetFocus;


                            }

          //FArticles.OnKeyDown:=@self.OnLookupComboKeydown;
        finally
          self.FSkipLookupChangeEvent := False;
        end;

      // 09.08.2010 Ingmar; midagi eriti tobedat !
      // kui kenasti editor antud, ütleme ka, et fokuseeri
      // aga mida ei toimu on fokuseerimine !

      // ---
    end;

    CCol_VatId:
    begin

      if not self.FSkipLookupChangeEvent then
        try
          self.FSkipLookupChangeEvent := True;

          self.FVat.Enabled := True;
          self.FVat.Text := '';
          self.FVat.Value := '';
          Editor := self.FVat;

          if assigned(gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
          begin
            pItemId := TVatDataClass2(gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatId;
            if (pItemId > 0) and (self.FVat.LookupSource.DataSet.Locate('id', integer(pItemId), [])) then
              self.FVat.Text := FVat.LookupSource.DataSet.FieldByName('description').AsString;

          end;


        finally
          self.FSkipLookupChangeEvent := False;
        end;

      // ---
    end; // --


    CCol_ArtUnit: Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsPicklist));
    else
    begin
      Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto));
      TCustomEdit(Editor).ReadOnly := (aCol >= CCol_ArtSumTotal);
    end;
  end;

  // 09.08.2010 Ingmar; veel üks laz loogika fix
  if Editor is TStringCellEditor then
    with (Editor as TStringCellEditor) do
    begin

      SelLength := length(Text);
      SelStart := 1;
      // --
      Color := glob_userSettings.uvc_colors[uvc_activeGridEditorColor];
      Visible := True;

        {
        if gridOrderLines.CanFocus then
           gridOrderLines.SetFocus;

        if CanFocus then
           SetFocus;}
    end;

  // 18.08.2010 Ingmar; lazarus nagu mina, kipub fookuse ära unustama
  if TStringGrid(Sender).CanFocus then
    TStringGrid(Sender).SetFocus;
  lazFocusFix.Enabled := True;
end;

procedure TframeOrders.gridOrderLinesSelection(Sender: TObject; aCol, aRow: integer);
begin
  // --
end;



procedure TframeOrders.btnOpenClientListClick(Sender: TObject);
var
  pCS: TClientData;
begin
  pCS := estbk_frm_choosecustmer.__chooseClient(strtointdef(edtSupplierCode.Text, -1));
  if assigned(pCS) then
  begin
    self.displayCSData(pCS);

    if self.cmbChannelType.canFocus then
      self.cmbChannelType.SetFocus;

  end
  else // --
  begin
    self.displayCSData(nil);
  end;
end;

procedure TframeOrders.btnPeformTaskClick(Sender: TObject);
var
  pEventDCls: TReqOrderMiscData;
begin
  assert(assigned(self.FClientSupplData), '#2');
  if (cmbVerified.Checked) and assigned(onFrameDataEvent) then
    with cmbPerfAction do
      if ItemIndex >= 0 then
        case cardinal(Items.Objects[ItemIndex]) of
          CValDoPrepayment:
          begin
            pEventDCls := TReqOrderMiscData.Create;
            pEventDCls.FClientID := self.FClientSupplData.FClientId;
            pEventDCls.FItemId := FLoadedOrderId;
            pEventDCls.FItemType := cOrdItemAsPurchOrder;
            self.onFrameDataEvent(self,
              estbk_types.__frameReqCreateNewPaymentOrder,
              FLoadedOrderId,
              Pointer(pEventDCls));
          end;

          CValAddPrepaymentBill:
          begin
            pEventDCls := TReqOrderMiscData.Create;
            pEventDCls.FClientID := self.FClientSupplData.FClientId;
            pEventDCls.FItemId := FLoadedOrderId;

            self.onFrameDataEvent(self,
              estbk_types.__frameReqCreateNewPrepaymentBill,
              FLoadedOrderId,
              Pointer(pEventDCls));
          end;

          CValCreateBillFromOrder:
          begin
            pEventDCls := TReqOrderMiscData.Create;
            pEventDCls.FClientID := self.FClientSupplData.FClientId;
            pEventDCls.FItemId := FLoadedOrderId;
            pEventDCls.FItemType := cOrdItemAsBill;
            self.onFrameDataEvent(self,
              estbk_types.__frameCreateBillFromOrder,
              FLoadedOrderId,
              Pointer(pEventDCls));
          end;
        end
      else
        Dialogs.messageDlg(estbk_strmsg.SEOrderIsNotVerified, mtError, [mbOK], 0);
end;


procedure TframeOrders.calcOrderLineArtTotalPrice(const pOrderItem: TVerifiedOrderDataLines; var pArtTotalPrice: double; var pArtVat: double);
begin
  pArtTotalPrice := 0;
  pArtVat := 0;

  with pOrderItem do
  begin
    pArtTotalPrice := roundto(FArtQty * (FArtPrice - (FArtPrice * (FArtDiscount / 100))), Z2);
    if ((FArtVatClass.FVatFlags and estbk_types._CVtmode_turnover_tax) <> estbk_types._CVtmode_turnover_tax) then
      pArtVat := roundto(pArtTotalPrice * (FArtVatClass.FVatPerc / 100), Z2);
  end;
end;


procedure TframeOrders.convertOrderDataToDynDataset(const pOrderItemsCollection: TCollection);
var
  i, j: integer;
  bl: TVerifiedOrderDataLines;
  pArtPriceTotal: double;
  pArtVat: double;
  pBillNotes: AStr;
  pArtDescr: AStr;
begin
  with frrepmemdataset do
    try

      Close;
      Active := True;
      for i := 0 to pOrderItemsCollection.Count - 1 do
      begin
        bl := TVerifiedOrderDataLines(pOrderItemsCollection.items[i]);
        Append;

        FieldByName('artcode').AsString := bl.FArtCode;
        FieldByName('artdescr').AsString := bl.FArtDescr;
        FieldByName('artunit').AsString := bl.FArtUnit;

        FieldByName('artqty').AsFloat := bl.FArtQty;
        FieldByName('artprice').AsFloat := bl.FArtPrice;


        // ---
        pArtPriceTotal := 0;
        pArtVat := 0;

        FieldByName('artdiscount').AsFloat := bl.FArtDiscount;

        self.calcOrderLineArtTotalPrice(bl, pArtPriceTotal, pArtVat);
        FieldByName('artpricetotal').AsFloat := pArtPriceTotal;

        FieldByName('artvatperc').AsFloat := bl.FArtVatClass.FVatPerc;
        FieldByName('artvatid').AsInteger := bl.FArtVatClass.FVatID;
        FieldByName('artvatlongname').AsString := bl.FArtVatClass.FVatLongDescr;
        Post;
      end;


      // ----
    except
      on e: Exception do
        Dialogs.messageDlg(format(estbk_strmsg.SEError, [e.message]), mtError, [mbOK], 0);
    end;

end;


procedure TframeOrders.createReportDatasetDef;
begin
  with frrepmemdataset do
  begin
    Active := False;
    FieldDefs.Clear;



    // artikli andmed
    FieldDefs.Add('artcode', ftString, 30);
    FieldDefs.Add('artdescr', ftString, 200);
    FieldDefs.Add('artunit', ftString, 30);
    FieldDefs.Add('artqty', ftFloat, 0);
    FieldDefs.Add('artprice', ftFloat, 0);
    FieldDefs.Add('artvatperc', ftFloat, 0);
    FieldDefs.Add('artvatid', ftInteger, 0);
    FieldDefs.Add('artdiscount', ftFloat, 0);
    FieldDefs.Add('artpricetotal', ftFloat, 0);
    FieldDefs.Add('artvatlongname', ftString, 85);

  end;
end;


procedure TframeOrders.clearReportDataset;
begin
  frrepmemdataset.Clear;
  self.createReportDatasetDef;
end;

procedure TframeOrders.buildRptFooterStrList(const pOrderLines: TCollection; const pFtrData: TAStrlist);

  procedure internalbubbleSortOrderLinesByVat(const pOrderLines: TCollection);
  var
    cmp1, cmp2, temp: TVerifiedOrderDataLines;
    rIndex, rounds, cIndex: integer;
    done: boolean;
  begin
    done := False;
    rounds := 0;
    if pOrderLines.Count > 0 then
      while not (Done) do
      begin

        done := True;
        for rIndex := 0 to ((pOrderLines.Count - 2) - rounds) do
        begin

          cmp1 := pOrderLines.items[rIndex] as TVerifiedOrderDataLines;
          cmp2 := pOrderLines.items[rIndex + 1] as TVerifiedOrderDataLines;

          if (TVerifiedOrderDataLines(cmp1).FArtVatClass.FVatPerc > TVerifiedOrderDataLines(cmp2).FArtVatClass.FVatPerc) then
          begin
            Done := False;
            cIndex := pOrderLines.items[rIndex].Index;
            pOrderLines.items[rIndex].Index := pOrderLines.items[rIndex + 1].Index;
            pOrderLines.items[rIndex + 1].Index := cIndex;
          end;
        end;


        Inc(Rounds);

        // ---
      end;

  end;

var
  i, j, k: integer;
  pOrderLine: TVerifiedOrderDataLines;
  pOrderSumTotal: double;
  pItemSum: double;
  pItemVatSum: double;
  pCurrVatId: integer;
  pItemSumTotal: double;
  pVatSumTotal: double;
  pGrpVat: double;

  pCurr: AStr;
  pLongVatName: AStr;
  pTempVatNmBfr: TAStrList;
begin
  try
    // täpselt samamoodi nagu arvetes !!!
    pTempVatNmBfr := TAStrList.Create;
    pFtrData.Clear;
    pItemSumTotal := 0;
    pVatSumTotal := 0;

    pCurr := '';
    for i := 0 to pOrderLines.Count - 1 do
    begin
      pItemSum := 0;
      pItemVatSum := 0;
      self.calcOrderLineArtTotalPrice(pOrderLines.Items[i] as TVerifiedOrderDataLines, pItemSum, pItemVatSum);
      pItemSumTotal := pItemSumTotal + pItemSum;
    end;


    // eristame arve jaluses erinevaid käibemaksusid
    internalbubbleSortOrderLinesByVat(pOrderLines);
    i := 0;
    j := 0;

    while (j <= pOrderLines.Count - 1) do
    begin
      pOrderLine := pOrderLines.Items[i] as TVerifiedOrderDataLines;
      pCurrVatId := pOrderLine.FArtVatClass.FVatID;
      while j <= pOrderLines.Count - 1 do
      begin
        pOrderLine := pOrderLines.Items[j] as TVerifiedOrderDataLines;
        if pOrderLine.FArtVatClass.FVatID <> pCurrVatId then
          break;

        Inc(j);
      end;



      // võtame käibemaksu kirjelduse esimese kirje pealt !
      pOrderLine := pOrderLines.Items[i] as TVerifiedOrderDataLines;
      pLongVatName := pOrderLine.FArtVatClass.FVatLongDescr;

      //  ka tellimusel jätame pöördkäibemaksud välja !
      if (pOrderLine.FArtVatClass.FVatFlags and estbk_types._CVtmode_turnover_tax) <> _CVtmode_turnover_tax then
      begin
        pGrpVat := 0;
        // võtame fragmendi välja
        for k := i to j - 1 do
        begin
          pOrderLine := pOrderLines.Items[k] as TVerifiedOrderDataLines;
          pItemSum := 0;
          self.calcOrderLineArtTotalPrice(pOrderLine, pItemSum, pItemVatSum);
          pGrpVat := pGrpVat + pItemVatSum;
        end;

        pVatSumTotal := pVatSumTotal + pGrpVat;

        if trim(pLongVatName) <> '' then
          pTempVatNmBfr.Values[pLongVatName] := format(CCurrentMoneyFmt2, [pGrpVat]) + pCurr;
      end;
      // ---
      i := j;
      // ---
    end;




    // Summa
    pFtrData.values[estbk_strmsg.SCOrderCaptSum] := format(CCurrentMoneyFmt2, [pItemSumTotal]) + pCurr;


    for i := 0 to pTempVatNmBfr.Count - 1 do
      pFtrData.add(pTempVatNmBfr.Strings[i]);


    // Tellimuse summa kokku
    pOrderSumTotal := pItemSumTotal + pVatSumTotal;
    pFtrData.values[estbk_strmsg.SCOrderCaptSumTotal] := format(CCurrentMoneyFmt2, [pOrderSumTotal]) + pCurr;

  finally
    FreeAndNil(pTempVatNmBfr);
  end;
end;


procedure TframeOrders.btnPrintClick(Sender: TObject);
var
  pOrderItemsColl: TCollection;
  pVrf: TVerifiedOrderDataLines;
  pRepDef: AStr;
begin
  try

    pOrderItemsColl := TCollection.Create(TVerifiedOrderDataLines);
    if self.verifyOrderData(pOrderItemsColl) then
    begin
      self.convertOrderDataToDynDataset(pOrderItemsColl);
      self.buildRptFooterStrList(pOrderItemsColl, self.FReportFtrData);
      frrepmemdataset.First;



      pRepDef := includetrailingbackslash(self.reportDefPath) + estbk_reportconst.COrderReportFilename;

      if not FileExists(pRepDef) then
        raise Exception.CreateFmt(estbk_strmsg.SEReportDataFileNotFound, [pRepDef]);

      frreport.LoadFromFile(pRepDef);
      frreport.ShowReport;
    end;

  finally
    self.clearReportDataset;

    if assigned(pOrderItemsColl) then
      FreeAndNil(pOrderItemsColl);
  end;
end;

procedure TframeOrders.btnCancelClick(Sender: TObject);
begin
  btnPrint.Enabled := False;

  if self.FLoadedOrderId < 1 then
  begin
    self.doCleanup;

    // --
    estbk_utilities.changeWCtrlEnabledStatus(pSupplPanel, False, 0);
    estbk_utilities.changeWCtrlEnabledStatus(pOrderChannelPanel, False, 0);
    estbk_utilities.changeWCtrlEnabledStatus(pOrdppanel, False, 0);
    estbk_utilities.changeWCtrlEnabledStatus(pOrderData, False, 0);
    estbk_utilities.changeWCtrlEnabledStatus(pInformationPanel, False, 0);



    cmbVerified.Enabled := False;
    self.FGridReadOnly := True;

    // ---
    //btnAddNewOrder.Enabled:=true;
    //btnPeformTask.Enabled:=false;
    gridOrderLines.Editor := nil;
  end
  else
    // laeme andmed uuesti ?!?!?
  begin
    self.openOrder(self.FLoadedOrderId);
  end; // ---

  btnCancel.Enabled := False;
  btnSave.Enabled := False;
  btnNewOrder.Enabled := True;

end;

procedure TframeOrders.btnCloseClick(Sender: TObject);
begin
  // ---
  if assigned(self.onFrameKillSignal) then
    self.onFrameKillSignal(self);
end;

function TframeOrders.getOrderNumber(const pReloadFlag: boolean): AStr;
var
  pDate: TDatetime;
  pGenOrderNr: AStr;

begin
  // 01.03.2012 Ingmar
  if trim(dbOrderDate.Text) = '' then
    pDate := now
  else
    pDate := dbOrderDate.Date;

  // ---
  case self.FOrderType of
    _coSaleOrder: pGenOrderNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self),
        dbOrderDate.Text, pDate, pReloadFlag, CSOrder_doc_nr);

    _coPurchOrder: pGenOrderNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self),
        dbOrderDate.Text, pDate, pReloadFlag, CPOrder_doc_nr);
  end;
  // ---
  Result := pGenOrderNr;
end;

procedure TframeOrders.btnNewOrderClick(Sender: TObject);
var
  pGenOrderNr: AStr;
begin
  // -----------
  self.doCleanup;
  // -----------
  //self.actPanel.visible:=false;
  self.FFrmAddr.Enabled := True;

  //btnPeformTask.Enabled:=false;
  self.loadDefaultCSAddrData;

  self.FNewOrderRecord := True;
  self.FGridReadOnly := False;

  // 01.03.2012 Ingmar
  pGenOrderNr := getOrderNumber(False);
  edtOrderNr.Text := pGenOrderNr;
  cmbSupplCont.Enabled := True;
  // --
  estbk_utilities.changeWCtrlEnabledStatus(pSupplPanel, True, 0);
  estbk_utilities.changeWCtrlEnabledStatus(pOrderChannelPanel, True, 0);
  estbk_utilities.changeWCtrlEnabledStatus(pOrdppanel, True, 0);
  estbk_utilities.changeWCtrlEnabledStatus(pOrderData, True, 0);
  estbk_utilities.changeWCtrlEnabledStatus(pInformationPanel, True, 0);




  estbk_utilities.changeWCtrlReadOnlyStatus(pSupplPanel, False, 0);
  estbk_utilities.changeWCtrlReadOnlyStatus(pOrderChannelPanel, False, 0);
  estbk_utilities.changeWCtrlReadOnlyStatus(pOrdppanel, False, 0);
  estbk_utilities.changeWCtrlReadOnlyStatus(pOrderData, False, 0);


  changecomboObjStatus(True);



  cmbVerified.Enabled := False;




  //estbk_utilities.changeWCtrlEnabledStatus(cmbPerfAction,false, 0);
  if dbOrderDate.CanFocus then
    dbOrderDate.SetFocus;

  self.enableDisablePTaskCtrls(False);
  TBitBtn(Sender).Enabled := False;
  btnCancel.Enabled := True;
  btnSave.Enabled := True;
  btnPrint.Enabled := False;

  // --
  cmbVerified.Enabled := True;
end;



// -- hetkel üks staatus !
function TframeOrders.buildOrderStatusStr: AStr;
begin
  Result := '';
  if cmbVerified.Checked then
    Result := estbk_types.COrderVerified;
end;


function TframeOrders.verifyCurrentOrderStatus: boolean;
begin
  Result := False;

  if not self.FNewOrderRecord then
    with qryHelper, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLGetOrderBillingData(self.FLoadedOrderId, estbk_globvars.glob_company_id));
        Open;
      finally
        Close;
        Clear;
      end;

  // -- ok
  Result := True;
end;

function TframeOrders.verifyOrderData(const pCollection: TCollection): boolean;
var
  i: integer;
  pItemFilled, b: boolean;
  pNewCollItem: TVerifiedOrderDataLines;
begin
  Result := False;
  if not assigned(pCollection) then
    exit;

  pCollection.Clear;

  if (self.FOrderType = _coPurchOrder) and (not assigned(FClientSupplData) or (trim(edtSupplierCode.Text) = '')) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEContractorNotChoosen, mtError, [mbOK], 0);
    if btnOpenClientList.Canfocus then
      btnOpenClientList.SetFocus;
    Exit;
  end;

  if (trim(dbOrderDate.Text) = '') then
  begin
    Dialogs.MessageDlg(estbk_strmsg.SEOrderDateNotDefined, mtError, [mbOK], 0);
    if dbOrderDate.CanFocus then
      dbOrderDate.SetFocus;
    Exit;
  end;

  if trim(edtContName.Text) = '' then
  begin
    Dialogs.MessageDlg(estbk_strmsg.SEOrderPPersonMissing, mtError, [mbOK], 0);
    if edtContName.CanFocus then
      edtContName.SetFocus;
  end;

  // ---

  with gridOrderLines do
    for  i := 1 to rowcount - 1 do
    begin

      Cells[CCol_Article, i] := trim(Cells[CCol_Article, i]);
      Cells[CCol_ArtSPCode, i] := trim(Cells[CCol_ArtSPCode, i]);
      Cells[CCol_ArtLongDescr, i] := trim(Cells[CCol_ArtLongDescr, i]);

      // järelikult on mingi artikkel kirjeldatud !
      pItemFilled := (Cells[CCol_Article, i] <> '') or (Cells[CCol_ArtSPCode, i] <> '') or (Cells[CCol_ArtLongDescr, i] <> '');


      // kui pole artiklit valitud, siis ei tohiks olla teistel ridadel mingit infot, järelikult jamaga tegu
      b := (trim(Cells[CCol_ArtUnit, i]) <> '') or (trim(Cells[CCol_ArtAmount, i]) <> '') or (trim(Cells[CCol_ArtPrice, i]) <> '') or
        (trim(Cells[CCol_VatId, i]) <> '') or (trim(Cells[CCol_VatSum, i]) <> '');


      if not pItemFilled and b then
      begin
        Dialogs.MessageDlg(estbk_strmsg.SEOrderLinesIsInvalid, mtError, [mbOK], 0);
        Row := i;
        Exit;
      end;

      if not pItemFilled then
        continue;


      // 07.09.2010 Ingmar
      if (trim(Cells[CCol_VatId, i]) = '') or (strtofloatdef(Cells[CCol_VatSum, i], -1) < 0) then
      begin
        Dialogs.MessageDlg(estbk_strmsg.SEOrderVatNotDefined, mtError, [mbOK], 0);
        Row := i;
        Col := CCol_VatId;
        Exit;
      end;



      if (strtofloatdef(Cells[CCol_ArtAmount, i], -1) <= 0) then
      begin
        Dialogs.MessageDlg(estbk_strmsg.SEOrderItemAmountNotDefined, mtError, [mbOK], 0);
        Row := i;
        Col := CCol_ArtAmount;
        Exit;
      end;

      if (trim(Cells[CCol_ArtUnit, i]) = '') then
      begin
        Dialogs.messageDlg(estbk_strmsg.SEOrderArticleUnitNotDefined, mtError, [mbOK], 0);
        Row := i;
        Col := CCol_ArtUnit;
        Exit;
      end;



      // müügitellimusel PEAB olema meie artikkel ja hind olema määratud !!!!!!!!
      if (self.FOrderType = _coSaleOrder) then
      begin
        if (Cells[CCol_Article, i] = '') then
        begin
          Dialogs.MessageDlg(estbk_strmsg.SEOrderArticleNotDefined, mtError, [mbOK], 0);
          Row := i;
          Col := CCol_Article;
          Exit;
        end;

        if (strtofloatdef(Cells[CCol_ArtPrice, i], -1) <= 0) then
        begin
          Dialogs.MessageDlg(estbk_strmsg.SEOrderArticlePrcNotDefined, mtError, [mbOK], 0);
          Row := i;
          Col := CCol_ArtPrice;
          Exit;
        end;
        // ---
      end;


      pNewCollItem := TVerifiedOrderDataLines.Create(pCollection);
      // ---
      //pNewCollItem.FArtDefClass.FArtCode:=
      // kopeerime ühest klassist andmed teise ! sest lihtsalt viitama panna pole ohutu !!!!!!!!!!
      if assigned(Objects[CCol_Article, i]) then
        with TOrderDataClass(Objects[CCol_Article, i]) do
        begin
          pNewCollItem.FArtDefClass.FOrderLineID := FOrderLineID;
          pNewCollItem.FArtDefClass.FArtId := FArtId;
          pNewCollItem.FArtDefClass.FOrderLineChkSum := FOrderLineChkSum;
        end
      else
      begin
        // --- lihtalt ilusam nullida asjad
        pNewCollItem.FArtDefClass.FArtId := 0; // ntx meile, et tarnija koodiga artikkel !
        pNewCollItem.FArtDefClass.FOrderLineID := 0;
        pNewCollItem.FArtDefClass.FOrderLineChkSum := 0;
      end;



      if assigned(Objects[CCol_VatId, i]) then
        with TVatDataClass2(Objects[CCol_VatId, i]) do
        begin
          pNewCollItem.FArtVatClass.FVatAccountId := FVatAccountId;
          pNewCollItem.FArtVatClass.FVatId := FVatId;
          pNewCollItem.FArtVatClass.FVatPerc := FVatPerc;
          pNewCollItem.FArtVatClass.FVatFlags := FVatFlags;
          pNewCollItem.FArtVatClass.FVatLongDescr := FVatLongDescr;
        end
      else
      begin
        pNewCollItem.FArtVatClass.FVatAccountId := 0;
        pNewCollItem.FArtVatClass.FVatId := 0;
        pNewCollItem.FArtVatClass.FVatPerc := 0;
        pNewCollItem.FArtVatClass.FVatFlags := 0;
      end;



      // ---
      pNewCollItem.FArtDescr := Cells[CCol_ArtLongDescr, i];
      pNewCollItem.FArtUnit := Cells[CCol_ArtUnit, i];
      pNewCollItem.FArtPrice := strtofloatdef(Cells[CCol_ArtPrice, i], 0);
      pNewCollItem.FArtQty := strtofloatdef(Cells[CCol_ArtAmount, i], 0);


      // hankija tootekood !
      pNewCollItem.FPurchArtCode := Cells[CCol_ArtSPCode, i];
      // ---
      pNewCollItem.FArtVatSum := strtofloatdef(Cells[CCol_VatSum, i], 0);

    end;



  if pCollection.Count < 1 then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEOrderHasNoValidLines, mtError, [mbOK], 0);

    if gridOrderLines.CanFocus then
      gridOrderLines.SetFocus;
    // --
    Exit;
  end;

  // ---
  Result := True;
end;

function TframeOrders.saveOrder: boolean;
var
  //pNewItoId : Integer;
  pCustm, i: integer;
  pOrderItemsColl: TCollection;
  pVrf: TVerifiedOrderDataLines;
  pContPerson: TClientContactPersonData;
  b: boolean;
begin
  Result := False;

  try
    try

      pOrderItemsColl := TCollection.Create(TVerifiedOrderDataLines);
      if not self.verifyOrderData(pOrderItemsColl) then
        exit;




      dmodule.primConnection.StartTransaction;
      // nii väike kontroll ka...
      pCustm := self.FClientSupplData.FClientId;




      // pole erilist pointi cached updates kasutada
      with qryRWOrder, SQL do
        try

          // esmalt vaatame, kas meil ka midagi südamel...ntx kirjeid kustutada...
          if FDeletedOrderLines.Count > 0 then
            for i := 0 to self.FDeletedOrderLines.Count - 1 do
            begin
              Close;
              Clear;
              add(estbk_sqlclientcollection._SQLDeleteOrderLine);
              paramByname('rec_changed').AsDateTime := now;
              paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByname('id').AsInteger := TOrderDataClass(FDeletedOrderLines.Items[i]).FOrderLineID;
              execSQL;

            end;


          Close;
          Clear;

          if self.FNewOrderRecord then
          begin
            add(estbk_sqlclientcollection._SQLInsertOrder);

            FLoadedOrderId := qryOrderSeq.GetNextValue;
            paramByname('id').AsInteger := FLoadedOrderId;
            //paramByname('id').asInteger:=pNewItoId;
            paramByname('order_nr').AsString := edtOrderNr.Text;
            paramByname('order_type').AsString := estbk_types.SCOrderTypes[self.FOrderType];
            paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
            paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;

          end
          else
          begin
            add(estbk_sqlclientcollection._SQLUpdateOrder);
            paramByname('id').AsInteger := FLoadedOrderId;
          end;


          paramByname('order_date').AsDateTime := dbOrderDate.date;
          // reserveerime; aga üldiselt tekib see protsess peale tellimust kinnitamist !
          //paramByname('order_gen_bill_id').asInteger:=0; // tellimusest genereeritud arve
          //paramByname('order_prpayment_bill_id').asInteger:=0; // ettemaksuarve id

          // mis kuupäevaks peab olema ettemaks tasutud või tellimus kuulub tühistamisele !!! müügitellimus
          if self.FOrderType = _coSaleOrder then
          begin
            paramByname('order_prp_due_date').AsDateTime := dbPrePaymentDuedate.date;
            paramByname('order_prp_perc').AsFloat := strtofloatdef(edtPrepaymentPerc.Text, 0);
          end
          else
          begin
            // kas peaks andma võimaluse sisestada ettemaksu %, mis meie peame tegema
            paramByname('order_prp_due_date').Value := null;
            paramByname('order_prp_perc').AsFloat := 0;
          end;


          // üldiselt tulevikus teeme ka valiku, kus saab täpsustada, mis ajaks oodatakse tellimuse vastust
          paramByname('rel_delivery_date').Value := null;
          paramByname('client_id').AsInteger := pCustm;

          if cmbWarehouse.ItemIndex >= 0 then
          begin
            if assigned(cmbWarehouse.Items.Objects[cmbWarehouse.ItemIndex]) then
              paramByname('warehouse_id').AsInteger := TIntIDAndCTypes(cmbWarehouse.Items.Objects[cmbWarehouse.ItemIndex]).id
            else
              paramByname('warehouse_id').AsInteger := 0;
          end
          else
            paramByname('warehouse_id').AsInteger := 0;

          if cmbOrderPlacedBy.Text = '' then
            paramByname('saleperson_id').AsInteger := 0;

          // hetkel lisakirjeldust ei pane
          paramByname('descr').AsString := '';
          paramByname('countrycode').AsString := FFrmAddr.country;
          paramByname('county_id').AsInteger := FFrmAddr.countyId;
          paramByname('city_id').AsInteger := FFrmAddr.cityId;
          paramByname('street_id').AsInteger := FFrmAddr.streetId;
          paramByname('house_nr').AsString := edtHousenr.Text;
          paramByname('apartment_nr').AsString := edtAparmNr.Text;
          paramByname('zipcode').AsString := edtPostalIndx.Text;
          paramByname('phone').AsString := edtMobPhone.Text;
          paramByname('mobilephone').AsString := ''; //  kas dubleerimisel on pointi ?!?!?!?!
          paramByname('fax').AsString := '';
          paramByname('email').AsString := edtEMail.Text;
          paramByname('contact').AsString := edtContName.Text;


          if cmbChannelType.ItemIndex <= 0 then // 0 on ka määramatu valik
            paramByname('order_channel_id').AsInteger := 0
          else
            paramByname('order_channel_id').AsInteger := TIntIDAndCTypes(cmbChannelType.items.Objects[cmbChannelType.ItemIndex]).id;
          paramByname('order_channel').AsString := edtChannelUsed.Text;


          // reserveeritud; ntx meie esitame tarnijale tellimus, siis subjektis oleks antud kontaktisik
          // kui meilt telliti ntx müügitellimus; siis müügimehe nimi !!!
          paramByname('order_ccperson').AsString := '';
          paramByname('order_ccperson_id').AsInteger := 0;

          if cmbSupplCont.ItemIndex > 0 then
          begin
            pContPerson := TClientContactPersonData(cmbSupplCont.Items.Objects[cmbSupplCont.ItemIndex]);
            paramByname('order_ccperson_id').AsInteger := pContPerson.FCId;
            // !!! peame ka salvestama kontaktisiku täispika nime;
            // ntx kontaktisik kustutatakse ära, kui avamisel peame nägema, kellega oli tegu... !
            paramByname('order_ccperson').AsString := Copy(cmbSupplCont.Items.Strings[cmbSupplCont.ItemIndex], 1, 85);
          end;




          // TODO !!!!
          // kuupäev, millal reaalselt tellimus välja saadeti; kui meie hankijale, siis tellimuse saatmise kuupäev
          // müügitellimuse puhul, millal kliendile saatsime arve; ala kas ettemaksu arve teatise või koheselt väljastasime !
          paramByname('order_senddate').Value := null;
          paramByname('order_confdate').Value := null; // millal saime müügitellimuse ja aktsepteerisime selle


          // -----------------
          // hetkel reserveeritud !
          // üldiselt minu plaan selline, kohe müügitellimusest tekiks täisarve; kõik parameetrid
          // kus ka peal transpordi liik, kuhu ja transpordi tüüp; piisab vaid korra tellimus ära täita !!!
          paramByname('transport_type_id').AsInteger := 0;

          // ala tarnime 3-4 päeva jooksul; standardtekstid
          paramByname('delivery_statment_id').AsInteger := 0;




          // müügitellimus ntx. koheselt määratakse ka tellimuse saatmiseks kasutatav kanal
          // USPS; Eesti Post jne jne
          paramByname('delivered_by').AsString := '';
          paramByname('delivered_date').Value := null; // müügotellimuse peal, millal meie saatsime selle välja
          // ntx meie ostutellimuse kaup saabus, meile infoks; ala laoliikumine sissetulek
          paramByname('delivery_accept_date').Value := null;



          // 16.08.2010 Ingmar ridade kogusumma puudus !
          paramByname('order_sum').AsCurrency := self.calculateSumTotal();
          paramByname('order_vatsum').AsCurrency := self.calculateVatSumTotal();


          // TODO
          // ntx müügimees aktsepteeris ostutellimuse; peab olema users tabelis kirjeldatud !!!!
          paramByname('delivery_accept_by').AsInteger := 0;

          // hetkel ei toeta, sisuliselt saaks mingile kliendile teha fixed müügitellimus
          paramByname('template').AsString := 'f';

          if self.FNewOrderRecord then
            paramByname('status').AsString := ''
          else
            paramByname('status').AsString := self.buildOrderStatusStr;


          // 17.02.2011 Ingmar; TODO; valuutade toetus !
          paramByname('currency').AsString := estbk_globvars.glob_baseCurrency;
          paramByname('currency_drate_ovr').AsFloat := 1.00;



          paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByname('rec_changed').AsDateTime := now;
          execSQL;




          // --- ok tore...nüüd kirjutame tellimuse read ka andmebaasi...
          for i := 0 to pOrderItemsColl.Count - 1 do
          begin
            pVrf := TVerifiedOrderDataLines(pOrderItemsColl.items[i]);
            Close;
            Clear;

            // -- uus kirje
            if pVrf.FArtDefClass.FOrderLineID < 1 then
            begin
              add(estbk_sqlclientcollection._SQLInsertOrderLines);
              paramByname('order_id').AsInteger := FLoadedOrderId;
              paramByname('id').AsInteger := qryOrderLinesSeq.GetNextValue;
              paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
            end
            else
            begin
              add(estbk_sqlclientcollection._SQLUpdateOrderLines);
              paramByname('id').AsInteger := pVrf.FArtDefClass.FOrderLineID;
            end;

            // 07.09.2010 Ingmar
            paramByname('vat_id').AsInteger := pVrf.FArtVatClass.FVatId;
            paramByname('vat_account_id').AsInteger := pVrf.FArtVatClass.FVatAccountId;
            paramByname('vat_perc').AsFloat := pVrf.FArtVatClass.FVatPerc;
            paramByname('vat_rsum').AsFloat := pVrf.FArtVatSum;


            paramByname('item_id').AsInteger := pVrf.FArtDefClass.FArtId;
            paramByname('quantity').AsFloat := pVrf.FArtQty;
            paramByname('price').AsFloat := pVrf.FArtPrice;
            paramByname('price2').AsFloat := 0;  // hankija tootekood !! reserveeritud !!!
            paramByname('descr').AsString := pVrf.FArtDescr;
            paramByname('unit').AsString := pVrf.FArtUnit;
            paramByname('partcode').AsString := pVrf.FPurchArtCode; // hankija tootekood !!!
            paramByname('status').AsString := '';
            paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
            paramByname('rec_changed').AsDateTime := now;
            execSQL;

          end;




          // ----
          self.FNewOrderRecord := False;
          self.FDataNotSaved := False;

          self.FDeletedOrderLines.Clear;




          self.FFrmAddr.Enabled := False;
          self.enableDisablePTaskCtrls(cmbVerified.Checked);

          //self.pActPanel.visible:=true;
          //self.cmbPerfAction.Enabled:=true;


          // 28.09.2010 Ingmar; laeme andmed uuesti, et ridadel oleks adekvaatsed andmed. Muidu tuleb mööda ridu pendeldada...
          self.openOrder(FLoadedOrderId);
        finally
          Close;
          Clear;
        end;
      // --


      b := cmbVerified.Checked;
      estbk_utilities.changeWCtrlReadOnlyStatus(pSupplPanel, b, 0);
      estbk_utilities.changeWCtrlReadOnlyStatus(pOrderChannelPanel, b, 0);
      estbk_utilities.changeWCtrlReadOnlyStatus(pOrdppanel, b, 0);
      estbk_utilities.changeWCtrlReadOnlyStatus(pOrderData, b, 0);
      //estbk_utilities.changeWCtrlReadOnlyStatus(pInformationPanel,b, 0);



      // 09.09.2010 Ingmar
      self.FOrderWasClosed := b;
      cmbSupplCont.Enabled := not b;

      // ---
      self.FGridReadOnly := b;


      gridOrderLines.Editor := TStringCellEditor(gridOrderLines.EditorByStyle(cbsAuto));
      self.FArticles.Visible := False;


      self.enableDisablePTaskCtrls(cmbVerified.Checked);
      cmbVerified.Enabled := True;


      btnNewOrder.Enabled := True;
      btnCancel.Enabled := False;
      btnSave.Enabled := False;

      dmodule.primConnection.Commit;
      Result := True;


      // 19.05.2011 Ingmar
      case self.FOrderType of
        _coPurchOrder: dmodule.markNumeratorValAsUsed(PtrUInt(self), CPOrder_doc_nr, edtOrderNr.Text, dbOrderDate.Date);
        _coSaleOrder: dmodule.markNumeratorValAsUsed(PtrUInt(self), CSOrder_doc_nr, edtOrderNr.Text, dbOrderDate.Date);
      end;


      // --
    finally
      FreeAndNil(pOrderItemsColl);
      assert(not dmodule.primConnection.InTransaction, '#4');
    end; // ---


  except
    on e: Exception do
    begin
      if dmodule.primConnection.InTransaction then
        try
          dmodule.primConnection.Rollback;
        except
        end;
      Dialogs.messageDlg(format(estbk_strmsg.SEMajorAppError, [e.message]), mtError, [mbOK], 0);
    end;
  end;

end;

procedure TframeOrders.btnSaveClick(Sender: TObject);
begin
  self.saveOrder();
end;

// pVrf.FArtDefClass.FOrderLineID
procedure TframeOrders.loadWareHouseList;
var
  pDataEntry: TIntIDAndCTypes;
begin
  estbk_utilities.clearComboObjects(cmbWarehouse);
  cmbWarehouse.AddItem(estbk_strmsg.SDefaultWareHouse, nil);

  with qryHelper, SQL do
    try

      // cmbWarehouse
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLGetWarehouses(estbk_globvars.glob_company_id, self.FWarehouseId));
      Open;
      First;
      while not EOF do
      begin
        pDataEntry := TIntIDAndCTypes.Create;
        pDataEntry.id := FieldByName('id').AsInteger;

        cmbWarehouse.AddItem(FieldByName('name').AsString, pDataEntry);
        // --
        Next;
      end;

      cmbWarehouse.ItemIndex := 0;
    finally
      Close;
      Clear;
    end;
end;


procedure TframeOrders.Button1Click(Sender: TObject);
begin

end;

procedure TframeOrders.cmbPerfActionChange(Sender: TObject);
begin
  // --
end;


procedure TframeOrders.cmbSupplContChange(Sender: TObject);
begin
  with TComboBox(Sender) do
    if focused and (ItemIndex >= 0) then
    begin
      edtCPersonEmail.Text := TClientContactPersonData(Items.Objects[ItemIndex]).Fcemail;
      edtCPersonPhone.Text := TClientContactPersonData(Items.Objects[ItemIndex]).Fcphone;
      // --
      self.OnMiscChange(Sender);
    end;
end;


procedure TframeOrders.cmbVerifiedChange(Sender: TObject);
begin
  if TCheckbox(Sender).Tag = -1 then // välistame evendi rekursiooni !
    Exit;

  // ---
  if TCheckbox(Sender).Checked and TCheckbox(Sender).Focused then
  begin

    try
      TCheckbox(Sender).Tag := -1;
      if not self.saveOrder() then
        TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;
    finally
      TCheckbox(Sender).Tag := 0;
    end;

    // --
    Exit;
  end;




  // ---- Kinnitus võeti maha !
  // not self.FNewOrderRecord and
  if not self.FSkipOnChangeEvent and TCheckbox(Sender).Focused and self.FOrderWasClosed and not TCheckbox(Sender).Checked then
    try


      self.FSkipOnChangeEvent := True;
      if Dialogs.messageDlg(estbk_strmsg.SConfReOpenVerifOrder, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin

        // kontrollime üle, kas saame üldse taasavada tellimust !!
        if self.verifyCurrentOrderStatus then
        begin

          estbk_utilities.changeWCtrlEnabledStatus(pSupplPanel, True, 0);
          estbk_utilities.changeWCtrlEnabledStatus(pOrderChannelPanel, True, 0);
          estbk_utilities.changeWCtrlEnabledStatus(pOrdppanel, True, 0);
          estbk_utilities.changeWCtrlEnabledStatus(pOrderData, True, 0);
          estbk_utilities.changeWCtrlEnabledStatus(pInformationPanel, True, 0);




          estbk_utilities.changeWCtrlReadOnlyStatus(pSupplPanel, False, 0);
          estbk_utilities.changeWCtrlReadOnlyStatus(pOrderChannelPanel, False, 0);
          estbk_utilities.changeWCtrlReadOnlyStatus(pOrdppanel, False, 0);
          estbk_utilities.changeWCtrlReadOnlyStatus(pOrderData, False, 0);


          cmbPerfAction.ItemIndex := 0;
          TCheckbox(Sender).Enabled := False;

          // --
          self.FGridReadOnly := False;

          self.OnMiscChange(nil);
          self.FOrderWasClosed := False;


          // ----------------------
          // 10.04.2011 Ingmar; salvestame automaatselt !
          self.saveOrder();
          // ----------------------
        end
        else
          TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;
      end
      else
        TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;

      self.enableDisablePTaskCtrls(TCheckbox(Sender).Checked);

    finally
      self.FSkipOnChangeEvent := False;
    end;
end;



procedure TframeOrders.loadDefaultCSAddrData;
begin
  if self.FOrderType = _coPurchOrder then
    with qryHelper, SQL do
      try
        Close;
        Clear;

        // vaikimisi võtame firma/osakonna rekvisiidid
        if self.FWarehouseId < 1 then
        begin
          add(estbk_sqlclientcollection._CSQLSelectCompany);
          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          Open;

          edtContName.Text := FieldByName('company_name').AsString;
          FFrmAddr.country := FieldByName('countrycode').AsString;
          FFrmAddr.countyid := FieldByName('county_id').AsInteger;
          FFrmAddr.cityid := FieldByName('city_id').AsInteger;
          FFrmAddr.streetid := FieldByName('street_id').AsInteger;

          edtHousenr.Text := FieldByName('house_nr').AsString;
          edtAparmNr.Text := FieldByName('apartment_nr').AsString;
          edtPostalIndx.Text := FieldByName('zipcode').AsString;
          edtMobPhone.Text := FieldByName('phone').AsString;
          edtEMail.Text := FieldByName('email').AsString;
        end; // --

      finally
        Close;
        Clear;
      end; // --
end;



procedure TframeOrders.onLookupComboSelect(Sender: TObject);
begin
  self.lazFocusFix.Enabled := False;
  // --
  with TRxDBLookupCombo(Sender) do
    if not self.FSkipLookupChangeEvent then
      try
        self.FSkipLookupChangeEvent := True;

        if Sender = self.FArticles then
        begin
          if LookupSource.DataSet.IsEmpty then
          begin
            Dialogs.messageDlg(estbk_strmsg.SEArtNotFound, mtError, [mbOK], 0);
            exit;
          end;

          // ---
          Text := LookupSource.DataSet.FieldByName('artcode').AsString;


          // lisame puuduva andmeklassi, et lahtriga seotud andmeid hoida...
          if not assigned(self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
            self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos] := TOrderDataClass.Create();


          //TOrderDataClass(gridOrderLines.Objects[FPaCurrColPos,FPaCurrRowPos]).FArtCode:=LookupSource.DataSet.FieldByName('artcode').asString;
          TOrderDataClass(gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtId := LookupSource.DataSet.FieldByName('id').AsInteger;

          self.gridOrderLines.Cells[FPaCurrColPos, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('artcode').AsString;
          self.gridOrderLines.Cells[CCol_ArtLongDescr, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('artname').AsString;
          self.gridOrderLines.Cells[CCol_ArtUnit, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('unit').AsString;
          //self.gridOrderLines.Cells[CCol_ArtAmount,FPaCurrRowPos]:=trim(format(CCurrentAmFmt3,[1.000]));
          self.OnMiscChange(nil);

{
                              // artikli käibemaks ka !
              pVATId:=LookupSource.DataSet.FieldByName('vat_id').asInteger;
              // käibemaksu info juurde
           if qryVat.Locate('id',Integer(pVATId),[]) then
             begin}

          // 08.08.2010 Ingmar
          //if not PopupVisible then
          //   SetFocus;
        end
        else
        if Sender = self.FVAT then
        begin
          // ka käibemaksu lahtri andmeobjekti peame looma, kui seda soovitakse...
          if not assigned(self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
            self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos] := TVatDataClass2.Create();
          self.gridOrderLines.Cells[FPaCurrColPos, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('description').AsString;
          TVatDataClass2(self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatFlags :=
            LookupSource.DataSet.FieldByName('vatflags').AsInteger;

          // TODO
          TVatDataClass2(self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatAccountId := 0;
          // just nagu arvete juures !
          TVatDataClass2(self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatId := LookupSource.DataSet.FieldByName('id').AsInteger;
          TVatDataClass2(self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatPerc := LookupSource.DataSet.FieldByName('perc').AsFloat;

          // et pidevat locatet ei peaks tegema, see mälu kaotus ei ole suur !
          TVatDataClass2(self.gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatLongDescr :=
            LookupSource.DataSet.FieldByName('description').AsString;


          // peame ju käibemaksurea ka uuesti arvutama !! käibemaksumäär võis muutuda !
          self.gridOrderLinesEditingDone(self.gridOrderLines);
          self.OnMiscChange(nil);

        end;
      finally
        self.FSkipLookupChangeEvent := False;
        self.lazFocusFix.Enabled := True;
      end;   // ---
end;

procedure TframeOrders.onLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix();
end;



procedure TframeOrders.onLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if self.FGridReadOnly then
  begin
    key := 0;
    exit;
  end;

  // ---
  if (key = VK_DELETE) and (Shift = [ssCtrl]) then
  begin
    //deleteBillLine(self.FPaNewRowPos);
    //deleteBillLine(TStringGrid(Sender).row);
    self.deleteOrderEntry(self.FPaCurrRowPos);
    key := 0;
  end;


  // avame artiklite nimistu;
  if (Sender = self.FArticles) and (key = Ord('+')) and (Shift = [ssCtrl]) then
  begin
    // TODO !
  end
  else
  if (shift = []) then
    with TRxDBLookupCombo(Sender) do
      case key of
        VK_DELETE: if Sender = self.FArticles then
          begin
            if assigned(gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
            begin

              Text := '';

              if gridOrderLines.CanFocus then
                gridOrderLines.SetFocus;
              key := 0;


              if assigned(gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
              begin
                gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos].Free;
                gridOrderLines.Objects[FPaCurrColPos, FPaCurrRowPos] := nil;
              end;


              // 07.09.2010 Ingmar
              if assigned(gridOrderLines.Objects[CCol_VatId, FPaCurrRowPos]) then
              begin
                gridOrderLines.Objects[CCol_VatId, FPaCurrRowPos].Free;
                gridOrderLines.Objects[CCol_VatId, FPaCurrRowPos] := nil;
              end;


              // !!!!!!!!!!!!!!!!!!!!!!!!!
              self.gridOrderLines.Clean(CCol_Article, FPaCurrRowPos, CCol_ArtSumTotal, FPaCurrRowPos, [gzNormal]);
              // ---
            end;
          end;

        VK_RETURN,
        VK_TAB:
        begin
          if gridOrderLines.Col + 1 <= gridOrderLines.ColCount then
            gridOrderLines.Col := gridOrderLines.Col + 1;


          // if gridOrderLines.CanFocus then
          //   gridOrderLines.SetFocus;
          key := 0;
          self.FKeyboardEventTriggered := True;
        end;

        VK_LEFT: if not popUpVisible then
          begin

            if gridOrderLines.Col - 1 > 0 then
              gridOrderLines.Col := gridOrderLines.Col - 1;

            if gridOrderLines.CanFocus then
              gridOrderLines.SetFocus;
            key := 0;
            self.FKeyboardEventTriggered := True;

          end;


        VK_RIGHT: if not popUpVisible then
          begin
            if gridOrderLines.Col + 1 <= gridOrderLines.ColCount then
              gridOrderLines.Col := gridOrderLines.Col + 1;

            if gridOrderLines.CanFocus then
              gridOrderLines.SetFocus;

            key := 0;
            self.FKeyboardEventTriggered := True;

          end;

        VK_DOWN,
        VK_NEXT: if not popUpVisible then
          begin
            key := 0;

            if gridOrderLines.Row + 1 <= gridOrderLines.RowCount then
              gridOrderLines.Row := gridOrderLines.Row + 1;

            if gridOrderLines.CanFocus then
              gridOrderLines.SetFocus;
          end;

        VK_UP,
        VK_PRIOR: if not popUpVisible then
          begin

            if gridOrderLines.Row - 1 > 0 then
              gridOrderLines.Row := gridOrderLines.Row - 1;

            if gridOrderLines.CanFocus then
              gridOrderLines.SetFocus;

            key := 0;
          end;
      end;
  // --------------------------------
end;




constructor TframeOrders.Create(frameOwner: TComponent);
var
  pr: AStr;
  i, ptmpIndx: integer;
  pCollItem: TCollectionItem;
  pGridEditor: TStringCellEditor;
begin
  // 10.08.2010 Ingmar
  try
    inherited Create(frameOwner);

    FReportFtrData := TAStrlist.Create;
    // -------
    estbk_uivisualinit.__preparevisual(self);
    lblSupplId.Caption := estbk_strmsg.CSBillCp_supplier;

    FPaCurrColPos := 1;
    FPaCurrRowPos := 1;
    FGridReadOnly := True;

    FDeletedOrderLines := TObjectList.Create(True);

    FFrmAddr := TFrameAddrPicker.Create(nil);

    FFrmAddr.left := cmbCountry.left - 142;
    FFrmAddr.Width := 400;
    FFrmAddr.Height := 73;
    FFrmAddr.top := cmbCountry.top + cmbCountry.Height + 2; //118;
    FFrmAddr.Name := 'ordcstframe' + inttohex(random(99999), 6);
    FFrmAddr.lbCounty.left := FFrmAddr.lbCounty.left + 6;
    FFrmAddr.lbCity.left := FFrmAddr.lbCity.left + 6;
    FFrmAddr.lbStreet.left := FFrmAddr.lbStreet.left + 6;
    FFrmAddr.connection := estbk_clientdatamodule.dmodule.primConnection;

    //FFrmAddr.parent := pMainPanel;
    FFrmAddr.parent := pOrdppanel;


    FFrmAddr.Visible := True;

    FFrmAddr.comboCounty.Width := cmbCountry.Width;
    FFrmAddr.comboCity.Width := cmbCountry.Width;
    FFrmAddr.comboStreet.Width := cmbCountry.Width;
    FFrmAddr.tabOrder := dummyTabFix.tabOrder;
    dummyTabFix.tabStop := False;

    self.doCleanup;
    self.ForderType := estbk_types._coPurchOrder;

    // TODO: kui toode mutuub stabiilsemaks, kaota dubleeriv kood, sama ka lao juures !!!
    self.FDefaultCountryIndx := -1;
    for i := 0 to estbk_globvars.glob_preDefCountryCodes.Count - 1 do
    begin
      pr := estbk_globvars.glob_preDefCountryCodes.ValueFromIndex[i];
      system.Delete(pr, 1, pos(':', pr));

      ptmpIndx := cmbCountry.items.AddObject(pr, TObject(cardinal(i)));
      if AnsiUpperCase(estbk_globvars.glob_preDefCountryCodes.Names[i]) = estbk_globvars.Cglob_DefaultCountryCodeISO3166_1 then
        self.FDefaultCountryIndx := ptmpIndx;
    end;

    // --
    estbk_utilities.changeWCtrlEnabledStatus(pSupplPanel, False, 0);
    estbk_utilities.changeWCtrlEnabledStatus(pOrderChannelPanel, False, 0);
    estbk_utilities.changeWCtrlEnabledStatus(pOrdppanel, False, 0);
    estbk_utilities.changeWCtrlEnabledStatus(pOrderData, False, 0);
    estbk_utilities.changeWCtrlEnabledStatus(pInformationPanel, False, 0);




    FArticles := TRxDBLookupCombo.Create(self.gridOrderLines);
    FArticles.parent := self.gridOrderLines;
    FArticles.Visible := False;

    FArticles.ParentFont := False;
    FArticles.ParentColor := False;
    FArticles.ShowHint := True;
    FArticles.DoubleBuffered := True;
    //FArticles.OnExit:=@self.OnLookupComboExit;
    FArticles.Left := CLeftHiddenCorn;
    FArticles.Flat := True;

    FArticles.BorderStyle := bsNone;
    FArticles.PopUpFormOptions.BorderStyle := bsNone;
    FArticles.PopUpFormOptions.Options := [pfgIndicator, pfgRowlines, pfgCollines, pfgColumnResize];
    FArticles.PopUpFormOptions.TitleButtons := True;

    FArticles.DropDownCount := 15;
    FArticles.DropDownWidth := 315;

    FArticles.EmptyValue := #32;
    FArticles.UnfindedValue := rxufNone;
    //FArticles.UnfindedValue:=rxuforiginal;


    FArticles.ButtonWidth := 15;
    FArticles.ButtonOnlyWhenFocused := False;
    FArticles.Height := 23;
    FArticles.PopUpFormOptions.ShowTitles := True;


    //FArticles.OnExit:=@self.OnLookupComboExit;
    FArticles.OnSelect := @self.OnLookupComboSelect;
    //FArticles.OnChange:=@self.OnLookupComboChange;

    FArticles.OnClosePopupNotif := @self.OnLookupComboPopupClose;
    FArticles.OnKeyDown := @self.OnLookupComboKeydown;
    // FArticles.OnKeyDown2:=@self.OnLookupComboKeydown;

    FArticles.LookupSource := self.qryArticlesDs;
    FArticles.LookupDisplay := 'artcode;artname';
    FArticles.LookupField := 'id';


    pCollItem := FArticles.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SArtCode;
    (pCollItem as TPopUpColumn).Fieldname := 'artcode';
    (pCollItem as TPopUpColumn).Width := 85;


    pCollItem := FArticles.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SArtName;
    (pCollItem as TPopUpColumn).Fieldname := 'artname';
    (pCollItem as TPopUpColumn).Width := 130;



    FVAT := TRxDBLookupCombo.Create(self.gridOrderLines);
    FVAT.parent := self.gridOrderLines;
    FVAT.Visible := False;

    FVAT.ParentFont := False;
    FVAT.ParentColor := False;
    FVAT.ShowHint := True;
    FVAT.DoubleBuffered := True;

    FVAT.LookupSource := self.qryVATDs;
    FVAT.LookupDisplay := 'perc;description';
    FVAT.LookupField := 'id';
    // 22.04.2010
    FVAT.LookupDisplayIndex := 1;
    FVAT.Name := 'FVAT';


    pCollItem := FVAT.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SVATName;
    (pCollItem as TPopUpColumn).Fieldname := 'description';
    (pCollItem as TPopUpColumn).Width := 130;


    pCollItem := FVAT.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SVATPerc;
    (pCollItem as TPopUpColumn).Fieldname := 'perc';
    (pCollItem as TPopUpColumn).Width := 25;

    FVAT.OnClosePopupNotif := @self.OnLookupComboPopupClose;
    FVAT.OnKeyDown := @self.OnLookupComboKeydown;
    FVAT.OnSelect := @self.onLookupComboSelect;

{
        FVAT.OnEnter:=@self.OnLookupComboEnter;
        FVAT.OnExit:=@self.OnLookupComboExit;
        FVAT.OnSelect:=@self.OnLookupComboSelect;
        FVAT.OnChange:=@self.OnLookupComboChange;
}

    FVAT.Left := CLeftHiddenCorn;
    FVAT.Flat := True;
    FVAT.EmptyValue := #32;
    FVAT.UnfindedValue := rxufNone;
    FVAT.DropDownCount := 15;
    FVAT.DropDownWidth := 315;

    FVAT.ButtonWidth := 15;
    FVAT.ButtonOnlyWhenFocused := False;
    FVAT.Height := 23;
    FVAT.PopUpFormOptions.ShowTitles := True;
    FVAT.PopUpFormOptions.TitleButtons := True;

    //FVAT.OnGetGridCellProps:=@self.OnLookupGetGridCellProps;
    //FVAT.PopUpFormOptions.OnGetCellProps:=@self.OnLookupGetGridCellProps;



    cmbPerfAction.Items.AddObject(estbk_strmsg.SUnDefComboChoise, nil);
    //   cmbSupplCont.Items.AddObject(estbk_strmsg.SCmbActionSendOrderPerEmail,TObject(CValSendOrderPerEmail)); reserveeritud
    //   cmbPerfAction.Items.AddObject(estbk_strmsg.SCmbActionOrderVerified,TObject(CValOrderVerified));
    cmbPerfAction.Items.AddObject(estbk_strmsg.SCmbActionDoPrepayment, TObject(CValDoPrepayment));
    cmbPerfAction.Items.AddObject(estbk_strmsg.SCmbActionAddPrepaymentBill, TObject(CValAddPrepaymentBill));
    cmbPerfAction.Items.AddObject(estbk_strmsg.SCmbActionCreateBillFromOrd, TObject(CValCreateBillFromOrder));

    cmbVerified.Font.Style := [fsUnderline];
    cmbVerified.Enabled := False;


    self.addOnChangeHandlers(pMainPanel);
    self.cmbPerfAction.OnChange := nil;
    TStringCellEditor(gridOrderLines.EditorByStyle(cbsAuto)).OnChange := @self.OnMiscChange;
    TStringCellEditor(gridOrderLines.EditorByStyle(cbsAuto)).OnKeyDown := @self.gridOrderLinesKeyDown;
    TStringCellEditor(gridOrderLines.EditorByStyle(cbsAuto)).OnExit := @self.onEditingExitFix;


    TPickListCellEditor(gridOrderLines.EditorByStyle(cbsPicklist)).OnKeyDown := @self.gridOrderLinesKeyDown;


    lbltotalSum.Font.Style := [fsBold];
    lblvattotal.Font.Style := [fsBold];
    lbltotalosum.Font.Style := [fsBold];

    btnPrint.Enabled := False;

    // --
    self.createReportDatasetDef;

  except
    on e: Exception do
      // ---
      Dialogs.messageDlg(format(estbk_strmsg.SEInitializationZError, [e.message, self.ClassName]), mtError, [mbOK], 0);
  end;
end;

destructor TframeOrders.Destroy;
begin
  clearComboObjects(cmbWarehouse);
  clearComboObjects(cmbChannelType);
  FreeAndNil(FFrmAddr);

  self.FDeletedOrderLines.Clear;
  FreeAndNil(FDeletedOrderLines);
  FreeAndNil(FReportFtrData);

  dmodule.notifyNumerators(PtrUInt(self));
  inherited Destroy;
end;

initialization
  {$I estbk_fra_orders.ctrs}

end.