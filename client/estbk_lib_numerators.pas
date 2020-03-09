unit estbk_lib_numerators;

{$i estbk_defs.inc}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dateutils, Contnrs,{$IFDEF WEBSERVICE}Syncobjs,{$ENDIF}Variants, ZConnection,
  ZDataset, estbk_lib_commoncls, estbk_strmsg, estbk_types, estbk_settings,
  estbk_globvars, estbk_sqlcollection, estbk_sqlclientcollection, estbk_dbcompability;

type
  TIsValidAccountingPeriodCallBack = function(const pDate: TDatetime; var pAccPeriodId: integer): boolean of object;

type
  TNumerators = class
  protected
    {$IFDEF WEBSERVICE}
    FCs: TCriticalSection;
    {$ENDIF}
    FActive: boolean;
    FCommQuery: TZQuery;
    FNumFmtQuery: TZQuery;
    // 02.03.2012 Ingmar; maj. aasta põhised numeraatorid
    FNumeratorCache: TObjectList;
    FForwardStsValues: estbk_settings.TUserStsValues;
    FIsValidAccountingPeriodCallBack: TIsValidAccountingPeriodCallBack;
    function getConnection: TZConnection;
    procedure setConnection(const v: TZConnection);
    procedure setActive(const v: boolean);
    function getStsData(index: TStsIndex): AStr;
    procedure setStsData(index: TStsIndex; Value: AStr);
    function InternalIsValidAccountingPeriod(const pDate: TDatetime; var pAccPeriodId: integer): boolean;
  public
    property connection: TZConnection read getConnection write setConnection;
    property active: boolean read FActive write setActive;
    property IsValidAccountingPeriod: TIsValidAccountingPeriodCallBack read FIsValidAccountingPeriodCallBack write FIsValidAccountingPeriodCallBack;
    property ForwardStsValues: estbk_settings.TUserStsValues read FForwardStsValues write FForwardStsValues;
    property userStsValues[Index: TStsIndex]: AStr read getStsData write setStsData;
    function __getNumeratorCacheIndex(const pNumeratorType: TCNumeratorTypes; const pCacheGenledgerAccNr: boolean = False): TStsIndex;
    function __resolveNumType(const pNumTypeAsStr: AStr): TCNumeratorTypes;
    function __getNumeratorCacheExt(const pCallerId: PtrUInt; const pCurrentNumVal: AStr; const pNumeratorType: TCNumeratorTypes;
      const pNumeratorDate: TDate; const pBookNumber: boolean; // st. kui false, siis võtame välja cachest ja kõik
      const pReloadNumber: boolean): AStr;
    procedure __markNumeratorValAsReserved(const pNumeratorType: TCNumeratorTypes; const pNumVal: AStr;
      const pCallerIsGeneralLedgerModule: boolean = False);
    procedure __markNumeratorValAsReservedExt(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
      const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pReloadNumber: boolean; const pCallerIsGeneralLedgerModule: boolean);

    procedure __markNumeratorValAsUsedExt(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
      const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pCallerIsGeneralLedgerModule: boolean = False);
    procedure markNumeratorValAsUsed(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
      const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pCallerIsGeneralLedgerModule: boolean = False);
    procedure notifyNumerators(const pCallerId: PtrUInt);
    function formatNumerator(const pNumVal: string; const pDate: TDatetime; const pNumFmt: string;
      const pThrowException: boolean = True): string;
    function extractNumberFromNumerator(const pNumVal: AStr; const pNumFmt: AStr): AStr;
    function couldbeCustomNumerator(const pNumVal: string; const pDate: TDatetime; const pNumFmt: AStr): boolean;
    function queryNumFormat(const pNumType: AStr; const pAccPeriodId: integer; var pNumPrefix: AStr; var pNumFmt: AStr): boolean;
    function doFinalNumeratorFmt(const pVal: AStr; const pNumType: AStr; const pAccPeriodId: integer; const pDate: TDatetime): AStr;
    function getUniqNumberFromNumerator(const pCallerId: PtrUInt; const pCurrentNumVal: AStr; const pNumeratorDate: TDate;
      const pReloadNumber: boolean; // ----
      const pNumeratorType: TCNumeratorTypes = estbk_types.CAccGen_rec_nr; const pBookSrNr: boolean = True;
      const pCallerIsGeneralLedgerModule: boolean = False): AStr;
    function generateStaticNumAccPeriod(const pNumeratorType: TCNumeratorTypes; var pAccPeriod: integer): boolean;
    procedure loadNumeratorValHistory;
    procedure saveNumeratorValHistory;

    constructor Create;
    destructor Destroy; override;
  end;

var
  _nm: TNumerators;

implementation

{$IFNDEF NOGUI}
uses Dialogs;

{$ENDIF}

function TNumerators.getConnection: TZConnection;
begin
  if Assigned(FCommQuery) then
    Result := FCommQuery.Connection as TZConnection
  else
    Result := nil;
end;

