unit estbk_fra_workcontract;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

{
[11:46:40] Ingmar Tammeväli: ja ka autokomp.
[11:46:45] Ingmar Tammeväli: siis oleks need kohe ära märgitud
[11:46:51] Ingmar Tammeväli: ja jookseks tasude lehele
[11:46:52] K: need võivad muutuda
[11:47:04] K: mis mõttega sa neid kusagil eraldi hoidma hakkad
[11:47:17] Ingmar Tammeväli: hetkel ma ei saanud aru, kus siis töötaja tasud määrad
[11:47:18] K: dokumendi väljatrükil täidad väljad tasude tabelist
[11:47:25] Ingmar Tammeväli: sa ju kuust kuusse ei hakka uuesti täitma
[11:47:29] K: üldises tasude tabelis
[11:47:50] Ingmar Tammeväli: :|aga lepingus peab põhipalk või tunnitasu olema määratud
[11:48:12] K: on töötaja üldandmed (isikukoodid jms) on töötaja tasude andmed (tasude tabelis)
[11:48:36] Ingmar Tammeväli: sinna peaks kohe saama lepingust
[11:48:52] K: no siis pead vähemalt dubleerima seda osa
[11:48:54] K: kui sa väga tahad
[11:49:04] K: peaasi, et tasude tabelis oleksid kõik tasud näha
[11:49:13] Ingmar Tammeväli: aga kuidas maksud tulevad
[11:49:19] Ingmar Tammeväli: ala kas samamoodi nagu bilanss sobiks
[11:49:25] Ingmar Tammeväli: ala et määrad mis rida kus võetakse
[11:49:30] Ingmar Tammeväli: mida arvutada lõppsumma jaoks
[11:49:46] K: maksud tulevad maksude tabelis, kus jah määrad a.la arvutusvalemid
[11:49:59] K: aga need arvutusvalemid peaksid olema nn if klausliga
[11:50:08] Ingmar Tammeväli: if ?
[11:50:11] Ingmar Tammeväli: mida see if teeb seal
[11:50:14] K: et kui töötajal on ristike, et arvutatakse maksuvaba, siis on valem selline
[11:50:27] K: kui töötajal ristikest pole, siis on valem natuke teistsugune
[11:50:37] Ingmar Tammeväli: aga miks ifi vaja
[11:50:41] Ingmar Tammeväli: sest lepingus ju öeldud
[11:50:54] Ingmar Tammeväli: võtab lepingust info
[11:51:27] K: jah, aga lepingust võtabki info, kas arvutab ühtmoodi või teistmoodi

[11:52:45] Ingmar Tammeväli: teisisõnu vaja tabelit maksud
[11:52:47] Ingmar Tammeväli: siis tasud
[11:52:56] Ingmar Tammeväli: siis töötaja palk, kus defineerid read ?
[11:53:14] Ingmar Tammeväli: olen õigel teel
[12:01:17] K: krt. ma pean mõtlema, mis kõige kiirem ja lihtsam lahendus oleks
[12:01:22] K: samas ta peab olema ka lollikindel
[12:01:40] Ingmar Tammeväli: ära vaeva hetkel pead, tee oma tööd, kui aega on, siis aita kaasa mõelda
[12:01:43] Ingmar Tammeväli: mina teeks nii
[12:01:48] Ingmar Tammeväli: eraldi vaated
[12:01:50] Ingmar Tammeväli: tasud, maksud
[12:01:58] Ingmar Tammeväli: siis nö fikseeritud tasu mall
[12:02:02] Ingmar Tammeväli: kus kirjeldatud ära palk
[12:02:06] Ingmar Tammeväli: mille saab töötajale lisada
[12:02:11] Ingmar Tammeväli: kus maksud värgid peal
[12:02:17] Ingmar Tammeväli: siis muudad lihtsalt numbrit
[12:02:27] Ingmar Tammeväli: maksud on vaimimisi määratud tasude juures
[12:02:33] Ingmar Tammeväli: ala linnukestega paned
[12:02:42] Ingmar Tammeväli: siis võtab arvesse lepigust eripärad
[12:02:45] Ingmar Tammeväli: kui arvutama hakkab
[12:02:47] K: mul ees Profiti palk ja see on väga jura
[12:02:58] K: pean mõtlema, et kuidas saavutada tulemust, et selline jura ei tuleks:D
[12:02:58] Ingmar Tammeväli: minu idee ka jura ?
[12:03:09] K: ei ole
[12:03:18] K: sinu idee on ehk täpselt see, mida ma ette kujutan
[12:03:28] K: aga võibolla miskit natuke profiti poolne
[12:03:41] Ingmar Tammeväli: ma teeks nii, minu pisike peake ütleb
[12:03:45] Ingmar Tammeväli: ntx on tasu põhipalk
[12:03:54] Ingmar Tammeväli: siis seal real ka lahtrid, kus saad linnukese panna
[12:04:00] Ingmar Tammeväli: sotsmaks, tulumaks ...
[12:04:05] Ingmar Tammeväli: siis need võetakse maha
[12:04:14] Ingmar Tammeväli: siis rida autokomp või puhkus või matusetasu
[12:04:16] Ingmar Tammeväli: mis sealt siis
[12:04:45] K: mulle tundub, et sinu pisike peake mõtleb täitsa hästi
[12:04:48] K: ja õigesti
[12:04:56] K: a'la nagu www.kalkulaator.ee lehel on toodud

[12:06:22] K: sa võta oma kujutlusse www.kalkulaator.ee toodud palgakalkulaator, aga ürita nuputada, et kuidas sarnast süsteemi kasutada näiteks 20ne töötaja puhul
}

uses
  Classes, SysUtils, FileUtil, LResources, LCLType, Forms, Controls, Dialogs, StdCtrls, Graphics, Math,
  DBCtrls, ExtCtrls, EditBtn, Grids, Buttons, estbk_fra_template, estbk_lib_commonevents,
  estbk_uivisualinit, estbk_lib_commoncls, estbk_clientdatamodule,
  estbk_sqlclientcollection, estbk_globvars, estbk_utilities, estbk_types,
  estbk_strmsg, DB, ZDataset, ZSqlUpdate, ZSequence,
  rxpopupunit, rxdbgrid, rxlookup;

