unit estbk_fra_generalledger;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
{$ASSERTIONS ON}
//{$TYPEINFO ON}
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, Grids, Contnrs, fgl,
  Controls, Graphics, LCLType, ExtCtrls, Buttons, Messages, estbk_fra_template, estbk_settings,
  estbk_frm_choosecustmer, Dialogs, Calendar, EditBtn, ClipBrd, estbk_types,
  estbk_utilities, estbk_lib_commonevents, estbk_lib_commonaccprop, estbk_globvars, LCLProc,
  estbk_reportconst, estbk_clientdatamodule, estbk_strmsg, estbk_uivisualinit,
  estbk_lib_commoncls, DB, memds, rxpopupunit, rxdbgrid, rxlookup, Math,
  RTTICtrls, LR_Class, LR_DBSet, ZDataset, ZSequence, ZSqlUpdate, Menus, types;

// sisuliselt programmi esimene moodul, mis algselt oli vaid testimiseks :))))
// #8 viimane assertion viga !!!
// -------------------------


const
  CShiftItemsLeft = -200;

const
  CAccountColWidth = 75;

// nr;selgitus;konto;deebet;kreedit
//type
//  TEventStub = procedure(sender : TObject) of Object;

type

  { TframeGeneralLedger }

  TframeGeneralLedger = class(Tfra_template)
    btnChooseOutput: TBitBtn;
    btnOutput: TBitBtn;
    btnNewEntry: TBitBtn;
    btnClose: TBitBtn;
    btnCopy: TBitBtn;
    btnSaveEntry: TBitBtn;
    btnCancelGd: TBitBtn;
    btnCancel: TBitBtn;
    cmbDocumentType: TComboBox;
    MenuItem1: TMenuItem;
    mnuRowAct: TPopupMenu;
    repData: TfrDBDataSet;
    repGenLedger: TfrReport;
    qsMemDataSetForRep: TMemDataset;
    mnuItemCsv: TMenuItem;
    mnuItemPrinter: TMenuItem;
    popupChooseOutput: TPopupMenu;
    qryObjectsGrpsDs: TDatasource;
    qryObjectsGrps: TZQuery;
    qryObjectsDs: TDatasource;
    qryAllAccountsDS: TDatasource;
    edtAccdate: TDateEdit;
    edtTransDescr: TEdit;
    edtDocNr: TEdit;
    edtAccnr: TEdit;
    lblDocnr: TLabel;
    lblAccNr: TLabel;
    lblAccDate: TLabel;
    lblAccDocType: TLabel;
    lblTrasDescr: TLabel;
    lblFix: TLabel;
    lblTotalBkArea: TLabel;
    ovrAllGrpbox: TGroupBox;
    plinee1: TBevel;
    plinee2: TBevel;
    accountingGrid: TStringGrid;
    qryDocumentTypes: TZQuery;
    qryObjects: TZQuery;
    dlgAccFile: TSaveDialog;
    stxtCPart: TEdit;
    stxtDPart: TEdit;
    qryAccreEntryObjSeq: TZSequence;
    qryAccData: TZQuery;
    qryAccReqObjects: TZReadOnlyQuery;
    qryAllAccounts: TZQuery;
    lazObjchangeTimer: TTimer;
    lazFocusFix: TTimer;

    procedure accountingGridClick(Sender: TObject);
    procedure accountingGridDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure accountingGridEditButtonClick(Sender: TObject);
    procedure accountingGridEditingDone(Sender: TObject);
    procedure accountingGridEnter(Sender: TObject);
    procedure accountingGridExit(Sender: TObject);
    procedure accountingGridGetEditMask(Sender: TObject; ACol, ARow: integer; var Value: string);
    procedure accountingGridHeaderClick(Sender: TObject; IsColumn: boolean; Index: integer);
    procedure accountingGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure accountingGridKeyPress(Sender: TObject; var Key: char);
    procedure accountingGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure accountingGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure accountingGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure accountingGridMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
    procedure accountingGridPickListSelect(Sender: TObject);
    procedure accountingGridPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
    procedure accountingGridSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
    procedure accountingGridSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelGdClick(Sender: TObject);
    procedure btnChooseOutputClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnNewEntryClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure btnSaveEntryClick(Sender: TObject);
    procedure cmbDocumentTypeChange(Sender: TObject);
    procedure edtAccdateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure edtAccdateChange(Sender: TObject);
    procedure edtAccdateExit(Sender: TObject);
    procedure edtAccdateKeyPress(Sender: TObject; var Key: char);
    procedure edtAccnrExit(Sender: TObject);
    procedure edtAccnrKeyPress(Sender: TObject; var Key: char);
    procedure edtDocNrExit(Sender: TObject);
    procedure lazObjchangeTimerTimer(Sender: TObject);
    procedure lazFocusFixTimer(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure mnuItemCsvClick(Sender: TObject);
    procedure qryAllAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure repGenLedgerBeginBand(Band: TfrBand);
    procedure repGenLedgerGetValue(const ParName: string; var ParValue: variant);
  private
    FOrigDateStr: AStr;
    FOrigDocTypeIndx: integer;
    FObjectColCnt: integer;

    // 27.11.2011 Ingmar; teeme kandest koopia
    FCopyObjs: TObjectList;
    FCopyDescr: AStr;
    FCopyDocIndx: integer;

    // ----
    //FObjectGrps      : TStringlist;
    FGridCleanup: boolean; // puhastame gridi, siis ei tekita me combosid !
    FGridReadOnly: boolean;
    // 20.11.2009 Ingmar; lihtsalt dblookup tekitab rohkem probleeme
    //FRestoreStrGridFocus : Boolean;
    // me ei võimalda inimestel valida kontosid, mis suletud !!
    FHideClosedAccounts: boolean;
    //FObjListOpenclick : Boolean;
    FInsertMode: boolean;

    // TLookupComboList eventide abi
    FSkipOnChangeSelectEvents: boolean;
    FSkipEditorSelect: boolean;

    // 20.11.2009 Ingmar; asendasin TDbLookupcomboga, palju parem disain, varasem nö "i-s"
    //FAccListCombo : TCombobox;
    FAccListCombo: TRxDBLookupCombo;
    //FAccObjTypes  : TCombobox;
    // onenter/onexit ikka täiesti möödas sellel komponendil; pane loenduri peale
    FAccObjGroups: TRxDBLookupCombo;
    FAccObjTypes: TRxDBLookupCombo;

    FPaCurrColPos: integer;
    FPaCurrRowPos: integer;

    FLastDSideSum: double;
    FLastCSideSum: double;

    // 22.11.2009 Ingmar; kuna ikka DBLookupComboEvendid on täiesti sassis,
    // kui kasutada teda editoris, siis peame ikka tegema väga rõvedaid hacke !
    // Tulevikus uurime edasi, kas on võimalik inimlikult asju teha !!
    FPaObjComboExitRefCnt: integer;
    FPaObjSkipExitEvent: boolean;

    // ehk sisenedes on koheselt onExit ?
    FPaAccComboExitRefCnt: integer;


    // valuuta kursside picklist info
    FLastPickListCol: integer;
    FLastPickListRow: integer;


    FObjCombItemIndx: integer;
    FOpenedEntryId: integer;
    FOpenedEntryBaseDocId: int64;
    // --------

    // sellega jälgime, kas peame uuesti kontode ja objektide nimistu laadima
    FAccObjCheck: integer;
    // loome nö muudatuste stringi; mille abil vaatame, kas reaalselt ka kanderead muutusid !
    // MD5 oleks ka variant, aga meie lahenduses pole see hea
    FAccRowsChkStr: AStr;
    FAccHeaderChkStr: AStr; // kas kande üldises infos ka midagi muutus
    FCurrDataList: TAStrList;
    FDocumentTypesList: TAStrList;
    // --------
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FReqTaskbarEvent: TTaskBarNotEvent;
    FReqCurrUpdate: TRequestForCurrUpdate;

    FRepDefFile: AStr;
    // --------
    FOrigGridWndProc: TWndMethod;
    // 11.04.2013 Ingmar
    FDebitSumTotal: double;
    FCreditSumTotal: double;

    procedure newGridWindowProc(var Message: TMessage);
    function allowDocumentsWithPrefix(const pDocPrefix: AStr): boolean;
    procedure displayAllowedDocs(const pAllTypes: boolean = True);
    function isBalanceInitDocument(): boolean; // kontrollime, kas valitud dokument on algsaldode seadistamise reziimis !
    function isAccPerClosingDocument(): boolean;


    // ----
    function getLoadStatus: boolean;
    procedure setLoadStatus(const v: boolean);
    procedure performCleanup;

    procedure detectChangesAndEnableSaveBtn;
    function resolveAccountNamebyCode(const paccCode: AStr): AStr;

    procedure initMemoryTable;
    procedure fillMemoryTable;

    // 15.05.2011 Ingmar; tegin lazaruse uuenduse, ülla ülla onEditingDone ei tööta !!! Vähemalt nii nagu peaks !
    procedure OnStringCellEditorExitFix(Sender: TObject);
    // ----
    procedure OnLookupPopupClose(Sender: TObject; SearchResult: boolean);
    procedure OnDbLookupComboSelColor(Sender: TObject; Field: TField; AFont: TFont; var Background: TColor);

    procedure OnAccListComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure OnAccListChange(Sender: TObject);
    procedure OnAccComboSelect(Sender: TObject);

    procedure OnLookupCmbEnter(Sender: TObject);
    procedure OnLookupCmbExit(Sender: TObject);
    procedure OnLookupCmbChange(Sender: TObject);


    // ----
    procedure OnObjTypeComboEnter(Sender: TObject);
    procedure OnObjTypeListComboExit(Sender: TObject);
    //procedure OnObjListCloseup(Sender: TObject);
    procedure OnObjListSelect(Sender: TObject);
    procedure OnObjListChange(Sender: TObject);
    procedure OnObjListClick(Sender: TObject);

    procedure OnPickListEnter(Sender: TObject);
    procedure OnPickListExit(Sender: TObject);

    procedure OnGridEditorChangeEvnt(Sender: TObject);
    procedure OnGridEditorClickEvnt(Sender: TObject);
    procedure OnObjListComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);

    function getCurrencyVal(const dt: TDatetime): double;
    procedure gridCurrDataRecheck;

    procedure addObjCol;
    //procedure hideObjListCombo;
    // -----

    // 22.11.2009 ingmar; bug: kui me korrigeerime seal combo sisu; siis keyevent kaob ära editori !
    procedure addDCSideSum(var colPos: integer; var rowPos: integer);
    procedure deleteGenLedgLine(const pRowNr: integer);

    procedure calcAccSumTotal(const pDebitSide: boolean = True); // teisel juhul oleks kreedit
    procedure doCConversion;

    // ----
    function calcChksumStrForAccRecord: AStr;
    function calcChksumStrForHdrRecord: AStr;


    procedure cancelAccRecords(const accRegID: integer); // kande aluskirje;
    procedure prepareGrid;
    procedure writeIntoCSVFile(const pFilename: AStr);
    procedure generatePrintPreview;


  public

    procedure callNewGenEntryEvent;
    procedure openEntry(const entryId: integer = 0);
    // --
    procedure refreshObjectList(const skipObjectListLoad: boolean = False);
    procedure refreshAccountList(const skipClosedAccounts: boolean = True);
    constructor Create(frameowner: TComponent); override;
    destructor Destroy; override;
  published // RTTI probleem


    // saadame vanemale info, et soovime ennast sulgeda !
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    // ----------------
    // seda kutsub meie vanem välje
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;     // kuna frame ei võimalda keypreview'd, kasutame vanema võimalusi
    // selle evendi omistab vanem, seda välja kutsudes saame esitada valuuta info uuendamise palve
    property onAskCurrencyDownload: TRequestForCurrUpdate read FReqCurrUpdate write FReqCurrUpdate;
    // frame teavitab, mis sündmus toimus...ühe frame sündmus võib tähendada sündmusi teistes framedes jne
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    // hetkel pole kasutatud, aga siin küsime peavormilt, et ehk saaks taskbarile midagi kirjutada
    property onReqTaskbarEvent: TTaskBarNotEvent read FReqTaskbarEvent write FReqTaskbarEvent;
    // ----------------
    property loadData: boolean read getLoadStatus write setLoadStatus;
    property reportDefPath: AStr read FRepDefFile write FRepDefFile;

  end;




const
  // +1 !!!!!
  CCol_Account = 1; // konto nimi
  CCol_AccDescr = 2;
  CCol_AccCurrency = 3;
  CCol_AccDebit = 4;
  CCol_AccCredit = 5;
  CCol_AccCurrencyRate = 6;
  CCol_AccMonConversion = 7;
  CCol_Client = 8; // tegelikkuses klient !



// objekti lookupcombode lahtrite mõõdud
const
  CCobjGrpNameLcpColWidth = 215;
  CCobjGrpLcpComboDropDownWidth = 275;

  CCobjNameLcpColWidth = CCobjGrpNameLcpColWidth; // 275;
  CCobjLcpComboDropDownWidth = CCobjGrpLcpComboDropDownWidth; // 315;


implementation

uses estbk_sqlclientcollection;

// 15.05.2011 Ingmar
procedure TframeGeneralLedger.callNewGenEntryEvent;
begin
  if btnNewEntry.Enabled then
    btnNewEntry.OnClick(btnNewEntry);
end;

function TframeGeneralLedger.getCurrencyVal(const dt: TDatetime): double;
begin
  // ---
end;


// kõik ülejäänud dokumendid peavad käima läbi laekumiste, ostu ja müügirestkontro
function TframeGeneralLedger.allowDocumentsWithPrefix(const pDocPrefix: AStr): boolean;
var
  pDoctype: AStr;
begin
  pDoctype := trim(AnsiUpperCase(copy(pDocPrefix, 1, pos(':', pDocPrefix) - 1)));
  Result :=//(pDoctype=estbk_types.CDocShortType_undefined)   or // 15.05.2011 Ingmar
    (pDocPrefix = SUndefComboChoise) or (pDoctype = estbk_types.CDocShortType_miscDocType) or
    (pDoctype = estbk_types.CDocShortType_mutualSettlements) or (pDoctype = estbk_types.CDocShortType_purchBill) or
    (pDoctype = estbk_types.CDocShortType_saleBill) or (pDoctype = estbk_types.CDocShortType_captialAssets) or
    (pDoctype = estbk_types.CDocShortType_salary) or
    // (pDoctype=estbk_types.CDocShortType_incomeOrder) or
    // (pDoctype=estbk_types.CDocShortType_withdrawalOrder) or
    //(pDoctype=estbk_types.CDocShortType_paymentOrder) or
    (pDoctype = estbk_types.CDocShortType_accInitBalance) or
    // 28.08.2012 Ingmar; sulgemiskande olin ära unustanud !
    (pDoctype = estbk_types.CDocShortType_AccClsRec);
end;

procedure TframeGeneralLedger.displayAllowedDocs(const pAllTypes: boolean = True);
var
  i: integer;
begin
  if pAllTypes then
    cmbDocumentType.Items.Assign(self.FDocumentTypesList)
  else
  begin
    cmbDocumentType.Clear;
    for i := 0 to self.FDocumentTypesList.Count - 1 do
      if self.allowDocumentsWithPrefix(self.FDocumentTypesList.Strings[i]) or (PtrInt(self.FDocumentTypesList.Objects[i]) = 0) then
      begin
        cmbDocumentType.Items.AddObject(self.FDocumentTypesList.Strings[i], self.FDocumentTypesList.Objects[i]);
      end;
  end;
end;

// TODO teeks üks funktsioon neile !
// algsaldod
function TframeGeneralLedger.isBalanceInitDocument(): boolean;
var
  pChkPrefix: AStr;
begin
  pChkPrefix := AnsiUpperCase(trim(copy(cmbDocumentType.Text, 1, pos(':', cmbDocumentType.Text) - 1)));
  Result := pChkPrefix = estbk_types.CDocShortType_accInitBalance;
end;

// kas sulgemiskanne
function TframeGeneralLedger.isAccPerClosingDocument(): boolean;
var
  pChkPrefix: AStr;
begin
  pChkPrefix := AnsiUpperCase(trim(copy(cmbDocumentType.Text, 1, pos(':', cmbDocumentType.Text) - 1)));
  Result := pChkPrefix = estbk_types.CDocShortType_AccClsRec;
end;


function TframeGeneralLedger.getLoadStatus: boolean;
begin
  Result := qryObjects.active;
end;




procedure TframeGeneralLedger.setLoadStatus(const v: boolean);
var
  pMerge: AStr;
begin

  qryAllAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
  // jäta query aktiivseks tema järgi tuvastame hiljem konto id ja muud vajalikud andmed !!!
  //qryAccountNames.Connection  := estbk_clientdatamodule.dmodule.primConnection;
  qryDocumentTypes.Connection := estbk_clientdatamodule.dmodule.primConnection;
  //qryObjectTypes.Connection   := estbk_clientdatamodule.dmodule.primConnection;
  qryObjects.Connection := estbk_clientdatamodule.dmodule.primConnection;
  qryObjectsGrps.Connection := estbk_clientdatamodule.dmodule.primConnection;
  //  qryAccregister.Connection   := estbk_clientdatamodule.dmodule.primConnection;
  //  qryAccregisterDoc.Connection   := estbk_clientdatamodule.dmodule.primConnection;
  //  qryAccregisterBindDoc.Connection   := estbk_clientdatamodule.dmodule.primConnection;
  //  qryAccreEntry.Connection   := estbk_clientdatamodule.dmodule.primConnection;
  //  qryAccreEntryObj.Connection   := estbk_clientdatamodule.dmodule.primConnection;
  qryAccReqObjects.Connection := estbk_clientdatamodule.dmodule.primConnection;
  //qryVerifData.Connection   := estbk_clientdatamodule.dmodule.primConnection;



  qryAccData.Connection := estbk_clientdatamodule.dmodule.primConnection;
  qryAccreEntryObjSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;
  qryAccreEntryObjSeq.SequenceName := 'accounting_records_attrb_id_seq';


  // 21.11.2009 Ingmar
  qryObjectsGrps.SQL.Clear;
  qryObjectsGrps.SQL.add(estbk_sqlclientcollection._CSQLObjectTypes);

  qryAccReqObjects.SQL.Clear;
  qryAccReqObjects.SQL.add(estbk_sqlclientcollection._CSQLGetAllAccMarkedObjects);


  qryDocumentTypes.SQL.Clear;
  qryDocumentTypes.SQL.add(estbk_sqlclientcollection._CSQLDocumentTypes);

  qryObjects.SQL.Clear;
  qryObjects.SQL.add(estbk_sqlclientcollection._CSQLAllObjects);

  // preparam
  qryObjects.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
  // objektid, mis PEAVAD eksisteerima kande real !!!!
  qryAccReqObjects.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;



  // frame ikka unustab oma properteid...lazaruse kala
  //qryAccountNames.active  := v;
  //qryDocumentTypes.active := v;

  // hoiame seoste tabeleid mälus !
  qryObjects.active := v;
  qryObjectsGrps.active := v;

  qryAccReqObjects.active := v;

  // -------
  //FAccListCombo.Clear;
  FAccListCombo.DropDownCount := 20;
  FAccListCombo.Height := 125;


  // 29.05.2011 Ingmar
  FAccListCombo.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;


  //  FAccObjTypes.Clear;
  FAccObjTypes.DropDownCount := 20;
  FAccObjTypes.Height := 125;

  //  FObjectGrps.Clear;
  cmbDocumentType.Clear;

  // accountingGrid.CellToGridZone();
  // ---
  if v then
  begin

    self.performCleanup;

    // 24.06.2010 Ingmar; tõin constructorist koodi siia
    if assigned(self.FCurrDataList) then
      FreeAndNil(self.FCurrDataList);
    self.FCurrDataList := dmodule.createPrivateCurrListCopy();


    // ---
    accountingGrid.columns.items[CCol_AccCurrency - 1].PickList.Assign(self.FCurrDataList);

    // -- viimane obj. id, mis oli firma kontodega seotud
    self.FAccObjCheck := 0;
    with qryAccReqObjects do
      try
        while not EOF do
        begin
          if FieldByName('id').AsInteger > FAccObjCheck then
            self.FAccObjCheck := FieldByName('id').AsInteger;

          Next;
        end;
        // --
      finally
        First;
      end;

    self.FAccObjCheck := estbk_utilities.chgChkSum(self.FAccObjCheck, qryAccReqObjects.RecordCount);

    // ------
    cmbDocumentType.items.addObject('', nil);
    //estbk_utilities.clearStrObject(TAStrings(FDocumentTypesList));
    FDocumentTypesList.AddObject(estbk_strmsg.SUnDefComboChoise, TObject(PtrInt(_ac.sysDocumentId[_dsDocUndefined])));


    // ------ Dokumendi tüübid
    with qryAccData, SQL do
    begin
      Close;
      Clear;
      Add(estbk_sqlclientcollection._CSQLDocumentTypes);
      Open;

      First;
      while not EOF do
      begin

        if (FieldByName('id').AsInteger > 0) then
        begin
          pMerge := trim(FieldByName('docshortident').AsString) + ':' + trim(FieldByName('docname').AsString);
          FDocumentTypesList.addObject(pMerge, TObject(PtrInt(FieldByName('id').AsInteger)));
        end;
        // --
        Next;
      end;

      // ---
      Close;
      SQL.Clear;
    end;




    //for i:=0 to FObjectGrps.count-1 do
    //    FAccObjTypes.items.objects[i]:=FObjectGrps.objects[i];
    //     self.accountingGrid.Columns.Items[CCol_AccMonConversion-1].Title.Caption:=estbk_globvars.glob_baseCurrencyShortname;


    // --------------------------------------
    self.refreshAccountList;
    self.refreshObjectList(True);
    // --------------------------------------
    self.FGridReadOnly := True;

  end;


  accountingGrid.Columns.Items[0].Width := CAccountColWidth;

  FAccListCombo.Width := CAccountColWidth;
  FAccListCombo.Visible := False;
  FAccListCombo.Left := CShiftItemsLeft;


  FAccObjGroups.Visible := False;
  FAccObjGroups.Left := CShiftItemsLeft;

  FAccObjTypes.Visible := False;
  FAccObjTypes.Left := CShiftItemsLeft;

  //  FAccObjGroups.AutoSelected:=True;
  //  FAccObjGroups.AutoDropDown:=True;
  //  FAccObjGroups.AutoSizeDelayed:=10;



  //  FAccObjGroups.ItemIndex:=-1;

  // algul kõik controlid kinni
  estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox as TWinControl, False);
  ovrAllGrpbox.Enabled := True;
  accountingGrid.Enabled := True;
  // estbk_utilities.changeWCtrlReadOnlyStatus(ovrAllGrpbox as TWinControl, true);
