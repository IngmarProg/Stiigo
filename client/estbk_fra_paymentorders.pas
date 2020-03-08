// * TASUMINE / MAKSEKORRALDUSED *
unit estbk_fra_paymentorders;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, ExtCtrls,
  DBGrids, ComCtrls, DBCtrls, EditBtn, StrUtils,
  rxlookup, Controls, Dialogs, Math, Buttons, dateutils, rxpopupunit,
  estbk_fra_template, estbk_utilities, estbk_uivisualinit, estbk_clientdatamodule, estbk_lib_commonaccprop, estbk_settings,
  estbk_sqlclientcollection, estbk_globvars, Graphics, estbk_frm_choosecustmer,
  estbk_lib_commonevents, estbk_lib_commoncls, estbk_fra_customer, contnrs, LCLProc,
  estbk_types, estbk_strmsg, DB, ZDataset, ZSqlUpdate, ZSequence, LCLType,
  rxdbgrid, ZAbstractDataset, ZSqlMonitor, Grids, Menus, estbk_lib_paymentmanager;

// viimane assert #5



type

  { TframePaymentOrder }

  TframePaymentOrder = class(Tfra_template)
    Bevel1: TBevel;
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnNewPayment: TBitBtn;
    btnOpenAccEntry: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnSave: TBitBtn;
    bv1: TBevel;
    dbEdtRecpRefNr: TDBEdit;
    dbEdtSumtotal: TDBEdit;
    dbGridAllItems: TDbGrid;
    dbEdtbankAcc: TDbEdit;
    dbEdtRecvAcc: TDbEdit;
    dbEdtBankCost: TDbEdit;
    dbExplMemo: TDbMemo;
    dbEdtDocNr: TDbEdit;
    chkboxConfPmtDone: TCheckBox;
    cmbCurrency: TComboBox;
    dbLookupComboCredit: TRxDBLookupCombo;
    dbRcvBankList: TRxDBLookupCombo;
    edtOrderNr: TEdit;
    edtrecpname: TDBEdit;
    lblTransactionCost: TLabel;
    lblVerified: TLabel;
    Label5: TLabel;
    lblAccCName: TLabel;
    lblbankacc: TLabel;
    lblCurrency: TLabel;
    lblMrgDescr: TLabel;
    lblPaymentrcv: TLabel;
    lblPaymentrcv1: TLabel;
    lblPaymentrcvname: TLabel;
    lblPaymentSumTotal: TLabel;
    lblPmtCreditAcc: TLabel;
    lblPmtDocNumber: TLabel;
    lblPmtOrderDate: TLabel;
    lblPmtOrderDate1: TLabel;
    lblRefNumber: TLabel;
    mnuItemDelLine: TMenuItem;
    miscSumDbGrid: TDBGrid;
    pconstrpanel: TPanel;
    pLblcurrVal: TLabel;
    pimgisverifiedclient: TImage;
    pmtDate: TDateEdit;
    popupMiscGridActions: TPopupMenu;
    qryGetAccountsDs: TDatasource;
    qryGetMiscPmtItemsDs: TDatasource;
    qryGetMiscPmtItems: TZQuery;
    qryGetPmtItemsDs: TDatasource;
    qryPmtBanks: TZReadOnlyQuery;
    qryPmtBanksDs: TDatasource;
    qryGetCBanksAccountsDs: TDatasource;
    qryPmtOrderDs: TDatasource;
    DBEdit4: TDBEdit;
    grpPmtOrder: TGroupBox;
    Image2: TImage;
    memProdDesc: TDBMemo;
    pageArtMainData: TTabSheet;
    pageCtrlArt: TPageControl;
    pageExtInfo: TTabSheet;
    panelLeft: TPanel;
    panelLeftInnerSrc: TPanel;
    panelRight: TPanel;
    rcornerimg: TImage;
    Splitter1: TSplitter;
    qryPmtOrder: TZQuery;
    qryPmtOrderUpt: TZUpdateSQL;
    qryGetCBanksAccounts: TZReadOnlyQuery;

    qryDataWrt: TZQuery;
    qryGetUserPmtItems: TZQuery;
    qryManagePaymentData: TZQuery;
    qryGetAccounts: TZQuery;
    qryGetMiscPmtItemsUptInst: TZUpdateSQL;
    lazFocusFix: TTimer;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewPaymentClick(Sender: TObject);
    procedure btnOpenAccEntryClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure chkboxConfPmtDoneChange(Sender: TObject);
    procedure cmbCurrencyChange(Sender: TObject);
    procedure dbedtBillSumKeyPress(Sender: TObject; var Key: char);
    procedure dbExplMemoKeyPress(Sender: TObject; var Key: char);
    procedure dbGridAllItemsCellClick(Column: TColumn);
    procedure dbGridAllItemsColEnter(Sender: TObject);
    procedure dbGridAllItemsColExit(Sender: TObject);
    procedure dbGridAllItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure dbGridAllItemsEnter(Sender: TObject);
    procedure dbGridAllItemsExit(Sender: TObject);
    procedure dbGridAllItemsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbGridAllItemsKeyPress(Sender: TObject; var Key: char);
    procedure dbGridAllItemsPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
    procedure dbGridAllItemsSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
    procedure dbGridAllItemsUserCheckboxBitmap(Sender: TObject; const CheckedState: TCheckboxState; var ABitmap: TBitmap);
    procedure dbLookupComboCreditChange(Sender: TObject);
    procedure dbLookupComboCreditClosePopupNotif(Sender: TObject);
    procedure dbLookupComboCreditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbLookupComboCreditSelect(Sender: TObject);
    procedure edtrecpnameChange(Sender: TObject);
    procedure edtrecpnameKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure lazFocusFixTimer(Sender: TObject);
    procedure mainPanelClick(Sender: TObject);
    procedure miscSumDbGridCellClick(Column: TColumn);
    procedure miscSumDbGridColEnter(Sender: TObject);
    procedure miscSumDbGridColExit(Sender: TObject);
    procedure miscSumDbGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure miscSumDbGridEnter(Sender: TObject);
    procedure miscSumDbGridExit(Sender: TObject);
    procedure miscSumDbGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure miscSumDbGridKeyPress(Sender: TObject; var Key: char);
    procedure miscSumDbGridSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
    procedure miscSumDbGridTitleClick(Column: TColumn);
    procedure mnuItemDelLineClick(Sender: TObject);
    procedure pmtDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure pmtDateChange(Sender: TObject);
    procedure pmtDateExit(Sender: TObject);
    procedure pmtDateKeyPress(Sender: TObject; var Key: char);
    procedure qryGetAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryGetCBanksAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryGetMiscPmtItemsAfterEdit(DataSet: TDataSet);
    procedure qryGetMiscPmtItemsAfterPost(DataSet: TDataSet);
    procedure qryGetMiscPmtItemsBeforePost(DataSet: TDataSet);
    procedure qryGetUserPmtItemsAfterEdit(DataSet: TDataSet);
    procedure qryGetUserPmtItemsAfterPost(DataSet: TDataSet);
    procedure qryGetUserPmtItemsBeforeEdit(DataSet: TDataSet);
    procedure qryGetUserPmtItemsBeforeInsert(DataSet: TDataSet);
    procedure qryPmtOrderAfterInsert(DataSet: TDataSet);
    procedure qryPmtOrderAfterScroll(DataSet: TDataSet);
    procedure qryPmtOrderBeforeEdit(DataSet: TDataSet);
    procedure qryPmtOrderBeforePost(DataSet: TDataSet);
  private
    // 16.06.2011 Ingmar; rumal lugu järgmine lazaruse fix ei peida ära editori
    FLiveEditor: TWinControl;
    FAccounts: TRxDBLookupCombo;
    FSelectedCol: TColumn;
    FLcmpAccountCode: AStr;
    // ---
    FNewRecord: boolean;
    FDataNotSaved: boolean;
    FMiscPODataChanged: boolean;
    FMiscLinesChanged: boolean;
    FSkipCellClickEvent: boolean;
    // ---
    FSkipScrollEvent: boolean;
    // valuuta konverteerimise kasum/kahjum
    FActiveEditor: TWinControl;
    // --
    //FLastDAccountId : Integer;
    FLastCAccountId: integer;

    // maksekorralduse avamisel hoitavad andmed
    FCurrPmtOrderID: integer;
    FCurrPmtAccBRecId: integer;

    // FCurrPmtAccPeriod : integer;
    // --
    FCurrPmtOrderConfirmed: boolean;
    FSkipOnChangeEvent: boolean;

    // ntx võtame ühe hankija, siis kuvatakse nö maksmata tellimused/ostuarved
    FStCurrInst: TAStrList; // valuutade nimistu
    // -- hoiame infot valitud kliendi kohta
    FPClientData: TClientData;
    FPPrevClientID: integer; // -- ntx olukord, kus avati eelsalvestatud maksekorraldus, aga vahetati klient ära
    // -- siis peame sisuliselt kõik valitud elemendid "tühistama", mis olid seotud eelmise kliendiga
    // -- peame kuidagi muudatuse tuvastama !

    //---
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FReqCurrUpdate: TRequestForCurrUpdate;
    FLazFocusFixFlags: byte;
    // ---
    function getPaymentOrderNr(const pDate: TDatetime; const pReload: boolean): string;
    function getClientId: integer;
    procedure setClientId(const pClientId: integer);
    procedure cpyCustomerMiscDataToDataset(const pClientData: TClientData);

    procedure OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
    procedure OnLookupComboSelect(Sender: TObject);
    procedure OnLookupComboChange(Sender: TObject);
    procedure OnLookupComboEnter(Sender: TObject);
    procedure OnLookupComboExit(Sender: TObject);
    procedure OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);

    procedure performCleanup;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure reloadCustomerData(const pClientId: integer; const pdispSrcForm: boolean = True);



    // --
    procedure managePaymentOrderItems(const pPmtOrderID: integer; const pTrackChanges: Tcollection);
    procedure refreshUICurrList(const pCurrDate: TDatetime);
    procedure ctrlsVisState(const pEnabled: boolean);

    procedure qryOpenPmt(const ppaymentID: integer);
    procedure qryPsPaymentData(const ppaymentID: integer);
    procedure qryPsPaymentMiscSum(const ppaymentID: integer); // ntx riigilõivu read või midagi taolist

    // arvete / tellimuste kogusumma
    function calculatePaymentOrderTotalSum(var pPmtSum: double; // arve valuutas
      var pDiff: double; // baasvaluuta
      var pDescr: AStr): boolean;  // --

    procedure calculatePaymentOrderMiscItemsTotalSum(var pPmtSum: double; var pDescr: AStr);

    procedure changePmtOrderSumAndDescr(const updateDescrField: boolean = True);

    function detectAccDataChange(var pPmtJustDocDataChanged: boolean): boolean;
    procedure cancelPmtOrderAccRecs(const pPmtOrderAccMainRecId: integer);
    function resolveAccName(const pAccId: integer; var pdefaultCurr: AStr): AStr;

    procedure createAccountingRecords(const pMainAccRecId: integer; const pClientId: integer);
    function savePaymentOrderData: boolean;
    function verifyMiscLines: boolean;
    procedure doOnClickFix(Sender: TObject);
    // ---
    // 12.06.2011 Ingmar
    procedure OnOvrEditorExit(Sender: TObject);
    procedure OnOvrEditorExit2(Sender: TObject);


  public
    // lihtne wrapper, et kui vorm avatakse oleks justkui uus tasumine nuppu vajutatud
    procedure callNewPaymentEvent;
    // --
    // üldiselt seda vaja, ntx tellimusest saaks automaatselt maksesse liikuda
    // seal ongi 3 sammu:
    // -  createNewPayment
    // -  clientId paika
    // -  setCustomerPmtItemsFilter filter kasutaja tellimuse peale
    procedure createNewPayment;
    // ntx tellimuse lehelt tahetakse koheselt makse teha
    procedure createNewPaymentWithPreDefOrder(const pOrderId: integer; const pClientId: integer);

    // 0 ja '' tühistab filtri !
    procedure setCustomerPmtItemsFilter(const pItemId: integer; const pItemType: AStr);


    procedure openPayment(const pPaymentId: integer);


    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
    // RTTI teema !
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onAskCurrencyDownload: TRequestForCurrUpdate read FReqCurrUpdate write FReqCurrUpdate;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;

    // võimaldab kuvada vaid antud hankija/kliendi arveid, tellimusi
    property clientId: integer read getClientId write setClientId;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

uses variants;

const
  CLeftHiddenCorn = -200;

const
  CCol_sumtoPay = 3;
  CCol_incomings = 4;
  CCol_toPay = 5;
  CCol_currency = 6;
  CCol_spltSum = 7;
  CCol_itemChecked = 8;

const
  CCol2_descr = 0;
  CCol2_sum = 1;
  CCol2_account = 2;


const
  CLookupKeyField = 'account_coding';
  CLookupSpltsum = 'splt_sum';
  CCurrencyKeyField = 'currency';

// lazaruse kalade fix
const
  CLazFixDbGridFocus = 1;
  CLazFixLookupFocus = 2;

procedure TframePaymentOrder.callNewPaymentEvent;
begin
  if btnNewPayment.Enabled then
    btnNewPayment.OnClick(btnNewPayment);
end;


procedure TframePaymentOrder.OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix();
end;


procedure TframePaymentOrder.OnLookupComboChange(Sender: TObject);
begin
  // ---
end;

//   if trim(TRxDBLookupCombo(Sender).Text)<>'' then
procedure TframePaymentOrder.OnLookupComboSelect(Sender: TObject);
begin
  if TRxDBLookupCombo(Sender).Tag = 0 then
    if qryGetMiscPmtItems.Active then // 24.02.2013 Ingmar; et ei ütles, dataset not active !
    begin
      // @@@
      if not (qryGetMiscPmtItems.State in [dsEdit, dsInsert]) then
        qryGetMiscPmtItems.Edit;

      self.FLcmpAccountCode := qryGetAccounts.FieldByName('account_coding').AsString;
      // ---
      qryGetMiscPmtItems.FieldByName('account_coding').AsString := self.FLcmpAccountCode;
      qryGetMiscPmtItems.FieldByName('account_id').AsInteger := qryGetAccounts.FieldByName('id').AsInteger;
      TRxDBLookupCombo(Sender).Text := self.FLcmpAccountCode;

      self.FLazFocusFixFlags := CLazFixLookupFocus;
      self.lazFocusFix.Enabled := True;
    end;
end;

procedure TframePaymentOrder.OnLookupComboEnter(Sender: TObject);
begin
  // ---
end;

procedure TframePaymentOrder.OnLookupComboExit(Sender: TObject);
begin
  // ---
end;

procedure TframePaymentOrder.OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Shift = []) then
    case key of
      VK_LEFT: if assigned(self.FSelectedCol) then
        begin
          miscSumDbGrid.SelectedIndex := self.FSelectedCol.Index - 1;
          exit;
        end; // --

      VK_DELETE:
        try
          TRxDBLookupCombo(Sender).Tag := -1;
          //estbk_utilities.rxLibKeyDownHelper(TRxDBLookupCombo(Sender),Key,Shift);
          self.FLcmpAccountCode := '';


          qryGetMiscPmtItems.Edit;
          qryGetMiscPmtItems.FieldByName('account_coding').AsString := '';
          qryGetMiscPmtItems.FieldByName('account_id').AsInteger := 0;
          qryGetMiscPmtItems.Post;

          TRxDBLookupCombo(Sender).Value := '';
          TRxDBLookupCombo(Sender).Text := '';

          if miscSumDbGrid.CanFocus then
            miscSumDbGrid.SetFocus;

          if TRxDBLookupCombo(Sender).CanFocus then
            TRxDBLookupCombo(Sender).SetFocus;

          key := 0;
        finally
          TRxDBLookupCombo(Sender).Tag := 0;
        end;
    end;

  // ---
  self.miscSumDbGridKeyDown(Sender, key, shift);
end;


procedure TframePaymentOrder.performCleanup;
var
  pIndex: integer;
