unit estbk_fra_warehouse;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, DBGrids, ComCtrls,
  StdCtrls, ExtCtrls, DBCtrls, Buttons, Dialogs,estbk_lib_commonevents,estbk_fra_template,
  estbk_uivisualinit, estbk_clientdatamodule, estbk_sqlclientcollection, estbk_globvars,
  estbk_utilities, estbk_types, estbk_strmsg, estbk_frame_chooseaddr,
  rxlookup, DB, ZDataset, ZSqlUpdate, ZSequence, Controls, ZAbstractDataset;

type

  { TframeWarehouses }

  TframeWarehouses = class(Tfra_template)
    btnCancel:   TBitBtn;
    btnClose:    TBitBtn;
    btnNewWarehouse: TBitBtn;
    btnSave:     TBitBtn;
    cmbCountry:  TComboBox;
    cmbPrCalcMeth: TComboBox;
    cmbSaleAcc:  TRxDBLookupCombo;
    cmbSaleAcc1: TRxDBLookupCombo;
    comboCity:   TComboBox;
    comboCounty: TComboBox;
    comboStreet: TComboBox;
    cPanel: TPanel;
    dbMemoextinfo: TDBMemo;
    qryWarehouseAccDs: TDatasource;
    dbEdtCustPhone: TDBEdit;
    dbEdtWarehouseChief: TDBEdit;
    dbEdtWarehouseCode: TDBEdit;
    dbEdtWarehouseEMail: TDBEdit;
    dbEdtWarehouseHousenr: TDBEdit;
    dbEdtWarehouseName: TDBEdit;
    dbEdtWarehousePostIndex: TDBEdit;
    dbWarehouseApNr: TDBEdit;
    dbWhGrid:    TDBGrid;
    dummyTabFix: TEdit;
    lbCity:      TLabel;
    lbCounty:    TLabel;
    lblWarehouseExpAcc: TLabel;
    lblWarehouseApartmentnr: TLabel;
    lblWarehouseChief: TLabel;
    lblWarehouseAcc: TLabel;
    lblWarehouseCode: TLabel;
    lblWarehouseEmail: TLabel;
    lblWarehouseHouseNr: TLabel;
    lblWarehouseName: TLabel;
    lblWarehousePhone: TLabel;
    lblWarehousePriceCalcMeth: TLabel;
    lblWarehousePriceCalcMeth1: TLabel;
    lblWhCountry: TLabel;
    lbStreet:    TLabel;
    lbWarehousePostIdx: TLabel;
    leftPanel:   TPanel;
    pmainPanel:  TPanel;
    qryWarehouseExpAccDs: TDatasource;
    qryWarehouseExpAcc: TZQuery;
    qryWarehouseDs: TDatasource;
    grpBoxWarehouse: TGroupBox;
    qryWarehouse: TZQuery;
    qryWarehouseUpdt: TZUpdateSQL;
    qryWarehouseSeq: TZSequence;
    rightPanel:  TPanel;
    Splitter1:   TSplitter;
    qryWarehouseAcc: TZQuery;
    qryVerifyData: TZReadOnlyQuery;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewWarehouseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cmbCountryChange(Sender: TObject);
    procedure cmbPrCalcMethChange(Sender: TObject);
    procedure cmbSaleAccClosePopupNotif(Sender: TObject);
    procedure cmbSaleAccSelect(Sender: TObject);
    procedure dbEdtWarehouseCodeKeyPress(Sender: TObject; var Key: char);
    procedure qryWarehouseAfterEdit(DataSet: TDataSet);
    procedure qryWarehouseAfterInsert(DataSet: TDataSet);
    procedure qryWarehouseAfterScroll(DataSet: TDataSet);
    procedure qryWarehouseBeforePost(DataSet: TDataSet);
    procedure qryWarehouseBeforeScroll(DataSet: TDataSet);
  protected
    FDefaultCountryIndx: integer;
    FSkipScrollEvent  : boolean;
    FNewRecordCreated : boolean;
    FDataNotSaved     : boolean;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif:  TKeyNotEvent;
    FFrameDataEvent:  TFrameReqEvent;
    FFrameWhAddr:     TFrameAddrPicker;
    function  getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure onWarehouseAddrChange(Sender: TObject);
    procedure verifyData;
  public
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  // RTTI probleem !
  published
    property onFrameKillSignal: TNotifyEvent Read FframeKillSignal Write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent Read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent Read FFrameDataEvent Write FFrameDataEvent;
    property loadData: boolean Read getDataLoadStatus Write setDataLoadStatus;
  end;

