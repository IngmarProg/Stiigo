unit estbk_fra_createmodaccounts;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

// TODO; kuna tegemist oli ühe esimese mooduliga, siis see maras sasipundard; TTreeview üle viia TVirtualTreeview peale !!!!
// http://wiki.freepascal.org/XML_Tutorial
// 09.09.2009 ingmar; hetkel ma tõesti ei luba algsaldot muuta enam peale sisestust ? Kas peaks lubama ?

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, Buttons, DBGrids,
  DBCtrls, ExtCtrls, Variants, estbk_fra_template, estbk_lib_commonevents, estbk_clientdatamodule,
  estbk_sqlclientcollection, estbk_types, estbk_uivisualinit, rxdbcomb,
  rxlookup, SMNetGradient, DB, ZDataset, ZSqlUpdate, ZSequence, Controls,
  ZAbstractRODataset, LCLType, Dialogs, Graphics, ComCtrls, ZAbstractDataset,
  Grids;

type
  // konto klass
  // konto rühm
  // konto grupp
  { TframeManageAccounts }

  TframeManageAccounts = class(Tfra_template)
    accountList: TGroupBox;
    acctabCtrl: TPageControl;
    Bevel1: TBevel;
    Bevel2: TBevel;
    bvl: TBevel;
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnNewAccount: TBitBtn;
    btnSave: TBitBtn;
    chkBoxAccStatus: TCheckBox;
    chkbxDispOnbill: TCheckBox;
    chkDefaultAccinIncForm: TCheckBox;
    chkDefaultAccinPmtForm: TCheckBox;
    cmbAccClassificator: TDBLookupComboBox;
    cmbBalanceDefaultGrp: TComboBox;
    cmbIncomeStatement: TComboBox;
    cmbLkTypes: TDBLookupComboBox;
    cmbSrcCriteria1: TComboBox;
    cmbCurrency: TDBComboBox;
    cmbSrcCriteriaObj: TComboBox;
    dbEdtAccountNr: TDBEdit;
    dbEdtAccountNr1: TDBEdit;
    edtSrcObjItem: TEdit;
    lbIncStatement: TLabel;
    lblDefaultForm: TLabel;
    lbAccnr: TLabel;
    lbAccnr1: TLabel;
    pPanelGrad: TNetGradient;
    qryBanksDS: TDatasource;
    dbEdtAccountCode: TDBEdit;
    dbEdtAccountName: TDBEdit;
    dbgridAccObjects: TDBGrid;
    lbBalance: TLabel;
    lbAccountCode: TLabel;
    lblBank: TLabel;
    lbAccountName: TLabel;
    lbAccountType: TLabel;
    lbAccountCurr: TLabel;
    lblAccountClassificator: TLabel;
    lblSearch1: TLabel;
    leftPanel: TPanel;
    qryAccountClassif: TZQuery;
    qryAccountClassifDs: TDatasource;
    qryBanks: TZQuery;
    rightPanel: TPanel;
    objsrcpanel: TPanel;
    pMainCtrlPanel: TPanel;
    qryAccObjectsds: TDatasource;
    dbBankLpCmb: TRxDBLookupCombo;
    spl: TSplitter;
    qryAccounts: TZQuery;
    qryAccountsds: TDatasource;
    qryAccounttypeds: TDatasource;
    qryAccountTypes: TZQuery;
    qryInsertUpdAccount: TZUpdateSQL;
    qrySeqnewAccount: TZSequence;
    qrySeqnewAccGrp: TZSequence;
    qryAccObjects: TZQuery;
    qryVData: TZQuery;
    qrySeqnewAccObjRec: TZSequence;
    tabAcc: TTabSheet;
    tabObj: TTabSheet;
    accTree: TTreeView;
    tabBank: TTabSheet;
    procedure accountDbGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure accountDbGridTitleClick(Column: TColumn);
    procedure accTreeChange(Sender: TObject; Node: TTreeNode);
    procedure accTreeChanging(Sender: TObject; Node: TTreeNode; var AllowChange: boolean);
    procedure accTreeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewAccountClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure chkBoxAccStatusChange(Sender: TObject);
    procedure chkbxDispOnbillChange(Sender: TObject);
    procedure chkDefaultAccinIncFormChange(Sender: TObject);
    procedure cmbBalanceDefaultGrpChange(Sender: TObject);
    procedure cmbBalanceDefaultGrpKeyPress(Sender: TObject; var Key: char);
    procedure cmbLkTypesChange(Sender: TObject);
    procedure dbBankLpCmbClosePopupNotif(Sender: TObject);
    procedure dbBankLpCmbKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbBankLpCmbSelect(Sender: TObject);
    procedure dbEdtInitBalanceKeyPress(Sender: TObject; var Key: char);
    procedure dbgridAccObjectsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbgridAccObjectsTitleClick(Column: TColumn);
    procedure edtSearchItemKeyPress(Sender: TObject; var Key: char);
    procedure edtSrcObjItemKeyPress(Sender: TObject; var Key: char);
    procedure edtSrcObjItemUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure qryAccObjectsBeforeEdit(DataSet: TDataSet);
    procedure qryAccObjectsBeforeInsert(DataSet: TDataSet);
    procedure qryAccObjectsUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; var pUpdateAction: TUpdateAction);
    procedure qryAccountsAfterEdit(DataSet: TDataSet);

    procedure qryAccountsAfterInsert(DataSet: TDataSet);
    procedure qryAccountsAfterPost(DataSet: TDataSet);
    procedure qryAccountsAfterScroll(DataSet: TDataSet);
    procedure qryAccountsBeforeEdit(DataSet: TDataSet);
    procedure qryAccountsBeforePost(DataSet: TDataSet);
    procedure qryAccountsBeforeScroll(DataSet: TDataSet);
    procedure qryAccountsEditError(DataSet: TDataSet; E: EDatabaseError; var DataAction: TDataAction);
  private
    FDataNotSaved: boolean;
    FSkipScrollEvent: boolean;
    FNewRecordCreated: boolean;
    FAccountCodeChangedDoReload: boolean;
    // kui tavaliselt kontoridade redigeerimisel me ei nõua kohest salvestamist,
    // siis objekti nimistu muutmisel küll !!!
    FReqSaveBeforeScroll: boolean;

    // et sorteerimisel suudaksime järjestust muuta
    FAccLastColUsedToSort: integer;
    FAccLastSortOrder: ZAbstractRODataset.TSortType; // miskil põhjusel ei suuda zeos seda õigesti kuvada wtf

    // sama teeme objektidega
    FObjLastColUsedToSort: integer;
    FObjLastSortOrder: ZAbstractRODataset.TSortType; // ikka sama probleem
    // -------
    FFrameKillSignal: TNotifyEvent;
    FFrameDataEvent: TFrameReqEvent;
    FParentKeyNotif: TKeyNotEvent;


    // ----
    procedure loadReportLinesIntoCombo(const pCombo: TCombobox; const pFormType: Astr);
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure srcAccTreeNode(const pAccCode: AStr; const node: TTreeNode; var retParentNode: TTreeNode);

    //procedure addNewAccountNode(const accCode : AStr;
    //                            const accName : AStr);
    procedure loadAccountTree(const pSelNodeCode: AStr = '');
    procedure parentKeyEvent(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure loadQryReqObj(const account_id: integer; const forceReload: boolean = False);
    function extractAccount(const pAccountStr: AStr): AStr;
  public
    procedure refreshObjectList();
    // 07.09.2009 ingmar; naljakas, kui frame creates panna andmeobjektile open, siis reaalselt seda ei tehta
    // justkui arvaks runtimes, et ikka design modes...jälle mingi bugi...oeh
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published // RTTI kala
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    // kuna frame ei võimalda keypreview'd, kasutame vanema võimalusi
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    // ---
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

uses estbk_utilities, estbk_settings, estbk_globvars, estbk_strmsg;

const
  CAccCodeNameSep = ' - ';

type
  TInternLoadAccountData = class
    FAccId: integer;
    FAccName: AStr;
  end;

// ---------------------------------------------------------------------------

procedure TframeManageAccounts.loadReportLinesIntoCombo(const pCombo: TCombobox; const pFormType: Astr);
begin
  pCombo.Clear;
  pCombo.AddItem(estbk_strmsg.SUndefComboChoise, TObject(0));
  with qryVData, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectFormLines(estbk_globvars.glob_company_id, pFormType));
      Open;

      First;
      // --
      while not EOF do
      begin
        pCombo.AddItem(FieldByName('line_descr').AsString, TObject(PtrInt(FieldByName('baserecord_id').AsInteger)));
        Next;
      end;

    finally
      Close;
      Clear;
    end;