begin
  lazFocusFix.Enabled := False;
  self.FActiveEditor := nil;



  self.FSelectedCol := nil;
  self.FLcmpAccountCode := '';
  self.FPPrevClientID := 0;

  if assigned(self.FPClientData) then
    FreeAndNil(self.FPClientData);


  self.FNewRecord := False;
  self.FDataNotSaved := False;
  self.FCurrPmtOrderConfirmed := False;

  // ----
  self.FMiscPODataChanged := False;
  self.FMiscLinesChanged := False;


  self.dbGridAllItems.Hint := '';
  self.pmtDate.Date := date;
  self.pmtDate.Text := datetostr(self.pmtDate.date);

  self.edtrecpname.Hint := '';
  dbLookupComboCredit.Text := '';
  //dbLookupComboDebit.Text := '';
  lblAccCName.Caption := '';
  //lblAccDName.Caption := '';


  chkboxConfPmtDone.Checked := False;
  pLblcurrVal.Caption := #32 + format(CCurrentAmFmt4, [double(1)]);
  // ---
  //self.tarbCtrlPmtOrder.ActivePage := tabPmtOrder;



  // ---
  pIndex := cmbCurrency.items.indexOf(estbk_globvars.glob_baseCurrency);
  if pIndex >= 0 then
    cmbCurrency.ItemIndex := pIndex;

  pimgisverifiedclient.Picture.Clear;
  pimgisverifiedclient.Hint := '';
  edtrecpname.Hint := '';

  self.FAccounts.Value := '';
  self.FAccounts.Text := '';

  //    tarbCtrlPmtOrder.ActivePage := tabPmtOrder;
  //if  assigned(dbLookupComboCredit.LookupSource) then
  //    dbLookupComboCredit.LookupSource.DataSet.First;
end;


function TframePaymentOrder.getClientId: integer;
begin
  if assigned(self.FPClientData) then
    Result := self.FPClientData.FClientId
  else
    Result := 0;
end;


procedure TframePaymentOrder.setClientId(const pClientId: integer);
begin
  if pClientId > 0 then
    self.reloadCustomerData(pClientId, False);
end;


// sub
procedure TframePaymentOrder.cpyCustomerMiscDataToDataset(const pClientData: TClientData);
var
  pOpenEdtSession: boolean;
begin

  pOpenEdtSession := not (qryPmtOrder.State in [dsEdit, dsInsert]);
  if pOpenEdtSession then
    qryPmtOrder.Edit;

  if assigned(pClientData) then
  begin
    // infoks kliendi id/ regkood
    self.edtrecpname.Hint := IntToStr(pClientData.FClientId);

    if pClientData.FCustRegNr <> '' then
      self.edtrecpname.Hint := self.edtrecpname.Hint + ' / ' + pClientData.FCustRegNr;


    qryPmtOrder.FieldByName('client_id').AsInteger := self.clientId;
    // ---
    qryPmtOrder.FieldByName('payment_rcv_name').AsString := pClientData.FCustFullName;
    qryPmtOrder.FieldByName('payment_rcv_refnr').AsString := pClientData.FCustPurchRefNr;
    qryPmtOrder.FieldByName('payment_rcv_account_nr').AsString := pClientData.FCustBankAccount;

    if qryPmtBanks.Locate('id', integer(pClientData.FCustBankId), []) then
    begin
      qryPmtOrder.FieldByName('payment_rcv_bank_id').AsInteger := pClientData.FCustBankId;
      dbRcvBankList.Text := qryPmtBanks.FieldByName('bankname').AsString;
    end
    else
    begin
      qryPmtOrder.FieldByName('payment_rcv_bank_id').AsInteger := 0;
      dbRcvBankList.Value := '';
      dbRcvBankList.Text := '';
    end;
    // ---
  end
  else
  begin
    self.edtrecpname.Hint := '';
    qryPmtOrder.FieldByName('client_id').AsInteger := self.clientId;
    qryPmtOrder.FieldByName('payment_rcv_name').AsString := '';
    qryPmtOrder.FieldByName('payment_rcv_refnr').AsString := '';
    qryPmtOrder.FieldByName('payment_rcv_account_nr').AsString := '';
  end;


  // 25.03.2010 Ingmar; see ju tarnija !!!
  //qryPmtOrder.FieldByname('payment_rcv_refnr').asString:=pNewCustData.FCustContrRefNr;


  if pOpenEdtSession then
    qryPmtOrder.Post;
end;


procedure TframePaymentOrder.reloadCustomerData(const pClientId: integer; const pdispSrcForm: boolean = True);

var
  pNewClientData: TClientData;
  pOpenEdtSession: boolean;
  pReloadClientData: boolean;
  pBmp: TBitmap;
  pCust: AStr;

begin
  pNewClientData := nil;
  if chkboxConfPmtDone.Checked then
    exit;

  pReloadClientData := False;
  if pdispSrcForm then
    pNewClientData := estbk_frm_choosecustmer.__chooseClient(pClientId)
  else
    pNewClientData := estbk_fra_customer.getClientDataWUI_uniq(pClientId);


  try
    pBmp := TBitmap.Create;
    dmodule.sharedImages.GetBitmap(img_indxItemVerified, pBmp);
    pimgisverifiedclient.Picture.Assign(pBmp);
  finally
    pBmp.Free;
  end;



  // vahetati klienti või uus klient !
  if assigned(pNewClientData) and (not assigned(self.FPClientData) or (pNewClientData.FClientId <> FPClientData.FClientId)) then
  begin
    if assigned(self.FPClientData) then
      FreeAndNil(self.FPClientData);

    self.FPClientData := pNewClientData; // okei uus klient/uued andmed
    pReloadClientData := True;


    // 28.08.2010 Ingmar
    self.changePmtOrderSumAndDescr();
    pCust := self.FPClientData.FClientCode;
    if self.FPClientData.FCustRegNr <> '' then
      pCust := pCust + ' (' + self.FPClientData.FCustRegNr + ')';

    pimgisverifiedclient.Hint := pCust;
  end
  else
  // me ei vaja neid puhverdatud andmeid !
  if assigned(pNewClientData) then
    FreeAndNil(pNewClientData);

     (*
     else
     if not assigned(pNewClientData) then
       begin

        // tühistame kliendi valiku; kliendi valikus järelikult tühistatud vajutatud !
        if assigned(self.FPClientData) then
          begin
           FreeAndNil(self.FPClientData);

           self.cpyCustomerMiscDataToDataset(nil);
           self.edtrecpname.Hint:='';
           pimgisverifiedclient.Picture.Clear;
          end;
        // ---
       end;*)




  // --- kopeerime ka andmed koheselt dataseti
  if pReloadClientData then
  begin

    self.cpyCustomerMiscDataToDataset(self.FPClientData);
    // 11.08.2010 Ingmar
    if self.FNewRecord then
      self.qryPsPaymentData(0)
    else
      self.qryPsPaymentData(self.FCurrPmtOrderID);
  end;
  // ---
end;



function TframePaymentOrder.getDataLoadStatus: boolean;
begin
  Result := qryPmtOrder.Active;
end;

procedure TframePaymentOrder.setDataLoadStatus(const v: boolean);
begin
  //tarbCtrlPmtOrder.ActivePage := tabPmtOrder;
  // ---
  qryPmtOrder.Close;
  qryPmtOrder.SQL.Clear;

  qryGetCBanksAccounts.Close;
  qryGetCBanksAccounts.SQL.Clear;


  qryManagePaymentData.Close;
  qryManagePaymentData.SQL.Clear;


  // ---
  qryPmtOrderUpt.ModifySQL.Clear;
  qryPmtOrderUpt.InsertSQL.Clear;

  qryGetAccounts.Close;
  qryGetAccounts.SQL.Clear;


  qryGetMiscPmtItemsUptInst.ModifySQL.Clear;
  qryGetMiscPmtItemsUptInst.InsertSQL.Clear;
  qryGetMiscPmtItemsUptInst.DeleteSQL.Clear;


  qryPmtBanks.Close;
  qryPmtBanks.SQL.Clear;



  if v then
  begin

    if assigned(self.FStCurrInst) then
      FreeAndNil(self.FStCurrInst);

    self.FStCurrInst := estbk_clientdatamodule.dmodule.createPrivateCurrListCopy();
    cmbCurrency.Items.Assign(self.FStCurrInst);




    // ----
    qryGetCBanksAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
    //qryGetAllBkAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryPmtBanks.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryDataWrt.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryGetUserPmtItems.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryManagePaymentData.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryGetAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryGetMiscPmtItems.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryPmtOrder.Connection := estbk_clientdatamodule.dmodule.primConnection;


    qryGetMiscPmtItemsUptInst.DeleteSQL.Add(estbk_sqlclientcollection._SQLDeletePaymentMiscData);
    qryGetMiscPmtItemsUptInst.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdatePaymentDataStatus);
    qryGetMiscPmtItemsUptInst.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertPaymentData2);
    //qryGetMiscPmtItemsUptInst.ModifySQL.Add(estbk_sqlclientcollection._SQLInsertPmtOrderData2);




    // ---
    qryPmtOrderUpt.ModifySQL.Add(estbk_sqlclientCollection._SQLUpdatePayment);
    qryPmtOrderUpt.InsertSQL.Add(estbk_sqlclientCollection._SQLInsertPayment);



    qryGetCBanksAccounts.SQL.Add(estbk_sqlclientCollection._SQLSelectAccountsWithBankData);
    qryGetCBanksAccounts.ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetCBanksAccounts.active := v;



    qryPmtBanks.SQL.Add(estbk_sqlclientCollection._SQLSelectBanks);
    qryPmtBanks.ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryPmtBanks.active := v;



    qryGetAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    qryGetAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetAccounts.Open;
  end
  else
  begin
    qryGetCBanksAccounts.Connection := nil;
    //qryGetAllBkAccounts.Connection := nil;
    qryPmtBanks.Connection := nil;
    qryDataWrt.Connection := nil;
    qryGetUserPmtItems.Connection := nil;
    qryManagePaymentData.Connection := nil;
    qryGetAccounts.Connection := nil;
    qryGetMiscPmtItems.Connection := nil;
    qryPmtOrder.Connection := nil;
  end;


  self.ctrlsVisState(False);

end;


procedure TframePaymentOrder.qryOpenPmt(const ppaymentID: integer);
var
  pCurrName: AStr;
  pcurrVal: double;
begin
  with qryPmtOrder, SQL do
  begin
    //self.performCleanup;

    Close;
    Clear;
    add(estbk_sqlclientcollection._SQLSelectPayment);
    paramByname('id').AsInteger := ppaymentID;
    paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    paramByname('payment_type').AsString := estbk_types.CPayment_aspmtord;
    Open;


    // 28.08.2010 Ingmar; kliendi muutuse tuvastamine !
    self.FPPrevClientID := FieldByName('client_id').AsInteger;




    // --- peale ka kliendi andmed küsima...kui need olemas...
    if (ppaymentID > 0) and (FieldByName('client_id').AsInteger > 0) then
      self.FPClientData := estbk_fra_customer.getClientDataWUI_uniq(FieldByName('client_id').AsInteger);



    // valitud arved/tellimused
    self.qryPsPaymentData(ppaymentID);
    // muud read
    self.qryPsPaymentMiscSum(ppaymentID);



    // õiged päevakursid peale
    estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pmtDate.date, self.FStCurrInst);



    // küsime uuesti kurssi !
    pCurrName := FieldByName('currency').AsString;
    cmbCurrency.ItemIndex := cmbCurrency.Items.IndexOf(pCurrName);
    if cmbCurrency.ItemIndex = -1 then
      cmbCurrency.ItemIndex := cmbCurrency.Items.IndexOf(estbk_globvars.glob_baseCurrency);



    // 04.04.2011 Ingmar; peame kuvama siiski maksega seotud kursi !
    pcurrVal := FieldByName('currency_drate_ovr').AsFloat;
    if pcurrVal > 0.00 then
      TCurrencyObjType(self.cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).currVal := pCurrVal
    else
      pcurrVal := TCurrencyObjType(self.cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).currVal;
    // ---
    pLblcurrVal.Caption := #32 + format(CCurrentAmFmt4, [double(pcurrVal)]);




    // ---
    if ppaymentID > 0 then
      self.FCurrPmtOrderID := ppaymentID;

    // reset filtritele !
    qryGetCBanksAccounts.Filtered := False;
    qryGetCBanksAccounts.Filtered := True;


    // -------
    chkboxConfPmtDone.Enabled := True;
    lblVerified.Enabled := True;



    btnNewPayment.Enabled := True;
    btnSave.Enabled := False;
    btnCancel.Enabled := False;

    btnOpenAccEntry.Enabled := self.FCurrPmtOrderConfirmed;
  end;
end;


procedure TframePaymentOrder.ctrlsVisState(const pEnabled: boolean);
begin
  estbk_utilities.changeWCtrlEnabledStatus(grpPmtOrder, pEnabled, 0);
  //estbk_utilities.changeWCtrlEnabledStatus(grpPmtOrder, pEnabled, 0);
  //lblAccCName.Visible := pEnabled;
  //lblAccDName.Visible := pEnabled;
  //bv1.Visible := pEnabled;
  //bv2.Visible := pEnabled;
  //bv2.Visible := pEnabled;
  //bh2.Visible := pEnabled;
  //bh3.Visible := pEnabled;
  //estbk_utilities.changeWCtrlEnabledStatus(dbGridAllItems, pEnabled, 0);
end;

procedure TframePaymentOrder.openPayment(const pPaymentId: integer);
begin
  self.performCleanup;
  self.qryOpenPmt(pPaymentId);


  self.FCurrPmtAccBRecId := qryPmtOrder.FieldByName('accounting_register_id').AsInteger;



  // kas kinnitatud tasumine
  self.FCurrPmtOrderConfirmed := pos(estbk_types.CPaymentRecStatusClosed, qryPmtOrder.FieldByName('status').AsString) > 0;
  self.ctrlsVisState(not qryPmtOrder.EOF);

  estbk_utilities.changeWCtrlReadOnlyStatus(grpPmtOrder, self.FCurrPmtOrderConfirmed);
  //estbk_utilities.changeWCtrlReadOnlyStatus(pPanel,self.FCurrPmtOrderConfirmed);


  chkboxConfPmtDone.Checked := self.FCurrPmtOrderConfirmed;
  chkboxConfPmtDone.Enabled := True;
  lblVerified.Enabled := True;


  // kas saab kannet vaadata
  // self.btnOpenAccEntry.Enabled:=(self.FCurrPmtAccBRecId>0);
  // 04.04.2011 Ingmar; viga vaid kinnitatud tasumisel on ka kanded, muidu vaid tühi kirjete kest !
  self.btnOpenAccEntry.Enabled := self.FCurrPmtOrderConfirmed;
end;

procedure TframePaymentOrder.dbLookupComboCreditClosePopupNotif(Sender: TObject);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;



// -- haldame sooritatud valikuid
// -- selekteerime esmalt välja, mis muutus, mis kadus jne
procedure TframePaymentOrder.managePaymentOrderItems(const pPmtOrderID: integer; const pTrackChanges: Tcollection);
var
  pBookMark: TBookmark;
  pPmtOrdDataId: integer;
  pIsChecked: boolean;
  pUpdateNeeded: boolean;
  // --
  pPMode: TMarkIncItems;
  pChangedData: TTrackItemChanges;