end;



procedure TframeGeneralLedger.openEntry(const entryId: integer = 0);
var
  i, rowCnt, LastObjCol: integer;
  paccRecSum: double;
  pIsCancelledRec: boolean;
  pEntryType: AStr;
  pCurr: Astr;
  pClientCls: TIntIDAndCTypes;
begin
  // ---
  with qryAccData, SQL do
    try
      self.FSkipOnChangeSelectEvents := True;


      self.performCleanup;
      // ---
      estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox as TWinControl, True);
      ovrAllGrpbox.Enabled := True;
      accountingGrid.Enabled := True;


      // 27.10.2009 Ingmar; nüüd vajame ka suletud kontode nimistut
      self.refreshAccountList(False);
      self.FGridReadOnly := True; // rahustame handlerid  maha...

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLGetAccRegFullSelectExt);
      paramByname('id').AsInteger := entryId;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;

      if EOF then
        Exit;

      pEntryType := AnsiUpperCase(FieldByName('entrytype').AsString);
      pIsCancelledRec := pos('C', pEntryType) > 0; // tühistatud kanne

      if assigned(onReqTaskbarEvent) then
        if pIsCancelledRec then
          onReqTaskbarEvent(self, estbk_strmsg.SAccRecordCancelled)
        else
          onReqTaskbarEvent(self, '');
      // #######################################

      self.FOpenedEntryId := entryId;
      self.FInsertMode := False; // ainult update !!!


      edtAccnr.Text := FieldByName('entrynumber').AsString;
      edtAccnr.ReadOnly := True;
      // 02.02.2010 Ingmar
      //edtAccnr.Enabled:=false;
      //edtAccnr.Color:=clBtnFace;

      // formateerime ise, kui backendi peaks vahetama, siis võib asString probleeme tekidada
      edtAccdate.Text := datetostr(FieldByName('transdate').AsDateTime);
      edtTransDescr.Text := FieldByName('transdescr').AsString;
      cmbDocumentType.ItemIndex := -1;
      edtDocNr.Text := FieldByName('docnr').AsString;


      // combos kuvatavad dokumendi tüübid !
      self.displayAllowedDocs(not estbk_utilities.isGenledgerRecord(pEntryType));


      // jätame ka meelde kirjega seotud baasdokumendi id !
      FOpenedEntryBaseDocId := FieldByName('document_id').AsLargeInt;


      cmbDocumentType.ItemIndex := 0; // määramata !
      // ---
      if FieldByName('doctypeid').AsInteger > 0 then
        for i := 0 to cmbDocumentType.Items.Count - 1 do
          if cardinal(cmbDocumentType.Items.Objects[i]) = FieldByName('doctypeid').AsInteger then
          begin
            cmbDocumentType.ItemIndex := i;
            break;
          end;


      // -------
      // nüüd laeme kasutatud kontod
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLGetAccRecsFullSelect(pIsCancelledRec)); // avame ka annuleeritud kande kirjed !!!!
      parambyname('accounting_register_id').AsInteger := entryId;

      if pIsCancelledRec then
        parambyname('accounting_register_id2').AsInteger := entryId;
      Open;
      rowCnt := 1;


      while not EOF do
      begin

        pCurr := trim(FieldByName('currency').AsString);
        if pCurr = '' then
          pCurr := estbk_globvars.glob_baseCurrency;

        pAccRecSum := FieldByName('rec_sum').AsFloat;
        // asmoney ei ole hea, kui kasutame erinevaid backenda ! float sobib !! aga mitte arvutusteks !!!!!
        self.accountingGrid.Cells[CCol_AccCurrency, rowCnt] := FieldByName('currency').AsString;
        self.accountingGrid.Columns.items[CCol_AccMonConversion - 1].Width := 85;
        // 07.09.2010 ingmar
        self.accountingGrid.Cells[CCol_AccCurrencyRate, rowCnt] := format(CCurrentAmFmt3, [FieldByName('currency_drate_ovr').AsFloat]);

        self.accountingGrid.Cells[CCol_AccMonConversion, rowCnt] := estbk_utilities.setRFloatSep(format(CCurrentMoneyFmt2, [pAccRecSum]));
        if (pCurr <> estbk_globvars.glob_baseCurrency) then
          pAccRecSum := FieldByName('currency_vsum').AsCurrency; // valuuta originaalsumma !


        // self.accountingGrid.Cells[CCol_AccCurrency,rowCnt]:=pCurr;
        self.accountingGrid.Cells[CCol_Account, rowCnt] := FieldByName('account_coding').AsString;
        self.accountingGrid.Objects[CCol_Account, rowCnt] := TCellAccountType.Create;
        TCellAccountType(self.accountingGrid.Objects[CCol_Account, rowCnt]).AccountId := FieldByName('account_id').AsInteger;
        TCellAccountType(self.accountingGrid.Objects[CCol_Account, rowCnt]).AccountRecID := FieldByName('id').AsInteger;
        TCellAccountType(self.accountingGrid.Objects[CCol_Account, rowCnt]).AccountType := FieldByName('account_type').AsString;


        // 11.07.2010 Ingmar; kui puudub kirjeldus, siis kuva konto nimi !
        if trim(FieldByName('descr').AsString) <> '' then
          self.accountingGrid.Cells[CCol_Account + 1, rowCnt] := FieldByName('descr').AsString
        else
          self.accountingGrid.Cells[CCol_Account + 1, rowCnt] := FieldByName('account_name').AsString;



        // 01.03.2010 Ingmar; miks see summa peaks andmebaasis negatiivne olema BUGI
        //if fieldByname('rec_type').asString=estbk_types.CAccRecTypeAsDebit then // deebet rida; CurrToStr ei võimalda meil 4 kohta peale koma kuvada !!!

        if FieldByName('rec_type').AsString = estbk_types.CAccRecTypeAsDebit then
          self.accountingGrid.Cells[CCol_AccDebit, rowCnt] := estbk_utilities.setRFloatSep(format(CCurrentMoneyFmt2, [pAccRecSum]))
        else
        if FieldByName('rec_type').AsString = estbk_types.CAccRecTypeAsCredit then
          self.accountingGrid.Cells[CCol_AccCredit, rowCnt] := estbk_utilities.setRFloatSep(format(CCurrentMoneyFmt2, [pAccRecSum]));


        //else
        //if fieldByname('rec_type').asString=estbk_types.CAccRecTypeAsCredit then
        //   self.accountingGrid.Cells[CCol_AccCredit,rowCnt]:=estbk_utilities.setRFloatSep(CurrToStr(pAccRecSum));
        //self.accountingGrid.Cells[CCol_AccCredit,rowCnt]:=estbk_utilities.setRFloatSep(CurrToStr(-pAccRecSum));

        // CCol_CompCode   = 5;
        // CCol_CompName   = 6;


        // 21.03.2011 Ingmar; nüüd kenasti klient ka olemas !!!
        // if (fieldByname('client_id').AsInteger>0) and estbk_utilities.isGenledgerRecord(pEntryType) then
        if (FieldByName('client_id').AsInteger > 0) then
        begin
          pClientCls := TIntIDAndCTypes.Create;
          pClientCls.id := FieldByName('client_id').AsInteger;
          pClientCls.clf := trim(FieldByName('firstname').AsString + ' ' + FieldByName('lastname').AsString);


          self.accountingGrid.Objects[CCol_Client, rowCnt] := pClientCls;
          self.accountingGrid.Cells[CCol_Client, rowCnt] := pClientCls.clf;
        end
        else
          self.accountingGrid.Cells[CCol_Client, rowCnt] := trim(FieldByName('tr_partner_name').AsString);


        // -------
        Inc(rowCnt);
        Next;
      end; // kanderead




      // -----
      // nüüd peame otsima objektid one by one...
      for i := 1 to rowCnt - 1 do
      begin
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLGetAccObjFullSelect);
        parambyname('accounting_record_id').AsInteger := TCellAccountType(self.accountingGrid.Objects[CCol_Account, i]).AccountRecID;
        Open;
        First;
        LastObjCol := CCol_Client + 1;

        while not EOF do
        begin

          // küsime lahtreid juurde
          if (LastObjCol >= accountingGrid.colCount - 1) then
            self.addObjCol;

          self.accountingGrid.Cells[LastObjCol, i] := FieldByName('objname').AsString;
          self.accountingGrid.Objects[LastObjCol, i] := TCellObjectType.Create;
          TCellObjectType(self.accountingGrid.Objects[LastObjCol, i]).ObjectId := FieldByName('objid').AsInteger;
          TCellObjectType(self.accountingGrid.Objects[LastObjCol, i]).ObjectGrp := FieldByName('objgrp').AsInteger;

          // ---
          Inc(LastObjCol);
          Next;
        end;

      end; // --

      try

        self.FAccListCombo.Visible := False;
        self.FAccObjGroups.Visible := False;
        self.FAccObjTypes.Visible := False;

        if edtAccdate.CanFocus then
          edtAccdate.SetFocus;

      except
      end;


    finally

      // selle järgi tuvastame, kas midagi muutus või mitte
      self.FAccRowsChkStr := self.calcChksumStrForAccRecord();
      self.FAccHeaderChkStr := self.calcChksumStrForHdrRecord();




      self.FGridReadOnly := pIsCancelledRec or not isGenledgerRecord(pEntryType);
      // 02.02.2010 Ingmar; lubame VAID pearaamatu kandeid muuta !!!!!!!



      // 02.02.2010 Ingmar; kinni !
      estbk_utilities.changeWCtrlReadOnlyStatus(ovrAllGrpbox, self.FGridReadOnly);
      cmbDocumentType.Enabled := not self.FGridReadOnly;




      // 12.12.2010 Ingmar; ei tohi lubada muuta olemasolevat dokumenti !!!! kui just pole määramata !
      if cmbDocumentType.Enabled and (cmbDocumentType.ItemIndex > 0) then
        cmbDocumentType.Enabled := False;



      //estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox as TWinControl, not self.FGridReadOnly);
      // arvutame ka summad kontode lõike
      accountingGridEditingDone(nil);

      // ---
      // 14.03.2010 Ingmar; ma ei luba kande nr ja kuupäeva muuta; siis kui alustasin, ei mõistnud selle kriitilisust !!!!!!!!!!!!!!!!!!
      estbk_utilities.changeWCtrlReadOnlyStatus(edtAccnr, True);
      estbk_utilities.changeWCtrlReadOnlyStatus(edtAccdate, not estbk_utilities.isGenledgerRecord(pEntryType));

      Close;
      Clear;

      // selle järgi tuvastame, kas midagi muutus või mitte
      self.FAccHeaderChkStr := self.calcChksumStrForHdrRecord();
      self.FAccRowsChkStr := self.calcChksumStrForAccRecord();
    end;



  btnNewEntry.Enabled := True;
  btnCopy.Enabled := True;

  btnSaveEntry.Enabled := False;
  btnCancel.Enabled := False;


  // 31.10.2009 ingmar
  // annuleeritud kanne !!!!
  if pIsCancelledRec then
  begin
    btnCancelGd.Enabled := False;

    estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox as TWinControl, False);
    accountingGrid.Enabled := True;
    ovrAllGrpbox.Enabled := True;
  end
  else
    btnCancelGd.Enabled := estbk_utilities.isGenledgerRecord(pEntryType);
  //pos(estbk_types.CAccRecIdentAsGenLedger,pEntryType)>0; // 10.02.2010 Ingmar; arve kanded tuleb annuleerida arvega !!!!

  // ---
end;

procedure TframeGeneralLedger.refreshObjectList(const skipObjectListLoad: boolean = False);
var
  pOrigFilter: AStr;
  pFiltStatus: boolean;
begin
  // ------------
  if not skipObjectListLoad then
  begin

    qryObjectsGrps.Active := False;
    qryObjectsGrps.Active := True;


    pFiltStatus := qryObjects.Filtered;
    pOrigFilter := qryObjects.Filter;

    // --- ohutu reload
    qryObjects.Active := False;
    qryObjects.Active := True;

    qryObjects.Filtered := False;
    qryObjects.Filter := pOrigFilter;
    qryObjects.Filtered := pFiltStatus;
  end;
  // !!!!!!!!!
  // algseis paika; mis kõige nummim, peame objektid ise uuesti väärtustama damn
  //FAccObjTypes.Items.Assign(FObjectGrps);
end;

procedure TframeGeneralLedger.refreshAccountList(const skipClosedAccounts: boolean = True);
begin
  self.FHideClosedAccounts := True;

  // 20.11.2009 ingmar; kui lookup combod hakkavad tööle tee koodi cleanup !!!
  with qryAllAccounts, SQL do
  begin
    Close;
    Clear;
    Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
    Open;
    // vaata ka filtered eventi !!!!
    Filtered := True;
  end;

end;

constructor TframeGeneralLedger.Create(frameOwner: TComponent);
var
  pCollItem: TCollectionItem;
  pTmpStr: AStr;
  i: integer;

