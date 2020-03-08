unit estbk_fra_bill_list;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, ExtCtrls, DBGrids,
  ComCtrls, DbCtrls, EditBtn, Graphics, Buttons, dialogs, estbk_fra_template,estbk_uivisualinit,
  estbk_strmsg, estbk_clientdatamodule, estbk_types, LCLType,
  estbk_fra_customer, estbk_frm_choosecustmer, estbk_lib_commonevents,
  estbk_sqlclientcollection, estbk_utilities, estbk_lib_commoncls, estbk_reportconst,
  estbk_settings, estbk_globvars, db, rxlookup, LR_Class, LR_DBSet, ZDataset,
  ZConnection, Controls, Grids, lr_e_csv, lr_e_pdf;

type

  { TframeBillList }

  TframeBillList = class(Tfra_template)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    btnClean: TBitBtn;
    btnPrint: TBitBtn;
    btnClose: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnNewBill: TBitBtn;
    btnSrc: TBitBtn;
    chkbxCreditBill: TCheckBox;
    chkbxPrepaymentBill: TCheckBox;
    chkbxSaleBill: TCheckBox;
    chkbxPurchBill: TCheckBox;
    cmbArtType: TComboBox;
    cmbBarCodeTypes: TComboBox;
    cmbCostAcc: TRxDBLookupCombo;
    cmbPurcAcc: TRxDBLookupCombo;
    cmbSaleAcc: TRxDBLookupCombo;
    cmbStaatus: TComboBox;
    cmbUnit: TDBComboBox;
    cmbVatLookup: TDBLookupComboBox;
    report: TfrReport;
    repdata: TfrDBDataSet;
    lblBillTypes: TLabel;
    lblStatus: TLabel;
    qryBillSrcDs: TDatasource;
    dtEdtAccDate: TDateEdit;
    DBEdit4: TDBEdit;
    dbEdtDiscountPerc: TDBEdit;
    dbEdtProdCode: TDBEdit;
    dbEdtProdName: TDBEdit;
    billsGrid: TDBGrid;
    dbObjGrid: TDBGrid;
    edtEdtBillDate: TDateEdit;
    edtCustNameAndAddr: TEdit;
    edtAccRecnr: TEdit;
    edtBillNr: TEdit;
    edtClientCode: TEdit;
    edtPurcPrice: TCalcEdit;
    edtSalePrice: TCalcEdit;
    edtSrc: TEdit;
    grpBoxObjects: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    lbBarCode: TLabel;
    lbCostAcc: TLabel;
    lblBillDate: TLabel;
    lblAccNr: TLabel;
    lblArtType: TLabel;
    lblBillNr: TLabel;
    lblCustId: TLabel;
    lblAccDate: TLabel;
    lblDescr: TLabel;
    lblDiscountPerc: TLabel;
    lbllpurchaseprice: TLabel;
    lblname: TLabel;
    lblProdcode: TLabel;
    lblPurcAcc: TLabel;
    lblSaleAcc: TLabel;
    lblSalePrice: TLabel;
    lblUnit: TLabel;
    lblVat: TLabel;
    memProdDesc: TDBMemo;
    pageArtMainData: TTabSheet;
    pageCtrlArt: TPageControl;
    pageExtInfo: TTabSheet;
    parentPanel: TPanel;
    panelLeft: TPanel;
    panelLeftInnerSrc: TPanel;
    panelRight: TPanel;
    qryBillSrc: TZQuery;
    procedure billsGridDblClick(Sender: TObject);
    procedure billsGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure billsGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure billsGridKeyPress(Sender: TObject; var Key: char);
    procedure billsGridPrepareCanvas(sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure btnCleanClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewBillClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSrcClick(Sender: TObject);
    procedure chkbxOnlyOverdueBillsClick(Sender: TObject);
    procedure cmbDaysOverKeyPress(Sender: TObject; var Key: char);
    procedure dtEdtAccDateExit(Sender: TObject);
    procedure edtClientCodeExit(Sender: TObject);
    procedure edtClientCodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtClientCodeKeyPress(Sender: TObject; var Key: char);
    procedure reportGetValue(const ParName: String; var ParValue: Variant);
    procedure qryBillSrcCalcFields(DataSet: TDataSet);
  protected
    FLastClientcode : AStr;
    FLastClientId   : Integer;
    FRepDefFile     : AStr;
    // ---
    //FClientCode     : AStr;
    FframeKillSignal:  TNotifyEvent;
    FParentKeyNotif :  TKeyNotEvent;
    FFrameDataEvent :  TFrameReqEvent;
    FPreChoosenItems:  TBillTypeSet; // et millised checkboxid on vaikimisi täidetud
    function     getDataLoadStatus: boolean;
    procedure    setDataLoadStatus(const v: boolean);
    procedure    setPreChoosenItems(const v : TBillTypeSet);
    procedure    assignClientData(const pClient : TClientData);
    function     billTypesAsStrIdef:AStr;
  public

    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  // RTTI probleem
  published
    property    reportDefPath : AStr read FRepDefFile write FRepDefFile;
    property    onFrameKillSignal     : TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property    onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    property    onFrameDataEvent      : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property    preSelectedBillTypes  : TBillTypeSet read FPreChoosenItems write setPreChoosenItems;
    property    loadData : boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation
uses Math,estbk_lib_deleteaccitems;

const
 CCol_AccRecNr   = 0;
 CCol_AccRecDate = 1;
 CCol_BillType   = 2;
 CCol_BillNr     = 3;
 CCol_BillDate   = 4;
 CCol_Client     = 5;
 CCol_DueDate    = 6;
 CCol_Billsum    = 7;
 CCol_Paid       = 8;
 CCol_toPay      = 9;


const
 CCmbIndex_billverified   = 1;
 CCmbIndex_billunverified = 2;


function TframeBillList.getDataLoadStatus: boolean;
begin
  Result := true;
end;

procedure TframeBillList.setDataLoadStatus(const v: boolean);
var
   pSQL : AStr;
begin
     qryBillSrc.Close;
     qryBillSrc.SQL.Clear;

  if v then
    begin
         qryBillSrc.Connection:=estbk_clientdatamodule.dmodule.primConnection;
         pSQL:=estbk_sqlclientcollection._SQLSearchBills(estbk_globvars.glob_company_id,
                                                         -1,
                                                         -1,
                                                         Nan,
                                                         '',
                                                         Nan,
                                                         '',
                                                         self.billTypesAsStrIdef);

         qryBillSrc.SQL.add(pSQL);
         qryBillSrc.active:=v;

      if qryBillSrc.RecordCount>0 then
         billsGrid.DataSource:=qryBillSrcDs
      else
         billsGrid.DataSource:=nil;
    end
  else
     qryBillSrc.Connection:=nil;
end;



procedure  TframeBillList.setPreChoosenItems(const v : TBillTypeSet);
begin
  self.FPreChoosenItems:=v;
  chkbxSaleBill.Checked:=(CB_salesInvoice in v);
  chkbxPurchBill.Checked:=(CB_purcInvoice in v);
  chkbxCreditBill.Checked:=(CB_creditInvoice in v);
  chkbxPrepaymentBill.Checked:=(CB_prepaymentInvoice in v);;
end;

procedure TframeBillList.edtClientCodeKeyPress(Sender: TObject; var Key: char);
begin
 if key=#13 then
  begin
     SelectNext(Sender as twincontrol, True, True);
     key:=#0;
  end;
 // 10.02.2011 Ingmar; nüüd ei nõua enam, et peaks nr olema
 //else
 //if (Sender=edtClientCode) or (Sender=edtAccRecnr) then
 // begin
 //   estbk_utilities.edit_verifyNumericEntry(sender as TCustomEdit,key,false);
 // end;
end;

procedure TframeBillList.reportGetValue(const ParName: String;
  var ParValue: Variant);
begin
   // --
end;

procedure TframeBillList.qryBillSrcCalcFields(DataSet: TDataSet);
begin
 // --
end;

procedure TframeBillList.dtEdtAccDateExit(Sender: TObject);
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

procedure TframeBillList.edtClientCodeExit(Sender: TObject);
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

procedure TframeBillList.edtClientCodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
 pClient : TClientData;
begin
 if  (Shift=[ssCtrl]) then
 case key of
  VK_RETURN: begin
              self.btnOpenClientListClick(btnOpenClientList);
              key:=0;
             end;

  ord('+') : if length(TEdit(Sender).Text)>0 then
             begin
              pClient:=estbk_fra_customer.getClientDataWUI(edtClientCode.text);
              //pCust:=estbk_formchoosecustmer.__chooseCustomer(strtointdef(edtClientCode.text,99999999));
              self.assignClientData(pClient);
             end;
 end;

{
    //}
end;

function  TframeBillList.billTypesAsStrIdef:AStr;
var
   pbillTypeMask  : AStr;
   pSeparator     : AStr;
begin
      result:='';
  if  chkbxSaleBill.checked then
    begin
      pbillTypeMask:=pbillTypeMask+pSeparator+QuotedStr(estbk_types._CItemSaleBill);
      pSeparator:=',';
    end;

  if  chkbxPurchBill.checked then
    begin
      pbillTypeMask:=pbillTypeMask+pSeparator+QuotedStr(estbk_types._CItemPurchBill);
      pSeparator:=',';
    end;

  if  chkbxCreditBill.checked then
    begin
      pbillTypeMask:=pbillTypeMask+pSeparator+QuotedStr(estbk_types._CItemCreditBill);
      pSeparator:=',';
    end;


  // 28.10.2010 Ingmar
  if chkbxPrepaymentBill.checked then
    begin
     pbillTypeMask:=pbillTypeMask+pSeparator+QuotedStr(estbk_types._CItemPrepaymentBill);
     pSeparator:=',';
    end;

     // --
     result:=pbillTypeMask;
end;

procedure TframeBillList.btnSrcClick(Sender: TObject);
var
  pParamsOk : Boolean;
  pSQL      : AStr;
  pBillId   : Integer;
  //pCustId   : Integer;
  pAccDate  : TDatetime;
  pBillDate : TDatetime;
  pPurchBillDate : TDatetime;
begin
// 01.02.2010 Ingmar; muutsin loogikat; tühi otsing annab viimased 200 arvet !!!!
{

      pParamsOk:=(trim(edtClientCode.text)<>'') or
                 (trim(dtEdtAccDate.text)<>'') or
                 (trim(edtAccRecnr.text)<>'') or
                 (trim(edtEdtBillDate.text)<>'') or
                 (trim(edtBillNr.text)<>'') or
                 (trim(edtBillNr.text)<>'') or
                 (trim(dtEdtSuppllBillDate.text)<>'') or
                 (trim(edtPurchBillNr.text)<>'');

 if not pParamsOk then
  begin
    dialogs.messageDlg(estbk_strmsg.SEMissingSrcCriterias,mtError,[mbOk],0);
    Exit;
  end;
}

  with qryBillSrc,SQL do
   begin
         close;
         clear;
         pBillId:=0;
         //pCustId:=strtointdef(edtClientCode.text,-1);

         pAccDate:=NaN;
         pBillDate:=NaN;
         pPurchBillDate:=NaN;


     if  dtEdtAccDate.Text<>'' then
         pAccDate:=dtEdtAccDate.Date;

     if  edtEdtBillDate.Text<>'' then
         pBillDate:=edtEdtBillDate.Date;


         // ---
         pSQL:=estbk_sqlclientcollection._SQLSearchBills(estbk_globvars.glob_company_id,
                                                         pBillId,
                                                         self.FLastClientId,
                                                         pAccDate,
                                                         edtAccRecnr.Text,
                                                         pBillDate,
                                                         edtBillNr.Text,
                                                         self.billTypesAsStrIdef,
                                                         cmbStaatus.ItemIndex
                                                         );

         add(pSQL);
         open;


      // --
      if eof then
        begin
         billsGrid.DataSource:=nil;
         dialogs.messageDlg(estbk_strmsg.SEQryRetNoData,mtError,[mbOk],0);
         exit;
        end else
         billsGrid.DataSource:=qryBillSrcDs;
   // ---------
   end;

end;

procedure TframeBillList.chkbxOnlyOverdueBillsClick(Sender: TObject);
begin
    chkbxCreditBill.Enabled:=not TCheckBox(Sender).Checked;
    chkbxPrepaymentBill.Enabled:=not TCheckBox(Sender).Checked;
    // ---
 if TCheckBox(Sender).Checked then
   begin
    chkbxCreditBill.Checked:=false;
    chkbxPrepaymentBill.Checked:=false;
   end;
end;

procedure TframeBillList.cmbDaysOverKeyPress(Sender: TObject; var Key: char);
begin
 if key=#13 then
  begin
     SelectNext(Sender as twincontrol, True, True);
     key:=#0;
  end else
 if key in ['+','-'] then
    key:=#0
 else
    estbk_utilities.edit_verifyNumericEntry_combo(Sender As TCombobox, key, false);
end;

procedure TframeBillList.billsGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
 i         : TBillType;
 pFieldVal : AStr;
 pts       : TTextStyle;
begin
 // üldiselt selline asi, et mingit str liitmist me ei tee üheski päringus !!!! uskuge mind, see tee on palju ohutum !!
 with TDbGrid(Sender) do
  begin


      Canvas.FillRect(Rect);
      pts:=Canvas.TextStyle;
      pts.Alignment := taLeftJustify;
      Canvas.TextStyle:=pts;

      //Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, 'test');
    if assigned(Column.Field) then
      begin

         pFieldVal:=Column.Field.AsString;
      if DataCol=CCol_Client then
      with DataSource.DataSet do
        begin
             pFieldVal:=FieldByname('cust_name').asString+#32+
                        FieldByname('cust_lastname').asString+#32;

         if (trim(FieldByname('cust_email').asString)<>'') then
             pFieldVal:=pFieldVal+'('+FieldByname('cust_email').asString+')';
             pFieldVal:=trim(pFieldVal);
        end else
      if DataCol=CCol_BillType then
        begin
             pFieldVal:='';
         for i:=low(TBillType) to high(TBillType) do
         if  estbk_types.CBillTypeAsIdent[i]=trim(Column.Field.AsString) then
           begin
             pFieldVal:=estbk_types.CLongBillName2[i];
             break;
           end;
        end;

      // ---
      if (DataCol in [CCol_Billsum,CCol_Paid,CCol_toPay]) then
        begin
          pts:=Canvas.TextStyle;
          pts.Alignment := taRightJustify;
          Canvas.TextStyle:=pts;

          Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,trim(format(estbk_types.CCurrentMoneyFmt2,[Column.Field.asFloat]))+#32,Canvas.TextStyle);
       end else
          Canvas.TextOut(Rect.Left + 5, Rect.Top + 2,pFieldVal)
      end else
          Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, '');
  end;
end;

// 02.08.2011 Ingmar; bugfix, kui arvesumma oli neg. siis märgiti laekunuks, Ctrl + F12 võtab selle jama maha !
procedure TframeBillList.billsGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if qryBillSrc.Active and (qryBillSrc.RecordCount>0) then
   begin

         if (key=VK_F12) and (Shift=[ssCtrl]) then
         with dmodule.tempQuery,SQL do
           try
               close;
               clear;
               // --
               add(estbk_sqlclientcollection._SQLFixTriggerPaymentStatusBug);
               paramByname('id').AsInteger:=qryBillSrc.FieldByName('id').AsInteger;
               execSQL;
           if  rowsAffected>0 then
               dialogs.messageDlg(estbk_strmsg.SEMessageFixed,mtInformation,[mbOk],0);

           finally
              close;
              clear;
              key:=0;
           end else
         // 23.02.2012 Ingmar;
         if  (key=VK_DELETE) then
           begin
            if _deleteAccItems(qryBillSrc.FieldByName('id').AsInteger,
                               qryBillSrc.FieldByName('bill_number').AsString,
                               cbDeleteBill) then
               btnSrc.OnClick(btnSrc);
          end;
   end;
end;

procedure TframeBillList.billsGridKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   begin
     billsGridDblClick(Sender);
     key:=#0;
   end;
end;

procedure TframeBillList.billsGridPrepareCanvas(sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  with TDbGrid(Sender) do
  if assigned(DataSource) then
   begin

     if(gdSelected in AState) then
      begin
         Canvas.Brush.Color:=clHighlight;
         Canvas.Font.Color:=clHighlightText;
      end else
     if (DataSource.Dataset.fieldByname('status').asString=estbk_types.CBillStatusOpen) then // avatud arved teise värviga !
         Canvas.Brush.Color := glob_userSettings.uvc_colors[uvc_gridColorForUnconfirmedItems]
     else
         Canvas.Brush.Color := clWindow;
   end; // ---
end;

procedure TframeBillList.billsGridDblClick(Sender: TObject);
begin
// if billsGrid.SelectedRows.Count>0 then
  if assigned(self.FFrameDataEvent) and not qryBillSrc.isEmpty then
     self.FFrameDataEvent(Self,__frameOpenBillEntry,qryBillSrc.fieldbyname('id').asInteger);
end;

procedure TframeBillList.btnCleanClick(Sender: TObject);
var
   pSQL : AStr;
begin
   estbk_utilities.clearControlsWithTextValue(grpBoxObjects);
   edtCustNameAndAddr.Text:='';

   self.FLastClientId:=0;
   self.FLastClientcode:='';

if edtClientCode.canFocus then
   edtClientCode.setFocus;

   // laeme uuesti viimased 200 arvet...
   qryBillSrc.Close;
   qryBillSrc.SQL.Clear;


   // ---
   pSQL:=estbk_sqlclientcollection._SQLSearchBills(estbk_globvars.glob_company_id);
   qryBillSrc.SQL.add(pSQL);
   qryBillSrc.Open;

if qryBillSrc.RecordCount>0 then
   billsGrid.DataSource:=qryBillSrcDs
else
   billsGrid.DataSource:=nil;

// ---------

   // ---
   chkbxSaleBill.Checked:=true;
   chkbxPurchBill.Checked:=true;

   chkbxCreditBill.Checked:=false;
   chkbxPrepaymentBill.Checked:=false;

   chkbxCreditBill.Enabled:=true;
   chkbxPrepaymentBill.Enabled:=true;
   cmbStaatus.ItemIndex:=0;
end;

procedure TframeBillList.btnCloseClick(Sender: TObject);
begin
    if assigned(onFrameKillSignal) then
       self.onFrameKillSignal(sender);
end;

procedure TframeBillList.btnNewBillClick(Sender: TObject);
begin
  if chkbxSaleBill.Checked then // müügiarved...
     self.onFrameDataEvent(self,__frameCreateNewSaleBill,-1,nil)
  else
  if chkbxPurchBill.Checked then // ostuarved...
     self.onFrameDataEvent(self,__frameCreateNewPurchBill,-1,nil)
end;

procedure TframeBillList.assignClientData(const pClient : TClientData);
begin
    if not assigned(pClient) then
     begin
      edtClientCode.Text:='';
      edtCustNameAndAddr.Text:='';

      self.FLastClientcode:='';
      self.FLastClientId:=0;
     end else
     begin
      edtCustNameAndAddr.Text:=pClient.FCustFullName;
      //edtClientCode.text:=inttostr(pClient.FClientId);
      edtClientCode.text:=pClient.FClientCode;
      self.FLastClientcode:=pClient.FClientCode;
      self.FLastClientId:=pClient.FClientId;
     end;
end;

procedure TframeBillList.btnOpenClientListClick(Sender: TObject);
var
   pClient : TClientData;
begin
   try
      //pCust:=estbk_customer.getCustomerDataWUI(strtointdef(edtClientCode.text,99999999));
      pClient:=estbk_frm_choosecustmer.__chooseClient(edtClientCode.text);
      assignClientData(pClient);
      // ---
   finally
      freeAndNil(pClient);
   end;
end;

procedure TframeBillList.btnPrintClick(Sender: TObject);
begin
  // ---
     if qryBillSrc.Eof then
        messageDlg(estbk_strmsg.SEQryRetNoData,mtinformation,[mbOk],0)
    else
      begin
        report.ShowProgress:=true;
        report.LoadFromFile(includetrailingbackslash(self.reportDefPath)+estbk_reportconst.CBillListReportFilename);
        report.ShowReport;
      end;
end;

constructor TframeBillList.create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
  dtEdtAccDate.date:=now;
  dtEdtAccDate.Text:='';
  edtEdtBillDate.date:=now;
  edtEdtBillDate.Text:='';

  // ---
  cmbStaatus.Items.Add(estbk_strmsg.SUndefComboChoise);
  cmbStaatus.Items.Add(estbk_strmsg.SCStatusConfirmed);
  cmbStaatus.Items.Add(estbk_strmsg.SCStatusUnConfirmed);

  cmbStaatus.ItemIndex:=0;
end;

destructor TframeBillList.destroy;
begin
 inherited destroy;
end;


initialization
  {$I estbk_fra_bill_list.ctrs}

end.

