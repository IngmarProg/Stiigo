unit estbk_fra_declformulacreator;

{$mode objfpc}
{$H+}
{$i estbk_defs.inc}
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, Grids, LCLType,
  ComCtrls, ExtCtrls, estbk_fra_template, estbk_types, estbk_lib_commonevents, estbk_utilities, estbk_clientdatamodule,
  ZDataset, DB, estbk_lib_commoncls, Graphics, Menus, Buttons, VirtualTrees, types;

const
  CDturnover_indx = 0; // DK
  CCturnover_indx = 1; // KK
  CDbalance_indx = 2; // DS
  CCbalance_indx = 3; // KS


type
  PNodeData = ^TNodeData;

  TNodeData = record
    FAccId: integer;
    FAccName: AStr;
    FAccCode: AStr;
  end;



type

  { TframeFormulaCreator }

  TframeFormulaCreator = class(Tfra_template)
    btnSave: TBitBtn;
    btnClose: TBitBtn;
    cmbEqType: TComboBox;
    edtEq: TEdit;
    grpBoxCAccounts: TCheckGroup;
    lblEq: TLabel;
    lstSelectedAccounts: TListView;
    extpopup: TPopupMenu;
    mnuitemdelline: TMenuItem;
    prightpanel: TPanel;
    pleftpanel: TPanel;
    pmainRezsizepanel: TPanel;
    grpFormulas: TGroupBox;
    pSrcAccount: TEdit;
    Splitter1: TSplitter;
    qryAccounts: TZQuery;
    pAccounts: TVirtualStringTree;
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cmbEqTypeChange(Sender: TObject);
    procedure edtEqChange(Sender: TObject);
    procedure edtEqExit(Sender: TObject);
    procedure grpBoxCAccountsClick(Sender: TObject);
    procedure grpBoxCAccountsItemClick(Sender: TObject; Index: integer);
    procedure lstSelectedAccountsCustomDraw(Sender: TCustomListView; const ARect: TRect; var DefaultDraw: boolean);
    procedure lstSelectedAccountsCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: boolean);
    procedure lstSelectedAccountsDragOver(Sender, Source: TObject; X, Y: integer; State: TDragState; var Accept: boolean);
    procedure lstSelectedAccountsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure lstSelectedAccountsSelectItem(Sender: TObject; Item: TListItem; Selected: boolean);
    procedure mnuitemdellineClick(Sender: TObject);
    procedure pAccountsAdvancedHeaderDraw(Sender: TVTHeader; var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements);
    procedure pAccountsBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure pAccountsColumnDblClick(Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
    procedure pAccountsCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: integer);
    procedure pAccountsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure pAccountsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure pSrcAccountKeyPress(Sender: TObject; var Key: char);
    procedure pListAccounts2InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure pListAccounts2Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure pAccountsFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure pAccountsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure pAccountsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure pAccountsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    FFormula: AStr;
    FPActiveTitleIndx: integer;
    FSkipAccAttrSelect: boolean;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure extractAccountsFromFormula(const pFormula: AStr);
    procedure setFormula(const v: AStr);
    procedure fillListView;
    // checkboxide valik
    function encodeAccAttrVal(): integer;
    procedure decodeAndSetAccAttrVal(const pListItem: TListItem);
    // valemisse
    function encodeAccSumFlags(const pFlags: AStr): integer;
    function decodeAccSumFlags(const pFlags: integer): AStr;


    procedure addCurrentAccitem;
    procedure deleteSelectedItem;
    procedure doRelMarkinginEdit(const Item: TListItem);


  public
    procedure Clear;
    // ---
    procedure refreshAccounts;
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published // RTTI teema !
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
    property formula: AStr read FFormula write setFormula;
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
  end;

implementation

uses estbk_uivisualinit, estbk_sqlclientcollection, estbk_globvars, strutils, Dialogs;

procedure TframeFormulaCreator.pSrcAccountKeyPress(Sender: TObject; var Key: char);
var
  psrcField: AStr;
  i: integer;
  pNode: PVirtualNode;
  pData: PNodeData;