begin
  try

    // lõpetame red. reziimi
    if qryGetUserPmtItems.State in [dsEdit, dsInsert] then
      qryGetUserPmtItems.Post;


    // kõige ebameeldivam olukord üldse...tasumisel vahetati klient ära...ehk...kõik eelnevad read annuleerida
    if not self.FNewRecord and (self.FPPrevClientID <> self.clientId) then
      with qryDataWrt, SQL do
        try
          // esmalt jätame meelde muudatused ! sest peame arvetelt ja tellimustelt need summad maha võtma !
          // kanded tehakse alati uuesti !
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLSelectOrderPmtData2);
          paramByname('payment_id').AsInteger := pPmtOrderID;
          Open;
          First;
          while not EOF do
          begin
            pChangedData := TTrackItemChanges.Create(pTrackChanges);
            pChangedData.FChangeType := cRemovePaymentSum;
            pChangedData.FItemId := FieldByName('item_id').AsInteger;
            pChangedData.FItemType := FieldByName('item_type').AsString;
            pChangedData.FNewSum := 0;
            pChangedData.FPrevSum := FieldByName('splt_sum').asCurrency;
            // ---
            Next;
          end;

          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLDeletePaymentMiscData2);
          paramByname('payment_id').AsInteger := pPmtOrderID;
          execSQL;


        finally
          Close;
          Clear;
        end;



    pBookMark := qryGetUserPmtItems.getBookmark;
    qryGetUserPmtItems.DisableControls;
    // siiski esmalt võrdleme, kas maksekorralduse kogusumma = valitud elementidega !


    qryGetUserPmtItems.First;

    while not qryGetUserPmtItems.EOF do
    begin
      pPmtOrdDataId := qryGetUserPmtItems.FieldByName('pmtdata_id').AsInteger;
      pIsChecked := estbk_utilities.isTrueVal(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString);




      pPMode := cMarkBillPayment;
      if qryGetUserPmtItems.FieldByName('litemtype').AsString = estbk_types.CCommTypeAsOrder then
        pPMode := cMarkOrderPayment;


      // järelikult element eemaldati !!!
      if (pPmtOrdDataId > 0) then
        with qryDataWrt, SQL do
          try
            pUpdateNeeded := False;
            // ---
            Close;
            Clear;
            add(estbk_sqlclientcollection._SQLUpdatePaymentDataStatus);
            paramByName('id').AsInteger := pPmtOrdDataId;



            // -- DEL
            if not pIsChecked then
            begin
              // järelikult maksekorraldus taasavati ning eemaldati arve/tellimus !
              paramByname('item_descr').AsString := '';
              paramByname('account_id').AsInteger := 0;
              paramByname('status').AsString := estbk_types.CRecIsCanceled;
              pUpdateNeeded := True;




              pChangedData := TTrackItemChanges.Create(pTrackChanges);
              pChangedData.FChangeType := cRemovePaymentSum;
              pChangedData.FItemId := qryGetUserPmtItems.FieldByName('id').AsInteger;
              pChangedData.FItemType := qryGetUserPmtItems.FieldByName('litemtype').AsString;
              pChangedData.FNewSum := 0;
              pChangedData.FPrevSum := qryGetUserPmtItems.FieldByName('or_splt_sum').asCurrency;

            end
            else
              // -- UPT
            begin
              paramByname('status').Value := null; // säilitame eelmised originaalstaatused !
              paramByname('item_descr').AsString := '';
              paramByname('account_id').AsInteger := 0;


              // -----
              pUpdateNeeded := (qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency <> qryGetUserPmtItems.FieldByName('or_splt_sum').asCurrency);

              if pUpdateNeeded then
              begin
                pChangedData := TTrackItemChanges.Create(pTrackChanges);
                pChangedData.FChangeType := cUpdatePaymentSum;
                pChangedData.FItemId := qryGetUserPmtItems.FieldByName('id').AsInteger;
                pChangedData.FItemType := qryGetUserPmtItems.FieldByName('litemtype').AsString;
                pChangedData.FNewSum := qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency;
                pChangedData.FPrevSum := qryGetUserPmtItems.FieldByName('or_splt_sum').asCurrency;
              end;
              // ---
            end;



            // 04.04.2010 Ingmar; säilita originaalsumma !!!!!!!!
            if pos(estbk_types.CRecIsCanceled, paramByname('status').AsString) = 0 then
              paramByname('splt_sum').AsCurrency := qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency;


            // ---
            if pUpdateNeeded then
              execSQL;
          finally
            Close;
            Clear;
          end
      else
      // elementi pole veel kasutatud, lisame !
      if (pPmtOrdDataId < 1) and pIsChecked then
        with qryDataWrt, SQL do
          try

            Close;
            Clear;
            add(estbk_sqlclientcollection._SQLInsertPaymentData);
            paramByname('id').AsInteger := estbk_clientdatamodule.dmodule.qryPaymentDataSeq.GetNextValue;
            paramByname('payment_id').AsInteger := pPmtOrderID;
            paramByname('item_type').AsString := qryGetUserPmtItems.FieldByName('litemtype').AsString;
            paramByname('item_id').AsInteger := qryGetUserPmtItems.FieldByName('id').AsInteger;
            paramByname('splt_sum').AsCurrency := qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency;
            paramByname('item_descr').AsString := '';
            paramByname('account_id').AsInteger := 0; //qryGetUserPmtItems.FieldByName('account_id').AsInteger
            paramByname('status').AsString := '';
            execSQL;


            // -- märgime ära muudatuse !
            pChangedData := TTrackItemChanges.Create(pTrackChanges);
            pChangedData.FChangeType := cAddPaymentSum;
            pChangedData.FItemId := qryGetUserPmtItems.FieldByName('id').AsInteger;
            pChangedData.FItemType := qryGetUserPmtItems.FieldByName('litemtype').AsString;
            pChangedData.FNewSum := qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency;
            pChangedData.FPrevSum := 0;

            // --
          finally
            Close;
            Clear;
          end;


      // ---
      qryGetUserPmtItems.Next;
    end;
  finally

    if assigned(pBookMark) then
    begin
      qryGetUserPmtItems.GotoBookmark(pBookMark);
      qryGetUserPmtItems.FreeBookmark(pBookMark);
    end;


    qryGetUserPmtItems.EnableControls;
    // ---
  end;
end;


procedure TframePaymentOrder.refreshUICurrList(const pCurrDate: TDatetime);
var
  pCurrData: TDate;
  pCurrFnd: boolean;
  pItemIndex: integer;
begin

  // 19.08.2011 Ingmar; BUGI: meil pole mõtet uuendada, kui valuutaks on EUR
  if AnsiUpperCase(cmbCurrency.Text) = AnsiUpperCase(estbk_globvars.glob_baseCurrency) then
    exit;


  if pmtDate.Text <> '' then
    try
      // pCurrData := pmtDate.date;

      pCurrData := pCurrDate; // pmtDate.Date;
      pItemIndex := cmbCurrency.ItemIndex;

      // kui kuupäev ei klapi laeme uuesti  daysBetween on ohutum kasutada !!!
      if dateutils.daysBetween(TCurrencyObjType(self.FStCurrInst.Objects[0]).currDate, pCurrData) <> 0 then
      begin

        // võtame ja vaatame
        pCurrFnd := estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pCurrData, self.FStCurrInst);
        // valuutakurssi ei leitud !
        if not pCurrFnd then
          if assigned(self.onAskCurrencyDownload) then
          begin
            self.onAskCurrencyDownload(self, pCurrData);
            estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pCurrData, self.FStCurrInst); // küsime uuesti kurssi !
          end;
      end;

      // --
      if pItemIndex >= 0 then
        pLblcurrVal.Caption := #32 + format(CCurrentAmFmt4, [TCurrencyObjType(cmbCurrency.items.Objects[pItemIndex]).currVal])
      else
        pLblcurrVal.Caption := '';



      // --- kirjeldus pole vaja uuendada
      self.changePmtOrderSumAndDescr(False);

       {
        qryGetAccounts.Filtered:=false;
        qryGetAccounts.Filtered:=true;
        }
    except
      on e: Exception do
        if (e is EAbort) then
          estbk_utilities.miscResetCurrenyValList(cmbCurrency)
        else
          raise;
    end;
end;


// kontroll, kas mingid kriitilised andmed muutusid !
function TframePaymentOrder.detectAccDataChange(var pPmtJustDocDataChanged: boolean): boolean;
begin

  Result := False;
  if not self.FNewRecord then
  begin
    pPmtJustDocDataChanged := False;

    // ZEOSE kala !!! kui tegemist täiesti uue kirjega, siis saab vea listindex out of bounds !
    // ohutum on str tüüpi võrdlust teha variantide puhul !
    Result := (vartoStr(qryPmtOrder.FieldByName('c_account_id').OldValue) <> // konto muutunud
      vartoStr(qryPmtOrder.FieldByName('c_account_id').Value)) or
      //(vartoStr(qryPmtOrder.FieldByName('d_account_id').OldValue) <>
      // vartoStr(qryPmtOrder.FieldByName('d_account_id').Value)) or
      (vartoStr(qryPmtOrder.FieldByName('sumtotal').OldValue) <> vartoStr(qryPmtOrder.FieldByName('sumtotal').Value)) or

      // 12.03.2011 Ingmar;
      (vartoStr(qryPmtOrder.FieldByName('client_id').OldValue) <> vartoStr(qryPmtOrder.FieldByName('client_id').Value)) or
      (cmbCurrency.Text <> qryPmtOrder.FieldByName('currency').AsString);

    // -------
    Result := Result or self.FMiscPODataChanged or self.FMiscLinesChanged;
    Result := Result or (vartoStr(qryPmtOrder.FieldByName('payment_date').OldValue) <> qryPmtOrder.FieldByName('payment_date').AsString);


    if not Result then
    begin
      Result := (vartoStr(qryPmtOrder.FieldByName('document_nr').OldValue) <> qryPmtOrder.FieldByName('document_nr').AsString);

      pPmtJustDocDataChanged := Result;
    end;
  end;  // ---
end;


procedure TframePaymentOrder.cancelPmtOrderAccRecs(const pPmtOrderAccMainRecId: integer);
var
  pPmtMgr: TPaymentManager;
begin
  try
    pPmtMgr := TPaymentManager.Create(__pmtModeAsPayment, self.FStCurrInst);
    pPmtMgr.accMainRec := pPmtOrderAccMainRecId;
    pPmtMgr.doCancelAllEntrys(pPmtOrderAccMainRecId);
  finally
    FreeAndNil(pPmtMgr);
  end;
end;




function TframePaymentOrder.resolveAccName(const pAccId: integer; var pDefaultCurr: AStr): AStr;
var
  pBookmark: TBookmark;
  pFilterStatus: boolean;
begin
  Result := '';
  pDefaultCurr := '';

  try
    pBookmark := qryGetAccounts.GetBookmark;
    pFilterStatus := qryGetAccounts.Filtered;

    qryGetAccounts.DisableControls;
    qryGetAccounts.Filtered := False;
    assert(qryGetAccounts.Locate('id', pAccId, []), '#1');


    // ---
    Result := qryGetAccounts.FieldByName('account_name').AsString;

  finally
    if assigned(pBookmark) then
    begin
      qryGetAccounts.GotoBookmark(pBookmark);

      qryGetAccounts.Filtered := pFilterStatus;
      qryGetAccounts.FreeBookmark(pBookmark);
    end;
    // --
    qryGetAccounts.EnableControls;
  end;


  // ---
  if length(trim(pDefaultCurr)) <> 3 then
    pDefaultCurr := qryGetAccounts.FieldByName('default_currency').AsString;
end;


procedure TframePaymentOrder.createAccountingRecords(const pMainAccRecId: integer; const pClientId: integer);
var
  // maksekorralduse valuutainfo !!!!
  pCurrRate: double;
  pCurrencyId: integer;
  pCurrency: AStr;

  pNewSum: double;   // summa rea pealt; enamasti = makstava summaga
  pCalcIncomesum: double; // kogu laekumine arvele
  pCalcPrpBalance: double; // vaatame, kas uue maksega tuli mingi ettemaksu
  pPrepaidSum: double; // arvel olev ettemaks
  pIncomeSum: double; // palju arvele raha peale märgiti
  pBankCharge: double;   // pangakulud
  pToPaySum: double;
  pItemBookmark: TBookmark;
  pItemIndx, i: integer;
  pBillAccId: integer;
  pAccId: integer;
  // ---
  pIndex: integer;
  pDefCurr: AStr;
  pLineDescr: AStr;
  pPaymentStatus: Astr;

  pFiltstatus: boolean;
  pFiltOrigStr: Astr;
  // --
  // pAccEntry  : TIntAddAccountingEntry;
  pPmtMgr: TPaymentManager;
  pPmtAccRec: TPaymentAccData;
  pAccountCurr: Astr;

