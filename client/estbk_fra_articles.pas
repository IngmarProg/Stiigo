unit estbk_fra_articles;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, DBCtrls, ExtCtrls, DBGrids, estbk_lib_commonevents, estbk_fra_template,
  estbk_uivisualinit, estbk_clientdatamodule, estbk_sqlclientcollection, estbk_globvars, estbk_utilities,
  estbk_types, estbk_strmsg, ZDataset, ZSqlUpdate, ZSequence, LCLType, rxdbgrid, ZAbstractRODataset, rxlookup, DB, Grids, Dialogs,
  Controls, EditBtn, Buttons, Graphics, ComCtrls, Typinfo, rxpopupunit;


type
  TframeArticles = class(Tfra_template)
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnNewArticle: TBitBtn;
    btnSave: TBitBtn;
    chkboxAllowedInSale: TCheckBox;
    chkboxAllowedInweb: TCheckBox;
    cmbArtType: TComboBox;
    cmbBarCodeTypes: TComboBox;
    cmbCostAcc: TRxDBLookupCombo;
    cmbPurcAcc: TRxDBLookupCombo;
    cmbSaleAcc: TRxDBLookupCombo;
    cmbUnit: TDBComboBox;
    cmbManufacturer: TDBComboBox;
    cmbVatLookup: TDBLookupComboBox;
    dbEdtBarcode: TDBEdit;
    dbEdtProdCode1: TDBEdit;
    dbRankNr: TDBEdit;
    dbEdtDimL: TDBEdit;
    dbEdtDimW: TDBEdit;
    dbEdtProdCode: TDBEdit;
    dbEdtDimH: TDBEdit;
    dbEdtProdName: TDBEdit;
    edtArtRelAmountTotal: TEdit;
    edtPurcPrice: TCalcEdit;
    edtSalePrice: TCalcEdit;
    Image2: TImage;
    ctrpanel: TPanel;
    imageCapt: TImageList;
    lblBatchnr: TLabel;
    memProdDesc: TDBMemo;
    pResizeFix: TPanel;
    btnNewArticleType: TSpeedButton;
    x1: TLabel;
    lblDimension: TLabel;
    lblArtAmount: TLabel;
    lbBarCode: TLabel;
    lbCostAcc: TLabel;
    lblArtType: TLabel;
    lblDescr: TLabel;
    lblShelfNumber: TLabel;
    lblManufacturer: TLabel;
    lbllpurchaseprice: TLabel;
    lblname: TLabel;
    lblProdcode: TLabel;
    lblPurcAcc: TLabel;
    lblSaleAcc: TLabel;
    lblSalePrice: TLabel;
    lblUnit: TLabel;
    lblVat: TLabel;
    pageArtMainData: TTabSheet;
    pageCtrlArt: TPageControl;
    qrySaleAccountsDs: TDatasource;
    qryPurcAccountsDs: TDatasource;
    qryExpensesAccountsDs: TDatasource;
    qryVATds: TDatasource;
    Image1: TImage;
    qryVAT: TZQuery;
    qryArticlesDs: TDatasource;
    dbEdtobjname: TDBEdit;
    dbObjGrid: TDBGrid;
    edtSrc: TEdit;
    grpBoxObjects: TGroupBox;
    grpObjType: TComboBox;
    lblObjGrp: TLabel;
    lblObjNimi: TLabel;
    lblSearch: TLabel;
    panelRight: TPanel;
    panelLeftInnerSrc: TPanel;
    panelLeft: TPanel;
    panelFlt: TPanel;
    Splitter1: TSplitter;
    qryArticles: TZQuery;
    qryArtInsUpdt: TZUpdateSQL;
    qryVerifData: TZReadOnlyQuery;
    qryArticlesSeq: TZSequence;
    qrySavePriceChanges: TZQuery;
    qrySaleAccounts: TZReadOnlyQuery;
    qryPurcAccounts: TZReadOnlyQuery;
    qryExpensesAccounts: TZReadOnlyQuery;
    tabPageExtInfo: TTabSheet;
    tabProductSeries: TTabSheet;
    x2: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewArticleClick(Sender: TObject);
    procedure btnNewArticleTypeClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure chkboxAllowedInSaleChange(Sender: TObject);
    procedure cmbArtTypeChange(Sender: TObject);

    procedure cmbSaleAccClosePopupNotif(Sender: TObject);
    procedure cmbSaleAccKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure cmbSaleAccKeyPress(Sender: TObject; var Key: char);
    procedure cmbSaleAccSelect(Sender: TObject);
    procedure cmbUnitClick(Sender: TObject);
    procedure cmbUnitExit(Sender: TObject);
    procedure cmbUnitKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbEdtDiscountPercExit(Sender: TObject);
    procedure dbEdtDiscountPercKeyPress(Sender: TObject; var Key: char);
    procedure dbEdtProdCodeKeyPress(Sender: TObject; var Key: char);
    procedure dbObjGridCellClick(Column: TColumn);
    procedure dbObjGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure dbObjGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbObjGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure dbObjGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure dbObjGridPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
    procedure dbObjGridTitleClick(Column: TColumn);
    procedure edtSalePriceAcceptValue(Sender: TObject; var AValue: double; var pAction: boolean);
    procedure edtSalePriceChange(Sender: TObject);
    procedure edtSalePriceEnter(Sender: TObject);
    procedure edtSalePriceExit(Sender: TObject);
    procedure edtSalePriceKeyPress(Sender: TObject; var Key: char);
    procedure edtSrcKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtSrcKeyPress(Sender: TObject; var Key: char);
    procedure edtSrcUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure qryArticlesAfterEdit(DataSet: TDataSet);
    procedure qryArticlesAfterInsert(DataSet: TDataSet);
    procedure qryArticlesAfterPost(DataSet: TDataSet);
    procedure qryArticlesAfterScroll(DataSet: TDataSet);
    procedure qryArticlesBeforePost(DataSet: TDataSet);
    procedure qryArticlesBeforeScroll(DataSet: TDataSet);
  protected
    FNewArtCode: AStr;
    FNewSrvCode: AStr;
    // ---
    FSaleAccountId: integer;
    FPurchAccountId: integer;
    FExcpAccountId: integer;
    // ---
    FSkipQryEvents: boolean;
    FNewRecordCreated: boolean;
    FDataNotSaved: boolean;
    // kui sisestatakse lao artikleid !
    FWarehouseMode: boolean;
    FWareHouseId: integer;
    FPActiveTitleIndx: integer;
    FDefaultVatID: integer;

    // sõltub ka konteksist !
    // jätame meelde hetke artikli hinna, et salvestamisel vaatame kas peame uut hinda kirjeldama
    FCurrentSalePrice: double;
    FCurrentPurcPrice: double;
    FCurrentDiscPerc: double;

    // ---
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;

    procedure deleteArticle();
    procedure fillComboItems;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    function autoGenerateItemCode(const pItemType: AStr; const pCurrentArtCode: AStr; const pTypeChanged: boolean = False): AStr;

    function isInternalItem(const pSpecialFlags: integer): boolean;
    procedure validateControlStatuses(const pSpecialFlags: integer);

    procedure verifyData;
    procedure managePrices;
    procedure addNewUnit(const pUnitName: AStr);

  public
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
    // RTTI pole täielik, published puhul vaid erandid
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;

    // ehk lao artiklid !
    property warehousemode: boolean read FWarehouseMode write FWarehouseMode;
    property warehouseid: integer read FWareHouseId write FWareHouseId;
  end;