begin
  try

    inherited Create(frameOwner);
    self.FCopyObjs := TObjectList.Create(True);
    self.FGridReadOnly := True; // välistame sellega, et kohe alguses vale handler paika läheb

    FDocumentTypesList := TAStrList.Create;
    //FCurrDataList:=TAStrList.create;
    self.DoubleBuffered := True;
    accountingGrid.DoubleBuffered := True;

    // ---
    FOrigGridWndProc := accountingGrid.WindowProc;
    accountingGrid.WindowProc := @self.newGridWindowProc;


    FHideClosedAccounts := True;
    FInsertMode := True;


    FAccListCombo := TRxDBLookupCombo.Create(self.accountingGrid);
    FAccListCombo.AutoSize := False;
    FAccListCombo.parent := self.accountingGrid;
    FAccListCombo.Visible := False;
    //FAccListCombo.AutoComplete := True;
    FAccListCombo.OnKeyDown := @self.OnAccListComboKeydown;
    FAccListCombo.OnEnter := @self.OnLookupCmbEnter;
    FAccListCombo.OnExit := @self.OnLookupCmbExit;

    FAccListCombo.OnClosePopupNotif := @self.OnLookupPopupClose;
    FAccListCombo.OnChange := @self.OnLookupCmbChange;
    //FAccListCombo.Color:=MyFavLightYellow;
    //FAccListCombo.OnButtonClick:=@self.OnAccBtnListclick;
    FAccListCombo.PopUpFormOptions.OnGetCellProps := @self.OnDbLookupComboSelColor;

    // 23.12.2009 Ingmar
    FAccListCombo.OnSelect := @self.OnAccComboSelect;
    //    FAccListCombo.EmptyItemColor:=estbk_types.MyFavLightYellow;


    FAccListCombo.ParentFont := True;
    FAccListCombo.ParentColor := False;
    FAccListCombo.ShowHint := True;
    FAccListCombo.DoubleBuffered := True;
    FAccListCombo.EmptyValue := #32;
    FAccListCombo.Flat := True;
    FAccListCombo.BorderStyle := bsNone;
    FAccListCombo.PopUpFormOptions.BorderStyle := bsNone;
    //FAccListCombo.PopUpFormOptions.Options:=[pfgIndicator,pfgRowlines,pfgCollines,pfgColumnResize];
    //FAccListCombo.PopUpFormOptions.ShowTitles:=true;
    //FAccListCombo.PopUpFormOptions.TitleButtons:=true;
    FAccListCombo.PopUpFormOptions.Options := [pfgIndicator, pfgRowlines, pfgCollines, pfgColumnResize];
    FAccListCombo.PopUpFormOptions.TitleButtons := True;
    //FAccListCombo.PopUpFormOptions.AutoSort:=true;



    FAccListCombo.DropDownCount := 20;
    FAccListCombo.DropDownWidth := 315;

    FAccListCombo.LookupSource := self.qryAllAccountsDS;
    FAccListCombo.LookupDisplay := 'account_coding;account_name';
    FAccListCombo.LookupField := 'id';


    pCollItem := FAccListCombo.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccCode;
    (pCollItem as TPopUpColumn).Fieldname := 'account_coding';
    (pCollItem as TPopUpColumn).Width := 85;


    pCollItem := FAccListCombo.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccName;
    (pCollItem as TPopUpColumn).Fieldname := 'account_name';
    (pCollItem as TPopUpColumn).Width := 185;



    //  FAccListCombo.BorderWidth:=2;

    FAccListCombo.EmptyValue := #32;
    FAccListCombo.UnfindedValue := rxufNone;
    //FAccListCombo.UnfindedValue:=rxufNone;
    FAccListCombo.ButtonWidth := 15;
    FAccListCombo.ButtonOnlyWhenFocused := False;
    FAccListCombo.Height := 23;
    FAccListCombo.PopUpFormOptions.ShowTitles := True;


    //FAccBtn:=TBitBtn.Create(self.accountingGrid);
    FObjectColCnt := 1;

    // !!!!
    FAccObjGroups := TRxDBLookupCombo.Create(self.accountingGrid);
    FAccObjGroups.parent := self.accountingGrid;
    FAccObjGroups.Visible := False;
    //  FAccObjGroups.AutoComplete := True;
    FAccObjGroups.ParentFont := False;
    FAccObjGroups.ParentColor := False;
    FAccObjGroups.ShowHint := True;
    FAccObjGroups.DoubleBuffered := True;
    FAccObjGroups.OnEnter := @self.OnObjTypeComboEnter;
    FAccObjGroups.OnExit := @self.OnObjTypeListComboExit;
    FAccObjGroups.OnKeyDown := @self.OnObjListComboKeydown;
    FAccObjGroups.OnSelect := @self.OnObjListSelect;
    FAccObjGroups.OnChange := @self.OnObjListChange;
    FAccObjGroups.OnDblClick := @self.OnObjListClick;
    FAccObjGroups.PopUpFormOptions.TitleButtons := True;
    FAccObjGroups.OnClosePopupNotif := @self.OnLookupPopupClose; // sama loogika, eventi võib jagada !
    FAccObjGroups.Hint := estbk_strmsg.SGenLedChooseObjGrp;
    //FAccObjGroups.Color:=MyFavLightYellow;
    // --
    FAccObjGroups.PopUpFormOptions.ShowTitles := True;
    FAccObjGroups.PopUpFormOptions.OnGetCellProps := @self.OnDbLookupComboSelColor;

    FAccObjGroups.ButtonWidth := 15;
    FAccObjGroups.ButtonOnlyWhenFocused := False;
    FAccObjGroups.Height := 23;
    //    FAccObjGroups.EmptyItemColor:=estbk_types.MyFavLightYellow;

    //FAccObjGroups.LookupSource:=nil;
    //FAccObjGroups.LookupDisplay:='';
    //FAccObjGroups.LookupField:='';
    FAccObjGroups.LookupDisplay := 'objgrp';
    FAccObjGroups.LookupField := 'id';
    FAccObjGroups.LookupDisplayIndex := 0;

    //FAccObjGroups.DataSource:=self.qryObjectsGrpsDs;
    FAccObjGroups.LookupSource := self.qryObjectsGrpsDs;
    // rumala lookupcombo fix
    FAccObjGroups.DataSource := nil;

    FAccObjGroups.EmptyValue := #32;
    FAccObjGroups.Flat := True;
    FAccObjGroups.BorderStyle := bsNone;
    FAccObjGroups.PopUpFormOptions.BorderStyle := bsNone;
    FAccObjGroups.PopUpFormOptions.Options := [pfgIndicator, pfgRowlines, pfgCollines, pfgColumnResize];

    pCollItem := FAccObjGroups.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccObjGrpName;
    (pCollItem as TPopUpColumn).Fieldname := 'objname';
    (pCollItem as TPopUpColumn).Width := CCobjGrpNameLcpColWidth;

    FAccObjGroups.LookupDisplay := 'objname';
    FAccObjGroups.LookupField := 'id';
    FAccObjGroups.LookupDisplayIndex := 0;

    //FAccObjGroups.DataSource:=self.qryObjectsDs;
    FAccObjGroups.LookupSource := self.qryObjectsGrpsDs;
    FAccObjGroups.DataSource := nil;


    //  FAccObjGroups.OnClick:=
    //  FAccObjGroups.OnCloseUp:=@self.OnObjListCloseup;
    FAccObjGroups.DropDownCount := 20;
    FAccObjGroups.DropDownWidth := CCobjGrpLcpComboDropDownWidth;


    // !!!

    FAccObjTypes := TRxDBLookupCombo.Create(self.accountingGrid);
    //FAccObjTypes.Color:=MyFavLightYellow;


    FAccObjTypes.parent := self.accountingGrid;
    FAccObjTypes.Visible := False;
    //  FAccObjGroups.AutoComplete := True;
    FAccObjTypes.ParentFont := False;
    FAccObjTypes.ParentColor := False;
    FAccObjTypes.ShowHint := True;
    FAccObjTypes.DoubleBuffered := True;
    FAccObjTypes.OnEnter := @self.OnObjTypeComboEnter;
    FAccObjTypes.OnExit := @self.OnObjTypeListComboExit;
    FAccObjTypes.OnKeyDown := @self.OnObjListComboKeydown;
    FAccObjTypes.OnSelect := @self.OnObjListSelect;
    FAccObjTypes.OnChange := @self.OnObjListChange;

    FAccObjTypes.PopUpFormOptions.TitleButtons := True;
    FAccObjTypes.OnClosePopupNotif := @self.OnLookupPopupClose; // sama loogika, eventi võib jagada !
    FAccObjTypes.Hint := estbk_strmsg.SGenLedBackToObjGrpList;

    // --
    FAccObjTypes.PopUpFormOptions.ShowTitles := True;
    FAccObjTypes.PopUpFormOptions.OnGetCellProps := @self.OnDbLookupComboSelColor;


    //    FAccObjTypes.EmptyItemColor:=estbk_types.MyFavLightYellow;

    FAccObjTypes.EmptyValue := #32;
    FAccObjTypes.Flat := True;
    FAccObjTypes.BorderStyle := bsNone;
    FAccObjTypes.PopUpFormOptions.BorderStyle := bsNone;
    FAccObjTypes.PopUpFormOptions.Options := [pfgIndicator, pfgRowlines, pfgCollines, pfgColumnResize];

    pCollItem := FAccObjTypes.PopUpFormOptions.Columns.Add;
    (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SAccObjName;
    (pCollItem as TPopUpColumn).Fieldname := 'descr';
    (pCollItem as TPopUpColumn).Width := CCobjNameLcpColWidth;



    FAccObjTypes.ButtonWidth := 15;
    FAccObjTypes.ButtonOnlyWhenFocused := False;
    FAccObjTypes.Height := 23;

    //FAccObjGroups.LookupSource:=nil;
    //FAccObjGroups.LookupDisplay:='';
    //FAccObjGroups.LookupField:='';
    FAccObjTypes.LookupDisplay := 'descr';
    FAccObjTypes.LookupField := 'id';
    FAccObjTypes.LookupDisplayIndex := 0;
    FAccObjTypes.DataSource := nil;
    FAccObjTypes.LookupSource := qryObjectsDs;

    FAccObjTypes.DropDownCount := 20;
    FAccObjTypes.DropDownWidth := CCobjLcpComboDropDownWidth;

    // ---
    self.prepareGrid;
    // ---

    estbk_uivisualinit.__preparevisual(self);
    //  FObjectGrps:=TStringlist.Create;


    //accountingGrid.columns.items[CCol_AccCurrency-1].PickList.Assign(self.FCurrDataList);
    // ---

    self.FGridReadOnly := False;

    // tiitel ilusam, kui peakirjal vähemalt üks tühik ees; viimane + märk välja jätta !
    for i := 0 to accountingGrid.Columns.Count - 2 do
    begin
      pTmpStr := ' ' + accountingGrid.Columns.Items[i].Title.Caption;
      accountingGrid.Columns.Items[i].Title.Caption := pTmpStr;
    end;

    // ------------------
    TStringCellEditor(accountingGrid.EditorByStyle(cbsAuto)).OnKeyDown := @self.accountingGridKeyDown;
    TStringCellEditor(accountingGrid.EditorByStyle(cbsAuto)).OnChange := @self.OnGridEditorChangeEvnt;
    TStringCellEditor(accountingGrid.EditorByStyle(cbsAuto)).OnClick := @self.OnGridEditorClickEvnt;
    TStringCellEditor(accountingGrid.EditorByStyle(cbsAuto)).OnExit := @self.OnStringCellEditorExitFix;

    // ------------------

  except
    on e: Exception do
      // ---
      Dialogs.messageDlg(format(estbk_strmsg.SEInitializationZError, [e.message, self.ClassName]), mtError, [mbOK], 0);
  end;
end;

// ebameeldiva vea hack
procedure TframeGeneralLedger.newGridWindowProc(var Message: TMessage);
begin

  if ((Message.Msg = WM_VSCROLL) or (Message.Msg = WM_HSCROLL)) then
  begin

    lazObjchangeTimer.Enabled := False;
    lazFocusFix.Enabled := False;

    if self.FAccListCombo.Visible then
    begin
      self.FAccListCombo.OnSelect(self.FAccListCombo);
      self.FAccListCombo.OnExit(self.FAccListCombo);
      self.FAccListCombo.Visible := False;
      self.FAccListCombo.PopupVisible := False;
    end; // --


    if self.FAccObjGroups.Visible then
    begin
      //self.FAccObjGroups.OnSelect(self.FAccObjGroups);
      //self.FAccObjGroups.OnExit(self.FAccObjGroups);
      self.FAccObjGroups.PopupVisible := False;
      self.FAccObjGroups.Visible := False;
    end;

    if self.FAccObjTypes.Visible then
    begin
      //self.FAccObjTypes.OnSelect(self.FAccObjTypes);
      //self.FAccObjTypes.OnExit(self.FAccObjTypes);
      self.FAccObjTypes.PopupVisible := False;
      self.FAccObjTypes.Visible := False;
    end;

    accountingGrid.SetFocus;
    //accountingGrid.Editor:=nil; // TStringCellEditor (accountingGrid.EditorByStyle(cbsAuto));
  end;
  // (Message.msg = WM_Mousewheel)) then
  self.FOrigGridWndProc(Message);

end;

destructor TframeGeneralLedger.Destroy;
begin
  accountingGrid.WindowProc := self.FOrigGridWndProc;
  self.performCleanup;
  FreeAndNil(self.FCopyObjs);
  //  freeAndNil(FObjectGrps);
  estbk_utilities.clearStrObject(TAStrings(FCurrDataList));
  FreeAndNil(FCurrDataList);
  FreeAndNil(FDocumentTypesList);

  dmodule.notifyNumerators(PtrUInt(self));
  inherited Destroy;
end;

{ TframeGeneralLedger }
procedure TframeGeneralLedger.prepareGrid;
var
  pgridCol: TGridColumn;
  i: integer;
begin
  accountingGrid.RowCount := 1000;
  // accountingGrid.DefaultRowHeight := FAccListCombo.Height - 2;

  for i := 1 to accountingGrid.RowCount - 1 do
    accountingGrid.Cells[0, i] := IntToStr(i);

end;



// ------------------------------ konto tüüpide evendid
procedure TframeGeneralLedger.OnAccListComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // --

  //      TComboBox(Sender).DroppedDown:=not TComboBox(Sender).DroppedDown
      {
  case TRxDBLookupCombo(sender).PopupVisible of
   true  : TRxDBLookupCombo(sender).hi
   false : TRxDBLookupCombo(sender).
  end  else}
  if (Shift = [ssCtrl]) and (key = VK_DELETE) then
  begin
    self.deleteGenLedgLine(self.FPaCurrRowPos);
    key := 0;
  end
  else
  if (shift = []) then
  begin

    if Sender = self.FAccListCombo then
      with TRxDBLookupCombo(Sender) do
        case key of
          VK_DELETE:
            try
              self.FSkipOnChangeSelectEvents := True;



              // kirjelduses sama konto nimi...
              //if trim(self.accountingGrid.Cells[CCol_AccDescr,self.FPaCurrRowPos])=text then
              if trim(self.accountingGrid.Cells[CCol_AccDescr, self.FPaCurrRowPos]) = LookupSource.DataSet.FieldByName('account_name').AsString then
                self.accountingGrid.Cells[CCol_AccDescr, self.FPaCurrRowPos] := '';
              self.accountingGrid.Cells[CCol_Account, self.FPaCurrRowPos] := '';




              if assigned(self.accountingGrid.Objects[CCol_Account, self.FPaCurrRowPos]) then
              begin
                self.accountingGrid.Objects[CCol_Account, self.FPaCurrRowPos].Free;
                self.accountingGrid.Objects[CCol_Account, self.FPaCurrRowPos] := nil;
              end;

              // ---
              Value := '';
              Text := '';
              key := 0;

            finally
              self.FSkipOnChangeSelectEvents := True;
            end;

          VK_ESCAPE:
          begin

            // ---
            key := 0;
            //PopupVisible := False;
            Visible := False;
            // sest ta on seda...
            // self.OnLookupCmbExit(sender);
          end;

          VK_RETURN,
          VK_TAB:
          begin

            // ei tõmmata fookust maha, tee või tina !!!
            // self.OnLookupCmbExit(Sender);
            if trim(Text) = '' then
              self.accountingGrid.Cells[CCol_AccDescr, self.FPaCurrRowPos] := ''
            else
            if assigned(LookupSource.DataSet) and (trim(self.accountingGrid.Cells[CCol_AccDescr, self.FPaCurrRowPos]) = '') then
              self.accountingGrid.Cells[CCol_AccDescr, self.FPaCurrRowPos] := LookupSource.DataSet.FieldByName('account_name').AsString;

            // ehk justkui tab
            key := 0;


            //accountingGrid.SelectedColumn
            if accountingGrid.Col + 1 <= accountingGrid.ColCount then
              accountingGrid.Col := accountingGrid.Col + 1;


            self.lazFocusFix.Enabled := True;
            //if accountingGrid.CanFocus then
            //   accountingGrid.SetFocus;
          end;

          VK_RIGHT: if not TRxDBLookupCombo(Sender).PopupVisible then //if TRxDBLookupCombo(Sender).Text='' then
            begin

              if accountingGrid.Col + 1 <= accountingGrid.ColCount then
                accountingGrid.Col := accountingGrid.Col + 1;

              if accountingGrid.CanFocus then
                accountingGrid.SetFocus;
              key := 0;
            end;

          VK_DOWN,
          VK_NEXT:
            if not PopupVisible then
            begin
              if accountingGrid.Row + 1 <= accountingGrid.RowCount then
                accountingGrid.Row := accountingGrid.Row + 1;

              if accountingGrid.CanFocus then
                accountingGrid.SetFocus;
              key := 0;
            end;

          VK_UP,
          VK_PRIOR:
            //if not DroppedDown then
            if not PopupVisible then
            begin
              //DroppedDown := False;
              if accountingGrid.Row - 1 > 0 then
                accountingGrid.Row := accountingGrid.Row - 1;

              if accountingGrid.CanFocus then
                accountingGrid.SetFocus;
              key := 0;
              // muidu paneb meie fookus jooksu...run focus, run...
            end;
          // --------
        end;
  end;
end;

procedure TframeGeneralLedger.OnLookupCmbEnter(Sender: TObject);
begin
  // ---
end;

procedure TframeGeneralLedger.OnLookupCmbExit(Sender: TObject);
begin
  // ---
end;


procedure TframeGeneralLedger.OnLookupCmbChange(Sender: TObject);
begin
  // ---
end;

procedure TframeGeneralLedger.OnStringCellEditorExitFix(Sender: TObject);
begin
  if not self.FGridReadOnly then
    self.accountingGridEditingDone(accountingGrid);
end;

procedure TframeGeneralLedger.OnLookupPopupClose(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix();
end;

procedure TframeGeneralLedger.OnDbLookupComboSelColor(Sender: TObject; Field: TField; AFont: TFont; var Background: TColor);
begin

end;


procedure TframeGeneralLedger.detectChangesAndEnableSaveBtn;
begin
  if not self.FInsertMode and not self.FGridReadOnly then
  begin
    // kas andmed muutusid !
    btnSaveEntry.Enabled := (self.FAccRowsChkStr <> self.calcChksumStrForAccRecord) or (self.FAccHeaderChkStr <>
      self.calcChksumStrForHdrRecord);
    btnCancel.Enabled := btnSaveEntry.Enabled;
  end;
end;

// 23.12.2009 Ingmar
procedure TframeGeneralLedger.OnAccComboSelect(Sender: TObject);
var
  pCurr: Astr;
begin
  if not self.FSkipOnChangeSelectEvents then
    with TRxDBLookupCombo(Sender) do
      if assigned(LookupSource.DataSet) then
        // if Focused then
        try
          self.FSkipOnChangeSelectEvents := True;
          // ntx valitakse valuutakonto, siis vaja uuendada valuutade kursse, aga editor ei tohi muutuda, muidu saame ebameeldivad vead !
          self.FSkipEditorSelect := True; // gridi editor PEAB jääma samaks

          // ----
          Text := LookupSource.DataSet.FieldByName('account_coding').AsString;


          if not assigned(self.accountingGrid.Objects[FPaCurrColPos, FPaCurrRowPos]) then
            self.accountingGrid.Objects[FPaCurrColPos, FPaCurrRowPos] := TCellAccountType.Create;

          TCellAccountType(accountingGrid.Objects[FPaCurrColPos, FPaCurrRowPos]).AccountId := LookupSource.DataSet.FieldByName('id').AsInteger;
          // 12.11.2010 Ingmar
          TCellAccountType(accountingGrid.Objects[FPaCurrColPos, FPaCurrRowPos]).AccountType :=
            LookupSource.DataSet.FieldByName('account_type').AsString;
          self.accountingGrid.Cells[FPaCurrColPos, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('account_coding').AsString;
          self.accountingGrid.Cells[CCol_AccDescr, FPaCurrRowPos] := LookupSource.DataSet.FieldByName('account_name').AsString;

          // 24.08.2010 Ingmar
          pCurr := LookupSource.DataSet.FieldByName('default_currency').AsString;
          if pCurr = '' then
            pCurr := estbk_globvars.glob_baseCurrency;
          self.accountingGrid.Cells[CCol_AccCurrency, FPaCurrRowPos] := pCurr;


          self.doCConversion;
          self.detectChangesAndEnableSaveBtn;

        finally

          self.FSkipOnChangeSelectEvents := False;
          self.FSkipEditorSelect := False;
          // ---
          // 18.08.2010 Ingmar
          self.lazFocusFix.Enabled := True;
        end;
end;

// 04.01.2010 Ingmar; viisin exiti koodi onchange alla, sest ta töötas valesti, kui hiire rullikuga scrollida
procedure TframeGeneralLedger.OnAccListChange(Sender: TObject);
begin
  with TRxDBLookupCombo(Sender) do
    if Focused then
      try
        self.FSkipOnChangeSelectEvents := True;
        if Text = '' then
        begin
          assert(assigned(self.accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos]));
          self.accountingGrid.Cells[self.FPaCurrColPos, self.FPaCurrRowPos] := '';

          if assigned(self.accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos]) then
            TCellAccountType(self.accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos]).AccountId := 0;
        end;
        // ------
      finally
        self.FSkipOnChangeSelectEvents := False;
      end;
end;



procedure TframeGeneralLedger.OnObjTypeComboEnter(Sender: TObject);
begin
  // --
end;

// haldame obj. tüüpe
procedure TframeGeneralLedger.OnObjTypeListComboExit(Sender: TObject);
begin
  // --
end;

procedure TframeGeneralLedger.OnObjListChange(Sender: TObject);
begin
  // --
end;

procedure TframeGeneralLedger.OnObjListClick(Sender: TObject);
begin

end;

// 21.11.2009 Ingmar
procedure TframeGeneralLedger.OnObjListSelect(Sender: TObject);
var
  pGrpId, pObjId: integer;
begin

  // --
  with TRxDBLookupCombo(Sender) do
    if Visible and not self.FSkipOnChangeSelectEvents then
    begin

      // ---
      if Sender = self.FAccObjGroups then
      begin

        if trim(FAccObjGroups.Text) <> '' then
        begin
          pGrpId := qryObjectsGrps.FieldByName('id').AsInteger;


          if not assigned(accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos]) then
            accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos] := TCellObjectType.Create;

          // objektidele uuesti filter peale !!!!!!
          qryObjects.Filtered := False;
          qryObjects.Filter := format('classificator_id=%d', [pGrpId]);
          qryObjects.Filtered := True;

          TCellObjectType(accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos]).ObjectGrp := pGrpId;
          TCellObjectType(accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos]).ObjectId := 0;
          accountingGrid.Cells[self.FPaCurrColPos, self.FPaCurrRowPos] := '';

          if FAccObjGroups.PopupVisible then
            FAccObjGroups.PopupVisible := False;

          FAccObjGroups.Value := '0';
          FAccObjGroups.Text := '';



          // 29.06.2010 ingmar; ainus vöimalus vältida olukorda,
          // kus select evendi sees editor ära vahetada, ilma, et tekiks can set focus error
          // on kasutada timerit !
          // !!!!!!!!!!!!!!!!!!!!!!!!!
          lazObjchangeTimer.Enabled := True;

        end;

      end
      else
      if (Sender = self.FAccObjTypes) and assigned(accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos]) then
      begin

        pObjId := qryObjects.FieldByName('id').AsInteger;
        TCellObjectType(accountingGrid.Objects[self.FPaCurrColPos, self.FPaCurrRowPos]).ObjectId := pObjId;
        accountingGrid.Cells[self.FPaCurrColPos, self.FPaCurrRowPos] := qryObjects.FieldByName('descr').AsString;
        Text := qryObjects.FieldByName('descr').AsString;

        self.lazFocusFix.Enabled := True;
      end;


      // 23.11.2011 Ingmar
      self.detectChangesAndEnableSaveBtn;
      // ---
    end;
end;

