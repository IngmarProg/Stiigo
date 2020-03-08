unit estbk_fra_declforms;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

// NativeInt
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, Grids,
  ComCtrls, ExtCtrls, Graphics, TypInfo, Buttons, Dialogs, LCLType, LCLProc, Clipbrd,
  Menus, Contnrs, ZDataset, ZSequence, estbk_fra_template, estbk_types, estbk_lib_commonevents, DOM, XMLRead, XMLWrite,
  estbk_clientdatamodule, estbk_fra_declformulacreator, estbk_formxframes,
  estbk_lib_calcdhelper, estbk_lib_revpolish, estbk_inputformex;

type
  TDeclFrameMode = (__declDisplayForms,
    __declDisplayFormContent
    );


type
  TDeclRowRez = (__declrmNullLine,
    __declrmInsertAllowed,
    __declrmDeleteAllowed);


type
  TDeclVerifiedLines = class(TCollectionItem)
  public
    FLineId: integer;
    FGridLineNr: integer;
    FGridLineOrigNr: integer;
    FGridLineUniqId: AStr; // row_id
    FLineBaseRecordId: integer;
    FDescr: AStr;
    FLogLineNr: AStr;
    FFormula: AStr;
    FLineHash: integer;
  end;

type

  { TframeDeclForms }

  TframeDeclForms = class(Tfra_template)
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnSave: TBitBtn;
    grpBoxDefDeclLines: TGroupBox;
    mnuPaste: TMenuItem;
    mnuCopyCell: TMenuItem;
    mnuSep3: TMenuItem;
    mnuItemExport: TMenuItem;
    mnuItemImport: TMenuItem;
    mnuItem: TMenuItem;
    mnu2Spaces: TMenuItem;
    mnuItemNewLine: TMenuItem;
    mnuSep: TMenuItem;
    mnuItemUp: TMenuItem;
    mnuItemDown: TMenuItem;
    pOpenXmlAs: TOpenDialog;
    pnewForm: TMenuItem;
    pgridDeclForms: TStringGrid;
    pFormdLinesEventsPopup: TPopupMenu;
    pSpecialTasks: TPopupMenu;
    qryTaxFormsSel: TZQuery;
    qryWorker: TZQuery;
    qryFormdSeq: TZSequence;
    pSaveXmlAs: TSaveDialog;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnu2SpacesClick(Sender: TObject);
    procedure mnuCopyCellClick(Sender: TObject);
    procedure mnuItemDownClick(Sender: TObject);
    procedure mnuItemExportClick(Sender: TObject);
    procedure mnuItemImportClick(Sender: TObject);
    procedure mnuItemNewLineClick(Sender: TObject);
    procedure mnuItemUpClick(Sender: TObject);
    procedure pgridDeclFormsClick(Sender: TObject);
    procedure pgridDeclFormsDblClick(Sender: TObject);
    procedure pgridDeclFormsDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure pgridDeclFormsEditButtonClick(Sender: TObject);
    procedure pgridDeclFormsEditingDone(Sender: TObject);
    procedure pgridDeclFormsExit(Sender: TObject);
    procedure pgridDeclFormsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure pgridDeclFormsPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
    procedure pgridDeclFormsResize(Sender: TObject);
    procedure pgridDeclFormsSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
    procedure pgridDeclFormsSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure pgridDeclFormsShowHint(Sender: TObject; HintInfo: PHintInfo);
    procedure pnewFormClick(Sender: TObject);
  private
    FformDefaultSubType: AStr;
    FOrigColUniqId: AStr; // jäetakse meelde originaaltunnus
    FLastActiveRow: integer;
    FDeletedItems: TObjectList;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FDeclFrameMode: TDeclFrameMode;

    FSelectedFormId: integer;

    FGridHeightCorrected: boolean;
    FLinesImportedFromFile: boolean;
    // ---
    procedure setDeclFrameMode(const v: TDeclFrameMode);

    procedure doOnCellEditorExit(Sender: TObject);
    procedure doOnclickFix(Sender: TObject);
    procedure doCleanup;
    procedure loadGridLines;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    function getRowMode(const prowNr: integer): TDeclRowRez;
    procedure checkForRowSwitch;

    function findUniqRowId: AStr;
    procedure insertNewLine(const pRow: integer);
    procedure deleteLine(const pRow: integer);
    procedure moveRow(const pCurrentRowNr: integer; const pMoveDown: boolean);
    procedure switchRows(const pSourceRowNr: integer; const pDestRowNr: integer);

    function verifyGridLines(const pCollection: TCollection): boolean;
    procedure onEditorKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);

  public
    // kuna lazaruse bugi; frame onResize eventi ei tule/samuti gridil mitte, peame hackintoshi tegema
    procedure forceResize;
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published // RTTI fix
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;

    // kas detailne või üldine vormide loend !
    property declFrameMode: TDeclFrameMode read FDeclFrameMode write setDeclFrameMode;
    property selectedFormId: integer read FSelectedFormId write FSelectedFormId;
    // vormi tunnus; käibemaksu vormid on tunnusega "V"
    // CFormTypeAsVatDecl
    property formDefaultSubType: AStr read FformDefaultSubType write FformDefaultSubType;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

uses estbk_uivisualinit, estbk_strmsg, estbk_sqlclientcollection,
  estbk_lib_commoncls, estbk_globvars, estbk_utilities, estbk_lib_declcalc;

const
  CCol_uniqId = 0;
  CCol_description = 1;
  CCol_logrownr = 2;
  CCol_formula = 3;
  CCol_action = 4;

{
procedure TForm1.AutoSizeCol(Grid: TStringGrid; Column: integer);
var
  i, W, WMax: integer;
begin
  WMax := 0;
  for i := 0 to (Grid.RowCount - 1) do begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax + 5;
end;
}

procedure TframeDeclForms.onEditorKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  pTemp: AStr;
begin

  pTemp := TCustomEdit(Sender).Text;
  if (key in [VK_LEFT, VK_RIGHT]) and (pTemp <> '') and (TCustomEdit(Sender).SelLength = length(pTemp)) then
  begin
    TCustomEdit(Sender).SelStart := length(ptemp);
    TCustomEdit(Sender).SelLength := 0;
    key := 0;
  end;
end;



procedure TframeDeclForms.setDeclFrameMode(const v: TDeclFrameMode);
var
  b: boolean;
begin
  FDeclFrameMode := v;
  b := (v = __declDisplayFormContent);

  btnSave.Visible := b;
  btnCancel.Visible := b;

  pgridDeclForms.Top := 1;
  pgridDeclForms.Height := 403;

  if not b then
  begin

    grpBoxDefDeclLines.Caption := estbk_strmsg.SCDeclCommonName;

    // --
    pgridDeclForms.Columns.Items[CCol_description].Title.Caption := estbk_strmsg.SCDeclGridCapt;
    pgridDeclForms.Columns.Items[CCol_description].Width := 360;
    pgridDeclForms.Columns.Items[CCol_description].ReadOnly := True;

    pgridDeclForms.Columns.Items[CCol_logrownr].Visible := False;
    pgridDeclForms.Columns.Items[CCol_formula].Visible := False;
    pgridDeclForms.Columns.Items[CCol_action].Visible := False;
    pgridDeclForms.Columns.Items[CCol_uniqId].Visible := False;
    pgridDeclForms.Options := pgridDeclForms.Options + [goRowSelect];

    TButtonCellEditor(pgridDeclForms.EditorByStyle(cbsEllipsis)).PopupMenu := nil;
    TStringCellEditor(pgridDeclForms.EditorByStyle(cbsAuto)).PopupMenu := nil;

  end
  else
  begin
    grpBoxDefDeclLines.Caption := estbk_strmsg.SCDeclLines;



    // --
    pgridDeclForms.Columns.Items[CCol_description].Title.Caption := estbk_strmsg.SCDeclColname;
    pgridDeclForms.Columns.Items[CCol_description].Width := 327; //395;
    pgridDeclForms.Columns.Items[CCol_description].ReadOnly := False;

    pgridDeclForms.Columns.Items[CCol_logrownr].Visible := True;
    pgridDeclForms.Columns.Items[CCol_formula].Visible := True;
    pgridDeclForms.Columns.Items[CCol_action].Visible := True;
    pgridDeclForms.Columns.Items[CCol_uniqId].Visible := True;

    pgridDeclForms.Options := pgridDeclForms.Options - [goRowSelect];

    TButtonCellEditor(pgridDeclForms.EditorByStyle(cbsEllipsis)).PopupMenu := self.pFormdLinesEventsPopup;
    TStringCellEditor(pgridDeclForms.EditorByStyle(cbsAuto)).PopupMenu := self.pFormdLinesEventsPopup;
    // TStringCellEditor(pgridDeclForms.EditorByStyle(cbsAuto)).OnExit;
  end;