implementation

uses variants, strutils, estbk_sqlcollection;

// ---
type
  TArtType = (CArtTypeGoodsIndex = 0,
    CArtTypeServiceIndex,
    CArtTypeWareHouseGoodsIndex,
    CArtTypeAsUserDefinedIndex);

type
  TArtClassifData = class
    FArtType: TArtType;
    FArtTypeId: integer; // see on olemas VAID kasutaja
  public
    constructor Create(pArtType: TArtType); overload; reintroduce;
    constructor Create(pArtType: TArtType; const pArtTypeId: integer); overload; reintroduce;
  end;

const
  TArtTypeArray: array[TArtType] of AStr = (estbk_types._CItemAsProduct,
    estbk_types._CItemAsService,
    estbk_types._CItemAsWProduct,
    estbk_types._CItemAsUsrDefined);


// ---------------------------------------------------------------------------

constructor TArtClassifData.Create(pArtType: TArtType);
begin
  inherited Create;
  FArtType := pArtType;
end;

constructor TArtClassifData.Create(pArtType: TArtType; const pArtTypeId: integer);
begin
  inherited Create;
  FArtType := pArtType;
  FArtTypeId := pArtTypeId;
end;

// ---------------------------------------------------------------------------

constructor TframeArticles.Create(frameOwner: TComponent);
var
  pTmpKey: word;
begin
  try
    //  cmbSaleAcc.OnLookupTitleColClick:=;
    // -------
    inherited Create(frameOwner);
    // -------
    estbk_uivisualinit.__preparevisual(self);

    // THackGrid(dbObjGrid).titleImagelist:=imageCapt;
    self.FPActiveTitleIndx := 1;
    edtArtRelAmountTotal.Color := estbk_types.MyFavOceanBlue;

    // 11.02.2010 ingmar
    // valime nimetuse lahtri !
    pTmpKey := Ord('2');
    self.edtSrcKeyDown(edtSrc, pTmpKey, [ssCtrl]);

    //panelRight.Color:=estbk_types.MyFavOceanBlue;
    panelRight.Color := clBtnFace;
    //panelLeft.Color:=estbk_types.MyFavOceanBlue;

    dbObjGrid.Columns.Items[0].Title.ImageIndex := estbk_clientdatamodule.img_indxItemUnChecked;
    dbObjGrid.Columns.Items[1].Title.ImageIndex := estbk_clientdatamodule.img_indxItemChecked;
    dbObjGrid.Columns.Items[2].Title.ImageIndex := estbk_clientdatamodule.img_indxItemUnChecked;

    // ---
    // TODO:
    tabProductSeries.TabVisible := False;
    pageCtrlArt.ActivePage := pageArtMainData;
  except
    on e: Exception do
      Dialogs.messageDlg(format(estbk_strmsg.SEInitializationZError, [e.message, self.ClassName]), mtError, [mbOK], 0);
  end;
end;

destructor TframeArticles.Destroy;
begin
  dmodule.notifyNumerators(PtrUInt(self));
  estbk_utilities.clearComboObjects(cmbArtType);
  inherited Destroy;
end;


procedure TframeArticles.fillComboItems;
begin
  with self.qryVerifData, SQL do
    try
      estbk_utilities.clearComboObjects(cmbArtType);
      cmbArtType.Clear;
      if not self.FWarehouseMode then
      begin
        cmbArtType.Enabled := self.Enabled;
        if cmbArtType.Enabled then
          cmbArtType.Color := clWindow
        else
          cmbArtType.Color := clBtnFace;
        cmbArtType.items.addObject(estbk_strmsg.CSArtAsGoods, TArtClassifData.Create(CArtTypeGoodsIndex));
        cmbArtType.items.addObject(estbk_strmsg.CSArtAsServices, TArtClassifData.Create(CArtTypeServiceIndex));
        cmbArtType.ItemIndex := 0;
      end
      else
      begin
        cmbArtType.Enabled := False;
        cmbArtType.Color := clBtnFace;
        cmbArtType.items.addObject(estbk_strmsg.CSArtAsGoods, TArtClassifData.Create(CArtTypeWareHouseGoodsIndex));
      end;


      // 02.09.2011 Ingmar; uued defineeritud tüübid ka peale !
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLArticleTypes);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      First;
      while not EOF do
      begin
        cmbArtType.items.addObject(FieldByName('arttypename').AsString, TArtClassifData.Create(CArtTypeAsUserDefinedIndex,
          FieldByName('id').AsInteger));
        Next;
      end;

      // ----
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLAmountNames);
      Open;
      First;
      while not EOF do
      begin
        if FieldByName('id').AsInteger > 0 then
          cmbUnit.items.addObject(FieldByName('amountname').AsString, TObject(cardinal(FieldByName('id').AsInteger)));
        Next;
      end;


    finally
      Close;
      Clear;
    end; // ----


  // sobib lookupcombo jaoks
  qryVAT.active := True;

  cmbVatLookup.ListSource := self.qryVATds;
  cmbVatLookup.DataSource := qryArticlesDs;

  // vaikimis käibemaks peale !
  qryVAT.Locate('defaultvat', 't', [loCaseInsensitive]);
  self.FDefaultVatID := qryVAT.FieldByName('id').AsInteger;
end;

procedure TframeArticles.dbObjGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
var
  pData: AStr;
  i: integer;
