unit estbk_fra_banks;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, ComCtrls, StdCtrls, DBCtrls, EditBtn, ExtCtrls, DBGrids, Buttons,
  Dialogs, estbk_fra_template, estbk_uivisualinit, estbk_clientdatamodule, estbk_sqlclientcollection, LCLType,
  estbk_globvars, estbk_utilities, estbk_types, estbk_lib_commonevents,
  estbk_strmsg, ZDataset, ZSequence, ZSqlUpdate, rxlookup, DB, Controls;
// http://www.pangaliit.ee/arveldused/IBAN/
type

  { TframeBanks }

  TframeBanks = class(Tfra_template)
    banks: TDBGrid;
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnNewBank: TBitBtn;
    btnSave: TBitBtn;
    cmbArtType: TComboBox;
    cmbBarCodeTypes: TComboBox;
    cmbCostAcc: TRxDBLookupCombo;
    cmbPurcAcc: TRxDBLookupCombo;
    cmbSaleAcc: TRxDBLookupCombo;
    cmbUnit: TDBComboBox;
    cmbVatLookup: TDBLookupComboBox;
    dbEdtBankName: TDBEdit;
    dbEdtBanlSwiftc: TDBEdit;
    dbEdtLocalCode: TDBEdit;
    lblBankName: TLabel;
    lblBankSwift: TLabel;
    lblBankSwift1: TLabel;
    leftPanel: TPanel;
    rightPanel: TPanel;
    pMainPanel: TPanel;
    qryBankDs: TDatasource;
    DBEdit4: TDBEdit;
    dbEdtDiscountPerc: TDBEdit;
    dbEdtProdCode: TDBEdit;
    dbEdtProdName: TDBEdit;
    dbObjGrid: TDBGrid;
    edtPurcPrice: TCalcEdit;
    edtSalePrice: TCalcEdit;
    edtSrc: TEdit;
    grpBoxBanks: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    lbBarCode: TLabel;
    lbCostAcc: TLabel;
    lblArtType: TLabel;
    lblDescr: TLabel;
    lblDiscountPerc: TLabel;
    lbllpurchaseprice: TLabel;
    lblname: TLabel;
    lblProdcode: TLabel;
    lblPurcAcc: TLabel;
    lblSaleAcc: TLabel;
    lblSalePrice: TLabel;
    lblUnit: TLabel;
    lblVat: TLabel;
    memProdDesc: TDBMemo;
    pageArtMainData: TTabSheet;
    pageCtrlArt: TPageControl;
    pageExtInfo: TTabSheet;
    panelLeft: TPanel;
    panelLeftInnerSrc: TPanel;
    panelRight: TPanel;
    Splitter1: TSplitter;
    qryBank: TZQuery;
    qryBankSeq: TZSequence;
    qryBankupdate: TZUpdateSQL;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewBankClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure chkboxCanUseInBillsChange(Sender: TObject);
    procedure dbEdtBankNameKeyPress(Sender: TObject; var Key: char);
    procedure qryAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryBankAfterCancel(DataSet: TDataSet);
    procedure qryBankAfterInsert(DataSet: TDataSet);
    procedure qryBankAfterScroll(DataSet: TDataSet);
    procedure qryBankBeforeEdit(DataSet: TDataSet);
    procedure qryBankBeforePost(DataSet: TDataSet);
    procedure qryBankBeforeScroll(DataSet: TDataSet);
    procedure rpAccountsChange(Sender: TObject);
    procedure rpAccountsClosePopupNotif(Sender: TObject);
    procedure rpAccountsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure rpAccountsSelect(Sender: TObject);
  private
    FDataNotSaved: boolean;
    FSkipDbEvents: boolean;
    FNewRecordCreated: boolean;
    // ---
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
  public
    // ---
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
    // RTTI teema
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation




procedure TframeBanks.qryBankBeforePost(DataSet: TDataSet);
begin
  with DataSet do
  begin
    self.qryBankBeforeScroll(DataSet);
    // ---
    if FNewRecordCreated then
    begin
      FieldByName('company_id').AsInteger := estbk_globvars.glob_company_id;
      FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
    end;

    FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
    FieldByName('rec_changed').AsDateTime := now;
  end;
end;

procedure TframeBanks.qryBankBeforeScroll(DataSet: TDataSet);
begin

  with DataSet do
    if not isEmpty and not self.FSkipDbEvents then
      try

        if trim(FieldByName('bankname').AsString) = '' then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEBankMissingName, mtError, [mbOK], 0);
          if dbEdtBankName.canfocus then
            dbEdtBankName.SetFocus;
          abort;
        end;

     {
    if trim(fieldByname('account_nr').asString)='' then
      begin
         dialogs.messageDlg(estbk_strmsg.SEBankMissingAccountNr,mtError,[mbOk],0);
      if dbEdtBankAccount.canFocus then
         dbEdtBankAccount.setFocus;
         abort;
      end;

    if  fieldByname('bk_account_id').asInteger<1 then
      begin
         dialogs.messageDlg(estbk_strmsg.SEBankMissingBkAccount,mtError,[mbOk],0);
      if rpAccounts.canFocus then
         rpAccounts.setFocus;
         abort;
      end;   }
        // ----
      except
        on e: Exception do
          ShowMessage(e.Message);
      end;
end;

procedure TframeBanks.rpAccountsChange(Sender: TObject);
begin

end;

