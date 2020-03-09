unit estbk_fra_order_list;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, ExtCtrls, StdCtrls, Buttons, Dialogs, LCLType,
  EditBtn, DBGrids, CheckLst, ZDataset, DB, Grids, estbk_fra_template, estbk_lib_commoncls, estbk_lib_commonevents, estbk_types, estbk_settings,
  estbk_globvars, estbk_clientdatamodule, estbk_sqlclientcollection, estbk_uivisualinit,
  estbk_strmsg, estbk_utilities, estbk_frm_choosecustmer, estbk_fra_customer;

type

  { TframeOrderList }

  TframeOrderList = class(Tfra_template)
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    btnNewOrder: TBitBtn;
    ordersGrid: TDBGrid;
    btnClean: TBitBtn;
    btnClose: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnSrc: TBitBtn;
    chkbxOnlyOverdueBills: TCheckBox;
    cmbOrderStatus: TComboBox;
    cmbOrderType: TComboBox;
    dtEdtAccDateEnd: TDateEdit;
    lblsign: TLabel;
    qryOrderListDs: TDatasource;
    dtEdtAccDateStart: TDateEdit;
    edtAccRecnr: TEdit;
    edtClientCode: TEdit;
    edtCustNameAndAddr: TEdit;
    grpBoxObjects: TGroupBox;
    lblOrderDate: TLabel;
    lblOrderNr: TLabel;
    lblOrderStatus: TLabel;
    lblCustId: TLabel;
    lblOrderType: TLabel;
    parentPanel: TPanel;
    qryOrderList: TZQuery;
    procedure btnNewOrderClick(Sender: TObject);
    procedure ordersGridDblClick(Sender: TObject);
    procedure ordersGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure ordersGridKeyPress(Sender: TObject; var Key: char);
    procedure ordersGridPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
    procedure btnCleanClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnSrcClick(Sender: TObject);
    procedure dtEdtAccDateStartExit(Sender: TObject);
    procedure edtClientCodeExit(Sender: TObject);
    procedure edtClientCodeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtClientCodeKeyPress(Sender: TObject; var Key: char);
  private

    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FLastclientID: integer;
    FLastClientCode: AStr;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure assignClientData(const pClient: TClientData);

  public
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published // RTTI probleem
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

uses Math, Graphics;

const
  CCol_orderNr = 0;
  CCol_orderDate = 1;
  //CCol_orderStatus  = 2;
  CCol_orderType = 2;
  CCol_ordersum = 3;
  CCol_currency = 4;
  CCol_orderPlName = 5; // tellimuse esitaja nimi
  CCol_orderRcName = 6; // tellimuse täitja



const
  COrderAllItems = 0;

const
  COrderStatusConfirmed = 1;
  COrderStatusUnConfirmed = 2;


const
  COrderTypeAsPurchOrder = 1;
  COrderTypeAsSaleOrder = 2;


procedure TframeOrderList.edtClientCodeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
  // 10.02.2011 Ingmar; enam ei nõua nr kohustuslikkust
  //else
  //if (Sender=edtClientCode)  then
  // begin
  //   estbk_utilities.edit_verifyNumericEntry(sender as TCustomEdit,key,false);
  // end;
end;

procedure TframeOrderList.btnSrcClick(Sender: TObject);
var
  pdtStart: TDatetime;
  pdtEnd: TDatetime;
  pOrdNr: AStr;
  pOrdStatus: byte;
  pOrdType: byte;
begin
  // ---
  pdtStart := Nan;
  pdtEnd := Nan;
  pOrdNr := edtAccRecnr.Text;

  if dtEdtAccDateStart.Text <> '' then
    pdtStart := dtEdtAccDateStart.Date;

  if dtEdtAccDateEnd.Text <> '' then
    pdtEnd := dtEdtAccDateEnd.Date;



  pOrdStatus := 0;
  pOrdType := 0;
  if cmbOrderStatus.ItemIndex >= 0 then
    pOrdStatus := integer(cmbOrderStatus.items.objects[cmbOrderStatus.ItemIndex]);

  if cmbOrderType.ItemIndex >= 0 then
    pOrdType := integer(cmbOrderType.items.objects[cmbOrderType.ItemIndex]);


  qryOrderList.Close;
  qryOrderList.SQL.Clear;
  qryOrderList.SQL.add(estbk_sqlclientcollection._SQLSrcOrders(pOrdType, pOrdStatus, self.FLastclientID, pOrdNr, pdtStart, pdtEnd, '',
    // pOrderContactPerson
    chkbxOnlyOverdueBills.Checked));
  qryOrderList.Open;

  if qryOrderList.EOF then
  begin
    ordersGrid.DataSource := nil;
    Dialogs.messageDlg(estbk_strmsg.SEQryRetNoData, mtError, [mbOK], 0);
    exit;
  end
  else
    ordersGrid.DataSource := qryOrderListDs;