type

  { TframeWorkContract }

  TframeWorkContract = class(Tfra_template)
    Bevel1: TBevel;
    Bevel2: TBevel;
    bh5: TBevel;
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnNew: TBitBtn;
    btnSave: TBitBtn;
    bv5: TBevel;
    chkSocialMinTaxCalc: TCheckBox;
    chkWorkerFullTime: TCheckBox;
    dbTextWorkername: TEdit;
    dbWorkIdCode: TEdit;
    qryAllFixedWageTypesDs: TDatasource;
    qryWorkContractDs: TDatasource;
    dbEdtContractNr: TDBEdit;
    dbEdtHolidayd: TDBEdit;
    dbEdtPosition: TDBEdit;
    dtContrdate: TDateEdit;
    dtTaxFreeCalcStart: TLabel;
    dtTaxFreePStart: TDateEdit;
    dtEarlyPensionDate: TDateEdit;
    dtWorkEnd: TDateEdit;
    dtWorkStart: TDateEdit;
    grpContract: TGroupBox;
    lblContractDate: TLabel;
    lblContractNr: TLabel;
    lblOrderEvents: TLabel;
    lblWorkEnd: TLabel;
    lblWorker: TLabel;
    lblWorkPosition: TLabel;
    lblWorkPosition1: TLabel;
    lblWorkPosition2: TLabel;
    lblWorkStart: TLabel;
    pContrPanel: TPanel;
    gridsalaryTypes: TStringGrid;
    qryWorkContract: TZQuery;
    qryWorkContractUpdt: TZUpdateSQL;
    qryWorkContractSeq: TZSequence;
    qryAllFixedWageTypes: TZQuery;
    focusFix: TTimer;
    qryTemp: TZQuery;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure chkWorkerFullTimeChange(Sender: TObject);
    procedure dbEdtContractNrKeyPress(Sender: TObject; var Key: char);
    procedure dtContrdateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
    procedure dtContrdateChange(Sender: TObject);
    procedure dtContrdateExit(Sender: TObject);
    procedure focusFixTimer(Sender: TObject);
    procedure gridsalaryTypesDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure gridsalaryTypesEditingDone(Sender: TObject);
    procedure gridsalaryTypesKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure gridsalaryTypesKeyPress(Sender: TObject; var Key: char);
    procedure gridsalaryTypesPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
    procedure gridsalaryTypesSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
    procedure gridsalaryTypesSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure qryWorkContractAfterEdit(DataSet: TDataSet);
    procedure qryWorkContractAfterInsert(DataSet: TDataSet);
    procedure qryWorkContractAfterScroll(DataSet: TDataSet);
    procedure qryWorkContractBeforeEdit(DataSet: TDataSet);
    procedure qryWorkContractBeforePost(DataSet: TDataSet);
  private
    FWageGridDataChanged: boolean; // et kas tasude juures muudeti midagi !
    FNewRecord: boolean;
    FEmployeeWageDefMRecID: integer;
    FSkipOnSelectEvent: boolean;
    FSkipDbEvents: boolean;
    FLastWorkContrId: integer;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FWageTypes: TRxDBLookupCombo;
    FEmployeeId: integer;
    procedure setEmployeeId(const v: integer);
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure deleteRow(const pRow: integer);
    procedure loadEmployeeData(const pEmployeeId: integer);
    procedure loadEmployeeWageData(const pContractId: integer);
    procedure OnLookupPopupClose(Sender: TObject; SearchResult: boolean);
    procedure OnLookupKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure OnLookupChange(Sender: TObject);
    procedure OnLookupSelect(Sender: TObject);

    procedure OnLookupEnter(Sender: TObject);
    procedure OnLookupExit(Sender: TObject);
    procedure performCleanup;

    procedure validateAndAssignDates(const Sender: TObject);
    procedure manageWorkerSalaryLines(const pContractId: integer);
    function verifyContractData: boolean;

  public
    property employeeId: integer read FEmployeeId write setEmployeeId; // ntx uue kirje loomisel
    procedure createContract();
    procedure loadContract(const pContractId: integer);
    procedure refreshWageTypes();
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

{
Re: Uus kalendriaasta ja töölepingute numeratsioon!
Soovitan kasutada kombineeritud numeratsiooni:
dokument aasta kuu päev registreerimise järjekorra number
Näiteks: TL-2012010901
}

const
  CCol_wagetype = 0;
  CCol_wagesum = 1;

{
insert into classificators(name,shortidef,type_)
values('Põhipalk','P','wage_type')

insert into classificators(name,shortidef,type_)
values('Tunnitasu','V','wage_type')
}
procedure TframeWorkContract.createContract();
begin
  if btnNew.Enabled then
    btnNew.OnClick(btnNew);
end;

procedure TframeWorkContract.setEmployeeId(const v: integer);
begin
  dbTextWorkername.Text := '';
  dbWorkIdCode.Text := '';
  self.FEmployeeId := v;
  if (v > 0) and assigned(qryTemp.Connection) then
    self.loadEmployeeData(v); // küsime nime ja isikukoodi !
end;

function TframeWorkContract.getDataLoadStatus: boolean;
begin
  Result := qryWorkContract.Active;
end;

procedure TframeWorkContract.setDataLoadStatus(const v: boolean);
begin
  self.FSkipOnSelectEvent := True;
  qryTemp.Close;
  qryTemp.SQL.Clear;

  qryWorkContract.Close;
  qryWorkContract.SQL.Clear;

  qryWorkContract.Close;
  qryWorkContract.SQL.Clear;

  // --
  qryWorkContractUpdt.ModifySQL.Clear;
  qryWorkContractUpdt.InsertSQL.Clear;

  if v then
  begin

    qryWorkContractUpdt.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertWorkContract);
    qryWorkContractUpdt.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdateWorkContract);

    qryWorkContract.SQL.Add(estbk_sqlclientcollection._SQLSelectWorkContract);
    qryAllFixedWageTypes.SQL.Add(estbk_sqlclientcollection._SQLSelectFixedWageTypes);

    qryWorkContract.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryWorkContractSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryAllFixedWageTypes.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryTemp.Connection := estbk_clientdatamodule.dmodule.primConnection;

    // --
    qryAllFixedWageTypes.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryAllFixedWageTypes.Open;
    qryAllFixedWageTypesDs.DataSet := qryAllFixedWageTypes;

  end
  else
  begin
    qryWorkContract.Connection := nil;
    qryWorkContractSeq.Connection := nil;
    qryAllFixedWageTypes.Connection := nil;
    qryTemp.Connection := nil;
    self.performCleanup;
  end;


  self.FSkipOnSelectEvent := False;
