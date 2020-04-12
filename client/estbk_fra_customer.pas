unit estbk_fra_customer;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, DBGrids, ExtCtrls,
  ComCtrls, Graphics, estbk_lib_commonevents, estbk_lib_commoncls,
  estbk_clientdatamodule, estbk_sqlclientcollection, estbk_globvars,
  estbk_utilities, estbk_types, estbk_strmsg, estbk_frame_chooseaddr, estbk_fra_template,
  estbk_crc32, DB, Dialogs, LCLProc, LCLType, DBCtrls, ZDataset, ZSqlUpdate,
  ZSequence, Controls, Grids, Menus, Buttons, rxlookup;

const
  CMaxCustomerCount = 4096;

type

  { TframeCustomers }
  //  TframeCustomers = class(TFrameAddrPicker)
  TframeCustomers = class(Tfra_template)
    btnClean: TBitBtn;
    btnCloseSrcPage: TBitBtn;
    btnNewClient: TBitBtn;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    btnCloseEdtPage: TBitBtn;
    btnSearch: TBitBtn;
    bv1: TBevel;
    bv2: TBevel;
    bvh1: TBevel;
    bvh2: TBevel;
    chkSupplier: TCheckBox;
    cmbCountry: TComboBox;
    cmbSrcCountry: TComboBox;
    cmbCustType: TComboBox;
    dbEdtClientCode: TDBEdit;
    dbEdtVatNr: TDBEdit;
    dbGridCustSearch: TDBGrid;
    dbMemoNotes: TDBMemo;
    dummyTabFix1: TEdit;
    edtClientId: TEdit;
    gridCustCPerson: TDBGrid;
    Image1: TImage;
    lblCustTotal: TLabel;
    lblClientId: TLabel;
    lblCustCode: TLabel;
    lblCustSrcCountry: TLabel;
    lblCustRegCode1: TLabel;
    lblEdtApartmentnr: TEdit;
    lblEdtCName: TEdit;
    lblEdtHousrnr: TEdit;
    lblEdtLastname: TEdit;
    lblEdtRegnr: TEdit;
    lblFCName: TLabel;
    lbLHouseNr: TLabel;
    lbLHouseNr1: TLabel;
    lbLName: TLabel;
    lblRegCode: TLabel;
    pPanelBottom: TPanel;
    pSrcCriteriaPanel: TPanel;
    ptoppanel: TPanel;
    pDeleteContactP: TMenuItem;
    pNewContactP: TMenuItem;
    pGridActions: TPopupMenu;
    qryBanksDs: TDatasource;
    dbEdtCustBankAcc1: TDBEdit;
    dbEdtCustBankAcc3: TDBEdit;
    dbEdtCustWebpage: TDBEdit;
    dbEdtCustBankAcc2: TDBEdit;
    dbRcvBankList: TRxDBLookupCombo;
    dummyTabFix: TEdit;
    lblOurRefNr: TLabel;
    lblBankName: TLabel;
    lblCredLimit: TLabel;
    lblPurchRefNr: TLabel;
    lblWebPage: TLabel;
    qryInsUptClientCPersonsDs: TDatasource;
    qryInsUpdtClientDS: TDatasource;
    dbEdtCustBankAcc: TDBEdit;
    dbEdtCustEMail: TDBEdit;
    dbEdtCustFax: TDBEdit;
    dbEdtCustomerFlatNr: TDBEdit;
    dbEdtCustomerHouseNr: TDBEdit;
    dbEdtCustomerLastname: TDBEdit;
    dbEdtCustomerName: TDBEdit;
    dbEdtCustomerRegCode: TDBEdit;
    dbEdtCustPhone: TDBEdit;
    dbEdtCustPostAddr: TDBEdit;
    dbEdtPostIndex: TDBEdit;
    lblNotes: TLabel;
    lblCustBankAcc: TLabel;
    lblCustCountry: TLabel;
    lblCustEmail: TLabel;
    lblCustFax: TLabel;
    lblCustFlatnr: TLabel;
    lblCustHousenr: TLabel;
    lblCustName: TLabel;
    lblCustPhone: TLabel;
    lblCustPostAddr: TLabel;
    lblCustPostIdx: TLabel;
    lblCustRegCode: TLabel;
    lblCustType: TLabel;
    lblLastname: TLabel;
    qryInsUptClientCPersons: TZQuery;
    qryInsUptClientSeq: TZSequence;
    qryInsUptClientSQL: TZUpdateSQL;
    qryInsUptClient: TZQuery;
    tabCustomerCommData: TPageControl;
    tabCtrlCustomer: TPageControl;
    tabSearch: TTabSheet;
    tabCustomerData: TTabSheet;
    tabNameAddrData: TTabSheet;
    tabDetailedPage: TTabSheet;
    qryValidateDataQry: TZReadOnlyQuery;
    qryBanks: TZReadOnlyQuery;
    tabContactPersons: TTabSheet;
    qryInsUptClientCPersonsUptIns: TZUpdateSQL;
    qryInsUptClientCPersonsSeq: TZSequence;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCleanClick(Sender: TObject);
    procedure btnCloseSrcPageClick(Sender: TObject);
    procedure btnNewClientClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure chkSupplierChange(Sender: TObject);
    procedure cmbCountryChange(Sender: TObject);
    procedure cmbCustTypeChange(Sender: TObject);
    procedure cmbCustTypeKeyPress(Sender: TObject; var Key: char);
    procedure cmbSrcCountryExit(Sender: TObject);
    procedure cmbSrcCountryKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbGridCustSearchDblClick(Sender: TObject);
    procedure dbGridCustSearchDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure dbGridCustSearchKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbGridCustSearchPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
    procedure dbRcvBankListClosePopupNotif(Sender: TObject);
    procedure dbRcvBankListSelect(Sender: TObject);
    procedure gridCustCPersonKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure pDeleteContactPClick(Sender: TObject);
    procedure pNewContactPClick(Sender: TObject);
    procedure qryInsUptClientAfterEdit(DataSet: TDataSet);
    procedure qryInsUptClientAfterInsert(DataSet: TDataSet);
    procedure qryInsUptClientAfterScroll(DataSet: TDataSet);
    procedure qryInsUptClientBeforeInsert(DataSet: TDataSet);
    procedure qryInsUptClientBeforePost(DataSet: TDataSet);
    procedure qryInsUptClientCPersonsAfterClose(DataSet: TDataSet);
    procedure qryInsUptClientCPersonsAfterInsert(DataSet: TDataSet);
    procedure qryInsUptClientCPersonsAfterOpen(DataSet: TDataSet);
    procedure qryInsUptClientCPersonsAfterScroll(DataSet: TDataSet);
    procedure qryInsUptClientCPersonsBeforeDelete(DataSet: TDataSet);
    procedure qryInsUptClientCPersonsBeforePost(DataSet: TDataSet);
    procedure tabCtrlCustomerChange(Sender: TObject);

  private
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FFrameItemChoosen: TFrameChooseCustomer;
    FTCCustomerType: TCCustomerType;
    // --
    FDefaultCountryIndx: integer;
    // jubeda probleemid, kui frame framel, nö viimasel framel kaovad propertid !
    FFrameSrcAddr: TFrameAddrPicker;
    FFrameCustAddr: TFrameAddrPicker;

  protected
    // 08.09.2011 Ingmar; tobe tab hack !
    FOnSrcFrameStreetExit: TNotifyEvent;
    FForceTabKeyCode: boolean;

    // 25.12.2009 Ingmar; salvestame hetke handlerid
    FAfterEdit: TQryEvent;    //procedure qryInsUptCustomerAfterEdit(DataSet: TDataSet);
    FAfterScroll: TQryEvent;    //procedure qryInsUptCustomerAfterScroll(DataSet: TDataSet);
    FBeforeInsert: TQryEvent;    //procedure qryInsUptCustomerBeforeInsert(DataSet: TDataSet);
    FBeforePost: TQryEvent;    //procedure qryInsUptCustomerBeforePost(DataSet: TDataSet);

    FsaveDataAndClose: boolean;
    FSkipScrollEvent: boolean;
    FDataNotSaved: boolean;
    FNewRecordCreated: boolean;
    FchooseCustomerMode: boolean;
    FCurrentCustId: integer;

    procedure setCustomerType(const v: TCCustomerType);
    function getSrcTabStatus: boolean;
    procedure setSrcTagStatus(const v: boolean);
    procedure setNewUsrBtnVis(const v: boolean);
    function getNewUsrBtnVis: boolean;

    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);


    procedure onCustomerDataAddrChange(Sender: TObject);
    procedure onSrcFrameStreetExitEvnt(Sender: TObject);
    procedure showCustomers(const custcnt: integer = CMaxCustomerCount);




    // --
    // sõltub millises reziimis töötame, kui displaySrcTab false, siis töötame 1 kliendiga !
    procedure openClientRec(const clientID: integer);
    function verifyIsDataSaved: boolean;
    // --
    procedure assignClientIdToCPerson;
  public
    procedure addNewClient; overload;
    procedure addNewClient(const pClientName: AStr; const pNameInRevOrder: boolean = False); overload;


    procedure forceFocus(const pSelectClientId: integer);
    class function datasetToClientDataClass(const dataset: TDataset): TClientData;
    // --------------
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;

    // 22.04.2011 Ingmar; sisuliselt tuli soov, kui ntx arvetes või kusiganes salvestatakse uus klient,
    // siis peale salvestamist vorm suletakse ning antud klient muutub valituks !
    property saveDataAndClose: boolean read FsaveDataAndClose write FsaveDataAndClose;


    property customerType: TCCustomerType read FTCCustomerType write setCustomerType;
    property currentCustId: integer read FCurrentCustId write openClientRec;

    // ------------
    // läbi prop. lihtsam ilusam suhtlus framega, saaks ka otse peita elemente
    property displayNewUsrBtn: boolean read getNewUsrBtnVis write setNewUsrBtnVis;
    // vajalik, kas kuvame otsingu tabi või mitte !
    property displaySrcTab: boolean read getSrcTabStatus write setSrcTagStatus;


    // kui tehakse pNewContactPäringu tulemust gridis topeltklikk, siis vastavalt sellele osustatakse,
    // kuidas edasi; muidu viiakse kliendi andmete lehele;
    // teisel juhul väärtustatakse kliendi ID ja kutsutakse välja frameKillsignal
    property chooseCustomerMode: boolean read FchooseCustomerMode write FchooseCustomerMode;
    // property loadData: boolean read getDataLoadStatus write setDataLoadStatus;

    // events
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;



    // clientChooseMode: pane see siis true; ei hüpata kliendi andmete peale !
    // klient valiti
    property onFrameItemChoosen: TFrameChooseCustomer read FFrameItemChoosen write FFrameItemChoosen;
  end;




