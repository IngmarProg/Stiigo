unit estbk_lib_paymentmanager;

{$i estbk_defs.inc}
{$mode objfpc}
{$H+}
interface

// ----------------------------------------------------------------------------
// MAKSEKORRALDUSE / LAEKUMISTE kannete genereerimise klass !!! #6 viimane assert
// ----------------------------------------------------------------------------

uses
  Classes, SysUtils, Contnrs, ZDataset, ZConnection, ZSequence, LCLProc, estbk_utilities,
  estbk_lib_commoncls, estbk_types, estbk_strmsg, estbk_sqlclientcollection, estbk_globvars;

type
  TPaymentMode = (__pmtModeAsUnknown,
    __pmtModeAsPayment,   //  tasumine / tasumine kassasse
    __pmtModeAsIncome      // laekumised / arve tasumine kassast
    );

type
  TPaymentItemIs = (__pmtItemAsUnknown, // ntx lihtsalt ette/enammaksu rida
    __pmtItemAsBill,
    __pmtItemAsOrder);


type
  TPaymentRollBackDataRec = record
    pPrepaymentSum: currency;
    pPaidSum: currency;

    pLItemToPaySum: currency;
    pLItemIncomeSum: currency;
    pLItemPrepaidSum: currency;
    pLItemUPrepaidSum: currency;

    pItemId: integer;
    pItemType: AStr;
    pRecProcessed: boolean;
  end;

type
  TPaymentAccData = class(estbk_lib_commoncls.TAccoutingRec)
  protected
    // ülekirjeldamise lipud !
    FPrepayment: boolean;
    FDebt: boolean;
    FIncome: boolean;

    // viitab reale ntx maksekorraldus, et kreeditpoole osa pan
    FisFinalAggrLine: boolean;

    // -------------------------------------
    FitemId: integer;
    FitemType: TPaymentItemIs;
    // double kasutada viimase hetkeni, võimaldab täpsemaid arvutusi !
    FInternalConvSum: double;
    // --
    FitemCurrRate: double;
    FitemCurrID: integer;
    FitemCurrIdentf: AStr;

    // ---
    //FPretermPmtStatus : AStr; 31.03.2011 Ingmar; enam pole !
    FItemProcessed: boolean;
    // ---
    FFlags: integer;
    FdontUseInOverAllCalc: boolean;
    property regMRec;
  public
    property recType;
    property accountId;
    property clientId;
    property recNr;
    property descr;
    property sum;

    // konto valuuta
    property currencyIdentf;
    property currencyRate;
    property currencyID;

    property pmtItemCurrIdentf: AStr read FitemCurrIdentf write FitemCurrIdentf;
    property pmtItemCurrRate: double read FitemCurrRate write FitemCurrRate;
    property pmtItemCurrID: integer read FitemCurrID write FitemCurrID;


    // -- 31.08.2010 Ingmar; eelnevalt saadud makse staatus, et kas ntx arve on lõplikult tasutud või mitte
    // -- kannetes me ei tee enam täiendavaid päringuid !


    // LIPUD kandereale
    // märgib meile, et tegemist ettemaksu kandega, peame finantsivälised objektid sünkroniseerima
    property isPrepayment: boolean read FPrepayment write FPrepayment;
    property isDebt: boolean read FDebt write FDebt;
    property isIncome: boolean read FIncome write FIncome; // hetkel reserveeritud

    // 17.02.2011 Ingmar
    property itemId: integer read FitemId write FitemId;
    property itemType: TPaymentItemIs read FitemType write FitemType;
    // 01.09.2011 Ingmar
    property dontUseInOverAllCalc: boolean read FdontUseInOverAllCalc write FdontUseInOverAllCalc;
    // koondrida;
    property isFinalAggrLine: boolean read FisFinalAggrLine write FisFinalAggrLine;
    property flags: integer read FFlags write FFlags;
    // -- identifitseerimiseks, et finantsi ja tavaloogikat koos hoida
    constructor Create(const pItemId: integer; const pItemType: TPaymentItemIs); overload;//  reintroduce;
    constructor Create(); overload;
  end;

type
  // klass sooritab kanded ja haldab dubleeritud finantsiväliseid andmed ntx ettemaks jne
  TPaymentManager = class
  protected
    FWrkQuery: TZQuery;
    FWrkQuery2: TZQuery;
    FAccEntrys: TObjectList;
    FPaymentMode: TPaymentMode;
    FCurrValList: TAStrList;
    FAccMainRec: integer;     // baaskirje id !
     {$ifdef debugmode}
    FaccEntryWriteCount: integer;
     {$endif}
    FpaymentCurrency: Astr;  // makse valuuta !
    FpaymentCurrRate: double;
    FpaymentCurrId: integer;
    // kande rea number; vajalik salvestamisel
    FaccRecNr: integer;


    // -- kannete sisemine kontroll
    FDBalanceSum: double;
    FCBalanceSum: double;


    // --
    function cnvItemTypeToStr(const pIType: TPaymentItemIs): AStr;
    procedure doAccDbWrite(const pAccData: TPaymentAccData);
    procedure markItemPayments; // üldiselt märgib arvele laekumised ja ettemaksud / ka tellimus; käib nö kanded läbi

    // --

    procedure doItemsumRecalculation(const prData: TPaymentRollBackDataRec);
    procedure doPaymentRollback(const pMainRecId: integer);
    procedure checkIfRoundingAccRecNeeded(const pLastCalcBaseSum: double);
    // asi selles, et ntx pangaridu võib siin nimistus mitu olla, aga reaalselt tohib neid 1 olla; siis ei tohi me item id kasutada
    procedure combineEntrys(const pSkipItemIdCheckByAggrFlag: boolean = True);
    procedure calcCurrDiff(var pConvSumTotal: double; var pCurrConvWin: double; var pCurrConvCost: double; var pCurrDiffTotal: double);




  public
    property accMainRec: integer read FAccMainRec write FAccMainRec;

    // millises valuutas tasuti ! baasvaluuta valitud väärtuse saab pCurrValStList kaudu
    property paymentCurrency: AStr read FpaymentCurrency write FpaymentCurrency;
    property paymentCurrRate: double read FpaymentCurrRate write FpaymentCurrRate;
    property paymentCurrId: integer read FpaymentCurrId write FpaymentCurrId; // valuutaID, kui kasutatakse EP kursse
     {$ifdef debugmode}
    // pigem diagnostika muutuja, seoses ühe bugiga pidin loendama mitu korda kandeid kirjutatakse !
    property accEntryWriteCount: integer read FaccEntryWriteCount;
     {$endif}// --
    // konteeringud collectionisse !
    function addAccEntry(const itemId: integer; const itemType: TPaymentItemIs; const addToColl: boolean = True): TPaymentAccData;
    function cloneAccBasicEntry(const pClonedEntry: TPaymentAccData): TPaymentAccData;
    procedure convItemSumToBaseCurr(var pPmtEntry: TPaymentAccData);


    // sisuliselt kasutada debugimisel, kirjutam cachest kanded faili !
    procedure writeEntryLog(const pFilename: AStr);

    // kas ma saame ntx maksekorralduses makse tagasi võtta ! kui ostuarvest lõplik arve tehtud ei tohi lubada jne
    function verifyPrepaymentUsage(const pAccMainRecId: integer; var pErrorInf: AStr): boolean;


    // tühjendame sisemised puhvrid
    procedure clearData;

    procedure doSaveAccEntrys(const pCalcAlsoCurrDiff: boolean = True);
    // pCalcAlsoCurrDiff; kas sisemiselt arvutatakse ka kursivahed ! ntx maksekorraldus
    procedure doCancelAllEntrys(const pMainRecId: integer);     // ehk tühistab kande, samuti arvutatakse arve staatused ümber !

    constructor Create(const pPmtMode: TPaymentMode; const pCurrValStList: TAStrlist); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses estbk_clientdatamodule, estbk_lib_commonaccprop, Math;