end;

procedure TframeWorkContract.refreshWageTypes();
begin
  qryAllFixedWageTypes.Active := False;
  qryAllFixedWageTypes.Active := True;
end;

procedure TframeWorkContract.loadEmployeeData(const pEmployeeId: integer);
begin
  with qryTemp, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectEmployee);
      paramByname('id').AsInteger := pEmployeeId;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      // --
      dbTextWorkername.Text := trim(FieldByName('firstname').AsString + ' ' + FieldByName('lastname').AsString);
      dbWorkIdCode.Text := FieldByName('personal_idnr').AsString;
    finally
      Close;
      Clear;
    end;
end;

procedure TframeWorkContract.loadEmployeeWageData(const pContractId: integer);
var
  pWType: TIntIDAndCTypes;
  pRow: integer;
begin
  with qryTemp, SQL do
    try

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectEmpWageDef);
      paramByname('employment_contract_id').AsInteger := pContractId;
      Open;

      self.FEmployeeWageDefMRecID := FieldByName('prec_id').AsInteger;
      First;
      pRow := 1;
      // töötaja vaikimisi palgamalli read !
      while not EOF do
      begin
        // pRow := gridsalaryTypes.Row;
        pWType := TIntIDAndCTypes.Create;
        pWType.id := FieldByName('wage_id').AsInteger;
        pWType.clf := FieldByName('wage_name').AsString;
        //  employee_wage_def
        pWType.id2 := FieldByName('id').AsInteger; // !!!


        gridsalaryTypes.Objects[CCol_wagetype, pRow] := pWType;
        gridsalaryTypes.Cells[CCol_wagetype, pRow] := FieldByName('wage_name').AsString;
        // --
        gridsalaryTypes.Cells[CCol_wagesum, pRow] := format(CCurrentMoneyFmt2, [FieldByName('price').AsFloat]);
        Inc(pRow);
        Next; // --
      end;

    finally
      Close;
      Clear;
    end;
end;

procedure TframeWorkContract.loadContract(const pContractId: integer);
begin
  try
    self.performCleanup;
    self.FSkipOnSelectEvent := True;
    self.FSkipDbEvents := True;

    // et lookup tasude gridis ei hakkaks midagi leiutama
    self.FLastWorkContrId := pContractId;
    with qryWorkContract do
    begin
      // ---
      Close;
      paramByname('id').AsInteger := pContractId;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;

      // ---
      self.FEmployeeId := FieldByName('employee_id').AsInteger;
      self.loadEmployeeData(self.FEmployeeId);
      self.loadEmployeeWageData(pContractId);

    end;

    if btnNew.CanFocus then
      btnNew.SetFocus;

    dbTextWorkername.Enabled := True;
    dbWorkIdCode.Enabled := True;


    estbk_utilities.changeWCtrlEnabledStatus(grpContract, not qryWorkContract.EOF, 0);
    grpContract.Enabled := True;
  finally
    self.FSkipOnSelectEvent := False;
    self.FSkipDbEvents := False;
  end; // ---


  // nüüd on alles ohutu scrollida !
  self.qryWorkContractAfterScroll(qryWorkContract);
  btnNew.Enabled := True;
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TframeWorkContract.deleteRow(const pRow: integer);
var
  i, j: integer;
begin
  with gridsalaryTypes do
    try
      self.FSkipOnSelectEvent := True;
      if assigned(Objects[CCol_wagetype, pRow]) then
      begin
        Objects[CCol_wagetype, pRow].Free;
        Objects[CCol_wagetype, pRow] := nil;
      end;

      Clean(CCol_wagetype, pRow, CCol_wagesum, pRow, [gzNormal]);

      for i := pRow to rowcount - 2 do
      begin
        for j := 0 to colcount - 1 do
        begin
          if (j in [CCol_wagetype]) then
            Objects[j, i] := Objects[j, i + 1];
          Cells[j, i] := Cells[j, i + 1];
        end;
      end;
      // grid
      if CanFocus then
        SetFocus;

      // ---
      if assigned(self.FWageTypes) then
      begin
        self.FWageTypes.Text := '';
        self.FWageTypes.Value := '';
      end;

    finally
      self.FSkipOnSelectEvent := False;
    end;
end;

procedure TframeWorkContract.gridsalaryTypesKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // --

  if (key = VK_RETURN) and (Shift = []) then
  begin
    if gridsalaryTypes.col < gridsalaryTypes.colcount - 1 then
      gridsalaryTypes.col := gridsalaryTypes.col + 1
    else
    if gridsalaryTypes.row < gridsalaryTypes.rowcount - 1 then
    begin
      gridsalaryTypes.row := gridsalaryTypes.row + 1;
      gridsalaryTypes.col := 0;
    end;
    // ---
    key := 0;
  end
  else
  if (key = VK_DELETE) and (Shift = [ssCtrl]) then
  begin

    self.deleteRow(gridsalaryTypes.row);
    key := 0;
  end;
  // ---
end;

procedure TframeWorkContract.validateAndAssignDates(const Sender: TObject);
var
  pStr: AStr;
  cval: TDatetime;
  pNewSession: boolean;
