unit estadmin_form;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Messages, ComCtrls, Menus, ExtCtrls, Grids, DBGrids, DB, estbk_progressform, estbk_lib_commoncls,
  estbk_datamodule, estbk_accperiods, estbk_vat, estbk_types, estbk_globvars, estbk_strmsg,
  estbk_frame_chooseaddr, StdCtrls, FileCtrl, DBCtrls, Buttons, CheckLst, estbk_upgrademodule, estbk_frm_numerators,
  estbk_frame_worker_mgr, estbk_customdialogsform, estbk_uivisualinitadmin, ZDataset, ZSequence,
  ZSqlUpdate, ZSqlMonitor, LCLType, types, base64;

// ----------------------------------------------------------------------------

// VERSION STR
const
  SCurrentAppver = #32'ver 0.59 '#32;

// ----------------------------------------------------------------------------

type
  // ----------

  { Tform_admin }

  Tform_admin = class(TForm)
    actionToolbar: TToolBar;
    admCompListDataset: TDatasource;
    admCompListQry: TZQuery;
    admWorkerMgmDataset: TDatasource;
    admWorkerMgmQry: TZQuery;
    frameAccPeriods1: TframeAccPeriods;
    frameCompCAddr: TFrameAddrPicker;
    frameVATMgr: TframeVATs;
    compLogoPct: TImage;
    l1: TBevel;
    btnCancel: TBitBtn;
    btnCancelWorkerEdit: TBitBtn;
    btnClose: TBitBtn;
    btnNewItem: TBitBtn;
    btnWorkerMgrTabClose: TBitBtn;
    btnNewWorker: TBitBtn;
    btnSave: TBitBtn;
    btnSaveWorker: TBitBtn;
    chkLstBoxAllowedCmp: TCheckListBox;
    chkLstBoxUserRoles: TCheckListBox;
    chkLstBoxPermission: TCheckListBox;
    chkLstBoxUserRolePermListing: TCheckListBox;
    comboCity: TComboBox;
    comboCounty: TComboBox;
    comboStreet: TComboBox;
    dbChkboxAllowLogin: TDBCheckBox;
    dbEdtApartment: TDBEdit;
    dbEdtCompname: TDBEdit;
    dbEdtEmail: TDBEdit;
    dbEdtFax: TDBEdit;
    dbEdtHouse: TDBEdit;
    dbEdtMobile: TDBEdit;
    dbEdtRegnr: TDBEdit;
    dbEdtWorkName: TDBEdit;
    dbEdtWorkUsername: TDBEdit;
    dbEdtWorMiddleName: TDBEdit;
    dbEdtWrkEmail: TDBEdit;
    dbEdtWrLoginFromIp: TDBEdit;
    dbEdtWrkLastname: TDBEdit;
    dbEdtWrkLastlogin: TDBEdit;
    dbEdtWrkPosition: TDBEdit;
    dbEdtZipcode: TDBEdit;
    dbGridWorkers: TDBGrid;
    dbGridcmp: TDBGrid;
    dbPhone: TDBEdit;
    dbVatnumber: TDBEdit;
    edEdtWrkPassword: TEdit;
    ImageList1: TImageList;
    l2: TBevel;
    Label1: TLabel;
    copyrightLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbCompanyName1: TLabel;
    lblLocData: TLabel;
    lbCity: TLabel;
    lbCompanyName: TLabel;
    lbCompregcode: TLabel;
    lbCounty: TLabel;
    lbEmail: TLabel;
    lbFax: TLabel;
    lbKorter: TLabel;
    lblLocDbVersion: TLabel;
    lbMaja: TLabel;
    lbMobile: TLabel;
    lbPhone: TLabel;
    lbStreet: TLabel;
    lbVatnumber: TLabel;
    lbWorkerLoginname: TLabel;
    lbWorkerPassword: TLabel;
    lbWrkLastLogin: TLabel;
    lbWrkLastLoginCIP: TLabel;
    lbWrkLoginAllowed: TLabel;
    lbWrkPosition: TLabel;
    lbWrkMiddleName: TLabel;
    lbWrkLastname: TLabel;
    lbWrkName: TLabel;
    lbWrkEmail: TLabel;
    lbZipcode: TLabel;
    FIX: TMenuItem;
    MenuItem1: TMenuItem;
    mnuReinitRole: TMenuItem;
    mnuVacuumDb: TMenuItem;
    mnuDebug: TMenuItem;
    mnuItemExecScript: TMenuItem;
    mnuSep5: TMenuItem;
    mnu_copySettings: TMenuItem;
    mnuRestore: TMenuItem;
    mnuBackup: TMenuItem;
    mnu_exit: TMenuItem;
    mnu_main: TMainMenu;
    adm_mainpanel: TPanel;
    admPages: TPageControl;
    openAccFile: TOpenDialog;
    openCompLogo: TOpenDialog;
    openScriptFile: TOpenDialog;
    pageCompControl: TPageControl;
    pageCtrlUserMgr: TPageControl;
    Panel1: TPanel;
    leftpanelWrk: TPanel;
    Panel2: TPanel;
    panelCompLogo: TPanel;
    pgControlUserPrm: TPageControl;
    mnuCmpActions: TPopupMenu;
    qryCity: TZQuery;
    qryCitySeq: TZSequence;
    qryCounty: TZQuery;
    qryCountySeq: TZSequence;
    qryInsertCity: TZUpdateSQL;
    qryInsertCounty: TZUpdateSQL;
    qryInsertStreet: TZUpdateSQL;
    qryStreet: TZQuery;
    qryStreetSeq: TZSequence;
    rightpanelWrk: TPanel;
    SpeedButton1: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    firstpage: TTabSheet;
    btnMngComp: TToolButton;
    btnMgnUsers: TToolButton;
    tabAction: TTabSheet;
    tabComp: TTabSheet;
    tabCompanyPermission: TTabSheet;
    tabOverAllDescr: TTabSheet;
    tabOverAllpermission: TTabSheet;
    tabRole: TTabSheet;
    tabCompContact: TTabSheet;
    tabPageAccPeriod: TTabSheet;
    tabLogo: TTabSheet;
    tabVat: TTabSheet;
    tabWorkerMgm: TTabSheet;
    loadLogo: TTimer;
    ToolButton1: TToolButton;
    tempQry: TZQuery;
    qryClientSeq: TZSequence;
    procedure actionToolbarClick(Sender: TObject);
    procedure admCompListQryAfterEdit(DataSet: TDataSet);
    procedure admCompListQryAfterPost(DataSet: TDataSet);
    procedure admCompListQryAfterScroll(DataSet: TDataSet);
    procedure admCompListQryBeforeEdit(DataSet: TDataSet);
    procedure admCompListQryBeforePost(DataSet: TDataSet);
    procedure admCompListQryBeforeScroll(DataSet: TDataSet);
    procedure admCompListQryEditError(DataSet: TDataSet; E: EDatabaseError; var DataAction: TDataAction);
    procedure admWorkerMgmQryAfterEdit(DataSet: TDataSet);
    procedure admWorkerMgmQryAfterPost(DataSet: TDataSet);
    procedure admWorkerMgmQryAfterScroll(DataSet: TDataSet);
    procedure admWorkerMgmQryBeforePost(DataSet: TDataSet);
    procedure admWorkerMgmQryBeforeScroll(DataSet: TDataSet);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelWorkerEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnMgnUsersClick(Sender: TObject);
    procedure btnMngCompClick(Sender: TObject);
    procedure btnNewItemClick(Sender: TObject);
    procedure btnNewWorkerClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveWorkerClick(Sender: TObject);
    procedure btnWorkerMgrTabCloseClick(Sender: TObject);
    procedure chkLstBoxAllowedCmpClick(Sender: TObject);
    procedure chkLstBoxPermissionItemClick(Sender: TObject; Index: integer);
    procedure chkLstBoxUserRolePermListingItemClick(Sender: TObject; Index: integer);
    procedure chkLstBoxUserRolesClickCheck(Sender: TObject);
    procedure chkLstBoxUserRolesItemClick(Sender: TObject; Index: integer);
    procedure dbEdtCompnameKeyPress(Sender: TObject; var Key: char);
    procedure dbEdtWorkUsernameKeyPress(Sender: TObject; var Key: char);
    procedure edEdtWrkPasswordChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure FrameAddrPicker1Click(Sender: TObject);
    procedure loadLogoTimer(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure mnuDebugClick(Sender: TObject);
    procedure mnuBackupClick(Sender: TObject);
    procedure mnuItemExecScriptClick(Sender: TObject);
    procedure mnuReinitRoleClick(Sender: TObject);
    procedure mnuRestoreClick(Sender: TObject);
    procedure mnuVacuumDbClick(Sender: TObject);
    procedure mnu_exitClick(Sender: TObject);
    procedure pageCompControlChange(Sender: TObject);
    procedure panelCompLogoClick(Sender: TObject);
    procedure pgControlUserPrmPageChanged(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);

  private
    FTemplate0Collation: AStr; // ---
    FSkipEvent: boolean; // et vältida evendisisest rekursiooni
    FIsNewComp: boolean;
    FCompDataNotSaved: boolean;
    FWorkDataNotSaved: boolean;
    // 23.12.2011 Ingmar
    procedure updateCompLogo(const pCompId: integer);
    procedure addDefaultAccountingPlanToComp(const compId: integer; const povrFilename: AStr = '');
    // ----
    function isPermissionBoundWithActiveRole(const permId: integer; var roleId: integer; var roleName: AStr;
      const skipRoleWithId: integer = -1): boolean;
    procedure createUserWithPermissions;
    procedure finalDataCleanup; // meil erinevaid tabe, puhverdatud andmeid
    procedure onClickCopyCmpSettings(Sender: TObject);
    procedure addCompanyListIntoSubMenu;


    // -- evendid
    procedure OnChangeAddEditMode(Sender: TObject);
    procedure OnAccPeriodDataChanged(Sender: TObject);
  public
    procedure createUserCompList(const userID: integer; const reloadComp: boolean = False);
    procedure createUserPermissionList(const userID: integer; const reloadPerm: boolean = False);
  end;

var
  form_admin: Tform_admin;
  myOldExceptHnd: TExceptProc = nil; // ---

implementation

uses estbk_dbcompability, estbk_sqlcollection, estbk_utilities, estbk_loginform,
  estbk_frm_backup_restore, estbk_fra_template, estbk_settings;



// 07.02.2010 Ingmar; faili lugemisel kasutatav !
type
  TAccPreDefDataHelperClass = class
    FAccDefCurr: AStr;
    FAccName: AStr;
    FAccTypeIndx: integer;
    FAccClsIndx: integer;
    FBalanceLogNr: AStr;
    FBalanceLineId: integer; // bilansirea nr !
    FIncsLogNr: AStr;
    FIncsLogNrLineId: integer;
  end;



// ---------------------------------------------------------------------------

procedure Tform_admin.mnu_exitClick(Sender: TObject);
begin
  application.Terminate;
end;

procedure Tform_admin.pageCompControlChange(Sender: TObject);
begin
  if pageCompControl.ActivePage = self.tabCompContact then
    btnNewItem.Caption := estbk_strmsg.SBtnCaptNewComp
  else
  if pageCompControl.ActivePage = self.tabPageAccPeriod then
    btnNewItem.Caption := estbk_strmsg.SBtnCaptNewAccYr
  else
  if pageCompControl.ActivePage = self.tabVat then
    btnNewItem.Caption := estbk_strmsg.SBtnCaptNewVat;
end;

procedure Tform_admin.panelCompLogoClick(Sender: TObject);
begin

end;



procedure Tform_admin.pgControlUserPrmPageChanged(Sender: TObject);
begin
  // ilma selleta on elementide focuscontrol jumalast paigast ära !
  if (Sender = tabCompanyPermission) then
  begin
    if chkLstBoxAllowedCmp.Enabled then
      chkLstBoxAllowedCmp.SetFocus;
  end
  else
  if (Sender = tabOverAllpermission) then
  begin
    if chkLstBoxPermission.Enabled then
      chkLstBoxPermission.SetFocus;
  end
  else
  if (Sender = tabRole) then
  begin
    if chkLstBoxUserRoles.Enabled then
      chkLstBoxUserRoles.SetFocus;
  end;
end;

procedure Tform_admin.SpeedButton1Click(Sender: TObject);
const
  CMaxFilesize = 700000;
var
  //pFile : File of Byte;
  pFilename: AStr;
  pFileSize: int64;
begin
  if openCompLogo.Execute then
  begin
    pFilename := openCompLogo.Files.Strings[0];
    //AssignFile (pFile,pFilename);
    //Reset (pFile);
    pFileSize := FileSize(pFilename);
    //CloseFile(pFile);
    if pFileSize <= CMaxFilesize then
    begin
      compLogoPct.Picture.LoadFromFile(pFilename);
      btnNewItem.Enabled := False;
      btnSave.Enabled := True;
      btnCancel.Enabled := True;
    end
    else
      Dialogs.MessageDlg(estbk_strmsg.SELogoFileIsTooBig, mtError, [mbOK], 0);
  end;
end;



procedure Tform_admin.FormCreate(Sender: TObject);
begin
  // Windows 7 kasutab sisuliselt kõikjal large fonti ! Programm näeb välja viisakalt öeldes jube !
  // NB windows 10 peal autosize töötab ja __preparevisual rikub ära ui !
  // estbk_uivisualinitadmin.__preparevisual(self);
  compLogoPct.Picture.Clear;
  copyrightLabel.Font.Style := [fsBold];
  //Label4.Font.Style:=[fsBold];
  //Label5.Font.Style:=[fsBold];

  // TRANSLATE
  btnMgnUsers.Hint := 'Kasutajate haldus';
  btnMngComp.Hint := 'Firmade haldus';
  // -----

  admCompListQry.SQL.add(estbk_sqlcollection._SQLSelectAllCompanys);
  admWorkerMgmQry.SQL.Add(estbk_sqlcollection._SQLSelectAllusers);

  // -----
  lblLocData.Caption := estbk_utilities.getSysLocname();

  frameAccPeriods1.OnDataChangeNotif := @self.OnAccPeriodDataChanged;
  frameVATMgr.OnDataChangeNotif := @self.OnAccPeriodDataChanged;



  // TAASTADA !!!
  //frameAccPeriods1.pchkboxAccPer.Visible:=false;
  //  SCNumeratorConversions
  mnuDebug.Visible := False;



  {$IFDEF debugmode}
  mnuDebug.Visible := True;
  {$ENDIF}

end;



procedure Tform_admin.FormDestroy(Sender: TObject);
begin
  self.finalDataCleanup;
end;

procedure Tform_admin.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  pchk: boolean;
begin

  if (upcase(chr(key)) = 'S') and (Shift = [ssCtrl]) then
  begin
    if (admPages.ActivePage = tabComp) and (btnSave.Enabled) then
      btnSave.OnClick(btnSave)
    else
    if (admPages.ActivePage = tabWorkerMgm) and (btnSaveWorker.Enabled) then
      btnSaveWorker.OnClick(btnSaveWorker);
  end
  else
  // undocumented !
  // 11.05.2012 Ingmar; millegipärast ei tööta numeraatorite cache igakord korrektselt !
  if (Shift = [ssCtrl]) and (admPages.ActivePage = tabComp) and admCompListQry.Active and (admCompListQry.FieldByName('id').AsInteger > 0) then
  begin

    // @@@
    if (key = VK_F11) then
    begin
      admDatamodule.remapNumerators(admCompListQry.FieldByName('id').AsInteger);
    end
    else
    if (key = VK_F12) then
    begin
      if Dialogs.MessageDlg(estbk_strmsg.SCNumeratorFlushCache + ' (' + admCompListQry.FieldByName('name').AsString +
        ')', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        with admDatamodule.admTempQuery, SQL do
          try
            pchk := admDatamodule.admTempQuery.ParamCheck;
            admDatamodule.admTempQuery.ParamCheck := True;
            Close;
            Clear;
            // --
            add(estbk_sqlcollection._SQLFlushNumeratorCache);
            paramByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
            execSQL;
          finally
            Close;
            Clear;
            // --
            admDatamodule.admTempQuery.ParamCheck := pchk;
            key := 0;
          end;
    end; // else küpseta kooke
  end;

end;

procedure Tform_admin.FormKeyPress(Sender: TObject; var Key: char);
begin

  // 29.08.2009 ingmar; järjekordne hack; tchecklistbox ei anna eventi, itemcheckedclick kui tühikuga märgistati
  // ei jää midagi muud üle, kui see tegevus ära keelata :(
  if assigned(self.ActiveControl) and (self.ActiveControl is TChecklistbox) and (key = #32) then
    key := #0;
end;

procedure Tform_admin.OnChangeAddEditMode(Sender: TObject);
begin
  with admCompListQry do
    if not (state in [dsEdit, dsInsert]) then
      Edit;
end;

procedure Tform_admin.OnAccPeriodDataChanged(Sender: TObject);
begin
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
  btnNewItem.Enabled := False;
end;

// Haldame firmasid järjekordne dünaamiline leht...
procedure Tform_admin.btnMngCompClick(Sender: TObject);
begin
  TToolbutton(Sender).Enabled := False;
  tabComp.TabVisible := True;


  pageCompControl.ActivePage := tabCompContact;

  frameCompCAddr.connection := estbk_datamodule.admDatamodule.admConnection;
  frameCompCAddr.loadData := True;
  frameCompCAddr.liveMode := True;

  // qry avatuks
  admCompListQry.Open;

  // ---------------------
  changeWCtrlEnabledStatus(self.Panel2, not admCompListQry.EOF);
  //    changeWCtrlEnabledStatus(self.btnClose,not estbk_datamodule.admDatamodule.admCompListQry.Eof,9);
  self.Panel2.Enabled := True;
  // ---------------------
  admpages.ActivePage := tabComp;
         {
if dbEdtCompname.Enabled then
   dbEdtCompname.SetFocus
else
   self.btnNewComp.SetFocus;
             }

  // --- üks trikk, onchange handler külge,et tavaline combo tõmbaks editi käima
  frameCompCAddr.comboCounty.OnChange := @self.OnChangeAddEditMode;
  frameCompCAddr.comboCity.OnChange := @self.OnChangeAddEditMode;
  frameCompCAddr.comboStreet.OnChange := @self.OnChangeAddEditMode;
end;

procedure Tform_admin.btnNewItemClick(Sender: TObject);
begin
  // kui kontakti leht, siis loome uue firma...
  if pageCompControl.ActivePage = tabCompContact then
  begin

    //pageCompControl.ActivePage:=tabCompContact;
    admCompListQry.Insert;


    if admCompListQry.state = dsInsert then
    begin
      changeWCtrlEnabledStatus(self.Panel2, True);

      dbEdtCompname.SetFocus;
      frameCompCAddr.countyId := 0;
      frameCompCAddr.cityId := 0;
      frameCompCAddr.streetId := 0;

      // üldiselt uue firma puhul peidame majandusaastad
      self.tabPageAccPeriod.TabVisible := False;
      self.tabVat.TabVisible := False;
      self.tabLogo.TabVisible := False;
      compLogoPct.Picture.Clear;
    end;
    // --------
  end
  else // ---
  if pageCompControl.ActivePage = tabPageAccPeriod then
  begin
    frameAccPeriods1.triggerNewRecEvent;
  end
  else
  if pageCompControl.ActivePage = tabVat then
  begin
    frameVATMgr.triggerNewRecEvent;
  end;

  // ---
  TBitBtn(Sender).Enabled := False;
  btnCancel.Enabled := True;
  btnSave.Enabled := True;
end;


procedure Tform_admin.btnNewWorkerClick(Sender: TObject);
begin

  self.pageCtrlUserMgr.ActivePage := tabOverAllDescr;
  admWorkerMgmQry.insert;
  if admWorkerMgmQry.state = dsInsert then
  begin
    changeWCtrlEnabledStatus(self.rightpanelWrk, True);
    self.rightpanelWrk.Enabled := True;
    TBitBtn(Sender).Enabled := False;
    dbEdtWorkUsername.ReadOnly := False;
    dbEdtWorkUsername.Color := clwindow;
    dbEdtWorkUsername.ParentColor := False;
    dbEdtWorkUsername.SetFocus;
    edEdtWrkPassword.Text := '';
  end;
  // ---
end;



// EELDEFINEERITUD kontode sisselugemine, teeb elu kasutajale mugavamaks !
// 07.02.2010 Ingmar
procedure Tform_admin.addDefaultAccountingPlanToComp(const compId: integer; const povrFilename: AStr = '');
const
  CTab = #09;
  CDefFilename = 'defaultaccountplan.txt';

var
  i: integer;
  pAccListFile: AStr;
  pTextFile: TextFile;
  // --
  pBuffer: TAStrList;
  pDefAccType: TAStrList;
  pDefAccCls: TAStrList;
  pTextLine: AStr;
  // ---
  pAccCode: AStr;
  pAccName: AStr;
  pAccDefCurr: AStr;
  pAccClassif: AStr;
  pAccType: AStr;
  // ---
  pBalanceLogLineNr: AStr; // bilansirea loogiline nr
  pBalanceGrpName: AStr; // bilansirea nimi
  pBalanceFormId: integer;
  pBalanceGrpNameId: integer;

  pIncStatementLogLineNr: AStr; // kasumiaruande loogiline nr
  pIncStatementGrpName: AStr; // kasumiaruande loogiline nr
  pIncStatementFormId: integer;
  pIncStatementGrpNameId: integer;
  // ridade numbrid
  pBalanceLNr: integer;
  pIncsLNr: integer;

  pDataItem: TAccPreDefDataHelperClass;
  pAccTypeListIndx: integer;
  pAccClsListIndx: integer;
  pLineNr: integer;
  pItemIndx: integer;
  pExtAccPlan: boolean; // seal sees bilansiread jne jne

  pBufferedBalLines: TAStrList;
  pBufferedIncsLines: TAStrList;

begin

  try
    pBufferedBalLines := TAStrList.Create;
    pBufferedIncsLines := TAStrList.Create;

    pBalanceLNr := 0;
    pIncsLNr := 0;


    // GetAppConfigDirUTF8
    // vaatame, kas konf fail üldse olemas

    pExtAccPlan := True; // tulevikus; otsin faile, kui on defaultaccountplan_ext.txt siis võtan laiendatud plaani !
    // ----------------------------------------------------------------------

    // 09.05.2011 Ingmar; ka faili tohib ette anda
    if povrFilename = '' then // faili pole määratud, siis kasutame defaultaccountplan.txt faili
      pAccListFile := getAppPath + CDefFilename
    else
      pAccListFile := pOvrFilename;

    // ----------------------------------------------------------------------

    if SysUtils.FileExists(pAccListFile) then
      try
        try
          pBuffer := TAStrList.Create;
          pDefAccType := TAStrList.Create;
          pDefAccType.CaseSensitive := False;

          pDefAccCls := TAStrList.Create;
          pDefAccCls.CaseSensitive := False;



          // --- süsteemis peavad need konto tüübid ja klassifikaatorid olema defineeritud !!!!!!!!!!!!!!!!!!!!!!
          with tempQry, SQL do
            try
              Close;
              Clear;
              add(estbk_sqlcollection._CSQLAccountTypes2);
              Open;
              First;
              // --
              while not EOF do
              begin
                pDefAccType.addObject(FieldByName('accname').AsString, TObject(cardinal(FieldByName('id').AsInteger)));
                Next;
              end;


              Close;
              Clear;
              add(estbk_sqlcollection._CSQLAccountCls2);
              Open;
              // --
              while not EOF do
              begin
                pDefAccCls.addObject(FieldByName('accclsname').AsString, TObject(cardinal(FieldByName('id').AsInteger)));
                Next;
              end;



              // 02.03.2011 Ingmar
              pBalanceFormId := 0;
              pIncStatementFormId := 0;

              Close;
              Clear;
              add(estbk_sqlcollection._CSQLGetRepFormId);
              parambyname('company_id').AsInteger := compId;
              parambyname('form_type').AsString := estbk_types.CFormTypeAsBalance;
              Open;
              pBalanceFormId := FieldByName('id').AsInteger;



              Close;
              parambyname('company_id').AsInteger := compId;
              parambyname('form_type').AsString := estbk_types.CFormTypeAsIncStatement;
              Open;
              pIncStatementFormId := FieldByName('id').AsInteger;

            finally
              Close;
              Clear;
            end;



          // --
          with tempQry, SQL do
          begin
            // et saaks kohe vormi vaikimisi read ära kirjutada !
            Close;
            Clear;
            add(estbk_sqlcollection._CSQLInsertRepFormLines);
            parambyname('id').AsInteger := 0;
            parambyname('formd_id').AsInteger := 0;
            parambyname('parent_id').AsInteger := 0;
            parambyname('line_descr').AsString := '';
            parambyname('row_nr').AsInteger := 0;
            parambyname('row_id').AsString := '';
            parambyname('log_nr').AsString := '';


            parambyname('baserecord_id').AsInteger := 0;
            parambyname('rec_changed').AsDateTime := now;
            parambyname('rec_changedby').AsInteger := 0;
            parambyname('rec_addedby').AsInteger := 0;
          end;


          // ---
          assignfile(pTextFile, pAccListFile);
          reset(pTextFile);
          pLineNr := 0;


          while not EOF(pTextFile) do
          begin

            Inc(pLineNr);
            readln(pTextFile, pTextLine);


            // RIDA 1 alati päis !!!!  1 rida on versioon / 2 rida on lahtrite nimetus
            if (pLineNr > 2) and (pTextLine <> '') then
            begin
              // taseme jätame välja
              // Klass = üld, detailne, koond
              // Tüüp =  aktiva, passiva
              // [TASE] [KONTO NR] [VALUUTA ] [KONTO NIMETUS] [KLASS] [TÜÜP]
              pAccCode := copy(trim(getStrDataFromPos(CTab, 2, pTextLine)), 1, 20);
              pAccDefCurr := copy(trim(getStrDataFromPos(CTab, 3, pTextLine)), 1, 3);
              pAccName := copy(trim(getStrDataFromPos(CTab, 4, pTextLine)), 1, 230);
              pAccClassif := copy(trim(getStrDataFromPos(CTab, 5, pTextLine)), 1, 25);
              pAccType := copy(trim(getStrDataFromPos(CTab, 6, pTextLine)), 1, 25);


              // 02.03.2010 Ingmar
              pBalanceLogLineNr := '';
              pBalanceGrpName := '';
              pIncStatementLogLineNr := '';
              pIncStatementGrpName := '';
              pBalanceGrpNameId := 0;
              pIncStatementGrpNameId := 0;



              // teeb ka automaatselt bilansiread ja eeldefineeritud kasumiaruande !
              if pExtAccPlan then
              begin
                pBalanceLogLineNr := copy(trim(getStrDataFromPos(CTab, 7, pTextLine)), 1, 20);
                pBalanceGrpName := copy(trim(getStrDataFromPos(CTab, 8, pTextLine)), 1, 45);


                // lisame siis bilansirea ära andmebaasi !
                pItemIndx := pBufferedBalLines.IndexOf(pBalanceGrpName);
                if (pBalanceGrpName <> '') and (pItemIndx = -1) then
                  with tempQry, SQL do
                  begin
                    Inc(pBalanceLNr);


                    pBalanceGrpNameId := admDatamodule.qryFormLinesSeq.GetNextValue;
                    parambyname('id').AsInteger := pBalanceGrpNameId;
                    parambyname('formd_id').AsInteger := pBalanceFormId;
                    parambyname('row_nr').AsInteger := pBalanceLNr;
                    parambyname('row_id').AsString := '$' + IntToStr(pBalanceLNr);
                    parambyname('log_nr').AsString := pBalanceLogLineNr;
                    parambyname('baserecord_id').AsInteger := pBalanceGrpNameId;
                    parambyname('line_descr').AsString := pBalanceGrpName;
                    execSQL;
                    // ---
                    pItemIndx := pBufferedBalLines.AddObject(pBalanceGrpName, TObject(PtrInt(pBalanceGrpNameId)));
                  end;


                if pItemIndx >= 0 then
                  pBalanceGrpNameId := PtrInt(pBufferedBalLines.Objects[pItemIndx]);


                pIncStatementLogLineNr := copy(trim(getStrDataFromPos(CTab, 9, pTextLine)), 1, 20);
                pIncStatementGrpName := copy(trim(getStrDataFromPos(CTab, 10, pTextLine)), 1, 45);
                pIncStatementGrpNameId := 0;




                pItemIndx := pBufferedIncsLines.IndexOf(pIncStatementGrpName);
                // lisame siis kasumirea ära andmebaasi !
                if (pIncStatementGrpName <> '') and (pItemIndx = -1) then
                  with tempQry, SQL do
                  begin
                    Inc(pIncsLNr);

                    pIncStatementGrpNameId := admDatamodule.qryFormLinesSeq.GetNextValue;
                    parambyname('id').AsInteger := pIncStatementGrpNameId;
                    parambyname('formd_id').AsInteger := pIncStatementFormId;
                    parambyname('row_nr').AsInteger := pIncsLNr;
                    parambyname('row_id').AsString := '$' + IntToStr(pIncsLNr);
                    parambyname('log_nr').AsString := pIncStatementLogLineNr;
                    parambyname('baserecord_id').AsInteger := pBalanceGrpNameId;
                    parambyname('line_descr').AsString := pIncStatementGrpName;
                    execSQL;
                    // ---
                    pItemIndx := pBufferedIncsLines.AddObject(pIncStatementGrpName, TObject(PtrInt(pIncStatementGrpNameId)));
                  end;


                if pItemIndx >= 0 then
                  pIncStatementGrpNameId := PtrInt(pBufferedIncsLines.Objects[pItemIndx]);
                // pBalanceGrpNameId
                // pIncStatementGrpNameId
                // (BufferedBalLines);
                // (pBufferedIncsLines);
              end;




              if pAccDefCurr = '' then
                pAccDefCurr := estbk_globvars.glob_baseCurrency;


              if (pAccCode = '') or (pAccName = '') or (pBuffer.indexOf(pAccCode) >= 0) then
                raise Exception.Create(estbk_strmsg.SEAccountFileIsNotValid);

              pAccTypeListIndx := pDefAccType.indexOf(pAccType);
              if (pAccTypeListIndx = -1) then
                raise Exception.createFmt(estbk_strmsg.SEAccountTypeUndef, [pAccType]);




              pAccClsListIndx := pDefAccCls.indexOf(pAccClassif);
              // peame seda klassifikaatorit tundma !
              if (pAccClassif <> '') and (pAccClsListIndx = -1) then
                raise Exception.createFmt(estbk_strmsg.SEAccountClassificatorUndef, [pAccClassif]);


              pDataItem := TAccPreDefDataHelperClass.Create;
              pDataItem.FAccDefCurr := pAccDefCurr;
              pDataItem.FAccName := pAccName;


              pDataItem.FAccTypeIndx := pAccTypeListIndx;
              pDataItem.FAccClsIndx := pAccClsListIndx;


              pDataItem.FBalanceLogNr := pBalanceLogLineNr;
              pDataItem.FBalanceLineId := pBalanceGrpNameId;

              pDataItem.FIncsLogNr := pIncStatementLogLineNr;
              pDataItem.FIncsLogNrLineId := pIncStatementGrpNameId;


              // ---
              pBuffer.AddObject(pAccCode, pDataItem);
            end;
          end;




          pBuffer.Sorted := True;
          // -- tore, kirjutame nüüd siis andmed andmebaasi
          for i := 0 to pBuffer.Count - 1 do
            with tempQry, SQL do
            begin

              Close;
              Clear;
              add(estbk_sqlcollection._CSQLInsertNewAcc);
              //paramByname('account_group_id').asInteger:=0;
              paramByname('account_coding').AsString := pBuffer.Strings[i];
              paramByname('account_name').AsString := TAccPreDefDataHelperClass(pBuffer.Objects[i]).FAccName;
              paramByname('company_id').AsInteger := compId;


              pAccTypeListIndx := TAccPreDefDataHelperClass(pBuffer.Objects[i]).FAccTypeIndx;
              paramByname('type_id').AsInteger := integer(pDefAccType.Objects[pAccTypeListIndx]);




              pAccClsListIndx := TAccPreDefDataHelperClass(pBuffer.Objects[i]).FAccClsIndx;
              if pAccClsListIndx < 0 then
                paramByname('typecls_id').AsInteger := 0
              else
                paramByname('typecls_id').AsInteger := integer(pDefAccCls.Objects[pAccClsListIndx]);

              // 02.03.2011 Ingmar
              paramByname('balance_rep_line_id').AsInteger := TAccPreDefDataHelperClass(pBuffer.Objects[i]).FBalanceLineId;
              paramByname('incstat_rep_line_id').AsInteger := TAccPreDefDataHelperClass(pBuffer.Objects[i]).FIncsLogNrLineId;



              paramByname('default_currency').AsString := TAccPreDefDataHelperClass(pBuffer.Objects[i]).FAccDefCurr;
              paramByname('init_balance').AsFloat := 0;
              paramByname('parent_id').AsInteger := 0; // hetkel veel ei toeta !
              paramByname('rec_changed').AsDateTime := now;
              paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
              execSQL;
            end;



          // --------------------------------------------------------------
          Dialogs.ShowMessage(estbk_strmsg.SConfOK);

        finally

          for i := 0 to pBuffer.Count - 1 do
            if assigned(pBuffer.objects[i]) then
              TAccPreDefDataHelperClass(pBuffer.objects[i]).Free;

          // ---
          FreeAndNil(pBuffer);
          FreeAndNil(pDefAccType);
          FreeAndNil(pDefAccCls);

          closefile(pTextFile);
        end;
        // ---
      except
        on e: Exception do
          Dialogs.messageDlg(format(estbk_strmsg.SEIncfCantReadFile, [pAccListFile, e.message]) + '  R[' +
            IntToStr(pLineNr) + ']', mtError, [mbOK], 0);
      end
    else
      Dialogs.MessageDlg(format(estbk_strmsg.SEFileNotFound, [pAccListfile]), mtError, [mbOK], 0);

  finally
    FreeAndNil(pBufferedBalLines);
    FreeAndNil(pBufferedIncsLines);
  end;
end;

procedure Tform_admin.updateCompLogo(const pCompId: integer);
var
  pBase64: AStr;
  pLogoRecID: integer;
  pMemStream: TMemoryStream;
  pReadStream: TStringStream;
  pBaseEnc: TBase64EncodingStream;
begin

  with tempQry, SQL do
    try
      pBaseEnc := nil;
      pMemStream := nil;
      pReadStream := nil;
      // --
      Close;
      Clear;
      add(estbk_sqlcollection._SQLConfSelectLogo);
      paramByname('company_id').AsInteger := pCompId;
      Open;
      pLogoRecID := FieldByName('id').AsInteger;
      // reset ?
      if compLogoPct.Picture.Width < 1 then
      begin
        Close;
        Clear;
        add(estbk_sqlcollection._SQLUpdateLogo);
        paramByname('val_blob').AsString := '';
        paramByname('var_val').AsString := '';
        paramByname('company_id').AsInteger := pCompId;
        execSQL;
      end
      else
      begin
        pMemStream := TMemoryStream.Create;
        pReadStream := TStringStream.Create('');
        pBaseEnc := TBase64EncodingStream.Create(pReadStream);
        compLogoPct.Picture.SaveToStream(pMemStream);
        pMemStream.Seek(0, 0);
        pBaseEnc.CopyFrom(pMemStream, pMemStream.Size);

        pReadStream.Seek(0, 0);
        pBase64 := pReadStream.DataString;
        Close;
        Clear;
        if pLogoRecID = 0 then
          add(estbk_sqlcollection._SQLInsertLogo)
        else
          add(estbk_sqlcollection._SQLUpdateLogo);
        paramByname('val_blob').AsString := pBase64;
        paramByname('var_val').AsString := ''; // tulevikus failinimi ?!?
        paramByname('company_id').AsInteger := pCompId;
        execSQL;
      end;
      // ---
    finally
      if assigned(pBaseEnc) then
        FreeAndNil(pBaseEnc);

      if assigned(pMemStream) then
        FreeAndNil(pMemStream);

      if assigned(pReadStream) then
        FreeAndNil(pReadStream);

      // ---
      Close;
      Clear;
    end;
end;

procedure Tform_admin.btnSaveClick(Sender: TObject);
var
  pClientId: integer;
begin
  // ---
  btnCancel.Enabled := True;

  // ---------
  // paneme osa parameetrid enne posti lõppu paika
  if (length(trim(admCompListQry.FieldByName('name').AsString)) < 2) then
  begin
    messageDlg(SEMissingCompanyName, mtError, [mbOK], 0);

    self.pageCompControl.ActivePage := tabCompContact;
    dbEdtCompname.SetFocus;
    exit;
  end;

  if (self.frameCompCAddr.cityId < 1) and (self.frameCompCAddr.streetId < 1) then
  begin
    messageDlg(SEAddrIncomplete, mtError, [mbOK], 0);

    self.pageCompControl.ActivePage := tabCompContact;
    self.frameCompCAddr.comboCity.SetFocus;
    exit;
  end;




  with estbk_datamodule.admDatamodule do
    try
      admConnection.StartTransaction;



      // ...okei paneme posti teele...
      // if (admWkrQuery.state in [dsEdit, dsInsert]) then
      //    admWkrQuery.Post;
      self.FIsNewComp := admCompListQry.FieldByName('id').AsInteger < 1;

      // ----
      admCompListQry.ApplyUpdates;
      // ---


      // 19.09.2009 Ingmar numeratsioon siis per firma, aga ku meil 100 firmat siis ju probleem ?!?
      // if admCompListQry.state=dsInsert then peale commitit staatus kaob :(
      if FIsNewComp then
        try


          // omistame numeraatori template
          admTempQuery.ParamCheck := True;
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.Add(estbk_sqlcollection._SQLCloneDefaultNumerator);
          // -----
          admTempQuery.ParamByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          admTempQuery.ExecSQL;



          // omistame käibemaksude template
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.Add(estbk_sqlcollection._SQLCloneVATValue);
          // -----
          admTempQuery.ParamByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          admTempQuery.ExecSQL;



          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          // 10.04.2011 Ingmar; teeme alati kliendi nimega ERAISIK !
          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.Add(estbk_sqlcollection._SQLInsertZClient);


          // -----
          pClientId := qryClientSeq.GetNextValue;
          admTempQuery.ParamByname('id').AsInteger := pClientId;
          admTempQuery.ParamByname('client_code').AsString := '1';

          admTempQuery.ParamByname('lastname').AsString := estbk_strmsg.SCPrivatePerson;
          admTempQuery.ParamByname('flags').AsInteger := estbk_types.CClient_defaultClientFlag;
          admTempQuery.ParamByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          admTempQuery.ExecSQL;



          // peame ka numeraatoritest ühe koha võrra edasi lükkama
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.Add(estbk_sqlcollection._SQLUpdateDefaultNumerator);
          admTempQuery.ParamByname('cr_num_val').AsInteger := 1;
          admTempQuery.ParamByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          admTempQuery.ParamByName('cr_num_type').AsString := estbk_types.TNumeratorTypesSDescr[CClientId_idef];
          admTempQuery.ExecSQL;




          // 07.04.2011 Ingmar
          // kanname pangad üle firmale
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.Add(estbk_sqlcollection._SQLCloneBanks);
          // -----
          admTempQuery.ParamByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          admTempQuery.ExecSQL;




          // ETTEMAKS !
          // ERITÜÜBID !
          // 11.09.2010 Ingmar; lisame ka "special" artikli tüübid ntx ettemaks
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.Add(estbk_sqlcollection._CSQLInsertSpecialArticles);
          admTempQuery.ParamByname('code').AsString := estbk_types.CArtSpTypeCode_Prepayment;
          admTempQuery.ParamByname('code2').AsString := estbk_types.CArtSpTypeCode_Prepayment;
          admTempQuery.ParamByname('name').AsString := estbk_strmsg.SArtSpLName_Prepayment;
          admTempQuery.ParamByname('unit').AsString := '';
          admTempQuery.ParamByname('dim_h').AsInteger := 0;
          admTempQuery.ParamByname('dim_l').AsInteger := 0;
          admTempQuery.ParamByname('dim_w').AsInteger := 0;
          admTempQuery.ParamByname('type_').AsString := estbk_types.CArtSpTypeCode_Prepayment;
          admTempQuery.ParamByname('vat_id').AsInteger := 0;
          admTempQuery.ParamByname('barcode_def_id').AsInteger := 0;
          admTempQuery.ParamByname('barcode').AsString := '';
          admTempQuery.ParamByname('cn8').AsString := '';
          admTempQuery.ParamByname('ean_code').AsString := '';
          admTempQuery.ParamByname('descr').AsString := '';
          admTempQuery.ParamByname('manufacturer').AsString := '';
          admTempQuery.ParamByname('url').AsString := '';
          admTempQuery.ParamByname('shelfnumber').AsString := '';
          admTempQuery.ParamByname('purchase_account_id').AsInteger := 0;
          admTempQuery.ParamByname('sale_account_id').AsInteger := 0;
          admTempQuery.ParamByname('expense_account_id').AsInteger := 0;
          admTempQuery.ParamByname('qty_flags').AsInteger := 0;
          admTempQuery.ParamByname('qty_minlevel').AsInteger := 0;
          admTempQuery.ParamByname('qty_maxlevel').AsInteger := 0;
          admTempQuery.ParamByname('price_calc_meth').AsString := 'F'; // ...FIFO
          admTempQuery.ParamByname('special_type_flags').AsInteger := estbk_types.CArtSpTypeCode_PrepaymentFlag;
          admTempQuery.ParamByname('status').AsString := '';
          admTempQuery.ParamByname('archive_rec_id').AsInteger := 0;
          admTempQuery.ParamByname('rec_changed').AsDateTime := now;
          admTempQuery.ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          admTempQuery.ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          admTempQuery.ParamByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          admTempQuery.ExecSQL;


          // VIIVIS !
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.Add(estbk_sqlcollection._CSQLInsertSpecialArticles);
          admTempQuery.ParamByname('code').AsString := estbk_types.CArtSpTypeCode_Fine;
          admTempQuery.ParamByname('code2').AsString := estbk_types.CArtSpTypeCode_Fine;
          admTempQuery.ParamByname('name').AsString := estbk_strmsg.SArtSpLName_Fine;

          admTempQuery.ParamByname('unit').AsString := '';
          admTempQuery.ParamByname('dim_h').AsInteger := 0;
          admTempQuery.ParamByname('dim_l').AsInteger := 0;
          admTempQuery.ParamByname('dim_w').AsInteger := 0;
          admTempQuery.ParamByname('type_').AsString := estbk_types.CArtSpTypeCode_Fine;
          admTempQuery.ParamByname('vat_id').AsInteger := 0;
          admTempQuery.ParamByname('barcode_def_id').AsInteger := 0;
          admTempQuery.ParamByname('barcode').AsString := '';
          admTempQuery.ParamByname('cn8').AsString := '';
          admTempQuery.ParamByname('ean_code').AsString := '';
          admTempQuery.ParamByname('descr').AsString := '';
          admTempQuery.ParamByname('manufacturer').AsString := '';
          admTempQuery.ParamByname('url').AsString := '';
          admTempQuery.ParamByname('shelfnumber').AsString := '';
          admTempQuery.ParamByname('purchase_account_id').AsInteger := 0;
          admTempQuery.ParamByname('sale_account_id').AsInteger := 0;
          admTempQuery.ParamByname('expense_account_id').AsInteger := 0;
          admTempQuery.ParamByname('qty_flags').AsInteger := 0;
          admTempQuery.ParamByname('qty_minlevel').AsInteger := 0;
          admTempQuery.ParamByname('qty_maxlevel').AsInteger := 0;
          admTempQuery.ParamByname('price_calc_meth').AsString := 'F'; // ...FIFO

          admTempQuery.ParamByname('special_type_flags').AsInteger := estbk_types.CArtSpTypeCode_FineFlag;
          admTempQuery.ParamByname('status').AsString := '';
          admTempQuery.ParamByname('archive_rec_id').AsInteger := 0;
          admTempQuery.ParamByname('rec_changed').AsDateTime := now;
          admTempQuery.ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          admTempQuery.ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          admTempQuery.ParamByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          admTempQuery.ExecSQL;



          // TODO
          // 23.02.2011 Ingmar
          // VAIKIMISI VORMID; üldiselt viia XML faili, et tulevikus saaks ka Soomes ja Rootsis rakendada !
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.Add(estbk_sqlcollection._SQLInsertNewFormdEntry2);
          // vorm: käibemaks
          admTempQuery.ParamByname('form_name').AsString := estbk_strmsg.SCFTypeVatDecl;
          admTempQuery.ParamByname('form_type').AsString := estbk_types.CFormTypeAsVatDecl; // käibemaksudeklaratsioon
          admTempQuery.ParamByname('descr').AsString := '';
          admTempQuery.ParamByname('url').AsString := '';

          admTempQuery.ParamByname('valid_from').AsDateTime := now;
          admTempQuery.ParamByname('valid_until').Value := null;
          admTempQuery.ParamByname('rec_changed').AsDateTime := now;
          admTempQuery.ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          admTempQuery.ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          admTempQuery.ParamByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          admTempQuery.ExecSQL;


          // vorm: tulumaks ja sotsmaks
          admTempQuery.ParamByname('form_name').AsString := estbk_strmsg.SCFTypeTSD;
          // 06.03.2011 Ingmar arghhhh ... panin ka sellele vormile nimeks käibemaksu deklaratsioon !!
          admTempQuery.ParamByname('form_type').AsString := estbk_types.CFormTypeAsTSD;
          admTempQuery.ExecSQL;


          // vorm: bilanss
          admTempQuery.ParamByname('form_name').AsString := estbk_strmsg.SCFTypeBalance;
          admTempQuery.ParamByname('form_type').AsString := estbk_types.CFormTypeAsBalance;
          admTempQuery.ExecSQL;


          // vorm: kasumiaruanne
          admTempQuery.ParamByname('form_name').AsString := estbk_strmsg.SCFTypeIncStatement;
          admTempQuery.ParamByname('form_type').AsString := estbk_types.CFormTypeAsIncStatement;
          admTempQuery.ExecSQL;

          // vorm: aastaaruanne
          admTempQuery.ParamByname('form_name').AsString := estbk_strmsg.SCFTypeAnnualReport;
          admTempQuery.ParamByname('form_type').AsString := estbk_types.CFormTypeAsAnnualReport;
          admTempQuery.ExecSQL;


        finally
          // --
          admTempQuery.Close; // pole vaja, aga "ilus"...
          admTempQuery.SQL.Clear;
        end
      else
      begin
        // -------------------------------------------------------------------
        // salvestame ka majandusaasta muudatused...eeldusel, et nad olemas...
        // -------------------------------------------------------------------

        try
          frameAccPeriods1.triggerSaveEvent;
        except
          on e: eabort do
          begin
            self.pageCompControl.ActivePage := tabPageAccPeriod;
            raise;
          end;
        end;




        // -------------------------------------------------------------------
        // salvestame käibemaksu muudatused
        // -------------------------------------------------------------------

        try
          self.frameVATMgr.triggerSaveEvent;




        except
          on e: eabort do
          begin
            self.pageCompControl.ActivePage := tabVat;
            raise;
          end;
        end;
        // ---
      end;

      // -- save logo
      self.updateCompLogo(admCompListQry.FieldByName('id').AsInteger);

      // ---------- roheline tuli...
      admConnection.Commit;
      admCompListQry.CommitUpdates;



      self.FCompDataNotSaved := False;
      self.tabPageAccPeriod.TabVisible := True;
      self.tabVat.TabVisible := True;
      self.tabLogo.TabVisible := True;

      // ---
      frameAccPeriods1.companyId := admCompListQry.FieldByName('id').AsInteger;


      // viime kohe raamatupidamisperioodi avamisele
      if FIsNewComp then
      begin
        pageCompControl.ActivePage := tabPageAccPeriod;
        frameVATMgr.companyId := admCompListQry.FieldByName('id').AsInteger;
      end;




      // ----
      btnCancel.Enabled := False;
      btnSave.Enabled := False;
      btnNewItem.Enabled := True;




    except
      on e: Exception do
      begin
        if admConnection.InTransaction then
          try
            admConnection.Rollback;
            //admCompListQry.CancelUpdates;
          except
          end; // 24.08.2009 ingmar; ntx kui ühendus maha kukkunud või trigger teinud rollback kaoks originaalviga !!!



        if not (e is eabort) then
          messageDlg(format(SESaveFailed, [e.Message]), mtError, [mbOK], 0);
        // ---
        Exit;
      end;
    end;




  // ----------
  // 07.02.2010 Ingmar; uue firma puhul küsime, kas koostame vaikimisi kontoplaani !
  // OSAKONDADEGA seda mitte küsida !!!!
  if FIsNewComp and (Dialogs.messageDlg(estbk_strmsg.SConfCreatDefaultAccountPlan, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    self.addDefaultAccountingPlanToComp(admCompListQry.FieldByName('id').AsInteger);
    self.frameVATMgr.companyId := 0;
    self.frameVATMgr.companyId := admCompListQry.FieldByName('id').AsInteger;
  end;
  self.FIsNewComp := False;


  // 21.09.2011 Ingmar
  self.addCompanyListIntoSubMenu;

end;

// ----------------------------------------------------------------------------

procedure Tform_admin.createUserWithPermissions;
// revoke all on user from table;
// REVOKE ALL PRIVILEGES ON DATABASE estbk FROM buratiino;
// http://www.postgresql.org/docs/current/static/sql-grant.html#SQL-GRANT-DESCRIPTION-OBJECTS
// GRANT SELECT (col1), UPDATE (col1) ON mytable TO miriam_rw;

var
  FParamChkStatus: boolean;
  pPwd: AStr;

begin
  with estbk_datamodule.admDatamodule do
    try
      FParamChkStatus := admTempQuery.Paramcheck;
      admTempQuery.Paramcheck := True;


      // ----------------------------------------------
      // loob reaalse kasutaja andmebaasis
      admTempQuery.Close;
      admTempQuery.SQL.Clear;


      // 08.11.2009 Ingmar
      pPwd := estbk_utilities.passwordMixup(dbEdtWorkUsername.Text, trim(edEdtWrkPassword.Text));
      admTempQuery.SQL.add(estbk_dbcompability.sqlp._createUserSQL(dbEdtWorkUsername.Text, pPwd));
      admTempQuery.execSQL;


      // paneme kasutaja ka meie rolli
      admTempQuery.Close;
      admTempQuery.SQL.Clear;
      admTempQuery.SQL.add(format(estbk_sqlcollection._CSQLGrantRole, [estbk_types.CProjectRolename, dbEdtWorkUsername.Text]));
      admTempQuery.execSQL;

      // ----
    finally
      admTempQuery.Close;
      admTempQuery.SQL.Clear;
      admTempQuery.ParamCheck := FParamChkStatus;
    end;
end;

procedure Tform_admin.btnSaveWorkerClick(Sender: TObject);
var
  FParamChkStatus: boolean;
  FNewUser: boolean;
  i, j, k, usrId: integer;
  pPassword: AStr;
begin
  // ---
  FNewUser := (admWorkerMgmQry.state = dsInsert);
  // paneme osa parameetrid enne posti lõppu paika
  if (length(trim(admWorkerMgmQry.FieldByName('loginname').AsString)) < 4) then
  begin
    messageDlg(SEUsernameIncorrect, mtError, [mbOK], 0);
    pageCtrlUserMgr.ActivePage := tabOverAllDescr;
    dbEdtWorkUsername.SetFocus;
    Exit;
  end;




  // --------
  with estbk_datamodule.admDatamodule do
    try
      FParamChkStatus := admTempQuery.Paramcheck;
      admTempQuery.Paramcheck := True;
      try
        admConnection.StartTransaction;
        // ---------------------------------------------------------------------
        // -- kontrollime kas seda kasutajanime juba pole
        if FNewUser then
        begin
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          admTempQuery.SQL.add(estbk_sqlcollection._SQLSelectUsrByLName);
          admTempQuery.ParamByName('loginname').AsString := admWorkerMgmQry.FieldByName('loginname').AsString; // !!!
          // --
          admTempQuery.Open;

          // asi selles, kui edit ja admin muudab kasutajanime sarnaseks, mis juba on, siis meil probleem
          if ((admWorkerMgmQry.state = dsEdit) and (admWorkerMgmQry.FieldByName('id').AsInteger <>
            admTempQuery.FieldByName('id').AsInteger)) or ((admWorkerMgmQry.state = dsInsert) and (not admTempQuery.EOF)) then
            //((admWorkerMgmQry.state = dsInsert) and (not admWorkerMgmQry.EOF)) then
          begin
            messageDlg(SEUsernameTaken, mtError, [mbOK], 0);
            pageCtrlUserMgr.ActivePage := tabOverAllDescr;
            dbEdtWorkUsername.SetFocus;
            Abort; //exit; et rollbacki saaksime
          end;

          // parool tühi  või muudmoodi jama
          if length(trim(edEdtWrkPassword.Text)) < 3 then
          begin
            messageDlg(SEInvalidPassword, mtError, [mbOK], 0);
            pageCtrlUserMgr.ActivePage := tabOverAllDescr;
            edEdtWrkPassword.SetFocus;
            Abort; //exit;
          end;
          // LOOME reaalse postgre kasutaja
          self.createUserWithPermissions;
        end
        else if (Trim(edEdtWrkPassword.Text) <> '') then
        begin  // kui parooli väli täidetud, järelikult soovitakse selle muutust
          admTempQuery.Close;
          admTempQuery.SQL.Clear;
          // 08.11.2009 IngmarM tehakse hash, sellega otse baasi ei saa logida !!
          pPassword := estbk_utilities.passwordMixup(admWorkerMgmQry.FieldByName('loginname').AsString, trim(edEdtWrkPassword.Text));
          admTempQuery.SQL.add(estbk_sqlcollection._CSQLChangeUserPassword(admWorkerMgmQry.FieldByName('loginname').AsString, pPassword));
          admTempQuery.execSQL;
        end;

        // ---------------------------------------------------------------------
        admWorkerMgmQry.ApplyUpdates;
        admWorkerMgmQry.CommitUpdates;
        // ---

        // [FIRMAD]
        for i := 0 to self.chkLstBoxAllowedCmp.Items.Count - 1 do
          if assigned(self.chkLstBoxAllowedCmp.Items.Objects[i]) then
            case FNewUser of // case parandab koodi loetavust
              True:
                if self.chkLstBoxAllowedCmp.Checked[i] then
                begin
                  admTempQuery.Close;
                  admTempQuery.SQL.Clear;
                  admTempQuery.SQL.add(estbk_sqlcollection._SQLUserCompAccListInsert);
                  // ---
                  usrId := admWorkerMgmQry.FieldByName('id').AsInteger;
                  admTempQuery.paramByName('user_id').AsInteger := usrId;
                  admTempQuery.paramByName('company_id').AsInteger := TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemId;
                  admTempQuery.ExecSQL;

                  TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemExists := True;
                end;

              False:
                // kontrollime muudatusi...
                // ...kasutajalt võeti firma ära...
                if not self.chkLstBoxAllowedCmp.Checked[i] and TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemExists then
                begin
                  admTempQuery.Close;
                  admTempQuery.SQL.Clear;
                  admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserCompAccListDelete);
                  usrId := admWorkerMgmQry.FieldByName('id').AsInteger;
                  admTempQuery.paramByName('user_id').AsInteger := usrId;
                  admTempQuery.paramByName('company_id').AsInteger := TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemId;
                  admTempQuery.ExecSQL;
                  TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemExists := False;
                end
                else if self.chkLstBoxAllowedCmp.Checked[i] and not TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemExists then
                  // kasutajale lisati firma;
                begin
                  admTempQuery.Close;
                  admTempQuery.SQL.Clear;
                  admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserCompAccListInsert);
                  // ---
                  usrId := admWorkerMgmQry.FieldByName('id').AsInteger;
                  admTempQuery.paramByName('user_id').AsInteger := usrId;
                  admTempQuery.paramByName('company_id').AsInteger := TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemId;
                  admTempQuery.ExecSQL;
                  // ----
                  TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemExists := True;
                end; // else midagi veel tulevikus...
            end;

        // [ÕIGUSED]
        // ---------------------------
        // --- okei...nüüd paneme õigused paika

        case FNewUser of // case parandab koodi loetavust
          True:
          begin
            // esmalt paneme rollid paika; uue kasutajaga asjad suht lihtsad...
            for j := 0 to chkLstBoxUserRoles.items.Count - 1 do
              if chkLstBoxUserRoles.Checked[j] then
              begin
                admTempQuery.Close;
                admTempQuery.SQL.Clear;
                admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserRoleInsert);

                // ----
                admTempQuery.parambyname('role_id').AsInteger := TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemid;
                usrId := admWorkerMgmQry.FieldByName('id').AsInteger;
                admTempQuery.parambyname('user_id').AsInteger := usrId;
                admTempQuery.execSQL;

                // ---- me peame ka siin kontrollima üle välistavad õigused...; st rollist on mingi õigus välja jäetud
                // kontrollime rolli ja üldist õiguste nimekirja; kui üldises pole õigust selekteeritud, siis on ta rollist eemaldatud
                admBufferedRolePermRelations.Filtered := False;
                admBufferedRolePermRelations.Filter := format('role_id=%d', [TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemid]);
                admBufferedRolePermRelations.Filtered := True;
                admBufferedRolePermRelations.First;
                // ---

                while not admBufferedRolePermRelations.EOF do
                begin
                  // kui õigus eemaldatud listist; paneme tabelisse markeri püsti ! D tähega
                  for  k := 0 to chkLstBoxPermission.items.Count - 1 do
                    if not chkLstBoxPermission.Checked[k] and not TPermissionHelper(
                      chkLstBoxPermission.items.objects[k]).itemExists and (TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemid =
                      admBufferedRolePermRelations.FieldByName('permission_descr_id').AsInteger) then
                    begin
                      admTempQuery.Close;
                      admTempQuery.SQL.Clear;
                      admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserPermissionsInsert);

                      usrId := admWorkerMgmQry.FieldByName('id').AsInteger;
                      admTempQuery.parambyname('user_id').AsInteger := usrId;
                      admTempQuery.parambyname('permission_descr_id').AsInteger := TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemid;
                      admTempQuery.parambyname('descriptors').AsString := estbk_types.CExcludePermission;
                      admTempQuery.execSQL;

                      TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemExists := True;
                    end;

                  admBufferedRolePermRelations.Next;
                end;
              end;



            // BUG: 13.09.2009 Ingmar; uuele kasutajale omistati rollid õigesti, aga eraldi õigusi mitte !!!
            // rollid paigas, vaatame kas mõni eriõigus ka; ntx rolliväline
            for i := 0 to chkLstBoxPermission.items.Count - 1 do
              if assigned(self.chkLstBoxPermission.Items.Objects[i]) then
                if chkLstBoxPermission.Checked[i] and not TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemExists then
                begin
                  // lisame...
                  admTempQuery.Close;
                  admTempQuery.SQL.Clear;
                  admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserPermissionsInsert);
                  admTempQuery.parambyname('user_id').AsInteger := admWorkerMgmQry.FieldByName('id').AsInteger;
                  admTempQuery.parambyname('permission_descr_id').AsInteger := TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemid;
                  admTempQuery.parambyname('descriptors').AsString := '';
                  admTempQuery.execSQL;

                  TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemExists := True;
                end;
          end; // CASE TRUE

          False:
          begin // nüüd läheb alles huvitavaks; vana kasutaja õiguse/rollide haldus !!!!!!!!!!!
            // alustame rollidest...
            for j := 0 to chkLstBoxUserRoles.items.Count - 1 do
            begin
              // ...täitsa uus roll lisatud...
              if chkLstBoxUserRoles.Checked[j] and not TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemExists then
              begin
                admTempQuery.Close;
                admTempQuery.SQL.Clear;
                admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserRoleInsert);
                admTempQuery.parambyname('role_id').AsInteger := TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemid;
                admTempQuery.parambyname('user_id').AsInteger := admWorkerMgmQry.FieldByName('id').AsInteger;
                admTempQuery.execSQL;

                TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemExists := True;
              end
              else if not chkLstBoxUserRoles.Checked[j] and TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemExists then
                // ...kustutame rolli
              begin
                admTempQuery.Close;
                admTempQuery.SQL.Clear;
                admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserRoleDelete);
                admTempQuery.parambyname('role_id').AsInteger := TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemid;
                admTempQuery.parambyname('user_id').AsInteger := admWorkerMgmQry.FieldByName('id').AsInteger;
                admTempQuery.execSQL;
                TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemExists := False;
              end;

              // ...aga aga peame jälle vaatama seda välistavat õigust
              admBufferedRolePermRelations.Filtered := False;
              admBufferedRolePermRelations.Filter := format('role_id=%d', [TPermissionHelper(chkLstBoxUserRoles.items.objects[j]).itemid]);
              admBufferedRolePermRelations.Filtered := True;

              admBufferedRolePermRelations.First;
              while not admBufferedRolePermRelations.EOF do
              begin
                // kui õigus eemaldatud listist; paneme tabelisse markeri püsti ! D tähega
                for k := 0 to chkLstBoxPermission.items.Count - 1 do
                begin

                  // case 1; ehk õigus on tagasi rolli toodud...võeti rollist ära;
                  // adminn sai aru, et oli ebaõiglane kasutaja suhtes ja taastas
                  // siis peame selle D tunnusega permission kirje eemaldama
                  if (TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemid = admBufferedRolePermRelations.FieldByName(
                    'permission_descr_id').AsInteger) then
                    if chkLstBoxPermission.Checked[k] and not TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemExists then
                    begin
                      admTempQuery.Close;
                      admTempQuery.SQL.Clear;
                      admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserPermissionsDeleteExc);
                      admTempQuery.parambyname('user_id').AsInteger := admWorkerMgmQry.FieldByName('id').AsInteger;
                      admTempQuery.parambyname('permission_descr_id').AsInteger := TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemid;

                      admTempQuery.execSQL;
                      //TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemExists:=true;

                    end
                    else if not chkLstBoxPermission.Checked[k] and // nö vana hea välistav õigus.......
                      not TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemExists and
                      // et topelt ei tuleks, kui mitmes rollis sama õigus !
                      chkLstBoxUserRoles.Checked[j] then // AGA roll peab ka eksisteerima olema
                    begin
                      admTempQuery.Close;
                      admTempQuery.SQL.Clear;
                      admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserPermissionsInsert);
                      admTempQuery.parambyname('user_id').AsInteger := admWorkerMgmQry.FieldByName('id').AsInteger;
                      admTempQuery.parambyname('permission_descr_id').AsInteger := TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemid;
                      admTempQuery.parambyname('descriptors').AsString := estbk_types.CExcludePermission; // D tunnus !!!
                      admTempQuery.execSQL;

                      TPermissionHelper(chkLstBoxPermission.items.objects[k]).itemExists := True;
                    end;
                end;

                admBufferedRolePermRelations.Next;
              end;
            end;

            // ---------
            // nii, aga nüüd üldiste "rolli väliste" õiguste juurde !!!
            // element puudub, lisame...

            for i := 0 to chkLstBoxPermission.items.Count - 1 do
              if assigned(self.chkLstBoxPermission.Items.Objects[i]) then
                if chkLstBoxPermission.Checked[i] and not TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemExists then
                begin
                  // ----------
                  // proovime ka välistava õiguse kustutada...võib eksisteerida
                  admTempQuery.Close;
                  admTempQuery.SQL.Clear;
                  admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserPermissionsDeleteExc);
                  admTempQuery.parambyname('user_id').AsInteger := admWorkerMgmQry.FieldByName('id').AsInteger;
                  admTempQuery.parambyname('permission_descr_id').AsInteger := TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemid;
                  admTempQuery.execSQL;

                  // lisame...
                  admTempQuery.Close;
                  admTempQuery.SQL.Clear;
                  admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserPermissionsInsert);
                  admTempQuery.parambyname('user_id').AsInteger := admWorkerMgmQry.FieldByName('id').AsInteger;
                  admTempQuery.parambyname('permission_descr_id').AsInteger := TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemid;
                  admTempQuery.parambyname('descriptors').AsString := '';
                  admTempQuery.execSQL;
                  TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemExists := True;
                end
                else if not chkLstBoxPermission.Checked[i] and // õigus eemaldati...
                  TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemExists and
                  TPermissionHelper(chkLstBoxPermission.items.objects[i]).userModified then
                begin
                  admTempQuery.Close;
                  admTempQuery.SQL.Clear;
                  admTempQuery.SQL.Add(estbk_sqlcollection._SQLUserPermissionsDelete);
                  admTempQuery.parambyname('user_id').AsInteger := admWorkerMgmQry.FieldByName('id').AsInteger;
                  admTempQuery.parambyname('permission_descr_id').AsInteger := TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemid;
                  admTempQuery.execSQL;
                end;
          end; // CASE FALSE
        end;


        // --------------------------------
        admConnection.Commit; // saadame kinnituse teele

        // --- lipp maha
        self.FWorkDataNotSaved := False;

        btnCancelWorkerEdit.Enabled := False;
        btnSaveWorker.Enabled := False;

        edEdtWrkPassword.Text := '';
        dbEdtWorkUsername.ReadOnly := True;
        dbEdtWorkUsername.ParentColor := True;


        // laeme andmed uuesti; et sync oleks
        self.createUserCompList(admWorkerMgmQry.FieldByName('id').AsInteger);
        self.createUserPermissionList(admWorkerMgmQry.FieldByName('id').AsInteger);

        // --------------------------------
        pageCtrlUserMgr.ActivePage := tabOverAllDescr;
        edEdtWrkPassword.SetFocus;

      except
        on e: Exception do
        begin
          if not (e is EAbort) then
          begin
            if admConnection.InTransaction then
              try
                admConnection.Rollback;
                //admWorkerMgmQry.CancelUpdates;
              except
              end;
            // -------
            messageDlg(format(SESaveFailed, [e.Message]), mtError, [mbOK], 0);
          end;
          // ----------
        end;
      end;


      // --------
    finally
      btnNewWorker.Enabled := True;

      admTempQuery.Paramcheck := FParamChkStatus;
      admTempQuery.Close;
      admTempQuery.SQL.Clear;
    end;