begin
  // reserveerin evendi !
  //TDbGrid(Sender).Canvas.TextOut(Rect.left + 2, Rect.top + 2, 'TEST');
  //if (gdFixed in State) then
  //TColumn(TDbGrid(Sender).Columns.Items[0]).Title.ImageIndex:=
  with TDbGrid(Sender) do
    if assigned(DataSource) and not DataSource.DataSet.IsEmpty and assigned(Column.Field) then
    begin
      Canvas.FillRect(Rect);
      pData := '';
      if Column.Index = 0 then
      begin
        if Column.Field.AsString = estbk_types._CItemAsProduct then
          pData := estbk_strmsg.CSArtAsGoods
        else if Column.Field.AsString = estbk_types._CItemAsWProduct then
          pData := estbk_strmsg.CSArtAsStockGoods
        else if Column.Field.AsString = estbk_types._CItemAsService then
          pData := estbk_strmsg.CSArtAsServices
        else if Column.Field.AsString = estbk_types._CItemAsUsrDefined then // 03.12.2011 Ingmar; ei kuvanud kasutaja defineeritud tüüpe  !
        begin
          for i := 0 to cmbArtType.items.Count - 1 do
            if TArtClassifData(cmbArtType.items.Objects[i]).FArtTypeId = qryArticles.FieldByName('arttype_id').AsInteger then
            begin
              pData := cmbArtType.items.Strings[i];
              Break;
            end;
        end;
      end
      else
        pData := Column.Field.AsString;

      // else
      Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, pData);
    end;
  {
   TDbGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
      if Column.State = csDefault then
      inherited DrawDataCell(Rect, Field, State);

    inherited DrawColumnCell(Rect, DataCol, Column, State); }
end;


procedure TframeArticles.deleteArticle();
begin
  if qryArticles.Active then
  begin

    // ilma applyupdate osata on delete !!!!!!
    if qryArticles.FieldByName('id').AsInteger > 0 then
      with qryVerifData, SQL do
        try
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLCheckArticleUsage);
          paramByname('article_id').AsInteger := qryArticles.FieldByName('id').AsInteger;
          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          Open;
          if Trim(FieldByName('nr').AsString) <> '' then
          begin
            Dialogs.messageDlg(format(estbk_strmsg.SEArtCantDelete, [FieldByName('nr').AsString]), mtError, [mbOK], 0);
            Exit; // !!!
          end;

          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLDeleteArticle);
          // et ei tekiks artikli koodi unikaalsuse indeksiga probleeme ntx kustutatakse sama koodi mitu korda, kunagi ei tea !!
          paramByname('code').AsString := 'DEL' + IntToStr(random(10)) + ':' + qryArticles.FieldByName('artcode').AsString;
          paramByname('article_id').AsInteger := qryArticles.FieldByName('id').AsInteger;
          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          paramByname('rec_deletedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;
        finally
          Close;
          Clear;
        end;

    // ---
    //qryArticles.Delete;
    qryArticles.Active := False;
    qryArticles.Active := True;
  end;
end;

procedure TframeArticles.dbObjGridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Shift = []) then
    case key of
      VK_F5: if not (qryArticles.State in [dsEdit, dsInsert]) then
        begin
          qryArticles.Active := False;
          qryArticles.Active := True;
          key := 0;
        end;
      // 05.02.2012 Ingmar
      // --- artikli kustutamine
      VK_DELETE:
        if not self.isInternalItem(qryArticles.FieldByName('special_type_flags').AsInteger) then  // süsteemseid ei luba kustutada !!!
          if Dialogs.messageDlg(format(estbk_strmsg.SCConfArticleDelete, [qryArticles.FieldByName('artname').AsString]),
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            self.deleteArticle();
            qryArticles.Active := False;
            qryArticles.Active := True;
            key := 0;
          end;
    end;
end;

procedure TframeArticles.dbEdtProdCodeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeArticles.dbObjGridCellClick(Column: TColumn);
begin
  // ---
end;

procedure TframeArticles.btnCloseClick(Sender: TObject);
begin
  if assigned(self.FframeKillSignal) then
    self.FframeKillSignal(self);
end;

procedure TframeArticles.btnCancelClick(Sender: TObject);
begin
  qryArticles.CancelUpdates;
  // !!!
  self.FDataNotSaved := False;
  self.FnewRecordCreated := False;
  self.FNewArtCode := '';
  self.FNewSrvCode := '';

  btnNewArticleType.Enabled := False;
  TBitBtn(Sender).Enabled := False;
  btnSave.Enabled := False;
  btnNewArticle.Enabled := True;
  estbk_utilities.changeWCtrlEnabledStatus(panelRight, not qryArticles.EOF, 0);
  panelRight.Enabled := True;


  pageCtrlArt.ActivePage := pageArtMainData;
  qryArticlesAfterScroll(qryArticles);
end;

procedure TframeArticles.btnNewArticleClick(Sender: TObject);
begin
  pageCtrlArt.ActivePage := pageArtMainData;

  estbk_utilities.changeWCtrlEnabledStatus(panelRight, True, 0);
  // ---
  panelRight.Enabled := True;
  TBitBtn(Sender).Enabled := False;
  btnNewArticleType.Enabled := True;

  // laost teenust ei müüda :)
  if self.FWarehouseMode then
  begin
    cmbArtType.Enabled := False;
    cmbArtType.Color := clBtnFace;
  end;


  btnSave.Enabled := True;
  btnCancel.Enabled := True;

  edtSalePrice.Text := '';
  edtPurcPrice.Text := '';
  self.edtArtRelAmountTotal.Text := '';


  // uus kirje peale !
  self.FNewRecordCreated := True;
  // self.cmbArtType.itemIndex:=0;
  // self.FSkipQryEvents:=true;

  if qryArticles.State in [dsEdit, dsInsert] then
    qryArticles.Post;

  qryArticles.First;
  qryArticles.Insert; // lookup teeb posti ära, peame editi uuesti käima tõmbama !

  qryArticles.FieldByName('sale_account_id').AsInteger := self.FSaleAccountId;
  qryArticles.FieldByName('purchase_account_id').AsInteger := self.FPurchAccountId;
  qryArticles.FieldByName('expense_account_id').AsInteger := self.FExcpAccountId;

  qryArticles.FieldByName('status').AsString := estbk_types._CArticleCanbeUsedInSale;
  qryArticles.FieldByName('disp_web_dir').AsString := '';
  chkboxAllowedInSale.Enabled := True;
  chkboxAllowedInSale.Checked := True;

  // 05.05.2014 Ingmar
  chkboxAllowedInweb.Enabled := True;
  chkboxAllowedInweb.Checked := False;

  qrySaleAccounts.First;
  qryPurcAccounts.First;
  qryExpensesAccounts.First;

  // ---
  if cmbArtType.canfocus then
    cmbArtType.SetFocus;
end;

procedure TframeArticles.btnNewArticleTypeClick(Sender: TObject);
var
  pTypeName: AStr;
  pTypeId: integer;
  pNewObj: integer;
begin
  // ---
  //cmbArtType
  pTypeName := '';
  if InputQuery(estbk_strmsg.SCNewArticleType, estbk_strmsg.SCNewArticleTypeName, pTypeName) and (trim(pTypeName) <> '') then
  begin
    pTypeName := trim(pTypeName);
    if cmbArtType.Items.IndexOf(pTypeName) = -1 then
      with dmodule.tempQuery, SQL do
        try
          pTypeId := dmodule.qryClassificatorSeq.GetNextValue;
          Close;
          Clear;
          add(estbk_sqlcollection._SQLInsertNewClassificator3);
          paramByname('id').AsInteger := pTypeId;
          paramByname('name').AsString := pTypeName;
          paramByname('shortidef').AsString := estbk_types._CItemAsUsrDefined; // user defined ! vii estbk_types moodulisse !
          paramByname('type_').AsString := estbk_types._CItemUserDefArticleTypeName;
          paramByname('weight').AsInteger := 0;
          paramByname('value').AsString := '';
          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          execSQL;

          pNewObj := cmbArtType.Items.AddObject(pTypeName, TArtClassifData.Create(CArtTypeAsUserDefinedIndex, pTypeId));
          cmbArtType.ItemIndex := pNewObj;
        finally
          Close;
          Clear;
        end
    else
      Dialogs.messageDlg(format(estbk_strmsg.SEArtTypeAlreadyExists, [pTypeName]), mtError, [mbOK], 0);
    // ---
  end;
end;

procedure TframeArticles.managePrices;
const
  CPrType: array[0..1] of AStr = (estbk_types._CArtSalePrice,
    estbk_types._CArtPurchPrice);
var
  pdidPurchPriceChg: boolean;
  pdidSalePriceChg: boolean;
  pnewSalePrice: double;
  pnewPurcPrice: double;
  pnpDate: TDatetime;
  i: byte;
begin
  pnpDate := date;
  pnewSalePrice := strtofloatdef(edtSalePrice.Text, 0);
  pnewPurcPrice := strtofloatdef(edtPurcPrice.Text, 0);

  // ---
  pdidSalePriceChg := (self.FCurrentSalePrice <> pnewSalePrice) or self.FNewRecordCreated or
    (self.FCurrentDiscPerc <> qryArticles.FieldByName('discount_perc').AsFloat);

  pdidPurchPriceChg := (self.FCurrentPurcPrice <> pnewPurcPrice) or self.FNewRecordCreated;
  // müügihind muutus
  with qrySavePriceChanges, SQL do
    try
      for i := 0 to 1 do
      begin

        if (i = 0) and not pdidSalePriceChg then
          Continue
        else
        if (i = 1) and not pdidPurchPriceChg then
          Continue;


        // --
        // tühistame eelmise hinna ...
        if not self.FNewRecordCreated then
        begin
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLUpdateArticlePrice1);
          parambyname('ends').AsDateTime := pnpDate - 1;
          parambyname('rec_changed').AsDateTime := now;
          parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          parambyname('type_').AsString := CPrType[i]; // price type !
          parambyname('article_id').AsInteger := qryArticles.FieldByName('id').AsInteger;
          execSQL;
        end;

        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLInsertArticlePrice);
        // 05.01.2009 Ingmar; viisin selle seq. üldisesse andmemoodulisse, kuna kasutusel mitmes kohas !
        parambyname('id').AsInteger := estbk_clientdatamodule.dmodule.qryArticlePriceSeq.GetNextValue;
        parambyname('article_id').AsInteger := qryArticles.FieldByName('id').AsInteger;
        parambyname('prsource').AsString := estbk_types._CArtPriceChangeSrcManual;
        parambyname('warehouse_id').AsInteger := self.FWarehouseId;


        case i of
          0: parambyname('price').AsFloat := pnewSalePrice;
          1: parambyname('price').AsFloat := pnewPurcPrice;
        end;


        // müügi puhul; allahindlust ostu puhul ?!?!?!
        if (CPrType[i] = 'S') then
          parambyname('discount_perc').AsFloat := qryArticles.FieldByName('discount_perc').AsInteger
        else
          parambyname('discount_perc').AsFloat := 0;

        // ----
        parambyname('begins').AsDateTime := pnpDate;
        parambyname('ends').Value := null;
        parambyname('type_').AsString := CPrType[i]; // price type !
        parambyname('rec_changed').AsDateTime := now;
        parambyname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        parambyname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        execSQL;
        // ----
      end;

    finally
      Close;
      Clear;
    end;