begin
  // if not self.FSkipDbEvents then
  try
    // ---

    pNewSession := not (qryWorkContract.State in [dsEdit, dsInsert]);
    if pNewSession then
      qryWorkContract.Edit;

    pStr := trim(TEdit(Sender).Text);
    if pStr <> '' then
    begin

      if not estbk_utilities.validateMiscDateEntry(pStr, cval) then
      begin
        Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
        if TEdit(Sender).CanFocus then
          TEdit(Sender).SetFocus;
      end
      else
        TEdit(Sender).Text := datetostr(cval);

      // ---
      if Sender = dtWorkStart then
        qryWorkContract.FieldByName('start_date').AsDateTime := cval
      else
      if Sender = dtWorkEnd then
        qryWorkContract.FieldByName('end_date').AsDateTime := cval
      else
      if Sender = dtContrdate then
        qryWorkContract.FieldByName('contract_date').AsDateTime := cval
      else
      if Sender = dtTaxFreePStart then
        qryWorkContract.FieldByName('tfcalc_beginning').AsDateTime := cval
      else
      if Sender = dtEarlyPensionDate then
        qryWorkContract.FieldByName('early_retirement_date').AsDateTime := cval;

    end
    else // ---
    begin
      if Sender = dtWorkStart then
        qryWorkContract.FieldByName('start_date').Value := null
      else
      if Sender = dtWorkEnd then
        qryWorkContract.FieldByName('end_date').Value := null
      else
      if Sender = dtContrdate then
        qryWorkContract.FieldByName('contract_date').Value := null
      else
      if Sender = dtTaxFreePStart then
        qryWorkContract.FieldByName('tfcalc_beginning').Value := null
      else
      if Sender = dtEarlyPensionDate then
        qryWorkContract.FieldByName('early_retirement_date').Value := null;
    end;
    // ----
  finally

    if pNewSession then
      qryWorkContract.Post;
  end;
end;

procedure TframeWorkContract.dtContrdateExit(Sender: TObject);
begin
  self.validateAndAssignDates(Sender);
end;

procedure TframeWorkContract.focusFixTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
{
  if self.FWageTypes.Visible then
     begin

     if gridsalaryTypes.CanFocus then
        gridsalaryTypes.SetFocus;

     if self.FWageTypes.CanFocus then
        self.FWageTypes.SetFocus;

     end;
}


  if gridsalaryTypes.CanFocus then
    gridsalaryTypes.SetFocus;

  if assigned(gridsalaryTypes.Editor) then
    if gridsalaryTypes.Editor.CanFocus then
    begin
      gridsalaryTypes.Editor.SetFocus;
    end;

end;

procedure TframeWorkContract.gridsalaryTypesDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
const
  CCWidthDelta = 0;
  CCLeftDelta = -1;
begin
  if (gdFocused in aState) then
    if aRow >= 1 then
      case aCol of
        CCol_wagetype:
        begin
          //  TStringGrid(Sender).Left
          FWageTypes.Left := aRect.Left + CCLeftDelta;
          FWageTypes.Top := aRect.Top;
          FWageTypes.Width := (aRect.Right - aRect.Left) + CCWidthDelta;
          FWageTypes.Height := (aRect.Bottom - aRect.Top) - 2;
          if FWageTypes.Height < 20 then
            FWageTypes.Height := 21;
        end;
      end; // ---
end;

procedure TframeWorkContract.gridsalaryTypesEditingDone(Sender: TObject);
begin
  // kasutame ära sama muutujat, sest see andmete laadimisel aktiivne, meil pole vaja, et siis nupud lahti oleks
  if not self.FSkipOnSelectEvent then
  begin
    btnNew.Enabled := False;
    btnSave.Enabled := True;
    btnCancel.Enabled := True;

    // märgime ära, et miskit muudeti...
    self.FWageGridDataChanged := True;
  end;
end;

procedure TframeWorkContract.chkWorkerFullTimeChange(Sender: TObject);
var
  pNewSession: boolean;
begin

  if TCheckbox(Sender).Focused then
    try

      pNewSession := not (qryWorkContract.State in [dsEdit, dsInsert]);
      if pNewSession then
        qryWorkContract.Edit;


      if Sender = chkWorkerFullTime then
        with qryWorkContract do
          case TCheckbox(Sender).Checked of
            True: FieldByName('flags').AsInteger := FieldByName('flags').AsInteger or estbk_types.CntrWorkerFullTime;
            False: FieldByName('flags').AsInteger := FieldByName('flags').AsInteger and not estbk_types.CntrWorkerFullTime;
          end
      else
      if Sender = chkSocialMinTaxCalc then
        with qryWorkContract do
          case TCheckbox(Sender).Checked of
            True: FieldByName('flags').AsInteger := FieldByName('flags').AsInteger or estbk_types.CntrSocialMinTaxCalc;
            False: FieldByName('flags').AsInteger := FieldByName('flags').AsInteger and not estbk_types.CntrSocialMinTaxCalc;
          end;

      // ----
    finally
      if pNewSession then
        qryWorkContract.Post;
    end;
end;

procedure TframeWorkContract.performCleanup;
var
  i: integer;
begin
  self.FEmployeeWageDefMRecID := 0;
  self.FWageGridDataChanged := False;
  self.FNewRecord := False;

  dbTextWorkername.Text := '';
  dbWorkIdCode.Text := '';

  dtContrdate.Date := now;
  dtContrdate.Text := '';

  dtWorkStart.Date := now;
  dtWorkStart.Text := '';

  dtWorkEnd.Date := now;
  dtWorkEnd.Text := '';

  dtTaxFreePStart.Date := now;
  dtTaxFreePStart.Text := '';

  dtEarlyPensionDate.Date := now;
  dtEarlyPensionDate.Text := '';

  estbk_utilities.clearControlsWithTextValue(pContrPanel);
  chkWorkerFullTime.Checked := False;
  chkSocialMinTaxCalc.Checked := False;
  self.gridsalaryTypes.Clean(CCol_wagetype, 1, CCol_wagesum, gridsalaryTypes.Rowcount - 1, [gzNormal]);
  // procedure Clean(StartCol,StartRow,EndCol,EndRow: integer; CleanOptions:TGridZoneSet); overload;
  for i := 1 to gridsalaryTypes.Rowcount - 1 do
    if assigned(gridsalaryTypes.Objects[CCol_wagetype, i]) then
    begin
      gridsalaryTypes.Objects[CCol_wagetype, i].Free;
      gridsalaryTypes.Objects[CCol_wagetype, i] := nil;
    end;
  // --
end;

procedure TframeWorkContract.btnNewClick(Sender: TObject);
begin
  try
    dbTextWorkername.Enabled := True;
    dbWorkIdCode.Enabled := True;

    self.FSkipDbEvents := True;
    self.performCleanup;


    self.FWageTypes.Visible := False;
    qryAllFixedWageTypes.First;
    estbk_utilities.changeWCtrlEnabledStatus(grpContract, True, 0);
    grpContract.Enabled := True;

    qryWorkContract.Close;
    qryWorkContract.ParamByName('id').AsInteger := -1;
    qryWorkContract.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryWorkContract.Open;
    // ---

    qryWorkContract.Insert;
    self.FWageGridDataChanged := True; // et tasuliigid ikka salvestuks
    self.FNewRecord := True;

    if dbEdtContractNr.CanFocus then
      dbEdtContractNr.SetFocus;




    // ---
  finally
    self.FSkipDbEvents := False;
  end;
