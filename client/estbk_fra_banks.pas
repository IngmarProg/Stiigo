unit estbk_fra_banks;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, ComCtrls, StdCtrls, DbCtrls, EditBtn, ExtCtrls, DBGrids, Buttons,
  dialogs,estbk_fra_template,estbk_uivisualinit,estbk_clientdatamodule, estbk_sqlclientcollection,LCLType,
  estbk_globvars, estbk_utilities,estbk_types,estbk_lib_commonevents,
  estbk_strmsg, ZDataset, ZSequence, ZSqlUpdate, rxlookup, db, Controls;
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
    procedure qryAccountsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure qryBankAfterCancel(DataSet: TDataSet);
    procedure qryBankAfterInsert(DataSet: TDataSet);
    procedure qryBankAfterScroll(DataSet: TDataSet);
    procedure qryBankBeforeEdit(DataSet: TDataSet);
    procedure qryBankBeforePost(DataSet: TDataSet);
    procedure qryBankBeforeScroll(DataSet: TDataSet);
    procedure rpAccountsChange(Sender: TObject);
    procedure rpAccountsClosePopupNotif(Sender: TObject);
    procedure rpAccountsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rpAccountsSelect(Sender: TObject);
  private
    FDataNotSaved     : Boolean;
    FSkipDbEvents     : Boolean;
    FNewRecordCreated : Boolean;
    // ---
    FframeKillSignal  : TNotifyEvent;
    FParentKeyNotif   : TKeyNotEvent;
    FFrameDataEvent   : TFrameReqEvent;
    function    getDataLoadStatus: boolean;
    procedure   setDataLoadStatus(const v: boolean);
  public
    // ---
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  // RTTI teema
  published
    property    onFrameKillSignal     : TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property    onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    property    onFrameDataEvent : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property    loadData : boolean read getDataLoadStatus write setDataLoadStatus;
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
      fieldByname('company_id').asInteger:=estbk_globvars.glob_company_id;
      fieldByname('rec_addedby').asInteger:=estbk_globvars.glob_worker_id;
     end;

      fieldByname('rec_changedby').asInteger:=estbk_globvars.glob_worker_id;
      fieldByname('rec_changed').asDateTime:=now;
  end;
end;

procedure TframeBanks.qryBankBeforeScroll(DataSet: TDataSet);
begin

 with DataSet do
 if not isEmpty and not self.FSkipDbEvents then
  try

    if trim(fieldByname('bankname').asString)='' then
      begin
          dialogs.messageDlg(estbk_strmsg.SEBankMissingName,mtError,[mbOk],0);
      if  dbEdtBankName.canfocus then
          dbEdtBankName.setFocus;
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
  except on e : exception do
   showmessage(e.Message);
  end;
end;

procedure TframeBanks.rpAccountsChange(Sender: TObject);
begin

end;

procedure TframeBanks.rpAccountsClosePopupNotif(Sender: TObject);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeBanks.rpAccountsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift=[] then
  case key of
      VK_DELETE:
       begin
         TRxDBLookupCombo(Sender).Value:='';
         key:=0;
       end;
  end;
end;

procedure TframeBanks.rpAccountsSelect(Sender: TObject);
begin
  with  TRxDBLookupCombo(Sender) do
  if (value<>'') then
   begin
      LookupSource.DataSet.Locate('id',value,[]);
      Text:=LookupSource.DataSet.FieldByname('account_coding').asString;
   end;
end;

procedure TframeBanks.qryBankAfterInsert(DataSet: TDataSet);
begin
  self.FDataNotSaved:=true;
  self.FNewRecordCreated:=true;
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
  btnNewBank.Enabled:=false;
  btnCancel.Enabled:=true;
  btnSave.Enabled:=true;
  self.FDataNotSaved:=true;
end;

