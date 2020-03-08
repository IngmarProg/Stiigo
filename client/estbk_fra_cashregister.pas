// * KASSA *
unit estbk_fra_cashregister;

{$mode objfpc}{$H+}
{$I estbk_defs.inc}

// Kassapõhise käibemaksuarvestuse
// http://www.emta.ee/index.php?id=28885
// MÄRKUS: osaliselt kopeerime paymentorders koodi, aga meil ohutum neid koode siiski eraldi hoida, kuigi tööpõhimõte väga sarnane !



interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, EditBtn,
  Variants, LCLProc, Graphics, Buttons, DBGrids, DBCtrls, ExtCtrls, estbk_fra_template,
  estbk_lib_commonevents, estbk_uivisualinit, rxpopupunit, estbk_clientdatamodule,
  dateutils, estbk_sqlclientcollection, estbk_globvars, ZAbstractDataset,
  LCLType, estbk_utilities, estbk_types, estbk_strmsg, ZDataset, ZSqlUpdate,
  ZConnection, DB, memds, rxlookup, Dialogs, Math, SMNetGradient, Grids, estbk_settings,
  estbk_fra_customer, estbk_lib_commoncls, estbk_lib_paymentmanager, estbk_reportconst,
  estbk_frm_choosecustmer, estbk_lib_commonaccprop, LR_DBSet, LR_Class;

type

  { TframeCashRegister }

  TframeCashRegister = class(Tfra_template)
    Bevel1: TBevel;
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnClose1: TBitBtn;
    btnNewPayment: TBitBtn;
    btnOpenAccEntry: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnPrint: TBitBtn;
    btnSave: TBitBtn;
    bv1: TBevel;
    cmbCurrencyList: TComboBox;
    mdescr: TDBMemo;
    frreport: TfrReport;
    qryGetCashRegAccountsDs: TDatasource;
    qryCashRegisterDs: TDatasource;
    lblSrc: TLabel;
    qryGetCashRegAccounts: TZReadOnlyQuery;
    qryGetUserPmtItemsDs: TDatasource;
    qryGetAccountsDs: TDatasource;
    dbEdtDocNr: TDBEdit;
    dbEdtTotalSum: TDBEdit;
    edtrecpname: TDBEdit;
    lblVerified: TLabel;
    pLblCurrVal: TLabel;
    qryGetUserPmtItems: TZQuery;
    qryGetPaymentMiscItems: TZQuery;
    qryGetPaymentMiscItemsDs: TDatasource;
    rcornerimg: TImage;
    lblAccDName: TLabel;
    lblTotalSum: TLabel;
    miscSumDbGrid: TDBGrid;
    panelExtItems: TPanel;
    pVerifiedChkbox: TCheckBox;
    lookupcmbCashRegister: TRxDBLookupCombo;
    cmbTransType: TComboBox;
    dbGridAllItems: TDBGrid;
    dtPmtDate: TDateEdit;
    grpboxLg: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblClient: TLabel;
    lblComment: TLabel;
    lblTransType: TLabel;
    lblTransNr: TLabel;
    lblDate: TLabel;
    lblAccount: TLabel;
    pimgisverifiedclient: TImage;
    qryCashRegister: TZQuery;
    qryCashRegisterUpdt: TZUpdateSQL;
    lazFocusFix: TTimer;
    qryGetAccounts: TZReadOnlyQuery;
    qryGetPaymentMiscItemsUpdIns: TZUpdateSQL;
    qryDataWriter: TZQuery;
    lazTimerClient: TTimer;
    procedure btnCancelClick(Sender: TObject);
    procedure btnClose1Click(Sender: TObject);
    procedure btnNewPaymentClick(Sender: TObject);
    procedure btnOpenAccEntryClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cmbCurrencyListChange(Sender: TObject);
    procedure cmbTransTypeKeyPress(Sender: TObject; var Key: char);
    procedure dbGridAllItemsColExit(Sender: TObject);
    procedure dbGridAllItemsEnter(Sender: TObject);
    procedure dtPmtDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure dtPmtDateExit(Sender: TObject);
    procedure frreportGetValue(const ParName: string; var ParValue: variant);
    procedure lazFocusFixTimer(Sender: TObject);
    procedure lazTimerClientTimer(Sender: TObject);
    procedure lookupcmbCashRegisterClosePopupNotif(Sender: TObject; SearchResult: boolean);
    procedure lookupcmbCashRegisterKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure lookupcmbCashRegisterSelect(Sender: TObject);
    procedure cmbTransTypeChange(Sender: TObject);
    procedure dbGridAllItemsCellClick(Column: TColumn);
    procedure dbGridAllItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure dbGridAllItemsExit(Sender: TObject);
    procedure dbGridAllItemsKeyPress(Sender: TObject; var Key: char);
    procedure dbGridAllItemsPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
    procedure dbGridAllItemsSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
    procedure edtrecpnameChange(Sender: TObject);
    procedure edtrecpnameKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure miscSumDbGridCellClick(Column: TColumn);
    procedure miscSumDbGridColEnter(Sender: TObject);
    procedure miscSumDbGridColExit(Sender: TObject);
    procedure miscSumDbGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure miscSumDbGridEnter(Sender: TObject);
    procedure miscSumDbGridExit(Sender: TObject);
    procedure miscSumDbGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure miscSumDbGridKeyPress(Sender: TObject; var Key: char);
    procedure miscSumDbGridSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
    procedure qryCashRegisterAfterInsert(DataSet: TDataSet);
    procedure qryCashRegisterAfterScroll(DataSet: TDataSet);
    procedure qryCashRegisterBeforeEdit(DataSet: TDataSet);
    procedure qryGetPaymentMiscItemsAfterEdit(DataSet: TDataSet);
    procedure qryGetPaymentMiscItemsAfterPost(DataSet: TDataSet);
    procedure qryGetPaymentMiscItemsBeforeEdit(DataSet: TDataSet);
    procedure qryGetPaymentMiscItemsBeforeInsert(DataSet: TDataSet);
    procedure qryGetPaymentMiscItemsBeforePost(DataSet: TDataSet);
    procedure qryGetUserPmtItemsAfterPost(DataSet: TDataSet);
    procedure qryGetUserPmtItemsBeforeEdit(DataSet: TDataSet);
    procedure rcornerimgClick(Sender: TObject);
    procedure pVerifiedChkboxChange(Sender: TObject);
  private
    // 16.06.2011 Ingmar; lazaruses bugi, bugi järel. Kui gridilt minema liikuda, siis editori ei kaotata !
    FLiveEditor: TWinControl;

    FAccounts: TRxDBLookupCombo;
    FSelectedCol: TColumn;
    FCurrList: TAStrList;
    FLazFocusFixFlags: integer;
    FLcmpAccountCode: AStr;

    FRepItemDescr: AStr;
    FRepItemVatSumTotal: double;
    FRepItemSumTotal: double;

    // hetkel avatud kassa kirje või just loodud !
    FCurrPaymentID: integer;  // kassa tasumise peakirje
    FCurrPaymentConfirmed: boolean; // avamisel hoiame lipu püsti, kas oli juba eelnevalt kinnitatud
    FCurrPaymentAccRecId: integer;  // kassa finantskannete peakirje
    FSkipOnChangeEvent: boolean;
    FSkipScrollEvent: boolean;
    FNewRecord: boolean; // kas loogi uus kirje !
    FUsrItemsChanged: boolean; // ntx valiti arve või muudeti seda
    FMiscItemsChanged: boolean; // varia rida
    FDataNotSaved: boolean;

    FActiveEditor: TWinControl;
    FLastCashRegisterAccId: integer; // konto päises; vaikimisi KASSA
    FReqCurrUpdate: TRequestForCurrUpdate;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;

    FreportDefPath: AStr;
    // -- hoiame infot valitud kliendi kohta
    FPClientData: TClientData;
    FPPrevClientID: integer; // -- ntx olukord, kus avati eelsalvestatud kassa kanne, aga vahetati klient ära
    // -- siis peame sisuliselt kõik valitud elemendid "tühistama", mis olid seotud eelmise kliendiga
    // -- peame kuidagi muudatuse tuvastama !

    procedure OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
    procedure OnLookupComboSelect(Sender: TObject);
    procedure OnLookupComboChange(Sender: TObject);
    procedure OnLookupComboEnter(Sender: TObject);
    procedure OnLookupComboExit(Sender: TObject);
    procedure OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
    // ---
    procedure performCleanup;
    procedure getBOTypesPerCashRegisterMode(var pBillType: AStr; var pOrderType: AStr);


    procedure qryOpenCashRegPayment(const ppaymentId: integer);
    procedure qryPaymentData(const ppaymentID: integer);
    procedure qryPaymentMiscSum(const ppaymentID: integer);

    procedure cpyCustomerMiscDataToDataset(const pClientData: TClientData);
    function calculatePaymentTotalSum(var pPmtSum: double; // arve valuutas
      var pDiff: double; // baasvaluuta
      var pDescr: AStr): boolean;  // --

    procedure calculatePaymentMiscItemsTotalSum(var pPmtSum: double; var pDescr: AStr);
    procedure changePaymentSumAndDescr(const updateDescrField: boolean = True);
    procedure reloadCustomerData(const pClientId: integer; const pdispSrcForm: boolean = True);

    function detectAccDataChange(): boolean;

    function resolveAccName(const pAccId: integer; var pDefaultCurr: AStr): AStr;
    procedure createAccountingRecords(const pMainAccRecId: integer; const pClientId: integer);

    function chooseCorrectPaymentMgrMode: TPaymentMode;
    procedure cancelPaymentAccRecs(const pPaymentAccMainRecId: integer);


    procedure managePaymentItems(const pPaymentID: integer; const pTrackChanges: Tcollection);

    function preparePrintData: boolean; // kasutame printimisel ridade puhverdamiseks !
    function saveCashRegPayment: boolean;

    procedure refreshUICurrList(const pCurrDate: TDatetime);
    function getClientId: integer;
    procedure setClientId(const pClientId: integer);

    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);

    procedure doOnClickFix(Sender: TObject);

    // ---
    // 12.06.2011 Ingmar
    procedure OnOvrEditorExit(Sender: TObject);
    procedure OnOvrEditorExit2(Sender: TObject);
  public
    procedure callNewCashRegEvent();
    procedure callNewCashRegEventExt(const pClientId: integer; const pBillId: integer);
    // --
    procedure openCashRegPayment(const ppaymentId: integer);
    procedure createNewPayment;

    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property onAskCurrencyDownload: TRequestForCurrUpdate read FReqCurrUpdate write FReqCurrUpdate;
    property clientId: integer read getClientId write setClientId;
    property reportDefPath: AStr read FreportDefPath write FreportDefPath;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

const
  CLeftHiddenCorn = -100;

const
  CCol_itemNr = 0;
  CCol_dueDate = 1;
  CCol_sumtoPay = 2;
  CCol_incomings = 3;
  CCol_toPay = 4;
  CCol_currency = 5;
  CCol_spltSum = 6;
  CCol_itemChecked = 7;

const
  CCol2_descr = 0;
  CCol2_sum = 1;
  CCol2_account = 2;

const
  CLazFixDbGridFocus = 1;
  CLazFixLookupFocus = 2;

{
const
  CLookupKeyField   = 'account_coding';
  CLookupSpltsum    = 'splt_sum';
  CCurrencyKeyField = 'currency';
}

// ---
const
  CCmb_indexIncpOrder = 0;
  CCmb_indexOutpOrder = 1;
//CCmb_indexMoneyFromBank = 2;
//CCmb_indexMoneyToBank = 3;

procedure TframeCashRegister.callNewCashRegEvent();
begin
  self.createNewPayment;
end;

procedure TframeCashRegister.callNewCashRegEventExt(const pClientId: integer; const pBillId: integer);
var
  pCurrCustID: integer;
  pBookmark: Tbookmark;
begin

  self.createNewPayment;
  // --
  pCurrCustID := pClientId;
  self.reloadCustomerData(pCurrCustID, False); // aken mitte kuvada !

  // @@@
  if dbGridAllItems.CanFocus then
    dbGridAllItems.SetFocus;

  // --
  try
    pBookmark := qryGetUserPmtItems.GetBookmark;
    qryGetUserPmtItems.DisableControls;

    // märgistame arve valituks !
    if qryGetUserPmtItems.Locate('id', integer(pBillId), []) then
    begin
      //self.dbGridAllItems.SelectedColumn.Index:=CCol_itemChecked;
      self.dbGridAllItems.SelectedIndex := CCol_itemChecked;
      self.dbGridAllItemsCellClick(dbGridAllItems.Columns.Items[CCol_itemChecked]);
    end;


  finally
    qryGetUserPmtItems.GotoBookmark(pBookmark);
    qryGetUserPmtItems.FreeBookmark(pBookmark);
    // --
    qryGetUserPmtItems.EnableControls;
  end;
end;

procedure TframeCashRegister.openCashRegPayment(const ppaymentId: integer);
var
  pCurrName: AStr;
  pCurrVal: double;
