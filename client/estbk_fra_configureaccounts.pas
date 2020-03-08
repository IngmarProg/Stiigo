unit estbk_fra_configureaccounts;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, LCLProc, LCLType, StdCtrls, ExtCtrls, DBGrids, ComCtrls, DBCtrls,
  EditBtn, Grids, estbk_fra_template,
  estbk_clientdatamodule, estbk_sqlclientcollection, estbk_globvars, estbk_utilities, estbk_uivisualinit, Graphics,
  estbk_types, estbk_strmsg, estbk_lib_commonevents, estbk_lib_commonaccprop,
  DB, ZDataset, ZSqlUpdate, ZSequence, ZAbstractDataset, rxdbgrid, rxlookup, rxpopupunit, Controls, Buttons;

type

  { TframeConfAccounts }

  TframeConfAccounts = class(Tfra_template)
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnSave: TBitBtn;
    qryAccountListDs: TDatasource;
    grpBoxDefAccounts: TGroupBox;
    pGridDefAccounts: TStringGrid;
    qryAccountList: TZReadOnlyQuery;
    qryWorker: TZQuery;
    qryWorkerSeq: TZSequence;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure pGridDefAccountsClick(Sender: TObject);
    procedure pGridDefAccountsDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure pGridDefAccountsPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
    procedure pGridDefAccountsSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure qryAccountListFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    // ---
  protected
    FSkipOnChangeEvent: boolean;

    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;

    FAccounts: TRxDBLookupCombo;
    procedure OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure OnLookupComboEnter(Sender: TObject);
    procedure OnLookupComboExit(Sender: TObject);
    procedure OnLookupComboSelect(Sender: TObject);
    procedure OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);

    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);

    procedure clearObjItems(const pCleanOnlyCellStrVal: boolean = False);

  public
    procedure refreshAccounts;
    // ----------------
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;

    //public
    // RTTI teema
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

uses Dialogs;

type
  // hoiame ka kirje juures originaal definitsiooni
  TCDefAccountTypeId = class
    FPType: TSystemAccType;
    FPRecId: integer; // andmebaasis kehtiva kirje ID
    FPOrigAccId: integer;
    FPAccId: integer;
  end;




const
  CLeftHiddenCorn = -200;

const
  // --
  CCol_sysDescr = 1;
  CCol_accDefCol = 2;

procedure TframeConfAccounts.refreshAccounts;
begin
  qryAccountList.Active := False;
  qryAccountList.Active := True;
end;

function TframeConfAccounts.getDataLoadStatus: boolean;
begin
  Result := qryAccountList.Active;
end;


procedure TframeConfAccounts.setDataLoadStatus(const v: boolean);
var
  pOrd: byte;
  pDefCls: TCDefAccountTypeId;
begin
  qryAccountList.Close;
  qryAccountList.SQL.Clear;


  qryWorker.Close;
  qryWorker.SQL.Clear;



  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  self.clearObjItems(True);

  if v then
  begin
    qryAccountList.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryWorker.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryWorkerSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;
    //qryDefSysAccounts.Connection :=estbk_clientdatamodule.dmodule.primConnection;

    qryAccountList.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts());
    qryAccountList.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryAccountList.Open;

    qryWorker.SQL.Add(estbk_sqlclientcollection._SQLSelectSysAccounts);
    qryWorker.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryWorker.Open;

    qryAccountList.Filtered := False;
    qryAccountList.Filtered := True;

    qryWorker.First;
    while not qryWorker.EOF do
    begin
      pOrd := byte(qryWorker.FieldByName('ordinal_nr').AsInteger);
      if (pOrd >= byte(low(TSystemAccType))) and (pOrd <= byte(high(TSystemAccType))) then
      begin
        pDefCls := TCDefAccountTypeId(pGridDefAccounts.Objects[CCol_accDefCol, pOrd + 1]);

        pDefCls.FPType := TSystemAccType(pOrd);
        pDefCls.FPRecId := qryWorker.FieldByName('id').AsInteger;
        pDefCls.FPAccId := qryWorker.FieldByName('account_id').AsInteger;
        pDefCls.FPOrigAccId := qryWorker.FieldByName('account_id').AsInteger;


        // ---
        pGridDefAccounts.Cells[CCol_accDefCol, pOrd + 1] := qryWorker.FieldByName('account_coding').AsString;
      end;
      // ---
      qryWorker.Next;
    end;

  end
  else
  begin
    qryAccountList.Connection := nil;
    qryWorker.Connection := nil;
    qryWorkerSeq.Connection := nil;
    //qryDefSysAccounts.Connection :=nil;
  end;