procedure TNumerators.setConnection(const v: TZConnection);
begin
  if not Assigned(FCommQuery) then
    FCommQuery := TZQuery.Create(nil);

  if not Assigned(FNumFmtQuery) then
    FNumFmtQuery := TZQuery.Create(nil);

  FCommQuery.Connection := v;
  FNumFmtQuery.Connection := v;
end;

procedure TNumerators.setActive(const v: boolean);
begin

  if v and Assigned(FNumFmtQuery) then
  begin
    // --------------
    // -- num formaadid !
    with FNumFmtQuery, SQL do
    begin
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectNumFmts);
      //paramByname('company_id').AsInteger := pSelectedCmp;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
    end;


    with FCommQuery, SQL do
      try
        // 02.03.2012 Ingmar
        // kontrollime, millises stiilis numeraatoreid me kasutame !
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLSelectACPVar);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;
        estbk_globvars.glob_accPeriontypeNumerators := trim(FieldByName('var_val').AsString) = '1';

        // 16.04.2012 Ingmar; peame leidma esimese maj. aasta kus hoiame staatiliste numeraatorite väärtusi !
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLSelectMinNumFst);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;
        estbk_globvars.glob_minAccPeriodForStaticNumerators := FieldByName('macc_period').AsInteger;

      finally
        Close;
        Clear;
      end;
  end; // --

  FActive := v;
end;

function TNumerators.getStsData(index: TStsIndex): AStr;
begin
  Result := ForwardStsValues[index];
end;

procedure TNumerators.setStsData(index: TStsIndex; Value: AStr);
var
  tmp: estbk_settings.TUserStsValues;
begin
  tmp := ForwardStsValues;
  tmp[index] := Value;
  ForwardStsValues := tmp;
end;

function TNumerators.InternalIsValidAccountingPeriod(const pDate: TDatetime; var pAccPeriodId: integer): boolean;
begin
  with FCommQuery, SQL do
    try
      Close;
      Clear;
      Add(estbk_sqlclientcollection._SQLCheckAccperiod);
      ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      ParamByname('accdate').AsDateTime := pDate;
      Open;
      pAccPeriodId := FieldByName('id').AsInteger;
      Result := pAccPeriodId > 0;
    finally
      Close;
      Clear;
    end;
end;

function TNumerators.__getNumeratorCacheIndex(const pNumeratorType: TCNumeratorTypes; const pCacheGenledgerAccNr: boolean = False): TStsIndex;
var
  pSt: TStsIndex;
begin
  pSt := Csts_nothing;

  // pearaamatu kandenr tuleb cacheda, sest muidu on igakord uus nr !
  // CAccGen_rec_nr otsene kasutamine oleks ohtlik, kuna seda kutsuvad välja ka teised moodulid !
  if pCacheGenledgerAccNr then
    pSt := Csts_rsv_GenLedgerAccnr
  else
    case pNumeratorType of
      // CAccInc_rec_nr:;    // laekumiste lausendite seerianumbrid
      // CContr_recnr:;      // lepingu number
      // CProd_recnr:;       // toote number/kood sõltub süsteemist; artikkel
      // CSrv_recnr:;        // teenusekood
      // CWProc_recnr:;      // lao artikkel
      // CDoc_recnr          // automaatne dokumentide numeratsioon
      // CAccBill_rec_nr: pSt:;   // arvete lausendite seerianumbrid
      // 23.08.2011 Ingmar
      CAccInc_rec_nr: pSt := Csts_rsv_IncAccnr_id;
      // ------
      // PUHVERDATUD DOKUMENTIDE NUMBRISEERIAD PS. NEED POLE KANDESEERIAD !!!
      // ------

      CBill_doc_nr: pSt := Csts_rsv_salebillnr;       // müügiarve number
      CCBill_doc_nr: pSt := Csts_rsv_creditbillnr;     // kreeditarve number;
      CDBill_doc_nr: pSt := Csts_rsv_overduebillnr;    // viivisarve number

      CPOrder_doc_nr: pSt := Csts_rsv_ordernr;          // ostutellimuse number
      CSOrder_doc_nr: pSt := Csts_rsv_saleornr;         // müügitellimuse number

      COffer_doc_nr: pSt := Csts_rsv_offernr;          // pakkumise number
      // --
      CPMOrder_doc_nr: pSt := Csts_rsv_Pmordernr;        // (payment order)maksekorralduse nr

      CCSRegister_doc_recnr: pSt := Csts_rsv_CashRegnr;     //  kassa numbriseeria
    end; // --

  Result := pSt;
end;


function TNumerators.__resolveNumType(const pNumTypeAsStr: AStr): TCNumeratorTypes;
var
  i: TCNumeratorTypes;
begin
  Result := CAccGen_rec_nr;
  for i := low(TCNumeratorTypes) to high(TCNumeratorTypes) do
    if AnsiUpperCase(pNumTypeAsStr) = AnsiUpperCase(TNumeratorTypesSDescr[i]) then
    begin
      Result := i;
      break;
    end;
end;

