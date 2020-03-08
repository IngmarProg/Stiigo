unit estbk_lib_declcalc;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
{$ASSERTIONS ON}
interface

uses
  Classes, SysUtils, Contnrs, Math, estbk_clientdatamodule, estbk_lib_commoncls, estbk_lib_mapdatatypes, estbk_dbcompability,
  estbk_lib_revpolish, estbk_utilities, estbk_lib_calcdhelper, estbk_types, Variants, ZDataset, DB, Dialogs;

// antud moodul arvutab maksudeklaratsioonidele summad
type
  TDeclcalc = class
  protected
    FFormdLines: TAStrList;
    FWorkerQry: TZQuery;
    FRevPolish: TRevPolish;
    FDeclPerStart: TDatetime;
    FDeclPerEnd: TDatetime;
    FhasDetailedAccLinesSupport: boolean;
    FBreakProc: boolean; // kiudude jaoks, töötlemine katkestatakse !
    FskipFinSummaryRec: boolean;
    FSafeBreakSign: TMultiReadExclusiveWriteSynchronizer;
    function getBreakProcVal: boolean;
    procedure setBreakProcVal(const v: boolean);
    procedure calcFormulaLineValues(var pRLinesCnt: integer; const pCalcFormula2: boolean = False);
    procedure createPreBufferingTable(var pBfrTableName: Astr);
    procedure fillBufferingTableWithAcc(const pBfrTableName: Astr);
    procedure calcAccAttrValues(const pBalanceChangeMode: boolean; // bilansil vajalik, kas peame ka saldomuutust arvestama !
      const pBfrTableName: Astr);

  public
    property hasDetailedAccLinesSupport: boolean read FhasDetailedAccLinesSupport write FhasDetailedAccLinesSupport;
    property skipFinSummaryRec: boolean read FskipFinSummaryRec write FskipFinSummaryRec; // kas arvestame sulgemiskandeid !
    // ---
    property declStart: TDatetime read FDeclPerStart write FDeclPerStart;
    property declEnd: TDatetime read FDeclPerEnd write FDeclPerEnd;
    property declDataLines: TAStrList read FFormdLines;

    // NB !
    property breakProc: boolean read getBreakProcVal write setBreakProcVal; // et kius olles saaks töö lõpetada !
    procedure Clear;
    function prepareCalc(const pDeclFormId: integer; var pErrorCode: AStr): boolean; // skännib läbi valemid
    function doCalc(const pBalanceChangeMode: boolean; var pErrorCode: AStr; const pSortAccounts: boolean = False;
      const pSkipZAccounts: boolean = False  // 0 tulemusega kontosid ei kuva; detailne bilanss !
      ): boolean; // pBalanceChangeMode; detailsel bilansil on algsaldo kuupäevani N ja siis lõppsaldo...
    constructor Create;
    destructor Destroy; override;
  end;



implementation

uses estbk_sqlclientcollection, estbk_reportsqlcollection, estbk_globvars, estbk_strmsg, strutils, dateutils;

function TDeclcalc.getBreakProcVal: boolean;
begin
  try
    FSafeBreakSign.Beginread;
    Result := self.FBreakProc;
  finally
    FSafeBreakSign.Endread;
  end;
end;

procedure TDeclcalc.setBreakProcVal(const v: boolean);
begin
  try
    FSafeBreakSign.BeginWrite;
    self.FBreakProc := v;
  finally
    FSafeBreakSign.EndWrite;
  end;
end;

procedure TDeclcalc.Clear;
var
  i: integer;
begin
  for i := 0 to FFormdLines.Count - 1 do
    if assigned(FFormdLines.Objects[i]) then
    begin
      FFormdLines.Objects[i].Free;
      FFormdLines.Objects[i] := nil;
    end;

  // --
  FFormdLines.Clear;
end;

function TDeclcalc.prepareCalc(const pDeclFormId: integer; var pErrorCode: AStr): boolean;
var
  pFormula: AStr;
  pLine: AStr;
  pRefObjList: TObjectList;
  pFormulaParser: TFormulaPreParser;

begin
  Result := False;
  pErrorCode := '';
  pFormulaParser := nil;
  // !!!
  self.Clear;
  try
    try
      pRefObjList := TObjectList.Create(True);

      FWorkerQry.Close;
      FWorkerQry.SQL.Clear;
      FWorkerQry.SQL.add(estbk_sqlclientcollection._SQLSelectDFormDetailedLines);
      FWorkerQry.ParamByname('formd_id').AsInteger := pDeclFormId;
      FWorkerQry.Open; // order by on reanr järgi !!! kui ei oleks siis valemis R1+R2 jne ei töötaks !
      if FWorkerQry.EOF then
        exit;


      // external !
      dmodule.fetchAccRefFormdLine(pDeclFormId, pRefObjList);



      while not FWorkerQry.EOF do
      begin
        pFormula := trim(FWorkerQry.FieldByName('formula').AsString);
        // tuletad valem rp. kontode viidetest !
        if pformula = '' then
          pformula := dmodule.buildDefaultFormulaLine(FWorkerQry.FieldByName('id').AsInteger, pRefObjList);




        pFormulaParser := TFormulaPreParser.Create(self.FhasDetailedAccLinesSupport);
        pFormulaParser.miscVal := FWorkerQry.FieldByName('row_nr').AsInteger;


        // 22.02.2011 Ingmar
        pFormulaParser.lineCode := FWorkerQry.FieldByName('row_id').AsString;
        pFormulaParser.formula := pFormula;
        pFormulaParser.formulaAlt := pFormula;



        assert(pFormulaParser.parseFormula(pFormula), '#1');
        // ---
        pFormulaParser.lineLongDescr := FWorkerQry.FieldByName('line_descr').AsString;
        pFormulaParser.lineLogNr := FWorkerQry.FieldByName('log_nr').AsString;


        pLine := FWorkerQry.FieldByName('log_nr').AsString + estbk_types.CInternalConcatMarker + FWorkerQry.FieldByName('line_descr').AsString;
        FFormdLines.AddObject(pLine, pFormulaParser);

        // ---
        FWorkerQry.Next;
      end;


    finally
      FWorkerQry.Close;
      FWorkerQry.SQL.Clear;
    end;

    // --
    Result := True;
  except
    on e: Exception do
    begin
      pErrorCode := e.Message;
      if assigned(pFormulaParser) then
        FreeAndNil(pFormulaParser);
    end;
  end;
end;