// staatilised abifunktsioonid !
function copyClientData(const pDataRec: TClientData): TClientData;



// ka see lihtpäring ära kaotada, asendada cachega ?!? andmebaasis unikaalse kliendiID
// ilma visuaalse pooleta ! kliendi andmed otsitakse ID järgi !
function getClientDataWUI(const pClientCode: AStr): TClientData;       // kliendile omistatud kood firma põhiselt
function getClientDataWUI_uniq(const pClientId: integer): TClientData;  // unikaalne kliendi ID üle andmebaasi !
function buildFullClientAddrFromCstData(const pClientData: TClientData): AStr;


implementation

uses estbk_uivisualinit;

const
  CComboIdxLegalPerson = 1;
  CComboIdxPrivatePerson = 2;


// mõnikord ei ole hea originaal instansi üle kirjutada
function copyClientData(const pDataRec: TClientData): TClientData;
begin
  Result := nil;
  if assigned(pDataRec) then
  begin
    Result := TClientData.Create;
    Result.FClientId := pDataRec.FClientId;
    Result.FCustFirstName := pDataRec.FCustFirstName;
    Result.FCustLastName := pDataRec.FCustLastName;

    Result.FCustJCountry := pDataRec.FCustJCountry;
    Result.FCustJCounty := pDataRec.FCustJCounty;
    Result.FCustJCity := pDataRec.FCustJCity;
    Result.FCustJStreet := pDataRec.FCustJStreet;
    Result.FCustJHouseNr := pDataRec.FCustJHouseNr;
    Result.FCustJApartNr := pDataRec.FCustJApartNr;
    Result.FCustJZipCode := pDataRec.FCustJZipCode;

    Result.FCustPAddr := pDataRec.FCustPAddr;
    Result.FCustRepr := pDataRec.FCustRepr;
    Result.FCustCredLimit := pDataRec.FCustCredLimit;
    Result.FCustVatNr := pDataRec.FCustVatNr;
    Result.FCustDueTime := pDataRec.FCustDueTime;

    // 28.02.2010
    Result.FCustEmail := pDataRec.FCustEmail;
    Result.FCustWebPage := pDataRec.FCustWebPage;
    Result.FCustPhone := pDataRec.FCustPhone;

    Result.FCustPurchRefNr := pDataRec.FCustPurchRefNr;
    Result.FCustContrRefNr := pDataRec.FCustContrRefNr;
    Result.FCustBankAccount := pDataRec.FCustBankAccount;
    Result.FCustBankId := pDataRec.FCustBankId;
    // 12.02.2010 Ingmar
    Result.FClientCode := pDataRec.FClientCode;
  end;
end;

// kui caches hoiame vaid osa andmeid, siis see pNewContactPäring annab täieliku kliendi info struktuuri !!!!
// !!!
function getClientDataWUI(const pClientCode: AStr): TClientData;
var
  pSql: AStr;
  pCnvCode: AStr;
begin

  with estbk_clientdatamodule.dmodule do
    try
      tempQuery.Close;
      tempQuery.SQL.Clear;
      // 26.09.2011 Ingmar; tobe värk; Postgres on case sensitive, nüüd pannakse kliendile kood upcases, aga otsitakse lowercases !
      psql := estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id, -1, '', '', '', -1, -1, -1, '', '', pClientCode);
      tempQuery.SQL.add(psql);
      tempQuery.Open;

      if tempQuery.RecordCount < 1 then
      begin
        tempQuery.Close;
        tempQuery.SQL.Clear;
        // järelikult on juba upper
        if AnsiUpperCase(pClientCode) = pClientCode then
          pCnvCode := ansilowercase(pClientCode)
        else
          pCnvCode := AnsiUpperCase(pClientCode);
        psql := estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id, -1, '', '', '', -1, -1, -1, '', '', pCnvCode);
        tempQuery.SQL.add(psql);
        tempQuery.Open;
      end;


      // reloadCustQuery(pcustId);
      Result := TframeCustomers.datasetToClientDataClass(tempQuery);
    finally
      tempQuery.Close;
      tempQuery.SQL.Clear;
    end;
end;

function getClientDataWUI_uniq(const pClientId: integer): TClientData;
var
  psql: AStr;