begin
  // --
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else
  if Sender = pSrcAccount then
  begin
    if self.FPActiveTitleIndx = 0 then
      psrcField := 'account_coding'
    else
      psrcField := 'account_name';
    estbk_utilities.edit_autoCompData(Sender as TCustomEdit, key, qryAccounts, psrcField);
    pNode := pAccounts.GetFirst();

    while assigned(pNode) do
    begin
      pData := pAccounts.GetNodeData(pNode);
      if assigned(pData) and (pData^.FAccId = qryAccounts.FieldByName('id').AsInteger) then
      begin
        pAccounts.Selected[pNode] := True;
        pAccounts.ScrollIntoView(pNode, False);
        break;
      end;

      // ---
      pNode := pAccounts.GetNextSibling(pNode);
    end;
  end;
end;

procedure TframeFormulaCreator.pListAccounts2InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  // --
  InitialStates := [];
end;

procedure TframeFormulaCreator.pListAccounts2Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin

end;

procedure TframeFormulaCreator.pAccountsFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin

end;

procedure TframeFormulaCreator.pAccountsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  Data: PNodeData;
begin
  // --
  Data := Sender.GetNodeData(Node);
  if assigned(Data) then
    case Column of
      0: CellText := Data^.FAccCode;
      1: CellText := Data^.FAccName;
    end;
end;

procedure TframeFormulaCreator.pAccountsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
// cursor on 32x32 meie pildid 16x16
const
  CDefPictSize = 0;
  CDefCursorSize = 32;

var
  xleft, i, plastXPos: integer;
  //pFndParent : TWinControl;

begin
    {
       xleft:=pListAccounts2.Left+CDefPictSize;
       pFndParent:=pListAccounts2.Parent;
    while assigned(pFndParent) do
      begin
         xleft:=xleft+pFndParent.Left;
         pFndParent:=pFndParent.Parent;
      end;
    }

  xleft := pAccounts.Left;
  with Sender.Columns do
  begin
    for  i := 0 to Count - 1 do
      if Items[i].Index <> Column then
        xleft := xleft + Items[i].Width + CDefPictSize // ka meie ikooni suurus !
      else
        break;
    plastXPos := X; //Mouse.CursorPos.X-CDefCursorSize;

    // tuleb lahutada cursori pildi suurus ja see on 32pixlit !
    if (plastXPos >= xleft - 15) and (plastXPos < xleft + 22) then
    begin
      // --- 0 staatused
      for  i := 0 to Count - 1 do
        if Column <> i then
          Items[i].ImageIndex := img_indxItemUnChecked;


      if Items[Column].ImageIndex = img_indxItemUnChecked then
        Items[Column].ImageIndex := img_indxItemChecked;

      self.FPActiveTitleIndx := Column;
      pSrcAccount.Text := '';
    end
    else
    begin

      if pAccounts.Header.SortDirection = sdAscending then
        pAccounts.Header.SortDirection := sdDescending
      else
        pAccounts.Header.SortDirection := sdAscending;
      pAccounts.Header.SortColumn := Column;
      pAccounts.SortTree(Column, pAccounts.Header.SortDirection, False);
    end;
  end;
end;

procedure TframeFormulaCreator.pAccountsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = VK_RETURN then
  begin
    self.addCurrentAccitem;
    key := 0;
  end;
end;


procedure TframeFormulaCreator.cmbEqTypeChange(Sender: TObject);
//var
//  pListItem : TListItem;
begin
{
    pListItem:=pListAccountsddd.Selected;
 // kas on operaator
 if assigned(pListItem) and not assigned(pListItem.Data) then
   begin
    //pListItem.Caption:=TCombobox(Sender).text;
    self.assignOperatorImg(pListItem);
    lstSelectedAccounts.Repaint;
   end;}
end;

procedure TframeFormulaCreator.edtEqChange(Sender: TObject);
begin
  if trim(TEdit(Sender).Text) = '' then
    lstSelectedAccounts.Clear;
end;

procedure TframeFormulaCreator.edtEqExit(Sender: TObject);
begin

end;

procedure TframeFormulaCreator.grpBoxCAccountsClick(Sender: TObject);
begin
  // --
end;

