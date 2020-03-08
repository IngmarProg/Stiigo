unit estbk_lib_commoncls;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
{$TYPEINFO ON}

interface

uses
   {$IFNDEF NOGUI}
   Grids,Dialogs,
   {$ENDIF}
   typinfo,Contnrs,Classes,SysUtils,estbk_types,estbk_strmsg;


// TASUMISED / KASSA siiski hoiame eraldi moodulites, kuigi kood 90% sarnane !
type
  TMarkIncItems = (cMarkBillPayment,cMarkOrderPayment);


type
  TPaymentAction = (cAddPaymentSum,cRemovePaymentSum,cUpdatePaymentSum);


type
  TTrackItemChanges = class(TCollectionItem)
  public
     FItemId     : Integer;
     FItemType   : AStr;
     FChangeType : TPaymentAction;
     FPrevSum    : Currency;
     FNewSum     : Currency;
  end;



// DEKL. ARVUTUSED
type
  TTaxdParsedAccounts = class(TCollectionItem)
  public
   FOrigOrder       : Integer; // algne asukoht valemis; vajalik algseisu taastamisel;
                               // muidu indeksite järgi andmete asendamine valemis enam ei toimu
                               // alustatakse tagantpoolt ettepoole
   FAccountCode     : AStr;
   FAccountLongName : AStr;
   FAccountAttr : AStr; // deebit/kreedit/saldo
   FAccType     : AStr;

   FIndxStart   : Integer; // kus vahemikus konto paiknes, koos atribuutidega
   FIndxEnds    : Integer;
   // -- taxdeclcalc !
   FAccountId     : Integer;

   FAccFormulaSum : Double;  // saldo kuni ... või käive
   FBalanceChange : Double;  // saldo muutus...detailne bilanss ntx !
   Fprocessed     : Boolean;
  end;

// NUMERAATORID
type
  TNumeratorCache = class
  public
   FCallerId  : PtrUInt;
   FNumId     : Integer;
   FNumType   : AStr;
   FNumVal    : AStr;
   FNumAccPer : Integer;
   FNumDateStart  : TDatetime; // peaks rp. perioodi vahemiku siia panema ?
   FNumDateEnd    : TDatetime;
   FNumMarkAsReserved : Boolean;
   //FNumParity    : Byte;
  end;


type
  TPersistentClassBase =  class(TPersistent);

// ----------------------------------------------------------------------------
// puhver klass; TList; TCombobox jne jne
// ----------------------------------------------------------------------------

type
 // 26.11.2011 Ingmar; nüüd ka võimalus koopiat teha arvetel ja pearaamatus; TObjectList läheb
 TCopyGridContent = class
 public
    FCells   : Array of AStr;
    FObjects : TObjectList;
    FCurrentRowIndx : Integer;
    FCellCount      : Integer;
    constructor create(const pCellCount : Integer;
                       const pReleaseGridObj : Boolean = false);reintroduce;
    destructor  destroy;override;
 end;

// klass erineva info hoidmiseks !
type
  TIntIDAndCTypes = class(TPersistentClassBase)
  public
     id   : Integer;
     id2  : Integer;
     clf  : AStr;
     clf2 : AStr;
     misc : Integer;
     flags: Integer;
     pptr : Pointer;
  end;

// --- 26.11.2011 Ingmar; et saaksime arvetel ja kannetel kasutada kopeerimist, siis võtame TPersistent klassi appi ja clone !
// ARVED/TELLIMUSED
type
  TAccountDataClass = class(TPersistentClassBase)
  public
     FAccId   : Integer;
     FAccCode : AStr;
  end;

// hetkel arvete ridadel
type
  TVatDataClass = class(TPersistentClassBase)
  public
     FVatId   : Integer;
     FVatPerc : Double;
     FVatLongDescr : AStr;
     //FVatSkip : Boolean;
     FVatFlags : Integer;  // pöördkäibemaks või ntx ei arvuta üldse !
  end;


// ostutellimus; tellimusel hetkel ei saa kontot eraldi valida !
type
  TVatDataClass2 = class(TVatDataClass)
  public
     FVatAccountId : Integer;
  end;