begin
  self.performCleanup;
  self.qryOpenCashRegPayment(ppaymentId);


  // algne klient !
  self.FPPrevClientID := qryCashRegister.FieldByName('client_id').AsInteger;

  // --- peale ka kliendi andmed küsima...kui need olemas...
  if (ppaymentID > 0) and (qryCashRegister.FieldByName('client_id').AsInteger > 0) then
    self.FPClientData := estbk_fra_customer.getClientDataWUI_uniq(qryCashRegister.FieldByName('client_id').AsInteger);



  qryCashRegister.AfterScroll(qryCashRegister);


  self.FCurrPaymentID := ppaymentId;
  self.FCurrPaymentAccRecId := qryCashRegister.FieldByName('accounting_register_id').AsInteger;
  self.FCurrPaymentConfirmed := pos(estbk_types.CPaymentRecStatusClosed, qryCashRegister.FieldByName('status').AsString) > 0;

  estbk_utilities.changeWCtrlEnabledStatus(grpboxLg, not qryCashRegister.EOF);

  //estbk_utilities.changeWCtrlEnabledStatus(cmbCurrency,False);
  estbk_utilities.changeWCtrlEnabledStatus(dtPmtDate, False);

  estbk_utilities.changeWCtrlReadOnlyStatus(grpboxLg, self.FCurrPaymentConfirmed);


  pVerifiedChkbox.Checked := self.FCurrPaymentConfirmed;
  pVerifiedChkbox.Enabled := True;
  lblVerified.Enabled := True;


  self.btnOpenAccEntry.Enabled := self.FCurrPaymentConfirmed;


  self.qryPaymentData(ppaymentId);
  self.qryPaymentMiscSum(ppaymentId);


  // laeme päevakursid !
  estbk_clientdatamodule.dmodule.revalidateCurrObjVals(dtPmtDate.date, self.FCurrList);


  // küsime uuesti kurssi !
  pCurrName := qryCashRegister.FieldByName('currency').AsString;
  cmbCurrencyList.ItemIndex := cmbCurrencyList.Items.IndexOf(pCurrName);

  // 04.04.2011 Ingmar; peame kuvama siiski maksega seotud kursi !
  pcurrVal := qryCashRegister.FieldByName('currency_drate_ovr').AsFloat;
  if pcurrVal > 0.00 then
    TCurrencyObjType(self.cmbCurrencyList.Items.Objects[cmbCurrencyList.ItemIndex]).currVal := pCurrVal
  else
    pcurrVal := TCurrencyObjType(self.cmbCurrencyList.Items.Objects[cmbCurrencyList.ItemIndex]).currVal;
  // ---
  pLblcurrVal.Caption := #32 + format(CCurrentAmFmt4, [double(pcurrVal)]);

  // 05.04.2011 Ingmar
  btnPrint.Enabled := pVerifiedChkbox.Checked;
end;


procedure TframeCashRegister.OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix();
end;


procedure TframeCashRegister.OnLookupComboChange(Sender: TObject);
begin
  // ---
end;

procedure TframeCashRegister.OnLookupComboSelect(Sender: TObject);
begin
  if TRxDBLookupCombo(Sender).Tag = 0 then
  begin
    // 13.07.2012 Ingmar; cancel puhul tekib viga...
    if not qryGetPaymentMiscItems.Active then
      exit; // !!


    if not (qryGetPaymentMiscItems.State in [dsEdit, dsInsert]) then
      qryGetPaymentMiscItems.Edit;

    self.FLcmpAccountCode := qryGetAccounts.FieldByName('account_coding').AsString;

    // ---
    qryGetPaymentMiscItems.FieldByName('account_coding').AsString := self.FLcmpAccountCode;
    qryGetPaymentMiscItems.FieldByName('account_id').AsInteger := qryGetAccounts.FieldByName('id').AsInteger;
    TRxDBLookupCombo(Sender).Text := self.FLcmpAccountCode;

    // ---
    self.FLazFocusFixFlags := CLazFixLookupFocus;
    self.lazFocusFix.Enabled := True;
  end;

end;

procedure TframeCashRegister.OnLookupComboEnter(Sender: TObject);
begin
  // ---
end;

procedure TframeCashRegister.OnLookupComboExit(Sender: TObject);
begin
  // ---
end;

procedure TframeCashRegister.OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Shift = []) then
    case key of
      VK_LEFT: if assigned(self.FSelectedCol) then
        begin
          miscSumDbGrid.SelectedIndex := self.FSelectedCol.Index - 1;
          key := 0; // 02.03.2013 Ingmar
          exit;
        end; // --

      VK_DELETE: if qryGetPaymentMiscItems.Active then  // 24.02.2013 Ingmar
          try
            TRxDBLookupCombo(Sender).Tag := -1;
            //estbk_utilities.rxLibKeyDownHelper(TRxDBLookupCombo(Sender),Key,Shift);
            self.FLcmpAccountCode := '';


            qryGetPaymentMiscItems.Edit;
            qryGetPaymentMiscItems.FieldByName('account_coding').AsString := '';
            qryGetPaymentMiscItems.FieldByName('account_id').AsInteger := 0;
            qryGetPaymentMiscItems.Post;

            TRxDBLookupCombo(Sender).Value := '';
            TRxDBLookupCombo(Sender).Text := '';

            if miscSumDbGrid.CanFocus then
              miscSumDbGrid.SetFocus;

            if TRxDBLookupCombo(Sender).CanFocus then
              TRxDBLookupCombo(Sender).SetFocus;


          finally
            TRxDBLookupCombo(Sender).Tag := 0;
          end;

      VK_RETURN:
      begin
        self.changePaymentSumAndDescr();
        key := 0;

        if pVerifiedChkbox.CanFocus then
          pVerifiedChkbox.SetFocus;
        Exit; // ---<
      end;
    end;


  // ---
  self.miscSumDbGridKeyDown(Sender, key, shift);
end;



procedure TframeCashRegister.getBOTypesPerCashRegisterMode(var pBillType: AStr; var pOrderType: AStr);
begin
  case cmbTransType.ItemIndex of
    CCmb_indexIncpOrder:
    begin
      pBillType := estbk_types._CItemSaleBill;
      pOrderType := estbk_types._COAsSaleOrder;
    end;

    CCmb_indexOutpOrder:
    begin
      pBillType := estbk_types._CItemPurchBill;
      pOrderType := estbk_types._COAsPurchOrder;
    end;
  end; // ---
end;

procedure TframeCashRegister.qryOpenCashRegPayment(const ppaymentId: integer);
begin
  with qryCashRegister, SQL do
  begin
    Close;
    Clear;
    add(estbk_sqlclientcollection._SQLSelectPayment);
    paramByname('id').AsInteger := ppaymentID;
    paramByname('payment_type').AsString := estbk_types.CPayment_ascashreg;
    paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    Open;
  end;
end;



// ARVED / TELLIMUSED
procedure TframeCashRegister.qryPaymentData(const ppaymentID: integer);
var
  pBillType: AStr;
  pOrderType: AStr;
begin
  with qryGetUserPmtItems, SQL do
  begin
    self.getBOTypesPerCashRegisterMode(pBillType, pOrderType);

    Close;
    Clear;
    add(estbk_sqlclientcollection._SQLGetDataForPayment(self.clientId, ppaymentID, estbk_globvars.glob_company_id, pBillType, pOrderType));
    Open;
    if RecordCount < 1 then
      dbGridAllItems.DataSource := nil
    else
      dbGridAllItems.DataSource := qryGetUserPmtItemsDs;
  end;
end;


procedure TframeCashRegister.qryPaymentMiscSum(const ppaymentID: integer);
begin

  // 24.02.2013 Ingmar; seda pole küll vaja, tekitab autoinsert evendi ! performcleanup teeb töö ära !
  //self.FAccounts.Text:='';
  //self.FAccounts.Value:='';

  // @@@
  with qryGetPaymentMiscItems, SQL do
  begin
    Close;
    Clear;
    add(estbk_sqlclientcollection._SQLGetPaymentDataMiscSum(ppaymentID));
    Open;
  end;
  // --

end;


procedure TframeCashRegister.performCleanup;
var
  pIndex: integer;
  pEvtPtr: TNotifyEvent;
  pDatasrc: TDataSource;
begin
  try
    self.FSkipOnChangeEvent := True;
    //  if btnOpenClientList.CanFocus then
    //     btnOpenClientList.SetFocus;

    self.FLiveEditor := nil;
    FRepItemVatSumTotal := 0.00;
    FRepItemSumTotal := 0.00;
    FRepItemDescr := '';

    FLazFocusFixFlags := 0;
    FUsrItemsChanged := False;
    FMiscItemsChanged := False;

    lazFocusFix.Enabled := False;
    self.FActiveEditor := nil;

    self.FSelectedCol := nil;
    self.FLcmpAccountCode := '';
    self.FPPrevClientID := 0;

    if assigned(self.FPClientData) then
      FreeAndNil(self.FPClientData);


    self.FNewRecord := False;
    self.FDataNotSaved := False;
    self.FCurrPaymentConfirmed := False;


    self.dbGridAllItems.Hint := '';
    self.dtPmtDate.Date := date;
    self.dtPmtDate.Text := datetostr(self.dtPmtDate.date);


    self.edtrecpname.Hint := '';
    // 24.02.2013 Ingmar; ei eventidele; teevad rumalusi cleanupis !
    pEvtPtr := lookupcmbCashRegister.OnChange;
    pDatasrc := lookupcmbCashRegister.DataSource;
    lookupcmbCashRegister.DataSource := nil;
    lookupcmbCashRegister.OnChange := nil;
    lookupcmbCashRegister.Text := '';
    // taastame
    lookupcmbCashRegister.DataSource := pDatasrc;
    lookupcmbCashRegister.OnChange := pEvtPtr;

    //dbLookupComboDebit.Text := '';
    lblAccDName.Caption := '';
    //lblAccDName.Caption := '';



    pVerifiedChkbox.Checked := False;
    pLblCurrVal.Caption := #32 + format(CCurrentAmFmt4, [double(1)]);
    // ---
    //self.tarbCtrlPmtOrder.ActivePage := tabPmtOrder;



    // ---
    pIndex := cmbCurrencyList.items.indexOf(estbk_globvars.glob_baseCurrency);
    if pIndex >= 0 then
      cmbCurrencyList.ItemIndex := pIndex;



    pimgisverifiedclient.Picture.Clear;
    pimgisverifiedclient.Hint := '';
    edtrecpname.Hint := '';

    // 24.02.2013 Ingmar; et evendid tõmblema ei hakkaks !
    pDatasrc := self.FAccounts.DataSource;
    pEvtPtr := self.FAccounts.OnChange;
    self.FAccounts.OnChange := nil;
    self.FAccounts.DataSource := nil;
    self.FAccounts.Value := '';
    self.FAccounts.Text := '';
    self.FAccounts.OnChange := pEvtPtr; // ja tagasi
    self.FAccounts.DataSource := pDatasrc;


    cmbTransType.ItemIndex := CCmb_indexIncpOrder;

    // ---
  finally
    self.FSkipOnChangeEvent := False;
  end;
end;


// sub
procedure TframeCashRegister.cpyCustomerMiscDataToDataset(const pClientData: TClientData);
var
  pOpenEdtSession: boolean;
begin

  pOpenEdtSession := not (qryCashRegister.State in [dsEdit, dsInsert]);
  if pOpenEdtSession then
    qryCashRegister.Edit;

  if assigned(pClientData) then
  begin
    // infoks kliendi id/ regkood
    self.edtrecpname.Hint := IntToStr(pClientData.FClientId);

    if pClientData.FCustRegNr <> '' then
      self.edtrecpname.Hint := self.edtrecpname.Hint + ' / ' + pClientData.FCustRegNr;


    qryCashRegister.FieldByName('client_id').AsInteger := self.clientId;
    // ---
    qryCashRegister.FieldByName('client_name2').AsString := pClientData.FCustFullName;
    qryCashRegister.FieldByName('payment_rcv_account_nr').AsString := pClientData.FCustBankAccount;
  end
  else
  begin
    self.edtrecpname.Hint := '';
    qryCashRegister.FieldByName('client_id').AsInteger := self.clientId;
    qryCashRegister.FieldByName('client_name2').AsString := '';
    qryCashRegister.FieldByName('payment_rcv_account_nr').AsString := '';
  end;


  if pOpenEdtSession then
    qryCashRegister.Post;
end;