procedure TframeGeneralLedger.OnObjListComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  FGotoNextCell: boolean;
begin
  if (Shift = [ssCtrl]) and (key = VK_DELETE) then
  begin
    deleteGenLedgLine(self.FPaCurrRowPos);
    key := 0;
  end
  else
  if (shift = []) then
    with TRxDBLookupCombo(Sender) do
      case key of
        //VK_ESCAPE:
        VK_DELETE:
          if assigned(accountingGrid.Objects[accountingGrid.Col, accountingGrid.Row]) then
          begin
            //self.OnObjTypeListComboExit(Sender);
            Text := '';
            //accountingGrid.Cells[FPaCurrColPos, FPaCurrRowPos]:='';

            if accountingGrid.CanFocus then
              accountingGrid.SetFocus;
            key := 0;
            // DroppedDown := False;
            //Visible := False;


            // kustutame valiku !!!!
            accountingGrid.Cells[accountingGrid.Col, accountingGrid.Row] := '';
            TCellObjectType(accountingGrid.Objects[accountingGrid.Col, accountingGrid.Row]).ObjectId := 0;
            TCellObjectType(accountingGrid.Objects[accountingGrid.Col, accountingGrid.Row]).ObjectGrp := 0;
            // ---
          end;


        // uuesti grupid avada:
        VK_F5:
        begin

          Text := '';
          Hint := estbk_strmsg.SGenLedChooseObjGrp;
          //FAccObjGroups.SetFocus;
          key := 0;




          if assigned(accountingGrid.Objects[accountingGrid.Col, accountingGrid.Row]) then
          begin
            accountingGrid.Objects[accountingGrid.Col, accountingGrid.Row].Free;
            accountingGrid.Objects[accountingGrid.Col, accountingGrid.Row] := nil;
          end;




          self.FAccObjTypes.Width := 0;

          self.FAccObjGroups.Visible := True;
          self.FAccObjGroups.SetFocus;

          accountingGrid.Cells[accountingGrid.Col, accountingGrid.Row] := '';
          qryObjects.Filtered := False;
          qryObjects.Filter := '';
          self.FAccObjGroups.PopupVisible := True;
        end;

        VK_RETURN,
        VK_TAB:
        begin
          if accountingGrid.Col < accountingGrid.ColCount - 2 then // - viimasele columnile ei liigu
            accountingGrid.Col := accountingGrid.Col + 1
          else
          if accountingGrid.Row < accountingGrid.RowCount - 1 then
          begin
            accountingGrid.Row := accountingGrid.Row + 1;
            accountingGrid.Col := 1;
          end;

          // et fookus minema ei jookseks
          if accountingGrid.CanFocus then
            accountingGrid.SetFocus;
          key := 0;

        end;

        VK_LEFT: if not popUpVisible then
          begin
            key := 0;
            // DroppedDown := False;
            if accountingGrid.Col - 1 > 0 then
              accountingGrid.Col := accountingGrid.Col - 1;

            if accountingGrid.CanFocus then
              accountingGrid.SetFocus;

          end;


        VK_RIGHT: if not popUpVisible then
          begin
            key := 0;
            //DroppedDown := False;
            if accountingGrid.Col + 1 <= accountingGrid.ColCount then
              accountingGrid.Col := accountingGrid.Col + 1;

            if accountingGrid.CanFocus then
              accountingGrid.SetFocus;
          end;

        VK_DOWN,
        VK_NEXT: if not popUpVisible then
          begin
            key := 0;
            //DroppedDown := False;
            if accountingGrid.Row + 1 <= accountingGrid.RowCount then
              accountingGrid.Row := accountingGrid.Row + 1;

            if accountingGrid.CanFocus then
              accountingGrid.SetFocus;
          end;

        VK_UP,
        VK_PRIOR: if not popUpVisible then
          begin
            key := 0;
            //DroppedDown := False;

            if accountingGrid.Row - 1 > 0 then
              accountingGrid.Row := accountingGrid.Row - 1;

            if accountingGrid.CanFocus then
              accountingGrid.SetFocus;
          end;
      end;
end;

{

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; Col, Row: Integer;
  aState: TGridDrawState);
begin
  if Col=2 then
    accountingGrid2.Canvas.TextStyle.Alignment := taRightJustify else
  if Col=3 then
    accountingGrid2.Canvas.TextStyle.Alignment := taCenter;
end;
}
procedure TframeGeneralLedger.addDCSideSum(var colPos: integer; var rowPos: integer);
var
  pAddVal: double;
  pTemp: AStr;

  pCurr: AStr;
  pAccName: AStr;
begin
  with accountingGrid do
  begin

    if (Col = CCol_AccDebit) then
    begin
      if (trim(Cells[Col, Row]) <> '') then
      begin
        pCurr := trim(Cells[CCol_AccCurrency, Row]);
        pAccName := trim(Cells[CCol_Account, Row]);


        //pAddVal:=StrToFloatDef(Cells[Col,Row],0);
        pAddVal := _normZero(double(self.FLastDSideSum - self.FLastCSideSum));
        pTemp := trim(Cells[Col + 1, Row + 1] + Cells[Col, Row + 1]); // ei tohi olla naabrit/ega kedagi tema alla

        if (pAddVal <> 0) and (pTemp = '') then // and (pAccName<>'')
        begin
          //pAddVal:=double(self.FLastDSideSum);
          Cells[Col + 1, Row + 1] := format(CCurrentMoneyFmt2, [pAddVal]); //CurrToStr(pAddVal);//FloatToStr(pAddVal); 28.10.2009
          Cells[CCol_AccCurrency, Row + 1] := pCurr;
        end;
        // --
        colPos := colPos + 3;
      end
      else
        colPos := colPos + 1;
    end
    else
    // ja vastupidi...rõnn rõnn
    if (Col = CCol_AccCredit) then
    begin
      if (trim(Cells[Col, Row]) <> '') then
      begin
        pCurr := trim(Cells[CCol_AccCurrency, Row]);
        pAccName := trim(Cells[CCol_Account, Row]);


        //pAddVal:=StrToFloatDef(Cells[Col,Row],0);
        pAddVal := _normZero(double(self.FLastCSideSum - self.FLastDSideSum));
        pTemp := trim(Cells[Col - 1, Row + 1] + Cells[Col, Row + 1]);

        if (pAddVal <> 0) and (pTemp = '') then //   and (pAccName<>'')
        begin
          //pAddVal:=double(self.FLastCSideSum);
          Cells[Col - 1, Row + 1] := format(CCurrentMoneyFmt2, [pAddVal]); // FloatToStr(pAddVal); 28.10.2009 ;  CurrToStr
          Cells[CCol_AccCurrency, Row + 1] := pCurr;
        end;
      end; // ---
      // ---
      // Col := Col + 1;
      colPos := colPos + 2;
    end
    else
      colPos := colPos + 1;
    // ---
  end;
end;

procedure TframeGeneralLedger.doCConversion;
var
  i, pCurrIndx: integer;
  pCurr: AStr;
  pDCSum: AStr;
  pConvVal: double;
  pCurrVal: double;
begin
  if not self.FGridReadOnly then
    with accountingGrid do
    begin

      for i := 1 to rowCount - 1 do
      begin
        pCurr := AnsiUpperCase(Cells[CCol_AccCurrency, i]);
        if pCurr = '' then
        begin
          Cells[CCol_AccMonConversion, i] := '';
          Cells[CCol_AccCurrencyRate, i] := '';
        end
        else
        begin
          pDCSum := trim(Cells[CCol_AccDebit, i]);
          if pDCSum = '' then
            pDCSum := trim(Cells[CCol_AccCredit, i]);


          pCurrIndx := self.FCurrDataList.IndexOf(pCurr);
          if pCurrIndx >= 0 then
            pCurrVal := _normZero(TCurrencyObjType(self.FCurrDataList.Objects[pCurrIndx]).currVal)
          else
            pCurrVal := 0;
          Cells[CCol_AccCurrencyRate, i] := format(CCurrentAmFmt3, [pCurrVal]);

          // kas midagi leiti lõpuks...
          if pDCSum <> '' then
          begin
            //if  pCurr=estbk_globvars.glob_baseCurrency then
            //    continue;


            // -- !!
            assert(pCurrIndx >= 0);

            pConvVal := _normZero(roundTo(StrToFloatDef(pDCSum, 0) * pCurrVal, Z2));
            // arvutame andmed vastavalt kursile...
            Cells[CCol_AccMonConversion, i] := trim(format(CCurrentMoneyFmt1, [pConvVal])); // FloatTostr(
          end
          else
            Cells[CCol_AccMonConversion, i] := '';
        end;
        // --------
      end;
    end;
end;


procedure TframeGeneralLedger.accountingGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  pColPos: integer;
  pRowPos: integer;
  pClientData: TClientData;
  pClDescr: TIntIDAndCTypes;
  pClientId: integer;
begin

  if not edtDocNr.Enabled or edtDocNr.ReadOnly then // järelikult kogu elu on RO !
    Exit;

  if (Shift = [ssCtrl]) and (key = VK_RETURN) then
  begin

    if (Sender is TPicklistCellEditor) then
    begin
      TPicklistCellEditor(Sender).DroppedDown := True;
      key := 0;
    end
    else
    // 21.03.2011 Ingmar
    if (accountingGrid.Col = CCol_Client) and (Sender is TStringCellEditor) then
      try
        pClientId := 0;
        pClDescr := accountingGrid.Objects[CCol_Client, accountingGrid.row] as TIntIDAndCTypes;
        if assigned(pClDescr) then
          pClientId := pClDescr.id;

        // -------
        pClientData := estbk_frm_choosecustmer.__chooseClient(pClientId);
        // -------

        if assigned(pClientData) then
        begin

          if (TStringCellEditor(Sender).CanFocus) then
            TStringCellEditor(Sender).SetFocus;

          if not assigned(pClDescr) then
            pClDescr := TIntIDAndCTypes.Create;
          pClDescr.id := pClientData.FClientId;
          pClDescr.clf := pClientData.FCustFullName; // hoiame muudatuste jaoks !
          pClDescr.clf2 := pClientData.FClientCode;

          // ---
          accountingGrid.Objects[CCol_Client, accountingGrid.row] := pClDescr;
          TStringCellEditor(Sender).Text := pClientData.FCustFullName;
          key := 0;
        end;
      finally
        FreeAndNil(pClientData);
      end;
    // ---
  end
  else
  if (Shift = [ssCtrl]) and (key = VK_DELETE) then
  begin
    deleteGenLedgLine(self.FPaCurrRowPos);
    key := 0;
  end
  else
  if (Shift = []) and ((key = VK_TAB) or (key = VK_RETURN)) then
    with accountingGrid do
    begin
      // 15.05.2011 Ingmar peab käsitsi evendi välja kutsuma !
      self.accountingGridEditingDone(accountingGrid);
      if Col < ColCount - 2 then // jätame selle viimase "objekti" valiku nupu välja
      begin
        pColPos := Col;

        pRowPos := Row;



        // TODO; vii ühte proc need 3 tegevust !
        //self.calcAccSumTotal(col=CCol_AccDebit);
        self.calcAccSumTotal(True);
        self.calcAccSumTotal(False);
        self.doCConversion;


        // --
        self.addDCSideSum(pColPos, pRowPos);




        Col := pColPos;
        Row := pRowPos;
        if Col in [CCol_AccCurrencyRate, CCol_AccMonConversion] then
        begin
          Col := CCol_Client - 1;
          exit;
        end;

      end
      else
      if Row <= RowCount then
      begin
        Row := Row + 1;
        Col := 1;
      end;


      self.lazFocusFix.Enabled := True;
{
          // grid
          if  CanFocus then
              SetFocus;

          // lazarus ikka kaotab fookuse !
          if assigned(Editor) and Editor.CanFocus then
             Editor.SetFocus;}
      key := 0;
    end;
end;


procedure TframeGeneralLedger.deleteGenLedgLine(const pRowNr: integer);
var
  i, j: integer;
begin
  if self.FGridReadOnly then
    exit;

  self.FLastDSideSum := 0;
  self.FLastCSideSum := 0;

  stxtDPart.Text := '';
  stxtCPart.Text := '';

  // ---
  assert(pRowNr > 0, '#7');
  if Dialogs.messageDlg(estbk_strmsg.SCConfGenLedLineDelConf, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;

  with accountingGrid do
  begin
    // objektid ka vabastada

    for i := 1 to ColCount - 1 do
      if assigned(Objects[i, pRowNr]) then
      begin
        Objects[i, pRowNr].Free;
        Objects[i, pRowNr] := nil;
      end;


    Clean(CCol_Account, pRowNr, Colcount, pRowNr, [gzNormal]);
    for i := pRowNr to rowcount - 2 do
    begin
      for j := 1 to colcount - 1 do
      begin
        // if (j=CCol_Account) or (j>=CCol_Client) then
        Objects[j, i] := Objects[j, i + 1];
        Cells[j, i] := Cells[j, i + 1];
      end;
    end;

    // lihtne, kuid efektiivne trikk !
    // korra peame liigutama kirjet, et editor õigesti väärtustataks
    if Row < RowCount - 1 then
    begin
      Row := pRowNr + 1;
      Row := pRowNr - 1;
    end
    else
    begin
      Row := pRowNr - 1;
      Row := pRowNr + 1;
    end;

    Col := Col + 1;
    Col := Col - 1;
    //Editor:=nil;
    if assigned(Editor) then
      Editor.Visible := False;


    // arvutame siis kande tasakaalu uuesti !
    self.calcAccSumTotal(True);
    self.calcAccSumTotal(False);
    self.doCConversion; // ja kursid ka paika kui vaja...


    if CanFocus then
      SetFocus;
  end; // ---

end;


procedure TframeGeneralLedger.calcAccSumTotal(const pDebitSide: boolean = True); // teisel juhul oleks kreedit
var
  i: integer;
  pColSide: integer;
  pSum: double;
  pVal: double;
begin
  pSum := 0;
  with accountingGrid do
  begin
    if pDebitSide then
      pColSide := CCol_AccDebit
    else
      pColSide := CCol_AccCredit;

    // ---
    for i := 1 to RowCount - 1 do
      if Cells[pColSide, i] <> '' then
      begin
        // 04.11.2009 Ingmar
        if trim(Cells[CCol_AccMonConversion, i]) <> '' then
          pVal := _normZero(StrToFloatDef(trim(Cells[CCol_AccMonConversion, i]), 0))
        else
          pVal := _normZero(StrToFloatDef(Cells[pColSide, i], 0));
        // seoses valuutakannetega loogika muutus natuke !
        pSum := pSum + pVal;
      end;




    // ---
    // kuvame kande tasakaalu !
    case pDebitSide of
      True:
      begin
        // stxtDPart.Caption := systoutf8(format(' %m', [pSum]));
        stxtDPart.Caption := Format(' %m', [pSum]);
        self.FLastDSideSum := pSum;
      end;

      False:
      begin
        // stxtCPart.Caption := systoutf8(format(' %m', [pSum]));
        stxtCPart.Caption := Format(' %m', [pSum]);
        self.FLastCSideSum := pSum;
      end;
    end;
  end;
end;


// TODO teha samasugune change detect nagu arvetes, see hetke lahendus on jama
procedure TframeGeneralLedger.OnGridEditorChangeEvnt(Sender: TObject);
begin
  self.detectChangesAndEnableSaveBtn;
end;

// totakas lazaruse bugi mdi puhul, et kui elemendile klikid ei pruugi ta fookust saada ! täiesti sürr
procedure TframeGeneralLedger.OnGridEditorClickEvnt(Sender: TObject);
begin
  if (Sender is TWinControl) and (TWinControl(Sender).CanFocus) then
    TWinControl(Sender).SetFocus;
end;

procedure TframeGeneralLedger.accountingGridEditingDone(Sender: TObject);
var
  pData: TIntIDAndCTypes;
begin

  // --- kasutan senderit markerina, kui otse kutsutakse välja, siis ta NIL !!!
  if assigned(Sender) then
    with accountingGrid do
    begin

      // arvutame pidevalt informatiivseid summasid !!!
      if (col in [CCol_AccDebit, CCol_AccCredit]) then
      begin

        if trim(Cells[Col, Row]) <> '' then
          Cells[Col, Row] := format(CCurrentMoneyFmt2, [_normZero(roundto(StrToFloatDef(Cells[Col, Row], 0), Z2))]);


        // 26.10.2010 Ingmar
        self.calcAccSumTotal(col = CCol_AccDebit);
        // paremale poole siis nö summa baasrahas !
        self.doCConversion;
      end
      else
      // 21.03.2011 Ingmar
      if (col = CCol_client) then
      begin
        pData := Objects[Col, Row] as TIntIDAndCTypes;
        if assigned(pData) then
        begin

          // -- märgiti klient, keda pole süsteemis kirjeldatud ? clf hoiab originaalnime
          if (trim(Cells[Col, Row]) <> pData.clf) then
          begin
            Objects[Col, Row].Free;
            Objects[Col, Row] := nil;
          end;

        end; // --
      end;

      // ------------
    end
  else
  begin
    self.calcAccSumTotal(True);
    self.calcAccSumTotal(False);
    self.doCConversion;
  end;



  // !!!!
  // varasema kirje avamisel vaatame, kas avame ka salvestamise nupu; ehk kas midagi ka muutus gridis - tavaväljadel !
  self.detectChangesAndEnableSaveBtn;

end;

procedure TframeGeneralLedger.accountingGridClick(Sender: TObject);
begin
  // ---
end;


procedure TframeGeneralLedger.accountingGridDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
const
  CLeftCorr = 2;
var
  pts: TTextStyle;
begin

  // 28.09.2009 Ingmar; vahetevahel olen ikka täitsa rumal;
  // pikalt mõtlesin, miks titlet ei kirjutada, aga table sisu küll. Header tuleb ise joonistada

  with TStringGrid(Sender) do
  begin

    Canvas.Font.Style := [];
    Canvas.Pen.Color := clWindowText;

    // tiitel
    if (aRow = 0) and (aCol > 0) then
    begin
      Canvas.FillRect(aRect);
      Canvas.TextOut(aRect.Left + 5, aRect.Top + 2, Columns.Items[aCol - 1].Title.Caption);
    end;


    // Tpicllist pole meie sõber !
    if not Enabled or self.FGridCleanup then
      exit;


    //Canvas.TextWidth
    //InflateRect(FocusedRect, -2, -2);
    if (aCol >= CCol_Client + 1) then
    begin
      if (gdFocused in aState) then
      begin
        FAccObjGroups.Left := (aRect.Left + TStringGrid(Sender).Left) - CLeftCorr;
        FAccObjGroups.Top := aRect.Top;
        FAccObjGroups.Width := (aRect.Right - aRect.Left) - 2;
        FAccObjGroups.Height := (aRect.Bottom - aRect.Top) - 2;

        FAccObjTypes.Left := (aRect.Left + TStringGrid(Sender).Left) - 3;
        FAccObjTypes.Top := aRect.Top;
        FAccObjTypes.Width := (aRect.Right - aRect.Left) - 2;
        FAccObjTypes.Height := (aRect.Bottom - aRect.Top) - 2;
      end;
      // ---
    end
    else
    if (aCol = CCol_Account) then
    begin
      if (gdFocused in aState) then
      begin
        FAccListCombo.Left := (aRect.Left + TStringGrid(Sender).Left) - CLeftCorr;
        FAccListCombo.Top := aRect.Top;
        //aRect.Top + TStringGrid(Sender).Top + 2;
        FAccListCombo.Width := (aRect.Right - aRect.Left) - 2;
        FAccListCombo.Height := (aRect.Bottom - aRect.Top) - 2;

      end;
    end
    else
    // 21.03.2011 Ingmar
    if (aCol = CCol_Client) then
    begin

      //fsBold, fsItalic, fsStrikeOut, fsUnderline
      if assigned(Objects[aCol, aRow]) and (TIntIDAndCTypes(Objects[aCol, aRow]).id > 0) then
      begin
        Canvas.Font.Style := [fsUnderline];
        Canvas.FillRect(aRect);
        Canvas.TextOut(aRect.Left + 5, aRect.Top + 2, TIntIDAndCTypes(Objects[aCol, aRow]).clf);
      end;
    end;


    // ---
  end;
end;


procedure TframeGeneralLedger.addObjCol;
var
  pGridCol: TGridColumn;
begin
  // ---
  Inc(FObjectColCnt);

  with self.accountingGrid do
  begin
    Columns.Items[Columns.Count - 1].Title.Caption := format(estbk_strmsg.CSObjectCol, [FObjectColCnt]);
    Columns.Items[Columns.Count - 1].ReadOnly := False;
    Columns.Items[Columns.Count - 1].ButtonStyle := cbsAuto;
    Columns.Items[Columns.Count - 1].Width := 200;
    Columns.Items[Columns.Count - 1].MaxSize := 300;
    Columns.Items[Columns.Count - 1].MinSize := 10;

    pGridCol := Columns.Add;
    pGridCol.ButtonStyle := cbsButton;
    pGridCol.MinSize := 25;
    pGridCol.MaxSize := 25;
    pGridCol.Width := 25;
    pGridCol.ReadOnly := True;
    pGridCol.Title.Caption := ' + ';

    //SetFocus;
    Col := Columns.Count - 1;
    // timeriga viime cursori eelmisele columnile, ainus võimalus mööda saada igasugustest gridi bugidest !!!
    //ColCount:=ColCount+1;
  end;
end;

procedure TframeGeneralLedger.accountingGridEditButtonClick(Sender: TObject);
begin
  if Self.FGridReadOnly then
    Exit;

  // fookuse trikk, muidu objekti väljad ei tööta õigesti !
  if self.FAccObjTypes.Visible and self.FAccObjTypes.CanFocus then
    SetFocus;

  self.addObjCol;
end;



procedure TframeGeneralLedger.accountingGridEnter(Sender: TObject);
begin
  // Memo1.lines.add('accountingGridEnter');
  // ---
  if not self.FGridReadOnly and (accountingGrid.Row = 1) and (accountingGrid.Col = 1) and not self.FAccListCombo.Visible then
  begin
    self.FPaCurrColPos := -1;
    self.FPaCurrRowPos := -1;
    // 31.10.2009 Ingmar; fix
    TStringGrid(Sender).Editor := self.FAccListCombo;
    //self.FAccListCombo.OnEnter(self.FAccListCombo);
  end;
end;

procedure TframeGeneralLedger.accountingGridExit(Sender: TObject);
begin
  // 03.01.2010 Ingmar
  self.accountingGridEditingDone(nil);

end;

procedure TframeGeneralLedger.accountingGridGetEditMask(Sender: TObject; ACol, ARow: integer; var Value: string);
begin
  // -------- ärme kasuta, siis kompatiiblus kadunud
 (*
   if ( aCol = 5 ) then
     PostMessage(Self.Handle
    ,WM_SETMAXLENGTH
    ,{WParam=}55)
    ,{LParam=}LongInt(TStringGridCracker(Sender).InplaceEditor));
 *)
