unit estbk_frm_custunpaiditems;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DBGrids, estbk_types, estbk_clientdatamodule, estbk_sqlclientcollection,
  estbk_globvars, DB, ZDataset, LCLType, Grids, Buttons;

type

  { TformCustUnpaiditems }

  TformCustUnpaiditems = class(TForm)
    btnClose: TBitBtn;
    btnConfirm: TBitBtn;
    gridImg: TImageList;
    qryClientUpItemsDs: TDatasource;
    dbGridupItems: TDBGrid;
    grpLogicalGrp: TGroupBox;
    lblCustName: TLabel;
    lblCustomerName: TLabel;
    qryClientUpItems: TZQuery;
    qryTempQry: TZQuery;
    procedure btnConfirmClick(Sender: TObject);
    procedure dbGridupItemsCellClick(Column: TColumn);
    procedure dbGridupItemsColEnter(Sender: TObject);
    procedure dbGridupItemsDblClick(Sender: TObject);
    procedure dbGridupItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure dbGridupItemsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbGridupItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure FormCreate(Sender: TObject);
    procedure qryClientUpItemsFilterRecord(DataSet: TDataSet; var Accept: boolean);

  private
    procedure doItemSelect(const pSwitchVal: boolean = False);
  public
    function showModal(const pClientId: integer; var pItemId: integer; var pItemIsBill: boolean): boolean; reintroduce;

  end;

var
  formCustUnpaiditems: TformCustUnpaiditems;

implementation

uses estbk_uivisualinit, estbk_strmsg;

const
  CChkColItem = 7;

procedure TformCustUnpaiditems.FormCreate(Sender: TObject);
begin
  // -------
  estbk_uivisualinit.__preparevisual(self);


  dbGridupItems.Columns.items[CChkColItem].ValueChecked := estbk_types.SCFalseTrue[True];
  dbGridupItems.Columns.items[CChkColItem].ValueUnChecked := estbk_types.SCFalseTrue[False]; // valik
end;

procedure TformCustUnpaiditems.qryClientUpItemsFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := copy(AnsiUpperCase(DataSet.FieldByName('itemchk').AsString), 1, 1) = copy(AnsiUpperCase(estbk_types.SCFalseTrue[True]), 1, 1);
end;



procedure TformCustUnpaiditems.dbGridupItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer;
  Column: TColumn; State: TGridDrawState);
var
  pData: AStr;
  pBitmap: TBitmap;
begin
  with TDbGrid(Sender) do
    if assigned(DataSource) and not DataSource.DataSet.IsEmpty and assigned(Column.Field) then
    begin
      if Column.Index = 0 then
      begin
        Canvas.FillRect(Rect);
        pData := AnsiUpperCase(Column.Field.AsString);
        if pData = 'B' then
          pData := estbk_strmsg.SCPLangBillName
        else
        if pData = 'O' then
          pData := estbk_strmsg.SCPLangOrderName;
        Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, pData);
      end
      else
      if Column.Index = CChkColItem then
        try

          if (gdSelected in State) then
          begin
            Brush.Color := clBackGround;
            Font.Color := clWhite;
          end
          else
          begin
            Canvas.Brush.Color := clWindow; // MyFavGreen; //clInfoBk; //;
            Font.Color := clBlack;
          end;

          pBitmap := TBitmap.Create;
          Canvas.FillRect(Rect);
          if AnsiUpperCase(copy(qryClientUpItems.FieldByName('itemchk').AsString, 1, 1)) = 'T' then
            gridImg.GetBitmap(1, pBitmap)
          else
            gridImg.GetBitmap(0, pBitmap);
          Canvas.Draw(Rect.Left + 5, Rect.Top + 2, pBitmap);


        finally
          FreeAndNil(pBitmap);
        end
      else
      if Column.Index = 0 then
        DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
end;

procedure TformCustUnpaiditems.dbGridupItemsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) then
  begin
    if not qryClientUpItems.EOF then
      self.ModalResult := mrOk;
    key := 0;
  end
  else
  if (key = VK_SPACE) and assigned(dbGridupItems.SelectedColumn) and (dbGridupItems.SelectedColumn.Index = CChkColItem) then
  begin
    self.doItemSelect();
    key := 0;
  end;
end;

procedure TformCustUnpaiditems.dbGridupItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  //  TDbGrid(Sender).MouseToCell(x,y,Acol,ARow);
  //         TDbGrid(Sender).mo
  //  if (ACol>0) and (ARow>0) then
  //  TDbGrid(Sender).SelectedRows.CurrentRowSelected:=true;
  //   memo1.lines.add(format('%d %d',[ACol,ARow]));
end;


procedure TformCustUnpaiditems.doItemSelect(const pSwitchVal: boolean = False);
var
  pBStatus: boolean;
  pBookmark: TBookmark;
  pCurrrecNr: integer;
  pCrSession: boolean;