begin
  // varem võtsin andmed cachest ! aga see pole hea idee, caches mõtet hoida klienti reg kood, nimi ja id
  // muidu lihtsalt raiskame mälu; see lihtpäring ei võta ka aega !
  with estbk_clientdatamodule.dmodule do
    try
      tempQuery.Close;
      tempQuery.SQL.Clear;

      psql := estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id, pClientId);
      tempQuery.SQL.add(psql);
      tempQuery.Open;


      // reloadCustQuery(pcustId);
      Result := TframeCustomers.datasetToClientDataClass(tempQuery);
    finally
      tempQuery.Close;
      tempQuery.SQL.Clear;
    end;
end;

// ----------------------------------------------------------------------------

function buildFullClientAddrFromCstData(const pClientData: TClientData): AStr;
begin
  Result := '';
  if assigned(pClientData) then
    Result := estbk_utilities.miscGenBuildAddr(pClientData.FCustJCountry, pClientData.FCustJCounty, pClientData.FCustJCity,
      pClientData.FCustJStreet, pClientData.FCustJHouseNr, pClientData.FCustJApartNr, pClientData.FCustJZipCode);
end;

// ----------------------------------------------------------------------------
// õudne tabide keemia
procedure TframeCustomers.onSrcFrameStreetExitEvnt(Sender: TObject);
var
  pForceNext: boolean;
begin
  pForceNext := FFrameSrcAddr.LastKeyTabOrEnter;
  if assigned(FOnSrcFrameStreetExit) then
    FOnSrcFrameStreetExit(Sender);

  if pForceNext and lblEdtHousrnr.CanFocus then
    lblEdtHousrnr.SetFocus;
end;

constructor TframeCustomers.Create(frameOwner: TComponent);
var
  i, ptmpIndx: integer;
  pr: AStr;
begin
  try
    // -------
    inherited Create(frameOwner);
    // -------

    //FFrameCustAddr:=TFrameAddrPicker.create(self);
    FFrameCustAddr := TFrameAddrPicker.Create(nil);
    FFrameCustAddr.Name := 'frame' + inttohex(random(99999), 6);
    FFrameCustAddr.parent := tabNameAddrData;
    FFrameCustAddr.Visible := True;

    FFrameCustAddr.left := 6;
    FFrameCustAddr.Width := 484;
    FFrameCustAddr.Height := 69;

    FFrameCustAddr.top := 164;
    FFrameCustAddr.liveMode := True;

    FFrameCustAddr.lbCounty.left := FFrameCustAddr.lbCounty.left + 3;
    FFrameCustAddr.lbCounty.Font.Style := [fsbold];

    FFrameCustAddr.lbCity.left := FFrameCustAddr.lbCity.left + 3;
    FFrameCustAddr.lbCity.Font.Style := [fsbold];

    FFrameCustAddr.lbStreet.left := FFrameCustAddr.lbStreet.left + 3;
    FFrameCustAddr.lbStreet.Font.Style := [fsbold];

    //FFrameCustAddr.TabOrder := cmbCountry.TabOrder + 1;
    FFrameCustAddr.TabOrder := dummyTabFix.TabOrder;
    dummyTabFix.tabStop := False;



    FFrameCustAddr.onDataChange := @onCustomerDataAddrChange;



    // -----------------
    FFrameSrcAddr := TFrameAddrPicker.Create(nil);
    FFrameSrcAddr.left := 11;
    FFrameSrcAddr.Width := 470;
    FFrameSrcAddr.Height := 70;
    FFrameSrcAddr.top := 149;
    FFrameSrcAddr.Name := 'srcframe' + inttohex(random(99999), 6);
    FFrameSrcAddr.parent := tabSearch;
    FFrameSrcAddr.Visible := True;



    FFrameSrcAddr.liveMode := False;
    FFrameSrcAddr.TabStop := True;
    FFrameSrcAddr.TabOrder := cmbSrcCountry.TabOrder + 1;


    FFrameSrcAddr.lbCounty.left := FFrameCustAddr.lbCounty.left + 1;
    FFrameSrcAddr.lbCounty.Font.Style := [fsbold];

    FFrameSrcAddr.lbCity.left := FFrameCustAddr.lbCity.left + 1;
    FFrameSrcAddr.lbCity.Font.Style := [fsbold];

    FFrameSrcAddr.lbStreet.left := FFrameCustAddr.lbStreet.left + 1;
    FFrameSrcAddr.lbStreet.Font.Style := [fsbold];

    cmbCustType.items.add('');
    cmbCustType.items.add(estbk_strmsg.CSCustJurPer);
    cmbCustType.items.add(estbk_strmsg.CSCustPrivPer);



    //FFrameSrcAddr.tabOrder      := lblEdtLastname.tabOrder + 1;
    FFrameSrcAddr.TabOrder := dummyTabFix1.TabOrder;
    FFrameSrcAddr.TabStop := True;
    dummyTabFix1.TabStop := False;

    // täielik kammajaaa on tabidega; annad küll õige taborderi, aga visuaalne pool läheb ikka metsa puid lõhkuma
    FOnSrcFrameStreetExit := FFrameSrcAddr.OnExit;
    FFrameSrcAddr.OnExit := @onSrcFrameStreetExitEvnt;




    customerType := _csTypeAsStandard;

    // vaikimisi on kliendi andmete leht peidetud
    //tabCustomerData.TabVisible := False;


    FDefaultCountryIndx := -1;

    for i := 0 to estbk_globvars.glob_preDefCountryCodes.Count - 1 do
    begin
      pr := estbk_globvars.glob_preDefCountryCodes.ValueFromIndex[i];
      system.Delete(pr, 1, pos(':', pr)); // võtame riigi nimel lühikese prefiksi eest ära EST=EE:Eesti

      ptmpIndx := cmbCountry.items.AddObject(pr, TObject(PtrUInt(i)));
      if AnsiUpperCase(estbk_globvars.glob_preDefCountryCodes.Names[i]) = estbk_globvars.Cglob_DefaultCountryCodeISO3166_1 then
        FDefaultCountryIndx := ptmpIndx;

    end;


    cmbCountry.ItemIndex := FDefaultCountryIndx;
    // 06.09.2011 Ingmar; otsingus ka riik
    cmbSrcCountry.Items.Assign(cmbCountry.Items);
    cmbSrcCountry.ItemIndex := FDefaultCountryIndx;
    // --
    estbk_uivisualinit.__preparevisual(self);


    tabCtrlCustomer.ActivePage := tabSearch;
    tabCustomerCommData.ActivePage := tabNameAddrData;

    FsaveDataAndClose := True;
  except
    on e: Exception do
      Dialogs.messagedlg(format(estbk_strmsg.SEInitializationZError, [e.message, ClassName]), mtError, [mbOK], 0);
  end;
end;

destructor TframeCustomers.Destroy;
begin
  dmodule.notifyNumerators(PtrUInt(self));
  // ----
  FreeAndNil(FFrameCustAddr);
  FreeAndNil(FFrameSrcAddr);
  inherited Destroy;
end;

procedure TframeCustomers.setNewUsrBtnVis(const v: boolean);
begin
  btnNewClient.Visible := v;
  if not v then
    tabCustomerData.TabVisible := False;
end;

function TframeCustomers.getNewUsrBtnVis: boolean;
begin
  Result := btnNewClient.Visible;
end;

function TframeCustomers.getDataLoadStatus: boolean;
begin
  Result := False;
end;

procedure TframeCustomers.showCustomers(const custcnt: integer = CMaxCustomerCount);
var
  pSQL: AStr;
begin
  with qryInsUptClient, SQL do
  begin
    Close;
    Clear;

    pSQL := estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id);
    add(pSQL);
    Open;
    lblCustTotal.Caption := IntToStr(RecordCount) + #32;


    // --
    estbk_utilities.changeWCtrlEnabledStatus(tabCustomerCommData, not qryInsUptClient.EOF);
    tabCustomerCommData.Enabled := True;
  end;