function TframeFormulaCreator.encodeAccSumFlags(const pFlags: AStr): integer;
begin
  Result := estbk_types.CFCreator_DC_Flag;
  if pFlags = estbk_types.CFCreator_DC_FlagAsStr then
    Result := estbk_types.CFCreator_DC_Flag
  else
  if pFlags = estbk_types.CFCreator_CC_FlagAsStr then
    Result := estbk_types.CFCreator_CC_Flag
  else
  if pFlags = estbk_types.CFCreator_SA_FlagAsStr then
    Result := estbk_types.CFCreator_SA_Flag;

  //if  pFlags=estbk_types.CFCreator_DS_FlagAsStr  then
  //    result:=estbk_types.CFCreator_DS_Flag
  //else
  //if  pFlags=estbk_types.CFCreator_CS_FlagAsStr  then
  //    result:=estbk_types.CFCreator_CS_Flag;
end;

function TframeFormulaCreator.decodeAccSumFlags(const pFlags: integer): AStr;
begin
  Result := '';
  if (pFlags and estbk_types.CFCreator_DC_Flag) = estbk_types.CFCreator_DC_Flag then
    Result := estbk_types.CFCreator_DC_FlagAsStr
  else
  if (pFlags and estbk_types.CFCreator_CC_Flag) = estbk_types.CFCreator_CC_Flag then
    Result := estbk_types.CFCreator_CC_FlagAsStr
  else
  if (pFlags and estbk_types.CFCreator_SA_Flag) = estbk_types.CFCreator_SA_Flag then
    Result := estbk_types.CFCreator_SA_FlagAsStr;

  // if (pFlags  and estbk_types.CFCreator_DS_Flag)=estbk_types.CFCreator_DS_Flag then
  //     result:=estbk_types.CFCreator_DS_FlagAsStr
  // else
  // if (pFlags  and estbk_types.CFCreator_CS_Flag)=estbk_types.CFCreator_CS_Flag then
  //     result:=estbk_types.CFCreator_CS_FlagAsStr;
end;

procedure TframeFormulaCreator.btnSaveClick(Sender: TObject);
var
  i: integer;
begin
  // lükkame nö valemi kokku
  self.FFormula := trim(EdtEq.Text);

  if assigned(self.FframeKillSignal) then
    self.FframeKillSignal(Self);
end;

procedure TframeFormulaCreator.btnCloseClick(Sender: TObject);
begin
  if assigned(self.FframeKillSignal) then
    self.FframeKillSignal(self);
end;

procedure TframeFormulaCreator.grpBoxCAccountsItemClick(Sender: TObject; Index: integer);
var
  i, pencValue: integer;
  pListDescr: TIntIDAndCTypes;
  pCurrText: AStr;
  pOrigSel: integer;
  pOrigLen: integer;
  pSelDelta: integer;
begin
  if not self.FSkipAccAttrSelect then
    try
      self.FSkipAccAttrSelect := True;
      for i := 0 to grpBoxCAccounts.Items.Count - 1 do
        if i <> Index then
        begin
          grpBoxCAccounts.Checked[i] := False;
        end;

      // 03.11.2010 Ingmar; meil peab ikka check peale jääma !
      if not grpBoxCAccounts.Checked[Index] then
        grpBoxCAccounts.Checked[Index] := True;


      // ---
      if assigned(lstSelectedAccounts.Selected) and assigned(lstSelectedAccounts.Selected.Data) then
      begin
        pListDescr := TIntIDAndCTypes(lstSelectedAccounts.Selected.Data);
        pencValue := self.encodeAccAttrVal();
        // ---
        pListDescr.flags := pencValue;

        pCurrText := edtEq.Text;
        if edtEq.SelLength > 0 then
        begin
          pOrigLen := edtEq.SelLength;
          pOrigSel := edtEq.SelStart;

          pSelDelta := edtEq.SelStart;
          if pSelDelta = 0 then
            pSelDelta := 1;

          Delete(pCurrText, posex('@', pCurrText, pSelDelta) + 1, 2);
          insert(self.decodeAccSumFlags(pEncValue), pCurrText, posex('@', pCurrText, pSelDelta) + 1);
          edtEq.Text := pCurrText;

          edtEq.SelStart := pOrigSel;
          edtEq.SelLength := pOrigLen;

        end;

      end;

      // ---
    finally
      self.FSkipAccAttrSelect := False;
    end;
end;