implementation

constructor TframeWarehouses.Create(frameOwner: TComponent);
var
  pr: AStr;
  i, ptmpIndx: integer;
begin
  inherited Create(frameOwner);
  // -------
  estbk_uivisualinit.__preparevisual(self);

  cmbPrCalcMeth.items.add(estbk_strmsg.SCaptCalcMethodAvarage);
  cmbPrCalcMeth.items.add(estbk_strmsg.SCaptCalcMethodFIFO);
  cmbPrCalcMeth.ItemIndex := 0;

  FFrameWhAddr      := TFrameAddrPicker.Create(nil);
  FFrameWhAddr.Name := 'whframe' + inttohex(random(99999), 6);
  FFrameWhAddr.parent := rightPanel;
  FFrameWhAddr.Visible := True;

  FFrameWhAddr.left   := 6;
  FFrameWhAddr.Width  := 374;
  FFrameWhAddr.Height := 69;

  FFrameWhAddr.top      := 69;
  FFrameWhAddr.liveMode := True;

  FFrameWhAddr.comboCity.Width   := dbEdtWarehouseName.Width;
  FFrameWhAddr.comboCounty.Width := dbEdtWarehouseName.Width;
  FFrameWhAddr.comboStreet.Width := dbEdtWarehouseName.Width;

  FFrameWhAddr.lbCounty.Left := FFrameWhAddr.lbCounty.Left + 3;
  FFrameWhAddr.lbCity.Left   := FFrameWhAddr.lbCity.Left + 3;
  FFrameWhAddr.lbStreet.Left := FFrameWhAddr.lbStreet.Left + 3;


  FFrameWhAddr.onDataChange := @self.onWarehouseAddrChange;

  FFrameWhAddr.TabOrder := dummyTabFix.TabOrder;
  //dbEdtWarehouseHousenr.TabOrder:=FFrameWhAddr.TabOrder+1;
  //dbEdtWarehouseHousenr.TabOrder:=FFrameWhAddr.TabOrder+1;
  dummyTabFix.TabStop   := False;

  self.FDefaultCountryIndx := -1;
  for i := 0 to estbk_globvars.glob_preDefCountryCodes.Count - 1 do
  begin
    pr := estbk_globvars.glob_preDefCountryCodes.ValueFromIndex[i];
    system.Delete(pr, 1, pos(':', pr));

    ptmpIndx := cmbCountry.items.AddObject(pr, TObject(cardinal(i)));
    if AnsiUpperCase(estbk_globvars.glob_preDefCountryCodes.Names[i]) = estbk_globvars.Cglob_DefaultCountryCodeISO3166_1 then
      self.FDefaultCountryIndx := ptmpIndx;
  end;

  // --
  cmbCountry.ItemIndex := self.FDefaultCountryIndx;
end;

destructor TframeWarehouses.Destroy;
begin
  FreeAndNil(FFrameWhAddr);
  inherited Destroy;
end;

procedure TframeWarehouses.btnNewWarehouseClick(Sender: TObject);
begin
     TBitBtn(Sender).Enabled := False;
     btnSave.Enabled   := True;
     btnCancel.Enabled := True;

     estbk_utilities.changeWCtrlEnabledStatus(leftPanel, True, 0);
     estbk_utilities.changeWCtrlEnabledStatus(rightPanel, True, 0);

     self.FFrameWhAddr.countyId :=0;
     self.FFrameWhAddr.cityId   :=0;
     self.FFrameWhAddr.streetId :=0;

     self.FFrameWhAddr.country:=estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;

  if dbEdtWarehouseCode.canFocus then
     dbEdtWarehouseCode.SetFocus;

  try
    self.FNewRecordCreated:=true;
    self.FSkipScrollEvent := True;
    qryWarehouse.First;
    qryWarehouse.Insert;
  finally
    self.FSkipScrollEvent := False;
  end;
end;

