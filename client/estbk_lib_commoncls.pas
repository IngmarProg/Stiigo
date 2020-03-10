unit estbk_lib_commoncls;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
{$TYPEINFO ON}

interface

uses
   {$IFNDEF NOGUI}
  Grids, Dialogs,
   {$ENDIF}
  typinfo, Contnrs, Classes, SysUtils, estbk_types, estbk_strmsg;


// TASUMISED / KASSA siiski hoiame eraldi moodulites, kuigi kood 90% sarnane !
type
  TMarkIncItems = (cMarkBillPayment, cMarkOrderPayment);


type
  TPaymentAction = (cAddPaymentSum, cRemovePaymentSum, cUpdatePaymentSum);


type
  TTrackItemChanges = class(TCollectionItem)
  public
    FItemId: integer;
    FItemType: AStr;
    FChangeType: TPaymentAction;
    FPrevSum: currency;
    FNewSum: currency;
  end;



// DEKL. ARVUTUSED
type
  TTaxdParsedAccounts = class(TCollectionItem)
  public
    FOrigOrder: integer; // algne asukoht valemis; vajalik algseisu taastamisel;
    // muidu indeksite järgi andmete asendamine valemis enam ei toimu
    // alustatakse tagantpoolt ettepoole
    FAccountCode: AStr;
    FAccountLongName: AStr;
    FAccountAttr: AStr; // deebit/kreedit/saldo
    FAccType: AStr;

    FIndxStart: integer; // kus vahemikus konto paiknes, koos atribuutidega
    FIndxEnds: integer;
    // -- taxdeclcalc !
    FAccountId: integer;

    FAccFormulaSum: double;  // saldo kuni ... või käive
    FBalanceChange: double;  // saldo muutus...detailne bilanss ntx !
    Fprocessed: boolean;
  end;

// NUMERAATORID
type
  TNumeratorCache = class
  public
    FCallerId: PtrUInt;
    FNumId: integer;
    FNumType: AStr;
    FNumVal: AStr;
    FNumAccPer: integer;
    FNumDateStart: TDatetime; // peaks rp. perioodi vahemiku siia panema ?
    FNumDateEnd: TDatetime;
    FNumMarkAsReserved: boolean;
    //FNumParity    : Byte;
  end;


type
  TPersistentClassBase = class(TPersistent);

// ----------------------------------------------------------------------------
// puhver klass; TList; TCombobox jne jne
// ----------------------------------------------------------------------------

type
  // 26.11.2011 Ingmar; nüüd ka võimalus koopiat teha arvetel ja pearaamatus; TObjectList läheb
  TCopyGridContent = class
  public
    FCells: array of AStr;
    FObjects: TObjectList;
    FCurrentRowIndx: integer;
    FCellCount: integer;
    constructor Create(const pCellCount: integer; const pReleaseGridObj: boolean = False); reintroduce;
    destructor Destroy; override;
  end;

// klass erineva info hoidmiseks !
type
  TIntIDAndCTypes = class(TPersistentClassBase)
  public
    id: integer;
    id2: integer;
    clf: AStr;
    clf2: AStr;
    misc: integer;
    flags: integer;
    pptr: Pointer;
  end;

// --- 26.11.2011 Ingmar; et saaksime arvetel ja kannetel kasutada kopeerimist, siis võtame TPersistent klassi appi ja clone !
// ARVED/TELLIMUSED
type
  TAccountDataClass = class(TPersistentClassBase)
  public
    FAccId: integer;
    FAccCode: AStr;
  end;

// hetkel arvete ridadel
type
  TVatDataClass = class(TPersistentClassBase)
  public
    FVatId: integer;
    FVatPerc: double;
    FVatLongDescr: AStr;
    //FVatSkip : Boolean;
    FVatFlags: integer;  // pöördkäibemaks või ntx ei arvuta üldse !
  end;


// ostutellimus; tellimusel hetkel ei saa kontot eraldi valida !
type
  TVatDataClass2 = class(TVatDataClass)
  public
    FVatAccountId: integer;
  end;

type
  TObjectDataClass = class(TPersistentClassBase)
  public
    FObjectID: integer;
  end;


