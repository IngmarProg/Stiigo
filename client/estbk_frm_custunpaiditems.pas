unit estbk_frm_custunpaiditems;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DBGrids,estbk_types,estbk_clientdatamodule,estbk_sqlclientcollection,
  estbk_globvars, db, ZDataset,LCLType, Grids, Buttons;

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
    procedure dbGridupItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbGridupItemsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbGridupItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure qryClientUpItemsFilterRecord(DataSet: TDataSet; var Accept: Boolean);

  private
    procedure doItemSelect(const pSwitchVal : Boolean = false);
  public
    function  showModal(const pClientId   : Integer;
                        var   pItemId     : Integer;
                        var   pItemIsBill : Boolean):boolean;reintroduce;

  end; 

var
  formCustUnpaiditems: TformCustUnpaiditems;

implementation
uses estbk_uivisualinit,estbk_strmsg;
const
  CChkColItem = 7;

procedure TformCustUnpaiditems.FormCreate(Sender: TObject);
begin
   // -------
   estbk_uivisualinit.__preparevisual(self);


   dbGridupItems.Columns.items[CChkColItem].ValueChecked  :=estbk_types.SCFalseTrue[True];
   dbGridupItems.Columns.items[CChkColItem].ValueUnChecked:=estbk_types.SCFalseTrue[False]; // valik
end;

procedure TformCustUnpaiditems.qryClientUpItemsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
   Accept:=copy(ansiuppercase(DataSet.fieldbyname('itemchk').asstring),1,1)=copy(ansiuppercase(estbk_types.SCFalseTrue[true]),1,1);
end;



procedure TformCustUnpaiditems.dbGridupItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  pData   : AStr;
  pBitmap : TBitmap;
begin
  with TDbGrid(Sender) do
  if assigned(DataSource) and not DataSource.DataSet.IsEmpty and assigned(Column.Field) then
    begin
    if Column.Index=0 then
      begin
         Canvas.FillRect(Rect);
         pData:=ansiuppercase(Column.Field.AsString);
      if pData='B' then
         pData:=estbk_strmsg.SCPLangBillName
      else
      if pData='O' then
        pData:=estbk_strmsg. SCPLangOrderName;
        Canvas.TextOut(Rect.Left+2,Rect.Top+2,pData);
      end else
      if Column.Index=CChkColItem then
      try

       if (gdSelected in  State) then
        begin
          Brush.Color := clBackGround;
          Font.Color  := clWhite;
        end else
        begin
          Canvas.Brush.Color := clWindow; // MyFavGreen; //clInfoBk; //;
          Font.Color := clBlack;
        end;

          pBitmap:=TBitmap.Create;
          Canvas.FillRect(Rect);
       if ansiuppercase(copy(qryClientUpItems.fieldbyname('itemchk').asstring,1,1))='T' then
          gridImg.GetBitmap(1, pBitmap)
       else
          gridImg.GetBitmap(0, pBitmap);
          Canvas.Draw(Rect.Left+5,Rect.Top+2,pBitmap);


      finally
          freeAndNil(pBitmap);
      end else
      if  Column.Index=0 then
          DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
end;

procedure TformCustUnpaiditems.dbGridupItemsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key=VK_RETURN) then
   begin
    if not qryClientUpItems.EOF then
       self.ModalResult:=mrok;
       key:=0;
   end else
  if (key=VK_SPACE)and assigned(dbGridupItems.SelectedColumn) and (dbGridupItems.SelectedColumn.Index=CChkColItem) then
   begin
       self.doItemSelect();
       key:=0;
   end;
end;

procedure TformCustUnpaiditems.dbGridupItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  TDbGrid(Sender).MouseToCell(x,y,Acol,ARow);
//         TDbGrid(Sender).mo
//  if (ACol>0) and (ARow>0) then
//  TDbGrid(Sender).SelectedRows.CurrentRowSelected:=true;
//   memo1.lines.add(format('%d %d',[ACol,ARow]));
end;


procedure TformCustUnpaiditems.doItemSelect(const pSwitchVal : Boolean = false);
var
  pBStatus   : Boolean;
  pBookmark  : TBookmark;
  pCurrrecNr : Integer;
  pCrSession : Boolean;
