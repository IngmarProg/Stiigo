unit estbk_fra_employee_wagetemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, ExtCtrls, Graphics, LclType, Dialogs, contnrs,
  EditBtn, DBCtrls, Grids, Buttons, estbk_lib_commonevents, Math, estbk_fra_template,
  estbk_uivisualinit, estbk_lib_commoncls, estbk_clientdatamodule, estbk_lib_revpolish, estbk_lib_formulaparserext,
  estbk_sqlclientcollection, estbk_globvars, estbk_utilities, estbk_types,
  estbk_strmsg, DB, ZDataset, ZSqlUpdate, ZSequence,
  rxpopupunit, rxdbgrid, rxlookup;

const
  CLeftHiddenCorn = -200;

type

  { TframeEmpwageTypeDefTemplate }

  TframeEmpwageTypeDefTemplate = class(Tfra_template)
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnSave: TBitBtn;
    Button1: TButton;
    qryTemp: TZReadOnlyQuery;
    qryRowltypeDs: TDatasource;
    qryAccountsDs: TDatasource;
    dbWorkIdCode: TEdit;
    grpContract: TGroupBox;
    gridSalaryTemplate: TStringGrid;
    qryRowltype: TZReadOnlyQuery;
    qryAccounts: TZReadOnlyQuery;
    focusFix: TTimer;
    procedure btnSaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure focusFixTimer(Sender: TObject);
    procedure gridSalaryTemplateDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure gridSalaryTemplateEditingDone(Sender: TObject);
    procedure gridSalaryTemplateKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure gridSalaryTemplateKeyPress(Sender: TObject; var Key: char);
    procedure gridSalaryTemplatePrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
    procedure gridSalaryTemplateSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
  private
    FRowType: TRxDBLookupCombo;
    FAccounts: TRxDBLookupCombo;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FSkipSelectEvent: boolean;
    FTemplateMode: boolean;
    FDeletedIDs: TList;
    // palga baaskirje ID
    FEmployeeWageRecID: integer;
    FOrigRowLineHash: integer;
    FCurrEmployeeId: integer;
    function calcRowLineHash: integer;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure loadEmployeeWageTemplate(const pEmployeeId: integer; const pRecDate: TDatetime = Nan);
    function calcRowValue(const prowNr: integer): double;
    procedure deleteRow(const pRow: integer);
    procedure performCleanup;
    function validateDataWithEval: boolean;
    function verifyLines: boolean;
    procedure saveData;
    procedure OnLookupGetGridCellProps(Sender: TObject; Field: TField; AFont: TFont; var Background: TColor);
    procedure OnLookupPopupClose(Sender: TObject; SearchResult: boolean);
    procedure OnLookupKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure OnLookupChange(Sender: TObject);
    procedure OnLookupSelect(Sender: TObject);
    procedure OnLookupEnter(Sender: TObject);
    procedure OnLookupExit(Sender: TObject);

  published

    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property employeeId: integer read FCurrEmployeeId write FCurrEmployeeId;
    property templateMode: boolean read FTemplateMode write FTemplateMode;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
    constructor Create(frameOwner: TComponent);
    destructor Destroy; override;
  end;
// NBNB ID2 hoiab endas väli
implementation

uses variants;

const
  CSbtype_wage = 'R';
  CSbtype_tax = 'T';

const
  CCol_rownumber = 0; // seal hoiame ka valemite infot !
  CCol_rowtype = 1;
  CCol_account = 2;
  CCol_formula = 3;

function TframeEmpwageTypeDefTemplate.getDataLoadStatus: boolean;
begin
  Result := qryRowltype.Active;
end;

procedure TframeEmpwageTypeDefTemplate.setDataLoadStatus(const v: boolean);
begin
  self.FSkipSelectEvent := True;
  qryRowltype.Close;
  qryRowltype.SQL.Clear;

  qryAccounts.Close;
  qryAccounts.SQL.Clear;

  if v then
  begin
    qryRowltype.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryTemp.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryRowltype.SQL.add(estbk_sqlclientcollection._CSQLWageTemplateItems(estbk_globvars.glob_company_id));
    qryAccounts.SQL.add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    qryAccounts.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
    // --
    qryAccounts.Active := v;
    qryRowltype.Active := v;
  end
  else
  begin
    qryRowltype.Connection := nil;
    qryAccounts.Connection := nil;
    qryTemp.Connection := nil;
  end;
  // ---
  self.FSkipSelectEvent := False;
end;


procedure TframeEmpwageTypeDefTemplate.loadEmployeeWageTemplate(const pEmployeeId: integer; const pRecDate: TDatetime = Nan);
var
  pAccountId: integer;
  pTaxId: integer;
  pWageId: integer;
  bHasTempLine: boolean;
  pRowType: TIntIDAndCTypes;
  pRownr: integer;
  pName: AStr;
  pWageObj: TWageFormulaParser;