procedure TframeBanks.rpAccountsClosePopupNotif(Sender: TObject);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeBanks.rpAccountsKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Shift = [] then
    case key of
      VK_DELETE:
      begin
        TRxDBLookupCombo(Sender).Value := '';
        key := 0;
      end;
    end;
end;

procedure TframeBanks.rpAccountsSelect(Sender: TObject);
begin
  with  TRxDBLookupCombo(Sender) do
    if (Value <> '') then
    begin
      LookupSource.DataSet.Locate('id', Value, []);
      Text := LookupSource.DataSet.FieldByName('account_coding').AsString;
    end;
end;

procedure TframeBanks.qryBankAfterInsert(DataSet: TDataSet);
begin
  self.FDataNotSaved := True;
  self.FNewRecordCreated := True;
  //chkboxCanUseInBills.Checked:=true;
  //qryBank.fieldByname('active').asString:=estbk_types.SCFalseTrue[true];
end;

procedure TframeBanks.qryBankAfterScroll(DataSet: TDataSet);
begin
  //if not dataSet.isEmpty and not self.FNewRecordCreated then
  //   chkboxCanUseInBills.Checked:=isTrueVal(Dataset.fieldByname('active').asString);
end;

procedure TframeBanks.qryBankBeforeEdit(DataSet: TDataSet);
begin
  btnNewBank.Enabled := False;
  btnCancel.Enabled := True;
  btnSave.Enabled := True;
  self.FDataNotSaved := True;
end;

procedure TframeBanks.btnSaveClick(Sender: TObject);
begin

  with estbk_clientdatamodule.dmodule do
    try
      // 05.03.2010 Ingmar
      self.qryBankBeforeScroll(qryBank);

      primConnection.StartTransaction;
      qryBank.ApplyUpdates;

      primConnection.Commit;
      qryBank.CommitUpdates;

      self.FDataNotSaved := False;
      self.FNewRecordCreated := False;

      btnSave.Enabled := False;
      btnCancel.Enabled := False;
      btnNewBank.Enabled := True;

      if btnNewBank.canFocus then
        btnNewBank.SetFocus;


      if assigned(FFrameDataEvent) then
        FFrameDataEvent(self, __frameBankDataChanged, -1);

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
      end;
    end;

end;

procedure TframeBanks.chkboxCanUseInBillsChange(Sender: TObject);
var
  pNewPostSq: boolean;
begin
  if TCheckbox(Sender).Focused then
  begin
    pNewPostSq := not (qryBank.State in [dsEdit, dsInsert]);
    if pNewPostSq then
      qryBank.Edit;

    qryBank.FieldByName('active').AsString := estbk_types.SCFalseTrue[TCheckbox(Sender).Checked];

    // ---
    if pNewPostSq then
      qryBank.Post;

  end;
end;

procedure TframeBanks.dbEdtBankNameKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeBanks.qryAccountsFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  //  Accept:=(DataSet.FieldByname('flags').asInteger and estbk_types.CAccFlagsClosed)<>estbk_types.CAccFlagsClosed;
end;

procedure TframeBanks.qryBankAfterCancel(DataSet: TDataSet);
begin
  // --
end;

procedure TframeBanks.btnCancelClick(Sender: TObject);
begin
  //qryBank.Cancel;
  qryBank.CancelUpdates;

  TBitBtn(Sender).Enabled := False;
  btnSave.Enabled := False;
  btnNewBank.Enabled := True;
  btnNewBank.SetFocus;

  estbk_utilities.changeWCtrlEnabledStatus(grpBoxBanks, not qryBank.EOF);
  self.FDataNotSaved := False;
  self.FNewRecordCreated := False;
end;

procedure TframeBanks.btnCloseClick(Sender: TObject);
begin
  if assigned(onFrameKillSignal) then
    onFrameKillSignal(self);
end;

procedure TframeBanks.btnNewBankClick(Sender: TObject);
begin
  TBitBtn(Sender).Enabled := False;
  estbk_utilities.changeWCtrlEnabledStatus(grpBoxBanks, True);


  try
    self.FSkipDbEvents := True;
    qryBank.First;
    qryBank.Insert;
    qryBank.FieldByName('bankname').AsString := '';

  finally
    self.FSkipDbEvents := False;
  end;

  // ---
  btnSave.Enabled := True;
  btnCancel.Enabled := True;

  if dbEdtBankName.CanFocus then
    dbEdtBankName.SetFocus;
end;

function TframeBanks.getDataLoadStatus: boolean;
begin
  Result := qryBank.active;
end;

procedure TframeBanks.setDataLoadStatus(const v: boolean);
begin

  qryBank.Close;
  qryBank.SQL.Clear;
  qryBankupdate.insertSQL.Clear;
  qryBankupdate.modifySQL.Clear;

  if v then
  begin
    qryBank.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryBankSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;

    qryBankupdate.insertSQL.add(estbk_sqlclientcollection._SQLInsertBank);
    qryBankupdate.modifySQL.add(estbk_sqlclientcollection._SQLUpdateBank);

    qryBank.SQL.Add(estbk_sqlclientcollection._SQLSelectBanks);
    qryBank.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;


    qryBank.Active := v;
    estbk_utilities.changeWCtrlEnabledStatus(grpBoxBanks, not qryBank.EOF);

  end
  else
  begin

    qryBank.Connection := nil;
    qryBankSeq.Connection := nil;
  end;
end;


constructor TframeBanks.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
end;


destructor TframeBanks.Destroy;
begin
  inherited Destroy;
end;


initialization
  {$I estbk_fra_banks.ctrs}

end.