end;

procedure TframeGeneralLedger.accountingGridHeaderClick(Sender: TObject; IsColumn: boolean; Index: integer);
begin
  if isColumn and (Index = TStringGrid(Sender).ColCount - 1) then
    self.accountingGridEditButtonClick(Sender);
end;


procedure TframeGeneralLedger.accountingGridKeyPress(Sender: TObject; var Key: char);
var
  pData: AStr;
  pCPos: integer;
begin
  if Self.FGridReadOnly then
  begin
    key := #0;
    Exit;
  end;

  case key of
    ^V: key := #0;
    // hetkel välistame paste käsu !! järgmistes versioonides lisandub, probleemiks andmete kontroll
    #8: ; // tab las hetkel olla
    #9: ; // backspace...sama siin
    #13:
    begin
      SelectNext(Sender as twincontrol, True, True);
      key := #0;
    end
    else
      with TStringGrid(Sender) do
      begin

        // ei luba deebet ja kreedit väljale andmeid sisestada; st mõlemale; on üks või teine !!!!!
        if ((Col = CCol_AccDebit) and (trim(Cells[CCol_AccCredit, Row]) <> '') or (Col = CCol_AccCredit) and
          (trim(Cells[CCol_AccDebit, Row]) <> '')) then
          key := #0
        else // kõik korras, jätkame nagu norras...
        if // assigned(self.FOrigEditor) and (self.FOrigEditor is TCustomEdit) and
        (Editor is TCustomEdit) and (Col in [CCol_AccDebit, CCol_AccCredit]) then
        begin
          // üle 12 märgi ei luba per cell !!!
          if length(Cells[Col, Row]) > 11 then
            key := #0
          else
          begin

            // 28.10.2010 Ingmar; ei lubanud kirjutada üle selekteeritud teksti !
            if (TStringCellEditor(Editor).SelLength <> length(TStringCellEditor(Editor).Text)) then
            begin
              // 2 kohta peale koma !!!!!
              pCPos := pos('.', Cells[Col, Row]);
              if pCPos = 0 then
                pCPos := pos(',', Cells[Col, Row]);

              if pCPos > 0 then
              begin
                pData := system.copy(Cells[Col, Row], pCPos + 1, length(Cells[Col, Row]) - pCPos + 1);
                if length(pData) = 2 then
                begin
                  key := #0;
                  exit;
                end;
              end;
            end; // ---

            estbk_utilities.edit_verifyNumericEntry(Editor as TCustomEdit, key, True);
          end;
          // ----------
        end;
      end;
  end;
  // ---
end;

procedure TframeGeneralLedger.accountingGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  Column, Row: integer;
begin
  // üritame liigset "minimiseerimist" ära hoida, lazaruse headerite constraint ei tööta !
  TStringGrid(Sender).MouseToCell(X, Y, Column, Row);
  {
      myCellResizeInProgress = true;
      myBoundaryPicked = WhichBoundaryPicked(X,Y);
      myColumnBeingResized = Column;
      }
end;

procedure TframeGeneralLedger.accountingGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
(*
 void __fastcall TMainForm::StringGridMouseUp(TObject *Sender,
      TMouseButton Button, TShiftState Shift, int X, int Y)
{
   myCellResizeInProgress = false;

   int IntendedWidth;

   if (myBoundaryPicked == CloserToRightBoundary) // Resize the cell being resized
   {
      IntendedWidth = NewWidth(myColumnBeingResized,X,Y);

      if (IntendedWidth != StringGrid->ColWidths[myColumnBeingResized])
      {
         StringGrid->ColWidths[myColumnBeingResized] = IntendedWidth;
      };
   }
   else // Resize the cell to the left of the cell being resized
   {
      if (myColumnBeingResized > 0) // Can't resize col -1
      {
         IntendedWidth = NewWidth(myColumnBeingResized-1,X,Y);

         if (IntendedWidth != StringGrid->ColWidths[myColumnBeingResized-1])
         {
            StringGrid->ColWidths[myColumnBeingResized-1] = IntendedWidth;
         };
      };
   };
}
*)
end;

procedure TframeGeneralLedger.accountingGridMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer;
  MousePos: TPoint; var Handled: boolean);
begin
  // --
end;

procedure TframeGeneralLedger.accountingGridPickListSelect(Sender: TObject);
var
  pReload: boolean;
  pItemIndex: integer;
  pCurr: AStr;
  pGridCurrList: TPicklistCellEditor;
begin

  if self.FSkipOnChangeSelectEvents then
    exit;


  // ----
  pGridCurrList := accountingGrid.EditorByStyle(cbsPickList) as TPicklistCellEditor;
  // with TPicklistCellEditor(accountingGrid.Editor) do
  pCurr := accountingGrid.Cells[CCol_AccCurrency, accountingGrid.Row];


  // me ei tea ju siin, millist päeva kurssi kasutada !
  if edtAccdate.Text = '' then
  begin
    estbk_utilities.miscResetCurrenyValList(accountingGrid.EditorByStyle(cbsPickList) as TPicklistCellEditor);
    pGridCurrList.ItemIndex := -1;
  end
  else
  if pCurr <> estbk_globvars.glob_baseCurrency then // vaatame, kas meil on antud valuuta päevakursid !
  begin
    // 24.08.2010 Ingmar
    pReload := estbk_clientdatamodule.dmodule.revalidateCurrObjVals(edtAccdate.Date, self.FCurrDataList);
    if not pReload then
      if Dialogs.messageDlg(format(estbk_strmsg.SAccCurDownloadNeeded, [datetostr(edtAccdate.Date), pCurr]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        pItemIndex := pGridCurrList.ItemIndex;
        estbk_utilities.miscResetCurrenyValList(accountingGrid.EditorByStyle(cbsPickList) as TPicklistCellEditor);
        pGridCurrList.ItemIndex := pItemIndex;


        estbk_clientdatamodule.dmodule.downloadCurrencyData(False, edtAccdate.Date);
        if not estbk_clientdatamodule.dmodule.revalidateCurrObjVals(edtAccdate.Date, self.FCurrDataList) then
          Dialogs.MessageDlg(estbk_strmsg.SEAccCantUpdateCurrRates, mtError, [mbOK], 0);
      end
      else
        pGridCurrList.ItemIndex := -1;
  end;
  // ---


  if (pGridCurrList.ItemIndex >= 0) and assigned(pGridCurrList.items.Objects[pGridCurrList.ItemIndex]) then
    pGridCurrList.Hint := format(CCurrentAmFmt4, [TCurrencyObjType(pGridCurrList.items.Objects[pGridCurrList.ItemIndex]).currVal])
  else
    pGridCurrList.Hint := '';

  // --
  self.doCConversion;

end;


procedure TframeGeneralLedger.accountingGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  // ---
  // Memo1.lines.add(format('hiir toimetab %d %d',[x,y]));
end;


procedure TframeGeneralLedger.accountingGridPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
var
  FDCmbIndx: integer;
  FAccId: cardinal;
  pts: TTextStyle;
  i: integer;
begin

  with TStringGrid(Sender) do
  begin

    pts := Canvas.TextStyle;
    if aCol in [CCol_AccDebit, CCol_AccCredit, CCol_AccMonConversion] then
      pts.Alignment := taRightJustify
    else
      pts.Alignment := taLeftJustify;
    Canvas.TextStyle := pts;
    Canvas.Pen.Color := clWindowText;

    if (aCol < 1) or (aRow < 1) then
      Canvas.Brush.Color := clBtnFace
    else
    if (aCol in [CCol_AccMonConversion, CCol_accCurrencyRate]) then
    begin
      Canvas.Brush.Color := MyFavMediumGray;
    end
    else
    if ((aRow mod 2) <> 0) then // and not (gdFocused in aState)  then
      Canvas.Brush.Color := MyFavGray // cl3DLight
    else
      Canvas.Brush.Color := clWindow;
    // ---
  end;
end;




procedure TframeGeneralLedger.accountingGridSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
begin
  // --
end;


function TframeGeneralLedger.resolveAccountNamebyCode(const paccCode: AStr): AStr;
var
  pbookMark: TBookmark;
begin
  Result := '';
  if (length(paccCode) > 0) and qryAllAccounts.Active then
    try
      pbookMark := qryAllAccounts.GetBookmark;
      qryAllAccounts.DisableControls;
      // ---
      if qryAllAccounts.Locate('account_coding', paccCode, [loCaseInsensitive]) then
        Result := qryAllAccounts.FieldByName('account_name').AsString;
    finally
      if assigned(pbookMark) then
      begin
        qryAllAccounts.GotoBookmark(pbookMark);
        qryAllAccounts.FreeBookmark(pbookMark);
      end;

      qryAllAccounts.EnableControls;
      // -------
    end;
end;


procedure TframeGeneralLedger.OnPickListEnter(Sender: TObject);
var
  pindex: integer;
begin
  // ---
  self.FLastPickListCol := self.accountingGrid.Col;
  self.FLastPickListRow := self.accountingGrid.Row;

  if Sender is TPicklistCellEditor then
    with TPicklistCellEditor(Sender) do
    begin
      pindex := self.FCurrDataList.IndexOf(accountingGrid.Cells[CCol_AccCurrency, self.accountingGrid.Row]);
      if pindex >= 0 then
        Hint := format(CCurrentAmFmt4, [_normZero(TCurrencyObjType(FCurrDataList.Objects[pindex]).currVal)])
      else
        Hint := '';
    end;
end;

procedure TframeGeneralLedger.OnPickListExit(Sender: TObject);
begin
  // ---
  //if (self.FLastPickListCol>0) and (self.FLastPickListRow>0) and self.accountingGrid.visible then
  //    self.accountingGrid.Cells[self.FLastPickListCol,self.FLastPickListRow]:='EEK';
end;




procedure TframeGeneralLedger.accountingGridSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
var
  pObjCellData: TCellObjectType;
  pGrpId: integer;
  pAccId: integer;
  pIndex: integer;
begin

  self.FPaCurrColPos := aCol;
  self.FPaCurrRowPos := aRow;


  // 24.08.2010 Ingmar
  if self.FSkipEditorSelect then
    exit;

  lazFocusFix.Enabled := False;
  lazObjchangeTimer.Enabled := False;



  self.FLastPickListCol := -1;
  self.FLastPickListRow := -1;
  // ----


  if TStringGrid(Sender).CanFocus then
    TStringGrid(Sender).SetFocus;


  if self.FGridCleanup or self.FGridReadOnly then
  begin

    self.FAccListCombo.Visible := False;
    if self.FAccObjGroups.PopupVisible then
      self.FAccObjGroups.PopupVisible := False;

    if self.FAccObjTypes.PopupVisible then
      self.FAccObjTypes.PopupVisible := False;

    self.FAccObjGroups.Visible := False;
    self.FAccObjTypes.Visible := False;


    Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto));
    // 11.04.2010 ingmar
    if aCol = CCol_Account then
    begin
      Editor.ShowHint := True;
      Editor.Hint := self.resolveAccountNamebyCode(TStringGrid(Sender).Cells[aCol, aRow]);

    end
    else
    begin
      Editor.ShowHint := False;
      Editor.Hint := '';
    end;

    TStringCellEditor(TStringGrid(Sender)).OnKeyDown := nil;
    TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto)).ReadOnly := self.FGridReadOnly;
    if ((aRow mod 2) <> 0) then
      TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto)).Color := estbk_types.MyFavGray
    else
      TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto)).Color := clwindow;
    Exit;

  end;


  // ----
  if (aCol = TStringGrid(Sender).ColCount - 1) then
  begin

    Editor := TButtonCellEditor(TStringGrid(Sender).EditorByStyle(cbsButton));
    TButton(Editor).Caption := 'O'; // O nagu objekt
    TButton(Editor).Font.Style := [fsBold];
    TButton(Editor).Hint := estbk_strmsg.SGenLedNewObjectColumnHint;
    if Editor.CanFocus then
      Editor.SetFocus;

  end
  else
  if (aCol >= CCol_Client + 1) and (aCol < TStringGrid(Sender).ColCount) then
    try
      self.FSkipOnChangeSelectEvents := True;
      // --
      pObjCellData := accountingGrid.Objects[aCol, aRow] as TCellObjectType;
      if not assigned(pObjCellData) or (pObjCellData.ObjectId < 1) then // pole konkreetset objekti valinud
      begin
        //FAccObjTypes.Visible:=false;
        self.FAccObjGroups.Text := '';
        self.FAccObjGroups.Value := '0';
        Editor := self.FAccObjGroups;




        FAccObjGroups.Visible := True;
        FAccObjGroups.Enabled := True;
       {
       if assigned(pObjCellData) then
          FAccObjGroups.Value:=inttostr(pObjCellData.ObjectGrp)
       else
          FAccObjGroups.Value:='';  }
        self.lazFocusFix.Enabled := True;
      end
      else
      begin
        assert(assigned(accountingGrid.Objects[aCol, aRow]), '#3');
        //FAccObjGroups.Visible:=false;
        self.FAccObjTypes.Text := '';
        self.FAccObjTypes.Value := '0';
        Editor := self.FAccObjTypes;




        pGrpId := TCellObjectType(accountingGrid.Objects[aCol, aRow]).ObjectGrp;

        qryObjects.Filtered := False;
        qryObjects.Filter := format('classificator_id=%d', [pGrpId]);
        qryObjects.Filtered := True;
        qryObjects.Locate('id', TCellObjectType(accountingGrid.Objects[aCol, aRow]).ObjectId, []);
        FAccObjTypes.Value := IntToStr(pObjCellData.ObjectId);

        FAccObjTypes.Visible := True;
        FAccObjTypes.Enabled := True;
        //accountingGrid.SetFocus;


        if FAccObjTypes.CanFocus then
          FAccObjTypes.SetFocus;




        // 18.08.2010 Ingmar
        self.lazFocusFix.Enabled := True;
      end;
    finally
      self.FSkipOnChangeSelectEvents := False;
    end
  else
  if (aCol = CCol_AccCurrency) then
  begin

    if length(edtAccdate.Text) > 0 then
    begin
      // if (Editor is TStringCellEditor) then
      //     TStringCellEditor(Editor).readOnly:=False;

      Editor := TPicklistCellEditor(TStringGrid(Sender).EditorByStyle(cbsPicklist));

      TPicklistCellEditor(Editor).OnEnter := @self.OnPickListEnter;
      TPicklistCellEditor(Editor).OnExit := @self.OnPickListExit;
      TPicklistCellEditor(Editor).AutoComplete := True;
      TPicklistCellEditor(Editor).OnKeyDown := @accountingGridKeyDown;
      TPicklistCellEditor(Editor).Style := csDropDownList;
      TPicklistCellEditor(Editor).ShowHint := True;


      // 03.11.2009 Ingmar; luban ainult siis, kui olemas ka kande kuupäev !
      TPicklistCellEditor(Editor).Enabled := length(edtAccdate.Text) > 0;
      //TPicklistCellEditor(Editor).AutoDropDown:=true;
      TPicklistCellEditor(Editor).Items.Assign(self.FCurrDataList);

      if TPicklistCellEditor(Editor).CanFocus then
        TPicklistCellEditor(Editor).SetFocus;
    end;
  end
  else
  if (aCol in [CCol_AccDebit, CCol_AccCredit]) then
  begin
    // vaikimisi valuuta PEAB oleam !
    if (trim(accountingGrid.Cells[CCol_AccCurrency, aRow]) = '') and (trim(accountingGrid.Cells[CCol_Account, aRow]) <> '') then
      accountingGrid.Cells[CCol_AccCurrency, aRow] := estbk_globvars.glob_baseCurrency;




    Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto));
    TStringCellEditor(Editor).Color := glob_userSettings.uvc_colors[uvc_activeGridEditorColor]; //clWindow;


    pIndex := self.FCurrDataList.IndexOf(accountingGrid.Cells[CCol_AccCurrency, aRow]);
    TStringCellEditor(Editor).ReadOnly := (pIndex = -1) or (Math.isZero(TCurrencyObjType(self.FCurrDataList.Objects[pIndex]).currVal));

    if Editor.CanFocus then
      Editor.SetFocus;



    // näeb välja sürr, aga selle koodiga saame viimased valuutakursid !
    if (accountingGrid.Cells[CCol_AccCurrency, aRow] <> '') and TStringCellEditor(Editor).ReadOnly then
      self.accountingGridPickListSelect(accountingGrid);

  end
  else
  if (aCol = CCol_Account) then
    try

      // 02.03.2010 Ingmar FIX; täiesti tobe, millegipärast tõmmatakse siin käima onselect event !!!!!!!!!!!!!
      self.FSkipOnChangeSelectEvents := True;

      FAccListCombo.Visible := True;
      FAccListCombo.Enabled := True;
      Editor := self.FAccListCombo;


      if accountingGrid.CanFocus then
        accountingGrid.SetFocus;



      FAccListCombo.Text := '';
      if assigned(accountingGrid.Objects[aCol, aRow]) then
      begin
        // ---
        pAccId := TCellAccountType(accountingGrid.Objects[aCol, aRow]).AccountId;
        if pAccId > 0 then
        begin
          qryAllAccounts.locate('id', pAccId, []);
          FAccListCombo.Value := IntToStr(pAccId);
          FAccListCombo.Text := qryAllAccounts.FieldByName('account_coding').AsString;
        end
        else
        begin
          FAccListCombo.Value := '';
          FAccListCombo.Text := '';
          qryAllAccounts.First;
        end;
        // ---
      end;


    finally
      self.FSkipOnChangeSelectEvents := False;
      // 18.08.2010 Ingmar; lazaruse fookuse kala parandamine; ei suuda lookupcombot fokuseerida !
      self.lazFocusFix.Enabled := True;
    end
  else
  begin
    Editor := TStringCellEditor(TStringGrid(Sender).EditorByStyle(cbsAuto));
    TStringCellEditor(Editor).ReadOnly := False;
    TStringCellEditor(Editor).Color := glob_userSettings.uvc_colors[uvc_activeGridEditorColor]; //clWindow;

    if Editor.CanFocus then
      Editor.SetFocus;
    //Editor.SetFocus;
  end;



  // 29.10.2009 ingmar
  // mul raske, mis asi keerab fondi värvuse pidevalt valgeks ?!
  Editor.Font.Color := clBlack;
end;

procedure TframeGeneralLedger.btnCancelClick(Sender: TObject);
begin
  TBitBtn(Sender).Enabled := False;
  // ---
  if self.FInsertMode then
    try
      self.FSkipEditorSelect := True;

      self.performCleanup;
      self.FGridReadOnly := True;



      self.accountingGrid.Editor := self.accountingGrid.EditorByStyle(cbsAuto);
      estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox as TWinControl, False);
      ovrAllGrpbox.Enabled := True;
      accountingGrid.Enabled := True;

      btnNewEntry.Enabled := True;
      btnCopy.Enabled := True;
      btnSaveEntry.Enabled := False;

      if btnNewEntry.CanFocus then
        btnNewEntry.SetFocus;

     {
     self.FAccListCombo.Visible:=false;
     self.FAccListCombo.Text:='';
     self.FAccListCombo.Value:='';
     }
      self.FPaCurrRowPos := 1;
      self.FPaCurrColPos := 1;


    finally
      self.FSkipEditorSelect := False;
    end
  else
    self.openEntry(self.FOpenedEntryId);
end;