end;

function TframeManageAccounts.getDataLoadStatus: boolean;
begin
  Result := qryAccountTypes.active;
end;


procedure TframeManageAccounts.setDataLoadStatus(const v: boolean);
var
  i, j: integer;
  pFieldIndx: integer;
begin
  // -------
  // lazarus all käitub Frame ikka õige imelikult, kaotab mõnikord connection property ära...brrr...
  with estbk_clientdatamodule.dmodule do
  begin
    qryAccountTypes.Connection := primConnection;
    qryAccountClassif.Connection := primConnection;

    qrySeqnewAccount.Connection := primConnection;
    qrySeqnewAccGrp.Connection := primConnection;


    //qryAccountGroup.Connection := primConnection;
    qryAccounts.Connection := primConnection;
    qryAccObjects.Connection := primConnection;
    qryVData.Connection := primConnection;
    qrySeqnewAccObjRec.Connection := primConnection;
    qryBanks.Connection := primConnection;

    qryAccountTypes.Close;
    qryAccountTypes.SQL.Clear;

    qryAccountClassif.Close;
    qryAccountClassif.SQL.Clear;

    qryAccounts.Close;
    qryAccounts.SQL.Clear;

    qryAccObjects.Close;
    qryAccObjects.SQL.Clear;

    qryBanks.Close;
    qryBanks.SQL.Clear;

    // --
    if v then
    begin
      self.acctabCtrl.ActivePage := self.tabAcc;

      //qryAccObjectsUpdInst.modifySQL.Clear;
      //tegelikkuses on meil ainult update ja insert...seda dummy vaja parameetrite jaoks !
      //qryAccObjectsUpdInst.modifySQL.Add(estbk_sqlclientcollection._CSQLDeleteAccReqObjects);
      qryAccountTypes.SQL.add(estbk_sqlclientcollection._CSQLAccountTypes);
      qryAccountClassif.SQL.add(estbk_sqlclientcollection._CSQLAccountClassfTypes);

      // --
      qryAccounts.SQL.add(estbk_sqlclientcollection._CSQLGetAllAccounts(False));

      // konto grupid; ntx varad, kulud, võlad jne        _CSQLUpdateAccount
      qryInsertUpdAccount.insertSQL.Clear;
      qryInsertUpdAccount.insertSQL.add(estbk_sqlclientcollection._CSQLInsertAccount);

      qryInsertUpdAccount.modifySQL.Clear;
      qryInsertUpdAccount.modifySQL.add(estbk_sqlclientcollection._CSQLUpdateAccount);

      // 05.03.2010 Ingmar
      qryBanks.SQL.add(estbk_sqlclientcollection._SQLSelectBanks);
      qryBanks.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      ;
      qryBanks.Open;


      qryAccObjects.Close;
      qryAccObjects.SQL.Clear;
      qryAccObjects.SQL.add(estbk_sqlclientcollection._CSQLGetAllAccReqObjects);

      // meid huvitavad vaid väljad...
      qryAccObjects.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      ;
      qryAccObjects.paramByname('account_id').AsInteger := 0;
      qryAccObjects.Open;

      cmbSrcCriteriaObj.Clear;




      // objekti otsingu combo ka paika !
      // täiendav -1 selletõttu, et seal gridis meil üks dummy column lazaruse bugi eemaldamiseks
      // checked välja me ei otsi ! seetõttu alates 1
      for i := 1 to dbgridAccObjects.columns.Count - 2 do
      begin
        pFieldIndx := qryAccObjects.FieldByName(TColumn(dbgridAccObjects.columns.Items[i]).FieldName).FieldNo;
        cmbSrcCriteriaObj.Items.addObject(dbgridAccObjects.columns.Items[i].Title.Caption, TObject(pFieldIndx));
      end;

      // ---
      cmbSrcCriteriaObj.ItemIndex := 1;

    end;
    // --  parameetrid paika
    qryAccounts.parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;

    // --
    qryAccounts.active := v;
    qryAccountTypes.active := v;
    qryAccountClassif.active := v;


    // dbcombo jaoks, kuna siin jooksvalt ei lisandu andmed
      {
      cmbSrcCriteria.Clear;
  for i := 0 to accountDbGrid.columns.Count - 1 do
      begin
        pFieldIndx := qryAccounts.FieldByName(TColumn(accountDbGrid.columns.Items[i]).FieldName).FieldNo;
        cmbSrcCriteria.Items.addObject(accountDbGrid.columns.Items[i].Title.Caption,TObject(pFieldIndx));
      end;

      // ---
      cmbSrcCriteria.ItemIndex := 2;
      }
    //      accountDbGrid.columns.Items[i].
    //estbk_utilities.changeWCtrlEnabledStatus(accountList, not qryAccounts.EOF);
    estbk_utilities.changeWCtrlEnabledStatus(acctabCtrl, not qryAccounts.EOF);
    acctabCtrl.Enabled := True;



    // bilansigrupp
    loadReportLinesIntoCombo(cmbBalanceDefaultGrp, estbk_types.CFormTypeAsBalance);

    // kasumiaruanne
    loadReportLinesIntoCombo(cmbIncomeStatement, estbk_types.CFormTypeAsIncStatement);



    // --- valuutad ka paika
    for i := 0 to dmodule.currencyList.Count - 1 do
      cmbCurrency.Items.Add(dmodule.currencyList.Strings[i]);
    cmbCurrency.ItemIndex := cmbCurrency.Items.IndexOf(estbk_globvars.glob_baseCurrency);




    // -- ütleme nii, et lazarus on veel toores...frame kaotab runtimes propertid ära...ikka juhtub
    // kontode tüübid !!!!
    cmbLkTypes.DataField := 'type_id'; //'classificator_id';
    cmbLkTypes.DataSource := self.qryAccountsds;

    cmbLkTypes.KeyField := 'id';
    cmbLkTypes.ListField := 'accname';
    cmbLkTypes.ListFieldIndex := -1;
    cmbLkTypes.ListSource := qryAccounttypeds;



    cmbAccClassificator.DataField := 'typecls_id'; //'classificator_id';
    cmbAccClassificator.DataSource := self.qryAccountsds;

    cmbAccClassificator.KeyField := 'id';
    cmbAccClassificator.ListField := 'accname';
    cmbAccClassificator.ListFieldIndex := -1;
    cmbAccClassificator.ListSource := qryAccountClassifDs;




    //cmbAccClassificator

    // ---

    //dbEdtInitBalance.color    := clBtnFace;
    //dbEdtInitBalance.ReadOnly := True;



    self.loadAccountTree;
    // et combos indeksid korda saada...
    qryAccountsAfterScroll(qryAccounts);
  end; // ---