begin
  try
    self.performCleanup;
    self.FSkipSelectEvent := True;
    bHasTempLine := False;
    self.FEmployeeWageRecID := 0;
    gridSalaryTemplate.Col := CCol_rowtype;
    gridSalaryTemplate.Row := 1;

    self.FAccounts.Visible := False;
    self.FRowType.Visible := False;
    focusFix.Enabled := False;

    // --
    with self.qryTemp, SQL do
    begin
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectEmpWageDefMRec);
      paramByname('employee_id').AsInteger := pEmployeeId;
      paramByname('template').Value := null;
      Open;
      self.FEmployeeWageRecID := FieldByName('id').AsInteger;


      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectEmpWageDef2);
      paramByname('id').AsInteger := self.FEmployeeWageRecID;
      // TODO; jätta meelde valemid, mis kehtisid palga maksmise hetkel !
      if isNan(pRecDate) then
      begin
        paramByname('valid_from').Value := null;
        paramByname('valid_until').Value := null;
      end
      else
      begin
        paramByname('valid_from').AsDateTime := pRecDate;
        paramByname('valid_until').AsDateTime := pRecDate;
      end;

      Open;

      pRownr := 1;
      First;

      while not EOF do
      begin
        pRowType := TIntIDAndCTypes.Create;
        pAccountId := FieldByName('account_id').AsInteger;
        pTaxId := FieldByName('tax_id').AsInteger;
        pWageId := FieldByName('wage_id').AsInteger;
        // kirje ID !
        pRowType.id2 := FieldByName('id').AsInteger;

        if pWageId > 0 then
        begin
          pName := FieldByName('wage_name').AsString;
          pRowType.id := pWageId;
          pRowType.clf := CSbtype_wage;
          pRowType.clf2 := CSbtype_wage + IntToStr(pWageId);
        end
        else
        if pTaxId > 0 then
        begin
          pName := FieldByName('taxname').AsString;
          pRowType.id := pTaxId;
          pRowType.clf := CSbtype_tax;
          pRowType.clf2 := CSbtype_tax + IntToStr(pWageId);
        end
        else
          assert(1 = 0, '#2');
        gridSalaryTemplate.Cells[CCol_rowtype, pRownr] := pName;
        gridSalaryTemplate.Objects[CCol_rowtype, pRownr] := pRowType;

        gridSalaryTemplate.Cells[CCol_formula, pRownr] := FieldByName('formula').AsString;


        // konto ka paika !
        pRowType := TIntIDAndCTypes.Create;
        pRowType.id := pAccountId;
        gridSalaryTemplate.Cells[CCol_account, pRownr] := FieldByName('account_coding').AsString;
        gridSalaryTemplate.Objects[CCol_account, pRownr] := pRowType;

        pWageObj := gridSalaryTemplate.Objects[CCol_rownumber, pRownr] as TWageFormulaParser;
        pWageObj.formula := '';
        pWageObj.parseLines('0');
        pWageObj.accumulator := 0;

        // ---
        Inc(pRownr);
        Next;
      end;
    end;


    // ------
    // jälgime muudatusi !
    self.FOrigRowLineHash := self.calcRowLineHash;
    btnSave.Enabled := False;
    btnCancel.Enabled := False;

{
if sender = self.FRowType then
with gridSalaryTemplate do
  begin
     Cells[CCol_rowtype,Row]:=plds.FieldByName('item_name').AsString;
     ptype:=Objects[CCol_rowtype,Row] as TIntIDAndCTypes;
  if not assigned(ptype) then
     ptype:=TIntIDAndCTypes.Create;
     // --
     ptype.id:=plds.FieldByName('id').AsInteger;
     ptype.clf:=plds.FieldByName('type_').AsString; // millega tegemist
     ptype.clf2:=plds.FieldByName('strid').AsString;

     // tühistame kontod; turvalisuse pärast
     Objects[CCol_rowtype,Row]:=ptype;
     Cells[CCol_formula,Row]:='('+floattostr(plds.FieldByName('perc').AsFloat)+'/100)';
     // ---

     ptype:=Objects[CCol_account,Row] as TIntIDAndCTypes;
  if assigned(ptype) then
    begin
     ptype.id:=0;
     ptype.clf:='';
     ptype.clf2:='';
    end; // ---

     Cells[CCol_account,Row]:='';
  end else
if sender = self.FAccounts then
with gridSalaryTemplate do
  begin
     Cells[CCol_account,Row]:=plds.FieldByName('account_coding').AsString;
     ptype:=Objects[CCol_account,Row] as TIntIDAndCTypes;
  if not assigned(ptype) then
     ptype:=TIntIDAndCTypes.Create;
     // --
     ptype.id:=plds.FieldByName('id').AsInteger;
     Objects[CCol_account,Row]:=ptype;
  end;
     // et muudatused tuleks nähtavale
     self.gridSalaryTemplateEditingDone(Sender);
     focusFix.Enabled:=true;
}
  finally
    self.FSkipSelectEvent := False;
  end;