function TNumerators.__getNumeratorCacheExt(const pCallerId: PtrUInt; const pCurrentNumVal: AStr;
  const pNumeratorType: TCNumeratorTypes; const pNumeratorDate: TDate; const pBookNumber: boolean;
  // st. kui false, siis võtame välja cachest ja kõik
  const pReloadNumber: boolean): AStr;
{$IFNDEF WEBSERVICE}
var
  i: integer;
  pNumCache: TNumeratorCache;
  // --
  b: boolean;
  pAccPeriod: integer;
{$ENDIF}
begin
  Result := '';
  // @@@
  // veebiservice puhul hetkel me cachet ei kasuta !!!
{$IFNDEF WEBSERVICE}

  b := generateStaticNumAccPeriod(pNumeratorType, pAccPeriod); // staatilised !
  if not b then
    b := isValidAccountingPeriod(pNumeratorDate, pAccPeriod);

  // hoiatus
  if not b then
  begin
     {$IFNDEF NOGUI}
    Dialogs.messageDlg(estbk_strmsg.SECantGenNewNVal, mtError, [mbOK], 0);
    abort;
     {$ELSE}
    raise Exception.Create(estbk_strmsg.SECantGenNewNVal);
     {$ENDIF}
    //Exit;
  end; // ---




  // @@@
  // vaatame, ehk jätame sama numbri...
  for i := 0 to FNumeratorCache.Count - 1 do
    if Assigned(FNumeratorCache.Items[i]) then
    begin
      pNumCache := FNumeratorCache.Items[i] as TNumeratorCache;
      if ((pNumCache.FCallerId = pCallerId) or (pNumCache.FCallerId = 0)) and (__resolveNumType(pNumCache.FNumType) = pNumeratorType) and
        (pNumCache.FNumAccPer = pAccPeriod) then // -- annan sama numbri tagasi eeldusel...et ... et rp. periood klapib
      begin
        Result := pNumCache.FNumVal;
        pNumCache.FNumMarkAsReserved := True;
        pNumCache.FCallerId := pCallerId;
        Exit;
      end; // --
    end;


  // @@@ ok, miskit ei leidnud, vaatame kas midagi siiski vaba
  for i := 0 to FNumeratorCache.Count - 1 do
    if Assigned(FNumeratorCache.Items[i]) then
    begin
      pNumCache := FNumeratorCache.Items[i] as TNumeratorCache;
      if (not pNumCache.FNumMarkAsReserved) and (__resolveNumType(pNumCache.FNumType) = pNumeratorType) and
        (pNumCache.FNumAccPer = pAccPeriod) then // !!!
      begin
        Result := pNumCache.FNumVal;
        pNumCache.FNumMarkAsReserved := True;
        pNumCache.FCallerId := pCallerId;
        Exit;
      end; // --
    end;
{$ENDIF}
end;

// WEBSERVICE PUHUL me ei reserveeri midagi !!!
procedure TNumerators.__markNumeratorValAsReserved(const pNumeratorType: TCNumeratorTypes; const pNumVal: AStr;
  const pCallerIsGeneralLedgerModule: boolean = False);
{$IFNDEF WEBSERVICE}
var
  pUsrSettingIndex: TStsIndex;
{$ENDIF}
begin
{$IFNDEF WEBSERVICE}
  if not estbk_globvars.glob_accPeriontypeNumerators then
  begin
    pUsrSettingIndex := __getNumeratorCacheIndex(pNumeratorType, pCallerIsGeneralLedgerModule);
    if pUsrSettingIndex <> Csts_nothing then
      userStsValues[pUsrSettingIndex] := pNumVal;
  end;
{$ENDIF}
end;


procedure TNumerators.__markNumeratorValAsReservedExt(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
  const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pReloadNumber: boolean; const pCallerIsGeneralLedgerModule: boolean);
{$IFNDEF WEBSERVICE}
var
  pNumCache: TNumeratorCache;
  pAccPeriod: integer;
  b: boolean;
{$ENDIF}
begin
{$IFNDEF WEBSERVICE}
  pNumCache := TNumeratorCache.Create;
  pNumCache.FNumId := 0;

  // Hoiatus
  pAccPeriod := 0;
  b := generateStaticNumAccPeriod(pNumeratorType, pAccPeriod); // 16.04.2012 Ingmar
  if not b then
    b := isValidAccountingPeriod(pNumeratorDate, pAccPeriod);

  if not b then
  begin
      {$IFNDEF NOGUI}
    Dialogs.messageDlg(estbk_strmsg.SECantGenNewNVal, mtError, [mbOK], 0);
    abort;
      {$ELSE}
    raise Exception.Create(estbk_strmsg.SECantGenNewNVal);
      {$ENDIF}
    //Exit;
  end; // ---


  pNumCache.FCallerId := pCallerId;
  pNumCache.FNumAccPer := pAccPeriod;
  pNumCache.FNumType := TNumeratorTypesSDescr[pNumeratorType]; // str
  pNumCache.FNumVal := pNumeratorVal;
  pNumCache.FNumDateStart := pNumeratorDate;
  pNumCache.FNumDateEnd := pNumeratorDate;
  pNumCache.FNumMarkAsReserved := True;


  FNumeratorCache.Add(pNumCache);
{$ENDIF}
end;