end;


procedure TframeManageAccounts.dbEdtInitBalanceKeyPress(Sender: TObject; var Key: char);
begin
  estbk_utilities.edit_verifyNumericEntry(Sender as TDbEdit, key, True);
  if key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    key := #0;
  end;
end;

procedure TframeManageAccounts.dbgridAccObjectsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (byte(key) in [9, 13]) then
  begin
  {
    if accountDbGrid.Enabled then
       accountDbGrid.SetFocus
    else
    if btnClose.Enabled then
       btnClose.SetFocus;
}
    SelectNext(Sender as TWinControl, True, True);
    key := 0;
  end; // --
end;

// sama, mis kontode puhul, aga me ei saa neid kahjuks ühildada !
procedure TframeManageAccounts.dbgridAccObjectsTitleClick(Column: TColumn);
begin

  //     qryAccounts.SortedFields:='';
  qryAccObjects.SortedFields := Column.FieldName;

  if self.FObjLastColUsedToSort <> Column.Index then
  begin
    self.FObjLastSortOrder := stAscending;
    qryAccObjects.SortType := self.FObjLastSortOrder;
  end
  else
    case self.FObjLastSortOrder of   // zeos ei suuda säilitada õiget väärtus propertis SortType !
      stAscending,
      stIgnored:
      begin
        self.FObjLastSortOrder := stDescending;
        qryAccObjects.SortType := self.FObjLastSortOrder;
      end;

      stDescending:
      begin
        self.FObjLastSortOrder := stAscending;
        qryAccObjects.SortType := self.FObjLastSortOrder;
      end;
    end;
  // -----------------
  self.FObjLastColUsedToSort := Column.Index;
end;


procedure TframeManageAccounts.edtSearchItemKeyPress(Sender: TObject; var Key: char);
var
  prealDField: AStr;
  i: integer;
begin
  if key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    key := #0;
  end;
  {
  else
  if cmbSrcCriteria.ItemIndex >= 0 then
  begin
    // TColumn(accountDbGrid.columns.Items[i]).FieldName:=

    prealDField := qryAccounts.Fields.FieldByNumber(
      integer(cmbSrcCriteria.Items.Objects[cmbSrcCriteria.ItemIndex])).FieldName;
    estbk_utilities.edit_autoCompData(Sender as TCustomEdit,
      key,
      qryAccounts,
      prealDField);
    // -----
  end;}
end;

procedure TframeManageAccounts.edtSrcObjItemKeyPress(Sender: TObject; var Key: char);
var
  prealDField: AStr;
  i: integer;
begin
  if Key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    Key := #0;
  end
  else
  if cmbSrcCriteriaObj.ItemIndex >= 0 then
  begin
    prealDField := qryAccObjects.Fields.FieldByNumber(integer(cmbSrcCriteriaObj.Items.Objects[cmbSrcCriteriaObj.ItemIndex])).FieldName;
    estbk_utilities.edit_autoCompData(Sender as TCustomEdit,
      Key,
      qryAccObjects,
      prealDField);
    // -----
  end;
end;


procedure TframeManageAccounts.edtSrcObjItemUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
begin
  // ---
end;



procedure TframeManageAccounts.qryAccObjectsBeforeEdit(DataSet: TDataSet);
begin
  if not self.FSkipScrollEvent then
  begin
    self.FDataNotSaved := True;
    // objektide puhul nõuame salvestamist !!!
    btnSave.Enabled := True;
    btnCancel.Enabled := True;
    self.FReqSaveBeforeScroll := True;
  end;
  // --
end;

procedure TframeManageAccounts.qryAccObjectsBeforeInsert(DataSet: TDataSet);
begin
  abort;
end;


// 24.10.2009 Ingmar; mõneti hack, meil vaja kindlaks teha, millal reaalselt teha insert baasi ning millal update;
// saaksime SQL abil teha, aga kui tahame N backendi toetada, kes neid pidevalt ümber kirjutab
// 25.10.2009 Ingmar; krt selle peale annab ikka tulla :((( Et Zeoses osa evente, mis küll kirjeldatud,
// aga mitte kusagilt ei kutsuta välja

procedure TframeManageAccounts.qryAccObjectsUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; var pUpdateAction: TUpdateAction);
(*
var
 pkRec : Boolean;
 *)
begin
  (*
  with qryAccObjects.UpdateObject do
   case UpdateKind of
      ukModify: begin
                 // SetParams(UpdateKind);
                     pkRec:=Dataset.FieldByname('chkfield').AsBoolean;
                 if (Dataset.FieldByname('account_id').asInteger<1) then // järelikult hetkel polnud veel antud objekti omistatud
                   begin
                   if pkRec then
                      SQL[UpdateKind].Text:=estbk_sqlclientcollection._CSQLInsertAccReqObjects
                   else
                      pUpdateAction:=uaApplied;
                   end else
                  if  not pkRec then
                      SQL[UpdateKind].Text:=estbk_sqlclientcollection._CSQLDeleteAccReqObjects;
                      // ExecSQL(UpdateKind);
                 end;

      ukInsert,
      ukDelete: assert(false); // hetkel ei kasuta
   end;

 // ---
 // pUpdateAction := uaApplied;
 *)
end;

procedure TframeManageAccounts.qryAccountsAfterEdit(DataSet: TDataSet);
begin
  // --
end;



procedure TframeManageAccounts.qryAccountsAfterInsert(DataSet: TDataSet);
begin
  // 16.02.2010 Ingmar
  DataSet.FieldByName('default_currency').AsString := estbk_globvars.glob_baseCurrency;
  DataSet.FieldByName('init_balance').AsFloat := 0.00;
  DataSet.FieldByName('company_id').AsInteger := estbk_globvars.glob_company_id;

  // 20.02.2011 Ingmar
  DataSet.FieldByName('balance_rep_line_id').AsInteger := 0;
  DataSet.FieldByName('incstat_rep_line_id').AsInteger := 0;

end;

procedure TframeManageAccounts.qryAccountsAfterPost(DataSet: TDataSet);
begin
  // ***
end;

function findRParent(const pRoot: TTreeNode; const pNodeup: TTreeNode; const currValue: AStr): TTreeNode;
var
  pCurrNod: TTreeNode;
  pMarkerPos: integer;
  pNodeVal: AStr;
begin
  Result := pRoot;
  pCurrNod := pNodeup;

  while assigned(pCurrNod) do
  begin
    pNodeVal := ansilowercase(pCurrNod.Text);
    pMarkerPos := pos(CAccCodeNameSep, pNodeVal);
    if pMarkerPos > 0 then
      pNodeVal := copy(pNodeVal, 1, pMarkerPos - 1);


    if pos(pNodeVal, ansilowercase(currValue)) = 1 then
    begin
      Result := pCurrNod;
      break;
    end;

    pCurrNod := pCurrNod.GetPrev;
  end;
end;


procedure TframeManageAccounts.srcAccTreeNode(const pAccCode: AStr; const node: TTreeNode; var retParentNode: TTreeNode);
var
  i, pMarkerPos: integer;
  pNodeVal: AStr;