end;


function TframeDeclForms.getDataLoadStatus: boolean;
begin
  Result := True;
end;

procedure TframeDeclForms.doCleanup;
var
  i, j: integer;
begin
  self.FLastActiveRow := 0;
  self.FOrigColUniqId := '';

  // Clean(1,rowNr,1,rowNr,[gzNormal]);
  with pgridDeclForms do
  begin
    for i := 1 to RowCount - 1 do
      for j := 0 to ColCount - 1 do
      begin
        Cells[j, i] := '';
        if assigned(Objects[j, i]) then
        begin
          Objects[j, i].Free;
          Objects[j, i] := nil;
        end;
      end;
    // --
    Repaint;
    Row := 1;
    Col := 1;
  end;
end;


procedure TframeDeclForms.loadGridLines;
var
  prowNr: integer;
  prowDescr: TIntIDAndCTypes;
  pformula: AStr;
  pRefObjList: TObjectList;
begin
  try
    pRefObjList := TObjectList.Create(True);
    self.doCleanup;

    // 25.02.2011; ingmar üldiselt nii, et kui valem puudub, siis vaadatakse, kas viidatakse antud reale !
    if (self.FDeclFrameMode = __declDisplayFormContent) then
      dmodule.fetchAccRefFormdLine(self.FSelectedFormId, pRefObjList);



    qryTaxFormsSel.First;
    prowNr := 1;
    pgridDeclForms.Enabled := True;


    while not qryTaxFormsSel.EOF do
    begin

      case self.FDeclFrameMode of
        __declDisplayForms:
        begin
          pgridDeclForms.Cells[CCol_description, prowNr] := qryTaxFormsSel.FieldByName('form_name').AsString;
          // --
          prowDescr := TIntIDAndCTypes.Create;
          prowDescr.id := qryTaxFormsSel.FieldByName('id').AsInteger;
          prowDescr.id2 := 0;
          pgridDeclForms.Objects[CCol_description, prowNr] := prowDescr;
        end;

        __declDisplayFormContent:
        begin
          // 25.02.2011 Ingmar
          pformula := trim(qryTaxFormsSel.FieldByName('formula').AsString);
          if pformula = '' then
            pformula := dmodule.buildDefaultFormulaLine(qryTaxFormsSel.FieldByName('id').AsInteger, pRefObjList);


          // ---
          pgridDeclForms.Cells[CCol_uniqId, prowNr] := qryTaxFormsSel.FieldByName('row_id').AsString;
          pgridDeclForms.Cells[CCol_description, prowNr] := qryTaxFormsSel.FieldByName('line_descr').AsString;
          pgridDeclForms.Cells[CCol_logrownr, prowNr] := qryTaxFormsSel.FieldByName('log_nr').AsString;
          pgridDeclForms.Cells[CCol_formula, prowNr] := pformula;


          prowDescr := TIntIDAndCTypes.Create;
          prowDescr.id := qryTaxFormsSel.FieldByName('id').AsInteger;
          prowDescr.id2 := qryTaxFormsSel.FieldByName('baserecord_id').AsInteger;
          // 12.03.2011 Ingmar
          prowDescr.misc := qryTaxFormsSel.FieldByName('row_nr').AsInteger;


          // kasutame hetkel flags välja, et hoida checksumi, kas rida ka muutus
          prowDescr.flags :=
            estbk_utilities.hashpjw(qryTaxFormsSel.FieldByName('row_id').AsString + qryTaxFormsSel.FieldByName('line_descr').AsString +
            qryTaxFormsSel.FieldByName('log_nr').AsString + pformula);
          pgridDeclForms.Objects[CCol_description, prowNr] := prowDescr;
        end;
      end;

      // ---
      Inc(prowNr);
      qryTaxFormsSel.Next;
    end;


    // --
  finally
    FreeAndNil(pRefObjList);
  end;

  // 19.11.2010 Ingmar; tühjas deklaris pole ju ridu veel !
  if (self.FDeclFrameMode = __declDisplayFormContent) and (prowNr = 1) then
  begin
    prowDescr := TIntIDAndCTypes.Create;
    prowDescr.id := 0;
    pgridDeclForms.Objects[CCol_description, prowNr] := prowDescr;
    pgridDeclForms.Cells[CCol_uniqId, prowNr] := estbk_types.CFormulaLineSpecialMarker + '1';
  end;
end;

procedure TframeDeclForms.setDataLoadStatus(const v: boolean);
begin
  qryTaxFormsSel.Close;
  qryTaxFormsSel.SQL.Clear;

  if v then
  begin
    qryTaxFormsSel.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryWorker.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryFormdSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;

    if self.FDeclFrameMode = __declDisplayForms then
    begin
      qryTaxFormsSel.SQL.add(estbk_sqlclientcollection._SQLSelectGetTaxForms(0, self.FformDefaultSubType));
      pgridDeclForms.PopupMenu := self.pSpecialTasks;
    end
    else
    if self.FDeclFrameMode = __declDisplayFormContent then
    begin
      qryTaxFormsSel.SQL.add(estbk_sqlclientcollection._SQLSelectDFormDetailedLines);
      qryTaxFormsSel.paramByname('formd_id').AsInteger := self.FSelectedFormId;
      pgridDeclForms.PopupMenu := pFormdLinesEventsPopup;
    end;

    // ---
    qryTaxFormsSel.active := v;
    self.loadGridLines;
  end
  else
  begin
    qryTaxFormsSel.Connection := nil;
    qryWorker.Connection := nil;
  end;
end;

// 28.05.2011 Ingmar
procedure TframeDeclForms.doOnCellEditorExit(Sender: TObject);
begin
  self.pgridDeclFormsEditingDone(pgridDeclForms);
end;


procedure TframeDeclForms.doOnclickFix(Sender: TObject);
var
  pCustEdit: TCustomEdit;
begin
{
TPoint Point = {0};
GetCursorPos ( &Point );
// Now you have to convert the Point.x and Point.y
// relative to your CustomEdit and Sent CustomEdit
// the EM_CHARFROMPOS message
.....
WORD x = (WORD)Point.x;
WORD y = (WORD)Point.y;
long xy = MAKELPARAM ( x, y );
long charpos = SendMessage ( CustomEdit->Handle, EM_CHARFROMPOS, 0, xy );
}
  if (Sender is TWinControl) then
    with TWinControl(Sender) do
      // 25.05.2011 ingmar
    begin
      // lazaruse fookuse probleemid, et kui selekteeritud, siis viiks hiire õigesse kohta
      if TWinControl(Sender) is TCustomEdit then
      begin
        pCustEdit := TCustomEdit(TWinControl(Sender));

        if pCustEdit.Focused and (pCustEdit.Sellength > 0) then
        begin
          pCustEdit.Sellength := 0;
          pCustEdit.SelStart := length(pCustEdit.Text);
          // pCustEdit.SelStart:=pCustEdit.CaretPos.x;
          Exit;
        end;

      end;

      if CanFocus then
        SetFocus;
    end;
end;

constructor TframeDeclForms.Create(frameOwner: TComponent);
var
  i: integer;
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);


  pgridDeclForms.DoubleBuffered := True;
  // kirjutame reanumbrid ära
  for i := 1 to pgridDeclForms.RowCount - 1 do
    pgridDeclForms.Cells[0, i] := IntToStr(i);

  FDeletedItems := TObjectList.Create(True);
  TButtonCellEditor(pgridDeclForms.EditorByStyle(cbsEllipsis)).Height := 20;
  TButtonCellEditor(pgridDeclForms.EditorByStyle(cbsEllipsis)).OnClick := @self.doOnclickFix;

  TStringCellEditor(pgridDeclForms.EditorByStyle(cbsAuto)).OnChange := @self.pgridDeclFormsEditingDone; // meil vaja ju kohe muutus avastada !!!!
  TStringCellEditor(pgridDeclForms.EditorByStyle(cbsAuto)).OnKeyDown := @self.onEditorKeyDown;

  TStringCellEditor(pgridDeclForms.EditorByStyle(cbsAuto)).OnClick := @self.doOnclickFix;
  TStringCellEditor(pgridDeclForms.EditorByStyle(cbsAuto)).OnExit := @self.doOnCellEditorExit;



  // ---
  self.FformDefaultSubType := estbk_types.CFormTypeAsVatDecl;