end;

procedure TframeCustomers.setDataLoadStatus(const v: boolean);
begin
  qryInsUptClientCPersons.Close;
  qryInsUptClientCPersons.SQL.Clear;

  qryBanks.Close;
  qryBanks.SQL.Clear;
  // ---
  qryInsUptClientSQL.ModifySQL.Clear;
  qryInsUptClientSQL.InsertSQL.Clear;

  qryInsUptClient.Close;
  qryInsUptClient.SQL.Clear;

  qryBanks.Close;
  qryBanks.SQL.Clear;

  qryInsUptClientCPersonsUptIns.ModifySQL.Clear;
  qryInsUptClientCPersonsUptIns.InsertSQL.Clear;
  qryInsUptClientCPersonsUptIns.DeleteSQL.Clear;

  tabCtrlCustomer.ActivePage := tabSearch;

  // frame probleemid, et connection unustatakse ära !!!
  case v of
    True:
    begin

      //qryGetCustomer.connection    := estbk_clientdatamodule.dmodule.primConnection;
      //qryInsUptCustomer.connection  := estbk_clientdatamodule.dmodule.primConnection;

      qryValidateDataQry.connection := estbk_clientdatamodule.dmodule.primConnection;
      qryInsUptClient.connection := estbk_clientdatamodule.dmodule.primConnection;
      qryInsUptClientCPersons.connection := estbk_clientdatamodule.dmodule.primConnection;


      // 25.12.2009 Ingmar; muutsin kliendi osa globaalseks !!!
      qryInsUptClientSeq.SequenceName := 'client_id_seq';
      qryInsUptClientSeq.connection := estbk_clientdatamodule.dmodule.primConnection;



      qryInsUptClientCPersonsSeq.SequenceName := 'client_contact_persons_id_seq';
      qryInsUptClientCPersonsSeq.connection := estbk_clientdatamodule.dmodule.primConnection;




      qryInsUptClientSQL.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdateClient);
      qryInsUptClientSQL.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertClient);


      // --

      qryInsUptClientCPersonsUptIns.InsertSQL.add(estbk_sqlclientcollection._SQLInsertClientCPersons2);
      qryInsUptClientCPersonsUptIns.ModifySQL.add(estbk_sqlclientcollection._SQLUpdateClientCPersons);
      qryInsUptClientCPersonsUptIns.DeleteSQL.add(estbk_sqlclientcollection._SQLDeleteClientCPersons);



      qryInsUptClientCPersons.SQL.Add(estbk_sqlclientcollection._SQLSelectClientCPersons);


      FFrameCustAddr.connection := estbk_clientdatamodule.dmodule.primConnection;
      FFrameCustAddr.loadData := True;
      FFrameCustAddr.liveMode := True;


      FFrameSrcAddr.connection := estbk_clientdatamodule.dmodule.primConnection;
      FFrameSrcAddr.loadData := True;
      FFrameSrcAddr.liveMode := False;


      showCustomers();




      // 25.12.2009 Ingmar; kuna viisin kliendi query globaalsesse datamoodulisse, siis tuleb afterscroll teha korra !
      qryInsUptClientAfterScroll(qryInsUptClient);


      // selle peaks ka vist viima datamoodulisse; vähem pNewContactPäringuid, samas kas mitu datasourcet sama qry peal ei tekita probleeme !
      qryBanks.Connection := estbk_clientdatamodule.dmodule.primConnection;
      qryBanks.SQL.Add(estbk_sqlclientCollection._SQLSelectBanks);
      qryBanks.ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      qryBanks.active := v;


      tabCtrlCustomer.ActivePage := tabSearch;
      tabCustomerCommData.ActivePage := tabNameAddrData;
    end;

    False:
    begin
      //qryGetCustomer.connection    := nil;
      //qryInsUptCustomer.connection    := nil;
      //qryInsUptCustomerSeq.connection := nil;
      qryValidateDataQry.connection := nil;
      qryBanks.Connection := nil;
      qryInsUptClient.connection := nil;
      //qryInsUptCustSQL.ModifySQL.Clear;
      //qryInsUptCustSQL.InsertSQL.Clear;
    end;
  end;
end;



procedure TframeCustomers.btnSearchClick(Sender: TObject);
const
  CMinlength = 3;

var
  pClientId: integer;
  psql: AStr;
  pHouseNr: AStr;
  pApartmentNr: AStr;
  pRegNr: AStr;
  pName: AStr;
  pLastName: AStr;
  pClientExt: AStr;
  pCountryCode: AStr;
begin
  // ---
  if not verifyIsDataSaved then
    exit;


  pHouseNr := trim(lblEdtHousrnr.Text);
  pApartmentNr := trim(lblEdtApartmentnr.Text);
  pRegNr := trim(lblEdtRegnr.Text);
  pName := trim(lblEdtCName.Text);
  pLastName := trim(lblEdtLastname.Text);
  pClientExt := trim(edtClientId.Text);

  pClientId := -1;
  //  if edtClientId.Text <> '' then
  //     pClientId := strtointdef(edtClientId.Text, 0);
  // 12.02.2011 Ingmar; päring kliendi tunnuse järgi käib nüüd läbi client_id_ext
{
  if (pClientExt='') and (pRegNr = '') and (pName = '') and
    (pLastName = '') and (FFrameSrcAddr.countyId = 0) and
    (FFrameSrcAddr.cityId = 0) and (FFrameSrcAddr.streetId = 0) and
    (pHouseNr = '') and (pApartmentNr = '') then
  begin
    Dialogs.messageDlg(estbk_strmsg.SESrcParamsAreMissing, mtError, [mbOK], 0);
    edtClientId.SetFocus;
    exit;
  end;
}

  if ((pHouseNr <> '') and (pApartmentNr <> '')) and (FFrameSrcAddr.cityId = 0) and (FFrameSrcAddr.streetId = 0) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SESrcParamsIncomplete, mtError, [mbOK], 0);
    FFrameSrcAddr.comboCity.SetFocus;
    exit;
  end;

  if (pRegNr <> '') and (length(pRegNr) < CMinlength) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SESrcParamsTooShort, mtError, [mbOK], 0);
    lblEdtRegnr.SetFocus;
    exit;
  end;

  if (pName <> '') and (length(stringreplace(pName, '%', '', [rfReplaceAll])) < CMinlength) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SESrcParamsTooShort, mtError, [mbOK], 0);
    lblEdtCName.SetFocus;
    exit;
  end;

  if (pLastName <> '') and (length(stringreplace(pLastName, '%', '', [rfReplaceAll])) < CMinlength) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SESrcParamsTooShort, mtError, [mbOK], 0);
    lblEdtLastname.SetFocus;
    exit;
  end;


  // --
  with estbk_clientdatamodule.dmodule, qryInsUptClient, SQL do
  begin

    pCountryCode := estbk_globvars.glob_preDefCountryCodes.Names[PtrUInt(cmbSrcCountry.Items.Objects[cmbSrcCountry.ItemIndex])];

    Close;
    Clear;
    psql := estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id, pClientId, pRegNr,
      pName, pLastName, FFrameSrcAddr.countyId, FFrameSrcAddr.cityId, FFrameSrcAddr.streetId, pHouseNr, pApartmentNr, pClientExt, pCountryCode);
    // ---
    add(psql);
    Open;
    lblCustTotal.Caption := IntToStr(RecordCount) + #32;

    First;
    if EOF then
    begin
      // ikka vaja välja kutsuda !
      qryInsUptClientAfterScroll(qryInsUptClient);
      Dialogs.messageDlg(estbk_strmsg.SEQryRetNoData, mtInformation, [mbOK], 0);
    end
    else
      dbGridCustSearch.SetFocus;
    estbk_utilities.changeWCtrlEnabledStatus(tabCustomerCommData, not EOF);

    // ---
    //btnChoose.Enabled := not EOF;
    //btnEdit.Enabled   := not EOF;
    // ---
  end;