end;

procedure TframeWorkContract.manageWorkerSalaryLines(const pContractId: integer);
var
  i: integer;
  pWgType: TIntIDAndCTypes;
begin
  if self.FWageGridDataChanged then
  begin
    assert(((self.FEmployeeId > 0) and (pContractId > 0)), '#1');
    // töötajal polegi palgamalli aluskirjet ?!?
    if self.FEmployeeWageDefMRecID < 1 then
      with qryTemp, SQL do
      begin
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLInsertEmpWageDefMRec);
        // antud sequence on dmodules kirjeldatud !
        self.FEmployeeWageDefMRecID := dmodule.qryEmployeeWageSeq.GetNextValue;
        paramByname('id').AsInteger := self.FEmployeeWageDefMRecID;
        paramByname('employee_id').AsInteger := self.FEmployeeId;
        paramByname('employment_contract_id').AsInteger := pContractId;
        // kas siia peaks ka tulevikus lepingu alguse ja lõpu panema ?!
        paramByname('valid_from').Value := null;
        paramByname('valid_until').Value := null;
        paramByname('flags').AsInteger := 0;
        paramByname('template').AsString := 'f'; // !!!
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        execSQL;

        Close;
        Clear;
      end;
    // ---
    for i := 1 to gridsalaryTypes.RowCount - 1 do
      if assigned(gridsalaryTypes.Objects[CCol_wagetype, i]) then
      begin

        // ---
        pWgType := TIntIDAndCTypes(gridsalaryTypes.Objects[CCol_wagetype, i]);

        // töötaja palgaread; põhipalk / tunnitasu !!!
        // ---
        // uuendame vanat kirjet !
        if pWgType.id2 > 0 then
          with qryTemp, SQL do
            try
              Close;
              Clear;
              add(estbk_sqlclientcollection._SQLUpdateEmpWageDef);
              paramByname('wage_type_id').AsInteger := pWgType.id; // tasu liik
              paramByname('row_id').AsString := '';
              paramByname('formula').AsString := '';
              if dtWorkStart.Text <> '' then
                paramByname('valid_from').AsDateTime := dtWorkStart.Date
              else
                paramByname('valid_from').Value := null;

              // ---
              if dtWorkEnd.Text <> '' then
                paramByname('valid_until').AsDateTime := dtWorkEnd.Date
              else
                paramByname('valid_until').Value := null;
              paramByname('unit').AsString := '';
              paramByname('flags').AsInteger := 0;
              paramByname('price').AsCurrency := roundto(strToFloatDef(gridsalaryTypes.Cells[CCol_wagesum, i], 0), Z2);

              paramByname('rec_changed').AsDateTime := now;
              paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByname('id').AsInteger := pWgType.id2;
              execSQL;
              // ---

            finally
              Close;
              Clear;
            end
        else
        // ---
        // selgub, et rida kustutatud !
        if (pWgType.id = 0) and (pWgType.id2 > 0) then
          with qryTemp, SQL do
            try
              Close;
              Clear;
              add(estbk_sqlclientcollection._SQLUpdateEmpWageDef);
              paramByname('rec_deleted').AsString := estbk_types.SCFalseTrue[True];
              paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByname('rec_changed').AsDateTime := now;
              paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByname('id').AsInteger := pWgType.id2;
              execSQL;
            finally
              Close;
              Clear;
            end
        else
        // ---
        // uus kirje
        if (pWgType.id > 0) and (pWgType.id2 < 1) then
          with qryTemp, SQL do
            try
              Close;
              Clear;
              add(estbk_sqlclientcollection._SQLInsertEmpWageDef);
              paramByname('employee_wage_id').AsInteger := self.FEmployeeWageDefMRecID;
              // paramByname('employee_id').AsInteger := self.FEmployeeId;
              // paramByname('employment_contract_id').AsInteger := pContractId;
              paramByname('wage_type_id').AsInteger := pWgType.id;
              paramByname('row_id').AsString := '';
              paramByname('formula').AsString := '';
              if dtWorkStart.Text <> '' then
                paramByname('valid_from').AsDateTime := dtWorkStart.Date
              else
                paramByname('valid_from').Value := null;

              // ---
              if dtWorkEnd.Text <> '' then
                paramByname('valid_until').AsDateTime := dtWorkEnd.Date
              else
                paramByname('valid_until').Value := null;
              paramByname('unit').AsString := '';
              paramByname('price').AsFloat := roundto(strToFloatDef(gridsalaryTypes.Cells[CCol_wagesum, i], 0), Z2);
              paramByname('flags').AsInteger := 0;
              paramByname('rec_changed').AsDateTime := now;
              paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
              execSQL;
            finally
              Close;
              Clear;
            end;
        // ---
      end;
  end;
end;

function TframeWorkContract.verifyContractData: boolean;
var
  bStart: TDateTime;
  bEnd: TDateTime;
  pDt1: AStr;
  pDt2: AStr;
  pCtrNr: AStr;
