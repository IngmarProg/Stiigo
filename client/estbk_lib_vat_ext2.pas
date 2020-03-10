unit estbk_lib_vat_ext2;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface




uses
  ZDataset, ZAbstractRODataset, Classes, SysUtils, Math, estbk_globvars, estbk_types{$ifdef debugmode}, Dialogs{$endif};

//{$ifdef debugmode}
//const CBillSumPer = 10; // 1000  -- hardcoded !?!
//{$else}
const
  CBillSumPer = 1000; // eurot arved  -- hardcoded !?!
//{$endif}


type
  TVatExtVars2 = class
  protected
    FTransactions20: double; //  20% määraga maksustatavad toimingud ja tehingud (KMD rida 1)
    FSelfSupply20: double; // 20% määraga maksustatavad toimingud ja tehingud (KMD rida 1.1)
    FTransactions9: double; // 9% määraga maksustatavad toimingud ja tehingud (KMD rida 2)
    FSelfSupply9: double; // 9% määraga maksustatav kauba või teenuse omatarve (KMD rida 2.1)
    FtransactionsZeroVat: double; // 0% määraga maksustatavad toimingud ja tehingud (KMD rida 3)
    FEUSupplyInclGoodsAndServicesZeroVat: double;
    //  (KMD rida 3.1) Kauba ühendusesisene käive ja teise liikmesriigi maksukohustuslasele/piiratud maksukohustuslasele osutatud teenuste käive kokku
    FEUSupplyGoodsZeroVat: double; // Kauba ühendusesisene käive (KMD rida 3.1.1)
    FExportZeroVat: double;  // Kauba eksport (KMD rida 3.2)
    FSalePassengersWithReturnVat: double; // Käibemaksutagastusega müük reisijale (KMD rida 3.2.1)
    FInputVatTotal: double; // Kokku sisendkäibemaksusumma, mis on seadusega lubatud maha arvata (KMD rida 5)
    FImportVat: double; // Impordilt tasutud või tasumisele kuuluv käibemaks (KMD rida 5.1)
    FFixedAssetsVat: double; // Põhivara soetamiselt tasutud või tasumisele kuuluv käibemaks (KMD rida 5.2)
    FEUAcquisitionsGoodsAndServicesTotal: double;
    //  (KMD rida 6) Kauba ühendusesisene soetamine ja teise liikmesriigi maksukohustuslaselt saadud teenused kokku
    FEUAcquisitionsGoods: double; //  Kauba ühendusesisene soetamine (KMD rida 6.1)
    FAcquisitionOtherGoodsAndServicesTotal: double; // Muu kauba soetamine ja teenuse saamine (KMD rida 7)
    FAcquisitionImmovablesAndScrapMetalAndGold: double;
    // Erikorra alusel maksustatava kinnisasja, metallijäätmete ja väärismetalli  soetamine(KMS § 41^1) (KMD rida 7.1)
    FSupplyExemptFromTax: double; // Maksuvaba käive (KMD rida 8)
    FSupplySpecialArrangements: double;
    // (KMD rida 9) Erikorra alusel maksustatava kinnisasja, metallijäätmete ja väärismetalli  käive (KMS § 41^1) ning teises liikmesriigis

    FAdjustmentsMinus: double; // (KMD rida 10)
    FAdjustmentsPlus: double; // (KMD rida 11)

  published
    property p1x_Transactions20: double read FTransactions20 write FTransactions20;
    property p11_SelfSupply20: double read FSelfSupply20 write FSelfSupply20;
    property p2x_Transactions9: double read FTransactions9 write FTransactions9;
    property p21_SelfSupply9: double read FSelfSupply9 write FSelfSupply9;
    property p3x_transactionsZeroVat: double read FtransactionsZeroVat write FtransactionsZeroVat;
    // #
    property p31_EUSupplyInclGoodsAndServicesZeroVat: double read FEUSupplyInclGoodsAndServicesZeroVat write FEUSupplyInclGoodsAndServicesZeroVat;
    property p311_EUSupplyGoodsZeroVat: double read FEUSupplyGoodsZeroVat write FEUSupplyGoodsZeroVat;
    property p32_ExportZeroVat: double read FExportZeroVat write FExportZeroVat;
    property p321_SalePassengersWithReturnVat: double read FSalePassengersWithReturnVat write FSalePassengersWithReturnVat;
    property p5x_InputVatTotal: double read FInputVatTotal write FInputVatTotal;
    property p51_ImportVat: double read FImportVat write FImportVat;
    property p52_FixedAssetsVat: double read FFixedAssetsVat write FFixedAssetsVat;
    property p6x_EUAcquisitionsGoodsAndServicesTotal: double read FEUAcquisitionsGoodsAndServicesTotal write FEUAcquisitionsGoodsAndServicesTotal;
    property p61_EUAcquisitionsGoods: double read FEUAcquisitionsGoods write FEUAcquisitionsGoods;
    property p7x_AcquisitionOtherGoodsAndServicesTotal: double read FAcquisitionOtherGoodsAndServicesTotal
      write FAcquisitionOtherGoodsAndServicesTotal;
    property p71_AcquisitionImmovablesAndScrapMetalAndGold: double read FAcquisitionImmovablesAndScrapMetalAndGold
      write FAcquisitionImmovablesAndScrapMetalAndGold;
    property p8_SupplyExemptFromTax: double read FSupplyExemptFromTax write FSupplyExemptFromTax;
    property p9_SupplySpecialArrangements: double read FSupplySpecialArrangements write FSupplySpecialArrangements;
    property p10_AdjustmentsMinus: double read FAdjustmentsMinus write FAdjustmentsMinus;
    property p11_AdjustmentsPlus: double read FAdjustmentsPlus write FAdjustmentsPlus;
  end;