end;

procedure Tform_admin.btnWorkerMgrTabCloseClick(Sender: TObject);
begin
  btnMgnUsers.Enabled := True;

  // mälu pole prügikast, kus kõike hoida !
  //admCompListQry.Close;
  admWorkerMgmQry.Close;

  tabWorkerMgm.TabVisible := False;
end;




procedure Tform_admin.chkLstBoxAllowedCmpClick(Sender: TObject);
var
  cmp: TChecklistbox;
begin
  cmp := Sender as TChecklistbox;
  with admWorkerMgmQry do
    //if cmp.focused and not (admWorkerMgmQry.state in [dsEdit, dsInsert]) then
    if (self.activecontrol = cmp) and not (state in [dsEdit, dsInsert]) then
    begin
      Edit;
      // --------
      //estadmin_form.form_admin.btnCancelWorkerEdit.Enabled:=true;
      //estadmin_form.form_admin.btnSaveWorker.Enabled:=true;
    end;
end;

procedure Tform_admin.chkLstBoxPermissionItemClick(Sender: TObject; Index: integer);
var
  cmp: TChecklistbox;
  i, j: integer;
begin
  if self.FSkipEvent then
    exit;

  cmp := TChecklistbox(Sender);
  if index >= 0 then
    with estbk_datamodule.admDatamodule, admBufferedRolePermRelations do
      try
        self.FSkipEvent := True;
        // ..edit reziim peale
        //  ei tööta nagu peaks ?!?
        if (self.activecontrol = cmp) and not (admWorkerMgmQry.state in [dsEdit, dsInsert]) then
        begin
          admWorkerMgmQry.Edit;
          //estadmin_form.form_admin.btnCancelWorkerEdit.Enabled:=true;
          //estadmin_form.form_admin.btnSaveWorker.Enabled:=true;
        end;




        // kontrollime ka rollid üle, et ei tuleks excluded õigust !!!
        for i := 0 to chkLstBoxUserRoles.items.Count - 1 do
          if chkLstBoxUserRoles.Checked[i] then
          begin
            Filtered := False;
            Filter := format('role_id=%d and permission_descr_id=%d', [TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemid,
              TPermissionHelper(cmp.items.objects[i]).itemid]);
            Filtered := True;
            First;
            // ---
            // käime läbi kasutaja aktiivsed rollid, et küsida ikka üle, kas olete kindel selles, mida teete;
            // eriti, kui just õigused eemaldate
            if not cmp.Checked[index] then
              // ------
              if not EOF and (TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemExists) then
              begin
                if not simpleYesNoDialog(estbk_strmsg.SConfirm, format(estbk_strmsg.SPermissionRemovedFromSingleRole,
                  [chkLstBoxUserRoles.items.Strings[i]])) then
                begin
                  cmp.Checked[index] := True;
                  exit;
                end;
              end;

            // ---
            // BUG: 13.09.2009 Ingmar; no sellist indeksit pole ja kui kasutaja on õigusel klikkinud siis ongi user modified !!!
            //TPermissionHelper(cmp.items.objects[i]).userModified := True;
            // marker külge, et muudetud...


            // hetkel aktiivne!!! rolli valik teise tabi peal...peale siis tema õiguste listi "korrigeerima"...
            if chkLstBoxUserRoles.ItemIndex = i then
              for j := 0 to chkLstBoxUserRolePermListing.items.Count - 1 do
                if (TPermissionHelper(chkLstBoxUserRolePermListing.items.objects[j]).itemid =
                  TPermissionHelper(cmp.items.objects[index]).itemid) then
                begin
                  chkLstBoxUserRolePermListing.Checked[j] := cmp.Checked[index];
                  break;
                end;

            // ---
          end;

        // ---
        TPermissionHelper(cmp.items.objects[index]).userModified := True;

      finally
        self.FSkipEvent := False;
        filtered := False;
        filter := '';
      end;
  // --------