begin

  // teised valikud tühistame !
  //if Column.Index=CChkColItem then
  if assigned(dbGridupItems.SelectedColumn) and (dbGridupItems.SelectedColumn.Index=CChkColItem) then
    try
           qryClientUpItems.DisableControls;
           pBookmark:=qryClientUpItems.GetBookmark;

           pCurrrecNr:=qryClientUpItems.RecNo;

           pBStatus:=not (ansiuppercase(copy(qryClientUpItems.fieldbyname('itemchk').asstring,1,1))='T');
//        if pSwitchVal then
//           pBStatus:=not pBStatus;


           pCurrrecNr:=qryClientUpItems.RecNo;
           pCrSession:=not (qryClientUpItems.State in [dsEdit,dsInsert]);
        if pCrSession then
           qryClientUpItems.Edit;
           // ---
           qryClientUpItems.fieldbyname('itemchk').asstring:=estbk_types.SCFalseTrue[ pBStatus];

        if pCrSession then
           qryClientUpItems.Post;

           qryClientUpItems.First;
    while  not qryClientUpItems.EOF do
       begin



       if  qryClientUpItems.RecNo<>pCurrrecNr then
          try
            qryClientUpItems.Edit;
            qryClientUpItems.fieldbyname('itemchk').asstring:=estbk_types.SCFalseTrue[false];
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
   if (Column.Index=CChkColItem) then
    begin
        self.doItemSelect;
    end;
end;

procedure TformCustUnpaiditems.btnConfirmClick(Sender: TObject);
begin
 try
    qryClientUpItems.DisableControls;
    qryClientUpItems.Filtered:=false;
    qryClientUpItems.Filtered:=true;
 if not qryClientUpItems.eof then
    self.ModalResult:=mrOk
 else
  begin
    qryClientUpItems.Filtered:=false;
    dialogs.messageDlg(estbk_strmsg.SCPleaseSelectItem,mtInformation,[mbOk],0);
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
     self.ModalResult:=mrok;
end;

function TformCustUnpaiditems.ShowModal(const pClientId : Integer;
                                        var pItemId     : Integer;
                                        var pItemIsBill : Boolean):boolean;
var
    pUserDat  : Astr;
    pPhoneDat : Astr;
begin
   // küsime uuesti kliendi andmed info jaoks !
    result:=false;

    qryTempQry.close;
    qryTempQry.SQL.clear;
    qryTempQry.SQL.add(estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id,pClientId));
    qryTempQry.open;

if  not qryTempQry.eof then
  begin
      pUserDat:=trim(qryTempQry.fieldbyname('custname').asString+' '+
                     qryTempQry.fieldbyname('lastname').asString);

  if  qryTempQry.fieldbyname('regnr').asString<>'' then
      pUserDat:=pUserDat+' / '+qryTempQry.fieldbyname('regnr').asString;

      pPhoneDat:=trim(qryTempQry.fieldbyname('phone').asString);
  if  pPhoneDat<>'' then
      pPhoneDat:= pPhoneDat+';';
      pPhoneDat:=pPhoneDat+trim(qryTempQry.fieldbyname('mobilephone').asString);

  if  trim(pPhoneDat)<>'' then
      pUserDat:=pUserDat+' '+estbk_strmsg.SCPhone+pPhoneDat;
      lblCustName.Caption:=' '+pUserDat;

      qryTempQry.Close;
      qryTempQry.SQL.Clear;


      // kliendi tasumata arved !
      qryClientUpItems.close;
      qryClientUpItems.SQL.clear;
      qryClientUpItems.SQL.add(estbk_sqlclientcollection._SQLGetCustomerUnpaidItems(pClientId,estbk_globvars.glob_company_id));
      qryClientUpItems.Open;


      pItemId:=0;
      pItemIsBill:=true;
      result:=inherited showmodal=mrOk;

  if result then
    begin
      pItemId:=qryClientUpItems.fieldByname('itemid').asInteger;
      pItemIsBill:=qryClientUpItems.fieldByname('ptype').asString='B';
    end;
    // ---
  end;
end;

initialization
  {$I estbk_frm_custunpaiditems.ctrs}

end.