begin
  try

    pPmtMgr := TPaymentManager.Create(__pmtModeAsPayment, self.FStCurrInst);
    pPmtMgr.accMainRec := pMainAccRecId;



    // ennem kui üldse mingeid kirjeid tekitame vaatame valuuta kohe üle !
    if (cmbCurrency.ItemIndex >= 0) and (cmbCurrency.Text <> estbk_globvars.glob_baseCurrency) then
    begin
      pItemIndx := cmbCurrency.ItemIndex;
      pCurrRate := TCurrencyObjType(self.FStCurrInst.Objects[pItemIndx]).currVal;
      pCurrencyId := TCurrencyObjType(self.FStCurrInst.Objects[pItemIndx]).id;
      pCurrency := cmbCurrency.Text;
    end
    else
    begin
      pCurrRate := 1;
      pCurrencyId := 0;
      // pRecSumInSelCurr := 0;
      pCurrency := estbk_globvars.glob_baseCurrency;
    end;


    pPmtMgr.paymentCurrency := pCurrency;
    pPmtMgr.paymentCurrId := pCurrencyId;
    pPmtMgr.paymentCurrRate := pCurrRate;

    // -----------------------------------
    // --- MUUD SUMMAD; ntx riigilõivud jne jne
    // -----------------------------------

    try

      qryGetMiscPmtItems.DisableControls;
      pItemBookmark := qryGetMiscPmtItems.GetBookmark;


      qryGetMiscPmtItems.First;
      while not qryGetMiscPmtItems.EOF do
      begin

        pPmtAccRec := pPmtMgr.addAccEntry(-1, __pmtItemAsUnknown); // !!


        //pAccEntry:=TIntAddAccountingEntry.Create;
        pAccId := qryGetMiscPmtItems.FieldByName('account_id').AsInteger;
        pLineDescr := Copy(trim(qryGetMiscPmtItems.FieldByName('item_descr').AsString), 1, 255);
        pPmtAccRec.descr := pLineDescr;


        // ----
        pPmtAccRec.recType := estbk_types.CAccRecTypeAsDebit;
        pPmtAccRec.accountId := pAccId;


        pPmtAccRec.descr := pLineDescr;
        pPmtAccRec.sum := qryGetMiscPmtItems.FieldByName('splt_sum').AsCurrency;
        pPmtAccRec.clientId := pClientId;


        // -- maksekorralduse valuuta
        pPmtAccRec.pmtItemCurrIdentf := pCurrency;
        pPmtAccRec.pmtItemCurrID := pCurrencyId; // tähendab tuleb võtta jooksev kurss
        pPmtAccRec.pmtItemCurrRate := pCurrRate;



        // raamatupidamiskonto valuuta !!!!
        pDefCurr := trim(qryGetMiscPmtItems.FieldByName('default_currency').AsString);
        if pDefCurr = '' then
          pDefCurr := estbk_globvars.glob_baseCurrency;



        pPmtAccRec.currencyRate := 0;
        pPmtAccRec.currencyIdentf := pDefCurr;
        pPmtAccRec.currencyID := -1; // st tuleb võtta jooksev kurss nimistust !

        // ----
        qryGetMiscPmtItems.Next;
      end;
    finally

      if assigned(pItemBookmark) then
      begin
        qryGetMiscPmtItems.Gotobookmark(pItemBookmark);

        qryGetMiscPmtItems.FreeBookmark(pItemBookmark);
        qryGetMiscPmtItems.EnableControls;
      end;
    end;




    // --- ARVED/TELLIMUSED
    try
      qryGetUserPmtItems.DisableControls;

      pItemBookmark := qryGetUserPmtItems.GetBookmark;
      pFiltstatus := qryGetUserPmtItems.Filtered;
      pFiltOrigStr := qryGetUserPmtItems.Filter;


      // -----------------
      qryGetUserPmtItems.First;
      qryGetUserPmtItems.Filtered := False;


      while not qryGetUserPmtItems.EOF do
      begin

        // -----
        if estbk_utilities.isTrueVal(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString) then
        begin

          // ARVED !!!
          if AnsiUpperCase(qryGetUserPmtItems.FieldByName('litemtype').AsString) = estbk_types.CCommTypeAsBill then
          begin

            // valuuta nimetus PEAB eksisteerima
            pIndex := self.FStCurrInst.IndexOf(qryGetUserPmtItems.FieldByName('currency').AsString);
            assert(pIndex >= 0);



            pNewSum := qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency; // summa, mis reale märgitud !
            pToPaySum := qryGetUserPmtItems.FieldByName('to_pay2').asCurrency;

            pPrepaidSum := qryGetUserPmtItems.FieldByName('prepaidsum').asCurrency;
            pCalcIncomesum := qryGetUserPmtItems.FieldByName('incomesum').asCurrency + pNewSum;  // laekumine



            // kas tekkis ettemaks !
            pCalcPrpBalance := (pToPaySum - pCalcIncomesum - pPrepaidSum);
            if pCalcPrpBalance < 0 then
            begin
              pCalcPrpBalance := abs(pCalcPrpBalance);
              pIncomeSum := pNewSum - pCalcPrpBalance;
            end
            else
            begin
              pCalcPrpBalance := 0;
              pIncomeSum := pNewSum;
            end;


            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // vaatame, mis staatuse arvele märgime
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                    {
                    if pIncomeSum=0 then
                       pPaymentStatus:=estbk_types.CBillPaymentUd
                    else
                    if(pIncomeSum=pToPaySum) or (pCalcPrpBalance>0) then
                       pPaymentStatus:=estbk_types.CBillPaymentOk
                    else
                    if pIncomeSum<pToPaySum then
                       pPaymentStatus:=estbk_types.CBillPaymentPt;
                    }

            // ----------------------------------------------------------------
            // DEEBET
            // -----

            pPmtAccRec := pPmtMgr.addAccEntry(qryGetUserPmtItems.FieldByName('id').AsInteger, __pmtItemAsBill); // !!!


            pAccId := qryGetUserPmtItems.FieldByName('account_id').AsInteger;
            pBillAccId := pAccId;

            //pLineDescr:=self.resolveAccName(pAccId);
            pLineDescr := format(estbk_strmsg.CSSaleBillNr, [qryGetUserPmtItems.FieldByName('nr').AsString]);


            // kontoga seotud valuuta !!!
            pDefCurr := qryGetUserPmtItems.FieldByName('default_currency').AsString;
            if pDefCurr = '' then
              pDefCurr := estbk_globvars.glob_baseCurrency;



            pPmtAccRec.accountId := pAccId;
            pPmtAccRec.recType := estbk_types.CAccRecTypeAsDebit;
            pPmtAccRec.descr := pLineDescr;
            pPmtAccRec.sum := pIncomeSum;
            //pPmtAccRec.pretermPmtStatus:=pPaymentStatus;

            pPmtAccRec.clientId := pClientId;


            pPmtAccRec.pmtItemCurrID := qryGetUserPmtItems.FieldByName('currency_id').AsInteger;
            pPmtAccRec.pmtItemCurrIdentf := qryGetUserPmtItems.FieldByName('currency').AsString;

            // 28.08.2010 Ingmar; viga, eek puhul edastati 0 kurss !!
            if pPmtAccRec.pmtItemCurrIdentf = estbk_globvars.glob_baseCurrency then
              pPmtAccRec.pmtItemCurrRate := 1.00
            else
              pPmtAccRec.pmtItemCurrRate := qryGetUserPmtItems.FieldByName('currrate').AsCurrency;

            pPmtAccRec.currencyRate := 0;
            pPmtAccRec.currencyIdentf := pDefCurr;
            pPmtAccRec.currencyID := -1; // st tuleb võtta jooksev kurss nimistust !


            // nii kontrollime ka ettemaksu üle !
            // ARVETE ETTEMAKS; hoiame ainult baasvaluutas ?!?!?!
            // mingi ettemaks jäi üles ?!?



            if pCalcPrpBalance > 0 then
            begin

              pPmtAccRec := pPmtMgr.addAccEntry(qryGetUserPmtItems.FieldByName('id').AsInteger, __pmtItemAsBill); // !!!
              pPmtAccRec.pmtItemCurrID := qryGetUserPmtItems.FieldByName('currency_id').AsInteger;
              pPmtAccRec.pmtItemCurrIdentf := qryGetUserPmtItems.FieldByName('currency').AsString;

              if pPmtAccRec.pmtItemCurrIdentf = estbk_globvars.glob_baseCurrency then
                pPmtAccRec.pmtItemCurrRate := 1.00
              else
                pPmtAccRec.pmtItemCurrRate := qryGetUserPmtItems.FieldByName('currrate').AsCurrency;


              pAccId := pBillAccId;
              self.resolveAccName(pAccId, pAccountCurr);

                          {
                          // see oli ennem !
                          // ---- NB NB NB !!!! tuleb vaadata, hetkel on hankija ettemaksuga seotud
                          // kui tasumisel peaks müügiarve tulema erand, siis tuleks kasutada kliendi kontot !!!!
                          pAccId:=dmodule.sysAccountId[_accSupplPrePayment];
                          self.resolveAccName(pAccId,pAccountCurr);
                          }
              // --
              pLineDescr := format(estbk_strmsg.CSSaleBillNr, [qryGetUserPmtItems.FieldByName('nr').AsString]);


              pPmtAccRec.currencyRate := 0;
              pPmtAccRec.currencyIdentf := pAccountCurr;
              pPmtAccRec.currencyID := -1; // st tuleb võtta jooksev kurss nimistust !
              // ---

              pPmtAccRec.accountId := pAccId;
              pPmtAccRec.recType := estbk_types.CAccRecTypeAsDebit;
              pPmtAccRec.descr := pLineDescr;

              pPmtAccRec.sum := pCalcPrpBalance;
              //pPmtAccRec.pretermPmtStatus:=pPaymentStatus;

              pPmtAccRec.clientId := pClientId;
              pPmtAccRec.isPrepayment := True;

            end;

          end
          else
          // tellimus on alati ettemaks !!!!!!
          if AnsiUpperCase(qryGetUserPmtItems.FieldByName('litemtype').AsString) = estbk_types.CCommTypeAsOrder then
          begin

            pNewSum := qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency; // sum

            // DEEBET
            // baasvaluuta
            // -----

            pPmtAccRec := pPmtMgr.addAccEntry(qryGetUserPmtItems.FieldByName('id').AsInteger, __pmtItemAsOrder); // !!!

            pAccId := _ac.sysAccountId[_accSupplPrePayment];
            // vaja teada konto valuutat !
            self.resolveAccName(pAccId, pAccountCurr);


            pLineDescr := format(estbk_strmsg.CSOrderNr, [qryGetUserPmtItems.FieldByName('nr').AsString]);
            // ----
            pPmtAccRec.accountId := pAccId;
            pPmtAccRec.recType := estbk_types.CAccRecTypeAsDebit;
            pPmtAccRec.descr := pLineDescr;
            pPmtAccRec.sum := pNewSum;
            pPmtAccRec.isPrepayment := True;

            pPmtAccRec.clientId := pClientId;


            pToPaySum := qryGetUserPmtItems.FieldByName('to_pay2').asCurrency;
                    {
                    if pNewSum>=pToPaySum then
                       pPaymentStatus:=estbk_types.COrderPaymentOk
                    else
                    if pNewSum>0 then
                       pPaymentStatus:=estbk_types.COrderPaymentPt
                    else
                       pPaymentStatus:=estbk_types.COrderPaymentUd;}
            //pPmtAccRec.pretermPmtStatus:=pPaymentStatus;


            pPmtAccRec.pmtItemCurrID := qryGetUserPmtItems.FieldByName('currency_id').AsInteger;
            pPmtAccRec.pmtItemCurrIdentf := qryGetUserPmtItems.FieldByName('currency').AsString;
            pPmtAccRec.pmtItemCurrRate := qryGetUserPmtItems.FieldByName('currrate').AsCurrency;


            pPmtAccRec.currencyRate := 0;
            pPmtAccRec.currencyIdentf := pAccountCurr;
            pPmtAccRec.currencyID := -1; // st tuleb võtta jooksev kurss nimistust !
            // ---
          end;
        end;


        qryGetUserPmtItems.Next;
      end;

    finally
      // --
      if assigned(pItemBookmark) then
      begin
        qryGetUserPmtItems.Filter := pFiltOrigStr;
        qryGetUserPmtItems.Filtered := pfiltstatus;

        qryGetUserPmtItems.Gotobookmark(pItemBookmark);

        qryGetUserPmtItems.FreeBookmark(pItemBookmark);
        qryGetUserPmtItems.EnableControls;
      end;
    end;


    pBankCharge := qryPmtOrder.FieldByName('trcost').AsCurrency;



    // D pangakulud  6kr
    if pBankCharge > 0 then
    begin
      pPmtAccRec := pPmtMgr.addAccEntry(-1, __pmtItemAsUnknown); // !!

      pAccId := _ac.sysAccountId[_accBankCharges];
      pLineDescr := self.resolveAccName(pAccId, pAccountCurr);


      pPmtAccRec.accountId := pAccId;
      pPmtAccRec.recType := estbk_types.CAccRecTypeAsDebit;
      pPmtAccRec.descr := pLineDescr;

      pPmtAccRec.pmtItemCurrID := -1;
      pPmtAccRec.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
      pPmtAccRec.pmtItemCurrRate := 1.00;



      pPmtAccRec.sum := pBankCharge;
      pPmtAccRec.clientId := 0; // -- !!

      pPmtAccRec.currencyIdentf := estbk_globvars.glob_baseCurrency;
      pPmtAccRec.currencyID := 0;
      pPmtAccRec.currencyRate := 1.00;
    end;




    // ----------------------------------------------------------------
    // KREEDIT !!! meie pangakonto, kus summa maha võtta !
    // ----------------------------------------------------------------
    // K arveldusarve hansapangas EEK 106kr

    pPmtAccRec := pPmtMgr.addAccEntry(-1, __pmtItemAsUnknown); // !!

    pAccId := qryGetCBanksAccounts.FieldByName('id').AsInteger;
    pLineDescr := self.resolveAccName(pAccId, pAccountCurr);

    // -- kande kirje klass
    pPmtAccRec.accountId := pAccId; // !!!!!
    pPmtAccRec.recType := estbk_types.CAccRecTypeAsCredit;
    pPmtAccRec.descr := pLineDescr;




    pPmtAccRec.sum := qryPmtOrder.FieldByName('sumtotal').asCurrency;



    // !!!
    // 28.08.2010 Ingmar peame ka pangakulu juurde panema, aga see baasvaluutas ?!?
    pBankCharge := qryPmtOrder.FieldByName('trcost').asCurrency;
    pBankCharge := roundto(pBankCharge / pCurrRate, Z2);


    pPmtAccRec.sum := pPmtAccRec.sum + pBankCharge;


    // ---
    pPmtAccRec.clientId := clientId;
    pPmtAccRec.pmtItemCurrID := pCurrencyId;
    pPmtAccRec.pmtItemCurrIdentf := pCurrency;
    pPmtAccRec.pmtItemCurrRate := pCurrRate;

    pPmtAccRec.currencyRate := 0;
    pPmtAccRec.currencyIdentf := pAccountCurr;
    pPmtAccRec.currencyID := -1; // st tuleb võtta jooksev kurss nimistust !


    pPmtAccRec.isFinalAggrLine := True; // !!!
    // ----------------------------------------------------------------
    // ja lõpuks koostame reaalsed kanded andmebaasi !!!!!!!!!!!!!!!!!
    // ----------------------------------------------------------------
           {$ifdef debugmode}
    pPmtMgr.writeEntryLog('C:\Deploy\debug\payment_accentrys.txt');
           {$endif}
    pPmtMgr.doSaveAccEntrys;

  finally
    FreeAndNil(pPmtMgr); // -->
  end;
end;


function TframePaymentOrder.verifyMiscLines: boolean;
var
  pBookMark: TBookmark;
  pLineOk: boolean;
begin
  try
    Result := False;
    // --
    if qryGetMiscPmtItems.State in [dsEdit, dsInsert] then
      qryGetMiscPmtItems.Post;


    // --
    pbookMark := qryGetMiscPmtItems.GetBookmark;
    qryGetMiscPmtItems.DisableControls;
    qryGetMiscPmtItems.First;
    while not qryGetMiscPmtItems.EOF do
    begin
      // kontrollime esmalt, kas pole tegemist lihtsalt ühe tühja reaga...summat ka asstringiga kontrollida,
      // siis ei pea isnull mässama
      pLineOk := (trim(qryGetMiscPmtItems.FieldByName('item_descr').AsString) <> '') or
        (trim(qryGetMiscPmtItems.FieldByName('splt_sum').AsString) <> '') or
        (trim(qryGetMiscPmtItems.FieldByName('account_coding').AsString) <> '');
      if pLineOk then
      begin
        pLineOk := (trim(qryGetMiscPmtItems.FieldByName('item_descr').AsString) <> '') and
          (trim(qryGetMiscPmtItems.FieldByName('splt_sum').AsString) <> '') and
          (trim(qryGetMiscPmtItems.FieldByName('account_coding').AsString) <> '');
        if not pLineOk then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEPmtMiscLineIncomplete, mtError, [mbOK], 0);
          Exit;
        end;

      end;
      qryGetMiscPmtItems.Next;
    end;

    // ---
    Result := True;
  finally
    if assigned(pbookMark) then
    begin
      qryGetMiscPmtItems.GotoBookmark(pbookMark);
      qryGetMiscPmtItems.EnableControls;
      qryGetMiscPmtItems.FreeBookmark(pbookMark);

      if not pLineOk and miscSumDbGrid.CanFocus then
        miscSumDbGrid.SetFocus;
    end;
    // ---
  end;
end;


function TframePaymentOrder.savePaymentOrderData: boolean;

const
  CPmtCreateNewAccRec = 1;
  CPmtCancelAccRecEntrys = 2;
  CPmtCreateNewAccEntrys = 4;
  CPmtUpdateAccRec = 8;

var
  pAccPeriodID: integer;
  pMainAccRecID: integer;
  // lipud, kuidas kandekirjet muudame uuendame
  pAccRecordBehavior: integer;
  // ---
  pDocId: int64;
  pAccDesc: AStr;
  pAccNr: AStr;
  pSQL: AStr;
  // ---
  pOnlyDocNrDateChanged: boolean;
  pVerifBalance: double;
  pTempCalc: double;
  pTrackChanges: TCollection;

