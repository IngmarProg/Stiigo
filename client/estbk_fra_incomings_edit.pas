unit estbk_fra_incomings_edit;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, ExtCtrls, Variants,
  Contnrs, Dialogs, DBGrids, DBCtrls, EditBtn, Grids, LCLType, LCLIntf, LCLProc, Graphics, Math,
  Buttons, rxpopupunit, rxdbgrid, rxlookup, SMNetGradient, estbk_settings,
  estbk_uivisualinit, estbk_lib_commonevents, estbk_lib_commoncls, estbk_lib_paymentmanager,
  estbk_clientdatamodule, estbk_lib_commonaccprop, estbk_sqlclientcollection, estbk_globvars, estbk_lib_bankfilesconverr,
  estbk_utilities, estbk_types, estbk_strmsg, estbk_lib_incomings, estbk_lib_rep_errorcodes, estbk_lib_erprtwriter,
  DB, ZDataset, ZSqlUpdate, ZAbstractRODataset;

// #3 viimane assert !
type
  TPmtLineErrorLevels = (_pmtLvlOK,
    _pmtLvlmediumerror,
    _pmtLvlcriticalerror
    );

type
  TBankIncomeModuleMode = (gbIncInsertNewFile,    // uus laekumiste faili sisestus
    gbIncInsertEditFile,   // reaalsuses avati juba sisetatud kannete fail ja hakati redigeerima
    gbIncEditManualEntrys  // käsitsi sisestatud laekumised
    );


type

  { TframeBankIncomeManually }

  TframeBankIncomeManually = class(TFrame)
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnNewLine: TBitBtn;
    btnOpenAccEntry: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnSave: TBitBtn;
    cmbCurrency: TDBComboBox;
    dbEdtDescr: TDBEdit;
    dbEdtDescr3: TDBEdit;
    dbEdtDocnr: TDBEdit;
    dbedtIncnr: TDBEdit;
    dbEdtRefNr: TDBEdit;
    dbEdtTotalSum: TDBEdit;
    dbEdtSrvCharges: TDBEdit;
    dbLookupBankA: TRxDBLookupCombo;
    edtAccDate: TDateEdit;
    edtClient: TEdit;
    edtCurrRate: TEdit;
    edtEDesrcr: TEdit;
    gridClientUnpaidItems: TDBGrid;
    gridPEntry: TDBGrid;
    Label4: TLabel;
    Label5: TLabel;
    lblAccNr: TLabel;
    lblBank: TLabel;
    lblCurrency: TLabel;
    lblCurrRate: TLabel;
    lblDescr: TLabel;
    lblDocnr: TLabel;
    lblIncNumber: TLabel;
    lblIncNumber1: TLabel;
    lblRefNr: TLabel;
    lblTotalSum: TLabel;
    lblTotalSum1: TLabel;
    pChkbVerified: TCheckBox;
    pImgListOpenClose: TImage;
    plowerpanel: TPanel;
    pMainPanel: TPanel;
    lazFocusFix2: TTimer;
    pPanelGrad: TNetGradient;
    pPanelGrad1: TNetGradient;
    pSizepanel: TPanel;
    pToppanel: TPanel;
    qryGetBankAccounts: TZQuery;
    qryIncomeLinesDs: TDatasource;
    qryIncomeLines: TZQuery;
    qryGetBankAccountsDs: TDatasource;
    qryUnpaidItemsDs: TDatasource;
    grpBoxBanks: TGroupBox;
    pl1: TBevel;
    pl: TBevel;
    qryGetAccountsDs: TDatasource;
    qryGetAccounts: TZQuery;
    qryWorker: TZQuery;
    qryUnpaidItems: TZQuery;
    qryIncomeLinesUpt: TZUpdateSQL;
    lazFocusFix: TTimer;
    qryIncomings: TZQuery;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewLineClick(Sender: TObject);
    procedure btnOpenAccEntryClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cmbCurrencyChange(Sender: TObject);
    procedure cmbCurrencyExit(Sender: TObject);
    procedure dbEdtDocnrExit(Sender: TObject);
    procedure dbEdtSrvChargesKeyPress(Sender: TObject; var Key: char);
    procedure dbLookupBankAKeyPress(Sender: TObject; var Key: char);
    procedure dbLookupBankASelect(Sender: TObject);
    procedure edtAccDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure edtAccDateEditingDone(Sender: TObject);
    procedure edtAccDateExit(Sender: TObject);
    procedure edtClientChange(Sender: TObject);
    procedure edtClientExit(Sender: TObject);
    procedure edtClientKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtClientKeyPress(Sender: TObject; var Key: char);
    procedure edtClientUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure edtCurrRateExit(Sender: TObject);
    procedure edtCurrRateKeyPress(Sender: TObject; var Key: char);
    procedure gridClientUnpaidItemsEditingDone(Sender: TObject);
    procedure gridPEntryCellClick(Column: TColumn);
    procedure gridPEntryColEnter(Sender: TObject);
    procedure gridPEntryDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure gridPEntryEnter(Sender: TObject);
    procedure gridPEntryPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
    procedure gridClientUnpaidItemsCellClick(Column: TColumn);
    procedure gridClientUnpaidItemsColEnter(Sender: TObject);
    procedure gridClientUnpaidItemsColExit(Sender: TObject);
    procedure gridClientUnpaidItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure gridClientUnpaidItemsExit(Sender: TObject);
    procedure gridClientUnpaidItemsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure gridClientUnpaidItemsKeyPress(Sender: TObject; var Key: char);
    procedure gridClientUnpaidItemsPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
    procedure gridClientUnpaidItemsSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);

    procedure lazFocusFix2Timer(Sender: TObject);
    procedure lazFocusFixTimer(Sender: TObject);
    procedure pChkbVerifiedClick(Sender: TObject);
    procedure pGridIncomingsDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure pGridIncomingsPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
    procedure pGridIncomingsSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
    procedure pGridIncomingsSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure pImgListOpenCloseClick(Sender: TObject);
    procedure qryGetAccountsAfterScroll(DataSet: TDataSet);
    procedure qryGetAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryGetBankAccountsAfterScroll(DataSet: TDataSet);
    procedure qryIncomeLinesAfterEdit(DataSet: TDataSet);
    procedure qryIncomeLinesAfterInsert(DataSet: TDataSet);
    procedure qryIncomeLinesAfterPost(DataSet: TDataSet);
    procedure qryIncomeLinesAfterScroll(DataSet: TDataSet);
    procedure qryIncomeLinesBeforePost(DataSet: TDataSet);
    procedure qryIncomeLinesBeforeScroll(DataSet: TDataSet);
    procedure qryUnpaidItemsAfterCancel(DataSet: TDataSet);
    procedure qryUnpaidItemsAfterEdit(DataSet: TDataSet);
    procedure qryUnpaidItemsAfterPost(DataSet: TDataSet);
    procedure qryUnpaidItemsAfterScroll(DataSet: TDataSet);
    procedure qryUnpaidItemsBeforeEdit(DataSet: TDataSet);
    procedure qryUnpaidItemsBeforeInsert(DataSet: TDataSet);
    procedure qryUnpaidItemsBeforePost(DataSet: TDataSet);
    procedure qryUnpaidItemsBeforeScroll(DataSet: TDataSet);
    procedure qryUnpaidItemsEditError(DataSet: TDataSet; E: EDatabaseError; var DataAction: TDataAction);
  private
    // 16.06.2011 Ingmar; lazaruses bugi, bugi järel. Kui gridilt minema liikuda, siis editori ei kaotata !
    FLiveEditor: TWinControl;

    FProcEntrys: TIncomings_base;
    FSelectedCol: TColumn;  // ! tasumata arved/tellimused
    FLcmpAccountCode: AStr;
    // kliendi otsimise smartedit
    FSmartEditSkipCtrlChars: boolean;
    FSmartEditSkipChar: boolean;

    // näitab, et failisisestuse reziim
    FFileImpMode: boolean;
    // ---
    FErrTrackingEnabled: boolean; // jooksvalt ütleb, mis on puudu ja mida veel vaja lisada; käsitsi laekumised !
    FAllowRecInsert: boolean; // -- et items gridis käsitsi ei muudetaks asju !
    FSkipDBEvents: boolean; // ntx kutsume välja edit / post ja me ei taha evente beforepost jne
    FSavingData: boolean; // lipp scroll evendi jaoks, mis näitab, et me juba salvestame andmeid !
    FSkipLookupEvents: boolean;
    FSkipOnChangeEvents: boolean;
    FFlagIncomeSumEdited: boolean;

    FSmartEditLastSuccIndx: integer;
    // ---
    FSelectedClientID: integer;
    FOrigEditorKeyPress: TKeyPressEvent;
    FCurrList: TAStrList;
    FAccounts: TRxDBLookupCombo;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FReqCurrUpdate: TRequestForCurrUpdate;


    procedure OnOvrEditorEnter(Sender: TObject);
    procedure OnOvrEditorExit(Sender: TObject);
    // mul pole piisavalt sõnu kirumiseks ! 0.9.30 lazarus ei oska oneditingdone eventi korralikult kasutada
    //  töötas, nüüd enam mitte ja oi palju probleeme see tekitab
    procedure OnLookupComboSelect(Sender: TObject);
    procedure OnLookupComboChange(Sender: TObject);
    procedure OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);

    procedure setFileImpMode(const b: boolean);
    procedure setCtrlStatusOnchange;

    procedure revalidateCurrExcRates;
    procedure recalculateItemSum;

    function validateSingleIncomeLine(const pDataSet: TDataset): integer;
    procedure setItemFilterForIncomeRec;
    procedure refreshClientItemGuids(const pClient: integer);
    function validateIncomings(var pOkRecCnt: integer): boolean;

    procedure copyClientItemsToDataset(const pClient: integer);
    procedure addMiscLine(const pClient: integer; const pGuid: AStr);
    procedure ReLoadClientCommonData(const pClientData: TClientData; const pReUpdateClientName: boolean = True);
    procedure refreshClientItems(const pClient: integer; const pReloadItemsToTempTable: boolean = False); // kliendi arved / tellimused
    procedure chgCommCtrlEnabledStatus(const b: boolean);
    procedure loadDataFromTempTable(const pFlushTable: boolean);
    function grpErrors(const pErrorCode: integer): TPmtLineErrorLevels;

    procedure performCleanup(const pFlushTempTables: boolean = True);
    // ---
    procedure doConversions(const pBaseSum: double; const pConvBillSum: boolean = False);
    procedure revalidateItemsAddConv;

    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);

    // sooritame konteeringud !
    procedure doAccounting(const pPmtManager: TPaymentManager; const pCurrVals: TAStrList; const pOnlyPrepaymentEntry: boolean = False);

    procedure addBankCharges(const pPmtManager: TPaymentManager);
    // ---
    function createNewIncomingBankRecord(const pSessionId: integer): integer;
    procedure calcTotalPaymentSum;
    procedure refreshDailyCurrencyRates(const pCurrCodeOvr: AStr = '');
    function disallowIncomeEditing: boolean;
    procedure topPanelOpencloseImg(const pIndex: integer);
  public
    procedure callNewIncomingEvent;
    // --
    procedure refreshAccountList;

    // üldiselt käsitsi sisestuse puhul võetakse sisestused kuupäeva kaupa;
    // ntx 10.11.2011 sisestati 5 korda laekumisi ja mitu korda pandi programm kinni, siis võetakse antud kuupäeva aluskirje !
    // procedure   loadIncomeData(const pSessionID : Integer);
    procedure readBankFile(const pFilename: AStr; const pBankCode: AStr; const pMarkOkItemsAsVerif: boolean;
      const pSEPAIncomings: boolean = False);

    function saveChanges: boolean;
    procedure saveChanges2;
    procedure revalidateUserPtItems;

    procedure loadIncomingById(const pBaseRecordId: integer); // tegelikkuses on incoming_bank ->id
    procedure loadIncomingBySesssionId(const pIncomingSessionId: integer);

    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published // RTTI kala
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property onAskCurrencyDownload: TRequestForCurrUpdate read FReqCurrUpdate write FReqCurrUpdate;

    // property procIncomes : TIncomings_base read FProcEntrys;

    // kui laekumised tulevad failist, siis ei lase käsitsi täiendavat rida ise teha ! see tuleb teha eraldi
    // muidu muutub üldpilt liiga segaseks, kui failist tulnud andmed + käsitsi sisestus !
    property fileMode: boolean read FFileImpMode write setFileImpMode;


    // ---------
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
    // ---------
  end;

implementation

uses estbk_lib_bankfiledefs, estbk_frm_choosecustmer;

const
  CPnewIncItemGuidMarker = 'new#';

const
  CDefaultRowHeight = 21;

const
  CLeftHiddenCorn = -200;

const
  CCol_LineMsg = 0; // failide sisestamise puhul kuvatakse viga !
  CCol_Type = 1;
  CCol_Account = 2;
  CCol_AccountNr = 3;
  CCol_Client = 4;
  CCol_DocNr = 5;
  CCol_Date = 6;
  CCol_Sum = 7;
  CCol_PaymentSumFromFile = 8;
  CCol_Currency = 9;
  CCol_Verified = 10;

const
  CColItems_bill_order = 0;
  CColItems_duedate = 1;
  CColItems_currency = 2;
  CColItems_paid = 3;
  CColItems_topay = 4;
  CColItems_incomeconvsum = 5;
  CColItems_accounts = 6;
  CColItems_incomesum = 7;
  CColItems_pcheckbox = 8;

// mingi jama on dbgridi col indeksiga
const
  CLookupAccFieldname = 'account_coding';



procedure TframeBankIncomeManually.callNewIncomingEvent;
begin
  if btnNewLine.Enabled then
    btnNewLine.OnClick(btnNewLine);
end;

procedure TframeBankIncomeManually.loadIncomingById(const pBaseRecordId: integer);
begin
  try
    self.FSkipDBEvents := True;
    FProcEntrys.loadIncomings(pBaseRecordId, False);
    loadDataFromTempTable(False);
  finally
    FSkipDBEvents := False;
  end;

  qryIncomeLinesAfterScroll(qryIncomeLines);
  calcTotalPaymentSum;

  // -- et kord oleks majas nuppude staatustega !
  btnNewLine.Enabled := True;
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TframeBankIncomeManually.loadIncomingBySesssionId(const pIncomingSessionId: integer);
begin
  try
    FSkipDBEvents := True;

    FProcEntrys.loadIncomings(pIncomingSessionId, False);
    loadDataFromTempTable(False);
  finally
    FSkipDBEvents := False;
  end;

  qryIncomeLinesAfterScroll(qryIncomeLines);
  calcTotalPaymentSum;

  // -- sama teema
  btnNewLine.Enabled := True;
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TframeBankIncomeManually.setFileImpMode(const b: boolean);
begin
  self.FFileImpMode := b;
  btnNewLine.Visible := not b;
  btnNewLine.Enabled := not b;

  if b then
  begin
    btnSave.Caption := estbk_strmsg.SBtnCaptContinue;
  end
  else
  begin
    btnSave.Caption := estbk_strmsg.SBtnCaptSave;
    pImgListOpenClose.Tag := -1;
  end;

  if pImgListOpenClose.Enabled then
    pImgListOpenClose.OnClick(pImgListOpenClose);
end;

procedure TframeBankIncomeManually.setCtrlStatusOnchange;
begin
  btnNewLine.Enabled := False;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
end;

function TframeBankIncomeManually.validateSingleIncomeLine(const pDataSet: TDataset): integer;
begin
  // veakood, mida ei saa üle kirjeldada !
  if pDataSet.FieldByName('errorcode').AsInteger = estbk_lib_bankfilesconverr.CErrIncAlreadyExists then
  begin
    Result := pDataSet.FieldByName('errorcode').AsInteger;
    Exit;
  end;

  Result := CDataOK;
  // kui kõik korras, siis võime veakoodid ülekirjutada 0 !
  if qryIncomeLines.FieldByName('client_id').AsInteger <= 0 then
    Result := estbk_lib_bankfilesconverr.CErrIncCustNotFound
  else
  if qryIncomeLines.FieldByName('bank_bk_account_id').AsInteger <= 0 then
    Result := estbk_lib_bankfilesconverr.CErrIncBankAccNotFound
  else
  if qryIncomeLines.FieldByName('payment_date').IsNull then
    Result := estbk_lib_bankfilesconverr.CErrIncDateIsEmpty
  else
  if qryIncomeLines.FieldByName('acc_period_id').AsInteger < 1 then
    Result := estbk_lib_bankfilesconverr.CErrIncValidAccPeriodNotFound
  else
  // 20.03.2011 Ingmar; võtsin maha kohustuse, et vaja teada, kus tuli laekumine; ntx swedis intersside puhul on see tühi !!!
  // if(trim(qryIncomeLines.FieldByname('bank_account').asString)='') and self.fileMode then // !!!!! TASUJA PANGAKONTO ! ainult failide puhul nõuame seda !
  //    result:=estbk_bankfilesconverr.CErrIncSrcAccountNrEmpty
  // else
  if (self.FCurrList.IndexOf(qryIncomeLines.FieldByName('currency').AsString) = -1) or
    (Math.isZero(qryIncomeLines.FieldByName('currency_drate_ovr').AsFloat)) then
  begin
    Result := estbk_lib_bankfilesconverr.CErrIncCurrencyIsUnkn;
  end
  else
  if (qryIncomeLines.FieldByName('payment_sum').AsCurrency = 0.00) then
    Result := estbk_lib_bankfilesconverr.CErrIncSumIszero;
end;

// genereerib filtri, mis vaatab milliseid elemente alumises osas kuvada
procedure TframeBankIncomeManually.setItemFilterForIncomeRec;
var
  pBuildFlt: AStr;