// TODO vii antud koodid ühte protseduuri, see hack pole ilus !
function TframeCashRegister.calculatePaymentTotalSum(var pPmtSum: double; // arve valuutas
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
  pPaymentCurrRate: double;
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


    pIndex := cmbCurrencyList.ItemIndex;
    if pIndex >= 0 then
      pCurrRate := TCurrencyObjType(cmbCurrencyList.items.Objects[pIndex]).currVal;


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
        pIndex := self.FCurrList.IndexOf(qryGetUserPmtItems.FieldByName('currency').AsString);
        assert(pIndex >= 0, '#5');


        pPaymentCurrRate := TCurrencyObjType(self.FCurrList.Objects[pIndex]).currVal;
        if pPaymentCurrRate = 0 then
        begin
          pPaymentCurrRate := 1;
          if qryGetUserPmtItems.FieldByName('currency').AsString <> estbk_globvars.glob_baseCurrency then
          begin
            // parem karta, kui kahetseda
            pPmtSum := 0;
            pDiff := 0;
            Dialogs.messageDlg(format(estbk_strmsg.SEMissingCurrVal, [qryGetUserPmtItems.FieldByName('currency').AsString]), mtError, [mbOK], 0);
            Exit;

          end;
        end;



        pPmtTempDiff := roundto(double(pToPaySum * pBillCurrRate), Z2) - roundto(double(pToPaySum * pPaymentCurrRate), Z2);
        // ----
        if pCurrRate > 0 then
        begin
          pDiff := pDiff + roundto(pPmtTempDiff / double(pCurrRate), Z2);
          pPmtSumTotal := roundto(double(pToPaySum * pPaymentCurrRate) / double(pCurrRate), Z2);
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
          pDescr := pDescr + format(CSSaleBillNr, [qryGetUserPmtItems.FieldByName('nr').AsString]);
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

procedure TframeCashRegister.calculatePaymentMiscItemsTotalSum(var pPmtSum: double; var pDescr: AStr);
var
  pCBookMark: TBookmark;
  pFiltStatus: boolean;
  i: integer;
begin
  try
    pDescr := '';
    // ---
    pCBookMark := qryGetPaymentMiscItems.getbookMark;

    qryGetPaymentMiscItems.DisableControls;

    pFiltStatus := qryGetPaymentMiscItems.Filtered;
    qryGetPaymentMiscItems.Filtered := False;
    qryGetPaymentMiscItems.First;

    i := 0;
    while not qryGetPaymentMiscItems.EOF do
    begin
      pPmtSum := pPmtSum + qryGetPaymentMiscItems.FieldByName('splt_sum').AsCurrency;
      if (i > 0) and (pDescr <> '') then
        pDescr := pDescr + ';';
      pDescr := pDescr + qryGetPaymentMiscItems.FieldByName('item_descr').AsString;

      qryGetPaymentMiscItems.Next;
      Inc(i);
    end;
    // ---
  finally
    qryGetPaymentMiscItems.Filtered := pFiltStatus;
    if assigned(pCBookMark) then
    begin
      qryGetPaymentMiscItems.GotoBookmark(pCBookMark);
      qryGetPaymentMiscItems.FreeBookmark(pCBookMark);
    end;

    // ---
    qryGetPaymentMiscItems.EnableControls;
  end;
end;


procedure TframeCashRegister.changePaymentSumAndDescr(const updateDescrField: boolean = True);
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
      if self.calculatePaymentTotalSum(pBOSum, pCurrDiff, pDescr1) then
      begin
        self.calculatePaymentMiscItemsTotalSum(pMiscSum, pDescr2);
        pTotalSum := roundto(pBOSum + pMiscSum, Z2);
      end;

      // -----
      pTrigEdt := not (qryCashRegister.state in [dsEdit, dsInsert]);


      // --
      if pTrigEdt then
        qryCashRegister.Edit;

      pDescrCnt := pDescr1;
      if pDescr2 <> '' then
      begin
        if pDescrCnt <> '' then
          pDescrCnt := pDescrCnt + ';';
        pDescrCnt := pDescrCnt + pDescr2;
      end;

      // --------
      qryCashRegister.FieldByName('sumtotal').AsCurrency := pTotalSum;

      if updateDescrField then
        qryCashRegister.FieldByName('descr').AsString := pDescrCnt;
      // --------


    finally

      // ----
      if pTrigEdt then
        qryCashRegister.Post;
    end;


  except
    on e: Exception do
      Dialogs.messageDlg(format(estbk_strmsg.SECalcFailed2, [e.message]), mtError, [mbOK], 0);
  end;
end;

procedure TframeCashRegister.reloadCustomerData(const pClientId: integer; const pdispSrcForm: boolean = True);

var
  pNewClientData: TClientData;
  pOpenEdtSession: boolean;
  pReloadClientData: boolean;
  pBmp: TBitmap;
  pCust: AStr;

begin
  pNewClientData := nil;
  if pVerifiedChkbox.Checked then
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


    // --------------------------------
    self.changePaymentSumAndDescr();
    // --------------------------------
    pCust := self.FPClientData.FClientCode;
    if self.FPClientData.FCustRegNr <> '' then
      pCust := pCust + ' (' + self.FPClientData.FCustRegNr + ')';

    pimgisverifiedclient.Hint := pCust;
  end
  else
  // me ei vaja neid puhverdatud andmeid !
  if assigned(pNewClientData) then
    FreeAndNil(pNewClientData);



  // --- kopeerime ka andmed koheselt dataseti
  if pReloadClientData then
  begin

    self.cpyCustomerMiscDataToDataset(self.FPClientData);

    if self.FNewRecord then
      self.qryPaymentData(0)
    else
      self.qryPaymentData(self.FCurrPaymentID);
  end;
  // ---
end;

procedure TframeCashRegister.pVerifiedChkboxChange(Sender: TObject);
var
  pDoSaveData: boolean;
begin

  with TCheckBox(Sender) do
    if not self.FSkipOnChangeEvent and Focused then
      try


        Tag := 0;
        pDoSaveData := False;
        self.FSkipOnChangeEvent := True;
        // --

        if not self.FNewRecord then
        begin

          if self.FCurrPaymentConfirmed then
          begin

            // küsime ikka üle, kas tõesti kinnitus maha !
            if not Checked then
            begin

              // --
              if Dialogs.messageDlg(estbk_strmsg.SConfReopenPayment, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
              begin
                estbk_utilities.changeWCtrlReadOnlyStatus(grpboxLg, Checked);
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
          if self.saveCashRegPayment() then
          begin
            self.qryPaymentData(self.FCurrPaymentID);
          end
          else
            Checked := not Checked;
        // ---
      finally
        FSkipOnChangeEvent := False;
        Tag := -1;
      end;
end;

procedure TframeCashRegister.rcornerimgClick(Sender: TObject);
begin

end;

procedure TframeCashRegister.dbGridAllItemsPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
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

procedure TframeCashRegister.dbGridAllItemsSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
begin
  if assigned(Editor) then
    Editor.Font.Color := clWindowText;


  if Editor is TStringCellEditor then
  begin
    if (Column.Index = CCol_spltSum) then
    begin
      TStringCellEditor(Editor).Alignment := taRightJustify;
      //TStringCellEditor(Editor).SelectAll;
    end
    else
      TStringCellEditor(Editor).Alignment := taLeftJustify;
  end;


  // 16.06.2011 Ingmar
  self.FLiveEditor := Editor;
end;

procedure TframeCashRegister.edtrecpnameChange(Sender: TObject);
begin
  // kuna autocomplete siin puudub nagu laekumistes, siis muutmisel oletame, et tegemist täiesti uue kliendiga / registreerimata !
  with TDbEdit(Sender) do
    if Focused and (Tag <> -1) then
    begin
      pimgisverifiedclient.Hint := '';
      edtrecpname.Hint := '';

      if assigned(FPClientData) then
      begin
        self.cpyCustomerMiscDataToDataset(nil);
        self.qryPaymentData(-1);


        pimgisverifiedclient.Picture.Clear;
        FreeAndNil(FPClientData);
        FPPrevClientID := 0;
      end;
      // ---
    end;
end;

procedure TframeCashRegister.edtrecpnameKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
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

procedure TframeCashRegister.miscSumDbGridCellClick(Column: TColumn);
begin
  // 02.03.2013 Ingmar;fix et kontod tuleks pidevalt, mitte suvaliselt hetkel
  {
  if Column.Index=CCol2_account then
    begin
       self.FActiveEditor:=self.FAccounts;
       self.FActiveEditor.Visible:=true;
    if self.FActiveEditor.CanFocus then
       self.FActiveEditor.SetFocus;

    end;
   }
end;

procedure TframeCashRegister.miscSumDbGridColEnter(Sender: TObject);
begin
  if not pVerifiedChkbox.Checked then
    with TDbGrid(Sender).DataSource.DataSet do
    begin

      if Active and not (State in [dsEdit, dsInsert]) then
        Edit;

      self.FSelectedCol := TDbGrid(Sender).SelectedColumn;

      // lazaruse jätkub fookuse kalad !
   {
   02.03.2013 Ingmar
   if TDbGrid(sender).CanFocus then
      TDbGrid(sender).SetFocus;}

    end; // --
end;

procedure TframeCashRegister.miscSumDbGridColExit(Sender: TObject);
var
  pNewSession: boolean;
begin

  if not pVerifiedChkbox.Checked then
    with TDbGrid(Sender).DataSource.DataSet do
      if assigned(self.FSelectedCol) and (FSelectedCol.Index = CCol2_account) then
        try
          //pNewSession:=not (State in [dsEdit,dsInsert]);
          self.FAccounts.Visible := False;
          //if State in [dsEdit,dsInsert] then
          //Post; // kinnitame sisestused;


          // ja paneme andmed uuesti peale
          Edit;
          // --- igasugu trikke tuleb teha, et lazaruse bugidest mööda hiilida !
          self.FSelectedCol.Field.AsString := self.FLcmpAccountCode;

        finally
          if State in [dsEdit, dsInsert] then
            Post;
        end;


  // 22.07.2011 Ingmar; arvutame ka summa !
  if assigned(FSelectedCol) and (FSelectedCol.Index = CCol2_sum) then
    self.changePaymentSumAndDescr();
end;

procedure TframeCashRegister.miscSumDbGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
begin

  if (Column.Index = CCol2_account) and (gdFocused in State) then
  begin
    self.FAccounts.SetBounds(Rect.Left,
      Rect.Top,
      (Rect.Right - Rect.Left) - 1,
      (Rect.Bottom - Rect.Top) - 3);

  end;
  TDbGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TframeCashRegister.miscSumDbGridEnter(Sender: TObject);
begin
  if not self.FAccounts.Visible and not self.FCurrPaymentConfirmed and pVerifiedChkbox.Checked and
    //  24.02.2013 Ingmar; nende lippude eksisteerimine näitab juba, et ära tee midagi !
    not self.FSkipScrollEvent and not self.FSkipOnChangeEvent then

    with TDbGrid(Sender).DataSource.DataSet do
      if Active and (not (State in [dsEdit, dsInsert])) and (RecordCount = 0) then
      begin
        Insert; // autoinsert...
      end;
end;

procedure TframeCashRegister.miscSumDbGridExit(Sender: TObject);
begin
  try

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

  except
    on e: Exception do
   {$ifdef debugmode}
      ShowMessage('miscSumDbGridExit:' + e.message);
   {$endif}
  end;
end;

procedure TframeCashRegister.miscSumDbGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  lazFocusFix.Enabled := False;

  // -- ps dblookupcombo kasutab sama eventi !
  if (((key = VK_RETURN) or (key = VK_TAB)) and (shift = [])) then
  begin
    if (Sender is TDbGrid) then
      with TDbGrid(Sender) do
      begin

        //      PerformTab(true);
        // if assigned(SelectedColumn) and (SelectedColumn.Index<Columns.Count-1) then
        // Columns.Items[1].Field.FocusControl;
        // FLazFocusFixFlags:=CLazFixDbGridFocus;
        // lazaruse kala !
        // Kui enter või tab vajutada, siis kenasti liigub järgmise columni peale,
        // AGA TDbGrid kaotab fookuse !

        if assigned(SelectedColumn) and (SelectedColumn.Index = Columns.Count - 1) then
        begin
          // PerformTab(true);
          // TODO: peame otsima, kellele fookus saata otse setFocus abil !
          // miskitpärast ei tule igakord editor nähtavale !!!!!"
          if not self.FAccounts.Visible then
          begin
            self.FAccounts.Visible := True;
            FLazFocusFixFlags := CLazFixLookupFocus;
            lazFocusFix.Enabled := True;
          end;

          key := 0; // ***
        end
        else
        begin
          key := VK_RIGHT;
        end;

        // -- et alati editor oleks korrektne !
        //miscSumDbGrid.Invalidate;
      end
    else
    if (Sender is TRxDBLookupCombo) then
    begin
      // TODO: peame otsima, kellele fookus saata otse setFocus abil !
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

procedure TframeCashRegister.miscSumDbGridKeyPress(Sender: TObject; var Key: char);
begin
  if pVerifiedChkbox.Checked then
    key := #0
  else

  if assigned(TDbGrid(Sender).SelectedColumn) and (TDbGrid(Sender).SelectedColumn.Index = CCol2_sum) then
  begin

    if key in ['+', '-'] then
      key := #0
    else
    if key in [',', '.'] then // et ikka õige võetaks !
      key := SysUtils.DecimalSeparator;
    edit_verifyNumericEntry(TDbGrid(Sender).EditorByStyle(cbsAuto) as TCustomEdit, key, True);
  end;
end;

procedure TframeCashRegister.miscSumDbGridSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
var
  pNewEdtSession: boolean;
  pDefaultEditor: TWinControl;
begin
  self.FActiveEditor := nil;
  // @@@
  pDefaultEditor := miscSumDbGrid.EditorByStyle(cbsAuto);
  Editor := pDefaultEditor;

  // ---
  if (Column.Index = CCol2_account) then
  begin

    // @@@
    // kinnitatud kassa makse puhul ei kasuta default editori !
    if not pVerifiedChkbox.Checked then
    begin

      if self.FAccounts.LookupSource.DataSet.Locate('id', TDbGrid(Sender).DataSource.DataSet.FieldByName('account_id').AsInteger, []) then
        self.FAccounts.Text := self.FAccounts.LookupSource.DataSet.FieldByName('account_coding').AsString
      else
      begin
        self.FAccounts.Text := '';
        self.FAccounts.Value := '';
      end;

      self.FLazFocusFixFlags := CLazFixLookupFocus;
      self.FActiveEditor := self.FAccounts;
      // --
    end;

    //Column.ReadOnly:=false;
    // Editor:=nil;
  end;


  if not assigned(self.FActiveEditor) then
  begin
    self.FActiveEditor := pDefaultEditor; // ---
    self.FLazFocusFixFlags := CLazFixDbGridFocus;
  end;


  // @@@
  // 16.06.2011 Ingmar
  if self.FActiveEditor is TStringCellEditor then
  begin
    if (Column.Index = CCol2_sum) then
    begin
      TStringCellEditor(Editor).Alignment := taRightJustify;
      //TStringCellEditor(Editor).SelectAll;
      //TStringCellEditor(Editor).SelStart:=length(TStringCellEditor(Editor).Text);
    end
    else
      TStringCellEditor(Editor).Alignment := taLeftJustify;
  end; // ---


  // paneme paika siis editori, mis aktiivne !
  Editor := self.FActiveEditor;
  if assigned(Editor) then
  begin
    Editor.OnKeyDown := @self.miscSumDbGridKeyDown;
    lazFocusFix.Enabled := True; // TDbGrid(sender).Focused;
  end;
end;

procedure TframeCashRegister.qryCashRegisterAfterInsert(DataSet: TDataSet);
begin
  self.FNewRecord := True;
  DataSet.FieldByName('payment_type').AsString := estbk_types.CPayment_ascashreg;
  DataSet.FieldByName('company_id').AsInteger := estbk_globvars.glob_company_id;
end;

procedure TframeCashRegister.qryCashRegisterAfterScroll(DataSet: TDataSet);
begin
  // 24.02.2013 Ingmar
  if self.FSkipScrollEvent then
    Exit; // !

  self.lookupcmbCashRegisterSelect(lookupcmbCashRegister);
  if not DataSet.Active or (DataSet.FieldByName('payment_date').AsString = '') then
    dtPmtDate.Text := ''
  else
  begin

    // --
    if not self.FNewRecord then
    begin
      dtPmtDate.date := DataSet.FieldByName('payment_date').AsDateTime;
      dtPmtDate.Text := datetostr(dtPmtDate.date);
      dbEdtDocNr.Text := DataSet.FieldByName('payment_nr').AsString;
      pVerifiedChkbox.Checked := pos(estbk_types.CPaymentRecStatusClosed, DataSet.FieldByName('status').AsString) > 0;
      //  sissetuleku order
      if DataSet.FieldByName('document_type_id').AsInteger = _ac.sysDocumentId[_dsReceiptVoucherDocId] then
        cmbTransType.ItemIndex := CCmb_indexIncpOrder
      else
      // väljamineku order
      if DataSet.FieldByName('document_type_id').AsInteger = _ac.sysDocumentId[_dsPaymentVoucherDocId] then
        cmbTransType.ItemIndex := CCmb_indexOutpOrder;
    end;
  end;
end;

procedure TframeCashRegister.qryCashRegisterBeforeEdit(DataSet: TDataSet);
begin
  if not self.FSkipOnChangeEvent then
  begin
    self.btnNewPayment.Enabled := False;
    self.btnSave.Enabled := True;
    self.btnCancel.Enabled := True;
  end; // ---
end;

procedure TframeCashRegister.qryGetPaymentMiscItemsAfterEdit(DataSet: TDataSet);
begin
  btnNewPayment.Enabled := False;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
end;

procedure TframeCashRegister.qryGetPaymentMiscItemsAfterPost(DataSet: TDataSet);
begin
  self.changePaymentSumAndDescr();
  // ---
  self.FMiscItemsChanged := True;
  self.FDataNotSaved := True;


  // 16.06.2011 Ingmar
  if assigned(self.FActiveEditor) and self.FActiveEditor.Visible and not (self.FActiveEditor is TRxDBLookupCombo) then
    self.FActiveEditor.Visible := False;
end;

procedure TframeCashRegister.qryGetPaymentMiscItemsBeforeEdit(DataSet: TDataSet);
begin
  // @@@
  if Dataset.EOF or (not self.FNewRecord and pVerifiedChkbox.Checked) then
    abort;
end;

procedure TframeCashRegister.qryGetPaymentMiscItemsBeforeInsert(DataSet: TDataSet);
begin
  // @@@
end;

procedure TframeCashRegister.qryGetPaymentMiscItemsBeforePost(DataSet: TDataSet);
begin
  if DataSet.active then
  begin
    if not self.FNewRecord then
      DataSet.FieldByName('payment_id').AsInteger := self.FCurrPaymentID;
    DataSet.FieldByName('status').AsString := '';
    // ---
  end;
end;

procedure TframeCashRegister.qryGetUserPmtItemsAfterPost(DataSet: TDataSet);
begin
  self.changePaymentSumAndDescr();
  // ---
  self.FUsrItemsChanged := True;
  self.FDataNotSaved := True;

  // 16.06.2011 Ingmar
  if assigned(self.FLiveEditor) and self.FLiveEditor.Visible and not (self.FLiveEditor is TRxDBLookupCombo) then
    self.FLiveEditor.Visible := False;
end;

procedure TframeCashRegister.qryGetUserPmtItemsBeforeEdit(DataSet: TDataSet);
begin
  if Dataset.EOF or (not self.FNewRecord and pVerifiedChkbox.Checked) then
    abort;
end;

procedure TframeCashRegister.dbGridAllItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
var
  pData: AStr;
  pts: TTextStyle;
  pBitmap: Tbitmap;
begin

  with TDbGrid(Sender) do
    if assigned(DataSource) and not DataSource.DataSet.IsEmpty and assigned(Column.Field) then
    begin
      Canvas.FillRect(Rect);
      pts := Canvas.TextStyle;
      pts.Alignment := taLeftJustify;
      Canvas.TextStyle := pts;
      Canvas.Font.Color := clWindowText;

      if (gdSelected in State) then
      begin
        Canvas.Brush.Color := clBackGround;
      end
      else
      begin
        Canvas.Brush.Color := clWindow;
      end;


      if Column.Index = CCol_currency then
      begin
        Canvas.TextStyle := pts;


        pData := Column.Field.AsString;
        if pData = '' then
          pData := estbk_globvars.glob_baseCurrency;
        Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, trim(pData), Canvas.TextStyle);
      end
      else
      if Column.Index in [CCol_sumtoPay, CCol_toPay, CCol_incomings, CCol_spltSum] then
      begin
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

          if estbk_utilities.isTrueVal(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString) then
            dmodule.sharedImages.GetBitmap(img_indxItemChecked, pBitmap)
          else
            dmodule.sharedImages.GetBitmap(img_indxItemUnChecked, pBitmap);
          Canvas.Draw(Rect.Left + 5, Rect.Top + 2, pBitmap);
        finally
          FreeAndNil(pBitmap);
        end
      else
        DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
end;

procedure TframeCashRegister.dbGridAllItemsCellClick(Column: TColumn);
var
  pNewSession: boolean;
  pbStatus: boolean;
begin
  // @@
  if self.pVerifiedChkbox.Checked or qryGetUserPmtItems.EOF then
    exit;


  // --
  if assigned(dbGridAllItems) and assigned(dbGridAllItems.SelectedColumn) and (dbGridAllItems.SelectedColumn.Index = CCol_itemChecked) and
    assigned(column) then
    try


      pNewSession := not (qryGetUserPmtItems.State in [dsEdit, dsInsert]);
      // --
      if pNewSession then
        qryGetUserPmtItems.Edit;


      pbStatus := not estbk_utilities.isTrueVal(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString);
      // ---
      qryGetUserPmtItems.FieldByName('lsitemhlp').AsString := estbk_types.SCFalseTrue[pbStatus];

      if pbStatus then
        qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency := qryGetUserPmtItems.FieldByName('to_pay').AsCurrency
      else
        qryGetUserPmtItems.FieldByName('splt_sum').Value := null;
      dbGridAllItems.Repaint;

    finally
      if pNewSession then
        qryGetUserPmtItems.Post;
    end;
end;

procedure TframeCashRegister.cmbTransTypeChange(Sender: TObject);
begin
  // --
  if self.FNewRecord and assigned(FPClientData) then
  begin
    if self.FPClientData.FClientId > 0 then
      self.qryPaymentData(0); // kliendi ID võtab ta klassi skoobist !
  end;
end;

procedure TframeCashRegister.btnOpenClientListClick(Sender: TObject);
var
  pCurrCustID: integer;
begin
  pCurrCustID := 0;
  if assigned(self.FPClientData) then
    pCurrCustID := self.FPClientData.FClientId;

  self.reloadCustomerData(pCurrCustID);

  if dbGridAllItems.CanFocus then
    dbGridAllItems.SetFocus;
end;

procedure TframeCashRegister.btnPrintClick(Sender: TObject);
var
  b: boolean;
  pRepDef: AStr;
begin
  b := preparePrintData;
  if b then
  begin
    // ---
    case cmbTransType.ItemIndex of
      CCmb_indexIncpOrder: pRepDef := includetrailingbackslash(self.reportDefPath) + estbk_reportconst.CIncOrderReportFilename;
      CCmb_indexOutpOrder: pRepDef := includetrailingbackslash(self.reportDefPath) + estbk_reportconst.COutOrderReportFilename;
    end;

    if not FileExists(pRepDef) then
      raise Exception.createFmt(estbk_strmsg.SEReportDataFileNotFound, [pRepDef]);

    frreport.LoadFromFile(pRepDef);
    //qInvoiceReport.ShowProgress:=true;
    frreport.ShowReport;
  end
  else
    Dialogs.MessageDlg(estbk_strmsg.SERepSourceDataIsInvalid, mtError, [mbOK], 0);
end;

function TframeCashRegister.detectAccDataChange(): boolean;
begin
  Result := False;
  if not self.FNewRecord then
  begin

    // ZEOSE kala !!! kui tegemist täiesti uue kirjega, siis saab vea listindex out of bounds !
    // ohutum on str tüüpi võrdlust teha variantide puhul !
    Result := (vartoStr(qryCashRegister.FieldByName('c_account_id').OldValue) <> // konto muutunud
      vartoStr(qryCashRegister.FieldByName('c_account_id').Value)) or (vartoStr(qryCashRegister.FieldByName('d_account_id').OldValue) <>
      vartoStr(qryCashRegister.FieldByName('d_account_id').Value)) or (vartoStr(qryCashRegister.FieldByName('sumtotal').OldValue) <>
      vartoStr(qryCashRegister.FieldByName('sumtotal').Value)) or


      // 12.03.2011 Ingmar;
      (vartoStr(qryCashRegister.FieldByName('client_id').OldValue) <> vartoStr(qryCashRegister.FieldByName('client_id').Value)) or
      (cmbCurrencyList.Text <> qryCashRegister.FieldByName('currency').AsString);


    // -------

    Result := Result or self.FUsrItemsChanged or self.FMiscItemsChanged;
    Result := Result or (vartoStr(qryCashRegister.FieldByName('payment_date').OldValue) <>
      qryCashRegister.FieldByName('payment_date').AsString);


    Result := Result or (vartoStr(qryCashRegister.FieldByName('document_nr').OldValue) <> qryCashRegister.FieldByName('document_nr').AsString);
  end;  // ---
end;


function TframeCashRegister.resolveAccName(const pAccId: integer; var pDefaultCurr: AStr): AStr;
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


// - KASSA KANDED !
//Raha laekumine kassasse pangast
//D kassa K pank

//Raha kassast panka
//D pank K kassa

//Arve laekumine kliendilt kassasse:
//D Kassa K ostjate võlgnevus

//Ostuarve tasumine kassast:
//D hankijate võlg K Kassa

// "nagu" tasumised...
procedure TframeCashRegister.createAccountingRecords(const pMainAccRecId: integer; const pClientId: integer);

  function getAccLineType(const pIsAggrLine: boolean = False): AStr;
  begin

    case cmbTransType.ItemIndex of
      CCmb_indexIncpOrder:
        //CCmb_indexMoneyToBank: // sissetulekuorder...
        Result := estbk_types.CAccRecTypeAsCredit;

      CCmb_indexOutpOrder: // väljaminekuorder...
        //CCmb_indexMoneyFromBank: // Raha laekumine kassasse pangast
        Result := estbk_types.CAccRecTypeAsDebit;
    end;

    // -- kokkuvõttev rida !
    if pIsAggrLine then
    begin
      if Result = estbk_types.CAccRecTypeAsCredit then
        Result := estbk_types.CAccRecTypeAsDebit
      else
        Result := estbk_types.CAccRecTypeAsCredit;
    end;

  end; // -->
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
  pToPaySum: double;
  pItemBookmark: TBookmark;
  pItemIndx, i: integer;

  pAccId: integer;
  // ---
  pIndex: integer;
  pDefCurr: AStr;
  pLineDescr: AStr;
  //pPaymentStatus : Astr;

  pFiltstatus: boolean;
  pFiltOrigStr: Astr;
  // --
  // pAccEntry  : TIntAddAccountingEntry;
  pPmtMgr: TPaymentManager;
  pPmtAccRec: TPaymentAccData;
  pAccountCurr: Astr;

begin
  try



    pPmtMgr := TPaymentManager.Create(self.chooseCorrectPaymentMgrMode, self.FCurrList);
    pPmtMgr.accMainRec := pMainAccRecId;



    // ennem kui üldse mingeid kirjeid tekitame vaatame valuuta kohe üle !
    if (cmbCurrencyList.ItemIndex >= 0) and (cmbCurrencyList.Text <> estbk_globvars.glob_baseCurrency) then
    begin
      pItemIndx := cmbCurrencyList.ItemIndex;
      pCurrRate := TCurrencyObjType(self.FCurrList.Objects[pItemIndx]).currVal;
      pCurrencyId := TCurrencyObjType(self.FCurrList.Objects[pItemIndx]).id;
      pCurrency := cmbCurrencyList.Text;
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

      qryGetPaymentMiscItems.DisableControls;
      pItemBookmark := qryGetPaymentMiscItems.GetBookmark;


      qryGetPaymentMiscItems.First;
      while not qryGetPaymentMiscItems.EOF do
      begin

        pPmtAccRec := pPmtMgr.addAccEntry(-1, __pmtItemAsUnknown); // !!


        //pAccEntry:=TIntAddAccountingEntry.Create;
        pAccId := qryGetPaymentMiscItems.FieldByName('account_id').AsInteger;
        pLineDescr := copy(trim(qryGetPaymentMiscItems.FieldByName('item_descr').AsString), 1, 255);
        pPmtAccRec.descr := pLineDescr;


        // --- varia read sõltuvad reziimist !!!
        // 06.12.2012 Ingmar
        pPmtAccRec.recType := getAccLineType();   // estbk_types.CAccRecTypeAsCredit;
        pPmtAccRec.accountId := pAccId;


        pPmtAccRec.descr := pLineDescr;
        pPmtAccRec.sum := qryGetPaymentMiscItems.FieldByName('splt_sum').AsCurrency;
        pPmtAccRec.clientId := pClientId;


        // -- maksekorralduse valuuta
        pPmtAccRec.pmtItemCurrIdentf := pCurrency;
        pPmtAccRec.pmtItemCurrID := pCurrencyId; // tähendab tuleb võtta jooksev kurss
        pPmtAccRec.pmtItemCurrRate := pCurrRate;



        // raamatupidamiskonto valuuta !!!!
        pDefCurr := trim(qryGetPaymentMiscItems.FieldByName('default_currency').AsString);
        if pDefCurr = '' then
          pDefCurr := estbk_globvars.glob_baseCurrency;



        pPmtAccRec.currencyRate := 0;
        pPmtAccRec.currencyIdentf := pDefCurr;
        pPmtAccRec.currencyID := -1; // st tuleb võtta jooksev kurss nimistust !

        // ----
        qryGetPaymentMiscItems.Next;
      end;
    finally

      if assigned(pItemBookmark) then
      begin
        qryGetPaymentMiscItems.Gotobookmark(pItemBookmark);

        qryGetPaymentMiscItems.FreeBookmark(pItemBookmark);
        qryGetPaymentMiscItems.EnableControls;
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
            pIndex := self.FCurrList.IndexOf(qryGetUserPmtItems.FieldByName('currency').AsString);
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
                    >> enam pole vaja nüüd teeb trigger selle töö ära !

                    if pIncomeSum=0 then
                       pPaymentStatus:=estbk_types.CBillPaymentUd
                    else
                    if(pIncomeSum=pToPaySum) or (pCalcPrpBalance>0) then
                       pPaymentStatus:=estbk_types.CBillPaymentOk
                    else
                    if pIncomeSum<pToPaySum then
                       pPaymentStatus:=estbk_types.CBillPaymentPt;
                    }

            // -----------------------------------------------------
            // ARVE / TELLIMUSEGA seotud kanded
            // -----------------------------------------------------


            pPmtAccRec := pPmtMgr.addAccEntry(qryGetUserPmtItems.FieldByName('id').AsInteger, __pmtItemAsBill); // !!!
            pAccId := qryGetUserPmtItems.FieldByName('account_id').AsInteger;

            //pLineDescr:=self.resolveAccName(pAccId);
            pLineDescr := format(estbk_strmsg.CSSaleBillNR, [qryGetUserPmtItems.FieldByName('nr').AsString]);


            // kontoga seotud valuuta !!!
            pDefCurr := qryGetUserPmtItems.FieldByName('default_currency').AsString;
            if pDefCurr = '' then
              pDefCurr := estbk_globvars.glob_baseCurrency;


            pPmtAccRec.accountId := pAccId;
            pPmtAccRec.recType := getAccLineType();




            // ---
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

              // ----
              pAccId := _ac.sysAccountId[_accSupplPrePayment];
              self.resolveAccName(pAccId, pAccountCurr);

              // --
              pLineDescr := format(estbk_strmsg.CSSaleBillnr, [qryGetUserPmtItems.FieldByName('nr').AsString]);


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
            // ---
          end
          else
          // tellimus on alati ettemaks !!!!!!
          if AnsiUpperCase(qryGetUserPmtItems.FieldByName('litemtype').AsString) = estbk_types.CCommTypeAsOrder then
          begin

            pNewSum := qryGetUserPmtItems.FieldByName('splt_sum').AsCurrency; // sum


            // baasvaluuta
            // -----

            pPmtAccRec := pPmtMgr.addAccEntry(qryGetUserPmtItems.FieldByName('id').AsInteger, __pmtItemAsOrder); // !!!


            pAccId := _ac.sysAccountId[_accSupplPrePayment]; // ETTEMAKSU KONTO !
            // vaja teada konto valuutat !
            self.resolveAccName(pAccId, pAccountCurr);




            pLineDescr := format(estbk_strmsg.CSOrderNr, [qryGetUserPmtItems.FieldByName('nr').AsString]);
            // ----
            pPmtAccRec.accountId := pAccId;
            //pPmtAccRec.recType:=estbk_types.CAccRecTypeAsCredit;
            pPmtAccRec.recType := getAccLineType();




            pPmtAccRec.descr := pLineDescr;
            pPmtAccRec.sum := pNewSum;
            pPmtAccRec.isPrepayment := True;
            pPmtAccRec.clientId := pClientId;


            pToPaySum := qryGetUserPmtItems.FieldByName('to_pay2').asCurrency;
                    {
                       Jällegit selle töö teeb nüüd ära trigger !
                    if pNewSum>=pToPaySum then
                       pPaymentStatus:=estbk_types.COrderPaymentOk
                    else
                    if pNewSum>0 then
                       pPaymentStatus:=estbk_types.COrderPaymentPt
                    else
                       pPaymentStatus:=estbk_types.COrderPaymentUd;
                       //pPmtAccRec.pretermPmtStatus:=pPaymentStatus;
                    }

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




    // -----------------------------------------------------------------
    // KOONDSUMMA !!!
    // -----------------------------------------------------------------
    pPmtAccRec := pPmtMgr.addAccEntry(-1, __pmtItemAsUnknown); // !!


    pAccId := qryGetCashRegAccounts.FieldByName('id').AsInteger;
    pAccountCurr := qryGetCashRegAccounts.FieldByName('default_currency').AsString;



    // -- kande kirje klass
    pPmtAccRec.accountId := pAccId; // !!!!!
    pPmtAccRec.recType := getAccLineType(True);
    pPmtAccRec.descr := copy(mDescr.Lines.Text, 1, 255);



    // --- kannete kogusumma
    pPmtAccRec.sum := qryCashRegister.FieldByName('sumtotal').asCurrency;


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

    // pPmtMgr.writeEntryLog('c:\test.txt');

    pPmtMgr.doSaveAccEntrys;

  finally
    FreeAndNil(pPmtMgr); // -->
  end;