procedure TframeWarehouses.btnSaveClick(Sender: TObject);
begin
 with  estbk_clientdatamodule.dmodule do
  try

        self.verifyData;
        // ---
        primConnection.StartTransaction;
        qryWarehouse.ApplyUpdates;

        primConnection.Commit;
        qryWarehouse.CommitUpdates;

        self.FDataNotSaved:=False;
        self.FNewRecordCreated:=False;

     if assigned(FFrameDataEvent) then
        FFrameDataEvent(self,__frameWarehouseDataChanged,-1);

        TBitBtn(Sender).Enabled := False;
        btnCancel.Enabled := False;
        btnNewWarehouse.Enabled := True;
        btnNewWarehouse.setFocus;

  except on e : exception do
    begin
    if  primConnection.inTransaction then
    try primConnection.Rollback; except end;
    if  not (e is eabort) then
        dialogs.messageDlg(format(estbk_strmsg.SESaveFailed,[e.message]),mtError,[mbok],0);
    end;
  end;
end;

procedure TframeWarehouses.cmbCountryChange(Sender: TObject);
var
  pnewEdt: boolean;
begin
  with TComboBox(Sender) do
    if not FSkipScrollEvent and Focused and (ItemIndex >= 0) then
      try
          self.FSkipScrollEvent := True;
          pnewEdt := not (qryWarehouse.State in [dsEdit, dsInsert]);
       if pnewEdt then
          qryWarehouse.Edit;

          // ---
          self.FFrameWhAddr.country :=estbk_globvars.glob_preDefCountryCodes.names[cardinal(items.Objects[ItemIndex])];
          qryWarehouse.FieldByName('countrycode').AsString := self.FFrameWhAddr.country;
          qryWarehouse.FieldByName('county_id').AsInteger := 0;
          qryWarehouse.FieldByName('city_id').AsInteger := 0;
          qryWarehouse.FieldByName('street_id').AsInteger := 0;
          // ---

      finally
        if pnewEdt then
           qryWarehouse.Post;
           self.FSkipScrollEvent := False;
      end;
end;

procedure TframeWarehouses.cmbPrCalcMethChange(Sender: TObject);
var
 pnewEdt : Boolean;
begin
   with TComboBox(Sender) do
    if not FSkipScrollEvent and Focused and (ItemIndex >= 0) then
      try
          self.FSkipScrollEvent := True;
          pnewEdt := not (qryWarehouse.State in [dsEdit, dsInsert]);
       if pnewEdt then
          qryWarehouse.Edit;

          // --- ! event väärtustab !!!!!!!!!!!
          // BeforePost
      finally
        if pnewEdt then
           qryWarehouse.Post;
           // --
           self.FSkipScrollEvent := False;
      end;
end;

procedure TframeWarehouses.cmbSaleAccClosePopupNotif(Sender: TObject);
begin
    estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeWarehouses.cmbSaleAccSelect(Sender: TObject);
begin
    with  TRxDBLookupCombo(Sender) do
  if (value<>'') then
   begin
      LookupSource.DataSet.Locate('id',value,[]);
      Text:=LookupSource.DataSet.FieldByname('account_coding').asString;
   end;
end;

procedure TframeWarehouses.btnCancelClick(Sender: TObject);
begin
  self.FDataNotSaved := False;
  self.FNewRecordCreated:= False;

  qryWarehouse.CancelUpdates;
  TBitBtn(Sender).Enabled := False;
  btnSave.Enabled := False;
  btnNewWarehouse.Enabled := True;

  btnNewWarehouse.SetFocus;

  estbk_utilities.changeWCtrlEnabledStatus(leftPanel, not qryWarehouse.EOF, 0);
  estbk_utilities.changeWCtrlEnabledStatus(rightPanel, not qryWarehouse.EOF, 0);
  // --
  qryWarehouseAfterScroll(qryWarehouse);
  cmbPrCalcMeth.itemindex:=0;

end;

procedure TframeWarehouses.btnCloseClick(Sender: TObject);
begin
  if assigned(onFrameKillSignal) then
     onFrameKillSignal(self);
end;

procedure TframeWarehouses.dbEdtWarehouseCodeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeWarehouses.qryWarehouseAfterEdit(DataSet: TDataSet);
begin
   self.FDataNotSaved := True;

   btnSave.Enabled:=true;
   btnCancel.Enabled:=true;
   btnNewWarehouse.Enabled:=false;
end;

procedure TframeWarehouses.qryWarehouseAfterInsert(DataSet: TDataSet);
begin
  self.FNewRecordCreated := True;
  self.FDataNotSaved := True;
end;

procedure TframeWarehouses.qryWarehouseAfterScroll(DataSet: TDataSet);
var
  pCountryCode: AStr;
  i: integer;