// 09.03.2012 Ingmar
procedure TNumerators.__markNumeratorValAsUsedExt(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
  const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pCallerIsGeneralLedgerModule: boolean = False);
{$IFNDEF WEBSERVICE}
var
  pNumCache: TNumeratorCache;
  i: integer;
  b: boolean;
  pAccPeriod: integer;
{$ENDIF}
begin
{$IFNDEF WEBSERVICE}
  if FNumeratorCache.Count = 0 then
    Exit;

  pAccPeriod := 0;
  b := isValidAccountingPeriod(pNumeratorDate, pAccPeriod);
  if not b then
  begin
     {$IFNDEF NOGUI}
    Dialogs.messageDlg(estbk_strmsg.SECantGenNewNVal, mtError, [mbOK], 0);
    abort;
     {$ELSE}
    raise Exception.Create(estbk_strmsg.SECantGenNewNVal);
     {$ENDIF}
    //Exit;
  end; // ---

  for i := 0 to FNumeratorCache.Count - 1 do
    if Assigned(FNumeratorCache.Items[i]) then
    begin
      pNumCache := FNumeratorCache.Items[i] as TNumeratorCache;
      if ((__resolveNumType(pNumCache.FNumType) = pNumeratorType) and (AnsiUpperCase(pNumCache.FNumVal) = AnsiUpperCase(pNumeratorVal)) and
        (pNumCache.FNumAccPer = pAccPeriod)) then
        with FCommQuery, SQL do
          try
            Close;
            Clear;
            add(estbk_sqlclientcollection._SQLDeleteNumCache);
            paramByname('id').AsInteger := pNumCache.FNumId;
            execSQL;
            //pNumCache.Free;
            // --
            //FNumeratorCache.Items[i]:=nil;
            FNumeratorCache.Delete(i);
            Exit; // ---
          finally
            Close;
            Clear;
          end;
    end;
  // ---
{$ENDIF}
end;

procedure TNumerators.markNumeratorValAsUsed(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
  const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pCallerIsGeneralLedgerModule: boolean = False);
{$IFNDEF WEBSERVICE}
var
  pUsrSettingIndex: TStsIndex;
  b: boolean;
  pAccPeriod: integer;
  pNumPrefix: AStr;
  pNumFmt: AStr;
  pNumRealVal: int64;
{$ENDIF}
begin
{$IFNDEF WEBSERVICE}
  // -- kõik nagu vanasti...
  if not estbk_globvars.glob_accPeriontypeNumerators then
  begin
    pUsrSettingIndex := __getNumeratorCacheIndex(pNumeratorType, pCallerIsGeneralLedgerModule);

    if pUsrSettingIndex <> Csts_nothing then
      userStsValues[pUsrSettingIndex] := '';
  end
  else
  begin
    pAccPeriod := 0;
    b := isValidAccountingPeriod(pNumeratorDate, pAccPeriod) and queryNumFormat(TNumeratorTypesSDescr[pNumeratorType],
      pAccPeriod, pNumPrefix, pNumFmt);
    if not b then
      raise Exception.CreateFmt(estbk_strmsg.SECantFindNumFmt, [datetostr(pNumeratorDate)]);


    b := couldbeCustomNumerator(pNumeratorVal, pNumeratorDate, pNumPrefix + pNumFmt); // järsku klient ise pannud müügiarve nr !?!
    if not b then
    begin
      // 14.04.2012 Ingmar; peame formateeritud numbrist üritama leida algset osa
      pNumRealVal := strtointdef(extractNumberFromNumerator(pNumeratorVal, pNumPrefix + pNumFmt), 0);
      __markNumeratorValAsUsedExt(pCallerId, pNumeratorType, IntToStr(pNumRealVal), pNumeratorDate, pCallerIsGeneralLedgerModule);
      //__markNumeratorValAsUsedExt(pCallerId,pNumeratorType,pNumeratorVal,pNumeratorDate,pCallerIsGeneralLedgerModule);
    end;
  end; // --
{$ENDIF}
end;

// frame karjub, et ta pannakse kinni ning sisuliselt broneeritud numeraatorid võib vabaks lasta ja tabelisse kirjutada
procedure TNumerators.notifyNumerators(const pCallerId: PtrUInt);
{$IFNDEF WEBSERVICE}
var
  pNumCache: TNumeratorCache;
  i: integer;
{$ENDIF}
begin
{$IFNDEF WEBSERVICE}
  for i := 0 to FNumeratorCache.Count - 1 do
    if Assigned(FNumeratorCache.Items[i]) then
    begin
      pNumCache := FNumeratorCache.Items[i] as TNumeratorCache;
      if pNumCache.FCallerId = pCallerId then
      begin
        pNumCache.FNumMarkAsReserved := False; // -- !!!
        // ja nulli ära, sest instans ju reaalselt tapeti ära !!!
        pNumCache.FCallerId := 0;
      end;
    end;
{$ENDIF}
end;