// TÜHISTAME KANDE !
procedure TframeGeneralLedger.btnCancelGdClick(Sender: TObject);
begin

  if Dialogs.messageDlg(format(estbk_strmsg.SConfGenLedRecCancellation, [edtAccnr.Text]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    try
      estbk_clientdatamodule.dmodule.primConnection.StartTransaction;

      with qryAccData, SQL do
      begin
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdCancelAccReg);
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('id').AsInteger := self.FOpenedEntryId;
        execSQL;
      end;

      // ----
      // tühistame kandekirjed !
      self.cancelAccRecords(self.FOpenedEntryId);
      estbk_clientdatamodule.dmodule.primConnection.Commit;

      // teavitame muutustest
      if assigned(FFrameDataEvent) then
        FFrameDataEvent(Self, __frameGenLedEntryChanged, self.FOpenedEntryId);

      self.btnNewEntry.Enabled := True;
      self.btnCopy.Enabled := True;
      self.btnNewEntry.SetFocus;


      self.btnSaveEntry.Enabled := False;
      TBitBtn(Sender).Enabled := False; // ---
      self.FGridReadOnly := True;
      // ---------------------
      estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox as TWinControl, False);
      ovrAllGrpbox.Enabled := True;
      accountingGrid.Enabled := True;


      self.FGridReadOnly := True;
      self.openEntry(self.FOpenedEntryId);

    except
      on e: Exception do
      begin
        if estbk_clientdatamodule.dmodule.primConnection.inTransaction then
          try
            estbk_clientdatamodule.dmodule.primConnection.Rollback;
          except
          end;

        Dialogs.MessageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);

        if accountingGrid.CanFocus then
          accountingGrid.SetFocus;

      end;
      // ---
    end;
end;

procedure TframeGeneralLedger.btnChooseOutputClick(Sender: TObject);
var
  pFindPOwner: TWincontrol;
begin
  pFindPOwner := self.Parent;
  while assigned(pFindPOwner) do
  begin
    if (pFindPOwner is TForm) then
      break;

    // ---
    pFindPOwner := pFindPOwner.Parent;
  end;


  popupChooseOutput.PopUp(TForm(pFindPOwner).left + TSpeedButton(Sender).left + TSpeedButton(Sender).Width + 8,
    TForm(pFindPOwner).top + TSpeedButton(Sender).top + TSpeedButton(Sender).Height + 85);

end;

procedure TframeGeneralLedger.btnCloseClick(Sender: TObject);
begin
  if assigned(FframeKillSignal) then
    FframeKillSignal(self);
end;

procedure TframeGeneralLedger.btnCopyClick(Sender: TObject);
var
  i: integer;
begin

  if estbk_lib_commoncls.copySGridContent(accountingGrid, self.FCopyObjs, [0]) then
    try
      FCopyDescr := edtTransDescr.Text;
      if not self.FGridReadOnly then
        FCopyDocIndx := cmbDocumentType.ItemIndex
      else
        // parem mitte dok. tüüpi määrata, sest miskit pärast on RO;
        FCopyDocIndx := -1;

      btnNewEntry.OnClick(btnNewEntry);
      edtTransDescr.Text := FCopyDescr;
      cmbDocumentType.ItemIndex := FCopyDocIndx;

      restoreGridContent(accountingGrid, self.FCopyObjs);
      // peame nullima esimese rea info, et ta ei arvaks, justkui oleks tegemist varem salvestatud andmetega
      for i := 1 to accountingGrid.RowCount - 1 do
        if assigned(accountingGrid.Objects[CCol_Account, i]) then
          TCellAccountType(accountingGrid.Objects[CCol_Account, i]).AccountRecID := 0;
      calcAccSumTotal(False);
      calcAccSumTotal(True);

    finally
      self.FCopyObjs.Clear;
      self.FCopyDescr := '';
      self.FCopyDocIndx := -1;
      TBitBtn(Sender).Enabled := False;
    end
  else
    Dialogs.MessageDlg(estbk_strmsg.SENothingToCopy, mtError, [mbOK], 0);
end;

procedure TframeGeneralLedger.btnNewEntryClick(Sender: TObject);
begin
  if not self.loadData then
    self.loadData := True;

  self.FLastDSideSum := 0;
  self.FLastCSideSum := 0;

  // puhastame kõik eelmise kandega seotud andmed
  self.FGridReadOnly := False;

  self.performCleanup;

  // @@@
  estbk_utilities.changeWCtrlReadOnlyStatus(ovrAllGrpbox, False);
  estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox, True);

  cmbDocumentType.Enabled := True;
  ovrAllGrpbox.Enabled := True;
  accountingGrid.Enabled := True;



  self.FInsertMode := True;
  self.FOpenedEntryId := 0;
  self.FOpenedEntryBaseDocId := 0;

  // 01.03.2012 Ingmar
  edtAccnr.Text := dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', now, False, estbk_types.CAccGen_rec_nr, True, True);
  //estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox as TWinControl, True);


  TBitBtn(Sender).Enabled := False;
  btnSaveEntry.Enabled := True;
  btnCancel.Enabled := True;
  btnCancelGd.Enabled := False;



  // ------------
  edtAccdate.Text := self.FOrigDateStr;
  edtAccdate.SelectAll;

  // 12.12.2010 Ingmar
  self.displayAllowedDocs(False);
  //estbk_utilities.changeWCtrlEnabledStatus(ovrAllGrpbox as TWinControl, True);
  // ------------
  if self.FOrigDateStr = '' then
    self.FOrigDateStr := datetostr(now);

  edtAccdate.Text := self.FOrigDateStr;
  edtAccdate.SelectAll;
  cmbDocumentType.ItemIndex := self.FOrigDocTypeIndx;



  if edtAccdate.CanFocus then
    edtAccdate.SetFocus;
  // !!!!
  accountingGridEditingDone(nil);

  //  todo picklist osa !
  //  estbk_utilities.miscResetCurrenyValList(cmbCurrency);

end;

procedure TframeGeneralLedger.writeIntoCSVFile(const pFilename: AStr);

  function _stripCSVm(const pStr: AStr): AStr;
  begin
    Result := stringreplace(pStr, ';', '', [rfReplaceAll]);
  end;

const
  CHdrCsvCnt = 5;
var
  pHdrLine: AStr;
  pSemcCnt: integer;
  pBuildLine: AStr;
  pCommonLines: AStr;
  i, j: integer;
  pMaxColCnt: integer;
  pNonEmptyItems: byte;
  pCSVFile: TextFile;
begin
  try
    // @@CHdrCsvCnt
    pCommonLines := '';
    pHdrLine := _stripCSVm(edtAccnr.Text) + ';' + _stripCSVm(edtAccdate.Text) + ';' + _stripCSVm(cmbDocumentType.Text) +
      ';' + _stripCSVm(edtDocNr.Text) + ';' + _stripCSVm(edtTransDescr.Text);
    pMaxColCnt := CHdrCsvCnt;

    assignfile(pCSVFile, pFilename);
    rewrite(pCSVFile);

    for i := 0 to accountingGrid.RowCount - 1 do
    begin
      pBuildLine := '';
      pNonEmptyItems := 0;
      // --
      for j := 1 to accountingGrid.ColCount - 1 do
      begin
        if i > pMaxColCnt then
          pMaxColCnt := j;

        if pBuildLine <> '' then
          pBuildLine := pBuildLine + ';';
        pBuildLine := pBuildLine + utf8toansi(_stripCSVm(accountingGrid.Cells[j, i]));
        // asi selles, et muidu exceli ei näe me täpitähti ja enamasti kasutatakse excelit
        if trim(accountingGrid.Cells[j, i]) <> '' then
          Inc(pNonEmptyItems); // ***
      end;

      if pNonEmptyItems < 1 then
        pBuildLine := ''
      else
        pCommonLines := pCommonLines + pBuildLine + CRLF;
    end;

    pHdrLine := pHdrLine + stringofchar(';', pMaxColCnt - CHdrCsvCnt);
    pCommonLines := pHdrLine + CRLF + pCommonLines;
    Write(pCSVFile, pCommonLines);
    closefile(pCSVFile);

    // @@@
    ShowMessage(estbk_strmsg.SCommSaved);
  except
    on e: Exception do
    begin
      Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
    end;
  end;
end;

procedure TframeGeneralLedger.initMemoryTable;
begin
  // @@
  qsMemDataSetForRep.Clear;
  with qsMemDataSetForRep do
  begin
    Active := False;
    FieldDefs.Clear;
    // ---
    FieldDefs.Add('accountcode', ftString, 35);
    FieldDefs.Add('rectype', ftString, 1);

    // artikli andmed
    FieldDefs.Add('linedescr', ftString, 512);
    FieldDefs.Add('currency', ftString, 3);
    FieldDefs.Add('debitsum', ftFloat, 0);
    FieldDefs.Add('creditsum', ftFloat, 0);
    FieldDefs.Add('currencyval', ftFloat, 0); // kurss
    FieldDefs.Add('basesum', ftFloat, 0); // summa baasvaluutaas
    FieldDefs.Add('customername', ftString, 255);
    FieldDefs.Add('objects', ftString, 255);
  end;
end;

procedure TframeGeneralLedger.fillMemoryTable;
var
  pHasData: boolean;
  i, j: integer;
  pObjects: AStr;
begin
  qsMemDataSetForRep.Close;
  qsMemDataSetForRep.Active := True;
  // @@
  for i := 0 to accountingGrid.RowCount - 1 do
  begin

    // --
    for j := 1 to accountingGrid.ColCount - 1 do
    begin
      pHasData := trim(accountingGrid.Cells[j, i]) <> '';
      if pHasData then
        break;
    end;


    pObjects := '';
    // loeme andmed mällu
    if pHasData then
      with qsMemDataSetForRep do
      begin
        Append;
        FieldByName('accountcode').AsString := accountingGrid.Cells[CCol_Account, i];
        FieldByName('linedescr').AsString := accountingGrid.Cells[CCol_AccDescr, i];
        FieldByName('currency').AsString := accountingGrid.Cells[CCol_AccCurrency, i];
        FieldByName('debitsum').AsFloat := strtofloatdef(accountingGrid.Cells[CCol_AccDebit, i], 0.00);
        FieldByName('creditsum').AsFloat := strtofloatdef(accountingGrid.Cells[CCol_AccCredit, i], 0.00);
        // milline kandereatüüp siis ikkagit on !?
        if trim(accountingGrid.Cells[CCol_AccDebit, i]) <> '' then
          FieldByName('rectype').AsString := estbk_types.CAccRecTypeAsDebit
        else
          FieldByName('rectype').AsString := estbk_types.CAccRecTypeAsCredit;

        FieldByName('currencyval').AsFloat := strtofloatdef(accountingGrid.Cells[CCol_AccCurrencyRate, i], 0.00);
        FieldByName('basesum').AsFloat := strtofloatdef(accountingGrid.Cells[CCol_AccCurrencyRate, i], 0.00);
        FieldByName('customername').AsString := accountingGrid.Cells[CCol_Client, i];
        // @@@
        for j := CCol_Client + 1 to accountingGrid.ColCount - 1 do
        begin
          if trim(accountingGrid.Cells[j, i]) = '' then
            continue;
          if pObjects <> '' then
            pObjects := pObjects + '; ';
          pObjects := pObjects + accountingGrid.Cells[j, i];
        end;

        FieldByName('objects').AsString := pObjects;
        Post;

      end;

  end; // --
end;

procedure TframeGeneralLedger.generatePrintPreview;
var
  pRepDef: AStr;
begin
  // TODO
  try
    self.initMemoryTable;
    self.fillMemoryTable;
    //  CGenLedgerMFReportFilename  = 'report_genledger_mf.lrf';
    if qsMemDataSetForRep.RecordCount > 0 then
    begin
      pRepDef := IncludeTrailingBackslash(self.reportDefPath) + estbk_reportconst.CGenLedgerMFReportFilename;

      self.FDebitSumTotal := 0.00;
      self.FCreditSumTotal := 0.00;

      if not FileExists(pRepDef) then
        raise Exception.CreateFmt(estbk_strmsg.SEReportDataFileNotFound, [pRepDef]);

      repGenLedger.LoadFromFile(pRepDef);
      repGenLedger.ShowReport;
    end;
    // @@@
  finally
    qsMemDataSetForRep.Clear;
  end;
end;

procedure TframeGeneralLedger.btnOutputClick(Sender: TObject);
begin
  if mnuItemCsv.Checked then
  begin
    dlgAccFile.FileName := format(estbk_strmsg.SGenLedDefaultFilename, [edtAccnr.Text]);
    if dlgAccFile.Execute then
    begin
      writeIntoCSVFile(dlgAccFile.Files.Strings[0]);
    end;
  end
  else
  if mnuItemPrinter.Checked then
  begin
    self.generatePrintPreview();
  end;
end;


procedure TframeGeneralLedger.performCleanup;
var
  i, j: integer;

begin

  try
    self.FGridCleanup := True;


    if assigned(onReqTaskbarEvent) then
      onReqTaskbarEvent(self, '');

    // taastame ka õige Editori !
    // accountingGrid.Editor:=TStringCellEditor (accountingGrid.EditorByStyle(cbsAuto));
    edtAccnr.Text := '';

    // --- kiirendame sisestust, kui jätame meelde eelmised valikud !
    FOrigDateStr := edtAccdate.Text;


    if cmbDocumentType.Enabled then
      FOrigDocTypeIndx := cmbDocumentType.ItemIndex
    else
      FOrigDocTypeIndx := 0;

    // accountingGrid.Clean(); objektidega tekitab jama
    // kas tehingukirjeldus ka meelde jätta...hmmm
    edtAccdate.Text := '';
    edtDocNr.Text := '';
    cmbDocumentType.ItemIndex := -1;
    edtTransDescr.Text := '';



    for i := 1 to accountingGrid.RowCount - 1 do
      for j := 1 to accountingGrid.ColCount - 1 do
      begin

        accountingGrid.Cells[j, i] := '';
        // 01.10.2009 Ingmar; hoiame midagi spetsiifilist row kaupa ! vabastame
        if assigned(accountingGrid.Objects[j, i]) then
        begin
          accountingGrid.Objects[j, i].Free;
          accountingGrid.Objects[j, i] := nil;
        end;
        // ---
      end;




    accountingGrid.Row := 1;
    accountingGrid.Col := 1;


    self.FObjCombItemIndx := -1;
    self.FLastPickListCol := -1;
    self.FLastPickListRow := -1;



    stxtDPart.Text := '';
    stxtCPart.Text := '';

    // ----------
    // objektide lisaveerud minema...
    // ehk column objekt 1 peab säilima !
                                               {
    for i:=CCol_CompName+2 downto  accountingGrid.ColCount-1 do
           accountingGrid.Columns.Delete(i);
                                                }
    self.FOpenedEntryId := 0;
    self.FOpenedEntryBaseDocId := 0;
    self.FInsertMode := True; // vaikimisi sisestamise reziim

    self.FAccRowsChkStr := '';
    self.FAccHeaderChkStr := '';


    // et uuel avamisel ikka gridis ka kontode combo oleks !
    //self.FPaCurrColPos:=1;
    //self.FPaCurrRowPos:=1;

    self.FPaCurrColPos := -1;
    self.FPaCurrRowPos := -1;

    accountingGrid.Editor := self.FAccListCombo;

  finally
    //accountingGrid.Editor:=TStringCellEditor (accountingGrid.EditorByStyle(cbsAuto));
    self.FGridCleanup := False;
  end;
  // ----
end;


// muutuste tuvastamise chksum
function TframeGeneralLedger.calcChksumStrForAccRecord: AStr;
var
  i, j: integer;
begin
  for i := 1 to accountingGrid.RowCount - 1 do
    for j := 1 to accountingGrid.ColCount - 1 do
      if j <> CCol_AccMonConversion then
        if assigned(accountingGrid.Objects[j, i]) then
        begin
          if (accountingGrid.Objects[j, i] is TCellAccountType) and (TCellAccountType(accountingGrid.Objects[j, i]).AccountId > 0) then
            Result := Result + trimLdZeros(inttohex(TCellAccountType(accountingGrid.Objects[j, i]).AccountId, 11))
          else
          if (accountingGrid.Objects[j, i] is TCellObjectType) and (TCellObjectType(accountingGrid.Objects[j, i]).ObjectId > 0) then
            Result := Result + trimLdZeros(inttohex(TCellObjectType(accountingGrid.Objects[j, i]).ObjectId, 11))
          else
            Result := Result + trimLdZeros(inttohex(estbk_utilities.hashpjw(accountingGrid.Cells[j, i]), 11));
        end
        else
        if trim(accountingGrid.Cells[j, i]) <> '' then
          Result := Result + trimLdZeros(inttohex(estbk_utilities.hashpjw(accountingGrid.Cells[j, i]), 11));
end;

function TframeGeneralLedger.calcChksumStrForHdrRecord: AStr;
begin
  Result := IntToStr(cmbDocumentType.ItemIndex) + edtAccdate.Text + // kp
    trimLdZeros(inttohex(estbk_utilities.hashpjw(edtDocNr.Text), 11)) + trimLdZeros(inttohex(estbk_utilities.hashpjw(edtTransDescr.Text), 11));
end;



procedure TframeGeneralLedger.cancelAccRecords(const accRegID: integer); // kande aluskirje;
begin
  with qryAccData, SQL do
    try

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLCancelAccRecSQL);
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('accounting_register_id').AsInteger := accRegID;
      execSQL;

      // ---
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLCancelAccRecSQL2);
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('accounting_register_id').AsInteger := accRegID;
      execSQL;


    finally
      Close;
      Clear;
    end;
  // ----
end;


procedure TframeGeneralLedger.btnSaveEntryClick(Sender: TObject);
var
  FReqObjNames: AStr;
  i, j, FAccRegID: integer;
  FAccDocId: int64;
  FAccDcRecId: int64; // kirjendite ID'd
  FAccDCAttrRecId: int64;

  FAccountId: integer;
  FCAccount: AStr; // konto kood  + nimi; peame ka seda kontrollima
  FCurrAcc: AStr;
  FDebit: double;
  FCredit: double;
  FRCVal: double;
  FTempCalc: double;

  FSkipRec: boolean;
  FErrRow: boolean;
  FAccYearId: integer;

  FValidRecCnt: integer;
  FRowNr: integer;
  FEntryDate: TDatetime;
  FBalanced: boolean;
  FReqObjFound: boolean;
  FAddAccRecs: boolean;

  // http://wiki.freepascal.org/Generics; kahjuks lazarus töötab alles komp. versiooniga 2.2.4;
  // alates 2.3.1 on generic saadaval
  // FValidRows : TList<integer>;
  FValidRows: TList;
  Bfr: AStr;
  FCurr: AStr;
  FValIsNull: boolean;
  FTmpCalc: double;
  FCurrIndx: integer;
  // 12.10.2010 Ingmar
  FCheckAccSides: boolean;
  FAccType: AStr;
  FPaccDescr: AStr;
  FFtsClientData: TIntIDAndCTypes;