// ----------------------------------------------------------------------------

constructor TPaymentAccData.Create(const pItemId: integer; const pItemType: TPaymentItemIs);
begin
  inherited Create;
  FitemId := pItemId;
  FitemType := pItemType;
end;

constructor TPaymentAccData.Create();
begin
  inherited Create;
  FitemId := 0;
  FitemType := __pmtItemAsUnknown;
end;

// ----------------------------------------------------------------------------

procedure TPaymentManager.clearData;
begin
  FaccRecNr := 0;
  // -- kannete sisemine kontroll
  FDBalanceSum := 0;
  FCBalanceSum := 0;
  FAccEntrys.Clear;

  {$ifdef debugmode}
  FaccEntryWriteCount := 0;
  {$endif}

end;


function TPaymentManager.cnvItemTypeToStr(const pIType: TPaymentItemIs): AStr;
begin
  Result := '';


  case pIType of
    __pmtItemAsUnknown: Result := estbk_types.CCommTypeAsMisc; // kutsume teda kui "misc" nagu miska...:) ntx riigilõivud jne
    __pmtItemAsBill: Result := estbk_types.CCommTypeAsBill;
    __pmtItemAsOrder: Result := estbk_types.CCommTypeAsOrder;
  end; // ---
end;

procedure TPaymentManager.doAccDbWrite(const pAccData: TPaymentAccData);
var
  pCurrExcRate: double;
  pCurr: AStr;
  pCurrencyId: integer;
  pCurrRate: double;
  pAccountingRec: int64;
  pAccLineSum: double;
  b: boolean;
begin
  assert((self.FAccMainRec > 0) and assigned(pAccData) and (pAccData.currencyIdentf <> ''), '#2');
  // ---
  Inc(self.FaccRecNr);

  with self.FWrkQuery, SQL do
    try
      Close;
      Clear;


      pCurrRate := 0; // --




      // --------
      add(estbk_sqlclientCollection._CSQLInsertNewAccDCRecEx);
      pAccountingRec := estbk_clientdatamodule.dmodule.qryGenLedgerAccRecId.GetNextValue;

      paramByname('id').asLargeInt := pAccountingRec;
      paramByname('accounting_register_id').AsInteger := self.FAccMainRec;
      paramByname('account_id').AsInteger := pAccData.accountId;


      paramByname('descr').AsString := copy(pAccData.descr, 1, 255);
      //     paramByname('rec_nr').asInteger:=pAccData.recNr;

      paramByname('rec_nr').AsInteger := self.FaccRecNr;
      paramByname('client_id').AsInteger := pAccData.clientId;
      paramByname('tr_partner_name').AsString := '';

      // ---




      // VALUUTA TUNNUS ! KONTO OMA !!!
      pCurr := pAccData.currencyIdentf;// estbk_globvars.glob_baseCurrency;



      // KONTOGA seotud valuuta; kui kontol baasvaluuta, siis lubame võtta tasutava elemendi valuuta
      // - kui konto valuuta pole baasvaluuta ja tasutava elemendi valuuta erineb, siis võetakse konto valuuta !
      if pCurr = estbk_globvars.glob_baseCurrency then
      begin
        pCurrencyId := pAccData.pmtItemCurrID;
        pCurr := pAccData.pmtItemCurrIdentf;
        pCurrRate := pAccData.pmtItemCurrRate;
      end
      else
        // KONTO pealt andmed ! ja summa konverteeritakse konto valuutasse !
      begin
        pCurrencyId := pAccData.currencyID;
        pCurr := pAccData.currencyIdentf;
        pCurrRate := pAccData.currencyRate;
      end;


      if pCurrRate = 0 then
        pCurrRate := 1;

      if pCurr = '' then
        pCurr := estbk_globvars.glob_baseCurrency;




      // ----
      paramByname('currency_drate_ovr').asCurrency := pCurrRate;
      if pCurrencyId > 0 then // -1 võib ka olla, siis öeldakse sellega sisemiselt võta jooksev kurss
        paramByname('currency_id').AsInteger := pCurrencyId
      else
        paramByname('currency_id').AsInteger := 0;
      paramByname('currency').AsString := pCurr;




    {
      * SIILILEGI SELGE !
      * KANDEREA PÕHISUMMA ALATI BAASVALUUTAS, ORIGINAALSUMMA ON currency_vsum väljal
    }


      pAccLineSum := pAccData.sum;
      paramByname('rec_sum').asCurrency := Math.roundto(pAccLineSum, Z2);
      paramByname('rec_type').AsString := pAccData.recType;


      // ja salvestame ka originaalvaluutas
      pAccLineSum := roundto(pAccLineSum / pCurrRate, Z2);
      paramByname('currency_vsum').asCurrency := pAccLineSum; // nö summa rida originaal valuutas !!!
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;




      // --------------------------
      // tasakaalude kontrollid !
      // --------------------------
      // 01.09.2011 Ingmar; kõik on tore, aga kui read, mida ei kasutata arvutustes, siis neid ei tohi arvestada; laekumiste pangakulude case

      if not pAccData.dontUseInOverAllCalc then
        if pAccData.recType = CAccRecTypeAsDebit then
        begin
          self.FDBalanceSum := self.FDBalanceSum + paramByname('rec_sum').asCurrency;
        end
        else
        if pAccData.recType = CAccRecTypeAsCredit then
        begin
          self.FCBalanceSum := self.FCBalanceSum + paramByname('rec_sum').asCurrency;
        end;

      // 17.02.2011 Ingmar; FIX
      // nii laekumiste / kui ka tasumiste korral agregaadi puhul ei saa me itemID lisada; sest tasutakse 1-* arvet !!!!



      if pAccData.isFinalAggrLine then
      begin
        pAccData.FitemType := __pmtItemAsUnknown;
        pAccData.FitemId := 0;
      end;



      // 28.08.2010 Ingmar
      // viitame ka elemendile, millega tegemist oli; arve/tellimus/...jne pakkumised ?
      // ...mjah peame jälle tagasi teisendama elemendi tüübi...
      paramByname('ref_item_type').AsString := self.cnvItemTypeToStr(pAccData.FitemType);

      if pAccData.FitemId > 0 then
        paramByname('ref_item_id').AsInteger := pAccData.FitemId
      else
        paramByname('ref_item_id').AsInteger := 0;
      // ---

      paramByname('ref_payment_flag').AsString := estbk_types.SCFalseTrue[False];    // tasumine / maksekorraldus
      paramByname('ref_prepayment_flag').AsString := estbk_types.SCFalseTrue[False]; // ettemaks / maksekorraldus/ laekumised
      paramByname('ref_debt_flag').AsString := estbk_types.SCFalseTrue[False];       // võlg / laekumised ?
      paramByname('ref_tax_flag').AsString := estbk_types.SCFalseTrue[False];        // maksud
      paramByname('ref_income_flag').AsString := estbk_types.SCFalseTrue[False];     // laekumine


      // --------------------------------------------------------------------------
      // TASUMINE
      // --------------------------------------------------------------------------

      if self.FPaymentMode = __pmtModeAsPayment then
      begin

        // ...ettemaksuga lihtne, siis maksekorralduse puhul paneme lipu püsti, et ettemaks !
        // .. ettemaks hankijale
        b := (pAccData.accountId = (_ac.sysAccountId[_accSupplPrePayment])) or  // Hankija ettemaksu konto
          pAccData.FPrepayment; // ülekirjeldatud
        paramByname('ref_prepayment_flag').AsString := estbk_types.SCFalseTrue[b];


        // ...aga võlgnevuse konto puhul on tegelikkuses see TÕLGENTATAV, kui tasumine tarnijale !
        // ehk tasumise lipp püsti
        b := (pAccData.accountId = (_ac.sysAccountId[_accSupplUnpaidBills])) or    // Hankijale tasumata arved
          pAccData.FDebt; // ülekirjeldatud

        paramByname('ref_payment_flag').AsString := estbk_types.SCFalseTrue[b];
        // tasumisel võlalippu mitte torkida !
        paramByname('ref_debt_flag').AsString := estbk_types.SCFalseTrue[False];
      end
      else


      // --------------------------------------------------------------------------
      // LAEKUMISED
      // --------------------------------------------------------------------------

      if self.FPaymentMode = __pmtModeAsIncome then
      begin
        b := (pAccData.accountId = (_ac.sysAccountId[_accPrepayment])) or pAccData.FPrepayment;


        paramByname('ref_prepayment_flag').AsString := estbk_types.SCFalseTrue[b];

        paramByname('ref_payment_flag').AsString := estbk_types.SCFalseTrue[False]; // payment = pigem maksekorraldus !


        //22.10.2011 Ingmar; kui oli teine konto, kui klientite tasumata arved, siis ei pandud lippu võlg ja laekumise lahtivõtmine toimus valesti !
        b := (pAccData.accountId = (_ac.sysAccountId[_accBuyersUnpaidBills])) or pAccData.isDebt;



        paramByname('ref_debt_flag').AsString := estbk_types.SCFalseTrue[b];
        paramByname('ref_income_flag').AsString := estbk_types.SCFalseTrue[pAccData.isFinalAggrLine];
      end;


      // 31.08.2011 Ingmar; täiendavad juhtlipud !
      paramByname('flags').AsInteger := pAccData.flags;



      paramByname('status').AsString := '';
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      execSQL;


    finally
      Close;
      Clear;
    end;

