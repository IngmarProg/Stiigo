unit estbk_lib_calcdhelper;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, estbk_types, estbk_lib_commoncls, Dialogs;

// moodulite sisemised koodid ühildada !
type
  TFormulaPreParser = class
  protected
    FParsedAccounts: TCollection;
    FDistinctAccounts: TCollection;
    FHasDetailedAccSupport: boolean; // kas toetame ka detailset kontode aruannet;
    FhideZValAccounts: boolean; // !!! nullkontod ära peita
    FRNLineNrs: TAStrList;
    FkeepTogether: boolean;
    FlineLogNr: AStr;
    FLineLongDescr: AStr;
    FLastParsedFormula: AStr;
    FFormulaStr: AStr;
    FFormulaAltStr2: AStr;

    FErrorCode: AStr;
    FLineCode: AStr;

    // kasutame teda selleks, meil juba valem puhverdatuna välja arvutaud !
    FmiscVal: integer;
    FFormulaComputed: boolean;
    FFormulRez: double;
    FFormulRez2: double;
    function getParsedAccounts: TCollection;
  public
    procedure buildDistinctAccountsColl; // kutsuda välja docalc lõpus !!!
    procedure calcOnlyAccSumPerFormula(const pFrmsum: boolean = True);
    property miscVal: integer read FmiscVal write FmiscVal;
    // suvaline väärtus, mida meil vaja hoida seoses antud klassiga; ntx formd rea nr !
    // --
    property accounts: TCollection read getParsedAccounts; // annab meile võimaluse kuvada filtreeritult asju
    property distinctAccounts: TCollection read FDistinctAccounts;
    property errorCode: AStr read FErrorCode;
    property RLines: TAStrList read FRNLineNrs;


    // formula siiski puhvermuutuja klassis, parseformula abil võib ka suvalist valemit parsida, siis lastparsedformule saab omale uue väärtuse
    // natuke hacki moodi formula2 sisuliselt dubleerib formulat ! peegeldus...

    // toon näite meil vaja bilansis arvutada valemi järgi;  Algsaldo 01.03.2011 Lõppsaldo  15.04.2011
    // - meil vaja valem A) kõik saldud kuni 01.03.2011 ja siis valem välja arvutada; 75+95+35 [10110@DS]+[10111@DS]+[10112@DS]+[10113@DS]+[10117@DS]
    // - vaja lõppsaldot selle valemi järgi

    property formula: AStr read FFormulaStr write FFormulaStr;
    property formulaAlt: AStr read FFormulaAltStr2 write FFormulaAltStr2;

    // VARIA !
    // 05.05.2011 Ingmar; isegi detailses bilansis tuleb mõni rida koos hoida !
    property keepTogether: boolean read FkeepTogether write FkeepTogether;
    property lineLogNr: AStr read FlineLogNr write FlineLogNr;
    property lineLongDescr: AStr read FLineLongDescr write FLineLongDescr;


    // 22.02.2011 Ingmar; reakood !
    property lineCode: AStr read FLineCode write FLineCode;


    // --- @rez
    property formulaComputed: boolean read FFormulaComputed write FFormulaComputed;
    property formulaRez: double read FFormulRez write FFormulRez;  // põhivalem; formula baasil
    property formulaAltRez: double read FFormulRez2 write FFormulRez2;
    // formulaAlt; üks valem, kuid kontode väärtused asendatakse erinevates per. tulemustega
    // üks ntx saldo kuni 01.01.2011; teine 01.01.2011-31.01.2011 formulaAltRez
    property lastParsedFormula: AStr read FLastParsedFormula write FLastParsedFormula; // formula--> parseFormula


    function parseFormula(const pFormula: AStr): boolean;
    // eelparsimine, mis eraldab kontod ja $ read ehk siis RLines, kui viidatakse teisele valemi reale
    function stripFormulaRez: AStr; // eeldab esmalt parseFormula väljakutset

    constructor Create(const pHasDetailedAccSupport: boolean = True); reintroduce; // 09.08.2012 Ingmar
    destructor Destroy; override;
  end;