end;

// - KASSA KANDED !
//Raha laekumine kassasse pangast
//D kassa K pank

//Raha kassast panka
//D pank K kassa

//Arve laekumine kliendilt kassasse:  - laekumine
//D Kassa K ostjate võlgnevus

//Ostuarve tasumine kassast:          - tasumine
//D hankijate võlg K Kassa

function TframeCashRegister.chooseCorrectPaymentMgrMode: TPaymentMode;
begin
  case cmbTransType.ItemIndex of
    CCmb_indexIncpOrder: Result := __pmtModeAsIncome;
    CCmb_indexOutpOrder: Result := __pmtModeAsPayment;
    else
      Result := __pmtModeAsUnknown;
  end;
  //  CCmb_indexMoneyFromBank = 2;
  //  CCmb_indexMoneyToBank = 3;
end;

procedure TframeCashRegister.cancelPaymentAccRecs(const pPaymentAccMainRecId: integer);
var
  pPayment: TPaymentManager;
begin
  try
    pPayment := TPaymentManager.Create(self.chooseCorrectPaymentMgrMode, self.FCurrList); // PS vaata tüüp üle !  __pmtModeAsPmtOrder
    pPayment.accMainRec := pPaymentAccMainRecId;
    pPayment.doCancelAllEntrys(pPaymentAccMainRecId);
  finally
    FreeAndNil(pPayment);
  end;