begin

  // algsaldode initsialiseerimisel peame vaatama, et summa oleks õigel pool !!!
  FCheckAccSides := self.isBalanceInitDocument;
  // Aktiva=deebetsald passiva=kreeditsaldo tulud=kreeditsaldo kulud=deebetsaldo


  try


    // vaatame, kas uuendame kannet või hoopis lisame kande !!!
    // FIsUpdateMode:=self.FInsertMode and (self.FOpenedEntryId>0);
    FValIsNull := True;
    FValidRows := TList.Create;

    // ----
    FAddAccRecs := True;
    FDebit := 0;
    FCredit := 0;
    FEntryDate := now + 1;


    // 02.09.2011 ingmar; krdi lazaruse kala, mõnikord jätab editingdone välja kutsumata, siis kanne pole tasakaalus !
    self.accountingGridEditingDone(accountingGrid);


    self.calcAccSumTotal(True);
    self.calcAccSumTotal(False);



    // parem karta...kui hiljem uuendada
    self.gridCurrDataRecheck;




    // -- kande sisestus
    if (length(trim(edtAccdate.Text)) < 1) or not estbk_utilities.validateMiscDateEntry(edtAccdate.Text, FEntryDate) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEAccEntryDateEmpy, mtError, [mbOK], 0);
      edtAccdate.SetFocus;
      Exit;
    end;

    // 24.10.2009 Ingmar; meelis arvas, et kande salvestamisel dokumendi nr asemel kirjutada kande number, kui see tühi
    if (length(trim(edtDocNr.Text)) < 1) then
    begin
      // cmbDocumentType.itemIndex:=-1; 02.08.2011 Ingmar; jama dokumendi tüüp peab jääma !
      edtDocNr.Text := format(estbk_strmsg.CSAccRepDocNrWithAccDesc, [edtAccnr.Text]);
    end;

    // 15.04.2012 Ingmar
    if not estbk_globvars.glob_accPeriontypeNumerators then
    begin
      if (StrToIntDef(edtAccnr.Text, -1) < 1) then
      begin
        Dialogs.messageDlg(estbk_strmsg.SEAccEntryNrEmpty, mtError, [mbOK], 0);
        edtAccnr.SetFocus;
        Exit;
      end;
      // --
    end
    else
    begin
      // --
      if trim(edtAccnr.Text) = '' then
      begin
        Dialogs.messageDlg(estbk_strmsg.SEAccEntryNrEmpty, mtError, [mbOK], 0);
        edtAccnr.SetFocus;
        Exit;
      end;
    end;

    if (FEntryDate < estbk_types.MinAllowedDate) or (FEntryDate > now) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
      edtAccdate.SetFocus;
      Exit;
    end;


    // ----------------
    FValidRecCnt := 0;

    // käime siis kanded läbi
    with accountingGrid do
    begin

      for i := 1 to RowCount - 1 do
      begin
        FSkipRec := True;
        // järsku tühi rida, jätame vahele, ootame järgmist !
        for j := 1 to ColCount - 1 do
          if trim(Cells[j, i]) <> '' then
          begin
            FSkipRec := False;
            break;
          end;

        if FSkipRec then
          continue;


        // konto nimi
        FCAccount := Cells[CCol_Account, i];
        // lihtkontroll;
        FErrRow := ((trim(Cells[CCol_AccDebit, i]) <> '') and (trim(Cells[CCol_AccCredit, i]) <> '')) or
          ((trim(FCAccount) = '') and ((trim(Cells[CCol_AccDebit, i]) <> '') or (trim(Cells[CCol_AccCredit, i]) <> ''))) or
          ((trim(FCAccount) <> '') and ((trim(Cells[CCol_AccDebit, i]) = '') and (trim(Cells[CCol_AccCredit, i]) = '')));


        // 26.08.2011 Ingmar; võtsin kontrolli ära, sest sellega olid vaid jamad !
        // kontrollime ikka summa ka üle...kas pole mingi valesti sisestatud formaat !
          {
          if not FErrRow then
            FErrRow := ((trim(Cells[CCol_AccDebit, i]) <> '') and
             (format(CCurrentMoneyFmt2,[_normZero(StrToFloatDef(setRFloatSep(Cells[CCol_AccDebit, i]), 0))]) <>  // FloatToStr 28.10.2009
              trim(setRFloatSep(Cells[CCol_AccDebit, i]))));


          if not FErrRow then
            FErrRow := ((trim(Cells[CCol_AccCredit, i]) <> '') and
              (format(CCurrentMoneyFmt2,[_normZero(StrToFloatDef(setRFloatSep(Cells[CCol_AccCredit, i]), 0))]) <> // FloatToStr    28.10.2009
               trim(setRFloatSep(Cells[CCol_AccCredit, i]))));
          }
        if FErrRow then
        begin
          Dialogs.messageDlg(format(estbk_strmsg.SEAccRecordIsInvalid, [i]), mtError, [mbOK], 0);
          Col := CCol_Account;
          Row := i;
          if CanFocus then
            SetFocus;
          Exit; // -->
        end;


        // kontrollime ikkagit üle, kas meil on reaalselt midagi ka valitud !!!
        if not assigned(Objects[CCol_Account, i]) or (TCellAccountType(Objects[CCol_Account, i]).AccountId < 1) then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEAccountNotChoosen, mtError, [mbOK], 0);
          Col := CCol_Account;
          Row := i;
          if CanFocus then
            SetFocus;
          Exit; // -->
        end;


        // 05.11.2009 Ingmar; peame vastavalt valuutale kasutama konverteeritud välja
        FCurr := trim(Cells[CCol_AccCurrency, i]);
        FRCVal := 0;
        if (trim(Cells[CCol_AccDebit, i]) <> '') then
        begin
          if (FCurr = '') or (FCurr = estbk_globvars.glob_baseCurrency) then
            FRCVal := _normZero(StrToFloatDef(setRFloatSep(trim(Cells[CCol_AccDebit, i])), 0))
          else
            FRCVal := _normZero(StrToFloatDef(setRFloatSep(trim(Cells[CCol_AccMonConversion, i])), 0)); // baasvaluutasse konverteeritud !
          FDebit := FDebit + FRCVal;
        end
        else
        if (trim(Cells[CCol_AccCredit, i]) <> '') then // meelis soovitas jätta raamatupidajale vabadus !!
        begin
          if (FCurr = '') or (FCurr = estbk_globvars.glob_baseCurrency) then
            FRCVal := _normZero(StrToFloatDef(setRFloatSep(trim(Cells[CCol_AccCredit, i])), 0))
          else
            FRCVal := _normZero(StrToFloatDef(setRFloatSep(trim(Cells[CCol_AccMonConversion, i])), 0));
          FCredit := FCredit + FRCVal;
          //FCredit:=FCredit-abs(StrToFloatDef(setRFloatSep(trim(Cells[CCol_AccCredit, i])),0)); // kreeditsumma alati negatiivne ?!?!
        end;




        // 12.11.2010 Ingmar
        if FCheckAccSides then
        begin
          FAccType := AnsiUpperCase(trim(TCellAccountType(Objects[CCol_Account, i]).AccountType));
          // // Aktiva=deebetsaldo & kulud=deebetsaldo; passiva=kreeditsaldo & tulud=kreeditsaldo
          if (((FAccType = estbk_types.CAccTypeAsActiva) or (FAccType = estbk_types.CAccTypeAsCost)) and (trim(Cells[CCol_AccCredit, i]) <> '')) or
            (((FAccType = estbk_types.CAccTypeAsPassiva) or (FAccType = estbk_types.CAccTypeAsProfit)) and
            (trim(Cells[CCol_AccDebit, i]) <> '')) then
          begin
            Dialogs.MessageDlg(estbk_strmsg.SEAccountInitBalanceIDef, mtError, [mbOK], 0);
            Row := i;
            if CanFocus then
              SetFocus;
            Exit; // --
          end;
        end;



        // -- lipp maha
        if FValIsNull and (FRCVal <> 0) then
          FValIsNull := False;

        // võib vabalt olla ka tühjasid ridasid, toetan nö loose sisestust;
        // meid huvitavad ainult täidetud read !
        FValidRows.Add(Pointer(cardinal(i))); // TODO: kes ütles, et pointer on pointer;
        // kui saama generics võimaluse teen ümber selle "hacki"

        // ----------
        Inc(FValidRecCnt);
      end;

      // 0 kandeid me ei luba !
      if FValIsNull then
      begin
        Dialogs.messageDlg(estbk_strmsg.SEAccRecodsHaveZVal, mtError, [mbOK], 0);
        SetFocus;
        Exit;
      end;

      // ----
      if FValidRecCnt < 1 then
      begin
        Dialogs.messageDlg(estbk_strmsg.SEAccRecordsMissing, mtError, [mbOK], 0);
        if CanFocus then
          SetFocus;
        Exit; // -->
      end;


      // ------------------------------------------------------------------------
      // --- nii KÕIGE TÄHTSAM raamatupidamise ABC --- TASAKAAL
      // ------------------------------------------------------------------------
      // 02.08.2011 Ingmar; viga -0.00 ei ole korrektne

      if not Math.IsZero(_normZero(FDebit - FCredit), 0.0001) then
      begin
        Dialogs.messageDlg(estbk_strmsg.SEAccEntryUnBalanced, mtError, [mbOK], 0);
        if CanFocus then
          SetFocus;
        Exit; // -->
      end;


      // KÄIME KONTOD läbi ning kontrollime, kas valitud objekt eksisteerib
      for i := 1 to RowCount - 1 do
      begin
        FCAccount := trim(Cells[CCol_Account, i]);
        if FCAccount <> '' then;
      end;



      // kas peame objekti nimistu uuesti laadima
      with qryAccData, SQL do
      begin
        Close;
        Clear;
        add(estbk_sqlclientcollection._CSQLGetMaxAccMarkedObjectID);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;



        // järelikult peame uuesti laadima andmed !
        if self.FAccObjCheck <> estbk_utilities.chgChkSum(FieldByName('maxobjid').AsInteger, FieldByName('objcnt').AsInteger) then
        begin
          self.FAccObjCheck := estbk_utilities.chgChkSum(FieldByName('maxobjid').AsInteger, FieldByName('objcnt').AsInteger);
          // zeose refresh ei ole sama !
          qryAccReqObjects.active := False;
          qryAccReqObjects.active := True;
        end;

        // ----
        Close;
        Clear;
      end;


      // ----- käime need korrektsed read läbi !
      for i := 0 to FValidRows.Count - 1 do
      begin
        FRowNr := PtrInt(FValidRows.items[i]);
        FFtsClientData := nil;

        with qryAccReqObjects, SQL do
        begin
          assert(assigned(self.accountingGrid.Objects[CCol_Account, FRowNr]), 'SaveEntry[1]');
          FAccountId := TCellAccountType(self.accountingGrid.Objects[CCol_Account, FRowNr]).AccountId;



          Filtered := False;
          First;

          // kontrollime, kas üldse on kontoga seotud objekte !! jah, siis filter peale ja kontrollime
          if Locate('account_id', FAccountId, []) then
            try

              // hetkel nõuame, et kõik kontoga seotud objektid oleks olemas !!!!
              qryAccReqObjects.Filter := format('account_id=%d', [FAccountId]);
              Filtered := True;
              First;

              while not EOF do
              begin
                FReqObjFound := False;

                // ---
                for j := CCol_Client + 1 to accountingGrid.colCount - 1 do // viimane lahter on col + 1 lahter !!!
                  if (trim(self.accountingGrid.Cells[j, FRowNr]) <> '') and assigned(self.accountingGrid.Objects[j, FRowNr]) then
                  begin
                    FReqObjFound := (TCellObjectType(self.accountingGrid.Objects[j, FRowNr]).ObjectId = FieldByName('object_id').AsInteger);
                    if FReqObjFound then
                      break;
                    // ---
                  end;

                if not FReqObjFound then
                  break
                else
                  Next;
              end;

              // kohustuslikku objekti ei leitud, loome nimistu, mis objektid peaks olema
              if not FReqObjFound then
              begin
                First;
                FReqObjNames := '';
                while not EOF do
                begin
                  FReqObjNames := FReqObjNames + trim(FieldByName('objgrpname').AsString) + ' - ' + trim(FieldByName('objname').AsString) + #13#10;
                  Next;
                end;
                // ---
                Dialogs.messageDlg(format(estbk_strmsg.SEAccReqObjectsMissing,
                  [self.accountingGrid.Cells[CCol_Account, FRowNr], FReqObjNames]), mtError, [mbOK], 0);

                self.accountingGrid.Col := CCol_Client + 1;
                self.accountingGrid.Row := FRowNr;

                if CanFocus then
                  SetFocus;
                exit;
              end;
              // ---
            finally
              Filtered := False;
              qryAccReqObjects.Filter := '';
            end;
          // ---
        end;
      end;




      // ########################################################################
      // KONTROLLID !
      // ########################################################################


      with qryAccData, SQL do
      begin

        // ainult uue kande puhul kontrollime, uuendamisel kande NR EI MUUTU !
        if self.FInsertMode and not estbk_globvars.glob_accPeriontypeNumerators then
          // 23.02.2014 Ingmar; lisasin, et mitte rp. per kanded oleksid alati unikaalsed
        begin

          // sama numbriga kanne juba olemas !!!!
          // Toomas Pertel ütles, et annab vea !
          Close;
          Clear;
          add(estbk_sqlclientcollection._CSQLVerifyEntryNr);
          paramByName('entrynumber').AsString := edtAccnr.Text;
          paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;
          Open;

          if not EOF then
          begin
            Dialogs.messageDlg(format(estbk_strmsg.SEAccEntryWSNrExists, [edtAccnr.Text, datetostr(
              FieldByName('transdate').AsDateTime)]), // ärme lase vahekihil teha transformi !
              mtError, [mbOK], 0);

            Close;
            Clear;

            // ----
            edtAccnr.SetFocus;
            Exit;
          end;
        end;

        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // --- kas raamatupidamisaasta eksisteerib
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLCheckAccperiod);
        //        paramByName('accdate').asDateTime:=estbk_utilities(datetoOdbcStr.FEntryDate;
        // 05.11.2009 Ingmar; selectis parameeter asdatetime ei anna päringut, kuna sekundite osa lisatakse
        paramByName('accdate').AsString := estbk_utilities.datetoOdbcStr(FEntryDate);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;

        Open;
        if EOF then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEAccDtPeriodNotFound, mtError, [mbOK], 0);
          // ----
          edtAccdate.SetFocus;
          Exit;
        end;



        // C - closed
        if pos('C', AnsiUpperCase(FieldByName('status').AsString)) > 0 then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEAccDtPeriodClosed, mtError, [mbOK], 0);
          // ----
          if edtAccdate.CanFocus then
            edtAccdate.SetFocus;
          Exit;
        end;


        // jätame meelde raamatupidamisaasta
        FAccYearId := FieldByName('id').AsInteger;
      end;




      // ----------------------------------------------------------------------
      // oleme sisestusreziimil !!!!
      //FAccRegID:=-1;
      FAccRegID := self.FOpenedEntryId;

      try
        estbk_clientdatamodule.dmodule.primConnection.StartTransaction;

        FEntryDate := now;
        validateMiscDateEntry(edtAccdate.Text, FEntryDate);

        // Kas peaksin antud kirjed ka regenereerima, et oleks võimalus muudatusi kannetes tagantjärgi jälitada ?
        with qryAccData, SQL do
          case self.FInsertMode of
            True:
            begin
              Close;
              Clear;
              add(estbk_sqlclientcollection._CSQLInsertNewAccReg);

              //FAccRegID:=qryAccregisterSeq.GetNextValue;

              FAccRegID := estbk_clientdatamodule.dmodule.qryGenLedgerEntrysSeq.GetNextValue;
              parambyname('id').AsInteger := FAccRegID;



              // 04.01.2010 ingmar
              if self.isBalanceInitDocument() then
                paramByName('type_').AsString := estbk_types.CAccRecIdentAsInitBalance
              else
              // 28.08.2012 Ingmar
              if self.isAccPerClosingDocument() then
                paramByName('type_').AsString := estbk_types.CAddRecIdendAsClosingRec
              else
                paramByName('type_').AsString := estbk_types.CAccRecIdentAsGenLedger;

              // 28.12.2010 Ingmar
              parambyname('entrynumber').AsString := copy(edtAccnr.Text, 1, 20);
              parambyname('transdescr').AsString := edtTransDescr.Text;
              parambyname('transdate').asDate := FEntryDate;
              // 08.01.2010 Ingmar
              paramByName('accounting_period_id').AsInteger := FAccYearId; //estbk_globvars.glob_openacc_per_id;

              parambyname('rec_changed').AsDateTime := now;
              ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
              paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
              execSQL;
            end;

            // uuendame aluskirjet
            False:
            begin

              // 29.10.2009 ingmar
              // Annuleerime kõik antud kande kirjed ning loome uuesti ! sellega väldime igasugu ebameeldivaid vigu !!!
              // Parem uuesti salvestada, kui lihtalt muutma hakata !
              // Kas reaalselt ka midagi kande kirjetes muutus

              if self.calcChksumStrForAccRecord <> self.FAccRowsChkStr then
                self.cancelAccRecords(self.FOpenedEntryId);



              // ----
              // uuendame baaskirjet !
              Close;
              Clear;
              add(estbk_sqlclientcollection._CSQLUpdateAccReg);

              // 04.01.2010 ingmar
              if self.isBalanceInitDocument() then
                paramByName('type_').AsString := estbk_types.CAccRecIdentAsInitBalance
              else
              // 28.08.2012 Ingmar
              if self.isAccPerClosingDocument() then
                paramByName('type_').AsString := estbk_types.CAddRecIdendAsClosingRec
              else
                paramByName('type_').AsString := estbk_types.CAccRecIdentAsGenLedger;
              // 08.01.2010 Ingmar
              paramByName('accounting_period_id').AsInteger := FAccYearId; //estbk_globvars.glob_openacc_per_id;
              parambyname('transdescr').AsString := edtTransDescr.Text;
              parambyname('transdate').asDate := FEntryDate;
              parambyname('rec_changed').AsDateTime := now;
              paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByName('id').AsInteger := FAccRegID;
              execSQL;

            end;

          end; // ---

        with qryAccData, SQL do
          case self.FInsertMode of
            True:
            begin
              Close;
              Clear;
              add(estbk_sqlclientcollection._CSQLInsertNewDoc);

              //FAccDocId:=qryAccregisterDocSeq.GetNextValue;
              FAccDocId := estbk_clientdatamodule.dmodule.qryGetdocumentIdSeq.GetNextValue;

              // 05.12.2009 Ingmar
              parambyname('id').asLargeInt := FAccDocId;
              parambyname('document_nr').AsString := trim(edtDocNr.Text);
              parambyname('document_date').asDate := now; // milline kuupäev peaks siin olema, kas sama, mis kandel ?!?!


              if (cmbDocumentType.ItemIndex >= 0) and (cmbDocumentType.Text <> '') and
                (PtrInt(cmbDocumentType.Items.Objects[cmbDocumentType.ItemIndex]) <> _ac.sysDocumentId[_dsDocUndefined]) then
              begin
                // paha teisendus ! aga listis on ainult positiivse väärtusega elemendid !
                parambyname('document_type_id').AsInteger := PtrInt(cmbDocumentType.items.Objects[cmbDocumentType.ItemIndex]);
                parambyname('sdescr').AsString := '';
              end
              else
              begin
                parambyname('document_type_id').AsInteger := _ac.sysDocumentId[_dsDocUndefined]; // tüüp klassifikaatoritest
                parambyname('sdescr').AsString := cmbDocumentType.Text; // mingi täiendav lühikirjeldus
              end;

              // ------------
              paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
              // 01.12.2009 Ingmar; ebameeldiv viga, valet välja kasutasin !!
              paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;
              parambyname('rec_changed').AsDateTime := now;
              execSQL;
            end;


            // uuendame dokumenti
            False:
            begin
              Close;
              Clear;
              add(estbk_sqlclientcollection._CSQLUpdateDoc);

              parambyname('id').AsInteger := self.FOpenedEntryBaseDocId;
              parambyname('document_nr').AsString := trim(edtDocNr.Text);
              parambyname('document_date').asDate := now; // milline kuupäev peaks siin olema, kas sama, mis kandel ?!?!

              if (cmbDocumentType.ItemIndex >= 0) and (cmbDocumentType.Text <> '') and
                (PtrInt(cmbDocumentType.Items.Objects[cmbDocumentType.ItemIndex]) <> _ac.sysDocumentId[_dsDocUndefined]) then
              begin
                // paha teisendus ! aga listis on ainult positiivse väärtusega elemendid !
                parambyname('document_type_id').AsInteger := integer(cmbDocumentType.items.Objects[cmbDocumentType.ItemIndex]);
                parambyname('sdescr').AsString := '';
              end
              else
              begin
                parambyname('document_type_id').AsInteger := _ac.sysDocumentId[_dsDocUndefined];
                parambyname('sdescr').AsString := cmbDocumentType.Text; // mingi täiendav lühikirjeldus
              end;

              // ---
              parambyname('rec_changed').asDate := now;
              parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              // säilitame eelmise staatuse !
              parambyname('status').Value := null;
              execSQL;
            end;
          end;


        with qryAccData, SQL do
          case self.FInsertMode of
            True:
            begin
              Close;
              Clear;
              add(estbk_sqlclientcollection._CSQLInsertNewAccRegDoc);
              parambyname('accounting_register_id').AsInteger := FAccRegID;
              // 05.12.2009 Ingmar
              parambyname('document_id').AsLargeInt := FAccDocId;
              paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
              parambyname('rec_changed').AsDateTime := now;
              execSQL;
            end;

            // uuendame:
            False:
            begin
            end;
          end;



        // kas peame kanderead lisama !
        FAddAccRecs := self.FInsertMode or (self.calcChksumStrForAccRecord <> self.FAccRowsChkStr);

        // ----- käime need korrektsed read läbi !
        if FAddAccRecs then
          for i := 0 to FValidRows.Count - 1 do
          begin
            FRowNr := ptrint(FValidRows.items[i]);
            FFtsClientData := self.accountingGrid.Objects[CCol_Client, FRowNr] as TIntIDAndCTypes; // 21.03.2011 Ingmar

            with qryAccData, SQL do
            begin
              // !!!!!
              // kontrollida, kontrollida ja veelkord kontrollida !!!
              //assert(assigned(self.accountingGrid.Objects[CCol_Account,FRowNr]),'SaveEntry[1]');

              FAccDCRecId := int64(estbk_clientdatamodule.dmodule.qryGenLedgerAccRecId.GetNextValue);
              Close;
              Clear;
              //add(estbk_sqlclientcollection._CSQLInsertNewAccDCRec);'
              add(estbk_sqlclientcollection._CSQLInsertNewAccDCRecEx);

              // 05.12.2009 ingmar; kirjendite id muutsin bigint peale !
              paramByName('id').AsLargeInt := int64(FAccDCRecId);
              paramByName('accounting_register_id').AsInteger := FAccRegID;


              FAccountId := TCellAccountType(self.accountingGrid.Objects[CCol_Account, FRowNr]).AccountId;
              paramByName('account_id').AsInteger := FAccountId;



              FPaccDescr := self.accountingGrid.Cells[CCol_Account + 1, FRowNr];
              // paneme kontoreale veel lõppu kirjelduse algsaldo
              if self.isBalanceInitDocument() and (pos(ansilowercase(estbk_strmsg.SGenLedInitBalance), ansilowercase(FPaccDescr)) = 0) then
                FPaccDescr := FPaccDescr + ' / ' + estbk_strmsg.SGenLedInitBalance;

              paramByName('descr').AsString := Copy(FPaccDescr, 1, 255);
              paramByName('rec_nr').AsInteger := i + 1; // ridade num
              // --
              paramByName('currency_vsum').AsCurrency := 0;
              paramByName('currency_id').AsInteger := 0; // sisuliselt 0 viitab baasvaluutale !!!




              FCurrAcc := trim(self.accountingGrid.Cells[CCol_AccCurrency, FRowNr]); // !!!!
              // DEEBIT
              bfr := trim(self.accountingGrid.Cells[CCol_AccDebit, FRowNr]);
              if bfr <> '' then
              begin
                paramByName('rec_type').AsString := estbk_types.CAccRecTypeAsDebit;
                paramByName('currency_drate_ovr').asCurrency := 0; // hetkel ei toeta !
                FTmpCalc := strtofloat(bfr);

                // ---
                paramByName('currency_vsum').asCurrency := FTmpCalc; // originaal valuutasumma !

                // kui valuuta, siis peame võtma baasvaluuta teisenduse !!
                if (FCurrAcc <> estbk_globvars.glob_baseCurrency) then
                begin
                  // 03.03.2010 Ingmar; ├żra kasuta fieldi otse !!!
                  //paramByName('rec_sum').AsFloat:=strtofloat(trim(self.accountingGrid.Cells[CCol_AccMonConversion,FRowNr]));
                  FCurrIndx := self.FCurrDataList.indexOf(FCurrAcc);
                  FTmpCalc := roundto(FTmpCalc * TCurrencyObjType(self.FCurrDataList.Objects[FCurrIndx]).currVal, Z2);
                  // ---
                  paramByName('currency_id').AsInteger := TCurrencyObjType(self.FCurrDataList.Objects[FCurrIndx]).id;
                  paramByName('currency_drate_ovr').asCurrency := TCurrencyObjType(self.FCurrDataList.Objects[FCurrIndx]).currVal;
                end
                else
                  paramByName('currency_drate_ovr').asCurrency := 1.00;

                // ---
                paramByName('rec_sum').asCurrency := FTmpCalc;
              end;



              // KREEDIT
              bfr := trim(self.accountingGrid.Cells[CCol_AccCredit, FRowNr]);
              if bfr <> '' then
              begin
                paramByName('rec_type').AsString := estbk_types.CAccRecTypeAsCredit;
                paramByName('currency_drate_ovr').asCurrency := 0; // hetkel ei toeta !

                FTmpCalc := strtofloat(bfr);
                paramByName('currency_vsum').asCurrency := FTmpCalc; // originaal valuutasumma !



                // 01.03.2010 Ingmar; miks see summa peaks andmebaasis negatiivne olema BUGI
                // kui valuuta, siis peame võtma baasvaluuta teisenduse !!
                if (FCurrAcc <> estbk_globvars.glob_baseCurrency) then
                begin
                  FCurrIndx := self.FCurrDataList.indexOf(FCurrAcc);
                  FTmpCalc := roundto(FTmpCalc * TCurrencyObjType(self.FCurrDataList.Objects[FCurrIndx]).currVal, Z2);
                  // ---
                  paramByName('currency_id').AsInteger := TCurrencyObjType(self.FCurrDataList.Objects[FCurrIndx]).id;
                  paramByName('currency_drate_ovr').asCurrency := TCurrencyObjType(self.FCurrDataList.Objects[FCurrIndx]).currVal;
                end
                else
                  paramByName('currency_drate_ovr').asCurrency := 1.00;
                // ---
                paramByName('rec_sum').asCurrency := FTmpCalc;
                //paramByName('rec_sum').AsFloat:=-strtofloat(bfr);
              end;

              // ---
              paramByName('status').AsString := '';

              if FCurrAcc <> '' then
                paramByName('currency').AsString := FCurrAcc
              else
                paramByName('currency').AsString := estbk_utilities.getDefaultCurrency;
              // ----




              paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;
              parambyname('rec_changed').AsDateTime := now;
              paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;

              if assigned(FFtsClientData) then
              begin
                paramByName('tr_partner_name').AsString := '';
                paramByName('client_id').AsInteger := FFtsClientData.id;
              end
              else
              begin
                paramByName('tr_partner_name').AsString := self.accountingGrid.Cells[CCol_Client, FRowNr];
                paramByName('client_id').AsInteger := 0;
              end;

              paramByName('ref_item_type').AsString := '';
              paramByName('ref_item_id').AsInteger := 0;



              // konteeringu atribuudid !
              // informatiivsed lipud !
              paramByName('ref_prepayment_flag').AsString :=
                estbk_types.SCFalseTrue[(FAccountId = _ac.sysAccountId[_accPrepayment]) or
                (FAccountId = _ac.sysAccountId[_accSupplPrePayment])];
              paramByName('ref_debt_flag').AsString :=
                estbk_types.SCFalseTrue[(FAccountId = _ac.sysAccountId[_accBuyersUnpaidBills]) or
                (FAccountId = _ac.sysAccountId[_accSupplUnpaidBills])];



              // pangalaekumisi ei tohiks panna pearaamatu kaudu ! vähemalt hetkel mitte !
              paramByName('ref_payment_flag').AsString := estbk_types.SCFalseTrue[False];
              paramByName('ref_income_flag').AsString := estbk_types.SCFalseTrue[False];
              paramByName('ref_tax_flag').AsString := estbk_types.SCFalseTrue[False]; // pearaamatust ei saa me maksukontot määrata !!!
              paramByName('flags').AsInteger := 0;
              execSQL;
            end;


            // reaga seotud objektide loetelu ka salvestada...
            for j := CCol_Client + 1 to self.accountingGrid.ColCount - 1 do
              with qryAccData, SQL do
              begin
                // ---
                if trim(self.accountingGrid.Cells[j, FRowNr]) = '' then
                  continue;

                // !!!!!!!!!!!!!
                assert(assigned(self.accountingGrid.Objects[j, FRowNr]));



                // struktuur küll loodi, aga andmeid ei sisestatud !
                if TCellObjectType(self.accountingGrid.Objects[j, FRowNr]).ObjectId = 0 then
                  continue;

                FAccDCAttrRecId := qryAccreEntryObjSeq.GetNextValue;
                Close;
                Clear;
                add(estbk_sqlclientcollection._CSQLInsertNewAccDCRecAttrb);
                parambyname('id').AsInteger := FAccDCAttrRecId;
                // 05.12.2009 Ingmar; large peal
                parambyname('accounting_record_id').asLargeInt := FAccDcRecId;
                parambyname('attrib_type').AsString := CAttrecordObjType;
                parambyname('attrib_id').AsInteger := TCellObjectType(self.accountingGrid.Objects[j, FRowNr]).ObjectId;
                parambyname('attrib_val').AsInteger := 0;
                parambyname('rec_changed').AsDateTime := now;
                paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
                paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
                execSQL;
              end;

            // _CSQLInsertNewAccDCRecAttrb
          end;




        // -------
        estbk_clientdatamodule.dmodule.primConnection.Commit;

        self.FAccRowsChkStr := self.calcChksumStrForAccRecord;
        self.FAccHeaderChkStr := self.calcChksumStrForHdrRecord;



        // jätame meelde siiski salvestatud kirje ID ntx kui vaja kohe annuleerida ?!?!
        self.FOpenedEntryId := FAccRegID;


        self.FLastDSideSum := 0;
        self.FLastCSideSum := 0;

        // 02.08.2011 Ingmar
        dmodule.markNumeratorValAsUsed(PtrUInt(self), estbk_types.CAccGen_rec_nr, edtAccnr.Text, edtAccdate.Date, True);

      except
        on e: Exception do
        begin
          if estbk_clientdatamodule.dmodule.primConnection.inTransaction then
            try
              estbk_clientdatamodule.dmodule.primConnection.Rollback;
            except
            end;

          Dialogs.MessageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
          accountingGrid.SetFocus;
          Exit; // -->
        end; // ----
      end;



      if assigned(FFrameDataEvent) then
        FFrameDataEvent(Self, __frameGenLedEntryChanged, FAccRegID);


      // nuppude staatused paika !
      // taastame algseisu !
      // self.performCleanup;

      self.btnNewEntry.Enabled := True;
      self.btnCopy.Enabled := True;

      self.btnNewEntry.SetFocus;
      TBitBtn(Sender).Enabled := False;
      btnCancelGd.Enabled := True;
      btnCancel.Enabled := False;



      // RELOAD !!!
      // andmete korrektsuse tõttu tuleks salvestatud andmed uuesti laadida; võimaldab ka jälgida, kas programm töötab korrektselt
      self.openEntry(self.FOpenedEntryId);
    end;
    // ---
  finally
    FreeAndNil(FValidRows);
  end;