// arvutab siis vormide ridade väärtused välja !
procedure TDeclcalc.calcFormulaLineValues(var pRLinesCnt: integer; const pCalcFormula2: boolean = False);
// SUB
  function _readFormula(const pFormula: TFormulaPreParser): AStr;
  begin
    Result := '';
    case pCalcFormula2 of
      False: Result := pFormula.formula;
      True: Result := pFormula.formulaAlt;
    end;
  end;

  function __varsafereplace(const pIdentifier: AStr; const pVal: double; var pStrv: AStr): AStr;
  var
    ppos: integer;
    pnext: integer;

  begin
    Result := pStrv;
    pnext := 1;
    ppos := posEx(pIdentifier, Result, pnext);
    while ppos > 0 do
    begin
      // kõik on tore; $1 puhul võib see ka $10 olla või $11 jne
      if ((ppos + length(pIdentifier) < length(Result)) and not (Result[ppos + length(pIdentifier)] in ['0'..'9'])) or
        (ppos + length(pIdentifier) - 1 = length(Result)) then
      begin
        system.Delete(Result, ppos, length(pIdentifier));
        system.Insert(floattostr(pVal), Result, ppos);
        pnext := ppos + length(floattostr(pVal));
      end
      else
        Inc(pnext);
      // pnext:=(ppos+length(pIdentifier))-1;
      ppos := posEx(pIdentifier, Result, pnext);
    end;
  end;

  procedure __writeFormula(const pFormula: TFormulaPreParser; const pFormulaStr: AStr);
  begin

    case pCalcFormula2 of
      False: pFormula.formula := pFormulaStr;
      True: pFormula.formulaAlt := pFormulaStr;
    end;
  end;
  // ----
const
  CMaxLogicalLoops = 32000;
var

  pInfLoopWatch: integer;
  pRlineIndx: integer;
  pCalcRez: double;
  pRCodeId: AStr;
  pFormulaStr: AStr;
  i, j, k: integer;
begin

  pInfLoopWatch := 0;

  // ALUSTAME ARVUTAMIST ! valemis on väärtused asendatud !
  // ------------------------------------------------------------------------
  // --- hakkame ridu linkima ja lõplikut tulemust arvutama
  // ------------------------------------------------------------------------

  while (pRLinesCnt > 0) and (self.FFormdLines.Count > 0) do
    for i := 0 to self.FFormdLines.Count - 1 do // sisuliselt ongi need read R1,R2,R3,R4... +1
    begin // .2

      Inc(pInfLoopWatch); // Rekursiooni valvekoer:))
      if pInfLoopWatch > CMaxLogicalLoops then
        raise Exception.Create(estbk_strmsg.SEDeclPossibleRecDetected);




      // 23.02.2011 Ingmar tühi valemirida nüüd lubatud !
      if trim(_readFormula(TFormulaPreParser(FFormdLines.Objects[i]))) = '' then
      begin
        Dec(pRLinesCnt);
        continue;
      end;



      // alustame algusest...
      if i = 0 then
        pRLinesCnt := 0;


      if assigned(FFormdLines.Objects[i]) then
      begin
        pRLinesCnt := pRLinesCnt + TFormulaPreParser(FFormdLines.Objects[i]).RLines.Count;
        // tohime välja arvutada !
        if TFormulaPreParser(FFormdLines.Objects[i]).RLines.Count = 0 then
        begin

          // 20.02.2011 Ingmar; nüüd asendasin nö reanumbrid reakoodiga !
          pRCodeId := TFormulaPreParser(FFormdLines.Objects[i]).lineCode;

          // kas juba oleme korra arvutanud ?!
          if not TFormulaPreParser(FFormdLines.Objects[i]).formulaComputed then
          begin

            pFormulaStr := _readFormula(TFormulaPreParser(FFormdLines.Objects[i]));
            if not self.FRevPolish.parseEquation(__removeFormulaDirectives(pFormulaStr)) then
              raise Exception.Create(self.FRevPolish.lastError);


            // küsime valemi tulemuse
            pCalcRez := self.FRevPolish.eval;
            case pCalcFormula2 of
              False: TFormulaPreParser(FFormdLines.Objects[i]).formulaRez := pCalcRez;
              True: TFormulaPreParser(FFormdLines.Objects[i]).formulaAltRez := pCalcRez;
            end;

            // ---
            TFormulaPreParser(FFormdLines.Objects[i]).formulaComputed := True;
          end;




          // CFormulaLineSpecialMarker
          // nüüd vaatame, kas saame kusagil tulemuse väärtustada !
          for k := 0 to self.FFormdLines.Count - 1 do // R read + 1
            if (k <> i) and (TFormulaPreParser(FFormdLines.Objects[k]).RLines.Count > 0) then
            begin // .1


              //pRline:=format('R%d',[i+1]);
              pRlineIndx := TFormulaPreParser(FFormdLines.Objects[k]).RLines.IndexOf(pRCodeId);
              if pRlineIndx >= 0 then
              begin

                // debugimise lihtsustamiseks kirjutame mitu korda andmeid muutujasse !
                pFormulaStr := _readFormula(TFormulaPreParser(FFormdLines.Objects[k]));
                // 30.11.2011 Ingmar; jõhker bugi; ntx oli valemis $1, aga ka $11 siis asendati mõlemad !!! stupid !
                         {
                         pFormulaStr:=stringReplace( pFormulaStr,
                                                     pRCodeId,
                                                     floattostr(TFormulaPreParser(FFormdLines.Objects[i]).formulaRez),
                                                     [rfReplaceAll, rfIgnoreCase]);

                         }
                pFormulaStr := __varsafereplace(pRCodeId, TFormulaPreParser(FFormdLines.Objects[i]).formulaRez, pFormulaStr);

                // uuendame järjekordselt valemit !
                __writeFormula(TFormulaPreParser(FFormdLines.Objects[k]), pFormulaStr);



                for j := TFormulaPreParser(FFormdLines.Objects[k]).RLines.Count - 1 downto 0 do
                  if AnsiUpperCase(TFormulaPreParser(FFormdLines.Objects[k]).RLines.Strings[j]) = pRCodeId then
                    TFormulaPreParser(FFormdLines.Objects[k]).RLines.Delete(j);


                // teeme arvutuse ära, siis ei pea hiljem tsüklit kordama
                if TFormulaPreParser(FFormdLines.Objects[k]).RLines.Count = 0 then
                  if not TFormulaPreParser(FFormdLines.Objects[k]).formulaComputed then
                  begin

                    // uuesti väärtustame lihtsama debugimise jaoks !
                    pFormulaStr := _readFormula(TFormulaPreParser(FFormdLines.Objects[k]));
                    if not self.FRevPolish.parseEquation(__removeFormulaDirectives(pFormulaStr)) then
                      raise Exception.Create(self.FRevPolish.lastError);

                    case pCalcFormula2 of
                      False: TFormulaPreParser(FFormdLines.Objects[k]).formulaRez := self.FRevPolish.eval; // küsime valemi tulemuse
                      True: TFormulaPreParser(FFormdLines.Objects[k]).formulaAltRez := self.FRevPolish.eval; // küsime valemi tulemuse
                    end;


                    TFormulaPreParser(FFormdLines.Objects[k]).formulaComputed := True;
                  end;
              end;
            end;  // .1
          // ---
        end;
      end;
    end;  // .2
end;

procedure TDeclcalc.createPreBufferingTable(var pBfrTableName: Astr);
var
  pBuildTmp: TAStrList;