begin
  // --
  if assigned(retParentNode) then
    Exit;

  for i := 0 to node.Count - 1 do
  begin

    pNodeVal := node.Items[i].Text;
    pMarkerPos := pos(CAccCodeNameSep, pNodeVal);
    if pMarkerPos > 0 then
      pNodeVal := copy(pNodeVal, 1, pMarkerPos - 1);

    if ansilowercase(pNodeVal) = ansilowercase(pAccCode) then
    begin
      retParentNode := node.Items[i];
      Exit;
    end;
    // --
    srcAccTreeNode(pAccCode, node.Items[i], retParentNode);
  end;
end;

// seoses veakirjeldusega; 0000002: Kontoplaanis uue konto lisamine
// on tunduvalt kindlam kontod uuesti laadida !!!
// Sest ntx kontod tulid järjestuses; ehk 20310 tuli ennem kui 203100 !!!!!!!!!!!!!!!!!!!!!!!
//"203100" "Võlad tarnijatele EEK"
//"20310" "Võlad tarnijatele"
//"20110" "Lühiajalised laenud"
{
03.03.2010 Ingmar; koodile deprecate
procedure TframeManageAccounts.addNewAccountNode(const accCode : AStr;
                                                 const accName : AStr);

var
 pParentNCode : AStr;
 pFParent     : TTreeNode;
 pNewNode     : TTreeNode;
begin
     pParentNCode:=trim(copy(accCode,1,length(accCode)-1));

     pFParent:=nil;
 if  pParentNCode<>'' then
     self.srcAccTreeNode(pParentNCode,accTree.TopItem,pFParent);

 if  not assigned(pFParent) then
     pFParent:=accTree.TopItem;

     // ---
     pNewNode:=accTree.Items.AddChild(pFParent,accCode+CAccCodeNameSep+accName);
     pNewNode.Selected:=true;
end;
}
// 03.02.2010 ingmar;
procedure TframeManageAccounts.loadAccountTree(const pSelNodeCode: AStr = '');
var
  i, j: integer;
  pAccCode: AStr;
  pBufferedItems: TAStrList;
  // pTreeNode         : TTreeNode;
  // pCurrNode         : TTreeNode;
  pStartIndx, pTopPrefix, pEndIndx, pLastLen: integer;
  //pAccCode,ptest,p1,p2 : string;

  pRootNode: TTreeNode;
  pLastChild: TTreeNode;
  pPrevParent: TTreeNode;
  pFndNode: TTreeNode;

  pCurrLen: integer;
  pBuildNodes: boolean;
  // --
  pTempLoadData: TInternLoadAccountData;
begin
  accTree.Items.Clear;

  with qryAccounts do
    try
      accTree.Enabled := False;
      pBufferedItems := TAStrList.Create;

      self.FSkipScrollEvent := True;
      DisableControls;
      First;


      while not qryAccounts.EOF do
      begin
        pAccCode := FieldByName('account_coding').AsString;

        pTempLoadData := TInternLoadAccountData.Create;
        pTempLoadData.FAccId := FieldByName('id').AsInteger;
        pTempLoadData.FAccName := FieldByName('account_name').AsString;

        // ---
        pBufferedItems.addObject(FieldByName('account_coding').AsString, pTempLoadData);
        Next;
      end;


      // ----------------------------
      accTree.Items.Clear;


      pStartIndx := 0;
      pEndIndx := 0;
      pBufferedItems.sorted := True;

      pRootNode := accTree.Items.AddChild(nil, estbk_strmsg.SAccLongName);
      pPrevParent := pRootNode;
      pLastChild := pRootNode;

      pTopPrefix := 0;
      for i := 0 to pBufferedItems.Count - 1 do
      begin

        pBuildNodes := True;
        if pos(pBufferedItems.Strings[pTopPrefix], pBufferedItems.Strings[i]) = 1 then
        begin
          pEndIndx := i;
          pBuildNodes := (i = pBufferedItems.Count - 1);
        end
        else
        begin
          pTopPrefix := i;
          if i = pBufferedItems.Count - 1 then
          begin
            pEndIndx := i;
          end;
        end;



        if pBuildNodes then
        begin

          pPrevParent := pRootNode;
          pLastChild := pRootNode;
          pLastLen := 0;

          for j := pStartIndx to pEndIndx do
          begin

            pTempLoadData := TInternLoadAccountData(pBufferedItems.Objects[j]);
            pCurrLen := length(pBufferedItems.Strings[j]);
            if (pCurrLen > pLastLen) then
            begin
              pPrevParent := pLastChild;
              pLastChild := findRParent(accTree.TopItem, pLastChild, copy(pBufferedItems.Strings[j], 1, length(pBufferedItems.Strings[j])));
              // ---
              // 29.05.2011 Ingmar
              if not assigned(pLastChild) then
                pLastChild := pRootNode;
              pLastChild := accTree.Items.AddChild(pLastChild, pBufferedItems.Strings[j] + CAccCodeNameSep + pTempLoadData.FAccName);
            end
            else
            if pCurrLen = pLastLen then
            begin
              pLastChild := accTree.Items.AddChild(pPrevParent, pBufferedItems.Strings[j] + CAccCodeNameSep + pTempLoadData.FAccName);
            end
            else
            if pCurrLen < pLastLen then
            begin
              pPrevParent := findRParent(accTree.TopItem, pLastChild, copy(pBufferedItems.Strings[j], 1, length(pBufferedItems.Strings[j])));
              // 29.05.2011 Ingmar
              if not assigned(pPrevParent) then
                pPrevParent := pRootNode;

              pLastChild := accTree.Items.AddChild(pPrevParent, pBufferedItems.Strings[j] + CAccCodeNameSep + pTempLoadData.FAccName);
              pPrevParent := pLastChild;
            end;
            // ----
            pLastLen := pCurrLen;
          end;



          // ---
          pStartIndx := i;
          pEndIndx := pStartIndx;
        end;

      end; // loop
      // ---
      accTree.Enabled := True;
      //accTree.FullExpand;


      // 04.03.2010 Ingmar
      if pSelNodeCode <> '' then
      begin
        pFndNode := nil;
        self.srcAccTreeNode(pSelNodeCode, accTree.TopItem, pFndNode);
        if assigned(pFndNode) then
        begin
          pFndNode.Selected := True;
          accTree.Selected := pFndNode;
        end;
        //pFndNode.Selected:=true;

      end
      else
      if assigned(accTree.TopItem) and assigned(accTree.TopItem.GetFirstChild) then
        accTree.TopItem.GetFirstChild.Selected := True;
      // ---
    finally
      accTree.Enabled := True;
      qryAccounts.EnableControls;
      FreeAndNil(pBufferedItems);
      self.FSkipScrollEvent := False;
    end;
  // ---
end;