end;

// TODO: teha kood normaalseks; hetkel liiga palju mõttetuid tegevusi
// märgib arve reale laekumised;
procedure TPaymentManager.markItemPayments;
var
  i, j: integer;
  p1, p2: TPaymentAccData;
  pPrepaidSum: currency;
  pIncomeSum: currency; // ilma ettemaksu osata !
begin

  for i := 0 to FAccEntrys.Count - 1 do
  begin
    pPrepaidSum := 0;
    pIncomeSum := 0;
    p1 := TPaymentAccData(FAccEntrys.Items[i]);

    if not p1.isFinalAggrLine and not p1.FItemProcessed and (p1.FitemId > 0) and not p1.dontUseInOverAllCalc then // 01.09.2011 Ingmar
      case p1.FitemType of
        __pmtItemAsBill:
        begin

          // lööme nüüd summad kokku, mis arvele vaja märkida !
          for j := 0 to FAccEntrys.Count - 1 do
          begin
            p2 := TPaymentAccData(FAccEntrys.Items[j]);
            if p2.FisFinalAggrLine then
              continue;



            if (p2.FitemId = p1.FitemId) and (p2.FitemType = p1.FitemType) then
            begin
              case p2.isPrepayment of
                True: pPrepaidSum := pPrepaidSum + p2.sum;
                False: pIncomeSum := pIncomeSum + p2.sum;
              end;

              // --
              p2.FItemProcessed := True; // märgime elemendi ära, et järgmisel korral uuesti ei summeeriks !
            end;
          end;




          // -- kirjutame muudatused ära
          with self.FWrkQuery, SQL do
            try
              Close;
              Clear;
              add(estbk_sqlclientcollection._SQLPyUpdateBillPaymentData);
              paramByname('rec_changed').AsDateTime := now;
              paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
              //paramByname('payment_status').asString:=pPaymentStatus;
              // ---

              paramByname('incomesum').asCurrency := pIncomeSum;
              paramByname('prepaidsum').asCurrency := pPrepaidSum;
              paramByname('id').AsInteger := p1.FitemId;
              execSQL;
            finally
              Close;
              Clear;
            end; // ---
        end;

        __pmtItemAsOrder:
        begin

          //pPaymentStatus:=p1.FPretermPmtStatus;
          for j := 0 to FAccEntrys.Count - 1 do
          begin
            p2 := TPaymentAccData(FAccEntrys.Items[j]);
            if p2.FisFinalAggrLine then
              continue;

            if (p2.FitemId = p1.FitemId) and (p2.FitemType = p1.FitemType) then
            begin
              // tellimusel alati ETTEMAKS !
              assert(p2.isPrepayment, '#5');
              pPrepaidSum := pPrepaidSum + p2.sum;
              p2.FItemProcessed := True;
            end;
          end;  // --


          // -- kirjutame muudatused ära vol 2
          with self.FWrkQuery, SQL do
            try
              Close;
              Clear;
              add(estbk_sqlclientcollection._SQLUpdateOrderPmtData2);
              paramByname('paid_sum').asCurrency := pPrepaidSum;
              //paramByname('payment_status').asString:=pPaymentStatus;
              paramByname('id').AsInteger := p1.FitemId;
              execSQL;
            finally
              Close;
              Clear;
            end;

          // --
        end;
      end;
    // ---
  end;
end;

function TPaymentManager.addAccEntry(const itemId: integer; const itemType: TPaymentItemIs; const addToColl: boolean = True): TPaymentAccData;
begin
  Result := TPaymentAccData.Create(itemId, itemType);
  if addToColl then
    self.FAccEntrys.Add(Result);
   {$ifdef debugmode}
  Inc(FaccEntryWriteCount);
   {$endif}
end;

function TPaymentManager.cloneAccBasicEntry(const pClonedEntry: TPaymentAccData): TPaymentAccData;
begin
  Result := nil;
  if assigned(pClonedEntry) then
  begin
    //result:=TPaymentAccData.Create(pClonedEntry.FitemId,pClonedEntry.FitemType);
    Result := self.addAccEntry(pClonedEntry.FitemId, pClonedEntry.FitemType, True);
    Result.recType := pClonedEntry.recType;
    Result.accountId := pClonedEntry.accountId;
    Result.clientId := pClonedEntry.clientId;
    Result.recNr := pClonedEntry.recNr;
    Result.descr := pClonedEntry.descr;
    //result.sum:=pClonedEntry.sum;
    Result.sum := 0;


    Result.currencyIdentf := pClonedEntry.currencyIdentf;
    Result.currencyRate := pClonedEntry.currencyRate;
    Result.currencyID := pClonedEntry.currencyID;



    Result.pmtItemCurrIdentf := pClonedEntry.pmtItemCurrIdentf;
    Result.pmtItemCurrRate := pClonedEntry.pmtItemCurrRate;
    Result.pmtItemCurrID := pClonedEntry.pmtItemCurrID;
    //result.pretermPmtStatus:=pClonedEntry.pretermPmtStatus;



    // põhjustab kloonimisel suuri probleeme ja vigu !
    Result.isPrepayment := False; // pClonedEntry.isPrepayment;
    Result.isDebt := False; // pClonedEntry.isDebt;
    Result.isFinalAggrLine := False;

    // reserveeritud !
    Result.isIncome := False;
  end;
