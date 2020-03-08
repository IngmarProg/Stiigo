unit estbk_fra_bills;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, EditBtn, Math, IdHttp, base64,
  Buttons, ExtCtrls, Dialogs, Grids, Graphics, rxpopupunit, rxdbgrid, rxlookup,
  LCLType, variants, Contnrs, estbk_fra_template, estbk_uivisualinit, estbk_strmsg,
  estbk_clientdatamodule, estbk_lib_commonaccprop, estbk_types, estbk_frm_choosecustmer, LCLIntf,
  estbk_sqlclientcollection, estbk_globvars, estbk_utilities, LR_Class,
  LR_DBSet, LR_View, lr_e_pdf, lr_e_htm, DB, dateutils, memds, SdfData, ZDataset, ZConnection,
  ZSqlUpdate, ZSequence, types, typinfo, Controls, ComCtrls, DBGrids, DBCtrls,
  LCLProc, Menus, estbk_settings, estbk_intdbsyserrors, estbk_lib_commonevents, estbk_frm_esendbill,
  estbk_lib_commoncls, estbk_lib_suminwords, estbk_ebill, ZAbstractRODataset;

const
  CAccountIdFlags_tax = 1;
  CAccountIdFlags_debt = 2;
  CAccountIdFlags_prepayment = 4;



type
  TbSortMode = (_csortByVat,
    _csortByAcc);


type

  { TframeBills }

  TframeBills = class(Tfra_template)
    accDate: TDateEdit;
    btnEBill: TSpeedButton;
    btnBillCopy: TBitBtn;
    btnEmailbill: TSpeedButton;
    btnIncomings: TBitBtn;
    pSaveXMLFile: TSaveDialog;
    qryGetObjectsDs: TDatasource;
    edtFocusFix: TEdit;
    edtPaidSumTotal: TEdit;
    btnAddFile: TSpeedButton;
    mnuNoAccRecs: TMenuItem;
    mnuScreen: TMenuItem;
    mnuBillHtmlFile: TMenuItem;
    mnuPdfFile: TMenuItem;
    pBillInfoText: TStaticText;
    mnuItems: TPopupMenu;
    mnuPopupSpecialOpt: TPopupMenu;
    pSaveDialog: TSaveDialog;
    stripe: TBevel;
    bv1: TBevel;
    btnCreditBill: TBitBtn;
    bv2: TBevel;
    chkBillConfirmed: TCheckBox;
    cmbSalePuchAcc: TRxDBLookupCombo;
    cmbWareHouses: TComboBox;
    edtBillStatus: TEdit;
    edtIncSum: TEdit;
    edtUsedPrpSum: TEdit;
    lblPmtStatus: TLabel;
    lblBillStatus: TLabel;
    lblUsedPrepayment: TLabel;
    lblSectionVatStatus: TLabel;
    lblVatSpc: TLabel;
    mmVatSpecs: TMemo;
    pCurrPSum1: TLabel;
    pcurrVal: TLabel;
    lblProvDefAcc: TLabel;
    lblWarehouse: TLabel;
    qryGetAccountsDChd: TDatasource;
    taskPanel: TPanel;
    reportdata: TfrDBDataSet;
    qInvoiceReport: TfrReport;
    qInvoiceMemDataset: TMemDataset;
    btnBillNewBill: TBitBtn;
    bs1: TBevel;
    btnOpenAccEntry: TBitBtn;
    btnChooseOutput: TBitBtn;
    btnSaveBill: TBitBtn;
    btnPrint: TBitBtn;
    btnClose: TBitBtn;
    btnOpenClientList: TBitBtn;
    cmbCurrencyList: TComboBox;
    billDate: TDateEdit;
    cmbPaymentTerm: TComboBox;
    dueDate: TDateEdit;
    edtAccEntryNr: TEdit;
    edtBankaccount: TEdit;
    edtBillNr: TEdit;
    edtBillSumTotalBc: TEdit;
    edtContractor: TEdit;
    edtCustAddr: TEdit;
    edtCustname: TEdit;
    edtInterestPerc: TEdit;
    edtRefNumber: TEdit;
    edtRoundBc: TEdit;
    edtSumWOVatBc: TEdit;
    edtVatSumBc: TEdit;
    gridBillLines: TStringGrid;
    grpClientData: TGroupBox;
    grpBoxBill: TGroupBox;
    lblPaymentTerm: TLabel;
    lblAccDate: TLabel;
    lblCurrVal: TLabel;
    lblAddr: TLabel;
    lblBillNr: TLabel;
    lblBillSumTotal: TLabel;
    lblCurrency: TLabel;
    lblCustId: TLabel;
    lblDate: TLabel;
    lblAccNr: TLabel;
    lblInterest: TLabel;
    lblPaymentDesc: TLabel;
    lblProv1: TLabel;
    lblProvBankAcc: TLabel;
    lblRefNumber: TLabel;
    lblTotalSumWVat: TLabel;
    lblVatSum: TLabel;
    lblRoundSum: TLabel;
    tabCtrlBill: TPageControl;
    panelbottom: TPanel;
    qryVatDs: TDatasource;
    qryVat: TZQuery;
    qryGetAccountsDs: TDatasource;
    qryGetAccounts: TZQuery;
    qryGetArticlesDs: TDatasource;
    qryGetArticles: TZQuery;
    qryTemp: TZReadOnlyQuery;
    tabBillLines: TTabSheet;
    qryBillMainRec: TZQuery;
    qryGenLedgerEntrys: TZQuery;
    qryBanks: TZReadOnlyQuery;
    lazFocusFix: TTimer;
    qryGetObjects: TZQuery;
    procedure accDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure btnAddFileClick(Sender: TObject);
    procedure billDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure billDateEditingDone(Sender: TObject);
    procedure billDateExit(Sender: TObject);
    procedure btnBillCopyClick(Sender: TObject);
    procedure btnBillNewBillClick(Sender: TObject);
    procedure btnChooseOutputClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCreditBillClick(Sender: TObject);
    procedure btnEBillClick(Sender: TObject);
    procedure btnEmailbillClick(Sender: TObject);
    procedure btnIncomingsClick(Sender: TObject);
    procedure btnOpenAccEntryClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSaveBillClick(Sender: TObject);
    procedure chkBillConfirmedChange(Sender: TObject);
    procedure cmbCurrencyListChange(Sender: TObject);
    procedure cmbPaymentTermChange(Sender: TObject);
    procedure cmbSalePuchAccChange(Sender: TObject);
    procedure cmbSalePuchAccClick(Sender: TObject);
    procedure cmbSalePuchAccClosePopupNotif(Sender: TObject);
    procedure cmbSalePuchAccSelect(Sender: TObject);
    procedure dueDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure edtBankaccountKeyPress(Sender: TObject; var Key: char);
    procedure edtContractorChange(Sender: TObject);
    procedure edtContractorEnter(Sender: TObject);
    procedure edtContractorExit(Sender: TObject);
    procedure edtContractorKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtContractorKeyPress(Sender: TObject; var Key: char);
    procedure edtCustnameChange(Sender: TObject);
    procedure edtCustnameExit(Sender: TObject);
    procedure edtCustnameKeyPress(Sender: TObject; var Key: char);
    procedure edtRoundBcChange(Sender: TObject);
    procedure edtRoundBcExit(Sender: TObject);
    procedure edtRoundBcKeyPress(Sender: TObject; var Key: char);
    procedure gridBillLinesClick(Sender: TObject);
    procedure gridBillLinesDblClick(Sender: TObject);
    procedure gridBillLinesDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure gridBillLinesEditingDone(Sender: TObject);
    procedure gridBillLinesEnter(Sender: TObject);
    procedure gridBillLinesExit(Sender: TObject);
    procedure gridBillLinesGetEditText(Sender: TObject; ACol, ARow: integer; var Value: string);
    procedure gridBillLinesKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure gridBillLinesKeyPress(Sender: TObject; var Key: char);
    procedure gridBillLinesPickListSelect(Sender: TObject);
    procedure gridBillLinesPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
    procedure gridBillLinesSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
    procedure gridBillLinesSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure gridBillLinesSelection(Sender: TObject; aCol, aRow: integer);
    procedure lazFocusFixStopTimer(Sender: TObject);
    procedure lazFocusFixTimer(Sender: TObject);
    procedure mmVatSpecsChange(Sender: TObject);
    procedure mnuNoAccRecsClick(Sender: TObject);
    procedure mnuScreenClick(Sender: TObject);
    procedure pBillInfoTextClick(Sender: TObject);
    procedure qInvoiceReportBeginBand(Band: TfrBand);
    procedure qInvoiceReportBeginPage(pgNo: integer);
    procedure qInvoiceReportEndBand(Band: TfrBand);
    procedure qInvoiceReportEnterRect(Memo: TStringList; View: TfrView);
    procedure qInvoiceReportGetValue(const ParName: string; var ParValue: variant);
    procedure qryGetArticlesFilterRecord(DataSet: TDataSet; var Accept: boolean);
    // --
    procedure OnMiscChange(Sender: TObject);
    procedure qryVatFilterRecord(DataSet: TDataSet; var Accept: boolean);
  protected
    // 08.10.2013 Ingmar
    {$ifdef debugmode}
    FAccDebug: TAStrList;
    {$endif}
    FNonUIMode: boolean;
    FCopyObjs: TObjectList;
    FCopyMode: boolean;
    // lipp, mis näitab, et arve salvestatakse PDF faili; vajalik elementide align muutmisel
    // pdf failis ei tööta align=right korrektselt !
    FSaveBillAsPdf: boolean;
    FPrintMode: boolean;

    // kiire kliendi/tarnija otsing
    FSmartEditSkipCtrlChars: boolean;
    FSmartEditSkipChar: boolean;
    FSmartEditLastSuccIndx: integer;


    // ---
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FReqCurrUpdate: TRequestForCurrUpdate;
    FCurrList: TAStrList;

    FBillHdrChkStr: AStr;
    FRepDefFile: AStr;
    // ---
    // kliendi päringu tulemus;
    FClientData: TClientData;
    FSrcLastClientCode: AStr; // kliendi koodi jälgime, et uuesti ei peaks selecti tegema
    // ---
    // ntx ostuarve ja müügiarve peal tavaliselt on võimalik artiklit
    // valida, kui pole kohustuslik; aga lao puhul peab olema artikkel valitud !
    FArticleRequired: boolean;

    FCurrBillType: TBillType; // millises reziimis arve töötab

    FArticles: TRxDBLookupCombo; // kirjeldatud artiklid
    FAccounts: TRxDBLookupCombo; // artikliga seotud konto
    FVAT: TRxDBLookupCombo; // käibemaksude valikud
    FVATAccounts: TRxDBLookupCombo; // käibemaksude konto
    FObjects: TRxDBLookupCombo;

    FNewArticleWndOpened: boolean;
    FGridReadOnly: boolean;
    FSkipLComboEvents: boolean; // enamasti lookupcombode event !
    FLoadingBillData: boolean;

    FPaCurrColPos: integer;
    FPaCurrRowPos: integer;
    // ---
    FDataNotSaved: boolean;
    FNewBill: boolean;
    FOfferId: integer;
    FOrderId: integer;
    // -- TODO tulevikus peaks see olema kliendi viitenumbri ID; kliendil endal ref.nr id täiesti olemas !
    // üldiselt müügiarvel ei peaks üldse laskma viitenumbrit sisestada ! vaid see tuleks kliendi küljest !!!
    FReferenceNrId: integer;
    //FWarehouseAcc    : Integer; // laokonto ! enamasti D
    //FWarehouseExpAcc : Integer; // laokulukonto
    // 28.02.2011 Ingmar; peame ka globaalselt meelde jätma tasumise / laekumise staatuse !
    FPaymentStatus: AStr;

    // ntx hankija juures on defineeritud teine konto
    FOvrSupplUnpaidBillAccId: integer; // tarnijatele maksmata arved
    FOvrBuyerUnpaidBillAccId: integer; // ostjate maksmata arved


    // laoreziim; vaikimis kaubad lähevad nö 0 lattu; ehk ala firmasse käe ja jala juurde
    // laoreziimi puhul muutub kontode osa !
    FWarehouseId: integer;
    FWarehouseMode: boolean;
    // 12.07.2012 Ingmar;
    FFltDisplayAllVatItems: boolean;

    // -- 28.01.2010 Ingmar
    FIsCreditBill: boolean;
    FBillVATFlags: integer;
    // tehakse uus kreeditarve ! jätame meelde aluskirje id !!!
    FCreditBillSourceBill: integer;
    FCreditBillId: integer; // avatud arve kreeditarve id !!!
    FBillIssuer: AStr;
    FKeyboardEventTriggered: boolean;
    FOpenedBillFlags: integer;
    FOpenedBillMainBrec: integer;  // arveridade aluskirje
    FOpenedBillMainAccRec: integer;  // pearaamatu kannete aluskirje
    FOpenedBillDocId: int64;        // tehinguga seotud dokumendi id
    //FCreditBillSourceBill : Integer;    // antud arvele on tehtud kreeditarve !!!! ja selle kreeditarve id on see
    FDeletedBillLines: TObjectList;

    // antud arve tasumiseks ettenähtud pangakontod !
    FBillBankAccounts: AStr;


    // :::kande kontrolli muutujad; kanne peab olema tasakaalus; või kui valuutakurssidega tekib ümardusvahe, tuleb see arvutada
    // -- createaccrec
    FDebitSumTotal: double;
    FCreditSumTotal: double;



    // aruannete muutujad;
    FReportPagenr: integer;
    // peame eelkalkuleerima jaluses oleva info; jne. st meil kaks memo; vasakul nö selgitus Arve tasuda
    // paremal memos on siis see summa; PROBLEEM: proovisin ühes memos nii teha, et selgitus on right align tüüpi;
    // fondi eripärade tõttu ei õnnestunud see ühes memos ! isegi kui arvutasin tühikud õigesti,
    // et ühes reas kõigil üks pikkus, tekkis kuvamisel probleem !!!
    // ....Summa tasuda: ......15 EEK
    FReportSumFtrData: TAStrList;
    // ------
    FMainBillMode: TBillType;


    function _callMsg(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: longint): integer;
    function revalidateBillNr: string;
    //FBankAccMemo : TfrView;
    //property    OnMiscChange : TNotifyEvent
    // et saaksime ikka muudatuse teavitused kätte
    procedure addOnChangeHandlers;
    // ---
    procedure changeGrpboxBillName(const billType: TBillType; const pBillNr: AStr; const pBillDate: TDatetime);
    procedure setBillType(const v: TBillType);
    procedure setWarehouseMode(const v: boolean);
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    // ---
    function calcBillLineChgDetectHash(const rowNr: integer): integer;
    function buildbillHdrFtrChkStr: AStr;
    procedure deleteBillLine(const rowNr: integer);
    procedure gridColumnsROStatus(const makeRO: boolean);
    function allowArtChange(): boolean;

    procedure clearGridLookupCombos;
    procedure performCleanup;
    procedure chooseAccountForArticle(const CurrRowPos: integer; const pAccToUse: integer);
    procedure calcArtSum(const rowNr: integer);
    procedure displayClientData(const pNewClientData: TClientData; const pKeepRefClientDataObj: boolean = False);
    procedure doPrint(var pFilename: AStr; const pEMailMode: boolean = False);

    procedure deleteConvertedDataset;
    function getBillIssuer(): AStr;
    function getRptBillSumInWords: AStr; // summa sõnades !!!!
    function getRptBillFormatBankData(const banks: AStr): AStr;
    function getRptBillBalanceData: AStr;
    function getRptBillNotes: AStr;



    procedure changeAllBillControlStates;
    function doesBillExists: boolean;
    procedure correctAccrecs(const pBillMainRec: integer; const pAccMainRec: integer);
    // 28.08.2011 Ingmar
    function hasBindingsWithPaymentIncomeRec(const pPaymentStatus: AStr): boolean;
    function saveBillData(const pChangeFocus: boolean = True): boolean; // peale salvestamist ntx viib fookuse uus arve peale jne



    // ---
    procedure buildRptFooterStrList(const pArtItemCollection: TCollection; const pFtrData: TAStrlist);

    // ---
    procedure convertBillDataToDynDataset(const pArtItemCollection: TCollection);

    procedure reCalculateArtPrice;
    procedure refreshUICurrencyList(const pDate: TDatetime);
    function verifyAndCreateCollection(const pArtItemCollection: TCollection; var pAccperiod: integer): boolean;

    procedure addNewGenLedgerMainrec(const pAccperiod: integer; const pAccDate: TDate;
    // kande kuupäev
      const pStrBillNr: AStr; const pFlags: integer; // !!!
      var pGenEntryMainRecId: integer; var pDocId: int64);

    function createUpdateBillMainRec(const pCreateBillRec: boolean; // true; uus arve kirje = result ID
      const pAccRecId: integer; // täita ainult uue arve puhul
      const pBillMainRecId: integer; // uuendamisel täita !
      const pBillSumTotal: double; const pBillVATSumTotal: double; const pBillVATSumTotal2: double;
      const pBillRoundSum: double; const pFlags: integer): integer;

    // 04.08.2011 Ingmar
    procedure updateAccMainRec(const pAccMainRecID: integer);
    procedure bubbleSortBillLines(const billLines: TCollection; const bsortMode: TbSortMode = _csortByVat);

    function createNewAccRec(const pAccRec: TAccoutingRec; const pAccountIdFlags: integer = 0; const pDoBaserecConv: boolean = True;
      const pReverseAccSides: boolean = True // pöörab algsete kannete pooled ära...kehtib kreeditarve puhul...
      ): int64;

    function doPriceEq(const pCurrentBillLine: TvMergedBillLines; const pBillLines: TCollection; var pLineChgDetected: boolean): boolean;

    // ostuarve; muudetakse artiklit viimast ostuhinda ning ka "laoseisu"
    procedure setArticleQtyAndPrice(const documentId: int64; const pCurrentBillLine: TvMergedBillLines;
      const pBillLines: TCollection; const pPreSavedBill: boolean; const pBillFlags: integer);

    procedure salesChangeArticleQty(const documentId: int64; const pCurrentBillLine: TvMergedBillLines;
      const pBillLines: TCollection; const pBookArticles: boolean // avatud arve puhul pannakse broneeringud peale
      );


    function billStrStatusesByFlags(const flags: integer): AStr;
    procedure calcArtTotalPrice(const pBillLine: TvMergedBillLines; var pArtPriceTotal: double; var pArtVat: double;
      var pArtVatNonCalcPart: double);
    // seoses autokäibemaksuga osa, mida ei tohi maha arvata !!

    function resolveAccName(const pAccId: integer): AStr;
    // võtab qryVat õige konto
    function getVatQryDefAccountId(): integer;
    // D -> C ; C-> D
    function switchAccRecTypes(const pAccRecType: AStr): AStr;


    // artiklite/ridade konteering
    procedure doArtAcc(const pBillLines: TCollection; const pAccMainRec: integer; const pAccPeriod: integer;
      var pAccRecNr: integer; var pArtSum: double);


    // käibemaksude ridade konteering
    procedure doVATAcc(const pBillLines: TCollection; const pAccMainRec: integer; const pAccPeriod: integer;
      var pAccRecNr: integer; var pVatSum: double);

    // ümmardamiste konteering
    procedure doRoundingAcc(const pAccMainRec: integer; const pAccPeriod: integer; const pRndSum: double;
      var pAccRecNr: integer; const pAllowCurrencyConv: boolean = False // ostuarve ümmardus tuleb teisendada !
      );

    function checkForCreditBillCorr(const pAccMainRec: integer; const pAccPeriod: integer; var pSumTotal: double;
      var pAccRecNr: integer): boolean;

    // D Ostjate tasumata arvet / hankijatele tasumata arved
    procedure doFinalBillAcc(const pAccMainRec: integer; const pAccPeriod: integer; const pSumTotal: double; var pAccRecNr: integer);

    // ettemaksu arve konteeringud; ntx ettemaksurea konteeringud
    procedure doExtendedAcc(const pBillLines: TCollection; const pAccMainRec: integer; const pAccPeriod: integer;
      var pAccRecNr: integer; var pItemSum: double; var pItemVatSum: double); // km osata elementide koondsumma



    function doBillLineDelete: integer;

    procedure doOrderBillingDataWrite;
    procedure cancelOrderBillingData;

    procedure crBillRemovePrepaymentRec;
    procedure manageBillLinesAndGenLedgerEntrys(const accPeriod: integer; const accMainRec: integer; const pFlags: integer; // !!!
      const documentId: int64; const billMainRec: integer; const billLines: TCollection);

    procedure ctrlsPerBillType(const withCleanUp: boolean = False);
    // annab valitud valuutakursi !
    function getSelectedCurrExcRate: double;
    procedure creditBillCaptionChange;

    procedure defineInMemTableStructs;
    procedure setLookupComboValues(const pLookup: TRxDBLookupCombo; const pCol: integer; const pRow: integer);

    function isInternalArticleType(const pRowNr: integer; const pColNr: integer; var pAllowColEdit: boolean): boolean;
    procedure readjustPaymentDueDate(const pBillDate: TDatetime);
    procedure searchDueMatchInCombo(const pDueDate: TDatetime);
    procedure generateRepTemppdfFile(var pFilename: AStr);

    procedure performColForwardMove;

    procedure OnStringCellEditorExitFix(Sender: TObject);
    // 21.03.2011 Ingmar; lazaruse fookuse fix
    procedure OnEditorFocusFixClick(Sender: TObject);

    procedure OnLookupGetGridCellProps(Sender: TObject; Field: TField; AFont: TFont; var Background: TColor);
    procedure OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
    procedure OnLookupComboSelect(Sender: TObject);
    procedure OnLookupComboChange(Sender: TObject);
    procedure OnLookupComboEnter(Sender: TObject);
    procedure OnLookupComboExit(Sender: TObject);
    procedure OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);

  public
    procedure tryToImportEBillData(const pInvoiceNr: AStr; const pInvoiceDate: TDatetime; const pInvoiceDueDate: TDatetime;
      const pCustomername: AStr; const pCustomerregCode: AStr; const pCustomerVAT: AStr; const pVatDateObjList: TObjectList;
      const pItemObjList: TObjectList; const pConfirmBills: boolean = False);
    procedure callNewBillEvent;

    //property    billType      : TBillType read FCurrBillType write setBillType;
    // millises arvereziimis töötame; ostuarved/müügiarved !
    procedure refreshArticleList(const pChangedArticleId: integer = 0);
    procedure refreshAccountList;

    procedure openBill(const billId: integer; const generateCreditBill: boolean = False // arvele tehakse kreeditarve !
      );


    procedure createFinalBillFromOrder(const pOrderID: integer);
    // --- 11.09.2010 ntx Ingmar; ostutellimusega saadud ETTEMAKSU arve
    procedure createPrepaymentBill(const pOrderID: integer = 0);

    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;

    // RTTI probleem !
  published
    // jätame defineeritavaks !
    property reportDefPath: AStr read FRepDefFile write FRepDefFile;
    property billMode: TBillType read FMainBillMode write setBillType;
    property wareHouseMode: boolean read FWarehouseMode write setWarehouseMode;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;

    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property onAskCurrencyDownload: TRequestForCurrUpdate read FReqCurrUpdate write FReqCurrUpdate;

  end;

implementation

uses estbk_fra_customer, estbk_reportconst, SMNetGradient;



// Astrid ütles, et konto enne ühikut tõsta !
const
  CCol_ArtCode = 1;
  CCol_ArtDesc = 2;
  CCol_ArtAcc = 3;
  CCol_ArtUnit = 4;

  CCol_ArtAmount = 5;
  CCol_ArtPrice = 6;
  CCol_ArtDisc = 7;
  CCol_ArtVATid = 8;
  CCol_ArtVATAccid = 9;
  CCol_ArtVATSum = 10;
  CCol_ArtSum = 11;
  CCol_ArtSumTotal = 12;
  CCol_ArtPercFromVat = 13;
  CCol_ArtObject = 14;
  CCol_DeleteCol = 15;

const
  CLeftHiddenCorn = -200;

// mitu numbrikohta lubame !
const
  CIntPartLen = 12;
  CFracPartLen = 4;


// sisemiseks kasutamiseks !!!!
// võtame erinevad lipud kasutusele, kui andmeid salvestame, sest me ei tea mis tulevik veel juurde toob'

const
  CBillLeaveOpenFlag = 1;
  CBillDeletedFlag = 2;
  CBillReOpenedFlag = 4;
  CBillClosedFlag = 8;


const
  CAccDescrMaxLen = 255;

// @26.04.2014 Ingmar
procedure TframeBills.tryToImportEBillData(const pInvoiceNr: AStr; const pInvoiceDate: TDatetime; const pInvoiceDueDate: TDatetime;
  const pCustomername: AStr; const pCustomerregCode: AStr; const pCustomerVAT: AStr; const pVatDateObjList: TObjectList;
  const pItemObjList: TObjectList; const pConfirmBills: boolean = False);
var
  i, pRowNr: integer;
  pBillEntry: TEBillItemClass;
  pVatrate: double;
  pArtDataClass: TArticleDataClass;
  pVATacc: TAccountDataClass;
  pVATdata: TVatDataClass;
  pAccdat: TAccountDataClass;
  pVatID: integer;
  pVatAccID: integer;
  pVatAccCode: AStr;
  pVATBookmark: TBookmark;
  pAccBookmark: TBookmark;
  pArtAccID: integer;
  pArtAccCode: AStr;
  // @@
  pArtSumTotal: double;
  pArtVATSumTotal: double;
  pArtSumTotalAll: double;
  // pArtRoundSum : Double;
begin
  try
    pVATBookmark := qryVAT.GetBookmark;
    qryVAT.DisableControls;

    pAccBookmark := qryGetAccounts.GetBookmark;
    qryGetAccounts.DisableControls;

    // @@@
    self.FNonUIMode := True;
    self.billMode := CB_purcInvoice;  // NB

    self.callNewBillEvent;
    edtBillNr.Text := pInvoiceNr;
    billDate.Date := pInvoiceDate;
    billDate.Text := DateToStr(pInvoiceDate);

    dueDate.Date := pInvoiceDueDate;
    dueDate.Text := DateToStr(pInvoiceDueDate);
    pRowNr := 1;
    pArtAccID := 0;

    // 03.05.2014 Ingmar; nõme päev täna
    self.FClientData := dmodule.__generateClientData(pCustomername, pCustomerregCode, '', pCustomerVAT);
    pArtSumTotal := 0.00;
    pArtVATSumTotal := 0.00;
    pArtSumTotalAll := 0.00;

    // proovime leida kontod, millega artikleid konteerida
    with self.qryTemp, SQL do
      try
        Close;
        Clear;
        Add(estbk_sqlclientcollection._SQLAutoDetectPurchaseAccID);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;

        pVatAccID := FieldByName('vat_id').AsInteger;
        pArtAccID := FieldByName('account_id').AsInteger;
        pArtAccCode := FieldByName('account_coding').AsString;
      finally
        Close;
        Clear;
      end;

    for i := 0 to pItemObjList.Count - 1 do
    begin
      pBillEntry := pItemObjList.Items[i] as TEBillItemClass;
      pArtDataClass := TArticleDataClass.Create;
      pArtDataClass.FArtOrigPrice := pBillEntry.FItemPrice;
      self.gridBillLines.Objects[CCol_ArtCode, pRowNr] := pArtDataClass;
      pArtDataClass.FBillLineHash := random(9999);
      // 20.04.2015 Ingmar; TODO
      self.gridBillLines.Cells[CCol_ArtPercFromVat, pRowNr] := Format(CCurrentMoneyFmt2, [double(100.00)]);
      self.gridBillLines.Cells[CCol_ArtDesc, pRowNr] := Copy(stripExtraSpaces(pBillEntry.FDescr), 1, 255);
      self.gridBillLines.Cells[CCol_ArtAmount, pRowNr] := Format(CCurrentAmFmt3, [pBillEntry.FItemAmount]);
      self.gridBillLines.Cells[CCol_ArtDisc, pRowNr] := Floattostr(0.00);
      self.gridBillLines.Cells[CCol_ArtPrice, pRowNr] := Format(CCurrentMoneyFmt2, [pBillEntry.FItemPrice]);
      self.gridBillLines.Cells[CCol_ArtSum, pRowNr] := Format(CCurrentMoneyFmt2, [pBillEntry.FItemSum]);
      self.gridBillLines.Cells[CCol_ArtSumTotal, pRowNr] := Format(CCurrentMoneyFmt2, [pBillEntry.FItemTotalSum]); // CCol_ArtSum

      // @@
      // proovime mingi imega leida käibemaksu % ja siis oletatava konto
      qryVat.First;

      pArtSumTotal := pArtSumTotal + pBillEntry.FItemSum;
      pArtVATSumTotal := pArtVATSumTotal + pBillEntry.FVatSum;

      //  locate ei oska double väärtustega õigesti käituda !!!!!
      //  if not qryVat.locate('perc',pBillEntry.FVatRate,[]) then
      while not qryVat.EOF do
      begin
        if Math.SameValue(qryVat.FieldByName('perc').AsFloat, pBillEntry.FVatRate, CEpsilon2) then
        begin
          pVatID := qryVat.FieldByName('id').AsInteger;
          break;
        end;
        qryVat.Next;
      end;

      if pVatID <= 0 then
      begin
        if Math.SameValue(0.00, pBillEntry.FVatRate, CEpsilon2) then
          if not qryVat.locate('description', 'Ei arvesta', []) then // NB hardcoded !!!
            pVatID := qryVat.FieldByName('id').AsInteger;

        if pVatID <= 0 then
          raise Exception.Create(estbk_strmsg.SEVatPercNotFound);
      end;



      pVatAccID := self.getVatQryDefAccountId();
      pVatAccCode := '';

      qryGetAccounts.First;
      if qryGetAccounts.Locate('id', pVatAccID, []) then
        pVatAccCode := qryGetAccounts.FieldByName('account_coding').AsString;

      pVATdata := TVatDataClass.Create;
      pVATdata.FVatId := qryVat.FieldByName('id').AsInteger;
      pVATdata.FVatPerc := qryVat.FieldByName('perc').AsFloat;
      pVATdata.FVatLongDescr := qryVat.FieldByName('description').AsString;
      pVATdata.FVatFlags := qryVat.FieldByName('vatflags').AsInteger;

      //@@ artikli kontod
      pAccdat := TAccountDataClass.Create;
      pAccdat.FAccId := pArtAccID;
      pAccdat.FAccCode := pArtAccCode;

      self.gridBillLines.Objects[CCol_ArtAcc, pRowNr] := pAccdat;
      self.gridBillLines.Cells[CCol_ArtAcc, pRowNr] := pArtAccCode;

      //@@ artikliga seotud käibemaksu info
      self.gridBillLines.Objects[CCol_ArtVATid, pRowNr] := pVATdata;
      self.gridBillLines.Cells[CCol_ArtVATid, pRowNr] := pVATdata.FVatLongDescr;


      pVATacc := TAccountDataClass.Create;
      pVATacc.FAccId := pVatAccID;
      pVATacc.FAccCode := pVatAccCode;

      self.gridBillLines.Objects[CCol_ArtVATAccid, pRowNr] := pVATacc;
      self.gridBillLines.Cells[CCol_ArtVATAccid, pRowNr] := pVATacc.FAccCode;
      // @@
      Inc(pRowNr);
    end;

    // muidu ei lähe salvestamine läbi !
    edtSumWOVatBc.Text := format(CCurrentMoneyFmt2, [pArtSumTotal]);
    edtVatSumBc.Text := format(CCurrentMoneyFmt2, [pArtVATSumTotal]);

    pArtSumTotalAll := pArtSumTotal + pArtVATSumTotal; // ümmardamine peaks ka veel olema
    edtBillSumTotalBc.Text := format(CCurrentMoneyFmt2, [pArtSumTotalAll]);

    // @@
    // -- üritame salvestada !
    if btnSaveBill.Enabled then
      btnSaveBill.OnClick(btnSaveBill);

    if pConfirmBills and chkBillConfirmed.Enabled then
      chkBillConfirmed.OnClick(chkBillConfirmed);

  finally
    qryVAT.GotoBookmark(pVATBookmark);
    qryVAT.FreeBookmark(pVATBookmark);
    qryVAT.EnableControls;

    qryGetAccounts.GotoBookmark(pAccBookmark);
    qryGetAccounts.FreeBookmark(pAccBookmark);
    qryGetAccounts.EnableControls;
    // @@
  end;
end;

//@kasutame ka servistes ära raami äriloogikat; ei hakka dubleerima, samas peame visuaalsed teated ära kaotama
function TframeBills._callMsg(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: longint): integer;
begin
  if Self.FNonUIMode then  // e-arve eksport ntx; või tulevikus veebiteenus
    raise Exception.Create(amsg)
  else
    Dialogs.MessageDlg(aMsg, DlgType, Buttons, HelpCtx);
end;


procedure TframeBills.callNewBillEvent;
begin
  if btnBillNewBill.Enabled then
    btnBillNewBill.OnClick(btnBillNewBill);
end;

// avame salvestamise nupu muutmise ajal
procedure TframeBills.OnMiscChange(Sender: TObject);
var
  b: boolean;
begin
  if self.FLoadingBillData then
    Exit;

  // ntx gridis kutsume muudatuse evendis välja ilma senderita !!! samas tahame, et event oleks elus
  b := not assigned(Sender);
  // --
  if not b then
    if Sender is TDateEdit then
    begin
      // kui nupust valitakse kuupäev, siis Focused = false !!! Tagi kaudu tuvastame on Enter omistab tagiks 999
      b := TDateEdit(Sender).Focused or (TDateEdit(Sender).Tag = 999);
    end
    else if Sender is TCustomComboBox then
      b := TCustomComboBox(Sender).Focused
    else if Sender is TCustomMemo then
      b := TCustomMemo(Sender).Focused
    else if Sender is TCustomEdit then
      b := TCustomEdit(Sender).Focused
    else
      b := Sender is TPickListCellEditor;

  // ---
  if b and not self.FGridReadOnly and not chkBillConfirmed.Checked then
    btnSaveBill.Enabled := True;
end;

procedure TframeBills.qryVatFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  // 02.05.2011 Ingmar; Astrid ütles, kui firma pole käibemaksukohuslane, siis peidame käibemaksud ! ainult müügiarved !
  if self.FCurrBillType = CB_salesInvoice then
    if Trim(estbk_globvars.glob_currcompvatnr) = '' then
    begin
      Accept := (DataSet.FieldByName('vatflags').AsInteger and estbk_types._CVtmode_dontAdd) = estbk_types._CVtmode_dontAdd;
    end
    else
      Accept := True;

  // 12.07.2012 Ingmar
  if not self.FFltDisplayAllVatItems then
    Accept := Accept and (ansilowercase(copy(Dataset.FieldByName('valid').AsString, 1, 1)) = 't');
end;


// jälgime onchange evente, tavaliselt me neid ei kasuta ja vastavalt paneme salvestamise nupu staatuse paika
procedure TframeBills.addOnChangeHandlers;
var
  i: integer;
  //pNotif : TNotifyEvent;
  //ppInfo : PPropInfo;
  Method: TMethod;
begin
  for i := 0 to grpClientData.ControlCount - 1 do
  begin
    //ppInfo:=GetPropInfo(grpClientData.Controls[i].ClassInfo, 'OnChange');
    //ppInfo:=GetPropInfo(grpClientData.Controls[i], 'OnChange');
    if IsPublishedProp(grpClientData.Controls[i], 'OnChange') then
    begin
      Method.Code := self.MethodAddress('OnMiscChange'); //self.MethodAddress('onmiscchange');
      Method.Data := self;//Self.Parent;

      if GetOrdProp(grpClientData.Controls[i], 'OnChange') = 0 then
        SetMethodProp(grpClientData.Controls[i], 'OnChange', Method);
    end;
  end;

  for i := 0 to grpBoxBill.ControlCount - 1 do
  begin

    if IsPublishedProp(grpBoxBill.Controls[i], 'OnChange') then
    begin
      Method.Code := self.MethodAddress('OnMiscChange');
      Method.Data := self;// Self.Parent;

      if GetOrdProp(grpBoxBill.Controls[i], 'OnChange') = 0 then
        SetMethodProp(grpBoxBill.Controls[i], 'OnChange', Method);
    end;
  end;
end;

procedure TframeBills.changeGrpboxBillName(const billType: TBillType; const pBillNr: AStr; const pBillDate: TDatetime);
begin
  // -- arvetüüp captioniks !
  case billType of
    CB_salesInvoice:
    begin
      //grpClientData.Caption:=estbk_strmsg.CSBillCp_Client;
      lblCustId.Caption := estbk_strmsg.CSBillCp_Client_id + ':';
      grpBoxBill.Caption := estbk_strmsg.CSBillName_Sale;
    end;

    CB_purcInvoice:
    begin
      grpBoxBill.Caption := estbk_strmsg.CSBillName_Purch;
      lblCustId.Caption := estbk_strmsg.CSBillCp_Supplier_id + ':';
      //grpClientData.Caption:=estbk_strmsg.CSBillCp_Supplier;
    end;

    CB_creditInvoice:
    begin
      //grpClientData.Caption:=estbk_strmsg.CSBillCp_Client;
      lblCustId.Caption := estbk_strmsg.CSBillCp_Client_id;
      grpBoxBill.Caption := format(estbk_strmsg.CSBillName_Credit, [pBillNr, dateToStr(pBillDate)]);
    end;
  end;
end;

procedure TframeBills.setBillType(const v: TBillType);
var
  pPurch, b: boolean;
begin
  //self.performCleanup;
  self.FCurrBillType := v;
  self.FMainBillMode := v;
  self.ctrlsPerBillType(True);
  if not ((self.FIsCreditBill) or (v = CB_creditInvoice)) then
    self.changeGrpboxBillName(v, '', now);


  // --
  gridBillLines.Columns.Items[CCol_ArtVATSum - 1].Visible := (v <> estbk_types.CB_salesInvoice);
  gridBillLines.Columns.Items[CCol_ArtDisc - 1].Visible := (v = estbk_types.CB_salesInvoice);

  // 21.04.2015 Ingmar; vaid ostuarvega kuvada
  gridBillLines.Columns.Items[CCol_ArtPercFromVat - 1].Visible :=
    (v = estbk_types.CB_purcInvoice) and (isTrueVal(dmodule.userStsValues[estbk_settings.CstsShowVATReturnFieldInBillLines]));




  b := ((v = CB_salesInvoice) or (v = CB_purcInvoice));
  lblPaymentTerm.Visible := b;
  cmbPaymentTerm.Visible := b;
  lblInterest.Visible := b;
  edtInterestPerc.Visible := b;

  // 10.02.2011 Ingmar; väike kalake; ostuarve tuleb kuvada tasumisi ja müügiarvel laekumisi; mul olid ka ostuarvel laekumised
  if v = estbk_types.CB_purcInvoice then
    btnIncomings.Caption := estbk_strmsg.CSBtnNamePayments
  else
    btnIncomings.Caption := estbk_strmsg.CSBtnNameIncomings;

  if self.qryVat.Active then
  begin
    self.qryVat.Filtered := False;
    self.qryVat.Filtered := True;
  end; // --



  // 18.07.2011 Ingmar; sellistele arvetüüpidele ei tohi võimaldada kanneteta arvete varianti !
  if (self.FIsCreditBill) or (v = CB_creditInvoice) or (v = CB_prepaymentInvoice) then
    accDate.PopupMenu := nil
  else
    accDate.PopupMenu := self.mnuPopupSpecialOpt;
end;

procedure TframeBills.setWarehouseMode(const v: boolean);
begin
  try
    self.FWarehouseMode := v;
    cmbWareHouses.Visible := v;
    lblWarehouse.Visible := v;
  except
  end;
end;

function TframeBills.getDataLoadStatus: boolean;
begin
  try
    Result := qryGetArticles.active;
  except
    Result := False;
  end;
end;

procedure TframeBills.setDataLoadStatus(const v: boolean);
var
  pSQLVatFix: AStr;
begin

  qryTemp.Close;
  qryTemp.SQL.Clear;

  qryGetArticles.Close;
  qryGetArticles.SQL.Clear;

  qryGetAccounts.Close;
  qryGetAccounts.SQL.Clear;

  qryBanks.Close;
  qryBanks.SQL.Clear;

  qryVat.Close;
  qryVat.SQL.Clear;

  // ----
  qryBillMainRec.Close;
  qryBillMainRec.SQL.Clear;


  qryGetObjects.Close;
  qryGetObjects.SQL.Clear;


  if v then
  begin
    self.performCleanup();

    // 24.06.2010 ingmar; tõin constructorist koodi siia !
    if assigned(self.FCurrList) then
      FreeAndNil(self.FCurrList);

    self.FCurrList := estbk_clientdatamodule.dmodule.createPrivateCurrListCopy();
    cmbCurrencyList.items.Assign(FCurrList);

    qryGetArticles.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryTemp.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryGetAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryVat.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryBillMainRec.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryGenLedgerEntrys.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryBanks.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryGetObjects.Connection := estbk_clientdatamodule.dmodule.primConnection;
    // -----------


    qryGetAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    qryGetAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetAccounts.Open;

    qryGetArticles.SQL.Add(estbk_sqlclientcollection._SQLGetArticles);
    qryGetArticles.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetArticles.ParamByName('warehouse_id').AsInteger := self.FWarehouseId;
    qryGetArticles.Open;

    // 11.09.2010 ingmar; vaid ettemaksu tüüp
    qryGetArticles.Filtered := False;
    qryGetArticles.Filtered := True;
    //qryBanks.SQL.Add(estbk_sqlclientcollection._SQLSelectBanks);
    qryBanks.SQL.Add(estbk_sqlclientcollection._SQLSelectAccountsWithBankData(False));
    qryBanks.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryBanks.Open;


    // 12.07.2012 Ingmar; häki maitseline koht;
    // üldiselt olukord, kus inimene muutis käibemaksusid, arve reale jäi vana ID'ga info,
    // nüüd üritas salvestada, programm karjuma assert #11; sest getvat olid vaid valid käibemaksud !
    // --
    // aga peame salvestamisel maha võtma nö true tingimuse; samas seda sqli kasutatakse ka mujal
    // modifitseerime endale sobivalt seda
    pSQLVatFix := estbk_sqlclientcollection._CSQLGetVAT;
    pSQLVatFix := stringreplace(pSQLVatFix, 'valid=''t''', '1=1', [rfIgnoreCase]);
    qryVat.SQL.Add(pSQLVatFix);
    qryVat.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryVat.Open;

    qryVat.Filtered := False;
    qryVat.Filtered := True;

    // ---
    qryBillMainRec.SQL.Add(_SQLSelectBillMainRec);

    // testimise ajal avame alati query
    qryBillMainRec.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryBillMainRec.Open;


    qryGetObjects.SQL.Add(estbk_sqlclientcollection._CSQLAllObjects);
    qryGetObjects.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryGetObjects.Open;

    //        qryBillMainRec.Add();
    // küsime ühikud
    with qryTemp, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._CSQLAmountNames);
        Open;
        First;

        while not EOF do
        begin
          gridBillLines.Columns.Items[CCol_ArtUnit - 1].PickList.AddObject(FieldByName('amountname').AsString,
            TObject(cardinal(FieldByName('id').AsInteger)));
          Next;
        end;
      finally
        Close;
        Clear;
      end;

    // 10.04.2011 Ingmar; instressi protsent ka !
    edtInterestPerc.Text := format(estbk_types.CCurrentMoneyFmt2, [dmodule.defaultDuePerc]);
  end
  else
  begin
    qryGetArticles.Connection := nil;
    qryTemp.Connection := nil;
    qryGetAccounts.Connection := nil;
    qryVat.Connection := nil;
    qryBillMainRec.Connection := nil;
    qryGenLedgerEntrys.Connection := nil;
    qryBanks.Connection := nil;
    qryGetObjects.Connection := nil;
  end;


  // 18.06.2010 ingmar; mingi imelik lazaruse bugi
  //panelbottom.Visible:=true;
  tabCtrlBill.Visible := True;
  tabCtrlBill.ActivePage := self.tabBillLines;

  // 13.03.2011 Ingmar; bug !
  //pBillInfoText.Color:=self.Parent.Color;
end;

procedure TframeBills.refreshArticleList(const pChangedArticleId: integer = 0);
var
  pArtCode: AStr;
  pMaxArtId: integer;
begin
  pArtCode := '';
  if qryGetArticles.active then
    try // tüüpiline reload...hack in dos... vaatame, kus tekkis uus artikkel
      qryGetArticles.DisableControls;
      pArtCode := qryGetArticles.FieldByName('artcode').AsString;
      // ---
      if self.FNewArticleWndOpened then
      begin
        pMaxArtId := 0;
        qryGetArticles.First;
        // leiame maksimaalse id olemasolevates andmetes !
        while not qryGetArticles.EOF do
        begin
          if qryGetArticles.FieldByName('id').AsInteger > pMaxArtId then
            pMaxArtId := qryGetArticles.FieldByName('id').AsInteger;
          qryGetArticles.Next;
        end;
      end; // ---

      qryGetArticles.active := False;
      qryGetArticles.active := True;
      // ---
      if self.FNewArticleWndOpened then
      begin
        qryGetArticles.First;
        // leiame maksimaalse id olemasolevates andmetes !
        while not qryGetArticles.EOF do
        begin
          if qryGetArticles.FieldByName('id').AsInteger > pMaxArtId then
          begin
            self.OnLookupComboSelect(self.FArticles);
            Exit;
          end;

          qryGetArticles.Next;
        end;
      end;

      // ----
      if pArtCode <> '' then
        qryGetArticles.Locate('artcode', pArtCode, []);

    finally
      qryGetArticles.EnableControls;
      self.FNewArticleWndOpened := False;
    end;

  // 29.05.2011 Ingmar
  _focus(gridBillLines);
  lazFocusFix.Enabled := True;
end;

procedure TframeBills.refreshAccountList;
begin
  if qryGetAccounts.active then
  begin
    qryGetAccounts.active := False;
    qryGetAccounts.active := True;
  end;
end;

procedure TframeBills.clearGridLookupCombos;
begin
  try
    self.FSkipLComboEvents := True;
    self.FAccounts.Value := '';
    self.FAccounts.Text := '';
    self.FAccounts.Visible := False;

    self.FVAT.Value := '';
    self.FVAT.Text := '';
    self.FVAT.Visible := False;

    self.FVATAccounts.Value := '';
    self.FVATAccounts.Text := '';
    self.FVATAccounts.Visible := False;

    self.FArticles.Value := '';
    self.FArticles.Text := '';
    self.FArticles.Visible := False;

    self.FObjects.Value := '';
    self.FObjects.Text := '';
    self.FObjects.Visible := False;

  finally
    self.FSkipLComboEvents := False;
  end;
end;

procedure TframeBills.performCleanup;
var
  i, pTmp: integer;
  b: boolean;
begin
  self.FFltDisplayAllVatItems := False;
  // @@@ need muutujad võib alati ära nullida, kas koopia puhul !
  self.FOrderId := 0;
  self.FOfferId := 0;

  self.FCreditBillSourceBill := 0;
  self.FCreditBillId := 0;
  self.FIsCreditBill := False;

  self.FDebitSumTotal := 0;
  self.FCreditSumTotal := 0;

  self.FOpenedBillFlags := 0;
  self.FOpenedBillMainAccRec := 0;
  self.FOpenedBillDocId := 0;
  self.FOpenedBillMainBrec := 0;
  self.FBillHdrChkStr := '';
  self.FBillIssuer := '';

  self.FPaCurrColPos := 0;
  self.FPaCurrRowPos := 0;

  //self.gridBillLines.Clean(CCol_ArtCode,1,CCol_ArtSumTotal,gridBillLines.Rowcount-1,[gzNormal]);
  self.gridBillLines.Clean(CCol_ArtCode, 1, CCol_DeleteCol, gridBillLines.Rowcount - 1, [gzNormal]);

  // 18.07.2011 Ingmar
  accDate.Color := clDefault;
  mnuNoAccRecs.Checked := False;
  self.btnAddFile.Enabled := False;
  self.btnEBill.Enabled := False;
  chkBillConfirmed.Checked := False;

  // nupud paika !
  self.btnOpenAccEntry.Enabled := False;
  self.btnCreditBill.Enabled := False;
  self.btnIncomings.Enabled := False;

  billDate.date := date();
  billDate.Text := datetostr(billDate.date);

  accDate.Date := date;
  accDate.Text := datetostr(accDate.Date);

  dueDate.date := date();
  dueDate.Text := datetostr(dueDate.date);
  //edtInterestPerc.text:='';
  edtAccEntryNr.Text := ''; // kande nr
  // tasumised
  edtBillStatus.Text := '';
  edtIncSum.Text := '';
  edtUsedPrpSum.Text := '';
  edtPaidSumTotal.Text := '';

  FVat.Hint := '';
  FAccounts.Hint := '';
  FVATAccounts.Hint := '';
  FArticles.Hint := '';

  // 08.11.2010 Ingmar
  self.FVAT.Value := '';
  self.FVAT.Text := '';

  self.FAccounts.Value := '';
  self.FAccounts.Text := '';

  self.FVATAccounts.Value := '';
  self.FVATAccounts.Text := '';

  self.FArticles.Value := '';
  self.FArticles.Text := '';

  self.FObjects.Value := '';
  self.FObjects.Text := '';
  self.FObjects.Hint := '';
  // @@@
  with self.gridBillLines do
    for i := 1 to Rowcount - 1 do
    begin
      if assigned(Objects[CCol_ArtCode, i]) then
      begin
        Objects[CCol_ArtCode, i].Free;
        Objects[CCol_ArtCode, i] := nil;
      end;

      // ---
      if Assigned(Objects[CCol_ArtAcc, i]) then
      begin
        Objects[CCol_ArtAcc, i].Free;
        Objects[CCol_ArtAcc, i] := nil;
      end;

      if Assigned(Objects[CCol_ArtVATid, i]) then
      begin
        Objects[CCol_ArtVATid, i].Free;
        Objects[CCol_ArtVATid, i] := nil;
      end;

      if Assigned(Objects[CCol_ArtVATAccid, i]) then
      begin
        Objects[CCol_ArtVATAccid, i].Free;
        Objects[CCol_ArtVATAccid, i] := nil;
      end;
      // --
    end;

  self.FArticles.Visible := False;

  // @@@
  if not self.FCopyMode then
    try
      // 02.12.2011 Ingmar
      // kui kloonitakse arve, ei pea me paljusid asju muutma !
      pBillInfoText.Caption := '';
      self.FSkipLComboEvents := True;

      // taastame arvete algseisu; ntx ostuarvest tekkis; kreeditarve jne. paneme algseisu tagasi uue arve puhul ehk siis ostuarve
      self.FCurrBillType := self.FMainBillMode;
      self.FSmartEditSkipCtrlChars := False;
      self.FSmartEditSkipChar := False;
      self.FSmartEditLastSuccIndx := -1;
      ;
      // ---
      self.FSrcLastClientCode := '';
      self.FPaymentStatus := '';

      mmVatSpecs.Lines.Clear;
      pcurrVal.Caption := '';

      edtCustname.Text := '';
      edtCustAddr.Text := '';
      edtBankaccount.Text := '';
      edtRefNumber.Text := '';
      edtBillNr.Text := '';
      edtCustname.Hint := '';
      //lblCurrPSum.Caption:='';
      //lblCurrBSum.Caption:='';
      self.clearGridLookupCombos;

      edtBillStatus.Color := estbk_types.MyFavOceanBlue;
      edtIncSum.Color := estbk_types.MyFavOceanBlue;
      edtUsedPrpSum.Color := estbk_types.MyFavOceanBlue;
      edtPaidSumTotal.Color := estbk_types.MyFavOceanBlue;


      cmbCurrencyList.ItemIndex := -1;
      //chkBoxCreditBill.checked:=false;
      //chkReqBillChange.checked:=false;
      //supplBillDate.text:='';
      //supplBillDate.Date:=now;
      //supplBillDueDate.Date:=now;
      //supplBillDueDate.text:='';
      // --
      edtContractor.Text := '';

      if self.Visible then
        _focus(edtContractor);

      panelbottom.Color := estbk_types.MyFavOceanBlue; // clInactiveCaptionText;
      //grpClientData.color:=$FEF3E2;
      // TAASTADA
     {
     self.btnPrint.enabled:=false;
     self.btnChooseOutput.enabled:=false;
     }

      self.btnSaveBill.Enabled := False;
      // 20.02.2010 Ingmar vaikekontod paika !
      // ---
      self.FOvrBuyerUnpaidBillAccId := 0;
      self.FOvrSupplUnpaidBillAccId := 0;
      pTmp := 0;

      case self.FCurrBillType of
        CB_salesInvoice: pTmp := _ac.sysAccountId[_accBuyersUnpaidBills];
        CB_purcInvoice: pTmp := _ac.sysAccountId[_accSupplUnpaidBills];
      end;

      // ---
      if pTmp > 0 then
        with cmbSalePuchAcc.LookupSource do
          if Dataset.active then
          begin
            // cmbSalePuchAcc.Enabled:=false;
            assert(Dataset.Locate('id', pTmp, []), '#1');
            cmbSalePuchAcc.Text := Dataset.FieldByName('account_coding').AsString;
            cmbSalePuchAcc.Value := IntToStr(pTmp);
            // cmbSalePuchAcc.Enabled:=true;
          end;

      // ---
      cmbCurrencyList.Enabled := True;
      estbk_utilities.miscResetCurrenyValList(cmbCurrencyList);
      pcurrVal.Caption := #32 + format(CCurrentAmFmt4, [double(1)]);


      edtSumWOVatBc.Text := format(CCurrentMoneyFmt2, [0.00]);
      edtVatSumBc.Text := format(CCurrentMoneyFmt2, [0.00]);
      edtRoundBc.Text := format(CCurrentMoneyFmt2, [0.00]);
      edtBillSumTotalBc.Text := format(CCurrentMoneyFmt2, [0.00]);
      // 30.03.2011 Ingmar
      edtInterestPerc.Text := format(estbk_types.CCurrentMoneyFmt2, [dmodule.defaultDuePerc]);

      // 01.08.2011 Ingmar; arve meilimise võimalus
      btnEmailbill.Enabled := False; // vaikimisi kinni ! openbill alles avab !
    finally
      self.FSkipLComboEvents := False;
    end;
end;

function TframeBills.calcBillLineChgDetectHash(const rowNr: integer): integer;
begin
  with self.gridBillLines do
    Result := estbk_utilities.hashpjw(Cells[CCol_ArtCode, rowNr] + Cells[CCol_ArtDesc, rowNr] + Cells[CCol_ArtUnit, rowNr] +
      Cells[CCol_ArtAcc, rowNr] + Cells[CCol_ArtAmount, rowNr] + Cells[CCol_ArtVATSum, rowNr] + Cells[CCol_ArtPercFromVat, rowNr] +
      Cells[CCol_ArtPrice, rowNr] + Cells[CCol_ArtDisc, rowNr] + Cells[CCol_ArtVatId, rowNr] + Cells[CCol_ArtVATAccid, rowNr] +
      Cells[CCol_ArtObject, rowNr] // objekti rida tuli ka juurde !
      );
end;

procedure TframeBills.deleteBillLine(const rowNr: integer);
var
  i, j, colPos: integer;
begin
  Assert(rowNr > 0, '#2');
  // ---
  if not self.FNewBill and (self.FOpenedBillMainBrec < 1) then
    Exit;

  // 13.05.2011 Ingmar; uue arve puhul seda küsimust ei esita !
  if not self.FNewBill then
    if _callMsg(estbk_strmsg.SCBillLineDelConf, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;

  with gridBillLines do
  begin
    self.clearGridLookupCombos;
    // ----
    if Assigned(Objects[CCol_ArtCode, rowNr]) then
    begin
      if self.FNewBill then
        TArticleDataClass(Objects[CCol_ArtCode, rowNr]).Free
      else
        FDeletedBillLines.Add(Objects[CCol_ArtCode, rowNr]);
      Objects[CCol_ArtCode, rowNr] := nil;
    end;

    if Assigned(Objects[CCol_ArtAcc, rowNr]) then
    begin
      TAccountDataClass(Objects[CCol_ArtAcc, rowNr]).Free;
      Objects[CCol_ArtAcc, rowNr] := nil;
    end;

    if Assigned(Objects[CCol_ArtVATAccid, rowNr]) then
    begin
      TAccountDataClass(Objects[CCol_ArtVATAccid, rowNr]).Free;
      Objects[CCol_ArtVATAccid, rowNr] := nil;
    end;

    if Assigned(Objects[CCol_ArtVATid, rowNr]) then
    begin
      TVatDataClass(Objects[CCol_ArtVATid, rowNr]).Free;
      Objects[CCol_ArtVATid, rowNr] := nil;
    end;

    if Assigned(Objects[CCol_ArtObject, rowNr]) then
    begin
      TObjectDataClass(Objects[CCol_ArtObject, rowNr]).Free;
      Objects[CCol_ArtObject, rowNr] := nil;
    end;

    Clean(CCol_ArtCode, rowNr, CCol_ArtSumTotal, rowNr, [gzNormal]);

    for i := rowNr to rowcount - 2 do
    begin
      for j := 0 to colcount - 1 do
      begin
        if (j in [CCol_ArtCode, CCol_ArtAcc, CCol_ArtVATid, CCol_ArtVATAccid]) then
          self.gridBillLines.Objects[j, i] := self.gridBillLines.Objects[j, i + 1];
        self.gridBillLines.Cells[j, i] := self.gridBillLines.Cells[j, i + 1];
      end;
    end;

    col := 1;
    // ohutum on kõik read üle arvutada;
    self.calcArtSum(rowNr - 1);
    _focus(gridBillLines);
  end;
end;

// TODO tee hash; hetkel raiskame muidu mõttetult mälu !
function TframeBills.buildbillHdrFtrChkStr: AStr;
begin
  Result := edtContractor.Text + edtBankaccount.Text + edtRefNumber.Text + edtBillNr.Text + accDate.Text +
    billDate.Text + cmbCurrencyList.Text + dueDate.Text + edtInterestPerc.Text + cmbSalePuchAcc.Text + edtRoundBc.Text +
    // 20.02.2012 Ingmar; see peab ka muudatustes olema !
    mmVatSpecs.Lines.Text;

  Result := IntToHex(estbk_utilities.hashpjw(Result), 12);
end;


// !!!! ostuarve puhul on hankija arve nr ja muu info
procedure TframeBills.ctrlsPerBillType(const withCleanUp: boolean = False);
var
  pPurch: boolean;
begin
  // ---
  if withCleanUp then
  begin
    edtBankaccount.Text := '';
    edtRefNumber.Text := '';
    //edtSupplBillNr.text:='';
    //supplBillDate.text:='';
    //supplBillDueDate.text:='';
  end;


  pPurch := (FCurrBillType = CB_purcInvoice);
  // ---
  //lblSupplBillNr.Visible:=pPurch;
  //edtSupplBillNr.Visible:=pPurch;
  //lblSupplBilldate.Visible:=pPurch;
  //supplBillDate.Visible:=pPurch;
  //lblSupplBillDueDate.Visible:=pPurch;
  //supplBillDueDate.Visible:=pPurch;
  lblProvBankAcc.Visible := pPurch;
  edtBankaccount.Visible := pPurch;
  lblRefNumber.Visible := pPurch;
  edtRefNumber.Visible := pPurch;
  //lblProvDefAcc.Visible:=pPurch;
  //cmbSalePuchAcc.Visible:=pPurch;

  // -- taasrakendame filtrit !
  qryGetArticles.Filtered := False;
  qryGetArticles.Filtered := True;
  if pPurch then
  begin
    lblAddr.Top := 0;
    edtCustAddr.Top := -3;
  end
  else
  begin
    lblAddr.Top := lblProv1.Top;
    edtCustAddr.Top := edtCustname.Top;
  end;
  // parim koht ka vaikekonteeringu paika panemiseks !
end;

function TframeBills.getSelectedCurrExcRate: double;
var
  pCIndex: integer;
begin
  Result := 1.00;
  pCIndex := cmbCurrencyList.ItemIndex;
  if (pCIndex >= 0) and Assigned(cmbCurrencyList.items.objects[pCIndex]) then
    Result := TCurrencyObjType(cmbCurrencyList.items.objects[pCIndex]).currVal;
end;

procedure TframeBills.creditBillCaptionChange;
var
  pParent: TWinControl;
  pParentForm: TForm;
  i: integer;
begin
  pParent := self.Parent;
  while assigned(pParent) do
  begin
    if pParent is TForm then
      Break;

    pParent := pParent.Parent;
  end;

  if Assigned(pParent) and (pParent is TForm) then
  begin
    pParentForm := TForm(pParent);
    for i := 0 to pParentForm.ComponentCount - 1 do
      if pParentForm.Components[i] is TNetGradient then
      begin
        TNetGradient(pParentForm.Components[i]).Caption := stringofchar(#32, 6) + estbk_strmsg.CSWndNameCreditBill;
        Break;
      end;
  end;
end;

// TODO protseduur jaotada väiksemateks osadeks ! ntx ridade laadimine
procedure TframeBills.openBill(const billId: integer; const generateCreditBill: boolean = False);

// kreeditarve vastandmärgiga
  function setsign(const pSum: currency; const pcCreaditBill: boolean): currency;
  begin
    Result := pSum;
    if pcCreaditBill then
      Result := -Result;
  end;
  // ---
var
  pTmp: TDate;
  pArtdat: TArticleDataClass;
  pAccdat: TAccountDataClass;
  pVatdat: TVatDataClass;
  pVatAccdat: TAccountDataClass; // 23.04.2010 Ingmar
  pObject: TObjectDataClass;

  pRowNr, i: integer;
  pClientID: integer;
  pDCAccountId: integer;
  bRevJoin: boolean;
  pCurr: AStr;
  pNewBillNr: AStr;
  pBillType: AStr;
  pInfoLine: AStr;
  pQty: double;
  pCreditBillSrcb: AStr;
  pCreditBillSrcdt: TDatetime;
  b: boolean;
  pSumTotal: currency;
  pTmpCurr: currency;
  pPmtTermval: PtrInt;
  pOrigBillType: TBillType;
begin
  performCleanup;
  FIsCreditBill := generateCreditBill;
  pInfoLine := '';
  btnBillNewBill.Enabled := True;
  btnBillCopy.Enabled := True;

  FNewBill := False;
  estbk_utilities.changeWCtrlEnabledStatus(grpClientData, True);
  estbk_utilities.changeWCtrlEnabledStatus(grpBoxBill, True);
  estbk_utilities.changeWCtrlEnabledStatus(panelbottom, True);
  with qryTemp, SQL do
    try
      self.FLoadingBillData := True;
      self.FSkipLComboEvents := True;
      pCurr := estbk_globvars.glob_baseCurrency;
      bRevJoin := not generateCreditBill;

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectBillType);
      parambyname('id').AsInteger := billId;
      Open;

      pBillType := trim(FieldByName('bill_type').AsString);
      bRevJoin := bRevJoin and (pBillType <> estbk_types._CItemCreditBill);

      // me peame taastama originaal arvetüübi, sest muidu kreeditarve kanded on täiesti metsas !
      // samuti otsime üles, milline arve on võetud aluseks; arve tüüp
      pOrigBillType := estbk_utilities.billTypeFromStr(pBillType);
      if pOrigBillType = estbk_types.CB_creditInvoice then
      begin
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLSelectCrBillSource);
        parambyname('credit_bill_id').AsInteger := billId;
        Open;
        pOrigBillType := estbk_utilities.billTypeFromStr(FieldByName('bill_type').AsString);
      end;


      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLGetBillMainRec(False, bRevJoin));
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('bill_id').AsInteger := billId;
      Open;

      if EOF then
        Exit;

      // seadistame esmalt nupult originaaltüübi järgi
      //pBillType:=ansiuppercase(trim(fieldbyname('bill_type').asString));
      self.setBillType(estbk_utilities.billTypeFromStr(pBillType));
      // ---
      edtBillNr.Text := FieldByName('bill_number').AsString;
      // 06.04.2012 Ingmar
      self.FBillIssuer := FieldByName('bill_createdby').AsString;
      // TODO, kui müügiarve tulevikus, siis viitenumber võtta kliendi järgi !!!  hetkel võib käsitsi igasugust jama omistada
      edtRefNumber.Text := FieldByName('ref_nr').AsString;
      pTmp := FieldByName('bill_date').AsDateTime;
      billDate.Text := datetostr(pTmp); // asstring ei tööta õigesti !
      billDate.date := pTmp;


      // 14.03.2011 Ingmar; kuvame ka kõikvõimaliku lisainfo ! ntx arvele tehtud kreeditarve ja mis summas see on !
      if self.FCurrBillType <> CB_creditInvoice then
      begin
        pInfoLine := trim(FieldByName('cr_origbillnr').AsString);
        if pInfoLine <> '' then
        begin
          pInfoLine := SCNotes + #32 + Format(LowerCase(estbk_strmsg.CSCrBillNr), [pInfoLine + ' / ' +
            datetostr(FieldByName('cr_origbilldate').AsDateTime) + #32 + format(CCurrentMoneyFmt2,
            [FieldByName('cr_origbillsum').AsFloat])]);
          //pBillInfoText.Lines.Add(pInfoLine);
          pBillInfoText.Caption := pInfoLine;
        end;
      end;

      // overdue fines
      if (FieldByName('overdue_perc').AsFloat > 0) then
        edtInterestPerc.Text := floatTostr(FieldByName('overdue_perc').AsFloat);

      // 13.09.2010 Ingmar; arvega seotud tellimus !
      self.FOrderId := FieldByName('order_id').AsInteger;

      // 17.03.2010 ingmar
      pCurr := FieldByName('currency').AsString;
      if pCurr = '' then
        pCurr := estbk_globvars.glob_baseCurrency;

      // laeme ka antud kuupäevaga arve kursid !
      b := estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pTmp, self.FCurrList);
      if pCurr <> estbk_globvars.glob_baseCurrency then
        Assert(b, '#3');

      cmbCurrencyList.ItemIndex := cmbCurrencyList.items.IndexOf(pCurr);
      pcurrVal.Caption := #32 + format(CCurrentAmFmt4, [TCurrencyObjType(cmbCurrencyList.items.Objects[cmbCurrencyList.ItemIndex]).currVal]);

      // arvega seotud tellimus / pakkumine
      if not FieldByName('due_date').IsNull then
      begin
        pTmp := FieldByName('due_date').AsDateTime;
        dueDate.Text := datetostr(ptmp);
        dueDate.date := pTmp;
      end
      else
      begin
        dueDate.date := date;
        dueDate.Text := datetostr(dueDate.date);
      end;


      // 22.05.2011 Ingmar; bug maksetingimusi ei lisatud !
      for i := 0 to cmbPaymentTerm.Items.Count - 1 do
        if cmbPaymentTerm.Items.Strings[i] <> '' then
        begin
          pPmtTermval := PtrInt(cmbPaymentTerm.Items.Objects[i]);
          if (FieldByName('paymentterm').AsInteger < 0) and (pPmtTermval = High(PtrInt) + FieldByName('paymentterm').AsInteger + 1) then
          begin
            cmbPaymentTerm.ItemIndex := i;
            break;
          end;
        end;


      pCreditBillSrcb := '';
      pCreditBillSrcdt := Now;
      // jaluses paika arvesummad
      // käibemaksuta summa
      // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      // arve originaalvaluutas !
      // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      edtSumWOVatBc.Text := format(CCurrentMoneyFmt2, [setSign(FieldByName('totalsum').asCurrency, generateCreditBill)]);

      // käibemaks
      edtVatSumBc.Text := format(CCurrentMoneyFmt2, [setSign(FieldByName('vatsum').asCurrency, generateCreditBill)]);

      // ümmardamise summa
      edtRoundBc.Text := format(CCurrentMoneyFmt2, [setSign(FieldByName('roundsum').asCurrency, generateCreditBill)]);

      // 26.07.2010 Ingmar; kreeditarve puhul muutub algse arve summa ettemaksuks !
      if not ((self.FCurrBillType = CB_creditInvoice) or generateCreditBill) then
      begin
        edtIncSum.Text := format(CCurrentMoneyFmt2, [FieldByName('incomesum').asCurrency]);
        // laekumine + kasutatud ettemaks !
        edtPaidSumTotal.Text := format(CCurrentMoneyFmt2, [FieldByName('incomesum').asCurrency + FieldByName('uprepaidsum').asCurrency]);
        edtUsedPrpSum.Text := format(CCurrentMoneyFmt2, [FieldByName('uprepaidsum').asCurrency]);
      end
      else
      begin
        edtIncSum.Text := '';
        edtPaidSumTotal.Text := '';
        edtUsedPrpSum.Text := '';
      end;

      self.FPaymentStatus := trim(FieldByName('payment_status').AsString);
      if self.FPaymentStatus = '' then
        edtBillStatus.Text := estbk_strmsg.SCBillUnPaid
      else if Pos(estbk_types.CBillPaymentPt, self.FPaymentStatus) > 0 then
        edtBillStatus.Text := estbk_strmsg.SCBillPartPaid
      else if Pos(estbk_types.CBillPaymentOk, self.FPaymentStatus) > 0 then
        edtBillStatus.Text := estbk_strmsg.SCBillPaid
      else
        Assert(0 = 1, '#14');

      // --------------
      // kokku !
      pSumTotal := FieldByName('totalsum').asCurrency + FieldByName('vatsum').asCurrency + FieldByName('roundsum').asCurrency;
      edtBillSumTotalBc.Text := format(CCurrentMoneyFmt2, [setSign(pSumTotal, generateCreditBill)]);


      // 31.01.2010 Ingmar
      // st. kreeditarve on juba salvestatud !!!!
      if self.FCurrBillType = CB_creditInvoice then
      begin
        self.FIsCreditBill := True; // !!!

        // pBillType:=ansiuppercase(trim(fieldbyname('cr_origtype').asString));
        // meil vaja teada siiski alusarve õiget tüüpi !!!!!!!!!!!!
        // self.FCurrBillType:=estbk_utilities.billTypeFromStr(pBillType);

        pCreditBillSrcb := FieldByName('cr_origbillnr').AsString;
        pCreditBillSrcdt := FieldByName('cr_origbilldate').AsDateTime;
        self.changeGrpboxBillName(self.FCurrBillType, pCreditBillSrcb, pCreditBillSrcdt);

        // self.FCurrBillType:=estbk_types.CB_creditInvoice;
      end
      else
      begin

        // täiesti uus kreeditarve, kas pole tore...
        if generateCreditBill then
        begin
          // jätame meelde originaal arve kuupäeva ja numbri !
          pCreditBillSrcb := FieldByName('bill_number').AsString;
          pCreditBillSrcdt := FieldByName('bill_date').AsDateTime;
          self.changeGrpboxBillName(CB_creditInvoice, pCreditBillSrcb, pCreditBillSrcdt);
        end
        else
          self.changeGrpboxBillName(self.FCurrBillType, '', now);
      end;




      // ---
      self.FOpenedBillMainBrec := FieldByName('id').AsInteger; // avatud arve id




      self.FOpenedBillMainAccRec := FieldByName('accounting_register_id').AsInteger;
      mnuNoAccRecs.Checked := self.FOpenedBillMainAccRec = -1;


      self.FOpenedBillDocId := FieldByName('document_id').asLargeInt;
      self.FCreditBillId := FieldByName('credit_bill_id').AsInteger; // arve avati, siis ta viitab ka arvele tehtud kreeditarvele !!!

      // 20.02.2012 Ingmar
      mmVatSpecs.Lines.Text := FieldByName('descr').AsString;
      self.FBillVATFlags := FieldByName('vat_flags').AsInteger;
      // kui arve "kustutatud"/annuleeritud, siis kõik !!!
      self.FOpenedBillFlags := 0;
      pDCAccountId := FieldByName('dc_account_id').AsInteger;
      assert(cmbSalePuchAcc.LookupSource.Dataset.Locate('id', pDCAccountId, []), '#4');


      // 10.12.2014 Ingmar; täiesti arusaamatutel põhjustel annab can't change focus
      try
        cmbSalePuchAcc.Value := IntToStr(pDCAccountId);
        cmbSalePuchAcc.Text := cmbSalePuchAcc.LookupSource.Dataset.FieldByName('account_coding').AsString;
      except
      end; // ***

      // !!!!!!!!!!!! kontrollime arve staatust !!!!!!!!!!!!!!
      if not generateCreditBill then
      begin
        btnPrint.Enabled := True;
        btnChooseOutput.Enabled := True;


        if (pos(estbk_types.CBillStatusDeleted, AnsiUpperCase(FieldByName('status').AsString)) > 0) then
          self.FOpenedBillFlags := self.FOpenedBillFlags or CBillDeletedFlag;

        if (pos(estbk_types.CBillStatusClosed, AnsiUpperCase(FieldByName('status').AsString)) > 0) then
          self.FOpenedBillFlags := self.FOpenedBillFlags or CBillClosedFlag;




        self.FGridReadOnly := (self.FOpenedBillFlags > 0);
        if self.FGridReadOnly then
        begin
          //chkBoxCreditBill.enabled:=false;
          self.gridColumnsROStatus(True);
          chkBillConfirmed.Enabled := False;
        end
        else
          self.gridColumnsROStatus(False);




        // kas arve avatud  ?!
        if //not (self.FCurrBillType in [estbk_types.CB_creditInvoice]) and // jätame võimaluse täiendavaid arveid lisada !   30.03.2011 Ingmar; jama ! Kreeditarve võib olla samuti avatud ja kinnitatud staatusega
        (pos(estbk_types.CBillStatusOpen, AnsiUpperCase(FieldByName('status').AsString)) > 0) and not self.FGridReadOnly then
        begin
          self.FOpenedBillFlags := self.FOpenedBillFlags or CBillLeaveOpenFlag;
          chkBillConfirmed.Checked := False;
          chkBillConfirmed.Enabled := True;

          btnOpenAccEntry.Enabled := False;
          btnCreditBill.Enabled := False;
          btnSaveBill.Enabled := False;
          btnIncomings.Enabled := False;


          edtAccEntryNr.Text := FieldByName('accentry_nr').AsString;
          if not FieldByName('accentry_date').IsNull then
            accDate.date := FieldByName('accentry_date').AsDateTime
          else
            accDate.date := billDate.Date;

          accDate.Text := datetostr(accDate.date);
          self.FGridReadOnly := False;

        end
        else
        begin

          chkBillConfirmed.Checked := True;
          chkBillConfirmed.Enabled := True;


          //chkReqBillChange.checked:=false;
          //chkReqBillChange.enabled:=true;

          // @@DBK
          // suletud arve puhul kuvame kande andmeid
          edtAccEntryNr.Text := FieldByName('accentry_nr').AsString;
          if not FieldByName('accentry_date').IsNull then
            accDate.date := FieldByName('accentry_date').AsDateTime
          else
            accDate.date := billDate.Date;

          accDate.Text := datetostr(accDate.date);




          // 12.09.2010 Ingmar; hetkel ettemaksuarvele ei lase kreeditarvet teha, raamatupidajatega täpsustada !
          btnCreditBill.Enabled := not self.FIsCreditBill and (self.FCreditBillId = 0) and
            (self.FCurrBillType <> CB_prepaymentInvoice) and (self.FOpenedBillMainAccRec > 0); // 19.07.2011 Ingmar kanded peavad olema !


          btnIncomings.Enabled := (self.FCurrBillType <> estbk_types.CB_creditInvoice);
          // 14.03.2011 Ingmar kreedtiarvel ei saa ju laekumisi olla !
          btnOpenAccEntry.Enabled := (self.FOpenedBillMainAccRec > 0); // kanneteta arved !


          //(self.FCurrBillType<>estbk_types.CB_creditInvoice) and (self.FCreditBillId=0);
          btnSaveBill.Enabled := False; // ARVE TULEB SELLEKS AVADA !!
        end;




        if (pos(estbk_types.CBillStatusClosed, AnsiUpperCase(FieldByName('status').AsString)) > 0) then
        begin
          self.FOpenedBillFlags := self.FOpenedBillFlags or CBillClosedFlag;
          self.FGridReadOnly := True;

          chkBillConfirmed.Checked := True;
          chkBillConfirmed.Enabled := True;
          //chkBoxCreditBill.checked:=false;
          //chkBoxCreditBill.enabled:=false;
        end;

      end
      else
        // -------------------------------------------------------------------
        // (UUS)KREEDITARVE
        // -------------------------------------------------------------------
      begin

        self.FGridReadOnly := False;
        self.gridColumnsROStatus(False);

        chkBillConfirmed.Checked := False;
        chkBillConfirmed.Enabled := True;


        btnOpenAccEntry.Enabled := False;
        btnCreditBill.Enabled := False;
        btnIncomings.Enabled := False;

        btnSaveBill.Enabled := True;
        btnPrint.Enabled := False;
        btnChooseOutput.Enabled := False;
        // jätame siiski originaalarve tunnuse alles !!!
        //self.FCurrBillType:=estbk_types.CB_creditInvoice;
        //self.chkBillConfirmed.checked:=true;
      end;




      // --- küsime kliendi andmed
      // eelmine tulemus vabastada...
      if assigned(self.FClientData) then
        FreeAndNil(FClientData);




      //FCustData:=TCustomerData.create;
      //FCustData.FCustomerId:=fieldbyname('customer_id').asInteger;
      // kliendi andmed !!!

      pClientID := FieldByName('client_id').AsInteger;
      self.FClientData := estbk_fra_customer.getClientDataWUI_uniq(pClientID);
      if not assigned(self.FClientData) then
        raise Exception.Create(estbk_strmsg.SECustomerNotChoosen);



      edtContractor.Text := self.FClientData.FClientCode;
      edtCustname.Text := FClientData.FCustFullName;
      edtCustAddr.Text := estbk_utilities.miscGenBuildAddr(FClientData.FCustJCountry, FClientData.FCustJCounty,
        FClientData.FCustJCity, FClientData.FCustJStreet, FClientData.FCustJHouseNr, FClientData.FCustJApartNr, FClientData.FCustJZipCode);

      edtBankaccount.Text := FClientData.FCustBankAccount;
      // 06.04.2012 Ingmar; vaadata üle täpsemalt, kuidas viitenumbri loogika teha
      // Sest ostu puhul on müüja viitenumber !!
      //edtRefNumber.text:=FClientData.FCustContrRefNr;




      // 31.01.2010 Ingmar; kreeditarve "lipp" muudab nii mõndagi ! summad vastupidised nagu ka kanded !
      if generateCreditBill then
      begin
       {
       http://www.palk.ee/foorum.php?op=1&tid=12470&d1=2
       // mis on kreeditarve
       16:34 14.09.2006 imelik kirjutas:
       Arve miinusega.

       Oletame müüsite kauba ja väljastasite ka arve aga hiljem kaup tagastatakse
       teile(kas täielikult või osaliselt) ja teie teete esitatud arve kohta kreeditarve(kas täielikult või osaliselt).
       }

        self.FCreditBillSourceBill := billId; // arve, millele tehakse kreeditarve !!!
        // kreeditarve tegemise kontrollid, täpsustada  milliseid täiendavaid kontrolle vaja !!!!!!!!!!!!
        // ---




        self.FNewBill := True;
        self.FIsCreditBill := True;
        // ----


        // 29.02.2012 Ingmar; numeraatorite reform
        pNewBillNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', now, False, estbk_types.CCBill_doc_nr);
        edtBillNr.Text := pNewBillNr;


        billDate.Date := date;
        billDate.Text := datetostr(billDate.Date);

        accDate.Date := date;
        accDate.Text := datetostr(accDate.Date);

        edtAccEntryNr.Text := '';


        // 30.03.2011 Ingmar; enam ei saa kreeditarves kasutada nuppu uus arve !
        btnBillNewBill.Enabled := False;
        btnBillCopy.Enabled := False;
      end;




      // ---
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectBillLines);
      paramByname('bill_id').AsInteger := billId;
      Open;
      First;
      pRowNr := 1;


      // laeme arveread !
      while not EOF do
      begin

        // ---
        pArtdat := TArticleDataClass.Create;

        // 29.05.2010 Ingmar; bugi, kreediarve laadis eelmise arveridade ID
        if generateCreditBill then
        begin
          pArtdat.FBillLineId := 0;
          pArtdat.FRefBillLineId := FieldByName('id').asLargeInt;
        end
        else
          pArtdat.FBillLineId := FieldByName('id').asLargeInt;


        pArtdat.FArtId := FieldByName('item_id').AsInteger;
        pArtdat.FArtCode := FieldByName('code').AsString;
        pArtdat.FArtCurrentQty := FieldByName('quantity').AsFloat;
        pArtdat.FArtInventoryId := FieldByName('inventory_id').AsInteger;
        pArtdat.FArtSpecialFlags := FieldByName('special_type_flags').AsInteger;



        pAccdat := TAccountDataClass.Create;
        // finantskannete andmed ennekõike !!!
        pAccdat.FAccId := FieldByName('account_id').AsInteger;
        pAccdat.FAccCode := FieldByName('account_coding').AsString;

        if pAccdat.FAccId < 1 then
          pAccdat.FAccId := FieldByName('item_account_id').AsInteger;
        //pAccdat.FAccCode:=fieldbyname('account_coding').asString;




        // 23.04.2010 Ingmar
        pVatAccdat := TAccountDataClass.Create;
        pVatAccdat.FAccId := FieldByName('vat_account_id').AsInteger;
        pVatAccdat.FAccCode := FieldByName('vat_account_coding').AsString;




        pVatdat := TVatDataClass.Create;
        pVatdat.FVatId := FieldByName('vat_id').AsInteger;
        pVatdat.FVatLongDescr := FieldByName('vatdescr').AsString;
        pVatdat.FVatPerc := FieldByName('vatperc').AsFloat;

        // 28.04.2010 ingmar
        pVatdat.FVatFlags := FieldByName('vatflags').AsInteger;

        // kas ignoreerime seda käibemaksurida !
        // vatflags arvega ka öeldud, et ära lisa käibemaksu infot !
        //pVatdat.FVatSkip:=((fieldbyname('vatflags').asInteger and estbk_types._CVtmode_dontAdd)=estbk_types._CVtmode_dontAdd);


        self.gridBillLines.Cells[CCol_ArtCode, pRowNr] := pArtdat.FArtCode;
        self.gridBillLines.Objects[CCol_ArtCode, pRowNr] := pArtdat;


        // 22.04.2010 Ingmar
        if trim(FieldByName('descr2').AsString) <> '' then
          self.gridBillLines.Cells[CCol_ArtDesc, pRowNr] := estbk_utilities._resolveEscapeSeq(FieldByName('descr2').AsString)
        else
          self.gridBillLines.Cells[CCol_ArtDesc, pRowNr] := FieldByName('artname').AsString;
        self.gridBillLines.Cells[CCol_ArtUnit, pRowNr] := FieldByName('unit2').AsString;

        // konto paika !
        self.gridBillLines.Objects[CCol_ArtAcc, pRowNr] := pAccdat;
        self.gridBillLines.Cells[CCol_ArtAcc, pRowNr] := pAccdat.FAccCode;

        // kreeditarve puhul keerame siis koguse vastupidiseks !!!!
        pQty := FieldByName('quantity').AsFloat;

        //if self.FIsCreditBill and self.FNewBill then // teisel juhul on juba olemasoleva kreeditarve avamine !!!
        if generateCreditBill then
          pQty := -pQty;



        self.gridBillLines.Cells[CCol_ArtAmount, pRowNr] := format(CCurrentAmFmt3, [pQty]);
        self.gridBillLines.Cells[CCol_ArtDisc, pRowNr] := floattostr(FieldByName('discount_perc').AsFloat);
        self.gridBillLines.Cells[CCol_ArtPrice, pRowNr] := format(CCurrentMoneyFmt2, [FieldByName('item_price').asCurrency]);




        // 27.04.2010 Ingmar
        self.gridBillLines.Cells[CCol_ArtVATSum, pRowNr] :=
          format(CCurrentMoneyFmt2, [setSign(FieldByName('vat_rsum').asCurrency, generateCreditBill)]);
        // 20.04.2015 Ingmar; TODO
        self.gridBillLines.Cells[CCol_ArtPercFromVat, pRowNr] := format(CCurrentMoneyFmt2, [FieldByName('vat_cperc').asCurrency]);



        // --- REA SUMMAD ! pöördkäibekat ei lisata koondsummasse !!!!
        pTmpCurr := FieldByName('total').asCurrency;
        if (pVatdat.FVatFlags and estbk_types._CVtmode_turnover_tax) = 0 then
          pTmpCurr := pTmpCurr - FieldByName('vat_rsum').asCurrency;

        self.gridBillLines.Cells[CCol_ArtSum, pRowNr] := format(CCurrentMoneyFmt2, [setSign(pTmpCurr, generateCreditBill)]);
        self.gridBillLines.Cells[CCol_ArtSumTotal, pRowNr] :=
          format(CCurrentMoneyFmt2, [setSign(FieldByName('total').asCurrency, generateCreditBill)]);



        // 13.04.2010 Ingmar; kuvada pikk nimi !!!
        //self.gridBillLines.Cells[CCol_ArtVATid,pRowNr]:=fieldbyname('vatdescr').asString;
        //if(fieldbyname('vatflags').asInteger and estbk_types._CVtmode_dontAdd)=estbk_types._CVtmode_dontAdd then
        //   self.gridBillLines.Cells[CCol_ArtVATid,pRowNr]:=estbk_strmsg.SCaptNoVat
        //else
        self.gridBillLines.Cells[CCol_ArtVATid, pRowNr] := FieldByName('vatdescr').AsString; //floattostr(fieldbyname('vatperc').asFloat);




        self.gridBillLines.Cells[CCol_ArtVATAccid, pRowNr] := pVatAccdat.FAccCode;
        // ---------------
        // omistame artikli / käibemaksu kontode info klassid
        self.gridBillLines.Objects[CCol_ArtVATid, pRowNr] := pVatdat;
        self.gridBillLines.Objects[CCol_ArtVATAccid, pRowNr] := pVatAccdat;



        pObject := TObjectDataClass.Create;
        pObject.FObjectID := FieldByName('object_id').AsInteger;
        self.gridBillLines.Objects[CCol_ArtObject, pRowNr] := pObject;
        self.gridBillLines.Cells[CCol_ArtObject, pRowNr] := FieldByName('objectname1').AsString;




        // 29.04.2010 Ingmar; peame laadima AS IS !!!!!
        // arvutame rea summa
        //self.calcArtSum(pRowNr);

        // muudatuste jälgimine !!!
        pArtdat.FBillLineHash := self.calcBillLineChgDetectHash(pRowNr);


        Inc(pRowNr);
        Next;
      end;




      // kas ainult lugemiseks !?
      estbk_utilities.changeWCtrlReadOnlyStatus(grpClientData, self.FGridReadOnly);
      estbk_utilities.changeWCtrlReadOnlyStatus(grpBoxBill, self.FGridReadOnly);
      estbk_utilities.changeWCtrlReadOnlyStatus(mmVatSpecs, self.FGridReadOnly);



      estbk_utilities.changeWCtrlEnabledStatus(cmbCurrencyList, not self.FGridReadOnly);
      estbk_utilities.changeWCtrlEnabledStatus(cmbPaymentTerm, not self.FGridReadOnly);


      //edtCustname.Color:=cl3DLight;//estbk_types.MyFavGray;
      edtCustAddr.Color := cl3DLight;//estbk_types.MyFavGray;




      // pole mõtet kuvada kliendi valikut, kui arve RO
      btnOpenClientList.Enabled := not self.FGridReadOnly;




      // paneme gridis positsiooni paika ! Ehk arve kinnitamata aktiviseerime esimese artikli lahtri !
      // 09.08.2010 Ingmar
      if not self.FGridReadOnly and not ((self.FCurrBillType = CB_creditInvoice) or generateCreditBill) then
        // 02.04.2011 Ingmar not ((self.FCurrBillType=CB_creditInvoice) or generateCreditBill)
      begin
        gridBillLines.Editor := self.FArticles;
        self.FArticles.Text := self.gridBillLines.Cells[1, 1];


        //self.FArticles.visible:=not self.FGridReadOnly;
        self.FArticles.Visible := self.allowArtChange();
      end;


      self.FPaCurrColPos := 1;
      self.FPaCurrRowPos := 1;

      gridBillLines.Col := 1;
      gridBillLines.Row := 1;

      // jätame meelde päise, kas vaja muuta !
      self.FBillHdrChkStr := self.buildbillHdrFtrChkStr();




      // vaatame, et visuaalsus oleks paigas;
      self.ctrlsPerBillType();


      self.edtRoundBc.ReadOnly := True;
      self.edtRoundBc.color := cl3DLight;

      if (self.FCurrBillType = CB_purcInvoice) and not chkBillConfirmed.Checked then
      begin
        self.edtRoundBc.color := clWindow;
        self.edtRoundBc.ReadOnly := False;
      end;

      // 01.03.2011 Ingmar
      self.btnAddFile.Enabled := True;
      self.btnEBill.Enabled := (self.FCurrBillType = CB_salesInvoice);




      // 02.04.2011 Ingmar
      // meil vaja eristada generatecreditbill ja _tüüp juba creditbill...igal juhul peame taastama lähtearve tüübi,
      // et kanded jookseksid korrektselt !  FIsCreditBill näitab meile, et kanded vastupidiselt koostada !!!!

      if generateCreditBill then
      begin
        self.setBillType(estbk_utilities.billTypeFromStr(estbk_types._CItemCreditBill));
        // TOBE hack ! TODO tulevikus mõistlikumalt ! meil vaja ära muuta vormi esimese paneeli caption !
        self.creditBillCaptionChange;
      end;



      // väärtustame muutuja uuesti, et setbilltype handler ei hakkaks leiutama asju
      self.FCurrBillType := pOrigBillType;
      // 30.03.2011 Ingmar
      estbk_clientdatamodule.dmodule.revalidateCurrObjVals(billDate.Date, self.FCurrList);


      // et me ikka saaksime aru, et tegemist on kanneteta arvega !
      if mnuNoAccRecs.Checked then
        accDate.Color := estbk_types.MyFavYellowGreen;

      // peab omama kandeid ja olema kinnitatud !
      btnEmailbill.Enabled := (self.FOpenedBillMainAccRec > 0) and chkBillConfirmed.Checked;


    finally
      self.FSkipLComboEvents := False;
      self.FLoadingBillData := False;

      Close;
      Clear;
    end;
end;




procedure TframeBills.createFinalBillFromOrder(const pOrderID: integer);
var
  pCurrIndx: integer;
  pRowNr: integer;
  pArtdat: TArticleDataClass;
  pAccdat: TAccountDataClass;
  pVatAccdat: TAccountDataClass;
  pVatdat: TVatDataClass;
begin
  // esmalt standartne uue kirje loomine
  self.btnBillNewBillClick(btnBillNewBill);

  with qryTemp, SQL do
    try
      //self.FLoadingBillData:=true;
      // --
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectOrder);
      paramByname('id').AsInteger := pOrderID;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      if EOF then
        raise Exception.Create(estbk_strmsg.SEOrderNotFound);

      // peame ära määrama millise arvetüübi peame looma
      if FieldByName('order_type').AsString = estbk_types._COAsPurchOrder then
        self.FCurrBillType := CB_purcInvoice
      else
      if FieldByName('order_type').AsString = estbk_types._COAsSaleOrder then
        self.FCurrBillType := CB_salesInvoice
      else
        assert(False, '#21');
      // !!!
      billDate.Date := FieldByName('order_date').AsDateTime;
      pCurrIndx := cmbCurrencyList.Items.IndexOf(FieldByName('currency').AsString);
      assert(pCurrIndx >= 0, '#22');

      cmbCurrencyList.ItemIndex := pCurrIndx;

      // et saaksime osadest kontrollidest läbi
      self.refreshUICurrencyList(billDate.Date);
      self.displayClientData(estbk_fra_customer.getClientDataWUI_uniq(FieldByName('client_id').AsInteger));


      // nüüd konverteerime tellimuse read ümber arve ridadeks !
      // tulevikus võiks unioniga teha ?
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectOrderLines2(pOrderID));
      Open;
      pRowNr := 1;

      while not EOF do
      begin
        // ---
        pArtdat := TArticleDataClass.Create;

        // #1
        pArtdat.FBillLineId := 0; // uus rida ju !
        pArtdat.FArtId := FieldByName('item_id').AsInteger;
        pArtdat.FArtCode := FieldByName('item_code').AsString;
        pArtdat.FArtCurrentQty := FieldByName('quantity').AsFloat;
        pArtdat.FArtInventoryId := FieldByName('inventory_id').AsInteger;
        pArtdat.FArtSpecialFlags := 0; // tellimusest ei saa eritüübid tulla ! special_type_flags


        // #2 artikli konto
        pAccdat := TAccountDataClass.Create;
        pAccdat.FAccId := FieldByName('account_id').AsInteger;
        pAccdat.FAccCode := FieldByName('account_coding').AsString;



        // #3 käibemaksu konto
        pVatAccdat := TAccountDataClass.Create;
        pVatAccdat.FAccId := FieldByName('vat_account_id').AsInteger;
        pVatAccdat.FAccCode := FieldByName('vat_account_coding').AsString;

        // #4
        pVatdat := TVatDataClass.Create;
        pVatdat.FVatId := FieldByName('vat_id').AsInteger;
        pVatdat.FVatLongDescr := FieldByName('vat_descr').AsString;
        pVatdat.FVatPerc := FieldByName('vat_perc').AsFloat;
        pVatdat.FVatFlags := FieldByName('vat_flags').AsInteger;

        // täidame read !
        self.gridBillLines.Cells[CCol_ArtCode, pRowNr] := pArtdat.FArtCode;
        self.gridBillLines.Objects[CCol_ArtCode, pRowNr] := pArtdat;

        if FieldByName('item_id').AsInteger > 0 then
          self.gridBillLines.Cells[CCol_ArtDesc, pRowNr] := FieldByName('artname').AsString
        else
          self.gridBillLines.Cells[CCol_ArtDesc, pRowNr] := FieldByName('descr').AsString;
        self.gridBillLines.Cells[CCol_ArtUnit, pRowNr] := FieldByName('unit').AsString;

        // konto paika !
        self.gridBillLines.Objects[CCol_ArtAcc, pRowNr] := pAccdat;
        self.gridBillLines.Cells[CCol_ArtAcc, pRowNr] := pAccdat.FAccCode;


        self.gridBillLines.Cells[CCol_ArtAmount, pRowNr] := format(CCurrentAmFmt3, [FieldByName('quantity').AsFloat]);
        self.gridBillLines.Cells[CCol_ArtDisc, pRowNr] := ''; // tulevikus müügitellimuse puhul
        self.gridBillLines.Cells[CCol_ArtPrice, pRowNr] := format(CCurrentMoneyFmt2, [FieldByName('price').asCurrency]);
        self.gridBillLines.Cells[CCol_ArtVATSum, pRowNr] := format(CCurrentMoneyFmt2, [FieldByName('vat_rsum').asCurrency]);
        // 20.04.2015 Ingmar; müügitellimusel pole mingeid auto käibemaksu mahaarvamist !
        self.gridBillLines.Cells[CCol_ArtPercFromVat, pRowNr] := format(CCurrentMoneyFmt2, [100]);


        self.gridBillLines.Cells[CCol_ArtVATid, pRowNr] := FieldByName('vat_descr').AsString;
        self.gridBillLines.Cells[CCol_ArtVATAccid, pRowNr] := pVatAccdat.FAccCode;


        self.gridBillLines.Objects[CCol_ArtVATid, pRowNr] := pVatdat;
        self.gridBillLines.Objects[CCol_ArtVATAccid, pRowNr] := pVatAccdat;

        // ----
        self.calcArtSum(pRowNr);
        // ----
        pArtdat.FBillLineHash := self.calcBillLineChgDetectHash(pRowNr);
        Inc(pRowNr);
        Next;
      end;


      // 04.10.2010 Ingmar; võtame ka ettemaksud peale !
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectGetOrderPrepaymentBills(pOrderId));
      Open;


      while not EOF do
      begin
        // ---
        pArtdat := TArticleDataClass.Create;

        // #1
        pArtdat.FBillLineId := 0; // uus rida ju !
        pArtdat.FArtId := FieldByName('item_id').AsInteger;
        pArtdat.FArtCode := FieldByName('item_code').AsString;
        pArtdat.FArtCurrentQty := FieldByName('quantity').AsFloat;
        pArtdat.FArtInventoryId := 0; // ettemaksudel ju pole inventaari
        pArtdat.FArtSpecialFlags := FieldByName('item_flags').AsInteger; // tegemist on eritüübiga !

        // #2 pigem ettemaksu konto siis
        pAccdat := TAccountDataClass.Create;
        pAccdat.FAccId := FieldByName('item_account_id').AsInteger;
        pAccdat.FAccCode := FieldByName('item_acc_coding').AsString;


        // #3 käibemaksu konto
        pVatAccdat := TAccountDataClass.Create;
        pVatAccdat.FAccId := FieldByName('vat_account_id').AsInteger;
        pVatAccdat.FAccCode := FieldByName('vat_account_coding').AsString;

        // #4
        pVatdat := TVatDataClass.Create;
        pVatdat.FVatId := FieldByName('vat_id').AsInteger;
        pVatdat.FVatLongDescr := FieldByName('vat_descr').AsString;
        pVatdat.FVatPerc := FieldByName('vat_perc').AsFloat;
        pVatdat.FVatFlags := FieldByName('vat_flags').AsInteger;

        self.gridBillLines.Cells[CCol_ArtCode, pRowNr] := pArtdat.FArtCode;
        self.gridBillLines.Objects[CCol_ArtCode, pRowNr] := pArtdat;

        self.gridBillLines.Cells[CCol_ArtDesc, pRowNr] := FieldByName('item_descr').AsString;
        self.gridBillLines.Cells[CCol_ArtUnit, pRowNr] := ''; // ettemaksu puhul pole ühikut !

        // ettemaksu konto ja kood
        self.gridBillLines.Objects[CCol_ArtAcc, pRowNr] := pAccdat;
        self.gridBillLines.Cells[CCol_ArtAcc, pRowNr] := pAccdat.FAccCode;


        self.gridBillLines.Cells[CCol_ArtAmount, pRowNr] := format(CCurrentAmFmt3, [FieldByName('quantity').AsFloat]);
        self.gridBillLines.Cells[CCol_ArtDisc, pRowNr] := ''; // ettemaksu puhul pole ka allahindlust !
        self.gridBillLines.Cells[CCol_ArtPrice, pRowNr] := format(CCurrentMoneyFmt2, [FieldByName('item_price').asCurrency]);
        self.gridBillLines.Cells[CCol_ArtVATSum, pRowNr] := format(CCurrentMoneyFmt2, [FieldByName('vat_rsum').asCurrency]);
        // 20.04.2015 Ingmar; TODO
        self.gridBillLines.Cells[CCol_ArtPercFromVat, pRowNr] := format(CCurrentMoneyFmt2, [FieldByName('vat_cperc').asCurrency]);


        self.gridBillLines.Cells[CCol_ArtVATid, pRowNr] := FieldByName('vat_descr').AsString;
        self.gridBillLines.Cells[CCol_ArtVATAccid, pRowNr] := pVatAccdat.FAccCode;


        self.gridBillLines.Objects[CCol_ArtVATid, pRowNr] := pVatdat;
        self.gridBillLines.Objects[CCol_ArtVATAccid, pRowNr] := pVatAccdat;


        self.calcArtSum(pRowNr);
        pArtdat.FBillLineHash := self.calcBillLineChgDetectHash(pRowNr);
        Inc(pRowNr);

        // ---
        Next;
      end;




      _focus(gridBillLines);


      self.FOrderId := pOrderId;
      // -- tekitame muudatuse
      gridBillLines.Editor := self.FArticles;
      self.FPaCurrColPos := 1;
      self.FPaCurrRowPos := 1;
      gridBillLines.Col := 1;
      gridBillLines.Row := 1;



      // nagu ettemaksudegi puhul peab olema sama valuuta !!!
      cmbCurrencyList.Enabled := False;
    finally
      //self.FLoadingBillData:=false;

      Close;
      Clear;
    end;

end;

procedure TframeBills.createPrepaymentBill(const pOrderID: integer = 0);
var
  pCurrIndx: integer;
  pClientId: integer;
  pDiffVatCnt: integer;
  pVatId: integer;
  pVatAccountId: integer;

  pOrderSum: double;
  pOrderVATSum: double;
  pPmtOrderSum: double;
  pCalcWVSum: double;

begin
  // esmalt standartne uue kirje loomine
  self.btnBillNewBillClick(btnBillNewBill);
  self.FCurrBillType := CB_prepaymentInvoice;


  // küsime tellimuse kohta andmed
  with qryTemp, SQL do
    try

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectOrder);
      paramByname('id').AsInteger := pOrderID;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      if EOF then
        raise Exception.Create(estbk_strmsg.SEOrderNotFound);


      pClientId := FieldByName('client_id').AsInteger;
      pOrderSum := FieldByName('order_sum').asCurrency;
      pOrderVATSum := FieldByName('order_vatsum').asCurrency;


      billDate.Date := FieldByName('order_date').AsDateTime;
      pCurrIndx := cmbCurrencyList.Items.IndexOf(FieldByName('currency').AsString);
      assert(pCurrIndx >= 0, '#15');

      cmbCurrencyList.ItemIndex := pCurrIndx;
      // et saaksime osadest kontrollidest läbi
      self.refreshUICurrencyList(billDate.Date);



      _focus(gridBillLines);
      self.FOrderId := pOrderId;
      // -- tekitame muudatuse
      gridBillLines.Editor := self.FArticles;
      self.FPaCurrColPos := 1;
      self.FPaCurrRowPos := 1;
      gridBillLines.Col := 1;
      gridBillLines.Row := 1;

      self.FArticles.LookupSource.DataSet.First;
      self.FArticles.Value := self.FArticles.LookupSource.DataSet.FieldByName('id').AsString;

      self.OnLookupComboSelect(self.FArticles);


      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectOrderLines);
      parambyname('order_id').AsInteger := pOrderID;
      Open;
      SortedFields := 'vat_id';
      SortType := stAscending;
      First;
      pVatId := 0;
      pVatAccountId := 0;
      pDiffVatCnt := 0;
      while not EOF do
      begin
        if FieldByName('vat_id').AsInteger <> pVatId then
        begin
          pVatId := FieldByName('vat_id').AsInteger;
          pVatAccountId := FieldByName('vat_account_id').AsInteger;
          Inc(pDiffVatCnt);
        end;
        // ---
        Next;
      end;



      // võtame summa nüüd viimasest maksekorraldusest !
      Close;
      Clear;
      SortedFields := '';
      add(estbk_sqlclientcollection._SQLSelectOrderLastCPmtOrder);
      paramByname('item_type').AsString := estbk_types.CCommTypeAsOrder;
      paramByname('item_id').AsInteger := pOrderID;
      Open;

      // viimane summa, mis on seotud antud tellimusega !
      pPmtOrderSum := FieldByName('isum').AsCurrency;


      // l.vat_id,l.vat_account_id
      // ---
      if pDiffVatCnt <= 1 then
      begin
        self.FPaCurrRowPos := 1;
        self.FPaCurrColPos := CCol_ArtVATid;
        FVAT.Value := IntToStr(pVatId);
        self.OnLookupComboSelect(FVAT);

        self.FPaCurrRowPos := 1;
        self.FPaCurrColPos := CCol_ArtVATAccid;
        FVATAccounts.Value := IntToStr(pVatAccountId);
        self.OnLookupComboSelect(FVATAccounts);


        // leidsime makse ...
        if pPmtOrderSum > 0 then
        begin

          // peame eraldama käibemaksu osa...
          pCalcWVSum := roundto(pPmtOrderSum * 100 / (TVatDataClass(gridBillLines.Objects[CCol_ArtVATid, self.FPaCurrRowPos]).FVatPerc + 100), Z2);

          // peame maha arvutama antud rea käibemaksu !
          gridBillLines.Cells[CCol_ArtPrice, gridBillLines.Row] := format(CCurrentMoneyFmt2, [pCalcWVSum]);
          gridBillLines.Cells[CCol_ArtVATSum, gridBillLines.Row] := format(CCurrentMoneyFmt2, [pPmtOrderSum - pCalcWVSum]);

        end
        else
          // võtame summad otse tellimuse pealt
        begin
          gridBillLines.Cells[CCol_ArtPrice, gridBillLines.Row] := format(CCurrentMoneyFmt2, [pOrderSum]);
          gridBillLines.Cells[CCol_ArtVATSum, gridBillLines.Row] := format(CCurrentMoneyFmt2, [pOrderVATSum]);
        end;
        // ---
      end
      else
      begin
        // mitu käibemaksu, raamatupidaja peab ise oskama maksekorraldust jagada
        gridBillLines.Cells[CCol_ArtPrice, gridBillLines.Row] := format(CCurrentMoneyFmt2, [pOrderSum]);
        gridBillLines.Cells[CCol_ArtVATSum, gridBillLines.Row] := '';
        gridBillLines.Cells[CCol_ArtVATid, gridBillLines.Row] := '';

        if assigned(gridBillLines.Objects[CCol_ArtVATid, gridBillLines.Row]) then
        begin
          gridBillLines.Objects[CCol_ArtVATid, gridBillLines.Row].Free;
          gridBillLines.Objects[CCol_ArtVATid, gridBillLines.Row] := nil;
        end;
      end;




      self.displayClientData(estbk_fra_customer.getClientDataWUI_uniq(pClientId));

      self.calcArtSum(gridBillLines.Row);
      cmbCurrencyList.Enabled := False; // !! peab olema tellimusega sama valuuta !!!!


      // peame kreeditosa õigeks muutma !
      if assigned(cmbSalePuchAcc.LookupSource) then
      begin
        //cmbSalePuchAcc.LookupSource.DataSet.Locate('id',dmodule.sysAccountId[_accSupplPrepaymentVat],[]);
        cmbSalePuchAcc.Value := IntToStr(_ac.sysAccountId[_accSupplPrepaymentVat]);
      end;



      self.FPaCurrRowPos := 1;
      self.FPaCurrColPos := CCol_ArtPrice;
      gridBillLines.Row := 1;
      gridBillLines.Col := CCol_ArtPrice;

      // 29.05.2011 Ingmar; miskitpärast jääb editor nähtavale ?!?
      if assigned(gridBillLines.Editor) and gridBillLines.Editor.Visible then
        gridBillLines.Editor.Visible := False;

    finally
      Close;
      Clear;
      SortedFields := '';
    end;
  // --
end;

procedure TframeBills.gridBillLinesEditingDone(Sender: TObject);
var
  pTmpStr: AStr;
  b: boolean;
begin

  // 22.05.2011 Ingmar; vähemalt kellegil peab olema fookus ! Kas editor või grid ise ! Muidu võib arvutustes tekkida paras jama
  // seoses onEditingDone bugiga on ei tööta enam see loogika !
  // b:=gridBillLines.Focused or (assigned(gridBillLines.Editor) and gridBillLines.Editor.Focused);

  if self.FGridReadOnly then
    Exit;


  with TStringGrid(Sender) do
    if (Col in [CCol_ArtAmount, CCol_ArtPrice, CCol_ArtDisc, CCol_ArtVATid, CCol_ArtVATSum, CCol_ArtPercFromVat]) then
    begin
      pTmpStr := setRFloatSep(trim(Cells[Col, Row]));
      Cells[Col, Row] := pTmpStr;

      if Col in [CCol_ArtPrice, CCol_ArtVATSum, CCol_ArtPercFromVat] then
      begin
        if pTmpStr <> '' then
          Cells[Col, Row] := format(estbk_types.CCurrentMoneyFmt2, [strtoFloatDef(pTmpStr, 0)]);
      end;


      // -- arvutame reasumma uuesti ja jaluse !
      self.calcArtSum(row);
    end;
end;

procedure TframeBills.gridBillLinesEnter(Sender: TObject);
begin
  // 14.02.2011 Ingmar
  // mingi täiesti sürr viga lazaruse tabstoppidega; fookus visatakse kliendiID peale
  //edtContractor.Enabled:=false; // ainus võimalus sulgeda
end;

procedure TframeBills.gridBillLinesExit(Sender: TObject);
begin
  lazFocusFix.Enabled := False;
  //edtContractor.Enabled:=true;
end;

procedure TframeBills.gridBillLinesGetEditText(Sender: TObject; ACol, ARow: integer; var Value: string);
begin
  //   if (ACol in [CCol_ArtAmount,CCol_ArtPrice,CCol_ArtDisc,CCol_ArtVATSum]) then
  //      self.FLastColText:=Value;
  //   else
  //       self.FLastColText:='';
end;

procedure TframeBills.gridBillLinesKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  pCol: integer;
  pRow: integer;
begin

  self.FKeyboardEventTriggered := True;
  // ---
  case key of
    VK_DELETE: if not self.FGridReadOnly and (Shift = [ssCtrl]) then
      begin
        deleteBillLine(self.FPaCurrRowPos);
        key := 0;
      end;

    // 17.08.2010 Ingmar
    VK_RETURN,
    VK_TAB:
      with gridBillLines do
        // CCol_ArtSum
      begin
                      {
                          pCol:= Col;
                          pRow:= Row;
                      if (Integer(pCol + 1) < Integer(CCol_ArtSumTotal-1)) then
                          Col := pCol + 1
                      else
                      if  pRow+1<= RowCount then
                        begin
                          Row:=pRow+1;
                          Col:=1;
                        end; }

        // 18.08.2011 Ingmar natuke intelligentsem lahtrite surfar

        self.performColForwardMove;

        if assigned(Editor) then
          _focus(Editor);
        key := 0;
        // ---

      end
    else
      // 22.07.2011 Ingmar; kui ntx ostuarve võetakse KM Ei arvesta, siis ei tohi lubada käibemaksu kirjutada !
      if assigned(self.gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]) and
        ((TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]).FVatFlags and _CVtmode_dontAdd) = _CVtmode_dontAdd) and
        // 08.08.2011 Ingmar; mõistus ei tule minuga kaasa...ma blokeerisin ka teised lahtrid ! ilma selle IF tingimuseta !
        ((FPaCurrColPos = CCol_ArtVATSum) or (FPaCurrColPos = CCol_ArtPercFromVat)) then

      begin
        Key := 0;
        Exit;
      end;

  end;
  // VK_LEFT,VK_RIGHT,VK_DOWN,VK_NEXT,VK_UP,VK_PRIOR
end;


procedure TframeBills.gridColumnsROStatus(const makeRO: boolean);
var
  i: integer;
begin
  for i := 0 to gridBillLines.Columns.Count - 1 do
  begin
    if (i + 1 in [CCol_ArtSum, CCol_ArtSumTotal, CCol_DeleteCol]) then
      gridBillLines.Columns.Items[i].ReadOnly := True // alati kinni !
    else
      gridBillLines.Columns.Items[i].ReadOnly := makeRO;
  end;
end;

function TframeBills.allowArtChange(): boolean;
var
  pAllowColEdit: boolean;
  pRow: integer;
  pCol: integer;
begin
  Result := False;

  if self.FGridReadOnly then  // ainult lugemiseks lipp üleval...jutt lõppeb !
    exit;


  with self.gridBillLines do
  begin
    pRow := Row;
    pCol := Col;
    if pCol = CCol_ArtCode then
    begin
      Result := True;

      // ---
      // olemas olevat rida saab vaid kustutada !!!!!!
      if assigned(Objects[CCol_ArtCode, pRow]) then
        if (TArticleDataClass(Objects[CCol_ArtCode, pRow]).FBillLineId > 0) or
          (TArticleDataClass(Objects[CCol_ArtCode, pRow]).FRefBillLineId > 0) then
          Result := False;

      // --
    end
    else
    begin
      if self.FArticleRequired then
        Result := (trim(Cells[CCol_ArtCode, pRow]) <> '')
      else
        Result := True;
    end;



    // ---
    pAllowColEdit := True;
    if self.isInternalArticleType(pRow, pCol, pAllowColEdit) then
      Result := pAllowColEdit;
  end;
end;

procedure TframeBills.gridBillLinesKeyPress(Sender: TObject; var Key: char);
var
  pCPos: integer;
  pData: AStr;
  pAllowFrac: boolean;

begin

  // ---------
  with TStringGrid(Sender) do
  begin

    // kui artiklit pole, võib sisestuse ära unustada !
    if not self.allowArtChange() then
    begin

      if not self.FGridReadOnly and (trim(Cells[CCol_ArtCode, Row]) = '') then // 22.04.2010 Ingmar
      begin
        _callMsg(SEArtNotChoosen, mtError, [mbOK], 0);
        _focus(gridBillLines);
        gridBillLines.Col := 1;
      end;
      // ------
      key := #0;
    end;



    // @@@
    if (key = ^V) and (gridBillLines.Col <> CCol_ArtDesc) and (gridBillLines.Col <> CCol_ArtUnit) then
    begin
      key := #0;
      exit;
    end;




    if key = #13 then
    begin
      //if Col+1<ColCount  then
      if Col + 1 < CCol_DeleteCol then
        Col := Col + 1
      else
      if Row + 1 < RowCount then
        Row := Row + 1;
    end
    else
      case Col of
        CCol_ArtSumTotal,
        CCol_ArtSum,
        CCol_ArtVATid,
        CCol_DeleteCol: key := #0;

        CCol_ArtDisc,
        CCol_ArtPrice,
        CCol_ArtVATSum, // 28.04.2010 Ingmar
        CCol_ArtPercFromVat, // 20.04.2015 Ingmar
        //CCol_ArtSum,
        CCol_ArtAmount:
        begin

          // 14.01.2010 Ingmar; seoses kreediarve ridadega lubada - kogust !
          // Täpsustada:  ostuarvele neg kogus ?!?!
          //((FCurrBillType= CB_purcInvoice) (key='-'))
          if (key = '+') then
          begin
            key := #0;
            exit;
          end;


          // -------
          pAllowFrac := True;
          if (Ord(key) < 32) then
            exit;

          if (TStringCellEditor(Editor).SelLength <> length(TStringCellEditor(Editor).Text)) then
          begin
            // 21.04.2015 Ingmar; ka käibemaksust protsenti ei tohi lubada üle 100 !
            // allahindlus saab olla ainult 3 kohaline number !
            if Col in [CCol_ArtDisc, CCol_ArtPercFromVat] then
            begin
              pAllowFrac := False;
              if length(Cells[Col, Row]) = 3 then
                key := #0;

              // üle 100% sisestus ei luba !
              if strtoFloatDef(Cells[Col, Row] + key, 0) > 100 then
                key := #0;
            end
            else
            begin
              // 2 kohta peale koma !!!!!
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



              pData := Cells[Col, Row];
              // mitu numbrikohta lubame;
              if (length(pData) >= CIntPartLen) and (pCPos = 0) then
                key := #0
              else
              if (length(pData) >= CIntPartLen + CFracPartLen) and (pCPos > 0) then
                key := #0;
            end;
            // @@@
          end;

          estbk_utilities.edit_verifyNumericEntry(Editor as TCustomEdit, key, pAllowFrac);
        end;
        // ---
      end;
  end;
end;

procedure TframeBills.gridBillLinesPickListSelect(Sender: TObject);
begin
  self.OnMiscChange(TStringGrid(Sender).Editor);
end;


procedure TframeBills.gridBillLinesDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
const
  CCLeftDelta = -1;
  CCWidthDelta = -1;

var
  pRectCpy: TRect;
begin

  with TStringGrid(Sender) do
    if (aRow = 0) and (aCol > 0) then
    begin
      Canvas.FillRect(aRect);
      Canvas.TextOut(aRect.Left + 5, aRect.Top + 2, Columns.Items[aCol - 1].Title.Caption);
    end
    else
    begin

      // 18.10.2010 Ingmar; pöördkäibemaksu lahtri värvime kollaseks
      if (aCol = CCol_ArtVATSum) and assigned(Objects[CCol_ArtVATid, aRow]) and
        ((TVatDataClass(Objects[CCol_ArtVATid, aRow]).FVatFlags and estbk_types._CVtmode_turnover_tax) = _CVtmode_turnover_tax) then
        //not (gdSelected in aState) then
        Canvas.Brush.Color := glob_userSettings.uvc_colors[uvc_gridColorForBillRvrVatCell];



      if aCol = CCol_DeleteCol then
      begin
        Canvas.FillRect(aRect);
        // 26.10.2010 Ingmar; viisin ikoonid datamodule sisse, sest timagelist ja frame = suured probleemid !
        dmodule.sharedImages.Draw(Canvas, aRect.Left, aRect.Top, estbk_clientdatamodule.img_indxSimpleDel);

        //billImg.Draw();
      end
      else
        DefaultDrawCell(aCol, aRow, aRect, aState);
    end;

  // TODO; refakt. dubleeriv kood ära kaotada !
  if (gdFocused in aState) then
    if aRow >= 1 then
      case aCol of
        CCol_ArtCode:
        begin
          FArticles.Left := (aRect.Left + TStringGrid(Sender).Left) + CCLeftDelta;
          FArticles.Top := aRect.Top;
          FArticles.Width := (aRect.Right - aRect.Left) + CCWidthDelta;
          FArticles.Height := (aRect.Bottom - aRect.Top) - 2;
          if FArticles.Height < 20 then
            FArticles.Height := 21;

        end;

        CCol_ArtAcc:
        begin
          FAccounts.Left := (aRect.Left + TStringGrid(Sender).Left) + CCLeftDelta;
          FAccounts.Top := aRect.Top;
          FAccounts.Width := (aRect.Right - aRect.Left) + CCWidthDelta;
          FAccounts.Height := (aRect.Bottom - aRect.Top) - 2;
          if FAccounts.Height < 20 then
            FAccounts.Height := 21;

        end;

        CCol_ArtVATid:
        begin
          FVat.Left := (aRect.Left + TStringGrid(Sender).Left) + CCLeftDelta;
          FVat.Top := aRect.Top;
          FVat.Width := (aRect.Right - aRect.Left) + CCWidthDelta;
          FVat.Height := (aRect.Bottom - aRect.Top) - 2;
          if FVat.Height < 20 then
            FVat.Height := 21;
        end;

        CCol_ArtVATAccid:
        begin
          FVATAccounts.Left := (aRect.Left + TStringGrid(Sender).Left) + CCLeftDelta;
          FVATAccounts.Top := aRect.Top;
          FVATAccounts.Width := (aRect.Right - aRect.Left) + CCWidthDelta;
          FVATAccounts.Height := (aRect.Bottom - aRect.Top) - 2;
          if FVATAccounts.Height < 20 then
            FVATAccounts.Height := 21;

        end;

        CCol_ArtObject:
        begin

          FObjects.Left := (aRect.Left + TStringGrid(Sender).Left) + CCLeftDelta;
          FObjects.Top := aRect.Top;
          FObjects.Width := (aRect.Right - aRect.Left) + CCWidthDelta;
          FObjects.Height := (aRect.Bottom - aRect.Top) - 2;
          if FObjects.Height < 20 then
            FObjects.Height := 21;

        end;
     {  else
       begin
            (TStringGrid(Sender).EditorByStyle(cbsAuto) as TStringCellEditor).Top:= aRect.Top+3;
       end; }
        // ---
      end;
  //  TStringGrid(Sender).DefaultDrawCell(aCol,aRow,aRect,aState);
end;

procedure TframeBills.displayClientData(const pNewClientData: TClientData; const pKeepRefClientDataObj: boolean = False);
begin

  edtCustname.Color := clWindow;
  edtCustname.Font.Color := clWindowText;

  // ---
  if assigned(self.FClientData) and not pKeepRefClientDataObj then
    FreeAndNil(self.FClientData);

  if assigned(pNewClientData) then
  begin

    // jätame globaalse kliendi objekti meelde !
    self.FClientData := pNewClientData;

    //edtContractor.text:=inttostr(self.FClientData.FClientId);
    edtContractor.Text := self.FClientData.FClientCode;
    edtCustname.Text := self.FClientData.FCustFullNameRev;


    // ainult ostuarvete puhul
    if self.FCurrBillType = CB_purcInvoice then
    begin
      edtBankaccount.Text := self.FClientData.FCustBankAccount;
      // TODO 05.04.2012 Ingmar viitenumbri osa paremini läbi mõelda !
      //edtRefNumber.Text:=self.FClientData.FCustContrRefNr;
    end
    else
    begin
      edtBankaccount.Text := '';
      // TODO 05.04.2012 Ingmar viitenumbri osa paremini läbi mõelda !
      //edtRefNumber.Text:='';
    end;



    with FClientData do
      edtCustAddr.Text := estbk_utilities.miscGenBuildAddr(FCustJCountry, FCustJCounty, FCustJCity, FCustJStreet,
        FCustJHouseNr, FCustJApartNr, FCustJZipCode);
  end
  else
  begin
    edtContractor.Text := '';
    edtCustname.Text := '';
    edtBankaccount.Text := '';
    edtRefNumber.Text := '';
    edtCustAddr.Text := '';
    edtCustAddr.Hint := '';
  end;
  // ------------

end;

procedure TframeBills.btnOpenClientListClick(Sender: TObject);
var
  pnewClient: TClientData;
begin

  if self.FGridReadOnly then
    exit;

  try

    pnewClient := estbk_frm_choosecustmer.__chooseClient(strtointdef(edtContractor.Text, -1));
    if assigned(pnewClient) then
      self.displayClientData(pnewClient);
    self.FSmartEditLastSuccIndx := -1; // reset otsingule


    edtCustname.Invalidate;
    _focus(self.gridBillLines);

  except
    on e: Exception do
      _callMsg(format(estbk_strmsg.SEMajorAppError, [e.message]), mtError, [mbOK], 0);
  end;
end;

procedure TframeBills.doPrint(var pFilename: AStr; const pEMailMode: boolean = False);
{
openBill(13);
self.FGridReadOnly:=false;
}
var
  pArtItemsCollection: TCollection;
  pitem: TvMergedBillLines;
  pvv: integer;
  pRepDef: AStr;
begin
  pFilename := '';
  self.FReportPagenr := 0;
  try
    pArtItemsCollection := TCollection.Create(TvMergedBillLines);


    pvv := 0;
    if self.verifyAndCreateCollection(pArtItemsCollection, pvv) then
    begin

      // konverteerime datasetiks
      self.convertBillDataToDynDataset(pArtItemsCollection);
      self.buildRptFooterStrList(pArtItemsCollection, self.FReportSumFtrData);
      qInvoiceMemDataset.First;



      // 11.04.2013 Ingmar; nüüd on võimalik kasutajal ise öelda, kus ta arve aruande fail on...
      if not Fileexists(dmodule.userStsValues[estbk_settings.Csts_bill_rep_templatename]) then
        pRepDef := includetrailingbackslash(self.reportDefPath) + estbk_reportconst.CInvoiceReportFileName // DEFAULT !!!
      else
      begin
        // postgres ja escape probleem ?
        pRepDef := dmodule.userStsValues[estbk_settings.Csts_bill_rep_templatename];
        pRepDef := StringReplace(pRepDef, '\134', '\', [rfReplaceAll]);
      end;



      if not FileExists(pRepDef) then
        raise Exception.createFmt(estbk_strmsg.SEReportDataFileNotFound, [pRepDef]);

      qInvoiceReport.LoadFromFile(pRepDef);


      // 02.08.2011 Ingmar
      if pEMailMode then
      begin
        pFilename := includetrailingbackslash(GetTempDir(False)) + format(stringreplace(estbk_strmsg.CSCmBillnr, ' ', '_', []),
          [doFilenameCleanup(edtBillNr.Text)]) + '.pdf';
        if qInvoiceReport.PrepareReport then
          qInvoiceReport.ExportTo(TFrTNPDFExportFilter, pFilename);
        Exit;
      end; // -->



      // ------ see on siis, kui tegemist normaalse printimisega,
      // mitte kohe faili printimisega nagu pdf puhul !

      //qInvoiceReport.ShowProgress:=true;
      if mnuScreen.Checked then
        qInvoiceReport.ShowReport
      else
      if mnuPdfFile.Checked then
      begin
        pSaveDialog.FileName := format(estbk_strmsg.SCBillOfmtFilename, [edtBillNr.Text]) + '.pdf';
        if pSaveDialog.Execute then
          try
            self.FSaveBillAsPdf := True;
            self.FPrintMode := True;
            if qInvoiceReport.PrepareReport then
            begin
              //qInvoiceMemDataset.First;
              qInvoiceReport.ExportTo(TFrTNPDFExportFilter, pSaveDialog.Files.Strings[0]);
            end;

          finally
            self.FSaveBillAsPdf := False;
            self.FPrintMode := False;
          end;
      end; { else
                   // 17.04.2011 Ingmar; kahjuks
                  if  mnuBillHtmlFile.Checked then
                    begin
                          pSaveDialog.FileName:=format(estbk_strmsg.SCBillOfmtFilename,[edtBillNr.Text])+'.html';
                       if pSaveDialog.Execute then
                        begin

                        if qInvoiceReport.PrepareReport then
                          qInvoiceReport.ExportTo(TfrHTMExportFilter,pSaveDialog.Files.Strings[0]);
                        end;
                    end;  }
    end; // ---

  finally
    if assigned(pArtItemsCollection) then
      FreeAndNil(pArtItemsCollection);
    // ---
    self.deleteConvertedDataset; // !!! dataset puhver ära tühjendada !

    self.FReportSumFtrData.Clear;
  end;

end;

procedure TframeBills.btnPrintClick(Sender: TObject);
var
  pDummy: AStr;
begin
  try
    self.FPrintMode := True;
    self.doPrint(pDummy, False);
  finally
    self.FPrintMode := False;
  end;
end;

// TODO: kahtlane lahendus, kontrolli üle !
procedure TframeBills.deleteConvertedDataset;
begin
  // ainus töötav kombinatsioon
  qInvoiceMemDataset.Clear;
  self.defineInMemTableStructs;
      {
        // 25.01.2010 Ingmar
        // imelik see, et kui close panna, jäävad eelmise dataseti andmed alles !?!?!?!
        First;
     while not eof do
       begin
          Delete;
          Next;
       end;

       if not eof then
          Delete;}

end;

// -- summary !!!
procedure TframeBills.buildRptFooterStrList(const pArtItemCollection: TCollection; const pFtrData: TAStrlist);
var
  pFirstRun: boolean;
  bOk: boolean;
  pCurrVatId: integer;
  i, j, k: integer;
  // ---
  pVatSumTotal: double; // -- sum
  pArtVatNonCalcPart: double;
  pDummPrice: double;
  pVatSum: double;
  pCalcVAT: double;
  pArtTotalPrice: double;
  pArtSumTotal: double; // -- sum
  pBillSumTotal: double; // -- sum
  pBillLine: TvMergedBillLines;
  pTempVatNmBfr: TAStrList;
  pCurr: AStr;
  pLongVatName: AStr;

begin
  if not assigned(pArtItemCollection) or (pArtItemCollection.Count = 0) then
    Exit;

  try
    pCurr := '';
    pVatSumTotal := 0.00;
    pArtVatNonCalcPart := 0.00;
    // lisame rahayhiku siis, kui pole baasvaluuta
    if cmbCurrencyList.Text <> estbk_globvars.glob_baseCurrency then
      pCurr := #32 + cmbCurrencyList.Text;


    // -----
    pTempVatNmBfr := TAStrList.Create;
    pFtrData.Clear;


    // ---
    // käibemaksud sorteerime ära
    self.bubbleSortBillLines(pArtItemCollection);
    i := 0;
    j := 0;

    while (j <= pArtItemCollection.Count - 1) do
    begin
      pBillLine := pArtItemCollection.Items[i] as TvMergedBillLines;
      pCurrVatId := pBillLine.FVatID;
      while j <= pArtItemCollection.Count - 1 do
      begin
        pBillLine := pArtItemCollection.Items[j] as TvMergedBillLines;
        if pBillLine.FVatID <> pCurrVatId then
          break;

        Inc(j);
      end;


      pCalcVAT := 0;
      // võtame käibemaksu kirjelduse esimese kirje pealt !
      pBillLine := pArtItemCollection.Items[i] as TvMergedBillLines;
      pLongVatName := pBillLine.FVatLongName;



      // Pöördkäibemaksu ei lisa arvele !
      // 09.05.2011 Ingmar
      // Kui firma pole käibemaksu kohuslane, siis samuti neid ridu mitte kuvada !
      // Samas vaatame ikka Ei arvesta lippu, alati on N case, kus võib-olla vaja KM'd

      bOk := ((pBillLine.FVatFlags and estbk_types._CVtmode_turnover_tax) <> estbk_types._CVtmode_turnover_tax) and
        ((pBillLine.FVatFlags and estbk_types._CVtmode_dontAdd) <> estbk_types._CVtmode_dontAdd);
      if (bOk) then
      begin

        // võtame fragmendi välja
        for k := i to j - 1 do
        begin
          pBillLine := pArtItemCollection.Items[k] as TvMergedBillLines;



          self.calcArtTotalPrice(pBillLine, pDummPrice, pVatSum, pArtVatNonCalcPart);
          pCalcVat := pCalcVat + pVatSum;
          //pCalcVAT:=pCalcVAT+pBillLine.FCalcLineVatSum;
        end;


        pVatSumTotal := pVatSumTotal + pCalcVat; // kogusumma, mitte ainult antud grupi summa
        if trim(pLongVatName) <> '' then
          pTempVatNmBfr.Values[pLongVatName] := format(CCurrentMoneyFmt2, [pCalcVAT]) + pCurr;
      end;
      // ---
      i := j;
      // ---
    end;




    pArtSumTotal := 0;
    for i := 0 to pArtItemCollection.Count - 1 do
    begin
      pArtTotalPrice := 0;
      pCalcVAT := 0; // -- enam meid km summa ei huvita !!!!
      pBillLine := pArtItemCollection.Items[i] as TvMergedBillLines;


      self.calcArtTotalPrice(pBillLine, pArtTotalPrice, pCalcVAT, pArtVatNonCalcPart); // pCalcVAT
      pArtSumTotal := pArtSumTotal + pArtTotalPrice + pArtVatNonCalcPart;
    end;




    // Summa
    pFtrData.values[estbk_strmsg.SCCaptBillSum] := format(CCurrentMoneyFmt2, [pArtSumTotal]) + pCurr;


    // -- kanname ka kõik erinevad käibemaksu read üle !!!!!!!
    for i := 0 to pTempVatNmBfr.Count - 1 do
      pFtrData.add(pTempVatNmBfr.Strings[i]);




    // -- ümmardus
    if not Math.isZero(strtofloatdef(edtRoundBc.Text, 0)) then
      pFtrData.values[estbk_strmsg.SCCaptRndSum] := format(CCurrentMoneyFmt2, [strtofloatdef(edtRoundBc.Text, 0)]);




    // Arvesumma kokku
    pBillSumTotal := pArtSumTotal + pVatSumTotal;
    pFtrData.values[estbk_strmsg.SCCaptBillSumTotal] := format(CCurrentMoneyFmt2, [pBillSumTotal]) + pCurr;


    // ainult müügiarve puhul kuvada ?!?!?!?
    if (FCurrBillType = CB_salesInvoice) and (pBillSumTotal > 0) then
    begin
      // Tasumisele kuulub; kui ettemaksude osa ka tuleb, siis antud kohta muutub !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      pFtrData.values[estbk_strmsg.SCCaptBillSumToPay] := format(CCurrentMoneyFmt2, [pBillSumTotal]) + pCurr;
    end;

    // ------------
  finally
    FreeAndNil(pTempVatNmBfr);
  end;
end;

procedure TframeBills.convertBillDataToDynDataset(const pArtItemCollection: TCollection);
var
  i, j: integer;
  bl: TvMergedBillLines;
  pArtPriceTotal: double;
  pArtVat: double;
  pArtVatNonCalcPart: double;
  pBillNotes: AStr;
  pArtDescr: AStr;
begin
  // defineerime struktuurid
  // imelik TMemDataseti bugi; kui pidevalt välju uuesti ei defineeri, siis korralik crash !
  //self.defineInMemTableStructs;
  with qInvoiceMemDataset do
    try

      // ---
      Close;
      Active := True;
      //   for j:=0 to 300 do
      for i := 0 to pArtItemCollection.Count - 1 do
      begin
        bl := TvMergedBillLines(pArtItemCollection.items[i]);
        //Insert;
        Append;
        //Fields[0].asString:='xxx';
        FieldByName('blnotes').AsString := pBillNotes;


        // artikli andmed
        FieldByName('artcode').AsString := bl.FArtCode;
        pArtDescr := bl.FArtOrigDescr;
        if trim(bl.FArtDescr) <> '' then
          pArtDescr := bl.FArtDescr;

        FieldByName('artdescr').AsString := pArtDescr;
        FieldByName('artunit').AsString := bl.FUnit;

        FieldByName('artqty').AsFloat := bl.FQty;
        FieldByName('artprice').AsFloat := bl.FPrice;
        // ---
        // 11.04.2013 Ingmar
        FieldByName('artobject').AsString := bl.FObjectName;

        // ---
        pArtPriceTotal := 0.00;
        pArtVat := 0.00;
        pArtVatNonCalcPart := 0.00;



        self.calcArtTotalPrice(bl, pArtPriceTotal, pArtVat, pArtVatNonCalcPart);

        FieldByName('artpricetotal').AsFloat := pArtPriceTotal;
        FieldByName('artvatperc').AsFloat := bl.FVatPerc;
        FieldByName('artdiscount').AsFloat := bl.FDiscount;
        FieldByName('artvatid').AsInteger := bl.FVatID;
        FieldByName('artvatlongname').AsString := bl.FVatLongName;
        Post;
      end;


      // ----
    except
      on e: Exception do
        _callMsg(format(estbk_strmsg.SEError, [e.message]), mtError, [mbOK], 0);
    end;
end;

// Kui muudetakse valuuta ära !
// pole just H264 algoritm :)) peame read uuesti arvutama; õigemini artikli hinna !!
procedure TframeBills.reCalculateArtPrice;
var
  i: integer;
  pNewPrice: double;
  pSelCurrVal: double;

begin
  // 22.05.2011 Ingmar
  if cmbCurrencyList.Text <> estbk_globvars.glob_baseCurrency then
    with gridBillLines do
      for i := 1 to RowCount - 1 do
      begin

        // ---
        if (trim(Cells[CCol_ArtCode, i]) <> '') and assigned(Objects[CCol_ArtCode, i]) and
          (TArticleDataClass(Objects[CCol_ArtCode, i]).FArtId > 0) then
          try

            // 24.03.2010 ingmar; kui liiga kiiresti liikuda siis programm kukub kokku ?!?
            // 22.05.2011 ingmar; kui tabelis kirjeldatud hind puudub, tuleb tõtta aluseks see, mis on lahtris !
            pNewPrice := TArticleDataClass(Objects[CCol_ArtCode, i]).FArtOrigPrice;
            if not Math.isZero(pNewPrice) then
            begin
              pSelCurrVal := Self.getSelectedCurrExcRate();
              if pSelCurrVal > 0 then
                pNewPrice := RoundTo(pNewPrice / pSelCurrVal, Z2)
              else
                pNewPrice := 0;


              Cells[CCol_ArtPrice, i] := format(CCurrentMoneyFmt2, [pNewPrice]);
            end;

            // --------------------------------------------------------------
            // ja arvutame kogusumma ka igakord uuesti...tobe...tean...
            // --------------------------------------------------------------

            self.calcArtSum(i);

          except
            on e: Exception do
        {$ifdef debugmode}
              ShowMessage('CurrVal failure');
        {$endif}
          end;
      end;
end;

procedure TframeBills.refreshUICurrencyList(const pDate: TDatetime);
var
  pCurrDate: TDate;
  pCurrFnd: boolean;
  pItemIndex: integer;
begin

  if (billDate.Text <> '') and (pDate < now) then   // märkus billdate.date enne date accepti pole õige, selletõttu ei saa seda otse kasutada !!!!
    try
      pItemIndex := cmbCurrencyList.ItemIndex;
      pCurrDate := pDate; //billDate.date; //  accDate.date



      if ((dateutils.daysbetween(TCurrencyObjType(cmbCurrencyList.items.Objects[pItemIndex]).currDate, pCurrDate) <> 0) or
        (TCurrencyObjType(cmbCurrencyList.items.Objects[pItemIndex]).currVal <= 0)) then
      begin
        if (pItemIndex >= 0) and (cmbCurrencyList.items.Strings[pItemIndex] = estbk_globvars.glob_baseCurrency) then
          Exit;

        pCurrFnd := estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pCurrDate, self.FCurrList);
        // valuutakurssi ei leitud !
        if not pCurrFnd then
          if assigned(self.onAskCurrencyDownload) then
            try
              self.onAskCurrencyDownload(self, pCurrDate);
              estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pCurrDate, self.FCurrList); // uuesti !
            except
              estbk_utilities.miscResetCurrenyValList(cmbCurrencyList);
            end;
      end;

      // --
      if pItemIndex >= 0 then
      begin
        pcurrVal.Caption := #32 + format(CCurrentAmFmt4, [TCurrencyObjType(cmbCurrencyList.items.Objects[pItemIndex]).currVal]);
        //lblCurrPSum.Caption:=cmbCurrencyList.items.Strings[pItemIndex]+#32;
      end
      else
      begin
        pcurrVal.Caption := '';
        //lblCurrPSum.Caption:='';
      end;



      // --- nüüd selline olukord, et peame arveread uuesti arvutama !!!
      self.reCalculateArtPrice;

    except
      on e: Exception do
        if (e is EAbort) then
          estbk_utilities.miscResetCurrenyValList(cmbCurrencyList)
        else
          raise;
    end
  else
    try
      // --
      estbk_utilities.miscResetCurrenyValList(cmbCurrencyList);
      if pItemIndex >= 0 then
      begin
        if cmbCurrencyList.Text = estbk_globvars.glob_baseCurrency then
          pcurrVal.Caption := #32 + format(CCurrentAmFmt4, [double(1.000)])
        else
        if assigned(cmbCurrencyList.items.Objects[pItemIndex]) then
          pcurrVal.Caption := #32 + format(CCurrentAmFmt4, [TCurrencyObjType(cmbCurrencyList.items.Objects[pItemIndex]).currVal]);
        //lblCurrPSum.Caption:=cmbCurrencyList.items.Strings[pItemIndex]+#32;
      end
      else
      begin
        pcurrVal.Caption := '';
        // lblCurrPSum.Caption:='';
      end;


      // !!!!!!!!!!!!!!!!!!!!!!!!!!
      self.reCalculateArtPrice;
      // !!!!!!!!!!!!!!!!!!!!!!!!!!

    except
    end;
end;

function TframeBills.verifyAndCreateCollection(const pArtItemCollection: TCollection; var pAccperiod: integer): boolean;
var
  i: integer;
  pArtId: integer;
  pArtAccId: integer;
  pVATId: integer;
  pVatAccId: integer;
  pObjectId: integer;
  pObjectName: AStr;
  //pVatSkip   : Boolean;
  pVatFlags: integer;
  pEmptyLine: boolean;
  pError: boolean;
  pItemDescr: AStr;
  pItemOrigDescr: AStr;
  pVatLongName: AStr;
  pArtCode: AStr;
  pArtType: AStr;
  pArtPriceCalcMeth: AStr;
  pArtQty: double;
  pArtPrice: double; // hetke hind arve real !! võib olla kasutaja poolt muudetud

  pItemSalePr: double;
  pItemPurcPr: double;

  pArtDiscount: double;
  pArtVatPerc: double;
  pVATSumPercFromVat: double;

  pArtVatNonCalcPart: double; // auto km
  pDummy: double;
  pVatSum: double;

  pItemUnit: AStr;
  pArtQryBk: TBookmark;
  pSuccess: integer;
  pArtSpecialFlags: integer;
  // ---
  pBillLine: TvMergedBillLines;

begin
  try
    Result := False;
    pAccperiod := 0;
    pArtQryBk := nil;

    if (trim(cmbSalePuchAcc.Text) = '') or not cmbSalePuchAcc.LookupSource.DataSet.locate('account_coding', cmbSalePuchAcc.Text, []) then
    begin
      _callMsg(estbk_strmsg.SEDCAccountNotFound, mtError, [mbOK], 0);
      _focus(cmbSalePuchAcc);
      Exit;
    end;

    if (trim(edtBillNr.Text) = '') then
    begin
      _callMsg(estbk_strmsg.SEBillNrIsMissing, mtError, [mbOK], 0);
      _focus(edtBillNr);
      Exit;
    end;


    if (trim(billDate.Text) = '') then
    begin
      _callMsg(estbk_strmsg.SEBillDateIsMissing, mtError, [mbOK], 0);
      _focus(billDate);
      Exit;
    end;

    if billDate.date > SysUtils.date() then
    begin
      _callMsg(estbk_strmsg.SEBillDateInFuture, mtError, [mbOK], 0);
      _focus(billDate);
      Exit;
    end;


    // õige teade kuvada
    //if trim(edtCustAddr.text)='' then
    if not assigned(self.FClientData) then
    begin
      case self.FCurrBillType of
        CB_salesInvoice: _callMsg(estbk_strmsg.SECustomerNotChoosen, mtError, [mbOK], 0);
        CB_purcInvoice: _callMsg(estbk_strmsg.SEContractorNotChoosen, mtError, [mbOK], 0);
      end;

      _focus(btnOpenClientList);
      // ---
      Exit;
    end; // ---


    if (cmbCurrencyList.ItemIndex = -1) or (TCurrencyObjType(cmbCurrencyList.Items.Objects[cmbCurrencyList.ItemIndex]).currVal <= 0) then
    begin
      _callMsg(estbk_strmsg.SECantDetermineCurrVal, mtError, [mbOK], 0);
      _focus(cmbCurrencyList);
      Exit;
    end;


    // 23.02.2014 Ingmar; tore küll, aga see kontroll ei lubanud arveid enam muuta, mis olid tehtud eelmistes rp. perioodides !!!!!!!
    // 07.03.2010 Ingmar


    // OTSIME sobiva raamatupidamis perioodi !!!
    pAccperiod := 0;
    if not self.FPrintMode then
    begin
      pAccperiod := estbk_clientdatamodule.dmodule.getAccoutingPerId(accDate.date);
      // järelikult viga !
      if pAccperiod < 1 then
        Exit;
    end;


    // -------
    pSuccess := 0;
    qryGetArticles.DisableControls;
    pArtQryBk := qryGetArticles.GetBookmark;

    with gridBillLines do
      for i := 1 to RowCount - 1 do
      begin
        pEmptyLine := (trim(Cells[CCol_ArtCode, i]) = '') and (trim(Cells[CCol_ArtDesc, i]) = '') and
          (trim(Cells[CCol_ArtUnit, i]) = '') and (trim(Cells[CCol_ArtAcc, i]) = '') and (trim(Cells[CCol_ArtAmount, i]) = '') and
          (trim(Cells[CCol_ArtPrice, i]) = '') and (trim(Cells[CCol_ArtDisc, i]) = '') and (trim(Cells[CCol_ArtSum, i]) = '') and
          (trim(Cells[CCol_ArtPercFromVat, i]) = '') // 20.04.2015 Ingmar
          and (trim(Cells[CCol_ArtVATid, i]) = '') and (trim(Cells[CCol_ArtSumTotal, i]) = '');

        if pEmptyLine then
          continue;



        pError := False;
        pArtId := 0;

        // 22.04.2010 Ingmar; artikkel kohustuslik
        if (trim(Cells[CCol_ArtCode, i]) <> '') then
        begin
          assert(assigned(Objects[CCol_ArtCode, i]), '#5');
          pArtId := TArticleDataClass(Objects[CCol_ArtCode, i]).FArtId;
          pError := (pArtId < 1);
        end
        else
          pError := not FArticleRequired;
        // ---



        // --------------------------------------------------------
        pItemDescr := Cells[CCol_ArtDesc, i];
        // --------------------------------------------------------
        // 22.04.2010 Ingmar; aga kui pole tootekoodi valitud, siis kirjeldus PEAB olema !
        if not FArticleRequired then
          pError := trim(pItemDescr) = '';


        if pError then
        begin
          _callMsg(estbk_strmsg.SEArtNotChoosen2, mtError, [mbOK], 0);
          // --
          Row := i;
          Exit;
        end;


        //qryGetArticles.First;
        // 06.01.2010 ingmar; naljakas viga; kui on vaid üks kirje ja id isegi klapib, siis locate ei leia seda elementi...
        //  or (qryGetArticles.FieldByname('id').asInteger=pArtId)

        pArtSpecialFlags := 0;
        // 22.04.2010 Ingmar; kas kohustuslik
        if (pArtId > 0) and (qryGetArticles.Locate('id', integer(pArtId), [])) then
        begin
          pItemOrigDescr := qryGetArticles.FieldByName('artname').AsString;
          pItemSalePr := qryGetArticles.FieldByName('currsale_price').asCurrency;
          pItemPurcPr := qryGetArticles.FieldByName('purchase_price').asCurrency;


          // 11.02.2010 Ingmar
          pArtType := qryGetArticles.FieldByName('arttype').AsString;
          pArtCode := qryGetArticles.FieldByName('artcode').AsString;
          pArtPriceCalcMeth := qryGetArticles.FieldByName('price_calc_meth').AsString;
          pArtSpecialFlags := qryGetArticles.FieldByName('special_type_flags').AsInteger;
        end
        else
        if FArticleRequired then
        begin
          _callMsg(estbk_strmsg.SEArtNotChoosen2, mtError, [mbOK], 0);
          // --
          Row := i;
          Exit;
        end
        else // ---
          // -- antud juhul puudub meil võrdlusmoment !
        begin
          // ehk kasutaja poolt kirjeldatud rida !
          if (trim(Cells[CCol_ArtCode, i]) = '') then
          begin
            pArtId := 0;
            pArtSpecialFlags := 0;
            pItemOrigDescr := '';
            pItemSalePr := 0;
            pItemPurcPr := 0;
            pArtType := '';
            pArtCode := '';
            pArtPriceCalcMeth := '';
          end; // ---
        end;




        // 11.09.2010 Ingmar; ettemaksu artiklil ühikut mitte nõuda
        if (self.FCurrBillType <> CB_prepaymentInvoice) and (pArtSpecialFlags and estbk_types.CArtSpTypeCode_PrepaymentFlag = 0) then
        begin

          // 06.02.2011 Ingmar; !!!!!!!!!!! selgus, et peale eemise muudatust kadus arvel ühik !
          pItemUnit := trim(Cells[CCol_ArtUnit, i]);
          pError := False;
          if (trim(Cells[CCol_ArtAcc, i]) <> '') then
          begin
            assert(assigned(Objects[CCol_ArtAcc, i]), '#6');
            pArtAccId := TAccountDataClass(Objects[CCol_ArtAcc, i]).FAccId;
            pError := (pArtAccId < 1);
          end
          else
            pError := True;


          if pError then
          begin
            _callMsg(estbk_strmsg.SEArtAccIsMissing, mtError, [mbOK], 0);
            // --
            Row := i;
            Col := CCol_ArtAcc;
            Exit;
          end;
        end; // ---




        // kogus !
        pError := False;
        if (trim(Cells[CCol_ArtAmount, i]) <> '') then
        begin
          pArtQty := strtoFloatDef(Cells[CCol_ArtAmount, i], Math.NaN); // pigem paneme Nan väärtuse, st kogus jama !
          // 14.01.2010 Ingmar; nüüd lubame ka negatiivseid artikli koguseid !
          //pError:=(pArtQty<1);
          // 22.04.2010 Ingmar; aga me ei luba 0 kogusega rida !!!!

          // 26.04.2014 Ingmar; tahaks mõjumat põhjust, miks 0 read pole lubatud, palju rp. kasutavad neid informatiivsetel alustel
          // pError:=(pArtQty=0);
          pError := Math.IsNan(pArtQty);
        end
        else
          pError := True;

        if pError then
        begin
          _callMsg(estbk_strmsg.SEArtQtyIsZero, mtError, [mbOK], 0);
          // --
          Row := i;
          Col := CCol_ArtAmount;
          Exit;
        end;


              {
              if pError then
                begin
                  _callMsg(estbk_strmsg.SEArtQtyIsZero,mtError,[mbOk],0);
                  // --
                  Row:=i;
                  Col:=CCol_ArtAmount;
                  Exit;
                end;
              }



        // --
        pError := False;
        if (trim(Cells[CCol_ArtPrice, i]) <> '') then
        begin
          // 26.04.2014 Ingmar; miks 0 hind pole ka lubatud; ntx vaja lihtsalt informatiivset rida !!!!
          pArtPrice := StrtoFloatDef(Cells[CCol_ArtPrice, i], Math.NaN);
          //pError:=(pArtPrice=0);
          pError := Math.IsNan(pArtPrice);
        end
        else
          pError := True;

        if pError then
        begin
          _callMsg(estbk_strmsg.SEArtPriceIsMissing, mtError, [mbOK], 0);
          // --
          Row := i;
          Col := CCol_ArtPrice;
          Exit;
        end;

        pArtDiscount := strtoFloatDef(Cells[CCol_ArtDisc, i], 0);
        if (pArtDiscount < 0) or (pArtDiscount > 100) then
          pArtDiscount := 0;


        // 23.04.2015 Ingmar; ehk siis mitu protsenti käibemaksust saame maha arvata...oeh...segane värk
        pVATSumPercFromVat := strtoFloatDef(Cells[CCol_ArtPercFromVat, i], 100);
        if (pVATSumPercFromVat < 0) or (pVATSumPercFromVat > 100) then
          pVATSumPercFromVat := 100;




        // kontrollime, kas käibemaksu tüüp ikka valitud !
        pError := False;
        pVatFlags := 0;
        if (trim(Cells[CCol_ArtVATid, i]) <> '') then
        begin
          assert(assigned(Objects[CCol_ArtVATid, i]), '#7');
          pVATId := TVatDataClass(Objects[CCol_ArtVATid, i]).FVatId;
          pVatLongName := TVatDataClass(Objects[CCol_ArtVATid, i]).FVatLongDescr;

          // --
          pArtVatPerc := TVatDataClass(Objects[CCol_ArtVATid, i]).FVatPerc;
          pVatFlags := TVatDataClass(Objects[CCol_ArtVATid, i]).FVatFlags;


          pError := (pVATId < 1);
        end
        else
          pError := True;

        if pError then
        begin
          _callMsg(estbk_strmsg.SEArtVatIsMissing, mtError, [mbOK], 0);
          // --
          Row := i;
          Col := CCol_ArtVATid;
          Exit;
        end;



        // 22.07.2011 ingmar; muidu Ei arvesta juures kuvati viga, et suvaline integer väärtus not found !
        pVatAccId := 0;
        // 23.04.2010 ingmar; käibemaksu kontod !!!!
        pError := (pVatFlags and estbk_types._CVtmode_dontAdd) <> estbk_types._CVtmode_dontAdd;
        if (trim(Cells[CCol_ArtVATAccid, i]) <> '') then
        begin
          assert(assigned(Objects[CCol_ArtVATAccid, i]), '#6');
          pVatAccId := TAccountDataClass(Objects[CCol_ArtVATAccid, i]).FAccId;

          // 13.05.2011 Ingmar; pole mõtet Ei arvesta tüüpi kandel nõuda kontot !
          if (pVatAccId > 0) then
            pError := False;
        end;


        if pError then
        begin
          _callMsg(estbk_strmsg.SEArtVatAccIsMissing, mtError, [mbOK], 0);
          // --
          Row := i;
          Col := CCol_ArtVATAccid;
          Exit;
        end;


        // 18.08.2011 Ingmar; objektide toetus
        pObjectId := 0;
        pObjectName := '';
        if (trim(Cells[CCol_ArtObject, i]) <> '') and assigned(Objects[CCol_ArtObject, i]) then
        begin
          pObjectId := TObjectDataClass(Objects[CCol_ArtObject, i]).FObjectID;
          pObjectName := trim(Cells[CCol_ArtObject, i]);
        end;

        // kirjutame kontrollitud andmed ühisklassi ära !
        pBillLine := TvMergedBillLines.Create(pArtItemCollection);
        pBillLine.FArtId := pArtId;


        // järelikult muudetud kirjeldus !
        if trim(ansilowercase(pItemDescr)) <> trim(ansilowercase(pItemOrigDescr)) then
          pBillLine.FArtDescr := pItemDescr;
        pBillLine.FArtOrigDescr := pItemOrigDescr;




        // --------
        // kopeerime siis ka artikli info
        pBillLine.FArtSalepr := pItemSalePr;
        pBillLine.FArtPurcpr := pItemPurcPr;
        pBillLine.FArtCode := pArtCode;
        pBillLine.FArtType := pArtType;
        pBillLine.FArtPriceCalcMeth := pArtPriceCalcMeth;


        pBillLine.FUnit := pItemUnit;
        pBillLine.FAccountID := pArtAccId;
        pBillLine.FArtSpecialFlags := pArtSpecialFlags;

        pBillLine.FQty := pArtQty;
        pBillLine.FPrice := pArtPrice;
        pBillLine.FDiscount := pArtDiscount;



        // lahtriga seotud klassile otsene viitamine pole hea, mõnikord parem dubleerida asju !
        pBillLine.FVatID := pVATId;
        pBillLine.FVatPerc := pArtVatPerc;
        pBillLine.FVatLongName := pVatLongName;
        pBillLine.FVatFlags := pVatFlags;
        pBillLine.FVatAccountId := pVatAccId;


        // 23.04.2015 Ingmar;
        pBillLine.FPercFromVatPerc := pVATSumPercFromVat;


        // 27.04.2010 ingmar
        if trim(Cells[CCol_ArtVATSum, i]) = '' then
        begin
          pDummy := 0.00;
          pVatSum := 0.00;
          pArtVatNonCalcPart := 0.00;


          self.calcArtTotalPrice(pBillLine, pDummy, pVatSum, pArtVatNonCalcPart);
          pBillLine.FCalcLineVatSum := pVatSum; // siis võtame vaikimisi summa
          pBillLine.FCalcLineVatNonCalcPart := pArtVatNonCalcPart;
        end
        else
          pBillLine.FCalcLineVatSum := StrToFloatDef(Cells[CCol_ArtVATSum, i], 0);


        // 24.04.2015 Ingmar; selline jama, et autode puhul ei tohi 100% maha arvata km
        if (pVATSumPercFromVat < 100.00) then
        begin
          pDummy := 0.00;
          pVatSum := 0.00;
          pArtVatNonCalcPart := 0.00;


          self.calcArtTotalPrice(pBillLine, pDummy, pVatSum, pArtVatNonCalcPart);
          pBillLine.FCalcLineVatNonCalcPart := pArtVatNonCalcPart;
        end;



        // üldiselt mingi hetk ümber teha !
        // -- 10.01.2010 Ingmar
        pBillLine.FBillLineChanged := (TArticleDataClass(Objects[CCol_ArtCode, i]).FBillLineHash <> self.calcBillLineChgDetectHash(i));
        pBillLine.FBillLineId := TArticleDataClass(Objects[CCol_ArtCode, i]).FBillLineId;
        pBillLine.FBillLineAccRecId := TArticleDataClass(Objects[CCol_ArtCode, i]).FBillLineAccRecId;



        pBillLine.FObjectID := pObjectId;
        pBillLine.FObjectName := pObjectName;

        // -------
        Inc(pSuccess);
      end;

    Result := (pSuccess > 0);
    if not Result then
      _callMsg(estbk_strmsg.SEBillLinesAreMissing, mtError, [mbOK], 0);

  finally

    if assigned(pArtQryBk) then
    begin
      qryGetArticles.GotoBookmark(pArtQryBk);
      qryGetArticles.FreeBookmark(pArtQryBk);
    end;
    // ---
    qryGetArticles.EnableControls;
  end;
end;


// 01.01.2010 Ingmar; üldiselt teha üks funktsioon nii arvete kui pearaamatu jaoks;
// rule nr 1; kaudselt ja otseselt dubleeriv kood ei ole sobilik, aga testi ajaks võib jääda
procedure TframeBills.addNewGenLedgerMainrec(const pAccperiod: integer; const pAccDate: TDate; const pStrBillNr: AStr; const pFlags: integer; // !!!
  var pGenEntryMainRecId: integer; var pDocId: int64);
var
  //pLeaveBillOpen : Boolean;
  pAccRecDescr: AStr;
  pGenLedgerType: AStr;
  pDocTypeId: TSystemDocType;
  pOrigBillType: TBillType;
  pAccEntryNr: AStr;
begin
  // 18.07.2011 Ingmar
  if mnuNoAccRecs.Checked then
  begin
    pGenEntryMainRecId := -1;
    pDocId := -1;
    Exit; // -->
  end;


  pAccRecDescr := '';
  pOrigBillType := self.FCurrBillType;

  if self.FIsCreditBill then // järelikult kreeditarve; võtame kasutusele ka õige tüübi, muidu on tüüp siiski ostuarve / müügiarve !
    pOrigBillType := estbk_types.CB_creditInvoice;


  // vastavalt arvetüübile õige dokumendi tüüp
  case pOrigBillType of
    CB_salesInvoice:
    begin
      pDocTypeId := estbk_types._dsSaleBillDocId;
      // 07.10.2013 Ingmar
      //if self.FIsCreditBill then
      //   pGenLedgerType:=estbk_types.CAccRecIdentAsCreditBill
      //else
      pGenLedgerType := estbk_types.CAccRecIdentAsBill;

      pAccRecDescr := format(estbk_strmsg.CSSaleBillNr, [pStrBillNr]);
      // 29.02.2012 Ingmar; num. uus disain
      // MÜÜK
      pAccEntryNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', accDate.Date,
        False, estbk_types.CAccSBill_rec_nr, False);
    end;

    CB_purcInvoice:
    begin
      pDocTypeId := estbk_types._dsPurchaseBillDocId;
      pGenLedgerType := estbk_types.CAccRecIdentAsPuchBill;
      pAccRecDescr := format(estbk_strmsg.CSPurchBillNr, [pStrBillNr]);

      // OST
      // 29.02.2012 Ingmar; num. uus disain
      pAccEntryNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', accDate.Date,
        False, estbk_types.CAccPBill_rec_nr, False);

    end;

    CB_creditInvoice:
    begin
      pDocTypeId := estbk_types._dsCreditBillDocId;
      // 07.10.2013 Ingmar
      //if self.FIsCreditBill then
      pGenLedgerType := estbk_types.CAccRecIdentAsCreditBill;
      //else
      //   pGenLedgerType:=estbk_types.CAccRecIdentAsBill;
      pAccRecDescr := format(estbk_strmsg.CSCrBillNr, [pStrBillNr]);
      // CAccCBill_rec_nr
      // KREEDITARVE
      pAccEntryNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', accDate.Date,
        False, estbk_types.CAccCBill_rec_nr, False);
    end;

    CB_prepaymentInvoice:
    begin
      pDocTypeId := estbk_types._dsMemDocId;
      // 07.10.2013 Ingmar
      //if self.FIsCreditBill then
      //   pGenLedgerType:=estbk_types.CAccRecIdentAsCreditBill
      //else
      pGenLedgerType := estbk_types.CAccRecIdentAsBill;
      pAccRecDescr := format(estbk_strmsg.CSCrPrepaymentBillNr, [pStrBillNr]);

      // ETTEMAKSUARVE
      pAccEntryNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', accDate.Date,
        False, estbk_types.CAccRBill_rec_nr, False);
    end;

  end;


  //---
  pDocId := 0;
  pGenEntryMainRecId := 0;

  if not estbk_clientdatamodule.dmodule.createNewGenLedgerMainRec(pAccperiod,   // rp. period
    pAccDate,     // kande kuupäev
    pAccRecDescr, // kirjeldus pearaamatu päises
    pDocTypeId, edtBillNr.Text, // doc. nr
    pGenLedgerType, // pearaamatu kirje tüüp
    pGenEntryMainRecId, pDocId, pAccEntryNr // eelgenereeritud kande nr
    ) then
    abort; // ---
end;



// TODO ühildada eelmised kaks proc natuke liiga copy ja pasta ! Aga kiire fixi jaoks teeme hetkel nii
// 04.08.2011 Ingmar seoses probleemiga, kui võeti olemas oleva arve lahti, uuendati ntx arve kuupäev
// või kande kuupäev või arve nr, siis kannet ei uuendatud ! jäi vana kuupäev ja eelmise arve nr
procedure TframeBills.updateAccMainRec(const pAccMainRecID: integer);
var
  pOrigBillType: TBillType;
  pStrBillNr: AStr;
  pAccRecDescr: AStr;
begin

  pStrBillNr := edtBillNr.Text;
  // ---
  pOrigBillType := self.FCurrBillType;
  if self.FIsCreditBill then
    pOrigBillType := estbk_types.CB_creditInvoice;


  case pOrigBillType of
    CB_salesInvoice:
    begin
      pAccRecDescr := format(estbk_strmsg.CSSaleBillNr, [pStrBillNr]);
    end;

    CB_purcInvoice:
    begin
      pAccRecDescr := format(estbk_strmsg.CSPurchBillNr, [pStrBillNr]);
    end;

    CB_creditInvoice:
    begin
      pAccRecDescr := format(estbk_strmsg.CSCrBillNr, [pStrBillNr]);
    end;

    CB_prepaymentInvoice:
    begin
      pAccRecDescr := format(estbk_strmsg.CSCrPrepaymentBillNr, [pStrBillNr]);
    end;
  end;


  // -->
  with qryTemp, SQL do
    try
      // TODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODO
      // 05.03.2012 Ingmar
      // peame nüüd valideerima, kas antud kande nr sobib üldse sinna rp. perioodi järsku muudeti teiseks, siis peab uue kande nr omistama
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLUpdateAccRecCommonAttr);
      paramByname('id').AsInteger := pAccMainRecID;
      paramByname('transdescr').AsString := copy(pAccRecDescr, 1, 255);
      if accDate.Text <> '' then
        paramByname('transdate').AsString := datetoOdbcStr(accDate.date)
      else
        paramByname('transdate').AsString := datetoOdbcStr(billDate.date);
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      execSQL;
    finally
      Close;
      Clear;
    end;
end;

procedure TframeBills.bubbleSortBillLines(const billLines: TCollection; const bsortMode: TbSortMode = _csortByVat);
var
  cmp1, cmp2, temp: TvMergedBillLines;
  rIndex, rounds, cIndex: integer;
  done: boolean;
begin
  done := False;
  rounds := 0;
  if billLines.Count > 0 then
    while not (Done) do
    begin

      done := True;
      for rIndex := 0 to ((billLines.Count - 2) - rounds) do
      begin

        cmp1 := billLines.items[rIndex] as TvMergedBillLines;
        cmp2 := billLines.items[rIndex + 1] as TvMergedBillLines;

        case bsortMode of
          _csortByVat: if (TvMergedBillLines(cmp1).FVatPerc > TvMergedBillLines(cmp2).FVatPerc) then
            begin
              Done := False;
              // Temp:= billLines.items[Index] as TvMergedBillLines;
              // 28.01.2010 ingmar; tobe, TCollection ei võimalda ju swappi !
              cIndex := billLines.items[rIndex].Index;
              billLines.items[rIndex].Index := billLines.items[rIndex + 1].Index;
              billLines.items[rIndex + 1].Index := cIndex;
              //billLines.items[Index]:=TCollectionItem(billLines.items[Index+1]);
              //billLines.items[Index+1]:=TCollectionItem(temp);
            end;


          _csortByAcc: if (TvMergedBillLines(cmp1).FAccountID > TvMergedBillLines(cmp2).FAccountID) then
            begin
              Done := False;
              cIndex := billLines.items[rIndex].Index;
              billLines.items[rIndex].Index := billLines.items[rIndex + 1].Index;
              billLines.items[rIndex + 1].Index := cIndex;
            end;
          // ---
        end;
      end;
      Inc(Rounds);
    end;
end;


// TODO : hakata kasutama datamodule objekte !!!! koodi cleanup teha
// TODO2: ntx kui kontol on teine valuuta tuleks teha teisendus !
function TframeBills.createNewAccRec(const pAccRec: TAccoutingRec; const pAccountIdFlags: integer = 0;
  const pDoBaserecConv: boolean = True; const pReverseAccSides: boolean = True): int64;
var
  pAccountingRec: int64;
  pCurr: AStr;
  pCurrExcRate: double;
  pCurrValOvr: double;
  pRawCalcSum: double;
  pCurrId: integer;
  pConstAddNSign: boolean;
begin
  Result := 0;
  pRawCalcSum := 0;

  if mnuNoAccRecs.Checked then
    Exit;


  with self.qryGenLedgerEntrys, SQL do
  begin
    pConstAddNSign := False;

    // --
    Close;
    Clear;


    pCurrExcRate := 1; // --
    pCurrId := 0;

    pCurr := estbk_globvars.glob_baseCurrency;


    // 17.03.2010 Ingmar; spetsiaalne lipp, et summade teisendusi enam ei tehtaks, ntx ümmarduse puhul pole seda enam vaja
    if (cmbCurrencyList.ItemIndex >= 0) and pDoBaserecConv then
    begin
      pCurr := cmbCurrencyList.Items.Strings[cmbCurrencyList.ItemIndex];
      pCurrExcRate := TCurrencyObjType(cmbCurrencyList.Items.Objects[cmbCurrencyList.ItemIndex]).currVal;
      pCurrId := TCurrencyObjType(cmbCurrencyList.Items.Objects[cmbCurrencyList.ItemIndex]).id;
      //pCurrValOvr:=roundto(TCurrencyObjType(cmbCurrencyList.Items.Objects[cmbCurrencyList.itemIndex]).currVal*accRec.FAccRecSum,-2);
    end;


    // --
    add(estbk_sqlclientCollection._CSQLInsertNewAccDCRecEx);


    pAccountingRec := estbk_clientdatamodule.dmodule.qryGenLedgerAccRecId.GetNextValue;
    paramByname('id').asLargeInt := pAccountingRec;
    paramByname('accounting_register_id').AsInteger := pAccRec.regMRec;
    paramByname('account_id').AsInteger := pAccRec.accountId;

    // kande kirjeldus, tavaliselt kasutatud konto nimi
    paramByname('descr').AsString := copy(pAccRec.descr, 1, CAccDescrMaxLen);

    paramByname('rec_nr').AsInteger := pAccRec.recNr;
    paramByname('client_id').AsInteger := pAccRec.clientId;
    // 21.03.2011 Ingmar
    paramByname('tr_partner_name').AsString := '';


    paramByname('client_id').AsInteger := pAccRec.clientId;

    // ------------------------------------------------------------------------
    // kreeditarve puhul kõik vastupidine...
    // ------------------------------------------------------------------------

    if self.FIsCreditBill then
    begin

      if pReverseAccSides then
        // ka kande tunnus teistpidi keerata ! vastupidine kanne !!!!!!!!!!!!!!!!!!!
        if pAccRec.recType = estbk_types.CAccRecTypeAsCredit then
          pAccRec.recType := estbk_types.CAccRecTypeAsDebit
        else
          pAccRec.recType := estbk_types.CAccRecTypeAsCredit;

      // ---
      pRawCalcSum := abs(pAccRec.sum) * pCurrExcRate;
      paramByname('rec_sum').asCurrency := roundto(pRawCalcSum, Z2);
    end
    else
      // tavalised müügi-ostuarved
    begin
      // ---
      pRawCalcSum := pCurrExcRate * pAccRec.sum;
      paramByname('rec_sum').asCurrency := roundto(pRawCalcSum, Z2);
    end;




    // ------------
    paramByname('rec_type').AsString := pAccRec.recType;
    // ---

    paramByname('currency_id').AsInteger := pCurrId;
    paramByname('currency').AsString := pCurr;



    // NB
    if pCurr = estbk_globvars.glob_baseCurrency then
      paramByName('currency_drate_ovr').asCurrency := 1.00
    else
      paramByName('currency_drate_ovr').asCurrency := pCurrExcRate;


    pCurrValOvr := pAccRec.sum;

    // kreeditarve kanne ju pööratud !!!
    if self.FIsCreditBill then
      pCurrValOvr := abs(pCurrValOvr);


    paramByname('currency_vsum').asCurrency := pCurrValOvr; // nö summa rida originaal valuutas !!!

    paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    paramByname('status').AsString := '';



    // 12.09.2010 Ingmar
    paramByname('ref_item_type').AsString := estbk_types.CCommTypeAsBill;
    paramByname('ref_item_id').AsInteger := self.FOpenedBillMainBrec;



    paramByname('ref_payment_flag').AsString := estbk_types.SCFalseTrue[False];
    paramByname('ref_income_flag').AsString := estbk_types.SCFalseTrue[False];


    // need on lipus, mis enamasti kasutusel maksekorralduses ja laekumistes !
    paramByname('ref_prepayment_flag').AsString :=
      estbk_types.SCFalseTrue[(pAccountIdFlags and CAccountIdFlags_prepayment) = CAccountIdFlags_prepayment];

    // arvete puhul on enamasti tegemist "võlaga", keegi on kellegile "võlgu"; kahjuks kasutatakse stringi !
    // paramByname('ref_debt_flag').asString:=estbk_types.SCFalseTrue[inttostr(pAccRec.accountId)=cmbSalePuchAcc.Value];
    paramByname('ref_debt_flag').AsString := estbk_types.SCFalseTrue[(pAccountIdFlags and CAccountIdFlags_debt) = CAccountIdFlags_debt];
    paramByname('ref_tax_flag').AsString := estbk_types.SCFalseTrue[(pAccountIdFlags and CAccountIdFlags_tax) = CAccountIdFlags_tax];

    // 31.08.2011 Ingmar
    paramByname('flags').AsInteger := 0;

    paramByname('rec_changed').AsDateTime := now;
    paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
    paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
    execSQL;


    // "kontrollsummad"
    if paramByname('rec_type').AsString = estbk_types.CAccRecTypeAsDebit then
      self.FDebitSumTotal := self.FDebitSumTotal + paramByname('rec_sum').asCurrency
    else
      self.FCreditSumTotal := self.FCreditSumTotal + paramByname('rec_sum').asCurrency;



    // 18.08.2011 Ingmar; objekt ka juurde !
    if pAccRec.objectId > 0 then
    begin
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLInsertNewAccDCRecAttrb2);
      parambyname('accounting_record_id').asLargeInt := pAccountingRec;
      parambyname('attrib_type').AsString := CAttrecordObjType;
      parambyname('attrib_id').AsInteger := pAccRec.objectId;
      parambyname('attrib_val').AsInteger := 0;
      parambyname('rec_changed').AsDateTime := now;
      paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      execSQL;
    end;

    // -------
    Result := pAccountingRec;
          {$ifdef debugmode}
    FAccDebug.Add('---');
    FAccDebug.Add(' - accid ' + IntToStr(paramByname('account_id').AsInteger));
    FAccDebug.Add(' - rsum  ' + floattostr(paramByname('rec_sum').asCurrency));
    FAccDebug.Add(' - type  ' + paramByname('rec_type').AsString);
    FAccDebug.Add(' - descr ' + paramByname('descr').AsString);
          {$endif}
  end; // ---

end;

// kui on nö arveridade viimane liige antud artikli ID'ga, siis arvutame ...
function TframeBills.doPriceEq(const pCurrentBillLine: TvMergedBillLines; const pBillLines: TCollection; var pLineChgDetected: boolean): boolean;
var
  pBlItem: TvMergedBillLines;
  i: integer;
begin
  pLineChgDetected := pCurrentBillLine.FBillLineChanged;
  pBlItem := pCurrentBillLine;
  // ---
  for i := 0 to pBillLines.Count - 1 do
    if (pBillLines.items[i] as TvMergedBillLines).FArtId = pCurrentBillLine.FArtId then
    begin
      pBlItem := (pBillLines.items[i] as TvMergedBillLines);
      pLineChgDetected := pLineChgDetected or pBlItem.FBillLineChanged;
    end;

  Result := (pBlItem = pCurrentBillLine);
  if not Result then
    pLineChgDetected := False;
end;




// Hoiame lahus; ostuarve ja müügiarve osa ! Lihtsam hallata, kuigi natuke koodi dubleerimist !
// FIFO ja keskmine, üldiselt pean siin meelde jätma hinnakujunduse ning üleküsima

procedure TframeBills.setArticleQtyAndPrice(const documentId: int64; const pCurrentBillLine: TvMergedBillLines;
  const pBillLines: TCollection; const pPreSavedBill: boolean; const pBillFlags: integer);
var

  i, pInvRecId: integer;
  pInvDocRecId: integer;
  pCurrCalcPrice: double;
  pLastPurchPrice: double;
  pArtQty: double;
  pAvgPrc: double;
  pInvSrcRecId: integer;
  pLinesChg: boolean;
  pClosePreSavedBill: boolean;
  pLastArtPriceId: integer;
begin
  // hetkel veel ei toeta nö sisseostu arve eelsalvestust
  if pPreSavedBill or self.mnuNoAccRecs.Checked then // mnuNoAccRecs = ära tee kandeid st ka ei muuda me inventuuri seisusid !
    exit;


  // kaupade sisseostmisel lubada negatiivset kogust / hinda ?!?!? täpsustada, hetkel ei luba !
  // 11.02.2010 Ingmar;
  // TEENUSE / KASUTAJA ARTIKLI puhul mitte muuta ! ülejäänutel alati olemas laoarvestus !

  if (pCurrentBillLine.FArtID > 0) and (pos(estbk_types._CItemAsService, pCurrentBillLine.FArtType) = 0) and
    (pos(estbk_types._CItemAsUsrDefined, pCurrentBillLine.FArtType) = 0) and (pCurrentBillLine.FArtSpecialFlags = 0) then
    //(pCurrentBillLine.FPrice>0) and
    //(pCurrentBillLine.FQty>0) then
    with qryTemp, SQL do
      try

        pLastArtPriceId := 0;
        pLinesChg := False;
        // pole veel viimane element, lahkume areenilt !
        if not self.doPriceEq(pCurrentBillLine, pBillLines, pLinesChg) then
          Exit;

        // viimase rea hind !
        pCurrCalcPrice := pCurrentBillLine.FPrice;
        pArtQty := 0;

        // -- lööme kogused kokku !
        for  i := 0 to pBillLines.Count - 1 do
          with (pBillLines.items[i] as TvMergedBillLines) do
            if (FArtId = pCurrentBillLine.FArtID) then
            begin
              pArtQty := pArtQty + FQty; // kõik tooted kokku, millel sama ID !
              pAvgPrc := pAvgPrc + FQty * FPrice;
            end;


        // vaatame, kas artiklil on nö keskmise hinna arvutamise lipp küljes...
        // CArtPriceCalcTypeAvarage = 'A';
        // CArtPriceCalcTypeFIFO    = 'F';
        if AnsiUpperCase(pCurrentBillLine.FArtPriceCalcMeth) = estbk_types.CArtPriceCalcTypeAvarage then
          pCurrCalcPrice := (pAvgPrc / pArtQty);


        // LÕPLIK SUMMA BAASVALUUTASSE !!!
        pCurrCalcPrice := roundto(pCurrCalcPrice * self.getSelectedCurrExcRate, Z2);
        //assert(FArtId>0);
        // --

        // vaatame, kas artkli hinna kirjelduse kirje loodud !!!
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLGetLastActArticlePrice);
        parambyname('article_id').AsInteger := pCurrentBillLine.FArtId;
        parambyname('type_').AsString := estbk_types._CArtPurchPrice;
        Open;

        // --
        pLastArtPriceId := FieldByName('id').AsInteger;
        pLastPurchPrice := FieldByName('price').asCurrency;


        // # pole enam viimane kehtiv hind, moodustame uue !!
        // if (pArtPriceId=0) or (pCurrPrice<>pBillLine.FArtPurcpr) then
        pClosePreSavedBill := ((pBillFlags and CBillLeaveOpenFlag) = CBillLeaveOpenFlag); // järelikult checkboxist avatud lipp eemaldatud !
        if pClosePreSavedBill or (pLastArtPriceId = 0) or (pCurrCalcPrice <> pLastPurchPrice) then
        begin
          // -- "tühistame" eelmise hinna
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLUpdateArticlePrice1);
          parambyname('ends').AsDateTime := date - 1;
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          parambyname('article_id').AsInteger := pCurrentBillLine.FArtId;
          parambyname('type_').AsString := estbk_types._CArtPurchPrice;
          execSQL;



          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLInsertArticlePrice);

          // lisame uue hinna
          pLastArtPriceId := estbk_clientdatamodule.dmodule.qryArticlePriceSeq.GetNextValue;
          parambyname('id').AsInteger := pLastArtPriceId;
          parambyname('article_id').AsInteger := pCurrentBillLine.FArtId;
          parambyname('price').asCurrency := pCurrCalcPrice;
          parambyname('discount_perc').AsFloat := 0;
          parambyname('begins').AsDateTime := date();
          parambyname('ends').Value := null;
          parambyname('type_').AsString := estbk_types._CArtPurchPrice;
          parambyname('prsource').AsString := estbk_types._CArtPriceChangeSrcBill;
          parambyname('warehouse_id').AsInteger := self.FWarehouseId;
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          parambyname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;
        end; // -- END



        // PEAME INVENTUURIS KA KOGUSEID MUUTMA
        // # kysime artikli inventuuri baaskirje id !
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLArtSelectInv);
        parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
        parambyname('warehouse_id').AsInteger := self.FWarehouseId;
        parambyname('article_id').AsInteger := pCurrentBillLine.FArtId;
        Open;
        pInvRecId := -1;

        if not EOF then
          pInvRecId := FieldByName('id').AsInteger
        else
        begin
          pInvRecId := estbk_clientdatamodule.dmodule.qryInventorySeq.GetNextValue;
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLArtInventory);
          parambyname('id').AsInteger := pInvRecId;
          parambyname('warehouse_id').AsInteger := self.FWarehouseId;
          parambyname('article_id').AsInteger := pCurrentBillLine.FArtId;

          // pole mõtet fikseerida !!! kui siis teha trigeriga !!!! inventory_documents pealt
          parambyname('current_quantity').AsFloat := 0;
          // -----------
          parambyname('status').AsString := ''; // OK
          parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          parambyname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;
        end; // ---




        // - uus arve; lisame dokumendi, mis viitab liikumisele
        if self.FNewBill or pClosePreSavedBill then
        begin
          // --- paneme kirjelduse; saabus nii ja niipalju tooteid !
          pInvDocRecId := estbk_clientdatamodule.dmodule.qryInventoryDocIdSeq.GetNextValue;

          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLArtInventoryDoc);
          parambyname('id').AsInteger := pInvDocRecId;
          parambyname('inventory_id').AsInteger := pInvRecId;
          parambyname('price').asCurrency := pCurrCalcPrice;
          parambyname('document_id').asLargeInt := documentId;
          // uus kogus ka peale !
          parambyname('quantity').AsFloat := pArtQty; // +
          parambyname('status').AsString := ''; // OK
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          parambyname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;
        end
        else
          // arve lihtsalt avati vöi tehti kreeditarve, peame muutma inventuuri dokumenti !
          // if pCurrentBillLine.FBillLineChanged then 23.03.2010 Ingmar ohutum alati uuendada mingit probleemi sellest ei teki !
        begin
          // --
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLSelectInvDocId);
          parambyname('inventory_id').AsInteger := pInvRecId;
          parambyname('document_id').AsInteger := documentId;
          Open;
          assert(not EOF, '#8');
          pInvSrcRecId := FieldByName('id').AsInteger;

          // uuendame siis vastavalt, kas hinda vöi kogust !!!
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLArtUpdtInvDoc);
          paramByname('price').asCurrency := pCurrCalcPrice;
          paramByname('quantity').AsFloat := pArtQty;
          paramByname('status').AsString := '';
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByname('id').AsInteger := pInvSrcRecId;
          execSQL;
        end;
        // ---------
      finally
        Close;
        Clear;
      end; // --
end;



// MÜÜK !!!
procedure TframeBills.salesChangeArticleQty(const documentId: int64; const pCurrentBillLine: TvMergedBillLines;
  const pBillLines: TCollection; const pBookArticles: boolean);

var
  pInvId, pInvDocDataId, i, pInvDocRecId: integer;
  pInvDRStatus: AStr;
  pCurrAmount, pQty: double;
  pLinesChg: boolean;
begin

  if self.mnuNoAccRecs.Checked then // mnuNoAccRecs = ära tee kandeid st ka ei muuda me inventuuri seisusid !
    Exit;


  // 14.01.2010 Ingmar; K mainis sellist asja, et on vabatekstiga rida, kus artiklit pole valitud !
  // 11.02.2010 Ingmar; ainult toodete puhul muuta laoseisu !!!
  if (pCurrentBillLine.FArtId > 0) and (pos(estbk_types._CItemAsService, pCurrentBillLine.FArtType) = 0) and
    (pos(estbk_types._CItemAsUsrDefined, pCurrentBillLine.FArtType) = 0) and
    // 02.09.2011 Ingmar; ka kasutaja artikli puhul ei tohi nõua laoarvestust !
    (pCurrentBillLine.FArtSpecialFlags = 0) then
    with qryTemp, SQL do
      try

        pLinesChg := False;
        // pole veel viimane element, lahkume areenilt !
        if not self.doPriceEq(pCurrentBillLine, pBillLines, pLinesChg) then
          Exit;


        // esmalt kontrollime, kas selle artikli liikumist on juba kajastatud
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLArtSelectInv);
        parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
        parambyname('warehouse_id').AsInteger := self.FWarehouseId;
        parambyname('article_id').AsInteger := pCurrentBillLine.FArtId;
        Open;



        // ostuarvega tekib artikkel; või tavaline lao algseisu dokument !!!!
        // kas artikkel laos on üldse kirjeldatud; vähetõenäoline viga, aga parem karta...kui ümber teha asju...
        if EOF then
          raise Exception.CreateFmt(estbk_strmsg.SEArtNotFoundInWareHouse, [pCurrentBillLine.FArtCode]);



        // inventuuri põhikirje id
        pCurrAmount := FieldByName('current_quantity').AsFloat;
        pInvId := FieldByName('id').AsInteger;

        // järsku on meil juba antud toote broneering peal; või arve avati uuesti
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLSelectInvDocId);
        parambyname('inventory_id').AsInteger := pInvId;
        parambyname('document_id').asLargeInt := documentId;
        Open;

        pInvDocDataId := FieldByName('id').AsInteger;
        pInvDRStatus := FieldByName('status').AsString;


        // liidame kogused kokku !
        pQty := 0;

        for i := 0 to pBillLines.Count - 1 do
          if TvMergedBillLines(pBillLines.items[i]).FArtId = pCurrentBillLine.FArtId then
            pQty := pQty + TvMergedBillLines(pBillLines.items[i]).FQty;


        // antud dokumendiga müügiliikumist pole veel kirjeldatud
        if pInvDocDataId = 0 then
        begin
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLArtInventoryDoc);
          pInvDocRecId := estbk_clientdatamodule.dmodule.qryInventoryDocIdSeq.GetNextValue;

          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLArtInventoryDoc);
          parambyname('id').AsInteger := pInvDocRecId;
          parambyname('inventory_id').AsInteger := pInvId;
          // antud hinnakomponent võtta arveridadelt, sest müügihinna arvutamine siin ei anna midagi !
          parambyname('price').AsInteger := 0;
          parambyname('document_id').asLargeInt := documentId;


          // CB_salesInvoice
          // CB_purcInvoice
          // CB_creditInvoice
          // CB_prepaymentInvoice
          // summeeritud artiklite kogus !

          if self.FCurrBillType = CB_salesInvoice then // müües ladu ju "tühjeneb" 29.11.2010 Ingmar
            parambyname('quantity').AsFloat := -pQty
          else
            parambyname('quantity').AsFloat := pQty;


          // telliti hoopis broneering ! st arve jäi avatuks
          if pBookArticles then
            parambyname('status').AsString := estbk_types.CInvItemReserved
          else
            parambyname('status').AsString := estbk_types.CInvItemServed;
          // ---
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          parambyname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;

        end
        else
        begin
          // -- !!!

          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLArtUpdtInvDoc); // korrigeerime koguste soove !!!!!
          parambyname('quantity').AsFloat := pQty;
          parambyname('price').AsInteger := 0; // tavaliste toodete juures me seda infot ei hoia !

          if pBookArticles then
            parambyname('status').AsString := estbk_types.CInvItemReserved
          else
            parambyname('status').AsString := estbk_types.CInvItemServed;
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          parambyname('id').AsInteger := pInvDocDataId;
          execSQL;
        end;
        // ----


      finally
        Close;
        Clear;
      end;
end;



function TframeBills.billStrStatusesByFlags(const flags: integer): AStr;
begin
  Result := estbk_types.CBillStatusClosed;
  if ((flags and CBillClosedFlag) = CBillClosedFlag) or         // arve jääb nagu on as is
    (((flags and CBillLeaveOpenFlag) = CBillLeaveOpenFlag) and chkBillConfirmed.Checked) or // kinnitamata arve kinnitati !
    ((self.FNewBill) and (flags = 0)) then                   // uus arve tehtud ilma lisaparameetriteta
    Result := estbk_types.CBillStatusClosed
  else
    //if   not chkBillConfirmed.checked then  // seda avamist saab  teha vaid uue arve puhul !!!
    Result := estbk_types.CBillStatusOpen;
  //  ((flags and CBillReOpenedFlag)=CBillReOpenedFlag)  or   // taasavati; panna uuesti sulgemise tunnus !!

end;


function TframeBills.createUpdateBillMainRec(const pCreateBillRec: boolean; const pAccRecId: integer;
  const pBillMainRecId: integer; const pBillSumTotal: double; const pBillVATSumTotal: double; const pBillVATSumTotal2: double;
  const pBillRoundSum: double; const pFlags: integer): integer;
var
  i, pCurrId: integer;
  pDCAcc: integer;
  pPTerm: integer;
  pDoubl: double;
  pCurr: AStr;
  pTemp: AStr;
begin
  Result := 0;
  // läbi cached update on asju lihtsam teha
  with qryBillMainRec, SQL do
  begin
    Close;
    Clear;
    cmbSalePuchAcc.LookupSource.DataSet.locate('account_coding', cmbSalePuchAcc.Text, []);
    pDCAcc := cmbSalePuchAcc.LookupSource.DataSet.FieldByName('id').AsInteger;

    case pCreateBillRec of
      True:
      begin
        add(estbk_sqlclientCollection._SQLInsertBillMainRec);
        Result := estbk_clientdatamodule.dmodule.qryBillMainRecSeq.GetNextValue;
        paramByname('accounting_register_id').AsInteger := pAccRecId;


        if not self.FIsCreditBill then
          paramByname('bill_type').AsString := estbk_types.CBillTypeAsIdent[self.FCurrBillType] // !!! ARVE TÜÜP !
        else
          paramByname('bill_type').AsString := estbk_types.CBillTypeAsIdent[CB_creditInvoice];



        // ---
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      end;

      False:
      begin
        // 04.08.2011 Ingmar; bugi pAccRecId muutujat ei tule loodud arve puhul !
        self.updateAccMainRec(self.FOpenedBillMainAccRec);

        // ---
        Close;
        Clear;
        add(estbk_sqlclientCollection._SQLUpdateBillMainRec);
        Result := pBillMainRecId;
      end;
    end;

    // ---
    paramByname('id').AsInteger := Result;


    // paramByname('customer_id').asInteger:=strtoInt(edtContractor.text);
    paramByname('client_id').AsInteger := self.FClientData.FClientId;
    paramByname('dc_account_id').AsInteger := pDCAcc;

    paramByname('bill_number').AsString := edtBillNr.Text;
    paramByname('bill_date').AsDateTime := billDate.Date;


    //paramByname('bill_number').asString:=edtBillNr.Text;
    paramByname('credit_bill_id').AsInteger := 0;// self.FCreditBillId;
    paramByname('vat_flags').AsInteger := self.FBillVATFlags;


    paramByname('billing_addr2').AsString := '';
    // enamasti arve lisakirjeldus; vasakul alumises nurgas
    // 20.02.2012 Ingmar; see oli ära ununenud !
    pTemp := trim(copy(mmVatSpecs.Lines.Text, 1, 512));
    paramByname('descr').AsString := pTemp;


    // arve tasumise tähtaeg !!!
    paramByname('due_date').AsDateTime := dueDate.Date;


    pDoubl := strtofloatdef(edtInterestPerc.Text, -1);
    if (pDoubl < 0) then
      pDoubl := estbk_clientdatamodule.dmodule.defaultDuePerc;
    paramByname('overdue_perc').AsFloat := pDoubl;

    // 06.04.2012 Ingmar
    paramByname('ref_nr').AsString := edtRefNumber.Text;
    // ref_nr_id
    paramByname('ref_nr_id').AsInteger := self.FReferenceNrId;




    pCurrId := 0;
    pCurr := estbk_globvars.glob_baseCurrency;
    if (cmbCurrencyList.ItemIndex >= 0) then
    begin
      pCurr := cmbCurrencyList.items.Strings[cmbCurrencyList.ItemIndex];
      pCurrId := TCurrencyObjType(cmbCurrencyList.items.Objects[cmbCurrencyList.ItemIndex]).id;
    end;



    // sisuliselt mõneti "kontrollsumma"
    paramByname('totalsum').asCurrency := pBillSumTotal;
    paramByname('vatsum').asCurrency := pBillVATSumTotal;
    paramByname('vatsum2').asCurrency := pBillVATSumTotal2;
    paramByname('roundsum').asCurrency := pBillRoundSum;


    //paramByname('totalsum').asFloat:=pBillSumTotal;
    //paramByname('roundsum').asFloat:=pBillRoundSum;


    // 30.03.2011 Ingmar; natuke hack-in-dos moodi !
    if (cmbPaymentTerm.Text <> '') and (cmbPaymentTerm.ItemIndex >= 0) then
    begin
      pPTerm := PtrInt(cmbPaymentTerm.Items.Objects[cmbPaymentTerm.ItemIndex]);
      if pPTerm = High(PtrInt) + CpaymentTermAsCashPayment + 1 then
        paramByname('paymentterm').AsInteger := CpaymentTermAsCashPayment // koheselt tasuda; sularahaarve
      else
      if pPTerm = High(PtrInt) + CPaymentTermAsCreditCard + 1 then
        paramByname('paymentterm').AsInteger := CPaymentTermAsCreditCard
      else
        paramByname('paymentterm').AsInteger := pPTerm;
    end
    else
      paramByname('paymentterm').AsInteger := 0;


    // ---
    paramByname('currency').AsString := pCurr;
    paramByname('currency_id').AsInteger := pCurrId;
    paramByname('currency_drate_ovr').AsFloat := strtofloatdef(setRFloatSep(trim(pcurrVal.Caption)), 0);
    // tulevikus edit ! et saaks valuutakurssi ülekirjeldada !

    assert((paramByname('currency_drate_ovr').AsFloat > 0), '#24');


    paramByname('status').AsString := billStrStatusesByFlags(pFlags);
    paramByname('openedby').AsInteger := estbk_globvars.glob_worker_id;
    paramByname('closedby').AsInteger := estbk_globvars.glob_worker_id;



    if ((pFlags and CBillLeaveOpenFlag) = CBillLeaveOpenFlag) then
    begin
      if self.FnewBill then
      begin
        paramByname('openedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('closedby').AsInteger := 0; // !!!
      end
      else
      if chkBillConfirmed.Checked then
      begin
        paramByname('openedby').Value := null;  // !!!
        paramByname('closedby').AsInteger := estbk_globvars.glob_worker_id;
      end;
    end; // ---




    //paramByname('order_id').asInteger:=self.FOrderId;
    //paramByname('offer_id').asInteger:=self.FOfferId;
    paramByname('rec_changed').AsDateTime := now;
    paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
    execSQL;
    // ----




    // 31.01.2010 Ingmar
    // -- seome arve kreeditarvega !!!!!
    if self.FIsCreditBill and self.FNewBill then
    begin
      assert((Result > 0) and (self.FCreditBillSourceBill > 0), '#9');
      Close;
      Clear;
      add(estbk_sqlclientCollection._SQLUpdateBillCredBillLink);

      paramByname('credit_bill_id').AsInteger := Result;
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('bill_id').AsInteger := self.FCreditBillSourceBill;
      execSQL;
    end;


    // ----------------------------
  end;
end;

procedure TframeBills.calcArtTotalPrice(const pBillLine: TvMergedBillLines; var pArtPriceTotal: double; var pArtVat: double;
  var pArtVatNonCalcPart: double);
var
  pVatPercFull: double;
  pVatPercFromVat: double;
  pVatSumLeft: double;
begin

  pArtPriceTotal := 0.00;
  pArtVat := 0.00;
  pArtVatNonCalcPart := 0.00;
  pVatPercFromVat := 0.00;
  pVatSumLeft := 0.00;
  // @@

  with pbillLine do
  begin

    // ntx pole ettemaksu rida !
    if pBillLine.FArtSpecialFlags = 0 then
    begin
      case self.FCurrBillType of
        CB_salesInvoice:
        begin
          pArtPriceTotal := roundto(FQty * (FPrice - (FPrice * (FDiscount / 100))), Z2);
        end;
        CB_purcInvoice,
        CB_prepaymentInvoice:
        begin
          pArtPriceTotal := roundto(FQty * FPrice, Z2); // allahindlus ostuarvel ?!?!?!?! hetkel ei tee
        end;
      end;



      // ---
      //if not pbillLine.FVatSkip then
      // arveridade KM arvutamisel kontrollime, et pole
      // A) pöördkäibemaks

      if ((pbillLine.FVatFlags and estbk_types._CVtmode_turnover_tax) <> estbk_types._CVtmode_turnover_tax) then
      begin
        pVatPercFull := FVatPerc;

        pVatPercFromVat := pbillLine.FPercFromVatPerc;

        // summa kogu KM ulatuses
        pVatSumLeft := RoundTo(pArtPriceTotal * (pVatPercFull / 100), Z2);


        pVatPercFromVat := (pVatPercFromVat / 100) * pVatPercFull;
        pVatPercFull := pVatPercFromVat;
        pArtVat := RoundTo(pArtPriceTotal * (pVatPercFull / 100), Z2);


        pArtVatNonCalcPart := pVatSumLeft - pArtVat;
      end;
    end
    else
    // miks siin võtan lihtsalt KM rea ?!?
    if (pBillLine.FArtSpecialFlags and estbk_types.CArtSpTypeCode_PrepaymentFlag) = estbk_types.CArtSpTypeCode_PrepaymentFlag then
    begin
      pArtVat := pBillLine.FCalcLineVatSum;
      pArtPriceTotal := roundto(FQty * FPrice, Z2);
    end;
  end;
end;


// et saaksike kohe vastavalt arvetüübile vaikimisi qry KM konto
// 23.04.2010
{


K tulu 1000
K müügikäibemaks 180
D ostja võlg 1180


Kui saad ostuarve siis:
D kulu 500
D sisendkäibemaks 90
K võlg tarnijale 590


Ettemaksu arve; st spetsiaalne arvetüüp

}

function TframeBills.resolveAccName(const pAccId: integer): AStr;
var
  bpmark: TBookmark;
begin
  Result := '';
  // ---
  if qryGetAccounts.FieldByName('id').AsInteger = pAccId then
    Result := qryGetAccounts.FieldByName('account_name').AsString
  else
    try
      qryGetAccounts.DisableControls;
      bpmark := qryGetAccounts.GetBookmark;
      // --
      qryGetAccounts.First;
      if qryGetAccounts.Locate('id', integer(pAccId), []) then
        Result := qryGetAccounts.FieldByName('account_name').AsString;
    finally
      qryGetAccounts.GotoBookmark(bpmark);
      qryGetAccounts.FreeBookmark(bpmark);
      qryGetAccounts.EnableControls;
    end;
  // ---
end;

function TframeBills.getVatQryDefAccountId(): integer;
begin
  Result := 0;
  case self.FCurrBillType of
    CB_salesInvoice:
    begin
      Result := qryVat.FieldByName('vat_account_id_s').AsInteger;
    end;

    CB_prepaymentInvoice,
    CB_purcInvoice:
    begin
      Result := qryVat.FieldByName('vat_account_id_i').AsInteger;
    end;
  end;

end;

function TframeBills.switchAccRecTypes(const pAccRecType: AStr): AStr;
begin
  if pAccRecType = estbk_types.CAccRecTypeAsCredit then
    Result := estbk_types.CAccRecTypeAsDebit
  else
  if pAccRecType = estbk_types.CAccRecTypeAsDebit then
    Result := estbk_types.CAccRecTypeAsCredit;
end;

// --------------------------------------------------------------------------
// ARVERIDADE KONTEERING ILMA KM
// --------------------------------------------------------------------------

// TODO võta kasutusele funktsioon resolveAccName
procedure TframeBills.doArtAcc(const pBillLines: TCollection; const pAccMainRec: integer; const pAccPeriod: integer;
  var pAccRecNr: integer; var pArtSum: double);
var
  i, j, k: integer;
  pArtAccId: integer;
  pBillLine: TvMergedBillLines;
  pAccBookMark: TBookmark;
  pAccRec: TAccoutingRec;
  pRealPrice: double;   // ilma km'ta
  pAccTotalSum: double; // grp. summa
  pCalcVat: double;
  pSkipItem: boolean;
  pHasData: boolean;
  pObjectExists: boolean;
  pArtVatNonCalcPart: double;
begin
  pObjectExists := False;

  // 18.08.2011 Ingmar; kui on kasvõi üks rida, kus object_id olemas, siis me ei grupeeri kandeid !!!
  for i := 0 to pBillLines.Count - 1 do
  begin
    pBillLine := pBillLines.Items[i] as TvMergedBillLines;
    pObjectExists := pBillLine.FObjectId > 0;
    if pObjectExists then
      break;
  end; // --


  try
    pArtSum := 0;
    pAccRec := TAccoutingRec.Create;
    pSkipItem := False;

    // --
    pAccBookMark := qryGetAccounts.GetBookmark;
    qryGetAccounts.DisableControls;

    self.bubbleSortBillLines(pBillLines);
    i := 0;
    j := 0;
    while (j <= pBillLines.Count - 1) do
    begin
      pBillLine := pBillLines.Items[i] as TvMergedBillLines;
      pArtAccId := pBillLine.FAccountID;

      if not pObjectExists then
        while j <= pBillLines.Count - 1 do
        begin
          pBillLine := pBillLines.Items[j] as TvMergedBillLines;

          pSkipItem := (pBillLine.FArtSpecialFlags > 0);
          if (pBillLine.FAccountID <> pArtAccId) or pSkipItem then
            break;

          Inc(j);
        end
      else
        Inc(j);




      // ---
      pAccTotalSum := 0;
      pHasData := False;
      for k := i to j - 1 do
      begin
        pBillLine := pBillLines.Items[k] as TvMergedBillLines;
        if (pBillLine.FArtSpecialFlags = 0) then
        begin
          pHasData := True;
          pRealPrice := 0.00;
          pCalcVAT := 0.00;
          pArtVatNonCalcPart := 0.00;

          // TODO; auto käibemaksu osa tuleb veel teha; DONE
          self.calcArtTotalPrice(pBillLine, pRealPrice, pCalcVAT, pArtVatNonCalcPart);
          // grupisisene kogusumma
          pAccTotalSum := pAccTotalSum + pRealPrice + pArtVatNonCalcPart;
        end; // ---
      end;



      if pHasData then
      begin

        // jätame meelde artiklite kogusumma
        pArtSum := pArtSum + pAccTotalSum;
        pArtAccId := pBillLine.FAccountID;

        Inc(pAccRecNr); // #
        pAccRec.regMRec := pAccMainRec;
        //pAccRec.FAccPeriod:=pAccPeriod;
        pAccRec.recNr := pAccRecNr;
        pAccRec.clientId := 0;
        pAccRec.objectId := pBillLine.FObjectId;


        pAccRec.AccountId := pArtAccId;
        // küsime ka pika nime kande kirjeldusele
        assert(qryGetAccounts.locate('id', pArtAccId, []), '#10');

        pAccRec.descr := qryGetAccounts.FieldByName('account_name').AsString;
        pAccRec.sum := pAccTotalSum;


        // --- vastavalt arve tüübile kanderea pool !
        // pAccRec.FAccRecType:=estbk_types.CAccRecTypeAsCredit;
        case self.FCurrBillType of
          CB_salesInvoice:
          begin
            pAccRec.recType := estbk_types.CAccRecTypeAsCredit;
          end;

          CB_purcInvoice:
          begin
            pAccRec.recType := estbk_types.CAccRecTypeAsDebit;
          end;
        end;




        // kirjutame kanderead baasi !!!!!!!!!!!
        self.createNewAccRec(pAccRec);
        // ---
      end;



      // ---
      if not pSkipItem then
      begin
        i := j;
      end
      else
      begin
        i := j + 1;
        Inc(j);
      end;
    end;

    // ---
  finally

    if assigned(pAccBookMark) then
    begin
      qryGetAccounts.GotoBookmark(pAccBookMark);
      qryGetAccounts.FreeBookmark(pAccBookMark);
    end;

    // ---
    qryGetAccounts.EnableControls;
    FreeAndNil(pAccRec);
  end;
end;



procedure TframeBills.doVATAcc(const pBillLines: TCollection; const pAccMainRec: integer; const pAccPeriod: integer;
  var pAccRecNr: integer; var pVatSum: double);

// sorteerime listis ära kontode järgi
  procedure internalSortByAccount(const pBillLinesLst: TList);
  var
    cmp1, cmp2, temp: TvMergedBillLines;
    rIndex, rounds, cIndex: integer;
    done: boolean;
  begin
    done := False;
    rounds := 0;
    if pBillLinesLst.Count > 0 then
      while not (Done) do
      begin

        done := True;
        for rIndex := 0 to ((pBillLinesLst.Count - 2) - rounds) do
        begin

          cmp1 := TvMergedBillLines(pBillLinesLst.items[rIndex]);
          cmp2 := TvMergedBillLines(pBillLinesLst.items[rIndex + 1]);

          if (TvMergedBillLines(cmp1).FVatAccountId > TvMergedBillLines(cmp2).FVatAccountId) then
          begin
            Done := False;
            temp := TvMergedBillLines(pBillLinesLst.items[rIndex]);
            pBillLinesLst.items[rIndex] := pBillLinesLst.items[rIndex + 1];
            pBillLinesLst.items[rIndex + 1] := temp;
          end;
          // ---
        end;
        Inc(Rounds);
      end;
  end;

  procedure internalDoVatAccWrite(const pBillLinesLst: TList);
  var
    i, j, k: integer;
    pCurrVatAccId: integer;
    pVatID: integer;
    pVatAccId: integer;
    pCalcVAT: double;
    pBillLine: TvMergedBillLines;
    pAccRec: TAccoutingRec;
    pVatFlags: integer;
    pSkipItem: boolean;
    pHasData: boolean;
    pRevSideAcc: integer;
  begin

    try
      // 12.07.2012 Ingmar
      self.FFltDisplayAllVatItems := True;
      self.qryVat.Filtered := False;
      self.qryVat.Filtered := True;


      pAccRec := TAccoutingRec.Create;

      i := 0;
      j := 0;

      while (j <= pBillLinesLst.Count - 1) do
      begin
        pBillLine := TvMergedBillLines(pBillLinesLst.Items[i]);
        pCurrVatAccId := pBillLine.FVatAccountId;
        while j <= pBillLinesLst.Count - 1 do
        begin
          pBillLine := TvMergedBillLines(pBillLinesLst.Items[j]);


          // Ei arvesta rida pole mõtet kirjutada pearaamatusse !
          pSkipItem := (pBillLine.FArtSpecialFlags > 0) or ((pBillLine.FVatFlags and estbk_types._CVtmode_dontAdd) = estbk_types._CVtmode_dontAdd);
          if (pBillLine.FVatAccountId <> pCurrVatAccId) or pSkipItem then
            break;

          Inc(j);
        end;

        pCalcVAT := 0;
        pHasData := False;


        // nii ja nüüd summad käibemaksu ID järgi; ja tema konto järgi...
        for k := i to j - 1 do
        begin
          pBillLine := TvMergedBillLines(pBillLinesLst.Items[k]);
          if (pBillLine.FArtSpecialFlags = 0) then
          begin
            pCalcVAT := pCalcVAT + pBillLine.FCalcLineVatSum;
            pHasData := True;
          end;
        end;



        if pHasData then
        begin
          // -----------------
          // koostame kande
          pVatID := 0;
          pVatAccId := 0;

          if assigned(pBillLine) then
          begin
            pVatID := pBillLine.FVatID;
            pVatAccId := pBillLine.FVatAccountId;
          end;


          Inc(pAccRecNr); // #
          // "taasväärtustame" andmeklassi
          pAccRec.regMRec := pAccMainRec;
          //pAccRec.FAccPeriod:=pAccPeriod;


          // Otsime üles õige käibemaksukonto !
          // http://raamatupidaja.ee/155970art
          // küsida, millal sisendkäibemaksu rakendada !!!
                       {
                          vat_account_id_s  müügikäibemaks
                          vat_account_id_i  sisendkäibemaks
                          vat_account_id_p  käibemaksu ettemaks
                       }
          Assert(qryVat.locate('id', pVATid, []), '#11');

          pVatFlags := qryVat.FieldByName('vatflags').AsInteger;
          pAccRec.accountId := pVatAccId;

          if pAccRec.accountId < 1 then
            raise Exception.Create(estbk_strmsg.SEVatAccountNotSpecified);

          pAccRec.descr := qryVat.FieldByName('description').AsString;
          pAccRec.recNr := pAccRecNr;
          pAccRec.sum := pCalcVAT;


          pAccRec.clientId := FClientData.FClientId;  // ??


          // -------------------------
          // käibemaksu konteerimise pool !!!
          case self.FCurrBillType of
            CB_salesInvoice:
            begin
              pAccRec.recType := estbk_types.CAccRecTypeAsCredit;
            end;

            CB_purcInvoice,
            CB_prepaymentInvoice:
            begin
              pAccRec.recType := estbk_types.CAccRecTypeAsDebit;
            end;

          end;

          // ---------------------------------------------------------------
          // -- pearaamatu kanne !
          // ---------------------------------------------------------------

          self.createNewAccRec(pAccRec, CAccountIdFlags_tax);

          // pöördkäibemaksu vastaspool !
          if (pVatFlags and estbk_types._CVtmode_turnover_tax) = estbk_types._CVtmode_turnover_tax then
          begin
            pRevSideAcc := pAccRec.accountId;
            case FCurrBillType of
              CB_salesInvoice:
              begin
                pRevSideAcc := qryVat.FieldByName('vat_account_id_i').AsInteger;
              end;

              CB_prepaymentInvoice,
              CB_purcInvoice:
              begin
                pRevSideAcc := qryVat.FieldByName('vat_account_id_s').AsInteger;
              end;

            end;

            pAccRec.Accountid := pRevSideAcc;
            pAccRec.recType := self.switchAccRecTypes(pAccRec.recType);
            Inc(pAccRecNr); // #

            pAccRec.recNr := pAccRecNr;
            self.createNewAccRec(pAccRec, CAccountIdFlags_tax);
          end
          else
          begin
            // -- @@ret väljastame käibemaksude kogusumma, see erineb ntx arvel olevast;
            // -- pöördkäibemaksusid ei kajastata arvetel ! selletõttu eelnevat rida ei tagasta !
            pVatSum := pVatSum + pCalcVAT;
          end;
        end;


        // ---
        if not pSkipItem then
        begin
          i := j;
        end
        else
        begin
          i := j + 1;
          Inc(j);
        end;
      end;

    finally
      // 12.07.2012 Ingmar
      self.FFltDisplayAllVatItems := False;
      self.qryVat.Filtered := False;
      self.qryVat.Filtered := True;

      pAccRec.Free;
    end;
  end;

  // ----------
var
  i, j, k: integer;
  pCurrVatId: integer;
  pBillLine: TvMergedBillLines;
  pTmpList: TList;
  pVatBookMark: TBookmark;

begin

  // -----
  if (pBillLines.Count > 0) then // reserveeritud !!!!
    try
      pVatBookMark := qryVat.getBookmark;
      qryVat.DisableControls;
      // ---
      pTmpList := TList.Create;
      self.bubbleSortBillLines(pBillLines);
      i := 0;
      j := 0;

      while (j <= pBillLines.Count - 1) do
      begin
        pBillLine := pBillLines.Items[i] as TvMergedBillLines;
        pCurrVatId := pBillLine.FVatID;
        while j <= pBillLines.Count - 1 do
        begin
          pBillLine := pBillLines.Items[j] as TvMergedBillLines;
          if pBillLine.FVatID <> pCurrVatId then
            break;

          Inc(j);
        end;

        // 25.09.2010 Ingmar; bug puudus, käibemaksud tulid mitmekordselt !
        pTmpList.Clear;


        // võtame fragmendi välja
        // --- nii, käibemaksu reaga meil grupeeritud; nüüd peame omakorda veel kontode kaupa kanded grupeerima
        for k := i to j - 1 do
        begin
          pBillLine := pBillLines.Items[k] as TvMergedBillLines;
          pTmpList.Add(Pointer(pBillLine));
          //pBillInfoText.Lines.Add(inttostr(pBillLine.FVatID)+' '+floattostr(pBillLine.FVatPerc));
        end;



        // --- sorteerime ära nppd kontode järgi
        internalSortByAccount(pTmpList);
        // ---
        internalDoVatAccWrite(pTmpList);
        i := j;
        // ---
      end;

    finally
      // ---
      if assigned(pVatBookMark) then
      begin
        qryVat.gotobookMark(pVatBookMark);
        qryVat.freebookMark(pVatBookMark);
        qryVat.EnableControls;
      end;
      // ---
      FreeAndNil(pTmpList);
    end;
end;

// TODO võta kasutusele funktsioon resolveAccName
procedure TframeBills.doRoundingAcc(const pAccMainRec: integer; const pAccPeriod: integer; const pRndSum: double;
  var pAccRecNr: integer; const pAllowCurrencyConv: boolean = False // ostuarve ümmardus tuleb teisendada !
  );
var
  pAccBookMark: TBookmark;
  pSelCurrVal: double;
  pRoundSum: double;
  pAccRec: TAccoutingRec;
begin

  // ümmardus antakse ostuarvel kaasa
  // ÜMMARDUS !
  //result:=roundto(self.FDebitSumTotal-self.FCreditSumTotal,Z2);


  pRoundSum := pRndSum;
  // ---
  if (pRoundSum <> 0) then
    try
      pAccRec := TAccoutingRec.Create;

      qryGetAccounts.DisableControls;
      pAccBookMark := qryGetAccounts.GetBookmark;

      Inc(pAccRecNr); // #
      pAccRec.regMRec := pAccMainRec;
      //pAccRec.FAccPeriod:=pAccMainRec;
      pAccRec.recNr := pAccPeriod;
      pAccRec.clientId := 0;

      // peame jälle summat pöörama
      if self.FIsCreditBill then
        pRoundSum := -pRoundSum;


      if pRoundSum > 0 then
      begin
        pAccRec.accountId := _ac.sysAccountId[_accRoundCost];
        pAccRec.recType := estbk_types.CAccRecTypeAsDebit;
      end
      else
      begin
        pAccRec.accountId := _ac.sysAccountId[_accRoundRevenue];
        pAccRec.recType := estbk_types.CAccRecTypeAsCredit;
      end;



      assert(qryGetAccounts.locate('id', pAccRec.accountId, []), '#12');
      pAccRec.descr := Copy(qryGetAccounts.FieldByName('account_name').AsString, 1, CAccDescrMaxLen);

      // --- baasvaluutas !!!! kas negatiivsus lubatud !!!!!!!!!!!!!!!
      pAccRec.sum := abs(pRoundSum);

      // kanne baasi
      self.createNewAccRec(pAccRec, 0, pAllowCurrencyConv);

      // kirjutame kanderead baasi ! peame peegeldama selle summa ka arve reale !
      // kuna ümmardus on baasvaluutas ja samuti ülejäänud kande info,
      // siis peame ümmardatud osa tagasi konverteerima originaalvaluutasse

      //pSelCurrVal:=self.getSelectedCurrExcRate();
      //assert(double(pSelCurrVal)>0,'#13');
      //pRoundSum:=roundto(pRoundSum/pSelCurrVal,Z2); // ARVE'le info !
      // --------------------

    finally
      FreeAndNil(pAccRec);

      if assigned(pAccBookMark) then
      begin
        qryGetAccounts.GotoBookmark(pAccBookMark);
        qryGetAccounts.FreeBookmark(pAccBookMark);
      end;

      // ---
      qryGetAccounts.EnableControls;
    end;
end;

// TODO korrasta muutujad ära !
function TframeBills.checkForCreditBillCorr(const pAccMainRec: integer; const pAccPeriod: integer; var pSumTotal: double;
  var pAccRecNr: integer): boolean;
var
  pPaymentStatus: AStr;
  pBillType: AStr;
  pSourceBillTSum: double;
  pPrepayment: double; // antud arvega tekkinud ettemaks
  pUPrepaidSum: double; // kasutatud ettemaks
  pPaidSum: double; // --
  pCalcPrepaymentSum: double; // et palju siis ettemaksu tekkis uuesti !
  pCreditBillTotalSum: double;
  pPaidSumTotal: double;
  pTemp: double;
  ptoPay: double; // nüüd summa, mille tõstame üles ettemaksuks, kui müügiarve - kreeditarve <0
  pBillCurrencyRate: double;
  pSourceBillId, i: integer;
  pAccountId: integer;
  pSavedCurrentBillId: integer;
  // --
  pAccRec: TAccoutingRec;
  pAccRecSum: double;
begin
  Result := False;
  if self.FIsCreditBill then // kreeditarve loomisel on ikkagit viide originaalarve tüübile !
    with qryTemp, SQL do
      try

        pAccRec := TAccoutingRec.Create;
        // --
        Close;
        Clear;
        // --
        add(estbk_sqlclientcollection._SQLSelectCrBillSource);
        paramByname('credit_bill_id').AsInteger := self.FOpenedBillMainBrec;
        Open;
        assert(pos(estbk_types.CBillStatusClosed, FieldByName('status').AsString) > 0, '#27');

        pBillType := trim(FieldByName('bill_type').AsString);
        pPaymentStatus := trim(FieldByName('payment_status').AsString);
        pSourceBillId := FieldByName('source_bill_id').AsInteger;

        // ntx ettemaks tuli valuutaarve pealt, siis kandes peame seda eurodes hoidma
        pBillCurrencyRate := FieldByName('currency_drate_ovr').AsFloat;
        assert(pBillCurrencyRate > 0.00, '#28');



        // lähtearve hetke summa
        pSourceBillTSum := FieldByName('totalsum').AsFloat + FieldByName('roundsum').AsFloat + FieldByName('vatsum').AsFloat;

        pPaidSum := FieldByName('incomesum').AsFloat; // tasutud summa pank / kassa
        pPrepayment := FieldByName('prepaidsum').AsFloat;
        pUPrepaidSum := FieldByName('uprepaidsum').AsFloat; // varasemast perioodist üles jäänud ettemaks, mida nüüd arve tasumisel kasutati !


        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateBillPmtData2);

        for i := 0 to paramcount - 1 do
          params.Items[i].Value := null;
        parambyname('id').AsInteger := pSourceBillId;


        (* Astrid:

         1) Müügiarve nr 1 nagu ikka
                D Tellijad 15.- / ostjate tasumata arved
                K Tulu müügist 12,50
                K KM 2,50

         2)Laekumine nagu ikka (kui klient on jõudnud juba ära maksta)
               D Pank või Kassa 15.-
               K Tellijad 15.-

         3)Kreeditarve arvele nr 1
               K Tellijate ettemaksed 15.- / ostjate ettemaks
               D Tulu müügist 12.-
               D KM 2,50

         4) Kui klient ei ole jõudnud veel arvet ära maksta siis teen ettemaksu ulatuses arve tasumise e. arve tasumine ettemaksust (annab ette valiku olemasolevate kliendi arvetega)

               D Tellijate ettemaksed 12.-

               K Tellijad 12.-

               Kui arve on tasutud siis jääb summa ettemaksu kontole ootama, või siis teen ettemaksu kontolt tagasikande:

               D Tellijate ettemaksed 12.-

               K Pank 12.- (tagastus kliendi arveldusarvele)


        *)



        pCreditBillTotalSum := strtofloatdef(edtBillSumTotalBc.Text, Math.NaN);
        // --------
        if not Math.IsNan(pCreditBillTotalSum) and (pPaymentStatus <> '') then
        begin

          ptoPay := (pSourceBillTSum + pCreditBillTotalSum); // ehk siis uus vahe, teoorias ... ettemaks...kui arve tasutud
          if not Math.isZero(ptoPay) then
            // juhul, kui müügiarve oli tasutud ja tehti kreeditarve, siis tuleb vaadata, mis saab laekumisega...
            if ptoPay < 0.00 then
            begin
              // tegelt mida me ikka teeme kui kreeditarve on suurem kui müügiarve ?!?!?
              // märgime arve täielikult laekunuks
              // pPaymentStatus:=estbk_types.CBillPaymentOk;
              raise Exception.Create(estbk_strmsg.SECrBillSumGreaterThenSource);

            end
            else // --
            begin
              pPaidSumTotal := pPaidSum + pPrepayment + pUPrepaidSum;
              // laekunud arvesumma osas / arvega tekkinud ettemaks / eelnevatest perioodidest ära kasutatud ettemaks

              // --
              // tõstame ettemaksu üles !
              if pPaidSumTotal > ptoPay then
                try
                  pCalcPrepaymentSum := (pPaidSumTotal - ptoPay);
                  // jätame meelde kreeditarve originaal ID !
                  pSavedCurrentBillId := self.FOpenedBillMainBrec;


                  Result := True;

                  // SQL ->
                  // jätame meelde ka üles tõstetud ettemaksu summa kreeditarve juures ! nö sisemine kontroll !
                  for i := 0 to paramcount - 1 do
                    params.Items[i].Value := null;



                  // korrigeeriv tasumine siis MÜÜGI/OSTUARVE külge !
                  parambyname('crprepaidsum').AsFloat := pCalcPrepaymentSum;
                  parambyname('id').AsInteger := pSourceBillId;
                  execSQL;




                  // ja ettemaksu kandeke ka...
                  if pBillType = estbk_types._CItemPurchBill then
                  begin
                    pAccountId := _ac.sysAccountId[_accSupplPrePayment];
                    pAccRec.descr := _ac.sysAccountLongName[_accSupplPrePayment];
                    pAccRec.clientId := 0; // ettemaks tuleb firma põhiselt -> company_id
                  end
                  else
                  begin
                    pAccountId := _ac.sysAccountId[_accPrepayment];
                    pAccRec.descr := _ac.sysAccountLongName[_accPrepayment];
                    pAccRec.clientId := FClientData.FClientId;
                  end;


                  // ---
                  Inc(pAccRecNr);
                  pAccRec.regMRec := pAccMainRec;
                  pAccRec.accountId := pAccountId;
                  pAccRec.recNr := pAccRecNr;


                  if pBillType = estbk_types._CItemPurchBill then     // OSTUARVE
                    pAccRec.recType := estbk_types.CAccRecTypeAsDebit
                  else
                    pAccRec.recType := estbk_types.CAccRecTypeAsCredit;


                  pAccRec.currencyID := 0;
                  pAccRec.currencyIdentf := estbk_globvars.glob_baseCurrency;
                  pAccRec.currencyRate := 1.00;



                  pSumTotal := ptoPay; // ostjate tasumata võlasumma / hankijatele tasumata arved
                  // 09.10.2013 Ingmar
                  pAccRecSum := Math.roundto(pCalcPrepaymentSum * pBillCurrencyRate, Z2);
                  pAccRec.sum := pAccRecSum;


                  self.FOpenedBillMainBrec := pSourceBillId;
                  // -- pearaamatu kanne !

                  self.createNewAccRec(pAccRec, CAccountIdFlags_prepayment, False, False); // ettemaksu lipuke ka püsti !

                finally
                  self.FOpenedBillMainBrec := pSavedCurrentBillId;
                end;  //  else jätame kõik nii nagu oli !!!
            end;
        end;

        // ---
      finally
        FreeAndNil(pAccRec);

        Close;
        Clear;
      end;
end;


procedure TframeBills.doFinalBillAcc(const pAccMainRec: integer; const pAccPeriod: integer; const pSumTotal: double; var pAccRecNr: integer);
var
  pAccRec: TAccoutingRec;
  pAccountId: integer;

  pSumTotalCorr: double;
  pOrigBillTypeIs: TBillType; // kreeditarve puhul tuleb tüüp võtta alusarvel
  pPrepaymentTriggered: boolean; // 10.10.2013 Ingmar
begin

  // KREEDITARVE TÄIENDAV KORREKTSIOON !
  // 29.03.2011 Ingmar seoses kreeditarvega peame nö ettemaksu osa maha arvama !
  pSumTotalCorr := pSumTotal;


  // !!!
  pPrepaymentTriggered := self.checkForCreditBillCorr(pAccMainRec, pAccPeriod, pSumTotalCorr, pAccRecNr);
  // ---
  pOrigBillTypeIs := self.FCurrBillType;


  // 29.09.2010 Ingmar
  if not Math.IsZero(pSumTotal) then
    try
      pAccRec := TAccoutingRec.Create;

      // ---
      case pOrigBillTypeIs of
        // MÜÜGIARVE kanded
        CB_salesInvoice:
        begin

          if self.FOvrBuyerUnpaidBillAccId > 0 then
            pAccountId := self.FOvrBuyerUnpaidBillAccId
          else
            pAccountId := _ac.sysAccountId[_accBuyersUnpaidBills]; // ostjate laekumata arved
          //pAccRec.descr:=estbk_clientdatamodule.dmodule.sysAccountLongName[_accBuyersUnpaidBills];

          // ---
          Inc(pAccRecNr);
          pAccRec.regMRec := pAccMainRec;
          //pAccRec.FAccPeriod:=accPeriod;

          pAccRec.accountId := pAccountId;
          // 26.09.2011 Ingmar; viga pandi vale kirjeldus kui võeti teine konto !
          pAccRec.descr := self.resolveAccName(pAccountId); // järelikult otsi õige konto nimi
          pAccRec.recNr := pAccRecNr;
          pAccRec.recType := estbk_types.CAccRecTypeAsDebit;

          // tehingupartner nö
          pAccRec.clientId := FClientData.FClientId;
          pAccRec.sum := pSumTotalCorr;


          // -- pearaamatu kanne !
          self.createNewAccRec(pAccRec, CAccountIdFlags_debt);
        end;

        // OSTUARVE kanded
        CB_purcInvoice:
        begin

          if self.FOvrSupplUnpaidBillAccId > 0 then
            pAccountId := self.FOvrSupplUnpaidBillAccId
          else
            pAccountId := _ac.sysAccountId[_accSupplUnpaidBills];     // tarnijatele maksmata arved

          // ---
          Inc(pAccRecNr);

          pAccRec.regMRec := pAccMainRec;
          //pAccRec.FAccPeriod:=accPeriod;

          pAccRec.accountId := pAccountId;
          // kirjuta ikka ehtne konto nimi !
          // 26.09.2011 Ingmar
          // pAccRec.descr:=estbk_strmsg.SPurchDebt;

          pAccRec.recNr := pAccRecNr;
          pAccRec.recType := estbk_types.CAccRecTypeAsCredit;
          pAccRec.descr := self.resolveAccName(pAccountId);

          pAccRec.clientId := FClientData.FClientId;
          pAccRec.sum := pSumTotalCorr;


          // -- pearaamatu kanne !
          if not pPrepaymentTriggered then
            self.createNewAccRec(pAccRec, CAccountIdFlags_debt);
        end;
      end;

      // ---
    finally
      FreeAndNil(pAccRec);
    end;
end;

// suht palju dubleerime KM osa koodi, aga ühe proc seda teha oleks päris ebameeldiv
procedure TframeBills.doExtendedAcc(const pBillLines: TCollection; const pAccMainRec: integer; const pAccPeriod: integer;
  var pAccRecNr: integer; var pItemSum: double; var pItemVatSum: double);

// Saan ettemaksuarve nr 900676 (minu teisele osamaksele)
// D Ostu käibemaks    K KM hankijate ettemaksetelt 1550

// sorteerime listis ära kontode järgi
  procedure internalSortByAccounts(const pBillLinesLst: TList);
  var
    cmp1, cmp2, temp: TvMergedBillLines;
    rIndex, rounds, cIndex: integer;
    done: boolean;
  begin
    done := False;
    rounds := 0;
    if pBillLinesLst.Count > 0 then
      while not (Done) do
      begin

        done := True;
        for rIndex := 0 to ((pBillLinesLst.Count - 2) - rounds) do
        begin

          cmp1 := TvMergedBillLines(pBillLinesLst.items[rIndex]);
          cmp2 := TvMergedBillLines(pBillLinesLst.items[rIndex + 1]);

          if (TvMergedBillLines(cmp1).FVatAccountId > TvMergedBillLines(cmp2).FVatAccountId) then
          begin
            Done := False;
            temp := TvMergedBillLines(pBillLinesLst.items[rIndex]);
            pBillLinesLst.items[rIndex] := pBillLinesLst.items[rIndex + 1];
            pBillLinesLst.items[rIndex + 1] := temp;
          end;
          // ---
        end;
        Inc(Rounds);
      end;
  end;


  function internalBuildAccRecs(const pBillLinesLst: TList): boolean;
  var
    i, j, k: integer;
    pCurrVatAccId: integer;
    pVatID: integer;
    pVatAccId: integer;
    pCalcVAT: double; // ühe rea käibemaks
    pCalcVATSum: double; // km kogusumma
    pArtSum: double;
    pBillLine: TvMergedBillLines;
    pAccRec: TAccoutingRec;
    pVatFlags: integer;
    pAccId: integer;
    pArtVatNonCalcPart: double;

  begin

    try
      pAccRec := TAccoutingRec.Create;
      Result := False;
      i := 0;
      j := 0;

      while (j <= pBillLinesLst.Count - 1) do
      begin
        pBillLine := TvMergedBillLines(pBillLinesLst.Items[i]);
        pCurrVatAccId := pBillLine.FVatAccountId;
        while j <= pBillLinesLst.Count - 1 do
        begin
          pBillLine := TvMergedBillLines(pBillLinesLst.Items[j]);

          if (pBillLine.FVatAccountId <> pCurrVatAccId) then
            break;

          Inc(j);
        end;

        pCalcVATSum := 0.00; // sama kontoga ridade summa
        pCalcVAT := 0.00;

        // nii ja nüüd summad käibemaksu ID järgi; ja tema konto järgi...
        for k := i to j - 1 do
        begin
          pBillLine := TvMergedBillLines(pBillLinesLst.Items[k]);

          pArtSum := 0.00;
          pCalcVAT := 0.00;
          pArtVatNonCalcPart := 0.00;
          // TODO; auto käibemaksu osa tuleb veel teha
          self.calcArtTotalPrice(pBillLine, pArtSum, pCalcVAT, pArtVatNonCalcPart);

          pItemSum := pItemSum + pArtSum; // @@out
          pCalcVATSum := pCalcVATSum + pCalcVAT;  // käibemaksu summa antud konto piires
          Result := True;
        end;



        pItemVatSum := pItemVatSum + pCalcVATSum; // @@out

        // -----------------
        // koostame kande
        pVatID := 0;
        pVatAccId := 0;

        if assigned(pBillLine) then
        begin
          pVatID := pBillLine.FVatID;
          pVatAccId := pBillLine.FVatAccountId;
        end;

        Inc(pAccRecNr); // !!!
        pAccRec.regMRec := pAccMainRec;
        assert(qryVat.locate('id', pVATid, []), '#18');

        pVatFlags := qryVat.FieldByName('vatflags').AsInteger;
        pAccRec.accountId := pVatAccId;

        if pAccRec.accountId < 1 then
          raise Exception.Create(estbk_strmsg.SEVatAccountNotSpecified);

        pAccRec.descr := qryVat.FieldByName('description').AsString;
        pAccRec.recNr := pAccRecNr;
        pAccRec.sum := pCalcVATSum;

        pAccRec.clientId := FClientData.FClientId;  // ??



        // käibemaksu konteeringu pool !!!
        case self.FCurrBillType of
          CB_salesInvoice,
          CB_purcInvoice:
          begin
            pAccRec.recType := estbk_types.CAccRecTypeAsCredit;
          end;

          CB_prepaymentInvoice:
          begin
            pAccRec.recType := estbk_types.CAccRecTypeAsDebit;
          end;

        end;



               { kanne ettemaksuarve puhul
               Saan ettemaksuarve nr 900676 (minu teisele osamaksele)
               D Ostu käibemaks    K KM hankijate ettemaksetelt
               }



        self.createNewAccRec(pAccRec, CAccountIdFlags_tax);

        // kusjuures kasutame ära sama kande kirjet !!!
        case self.FCurrBillType of
          CB_salesInvoice:
          begin
            pAccId := _ac.sysAccountId[estbk_types._accBuyerPrepaymentVat];
            pAccRec.recType := estbk_types.CAccRecTypeAsDebit;
          end;

          CB_purcInvoice:
          begin
            pAccId := _ac.sysAccountId[estbk_types._accSupplPrepaymentVat];
            pAccRec.recType := estbk_types.CAccRecTypeAsDebit;
          end;

          CB_prepaymentInvoice:
          begin
            pAccId := strtointdef(cmbSalePuchAcc.Value, 0);
            if pAccId = 0 then
              pAccId := _ac.sysAccountId[estbk_types._accSupplPrepaymentVat];

            // D Ostu käibemaks K KM hankijatele ettemaksetelt 1550
            pAccRec.recType := estbk_types.CAccRecTypeAsCredit;
          end;
        end;




        // 21.07.2011 Ingmar; mõistlikum viga ! assert ei ütle just kasutajale eriti palju !
        if not qryGetAccounts.Locate('id', pAccId, []) then
          raise Exception.Create(estbk_strmsg.SEPrepaymentVATAccountNotDefined);


        //assert(qryGetAccounts.Locate('id',pAccId,[]),'#17');
        pAccRec.descr := qryGetAccounts.FieldByName('account_name').AsString;

        // K KM hankijate ettemaksetelt või D KM hankijate ettemaksetelt; sõltub kontekstist
        // #
        Inc(pAccRecNr);
        pAccRec.regMRec := pAccMainRec;
        pAccRec.recNr := pAccRecNr;


        if assigned(self.FClientData) then
          pAccRec.clientId := self.FClientData.FClientId
        else
          pAccRec.clientId := 0;


        pAccRec.accountId := pAccId;
        pAccRec.sum := pCalcVATSum;


        // --- kirjutame ära käibemaksu vastaspoole
        self.createNewAccRec(pAccRec, CAccountIdFlags_tax);

        // ...ja liigume edasi
        i := j;
      end;
      // ---
    finally
      pAccRec.Free;
    end;
  end;

{
Ettemakse kokku kandmine ostuarvega
D Hankijatele võlg    K Ettemaksed hankijatele         18600
D KM hankijate ettemaksetelt  K ostu käibemaks      3100
}

  procedure internalDoPrepaymentAccounting(const pTotalSum: double);
  var
    pAccRec: TAccoutingRec;
    pDebitAccId: integer;
    pCreditAccId: integer;
  begin
    if FCurrBillType in [CB_salesInvoice, CB_purcInvoice] then
      try
        pAccRec := TAccoutingRec.Create;
        pAccRec.recType := estbk_types.CAccRecTypeAsDebit;

        case self.FCurrBillType of
          CB_purcInvoice:
          begin
            pDebitAccId := _ac.sysAccountId[estbk_types._accSupplUnpaidBills];
            pCreditAccId := _ac.sysAccountId[estbk_types._accSupplPrePayment];
          end;

          CB_salesInvoice:
          begin
            pDebitAccId := _ac.sysAccountId[estbk_types._accBuyersUnpaidBills];
            pCreditAccId := _ac.sysAccountId[estbk_types._accPrepayment];
          end;
        end;



        Inc(pAccRecNr);
        // kirjutame esmalt deebet poole
        assert(qryGetAccounts.Locate('id', pDebitAccId, []), '#19');
        pAccRec.accountId := pDebitAccId;
        pAccRec.recType := estbk_types.CAccRecTypeAsDebit;

        pAccRec.descr := qryGetAccounts.FieldByName('account_name').AsString;
        pAccRec.regMRec := pAccMainRec;
        pAccRec.recNr := pAccRecNr;

        if assigned(self.FClientData) then
          pAccRec.clientId := self.FClientData.FClientId
        else
          pAccRec.clientId := 0;
        pAccRec.sum := pTotalSum;

        self.createNewAccRec(pAccRec, CAccountIdFlags_debt);


        // ei saa me ilma kreedit pooleta
        Inc(pAccRecNr);
        // ---
        // 21.07.2011 Ingmar; panin mõistlikuma vea !
        // assert(qryGetAccounts.Locate('id',pCreditAccId,[]),'#20');
        if not qryGetAccounts.Locate('id', pCreditAccId, []) then
          raise Exception.Create(estbk_strmsg.SEPrepaymentAccountNotDefined);


        pAccRec.accountId := pCreditAccId;
        pAccRec.recType := estbk_types.CAccRecTypeAsCredit;

        pAccRec.descr := qryGetAccounts.FieldByName('account_name').AsString;
        pAccRec.regMRec := pAccMainRec;
        pAccRec.recNr := pAccRecNr;

        if assigned(self.FClientData) then
          pAccRec.clientId := self.FClientData.FClientId
        else
          pAccRec.clientId := 0;
        pAccRec.sum := pTotalSum;

        self.createNewAccRec(pAccRec, CAccountIdFlags_prepayment);


      finally
        FreeAndNil(pAccRec);
      end;
    // ---
  end;

var
  i, j, k: integer;
  pCurrVatId: integer;
  pBillLine: TvMergedBillLines;
  pAccRec: TAccoutingRec;
  pCalcVat: double;
  pVatBookMark: TBookmark;
  pAccBookmark: TBookmark;
  pTmpSelect: TList; //  paneme read nimistusse, et ei peaks igakord eraldi skänneerima
  pTmpVatSelect: TList;
  pRez: boolean;
begin

  pAccRec := nil;
  pVatBookMark := nil;
  pAccBookmark := nil;
  pItemSum := 0;
  pItemVatSum := 0;
  pRez := False;

  // ---
  try
    pTmpSelect := TList.Create; // vahepuhver, collection ei sobi selleks
    pTmpVatSelect := TList.Create;

    pVatBookMark := qryVat.getBookmark;
    qryVat.DisableControls;


    pAccBookmark := qryGetAccounts.GetBookmark;
    qryGetAccounts.DisableControls;


    // sorteerime nagu juba tavaks, miskit ei juhtu KM järgi, kogu collection
    self.bubbleSortBillLines(pBillLines);


    // kuna vaja mitu korda skännida, siis paneme valitud kirjed eraldi tlist nimistusse !!!
    for  i := 0 to pBillLines.Count - 1 do
    begin
      pBillLine := pBillLines.Items[i] as TvMergedBillLines;
      if (pBillLine.FArtSpecialFlags and estbk_types.CArtSpTypeCode_PrepaymentFlag) = estbk_types.CArtSpTypeCode_PrepaymentFlag then
        pTmpSelect.add(pBillLine);
    end;


    // pole midagi põnevat...nägemist
    if pTmpSelect.Count = 0 then
      exit;


    i := 0;
    j := 0;

    while (j <= pTmpSelect.Count - 1) do
    begin
      pBillLine := TvMergedBillLines(pTmpSelect.Items[i]);
      pCurrVatId := pBillLine.FVatID;
      while j <= pTmpSelect.Count - 1 do
      begin
        pBillLine := TvMergedBillLines(pTmpSelect.Items[j]);
        if pBillLine.FVatID <> pCurrVatId then
          break;

        Inc(j);
      end;

      pTmpVatSelect.Clear;
      // --- nii, käibemaksu reaga meil grupeeritud; nüüd peame omakorda veel kontode kaupa kanded grupeerima
      for k := i to j - 1 do
      begin
        pBillLine := TvMergedBillLines(pTmpSelect.Items[k]);
        pTmpVatSelect.Add(Pointer(pBillLine));
        //pBillInfoText.Lines.Add(inttostr(pBillLine.FVatID)+' '+floattostr(pBillLine.FVatPerc));
      end;



      // --- sorteerime ära nüüd kontode järgi
      internalSortByAccounts(pTmpVatSelect);
      // ---
      pRez := internalBuildAccRecs(pTmpVatSelect) or pRez;
      i := j;
      // ---
    end;


    // kas vajame ettemaksu märkimise kannet !
    if pRez then
      internalDoPrepaymentAccounting(pItemSum);

    // ---
  finally

    if assigned(pAccBookmark) then
    begin
      qryGetAccounts.GotoBookmark(pAccBookmark);
      qryGetAccounts.FreeBookmark(pAccBookmark);
    end;

    if assigned(pVatBookMark) then
    begin
      qryVat.GotoBookmark(pVatBookMark);
      qryVat.FreeBookmark(pVatBookMark);
    end;


    qryGetAccounts.EnableControls;
    qryVat.EnableControls;

    if assigned(pAccRec) then
      FreeAndNil(pAccRec);

    if assigned(pTmpSelect) then
      FreeAndNil(pTmpSelect);

    if assigned(pTmpVatSelect) then
      FreeAndNil(pTmpVatSelect);
  end; // ---
end;


// tagastab mitu eelsalvestatud kirjet kustutati
function TframeBills.doBillLineDelete: integer;
var
  i: integer;
  pRawArticleCls: TArticleDataClass;
begin
  Result := 0;
  // ---------------------------------------------------------------------------
  // kustutame arve ridade kirjed
  // ---------------------------------------------------------------------------

  for i := 0 to self.FDeletedBillLines.Count - 1 do
  begin

    pRawArticleCls := TArticleDataClass(self.FDeletedBillLines.items[i]);

    if pRawArticleCls.FBillLineId > 0 then // on juba varasemalt salvestatud
      with qryBillMainRec, SQL do
      begin

        // -- kas kustutati juba salvestatud rida !
        Inc(Result);


        // --
        Close;
        Clear;
        add(estbk_sqlclientCollection._SQLDeleteBillLine);
        paramByname('bill_lineid').asLargeInt := pRawArticleCls.FBillLineId;
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
        execSQL;


        if pRawArticleCls.FArtInventoryId > 0 then
        begin
          // --- vabastame arvega esitatud kogused; eeldusel, et tooted ka tagastati; seda kohta peab täpsustama !
          Close;
          Clear;
          add(estbk_sqlclientCollection._SQLArtUpdtInvDoc2);
          paramByname('quantity').AsFloat := pRawArticleCls.FArtCurrentQty; // - võtame koguse maha !
          //paramByname('article_price_id').asInteger:=0;
          paramByname('price').AsInteger := 0;
          paramByname('status').Value := null; // 0 ? siis panna staatus D ?
          paramByname('rec_changed').AsDateTime := now;
          paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByname('inventory_id').AsInteger := pRawArticleCls.FArtInventoryId;
          execSQL;
        end;
        // ---
      end;
  end;
end;

// kui tellimuse ID olemas meil, siis kirjutame ka tellimuse ajaloo jaoks andmed
procedure TframeBills.doOrderBillingDataWrite;
begin
  if self.FOrderId > 0 then
    with qryTemp, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLInsertOrderBillingDataEx);
        paramByname('order_id').AsInteger := self.FOrderId;
        paramByname('item_type').AsString := estbk_types.CCommTypeAsBill;
        paramByname('item_id').AsInteger := self.FOpenedBillMainBrec;
        paramByname('status').AsString := '';
        execSQL;
      finally
        Close;
        Clear;
      end;
end;


procedure TframeBills.cancelOrderBillingData;
begin
  if self.FOrderId > 0 then
    with qryTemp, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateOrderBillingData);
        paramByname('order_id').AsInteger := self.FOrderId;
        paramByname('item_type').AsString := estbk_types.CCommTypeAsBill;
        paramByname('item_id').AsInteger := self.FOpenedBillMainBrec;
        paramByname('status').AsString := estbk_types.CRecIsCanceled;
        execSQL;
      finally
        Close;
        Clear;
      end;
end;


// eemaldame kreeditarvega üles tõstetud ettemaksu osa !
procedure TframeBills.crBillRemovePrepaymentRec;
var
  pSourceBillId: integer;
begin
  if self.FIsCreditBill then
    with qryTemp, SQL do
      try
        // leiame üles nö lähtearve !
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLSelectCrBillSource);
        paramByname('credit_bill_id').AsInteger := self.FOpenedBillMainBrec;
        Open;

        pSourceBillId := FieldByName('source_bill_id').AsInteger;
        assert(pSourceBillId > 0, '#29');

        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateCrBillRaisedPrepaymentRec);
        paramByname('id').AsInteger := pSourceBillId;
        paramByname('crprepaidsum').AsFloat := 0.00;
        execSQL;

      finally
        Close;
        Clear;
      end;
end;

// TODO: tükelda protseduur väiksemaks, kiire arendamise faasis muutus liiga kohmakaks
procedure TframeBills.manageBillLinesAndGenLedgerEntrys(const accperiod: integer; const accMainRec: integer;
  const pFlags: integer; const documentId: int64; const billMainRec: integer; const billLines: TCollection);
const
  CDiffRange = 0.0000000001;

var
  i, j, pAccRecNr: integer;
  pBillLineId: int64;
  pCalcVAT: double;
  pGenDescr: AStr;
  pCurrency: AStr;
  pBillHdrChanged: boolean;
  pClosePreBuildBill: boolean;

  // toodete hinnad + käibemaks (+/-) ümmardus
  pRealPrice: double;
  pSum: double;
  pSumAll: double;
  pPrpVATSum: double; // ettemaksude kanderea summa
  pVATSum: double; // see summa ei sisalda pöördkäibemaksu summat !
  pVATSumAll: double; // ka pöördkäibemaksud
  //pCurrencyRate   : Double;
  pRoundSum: double;

  pAccSumDiffM: currency;

  pAccountId: integer;
  pPurcAccountId: integer;

  pAccRec: TAccoutingRec;
  pBillLine: TvMergedBillLines;

  pNewRecords: integer;
  pChangedRecords: integer;
  pReCreateBillLines: boolean;
  //pIsCashRegisterPmtTerm : Boolean;
  pCreateAccEntrys: boolean; // kas pearaamatusse tekitame kirjed
  pTemp: AStr;
  pDummy: double;
  pCurrSum: double;
  pCalcSum: double;
begin

  // ---
  try
    pTemp := '';
    pAccRec := TAccoutingRec.Create;



    // 15.09.2010 Ingmar
    // ümmardamise summa tuleb võtta ümardamise lahtrist; ostuarvel on ümmardus käsitsi sisestatav; kreeditarve /
    pRoundSum := 0;
    if not (self.FCurrBillType in [CB_salesInvoice, CB_prepaymentInvoice]) then
      pRoundSum := strtofloatdef(edtRoundBc.Text, 0);



    // nii kas arve jäeti lahti või sulgeti !
    if not self.FnewBill then
      pClosePreBuildBill := (((pFlags and CBillLeaveOpenFlag) = CBillLeaveOpenFlag) or ((pFlags and CBillReOpenedFlag) = CBillReOpenedFlag))
        // 11.03.2011 Ingmar; nüüd kus checkbox salvestus ka salvestab peame seda lippu jälgima !
        and chkBillConfirmed.Checked    // ***
    else
      pClosePreBuildBill := False;




    // kas arvepäis muutus ?
    pBillHdrChanged := (self.FBillHdrChkStr <> self.buildbillHdrFtrChkStr());

    pAccRecNr := 0;
    pSum := 0;
    pSumAll := 0;
    pVATSum := 0;
    pVATSumAll := 0;
    pPrpVATSum := 0;

    pCurrency := estbk_globvars.glob_baseCurrency;

    // ---
    pNewRecords := 0;
    pChangedRecords := 0;  // ***


    // ---
    // 12.09.2010 Ingmar
    pChangedRecords := Self.doBillLineDelete;



    // -- eelkontroll; muutused/lisamised
    for i := 0 to billLines.Count - 1 do
      with TvMergedBillLines(billLines.Items[i]) do
      begin
        if FBillLineId < 1 then
          Inc(pNewRecords);

        if FBillLineChanged then
          Inc(pChangedRecords);
      end;




    // (((pFlags and CBillLeaveOpenFlag)<>CBillLeaveOpenFlag) and // pole avatud arve
    // if  (FNewBill and  ((pFlags and CBillLeaveOpenFlag)=CBillLeaveOpenFlag) then // arve jäi avatuks, kandeid ei teki
    // if  (self.FOpenedBillFlags and CBillReOpenedFlag)=CBillReOpenedFlag then
    // otsustame, kas teeme arveread uuesti !

    pReCreateBillLines := not self.FNewBill and ((pNewRecords > 0) or (pChangedRecords > 0)); // ***




    // TODO: kui kusagil real muutub ühik, siis ei peaks kõike kandeid uuesti tegema !!!
    // arve ridade info muutunud;  muuta kannet !!!
    // Sellega välistame vead finantsi osas, mis võivad tekkida muutuste järgimisel


    if (accMainRec > 0) then
      if (pReCreateBillLines and ((pFlags and CBillLeaveOpenFlag) <> CBillLeaveOpenFlag)) or // kinnitamata arvel pole kandeid !
        ((self.FOpenedBillFlags and CBillReOpenedFlag) = CBillReOpenedFlag) then            // arvel võeti kinnitus maha / muudeti
        with qryBillMainRec, SQL do
        begin

          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLCancelAccRecSQL); // tühistab kõik kandekirjed
          paramByname('rec_changed').AsDateTime := now;
          paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByname('accounting_register_id').AsInteger := accMainRec;   // !
          execSQL;




          // peame ka info tellimuste registrist eemaldama
          self.cancelOrderBillingData;

          // 02.04.2011 Ingmar
          // juhul, kui tasutud arvele tehti kreeditarve, siis tõsteti ka arve juures üles ettemaks...juhul kui kreeditarve muutus väiksemaks !
          // nüüd me peame selle osa uuesti lahti võtma
          self.crBillRemovePrepaymentRec;
        end;




    // ---------------------------------------------------------------------------
    // kirjutame arveread ära !!!!!!!!!!!
    // ---------------------------------------------------------------------------
    for i := 0 to billLines.Count - 1 do
    begin

      // ------------------------------------------------------------------------
      // 03.01.2009 Ingmar;
      // kas allahindlus tuleb konteeringul ka kuidagi eraldi ära märkida
      // ------------------------------------------------------------------------


      //pAccountingRec:=0;
      pRealPrice := 0;
      pCalcVAT := 0;
      pbillLine := TvMergedBillLines(billLines.Items[i]);
      // 28.05.2010 Ingmar; me ei võta enam toote hinda toote küljest vaid arve realt !
      // Kasutaja võib seda muuta nagu käibemaksugi !

      //self.calcArtTotalPrice(pbillLine,pRealPrice,pCalcVAT);
      pRealPrice := pbillLine.FPrice;
      pRealPrice := Roundto(pbillLine.FQty * (pRealPrice - (pRealPrice * (pbillLine.FDiscount / 100))), -2);


      //(pFlags and CBillLeaveOpenFlag)<>CBillLeaveOpenFlag)

      // --- MUUDAME koguseid !
      case self.FCurrBillType of
        CB_salesInvoice:
        begin

          self.salesChangeArticleQty(documentId,
            pBillLine,
            billLines, not chkBillConfirmed.Checked);
        end;

        CB_purcInvoice:
        begin
          //pRealPrice:=roundto(FQty*FPrice,-2); // allahindlus ostuarvel ?!?!?!?! hetkel ei tee

          // 14.01.2010 Ingmar
          // avatud arve puhul ei toimu ostuarvetes mitte midagi !!!!!

          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          // uue hinna lisamine ja laoseisu muutmine
          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

          //if  not chkBillConfirmed.checked then
          //if pbillLine.FBillLineChanged or pClosePreBuildBill then
          self.setArticleQtyAndPrice(documentId,
            pBillLine,
            billLines, not chkBillConfirmed.Checked,
            pFlags);

        end;
      end;


      // 30.04.2010 Ingmar
      if (pBillLine.FVatFlags and estbk_types._CVtmode_turnover_tax) = estbk_types._CVtmode_turnover_tax then
        pCalcVAT := 0    // Arvele pöördkäibemaksu summat ei pane !!!
      else
        pCalcVAT := pBillLine.FCalcLineVatSum;

      // ---
      // TODO kaota koodi dubleerimine; miks artikli arvutust ei võiks bill_linest võtta ?
      // arvutatud artikli summa, kas poleks nagu mõttekas seda verifyCollectionis teha ! dubleerin koodi
      // 24.04.2015 Ingmar; nüüd liidame ka juurde osa, mis seoses auto km muutusega tuli, osa mida ei tohi me km maha võtta
      pSum := pRealPrice + pBillLine.FCalcLineVatNonCalcPart;

      pSumAll := pSumAll + pSum;
      pVATSum := pVATSum + pCalcVAT; // tavaline käibemaks !


      // kontrollime siiski kuvatavat summat ! ka pöördkäibemaks on siia arvestatud
      pVATSumAll := pVATSumAll + pBillLine.FCalcLineVatSum;




      // !!!
      // lisame või eemaldame vastavalt reziimile arveread !!
      if self.FNewBill or pReCreateBillLines or ((pbillLine.FBillLineId = 0) and ((pFlags and CBillLeaveOpenFlag) = CBillLeaveOpenFlag)) then
        // siiski avatud arvele pandi juurde veel mõned read !!!
        with qryBillMainRec, SQL do
        begin

          // tühistame eelmise arverea !
          // ntx kui hetke arveread midagi muudeti, siis originaalrida jäetakse alles !!! D tunnusega ning tehakse uus peale !
          if (pbillLine.FBillLineId > 0) then
          begin
            // --
            Close;
            Clear;
            add(estbk_sqlclientCollection._SQLDeleteBillLine);
            paramByname('bill_lineid').asLargeInt := pbillLine.FBillLineId;
            paramByname('rec_changed').AsDateTime := now;
            paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
            paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
            execSQL;
          end;



          // --
          // arveread paika
          Close;
          Clear;
          add(estbk_sqlclientCollection._SQLInsertBillLine);


          pBillLineId := estbk_clientdatamodule.dmodule.qryBillLineSeq.GetNextValue;
          paramByname('id').asLargeInt := pBillLineId;
          paramByname('bill_id').AsInteger := billMainRec;

          // standard toode...artikli rida...
          paramByname('linetype').AsString := 'P';
          //paramByname('rec_nr').asInteger:=i+1;
          paramByname('discount_perc').AsFloat := pbillLine.FDiscount;
          paramByname('cust_discount_id').AsInteger := 0; // reserveeritud !

          paramByname('item_id').AsInteger := pbillLine.FArtId;
          paramByname('item_price').asCurrency := pbillLine.FPrice;


          paramByname('quantity').AsFloat := pbillLine.FQty;
          paramByname('vat_id').AsInteger := pbillLine.FVatID;
          //paramByname('vat_perc').AsFloat:=pbillLine.FVatPerc;
          // 28.04.2010 ingmar
          paramByname('vat_rsum').AsCurrency := pbillLine.FCalcLineVatSum;


          // 24.04.2015 Ingmar mitu protsenti km'st tohib maha võtta
          paramByname('vat_cperc').AsCurrency := pbillLine.FPercFromVatPerc;




          //paramByname('accounting_record_id').AsLargeInt:=pAccountingRec;
          paramByname('item_account_id').AsInteger := pbillLine.FAccountID;
          // 23.04.2010 Ingamr
          paramByname('vat_account_id').AsInteger := pbillLine.FVatAccountId;
          // --- total rida on koos käibemaksuga !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! AS IS arvel
          paramByname('total').asCurrency := (pRealPrice + pCalcVAT);

          if ansilowercase(pbillLine.FArtDescr) <> ansilowercase(pbillLine.FArtOrigDescr) then
            paramByname('descr2').AsString := estbk_utilities._resolveEscapeSeq(pbillLine.FArtDescr)
          else
            paramByname('descr2').Value := null;
          paramByname('unit2').AsString := pbillLine.FUnit;
          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;

          paramByname('object_id').AsInteger := pbillLine.FObjectId;
          paramByname('status').AsString := ''; // reserveeritud
          paramByname('rec_changed').AsDateTime := now;
          paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;

        end
      else // ------------------

      // juhul, kui eelnevalt salvestatud arverida, kuid arve oli avatud, reaalseid kandeid polnud toimunud
      // sulgemisel kanderead külge !!!!

      if (((pFlags and CBillLeaveOpenFlag) = CBillLeaveOpenFlag) and (pClosePreBuildBill or pbillLine.FbillLineChanged)) then
        with qryBillMainRec, SQL do
        begin

          Close;
          Clear;
          add(estbk_sqlclientCollection._SQLUpdateAccEntBillLine);

          for j := 0 to paramcount - 1 do
            params.Items[i].Value := null;

          paramByname('id').asLargeInt := pbillLine.FBillLineId;
          //paramByname('accounting_record_id').AsLargeInt:=pAccountingRec;   // pClosePreBuildBill
          paramByname('discount_perc').AsFloat := pbillLine.FDiscount;
          paramByname('cust_discount_id').AsInteger := 0; // reserveeritud !

          paramByname('item_price').asCurrency := pbillLine.FPrice;
          paramByname('quantity').AsFloat := pbillLine.FQty; // gridist !!!
          paramByname('vat_id').AsInteger := pbillLine.FVatID;

          // 28.04.2010 ingmar
          paramByname('vat_rsum').asCurrency := pbillLine.FCalcLineVatSum;
          // 24.04.2015 Ingmar mitu protsenti km'st tohib maha võtta
          paramByname('vat_cperc').AsCurrency := pbillLine.FPercFromVatPerc;


          //paramByname('vat_perc').AsFloat:=pbillLine.FCalcLineVatSum; //pbillLine.FVatPerc;
          paramByname('item_account_id').AsInteger := pbillLine.FAccountID;
          // 23.04.2010 Ingmar
          paramByname('vat_account_id').AsInteger := pbillLine.FVatAccountId;

          // rida koos käibemaksuga !!
          paramByname('total').asCurrency := (pRealPrice + pCalcVAT);


          if ansilowercase(pbillLine.FArtDescr) <> ansilowercase(pbillLine.FArtOrigDescr) then
            paramByname('descr2').AsString := estbk_utilities._resolveEscapeSeq(pbillLine.FArtDescr)
          else
            paramByname('descr2').Value := null;
          paramByname('unit2').AsString := pbillLine.FUnit;

          paramByname('rec_changed').AsDateTime := now;
          paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;
        end;
    end; // ------ arveridade kirjutamise lõpp !




    // arve jäeti avatuks !!! finantskandeid ei tekita !
    if (((pFlags and CBillLeaveOpenFlag) = CBillLeaveOpenFlag) and not chkBillConfirmed.Checked) then
    begin

      // assert(trim(edtBillSumTotalBc.Text)=floattostr(pSumTotal));
      // meie sisemine kalkulatsioon PEAB võrdlema sisemiste arvutustega
      pTemp := format(estbk_strmsg.SEBillFatalErrSumMismatch, [trim(edtBillSumTotalBc.Text),
        format(CCurrentMoneyFmt2, [pSumAll + pVATSum + pRoundSum])]);
      assert(trim(edtBillSumTotalBc.Text) = format(CCurrentMoneyFmt2, [pSumAll + pVATSum + pRoundSum]), pTemp); // float võrdlus paha idee !


      // vatsum2 pöördkäibemaksu osa; pVATSumAll-pVATSumTotal
      if pBillHdrChanged or self.FNewBill or (pNewRecords > 0) or (pChangedRecords > 0) then
        self.createUpdateBillMainRec(False, 0, billMainRec, pSumAll, pVATSum, pVATSumAll - pVATSum, pRoundSum, pFlags); // uuendame arve aluskirjet !

      // ---
      Exit;
    end;




    // KANDED; ainult, kui kinnitatud
    if chkBillConfirmed.Checked then
    begin

      // -- vaatame, kas on vajadust muuta/luua pearaamatu kirjeid
      pCreateAccEntrys := self.FNewBill or       // uus arve koos kinnitusega
        pClosePreBuildBill or  // arve kinnitati !
        pReCreateBillLines;    // arveread muutusid ! uued kanded;


      // pVATSumAll selle sisu tuleb eelkalkulatsioonist üle kõikide ridade !!!
      if pCreateAccEntrys then
      begin

        // kirjutame ära ka info, mis seotud ntx tellimusega
        self.doOrderBillingDataWrite;

        // järjekord on siin väga tähtis !
        pSumAll := 0; // kõikide ridade summad ilma km'ta

        // ettemaksude reatüübid; siiski siin peaks
        pSum := 0;
        pPrpVATSum := 0;

        self.doExtendedAcc(billLines, accMainRec, accPeriod, pAccRecNr, pSum, pPrpVATSum);
        pSumAll := pSum;

        // -----------------------------------------------------------------
        // ARTIKLITE/RIDADE KANDED
        // -----------------------------------------------------------------
        pSum := 0; // artiklite summa
        self.doArtAcc(billLines, accMainRec, accPeriod, pAccRecNr, pSum);
        pSumAll := pSumAll + pSum;

        // -----------------------------------------------------------------
        // KÄIBEMAKSUD KANDESSE !!!
        // 03.12.2009 Ingmar; räme palavik hakkab mõtlemisele vist; üldiselt ootan generic supporti ka lazaruses
        // 2.4.0 juba vist toetab A-Z käibemaksud
        // -----------------------------------------------------------------

        pVATSum := 0; // käibemaksude osa on keerukam, siin ei piisa enam "preview" arvutustest !
        self.doVATAcc(billLines, accMainRec, accPeriod, pAccRecNr, pVATSum);



        // ---------------------------------------------------------------------------
        // LISAME vastavalt kanderead; ostjate võlgnevus meile; või meie tarnijatele !
        // ---------------------------------------------------------------------------
        // TODO viia ka eraldi protseduuridesse
        // kasutame ära tasakaalu mooduleid; FDebitSumTotal / FCreditSumTotal


        self.doFinalBillAcc(accMainRec, accPeriod, pSum + pVatSum + pRoundSum, pAccRecNr);



        // 20.01.2011 Ingmar; unise peaga kiiresti lisatud kood, optimiseeri ära, päris totakas
        if self.FCurrBillType in [CB_salesInvoice, CB_prepaymentInvoice] then
        begin
          //pCurrencyRate:=0;
          pRoundSum := 0;
          //pCurrencyRate:=strtofloatdef(setRFloatSep(trim(pcurrVal.Caption)),0);
          //pRoundSum:=(pSum+pVatSum)*pCurrencyRate;

          //if not math.IsZero(pRoundSum) then
          pRoundSum := self.FCreditSumTotal - self.FDebitSumTotal;
          pRoundSum := Math.roundto(pRoundSum, Z2);

          // ---
          // arvele ka juurde ümmardamise summa baasvaluutas
          self.doRoundingAcc(accMainRec, accPeriod, pRoundSum, pAccRecNr);
          // arve reale kandes kirjeldatud ümmardamise rida ei lase panna !
          pRoundSum := 0;
        end
        else
        begin
          // +0.05 DEEBETIS; -0.05 KREEDIT
          self.doRoundingAcc(accMainRec, accPeriod, pRoundSum, pAccRecNr, True);
        end;




        // ettemaksu KM osa me ei tohi lisada arve tavaühikutele !
        pVatSum := pVatSum + pPrpVATSum;



        // ###############################################################
        // KONTROLLIME KANNETE TASAKAALU
        // 17.03.2010 Ingmar
        // ###############################################################

        pAccSumDiffM := self.FDebitSumTotal - self.FCreditSumTotal;

      end;




      // @@@
      if not Math.SameValue(pAccSumDiffM, 0.00, CDiffRange) then // imelik, ilma selleta arvas kompilaator, et tegemist cardinaliga ?!?
        raise Exception.createFmt(estbk_strmsg.SEAccEntryUnBalanced + ' D: %.4f; C: %.4f', [self.FDebitSumTotal, self.FCreditSumTotal]);


      if self.FCurrBillType in [CB_salesInvoice, CB_prepaymentInvoice] then
      begin
        pTemp := format(estbk_strmsg.SEBillFatalErrSumMismatch, [trim(edtBillSumTotalBc.Text),
          format(CCurrentMoneyFmt2, [pSumAll + pVATSum])]);
        assert(trim(edtBillSumTotalBc.Text) = format(CCurrentMoneyFmt2, [pSumAll + pVATSum]), pTemp);
      end
      else
      begin

        // 10.08.2012 Ingmar; andis, et summad ei klapi; assert viga ja str võrdlemise loogika NO NO NO !!!
        pCurrSum := StrToFloatDef(edtBillSumTotalBc.Text, -9999999);
        pCalcSum := pSumAll + pVATSum + pRoundSum;
        if not Math.SameValue(pCurrSum, pCalcSum, CDiffRange) then // imelik, ilma selleta arvas kompilaator, et tegemist cardinaliga ?!?
          raise Exception.CreateFmt(estbk_strmsg.SEBillFatalErrSumMismatch, [trim(edtBillSumTotalBc.Text),
            format(CCurrentMoneyFmt2, [pCalcSum])]);

        //pTemp:=format(estbk_strmsg.SEBillFatalErrSumMismatch,[trim(edtBillSumTotalBc.Text),format(CCurrentMoneyFmt2,[pSumAll+pVATSum+pRoundSum])]);
        //assert(trim(edtBillSumTotalBc.Text)=format(CCurrentMoneyFmt2,[pSumAll+pVATSum+pRoundSum]),pTemp);
        // ---
      end;

    end;




    // !!!!
    // -- uuendame arve aluskirjet !!!!!!!!
    if pClosePreBuildBill or  // avatud arve suleti
      pBillHdrChanged or  // arve päis muutus
      self.FNewBill or  // uus arve
      (pNewRecords > 0) or  // lisandusid uued arveread
      (pChangedRecords > 0) or  // // muutusid arveread; ntx kustutati/muudeti
      ((pFlags and CBillReOpenedFlag) = CBillReOpenedFlag) then // arvel võeti kinnitus maha
    begin
      // pVATSumTotal=reaalselt arvestatav käibemaks
      // pVATSumAll=kõik käibemaksud, ka pöördkäibemaks
      self.createUpdateBillMainRec(False, 0, billMainRec, pSumAll, pVATSum, pVATSumAll - pVATSum, pRoundSum, pFlags);
    end;

  finally
    FreeAndNil(pAccRec);
    // -- puhastame kustutatud arveridade puhvri
    FDeletedBillLines.Clear;
  end;
end;



procedure TframeBills.changeAllBillControlStates;
begin
  //estbk_utilities.changeWCtrlEnabledStatus(grpClientData,false);
  //estbk_utilities.changeWCtrlEnabledStatus(grpBoxBill,false);
  estbk_utilities.changeWCtrlReadOnlyStatus(grpClientData, chkBillConfirmed.Checked);
  estbk_utilities.changeWCtrlReadOnlyStatus(grpBoxBill, chkBillConfirmed.Checked);
  estbk_utilities.changeWCtrlReadOnlyStatus(mmVatSpecs, chkBillConfirmed.Checked);


  // --
  estbk_utilities.changeWCtrlEnabledStatus(cmbCurrencyList, not chkBillConfirmed.Checked);
  estbk_utilities.changeWCtrlEnabledStatus(cmbPaymentTerm, not chkBillConfirmed.Checked);
end;

// 11.05.2011 Ingmar; peame kontrollima ka, kas ostuarvet pole juba salvestatud !
function TframeBills.doesBillExists: boolean;
var
  pDayBtw: integer;
begin
  Result := False;
  if (self.FCurrBillType in [CB_purcInvoice, CB_salesInvoice]) and assigned(self.FClientData) and chkBillConfirmed.Checked then
    with qryTemp, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLDoesBillExists);
        parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
        parambyname('bill_type').AsString := estbk_types.CBillTypeAsIdent[self.FCurrBillType];
        parambyname('bill_number').AsString := edtBillNr.Text;
        // 30.08.2011 Ingmar;
        parambyname('client_id').AsInteger := self.FClientData.FClientId;

        Open;
        First;
        // ---
        if not EOF and (FieldByName('id').AsInteger <> self.FOpenedBillMainBrec) then
        begin
          pDayBtw := abs(round(billDate.date - FieldByName('bill_date').AsDateTime));
          if pDayBtw < 90 then // ajast möödas vähem, kui 90 päeva !
          begin
            Result := True;
            _callMsg(format(estbk_strmsg.SEBillWithNrAlreadyExists, [edtBillNr.Text]), mtError, [mbOK], 0);
          end;

        end;


      finally
        Close;
        Clear;
      end;
end;

procedure TframeBills.correctAccrecs(const pBillMainRec: integer; const pAccMainRec: integer);
begin
  // --
  if mnuNoAccRecs.Checked and (pBillMainRec > 0) then
    with qryTemp, SQL do
      try
        // kanded on juba eelmise handleri poolt tühistatud !
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateBillAccRegID);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        paramByname('accounting_register_id').AsInteger := -1;
        paramByname('id').AsInteger := pBillMainRec;
        execSQL;

        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdCancelAccReg);
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('id').AsInteger := pAccMainRec;
        execSQL;

      finally
        Close;
        Clear;
      end;
end;

function TframeBills.saveBillData(const pChangeFocus: boolean = True): boolean;
var
  pAccPeriod: integer;
  pAccMainRec: integer;
  pBillMainRec: integer;
  pFlags: integer;
  pDocId: int64;
  pBillDate: TDate;
  pBillNr: AStr;
  pArtItemsCollection: TCollection;
  b: boolean;
  pActiveControl: TWinControl;
  pCursor: TCursor;
  pIsCashRegisterPmtTerm: boolean;
begin
  Result := False;
  lazFocusFix.Enabled := False;


  // sama numbriga ostuarve juba olemas !
  if self.doesBillExists then
    Exit;

  pActiveControl := Screen.ActiveControl;
  // --
  with estbk_clientdatamodule.dmodule do
    try

      pCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;




      assert(primConnection.InTransaction = False, '#23');
      // 27.07.2010 Ingmar; päris ebameeldiv bugi; kui oli artikli valik ja see nö jäi aktiivseks
      //  st. lookupcombo näha, siis salvestamisel tekkis juurde täiendav arverida !!!!!!!!!!!!!!
      self.FSkipLComboEvents := True;

      pArtItemsCollection := TCollection.Create(TvMergedBillLines);
      pAccPeriod := 0;
      pAccMainRec := 0;

      if self.verifyAndCreateCollection(pArtItemsCollection, pAccPeriod) then
        try

          primConnection.StartTransaction;

          self.FDebitSumTotal := 0;
          self.FCreditSumTotal := 0;


          // ---------------------------------------
          // täitsa uus arve ! üldiselt on soovitav muutmine ja nö insert alati lahus hoida

          if self.FNewBill then
          begin

            pBillDate := billDate.Date;
            pBillNr := edtBillNr.Text;
            pFlags := 0;

            if not chkBillConfirmed.Checked then
              pFlags := pFlags or CBillLeaveOpenFlag;


            // kande kuupäev on erinev !!!
            if (accDate.Text <> '') and (pBillDate <> accDate.date) then
              pBillDate := accDate.date;




            // pearaamatu kande aluskirje
            self.addNewGenLedgerMainrec(pAccPeriod, pBillDate, pBillNr, pFlags, pAccMainRec {out}, pDocId{out});

            pBillMainRec := createUpdateBillMainRec(True,       // true; uus arve kirje = result ID
              pAccMainRec, 0, 0, 0, 0, 0, pFlags);

            self.FOpenedBillMainBrec := pBillMainRec;   // omistame uue arve id !

            // 21.07.2011 Ingmar; väga tobe viga, kui miskit läheb viltu manageBillLinesAndGenLedgerEntrys;
            // siis # FOpenedBillMainBrec muutuja on omistatud, mis tekitab probleeme, sest tegelikkuses tehti kogu loole rollback !
            try
              self.manageBillLinesAndGenLedgerEntrys(pAccPeriod,
                pAccMainRec,
                pFlags,
                pDocId,
                pBillMainRec,
                pArtItemsCollection);
            except
              self.FOpenedBillMainBrec := 0;
              raise; // -->
            end;


            self.FOpenedBillMainAccRec := pAccMainRec;
            self.FOpenedBillDocId := pDocId;

          end
          else
          begin

            pBillMainRec := self.FOpenedBillMainBrec;
            pFlags := self.FOpenedBillFlags;
            pAccMainRec := self.FOpenedBillMainAccRec;
            pDocId := self.FOpenedBillDocId;



            // järelikult arve suleti...
            // 20.02.2010 Ingmar; bug; !!! kande põhirida tehakse alati; ainult kande all olevad read puuduvad !!!!
            //if  ((pFlags and CBillLeaveOpenFlag)=CBillLeaveOpenFlag) and not chkBillConfirmed.checked then
            //      self.addNewGenLedgerMainrec(pAccPeriod,pBillDate,pBillNr,pFlags,pAccMainRec {out},pDocId{out});

            self.manageBillLinesAndGenLedgerEntrys(pAccPeriod, pAccMainRec, pFlags, pDocId, pBillMainRec, pArtItemsCollection);
            // -----
          end;




          // ---
          //chkBoxCreditBill.enabled:=false;
          chkBillConfirmed.Enabled := True;
          // 11.05.2010 Ingmar
          self.changeAllBillControlStates;

          if not self.FNewBill then
            self.correctAccrecs(pBillMainRec, pAccMainRec);


          // -- 24.04.2012 Ingmar; nüüd kui salvestatakse arve ja tüüp kassa, siis avatakse ka kassa !
          if self.FNewBill and chkBillConfirmed.Checked then
          begin
            pIsCashRegisterPmtTerm := (cmbPaymentTerm.ItemIndex >= 0) and
              (PtrInt(cmbPaymentTerm.Items.Objects[cmbPaymentTerm.ItemIndex]) = High(Ptrint) + CPaymentTermAsCashPayment + 1);
            // avame kassa ...
            if pIsCashRegisterPmtTerm and assigned(onFrameDataEvent) then
              self.onFrameDataEvent(self,
                estbk_types.__frameOpenCashRegister,
                self.FClientData.FClientId,
                Pointer(self.FOpenedBillMainBrec));
          end; // -->




          // 29.05.2010 Ingmar; arve taasavamine garanteerib korrektsed andmed;
          // muidu peaks peale salvestamist hakkama lahtritele eraldi ID'sid otsima
          self.openBill(pBillMainRec);


          // --
          if primConnection.InTransaction then
            primConnection.Commit;


          // 19.05.2011 Ingmar; totakas viga, kui arvet ei salvestatud, siis järgmine kord jälle uus arve nr !
          case self.FCurrBillType of
            CB_salesInvoice: dmodule.markNumeratorValAsUsed(PtrUInt(self), CBill_doc_nr, edtBillNr.Text, billDate.Date); // müügiarve number
            CB_creditInvoice: dmodule.markNumeratorValAsUsed(PtrUInt(self), CCBill_doc_nr, edtBillNr.Text, billDate.Date); // kreediarve number
            CB_purcInvoice: ;     // unused !
            CB_prepaymentInvoice: ; // unused !
          end;



          self.btnAddFile.Enabled := True;
          self.btnEBill.Enabled := (self.FCurrBillType = CB_salesInvoice);



          // teavitame arve salvestamisest !
          if assigned(onFrameDataEvent) then
            self.onFrameDataEvent(self,
              estbk_types.__frameBillDataChanged,
              self.FOpenedBillMainBrec,
              nil);

          // salvestamine läks edukalt !
          Result := True;


          if not pChangeFocus and assigned(pActiveControl) then
            _focus(pActiveControl);



        except
          on e: Exception do
          begin
            if primConnection.InTransaction then
              try
                primConnection.Rollback;
              except
              end;

            if not (e is eabort) then
              _callMsg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);

            _focus(btnSaveBill);
          end;
          // ---
        end;

    finally
      Screen.Cursor := pCursor;
      FreeAndNil(pArtItemsCollection);
      self.FSkipLComboEvents := False;
      assert(not primConnection.InTransaction, '#25');
    end;


  // 28.09.2010 Ingmar; mingi kamm on editoriga !
  gridBillLines.Editor := gridBillLines.EditorByStyle(cbsAuto);
  gridBillLines.Enabled := True;




  // 30.03.2011 Ingmar; kreeditarve puhul ei ole võimalust uut arvet teha !!!
  if (self.FIsCreditBill) then
  begin
    btnBillNewBill.Enabled := False;
    btnBillCopy.Enabled := False;
  end
  else
  begin
    btnBillNewBill.Enabled := True;
    btnBillCopy.Enabled := True;
  end;
end;

procedure TframeBills.btnSaveBillClick(Sender: TObject);
begin
  self.saveBillData();
end;

// 29.08.2011 Ingmar; jätsin võimaluse lisakontrollideks !
function TframeBills.hasBindingsWithPaymentIncomeRec(const pPaymentStatus: AStr): boolean;
begin
  Result := pPaymentStatus <> '';
end;

procedure TframeBills.chkBillConfirmedChange(Sender: TObject);
begin

  // @@@
  // 09.10.2013 Ingmar
 {$ifdef debugmode}
  try
 {$endif}



    // vajadusel saab checkbox loogika välja uuesti võtta; st et checkbox ka salvestab !
    // saveBillData tuleb välja kommenteerida ! Loodan, et raamatupidajad jälle ümber ei mõtle !
    // 11.05.2010 Ingmar;
    // --- pole uus arve...
    if TCheckbox(Sender).Focused and (TCheckbox(Sender).Tag = -1) then
      // -1 näitab ka süsteemile, et selle elemendi enabled staatust muudetakse mujal
      try
        TCheckbox(Sender).Tag := 0;

        if not self.FNewBill then
        begin

          // ---
          if self.FCreditBillId > 0 then
          begin
            // väldime rekursiooni !
            TCheckbox(Sender).Tag := 0;
            TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;
            TCheckbox(Sender).Tag := -1;
            _callMsg(estbk_strmsg.SEBillHasCreditBill, mtError, [mbOK], 0);
            Exit;
          end;

          // 27.02.2011 Ingmar; arvel laekumine / tasumine peal EI LUBA MUUTA ! Esmalt tuleb see lahti siduda !
          if self.hasBindingsWithPaymentIncomeRec(trim(self.FPaymentStatus)) and (not self.FIsCreditBill) then
          begin
            TCheckbox(Sender).Tag := 0;
            TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;
            TCheckbox(Sender).Tag := -1;
            _callMsg(estbk_strmsg.SEBillHasPayment, mtError, [mbOK], 0);
            Exit;
          end;



          // juba kinnitatud arve / suletud; arve soovitakse taasavada !
          if ((self.FOpenedBillFlags and CBillClosedFlag) = CBillClosedFlag) and not TCheckbox(Sender).Checked then
          begin

            if _callMsg(estbk_strmsg.SConfBillChangeReq, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin

              // 27.05.2010 Ingmar; mängime ümber staatused; muidu savebilldata teostab lambi operatsioone...
              self.FOpenedBillFlags := (self.FOpenedBillFlags or CBillReOpenedFlag);
              self.FOpenedBillFlags := (self.FOpenedBillFlags and not CBillClosedFlag); // kinnitatud lipp maha



              // ---
              btnOpenClientList.Enabled := True;


              btnSaveBill.Enabled := True;
              self.FGridReadOnly := False;

              // 11.05.2010 Ingmar
              self.changeAllBillControlStates();
              self.gridColumnsROStatus(False);

              btnOpenAccEntry.Enabled := False;
              btnCreditBill.Enabled := False;
              btnIncomings.Enabled := False;

              _focus(edtBillNr);

              if not self.saveBillData(False) then
              begin
                TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;
                Exit;
              end;


              //TCheckbox(sender).Enabled:=false;
              //chkBillConfirmed.Enabled:=true;
            end
            else
              TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;

          end
          else
            // CHECKED:nüüd kinnitus = salvestus   !!!!
          begin
            // 10.03.2011 Ingmar
            //btnSaveBill.Enabled:=true;
            if self.FOpenedBillMainBrec > 0 then
              if not self.saveBillData(False) then
                TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;
          end;


         { else
         // arve kinnitati
         if ((self.FOpenedBillFlags and  CBillClosedFlag)=0) and  TCheckbox(sender).checked then
              begin
                 // 11.05.2010 Ingmar
                 self.changeAllBillControlStates();
                 self.gridColumnsROStatus(true);
                 self.FGridReadOnly:=true;
              end;}

          self.edtRoundBc.ReadOnly := not ((self.FCurrBillType = CB_purcInvoice) and (not chkBillConfirmed.Checked));
          if not self.edtRoundBc.ReadOnly then
            self.edtRoundBc.color := clWindow
          else
            self.edtRoundBc.color := cl3DLight;
          // ---
        end
        else
        // UUS ARVE !
        // CHECKED:nüüd kinnitus = salvestus   !!!!
        if TCheckbox(Sender).Checked then
        begin

          if not mnuNoAccRecs.Checked then
            assert((self.FOpenedBillMainBrec = 0) or self.FIsCreditBill, '#26');
          // kreeditarve puhul hoitakse originaalarve ID mälus; just loomisel !

          //if self.FOpenedBillMainBrec>0 then
          if not self.saveBillData(False) then
            TCheckbox(Sender).Checked := not TCheckbox(Sender).Checked;
        end;

      finally
        TCheckbox(Sender).Tag := -1;
      end;
    // @@@
    // 09.10.2013 Ingmar
 {$ifdef debugmode}
  finally
    FAccDebug.SaveToFile('C:\Deploy\debug\bill_accentrys.txt');
  end;
 {$endif}
end;

procedure TframeBills.cmbCurrencyListChange(Sender: TObject);
begin
  if TComboBox(Sender).Focused and (billDate.Text <> '') then
    self.refreshUICurrencyList(billDate.Date);
end;

procedure TframeBills.cmbPaymentTermChange(Sender: TObject);
var
  pIndex: integer;
  pDays: integer;

begin

  if not cmbPaymentTerm.Focused then
    Exit;


  if cmbPaymentTerm.Text = '' then
  begin
    dueDate.Date := billDate.Date;
    dueDate.Text := datetostr(dueDate.Date);
    Exit;
  end;


  pIndex := cmbPaymentTerm.ItemIndex;
  if pIndex >= 0 then
  begin

    if PtrInt(cmbPaymentTerm.Items.Objects[pIndex]) = High(PtrInt) then // -1 ehk sularaha arve !
      pDays := 0 // ---
    else
    begin
      pDays := PtrInt(cmbPaymentTerm.Items.Objects[pIndex]);
      // -- järelikult valik täna
      if pDays = 0 then
      begin
        dueDate.Date := now;
        Exit; // -->
      end;
    end;

    dueDate.Date := billDate.Date + pDays;

    // handler mis avab salvesta nupu, kui miskit muutus...
    self.onMiscChange(Sender);
  end;
end;


procedure TframeBills.cmbSalePuchAccChange(Sender: TObject);

begin
  with  TRxDBLookupCombo(Sender) do
    if (Text <> '') and LookupSource.DataSet.Active then
    begin
      Hint := LookupSource.DataSet.FieldByName('account_name').AsString;
    end
    else
      Hint := '';
end;

procedure TframeBills.cmbSalePuchAccClick(Sender: TObject);
begin
  // ---
  self.edtContractorEnter(Sender);
  //TRxDbLookupCombo(Sender).PopupVisible:=not TRxDbLookupCombo(Sender).PopupVisible; Ei tööta kahjuks !
end;



procedure TframeBills.cmbSalePuchAccClosePopupNotif(Sender: TObject);
begin
  estbk_utilities.rxLibAndMainMenuFix();
  lazFocusFix.Enabled := True;
end;

procedure TframeBills.cmbSalePuchAccSelect(Sender: TObject);
begin
  self.edtContractorEnter(Sender);
  // -----------------

  with  TRxDBLookupCombo(Sender) do
    if (Value <> '') and LookupSource.DataSet.Active then
    begin

      _focus(TRxDBLookupCombo(Sender));

      LookupSource.DataSet.Locate('id', Value, []);
      Text := LookupSource.DataSet.FieldByName('account_coding').AsString;


      Hint := LookupSource.DataSet.FieldByName('account_name').AsString;

      case self.FCurrBillType of
        CB_salesInvoice: self.FOvrBuyerUnpaidBillAccId := LookupSource.DataSet.FieldByName('id').AsInteger;
        CB_purcInvoice: self.FOvrSupplUnpaidBillAccId := LookupSource.DataSet.FieldByName('id').AsInteger;
      end;
      // ----
    end;

  // 12.05.2010 ingmar
  // self.OnMiscChange(nil);
end;

procedure TframeBills.dueDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
begin
  TDateEdit(Sender).Tag := 999;
  AcceptDate := ADate >= billDate.Date;
  if AcceptDate then
    self.searchDueMatchInCombo(ADate);
end;

procedure TframeBills.edtBankaccountKeyPress(Sender: TObject; var Key: char);
begin

  if key = #13 then
  begin
    if (Sender = billDate) and (TDateEdit(Sender).Text <> '') then
      self.refreshUICurrencyList(TDateEdit(Sender).date);

    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeBills.btnBillNewBillClick(Sender: TObject);
var
  pNewBillNr: AStr;
  i: integer;
begin
  if not self.loadData then
    self.loadData := True;

  if (_ac.sysAccountId[_accPurchase] < 0) or (_ac.sysAccountId[_accSale] < 0) then
  begin
    _callMsg(estbk_strmsg.SEPurchSaleAccUndef, mtError, [mbOK], 0);
    exit;
  end;


  // grpClientData.Color:=rgb(209,238,246);
  // rgb(209,238,246);
  // --
  estbk_utilities.changeWCtrlReadOnlyStatus(grpClientData, False);
  estbk_utilities.changeWCtrlReadOnlyStatus(grpBoxBill, False);
  estbk_utilities.changeWCtrlReadOnlyStatus(mmVatSpecs, False);


  estbk_utilities.changeWCtrlEnabledStatus(grpClientData, True);
  estbk_utilities.changeWCtrlEnabledStatus(grpBoxBill, True);
  estbk_utilities.changeWCtrlEnabledStatus(mmVatSpecs, True);

  estbk_utilities.changeWCtrlEnabledStatus(panelbottom, True);
  estbk_utilities.changeWCtrlEnabledStatus(cmbCurrencyList, True);
  estbk_utilities.changeWCtrlEnabledStatus(cmbPaymentTerm, True);




  self.performCleanup;
  self.FGridReadOnly := False;
  self.gridColumnsROStatus(False);


  //lblBillStatus
  //lblPmtStatus
  //edtBillStatus
  //edtIncSum


  // hiljem eemalda
  btnPrint.Enabled := False;
  btnChooseOutput.Enabled := False;



  // VISUAALI seaded vastavaks !
  // nupud paika !
  TBitBtn(Sender).Enabled := False;
  btnSaveBill.Enabled := True;
  btnOpenAccEntry.Enabled := False;
  btnCreditBill.Enabled := False;
  btnIncomings.Enabled := False;
  btnBillCopy.Enabled := False;

  //chkBoxCreditBill.enabled:=true;
  chkBillConfirmed.Enabled := True;
  btnOpenClientList.Enabled := True;


  lblWarehouse.Enabled := True;
  cmbWareHouses.Color := clWindow;
  self.btnOpenClientList.Enabled := True;

  // 02.02.2010 Ingmar
  //chkReqBillChange.checked:=false;
  //chkReqBillChange.enabled:=false;

  // 03.05.2010 ingmar;
  chkBillConfirmed.Checked := True;



  //edtCustname.Color:=cl3DLight; //rgb(209,238,251);//rgb(204,225,248);//estbk_types.MyFavGray;
  edtCustAddr.Color := cl3DLight; // estbk_types.MyFavGray;
  // ---


  try
    self.FSkipLComboEvents := True;
    //  gridBillLines.Editor:=self.FArticles;
    //  self.FArticles.Visible:=true;
    self.FArticles.Text := '';
    self.FArticles.Value := '';
  finally
    self.FSkipLComboEvents := False;
  end;


  // ---
  gridBillLines.Col := 1;
  gridBillLines.Row := 1;
  gridBillLines.Editor := gridBillLines.EditorByStyle(cbsAuto);



  self.FArticles.Left := gridBillLines.Editor.Left;
  self.FArticles.Top := gridBillLines.Editor.Top;



  self.FPaCurrColPos := 1;
  self.FPaCurrRowPos := 1;




  with qryBillMainRec, SQL do
  begin
    Close;
    Clear;
    add(estbk_sqlclientcollection._SQLSelectBillMainRec);
    paramByname('id').AsInteger := 0;
    paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    Open;

    self.FNewBill := True;




    // ---- MÜÜGIARVE numeraator
    if self.FCurrBillType = CB_salesInvoice then
    begin
      // 01.03.2012 Ingmar; aga kui me ei tea arve kp veel !?!
      pNewBillNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', now, False, estbk_types.CBill_doc_nr);
      edtBillNr.Text := pNewBillNr;
    end
    else
      edtBillNr.Text := ''; // ---
    billDate.Date := date;
    billDate.Text := datetostr(billDate.Date);

    accDate.Date := date;
    accDate.Text := datetostr(accDate.Date);
  end;




  // 20.09.2010 Ingmar
  self.edtRoundBc.ReadOnly := not (self.FCurrBillType = CB_purcInvoice);
  if not self.edtRoundBc.ReadOnly then
    self.edtRoundBc.color := clWindow
  else
    self.edtRoundBc.color := cl3DLight;

  _focus(edtContractor);

  // 24.09.2010 Ingmar
  if self.FCurrBillType = CB_prepaymentInvoice then
    cmbSalePuchAcc.Value := IntToStr(_ac.sysAccountId[estbk_types._accSupplPrepaymentVat]);

  // 10.03.2011 Ingmar; ei kinnita kohe !
  chkBillConfirmed.Checked := False;


  // maksetähtaeg combo
  if cmbPaymentTerm.Items.Count > 1 then
  begin
    if estbk_globvars.glob_default_paymentterm <> '' then
    begin

      for i := 0 to cmbPaymentTerm.Items.Count - 1 do
        if PtrInt(strtointdef(estbk_globvars.glob_default_paymentterm, high(Ptrint))) = PtrInt(cmbPaymentTerm.Items.Objects[i]) then
        begin
          cmbPaymentTerm.ItemIndex := i;
          cmbPaymentTerm.OnChange(cmbPaymentTerm);
          break;
        end;
    end
    else
      cmbPaymentTerm.ItemIndex := 0; // defineerimata
  end;




  pBillInfoText.color := pBillInfoText.Color;
end;

procedure TframeBills.btnChooseOutputClick(Sender: TObject);
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


  mnuItems.PopUp(TForm(pFindPOwner).left + TSpeedButton(Sender).left + TSpeedButton(Sender).Width - 8,
    TForm(pFindPOwner).top + TSpeedButton(Sender).top + TSpeedButton(Sender).Height + 105);
end;

procedure TframeBills.readjustPaymentDueDate(const pBillDate: TDatetime);
var
  pnewDueDate: TDatetime;
  pDays: integer;
  pIndex: integer;
begin

  if cmbPaymentTerm.Text = '' then
  begin
    dueDate.Date := pBillDate;
    dueDate.Text := datetostr(dueDate.Date);
  end
  else
  begin
    pIndex := cmbPaymentTerm.ItemIndex;
    if PtrInt(cmbPaymentTerm.Items.Objects[pIndex]) = High(PtrInt) then // -1 ehk sularaha arve !
      pDays := 0 // ---
    else
    begin
      pDays := PtrInt(cmbPaymentTerm.Items.Objects[pIndex]);
      // -- järelikult valik täna
      if pDays = 0 then
      begin
        dueDate.Date := now;
        Exit; // -->
      end;
    end;

    pnewDueDate := pBillDate + pDays;
    // ---
    dueDate.Date := pnewDueDate;
    dueDate.Text := datetostr(pnewDueDate);
  end;

end;

procedure TframeBills.searchDueMatchInCombo(const pDueDate: TDatetime);
var
  pDayBtw, i: integer;
  ptVal: Ptrint;
begin
  // 22.05.2011 Ingmar; hetkel selekteeritud on juba sularahaarve või kaardimakse
  pDayBtw := round(pDueDate - billDate.Date);
  if pDayBtw = 0 then
  begin
    ptVal := PtrInt(cmbPaymentTerm.Items.Objects[cmbPaymentTerm.ItemIndex]);
    if (ptVal = High(Ptrint) + CPaymentTermAsCashPayment + 1) or (ptVal = High(Ptrint) + CPaymentTermAsCreditCard + 1) then
      Exit;
  end;



  if pDayBtw >= 0 then
    for i := 0 to cmbPaymentTerm.Items.Count - 1 do
    begin
      ptVal := PtrInt(cmbPaymentTerm.Items.Objects[i]);
      if (ptVal < 365) and (ptVal = pDayBtw) then
      begin
        cmbPaymentTerm.ItemIndex := i;
        exit;
      end;
    end; // --

end;

procedure TframeBills.billDateExit(Sender: TObject);
var
  fVdate: TDatetime;
  fDateStr: AStr;
  pNewBillNr: AStr;
begin
  if self.FGridReadOnly then
    exit;

  TDateEdit(Sender).Tag := 0;
  fVdate := Now;
  fDateStr := TDateEdit(Sender).Text;

  if (trim(fDateStr) <> '') then
    if not validateMiscDateEntry(fDateStr, fVDate) then
    begin
      _callMsg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
      TDateEdit(Sender).SetFocus;
      Exit;
    end
    else
    begin
      TDateEdit(Sender).Text := datetostr(fVDate);
    end;


  // 16.03.2010 Ingmar
  if Sender = billDate then
  begin
    // 30.06.2011 Ingmar  kande kuupäev peab olema vaikimisi arve kuupäev
    accDate.Date := fVDate;
    self.readjustPaymentDueDate(fVDate);
    // ---
    self.refreshUICurrencyList(fVDate);

    // 14.04.2012 Ingmar
    // kontrollime ka üle arve kuupäeva, et ikka number tuleks õigesse seeriasse !
    pNewBillNr := self.revalidateBillNr;
    edtBillNr.Text := pNewBillNr;
  end
  else
  if Sender = dueDate then
  begin
    self.searchDueMatchInCombo(fVDate);
  end;


  // -- 18.07.2011 Ingmar; kanneteta arvete puhul värvida kuupäev teist värvi !
  if mnuNoAccRecs.Checked and (Sender = accDate) then
    accDate.Color := estbk_types.MyFavYellowGreen;
end;

procedure TframeBills.btnBillCopyClick(Sender: TObject);
var
  i: integer;
begin

  if self.FCurrBillType in [CB_salesInvoice, CB_purcInvoice] then
  begin

    // ---
    if estbk_lib_commoncls.copySGridContent(gridBillLines, self.FCopyObjs, [0]) then
      try
        self.FCopyMode := True;
        btnBillNewBill.OnClick(btnBillNewBill);

        restoreGridContent(gridBillLines, self.FCopyObjs);
        self.FBillHdrChkStr := '#';


        // et reaalselt ka uuesti salvestaks arveread !
        for i := 0 to gridBillLines.RowCount - 1 do
          if assigned(gridBillLines.Objects[CCol_ArtCode, i]) then
            with  TArticleDataClass(gridBillLines.Objects[CCol_ArtCode, i]) do
            begin
              FBillLineId := 0;
              FBillLineHash := -123456789;
              FRefBillLineId := 0;
            end; // ---

      finally
        self.FCopyMode := False;
        self.FCopyObjs.Clear;
        TBitBtn(Sender).Enabled := False;
      end
    else
      _callMsg(estbk_strmsg.SENothingToCopy, mtError, [mbOK], 0);
  end
  else
    _callMsg(estbk_strmsg.SEOpNotSupported, mtError, [mbOK], 0);
end;

// 01.03.2012 Ingmar
// NBNBNB; hetkel genereeritakse automaatselt arve nr müügiarve ja kreeditarvele !
// NB sellepärast, et tulevikus ntx viivisarved, ettemaksuarved(?), liisingarved...
function TframeBills.revalidateBillNr: string;
begin
  Result := edtBillNr.Text;
  if billDate.Text = '' then
    exit;

  if self.FIsCreditBill then
    Result := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), edtBillNr.Text, billDate.date,
      True, estbk_types.CCBill_doc_nr)
  else
    case self.FCurrBillType of
      CB_salesInvoice: Result := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self),
          edtBillNr.Text, billDate.date, True, estbk_types.CBill_doc_nr); // MÜÜK
      CB_prepaymentInvoice: ; // siin annab ka kasutaja ise numbri ette !
      CB_purcInvoice: ;      // siin annab ise inimene numbri ette
      else
        raise Exception.Create('Not implemented !');
    end;
end;

procedure TframeBills.billDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
var
  pNewBillNr: AStr;
begin
{
// 13.05.2011 Ingmar; raamatupidajad soovisid, et arve kuupäev on ka kande default kuupäev

}
  AcceptDate := ADate < now;
  if AcceptDate then
  begin
    self.refreshUICurrencyList(ADate);
    TDateEdit(Sender).Tag := 999;

    if self.FNewBill then
    begin
      accDate.Text := TDateEdit(Sender).Text;
      accDate.Date := ADate;
    end;

    // 22.05.2011 Ingmar
    self.OnMiscChange(Sender);


    // 21.05.2011 Ingmar; Kui arve kuupäeva muudeti, siis ei muudetud maksetähtaega !
    self.readjustPaymentDueDate(ADate);
    // --

    // kontrollime ka üle arve kuupäeva, et ikka number tuleks õigesse seeriasse !
    pNewBillNr := self.revalidateBillNr;
    edtBillNr.Text := pNewBillNr;
  end;
end;

procedure TframeBills.btnAddFileClick(Sender: TObject);
begin
  if assigned(onFrameDataEvent) then
    self.onFrameDataEvent(self,
      estbk_types.__frameOpenDocumentFiles,
      self.FOpenedBillDocId,
      nil);

end;

procedure TframeBills.accDateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
begin
  TDateEdit(Sender).Tag := 999;
  // kande kuupäev ei saa olla varasem, kui arve kuupäev
  AcceptDate := ADate >= billDate.Date;

  // 22.05.2011 Ingmar
  if AcceptDate then
    self.OnMiscChange(Sender);
end;

procedure TframeBills.billDateEditingDone(Sender: TObject);
begin
  // if TDateEdit(Sender).text<>'' then
  //    self.refreshUICurrencyList(TDateEdit(Sender).date);
end;

procedure TframeBills.btnCloseClick(Sender: TObject);
begin
  if assigned(onFrameKillSignal) then
    self.onFrameKillSignal(Sender);
end;

procedure TframeBills.btnCreditBillClick(Sender: TObject);
begin
  if ((self.FOpenedBillFlags and CBillLeaveOpenFlag) = CBillLeaveOpenFlag) or not chkBillConfirmed.Checked then
  begin
    _callMsg(estbk_strmsg.SEBillCantCreateCrBill, mtError, [mbOK], 0);
    Exit;
  end;


  if _callMsg(format(estbk_strmsg.SConfBillGenCreditBill, [edtBillNr.Text]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    openBill(self.FOpenedBillMainBrec, True);
  end;
end;

procedure TframeBills.btnEBillClick(Sender: TObject);
var
  pEBill: AStr;
  pStrList: TAStrlist;
  pFilename: AStr;
begin
  if self.FOpenedBillMainBrec > 0 then
  begin
    pFilename := edtBillNr.Text + formatdatetime('_dd_mm_yyyy', Now) + '.xml';
    pSaveXMLFile.FileName := estbk_utilities.doFilenameCleanup(pFilename);
    if pSaveXMLFile.Execute then
      try
        pStrList := TAStrlist.Create;
        pFilename := pSaveXMLFile.Files.Strings[0];
        pEBill := chr($EF) + chr($BB) + chr($BF) + estbk_ebill._generateEBill(self.FOpenedBillMainBrec);
        pStrList.Text := pEBill;
        pStrList.SaveToFile(pFilename);
      finally
        pStrList.Free;
      end;
  end;
end;

// 02.08.2011 Ingmar; teeb arve failist ajutise faili, et selle saaks ära meilida !
procedure TframeBills.generateRepTemppdfFile(var pFilename: AStr);
begin
  // --
  self.doPrint(pFilename, True);
end;


procedure TframeBills.btnEmailbillClick(Sender: TObject);
var
  psenderEmail, ptempfile, pbfr, pFileBase64: AStr;
  pHttp: TIdHttp;
  pFileStream: TFileStream;
  pStrStream: TStringStream;
  pBaseEnc: TBase64EncodingStream;
begin
  if assigned(self.FClientData) then
  begin

    // 26.04.2014 Ingmar; nüüd ka variant, kui saatja aadress on http protokoll, siis saadetakse sinna peale
    psenderEmail := Ansilowercase(Trim(dmodule.userStsValues[Csts_email_addr]));
    pFileStream := nil;
    pBaseEnc := nil;
    pStrStream := nil;

  end;
  if pos('http://', psenderEmail) = 1 then
    try
      pHttp := TIdHttp.Create();
      Self.generateRepTemppdfFile(ptempfile);

      pFileStream := TFileStream.Create(ptempfile, fmOpenRead);
      pStrStream := TStringStream.Create('');
      pBaseEnc := TBase64EncodingStream.Create(pStrStream);
      pFileStream.Seek(0, 0);
      pBaseEnc.CopyFrom(pFileStream, pFileStream.Size);


      pFileBase64 := pStrStream.DataString;
      pbfr := format('<?xml version="1.0" encoding="UTF-8"?><data><bill><![CDATA[%s]]></bill><pdf><![CDATA[%s]]></pdf></data>',
        [edtBillNr.Text, pFileBase64]);

      // -- reuse
      FreeAndNil(pStrStream);

      pStrStream := TStringStream.Create(pbfr);
      pStrStream.Seek(0, 0);
      pHttp.Request.ContentType := 'text/xml';
      pHttp.Request.UserAgent := 'Mozilla/5.0 (Windows NT 5.1; rv:28.0) Gecko/20100101 Firefox/28.0';
      pHttp.Request.Accept := '*/*';

      pHttp.Post(psenderEmail, pStrStream);

    finally
      SysUtils.DeleteFile(ptempfile);
      FreeAndNil(pHttp);
      FreeAndNil(pFileStream);
      FreeAndNil(pStrStream);
      FreeAndNil(pBaseEnc);
    end
  else
  begin
    // standard e-kirja saatmine !
    estbk_frm_esendbill.TformEMailBill.createAndShow(@generateRepTemppdfFile,
      FClientData.FCustEmail,
      Format(estbk_strmsg.CSCmBillnr, [edtBillNr.Text]),
      '', // tulevikus tuleb kirjeldus konfist !
      // 03.03.2013 Ingmar
      True, {pLogEmail}
      FOpenedBillMainBrec,
      'B', // viitab arvele
      edtBillNr.Text
      );
  end; // ---
end;

procedure TframeBills.btnIncomingsClick(Sender: TObject);
begin
  // req palume nö avada arve laekumised !
  // --
  if assigned(self.FFrameDataEvent) and (self.FOpenedBillMainBrec > 0) then
  begin
    if self.FCurrBillType = CB_purcInvoice then
      self.FFrameDataEvent(Self, __frameOpenBillPayments, self.FOpenedBillMainBrec)   // TASUMISED
    else
      self.FFrameDataEvent(Self, __frameOpenBillIncomings, self.FOpenedBillMainBrec); // LAEKUMISED
  end;
end;

procedure TframeBills.btnOpenAccEntryClick(Sender: TObject);
begin
  if assigned(self.FFrameDataEvent) and (self.FOpenedBillMainAccRec > 0) then
    self.FFrameDataEvent(Self, __frameOpenAccEntry, self.FOpenedBillMainAccRec);
end;

procedure TframeBills.edtContractorChange(Sender: TObject);
begin
  with TEdit(Sender) do
    if Focused then
    begin

      if Text = '' then
      begin
        if assigned(self.FClientData) then
          FreeAndNil(self.FClientData);

        self.displayClientData(nil);
      end;
      // ---
    end;
end;

// peame lihtsalt julmalt fookuse endale küsima, lazaruses on sellised probleemid fookusega, et hakka või nutma !
// lazaruse fookuse maailm on täiesti p----
procedure TframeBills.edtContractorEnter(Sender: TObject);
begin
  try
    self.FSkipLComboEvents := True;
    self.lazFocusFix.Enabled := False;
    //self.FLoadingBillData:=true; // trikk, stringgrid ei hakka siis editori ise paika panema !
    self.gridBillLines.Editor := gridBillLines.EditorByStyle(cbsAuto);
    //self.FAccounts.PopupVisible:=false;
    self.FAccounts.Visible := False;
    //self.FArticles.PopupVisible:=false;
    self.FArticles.Visible := False;
    //self.FVAT.PopupVisible:=false;
    self.FVAT.Visible := False;
    //self.FVATAccounts.PopupVisible:=false;
    self.FVATAccounts.Visible := False;
    // if TWinControl(sender).CanFocus then
    //    TWinControl(sender).SetFocus;
    // 30.03.2011 Ingmar; kui kuupäeva valitakse nupust, siis meie onchange handler ei tööta !
    if Sender is TDateEdit then
      TDateEdit(Sender).Tag := 999;

  finally
    self.FSkipLComboEvents := False;
  end;
end;

procedure TframeBills.edtContractorExit(Sender: TObject);
var
  pnewClient: TClientData;
  pClientCode: AStr;
begin
  if self.FGridReadOnly then
    exit;

  with TEdit(Sender) do
  begin
    if (Text = '') then
    begin
      self.displayClientData(nil);
    end
    else
    begin

      // pClientCode:=strtointdef(TEdit(Sender).text,-999999);
      pClientCode := copy(TEdit(Sender).Text, 1, 10);
      if (pClientCode <> self.FSrcLastClientCode) then
      begin
        pNewClient := estbk_fra_customer.getClientDataWUI(pClientCode);
        self.displayClientData(pnewClient);

        // 20.02.2011 Ingmar
        _focus(edtBillNr);
      end;
    end;

    // ---
    self.FSmartEditLastSuccIndx := -1;
    self.FSrcLastClientCode := pClientCode;
  end;
end;

procedure TframeBills.edtContractorKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) then
    case key of
      VK_RETURN: if not self.FGridReadOnly then
        begin
          self.btnOpenClientListClick(btnOpenClientList);
          key := 0;
        end;

      Ord('+'):
      begin
        // -------
      end;
    end;
end;

procedure TframeBills.edtContractorKeyPress(Sender: TObject; var Key: char);
begin
  // seda eventi kasutab grid ja kliendikoodi osa
  case key of
    ^V: if (key = ^V) and ((not edtContractor.Focused) and (assigned(gridBillLines.Editor)) and
        // and gridBillLines.Editor.Focused)
        (gridBillLines.Col <> CCol_ArtDesc) and (gridBillLines.Col <> CCol_ArtUnit)) then
      begin
        key := #0;
        exit;
      end;


    #13:
    begin
      SelectNext(Sender as twincontrol, True, True);
      key := #0;
    end
    else  // kuna eventi kasutavad ka teised editid, siis skipime ennast; algselt oli meil vaid kliendi ID, nüüd kood !!!
      if Sender <> edtContractor then
        estbk_utilities.edit_verifyNumericEntry(TEdit(Sender), key);
  end;

end;

procedure TframeBills.edtCustnameChange(Sender: TObject);
begin
  with TEdit(Sender) do
    if Focused and (Text = '') then
    begin
      edtContractor.Text := '';
      //edtCustname.Text:='';
      edtBankaccount.Text := '';
      // TODO 05.04.2012 Ingmar viitenumbri osa paremini läbi mõelda !
      // edtRefNumber.Text:='';
      edtCustAddr.Text := '';
      edtCustname.Hint := '';
      // 17.01.2011 Ingmar
      Color := clWindow;
      Font.Color := clWindowText;
    end;
end;

procedure TframeBills.edtCustnameExit(Sender: TObject);
var
  pSrcInst: TAStrList;
begin
  // 17.01.2011 Ingmar
  if (Sender = self.edtCustname) and (self.FSmartEditLastSuccIndx >= 0) then
  begin
    // ---
    if assigned(self.FClientData) then
      FreeAndNil(self.FClientData);



    pSrcInst := estbk_clientdatamodule.dmodule.custFastSrcList;
    // teeme koopia cachetud klassist
    self.FClientData := estbk_fra_customer.copyClientData(TClientData(pSrcInst.Objects[self.FSmartEditLastSuccIndx]));


    edtContractor.Text := self.FClientData.FClientCode;
    // ohutum on class uuesti kopeerida !!!!
    edtCustAddr.Text := estbk_fra_customer.buildFullClientAddrFromCstData(self.FClientData);
    // --
  end;
end;

{
procedure TframeBills.edtCustnameKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else

  if self.FSmartEditSkipChar or (key = #10) then
  begin
    self.FSmartEditSkipChar := False;
    key := #0;
  end;
  // --
end;
}

procedure TframeBills.edtCustnameKeyPress(Sender: TObject; var Key: char);
var
  pSrcInst: TAStrList;
  pRez: boolean;
begin
  // 31.03.2010 Ingmar; FIX: täiesti sürr lazaruse kala, kui edit on RO, siis  keypress läheb nagu niuhti läbi !!!
  self.FSmartEditSkipChar := TEdit(Sender).ReadOnly;
  if self.FSmartEditSkipChar or ((Key = #13) and assigned(self.FClientData) and (FClientData.FCustFullNameRev = Tedit(Sender).Text)) then
    Exit;


  // ONExit evendis pannakse kliendi klass uuesti paika !
  if assigned(self.FClientData) then
    FreeAndNil(self.FClientData);



  pSrcInst := estbk_clientdatamodule.dmodule.custFastSrcList;
  //TODO tavaliselt on kaks;  tee kood normaalseks, et kõik toimuks FSmartEditLastSuccIndx järgi !
  pRez := estbk_utilities.edit_autoCustDataStrListAutoComp(Sender, pSrcInst,
    // otsing perekonna ja nimetuse järgi
    self.FSmartEditSkipCtrlChars, Key, self.FSmartEditSkipChar, self.FSmartEditLastSuccIndx, edtContractor);


  if (trim(edtContractor.Text) = '') or (self.FSmartEditLastSuccIndx = -1) then
  begin
    edtContractor.Text := '';
    edtCustAddr.Text := '';
    if (self.FSmartEditLastSuccIndx = -1) then
    begin
      TCustomEdit(Sender).Color := estbk_types.MyFavRed2;
      TCustomEdit(Sender).Font.Color := clWhite;
    end
    else
    begin
      TCustomEdit(Sender).Color := clWindow;
      TCustomEdit(Sender).Font.Color := clWindowText;
    end;

  end
  else
  if pRez and (self.FSmartEditLastSuccIndx >= 0) then
  begin
    edtCustAddr.Text := estbk_fra_customer.buildFullClientAddrFromCstData(TClientData(pSrcInst.Objects[self.FSmartEditLastSuccIndx]));
    TCustomEdit(Sender).Color := clWindow;
    TCustomEdit(Sender).Font.Color := clWindowText;
  end;
end;

procedure TframeBills.edtRoundBcChange(Sender: TObject);
begin
  self.OnMiscChange(Sender);
end;

procedure TframeBills.edtRoundBcExit(Sender: TObject);
var
  psumTotal: double;
begin
  psumTotal := strtofloatdef(edtSumWOVatBc.Text, 0) + strtofloatdef(edtVatSumBc.Text, 0) + strtofloatdef(edtRoundBc.Text, 0);

  edtBillSumTotalBc.Text := format(CCurrentMoneyFmt2, [psumTotal]);
end;

procedure TframeBills.edtRoundBcKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    self.edtRoundBcExit(Sender);
    key := #0;
  end;
end;



procedure TframeBills.gridBillLinesClick(Sender: TObject);
begin
  // --
  if self.FKeyboardEventTriggered then
  begin
    self.FKeyboardEventTriggered := False;
    exit;
  end;


  // if  not (gridBillLines.Col  in [CCol_ArtCode,CCol_ArtAcc,CCol_ArtVATid,CCol_ArtVATAccid]) and  gridBillLines.CanFocus then
  //      gridBillLines.SetFocus;
end;

procedure TframeBills.gridBillLinesDblClick(Sender: TObject);
begin
  if not self.FGridReadOnly then
    with TStringGrid(Sender) do
      if (Row > 0) and (Col = CCol_DeleteCol) then
        self.deleteBillLine(Row);
end;



procedure TframeBills.gridBillLinesPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
var
  p: TTextStyle;
  pColOk: boolean;
begin
  p := TStringGrid(Sender).Canvas.TextStyle;
  // ---
  if aCol in [CCol_ArtPrice, CCol_ArtSum, CCol_ArtSumTotal, CCol_ArtAmount, CCol_ArtPercFromVat] then
    p.Alignment := taRightJustify
  else
    p.Alignment := taLeftJustify;
  TStringGrid(Sender).Canvas.TextStyle := p;



  //  accountingGrid2.Canvas.TextStyle.Alignment := taRightJustify else
  with TStringGrid(Sender).Canvas.Brush do
  begin
    pColOk := True;
    self.isInternalArticleType(aRow, aCol, pColOk);

    if (aRow = 0) or (aCol = 0) then
    begin
      if (aCol = CCol_DeleteCol) then
        Color := clWindow
      else
        Color := clBtnFace;
    end
    else
    if (aCol in [CCol_ArtSumTotal, CCol_ArtSum]) or not pColOk then
      Color := estbk_types.MyFavGray
    else
      Color := clWindow;
  end;
end;

procedure TframeBills.gridBillLinesSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
begin

  // 21.07.2011 Ingmar; huvitav viga ! kui nö kõrval lahtrisse liigud, siis tuleb  editing done event
  // ja küsitakse uuesti editori; kui liigud samas lahtris alla, siis eventi ei teki !
  if (self.FPaCurrColPos = aCol) and (self.FPaCurrRowPos <> aRow) then
    self.gridBillLinesEditingDone(gridBillLines); // kutsume ise välja !



  // ---
  self.FPaCurrRowPos := aRow;
  self.FPaCurrColPos := aCol;

  // 28.02.2010 Ingmar
  if (aCol = CCol_DeleteCol) then
  begin
    CanSelect := True;
    //if aRow>0 then
    //   self.deleteBillLine(aRow);
  end
  else
  begin

    // 25.12.2009 Ingmar
    if TStringGrid(Sender).Editor is TStringCellEditor then
    begin
      if aCol in [CCol_ArtSumTotal, CCol_ArtSum] then
        TStringCellEditor(TStringGrid(Sender).Editor).Color := MyFavGray
      else
        TStringCellEditor(TStringGrid(Sender).Editor).Color := clWindow;
    end;
  end;
  // ---
end;


procedure TframeBills.setLookupComboValues(const pLookup: TRxDBLookupCombo; const pCol: integer; const pRow: integer);
var
  pItemId: integer;
begin
  if not FSkipLComboEvents then
    with pLookup do
      try

        self.FSkipLComboEvents := True;
        Text := '';
        Value := '';
        Hint := '';

        if assigned(gridBillLines.Objects[pCol, pRow]) then
          if (pLookup = self.FArticles) then
          begin
            // leiame sobiva artikli !
            pItemId := TArticleDataClass(gridBillLines.Objects[pCol, pRow]).FArtId;
            if LookupSource.DataSet.Locate('id', integer(pItemId), []) then
            begin
              Text := LookupSource.DataSet.FieldByName('artcode').AsString;
              Hint := LookupSource.DataSet.FieldByName('artname').AsString;
            end;
          end
          else
          if (pLookup = self.FAccounts) or (pLookup = self.FVATAccounts) then
          begin
            pItemId := TAccountDataClass(gridBillLines.Objects[pCol, pRow]).FaccId;
            if LookupSource.DataSet.Locate('id', integer(pItemId), []) then
            begin
              Text := LookupSource.DataSet.FieldByName('account_coding').AsString;
              Hint := LookupSource.DataSet.FieldByName('account_name').AsString;
            end;
          end
          else
          if (pLookup = self.FVat) then
          begin
            pItemId := TVatDataClass(gridBillLines.Objects[pCol, pRow]).FVatId;
            if LookupSource.DataSet.Locate('id', integer(pItemId), []) then
            begin
              // 22.04.2010 Ingmar
              //if (LookupSource.DataSet.FieldByName('perc').AsFloat>0) then
              //    Text:=trim(LookupSource.DataSet.FieldByName('perc').asString)
              //else
              Text := trim(LookupSource.DataSet.FieldByName('description').AsString);
              Hint := trim(LookupSource.DataSet.FieldByName('description').AsString);
            end;

            if Text = '' then
              Text := '-';
          end
          else
          // 19.08.2011 Ingmar
          // ---
          if (pLookup = self.FObjects) then
          begin
            pItemId := TObjectDataClass(gridBillLines.Objects[pCol, pRow]).FObjectID;
            if LookupSource.DataSet.Locate('id', integer(pItemId), []) then
            begin
              Text := trim(LookupSource.DataSet.FieldByName('descr').AsString);
              Hint := trim(LookupSource.DataSet.FieldByName('descr').AsString);
            end;
          end;
        // --
      finally
        self.FSkipLComboEvents := False;
      end;
end;

function TframeBills.isInternalArticleType(const pRowNr: integer; const pColNr: integer; var pAllowColEdit: boolean): boolean;
begin
  pAllowColEdit := True;
  Result := (assigned(gridBillLines.Objects[CCol_ArtCode, pRowNr]) and
    (TArticleDataClass(gridBillLines.Objects[CCol_ArtCode, pRowNr]).FArtSpecialFlags and CArtSpTypeCode_PrepaymentFlag =
    CArtSpTypeCode_PrepaymentFlag));


  if Result then
    pAllowColEdit := not (pColNr in [CCol_ArtAcc, CCol_ArtUnit, CCol_ArtAmount, CCol_ArtDisc]);  // kas tohib redigeerida !
  // CCol_ArtPrice
end;

procedure TframeBills.gridBillLinesSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
var
  pRd, bFlag, pColOk, pIsRvrVatCol: boolean;
begin
  // self.FArticles.Visible:=false;
  //  ComboBox1.BoundsRect:=StringGrid1.CellRect(aCol,aRow);
  lazFocusFix.Enabled := False;

  // 28.02.2010 Ingmar
  if aCol = CCol_DeleteCol then
  begin
    Editor := nil;
    Exit;
  end;


  //bAddLastVal:=false;
  // kas tohib reaalselt rida muuta !
  pRd := self.allowArtChange();
  if not pRd then
  begin
    // --------------------------------------------
    Editor := TStringGrid(Sender).EditorByStyle(cbsAuto);

    if (aCol = CCol_ArtSumTotal) then
      TStringCellEditor(Editor).Color := MyFavGray
    else
    begin
      // ntx artikli tüüp on ettemaks
      pColOk := False;
      self.isInternalArticleType(aRow, aCol, pColOk);

      if not pColOk then
        TStringCellEditor(Editor).Color := MyFavGray
      else
        TStringCellEditor(Editor).Color := glob_userSettings.uvc_colors[uvc_activeGridEditorColor];
      Exit;
    end;
  end;




  // okei..eelnevad kontrollid lubasid läbi, paneme paika õige editori !!!
  case aCol of
    CCol_ArtCode:
    begin
      Editor := self.FArticles;
      // 15.08.2010 Ingmar;  kui me visiblet torgime, siis jääbki fookus gridi !
      FArticles.Visible := True;
      FArticles.Enabled := True;

      //if gridBillLines.CanFocus then
      //   gridBillLines.SetFocus;
      // 09.08.2010 Ingmar; iga uus laz versioon, toob mulle uued probleemid
      //if FArticles.CanFocus then
      //FArticles.SetFocus;
      //bAddLastVal:=true;

    end;

    CCol_ArtAcc:
    begin
      Editor := self.FAccounts;
      FAccounts.Visible := True;
      FAccounts.Enabled := True;

      //if FAccounts.CanFocus then
      //  FAccounts.SetFocus;
      //bAddLastVal:=true;
    end;

    CCol_ArtVATid:
    begin
      Editor := self.FVAT;
      FVAT.Visible := True;
      FVAT.Enabled := True;

      // if FVAT.CanFocus then
      //    FVAT.SetFocus;
      //bAddLastVal:=true;
    end;
    // 22.04.2010
    CCol_ArtVATAccid:
    begin
      Editor := self.FVATAccounts;
      FVATAccounts.Visible := True;
      FVATAccounts.Enabled := True;
      //if FVATAccounts.CanFocus then
      //   FVATAccounts.SetFocus;
      //bAddLastVal:=true;
    end;

    CCol_ArtUnit: Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsPicklist));

    // 19.08.2011 Ingmar
    CCol_ArtObject:
    begin
      Editor := self.FObjects;
      FObjects.Visible := True;
      FObjects.Enabled := True;

    end;



    else
      // stringeditori paigutus paika !
    begin
      Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto));
      if aCol in [CCol_ArtPrice, CCol_ArtSum, CCol_ArtSumTotal, CCol_ArtPercFromVat, CCol_ArtAmount] then
        TStringCellEditor(Editor).Alignment := taRightJustify
      else
        TStringCellEditor(Editor).Alignment := taLeftJustify;
    end;
      // ---
  end;




  // ---
  // 09.08.2010 Ingmar; veel üks laz loogika fix
  if Editor is TStringCellEditor then
    with (Editor as TStringCellEditor) do
    begin
      Color := glob_userSettings.uvc_colors[uvc_activeGridEditorColor];
      pIsRvrVatCol := (aCol = CCol_ArtVATSum) and assigned(TStringGrid(Sender).Objects[CCol_ArtVATid, aRow]) and
        ((TVatDataClass(TStringGrid(Sender).Objects[CCol_ArtVATid, aRow]).FVatFlags and estbk_types._CVtmode_turnover_tax) =
        _CVtmode_turnover_tax);


      // pöördkäibemaksu summa lahtri värvime kollaseks !
      if pIsRvrVatCol then
        TStringCellEditor(Editor).Color := glob_userSettings.uvc_colors[uvc_gridColorForBillRvrVatCell]
      else
      // 25.12.2009 Ingmar
      if (aCol = CCol_ArtSumTotal) then
        TStringCellEditor(Editor).Color := MyFavGray;


      // Lazarus ja tema fookuse probleemid !
      //gridBillLines.SetFocus;
      Visible := True;
      if CanFocus then
        SetFocus;


      // 18.02.2011 Ingmar; kogu see lazaruse fookuse teema on üks suur BUGI ! peame isegi celleditori fokuseerima timeriga, muidu kaob caret ära
      //       Height:=12;
    end
  else
  if Editor is TRxDBLookupCombo then
  begin

    self.setLookupComboValues(Editor as TRxDBLookupCombo,
      aCol,
      aRow);
    // 09.08.2010 Ingmar; iga uus laz versioon, toob mulle uued probleemid
    // kui valitakse cell ja siin funktsioonis paned kohe ntx Farticles.setFocus, siis antud lahendus ei tööta
    // Varasemas lazaruses töötas
  end;

  // ---
  lazFocusFix.Enabled := True;

end;

procedure TframeBills.gridBillLinesSelection(Sender: TObject; aCol, aRow: integer);
begin
  // ---
end;

procedure TframeBills.lazFocusFixStopTimer(Sender: TObject);
begin
  // ---
end;

// lazaruse fookused ei tööta õigesti !
procedure TframeBills.lazFocusFixTimer(Sender: TObject);
begin

  // if self.loadData then
  try

    if not self.FGridReadOnly then
    begin

      case self.FPaCurrColPos of
        CCol_ArtCode:
        begin

          if not self.FArticles.PopupVisible then
            _focus(self.FArticles);
        end;

        CCol_ArtAcc:
        begin

          if not self.FAccounts.PopupVisible then
            _focus(self.FAccounts);
        end;

        CCol_ArtVATid:
        begin

          if not self.FVAT.PopupVisible then
            _focus(self.FVAT);
        end;

        CCol_ArtVATAccid:
        begin
          if not self.FVATAccounts.PopupVisible then
            _focus(FVATAccounts);
        end
        else
          if (gridBillLines.Editor is TStringCellEditor) and TStringCellEditor(gridBillLines.Editor).CanFocus then   // 18.02.2011 Ingmar
          begin
              (*
                 gridBillLines.SetFocus;

              if assigned(gridBillLines.Editor) then
                 gridBillLines.Editor.SetFocus;
              *)
          end;
      end;
      // ---
    end;

  except
  end;
  // timer kinni
  TTimer(Sender).Enabled := False;
end;

procedure TframeBills.mmVatSpecsChange(Sender: TObject);
begin
  // 20.02.2012 Ingmar
  self.OnMiscChange(Sender);
end;

procedure TframeBills.mnuNoAccRecsClick(Sender: TObject);
begin

  // kanded või mitte, kinnitatud arvet EI saa muuta !
  if chkBillConfirmed.Checked then
    Exit;


  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  if TMenuItem(Sender).Checked then
    accDate.Color := estbk_types.MyFavYellowGreen
  else
    accDate.Color := clDefault;

end;

procedure TframeBills.mnuScreenClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to self.mnuItems.Items.Count - 1 do
    self.mnuItems.Items[i].Checked := False;
  TMenuItem(Sender).Checked := True;

  _focus(btnPrint);
end;

procedure TframeBills.pBillInfoTextClick(Sender: TObject);
begin
  // -- lazaruse onclick fix
  if TMemo(Sender).CanFocus then
  begin
    TMemo(Sender).SelectAll;
    TMemo(Sender).SetFocus;
  end;

  TMemo(Sender).Color := pBillInfoText.Color;

end;



procedure TframeBills.qInvoiceReportBeginBand(Band: TfrBand);
begin
  if (band.Typ = btPageHeader) then
    band.Visible := (self.FReportPagenr = 0)
  else
  if (band.Typ = btPageFooter) then
    band.Visible := (self.FReportPagenr > 0);
end;

procedure TframeBills.qInvoiceReportBeginPage(pgNo: integer);
begin
  self.FReportPageNr := pgNo;
end;

procedure TframeBills.qInvoiceReportEndBand(Band: TfrBand);
{
var
 i : Integer;
 p: TfrView;
}

begin
  if (band.Typ = btPageHeader) and (self.FReportPagenr > 1) then
    Band.Height := 1;

{
 // kuna pankade osa laieneb, siis arvutame bandid uuesti
 if band.Typ=btReportTitle then
 for i:=0 to band.Objects.Count-1 do
  if TObject(band.Objects.Items[i]) is TfrView then
  begin
      p:=TfrView(band.Objects.Items[i]);
   if p.Name='bankAccounts' then
    begin
      self.FBankAccMemo:=p;
      break;
    end;
  end;

 if band.Typ=btPageHeader then
   for i:=0 to band.Objects.Count-1 do
  if TObject(band.Objects.Items[i]) is TfrView then
   begin
      p:=TfrView(band.Objects.Items[i]);
      p.top:=p.top-7;
   end;
}
end;


procedure TframeBills.qInvoiceReportEnterRect(Memo: TStringList; View: TfrView);
var
  ppicView: TFrPictureView;
  ppicName: AStr;
begin
  // 09.05.2011 Ingmar; quick fix !
  // tõsine pdf kalake, seotud fontidega; üldiselt kui on align right, siis pdf failis on tekst rõvedalt nihkes !
  if self.FSaveBillAsPdf and (View is TfrMemoView) and (pos('@SVBillData', Memo.Text) > 0) then
    TfrMemoView(View).Alignment := taLeftJustify
  else
  // 10.01.2012 Ingmar
  if (View is TFrPictureView) then
    //  if (View.name='pcomplogo') then
  begin

    ppicView := View as TFrPictureView;
    ppicName := trim(ansilowercase(ppicView.Name));
    // 08.10.2013 Ingmar; kui kaks pilti, siis asendati kõik firma logoga, tuleb võtta kus nimi on pcomplogo
    if (ppicName = 'pcomplogo') then
      // 06.02.2012 Ingmar; arvel peab ka õige tüüp olema !!!
      if self.FCurrBillType in [CB_salesInvoice, CB_creditInvoice] then
        if estbk_clientdatamodule.dmodule.companyLogo.Width > 10 then
          try
            TFrPictureView(View).Stretched := True;
            TFrPictureView(View).Picture.Bitmap.Assign(estbk_clientdatamodule.dmodule.companyLogo.Picture.Bitmap);
          except
          end;
  end;
  // ---
end;

// ****************************************************************************
// Aruanne
// ****************************************************************************

// TODO korralikult ära formateerida !!!!!!!!!!!!!!
function TframeBills.getRptBillFormatBankData(const banks: AStr): AStr;
const
  CSpaces = 2;
var
  pNewLine: AStr;
begin
  Result := '';
  // -- teisel juhul näiteks TARNIJA pangakontod !!!!!
  if banks = '' then
    with qryBanks do
    begin
      First;
      while not EOF do
      begin
        pNewLine := stringofchar(#32, CSpaces) + FieldByName('bankname').AsString + #32;
        // 06.05.2013 Ingmar; lisasin loogika kui vaikimisi nr olemas võetakse see, muidu iban !
        if trim(FieldByName('account_nr').AsString) <> '' then
          pNewLine := pNewLine + FieldByName('account_nr').AsString
        else
        if trim(FieldByName('account_nr_iban').AsString) <> '' then
          pNewLine := pNewLine + FieldByName('account_nr_iban').AsString;
        // --
        Result := Result + pNewLine + CRLF;
        // result:=result+fieldbyname('bankname').asString+#32+fieldbyname('account_nr').asString+'                   ';

        Next;
      end;
      // --
    end;
end;

function TframeBills.getBillIssuer(): AStr;
begin
  if chkBillConfirmed.Checked then
    Result := self.FBillIssuer
  else
    Result := estbk_globvars.glob_usrname;
end;

function TframeBills.getRptBillSumInWords: AStr;
var
  pSumTotal: double;
  pConv: AStr;
begin
  Result := '';
  // 04.03.2013 Ingmar; kõik on tore, aga ainult müügiarvel võiks olla; mitte kõikjal !
  if self.FCurrBillType <> estbk_types.CB_salesInvoice then
    Exit;

  // 26.01.2013 Ingmar;
  pConv := Stringreplace(estbk_utilities.setRFloatSep(edtBillSumTotalBc.Text), #32, '', [rfReplaceAll]);
  pSumTotal := strtofloatdef(pConv, Math.Nan);
  // --
  if not Math.IsNan(pSumTotal) and (pSumTotal > 0.00) then
    Result := estbk_utilities.fncSumIncWords(pSumTotal);
end;

function TframeBills.getRptBillBalanceData: AStr;
begin
  Result := '';
end;


function TframeBills.getRptBillNotes: AStr;
const
  CSbUnderLineLen = 16;
var
  pBillIssuer: AStr;
  pBillReceiver: AStr;
begin
  Result := trim(mmVatSpecs.Text) + CRLF; // käibemaksu erisused
  // TODO !
{
   pBillIssuer:='';
   pBillReceiver:='';

if self.FCurrBillType=CB_salesInvoice then
  begin
   result:=result+CRLF+CRLF+' '+CRLF+' '+format(estbk_strmsg.SCBillIssuedBy,[pBillIssuer])+stringofchar('_',CSbUnderLineLen);
   result:=result+CRLF+' '+CRLF+' '+format(estbk_strmsg.SCBillAcceptedBy,[pBillReceiver]);
  end; // ---
}
end;




procedure TframeBills.qInvoiceReportGetValue(const ParName: string; var ParValue: variant);
const
  // -- firma rekvisiidid
  _CVCompname = '@cvcompname'; // @1
  _CVComprq = '@cvcomprq';   // @2
  _CVCompAddr = '@cvcompaddr'; // @3
  _CVCompCont = '@cvcompcont'; // @4

  // --
  _CSCustAddr = '@scustaddr';    // arve saaja @5
  _CSCustRegCode = '@scustregcode'; // reg. kood, kui juriidiline isik @6
  _CSCustName = '@scustname';    // kliendi nimi @7
  _CSCustBillRecv = '@scbillrecv';   // tiitel arve saaja @8
  _CSBillName = '@scbillname';   // @9
  // -- andmeväljad
  _CVBillNr = '@svbillnr';         // @10
  _CVBillDate = '@svbilldate';       // @11
  _CVBillRefnr = '@svrefnr';          // @12
  _CVBillDueDate = '@svduedate';  // @13
  _CVBillCustVatNr = '@svcustvatnr'; // @14
  _CVCustBalanceInfo = '@svcustbalanceinfo'; // @15
  _CVBankAccounts = '@svbankaccounts'; // @16

  // --
  _CVArtQty = '@svartqty'; // @17
  _CVArtItemPrice = '@svartitemprice'; // @18
  _CVArtDiscount = '@svartitemdisc';  // @19
  _CVArtLineSum = '@svartlinesum';   // @20

  //_SVBillSummaryLb  = '@svbillsummarylb';   // @21; labelid
  //_SVBillSummaryVb  = '@svbillsummaryvb';   // @22; labelitega seotud summad

  _SVBillExtNotes = '@svbillextnotes';  // @21
  _SVBillSumVrb = '@svbillsumvrb';    // @22

  // 06.04.2012 Ingmar
  _SVBillIssuer = '@svbillissuer';    // @23
  _SVBillDuePerc = '@svbilldueperc';   // @24
  _SVBillCurrency = '@svbillcurrency';  // @25
  _SVVATNumber = '@svvatnr';         // @26
  // maksetingimus
  _CVPaymentCriteria = '@scpaymentcrit'; // @27

const
  _SVBillLData = '@svbilldatal'; // label; ntx summa tasuda
  _SVBillData = '@svbilldata'; // siin on summa !

const
  pTagArray: array[1..27] of AStr = (
    _CVCompname,
    _CVComprq,
    _CVCompAddr,
    _CVCompCont,
    // --
    _CSCustAddr,
    _CSCustRegCode,
    _CSCustName,
    _CSCustBillRecv,
    _CSBillName,
    _CVBillNr,
    _CVBillDate,
    _CVBillRefnr,
    _CVBillDueDate,
    _CVBillCustVatNr,
    _CVCustBalanceInfo,
    _CVBankAccounts,
    // --
    _CVArtQty,
    _CVArtItemPrice,
    _CVArtDiscount,
    _CVArtLineSum,
    // arve alumine osa
    //_SVBillSummaryLb,
    //_SVBillSummaryVb,
    _SVBillExtNotes,
    _SVBillSumVrb,
    // --
    _SVBillIssuer,
    _SVBillDuePerc,
    _SVBillCurrency,
    _SVVATNumber,
    // 11.04.2013 Ingmar
    _CVPaymentCriteria
    );

  // 20.02.2012 Ingmar; ostuarvel tuleb väljad ära vahetada !
  function __correctValue(const pFieldIndx: integer; const pVal: AStr): AStr;
  begin
    Result := pVal;
    if self.FCurrBillType = CB_purcInvoice then
      case pFieldIndx of
        1: Result := self.FClientData.FCustFullNameRev;       // _CVCompname
        3: Result := estbk_utilities.miscGenBuildAddr(self.FClientData.FCustJCountry, self.FClientData.FCustJCounty,
            self.FClientData.FCustJCity, self.FClientData.FCustJStreet, self.FClientData.FCustJHouseNr,
            self.FClientData.FCustJApartNr, self.FClientData.FCustJZipCode, addr_billfmt);
        // _CVCompAddr
        4: Result := '';  // CVCompCont

        // klient
        5: Result := estbk_globvars.glob_currcompaddr;

        // 11.04.2013 Ingmar
        6: Result := '';     // _CSCustRegCode
        7: Result := estbk_globvars.glob_currcompname;  // _CSCustName
        2,  // // _CVComprq
        16: Result := ''; //_CVBankAccounts
        23: Result := ''; // ostuarvel me ei kuva arve väljastajat !
        26: Result := ''; // kmknr ei kuva samuti !
        27: Result := ''; // maksetingimust ka ei kuva ? või peaks ?!?
      end;
  end;

var
  prm: AStr;
  i, paramIndx: integer;
  pIsLabel: boolean;
  pDataIndex: integer;
begin
  // väljade testimiseks
  //   ParValue:='#'+ParName;
  //   Exit;

  try



    paramIndx := -1;
    prm := ansilowercase(ParName);
    if (pos('@', prm) = 0) or not assigned(self.FClientData) then
      exit;


    // 17.04.2011 Ingmar
    // [@SVBillLData1]-[@SVBillLData6] [@SVBillData1]-[@SVBillData6]
    if (pos(_SVBillLData, prm) > 0) or (pos(_SVBillData, prm) > 0) then
    begin

      ParValue := '';
      pIsLabel := (pos(_SVBillLData, prm) > 0);
      pDataIndex := strtointdef(stringreplace(stringreplace(prm, _SVBillLData, '', []), _SVBillData, '', []), -1) - 1;




      if (pDataIndex >= 0) and (pDataIndex <= FReportSumFtrData.Count - 1) then
      begin

        case pIsLabel of
          True: ParValue := trim(self.FReportSumFtrData.Names[pDataIndex]);
          False: ParValue := trim(self.FReportSumFtrData.ValueFromIndex[pDataIndex]);
        end;




        Exit; // -->
      end;

    end;


    // ---
    for i := low(pTagArray) to high(pTagArray) do
      if pTagArray[i] = prm then
      begin
        paramIndx := i;
        break;
      end;


    case paramIndx of
      1: ParValue := __correctValue(paramIndx, estbk_globvars.glob_currcompname);       // _CVCompname
      2: ParValue := __correctValue(paramIndx, estbk_globvars.glob_currcompregcode);    // _CVComprq
      3: ParValue := __correctValue(paramIndx, estbk_globvars.glob_currcompaddr);       // _CVCompAddr
      4: ParValue := __correctValue(paramIndx, estbk_globvars.glob_currcompcontacts);   // CVCompCont


      // klient
      5: ParValue := __correctValue(paramIndx, estbk_utilities.miscGenBuildAddr(self.FClientData.FCustJCountry,
          self.FClientData.FCustJCounty, self.FClientData.FCustJCity, self.FClientData.FCustJStreet,
          self.FClientData.FCustJHouseNr, self.FClientData.FCustJApartNr, self.FClientData.FCustJZipCode, addr_billfmt));
      // _CSCustAddr
      6: if self.FClientData.FCustType = 'L' then // ainult jur. isiku puhul
        begin
          ParValue := __correctValue(paramIndx, self.FClientData.FCustRegNr);
        end
        else
          ParValue := ''; // _CSCustRegCode

      7: ParValue := __correctValue(paramIndx, self.FClientData.FCustFullNameRev); // _CSCustName
      8: ParValue := estbk_strmsg.SCBillRepBillRecv; // _CSCustBillRecv
      9: ParValue := estbk_types.CLongBillName[self.FCurrBillType]; // _CSBillName

      // arve
      10: ParValue := edtBillNr.Text; // _CVBillNr
      11: ParValue := datetostr(billDate.date);  // _CVBillDate
      12: ParValue := edtRefNumber.Text; // self.FClientData.FCustContrRefNr; // _CVBillRefnr

      13: if dueDate.Text <> '' then
          ParValue := datetostr(dueDate.date)
        else
          ParValue := '';  // _CVBillDueDate

      14: if (self.FClientData.FCustType = 'L') and (trim(self.FClientData.FCustVatNr) <> '') then
          ParValue := self.FClientData.FCustVatNr // _CVBillCustVatNr
        else
          ParValue := '';

      // --------------------------------------------------------------------------
      15: ParValue := getRptBillBalanceData; // _CVCustBalanceInfo
      16: ParValue := __correctValue(paramIndx, getRptBillFormatBankData(trim(self.FBillBankAccounts))); // _CVBankAccounts

      // --------------------------------------------------------------------------
      17: ParValue := smartFloatFmt(qInvoiceMemDataset.FieldByName('artqty').AsFloat, CCurrentAmFmt3); // _CVArtQty
      18: ParValue := format(CCurrentMoneyFmt2, [qInvoiceMemDataset.FieldByName('artprice').AsFloat]); // _CVArtItemPrice
      19:
      begin // _CVArtDiscount
        if qInvoiceMemDataset.FieldByName('artdiscount').AsFloat > 0 then
          ParValue := format('%d %%', [round(qInvoiceMemDataset.FieldByName('artdiscount').AsFloat)])
        else
          ParValue := '';
      end;
      20: ParValue := format(estbk_types.CCurrentMoneyFmt2, [qInvoiceMemDataset.FieldByName('artpricetotal').AsFloat]); // _CVArtLineSum
      // ------------------------------------------------
      // arve jaluse info; makstavad summad jne jne
      //21: ParValue:=self.getRptFooterSummaryData(true);
      //22: ParValue:=self.getRptFooterSummaryData(false);
      // ------------------------------------------------

      21: ParValue := self.getRptBillNotes();// qInvoiceMemDataset.FieldByname('blnotes').asString; // märkused arve alumises osas
      22: ParValue := self.getRptBillSumInWords(); // summa sõnadega !
      23: ParValue := __correctValue(paramIndx, self.getBillIssuer());
      24: ParValue := self.edtInterestPerc.Text; // viivise protsent
      25: ParValue := cmbCurrencyList.Text; // valuuta !
      26: ParValue := estbk_globvars.glob_currcompvatnr;
      // 11.04.2013 Ingmar
      // maksetingimus
      27: ParValue := trim(cmbPaymentTerm.Text)
      else
        ParValue := '';
    end;

  except
    on e: Exception do
    begin
    {$ifdef debugmode}
      ShowMessage(Parname + ' ' + vartostr(Parvalue));
    {$endif}
      ParValue := '';
    end;
  end;
end;

procedure TframeBills.qryGetArticlesFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := True;
  case self.FCurrBillType of
    CB_purcInvoice: ; // 10.03.2012 Ingmar; mingi nipiga suutsid kasutajad valida ostuarvele ka "teenused"
    // Accept:=DataSet.FieldByname('arttype').AsString<>estbk_types._CItemAsService;
    CB_prepaymentInvoice: Accept := (DataSet.FieldByName('special_type_flags').AsInteger and estbk_types.CArtSpTypeCode_PrepaymentFlag) =
        estbk_types.CArtSpTypeCode_PrepaymentFlag;
    // Accept:=DataSet.FieldByname('special_type_flags').AsInteger>0;
    CB_salesInvoice: Accept := (pos(estbk_types._CArticleCanbeUsedInSale, DataSet.FieldByName('status').AsString) > 0) or
        ((DataSet.FieldByName('special_type_flags').AsInteger and estbk_types.CArtSpTypeCode_PrepaymentFlag) =
        estbk_types.CArtSpTypeCode_PrepaymentFlag);
  end;
  // ---
end;

// 13.05.2011 Ingmar; peame garanteerima, et see event ka välja kutsutakse OH lazarus !
procedure TframeBills.OnStringCellEditorExitFix(Sender: TObject);
begin
  with gridBillLines do
    self.gridBillLinesEditingDone(self.gridBillLines);
end;

// TODO porgani fix !
procedure TframeBills.OnEditorFocusFixClick(Sender: TObject);
begin
  if (Sender is TWinControl) and TWinControl(Sender).CanFocus then
  begin
    if (TWinControl(Sender) is TCustomEdit) and (TCustomEdit(TWinControl(Sender)).SelLength > 0) then
    begin
      TCustomEdit(TWinControl(Sender)).SelStart := length(TCustomEdit(TWinControl(Sender)).Text);
      TCustomEdit(TWinControl(Sender)).SelLength := 0;
    end
    else
    if not TWinControl(Sender).Focused then
      TWinControl(Sender).SetFocus;
  end;
end;

// värvime pöördkäibemaksu read kollaseks !!!
procedure TframeBills.OnLookupGetGridCellProps(Sender: TObject; Field: TField; AFont: TFont; var Background: TColor);
begin
  Background := clInfoBk;

  // if (Sender=self.FVAT) then
  with self.FVAT.LookupSource.DataSet do
    if active then
    begin
      if (FieldByName('vatflags').AsInteger and estbk_types._CVtmode_turnover_tax) = estbk_types._CVtmode_turnover_tax then
        Background := clInfoBk
      else
        Background := clWindow;
    end;
end;

procedure TframeBills.OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix();
end;


procedure TframeBills.OnLookupComboChange(Sender: TObject);
begin
  // ---
  self.OnMiscChange(nil);
end;



procedure TframeBills.chooseAccountForArticle(const CurrRowPos: integer; const pAccToUse: integer);
begin
  if CurrRowPos > 0 then
  begin
    // vaatame, kas konto info klass lahtriga juba seotud
    if not assigned(self.gridBillLines.Objects[CCol_ArtAcc, CurrRowPos]) then
      self.gridBillLines.Objects[CCol_ArtAcc, CurrRowPos] := TAccountDataClass.Create;

    // ---
    if qryGetAccounts.Locate('id', integer(pAccToUse), []) and ((qryGetAccounts.FieldByName('flags').AsInteger and
      estbk_types.CAccFlagsClosed) <> estbk_types.CAccFlagsClosed) then // konto ei tohi olla suletud
    begin
      TAccountDataClass(self.gridBillLines.Objects[CCol_ArtAcc, CurrRowPos]).FAccCode := qryGetAccounts.FieldByName('account_coding').AsString;
      TAccountDataClass(self.gridBillLines.Objects[CCol_ArtAcc, CurrRowPos]).FAccId := qryGetAccounts.FieldByName('id').AsInteger;
      self.gridBillLines.Cells[CCol_ArtAcc, CurrRowPos] := qryGetAccounts.FieldByName('account_coding').AsString;
    end
    else
    begin
      TAccountDataClass(self.gridBillLines.Objects[CCol_ArtAcc, CurrRowPos]).FAccCode := '';
      TAccountDataClass(self.gridBillLines.Objects[CCol_ArtAcc, CurrRowPos]).FAccId := 0;
      self.gridBillLines.Cells[CCol_ArtAcc, CurrRowPos] := '';
      // 12.03.2010 Ingmar
      self.FAccounts.Text := '';
      self.FAccounts.Value := '';
    end;
    // ---
  end;
end;


// Ingmar; kui aega tuleb optimiseeri seda koodi !  pidev rescan pole eriti mõistlik !
procedure TframeBills.calcArtSum(const rowNr: integer);
var
  pArtPrice: double;
  pArtAmount: double;
  pArtCArtPrice: double;
  pDiscPerc: double;
  pSumTotal: double;
  pVatPercFull: double;
  pVatPercFromVat: double;
  pVatSum: double;
  pVatSumLeft: double; // auto kuludega ei tohi kõike maha võtta, see siis jääk, mida ei saanud maha võtta
  pArtSumTotalWA: double;
  pArtVatTotal: double;
  pRoundsum: double;
  i, pOkItems: integer;
  pSkipVat: boolean;

begin
  try
    pOkItems := 0;
    for i := 1 to gridBillLines.Rowcount - 1 do
      if (trim(self.gridBillLines.Cells[CCol_ArtPrice, i]) <> '') or (trim(self.gridBillLines.Cells[CCol_ArtAmount, i]) <> '') then
        Inc(pOkItems);

    // --
    if (rowNr = -1) or (pOkItems = 0) then
    begin
      edtSumWOVatBc.Text := '';
      edtVatSumBc.Text := '';
      edtRoundBc.Text := '';
      edtBillSumTotalBc.Text := '';
              {
             edtSumWOVatBco.text:='';
             edtVatSumBco.text:='';
             edtRoundBco.text:='';
             edtBillSumTotalBco.text:='';}
      Exit;
    end;



          {
          23.04.2010
          if (trim(self.gridBillLines.Cells[CCol_ArtCode,rowNr])='') and
             (trim(self.gridBillLines.Cells[CCol_ArtDesc,rowNr])='') then
              Exit;
          }

    if (trim(self.gridBillLines.Cells[CCol_ArtPrice, rowNr]) = '') or (trim(self.gridBillLines.Cells[CCol_ArtAmount, rowNr]) = '') then
    begin
      self.gridBillLines.Cells[CCol_ArtSum, rowNr] := '';
      self.gridBillLines.Cells[CCol_ArtVATSum, rowNr] := '';
      // 20.04.2015 Ingmar
      self.gridBillLines.Cells[CCol_ArtPercFromVat, rowNr] := '';
      self.gridBillLines.Cells[CCol_ArtSumTotal, rowNr] := '';
      Exit;
    end;




    pArtPrice := strtoFloatDef(self.gridBillLines.Cells[CCol_ArtPrice, rowNr], 0);
    pArtAmount := strtoFloatDef(self.gridBillLines.Cells[CCol_ArtAmount, rowNr], 0);
    pDiscPerc := strtoFloatDef(self.gridBillLines.Cells[CCol_ArtDisc, rowNr], 0);


    // ---
    //   allahindlus
    if (pDiscPerc < 0) and (pDiscPerc > 100) then
      pDiscPerc := 0;




    // arvutame rea hinna
    pArtCArtPrice := pArtPrice * pArtAmount;
    pArtCArtPrice := pArtCArtPrice - (pArtCArtPrice * (pDiscPerc / 100));



    // -------------------------------------------------------------------------
    // korrigeerime täiendavalt üle väljade numbrilised sisud
    // -------------------------------------------------------------------------

    if self.gridBillLines.Cells[CCol_ArtAmount, rowNr] <> '' then
    begin
      self.gridBillLines.Cells[CCol_ArtAmount, rowNr] :=
        format(CCurrentAmFmt3, [strtoFloatDef(self.gridBillLines.Cells[CCol_ArtAmount, rowNr], 0)]);

      // 20.04.2015 Ingmar
      if trim(self.gridBillLines.Cells[CCol_ArtPercFromVat, rowNr]) = '' then
        self.gridBillLines.Cells[CCol_ArtPercFromVat, rowNr] := format(CCurrentMoneyFmt2, [100.00]);
    end;


    if self.gridBillLines.Cells[CCol_ArtDisc, rowNr] <> '' then
      self.gridBillLines.Cells[CCol_ArtDisc, rowNr] := format('%d', [strtoIntDef(self.gridBillLines.Cells[CCol_ArtDisc, rowNr], 0)]);



    pVatPercFromVat := 100;
    pVatPercFull := 0;
    pSkipVat := False; // ntx pöördkäibemaksu puhul lõppsummale ei tohi antud summat lisada !!!!



    // vaatame, kas käibemaks on paigas !
    if assigned(self.gridBillLines.Objects[CCol_ArtVATid, rowNr]) then
    begin
      pVatPercFull := TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, rowNr]).FVatPerc;

      // Riigil tõesti pole sittagit teha, kui pidevalt mingit jura raamatupidamises välja mõelda
      // Hetkel on nüüd nii, et osadelt kulutustelt tohib vaid 50% maha arvata
      if (TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, rowNr]).FVatFlags and estbk_types._CVtmode_carVAT50) =
        estbk_types._CVtmode_carVAT50 then
        pVatPercFromVat := 50; // ehk mitu protsenti tohib maha arvestada
      // kas riik järsku varsti ei mõtle, et ala 40.5% tohib maha arvata ?!?

      // NBNB kontrolli esmalt, järsku kasutaja on ise tagasiküsitavat protsenti muutnud !!!
            (*
            if (trim(self.gridBillLines.Cells[CCol_ArtPercFromVat,rowNr]) <> '') then
                self.gridBillLines.Cells[CCol_ArtPercFromVat,rowNr]:=format(CCurrentMoneyFmt2,[pVatPercFromVat]);
            *)

      // küsime jälle lahtrist protsendi; järsku kasutaja kirjutas sinna midagi meeletult põnevat
      pVatPercFromVat := StrtoFloatDef(self.gridBillLines.Cells[CCol_ArtPercFromVat, rowNr], 100);
    end;

    // Miks ma ei võiks krt kasutada siin calcArt
    // arvutame käibemaksu siis täismahus
    pVatSumLeft := roundto(pArtCArtPrice * (pVatPercFull / 100), Z2);


    // võtame siis protsendi protsendist...autole kulutatud käibemaksust saab VAID pool tagasi arvestada
    pVatPercFromVat := (pVatPercFromVat / 100) * pVatPercFull;
    pVatPercFull := pVatPercFromVat;


    // -------------
    // terviksumma; 2 kohta peale koma
    pVatSum := roundto(pArtCArtPrice * (pVatPercFull / 100), Z2);
    pSkipVat := False;
    pVatSumLeft := pVatSumLeft - pVatSum;


    // Summa lahter
    self.gridBillLines.Cells[CCol_ArtSum, rowNr] := format(CCurrentMoneyFmt2, [roundto(pArtCArtPrice + pVatSumLeft, Z2)]);


    // BUG: välistame muutmise, kui sisestus tuli antud väljalt !
    if self.gridBillLines.Col <> CCol_ArtVATSum then
      self.gridBillLines.Cells[CCol_ArtVATSum, rowNr] := format(CCurrentMoneyFmt2, [pVatSum])
    else
      // ostuarvel saab ise käibemaksu summat sisestada !
    begin
      pVatSum := strtoFloatDef(self.gridBillLines.Cells[CCol_ArtVATSum, rowNr], 0);
      // et formateering oleks korrektne;
      self.gridBillLines.Cells[CCol_ArtVATSum, rowNr] := format(CCurrentMoneyFmt2, [pVatSum]);
    end;

    // ::pöördkäibemaks
    if assigned(self.gridBillLines.Objects[CCol_ArtVATid, rowNr]) then
      pSkipVat := (TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, rowNr]).FVatFlags and estbk_types._CVtmode_turnover_tax) =
        _CVtmode_turnover_tax;



    // antud reale ei arvuta käibemaksu !
    if pSkipVat then
      pVatSum := 0;




    pSumTotal := roundto(pArtCArtPrice + pVatSum + pVatSumLeft, Z2);
    self.gridBillLines.Cells[CCol_ArtSumTotal, rowNr] := format(CCurrentMoneyFmt2, [pSumTotal]);


    // ----
    // 25.12.2009 Ingmar; arvutame üldsummad uuesti !!
    pArtSumTotalWA := 0; // ilma käibemaksuta
    pArtVatTotal := 0;


    // JALUS !!!
    for i := 1 to gridBillLines.Rowcount - 1 do
    begin

      pArtCArtPrice := strtofloatDef(self.gridBillLines.Cells[CCol_ArtSum, i], 0);
      pArtSumTotalWA := pArtSumTotalWA + pArtCArtPrice; // summa ilma käibemaksuta
      pVatSum := strtofloatDef(self.gridBillLines.Cells[CCol_ArtVATSum, i], 0);


      pSkipVat := False;

      // pöördkäibemaksu me ei tohi lisada lõppsummasse !
      if assigned(self.gridBillLines.Objects[CCol_ArtVATid, i]) then
        pSkipVat := (TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, i]).FVatFlags and estbk_types._CVtmode_turnover_tax) =
          _CVtmode_turnover_tax;
      if not pSkipVat then
        pArtVatTotal := pArtVatTotal + pVatSum;
    end;




    // uuendame ka jaluses olevat kogusummade infot !
    pRoundsum := strtofloatdef(edtRoundBc.Text, 0);
    edtSumWOVatBc.Text := format(CCurrentMoneyFmt2, [pArtSumTotalWA]);
    edtVatSumBc.Text := format(CCurrentMoneyFmt2, [pArtVatTotal]);
    edtBillSumTotalBc.Text := format(CCurrentMoneyFmt2, [pArtSumTotalWA + pArtVatTotal + pRoundsum]);

  except
    begin
      self.FSkipLComboEvents := True; // väldime üllatusi, et mingi handler kusagil tahaks tööd teha

      edtSumWOVatBc.Text := '';
      edtVatSumBc.Text := '';
      edtBillSumTotalBc.Text := '';
      if rowNr > 0 then
        self.gridBillLines.Cells[CCol_ArtSumTotal, rowNr] := estbk_strmsg.SEErr;


      self.FSkipLComboEvents := False;
    end;
  end;
end;

procedure TframeBills.performColForwardMove;
var
  pNextCol: integer;
  pRowMove: boolean;
begin
  if self.FGridReadOnly then
  begin

    if gridBillLines.Col + 1 <= gridBillLines.ColCount then
      gridBillLines.Col := gridBillLines.Col + 1
    else
    begin
      gridBillLines.Row := gridBillLines.Row + 1;
      gridBillLines.Col := 1;
    end;
  end
  else
  begin
    pRowMove := True;
    pNextCol := gridBillLines.Col + 1;



    while pNextCol < gridBillLines.ColCount do
    begin

      if not (pNextCol in [CCol_ArtSum, CCol_ArtSumTotal]) and
        // kole häkk; aga peame vaatama, et lahter poleks tumehall; ntx km summat on võimalik osadel arvetüüpidel muuta ja see väli pole RO
        (gridBillLines.Columns.Items[pNextCol - 1].Color = clWindow) and gridBillLines.Columns.Items[pNextCol - 1].Visible and
        not gridBillLines.Columns.Items[pNextCol - 1].ReadOnly then
      begin
        pRowMove := False;
        break;
      end;
      // --
      Inc(pNextCol);
    end;


    if not pRowMove then
      gridBillLines.Col := pNextCol
    else
    if gridBillLines.Row < gridBillLines.RowCount then
    begin
      gridBillLines.Row := gridBillLines.Row + 1;
      gridBillLines.Col := 1;
    end;
  end; // --
end;


// OnChoose ka !
procedure TframeBills.OnLookupComboSelect(Sender: TObject);
var
  pPrice: double;
  pDefaultVatAccId: integer;
  pPurchAcc: integer;
  pSaleAcc: integer;
  pExpAcc: integer;
  pAccToUse: integer;
  pVATId: integer;
  pBookmark: Tbookmark;
  pdummy2: boolean;
  pVatFound: boolean;

begin

  if not (Sender is TRxDBLookupCombo) or self.FSkipLComboEvents or (self.FPaCurrRowPos < 1) or (self.FPaCurrColPos < 1) then
    exit;

  // 12.05.2010 ingmar
  self.OnMiscChange(nil);


  with TRxDBLookupCombo(Sender) do
    try
      self.FSkipLComboEvents := True;

      // --------------
      if (Sender = self.FArticles) then
      begin
        // fookuse fix
        //self.FPaCurrColPos:=   CCol_ArtCode;
        if LookupSource.DataSet.IsEmpty then
        begin
          _callMsg(estbk_strmsg.SEArtNotFound, mtError, [mbOK], 0);
          exit;
        end;

        // ---
        Text := LookupSource.DataSet.FieldByName('artcode').AsString;



        // me pole veel andmestruktuuri loonud
        if not assigned(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
          self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos] := TArticleDataClass.Create; // !!!


        TArticleDataClass(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtCode := LookupSource.DataSet.FieldByName('artcode').AsString;
        TArticleDataClass(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtId := LookupSource.DataSet.FieldByName('id').AsInteger;



        self.gridBillLines.Cells[FPaCurrColPos, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('artcode').AsString;
        self.gridBillLines.Cells[CCol_ArtDesc, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('artname').AsString;
        self.gridBillLines.Cells[CCol_ArtUnit, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('unit').AsString;


        // 11.09.2010 Ingmar
        if (LookupSource.DataSet.FieldByName('special_type_flags').AsInteger and estbk_types.CArtSpTypeCode_PrepaymentFlag) =
          estbk_types.CArtSpTypeCode_PrepaymentFlag then
        begin
          self.gridBillLines.Cells[CCol_ArtUnit, FPaCurrRowPos] := '';
          self.gridBillLines.Cells[CCol_ArtAcc, FPaCurrRowPos] := '';
          self.gridBillLines.Cells[CCol_ArtPrice, FPaCurrRowPos] := '';
          self.gridBillLines.Cells[CCol_ArtDisc, FPaCurrRowPos] := '';
        end;


        // 23.12.2009 Ingmar; paneme paika kontod
        pPurchAcc := LookupSource.DataSet.FieldByName('purchase_account_id').AsInteger;
        if pPurchAcc < 1 then
          pPurchAcc := _ac.sysAccountId[_accPurchase];  //estbk_clientdatamodule.dmodule.defaultArtPurchAccount;


        pSaleAcc := LookupSource.DataSet.FieldByName('sale_account_id').AsInteger;
        if pSaleAcc < 1 then
          pSaleAcc := _ac.sysAccountId[_accSale]; // estbk_clientdatamodule.dmodule.defaultArtSaleAccount;


        pExpAcc := LookupSource.DataSet.FieldByName('expense_account_id').AsInteger;
        if pExpAcc < 1 then
          pExpAcc := _ac.sysAccountId[_accExpense];// estbk_clientdatamodule.dmodule.defaultArtExpAccount;


              {
              laokaup à kaup ostetakse sisse ning ei kanta kohe kulusse, vaid võetakse lattu arvele: D ladu, K HTA.
              Kui antud kaupa müüakse, alles siis kantakse müügitehingu ajal see laost kulusse.

              Kanne: D OLA
                     D kaubakulu
                     K käive (kaup)
                     K müügi km
                     K ladu
              }
        // currsale_price,p1.price as purchase_price
        case self.FCurrBillType of
          CB_salesInvoice:
          begin
            pPrice := LookupSource.DataSet.FieldByName('currsale_price').asCurrency; // müük
            pAccToUse := pSaleAcc;

            // --- kontod paika !
            self.chooseAccountForArticle(FPaCurrRowPos, pAccToUse);
          end;

          CB_purcInvoice:
          begin
            pPrice := LookupSource.DataSet.FieldByName('purchase_price').asCurrency; // ost
            pAccToUse := pPurchAcc;

            // --- kontod paika !
            self.chooseAccountForArticle(FPaCurrRowPos, pAccToUse);
          end;
        end;




        // 17.03.2010 Ingmar
        TArticleDataClass(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtOrigPrice := pPrice; // hind baasvaluutas !!!
        TArticleDataClass(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtPriceCalcMeth :=
          LookupSource.DataSet.FieldByName('price_calc_meth').AsString;

        // 11.09.2010 Ingmar
        TArticleDataClass(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtSpecialFlags :=
          LookupSource.DataSet.FieldByName('special_type_flags').AsInteger;



        // seoses valuutaga teisendame hinna antud valuutasse !
        pPrice := roundto(pPrice / self.getSelectedCurrExcRate, Z2);
        self.gridBillLines.Cells[CCol_ArtPrice, FPaCurrRowPos] := format(CCurrentMoneyFmt2, [pPrice]);


        // ---
        self.gridBillLines.Cells[CCol_ArtDisc, FPaCurrRowPos] := '0';
        self.gridBillLines.Cells[CCol_ArtAmount, FPaCurrRowPos] := format(CCurrentAmFmt4, [double(1)]);


              {
                // 11.09.2010 Ingmar; ettemaksu puhul ei pruugi seda olla !
                if self.FCurrBillType<>estbk_types.CB_prepaymentInvoice then
              }
        // --------
        // artikli käibemaks ka !
        pVATId := LookupSource.DataSet.FieldByName('vat_id').AsInteger;
        pVatFound := qryVat.Locate('id', integer(pVATId), []);


        // käibemaksu info juurde
        if not pVatFound then // kui pole km kohuslane, siis vaid üks rida EI ARVESTA
        begin
          pVatFound := (trim(estbk_globvars.glob_currcompvatnr) = '') and (qryVat.RecordCount > 0);
          if pVatFound then
          begin
            qryVat.First;
            pVATId := qryVat.FieldByName('id').AsInteger;
          end; // ---
        end;



        if pVatFound then
        begin

          self.gridBillLines.Cells[CCol_ArtVATid, FPaCurrRowPos] := qryVat.FieldByName('description').AsString;
          //qryVat.FieldByName('perc').asString;
          if not assigned(self.gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]) then
            self.gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos] := TVatDataClass.Create; // !!!!


          // 24.04.2010  Ingmar; nüüd vaja ka koheselt konto kirjet lahtrile
          if not assigned(self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos]) then
            self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos] := TAccountDataClass.Create; // !!!!


          TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]).FVatId := pVATId;
          TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]).FVatPerc := qryVat.FieldByName('perc').AsFloat;
          TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]).FVatLongDescr := qryVat.FieldByName('description').AsString;
          // 19.05.2011 Ingmar
          TVatDataClass(self.gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]).FVatFlags := qryVat.FieldByName('vatflags').AsInteger;




          // 22.07.2011 Ingmar; kui km ei arvestata, siis lahter ka tühjaks !
          if (qryVat.FieldByName('vatflags').AsInteger and estbk_types._CVtmode_dontAdd) = estbk_types._CVtmode_dontAdd then
          begin
            self.gridBillLines.Cells[CCol_ArtVATSum, FPaCurrRowPos] := format(CCurrentMoneyFmt2, [0.00]);
            self.gridBillLines.Cells[CCol_ArtPercFromVat, FPaCurrRowPos] := format(CCurrentMoneyFmt2, [0.00]);
          end;

          // LookupSource.DataSet.FieldByName('special_type_flags').AsInteger
          pDefaultVatAccId := self.getVatQryDefAccountId();




          try
            pBookmark := qryGetAccounts.GetBookmark;
            qryGetAccounts.DisableControls;

            with TAccountDataClass(self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos]) do
              if qryGetAccounts.Locate('id', pDefaultVatAccId, []) then
              begin
                FAccCode := qryGetAccounts.FieldByName('account_coding').AsString;
                FAccId := pDefaultVatAccId;
                self.gridBillLines.Cells[CCol_ArtVATAccid, FPaCurrRowPos] := FAccCode;
              end
              else
              begin
                FAccCode := '';
                FAccId := 0;
                self.gridBillLines.Cells[CCol_ArtVATAccid, FPaCurrRowPos] := '';
              end;



            // ----
          finally

            qryGetAccounts.GotoBookmark(pBookmark);
            qryGetAccounts.EnableControls;
            qryGetAccounts.FreeBookmark(pBookmark);
          end;

        end
        else
          _callMsg(estbk_strmsg.SEArtVatNotFound, mtError, [mbOK], 0);


        if self.isInternalArticleType(FPaCurrRowPos, FPaCurrColPos, pDummy2) then
          gridBillLines.Repaint;

        // ---
      end
      else
      // --------------
      if (Sender = self.FAccounts) or (Sender = self.FVATAccounts) then
      begin
        //fookuse fix
        //self.FPaCurrColPos:=  CCol_ArtAcc;
        Text := LookupSource.DataSet.FieldByName('account_coding').AsString;


        // 22.04.2010 Ingmar; nüüd on artikli valik vaba,
        // selletõttu võimaldame artikli struktuuri ära kirjeldada konto valimisel
        if not assigned(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
          self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos] := TAccountDataClass.Create; // !!!


        if not assigned(self.gridBillLines.Objects[CCol_ArtCode, FPaCurrRowPos]) then
          self.gridBillLines.Objects[CCol_ArtCode, FPaCurrRowPos] := TArticleDataClass.Create; // !!!


        // ---
        TAccountDataClass(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FAccCode :=
          LookupSource.DataSet.FieldByName('account_coding').AsString;
        TAccountDataClass(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FAccId := LookupSource.DataSet.FieldByName('id').AsInteger;

        self.gridBillLines.Cells[FPaCurrColPos, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('account_coding').AsString;

        if (self.FCurrBillType = CB_purcInvoice) and (Sender = self.FAccounts) and
          (trim(self.gridBillLines.Cells[CCol_ArtDesc, FPaCurrRowPos]) = '') and
          (trim(self.gridBillLines.Cells[CCol_ArtCode, FPaCurrRowPos]) = '') then
          self.gridBillLines.Cells[CCol_ArtDesc, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('account_name').AsString;

      end
      else
      // --------------
      if (Sender = self.FVat) then
      begin
        Text := trim(qryVat.FieldByName('description').AsString);

        // ---
        if Text = '' then
          Text := LookupSource.DataSet.FieldByName('perc').AsString;

        if not assigned(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
          self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos] := TVatDataClass.Create; // !!!


        if not assigned(self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos]) then
          self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos] := TAccountDataClass.Create; // !!!




        // 13.04.2010 Ingmar
           {
           if (LookupSource.DataSet.FieldByname('vatflags').asInteger and estbk_types._CVtmode_dontAdd)=estbk_types._CVtmode_dontAdd then
             begin
               self.gridBillLines.Cells[FPaCurrColPos,FPaCurrRowPos]:=estbk_strmsg.SCaptNoVat;
               TVatDataClass(self.gridBillLines.Objects[FPaCurrColPos,FPaCurrRowPos]).FVatSkip:=true;
             end else
             begin }
        self.gridBillLines.Cells[FPaCurrColPos, FPaCurrRowPos] := Text; //LookupSource.DataSet.FieldByName('perc').asString;
        TVatDataClass(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatFlags :=
          LookupSource.DataSet.FieldByName('vatflags').AsInteger;
            {
             end;
            }

        TVatDataClass(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatId := LookupSource.DataSet.FieldByName('id').AsInteger;
        TVatDataClass(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatPerc := LookupSource.DataSet.FieldByName('perc').AsFloat;
        TVatDataClass(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FVatLongDescr :=
          LookupSource.DataSet.FieldByName('description').AsString;



        // 20.04.2015 Ingmar
        if (LookupSource.DataSet.FieldByName('vatflags').AsInteger and estbk_types._CVtmode_carVAT50) = estbk_types._CVtmode_carVAT50 then
          self.gridBillLines.Cells[CCol_ArtPercFromVat, FPaCurrRowPos] := format(CCurrentMoneyFmt2, [50.00])
        else
          self.gridBillLines.Cells[CCol_ArtPercFromVat, FPaCurrRowPos] := format(CCurrentMoneyFmt2, [100.00]);



        // --- vaatab,  millist km kontot kasutada, sõltub arve tüübist !
        pDefaultVatAccId := self.getVatQryDefAccountId();


        with TAccountDataClass(self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos]) do
          if qryGetAccounts.Locate('id', pDefaultVatAccId, []) then
          begin
            FAccCode := qryGetAccounts.FieldByName('account_coding').AsString;
            FAccId := pDefaultVatAccId;
            self.gridBillLines.Cells[CCol_ArtVATAccid, FPaCurrRowPos] := FAccCode;
          end
          else
          begin
            FAccCode := '';
            FAccId := 0;
            self.gridBillLines.Cells[CCol_ArtVATAccid, FPaCurrRowPos] := '';
          end;
        // ---
      end
      else
      // --------------
      if (Sender = self.FObjects) then
      begin
        Text := LookupSource.DataSet.FieldByName('descr').AsString;

        if not assigned(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
          self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos] := TObjectDataClass.Create; // !!!


        // ---
        TObjectDataClass(self.gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FObjectID :=
          LookupSource.DataSet.FieldByName('id').AsInteger;
        self.gridBillLines.Cells[FPaCurrColPos, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('descr').AsString;
      end;


      // -- arvutame rea ümber
      // 15.01.2010 Ingmar
      //self.calcArtSum(FPaCurrRowPos);
      self.calcArtSum(self.gridBillLines.Row);




      // 08.09.2010 Ingmar; lazaruse ebameeldivad üllatused jätkuvad
      //if gridBillLines.CanFocus then
      // gridBillLines.SetFocus;

    finally
      self.FSkipLComboEvents := False;
    end;

  // ---
  // 09.08.2010 Ingmar; ikka likvideerin lazaruse bugisid
  lazFocusFix.Enabled := True;
end;

procedure TframeBills.OnLookupComboEnter(Sender: TObject);
begin
  // ---
end;

procedure TframeBills.OnLookupComboExit(Sender: TObject);
begin
  // ---
end;


// --
procedure TframeBills.OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  FGotoNextCell: boolean;
begin
  self.FKeyboardEventTriggered := True;

  // --
  if self.FGridReadOnly then
  begin
    key := 0;
    exit;
  end;

  // ---
  if (key = VK_DELETE) and (Shift = [ssCtrl]) then
  begin
    deleteBillLine(self.FPaCurrRowPos);
    //deleteBillLine(TStringGrid(Sender).row);
    key := 0;
  end;


  // avame artiklite nimistu;
  if (Sender = self.FArticles) and (key = Ord(' ')) and (Shift = [ssCtrl]) then
    try
      self.FNewArticleWndOpened := True;

      // 29.05.2011 Ingmar
      if assigned(self.FFrameDataEvent) then
        self.FFrameDataEvent(self, __frameOpenArticleEntry, 0, nil);
      key := 0;
      //--

    finally
      // self.FNewArticleWndOpened:=false;
    end
  else
  if (shift = []) then
    with TRxDBLookupCombo(Sender) do
    begin

      // --------------------------------

      case key of
        //VK_ESCAPE:
        VK_DELETE:
          try
            self.FSkipLComboEvents := True;
            // ---
            if Sender = self.FArticles then
            begin

              if assigned(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
              begin

                if not allowArtChange() then
                  exit;


                Text := '';
                Value := '';


                // nagu pearaamatus ärme veel struktuuri kustuta
                //gridBillLines.Cells[FPaCurrColPos, FPaCurrRowPos]:='';
                if assigned(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]) then
                begin
                  TArticleDataClass(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtCode := '';
                  TArticleDataClass(gridBillLines.Objects[FPaCurrColPos, FPaCurrRowPos]).FArtId := 0;
                end;


                // --- peame nullima ka artikliga seotud konto välja !!!!
                // gridBillLines.Cells[CCol_ArtAcc, FPaCurrRowPos]:='';
                if assigned(gridBillLines.Objects[CCol_ArtAcc, FPaCurrRowPos]) then
                begin
                  TAccountDataClass(gridBillLines.Objects[CCol_ArtAcc, FPaCurrRowPos]).FAccCode := '';
                  TAccountDataClass(gridBillLines.Objects[CCol_ArtAcc, FPaCurrRowPos]).FAccId := 0;
                end;



                // !!!!!!!!!!!!!!!!!!!!!!!!!
                // tühjendame lahtrid
                self.gridBillLines.Clean(CCol_ArtCode, FPaCurrRowPos, CCol_ArtSumTotal, FPaCurrRowPos, [gzNormal]);

                // if gridBillLines.CanFocus then
                //    gridBillLines.SetFocus;

                lazFocusFix.Enabled := True; // ***
                key := 0;
                // ---
              end;

            end
            else
            if Sender = self.FAccounts then
            begin
              Text := '';
              Value := '';
              gridBillLines.Cells[CCol_ArtAcc, FPaCurrRowPos] := '';
              // ---
              if assigned(gridBillLines.Objects[CCol_ArtAcc, FPaCurrRowPos]) then
                with TAccountDataClass(gridBillLines.Objects[CCol_ArtAcc, FPaCurrRowPos]) do
                begin
                  FAccId := 0;
                  FAccCode := '';
                end;


              lazFocusFix.Enabled := True; // ***
              key := 0;
              // ---
            end
            else
            if Sender = self.FVAT then
            begin
              Text := '';
              Value := '';
              gridBillLines.Cells[CCol_ArtVATid, FPaCurrRowPos] := '';
              // ---
              if assigned(gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]) then
                with TVatDataClass(gridBillLines.Objects[CCol_ArtVATid, FPaCurrRowPos]) do
                begin
                  FVatId := 0;
                  FVatPerc := 0;
                  FVatLongDescr := '';
                  FVatFlags := 0;
                end;

              lazFocusFix.Enabled := True; // ***
              key := 0;
            end
            else
            if Sender = self.FVATAccounts then
            begin
              Text := '';
              Value := '';
              gridBillLines.Cells[CCol_ArtVATAccid, FPaCurrRowPos] := '';

              // 13.05.2011 ingmar; koodi seisukohalt jätame siiski struktuuri alles !
              if assigned(self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos]) then
              begin
                TAccountDataClass(self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos]).FAccCode := '';
                TAccountDataClass(self.gridBillLines.Objects[CCol_ArtVATAccid, FPaCurrRowPos]).FAccId := 0;
              end;

              lazFocusFix.Enabled := True; // ***
              key := 0;
            end
            else
            // 18.08.2011 Ingmar
            if Sender = self.FObjects then
            begin
              Text := '';
              Value := '';
              gridBillLines.Cells[CCol_ArtObject, FPaCurrRowPos] := '';

              if assigned(self.gridBillLines.Objects[CCol_ArtObject, FPaCurrRowPos]) then
                TObjectDataClass(self.gridBillLines.Objects[CCol_ArtObject, FPaCurrRowPos]).FObjectID := 0;


              lazFocusFix.Enabled := True; // ***
              key := 0;
            end;

            // -- vk_delete end
          finally
            self.FSkipLComboEvents := False;
          end;

        VK_LEFT: if not popUpVisible then
          begin
            // DroppedDown := False;
            // muidu meil fookusega kööga
            //Visible := False;
            if gridBillLines.Col - 1 > 0 then
              if gridBillLines.Columns.Items[gridBillLines.Col - 2].Visible then
                gridBillLines.Col := gridBillLines.Col - 1
              else
                gridBillLines.Col := gridBillLines.Col - 2;

            _focus(gridBillLines);
            key := 0;
            self.FKeyboardEventTriggered := True;
            //self.lazFocusFix.Enabled:=true;
          end;

        VK_RETURN,
        VK_TAB,
        VK_RIGHT: if not popUpVisible then
          begin
            //DroppedDown := False;
            //Visible := False;
            self.performColForwardMove;

            _focus(gridBillLines);
            // --
            self.FKeyboardEventTriggered := True;
            key := 0;

          end;

        VK_DOWN,
        VK_NEXT: if not popUpVisible then
          begin
            //Visible := False;
            //DroppedDown := False;
            if gridBillLines.Row + 1 <= gridBillLines.RowCount then
              gridBillLines.Row := gridBillLines.Row + 1;

            _focus(gridBillLines);
            // ---
            self.FKeyboardEventTriggered := True;
            key := 0;
          end;

        VK_UP,
        VK_PRIOR: if not popUpVisible then
          begin
            if gridBillLines.Row - 1 > 0 then
              gridBillLines.Row := gridBillLines.Row - 1;


            _focus(gridBillLines);
            // ---
            self.FKeyboardEventTriggered := True;
            key := 0;
          end;
      end;
      // --------------------------------

    end;
end;



procedure TframeBills.defineInMemTableStructs;
begin
  with qInvoiceMemDataset do
  begin
    Active := False;
    FieldDefs.Clear;
    //CreateTable;
    // arve andmed; bl = bill
    // !!!!!!!!!!!!! kui panin väljale pikkuse tuli tore AV !!!
    FieldDefs.Add('blnotes', ftString, 512);
    // artikli andmed
    FieldDefs.Add('artcode', ftString, 30); // 30
    FieldDefs.Add('artdescr', ftString, 200); // 200
    FieldDefs.Add('artunit', ftString, 30); // 30
    FieldDefs.Add('artqty', ftFloat, 0);
    FieldDefs.Add('artprice', ftFloat, 0);
    FieldDefs.Add('artvatperc', ftFloat, 0);
    FieldDefs.Add('artvatid', ftInteger, 0);
    FieldDefs.Add('artdiscount', ftFloat, 0);
    FieldDefs.Add('artpricetotal', ftFloat, 0);
    FieldDefs.Add('artvatlongname', ftString, 85); // 85
    // 11.04.2013 Ingmar; toome ka objekti võimaluse sisse
    FieldDefs.Add('artobject', ftString, 512);




    // firma rekvisiidid
    FieldDefs.Add('compphone', ftString, 40);  // 40
    FieldDefs.Add('compfax', ftString, 40);  // 40
    FieldDefs.Add('compemail', ftString, 40); // 40


    FieldDefs.Add('cmpcountry', ftString, 85); // 85
    FieldDefs.Add('cmpcounty', ftString, 85); // 85
    FieldDefs.Add('cmpcity', ftString, 85);  // 85
    FieldDefs.Add('cmpstreet', ftString, 85);  // 85
    FieldDefs.Add('cmphousenr', ftString, 85); // 65
    FieldDefs.Add('cmpflatnr', ftString, 85); // 65

  end;
end;

constructor TframeBills.Create(frameOwner: TComponent);
var
  i: integer;
  pCol: TColor;
  pCollItem: TCollectionItem;
  pGridEditor: TStringCellEditor;
begin
  try
    // -------
    inherited Create(frameOwner);
        {$ifdef debugmode}
    FAccDebug := TAStrList.Create;
        {$endif}

    //(gridBillLines.EditorByStyle(cbsPickList) as TPickListCellEditor).OnEditingDone:=@self.OnMiscChange;
    // 02.12.2011 Ingmar; arve koopia
    FCopyObjs := TObjectList.Create(True);
    FDeletedBillLines := TObjectList.Create;
    FReportSumFtrData := TAStrList.Create;

    // -------
    estbk_uivisualinit.__preparevisual(self);
    FCurrBillType := CB_salesInvoice;
    //btnNewCust.Font.Style := [fsBold];

    // readonly väljad teistvärvi
    pCol := cl3DLight; // estbk_types.MyFavGray;




    //edtCustname.Color:=pCol;
    edtCustAddr.Color := pCol;
    //edtBillNr.Color:=pCol;
    edtSumWOVatBc.Color := pCol;
    edtVatSumBc.Color := pCol;
    edtRoundBc.Color := pCol;
    edtBillSumTotalBc.Color := pCol;

        {
        edtSumWOVatBco.Color:=pCol;
        edtVatSumBco.Color:=pCol;
        edtRoundBco.Color:=pCol;
        edtBillSumTotalBco.Color:=pCol;
        }
    lblBillSumTotal.Font.Style := [fsBold];

    // 30.12.2009 Ingmar; artiklite nimistu on ilusam comboga tehes !
    // artiklite nimistu
    FArticles := TRxDBLookupCombo.Create(self.gridBillLines);
    FArticles.Name := 'Farticles';
    FArticles.parent := self.gridBillLines;
    FArticles.Visible := False;

    FArticles.ParentFont := False;
    FArticles.ParentColor := False;
    FArticles.ShowHint := True;
    FArticles.DoubleBuffered := True;
    FArticles.OnEnter := @self.OnLookupComboEnter;
    FArticles.OnExit := @self.OnLookupComboExit;
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

    FArticles.OnEnter := @self.OnLookupComboEnter;
    FArticles.OnExit := @self.OnLookupComboExit;
    FArticles.OnSelect := @self.OnLookupComboSelect;
    FArticles.OnChange := @self.OnLookupComboChange;
    FArticles.OnClosePopupNotif := @self.OnLookupComboPopupClose;
    FArticles.OnKeyDown := @self.OnLookupComboKeydown;




    FArticles.LookupSource := self.qryGetArticlesDs;
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


    // --------------------------------------------
    // artikliga seotud kontod
    FAccounts := TRxDBLookupCombo.Create(self.gridBillLines);
    FAccounts.parent := self.gridBillLines;
    FAccounts.Visible := False;
    FAccounts.Name := 'FAccounts';
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




    //FAccounts.OnChange:=@self.OnLookupComboSelect;
    //FAccounts.OnClick:=@self.OnLookupComboSelect;

    FAccounts.Left := CLeftHiddenCorn;
    FAccounts.Flat := True;
    FAccounts.EmptyValue := #32;
    FAccounts.UnfindedValue := rxufNone;
    FAccounts.DropDownCount := 15;
    FAccounts.DropDownWidth := 330;

    FAccounts.ButtonWidth := 15;
    FAccounts.ButtonOnlyWhenFocused := False;
    FAccounts.Height := 23;
    FAccounts.PopUpFormOptions.ShowTitles := True;
    FAccounts.PopUpFormOptions.TitleButtons := True;

    // --------------------------------------------
    // käibemaksud
    FVAT := TRxDBLookupCombo.Create(self.gridBillLines);
    FVAT.parent := self.gridBillLines;
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



    FVAT.OnEnter := @self.OnLookupComboEnter;
    FVAT.OnExit := @self.OnLookupComboExit;
    FVAT.OnSelect := @self.OnLookupComboSelect;
    FVAT.OnChange := @self.OnLookupComboChange;
    FVAT.OnClosePopupNotif := @self.OnLookupComboPopupClose;
    FVAT.OnKeyDown := @self.OnLookupComboKeydown;


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
    FVAT.OnGetGridCellProps := @self.OnLookupGetGridCellProps;
    FVAT.PopUpFormOptions.OnGetCellProps := @self.OnLookupGetGridCellProps;




    // ------------
    // käibemaksude kontod !

    FVATAccounts := TRxDBLookupCombo.Create(self.gridBillLines);
    FVATAccounts.parent := self.gridBillLines;
    FVATAccounts.Visible := False;

    FVATAccounts.ParentFont := False;
    FVATAccounts.ParentColor := False;
    FVATAccounts.ShowHint := True;
    FVATAccounts.DoubleBuffered := True;

    FVATAccounts.Name := 'FVATAccounts';

    FVATAccounts.LookupSource := self.qryGetAccountsDs;
    FVATAccounts.LookupDisplay := 'account_coding;account_name';
    FVATAccounts.LookupField := 'id';


    pCollItem := FVATAccounts.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccCode;
    (pCollItem as TPopUpColumn).Fieldname := 'account_coding';
    (pCollItem as TPopUpColumn).Width := 85;


    pCollItem := FVATAccounts.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccName;
    (pCollItem as TPopUpColumn).Fieldname := 'account_name';
    (pCollItem as TPopUpColumn).Width := 215;


    FVATAccounts.OnEnter := @self.OnLookupComboEnter;
    FVATAccounts.OnExit := @self.OnLookupComboExit;
    FVATAccounts.OnSelect := @self.OnLookupComboSelect;
    FVATAccounts.OnChange := @self.OnLookupComboChange;
    FVATAccounts.OnClosePopupNotif := @self.OnLookupComboPopupClose;
    FVATAccounts.OnKeyDown := @self.OnLookupComboKeydown;



    FVATAccounts.Left := CLeftHiddenCorn;
    FVATAccounts.Flat := True;
    FVATAccounts.EmptyValue := #32;
    FVATAccounts.UnfindedValue := rxufNone;
    FVATAccounts.DropDownCount := 15;
    FVATAccounts.DropDownWidth := 330;

    FVATAccounts.ButtonWidth := 15;
    FVATAccounts.ButtonOnlyWhenFocused := False;
    FVATAccounts.Height := 23;
    FVATAccounts.PopUpFormOptions.ShowTitles := True;
    FVATAccounts.PopUpFormOptions.TitleButtons := True;



    // 19.08.2011 Ingmar
    // objektid;
    FObjects := TRxDBLookupCombo.Create(self.gridBillLines);
    FObjects.parent := self.gridBillLines;
    FObjects.Visible := False;

    FObjects.ParentFont := False;
    FObjects.ParentColor := False;
    FObjects.ShowHint := True;
    FObjects.DoubleBuffered := True;

    FObjects.Name := 'FObjects';

    FObjects.LookupSource := self.qryGetObjectsDs;
    FObjects.LookupDisplay := 'descr';
    FObjects.LookupField := 'id';



    pCollItem := FObjects.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccObjName;
    (pCollItem as TPopUpColumn).Fieldname := 'descr';
    (pCollItem as TPopUpColumn).Width := 255;


    FObjects.OnEnter := @self.OnLookupComboEnter;
    FObjects.OnExit := @self.OnLookupComboExit;
    FObjects.OnSelect := @self.OnLookupComboSelect;
    FObjects.OnChange := @self.OnLookupComboChange;
    FObjects.OnClosePopupNotif := @self.OnLookupComboPopupClose;
    FObjects.OnKeyDown := @self.OnLookupComboKeydown;



    FObjects.Left := CLeftHiddenCorn;
    FObjects.Flat := True;
    FObjects.EmptyValue := #32;
    FObjects.UnfindedValue := rxufNone;
    FObjects.DropDownCount := 15;
    FObjects.DropDownWidth := 278;

    FObjects.ButtonWidth := 15;
    FObjects.ButtonOnlyWhenFocused := False;
    FObjects.Height := 23;
    FObjects.PopUpFormOptions.ShowTitles := True;
    FObjects.PopUpFormOptions.TitleButtons := True;



    // billDate.Date:=now;
    // billDate.Text:=datetostr(billDate.Date);

    self.setWarehouseMode(False);
    estbk_utilities.changeWCtrlEnabledStatus(grpClientData, False);
    estbk_utilities.changeWCtrlEnabledStatus(grpBoxBill, False);
    estbk_utilities.changeWCtrlEnabledStatus(panelbottom, False);


    estbk_utilities.changeWCtrlReadOnlyStatus(grpClientData, True);
    estbk_utilities.changeWCtrlReadOnlyStatus(grpBoxBill, True);
    estbk_utilities.changeWCtrlReadOnlyStatus(mmVatSpecs, True);



    lblWarehouse.Enabled := False;
    cmbWareHouses.Color := clBtnFace;
    cmbWareHouses.Enabled := False;


    // ---
    //chkBoxCreditBill.enabled:=false;
    chkBillConfirmed.Enabled := False;
    //chkReqBillChange.enabled:=false;



    self.FGridReadOnly := True;
    panelbottom.Color := estbk_types.MyFavOceanBlue;
    taskPanel.Color := estbk_types.MyFavGray;



    // -------
    self.defineInMemTableStructs;
    cmbCurrencyList.ShowHint := True;


    lblBillStatus.Font.Style := [fsBold];
    lblPmtStatus.Font.Style := [fsBold];
    lblUsedPrepayment.Font.Style := [fsBold];


    self.addOnChangeHandlers;
    qInvoiceMemDataset.Active := False;

    // 13.05.2011 Ingmar; Igakord ei arvutagi andmeid, EditingDone event töötab lazaruses nagu tuju on
    TStringCellEditor(gridBillLines.EditorByStyle(cbsAuto)).OnExit := @self.OnStringCellEditorExitFix;


    TStringCellEditor(gridBillLines.EditorByStyle(cbsAuto)).OnChange := @self.OnMiscChange;
    TStringCellEditor(gridBillLines.EditorByStyle(cbsAuto)).OnKeyDown := @self.gridBillLinesKeyDown;
    // nii kuratlikult tobe, lazarusel on MDI kala, mis ei suuna klikkimisel fookust TEdit tüüpi elementidele !
    TStringCellEditor(gridBillLines.EditorByStyle(cbsAuto)).OnClick := @self.OnEditorFocusFixClick;


    TPickListCellEditor(gridBillLines.EditorByStyle(cbsPicklist)).OnKeyDown := @self.gridBillLinesKeyDown;



    FVat.ShowHint := True;
    FAccounts.ShowHint := True;
    FVATAccounts.ShowHint := True;
    FArticles.ShowHint := True;



    cmbPaymentTerm.Items.Assign(dmodule.paymentTerms);
    cmbPaymentTerm.Items.Insert(0, ''); // defineerimata tingimus !
    for i := 0 to cmbPaymentTerm.Items.Count - 1 do
      if (cmbPaymentTerm.Items.Strings[i] <> '') and (ptrInt(cmbPaymentTerm.Items.Objects[i]) < 365) then
      begin
        cmbPaymentTerm.ItemIndex := i;
        break;
      end;

    // ---
    // 29.05.2011 Ingmar
    cmbSalePuchAcc.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
    FArticles.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
    FAccounts.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
    FVAT.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
    FVATAccounts.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
    FObjects.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;


    if not isTrueVal(dmodule.userStsValues[estbk_settings.CstsShowObjFieldInBillLines]) then //estbk_types.SCFalseTrue[true]
    begin
      gridBillLines.Columns.Items[CCol_ArtObject - 1].Visible := False;
      gridBillLines.Columns.Items[CCol_ArtObject - 1].Width := 0;
    end;

    // 20.04.2015 Ingmar
    if not isTrueVal(dmodule.userStsValues[estbk_settings.CstsShowVATReturnFieldInBillLines]) then
    begin
      gridBillLines.Columns.Items[CCol_ArtPercFromVat - 1].Visible := False;
      gridBillLines.Columns.Items[CCol_ArtPercFromVat - 1].Width := 0;
    end;

  except
    on e: Exception do
      // ---
      _callMsg(format(estbk_strmsg.SEInitializationZError, [e.message, self.ClassName]), mtError, [mbOK], 0);
  end;
end;

destructor TframeBills.Destroy;
begin
  try
    {$ifdef debugmode}
    FreeAndNil(FAccDebug);
    {$endif}
    FreeAndNil(FCopyObjs);
    // showmessage('check:bills->destroy');
    clearStrObject(TAStrings(FCurrList));
    FreeAndNil(FCurrList);
    FDeletedBillLines.Clear;
    FreeAndNil(FDeletedBillLines);
    FreeAndNil(FReportSumFtrData);

    if assigned(self.FClientData) then
      FreeAndNil(self.FClientData);

    dmodule.notifyNumerators(PtrUInt(self));
  except
  end;

  inherited Destroy;
end;


initialization
  {$I estbk_fra_bills.ctrs}

end.