begin
  pBuildTmp := TAStrList.Create;
  with pBuildTmp do
    try
      add('SELECT ');
      add(' a.id AS account_id,');
      add(' a.account_coding,');
      add(' a.account_name,');
      //add(' CAST('''' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarCharType(25)+') AS parent_account_coding,');
      add(' CAST(0.00 AS ' + estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType() + ') AS init_balance,');
      add(' CAST(0.00 AS ' + estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType() + ') AS init_balance2,');
      add(' CAST(0.00 AS ' + estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType() + ') AS dsum,');  //  ntx deebetkäive
      add(' CAST(0.00 AS ' + estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType() + ') AS csum,');  //  ntx kreeditkäive

      add(' CAST(0.00 AS ' + estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType() + ') AS dsum2,');
      // kui bilanss siis meil vaja saldo muutust ju !
      add(' CAST(0.00 AS ' + estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType() + ') AS csum2,');

      add(' CAST('''' AS ' + estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarCharType(2) + ') AS account_type,');
      add(' CAST('''' AS ' + estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarcharType(2) + ') AS attr');


      add('FROM accounts a');
      add('WHERE 0=1');


      // --- loome nüüd ka tabeli !
      self.FWorkerQry.Close;
      self.FWorkerQry.SQL.Clear;



      pBfrTableName := 'bfr';
      self.FWorkerQry.SQL.add(sqlp._create_temptable(pBfrTableName, pBuildTmp.Text, True));
      self.FWorkerQry.ExecSQL;


    finally
      FreeAndNil(pBuildTmp);
    end;
end;

procedure TDeclcalc.fillBufferingTableWithAcc(const pBfrTableName: Astr);
var
  i, j: integer;
  pMainSQL: AStr;
  pChildSQL: AStr;
  pAccCode: AStr;
  pTemp: AStr;
  pFrmParser: TFormulaPreParser;
  pFrmAcc: TTaxdParsedAccounts;
  pAccColl: TCollection;
  pMarkerPos: integer;
  pExpAcc: boolean; // ntx süntaks 11%@SA; kõikide kontode saldo, mis algab 11__
  pChildAcc: TAStrList;
  pNewAccObj: TTaxdParsedAccounts;

begin

  try
    pChildAcc := TAStrList.Create;
    //pChildAcc.Duplicates:=dupIgnore;
    // SQL 1-1 seos !
    with self.FWorkerQry, SQL do
    begin

      // allkontode leidmine !
      Close;
      Clear;
      // ---
      Add(format('INSERT INTO %s(account_id,account_coding,account_name,account_type,attr)', [pBfrTableName]));
      Add('SELECT COALESCE(a.id,0),COALESCE(a.account_coding,:account_coding),a.account_name,t.shortidef,:attr');

      Add('FROM __int_systemtypes');
      Add('LEFT OUTER JOIN accounts a ON');
      Add('a.account_coding ' + sqlp._like() + ' :account_coding AND a.company_id=:company_id AND a.rec_deleted=''f''');
      add('LEFT OUTER JOIN classificators t ON');
      add('t.id=a.type_id');

      Add('WHERE bbool=''t''');
      Add(' AND NOT EXISTS(');
      Add(' SELECT p.*');
      Add(format(' FROM %s p', [pBfrTableName]));
      Add(' WHERE p.account_coding ' + sqlp._like() + 'a.account_coding '); // ILIKE !!
      Add('   AND p.attr ' + sqlp._like() + ':attr)');
      Add('ORDER BY a.account_coding');
      // --------
      pChildSQL := Text;



      // põhiline insert, kus kontokood ikka detailne !
      Close;
      Clear;
      // ---
      Add(format('INSERT INTO %s(account_id,account_coding,account_name,account_type,attr)', [pBfrTableName]));
      Add('SELECT COALESCE(a.id,0),:account_coding,a.account_name,t.shortidef,:attr');

      Add('FROM __int_systemtypes');
      Add('LEFT OUTER JOIN accounts a ON');
      Add('a.account_coding=:account_coding AND a.company_id=:company_id AND a.rec_deleted=''f''');
      add('LEFT OUTER JOIN classificators t ON');
      add('t.id=a.type_id');

      Add('WHERE bbool=''t''');
      Add(' AND NOT EXISTS(');
      Add(' SELECT p.*');
      Add(format(' FROM %s p', [pBfrTableName]));
      Add(' WHERE p.account_coding ' + sqlp._like() + ':account_coding'); // ILIKE !!
      Add('   AND p.attr ' + sqlp._like() + ':attr)');
      Add('ORDER BY a.account_coding');
      // --------
      pMainSQL := Text; // jätame meelde !
    end;


    for i := 0 to self.FFormdLines.Count - 1 do
      if assigned(FFormdLines.Objects[i]) then
      begin

        pFrmParser := TFormulaPreParser(FFormdLines.Objects[i]);


        // viskame välja eelmise päringuga loodud allkontod; 11%@SA ---

        for j := pFrmParser.accounts.Count - 1 downto 0 do
          if TTaxdParsedAccounts(pFrmParser.accounts.Items[j]).FOrigOrder = -1 then
            pFrmParser.accounts.Delete(j);



        for j := 0 to pFrmParser.accounts.Count - 1 do
        begin
          pFrmAcc := pFrmParser.accounts.Items[j] as TTaxdParsedAccounts;
          pAccCode := trim(pFrmAcc.FAccountCode);
          if pAccCode = '' then
            continue;

          // --
          pExpAcc := pAccCode[length(pAccCode)] = '%';
          if pExpAcc then // peame allkontod ka lahti lööma; ntx 11 algusega kontod ! 11% kaasa arvatud
          begin

            // esmalt 11 konto ise
            self.FWorkerQry.ParamByName('account_coding').AsString := copy(pAccCode, 1, length(pAccCode) - 1);
            self.FWorkerQry.ParamByName('attr').AsString := pFrmAcc.FAccountAttr;
            self.FWorkerQry.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
            self.FWorkerQry.ExecSQL; // --




            // vahetame SQL süntaksi ära
            self.FWorkerQry.Close;
            self.FWorkerQry.SQL.Clear;
            self.FWorkerQry.SQL.Text := pChildSQL;

            // ja nö alamad
            self.FWorkerQry.ParamByName('account_coding').AsString := pAccCode;
            self.FWorkerQry.ParamByName('attr').AsString := pFrmAcc.FAccountAttr;
            self.FWorkerQry.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
            self.FWorkerQry.ExecSQL; // --


            // pole midagi teha, aga peame kohe tulemused välja lugema ! just koodid !
            FWorkerQry.Close;
            FWorkerQry.SQL.Clear;
            FWorkerQry.SQL.Add(format('SELECT account_coding FROM %s WHERE  account_coding ' + sqlp._like() +
              ' :account_coding', [pBfrTableName]));
            FWorkerQry.ParamByName('account_coding').AsString := pAccCode;
            FWorkerQry.Open;


            FWorkerQry.First;

            while not FWorkerQry.EOF do
            begin

              if FWorkerQry.FieldByName('account_coding').AsString <> copy(pAccCode, 1, length(pAccCode) - 1) then // 11 vanemat uuesti ei lisa !
              begin
                // 07.08.2012 Ingmar; jätame ikka indeksid ka alles !
                pTemp := format('%d#%d#', [pFrmAcc.FIndxStart, pFrmAcc.FIndxEnds]) + pFrmAcc.FAccountAttr +
                  '#' + FWorkerQry.FieldByName('account_coding').AsString; // sama atribuut, mis vanemal
                // 07.08.2012 Ingmar; ei tohi topelt panna sama kontot ! kasumiaruandes tekkis selline olukord [3501@KK]-[35%@DK]-[5501@DK]-[5502@KK]
                if pChildAcc.IndexOf(pTemp) = -1 then
                  pChildAcc.AddObject(pTemp, pFrmParser); // pFrmParser = töödeldav bilansirida
              end;


              // --
              FWorkerQry.Next;
            end;


            // ---
            FWorkerQry.Close;
            FWorkerQry.SQL.Clear;


            // taastame SQLi, mis ei otsi allkontosid !
            FWorkerQry.SQL.Text := pMainSQL;
          end
          else
          begin
            self.FWorkerQry.ParamByName('account_coding').AsString := pAccCode;
            self.FWorkerQry.ParamByName('attr').AsString := pFrmAcc.FAccountAttr;
            self.FWorkerQry.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
            self.FWorkerQry.ExecSQL; // --
          end;
        end;
      end; // --




    // ALLKONTOD !
    // nüüd kanname ka allkontod valemisse, kui asendatavat positsiooni ei märgi;
    // 10



    for i := 0 to pChildAcc.Count - 1 do
    begin
      pFrmParser := pChildAcc.Objects[i] as TFormulaPreParser;
      pAccColl := pFrmParser.accounts;

      pNewAccObj := pAccColl.Add as TTaxdParsedAccounts;
      pNewAccObj.FAccountId := 0;


      // 1#1#SA#1101
      pTemp := pChildAcc.Strings[i];


      j := pos('#', pTemp);
      pNewAccObj.FIndxStart := strtointdef(copy(pTemp, 1, j - 1), 0);
      system.Delete(pTemp, 1, j);

      j := pos('#', pTemp);
      pNewAccObj.FIndxEnds := strtointdef(copy(pTemp, 1, j - 1), 0);
      system.Delete(pTemp, 1, j);

      //pNewAccObj.FIndxEnds:=-1;

      j := pos('#', pTemp);
      pNewAccObj.FAccountAttr := copy(pTemp, 1, j - 1);
      system.Delete(pTemp, 1, j);

      pNewAccObj.FAccountCode := pTemp;
      //pNewAccObj.FIndxStart:=-1;
      //pNewAccObj.FIndxEnds:=-1;
      pNewAccObj.FOrigOrder := -1;
    end;

  finally
    FreeAndNil(pChildAcc);
  end;