end;

// @@@
procedure TPaymentManager.writeEntryLog(const pFilename: AStr);
var
  pTxtFile: Textfile;
  pAccrec: TPaymentAccData;
  i: integer;
begin

  if self.FAccEntrys.Count > 0 then
  begin

    Assign(pTxtFile, pFilename);
    rewrite(pTxtFile);
    writeln(pTxtFile, 'payment/income');
    writeln(pTxtFile, 'currency:', self.FpaymentCurrency);
    writeln(pTxtFile, 'currency_rate:', floattostr(self.FpaymentCurrRate));


    // ---
    for i := 0 to self.FAccEntrys.Count - 1 do
    begin

      pAccrec := TPaymentAccData(self.FAccEntrys.Items[i]);
      writeln(pTxtFile, '# --', pAccrec.recNr);


      // --> küsime pikad konto nimed !
      self.FWrkQuery.Close;
      self.FWrkQuery.SQL.Clear;
      self.FWrkQuery.SQL.add(format('SELECT account_name FROM accounts WHERE id=%d', [pAccrec.accountId]));
      self.FWrkQuery.Open;
      writeln(pTxtFile, 'account_id:', pAccrec.accountId, ' [ ' + self.FWrkQuery.FieldByName('account_name').AsString + '] ', pAccrec.recType);
      self.FWrkQuery.Close;

      writeln(pTxtFile, 'descr:', pAccrec.descr);

      writeln(pTxtFile, 'account_sum:', floattostr(pAccrec.sum)); // kõige labasemas formaadis !
      writeln(pTxtFile, 'account_curr:', pAccrec.currencyIdentf);
      writeln(pTxtFile, 'account_curr_rate:', floattostr(pAccrec.currencyRate));

      writeln(pTxtFile, 'pmt_item_id:', pAccrec.FitemId);

      writeln(pTxtFile, 'pmt_item_curr:', pAccrec.pmtItemCurrIdentf);
      writeln(pTxtFile, 'pmt_curr_rate:', floattostr(pAccrec.pmtItemCurrRate));

      writeln(pTxtFile, 'debt:', booltostr(pAccrec.isDebt, True));
      writeln(pTxtFile, 'prep:', booltostr(pAccrec.isPrepayment, True));
      writeln(pTxtFile, 'bank:', booltostr(pAccrec.isFinalAggrLine, True));
      writeln(pTxtFile, 'inc/pmt:', booltostr(pAccrec.isIncome, True));

    end;

    // ----
    writeln(pTxtFile, '---------');
    writeln(pTxtFile, 'dcdiff:', floattostr(self.FDBalanceSum - self.FCBalanceSum));

    closefile(pTxtFile);
  end;
end;

(*
case 1

Firma võlg hankijale materjalide eest on 2000usd. Kohustus on firma kirjendanud oma raamatupidamises majandustehingu
toimumise päeval kehtinud Eesti Panga kursiga 1usd=17,45EEK (2000*17,45=34900).
kohustus tasutakse kroonides pangakontolt. Sellel päeval kehtinud kommertspanga kurss: 1usd=17,65kr (2000*17,65=35500).
Firma koostab tasumise kohta raamatupidamislausendi:
D Võlad tarnijatele  34 900
D Muud ärikulud  400
K Pangakonto  35 300

case 2

Firma võlg hankijale materjalide eest on 2000usd. Kohustus on firma kirjendanud oma raamatupidamises majandustehingu
toimumise päeval kehtinud Eesti Panga kursiga 1usd=17,45EEK (2000*17,45=34900).

kohustus tasutakse kroonides sularahas. Sellel päeval kehtinud kommertspanga kurss: 1usd=17,65kr (2000*17,65=35500).
Firma koostab tasumise kohta raamatupidamislausendi:
D Võlad tarnijatele  34 900
D Muud ärikulud  400
K Kassa  35 300

case 3

Firma võlg hankijale materjalide eest on 2000usd. Kohustus on firma kirjendanud oma raamatupidamises majandustehingu
toimumise päeval kehtinud Eesti Panga kursiga 1usd=17,45EEK (2000*17,45=34900).
Kohustus tasutakse valuutas pangakontolt. Firma raamatupidamises arvelevõetud välisvaluuta kurss on   1usd=17kr
Hankijale makstav summa arvelevõetud välisvaluuta kursi alusel on (2000*17=34000).
Firma koostab tasumise kohta raamatupidamislausendi:
D Võlad tarnijatele  34 900
K USD arveldusarve  34 000
K Muud äritulud  900


// ---
maksekorralduse standardkanne

D hankijatele võlg arve nr.... eest n 100kr
D pangakulud  6kr
K arveldusarve hansapangas EEK 106kr

*)


// käime nimistu läbi ja moodustame kreeditpoole
// arve tasumine
(*
  D hankijatele võlg arve nr.... eest n 100kr
  D pangakulud  6kr
  K arveldusarve hansapangas EEK 106kr
*)


procedure TPaymentManager.checkIfRoundingAccRecNeeded(const pLastCalcBaseSum: double);
(*
*)
// 20.09.2013
// Väga suurte valuutakahjumite puhul see osa ei tööta !
const
  // CMaxAcceptRoundDiff = 1.99;
  CMaxAcceptRoundDiff = 9.99; // suurem kui 99 ühikut kahjum on tõesti juba täielik anomaalia !!!!

var
  pRoundSum: double;
  pPmtAccData: TPaymentAccData;
  pDCBalCalc: double;
begin

{
case self.FPaymentMode of
  __pmtModeAsPayment : pRoundSum:=roundto(pLastCalcBaseSum-FDBalanceSum,Z2); // MAKSEKORRALDUS; raha välja ->
  __pmtModeAsIncome  : pRoundSum:=roundto(pLastCalcBaseSum-FCBalanceSum,Z2); // LAEKUMISTE MÄRKIMINE: raha sisse ->
else // targemat ei oska siinkohal teha !
  Exit;
end;
}


  case self.FPaymentMode of
    __pmtModeAsPayment:
    begin // MAKSEKORRALDUS; raha välja ->
      pDCBalCalc := self.FDBalanceSum - self.FCBalanceSum; // FCBalanceSum kursivahe
      pRoundSum := roundto(pLastCalcBaseSum - pDCBalCalc, Z2);
    end;
    __pmtModeAsIncome: pRoundSum := roundto(pLastCalcBaseSum - FCBalanceSum, Z2); // LAEKUMISTE MÄRKIMINE: raha sisse <-
    else // targemat ei oska siinkohal teha !
      Exit;
  end;




  // ------
  pPmtAccData := nil;
  // ------
  if not Math.IsZero(pRoundSum) then
    try
      Inc(self.FaccRecNr);
      // @@@
      if abs(pRoundSum) > CMaxAcceptRoundDiff then
        raise Exception.createFmt(estbk_strmsg.SERoundErrorSumTooBig, [pRoundSum]);

      pPmtAccData := self.addAccEntry(0, __pmtItemAsUnknown, False);


      pPmtAccData.clientId := 0;
      pPmtAccData.currencyID := 0;
      pPmtAccData.currencyRate := 1.00;
      pPmtAccData.currencyIdentf := estbk_globvars.glob_baseCurrency;

      pPmtAccData.pmtItemCurrID := 0;
      pPmtAccData.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
      pPmtAccData.pmtItemCurrRate := 1.00;



      pPmtAccData.regMRec := self.FAccMainRec;
      pPmtAccData.sum := abs(pRoundSum);
      pPmtAccData.recNr := self.FaccRecNr;



      if pRoundSum > 0 then
      begin
        pPmtAccData.accountId := _ac.sysAccountId[_accRoundRevenue];
        case self.FPaymentMode of
          __pmtModeAsPayment: pPmtAccData.recType := estbk_types.CAccRecTypeAsDebit;
          __pmtModeAsIncome: pPmtAccData.recType := estbk_types.CAccRecTypeAsCredit;
        end;
      end
      else
      begin
        pPmtAccData.accountId := _ac.sysAccountId[_accRoundCost];
        case self.FPaymentMode of
          __pmtModeAsPayment: pPmtAccData.recType := estbk_types.CAccRecTypeAsCredit;
          __pmtModeAsIncome: pPmtAccData.recType := estbk_types.CAccRecTypeAsDebit;
        end;
      end;



      // ---
      // kirjutame siis ümmardamise vahed ära...
      self.doAccDbWrite(pPmtAccData);

    finally
      FreeAndNil(pPmtAccData);
    end;