procedure TframeFormulaCreator.lstSelectedAccountsCustomDraw(Sender: TCustomListView; const ARect: TRect; var DefaultDraw: boolean);
begin
  with Sender.Canvas do
  begin
    fillRect(ARect);
    //DefaultDraw:=false;
  end;
end;

procedure TframeFormulaCreator.lstSelectedAccountsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: boolean);
begin

end;

procedure TframeFormulaCreator.lstSelectedAccountsDragOver(Sender, Source: TObject; X, Y: integer; State: TDragState; var Accept: boolean);
begin
  // ---
  Accept := (Source is TVirtualStringTree) and assigned(TVirtualStringTree(Source).FocusedNode);
  if State = dsDragEnter then
  begin
    self.addCurrentAccitem;
  end;
end;

procedure TframeFormulaCreator.deleteSelectedItem;
var
  pcurrIndx: integer;
  pnodeData: Pointer;
  pcurrItem: AStr;
begin

  if lstSelectedAccounts.SelCount = 1 then
    // for i:=0 to lstboxChItems.Count-1 do
    // if lstboxChItems.Selected[i] then
  begin
    // operaatorit otse ei kustuta

    if not assigned(lstSelectedAccounts.Selected.Data) then
      exit;

    pcurrIndx := lstSelectedAccounts.ItemIndex;
    pnodeData := lstSelectedAccounts.Items[pcurrIndx].Data;

    if assigned(pnodeData) then
    begin
      TObject(pnodeData).Free;
      lstSelectedAccounts.Items[pcurrIndx].Data := nil;
    end;

    // kui esimene konto, siis kustutame ka tehte märgi ära !
    if (pcurrIndx = 0) and (pcurrIndx + 1 <= lstSelectedAccounts.items.Count - 1) and not assigned(lstSelectedAccounts.Items[pcurrIndx + 1].Data) then
    begin
      lstSelectedAccounts.Items.Delete(pcurrIndx + 1);
      lstSelectedAccounts.Items.Delete(pcurrIndx);
    end
    else
    // (pcurrIndx=lstSelectedAccounts.items.Count-1)
    if (pcurrIndx - 1 >= 0) and not assigned(lstSelectedAccounts.Items[pcurrIndx - 1].Data) then
    begin
      lstSelectedAccounts.Items.Delete(pcurrIndx);
      lstSelectedAccounts.Items.Delete(pcurrIndx - 1);
    end
    else
      lstSelectedAccounts.Items.Delete(pcurrIndx);


    pcurrItem := edtEq.Text;
    if edtEq.SelLength > 0 then
    begin
      Delete(pcurrItem, edtEq.SelStart, edtEq.SelLength + 1);
      edtEq.Text := pcurrItem;
    end;

    // ---
    btnSave.Enabled := lstSelectedAccounts.Items.Count > 0;
  end;
end;

procedure TframeFormulaCreator.lstSelectedAccountsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  pcurrIndx: integer;
begin
  if key = VK_DELETE then
  begin
    self.deleteSelectedItem;
    // --
    key := 0;
  end;

end;

// üritab leida konto ja teha sellele highlight
procedure TframeFormulaCreator.doRelMarkinginEdit(const Item: TListItem);
var
  pAccCode: AStr;
  pAccCmp: AStr;
  i: integer;
  pLCnt: integer; // kui mitu sama koodiga kontot, siis peame teadma, millist highlightiga
  pSrcLoop: integer;
  pSrcPos: integer;
  pSrcDelta: integer;
  pSrcPL: integer;