end;



// kas on tarnija või mitte... nii lihtne see ongi
procedure TframeCustomers.chkSupplierChange(Sender: TObject);
var
  pNewEdtMode: boolean;
begin
  if TCheckbox(Sender).Focused then
    with qryInsUptClient do
      try
        pNewEdtMode := not (State in [dsEdit, dsInsert]);
        if pNewEdtMode then
          Edit;


        if TCheckbox(Sender).Checked then
          FieldByName('type_').AsString := estbk_types.SCustomerTypeAsIdent[_csTypeAsSupplier]
        else
          FieldByName('type_').AsString := estbk_types.SCustomerTypeAsIdent[_csTypeAsStandard];

      finally
        if pNewEdtMode then
          Post;
      end;
  // pNewEdtMode:=not .
end;

// ############################################################################

procedure TframeCustomers.onCustomerDataAddrChange(Sender: TObject);
var
  pNewSession: boolean;
begin

  if not FSkipScrollEvent then
  begin
    btnSave.Enabled := True;
    btnCancel.Enabled := True;


    // 08.08.2011 Ingmar; Evea teates, et aadressi ei õnnestu uuendada;
    // Vaatan, et mis värk on...ja selgub - BeforePost event kutsutakse välja vaid siis, kui mõni database objekt on red. reziimis
    // Aadressi valik pole DB objekt !
    try
      pNewSession := not (qryInsUptClient.State in [dsEdit, dsInsert]);
      if pNewSession then
        qryInsUptClient.Edit;
      // Antud kood on Before postis !
      qryInsUptClient.FieldByName('county_id').AsInteger := FFrameCustAddr.countyId;
      qryInsUptClient.FieldByName('city_id').AsInteger := FFrameCustAddr.cityId;
      qryInsUptClient.FieldByName('street_id').AsInteger := FFrameCustAddr.streetId;
    finally
      if pNewSession then
        qryInsUptClient.Post; // ---
    end;
  end;
  // ---
end;


procedure TframeCustomers.cmbCountryChange(Sender: TObject);
begin
  with TComboBox(Sender) do
    if Focused and (ItemIndex >= 0) then
    begin
      FFrameCustAddr.country := estbk_globvars.glob_preDefCountryCodes.names[PtrUInt(items.Objects[ItemIndex])];
      // isikutüübiga sama käitumisloogika !
      cmbCustTypeChange(Sender);
    end;
end;


procedure TframeCustomers.cmbCustTypeChange(Sender: TObject);
var
  pNewPtEvent: boolean;
  b: boolean;
begin
  with TComboBox(Sender) do
    if Focused then
    begin
      pNewPtEvent := not (qryInsUptClient.State in [dsEdit, dsInsert]);
      if pNewPtEvent then
        qryInsUptClient.Edit;

      b := (ItemIndex <> CComboIdxLegalPerson);
      if b then
      begin
        lblLastname.Enabled := True;
        dbEdtCustomerLastname.Enabled := True;
        dbEdtCustomerLastname.Color := clWindow;
      end
      else
      begin
        lblLastname.Enabled := False;
        dbEdtCustomerLastname.Enabled := False;
        dbEdtCustomerLastname.Text := '';
        dbEdtCustomerLastname.Color := MyFavGray;
      end;


      // --- ei peagi midagi rohkemat tegema, after post paneb parameetrid paika !
      if pNewPtEvent then
        qryInsUptClient.Post;
    end;
  // -------
end;

procedure TframeCustomers.cmbCustTypeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
  // --
end;

procedure TframeCustomers.cmbSrcCountryExit(Sender: TObject);
begin
  // --- 09.09.2011 Ingmar; fookuse hack !
  if FForceTabKeyCode and FFrameSrcAddr.comboCounty.CanFocus then
    FFrameSrcAddr.comboCounty.SetFocus;

  FForceTabKeyCode := False;
end;

procedure TframeCustomers.cmbSrcCountryKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  FForceTabKeyCode := (key = VK_TAB) or (key = VK_RETURN);
end;

procedure TframeCustomers.dbGridCustSearchDblClick(Sender: TObject);
var
  pCustData: TClientData;
  pSQL: AStr;
begin
  //if not TDBGrid(Sender).DataSource.DataSet.EOF then
  if TDBGrid(Sender).DataSource.DataSet.RecordCount > 0 then
  begin

    // 05.08.2010 Ingmar; kliendi kontaktid
    with qryInsUptClientCPersons, SQL do
      try
        FSkipScrollEvent := True;
        Close;
        paramByname('client_id').AsInteger := TDBGrid(Sender).DataSource.DataSet.FieldByName('id').AsInteger;
        Open;
      finally
        FSkipScrollEvent := False;
      end;



    if not FchooseCustomerMode then
    begin
      tabCtrlCustomer.ActivePage := tabCustomerData;
      tabCustomerCommData.ActivePage := tabNameAddrData;

      if cmbCustType.CanFocus then
        cmbCustType.SetFocus;
    end;


    // ---
    if assigned(FFrameItemChoosen) then
    begin
      pCustData := datasetToClientDataClass(TDBGrid(Sender).DataSource.DataSet);
      // ----
      FFrameItemChoosen(self, pCustData);

        {
        FFrameItemChoosen(self,
          FieldByName('id').AsInteger,
          0,
          FieldByName('regnr').AsString,
          trim(FieldByName('custname').AsString + #32 +
          FieldByName('lastname').AsString),
          '');}
    end;
  end;
end;

procedure TframeCustomers.dbGridCustSearchDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
var
  pAddr: AStr;
begin
  with TDBGrid(Sender) do
  begin
    Canvas.FillRect(Rect);

    // viimane hetkel aadress, ehitame nö aadressi valmis
    if Column.Index = TDBGrid(Sender).Columns.Count - 1 then
    begin
      if not TDBGrid(Sender).DataSource.DataSet.EOF then
        pAddr := estbk_utilities.miscGenBuildAddr(TDBGrid(Sender).DataSource.DataSet.FieldByName('countrycode').AsString,
          TDBGrid(Sender).DataSource.DataSet.FieldByName('countyname').AsString,
          TDBGrid(Sender).DataSource.DataSet.FieldByName('cityname').AsString,
          TDBGrid(Sender).DataSource.DataSet.FieldByName('streetname').AsString,
          TDBGrid(Sender).DataSource.DataSet.FieldByName('house_nr').AsString,
          TDBGrid(Sender).DataSource.DataSet.FieldByName('apartment_nr').AsString,
          TDBGrid(Sender).DataSource.DataSet.FieldByName('zipcode').AsString)
      else
        pAddr := '';
      Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, pAddr);
    end
    else
    if assigned(Column.Field) then
      Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, Column.Field.AsString);
  end;
  // -------
end;

procedure TframeCustomers.dbGridCustSearchKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = []) then
  begin
    dbGridCustSearchDblClick(dbGridCustSearch);
    key := 0;
  end;
end;

procedure TframeCustomers.dbGridCustSearchPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin
  // visuaaselt polnud hea !
  //estbk_utilities.miscdbGridRowHighLighter(Sender as TDbGrid,AState);
end;