end;

procedure TframeCashRegister.managePaymentItems(const pPaymentID: integer; const pTrackChanges: Tcollection);
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


    // kõige ebameeldivam olukord üldse...maksekorralduse klient vahetati ära...ehk...kõik eelnevad read annuleerida
    if not self.FNewRecord and (self.FPPrevClientID <> self.clientId) then
      with qryDataWriter, SQL do
        try
          // esmalt jätame meelde muudatused ! sest peame arvetelt ja tellimustelt need summad maha võtma !
          // kanded tehakse alati uuesti !
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLSelectOrderPmtData2);
          paramByname('payment_id').AsInteger := pPaymentID;
          Open;
          First;
          // @@@
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
          paramByname('payment_id').AsInteger := pPaymentID;
          execSQL;


        finally
          Close;
          Clear;
        end;



    pBookMark := qryGetUserPmtItems.getBookmark;
    qryGetUserPmtItems.DisableControls;



    // siiski esmalt võrdleme, kas tasumise kogusumma = valitud elementidega !
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
        with qryDataWriter, SQL do
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
        with qryDataWriter, SQL do
          try

            Close;
            Clear;
            add(estbk_sqlclientcollection._SQLInsertPaymentData);
            paramByname('id').AsInteger := estbk_clientdatamodule.dmodule.qryPaymentDataSeq.GetNextValue;
            paramByname('payment_id').AsInteger := pPaymentID;
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

function TframeCashRegister.saveCashRegPayment: boolean;
const
  CPmtCreateNewAccRec = 1;
  CPmtCancelAccRecEntrys = 2;
  CPmtCreateNewAccEntrys = 4;
  CPmtUpdateAccRec = 8;

var
  pAccPeriodID: integer;
  pMainAccRecID: integer;
  pDocType: TSystemDocType;
  // lipud, kuidas kandekirjet muudame uuendame
  pAccRecordBehavior: integer;
  // ---
  pDocId: int64;
  pAccDesc: AStr;
  pSQL: AStr;
  // ---
  pOnlyDocNrDateChanged: boolean;
  pVerifBalance: double;
  pTempCalc: double;
  pCurrVal: double;
  pTrackChanges: TCollection;
  pAccNr: AStr;