end;

procedure TframeEmpwageTypeDefTemplate.gridSalaryTemplateEditingDone(Sender: TObject);
var
  b: boolean;
begin
  // --
  b := (self.FOrigRowLineHash <> self.calcRowLineHash);
  btnSave.Enabled := b;
  btnCancel.Enabled := b;
end;

procedure TframeEmpwageTypeDefTemplate.focusFixTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;

  if assigned(gridSalaryTemplate.Editor) then
  begin

    // --
    if gridSalaryTemplate.CanFocus then
      gridSalaryTemplate.SetFocus;



    if gridSalaryTemplate.Editor.CanFocus then
      gridSalaryTemplate.Editor.SetFocus;

  end;
end;

procedure TframeEmpwageTypeDefTemplate.btnSaveClick(Sender: TObject);
begin
  self.savedata;
end;

procedure TframeEmpwageTypeDefTemplate.Button1Click(Sender: TObject);
begin

  //self.validateDataWithEval;
  // calculateAll
  // self.verifyLines;
end;

procedure TframeEmpwageTypeDefTemplate.gridSalaryTemplateDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
const
  CCLeftDelta = 0;
  CCWidthDelta = -1;
begin

  if (gdFocused in aState) then
    if aRow >= 1 then
      case aCol of
        CCol_rowtype:
        begin
          FRowType.Left := aRect.Left + CCLeftDelta;
          FRowType.Top := aRect.Top;
          FRowType.Width := (aRect.Right - aRect.Left) + CCWidthDelta;
          FRowType.Height := (aRect.Bottom - aRect.Top) - 2;
          if FRowType.Height < 20 then
            FRowType.Height := 21;
        end;

        CCol_account:
        begin
          FAccounts.Left := aRect.Left + CCLeftDelta;
          FAccounts.Top := aRect.Top;
          FAccounts.Width := (aRect.Right - aRect.Left) + CCWidthDelta;
          FAccounts.Height := (aRect.Bottom - aRect.Top) - 2;
          if FAccounts.Height < 20 then
            FAccounts.Height := 21;
        end;
      end; // ---
end;

function TframeEmpwageTypeDefTemplate.calcRowLineHash: integer;
var
  pStr: AStr;
  i, j: integer;
begin
  Result := 0;
  pStr := '';

  for i := 1 to gridSalaryTemplate.RowCount - 1 do
    for j := 1 to gridSalaryTemplate.ColCount - 1 do
    begin
      pStr := pStr + gridSalaryTemplate.Cells[j, i];
      case j of
        CCol_rowtype,  // võtame ID'd ka kunagi ei tea mis imetrikke kasutaja suudab teha !
        CCol_account: if assigned(gridSalaryTemplate.Objects[j, i]) then
            with TIntIDAndCTypes(gridSalaryTemplate.Objects[j, i]) do
            begin
              pStr := pStr + IntToStr(id) + IntToStr(id2) + clf;
            end;
        //CCol_formula:;
      end;
    end;

  // --
  Result := estbk_utilities.hashpjw(pStr);
end;

procedure TframeEmpwageTypeDefTemplate.deleteRow(const pRow: integer);
begin
  gridSalaryTemplate.Cells[CCol_rowtype, pRow] := '';
  if assigned(gridSalaryTemplate.Objects[CCol_rowtype, pRow]) then
  begin
    // --
    self.FDeletedIDs.Add(Pointer(PtrInt(TIntIDAndCTypes(gridSalaryTemplate.Objects[CCol_rowtype, pRow]).id2)));
    gridSalaryTemplate.Objects[CCol_rowtype, pRow].Free;
    gridSalaryTemplate.Objects[CCol_rowtype, pRow] := nil;

  end;


  gridSalaryTemplate.Cells[CCol_rowtype, pRow] := '';
  if assigned(gridSalaryTemplate.Objects[CCol_account, pRow]) then
  begin
    gridSalaryTemplate.Objects[CCol_account, pRow].Free;
    gridSalaryTemplate.Objects[CCol_account, pRow] := nil;
  end;

  gridSalaryTemplate.Cells[CCol_formula, pRow] := '';

end;

procedure TframeEmpwageTypeDefTemplate.gridSalaryTemplateKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = []) then
  begin
    if gridSalaryTemplate.col < gridSalaryTemplate.colcount - 1 then
      gridSalaryTemplate.col := gridSalaryTemplate.col + 1
    else
    if gridSalaryTemplate.row < gridSalaryTemplate.rowcount - 1 then
    begin
      gridSalaryTemplate.row := gridSalaryTemplate.row + 1;
      gridSalaryTemplate.col := 1;
    end;
    // ---
    key := 0;
  end
  else
  if (key = VK_DELETE) and (Shift = [ssCtrl]) then
  begin

    self.deleteRow(gridSalaryTemplate.row);
    key := 0;
  end;