end;

procedure TframeArticles.btnSaveClick(Sender: TObject);
var
  pDetectPriceChg: boolean;
  pSalePrice: double;
  pPurcPrice: double;
begin
  btnNewArticleType.Enabled := False;
  // ---
  with estbk_clientdatamodule.dmodule do
    try
      //    if  not (qryArticles.state in [dsInsert,dsEdit]) then
      //        qryArticles.Edit;
      // antud event paneb alles õige tüübi paika !!!!!!
      //        qryArticlesBeforePost(qryArticles);
      if (qryArticles.state in [dsInsert, dsEdit]) then
        qryArticles.Post;


      // #########################################################
      // ---- kontrollime alati !!!
      // if self.FNewRecordCreated then
      // ----------------
      self.verifyData;

      pSalePrice := strtofloatdef(edtSalePrice.Text, 0);
      pPurcPrice := strtofloatdef(edtPurcPrice.Text, 0);
      //  SConfArtSalePriceMixup


      // #####################################################
      primConnection.StartTransaction;
      qryArticles.ApplyUpdates;

      // vaatame üle hinnainfo ja sisestame vajalikud kirjed
      self.managePrices;


      primConnection.Commit;
      qryArticles.CommitUpdates;

      // !!!
      self.FDataNotSaved := False;
      self.FNewRecordCreated := False;
      self.FNewArtCode := '';
      self.FNewSrvCode := '';

      btnSave.Enabled := False;
      btnCancel.Enabled := False;
      btnNewArticle.Enabled := True;

      // 09.08.2011 Ingmar
      cmbArtType.Enabled := False;

      // saadame välja teavituse
      if assigned(FFrameDataEvent) then
        FFrameDataEvent(self, __frameArticleDataChanged, -1);

    except
      on E: Exception do
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

procedure TframeArticles.chkboxAllowedInSaleChange(Sender: TObject);
var
  pStatus: AStr;
  pNewSession: boolean;
begin
  with TCheckbox(Sender) do
    if Focused then
      try
        pNewSession := False;
        //@@ muudetakse artikli müügistaatust !
        if Sender = chkboxAllowedInSale then
        begin
          pStatus := qryArticles.FieldByName('status').AsString;
          // @@@
          if not Checked then
            pStatus := stringreplace(pStatus, estbk_types._CArticleCanbeUsedInSale, '', [])
          else
            pStatus := estbk_types._CArticleCanbeUsedInSale;
        end
        else if Sender = chkboxAllowedInweb then
          pStatus := IfThen(Checked, 't', 'f');

        pNewSession := not (qryArticles.State in [dsEdit, dsInsert]);
        if pNewSession then
          qryArticles.Edit;

        if Sender = chkboxAllowedInSale then
          qryArticles.FieldByName('status').AsString := pStatus
        else if Sender = chkboxAllowedInweb then
          qryArticles.FieldByName('disp_web_dir').AsString := pStatus

      finally
        // ---
        if pNewSession then
          qryArticles.Post;
      end;