end;

// kontrollime, kas õigus juba seotud mõne aktiivse rolliga
function Tform_admin.isPermissionBoundWithActiveRole(const permId: integer; var roleId: integer; var roleName: AStr;
  const skipRoleWithId: integer = -1): boolean;
var
  i: integer;
begin
  roleId := 0;
  roleName := '';
  Result := False;
  with estbk_datamodule.admDatamodule.admBufferedRolePermRelations do
    try
      // ---
      for i := 0 to chkLstBoxUserRoles.items.Count - 1 do
        if chkLstBoxUserRoles.Checked[i] then
        begin

          // siis saame kontrollida, kas õigus sisaldub ka teistes rollides !!!
          if (skipRoleWithId = TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemid) then
            continue;

          Filtered := False;
          Filter := format('role_id=%d and permission_descr_id=%d',
            [TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemid, permId]);
          // locate('permission_descr_id',permId,[]); // mitte leidmist ei tohiks esineda; nö esimene roll, kus see õigus sees
          Filtered := True;
          First;

          if not EOF then
          begin
            roleId := TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemid;
            roleName := chkLstBoxUserRoles.items.Strings[i];
            Result := True;
            break;
          end;

        end;
    finally
      Filtered := False;
      Filter := '';
    end;
end;




procedure Tform_admin.chkLstBoxUserRolePermListingItemClick(Sender: TObject; Index: integer);
var
  i, roleindx: integer;
  cnt: integer;
  cmp: TChecklistbox;
  dummy: integer;
  pRoleName: AStr;