procedure TframeManageAccounts.loadQryReqObj(const account_id: integer; const forceReload: boolean = False);
begin
  // ------------
  // laeme objektid; samas väldime mõttetut uuesti laadimist
  if (account_id <> qryAccObjects.ParamByname('account_id').AsInteger) or forceReload then
    try
      self.FSkipScrollEvent := True;
      qryAccObjects.DisableControls;

      cmbSrcCriteriaObj.ItemIndex := 2;
      edtSrcObjItem.Text := '';




      //qryAccObjects.Close;
      //qryAccObjects.SQL.Clear;
      //qryAccObjects.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccReqObjects);
      qryAccObjects.paramByname('account_id').AsInteger := account_id;
      qryAccObjects.active := False;
      qryAccObjects.active := True;

      //qryAccObjects.paramByname('company_id').AsInteger :=estbk_globvars.glob_company_id;
      //qryAccObjects.Open;

      // tobe, aga pole midagi teha, me niigi baasist tagastame fiktiivse andmevälja;
      // ntx kui teha cast(0 as boolean) siis muutuvad väljad RO'ks; kui veel määramata staatus !
      // PEAN väljadel määramatuse ära kaotama kirje haaval...väga tobe :(
      // addfields pole ka hea idee, siis peame kõik uuesti kirjeldama

      qryAccObjects.First;

      // palju toredaid lazaruse bugisid, mingist hetkest enam ei ole gridi väli RO
      //dbgridAccObjects.Columns.Items[1].ReadOnly:=true;
      //dbgridAccObjects.Columns.Items[2].ReadOnly:=true;

      // aitas FIX; tegin ühe tühja RO välju lõppu juurde, mis peidetud !


      // TOBE TOBE TOBE; peaks proovima autocalcfields trikki
      while not qryAccObjects.EOF do
      begin

        if qryAccObjects.FieldByName('chkfield').isNull or (qryAccObjects.FieldByName('account_id').AsInteger > 0) then
          try
            qryAccObjects.Edit;
            qryAccObjects.FieldByName('chkfield').AsBoolean := qryAccObjects.FieldByName('account_id').AsInteger > 0;
          finally
            qryAccObjects.Post;
          end;
        // --
        qryAccObjects.Next;
      end;

      qryAccObjects.First;

      // --

    finally
      self.FSkipScrollEvent := False;
      self.qryAccObjects.EnableControls;
    end;
end;

procedure TframeManageAccounts.qryAccountsAfterScroll(DataSet: TDataSet);
var
  i: integer;
begin
  btnNewAccount.Enabled := not self.FNewRecordCreated;
  if self.FNewRecordCreated then
  begin
    chkBoxAccStatus.Checked := False;
    chkBoxAccStatus.Enabled := False;
  end;

  // --
  if not self.FSkipScrollEvent and (DataSet.RecordCount > 0) then
    try
      self.FSkipScrollEvent := True;
      // --
      cmbBalanceDefaultGrp.ItemIndex := estbk_utilities._comboboxIndexByIdVal(cmbBalanceDefaultGrp, DataSet.FieldByName(
        'balance_rep_line_id').AsInteger);
      cmbIncomeStatement.ItemIndex := estbk_utilities._comboboxIndexByIdVal(cmbIncomeStatement,
        DataSet.FieldByName('incstat_rep_line_id').AsInteger);

      chkBoxAccStatus.Checked := (DataSet.FieldByName('flags').AsInteger and estbk_types.CAccFlagsClosed) = estbk_types.CAccFlagsClosed;
      chkBoxAccStatus.Enabled := not self.FNewRecordCreated;

      chkbxDispOnbill.Checked := copy(AnsiUpperCase(qryAccounts.FieldByName('display_onbill').AsString), 1, 1) =
        AnsiUpperCase(estbk_types.SCFalseTrue[True]);
      // suletud kontol ei luba me objekte muuta !!! peab uuesti avama nö
      dbgridAccObjects.Columns.Items[0].ReadOnly := chkBoxAccStatus.Checked;

    finally
      self.FSkipScrollEvent := False;
    end
  else
    Exit;


  // laeme objektide nimekirja !
  //self.loadQryReqObj(DataSet.FieldByName('id').asInteger,(DataSet.state=dsInsert));
  self.loadQryReqObj(DataSet.FieldByName('id').AsInteger, self.FNewRecordCreated);
end;

procedure TframeManageAccounts.qryAccountsBeforeEdit(DataSet: TDataSet);
begin
  self.FDataNotSaved := True;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
end;

procedure TframeManageAccounts.qryAccountsBeforePost(DataSet: TDataSet);
var
  b: boolean;
begin
  if self.FNewRecordCreated then
  begin
    dataset.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
  end
  else
    // 21.02.2011 Ingmar; peame koodi ära muutma
  begin
    b := (vartostr(Dataset.FieldByName('account_coding').Value) <> vartostr(Dataset.FieldByName('account_coding').OldValue));
    self.FAccountCodeChangedDoReload := self.FAccountCodeChangedDoReload or b;

    // peame puus ka koodi ära muutma !
    if b and assigned(accTree.Selected) then
      accTree.Selected.Text := vartostr(Dataset.FieldByName('account_coding').Value);
  end;



  dataset.FieldByName('rec_changed').AsDateTime := now;
  dataset.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  dataset.FieldByName('parent_id').AsInteger := 0;
  if chkBoxAccStatus.Checked then
    dataset.FieldByName('flags').AsInteger := (dataset.FieldByName('flags').AsInteger or estbk_types.CAccFlagsClosed)
  else
    // xor ka hea
    dataset.FieldByName('flags').AsInteger := (dataset.FieldByName('flags').AsInteger and not estbk_types.CAccFlagsClosed);
end;

procedure TframeManageAccounts.qryAccountsBeforeScroll(DataSet: TDataSet);
var
  pAccDef: AStr;
begin

  if self.FDataNotSaved and not self.FSkipScrollEvent then
  begin

    // igaksjuhuks kontrollime baasist nime...ei piisa ainult meie dataseti kontrollist
    qryVData.Close;
    qryVData.SQL.Clear;
    qryVData.SQL.Add(estbk_sqlclientcollection._CSQLVerifyAccountName);
    qryVData.ParamByname('account_name').AsString := DataSet.FieldByName('account_name').AsString; // trim(cmbAccountClasses.text);
    qryVData.ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;

    if self.FNewRecordCreated then
    begin
      qryVData.ParamByName('id').AsInteger := 0;
      qryVData.ParamByName('id').Value := null;
    end
    else
      qryVData.ParamByName('id').AsInteger := DataSet.FieldByName('id').AsInteger;

    qryVData.ParamByname('account_coding').AsString := DataSet.FieldByName('account_coding').AsString;
    qryVData.ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;

    if self.FNewRecordCreated then
    begin
      qryVData.ParamByName('id').AsInteger := 0;
      qryVData.ParamByName('id').Value := null;
    end
    else
      qryVData.ParamByName('id').AsInteger := DataSet.FieldByName('id').AsInteger;
    qryVData.Open;

    if not qryVData.EOF then
    begin
      qryVData.Close;
      Dialogs.messageDlg(estbk_strmsg.SEAccountWSnameExists, mtError, [mbOK], 0);
      abort; // -->
    end;



    // ----------
    // kontrollime üle konto parameetrid !
    if (length(trim(qryAccounts.FieldByName('account_name').AsString)) < 1) then
    begin
      self.acctabCtrl.ActivePage := tabAcc;
      Dialogs.messageDlg(estbk_strmsg.SEAccountNameTooShort, mtError, [mbOK], 0);
      self.dbEdtAccountName.SetFocus;
      abort; // -->
    end;




    // 27.11.2010 Ingmar;  konto/pank/valuuta ei tohi esineda üle 1 korra !
    qryVData.Close;
    qryVData.SQL.Clear;
    qryVData.SQL.Add(estbk_sqlclientcollection._CSQLVerifyAccBankData);

    qryVData.ParamByname('account_coding').AsString := DataSet.FieldByName('account_coding').AsString;
    qryVData.ParamByname('bank_id').AsInteger := DataSet.FieldByName('bank_id').AsInteger;
    qryVData.ParamByname('default_currency').AsString := DataSet.FieldByName('default_currency').AsString;
    qryVData.ParamByname('account_nr').AsString := DataSet.FieldByName('account_nr').AsString;
    qryVData.ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryVData.Open;
    pAccDef := trim(qryVData.FieldByName('account_coding').AsString);


    qryVData.Close;
    qryVData.SQL.Clear;


    if pAccDef <> '' then
    begin
      self.acctabCtrl.ActivePage := tabAcc;
      Dialogs.messageDlg(format(estbk_strmsg.SEAccountBankAlreadyDef, [pAccDef]), mtError, [mbOK], 0);

      if self.cmbLkTypes.CanFocus then
        self.cmbLkTypes.SetFocus;
      abort; // -->
    end;



    //if (DataSet.FieldByName('classificator_id').AsInteger < 1) then
    if (DataSet.FieldByName('type_id').AsInteger < 1) then
    begin
      self.acctabCtrl.ActivePage := tabAcc;
      Dialogs.messageDlg(estbk_strmsg.SEAccountTypeIsMissing, mtError, [mbOK], 0);

      if self.cmbLkTypes.CanFocus then
        self.cmbLkTypes.SetFocus;
      abort; // -->
    end;



    // objektide muutmisel nõuame salvestamist,  muidu peaksime meeletult andmeid puhverdama !
    if self.FReqSaveBeforeScroll then
    begin
      Dialogs.messageDlg(estbk_strmsg.SConfBfScrollSaveChg, mtInformation, [mbOK], 0);
      if btnSave.CanFocus then
        btnSave.SetFocus;
      abort; // -->
    end;
  end;