end;

procedure TframeConfAccounts.pGridDefAccountsDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin
  if aCol = CCol_accDefCol then
  begin
    if (gdFocused in aState) then
    begin
      FAccounts.Left := (aRect.Left + TStringGrid(Sender).Left) - 7; // -10
      FAccounts.Top := aRect.Top;
      FAccounts.Width := (aRect.Right - aRect.Left) - 1;
      FAccounts.Height := (aRect.Bottom - aRect.Top) - 6;
    end;
  end
  else
    TStringGrid(Sender).DefaultDrawCell(aCol, aRow, aRect, aState);
end;

procedure TframeConfAccounts.btnSaveClick(Sender: TObject);
var
  i: TSystemAccType;
  pObjCls: TCDefAccountTypeId;
  pAddNewRec: boolean;
begin

  with estbk_clientdatamodule.dmodule do
    try
      primConnection.StartTransaction;
      for  i := low(TSystemAccType) to high(TSystemAccType) do
      begin
        pObjCls := TCDefAccountTypeId(pGridDefAccounts.Objects[CCol_accDefCol, Ord(i) + 1]);
        if assigned(pObjCls) and (pGridDefAccounts.Cells[CCol_accDefCol, Ord(i) + 1] <> '') then
          with qryWorker, SQL do
            try
              Close;
              Clear;
              // ---
              pAddNewRec := (pObjCls.FPRecId < 1) or (pObjCls.FPAccId <> pObjCls.FPOrigAccId);


              if pAddNewRec then
              begin
                // järelikult muudeti kontot !!!
                // vana kirje märgime kehtetuks
                if (pObjCls.FPRecId > 0) then
                begin
                  add(estbk_sqlclientcollection._SQLUpdateSysAccount2);
                  paramByname('ends').AsDateTime := now - 1;
                  paramByname('rec_changed').AsDateTime := now;
                  paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
                  paramByname('id').AsInteger := pObjCls.FPRecId;
                  execSQL;
                end;


                // ----
                Close;
                Clear;
                add(estbk_sqlclientcollection._SQLInsertSysAccount);
                paramByname('id').AsInteger := qryWorkerSeq.GetNextValue;
                paramByname('ordinal_nr').AsInteger := Ord(i);
                paramByname('sys_descr').AsString := TSystemAccNames[i]; // parem eristada andmebaasis !
                paramByname('account_id').AsInteger := pObjCls.FPAccId;
                paramByname('starts').AsDateTime := now;
                paramByname('ends').Value := null;
                paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
                paramByname('rec_changed').AsDateTime := now;
                paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
                paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
                execSQL;

                // ---
                _ac.sysAccountId[i] := pObjCls.FPAccId;
              end;

            finally
              Close;
              Clear;
            end;
        // ---
      end;

      // ---
      primConnection.Commit;



      self.FAccounts.Visible := False;
      btnSave.Enabled := False;
      btnCancel.Enabled := False;


      // 20.08.2010 Ingmar; laeme siiski info uuesti !
      _ac.loadDefaultSysAccounts(estbk_clientdatamodule.dmodule.tempQuery);


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
    end;
end;

procedure TframeConfAccounts.pGridDefAccountsClick(Sender: TObject);
begin
  // 22.07.2011 Ingmar; bugreport 0000009
  try
    if self.FAccounts.PopupVisible then
      self.FAccounts.PopupVisible := False;

  except
  end;
end;

procedure TframeConfAccounts.btnCancelClick(Sender: TObject);
begin
  self.loadData := False;
  self.loadData := True;
  self.FAccounts.Visible := False;
end;

procedure TframeConfAccounts.btnCloseClick(Sender: TObject);
begin
  if assigned(onFrameKillSignal) then
    onFrameKillSignal(self);