type
  TVatExt2 = class
    FQuery: TZQuery;
  public
    constructor Create(const pQuery: TZQuery);
    function VatBillExtf(const pVatVars: TVatExtVars2; const pVatPerStart: TDatetime;
      const pVatPerEnd: TDatetime; const pYear: integer; // millise kuu ja aasta käibekaga tegemist !
      const pMonth: integer): AStr;
  end;

implementation

uses strutils;

constructor TVatExt2.Create(const pQuery: TZQuery);
begin
  inherited Create;
  FQuery := pQuery;
end;

function TVatExt2.VatBillExtf(const pVatVars: TVatExtVars2; const pVatPerStart: TDatetime;
  const pVatPerEnd: TDatetime; const pYear: integer;
  const pMonth: integer): AStr;

  function _xs(const pstr: AStr): AStr;
  begin
    Result := pstr;
    Result := stringreplace(Result, '&', '&amp;', [rfReplaceAll, rfIgnoreCase]);
    Result := stringreplace(Result, '"', '&quot;', [rfReplaceAll, rfIgnoreCase]);
    Result := stringreplace(Result, char(39), '&apos;', [rfReplaceAll, rfIgnoreCase]);
    Result := stringreplace(Result, '<', '&lt;', [rfReplaceAll, rfIgnoreCase]);
    Result := stringreplace(Result, '>', '&gt;', [rfReplaceAll, rfIgnoreCase]);
  end;

  function _xf(const pval: double; const pEmptyStrIfZero: boolean = False; const pIntPartOnly: boolean = False): AStr;
  begin
    if pEmptyStrIfZero and Math.IsZero(pval) then
    begin
      Result := '';
      Exit;
    end;

    if pIntPartOnly then
    begin
      Result := format('%d', [round(pval)]);
      Exit;
    end;

    Result := format(CCurrentMoneyFmt2, [pval]);
    if (SysUtils.DecimalSeparator = ',') then
      Result := stringreplace(Result, ',', '.', []);
  end;

  // http://www.emta.ee/index.php?id=35598
(*
 Kui maksustamisperioodil kauba võõrandamise või teenuse osutamise eest väljastatud/saadud arvete kogusumma ilma kreeditarveteta
 on tehingupartneri lõikes vähemalt 1000 eurot, kuuluvad kõik sellel maksustamisperioodil sellele tehingupartnerile
 väljastatud ja/või temalt saadud arved, sealhulgas kreeditarved, vastavalt vormi A- või B-osal deklareerimisele.
*)