begin

  Result := False;
  lazFocusFix.Enabled := False;
  self.FAccounts.Visible := False;


  // --
  pTempCalc := 0;


  // -- et arvutaks total sumi ära !!! lõpetame kõik evendid !
  if (qryGetPaymentMiscItems.State in [dsEdit, dsInsert]) then
    qryGetPaymentMiscItems.Post;

  if (qryGetUserPmtItems.State in [dsEdit, dsInsert]) then
    qryGetUserPmtItems.Post;


  if self.clientId < 1 then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEClientNotFound, mtError, [mbOK], 0);
    if edtrecpname.canFocus then
      edtrecpname.SetFocus;
    Exit;
  end;


  if trim(dtPmtDate.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEEmptyDate, mtError, [mbOK], 0);
    if dtPmtDate.canFocus then
      dtPmtDate.SetFocus;
    // ---
    Exit;
  end;

  if dtPmtDate.Date > date then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEDateInFuture, mtError, [mbOK], 0);
    if dtPmtDate.canFocus then
      dtPmtDate.SetFocus;
    // ---
    Exit;
  end;

  if trim(lookupcmbCashRegister.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEAccountNotChoosen, mtError, [mbOK], 0);
    if lookupcmbCashRegister.canFocus then
      lookupcmbCashRegister.SetFocus;

    // ---
    Exit;
  end;


  if (qryCashRegister.FieldByName('sumtotal').AsCurrency <= 0) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEPmtOrderSumIsEqOrLessZ, mtError, [mbOK], 0);
    exit;
  end;




  // TODO: tulevikus tee normaalne dateedit komponent; kuupäev paika ka datasetis !
  // ---
  if not (qryCashRegister.state in [dsEdit, dsInsert]) then
    qryCashRegister.Edit;
  // ---


  qryCashRegister.FieldByName('payment_date').AsDateTime := dtPmtDate.date;
  if pVerifiedChkbox.Checked then
    qryCashRegister.FieldByName('status').AsString := estbk_types.CPaymentRecStatusClosed
  else
    qryCashRegister.FieldByName('status').AsString := estbk_types.CPaymentRecStatusOpen;
  qryCashRegister.FieldByName('currency').AsString := cmbCurrencyList.Text;

  pCurrVal := TCurrencyObjType(self.cmbCurrencyList.Items.Objects[cmbCurrencyList.ItemIndex]).currVal;
  qryCashRegister.FieldByName('currency_drate_ovr').AsFloat := pCurrVal;


  // -------
  // otsime raamatupidamisperioodi pearaamatu kande jaoks !!!! Antud funktsioon ise nö kuvab vaikimisi teateid !
  pAccRecordBehavior := 0;

  pAccPeriodID := estbk_clientdatamodule.dmodule.getAccoutingPerId(dtPmtDate.date);
  if pAccPeriodID < 1 then
    Exit;




  // salvestame andmed
  with estbk_clientdatamodule.dmodule do
    try

      primConnection.StartTransaction;

      // pearaamatu baaskirje ID !!!!
      pMainAccRecID := self.FCurrPaymentAccRecId;




      // 11.03.2011 Ingmar; kannete loogika natuke muutus; kui vajutatakse checkboxis kinnita, siis luuakse koheselt kanded
      // peamise kirje võib luua ! kui sinna alla ei pane lihtsalt kandeid !!!!!
      if self.FNewRecord then
      begin
        pAccRecordBehavior := pAccRecordBehavior or CPmtCreateNewAccRec; // luuakse kande aluskirje !
        if pVerifiedChkbox.Checked then
          pAccRecordBehavior := pAccRecordBehavior or CPmtCreateNewAccEntrys;
      end
      else
      // maksekorraldus kinnitati, tekitame kanded ning märgime arved laekunuks jne
      if not self.FCurrPaymentConfirmed and pVerifiedChkbox.Checked then
      begin
        pAccRecordBehavior := pAccRecordBehavior or CPmtCreateNewAccEntrys; // luuakse kanded
      end
      else
      // ---- maksekorraldus oli eelnevalt kinnitatud, aga seoti lahti...järelikult,
      // - kõik kanded annuleerida
      // - arvetel võtta maha laekumise tunnused, samuti ettemaks
      if self.FCurrPaymentConfirmed and not pVerifiedChkbox.Checked then
      begin
        pAccRecordBehavior := pAccRecordBehavior or CPmtCancelAccRecEntrys; // tühistatakse kanded
      end;




      // --
      // detectAccDataChange kas muutusid mingid andmed, mis tähendaks finantskande ümber tegemist
      if not ((pAccRecordBehavior and CPmtCreateNewAccRec) = CPmtCreateNewAccRec) and self.detectAccDataChange() then
      begin

        pAccRecordBehavior := pAccRecordBehavior or CPmtUpdateAccRec;
        // ---
        // 09.04.2010 Ingmar; ainult kinnitatud korralduste puhul !
        // tühistame kanderead !
        if self.FCurrPaymentConfirmed then
          pAccRecordBehavior := pAccRecordBehavior or CPmtCancelAccRecEntrys;
      end;




      // KANDE ÜLDINE KIRJELDUS
      pAccDesc := cmbTransType.Text + ' ' + dbEdtDocNr.Text;




      // ---- jätame võimaluse juhtida inserte;
      if (pAccRecordBehavior and CPmtCreateNewAccRec) = CPmtCreateNewAccRec then
      begin
        self.FCurrPaymentAccRecId := 0;
        pMainAccRecID := 0;
        pDocId := 0;
        pAccNr := '';

        // valime välja õige dokumendi tüübi !
        case cmbTransType.ItemIndex of
          CCmb_indexIncpOrder:
          begin
            pDocType := _dsReceiptVoucherDocId;
            // 19.07.2011 Ingmar
            // 29.02.2012 Ingmar;numeraatorite reform
            pAccNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', dtPmtDate.date,
              False, estbk_types.CAccCri_rec_nr);
          end;

          CCmb_indexOutpOrder:
          begin
            pDocType := _dsPaymentVoucherDocId;
            // 19.07.2011 Ingmar
            pAccNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', dtPmtDate.date,
              False, estbk_types.CAccCro_rec_nr);
          end
          else
            pDocType := _dsMemDocId;
        end;

        // -- dmodule funktsioon !
        if not createNewGenLedgerMainRec(pAccPeriodID,  // rp. period
          dtPmtDate.Date,// kande kuupäev
          pAccDesc,      // kirjeldus pearaamatu päises
          pDocType, dbEdtDocNr.Text, // dokumendi nr
          estbk_types.CAddRecIdentAsCashReg, pMainAccRecID,
          // mingi hetk ei saanud enam klassi propertyt anda var parameetrisse !!
          pDocId, pAccNr) then
          abort;


        // ---
        self.FCurrPaymentAccRecId := pMainAccRecID;


        if not (qryCashRegister.State in [dsEdit, dsInsert]) then
          qryCashRegister.Edit;


        // --
        qryCashRegister.FieldByName('accounting_register_id').AsInteger := pMainAccRecID;
        qryCashRegister.FieldByName('payment_nr').AsString := dbEdtDocNr.Text;
        qryCashRegister.FieldByName('client_id').AsInteger := self.clientId;

      end
      else
      if (pAccRecordBehavior and CPmtUpdateAccRec) = CPmtUpdateAccRec then
      begin

        // -- dmodule funktsioon
        if not updateGenLedgerMainRec(self.FCurrPaymentAccRecId, // kirje mida uuendame
          dtPmtDate.Date,              // kande kuupäev
          pAccDesc,                  // pearaamatu kirjeldus
          dbEdtDocNr.Text            // dokumendi nr
          ) then
          abort;

      end;



      // kui vaja, siis tühistame kõik kande kirjed !
      if (pAccRecordBehavior and CPmtCancelAccRecEntrys) = CPmtCancelAccRecEntrys then
      begin

        // 09.04.2010 Ingmar; ainult kinnitatud korralduste puhul !
        if self.FCurrPaymentConfirmed then
        begin
          self.cancelPaymentAccRecs(pMainAccRecID);
        end; // ----------
      end;


      // --
      if (pAccRecordBehavior and CPmtCreateNewAccEntrys) = CPmtCreateNewAccEntrys then
      begin

        // et oleks ikka korrektne lõplik summa !!!! kaasa arvatud kursivahe !!!!
        self.changePaymentSumAndDescr();
        // -----------------------

        self.createAccountingRecords(self.FCurrPaymentAccRecId, self.clientId);

      end; // ---




      // --------------------------------
      // tavaline salvestus...läbi cache...

      qryCashRegister.ApplyUpdates;




      // paneme uue loodud kirje ID ka paika !
      if self.FNewRecord then
        self.FCurrPaymentID := qryCashRegister.FieldByName('id').AsInteger; // qryPmtOrderSeq.GetCurrentValue;



      //qryGetMiscPmtItemsUptInst.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdatePmtOrderDataStatus);
      //qryGetMiscPmtItemsUptInst.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertPmtOrderData2);

      // kas A) kõikidele kirjetele käsitsi omistada pmtorderId
      //     B) modify SQL kavalalt ära muuta


      pSQL := stringreplace(estbk_sqlclientcollection._SQLInsertPaymentData2, ':payment_id', IntToStr(self.FCurrPaymentID), []);
      //pSQL:=stringreplace(estbk_sqlclientcollection._SQLUpdatePmtOrderDataStatus,':payment_order_id',inttostr(self.FCurrPmtOrderID),[]);



      qryGetPaymentMiscItemsUpdIns.InsertSQL.Clear;
      qryGetPaymentMiscItemsUpdIns.InsertSQL.add(pSQL);
      // --


      try
        // -- vastavalt reziimile seome või tühistame maksekorraldusega seotud arved/tellimused
        // valitud elemendid (arved/tellimused) ja nende "jaotatud" summad !!!!
        pTrackChanges := TCollection.Create(TTrackItemChanges);

        self.managePaymentItems(self.FCurrPaymentId, pTrackChanges);
      finally
        FreeAndNil(pTrackChanges);
      end;




      // -------------------------------------------------------
      // käsitsi koostatud read !
      // -------------------------------------------------------

      qryGetPaymentMiscItems.ApplyUpdates;


      // ---
      primConnection.Commit;

      // 19.05.2011 Ingmar
      dmodule.markNumeratorValAsUsed(PtrUInt(self), CCSRegister_doc_recnr, dbEdtDocNr.Text, dtPmtDate.Date);

      // 11.05.2012 Ingmar; ma olin ära unustanud numeraatori reserveerimise tühistamise
      if (trim(pAccNr) <> '') and pVerifiedChkbox.Checked then
        case cmbTransType.ItemIndex of
          CCmb_indexIncpOrder: dmodule.markNumeratorValAsUsed(PtrUInt(self), estbk_types.CAccCri_rec_nr, pAccNr, dtPmtDate.Date);
          CCmb_indexOutpOrder: dmodule.markNumeratorValAsUsed(PtrUInt(self), estbk_types.CAccCro_rec_nr, pAccNr, dtPmtDate.Date);
        end;


      // ---
      qryCashRegister.CommitUpdates;
      qryGetPaymentMiscItems.CommitUpdates;



      self.FLastCashRegisterAccId := qryGetCashRegAccounts.FieldByName('id').AsInteger;
      self.FCurrPaymentConfirmed := pVerifiedChkbox.Checked;




      Result := True;

      if btnNewPayment.CanFocus then
        btnNewPayment.SetFocus;




      // laeme maksekorraldusega seotud andmed uuesti, et vältida probleemi salvestamisel !!! just makse kinnitamisel !
      // ala; salvestatakse, checkbox valitud, uuesti salvestatakse
      if self.clientId > 0 then
        self.qryPaymentData(self.FCurrPaymentID)
      else
        self.qryPaymentData(-1);
      self.qryPaymentMiscSum(self.FCurrPaymentID);



      // nuppude staatus ära muuta
      btnSave.Enabled := False;
      btnCancel.Enabled := False;
      btnNewPayment.Enabled := True;



      pVerifiedChkbox.Enabled := True;
      lblVerified.Enabled := True;

      //estbk_utilities.changeWCtrlEnabledStatus(cmbCurrency,False);
      estbk_utilities.changeWCtrlEnabledStatus(dtPmtDate, False);
      estbk_utilities.changeWCtrlReadOnlyStatus(grpboxLg, pVerifiedChkbox.Checked);
      //estbk_utilities.changeWCtrlReadOnlyStatus(pPanel,chkboxConfPmtDone.checked);



      // taastame õige insert !
      if self.FNewRecord then
      begin
        qryGetPaymentMiscItemsUpdIns.InsertSQL.Clear;
        qryGetPaymentMiscItemsUpdIns.InsertSQL.add(estbk_sqlclientcollection._SQLInsertPaymentData2);
      end;



      // ---
      self.FNewRecord := False;
      cmbCurrencyList.Enabled := not pVerifiedChkbox.Checked;
      // ---
      btnOpenAccEntry.Enabled := (self.FCurrPaymentAccRecId > 0) and (pVerifiedChkbox.Checked);



      if FAccounts.Visible then
        FAccounts.Visible := False;




      // 31.08.2010 Ingmar
      self.FPPrevClientID := self.clientId;




      btnPrint.Enabled := pVerifiedChkbox.Checked;
      // ---
      cmbTransType.Enabled := False;

      if assigned(self.onFrameDataEvent) then
        self.onFrameDataEvent(self,
          estbk_types.__framePaymentChanged,
          self.FCurrPaymentId,
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

procedure TframeCashRegister.btnSaveClick(Sender: TObject);
begin
  self.saveCashRegPayment();
end;



// teeme ajutise tabeli, mis võtab kokku nö tasutud elemendid; mis point oleks uus päring andmebaasi teha ?
function TframeCashRegister.preparePrintData: boolean;
var
  pBookmark: TBookmark;
  pBookmark2: TBookmark;
  pIncSum: double;
begin
  Result := False;
  // ----
  try
    pBookmark := qryGetUserPmtItems.GetBookmark;
    pBookmark2 := qryGetPaymentMiscItems.GetBookmark;

    qryGetUserPmtItems.DisableControls;
    qryGetPaymentMiscItems.DisableControls;

    self.FRepItemVatSumTotal := 0.00;
    self.FRepItemSumTotal := 0.00;
    self.FRepItemDescr := '';

    // ---
    // esmalt arve / tellimuse read !
    qryGetUserPmtItems.First;

    // ma pole selles loogikas just eriti kindel !
    while not qryGetUserPmtItems.EOF do
    begin

      if estbk_utilities.isTrueVal(qryGetUserPmtItems.FieldByName('lsitemhlp').AsString) then
      begin
        // ma ei oska midagi mõelda, ntx arve tasutakse osaliselt !? samuti arvel mitu käibemaksu...
        // osaliselt tasutud arvetel mina käibemaksu välja ei too !
        pIncSum := qryGetUserPmtItems.FieldByName('incomesum').AsFloat + qryGetUserPmtItems.FieldByName('prepaidsum').AsFloat;
        if (Math.roundto(qryGetUserPmtItems.FieldByName('splt_sum').AsFloat, Z2) = Math.roundto(
          qryGetUserPmtItems.FieldByName('to_pay').AsFloat, Z2)) or
          ((Math.roundto(qryGetUserPmtItems.FieldByName('to_pay').AsFloat, Z2) = 0) and
          (Math.roundto(qryGetUserPmtItems.FieldByName('splt_sum').AsFloat, Z2) = pIncSum)) then
        begin
          self.FRepItemSumTotal := self.FRepItemSumTotal + qryGetUserPmtItems.FieldByName('sumwvat').AsFloat;
          self.FRepItemVatSumTotal := self.FRepItemVatSumTotal + qryGetUserPmtItems.FieldByName('vatsum').AsFloat;
        end
        else
        begin
          // self.FRepItemVatSumTotal  ma ei tea ju siin käibemaksu summat ! osaliselt arve tasumine, seal võib olla N käibemaksumäära ju !
          self.FRepItemSumTotal := self.FRepItemSumTotal + qryGetUserPmtItems.FieldByName('splt_sum').AsFloat;
        end;



        if self.FRepItemDescr <> '' then
          self.FRepItemDescr := self.FRepItemDescr + ';';


        if qryGetUserPmtItems.FieldByName('litemtype').AsString = estbk_types.CCommTypeAsBill then
          self.FRepItemDescr := self.FRepItemDescr + format(estbk_strmsg.CSSaleBillNr, [qryGetUserPmtItems.FieldByName('nr').AsString])
        else
          self.FRepItemDescr := self.FRepItemDescr + format(estbk_strmsg.CSOrderNr, [qryGetUserPmtItems.FieldByName('nr').AsString]);
        Result := True;
      end; // ---
      // ---
      qryGetUserPmtItems.Next;
    end;


    // VARIA elemendid...
    qryGetPaymentMiscItems.First;
    while not qryGetPaymentMiscItems.EOF do
    begin

      // --
      if qryGetPaymentMiscItems.FieldByName('splt_sum').AsFloat > 0 then
      begin
        if self.FRepItemDescr <> '' then
          self.FRepItemDescr := self.FRepItemDescr + ';';
        self.FRepItemSumTotal := self.FRepItemSumTotal + qryGetPaymentMiscItems.FieldByName('splt_sum').AsFloat;
        Result := True;
      end; // --
      qryGetPaymentMiscItems.Next;
    end;



  finally
    if assigned(pBookmark) then
    begin
      qryGetUserPmtItems.GotoBookmark(pBookmark);
      qryGetUserPmtItems.FreeBookmark(pBookmark);
    end;

    qryGetUserPmtItems.EnableControls;

    if assigned(pBookmark2) then
    begin
      qryGetPaymentMiscItems.GotoBookmark(pBookmark2);
      qryGetPaymentMiscItems.FreeBookmark(pBookmark2);
    end;

    qryGetPaymentMiscItems.EnableControls;
  end; // ---
end;


procedure TframeCashRegister.cmbCurrencyListChange(Sender: TObject);
begin
  if TComboBox(Sender).Focused then
    self.refreshUICurrList(dtPmtDate.date);
end;

procedure TframeCashRegister.cmbTransTypeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeCashRegister.dbGridAllItemsColExit(Sender: TObject);
begin
  with TDBGrid(Sender) do
    if assigned(SelectedColumn) and (SelectedColumn.Index = CCol_spltSum) and DataSource.DataSet.Active and
      (DataSource.DataSet.State in [dsEdit, dsInsert]) then
      DataSource.DataSet.Post;
end;

// 11.06.2011 Ingmar
procedure TframeCashRegister.dbGridAllItemsEnter(Sender: TObject);
begin
  // dbGridAllItems.SelectedIndex:=CCol_itemChecked;
end;

procedure TframeCashRegister.refreshUICurrList(const pCurrDate: TDatetime);
var
  pCurrData: TDate;
  pCurrFnd: boolean;
  pItemIndex: integer;
begin
  if dtPmtDate.Text <> '' then
    try
      // pCurrData := pmtDate.date;

      pCurrData := pCurrDate; // pmtDate.Date;
      pItemIndex := cmbCurrencyList.ItemIndex;

      // kui kuupäev ei klapi laeme uuesti  daysBetween on ohutum kasutada !!!
      if dateutils.daysBetween(TCurrencyObjType(self.FCurrList.Objects[0]).currDate, pCurrData) <> 0 then
      begin

        // võtame ja vaatame
        pCurrFnd := estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pCurrData, self.FCurrList);
        // valuutakurssi ei leitud !
        if not pCurrFnd then
          if assigned(self.onAskCurrencyDownload) then
          begin
            self.onAskCurrencyDownload(self, pCurrData);
            estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pCurrData, self.FCurrList); // küsime uuesti kurssi !
          end;
      end;

      // --
      if pItemIndex >= 0 then
        pLblCurrVal.Caption := #32 + format(CCurrentAmFmt4, [TCurrencyObjType(cmbCurrencyList.items.Objects[pItemIndex]).currVal])
      else
        pLblCurrVal.Caption := '';



      // --- kirjeldus pole vaja uuendada
      self.changePaymentSumAndDescr(False);

    except
      on e: Exception do
        if (e is EAbort) then
          estbk_utilities.miscResetCurrenyValList(cmbCurrencyList)
        else
          raise;
    end;