end;

procedure TframeManageAccounts.qryAccountsEditError(DataSet: TDataSet; E: EDatabaseError; var DataAction: TDataAction);
begin
  Dialogs.messageDlg(format(estbk_strmsg.SEIncorrectFormat, [e.message]), mtError, [mbOK], 0);
  DataAction := daRetry;
  // abort;
end;

procedure TframeManageAccounts.cmbBalanceDefaultGrpKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    key := #0;
  end;
end;

procedure TframeManageAccounts.cmbLkTypesChange(Sender: TObject);
begin
  //accountDbGrid.Repaint;
  // TODO: fix
  // bugi gridis ei uuenda konto tüüp välja
end;

procedure TframeManageAccounts.dbBankLpCmbClosePopupNotif(Sender: TObject);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeManageAccounts.dbBankLpCmbKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Sender is TRxDBLookupCombo then
    try
      estbk_utilities.rxLibKeyDownHelper(Sender as TRxDBLookupCombo, Key, Shift, False);
    except
    end; // ---
end;

procedure TframeManageAccounts.dbBankLpCmbSelect(Sender: TObject);
begin
  with  TRxDBLookupCombo(Sender) do
    if (Value <> '') then
    begin
      LookupSource.DataSet.Locate('id', Value, []);
      Text := LookupSource.DataSet.FieldByName('bankname').AsString;
    end;
end;

procedure TframeManageAccounts.btnNewAccountClick(Sender: TObject);
begin
  // 19.08.2011 Ingmar
  chkDefaultAccinPmtForm.Checked := False;
  chkDefaultAccinIncForm.Checked := False;

  estbk_utilities.changeWCtrlEnabledStatus(accountList, True);
  cmbBalanceDefaultGrp.ItemIndex := -1;

  // -------
  accTree.TopItem.Selected := True;


  self.FNewRecordCreated := True;
  self.acctabCtrl.ActivePage := tabAcc;


  try
    self.FSkipScrollEvent := True;
    qryAccounts.Insert;

    self.cmbCurrency.ItemIndex := self.cmbCurrency.items.indexOf(estbk_globvars.glob_baseCurrency);
    self.loadQryReqObj(-1);
  finally
    self.FSkipScrollEvent := False;
  end;

  // ---
  TBitBtn(Sender).Enabled := False;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;


  if dbEdtAccountCode.canFocus then
    dbEdtAccountCode.SetFocus;


  //dbEdtInitBalance.color    := clWindow;
  //dbEdtInitBalance.ReadOnly := False;


  //accountDbGrid.Enabled:=False; // et scrolli ei luba !!!
  //dbEdtInitBalance.ParentColor:=true;
  //estbk_utilities.changeWCtrlEnabledStatus(srcpanel, False);
end;

procedure TframeManageAccounts.btnSaveClick(Sender: TObject);
var
  //FIsNewGrpItem: boolean;
  FpkRec: boolean;
  FTmpState: boolean;
  FCurrBkMark: TBookmark;
  //  FOrigStrItem: AStr;
  //  Temp:      integer;
  //  FAccClassId: integer;
  //  FSelectAccCode: AStr;