end;

procedure TframeArticles.cmbArtTypeChange(Sender: TObject);
var
  pNewEdt: boolean;
begin
  if TWinControl(Sender).Focused then
  begin
    // trigger events; siin evendis ei peagi midagi omistama; beforepost event teeb kogu töö !
    pNewEdt := not (qryArticles.state in [dsInsert, dsEdit]);
    if pNewEdt then
    begin
      qryArticles.Edit;
      // teeme midagi teoreetilist ----
      qryArticles.Post;
    end
    else
      self.qryArticlesBeforePost(qryArticles); // meil siiski vaja , et event jookseks läbi !
  end;
end;



procedure TframeArticles.cmbSaleAccClosePopupNotif(Sender: TObject);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeArticles.cmbSaleAccKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Sender is TRxDBLookupCombo then
    estbk_utilities.rxLibKeyDownHelper(Sender as TRxDBLookupCombo, Key, Shift);
end;

procedure TframeArticles.cmbSaleAccKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

// 29.05.2011 Ingmar
{
procedure TframeArticles.cmbSaleAccLookupTitleColClick(column: tcolumn);
begin
  // stAscending, stDescending, stIgnored
  // showmessage('test'+column.FieldName);
  __intUIMiscHelperClass.OnLookupComboTitleClick(Column);
end;
}

procedure TframeArticles.cmbSaleAccSelect(Sender: TObject);
begin
  with  TRxDBLookupCombo(Sender) do
    if (Value <> '') then
    begin
      LookupSource.DataSet.Locate('id', Value, []);
      Text := LookupSource.DataSet.FieldByName('account_coding').AsString;
    end;
end;

procedure TframeArticles.cmbUnitClick(Sender: TObject);
begin
  // --- ikka lazaruse fookuse kalad
  with TDbCombobox(Sender) do
    if not DroppedDown and CanFocus then
      SetFocus;
end;


procedure TframeArticles.addNewUnit(const pUnitName: AStr);
var
  pTemp: AStr;
  pMaxShortIdef: integer;
begin
  with dmodule.tempQuery, SQL do
    try

      Close;
      Clear;
      add(estbk_sqlcollection._SQLGetMaxArticleTypeClassificatorShortId);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      // #1
      pTemp := FieldByName('shortidef').AsString;
      system.Delete(pTemp, 1, 1);

      pMaxShortIdef := strtointDef(pTemp, 0) + 1;

      Close;
      Clear;
      add(estbk_sqlcollection._SQLInsertNewClassificator2);
      paramByname('name').AsString := trim(pUnitName);
      paramByname('shortidef').AsString := format('#%d', [pMaxShortIdef]);
      paramByname('type_').AsString := 'amount_type';
      paramByname('weight').AsInteger := 0;
      paramByname('value').AsString := '';
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      execSQL;
    finally
      Close;
      Clear;
    end; // --
end;