begin
  qryUnpaidItems.Filtered := False;
  //pBuildFlt:=format('(pguid='+QuotedStr(qryIncomeLines.FieldByname('pguid').asString)+') OR (client_id=%d)',[qryIncomeLines.FieldByname('client_id').asInteger])
  // 18.03.2011 Ingmar; kui klienti pole registeeritud, siis ei lase me ka midagi valida !
  if qryIncomeLines.FieldByName('client_id').AsInteger > 0 then
    pBuildFlt := format('(   ' + '    (pguid=' + QuotedStr(qryIncomeLines.FieldByName('pguid').AsString) + ') ' +
      ' OR (client_id=%d AND pguid='''' AND item_type<>%d) ' + ')', [qryIncomeLines.FieldByName('client_id').AsInteger,
      CResolvedDataType_asMisc])
  else
  begin
    pBuildFlt := '1=0';
  end;

  qryUnpaidItems.Filter := pBuildFlt;
  qryUnpaidItems.Filtered := True;
  // 17.12.2017 Ingmar; unustab sorteeringu ?!?
  qryUnpaidItems.SortedFields := 'item_type;item_id desc';
  qryUnpaidItems.SortType := stAscending;

  {$IFDEF DEBUGMODE}
  DebugOutput(Self.ClassName, 'setItemFilterForIncomeRec', pBuildFlt);
  {$ENDIF}
end;

// 07.02.2012 Ingmar
procedure TframeBankIncomeManually.refreshClientItemGuids(const pClient: integer);
var
  pitemGuid: AStr;
  pnewRowGuid: AStr;
  plogrez: AStr;
  preinit: boolean;
begin
  preinit := False;
  // ---
  qryUnpaidItems.Filter := '';
  qryUnpaidItems.Filtered := False;
  qryUnpaidItems.First;
  // ---
  pnewRowGuid := qryIncomeLines.FieldByName('pguid').AsString;

  while not qryUnpaidItems.EOF do
  begin
    if qryUnpaidItems.FieldByName('client_id').AsInteger = pClient then
    begin
      pitemGuid := qryUnpaidItems.FieldByName('pguid').AsString; // !!!
      plogrez := copy(ansilowercase(qryUnpaidItems.FieldByName('lsitemhlp').AsString), 1, 1);

      if (pos(pnewRowGuid, pitemGuid) = 0) and ((plogrez = '') or (plogrez = 'f')) then
      begin
        qryUnpaidItems.Edit;
        qryUnpaidItems.FieldByName('pguid').AsString := pnewRowGuid;
        qryUnpaidItems.Post;
        // --
        preinit := True;
      end; // taaskasutame kliendi arveid / tellimusi ...
    end;

    qryUnpaidItems.Next;
  end;

  //   if preinit then
  setItemFilterForIncomeRec;
end;

function TframeBankIncomeManually.validateIncomings(var pOkRecCnt: integer): boolean;
var
  pBookmark: TBookmark;
  pErrorCode: integer;
  pErrorCnt: integer;
  pQryUnpFilter: AStr;
  pQryUnFiltered: boolean;
  pFirstRecWithErr: AStr;
  pBeforePost: TDatasetNotifyEvent;
begin
  try
    Result := False;
    pOkRecCnt := 0;
    pFirstRecWithErr := ''; // pquid !
    //pDisableBefPost:=qryIncomeLines.on

    pBeforePost := qryIncomeLines.BeforePost;
    qryIncomeLines.BeforePost := nil;

    self.FSkipDBEvents := True; // et scrollis midagi kavalat ei tehtaks või beforepost
    pBookmark := qryIncomeLines.GetBookmark;
    qryIncomeLines.DisableControls;

    pQryUnpFilter := qryUnpaidItems.Filter;
    pQryUnFiltered := qryUnpaidItems.Filtered;
    qryUnpaidItems.DisableControls;


    qryIncomeLines.First;
    while not qryIncomeLines.EOF do
    begin
      if qryIncomeLines.FieldByName('errorcode').AsInteger <> CErrIncAlreadyExists then
        try
          pErrorCode := self.validateSingleIncomeLine(qryIncomeLines);
          // vaatame üle ka laekumise kandega seotud elemendid !
          if pErrorCode = CDataOK then
          begin
            qryUnpaidItems.Filtered := False;
            qryUnpaidItems.Filter := 'pguid=' + QuotedStr(qryIncomeLines.FieldByName('pguid').AsString);
            qryUnpaidItems.Filtered := True;
            qryUnpaidItems.First;

            while not qryUnpaidItems.EOF do
            begin

              if (qryUnpaidItems.FieldByName('account_id').AsInteger <= 0) and estbk_utilities.isTrueVal(
                qryUnpaidItems.FieldByName('lsitemhlp').AsString) then
              begin
                pErrorCode := estbk_lib_bankfilesconverr.CErrIncObjectAccIdUnkn;
                Break;
              end;

              if (qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsFloat <= 0) then
              begin
                pErrorCode := estbk_lib_bankfilesconverr.CErrIncCurrencyIsUnkn;
                Break;
              end;

              qryUnpaidItems.Next;
            end;
          end;


        finally
          begin
            if (pErrorCode <> CDataOK) and (pFirstRecWithErr = '') then
              pFirstRecWithErr := qryIncomeLines.FieldByName('pguid').AsString;

            // TÄPSUSTAME veakoodi ! tegemist enamasti elementide valikuga !
            qryIncomeLines.Edit;
            qryIncomeLines.FieldByName('errorcode').AsInteger := pErrorCode;
            qryIncomeLines.Post;
            // ---
          end;
        end;

      // ---
      qryIncomeLines.Next;
    end;

    // MITU ebakorrektset kirjet veel leiti !
    qryIncomeLines.Filtered := False;
    qryIncomeLines.Filter := format('errorcode<>%d', [CDataOK]);
    qryIncomeLines.Filtered := True;

    pErrorCnt := qryIncomeLines.RecordCount;
    Result := (pErrorCnt = 0);

    qryIncomeLines.Filtered := False;
    pOkRecCnt := qryIncomeLines.RecordCount - pErrorCnt;

  finally
    FSkipDBEvents := False;
    qryIncomeLines.Filtered := False;
    qryIncomeLines.GotoBookmark(pBookmark);
    qryIncomeLines.FreeBookmark(pBookmark);
    qryIncomeLines.EnableControls;


    // ---
    qryUnpaidItems.Filtered := False;
    qryUnpaidItems.Filter := pQryUnpFilter;
    qryUnpaidItems.Filtered := pQryUnFiltered;
    qryUnpaidItems.EnableControls;

    gridClientUnpaidItems.Repaint;
    gridPEntry.Repaint;

    if pFirstRecWithErr <> '' then
      qryIncomeLines.Locate('pguid', pFirstRecWithErr, []);
    qryIncomeLines.BeforePost := pBeforePost;
  end;
end;

procedure TframeBankIncomeManually.recalculateItemSum;
var
  pBookMark: TBookmark;
  pLineSum: double;
  pCurrVal: double;
begin
  try
    self.FSkipDBEvents := True;
    pBookMark := qryUnpaidItems.GetBookmark;
    qryUnpaidItems.DisableControls;


    qryUnpaidItems.First;

    // -- 27.02.2011 Ingmar; varia rida ! peame maksega samade andmete peale konvertima !
    if qryUnpaidItems.Locate('item_type', integer(estbk_lib_bankfiledefs.CResolvedDataType_asMisc), []) then
    begin
      qryUnpaidItems.Edit;
      qryUnpaidItems.FieldByName('item_currency').AsString := cmbCurrency.Text;

      pCurrVal := double(TCurrencyObjType(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).currVal);
      qryUnpaidItems.FieldByName('item_currency_ovr').AsFloat := pCurrVal;
      qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsFloat := pCurrVal;
      qryUnpaidItems.Post;
    end;  // -->

    // --
    qryUnpaidItems.First;
    while not qryUnpaidItems.EOF do
    begin

      if estbk_utilities.isTrueVal(qryUnpaidItems.FieldByName('lsitemhlp').AsString) then
      begin
        if qryUnpaidItems.FieldByName('to_pay').AsCurrency > 0 then
          pLineSum := qryUnpaidItems.FieldByName('to_pay').AsCurrency
        else
          pLineSum := double(qryUnpaidItems.FieldByName('payment_sum').OldValue);
        // ---
        self.doConversions(pLineSum, True);
      end; // ---

      qryUnpaidItems.Next;
    end; // --
  finally
    qryUnpaidItems.GotoBookmark(pBookMark);
    qryUnpaidItems.FreeBookmark(pBookMark);
    qryUnpaidItems.EnableControls;
    self.FSkipDBEvents := False;
  end;
end;

procedure TframeBankIncomeManually.revalidateCurrExcRates;
var
  pNewSession: boolean;
begin
  with cmbCurrency do
  begin
    if Math.isZero(TCurrencyObjType(Items.Objects[ItemIndex]).currVal) then
      refreshDailyCurrencyRates;

    edtCurrRate.Text := format(CCurrentAmFmt4, [double(TCurrencyObjType(Items.Objects[ItemIndex]).currVal)]);
    try
      FSkipDBEvents := True;
      pNewSession := _doEdit(qryIncomeLines);
      if ItemIndex >= 0 then
      begin
        qryIncomeLines.FieldByName('currency').AsString := Items.Strings[ItemIndex];
        qryIncomeLines.FieldByName('currency_drate_ovr').AsFloat := TCurrencyObjType(Items.Objects[ItemIndex]).currVal;
      end
      else
      begin
        qryIncomeLines.FieldByName('currency').AsString := '';
        qryIncomeLines.FieldByName('currency_drate_ovr').AsFloat := 0;
      end;

    finally
      _doPost(qryIncomeLines, pNewSession);
      FSkipDBEvents := False;
    end;
  end;
end;

procedure TframeBankIncomeManually.cmbCurrencyChange(Sender: TObject);
begin
  with TComboBox(Sender) do
    if Focused then
    begin
      revalidateCurrExcRates;
      // asi selles ntx valuuta muutub, siis peab tegema uuesti ristkursid läbi !
      recalculateItemSum;
      calcTotalPaymentSum;
      // peegeldus
      //lblCurrMirr.Caption:=Items.Strings[ItemIndex];
    end;
end;

procedure TframeBankIncomeManually.cmbCurrencyExit(Sender: TObject);
begin
  refreshDailyCurrencyRates;
end;


procedure TframeBankIncomeManually.dbEdtDocnrExit(Sender: TObject);
begin
  if (Sender is TDBEdit) and (assigned(TDbEdit(Sender).DataSource)) then
    with TDbEdit(Sender).DataSource.DataSet do
      if State in [dsEdit, dsInsert] then
      begin
        // 02.02.2011 Ingmar; kontrollime veelkord rea üle ! BeforePost muudab !
        //FieldByname('errorcode').asInteger:=self.validateSingleIncomeLine(TDbEdit(Sender).DataSource.DataSet);
        Post;
      end;
end;

procedure TframeBankIncomeManually.dbEdtSrvChargesKeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13] then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else
    estbk_utilities.edit_verifyNumericEntry(Sender as TCustomEdit, Key, True);
end;


procedure TframeBankIncomeManually.dbLookupBankAKeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13] then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeBankIncomeManually.dbLookupBankASelect(Sender: TObject);
var
  pNewSession: boolean;
begin
  if not FSkipLookupEvents then
    try
      FSkipDBEvents := True;
      FSkipLookupEvents := True;

      pNewSession := not (qryIncomeLines.State in [dsEdit, dsInsert]);
      if pNewSession then
        qryIncomeLines.Edit;

      // ----
      qryIncomeLines.FieldByName('bank_bk_account_coding').AsString := qryGetBankAccounts.FieldByName('account_coding').AsString;
      // meie pangakontod, kuhu raha laekus mõneti dubleerime; kas kliendi pangakonto on vajalik ?!? st mille pealt raha tuli !?
      qryIncomeLines.FieldByName('receiver_account_number').AsString := qryGetBankAccounts.FieldByName('account_nr').AsString;
      qryIncomeLines.FieldByName('receiver_account_number_iban').AsString := qryGetBankAccounts.FieldByName('account_nr_iban').AsString;
      // 11.02.2011 Ingmar
      qryIncomeLines.FieldByName('bank_id').AsInteger := qryGetBankAccounts.FieldByName('bank_id').AsInteger;
    finally
      //if pNewSession then
      qryIncomeLinesBeforePost(qryIncomeLines); // et faili impordi puhul saaks ka veateated korda
      qryIncomeLines.Post;
      FSkipDBEvents := False;
      FSkipLookupEvents := False;
    end;
end;

procedure TframeBankIncomeManually.edtAccDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
var
  pNewEdtSession: boolean;
  pIncNumber: AStr;
begin
  AcceptDate := Adate < now;
  if AcceptDate then
  begin
    pNewEdtSession := not (qryIncomeLines.State in [dsEdit, dsInsert]);
    if pNewEdtSession then
      qryIncomeLines.Edit;

    // --------
    qryIncomeLines.FieldByName('payment_date').AsDateTime := ADate;

    // 01.03.2012 Ingmar; numeraatorite reform
    pIncNumber := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self),
      qryIncomeLines.FieldByName('acc_reg_incnr').AsString, ADate, True, estbk_types.CAccInc_rec_nr);
    qryIncomeLines.FieldByName('acc_reg_incnr').AsString := pIncNumber;
    if pNewEdtSession then
      qryIncomeLines.Post;
  end;
end;

procedure TframeBankIncomeManually.edtAccDateEditingDone(Sender: TObject);
begin
  // ---
end;


procedure TframeBankIncomeManually.refreshDailyCurrencyRates(const pCurrCodeOvr: AStr = ''); // --
var
  pOk: boolean;
  pCurr: AStr;
begin
  if (edtAccDate.Text <> '') and (cmbCurrency.ItemIndex >= 0) then
  begin

    if pCurrCodeOvr = '' then
      pCurr := cmbCurrency.Items.Strings[cmbCurrency.ItemIndex]
    else
      pCurr := cmbCurrency.Items.Strings[cmbCurrency.Items.IndexOf(pCurrCodeOvr)];

    // ---
    if pCurr = estbk_globvars.glob_baseCurrency then
      exit;

    pOk := estbk_clientdatamodule.dmodule.revalidateCurrObjVals(edtAccDate.Date, self.FCurrList);
    if not pOk then
    begin

      if Dialogs.messageDlg(format(estbk_strmsg.SAccCurDownloadNeeded, [pCurr, datetostr(edtAccdate.Date)]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        estbk_utilities.miscResetCurrenyValList(cmbCurrency);
        estbk_clientdatamodule.dmodule.downloadCurrencyData(False, edtAccdate.Date);

        if not estbk_clientdatamodule.dmodule.revalidateCurrObjVals(edtAccdate.Date, self.FCurrList) then
        begin
          if pCurrCodeOvr = '' then
            edtCurrRate.Text := format(CCurrentMoneyFmt2,
              [double(TCurrencyObjType(self.FCurrList.Objects[self.FCurrList.IndexOf(AnsiUpperCase(pCurr))]).currVal)]);
          Dialogs.MessageDlg(estbk_strmsg.SEAccCantUpdateCurrRates, mtError, [mbOK], 0);
        end
        else
        if pCurrCodeOvr = '' then
        begin
          edtCurrRate.Text := format(CCurrentMoneyFmt2, [double(0.00)]);
        end;
      end
      else
      if pCurrCodeOvr = '' then
      begin
        edtCurrRate.Text := format(CCurrentMoneyFmt2, [double(0.00)]);
      end;



      // sunnime dataset currency ovr uuendama !
      if pCurrCodeOvr = '' then
        edtCurrRate.OnExit(edtCurrRate);
    end;     // ---
  end;
end;



procedure TframeBankIncomeManually.edtAccDateExit(Sender: TObject);
var
  cval: TDatetime;
  pStr: AStr;
  pNewEdtSession: boolean;
  b: boolean;
begin
  cval := now;
  pStr := trim(TDateEdit(Sender).Text);
  if pStr <> '' then
  begin
    if not estbk_utilities.validateMiscDateEntry(pStr, cval) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
      if TEdit(Sender).CanFocus then
        TEdit(Sender).SetFocus;
      Exit; // ---
    end
    else
      TEdit(Sender).Text := datetostr(cval);
    b := True;
    // 13.06.2012 Ingmar; ei uuendanud kuupäeva, kui lihtsalt kirjutati kuupäev ja vajutati enter
    self.edtAccDateAcceptDate(Sender, cVal, b);
    if not pChkbVerified.Checked then
      try
        pNewEdtSession := _doEdit(qryIncomeLines);
        self.revalidateCurrExcRates;
        qryIncomeLines.FieldByName('payment_date').AsDateTime := TDateEdit(Sender).Date;
      finally
        _doPost(qryIncomeLines, pNewEdtSession);
      end;
  end;
end;

procedure TframeBankIncomeManually.edtClientChange(Sender: TObject);
var
  pNewEdtSession: boolean;
begin
  with TEdit(Sender) do
    if Focused and not FSkipOnChangeEvents and (Trim(Text) = '') then
      try
        qryUnpaidItems.DisableControls;
        qryIncomeLines.DisableControls;
        qryUnpaidItems.Filtered := False;
        //qryUnpaidItems.Filter:='(pquid=''X'') OR (item_type=0)'; //  item_type nö hall rida !
        qryUnpaidItems.Filter := '(pquid=''X'')';
        qryUnpaidItems.Filtered := True;
        gridClientUnpaidItems.DataSource := nil;

        // -- kliendi ID tuleb ka ära muuta !
        pNewEdtSession := _doEdit(qryIncomeLines);
        FSmartEditLastSuccIndx := -1;
        FSelectedClientID := -1;
        // paneme markeri, et korra välistati rida
        qryIncomeLines.FieldByName('client_id').AsInteger := 0; // -qryIncomeLines.FieldByName('client_id').AsInteger;
        _doPost(qryIncomeLines, pNewEdtSession);
      finally
        qryUnpaidItems.EnableControls;
        qryIncomeLines.EnableControls;
      end;
end;


// tegelt kogu see cache värk oli paras ämbrisse astumine !
procedure TframeBankIncomeManually.copyClientItemsToDataset(const pClient: integer);
var
  i: integer;
begin
  try
    qryUnpaidItems.DisableControls;
    FSkipDBEvents := True;
    FAllowRecInsert := True;

    qryWorker.Close;
    qryWorker.SQL.Clear;
    qryWorker.SQL.add(format('SELECT * FROM %s WHERE client_id=%d ORDER BY item_type,item_due_date',
      [self.FProcEntrys.incomeItemsTempTableName, pClient]));
    qryWorker.Open;
    qryWorker.First;

    // CACHE, et ei peaks pidevalt uuesti andmeid küsima !
    while not qryWorker.EOF do
    begin
      qryUnpaidItems.Append;
      for i := 0 to qryWorker.FieldCount - 1 do
      begin
        qryUnpaidItems.FieldValues[qryWorker.Fields[i].FieldName] := qryWorker.FieldValues[qryWorker.Fields[i].FieldName];
      end;

      qryUnpaidItems.FieldByName('client_id').AsInteger := pClient;
      qryUnpaidItems.FieldByName('lsitemhlp').AsString := estbk_types.SCFalseTrue[False];
      // 23.10.2011 Ingmar
      qryUnpaidItems.FieldByName('pguid').AsString := qryIncomeLines.FieldByName('pguid').AsString;
      // -- pole alguses seotud !
      qryUnpaidItems.Post;
      // qryUnpaidItems.AppendRecord();
      // ---
      qryWorker.Next;
    end;
  finally
    qryUnpaidItems.First;
    qryUnpaidItems.EnableControls;

    FSkipDBEvents := False;
    FAllowRecInsert := False;
    // --
    qryWorker.Close;
    qryWorker.SQL.Clear;
  end;
end;

procedure TframeBankIncomeManually.addMiscLine(const pClient: integer; const pGuid: AStr);
var
  pBookmark: TBookmark;
begin
  // 18.08.2011 Ingmar; kui ettemaksu kontot pole defineeritud, siis antud rida ei kuva üldse
  if _ac.sysAccountId[_accPrepayment] > 0 then
    if qryUnpaidItems.Active then
      with qryUnpaidItems do
        try
          pBookmark := qryGetAccounts.GetBookmark;
          qryGetAccounts.DisableControls;

          self.FAllowRecInsert := True;
          First; // -- varia rida peaks kõikidel klientidel olema esimene !
          Insert;
          // informatiivne osa !
          // fieldbyname('item_nr').AsString:=estbk_strmsg.SCIncInforLine;
          // fieldbyname('client_id').AsInteger:=pClient;
          FieldByName('item_type').AsInteger := estbk_lib_bankfiledefs.CResolvedDataType_asMisc;
          FieldByName('item_currency').AsString := estbk_globvars.glob_baseCurrency;
          FieldByName('item_currency_ovr').AsFloat := 1.000;
          FieldByName('item_currency_ovr_idt').AsFloat := 1.000;
          FieldByName('curr_diff').AsFloat := 0;
          FieldByName('payment_sum').AsFloat := 0;
          FieldByName('payment_sum_conv').AsFloat := 0;
          FieldByName('pguid').AsString := pGuid;

          // paneme vaikimisi konto seal ettemaks !
          if qryGetAccounts.Locate('id', integer(_ac.sysAccountId[_accPrepayment]), []) then
          begin
            FieldByName('account_id').AsInteger := qryGetAccounts.FieldByName('id').AsInteger;
            FieldByName('account_coding').AsString := qryGetAccounts.FieldByName('account_coding').AsString;
            FieldByName('account_currency').AsString := qryGetAccounts.FieldByName('default_currency').AsString;
            FieldByName('item_nr').AsString := qryGetAccounts.FieldByName('account_name').AsString;
          end;
          // --
          Post;
          //qryUnpaidItems.RecNo:=1;
        finally
          FAllowRecInsert := False;
          qryGetAccounts.GotoBookmark(pBookmark);
          qryGetAccounts.FreeBookmark(pBookmark);
          qryGetAccounts.EnableControls;
        end;
end;


procedure TframeBankIncomeManually.refreshClientItems(const pClient: integer; const pReloadItemsToTempTable: boolean = False);
var
  pReload: boolean;
  pGuid, pOrigFilt: string;
begin
  pReload := pReloadItemsToTempTable;
  // ntx on tundmatu klienti siis item filter = ''X' kui uuesti klient olemas, siis tuleb pguid järgi uuesti flt peale panna
  // et kõik controlid saaksid õige staatuse ! samuti pannakse itemitele filter õigesti peale !
  self.qryIncomeLinesAfterScroll(qryIncomeLines);
  gridClientUnpaidItems.Enabled := False;

  // -- käsitsi laadimisel pole eellaetud elemente; kandeid...st on, aga need siis juba eelnevalt salvestatud
  //if not self.fileMode then
  try
    FSkipDBEvents := True;
    qryUnpaidItems.DisableControls;
    pGuid := qryIncomeLines.FieldByName('pguid').AsString;
    pOrigFilt := qryUnpaidItems.Filter;
    // qryUnpaidItems.SortedFields:='';
    // qryUnpaidItems.SortType:=stIgnored;
    qryUnpaidItems.Filtered := False; // @@ -- peame kontrollima, kas kliendi andmed on juba laetud !
    // if qryIncomeLines.FieldByName('incoming_id').AsInteger>0 then
    pReload := pReload or not qryUnpaidItems.Locate('client_id', VarArrayOf([integer(pClient)]), []);
    // vaatame, kas kliendiga üldse seotud mingeid ridu tasutavate elementide seas
    // enne filtrit peab kontrollima ! pquid loogika on veel peal !
    // 27.02.2011 Ingmar; kas VARIA rida olemas (tumehall); rida vajalik täiendava kande jaoks !
    {
    if not qryUnpaidItems.Locate('item_type;client_id;pguid', VarArrayOf([ Integer(estbk_lib_bankfiledefs.CResolvedDataType_asMisc),
                                                                           Integer(pClient),
                                                                           AStr(qryIncomeLines.FieldByname('pguid').AsString)
                                                                          ]),[]) then
    }
    // me peame laadima "uue" kliendi andmed
    Screen.Cursor := crHourglass;
    if pReload then
    begin
      // muidu hakkab pidevalt sorteerima, paras katastroof !
      FProcEntrys.getClientUnpaidItems(pClient, pReload);
      // tulevikus ära muuta; hetkel laeme kliendi tasumata arve/tellimused ja kopeerime andmed datasetti
      // teoorias võis ju teha lihtsautn qryunpaiditems reloadi, aga siis lähevad kõik meie muudatused kaduma
      // ehk lihtsalt inserdime uued kirjed datasetti;
      // ---- peame uuesti sorteerimise taastama, kuna meie varia element peab olema esimene !
      copyClientItemsToDataset(pClient);
      // qryUnpaidItems.SortedFields:='';
      // qryUnpaidItems.SortType:=stIgnored;
      // kasutamata elementidel on vaid client_id täidetud / pguid mitte !
    end;
    //else
    begin
      refreshClientItemGuids(pClient);
    end;

    if not qryUnpaidItems.Locate('item_type;pguid', VarArrayOf([integer(estbk_lib_bankfiledefs.CResolvedDataType_asMisc),
      AStr(qryIncomeLines.FieldByName('pguid').AsString)]), []) then
    begin
      addMiscLine(pClient, pGuid);
    end;

    // @@taastame filtri !
    qryUnpaidItems.Filter := pOrigFilt;
    qryUnpaidItems.Filtered := True;
    // ---
    if qryUnpaidItems.State in [dsEdit, dsInsert] then
      qryUnpaidItems.Post;

  finally
    Screen.Cursor := crDefault;
    self.FSkipDBEvents := False;
    // gridClientUnpaidItems.SelectedColumn.Index:=gridClientUnpaidItems.Columns.Items[0].Index;
    qryUnpaidItems.EnableControls;
  end;

  // üks naljakas fookuse bugi; kui scroll käib ära, siis arvatakse, et itemitest soovime midagi valida
  if btnOpenClientList.CanFocus then
    btnOpenClientList.SetFocus;

  lazFocusFix2.Enabled := True;
  qryUnpaidItems.First;

  // 30.03.2011 Ingmar; dataset oli omistamata !
  if not assigned(gridClientUnpaidItems.DataSource) then
    gridClientUnpaidItems.DataSource := qryUnpaidItemsDs;
end;

procedure TframeBankIncomeManually.edtClientExit(Sender: TObject);
var
  pNewSession: boolean;
  pCodeToname: boolean;
  pSrcInst: TAStrList;
  pFirstname: AStr;
  pLastname: AStr;
  pNpMarker: integer;
  i: integer;
begin
  // 11.02.2011 Ingmar
  if pChkbVerified.Checked then
    Exit;

  pCodeToname := False;
  pSrcInst := estbk_clientdatamodule.dmodule.custFastSrcList;

  // 23.08.2011 Ingmar; klienti pole, proovime järsku hoopis kood !
  if FSmartEditLastSuccIndx < 1 then
    for i := 0 to pSrcInst.Count - 1 do
      if AnsiUpperCase(TClientData(pSrcInst.Objects[i]).FClientCode) = AnsiUpperCase(edtClient.Text) then
      begin
        FSmartEditLastSuccIndx := i;
        FSelectedClientID := TClientData(pSrcInst.Objects[i]).FClientId;
        pCodeToname := True;
        break;
      end;


  // ----
  with  TEdit(Sender) do
    try
      self.FSkipDBEvents := True;
      if (FSelectedClientID > 0) or (Text = '') then
      begin
        Color := clWindow;
        Font.Color := clWindowText;
      end
      else
      begin
        Color := estbk_types.MyFavRed2;
        Font.Color := clWhite;
      end;

      edtClient.Hint := '';
      // järelikult nime käsitsi ei otsitud
      pNewSession := _doEdit(qryIncomeLines);
      if FSelectedClientID < 1 then
      begin
        qryIncomeLines.FieldByName('client_id').AsInteger := 0;
        qryIncomeLines.FieldByName('firstname').AsString := '';
        qryIncomeLines.FieldByName('lastname').AsString := '';
        qryIncomeLines.FieldByName('fullname').AsString := edtClient.Text;
        gridClientUnpaidItems.DataSource := nil;
      end
      else if FSmartEditLastSuccIndx >= 0 then
      begin
        gridClientUnpaidItems.DataSource := self.qryUnpaidItemsDs;
        // -- kuna otsingunimistus on tagurpidi nimi, siis peame väikese hacki tegema;
        pFirstname := '';
        pLastname := pSrcInst.Strings[self.FSmartEditLastSuccIndx];
        pNpMarker := pos(estbk_types.CInternalConcatMarker, pLastname);

        if pNpMarker > 0 then
        begin
          pFirstname := copy(pLastname, pNpMarker + length(estbk_types.CInternalConcatMarker), length(pLastname) -
            pNpMarker - length(estbk_types.CInternalConcatMarker) + 1);
          pLastname := copy(pLastname, 1, pNpMarker - 1);
        end;


        qryIncomeLines.FieldByName('firstname').AsString := pFirstname;
        qryIncomeLines.FieldByName('lastname').AsString := pLastname;
        qryIncomeLines.FieldByName('fullname').AsString := trim(pFirstname + ' ' + pLastname);
        ReLoadClientCommonData(TClientData(pSrcInst.Objects[self.FSmartEditLastSuccIndx]), False);

        edtClient.Hint := TClientData(pSrcInst.Objects[FSmartEditLastSuccIndx]).FClientCode;
        edtClient.Text := Trim(pFirstname + ' ' + pLastname);
        estbk_utilities.changeWCtrlReadOnlyStatus(plowerpanel, False);
      end;
    finally
      _doPost(qryIncomeLines, pNewSession);
      FSkipDBEvents := False;
    end;
end;

procedure TframeBankIncomeManually.edtClientKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // UTF8 keypress kalaga seoses !
  if (qryIncomeLines.RecordCount < 1) or pChkbVerified.Checked then // 04.11.2016 Hull päev küttes, arved läksid valesti
    key := 0
  else if (key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    self.btnOpenClientList.OnClick(btnOpenClientList);
    key := 0;
  end;
end;

procedure TframeBankIncomeManually.edtClientKeyPress(Sender: TObject; var Key: char);
begin
  //if (qryIncomeLines.RecordCount < 1) or pChkbVerified.Checked then
  if (qryIncomeLines.RecordCount < 1) or pChkbVerified.Checked then
    key := #0;
end;

procedure TframeBankIncomeManually.chgCommCtrlEnabledStatus(const b: boolean);
begin
  estbk_utilities.changeWCtrlEnabledStatus(pSizepanel, b);
  estbk_utilities.changeWCtrlEnabledStatus(plowerpanel, b);
end;

procedure TframeBankIncomeManually.loadDataFromTempTable(const pFlushTable: boolean);
var
  pTemptableIncLines: AStr; // laekumise üldine info
  pTemptableIncItems: AStr; // laekumise reaga seotud arve/tellimus
begin
  //qryUnpaidItems.ShowRecordTypes:=[usUnmodified, usModified]; // usUnmodified, usModified, usInserted
  qryUnpaidItems.Filtered := False;
  qryUnpaidItems.Filter := '';
  pTemptableIncLines := FProcEntrys.incomeLinesTempTableName;
  pTemptableIncItems := FProcEntrys.incomeItemsTempTableName;
  if (pTemptableIncLines = '') or (pFlushTable) then
    self.FProcEntrys.createTempIncomeTables(pTemptableIncLines, pTemptableIncItems);

  with qryIncomeLines, SQL do
  begin
    // ---
    Close;
    Clear;
    add(format('SELECT * FROM %s', [pTemptableIncLines]));
    Open;

    First;
    chgCommCtrlEnabledStatus(not EOF);
    if qryIncomeLines.RecordCount < 1 then
    begin
      gridPEntry.DataSource := nil;
      Close;
    end
    else
    begin
      gridPEntry.DataSource := qryIncomeLinesDs;
      gridPEntry.Invalidate;
    end;
  end;


  // koostame ajutise tabeli !
  with qryUnpaidItems, SQL do
  begin
    // ---
    Close;
    Clear;
    add(format('SELECT * FROM %s  ORDER BY item_type,item_due_date', [pTemptableIncItems]));
    Open;
    // 11.12.2010 Ingmar; tühja datasetti pole mõtet kuvada !
    if RecordCount < 1 then
      gridClientUnpaidItems.DataSource := nil
    else
      gridClientUnpaidItems.DataSource := qryUnpaidItemsDs;
    gridClientUnpaidItems.Invalidate;
  end;
end;

procedure TframeBankIncomeManually.readBankFile(const pFilename: AStr; const pBankCode: AStr; const pMarkOkItemsAsVerif: boolean;
  const pSEPAIncomings: boolean = False);
var
  pBankFileDefPath: AStr;
  pError: AStr;
  pBankFiles: TAStrList;
begin
  self.fileMode := True; // !!!
  self.performCleanup;

  // paneel vaikimisi RO'ks !
  estbk_utilities.changeWCtrlReadOnlyStatus(self.plowerpanel, True);
  cmbCurrency.Enabled := False;

  // http://wiki.lazarus.freepascal.org/Multiplatform_Programming_Guide
  pBankFileDefPath := estbk_utilities.getAppPath + estbk_types.CDir_Conf + DirectorySeparator + CFile_bankfiledef;

  try
    try
      pBankFiles := TAStrList.Create;
      pBankFiles.Add(pFilename);
      if pSEPAIncomings then
      begin
        pError := '';
        FProcEntrys.readSEPAFiles(pBankFiles, pBankCode, pError);

        if pError <> '' then
          raise Exception.Create(pError);
      end
      else // loeme tavalisi pangafaile, CSV jne
      begin
        pError := '';
        if FProcEntrys.loadBankIFrmtFileDefs(pBankFileDefPath, pError) then
        begin
          pError := '';
          FProcEntrys.readFiles(pBankFiles, pBankCode, pError);
          if pMarkOkItemsAsVerif then
            FProcEntrys.markOkIncomingsAsVerified;

          if pError <> '' then
            raise Exception.Create(pError);
        end
        else
          raise Exception.Create(pError);
      end;

      // -- nii laeme andmed gridi, et saaks redigeerida !
      self.loadDataFromTempTable(False);
      self.revalidateItemsAddConv;
      // 18.03.2011 Ingmar
      self.qryIncomeLinesAfterScroll(qryIncomeLines);
      // self.calcTotalPaymentSum; 25.08.2011 rikutab totalsumi ära
    except
      on e: Exception do
        Dialogs.messageDlg(format(SEMajorAppError, [trim(e.message)]), mtError, [mbOK], 0);
    end;

    // ----
  finally
    FreeAndNil(pBankFiles);
  end;
end;



procedure TframeBankIncomeManually.btnNewLineClick(Sender: TObject);
var
  pTemptableIncLines: AStr;
  pTemptableIncItems: AStr;
  pDefaultAccount: AStr;
  i: integer;
  pIncNumber: AStr;
begin

  if not self.loadData then
    self.loadData := True;


  gridClientUnpaidItems.Enabled := False;
  // --
  self.performCleanup(False);



  self.FSelectedClientID := 0;
  self.FSelectedCol := nil;
  // self.loadDataFromTempTable(not qryIncomeLines.Active);
  // peame looma puhver tabelid, kui need puuduvad !
  pTemptableIncLines := self.FProcEntrys.incomeLinesTempTableName;
  if (pTemptableIncLines = '') then
  begin
    self.FProcEntrys.createTempIncomeTables(pTemptableIncLines, pTemptableIncItems);
  end;


  // -- peame taasavama qryd !
  // eelmine protseduur võtab dataseti ära, kui recordcount = 0, aga käsitsi sisestamisel peame lubama !
  gridPEntry.DataSource := qryIncomeLinesDs;
  gridClientUnpaidItems.DataSource := qryUnpaidItemsDs;
  // ---
  qryUnpaidItems.Active := True;
  qryIncomeLines.Active := True;

  qryUnpaidItems.DisableControls;
  qryUnpaidItems.Filtered := False;
  qryUnpaidItems.Filter := 'pquid=''X'''; // et puhvris oleks tühjad väärtused
  qryUnpaidItems.Filtered := True;
  qryUnpaidItems.EnableControls;

  // ---
  //self.FErrTrackingEnabled:=true;
  self.FErrTrackingEnabled := False;
  self.edtEDesrcr.Text := '';
  //cmbCurrency.ItemIndex:=cmbCurrency.Items.IndexOf(estbk_globvars.glob_baseCurrency);
  //edtAccDate.Date:=now;
  //edtAccDate.Text:=datetostr(edtAccDate.Date);
  // --
  //qryIncomeLines.Last;
  try
    self.FAllowRecInsert := True;
    self.FSkipDBEvents := True;
    //if qryIncomeLines.RecordCount<1 then
    qryIncomeLines.Append;
    //else
    //   qryIncomeLines.Insert;
    qryIncomeLines.FieldByName('pguid').AsString := estbk_utilities.uGuid36;
    qryIncomeLines.FieldByName('errorcode').AsInteger := estbk_lib_bankfilesconverr.CErrIncCustNotFound;
    qryIncomeLines.FieldByName('currency').AsString := estbk_globvars.glob_baseCurrency;
    qryIncomeLines.FieldByName('currency_drate_ovr').AsCurrency := 1.00;
    qryIncomeLines.FieldByName('payment_sum').AsCurrency := 0.00;
    // qryIncomeLines.FieldByName('payment_sum_fromfile').AsCurrency:=0.00;
    qryIncomeLines.FieldByName('payment_date').AsDateTime := now;
    qryIncomeLines.FieldByName('incoming_date').AsDateTime := now;
    qryIncomeLines.FieldByName('receiver_account_number').AsString := '';
    qryIncomeLines.FieldByName('receiver_account_number_iban').AsString := '';
    // --- INCNR nõuab suuremat fixi !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // TODO siia panna laekumise kande nr !
    // 10.08.2011 Ingmar; muutsin ära !
    //qryIncomeLines.FieldByname('acc_reg_incnr').asString:=estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(estbk_types.CAccGen_rec_nr);
    // 01.03.2012 Ingmar; numeraatorite reform
    pIncNumber := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', now, False, estbk_types.CAccInc_rec_nr);
    qryIncomeLines.FieldByName('acc_reg_incnr').AsString := pIncNumber;

    // eelväärtustame kõik väljad !
    for i := 0 to qryIncomeLines.Fields.Count - 1 do
      if qryIncomeLines.FieldByName(qryIncomeLines.Fields[i].FieldName).Value = null then
        if qryIncomeLines.Fields[i].DataType in [ftString, ftMemo, ftWideString] then
          qryIncomeLines.FieldByName(qryIncomeLines.Fields[i].FieldName).Value := ''
        else if qryIncomeLines.Fields[i].DataType in [ftInteger, ftFloat, ftCurrency] then
          qryIncomeLines.FieldByName(qryIncomeLines.Fields[i].FieldName).Value := 0;


    //if qryIncomeLines.RecordCount<1 then
    qryIncomeLines.Post;
  finally
    self.FSkipDBEvents := False;
    self.FAllowRecInsert := False;
  end;


  self.chgCommCtrlEnabledStatus(True);


  if qryUnpaidItems.Active and (qryUnpaidItems.RecordCount > 0) then
    gridClientUnpaidItems.DataSource := qryUnpaidItemsDs
  else
    gridClientUnpaidItems.DataSource := nil;
  gridClientUnpaidItems.Enabled := True;


  self.FSkipOnChangeEvents := True;
  // 15.03.2011 Ingmar
  pChkbVerified.Checked := False;
  self.FSkipOnChangeEvents := False;

  if btnOpenClientList.CanFocus then
    btnOpenClientList.SetFocus;

  // 19.08.2011 Ingmar; vaikimisi konto
  pDefaultAccount := trim(dmodule.userStsValues[CstsDefaultIncAcc]);
  if pDefaultAccount <> '' then
  begin
    dbLookupBankA.Enabled := True;
    dbLookupBankA.ReadOnly := False;
    qryGetBankAccounts.First;
    if qryGetBankAccounts.Locate('account_coding', pDefaultAccount, [loCaseInsensitive]) then
    begin
      dbLookupBankA.Value := IntToStr(qryGetBankAccounts.FieldByName('id').AsInteger);
      dbLookupBankA.OnSelect(dbLookupBankA);
      dbLookupBankA.Text := pDefaultAccount;
    end;
  end;
  // ----
  // et filtrid rakenduks
  //self.qryIncomeLinesAfterScroll(qryIncomeLines);
end;

procedure TframeBankIncomeManually.btnOpenAccEntryClick(Sender: TObject);
begin
  // ---
  if assigned(self.FFrameDataEvent) and (qryIncomeLines.FieldByName('acc_reg_id').AsInteger > 0) then
    self.FFrameDataEvent(Self, __frameOpenAccEntry, qryIncomeLines.FieldByName('acc_reg_id').AsInteger);
end;

procedure TframeBankIncomeManually.ReLoadClientCommonData(const pClientData: TClientData; const pReUpdateClientName: boolean = True);
var
  pClientIdMark: integer;
begin
  try
    FSkipOnChangeEvents := True;
    FSelectedClientID := pClientData.FClientId;

    qryIncomeLines.Edit;
    if pReUpdateClientName then
    begin
      edtClient.Text := pClientData.FCustFullNameRev;

      qryIncomeLines.FieldByName('fullname').AsString := pClientData.FCustFullName;
      qryIncomeLines.FieldByName('firstname').AsString := pClientData.FCustFirstname;
      qryIncomeLines.FieldByName('lastname').AsString := pClientData.FCustLastname;
    end;

    // ntx võetakse ja järjest vahetatakse kliente, siis guid ei muutu !!!!! ja kuvatakse eelmise kliendi andmeid
    // -- 22.10.2011 Ingmar; kui me pquid ei vahetada kliendi puhul, siis elemente kuvatakse edasi !
    pClientIdMark := pos('#', qryIncomeLines.FieldByName('pguid').AsString);
    if pClientIdMark = 0 then
      qryIncomeLines.FieldByName('pguid').AsString := estbk_utilities.uGuid36 + '#' + IntToStr(self.FSelectedClientID)
    else
      qryIncomeLines.FieldByName('pguid').AsString := copy(qryIncomeLines.FieldByName('pguid').AsString, 1, pClientIdMark - 1) +
        '#' + IntToStr(self.FSelectedClientID);
    qryIncomeLines.FieldByName('client_id').AsInteger := self.FSelectedClientID;
    edtClient.Hint := pClientData.FClientCode;

    // järsku oli viga, et klienti ei leitud, siis see ka meil korras
    self.validateSingleIncomeLine(qryIncomeLines);
    qryIncomeLines.Post;


    edtClient.Text := pClientData.FCustFullNameRev;
    edtClient.Color := clWindow;
    edtClient.Font.Color := clWindowText;

    // filtrid peale, et õige laekumisega kuvaksime õigeid laekumata arveid...
    self.setItemFilterForIncomeRec;
    // laeme siis uuesti arved / tellimused
    self.refreshClientItems(self.FSelectedClientID);
    self.FSkipOnChangeEvents := False;

    if dbLookupBankA.CanFocus then
      dbLookupBankA.SetFocus;

    // et veakoodid uuesti valideeritaks !
    qryIncomeLines.Edit;
    qryIncomeLines.Post;
    //gridPEntry.Invalidate;

  finally
    FSkipOnChangeEvents := False;

    chgCommCtrlEnabledStatus(True);
    Assert(edtAccDate.Enabled and not pChkbVerified.Checked);
    Assert(Assigned(dbEdtRefNr.DataSource));
  end;
end;

procedure TframeBankIncomeManually.btnOpenClientListClick(Sender: TObject);
var
  pClientData: TClientData;
  pCurrClientId: integer;
begin
  if (qryIncomeLines.RecordCount < 1) or pChkbVerified.Checked then
    Exit;

  pCurrClientId := self.FSelectedClientID;
  pClientData := estbk_frm_choosecustmer.__chooseClient(self.FSelectedClientID);
  if Assigned(pClientData) then
  begin
    ReLoadClientCommonData(pClientData);
  end;
end;

// tükeldame protseduure, muidu savechanges muutub liiga pikaks ja raske jälgida !
procedure TframeBankIncomeManually.doAccounting(const pPmtManager: TPaymentManager; const pCurrVals: TAStrList;
  const pOnlyPrepaymentEntry: boolean = False);
// @@SUB
{
   D pank/kassa vms K ostjate võlgnevus
}
  procedure fillCurrencyData(const pCls: TPaymentAccData; const pPDate: TDatetime;
    // et saaksime karjuda antud kuupäeva päevakurssi meil netu
  const pResItemCurrRateOnPDate: boolean = False // st valuuta võetakse
    );
  var
    pCurrIndex: integer;
    pCurrIdf: AStr;
  begin
    // märgime siis ka päevakursid ära !
    // RP.KONTO VALUUTA
    if Math.IsZero(pCls.currencyRate) then
    begin
      pCurrIdf := pCls.currencyIdentf;
      pCurrIndex := pCurrVals.IndexOf(pCurrIdf);
      if (pCurrIndex < 0) or Math.IsZero(TCurrencyObjType(pCurrVals.Objects[pCurrIndex]).currVal) then
        raise Exception.CreateFmt(SEIncfCurrencyRates, [pCurrIdf, datetostr(pPDate)]);
      pCls.currencyRate := TCurrencyObjType(pCurrVals.Objects[pCurrIndex]).currVal;
    end; // --
    // ARVE / TELLIMUSE VALUUTA
    if pResItemCurrRateOnPDate and Math.IsZero(pCls.pmtItemCurrRate) then
    begin
      pCurrIdf := pCls.pmtItemCurrIdentf;
      pCurrIndex := pCurrVals.IndexOf(pCurrIdf);
      if (pCurrIndex < 0) or Math.IsZero(TCurrencyObjType(pCurrVals.Objects[pCurrIndex]).currVal) then
        raise Exception.CreateFmt(SEIncfCurrencyRates, [pCurrIdf, datetostr(pPDate)]);
      pCls.pmtItemCurrRate := TCurrencyObjType(pCurrVals.Objects[pCurrIndex]).currVal;
    end;
  end;

var
  pOrderId: integer;
  pBillId: integer;
  pBankAccountId: integer;
  pErrorCode: integer;
  pItemFound: boolean;
  pIncomeAccData: TPaymentAccData;
  pPrepaymentSum: currency;
  pCurrIdf: AStr;
  pMarkStatus: AStr;
  pAccDate: TDatetime;

  pUsrSum: currency;
  pPaidSum: currency;
  pToPay: currency;
  pTempCalc: double;
begin

  pOrderId := 0;
  pBillId := 0;
  pAccDate := TDate(self.qryIncomeLines.FieldByName('payment_date').AsDateTime);


  // LAEKUMINE
  pPmtManager.paymentCurrId := 0;
  pPmtManager.paymentCurrency := self.qryIncomeLines.FieldByName('currency').AsString;
  pPmtManager.paymentCurrRate := self.qryIncomeLines.FieldByName('currency_drate_ovr').AsCurrency;
  if Math.isZero(pPmtManager.paymentCurrRate) then
    pPmtManager.paymentCurrRate := 1.00;




  // ntx pole arvet ja tellimust valitud, siis vaid ettemaksu kanne, aga  selle teeme all poole elses !
  if not pOnlyPrepaymentEntry then
  begin

    // OSTJATE VÕLGNEVUS
    // ------
    if (self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asBill) then
    begin
      pBillId := self.qryUnpaidItems.FieldByName('item_id').AsInteger;
      pIncomeAccData := pPmtManager.addAccEntry(pBillId, __pmtItemAsBill);
    end
    else
    if self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asOrder then
    begin
      pOrderId := self.qryUnpaidItems.FieldByName('item_id').AsInteger;
      pIncomeAccData := pPmtManager.addAccEntry(pOrderId, __pmtItemAsOrder);

      pIncomeAccData.descr := format(estbk_strmsg.CSOrderNr, [self.qryUnpaidItems.FieldByName('item_nr').AsString]);
    end
    else
    if self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asMisc then
    begin
      pOrderId := 0;
      pBillId := 0;
      pIncomeAccData := pPmtManager.addAccEntry(0, __pmtItemAsUnknown);
    end
    else
      assert(1 = 0, '#1');



    // ---
    pBankAccountId := self.qryIncomeLines.FieldByName('bank_bk_account_id').AsInteger;

    assert(pBankAccountId > 0, '#3');
    pPrepaymentSum := 0;




    //pIncomeAccData.regMRec:=pGenEntryMainRecId;
    // RP. KONTO VALUUTA
    pIncomeAccData.currencyIdentf := self.qryIncomeLines.FieldByName('bank_bk_account_currency').AsString;
    if pIncomeAccData.currencyIdentf = '' then
      pIncomeAccData.currencyIdentf := estbk_globvars.glob_baseCurrency;




    // ---
    pCurrIdf := trim(self.qryUnpaidItems.FieldByName('item_currency').AsString); // arve / tellimuse enda valuuta !
    if pCurrIdf = '' then
      pCurrIdf := estbk_globvars.glob_baseCurrency;




    // ARVE / TELLIMUSE VALUUTA
    pIncomeAccData.pmtItemCurrID := 0;
    pIncomeAccData.pmtItemCurrIdentf := trim(pCurrIdf); // laekumise valuuta
    if length(pIncomeAccData.pmtItemCurrIdentf) <> 3 then
      pIncomeAccData.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
    pIncomeAccData.pmtItemCurrRate := self.qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsFloat;
    // ehk valuutakurss laekumise kp.




    if (pIncomeAccData.currencyIdentf <> estbk_globvars.glob_baseCurrency) or // pangaga kontoga seotud rp. konto valuuta
      (pCurrIdf <> estbk_globvars.glob_baseCurrency) then                    // leitud arve või tellimuse või
    begin
      if not dmodule.revalidateCurrObjVals(pAccDate, pCurrVals) then
        raise Exception.CreateFmt(SEIncfCurrencyRates, [pCurrIdf, datetostr(pAccDate)]);
    end;


    pIncomeAccData.accountId := pBankAccountId;  // rp. kontoga seotud panga konto !
    pIncomeAccData.clientId := self.qryIncomeLines.FieldByName('client_id').AsInteger;
    pIncomeAccData.recType := estbk_types.CAccRecTypeAsDebit;



    //pIncomeAccData.sum:=self.qryUnpaidItems.fieldbyname('payment_sum').asCurrency; // !!! summa pangast paika !
    // ehk tasutav summa on JUBA konverteeritud ARVE / TELLIMUSE valuutasse !
    pUsrSum := self.qryUnpaidItems.FieldByName('payment_sum_conv').asCurrency;
    pIncomeAccData.sum := pUsrSum;
    // pIncomeAccData.descr:=self.FWorkerQry.fieldbyname('description').asString;



    // ---------------------------------
    // küsime päevakursid !
    fillCurrencyData(pIncomeAccData, pAccDate);



    //assert(math.IsZero(pIncomeAccData.pmtItemCurrRate-self.qryUnpaidItems.fieldbyname('item_currency_ovr_idt').asFloat,0.0001),'#3');

    if Math.isZero(pIncomeAccData.pmtItemCurrRate) then
      pIncomeAccData.pmtItemCurrRate := 1.00;


    pToPay := self.qryUnpaidItems.FieldByName('to_pay').asCurrency;
    pPaidSum := pIncomeAccData.sum;// ehk siis summa, mis laekumisega tasuti; teisendatud arve valuutasse !



    // ------------------------------------------------------------------------
    // ARVE / TELLIMUSE SUMMAD JA STAATUSED PAIKA !
    // @@ TODO
    // pmtmanager võiks ka tulevikus ise kindlaks teha, kas ettemaksud jne ei pea sellist jura rohkem tegema !
    // Vaatame, kas peame koostama ka ettemaksude kirjed collectioni



    if (self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asBill) then
    begin
      pMarkStatus := '';
      // kui maksta summa negatiivne, siis on kogu summa ettemaks !
      if (pToPay < 0) and ((pToPay - pPaidSum) <= 0.00) then   // 02.09.2011 Ingmar
      begin

        if self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asBill then
          pMarkStatus := estbk_types.CBillPaymentOk;
        // neg arvetega lood teised
        if pPaidSum > 0.00 then
        begin
          pPrepaymentSum := pPaidSum;
          pPaidSum := 0; // järelikult on arve juba tasutud !
        end
        else
        begin
          pPrepaymentSum := -(pToPay - pPaidSum);
          pPaidSum := pToPay;
        end;
        // --
      end
      else
      // tekkis ettemaks
      if (pToPay - pPaidSum) < 0 then
      begin
        pPrepaymentSum := pPaidSum - pToPay;
        pPaidSum := pToPay;

        if self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asBill then
          pMarkStatus := estbk_types.CBillPaymentOk;
      end
      else
      if pToPay > pPaidSum then // osaliselt laekunud !
        pMarkStatus := estbk_types.CBillPaymentPt
      else
      if (pPaidSum > 0) and (pToPay = pPaidSum) then // kõik on laekunud
        pMarkStatus := estbk_types.CBillPaymentOk;
    end
    else
    if (self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asOrder) then
    begin
      pMarkStatus := '';
      // vaatame, millise staatuse paneme ettemaksudele
      pPrepaymentSum := pPaidSum; // ettemaksu summa ARVE / TELLIMUSE valuutas !

      if pPaidSum >= pToPay then
        pMarkStatus := estbk_types.COrderPaymentOk
      else
        pMarkStatus := estbk_types.COrderPaymentPt;
    end;



    // -------------------------------------------------------------------
    // nii arve/tellimuse staatused ka teada...BRO
    // 07.02.2011 Ingmar
    //pPmtManager.convItemSumToBaseCurr(pIncomeAccData);
    //pIncomeAccData.pretermPmtStatus:=pMarkStatus;
    // --
    pIncomeAccData.isFinalAggrLine := True;  // RIDA nimega PANK; deebet

    pErrorCode := self.qryIncomeLines.FieldByName('errorcode').AsInteger;
    // meil ei õnnestunud leida, millega tegemist !
    pItemFound := not (pErrorCode in [CErrIncBillWNrNotFound, CErrIncOrderWNrNotFound, CErrIncCantResPayment]);




    // qryUnpaidItems.fieldByname('curr_diff').asFloat
    // Eelkalkuleeritud valuutavahe
    // -----------------------------------------------------------------------
    // VALUUTA VAHE
    // -----------------------------------------------------------------------



    if not Math.isZero(qryUnpaidItems.FieldByName('curr_diff').AsFloat) then
    begin
      pIncomeAccData := pPmtManager.cloneAccBasicEntry(pIncomeAccData);
      pIncomeAccData.currencyIdentf := estbk_globvars.glob_baseCurrency;


      // !!!!!
      // HETKEL ka valuutavahe kanne VAID baasvaluutas
      pIncomeAccData.currencyRate := 1.00;



      // fillCurrencyData(pIncomeAccData,pAccdate);
      pIncomeAccData.sum := abs(qryUnpaidItems.FieldByName('curr_diff').AsFloat);
      if qryUnpaidItems.FieldByName('curr_diff').AsFloat > 0 then
        pIncomeAccData.recType := estbk_types.CAccRecTypeAsCredit
      else
        pIncomeAccData.recType := estbk_types.CAccRecTypeAsDebit;



      // siin me elemendile ei viita
      pIncomeAccData.pmtItemCurrID := 0;
      pIncomeAccData.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
      pIncomeAccData.pmtItemCurrRate := 1.00;
    end;



    // -----------------------------------------------------------------------
    // ETTEMAKSU KANNE
    // -----------------------------------------------------------------------


    if not pItemFound or (pPrepaymentSum <> 0.00) then // ei leitud elementi või märkimisel saadi ettemaks !
    begin
      assert(self.qryIncomeLines.FieldByName('client_id').AsInteger > 0, '#2');
      // !!!!!
      pIncomeAccData := pPmtManager.cloneAccBasicEntry(pIncomeAccData);
      // rp. konto valuuta !
      pIncomeAccData.recType := estbk_types.CAccRecTypeAsCredit;


      pIncomeAccData.currencyIdentf := estbk_globvars.glob_baseCurrency;
      // HETKEL tohib antud ettemaksu kanne olla vaid baasvaluutas !
      pIncomeAccData.currencyRate := 1.00;
      fillCurrencyData(pIncomeAccData, pAccdate);



      pIncomeAccData.descr := '';
      pIncomeAccData.clientId := self.qryIncomeLines.FieldByName('client_id').AsInteger;

      // ettemaks = ka käibemaks ! enammaks, aga seda hoitakse arve küljes
      if self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asBill then
      begin
        // varasem kood !
        // pIncomeAccData.accountId:=estbk_clientdatamodule.dmodule.sysAccountId[_accPrepayment];
        if self.qryUnpaidItems.FieldByName('account_id').AsInteger < 1 then
          pIncomeAccData.accountId := _ac.sysAccountId[_accBuyersUnpaidBills]
        else
          pIncomeAccData.accountId := self.qryUnpaidItems.FieldByName('account_id').AsInteger; // Ostjate tasumata arved
        pIncomeAccData.descr := format(estbk_strmsg.CSSaleBillnr, [self.qryUnpaidItems.FieldByName('item_nr').AsString]);
      end
      else
        pIncomeAccData.accountId := _ac.sysAccountId[_accBuyersUnpaidBills];
      // ---



      // ARVE / TELLIMUSE VALUUTA
      pIncomeAccData.pmtItemCurrID := 0;
      pIncomeAccData.pmtItemCurrIdentf := trim(pCurrIdf); // laekumise valuuta


      if length(pIncomeAccData.pmtItemCurrIdentf) <> 3 then
        pIncomeAccData.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
      pIncomeAccData.pmtItemCurrRate := self.qryUnpaidItems.FieldByName('item_currency_ovr').AsFloat; // ehk valuutakurss laekumise kp.


      // teisendame baasvaluutasse  EUR !  Pole mõtet, baasklass teisendab !
      //pTempCalc:=pPrepaymentSum;
      //pTempCalc:=math.roundto(pTempCalc*qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsFloat,Z2);

      pIncomeAccData.sum := pPrepaymentSum;
      // lipp püsti, et tegemist ettemaksuga, täpsemalt öeldes; enammaks / tellimus ettemaks
      pIncomeAccData.isPrepayment := True;
    end;




    //  ARVE või VARIA rida !
    if ((self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asBill) or
      (self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asMisc)) then
    begin

      // KANNE
      // #########################
      // ostjate võlgnevused !!!!
      // #########################
      // !!!!!
      pIncomeAccData := pPmtManager.cloneAccBasicEntry(pIncomeAccData);




      pIncomeAccData.currencyIdentf := qryUnpaidItems.FieldByName('account_currency').AsString;
      pIncomeAccData.currencyRate := 1.00;
      fillCurrencyData(pIncomeAccData, pAccdate);

      // valuutaks jääb arve valuuta kurss;
      pIncomeAccData.pmtItemCurrRate := self.qryUnpaidItems.FieldByName('item_currency_ovr').AsFloat;
      pIncomeAccData.pmtItemCurrID := 0;
      pIncomeAccData.pmtItemCurrIdentf := self.qryUnpaidItems.FieldByName('item_currency').AsString;


      pIncomeAccData.recType := estbk_types.CAccRecTypeAsCredit;
      pIncomeAccData.clientId := self.qryIncomeLines.FieldByName('client_id').AsInteger;

      pIncomeAccData.isPrepayment := False;


      if (self.qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asBill) then
      begin
        if self.qryUnpaidItems.FieldByName('account_id').AsInteger < 1 then
          pIncomeAccData.accountId := _ac.sysAccountId[_accBuyersUnpaidBills]
        else
          pIncomeAccData.accountId := self.qryUnpaidItems.FieldByName('account_id').AsInteger; // Ostjate tasumata arved
        //pIncomeAccData.descr:='';

        // 01.04.2011 Ingmar; paneme elemendi kirjelduse ! kui tühistring siis kuvatakse konto nimi !
        pIncomeAccData.descr := format(estbk_strmsg.CSSaleBillnr, [self.qryUnpaidItems.FieldByName('item_nr').AsString]);

        // 22.10.2011 Ingmar; ma pole kindel, kas see aitab, kui võlalipp peab olema; sest võlgu ollakse arveid...
        pIncomeAccData.isDebt := True;

      end
      else // ---
        // Varia rida !
      begin
        pIncomeAccData.accountId := self.qryUnpaidItems.FieldByName('account_id').AsInteger;
        pIncomeAccData.descr := dbEdtDescr.Text;


        // paneme lipu püsti, et kasutati ettemaksu kontot !
        pIncomeAccData.isPrepayment := (pIncomeAccData.accountId = _ac.sysAccountId[_accPrepayment]);
      end;



      pIncomeAccData.sum := pPaidSum;
      // 02.09.2011 Ingmar
      //pIncomeAccData.isPrepayment:= pIncomeAccData.isPrepayment or (pPaidSum<0.00);


      // CSBillname       = 'Arve nr: %s';
      // CSOrderNumber    = 'Tellimuse nr: %s';
      // ettemaksu osa maha võetud ! ja kenasti teisendame baasvaluutaks EUR
      // -------------------------
                    {
                      pIncomeAccData.sum:=0.00;
                    // 02.09.2011 Ingmar; meeletu ettemaksude teema neg. arved
                    if pPaidSum<>0.00 then
                       pIncomeAccData.sum:=pPaidSum
                    else
                    if pPrepaymentSum<0.00 then
                       pIncomeAccData.sum:=pPrepaymentSum;

                    if pIncomeAccData.sum<0 then
                       pIncomeAccData.isPrepayment:=true;}
      // -------------------------
    end;

  end
  else
    // "puhas" enammaksu märkimine
  begin

    pIncomeAccData := pPmtManager.addAccEntry(0, __pmtItemAsUnknown);
    pIncomeAccData.pmtItemCurrID := 0;
    pIncomeAccData.pmtItemCurrIdentf := pPmtManager.paymentCurrency;
    if length(pIncomeAccData.pmtItemCurrIdentf) <> 3 then
      pIncomeAccData.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
    pIncomeAccData.pmtItemCurrRate := pPmtManager.paymentCurrRate;


    // rp. konto valuuta !
    pIncomeAccData.recType := estbk_types.CAccRecTypeAsCredit;


    pIncomeAccData.currencyIdentf := estbk_globvars.glob_baseCurrency;
    // HETKEL tohib antud ettemaksu kanne olla vaid baasvaluutas !
    pIncomeAccData.currencyRate := 1.00;
    fillCurrencyData(pIncomeAccData, pAccdate);




    // --  kliendiga seotud ettemaksu konto
    if self.qryIncomeLines.FieldByName('client_prpaccount_id').AsInteger > 0 then
      pIncomeAccData.accountId := self.qryIncomeLines.FieldByName('client_prpaccount_id').AsInteger  // !!!!!
    else
      pIncomeAccData.accountId := _ac.sysAccountId[_accPrepayment];       // !!!!!
    pIncomeAccData.descr := '';

    pIncomeAccData.sum := qryIncomeLines.FieldByName('payment_sum').asCurrency;
    pIncomeAccData.isPrepayment := True;



    // PANK
    pIncomeAccData := pPmtManager.cloneAccBasicEntry(pIncomeAccData);
    pIncomeAccData.sum := qryIncomeLines.FieldByName('payment_sum').asCurrency;
    pIncomeAccData.recType := estbk_types.CAccRecTypeAsDebit;

    // ---
    pBankAccountId := self.qryIncomeLines.FieldByName('bank_bk_account_id').AsInteger;
    assert(pBankAccountId > 0, '#3');
    pIncomeAccData.accountId := pBankAccountId;


    pIncomeAccData.currencyIdentf := self.qryIncomeLines.FieldByName('bank_bk_account_currency').AsString;
    if pIncomeAccData.currencyIdentf = '' then
      pIncomeAccData.currencyIdentf := estbk_globvars.glob_baseCurrency;


    pIncomeAccData.pmtItemCurrID := 0;
    pIncomeAccData.pmtItemCurrIdentf := pPmtManager.paymentCurrency;
    if length(pIncomeAccData.pmtItemCurrIdentf) <> 3 then
      pIncomeAccData.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
    pIncomeAccData.pmtItemCurrRate := pPmtManager.paymentCurrRate;


    fillCurrencyData(pIncomeAccData, pAccdate);

    pIncomeAccData.isFinalAggrLine := True;
  end;
  // ---
end;

procedure TframeBankIncomeManually.addBankCharges(const pPmtManager: TPaymentManager);
var
  pSrvCharges: double;
  pIncomeAccData: TPaymentAccData;
begin

  pSrvCharges := qryIncomeLines.FieldByName('service_charges').asCurrency;
  if pSrvCharges > 0 then
  begin
    // ilusam kui kreedit eest !
    // -- K Pangakonto
    pIncomeAccData := pPmtManager.addAccEntry(0, __pmtItemAsUnknown);
    pIncomeAccData.pmtItemCurrID := 0;
    pIncomeAccData.pmtItemCurrIdentf := pPmtManager.paymentCurrency;
    if length(pIncomeAccData.pmtItemCurrIdentf) <> 3 then
      pIncomeAccData.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
    pIncomeAccData.pmtItemCurrRate := pPmtManager.paymentCurrRate;



    // rp. konto valuuta !
    pIncomeAccData.recType := estbk_types.CAccRecTypeAsCredit;
    pIncomeAccData.currencyIdentf := estbk_globvars.glob_baseCurrency;
    // teenustasu vaid baasvaluutas !
    pIncomeAccData.currencyRate := 1.00;
    pIncomeAccData.accountId := self.qryIncomeLines.FieldByName('bank_bk_account_id').AsInteger;
    pIncomeAccData.descr := '';

    pIncomeAccData.sum := qryIncomeLines.FieldByName('service_charges').asCurrency;
    pIncomeAccData.dontUseInOverAllCalc := True; // et ei üritaks arvele midagi juurde kirjutada !


    // -- D Panga teenustasud
    pIncomeAccData := pPmtManager.addAccEntry(0, __pmtItemAsUnknown);
    pIncomeAccData.pmtItemCurrID := 0;
    pIncomeAccData.pmtItemCurrIdentf := pPmtManager.paymentCurrency;
    if length(pIncomeAccData.pmtItemCurrIdentf) <> 3 then
      pIncomeAccData.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
    pIncomeAccData.pmtItemCurrRate := pPmtManager.paymentCurrRate;



    // rp. konto valuuta !
    pIncomeAccData.recType := estbk_types.CAccRecTypeAsDebit;
    pIncomeAccData.currencyIdentf := estbk_globvars.glob_baseCurrency;
    // teenustasu vaid baasvaluutas !
    pIncomeAccData.currencyRate := 1.00;
    pIncomeAccData.accountId := _ac.sysAccountId[_accBankCharges];
    if pIncomeAccData.accountId < 1 then
      raise Exception.Create(estbk_strmsg.SEIncMissingChargeAccount);
    pIncomeAccData.descr := '';
    pIncomeAccData.sum := qryIncomeLines.FieldByName('service_charges').asCurrency;
    pIncomeAccData.dontUseInOverAllCalc := True; // et ei üritaks arvele midagi juurde kirjutada !
  end;
end;

function TframeBankIncomeManually.createNewIncomingBankRecord(const pSessionId: integer): integer;
begin
  Result := 0;
  with self.qryWorker, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLInsertIncomingsBank);

      Result := dmodule.qryIncomingsBankSeq.GetNextValue;
      paramByname('id').AsInteger := Result;
      paramByname('incomings_import_session_id').AsInteger := pSessionId;

      paramByname('client_id').AsInteger := qryIncomeLines.FieldByName('client_id').AsInteger;
      paramByname('bank_id').AsInteger := qryIncomeLines.FieldByName('bank_id').AsInteger;

      paramByname('bank_code').AsString := qryIncomeLines.FieldByName('bank_code').AsString;
      paramByname('bank_archcode').AsString := qryIncomeLines.FieldByName('bank_archcode').AsString;
      paramByname('bank_rec_status').AsString := ''; // reserved
      paramByname('bank_op_code').AsString := ''; // reserved
      paramByname('payer_name').AsString := qryIncomeLines.FieldByName('fullname').AsString;
      paramByname('payer_refnumber').AsString := qryIncomeLines.FieldByName('payer_refnumber').AsString;
      paramByname('payer_mk_nr').AsString := qryIncomeLines.FieldByName('payer_mk_nr').AsString;
      paramByname('payment_sum').asCurrency := qryIncomeLines.FieldByName('payment_sum').asCurrency;
      paramByname('nr').AsString := '';  // reserved
      paramByname('state_treasury_refnr').AsString := '';  // reserved
      paramByname('receiver_account_number').AsString := qryIncomeLines.FieldByName('receiver_account_number').AsString;
      paramByname('receiver_account_number_iban').AsString := qryIncomeLines.FieldByName('receiver_account_number_iban').AsString;

      // postgres mingi bugi või zeoses ! otse ei saa kopeerida !
      paramByname('payment_date').AsString := estbk_utilities.datetoOdbcStr(qryIncomeLines.FieldByName('payment_date').AsDateTime);
      paramByname('payer_code').AsString := '';  // reserved
      paramByname('description').AsString := qryIncomeLines.FieldByName('description').AsString;
      paramByname('bank_description').AsString := '';  // reserved
      paramByname('incoming_date').AsString := estbk_utilities.datetoOdbcStr(qryIncomeLines.FieldByName('incoming_date').AsDateTime);
      paramByname('bank_account').AsString := qryIncomeLines.FieldByName('bank_account').AsString;
      paramByname('bank_account_iban').AsString := qryIncomeLines.FieldByName('bank_account_iban').AsString;
      paramByname('bank_bk_account_id').AsInteger := qryIncomeLines.FieldByName('bank_bk_account_id').AsInteger;
      paramByname('currency').AsString := qryIncomeLines.FieldByName('currency').AsString;
      paramByname('currency_drate_ovr').asCurrency := qryIncomeLines.FieldByName('currency_drate_ovr').asCurrency;
      paramByname('status').AsString := qryIncomeLines.FieldByName('status').AsString;
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      // 01.09.2011 Ingmar
      paramByname('service_charges').AsCurrency := qryIncomeLines.FieldByName('service_charges').AsInteger;
      execSQL;

    finally
      Close;
      Clear;
    end;
