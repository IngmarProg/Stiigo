unit estbk_frame_chooseaddr;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Dialogs, StdCtrls,
  ZConnection, ZDataset, ZSequence, ZSqlUpdate,
  estbk_sqlcollection, estbk_customdialogsform, estbk_fra_template,
  estbk_types, contnrs, Graphics, DB, Controls, LCLType;

type
  TFrameAddrPicker = class(TFrame)
    comboStreet: TComboBox;
    comboCounty: TComboBox;
    comboCity: TComboBox;
    lbCounty: TLabel;
    lbCity: TLabel;
    lbStreet: TLabel;
    qryCounty: TZQuery;
    qryCity: TZQuery;
    qryStreet: TZQuery;
    qryCountySeq: TZSequence;
    qryCitySeq: TZSequence;
    qryStreetSeq: TZSequence;
    qryInsertCounty: TZUpdateSQL;
    qryInsertCity: TZUpdateSQL;
    qryInsertStreet: TZUpdateSQL;
    procedure comboCityKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure comboCountyEnter(Sender: TObject);
    procedure comboCountyExit(Sender: TObject);
    procedure comboCountyKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure comboCountyKeyPress(Sender: TObject; var Key: char);
    procedure comboCountySelect(Sender: TObject);
    procedure qryCountyBeforePost(DataSet: TDataSet);
  protected
    //FConnection : TZConnection;
    FLiveMode: boolean;
    FDataLoaded: boolean;
    FCountry: AStr;
    FCountyId: integer;
    FCityId: integer;
    FStreetId: integer;
    FHideNextConfirm: boolean;
    FDataChanged: TNotifyEvent;
    // 06.09.2011 Ingmar
    FLastKeyTabOrEnter: boolean;
    function getConnection: TZConnection;
    procedure setConnection(const v: TZConnection);
    procedure setLiveMode(const v: boolean);
    procedure setValAndLoadData(const v: boolean);

    procedure fillComboStList(const pCombo: TCombobox; const pQry: TZQuery);
    // -----------
    procedure setCountry(const v: AStr);
    procedure setCountyId(const v: integer);
    procedure setCityId(const v: integer);
    procedure setStreetId(const v: integer);
    // ---- !!! 29.11.2009 Ingmar; muidu oli kole, kui enabled=false; aga aadressivalik oli ikka valge !!!
    procedure SetEnabled(AValue: boolean); override;
    function GetEnabled: boolean; override;

  public

    // filter riigi kaupa; hetkel framest eraldi; TODO: viia kokku riikide valiku osaga
    property Enabled; // read GetEnabled write SetEnabled default  false; // : Boolean read GetEnabled write SetEnabled;

    property country: AStr read FCountry write setCountry;
    property countyId: integer read FCountyId write setCountyId;
    property cityId: integer read FCityId write setCityId;
    property streetId: integer read FStreetId write setStreetId;

    property connection: TZConnection read getConnection write setconnection;
    property liveMode: boolean read FLiveMode write setLiveMode;
    // kui puudub  maakond/linn/tänav siis lisatakse kohe baasi
    property loadData: boolean read FDataLoaded write setValAndLoadData default False;
    property onDataChange: TNotifyEvent read FDataChanged write FDataChanged;
    // --
    property LastKeyTabOrEnter: boolean read FLastKeyTabOrEnter;
    constructor Create(frameOwner: TComponent); override;

  end;


implementation


uses estbk_dbcompability, estbk_strmsg, estbk_globvars;

constructor TFrameAddrPicker.Create(frameOwner: TComponent);
begin

  inherited Create(frameOwner);



  Enabled := True;
  FDataLoaded := False;
  //FLiveMode:=true;

  // SQL paika
  qryCounty.SQL.add(estbk_sqlcollection._SQLCountyList());
  qryCity.SQL.add(estbk_sqlcollection._SQLCityList());
  qryStreet.SQL.add(estbk_sqlcollection._SQLStreetList());

  qryInsertCounty.insertSQL.add(estbk_sqlcollection._SQLInsertCounty);
  qryInsertCity.insertSQL.add(estbk_sqlcollection._SQLInsertCity);
  qryInsertStreet.insertSQL.add(estbk_sqlcollection._SQLInsertStreet);

  // 25.08.2009 ingmar ...väga sürr; runtimes kaotatakse mõnikord tag ära; lazaruse bugi ?!?
  comboCounty.tag := 1;
  comboCity.tag := 2;
  comboStreet.tag := 3;

  FCountyId := 0;
  FCityId := 0;
  FStreetId := 0;
  connection := nil;

  // 25.02.2014 Ingmar
  estbk_fra_template.translateObject(self);