procedure TframeArticles.cmbUnitExit(Sender: TObject);
begin
  with TDbCombobox(Sender) do
    if (trim(Text) <> '') and (items.indexOf(Text) = -1) then
    begin
      if Dialogs.MessageDlg(format(estbk_strmsg.SConfNewArticleUnit, [Text]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        self.addNewUnit(Text);
      items.Add(Text);
    end;
end;

procedure TframeArticles.cmbUnitKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    TCombobox(Sender).DroppedDown := True;
    key := 0;
  end;
end;

procedure TframeArticles.dbEdtDiscountPercExit(Sender: TObject);
var
  pCurrVal: integer;
begin
  with TDbEdit(Sender) do
  begin
    pCurrVal := TDbEdit(Sender).Field.AsInteger;
    if (pCurrVal < 0) or (pCurrVal > 99) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEArtDiscountIsInvalid, mtError, [mbOK], 0);
      if canFocus then
        SetFocus;
    end;
  end;
end;

procedure TframeArticles.dbEdtDiscountPercKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else
    estbk_utilities.edit_verifyNumericEntry((Sender as TCustomEdit), key, False);
end;

procedure TframeArticles.dbObjGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
const
  CCursorDelta = 15;
var
  i: integer;
  prelX: integer;
  pLastCol: integer;
begin
  // -----
  // MouseToCell
  // kas on ikka õiges piirkonnas, et me pilti vahetaks !!!
  prelX := dbObjGrid.Left;
  pLastCol := 0;

  // kuna title click dbgridis ei tööta, siis analüüsime, et mitmes lahter võiks olla
  for i := 0 to dbObjGrid.Columns.Count - 1 do
  begin
    prelX := prelX + dbObjGrid.Columns.Items[i].Width;
    if prelX > X - CCursorDelta then
    begin
      prelX := prelX - dbObjGrid.Columns.Items[i].Width;

      pLastCol := i;
      Break;
    end;
  end;  // Mouse.CursorPos.X;

  if (X >= prelX - 15) and (X < prelX + 24) then
  begin
    // --- 0 staatused
    for i := 0 to dbObjGrid.Columns.Count - 1 do
      dbObjGrid.Columns.Items[i].Title.ImageIndex := estbk_clientdatamodule.img_indxitemUnChecked;


    self.FPActiveTitleIndx := pLastCol;
    self.edtSrc.Text := '';

    if dbObjGrid.Columns.Items[pLastCol].Title.ImageIndex = estbk_clientdatamodule.img_indxitemUnChecked then
      dbObjGrid.Columns.Items[pLastCol].Title.ImageIndex := estbk_clientdatamodule.img_indxitemChecked;
  end;
end;

procedure TframeArticles.dbObjGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  // ---
end;

procedure TframeArticles.dbObjGridPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin
  // ---
end;

procedure TframeArticles.dbObjGridTitleClick(Column: TColumn);
begin
  // BUGI; lazaruses 0.9.29 ei töötam enam ?!!?!?!?!  URRRRRRR
end;



procedure TframeArticles.edtSalePriceAcceptValue(Sender: TObject; var AValue: double; var pAction: boolean);
begin
  // ---
end;

procedure TframeArticles.edtSalePriceChange(Sender: TObject);
var
  pTrigNewEdit: boolean;
begin
  // --- viima red. reziimi
  with TCalcEdit(Sender) do
    if Focused then
    begin
      pTrigNewEdit := not (qryArticles.state in [dsEdit, dsInsert]);
      if pTrigNewEdit then
        qryArticles.Edit;
    end;
end;



procedure TframeArticles.edtSalePriceEnter(Sender: TObject);
begin
  TCalcEdit(Sender).SelectAll;
end;

procedure TframeArticles.edtSalePriceExit(Sender: TObject);
begin
  with TCalcEdit(Sender) do
    if TCalcEdit(Sender).Text <> '' then
    begin
      if strToFloatDef(TCalcEdit(Sender).Text, -1) < 0 then
      begin
        Dialogs.MessageDlg(estbk_strmsg.SEIncorrectInp, mtError, [mbOK], 0);
        if canFocus then
          SetFocus;
      end;
      // ---
    end
    else
      TCalcEdit(Sender).Text := '0';
end;

procedure TframeArticles.edtSalePriceKeyPress(Sender: TObject; var Key: char);
var
  pCPos: integer;
  pCurrVal: AStr;
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else
  if key > #13 then
  begin
    pCurrVal := TCalcEdit(Sender).Text;
    pCPos := pos(',', pCurrVal);
    if pCPos = 0 then
      pCPos := pos('.', pCurrVal);

    // 2 kohta peale koma !
    // ---
    if TCalcEdit(Sender).SelLength = length(TCalcEdit(Sender).Text) then
    begin
      if (key in ['+', '-', '.', ',']) or not (key in ['0'..'9']) then
        key := #0;
    end
    else
    if ((Ord(key) > 32) and (pCPos > 0) and (length(system.copy(pCurrVal, pCPos + 1, (length(pCurrVal) - pCPos) + 1)) = 2)) then
      key := #0
    else
      estbk_utilities.edit_verifyNumericEntry((Sender as TCustomEdit), key, True);
  end;
end;

procedure TframeArticles.edtSrcKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  i: integer;
begin
  if (key = VK_F5) and (Shift = []) then
  begin
    if not (qryArticles.State in [dsEdit, dsInsert]) then
    begin
      qryArticles.Active := False;
      qryArticles.Active := True;
      key := 0;
    end;
  end
  else if (Shift = [ssCtrl]) and (byte(key) in [Ord('1'), Ord('2'), Ord('3')]) then // VK_1
  begin
    for i := 0 to dbObjGrid.Columns.Count - 1 do
      dbObjGrid.Columns.Items[i].Title.ImageIndex := estbk_clientdatamodule.img_indxItemUnChecked;

    case byte(key) of
      Ord('1'): self.FPActiveTitleIndx := 0;
      Ord('2'): self.FPActiveTitleIndx := 1;
      Ord('3'): self.FPActiveTitleIndx := 2;
    end;

    self.edtSrc.Text := '';
    dbObjGrid.Columns.Items[self.FPActiveTitleIndx].Title.ImageIndex := estbk_clientdatamodule.img_indxItemChecked;
    dbObjGrid.Repaint;
  end;
end;

procedure TframeArticles.edtSrcKeyPress(Sender: TObject; var Key: char);
var
  pField: AStr;
begin
  // ennem tuleb ikka tegevus lõpetada !!!
  if (qryArticles.state in [dsEdit, dsInsert]) then
  begin
    Key := #0;
  end
  else if Key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    Key := #0;
  end
  else if self.FPActiveTitleIndx <= dbObjGrid.Columns.Count then
  begin
    pField := TColumn(dbObjGrid.Columns.Items[self.FPActiveTitleIndx]).FieldName;
    estbk_utilities.edit_autoCompData(Sender as TCustomEdit,
      Key,
      qryArticles,
      pField);
  end;
end;

procedure TframeArticles.edtSrcUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
begin
  // ---
end;

procedure TframeArticles.qryArticlesAfterEdit(DataSet: TDataSet);
begin
  self.FDataNotSaved := True;
  btnSave.Enabled := True;
  btnCancel.Enabled := True;

  if not FNewRecordCreated then
    btnNewArticle.Enabled := False;
end;

procedure TframeArticles.qryArticlesAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('vat_id').AsInteger := self.FDefaultVatID;
  // ---
  self.FNewRecordCreated := True;
  self.FDataNotSaved := True;
  cmbArtType.ItemIndex := 0;
end;

procedure TframeArticles.qryArticlesAfterPost(DataSet: TDataSet);
begin
  if self.FNewRecordCreated and not self.FSkipQryEvents then
  begin
    // 13.02.2011 Ingmar
    // jätame meelde kontod, et me ei peaks uue kirjega uuesti samu kontosid lisama
    self.FSaleAccountId := Dataset.FieldByName('sale_account_id').AsInteger;
    self.FPurchAccountId := Dataset.FieldByName('purchase_account_id').AsInteger;
    self.FExcpAccountId := Dataset.FieldByName('expense_account_id').AsInteger;
  end;
end;

function TframeArticles.isInternalItem(const pSpecialFlags: integer): boolean;
begin
  Result := (pSpecialFlags and CArtSpTypeCode_PrepaymentFlag) = CArtSpTypeCode_PrepaymentFlag; // ntx
end;

procedure TframeArticles.validateControlStatuses(const pSpecialFlags: integer);
var
  pAllow: boolean;
begin
  // ---
  pAllow := not self.isInternalItem(pSpecialFlags);

  dbEdtProdCode.Enabled := pAllow;
  dbEdtProdName.Enabled := pAllow;
  //  dbEdtDiscountPerc.Enabled:=pAllow;
  cmbUnit.Enabled := pAllow;
  edtSalePrice.Enabled := pAllow;
  edtPurcPrice.Enabled := pAllow;
  cmbBarCodeTypes.Enabled := pAllow;
  dbEdtDimH.Enabled := pAllow;
  dbEdtDimL.Enabled := pAllow;
  dbEdtDimW.Enabled := pAllow;
  cmbManufacturer.Enabled := pAllow;
  dbRankNr.Enabled := pAllow;

  // -- kontod
  cmbSaleAcc.Enabled := pAllow;
  cmbPurcAcc.Enabled := pAllow;
  cmbCostAcc.Enabled := pAllow;
end;

procedure TframeArticles.qryArticlesAfterScroll(DataSet: TDataSet);
var
  i: TArtType;
  j: integer;
  b: boolean;
begin

  // --- Zeose kala; Delphi all eof siin pole reaalne
  if not Dataset.EOF then
  begin

    // ---- jutt käib müügisummast !!!
    self.FCurrentSalePrice := DataSet.FieldByName('currsale_price').AsFloat;
    self.FCurrentPurcPrice := DataSet.FieldByName('purchase_price').AsFloat;
    self.FCurrentDiscPerc := DataSet.FieldByName('discount_perc').AsFloat;

    // ettemaks jne ka ehk tulevikus transport !
    if self.isInternalItem(DataSet.FieldByName('special_type_flags').AsInteger) then
      cmbArtType.ItemIndex := -1
    else
    begin
      // esmalt hardcoded süsteemsed tüübid !
      if (DataSet.FieldByName('arttype').AsString <> estbk_types._CItemAsUsrDefined) then
      begin
        for i := low(TArtTypeArray) to high(TArtTypeArray) do
          if (DataSet.FieldByName('arttype').AsString = TArtTypeArray[i]) then  // süsteemsed tüübid
            for j := 0 to cmbArtType.items.Count - 1 do
              if TArtClassifData(cmbArtType.items.Objects[j]).FArtType = i then
              begin
                cmbArtType.ItemIndex := j;
                break;
              end;
      end
      else
      begin
        // kasutaja poolt defineeritud !
        for j := 0 to cmbArtType.items.Count - 1 do
          if TArtClassifData(cmbArtType.items.Objects[j]).FArtTypeId = DataSet.FieldByName('arttype_id').AsInteger then
          begin
            cmbArtType.ItemIndex := j;
            break;
          end;
      end;
    end; // ---

    edtSalePrice.Text := format(CCurrentMoneyFmt2, [self.FCurrentSalePrice]);//CurrToStr(self.FCurrentSalePrice);
    edtPurcPrice.Text := format(CCurrentMoneyFmt2, [self.FCurrentPurcPrice]);//CurrToStr(self.FCurrentPurcPrice);

    cmbArtType.Enabled := self.FNewRecordCreated;
    if not cmbArtType.Enabled then
      cmbArtType.Font.Color := clWindowText;


    // 11.09.2010 Ingmar; seoses "special"
    self.validateControlStatuses(DataSet.FieldByName('special_type_flags').AsInteger);

    b := (trim(DataSet.FieldByName('arttype').AsString) <> '') and (pos(estbk_types._CItemAsService,
      DataSet.FieldByName('arttype').AsString) = 0);

    lblArtAmount.Enabled := b;
    edtArtRelAmountTotal.Enabled := b;
    if b then
      self.edtArtRelAmountTotal.Text := floattostr(DataSet.FieldByName('artqty').AsFloat)
    else
      self.edtArtRelAmountTotal.Text := '';

    if not self.FNewRecordCreated then
    begin
      self.FNewArtCode := '';
      self.FNewSrvCode := '';
    end;


    // 10.04.2011 Ingmar
    chkboxAllowedInSale.Checked := pos(estbk_types._CArticleCanbeUsedInSale, qryArticles.FieldByName('status').AsString) > 0;
    chkboxAllowedInSale.Enabled := qryArticles.FieldByName('special_type_flags').AsInteger = 0;

    chkboxAllowedInweb.Checked := IsTrueVal(qryArticles.FieldByName('disp_web_dir').AsString);
    chkboxAllowedInweb.Enabled := chkboxAllowedInSale.Enabled;
  end; // ---
end;

// abort exception välistab scrolli
procedure TframeArticles.verifyData;
var
  pCurrPerc: integer;
begin
  //    qryArticles.fieldByname('currsale_price').asFloat
  //    qryArticles.fieldByname('purchase_price').asFloat

  if length(trim(qryArticles.FieldByName('artname').AsString)) < 1 then
  begin
    Dialogs.messageDlg(estbk_strmsg.SENameIsMissing, mtError, [mbOK], 0);
    if dbEdtProdName.canFocus then
      dbEdtProdName.SetFocus;
    abort;
  end;

  // 14.05.2011 Ingmar; see allahindluse % ajas kuulid kokku
  {
      pCurrPerc:=qryArticles.fieldByname('discount_perc').asInteger;
  if (pCurrPerc<>0) and ((pCurrPerc<0) or (pCurrPerc>99)) then
    begin
       dialogs.messageDlg(estbk_strmsg.SEArtDiscountIsInvalid,mtError,[mbOk],0);
    if dbEdtDiscountPerc.canFocus then
       dbEdtDiscountPerc.setFocus;
    end;
  }


  // ----
  with qryVerifData, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLVerifArtCode);
      paramByname('artcode').AsString := qryArticles.FieldByName('artcode').AsString;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;


      // kood juba olemas !!!
      if not EOF and (FieldByName('id').AsInteger <> qryArticles.FieldByName('id').AsInteger) then
      begin
        Dialogs.messageDlg(format(estbk_strmsg.SEArtCodeExists, [qryArticles.FieldByName('artcode').AsString]),
          mtError,
          [mbOK],
          0);
        if dbEdtProdCode.canFocus then
          dbEdtProdCode.SetFocus;
        abort;
      end;
    finally
      Close;
      Clear;
    end;
