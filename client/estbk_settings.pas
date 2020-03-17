unit estbk_settings;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}


interface

uses
  {$IFNDEF NOGUI}
  Graphics,
  {$ENDIF}
  Classes, SysUtils, estbk_types;

// esimene osa reserveeritud ntx. viimane kasutamata arve nr / maksekorralduse nr. võima neid uuesti võtta !
type
  TStsIndex = (

    // -----------------------------
    Csts_nothing = 0,
    // -----------------------------
    // SPECIAL range kõikide firma kasutajate seas on see ühine !
    // arve loomisel broneeritakse talle seeria nr, jätame meelde
    Csts_reserved1_id = 1, // arve kande NR !

    Csts_rsv_salebillnr = 2,
    Csts_rsv_purchbillnr = 3,
    Csts_rsv_prepaymentbillnr = 4,
    Csts_rsv_creditbillnr = 5,
    Csts_rsv_overduebillnr = 6, // viivisarve

    Csts_rsv_generalledger = 7, // pearaamatu seeria nr
    Csts_rsv_offernr = 8,      // pakkumise nr
    Csts_rsv_ordernr = 9,      // ostutellimuse nr
    Csts_rsv_saleornr = 10,     // müügitellimuse nr

    Csts_rsv_Pmordernr = 11,     // (payment order)maksekorralduse nr
    Csts_rsv_CashRegnr = 12,     // kassa numbriseeria
    Csts_rsv_GenLedgerAccnr = 13, // pearaamatu mooduli viimase kande nr peab meelde jätma !

    Csts_rsv_IncAccnr_id = 14, // laekumise kande nr ka meelde jätta !
    Csts_reserved15_id = 15,
    Csts_reserved16_id = 16,
    Csts_reserved17_id = 17,
    Csts_reserved18_id = 18,
    Csts_reserved19_id = 19,
    Csts_reserved20_id = 20,

    // -- special range ends !
    // --
    Csts_downloadlatestCurrRates = 16, // kas programmi käivitamisel alati laeme valuutakursid

    Csts_vis_labelColors = 17, // programmis labelite värvus
    Csts_vis_activeGridEditColor = 18, // millist värvi on celleditori tagataust
    Csts_vis_itemTypeAsBillColor = 19, // rea värvus, mis näitab, et tegemist arvega
    Csts_vis_itemTypeAsOrderColor = 20, // rea värvus, mis näitab, et tegemist tellimusega
    Csts_vis_unConfirmedItemsColor = 21, // kinnitamata ridade värvus; ntx arved / tasumised / kassa maksed jne
    Csts_vis_billRvrVatCellColor = 22, // arvetel pöördkäibemaksu lahtri värvus

    // -- välimus
    Csts_forms_as_sdi = 23,
    // enamasti on programm MDI reziimis multi document interface; mõnikord SDI on parem single document interface

    // -- epost / smtp
    Csts_use_mapi = 24,
    Csts_email_addr = 25,
    Csts_smtp_srv = 26,
    Csts_smtp_port = 27,
    Csts_smtp_authmethod = 28,
    Csts_smtp_username = 29,
    Csts_smtp_password = 30,

    // vaikimisi seaded; laek. / tasumiste vormidel pannakse need vaikimisi kontodeks
    CstsDefaultIncAcc = 31,
    CstsDefaultPmtAcc = 32,
    CstsShowObjFieldInBillLines = 33, // kas arve ridadel kuvada objekti valikut !
    // --- 01.09.2011 Ingmar; sooviti ka meilisaatja nime !
    Csts_email_sendername = 34,
    // 11.04.2013 Ingmar
    Csts_bill_rep_templatename = 35,
    // 23.02.2014 Ingmar
    Csts_active_language = 36,
    // 20.04.2015 Ingmar; kuvatakse auto KM tagastusega seotud lahtrit
    CstsShowVATReturnFieldInBillLines = 37, // kas arve ridadel kuvada objekti valikut !
    // -----------------------------
    Csts_arr_end = 38
    // -----------------------------
    );

type
  TUserStsValues = array[TStsIndex] of AStr;


// ----------------------------------------------------------------------------
// seoses vista/windows 7 on targem kasutajaseadeid hoida andmebaasis !
// ----------------------------------------------------------------------------