// -- PEARAAMAT
// hoiame selguse mõttes klassid eraldi !!!
type
  TCellAccountType = class(TPersistentClassBase)
  public
    AccountId: cardinal;
    // rohkem abimuutuja
    AccountRecID: cardinal;
    AccountType: AStr; // tunnus, kas aktiva / passiva / tulu / kulu
  end;




type
  TCellObjectType = class(TPersistentClassBase)
  public
    ObjectGrp: cardinal;
    ObjectId: cardinal;
  end;



// ARVED; estbk_fra_bills
// Lahtrite tarbeks kasutatavad andmeklassid !

type
  TArticleDataClass = class(TPersistentClassBase)
  public
    FArtId: integer;
    FArtCode: AStr;
    FArtOrigPrice: double; // müügi/osthind sõltub reziimist !
    FArtPriceCalcMeth: AStr;
    FArtSpecialFlags: integer;

    // täidetakse juba salvestatud arve avamisel
    FBillLineId: int64;
    FRefBillLineId: int64; // 02.04.2011 Ingmar; kreeditarve puhul viitab originaalreale, mis võeti aluseks ka kreeditarvel
    FBillLineAccRecId: int64;
    FArtInventoryId: integer; // -- artikliga seotud inventaari kirje !
    FArtCurrentQty: double;  // baasist laetud originaal  artiklite kogus arvereal  !!!!!!!!!!
    FBillLineHash: integer; // antud reaga kontrollime, kas reaalselt on arverida muutunud !!
  end;


// payment manager !
type
  TAccoutingRec = class
  private
    FAccRegMRec: integer;
    //FAccPeriod  : Integer; pole vaja !
    FAccountId: integer;
    FDescr: AStr;
    FRecNr: integer;
    FAccRecType: AStr;
    FAccRecSum: double;
    FClientId: integer;

    // 27.06.2010 Ingmar
    FCurrencyIdentf: AStr;
    FCurrencyRate: double;
    FCurrencyID: integer;
    // 18.08.2011 Ingmar
    FObjectId: integer;
  public
    property regMRec: integer read FAccRegMRec write FAccRegMRec;
    property recType: AStr read FAccRecType write FAccRecType;
    property accountId: integer read FAccountId write FAccountId;
    property clientId: integer read FClientId write FClientId;
    property objectId: integer read FObjectId write FObjectId;
    property recNr: integer read FRecNr write FRecNr;
    property descr: AStr read FDescr write FDescr;
    property sum: double read FAccRecSum write FAccRecSum;

    // 27.06.2010 Ingmar
    property currencyIdentf: AStr read FCurrencyIdentf write FCurrencyIdentf;
    // kursi ülekirjeldamine, vajalik siis kui kasutaja soovib enda poolt defineritud kurssi kasutada !
    property currencyRate: double read FCurrencyRate write FCurrencyRate;
    property currencyID: integer read FCurrencyID write FCurrencyID;
  end;


// ----------------------------------------------------------------------------
// frame eventide andmeklass
// ----------------------------------------------------------------------------

type
  TReqOrderMiscData = class
  public
    FClientID: integer;
    FPaymentOrderID: integer; // ntx tahetakse maksest teha ettemaksuarve
    FItemId: integer; // tellimus jne
    FItemType: TFrameReqItemType;
    FCurrency: AStr;
  end;



// ----------------------------------------------------------------------------
// TÜÜBID
// abistavad klassid andmete hoidmiseks, ei midagi erilist...
// ----------------------------------------------------------------------------

type

  TPermissionHelper = class
  public
    // deklareerime tavamuutujatena, siin pole mõtet property trikke teha; mitte mingit pointi
    itemId: integer;  // rolli/õiguse id
    itemExists: boolean;  // kasutajal roll / õigus algselt olemas
    userModified: boolean;  // kasutaja muutis kirjet, kindalsti kontrolli üle visuaalist
    descriptors: string;
    //parent    : TClassList; // ntx õigusega seotud rollid
    // --
  end;


// ----------------------------------------------------------------------------
// valuuta valikute juurde info
// ----------------------------------------------------------------------------
type
  TCurrencyObjType = class(TObject)
  public
    id: integer;
    currDate: TDatetime;
    currVal: double;
  end;