end;


function TframeArticles.autoGenerateItemCode(const pitemType: AStr; const pCurrentArtCode: AStr; const pTypeChanged: boolean = False): AStr;

  function addZItems(const pAskUniqVal: AStr): AStr;
  const
    CZNrCount = 5;
  begin
    Result := pAskUniqVal;
    if length(Result) < CZNrCount then
      Result := pitemType + stringofchar('0', CZNrCount - length(Result)) + Result;
  end;

begin
  Result := '';

  // juhul, kui kasutaja on enda koodi pannud siis jätame selle vahele
  if (trim(pCurrentArtCode) <> '') and pTypeChanged then
  begin

    if (self.FNewArtCode <> '') and (trim(pCurrentArtCode) <> self.FNewArtCode) and (self.FNewSrvCode <> '') and
      (trim(pCurrentArtCode) <> self.FNewSrvCode) then
      // säilitame originaalkoodi !
    begin
      Result := pCurrentArtCode;
      Exit;
    end;
  end;

  // alustame koode nii: 0001; strcase tuleb alles FPC 2.3.0
  with estbk_clientdatamodule.dmodule do
    if pitemType = _CItemAsProduct then
    begin
      // et koodi pidevalt uuesti ei looks !
      if self.FNewArtCode = '' then
      begin
        Result := addZItems(getUniqNumberFromNumerator(PtrUInt(self), '', now, False, estbk_types.CProd_sr_nr));
        self.FNewArtCode := Result;
      end
      else
        Result := self.FNewArtCode;
    end
    else if pitemType = _CItemAsService then
    begin
      if self.FNewSrvCode = '' then
      begin
        Result := addZItems(getUniqNumberFromNumerator(PtrUInt(self), '', now, False, estbk_types.CSrv_sr_nr));
        self.FNewSrvCode := Result;
      end
      else
        Result := self.FNewSrvCode;
    end
    else if pitemType = _CItemAsWProduct then
    begin
      Result := addZItems(getUniqNumberFromNumerator(PtrUInt(self), '', now, False, estbk_types.CWProc_sr_nr));
    end;
end;

