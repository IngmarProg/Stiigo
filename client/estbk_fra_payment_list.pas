unit estbk_fra_payment_list;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, Buttons, Dialogs,Graphics,
  EditBtn, ExtCtrls, DBGrids, Controls,LCLType,LCLProc,
  estbk_clientdatamodule,estbk_settings,estbk_fra_template,
  estbk_strmsg,estbk_fra_customer,estbk_frm_choosecustmer,estbk_types,estbk_uivisualinit,
  estbk_lib_commonevents,estbk_lib_commonaccprop,estbk_sqlclientcollection,estbk_utilities,
  estbk_lib_deleteaccitems, estbk_frm_sepapayments, estbk_lib_commoncls,estbk_globvars,
  db, ZDataset, Grids, ComCtrls, estbk_lib_asyncload;

type

  { TframePaymentList }

  TframePaymentList = class(Tfra_template)
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    btnSepaPayments: TBitBtn;
    btnNewPayment: TBitBtn;
    cmbTransType: TComboBox;
    edtSelSumtotal: TEdit;
    edtSelItemCurr: TEdit;
    lblBankBalanceSum: TLabel;
    lblBankBalance: TLabel;
    lblTransType: TLabel;
    paymentOrders: TDBGrid;
    btnClean: TBitBtn;
    btnClose: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnSrc: TBitBtn;
    chkbxCreditBill: TCheckBox;
    chkbxOnlyOverdueBills: TCheckBox;
    chkbxPurchBill: TCheckBox;
    chkbxSaleBill: TCheckBox;
    pgBarSepaFiles: TProgressBar;
    qryGetSelectedItems: TZQuery;
    qryPaymentOrderSrcDS: TDatasource;
    dtEdtPmtOrderDate: TDateEdit;
    edtDoccnr: TEdit;
    edtBillNr: TEdit;
    edtRecvAccNr: TEdit;
    edtOrderNr: TEdit;
    edtDescr: TEdit;
    edtCustCode: TEdit;
    edtCustNameAndAddr: TEdit;
    edtEdtBillDate: TDateEdit;
    grpBoxPaymenyOrders: TGroupBox;
    lblOrderNr: TLabel;
    lblDescr: TLabel;
    lblPmtDate: TLabel;
    lblAccNr: TLabel;
    lblBillDate: TLabel;
    lblBillNr: TLabel;
    lblPaymentRcvAA: TLabel;
    lblBillTypes: TLabel;
    lblCustId: TLabel;
    parentPanel: TPanel;
    qryPaymentOrderSrc: TZQuery;
    procedure btnCleanClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewPaymentClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnSepaPaymentsClick(Sender: TObject);
    procedure btnSrcClick(Sender: TObject);
    procedure dtEdtPmtOrderDateExit(Sender: TObject);
    procedure edtCustCodeChange(Sender: TObject);
    procedure edtCustCodeExit(Sender: TObject);
    procedure edtCustCodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCustCodeKeyPress(Sender: TObject; var Key: char);
    procedure edtCustNameAndAddrChange(Sender: TObject);
    procedure edtCustNameAndAddrKeyPress(Sender: TObject; var Key: char);
    procedure edtCustNameAndAddrUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure paymentOrdersCellClick(Column: TColumn);
    procedure paymentOrdersDblClick(Sender: TObject);
    procedure paymentOrdersDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure paymentOrdersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure paymentOrdersKeyPress(Sender: TObject; var Key: char);

  protected
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif : TKeyNotEvent;
    FFrameDataEvent : TFrameReqEvent;
    FLastClientCode : AStr;
    FLastClientId   : Integer;
    // --
    FSmartEditSkipCtrlChars : Boolean; // kui vajutada keydown ja seal key=0; jookseb event siiski edasi ?!? utf8keypressi
    FSmartEditSkipChar      : Boolean;
    FSmartEditLastSuccIndx  : Integer;
    FCashRegisterMode : Boolean; // siis kuvatakse kassamakseid / teisel juhul ... vaikimisi variant; pangatasumisi
    {$IFDEF FINLAND}
    FSepaUploadInfo : TStringList;
    FAsyncBalance : TAsyncLoadGetBalance;
    FAsyncUpload  : TAsyncSendSepaFile;
    procedure   getLiveBankBalance;
    procedure   getSepaUploadStatus;
    procedure   generateSepaFiles(const pbankswift : AStr; const pcompanyid : Integer; const pselids : TADynIntArray);
    {$ENDIF}
    // --
    procedure   calculateSelectedRowSum();
    procedure   setCashRegisterMode(const v : Boolean);
    function    getDataLoadStatus: boolean;
    procedure   setDataLoadStatus(const v: boolean);

    procedure   assignClientData(const pClient : TClientData);
    procedure   updateBankBalance;
    procedure   reloadLastNPmtOrderEntrys;
    procedure   chooseCustomer(const pShowSrcForm : Boolean = true);
  public
    property    cashRegisterMode : Boolean read FCashRegisterMode write setCashRegisterMode;
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  published // RTTI probleem
    property    onFrameKillSignal     : TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property    onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    property    onFrameDataEvent      : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property    loadData : boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation
uses Math, LCLIntf, estbk_http;

const
  CCmb_indexIncpOrder = 1;
  CCmb_indexOutpOrder = 2;


const
  CCol_cbRow     = 0;
  CCol_accrecNr  = 1;
  CCol_cashrtype = 2;
  CCol_docnr1    = 3;
  CCol_docnr2    = 5;
  CCol_sumtotal  = 7;

{ TframePaymentList }

procedure TframePaymentList.setCashRegisterMode(const v : Boolean);
begin
    // panga tasumised; not v !
    lblAccNr.Visible:=not v ;
    edtDoccnr.Visible:=not v ;
    lblPaymentRcvAA.Visible:=not v;
    edtRecvAccNr.Visible:=not v;
    paymentOrders.Columns.Items[CCol_cashrtype].Visible:=v;
    // kassal ja tasumisel erinevad väljad ! võimalik, et tuleb ka kande nr hakata hoopis kuvama !
    paymentOrders.Columns.Items[CCol_docnr1].Visible:=v;
    paymentOrders.Columns.Items[CCol_docnr2].Visible:=not v;
    paymentOrders.Columns.Items[CCol_cbRow].Visible:=not v;
    btnSepaPayments.Visible := not v;

    lblTransType.Visible:=v;
    cmbTransType.Visible:=v;


 if v then
   begin
    btnNewPayment.Caption:=estbk_strmsg.SCBtnCaptNewCsPayment;
    grpBoxPaymenyOrders.Caption:=estbk_strmsg.SCaptAsCashRegPayment;
    cmbTransType.ItemIndex:=0;
   end else
   begin
    grpBoxPaymenyOrders.Caption:=estbk_strmsg.SCaptAsPayment;
    btnNewPayment.Caption:=estbk_strmsg.SCBtnCaptNewPayment;
   end;
    self.FCashRegisterMode:=v;


end;


function TframePaymentList.getDataLoadStatus: boolean;
begin
  Result := true;
end;


procedure TframePaymentList.setDataLoadStatus(const v: boolean);
begin
     qryPaymentOrderSrc.Close;
     qryPaymentOrderSrc.SQL.Clear;

  if v then
    begin
     qryPaymentOrderSrc.Connection := estbk_clientdatamodule.dmodule.primConnection;
     qryGetSelectedItems.Connection := estbk_clientdatamodule.dmodule.primConnection;


     {$IFDEF FINLAND}
     FAsyncBalance.Resume;
     {$ENDIF}


     self.reloadLastNPmtOrderEntrys;
     //qryPaymentOrderSrc.active:=v;
    end else
    begin
     qryPaymentOrderSrc.Connection := nil;
     qryGetSelectedItems.Connection := nil;
    end;
end;