end;

// 07.02.2011 Ingmar; ntx agregaatread peaksid olema sama valuutaga; nö itemid !
// ntx laekumistes oli olukord, kus N + 1 elementi, aga erinevates valuutades. Pangalaekumine
procedure TPaymentManager.convItemSumToBaseCurr(var pPmtEntry: TPaymentAccData);
var
  bBaseSum: double;
begin
  bBaseSum := pPmtEntry.sum * pPmtEntry.pmtItemCurrRate; // math.roundto

  pPmtEntry.sum := bBaseSum;
  pPmtEntry.pmtItemCurrRate := 1.000;
  pPmtEntry.pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;
end;


procedure TPaymentManager.combineEntrys(const pSkipItemIdCheckByAggrFlag: boolean = True);
var
  i, j: integer;
  pcmp1: TPaymentAccData;
  pcmp2: TPaymentAccData;
begin

  // --
  i := 0;
  while (i <= self.FAccEntrys.Count - 1) do
  begin
    j := self.FAccEntrys.Count - 1;
    pcmp1 := self.FAccEntrys.Items[i] as TPaymentAccData;
    while (j >= 0) and (j > i) do
    begin
      pcmp2 := self.FAccEntrys.Items[j] as TPaymentAccData;

      // kas tõesti sarnane kanne
      if (pcmp1.accountId = pcmp2.accountId) and (pcmp1.currencyIdentf = pcmp2.currencyIdentf) and
        (roundto(pcmp1.currencyRate, Z4) = roundto(pcmp2.currencyRate, Z4)) and (pcmp1.recType = pcmp2.recType) and
        (pcmp1.pmtItemCurrIdentf = pcmp2.pmtItemCurrIdentf) and (roundto(pcmp1.pmtItemCurrRate, Z4) = roundto(pcmp2.pmtItemCurrRate, Z4)) and
        (pcmp1.isFinalAggrLine = pcmp2.isFinalAggrLine) and (pcmp1.isPrepayment = pcmp2.isPrepayment) and
        (pcmp1.isIncome = pcmp2.isIncome) and (pcmp1.isDebt = pcmp2.isDebt) then
      begin

        // agregaat; PANK# MAKSEKORRALDUS / LAEKUMINE
        if (((pcmp1.FitemId = pcmp2.FitemId) and (pcmp1.FitemType = pcmp2.FitemType)) or (pcmp1.isFinalAggrLine and
          pcmp2.isFinalAggrLine and pSkipItemIdCheckByAggrFlag)) then
        begin
          pcmp1.sum := pcmp1.sum + pcmp2.sum;
          self.FAccEntrys.Delete(j);
        end;
      end;



      Dec(j);

    end;

    // --
    Inc(i);
  end;
end;

// arvutame kursivahed; päevakursi järgi, mis meil FCurrList sees
procedure TPaymentManager.calcCurrDiff(var pConvSumTotal: double; var pCurrConvWin: double; var pCurrConvCost: double; var pCurrDiffTotal: double);

var
  i, pIndex: integer;
  pCurrDiffTemp: double;
  // kui toimub konverteerimine !
  // valuutakahjum
  //pCurrConvCost  : Double;
  // valuutakasum
  //pCurrConvWin   : Double;

  // ---
  pCurrRateBl: double;
  pCurrRateBlSel: double;
  pCrossConv: double;
  pSum: double;
  pNewAccLine: TPaymentAccData;
  pAccId: integer;