begin

  if self.FSkipEvent then
    exit;

  cmp := TChecklistbox(Sender);
  roleindx := chkLstBoxUserRoles.ItemIndex; // kas mingi roll ka reaalselt valitud !

  if Index >= 0 then
    try
      self.FSkipEvent := True;
      // ...kui roll on unchecked siis pole võimalik õigust eraldi chekkida !
      if not chkLstBoxUserRoles.Checked[roleindx] and (index >= 0) then
      begin
        cmp.Checked[Index] := False;
        exit;
      end;


      // rolli alt on kõik õigused maha keeratud, pole mingit pointi rolli üldse hoida !!!
      cnt := 0;
      for i := 0 to cmp.items.Count - 1 do
        if cmp.Checked[i] then
          Inc(cnt);

      if cnt = 0 then
        chkLstBoxUserRoles.Checked[roleindx] := False;
      // -------

      with estbk_datamodule.admDatamodule do
      begin

        // küsime üle ikka, kas tekitame välistava õiguse !
        if not cmp.Checked[index] then
          if not simpleYesNoDialog(estbk_strmsg.SConfirm, estbk_strmsg.SPermissionExcludeFromRole) then
          begin
            cmp.Checked[index] := not cmp.Checked[index];
            exit;
          end;


        // ...siseneme redigeerimis reziimi
        if (self.activecontrol = cmp) and admWorkerMgmQry.active and not (admWorkerMgmQry.state in [dsEdit, dsInsert]) then
        begin
          admWorkerMgmQry.Edit;
          //estadmin_form.form_admin.btnCancelWorkerEdit.Enabled:=true;
          //estadmin_form.form_admin.btnSaveWorker.Enabled:=true;
        end;


        // õigus võeti maha...vaatame, kas ta kusagil teistel rollides !!!!
        if not cmp.Checked[index] and assigned(cmp.items.objects[index]) and isPermissionBoundWithActiveRole(
          TPermissionHelper(cmp.items.objects[index]).itemId, dummy, pRolename, TPermissionHelper(
          chkLstBoxUserRoles.items.objects[roleindx]).itemid) then // ennast ei kontrolli

          if not simpleYesNoDialog(estbk_strmsg.SConfirm, format(estbk_strmsg.SPermissionRemovedFromSingleRole, [pRolename])) then
            try
              self.FSkipEvent := True;
              cmp.Checked[index] := not cmp.Checked[index];
              exit;
            finally
              self.FSkipEvent := False;
            end;




        // nii, peame ka üldises õigust loetelus märgistuse maha võtma !
        //if not cmb.checked[index] then
        for i := 0 to chkLstBoxPermission.Count - 1 do
          if TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemId = TPermissionHelper(cmp.items.objects[index]).itemId then
          begin
            chkLstBoxPermission.Checked[i] := cmp.Checked[index]; //false;
            TPermissionHelper(chkLstBoxPermission.items.objects[i]).userModified := True;
            break;
          end;

        // ---
      end;
    finally
      self.FSkipEvent := False;
    end;