end;

procedure TframeEmpwageTypeDefTemplate.gridSalaryTemplateKeyPress(Sender: TObject; var Key: char);
begin
  // --
end;

procedure TframeEmpwageTypeDefTemplate.gridSalaryTemplatePrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
var
  ptype: TIntIDAndCTypes;
begin
  ptype := gridSalaryTemplate.Objects[CCol_rowtype, aRow] as TIntIDAndCTypes;
  if (aCol = CCol_rownumber) then
    gridSalaryTemplate.Canvas.Brush.Color := clBtnFace
  else
  if assigned(ptype) and (ptype.clf = CSbtype_tax) then
    gridSalaryTemplate.Canvas.Brush.Color := estbk_types.MyFavLightYellow
  else
    gridSalaryTemplate.Canvas.Brush.Color := clWindow;
end;


procedure TframeEmpwageTypeDefTemplate.gridSalaryTemplateSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
var
  ptype: TIntIDAndCTypes;
  paccountid: integer;
begin
  // --
  try
    self.FSkipSelectEvent := True;
    ptype := nil;

    if assigned(gridSalaryTemplate.Objects[aCol, aRow]) and (gridSalaryTemplate.Objects[aCol, aRow] is TIntIDAndCTypes) then
      ptype := gridSalaryTemplate.Objects[aCol, aRow] as TIntIDAndCTypes;


    FRowType.Visible := False;
    FAccounts.Visible := False;
    // --
    case aCol of
      CCol_rownumber: Editor := nil;
      CCol_rowtype:
      begin
        FRowType.Text := '';
        FRowType.Value := '';
        Editor := self.FRowType;

        if assigned(ptype) then
        begin
          assert(qryRowltype.Locate('id;type_', VarArrayOf([integer(ptype.id), AStr(ptype.clf)]), []), '#1');
          paccountid := qryRowltype.FieldByName('account_id').AsInteger;
          FRowType.Value := qryRowltype.FieldByName('strid').AsString;
        end;


        FRowType.Enabled := True;
        FRowType.Visible := True;
      end;

      CCol_account:
      begin
        FAccounts.Text := '';
        FAccounts.Value := '';
        Editor := self.FAccounts;
        if assigned(ptype) then
        begin
          qryAccounts.Locate('id', ptype.id, []);
          FAccounts.Value := IntToStr(ptype.id);
          FAccounts.Text := qryAccounts.FieldByName('account_coding').AsString;
        end;

        FAccounts.Enabled := True;
        FAccounts.Visible := True;
      end;

      CCol_formula:
      begin
        Editor := TStringCellEditor(gridSalaryTemplate.EditorByStyle(cbsAuto));
      end;
    end;
    // --
    //focusFix.Enabled:=true;

  finally
    self.FSkipSelectEvent := False;
  end;
end;

function TframeEmpwageTypeDefTemplate.calcRowValue(const prowNr: integer): double;
begin
  Result := 0.00;
  // if  not self.FTemplateMode then arvuta läbi rida
end;

// mängime valemid ka läbi !
function TframeEmpwageTypeDefTemplate.validateDataWithEval: boolean;
const
  CDummyDefaultVal: double = 0.000001;  // väärtus selline selleks, et kusagil 0 jagamist ei tekiks kui valemit kontrollitakse
var
  pMaskVal: TAStrList;
  pObj: TObjectList;
  i: integer;
  pWageObj: TWageFormulaParser;
begin
  try
    Result := True;

    try
      pObj := TObjectList.Create(False);
      pMaskVal := TAStrList.Create;

      for i := 1 to gridSalaryTemplate.RowCount - 1 do
        if (trim(gridSalaryTemplate.Cells[CCol_rowtype, i]) <> '') and (trim(gridSalaryTemplate.Cells[CCol_account, i]) <> '') then
        begin
          pWageObj := gridSalaryTemplate.Objects[CCol_rownumber, i] as TWageFormulaParser;
          pWageObj.formula := trim(gridSalaryTemplate.Cells[CCol_formula, i]);
          if pWageObj.formula = '' then
            pWageObj.formula := '0';
          pObj.Add(pWageObj);
        end;


      pMaskVal.Add('[' + CMarkWhours + ']=' + floattostr(CDummyDefaultVal));
      pMaskVal.Add('[' + CMarkMhours + ']=' + floattostr(CDummyDefaultVal));
      pMaskVal.Add('[' + CMarkSickDays + ']=' + floattostr(CDummyDefaultVal));
      estbk_lib_formulaparserext.replaceMarkers(pObj, pMaskVal);
      estbk_lib_formulaparserext.calculateAll(pObj);

    finally
      FreeAndNil(pObj);
      FreeAndNil(pMaskVal);
    end;

    // ---
  except
    on e: Exception do
  end;
end;