// ----------------------------------------------------------------------------
type
  TClientContactPersonData = class
  public
    FCId: integer;
    Fcname: AStr;
    Fcaddr: AStr;
    Fcphone: AStr;
    Fcemail: AStr;
    Fcposition: AStr;
  end;


// EARVE import

// algul e-arve põhised, pärast konverdime ümber
// @@ INTERNAL
type
  TEBillVATClass = class
  public
    FSumBefVat: double;
    FVatRate: double;
    FVATSum: double;
  end;

type
  TEBillItemClass = class
  public
    FDescr: AStr;
    FItemUnit: AStr;
    FItemAmount: double;
    FItemPrice: double;
    FItemSum: double;
    // kas tõesti ühel artikli real saaks olla mitu käibemaksumäära ? ebaloogiline
    FSumBefVat: double;
    FVatRate: double;
    FVatSum: double;
    FItemTotalSum: double;
  end;




// ARVED
type
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // TODO: korrasta klassid ja minimiseeri andmete dubleerimist / kopeerimist !!
  // Eriti release versioonis

  TvMergedBillLines = class(TCollectionItem)
  public
    FArtId: integer;
    FArtSalepr: double;
    FArtPurcpr: double;
    FArtCode: AStr;
    FArtType: AStr; // !!! tüüpi pead ka kontrollima; muidu ALA muudad teenuse sisseostuhinda; teoorias võib ka olla, hetkel ei toeta
    FArtPriceCalcMeth: AStr;

    FUnit: AStr;
    FArtDescr: AStr;
    FArtOrigDescr: AStr;
    FAccountID: integer;
    FQty: double;
    FPrice: double;
    FDiscount: double;
    // 30.10.2015 Ingmar; veebi jaoks, et summad tuleks koos ümmardusega
    FRoundCorr: double;

    // 12.09.2010 ingmar
    FArtSpecialFlags: integer;

    // ---
    // 18.03.2010 ingmar; jäta vahele vat lipp olemas !!!
    FVatID: integer;
    FVatAccountId: integer;
    FVatPerc: double;
    FPercFromVatPerc: double; // *** autokäibemaksuga seoses
    FVatLongName: AStr;
    FVatFlags: integer;

    //FVatSkip      : Boolean; // ei arveldata ntx; USA dollarites saadan arve
    FBillLineId: int64;
    FBillLineAccRecId: int64;
    FBillLineChanged: boolean;

    // kasutame kanderidade arvutamisel
    FCalcLineVatSum: double;
    FCalcLineVatNonCalcPart: double; // 24.04.2015 Ingmar; käibemaksu osa, mis jäi üles

    // kasutame koguste kirjete juures; et palju "laost" välja läks müügiarvega jne jne
    //FQtyRecAdded : Boolean;
    FObjectId: integer;
    // 11.04.2013 Ingmar
    FObjectName: AStr;
  end;



// TELLIMUS
// TODO nagu arvetegi juures viia eraldi andmeklassi !!!
// üldine andmeklass
type
  TOrderDataClass = class
  public
    FOrderLineID: integer;  // kui tellimus andmebaasist laetud !
    FOrderLineChkSum: integer;  // tuvastame selle järgi kas on andmed muutunud !!!
    FArtId: integer;  // meie artikli ID !!!
  end;




type
  TVerifiedOrderDataLines = class(TCollectionItem)
  public
    FArtDefClass: TOrderDataClass;
    FArtVatClass: TVatDataClass2;

    FPurchArtCode: AStr; // hankija tootekood !
    FArtCode: AStr; // meie tootekood
    FArtDescr: AStr; // enamasti tarnija oma
    FArtUnit: AStr;
    FArtDiscount: double;
    FArtQty: double;
    FArtPrice: double;
    FArtVatSum: double;
    // --
    constructor Create(ItemClass: TCollection); reintroduce;
    destructor destoy;
  end;


// ----------------------------------------------------------------------------
// KLIENDI ANDMED
// ----------------------------------------------------------------------------