// fmt:='A$YY$MM%.10d';
// 14.03.2012 Ingmar; siin paneme paika mingi default formaadi ja teine funktsioon peab uuesti sealt välja arutama reaalse numbri ...
// paras häkk
function TNumerators.formatNumerator(const pNumVal: string; const pDate: TDatetime; const pNumFmt: string;
  const pThrowException: boolean = True): string;
  // A%.10d
var
  pFmtInt: int64;
begin
  if trim(pNumFmt) = '' then
  begin
    Result := pNumVal;
    Exit; // --
  end;

  // A$YY$MM%.10d
  try
    Result := '';
    pFmtInt := strtoint64def(pNumVal, -1);
    Result := format(pNumFmt, [pFmtInt]);
    Result := stringreplace(Result, '$YYYY', IntToStr(yearof(pdate)), [rfReplaceAll]);
    Result := stringreplace(Result, '$YY', copy(IntToStr(yearof(pdate)), 3, 4), [rfReplaceAll]);
    Result := stringreplace(Result, '$MM', format('%.2d', [monthof(pdate)]), [rfReplaceAll]);
  except
    on e: Exception do
      if pThrowException then
        raise Exception.Create(estbk_strmsg.SENumMaskError + #32 + pNumFmt);
  end;
end;

function TNumerators.extractNumberFromNumerator(const pNumVal: AStr; const pNumFmt: AStr): AStr;
const
  CTestFmt = '9999999999';
var
  pCompTemplate: AStr;
  pNumSPos: integer;
  i: integer;
  pBfr: AStr;
  pRezV: int64;
begin
  if trim(pNumFmt) = '' then
  begin
    Result := pNumVal;
    Exit; // --
  end;


  Result := '';
  pBfr := formatNumerator(CTestFmt, now, pNumFmt);
  // ---
  pNumSPos := pos(CTestFmt, pBfr);
  pRezV := strtoint64Def(trim(copy(pNumVal, pNumSPos, 255)), -1);
  Result := IntToStr(pRezV);
end;

function TNumerators.couldbeCustomNumerator(const pNumVal: string; const pDate: TDatetime; const pNumFmt: AStr): boolean;
var
  pPv: AStr;
begin

  if trim(pNumFmt) = '' then
  begin
    Result := False;
    Exit; // --
  end;

  pPv := (extractNumberFromNumerator(pNumVal, pNumFmt));
  Result := formatNumerator(pPv, pDate, pNumFmt, False) <> pNumVal;
end;

// TCriticalSection
function TNumerators.queryNumFormat(const pNumType: AStr; const pAccPeriodId: integer; var pNumPrefix: AStr; var pNumFmt: AStr): boolean;
var
  pTemp: AStr;
  pPos: integer;
begin
  try
       {$IFDEF WEBSERVICE}
    FCs.Enter;
{$ENDIF}

    FNumFmtQuery.First;

    pNumPrefix := '';
    pNumFmt := '';
    Result := FNumFmtQuery.Locate('acc_id;cr_num_type', VarArrayOf([pAccPeriodId, pNumType]), []);
    if Result then
    begin
      pTemp := FNumFmtQuery.FieldByName('cr_srbfr').AsString;
      pPos := pos('&', pTemp);
      pNumPrefix := trim(copy(pTemp, 1, pPos - 1));
      pNumFmt := trim(copy(pTemp, pPos + 1, 255)); // tabelis hoitakse numbrit !


      if pNumFmt = '' then
        pNumFmt := '%d'
      else
        pNumFmt := '%.' + IntToStr(strtointdef(pNumFmt, 0)) + 'd';
    end;

    // @@
  finally
      {$IFDEF WEBSERVICE}
    FCs.Leave;
{$ENDIF}
  end;
end;

function TNumerators.doFinalNumeratorFmt(const pVal: AStr; const pNumType: AStr; const pAccPeriodId: integer; const pDate: TDatetime): AStr;
var
  b: boolean;
  pNumPrefix: AStr;
  pNumFmt: AStr;
begin
  Result := pVal;
  // --
  b := queryNumFormat(pNumType, pAccPeriodId, pNumPrefix, pNumFmt);
  if b then // üritame tuvastada, mis formaati see numeraator kasutab...
    Result := formatNumerator(pVal, pDate, pNumPrefix + pNumFmt);
end;


// 19.09.2009 Ingmar; nummerdamise koht ümber teha, hetkel näen sellega palju probleeme.
// Test lahendus !
function TNumerators.getUniqNumberFromNumerator(const pCallerId: PtrUInt; const pCurrentNumVal: AStr;
  const pNumeratorDate: TDate; const pReloadNumber: boolean; // ----
  const pNumeratorType: TCNumeratorTypes = estbk_types.CAccGen_rec_nr; const pBookSrNr: boolean = True;
  const pCallerIsGeneralLedgerModule: boolean = False): AStr;
var
  b: boolean;
  pSQL: AStr;
  pItemId: integer;
  pNumStart: int64;
  pCurrVal: int64;
  pVRangeStarts: int64;
  pVRangeEnds: int64;
  pNumVersion: integer;
  pDoInc: boolean;
  // 19.05.2011 Ingmar; kui võtsime numbri cachest, siis peame selle ära puhastama mitte uuesti reserveerima !
  pNotPrvUsdrnr: boolean;
  pGetRrvNrIndx: TStsIndex;
  pBfrNumeratorVal: AStr;
  pAccPeriod: integer;
  primConnection: TZConnection;
begin
  try
    {$IFDEF WEBSERVICE}
    FCs.Enter;
    {$ENDIF}

    assert(Assigned(isValidAccountingPeriod), '#1');
    // @@ jätame toetuste vanale numeraatorite loogikale, muidu võb tekkida suuri probleeme kasutajatel
    // 02.03.2012 Ingmar;  kui vanamoodi numeraatorid, kus järjest liigutakse ülespoole; siis refresh puhul peegeldame hetke väärtuse tagasi !
    if not estbk_globvars.glob_accPeriontypeNumerators then
    begin

      // vanas stiilis peegeldame olemaoleva numbri !
      if pReloadNumber then
      begin
        Result := pCurrentNumVal;
        Exit; // --
      end;


      // siin hoitakse siis kasutaja juures viimast kasutamata numbrit !
      pGetRrvNrIndx := __getNumeratorCacheIndex(pNumeratorType, pCallerIsGeneralLedgerModule);
      if (pGetRrvNrIndx <> Csts_nothing) then
      begin
        pBfrNumeratorVal := trim(userStsValues[pGetRrvNrIndx]);
        if pBfrNumeratorVal <> '' then
        begin
          Result := IntToStr(strtointdef(pBfrNumeratorVal, -1));
          if Result <> '-1' then
            Exit; // võtsime andmed cachest !
        end; // ---
      end;
    end
    else  // ---
    begin

      // --
      pAccPeriod := 0;
      b := generateStaticNumAccPeriod(pNumeratorType, pAccPeriod); // staatilised numeraatorid !
      if not b then
        b := isValidAccountingPeriod(pNumeratorDate, pAccPeriod);

      // 06.03.2012 Ingmar
      Result := trim(__getNumeratorCacheExt(pCallerId, pCurrentNumVal, pNumeratorType, pNumeratorDate, pBookSrNr, pReloadNumber));
      if Result <> '' then
        Exit; // !!!

    end;



    // ---- järelikult peame küsima järgmise numeraatori väärtuse !
    try
      primConnection := FCommQuery.Connection as TZConnection;
      // @@
      primConnection.StartTransaction;
      pDoInc := True;
      pSQL := '';
      Result := '';

      case estbk_dbcompability.sqlp.currentBackEnd of
        __postGre:
        begin
          pSQL := 'LOCK TABLE numerators ';
        end;

      end;


      // @@@
      // --- küsime endale numbri
      with FCommQuery, SQL do
        try
          // tabel lukku...
          Close;
          Clear;
          add(pSQL);
          execSQL;


          // ----
          Close;
          Clear;
          if estbk_globvars.glob_accPeriontypeNumerators then
            add(estbk_sqlclientcollection._CSQLGetNumerator)
          else
            // 10.10.2013 Ingmar; et alati leiaks maksimaalse numeraatori, oli kunagi bugi, kus installimisel tehti N + 1 numeraatorit !
            add(estbk_sqlclientcollection._CSQLGetNumerator2);


          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          paramByname('cr_num_type').AsString := estbk_types.TNumeratorTypesSDescr[pNumeratorType];


          // ---
          if not estbk_globvars.glob_accPeriontypeNumerators then
            paramByname('accounting_period_id').Value := null
          else
          begin
            assert(pAccPeriod > 0, '#3');
            paramByname('accounting_period_id').Value := pAccPeriod;
          end;
          Open;

          // ----------
          if EOF then
            raise Exception.Create(SENumeratorError);

          // ---
          pItemId := FCommQuery.FieldByName('id').AsInteger;
          pNumStart := FCommQuery.FieldByName('cr_vrange_start').AsLargeInt;
          pCurrVal := FCommQuery.FieldByName('cr_num_val').AsLargeInt;
          pVRangeStarts := FCommQuery.FieldByName('cr_vrange_start').AsLargeInt;
          pVRangeEnds := FCommQuery.FieldByName('cr_vrange_end').AsLargeInt;
          pNumVersion := FCommQuery.FieldByName('cr_version').AsInteger;

          if pCurrVal < 1 then
          begin
            pCurrVal := pNumStart;
            pDoInc := False;
          end;

          if pCurrVal < 1 then
          begin
            pCurrVal := 1;
            pDoInc := False;
          end;

          // ---
          if pDoInc then
            Inc(pCurrVal);


          // ehk alustame kasutaja poolt sätestatud reeglist
          if pVRangeStarts > pCurrVal then
            pCurrVal := pVRangeStarts;

          if (((pVRangeStarts > 0) and (pCurrVal < pVRangeStarts)) or ((pVRangeEnds > 0) and (pCurrVal > pVRangeEnds))) then
            raise Exception.createFmt(estbk_strmsg.SENumeratorRangeExceeded, [pVRangeStarts, pVRangeEnds]);

          // -- uuendame numeraatorit ! serial/sequence ei sobi numeraatoriks; saaks, kui palju agasid...
          Close;
          Clear;
          add(estbk_sqlclientcollection._CSQLUpdateNumerator);
          // tuntud trikk, mida alati ohutuma koodi pärast tasub rakendada; ütled tüübi ja alles siis null
          paramByName('cr_num_val').AsLargeInt := pCurrVal;
          paramByName('cr_num_start').AsLargeInt := 0;
          paramByName('cr_num_start').Value := null;

          paramByName('cr_vrange_start').AsLargeInt := 0;
          paramByName('cr_vrange_start').Value := null;

          paramByName('cr_vrange_end').AsLargeInt := 0;
          paramByName('cr_vrange_end').Value := null;

          paramByName('cr_version').AsLargeInt := 0;
          paramByName('cr_version').Value := null;

          paramByName('cr_valid').AsBoolean := True;
          paramByName('cr_srbfr').AsString := '';
          paramByName('cr_srbfr').Value := null;
          paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;
          paramByName('id').AsInteger := pItemId;
          execSQL;
          // ----------
          Result := IntToStr(pCurrVal);

        finally
          Close;
          Clear;
        end;


      // ---
      primConnection.Commit;


      // @@@
      // 02.03.2012 Ingmar; et vanamoodi numeraatorid jääks tööle
      if pBookSrNr then
        if not estbk_globvars.glob_accPeriontypeNumerators then
        begin
          // --------------
          // 19.05.2011 Ingmar
          __markNumeratorValAsReserved(pNumeratorType, Result, pCallerIsGeneralLedgerModule);
        end
        else // --
        begin
          __markNumeratorValAsReservedExt(pCallerId, pNumeratorType, Result, pNumeratorDate, pReloadNumber, pCallerIsGeneralLedgerModule);
        end;



    except
      on e: Exception do
      begin
        if primConnection.inTransaction then // ntx võib transaktioon olla tühistatud triggeri poolt !!!
          try
            primConnection.Rollback;
          except
          end;
        // ---------
      end;
    end;

    // 14.04.2012 Ingmar
  finally
    if estbk_globvars.glob_accPeriontypeNumerators then
      try
        Result := doFinalNumeratorFmt(Result, TNumeratorTypesSDescr[pNumeratorType], pAccPeriod, pNumeratorDate);
      except
      end; // --
    {$IFDEF WEBSERVICE}
    FCs.Leave;
{$ENDIF}
  end;
end;

// ntx osad numeraatorid ei tohigi muutuda ! seome need kõige esimese maj. aastaga;
function TNumerators.generateStaticNumAccPeriod(const pNumeratorType: TCNumeratorTypes; var pAccPeriod: integer): boolean;
begin
  Result := False;
  if estbk_globvars.glob_accPeriontypeNumerators then
  begin
    Result := pNumeratorType in [CProd_sr_nr, CSrv_sr_nr, CWProc_sr_nr, CClientId_idef, CWorkContr_nr, COffer_doc_nr, CContr_doc_nr];

    if Result then
      pAccPeriod := estbk_globvars.glob_minAccPeriodForStaticNumerators;
  end;
end;

// 02.03.2012 Ingmar;
procedure TNumerators.loadNumeratorValHistory;
var
  pNumCache: TNumeratorCache;
  i: integer;
  pCheck: boolean;
begin
  with FCommQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectNumCache);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('user_id').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('flags').Value := null;
      Open;

      First;
      while not EOF do
      begin
        pNumCache := TNumeratorCache.Create;
        FNumeratorCache.Add(pNumCache);

        pNumCache.FNumId := FieldByName('id').AsInteger;
        pNumCache.FNumAccPer := FieldByName('num_acc_period_id').AsInteger;
        //pNumCache.FNumIsUsed:=false;
        pNumCache.FCallerId := 0;
        //pNumCache.FNumParity:=1; // märgime, et kasutamata
        pNumCache.FNumMarkAsReserved := False;
        pNumCache.FNumType := FieldByName('num_type').AsString;
        pNumCache.FNumVal := FieldByName('num_value').AsString;

        if FieldByName('num_perstart').IsNull then
          pNumCache.FNumDateStart := now
        else
          pNumCache.FNumDateStart := FieldByName('num_perstart').AsDateTime;


        if FieldByName('num_perend').IsNull then
          pNumCache.FNumDateEnd := now
        else
          pNumCache.FNumDateEnd := FieldByName('num_perend').AsDateTime;
        // ---
        Next;
      end;

      // 29.06.2012 Ingmar; numeraatoritega mingi jama, kasutajad suudavad kuidagi nii teha, et cachesse jääb sisse number ?
      // kas sulgevad taskmanagerist, krt seda teab !
      for i := 0 to FNumeratorCache.Count - 1 do
        with FCommQuery, SQL do
        begin
          pCheck := False;
          Close;
          Clear;

          pNumCache := FNumeratorCache.Items[i] as TNumeratorCache;
          if pNumCache.FNumType = TNumeratorTypesSDescr[CAccCri_rec_nr] then  // Kassa sissetulekuorderi kandeseeria
          begin
            pCheck := True;
            add(estbk_sqlclientcollection._SQLNumeratorQryFixSQL1);
          end
          else
          if pNumCache.FNumType = TNumeratorTypesSDescr[CAccCro_rec_nr] then  // Kassa väljaminekuorderi kandeseeria
          begin
            pCheck := True;
            add(estbk_sqlclientcollection._SQLNumeratorQryFixSQL2);
          end
          else
          if pNumCache.FNumType = TNumeratorTypesSDescr[CAccPmt_rec_nr] then  // Tasumise kandeseeria
          begin
            // 05.07.2012 Ingmar
            pCheck := True;
            add(estbk_sqlclientcollection._SQLNumeratorQryFixSQL3);
            paramByname('ptype').AsString := 'O';
          end;
          if pNumCache.FNumType = TNumeratorTypesSDescr[CPMOrder_doc_nr] then  // - (payment order)maksekorralduse nr
          begin
            // 05.07.2012 Ingmar
            pCheck := True;
            add(estbk_sqlclientcollection._SQLNumeratorQryFixSQL3);
            paramByname('ptype').AsString := 'O';
          end;




          // ---
          if pCheck then
          begin
            paramByname('acc_period').AsInteger := pNumCache.FNumAccPer;
            paramByname('entrynumber').AsString := pNumCache.FNumVal;
            Open;
            // mingi jama; number kasutusel; ignoreerime cachet !!!
            if FieldByName('id').AsInteger > 0 then
            begin
              Close;
              Clear;
              add(estbk_sqlclientcollection._SQLDeleteNumCache);
              paramByname('id').AsInteger := pNumCache.FNumId;
              execSQL;
              // ---
              FNumeratorCache.Delete(i);
            end;
          end; // --
        end; // ---

    finally
      Close;
      Clear;
    end;