procedure TframeBanks.btnSaveClick(Sender: TObject);
begin
 // if qryBank.state in [dsEdit,dsInsert] then
 //    qryBank.post;


  with estbk_clientdatamodule.dmodule do
  try
        // 05.03.2010 Ingmar
        self.qryBankBeforeScroll(qryBank);

        primConnection.StartTransaction;
        qryBank.ApplyUpdates;

        primConnection.Commit;
        qryBank.CommitUpdates;

        self.FDataNotSaved:=false;
        self.FNewRecordCreated:=false;

        btnSave.Enabled:=false;
        btnCancel.Enabled:=false;
        btnNewBank.Enabled:=true;

     if btnNewBank.canFocus then
        btnNewBank.setFocus;


     if assigned(FFrameDataEvent) then
        FFrameDataEvent(self,__frameBankDataChanged,-1);

  except on e : exception do
    begin
    if  primConnection.inTransaction then
    try primConnection.Rollback; except end;
    if  not (e is eabort) then
        dialogs.messageDlg(format(estbk_strmsg.SESaveFailed,[e.message]),mtError,[mbok],0);
    end;
  end;

end;

procedure TframeBanks.chkboxCanUseInBillsChange(Sender: TObject);
var
 pNewPostSq : Boolean;
begin
  if TCheckbox(Sender).Focused then
   begin
        pNewPostSq:=not (qryBank.State in [dsEdit,dsInsert]);
    if  pNewPostSq then
        qryBank.Edit;

        qryBank.fieldByname('active').asString:=estbk_types.SCFalseTrue[TCheckbox(Sender).checked];

        // ---
    if  pNewPostSq then
        qryBank.Post;

   end;
end;

procedure TframeBanks.dbEdtBankNameKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   begin
     SelectNext(Sender as twincontrol, True, True);
     key:=#0;
   end;
end;

procedure TframeBanks.qryAccountsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
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

  TBitBtn(Sender).Enabled:=false;
  btnSave.Enabled:=false;
  btnNewBank.Enabled:=true;
  btnNewBank.setFocus;

  estbk_utilities.changeWCtrlEnabledStatus(grpBoxBanks,not qryBank.eof);
  self.FDataNotSaved:=false;
  self.FNewRecordCreated:=false;
end;

procedure TframeBanks.btnCloseClick(Sender: TObject);
begin
  if assigned(onFrameKillSignal) then
     onFrameKillSignal(self);
end;

procedure TframeBanks.btnNewBankClick(Sender: TObject);
begin
    TBitBtn(Sender).Enabled:=false;
    estbk_utilities.changeWCtrlEnabledStatus(grpBoxBanks,true);


  try
    self.FSkipDbEvents:=true;
    qryBank.First;
    qryBank.Insert;
    qryBank.FieldByName('bankname').AsString:='';

  finally
    self.FSkipDbEvents:=false;
  end;

    // ---
    btnSave.Enabled:=true;
    btnCancel.Enabled:=true;

 if dbEdtBankName.CanFocus then
    dbEdtBankName.setFocus;
end;

function    TframeBanks.getDataLoadStatus: boolean;
begin
 result:=qryBank.active;
end;

procedure   TframeBanks.setDataLoadStatus(const v: boolean);
begin


    qryBank.close;
    qryBank.SQL.Clear;
    qryBankupdate.insertSQL.Clear;
    qryBankupdate.modifySQL.Clear;

 if v then
  begin
    // ---
    qryBank.Connection:=estbk_clientdatamodule.dmodule.primConnection;
    qryBankSeq.Connection:=estbk_clientdatamodule.dmodule.primConnection;

    qryBankupdate.insertSQL.add(estbk_sqlclientcollection._SQLInsertBank);
    qryBankupdate.modifySQL.add(estbk_sqlclientcollection._SQLUpdateBank);

    qryBank.SQL.Add(estbk_sqlclientcollection._SQLSelectBanks);
    qryBank.ParamByName('company_id').asInteger:=estbk_globvars.glob_company_id;


    qryBank.Active:=v;
    estbk_utilities.changeWCtrlEnabledStatus(grpBoxBanks,not qryBank.eof);



  end else
  begin

    qryBank.Connection:=nil;
    qryBankSeq.Connection:=nil;
  end;
end;


constructor TframeBanks.create(frameOwner: TComponent);
begin
  // -------
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
end;


destructor  TframeBanks.destroy;
begin
 inherited destroy;
end;


initialization
  {$I estbk_fra_banks.ctrs}

end.