end;

procedure TframeOrderList.dtEdtAccDateStartExit(Sender: TObject);
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

procedure TframeOrderList.assignClientData(const pClient: TClientData);
begin
  if not assigned(pClient) then
  begin
    edtClientCode.Text := '';
    edtCustNameAndAddr.Text := '';

    self.FLastClientCode := '';
    self.FLastclientID := 0;
  end
  else
  begin
    edtCustNameAndAddr.Text := pClient.FCustFullName;
    edtClientCode.Text := pClient.FClientCode; //inttostr(pClient.FClientId);

    self.FLastClientCode := pClient.FClientCode;
    self.FLastclientID := pClient.FClientId;
  end;
end;

procedure TframeOrderList.edtClientCodeExit(Sender: TObject);
var
  pClient: TClientData;
begin
  pClient := nil;
  // ---
  with TEdit(Sender) do
    if Text <> '' then
      try

        if self.FLastClientCode <> Text then
        begin
          //pClient:=estbk_customer.getClientDataWUI(strtointdef(edtClientCode.text,99999999));
          pClient := estbk_fra_customer.getClientDataWUI(edtClientCode.Text);
          self.assignClientData(pClient);
        end;

        // ---
      finally
        if assigned(pClient) then
          FreeAndNil(pClient);
      end
    else
      assignClientData(nil);
end;

procedure TframeOrderList.edtClientCodeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    btnOpenClientListClick(btnOpenClientList);
    key := 0;
  end;
end;

procedure TframeOrderList.btnCloseClick(Sender: TObject);
begin
  if assigned(self.onFrameKillSignal) then
    self.onFrameKillSignal(self);
end;

procedure TframeOrderList.btnOpenClientListClick(Sender: TObject);
var
  pClient: TClientData;
begin
  try
    pClient := estbk_frm_choosecustmer.__chooseClient(strtointdef(edtClientCode.Text, 99999999));
    assignClientData(pClient);
    // ---
  finally
    FreeAndNil(pClient);
  end;
end;

procedure TframeOrderList.btnCleanClick(Sender: TObject);
begin
  cmbOrderStatus.ItemIndex := 0;
  cmbOrderType.ItemIndex := 0;


  // ---
  estbk_utilities.clearControlsWithTextValue(grpBoxObjects);
  self.FLastclientID := 0;
  self.FLastClientCode := '';
  chkbxOnlyOverdueBills.Checked := False;
  dtEdtAccDateStart.Text := '';
  dtEdtAccDateEnd.Text := '';
  edtCustNameAndAddr.Text := '';

  qryOrderList.Close;
  qryOrderList.SQL.Clear;
  qryOrderList.SQL.add(estbk_sqlclientcollection._SQLSrcOrders());
  qryOrderList.Open;

  if qryOrderList.RecordCount > 0 then
    ordersGrid.DataSource := qryOrderListDs
  else
    ordersGrid.DataSource := nil;

  if edtClientCode.CanFocus then
    edtClientCode.SetFocus;
end;

procedure TframeOrderList.ordersGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
var

  pFieldVal: AStr;
  pOrderType: AStr;
  pTotalRowSum: currency;
  pts: TTextStyle;