type
  TClientData = class
  protected
    function getCustnameAsc: AStr;
    function getCustnameDesc: AStr;
  public
    FClientId: integer;
    FClientCode: AStr;
    FCustType: AStr;
    FCustFirstname: AStr;
    FCustLastname: AStr;

    FCustRegNr: AStr;
    // juriidiline aadress; hoiame eraldi parem kuvada !
    FCustJCountry: AStr;
    FCustJCounty: AStr;
    FCustJCity: AStr;
    FCustJStreet: AStr;
    FCustJHouseNr: AStr;
    FCustJApartNr: AStr;
    FCustJZipCode: AStr;

    FCustPAddr: AStr; // postiaadress
    FCustBankId: integer; // enamasti tarnija vaikimisi bank
    FCustBankAccount: AStr; // enamasti tarnija arveldusarve !
    FCustPurchRefNr: AStr; // ntx. tarnija poolt antud püsinumber
    FCustContrRefNr: AStr; // tavaliselt tarnija viitenumber

    FCustRepr: AStr; // esindaja nimi

    FCustCredLimit: double;
    FCustVatNr: AStr;
    FCustDueTime: integer;
    // 28.02.2010 Ingmar; meil vaja hankija kontakte
    FCustEmail: AStr;
    FCustPhone: AStr;
    FCustWebPage: AStr;

    // 17.01.2011 Ingmar;
    property FCustFullName: AStr read getCustnameAsc;    // INGMAR TAMMEVÄLI
    property FCustFullNameRev: AStr read getCustnameDesc;   // TAMMEVÄLI INGMAR
  end;




// TODO klasside cleanup !
procedure copyObject(Source, Dest: TObject);
function cloneObject(const pObject: TObject): TObject;
{$IFNDEF NOGUI}
function copySGridContent(const pStrGrid: TStringGrid; const pCopytoList: TObjectList; const pSkipColInDataCheck: TABSet = []): boolean;
procedure restoreGridContent(const pStrGrid: TStringGrid; const pCpyList: TObjectList);
{$ENDIF}
implementation


// --http://webcache.googleusercontent.com/search?q=cache:R3cb8sKexo0J:www.experts-exchange.com/Programming/Languages/Pascal/Delphi/Q_21141107.html+delphi+copy+class+properties&cd=9&hl=et&ct=clnk&gl=ee
procedure copyObject(Source, Dest: TObject);
var
  TypInfo: PTypeInfo;
  PropList: TPropList;
  PropCount, i: integer;
  Value: variant;
begin
  TypInfo := Source.ClassInfo;
  PropCount := GetPropList(TypInfo, tkAny, @PropList);
  for i := 0 to PropCount - 1 do
  begin
    Value := GetPropValue(Source, PropList[i]^.Name);
    SetPropValue(Dest, PropList[i]^.Name, Value);
  end;
end;

function cloneObject(const pObject: TObject): TObject;
var
  pFndClass: TPersistentClass;
  pCrObject: TPersistentClassBase;
  pName: AStr;