end;

// arvutame käibed ja saldod
procedure TDeclcalc.calcAccAttrValues(const pBalanceChangeMode: boolean; // bilansil vajalik, kas peame ka saldomuutust arvestama !
  const pBfrTableName: Astr);
var
  p1: AStr;
  p2: AStr;
begin
  with self.FWorkerQry, SQL do
    try
      // 28.04.2011 Ingmar; algsaldo päring veelkord eraldi on küll kuidagi imelik, sest kanded võtavad ta ju sisse !

      // ALGSALDO KANNE !!!!!!!!!!
      // ALGSALDO < ?
      p1 := '';
      p2 := '';
      Close;
      Clear;
      add(format('UPDATE %s', [pBfrTableName]));
      add('SET init_balance=COALESCE((');

      // -----------------------
      // 1.jaanuar = 0
      // 3.veebruar = 40 000

      if self.FDeclPerStart <> CZStartDate1980 then
      begin
        p1 := p1 + ' AND accounting_register.transdate<=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerStart)); // <? või  <= ?
        // 27.11.2011 Ingmar
        p1 := p1 + ' AND accounting_register.template=''f''';
      end;

      //p2:=' AND accounts.id=a.id'; // accounts

      p2 := format(' AND accounts.id=%s.account_id', [pBfrTableName]);
      add(estbk_sqlclientcollection._SQLSelectAccountInitBalance(estbk_globvars.glob_company_id, p1, p2));

      add('),0.00)');
      add(format('WHERE attr=%s', [QuotedStr(CFCreator_SA_FlagAsStr)]));  // soovitakse KONTO SALDOT !
      execSQL;


      // 10.03.2011 Ingmar; aga ALLkontode summad tuleb ka peakontodele arvutada !?
      // Piret Rumbergi meil; 10.03.2012
      // Hetkel jätsin AS IS !



   (*
       p1:='';
       p2:='';
       close;
       clear;
       add(format('UPDATE %s',[pBfrTableName]));
       add('SET init_balance2=COALESCE((');


   if  self.FDeclPerStart<>CZStartDate1980 then
       p1:=p1+' AND accounting_register.transdate>='+ QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerStart)); // <? või  <= ?

   if  self.FDeclPerEnd<>CZEndDate2050 then
       p1:=p1+' AND accounting_register.transdate<='+ QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerEnd));

       //p2:=' AND accounts.id=a.id'; // accounts
       p2:=format(' AND accounts.id=%s.account_id',[pBfrTableName]);
       add(estbk_sqlclientcollection._SQLSelectAccountInitBalance(estbk_globvars.glob_company_id,p1,p2));

       add('),0.00)');
       add(format('WHERE attr=%s',[QuotedStr(CFCreator_SA_FlagAsStr)]));  // soovitakse KONTO SALDOT !
       execSQL;
   *)
      //pAccrMarkers:=QuotedStr(estbk_types.CAccRecIdentAsInitBalance);
      // -----------------------
      // DEEBETKÄIVE
      Close;
      Clear;
      add(format('UPDATE %s', [pBfrTableName]));
      add('SET dsum=');
      add('(');
      add(' SELECT coalesce(SUM(z0.rec_sum),0)');
      add(' FROM  accounting_records z0');
      add(' INNER JOIN accounting_register w0 ON');
      add(' w0.id=z0.accounting_register_id');
      // 27.11.2011 Ingmar
      add(' AND w0.template=''f''');

      // 01.06.2011 Ingmar
      // add(' AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));
      add(' AND NOT w0.type_ LIKE ' + QuotedStr('%' + estbk_types.CAccRecIdentAsInitBalance + '%'));
      if self.skipFinSummaryRec then
        add(' AND NOT w0.type_ LIKE ' + QuotedStr('%' + estbk_types.CAddRecIdendAsClosingRec + '%'));


      add(format('   AND w0.company_id=%d', [estbk_globvars.glob_company_id]));



      if not pBalanceChangeMode then // tavaline käive
      begin
        if self.FDeclPerStart <> CZStartDate1980 then
          add('   AND w0.transdate>=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerStart)));

        if self.FDeclPerEnd <> CZEndDate2050 then
          add('   AND w0.transdate<=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerEnd)));
      end
      else
        // ntx bilansis kuvame saldo muutused ! saldo kuupäevani X
      begin
        // algsaldo siis kuupäevani N-1 <=2011-02-28
        if self.FDeclPerEnd <> CZEndDate2050 then
          add('   AND w0.transdate<=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerStart - 1)));
      end;

      // ---
      add(format(' WHERE z0.account_id=%s.account_id', [pBfrTableName]));
      add('   AND z0.rec_type=''D''');
      add(' ) ');

      // saldo muutuste reziimis ignoreerime konto lippe !
      if not pBalanceChangeMode then
        add(format('WHERE attr=%s OR attr=%s', [QuotedStr(CFCreator_DC_FlagAsStr), QuotedStr(CFCreator_SA_FlagAsStr)]));
      execSQL;


      // -----------------------
      // KREEDITKÄIVE
      Close;
      Clear;
      add(format('UPDATE %s', [pBfrTableName]));
      add('SET csum=');
      add('(');
      add(' SELECT coalesce(SUM(z0.rec_sum),0)');
      add(' FROM  accounting_records z0');
      add(' INNER JOIN accounting_register w0 ON');
      add(' w0.id=z0.accounting_register_id');

      // 27.11.2011 Ingmar
      add(' AND w0.template=''f''');

      // 01.06.2011 Ingmar
      //add(' AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));
      add(' AND NOT w0.type_ LIKE ' + QuotedStr('%' + estbk_types.CAccRecIdentAsInitBalance + '%'));
      if self.skipFinSummaryRec then
        add(' AND NOT w0.type_ LIKE ' + QuotedStr('%' + estbk_types.CAddRecIdendAsClosingRec + '%'));

      add(format('   AND w0.company_id=%d', [estbk_globvars.glob_company_id]));


      if not pBalanceChangeMode then // tavaline käive
      begin
        if self.FDeclPerStart <> CZStartDate1980 then
          add('   AND w0.transdate>=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerStart)));

        if self.FDeclPerEnd <> CZEndDate2050 then
          add('   AND w0.transdate<=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerEnd)));
      end
      else
        // ntx bilansis kuvame saldo muutused ! saldo kuupäevani X
      begin
        // algsaldo siis kuupäevani N-1 <=2011-02-28
        if self.FDeclPerEnd <> CZEndDate2050 then
          add('   AND w0.transdate<=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerStart - 1)));
      end;



      // ----
      add(format(' WHERE z0.account_id=%s.account_id', [pBfrTableName]));
      add('   AND z0.rec_type=''C''');
      add(' ) ');

      if not pBalanceChangeMode then
        add(format('WHERE attr=%s OR attr=%s', [QuotedStr(CFCreator_CC_FlagAsStr), QuotedStr(CFCreator_SA_FlagAsStr)]));
      execSQL;

      //  HETKESALDO !
      //  DS1=DS0+DK-KK / KS1= KS0+KK-DK

      // -----------------------
      // DEEBETKÄIVE2/KREEDITKÄIVE2 või saldo seisuga X / muutus vahemik
      // -----------------------

      if pBalanceChangeMode then
      begin
        // D !
        Close;
        Clear;
        add(format('UPDATE %s', [pBfrTableName]));
        add('SET dsum2=');
        add('(');
        add(' SELECT coalesce(SUM(z0.rec_sum),0)');
        add(' FROM  accounting_records z0');
        add(' INNER JOIN accounting_register w0 ON');
        add(' w0.id=z0.accounting_register_id');
        // 27.11.2011 Ingmar
        add(' AND w0.template=''f''');

        // 01.06.2011 Ingmar
        //add(' AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));
        add(' AND NOT w0.type_ LIKE ' + QuotedStr('%' + estbk_types.CAccRecIdentAsInitBalance + '%'));
        if self.skipFinSummaryRec then
          add(' AND NOT w0.type_ LIKE ' + QuotedStr('%' + estbk_types.CAddRecIdendAsClosingRec + '%'));

        add(format('   AND w0.company_id=%d', [estbk_globvars.glob_company_id]));
        if self.FDeclPerStart <> CZStartDate1980 then
          add('   AND w0.transdate>=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerStart)));

        if self.FDeclPerEnd <> CZEndDate2050 then
          add('   AND w0.transdate<=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerEnd)));

        add('   AND z0.rec_type=''D'''); // DEEBET
        add(format(' AND z0.account_id=%s.account_id', [pBfrTableName]));
        add(')');
        execSQL;


        // C !
        Close;
        Clear;
        add(format('UPDATE %s', [pBfrTableName]));
        add('SET csum2=');
        add('(');
        add(' SELECT coalesce(SUM(z0.rec_sum),0)');
        add(' FROM  accounting_records z0');
        add(' INNER JOIN accounting_register w0 ON');
        add(' w0.id=z0.accounting_register_id');
        // 27.11.2011 Ingmar
        add(' AND w0.template=''f''');

        // 01.06.2011 Ingmar
        //add(' AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));
        add(' AND NOT w0.type_ LIKE ' + QuotedStr('%' + estbk_types.CAccRecIdentAsInitBalance + '%'));
        if self.skipFinSummaryRec then
          add(' AND NOT w0.type_ LIKE ' + QuotedStr('%' + estbk_types.CAddRecIdendAsClosingRec + '%'));

        add(format('   AND w0.company_id=%d', [estbk_globvars.glob_company_id]));
        if self.FDeclPerStart <> CZStartDate1980 then
          add('   AND w0.transdate>=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerStart)));

        if self.FDeclPerEnd <> CZEndDate2050 then
          add('   AND w0.transdate<=' + QuotedStr(estbk_utilities.datetoOdbcStr(self.FDeclPerEnd)));

        add('   AND z0.rec_type=''C'' '); // KREEDIT
        add(format(' AND z0.account_id=%s.account_id', [pBfrTableName]));
        add(')');
        execSQL;
      end;


    finally
      Close;
      Clear;
    end;
end;




function TDeclcalc.doCalc(const pBalanceChangeMode: boolean; var pErrorCode: AStr; const pSortAccounts: boolean = False;


  const pSkipZAccounts: boolean = False): boolean; // pBalanceChangeMode bilansi reziim !

  // SUB !
  function __addChildAccSum(const accounts: TCollection; const currentAcc: TTaxdParsedAccounts; const pCalcFormula2: boolean = False): double;
  var
    i: integer;
    pAcc: AStr;
    pChildAcc: TTaxdParsedAccounts;
    pUsed: TAStrList; // ntx tehakse valemis [1%@SA] + [1%@SA]; siis jätame meelde all konto, mida oleme juba korra kasutanud
    pIsOkChildAcc: boolean;
    // pIsPassiva    : Boolean;
    pSum1: double;
    pSum2: double;
  begin
    Result := 0.00;
    pAcc := currentAcc.FAccountCode;
    if (pAcc <> '') and (pAcc[length(pAcc)] = '%') then
      try
        pAcc := copy(pAcc, 1, length(pAcc) - 1);
        pUsed := TAStrList.Create;
        for i := 0 to accounts.Count - 1 do
        begin
          pChildAcc := accounts.Items[i] as TTaxdParsedAccounts;
          if pChildAcc.FOrigOrder >= 0 then // allkontodel on tunnuseks -1 !!!
            continue;


          pIsOkChildAcc := (pos(pAcc, pChildAcc.FAccountCode) = 1) and // 27.05.2011 Ingmar; bugi oli suurem >0 märk, aga pidi olema = 1 !!!!!!
            (AnsiUpperCase(pChildAcc.FAccountAttr) = AnsiUpperCase(currentAcc.FAccountAttr)) and
            (pUsed.indexOf(pChildAcc.FAccountCode) = -1);

          if pIsOkChildAcc then
          begin

            //pIsPassiva:=(pChildAcc.FAccType=estbk_types.CAccTypeAsPassiva) or
            //            (pChildAcc.FAccType=estbk_types.CAccTypeAsProfit);


            pSum1 := pChildAcc.FAccFormulaSum;
            pSum2 := pChildAcc.FBalanceChange;
            //if pIsPassiva then
            //  begin
            //   pSum1:=-pSum1;
            //   pSum2:=-pSum2;
            //  end;
            // showmessage(pChildAcc.FAccountCode+' '+floattostr(pSum1)+' '+floattostr(pSum2));


            case pCalcFormula2 of
              False: Result := Result + pSum1;
              True: Result := Result + pSum2;
            end;

            // ---
            pUsed.Add(pChildAcc.FAccountCode);
          end;
          // ---
        end;
      finally
        FreeAndNil(pUsed);
      end;
  end;

  function __intputValuesIntoFormula(const pFormula: AStr; const accounts: TCollection; const pCalcFormula2: boolean = False): AStr;
  var
    j: integer;
    pAcc: TTaxdParsedAccounts;
    pSum1: double;
    pSum2: double;
    // pIsPassiva : Boolean;
  begin
    Result := pFormula;

    // TFormulaPreParser(FFormdLines.Objects[i]).formula;
    // -- nüüd peame võtma kontode summad ja asendama valemis ning kutsuma välja valemi !
    if trim(Result) <> '' then
      for  j := accounts.Count - 1 downto 0 do // downto 0
      begin

        // alates 04.05.2011 Ingmar; on süntaks [11%@SA] st kõik kontod mille algus on 11%, aga valemis tuleb asendada nende summaga !
        // alamkontod summeerid + 11 konto ise ka, kui ta olemas
        pAcc := TTaxdParsedAccounts(accounts.Items[j]);
        if pAcc.FOrigOrder < 0 then // allkonto; tuletatud konto, jätame vahele !
          continue;


        system.Delete(Result, pAcc.FIndxStart - 1, (pAcc.FIndxEnds - pAcc.FIndxStart) + 3);
        pSum1 := pAcc.FAccFormulaSum;
        pSum2 := pAcc.FBalanceChange;

        //if  pIsPassiva then
        //begin
        // pSum1:=-pSum1;
        // pSum2:=-pSum2;
        // end;


        // valemisse tuleb summeerida; peakonto + allkontod !
        case pCalcFormula2 of
          False:
          begin
            pSum1 := _normZero(pSum1 + __addChildAccSum(accounts, pAcc, False));
            system.Insert(floattostr(pSum1), Result, pAcc.FIndxStart - 1); // ntx saldo kuni ... 01.01.2011
          end;
          True:
          begin
            pSum2 := _normZero(pSum2 + __addChildAccSum(accounts, pAcc, True));
            system.Insert(floattostr(pSum2), Result, pAcc.FIndxStart - 1); // saldo muutus 01.01.2011>= <=31.03.2011
          end;
        end;




        // ---
      end
    else
      Result := '0';

  end;

  // 27.04.2011 Ingmar; aruande jaoks peaksime kontod ära sorteerima detailne bilanss
  // kõik ju tore...aga kontod hoiavad ka koordinaate, kuidas elemente asendada valemis vastavalt järjekorrale !
  // SUB 2 !
  procedure __intDoSortAccounts(const pAccounts: TCollection; const pSortByAccCode: boolean = False);
  var
    cmp1, cmp2: TTaxdParsedAccounts;
    //temp : TCollectionItem;
    rIndex, rounds, cIndex: integer;
    done: boolean;
    i, j: integer;
  begin

    done := False;
    rounds := 0;
    if pAccounts.Count > 0 then
      while not (done) do
      begin

        done := True;
        for rIndex := 0 to ((pAccounts.Count - 2) - rounds) do
        begin
          cmp1 := pAccounts.items[rIndex] as TTaxdParsedAccounts;
          cmp2 := pAccounts.items[rIndex + 1] as TTaxdParsedAccounts;

          if pSortByAccCode then
          begin
            if (TTaxdParsedAccounts(cmp1).FAccountCode > TTaxdParsedAccounts(cmp2).FAccountCode) then
            begin
              Done := False;
              cIndex := cmp1.Index;
              cmp1.Index := cmp2.Index;
              cmp2.Index := cIndex;
            end;
          end
          else
          if (TTaxdParsedAccounts(cmp1).FOrigOrder > TTaxdParsedAccounts(cmp2).FOrigOrder) then
          begin
            Done := False;
            cIndex := cmp1.Index;
            cmp1.Index := cmp2.Index;
            cmp2.Index := cIndex;
          end;
          // ---
        end;

        Inc(Rounds);
      end;
  end;

var
  i, j: integer;
  pAcc: TTaxdParsedAccounts;
  pDSum, pCSum, pRez, pBChange: double;
  pHasdata: boolean;
  pIsActiva: boolean;
  pFormulaStr: AStr;   // asendame andmed !
  pTemp: AStr;
  pRLinesCnt: integer; // referenced line
  pOrigRLineCnt: integer;
  pFormula: AStr;
  pBfrTable: AStr;
  pStartDate: TDatetime;
  s: astr;
   {$ifdef debugmode}
  pFormulaReztoFile: Textfile;
   {$endif}
begin
  Result := False;
  pHasdata := False;


  try

    // ---- ajutiste tabelite pärast
    dmodule.primConnection.StartTransaction;




    // assert(pFormulaParser.parseFormula(pFormula),'#1');
    // passiva konto id'd vaja
    // esmalt nullida andmed; samuti taastada

    for i := 0 to self.FFormdLines.Count - 1 do
      if assigned(FFormdLines.Objects[i]) then
        with TFormulaPreParser(FFormdLines.Objects[i]) do
        begin
          formulaRez := 0;
          formulaAltRez := 0;
          formulaComputed := False;

          // 28.05.2011 Ingmar;  bugi R väärtused on ka ära kustutatud, need tuleb uuesti luua !!!!
          parseFormula(formula);

          // taastame samuti algse olukorra ! et kontod oleks täpselt samas järjekorras nagu nad valemist parsiti !
          // muidu indeksitega asendus on metsas !
          __intDoSortAccounts(accounts);
        end;



    // ----
    self.createPreBufferingTable(pBfrTable);
    self.fillBufferingTableWithAcc(pBfrTable);
    self.calcAccAttrValues(pBalanceChangeMode, pBfrTable);


    // --- küsime siis tulemused
    FWorkerQry.Close;
    FWorkerQry.SQL.Clear;
    FWorkerQry.SQL.Add(format('SELECT * FROM %s', [pBfrTable]));
    FWorkerQry.Open;




    pRLinesCnt := 0; // !!!!!!!!!!! ref lines
    // --- eelarvutus ! SQL jne
    for i := 0 to self.FFormdLines.Count - 1 do
      if assigned(FFormdLines.Objects[i]) and (trim(TFormulaPreParser(FFormdLines.Objects[i]).formula) <> '') then
        with TFormulaPreParser(FFormdLines.Objects[i]) do
        begin

          for j := 0 to accounts.Count - 1 do
          begin   // ---
            pBChange := 0.00;
            pRez := 0.00;

            pAcc := TTaxdParsedAccounts(accounts.Items[j]);
            pAcc.FAccFormulaSum := 0;
            pAcc.FBalanceChange := 0; // bilanss -> saldo muutus

            pAcc.FAccountId := FWorkerQry.FieldByName('account_id').AsInteger;

            // --  kontole nimi ja ID ka külge !
            // @@@ 10.03.2012 Ingmar; Piret Rumberg ütles
                {
                Samuti muutsin ära algsaldode kuupäeva. Mul oli tõesti algselt sisestatud 01.01.2012 seisuga, kuid nüüd sisestasin 31. 12.2011 seisuga, kuid ikka ei näita ta osakapitali nimiväärtuse summat (omakapitali alla ta selle siiski lõppkokkuvõttes arvutab).
                }
            // 10.03.2012 Ingmar; originaalkood !
            // @@@
            // if  not FWorkerQry.Locate('account_coding;attr',VarArrayOf([AStr(pAcc.FAccountCode),AStr(pAcc.FAccountAttr)]),[ loCaseInsensitive]) then
            if not FWorkerQry.Locate('account_coding;attr', VarArrayOf(
              [AStr(stringreplace(pAcc.FAccountCode, '%', '', [])), AStr(pAcc.FAccountAttr)]), [loCaseInsensitive]) then
              continue;


            pAcc.FAccountLongName := FWorkerQry.FieldByName('account_name').AsString;
            pAcc.FAccType := FWorkerQry.FieldByName('account_type').AsString; // aktiva / passiva !

            // 31.05.2011 Ingmar
            pIsActiva := (pAcc.FAccType = estbk_types.CAccTypeAsActiva) or (pAcc.FAccType = estbk_types.CAccTypeAsCost);

            // ------------------------------------------------------------
            // 31.05.2011 Ingmar; uus tüüp; muutus vahemikus ! see pole sama mis käive, käive on vaid ühe konto poole liikumine !
            if (pAcc.FAccountAttr = CFCreator_TR_FlagAsStr) then
            begin

              // -- bilansi puhul on käive teises muutujas
              if pBalanceChangeMode then
                pDSum := FWorkerQry.FieldByName('dsum2').AsCurrency
              else
                pDSum := FWorkerQry.FieldByName('dsum').AsCurrency;

              if pBalanceChangeMode then
                pCSum := FWorkerQry.FieldByName('csum2').AsCurrency
              else
                pCSum := FWorkerQry.FieldByName('csum').AsCurrency;
              pRez := 0; // muutuse puhul pole "algsaldot" !


              if pIsActiva then
                pBChange := (pDSum - pCSum)
              else
                pBChange := (pCSum - pDSum);

            end
            else

            // ------------------------------------------------------------
            // 18.04.2011 Ingmar; lohakusviga; KK lipp oli ära jäänud !  2xCFCreator_CC_FlagAsStr oli !
            // 27.05.2011 Ingmar; käibe on ju mingi vahemikus !!! dsum -> dsum2
            if (pAcc.FAccountAttr = CFCreator_DC_FlagAsStr) then
            begin

              // -- bilansi puhul on käive teises muutujas
              if pBalanceChangeMode then
                pRez := FWorkerQry.FieldByName('dsum2').AsCurrency // DEEBETKÄIVE
              else
                pRez := FWorkerQry.FieldByName('dsum').AsCurrency;

            end
            else
            if (pAcc.FAccountAttr = CFCreator_CC_FlagAsStr) then
            begin

              if pBalanceChangeMode then
                pRez := FWorkerQry.FieldByName('csum2').AsCurrency // KREEDITKÄIVE
              else
                pRez := FWorkerQry.FieldByName('csum').AsCurrency;
            end
            else

            // ------------------------------------------------------------
               (*
               // Passiva puhul vastupidi DS1=DS0+KK-DK
               // Kreeditsaldo KS1= KS0+KK-DK
               // aga muidu on nii, et passiva kontodel on Kreeditkäibed-Deebetkäibed
               // ja aktiva kontodel on Deebetkäibed-kreeditkäibed
               *)
            //if (pAcc.FAccountAttr=CFCreator_DS_FlagAsStr) or (pAcc.FAccountAttr=CFCreator_CS_FlagAsStr) then
            if (pAcc.FAccountAttr = CFCreator_SA_FlagAsStr) then // 23.04.2011 Ingmar; vaid saldo !
            begin

              // algsaldo
              // ------------- | 01.03.2011 -- 31.03.2011
              // ehk ntx bilansil on kahte tüüpi saldo kuni declStart<=
              // nüüd vaja bilansile veel osa >declStart  declEnd<=

              // kui küsitakse lihtsalt saldot ja pole tegemist nö bilansi stiilis olukorraga
              // kus saldo seisuga kp. 01.03.2011 ja lõppsaldo 31.03.2011, teisel juhul pole declStart muutujal mingit pointi !
              // muidu on lihtsalt kuu käive, mis ei anna mitte midagi
                    {
                    (
                       SELECT coalesce(SUM(z0.rec_sum),0)
                       FROM  accounting_records z0
                       INNER JOIN accounting_register w0 ON
                       w0.id=z0.accounting_register_id AND w0.type_<>'A'
                         AND w0.company_id=2
                         AND w0.transdate>='2011-03-01'
                         AND w0.transdate<='2011-03-31'
                       WHERE z0.account_id=a.id
                         AND z0.rec_type='D'
                       ) AS dt
                    }

              // -------------------------------------------------------
              // Saldo kuni !

              pDSum := FWorkerQry.FieldByName('dsum').AsCurrency;
              pCSum := FWorkerQry.FieldByName('csum').AsCurrency;

              // TODO puhverdus, ntx meil konto 1100 DS või KS siis meil juba korra algsaldo arvutatud, miks me uuesti küsima
              pRez := FWorkerQry.FieldByName('init_balance').AsCurrency;
                         {
                          CAccTypeAsActiva  = 'A';    // Aktiva
                          CAccTypeAsPassiva = 'P';    // Passiva
                          CAccTypeAsCost    = 'CO';   // Kulud
                          CAccTypeAsProfit  = 'IN';   // Tulud
                          }
              if pIsActiva then // algsaldo !
              begin
                pRez := pRez + (pDSum - pCSum);
              end
              else
              begin
                pRez := pRez + (pCSum - pDSum);
              end;


              // ---
              pDSum := FWorkerQry.FieldByName('dsum2').AsCurrency;
              pCSum := FWorkerQry.FieldByName('csum2').AsCurrency;



              if pIsActiva then // muutus !
              begin
                pBChange := (pDSum - pCSum);
              end
              else
              begin
                pBChange := (pCSum - pDSum);
                // pBChange:=-pBChange;
              end;
            end;

            pHasdata := True;

            // parema debugimise pärast !
            if iszero(pRez) and iszero(pBChange) then
              continue;


            // -------------------------------------------------------
            // naljakas freepascal; -0.00 on toetatud :)


            pAcc.FAccFormulaSum := _normZero(pRez);     // ntx hetkesaldo / saldo kuni
            pAcc.FBalanceChange := _normZero(pBChange);
            // -------------------------------------------------------
          end;




          // 19.04.2011 Ingmar
          // asendame valemis siis kontode käibed ja saldod ! pTemp selleks, et debugimine lihtsam !
          pTemp := TFormulaPreParser(FFormdLines.Objects[i]).formula;
          pTemp := __intputValuesIntoFormula(pTemp, accounts, False);


          TFormulaPreParser(FFormdLines.Objects[i]).formula := pTemp;



          // alt. valem, seda kasutatakse bilansi puhul ntx, et teada saada saldo muutus vahemikus N
          pTemp := TFormulaPreParser(FFormdLines.Objects[i]).formulaAlt;
          pTemp := __intputValuesIntoFormula(pTemp, accounts, True);

          TFormulaPreParser(FFormdLines.Objects[i]).formulaAlt := pTemp;



          // -- mitu lingitud rida kokku
          pRLinesCnt := pRLinesCnt + TFormulaPreParser(FFormdLines.Objects[i]).RLines.Count;
        end;




    // bilansi puhul tuleb 2x arvutada, esimene valem formula on algsaldo kuni
    // teine valem on saldo muutus vahemikus X
    // kui 0, siis asendame nr 1, et ikka arvutaks kõik read läbi !
    if pRLinesCnt < 1 then
      pRLinesCnt := 1;


    // ---
    pOrigRLineCnt := pRLinesCnt;


    // arvutame nüüd kõik read läbi, ka teineteisele viitamised ! $1+$2
    self.calcFormulaLineValues(pRLinesCnt);



    // saldo muutused
    if pBalanceChangeMode then
    begin
      pRLinesCnt := pOrigRLineCnt;
      for i := 0 to self.FFormdLines.Count - 1 do
        TFormulaPreParser(FFormdLines.Objects[i]).formulaComputed := False; // et saaksime korra veel arvutada !

      // --
      self.calcFormulaLineValues(pRLinesCnt, True);
    end;



    for i := 0 to self.FFormdLines.Count - 1 do
    begin
      // 01.08.2012 Ingmar; nüüd allkontod ka olemas
      TFormulaPreParser(FFormdLines.Objects[i]).buildDistinctAccountsColl;
      TFormulaPreParser(FFormdLines.Objects[i]).calcOnlyAccSumPerFormula();
      // bilansi jaoks ka muutused 08.08.2012 Ingmar
      TFormulaPreParser(FFormdLines.Objects[i]).calcOnlyAccSumPerFormula(False);


      // 22.04.2011 Ingmar
      if pSortAccounts then
        __intDoSortAccounts(TFormulaPreParser(FFormdLines.Objects[i]).accounts, True);
    end;



    // dumpREZ !
      {$ifdef debugmode}

    assignfile(pFormulaReztoFile, 'c:\debug\baloutput.txt');
    rewrite(pFormulaReztoFile);

    for i := 0 to self.FFormdLines.Count - 1 do
    begin
      writeln(pFormulaReztoFile, '--------------------------------------------------------');
      writeln(pFormulaReztoFile, TFormulaPreParser(FFormdLines.Objects[i]).lastParsedFormula);

      writeln(pFormulaReztoFile, 'frm 1:', TFormulaPreParser(FFormdLines.Objects[i]).formula);
      writeln(pFormulaReztoFile, 'frm 2:', TFormulaPreParser(FFormdLines.Objects[i]).formulaAlt);
      // ---
      for j := 0 to TFormulaPreParser(FFormdLines.Objects[i]).accounts.Count - 1 do
        with  TTaxdParsedAccounts(TFormulaPreParser(FFormdLines.Objects[i]).accounts.Items[j]) do
          if not iszero(FAccFormulaSum) or not iszero(FBalanceChange) then
            writeln(pFormulaReztoFile, FAccountCode, ' ', FAccountAttr, ' frm val 1 = ', floattostr(FAccFormulaSum),
              ' frm val 2 = ', floattostr(FBalanceChange));
      // ---
    end;


    closefile(pFormulaReztoFile);

      {$endif}




    // DEBUG
   (*
   for i:=0 to self.FFormdLines.Count-1 do // sisuliselt ongi need read R1,R2,R3,R4... +1
       showmessage(format('rida: %d v_asendus: %s tulemus: %s',[i+1,TFormulaPreParser(FFormdLines.Objects[i]).formula,floattostr(TFormulaPreParser(FFormdLines.Objects[i]).formulaRez)]));
   *)



    Result := pHasdata;
    dmodule.primConnection.Commit;


  except
    on e: Exception do
    begin
      pErrorCode := e.Message;

      if dmodule.primConnection.InTransaction then
        try
          dmodule.primConnection.Rollback;
        except
        end;
    end;

    // --
  end;
end;


constructor TDeclcalc.Create;
var
  pInitDate: TDatetime;
begin
  inherited Create;
  FRevPolish := TRevPolish.Create;
  FWorkerQry := TZQuery.Create(nil);
  FSafeBreakSign := TMultiReadExclusiveWriteSynchronizer.Create;

  FFormdLines := TAStrList.Create;
  FWorkerQry.Connection := estbk_clientdatamodule.dmodule.primConnection;


  pInitDate := now;
  self.FDeclPerStart := dateutils.StartOfTheMonth(pInitDate);
  self.FDeclPerEnd := dateutils.EndOfTheMonth(pInitDate);
end;

destructor TDeclcalc.Destroy;
begin
  self.Clear;
  FreeAndNil(FSafeBreakSign);
  FreeAndNil(FFormdLines);
  FreeAndNil(FWorkerQry);
  FreeAndNil(FRevPolish);
  inherited Destroy;
end;

end.