end;



function TframeBankIncomeManually.saveChanges: boolean;
var
  pGuids: TAStrList;
  pRegenFlag: boolean;
  pGuid: AStr;
  pAccRecDescr: AStr;
  pAccPeriodID: integer;
  pAccDate: TDatetime;
  pEntryNumber: AStr;

  //pItemsStatus    : TUpdateStatusSet;
  pRegenIncRecord: boolean;
  pAccRecordCanceled: boolean; // kas peame kanded uuesti tegema
  pNewAccRecCreated: boolean;
  pLeaveRecOpen: boolean; // kas jätame laekumised avatuks !
  pHasSelectedItems: boolean;
  pIncomingRecWasOpen: boolean;

  pOrderId: integer;
  pBillId: integer;
  pIncomingId: integer;
  pBankIncomeSessionId: integer;
  pBankIncomeId: integer;
  pGenEntryMainRecId: integer;
  pAccRecRefCount: integer;

  pIncomeSum: currency;
  pTotalIncomeSum: currency;
  pTotalItemSum: currency; // peab = pTotalIncomeSum
  pDocTypeId: TSystemDocType;

  pCurrValStList: TAStrList;

  pNewPmtMgrInst: TPaymentManager;
  pOkRecCount: integer;
  pDocId: int64;
  b, pNewEdtSession: boolean;
  pStrDMsg: astr;