begin

  if assigned(pObject) then
  begin
    pName := pObject.ClassName;
    pFndClass := GetClass(pName);


    if assigned(pFndClass) then
    begin
      pCrObject := TPersistentClassBase(pFndClass.Create);
      // pCrObject.Assign(pObject as TPersistentClassBase);
      // 27.11.2011 Ingmar; mõistus sai otsa, miks ei tööta see kood ! ja siis tuleb väga rumalat moodi asjad teha !
      //copyObject(TCellAccountType(pObject),TCellAccountType(pCrObject));
      if pObject is TIntIDAndCTypes then
        with TIntIDAndCTypes(pObject) do
        begin
          TIntIDAndCTypes(pCrObject).id := id;
          TIntIDAndCTypes(pCrObject).id2 := id2;
          TIntIDAndCTypes(pCrObject).clf := clf;
          TIntIDAndCTypes(pCrObject).clf2 := clf2;
          TIntIDAndCTypes(pCrObject).misc := misc;
          TIntIDAndCTypes(pCrObject).flags := flags;
        end
      else
      if pObject is TAccountDataClass then
        with TAccountDataClass(pObject) do
        begin
          TAccountDataClass(pCrObject).FAccId := FAccId;
          TAccountDataClass(pCrObject).FAccCode := FAccCode;
        end
      else
      if pObject is TVatDataClass then
        with TVatDataClass(pObject) do
        begin
          TVatDataClass(pCrObject).FVatId := FVatId;
          TVatDataClass(pCrObject).FVatPerc := FVatPerc;
          TVatDataClass(pCrObject).FVatLongDescr := FVatLongDescr;
          TVatDataClass(pCrObject).FVatFlags := FVatFlags;
        end
      else
      if pObject is TVatDataClass2 then
        with TVatDataClass2(pObject) do
        begin
          TVatDataClass2(pCrObject).FVatId := FVatId;
          TVatDataClass2(pCrObject).FVatPerc := FVatPerc;
          TVatDataClass2(pCrObject).FVatLongDescr := FVatLongDescr;
          TVatDataClass2(pCrObject).FVatFlags := FVatFlags;
          TVatDataClass2(pCrObject).FVatAccountId := FVatAccountId;
        end
      else
      if pObject is TObjectDataClass then
        with TObjectDataClass(pObject) do
        begin
          TObjectDataClass(pCrObject).FObjectID := FObjectID;
        end
      else
      if pObject is TCellAccountType then
        with TCellAccountType(pObject) do
        begin
          TCellAccountType(pCrObject).AccountId := AccountId;
          TCellAccountType(pCrObject).AccountRecID := AccountRecID;
          TCellAccountType(pCrObject).AccountType := AccountType;
        end
      else
      if pObject is TCellObjectType then
        with TCellObjectType(pObject) do
        begin
          TCellObjectType(pCrObject).ObjectGrp := ObjectGrp;
          TCellObjectType(pCrObject).ObjectId := ObjectId;
        end
      else
      if pObject is TArticleDataClass then // 02.12.2011 Ingmar
        with  TArticleDataClass(pObject) do
        begin
          TArticleDataClass(pCrObject).FArtId := FArtId;
          TArticleDataClass(pCrObject).FArtCode := FArtCode;

          TArticleDataClass(pCrObject).FArtOrigPrice := FArtOrigPrice;
          TArticleDataClass(pCrObject).FArtPriceCalcMeth := FArtPriceCalcMeth;
          TArticleDataClass(pCrObject).FArtSpecialFlags := FArtSpecialFlags;
          TArticleDataClass(pCrObject).FBillLineId := FBillLineId;
          TArticleDataClass(pCrObject).FRefBillLineId := FRefBillLineId;
          TArticleDataClass(pCrObject).FBillLineAccRecId := FBillLineAccRecId;
          TArticleDataClass(pCrObject).FArtInventoryId := FArtInventoryId;
          TArticleDataClass(pCrObject).FArtCurrentQty := FArtCurrentQty;
          TArticleDataClass(pCrObject).FBillLineHash := FBillLineHash;
        end;
      // @@@
      Result := pCrObject;
    end
    else
      Result := nil;
  end
  else
    Result := nil;
end;

{$IFNDEF NOGUI}
function copySGridContent(const pStrGrid: TStringGrid; const pCopytoList: TObjectList; const pSkipColInDataCheck: TABSet = []): boolean;
var
  i, j, n: integer;
  pHasData: boolean;
  pRowLine: TCopyGridContent; // peame kõik info ühte pikka nimekirja, ei hakka listnimistuid tegema, mingit võitu ei saavuta
  pCloned: TObject;
  pCellObj: TObject;
  //pIntList : TIntegerList;