type
  TObjectDataClass = class(TPersistentClassBase)
  public
     FObjectID : Integer;
  end;


// -- PEARAAMAT
// hoiame selguse mõttes klassid eraldi !!!
type
  TCellAccountType = class(TPersistentClassBase)
  public
     AccountId    : Cardinal;
     // rohkem abimuutuja
     AccountRecID : Cardinal;
     AccountType  : AStr; // tunnus, kas aktiva / passiva / tulu / kulu
  end;




type
  TCellObjectType = class(TPersistentClassBase)
  public
   ObjectGrp : Cardinal;
   ObjectId  : Cardinal;
  end;



// ARVED; estbk_fra_bills
// Lahtrite tarbeks kasutatavad andmeklassid !

type
  TArticleDataClass = class(TPersistentClassBase)
  public
   FArtId        : Integer;
   FArtCode      : AStr;
   FArtOrigPrice : Double; // müügi/osthind sõltub reziimist !
   FArtPriceCalcMeth : AStr;
   FArtSpecialFlags  : Integer;

   // täidetakse juba salvestatud arve avamisel
   FBillLineId        : Int64;
   FRefBillLineId     : Int64; // 02.04.2011 Ingmar; kreeditarve puhul viitab originaalreale, mis võeti aluseks ka kreeditarvel
   FBillLineAccRecId  : Int64;
   FArtInventoryId    : Integer; // -- artikliga seotud inventaari kirje !
   FArtCurrentQty     : Double;  // baasist laetud originaal  artiklite kogus arvereal  !!!!!!!!!!
   FBillLineHash      : Integer; // antud reaga kontrollime, kas reaalselt on arverida muutunud !!
  end;


// payment manager !
type
  TAccoutingRec =  class
  private
     FAccRegMRec : Integer;
     //FAccPeriod  : Integer; pole vaja !
     FAccountId  : Integer;
     FDescr      : AStr;
     FRecNr      : Integer;
     FAccRecType : AStr;
     FAccRecSum  : Double;
     FClientId   : Integer;

     // 27.06.2010 Ingmar
     FCurrencyIdentf : AStr;
     FCurrencyRate   : Double;
     FCurrencyID     : Integer;
     // 18.08.2011 Ingmar
     FObjectId : Integer;
  public
     property regMRec : Integer read FAccRegMRec write FAccRegMRec;
     property recType : AStr read FAccRecType write FAccRecType;
     property accountId : Integer read FAccountId write FAccountId;
     property clientId : Integer read FClientId write FClientId;
     property objectId : Integer read FObjectId write FObjectId;
     property recNr : Integer read FRecNr write FRecNr;
     property descr : AStr read FDescr write FDescr;
     property sum : Double read FAccRecSum write FAccRecSum;

     // 27.06.2010 Ingmar
     property currencyIdentf : AStr read FCurrencyIdentf write FCurrencyIdentf;
     // kursi ülekirjeldamine, vajalik siis kui kasutaja soovib enda poolt defineritud kurssi kasutada !
     property currencyRate   : Double read FCurrencyRate write FCurrencyRate;
     property currencyID     : Integer read FCurrencyID write FCurrencyID;
  end;


// ----------------------------------------------------------------------------
// frame eventide andmeklass
// ----------------------------------------------------------------------------

type
  TReqOrderMiscData = class
  public
     FClientID : Integer;
     FPaymentOrderID : Integer; // ntx tahetakse maksest teha ettemaksuarve
     FItemId   : Integer; // tellimus jne
     FItemType : TFrameReqItemType;
     FCurrency : AStr;
  end;



// ----------------------------------------------------------------------------
// TÜÜBID
// abistavad klassid andmete hoidmiseks, ei midagi erilist...
// ----------------------------------------------------------------------------

type

 TPermissionHelper = class
 public
    // deklareerime tavamuutujatena, siin pole mõtet property trikke teha; mitte mingit pointi
    itemId       : Integer;  // rolli/õiguse id
    itemExists   : Boolean;  // kasutajal roll / õigus algselt olemas
    userModified : Boolean;  // kasutaja muutis kirjet, kindalsti kontrolli üle visuaalist
    descriptors  : String;
    //parent    : TClassList; // ntx õigusega seotud rollid
    // --
 end;