// @@
function __removeFormulaDirectives(const pFormula: AStr): AStr;


implementation

uses estbk_lib_revpolish;

// @@
function __removeFormulaDirectives(const pFormula: AStr): AStr;
begin
  Result := stringreplace(pFormula, estbk_types.CFormulaLineKeepTogether, '', []); // detailne bilanss hoia rida koos !
end;


function TFormulaPreParser.getParsedAccounts: TCollection;
begin
  Result := self.FParsedAccounts;
end;

// häkkide häkk
// 01.08.2012 Ingmar
procedure TFormulaPreParser.buildDistinctAccountsColl;
var
  pCopyOf: TCollection; // kõik kontod !
  pCurrAccObj: TTaxdParsedAccounts;
  pNewAccObj: TTaxdParsedAccounts;
  pItemExists: boolean;
  i, j: integer;
begin
  // kui pole detailset reziimi, siis kõik nagu vanasti !
  if not self.FHasDetailedAccSupport then
  begin
    self.FDistinctAccounts := self.FParsedAccounts;
    Exit; // --
  end;


  // self.FDistinctAccounts:=self.FParsedAccounts;

  // teeme privaatse koopia distinct jaoks !
  self.FDistinctAccounts.Clear;
  pCopyOf := self.accounts;


  for i := 0 to pCopyOf.Count - 1 do
  begin
    // --
    pItemExists := False;
    for j := 0 to self.FDistinctAccounts.Count - 1 do
    begin
      pItemExists := ansilowercase((self.FDistinctAccounts.Items[j] as TTaxdParsedAccounts).FAccountCode) =
        ansilowercase((pCopyOf.Items[i] as TTaxdParsedAccounts).FAccountCode);
      if pItemExists then
        break;
    end;

    // TAASTADA
  {
  if  (

    ((pCopyOf.Items[i] as TTaxdParsedAccounts).FAccountCode<>'31')

  and ((pCopyOf.Items[i] as TTaxdParsedAccounts).FAccountCode<>'3101')) then
     continue;}

    if pItemExists then
      continue;



    pCurrAccObj := pCopyOf.Items[i] as TTaxdParsedAccounts;
    // ---
    pNewAccObj := self.FDistinctAccounts.Add as TTaxdParsedAccounts;
    pNewAccObj.FOrigOrder := -1; // antud juhul pole meil mingi kasu sellest indeksist !
    pNewAccObj.FAccountCode := pCurrAccObj.FAccountCode;
    pNewAccObj.FAccountLongName := pCurrAccObj.FAccountLongName;
    pNewAccObj.FAccountAttr := '';
    pNewAccObj.FAccType := '';

    pNewAccObj.FIndxStart := -1;
    pNewAccObj.FIndxEnds := -1;
    // -- taxdeclcalc !
    pNewAccObj.FAccountId := pCurrAccObj.FAccountId;
    //pNewAccObj.FAccFormulaSum:=pCurrAccObj.FAccFormulaSum;
    //pNewAccObj.FBalanceChange:=pCurrAccObj.FBalanceChange;
    pNewAccObj.FAccFormulaSum := 0.00;
    pNewAccObj.FBalanceChange := 0.00;

    // kopeerida kaasa ?
    //pNewAccObj.FAccFormulaSum:=pCurrAccObj.FAccFormulaSum;
    //pNewAccObj.FBalanceChange:=pCurrAccObj.FBalanceChange;
    pNewAccObj.Fprocessed := False;
  end;
end;