end;

procedure TframeGeneralLedger.cmbDocumentTypeChange(Sender: TObject);
begin
  self.detectChangesAndEnableSaveBtn;
end;

procedure TframeGeneralLedger.edtAccdateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
begin
  AcceptDate := True;
end;


procedure TframeGeneralLedger.gridCurrDataRecheck;
var
  i: integer;
  pindex: integer;
  pCurr: AStr;
  pSaveCol: integer;
  pSaveRow: integer;

begin
  // ---
  if (accountingGrid.Col = CCol_AccCurrency) and (accountingGrid.Editor is TPicklistCellEditor) then
    with TPicklistCellEditor(accountingGrid.Editor) do
    begin
      pindex := self.FCurrDataList.IndexOf(accountingGrid.Cells[CCol_AccCurrency, self.accountingGrid.Row]);
      if pindex >= 0 then
        Hint := format(CCurrentAmFmt4, [TCurrencyObjType(FCurrDataList.Objects[pindex]).currVal])
      else
        Hint := '';
    end;



  // peame ka olema valmis olukorraks, kus valuutakursid paika pandud, aga muudetakse kande kuupäeva !!!!!!
  for i := 1 to accountingGrid.RowCount - 1 do
  begin
    pCurr := trim(accountingGrid.Cells[CCol_AccCurrency, i]);


    // kui leiame mingi baasvaluutast erineva valuuta peame selle sisu kontrollima !
    if (pCurr <> '') and (pCurr <> estbk_globvars.glob_baseCurrency) then
      try
        pSaveCol := accountingGrid.Col;
        pSaveRow := accountingGrid.Row;




        // toome sipelgapesse elu... handlerid avastavad, et midagi toimus
        accountingGrid.Col := CCol_AccCurrency;
        accountingGrid.Row := i;

        accountingGrid.Cells[CCol_AccCurrency, i] := '';
        accountingGrid.Cells[CCol_AccCurrency, i] := pCurr;



        // kutsume välja olemasoleva handleri, mis kursid kenasti ära uuendab...
        accountingGridPickListSelect(accountingGrid);
        break;

      finally
        accountingGrid.Col := pSaveCol;
        accountingGrid.Row := pSaveRow;
      end;

    // ---
  end;
end;



procedure TframeGeneralLedger.lazFocusFixTimer(Sender: TObject);
begin
  // ---
  TTimer(Sender).Enabled := False;
  if FPaCurrColPos = CCol_Account then
  begin
    if self.FAccListCombo.CanFocus then
      self.FAccListCombo.SetFocus;
  end
  else
  if (FPaCurrColPos >= CCol_Client) and (FPaCurrColPos < accountingGrid.ColCount - 1) then
  begin
    if accountingGrid.CanFocus then
      accountingGrid.SetFocus;

    // ---
    if self.FAccObjGroups.Visible then
    begin
      self.FAccObjGroups.Enabled := True;
      if self.FAccObjGroups.CanFocus then
        self.FAccObjGroups.SetFocus;
    end;

    // ---
    if self.FAccObjTypes.Visible then
    begin
      self.FAccObjTypes.Enabled := True;
      if self.FAccObjTypes.CanFocus then
        self.FAccObjTypes.SetFocus;
    end;
  end
  else
  // 15.04.2011 Ingmar
  if accountingGrid.CanFocus then
  begin
    accountingGrid.SetFocus;
    if assigned(accountingGrid.Editor) and (accountingGrid.Editor.CanFocus) then
      accountingGrid.Editor.SetFocus;
  end;
end;

procedure TframeGeneralLedger.MenuItem1Click(Sender: TObject);
begin
  Clipboard.AsText := Self.accountingGrid.Cells[self.accountingGrid.Col, self.accountingGrid.Row];
end;

procedure TframeGeneralLedger.mnuItemCsvClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to popupChooseOutput.Items.Count - 1 do
    TMenuItem(popupChooseOutput.Items.Items[i]).Checked := False;
  TMenuItem(Sender).Checked := True;
end;



procedure TframeGeneralLedger.lazObjchangeTimerTimer(Sender: TObject);
begin
  // --
  try

    if self.accountingGrid.CanFocus then
      self.accountingGrid.SetFocus;

    self.FAccObjTypes.Visible := True;
    if self.FAccObjTypes.CanFocus then
      self.FAccObjTypes.SetFocus;

    accountingGrid.editor := self.FAccObjTypes;
    if not self.FAccObjTypes.PopupVisible then
      self.FAccObjTypes.PopupVisible := True;

  finally
    TTimer(Sender).Enabled := False;
  end;
end;

procedure TframeGeneralLedger.edtAccdateChange(Sender: TObject);
begin
  if not TDateEdit(Sender).Focused and TDateEdit(Sender).Enabled then
  begin
    self.gridCurrDataRecheck;
    // SelectNext(Sender as twincontrol, True, True);

    // 23.11.2010 Ingmar
    self.detectChangesAndEnableSaveBtn;
  end;
end;


procedure TframeGeneralLedger.edtAccdateExit(Sender: TObject);
var
  cval: TDatetime;
  pStr: AStr;
  i: integer;
  pCurr: AStr;
begin
  cval := now;
  pStr := trim(TEdit(Sender).Text);
  if pStr <> '' then
  begin
    if not estbk_utilities.validateMiscDateEntry(pStr, cval) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
      if TEdit(Sender).CanFocus then
        TEdit(Sender).SetFocus;
      Exit;
    end
    else
      TEdit(Sender).Text := datetostr(cval);

    // 07.03.2015 Ingmar; miks see koht siin (2012 kommentaar) ?!?!?!? Üldiselt, kui salvestatud kanne, siis kohe kindlasti seda ei luba !
    if self.FOpenedEntryId < 1 then
      // -- @@ 29.02.2012 Ingmar;
      edtAccnr.Text := dmodule.getUniqNumberFromNumerator(PtrUInt(self), edtAccnr.Text, cval, True, estbk_types.CAccGen_rec_nr, True, True);

    if accountingGrid.CanFocus then
    begin
      accountingGrid.Repaint;
      // peame ka olema valmis olukorraks, kus valuutakursid paika pandud, aga muudetakse kande kuupäeva !!!!!!
      self.gridCurrDataRecheck;
    end;

    // ----
  end;

  // ----------- uuendame kannet; detectime muudatusi
  if not self.FInsertMode then
    btnSaveEntry.Enabled := btnSaveEntry.Enabled or (self.calcChksumStrForHdrRecord <> self.FAccHeaderChkStr);

end;




procedure TframeGeneralLedger.edtAccdateKeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13] then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeGeneralLedger.edtAccnrExit(Sender: TObject);
begin
  // 15.04.2012 Ingmar meil pole mõtet kontrollida, kui custom kande numbrid tulevad
  if not estbk_globvars.glob_accPeriontypeNumerators then
    with TEdit(Sender) do
      // 08.10.2013 Ingmar; pole mõtet kontrollida kui readonly !!!
      if not ReadOnly then
        if (trim(Text) <> '') and (StrToIntDef(Text, -1) < 1) then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEIncorrectAccnumbering, mtError, [mbOK], 0);
          SetFocus;
        end;
end;

procedure TframeGeneralLedger.edtAccnrKeyPress(Sender: TObject; var Key: char);
begin

  if key in [#13] then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else
    estbk_utilities.edit_verifyNumericEntry(Sender as TCustomEdit, key, False);
end;

procedure TframeGeneralLedger.edtDocNrExit(Sender: TObject);
begin
  if not self.FInsertMode then
    btnSaveEntry.Enabled := btnSaveEntry.Enabled or (self.calcChksumStrForHdrRecord <> self.FAccHeaderChkStr);
end;




// kuvame ainult kontosid, mis pole suletud
procedure TframeGeneralLedger.qryAllAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  if self.FHideClosedAccounts then
    Accept := ((DataSet.FieldByName('flags').AsInteger and estbk_types.CAccFlagsClosed) <> CAccFlagsClosed)
  else
    Accept := True;
end;


procedure TframeGeneralLedger.repGenLedgerBeginBand(Band: TfrBand);
begin
  if Band.Typ = btMasterData then
    if trim(qsMemDataSetForRep.FieldByName('objects').AsString) = '' then
      Band.Height := 21
    else
      Band.Height := 45;
end;


procedure TframeGeneralLedger.repGenLedgerGetValue(const ParName: string; var ParValue: variant);
const
  CSCAccnr = 'scaccnr';
  CSCAccdate = 'scaccdate';
  CSCDocnr = 'scdocnr';
  CSCDocType = 'scdoctype';
  CSCDebitSum = 'scdebitsum';
  CSCCreditSum = 'sccreditsum';
  CSCCurrenyData = 'sccurrenydata';
  CSCObjectname = 'scobjectname';
  CSCDebitSumTotal = 'scdebitsumtotal';
  CSCCreditSumTotal = 'sccreditsumtotal';

  // pealkiri; strmsg faili viia !
  CSCCaptObj = 'sccaptobj';
var

  pname: AStr;
begin
  pname := ansilowercase(Parname);
  if pos('@', pname) = 0 then
    exit;

  pname := stringreplace(pname, '@', '', []);
  if pname = CSCAccnr then
    ParValue := trim(edtAccnr.Text)
  else
  if (pname = CSCAccdate) and (edtAccdate.Text <> '') then
    ParValue := datetostr(edtAccdate.Date)
  else
  if pname = CSCDocnr then
    ParValue := trim(edtDocNr.Text)
  else
  if pname = CSCDocType then
    ParValue := trim(cmbDocumentType.Text)
  else
  if (pname = CSCDebitSum) then
  begin
    if qsMemDataSetForRep.FieldByName('rectype').AsString = estbk_types.CAccRecTypeAsDebit then
    begin
      self.FDebitSumTotal := self.FDebitSumTotal + qsMemDataSetForRep.FieldByName('debitsum').AsFloat;
      ParValue := format(estbk_types.CCurrentMoneyFmt2, [qsMemDataSetForRep.FieldByName('debitsum').AsFloat]);
    end
    else
      ParValue := AStr('');
  end
  else
  if (pname = CSCCreditSum) then
  begin
    if qsMemDataSetForRep.FieldByName('rectype').AsString = estbk_types.CAccRecTypeAsCredit then
    begin
      self.FCreditSumTotal := self.FCreditSumTotal + qsMemDataSetForRep.FieldByName('creditsum').AsFloat;
      ParValue := format(estbk_types.CCurrentMoneyFmt2, [qsMemDataSetForRep.FieldByName('creditsum').AsFloat]);
    end
    else
      ParValue := AStr('');

  end
  else
  if (pname = CSCCurrenyData) then
  begin
    if qsMemDataSetForRep.FieldByName('currency').AsString <> estbk_globvars.glob_baseCurrency then
      // qsMemDataSetForRep.FieldByName('currencyval').AsFloat
      ParValue := qsMemDataSetForRep.FieldByName('currency').AsString + ' / ' + format(estbk_types.CCurrentMoneyFmt2,
        [qsMemDataSetForRep.FieldByName('basesum').AsFloat])
    else
      ParValue := '';
  end
  else
  if (pname = CSCCaptObj) then
  begin
    if trim(qsMemDataSetForRep.FieldByName('objects').AsString) <> '' then
      ParValue := 'Objekt:'
    else
      ParValue := '';
  end
  else
  if (pname = CSCObjectname) then
  begin
    ParValue := trim(qsMemDataSetForRep.FieldByName('objects').AsString);
  end
  else
  if (pname = CSCDebitSumTotal) then
  begin
    ParValue := format(estbk_types.CCurrentMoneyFmt2, [self.FDebitSumTotal]);
  end
  else
  if (pname = CSCCreditSumTotal) then
  begin
    ParValue := format(estbk_types.CCurrentMoneyFmt2, [self.FCreditSumTotal]);
  end;
end;


initialization
  {$I estbk_fra_generalledger.ctrs}

end.