begin
  Result := False;
  lazFocusFix.Enabled := False;
  self.FAccounts.Visible := False;


  // --
  pTempCalc := 0;


  // -- et arvutaks total sumi ära !!! lõpetame kõik evendid !
  if (qryGetMiscPmtItems.State in CLVRecStatus) then
    qryGetMiscPmtItems.Post;

  if (qryGetUserPmtItems.State in CLVRecStatus) then
    qryGetUserPmtItems.Post;

  // 09.09.2013 love
  if (qryPmtOrder.State in CLVRecStatus) then
    qryPmtOrder.Post;


  // 11.04.2010 Ingmar
  // kontrollime ka vaikimisi ridade sisu
  if not self.verifyMiscLines then
  begin
    if miscSumDbGrid.CanFocus then
      miscSumDbGrid.SetFocus;
    Exit;
  end;


  if self.clientId < 1 then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEClientNotFound, mtError, [mbOK], 0);
    if edtrecpname.canFocus then
      edtrecpname.SetFocus;
    Exit;
  end;


  if trim(pmtDate.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEEmptyDate, mtError, [mbOK], 0);
    if pmtDate.canFocus then
      pmtDate.SetFocus;
    // ---
    Exit;
  end;

  if pmtDate.Date > date then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEDateInFuture, mtError, [mbOK], 0);
    if pmtDate.canFocus then
      pmtDate.SetFocus;
    // ---
    Exit;
  end;

  if trim(dbLookupComboCredit.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEAccountNotChoosen, mtError, [mbOK], 0);
    if dbLookupComboCredit.canFocus then
      dbLookupComboCredit.SetFocus;
    // ---
    Exit;
  end;


  if trim(dbEdtbankAcc.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEBankAccountIsMissing, mtError, [mbOK], 0);
    if dbEdtbankAcc.canFocus then
      dbEdtbankAcc.SetFocus;
    // ---
    Exit;
  end;


  if trim(dbEdtRecvAcc.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEBankAccountIsMissing, mtError, [mbOK], 0);
    if dbEdtRecvAcc.canFocus then
      dbEdtRecvAcc.SetFocus;
    // ---
    Exit;
  end;

  if trim(edtrecpname.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEPmtRecipientsNameIsMissing, mtError, [mbOK], 0);
    if edtrecpname.canFocus then
      edtrecpname.SetFocus;
    // ---
    Exit;
  end;

  // 04.03.2016 Ingmar; siin oli viga, kui taheti kinnitatud linnukest maha võtta, ei lubanud seda teha, kui polnud selgitust !
  if chkboxConfPmtDone.Checked and (trim(qryPmtOrder.FieldByName('descr').AsString) = '') then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEPmtDescrIsMissing, mtError, [mbOK], 0);
    if dbExplMemo.canFocus then
      dbExplMemo.SetFocus;
    // ---
    Exit;
  end;

  // TODO: tulevikus tee normaalne dateedit komponent; kuupäev paika ka datasetis !
  // ---
  if not (qryPmtOrder.state in CLVRecStatus) then
    qryPmtOrder.Edit;

  qryPmtOrder.FieldByName('payment_date').AsDateTime := pmtDate.date;
  if chkboxConfPmtDone.Checked then
    qryPmtOrder.FieldByName('status').AsString := estbk_types.CPaymentRecStatusClosed
  else
    qryPmtOrder.FieldByName('status').AsString := estbk_types.CPaymentRecStatusOpen;
  //qryPmtOrder.FieldByName('payment_confirmed').AsString:=estbk_types.SCFalseTrue[chkboxConfPmtDone.checked];
  qryPmtOrder.FieldByName('currency').AsString := cmbCurrency.Text;
  qryPmtOrder.FieldByName('currency_drate_ovr').AsFloat :=
    TCurrencyObjType(self.cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).currVal;



  // -------
  // otsime raamatupidamisperioodi pearaamatu kande jaoks !!!! Antud funktsioon ise nö kuvab vaikimisi teateid !
  pAccRecordBehavior := 0;

  pAccPeriodID := estbk_clientdatamodule.dmodule.getAccoutingPerId(pmtDate.date);
  if pAccPeriodID < 1 then
    Exit;




  // salvestame andmed
  with estbk_clientdatamodule.dmodule do
    try

      primConnection.StartTransaction;

      // pearaamatu baaskirje ID !!!!
      pMainAccRecID := self.FCurrPmtAccBRecId;




      // 11.03.2011 Ingmar; kannete loogika natuke muutus; kui vajutatakse checkboxis kinnita, siis luuakse koheselt kanded
      // peamise kirje võib luua ! kui sinna alla ei pane lihtsalt kandeid !!!!!
      if self.FNewRecord then
      begin
        pAccRecordBehavior := pAccRecordBehavior or CPmtCreateNewAccRec; // luuakse kande aluskirje !
        if chkboxConfPmtDone.Checked then
          pAccRecordBehavior := pAccRecordBehavior or CPmtCreateNewAccEntrys;
      end
      else
      // maksekorraldus kinnitati, tekitame kanded ning märgime arved laekunuks jne
      if not self.FCurrPmtOrderConfirmed and chkboxConfPmtDone.Checked then
      begin
        pAccRecordBehavior := pAccRecordBehavior or CPmtCreateNewAccEntrys; // luuakse kanded
      end
      else
      // ---- maksekorraldus oli eelnevalt kinnitatud, aga seoti lahti...järelikult,
      // - kõik kanded annuleerida
      // - arvetel võtta maha laekumise tunnused, samuti ettemaks
      if self.FCurrPmtOrderConfirmed and not chkboxConfPmtDone.Checked then
      begin
        pAccRecordBehavior := pAccRecordBehavior or CPmtCancelAccRecEntrys; // tühistatakse kanded
      end;


      // --
      pOnlyDocNrDateChanged := False;
      if not ((pAccRecordBehavior and CPmtCreateNewAccRec) = CPmtCreateNewAccRec) and self.detectAccDataChange(pOnlyDocNrDateChanged) then
      begin

        pAccRecordBehavior := pAccRecordBehavior or CPmtUpdateAccRec;
        // ---
        if not pOnlyDocNrDateChanged then
        begin

          // 09.04.2010 Ingmar; ainult kinnitatud korralduste puhul !
          // tühistame kanderead !
          if self.FCurrPmtOrderConfirmed then
            pAccRecordBehavior := pAccRecordBehavior or CPmtCancelAccRecEntrys;
          // pAccRecordBehavior:=pAccRecordBehavior or CPmtCreateNewAccEntrys;
        end; // ---
      end;




      // KANDE ÜLDINE KIRJELDUS
      pAccDesc := format(estbk_strmsg.CSPaymentOrder, [edtOrderNr.Text]);




      // ---- jätame võimaluse juhtida inserte;
      if (pAccRecordBehavior and CPmtCreateNewAccRec) = CPmtCreateNewAccRec then
      begin
        self.FCurrPmtAccBRecId := 0;
        pMainAccRecID := 0;
        pDocId := 0;
        // 19.07.2011 Ingmar ; 01.03.2012 Ingmar numeraatorite reform
        pAccNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', pmtDate.Date,
          False, estbk_types.CAccPmt_rec_nr);

        // -- dmodule funktsioon !
        if not createNewGenLedgerMainRec(pAccPeriodID,  // rp. period
          pmtDate.Date,  // kande kuupäev
          pAccDesc,      // kirjeldus pearaamatu päises
          estbk_types._dsPaymentDocId, dbEdtDocNr.Text, // dokumendi nr
          estbk_types.CAddRecIdentAsPaymentOrder, pMainAccRecID,
          // mingi hetk ei saanud enam klassi propertyt anda var parameetrisse !!
          pDocId, pAccNr) then
          abort;

        // ---
        self.FCurrPmtAccBRecId := pMainAccRecID;

        // uuesti aktiivseks !
        if not (qryPmtOrder.State in CLVRecStatus) then
          qryPmtOrder.Edit;


        // --
        qryPmtOrder.FieldByName('accounting_register_id').AsInteger := pMainAccRecID;
        qryPmtOrder.FieldByName('payment_nr').AsString := edtOrderNr.Text;
        qryPmtOrder.FieldByName('client_id').AsInteger := self.clientId;

      end
      else
      if (pAccRecordBehavior and CPmtUpdateAccRec) = CPmtUpdateAccRec then
      begin

        // -- dmodule funktsioon
        if not updateGenLedgerMainRec(self.FCurrPmtAccBRecId, // kirje mida uuendame
          pmtDate.Date,   // kande kuupäev
          pAccDesc,       // pearaamatu kirjeldus
          dbEdtDocNr.Text // dokumendi nr
          ) then
          abort;

      end;



      // kui vaja, siis tühistame kõik kande kirjed !
      if (pAccRecordBehavior and CPmtCancelAccRecEntrys) = CPmtCancelAccRecEntrys then
      begin

        // 09.04.2010 Ingmar; ainult kinnitatud korralduste puhul !
        if self.FCurrPmtOrderConfirmed then
        begin
          self.cancelPmtOrderAccRecs(pMainAccRecID);
        end; // ----------
      end;


      // --
      if (pAccRecordBehavior and CPmtCreateNewAccEntrys) = CPmtCreateNewAccEntrys then
      begin

        // et oleks ikka korrektne lõplik summa !!!! kaasa arvatud kursivahe !!!!
        self.changePmtOrderSumAndDescr();
        // -----------------------

        self.createAccountingRecords(self.FCurrPmtAccBRecId, self.clientId);

      end; // ---




      // --------------------------------
      // tavaline salvestus...läbi cache...

      qryPmtOrder.ApplyUpdates;




      // paneme uue loodud kirje ID ka paika !
      if self.FNewRecord then
        self.FCurrPmtOrderID := qryPmtOrder.FieldByName('id').AsInteger; // qryPmtOrderSeq.GetCurrentValue;



      //qryGetMiscPmtItemsUptInst.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdatePmtOrderDataStatus);
      //qryGetMiscPmtItemsUptInst.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertPmtOrderData2);

      // kas A) kõikidele kirjetele käsitsi omistada pmtorderId
      //     B) modify SQL kavalalt ära muuta


      pSQL := stringreplace(estbk_sqlclientcollection._SQLInsertPaymentData2, ':payment_id', IntToStr(self.FCurrPmtOrderID), []);
      //pSQL:=stringreplace(estbk_sqlclientcollection._SQLUpdatePmtOrderDataStatus,':payment_order_id',inttostr(self.FCurrPmtOrderID),[]);



      qryGetMiscPmtItemsUptInst.InsertSQL.Clear;
      qryGetMiscPmtItemsUptInst.InsertSQL.add(pSQL);
      // --


      // debug
                    {
                     qryGetUserPmtItems.ShowRecordTypes:=[usModified];
                     showmessage('modified '+inttostr(qryGetMiscPmtItems.RecordCount));
                     qryGetUserPmtItems.ShowRecordTypes:=[usInserted];
                     showmessage('inserted '+inttostr(qryGetMiscPmtItems.RecordCount));
                     }

      try
        // -- vastavalt reziimile seome või tühistame maksekorraldusega seotud arved/tellimused
        // valitud elemendid (arved/tellimused) ja nende "jaotatud" summad !!!!
        pTrackChanges := TCollection.Create(TTrackItemChanges); // reserveeritud
        self.managePaymentOrderItems(self.FCurrPmtOrderID, pTrackChanges);
      finally
        FreeAndNil(pTrackChanges);
      end;



      // -------------------------------------------------------
      // käsitsi koostatud read !
      // -------------------------------------------------------

      qryGetMiscPmtItems.ApplyUpdates;


      // ---
      primConnection.Commit;


      // 19.05.2011 Ingmar
      // pAccNr
      dmodule.markNumeratorValAsUsed(PtrUInt(self), CPMOrder_doc_nr, edtOrderNr.Text, pmtDate.Date);

      // 14.05.2012 Ingmar; unustasin ära numeraatori vabastamast
      // if (trim(pAccNr)<>'') and (chkboxConfPmtDone.Checked) then
      // 05.07.2012 Ingmar; võib õhku rippuma jääda !
      dmodule.markNumeratorValAsUsed(PtrUInt(self), estbk_types.CAccPmt_rec_nr, pAccNr, pmtDate.Date);


      qryPmtOrder.CommitUpdates;
      qryGetMiscPmtItems.CommitUpdates;



      //self.FLastDAccountId:=qryGetAccounts.fieldByname('id').asInteger;
      self.FLastCAccountId := qryGetCBanksAccounts.FieldByName('id').AsInteger;
      self.FCurrPmtOrderConfirmed := chkboxConfPmtDone.Checked;




      Result := True;

      if btnNewPayment.CanFocus then
        btnNewPayment.SetFocus;




      // laeme maksekorraldusega seotud andmed uuesti, et vältida probleemi salvestamisel !!! just makse kinnitamisel !
      // ala; salvestatakse, checkbox valitud, uuesti salvestatakse
      if self.clientId > 0 then
        self.qryPsPaymentData(self.FCurrPmtOrderID)
      else
        self.qryPsPaymentData(-1);
      self.qryPsPaymentMiscSum(self.FCurrPmtOrderID);

      // nuppude staatus ära muuta
      btnSave.Enabled := False;
      btnCancel.Enabled := False;
      btnNewPayment.Enabled := True;

      chkboxConfPmtDone.Enabled := True;
      lblVerified.Enabled := True;

      estbk_utilities.changeWCtrlReadOnlyStatus(grpPmtOrder, chkboxConfPmtDone.Checked);


      // taasta õige insert !
      if self.FNewRecord then
      begin
        qryGetMiscPmtItemsUptInst.InsertSQL.Clear;
        qryGetMiscPmtItemsUptInst.InsertSQL.add(estbk_sqlclientcollection._SQLInsertPaymentData2);
      end;

      // ---
      self.FNewRecord := False;
      cmbCurrency.Enabled := not chkboxConfPmtDone.Checked;
      // ---
      btnOpenAccEntry.Enabled := (self.FCurrPmtAccBRecId > 0) and (chkboxConfPmtDone.Checked);



      if FAccounts.Visible then
        FAccounts.Visible := False;

      // 31.08.2010 Ingmar
      self.FPPrevClientID := self.clientId;

      if assigned(self.onFrameDataEvent) then
        self.onFrameDataEvent(self,
          estbk_types.__framePaymentChanged,
          self.FCurrPmtOrderID,
          nil);

    except
      on  e: Exception do
      begin
        if primConnection.InTransaction then
          try
            primConnection.Rollback;
          except
          end;


        if not (e is eabort) then
          Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
      end;
    end;
end;


procedure TframePaymentOrder.btnSaveClick(Sender: TObject);
begin
  self.savePaymentOrderData;
end;


procedure TframePaymentOrder.chkboxConfPmtDoneChange(Sender: TObject);
var
  pDoSaveData: boolean;