end;



procedure TframeCashRegister.dtPmtDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
begin
  if ADate <= now then
    self.refreshUICurrList(ADate)
  else
    estbk_utilities.miscResetCurrenyValList(cmbCurrencyList);
end;

procedure TframeCashRegister.dtPmtDateExit(Sender: TObject);
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
        estbk_utilities.miscResetCurrenyValList(cmbCurrencyList);
    end;
end;

procedure TframeCashRegister.frreportGetValue(const ParName: string; var ParValue: variant);
const
  SCompanyName = '@scompanyname';
  SCompanyData = '@scompanydata';
  SCPmtnumber = '@scpmtnumber';
  SCPmtdate = '@scpmtdate';
  SCPmttotalsum = '@scpmttotalsum';
  SCPayername = '@scpayername';
  SCPayerAddress = '@scpayeraddress';
  SCPmtBase = '@scpmtbase';
  SCItemSumtotal = '@scitemsumtotal';
  SCItemVatSumtotal = '@scitemvatsumtotal';
  SCPmtSumInWords = '@scpmtsuminwords';
  SCCurrYear = '@sccurryear';
var
  v: AStr;
  pTemp: AStr;
begin
  ParValue := '';
  v := ansilowercase(ParName);
  if v = SCompanyName then
    ParValue := estbk_globvars.glob_currcompname
  else
  if v = SCompanyData then
  begin
    // Printides kassa sissetuleku või väljamineku orderit puudub firma reg nr.
    pTemp := '';
    if estbk_globvars.glob_currcompregcode <> '' then
      pTemp := estbk_strmsg.SCRegCode + ' ' + estbk_globvars.glob_currcompregcode + CRLF;
    pTemp := pTemp + estbk_globvars.glob_currcompaddr;

    ParValue := pTemp;
  end
  else
  if v = SCPmtnumber then
    ParValue := dbEdtDocNr.Text
  else
  if v = SCPmtdate then
    ParValue := datetostr(dtPmtDate.Date)
  else
  if v = SCPmttotalsum then
    ParValue := format(estbk_types.CCurrentMoneyFmt2, [qryCashRegister.FieldByName('sumtotal').asCurrency])
  else
  if v = SCPayername then
    ParValue := FPClientData.FCustFullName
  else
  if v = SCPayerAddress then
    ParValue := estbk_utilities.miscGenBuildAddr(FPClientData.FCustJCountry, FPClientData.FCustJCounty,
      FPClientData.FCustJCity, FPClientData.FCustJStreet, FPClientData.FCustJHouseNr, FPClientData.FCustJApartNr,
      FPClientData.FCustJZipCode, addr_pmtorderfmt)
  else
  if v = SCPmtBase then
    ParValue := self.FRepItemDescr
  else
  if v = SCItemSumtotal then
    ParValue := format(estbk_types.CCurrentMoneyFmt2, [self.FRepItemSumTotal])
  else
  if v = SCItemVatSumtotal then
    ParValue := format(estbk_types.CCurrentMoneyFmt2, [self.FRepItemVatSumTotal])
  else
  if v = SCPmtSumInWords then
    ParValue := estbk_utilities.fncSumIncWords(qryCashRegister.FieldByName('sumtotal').asCurrency)
  else
  if v = SCCurrYear then
    ParValue := IntToStr(Yearof(now));
end;

procedure TframeCashRegister.lazFocusFixTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  if not assigned(self.FActiveEditor) then
    exit;


  // ---
  if (FLazFocusFixFlags and CLazFixLookupFocus) = CLazFixLookupFocus then
  begin

    if miscSumDbGrid.CanFocus then
      miscSumDbGrid.SetFocus;


    if self.FActiveEditor.CanFocus then
      self.FActiveEditor.SetFocus;

  end
  else
  if (FLazFocusFixFlags and CLazFixDbGridFocus) = CLazFixDbGridFocus then
  begin

    (miscSumDbGrid.EditorByStyle(cbsAuto) as TStringCellEditor).SelStart := length((miscSumDbGrid.EditorByStyle(cbsAuto) as TStringCellEditor).Text);
    if miscSumDbGrid.CanFocus then
      miscSumDbGrid.SetFocus;

    if assigned(self.FActiveEditor) and self.FActiveEditor.CanFocus then
      self.FActiveEditor.SetFocus;
  end;

  self.FLazFocusFixFlags := 0;
end;

procedure TframeCashRegister.lazTimerClientTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  if btnOpenClientList.CanFocus then
    btnOpenClientList.SetFocus;
end;

procedure TframeCashRegister.lookupcmbCashRegisterClosePopupNotif(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeCashRegister.lookupcmbCashRegisterKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Shift = []) then
    if (key = VK_DELETE) then
    begin
      if Sender = lookupcmbCashRegister then
        lblAccDName.Caption := '';
    end;


  if Sender is TRxDBLookupCombo then
    estbk_utilities.rxLibKeyDownHelper(Sender as TRxDBLookupCombo, Key, Shift);
end;

procedure TframeCashRegister.lookupcmbCashRegisterSelect(Sender: TObject);
var
  pCurrIndex: integer;
begin
  with  TRxDBLookupCombo(Sender) do
    if (Value <> '') then
    begin
      LookupSource.DataSet.Locate('id', Value, []);
      Text := LookupSource.DataSet.FieldByName('account_coding').AsString;
      lblAccDName.Caption := '  ' + LookupSource.DataSet.FieldByName('account_name').AsString;
      ;

      if Sender = lookupcmbCashRegister then
      begin
        pCurrIndex := cmbCurrencyList.items.indexOf(LookupSource.DataSet.FieldByName('default_currency').AsString);
        if pCurrIndex >= 0 then
          cmbCurrencyList.ItemIndex := pCurrIndex;
      end;
      // ---
    end;
end;


procedure TframeCashRegister.createNewPayment;
var
  pPmtOrderNr: AStr;
  pMiscDs: TDataSource;