function TframeEmpwageTypeDefTemplate.verifyLines: boolean;
var
  i, j, prLineNr: integer;
  pFrmp: TWageFormulaParser;
  //  pParseFrm  : TFormulaPreParser;
  //  pRevPolish : TRevPolish;
begin

  // kontrollime valemid ka üle
  //      pParseFrm:=TFormulaPreParser.Create;
  //      pRevPolish:=TRevPolish.Create;
  //      34534
  // --
  Result := True;
  with gridSalaryTemplate do
    for i := 1 to RowCount - 1 do
      try
        if ((trim(Cells[CCol_rowtype, i]) = '') and (trim(Cells[CCol_account, i]) = '')) then
          continue;

        if (((trim(Cells[CCol_rowtype, i]) <> '') and (trim(Cells[CCol_account, i]) = '')) or
          ((trim(Cells[CCol_account, i]) <> '') and (trim(Cells[CCol_rowtype, i]) = ''))) then
        begin
          Dialogs.messageDlg(estbk_strmsg.SESalaryTemplateIncorrectLine, mtError, [mbOK], 0);
          Row := i;
          Result := False;
          Exit;
        end;

        if (trim(Cells[CCol_formula, i]) = '') then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEFormulaEmpty, mtError, [mbOK], 0);
          Row := i;
          Result := False;
          Exit;
        end;

        // kui viga siis pistab karjuma !
        // --- nüüd paneme parseri ka tööle...
        //TWageFormulaParser(Objects[CCol_rownumber,i]).parseLines(Cells[CCol_formula,i]);


      except
        on e: Exception do
        begin
          Dialogs.messageDlg(estbk_strmsg.SESalaryTemplateIncorrectLine, mtError, [mbOK], 0);
          Result := False;
          Exit;
        end;
      end;



  // --- kontrollime üle R read !
  with gridSalaryTemplate do
    for i := 1 to RowCount - 1 do
    begin
      pFrmp := Objects[CCol_rownumber, i] as TWageFormulaParser;
      for j := 0 to pFrmp.RLines.Count - 1 do
      begin
        // ---
        prLineNr := strtointdef(stringreplace(pFrmp.RLines.Strings[j], '$', '', []), -1);
        if (prLineNr < 1) or (prLineNr > RowCount) then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEFormulaContainsUnkMarker + ' ' + Cells[CCol_formula, i], mtError, [mbOK], 0);
          Row := i;
          Result := False;
          Exit;
        end;
      end;
{
     CMarkWhours  =  '@TT'; // töötunnid
  CMarkMhours   = '@PT'; // puudutud tunnid
  CMarkSickDays = '@HP'; // haiguspäevad
}
    end;

  // 31.01.2012 Ingmar
  Result := self.validateDataWithEval;
end;

procedure TframeEmpwageTypeDefTemplate.saveData;
// @@1
  procedure __delrline(const pid: integer);
  var
    j: integer;
  begin
    with qryTemp, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLDeleteEmpWageDef);

        paramByname('pid').AsInteger := pid;
        paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('rec_deleted').AsString := estbk_types.SCFalseTrue[True];
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        ExecSQL;

      finally
        Close;
        Clear;
      end;
    // --
  end;

  // @@2
  procedure __insu_pdt_rline(const pEmpWageLineId: integer; const prownr: integer;
  const paccountid: integer; const pdescr: TIntIDAndCTypes;
  const pinsertmode: boolean = True);
  begin
    with qryTemp, SQL do
      try
        Close;
        Clear;

        case pinsertmode of
          True:
          begin
            add(estbk_sqlclientcollection._SQLInsertEmpWageDef2);
            paramByname('employee_wage_id').AsInteger := self.FEmployeeWageRecID; // !! tegemist on aluskirjega !!!!
            paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          end;

          False:
          begin
            add(estbk_sqlclientcollection._SQLUpdateEmpWageDef2);
            paramByname('id').AsInteger := pEmpWageLineId;
          end;
        end;


        paramByname('wage_type_id').AsInteger := 0;
        paramByname('tax_id').AsInteger := 0;

        if pdescr.clf = CSbtype_wage then // palgatüübi rida...
          paramByname('wage_type_id').AsInteger := pdescr.id // tasu id
        else
          paramByname('tax_id').AsInteger := pdescr.id; // maksu id
        //paramByname('template_line').AsString:=estbk_types.SCFalseTrue[ self.FTemplateMode];
        paramByname('row_id').AsString := IntToStr(prownr);
        paramByname('formula').AsString := trim(gridSalaryTemplate.Cells[CCol_formula, prownr]);
        //paramByname('valid_from').Value:=null;
        //paramByname('valid_until').Value:=null;
        paramByname('unit').AsString := '';
        paramByname('price').AsFloat := self.calcRowValue(prownr);

        paramByname('account_id').AsInteger := paccountid;
        paramByname('flags').AsInteger := 0;
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        ExecSQL;

      finally
        Close;
        Clear;
      end;
    // ---
  end;