(*
Kui maksustamisperioodil väljastatud/saadud kreeditarvete kogusumma on tehingupartneri lõikes vähemalt 1000 eurot,
kuuluvad kõik sellel maksustamisperioodil sellele tehingupartnerile väljastatud ja/või temalt saadud arved,
sealhulgas kreeditarved, vastavalt vormi A- või B-osal deklareerimisele.
*)


  function _buildQueryDetailed(const pType: AStr = ''; const pCustlist: TList = nil;
  const pGroupAlsoPercData: boolean = False; const pBillIdlist: TList = nil): AStr;
  var
    i: integer;
    strl, billstrl, pFieldTouse: string;
    pQStrList: TAStrList;
    pGrpAlsoByVat: boolean;
  begin
    strl := '';
    billstrl := '';

    if assigned(pCustlist) then
      for i := 0 to pCustlist.Count - 1 do
      begin
        if strl <> '' then
          strl := strl + ',';
        strl := strl + IntToStr(integer(pCustlist.Items[i]));
      end;




    // strl := IfThen(strl = '', '-1', strl);
    pGrpAlsoByVat := (pType = estbk_Types._CItemSaleBill) or pGroupAlsoPercData;

    try
      // --
      pQStrList := TAStrList.Create;
      with pQStrList do
      begin
        //Add('SELECT client_id,c.name,c.lastname,c.regnr,bl.bill_number,bl.bill_date,bl.credit_bill_id ' + IfThen(pGrpAlsoByVat, ',v.perc') +',SUM(ABS(vtlsum)) as blsum, SUM(vatsum) as vsum');
        Add('SELECT client_id,c.name,c.lastname,c.regnr,bl.bill_number,bl.bill_date,bl.credit_bill_id ' +
          IfThen(pGrpAlsoByVat, ',v.perc') + ',SUM(vtlsum) + MAX(roundsum) as blsum,' +
          // meil arveread ju kontode kaupa grupeeritud, tuleb kokku lüüa;
          ' MAX(vatsum) as vsum');
        // aga käibemaksu summa küsitakse konkreetselt arvelt endalt; mitte SUM vaid MAX krdi pudru ja kapsad; SUM(vatsum) as vsum
        Add('FROM');


        Add('(SELECT  DISTINCT b.bill_number,b.bill_type,b.bill_date,r.transdate,' + 'b.client_id,b.credit_bill_id,v.id as vat_id,b.roundsum,');


        // Et arvesummad saaks baasvaluutas !
        Add('(SELECT SUM(a.rec_sum)');
        Add('FROM accounting_records a');
        Add('WHERE a.account_id = b0.item_account_id');
        Add('  AND a.accounting_register_id = r.id');
        Add('  AND a.rec_deleted = ''f'') as vtlsum,'); // b0.total - b0.vat_rsum


        // käibemaks ka baasvaluutas
        Add('(SELECT SUM(a.rec_sum)');
        Add('FROM accounting_records a');
        pFieldTouse := 'v.vat_account_id_s';


        if (pType = estbk_Types._CItemPurchBill) then
          pFieldTouse := 'v.vat_account_id_i'
        else
          pFieldTouse := 'v.vat_account_id_s';

        Add('WHERE a.account_id = ' + pFieldTouse);
        Add('  AND a.accounting_register_id = r.id');
        Add('  AND a.rec_deleted = ''f'') as vatsum'); // b0.vat_rsum

        Add('FROM bills b');
        Add('INNER JOIN bill_lines b0 ON');
        Add('b0.bill_id=b.id');
        Add('INNER JOIN vat v ON');
        Add('v.id = b0.vat_id AND v.perc IN (9,20)'); // -- ei tohi hardcoded olla !!!!!!!!!!!!
        Add('INNER JOIN accounting_register r ON');
        Add('r.id = b.accounting_register_id AND r.type_ IN (''P'',''B'',''K'')');
        Add('WHERE  b.status NOT LIKE ''%D%''');
        Add('   AND b.rec_deleted = ''f''');

        if assigned(pBillIdlist) and (pBillIdlist.Count > 0) then
        begin
          for i := 0 to pBillIdlist.Count - 1 do
          begin
            if billstrl <> '' then
              billstrl := billstrl + ',';
            billstrl := billstrl + IntToStr(integer(pBillIdlist.Items[i]));
          end;

          // ---
          Add('   AND b.id IN (' + billstrl + ')');
        end;

        if (pType <> '') and (billstrl = '') then
          Add('   AND b.bill_type = ' + QuotedStr(pType));

        // 09.11.2014 Ingmar
        Add(format('  AND b.company_id = %d', [estbk_globvars.glob_company_id]));
        Add(format('  AND b.bill_date BETWEEN %s AND %s', [quotedStr(formatdatetime('yyyy-mm-dd', pVatPerStart)),
          quotedStr(formatdatetime('yyyy-mm-dd', pVatPerEnd))]));
        Add('   AND b.status LIKE ''%C%'') as bl');

        Add('INNER JOIN client c ON');
        Add('      c.id = bl.client_id');

        if strl <> '' then
          Add('  AND c.id IN (' + strl + ')');

        Add('  AND ((c.regnr <> '''') or (c.ctype = ''L''))');
        Add('INNER JOIN vat v ON');
        Add('v.id = bl.vat_id');


        Add('GROUP BY client_id,c.name,c.lastname,c.regnr,bl.bill_number,bl.bill_date,bl.credit_bill_id' + IfThen(pGrpAlsoByVat, ',v.perc'));
        Add('ORDER BY c.name,c.lastname,bill_date,bill_number' + IfThen(pGrpAlsoByVat, ',perc'));

        // ---
        Result := Text;
      end;

    finally
      FreeAndNil(pQStrList);
    end;
  end;

  // üldine; nimekiri
  function _buildQueryCommon(const pType: AStr = ''; const pCreditBillSourceType: AStr = ''): AStr;
  var
    pQStrList: TAStrList;
  begin
    try
      pQStrList := TAStrList.Create;
      with pQStrList do
      begin
        Add('SELECT client_id,c.name,c.lastname,c.regnr,bill_type,SUM(vtlsum) as blsum');
        Add('FROM');
        Add('(');

        Add(' SELECT  DISTINCT b.bill_number,b.bill_type,b.bill_date,r.transdate,b.client_id,b.credit_bill_id,');
        Add('(SELECT SUM(a.rec_sum)');
        Add('FROM accounting_records a');
        Add('WHERE a.account_id = b0.item_account_id');
        Add('  AND a.accounting_register_id = r.id');
        Add('  AND a.rec_deleted = ''f'') as vtlsum');
        Add('FROM bills b');
        Add('INNER JOIN bill_lines b0 ON');
        Add('b0.bill_id=b.id');
        Add('INNER JOIN vat v ON');
        Add('v.id = b0.vat_id AND v.perc IN (9,20)'); // -- hardcoded !?!
        Add('INNER JOIN accounting_register r ON');
        Add('r.id = b.accounting_register_id AND r.type_ IN (''P'',''B'',''K'')');
        Add('WHERE b.status NOT LIKE ''%D%'' ');
        Add('  AND b.rec_deleted = ''f'' ');
        Add('  AND b.status LIKE ''%C%'' ');

        Add(format('  AND b.bill_date BETWEEN %s AND %s', [quotedStr(formatdatetime('yyyy-mm-dd', pVatPerStart)),
          quotedStr(formatdatetime('yyyy-mm-dd', pVatPerEnd))]));
        Add(format('  AND b.company_id = %d', [estbk_globvars.glob_company_id]));
        if (pType <> '') then
          Add('  AND b.bill_type=' + quotedStr(pType));

        // 08.11.2014 Ingmar
        if (pType = estbk_types._CItemCreditBill) and (pCreditBillSourceType <> '') then
          Add(' AND EXISTS(SELECT b1.id FROM bills b1 WHERE b1.credit_bill_id = b.id  AND b.rec_deleted=''f'' AND b.status LIKE ''%C%%'')');


        Add(') as bl');
        Add('LEFT OUTER JOIN client c ON');
        Add('c.id = bl.client_id');
        Add('GROUP BY client_id,c.name,c.lastname,c.regnr,bill_type');


        Add(format('HAVING SUM(ABS(vtlsum))>=%d', [CBillSumPer]));

        // ---
        Result := Text;
      end;

    finally
      FreeAndNil(pQStrList);
    end;
  end;

  // ootan genericsi ! TList<Integer>   TList<Integer>.Create;
  procedure _getCustBillSumZ1000(const pCustList: TList; const pType: AStr = ''; const pCreditBillSourceType: AStr = ''); // ptype = arve tüüp
  var
    _IntAsPtr: Pointer;
  begin

    with Self.FQuery, SQL do
      try
        Close;
        Clear;
        Add(_buildQueryCommon(pType, pCreditBillSourceType));
        Open;

        while not EOF do
        begin
          _IntAsPtr := Pointer(FieldByName('client_id').AsInteger);
          if pCustList.IndexOf(pCustList) = -1 then
            pCustList.Add(_IntAsPtr);
          Next;
        end; // --

      finally
        Close;
        Clear;
      end;
  end;

  // http://www.emta.ee/public/vormid/maksudeklaratsioonid/KMD/2014/vatdeclaration_example.xml
  function _getSaleAnnex(const pType: AStr = ''; const pCustList: TList = nil): AStr;
  var
    pXMLList: TAStrList;
    pCredBillIds: TList;

    _IntAsPtr: Pointer;
    pt: double;
  begin
    Result := '';

    pt := 0.00;
    // ---
    with Self.FQuery, SQL do
      try
        pXMLList := TAStrList.Create;
        pCredBillIds := TList.Create;

        Close;
        Clear;
        Add(_buildQueryDetailed(pType, pCustList));
        // dmodule.tempQuery.SQL.SaveToFile('c:\test.txt');
        Open;
        while not EOF do
        begin

          pXMLList.add('<saleLine>');
          // <!-- KMD INF A osa - müügiarve rida [0..n]
          // Part A of VAT INF return - Line of sales invoice [0..n]  -->

          // Tehingupartneri registri- või isikukood (KMD INF A osa  veerg 2).
          pXMLList.Add(format('<buyerRegCode>%s</buyerRegCode>', [_xs(FieldByName('regnr').AsString)]));
          // Tehingupartneri nimi (KMD INF A osa veerg 3). Peab olema täidetud, kui on täitmata tehingupartneri registri- või isikukood.
          pXMLList.Add(format('<buyerName>%s</buyerName>', [trim(_xs(FieldByName('name').AsString + ' ' + FieldByName('lastname').AsString))]));
          // Arve number (KMD INF A osa veerg 4).
          pXMLList.Add(format('<invoiceNumber>%s</invoiceNumber>', [_xs(FieldByName('bill_number').AsString)]));
          // Arve kuupäev pp.kk.aaaa (KMD INF A osa veerg 5). aaaa-kk-pp
          pXMLList.Add(format('<invoiceDate>%s</invoiceDate>', [_xs(formatDatetime('yyyy-mm-dd', FieldByName('bill_date').AsDateTime))]));
          // Kohustuslik. Arve kogusumma ilma käibemaksuta (KMD INF A osa veerg 6).
          pXMLList.Add(format('<invoiceSum>%s</invoiceSum>', [_xf(FieldByName('blsum').AsFloat)])); // arve summa ilma KM'ta
          // Kohustuslik. Maksumäär (KMD INF A osa veerg 7). Klassifikaator TAX_RATE_SALES.
          pXMLList.Add(format('<taxRate>%s</taxRate>', [_xf(FieldByName('perc').AsFloat, False, True)]));



          // <!-- Arvel märgitud kauba ja teenuse maksustatav väärtus  (KMD INF A osa veerg 8). Täidab ainult kassapõhine käibemaksukohustuslane.
          // <invoiceSumForRate>400.00</invoiceSumForRate>
          // Maksustamisperioodil KMD lahtris 1 või 2 kajastatud maksustatav käive (KMD INF A osa veerg 9).

          // <sumForRateInPeriod>400.00</sumForRateInPeriod>
          pXMLList.Add(format('<sumForRateInPeriod>%s</sumForRateInPeriod>', [_xf(FieldByName('vsum').AsFloat)]));

          //  Erisuse kood (KMD INF A osa veerg 10). Klassifikaator COMMENT_SALES.
          // <comments>01</comments>
          pXMLList.add('</saleLine>');


          if FieldByName('credit_bill_id').AsInteger > 0 then
          begin
            _IntAsPtr := Pointer(FieldByName('credit_bill_id').AsInteger);
            if pCredBillIds.IndexOf(pCustList) = -1 then
              pCredBillIds.Add(_IntAsPtr);
          end;



          Next;
        end; // --


        if pCredBillIds.Count > 0 then
        begin
          Close;
          Clear;
          Add(_buildQueryDetailed('', nil, True, pCredBillIds));
          Open;
          while not EOF do
          begin
            pXMLList.add('<saleLine>');
            // <!-- KMD INF A osa - müügiarve rida [0..n]
            // Part A of VAT INF return - Line of sales invoice [0..n]  -->

            // Tehingupartneri registri- või isikukood (KMD INF A osa  veerg 2).
            pXMLList.Add(format('<buyerRegCode>%s</buyerRegCode>', [_xs(FieldByName('regnr').AsString)]));
            // Tehingupartneri nimi (KMD INF A osa veerg 3). Peab olema täidetud, kui on täitmata tehingupartneri registri- või isikukood.
            pXMLList.Add(format('<buyerName>%s</buyerName>', [trim(_xs(FieldByName('name').AsString + ' ' + FieldByName('lastname').AsString))]));
            // Arve number (KMD INF A osa veerg 4).
            pXMLList.Add(format('<invoiceNumber>%s</invoiceNumber>', [_xs(FieldByName('bill_number').AsString)]));
            // Arve kuupäev pp.kk.aaaa (KMD INF A osa veerg 5). aaaa-kk-pp
            pXMLList.Add(format('<invoiceDate>%s</invoiceDate>', [_xs(formatDatetime('yyyy-mm-dd', FieldByName('bill_date').AsDateTime))]));
            // Kohustuslik. Arve kogusumma ilma käibemaksuta (KMD INF A osa veerg 6).
            //           pXMLList.Add(format('<invoiceSumVat>%s</invoiceSumVat>', [_xf(FieldByname('blsum').AsFloat + FieldByname('vsum').AsFloat)])); // arve summa ilma KM'ta

            pXMLList.Add(format('<invoiceSum>%s</invoiceSum>', [_xf(-FieldByName('blsum').AsFloat)])); // arve summa ilma KM'ta
            // Kohustuslik. Maksumäär (KMD INF A osa veerg 7). Klassifikaator TAX_RATE_SALES.
            pXMLList.Add(format('<taxRate>%s</taxRate>', [_xf(FieldByName('perc').AsFloat, False, True)]));



            // <!-- Arvel märgitud kauba ja teenuse maksustatav väärtus  (KMD INF A osa veerg 8). Täidab ainult kassapõhine käibemaksukohustuslane.
            // <invoiceSumForRate>400.00</invoiceSumForRate>
            // Maksustamisperioodil KMD lahtris 1 või 2 kajastatud maksustatav käive (KMD INF A osa veerg 9).

            // <sumForRateInPeriod>400.00</sumForRateInPeriod>
            pXMLList.Add(format('<sumForRateInPeriod>%s</sumForRateInPeriod>', [_xf(FieldByName('vsum').AsFloat)]));

            //  Erisuse kood (KMD INF A osa veerg 10). Klassifikaator COMMENT_SALES.
            // <comments>01</comments>
            pXMLList.add('</saleLine>');
            Next;
          end;
        end;

      finally
        Close;
        Clear;

        Result := pXMLList.Text;

        FreeAndNil(pCredBillIds);
        FreeAndNil(pXMLList);
      end;
  end;

  function _getPurchAnnex(const pType: AStr = ''; const pCustList: TList = nil): AStr;
  var
    pXMLList: TAStrList;
    pCredBillIds: TList;
    _IntAsPtr: Pointer;

  begin
    Result := '';

    // ---
    with Self.FQuery, SQL do
      try
        pXMLList := TAStrList.Create;
        pCredBillIds := TList.Create;

        Close;
        Clear;
        Add(_buildQueryDetailed(pType, pCustList));
        Open;

        // sql.SaveToFile('c:\test.txt');

        while not EOF do
        begin
          pXMLList.add('<purchaseLine>');
          // <!-- KMD INF B osa, käibemaksukohustuslasel [0..1], käibemaksugruppidel [0..n]
          // Part B of VAT INF return, taxable person [0..1], value added tax group [0..n]  -->
          // Tehingupartneri registri- või isikukood (KMD INF B osa  veerg 2).
          pXMLList.add(format('<sellerRegCode>%s</sellerRegCode>', [_xs(FieldByName('regnr').AsString)]));
          //  Tehingupartneri nimi (KMD INF B osa veerg 3). Peab olema täidetud, kui on täitmata tehingupartneri registri- või isikukood.
          pXMLList.add(format('<sellerName>%s</sellerName>', [trim(_xs(FieldByName('name').AsString + ' ' + FieldByName('lastname').AsString))]));
          //  Arve number (KMD INF B osa veerg 4).
          pXMLList.Add(format('<invoiceNumber>%s</invoiceNumber>', [_xs(FieldByName('bill_number').AsString)]));
          //  Arve kuupäev pp.kk.aaaa (KMD INF B osa veerg 5). aaaa-kk-pp
          pXMLList.Add(format('<invoiceDate>%s</invoiceDate>', [_xs(formatDatetime('yyyy-mm-dd', FieldByName('bill_date').AsDateTime))]));
          //  Kohustuslik. Arve kogusumma koos käibemaksuga (KMD INF B osa veerg 6).
          pXMLList.Add(format('<invoiceSumVat>%s</invoiceSumVat>', [_xf(FieldByName('blsum').AsFloat + FieldByName('vsum').AsFloat)]));
          // arve summa ilma KM'ta

          // <vatSum>200.00</vatSum>
          //  Arvel märgitud käibemaksusumma (KMD INF B osa veerg 7). Täidab ainult kassapõhine käibemaksukohustuslane.
          // Kohustuslik. Maksustamisperioodil KMD lahtris 5 kajastatud sisendkäibemaksusumma (KMD INF B osa veerg 8).
          // <vatInPeriod>200.00</vatInPeriod>
          pXMLList.Add(format('<vatInPeriod>%s</vatInPeriod>', [_xf(FieldByName('vsum').AsFloat)])); // arve summa ilma KM'ta
          pXMLList.add('</purchaseLine>');


          if FieldByName('credit_bill_id').AsInteger > 0 then
          begin
            _IntAsPtr := Pointer(FieldByName('credit_bill_id').AsInteger);
            if pCredBillIds.IndexOf(pCustList) = -1 then
              pCredBillIds.Add(_IntAsPtr);
          end; // --

          Next;
        end; // --

        // ja kreeditarve osa bang
        if pCredBillIds.Count > 0 then
        begin
          Close;
          Clear;
          Add(_buildQueryDetailed('', nil, False, pCredBillIds));
          Open;

          //dmodule.tempQuery.SQL.SaveToFile('c:\test.txt');

          while not EOF do
          begin
            pXMLList.add('<purchaseLine>');
            // <!-- KMD INF B osa, käibemaksukohustuslasel [0..1], käibemaksugruppidel [0..n]
            // Part B of VAT INF return, taxable person [0..1], value added tax group [0..n]  -->
            // Tehingupartneri registri- või isikukood (KMD INF B osa  veerg 2).
            pXMLList.add(format('<sellerRegCode>%s</sellerRegCode>', [_xs(FieldByName('regnr').AsString)]));
            //  Tehingupartneri nimi (KMD INF B osa veerg 3). Peab olema täidetud, kui on täitmata tehingupartneri registri- või isikukood.
            pXMLList.add(format('<sellerName>%s</sellerName>', [trim(_xs(FieldByName('name').AsString + ' ' + FieldByName('lastname').AsString))]));
            //  Arve number (KMD INF B osa veerg 4).
            pXMLList.Add(format('<invoiceNumber>%s</invoiceNumber>', [_xs(FieldByName('bill_number').AsString)]));
            //  Arve kuupäev pp.kk.aaaa (KMD INF B osa veerg 5). aaaa-kk-pp
            pXMLList.Add(format('<invoiceDate>%s</invoiceDate>', [_xs(formatDatetime('yyyy-mm-dd', FieldByName('bill_date').AsDateTime))]));
            //  Kohustuslik. Arve kogusumma koos käibemaksuga (KMD INF B osa veerg 6).
            pXMLList.Add(format('<invoiceSumVat>%s</invoiceSumVat>', [_xf(-FieldByName('blsum').AsFloat + FieldByName('vsum').AsFloat)]));
            // arve summa ilma KM'ta

            // <vatSum>200.00</vatSum>
            //  Arvel märgitud käibemaksusumma (KMD INF B osa veerg 7). Täidab ainult kassapõhine käibemaksukohustuslane.
            // Kohustuslik. Maksustamisperioodil KMD lahtris 5 kajastatud sisendkäibemaksusumma (KMD INF B osa veerg 8).
            // <vatInPeriod>200.00</vatInPeriod>
            pXMLList.Add(format('<vatInPeriod>%s</vatInPeriod>', [_xf(FieldByName('vsum').AsFloat)])); // arve summa ilma KM'ta
            pXMLList.add('</purchaseLine>');

            Next;
          end;
        end;




      finally
        Result := pXMLList.Text;
        FreeAndNil(pXMLList);
        FreeAndNil(pCredBillIds);
        // --
        Close;
        Clear;
      end;
  end;

var
  ps: TAStrList;
  pRegCode: AStr;
  pSalebillCnt: integer;
  pPurchbillCnt: integer;

  pSumPartnerSales: boolean;
  pSumPerPartnerPurchases: boolean;

  // pVATPercSums : TAStrList;
  i: integer;
  p1000EurCustSales: TList;
  p1000EurCustPurch: TList;
  p1000EurCustCred: TList;
  pRez: AStr;
  pSaleAnnexStr: AStr;
  pPurchasesStr: AStr;
  _pItemPtr: Pointer;
begin

  try

    ps := TAStrList.Create();

    p1000EurCustSales := TList.Create;
    p1000EurCustPurch := TList.Create;
    p1000EurCustCred := TList.Create;


    // pVATPercSums := TAStrList.Create();



    // @
    pSalebillCnt := 0;
    pPurchbillCnt := 0;
    pSumPartnerSales := False;
    pSumPerPartnerPurchases := False;

    // #
   (*
   pFixedAssetsVat := 0.00;
   pEUSupplyInclGoodsAndServicesZeroVat := 0.00;
   pEUSupplyGoodsZeroVat := 0.00;
   pExportZeroVat := 0.00;
   pSalePassengersWithReturnVat := 0.00;
   pInputVatTotal  := 0.00;
   pImportVat := 0.00;
   pEUAcquisitionsGoodsAndServicesTotal := 0.00;
   pEUAcquisitionsGoods := 0.00;
   pAcquisitionOtherGoodsAndServicesTotal := 0.00;
   pAcquisitionImmovablesAndScrapMetalAndGold := 0.00;
   pSupplyExemptFromTax := 0.00;
   pSupplySpecialArrangements := 0.00;

   pAdjustmentsMinus := 0.00;
   pAdjustmentsPlus := 0.00;
   *)


    // kui kliendi krediitarvete summa on suurem kui -1000, siis peab kõik tema teised arved ka kaasa panema
    p1000EurCustCred.Clear;
    _getCustBillSumZ1000(p1000EurCustCred, estbk_types._CItemCreditBill, estbk_types._CItemSaleBill);
    // eelselekteerime välja kliendid, kelle arvete kogusumma ületab 1000 eurot
    _getCustBillSumZ1000(p1000EurCustSales, estbk_types._CItemSaleBill);
    pSalebillCnt := p1000EurCustSales.Count; // --



    for i := 0 to p1000EurCustCred.Count - 1 do
    begin
      _pItemPtr := p1000EurCustCred.Items[i];
      if p1000EurCustSales.IndexOf(_pItemPtr) = -1 then
        p1000EurCustSales.Add(_pItemPtr);
    end;


    p1000EurCustCred.Clear;
    _getCustBillSumZ1000(p1000EurCustCred, estbk_types._CItemCreditBill, estbk_types._CItemPurchBill);
    _getCustBillSumZ1000(p1000EurCustPurch, estbk_types._CItemPurchBill);
    pPurchbillCnt := p1000EurCustPurch.Count; // --


    for i := 0 to p1000EurCustCred.Count - 1 do
    begin
      _pItemPtr := p1000EurCustCred.Items[i];
      if p1000EurCustPurch.IndexOf(_pItemPtr) = -1 then
        p1000EurCustPurch.Add(_pItemPtr);
    end;


    // -- väldime võimalikke probleeme
    if p1000EurCustSales.Count = 0 then
      p1000EurCustSales.Add(Pointer(0));

    if p1000EurCustPurch.Count = 0 then
      p1000EurCustPurch.Add(Pointer(0));




    // konfist ? mitte hardcoded ?
   (*
   pVATPercSums.Add('0=0');
   pVATPercSums.Add('9=0');
   pVATPercSums.Add('20=0');

   pVATPercSums.Add('*0=0');
   pVATPercSums.Add('*9=0');
   pVATPercSums.Add('*20=0');
   *)

    pSaleAnnexStr := _getSaleAnnex(estbk_types._CItemSaleBill, p1000EurCustSales);
    pPurchasesStr := _getPurchAnnex(estbk_types._CItemPurchBill, p1000EurCustPurch);


    pRegCode := estbk_globvars.glob_currcompregcode;

    with ps do
    begin
      add('<?xml version="1.0" encoding="UTF-8"?>');
      add('<vatDeclaration>');

      add('<taxPayerRegCode>' + pRegCode + '</taxPayerRegCode>'); // Kohustuslik. Maksukohustuslase registri- või isikukood või mitteresidendi kood.
      add('<submitterPersonCode></submitterPersonCode>'); // Kohustuslik kui esitada üle masin-masin liidese. Esitaja isikukood.

      add(format('<year>%d</year>', [pYear])); // Kohustuslik. Aasta
      add(format('<month>%d</month>', [pMonth])); // Kohustuslik. Kuu

      add('<declarationType>1</declarationType>');
      // Kohustuslik. KMD ja KMD INF’i esitamine tava või pankrotiperioodi kohta. Väärtused 1-2. 1 - Tavaperiood, 2 - Pankrotiperiood

      add('<declarationBody>');

     (*
     Kohustuslik. Müügitehingud puuduvad. Välja väärtused on TRUE või FALSE. Väärtustatakse TRUE, kui piirmäära ületavad müügitehingud
                  perioodis puuduvad - sel juhul salesLine osa täita ei saa.  Kui on deklareeritavaid tehinguid, siis tuleb märkida FALSE.
                  Väli täidetakse maksukohustuslase või käibemaksugrupi esindusisiku kohta. Piiratud KMK peab märkima väärtuseks alati TRUE
     *)

      add('<noSales>' + IfThen(pSalebillCnt < 1, 'true', 'false') + '</noSales>');

     (*
     Kohustuslik. Ostutehingud puuduvad. Välja väärtused on TRUE või FALSE. Väärtustatakse TRUE, kui piirmäära ületavad ostutehingud
                  perioodis puuduvad - sel juhul purchaseLine osa täita ei saa. Kui on deklareeritavaid tehinguid, siis tuleb märkida FALSE.
                  Väli täidetakse maksukohustuslase või käibemaksugrupi esindusisiku kohta. Piiratud KMK ja Mitte KMK peavad märkima väärtuseks alati TRUE.
      *)

      add('<noPurchases>' + IfThen(pPurchbillCnt < 1, 'true', 'false') + '</noPurchases>');

     (*
     Kohustuslik. KMD INF A osas andmete esitamine summeeritult tehingupartnerite lõikes. Välja väärtused on TRUE või FALSE.
             Kui välja väärtus on TRUE, siis A osas arve numbri ja kuupäeva märkimine ei ole kohustuslik. Kui andmed esitatakse  mitte summeeritult ehk arvete lõikes,
             siis tuleb väärtuseks märkida FALSE. Väli täidetakse maksukohustuslase või käibemaksugrupi esindusisiku kohta.
     *)

      add('<sumPerPartnerSales>' + IfThen(pSumPartnerSales, 'true', 'false') + '</sumPerPartnerSales>');

     (*
     Kohustuslik. KMD INF B osas andmete esitamine summeeritult tehingupartnerite lõikes. Välja väärtused on TRUE või FALSE.
             Kui välja väärtus on TRUE, siis B osas arve numbri ja kuupäeva märkimine ei ole kohustuslik. Kui andmed esitatakse mitte summeeritult ehk arvete lõikes,
             siis tuleb väärtuseks märkida FALSE. Väli täidetakse maksukohustuslase või käibemaksugrupi esindusisiku kohta.
     *)

      add('<sumPerPartnerPurchases>' + IfThen(pSumPerPartnerPurchases, 'true', 'false') + '</sumPerPartnerPurchases>');

(*
     i := pVATPercSums.IndexOfName('*0');
     // omatarbimine 0% absurd
 if (i >= 0) then
     pVATPercSums.Delete(i);

     for i := 0 to pVATPercSums.Count - 1 do
     begin
        // <transactions20>90000.00</transactions20>
        // 20% määraga maksustatavad toimingud ja tehingud (KMD rida 1)
        // <transactions9>10000.00</transactions9>
        // 9% määraga maksustatavad toimingud ja tehingud (KMD rida 2)
     if copy(pVATPercSums.Names[i], 1, 1) = '*' then
       begin
        // <selfSupply20>1000.00</selfSupply20>
        //  20% määraga maksustatav kauba või teenuse omatarve (KMD rida 1.1)
        // <selfSupply9>1000.00</selfSupply9>
        // 9% määraga maksustatav kauba või teenuse omatarve (KMD rida 2.1)
       add('<selfSupply' + copy(pVATPercSums.Names[i], 2 , 6) + '>' + _xf(StrtoFloatDef(pVATPercSums.ValueFromIndex[i], 0.00)) +'</selfSupply' + copy(pVATPercSums.Names[i] ,2 ,6) + '>');
       end else
     if StrToIntDef(pVATPercSums.Names[i],0) = 0 then
        add('<transactionsZeroVat>' + pVATPercSums.ValueFromIndex[i] +'</transactionsZeroVat>')
     else
        add('<transactions' + pVATPercSums.Names[i] + '>' + _xf(StrtoFloatDef(pVATPercSums.ValueFromIndex[i], 0.00)) + '</transactions' + pVATPercSums.Names[i] + '>');
     end;
*)



      add('<transactions20>' + _xf(pVatVars.p1x_Transactions20) + '</transactions20>');
      // http://www.stiigo.com/forum/viewtopic.php?f=2&t=4&start=120#p19413
      // add('<selfSupply20>' + _xf(pVatVars.p11_SelfSupply20) + '</selfSupply20>');
      add('<transactions9>' + _xf(pVatVars.p2x_Transactions9) + '</transactions9>');
      // http://www.stiigo.com/forum/viewtopic.php?f=2&t=4&start=120#p19413
      // add('<selfSupply9>' + _xf(pVatVars.p21_SelfSupply9) + '</selfSupply9>');

      add('<transactionsZeroVat>' + _xf(pVatVars.p3x_transactionsZeroVat) + '</transactionsZeroVat>');



     (*
      Kauba ühendusesisene käive ja
      teise liikmesriigi maksukohustuslasele/piiratud maksukohustuslasele osutatud teenuste käive kokku (KMD rida 3.1)
     *)
      add('<euSupplyInclGoodsAndServicesZeroVat>' + _xf(pVatVars.p31_EUSupplyInclGoodsAndServicesZeroVat) + '</euSupplyInclGoodsAndServicesZeroVat>');

     (*
      Kauba ühendusesisene käive (KMD rida 3.1.1)
      *)
      add('<euSupplyGoodsZeroVat>' + _xf(pVatVars.p311_EUSupplyGoodsZeroVat) + '</euSupplyGoodsZeroVat>');

     (*
      Kauba eksport (KMD rida 3.2)
     *)
      add('<exportZeroVat>' + _xf(pVatVars.p32_ExportZeroVat) + '</exportZeroVat>');

     (*
      Käibemaksutagastusega müük reisijale (KMD rida 3.2.1)
     *)
      add('<salePassengersWithReturnVat>' + _xf(pVatVars.p321_SalePassengersWithReturnVat) + '</salePassengersWithReturnVat>');

     (*
      Kokku sisendkäibemaksusumma, mis on seadusega lubatud maha arvata (KMD rida 5)
     *)
      add('<inputVatTotal>' + _xf(pVatVars.p5x_InputVatTotal) + '</inputVatTotal>');

     (*
      Impordilt tasutud või tasumisele kuuluv käibemaks (KMD rida 5.1)
     *)

      add('<importVat>' + _xf(pVatVars.p51_ImportVat) + '</importVat>');

     (*
      Põhivara soetamiselt tasutud või tasumisele kuuluv käibemaks (KMD rida 5.2)
     *)

      add('<fixedAssetsVat>' + _xf(pVatVars.p52_FixedAssetsVat) + '</fixedAssetsVat>');

     (*
     Kauba ühendusesisene soetamine ja teise liikmesriigi maksukohustuslaselt saadud teenused kokku (KMD rida 6)
     *)

      add('<euAcquisitionsGoodsAndServicesTotal>' + _xf(pVatVars.p6x_EUAcquisitionsGoodsAndServicesTotal) + '</euAcquisitionsGoodsAndServicesTotal>');

     (*
      Kauba ühendusesisene soetamine (KMD rida 6.1)
     *)
      add('<euAcquisitionsGoods>' + _xf(pVatVars.p61_EUAcquisitionsGoods) + '</euAcquisitionsGoods>');

     (*
     Muu kauba soetamine ja teenuse saamine (KMD rida 7)
     *)
      add('<acquisitionOtherGoodsAndServicesTotal>' + _xf(pVatVars.p7x_AcquisitionOtherGoodsAndServicesTotal) +
        '</acquisitionOtherGoodsAndServicesTotal>');

     (*
     Erikorra alusel maksustatava kinnisasja, metallijäätmete ja väärismetalli  soetamine(KMS § 41^1) (KMD rida 7.1)
     *)
      add('<acquisitionImmovablesAndScrapMetalAndGold>' + _xf(pVatVars.p71_AcquisitionImmovablesAndScrapMetalAndGold) +
        '</acquisitionImmovablesAndScrapMetalAndGold>');

     (*
     Maksuvaba käive (KMD rida 8)
     *)
      add('<supplyExemptFromTax>' + _xf(pVatVars.p8_SupplyExemptFromTax) + '</supplyExemptFromTax>');

     (*
      Erikorra alusel maksustatava kinnisasja, metallijäätmete ja väärismetalli  käive (KMS § 41^1) ning teises liikmesriigis
      paigaldatava või kokkupandava kauba maksustatav väärtus (KMD rida 9)
     *)

      add('<supplySpecialArrangements>' + _xf(pVatVars.p9_SupplySpecialArrangements) + '</supplySpecialArrangements>');

     (*
     Täpsustused (+) (KMD rida 10)
     *)

      add('<adjustmentsPlus>' + _xf(pVatVars.p10_AdjustmentsMinus) + '</adjustmentsPlus>');

     (*
     Täpsustused (-) (KMD rida 11)
     *)

      add('<adjustmentsMinus>' + _xf(pVatVars.p11_AdjustmentsPlus) + '</adjustmentsMinus>');

      add('</declarationBody>');




      // --- doQuery
      // pRez := _buildQueryDetailed(estbk_types._CItemSaleBill, p1000EurCustSales);
      // @@ koostame siis arveread; vaatame siis välja kliendid, kelle arve summa tuli perioodis suurem, kui 1000
      add('<salesAnnex>');
      add(pSaleAnnexStr);
      add('</salesAnnex>');


      // pRez := _buildQueryDetailed(estbk_types._CItemPurchBill, p1000EurCustPurch);
      add('<purchasesAnnex>');
      add(pPurchasesStr);
      add('</purchasesAnnex>');


      // pRez := _buildQueryDetailed(estbk_types._CItemCreditBill, p1000EurCustCred);
      add('</vatDeclaration>');
    end;
  finally
    Result := ps.Text;


    FreeAndNil(ps);

    // ---
    FreeAndNil(p1000EurCustSales);
    FreeAndNil(p1000EurCustPurch);
    // FreeAndNil(p1000EurCustCred);
  end;
  // @
end;


end.