begin
  // ehk kinnitus eemaldati..!
  with TCheckBox(Sender) do
    if not self.FSkipOnChangeEvent and Focused then
      try


        Tag := 0;
        pDoSaveData := False;
        self.FSkipOnChangeEvent := True;
        // --

        if not self.FNewRecord then
        begin

          if self.FCurrPmtOrderConfirmed then
          begin

            // küsime ikka üle, kas tõesti kinnitus maha !
            if not Checked then
            begin

              if Dialogs.messageDlg(estbk_strmsg.SConfReopenPayment, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
              begin
                estbk_utilities.changeWCtrlReadOnlyStatus(grpPmtOrder, Checked);
                pDoSaveData := True;
              end
              else
              begin // tänan me ei soovi avada !
                Checked := not Checked;
                pDoSaveData := False;
              end;

            end
            else
            begin
              Checked := not Checked; // vana väärtus tagasi !!!
            end; // ---
          end
          else
          begin
            pDoSaveData := Checked;
          end;

        end
        else
          // --- uus kirje...
          pDoSaveData := Checked;


        // 11.03.2011 Ingmar
        if pDoSaveData then
          if self.savePaymentOrderData() then
          begin
            self.qryPsPaymentData(self.FCurrPmtOrderID);
          end
          else
            Checked := not Checked;
        // ---
      finally
        FSkipOnChangeEvent := False;
        Tag := -1;
      end;
end;



procedure TframePaymentOrder.cmbCurrencyChange(Sender: TObject);
begin
  if TComboBox(Sender).Focused then
    self.refreshUICurrList(pmtDate.date);

end;


procedure TframePaymentOrder.dbedtBillSumKeyPress(Sender: TObject; var Key: char);
begin
  case key of
    ^V, '-': key := #0;
    #13:
    begin
      SelectNext(Sender as twincontrol, True, True);
      key := #0;
    end;
    else
      estbk_utilities.edit_verifyNumericEntry(Sender as TCustomEdit, key, True);
  end;
end;

procedure TframePaymentOrder.dbExplMemoKeyPress(Sender: TObject; var Key: char);
begin
  // 11.03.2011 Ingmar; no ikka ei luba kirjeldada küll, kui kinnitatud !
  if chkboxConfPmtDone.Checked then
    key := #0;
end;

procedure TframePaymentOrder.dbGridAllItemsCellClick(Column: TColumn);
var
  pTrigEdt: boolean;
  pbStatus: boolean;
begin
  // 30.08.2011 Ingmar; bugfix qryGetUserPmtItems.eof asendatud recordcount lahtriga, sest muidu ei saanud viimast arvet selekteerida
  if self.chkboxConfPmtDone.Checked or not assigned(dbGridAllItems.DataSource) or (qryGetUserPmtItems.RecordCount < 1) then
    exit;


  // --
  if not self.FSkipCellClickEvent and assigned(dbGridAllItems) and assigned(dbGridAllItems.SelectedColumn) and
    (dbGridAllItems.SelectedColumn.Index = CCol_itemChecked) and assigned(column) then
    try
      // uus lazarus tõi jälle põnevaid asju; ntx event tuli mitu korda !
      self.FSkipCellClickEvent := True;

      pTrigEdt := not (qryGetUserPmtItems.State in [dsEdit, dsInsert]);
      // --
      if pTrigEdt then
        qryGetUserPmtItems.Edit;


      // 18.07.2010 ingmar
      pbStatus := not (AnsiUpperCase(copy(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString, 1, 1)) = 'T');
      // ---
      qryGetUserPmtItems.FieldByName('lsitemhlp').AsString := estbk_types.SCFalseTrue[pbStatus];




      //if estbk_utilities.isTrueVal(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString) then
      if pbStatus then
        qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency := qryGetUserPmtItems.FieldByName('to_pay').AsCurrency
      else
        qryGetUserPmtItems.FieldByName('splt_sum').Value := null;
      dbGridAllItems.Repaint;

    finally
      // --
      if pTrigEdt then
        try
          qryGetUserPmtItems.Post;
        except
        end;
      // ---
      self.FSkipCellClickEvent := False;
    end;
end;

procedure TframePaymentOrder.dbGridAllItemsColEnter(Sender: TObject);
begin
  // --
end;

procedure TframePaymentOrder.dbGridAllItemsColExit(Sender: TObject);
begin
  with TDBGrid(Sender) do
    if assigned(SelectedColumn) and (SelectedColumn.Index = CCol_spltSum) and DataSource.DataSet.Active and
      (DataSource.DataSet.State in [dsEdit, dsInsert]) then
      DataSource.DataSet.Post;
end;


// kõik on tore; aga columni display format ei tööta !!
procedure TframePaymentOrder.dbGridAllItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
var
  pData: AStr;
  pts: TTextStyle;
  pBitmap: Tbitmap;
begin

  with TDbGrid(Sender) do
    if assigned(DataSource) and not DataSource.DataSet.IsEmpty and assigned(Column.Field) then
    begin
      //self.FAccounts.Visible:=false; // !
      Canvas.FillRect(Rect);
      pts := Canvas.TextStyle;
      pts.Alignment := taLeftJustify;
      Canvas.TextStyle := pts;
      Canvas.Font.Color := clWindowText;

      if (gdSelected in State) then
      begin
        Canvas.Brush.Color := clBackGround;
        //Canvas.Font.Color  := clWhite;
      end
      else
      begin
        Canvas.Brush.Color := clWindow; // MyFavGreen; //clInfoBk; //;
        //Canvas.Font.Color := clBlack;
      end;


      if Column.Index = CCol_currency then
      begin
        Canvas.TextStyle := pts;


        pData := Column.Field.AsString;
        if pData = '' then
          pData := estbk_globvars.glob_baseCurrency;

        // ---
        //pData:=pData+' '+format(CCurrentAmFmt4,[pCurrrate]);
        Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, trim(pData), Canvas.TextStyle);
      end
      else
      if Column.Index in [CCol_sumtoPay, CCol_toPay, CCol_incomings, CCol_spltSum] then
      begin
        //Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,format(estbk_types.CCurrentMoneyFmt2,[Column.Field.asFloat]),Canvas.TextStyle);
        pts.Alignment := taRightJustify;
        Canvas.TextStyle := pts;
        pData := trim(format(estbk_types.CCurrentMoneyFmt2, [Column.Field.AsCurrency]));
        Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, pData + #32, Canvas.TextStyle);
      end
      else
      if Column.Index = CCol_itemChecked then
        try
          pBitmap := TBitmap.Create;
          Canvas.FillRect(Rect);

          if AnsiUpperCase(copy(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString, 1, 1)) = 'T' then
            dmodule.sharedImages.GetBitmap(img_indxItemChecked, pBitmap)
          else
            dmodule.sharedImages.GetBitmap(img_indxItemUnChecked, pBitmap);
          Canvas.Draw(Rect.Left + 5, Rect.Top + 2, pBitmap);
        finally
          FreeAndNil(pBitmap);
        end
      else
        DefaultDrawColumnCell(Rect, DataCol, Column, State);
      // inherited DrawColumnCell(Rect, DataCol, Column, State);
    end;
end;

procedure TframePaymentOrder.dbGridAllItemsEnter(Sender: TObject);
begin
  // --
end;



procedure TframePaymentOrder.dbGridAllItemsExit(Sender: TObject);
begin
  with TDbGrid(Sender) do
    if assigned(Datasource) and (Datasource.DataSet.state in [dsEdit, dsInsert]) then
    begin
      Datasource.DataSet.Post;
      self.changePmtOrderSumAndDescr();
    end;

  // 16.06.2011 Ingmar
  if assigned(self.FLiveEditor) and self.FLiveEditor.Visible and not (self.FLiveEditor is TRxDBLookupCombo) then
    self.FLiveEditor.Visible := False;
end;

procedure TframePaymentOrder.dbGridAllItemsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // ---
end;


procedure TframePaymentOrder.dbGridAllItemsKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else
  if (Sender = dbGridAllItems) and assigned(dbGridAllItems.SelectedColumn) then
  begin

    // kui summat muudad peaks olema ka midagi valitud !!!
    case dbGridAllItems.SelectedColumn.Index of
      CCol_spltSum:
      begin
        if not estbk_utilities.isTrueVal(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString) then
          key := #0
        else
          estbk_utilities.grid_verifyNumericEntry(TDbgrid(Sender), CCol_spltSum, key, True);
      end;

      CCol_itemChecked:
        if Key = #32 then
        begin
          self.dbGridAllItemsCellClick(dbGridAllItems.SelectedColumn);
          key := #0;
        end;
      else
        key := #0;
    end;
    // ----
  end;
end;

procedure TframePaymentOrder.dbGridAllItemsPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin

  TDbGrid(Sender).Canvas.Font.Color := clWindowText;
  if (gdSelected in AState) then
  begin
    TDbGrid(Sender).Canvas.Brush.Color := clHighlight;
    TDbGrid(Sender).Canvas.Font.Color := clWindow;
  end
  else
  if DataCol <= CCol_currency then
  begin
    if TDbGrid(Sender).DataSource.DataSet.FieldByName('litemtype').AsString = estbk_types.CCommTypeAsOrder then
      TDbGrid(Sender).Canvas.Brush.Color := glob_userSettings.uvc_colors[uvc_itemTypeAsOrderColor]
    else
      TDbGrid(Sender).Canvas.Brush.Color := glob_userSettings.uvc_colors[uvc_itemTypeAsBillColor];
  end
  else
  begin
    TDbGrid(Sender).Canvas.Brush.Color := clWindow;
  end;
end;

procedure TframePaymentOrder.dbGridAllItemsSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
begin
  if assigned(Editor) then
    Editor.Font.Color := clWindowText;

  if Editor is TStringCellEditor then
  begin
    if Column.Index = CCol_spltSum then
      TStringCellEditor(Editor).Alignment := taRightJustify
    else
      TStringCellEditor(Editor).Alignment := taLeftJustify;
  end;

  // 16.06.2011 Ingmar
  self.FLiveEditor := Editor;
end;




procedure TframePaymentOrder.dbGridAllItemsUserCheckboxBitmap(Sender: TObject; const CheckedState: TCheckboxState; var ABitmap: TBitmap);
begin
  // --
end;

procedure TframePaymentOrder.dbLookupComboCreditChange(Sender: TObject);
begin
  // --
end;

procedure TframePaymentOrder.btnCancelClick(Sender: TObject);
begin
  lazFocusFix.Enabled := False;

  self.FDataNotSaved := False;
  self.FNewRecord := False;
  self.FMiscLinesChanged := False;
  self.FDataNotSaved := False;


  TButton(Sender).Enabled := False;
  btnSave.Enabled := False;
  btnNewPayment.Enabled := True;
  btnOpenAccEntry.Enabled := (self.FCurrPmtAccBRecId > 0);

  // --
  try

    qryPmtOrder.CancelUpdates;
    qryGetUserPmtItems.CancelUpdates;

    //if self.FCurrentPmtOrderID;
    self.ctrlsVisState(not qryPmtOrder.EOF);


    // ----
    // -- tühi laadimine !
    if qryPmtOrder.EOF then
    begin
      self.qryOpenPmt(0);
      //self.qryPsPaymentData(0);
      qryGetUserPmtItems.Close;
      qryGetMiscPmtItems.Close;
      self.performCleanup;
      edtOrderNr.Text := '';
    end;


    // ----
    estbk_utilities.changeWCtrlReadOnlyStatus(grpPmtOrder, pos(estbk_types.CPaymentRecStatusClosed, qryPmtOrder.FieldByName('status').AsString) > 0);
    //estbk_utilities.changeWCtrlReadOnlyStatus(pPanel,estbk_utilities.isTrueVal(qryPmtOrder.FieldByname('payment_confirmed').asString));
    chkboxConfPmtDone.Enabled := not qryPmtOrder.EOF;
    lblVerified.Enabled := not qryPmtOrder.EOF;

  except
  end; // --
end;

procedure TframePaymentOrder.btnCloseClick(Sender: TObject);
begin
  if assigned(self.onFrameKillSignal) then
    self.onFrameKillSignal(self);
end;

// nö kuvab hankijatele maksmata arved; avatud tellimused
procedure TframePaymentOrder.qryPsPaymentData(const ppaymentID: integer);
begin
  with qryGetUserPmtItems, SQL do
  begin
    Close;
    Clear;
    add(estbk_sqlclientcollection._SQLGetDataForPayment(self.clientId, ppaymentID, estbk_globvars.glob_company_id));
    Open;
    if RecordCount < 1 then
      dbGridAllItems.DataSource := nil
    else
      dbGridAllItems.DataSource := qryGetPmtItemsDs;
  end;
end;


procedure TframePaymentOrder.qryPsPaymentMiscSum(const ppaymentID: integer);
begin
  with qryGetMiscPmtItems, SQL do
  begin
    Close;
    Clear;
    add(estbk_sqlclientcollection._SQLGetPaymentDataMiscSum(ppaymentID));
    Open;
  end;
end;

// 01.03.2012 Ingmar
function TframePaymentOrder.getPaymentOrderNr(const pDate: TDatetime; const pReload: boolean): string;
begin
  Result := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), edtOrderNr.Text, pDate, pReload,
    estbk_types.CPMOrder_doc_nr);
end;

procedure TframePaymentOrder.createNewPayment;
var
  pPmtOrderNr: AStr;
  pDefaultAcc: AStr;
begin
  lazFocusFix.Enabled := False;
  // --
  edtOrderNr.Text := getPaymentOrderNr(now, False);

  try

    self.FSkipScrollEvent := True;
    // --
    self.performCleanup;

    qryGetUserPmtItems.Filtered := False;
    qryGetUserPmtItems.Filter := '';


    self.qryOpenPmt(0);
    self.qryPsPaymentMiscSum(0);
    self.qryPsPaymentData(-1);

    // --------
    qryPmtOrder.Insert;


    pmtDate.Date := now;
    pmtDate.Text := datetostr(pmtDate.Date);
    // et üllatusi ei tuleks, ootamatuid üllatusi on tulnud !!!


    cmbCurrency.ItemIndex := cmbCurrency.Items.IndexOf(estbk_globvars.glob_baseCurrency);


    // reset filtrile !
    // --- et kuvataks ainult lubatud kontosid !!!
    qryGetCBanksAccounts.Filtered := False;
    qryGetCBanksAccounts.Filtered := True;

        {
        qryGetAccounts.Filtered := False;
        qryGetAccounts.Filtered := True;
        }

    // ---
    self.ctrlsVisState(True);


    // estbk_utilities.changeWCtrlEnabledStatus(pmtDate, True);
    // RO staatus !!!
    estbk_utilities.changeWCtrlReadOnlyStatus(grpPmtOrder, False);
    //estbk_utilities.changeWCtrlReadOnlyStatus(pPanel,false);

    // ---
    btnNewPayment.Enabled := False;
    btnSave.Enabled := True;
    btnCancel.Enabled := True;
    btnOpenAccEntry.Enabled := False;




    // raamatupidaja peab kinnitama makse toimumist ! 11.03.2011 Ingmar; jama, nüüd sooviti, et kinnitus = salvestamine !
    //chkboxConfPmtDone.Enabled:=False;
    //lblVerified.Enabled:=False;


    // jätame meelde valitud kontod
    if self.FLastCAccountId = 0 then
    begin

      pDefaultAcc := dmodule.userStsValues[CstsDefaultPmtAcc];
      if (pDefaultAcc <> '') and (qryGetCBanksAccounts.locate('account_coding', pDefaultAcc, [loCaseInsensitive])) then
      begin
        dbLookupComboCredit.Value := IntToStr(qryGetCBanksAccounts.FieldByName('id').AsInteger);
        dbLookupComboCredit.OnSelect(dbLookupComboCredit);
        dbLookupComboCredit.Text := qryGetCBanksAccounts.FieldByName('account_coding').AsString;
      end;
    end
    else
    if (qryGetCBanksAccounts.locate('id', self.FLastCAccountId, [])) then
    begin
      dbLookupComboCredit.Value := IntToStr(self.FLastCAccountId);
      dbLookupComboCredit.OnSelect(dbLookupComboCredit);
      dbLookupComboCredit.Text := qryGetCBanksAccounts.FieldByName('account_coding').AsString;
    end;
     {
     if (self.FLastDAccountId>0) and (qryGetAllBkAccounts.locate('id',self.FLastDAccountId,[])) then
       begin
         dbLookupComboDebit.value:=inttostr(self.FLastDAccountId);
         dbLookupComboDebit.OnSelect(dbLookupComboDebit);
         dbLookupComboDebit.text:=qryGetCBanksAccounts.fieldbyname('account_coding').asString;
       end;
     }
  finally
    self.FSkipScrollEvent := False;
  end;

  if dbEdtDocNr.CanFocus then
    dbEdtDocNr.SetFocus;
end;

procedure TframePaymentOrder.createNewPaymentWithPreDefOrder(const pOrderId: integer; const pClientId: integer);
begin

  self.performCleanup;
  self.createNewPayment;
  self.reloadCustomerData(pClientId, False);

  // leiame elemendi üles
  if qryGetUserPmtItems.Locate('id;litemtype', VarArrayOf([pOrderId, estbk_types.CCommTypeAsOrder]), []) then
  begin
    qryGetUserPmtItems.Edit;
    qryGetUserPmtItems.FieldByName('lsitemhlp').AsString := estbk_types.SCFalseTrue[True];
    qryGetUserPmtItems.FieldByName('splt_sum').asCurrency := qryGetUserPmtItems.FieldByName('to_pay').asCurrency;
    qryGetUserPmtItems.Post;
  end;


  // lõpuks uuendame ka ära summa osa
  self.changePmtOrderSumAndDescr(True);
end;



procedure TframePaymentOrder.setCustomerPmtItemsFilter(const pItemId: integer; const pItemType: AStr);
begin
  // filtrile reset
  if (pItemId = 0) and (pItemType = '') then
  begin
    qryGetUserPmtItems.Filtered := False;
    qryGetUserPmtItems.Filter := '';
  end
  else
  begin
    qryGetUserPmtItems.Filtered := False;
    qryGetUserPmtItems.Filter := format('id=%d AND litemtype=%s', [pItemId, QuotedStr(pItemType)]);
    qryGetUserPmtItems.Filtered := True;
  end;
end;


procedure TframePaymentOrder.btnNewPaymentClick(Sender: TObject);
begin
  if not self.loadData then
    self.loadData := True;

  self.createNewPayment;
end;

procedure TframePaymentOrder.btnOpenAccEntryClick(Sender: TObject);
begin
  // --- saadame välja signaali, et soovime näha maksekorralduse kannet
  if assigned(self.FFrameDataEvent) and (self.FCurrPmtAccBRecId > 0) then
    self.FFrameDataEvent(Self, __frameOpenAccEntry, self.FCurrPmtAccBRecId);
end;

procedure TframePaymentOrder.btnOpenClientListClick(Sender: TObject);
var
  pCurrCustID: integer;