begin
  Result := False;
  if trim(dbEdtContractNr.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEWrkContrNrIsMissing, mtError, [mbOK], 0);
    if dbEdtContractNr.CanFocus then
      dbEdtContractNr.SetFocus;
    Exit; // --
  end;

  // ei tohi tühi olla !
  if trim(dtContrdate.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEWrkContrDateIsMissing, mtError, [mbOK], 0);
    if dtContrdate.CanFocus then
      dtContrdate.SetFocus;
    Exit; // --
  end;

  // peab rp. üle küsima need tingimused !
  if (dtContrdate.Date < now - 365) or (dtContrdate.Date > now + 60) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEWrkContrDateIsIncorrect, mtError, [mbOK], 0);
    if dtContrdate.CanFocus then
      dtContrdate.SetFocus;
    Exit; // --
  end;


  // TODO
  if (dtWorkStart.Text = '') and (dtWorkEnd.Text <> '') then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEWrkContrStartDateInvalid, mtError, [mbOK], 0);
    if dtWorkStart.CanFocus then
      dtWorkStart.SetFocus;
    Exit; // --
  end;

  if (dtWorkStart.Text <> '') and (dtWorkStart.Date < dtContrdate.Date) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEWrkContrDateCrAsStartDate, mtError, [mbOK], 0);
    if dtContrdate.CanFocus then
      dtContrdate.SetFocus;
    Exit; // --
  end;


  // -- kas perioodis on juba olnud kehtivaid lepinguid !

  with qryTemp, SQL do
    try

      // ainult uue lep. puhul küsi numbrit !
      if self.FNewRecord then
      begin
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLSelectWorkContract3);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        paramByname('nr').AsString := dbEdtContractNr.Text;
        Open;
        if FieldByName('id').AsInteger > 0 then
        begin
          Dialogs.messageDlg(format(estbk_strmsg.SEWrkContrNrExists, [dbEdtContractNr.Text]), mtError, [mbOK], 0);
          if dbEdtContractNr.CanFocus then
            dbEdtContractNr.SetFocus;
          Exit;
        end;
      end; // ---

      bStart := Nan;
      if dtWorkStart.Text <> '' then
        bStart := dtWorkStart.Date;

      bEnd := Nan;
      if dtWorkEnd.Text <> '' then
        bEnd := dtWorkEnd.Date;

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLCheckForCurrentlyValidContracts(self.FEmployeeId, qryWorkContract.FieldByName('id').AsInteger,
        bStart, bEnd));
      Open;

      if RecordCount > 0 then
      begin
        // --
        pDt1 := '';
        if not FieldByName('start_date').IsNull then
          pDt1 := datetostr(FieldByName('start_date').AsDateTime);

        pDt2 := '';
        if not FieldByName('end_date').IsNull then
          pDt2 := datetostr(FieldByName('end_date').AsDateTime);
        pCtrNr := FieldByName('nr').AsString;
        Dialogs.messageDlg(format(estbk_strmsg.SEWrkContrSteDateExists, [pDt1, pDt2, pCtrNr]), mtError, [mbOK], 0);
        Exit; // ---
      end;
    finally
      Close;
      Clear;
    end;

  // ---
  Result := True;
end;

procedure TframeWorkContract.btnSaveClick(Sender: TObject);
var
  pContrId: integer;
begin
  if not self.verifyContractData then
    Exit;

  with estbk_clientdatamodule.dmodule do
    try
      self.FSkipDbEvents := True;
      // ---
      try

        dmodule.primConnection.StartTransaction;
        if self.FNewRecord then
        begin
          pContrId := qryWorkContractSeq.GetNextValue;
          // --
          qryWorkContract.Edit;
          qryWorkContract.FieldByName('id').AsInteger := pContrId;
          qryWorkContract.FieldByName('employee_id').AsInteger := self.FEmployeeId;
          qryWorkContract.Post;
        end
        else
          pContrId := qryWorkContract.FieldByName('id').AsInteger;
        qryWorkContract.ApplyUpdates;


        self.manageWorkerSalaryLines(pContrId);
        // --
        dmodule.primConnection.Commit;
        qryWorkContract.CommitUpdates;


        btnNew.Enabled := True;
        btnSave.Enabled := False;
        btnCancel.Enabled := False;

        // --
        self.FWageGridDataChanged := False;
        self.FNewRecord := False;
        self.FLastWorkContrId := pContrId;


      except
        on e: Exception do
        begin
          if primConnection.inTransaction then
            try
              primConnection.Rollback;
            except
            end;
          if not (e is eabort) then
            Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
          Exit; // ---
        end;
      end;

      // ---
    finally
      self.FSkipDbEvents := False;
    end;


  // -- elu näidanud, et andmed tasub uuesti laadida, kui mingid probleemid, siis kasutaja märkab koheselt neid
  self.loadContract(self.FLastWorkContrId);
end;


procedure TframeWorkContract.btnCancelClick(Sender: TObject);
begin
  self.FWageTypes.Visible := False;
  btnNew.Enabled := True;
  btnSave.Enabled := False;
  btnCancel.Enabled := False;

  if self.FLastWorkContrId < 1 then
  begin
    qryWorkContract.CancelUpdates;
    estbk_utilities.changeWCtrlEnabledStatus(grpContract, not qryWorkContract.EOF, 0);
    grpContract.Enabled := True;

    if qryWorkContract.EOF then
      self.performCleanup;
  end
  else
    self.loadContract(self.FLastWorkContrId); // ohutum uuesti laadida !
end;

procedure TframeWorkContract.btnCloseClick(Sender: TObject);
begin
  if assigned(self.FframeKillSignal) then
    self.FframeKillSignal(self);
end;

procedure TframeWorkContract.dbEdtContractNrKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeWorkContract.dtContrdateAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: boolean);
begin
  // TODO, millised piirangud siia panna ?!?!?
  AcceptDate := True;
  TDateEdit(Sender).Text := datetostr(ADate);
  self.validateAndAssignDates(Sender);
end;

procedure TframeWorkContract.dtContrdateChange(Sender: TObject);
begin

end;



procedure TframeWorkContract.gridsalaryTypesKeyPress(Sender: TObject; var Key: char);
begin
  if (self.gridsalaryTypes.Col = CCol_wagesum) then
  begin
    if key = ^V then
      self.gridsalaryTypes.Cells[CCol_wagesum, self.gridsalaryTypes.Row] :=
        format(CCurrentMoneyFmt2, [strToFloatDef(self.gridsalaryTypes.Cells[CCol_wagesum, self.gridsalaryTypes.Row], 0)])
    else
    if assigned(self.gridsalaryTypes.Editor) and (self.gridsalaryTypes.Editor is TCustomEdit) then
    begin
      if length(self.gridsalaryTypes.Cells[CCol_wagesum, self.gridsalaryTypes.Row]) > 11 then
        key := #0
      else
        estbk_utilities.edit_verifyNumericEntry(self.gridsalaryTypes.Editor as TCustomEdit, key, True);
    end;

    // ---
  end;
end;

procedure TframeWorkContract.gridsalaryTypesPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
begin
  // --
end;