end;

procedure TframeConfAccounts.pGridDefAccountsPrepareCanvas(Sender: TObject; aCol, aRow: integer; aState: TGridDrawState);
begin
  // ---
  with TStringGrid(Sender).Canvas.Brush do
    if (aRow > 0) and (aCol > 0) then
    begin
      //Font.Color:=clWindow;
      if (aCol = CCol_sysDescr) then
        Color := clInfoBk
      else
        // if not (gdSelected in aState)  then
        Color := clWindow;
    end;
end;

procedure TframeConfAccounts.pGridDefAccountsSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
begin
  // ---
  if not (csDesigning in self.ComponentState) and (aCol = CCol_accDefCol) then
    try

      if self.FAccounts.PopupVisible then
        try
          self.FAccounts.PopupVisible := False;
        except
        end;

      // ---
      Editor := self.FAccounts;

      FAccounts.Visible := True;
      FAccounts.Enabled := True;


      if FAccounts.CanFocus then
        FAccounts.SetFocus;

    except
    end;
end;

procedure TframeConfAccounts.qryAccountListFilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  b: boolean;
begin
  b := not ((DataSet.FieldByName('flags').AsInteger and estbk_types.CAccFlagsClosed) = estbk_types.CAccFlagsClosed);
  b := b and (AnsiUpperCase(DataSet.FieldByName('default_currency').AsString) = AnsiUpperCase(estbk_globvars.glob_baseCurrency));
  Accept := b;
end;

procedure TframeConfAccounts.OnLookupComboKeydown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if not TRxDBLookupCombo(Sender).PopupVisible then
    case key of
      VK_UP:
      begin
        if pGridDefAccounts.Row > 1 then
          pGridDefAccounts.Row := pGridDefAccounts.Row - 1;
        // ---
        key := 0;
      end;

      VK_DOWN:
      begin
        if pGridDefAccounts.Row < pGridDefAccounts.RowCount then
          pGridDefAccounts.Row := pGridDefAccounts.Row + 1;
        // ---
        key := 0;
      end;
    end;
end;

procedure TframeConfAccounts.OnLookupComboEnter(Sender: TObject);
var
  psrcOk: boolean;
  pAccId: integer;
begin
  if not self.FSkipOnChangeEvent then
    with pGridDefAccounts do
      try
        self.FSkipOnChangeEvent := True;
        psrcOk := False;
        TRxDBLookupCombo(Sender).Text := '';

        if assigned(Objects[CCol_accDefCol, Row]) then
        begin
          pAccId := TCDefAccountTypeId(Objects[CCol_accDefCol, row]).FPAccId;
          psrcOk := qryAccountList.locate('id', pAccId, []);
          if psrcOk then
          begin

            Cells[col, row] := qryAccountList.FieldByName('account_coding').AsString;
            TCDefAccountTypeId(Objects[CCol_accDefCol, row]).FPAccId := pAccId;

            TRxDBLookupCombo(Sender).Value := IntToStr(pAccId);
            TRxDBLookupCombo(Sender).Text := qryAccountList.FieldByName('account_coding').AsString;
            TRxDBLookupCombo(Sender).Hint := qryAccountList.FieldByName('account_name').AsString;

          end; // --
        end;
        // --
        if not psrcOk then
        begin

          Cells[CCol_accDefCol, row] := '';
          // --
          TRxDBLookupCombo(Sender).Value := '';
          TRxDBLookupCombo(Sender).Text := '';
          TRxDBLookupCombo(Sender).Hint := '';
          qryAccountList.First;
        end;
        // ---
      finally
        self.FSkipOnChangeEvent := False;
      end;
end;

procedure TframeConfAccounts.OnLookupComboExit(Sender: TObject);
begin
  // ---
end;