procedure TframeCustomers.dbRcvBankListClosePopupNotif(Sender: TObject);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeCustomers.dbRcvBankListSelect(Sender: TObject);
begin
  with  TRxDBLookupCombo(Sender) do
    if (Value <> '') then
    begin
      LookupSource.DataSet.Locate('id', Value, []);
      Text := LookupSource.DataSet.FieldByName('bankname').AsString;
    end;
end;




procedure TframeCustomers.gridCustCPersonKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = []) then
    with TDbGrid(Sender).DataSource.DataSet do
      if active then
      begin
        if State in [dsEdit, dsInsert] then
          Post;
        key := 0;
      end;
end;

procedure TframeCustomers.pDeleteContactPClick(Sender: TObject);
begin
  with qryInsUptClientCPersons do
    if Active then
    begin
      if State in [dsEdit, dsInsert] then
        Post;
      // ---
      Delete;
    end;
end;

procedure TframeCustomers.pNewContactPClick(Sender: TObject);
begin
  with qryInsUptClientCPersons do
    if Active then
    begin
      // --
      if State = dsEdit then
        Post
      else
      if State = dsInsert then
        Exit;

      First;
      // --
      Insert;
    end;
end;




procedure TframeCustomers.qryInsUptClientAfterEdit(DataSet: TDataSet);
begin

  FDataNotSaved := True;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
  btnNewClient.Enabled := False;
end;

procedure TframeCustomers.qryInsUptClientAfterInsert(DataSet: TDataSet);
begin
  // 22.04.2011 Ingmar
  Dataset.FieldByName('client_code').AsString := dmodule.getUniqNumberFromNumerator(PtrUInt(self), '', now, False,
    estbk_types.CClientId_idef, False);



end;

procedure TframeCustomers.qryInsUptClientAfterScroll(DataSet: TDataSet);
var
  pCountryCode: AStr;
  i: integer;
begin

  if not FNewRecordCreated then
  begin
    cmbCountry.ItemIndex := FDefaultCountryIndx;
    // pCountyCode := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;
    pCountryCode := DataSet.FieldByName('countrycode').AsString;



    //if cmbCountry.ItemIndex >= 0 then
    for i := 0 to cmbCountry.items.Count - 1 do
      if estbk_globvars.glob_preDefCountryCodes.Names[PtrUInt(cmbCountry.Items.Objects[i])] = pCountryCode then
      begin
        cmbCountry.ItemIndex := i;
        break;
      end;


    // DataSet.FieldByName('countrycode').AsString := pCountryCode;
    // showmessage(DataSet.FieldByName('countrycode').AsString);
    FFrameCustAddr.country := pCountryCode; // peab olema esimene !!!!



    FFrameCustAddr.countyId := DataSet.FieldByName('county_id').AsInteger;
    FFrameCustAddr.cityId := DataSet.FieldByName('city_id').AsInteger;
    FFrameCustAddr.streetId := DataSet.FieldByName('street_id').AsInteger;

    // ---
    if DataSet.FieldByName('ctype').AsString = estbk_types.CCust_PType then
      cmbCustType.ItemIndex := CComboIdxPrivatePerson
    else
      cmbCustType.ItemIndex := CComboIdxLegalPerson;
    FCurrentCustId := DataSet.FieldByName('id').AsInteger;



    // 12.02.2010 Ingmar
    chkSupplier.Checked := pos(estbk_types.SCustomerTypeAsIdent[_csTypeAsSupplier], DataSet.FieldByName('type_').AsString) > 0;
  end;
  // --

  // 05.08.2010 Ingmar
  if DataSet.Active then
  begin
    qryInsUptClientCPersons.Close;
    qryInsUptClientCPersons.ParamByname('client_id').AsInteger := DataSet.FieldByName('id').AsInteger;
    qryInsUptClientCPersons.Open;
  end;
  // --
end;

procedure TframeCustomers.qryInsUptClientBeforeInsert(DataSet: TDataSet);
begin
  // lipud
  FDataNotSaved := True;
  FNewRecordCreated := True;

  // ---
  cmbCustType.ItemIndex := 0;
  cmbCountry.ItemIndex := FDefaultCountryIndx;
  FFrameCustAddr.country := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;
  FFrameCustAddr.countyId := 0;
  FFrameCustAddr.cityId := 0;
  FFrameCustAddr.streetId := 0;
end;

procedure TframeCustomers.qryInsUptClientBeforePost(DataSet: TDataSet);
var
  pCountyCode: AStr;
  pCRC32: DWord;
  pFullname: AStr;
begin

  DataSet.FieldByName('county_id').AsInteger := FFrameCustAddr.countyId;
  DataSet.FieldByName('city_id').AsInteger := FFrameCustAddr.cityId;
  DataSet.FieldByName('street_id').AsInteger := FFrameCustAddr.streetId;
  DataSet.FieldByName('rec_changed').AsDateTime := now;



  if FNewRecordCreated then
  begin
    DataSet.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
    DataSet.FieldByName('company_id').AsInteger := estbk_globvars.glob_company_id;
  end;

  // 17.06.2010 ingmar;
  pCRC32 := 0;
  pFullname := UpperCase(trim(Dataset.FieldByName('custname').AsString + ' ' + Dataset.FieldByName('lastname').AsString));
  if pFullname <> '' then
    estbk_crc32.CRC32(@pFullname[1], length(pFullname), pCRC32);
  DataSet.FieldByName('srcval').AsLargeInt := pCRC32;
  DataSet.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;


  // ----
  pCountyCode := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;
  if cmbCountry.ItemIndex >= 0 then
    pCountyCode := estbk_globvars.glob_preDefCountryCodes.names[cardinal(cmbCountry.Items.Objects[cmbCountry.ItemIndex])];
  DataSet.FieldByName('countrycode').AsString := pCountyCode;




  // ---
  case cmbCustType.ItemIndex of
    CComboIdxPrivatePerson: DataSet.FieldByName('ctype').AsString := estbk_types.CCust_PType; // personal
    CComboIdxLegalPerson: DataSet.FieldByName('ctype').AsString := estbk_types.CCust_LType; // legal
    else
      DataSet.FieldByName('ctype').AsString := '';
  end;
end;

procedure TframeCustomers.qryInsUptClientCPersonsAfterClose(DataSet: TDataSet);
var
  i: integer;
begin
  for i := 0 to pGridActions.Items.Count - 1 do
    pGridActions.Items[i].Enabled := False;
end;

procedure TframeCustomers.qryInsUptClientCPersonsAfterInsert(DataSet: TDataSet);
begin
  qryInsUptClientAfterEdit(DataSet);
  if DataSet.Active then
  begin
    DataSet.FieldByName('client_id').AsInteger := FCurrentCustId;
    DataSet.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
  end; // --
end;


procedure TframeCustomers.qryInsUptClientCPersonsAfterOpen(DataSet: TDataSet);
var
  i: integer;
begin
  for i := 0 to pGridActions.Items.Count - 1 do
    pGridActions.Items[i].Enabled := True;
end;

procedure TframeCustomers.qryInsUptClientCPersonsAfterScroll(DataSet: TDataSet);
begin
  // --
end;

procedure TframeCustomers.qryInsUptClientCPersonsBeforeDelete(DataSet: TDataSet);
var
  pNewSession: boolean;