procedure TframeWorkContract.gridsalaryTypesSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
begin
  // --
end;

procedure TframeWorkContract.gridsalaryTypesSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
begin
  try
    self.FSkipOnSelectEvent := True;
    if not assigned(self.FWageTypes) then
    begin
      Editor := TStringGrid(Sender).EditorByStyle(cbsAuto);
      TStringCellEditor(Editor).Alignment := taLeftJustify;
      Exit;  // --
    end;



    self.FWageTypes.Visible := False;
    // --
    case aCol of
      CCol_wagetype:
      begin
        self.FWageTypes.Text := '';
        self.FWageTypes.Value := '';

        Editor := self.FWageTypes;
        if assigned(gridsalaryTypes.Objects[CCol_wagetype, aRow]) then
          self.FWageTypes.Value := IntToStr(TIntIDAndCTypes(gridsalaryTypes.Objects[CCol_wagetype, aRow]).id);
        self.FWageTypes.Visible := True;
        self.FWageTypes.Enabled := True;
      end;

      CCol_wagesum:
      begin
        Editor := TStringGrid(Sender).EditorByStyle(cbsAuto);
        TStringCellEditor(Editor).Alignment := taRightJustify;

        if Editor.CanFocus then
          Editor.SetFocus;
      end;
    end;


    // --
    focusFix.Enabled := True;
  finally
    self.FSkipOnSelectEvent := False;
  end;
end;

procedure TframeWorkContract.qryWorkContractAfterEdit(DataSet: TDataSet);
begin

  // --
  btnNew.Enabled := False;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
end;

procedure TframeWorkContract.qryWorkContractAfterInsert(DataSet: TDataSet);
begin

  Dataset.FieldByName('flags').AsInteger := 0;
  Dataset.FieldByName('employee_id').AsInteger := self.FEmployeeId;
  Dataset.FieldByName('company_id').AsInteger := estbk_globvars.glob_company_id;
  Dataset.FieldByName('holidays_per_year').AsInteger := estbk_globvars.glob_holidayd_peryear;

  // --
  btnNew.Enabled := False;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
end;

procedure TframeWorkContract.qryWorkContractAfterScroll(DataSet: TDataSet);
begin
  if (Dataset.RecordCount > 0) and not self.FNewRecord then
    with DataSet do
    begin
      chkWorkerFullTime.Checked := (FieldByName('flags').AsInteger and estbk_types.CntrWorkerFullTime) = estbk_types.CntrWorkerFullTime;
      chkSocialMinTaxCalc.Checked := (FieldByName('flags').AsInteger and estbk_types.CntrSocialMinTaxCalc) = estbk_types.CntrSocialMinTaxCalc;

      // --
      if qryWorkContract.FieldByName('start_date').IsNull then
      begin
        dtWorkStart.Date := now;
        dtWorkStart.Text := '';
      end
      else
      begin
        dtWorkStart.Date := qryWorkContract.FieldByName('start_date').AsDateTime;
        dtWorkStart.Text := datetostr(dtWorkStart.Date);
      end;

      if qryWorkContract.FieldByName('end_date').IsNull then
      begin
        dtWorkEnd.Date := now;
        dtWorkEnd.Text := '';
      end
      else
      begin
        dtWorkEnd.Date := qryWorkContract.FieldByName('end_date').AsDateTime;
        dtWorkEnd.Text := datetostr(dtWorkEnd.Date);
      end;

      if qryWorkContract.FieldByName('contract_date').IsNull then
      begin
        dtContrdate.Date := now;
        dtContrdate.Text := '';
      end
      else
      begin
        dtContrdate.Date := qryWorkContract.FieldByName('contract_date').AsDateTime;
        dtContrdate.Text := datetostr(dtContrdate.Date);
      end;


      if qryWorkContract.FieldByName('tfcalc_beginning').IsNull then
      begin
        dtTaxFreePStart.Date := now;
        dtTaxFreePStart.Text := '';
      end
      else
      begin
        dtTaxFreePStart.Date := qryWorkContract.FieldByName('tfcalc_beginning').AsDateTime;
        dtTaxFreePStart.Text := datetostr(dtTaxFreePStart.Date);
      end;

      if qryWorkContract.FieldByName('early_retirement_date').IsNull then
      begin
        dtEarlyPensionDate.Date := now;
        dtEarlyPensionDate.Text := '';
      end
      else
      begin
        dtEarlyPensionDate.Date := qryWorkContract.FieldByName('early_retirement_date').AsDateTime;
        dtEarlyPensionDate.Text := datetostr(dtEarlyPensionDate.Date);
      end;
      // ---
    end;
end;

procedure TframeWorkContract.qryWorkContractBeforeEdit(DataSet: TDataSet);
begin
  btnNew.Enabled := False;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;
end;

procedure TframeWorkContract.qryWorkContractBeforePost(DataSet: TDataSet);
begin
  // --
end;

procedure TframeWorkContract.OnLookupPopupClose(Sender: TObject; SearchResult: boolean);
begin
end;

procedure TframeWorkContract.OnLookupKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  with TRxDBLookupCombo(Sender) do

    if Shift = [] then
      case key of
        VK_RETURN,
        VK_RIGHT,
        VK_TAB:
        begin
          gridsalaryTypes.Col := CCol_wagesum;
          if gridsalaryTypes.CanFocus then
            gridsalaryTypes.SetFocus;
          // ---
          focusFix.Enabled := True;
          key := 0;
          //      key:=VK_TAB;
          //      focusFix.Enabled:=true;
        end;

        VK_DOWN,
        VK_NEXT: if not popUpVisible then
          begin
            //Visible := False;
            //DroppedDown := False;
            if gridsalaryTypes.Row + 1 <= gridsalaryTypes.RowCount then
              gridsalaryTypes.Row := gridsalaryTypes.Row + 1;

            if gridsalaryTypes.CanFocus then
              gridsalaryTypes.SetFocus;

            // ---
            key := 0;
          end;

        VK_UP,
        VK_PRIOR: if not popUpVisible then
          begin
            if gridsalaryTypes.Row - 1 > 0 then
              gridsalaryTypes.Row := gridsalaryTypes.Row - 1;

            if gridsalaryTypes.CanFocus then
              gridsalaryTypes.SetFocus;

            // ---
            key := 0;
          end;
        VK_DELETE:
          try
            self.FSkipOnSelectEvent := True;
            TRxDBLookupCombo(Sender).Text := '';
            TRxDBLookupCombo(Sender).Value := '';
          finally
            self.FSkipOnSelectEvent := False;
          end;
        // --
      end
    else
    if key = VK_DELETE then  //  if(Shift=[ssCtrl]) then
      self.deleteRow(gridsalaryTypes.Row);