end;

procedure Tform_admin.chkLstBoxUserRolesClickCheck(Sender: TObject);
begin

end;




procedure Tform_admin.chkLstBoxUserRolesItemClick(Sender: TObject; Index: integer);
var
  cmp: TChecklistBox;
  i, j: integer;
begin
  if self.FSkipEvent then
    exit;


  with estbk_datamodule.admDatamodule, admBufferedRolePermRelations do
    try
      // ..edit reziim peale
      cmp := TChecklistBox(Sender);


      self.FSkipEvent := True;
      chkLstBoxUserRolePermListing.Clear;
      // ---
      if cmp.ItemIndex >= 0 then // on ka teine variant täitsa võimalik !!
      begin

        // ----
        Filtered := False;
        Filter := 'role_id=' + IntToStr(TPermissionHelper(cmp.items.objects[index]).itemId);
        Filtered := True;
        First;

        while not EOF do
        begin

          // kasutame ära täispikka õiguste nimistut, et me ei peaks jälle uuesti laadima asju !!!
          // kammime õiguste nimistu läbi
          for i := 0 to chkLstBoxPermission.items.Count - 1 do
            if assigned(chkLstBoxPermission.items.objects[i]) and (TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemId =
              FieldByName('permission_descr_id').AsInteger) then
            begin
              j := chkLstBoxUserRolePermListing.items.addobject(chkLstBoxPermission.items.Strings[i], chkLstBoxPermission.items.objects[i]);
              chkLstBoxUserRolePermListing.Checked[j] := False;

              if not cmp.Checked[cmp.ItemIndex] then
                continue;

              // et poleks välistavat õigust peal...ja kasutaja pole tead muutnud...
              if not TPermissionHelper(chkLstBoxPermission.items.objects[i]).userModified then
                chkLstBoxPermission.Checked[i] := cmp.Checked[cmp.ItemIndex] and
                  (pos(estbk_types.CExcludePermission, TPermissionHelper(chkLstBoxPermission.items.objects[i]).descriptors) = 0);
              //else
              //  chkLstBoxPermission.checked[i]:=cmp.checked[index];  // üldine list on täielik peegeldus
              chkLstBoxUserRolePermListing.Checked[j] := chkLstBoxPermission.Checked[i];

              //if chkLstBoxPermission.checked[i] not TPermissionHelper(chkLstBoxPermission.items.objects[i]).userModified then
              // and chkLstBoxPermission.checked[i];
            end;
          // -----
          Next;
        end;
      end;
      // --
    finally
      Filtered := False;
      self.FSkipEvent := False;
    end;