end;

procedure TNumerators.saveNumeratorValHistory;
{$IFNDEF WEBSERVICE}
var
  i: integer;
  pNumCache: TNumeratorCache;
  // --
  // TNumeratorCache
{$ENDIF}
begin
{$IFNDEF WEBSERVICE}
  for i := 0 to FNumeratorCache.Count - 1 do
    if Assigned(FNumeratorCache.Items[i]) then
      with FCommQuery, SQL do
        try
          pNumCache := FNumeratorCache.Items[i] as TNumeratorCache;
          Close;
          Clear;

          // -- järelikult uus sissekanne
          if (pNumCache.FNumId < 1) then
          begin
            add(estbk_sqlclientcollection._SQLInsertNumCache);
            paramByname('num_type').AsString := pNumCache.FNumType;
            paramByname('num_value').AsString := pNumCache.FNumVal;
            paramByname('num_acc_period_id').AsInteger := pNumCache.FNumAccPer;
            paramByname('flags').AsInteger := 0; // st. kõik võivad selle numbri võtta kasutusele !!!
            paramByname('user_id').AsInteger := estbk_globvars.glob_worker_id;
            paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
            execSQL;
          end
          else
          begin
            add(estbk_sqlclientcollection._SQLUpdateNumCache);
            paramByname('num_type').AsString := pNumCache.FNumType;
            paramByname('num_value').AsString := pNumCache.FNumVal;
            paramByname('num_acc_period_id').AsInteger := pNumCache.FNumAccPer;
            paramByname('flags').AsInteger := 0; // 1 oleks privaatne nr
            paramByname('id').AsInteger := pNumCache.FNumId;
            execSQL;
          end;

        finally
          Close;
          Clear;
        end;
{$ENDIF}
end;

constructor TNumerators.Create;
begin
  inherited Create;
  {$IFDEF WEBSERVICE}
  FCs := TCriticalSection.Create;
  {$ENDIF}
  FNumeratorCache := TObjectList.Create(True);
  FIsValidAccountingPeriodCallBack := @InternalIsValidAccountingPeriod;
end;

destructor TNumerators.Destroy;
begin
  if Assigned(FCommQuery) then
  begin
    FCommQuery.Connection := nil;
    FreeAndNil(FCommQuery);
  end;

  if Assigned(FNumFmtQuery) then
  begin
    FNumFmtQuery.Connection := nil;
    FreeAndNil(FNumFmtQuery);
  end;


  {$IFDEF WEBSERVICE}
  FreeAndNil(FCs);
  {$ENDIF}
  inherited Destroy;
end;

initialization
  _nm := TNumerators.Create;

finalization
  FreeAndNil(_nm);
end.