begin

  try // ---
    Result := False;
    pOkRecCount := 0;
    self.FSavingData := True; // anname teada, et salvestame !
    // LAEKUMISTE puhul tuleb ikka mitu korda asjad üle küsida !
    // kontrollime andmed üle ja küsime kasutajalt, kas ikka teab mida teeb !
    b := self.validateIncomings(pOkRecCount);

    if not b then
    begin
      if pOkRecCount < 1 then
      begin
        Dialogs.messageDlg(estbk_strmsg.SEIncfZOkLines, mtError, [mbOK], 0);
        Exit;
      end
      else
      if Dialogs.messageDlg(estbk_strmsg.SEIncfLinesPartiallyOK, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Exit;
    end
    else
    if self.fileMode then
    begin
      if Dialogs.messageDlg(estbk_strmsg.SConfIncFLinesSave, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Exit;
    end;

    try
      try
        FSkipDBEvents := True;
        FFlagIncomeSumEdited := False;

        // -- siia jätame meelde aluskirje muudatused, mis nõuaksid valitud elementide kannete uuesti genereerimist !
        pGuids := TAStrList.Create;
        pCurrValStList := dmodule.createPrivateCurrListCopy();
        dmodule.revalidateCurrObjVals(date, pCurrValStList);

        qryIncomeLines.DisableControls;
        qryUnpaidItems.DisableControls;

        pNewPmtMgrInst := TPaymentManager.Create(__pmtModeAsIncome, pCurrValStList);
        // #
        dmodule.primConnection.StartTransaction;
        // pItemsStatus:=qryUnpaidItems.ShowRecordTypes;
        //pBookmark:=qryIncomeLines.GetBookmark;
        pGuid := qryIncomeLines.FieldByName('pguid').AsString;

        // paneme dokumendi ka kenasti paika !
        pDocTypeId := estbk_types._dsBankIncomes;

        qryIncomeLinesUpt.InsertSQL.Clear;  // pole vaja, kuna inserti peame me ise juhtima !
        qryIncomeLinesUpt.DeleteSQL.Clear;

        with qryIncomeLinesUpt.ModifySQL do
        begin
          Clear;
          add('UPDATE incomings_bank');
          add('SET payer_name=:fullname,');
          add('    payer_refnumber=:payer_refnumber,');
          add('    payer_mk_nr=:payer_mk_nr,');
          //add('    payment_sum=:payment_sum,');
          add('    bank_bk_account_id=:bank_bk_account_id,');
          add('    bank_account=:bank_account,');
          add('    description=:description,');
          add('    payment_sum=:payment_sum,');
          add('    currency=:currency,');
          add('    currency_drate_ovr=:currency_drate_ovr,');
          add('    status=:status,'); // kas avatud või mitte C siis suletud !
          add('    payment_date=:payment_date,');
          add('    incoming_date=:payment_date,');
          // 11.02.2011 Ingmar;
          add('    bank_id=:bank_id,');
          add('    service_charges=:service_charges');
          add('WHERE id=:incomings_bank_id');
        end;

        // 4# Kanded ja kandega read uuesti teha, kui sessiooni kirjel muutub:
        //  # pangakonto (bank_bk_account_id)
        //  # laekumise kuupäev
        //  # kliendiid
        //  # valuuta või valuutakurss
        pBankIncomeSessionId := self.FProcEntrys.createIncomeSessionId(True);


        // kirjutame puudulikud read ka logisse ära !
        self.FProcEntrys.writeErrReport();

        // --- aktsepteerime vaid korras kirjeid !
        qryIncomeLines.Filtered := False;
        qryIncomeLines.Filter := format('errorcode=%d', [CDataOK]);
        qryIncomeLines.Filtered := True;

        // TODO peaks veateate kuvama kui kirjeid ei leia
        // leiame muudatused !
        qryIncomeLines.First;
        while not qryIncomeLines.EOF do
        begin
          pRegenFlag := pos(CPnewIncItemGuidMarker, qryIncomeLines.FieldByName('pguid').AsString) > 0;
          if not pRegenFlag then // vartostr tagab ohutuse !
            pRegenFlag := (vartostr(qryIncomeLines.FieldByName('client_id').Value) <> vartostr(qryIncomeLines.FieldByName('client_id').OldValue)) or
              (vartostr(qryIncomeLines.FieldByName('currency').Value) <> vartostr(qryIncomeLines.FieldByName('currency').OldValue)) or
              (vartostr(qryIncomeLines.FieldByName('currency_drate_ovr').Value) <> vartostr(
              qryIncomeLines.FieldByName('currency_drate_ovr').OldValue)) or
              (vartostr(qryIncomeLines.FieldByName('payment_date').Value) <> vartostr(qryIncomeLines.FieldByName('payment_date').OldValue)) or
              (vartostr(qryIncomeLines.FieldByName('bank_bk_account_id').Value) <> vartostr(
              qryIncomeLines.FieldByName('bank_bk_account_id').OldValue));
          if pRegenFlag then
            pGuids.Add(qryIncomeLines.FieldByName('pguid').AsString);

          qryIncomeLines.Next;
        end;

        // pAccRecDescr:=formatdatetime('yyyymmdd',date)+'_'+extractfilename(self.FCurrBankFile);
      {
        LAEKUMISTE MÄRKIMINE
        üldiselt teha nii, kui siiski ei leita mida klient maksis, siis parem panna ettemaksuks,
        kui üldse mitte märkida !!! Sest juhul, kui mingi arve lähebki tal võlgu, siis kasutatakse ettemaks ära !
      }
        // ---------------------------------------------------------------------
        // standardkanne !
        // D pank/kassa vms K ostjate võlgnevus
        // ---------------------------------------------------------------------
        // qryUnpaidItems.ShowRecordTypes:=[usModified,usDeleted]; // usUnmodified / usInserted
        // --
        qryIncomeLines.First;
      {
       * st peakirje muutuse sündmused automaatselt kohustavad kõiki kandeid uuesti tegema ! 4#
       * Laekumisega seotud elementide kanded uuesti teha, kui ...
       * muutub elemendi summa
       * valiti / tühistati mõne elemendi valik nimistus
       * muutus elemendiga seotud konto
       }

        while not qryIncomeLines.EOF do
        begin
          // antud laekumise reaga seotud elemendid ARVED / TELLIMUSED
          qryUnpaidItems.Filtered := False;
          qryUnpaidItems.Filter := 'pguid=' + QuotedStr(qryIncomeLines.FieldByName('pguid').AsString);
          qryUnpaidItems.Filtered := True;



          // qryUnpaidItems.ShowRecordTypes:=[usModified,usDeleted];
          // ---
          pGenEntryMainRecId := 0;
          pBankIncomeId := 0;
          pAccRecordCanceled := False;
          pNewAccRecCreated := False;
          pHasSelectedItems := False;

          // laekumise kogusumma ! payment_sum itemite juures on "jaotatud summa"
          pTotalIncomeSum := qryIncomeLines.FieldByName('payment_sum').AsCurrency;
          pTotalItemSum := 0;

          try
            // -- kirjutame värskelt loodud kirjeinfo tagasi !
            pBankIncomeId := qryIncomeLines.FieldByName('incomings_bank_id').AsInteger;
            pNewEdtSession := _doEdit(qryIncomeLines);
            try
              if pBankIncomeId < 1 then
              begin
                pBankIncomeId := createNewIncomingBankRecord(pBankIncomeSessionId);
                qryIncomeLines.FieldByName('incomings_bank_id').AsInteger := pBankIncomeId;
              end;
            finally
              _doPost(qryIncomeLines, pNewEdtSession);
            end;

            // jätame laekumiste kande avatuks ! vaatame staatust !
            pLeaveRecOpen := (pos(estbk_types.CIncomeRecStatusClosed, self.qryIncomeLines.FieldByName('status').AsString) = 0);

            // -- finantskande puhvrid tühjaks !
            pNewPmtMgrInst.clearData;
            pGenEntryMainRecId := qryIncomeLines.FieldByName('acc_reg_id').AsInteger;


            if not qryIncomeLines.FieldByName('payment_date').IsNull then
              pAccDate := qryIncomeLines.FieldByName('payment_date').AsDateTime
            else
              pAccDate := edtAccDate.Date;

            //   ---
            // laekumise kinnitatud; koostame kande peakirje
            if (pGenEntryMainRecId = 0) then
            begin
              pDocId := 0;
              // ---
              // TODO siia panna laekumise kande nr !
              // 01.03.2012 Ingmar; numeraatorite reform
              pEntryNumber := Trim(qryIncomeLines.FieldByName('acc_reg_incnr').AsString);
              if pEntryNumber = '' then
              begin
                pEntryNumber := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '',
                  pAccDate, // 22.04.2012 Ingmar edtAccDate.Date,
                  False, estbk_types.CAccInc_rec_nr);
                // 06.09.2016 Ingmar; estbk_types.CAccGen_rec_nr oli, aga see peaks olema viga peaks olema laekumiste seeria nr   CAccInc_rec_nr
              end;

              if not dmodule.createNewGenLedgerMainRec(qryIncomeLines.FieldByName('acc_period_id').AsInteger,  // rp. period
                pAccDate,// edtAccDate.Date,  22.04.2012 kande kuupäev
                qryIncomeLines.FieldByName('description').AsString, estbk_types._dsBankIncomes,
                qryIncomeLines.FieldByName('payer_mk_nr').AsString, // dokumendi nr
                estbk_types.CAddRecIdentAsIncome, pGenEntryMainRecId, pDocId, pEntryNumber) then
                Abort;


              // kirjutame kande ID tagasi cachetud kirjetesse
              qryIncomeLines.Edit;
              qryIncomeLines.FieldByName('acc_reg_id').AsInteger := pGenEntryMainRecId;
              qryIncomeLines.Post;

              // ---
              pNewAccRecCreated := True;
            end
            else
              // 17.08.2011 Ingmar; vaatame, kas järsku muutus kande kuupäev,
              // seda bugi raporteeriti mulle, kus laekumise kuupäev muutus, aga kande kuupäev mitte !
              with qryWorker, SQL do
                try
                  Close;
                  Clear;
                  if vartoStr(qryIncomeLines.FieldByName('payment_date').Value) <> vartoStr(qryIncomeLines.FieldByName('payment_date').OldValue) then
                  begin
                    pAccPeriodID := 0;
                    // kõige ohutum on exception tõstatada !
                    if not dmodule.isValidAccountingPeriod(qryIncomeLines.FieldByName('payment_date').AsDateTime, pAccPeriodID) then
                      raise Exception.Create(estbk_strmsg.SEAccDtPeriodNotFound);

                    add(estbk_sqlclientCollection._CSQLUpdateAccReg);
                    parambyname('transdescr').AsString := qryIncomeLines.FieldByName('description').AsString;
                    parambyname('transdate').AsDateTime := qryIncomeLines.FieldByName('payment_date').AsDateTime;
                    parambyname('accounting_period_id').AsInteger := pAccPeriodID;
                    parambyname('type_').Value := null; // --
                    parambyname('rec_changed').AsDateTime := now;
                    parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
                    parambyname('id').AsInteger := pGenEntryMainRecId;
                    execSQL;
                  end; // -- uuendame kandekirjel ka kuupäeva ära !!!

                finally
                  Close;
                  Clear;
                end;

            // 20.08.2011 Ingmar
            // -- selline olukord; A) salvestati laekumine ja B) siis alles kinnitati
            pIncomingRecWasOpen := False;
            if not pNewAccRecCreated then
              try
                pIncomingRecWasOpen := (pos(estbk_types.CIncomeRecStatusClosed, vartostr(self.qryIncomeLines.FieldByName('status').OldValue)) = 0);
              except
                pIncomingRecWasOpen := False;
              end;

            // ---
            pAccRecRefCount := 0; // jälgime vajadust reaalselt kannete salvestamiseks !
            pNewPmtMgrInst.accMainRec := pGenEntryMainRecId;
            {$ifdef debugmode}
            //showmessage(qryIncomeLines.FieldByName('pguid').asString + ' * '+inttostr(qryUnpaidItems.RecordCount)+qryUnpaidItems.filter);
            {$endif}

            qryUnpaidItems.First;
            // nüüd käime, siis laekumistega seotud elemendid läbi !
            while not qryUnpaidItems.EOF do
            begin
              pRegenIncRecord := False;
              pIncomingId := qryUnpaidItems.FieldByName('incoming_id').AsInteger;
              pIncomeSum := qryUnpaidItems.FieldByName('payment_sum').AsCurrency;    // tegemist on nö summa jaotamisele ühele elemendile
              // kontroll
              pTotalItemSum := pTotalItemSum + pIncomeSum;
              pOrderId := 0;
              pBillId := 0;
              if (qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asBill) then
                pBillId := self.qryUnpaidItems.FieldByName('item_id').AsInteger
              else
              if (qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asOrder) then
                pOrderId := self.qryUnpaidItems.FieldByName('item_id').AsInteger;

              // 20.12.2010 Ingmar
              // --- ja nüüd vastavalt muutusele peame incomings tabeli ära korrigeerima / samuti antud reaga seotud raamatupidamis kande !!!!
              pRegenIncRecord := (((vartostr(qryUnpaidItems.FieldByName('payment_sum').Value)) <>
                (vartostr(qryUnpaidItems.FieldByName('payment_sum').OldValue))) or
                ((vartostr(qryUnpaidItems.FieldByName('account_id').Value)) <>
                (vartostr(qryUnpaidItems.FieldByName('account_id').OldValue))) or
                ((vartostr(qryUnpaidItems.FieldByName('lsitemhlp').Value)) <>
                (vartostr(qryUnpaidItems.FieldByName('lsitemhlp').OldValue)))) or
                (pGuids.IndexOf(qryIncomeLines.FieldByName('pguid').AsString) >= 0); // !!!
              {

              // @@@ ära kustutada pole mõtet ! hea kasutada debugimisel !
              if pRegenIncRecord then
                 showmessage(qryIncomeLines.FieldByName('pguid').asString+' - '+#13#10+' summa '+
                              (vartostr(qryUnpaidItems.fieldByname('payment_sum').Value))+' # '+
                              (vartostr(qryUnpaidItems.fieldByname('payment_sum').OldValue))+#13#10+

                              'konto: '+(vartostr(qryUnpaidItems.fieldByname('account_id').Value))+' # '+
                              (vartostr(qryUnpaidItems.fieldByname('account_id').OldValue))+#13#10+

                              'valitud: '+
                              (vartostr(qryUnpaidItems.fieldByname('lsitemhlp').Value))+' # '+
                              (vartostr(qryUnpaidItems.fieldByname('lsitemhlp').OldValue))+#13#10+
                              inttostr(pGuids.IndexOf(qryIncomeLines.FieldByname('pguid').asString))

                             );
              }

              // Tühistame varasemad kanded
              // kas kriitilised andmed muutusid või taasavati kanne !
              if (pRegenIncRecord or pLeaveRecOpen) and not pAccRecordCanceled and (pGenEntryMainRecId > 0) then
              begin
                // kusjuures antud funktsioon mängib ümber ka kõik varasemad laekumised st vabastab !
                pNewPmtMgrInst.doCancelAllEntrys(pGenEntryMainRecId);
                pAccRecordCanceled := True; // teeme kanded uuesti !
              end;

              if (pIncomingId > 0) then
              begin
                // Vana kirje jätame alles ! mitte midagi ei uuenda üle, sest rp. muutused tuleb logida !
                // Kui mingi jama tekib, siis saab asju taasesitada !
                if pRegenIncRecord then
                  with qryWorker, SQL do
                    try
                      Close;
                      Clear;
                      add(estbk_sqlclientcollection._SQLUpdateIncomingStatus);
                      paramByname('id').AsInteger := pIncomingId;
                      paramByname('status').AsString := estbk_types.CRecIsCanceled;
                      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
                      paramByname('rec_changed').AsDateTime := now;
                      execSQL;
                    finally
                      Close;
                      Clear;
                    end;
              end
              else // ---
                pRegenIncRecord := True; // uus kirje, antud juhul kindlasti laekumiste kirje lisada !

              // --- 28.12.2010 Ingmar; fix, kui klient muudeti laekumisel ära, siis teeme uuesti laekumiste kirjed, kus kliendi id klapib !
              // --- Teisel juhul jääbki tühistatuks !
              if (qryUnpaidItems.FieldByName('client_id').AsInteger > 0) and (qryUnpaidItems.FieldByName('client_id').AsInteger <>
                qryIncomeLines.FieldByName('client_id').AsInteger) then
                pRegenIncRecord := False;

              // ----------------------------------------------------------------
              // kirjutame ära laekumiste kirje !
              // ----------------------------------------------------------------

              if estbk_utilities.isTrueVal(qryUnpaidItems.FieldByName('lsitemhlp').AsString) then
              begin

                pHasSelectedItems := True;
                if pRegenIncRecord then
                begin
                  pIncomingId := dmodule.qryIncomingsSeq.GetNextValue; // seq paika !
                  qryIncomings.ParamByname('id').AsInteger := pIncomingId;
                  qryIncomings.ParamByname('incomings_bank_id').AsInteger := pBankIncomeId;
                  qryIncomings.ParamByname('accounting_register_id').AsInteger := pGenEntryMainRecId;
                  qryIncomings.ParamByname('account_id').AsInteger := qryUnpaidItems.FieldByName('account_id').AsInteger;
                  // ARVE / TELLIMUSE primaarne rp.konto !
                  qryIncomings.ParamByname('cash_register_id').AsInteger := 0; // kassa maksete puhul vaid !
                  qryIncomings.ParamByname('client_id').AsInteger := self.qryIncomeLines.FieldByName('client_id').AsInteger;
                  qryIncomings.ParamByname('bill_id').AsInteger := pBillId;
                  qryIncomings.ParamByname('order_id').AsInteger := pOrderId;
                  {
                    sellel pole otseselt pointi, kui ntx nüüd, kus redigeeritakse laekumiste ridu,
                    siis kirjete uuesti genereerimisel kaob rec_nr point ära; samas siiski jätame välja alles, sest tulevikus võib vaja minna !
                  }
                  qryIncomings.ParamByname('rec_nr').AsInteger := 0;
                  if not self.qryIncomeLines.FieldByName('payment_date').IsNull then
                    qryIncomings.ParamByName('payment_date').AsDateTime := self.qryIncomeLines.FieldByName('payment_date').AsDateTime
                  else
                    qryIncomings.ParamByName('payment_date').AsDateTime := now;

                  qryIncomings.ParamByname('incoming_date').AsDateTime := self.qryIncomeLines.FieldByName('payment_date').AsDateTime;
                  // kuskohast laekumine pärit !
                  qryIncomings.ParamByname('direction').AsString := estbk_types.CIncDirectionIN; // CIncSrcFromBank;
                  // laekumise originaalsumma; st valuutas, milles laekus !
                  qryIncomings.ParamByname('income_sum').asCurrency := pIncomeSum;
                  qryIncomings.ParamByname('currency_id').AsInteger := 0;
                  qryIncomings.ParamByname('currency').AsString := self.qryIncomeLines.FieldByName('currency').AsString;
                  qryIncomings.ParamByname('currency_drate_ovr').asCurrency := self.qryIncomeLines.FieldByName('currency_drate_ovr').asCurrency;
                  qryIncomings.ParamByname('conv_income_sum').asCurrency := qryUnpaidItems.FieldByName('payment_sum_conv').AsCurrency;
                  qryIncomings.ParamByname('conv_currency_id').AsInteger := 0;
                  qryIncomings.ParamByname('conv_currency').AsString := qryUnpaidItems.FieldByName('item_currency').AsString;
                  // et arve / tellimuse valuutakurss vastavalt laekumise kuupäevale !
                  qryIncomings.ParamByname('conv_currency_drate_ovr').asCurrency :=
                    self.qryUnpaidItems.FieldByName('item_currency_ovr_idt').asCurrency;
                  //qryIncomings.ParamByname('source').asString:=estbk_types.CIncSrcBank;
                  qryIncomings.ParamByname('status').AsString := '';
                  qryIncomings.ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
                  qryIncomings.ParamByname('rec_changed').AsDateTime := now;
                  qryIncomings.ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
                  qryIncomings.ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
                  qryIncomings.ExecSQL;

                  // peegeldame laekumise kirje ID
                  qryUnpaidItems.Edit;
                  qryUnpaidItems.FieldByName('incoming_id').AsInteger := pIncomingId;
                  qryUnpaidItems.Post;
                end; // -->

                // ------------------------------------------------------
                // KOOSTAME KANDED JA MÄRGIME LAEKUMISED ARVETELE !
                // ------------------------------------------------------
                if not pLeaveRecOpen then
                begin
                  // pNewAccRecCreated = laekumised märgiti ja kohe kinnitati
                  // pRegenIncRecord =  muudeti midagi arvete tellimuste valikus
                  // pIncomingRecWasOpen = laekumine salvestati, kuid kinnitati hiljem !
                  if (pNewAccRecCreated or pRegenIncRecord or pIncomingRecWasOpen) then  // kinnitatud või muudetud !
                    Inc(pAccRecRefCount);


                  // 06.02.2011 Ingmar; bugi...sisuliselt kujuta avati salvestatud laekumine
                  // lisati uus, nüüd tekkis vaid uue elemendi kanne ! see on VALE; puhverdame KÕIK kanded uuesti ja vajadusel kirjutame baasi !
                  self.doAccounting(pNewPmtMgrInst, pCurrValStList);
                end;
                // ------------------------------------------------------
              end;

              // järgmine element nimistus !
              qryUnpaidItems.Next;
            end; // ---

            // ridade summa peab võrduma laekumise üldsummaga; pigem rohkem sisemine kontroll
            if pHasSelectedItems then
            begin
              if (pTotalIncomeSum <> pTotalItemSum) then
                raise Exception.CreateFmt(estbk_strmsg.SEIncItemSumNEqWithTotal, [pTotalItemSum, pTotalIncomeSum]);
            end
            else if not pLeaveRecOpen and (pNewAccRecCreated or pRegenIncRecord) then
              self.doAccounting(pNewPmtMgrInst, pCurrValStList, True);  // TÕSTAME ÜLES SIIS ETTEMAKSU !

            // -------------------------------------------------------------
            // KIRJUTAME KANDED LÕPUKS ÄRA
            // -------------------------------------------------------------
          {$ifdef debugmode}
            // pNewPmtMgrInst.writeEntryLog('c:\debug.txt');
            // showmessage(inttostr(pNewPmtMgrInst.accEntryWriteCount)+' '+inttostr(pAccRecRefCount));
          {$endif}

            // NB NB !!!!
            // kirjutame kanded füüsiliselt baasi ära ! false näitab, et kursivahesid mitte arvutada !
            // PÄRIS JÕHKER BUGI !
            // 17.08.2011 Ingmar; sisuliselt me koostasime kõikide ridade tarbeks kanded...
            // AGA me ei vaadanud, kas reaalselt oleks vaja neid ka salvestada !
            // pAccRecRefCount näitab, kas reaalsete kannete koostamiseks ka vajadust.

            if pAccRecRefCount > 0 then
            begin
              self.addBankCharges(pNewPmtMgrInst);
              //pNewPmtMgrInst.writeEntryLog('c:\debug\test.txt');
              pNewPmtMgrInst.doSaveAccEntrys(False);
            end;

            // ----
          except //on e : exception do
            begin
              // logime ja tõstame uuesti üles !
              // raise; lihtsalt ei tööta mingi FPC kala
              raise; // exception.Create(e.Message);
            end;
          end;

          // ---
          qryIncomeLines.Next;
        end;

      finally
        FreeAndNil(pGuids);
        FreeAndNil(pCurrValStList);
        FreeAndNil(pNewPmtMgrInst);
        //qryUnpaidItems.ShowRecordTypes:=pItemsStatus;
        qryUnpaidItems.EnableControls;
        qryUnpaidItems.Filter := '';
        qryUnpaidItems.Filtered := False;

        qryIncomeLines.Locate('pguid', pGuid, []);
        qryIncomeLines.EnableControls;
        FSkipDBEvents := False;
      end;

      // @@ transaktsioon
      //{$ifndef debugmode}
      // -------------
      dmodule.primConnection.Commit;
      // -------------
      //{$else}
      // -------------
      //dmodule.primConnection.Rollback; // testandmed tõmbame kenasti tagasi
      // -------------
      //{$endif}

      // lõpuks kirjutame muudatused ära
      // {$ifndef debugmode}

      qryIncomeLines.ApplyUpdates;
      qryIncomeLines.CommitUpdates;

      qryUnpaidItems.ApplyUpdates;
      qryUnpaidItems.CommitUpdates;
      //{$endif}
      // 23.08.2011 Ingmar; Laekumiste nr ka cachetaks !
      dmodule.markNumeratorValAsUsed(PtrUInt(self), estbk_types.CAccInc_rec_nr, dbedtIncnr.Text, edtAccDate.Date);
      Result := True;

      // ----- et ikka oleks õige controlite staatused !
      self.qryIncomeLinesAfterScroll(qryIncomeLines);
      // -----
      // nuppude staatused paika
      if not self.fileMode then
        btnNewLine.Enabled := True;

      // 05.02.2011 Ingmar; bugi peame ka uuesti kuvama ebakorrektseid kirjeid !
      qryIncomeLines.Filtered := False;
      qryIncomeLines.Filter := '';
      // DEBUG
    {
    with qryWorker,sql do
        begin
        close; clear;
        add('update bills');
         add('set payment_status='''',incomesum=0.00,prepaidsum=0.00');
         execsql;

         close; clear;
         add('delete from incomings_bank');
         execsql;
        end;
    }



      // 18.03.2011 Ingmar; peale edukat salvestamist lähme tavalisse reziimi, et saaks vajadusel täiendavalt redigeerida
      pImgListOpenClose.Enabled := False;
      // !!!!!!!!!!!!!!
      self.fileMode := False;
      // !!!!!!!!!!!!!!
      pImgListOpenClose.Enabled := True;


      btnSave.Enabled := False;
      btnCancel.Enabled := False;

    except
      on e: Exception do
      begin
        self.FSkipDBEvents := False;
        if dmodule.primConnection.inTransaction then
          try
            dmodule.primConnection.Rollback;
          except
          end;

        // dialogs.messageDlg(format(estbk_strmsg.SEMajorAppError,[e.message]),mterror,[mbOk],0);
        Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed2, [e.message]), mtError, [mbOK], 0);
      end;
    end;


  finally
    self.FSavingData := False; // teavitame, et salvestamine lõppenud !
  end;
end;


procedure TframeBankIncomeManually.saveChanges2;
var
  b: boolean;
begin
  try
    FErrTrackingEnabled := True;
    b := saveChanges;

    lazFocusFix.Enabled := False;
    lazFocusFix2.Enabled := False;

  finally
    if b then // kui korras, siis..,
    begin
      qryUnpaidItems.First;
      gridClientUnpaidItems.SelectedField := qryUnpaidItems.FieldByName('item_nr');

      btnSave.Enabled := False;
      btnCancel.Enabled := False;
      btnNewLine.Enabled := True;
    end;
  end;
end;

// 19.09.2011 Ingmar
procedure TframeBankIncomeManually.revalidateUserPtItems;
var
  pPaid: double;
  pToPay: double;
  pBookmark: TBookmark;
  b1, b2, b3: boolean;
begin
  try
    // väldime eventide poolseid reaktsioone !
    b1 := btnNewLine.Enabled;
    b2 := btnSave.Enabled;
    b3 := btnCancel.Enabled;

    qryUnpaidItems.DisableControls;
    pBookmark := qryUnpaidItems.GetBookmark;

    self.FSkipDBEvents := True;
    // uuendame arvesummad ära !
    self.FProcEntrys.reUpdateCachedItems();
    // --- ja tuleb ka olemasolev cache sellega ära syncida !
    qryUnpaidItems.First;

    while not qryUnpaidItems.EOF do
    begin

      self.FProcEntrys.fetchItemPmtData(qryUnpaidItems.FieldByName('item_id').AsInteger,
        qryUnpaidItems.FieldByName('item_type').AsInteger,
        pPaid,
        pToPay
        );

      // uuendame summad ära !
      qryUnpaidItems.Edit;
      qryUnpaidItems.FieldByName('paid').AsFloat := pPaid;
      qryUnpaidItems.FieldByName('to_pay').AsFloat := pToPay;
      qryUnpaidItems.Post;
      // --
      qryUnpaidItems.Next;
    end;

  finally
    qryUnpaidItems.First;
    self.FSkipDBEvents := False;
    // ---
    qryUnpaidItems.GotoBookmark(pBookmark);
    qryUnpaidItems.FreeBookmark(pBookmark);
    qryUnpaidItems.EnableControls;

    btnNewLine.Enabled := b1;
    btnSave.Enabled := b2;
    btnCancel.Enabled := b3;
  end;
end;

procedure TframeBankIncomeManually.btnCancelClick(Sender: TObject);
//var
//  pVerif   : TPaymentManager;
//  pErrCode : AStr;
begin
  if self.fileMode then
  begin

    // faili sisestamise puhul tähendab see, et tegevus katkestati
    if assigned(self.onFrameKillSignal) then
      self.onFrameKillSignal(self);

  end
  else
    btnNewLine.Enabled := True;


  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  //qryIncomeLines.RevertRecord;
  self.performCleanup(False);
  qryIncomeLines.CancelUpdates;
  qryIncomeLinesAfterScroll(qryIncomeLines);
  chgCommCtrlEnabledStatus(qryIncomeLines.RecordCount > 0);

  if not qryIncomeLines.active or (qryIncomeLines.RecordCount < 1) then
  begin
    gridClientUnpaidItems.DataSource := nil;
  end;

  // --- et ikka oleks ka korrektne nimi TEditis
  edtClient.Text := qryIncomeLines.FieldByName('fullname').AsString;
  //  estbk_utilities.changeWCtrlReadOnlyStatus(self.plowerpanel,true);
  //  cmbCurrency.Enabled:=false;
  //  self.FProcEntrys.loadIncomings(4);
end;

procedure TframeBankIncomeManually.btnCloseClick(Sender: TObject);
begin
  if assigned(self.onFrameKillSignal) then
    self.onFrameKillSignal(self);
end;

procedure TframeBankIncomeManually.btnSaveClick(Sender: TObject);
begin
  self.saveChanges2;
end;


procedure TframeBankIncomeManually.edtClientUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
var
  pSrcInst: TAStrList;
  pRez: boolean;
  pNewSession: boolean;
  i: integer;
begin
  // mingi naljakas utf-8 kala ! keydown annab küll, et key=0, aga siia jõuab ikkagit tulemus
  if UTF8Key = #10 then
  begin
    UTF8Key := #0;
    exit;
  end;

  // ---
  pSrcInst := estbk_clientdatamodule.dmodule.custFastSrcList;
  pRez := estbk_utilities.edit_autoCustDataStrListAutoComp(Sender, pSrcInst, self.FSmartEditSkipCtrlChars, UTF8Key,
    self.FSmartEditSkipChar, self.FSmartEditLastSuccIndx, nil);

  if not pRez and (TCustomEdit(Sender).Text <> '') then
  begin
    TCustomEdit(Sender).Color := estbk_types.MyFavRed2;
    TCustomEdit(Sender).Font.Color := clWhite;
    self.FSmartEditLastSuccIndx := -1;
    self.FSelectedClientID := -1;
  end
  else
  begin
    TCustomEdit(Sender).Color := clWindow;
    TCustomEdit(Sender).Font.Color := clWindowText;
    if self.FSmartEditLastSuccIndx >= 0 then
    begin
      self.FSelectedClientID := TClientData(pSrcInst.Objects[self.FSmartEditLastSuccIndx]).FClientId;
      // peame ka nime dubleerima, sest seda kuvatakse gridis !
    end
    else if TCustomEdit(Sender).Text <> '' then
    begin
      TCustomEdit(Sender).Color := estbk_types.MyFavRed2;
      TCustomEdit(Sender).Font.Color := clWhite;
      self.FSelectedClientID := -1;
    end;
  end;

  if (UTF8Key = TUTF8Char(#13)) or (UTF8Key = TUTF8Char(#09)) then
  begin
    SelectNext(Sender as twincontrol, True, True);
  end
  else
    UTF8Key := TUTF8Char(#0);
end;

procedure TframeBankIncomeManually.edtCurrRateExit(Sender: TObject);
var
  p: Astr;
begin
  // paneme kursi paika !
  with TEdit(Sender) do
  begin
    qryIncomeLines.Edit;
    p := estbk_utilities.setRFloatSep(Text);
    Text := format(CCurrentAmFmt4, [StrToFloatDef(p, 0)]);
    qryIncomeLines.FieldByName('currency_drate_ovr').AsFloat := StrToFloatDef(p, 0);
    qryIncomeLines.Post;
  end;
end;

procedure TframeBankIncomeManually.edtCurrRateKeyPress(Sender: TObject; var Key: char);
begin
  if key = ^V then
    key := #0
  else if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else
  begin
    if cmbCurrency.Text = estbk_globvars.glob_baseCurrency then
      key := #0
    else if key in ['+', '-'] then
      key := #0
    else
      estbk_utilities.edit_verifyNumericEntry(Sender as TCustomEdit, key, True);
  end;
end;

procedure TframeBankIncomeManually.gridClientUnpaidItemsEditingDone(Sender: TObject);
begin
  // ---
end;


procedure TframeBankIncomeManually.gridPEntryCellClick(Column: TColumn);
begin
  // --
end;

procedure TframeBankIncomeManually.gridPEntryColEnter(Sender: TObject);
begin

end;

function TframeBankIncomeManually.grpErrors(const pErrorCode: integer): TPmtLineErrorLevels;
begin
  // ---
  Result := _pmtLvlOK;
  if (pErrorCode in [CErrIncCustNotFound, CErrIncAlreadyExists, CErrIncRecvBankAccountNotFound, CErrIncCantDetermAccount,
    CErrIncValidAccPeriodNotFound, CErrIncBankAccNotFound, CErrIncAccNrNotFound, CErrIncDateIsEmpty, CErrIncSrcAccountNrEmpty,
    CErrIncCurrencyIsUnkn, CErrIncObjectAccIdUnkn, CErrIncSumIszero]) then
    Result := _pmtLvlcriticalerror
  else
  if (pErrorCode in [CErrIncBillWNrNotFound, CErrIncOrderWNrNotFound, CErrIncMissingObjects]) then
    Result := _pmtLvlmediumerror;
end;


procedure TframeBankIncomeManually.gridPEntryDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
var
  pData: AStr;
  pBitmap: TBitmap;
  pErrorLvl: TPmtLineErrorLevels;
begin
  with (Sender as TDBGrid) do
    //if not DataSource.DataSet.EOF then
  begin
    pErrorLvl := grpErrors(TDbGrid(Sender).DataSource.DataSet.FieldByName('errorcode').AsInteger);

    // käsitsi sisestatakse laekumist ! remapime vea...
    if not self.fileMode and (pErrorLvl = _pmtLvlCriticalError) and (qryIncomeLines.FieldByName('incoming_id').AsInteger = 0) then
      // (qryIncomeLines.State=dsInsert) and
      pErrorLvl := _pmtLvlMediumError;


    // gdFocused, gdFixed, gdHot
    if (gdSelected in State) then
    begin
      Brush.Color := clBackGround;
      Font.Color := clWhite;
    end
    else
    begin
      Canvas.Brush.Color := clWindow; // MyFavGreen; //clInfoBk; //;
      Font.Color := clBlack;
      //if not TDbGrid(Sender).DataSource.DataSet.EOF then
      case pErrorLvl of
        _pmtLvlCriticalError: Canvas.Brush.Color := MyFavLightRed;
        _pmtLvlMediumError: Canvas.Brush.Color := clInfoBk;
        _pmtLvlOK: Canvas.Brush.Color := MyFavGreen;
      end;
    end;
    //Canvas.FillRect(Rect);
    if assigned(Column.Field) then
      pData := Column.Field.AsString
    else
      pData := '';
    // ----
    Canvas.FillRect(Rect);
    if (Column.Index = CCol_LineMsg) then // and  not TDbGrid(Sender).DataSource.DataSet.EOF
      try
        //Canvas.Draw(Rect.left,Rect.top);
        pBitmap := TBitmap.Create;
        // ---
        case pErrorLvl of
          _pmtLvlCriticalError: dmodule.sharedImages.GetBitmap(estbk_clientdatamodule.img_indError, pBitmap);
          _pmtLvlMediumError: dmodule.sharedImages.GetBitmap(estbk_clientdatamodule.img_indQuestionMark, pBitmap);
          _pmtLvlOK: dmodule.sharedImages.GetBitmap(estbk_clientdatamodule.img_indxOk, pBitmap);
        end;
        if (DataSource.DataSet.RecordCount > 0) then
          Canvas.Draw(Rect.left, Rect.top, pBitmap);
      finally
        FreeAndNil(pBitmap);
      end
    else
    begin
      if Column.Index in [CCol_Sum, CCol_PaymentSumFromFile] then
      begin
        if Assigned(Column.Field) then
          pData := Format(CCurrentMoneyFmt2, [Column.Field.AsCurrency])
        else
          pData := Format(CCurrentMoneyFmt2, [0.00]);
      end
      else
      if Column.Index = CCol_Verified then // kas kinnitatud või mitte !
      begin
        // kas kanne kinnitatud
        if pos(estbk_types.CRecIsClosed, Column.Field.AsString) > 0 then
          pData := estbk_strmsg.SCommYes
        else
          pData := estbk_strmsg.SCommNo;
      end
      else
        pData := Column.Field.AsString;
      Canvas.TextOut(Rect.left + 2, Rect.top + 2, pData);
    end;
  end;
end;

procedure TframeBankIncomeManually.gridPEntryEnter(Sender: TObject);
begin
  // --
end;

procedure TframeBankIncomeManually.gridPEntryPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin
  // --
end;

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// TODO: kui aega on tee protseduurile cleanup, need ptemp...ajavad segadusse
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
procedure TframeBankIncomeManually.doConversions(const pBaseSum: double;
  const pConvBillSum: boolean = False // ehk tasutud summa on juba teisendatud arve valuutasse...
  );
// sooritab ristkursside arvutused;
// -
// # esimesel valikul konverteeritakse payment sum antud arve valuutasse
// # teisel juhul tuleb sisestatud summa konverteerida arve valuutaks
{
HKD   1.5073700000
USD   11.6988000000

            HKD          USD
HKD   1.0000000000   7.7610672894
USD   0.1288482579   1.0000000000
}

var
  pCurrrateCl: double; // arvele/tellimusele märgitud valuutakurss
  pCurrrateBl: double; // arve valuuta kurss vastavalt laekumise kuupäevale
  pCurrrateIn: double; // laekumise valuutakurss
  pCurrDiff: double; // kursivahe
  pRoundSum: double; // ümmardus
  pTemp: double;
  pTemp1: double;
  pTemp2: double;
  pNewSession: boolean;
  pCurrIndex: integer;
begin

  try

    //pRoundSum:=0.00;
    pNewSession := not (qryUnpaidItems.State in [dsEdit, dsInsert]);
    if pNewSession then
      qryUnpaidItems.Edit;




    // 27.02.2011 Ingmar
    if qryUnpaidItems.FieldByName('item_type').AsInteger = CResolvedDataType_asMisc then
    begin
      qryUnpaidItems.FieldByName('payment_sum').AsCurrency := pBaseSum;
      qryUnpaidItems.FieldByName('payment_sum_conv').AsCurrency := pBaseSum;
      Exit; // -->
    end;




    pCurrIndex := self.FCurrList.IndexOf(qryUnpaidItems.FieldByName('item_currency').AsString);
    assert(pCurrIndex >= 0, '#2');
    pCurrrateCl := qryUnpaidItems.FieldByName('item_currency_ovr').AsFloat; // --



    // baasvaluuta peab alati olema kursiga 1.000 !!!!
    if qryUnpaidItems.FieldByName('item_currency').AsString = estbk_globvars.glob_baseCurrency then
      qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsCurrency := 1.00;
    qryUnpaidItems.FieldByName('curr_diff').AsFloat := 0.00;

    // peame võtma vastavalt laekumise kuupäevale kursi
    pCurrrateBl := double(TCurrencyObjType(self.FCurrList.Objects[pCurrIndex]).currVal); // arve / tellimuse valuuta kurss
    pCurrrateIn := strtofloatdef(setRFloatSep(edtCurrRate.Text), 0);
    // ---------
    // TODO; 24.01.2011 Ingmar; selle peaelt saab tulevikus kuvada ka ümmarduse summar; algsumma-roundto(algsumma,z2)



    pCurrDiff := 0;
    // unise peaga ei tohi koodi kirjutada :)
    if ((pCurrrateIn <= 0) or // kurssi pole, siis tekiks 0 jagamine !
      (pCurrrateBl <= 0)) then
    begin
      qryUnpaidItems.FieldByName('payment_sum').AsCurrency := 0;
      qryUnpaidItems.FieldByName('payment_sum_conv').AsCurrency := 0;
    end
    else
    if ((qryUnpaidItems.FieldByName('item_currency').AsString <> estbk_globvars.glob_baseCurrency) or
      (cmbCurrency.Text <> estbk_globvars.glob_baseCurrency)) then
    begin

      // esmalt teisendame arve valuuta baasvaluutaks; TODO;laekumiste kursivahed ?!? nüüd on meil siis eluke baasvaluutas
      if pConvBillSum then
      begin
        pTemp := pBaseSum * pCurrrateCl;  // arve valuuta kurss arve loomise hetkel
        pTemp1 := pBaseSum * pCurrrateBl;  // arve valuuta hetke kurss EUR; tasumise kuupäev
      end
      else
      begin
        // ehk meil on teisendus tehtud;
        pTemp := (pBaseSum / pCurrrateBl) * pCurrrateCl;
        pTemp1 := pBaseSum; // summa lahtris alati baasvaluuta !
      end;


      // --- eelkalkuleeritud kursivahe
      if not Math.isZero(pBaseSum) then
      begin
        if not pConvBillSum then
          pCurrDiff := pCurrDiff * pCurrrateCl;  // arve valuuta kurss arve loomise hetkel

        assert(((pTemp1 > 0) and (pTemp > 0)), '#4');

        pTemp2 := pTemp1 - pTemp;
        pCurrDiff := Math.roundto(pTemp1 - pTemp, Z2); // pTemp1;vahe koos ümmardusega
        pTemp1 := pTemp + pCurrDiff; // et ümmardus satuks ikka lõppsummasse ! tulevikus eraldi kuvada ?
        // leiame võimaliku ümmarduse arve hetke valuutast !
        //pRoundSum:=math.roundto(pTemp,Z2);
        //pRoundSum:=pTemp-pRoundSum; // arve summa hetke valuutas

      end
      else
        pCurrDiff := 0.00;




      // ---
      // showmessage(floattostr(pCurrDiff)+' '+floattostr(ptemp)+' '+floattostr(ptemp1));


      // ---
      qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsCurrency := pCurrrateBl;
      // arve / tellimuse; valuuta kurss vastavalt laekumise kuupäevale !
      qryUnpaidItems.FieldByName('curr_diff').AsFloat := pCurrDiff;



      // ehk siis ntx failist tulnud arve / tellimuse summa teisendame arve valuutasse
      if pConvBillSum then
      begin

        // nö nüüd konverteerime arve summa valuutaks, mis valitud laekumistes; ehk kui laekumise valuuta GBP,
        // siis võtame arve kus tasuda summa USD ja konv. ta väärtuseks; et visuaalselt saaks aru
        pTemp2 := (pTemp1 / pCurrrateIn);
        pTemp1 := Math.roundto(pTemp2, Z2);
        //pRoundSum:=pRoundSum+(pTemp2-pTemp1); //  -------- ümmardus

        // --
        qryUnpaidItems.FieldByName('payment_sum').AsCurrency := pTemp1;




        // -- arve valuutasse
        pTemp2 := (ptemp1 * pCurrrateIn) / pCurrrateBl;
        pTemp1 := Math.roundto(pTemp2, Z2);
        //pRoundSum:=pRoundSum+(pTemp2-pTemp1);

        qryUnpaidItems.FieldByName('payment_sum_conv').AsCurrency := ptemp1;

      end
      else
      begin

        pTemp := pBaseSum * pCurrrateIn; // järelikult summa juba korra konverteeritud
        pTemp2 := (pTemp / pCurrrateBl);
        pTemp1 := Math.roundto(pTemp2, Z2);

        // ---
        //pRoundSum:=pRoundSum+(pTemp2-pTemp1);  // -------- ümmardus

        qryUnpaidItems.FieldByName('payment_sum_conv').AsCurrency := pTemp1;
        qryUnpaidItems.FieldByName('payment_sum').AsCurrency := pBaseSum;
      end;

    end
    else
    begin

      qryUnpaidItems.FieldByName('payment_sum_conv').AsCurrency := pBaseSum; // qryUnpaidItems.FieldByName('payment_sum').AsCurrency;
      qryUnpaidItems.FieldByName('payment_sum').AsCurrency := pBaseSum;

      if qryUnpaidItems.FieldByName('item_currency').AsString = estbk_globvars.glob_baseCurrency then
        qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsCurrency := 1.00
      else
        qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsCurrency := 0;
    end;



  finally

    if pNewSession then
      try
        qryUnpaidItems.Post;
      except
      end;
  end;
end;

// sisuliselt faili laadimisel tuleb arvutada konverteerimiskurss; samas ei ole hea vaid SQLis seda teha
// 02.02.2011 Ingmar
procedure TframeBankIncomeManually.revalidateItemsAddConv;
var
  pBookmark: TBookmark;
  pQryUnpFilter: AStr;
  pQryUnFiltered: boolean;
  pLineSum: double;
  pItemIndex: integer;
begin
  if qryIncomeLines.Active and (qryIncomeLines.RecordCount > 0) then
    try


      self.FSkipDBEvents := True;
      pBookmark := qryIncomeLines.GetBookmark;
      qryIncomeLines.DisableControls;

      pQryUnpFilter := qryUnpaidItems.Filter;
      pQryUnFiltered := qryUnpaidItems.Filtered;

      qryUnpaidItems.DisableControls;
      qryUnpaidItems.Filtered := False;



      // ---
      qryIncomeLines.First;

      while not qryIncomeLines.EOF do
      begin

        qryUnpaidItems.Filtered := False;
        qryUnpaidItems.Filter := 'pguid=' + QuotedStr(qryIncomeLines.FieldByName('pguid').AsString);
        qryUnpaidItems.Filtered := True;
        qryUnpaidItems.First;

        // 18.03.2011
        if not qryUnpaidItems.EOF then
        begin
          if qryUnpaidItems.FieldByName('to_pay').AsCurrency > 0 then
            pLineSum := qryUnpaidItems.FieldByName('to_pay').AsCurrency
          else
            pLineSum := double(qryUnpaidItems.FieldByName('payment_sum').OldValue);



          // TODO: tulevikus teha nii, et ei toimuks pidevat kursside uuendamist !
          if (self.qryUnpaidItems.FieldByName('item_currency').AsString = estbk_globvars.glob_baseCurrency) or
            (self.qryIncomeLines.FieldByName('currency').AsString = estbk_globvars.glob_baseCurrency) then
          begin

            pItemIndex := self.FCurrList.IndexOf('USD');
            if (pItemIndex >= 0) and ((TCurrencyObjType(self.FCurrList.Objects[pItemIndex]).currDate <>
              qryIncomeLines.FieldByName('payment_date').AsDateTime) or (isZero(TCurrencyObjType(self.FCurrList.Objects[pItemIndex]).currVal))) then
              dmodule.revalidateCurrObjVals(qryIncomeLines.FieldByName('payment_date').AsDateTime, self.FCurrList)
            else
              dmodule.resetCurrObjVals(now + 1, self.FCurrList);
          end;




          // ---
          if estbk_utilities.isTrueVal(qryUnpaidItems.FieldByName('lsitemhlp').AsString) then
            try
              qryUnpaidItems.Edit;
              self.doConversions(pLineSum, True);

              if isZero(qryUnpaidItems.FieldByName('payment_sum_conv').AsFloat) then
                qryUnpaidItems.FieldByName('lsitemhlp').AsString := SCFalseTrue[False];

            finally
              qryUnpaidItems.Post;
            end;

        end;

        // ---
        qryIncomeLines.Next;
      end;

    finally
      if assigned(pBookmark) then
      begin
        qryIncomeLines.GotoBookmark(pBookmark);
        qryIncomeLines.FreeBookmark(pBookmark);
      end;


      qryUnpaidItems.Filter := pQryUnpFilter;
      qryUnpaidItems.Filtered := pQryUnFiltered;

      // ---
      qryUnpaidItems.EnableControls;
      qryIncomeLines.EnableControls;
      self.FSkipDBEvents := False;
    end;
end;


procedure TframeBankIncomeManually.gridClientUnpaidItemsCellClick(Column: TColumn);
var
  pLineSum: double;
  pNewEdtSession: boolean;
  pChecked: boolean;
  b: boolean;

begin

  b := not assigned(gridClientUnpaidItems.DataSource) or (qryUnpaidItems.RecordCount < 1) or
    (pos(estbk_types.CIncomeRecStatusClosed, qryIncomeLines.FieldByName('status').AsString) > 0) or self.disallowIncomeEditing;

  if b then
    Exit;

  // --
  //if assigned(gridClientUnpaidItems.SelectedColumn) and (gridClientUnpaidItems.SelectedColumn.Index = CColItems_pcheckbox) and assigned(column) then
  if assigned(column) and (Column.Index = CColItems_pcheckbox) then
    try
      // 07.02.2011 Ingmar; editori rekursioon
      //gridClientUnpaidItems.Columns.Items[CColItems_incomesum].ReadOnly:=false;
      //qryUnpaidItems.DisableControls;
      self.FFlagIncomeSumEdited := False;



      // 26.01.2011 Ingmar; FIX
      if qryGetAccounts.Locate('id', qryUnpaidItems.FieldByName('account_id').AsInteger, []) then
        self.FLcmpAccountCode := qryUnpaidItems.FieldByName('account_coding').AsString
      else
        self.FLcmpAccountCode := '';



      pNewEdtSession := not (qryUnpaidItems.State in [dsEdit, dsInsert]);
      // --
      if pNewEdtSession then
        qryUnpaidItems.Edit;

      pChecked := not (AnsiUpperCase(copy(qryUnpaidItems.FieldByName('lsitemhlp').AsString, 1, 1)) = 'T');
      // ---
      qryUnpaidItems.FieldByName('lsitemhlp').AsString := estbk_types.SCFalseTrue[pChecked];




      if pChecked then
      begin

        if qryUnpaidItems.FieldByName('to_pay').AsCurrency > 0 then
        begin
          pLineSum := qryUnpaidItems.FieldByName('to_pay').AsCurrency;
          //          if not math.isZero(pCurrrateIn) then
          //             pLineSum:=math.roundto(pLineSum/pCurrrateIn,Z2);
        end
        else
        begin
          //          if not math.isZero(pCurrrateIn) then
          pLineSum := double(qryUnpaidItems.FieldByName('payment_sum').OldValue);
          if pLineSum = 0 then
            pLineSum := qryUnpaidItems.FieldByName('to_pay').AsCurrency;
        end;


        self.refreshDailyCurrencyRates(qryUnpaidItems.FieldByName('item_currency').AsString);

        // --
        self.doConversions(pLineSum, True);
      end
      else
      begin
        qryUnpaidItems.FieldByName('payment_sum').asCurrency := 0;
        qryUnpaidItems.FieldByName('payment_sum_conv').asCurrency := 0;
      end;



      // ----
      gridClientUnpaidItems.Repaint;



      // Kui kasutajal on nö veel tasumata arveid, siis seos panga laekumise kirjega puudub; st pguid on = ''
      // nüüd kui element valitakse seostatakse elemendi kirje laekumise kirjega pguid abil !

      if pChecked then
      begin
        qryUnpaidItems.FieldByName('pguid').AsString := qryIncomeLines.FieldByName('pguid').AsString;
      end
      else
      if qryUnpaidItems.FieldByName('incoming_id').AsInteger < 1 then // ehk laekumise id ei tohi olla st veel sidumata element !
      begin
        if qryUnpaidItems.FieldByName('item_type').AsInteger <> estbk_lib_bankfiledefs.CResolvedDataType_asMisc then
          qryUnpaidItems.FieldByName('pguid').AsString := '';
      end;



    finally
      if pNewEdtSession then
        qryUnpaidItems.Post;

      // -- kalkuleerime uuesti kogusumma !
      self.FSkipDBEvents := False;
      self.calcTotalPaymentSum;
      //qryUnpaidItems.EnableControls;
    end;
end;


procedure TframeBankIncomeManually.gridClientUnpaidItemsColEnter(Sender: TObject);
begin
  FSelectedCol := TDbGrid(Sender).SelectedColumn;
  if Assigned(FSelectedCol) then
  begin
    if Assigned(FSelectedCol.Field) and (FSelectedCol.Index = CColItems_accounts) then
      //   (ansilowercase(FSelectedCol.Field.FieldName) =CLookupAccFieldname) then
      //(FSelectedCol.Index  in [CColItems_accounts,CColItems_incomesum,CColItems_pcheckbox])  then
    begin
      FLcmpAccountCode := FSelectedCol.Field.AsString;
      //if  not (qryUnpaidItems.State in [dsEdit,dsInsert]) then
      if not pChkbVerified.Checked then // kui pole kinnitatud, siis lahtrisse sisestamisel avame automaatselt redigeerimise !
        qryUnpaidItems.Edit;
    end
    else
    if (self.FSelectedCol.Index = CColItems_currency) and (qryUnpaidItems.RecordCount > 0) then
      gridClientUnpaidItems.Hint := Format(CCurrentAmFmt4, [qryUnpaidItems.FieldByName('item_currency_ovr_idt').AsFloat]);
  end; // --
end;


procedure TframeBankIncomeManually.gridClientUnpaidItemsColExit(Sender: TObject);
begin

  if assigned(self.FSelectedCol) and (self.FSelectedCol.Index = CColItems_incomesum) and estbk_utilities.isTrueVal(
    qryUnpaidItems.FieldByName('lsitemhlp').AsString) and not pChkbVerified.Checked then
  begin
    // 27.02.2011 Ingmar; meil siiski vaja, et summade konversioon kontrollitaks üle ! ntx makse oli GBD, aga arve EUR jne
    qryUnpaidItems.AfterPost(qryUnpaidItems);
    self.calcTotalPaymentSum;
  end;


  if assigned(FSelectedCol) and (self.FSelectedCol.Index = CColItems_currency) then
    gridClientUnpaidItems.Hint := '';
end;

procedure TframeBankIncomeManually.gridClientUnpaidItemsDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: integer; Column: TColumn; State: TGridDrawState);

var
  pData: AStr;
  pts: TTextStyle;
  pBitmap: TBitmap;
begin

  // -- kahjuks pole nö süsteemne checkbox visuaalselt ilus !
{
var
    DrawFlags : Longint;
    DrawRect  : TRect;
    const IsChecked : array[Boolean] of Integer = (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED);
    DrawRect:=Rect;
    InflateRect(DrawRect,-3,-3);
    DrawFlags:=DFCS_BUTTONCHECK or DFCS_CHECKED;
    DrawFrameControl( TDbGrid(sender).Canvas.Handle, DrawRect, DFC_BUTTON, DrawFlags);
}

  //Canvas.Pen.Color:=clWindowText;
  //Canvas.FillRect(aRect);
  //Canvas.TextOut(aRect.Left+5, aRect.Top+2,Columns.Items[aCol].Title.Caption);



  with TDbGrid(Sender) do
  begin
    Canvas.FillRect(Rect);
    pts := Canvas.TextStyle;
    pts.Alignment := taLeftJustify;
    Canvas.TextStyle := pts;

    if (ansilowercase(Column.FieldName) = CLookupAccFieldname) and (gdFocused in State) then
    begin
      self.FAccounts.SetBounds(Rect.Left,
        Rect.Top,
        (Rect.Right - Rect.Left) - 1,
        (Rect.Bottom - Rect.Top) - 6);
      //DefaultDrawColumnCell(Rect, DataCol, Column, State);
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 3, self.FLcmpAccountCode, Canvas.TextStyle);
    end
    else
    if (Column.Index in [CColItems_paid, CColItems_topay, CColItems_incomesum, CColItems_incomeconvsum]) then
    begin
      //Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,format(estbk_types.CCurrentMoneyFmt2,[Column.Field.asFloat]),Canvas.TextStyle);
      pts.Alignment := taRightJustify;
      Canvas.TextStyle := pts;
      if not Column.Field.IsNull and not isNan(strtofloatdef(Column.Field.AsString, Nan)) then
        pData := trim(format(estbk_types.CCurrentMoneyFmt2, [Column.Field.AsCurrency]))
      else
        pData := '';

      // 25.01.2011 Ingmar
      if (Column.Index = CColItems_incomesum) and not isTrueVal(qryUnpaidItems.FieldByName('lsitemhlp').AsString) then
        pData := '';
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 3, pData + #32, Canvas.TextStyle);
    end
    else
    if Column.Index = CColItems_pcheckbox then
      try

        pBitmap := TBitmap.Create;
        Canvas.FillRect(Rect);

        if isTrueVal(qryUnpaidItems.FieldByName('lsitemhlp').AsString) then
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

procedure TframeBankIncomeManually.gridClientUnpaidItemsExit(Sender: TObject);
begin
  if not edtAccDate.ReadOnly then
  begin
    gridClientUnpaidItemsColExit(Sender);

    // ilusam, kui editor ei jää tööle
    if qryUnpaidItems.State in [dsEdit, dsInsert] then
      qryUnpaidItems.Post;

    FAccounts.Visible := False;
    lazFocusFix.Enabled := False;
  end;
end;

procedure TframeBankIncomeManually.gridClientUnpaidItemsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (((key = VK_RETURN) or (key = VK_TAB)) and (shift = [])) then
    key := VK_RIGHT;
end;

procedure TframeBankIncomeManually.gridClientUnpaidItemsKeyPress(Sender: TObject; var Key: char);

begin

  if assigned(self.FSelectedCol) then
    case self.FSelectedCol.Index of
      CColItems_incomesum:
      begin
        if not estbk_utilities.isTrueVal(qryUnpaidItems.FieldByName('lsitemhlp').AsString) then
          key := #0
        else
        begin
          estbk_utilities.grid_verifyNumericEntry(TDbgrid(Sender), CColItems_incomesum, key, True);
        end;
      end;
      CColItems_pcheckbox: if Key = #32 then
        begin
          self.gridClientUnpaidItemsCellClick(self.FSelectedCol);
          key := #0;
        end;

    end;
end;


procedure TframeBankIncomeManually.gridClientUnpaidItemsPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin

  with TDbGrid(Sender).Canvas do
  begin

    Font.Color := clWindowText;
    if (gdSelected in AState) then // or (Column.Index=CColItems_pcheckbox)
    begin
      Brush.Color := clHighlight;
      Font.Color := clWindow;
    end
    else
    begin

      Brush.Color := clWindow;
      if not (Column.Index in [CColItems_accounts, CColItems_incomesum, CColItems_pcheckbox]) then
      begin
        // 27.02.2011 Ingmar
        if TDbGrid(Sender).DataSource.DataSet.FieldByName('item_type').AsInteger = estbk_lib_bankfiledefs.CResolvedDataType_asMisc then
          Brush.Color := estbk_types.MyFavGray
        else
        if Column.Index = CColItems_incomeconvsum then
          Brush.Color := estbk_types.MyFavGray
        else
        if TDbGrid(Sender).DataSource.DataSet.FieldByName('item_type').AsInteger = estbk_lib_bankfiledefs.CResolvedDataType_asOrder then
          Brush.Color := glob_userSettings.uvc_colors[uvc_itemTypeAsOrderColor]
        else
          Brush.Color := glob_userSettings.uvc_colors[uvc_itemTypeAsBillColor];
      end; // ---
    end;
    // ---
  end;
end;

procedure TframeBankIncomeManually.gridClientUnpaidItemsSelectEditor(Sender: TObject; Column: TColumn; var Editor: TWinControl);
var
  b: boolean;
begin

  // ---
  self.FAccounts.Visible := False;
  lazFocusFix.Enabled := False;


  b := (qryUnpaidItems.RecordCount < 1) or not estbk_utilities.isTrueVal(qryUnpaidItems.FieldByName('lsitemhlp').AsString) or
    (pos(estbk_types.CIncomeRecStatusClosed, self.qryIncomeLines.FieldByName('status').AsString) > 0) or // laekumine kinnitatud
    self.disallowIncomeEditing; // veakood sama koodiga laekumine olemas, siis tõesti ei luba mitte mingil tingumusel asju muuta


  if b then
  begin
    //Editor:=TDbGrid(Sender).EditorByStyle(cbsNone);
    //TStringCellEditor(Editor).ReadOnly:=true;
    Editor := TDbGrid(Sender).EditorByStyle(cbsNone);
    //sysutils.Sleep(45);
    exit;
  end;


{
     gridClientUnpaidItems.Columns.Items[CColItems_accounts].ReadOnly:=b;
     gridClientUnpaidItems.Columns.Items[CColItems_incomesum].ReadOnly:=b;
     gridClientUnpaidItems.Columns.Items[CColItems_pcheckbox].ReadOnly:=true;
}


  // et kalkulatsioonid ja väljade andmed oleks korrektsed !
  //self.gridClientUnpaidItemsColExit(GridClientUnpaidItems);
  //gridClientUnpaidItems.Columns.Items[CColItems_incomesum].ReadOnly:=false;
  try
    self.FSkipLookupEvents := True;
    // --
    case Column.Index of
      CColItems_accounts:
      begin
        // ---
        //if TDbGrid(Sender).Focused then
        // begin
        // rx lookup on üks väga imelik asjandus !
        if self.FAccounts.LookupSource.DataSet.Locate('id', TDbGrid(Sender).DataSource.DataSet.FieldByName(
          'account_id').AsInteger, []) then
        begin
          //self.FAccounts.Text:=self.FAccounts.LookupSource.DataSet.FieldByname('account_coding').AsString;
          //self.FAccounts.Value:=inttostr(TDbGrid(Sender).DataSource.DataSet.FieldByname('account_id').asInteger);
          self.FLcmpAccountCode := self.FAccounts.LookupSource.DataSet.FieldByName('account_coding').AsString;
        end
        else
        begin
          self.FAccounts.Text := '';
          self.FAccounts.Value := '';
        end;

        self.FAccounts.Visible := True;
        self.FAccounts.Enabled := True;
        Editor := self.FAccounts;

        lazFocusFix.Enabled := True;
        //if TDbGrid(Sender).CanFocus then
        //   TDbGrid(Sender).SetFocus;

        // if self.FAccounts.CanFocus then
        //    self.FAccounts.SetFocus;

        //memo1.Lines.Add('acc on editor !');

        //end else
        //begin
        //  Editor:=nil ; // TDbGrid(Sender).EditorByStyle(cbsAuto);
        //  memo1.Lines.Add('nil on editor !');
        //end;
      end;
        // reserveeritud väärtused !
      else
      begin
        Editor := TDbGrid(Sender).EditorByStyle(cbsAuto);
        // 16.06.2011 Ingmar
        if Editor is TStringCellEditor then
          if (Column.index = CColItems_incomesum) then
          begin
            TStringCellEditor(Editor).Alignment := taRightJustify;
            TStringCellEditor(Editor).ReadOnly := False;
            //TStringCellEditor(Editor).SelectAll;
            //TStringCellEditor(Editor).SelStart:=length(TStringCellEditor(Editor).Text);
          end
          else
          begin
            TStringCellEditor(Editor).Alignment := taLeftJustify;
            TStringCellEditor(Editor).ReadOnly := True;
          end;
      end;
    end;


    // ---
    // 16.06.2011 Ingmar
    self.FLiveEditor := Editor;


  finally
    self.FSkipLookupEvents := False;
  end;
end;


procedure TframeBankIncomeManually.lazFocusFix2Timer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  gridClientUnpaidItems.Enabled := True;
end;


procedure TframeBankIncomeManually.lazFocusFixTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;

  if gridClientUnpaidItems.CanFocus then
    gridClientUnpaidItems.SetFocus;

  if self.FAccounts.CanFocus then
    self.FAccounts.SetFocus;
end;

procedure TframeBankIncomeManually.pChkbVerifiedClick(Sender: TObject);
var
  pNewEdtSession: boolean;
  pMsg: AStr;
  pVerif: TPaymentManager;
  pAccPeriodId: integer;
begin
  pMsg := '';
  // 23.08.2011 Ingmar; bugi, klienti polnud, aga lubas kinnitada !
  if (TCheckbox(Sender).Focused and not self.FSkipOnChangeEvents) and ((Trim(edtClient.Text) = '') or
    ((FFileImpMode) and (qryIncomeLines.FieldByName('errorcode').AsInteger <> CDataOK))) then
    // kui tegemist faili impordiga, ei tohi lubada kinnitatuks märkida vigaseid ridu !
    try
      self.FSkipOnChangeEvents := True;
      TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;
      Exit; // --
    finally
      self.FSkipOnChangeEvents := False;
    end;

  // @@2
  if (qryIncomeLines.RecordCount > 0) and TCheckbox(Sender).Focused and not self.FSkipOnChangeEvents then
    try
      // !!!
      // kinnitame elemendid arved/tellimused...kõik evendid töödeldakse siis läbi; afteredit, afterpost !
      if not (qryUnpaidItems.State in [dsEdit, dsInsert]) then
        qryUnpaidItems.Edit;
      qryUnpaidItems.Post;

      // 22.10.2011 Ingmar; et siiski oleks regideerimine lõpetatud, siis kontrollitakse eventide kaudu üle andmed !
      if not (qryIncomeLines.State in [dsEdit, dsInsert]) then
        qryIncomeLines.Edit;
      qryIncomeLines.Post;

      pVerif := TPaymentManager.Create(__pmtModeAsIncome, self.FCurrList);
      self.FSkipOnChangeEvents := True;

      if qryIncomeLines.FieldByName('errorcode').AsInteger <> CDataOk then
      begin
        Dialogs.messageDlg(estbk_strmsg.SENotAllReqFieldsAreFilled, mtError, [mbOK], 0);
        Tcheckbox(Sender).Checked := False;
        Exit;
      end;


      // incoming on seotud pigem arveridadega !
      //if (qryIncomeLines.FieldByName('incoming_id').asInteger>0) then
      if (qryIncomeLines.FieldByName('incomings_bank_id').AsInteger > 0) then
      begin
        // 17.01.2011 Ingmar
        // et tegemist poleks uue kirjega !  EI tohi laekumisi lahti sisuda, kui rp. periood on suletud !
        if (edtAccDate.Text <> '') and not dmodule.isValidAccountingPeriod(edtAccDate.Date, pAccPeriodId) then
        begin
          Dialogs.MessageDlg(estbk_strmsg.SEAccDtPeriodClosed2, mtError, [mbOK], 0);
          Tcheckbox(Sender).Checked := not Tcheckbox(Sender).Checked;
          Exit;
        end;

        // 04.02.2011 Ingmar; üks asi on arvelt laekumine lahti siduda, teine asi, kui laekumistega seotud ettemaksud on N kohtades ära kasutatud !
        if not TCheckbox(Sender).Checked and (pos(estbk_types.CIncomeRecStatusClosed, qryIncomeLines.FieldByName('status').AsString) > 0) and
          (qryIncomeLines.FieldByName('acc_reg_id').AsInteger > 0) then
          if (pVerif.verifyPrepaymentUsage(qryIncomeLines.FieldByName('acc_reg_id').AsInteger, pMsg)) then
          begin
            Dialogs.MessageDlg(format(estbk_strmsg.SEIncPrepaymentUsed, [pMsg]), mtError, [mbOK], 0);
            Tcheckbox(Sender).Checked := not Tcheckbox(Sender).Checked;
            Exit;
          end;
      end; // ----

      // arvame uuesti redigeerimise ja paneme paika staatuse !
      // paneb paika laekumise rea staatused !
      pNewEdtSession := not (qryIncomeLines.State in [dsEdit, dsInsert]);
      if pNewEdtSession then
        qryIncomeLines.Edit;

      if TCheckbox(Sender).Checked then
        qryIncomeLines.FieldByName('status').AsString := estbk_types.CIncomeRecStatusClosed
      else
        qryIncomeLines.FieldByName('status').AsString := '';

      if pNewEdtSession then
        qryIncomeLines.Post;

      estbk_utilities.changeWCtrlReadOnlyStatus(self.plowerpanel, TCheckbox(Sender).Checked);
      cmbCurrency.Enabled := not TCheckbox(Sender).Checked;
      // ---
      gridClientUnpaidItems.Invalidate;
    finally
      FreeAndNil(pVerif);
      self.FSkipOnChangeEvents := False;
    end; // ---

  //salvestada tuleb nii tühistamise / kinnitamisel !
  //if (qryIncomeLines.FieldByName('incoming_id').asInteger>0) or ((qryIncomeLines.FieldByName('incoming_id').asInteger=0) and TCheckbox(Sender).Checked) then
  if not self.FFileImpMode and TCheckbox(Sender).Focused then
    // 18.03.2011 Ingmar; faili esmasel sisestamisel readbankfile puhul salvestatakse andmed korraga !!!
  begin
    self.saveChanges2();
    // 17.09.2011 Ingmar
    // -- disaini viga;
    // kui ntx võetakse kinnitus maha !!!, siis mis on tasuta summa, ülla ülla
    // 0; ja tasutud on siis ntx 8512; tuleb teha refresh ja küsida uuesti reaalne summa
    //if  not TCheckbox(Sender).Checked then
    self.revalidateUserPtItems;
  end;
end;




procedure TframeBankIncomeManually.pGridIncomingsDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin
  // --
end;

procedure TframeBankIncomeManually.pGridIncomingsPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
begin
  // --
end;

procedure TframeBankIncomeManually.pGridIncomingsSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
begin
  // --
end;

procedure TframeBankIncomeManually.pGridIncomingsSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
begin
  // --
end;


procedure TframeBankIncomeManually.topPanelOpencloseImg(const pIndex: integer);
var
  pBmp: TBitmap;
begin
  try
    pBmp := TBitmap.Create;
    dmodule.sharedImages.GetBitmap(pIndex, pBmp);
    pImgListOpenClose.Picture.Assign(pBmp);
  finally
    pBmp.Free;
  end;
end;

procedure TframeBankIncomeManually.pImgListOpenCloseClick(Sender: TObject);
const
  CTopPanelHeight = 164;
  CGridHeight = 142;
begin
  //  pToppanel.Height:=164;
  //  gridPEntry.Height:=142;
  // sulgeme
  if TImage(Sender).Tag = -1 then
  begin
    pToppanel.Height := CTopPanelHeight - CGridHeight;
    gridPEntry.Height := 0;
    TImage(Sender).Tag := 0;
    self.topPanelOpencloseImg(img_indxDownSign);
  end
  else
  begin
    pToppanel.Height := CTopPanelHeight;
    gridPEntry.Height := CGridHeight;
    TImage(Sender).Tag := -1;
    self.topPanelOpencloseImg(img_indxUpSign);
  end;

end;

procedure TframeBankIncomeManually.qryGetAccountsAfterScroll(DataSet: TDataSet);
begin
  // --
end;

procedure TframeBankIncomeManually.OnOvrEditorEnter(Sender: TObject);
begin
  // --
end;

procedure TframeBankIncomeManually.OnOvrEditorExit(Sender: TObject);
begin

  if assigned(self.FSelectedCol) and (self.FSelectedCol.Index = CColItems_incomesum) then
    try
      // --
      try
        self.FFlagIncomeSumEdited := True;
        self.FSkipDBEvents := False; // lubame evendid !

        estbk_utilities.OnDbGridEditorExitFltCheck(gridClientUnpaidItems, Sender, CColItems_incomesum);


        // 20.06.2011 Ingmar; workaround probleemile, kui lahtrilt ära liiguti ntx paremale, et õige konv summa arvutaks !
        // after post event !
        qryUnpaidItems.Edit;
        // ---
        qryUnpaidItems.Post;
        self.FSkipDBEvents := True;

      finally
        self.FFlagIncomeSumEdited := False;
        self.FSkipDBEvents := False;
      end; // --

    except
      on e: Exception do// ---
        Dialogs.messageDlg(format(estbk_strmsg.SEMajorAppError, [e.Message]), mtError, [mbOK], 0);
    end;
end;

// if PtInRect(StringGrid1.Selection, Point(aCol, aRow))

procedure TframeBankIncomeManually.OnLookupComboSelect(Sender: TObject);
var
  pAccCode: AStr;
  pNewSession: boolean;
begin
  with TRxDBLookupCombo(Sender) do
    if (Sender = self.FAccounts) and not self.FSkipLookupEvents then
      try

        pNewSession := qryUnpaidItems.State in [dsEdit, dsInsert];
        lazFocusFix.Enabled := True;
        self.FLcmpAccountCode := LookupSource.DataSet.FieldByName('account_coding').AsString;

        if pNewSession then
          qryUnpaidItems.Edit;


        // 27.02.2011 Ingmar; bug: valuutat ei kantud üle !!!!
        qryUnpaidItems.FieldByName('account_currency').AsString := LookupSource.DataSet.FieldByName('default_currency').AsString;

        // kuna meil nö gridis väli RO; siis tuleb käsitsi väärtused omistada !
        qryUnpaidItems.FieldByName('account_coding').AsString := LookupSource.DataSet.FieldByName('account_coding').AsString;
        qryUnpaidItems.FieldByName('account_id').AsInteger := LookupSource.DataSet.FieldByName('id').AsInteger;


        if qryUnpaidItems.FieldByName('item_type').AsInteger = estbk_lib_bankfiledefs.CResolvedDataType_asMisc then
          qryUnpaidItems.FieldByName('item_nr').AsString := qryGetAccounts.FieldByName('account_name').AsString;


      finally
        if pNewSession then
          qryUnpaidItems.Post;
      end;
  //gridClientUnpaidItems.Invalidate;
end;

procedure TframeBankIncomeManually.OnLookupComboChange(Sender: TObject);
var
  pNewSession: boolean;
begin
  with TRxDBLookupCombo(Sender) do
    if (trim(Text) = '') and focused then
      try
        pNewSession := not (qryUnpaidItems.State in [dsEdit, dsInsert]);

        if pNewSession then
          qryUnpaidItems.Edit;

        // --
        qryUnpaidItems.FieldByName('account_coding').AsString := '';
        qryUnpaidItems.FieldByName('account_id').AsInteger := 0;
        qryUnpaidItems.FieldByName('account_currency').AsString := estbk_globvars.glob_baseCurrency;

        if qryUnpaidItems.FieldByName('item_type').AsInteger = estbk_lib_bankfiledefs.CResolvedDataType_asMisc then
          qryUnpaidItems.FieldByName('item_nr').AsString := '';

      finally
        if pNewSession then
          qryUnpaidItems.Post;
      end;
end;

procedure TframeBankIncomeManually.OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  pDelta: integer;
begin

  if (shift = []) then
    if (key = VK_RETURN) or (key = VK_TAB) then
    begin
      //key:=VK_RIGHT;
      key := 0;
      self.FAccounts.Visible := False;
      if gridClientUnpaidItems.CanFocus then
        gridClientUnpaidItems.SetFocus;

      // no tee, mis tahad, aga lookupcombo hoiab fookust ikka enda käes !
      if assigned(self.FSelectedCol) then
        gridClientUnpaidItems.SelectedIndex := FSelectedCol.Index + 1;
    end
    else
    if (key = VK_LEFT) or (key = VK_RIGHT) then
    begin
      if (key = VK_LEFT) then
        pDelta := -1
      else
        pDelta := 1;
      self.FAccounts.Visible := False;
      if gridClientUnpaidItems.CanFocus then
        gridClientUnpaidItems.SetFocus;

      if assigned(self.FSelectedCol) then
        gridClientUnpaidItems.SelectedIndex := FSelectedCol.Index + pDelta;
      key := 0;
    end
    else
    if (key = VK_DELETE) then
    begin

      estbk_utilities.rxLibKeyDownHelper(Sender as TRxDBLookupCombo, Key, Shift);
      TRxDBLookupCombo(Sender).Text := '';
      TRxDBLookupCombo(Sender).Value := '';
    end;
end;

procedure TframeBankIncomeManually.OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeBankIncomeManually.qryGetAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  b: boolean;
begin
  b := not ((DataSet.FieldByName('flags').AsInteger and estbk_types.CAccFlagsClosed) = estbk_types.CAccFlagsClosed);
  Accept := b;
end;

procedure TframeBankIncomeManually.qryGetBankAccountsAfterScroll(DataSet: TDataSet);
begin
  if dataset.Active then
    dbLookupBankA.Hint := Dataset.FieldByName('account_name').AsString;
end;

procedure TframeBankIncomeManually.qryIncomeLinesAfterEdit(DataSet: TDataSet);
var
  pAccPeriod: integer;
begin
  self.setCtrlStatusOnchange;
  // 27.04.2011 Ingmar; Astrid leidis vea, et laekumistel ei panda raamatupidamisperioodi peale !
  if edtAccDate.Text <> '' then
  begin
    // qryIncomeLines.FieldByName('payment_date').asDatetime
    dmodule.isValidAccountingPeriod(edtAccDate.Date, pAccPeriod);
    qryIncomeLines.FieldByName('acc_period_id').AsInteger := pAccPeriod;
  end
  else
    qryIncomeLines.FieldByName('acc_period_id').AsInteger := 0;
end;

procedure TframeBankIncomeManually.qryIncomeLinesAfterInsert(DataSet: TDataSet);
begin
  self.setCtrlStatusOnchange;
end;

procedure TframeBankIncomeManually.qryIncomeLinesAfterPost(DataSet: TDataSet);
begin
  // 16.06.2011 Ingmar
  if assigned(self.FLiveEditor) and self.FLiveEditor.Visible and not (self.FLiveEditor is TRxDBLookupCombo) then
    self.FLiveEditor.Visible := False;
end;

function TframeBankIncomeManually.disallowIncomeEditing: boolean;
begin
  Result := qryIncomeLines.Active;
  if Result then;
  Result := qryIncomeLines.FieldByName('errorcode').AsInteger = estbk_lib_bankfilesconverr.CErrIncAlreadyExists;
end;


procedure TframeBankIncomeManually.qryIncomeLinesAfterScroll(DataSet: TDataSet);
var
  pStrDMsg, pFullname: AStr;
  pCurrRate: double;
  b: boolean;
  pItemIndex: integer;
begin
  if DataSet.Active and (DataSet.RecordCount > 0) and not self.FSkipDBEvents then
  begin
    // kanne kinnitatud !
    pChkbVerified.Checked := (pos(estbk_types.CIncomeRecStatusClosed, Dataset.FieldByName('status').AsString) > 0);
    btnOpenAccEntry.Enabled := pChkbVerified.Checked and (DataSet.FieldByName('acc_reg_id').AsInteger > 0);

    if DataSet.FieldByName('client_id').AsInteger > 0 then
      self.FSelectedClientID := DataSet.FieldByName('client_id').AsInteger;

    pStrDMsg := trim(FProcEntrys.translateIntErrorCodeToMsg(DataSet.FieldByName('errorcode').AsInteger));
    if FErrTrackingEnabled then
    begin
      if pStrDMsg <> '' then
        pStrDMsg := pStrDMsg + ' [' + DataSet.FieldByName('line_nr').AsString + ']';

      edtEDesrcr.Text := pStrDMsg;
    end;


    // showmessage(qryIncomeLines.fieldByname('client_id').asstring + ' ' + qryIncomeLines.fieldByname('fullname').asstring);
    // ---
    pCurrRate := qryIncomeLines.FieldByName('currency_drate_ovr').AsFloat;

    if pCurrRate <= 0 then
      pCurrRate := 1.00;

    edtCurrRate.Text := Format(CCurrentAmFmt4, [pCurrRate]);
    //if not edtClient.Focused then // asi selles, et ntx kui klienti ei leitud ta lihtsalt tühjendas textivälja ja see pole hea !!!
    pFullname := Trim(DataSet.FieldByName('fullname').AsString);
    edtClient.Text := pFullname; //trim(DataSet.FieldByname('lastname').AsString+' '+DataSet.FieldByname('firstname').AsString);

    if not DataSet.FieldByName('payment_date').IsNull then
    begin
      edtAccDate.Date := DataSet.FieldByName('payment_date').AsDateTime;
      edtAccDate.Text := Datetostr(DataSet.FieldByName('payment_date').AsDateTime); // AsString on ohtlik !
    end
    else
    begin
      edtAccDate.Date := Now;
      edtAccDate.Text := '';
    end;

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // kuvame kas antud laekumise reaga seotud elemendid, mis varasemalt salvestatud, seotud guid läbi !
    if qryUnpaidItems.State in [dsEdit, dsInsert] then
      qryUnpaidItems.Post;


    // otsustame mida kuvada !
    self.setItemFilterForIncomeRec;

    // edit punaseks, sest me ei tea, kes on klient !
    if DataSet.FieldByName('client_id').AsInteger = 0 then
    begin
      edtClient.Color := estbk_types.MyFavRed2;
      edtClient.Font.Color := clWhite;
    end;

    // MÄRKUS:
    // selline lugu, et kui veakood selline laekumise pangatunnusega juba olemas, siis ei saagi seda laekumist sisestada !
    // tulevikus kuvame selle sisestuse, mis antud tunnusega seotud !
    b := (Dataset.RecordCount > 0) and (pos(estbk_types.CIncomeRecStatusClosed, Dataset.FieldByName('status').AsString) = 0) and
      (not self.disallowIncomeEditing);
    estbk_utilities.changeWCtrlReadOnlyStatus(self.plowerpanel, not b);
    cmbCurrency.Enabled := b;

    b := not self.disallowIncomeEditing;
    pChkbVerified.Enabled := b;

    if not b then
      pChkbVerified.Checked := False
    else
      pChkbVerified.Checked := (pos(estbk_types.CIncomeRecStatusClosed, Dataset.FieldByName('status').AsString) > 0);

    edtClient.Enabled := b;
    btnOpenClientList.Enabled := b;
    // --
    self.FSmartEditLastSuccIndx := -1;

    // visuaalselt ilusam
    if qryUnpaidItems.Active and (qryUnpaidItems.RecordCount > 0) then
      gridClientUnpaidItems.DataSource := qryUnpaidItemsDs
    else
      gridClientUnpaidItems.DataSource := nil;

    if DataSet.FieldByName('currency').AsString <> estbk_globvars.glob_baseCurrency then
    begin
      // 02.02.2011 Ingmar; peame ka päevakursid ära uuendama; samas vaatame, kas on üldse pointi uuendada
      pItemIndex := self.FCurrList.IndexOf('USD'); // kindel valuuta testimiseks !
      if (pItemIndex >= 0) and ((TCurrencyObjType(self.FCurrList.Objects[pItemIndex]).currDate <> DataSet.FieldByName('payment_date').AsDateTime) or
        (isZero(TCurrencyObjType(self.FCurrList.Objects[pItemIndex]).currVal))) then
        dmodule.revalidateCurrObjVals(DataSet.FieldByName('payment_date').AsDateTime, self.FCurrList);
    end
    else
      dmodule.resetCurrObjVals(now + 1, self.FCurrList);
  end;
end;

procedure TframeBankIncomeManually.qryIncomeLinesBeforePost(DataSet: TDataSet);
var
  pErr: integer;
begin
  pErr := validateSingleIncomeLine(Dataset);
  Dataset.FieldByName('errorcode').AsInteger := pErr;
  edtEDesrcr.Text := ''; // reset veainfole
  if (pErr <> CDataOk) and (self.FErrTrackingEnabled) then
  begin
    edtEDesrcr.Text := Trim(FProcEntrys.translateIntErrorCodeToMsg(pErr));
  end;
end;

procedure TframeBankIncomeManually.qryIncomeLinesBeforeScroll(DataSet: TDataSet);
begin
  // kõige lihtsam on meil kontrollida, kas salvestatud nupp on disabled ! kui jah, siis kas insert või edit !
  // 25.08.2011 Ingmar; BUGI ! kui failide sisestus, siis me ei saa salvestamist nõuda igale reale !
  if not self.FFileImpMode and not self.FSavingData and btnSave.Enabled then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEIncBfSaveRecord, mtError, [mbOK], 0);
    SysUtils.Abort;
  end; // --
end;

procedure TframeBankIncomeManually.qryUnpaidItemsAfterCancel(DataSet: TDataSet);
begin
  // --
end;



procedure TframeBankIncomeManually.calcTotalPaymentSum;
var
  pBookmark: TBookmark;
  pTotalSum: currency;
  pConvSum: currency;
  pNewEdtSession: boolean;
  pCheckedItemsCnt: integer;
begin
  try

    pTotalSum := 0;
    pConvSum := 0;

    if not self.FSkipdbEvents and qryUnpaidItems.Active and (qryUnpaidItems.RecordCount > 0) then
      try

        self.FSkipdbEvents := True;

        // ---
        pBookmark := qryUnpaidItems.GetBookmark;
        qryUnpaidItems.DisableControls;
        qryUnpaidItems.First;

        pCheckedItemsCnt := 0;
        while not qryUnpaidItems.EOF do
        begin

          if estbk_utilities.isTrueVal(qryUnpaidItems.FieldByName('lsitemhlp').AsString) then
          begin
            pTotalSum := pTotalSum + qryUnpaidItems.FieldByName('payment_sum').AsCurrency;
            pConvSum := pConvSum + qryUnpaidItems.FieldByName('payment_sum_conv').AsCurrency;

            Inc(pCheckedItemsCnt);
          end;


          // --
          qryUnpaidItems.Next;
        end;



        // vaatame, kas põhireal tuleb redigeerimine avada !
        pNewEdtSession := not (qryIncomeLines.State in [dsEdit, dsInsert]);
        if pNewEdtSession then
          qryIncomeLines.Edit;


        // ---------------
        qryIncomeLines.FieldByName('payment_sum').AsCurrency := pTotalSum; // kokku
        // ---------------

        if pNewEdtSession then
          qryIncomeLines.Post;


        dbEdtTotalSum.ReadOnly := pCheckedItemsCnt > 0;
        if dbEdtTotalSum.ReadOnly then
          dbEdtTotalSum.Color := cl3DLight
        else
          dbEdtTotalSum.Color := clWindow;



      finally
        qryUnpaidItems.GotoBookmark(pBookmark);
        qryUnpaidItems.FreeBookmark(pBookmark);
        qryUnpaidItems.EnableControls;
        // ---
        self.FSkipdbEvents := False;
      end;

  except // ---
  end;
end;

// kui muudetakse elemendi summat peame kogusummat arvutama ümber
procedure TframeBankIncomeManually.qryUnpaidItemsAfterEdit(DataSet: TDataSet);
begin
  self.setCtrlStatusOnchange;
end;

procedure TframeBankIncomeManually.qryUnpaidItemsAfterPost(DataSet: TDataSet);
begin

  // --
  if self.FSkipDBEvents then
    exit;


  // not self.FSkipDBEvents and
  if self.FFlagIncomeSumEdited then
    try
      self.FSkipDBEvents := True;
      self.doConversions(DataSet.FieldByName('payment_sum').asCurrency);
      self.FFlagIncomeSumEdited := False;
    finally
      self.FSkipDBEvents := False;
    end;

  // ---
  self.calcTotalPaymentSum;
end;

procedure TframeBankIncomeManually.qryUnpaidItemsAfterScroll(DataSet: TDataSet);
begin
  self.FLcmpAccountCode := DataSet.FieldByName('account_coding').AsString;
  //gridClientUnpaidItems.Columns.Items[CColItems_incomesum].ReadOnly:=false;
end;

// KUI SIIN EVENDI ABORT öelda, siis postgre draiver on käpuli maas...
procedure TframeBankIncomeManually.qryUnpaidItemsBeforeEdit(DataSet: TDataSet);
begin
(*
  // ennem tuleb kinnitus maha võtta !
  if (pos(estbk_types.CIncomeRecStatusClosed,qryIncomeLines.FieldByName('status').asString)>0) or self.allowIncomeEditingErr then
      sysutils.Abort;

  // tühja sisestust me ei luba, sest siis peaks tegelikkuses insert olema !
  if  DataSet.RecordCount<1 then
      sysutils.Abort;
*)
end;

procedure TframeBankIncomeManually.qryUnpaidItemsBeforeInsert(DataSet: TDataSet);
begin
  if not self.FAllowRecInsert then
    SysUtils.Abort;
end;

procedure TframeBankIncomeManually.qryUnpaidItemsBeforePost(DataSet: TDataSet);
begin
  // --
end;

procedure TframeBankIncomeManually.qryUnpaidItemsBeforeScroll(DataSet: TDataSet);
begin
  // --
end;

procedure TframeBankIncomeManually.qryUnpaidItemsEditError(DataSet: TDataSet; E: EDatabaseError; var DataAction: TDataAction);
begin
  // ---
end;

procedure TframeBankIncomeManually.performCleanup(const pFlushTempTables: boolean = True);
begin

  self.FLiveEditor := nil;
  // cmbAccType.ItemIndex:=0; pangainfot pole mõtet muuta, sest tihti kasutaja paneb samad laekumised peale !
  self.FSelectedCol := nil;

  //edtAccDate.Text:='';
  edtAccDate.Date := now;
  edtAccDate.Text := datetostr(edtAccDate.Date);
  dbLookupBankA.Hint := '';
  edtClient.Hint := '';

  edtClient.Color := clWindow;
  edtClient.Font.Color := clWindowText;

  cmbCurrency.ItemIndex := cmbCurrency.Items.IndexOf(estbk_globvars.glob_baseCurrency);
  //    lblCurrMirr.Caption:='';



  edtCurrRate.Text := format(CCurrentAmFmt4, [double(1.000)]);
  dbedtIncnr.Color := cl3DLight;
  dbedtIncnr.ReadOnly := True;

  edtClient.Text := '';
  pChkbVerified.Checked := False;
  FSmartEditSkipCtrlChars := False;
  FSmartEditSkipChar := False;

  FLcmpAccountCode := '';
  FSelectedClientID := 0;
  // ---
  FSkipDBEvents := False;
  FSkipLookupEvents := False;
  FSkipOnChangeEvents := False;
  FFlagIncomeSumEdited := False;

  FErrTrackingEnabled := True;

  self.FSmartEditLastSuccIndx := -1;



  if pFlushTempTables then
    self.loadDataFromTempTable(True); // reaalsuses tehakse andmetele truncate

end;

function TframeBankIncomeManually.getDataLoadStatus: boolean;
begin
  Result := qryGetAccounts.Active;
end;


procedure TframeBankIncomeManually.setDataLoadStatus(const v: boolean);
begin
  qryGetAccounts.Filtered := False;
  qryGetAccounts.Close;
  qryGetAccounts.SQL.Clear;

  qryGetBankAccounts.Close;
  qryGetBankAccounts.SQL.Clear;

  qryUnpaidItems.Close;
  qryUnpaidItems.SQL.Clear;

  qryIncomeLines.Close;
  qryIncomeLines.SQL.Clear;

  qryIncomings.Close;
  qryIncomings.SQL.Clear;


  // ---
  if v then
  begin
    if assigned(self.FCurrList) then
      FreeAndNil(self.FCurrList);

    self.FCurrList := dmodule.createPrivateCurrListCopy();
    cmbCurrency.Items.Assign(self.FCurrList);


    qryWorker.Connection := dmodule.primConnection;
    qryGetAccounts.Connection := dmodule.primConnection;
    qryUnpaidItems.Connection := dmodule.primConnection;
    qryIncomeLines.Connection := dmodule.primConnection;
    qryGetBankAccounts.Connection := dmodule.primConnection;
    // 25.12.2010 Ingmar; häid jõule !
    qryIncomings.Connection := dmodule.primConnection;

    self.performCleanup;

    qryGetAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    qryGetAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetAccounts.Open;
    qryGetAccounts.Filtered := True;

    qryGetBankAccounts.SQL.Add(estbk_sqlclientcollection._SQLSelectAccountsWithBankData);
    qryGetBankAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetBankAccounts.Open;

    qryIncomings.SQL.Add(estbk_sqlclientcollection._SQLInsertIncoming);
    self.loadDataFromTempTable(True);
  end
  else
  begin
    qryWorker.Connection := nil;
    qryGetAccounts.Connection := nil;
    qryUnpaidItems.Connection := nil;
    qryIncomeLines.Connection := nil;
    qryGetBankAccounts.Connection := nil;
    qryIncomings.Connection := nil;
  end;

  qryUnpaidItems.SortedFields := 'item_type;item_id desc';
  qryUnpaidItems.SortType := stAscending;
end;



procedure TframeBankIncomeManually.refreshAccountList;
begin
  qryGetAccounts.Active := False;
  qryGetAccounts.Filtered := False;
  qryGetAccounts.Active := True;
  qryGetAccounts.Filtered := True;
end;


constructor TframeBankIncomeManually.Create(frameOwner: TComponent);
var
  pCollItem: TCollectionItem;
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);




  btnOpenAccEntry.Enabled := False;
  btnNewLine.Enabled := True;
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  self.chgCommCtrlEnabledStatus(False);

  dbedtIncnr.Color := cl3DLight;
  dbedtIncnr.ReadOnly := True;


  // --------------
  FProcEntrys := TIncomings_base.Create(dmodule.primConnection);
  // --------------
  FAccounts := TRxDBLookupCombo.Create(self.gridClientUnpaidItems);
  FAccounts.parent := self.gridClientUnpaidItems;
  FAccounts.Visible := False;
  FAccounts.Name := 'FAccounts';
  FAccounts.ParentFont := False;
  FAccounts.ParentColor := False;
  FAccounts.ShowHint := True;
  FAccounts.DoubleBuffered := True;


  FAccounts.LookupSource := self.qryGetAccountsDs;
  FAccounts.LookupDisplay := 'account_coding;account_name';
  FAccounts.LookupField := 'id';


  FAccounts.DataField := 'account_id';
  FAccounts.DataSource := qryUnpaidItemsDs;




  pCollItem := FAccounts.PopUpFormOptions.Columns.Add;
  (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccCode;
  (pCollItem as TPopUpColumn).Fieldname := 'account_coding';
  (pCollItem as TPopUpColumn).Width := 75;


  pCollItem := FAccounts.PopUpFormOptions.Columns.Add;
  (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccName;
  (pCollItem as TPopUpColumn).Fieldname := 'account_name';
  (pCollItem as TPopUpColumn).Width := 160;


  pCollItem := FAccounts.PopUpFormOptions.Columns.Add;
  (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccCurrency;
  (pCollItem as TPopUpColumn).Fieldname := 'default_currency';
  (pCollItem as TPopUpColumn).Width := 45;


  //FAccounts.OnEnter:=@self.OnLookupComboEnter;
  //FAccounts.OnExit:=@self.OnLookupComboExit;
  FAccounts.OnSelect := @self.OnLookupComboSelect;
  FAccounts.OnChange := @self.OnLookupComboChange;

  FAccounts.OnClosePopupNotif := @self.OnLookupComboPopupClose;
  FAccounts.OnKeyDown := @self.OnLookupComboKeydown;


  FAccounts.Left := CLeftHiddenCorn;
  FAccounts.Flat := True;
  FAccounts.EmptyValue := #32;
  FAccounts.UnfindedValue := rxufNone; // rxufLastSuccessful; // rxufNone;
  FAccounts.DropDownCount := 15;
  FAccounts.DropDownWidth := 410;

  FAccounts.ButtonWidth := 15;
  FAccounts.ButtonOnlyWhenFocused := False;
  FAccounts.Height := 23;
  FAccounts.PopUpFormOptions.ShowTitles := True;
  FAccounts.PopUpFormOptions.TitleButtons := True;


  //      self.FOrigEditorKeyPress:=gridClientUnpaidItems.EditorByStyle(cbsAuto).OnKeyPress;
  gridClientUnpaidItems.EditorByStyle(cbsAuto).OnExit := @self.OnOvrEditorExit;
  gridClientUnpaidItems.EditorByStyle(cbsAuto).OnKeyDown := gridClientUnpaidItems.OnKeyDown;

  // 26.01.2011 Ingmar; täiesti haige bugi;
      (*
      2 päeva raiskasin sellele, et kui kahe lahtri vahel liikuda, siis mingi hetk kontokood keerati nässu (tühjaks muutus).
      Ja otsin ja otsin ja ei saa pihta. Siis selgus, et no mingitel hetkedel gridi enda Editor tühjendab välja :(
      *)
  gridClientUnpaidItems.Columns.Items[CColItems_accounts].ReadOnly := True;
  gridClientUnpaidItems.Columns.Items[CColItems_incomesum].ReadOnly := False;
  gridClientUnpaidItems.Columns.Items[CColItems_pcheckbox].ReadOnly := True;


  // hetkel ei luba sorteerimist !
  gridClientUnpaidItems.OnTitleClick := nil;

  self.topPanelOpencloseImg(img_indxUpSign);


  // 29.05.2011 Ingmar
  FAccounts.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
  // dbLookupBankA.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
end;

destructor TframeBankIncomeManually.Destroy;
begin
  try
    estbk_utilities.clearStrObject(TAStrings(FCurrList));
    if assigned(FCurrList) then
      FreeAndNil(FCurrList);

    FreeAndNil(FProcEntrys);
  except
  end;

  dmodule.notifyNumerators(PtrUInt(self));
  // ---
  inherited Destroy;
end;


initialization
  {$I estbk_fra_incomings_edit.ctrs}
end.