procedure TframePaymentList.updateBankBalance;
begin
{$IFDEF FINLAND}
 lblBankBalance.ShowHint := true;
 lblBankBalance.Hint := '';
 lblBankBalance.Caption := estbk_strmsg.CSPmtCurrentBankBalance;
 lblBankBalanceSum.Caption := format(CCurrentMoneyFmt2, [0.00]);
 lblBankBalanceSum.Font.Style:= [fsBold];
{$ELSE}
 lblBankBalance.Caption := '';
 lblBankBalanceSum.Caption := '';
{$ENDIF}
end;

procedure TframePaymentList.reloadLastNPmtOrderEntrys;
begin

   // ---
   qryPaymentOrderSrc.Close;
   qryPaymentOrderSrc.SQL.Clear;


   qryPaymentOrderSrc.SQL.add(estbk_sqlclientcollection._SQLSearchPayments(estbk_globvars.glob_company_id,
                                                                           0,
                                                                           Nan,
                                                                           '',
                                                                           '',
                                                                           '',
                                                                           '',
                                                                           '',
                                                                           '',
                                                                           self.FCashRegisterMode,
                                                                           cmbTransType.ItemIndex));
   qryPaymentOrderSrc.Open;
if qryPaymentOrderSrc.RecordCount>0 then
  begin
   paymentOrders.DataSource:=qryPaymentOrderSrcDS;
   btnSepaPayments.Enabled := not Self.FCashRegisterMode;
  end else
  begin
   btnSepaPayments.Enabled := false;
   paymentOrders.DataSource:=nil;
  end;
end;

procedure TframePaymentList.btnSrcClick(Sender: TObject);
var
   pSql    : AStr;
   //pCustId : Integer;
   pPmtOrderDate : TDatetime;
begin
   // edtCustCode
   // dtEdtPmtOrderDate
   // edtDoccnr
   // edtBillNr
   // edtRecvAccNr
   // edtDescr
   qryPaymentOrderSrc.Close;
   qryPaymentOrderSrc.SQL.Clear;


   //pCustId:=strtointdef(edtCustCode.text,0);

if dtEdtPmtOrderDate.text<>'' then
   pPmtOrderDate:=dtEdtPmtOrderDate.date
else
   pPmtOrderDate:=NaN;
   pSql:=estbk_sqlclientcollection._SQLSearchPayments(estbk_globvars.glob_company_id,
                                                      self.FLastClientId,
                                                      pPmtOrderDate,
                                                      edtDoccnr.Text,
                                                      edtBillNr.Text,
                                                      edtOrderNr.Text,
                                                      edtRecvAccNr.Text,
                                                      edtDescr.Text,
                                                      edtCustNameAndAddr.Text,
                                                      self.FCashRegisterMode,
                                                      cmbTransType.ItemIndex // 0 = sissetulek; 1 = väljaminek !
                                                      );
   qryPaymentOrderSrc.SQL.add(pSql);
   qryPaymentOrderSrc.Open;
if qryPaymentOrderSrc.RecordCount>0 then
  begin
   paymentOrders.DataSource:=qryPaymentOrderSrcDS;
   btnSepaPayments.Enabled := not self.FCashRegisterMode;
  end else
  begin
   btnSepaPayments.Enabled := false;
   paymentOrders.DataSource:=nil;
  end;
end;

procedure TframePaymentList.dtEdtPmtOrderDateExit(Sender: TObject);
var
  fVdate   : TDatetime;
  fDateStr : AStr;
begin
   fVdate:=Now;
   fDateStr:=TDateEdit(Sender).Text;

if (trim(fDateStr)<>'') then
 if not validateMiscDateEntry(fDateStr,fVDate) then
  begin
      dialogs.messageDlg(estbk_strmsg.SEInvalidDate,mterror,[mbOk],0);
      TDateEdit(Sender).setFocus;
      exit;
  end else
      TDateEdit(Sender).text:=datetostr(fVDate);
end;

procedure TframePaymentList.edtCustCodeChange(Sender: TObject);
begin
{
   with TEdit(Sender) do
   if Focused and (Text='') then
     begin
      self.edtCustNameAndAddr.Text:='';
      self.edtCustNameAndAddr.Hint:='';
     end;
}
end;


procedure TframePaymentList.assignClientData(const pClient : TClientData);
var
   pData   : AStr;