end;

procedure TframeWorkContract.OnLookupChange(Sender: TObject);
var
  pRow: integer;
  pWType: TIntIDAndCTypes;
begin

  if self.FSkipOnSelectEvent then
    Exit;

  pRow := gridsalaryTypes.Row;
  pWType := gridsalaryTypes.Objects[CCol_wagetype, pRow] as TIntIDAndCTypes;
  with TRxDBLookupCombo(Sender) do
    if (trim(Text) = '') and assigned(pWType) then
    begin
      pWType.id := 0;
      pWType.clf := '';
    end;


  // -- nupud lahti; kasutame sama eventi !
  self.gridsalaryTypesEditingDone(Sender);
end;

procedure TframeWorkContract.OnLookupSelect(Sender: TObject);
var
  //pCol : Integer;
  pRow: integer;
  pWType: TIntIDAndCTypes;
begin

  if self.FSkipOnSelectEvent then
    Exit;

  //pCol:=gridsalaryTypes.Col;
  pRow := gridsalaryTypes.Row;
  pWType := gridsalaryTypes.Objects[CCol_wagetype, pRow] as TIntIDAndCTypes;
  if not assigned(pWType) then
  begin
    pWType := TIntIDAndCTypes.Create;
    gridsalaryTypes.Objects[CCol_wagetype, pRow] := pWType;
  end;
  // --
  with TRxDBLookupCombo(Sender) do
  begin
    gridsalaryTypes.Cells[CCol_wagetype, pRow] := Text;
    pWType.id := LookupSource.DataSet.FieldByName('id').AsInteger;
    pWType.clf := Text;
  end;

  focusFix.Enabled := True;
end;

procedure TframeWorkContract.OnLookupEnter(Sender: TObject);
begin
end;

procedure TframeWorkContract.OnLookupExit(Sender: TObject);
begin
end;



constructor TframeWorkContract.Create(frameOwner: TComponent);
var
  pCollItem: TCollectionItem;
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
  gridsalaryTypes.RowCount := 999;
  estbk_utilities.changeWCtrlEnabledStatus(grpContract, False, 0);
  grpContract.Enabled := True;



  FWageTypes := TRxDBLookupCombo.Create(self.gridsalaryTypes);
  FWageTypes.AutoSize := False;
  FWageTypes.parent := self.gridsalaryTypes;
  FWageTypes.Visible := False;

  FWageTypes.OnKeyDown := @self.OnLookupKeydown;
  FWageTypes.OnEnter := @self.OnLookupEnter;
  FWageTypes.OnExit := @self.OnLookupExit;
  FWageTypes.OnClosePopupNotif := @self.OnLookupPopupClose;
  FWageTypes.OnChange := @self.OnLookupChange;
  //FAccListCombo.PopUpFormOptions.OnGetCellProps:=@self.OnDbLookupComboSelColor;
  FWageTypes.OnSelect := @self.OnLookupSelect;
  FWageTypes.ParentFont := True;
  FWageTypes.ParentColor := False;
  FWageTypes.ShowHint := True;
  FWageTypes.DoubleBuffered := True;
  FWageTypes.EmptyValue := #32;
  FWageTypes.Flat := True;
  FWageTypes.BorderStyle := bsNone;
  FWageTypes.PopUpFormOptions.BorderStyle := bsNone;
  //FAccListCombo.PopUpFormOptions.Options:=[pfgIndicator,pfgRowlines,pfgCollines,pfgColumnResize];
  //FAccListCombo.PopUpFormOptions.ShowTitles:=true;
  //FAccListCombo.PopUpFormOptions.TitleButtons:=true;
  FWageTypes.PopUpFormOptions.Options :=
    [pfgIndicator, pfgRowlines, pfgCollines, pfgColumnResize];
  FWageTypes.PopUpFormOptions.TitleButtons := True;
  FWageTypes.DropDownCount := 20;
  FWageTypes.DropDownWidth := 315;

  FWageTypes.LookupSource := self.qryAllFixedWageTypesDs;
  FWageTypes.LookupDisplay := 'wage_name';
  FWageTypes.LookupField := 'id';


  pCollItem := FWageTypes.PopUpFormOptions.Columns.Add;
  (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SCFWageLineType;
  (pCollItem as TPopUpColumn).Fieldname := 'wage_name';
  (pCollItem as TPopUpColumn).Width := 270;


  FWageTypes.EmptyValue := #32;
  FWageTypes.UnfindedValue := rxufNone;
  //FAccListCombo.UnfindedValue:=rxufNone;
  FWageTypes.ButtonWidth := 15;
  FWageTypes.ButtonOnlyWhenFocused := False;
  FWageTypes.Height := 23;
  FWageTypes.PopUpFormOptions.ShowTitles := True;

  FWageTypes.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;


  //  dbTextWorkername.Color := estbk_types.MyFavGray;
  //  dbWorkIdCode.Color := estbk_types.MyFavGray;
  //  dbTextWorkername.Font.Style:=[fsBold];
  //  dbWorkIdCode.Font.Style:=[fsBold];
  TStringCellEditor(gridsalaryTypes.EditorByStyle(cbsAuto)).OnClick := @__intUIMiscHelperClass.OnClickEditFocusFix;
  TStringCellEditor(gridsalaryTypes.EditorByStyle(cbsAuto)).OnKeyDown := @self.gridsalaryTypesKeyDown;
  TStringCellEditor(gridsalaryTypes.EditorByStyle(cbsAuto)).OnKeyPress := @self.gridsalaryTypesKeyPress;
  TStringCellEditor(gridsalaryTypes.EditorByStyle(cbsAuto)).OnChange := @self.gridsalaryTypesEditingDone;
end;

destructor TframeWorkContract.Destroy;
begin
  self.performCleanup;
  inherited Destroy;
end;


initialization
  {$I estbk_fra_workcontract.ctrs}

end.