begin

  // ---
  pCurrConvCost := 0;
  pCurrConvWin := 0;
  pConvSumTotal := 0;
  pCurrDiffTotal := 0;

  for i := 0 to FAccEntrys.Count - 1 do
    with TPaymentAccData(FAccEntrys.Items[i]) do
      if not isFinalAggrLine then // ehk siis kreeditosa ! @@[PANK]
      begin

        if trim(pmtItemCurrIdentf) = '' then
          pmtItemCurrIdentf := estbk_globvars.glob_baseCurrency;

        // -------------------------------------------------------------------
        // originaalsumma ja valuuta on teisendamata kenasti kande kirjes
        // -------------------------------------------------------------------

        pSum := sum; // kirje originaalsumma
        // ...otsime samuti kontode valuutakursid..konto valuuta erineb baasvaluutast
        if currencyIdentf <> estbk_globvars.glob_baseCurrency then
        begin
          pIndex := FCurrValList.IndexOf(currencyIdentf);

          if pIndex = -1 then
            raise Exception.createFmt(SEMissingCurrVal, [currencyIdentf]);

          currencyRate := TCurrencyObjType(FCurrValList.Objects[pIndex]).currVal;
          currencyID := TCurrencyObjType(FCurrValList.Objects[pIndex]).id;
        end;


        // ---
        if pmtItemCurrIdentf <> estbk_globvars.glob_baseCurrency then
        begin
          // meil teada, et arve tehti ntx 2010-07-07 kursiga
          // 1usd=17,45EEK (2000*17,45=34900)
          // see oli kurss arve tegemise hetkel...
          pCurrRateBl := pmtItemCurrRate; // ntx 17.45
          if pCurrRateBl = 0 then
            pCurrRateBl := 1;


          // nüüd on meil vaja sama valuuta hetkekurss ning summa leida
          pIndex := FCurrValList.IndexOf(pmtItemCurrIdentf);
          //assert(pIndex>=0,'#2');
          if pIndex = -1 then
            raise Exception.createFmt(SEMissingCurrVal, [pmtItemCurrIdentf]);


          // nüüd meil olemas sama valuuta kurss tänase seisuga; ntx 17,65
          pCurrRateBlSel := TCurrencyObjType(FCurrValList.Objects[pIndex]).currVal;
          if pCurrRateBlSel = 0 then
            pCurrRateBlSel := 1;



          // saime teada kursivahed...
          pCurrDiffTemp := (roundto(double(pSum * pCurrRateBlSel), Z2) - (roundto(double(pSum * pCurrRateBl), Z2)));
          pCurrDiffTotal := pCurrDiffTotal + pCurrDiffTemp;


          // muutujad kannete jaoks
          if pCurrDiffTemp < 0 then
            pCurrConvWin := roundto(pCurrConvWin + abs(pCurrDiffTemp), Z2)
          else
            pCurrConvCost := roundto(pCurrConvCost + pCurrDiffTemp, Z2);




          // --
          if pmtItemCurrIdentf <> self.FpaymentCurrency then
          begin
            // ristkursid: summa, mis on konverteeritud maksekorralduse valuutasse !!!
            pCrossConv := roundto(double(pSum * pCurrRateBl) / double(self.FpaymentCurrRate), Z2);
            pConvSumTotal := pConvSumTotal + pCrossConv; //  maksekorralduse summa
          end;

        end
        else
          pConvSumTotal := pConvSumTotal + roundto(pSum / self.FpaymentCurrRate, Z2); // BAASVALUUTA EEK
      end;




  // konverteerime vahe maksekorralduse valuutasse !
  if self.FpaymentCurrRate > 0 then
    pCurrDiffTotal := roundto(pCurrDiffTotal / double(self.FpaymentCurrRate), Z2)
  else
    pCurrDiffTotal := 0;

  // ---------------------------
  // lisame juurde täiendavad kanded
  // VALUUTAKULUD
  // ---------------------------

  if pCurrConvCost > 0 then
  begin
    pNewAccLine := self.addAccEntry(-1, __pmtItemAsUnknown);
    pAccId := _ac.sysAccountId[_accCurrRateCost];
    pNewAccLine.recType := estbk_types.CAccRecTypeAsDebit;
    pNewAccLine.accountId := pAccId;
    pNewAccLine.descr := ''; // dmodule.sysAccountLongName[_accCurrRateCost];
    pNewAccLine.sum := pCurrConvCost; // vaikimisi summa baasvaluutas ehk EEK / tulevikus siis EUR

    pNewAccLine.clientId := 0;
    pNewAccLine.currencyIdentf := _ac.sysAccountCurr[_accCurrRateCost];

    pIndex := FCurrValList.IndexOf(pNewAccLine.currencyIdentf);
    //assert(pIndex>=0,'#2');
    if pIndex = -1 then
      raise Exception.createFmt(SEMissingCurrVal, [pNewAccLine.currencyIdentf]);

    pNewAccLine.currencyId := TCurrencyObjType(FCurrValList.Objects[pIndex]).id;
    pNewAccLine.currencyRate := TCurrencyObjType(FCurrValList.Objects[pIndex]).currVal;
    if pNewAccLine.currencyRate = 0 then
      pNewAccLine.currencyRate := 1;

    // 1:1
    pNewAccLine.pmtItemCurrRate := 1.00;
  end;

  // ---------------------------
  // VALUUTATULUD
  // ---------------------------


  if pCurrConvWin > 0 then
  begin
    pNewAccLine := self.addAccEntry(-1, __pmtItemAsUnknown);
    pAccId := _ac.sysAccountId[_accCurrRateRevenue];
    pNewAccLine.recType := estbk_types.CAccRecTypeAsCredit;



    pNewAccLine.accountId := pAccId;
    pNewAccLine.descr := ''; // dmodule.sysAccountLongName[_accCurrRateCost];
    // vaikimisi summa baasvaluutas ehk EEK / tulevikus siis EUR
    // 21.08.2013 Ingmar; vale muutuja oli pCurrConvCost; peab olema pCurrConvWin
    pNewAccLine.sum := pCurrConvWin;

    pNewAccLine.clientId := 0;
    pNewAccLine.currencyIdentf := _ac.sysAccountCurr[_accCurrRateRevenue];

    pIndex := FCurrValList.IndexOf(pNewAccLine.currencyIdentf);
    //assert(pIndex>=0,'#2');
    if pIndex = -1 then
      raise Exception.createFmt(SEMissingCurrVal, [pNewAccLine.currencyIdentf]);

    pNewAccLine.currencyId := TCurrencyObjType(FCurrValList.Objects[pIndex]).id;
    pNewAccLine.currencyRate := TCurrencyObjType(FCurrValList.Objects[pIndex]).currVal;
    if pNewAccLine.currencyRate = 0 then
      pNewAccLine.currencyRate := 1;

    // 1:1
    pNewAccLine.pmtItemCurrRate := 1.00;
  end;


  // --------
end;

// ntx maksekorralduse puhul, kirjutab ta viimase kande ära ! PANK(kreedit)
procedure TPaymentManager.doSaveAccEntrys(const pCalcAlsoCurrDiff: boolean = True);
var
  i: integer;
  //  pCmp1,pCmp2    : Double; 22.09.2013 Ingmar
  pCalc: double;
  // 22.09.2013 Ingmar
  pCurrConvWin: double;
  pCurrConvCost: double;

  pCurrDiffTotal: double;
  pConvSumTotal: double;
  pPreCalc: double;
  pNewAccLine: TPaymentAccData;
  pBankTypeCnt: byte;