// ----------------------------------------------------------------------------
// valuuta valikute juurde info
// ----------------------------------------------------------------------------
type
 TCurrencyObjType = class(TObject)
 public
     id       : Integer;
     currDate : TDatetime;
     currVal  : Double;
 end;

// ----------------------------------------------------------------------------
type
 TClientContactPersonData = class
 public
     FCId      : Integer;
     Fcname    : AStr;
     Fcaddr    : AStr;
     Fcphone   : AStr;
     Fcemail   : AStr;
     Fcposition: AStr;
 end;


// EARVE import

// algul e-arve põhised, pärast konverdime ümber
// @@ INTERNAL
type
  TEBillVATClass = class
  public
    FSumBefVat : Double;
    FVatRate : Double;
    FVATSum : Double;
  end;

type
  TEBillItemClass = class
  public
    FDescr : AStr;
    FItemUnit : AStr;
    FItemAmount : Double;
    FItemPrice : Double;
    FItemSum : Double;
    // kas tõesti ühel artikli real saaks olla mitu käibemaksumäära ? ebaloogiline
    FSumBefVat : Double;
    FVatRate : Double;
    FVatSum : Double;
    FItemTotalSum : Double;
  end;




// ARVED
type
   // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   // TODO: korrasta klassid ja minimiseeri andmete dubleerimist / kopeerimist !!
   // Eriti release versioonis

 TvMergedBillLines = class(TCollectionItem)
 public
    FArtId     : Integer;
    FArtSalepr : Double;
    FArtPurcpr : Double;
    FArtCode   : AStr;
    FArtType   : AStr; // !!! tüüpi pead ka kontrollima; muidu ALA muudad teenuse sisseostuhinda; teoorias võib ka olla, hetkel ei toeta
    FArtPriceCalcMeth : AStr;

    FUnit      : AStr;
    FArtDescr  : AStr;
    FArtOrigDescr : AStr;
    FAccountID : Integer;
    FQty       : Double;
    FPrice     : Double;
    FDiscount  : Double;
    // 30.10.2015 Ingmar; veebi jaoks, et summad tuleks koos ümmardusega
    FRoundCorr : Double;

    // 12.09.2010 ingmar
    FArtSpecialFlags : Integer;

    // ---
    // 18.03.2010 ingmar; jäta vahele vat lipp olemas !!!
    FVatID        : Integer;
    FVatAccountId : Integer;
    FVatPerc      : Double;
    FPercFromVatPerc : Double; // *** autokäibemaksuga seoses
    FVatLongName  : AStr;
    FVatFlags     : Integer;

    //FVatSkip      : Boolean; // ei arveldata ntx; USA dollarites saadan arve
    FBillLineId       : Int64;
    FBillLineAccRecId : Int64;
    FBillLineChanged  : Boolean;

    // kasutame kanderidade arvutamisel
    FCalcLineVatSum   : Double;
    FCalcLineVatNonCalcPart : Double; // 24.04.2015 Ingmar; käibemaksu osa, mis jäi üles

    // kasutame koguste kirjete juures; et palju "laost" välja läks müügiarvega jne jne
    //FQtyRecAdded : Boolean;
    FObjectId : Integer;
    // 11.04.2013 Ingmar
    FObjectName : AStr;
 end;



// TELLIMUS
// TODO nagu arvetegi juures viia eraldi andmeklassi !!!
// üldine andmeklass
type
 TOrderDataClass = class
 public
    FOrderLineID     : Integer;  // kui tellimus andmebaasist laetud !
    FOrderLineChkSum : Integer;  // tuvastame selle järgi kas on andmed muutunud !!!
    FArtId           : Integer;  // meie artikli ID !!!
 end;