begin
 if not assigned(pClient) then
   begin
       self.FLastClientCode:='';
       self.FLastClientId:=0;
       edtCustCode.Text:='';
       edtCustNameAndAddr.Text:='';
   end else
   begin
        pData:=pClient.FCustFullName;
     if pClient.FCustRegNr<>'' then
        pData:=pData+' ('+')';

        edtCustNameAndAddr.Text:=pData;
        // 11.02.2011 Ingmar
        edtCustCode.text:=pClient.FClientCode;

        self.FLastClientCode:=pClient.FClientCode;
        self.FLastClientId:=pClient.FClientId;
   end;
end;

procedure TframePaymentList.edtCustCodeExit(Sender: TObject);
var
   pClient : TClientData;
begin
       pClient:=nil;
  with TEdit(Sender) do
  if text<>'' then
   try
    if self.FLastClientcode<>text then
      begin
        pClient:=estbk_fra_customer.getClientDataWUI(text);
        self.assignClientData(pClient);
      end;

   finally
     freeAndNil(pClient);
   end else
    self.assignClientData(pClient);
end;

procedure TframePaymentList.chooseCustomer(const pShowSrcForm : Boolean = true);
var
 pClient : TClientData;

begin
 try
        pClient:=nil;
   // --------
   case pShowSrcForm of
    true : pClient:=estbk_frm_choosecustmer.__chooseClient(edtCustCode.text);
    false: pClient:=estbk_fra_customer.getClientDataWUI(edtCustCode.text);
   end;


   //pCust:=estbk_formchoosecustmer.__chooseCustomer(strtointdef(edtCustCode.text,99999999));
   if  assigned(pClient) then
        self.assignClientData(pClient);

     if dtEdtPmtOrderDate.CanFocus then
        dtEdtPmtOrderDate.setFocus;


 finally
     freeAndNil(pClient);
 end;
end;

procedure TframePaymentList.edtCustCodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 if  (Shift=[ssCtrl]) then
 case key of
  VK_RETURN: begin
                key:=0;
                self.FSmartEditSkipCtrlChars:=true;
                TEdit(Sender).SelStart:=length(TEdit(Sender).Text);
                TEdit(Sender).SelLength:=0;

                self.btnOpenClientListClick(btnOpenClientList);
                //       memo1.lines.add('edtCustRegnrKeyDown '+inttostr(integer(Key)));
             end;

  ord('+') : if length(TEdit(Sender).Text)>0 then
             begin
                key:=0;
                self.FSmartEditSkipCtrlChars:=true;
                TEdit(Sender).SelStart:=length(TEdit(Sender).Text);
                TEdit(Sender).SelLength:=0;

                self.chooseCustomer(false);
             end;

   VK_DELETE:if (Sender=edtCustNameAndAddr) and (edtCustNameAndAddr.text='') then
             begin
                edtCustNameAndAddr.Hint:='';
                edtCustCode.Text:='';
             end else
             if  (Sender=edtCustCode) and (edtCustCode.text='') then
             begin
                edtCustNameAndAddr.Hint:='';
                edtCustNameAndAddr.Text:='';
             end;
 end;
  // ---
end;

procedure TframePaymentList.edtCustCodeKeyPress(Sender: TObject; var Key: char);
begin
 if key=#13 then
  begin
     SelectNext(Sender as twincontrol, True, True);
     key:=#0;
  end; // else
 // 10.02.2011 Ingmar; enam ei nõua ilmatingimata nr sisestust, nüüd võib see olla ka regkood
 //if Sender=edtCustCode then
 //   estbk_utilities.edit_verifyNumericEntry(sender as TCustomEdit,key,false);
end;

procedure TframePaymentList.edtCustNameAndAddrChange(Sender: TObject);
begin
  if TEdit(Sender).Text='' then
    begin
     self.FSmartEditSkipChar:=false;
     TEdit(Sender).Hint:='';
    end;
end;