end;

destructor TframeDeclForms.Destroy;
begin

  self.doCleanup;

  FreeAndNil(FDeletedItems);
  inherited Destroy;
end;


procedure TframeDeclForms.pgridDeclFormsEditingDone(Sender: TObject);
var
  pDescrObj: TIntIDAndCTypes;
  pEnable: boolean;
  pHash, i: integer;

begin
  if self.FDeclFrameMode = __declDisplayFormContent then
  begin
    // if ((Sender is TStringCellEditor) and (TStringCellEditor(Sender).Focused)) or pgridDeclForms.Focused then
    //  begin
    pEnable := True;
    pDescrObj := pgridDeclForms.Objects[CCol_description, pgridDeclForms.Row] as TIntIDAndCTypes;
    if assigned(pDescrObj) then
    begin
      pHash := estbk_utilities.hashpjw(pgridDeclForms.Cells[CCol_uniqId, pgridDeclForms.Row] +
        pgridDeclForms.Cells[CCol_description, pgridDeclForms.Row] + pgridDeclForms.Cells[CCol_logrownr, pgridDeclForms.Row] +
        pgridDeclForms.Cells[CCol_formula, pgridDeclForms.Row]);

      pEnable := (pDescrObj.flags = 0) or (pDescrObj.flags <> pHash);
    end
    else
      pEnable := True;




    // ---
    btnSave.Enabled := btnSave.Enabled or pEnable;
    btnCancel.Enabled := btnCancel.Enabled or pEnable;
  end;
  //  end;
end;

procedure TframeDeclForms.pgridDeclFormsExit(Sender: TObject);
begin
  self.EditingDone;
end;


function TframeDeclForms.getRowMode(const prowNr: integer): TDeclRowRez;
begin
  Result := __declrmNullLine;

  with pgridDeclForms do
    if pRowNr < Rowcount then
    begin
      if prowNr > 0 then
        if assigned(Objects[CCol_description, prowNr - 1]) and not assigned(Objects[CCol_description, prowNr]) then
          Result := __declrmInsertAllowed
        else
        if assigned(Objects[CCol_description, prowNr]) then
          Result := __declrmDeleteAllowed;
    end;
end;

// 28.03.2011 Ingmar
procedure TframeDeclForms.checkForRowSwitch;
var
  pSameId, i: integer; // rea nr, kus leiti sama tunnusega kirje
  pCurrUniqId: AStr;
begin
  if pgridDeclForms.Col = CCol_uniqId then
  begin
    pCurrUniqId := trim(pgridDeclForms.Cells[CCol_uniqId, pgridDeclForms.Row]);
    if (pCurrUniqId <> '') and (trim(self.FOrigColUniqId) <> '') then
    begin
      pSameId := -1;
      for i := 1 to pgridDeclForms.RowCount - 1 do
        if i <> pgridDeclForms.Row then
        begin
          // -- leiti sama tunnusega lahter
          if pgridDeclForms.Cells[CCol_uniqId, i] = pCurrUniqId then
          begin
            pSameId := i; // leidsime kirje millele viidati
            break;
          end;


          // reaalse andmeosa lõpp
          if not assigned(pgridDeclForms.Objects[CCol_description, pgridDeclForms.Row]) then
            break;
        end;

      // viide leitud
      if pSameId > 0 then
      begin
        pgridDeclForms.Cells[CCol_uniqId, i] := self.FOrigColUniqId;
        self.switchRows(pgridDeclForms.Row, pSameId);
      end;
      // switchRows(const pSourceRowNr : Integer; const pDestRowNr : Integer);

      // ---
    end;
  end; // --
end;

procedure TframeDeclForms.pgridDeclFormsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  pRez: TDeclRowRez;
begin

  // lubame neid võtmeid ps in list ei toeta wordi !
  if (key = VK_LEFT) or (key = VK_RIGHT) or (key = VK_DOWN) or (key = VK_NEXT) or (key = VK_UP) or (key = VK_PRIOR) or
    (key = VK_TAB) or (key = VK_BACK) then
    exit;



  if (FDeclFrameMode = __declDisplayFormContent) then
  begin
    //pRez:=getRowMode(TStringGrid(Sender).Row);
    pRez := getRowMode(self.FLastActiveRow);

    if (key = VK_RETURN) then
    begin

      if pRez in [__declrmDeleteAllowed] then //  __declrmDeleteAllowed järelikult reaalne rida !
      begin

        case TStringGrid(Sender).Col of
          CCol_uniqId: self.checkForRowSwitch();
          CCol_formula: if Shift = [ssCtrl] then
              self.pgridDeclFormsEditButtonClick(Sender);
        end;


        // ---
        self.pgridDeclFormsEditingDone(pgridDeclForms);
      end;

      if TStringGrid(Sender).Col < TStringGrid(Sender).ColCount then
        TStringGrid(Sender).Col := TStringGrid(Sender).Col + 1;
      key := 0;
    end
    else
    if (pRez in [__declrmInsertAllowed, __declrmDeleteAllowed]) and (TStringGrid(Sender).Col = CCol_action) and (key = VK_SPACE) then
    begin
      self.pgridDeclFormsDblClick(Sender);
      key := 0;
    end
    else
    if (pRez in [__declrmDeleteAllowed]) and (Shift = [ssCtrl]) and (key = VK_DELETE) then
    begin
      self.deleteLine(self.FLastActiveRow);
      key := 0;
    end
    else
    if (pRez in [__declrmInsertAllowed]) and (Shift = [ssCtrl]) and (key = Ord('+')) then
    begin
      self.insertNewLine(self.FLastActiveRow);
      key := 0;
    end
    else
    if (pRez = __declrmNullLine) or (TStringGrid(Sender).Col = CCol_action) then
    begin
      key := 0;
    end;
    // ---
  end
  else
  begin
    // siis kui on ainult vormid !!!
    if key = VK_RETURN then
    begin
      self.pgridDeclFormsDblClick(Sender);
      key := 0;
    end;
  end; // ---
end;


procedure TframeDeclForms.pgridDeclFormsPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
var
  pRez: TDeclRowRez;
begin
  if (FDeclFrameMode = __declDisplayFormContent) then
    with TStringGrid(Sender) do
      if (aCol >= 0) and (aRow > 0) then
      begin

        pRez := getRowMode(aRow);
        if (aCol = CCol_action) then // alati valge tagataust !
          canvas.brush.Color := clWindow
        else
        if (pRez in [__declrmNullLine, __declrmInsertAllowed]) then
          canvas.brush.Color := MyFavGray;
      end;
end;

procedure TframeDeclForms.pgridDeclFormsResize(Sender: TObject);
begin
  // ---
end;

procedure TframeDeclForms.pgridDeclFormsSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);

var
  pRez: TDeclRowRez;
  pReadOnly: boolean;

begin
  self.FLastActiveRow := 0;


  // ---
  //if self.FDeclFrameMode=__declDisplayForms then
  //   CanSelect:=assigned(TStringGrid(Sender).Objects[CCol_description,aRow]);


  if CanSelect then
    self.FLastActiveRow := aRow;

  if self.FDeclFrameMode = __declDisplayFormContent then
  begin
    pRez := self.getRowMode(aRow);
    pReadOnly := (pRez in [__declrmNullLine, __declrmInsertAllowed]) and (aRow <> CCol_action);
    pgridDeclForms.Columns.Items[CCol_description - 1].ReadOnly := pReadOnly;
    pgridDeclForms.Columns.Items[CCol_logrownr - 1].ReadOnly := pReadOnly;
    pgridDeclForms.Columns.Items[CCol_formula - 1].ReadOnly := pReadOnly;


    mnuItemUp.Enabled := (aRow > 1) and (pRez in [__declrmDeleteAllowed]);
    mnuItemDown.Enabled := self.getRowMode(aRow + 1) in [__declrmDeleteAllowed];
    mnu2Spaces.Enabled := mnuItemUp.Enabled or mnuItemDown.Enabled;


    mnuItemNewLine.Enabled := assigned(pgridDeclForms.Objects[CCol_description, aRow]);
  end;
end;



procedure TframeDeclForms.pgridDeclFormsSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
var
  pRez: TDeclRowRez;
  pReadOnly: boolean;