begin
  // kontodega seotud objekti info salvestamine
         {
      qryAccObjects.ApplyUpdates;
      qryAccObjects.CommitUpdates;
      }



  // ---
  with estbk_clientdatamodule.dmodule do
  begin

    // kontroll uuesti tööle !! Et event ei viskaks salvestamisel teadet, et peate esmalt andmed salvestama :)
    try

      if qryAccounts.State in [dsEdit, dsInsert] then
        qryAccounts.Post;

      FTmpState := self.FReqSaveBeforeScroll;
      self.FReqSaveBeforeScroll := False;
      self.qryAccountsBeforeScroll(qryAccounts);

    finally
      self.FReqSaveBeforeScroll := FTmpState;
      // peame staatust säilitama, kunagi ei tea, mis võib juhtuda !
    end;



    // -------
    try
      // nii...läheb tegevuseks
      // -----------
      primConnection.StartTransaction;
      // saadame andmed teele - "normaalses stiilis"
      qryAccounts.ApplyUpdates;


      // kuna zeoses pooled meetodit ei tööta ning updateSQL ei saa me ülelaadida, peame jooksva kirje andmed ise
      // ükshaaval läbi käima ning salvestama. Tobe, aga mis teha
      qryVData.Close;
      qryVData.SQL.Clear;



      try
        FCurrBkMark := qryAccObjects.GetBookmark;
        qryAccObjects.DisableControls;
        qryAccObjects.First;

        while not qryAccObjects.EOF do
        begin
          // kasutame ära dummy chkbox fieldi, et muudatusi leida
          FpkRec := qryAccObjects.FieldByName('chkfield').AsBoolean;
          if (qryAccObjects.FieldByName('account_id').AsInteger < 1) then
            // järelikult hetkel polnud veel antud objekti omistatud
          begin

            // -- UUS KIRJE !
            if FpkRec then
            begin
              qryVData.Close;
              qryVData.SQL.Clear;
              qryVData.SQL.Add(estbk_sqlclientcollection._CSQLInsertAccReqObjects);

              // ---
              qryVData.ParamByname('id').AsInteger := qrySeqnewAccObjRec.GetNextValue;
              qryVData.ParamByname('account_id').AsInteger := qryAccounts.FieldByName('id').AsInteger;
              // qrySeqnewAccount.GetCurrentValue;// FNewAccountId;
              qryVData.ParamByname('object_id').AsInteger := qryAccObjects.FieldByName('object_id').AsInteger;
              qryVData.ParamByname('type_').AsString := 'O';
              // hetkel ainult objekt;
              qryVData.ParamByname('rec_changed').AsDateTime := now;
              qryVData.ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              qryVData.ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
              qryVData.execSQL;

            end; // else
          end
          else
          if not FpkRec then
          begin
            qryVData.Close;
            qryVData.SQL.Clear;
            qryVData.SQL.Add(estbk_sqlclientcollection._CSQLDeleteAccReqObjects);
            qryVData.ParamByname('rec_changed').AsDateTime := now;
            qryVData.ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
            qryVData.ParamByname('id').AsInteger := qryAccObjects.FieldByName('id').AsInteger;
            qryVData.execSQL;
          end;
          // ---
          qryAccObjects.Next;
        end;

        // --
      finally
        qryAccObjects.GotoBookmark(FCurrBkMark);
        qryAccObjects.FreeBookmark(FCurrBkMark);

        qryAccObjects.EnableControls;
        // --
        qryVData.Close;
        qryVData.SQL.Clear;
      end;


      // kinnitame oma soove...
      primConnection.Commit;
      qryAccounts.CommitUpdates;

      //qryAccObjects.Refresh;
      qryAccObjects.Active := False;
      qryAccObjects.Active := True;




      // saadame välja signaali, et uuenda andmeid...
      if assigned(FFrameDataEvent) then
        FFrameDataEvent(self, __frameAccAddedChanged, -1);



      // nuppude staatus taastada ---
      btnSave.Enabled := False;
      btnCancel.Enabled := False;
      btnNewAccount.Enabled := True;

      // ---

      //dbEdtInitBalance.color    := clBtnFace;
      //dbEdtInitBalance.ReadOnly := True;


      //estbk_utilities.changeWCtrlEnabledStatus(srcpanel, True);


      //dbEdtInitBalance.ParentColor:=False;
      // ------
      // nullime lipud
      self.FDataNotSaved := False;


      // 08.02.2010 Ingmar
      if self.FNewRecordCreated or self.FAccountCodeChangedDoReload then
        self.loadAccountTree(dbEdtAccountCode.Text);


      //self.addNewAccountNode(qryAccounts.fieldByname('account_coding').asString,
      //                       qryAccounts.fieldByname('account_name').asString);




            {
            FSelectAccCode := qryAccounts.FieldByName('account_coding').AsString;

            //qryAccounts.active:=False;
            qryAccounts.Refresh;
            // ...reload
            qryAccounts.locate('account_coding', FSelectAccCode, []);
            }



      self.FNewRecordCreated := False;
      self.FReqSaveBeforeScroll := False;
      self.FAccountCodeChangedDoReload := False;

      // laeme uuesti objektid !!!
      self.loadQryReqObj(qryAccounts.FieldByName('id').AsInteger, True);

    except
      on e: Exception do
      begin
        if primConnection.InTransaction then
          try
            primConnection.Rollback;
          except
          end; // ntx trigger teinud rollbacki ja kui me ka veel teeme...oi oi oi...

        if not (e is EAbort) then
          messageDlg(format(SESaveFailed, [e.message]), mtError, [mbOK], 0);
      end;
    end;

    // -- bfr tühjaks
    tempQuery.Close;
    tempQuery.SQL.Clear;
  end; // ---

end;

procedure TframeManageAccounts.chkBoxAccStatusChange(Sender: TObject);
var
  pnewEdtMode: boolean;
begin
  with TCheckBox(Sender) do
    if focused and not self.FSkipScrollEvent then
      try
        pnewEdtMode := not (qryAccounts.state in [dsEdit, dsInsert]);
        if pnewEdtMode then
          qryAccounts.Edit;
        // -- siia ei peagi mingit db koodi panema;
        // Before post event teeb kõik ülejäänud !!!!
        //accountDbGrid.repaint;
        dbgridAccObjects.Columns.Items[0].ReadOnly := Checked;

      finally
        if pnewEdtMode then
          qryAccounts.Post;

      end;
  // --
end;

procedure TframeManageAccounts.chkbxDispOnbillChange(Sender: TObject);
begin
  with TCheckbox(Sender) do
    if focused then
    begin

      // --
      if not (qryAccounts.state in [dsEdit, dsInsert]) then
        qryAccounts.Edit;
      qryAccounts.FieldByName('display_onbill').AsString := estbk_types.SCFalseTrue[Checked];
      // hetkel on vaikimisi vaid müügiarved !
      qryAccounts.FieldByName('display_billtypes').AsString := estbk_types._CItemSaleBill;
    end;
end;

// 19.08.2011 Ingmar
procedure TframeManageAccounts.chkDefaultAccinIncFormChange(Sender: TObject);
var
  pAcc: AStr;
begin
  with TCheckbox(Sender) do
    if Focused and assigned(accTree.Selected) then
    begin
      qryAccounts.Edit;
      if Checked then
        pAcc := self.extractAccount(accTree.Selected.Text)
      else
        pAcc := ''; // --

      if Sender = self.chkDefaultAccinIncForm then
        dmodule.userStsValues[CstsDefaultIncAcc] := pAcc
      else
      if Sender = self.chkDefaultAccinPmtForm then
        dmodule.userStsValues[CstsDefaultPmtAcc] := pAcc;
      qryAccounts.Post; // lihtsalt selleks, et evendid jookseks nagu dataset komponentide puhul
    end;
end;


procedure TframeManageAccounts.cmbBalanceDefaultGrpChange(Sender: TObject);
var
  pNewSession: boolean;
  pItemId: integer;
  pMode: byte;
begin
  if not self.FSkipScrollEvent and TCombobox(Sender).Focused then
    try

      // bilansigrupp
      if Sender = self.cmbBalanceDefaultGrp then
        pMode := 0
      else
      // kasumiaruande grupp
      if Sender = self.cmbIncomeStatement then
        pMode := 1
      else
        Exit;


      pNewSession := not (qryAccounts.state in [dsEdit, dsInsert]);
      if pNewSession then
        qryAccounts.Edit;
      // ---
      pItemId := PtrInt(TCombobox(Sender).Items.Objects[TCombobox(Sender).ItemIndex]);


      case pMode of
        0: qryAccounts.FieldByName('balance_rep_line_id').AsInteger := pItemId;
        1: qryAccounts.FieldByName('incstat_rep_line_id').AsInteger := pItemId;
      end;


      // --
    finally
      if pNewSession then
        qryAccounts.Post;
      self.FSkipScrollEvent := False;
    end;
end;

procedure TframeManageAccounts.btnCancelClick(Sender: TObject);
begin
  //  qryAccounts.Cancel;
  self.FNewRecordCreated := False;
  self.FDataNotSaved := False;
  // ---

  qryAccounts.CancelUpdates;

  if (qryAccObjects.state = dsEdit) then
    qryAccObjects.post; // sulgeme sisestuse !

  if self.FReqSaveBeforeScroll then
  begin
    qryAccObjects.CancelUpdates;
    self.loadQryReqObj(qryAccounts.FieldByName('id').AsInteger, True);
  end;

  // ----
  self.FReqSaveBeforeScroll := False;



  btnNewAccount.Enabled := True;
  btnSave.Enabled := False;
  TBitBtn(Sender).Enabled := False;


  //dbEdtInitBalance.color    := clBtnFace;
  //dbEdtInitBalance.ReadOnly := True;


  //estbk_utilities.changeWCtrlEnabledStatus(srcpanel, True);
  estbk_utilities.changeWCtrlEnabledStatus(acctabCtrl, not qryAccounts.EOF);
  acctabCtrl.Enabled := True;

  //accountDbGrid.Enabled:=true; // et scrolli ei luba !!!
  //dbEdtInitBalance.ParentColor:=False;
end;