begin

  // - kannete kaudu koostame ka summad, mille märgime arve/tellimuse kirjetele !
  self.markItemPayments;


  self.FDBalanceSum := 0;
  self.FCBalanceSum := 0;

  // --- valuutakurss, millesse tuleb teisendada maksed; olgu maksekorraldus/laekumised/kassa
  if self.FpaymentCurrRate = 0 then
    self.FpaymentCurrRate := 1;



  // 20.01.2011 Ingmar; pole mõtet samasuguseid kandeid eraldi ridadena teha
  self.combineEntrys;


  // -------
  // Arvutame kannete pealt valuuta kasumi ja kahjumi; ntx maksekorraldus; laekumiste puhul on see eelarvutatud juba !
  pCurrDiffTotal := 0;
  pConvSumTotal := 0;
  pCurrConvWin := 0;
  pCurrConvCost := 0;

  if pCalcAlsoCurrDiff then
    self.calcCurrDiff(pConvSumTotal, pCurrConvWin, pCurrConvCost, pCurrDiffTotal);




  //   pCurrDiffTotal:=abs(pCurrDiffTotal);
  // ja alustame ülejäänud kannete kirjutamist
  for i := 0 to FAccEntrys.Count - 1 do
    with TPaymentAccData(FAccEntrys.Items[i]) do
      if not isFinalAggrLine then
      begin

        // väike korrektsioon !
        if TPaymentAccData(FAccEntrys.Items[i]).pmtItemCurrIdentf = estbk_globvars.glob_baseCurrency then
          pmtItemCurrRate := 1;

        assert(pmtItemCurrRate > 0, '#4');

        // --------------------------------------------------------------------
        // KANDE SUMMA TAGASI BAASVALUUTASSE
        //pCalc:=math.roundto(sum*pmtItemCurrRate,Z2); // vahemuutuja muidu debugger ei kuva väärtust !
        pCalc := sum * pmtItemCurrRate;
        Sum := pCalc;
        // --------------------------------------------------------------------
        // --- kirjutame siis kanded reaalselt ära
        self.doAccDbWrite(TPaymentAccData(FAccEntrys.Items[i]));

      end;




  // -- 20.01.2011 Ingmar; hetkel tohib olla vaid üks bankline tüüpi kirje; see on nö koondsumma !
  // -- kogusumma, mis pangast võtta või tuleb;
  // pConvSumTotal:=pConvSumTotal+roundto(pCurrConvCost/double(self.FpaymentCurrRate),Z2)+roundto(pCurrConvWin/double(self.FpaymentCurrRate),Z2);
  pBankTypeCnt := 0;

  for i := 0 to FAccEntrys.Count - 1 do
    with TPaymentAccData(FAccEntrys.Items[i]) do
      if isFinalAggrLine then
      begin
        assert(pBankTypeCnt = 0, '#3');
        Inc(pBankTypeCnt); // välistame rumalused; korraga tohib olla vaid üks pangaga seotud kanne !


        //  lisakontroll
        //  SameValue
        //  20.09.2013 Ingmar; ühel inimesel oli see vahe lausa 400
           {
           if (self.FpaymentMode=__pmtModeAsPayment) and (double(pCmp2-pCmp1)>1.00) then
               raise exception.createFmt(SEPmtPresumAccSumMismatch,[pCmp2,pCmp1,double(pCmp2-pCmp1)]);
           }
        assert(pmtItemCurrRate > 0, '#6');
        // --------------------------------------------------------------------
        // KANDE SUMMA BAASVALUUTASSE
        pCalc := (Sum * pmtItemCurrRate);
        Sum := pCalc;
        // --------------------------------------------------------------------


        // kontrollime võimalikud ümmardamised üle
        // self.checkIfRoundingAccRecNeeded(sum);

        // 22.09.2013 Ingmar; tuleb korrigeerida ka valuuta summaga !!!! vähemalt tasumistel küll !
        // pCurrDiffTotal:=Sum - (pCurrConvWin * pmtItemCurrRate);
        // pCurrDiffTotal:=pCurrDiffTotal + (pCurrConvCost * pmtItemCurrRate);



        self.checkIfRoundingAccRecNeeded(Sum);

        // "lõplik" kanne ka baasi
        self.doAccDbWrite(TPaymentAccData(FAccEntrys.Items[i]));
      end; // --




  // sisemine kontroll, et kanded oleks ikka ok; see kande osa originaal valuutas, ilma konverteerimata !
  // if   not Math.SameValue(double(self.FDBalanceSum-self.FCBalanceSum), 0.00, 0.001) then // imelik, ilma selleta arvas kompilaator, et tegemist cardinaliga ?!?
  //     self.FDBalanceSum:=roundto(self.FDBalanceSum,Z2);
  //     self.FCBalanceSum:=roundto(self.FDBalanceSum,Z2);


  if not Math.SameValue(self.FDBalanceSum, self.FCBalanceSum, estbk_types.CEpsilon) then
    raise Exception.createFmt(estbk_strmsg.SEAccEntryUnBalanced + ' D: %.4f; C: %.4f [%.4f] @ERR:1',
      [self.FDBalanceSum, self.FCBalanceSum, double(self.FDBalanceSum - self.FCBalanceSum)]);

  //  if not math.IsZero(self.FDBalanceSumConv-self.FCBalanceSumConv) then
  //     raise exception.createFmt(estbk_strmsg.SEAccEntryUnBalanced+' D: %.4f; C: %.4f [%.4f] @ERR:2',[self.FDBalanceSumConv,self.FCBalanceSumConv,double(self.FDBalanceSumConv-self.FCBalanceSumConv)]);




  // puhver tühjaks !
  self.clearData;
end;


// tegelikkuses antud funktsioon kontrollib, kas meie poolt loodud ettemaksu pole kusagil ära kasutatud
// LAEKUMISED / MAKSEKORRALDUS
function TPaymentManager.verifyPrepaymentUsage(const pAccMainRecId: integer; var pErrorInf: AStr): boolean;
var
  pLongName: AStr;
begin
  Result := False; // oletame, et alguses, kõik ilus ja tore
  pErrorInf := '';
  with self.FWrkQuery2, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLCheckIsCurrPaymentPrePaymentUsed(pAccMainRecId)); // otsime vihjeid kande ettemaksu kasutamisele
      Open;
      // --------
      Result := RecordCount > 0;
      // --------

      if not Result then
      begin
        First;
        while not EOF do
        begin

          // kuvame ka, millega tegemist;  ARVE / TELLIMUS
          pLongName := '';
          if AnsiUpperCase(FieldByName('ref_item_type2').AsString) = estbk_types.CCommTypeAsBill then
            pLongName := estbk_strmsg.SCPLangBillName
          else
          if AnsiUpperCase(FieldByName('ref_item_type2').AsString) = estbk_types.CCommTypeAsOrder then
            pLongName := estbk_strmsg.SCPLangOrderName
          else
            pLongName := '?';
          // anname siis teada, kus seda ettemaksu on kasutatud
          pErrorInf := pErrorInf + format('%s # %s - %s', [pLongName, FieldByName('srcitem_nr').AsString,
            datetostr(FieldByName('srcitem_date').AsDateTime)]) + #13#10;
          Next;
        end;
        // ---
      end;

    finally
      Close;
      Clear;
    end;
end;


procedure TPaymentManager.doItemsumRecalculation(const prData: TPaymentRollBackDataRec);
// @@SUB

  procedure negValCheck(const pVal: currency);
  begin
    case self.FPaymentMode of
      __pmtModeAsPayment: raise Exception.CreateFmt(estbk_strmsg.SEPmtOrderPmtRollbackErr, [SEPmtOrderBOSumLess0]);
      __pmtModeAsIncome: raise Exception.CreateFmt(estbk_strmsg.SEIncRollbackErr, [SEPmtOrderBOSumLess0]);
    end;

  end;

var
  precalcPrpSum: currency;
  precalcIncSum: currency;
begin
  if (self.FPaymentMode in [__pmtModeAsPayment, __pmtModeAsIncome]) then
    with self.FWrkQuery2, SQL do
      try
        Close;
        Clear;


        // laekumise koond ei tohi muutuda negatiivseks !
        precalcIncSum := prData.pLItemIncomeSum - prData.pPaidSum;
        {
           29.08.2011 Ingmar; seoses ostuarvetega võivad tekkida ka negatiivsed tasumised
          if  precalcIncSum < 0 then
              negValCheck(precalcIncSum);
        }


        // pLItemUPrepaidSum see muutuja meid hetkel "veel" ei huvita
        if prData.pItemType = estbk_types.CCommTypeAsBill then
        begin

          // võtame siis summad arvete pealt ka maha !
          precalcPrpSum := prData.pLItemPrepaidSum - prData.pPrepaymentSum; // ETTEMAKS !
          if precalcPrpSum < 0 then // tegemist on mingi veaga ! TODO; näidata veapuhul ka ära, et millise arve/tellimusega see tekkis !!!
            negValCheck(precalcPrpSum);



          add(estbk_sqlclientcollection._SQLUpdateBillPmtData);


          // -------------------------------------------------------------
          // võtame kandega märgitud summad uuesti maha !

          paramByname('incomesum').asCurrency := -prData.pPaidSum;
          paramByname('prepaidsum').asCurrency := -prData.pPrepaymentSum;
          // -------------------------------------------------------------

          // nüüd arvutab staatusi trigger !
          // hetkel ei kasuta
         {
          if  (prData.pLItemIncomeSum>0) and (precalcIncSum=0) then  // LAEKUMINE EEMALDATI
               paramByname('payment_status').asString:=estbk_types.CBillPaymentUd
          else
          if  (prData.pLItemIncomeSum-prData.pPaidSum<prData.pLItemToPaySum) then  // OSALINE SUMMA JÄI ÜLES
               paramByname('payment_status').asString:=estbk_types.CBillPaymentPt
          else //
               paramByname('payment_status').value:=null; // jätame staatuse nagu on
         }

          paramByname('payment_date').Value := null; // unused
          paramByname('uprepaidsum').Value := null; // unused
          paramByname('id').AsInteger := prData.pItemId;
          execSQL;
        end
        else
        if prData.pItemType = estbk_types.CCommTypeAsOrder then
        begin
          precalcPrpSum := prData.pLItemIncomeSum - prData.pPrepaymentSum;
          if precalcPrpSum < 0 then
            raise Exception.CreateFmt(estbk_strmsg.SEPmtOrderPmtRollbackErr, [SEPmtOrderBOSumLess0]);

          add(estbk_sqlclientcollection._SQLUpdateOrderPmtData2);

          // tellimus alati "ettemaks"
          paramByname('paid_sum').asCurrency := -prData.pPrepaymentSum; // -prData.pPaidSum;
          paramByname('id').AsInteger := prData.pItemId;

          // 31.03.2011 Ingmar; nüüd arvutab staatusi trigger !
           {
           if precalcPrpSum=0 then
               paramByname('payment_status').asString:=estbk_types.COrderPaymentUd
           else
           if precalcPrpSum>=prData.pLItemToPaySum then // võeti vaid ülemakstud osa tagasi ?!?
               paramByname('payment_status').asString:=estbk_types.COrderPaymentOk
           else
               paramByname('payment_status').asString:=estbk_types.COrderPaymentPt;}
          execSQL;
        end;
        // ---

      finally
        Close;
        Clear;
      end;