type
 TVerifiedOrderDataLines = class(TCollectionItem)
 public
    FArtDefClass  : TOrderDataClass;
    FArtVatClass  : TVatDataClass2;

    FPurchArtCode : AStr; // hankija tootekood !
    FArtCode      : AStr; // meie tootekood
    FArtDescr     : AStr; // enamasti tarnija oma
    FArtUnit      : AStr;
    FArtDiscount  : Double;
    FArtQty       : Double;
    FArtPrice     : Double;
    FArtVatSum    : Double;
    // --
    constructor create(ItemClass: TCollection);reintroduce;
    destructor  destoy;
 end;


 // ----------------------------------------------------------------------------
 // KLIENDI ANDMED
 // ----------------------------------------------------------------------------

 type
  TClientData = class
  protected
    function getCustnameAsc:AStr;
    function getCustnameDesc:AStr;
  public
   FClientId    : Integer;
   FClientCode  : AStr;
   FCustType    : AStr;
   FCustFirstname : AStr;
   FCustLastname  : AStr;

   FCustRegNr  : AStr;
   // juriidiline aadress; hoiame eraldi parem kuvada !
   FCustJCountry : AStr;
   FCustJCounty  : AStr;
   FCustJCity    : AStr;
   FCustJStreet  : AStr;
   FCustJHouseNr : AStr;
   FCustJApartNr : AStr;
   FCustJZipCode : AStr;

   FCustPAddr  : AStr; // postiaadress
   FCustBankId : Integer; // enamasti tarnija vaikimisi bank
   FCustBankAccount : AStr; // enamasti tarnija arveldusarve !
   FCustPurchRefNr  : AStr; // ntx. tarnija poolt antud püsinumber
   FCustContrRefNr  : AStr; // tavaliselt tarnija viitenumber

   FCustRepr   : AStr; // esindaja nimi

   FCustCredLimit : Double;
   FCustVatNr     : AStr;
   FCustDueTime   : Integer;
   // 28.02.2010 Ingmar; meil vaja hankija kontakte
   FCustEmail    : AStr;
   FCustPhone    : AStr;
   FCustWebPage  : AStr;

   // 17.01.2011 Ingmar;
   property FCustFullName    : AStr read getCustnameAsc;    // INGMAR TAMMEVÄLI
   property FCustFullNameRev : AStr read getCustnameDesc;   // TAMMEVÄLI INGMAR
  end;




// TODO klasside cleanup !
procedure copyObject(Source, Dest: TObject);
function  cloneObject(const pObject : TObject):TObject;
{$IFNDEF NOGUI}
function  copySGridContent(const pStrGrid : TStringGrid; const pCopytoList : TObjectList; const pSkipColInDataCheck : TABSet = []):Boolean;
procedure restoreGridContent(const pStrGrid : TStringGrid; const pCpyList : TObjectList);
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
    Value := GetPropValue (Source, PropList [i]^.Name);
    SetPropValue (Dest, PropList [i]^.Name, Value);
  end;
end;

function  cloneObject(const pObject : TObject):TObject;
var
  pFndClass : TPersistentClass;
  pCrObject : TPersistentClassBase;
  pName     : AStr;