procedure TframeManageAccounts.accountDbGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
var
  pStatus: AStr;
  pFieldVal: integer;

begin
  with (Sender as TDBGrid) do
  begin
    if (gdSelected in State) then // or (dgRowSelect in TDbGrid(Sender).Options)
    begin
      Brush.Color := clBackGround;
      Font.Color := clWhite;
    end
    else
    begin
      Canvas.Brush.Color := clWindow;
      Font.Color := clBlack;
    end;

    // --------
    Canvas.FillRect(Rect);
    if DataCol = Columns.Count - 1 then
    begin
      // tulevikus lisandub veelgi staatusi
      pFieldVal := Column.Field.AsInteger;

      // konto puhul natuke keerulisem, kui lihtsalt staatus, seal on nö bitmaskid !
      if (pFieldVal and estbk_types.CAccFlagsClosed) = estbk_types.CAccFlagsClosed then
        pStatus := estbk_strmsg.CSStatusClosed;
      Canvas.TextOut(Rect.left + 2, Rect.top + 2, pStatus);
    end
    else
      Canvas.TextOut(Rect.left + 2, Rect.top + 2, Column.Field.AsString);
  end;
end;

procedure TframeManageAccounts.accountDbGridTitleClick(Column: TColumn);
begin
  //     qryAccounts.SortedFields:='';
  qryAccounts.SortedFields := Column.FieldName;

  if self.FAccLastColUsedToSort <> Column.Index then
  begin
    self.FAccLastSortOrder := stAscending;
    qryAccounts.SortType := self.FAccLastSortOrder;
  end
  else
    case self.FAccLastSortOrder of   // zeos ei suuda säilitada õiget väärtus propertis SortType !
      stAscending,
      stIgnored:
      begin
        self.FAccLastSortOrder := stDescending;
        qryAccounts.SortType := self.FAccLastSortOrder;
      end;

      stDescending:
      begin
        self.FAccLastSortOrder := stAscending;
        qryAccounts.SortType := self.FAccLastSortOrder;
      end;
    end;

  self.FAccLastColUsedToSort := Column.Index;
end;

function TframeManageAccounts.extractAccount(const pAccountStr: AStr): AStr;
var
  pNStr: AStr;
  pMarker: integer;
begin
  Result := '';
  pMarker := pos(CAccCodeNameSep, pAccountStr); // eemaldame nime, meid huvitav vaid KOOD
  if pMarker > 0 then
    Result := copy(pAccountStr, 1, pMarker - 1);
end;

procedure TframeManageAccounts.accTreeChange(Sender: TObject; Node: TTreeNode);
var
  pAccCode: AStr;
begin
  // --  TTreeView(Sender).focused
  if assigned(accTree.Selected) and (accTree.Selected <> accTree.TopItem) then
  begin
    pAccCode := self.extractAccount(accTree.Selected.Text);
    qryAccounts.Locate('account_coding', pAccCode, [loCaseInsensitive]);

    self.chkDefaultAccinIncForm.Checked := ansilowercase(pAccCode) = ansilowercase(dmodule.userStsValues[CstsDefaultIncAcc]);
    self.chkDefaultAccinPmtForm.Checked := ansilowercase(pAccCode) = ansilowercase(dmodule.userStsValues[CstsDefaultPmtAcc]);
  end;
end;

procedure TframeManageAccounts.accTreeChanging(Sender: TObject; Node: TTreeNode; var AllowChange: boolean);
begin
  AllowChange := not self.FDataNotSaved;
  if not AllowChange then
    Dialogs.messageDlg(estbk_strmsg.SConfBfScrollSaveChg, mtInformation, [mbOK], 0);
end;

procedure TframeManageAccounts.accTreeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  pParentNode: TTreeNode;
begin
  if (key = VK_DELETE) and (Shift = []) and assigned(accTree.Selected) then
  begin
    key := 0;
    // konto all on alamkontosid !
    if assigned(accTree.Selected.GetFirstChild) then
    begin
      Dialogs.MessageDlg(estbk_strmsg.SEAccountHasSubElements, mtError, [mbOK], 0);
      exit;
    end;


    if qryAccounts.Locate('account_coding', self.extractAccount(accTree.Selected.Text), []) then
      with qryVData, SQL do
        try

          // ---
          Close;
          Clear;
          add(estbk_sqlclientcollection._CSQLIsAccountBeenUsed);
          parambyname('account_id').AsInteger := qryAccounts.FieldByName('id').AsInteger;
          Open;
          if FieldByName('id').AsInteger > 0 then
          begin
            Dialogs.MessageDlg(estbk_strmsg.SEAccountHasBeenUsed, mtError, [mbOK], 0);
            exit;
          end;


          // !!!
          if Dialogs.MessageDlg(format(estbk_strmsg.SConfAccDeleteAccount, [accTree.Selected.Text]), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            exit;




          Close;
          Clear;
          add(estbk_sqlclientcollection._CSQLDeleteAccount);
          parambyname('id').AsInteger := qryAccounts.FieldByName('id').AsInteger;
          parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;


          // ---
          pParentNode := accTree.Selected.Parent;
          accTree.Selected.Delete;


          if assigned(pParentNode) then
          begin

            if pParentNode = accTree.Items.Item[0] then
              pParentNode := pParentNode.GetFirstChild;



            if assigned(pParentNode) then
            begin
              accTree.Selected := pParentNode;
              qryAccounts.Locate('account_coding', self.extractAccount(pParentNode.Text), [loCaseInsensitive]);
            end;
            // ---
          end;

        finally
          Close;
          Clear;
        end;
    // ---
  end;
end;

procedure TframeManageAccounts.btnCloseClick(Sender: TObject);
begin
  if assigned(FframeKillSignal) then
    FframeKillSignal(self);
end;

procedure TframeManageAccounts.refreshObjectList();
begin
  self.loadQryReqObj(qryAccObjects.ParamByname('account_id').AsInteger, True);
end;


procedure TframeManageAccounts.parentKeyEvent(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // depr
end;

constructor TframeManageAccounts.Create(frameOwner: TComponent);
begin
  try
    // -------
    inherited Create(frameOwner);


    estbk_uivisualinit.__preparevisual(self);

    //srcpanel.color:=estbk_types.MyFavGray;
    //objsrcpanel.color:=estbk_types.MyFavGray;
    //self.srcpanel.visible:=false;
    self.acctabCtrl.ActivePage := self.tabAcc;
    self.cmbCurrency.Items.Assign(estbk_clientdatamodule.dmodule.currencyList);
    self.cmbCurrency.ItemIndex := self.cmbCurrency.items.indexOf(estbk_globvars.glob_baseCurrency);

    // -------
    //leftPanel.Color:=estbk_types.MyFavOceanBlue;
    //rightPanel.Color:=estbk_types.MyFavOceanBlue;
    //self.Color:=estbk_types.MyFavOceanBlue;
    //self.color:=clbtnface;
    spl.ParentColor := False;
    spl.Color := clForm;


    self.FParentKeyNotif := @self.parentKeyEvent;
    // 29.05.2011 Ingmar
    dbBankLpCmb.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;


  except
    on e: Exception do
      // ---
      Dialogs.messageDlg(format(estbk_strmsg.SEInitializationZError, [e.message, self.ClassName]), mtError, [mbOK], 0);
  end;
end;

destructor TframeManageAccounts.Destroy;
begin
  inherited Destroy;
end;

initialization
  {$I estbk_fra_createmodaccounts.ctrs}

end.