begin

  if not self.FNewRecordCreated and not Dataset.EOF then
  begin

    cmbCountry.ItemIndex := self.FDefaultCountryIndx;
    pCountryCode := DataSet.FieldByName('countrycode').AsString;

    for i := 0 to cmbCountry.items.Count - 1 do
     if estbk_globvars.glob_preDefCountryCodes.names[cardinal(cmbCountry.Items.Objects[i])] = pCountryCode then
      begin
        cmbCountry.ItemIndex := i;
        break;
      end;



        FFrameWhAddr.country  := pCountryCode;
        FFrameWhAddr.countyId := DataSet.FieldByName('county_id').AsInteger;
        FFrameWhAddr.cityId   := DataSet.FieldByName('city_id').AsInteger;
        FFrameWhAddr.streetId := DataSet.FieldByName('street_id').AsInteger;

    if  DataSet.FieldByName('price_calc_meth').asString=estbk_types.CArtPriceCalcTypeAvarage then
        cmbPrCalcMeth.itemIndex:=0
    else
    if  DataSet.FieldByName('price_calc_meth').asString=estbk_types.CArtPriceCalcTypeFIFO then
        cmbPrCalcMeth.itemIndex:=1;

  end;  // ---
end;

procedure TframeWarehouses.qryWarehouseBeforePost(DataSet: TDataSet);
begin
  with dataset do
  begin
        // ---
        FieldByName('rec_changed').AsDateTime  := now;
        FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;

    if self.FNewRecordCreated then
    begin
        FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        FieldByName('company_id').AsInteger  := estbk_globvars.glob_company_id;
    end;


        //DataSet.FieldByName('charge_account_id').AsInteger  := 0;
        //DataSet.FieldByName('revenue_account_id').AsInteger := 0;


        // hetkel veel ei kasuta; seda infot peab täpsustama !!!
        DataSet.FieldByName('vatnumber').AsString     := '';
        DataSet.FieldByName('opening_times').AsString := '';
        DataSet.FieldByName('postal_addr').AsString :='';
        DataSet.FieldByName('status').AsString :='';

        // kaotame need tühikud !
        DataSet.FieldByName('warehousecode').AsString :=trim(DataSet.FieldByName('warehousecode').AsString);
        DataSet.FieldByName('warehousename').AsString :=trim(DataSet.FieldByName('warehousename').AsString);


        // ---
        if trim(DataSet.FieldByName('countrycode').AsString) = '' then
          DataSet.FieldByName('countrycode').AsString :=estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;


        DataSet.FieldByName('county_id').AsInteger := FFrameWhAddr.countyId;
        DataSet.FieldByName('city_id').AsInteger   := FFrameWhAddr.cityId;
        DataSet.FieldByName('street_id').AsInteger := FFrameWhAddr.streetId;

   // tüüp
   case cmbPrCalcMeth.itemIndex of
      0: DataSet.FieldByName('price_calc_meth').asString:=estbk_types.CArtPriceCalcTypeAvarage;
      1: DataSet.FieldByName('price_calc_meth').asString:=estbk_types.CArtPriceCalcTypeFIFO;
    end;
    // -----
  end;
end;


procedure TframeWarehouses.verifyData;
begin
 // ---
 //if not self.FNewRecordCreated then
   if trim(qryWarehouse.fieldByname('warehousecode').asString)='' then
     begin
        dialogs.messageDlg(estbk_strmsg.SEWareHouseCodeIsMissing,mtError,[mbOk],0);
     if dbEdtWarehouseCode.CanFocus then
        dbEdtWarehouseCode.SetFocus;
        abort; // ---
     end;

   if trim(qryWarehouse.fieldByname('warehousename').asString)='' then
     begin
        dialogs.messageDlg(estbk_strmsg.SEWareHouseNameIsMissing,mtError,[mbOk],0);
     if dbEdtWarehouseName.CanFocus then
        dbEdtWarehouseName.SetFocus;
        abort; // ---
     end;

 // --- kontrollime ka loakoodi unikaalsust
 with qryVerifyData,SQL do
  try
     close;
     clear;
     add(estbk_sqlclientcollection._SQLCheckWarehouseCN);

     paramByname('id').asInteger:=qryWarehouse.fieldByname('id').asInteger;
     paramByname('company_id').asInteger:=estbk_globvars.glob_company_id;
     paramByname('warehousecode').asString:=qryWarehouse.fieldByname('warehousecode').asString;
     paramByname('warehousename').asString:=qryWarehouse.fieldByname('warehousename').asString;
     open;
     // --- miskit leiti ?!?! anname veateate, mis juba olemas
  if not eof then
   begin
      case fieldByname('item').asInteger of
       1: begin
           dialogs.messageDlg(estbk_strmsg.SEWareHouseCodeExists,mtError,[mbOk],0);
          end;

       2: begin
           dialogs.messageDlg(estbk_strmsg.SEWareHouseNameExists,mtError,[mbOk],0);
          end;
      end;

     abort;
   end;
   // ---
  finally
     close;
     clear;
  end;
  // ---
