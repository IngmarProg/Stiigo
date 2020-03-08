unit estbk_ebill;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface

uses
  Classes, SysUtils, DOM, ZConnection, ZDataset, ZSqlUpdate,
  XMLRead, XMLWrite, XMLCfg, XMLUtils, strutils,
  estbk_globvars, estbk_types, estbk_strmsg, estbk_sqlclientcollection,
  estbk_lib_commoncls, estbk_utilities
  {$IFNDEF NOGUI}, Dialogs, estbk_clientdatamodule{$ENDIF};

// @@
function _generateEBill(const pBillID: integer{$IFDEF NOGUI}; const pExtQuery: TZquery{$ENDIF}): AStr;

implementation
// ---
procedure loadBillLines(const pQry: TZquery; const pBillId: integer; const pBillLines: TCollection);
var
  pItem: TvMergedBillLines;
begin
  with pQry, SQL do
    try
      Close;
      Clear;
      // --
      add(estbk_sqlclientcollection._SQLSelectBillLines());
      paramByname('bill_id').AsInteger := pBillId;
      Open;
      while not EOF do
      begin
        // lühendatud variant !
        pItem := pBillLines.Add as TvMergedBillLines;
        pItem.FArtCode := FieldByName('code').AsString;
        pItem.FArtDescr := trim(FieldByName('artname').AsString);
        if pItem.FArtDescr = '' then
          pItem.FArtDescr := trim(FieldByName('descr2').AsString);
        pItem.FArtOrigDescr := pItem.FArtDescr;

        // @@@
        pItem.FUnit := FieldByName('artunit').AsString;
        pItem.FQty := FieldByName('quantity').AsFloat;
        pItem.FArtSalepr := FieldByName('total').AsFloat; // siin hoian totali infot !
        pItem.FPrice := FieldByName('item_price').AsFloat;

        pItem.FCalcLineVatSum := FieldByName('vat_rsum').AsFloat;
        pItem.FVatPerc := FieldByName('vatperc').AsFloat;
        pItem.FVatID := FieldByName('vat_id').AsInteger;
        // pItem.FVatLongName := fieldByname('artunit').AsString;

        Next;
      end;
    finally
      Close;
      Clear;
    end;
end;

{
& &amp;
’ &apos;
> &gt;
< &lt;
“ &quot;
}

function _sx(const pxmlstr: AStr; const pmaxLen: integer = 1024): AStr; // TODO panna pikkused paika vastavalt XSD schemale !
begin
  Result := pxmlstr;
  Result := stringreplace(Result, '&', '&amp;', [rfReplaceAll]);
  Result := stringreplace(Result, '>', '&gt;', [rfReplaceAll]);
  Result := stringreplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := stringreplace(Result, '"', '&quot;', [rfReplaceAll]);
  Result := stringreplace(Result, chr(39), '&quot;', [rfReplaceAll]);

end;

// http://www.pangaliit.ee/images/files/E-arve/e-invoice_ver1_1_est.pdf
// E:\Arved_2012_03_27_10_20_20.xml
function _generateEBill(const pBillID: integer{$IFDEF NOGUI}; const pExtQuery: TZquery{$ENDIF}): AStr;
const
  CHdrSenderId = '';
  CReceiverId = '';
  CPayeeAccountNumber = '';
  CContractId = '';
  CEBillFmt = 'yyyy-mm-dd';