begin
  pCurrCustID := 0;
  if assigned(self.FPClientData) then
    pCurrCustID := self.FPClientData.FClientId;


  self.reloadCustomerData(pCurrCustID);



  // 20.03.2011 Ingmar
  if dbGridAllItems.CanFocus then
    dbGridAllItems.SetFocus;
end;

procedure TframePaymentOrder.dbLookupComboCreditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Shift = []) then
    if (key = VK_DELETE) then
    begin
      if Sender = dbLookupComboCredit then
        lblAccCName.Caption := '';
      // else
      // if Sender = dbLookupComboDebit then
      //   lblAccDName.Caption := '';
    end;


  if Sender is TRxDBLookupCombo then
    estbk_utilities.rxLibKeyDownHelper(Sender as TRxDBLookupCombo, Key, Shift);

end;

procedure TframePaymentOrder.dbLookupComboCreditSelect(Sender: TObject);
var
  pCurrIndex: integer;
  pCreateNewSess: boolean;
begin
  with  TRxDBLookupCombo(Sender) do
    if (Value <> '') then
    begin
      LookupSource.DataSet.Locate('id', Value, []);
      Text := LookupSource.DataSet.FieldByName('account_coding').AsString;


      if Sender = dbLookupComboCredit then
      begin
        lblAccCName.Caption := '     ' + LookupSource.DataSet.FieldByName('account_name').AsString + '(' +
          LookupSource.DataSet.FieldByName('bankname').AsString + ')';

        // peame ka õige valuuta võtma !
        pCurrIndex := cmbCurrency.items.indexOf(LookupSource.DataSet.FieldByName('default_currency').AsString);
        if pCurrIndex >= 0 then
          cmbCurrency.ItemIndex := pCurrIndex;

        try

          pCreateNewSess := not (qryPmtOrder.State in [dsEdit, dsInsert]);
          if pCreateNewSess then
            qryPmtOrder.Edit;

          qryPmtOrder.FieldByName('payer_account_nr').AsString := LookupSource.DataSet.FieldByName('account_nr').AsString;
          if trim(qryPmtOrder.FieldByName('payer_account_nr').AsString) = '' then
            qryPmtOrder.FieldByName('payer_account_nr').AsString := LookupSource.DataSet.FieldByName('account_nr_iban').AsString;

        finally
          if pCreateNewSess then
            qryPmtOrder.Post;
        end;

      end;
      //else
      //if Sender = dbLookupComboDebit then
      //   lblAccDName.Caption := '     ' +LookupSource.DataSet.FieldByName('account_name').AsString;
    end; // ---
end;

procedure TframePaymentOrder.edtrecpnameChange(Sender: TObject);
begin

  // pimgisverifiedclient.Picture.Clear;
  // kuna autocomplete siin puudub nagu laekumistes, siis muutmisel oletame, et tegemist täiesti uue kliendiga / registreerimata !
  with TDbEdit(Sender) do
    if Focused and (Tag <> -1) then
    begin
      pimgisverifiedclient.Hint := '';
      edtrecpname.Hint := '';

      if assigned(FPClientData) then
      begin
        self.cpyCustomerMiscDataToDataset(nil);
        self.qryPsPaymentData(-1);


        pimgisverifiedclient.Picture.Clear;
        FreeAndNil(FPClientData);
        FPPrevClientID := 0;
      end;

      // ---
    end;
end;

procedure TframePaymentOrder.edtrecpnameKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Shift = [ssCtrl]) then
    try
      TDbEdit(Sender).Tag := -1;
      // -- et onchange event ei rakenduks !
      self.btnOpenClientListClick(btnOpenClientList);
      key := 0;

    finally
      TDbEdit(Sender).Tag := 0;
    end;
end;

procedure TframePaymentOrder.lazFocusFixTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;

  // ---
  if (FLazFocusFixFlags and CLazFixDbGridFocus) = CLazFixLookupFocus then
  begin

    if miscSumDbGrid.CanFocus then
      miscSumDbGrid.SetFocus;

    if self.FAccounts.CanFocus then
      self.FAccounts.SetFocus;

  end
  else
  if (FLazFocusFixFlags and CLazFixDbGridFocus) = CLazFixDbGridFocus then
  begin

    (miscSumDbGrid.EditorByStyle(cbsAuto) as TStringCellEditor).SelStart := length((miscSumDbGrid.EditorByStyle(cbsAuto) as TStringCellEditor).Text);
    if miscSumDbGrid.CanFocus then
      miscSumDbGrid.SetFocus;

    if self.FActiveEditor.CanFocus then
      self.FActiveEditor.SetFocus;
  end;

  self.FLazFocusFixFlags := 0;
end;

procedure TframePaymentOrder.mainPanelClick(Sender: TObject);
begin
  // --
end;

procedure TframePaymentOrder.miscSumDbGridCellClick(Column: TColumn);
begin
  // --
end;

// no autoedit alati tööle !
procedure TframePaymentOrder.miscSumDbGridColEnter(Sender: TObject);
begin

  with TDbGrid(Sender).DataSource.DataSet do
  begin
    if Active and not (State in [dsEdit, dsInsert]) then
      Edit;
    self.FSelectedCol := TDbGrid(Sender).SelectedColumn;


    // lazaruse jätkub fookuse kalad !
    if TDbGrid(Sender).CanFocus then
      TDbGrid(Sender).SetFocus;
  end; // --
end;


procedure TframePaymentOrder.miscSumDbGridColExit(Sender: TObject);
var
  pNewSession: boolean;
begin

  with TDbGrid(Sender).DataSource.DataSet do
    if assigned(self.FSelectedCol) and (ansilowercase(FSelectedCol.Field.FieldName) = CLookupKeyField) then
      try
        pNewSession := not (State in [dsEdit, dsInsert]);
        if pNewSession then
          Edit;


        // --- igasugu trikke tuleb teha, et lazaruse bugidest mööda hiilida !
        self.FSelectedCol.Field.AsString := self.FLcmpAccountCode;
        self.FAccounts.Visible := False;

      finally
        if pNewSession then
          Post;
      end;
end;

procedure TframePaymentOrder.miscSumDbGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
begin

  if (ansilowercase(Column.FieldName) = CLookupKeyField) and (gdFocused in State) then
  begin
    self.FAccounts.SetBounds(Rect.Left,
      Rect.Top,
      (Rect.Right - Rect.Left) - 1,
      (Rect.Bottom - Rect.Top) - 5);

  end;
  TDbGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TframePaymentOrder.miscSumDbGridEnter(Sender: TObject);
begin

  // # autoinsert !
  // with TDbGrid(sender).DataSource.DataSet    do
  // miscSumDbGrid -> OnEnter
  // teeme tühja insert rea !
  if not self.FAccounts.Visible and not self.FCurrPmtOrderConfirmed then
    with qryGetMiscPmtItems do
      if Active and (not (State in [dsEdit, dsInsert])) and (RecordCount = 0) then
      begin
        Insert;
        //     miscSumDbGrid.SelectedColumn:=miscSumDbGrid.Columns.Items[0];
      end;
end;

procedure TframePaymentOrder.miscSumDbGridExit(Sender: TObject);
begin

  self.miscSumDbGridColExit(Sender); // !!!

  // ---
  with TDbGrid(Sender).DataSource.DataSet do
    if Active then
    begin
      // lõpetame igal juhul redigeerimise !
      if (State in [dsEdit, dsInsert]) then
        Post;

      self.lazFocusFix.Enabled := False;
      self.FAccounts.Visible := False;
    end;
end;

procedure TframePaymentOrder.miscSumDbGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin

  lazFocusFix.Enabled := False;
  // -- ps dblookupcombo kasutab sama eventi !
  if (((key = VK_RETURN) or (key = VK_TAB)) and (shift = [])) then
  begin
    if (Sender is TDbGrid) then
      with TDbGrid(Sender) do
      begin
        //      PerformTab(true);
        //if assigned(SelectedColumn) and (SelectedColumn.Index<Columns.Count-1) then
        //Columns.Items[1].Field.FocusControl;
        FLazFocusFixFlags := CLazFixDbGridFocus;



        // lazaruse kala !
        // Kui enter või tab vajutada, siis kenasti liigub järgmise columni peale,
        // AGA TDbGrid kaotab fookuse !

        if assigned(SelectedColumn) and (SelectedColumn.Index = Columns.Count - 1) then
        begin
          //      PerformTab(true);
          if dbEdtBankCost.CanFocus then
            dbEdtBankCost.SetFocus;
          key := 0;
        end
        else
        begin
          lazFocusFix.Enabled := True;
          key := VK_RIGHT;
        end;
      end
    else
    if (Sender is TRxDBLookupCombo) then
    begin
      if dbEdtBankCost.CanFocus then
        dbEdtBankCost.SetFocus;
      key := 0;
    end;
    // --
  end
  else
  if (key = VK_DELETE) and (shift = [ssCtrl]) then
    with miscSumDbGrid.DataSource.DataSet do
      if active and not isEmpty then
        Delete;
end;

procedure TframePaymentOrder.miscSumDbGridKeyPress(Sender: TObject; var Key: char);
begin
  if chkboxConfPmtDone.Checked then
    key := #0
  else
  if assigned(TDbGrid(Sender).SelectedColumn) and (ansilowercase(TDbGrid(Sender).SelectedColumn.FieldName) = CLookupSpltsum) then
  begin
    if key in ['+', '-'] then
      key := #0
    else
    if key in [',', '.'] then // et ikka õige võetaks !
      key := SysUtils.DecimalSeparator;
    edit_verifyNumericEntry(TDbGrid(Sender).EditorByStyle(cbsAuto) as TCustomEdit, key, True);
  end;
end;



procedure TframePaymentOrder.miscSumDbGridSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
var
  pNewEdtSession: boolean;
begin

  // 15.03.2011 Ingmar
  Editor := miscSumDbGrid.EditorByStyle(cbsAuto);

  // --
  self.FActiveEditor := Editor;
  if (ansilowercase(Column.FieldName) = CLookupKeyField) then
  begin

    // kinnitatud maksekorralduse puhul ei kasuta default editori !
    if not chkboxConfPmtDone.Checked then
    begin

      if self.FAccounts.LookupSource.DataSet.Locate('id', TDbGrid(Sender).DataSource.DataSet.FieldByName('account_id').AsInteger, []) then
        self.FAccounts.Text := self.FAccounts.LookupSource.DataSet.FieldByName('account_coding').AsString
      else
      begin
        self.FAccounts.Text := '';
        self.FAccounts.Value := '';
      end;

      self.FLazFocusFixFlags := CLazFixLookupFocus;
      // --
    end;

    // --
    Editor := self.FAccounts;
    //Column.ReadOnly:=false;
    // Editor:=nil;
  end
  else
  if assigned(Editor) then
  begin
    Editor.OnKeyDown := @self.miscSumDbGridKeyDown;
    self.FLazFocusFixFlags := CLazFixDbGridFocus;
  end;

  lazFocusFix.Enabled := TDbGrid(Sender).Focused;
  self.FActiveEditor.PopupMenu := self.popupMiscGridActions;



  // 16.06.2011 Ingmar
  if Editor is TStringCellEditor then
  begin
    if Column.Index = CCol2_sum then
      TStringCellEditor(Editor).Alignment := taRightJustify
    else
      TStringCellEditor(Editor).Alignment := taLeftJustify;
  end; // ---
end;

procedure TframePaymentOrder.miscSumDbGridTitleClick(Column: TColumn);
begin
  // ---
end;

procedure TframePaymentOrder.mnuItemDelLineClick(Sender: TObject);
begin
  with qryGetMiscPmtItems do
    if active and not isEmpty then
      Delete;
end;

procedure TframePaymentOrder.pmtDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
var
  pNewEditSession: boolean;
begin
  if ADate <= now then
  begin
    // 19.08.2011 Ingmar
    if (Sender is TDateEdit) and not chkboxConfPmtDone.Checked then
      try

        pNewEditSession := not (qryPmtOrder.State in [dsEdit, dsInsert]);
        if pNewEditSession then
          qryPmtOrder.Edit;
        // ---
        qryPmtOrder.FieldByName('payment_date').AsDateTime;


      finally
        if pNewEditSession then
          qryPmtOrder.Post;
      end; // --


    // 01.03.2012 Ingmar; numeraatorite reform
    edtOrderNr.Text := self.getPaymentOrderNr(ADate, True);
    self.refreshUICurrList(ADate);
  end
  else
    estbk_utilities.miscResetCurrenyValList(cmbCurrency);
end;

procedure TframePaymentOrder.pmtDateChange(Sender: TObject);
begin
  // --

end;



procedure TframePaymentOrder.pmtDateExit(Sender: TObject);
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
    begin
      TDateEdit(Sender).Text := datetostr(fVDate);
      if fVDate <= now then
        self.refreshUICurrList(fVDate)
      else
        estbk_utilities.miscResetCurrenyValList(cmbCurrency);
      // kõige õigem viist vist ?!?
    end;

end;

procedure TframePaymentOrder.pmtDateKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;

end;

procedure TframePaymentOrder.qryGetAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  pDefC: AStr;
  pCurrC: AStr;
  pOk: boolean;
begin
  pDefC := DataSet.FieldByName('default_currency').AsString;
  if pDefC = '' then
    pDefC := estbk_globvars.glob_baseCurrency;

  pCurrC := cmbCurrency.Text;
  if pCurrC = '' then
    pCurrC := estbk_globvars.glob_baseCurrency;

  // ---
  pOk := AnsiUpperCase(pDefC) = AnsiUpperCase(pCurrC);
  if self.FNewRecord then
    pOk := pOk and not ((DataSet.FieldByName('flags').AsInteger and estbk_types.CAccFlagsClosed) = estbk_types.CAccFlagsClosed);
  Accept := pOk;
end;

procedure TframePaymentOrder.qryGetCBanksAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  // Uue kirje puhul ei luba enam suletud kontosid kuvada; vanade puhul peame, muidu pole võimalik neid kuvada !!!
  if self.FNewRecord then
    Accept := not ((DataSet.FieldByName('flags').AsInteger and estbk_types.CAccFlagsClosed) = estbk_types.CAccFlagsClosed)
  else
    Accept := True;
end;

procedure TframePaymentOrder.qryGetMiscPmtItemsAfterEdit(DataSet: TDataSet);
begin
  // fix;
  btnNewPayment.Enabled := False;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
end;

procedure TframePaymentOrder.qryGetMiscPmtItemsAfterPost(DataSet: TDataSet);
begin

  self.changePmtOrderSumAndDescr();
  // ---
  self.FMiscPODataChanged := True;
  self.FDataNotSaved := True;


  // 16.06.2011 Ingmar
  if assigned(self.FActiveEditor) and self.FActiveEditor.Visible and not (self.FActiveEditor is TRxDBLookupCombo) then
    self.FActiveEditor.Visible := False;
end;

procedure TframePaymentOrder.qryGetMiscPmtItemsBeforePost(DataSet: TDataSet);
begin
  if DataSet.active then
  begin
    if not self.FNewRecord then
      DataSet.FieldByName('payment_id').AsInteger := self.FCurrPmtOrderID;
    //DataSet.FieldByname('item_type').AsString:=estbk_types.CPmtOrder_miscitem;
    DataSet.FieldByName('status').AsString := '';
    // ---
  end;
end;

procedure TframePaymentOrder.qryGetUserPmtItemsAfterEdit(DataSet: TDataSet);
begin
  self.dbGridAllItemsCellClick(nil);
end;


// TODO vii antud koodid ühte protseduuri, see hack pole ilus !
function TframePaymentOrder.calculatePaymentOrderTotalSum(var pPmtSum: double; // arve valuutas
  var pDiff: double; // baasvaluuta
  var pDescr: AStr): boolean;  // --
var
  i, pIndex: integer;
  pCBookMark: TBookmark;
  // --
  pSelItemSum: currency;
  pToPaySum: currency;
  //pPrepSum   : double; // kalkuleerime ettemaksusumma
  pBillCurrRate: double;

  // arvutuslik
  pPmtOrdCurrRate: double;
  pCurrRate: double;
  pPmtSumTotal: double;
  pPmtTempDiff: double;