begin

  edtEq.SelStart := 0;
  edtEq.SelLength := 0;

  if assigned(Item) then
  begin
    pAccCode := AnsiUpperCase(trim(copy(Item.Caption, 1, pos(#32, Item.Caption) - 2)));
    pLCnt := 0;
    for i := 0 to lstSelectedAccounts.Items.Count - 1 do
    begin
      pAccCmp := AnsiUpperCase(trim(copy(lstSelectedAccounts.Items.Item[i].Caption, 1, pos(#32, lstSelectedAccounts.Items.Item[i].Caption) - 2)));
      if (pAccCmp = pAccCode) then
        Inc(pLCnt);

      if lstSelectedAccounts.Items.Item[i] = item then
        break;
    end;


    pSrcLoop := 1;
    pSrcPos := 1;
    pSrcDelta := 1;

    while (pSrcLoop <= pLCnt) do
    begin
      pSrcPos := posex(pAccCode + '@', edtEq.Text, pSrcDelta);
      pSrcDelta := pSrcPos + 1;

      if pSrcPos = 0 then
        exit;


      Inc(pSrcLoop);
    end;

    if pSrcLoop - 1 = pLCnt then
    begin
      pSrcPL := posex(']', edtEq.Text, pSrcPos);
      if pSrcPL = 0 then
        exit;

      edtEq.SelStart := pSrcPos - 1;
      edtEq.SelLength := (pSrcPL - pSrcPos) + 1;
    end;

    // ---
  end;
end;

procedure TframeFormulaCreator.lstSelectedAccountsSelectItem(Sender: TObject; Item: TListItem; Selected: boolean);
begin
  if Selected then
  begin
    self.decodeAndSetAccAttrVal(Item);
    self.doRelMarkinginEdit(Item);
  end;
end;

procedure TframeFormulaCreator.mnuitemdellineClick(Sender: TObject);
begin
  self.deleteSelectedItem;
end;

procedure TframeFormulaCreator.pAccountsAdvancedHeaderDraw(Sender: TVTHeader; var PaintInfo: THeaderPaintInfo;
  const Elements: THeaderPaintElements);
begin
{
     with PaintInfo do

      Width := PaintRectangle.Right - PaintRectangle.Left;
                Height := PaintRectangle.Bottom - PaintRectangle.Top;
                TargetRect := Rect(0, 0, Width, Height);
                Canvas.Brush.Color := $E1FFFF;
                Canvas.FillRect(TargetRect);
                InflateRect(TargetRect, - 10, -10);
                SourceRect := TargetRect;
                OffsetRect(SourceRect, -SourceRect.Left + FLeftPos, -SourceRect.Top);
                Canvas.CopyRect(TargetRect, FHeaderBitmap.Canvas, SourceRect);

                TargetCanvas.Font.Name := 'Webdings';
                            TargetCanvas.Font.Charset := SYMBOL_CHARSET;
                            TargetCanvas.Font.Size := 60;
                            if IsHoverIndex then
                              TargetCanvas.Font.Color := $80FF;
                            S := 'û';
                            Size := TargetCanvas.TextExtent(S);
                            SetBkMode(TargetCanvas.Handle, TRANSPARENT);
                            TargetCanvas.TextOut(PaintRectangle.Left + 10, Paintrectangle.Bottom - Size.cy, S);}
end;

procedure TframeFormulaCreator.pAccountsBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  if Column = 0 then
  begin
    TargetCanvas.Brush.Color := estbk_types.MyFavGray;
    TargetCanvas.FillRect(CellRect);
  end;
end;



procedure TframeFormulaCreator.pAccountsColumnDblClick(Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
begin
  self.addCurrentAccitem;
end;

procedure TframeFormulaCreator.pAccountsCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: integer);
var
  Data1, Data2: PNodeData;

begin

  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  if assigned(Data1) and assigned(Data2) then
    case Column of
      0: Result := CompareText(Data1^.FAccCode, Data2^.FAccCode); // konto kood
      1: Result := CompareText(Data1^.FAccName, Data2^.FAccName); // konto nimi
    end;
end;

procedure TframeFormulaCreator.pAccountsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PNodeData;
begin
  if Assigned(Node) then
  begin
    Data := Sender.GetNodeData(Node);
    finalize(Data^);
  end;
end;

procedure TframeFormulaCreator.pAccountsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  Data: PNodeData;
begin
  // --
  Data := Sender.GetNodeData(Node);
  if assigned(Data) then
  begin
    Initialize(Data^);
    Data^.FAccCode := qryAccounts.FieldByName('account_coding').AsString;
    Data^.FAccId := qryAccounts.FieldByName('id').AsInteger;
    Data^.FAccName := qryAccounts.FieldByName('account_name').AsString;
  end;
end;


function TframeFormulaCreator.encodeAccAttrVal(): integer;
var
  i: integer;
begin
  Result := 0;
  for  i := 0 to grpBoxCAccounts.Items.Count - 1 do
    if grpBoxCAccounts.Checked[i] then
      case i of
        0: Result := estbk_types.CFCreator_DC_Flag;
        1: Result := estbk_types.CFCreator_CC_Flag;
        2: Result := estbk_types.CFCreator_SA_Flag;
        //     2: result:=estbk_types.CFCreator_DS_Flag;
        //     3: result:=estbk_types.CFCreator_CS_Flag;
      end;
end;

procedure TframeFormulaCreator.decodeAndSetAccAttrVal(const pListItem: TListItem);
var
  pIndex, i: integer;
begin
  try
    self.FSkipAccAttrSelect := True;


    // --
    for i := 0 to grpBoxCAccounts.Items.Count - 1 do
      grpBoxCAccounts.Checked[i] := False;

    if assigned(pListItem) and assigned(pListItem.Data) then
    begin
      grpBoxCAccounts.Enabled := True;

      pIndex := 0;
      if (TIntIDAndCTypes(pListItem.Data).flags and estbk_types.CFCreator_DC_Flag) = estbk_types.CFCreator_DC_Flag then
        pIndex := 0
      else
      if (TIntIDAndCTypes(pListItem.Data).flags and estbk_types.CFCreator_CC_Flag) = estbk_types.CFCreator_CC_Flag then
        pIndex := 1
      else
      if (TIntIDAndCTypes(pListItem.Data).flags and estbk_types.CFCreator_SA_Flag) = estbk_types.CFCreator_SA_Flag then
        pIndex := 2;

      //   if (TIntIDAndCTypes(pListItem.Data).flags and estbk_types.CFCreator_DS_Flag)=estbk_types.CFCreator_DS_Flag then
      //       pIndex:=2
      //   else
      //   if (TIntIDAndCTypes(pListItem.Data).flags and estbk_types.CFCreator_CS_Flag)=estbk_types.CFCreator_CS_Flag then
      //       pIndex:=3;

      // --
      grpBoxCAccounts.Checked[pIndex] := True;
    end
    else
      grpBoxCAccounts.Enabled := False;

  finally
    self.FSkipAccAttrSelect := False;
  end;
end;

//  if assigned(pListItem) and assigned(pListItem.Data) then

procedure TframeFormulaCreator.addCurrentAccItem;
var
  pNode: PVirtualNode;
  pData: PNodeData;
  pListItem: TListItem;
  pDescr: TIntIDAndCTypes;
  pMerge: AStr;
  pTemp: AStr;
  // pItemCnt : Integer;
begin
  pNode := pAccounts.FocusedNode;
  if assigned(pNode) then
  begin

    pData := pAccounts.GetNodeData(pNode);

    pMerge := '[' + trim(pData^.FAccCode) + '] ' + trim(pData^.FAccName);


    // ---
    pDescr := TIntIDAndCTypes.Create;
    pDescr.id := pData^.FAccId;
    pDescr.clf := pData^.FAccCode;
    pDescr.flags := self.encodeAccAttrVal;

    pListItem := lstSelectedAccounts.Items.Add;
    pListItem.ImageIndex := -1;
    pListItem.Caption := pMerge;
    pListItem.Data := pDescr;

    //with TIntIDAndCTypes(lstSelectedAccounts.Items.Item[i].Data) do
    pTemp := '[' + trim(pDescr.clf) + '@' + self.decodeAccSumFlags(pDescr.flags) + ']';

    if trim(edtEq.Text) = '' then
      edtEq.Text := pTemp
    else
      edtEq.Text := edtEq.Text + cmbEqType.Text + pTemp;
    btnSave.Enabled := True;
  end;
end;

function TframeFormulaCreator.getDataLoadStatus: boolean;
begin
  Result := qryAccounts.active;
end;

procedure TframeFormulaCreator.fillListView;
var
  pNode: PVirtualNode;
  i: integer;
begin

  pAccounts.Clear;
  pAccounts.RootNodeCount := 0;
  // ---

  qryAccounts.First;


  while not qryAccounts.EOF do
  begin
    if ((qryAccounts.FieldByName('flags').AsInteger and estbk_types.CAccFlagsClosed) <> estbk_types.CAccFlagsClosed) then
    begin
      pNode := pAccounts.AddChild(nil);
      pAccounts.ValidateNode(pNode, False);
    end;

    qryAccounts.Next;
  end;
end;

procedure TframeFormulaCreator.Clear;
var
  i: integer;
begin

  //self.FFormula:='';

  for i := 0 to lstSelectedAccounts.Items.Count - 1 do
    if assigned(lstSelectedAccounts.Items.Item[i].Data) then
      TIntIDAndCTypes(lstSelectedAccounts.Items.Item[i].Data).Free;
  lstSelectedAccounts.Items.Clear;


  for i := 0 to grpBoxCAccounts.Items.Count - 1 do
    grpBoxCAccounts.Checked[i] := False;
  grpBoxCAccounts.Checked[0] := True;
end;

procedure TframeFormulaCreator.refreshAccounts;
begin
  qryAccounts.Active := False;
  qryAccounts.Active := True;


  // --
  fillListView;
end;

procedure TframeFormulaCreator.setDataLoadStatus(const v: boolean);
begin
  //Mouse.Capture:=pListAccountsddd.Handle;

  qryAccounts.Close;
  qryAccounts.SQL.Clear;

  if v then
  begin
    qryAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryAccounts.SQL.add(estbk_sqlclientcollection._CSQLGetAllAccounts);
    qryAccounts.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;

    qryAccounts.active := v;

    // ---
    self.fillListView;
  end
  else
    qryAccounts.Connection := nil;

end;


procedure TframeFormulaCreator.extractAccountsFromFormula(const pFormula: AStr);
var
  ptmp: AStr;
  pAccCode: AStr;
  pAccAttr: AStr;
  pPos: integer;
  pEnd: integer;
  pDescr: TIntIDAndCTypes;
  pListItem: TListItem;
begin
  ptmp := pFormula;
  pPos := posex('[', ptmp, 1);

  // tunnistan ausalt, siin mingit erilist veahaldust ei saa teha (lihtdisainer), lihtsalt ignoreerime ridu, mida ei mõisteta !
  while pPos > 0 do
  begin
    pEnd := posex(']', ptmp, pPos);

    if pEnd > 0 then
    begin
      pAccCode := copy(pFormula, pPos + 1, (pEnd - pPos) - 1);
      pAccAttr := copy(pAccCode, pos('@', pAccCode) + 1, 2);
      pAccCode := copy(pAccCode, 1, pos('@', pAccCode) - 1);
      if qryAccounts.Locate('account_coding', pAccCode, [loCaseInsensitive]) then
      begin
        // ---
        pDescr := TIntIDAndCTypes.Create;
        pDescr.id := qryAccounts.FieldByName('id').AsInteger;
        pDescr.clf := pAccCode;
        pDescr.flags := self.encodeAccSumFlags(pAccAttr);

        pListItem := lstSelectedAccounts.Items.Add;
        pListItem.ImageIndex := -1;
        pListItem.Caption := '[' + pAccCode + '] ' + qryAccounts.FieldByName('account_name').AsString;
        pListItem.Data := pDescr;
      end;
      // --
      pPos := pEnd;
    end;

    // --
    pPos := posex('[', ptmp, pPos);
  end;

  // 02.05.2011 Ingmar
  if lstSelectedAccounts.Items.Count > 0 then
  begin
    self.lstSelectedAccounts.Selected := lstSelectedAccounts.Items.Item[0];
    //self.lstSelectedAccountsSelectItem(lstSelectedAccounts,lstSelectedAccounts.Items.Item[0],true);
  end;
end;

procedure TframeFormulaCreator.setFormula(const v: AStr);
begin
  self.Clear;
  self.FFormula := v;
  self.edtEq.Text := v;
  self.extractAccountsFromFormula(v);
end;

constructor TframeFormulaCreator.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);

  pAccounts.Header.Columns.Items[0].ImageIndex := img_indxItemChecked;
  pAccounts.Header.Columns.Items[1].ImageIndex := img_indxItemUnChecked;
  pAccounts.NodeDataSize := sizeof(TNodeData);
  grpBoxCAccounts.Checked[0] := True;

end;

destructor TframeFormulaCreator.Destroy;
var
  i: integer;
begin
  for i := 0 to lstSelectedAccounts.Items.Count - 1 do
    if assigned(lstSelectedAccounts.Items.Item[i].Data) then
      TIntIDAndCTypes(lstSelectedAccounts.Items.Item[i].Data).Free;

  inherited Destroy;

end;

initialization
  {$I estbk_fra_declformulacreator.ctrs}

end.