// TODO; vaata antud asi üle, siin liiga kehv kood, liiga palju tsükleid !!!
// Võtta vaid antud konto tehe valemist;
// [10%@DK]+$1-[10%KK]+[40%SA]; loogika järgi oleks detailses bilansis info;
// [10%@DK]+0-[10%KK]+0;
procedure TFormulaPreParser.calcOnlyAccSumPerFormula(const pFrmsum: boolean = True);
// nullib kõik teised read, mis pole antud kontoga seotud
  procedure __intzFormula(var pFormula: string);
  var
    pPos: integer;
    pEndPos: integer;
    pProceed: boolean;
  begin
    // --
    pProceed := True;
    while pProceed do
    begin
      // asendame valemisse üles jäänud kontod !!!
      pPos := pos('[', pFormula);
      pProceed := pPos > 0;
      if pProceed then
      begin
        pEndPos := pPos;
        while pEndPos <= length(pFormula) do
          if pFormula[pEndPos] = ']' then
            break
          else
            Inc(pEndPos);

        system.Delete(pFormula, pPos, (pEndPos - pPos) + 1);
        system.Insert('0', pFormula, pPos);
      end;

      // asendame viiteread !
      pPos := pos('$', pFormula);
      pProceed := pProceed or (pPos > 0);
      if pPos > 0 then
      begin
        pEndPos := pPos + 1;
        while pEndPos <= length(pFormula) do
          if pFormula[pEndPos] in ['0'..'9'] then
            Inc(pEndPos)
          else
            break;
        system.Delete(pFormula, pPos, (pEndPos - pPos));
        system.Insert('0', pFormula, pPos);
      end;


      // ---
    end;
  end;

  // function    _detectAccFormulaIndex();
var
  i, j, k: integer;
  pDistAcc: TTaxdParsedAccounts;
  pOrigAcc: TTaxdParsedAccounts;
  pSeek: TTaxdParsedAccounts;
  pOrigFrm: AStr;

  pOrigIdxStart: integer;
  pOrigIdxEnd: integer;

  // pParentAcc    : Integer;
  pParentAccCode: AStr;
  pAccLen: integer;
  //pAccFrmSum : Double;
  //pAccBalSum : Double;
  pFrmAddSum: double; // mis summa paneme valemisse
  //pTmpParser : TFormulaPreParser;
  pRevPolish: TRevPolish;
  pFailedFormula: AStr;
  //pFollowNext    : Boolean;
  //f: textfile;
begin
  // vaid detailse reziimi puhul teisendame valemi nii, et tehe hõlmaks vaid antud kontorida
  if not self.FHasDetailedAccSupport then
    Exit;

  // ---
  for i := self.FDistinctAccounts.Count - 1 downto 0 do
  begin
    pOrigFrm := self.FLastParsedFormula;
    // 08.08.2012 Ingmar; kaotame ära & markeri st hoia rida koos, ka detailses vaates !
    pOrigFrm := stringreplace(pOrigFrm, '&', '', [rfReplaceAll]);
    pDistAcc := self.FDistinctAccounts.Items[i] as TTaxdParsedAccounts;




    // ---
    for j := self.accounts.Count - 1 downto 0 do
    begin

      // ---
      pOrigAcc := self.accounts.Items[j] as TTaxdParsedAccounts;


      //if (pOrigAcc.FAccountCode='3501') and (pOrigAcc.FAccountCode = pDistAcc.FAccountCode)  then
      //  begin
      //     showmessage(pOrigAcc.FAccountCode+' # '+pOrigAcc.FAccountAttr);
      //  end;
      // pAccFrmSum:=pOrigAcc.FAccFormulaSum;
      // pAccBalSum:=pOrigAcc.FBalanceChange;

      // --
      case pFrmsum of
        True: pFrmAddSum := pOrigAcc.FAccFormulaSum;
        False: pFrmAddSum := pOrigAcc.FBalanceChange;
      end;