type
  TUserFavColors = (uvc_labelColors, // kõikide labelite värv, olgu frame või vorm
    uvc_activeGridEditorColor, // TStringGridEditori tagatausta värvus
    uvc_itemTypeAsOrderColor,  // maksekorralduses maksmata tellimuse värvus
    uvc_itemTypeAsBillColor,   // maksekorralduses maksmata arve värvus
    uvc_gridColorForUnconfirmedItems,       // kinnitamata tellimuste värvus
    uvc_gridColorForBillRvrVatCell          // arvete lahtrite värvus, kus on pöördkäibemaksu summa
    );

{$IFNDEF NOGUI}
type
  TUserColor = array[TUserFavColors] of TColor;
{$ENDIF}


// WRAPPER kasutaja seadetele; tarkvaras tüütu otse lugeda kasutaja seadeid ja siis str väärtus parsida kõikjal !
type
  TUserSettings = class
  protected
    FUsersStsValues: TUserStsValues;
    FshowWndAsModal: boolean;
    FBoldDataLabels: boolean;
    {$IFNDEF NOGUI}
    FUserColors: TUserColor;
    {$ENDIF}

    procedure setBoldLabelsStatus(const v: boolean);
    {$IFNDEF NOGUI}
    procedure setUvcColor(v: TUserFavColors; c: TColor);
    function getUvcColor(v: TUserFavColors): TColor;
    {$ENDIF}
  public
    // property    lbFontColor    : TColor  read FFontColor write setLbFontColor default clWindowText;
    property boldDataLabels: boolean read FBoldDataLabels write setBoldLabelsStatus default False;
    // -- aktiivsed TStringGridEditorid siis seda värvi !
    {$IFNDEF NOGUI}
    property uvc_colors[index: TUserFavColors]: TColor read getUvcColor write setUvcColor;
    {$ENDIF}
    // akende "disain"
    property showWndAsModal: boolean read FshowWndAsModal write FshowWndAsModal;
    constructor Create(const pUserStsValues: TUserStsValues); reintroduce;
    destructor Destroy; override;
  end;

implementation

{$IFNDEF WEBSERVICE}
uses estbk_clientdatamodule;

{$ENDIF}

constructor TUserSettings.Create(const pUserStsValues: TUserStsValues);

{$IFNDEF NOGUI}
  // ---
  function pGetColor(const stsVal: TStsIndex; const defaultColor: TColor): TColor;
  begin
    Result := defaultColor;
    if Trim(FUsersStsValues[stsVal]) <> '' then
      Result := strtointdef(FUsersStsValues[stsVal], 0);
  end;

{$ENDIF}

begin
  inherited Create;

  FUsersStsValues := pUserStsValues;

  {$IFNDEF NOGUI}
  FUserColors[uvc_labelColors] := pGetColor(Csts_vis_labelColors, clWindowText);
  FUserColors[uvc_activeGridEditorColor] := pGetColor(Csts_vis_activeGridEditColor, clWindow);

  FUserColors[uvc_itemTypeAsBillColor] := pGetColor(Csts_vis_itemTypeAsBillColor, ClInfobk);
  // arve ridu kuvatakse sellise värviga; maksekorraldus / laekumised
  FUserColors[uvc_itemTypeAsOrderColor] := pGetColor(Csts_vis_itemTypeAsOrderColor, estbk_types.MyFavYellowGreen);
  // tellimuse ridu kuvatakse sellise värviga; maksekorraldus / laekumised

  FUserColors[uvc_gridColorForUnconfirmedItems] := pGetColor(Csts_vis_unConfirmedItemsColor, clInfobk);
  FUserColors[uvc_gridColorForBillRvrVatCell] := pGetColor(Csts_vis_BillRvrVatCellColor, clInfobk);
  {$ENDIF}
  // #FEF4D4
  self.FshowWndAsModal := False;
end;

destructor TUserSettings.Destroy;
begin
  inherited Destroy;
end;

procedure TUserSettings.setBoldLabelsStatus(const v: boolean);
begin
  FBoldDataLabels := v;
end;

{$IFNDEF NOGUI}
procedure TUserSettings.setUvcColor(v: TUserFavColors; c: TColor);
begin
  FUserColors[v] := c;
end;

function TUserSettings.getUvcColor(v: TUserFavColors): TColor;
begin
  Result := FUserColors[v];
end;

{$ENDIF}
end.