procedure TframeConfAccounts.OnLookupComboSelect(Sender: TObject);
begin
  with TRxDBLookupCombo(Sender) do
    try
      if assigned(LookupSource.DataSet) and not self.FSkipOnChangeEvent then
        try
          self.FSkipOnChangeEvent := True;
          // ----
          Text := LookupSource.DataSet.FieldByName('account_coding').AsString;


          pGridDefAccounts.Cells[CCol_accDefCol, pGridDefAccounts.Row] := Text;
          TCDefAccountTypeId(pGridDefAccounts.Objects[CCol_accDefCol, pGridDefAccounts.row]).FPAccId :=
            LookupSource.DataSet.FieldByName('id').AsInteger;

          btnSave.Enabled := True;
          btnCancel.Enabled := True;

        finally
          self.FSkipOnChangeEvent := False;
        end;

    except
    end;
end;

procedure TframeConfAccounts.OnLookupComboPopupClose(Sender: TObject; SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

constructor TframeConfAccounts.Create(frameOwner: TComponent);
var
  pCollItem: TCollectionItem;
  i: TSystemAccType;
begin
  // -------
  inherited Create(frameOwner);
  // -------
  estbk_uivisualinit.__preparevisual(self);



  FAccounts := TRxDBLookupCombo.Create(self.pGridDefAccounts);
  FAccounts.parent := self.pGridDefAccounts;
  FAccounts.Visible := False;

  FAccounts.ParentFont := False;
  FAccounts.ParentColor := False;
  FAccounts.ShowHint := True;
  FAccounts.DoubleBuffered := True;



  FAccounts.LookupSource := self.qryAccountListDs;
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


  FAccounts.OnEnter := @self.OnLookupComboEnter;
  FAccounts.OnExit := @self.OnLookupComboExit;
  FAccounts.OnSelect := @self.OnLookupComboSelect;
  FAccounts.OnClosePopupNotif:=@self.OnLookupComboPopupClose;
  FAccounts.OnKeyDown := @self.OnLookupComboKeydown;




  //FAccounts.OnChange:=@self.OnLookupComboSelect;
  //FAccounts.OnClick:=@self.OnLookupComboSelect;

  FAccounts.Left := CLeftHiddenCorn;
  FAccounts.Flat := True;
  FAccounts.EmptyValue := #32;
  FAccounts.UnfindedValue := rxufNone;
  FAccounts.DropDownCount := 15;
  FAccounts.DropDownWidth := 385;

  FAccounts.ButtonWidth := 15;
  FAccounts.ButtonOnlyWhenFocused := False;
  FAccounts.Height := 23;
  FAccounts.PopUpFormOptions.ShowTitles := True;
  FAccounts.PopUpFormOptions.TitleButtons := True;

  pGridDefAccounts.RowCount := Ord(high(TSystemAccType)) + 2;

  for i := low(TSystemAccType) to high(TSystemAccType) do
  begin
    pGridDefAccounts.Cells[CCol_sysDescr, Ord(i) + 1] := ' ' + estbk_types.TSystemAccNames[i];
    // --
    pGridDefAccounts.Objects[CCol_accDefCol, Ord(i) + 1] := TCDefAccountTypeId.Create;
    TCDefAccountTypeId(pGridDefAccounts.Objects[CCol_accDefCol, Ord(i) + 1]).FPType := i;
  end;

  // 29.05.2011 Ingmar
  FAccounts.OnLookupTitleColClick:=@__intUIMiscHelperClass.OnLookupComboTitleClick;
end;

procedure TframeConfAccounts.clearObjItems(const pCleanOnlyCellStrVal: boolean = False);
var
  i: TSystemAccType;
begin
  self.FSkipOnChangeEvent := True;

  for i := low(TSystemAccType) to high(TSystemAccType) do
  begin

    if not pCleanOnlyCellStrVal and assigned(pGridDefAccounts.Objects[CCol_accDefCol, Ord(i) + 1]) then
    begin
      pGridDefAccounts.Objects[CCol_accDefCol, Ord(i) + 1].Free;
      pGridDefAccounts.Objects[CCol_accDefCol, Ord(i) + 1] := nil;
    end;
    pGridDefAccounts.Cells[CCol_accDefCol, Ord(i) + 1] := '';
  end;

  // ---
  self.FSkipOnChangeEvent := False;
end;

destructor TframeConfAccounts.Destroy;
begin
  self.clearObjItems;
  inherited Destroy;
end;

initialization
  {$I estbk_fra_configureaccounts.ctrs}


end.