end;

procedure TframeWarehouses.qryWarehouseBeforeScroll(DataSet: TDataSet);
begin
  if not self.FSkipScrollEvent and self.FDataNotSaved then
    self.verifyData;
end;

function TframeWarehouses.getDataLoadStatus: boolean;
begin
  Result := qryWarehouse.active;
end;

procedure TframeWarehouses.setDataLoadStatus(const v: boolean);
begin
  qryWarehouse.Close;
  qryWarehouse.SQL.Clear;

  qryWarehouseAcc.Close;
  qryWarehouseAcc.SQL.Clear;

  qryWarehouseExpAcc.Close;
  qryWarehouseExpAcc.SQL.Clear;

  // ---
  qryWarehouseUpdt.InsertSQL.Clear;

  if v then
  begin
    // ---
    qryWarehouseSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryWarehouse.Connection    := estbk_clientdatamodule.dmodule.primConnection;
    qryWarehouseAcc.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryWarehouseExpAcc.Connection:= estbk_clientdatamodule.dmodule.primConnection;
    qryVerifyData.Connection:= estbk_clientdatamodule.dmodule.primConnection;

    // ---
    qryWarehouseUpdt.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertWarehouse);
    qryWarehouseUpdt.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdateWarehouse);


    FFrameWhAddr.connection := estbk_clientdatamodule.dmodule.primConnection;
    FFrameWhAddr.loadData   := True;



    qryWarehouseAcc.SQL.Add(estbk_sqlclientcollection._CSQLGetOpenAccounts);
    qryWarehouseAcc.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryWarehouseAcc.active:=v;


    qryWarehouseExpAcc.SQL.Add(estbk_sqlclientcollection._CSQLGetOpenAccounts);
    qryWarehouseExpAcc.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryWarehouseExpAcc.active:=v;



    qryWarehouse.SQL.add(estbk_sqlclientcollection._SQLSelectWarehouse);
    qryWarehouse.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryWarehouse.active := v;


    // --
    qryWarehouseAfterScroll(qryWarehouse);
    estbk_utilities.changeWCtrlEnabledStatus(leftPanel, not qryWarehouse.EOF, 0);
    estbk_utilities.changeWCtrlEnabledStatus(rightPanel, not qryWarehouse.EOF, 0);

  end
  else
  begin
    FFrameWhAddr.loadData   := False;
    FFrameWhAddr.connection := nil;

    qryWarehouse.Connection    := nil;
    qryWarehouseSeq.Connection := nil;
    qryWarehouseAcc.Connection := nil;
    qryWarehouseExpAcc.Connection:= nil;

    qryVerifyData.Connection:=nil;
  end;
end;

procedure TframeWarehouses.onWarehouseAddrChange(Sender: TObject);
var
  pnewEdt: boolean;
begin
  if not self.FSkipScrollEvent then
    try
      self.FSkipScrollEvent := True;
      pnewEdt := not (qryWarehouse.State in [dsEdit, dsInsert]);
      if pnewEdt then
        qryWarehouse.Edit;

      //  if TCombobox(Sender).Focused then
      case TCombobox(Sender).tag of
        1: qryWarehouse.FieldByName('county_id').AsInteger := FFrameWhAddr.countyId;
        // maakond
        2: qryWarehouse.FieldByName('city_id').AsInteger   := FFrameWhAddr.cityId;  // linn
        3: qryWarehouse.FieldByName('street_id').AsInteger := FFrameWhAddr.streetId;
        // tänav
      end;

      // --
    finally
      if pnewEdt then
        qryWarehouse.Post;

      self.FSkipScrollEvent := False;
    end;
end;

initialization
  {$I estbk_fra_warehouse.ctrs}

end.