begin
  // --
  pNewSession := not (DataSet.State in [dsEdit, dsInsert]);
  try
    if pNewSession then
      Dataset.Edit;

    DataSet.FieldByName('rec_changed').AsDateTime := now;
    DataSet.FieldByName('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;


  finally
    if pNewSession then
      Dataset.Post;
  end;
end;

procedure TframeCustomers.qryInsUptClientCPersonsBeforePost(DataSet: TDataSet);
begin
  // zeose kala !
  if DataSet.Active then
  begin
    DataSet.FieldByName('rec_changed').AsDateTime := now;
    DataSet.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  end;
end;

procedure TframeCustomers.tabCtrlCustomerChange(Sender: TObject);
begin
  // --
end;



function TframeCustomers.verifyIsDataSaved: boolean;
begin
  Result := not FDataNotSaved;
  if FDataNotSaved then
  begin
    Dialogs.messageDlg(estbk_strmsg.SConfBfScrollSaveChg, mtInformation, [mbOK], 0);
    tabCtrlCustomer.ActivePage := tabCustomerData;
    tabCustomerCommData.ActivePage := tabNameAddrData;
  end;
  // ---
end;

// 25.12.2009 ingmar; muutsin klassipõhiseks !!!
class function TframeCustomers.datasetToClientDataClass(const dataset: TDataset): TClientData;
begin
  Result := nil;
  if assigned(dataset) and not dataset.IsEmpty then
    with dataset do
    begin

      Result := TClientData.Create;
      Result.FClientId := FieldByName('id').AsInteger;

      Result.FCustFirstname := FieldByName('custname').AsString;
      Result.FCustLastname := FieldByName('lastname').AsString;

      Result.FCustJCountry := FieldByName('countrycode').AsString;
      Result.FCustJCounty := FieldByName('countyname').AsString;
      Result.FCustJCity := FieldByName('cityname').AsString;
      Result.FCustJStreet := FieldByName('streetname').AsString;
      Result.FCustJHouseNr := FieldByName('house_nr').AsString;
      Result.FCustJApartNr := FieldByName('apartment_nr').AsString;
      Result.FCustJZipCode := FieldByName('zipcode').AsString;

      Result.FCustPAddr := FieldByName('postal_addr').AsString;
      // result.FCustRepr:=FieldByName('contact_person').AsString; esindajaid võib nüüd mitu olla !
      Result.FCustCredLimit := FieldByName('credit_limit').AsFloat;
      Result.FCustVatNr := FieldByName('vatnumber').AsString; // !!!!!!!!
      Result.FCustDueTime := FieldByName('payment_duetime').AsInteger;

      // 28.02.2010
      Result.FCustEmail := FieldByName('email').AsString;
      Result.FCustWebPage := FieldByName('webpage').AsString;
      Result.FCustPhone := FieldByName('phone').AsString;

      Result.FCustPurchRefNr := FieldByName('prefnumber').AsString;
      Result.FCustContrRefNr := FieldByName('crefnumber').AsString;
      Result.FCustBankAccount := FieldByName('bank_accounts').AsString;
      Result.FCustBankId := FieldByName('bank_id').AsInteger;
      // 11.04.2013 Ingmar; kliendi tüüp oli puudu !!!!
      Result.FCustType := FieldByName('ctype').AsString;
      Result.FCustRegNr := FieldByName('regnr').AsString; // !!!!!!!!

      // 12.02.2011 Ingmar
      Result.FClientCode := FieldByName('client_code').AsString;
    end;
end;

procedure TframeCustomers.btnCloseSrcPageClick(Sender: TObject);
begin
  if assigned(FframeKillSignal) then
    FframeKillSignal(self);
end;

procedure TframeCustomers.btnCleanClick(Sender: TObject);
begin
  if not verifyIsDataSaved then
    exit;

  FForceTabKeyCode := False;
  edtClientId.Text := '';
  lblEdtRegnr.Text := '';
  lblEdtCName.Text := '';
  lblEdtLastname.Text := '';
  lblEdtHousrnr.Text := '';
  lblEdtApartmentnr.Text := '';

  FFrameSrcAddr.country := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;
  FFrameSrcAddr.countyId := 0;
  FFrameSrcAddr.cityId := 0;
  FFrameSrcAddr.streetId := 0;

  if edtClientId.canFocus then
    edtClientId.SetFocus;

  showCustomers;
  cmbSrcCountry.ItemIndex := FDefaultCountryIndx;
end;

procedure TframeCustomers.btnCancelClick(Sender: TObject);
begin
  //     pOrig:=FCurrentClientId;
  btnSave.Enabled := False;
  btnCancel.Enabled := False;


  qryInsUptClient.CancelUpdates;
  // 05.08.2010 Ingmar
  qryInsUptClientCPersons.CancelUpdates;




  // ----
  //estbk_utilities.changeWCtrlEnabledStatus(tabCustomerCommData,(pOrig>0));

  if displaySrcTab and FNewRecordCreated then
  begin
    //tabCtrlCustomer.ActivePage := tabSearch;
    btnNewClient.Enabled := True;
  end
  else
  begin
    estbk_utilities.changeWCtrlEnabledStatus(tabCustomerCommData, not qryInsUptClient.EOF);
  end;

  FDataNotSaved := False;
  FNewRecordCreated := False;

  // ---
  qryInsUptClientAfterScroll(qryInsUptClient);
end;

procedure TframeCustomers.forceFocus(const pSelectClientId: integer);
begin
  if dbGridCustSearch.CanFocus then
    dbGridCustSearch.SetFocus;

  // ---
  qryInsUptClient.DisableControls;
  qryInsUptClient.Locate('id', pSelectClientId, []);
  qryInsUptClient.EnableControls;
end;

procedure TframeCustomers.addNewClient;
begin
  FCurrentCustId := 0;
  qryInsUptClient.Insert;

  // ---
  qryInsUptClientCPersons.Close;
  qryInsUptClientCPersons.paramByname('client_id').AsInteger := 0;
  qryInsUptClientCPersons.Open;
  qryInsUptClientCPersons.Insert;
end;



procedure TframeCustomers.addNewClient(const pClientName: AStr; const pNameInRevOrder: boolean = False);
var
  pFirstname: AStr;
  pLastname: AStr;
  pFullname: AStr;
  pPos: integer;
  pIsRevName: boolean;

begin
  pIsRevName := pNameInRevOrder; // kas on TAMMEVÄLI INGMAR; mitte INGMAR TAMMEVÄLI

  pFirstname := '';
  pLastname := '';
  pFullname := trim(pClientName);
  pPos := pos(' ', pFullname);
  if pPos = 0 then
  begin
    pFirstname := pFullname;
    pIsRevName := False;
  end
  else
  begin
    pFirstname := copy(pFullname, 1, pPos - 1);
    if length(pFirstname) <= 2 then // AS / OÜ / KÜ
      pFirstname := pFullname
    else
    begin
      pLastname := trim(copy(pFullname, pPos + 1, length(pFullname) - pPos));
    end;
    // ---
  end;

  // ---
  //tabCtrlCustomer.ActivePage:=tabCustomerData;
  addNewClient;



  qryInsUptClient.Edit;
  if not pIsRevName then
  begin
    qryInsUptClient.FieldByName('custname').AsString := pFirstname;
    qryInsUptClient.FieldByName('lastname').AsString := pLastname;
  end
  else
  begin
    qryInsUptClient.FieldByName('custname').AsString := pLastname;
    qryInsUptClient.FieldByName('lastname').AsString := pFirstname;
  end;

  // 24.04.2011 Ingmar
  FsaveDataAndClose := True;

end;

procedure TframeCustomers.openClientRec(const clientID: integer);
var
  pSQL: AStr;
begin

  btnSave.Enabled := False;
  btnCancel.Enabled := False;

  FNewRecordCreated := False;
  FDataNotSaved := False;

  FCurrentCustId := clientId;
  // ---
  with qryInsUptClient, SQL do
    try
      FSkipScrollEvent := True;
      Close;
      Clear;
      pSQL := estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id, clientID);
      add(pSQL);
      Open;



      tabCustomerData.TabVisible := not EOF;
      tabCtrlCustomer.ActivePage := tabSearch;

      if tabCustomerData.TabVisible and (clientID > 0) then
        tabCustomerCommData.ActivePage := tabNameAddrData;

    finally
      FSkipScrollEvent := False;
    end;


  // 05.08.2010 Ingmar; kliendi kontaktid
  with qryInsUptClientCPersons, SQL do
    try
      FSkipScrollEvent := True;
      Close;
      paramByname('client_id').AsInteger := clientID;
      Open;
    finally
      FSkipScrollEvent := False;
    end;