begin
  if (FDeclFrameMode = __declDisplayFormContent) then
  begin

    if pgridDeclForms.CanFocus then
      pgridDeclForms.Focused;

    pRez := self.getRowMode(aRow);
    pReadOnly := (pRez in [__declrmNullLine, __declrmInsertAllowed]);

    if assigned(Editor) then
      if (pRez in [__declrmNullLine, __declrmInsertAllowed]) then
        Editor := nil //Editor.Color:=MyFavGray
      else
        Editor.Color := clWindow;

    if assigned(Editor) and (aCol = CCol_uniqId) then
      self.FOrigColUniqId := pgridDeclForms.Cells[aCol, aRow]
    else
      self.FOrigColUniqId := '';
    // if assigned(Editor) then
    //     Editor.Visible:=true;
  end;
end;



procedure TframeDeclForms.pgridDeclFormsShowHint(Sender: TObject; HintInfo: PHintInfo);
begin
  // ---
end;

procedure TframeDeclForms.pnewFormClick(Sender: TObject);
var
  pFormname: AStr;
  pRowDescr: TIntIDAndCTypes;
  i: integer;
begin
  if (FDeclFrameMode = __declDisplayForms) then
  begin
    pFormname := '';
    if estbk_inputformex.inputFormEx(estbk_strmsg.SCDeclNewVatForm, pFormname) then
      with qryWorker, SQL do
        try
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLInsertNewFormdEntry);
          // ---
          paramByname('id').AsInteger := qryFormdSeq.GetNextValue;
          paramByname('form_name').AsString := pFormname;
          paramByname('form_type').AsString := estbk_types.CFormTypeAsVatDecl;

          paramByname('descr').AsString := '';
          paramByname('url').AsString := '';
          paramByname('valid_from').AsDateTime := now;
          paramByname('valid_until').Value := null;
          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          paramByname('rec_changed').AsDateTime := now;
          paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          ;
          paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;


          // leiame tühja rea...
          for i := 1 to pgridDeclForms.RowCount - 1 do
            if not assigned(pgridDeclForms.Objects[CCol_description, i]) then
            begin
              pgridDeclForms.Cells[CCol_description, i] := pFormname;

              prowDescr := TIntIDAndCTypes.Create;
              prowDescr.id := paramByname('id').AsInteger;
              pgridDeclForms.Objects[CCol_description, i] := prowDescr;
              break;
            end;


        finally
          Close;
          Clear;
        end;
  end; // --------
end;

procedure TframeDeclForms.pgridDeclFormsDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
var
  pRez: TDeclRowRez;
begin
  with TStringGrid(Sender) do
    if (FDeclFrameMode = __declDisplayFormContent) then
    begin
      if (aRow > 0) and (aCol > 0) then
      begin
        Canvas.FillRect(aRect);
        pRez := getRowMode(aRow);
        if (aCol = CCol_action) then
          canvas.brush.Color := clWindow
        else
        if (pRez in [__declrmNullLine, __declrmInsertAllowed]) then
          canvas.brush.Color := MyFavGray
        else
          canvas.brush.Color := clWindow;

        if assigned(dmodule.sharedImages) and (dmodule.sharedImages.Count > 0) and (aCol = CCol_action) then
          case pRez of
            __declrmInsertAllowed: dmodule.sharedImages.Draw(TStringGrid(Sender).Canvas, aRect.Left + 2, aRect.Top + 2, img_indxAddItem);
            __declrmDeleteAllowed: dmodule.sharedImages.Draw(TStringGrid(Sender).Canvas, aRect.Left + 2, aRect.Top + 2, img_indxExtDel);
            __declrmNullLine: Canvas.TextOut(aRect.Left + 4, aRect.Top + 3, ' '); // tühjus
          end
        else
          Canvas.TextOut(aRect.Left + 4, aRect.Top + 3, Cells[aCol, aRow]);

      end
      else
      begin
        defaultDrawCell(aCol, aRow, aRect, aState);
      end;

      // lazarusel on mõõtudega probleeme
      TButtonCellEditor(pgridDeclForms.EditorByStyle(cbsEllipsis)).Height := 20;
    end
    else
      defaultDrawCell(aCol, aRow, aRect, aState);
end;

procedure TframeDeclForms.pgridDeclFormsEditButtonClick(Sender: TObject);
var
  pFrmFormulaCreator: TformXFrames;
begin
  if (FDeclFrameMode = __declDisplayFormContent) then
    try

      pFrmFormulaCreator := TformXFrames.Create(nil, False);
      pFrmFormulaCreator.initForm(estbk_types.__csmRPFormulaCreatorWnd, 800, 700);
      pFrmFormulaCreator.Caption := estbk_strmsg.SCDeclFormuleCrFormname;

      pFrmFormulaCreator.strRez := pgridDeclForms.Cells[CCol_formula, pgridDeclForms.Row];
      pFrmFormulaCreator.autoLoadData := True;
      pFrmFormulaCreator.showmodal();



      if trim(pFrmFormulaCreator.strRez) <> '' then
      begin
        pgridDeclForms.Cells[CCol_formula, pgridDeclForms.Row] := pFrmFormulaCreator.strRez;
        self.pgridDeclFormsEditingDone(Sender);
      end;

      // ---
    finally
      FreeAndNil(pFrmFormulaCreator);
    end;
end;

{
function IsCellSelected(StringGrid: TStringGrid; X, Y: Longint): Boolean;
begin
  Result := False;
  try
    if (X >= StringGrid.Selection.Left) and (X <= StringGrid.Selection.Right) and
      (Y >= StringGrid.Selection.Top) and (Y <= StringGrid.Selection.Bottom) then
      Result := True;
  except
  end;
end;
}

procedure TframeDeclForms.insertNewLine(const pRow: integer);
var
  prowDescr: TIntIDAndCTypes;
  pUsedMarkers: TAStrList;
  i: integer;
begin
  if self.declFrameMode = __declDisplayFormContent then
  begin
    if pRow < pgridDeclForms.RowCount - 1 then
      try
        pUsedMarkers := TAStrList.Create;
        btnSave.Enabled := True;
        btnCancel.Enabled := True;
        // ---
        prowDescr := TIntIDAndCTypes.Create;
        prowDescr.id := 0;
        pgridDeclForms.Objects[CCol_description, pRow] := prowDescr;



        pgridDeclForms.Row := pRow;
        pgridDeclForms.Col := CCol_description; // CCol_uniqId;

        for i := 1 to pgridDeclForms.RowCount - 1 do
        begin

          // rida reaalselt ka olemas...
          if assigned(pgridDeclForms.Objects[CCol_description, i]) then
          begin
            if trim(pgridDeclForms.Cells[CCol_uniqId, i]) <> '' then
              pUsedMarkers.Add(ansilowercase(pgridDeclForms.Cells[CCol_uniqId, i]));
          end
          else
            break;
        end;

        // -- loome uue unikaalse ID
        for i := 1 to 999 do
          if pUsedMarkers.IndexOf(CFormulaLineSpecialMarker + IntToStr(i)) = -1 then
          begin
            pgridDeclForms.Cells[CCol_uniqId, pRow] := CFormulaLineSpecialMarker + IntToStr(i);
            break;
          end;


      finally
        FreeAndNil(pUsedMarkers);
      end;
  end; // ---
end;

procedure TframeDeclForms.deleteLine(const pRow: integer);
var
  i, j: integer;
begin
  with pgridDeclForms do
    if self.declFrameMode = __declDisplayFormContent then
    begin
      // muutusid andmed
      btnSave.Enabled := True;
      btnCancel.Enabled := True;

      for i := 0 to ColCount - 1 do
        if assigned(Objects[i, pRow]) then
        begin
          // cacheme objektid, mida ka reaalselt kustutame
          if Objects[i, pRow] is TIntIDAndCTypes then
          begin
            if TIntIDAndCTypes(Objects[i, pRow]).id > 0 then
              FDeletedItems.Add(TObject(Objects[i, pRow]))
            else
              Objects[i, pRow].Free;
            Objects[i, pRow] := nil;
          end
          else
          begin
            Objects[i, pRow].Free;
            Objects[i, pRow] := nil;
          end;
          // ---
        end;


      Clean(CCol_description, pRow, Colcount, pRow, [gzNormal]);
      for i := pRow to rowcount - 2 do
      begin
        for j := 0 to colcount - 1 do
        begin
          Objects[j, i] := Objects[j, i + 1];
          Cells[j, i] := Cells[j, i + 1];
        end;
      end;

      // juhul, kui kustutati esimene rida ja tal puuduvad järgmised read, peame taastama nö null rea konfi !
      if (pRow = 1) and not assigned(Objects[CCol_description, pRow + 1]) then
        Objects[CCol_description, pRow] := TIntIDAndCTypes.Create;

      // ---
      Repaint;
      if pRow > 1 then
        Row := pRow - 1;

    end;