var
  i: integer;
  ptype: TIntIDAndCTypes;
  paccountId: integer;
begin
  if not self.verifyLines then
    Exit;

  try
    self.FSkipSelectEvent := True;
    // --
    try
      dmodule.primConnection.StartTransaction;
      // ---
      for i := 0 to self.FDeletedIDs.Count - 1 do
        __delrline(PtrInt(self.FDeletedIDs.Items[i]));


      for i := 1 to gridSalaryTemplate.RowCount - 1 do
        //   if ((trim(gridSalaryTemplate.Cells[CCol_rowtype,i])<>'') and
        //       (trim(gridSalaryTemplate.Cells[CCol_account,i])<>'')) then
      begin
        paccountId := 0;
        if assigned(gridSalaryTemplate.Objects[CCol_account, i]) then
          paccountId := TIntIDAndCTypes(gridSalaryTemplate.Objects[CCol_account, i]).id;

        //---
        ptype := gridSalaryTemplate.Objects[CCol_rowtype, i] as TIntIDAndCTypes;
        if assigned(ptype) then
        begin
          // NB id2 = rea ID !!
          // kustutada, järelikult olukord, kus kasutaja on backspace abil lookupid tühjaks kustutanud; see samavõrdne delete käsuga
          if (ptype.id2 > 0) and (ptype.id = 0) then
            __delrline(ptype.id2)
          else
            __insu_pdt_rline(ptype.id2, i, paccountId, ptype, ((ptype.id2 = 0) and (ptype.id > 0)));
        end; // --
      end;

      // ---
      self.FDeletedIDs.Clear;
      dmodule.primConnection.Commit;

      // -- laeme andmed uuesti, et vältida vigu
      if self.FTemplateMode then
        self.loadEmployeeWageTemplate(estbk_globvars.glob_zemployee)
      else
        self.loadEmployeeWageTemplate(self.FCurrEmployeeId);

      btnSave.Enabled := False;
      btnCancel.Enabled := False;
    except
      on e: Exception do
      begin
        if dmodule.primConnection.inTransaction then
          try
            dmodule.primConnection.Rollback;
          except
          end;
        if not (e is eabort) then
          Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
        Exit; // ---
      end;
    end;

  finally
    self.FSkipSelectEvent := False;
  end;
end;

procedure TframeEmpwageTypeDefTemplate.performCleanup;
var
  i: integer;
  pWageObj: TWageFormulaParser;
begin
  try
    self.FEmployeeWageRecID := 0;
    self.FSkipSelectEvent := True;
    FRowType.Visible := False;
    FRowType.Text := '';
    FRowType.Value := '';
    FAccounts.Visible := False;
    FAccounts.Text := '';
    FAccounts.Value := '';

    for i := 1 to gridSalaryTemplate.RowCount - 1 do
      self.deleteRow(i);
    self.FDeletedIDs.Clear; // seda infot pole siin vaja hoida !


    for i := 1 to gridSalaryTemplate.RowCount - 1 do
    begin
      pWageObj := gridSalaryTemplate.Objects[CCol_rownumber, i] as TWageFormulaParser;
      if not assigned(pWageObj) then
        continue;

      pWageObj.formula := '';
      pWageObj.parseLines('0');
      pWageObj.accumulator := 0;
    end;

    // ---
  finally
    self.FSkipSelectEvent := False;
  end;
end;

procedure TframeEmpwageTypeDefTemplate.OnLookupGetGridCellProps(Sender: TObject; Field: TField; AFont: TFont; var Background: TColor);
begin
  if qryRowltype.FieldByName('type_').AsString = CSbtype_tax then
    Background := estbk_Types.MyFavLightYellow
  else
    Background := clWindow;
end;

procedure TframeEmpwageTypeDefTemplate.OnLookupPopupClose(Sender: TObject; SearchResult: boolean);
begin
end;