end;

procedure TFrameAddrPicker.setCountry(const v: AStr);
begin
  FCountry := v;
  if v = '' then
    FCountry := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;

  qryCounty.filtered := False;
  qryCounty.filter := format('countrycode=''%s''', [v]);
  qryCounty.filtered := True;

  qryCity.filtered := False;
  qryCity.filter := format('countrycode=''%s''', [v]);
  qryCity.filtered := True;

  qryStreet.filtered := False;
  qryStreet.filter := format('countrycode=''%s''', [v]);
  qryStreet.filtered := True;


  countyId := 0;
  cityId := 0;
  streetId := 0;

  // uuesti laeme combode sisud !
  fillComboStList(comboCounty, qryCounty);
  fillComboStList(comboCity, qryCity);
  fillComboStList(comboStreet, qryStreet);



  //  if assigned(FDataChanged) then
  //     FDataChanged(self);
end;

procedure TFrameAddrPicker.setCountyId(const v: integer);
var
  FFound: boolean;
  FItemIdx: integer;
begin
  if v = 0 then
  begin
    FCountyId := 0;
    comboCounty.ItemIndex := -1;
    comboCounty.Text := '';
  end
  else
  if qryCounty.active then
  begin

    FFound := qryCounty.Locate('id', v, []);
    FItemIdx := comboCounty.Items.IndexOf(qryCounty.FieldByName('name').AsString);

    FFound := FFound and (FItemIdx >= 0);
    if FFound then
    begin
      FCountyId := v;
      comboCounty.ItemIndex := FItemIdx;
    end
    else
      assert(1 = 0, SEDataError + #32 + qryCounty.Filter + '(' + IntToStr(v) + ')'); // seda olukorda ei tohiks normaaltingimustel tekkida !!!
  end;
end;

procedure TFrameAddrPicker.setCityId(const v: integer);
var
  FFound: boolean;
  FItemIdx: integer;
begin
  if v = 0 then
  begin
    FCityId := 0;
    comboCity.ItemIndex := -1;
    comboCity.Text := '';
  end
  else
  if qryCity.active then
  begin
    FFound := qryCity.Locate('id', v, []);
    FItemIdx := comboCity.Items.IndexOf(qryCity.FieldByName('name').AsString);

    FFound := FFound and (FItemIdx >= 0);
    if FFound then
    begin
      FCityId := v;
      comboCity.ItemIndex := FItemIdx;
    end
    else
      assert(1 = 0, SEDataError + #32 + qryCity.filter + '(' + IntToStr(v) + ')');
  end;
end;

procedure TFrameAddrPicker.setStreetId(const v: integer);
var
  FFound: boolean;
  FItemIdx: integer;
begin
  if v = 0 then
  begin
    FStreetId := 0;
    comboStreet.ItemIndex := -1;
    comboStreet.Text := '';
  end
  else
  if qryStreet.active then
  begin
    FFound := qryStreet.Locate('id', v, []);
    FItemIdx := comboStreet.Items.IndexOf(qryStreet.FieldByName('name').AsString);
    FFound := FFound and (FItemIdx >= 0);
    if FFound then
    begin
      FStreetId := v;
      comboStreet.ItemIndex := FItemIdx;
    end
    else
      assert(1 = 0, SEDataError + #32 + qryStreet.Filter + '(' + IntToStr(v) + ')');
  end;
end;

procedure TFrameAddrPicker.SetEnabled(AValue: boolean);
const
  pdColor: array[boolean] of TColor = (clBtnFace, clWindow);
begin

  comboStreet.Enabled := AValue;
  comboStreet.Color := pdColor[AValue];

  comboCounty.Enabled := AValue;
  comboCounty.Color := pdColor[AValue];

  comboCity.Enabled := AValue;
  comboCity.Color := pdColor[AValue];

  inherited setEnabled(AValue);
end;

function TFrameAddrPicker.GetEnabled: boolean;
begin
  Result := inherited GetEnabled;
end;

procedure TFrameAddrPicker.comboCountyExit(Sender: TObject);
// FindNextControl
var
  FItemFound: boolean;
  FUseQry: TZQuery;
  FCmb: TCombobox;
  FLiveItem: AStr;
  FTempID: integer;
  // FItemIndex : Integer;
begin
  // --- sisuliselt kui live mode tabeli täitmine siis kohe ka BAASI !!!!!! ideaalmaailmas on admin eelnevalt tabelid ära täitnud
  FUseQry := nil;
  FCmb := TComboBox(Sender);
  case FCmb.tag of
    1:
    begin
      FCountyId := 0;
      FUseQry := qryCounty;
    end;

    2:
    begin
      FCityID := 0;
      FUseQry := qryCity;
    end;

    3:
    begin
      FStreetId := 0;
      FUseQry := qryStreet;

    end;
  end;

  if trim(FCmb.Text) = '' then
  begin
    // 08.08.2011 Ingmar; aga järsku kustutati tänav ära !!!
    if assigned(FDataChanged) then
      FDataChanged(Sender);
    exit;
  end;


  // ---------
  FItemFound := FCmb.Items.indexOf(trim(FCmb.Text)) <> -1;
  if not FItemFound then
  begin

    if not liveMode then
    begin
      case FCmb.tag of
        1:
        begin // maakonnad
          messageDlg(format(SECountyNotFound, [FCmb.Text]), mtError, [mbOK], 0);
        end;

        2:
        begin // linn
          messageDlg(format(SECityNotFound, [FCmb.Text]), mtError, [mbOK], 0);
        end;

        3:
        begin // tänav
          messageDlg(format(SEStreetNotFound, [FCmb.Text]), mtError, [mbOK], 0);
        end;
      end;

      // ----
      FCmb.SelectAll;

      if FCmb.CanFocus then
        FCmb.SetFocus;
    end
    else // LIVE !!!
    if assigned(FUseQry) then
      try

        if not estbk_customdialogsform.simpleYesNoDialogExt(estbk_strmsg.SConfirm, estbk_strmsg.SDoWeAddnewAddrEntry, True, FHideNextConfirm) then
        begin
          // ...antud juhul ei osa midagi targemat teha, kui väljuda ja eeldada, et kasutaja valib uuesti...
          FCmb.Text := '';

          if FCmb.CanFocus then
            FCmb.SetFocus;
          // ---
          exit;
        end;


        // TODO; cached updates pole siin küll mõistlik, otse write teha !!!!
        FUseQry.connection.StartTransaction;
        FUseQry.insert;
        FUseQry.FieldByName('name').AsString := trim(FCmb.Text);
        FUseQry.applyUpdates;
        FUseQry.commitUpdates;
        // ----
        FUseQry.connection.Commit;


        FLiveItem := FCmb.Text;
        FCmb.Items.add(FLiveItem);
        FCmb.Sorted := True;
        FCmb.Text := FLiveItem;
        // exiti puhul onchange muutmine pole eriti arukas !

        //FCmb.ItemIndex:=FItemIndex;
        // ----- usalda, aga kontrolli...
        assert((FUseQry.FieldByName('id').AsInteger > 0) and (FUseQry.FieldByName('name').AsString = FCmb.Text), 'Failure  !');
        case FCmb.tag of
          1:
          begin
            FCountyId := FUseQry.FieldByName('id').AsInteger;
          end;

          2:
          begin
            FCityID := FUseQry.FieldByName('id').AsInteger;
          end;

          3:
          begin
            FStreetId := FUseQry.FieldByName('id').AsInteger;
          end;
        end;


        if assigned(FDataChanged) then
          FDataChanged(Sender);

        // ----
      except
        on e: Exception do
        begin
          if FUseQry.connection.InTransaction then
            try
              FUseQry.connection.Rollback;
            except
            end;

          messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
        end;
      end;
  end
  else
    // -------- üritame leida siis selle õige...id siis
  begin

    if FUseQry.Locate('name', FCmb.Text, [loCaseInsensitive]) then
      case FCmb.tag of
        1:
        begin
          FTempID := FCountyId;
          FCountyId := FUseQry.FieldByName('id').AsInteger;
          if assigned(FDataChanged) and (FCountyId <> FTempID) then
          begin
            FDataChanged(Sender);
          end;
          // ---
        end;

        2:
        begin
          FTempID := FCityID;
          FCityID := FUseQry.FieldByName('id').AsInteger;
          if assigned(FDataChanged) and (FCityID <> FTempID) then
            FDataChanged(Sender);
        end;

        3:
        begin
          FTempID := FStreetId;
          FStreetId := FUseQry.FieldByName('id').AsInteger;
          if assigned(FDataChanged) and (FStreetId <> FTempID) then
            FDataChanged(Sender);
        end;
      end
    else
      raise Exception.Create(SELocationResolveError);
  end; // ---
end;

procedure TFrameAddrPicker.comboCountyEnter(Sender: TObject);
begin
  FLastKeyTabOrEnter := False;
end;

procedure TFrameAddrPicker.comboCityKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  FLastKeyTabOrEnter := (key = VK_TAB) or (key = VK_RETURN);
end;


procedure TFrameAddrPicker.comboCountyKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  FLastKeyTabOrEnter := (key = VK_TAB) or (key = VK_RETURN);
  // jätan ka imelise andmete refreshimine võimaluse...
  if key = VK_F5 then
  begin

    case TCombobox(Sender).tag of
      1:
      begin
        FCountyId := 0;
        //  ..tõsiselt kõige lollikindlam tee...
        qryCounty.active := False;
        qryCounty.active := True;
        fillComboStList(TCombobox(Sender), qryCounty);
      end;

      2:
      begin
        FCityId := 0;
        qryCity.active := False;
        qryCity.active := True;
        fillComboStList(TCombobox(Sender), qryCity);
      end;

      3:
      begin
        FStreetId := 0;
        qryStreet.active := False;
        qryStreet.active := True;
        fillComboStList(TCombobox(Sender), qryStreet);
      end;
    end;

    key := 0;
  end;
end;

procedure TFrameAddrPicker.comboCountyKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    key := #0;
  end;
  // ---
end;

// 08.08.2011 Ingmar
procedure TFrameAddrPicker.comboCountySelect(Sender: TObject);
begin
  if TComboBox(Sender).focused and assigned(FDataChanged) then
    comboCountyExit(Sender);
end;

procedure TFrameAddrPicker.qryCountyBeforePost(DataSet: TDataSet);
var
  pCountry: AStr;

begin
  Dataset.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  Dataset.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
  Dataset.FieldByName('rec_changed').AsDateTime := now;

  pCountry := FCountry;
  if pCountry = '' then
    pCountry := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;

  Dataset.FieldByName('countrycode').AsString := pCountry;
end;

function TFrameAddrPicker.getConnection: TZConnection;
begin
  Result := qryCounty.Connection as TZConnection;
end;

procedure TFrameAddrPicker.setConnection(const v: TZConnection);
begin
  //FConnection:=v;
  qryCounty.Connection := v;
  qryCity.Connection := v;
  qryStreet.Connection := v;
  qryCountySeq.Connection := v;
  qryCitySeq.Connection := v;
  qryStreetSeq.Connection := v;
end;

// reserveeritud
procedure TFrameAddrPicker.setLiveMode(const v: boolean);
begin
  FLiveMode := v;
end;

procedure TFrameAddrPicker.setValAndLoadData(const v: boolean);
begin

  if FDataLoaded = v then
    exit;

  qryCounty.Active := v;
  qryCity.Active := v;
  qryStreet.Active := v;
  // ---
  FDataLoaded := v;

  // laeme andmed...
  if v then
  begin
    country := estbk_globvars.Cglob_DefaultCountryCodeISO3166_1;
    // kasutame ka puhvreid !
    fillComboStList(comboCounty, qryCounty);
    fillComboStList(comboCity, qryCity);
    fillComboStList(comboStreet, qryStreet);
  end;
end;

procedure TFrameAddrPicker.fillComboStList(const pCombo: TCombobox; const pQry: TZQuery);
begin
  // --
  pCombo.Clear;
  pCombo.Text := '';
  pCombo.ItemIndex := -1;

  pQry.First;
  while not pQry.EOF do
  begin
    pCombo.Items.Add(trim(pQry.FieldByName('name').AsString));
    pQry.Next;
  end;

  pQry.First;
end;

initialization
  {$I estbk_frame_chooseaddr.ctrs}
end.