end;

procedure TPaymentManager.doPaymentRollback(const pMainRecId: integer);
var
  prData: TPaymentRollBackDataRec;

begin
  // ---
  with self.FWrkQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLGetPaymentRefItems(pMainRecId));
      Open;
      // @@debug
      // sql.SaveToFile('c:\debug\refitems.txt');

      First;
      if EOF then
        exit;



      prData.pRecProcessed := False;
      prData.pPrepaymentSum := 0;
      prData.pPaidSum := 0;
      prData.pItemId := FieldByName('ref_item_id').AsInteger;
      prData.pItemType := FieldByName('ref_item_type').AsString;

      // --
      prData.pLItemToPaySum := FieldByName('topay').asCurrency;          // arvel / tellimusel jäänud tasuda
      prData.pLItemIncomeSum := FieldByName('incomesum').asCurrency;     // arve / tellimuse laekunud summa
      prData.pLItemPrepaidSum := FieldByName('prepaidsum').asCurrency;   // arve / tellimuse ettemaksu summa st enammaks pigem !
      prData.pLItemUPrepaidSum := FieldByName('uprepaidsum').asCurrency; // arvel / tellimusel ärakasutatud ettemaksu summa;



      // teeme nö labase grupeerimise
      // --
      while not EOF do
      begin

        // saabus järgmine element; kirjutame jooksva elemendi andmed ära !
        if ((prData.pItemId <> FieldByName('ref_item_id').AsInteger) or (prData.pItemType <> FieldByName('ref_item_type').AsString)) then
        begin

          // --- arvutame arve / tellimuse tasumise / laekumise ümber
          self.doItemsumRecalculation(prData);
          // ----

          prData.pPrepaymentSum := 0;
          prData.pPaidSum := 0;



          // ---
          // jätame meelde uuesti elemendi parameetrid !
          prData.pLItemToPaySum := FieldByName('topay').asCurrency;
          prData.pLItemIncomeSum := FieldByName('incomesum').asCurrency;
          prData.pLItemPrepaidSum := FieldByName('prepaidsum').asCurrency;
          prData.pLItemUPrepaidSum := FieldByName('uprepaidsum').asCurrency;


          // --
          prData.pItemId := FieldByName('ref_item_id').AsInteger;
          prData.pItemType := FieldByName('ref_item_type').AsString;
          prData.pRecProcessed := True;
        end;




        // ----------------
        // 31.08.2011 Ingmar; tasumistes on hetki, eriti neg. arvetel, kus income sum on prepayment flag tunnusega
        // peame vaatama, et ikka õiget välja korrigeeritaks
        if isTrueVal(FieldByName('ref_prepayment_flag').AsString) and ((FieldByName('flags').AsInteger and
          estbk_types.CAccRecIncomeAsPrepaymentFlag) <> estbk_types.CAccRecIncomeAsPrepaymentFlag) then
        begin
          //prData.pRecProcessed:=(RecNo=Recordcount);
          prData.pRecProcessed := False;
          prData.pPrepaymentSum := prData.pPrepaymentSum + FieldByName('currency_vsum').AsCurrency; // peame arvega samas valuutas asju ajama

          // 31.08.2011 Ingmar; seoses negatiivse
        end
        else  // st tasumisel on  ref_payment_flag
        if ((FieldByName('flags').AsInteger and estbk_types.CAccRecIncomeAsPrepaymentFlag) = estbk_types.CAccRecIncomeAsPrepaymentFlag) or
          isTrueVal(FieldByName('ref_payment_flag').AsString) or ((isTrueVal(FieldByName('ref_debt_flag').AsString) and
          (self.FPaymentMode = __pmtModeAsIncome))) then





          // 17.02.2011 Ingmar; olin income flagi täiesti ära unustanud, häbi !
        begin
          //prData.pRecProcessed:=(RecNo=Recordcount);
          prData.pRecProcessed := False;
          //assert(not ((isTrueVal(fieldByname('ref_payment_flag').asString)) and (isTrueVal(fieldByname('ref_debt_flag').asString)  and (self.FPaymentMode=__pmtModeAsIncome))),'#6');
          prData.pPaidSum := prData.pPaidSum + FieldByName('currency_vsum').AsCurrency;
        end;


        // --
        Next;

      end;


      if not prData.pRecProcessed then
        self.doItemsumRecalculation(prData);

      // --
    finally
      Close;
      Clear;
    end;
end;

procedure TPaymentManager.doCancelAllEntrys(const pMainRecId: integer);
begin

  // --- !!!
  self.doPaymentRollback(pMainRecId);



  // tühistame kõik selle kande kirjed...
  with self.FWrkQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLCancelAccRecSQL);
      paramByname('accounting_register_id').AsInteger := self.FAccMainRec;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_changed').AsDateTime := now;
      execSQL;

      // ---
    finally
      Close;
      Clear;
    end;
  // cnvItemTypeToStr
end;

constructor TPaymentManager.Create(const pPmtMode: TPaymentMode; const pCurrValStList: TAStrlist);
begin
  inherited Create;
  FAccEntrys := TObjectList.Create(True);
  FPaymentMode := pPmtMode;
  FCurrValList := pCurrValStList;
  FAccMainRec := 0;


  // üks väike qry abiks
  FWrkQuery := TZQuery.Create(nil);
  FWrkQuery.Connection := estbk_clientdatamodule.dmodule.primConnection;

  FWrkQuery2 := TZQuery.Create(nil);
  FWrkQuery2.Connection := estbk_clientdatamodule.dmodule.primConnection;


  // ---
  assert(assigned(pCurrValStList) and (pCurrValStList.Count > 0), '#1');
  self.clearData;
end;

destructor TPaymentManager.Destroy;
begin
  FreeAndNil(FWrkQuery2);
  FreeAndNil(FWrkQuery);
  FreeAndNil(FAccEntrys);
  inherited Destroy;
end;

end.