end;



procedure Tform_admin.dbEdtCompnameKeyPress(Sender: TObject; var Key: char);
var
  wctrl: TWinControl;
begin
  if key = #13 then
  begin
    wctrl := TDbEdit(Sender) as TWinControl;
    //    wctrl.FindNextControl();
    SelectNext(wctrl, True, True);
    key := #0;
  end;
  // ---
end;

procedure Tform_admin.dbEdtWorkUsernameKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    key := #0;
  end
  else
  if not ((key in [#08, #09]) or (key in ['0'..'9']) or (upcase(key) in ['A'..'Z'])) then
    key := #0;
end;


procedure Tform_admin.edEdtWrkPasswordChange(Sender: TObject);
begin
  with admWorkerMgmQry do
    if TCombobox(Sender).focused and (TCombobox(Sender).Text <> '') and active and not (state in [dsEdit, dsInsert]) then
      Edit;
end;

procedure Tform_admin.btnCloseClick(Sender: TObject);
begin
  btnMngComp.Enabled := True;

  // mälu pole prügikast, kus kõike hoida !
  //admCompListQry.Close;

  frameCompCAddr.loadData := False;
  tabComp.TabVisible := False;
  // ...et kiusatust ei tekiks changeda midagi
  frameCompCAddr.comboCounty.OnChange := nil;
  frameCompCAddr.comboCity.OnChange := nil;
  frameCompCAddr.comboStreet.OnChange := nil;
end;

procedure Tform_admin.finalDataCleanup; // meil erinevaid tabe, puhverdatud andmeid
var
  i: integer;
begin
  for i := 0 to self.chkLstBoxAllowedCmp.Items.Count - 1 do
    if assigned(self.chkLstBoxAllowedCmp.Items.Objects[i]) then
      TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).Free;

  for i := 0 to chkLstBoxPermission.items.Count - 1 do
    if assigned(chkLstBoxPermission.items.Objects[i]) then
      TPermissionHelper(chkLstBoxPermission.items.Objects[i]).Free;

  for i := 0 to chkLstBoxUserRoles.items.Count - 1 do
    if assigned(chkLstBoxUserRoles.items.Objects[i]) then
      TPermissionHelper(chkLstBoxUserRoles.items.Objects[i]).Free;
end;


procedure Tform_admin.createUserCompList(const userID: integer; const reloadComp: boolean = False);
var
  FPtmp: TPermissionHelper;
  i: integer;
  paramChkState: boolean;
  peformRechk: boolean;
begin
  peformRechk := reloadComp or (self.chkLstBoxAllowedCmp.Items.Count = 0);
  if peformRechk then
  begin
    for i := 0 to self.chkLstBoxAllowedCmp.Items.Count - 1 do
      if assigned(self.chkLstBoxAllowedCmp.Items.Objects[i]) then
        TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).Free;
    chkLstBoxAllowedCmp.Items.Clear;
  end
  else
    for i := 0 to self.chkLstBoxAllowedCmp.Items.Count - 1 do
    begin
      self.chkLstBoxAllowedCmp.Checked[i] := False;
      TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemExists := False;
    end;
  // ----
  with  estbk_datamodule.admDatamodule.admTempQuery, SQL do
    try
      paramChkState := paramCheck;
      paramCheck := True;

      if peformRechk then
      begin
        Close;
        Clear;
        add(estbk_sqlcollection._SQLSelectAllCompanys);
        Open;
        First;

        while not EOF do
        begin
          FPtmp := TPermissionHelper.Create;
          FPtmp.itemId := FieldByName('id').AsInteger;
          // TObject(fieldbyname('id').Asinteger) lahendus POLE ilus !!! kuigi võiks kasutada lihtsamalt
          self.chkLstBoxAllowedCmp.Items.AddObject(
            FieldByName('name').AsString, FPtmp);
          Next;
        end;
      end; // ----

      // vaatame, millistes võrkudes antud kasutaja tohib tegutseda
      Close;
      Clear;
      add(estbk_sqlcollection._SQLUserCompAccListSelect);
      parambyName('user_id').AsInteger := userID;
      Open;

      First;

      while not EOF do
      begin
        for i := 0 to self.chkLstBoxAllowedCmp.Items.Count - 1 do
          if (TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemId = FieldByName('company_id').AsInteger) then
          begin
            self.chkLstBoxAllowedCmp.Checked[i] := True;
            TPermissionHelper(self.chkLstBoxAllowedCmp.Items.Objects[i]).itemExists := True; // ***
            break;
          end;

        Next;
      end;
      // ---



    finally
      // ilus stiil on sodi enda järel ära koristada
      Close;
      Clear;
      paramCheck := paramChkState;
    end;
end;



procedure Tform_admin.createUserPermissionList(const userID: integer; const reloadPerm: boolean = False);
var
  paramChkState: boolean;
  FPtmp: TPermissionHelper;
  FDoReload: boolean;
  i, j: integer;
begin

  with  estbk_datamodule.admDatamodule do
    try
      self.chkLstBoxUserRolePermListing.Clear;

      // --- üldistes õigustes reset
      for i := 0 to chkLstBoxPermission.items.Count - 1 do
      begin
        chkLstBoxPermission.Checked[i] := False;
        // tegemist universaalse klassiga, sellest ka need nimed tingitud
        TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemExists := False;
        // kas algselt oli valik või mitte
        TPermissionHelper(chkLstBoxPermission.items.objects[i]).userModified := False;
        TPermissionHelper(chkLstBoxPermission.items.objects[i]).descriptors := '';
        // ntx kas välistav õigus
      end;


      // --- valitud rollides reset
      for i := 0 to chkLstBoxUserRoles.items.Count - 1 do
      begin
        chkLstBoxUserRoles.Checked[i] := False;
        TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemExists := False;
      end;


      FDoReload := reloadPerm or (chkLstBoxPermission.items.Count = 0);
      paramChkState := admTempQuery.paramCheck;
      admTempQuery.paramCheck := True;
      // ---
      if FDoReload then
      begin

        // --- tühjendame õiguste nimistu
        for i := 0 to chkLstBoxPermission.items.Count - 1 do
          if assigned(chkLstBoxPermission.items.Objects[i]) then
            TPermissionHelper(chkLstBoxPermission.items.Objects[i]).Free;
        chkLstBoxPermission.Clear;

        // --- rollid laetakse ka uuesti, peame need ka vabastama
        for i := 0 to chkLstBoxUserRoles.items.Count - 1 do
          if assigned(chkLstBoxUserRoles.items.Objects[i]) then
            TPermissionHelper(chkLstBoxUserRoles.items.Objects[i]).Free;
        chkLstBoxUserRoles.Clear;
        // http://lazarus-ccr.sourceforge.net/docs/fcl/process/tprocess.html



        // -------------------
        // täidame kogu õiguste listi
        admTempQuery.Close;
        admTempQuery.SQL.Clear;
        admTempQuery.SQL.add(estbk_sqlcollection._SQLGetAllPermissionDescr);
        admTempQuery.Open;

        while not admTempQuery.EOF do
        begin
          FPtmp := TPermissionHelper.Create;
          FPtmp.itemId := admTempQuery.FieldByName('id').AsInteger;
          FPtmp.itemExists := False;
          //FPtmp.itemMiscS:=fieldByName('system_alias').asString;
          chkLstBoxPermission.items.addObject(admTempQuery.FieldByName('description').AsString, FPtmp);
          // --
          admTempQuery.Next;
        end;



        // -------------------
        // lisame ka rollide üldised kirjeldused
        admTempQuery.Close;
        admTempQuery.SQL.Clear;
        admTempQuery.SQL.add(estbk_sqlcollection._SQLUserRole);
        admTempQuery.Open;

        while not admTempQuery.EOF do
        begin
          FPtmp := TPermissionHelper.Create;
          FPtmp.itemId := admTempQuery.FieldByName('id').AsInteger;
          FPtmp.itemExists := False;
          chkLstBoxUserRoles.items.addObject(
            admTempQuery.FieldByName('role_name').AsString, FPtmp);
          admTempQuery.Next;
        end;
      end;




      //  -------------------
      // vaatame, millised rollid kasutaja omistatud
      admTempQuery.Close;
      admTempQuery.SQL.Clear;
      admTempQuery.SQL.add(estbk_sqlcollection._SQLUserAssignedRoles);
      admTempQuery.paramByname('user_id').AsInteger := userid;
      admTempQuery.Open;
      admTempQuery.First;

      while not admTempQuery.EOF do
      begin
        for i := 0 to chkLstBoxUserRoles.items.Count - 1 do
          if assigned(chkLstBoxUserRoles.items.objects[i]) and (TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemId =
            admTempQuery.FieldByName('role_id').AsInteger) then
          begin
            chkLstBoxUserRoles.Checked[i] := True;
            TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemExists := True;
            break;
          end;

        admTempQuery.Next;
      end;



      // käime läbi rollide nimistu ning tema õigused ja märgistame valituks kogu õiguste listis
      for i := 0 to chkLstBoxUserRoles.items.Count - 1 do
        if assigned(chkLstBoxUserRoles.items.objects[i]) and chkLstBoxUserRoles.Checked[i] then
        begin

          // filtreerime selle rolli õigused välja
          admBufferedRolePermRelations.filtered := False;
          admBufferedRolePermRelations.filter := 'role_id=' + IntToStr(TPermissionHelper(chkLstBoxUserRoles.items.objects[i]).itemid);
          admBufferedRolePermRelations.filtered := True;
          admBufferedRolePermRelations.First;


          for j := 0 to chkLstBoxPermission.items.Count - 1 do
            if (TPermissionHelper(chkLstBoxPermission.items.objects[j]).itemId = admBufferedRolePermRelations.FieldByName(
              'permission_descr_id').AsInteger) then
            begin
              TPermissionHelper(chkLstBoxPermission.items.objects[j]).itemExists := True;
              // kui välistava markeriga õigus, siis ei märgista teda aktiviivseks
              chkLstBoxPermission.Checked[j] :=
                (pos(estbk_types.CExcludePermission, TPermissionHelper(chkLstBoxPermission.items.objects[j]).descriptors) <> 0);
              break;
            end;
          // ---
        end;



      // ---
      // filter maha !
      admBufferedRolePermRelations.filtered := False;


      // kõik kasutaja rolli välised või rolli õigust välistavad õigused...kas pole tore lause...
      // ---
      admTempQuery.Close;
      admTempQuery.SQL.Clear;
      admTempQuery.SQL.add(estbk_sqlcollection._SQLUserPermissions);
      admTempQuery.paramByname('user_id').AsInteger := userId;
      admTempQuery.Open;
      admTempQuery.First;
      //if  admTempQuery.paramcheck then
      //   showmessage(estbk_sqlcollection._SQLUserPermissions+' '+inttostr(userId));

      while not admTempQuery.EOF do
      begin

        //  -------------------
        // vaatame üle kasutaja aktiivsed õigused; st rolli välised
        for i := 0 to chkLstBoxPermission.items.Count - 1 do
        begin

          // ---------
          // et poleks välistav õigus ! D tunnusega
          if (TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemId = admTempQuery.FieldByName('permission_descr_id').AsInteger) then
          begin
            if (pos(estbk_types.CExcludePermission, admTempQuery.FieldByName('descriptors').AsString) = 0) then
            begin
              chkLstBoxPermission.Checked[i] := True;
              TPermissionHelper(chkLstBoxPermission.items.objects[i]).itemExists := True;
            end
            else
              TPermissionHelper(chkLstBoxPermission.items.objects[i]).descriptors := admTempQuery.FieldByName('descriptors').AsString;
            break;
            // --
          end;
        end;
        // ---
        admTempQuery.Next;
      end;


      // teeme nagu oleks vaikimisi rollile klikitud...olgu seleteeritud või mitte...
      if self.chkLstBoxUserRoles.items.Count > 0 then
      begin
        self.chkLstBoxUserRoles.ItemIndex := 0;
        self.chkLstBoxUserRolesItemClick(chkLstBoxUserRoles, 0);
      end;
      // ---
    finally
      admTempQuery.Close;
      admTempQuery.SQL.Clear;
      admTempQuery.paramCheck := paramChkState;
    end;
end;

procedure Tform_admin.btnMgnUsersClick(Sender: TObject);
begin
  TToolbutton(Sender).Enabled := False;

  //admpages.ActivePage :=self.tabWorkerMgm;
  estbk_datamodule.admDatamodule.admBufferedRolePermRelations.Open;

  admWorkerMgmQry.Open;

  // --------------

  changeWCtrlEnabledStatus(self.rightPanelWrk, not admWorkerMgmQry.EOF);
  //   estbk_datamodule.admDatamodule.admWorkerMgmQry.Edit;
  //   estbk_datamodule.admDatamodule.admWorkerMgmQry.fieldbyname('dummypwd').AsString:='AAA';
  //   estbk_datamodule.admDatamodule.admWorkerMgmQry.Post;
  // self.rightPanelWrk.Enabled := True;


  tabWorkerMgm.TabVisible := True;
  //pageCompControl.ActivePage:=tabWorkerMgm

  self.admPages.ActivePage := tabWorkerMgm;
  self.pageCtrlUserMgr.ActivePage := tabOverAllDescr;
  self.pgControlUserPrm.ActivePage := tabCompanyPermission;
  // kasutajanime ei luba muuta, kuigi algselt see võimalus ka oli. Tekitab probleeme !
  //self.dbEdtWorkUsername.Enabled:=False;
  self.dbEdtWorkUsername.ReadOnly := True;
  self.dbEdtWorkUsername.ParentColor := True;


  // if dbEdtWorkUsername.Enabled then
  if edEdtWrkPassword.Enabled then
    self.edEdtWrkPassword.SetFocus
  else
    self.btnNewWorker.SetFocus;
  // ----
  self.createUserCompList(admWorkerMgmQry.FieldByName('id').AsInteger, True);
  self.createUserPermissionList(admWorkerMgmQry.FieldByName('id').AsInteger, True);

end;

procedure Tform_admin.btnCancelClick(Sender: TObject);
begin
  self.FCompDataNotSaved := False;

  admCompListQry.Cancel;
  changeWCtrlEnabledStatus(self.Panel2, not admCompListQry.EOF);

  // -------------------------------------------------------------------
  // -- tühistame ka salvestamata majandusaasta tulemused

  self.frameAccPeriods1.triggerCancelEvent;


  btnNewItem.Enabled := True;
  btnSave.Enabled := False;
  btnCancel.Enabled := False;


  self.admCompListQryAfterScroll(admCompListQry);
  self.tabPageAccPeriod.TabVisible := not admCompListQry.EOF;
  self.tabVat.TabVisible := not admCompListQry.EOF;
  self.tabLogo.TabVisible := not admCompListQry.EOF;

end;

procedure Tform_admin.actionToolbarClick(Sender: TObject);
begin

end;

procedure Tform_admin.admCompListQryAfterEdit(DataSet: TDataSet);
begin
  // lipp püsti, et midagi toimus
  self.FCompDataNotSaved := True;
end;

procedure Tform_admin.admCompListQryAfterPost(DataSet: TDataSet);
begin
  btnCancel.Enabled := False;
  //  estadmin_form.form_admin.btnSave.SetFocus;
end;

procedure Tform_admin.admCompListQryAfterScroll(DataSet: TDataSet);
begin
  // 25.08.2009 ingmar tean, et saab ka Dataset["p"]; aga kui vähegi võimalik hoidu igasugustest variantidest !!!
  frameCompCAddr.countyId := DataSet.FieldByName('county_id').AsInteger;
  frameCompCAddr.cityId := DataSet.FieldByName('city_id').AsInteger;
  frameCompCAddr.streetId := DataSet.FieldByName('street_id').AsInteger;

  // --------
  frameAccPeriods1.companyId := DataSet.FieldByName('id').AsInteger;

  if not FIsNewComp then
  begin
    loadLogo.Enabled := False;
    frameVATMgr.companyId := DataSet.FieldByName('id').AsInteger;
    // 24.12.2011 Ingmar
    loadLogo.Enabled := True;
  end;

end;

procedure Tform_admin.admCompListQryBeforeEdit(DataSet: TDataSet);
begin
  btnCancel.Enabled := True;
  btnSave.Enabled := True;
end;

procedure Tform_admin.admCompListQryBeforePost(DataSet: TDataSet);
begin
  // ---
  Dataset.FieldByName('countrycode').AsString := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;
  Dataset.FieldByName('county_id').AsInteger := estadmin_form.form_admin.frameCompCAddr.countyId;
  Dataset.FieldByName('city_id').AsInteger := estadmin_form.form_admin.frameCompCAddr.cityId;
  Dataset.FieldByName('street_id').AsInteger := estadmin_form.form_admin.frameCompCAddr.streetId;
  Dataset.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  Dataset.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
end;

procedure Tform_admin.admCompListQryBeforeScroll(DataSet: TDataSet);
begin

  // ennem peab ikka muudatused ka salvestama !
  if self.FCompDataNotSaved or self.frameAccPeriods1.dataNotSaved then
  begin
    Dialogs.messageDlg(SConfBfScrollSaveChg, mtInformation, [mbOK], 0);
    btnCancel.Enabled := True;
    abort;
  end;
  // ---
end;

procedure Tform_admin.admCompListQryEditError(DataSet: TDataSet; E: EDatabaseError; var DataAction: TDataAction);
begin
  // Action:=daRetry;
  DataAction := daAbort;
end;

procedure Tform_admin.admWorkerMgmQryAfterEdit(DataSet: TDataSet);
begin
  self.FWorkDataNotSaved := True;
  // --------
  self.btnSaveWorker.Enabled := True;
  self.btnCancelWorkerEdit.Enabled := True;
end;


procedure Tform_admin.admWorkerMgmQryAfterPost(DataSet: TDataSet);
begin
  btnCancelWorkerEdit.Enabled := False;
end;

procedure Tform_admin.admWorkerMgmQryAfterScroll(DataSet: TDataSet);
begin
  createUserCompList(Dataset.FieldByName('id').AsInteger);
  createUserPermissionList(Dataset.FieldByName('id').AsInteger);
end;

procedure Tform_admin.admWorkerMgmQryBeforePost(DataSet: TDataSet);
begin
  Dataset.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  Dataset.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
  if assigned(Dataset.FindField('rec_changed')) then
    Dataset.FieldByName('rec_changed').AsDateTime := now;
end;

procedure Tform_admin.admWorkerMgmQryBeforeScroll(DataSet: TDataSet);
begin
  if self.FWorkDataNotSaved then
  begin
    Dialogs.messageDlg(SConfBfScrollSaveChg, mtInformation, [mbOK], 0);
    btnCancelWorkerEdit.Enabled := True;
    abort;
  end;
  // ---
end;

procedure Tform_admin.btnCancelWorkerEditClick(Sender: TObject);
begin
  admWorkerMgmQry.Cancel;
  changeWCtrlEnabledStatus(self.rightPanelWrk, not admWorkerMgmQry.EOF);

  // --- lipp maha
  self.FWorkDataNotSaved := False;

  btnCancelWorkerEdit.Enabled := False;
  btnSaveWorker.Enabled := False;
  btnNewWorker.Enabled := True;
  pageCtrlUserMgr.ActivePage := tabOverAllDescr;
  dbEdtWorkUsername.ReadOnly := True;
  dbEdtWorkUsername.ParentColor := True;

  // ------------
  self.admWorkerMgmQryAfterScroll(admWorkerMgmQry);
end;


procedure Tform_admin.OnClickCopyCmpSettings(Sender: TObject);
begin
  if Sender is TMenuItem then
    if (admCompListQry.FieldByName('id').AsInteger <> TMenuItem(Sender).tag) and
      (Dialogs.MessageDlg(format(estbk_strmsg.SCCopyCompanyAttr, [admCompListQry.FieldByName('name').AsString, TMenuItem(Sender).Caption]),
      mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      with tempQry, SQL do
        try
          Close;
          Clear;
          add(estbk_sqlcollection._SQLCountAccounts2);
          paramByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          Open;
          if FieldByName('acc_cnt').AsInteger > 0 then
          begin
            Dialogs.MessageDlg(estbk_strmsg.SECpyfDefaultAccPlanExists, mtError, [mbOK], 0);
            exit;
          end;


          // -- kopeerime kontod ja vaikimisi kontod
          Close;
          Clear;
          add(estbk_sqlcollection._SQLCopyCompanyAcc);
          paramByname('companyid1').AsInteger := TMenuItem(Sender).tag;
          paramByname('companyid2').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          execSQL;

          Close;
          Clear;
          add(estbk_sqlcollection._SQLCopyDefaultAccPart1);
          paramByname('companyid1').AsInteger := TMenuItem(Sender).tag;
          paramByname('companyid2').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          execSQL;

          Close;
          Clear;
          add(estbk_sqlcollection._SQLCopyDefaultAccPart2);
          paramByname('companyid2').AsInteger := admCompListQry.FieldByName('id').AsInteger;
          execSQL;

          Dialogs.messageDlg(estbk_strmsg.SCCopied, mtInformation, [mbOK], 0);

        finally
          Close;
          Clear;
        end;
end;

procedure Tform_admin.addCompanyListIntoSubMenu;
var
  pNewItem: TMenuItem;
begin
  mnu_copySettings.Clear;

  with tempQry, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlcollection._SQLSelectAllCompanys);
      Open;
      while not EOF do
      begin
        pNewItem := TMenuItem.Create(mnu_copySettings);
        pNewItem.Caption := FieldByName('name').AsString;
        pNewItem.Tag := PtrUInt(FieldByName('id').AsInteger);
        pNewItem.OnClick := @self.OnClickCopyCmpSettings;
        mnu_copySettings.Add(pNewItem);

        Next; // ---
      end;


    finally
      Close;
      Clear;
    end;
  // asdas
end;

procedure Tform_admin.FormShow(Sender: TObject);
var
  emsg, tempColl: AStr;
  eParam: boolean; // selle sisu sõltub vastavalt backendine
begin

  // 14.04.2012 Ingmar; tõin formcreate osast ära, põhjustab vigu !
  with estbk_datamodule.admDatamodule.admTempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_dbcompability.sqlp._getDatabaseVerSQL);
      Open;

      lblLocDbVersion.Caption := FieldByName('version').AsString;
    finally
      Close;
      Clear;
    end;


  eParam := False;
  //copyrightLabel.caption:=SCurrentAppver+#32+  copyrightLabel.caption;
  self.Caption := self.Caption + #32 + SCurrentAppver;
  self.admPages.ActivePage := firstpage;
  emsg := '';
  tempColl := '';
  // -------



  if not admDatamodule.validateTables(False, emsg, tempColl, eParam) then
  begin

    // pole ilus...aga efektiivne :)
    if emsg = estbk_strmsg.SENoRightsToCreateDbObj then
    begin
      messageDlg(emsg, mtError, [mbOK], 0);
      application.terminate;
      exit;
    end;

    // ---
    if Dialogs.messageDlg(SCFirstRun + CRLF + CRLF + emsg + CRLF + CRLF + SCDoWeCreateTables, mtError, [mbYes, mbNo], 0) = mrNo then
      application.Terminate
    else
      // ...proovime uuesti...
    begin

      // ja kontrollime
      // ainult postgre puhul; windowsi puhul võtab ta collationid DEFAULT seadetest !!!!
      if (estbk_dbcompability.sqlp.currentBackEnd = __postGre) and (emsg = format(estbk_strmsg.SEDatabaseNotCreated,
        [__dbNameOverride(CProjectDatabaseNameDef)])) then


      begin

        // temp:=trim(ansilowercase(estbk_utilities.getSysLocname())); // Estonian_Estonia.1257
        if pos(ansilowercase(CPostRequiredCollationAndCType), ansilowercase(tempColl)) = 0 then
          // if  (temp<>ansilowercase(estbk_types.CPostRequiredCollationAndCType)) then
          // if (Dialogs.messageDlg(format(ScPostGreIgnoreCurrentLocaleSettings,[estbk_types.CPostRequiredCollationAndCType,estbk_utilities.getSysLocname()]),mtConfirmation,[mbYes,mbNo],0)=mrNo) then
          // 09.04.2012 Ingmar; peaks ikkagit kuvama serveri lokaali !
          if (Dialogs.messageDlg(format(ScPostGreIgnoreCurrentLocaleSettings, [estbk_types.CPostRequiredCollationAndCType, tempColl]),
            mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
          begin
            application.Terminate;
            exit;
          end
          else
            // ---
            eparam := True; // võtame C / Posix collationi
      end;


      if not admDatamodule.validateTables(True, emsg, tempColl, eparam) then
      begin
        Dialogs.messageDlg(SETableAutoCreateFailed + CRLF + CRLF + emsg, mtError, [mbOK], 0);
        application.Terminate;
      end;
    end;
  end;


  self.FTemplate0Collation := tempColl;
  StatusBar1.SimpleText := '';
  if not application.Terminated then
  begin
    // 19.07.2011 Ingmar
    estbk_upgrademodule.__doDatabaseUpgrade;
    // 21.09.2011 Ingmar; nüüd saab ühe firma seaded teisele kopeerida
    self.addCompanyListIntoSubMenu;

    // 25.02.2014 Ingmar; tagame, et ikka kõik tõlked peale jookseks !
    try
      estbk_fra_template.translateObject(self, estbk_datamodule.admDatamodule.findActiveLanguage);
    except
    end;

    // W10 peal on aadressi frame nihkes
    frameCompCAddr.Left := 19;
  end;
end;

procedure Tform_admin.FrameAddrPicker1Click(Sender: TObject);
begin

end;

procedure Tform_admin.loadLogoTimer(Sender: TObject);
var
  pBase64: AStr;
  pStrStream: TStringStream;
  pMemStream: TMemoryStream;
  pBase64Str: TBase64DecodingStream;
begin
  TTimer(Sender).Enabled := False;
  // ---
  if admCompListQry.active and (admCompListQry.RecordCount > 0) then
    with tempQry, SQL do
      try
        pStrStream := nil;
        pBase64Str := nil;
        pMemStream := TMemoryStream.Create;
        compLogoPct.Picture.Clear;
        Close;
        Clear;
        add(estbk_sqlcollection._SQLConfSelectLogo);
        paramByname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
        Open;
        if EOF then
          Exit; // ---


        pBase64 := trim(FieldByName('val_blob').AsString);
        pStrStream := TStringStream.Create(pBase64);
        pStrStream.Seek(0, 0);
        pBase64Str := TBase64DecodingStream.Create(pStrStream);

        pStrStream.Seek(0, 0);
        pMemStream.CopyFrom(pBase64Str, pBase64Str.Size);


        pMemStream.Seek(0, 0);
        compLogoPct.Picture.LoadFromStream(pMemStream);
      finally
        Close;
        Clear;
        // ---
        if assigned(pStrStream) then
          FreeAndNil(pStrStream);

        if assigned(pMemStream) then
          FreeAndNil(pMemStream);

        if assigned(pBase64Str) then
          FreeAndNil(pBase64Str);
      end;
end;

// 09.05.2011 Ingmar; luban kontoplaani importida !
procedure Tform_admin.MenuItem1Click(Sender: TObject);
begin
  if admCompListQry.active and (admCompListQry.RecordCount > 0) then
    with tempQry, SQL do
      try
        Close;
        Clear;
        add(_SQLCountAccounts);
        parambyname('company_id').AsInteger := admCompListQry.FieldByName('id').AsInteger;
        Open;
        if FieldByName('acc_cnt').AsInteger > 0 then
          Dialogs.MessageDlg(estbk_strmsg.SEAccountPlanAlreadyExists, mtError, [mbOK], 0)
        else
          // ---
        begin
          if self.openAccFile.Execute then
            self.addDefaultAccountingPlanToComp(admCompListQry.FieldByName('id').AsInteger, self.openAccFile.Files.Strings[0]);
        end;

      finally
        Close;
        Clear;
      end;
end;

procedure Tform_admin.mnuDebugClick(Sender: TObject);
begin
  // TformNumerators.showAndCreate(3,1);

end;

procedure Tform_admin.mnuBackupClick(Sender: TObject);
begin
  estbk_frm_backup_restore.TformBackupRestore.createAndShow(True);
end;

procedure Tform_admin.mnuItemExecScriptClick(Sender: TObject);
const
  CDenyDelete = 'DELETE ';
  CDenyTruncate = 'TRUNCATE ';
  CCompanyId = ':company_id';
var
  b: boolean;
  pLoadScript: TAStrList;
  pSQL: AStr;
  i: integer;
begin
  // --
  if openScriptFile.Execute then
    try
      admDatamodule.admConnection.StartTransaction;
      // ---
      with admDatamodule.admTempQuery do
        try
          b := ParamCheck;
          pLoadScript := TAStrList.Create;
          pLoadScript.Delimiter := '#';
          pLoadScript.LoadFromFile(openScriptFile.Files.Strings[0]);
          pSQL := (pLoadScript.Text);
          pSQL := stringreplace(pSQL, #13, ' ', [rfReplaceAll]);
          pSQL := stringreplace(pSQL, #10, ' ', [rfReplaceAll]);
          pLoadScript.Text := pSQL;
          // pSQL:=stringreplace(pSQL,'#',#13,[rfReplaceAll]);
          // pLoadScript.DelimitedText:=pSQL;


          for i := 0 to pLoadScript.Count - 1 do
          begin
            pSQL := trim(pLoadScript.Strings[i]);
            if pSQL = '' then
              continue;

            if pos(CDenyDelete, AnsiUpperCase(pSQL)) > 0 then
              raise Exception.Create(estbk_strmsg.SEErrorCmdDenied + ' ' + CDenyDelete);
            // ---
            if pos(CDenyTruncate, AnsiUpperCase(pSQL)) > 0 then
              raise Exception.Create(estbk_strmsg.SEErrorCmdDenied + ' ' + CDenyTruncate);
            // ---
            Close;
            SQL.Clear;
            ParamCheck := pos(CCompanyId, ansilowercase(pSQL)) > 0;
            SQL.Text := pSQL;
            // ---
            if ParamCheck and admCompListQry.Active then
              ParamByname(CCompanyId).AsInteger := admCompListQry.FieldByName('id').AsInteger;
            ExecSQL;
          end;

          admDatamodule.admConnection.Commit;
          ShowMessage(estbk_strmsg.SCommDone);
        finally
          ParamCheck := b;
          Close;
          SQL.Clear;
        end;

    except
      on E: Exception do
      begin
        if admDatamodule.admConnection.InTransaction then
          try
            admDatamodule.admConnection.Rollback;
          except
          end;
        Dialogs.MessageDlg(format(estbk_strmsg.SEErrorOnExecScript, [e.message]), mtError, [mbOK], 0);
      end;
    end;
end;

procedure Tform_admin.mnuReinitRoleClick(Sender: TObject);
var
  emsg: string;
begin
  admDatamodule.assignRolePermissions(emsg);
  if emsg <> '' then
    Dialogs.MessageDlg(emsg, mtError, [mbOK], 0)
  else
    Dialogs.MessageDlg(estbk_strmsg.SCommDone, mtInformation, [mbOK], 0);
end;

procedure Tform_admin.mnuRestoreClick(Sender: TObject);
begin
  estbk_frm_backup_restore.TformBackupRestore.createAndShow(False);
end;

procedure Tform_admin.mnuVacuumDbClick(Sender: TObject);
begin
  with admDatamodule.admTempQuery, sql do
    try
      Close;
      Clear;
      add('VACUUM FULL VERBOSE');
      ExecSQL;

    finally
      Close;
      Clear;
    end;
  Dialogs.messageDlg(estbk_strmsg.SCommDone, mtInformation, [mbOK], 0);
end;



procedure ExceptHandler(Obj: TObject; Addr: Pointer; FrameCount: longint; Frame: PPointer);
begin
  // ExceptProc := OldExceptProc;
  messageDlg('Programmis tekkis viga !' + #13#10#13#10 + format('Aadress: %p', [Addr]), mtError, [mbOK], 0);
end;


initialization
  {$I estadmin_form.ctrs}
  myOldExceptHnd := ExceptProc;
  ExceptProc := @ExceptHandler;


finalization
  ExceptProc := myOldExceptHnd;
end.