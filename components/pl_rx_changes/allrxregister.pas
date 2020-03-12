{**********************************************************************
                PilotLogic Software House.
  
 Package pl_RX.pkg
 This file is part of CodeTyphon Studio (https://www.pilotlogic.com/)
***********************************************************************}

unit allrxregister;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, forms, LResources,
  TypInfo, TyphonPackageIntf, DBPropEdits, PropEdits,
  DB, ComponentEditors;


procedure Register;

implementation
{$R allrxregister.res}
uses
  //..............General..................
  rxfolderlister, rxduallist, RxHistoryNavigator,
  rxcurredit, rxswitch, rxdice, rxtoolbar, rxpagemngr,
  rxctrls, rxstrutils, rxdconst,
  RxCustomChartPanel, rxautopanel, rxpickdate, rxconst, rxtooledit, rxclock,
  rxceEditLookupFields, rxpopupunit, rxspin, RxTimeEdit,
  RxAboutDialog, RxViewsPanel, RxMDI,RxIniPropStorage, rxDateRangeEditUnit,
  RXHistory,
  rxlazreport,
  lrRxControls,

  //..............DB.......................
  rxdbgrid, RxDBSpinEdit, RxDBTimeEdit, RxDBCtrls, rxmemds,
  rxseldsfrm,  RxDBColorBox, rxdbdateedit, rxdbcomb,
  rxlookup, rxdbcurredit, RxDBGridExportSpreadSheet, RxDBGridPrintGrid,
  RxSortSqlDB,RxSortZeos,RxDBGridFooterTools, rxdbgridexportpdf,
  rxdbverticalgrid,

  //.................Tools.................
  RxSystemServices, RxLogin, RxVersInfo, RxCloseFormValidator,
  RxTextHolder, RxTextHolder_Editor,

  //.................Other.................
  MRUList, StrHolder;


resourcestring
  sTestTRxLoginDialog = 'Test TRxLoginDialog';
  sLoadIcon        = 'Load icon';


type
  PClass = ^TClass;


//=== from register_rxtools ==============

  TRxTextHolderEditor = class(TComponentEditor)
  public
    function GetVerbCount:integer;override;
    function GetVerb(Index:integer):string;override;
    procedure ExecuteVerb(Index:integer);override;
  end;

//=== from register_rxctrl ===============

  TRxCollumsSortFieldsProperty = class(TDBGridFieldProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    procedure FillValues(const Values: TStringList); override;
  end;

  TPopUpColumnFieldProperty = class(TFieldProperty)
  public
    procedure FillValues(const Values: TStringList); override;
  end;

  THistoryButtonProperty = class(TStringPropertyEditor)
  public
    function  GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;


  TRxLoginDialogEditor = class(TComponentEditor)
  public
    DefaultEditor: TBaseComponentEditor;
    constructor Create(AComponent: TComponent; ADesigner: TComponentEditorDesigner); override;
    destructor Destroy; override;
    function GetVerbCount:integer;override;
    function GetVerb(Index:integer):string;override;
    procedure ExecuteVerb(Index:integer);override;
  end;

  TToolPanelEditor = class(TComponentEditor)
  public
    function GetVerbCount:integer;override;
    function GetVerb(Index:integer):string;override;
    procedure ExecuteVerb(Index:integer);override;
  end;

  TRxViewsPanelEditor = class(TComponentEditor)
  public
    function GetVerbCount:integer;override;
    function GetVerb(Index:integer):string;override;
    procedure ExecuteVerb(Index:integer);override;
  end;

  TRxCloseFormValidatorEditor = class(TComponentEditor)
  public
    function GetVerbCount:integer;override;
    function GetVerb(Index:integer):string;override;
    procedure ExecuteVerb(Index:integer);override;
  end;

//=== from RegisterRxDB.pas ====

  TRxDBGridFieldProperty = class(TFieldProperty)
  public
    procedure FillValues(const Values: TStringList); override;
  end;

  TRxDBVerticalGridFieldProperty = class(TFieldProperty)
  public
    procedure FillValues(const Values: TStringList); override;
  end;

  TRxDBGridComponentEditor = class(TDBGridComponentEditor)
    procedure ExecuteVerb({%H-}Index: Integer); override;
  end;

  TRxDBGridFooterFieldProperty = class(TFieldProperty)
  public
    procedure FillValues(const Values: TStringList); override;
  end;


//=== from RXHistory.pas ====

  TTRXHistoryBtnNameProperty = class(TStringPropertyEditor)
  public
    function  GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

//=====================================================
//=====================================================
//=====================================================

//=== from register_rxtools ==============

function TRxTextHolderEditor.GetVerbCount: integer;
begin
  Result:=1;
end;

function TRxTextHolderEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0:Result:=sRxTextHolderTextEditor;
  else
    Result:='';
  end;
end;

procedure TRxTextHolderEditor.ExecuteVerb(Index: integer);
begin
  if Index = 0 then
  begin
    if ShowRxTextHolderEditorForm(Component as TRxTextHolder) then
      Modified;
  end
  else
    inherited ExecuteVerb(Index);
end;

//=== from register_rxctrl.pas ===============


function TRxViewsPanelEditor.GetVerbCount: integer;
begin
  Result:=1;
end;

function TRxViewsPanelEditor.GetVerb(Index: integer): string;
begin
  if Index = 0 then Result:=sRxViewsPanelEditor
  else Result:='';
end;

procedure TRxViewsPanelEditor.ExecuteVerb(Index: integer);
var
  FRxViewsPanel: TRxViewsPanel;
begin
  if Index = 0 then
  begin
    FRxViewsPanel:=GetComponent as TRxViewsPanel;
    TCollectionPropertyEditor.ShowCollectionEditor(FRxViewsPanel.Items, FRxViewsPanel, 'Items');
  end
  else
    inherited ExecuteVerb(Index);
end;

{ TRxCloseFormValidatorEditor }

function TRxCloseFormValidatorEditor.GetVerbCount: integer;
begin
  Result:=1;
end;

function TRxCloseFormValidatorEditor.GetVerb(Index: integer): string;
begin
  if Index = 0 then Result:=sRxCloseFormValidatorEditor
  else Result:='';
end;

procedure TRxCloseFormValidatorEditor.ExecuteVerb(Index: integer);
var
  FEdt: TRxCloseFormValidator;
begin
  if Index = 0 then
  begin
    FEdt:=GetComponent as TRxCloseFormValidator;
    TCollectionPropertyEditor.ShowCollectionEditor(FEdt.Items, FEdt, 'Items');
  end
  else
    inherited ExecuteVerb(Index);
end;

{ TToolPanelEditor }

function TToolPanelEditor.GetVerbCount: integer;
begin
  Result:=1;
end;

function TToolPanelEditor.GetVerb(Index: integer): string;
begin
  if Index = 0 then Result:=sRxToolPanelEditor
  else Result:='';
end;

procedure TToolPanelEditor.ExecuteVerb(Index: integer);
var
  ToolPanel: TToolPanel;
begin
  if Index = 0 then
  begin
    ToolPanel:=GetComponent as TToolPanel;
    TCollectionPropertyEditor.ShowCollectionEditor(ToolPanel.Items, ToolPanel, 'Items');
  end
  else
    inherited ExecuteVerb(Index);
end;


{ TRxLoginDialogEditor }

constructor TRxLoginDialogEditor.Create(AComponent: TComponent;
  ADesigner: TComponentEditorDesigner);
var
  CompClass: TClass;
begin
  inherited Create(AComponent, ADesigner);
  CompClass := PClass(Acomponent)^;
  try
    PClass(AComponent)^ := TComponent;
    DefaultEditor := GetComponentEditor(AComponent, ADesigner);
  finally
    PClass(AComponent)^ := CompClass;
  end;
end;

destructor TRxLoginDialogEditor.Destroy;
begin
  DefaultEditor.Free;
  inherited Destroy;
end;

function TRxLoginDialogEditor.GetVerbCount: integer;
begin
  Result:=DefaultEditor.GetVerbCount + 1;
end;

function TRxLoginDialogEditor.GetVerb(Index: integer): string;
begin
  if Index < DefaultEditor.GetVerbCount then
    Result := DefaultEditor.GetVerb(Index)
  else
  begin
    case Index - DefaultEditor.GetVerbCount of
      0:Result:=sTestTRxLoginDialog;
    end;
  end;
end;

procedure TRxLoginDialogEditor.ExecuteVerb(Index: integer);
begin
  if Index < DefaultEditor.GetVerbCount then
    DefaultEditor.ExecuteVerb(Index)
  else
  begin
    case Index - DefaultEditor.GetVerbCount of
      0:(Component as TRxLoginDialog).Login;
    end;
  end;
end;

{ THistoryButtonProperty }

function THistoryButtonProperty.GetAttributes: TPropertyAttributes;
begin
  Result:= [paValueList, paSortList, paMultiSelect];
end;

procedure THistoryButtonProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Navigator:TRxHistoryNavigator;
begin
  Navigator:=TRxHistoryNavigator(GetComponent(0));
  if Assigned(Navigator) then
  begin
    if Assigned(Navigator.ToolPanel) then
    begin
      for i:=0 to Navigator.ToolPanel.Items.Count - 1 do
      begin
        if Assigned(Navigator.ToolPanel.Items[i].Action) then
          Proc(Navigator.ToolPanel.Items[i].Action.Name);
      end;
    end;
  end;
end;

{ TPopUpColumnFieldProperty }

procedure TPopUpColumnFieldProperty.FillValues(const Values: TStringList);
var
  Column: TPopUpColumn;
  DataSource: TDataSource;
begin
  Column:=TPopUpColumn(GetComponent(0));
  if not (Column is TPopUpColumn) then exit;
  DataSource := TPopUpFormColumns(Column.Collection).PopUpFormOptions.DataSource;
  if Assigned(DataSource) and Assigned(DataSource.DataSet) then
    DataSource.DataSet.GetFieldNames(Values);
end;


{ TRxCollumsSortFieldsProperty }

function TRxCollumsSortFieldsProperty.GetAttributes: TPropertyAttributes;
begin
  Result:= [paValueList, paSortList, paMultiSelect, paDialog];
end;

procedure TRxCollumsSortFieldsProperty.Edit;
var
  DualListDialog1: TDualListDialog;
  FCol:TRxColumn;
 /// FGrid:TRxDBGrid;

procedure DoInitFill;
var
  i,j:integer;
  LookupDisplay:string;
begin
  LookupDisplay:=FCol.SortFields;
  if LookupDisplay<>'' then
  begin
    StrToStrings(LookupDisplay, DualListDialog1.List2, ';');
    for i:=DualListDialog1.List1.Count-1 downto 0 do
    begin
      j:=DualListDialog1.List2.IndexOf(DualListDialog1.List1[i]);
      if j>=0 then
        DualListDialog1.List1.Delete(i);
    end;
  end;
end;

function DoFillDone:string;
var
  i:integer;
begin
  for i:=0 to DualListDialog1.List2.Count-1 do
    Result:=Result + DualListDialog1.List2[i]+';';
  if Result<>'' then
    Result:=Copy(Result, 1, Length(Result)-1);
end;

procedure DoSetCaptions;
begin
  DualListDialog1.Label1Caption:=sRxAllFields;
  DualListDialog1.Label2Caption:=sRxSortFieldsDisplay;
  DualListDialog1.Title:=sRxFillSortFieldsDisp;
end;

begin
  FCol:=nil;

  if GetComponent(0) is TRxColumn then
    FCol:=TRxColumn(GetComponent(0))
  else
    exit;

  DualListDialog1:=TDualListDialog.Create(Application);
  try
    DoSetCaptions;
    FillValues(DualListDialog1.List1 as TStringList);
    DoInitFill;
    if DualListDialog1.Execute then
      FCol.SortFields:=DoFillDone;
  finally
    FreeAndNil(DualListDialog1);
  end;
end;

procedure TRxCollumsSortFieldsProperty.FillValues(const Values: TStringList);
var
  Column: TRxColumn;
  Grid: TRxDBGrid;
  DataSource: TDataSource;
begin
  Column:=TRxColumn(GetComponent(0));
  if not (Column is TRxColumn) then exit;
  Grid:=TRxDBGrid(Column.Grid);
  if not (Grid is TRxDBGrid) then exit;
//  LoadDataSourceFields(Grid.DataSource, Values);

  DataSource := Grid.DataSource;
  if (DataSource is TDataSource) and Assigned(DataSource.DataSet) then
    DataSource.DataSet.GetFieldNames(Values);

end;


//=== from RegisterRxDB.pas ====

procedure TRxDBGridComponentEditor.ExecuteVerb(Index: Integer);
var
  Hook: TPropertyEditorHook;
  FRxBGrid: TRxDBGrid;
begin
  FRxBGrid := GetComponent as TRxDBGrid;
  GetHook(Hook);
  EditDBGridColumns( FRxBGrid, FRxBGrid.Columns, 'Columns' );
  if Assigned(Hook) then Hook.Modified(Self);
end;

procedure TRxDBVerticalGridFieldProperty.FillValues(const Values: TStringList);
var
  FRow: TRxDBVerticalGridRow;
  Grid: TRxDBVerticalGrid;
  DataSource: TDataSource;
begin
  FRow:=TRxDBVerticalGridRow(GetComponent(0));
  if not (FRow is TRxDBVerticalGridRow) then exit;
  Grid:=TRxDBVerticalGrid(FRow.Grid);
  if not (Grid is TRxDBVerticalGrid) then exit;
  DataSource := Grid.DataSource;
  if Assigned(DataSource) and Assigned(DataSource.DataSet) then
    DataSource.DataSet.GetFieldNames(Values);
end;

procedure TRxDBGridFieldProperty.FillValues(const Values: TStringList);
var
  Column: TRxColumn;
  Grid: TRxDBGrid;
  DataSource: TDataSource;
begin
  Column:=TRxColumn(GetComponent(0));
  if not (Column is TRxColumn) then exit;
  Grid:=TRxDBGrid(Column.Grid);
  if not (Grid is TRxDBGrid) then exit;
  DataSource := Grid.DataSource;
  if Assigned(DataSource) and Assigned(DataSource.DataSet) then
    DataSource.DataSet.GetFieldNames(Values);
end;

procedure TRxDBGridFooterFieldProperty.FillValues(const Values: TStringList);
var
  Grid: TRxDBGrid;
  DataSource: TDataSource;
begin
  if GetComponent(0) is TRxColumnFooterItem then
    Grid:=TRxDBGrid(TRxColumnFooterItem(GetComponent(0)).Owner.Grid)
  else
(*  if GetComponent(0) is TRxColumnFooter then
    Grid:=TRxDBGrid(TRxColumnFooter(GetComponent(0)).Owner.Grid)
  else *)
    exit;
  if not (Grid is TRxDBGrid) then exit;

  DataSource := Grid.DataSource;
  if Assigned(DataSource) and Assigned(DataSource.DataSet) then
    DataSource.DataSet.GetFieldNames(Values);
end;


//=== from RXHistory.pas ====

function TTRXHistoryBtnNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result:=inherited GetAttributes;
  Result:=Result + [paValueList, paSortList, paMultiSelect];
end;

procedure TTRXHistoryBtnNameProperty.GetValues(Proc: TGetStrProc);
var
  ToolPanel:TToolPanel;
  i:integer;
begin
  ToolPanel := GetObjectProp(GetComponent(0), 'ToolPanel') as TToolPanel;
  if Assigned(ToolPanel) then
    for I := 0 to ToolPanel.Items.Count - 1 do
    begin
      if Assigned(ToolPanel.Items[i].Action) then
       Proc(ToolPanel.Items[i].Action.Name);
    end;
end;

// =======================================================
// =======================================================
// =======================================================

procedure Register;
begin

//..............General..................
  RegisterComponents('RX',[
                           TPageManager,
                           TDualListDialog,
                           TCurrencyEdit,
                           TRxSwitch,
                           TRxDice,
                           TFolderLister,
                           TToolPanel,
                           TRxLabel, TSecretPanel, TRxSpeedButton, TRxRadioGroup,
                           TRxChart,    //??
                           TAutoPanel,
                           TRxCalendarGrid,
                           TRxDateEdit, 
                           TRxDateRangeEdit,
                           TRxClock,
                           TRxSpinButton, TRxSpinEdit, 
                           TRxTimeEdit,
                           TRxAboutDialog,
                           TRxViewsPanel,
                           TRxMDICloseButton, TRxMDIPanel, TRxMDITasks,
                           TRXHistory,
                           TRxHistoryNavigator
                           ]);

  // from RxLazReport.pas
  RegisterComponents('Reports',[TRxReport]);  // from RxLazReport.pas


  // from register_rxctrl.pas

  RegisterComponentEditor(TRxLoginDialog, TRxLoginDialogEditor);
  RegisterComponentEditor(TToolPanel, TToolPanelEditor);
  RegisterComponentEditor(TRxCloseFormValidator, TRxCloseFormValidatorEditor);
  RegisterComponentEditor(TRxViewsPanel, TRxViewsPanelEditor);

  RegisterPropertyEditor(TypeInfo(string), TPopUpColumn, 'FieldName', TPopUpColumnFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TRxHistoryNavigator, 'BackBtn', THistoryButtonProperty);
  RegisterPropertyEditor(TypeInfo(string), TRxHistoryNavigator, 'ForwardBtn', THistoryButtonProperty);

  RegisterPropertyEditor(TypeInfo(string), TRxColumn, 'SortFields', TRxCollumsSortFieldsProperty);

  RegisterCEEditLookupFields;

  // from RXHistory.pas
  RegisterPropertyEditor(TypeInfo(string), TRXHistory, 'PriorButtonName', TTRXHistoryBtnNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TRXHistory, 'NextButtonName', TTRXHistoryBtnNameProperty);

//..............DB.................

// from from RegisterRxDB.pas

  RegisterComponents('RX DBAware',[
                                   TRxDBSpinEdit,
                                   TRxDBTimeEdit,
                                   TRxDBProgressBar, TRxDBTrackBar, TRxDBRadioGroup,
                                   TRxDBGrid,
                                   TRxDBGridFooterTools,
                                   TRxDBGridExportPDF,
                                   TRxMemoryData,
                                   TRxDBColorBox,

                                   TRxDBDateEdit, TRxDBCalcEdit, TRxDBCurrEdit,
                                   
                                   TRXLookupEdit, TRxDBLookupCombo,
                                   TRxDBComboBox,

                                   TRxDBVerticalGrid,

                                   TRxDBGridExportSpreadSheet,
                                   TRxDBGridPrint,
                                   TRxSortSqlDB,
                                   TRxSortZeos
                                   ]);


  RegisterComponentEditor(TRxMemoryData, TMemDataSetEditor);
  RegisterComponentEditor(TRxDBGrid, TRxDBGridComponentEditor);
  RegisterPropertyEditor(TypeInfo(string), TRxColumn, 'FieldName', TRxDBGridFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TRxDBVerticalGridRow, 'FieldName', TRxDBVerticalGridFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TRxColumnFooterItem, 'FieldName', TRxDBGridFooterFieldProperty);

//.................Tools.................

// from RegisterRxTools.pas

  RegisterComponents('RX Tools', [
                                  TRxSystemServices,
                                  TRxLoginDialog,
                                  TRxVersionInfo,
                                  TRxCloseFormValidator,
                                  TRxIniPropStorage ,
                                  TRxTextHolder
                                  ]);


  RegisterComponentEditor(TRxLoginDialog, TRxLoginDialogEditor);

 // from register_rxtools

  RegisterComponentEditor(TRxTextHolder, TRxTextHolderEditor);

  //.................Other.................

  RegisterComponents('Misc',    [TMRUManager, TStrHolder]);
end;

// =======================================================
// =======================================================
// =======================================================


end.