begin

  // teised valikud tühistame !
  //if Column.Index=CChkColItem then
  if assigned(dbGridupItems.SelectedColumn) and (dbGridupItems.SelectedColumn.Index = CChkColItem) then
    try
      qryClientUpItems.DisableControls;
      pBookmark := qryClientUpItems.GetBookmark;

      pCurrrecNr := qryClientUpItems.RecNo;

      pBStatus := not (AnsiUpperCase(copy(qryClientUpItems.FieldByName('itemchk').AsString, 1, 1)) = 'T');
      //        if pSwitchVal then
      //           pBStatus:=not pBStatus;


      pCurrrecNr := qryClientUpItems.RecNo;
      pCrSession := not (qryClientUpItems.State in [dsEdit, dsInsert]);
      if pCrSession then
        qryClientUpItems.Edit;
      // ---
      qryClientUpItems.FieldByName('itemchk').AsString := estbk_types.SCFalseTrue[pBStatus];

      if pCrSession then
        qryClientUpItems.Post;

      qryClientUpItems.First;
      while not qryClientUpItems.EOF do
      begin

        if qryClientUpItems.RecNo <> pCurrrecNr then
          try
            qryClientUpItems.Edit;
            qryClientUpItems.FieldByName('itemchk').AsString := estbk_types.SCFalseTrue[False];
          finally
            qryClientUpItems.Post;
          end;

        // --
        qryClientUpItems.Next;
      end;




    finally

      qryClientUpItems.GotoBookmark(pBookmark);
      qryClientUpItems.FreeBookmark(pBookmark);
      qryClientUpItems.EnableControls;

      //dbGridupItems.Repaint;
    end;

end;

procedure TformCustUnpaiditems.dbGridupItemsCellClick(Column: TColumn);
begin
  if (Column.Index = CChkColItem) then
  begin
    self.doItemSelect;
  end;
end;

procedure TformCustUnpaiditems.btnConfirmClick(Sender: TObject);
begin
  try
    qryClientUpItems.DisableControls;
    qryClientUpItems.Filtered := False;
    qryClientUpItems.Filtered := True;
    if not qryClientUpItems.EOF then
      self.ModalResult := mrOk
    else
    begin
      qryClientUpItems.Filtered := False;
      Dialogs.messageDlg(estbk_strmsg.SCPleaseSelectItem, mtInformation, [mbOK], 0);
    end;
  finally
    qryClientUpItems.EnableControls;
  end;
end;

procedure TformCustUnpaiditems.dbGridupItemsColEnter(Sender: TObject);
begin
  //if  (dbGridupItems.SelectedColumn.Index=CChkColItem)  and not (qryClientUpItems.State in [dsEdit,dsInsert]) then
  //     qryClientUpItems.Edit;
end;

procedure TformCustUnpaiditems.dbGridupItemsDblClick(Sender: TObject);
begin
  if not qryClientUpItems.EOF then
    self.ModalResult := mrOk;
end;

function TformCustUnpaiditems.ShowModal(const pClientId: integer; var pItemId: integer; var pItemIsBill: boolean): boolean;


var
  pUserDat: Astr;
  pPhoneDat: Astr;
begin
  // küsime uuesti kliendi andmed info jaoks !
  Result := False;

  qryTempQry.Close;
  qryTempQry.SQL.Clear;
  qryTempQry.SQL.add(estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id, pClientId));
  qryTempQry.Open;

  if not qryTempQry.EOF then
  begin
    pUserDat := trim(qryTempQry.FieldByName('custname').AsString + ' ' + qryTempQry.FieldByName('lastname').AsString);

    if qryTempQry.FieldByName('regnr').AsString <> '' then
      pUserDat := pUserDat + ' / ' + qryTempQry.FieldByName('regnr').AsString;

    pPhoneDat := trim(qryTempQry.FieldByName('phone').AsString);
    if pPhoneDat <> '' then
      pPhoneDat := pPhoneDat + ';';
    pPhoneDat := pPhoneDat + trim(qryTempQry.FieldByName('mobilephone').AsString);

    if trim(pPhoneDat) <> '' then
      pUserDat := pUserDat + ' ' + estbk_strmsg.SCPhone + pPhoneDat;
    lblCustName.Caption := ' ' + pUserDat;

    qryTempQry.Close;
    qryTempQry.SQL.Clear;


    // kliendi tasumata arved !
    qryClientUpItems.Close;
    qryClientUpItems.SQL.Clear;
    qryClientUpItems.SQL.add(estbk_sqlclientcollection._SQLGetCustomerUnpaidItems(pClientId, estbk_globvars.glob_company_id));
    qryClientUpItems.Open;


    pItemId := 0;
    pItemIsBill := True;
    Result := inherited showmodal = mrOk;

    if Result then
    begin
      pItemId := qryClientUpItems.FieldByName('itemid').AsInteger;
      pItemIsBill := qryClientUpItems.FieldByName('ptype').AsString = 'B';
    end;
    // ---
  end;
end;

initialization
  {$I estbk_frm_custunpaiditems.ctrs}

end.