begin

 if assigned(pObject) then
   begin
      pName:=pObject.ClassName;
      pFndClass:=GetClass(pName);


   if assigned(pFndClass) then
     begin
         pCrObject:=TPersistentClassBase(pFndClass.Create);
         // pCrObject.Assign(pObject as TPersistentClassBase);
         // 27.11.2011 Ingmar; mõistus sai otsa, miks ei tööta see kood ! ja siis tuleb väga rumalat moodi asjad teha !
         //copyObject(TCellAccountType(pObject),TCellAccountType(pCrObject));
     if  pObject is TIntIDAndCTypes then
     with TIntIDAndCTypes(pObject) do
       begin
          TIntIDAndCTypes(pCrObject).id:=id;
          TIntIDAndCTypes(pCrObject).id2:=id2;
          TIntIDAndCTypes(pCrObject).clf:=clf;
          TIntIDAndCTypes(pCrObject).clf2:=clf2;
          TIntIDAndCTypes(pCrObject).misc:=misc;
          TIntIDAndCTypes(pCrObject).flags:=flags;
       end else
     if  pObject is TAccountDataClass then
     with TAccountDataClass(pObject) do
       begin
          TAccountDataClass(pCrObject).FAccId:=FAccId;
          TAccountDataClass(pCrObject).FAccCode:=FAccCode;
       end else
     if  pObject is TVatDataClass then
     with TVatDataClass(pObject) do
       begin
          TVatDataClass(pCrObject).FVatId:=FVatId;
          TVatDataClass(pCrObject).FVatPerc:=FVatPerc;
          TVatDataClass(pCrObject).FVatLongDescr:=FVatLongDescr;
          TVatDataClass(pCrObject).FVatFlags:=FVatFlags;
       end else
     if  pObject is TVatDataClass2 then
     with TVatDataClass2(pObject) do
       begin
          TVatDataClass2(pCrObject).FVatId:=FVatId;
          TVatDataClass2(pCrObject).FVatPerc:=FVatPerc;
          TVatDataClass2(pCrObject).FVatLongDescr:=FVatLongDescr;
          TVatDataClass2(pCrObject).FVatFlags:=FVatFlags;
          TVatDataClass2(pCrObject).FVatAccountId:=FVatAccountId;
       end else
     if  pObject is TObjectDataClass then
     with TObjectDataClass(pObject) do
       begin
          TObjectDataClass(pCrObject).FObjectID:=FObjectID;
       end else
     if  pObject is TCellAccountType then
     with TCellAccountType(pObject) do
      begin
          TCellAccountType(pCrObject).AccountId:=AccountId;
          TCellAccountType(pCrObject).AccountRecID:=AccountRecID;
          TCellAccountType(pCrObject).AccountType:=AccountType;
      end else
     if  pObject is TCellObjectType then
     with TCellObjectType(pObject) do
      begin
          TCellObjectType(pCrObject).ObjectGrp:=ObjectGrp;
          TCellObjectType(pCrObject).ObjectId:=ObjectId;
      end else
     if  pObject is TArticleDataClass then // 02.12.2011 Ingmar
     with  TArticleDataClass(pObject) do
      begin
          TArticleDataClass(pCrObject).FArtId:=FArtId;
          TArticleDataClass(pCrObject).FArtCode:=FArtCode;

          TArticleDataClass(pCrObject).FArtOrigPrice:=FArtOrigPrice;
          TArticleDataClass(pCrObject).FArtPriceCalcMeth:=FArtPriceCalcMeth;
          TArticleDataClass(pCrObject).FArtSpecialFlags:=FArtSpecialFlags;
          TArticleDataClass(pCrObject).FBillLineId:=FBillLineId;
          TArticleDataClass(pCrObject).FRefBillLineId:=FRefBillLineId;
          TArticleDataClass(pCrObject).FBillLineAccRecId:=FBillLineAccRecId;
          TArticleDataClass(pCrObject).FArtInventoryId:=FArtInventoryId;
          TArticleDataClass(pCrObject).FArtCurrentQty:=FArtCurrentQty;
          TArticleDataClass(pCrObject).FBillLineHash:=FBillLineHash;
      end;
         // @@@
         result:=pCrObject;
     end else
         result:=nil;
   end else
         result:=nil;
end;

{$IFNDEF NOGUI}
function   copySGridContent(const pStrGrid : TStringGrid; const pCopytoList : TObjectList; const pSkipColInDataCheck : TABSet = []):Boolean;
var
  i,j,n : Integer;
  pHasData : Boolean;
  pRowLine : TCopyGridContent; // peame kõik info ühte pikka nimekirja, ei hakka listnimistuid tegema, mingit võitu ei saavuta
  pCloned  : TObject;
  pCellObj : TObject;
  //pIntList : TIntegerList;