{
  if pFrmAddSum>0 then
     begin
        assignfile(f,'c:\test.txt');
        rewrite(f);
        writeln(f, pFrmAddSum,  pDistAcc.FAccountCode );
        closefile(f);
      end;
}
      if pOrigAcc.FAccountCode = pDistAcc.FAccountCode then
      begin

        pOrigIdxStart := pOrigAcc.FIndxStart;
        pOrigIdxEnd := pOrigAcc.FIndxEnds;

        // üritame valemiga leida vaid antud kontodega seotud väärtused !
        // kui neg. indeks, järelikult allkonto; ainus jama, et parent indeksit pole
        if pOrigIdxStart = -1 then // leiame indeksi !
        begin
          pParentAccCode := pOrigAcc.FAccountCode;
          pAccLen := length(pParentAccCode);
          while True do
          begin
            Dec(pAccLen);
            if pAccLen < 1 then
            begin
              pParentAccCode := '';
              break;
            end; // --

            pParentAccCode := copy(pParentAccCode, 1, pAccLen);
            for k := self.accounts.Count - 1 downto 0 do
            begin

              pSeek := self.accounts.Items[k] as TTaxdParsedAccounts;
              if (pSeek.FAccountAttr = pOrigAcc.FAccountAttr) and ((pSeek.FAccountCode = pParentAccCode) or
                (pSeek.FAccountCode = pParentAccCode + '%')) then
              begin

                pOrigIdxStart := pSeek.FIndxStart;
                pOrigIdxEnd := pSeek.FIndxEnds;

                system.Delete(pOrigFrm, pOrigIdxStart - 1, (pOrigIdxEnd - pOrigIdxStart) + 3);
                system.Insert(floattostr(pFrmAddSum), pOrigFrm, pOrigIdxStart - 1);
                pAccLen := -1;
                //  break;
              end;
            end; // ---
          end;
          // ---
        end
        else
        begin

          for k := self.accounts.Count - 1 downto 0 do
          begin

            pSeek := self.accounts.Items[k] as TTaxdParsedAccounts;
            if (pSeek.FAccountAttr = pOrigAcc.FAccountAttr) and (pSeek.FAccountCode = pOrigAcc.FAccountCode) then
              // 07.08.2012 ingmar; bugi, mida kaua otsisin; pidin hulluks minema, siin ei tohi relatiivseid kontosid lahendada !
              //(pOrigAcc.FAccountCode<>'') and
              //(pOrigAcc.FAccountCode[length( pOrigAcc.FAccountCode)]<>'%') then
            begin
              pOrigIdxStart := pSeek.FIndxStart;
              pOrigIdxEnd := pSeek.FIndxEnds;

              system.Delete(pOrigFrm, pOrigIdxStart - 1, (pOrigIdxEnd - pOrigIdxStart) + 3);
              system.Insert(floattostr(pFrmAddSum), pOrigFrm, pOrigIdxStart - 1);
            end;
          end; // ---

        end;


        // pOrigAcc:=self.accounts.Items[j] as TTaxdParsedAccounts;
        // showmessage(pOrigAcc.FAccountCode+' '+inttostr(pOrigIdxStart)+' '+floattostr(pAccFrmSum)+' '+floattostr(pAccBalSum));
      end;
      // ----------------------------------------------------------------------
      // valem täidetud, viskame ülejäänud info välja !!
      // ----------------------------------------------------------------------
    end;

    // 06.08.2012 Ingmar; nüüd teeme  trikki, et kõik järgi jäänud kontod ja $ read nullime
    try
      try
        pFailedFormula := pOrigFrm;
        pRevPolish := estbk_lib_revpolish.TRevPolish.Create();
        __intzFormula(pOrigFrm);
        pRevPolish.parseEquation(pOrigFrm);
        pFrmAddSum := pRevPolish.eval;
        //pTmpParser.parseFormula(pOrigFrm);
        //pFrmAddSum:=pTmpParser.formulaRez;


        case pFrmsum of
          True: pDistAcc.FAccFormulaSum := pFrmAddSum;
          False: pDistAcc.FBalanceChange := pFrmAddSum;
        end;
        // --
      finally
        FreeAndNil(pRevPolish);
      end;

    except
      on e: Exception do
        raise Exception.Create(e.Message + #32 + ' formula ' + pFailedFormula);
    end;
    // ---
  end;
  // if (pAccFrmSum>0) or (pAccBalSum>0) then
   {
         begin
          assignfile(f,'c:\test.txt');
          append(f);
          writeln(f,pOrigFrm);
          closefile(f);
         end;}
  // ---
end;


// tulevikus lisame ka exception koodid !
function TFormulaPreParser.parseFormula(const pFormula: AStr): boolean;
var
  pParseAcc: AStr;
  pParseAttr: AStr;
  pParseLineDef: AStr;
  pPos: integer;
  pParity, i, pParityStart, pFormStart: integer;
  pParityOpen: boolean;
  pParityClosed: boolean;
  pLineDefOpen: boolean;
  pNewAccObj: TTaxdParsedAccounts;
  pAccountFrnIndx: integer; // mitmes konto ta on valemis
begin

  Result := False;

  self.FErrorCode := '';
  self.FFormulaStr := pFormula; // gl
  // -----
  self.FLastParsedFormula := self.FFormulaStr; // jätame meelde viimase parsitud valemi !
  // -----

  pAccountFrnIndx := 0;
  pParity := 0;
  pParityOpen := False;
  pParityStart := 1;
  pLineDefOpen := False;
  pFormStart := 0;
  self.FkeepTogether := False;


  self.FRNLineNrs.Clear;
  self.FParsedAccounts.Clear;
  self.FDistinctAccounts.Clear;

  try




    for i := 1 to length(self.FFormulaStr) do
    begin
      // hoia rida koos lipp !
      if self.FFormulaStr[i] = '&' then
      begin
        if i = 1 then
          self.FkeepTogether := True
        else
        begin
          self.FErrorCode := 'PR008';
          exit;
        end;
      end
      else
      // ---
      if self.FFormulaStr[i] = '[' then
      begin
        // jama ja nägemist; [AAAAA[ case...
        if (pParityOpen and not pParityClosed) or pLineDefOpen then
        begin
          self.FErrorCode := 'PR001';
          exit;
        end;

        pParityStart := i;
        Inc(pParity);
        pParityOpen := True;
        pParityClosed := False;
      end
      else
      if self.FFormulaStr[i] = ']' then
      begin
        // jälle nägemist, põhiline viisakas olla AAA]A]
        if pParityClosed and not pParityOpen or pLineDefOpen then
        begin
          self.FErrorCode := 'PR002';
          exit;
        end;

        Dec(pParity);
        pParityClosed := True;
        pParityOpen := False;
        pParseAcc := trim(copy(self.FFormulaStr, pParityStart + 1, i - pParityStart - 1));
        if pParseAcc = '' then
        begin
          self.FErrorCode := 'PR003';
          exit;
        end;

        pPos := pos('@', pParseAcc);
        if pPos = 0 then
        begin
          self.FErrorCode := 'PR004';
          exit;
        end;

        pParseAttr := trim(copy(pParseAcc, pPos + 1, (length(pParseAcc) - pPos) + 1));
        if pParseAttr = '' then
        begin
          self.FErrorCode := 'PR005';
          exit;
        end;

        Delete(pParseAcc, pPos, (length(pParseAcc) - pPos) + 1);
        pParseAcc := trim(pParseAcc);
        if pParseAcc = '' then
        begin
          self.FErrorCode := 'PR004';
          exit;
        end;



        pNewAccObj := FParsedAccounts.Add as TTaxdParsedAccounts;
        pNewAccObj.FAccountId := 0;
        pNewAccObj.FAccountCode := pParseAcc;
        pNewAccObj.FAccountAttr := AnsiUpperCase(pParseAttr);
        pNewAccObj.FIndxStart := pParityStart + 1;
        pNewAccObj.FIndxEnds := i - 1;


        // 27.04.2011 Ingmar; mitmes konto valemis !
        Inc(pAccountFrnIndx);
        pNewAccObj.FOrigOrder := pAccountFrnIndx;

      end
      else
      if not pParityOpen or not pParityClosed then
      begin
        // --
        if pLineDefOpen and (AnsiUpperCase(self.FFormulaStr[i]) = estbk_types.CFormulaLineSpecialMarker) then
        begin
          self.FErrorCode := 'PR006';
          exit;
        end;

        if pLineDefOpen then // marker on lahti ($1+$2)/2       $ märk on lingitud rea marker
        begin

          if (self.FFormulaStr[i] in ['+', '-', '*', '/', '[', ']', '(', ')']) or ((i = length(self.FFormulaStr)) and
            (self.FFormulaStr[i] in ['0'..'9'])) then
          begin
            if (i = length(self.FFormulaStr)) then
              pParseLineDef := copy(self.FFormulaStr, pFormStart, (i - pFormStart) + 1)
            else
              pParseLineDef := copy(self.FFormulaStr, pFormStart, (i - pFormStart));
            pLineDefOpen := False;


            // ntx saame ka ridu liita ja lahutada; ühele reale arvutame summa ja liidame teisega
            if length(pParseLineDef) <= 1 then
            begin
              self.FErrorCode := 'PR006';
              exit;
            end;

            // --
            FRNLineNrs.Add(pParseLineDef);
          end
          else
          if not (self.FFormulaStr[i] in ['0'..'9']) then
          begin
            self.FErrorCode := 'PR007';
            exit;
          end;
        end;

        // --
        if AnsiUpperCase(self.FFormulaStr[i]) = estbk_types.CFormulaLineSpecialMarker then
        begin
          pFormStart := i;
          pLineDefOpen := True;
        end;
      end;
    end;

    // ---
    Result := pParity = 0;
    if not Result then
      exit;

    // 01.08.2012 Ingmar; lihtnimistu ilma allkontodeta ! eelinitsialiseerimine !!!
    self.buildDistinctAccountsColl();
  finally
    if not Result then
    begin
      self.FParsedAccounts.Clear;
      self.FDistinctAccounts.Clear;
    end; // ---
  end;
end;

function TFormulaPreParser.stripFormulaRez: AStr;
var
  i: integer;
begin

  Result := self.FFormulaStr;
  for i := FParsedAccounts.Count - 1 downto 0 do
    with FParsedAccounts.Items[i] as TTaxdParsedAccounts do
    begin
      Delete(Result, FIndxStart - 1, (FIndxEnds - FIndxStart + 1) + 2);
      insert(floattostr(1.00 + i), Result, FIndxStart - 1); // et valemi jooksutamisel ei tuleks 0 jagamist !
    end;

  // asendame ka R read kontrollnumbritega
  for i := 0 to self.FRNLineNrs.Count - 1 do
    if trim(self.FRNLineNrs.Strings[i]) <> '' then
    begin
      Result := stringreplace(Result, self.FRNLineNrs.Strings[i], IntToStr(10 + i), []);
    end;
end;

constructor TFormulaPreParser.Create(const pHasDetailedAccSupport: boolean = True);
begin
  inherited Create;
  FParsedAccounts := TCollection.Create(TTaxdParsedAccounts);
  FDistinctAccounts := TCollection.Create(TTaxdParsedAccounts);
  FHasDetailedAccSupport := pHasDetailedAccSupport;
  FRNLineNrs := TAStrList.Create;
end;

destructor TFormulaPreParser.Destroy;
begin
  FreeAndNil(FParsedAccounts);
  if self.FHasDetailedAccSupport then // teisel juhul  FDistinctAccounts = FParsedAccounts
    FreeAndNil(FDistinctAccounts);

  FreeAndNil(FRNLineNrs);
  inherited Destroy;
end;

end.