procedure TframeEmpwageTypeDefTemplate.OnLookupKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  with TRxDBLookupCombo(Sender) do

    if Shift = [] then
      case key of
        VK_RETURN,
        VK_RIGHT,
        VK_TAB:
        begin
          gridSalaryTemplate.Col := gridSalaryTemplate.Col + 1;
          if gridSalaryTemplate.CanFocus then
            gridSalaryTemplate.SetFocus;
          // ---
          focusFix.Enabled := True;
          key := 0;
        end;

        VK_DOWN,
        VK_NEXT: if not popUpVisible then
          begin
            //Visible := False;
            //DroppedDown := False;
            if gridSalaryTemplate.Row + 1 <= gridSalaryTemplate.RowCount then
              gridSalaryTemplate.Row := gridSalaryTemplate.Row + 1;

            if gridSalaryTemplate.CanFocus then
              gridSalaryTemplate.SetFocus;

            // ---
            key := 0;
          end;

        VK_UP,
        VK_PRIOR: if not popUpVisible then
          begin
            if gridSalaryTemplate.Row - 1 > 0 then
              gridSalaryTemplate.Row := gridSalaryTemplate.Row - 1;

            if gridSalaryTemplate.CanFocus then
              gridSalaryTemplate.SetFocus;

            // ---
            key := 0;
          end;
        VK_DELETE:
          try
            self.FSkipSelectEvent := True;
            TRxDBLookupCombo(Sender).Text := '';
            TRxDBLookupCombo(Sender).Value := '';
            if assigned(gridSalaryTemplate.Objects[gridSalaryTemplate.Col, gridSalaryTemplate.Row]) then
            begin
              gridSalaryTemplate.Objects[gridSalaryTemplate.Col, gridSalaryTemplate.Row].Free;
              gridSalaryTemplate.Objects[gridSalaryTemplate.Col, gridSalaryTemplate.Row] := nil;
            end;
            // --
          finally
            self.FSkipSelectEvent := False;
          end;
        // --
      end
    else
    if key = VK_DELETE then  //  if(Shift=[ssCtrl]) then
      self.deleteRow(gridSalaryTemplate.Row);
end;

procedure TframeEmpwageTypeDefTemplate.OnLookupChange(Sender: TObject);
var
  ptype: TIntIDAndCTypes;
begin
  if self.FSkipSelectEvent then
    Exit;

  ptype := gridSalaryTemplate.Objects[gridSalaryTemplate.Col, gridSalaryTemplate.Row] as TIntIDAndCTypes;
  if (trim(TRxDBLookupCombo(Sender).Text) = '') and assigned(ptype) then
  begin
    ptype.id := 0;
    ptype.clf := '';
    ptype.clf2 := '';
  end;
end;

procedure TframeEmpwageTypeDefTemplate.OnLookupSelect(Sender: TObject);
var
  ptype: TIntIDAndCTypes;
  plds: TDataset;
begin
  if self.FSkipSelectEvent then
    Exit;
  // --
  plds := TRxDBLookupCombo(Sender).LookupSource.DataSet;
  if Sender = self.FRowType then
    with gridSalaryTemplate do
    begin
      Cells[CCol_rowtype, Row] := plds.FieldByName('item_name').AsString;
      ptype := Objects[CCol_rowtype, Row] as TIntIDAndCTypes;
      if not assigned(ptype) then
        ptype := TIntIDAndCTypes.Create;
      // --
      ptype.id := plds.FieldByName('id').AsInteger;
      ptype.clf := plds.FieldByName('type_').AsString; // millega tegemist
      ptype.clf2 := plds.FieldByName('strid').AsString;

      // tühistame kontod; turvalisuse pärast
      Objects[CCol_rowtype, Row] := ptype;
      Cells[CCol_formula, Row] := '(' + floattostr(plds.FieldByName('perc').AsFloat) + '/100)';
      // ---

      ptype := Objects[CCol_account, Row] as TIntIDAndCTypes;
      if assigned(ptype) then
      begin
        ptype.id := 0;
        ptype.clf := '';
        ptype.clf2 := '';
      end; // ---

      Cells[CCol_account, Row] := '';
    end
  else
  if Sender = self.FAccounts then
    with gridSalaryTemplate do
    begin
      Cells[CCol_account, Row] := plds.FieldByName('account_coding').AsString;
      ptype := Objects[CCol_account, Row] as TIntIDAndCTypes;
      if not assigned(ptype) then
        ptype := TIntIDAndCTypes.Create;
      // --
      ptype.id := plds.FieldByName('id').AsInteger;
      Objects[CCol_account, Row] := ptype;
    end;
  // et muudatused tuleks nähtavale
  self.gridSalaryTemplateEditingDone(Sender);
  focusFix.Enabled := True;
end;

procedure TframeEmpwageTypeDefTemplate.OnLookupEnter(Sender: TObject);
begin
end;

procedure TframeEmpwageTypeDefTemplate.OnLookupExit(Sender: TObject);
begin
end;

constructor TframeEmpwageTypeDefTemplate.Create(frameOwner: TComponent);
var
  pCollItem: TCollectionItem;
  i: integer;