begin
  Result := False;
  //pIntList:=TIntegerList.Create();
  pCopytoList.Clear;
  // esmalt vaatame, kas on üldse andmeid
  i := 1;
  while (i < pStrGrid.rowcount) do
  begin
    pHasData := False;
    for j := 0 to pStrGrid.colcount - 1 do
    begin

      //pHasData:=not pStrGrid.Columns.Items[j].ReadOnly and (trim(pStrGrid.Cells[j,i])<>'');
      if j in pSkipColInDataCheck then
        continue;

      pHasData := (trim(pStrGrid.Cells[j, i]) <> '');
      if pHasData then
      begin
        pRowLine := TCopyGridContent.Create(pStrGrid.colcount);
        pRowLine.FCurrentRowIndx := i;

        pCopytoList.Add(pRowLine);
        break;
      end;
      // ---
    end;
    // --
    Inc(i);
  end;

  if pCopytoList.Count < 1 then
  begin
    Dialogs.MessageDlg(estbk_strmsg.SENothingToCopy, mtError, [mbOK], 0);
    if pStrGrid.CanFocus then
      pStrGrid.SetFocus;
    exit;
  end; // --

  // --------
  for i := 0 to pCopytoList.Count - 1 do
  begin
    pRowLine := pCopytoList.Items[i] as TCopyGridContent;
    n := low(pRowLine.FCells);
    for j := 0 to pStrGrid.colcount - 1 do
    begin
      pRowLine.FCells[n] := pStrGrid.Cells[j, pRowLine.FCurrentRowIndx];

      pCellObj := (pStrGrid.Objects[j, pRowLine.FCurrentRowIndx]);
      pCloned := cloneObject(pCellObj);
      pRowLine.FObjects.Add(pCloned);
      Inc(n);
    end;
  end;

  Result := True;
end;

procedure restoreGridContent(const pStrGrid: TStringGrid; const pCpyList: TObjectList);
var
  i, j: integer;
  pRowLine: TCopyGridContent;
  b: boolean;
begin
  try
    b := pStrGrid.Enabled;
    if assigned(pStrGrid.Editor) then
      pStrGrid.Editor.Visible := False;
    pStrGrid.Enabled := False;

    pStrGrid.BeginUpdate;

    if pStrGrid.RowCount < pCpyList.Count then
      pStrGrid.RowCount := pCpyList.Count;

    for i := 0 to pCpyList.Count - 1 do
    begin

      pRowLine := pCpyList.Items[i] as TCopyGridContent;
      if pStrGrid.ColCount < length(pRowLine.FCells) then
        pStrGrid.ColCount := length(pRowLine.FCells);

      // 1 rida on alati tiitel !
      // col algab 0 indexiga
      for j := low(pRowLine.FCells) to high(pRowLine.FCells) do
        pStrGrid.Cells[j, i + 1] := pRowLine.FCells[j];

      for j := 0 to pRowLine.FObjects.Count - 1 do
        pStrGrid.Objects[j, i + 1] := pRowLine.FObjects.Items[j];
    end;

  finally
    pStrGrid.EndUpdate();
    pStrGrid.Enabled := b;
  end;
end;

{$ENDIF}

// ---------------------------------------------------------------------------


constructor TCopyGridContent.Create(const pCellCount: integer; const pReleaseGridObj: boolean = False);
begin
  inherited Create;
  setlength(FCells, pCellCount);
  FCellCount := pCellCount;
  FObjects := TObjectList.Create(pReleaseGridObj);
end;

destructor TCopyGridContent.Destroy;
begin
  FObjects.Free;
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// @TClientData
// ---------------------------------------------------------------------------

function TClientData.getCustnameAsc: AStr;
begin
  Result := trim(self.FCustFirstname + #32 + self.FCustLastname);
end;

function TClientData.getCustnameDesc: AStr;
begin
  Result := trim(self.FCustLastname + #32 + self.FCustFirstname);
end;


// ---------------------------------------------------------------------------
// @TVerifiedOrderDataLines
// ---------------------------------------------------------------------------

constructor TVerifiedOrderDataLines.Create(ItemClass: TCollection);
begin
  inherited Create(ItemClass);
  FArtDefClass := TOrderDataClass.Create;
  FArtVatClass := TVatDataClass2.Create;
end;

destructor TVerifiedOrderDataLines.destoy;
begin
  FreeAndNil(FArtVatClass);
  FreeAndNil(FArtDefClass);
  inherited Destroy;
end;



initialization
  // tüüpklassi mida kasutame koopia objektides; kanded / arved
  Registerclass(TArticleDataClass);
  Registerclass(TAccountDataClass);
  //  Registerclass(TAccoutingRec);
  Registerclass(TCellAccountType);
  Registerclass(TCellObjectType);
  Registerclass(TVatDataClass);
  Registerclass(TVatDataClass2);
  Registerclass(TObjectDataClass);
  Registerclass(TIntIDAndCTypes);

end.