var
  Doc: TXMLDocument;
  Root, Header, Footer, Invoice, InvoiceParties, SellerParty, BuyerParty, InvoiceInformation, InvoiceSumGroup,
  InvoiceItem, InvoiceItemGroup, ItemEntry, ContactData, VAT, Item, TextNode, LegalAddress, MailAddress,
  ItemReserve, PaymentInfo, ItemDetailInfo: TDOMNode;

  pTestMode: boolean;
  pClientId: integer;
  pClientRegCode, pCompPhoneNr, pCompEmail, pCompPostalAddr, pCompCity, pCompPostalCode, pCompCountry,
  pCompMailPostalAddr, pCompMailCity, pCompMailPostalCode, pCompMailCountry: AStr;

  pCustomername, pCustomerregnr, pCustomerVATRegnr, pCustomerPhoneNr, pCustomerEmail, pCustomerPostalAddr,
  pCustomerCity, pCustomerPostalCode, pCustomerCountry: AStr;

  pBilldate, pBillDuedate: TDatetime;
  pBillFineRate: double;
  pBillNr: AStr;
  pBillLines: TCollection;
  pQry: TZQuery;
  // --
  pBillSum: double;
  pBillVATSum: double;
  pBillIncomeSum: double;
  pBillRoundSum: double;
  pBillCurrency: AStr;
  i, j: integer;
  pVATl: TList;
  pVATId: integer;
  pBillLine: TvMergedBillLines;

  pSumBeforeVAT, pVATRate, pVATSum, pCal: double;
  pStr: TStringStream;
  pTest: Textfile;