begin
  inherited Create(frameOwner);
  self.FSkipSelectEvent := True;
  //  ---
  for i := 1 to gridSalaryTemplate.RowCount - 1 do
    gridSalaryTemplate.Objects[CCol_rownumber, i] := estbk_lib_formulaparserext.TWageFormulaParser.Create(format('$%d', [i]));

  // --
  self.FTemplateMode := True;
  estbk_uivisualinit.__preparevisual(self);
  FDeletedIDs := TList.Create;
  FRowType := TRxDBLookupCombo.Create(self.gridSalaryTemplate);
  FRowType.AutoSize := False;
  FRowType.parent := self.gridSalaryTemplate;
  FRowType.Visible := False;
  FRowType.Left := CLeftHiddenCorn;

  FRowType.OnKeyDown := @self.OnLookupKeydown;
  FRowType.OnEnter := @self.OnLookupEnter;
  FRowType.OnExit := @self.OnLookupExit;
  FRowType.OnClosePopupNotif := @self.OnLookupPopupClose;
  FRowType.OnChange := @self.OnLookupChange;
  //FAccListCombo.PopUpFormOptions.OnGetCellProps:=@self.OnDbLookupComboSelColor;
  FRowType.OnSelect := @self.OnLookupSelect;
  FRowType.OnGetGridCellProps := @self.OnLookupGetGridCellProps;
  FRowType.PopUpFormOptions.OnGetCellProps := @self.OnLookupGetGridCellProps;

  FRowType.ParentFont := True;
  FRowType.ParentColor := False;
  FRowType.ShowHint := True;
  FRowType.DoubleBuffered := True;
  FRowType.EmptyValue := #32;
  FRowType.Flat := True;
  FRowType.BorderStyle := bsNone;
  FRowType.PopUpFormOptions.BorderStyle := bsNone;
  FRowType.PopUpFormOptions.Options := [pfgIndicator, pfgRowlines, pfgCollines, pfgColumnResize];
  FRowType.PopUpFormOptions.TitleButtons := True;
  FRowType.DropDownCount := 20;
  FRowType.DropDownWidth := 315;

  FRowType.LookupSource := self.qryRowltypeDs;
  FRowType.LookupDisplay := 'item_name';
  FRowType.LookupField := 'strid';


  pCollItem := FRowType.PopUpFormOptions.Columns.Add;
  (pCollItem as TPopUpColumn).Title.Caption := estbk_strmsg.SCFWageTaxLine;
  (pCollItem as TPopUpColumn).Fieldname := 'item_name';
  (pCollItem as TPopUpColumn).Width := 270;


  FRowType.EmptyValue := #32;
  FRowType.UnfindedValue := rxufNone;
  //FAccListCombo.UnfindedValue:=rxufNone;
  FRowType.ButtonWidth := 15;
  FRowType.ButtonOnlyWhenFocused := False;
  FRowType.Height := 23;
  FRowType.PopUpFormOptions.ShowTitles := True;
  FRowType.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;

  FAccounts := TRxDBLookupCombo.Create(self.gridSalaryTemplate);
  FAccounts.parent := self.gridSalaryTemplate;
  FAccounts.Visible := False;
  FAccounts.Name := 'FAccounts';
  FAccounts.ParentFont := False;
  FAccounts.ParentColor := False;
  FAccounts.ShowHint := True;
  FAccounts.DoubleBuffered := True;



  FAccounts.LookupSource := self.qryAccountsDs;
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


  FAccounts.OnEnter := @self.OnLookupEnter;
  FAccounts.OnExit := @self.OnLookupExit;
  FAccounts.OnSelect := @self.OnLookupSelect;
  FAccounts.OnChange := @self.OnLookupChange;
  FAccounts.OnClosePopupNotif := @self.OnLookupPopupClose;
  FAccounts.OnKeyDown := @self.OnLookupKeydown;


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

  FAccounts.OnLookupTitleColClick := @__intUIMiscHelperClass.OnLookupComboTitleClick;
  TStringCellEditor(gridSalaryTemplate.EditorByStyle(cbsAuto)).OnClick := @__intUIMiscHelperClass.OnClickEditFocusFix;
  TStringCellEditor(gridSalaryTemplate.EditorByStyle(cbsAuto)).OnKeyDown := @self.gridSalaryTemplateKeyDown;
  TStringCellEditor(gridSalaryTemplate.EditorByStyle(cbsAuto)).OnKeyPress := @self.gridSalaryTemplateKeyPress;

  TStringCellEditor(gridSalaryTemplate.EditorByStyle(cbsAuto)).OnExit := @self.gridSalaryTemplateEditingDone;
  TStringCellEditor(gridSalaryTemplate.EditorByStyle(cbsAuto)).OnChange := @self.gridSalaryTemplateEditingDone;



  // markerid paika;
  for i := 1 to gridSalaryTemplate.RowCount - 1 do
    gridSalaryTemplate.Cells[0, i] := format('$%d ', [i]);

  self.FSkipSelectEvent := False;
end;

destructor TframeEmpwageTypeDefTemplate.Destroy;
var
  i: integer;
begin
  for i := 1 to gridSalaryTemplate.RowCount - 1 do
    if assigned(gridSalaryTemplate.Objects[CCol_rownumber, i]) then
    begin
      gridSalaryTemplate.Objects[CCol_rownumber, i].Free;
      gridSalaryTemplate.Objects[CCol_rownumber, i] := nil;
    end;

  self.performCleanup;
  FDeletedIDs.Free;
  inherited Destroy;
end;

initialization
  {$I estbk_fra_employee_wagetemplate.ctrs}

end.