procedure TframePaymentList.edtCustNameAndAddrKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
    begin
      SelectNext(Sender as twincontrol, True, True);
      key:=#0;
    end else
  //memo1.lines.add('ansikeypress '+inttostr(ord(key)));
  if  self.FSmartEditSkipChar or (key=#10) then
   begin
     self.FSmartEditSkipChar:=false;
     key:=#0;
   end;
 // --

end;



procedure TframePaymentList.edtCustNameAndAddrUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
{
var
  pSrcInst   : TAStrList;
}
begin
{
  pSrcInst:=estbk_clientdatamodule.dmodule.custFastSrcList;
  estbk_utilities.edit_autoCustDataStrListAutoCompUTF8(Sender,
                                                       pSrcInst, // otsing perekonna ja nimetuse järgi
                                                       self.FSmartEditSkipCtrlChars,
                                                       UTF8Key,
                                                       self.FSmartEditSkipChar,
                                                       self.FSmartEditLastSuccIndx,
                                                       edtCustCode);
}
end;

procedure   TframePaymentList.calculateSelectedRowSum();
var
  bk : TBookmark;
  rowsum : Double;
begin
    edtSelSumtotal.Text := '';
    edtSelItemCurr.Caption := '';
 if Assigned(paymentOrders.DataSource) then
  with paymentOrders.DataSource.DataSet do
  try
     bk := GetBookMark;
     DisableControls;
     First;

     If RecordCount < 1 then
        Exit;

     while not Eof do
      begin

      if FieldByname('int4').AsInteger > 0 then
         rowsum :=  rowsum + FieldByname('sumtotal').AsFloat;
         Next;
      end;

     edtSelItemCurr.Caption := estbk_globvars.glob_baseCurrency;
     edtSelSumtotal.Text := Format(CCurrentMoneyFmt2, [rowsum]);
  finally
     GotoBookmark(bk);
     FreeBookmark(bk);
     EnableControls;
  end;
end;

procedure TframePaymentList.paymentOrdersCellClick(Column: TColumn);
begin
  with paymentOrders do
  if assigned(column) and (column.Index = CCol_cbRow) and assigned(DataSource) and DataSource.DataSet.Active then
    begin
        if DataSource.Dataset.fieldByname('currency').asString <> estbk_globvars.glob_baseCurrency then
           dialogs.messageDlg(estbk_strmsg.SEPmtOnlyBaseCurrencyAllowed, mtError, [mbOk],0)
        else
        // pole kinnitatud !
        if (pos(estbk_types.CPaymentRecStatusClosed, DataSource.Dataset.fieldByname('status').asString) = 0) then
            dialogs.messageDlg(estbk_strmsg.SEPmtOnlyVerifRecAreAllowed, mtError, [mbOk],0)
        else
        if (DataSource.Dataset.fieldByname('sumtotal').AsCurrency < 0.00) then
            dialogs.messageDlg(estbk_strmsg.SEPmtNegSumSelected, mtError, [mbOk],0)
        else
        try
             DataSource.Dataset.Edit;
          if DataSource.Dataset.FieldByname('int4').asInteger < 1 then
             DataSource.Dataset.FieldByname('int4').asInteger := 1
          else
             DataSource.Dataset.FieldByname('int4').asInteger := 0;
        finally
             DataSource.Dataset.Post;
             calculateSelectedRowSum();
        end;
    end;
end;

procedure TframePaymentList.paymentOrdersDblClick(Sender: TObject);
begin
   // 15.10.2015 Ingmar; kui on cb lahter, siis pole mõtet avada makset, sest võib olla lihtsalt valiti CB !
   if not self.FCashRegisterMode and (paymentOrders.SelectedIndex = CCol_cbRow) then
      Exit;

   if assigned(self.FFrameDataEvent) and not qryPaymentOrderSrc.isEmpty then
    begin

    if self.FCashRegisterMode then // järelikult soovitakse näha kassa makseid
       self.FFrameDataEvent(Self,__frameOpenCashRegrEntry,qryPaymentOrderSrc.fieldbyname('pmtordid').asInteger)
    else
       self.FFrameDataEvent(Self,__frameOpenPaymentEntry,qryPaymentOrderSrc.fieldbyname('pmtordid').asInteger);

    end;
end;

procedure TframePaymentList.paymentOrdersDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  pts       : TTextStyle;
  pFieldVal : AStr;
begin
 with TDbGrid(Sender) do
  begin

      // kuvame avatud kirjeid kollasena...
       if assigned(DataSource) and assigned(DataSource) then
         if (gdSelected in State) then
            begin
               Canvas.Brush.Color:=clHighlight;
               Canvas.Font.Color:=clHighlightText;

            end else
            if (pos(estbk_types.CPaymentRecStatusClosed, DataSource.Dataset.fieldByname('status').asString)=0) then // avatud arved teise värviga !
                Canvas.Brush.Color := glob_userSettings.uvc_colors[uvc_gridColorForUnconfirmedItems]
            else
                Canvas.Brush.Color := clWindow;
                Canvas.FillRect(Rect);

                pts:=Canvas.TextStyle;
                pts.Alignment := taLeftJustify;
                Canvas.TextStyle:=pts;


            // 24.10.2015 Ingmar
            if not self.FCashRegisterMode and (dataCol = CCol_cbRow) then
             begin
             if DataSource.Dataset.FieldByname('int4').asInteger > 0 then
                DrawFrameControl(TDbGrid(Sender).Canvas.Handle, Rect, DFC_BUTTON, DFCS_CHECKED)
             else
                DrawFrameControl(TDbGrid(Sender).Canvas.Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK);
             end else

            // 22.07.2011 Ingmar
            if (dataCol=CCol_cashrtype) and self.FCashRegisterMode then
               begin

               if assigned(Column.Field) then
                 if Column.Field.AsInteger = _ac.sysDocumentId[_dsReceiptVoucherDocId] then
                    pFieldVal:=estbk_strmsg.SCashrIncOrder2
                 else
                 if Column.Field.AsInteger = _ac.sysDocumentId[_dsPaymentVoucherDocId] then
                    pFieldVal:=estbk_strmsg.SCashrOutpOrder2
                 else
                   pFieldVal:='';
                   Canvas.TextOut(Rect.Left + 5, Rect.Top + 2,pFieldVal);

               end else
            if (dataCol=CCol_sumtotal) then
                begin

                  pts.Alignment := taRightJustify;
                  Canvas.TextStyle:=pts;

                  Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,trim(format(estbk_types.CCurrentMoneyFmt2,[Column.Field.asFloat]))+#32,Canvas.TextStyle);
               end else
               begin
               // ---
               if assigned(Column.Field) then
                  pFieldVal:=Column.Field.asString
               else
                  pFieldVal:='';
                  Canvas.TextOut(Rect.Left + 5, Rect.Top + 2,pFieldVal);
               end;
  end;
end;

// 23.02.2012 Ingmar
procedure TframePaymentList.paymentOrdersKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  pItemToDelete : TCBDeleteItem;
begin
  if qryPaymentOrderSrc.Active and (qryPaymentOrderSrc.RecordCount>0) then
    if key=VK_DELETE then
      begin
      if FCashRegisterMode then
         pItemToDelete:=cbDeleteCashReg
      else
         pItemToDelete:=cbDeletePayment;

      if _deleteAccItems(qryPaymentOrderSrc.FieldByname('pmtordid').asInteger,
                         qryPaymentOrderSrc.FieldByname('document_nr').AsString,
                         pItemToDelete)then
         btnSrc.OnClick(btnSrc);
         key:=0;
      end;
end;


procedure TframePaymentList.paymentOrdersKeyPress(Sender: TObject; var Key: char);
begin
   if key=#13 then
    begin
      paymentOrdersDblClick(Sender);
      key:=#0;
    end;
end;

procedure TframePaymentList.btnCleanClick(Sender: TObject);
begin
    self.FLastClientCode:='';
    self.FLastClientId:=0;

    edtCustNameAndAddr.Hint:='';
    self.FSmartEditLastSuccIndx:=-1;
    self.FSmartEditSkipChar:=false;
    edtSelSumtotal.Text := '';
    edtSelItemCurr.Text := '';
    // ---
    estbk_utilities.clearControlsWithTextValue(grpBoxPaymenyOrders);
    edtCustNameAndAddr.Text:='';

if  edtCustCode.canFocus then
    edtCustCode.setFocus;

    self.reloadLastNPmtOrderEntrys;
    cmbTransType.ItemIndex:=CCmb_indexIncpOrder;
end;

procedure TframePaymentList.btnCloseClick(Sender: TObject);
begin
  if assigned(self.onFrameKillSignal) then
     self.onFrameKillSignal(self);
end;

procedure TframePaymentList.btnNewPaymentClick(Sender: TObject);
begin
 if self.cashRegisterMode then
    self.onFrameDataEvent(self,__frameCreateNewAccPayment,-1,nil)
 else
    self.onFrameDataEvent(self,__frameCreateNewPayment,-1,nil);
end;

procedure TframePaymentList.btnOpenClientListClick(Sender: TObject);
begin
 self.chooseCustomer(true);
end;

{$IFDEF FINLAND}

procedure TframePaymentList.getSepaUploadStatus;
begin
  pgBarSepaFiles.StepIt;
  FSepaUploadInfo.Add(FAsyncUpload.Status + ' : ' + FAsyncUpload.PaymentData);
end;

procedure TframePaymentList.generateSepaFiles(const pbankswift : AStr; const pcompanyid : Integer; const pselids : TADynIntArray);
var
   pxmlf : TextFile;
   pfile, prez, pServiceWrapperURL : AStr;
   pfiles : TStringList;
   i : Integer;
   ponepmt : TADynIntArray;
   pSQL, pPaymentData : AStr;
begin
   pgBarSepaFiles.Min := low(pselids);
   pgBarSepaFiles.Max := high(pselids);

 try
   try
     btnSepaPayments.Enabled:= false;
     btnClose.Enabled:= false;

     pFiles := TStringList.Create;
     for i := low(pselids) to high(pselids) do
       begin
        pfile := GetTempFileName(GetTempDir, 'sepatemp');
        ponepmt := nil;

        SetLength(ponepmt, 1);
        ponepmt[0] := pselids[i];

        prez := TformSepaPayments.generateSepaPayments(pbankswift, estbk_globvars.glob_company_id, ponepmt, dmodule.tempQuery);
        AssignFile(pxmlf, pfile);
        Rewrite(pxmlf);
        Writeln(pxmlf, prez);
        CloseFile(pxmlf);

        // --
        pFiles.Add(pfile);
       end;

     // kiud tööle
     for i := 0 to pFiles.Count - 1 do
       begin
          pServiceWrapperURL := estbk_clientdatamodule.dmodule.globalIni.ReadString('bank','uploadsepa', ''); // TODO add companyid also to URL !
       if pServiceWrapperURL <> '' then
        try
          pSQL := estbk_sqlclientcollection._SQLSearchPayments(pCompanyId,
                                                       0, // custid
                                                       Nan, // pmtorderdate,
                                                       '', // docnr
                                                       '', // billnr
                                                       '', // ordern
                                                       '', // recvaccnr
                                                       '', // descr
                                                       '', // custname
                                                       false, // iscashregister
                                                       0, // 0 - sissetulek; 1 - väljaminek
                                                       1000, // maxrowrs
                                                       ponepmt);
          with dmodule.tempQuery, SQL do
          try
            Close;
            Clear;
            Add(pSQL);
            Open;
            // -- one row !
            pPaymentData := FieldByName('payment_nr').AsString + ' : ' + FieldByName('custname').AsString;

          finally
            Close;
            Clear;
          end;

          FAsyncUpload := TAsyncSendSepaFile.Create(pServiceWrapperURL, pFiles.Strings[i], pPaymentData, @getSepaUploadStatus);
          FAsyncUpload.Resume;

          while FAsyncUpload.Working  do
           begin
           if Application.Terminated then Exit;
              Application.ProcessMessages;
           end;

          Sleep(600);
        finally
          FreeAndNil(FAsyncUpload);
        end;
       end;

   finally

   for i := 0 to pFiles.Count - 1 do
       deleteFile(pFiles.Strings[i]);
       pFiles.Free;


       btnSepaPayments.Enabled := true;
       btnClose.Enabled := true;
   end;

 except on e : exception do
  dialogs.MessageDlg(Format(SEError, [e.Message]), mtError, [MbOk], 0);
 end;
end;

{$ENDIF}

procedure TframePaymentList.btnSepaPaymentsClick(Sender: TObject);
var
  bk : TBookmark;
  selids : TADynIntArray;
  psepafrm : TformSepaPayments;
  pbankswift : AStr;
begin
     selids := nil;
  if Assigned(paymentOrders.DataSource) then
   with paymentOrders.DataSource.DataSet do
   try
      bk := GetBookMark;
      DisableControls;
      First;

      If RecordCount < 1 then
         Exit;

      while not Eof do
       begin

       if (pos(estbk_types.CPaymentRecStatusClosed, FieldByname('status').asString) > 0) and
          (FieldByname('int4').AsInteger > 0) then
        begin
           SetLength(selids, length(selids) + 1);
           selids[length(selids) - 1] := FieldByname('pmtordid').AsInteger;
        end;

          Next;
       end;


        // --
        pbankswift := ''; // TODO
        {$IFDEF FINLAND}
        generateSepaFiles(pbankswift, estbk_globvars.glob_company_id, selids);
        {$ELSE}
        // plain file !
        psepafrm := TformSepaPayments.Create(nil, pbankswift, estbk_globvars.glob_company_id, selids, qryGetSelectedItems);
        try
          psepafrm.Showmodal;
        finally
          FreeAndNil(psepafrm);
        end;
        {$ENDIF}


   finally
      GotoBookmark(bk);
      FreeBookmark(bk);
      EnableControls;
   end;
end;

{$IFDEF FINLAND}
procedure TframePaymentList.getLiveBankBalance;
var
  pStr : TStringStream;
  pBankBal : Double;
begin
     lblBankBalance.Hint := '';
     lblBankBalance.Caption := CSPmtCurrentBankBalance;

  if FAsyncBalance.Error = '' then
     lblBankBalanceSum.Caption := Format(CCurrentMoneyFmt2, [FAsyncBalance.CurrenctBalance])
  else
    begin
     lblBankBalance.Hint := FAsyncBalance.Error;
     lblBankBalanceSum.Caption := 'NaN';
   end;
end;
{$ENDIF}

constructor TframePaymentList.create(frameOwner: TComponent);
{$IFDEF FINLAND}
var
  pServiceWrapperURL : AStr; // request from ini
{$ENDIF}
begin
   inherited create(frameOwner);

   lblBankBalance.Caption := '';
   lblBankBalanceSum.Caption := '';
   estbk_uivisualinit.__preparevisual(self);
   cmbTransType.Items.Add(estbk_strmsg.SUndefComboChoise);
   cmbTransType.Items.add(estbk_strmsg.SCashrIncOrder);
   cmbTransType.Items.add(estbk_strmsg.SCashrOutpOrder);

   cmbTransType.ItemIndex:=CCmb_indexIncpOrder;

{$IFDEF FINLAND}
   FSepaUploadInfo := TStringList.Create;

   pgBarSepaFiles.Visible := true;
   pServiceWrapperURL := estbk_clientdatamodule.dmodule.globalIni.ReadString('bank','balance', ''); // TODO add companyid also to URL !
if pServiceWrapperURL <> '' then
   FAsyncBalance := TAsyncLoadGetBalance.Create(pServiceWrapperURL, @getLiveBankBalance, true, 120);
  {$ENDIF}
end;

destructor  TframePaymentList.destroy;
begin
 {$IFDEF FINLAND}
    FreeAndNil(FSepaUploadInfo);

 if Assigned(FAsyncBalance) then
  begin
    FAsyncBalance.Terminate;
    FreeAndNil(FAsyncBalance);
  end;

 if Assigned(FAsyncUpload) then
  begin
    FAsyncUpload.Terminate;
    FreeAndNil(FAsyncUpload);
  end;

 {$ENDIF}
 inherited destroy;
end;

initialization
  {$I estbk_fra_payment_list.ctrs}

end.