end;


procedure TframeDeclForms.moveRow(const pCurrentRowNr: integer; const pMoveDown: boolean);
var
  pSwitchRownr, i: integer;
  pTempStr: AStr;
  pTempObj: TObject;
begin
  case pMoveDown of
    True: pSwitchRownr := pCurrentRowNr + 1;
    False: pSwitchRownr := pCurrentRowNr - 1;
  end;


  for i := 0 to pgridDeclForms.ColCount - 1 do
  begin
    pTempStr := pgridDeclForms.Cells[i, pCurrentRowNr];
    pTempObj := pgridDeclForms.Objects[i, pCurrentRowNr];

    pgridDeclForms.Cells[i, pCurrentRowNr] := pgridDeclForms.Cells[i, pSwitchRownr];
    pgridDeclForms.Objects[i, pCurrentRowNr] := pgridDeclForms.Objects[i, pSwitchRownr];

    pgridDeclForms.Cells[i, pSwitchRownr] := pTempStr;
    pgridDeclForms.Objects[i, pSwitchRownr] := pTempObj;
  end;

  // ---
  pgridDeclForms.Repaint;

  btnCancel.Enabled := False;
  btnSave.Enabled := True;
end;


// 28.03.2011 Ingmar
procedure TframeDeclForms.switchRows(const pSourceRowNr: integer; const pDestRowNr: integer);
var
  i: integer;
  pStr: Astr;
  pObj: TObject;
begin
  try
    pgridDeclForms.BeginUpdate;
    if (pSourceRowNr > 0) and (pSourceRowNr < pgridDeclForms.RowCount) and (pDestRowNr > 0) and (pDestRowNr < pgridDeclForms.RowCount) then
    begin
      for i := 0 to pgridDeclForms.ColCount - 1 do
      begin
        pStr := pgridDeclForms.Cells[i, pSourceRowNr];
        pObj := pgridDeclForms.Objects[i, pSourceRowNr];

        pgridDeclForms.Cells[i, pSourceRowNr] := pgridDeclForms.Cells[i, pDestRowNr];
        pgridDeclForms.Objects[i, pSourceRowNr] := pgridDeclForms.Objects[i, pDestRowNr];

        pgridDeclForms.Cells[i, pDestRowNr] := pStr;
        pgridDeclForms.Objects[i, pSourceRowNr] := pObj;
      end;
    end;

  finally
    pgridDeclForms.EndUpdate(True);
  end;

  // ---
  // pgridDeclForms.Repaint;
  btnCancel.Enabled := False;
  btnSave.Enabled := True;

end;

procedure TframeDeclForms.pgridDeclFormsDblClick(Sender: TObject);
var
  pRez: TDeclRowRez;
begin
  // if pgridDeclForms.Selection
  if self.FLastActiveRow > 0 then
    case self.declFrameMode of
      __declDisplayForms: if assigned(self.onFrameDataEvent) and assigned(pgridDeclForms.Objects[CCol_description, self.FLastActiveRow]) then
        begin
          self.onFrameDataEvent(self,
            __frameOpenDeclDetails,
            TIntIDAndCTypes(pgridDeclForms.Objects[CCol_description, self.FLastActiveRow]).id,
            nil);

        end;

      __declDisplayFormContent: if TStringGrid(Sender).Col = CCol_action then
        begin
          pRez := getRowMode(FLastActiveRow);
          case pRez of
            __declrmInsertAllowed: self.insertNewLine(self.FLastActiveRow);
            __declrmDeleteAllowed: self.deleteLine(self.FLastActiveRow);
          end;
        end;
    end;
end;

procedure TframeDeclForms.FrameResize(Sender: TObject);
begin
  // ---
end;

procedure TframeDeclForms.mnuPasteClick(Sender: TObject);
begin
  if (pgridDeclForms.Row > 0) and (pgridDeclForms.Col < pgridDeclForms.ColCount - 1) and
    assigned(pgridDeclForms.Objects[CCol_description, pgridDeclForms.Row]) then
    pgridDeclForms.Cells[pgridDeclForms.Col, pgridDeclForms.Row] := Clipboard.AsText;
end;

procedure TframeDeclForms.mnu2SpacesClick(Sender: TObject);
const
  CSpaceCnt = 3;