begin
  try
     {$IFDEF NOGUI}
    pQry := pExtQuery;
     {$ELSE}
    pQry := TZQuery.Create(nil);
    pQry.Connection := estbk_clientdatamodule.dmodule.primConnection;
     {$ENDIF}
    pStr := TStringStream.Create('');
    pBillLines := TCollection.Create(TvMergedBillLines);
    // Create a document
    Doc := TXMLDocument.Create;
    pVATl := TList.Create;

    // teeme lihtandmete eellaadimise
    with pQry, SQL do
      try
        pBilldate := now;
        pBillDuedate := now;
        pBillFineRate := 0.00;
        pBillSum := 0.00;
        pBillVATSum := 0.00;
        pBillIncomeSum := 0.00;
        pBillRoundSum := 0.00;

        pClientId := 0;
        pClientRegCode := '';
        pCompPhoneNr := '';
        pCompEmail := '';
        pCompPostalAddr := '';
        pCompCity := '';
        pCompPostalCode := '';
        pCompCountry := '';
        pCompMailPostalAddr := '';
        pCompMailCity := '';
        pCompMailPostalCode := '';
        pCompMailCountry := '';

        pCustomername := '';
        pCustomerregnr := '';
        pCustomerVATRegnr := '';
        pCustomerPhoneNr := '';
        pCustomerEmail := '';
        pCustomerPostalAddr := '';
        pCustomerCity := '';
        pCustomerPostalCode := '';
        pCustomerCountry := '';

        Close;
        Clear;
        // add(estbk_sqlclientcollection._SQLSelectBillMainRec);
        add(estbk_sqlclientcollection._SQLGetBillMainRec); // meil vaja ka kreeditarve infot !
        paramByname('bill_id').AsInteger := pBillID;
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;
        if EOF then
          raise Exception.Create(estbk_strmsg.SEBillNotFound);

        pClientId := FieldByName('client_id').AsInteger;
        pBilldate := FieldByName('bill_date').AsDateTime;
        pBillDuedate := FieldByName('due_date').AsDateTime;
        pBillFineRate := FieldByName('overdue_perc').AsFloat;
        pBillNr := FieldByName('bill_number').AsString;

        pBillSum := FieldByName('totalsum').AsFloat;
        pBillVATSum := FieldByName('vatsum').AsFloat;
        pBillIncomeSum := FieldByName('incomesum').AsFloat;
        pBillRoundSum := FieldByName('roundsum').AsFloat;
        pBillCurrency := FieldByName('currency').AsString;

        // ---
        // FIRMA
        Close;
        Clear;
        add(estbk_sqlclientcollection._CSQLSelectCompany);
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;
        pCompPhoneNr := FieldByName('phone').AsString;
        pCompEmail := FieldByName('email').AsString;
        pCompPostalAddr := trim(FieldByName('street_name').AsString + ' ' + FieldByName('house_nr').AsString);
        if FieldByName('apartment_nr').AsString <> '' then
          pCompPostalAddr := pCompPostalAddr + ' - ';
        pCompPostalAddr := pCompPostalAddr + FieldByName('apartment_nr').AsString;

        pCompCity := FieldByName('city_name').AsString;
        pCompPostalCode := FieldByName('zipcode').AsString;
        pCompCountry := ''; // TODO

        // hetkel samad ! TODO 2 !!
        pCompMailPostalAddr := pCompPostalAddr;
        pCompMailCity := pCompCity;
        pCompMailPostalCode := pCompPostalCode;
        pCompMailCountry := pCompCountry;

        // ---
        // KLIENT
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id, pClientId));
        Open;

        pCustomername := trim(FieldByName('custname').AsString + ' ' + FieldByName('middlename').AsString + ' ' + FieldByName('lastname').AsString);
        pCustomerregnr := FieldByName('regnr').AsString;
        pCustomerVATRegnr := FieldByName('vatnumber').AsString;
        pCustomerPhoneNr := FieldByName('phone').AsString;
        pCustomerEmail := FieldByName('email').AsString;


        pCustomerPostalAddr := trim(FieldByName('streetname').AsString + ' ' + FieldByName('house_nr').AsString);
        if FieldByName('house_nr').AsString <> '' then
          pCustomerPostalAddr := pCustomerPostalAddr + ' - ';
        pCustomerPostalAddr := pCustomerPostalAddr + FieldByName('house_nr').AsString;

        pCustomerCity := FieldByName('cityname').AsString;
        pCustomerPostalCode := FieldByName('cityname').AsString;
        pCustomerCountry := FieldByName('countrycode').AsString;


      finally
        Close;
        Clear;
      end;

    // ---
    loadBillLines(pQry, pBillID, pBillLines);

    // mitu erinevat KM on ?
    for i := 0 to pBillLines.Count - 1 do
    begin
      pVATId := (pBillLines.Items[i] as TvMergedBillLines).FVatID;
      if (pVATId > 0) and (pVATl.IndexOf(Pointer(PtrInt(pVATId))) = -1) then
        pVATl.Add(Pointer(PtrInt(pVATId)));
      // ---
    end;



    // ---
    // Create a root node
    Root := Doc.CreateElement('E_Invoice');
    Doc.Appendchild(Root);




    Header := Doc.CreateElement('Header');

    Item := Doc.CreateElement('Test');
    pTestMode := False;
    Item.AppendChild(Doc.CreateTextNode(_sx(IfThen(pTestMode, 'YES', 'NO')))); // Kasutatava standardi versioon.
    Header.AppendChild(Item);

    Item := Doc.CreateElement('Date');
    Item.AppendChild(Doc.CreateTextNode(_sx(formatdatetime(CEBillFmt, now)))); // Elemendis märgitakse faili genereerimise kuupäev.
    Header.AppendChild(Item);


    Item := Doc.CreateElement('FileId');
    Item.AppendChild(Doc.CreateTextNode(_sx(IntToStr(pBillID))));
    // Faili unikaalne identifikaator, mis aitab vältida sama identifikaatoriga failide topelt töötlemist.
    Header.AppendChild(Item);

    Item := Doc.CreateElement('Version');
    Item.AppendChild(Doc.CreateTextNode(_sx('1.1'))); // Kasutatava standardi versioon.
    Header.AppendChild(Item);


    Item := Doc.CreateElement('SenderId');
    Item.AppendChild(Doc.CreateTextNode(_sx(CHdrSenderId))); // Faili saatja identifikaator.
    Header.AppendChild(Item);

    Item := Doc.CreateElement('ReceiverId');
    Item.AppendChild(Doc.CreateTextNode(_sx(CReceiverId))); // Faili vastuvõtja identifikaator.
    Header.AppendChild(Item);

    Item := Doc.CreateElement('ContractId');
    Item.AppendChild(Doc.CreateTextNode(_sx(CContractId))); // Saatja ja vastuvõtja vahelise lepingu identifikaator.
    Header.AppendChild(Item);

    Item := Doc.CreateElement('PayeeAccountNumber');
    Item.AppendChild(Doc.CreateTextNode(_sx(CPayeeAccountNumber)));
    // Müüjale kuuluv konto. Konto väärtus ei pea olema võrdne PaymentInfo blokis oleva PayToAccount numbriga
    Header.AppendChild(Item);


    Root.Appendchild(Header);
    // --------------------
     {
     invoiceId Arve unikaalne identifikaator, mis tagabrve unikaalsuse faili piires.
     serviceId Kliendi identifikaator arve saatja süsteemis (kliendikood, kliendinumber, viitenumber vms.).
     }



    Invoice := Doc.CreateElement('Invoice');
    Root.Appendchild(Invoice);
    TDOMElement(Invoice).SetAttribute('invoiceId', IntToStr(pBillId));
    TDOMElement(Invoice).SetAttribute('serviceId', IntToStr(pClientId));
    TDOMElement(Invoice).SetAttribute('regNumber', pClientRegCode);



    //<InvoiceParties>
    InvoiceParties := Doc.CreateElement('InvoiceParties');
    Invoice.Appendchild(InvoiceParties);
    // --------------------
    // SellerParty

    SellerParty := Doc.CreateElement('SellerParty');
    InvoiceParties.Appendchild(SellerParty);

    Item := Doc.CreateElement('Name');
    Item.AppendChild(Doc.CreateTextNode(_sx(estbk_globvars.glob_currcompname)));
    SellerParty.AppendChild(Item);

    Item := Doc.CreateElement('RegNumber');
    Item.AppendChild(Doc.CreateTextNode(_sx(estbk_globvars.glob_currcompregcode)));
    SellerParty.AppendChild(Item);

    Item := Doc.CreateElement('VATRegNumber');
    Item.AppendChild(Doc.CreateTextNode(_sx(estbk_globvars.glob_currcompvatnr)));
    SellerParty.AppendChild(Item);

    ContactData := Doc.CreateElement('ContactData');
    SellerParty.AppendChild(ContactData);

    Item := Doc.CreateElement('PhoneNumber');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCompPhoneNr)));
    ContactData.AppendChild(Item);

    if pCompEmail <> '' then
    begin
      Item := Doc.CreateElement('E-mailAddress');
      Item.AppendChild(Doc.CreateTextNode(_sx(pCompEmail)));
      ContactData.AppendChild(Item);
    end;

    LegalAddress := Doc.CreateElement('LegalAddress');
    ContactData.AppendChild(LegalAddress);


    Item := Doc.CreateElement('PostalAddress1');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCompPostalAddr)));
    LegalAddress.AppendChild(Item);

    Item := Doc.CreateElement('City');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCompCity)));
    LegalAddress.AppendChild(Item);

    Item := Doc.CreateElement('PostalCode');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCompPostalCode)));
    LegalAddress.AppendChild(Item);

    Item := Doc.CreateElement('Country');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCompCountry)));
    LegalAddress.AppendChild(Item);


    BuyerParty := Doc.CreateElement('BuyerParty');
    InvoiceParties.Appendchild(BuyerParty);

    Item := Doc.CreateElement('Name');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCustomername)));
    BuyerParty.AppendChild(Item);

    Item := Doc.CreateElement('RegNumber');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerregnr)));
    BuyerParty.AppendChild(Item);

    Item := Doc.CreateElement('VATRegNumber');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerVATRegnr)));
    BuyerParty.AppendChild(Item);

    ContactData := Doc.CreateElement('ContactData');
    BuyerParty.AppendChild(ContactData);

    Item := Doc.CreateElement('PhoneNumber');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerPhoneNr)));
    ContactData.AppendChild(Item);


    if pCustomerEmail <> '' then
    begin
      Item := Doc.CreateElement('E-mailAddress');
      Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerEmail)));
      ContactData.AppendChild(Item);
    end;

    LegalAddress := Doc.CreateElement('LegalAddress');
    ContactData.AppendChild(LegalAddress);


    Item := Doc.CreateElement('PostalAddress1');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerPostalAddr)));
    LegalAddress.AppendChild(Item);

    Item := Doc.CreateElement('City');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerCity)));
    LegalAddress.AppendChild(Item);

    Item := Doc.CreateElement('PostalCode');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerPostalCode)));
    LegalAddress.AppendChild(Item);

    Item := Doc.CreateElement('Country');
    Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerCountry)));
    LegalAddress.AppendChild(Item);


    InvoiceInformation := Doc.CreateElement('InvoiceInformation');
    Invoice.Appendchild(InvoiceInformation);

    Item := Doc.CreateElement('Type');
    // Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerCountry));
    //TDOMElement(Invoice).SetAttribute('type','DEB'); // vaid müügiarved hetkel !! <Type type="DEB"/>
    // Item.AppendChild(Doc.CreateTextNode(_sx('DEB')));
     (*
     <xs:restriction base="xs:NMTOKEN">
                  <xs:pattern value="DEB"/>
                  <xs:pattern value="CRE"/>
     </xs:restriction>
     *)
    TDOMElement(Item).SetAttribute('type', 'DEB');
    InvoiceInformation.AppendChild(Item);

    Item := Doc.CreateElement('DocumentName');
    Item.AppendChild(Doc.CreateTextNode(_sx('ARVE')));
    InvoiceInformation.AppendChild(Item);


    Item := Doc.CreateElement('InvoiceNumber');
    Item.AppendChild(Doc.CreateTextNode(_sx(pBillNr)));
    InvoiceInformation.AppendChild(Item);

    //Item:=Doc.CreateElement('InvoiceContentText');
    //Item.AppendChild(Doc.CreateTextNode(_sx('MÜÜGIARVE'));
    //InvoiceInformation.AppendChild(Item);
    Item := Doc.CreateElement('InvoiceDate');
    Item.AppendChild(Doc.CreateTextNode(_sx(formatdatetime(CEBillFmt, pBilldate))));
    InvoiceInformation.AppendChild(Item);

    Item := Doc.CreateElement('DueDate');
    Item.AppendChild(Doc.CreateTextNode(_sx(formatdatetime(CEBillFmt, pBillDuedate))));
    InvoiceInformation.AppendChild(Item);

    Item := Doc.CreateElement('FineRatePerDay');
    Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(CCurrentMoneyFmt2, [pBillFineRate]), ',', '.', []))));
    //     FineRatePerDay
    InvoiceInformation.AppendChild(Item);



    // --------------------
    {
    <Balance />
    <InvoiceSum>35</InvoiceSum>
-   <VAT>
    <SumBeforeVAT>35</SumBeforeVAT>
    <VATRate />
    <VATSum>7</VATSum>
    </VAT>
    <TotalSum>42</TotalSum>
    <Currency>EUR</Currency>
    }
    InvoiceSumGroup := Doc.CreateElement('InvoiceSumGroup');
    Invoice.Appendchild(InvoiceSumGroup);


    for i := 0 to pVATl.Count - 1 do
    begin
      pVATId := PtrInt(pVATl.Items[i]);
      VAT := Doc.CreateElement('VAT');
      InvoiceSumGroup.AppendChild(VAT);
      pSumBeforeVAT := 0.00;
      pVATRate := 0.00;
      pVATSum := 0.00;


      for j := 0 to pBillLines.Count - 1 do
      begin
        pBillLine := pBillLines.Items[j] as TvMergedBillLines;
        if PtrInt(pBillLine.FVatID) = pVATId then
        begin
          pVATRate := pBillLine.FVatPerc;
          pVATSum := pVATSum + pBillLine.FCalcLineVatSum;
          pSumBeforeVAT := pSumBeforeVAT + pBillLine.FArtSalepr - pVATSum;
        end;
      end;

      Item := Doc.CreateElement('SumBeforeVAT');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pSumBeforeVAT]), ',', '.', []))));
      VAT.AppendChild(Item);

      Item := Doc.CreateElement('VATRate');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(floattostr(pVATRate), ',', '.', []))));
      VAT.AppendChild(Item);

      Item := Doc.CreateElement('VATSum');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pVATSum]), ',', '.', []))));
      VAT.AppendChild(Item);

      Item := Doc.CreateElement('Currency');
      Item.AppendChild(Doc.CreateTextNode(_sx(pBillCurrency)));
      VAT.AppendChild(Item);
    end;




    pCal := pBillSum + pBillVATSum + pBillRoundSum;
    Item := Doc.CreateElement('TotalSum');
    Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pCal]), ',', '.', []))));
    InvoiceSumGroup.AppendChild(Item);

    Item := Doc.CreateElement('Currency');
    Item.AppendChild(Doc.CreateTextNode(_sx(pBillCurrency)));
    InvoiceSumGroup.AppendChild(Item);


    InvoiceItem := Doc.CreateElement('InvoiceItem');
    Invoice.Appendchild(InvoiceItem);

    InvoiceItemGroup := Doc.CreateElement('InvoiceItemGroup');
    InvoiceItem.Appendchild(InvoiceItemGroup);
    TDOMElement(InvoiceItemGroup).SetAttribute('groupId', '');


    // ---
    for i := 0 to pBillLines.Count - 1 do
    begin
      pBillLine := pBillLines.Items[i] as TvMergedBillLines;
      // @@@
      ItemEntry := Doc.CreateElement('ItemEntry');
      InvoiceItemGroup.Appendchild(ItemEntry);

      Item := Doc.CreateElement('Description');
      Item.AppendChild(Doc.CreateTextNode(_sx(pBillLine.FArtOrigDescr)));
      ItemEntry.AppendChild(Item);

      ItemDetailInfo := Doc.CreateElement('ItemDetailInfo');
      ItemEntry.AppendChild(ItemDetailInfo);

      Item := Doc.CreateElement('ItemUnit');
      Item.AppendChild(Doc.CreateTextNode(_sx(pBillLine.FUnit)));
      ItemDetailInfo.AppendChild(Item);

      // <ItemAmount>1</ItemAmount>
      Item := Doc.CreateElement('ItemAmount');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(floattostr(pBillLine.FQty), ',', '.', []))));
      ItemDetailInfo.AppendChild(Item);

      // <ItemPrice>35</ItemPrice>
      Item := Doc.CreateElement('ItemPrice');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pBillLine.FPrice]), ',', '.', []))));
      ItemDetailInfo.AppendChild(Item);

      // <ItemSum>35</ItemSum>
      Item := Doc.CreateElement('ItemSum');
      //     Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pBillLine.FArtSalepr-pBillLine.FCalcLineVatSum]),',','.',[]))));
      // 04.05.2014 Ingmar; ikka ItemSum on kogusumma !
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pBillLine.FPrice * pBillLine.FQty]), ',', '.', []))));
      ItemEntry.AppendChild(Item);


      VAT := Doc.CreateElement('VAT');
      ItemEntry.AppendChild(VAT);


      pSumBeforeVAT := pBillLine.FArtSalepr - pBillLine.FCalcLineVatSum;

      Item := Doc.CreateElement('SumBeforeVAT');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pSumBeforeVAT]), ',', '.', []))));
      VAT.AppendChild(Item);

      pVATRate := pBillLine.FVatPerc;
      Item := Doc.CreateElement('VATRate');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(floattostr(pVATRate), ',', '.', []))));
      VAT.AppendChild(Item);


      pVATSum := pBillLine.FCalcLineVatSum;

      Item := Doc.CreateElement('VATSum');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pVATSum]), ',', '.', []))));
      VAT.AppendChild(Item);


      Item := Doc.CreateElement('ItemTotal');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pBillLine.FArtSalepr]), ',', '.', []))));
      ItemEntry.AppendChild(Item);
    end;

    PaymentInfo := Doc.CreateElement('PaymentInfo');
    Invoice.Appendchild(PaymentInfo);

    with pQry, SQL do
      try

        Close;
        Clear;
        Add(estbk_sqlclientcollection._SQLSelectAccountsWithBankData(False));
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;
        //   while not eof do
        First;
        Item := Doc.CreateElement('Currency');
        Item.AppendChild(Doc.CreateTextNode(_sx(pBillCurrency)));
        PaymentInfo.AppendChild(Item);

        Item := Doc.CreateElement('PaymentDescription');
        Item.AppendChild(Doc.CreateTextNode(_sx('Arve nr ' + pBillNr)));
        PaymentInfo.AppendChild(Item);

        // Item:=Doc.CreateElement('PaymentRefId');
        // Item.AppendChild(Doc.CreateTextNode(_sx(pRefNumber));
        // <Payable>YES</Payable>
     {
     Juhib arve maksmist.
      YES – arve kuulub tasumisele.
     (PayDueDate täitmine on
      kohustuslik).
      NO – arve ei kuulu tasumisele
     (PayDueDate täitmine ei olekohustuslik).
     }
        Item := Doc.CreateElement('Payable');
        Item.AppendChild(Doc.CreateTextNode(_sx('YES')));
        PaymentInfo.AppendChild(Item);

        Item := Doc.CreateElement('PayDueDate');
        Item.AppendChild(Doc.CreateTextNode(_sx(formatdatetime(CEBillFmt, pBillDuedate))));
        PaymentInfo.AppendChild(Item);

        // arve kogusumma;
        if pCal < 0.00 then
          pCal := 0.00;

        Item := Doc.CreateElement('PaymentTotalSum');
        Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pCal]), ',', '.', []))));
        PaymentInfo.AppendChild(Item);

        Item := Doc.CreateElement('PayerName');
        Item.AppendChild(Doc.CreateTextNode(_sx(pCustomername)));
        PaymentInfo.AppendChild(Item);

        Item := Doc.CreateElement('PaymentId');
        Item.AppendChild(Doc.CreateTextNode(_sx(pBillNr)));
        PaymentInfo.AppendChild(Item);

        // <PayToAccount>10002028538006</PayToAccount>
        // <PayToName>TESTMÜÜJA AS</PayToName>
        Item := Doc.CreateElement('PayToAccount');
        Item.AppendChild(Doc.CreateTextNode(_sx(FieldByName('account_nr').AsString)));
        PaymentInfo.AppendChild(Item);

        Item := Doc.CreateElement('PayToName');
        Item.AppendChild(Doc.CreateTextNode(_sx(estbk_globvars.glob_currcompname)));
        PaymentInfo.AppendChild(Item);
     {
     DirectDebitPayeeContract Number Panga ja raha saaja vahel sõlmitud otsekorralduse lepingu number (Saajalepingu number). ShortTextType EI
     DirectDebitPayerNumber Otsekorralduse maksetunnus (viitenumber, kliendikood, vms.). ReferenceType EI
     }
        // ---
      finally
        Close;
        Clear;
      end;



    // --- hetkel vaid üks arve !
    Footer := Doc.CreateElement('Footer');
    Root.Appendchild(Footer);

    Item := Doc.CreateElement('TotalNumberInvoices');
    Item.AppendChild(Doc.CreateTextNode(_sx('1')));
    Footer.AppendChild(Item);

    Item := Doc.CreateElement('TotalAmount');
    Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2, [pCal]), ',', '.', []))));
    Footer.AppendChild(Item);

    // ---
    XMLWrite.WriteXML(Doc.DocumentElement, pStr);

    Result := utf8decode(pStr.DataString);

  finally
    pBillLines.Free;
    pStr.Free;
    Doc.Free;
    pVATl.Free;
      {$IFNDEF NOGUI}
    pQry.Free;
      {$ENDIF}
  end;
end;

end.