procedure TframeArticles.qryArticlesBeforePost(DataSet: TDataSet);
//var
// pArtTypeNChg : Boolean;
begin
  //if not self.FSkipQryEvents then
  with DataSet do
  begin
    case self.FNewRecordCreated of
      True:
      begin
        FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        FieldByName('company_id').AsInteger := estbk_globvars.glob_company_id;
      end;

      False:
      begin
        FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      end;
    end; // ---

    // --- märgime tüübi ka ära
    if cmbArtType.ItemIndex >= 0 then
    begin
      FieldByName('arttype').AsString := TArtTypeArray[TArtClassifData(cmbArtType.items.Objects[cmbArtType.ItemIndex]).FArtType];
      FieldByName('arttype_id').AsInteger := TArtClassifData(cmbArtType.items.Objects[cmbArtType.ItemIndex]).FArtTypeId;
    end;


    FieldByName('rec_changed').AsDateTime := now;
    // -- väldime probleeme
    if FieldByName('discount_perc').IsNull then
      FieldByName('discount_perc').AsInteger := 0;

    if FieldByName('barcode_def_id').IsNull then
      FieldByName('barcode_def_id').AsInteger := 0;



    // süsteemse "artikli" puhul ei tohi koodi ega tüüpi muuta !
    if not self.isInternalItem(FieldByName('special_type_flags').AsInteger) then
    begin
      // ZEOS'e bugi, annab siis tühja dataseti puhul listindex of bounds
      // TODO loogika täiesti ei tööta veel
      // Tüüp vahetus ärme anna koodi veel !
      {
            pArtTypeNChg:=false;
        if  dataset.RecordCount>=1 then
            pArtTypeNChg:= (fieldByname('arttype').OldValue<>null) and
                           (fieldByname('arttype').Value<>null) and
                           (trim(vartostr(fieldByname('arttype').OldValue))<>trim(vartostr(fieldByname('arttype').Value)));
         or  pArtTypeNChg
      }

      // kui artikli koodi pole, siis lisame selle automaatselt või korrigeerime !
      if not cmbArtType.focused and ((trim(FieldByName('artcode').AsString) = '') and (length(FieldByName('arttype').AsString) > 0)) then
        FieldByName('artcode').AsString := self.autoGenerateItemCode(FieldByName('arttype').AsString, FieldByName('artcode').AsString);
      // pArtTypeNChg
    end;  // ---

    if FieldByName('purchase_account_id').isnull then
      FieldByName('purchase_account_id').AsInteger := 0;

    if FieldByName('sale_account_id').isnull then
      FieldByName('sale_account_id').AsInteger := 0;

    if FieldByName('expense_account_id').isnull then
      FieldByName('expense_account_id').AsInteger := 0;

    FieldByName('currsale_price').AsFloat := strtofloatdef(edtSalePrice.Text, 0);
    FieldByName('purchase_price').AsFloat := strtofloatdef(edtPurcPrice.Text, 0);
  end;
end;

procedure TframeArticles.qryArticlesBeforeScroll(DataSet: TDataSet);
begin
  if not self.FSkipQryEvents and self.FDataNotSaved then
    self.verifyData;
end;


function TframeArticles.getDataLoadStatus: boolean;
begin
  Result := qryArticles.active;
end;

procedure TframeArticles.setDataLoadStatus(const v: boolean);
var
  sql: String;
begin
  qryArtInsUpdt.ModifySQL.Clear;
  qryArtInsUpdt.InsertSQL.Clear;

  qryArticles.Close;
  qryArticles.SQL.Clear;

  qryVAT.Close;
  qryVAT.SQL.Clear;

  qrySaleAccounts.Close;
  qrySaleAccounts.SQL.Clear;

  qryPurcAccounts.Close;
  qryPurcAccounts.SQL.Clear;

  qryExpensesAccounts.Close;
  qryExpensesAccounts.SQL.Clear;


  if v then
  begin
    pageCtrlArt.ActivePage := pageArtMainData;


    qryArticles.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryVerifData.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryArticlesSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qrySavePriceChanges.Connection := estbk_clientdatamodule.dmodule.primConnection;
    //qrySavePriceChangesSeq.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryVAT.Connection := estbk_clientdatamodule.dmodule.primConnection;

    qrySaleAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryPurcAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
    qryExpensesAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;

    // TODO; Leiutada workaround Zeose bugile, kui on mitu samasuguse nimega parameetrit, siis ta VAID täidab esimesed
    // Fiks Zeose parameetrite bugile !
    sql := estbk_sqlclientcollection._SQLGetArticles;
    sql := StringReplace(sql, ':company_id', IntToStr(estbk_globvars.glob_company_id), [rfReplaceAll]);
    sql := StringReplace(sql, ':warehouse_id', IntToStr(FWareHouseId), [rfReplaceAll]);
    qryArticles.SQL.Add(sql);
    // qryArticles.paramByname('warehouse_id').AsInteger := self.FWareHouseId;
    // qryArticles.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;


    qryVAT.SQL.Add(estbk_sqlclientcollection._CSQLGetVAT);
    qryVAT.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qrySaleAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetOpenAccounts);
    qryPurcAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetOpenAccounts);
    qryExpensesAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetOpenAccounts);

    qrySaleAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryPurcAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryExpensesAccounts.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;


    // ----
    qryArtInsUpdt.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdateArticles);
    qryArtInsUpdt.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertArticle);


    // valikud aktiivseks
    self.fillComboItems;


    try
      self.FSkipQryEvents := True;
      // --
      qrySaleAccounts.active := v;
      qryPurcAccounts.active := v;
      qryExpensesAccounts.active := v;

      // 12.03.2011 Ingmar
      qryArticles.active := v;


      //qryArticles.Filtered:=false;
      //qryArticles.Filter:='special_type_flags=0';
      //qryArticles.Filtered:=true;

      // ---
      estbk_utilities.changeWCtrlEnabledStatus(panelRight, not qryArticles.EOF, 0);
      estbk_utilities.changeWCtrlEnabledStatus(pageArtMainData, not qryArticles.EOF, 0);


      panelRight.Enabled := True;
      cmbVatLookup.ListFieldIndex := 0;

    finally
      self.FSkipQryEvents := False;
    end;


    // -----
    // laeme viimati kasutatud kontod !
    with qryVerifData, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLLastArticleAccounts);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;




        self.FSaleAccountId := FieldByName('sale_account_id').AsInteger;
        self.FPurchAccountId := FieldByName('purchase_account_id').AsInteger;
        self.FExcpAccountId := FieldByName('expense_account_id').AsInteger;
      finally
        Close;
        Clear;
      end;

    // paneme paika algseaded artiklil ! ntx combo tüüp jne
    qryArticlesAfterScroll(qryArticles);

    // -------
  end
  else
  begin
    qryArticles.Connection := nil;
    qryVerifData.Connection := nil;
    qryArticlesSeq.Connection := nil;
    qrySavePriceChanges.Connection := nil;
    qryVAT.Connection := nil;
    qrySaleAccounts.Connection := nil;
    qryPurcAccounts.Connection := nil;
    qryExpensesAccounts.Connection := nil;
  end;
end;



initialization
  {$I estbk_fra_articles.ctrs}
end.