begin
  pgridDeclForms.Cells[CCol_description, pgridDeclForms.Row] :=
    stringofchar(#32, CSpaceCnt) + pgridDeclForms.Cells[CCol_description, pgridDeclForms.Row];
end;

procedure TframeDeclForms.mnuCopyCellClick(Sender: TObject);
begin
  if (pgridDeclForms.Row > 0) and (pgridDeclForms.Col < pgridDeclForms.ColCount - 1) then
    Clipboard.AsText := pgridDeclForms.Cells[pgridDeclForms.Col, pgridDeclForms.Row];
end;

procedure TframeDeclForms.mnuItemDownClick(Sender: TObject);
begin
  // ---
  self.moveRow(pgridDeclForms.Row, True);
end;

procedure TframeDeclForms.mnuItemExportClick(Sender: TObject);
const
  CExportVer = '1.5';
var
  pXmlDoc: TXMLDocument;
  pRootNode, pParentNode, pItem, pItemData: TDOMNode;
  pTextData: TDomCDatasection;
  i: integer;
begin
  // --

  try

    pXmlDoc := TXMLDocument.Create;

    // pXmlDoc.XMLEncoding := 'utf-8';
    // pXmlDoc.ParentNode.AppendChild(pXmlDoc.CreateProcessingInstruction('encoding','utf-8'));
    // document.createProcessingInstruction('xml','version="1.0" encoding="UTF-8"');
    // pXmlDoc.AppendChild(pXmlDoc.CreateProcessingInstruction('encoding','utf-8'));

    pRootNode := pXmlDoc.CreateElement('formd'); // juurikas paika !
    pXmlDoc.Appendchild(pRootNode);
    TDOMElement(pRootNode).SetAttribute('version', CExportVer);
    TDOMElement(pRootNode).SetAttribute('type', self.FformDefaultSubType);

    pParentNode := pXmlDoc.CreateElement('items');
    pRootNode.AppendChild(pParentNode);

    for  i := 1 to pgridDeclForms.RowCount - 1 do
      if assigned(pgridDeclForms.Objects[CCol_description, i]) then
      begin

        pItem := pXmlDoc.CreateElement('item');
        pParentNode.AppendChild(pItem);

        // @1 ---------------
        pItemData := pXmlDoc.CreateElement('uniqidf');
        pItem.AppendChild(pItemData);

        pTextData := pXmlDoc.CreateCDATASection(utf8decode(pgridDeclForms.Cells[CCol_uniqId, i]));
        pItemData.AppendChild(pTextData);

        // @2 ---------------
        pItemData := pXmlDoc.CreateElement('descr');
        pItem.AppendChild(pItemData);

        pTextData := pXmlDoc.CreateCDATASection(utf8decode(pgridDeclForms.Cells[CCol_description, i]));
        pItemData.AppendChild(pTextData);

        // @3 ---------------
        pItemData := pXmlDoc.CreateElement('logrownr');
        pItem.AppendChild(pItemData);

        pTextData := pXmlDoc.CreateCDATASection(utf8decode(pgridDeclForms.Cells[CCol_logrownr, i]));
        pItemData.AppendChild(pTextData);

        // @4 ---------------
        pItemData := pXmlDoc.CreateElement('formula');
        pItem.AppendChild(pItemData);

        pTextData := pXmlDoc.CreateCDATASection(utf8decode(pgridDeclForms.Cells[CCol_formula, i]));
        pItemData.AppendChild(pTextData);
        // pTextData := pXmlDoc.CreateTextNode('');
      end;


    // --------------------------------------------------------------------
    pSaveXmlAs.FileName := format(estbk_strmsg.SCDeclFormSVName, [self.FformDefaultSubType]) + '.xml';
    if pSaveXmlAs.Execute then
      writeXMLFile(pXmlDoc, pSaveXmlAs.Files.Strings[0]);
    // --------------------------------------------------------------------

  finally
    pXmlDoc.Free;
  end;
end;

procedure TframeDeclForms.mnuItemImportClick(Sender: TObject);
var
  pXmlDoc: TXMLDocument;
  pRootNode, pParentNode, pItem: TDOMNode;
  i, pOkTagCnt: integer;
  // ---
  pDescr: AStr;
  pUniqIdf: AStr;
  pLogNr: AStr;
  pFormula: AStr;
  pCleanupDone: boolean;
  prowDescr: TIntIDAndCTypes;
  pCurrRownr: integer;
begin
  // --
  self.FLinesImportedFromFile := False;

  try
    pgridDeclForms.BeginUpdate;
    pXmlDoc := nil;
    pCurrRownr := 1;
    pOpenXmlAs.FileName := format(estbk_strmsg.SCDeclFormSVName, [self.FformDefaultSubType]) + '.xml';
    if pOpenXmlAs.Execute then
    begin
      ReadXMLFile(pXmlDoc, pOpenXmlAs.Files.Strings[0]);
      pRootNode := pXmlDoc.FirstChild;
      if assigned(pRootNode) and (ansilowercase(pRootNode.NodeName) = 'formd') then
      begin

        if not assigned(pRootNode.Attributes) or not assigned(pRootNode.Attributes.GetNamedItem('type')) or
          (pRootNode.Attributes.GetNamedItem('type').TextContent <> self.FformDefaultSubType) then
        begin
          Dialogs.MessageDlg(estbk_strmsg.SEDeclWrongImportFormType, mtError, [mbOK], 0);
          Exit; // -->
        end;




        pParentNode := pRootNode.FirstChild;

        if assigned(pParentNode) and (ansilowercase(pParentNode.NodeName) = 'items') then
          for i := 0 to pParentNode.ChildNodes.Count - 1 do
          begin
            pItem := pParentNode.ChildNodes.Item[i];
            if assigned(pItem) and (ansilowercase(pItem.NodeName) = 'item') then
            begin // 1.
              pDescr := '';
              pUniqIdf := '';
              pLogNr := '';
              pFormula := '';
              pOkTagCnt := 0;
              // --
              pItem := pitem.FirstChild;
              while assigned(pItem) do
              begin

                if ansilowercase(pItem.NodeName) = 'uniqidf' then
                begin
                  pUniqIdf := Copy(utf8encode(pItem.TextContent), 1, 8);
                  Inc(pOkTagCnt);
                end
                else
                if ansilowercase(pItem.NodeName) = 'descr' then
                begin
                  pDescr := Copy(utf8encode(pItem.TextContent), 1, 255);
                  Inc(pOkTagCnt);
                end
                else
                if ansilowercase(pItem.NodeName) = 'logrownr' then
                begin
                  pLogNr := Copy(utf8encode(pItem.TextContent), 1, 20);
                  Inc(pOkTagCnt);
                end
                else
                if ansilowercase(pItem.NodeName) = 'formula' then
                begin
                  pFormula := Copy(utf8encode(pItem.TextContent), 1, 512);
                  Inc(pOkTagCnt);
                end;

                // --
                pItem := pitem.NextSibling;
              end;


              // -- kustutame kõik hetkeread ära !
              if (pOkTagCnt > 0) then
              begin

                if not pCleanupDone then
                begin
                  self.doCleanup();

                  pCleanupDone := True;
                end;


                self.FLinesImportedFromFile := True;
                // lipp püsti, et kõik hetkeread tulid failid ! st varasemad tuleb baasis "tühistada"
                prowDescr := TIntIDAndCTypes.Create;
                pgridDeclForms.Objects[CCol_description, pCurrRownr] := prowDescr;
                pgridDeclForms.Cells[CCol_uniqId, pCurrRownr] := pUniqIdf;
                pgridDeclForms.Cells[CCol_description, pCurrRownr] := pDescr;
                pgridDeclForms.Cells[CCol_logrownr, pCurrRownr] := pLogNr;
                pgridDeclForms.Cells[CCol_formula, pCurrRownr] := pFormula;
                // ---
                Inc(pCurrRownr);


                btnSave.Enabled := True;
                btnCancel.Enabled := True;
              end;

              // ---
            end;  // 1.
          end;
        // ---
      end;
      // ---
    end;



  finally
    pgridDeclForms.EndUpdate;
    pgridDeclForms.Invalidate;

    if assigned(pXmlDoc) then
      pXmlDoc.Free;
  end;
end;


function TframeDeclForms.findUniqRowId: AStr;
var
  pRowIds: TAStrList;
  i: integer;
begin
  Result := '';
  try
    pRowIds := TAStrlist.Create;
    // --
    for  i := 1 to pgridDeclForms.RowCount - 1 do
      if trim(pgridDeclForms.Cells[CCol_uniqId, i]) <> '' then
        pRowIds.add(trim(pgridDeclForms.Cells[CCol_uniqId, i]));


    i := 1;
    while (i < 32000) do
    begin
      Result := estbk_types.CFormulaLineSpecialMarker + IntToStr(i);
      if pRowIds.IndexOf(Result) = -1 then
        break;

      Inc(i);
    end;

  finally
    pRowIds.Free;
  end;
end;

procedure TframeDeclForms.mnuItemNewLineClick(Sender: TObject);
var
  pCurrentRow: integer;
  pRowDescr: TIntIDAndCTypes;
  pNextUniqRowId: AStr;

begin
  // kui ei ole tühi tuleb alumisi elemente liigutada allapoole ning tekitada vahele
  pCurrentRow := pgridDeclForms.Row;
  if assigned(pgridDeclForms.Objects[CCol_description, pCurrentRow + 1]) then
    pgridDeclForms.InsertColRow(False, pCurrentRow + 1);

  pRowDescr := TIntIDAndCTypes.Create;
  pRowDescr.id := 0;

  pNextUniqRowId := self.findUniqRowId;
  pgridDeclForms.Objects[CCol_description, pCurrentRow + 1] := pRowDescr;
  pgridDeclForms.Cells[CCol_description, pCurrentRow + 1] := ' ';
  pgridDeclForms.Cells[CCol_uniqId, pCurrentRow + 1] := pNextUniqRowId;
  pgridDeclForms.Row := pCurrentRow + 1;
  pgridDeclForms.Col := CCol_description;

  pgridDeclForms.Repaint;
end;

procedure TframeDeclForms.mnuItemUpClick(Sender: TObject);
begin
  moveRow(pgridDeclForms.Row, False);
end;

procedure TframeDeclForms.pgridDeclFormsClick(Sender: TObject);
begin
  if Assigned(pgridDeclForms.Editor) then
    if not pgridDeclForms.Editor.Visible then
    begin
      if pgridDeclForms.CanFocus then
        pgridDeclForms.SetFocus;
    end
    else
    begin
      if pgridDeclForms.Editor.CanFocus then
        pgridDeclForms.Editor.SetFocus;
    end;
end;



procedure TframeDeclForms.btnCancelClick(Sender: TObject);
begin
  self.FLinesImportedFromFile := False;

  qryTaxFormsSel.active := False;
  qryTaxFormsSel.active := True;
  self.loadGridLines;

  btnSave.Enabled := False;
  btnCancel.Enabled := False;

  if pgridDeclForms.CanFocus then
    pgridDeclForms.SetFocus;
end;

procedure TframeDeclForms.btnCloseClick(Sender: TObject);
begin
  if assigned(self.FframeKillSignal) then
    self.FframeKillSignal(self);
end;



function TframeDeclForms.verifyGridLines(const pCollection: TCollection): boolean;
const
  pAccAttrib: array[0..3] of AStr = (
    CFCreator_DC_FlagAsStr,
    CFCreator_CC_FlagAsStr,
    CFCreator_SA_FlagAsStr,
    CFCreator_TR_FlagAsStr
    );
  //CFCreator_DS_FlagAsStr,
  //CFCreator_CS_FlagAsStr);
var
  pOkLine: TDeclVerifiedLines;
  pParseFrm: TFormulaPreParser; // suudab tagidest andmed välja lugeda
  pRevPolish: TRevPolish;
  pFormula: AStr;
  pUniqcode: AStr;
  pNormalizeFrm: AStr; // asendab tagid reaalsete numbritega !
  // TIntIDAndCTypes
  i, j, k: integer;
  pRefCount: integer;
  bOk: boolean;
  pLines: integer;
begin

  // -- dekl. ridade valideerimine
  if self.FDeclFrameMode = __declDisplayFormContent then
    try
      Result := False;
      pLines := 0;

      pParseFrm := TFormulaPreParser.Create(False);
      pRevPolish := TRevPolish.Create;




      for i := 1 to pgridDeclForms.RowCount - 1 do
        if assigned(pgridDeclForms.Objects[CCol_description, i]) then
        begin // BEGIN
          // CCol_logrownr loogiline numeratsioon pole kohustuslik
          pFormula := trim(pgridDeclForms.Cells[CCol_formula, i]);

          // reakood peab olema unikaalne ja $1,$2,$3,$4
          // kontrollme, kas kood juba kusagil mujal kasutusel !
          for k := 0 to pgridDeclForms.RowCount - 1 do
            if assigned(pgridDeclForms.Objects[CCol_description, i]) and (k <> i) then
              if trim(ansilowercase(pgridDeclForms.Cells[CCol_uniqId, k])) = trim(ansilowercase(pgridDeclForms.Cells[CCol_uniqId, i])) then
              begin
                Dialogs.MessageDlg(estbk_strmsg.SEDeclCodeAlreadyDef, mtError, [mbOK], 0);
                if pgridDeclForms.CanFocus then
                  pgridDeclForms.SetFocus;
                Exit;
              end;



          // kas rida sisaldab üldse mingit valemit ! järsku vaid vaherida aruande jaoks !
          if (pFormula <> '') then
          begin // formula IF


            if not pParseFrm.parseFormula(pFormula) then
            begin
              Dialogs.MessageDlg(estbk_strmsg.SEDeclIncorrectFormula + ' ' + pParseFrm.errorCode, mtError, [mbOK], 0);
              pgridDeclForms.Row := i;
              if pgridDeclForms.CanFocus then
                pgridDeclForms.SetFocus;
              Exit;
            end;



            // REKURSIOON
            // strtointdef(stringreplace(pParseFrm.RLines.Strings[j],'R','',[rfIgnoreCase]),-1);
            pUniqcode := trim(ansilowercase(pgridDeclForms.Cells[CCol_uniqId, i]));
            if ((pUniqcode <> '') and (pUniqcode[1] = CFormulaLineSpecialMarker)) and
              (pos(pUniqcode, ansilowercase(pgridDeclForms.Cells[CCol_formula, i])) > 0) then
            begin
              Dialogs.MessageDlg(estbk_strmsg.SEDeclRefToSelf, mtError, [mbOK], 0);
              pgridDeclForms.Row := i;
              if pgridDeclForms.CanFocus then
                pgridDeclForms.SetFocus;
              Exit;
            end; // else



            // KATKENUD LINK; RLines tuleb valemist, kus käiakse läbi kõik koodid
            pRefCount := 0;
            for j := 0 to pParseFrm.RLines.Count - 1 do
            begin
              for k := 1 to pgridDeclForms.RowCount - 1 do
              begin
                if assigned(pgridDeclForms.Objects[CCol_description, k]) then
                begin
                  pUniqcode := trim(ansilowercase(pgridDeclForms.Cells[CCol_uniqId, k]));
                  if (pParseFrm.RLines.Strings[j] <> '') and (pUniqcode = trim(ansilowercase(pParseFrm.RLines.Strings[j]))) then
                    Inc(pRefCount);
                end
                else
                  break;
              end;
            end;


            if pRefCount <> pParseFrm.RLines.Count then
            begin
              Dialogs.MessageDlg(estbk_strmsg.SEDeclBrokenRef, mtError, [mbOK], 0);
              if pgridDeclForms.CanFocus then
                pgridDeclForms.SetFocus;
              Exit;
            end;


            // RISTLINKIMINE
            for j := 0 to pParseFrm.RLines.Count - 1 do
            begin

              for k := 1 to pgridDeclForms.RowCount - 1 do
                if (k <> i) then
                begin
                  if assigned(pgridDeclForms.Objects[CCol_description, k]) then
                  begin
                    pFormula := trim(ansilowercase(pgridDeclForms.Cells[CCol_formula, k]));
                    pUniqcode := trim(ansilowercase(pgridDeclForms.Cells[CCol_uniqId, k])); // meie rida

                    if (pUniqcode = '') or (pUniqcode[1] <> CFormulaLineSpecialMarker) then
                      continue;

                    if (pUniqcode = trim(ansilowercase(pParseFrm.RLines.Strings[j]))) then
                    begin
                      pUniqcode := trim(ansilowercase(pgridDeclForms.Cells[CCol_uniqId, i]));
                      if (pUniqcode = '') or (pUniqcode[1] <> CFormulaLineSpecialMarker) then
                        continue;

                      if pos(pUniqcode, pFormula) > 0 then // antud rida viitab meie peale tagasi !
                      begin
                        Dialogs.MessageDlg(estbk_strmsg.SEDeclCrossLinkedLines, mtError, [mbOK], 0);
                        pgridDeclForms.Row := k;
                        if pgridDeclForms.CanFocus then
                          pgridDeclForms.SetFocus;
                        Exit;
                      end;
                    end;
                  end
                  else
                    break;
                end;

            end; // formula IF
          end; // --- END




          // kontrollime üle, kas kontoga kaasas korrektsed atribuudid
          for k := 0 to pParseFrm.accounts.Count - 1 do
            with TTaxdParsedAccounts(pParseFrm.accounts.Items[k]) do
            begin
              bOk := False;
              // --
              for j := low(pAccAttrib) to high(pAccAttrib) do
              begin
                bOk := AnsiUpperCase(pAccAttrib[j]) = AnsiUpperCase(FAccountAttr);
                if bOk then
                  break;
              end;


              if not bOk then
              begin
                Dialogs.MessageDlg(estbk_strmsg.SEDeclUnknownAccAttrib + ' ' + FAccountCode + '@' + FAccountAttr, mtError, [mbOK], 0);
                pgridDeclForms.Row := i;
                if pgridDeclForms.CanFocus then
                  pgridDeclForms.SetFocus;
                Exit;
              end;
       {
          // okei...põnev oli, kas sellise koodiga konto ka reaalselt olemas
          bOk:=qryTaxFormsSel.Locate('account_coding',FAccountCode,[]);
      if  not bOk then
        begin
          dialogs.MessageDlg(estbk_strmsg.SEDeclUnknownAccount+' '+FAccountCode,mtError,[mbOk],0);
          pgridDeclForms.Row:=i;
          exit;
        end;
        }

              // --
            end;




          // --- see asendab nö tagid vabalt valitud numbritega, tulevikus peaks ikka kontrollima, et 0 jagamist ei tule
          // --- aga esmalt meil vaja valideerida valem ära !
          if trim(pParseFrm.formula) <> '' then
            try
              pNormalizeFrm := pParseFrm.stripFormulaRez;

              // antud klass tõstatab vea !
              if not pRevPolish.parseEquation(__removeFormulaDirectives(pNormalizeFrm)) then
                abort;

            except
              on e: Exception do
              begin

                if not (e is eabort) then
                  Dialogs.MessageDlg(estbk_strmsg.SEDeclIncorrectFormula + ' ' + e.Message, mtError, [mbOK], 0)
                else
                  Dialogs.MessageDlg(estbk_strmsg.SEDeclIncorrectFormula + ' ' + e.Message, mtError, [mbOK], 0);
                pgridDeclForms.Row := i;
                exit;
              end;
            end;




          // nii ja viimane mängime valemi reaalselt läbi
          pOkLine := pCollection.Add as TDeclVerifiedLines;
          pOkLine.FLineId := TIntIDAndCTypes(pgridDeclForms.Objects[CCol_description, i]).id;
          pOkLine.FLineBaseRecordId := TIntIDAndCTypes(pgridDeclForms.Objects[CCol_description, i]).id2;
          pOkLine.FLineHash := TIntIDAndCTypes(pgridDeclForms.Objects[CCol_description, i]).flags; // lihtklassis oli flags all hash !!!

          pOkLine.FGridLineNr := i;
          pOkLine.FGridLineOrigNr := TIntIDAndCTypes(pgridDeclForms.Objects[CCol_description, i]).misc;

          pOkLine.FGridLineUniqId := trim(pgridDeclForms.Cells[CCol_uniqId, i]);
          pOkLine.FDescr := pgridDeclForms.Cells[CCol_description, i];
          // trim(pgridDeclForms.Cells[CCol_description,i]); 17.04.2011 ingmar; trim mitte teha, sest kui vormis üritatu tühikuid kasutada, siis kustutati need eest ära
          // ntx km vormil käibemaksu rida natuke paremale saada

          pOkLine.FLogLineNr := trim(pgridDeclForms.Cells[CCol_logrownr, i]);
          pOkLine.FFormula := trim(pgridDeclForms.Cells[CCol_formula, i]);

          // ---
          Inc(pLines);
        end;

      Result := pLines > 0;
      if not Result then
        Dialogs.MessageDlg(estbk_strmsg.SEDeclIncorrectLine, mtError, [mbOK], 0);


      // ---
    finally
      FreeAndNil(pParseFrm);
      FreeAndNil(pRevPolish);

      if assigned(pgridDeclForms.Editor) and pgridDeclForms.Editor.CanFocus then
        pgridDeclForms.Editor.SetFocus;
    end;
end;

procedure TframeDeclForms.btnSaveClick(Sender: TObject);
var
  i, pNewLineId: integer;
  pRCreateLine: boolean;
  pClearDelItems: boolean;
  pLineChanged: boolean;

  pLineHash: integer;
  pCollection: TCollection;
  pVerifLine: TDeclVerifiedLines;
begin
  try


    // vormi valemi ridade täitmine !
    if self.FDeclFrameMode = __declDisplayFormContent then
      try


        pClearDelItems := False;
        pCollection := TCollection.Create(TDeclVerifiedLines);
        if verifyGridLines(pCollection) then
          try
            dmodule.primConnection.StartTransaction;
            pClearDelItems := True;


            // "kustutame"/tühistame siis reaalselt andmed
            for i := 0 to self.FDeletedItems.Count - 1 do
              if assigned(self.FDeletedItems.Items[i]) then
              begin

                qryWorker.Close;
                qryWorker.SQL.Clear;
                qryWorker.SQL.add(estbk_sqlclientcollection._SQLDeleteDFormDetailedLine);
                qryWorker.paramByname('id').AsInteger := TIntIDAndCTypes(self.FDeletedItems.Items[i]).id;
                qryWorker.paramByname('rec_changed').AsDateTime := now;
                qryWorker.paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
                qryWorker.paramByname('rec_deleted').AsString := estbk_types.SCFalseTrue[True];
                qryWorker.ExecSQL;
              end;



            // 24.04.2011 Ingmar; kõik andmed imporditi failist, kõik eelnevad vormi kirjed andmebaasis tuleb tühistada
            if self.FLinesImportedFromFile then
            begin
              qryWorker.Close;
              qryWorker.SQL.Clear;
              qryWorker.SQL.add(estbk_sqlclientcollection._SQLDeleteAllDFormLines);
              qryWorker.paramByname('formd_id').AsInteger := self.FSelectedFormId;
              qryWorker.paramByname('rec_changed').AsDateTime := now;
              qryWorker.paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
              qryWorker.paramByname('rec_deleted').AsString := estbk_types.SCFalseTrue[True];
              qryWorker.ExecSQL;
              self.FLinesImportedFromFile := False;
            end;




            // ----
            for  i := 0 to pCollection.Count - 1 do
            begin
              pLineChanged := False;
              pVerifLine := pCollection.Items[i] as TDeclVerifiedLines;


              pLineHash := estbk_utilities.hashpjw(pVerifLine.FGridLineUniqId + pVerifLine.FDescr + pVerifLine.FLogLineNr + pVerifLine.FFormula);
              pRCreateLine := (pVerifLine.FLineId > 0) and (pVerifLine.FLineHash <> pLineHash);

              // peame originaalrea tühistama !
              if pRCreateLine then
              begin
                qryWorker.Close;
                qryWorker.SQL.Clear;
                qryWorker.SQL.add(estbk_sqlclientcollection._SQLDeleteDFormDetailedLine);
                qryWorker.paramByname('id').AsInteger := pVerifLine.FLineId;
                qryWorker.paramByname('rec_changed').AsDateTime := now;
                qryWorker.paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
                qryWorker.paramByname('rec_deleted').AsString := estbk_types.SCFalseTrue[True];
                qryWorker.ExecSQL;
                pLineChanged := True;
              end;


              if (pVerifLine.FLineId <= 0) or pRCreateLine then
              begin
                // täiesti uus rida !
                // ---
                qryWorker.Close;
                qryWorker.SQL.Clear;
                qryWorker.SQL.add(estbk_sqlclientcollection._SQLInsertDFormDetailedLine);


                pNewLineId := estbk_clientdatamodule.dmodule.qrydFormLinesSeq.GetNextValue;
                qryWorker.paramByname('id').AsInteger := pNewLineId;
                qryWorker.paramByname('formd_id').AsInteger := self.FSelectedFormId;
                qryWorker.paramByname('parent_id').AsInteger := 0;

                qryWorker.paramByname('line_descr').AsString := Copy(pVerifLine.FDescr, 1, 255);
                qryWorker.paramByname('log_nr').AsString := Copy(pVerifLine.FLogLineNr, 1, 20);
                qryWorker.paramByname('formula').AsString := Copy(pVerifLine.FFormula, 1, 512);
                qryWorker.paramByname('row_nr').AsInteger := pVerifLine.FGridLineNr; // st see näitab rea järjekorra nr !
                qryWorker.paramByname('row_id').AsString := pVerifLine.FGridLineUniqId;
                // 22.02.2011 Ingmar; rea unikaalne tunnus, mida kasutatakse ka valemis




                qryWorker.paramByname('rec_changed').AsDateTime := now;
                qryWorker.paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
                qryWorker.paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;


                // 23.02.2011 Ingmar; ntx pidevalt muudetakse siis tarkvara terviklikkuse pärast on vaja aluskirje ID meelde jätta !
                if pVerifLine.FLineBaseRecordId <= 0 then
                  qryWorker.paramByname('baserecord_id').AsInteger := qryWorker.paramByname('id').AsInteger
                else
                  qryWorker.paramByname('baserecord_id').AsInteger := pVerifLine.FLineBaseRecordId;
                qryWorker.ExecSQL;



                // ---
                pLineChanged := True;
              end;



              // 12.03.2011 Ingmar; rida vahetas asukohta aruandel
              if not pLineChanged and (pVerifLine.FGridLineNr <> pVerifLine.FGridLineOrigNr) then
              begin
                qryWorker.Close;
                qryWorker.SQL.Clear;
                qryWorker.SQL.add(estbk_sqlclientcollection._SQLUpdateDFormDetailedLineRowNr);
                qryWorker.paramByname('row_nr').AsInteger := pVerifLine.FGridLineNr;
                qryWorker.paramByname('rec_changed').AsDateTime := now;
                qryWorker.paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
                qryWorker.paramByname('id').AsInteger := pVerifLine.FLineId;
                qryWorker.ExecSQL;
              end;
            end;

            // ---
            dmodule.primConnection.Commit;


            // värskendame ridu
            qryTaxFormsSel.paramByname('formd_id').AsInteger := self.FSelectedFormId;
            qryTaxFormsSel.active := False;
            qryTaxFormsSel.active := True;


            // impordi lipp maha !
            self.FLinesImportedFromFile := False;

            // ------------------------------------------------------------------
            self.loadGridLines; // uuendame uuesti ridu !
            // ------------------------------------------------------------------

            btnSave.Enabled := False;
            btnCancel.Enabled := False;

          finally
            if dmodule.primConnection.InTransaction then
              try
                dmodule.primConnection.Rollback;
              except
              end;

            if pClearDelItems then
              self.FDeletedItems.Clear;

            qryWorker.Close;
            qryWorker.SQL.Clear;
          end
        else
        if pgridDeclForms.CanFocus then
          pgridDeclForms.SetFocus;

      finally
        FreeAndNil(pCollection);
      end;
  except
    on e: Exception do
    begin
      if dmodule.primConnection.InTransaction then
        try
          dmodule.primConnection.Rollback;
        except
        end;
      Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
    end;
  end;
end;

procedure TframeDeclForms.forceResize;
begin
  if not FGridHeightCorrected then
  begin
    pgridDeclForms.Height := pgridDeclForms.Height - 15;
    FGridHeightCorrected := True;
  end;

  if self.FDeclFrameMode = __declDisplayForms then
    pgridDeclForms.Columns.Items[CCol_description].Width := pgridDeclForms.Width - 44;
end;

initialization
  {$I estbk_fra_declforms.ctrs}

end.