begin
  try
    Result := False;
    pPmtSumTotal := 0;
    pDiff := 0;




    // ---
    pCBookMark := qryGetUserPmtItems.getbookMark;
    qryGetUserPmtItems.DisableControls;

    pDescr := '';
    pSelItemSum := 0;
    // --
    pCurrRate := 0; // hetke valuuta kurss


    pIndex := cmbCurrency.ItemIndex;
    if pIndex >= 0 then
      pCurrRate := TCurrencyObjType(cmbCurrency.items.Objects[pIndex]).currVal;


    // --- moodustame uuesti kirjelduse !!!
    qryGetUserPmtItems.First;
    i := 0;
    while not qryGetUserPmtItems.EOF do
    begin

      if estbk_utilities.isTrueVal(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString) then
      begin
        if i > 0 then
          pDescr := pDescr + ';';
        //pPrepSum  := 0;
        pToPaySum := qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency;

        //  pToPaySum := qryGetUserPmtItems.FieldByName('splt_sum').AsFloat;
        //qryGetUserPmtItems.fieldByname('to_pay').asFloat;
        // peame tegema valuuta konverteerimise !!!!

       {
           HKD   1.5073700000
           USD   11.6988000000

                       HKD          USD
           HKD   1.0000000000   7.7610672894
           USD   0.1288482579   1.0000000000
       }


        pBillCurrRate := qryGetUserPmtItems.FieldByName('currrate').AsCurrency;
        if pBillCurrRate = 0 then // järelikult baasvaluuta
          pBillCurrRate := 1;

        // ----------------------------------------------------------
        // arve/tellimuse summa teisendus !
        // ----------------------------------------------------------



        // üritame leida kursivahe;
                  {
                  Firma ostab materjale, mille kohta hankija esitab arve summas 2 000 USD.
                  Majandustehingu toimumise päeval on Eesti Panga valuutakurss: 1 USD = 17,45 krooni.
                  }

        // arvutame kursivahe tänase seisuga
        pIndex := self.FStCurrInst.IndexOf(qryGetUserPmtItems.FieldByName('currency').AsString);
        assert(pIndex >= 0, '#5');


        pPmtOrdCurrRate := TCurrencyObjType(self.FStCurrInst.Objects[pIndex]).currVal;
        if pPmtOrdCurrRate = 0 then
        begin
          pPmtOrdCurrRate := 1;
          if qryGetUserPmtItems.FieldByName('currency').AsString <> estbk_globvars.glob_baseCurrency then
          begin
            // parem karta, kui kahetseda
            pPmtSum := 0;
            pDiff := 0;
            Dialogs.messageDlg(format(SEMissingCurrVal, [qryGetUserPmtItems.FieldByName('currency').AsString]), mtError, [mbOK], 0);
            Exit;

          end;
        end;



        pPmtTempDiff := roundto(double(pToPaySum * pBillCurrRate), Z2) - roundto(double(pToPaySum * pPmtOrdCurrRate), Z2);
        // ----
        if pCurrRate > 0 then
        begin
          pDiff := pDiff + roundto(pPmtTempDiff / double(pCurrRate), Z2);
          pPmtSumTotal := roundto(double(pToPaySum * pPmtOrdCurrRate) / double(pCurrRate), Z2);
        end
        else
        begin
          pPmtSumTotal := 0;
        end;

        // selline probleem, et kas ettemaksu ei peaks hoidma baasvaluutas arve juures !?!?!?
        // kandes on ju baasvaluutas
        // teisendasime baasvaluutasse, mis valitud
        pSelItemSum := (pSelItemSum + pPmtSumTotal); // kõik summad kokku !


        // ostuarve
        if (qryGetUserPmtItems.FieldByName('litemtype').AsString = estbk_types.CCommTypeAsBill) then
        begin
          // kui hankijale maksame, siis pole nagu pointi ostuarve kirjutada !!!
          pDescr := pDescr + format(CSSaleBillnr, [qryGetUserPmtItems.FieldByName('nr').AsString]);
        end
        else
        // tellimus
        if (qryGetUserPmtItems.FieldByName('litemtype').AsString = estbk_types.CCommTypeAsOrder) then
        begin
          //  ---
          pDescr := pDescr + format(CSOrderNr, [qryGetUserPmtItems.FieldByName('nr').AsString]);
        end;


        // --
        Inc(i);
      end;

      // --
      qryGetUserPmtItems.Next;
    end;


    // ----  kogu tellimuste ja arvete summa
    pPmtSum := pSelItemSum;
    Result := True;
  finally
    if assigned(pCBookMark) then
    begin
      qryGetUserPmtItems.GotoBookmark(pCBookMark);
      qryGetUserPmtItems.FreeBookmark(pCBookMark);
    end;

    // ---
    qryGetUserPmtItems.EnableControls;
  end;
end;

procedure TframePaymentOrder.calculatePaymentOrderMiscItemsTotalSum(var pPmtSum: double; var pDescr: AStr);
var
  pCBookMark: TBookmark;
  pFiltStatus: boolean;
  i: integer;
begin
  try
    pDescr := '';
    // ---
    pCBookMark := qryGetMiscPmtItems.getbookMark;

    qryGetMiscPmtItems.DisableControls;

    pFiltStatus := qryGetMiscPmtItems.Filtered;
    qryGetMiscPmtItems.Filtered := False;
    qryGetMiscPmtItems.First;

    i := 0;
    while not qryGetMiscPmtItems.EOF do
    begin
      pPmtSum := pPmtSum + qryGetMiscPmtItems.FieldByName('splt_sum').AsCurrency;
      if (i > 0) and (pDescr <> '') then
        pDescr := pDescr + ';';
      pDescr := pDescr + qryGetMiscPmtItems.FieldByName('item_descr').AsString;

      qryGetMiscPmtItems.Next;
      Inc(i);
    end;
    // ---
  finally
    qryGetMiscPmtItems.Filtered := pFiltStatus;
    if assigned(pCBookMark) then
    begin
      qryGetMiscPmtItems.GotoBookmark(pCBookMark);
      qryGetMiscPmtItems.FreeBookmark(pCBookMark);
    end;

    // ---
    qryGetMiscPmtItems.EnableControls;
  end;
end;


procedure TframePaymentOrder.changePmtOrderSumAndDescr(const updateDescrField: boolean = True);
var
  pCBookMark: TBookmark;
  pTrigEdt: boolean;
  pDescrCnt: AStr;
  pDescr1: AStr;
  pDescr2: AStr;
  // kursivahe erinevus
  pCurrDiff: double;
  pMiscSum: double;
  pBOSum: double;
  pTotalSum: double;

begin
  try
    try
      // valitud arvete ja tellimuste info
      pCurrDiff := 0;
      pBOSum := 0;
      pMiscSum := 0;
      pTotalSum := 0;

      pDescr1 := '';
      pDescr2 := '';



      // eelkalkuleeritud summa; sumtotal väljale
      if self.calculatePaymentOrderTotalSum(pBOSum, pCurrDiff, pDescr1) then
      begin
        self.calculatePaymentOrderMiscItemsTotalSum(pMiscSum, pDescr2);
        pTotalSum := roundto(pBOSum + pMiscSum, Z2);
      end;

      // -----
      pTrigEdt := not (qryPmtOrder.state in [dsEdit, dsInsert]);

      // --
      if pTrigEdt then
        qryPmtOrder.Edit;

      pDescrCnt := pDescr1;
      if pDescr2 <> '' then
      begin
        if pDescrCnt <> '' then
          pDescrCnt := pDescrCnt + ';';
        pDescrCnt := pDescrCnt + pDescr2;
      end;

      // --------
      qryPmtOrder.FieldByName('sumtotal').AsCurrency := pTotalSum;

      if updateDescrField then
        qryPmtOrder.FieldByName('descr').AsString := pDescrCnt;
      // --------


    finally

      // ----
      if pTrigEdt then
        qryPmtOrder.Post;
    end;

  except
  end; // ---
end;

procedure TframePaymentOrder.qryGetUserPmtItemsAfterPost(DataSet: TDataSet);
begin
  self.changePmtOrderSumAndDescr();
  // ---
  self.FMiscLinesChanged := True;
  self.FDataNotSaved := True;

  // 16.06.2011 Ingmar
  if assigned(self.FLiveEditor) and self.FLiveEditor.Visible and not (self.FLiveEditor is TRxDBLookupCombo) then
    self.FLiveEditor.Visible := False;
end;

procedure TframePaymentOrder.qryGetUserPmtItemsBeforeEdit(DataSet: TDataSet);
begin
  // kui makse kinnitatud, siis ei luba redigeerida !!!!!
  if (not self.FNewRecord and chkboxConfPmtDone.Checked) or (DataSet.RecordCount < 1) then // Dataset.Eof or
    abort;
end;

procedure TframePaymentOrder.qryGetUserPmtItemsBeforeInsert(DataSet: TDataSet);
begin
  Abort; // et gridis pole võimalik uut rida lisada !
end;

procedure TframePaymentOrder.qryPmtOrderAfterInsert(DataSet: TDataSet);
begin
  self.FNewRecord := True;
  DataSet.FieldByName('payment_type').AsString := estbk_types.CPayment_aspmtord;
end;

procedure TframePaymentOrder.qryPmtOrderAfterScroll(DataSet: TDataSet);
begin
  self.dbLookupComboCreditSelect(dbLookupComboCredit);
  //self.dbLookupComboCreditSelect(dbLookupComboDebit);
  // ----

  if not DataSet.Active or (DataSet.FieldByName('payment_date').AsString = '') then
    pmtDate.Text := ''
  else
  begin

    // --
    if not self.FNewRecord then
    begin
      pmtDate.date := DataSet.FieldByName('payment_date').AsDateTime;
      pmtDate.Text := datetostr(pmtDate.date);
      edtOrderNr.Text := DataSet.FieldByName('payment_nr').AsString;
      chkboxConfPmtDone.Checked := pos(estbk_types.CPaymentRecStatusClosed, DataSet.FieldByName('status').AsString) > 0;
    end;
  end;
  // ---
end;

procedure TframePaymentOrder.qryPmtOrderBeforeEdit(DataSet: TDataSet);
begin
  // ntx checkboxis kinnitati, siis meil tõesti pole vaja uuesti nuppe lahti teha ja vilgutada neid
  if not self.FSkipOnChangeEvent then
  begin
    self.btnNewPayment.Enabled := False;
    self.btnSave.Enabled := True;
    self.btnCancel.Enabled := True;
  end;
end;

procedure TframePaymentOrder.qryPmtOrderBeforePost(DataSet: TDataSet);
begin
  if DataSet.active then
  begin
    // --
    if self.FNewRecord then
    begin
      DataSet.FieldByName('company_id').AsInteger := estbk_globvars.glob_company_id;
      DataSet.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
    end;

    // --
    DataSet.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
    DataSet.FieldByName('rec_changed').AsDateTime := now;
  end;
end;

// lazaruse kala; aka mdi vormid !
procedure TframePaymentOrder.doOnClickFix(Sender: TObject);
begin
  if miscSumDbGrid.CanFocus then
    miscSumDbGrid.SetFocus;

  if TWinControl(Sender).CanFocus then
    TWinControl(Sender).SetFocus;
end;

// 12.06.2011 Ingmar
procedure TframePaymentOrder.OnOvrEditorExit(Sender: TObject);
begin
  estbk_utilities.OnDbGridEditorExitFltCheck(dbGridAllItems, Sender, CCol_spltSum);
end;

procedure TframePaymentOrder.OnOvrEditorExit2(Sender: TObject);
begin
  estbk_utilities.OnDbGridEditorExitFltCheck(miscSumDbGrid, Sender, CCol2_sum);
end;

constructor TframePaymentOrder.Create(frameOwner: TComponent);
var
  pCollItem: TCollectionItem;
begin
  // -------
  inherited Create(frameOwner);
  // -------
  estbk_uivisualinit.__preparevisual(self);
  //panelLogSeparator.Color:=estbk_types.MyFavOceanBlue;
  //Color:=estbk_types.MyFavOceanBlue;
  //mainPanel.Color:=estbk_types.MyFavOceanBlue;
  //mainPanel.Color := clBtnFace;
  miscSumDbGrid.DoubleBuffered := True;

  // ---
  dbGridAllItems.Columns.items[CCol_itemchecked].ValueChecked := estbk_types.SCFalseTrue[True];
  dbGridAllItems.Columns.items[CCol_itemchecked].ValueUnChecked := estbk_types.SCFalseTrue[False]; // valik



  //.DisplayFormat:=estbk_types.CCurrentMoneyFmt2;
  //self.tarbCtrlPmtOrder.ActivePage := tabPmtOrder;

  chkboxConfPmtDone.Font.Style := [fsUnderline];


  FAccounts := TRxDBLookupCombo.Create(miscSumDbGrid);
  FAccounts.parent := self.miscSumDbGrid;
  FAccounts.Visible := False;

  FAccounts.ParentFont := False;
  FAccounts.ParentColor := False;
  FAccounts.ShowHint := True;
  FAccounts.DoubleBuffered := True;
{
  FAccounts.DataSource:=qryGetPmtItemsDs;
  FAccounts.DataField:='account_id';
}

  FAccounts.LookupSource := self.qryGetAccountsDs;
  FAccounts.LookupDisplay := 'account_coding;account_name';
  FAccounts.LookupField := 'id';


  pCollItem := FAccounts.PopUpFormOptions.Columns.Add;
  (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccCode;
  (pCollItem as TPopUpColumn).Fieldname := 'account_coding';
  (pCollItem as TPopUpColumn).Width := 85;


  pCollItem := FAccounts.PopUpFormOptions.Columns.Add;
  (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccName;
  (pCollItem as TPopUpColumn).Fieldname := 'account_name';
  (pCollItem as TPopUpColumn).Width := 215;


  FAccounts.OnEnter := @self.OnLookupComboEnter;
  FAccounts.OnExit := @self.OnLookupComboExit;
  FAccounts.OnSelect := @self.OnLookupComboSelect;
  FAccounts.OnChange := @self.OnLookupComboChange;

  FAccounts.OnClosePopupNotif := @self.OnLookupComboPopupClose;
  FAccounts.OnKeyDown := @self.OnLookupComboKeydown;




  //FAccounts.OnChange:=@self.OnLookupComboSelect;
  //FAccounts.OnClick:=@self.OnLookupComboSelect;

  FAccounts.Left := CLeftHiddenCorn;
  FAccounts.Flat := True;
  FAccounts.EmptyValue := #32;
  FAccounts.UnfindedValue := rxufNone;
  FAccounts.DropDownCount := 15;
  FAccounts.DropDownWidth := 385;

  FAccounts.ButtonWidth := 15;
  FAccounts.ButtonOnlyWhenFocused := False;
  FAccounts.Height := 23;
  FAccounts.PopUpFormOptions.ShowTitles := True;
  FAccounts.PopUpFormOptions.TitleButtons := True;



  // 20.03.2011 Ingmar; totakad fookuse probleemid !
  (miscSumDbGrid.EditorByStyle(cbsAuto) as TStringCellEditor).OnClick := @self.doOnClickFix;
  //self.tarbCtrlPmtOrder.ActivePage:=tabPmtOrder;


  // 29.05.2011 Ingmar
  FAccounts.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
  dbLookupComboCredit.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
  dbRcvBankList.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;

  // 00006 bug; 12.06.2011 kui gridi arvulisse lahtrisse kopeeriti tekst
  dbGridAllItems.EditorByStyle(cbsAuto).OnExit := @self.OnOvrEditorExit;
  miscSumDbGrid.EditorByStyle(cbsAuto).OnExit := @self.OnOvrEditorExit2;
end;

destructor TframePaymentOrder.Destroy;
begin
  lazFocusFix.Enabled := False;
  estbk_utilities.clearStrObject(TAStrings(self.FStCurrInst));
  FreeAndNil(self.FStCurrInst);
  dmodule.notifyNumerators(PtrUInt(self));

  inherited Destroy;
end;

initialization
  {$I estbk_fra_paymentorders.ctrs}

end.