begin

  lazFocusFix.Enabled := False;
  // --
  dbEdtDocNr.Text := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', now, False, estbk_types.CCSRegister_doc_recnr);


  try

    self.FSkipScrollEvent := True;


    // --
    self.performCleanup;
    // mingi müstiline insert
    pMiscDs := miscSumDbGrid.DataSource;
    miscSumDbGrid.DataSource := nil;
    miscSumDbGrid.Enabled := False;




    cmbTransType.Enabled := True;
    qryGetUserPmtItems.Filtered := False;
    qryGetUserPmtItems.Filter := '';


    self.qryOpenCashRegPayment(0);
    self.qryPaymentMiscSum(0);
    self.qryPaymentData(-1);


    // --------
    qryCashRegister.Insert;


    dtPmtDate.Date := now;
    dtPmtDate.Text := datetostr(dtPmtDate.Date);
    // et üllatusi ei tuleks, ootamatuid üllatusi on tulnud !!!


    cmbCurrencyList.ItemIndex := cmbCurrencyList.Items.IndexOf(estbk_globvars.glob_baseCurrency);

    // RO staatus !!!
    estbk_utilities.changeWCtrlReadOnlyStatus(grpboxLg, False);
    estbk_utilities.changeWCtrlEnabledStatus(grpboxLg, True);


    // ---
    btnNewPayment.Enabled := False;
    btnSave.Enabled := True;
    btnCancel.Enabled := True;
    btnOpenAccEntry.Enabled := False;



    // jätame meelde valitud kontod
    if (self.FLastCashRegisterAccId > 0) and (qryGetCashRegAccounts.locate('id', self.FLastCashRegisterAccId, [])) then
    begin
      lookupcmbCashRegister.Value := IntToStr(self.FLastCashRegisterAccId);
      lookupcmbCashRegister.OnSelect(lookupcmbCashRegister);
      lookupcmbCashRegister.Text := qryGetCashRegAccounts.FieldByName('account_coding').AsString;
    end;




  finally
    self.FSkipScrollEvent := False;
    // @@@
    miscSumDbGrid.DataSource := pMiscDs;
    self.FLazFocusFixFlags := 0;
    miscSumDbGrid.Enabled := True;
  end;

  // @ ULME VIGA !
  // 24.02.2013 Ingmar
  // kusagil tekib edit event uue elemendi puhul, isegi peale avamist, time see pole, grid pole...müstika !
  try
    try

      self.FSkipOnChangeEvent := True;
      self.FSkipScrollEvent := True;
      qryGetPaymentMiscItems.CancelUpdates;

      if assigned(self.FActiveEditor) then
      begin
        self.FActiveEditor.Visible := False;
        self.FActiveEditor := nil;
      end;
      self.FAccounts.Visible := False;
      // --
    finally
      self.FLazFocusFixFlags := 0;
      self.FSkipOnChangeEvent := False;
      self.FSkipScrollEvent := False;
    end;

  except
  end;

  // --
  lazTimerClient.Enabled := True;
end;


procedure TframeCashRegister.btnNewPaymentClick(Sender: TObject);
begin
  self.createNewPayment;
end;

procedure TframeCashRegister.btnOpenAccEntryClick(Sender: TObject);
begin
  if assigned(self.FFrameDataEvent) and (self.FCurrPaymentAccRecId > 0) then
    self.FFrameDataEvent(Self, __frameOpenAccEntry, self.FCurrPaymentAccRecId);
end;

procedure TframeCashRegister.btnCancelClick(Sender: TObject);
begin
  lazFocusFix.Enabled := False;

  self.FDataNotSaved := False;
  self.FNewRecord := False;

  self.FUsrItemsChanged := False;
  self.FMiscItemsChanged := False;



  TButton(Sender).Enabled := False;
  btnSave.Enabled := False;
  btnNewPayment.Enabled := True;
  btnOpenAccEntry.Enabled := (self.FCurrPaymentAccRecId > 0);


  qryCashRegister.CancelUpdates;
  qryGetUserPmtItems.CancelUpdates;
  // 02.03.2013 Ingmar
  qryGetPaymentMiscItems.CancelUpdates;

  // 02.03.2013 Ingmar;
  if assigned(self.FActiveEditor) then
  begin
    self.FActiveEditor.Visible := False;
    self.FActiveEditor := nil;
  end;



  //if self.FCurrentPmtOrderID;
  estbk_utilities.changeWCtrlEnabledStatus(grpboxLg, not qryCashRegister.EOF, 0);



  // ----
  // -- tühi laadimine !
  if qryCashRegister.EOF then
  begin

    self.qryOpenCashRegPayment(0);
    qryGetUserPmtItems.Close;
    qryGetPaymentMiscItems.Close;
    self.performCleanup;

    //edtOrderNr.Text:='';
  end;

  // miscSumDbGrid.Invalidate;
  // ----
  estbk_utilities.changeWCtrlReadOnlyStatus(grpboxLg, pos(estbk_types.CPaymentRecStatusClosed, qryCashRegister.FieldByName('status').AsString) > 0);

  pVerifiedChkbox.Enabled := not qryCashRegister.EOF;
  lblVerified.Enabled := not qryCashRegister.EOF;

  if btnOpenClientList.CanFocus then
    btnOpenClientList.SetFocus;

end;

procedure TframeCashRegister.btnClose1Click(Sender: TObject);
begin
  if assigned(self.FframeKillSignal) then
    self.FframeKillSignal(self);
end;

procedure TframeCashRegister.dbGridAllItemsExit(Sender: TObject);
begin
  with TDbGrid(Sender) do
    if assigned(Datasource) and (Datasource.DataSet.state in [dsEdit, dsInsert]) then
    begin
      Datasource.DataSet.Post;
      self.changePaymentSumAndDescr();
    end;

  // 16.06.2011 Ingmar
  if assigned(self.FLiveEditor) and self.FLiveEditor.Visible and not (self.FLiveEditor is TRxDBLookupCombo) then
    self.FLiveEditor.Visible := False;
end;

procedure TframeCashRegister.dbGridAllItemsKeyPress(Sender: TObject; var Key: char);
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
          estbk_utilities.grid_verifyNumericEntry(TDbgrid(Sender), CCol_spltSum, key);
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
  end;
end;

function TframeCashRegister.getClientId: integer;
begin
  if assigned(self.FPClientData) then
    Result := self.FPClientData.FClientId
  else
    Result := 0;
end;

procedure TframeCashRegister.setClientId(const pClientId: integer);
begin
  if pClientId > 0 then
    self.reloadCustomerData(pClientId, False);
end;


function TframeCashRegister.getDataLoadStatus: boolean;
begin
  Result := qryCashRegister.Active;
end;


procedure TframeCashRegister.setDataLoadStatus(const v: boolean);
begin
  qryDataWriter.Close;
  qryDataWriter.SQL.Clear;

  qryGetUserPmtItems.Close;
  qryGetUserPmtItems.SQL.Clear;

  qryGetPaymentMiscItems.Close;
  qryGetPaymentMiscItems.SQL.Clear;

  qryCashRegister.Close;
  qryCashRegister.SQL.Clear;

  qryGetAccounts.Close;
  qryGetAccounts.SQL.Clear;

  qryGetCashRegAccounts.Close;
  qryGetCashRegAccounts.SQL.Clear;

  // --
  qryCashRegisterUpdt.DeleteSQL.Clear;
  qryCashRegisterUpdt.InsertSQL.Clear;
  qryCashRegisterUpdt.ModifySQL.Clear;


  qryGetPaymentMiscItemsUpdIns.ModifySQL.Clear;
  qryGetPaymentMiscItemsUpdIns.InsertSQL.Clear;
  qryGetPaymentMiscItemsUpdIns.DeleteSQL.Clear;

  if v then
  begin

    qryDataWriter.Connection := dmodule.primConnection;
    qryCashRegister.Connection := dmodule.primConnection;
    qryGetAccounts.Connection := dmodule.primConnection;
    qryGetCashRegAccounts.Connection := dmodule.primConnection;

    qryGetUserPmtItems.Connection := dmodule.primConnection;
    qryGetPaymentMiscItems.Connection := dmodule.primConnection;

    qryCashRegisterUpdt.InsertSQL.Add(estbk_sqlclientCollection._SQLInsertPayment2);
    qryCashRegisterUpdt.ModifySQL.Add(estbk_sqlclientCollection._SQLUpdatePayment2);

    qryGetPaymentMiscItemsUpdIns.DeleteSQL.Add(estbk_sqlclientcollection._SQLDeletePaymentMiscData);
    qryGetPaymentMiscItemsUpdIns.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdatePaymentDataStatus);
    qryGetPaymentMiscItemsUpdIns.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertPaymentData2);



    // TODO teha, et sellist topeltlaadimist enam ei oleks !!!
    qryGetAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    qryGetAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetAccounts.Open;

    qryGetCashRegAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    ;
    qryGetCashRegAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetCashRegAccounts.Open;


    self.FLastCashRegisterAccId := _ac.sysAccountId[_accCashRegister];
    qryGetAccounts.Locate('id', _ac.sysAccountId[_accCashRegister], []);

  end
  else
  begin
    qryCashRegister.Connection := nil;
    qryGetAccounts.Connection := nil;
    qryGetPaymentMiscItems.Connection := nil;
    qryGetUserPmtItems.Connection := nil;
    qryGetCashRegAccounts.Connection := nil;
    qryDataWriter.Connection := nil;
  end;


  //   qryPmtOrderUpt.ModifySQL.Add(estbk_sqlclientCollection._SQLUpdatePayment);
  //  qryPmtOrderUpt.InsertSQL.Add(estbk_sqlclientCollection._SQLInsertPayment);
   (*
     qryGetCBanksAccounts.SQL.Add(estbk_sqlclientCollection._SQLSelectAccountsWithBankData);
     qryGetCBanksAccounts.ParamByname('company_id').AsInteger :=estbk_globvars.glob_company_id;
     qryGetCBanksAccounts.active := v;



     qryPmtBanks.SQL.Add(estbk_sqlclientCollection._SQLSelectBanks);
     qryPmtBanks.ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
     qryPmtBanks.active := v;



     qryGetAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
     qryGetAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
     qryGetAccounts.Open;





     // õiged päevakursid peale
         estbk_clientdatamodule.dmodule.revalidateCurrObjVals( pmtDate.date, self.FStCurrInst);


         // küsime uuesti kurssi !
         pCurrName := FieldByName('currency').AsString;
         cmbCurrency.ItemIndex := cmbCurrency.Items.IndexOf(pCurrName);

  // --- peale ka kliendi andmed küsima...kui need olemas...
  if (ppaymentID>0) and (fieldByname('client_id').asInteger>0)  then
      self.FPClientData:=estbk_customer.getClientDataWUI_uniq(fieldByname('client_id').asInteger);




   *)
end;



procedure TframeCashRegister.doOnClickFix(Sender: TObject);
begin
  if miscSumDbGrid.CanFocus then
    miscSumDbGrid.SetFocus;

  if TWinControl(Sender).CanFocus then
    TWinControl(Sender).SetFocus;
end;

// 12.06.2011 Ingmar
procedure TframeCashRegister.OnOvrEditorExit(Sender: TObject);
begin
  estbk_utilities.OnDbGridEditorExitFltCheck(dbGridAllItems, Sender, CCol_spltSum);
end;


procedure TframeCashRegister.OnOvrEditorExit2(Sender: TObject);
begin
  estbk_utilities.OnDbGridEditorExitFltCheck(miscSumDbGrid, Sender, CCol2_sum);
end;


constructor TframeCashRegister.Create(frameOwner: TComponent);
var
  pCollItem: TCollectionItem;
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
  FCurrList := estbk_clientdatamodule.dmodule.createPrivateCurrListCopy();

  cmbCurrencyList.Items.Assign(FCurrList);
  //   cmbCurrencyList.Items.InsertObject(0,estbk_strmsg.SUndefComboChoise,nil);
  cmbCurrencyList.ItemIndex := 0;

  FAccounts := TRxDBLookupCombo.Create(miscSumDbGrid);
  FAccounts.parent := self.miscSumDbGrid;
  FAccounts.Visible := False;

  FAccounts.ParentFont := False;
  FAccounts.ParentColor := False;
  FAccounts.ShowHint := True;
  FAccounts.DoubleBuffered := True;

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


  estbk_utilities.changeWCtrlEnabledStatus(grpboxLg, False);
  // changeWCtrlReadOnlyStatus
  grpboxLg.Enabled := True;
  (miscSumDbGrid.EditorByStyle(cbsAuto) as TStringCellEditor).OnClick := @self.doOnClickFix;
  // ---

  cmbTransType.Items.add(estbk_strmsg.SCashrIncOrder);
  cmbTransType.Items.add(estbk_strmsg.SCashrOutpOrder);

  // 00006 bug; 12.06.2011 kui gridi arvulisse lahtrisse kopeeriti tekst
  dbGridAllItems.EditorByStyle(cbsAuto).OnExit := @self.OnOvrEditorExit;
  miscSumDbGrid.EditorByStyle(cbsAuto).OnExit := @self.OnOvrEditorExit2;
end;

destructor TframeCashRegister.Destroy;
begin
  estbk_utilities.clearStrObject(TAStrings(self.FCurrList));
  FreeAndNil(self.FCurrList);

  dmodule.notifyNumerators(PtrUInt(self));
  inherited Destroy;
end;

initialization
  {$I estbk_fra_cashregister.ctrs}

end.