end;

procedure TframeCustomers.btnNewClientClick(Sender: TObject);
begin
  estbk_utilities.changeWCtrlEnabledStatus(tabCustomerCommData, True);
  FFrameCustAddr.country := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;

  TButton(Sender).Enabled := False;
  //btnEdit.Enabled := False;

  tabCustomerData.TabVisible := True;
  tabCtrlCustomer.ActivePage := tabCustomerData;
  tabCustomerCommData.ActivePage := tabNameAddrData;

  if cmbCustType.CanFocus then
    cmbCustType.SetFocus;


  // --- !!!!!
  addNewClient();

  btnSave.Enabled := True;
  btnCancel.Enabled := True;
end;

procedure TframeCustomers.assignClientIdToCPerson;
var
  pBookmark: TBookmark;
begin
  try

    pBookmark := qryInsUptClientCPersons.GetBookmark;
    qryInsUptClientCPersons.DisableControls;

    if qryInsUptClientCPersons.State in [dsEdit, dsInsert] then
      qryInsUptClientCPersons.Post;

    qryInsUptClientCPersons.First;
    while not qryInsUptClientCPersons.EOF do
    begin
      qryInsUptClientCPersons.Edit;
      qryInsUptClientCPersons.FieldByName('client_id').AsInteger := FCurrentCustId;
      qryInsUptClientCPersons.Post;

      qryInsUptClientCPersons.Next;
    end;




  finally
    if assigned(pBookmark) then
    begin
      qryInsUptClientCPersons.GotoBookmark(pBookmark);
      qryInsUptClientCPersons.FreeBookmark(pBookmark);
    end;
    // --
    qryInsUptClientCPersons.EnableControls;
  end;
end;

procedure TframeCustomers.btnSaveClick(Sender: TObject);
var
  pClientName: AStr;
begin
  // -- et ikka oleks andmed ka kinnitatud ! enne andmebaasi transaktsiooni !!!
  //  @@@ enne valideerimist kinnitame ka andmed !
  if qryInsUptClient.State in [dsEdit, dsInsert] then
    qryInsUptClient.Post;

  // ---
  pClientName := trim(qryInsUptClient.FieldByName('custname').AsString) + trim(qryInsUptClient.FieldByName('lastname').AsString);
  if length(pClientName) < 2 then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEClientNameIsMissing, mtError, [mbOK], 0);

    if dbEdtCustomerName.canFocus then
      dbEdtCustomerName.SetFocus;
    exit;
  end;

  if cmbCustType.ItemIndex < 1 then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEClientPTypeIsMissing, mtError, [mbOK], 0);

    if cmbCustType.canFocus then
      cmbCustType.SetFocus;
    exit;
  end;


  // @@@
  // kontrollime kas sellise reg.koodiga klienti pole juba olemas !
  if trim(qryInsUptClient.FieldByName('regnr').AsString) <> '' then
    with qryValidateDataQry, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLVerifyCustRegCode);
        paramByname('regnr').AsString := qryInsUptClient.FieldByName('regnr').AsString;
        // 22.04.2012 Ingmar; klient on firma põhine !
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;
        First;

        //if not EOF and ((qryInsUptClient.FieldByName('id').AsInteger <>FCurrentCustId) or (FCurrentCustId=0)) then
        if not EOF and ((FieldByName('id').AsInteger <> FCurrentCustId) or (FCurrentCustId = 0)) then
        begin
          Dialogs.messageDlg(format(estbk_strmsg.SEClientWithSameRegCodeExists, [FieldByName('id').AsInteger]), mtError, [mbOK], 0);
          exit;
        end;

        // ---
      finally
        Close;
        Clear;
      end;


  // 22.04.2012 Ingmar;Sama kliendikoodi lubab panna !
  if trim(dbEdtClientCode.Text) <> '' then
    with qryValidateDataQry, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLVerifyClientCode);
        paramByname('client_code').AsString := qryInsUptClient.FieldByName('client_code').AsString;
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;
        First;

        if not EOF and ((FieldByName('id').AsInteger <> FCurrentCustId) or (FCurrentCustId = 0)) then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEClientWithSameCCodeExists, mtError, [mbOK], 0);
          exit;
        end;

      finally
        Close;
        Clear;
      end;




  // ---
  with estbk_clientdatamodule.dmodule do
    try

      primConnection.StartTransaction;


      // ---
      qryInsUptClient.ApplyUpdates;



      // ---
      if FNewRecordCreated then
      begin
        FCurrentCustId := qryInsUptClientSeq.GetCurrentValue;
        // asi selles, et me ei tea veel täiesti uue kliendi salvestamisel tema ID'd !
        assignClientIdToCPerson;
      end;




      // 05.08.2010 Ingmar; kliendikontaktid ka peale !
      qryInsUptClientCPersons.ApplyUpdates;



      // ---
      primConnection.Commit;
      qryInsUptClient.CommitUpdates;
      qryInsUptClientCPersons.CommitUpdates;




      btnNewClient.Enabled := True;
      TButton(Sender).Enabled := False;
      btnCancel.Enabled := False;



      if assigned(FFrameDataEvent) then
        FFrameDataEvent(self, estbk_types.__frameCustdataChanged, FCurrentCustId);




      // --- laeme ka globaalse kiirotsingu nimistu uuesti !!
      estbk_clientdatamodule.dmodule.reloadSharedCustData();



      // 22.04.2011 Ingmar
      if FsaveDataAndClose and FNewRecordCreated then
        dbGridCustSearchDblClick(dbGridCustSearch);


      // lipud maha
      FDataNotSaved := False;
      FNewRecordCreated := False;

    except
      on e: Exception do
      begin
        if primConnection.InTransaction then
          try
            primConnection.Rollback;
          except
          end;

        Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
      end;
      // -----------
    end;
end;


function TframeCustomers.getSrcTabStatus: boolean;
begin
  Result := tabSearch.TabVisible;
end;

procedure TframeCustomers.setSrcTagStatus(const v: boolean);
begin
  tabSearch.TabVisible := v;
  // pole pointi üleval tabe kuvada, kui otsingu osa puudub !
  tabCtrlCustomer.ShowTabs := v;

  // search tabi pole on vaid kliendi sisestus ja üldised andmed
  if not v then
    tabCtrlCustomer.ActivePage := tabCustomerData;
end;

procedure TframeCustomers.setCustomerType(const v: TCCustomerType);
begin
  FTCCustomerType := v;

  case v of
    _csTypeAsStandard:
    begin
      tabSearch.Caption := estbk_strmsg.SCaptOrdClientSrc;
      tabCustomerData.Caption := estbk_strmsg.SCaptOrdClientdata;
    end;


    _csTypeAsSupplier:
    begin
      tabSearch.Caption := estbk_strmsg.SCaptOrdSupplSrc;
      tabCustomerData.Caption := estbk_strmsg.SCaptOrdSuppldata;
    end;
  end;
end;

initialization
  {$I estbk_fra_customer.ctrs}

end.