begin
             result:=false;
             //pIntList:=TIntegerList.Create();
             pCopytoList.Clear;
             // esmalt vaatame, kas on üldse andmeid
             i:=1;
      while (i<pStrGrid.rowcount) do
       begin
             pHasData:=false;
         for j:=0 to pStrGrid.colcount-1 do
           begin

              //pHasData:=not pStrGrid.Columns.Items[j].ReadOnly and (trim(pStrGrid.Cells[j,i])<>'');
           if j in pSkipColInDataCheck then
              continue;

              pHasData:=(trim(pStrGrid.Cells[j,i])<>'');
           if pHasData then
             begin
               pRowLine:=TCopyGridContent.create(pStrGrid.colcount);
               pRowLine.FCurrentRowIndx:=i;

               pCopytoList.Add(pRowLine);
               break;
             end;
             // ---
           end;
          // --
          inc(i);
       end;

      if pCopytoList.count<1 then
       begin
          dialogs.MessageDlg(estbk_strmsg.SENothingToCopy,mtError,[mbOk],0);
       if pStrGrid.CanFocus then
          pStrGrid.SetFocus;
          exit;
       end; // --

      // --------
      for i:=0 to pCopytoList.Count-1 do
        begin
               pRowLine:=pCopytoList.Items[i] as TCopyGridContent;
               n:=low(pRowLine.FCells);
           for j:=0 to pStrGrid.colcount-1 do
             begin
               pRowLine.FCells[n]:=pStrGrid.Cells[j,pRowLine.FCurrentRowIndx];

               pCellObj:=(pStrGrid.Objects[j,pRowLine.FCurrentRowIndx]);
               pCloned:=cloneObject(pCellObj);
               pRowLine.FObjects.Add(pCloned);
               inc(n);
             end;
        end;

        result:=true;
end;

procedure  restoreGridContent(const pStrGrid : TStringGrid; const pCpyList : TObjectList);
var
  i,j : Integer;
  pRowLine : TCopyGridContent;
  b : Boolean;
begin
 try
    b:=pStrGrid.Enabled;
 if assigned(pStrGrid.Editor) then
    pStrGrid.Editor.Visible:=false;
    pStrGrid.Enabled:=false;

    pStrGrid.BeginUpdate;

 if pStrGrid.RowCount<pCpyList.Count then
    pStrGrid.RowCount:=pCpyList.Count;

 for i:=0 to pCpyList.Count-1 do
  begin

        pRowLine:=pCpyList.Items[i] as TCopyGridContent;
    if  pStrGrid.ColCount<length(pRowLine.FCells) then
        pStrGrid.ColCount:=length(pRowLine.FCells);

    // 1 rida on alati tiitel !
    // col algab 0 indexiga
    for j:=low(pRowLine.FCells) to high(pRowLine.FCells) do
        pStrGrid.Cells[j,i+1]:=pRowLine.FCells[j];

    for j:=0 to pRowLine.FObjects.Count-1 do
        pStrGrid.Objects[j,i+1]:=pRowLine.FObjects.Items[j];
  end;

 finally
   pStrGrid.EndUpdate();
   pStrGrid.Enabled:=b;
 end;
end;
{$ENDIF}

// ---------------------------------------------------------------------------


constructor TCopyGridContent.Create(const pCellCount : Integer;
                                    const pReleaseGridObj : Boolean = false);
begin
  inherited create;
  setlength(FCells,pCellCount);
  FCellCount:=pCellCount;
  FObjects:=TObjectList.Create(pReleaseGridObj);
end;

destructor  TCopyGridContent.Destroy;
begin
  FObjects.Free;
  inherited destroy;
end;

// ---------------------------------------------------------------------------
// @TClientData
// ---------------------------------------------------------------------------

function TClientData.getCustnameAsc:AStr;
begin
 result:=trim(self.FCustFirstname+#32+self.FCustLastname);
end;

function TClientData.getCustnameDesc:AStr;
begin
  result:=trim(self.FCustLastname+#32+self.FCustFirstname);
end;


// ---------------------------------------------------------------------------
// @TVerifiedOrderDataLines
// ---------------------------------------------------------------------------

constructor TVerifiedOrderDataLines.create(ItemClass: TCollection);
begin
 inherited create(ItemClass);
 FArtDefClass:=TOrderDataClass.create;
 FArtVatClass:=TVatDataClass2.create;
end;

destructor  TVerifiedOrderDataLines.destoy;
begin
 freeAndNil(FArtVatClass);
 freeAndNil(FArtDefClass);
 inherited destroy;
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