begin
  with TDbGrid(Sender) do
  begin
    Canvas.FillRect(Rect);

    if assigned(Column.Field) then
      pFieldVal := Column.Field.AsString
    else
      pFieldVal := '';


    pts := Canvas.TextStyle;
    pts.Alignment := taLeftJustify;


    if assigned(DataSource) then
      with DataSource.DataSet do
        // -- vastavalt reziimile koostame lahtrite sisu
        if not qryOrderList.isEmpty then
          case dataCol of
            // o.order_sum,o.order_roundsum,o.order_vatsum,o.paid_sum,o.payment_status
            // currency
            // o.client_id,k.name as firstname,k.lastname,k.regnr
            // contact
            // order_ccperson
            CCol_ordersum:
            begin
              pts.Alignment := taRightJustify;
              //pTotalRowSum:=fieldbyname('order_sum').asCurrency+fieldbyname('order_roundsum').asCurrency+fieldbyname('order_vatsum').asCurrency;
              pFieldVal := trim(format(estbk_types.CCurrentMoneyFmt2, [Column.Field.AsCurrency])) + #32;

            end;
       (*
       CCol_orderStatus: begin
                         if FieldByName('order_status').asString=estbk_types.COrderVerified then
                            pFieldVal:=estbk_strmsg.SCStatusConfirmed
                         else
                            pFieldVal:=estbk_strmsg.SCStatusUnConfirmed;
                         end; // -- *)

            CCol_orderType:
            begin
              if FieldByName('order_type').AsString = estbk_types._COAsPurchOrder then
                pFieldVal := estbk_strmsg.SCaptPurchaseOrder
              else
              if FieldByName('order_type').AsString = estbk_types._COAsSaleOrder then
                pFieldVal := estbk_strmsg.SCaptSaleOrder;
            end;

            CCol_orderPlName:
            begin
              if FieldByName('order_type').AsString = estbk_types._COAsPurchOrder then  // _COAsSaleOrder
                pFieldVal := trim(FieldByName('contact').AsString);
            end; {else
                          if (dataCol= cCol_orderRcName) then
                          begin
                           if FieldByName('order_type').asString=estbk_types._COAsPurchOrder then
                              pFieldVal:=FieldByName('firstname').asStr+#32+FieldByName('lastname').asStr;
                          end; }
            CCol_orderRcName:
            begin
              if FieldByName('order_type').AsString = estbk_types._COAsPurchOrder then  // _COAsSaleOrder
                pFieldVal := trim(FieldByName('firstname').AsString + #32 + FieldByName('lastname').AsString);
            end;
          end
        else
          pFieldVal := '';

    // ---
    Canvas.TextRect(Rect, Rect.Left + 5, Rect.Top + 2, pFieldVal, Canvas.TextStyle);
  end;
end;

procedure TframeOrderList.ordersGridKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    self.OrdersGridDblClick(Sender);
    key := #0;
  end;
end;

procedure TframeOrderList.ordersGridDblClick(Sender: TObject);
begin
  // if ordersGrid.SelectedRows.Count>0 then
  if assigned(self.FFrameDataEvent) and not qryOrderList.isEmpty then
    self.FFrameDataEvent(Self, __frameOpenOrderEntry, qryOrderList.FieldByName('id').AsInteger);
end;

procedure TframeOrderList.btnNewOrderClick(Sender: TObject);
begin
  self.onFrameDataEvent(self, __frameCreateNewPOrder, -1, nil);
end;

procedure TframeOrderList.ordersGridPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin
  with TDbGrid(Sender) do
  begin
    if assigned(DataSource) and assigned(DataSource) then
      if (gdSelected in AState) then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end
      else
      if (trim(DataSource.Dataset.FieldByName('order_status').AsString) <> estbk_types.COrderVerified) then // avatud arved teise värviga !
        Canvas.Brush.Color := glob_userSettings.uvc_colors[uvc_gridColorForUnconfirmedItems]
      else
        Canvas.Brush.Color := clWindow;
  end;
end;

function TframeOrderList.getDataLoadStatus: boolean;
begin
  Result := True;
end;

procedure TframeOrderList.setDataLoadStatus(const v: boolean);
begin
  qryOrderList.Close;
  qryOrderList.SQL.Clear;

  if v then
  begin
    qryOrderList.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryOrderList.SQL.add(estbk_sqlclientcollection._SQLSrcOrders());
    qryOrderList.active := v;
    if qryOrderList.RecordCount > 0 then
      ordersGrid.DataSource := qryOrderListDs
    else
      ordersGrid.DataSource := nil;
  end
  else
    qryOrderList.Connection := nil;
end;



constructor TframeOrderList.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
  cmbOrderStatus.items.addObject(estbk_strmsg.SUnDefComboChoise, TObject(COrderAllItems));
  cmbOrderStatus.items.addObject(estbk_strmsg.SCStatusConfirmed, TObject(COrderStatusConfirmed));
  cmbOrderStatus.items.addObject(estbk_strmsg.SCStatusUnConfirmed, TObject(COrderStatusUnConfirmed));

  cmbOrderType.items.addObject(estbk_strmsg.SUnDefComboChoise, TObject(COrderAllItems));
  cmbOrderType.items.addObject(estbk_strmsg.SCaptPurchaseOrder, TObject(COrderTypeAsPurchOrder));
  cmbOrderType.items.addObject(estbk_strmsg.SCaptSaleOrder, TObject(COrderTypeAsSaleOrder));

  dtEdtAccDateStart.date := now;
  dtEdtAccDateStart.Text := '';
  dtEdtAccDateEnd.date := now;
  dtEdtAccDateEnd.Text := '';


  cmbOrderStatus.ItemIndex := 0;
  cmbOrderType.ItemIndex := 0;
end;

destructor TframeOrderList.Destroy;
begin
  inherited Destroy;
end;


initialization
  {$I estbk_fra_order_list.ctrs}



end.
