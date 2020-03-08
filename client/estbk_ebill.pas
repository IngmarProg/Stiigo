unit estbk_ebill;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface

uses
  Classes,SysUtils,DOM,ZConnection,ZDataset,ZSqlUpdate,
  XMLRead,XMLWrite, XMLCfg, XMLUtils,strutils,
  estbk_globvars,estbk_types,estbk_strmsg,estbk_sqlclientcollection,
  estbk_lib_commoncls,estbk_utilities
  {$IFNDEF NOGUI},Dialogs,estbk_clientdatamodule{$ENDIF};

// @@
function _generateEBill(const pBillID : Integer{$IFDEF NOGUI};const pExtQuery : TZquery{$ENDIF}):AStr;

implementation
// ---
procedure loadBillLines(const pQry : TZquery;const pBillId : Integer; const pBillLines : TCollection);
var
    pItem : TvMergedBillLines;
begin
 with pQry,SQL do
  try
        close;
        clear;
        // --
        add(estbk_sqlclientcollection._SQLSelectBillLines());
        paramByname('bill_id').AsInteger:=pBillId;
        open;
  while not eof do
     begin
        // lühendatud variant !
        pItem := pBillLines.Add as TvMergedBillLines;
        pItem.FArtCode := fieldByname('code').AsString;
        pItem.FArtDescr := trim(fieldByname('artname').AsString);
     if pItem.FArtDescr = '' then
        pItem.FArtDescr := trim(fieldByname('descr2').AsString);
        pItem.FArtOrigDescr := pItem.FArtDescr;

        // @@@
        pItem.FUnit := fieldByname('artunit').AsString;
        pItem.FQty := fieldByname('quantity').AsFloat;
        pItem.FArtSalepr := fieldByname('total').AsFloat; // siin hoian totali infot !
        pItem.FPrice := fieldByname('item_price').AsFloat;

        pItem.FCalcLineVatSum := fieldByname('vat_rsum').AsFloat;
        pItem.FVatPerc := fieldByname('vatperc').AsFloat;
        pItem.FVatID := fieldByname('vat_id').AsInteger;
        // pItem.FVatLongName := fieldByname('artunit').AsString;

        next;
     end;
  finally
       close;
       clear;
  end;
end;

{
& &amp;
’ &apos;
> &gt;
< &lt;
“ &quot;
}

function _sx(const pxmlstr : AStr; const pmaxLen : Integer = 1024):AStr; // TODO panna pikkused paika vastavalt XSD schemale !
begin
 result:=pxmlstr;
 result:=stringreplace(result,'&','&amp;',[rfReplaceAll]);
 result:=stringreplace(result,'>','&gt;',[rfReplaceAll]);
 result:=stringreplace(result,'<','&lt;',[rfReplaceAll]);
 result:=stringreplace(result,'"','&quot;',[rfReplaceAll]);
 result:=stringreplace(result,chr(39),'&quot;',[rfReplaceAll]);

end;

// http://www.pangaliit.ee/images/files/E-arve/e-invoice_ver1_1_est.pdf
// E:\Arved_2012_03_27_10_20_20.xml
function _generateEBill(const pBillID : Integer{$IFDEF NOGUI};const pExtQuery : TZquery{$ENDIF}):AStr;
const
    CHdrSenderId = '';
    CReceiverId  = '';
    CPayeeAccountNumber = '';
    CContractId = '';
    CEBillFmt   = 'yyyy-mm-dd';
var
    Doc: TXMLDocument;
    Root,Header,Footer,Invoice,
    InvoiceParties,SellerParty,BuyerParty,
    InvoiceInformation,InvoiceSumGroup,
    InvoiceItem,InvoiceItemGroup,ItemEntry,ContactData,
    VAT, Item,TextNode,LegalAddress,MailAddress,
    ItemReserve,PaymentInfo, ItemDetailInfo: TDOMNode;

    pTestMode : Boolean;
    pClientId : Integer;
    pClientRegCode,
    pCompPhoneNr,
    pCompEmail,
    pCompPostalAddr,
    pCompCity,
    pCompPostalCode,
    pCompCountry,
    pCompMailPostalAddr,
    pCompMailCity,
    pCompMailPostalCode,
    pCompMailCountry : AStr;

    pCustomername,
    pCustomerregnr,
    pCustomerVATRegnr,
    pCustomerPhoneNr,
    pCustomerEmail,
    pCustomerPostalAddr,
    pCustomerCity,
    pCustomerPostalCode,
    pCustomerCountry : AStr;

    pBilldate,
    pBillDuedate : TDatetime;
    pBillFineRate : Double;
    pBillNr : AStr;
    pBillLines  : TCollection;
    pQry : TZQuery;
    // --
    pBillSum: Double;
    pBillVATSum: Double;
    pBillIncomeSum: Double;
    pBillRoundSum: Double;
    pBillCurrency : AStr;
    i,j : Integer;
    pVATl : TList;
    pVATId: Integer;
    pBillLine : TvMergedBillLines;

    pSumBeforeVAT,
    pVATRate,
    pVATSum,
    pCal: Double;
    pStr : TStringStream;
    pTest : Textfile;
begin
  try
     {$IFDEF NOGUI}
     pQry := pExtQuery;
     {$ELSE}
     pQry:=TZQuery.Create(nil);
     pQry.Connection:=estbk_clientdatamodule.dmodule.primConnection;
     {$ENDIF}
     pStr:=TStringStream.Create('');
     pBillLines:=TCollection.Create(TvMergedBillLines);
     // Create a document
     Doc := TXMLDocument.Create;
     pVATl:=TList.Create;

     // teeme lihtandmete eellaadimise
with pQry,SQL do
  try
     pBilldate:=now;
     pBillDuedate:=now;
     pBillFineRate:=0.00;
     pBillSum:=0.00;
     pBillVATSum:=0.00;
     pBillIncomeSum:=0.00;
     pBillRoundSum:=0.00;

     pClientId:=0;
     pClientRegCode:='';
     pCompPhoneNr:='';
     pCompEmail:='';
     pCompPostalAddr:='';
     pCompCity:='';
     pCompPostalCode:='';
     pCompCountry:='';
     pCompMailPostalAddr:='';
     pCompMailCity:='';
     pCompMailPostalCode:='';
     pCompMailCountry:='';

     pCustomername:='';
     pCustomerregnr:='';
     pCustomerVATRegnr:='';
     pCustomerPhoneNr:='';
     pCustomerEmail:='';
     pCustomerPostalAddr:='';
     pCustomerCity:='';
     pCustomerPostalCode:='';
     pCustomerCountry:='';

     close;
     clear;
     // add(estbk_sqlclientcollection._SQLSelectBillMainRec);
     add(estbk_sqlclientcollection._SQLGetBillMainRec); // meil vaja ka kreeditarve infot !
     paramByname('bill_id').AsInteger:=pBillID;
     paramByname('company_id').AsInteger:=estbk_globvars.glob_company_id;
     open;
  if eof then
     raise exception.Create(estbk_strmsg.SEBillNotFound);

     pClientId:=FieldByname('client_id').AsInteger;
     pBilldate:=FieldByname('bill_date').AsDateTime;
     pBillDuedate:=FieldByname('due_date').AsDateTime;
     pBillFineRate:=FieldByname('overdue_perc').AsFloat;
     pBillNr:=FieldByname('bill_number').AsString;

     pBillSum:=FieldByname('totalsum').AsFloat;
     pBillVATSum:=FieldByname('vatsum').AsFloat;
     pBillIncomeSum:=FieldByname('incomesum').AsFloat;
     pBillRoundSum:=FieldByname('roundsum').AsFloat;
     pBillCurrency:=FieldByname('currency').AsString;

     // ---
     // FIRMA
     close;
     clear;
     add(estbk_sqlclientcollection._CSQLSelectCompany);
     paramByname('company_id').AsInteger:=estbk_globvars.glob_company_id;
     open;
     pCompPhoneNr:=FieldByname('phone').AsString;
     pCompEmail:=FieldByname('email').AsString;
     pCompPostalAddr:=trim(FieldByname('street_name').AsString+' '+FieldByname('house_nr').AsString);
  if FieldByname('apartment_nr').AsString<>'' then
     pCompPostalAddr:=pCompPostalAddr+' - ';
     pCompPostalAddr:=pCompPostalAddr+ FieldByname('apartment_nr').AsString;

     pCompCity:=FieldByname('city_name').AsString;
     pCompPostalCode:=FieldByname('zipcode').AsString;
     pCompCountry:=''; // TODO

     // hetkel samad ! TODO 2 !!
     pCompMailPostalAddr:=pCompPostalAddr;
     pCompMailCity:=pCompCity;
     pCompMailPostalCode:=pCompPostalCode;
     pCompMailCountry:=pCompCountry;

     // ---
     // KLIENT
     close;
     clear;
     add(estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id,pClientId));
     open;

     pCustomername:=trim(fieldByname('custname').asString+' '+fieldByname('middlename').asString+' '+fieldByname('lastname').asString);
     pCustomerregnr:=fieldByname('regnr').asString;
     pCustomerVATRegnr:=fieldByname('vatnumber').asString;
     pCustomerPhoneNr:=fieldByname('phone').asString;
     pCustomerEmail:=fieldByname('email').asString;


     pCustomerPostalAddr:=trim(FieldByname('streetname').AsString+' '+FieldByname('house_nr').AsString);
  if FieldByname('house_nr').AsString<>'' then
     pCustomerPostalAddr:=pCustomerPostalAddr+' - ';
     pCustomerPostalAddr:=pCustomerPostalAddr+ FieldByname('house_nr').AsString;

     pCustomerCity:=fieldByname('cityname').asString;
     pCustomerPostalCode:=fieldByname('cityname').asString;
     pCustomerCountry:=fieldbyname('countrycode').asString;


  finally
     close;
     clear;
  end;

     // ---
     loadBillLines(pQry,pBillID,pBillLines);

 // mitu erinevat KM on ?
 for i:=0 to pBillLines.Count-1 do
   begin
     pVATId:=(pBillLines.Items[i] as TvMergedBillLines).FVatID;
 if (pVATId>0) and (pVATl.IndexOf(Pointer(PtrInt(pVATId)))=-1) then
     pVATl.Add(Pointer(PtrInt(pVATId)));
   // ---
   end;


     //  TDOMElement(parentNode).SetAttribute('id', '001');
     //  TextNode:=Doc.CreateTextNode(_sx('Item1Value is '+IntToStr(i));
     // ---
     // Create a root node
     Root := Doc.CreateElement('E_Invoice');
     Doc.Appendchild(Root);


  {
    <Date>2012-03-27</Date>
    <FileId>12032710202068_14</FileId>
    <Version>1.0</Version>
    <TotalNumberInvoices>1</TotalNumberInvoices>
    <TotalAmount>0</TotalAmount>
    // ---
    dokumendist !
    <Test>YES</Test>
    <Date>2009-12-01</Date>
    <FileId>66488</FileId>
    <Version>1.1</Version>
    <SenderId>SWEDB</SenderId>
    <ReceiverId>ITEE</ReceiverId>
    <ContractId>EA1245</ContractId>
    <PayeeAccountNumber>10022056127002
    </PayeeAccountNumber>
  }

     Header:= Doc.CreateElement('Header');

     Item:=Doc.CreateElement('Test');
     pTestMode:=false;
     Item.AppendChild(Doc.CreateTextNode(_sx(IfThen(pTestMode,'YES','NO')))); // Kasutatava standardi versioon.
     Header.AppendChild(Item);

     Item:=Doc.CreateElement('Date');
     Item.AppendChild(Doc.CreateTextNode(_sx(formatdatetime(CEBillFmt,now)))); // Elemendis märgitakse faili genereerimise kuupäev.
     Header.AppendChild(Item);


     Item:=Doc.CreateElement('FileId');
     Item.AppendChild(Doc.CreateTextNode(_sx(inttostr(pBillID)))); // Faili unikaalne identifikaator, mis aitab vältida sama identifikaatoriga failide topelt töötlemist.
     Header.AppendChild(Item);

     Item:=Doc.CreateElement('Version');
     Item.AppendChild(Doc.CreateTextNode(_sx('1.1'))); // Kasutatava standardi versioon.
     Header.AppendChild(Item);


     Item:=Doc.CreateElement('SenderId');
     Item.AppendChild(Doc.CreateTextNode(_sx(CHdrSenderId))); // Faili saatja identifikaator.
     Header.AppendChild(Item);

     Item:=Doc.CreateElement('ReceiverId');
     Item.AppendChild(Doc.CreateTextNode(_sx(CReceiverId))); // Faili vastuvõtja identifikaator.
     Header.AppendChild(Item);

     Item:=Doc.CreateElement('ContractId');
     Item.AppendChild(Doc.CreateTextNode(_sx(CContractId))); // Saatja ja vastuvõtja vahelise lepingu identifikaator.
     Header.AppendChild(Item);

     Item:=Doc.CreateElement('PayeeAccountNumber');
     Item.AppendChild(Doc.CreateTextNode(_sx(CPayeeAccountNumber))); // Müüjale kuuluv konto. Konto väärtus ei pea olema võrdne PaymentInfo blokis oleva PayToAccount numbriga
     Header.AppendChild(Item);


     Root.Appendchild(Header);
     // --------------------
     {
     invoiceId Arve unikaalne identifikaator, mis tagabrve unikaalsuse faili piires.
     serviceId Kliendi identifikaator arve saatja süsteemis (kliendikood, kliendinumber, viitenumber vms.).
     }
     // <Invoice invoiceId="826392" serviceId="1578680" regNumber="10308526" accountNumber="">    accountNumber puudub dokumendis ?



     Invoice:=Doc.CreateElement('Invoice');
     Root.Appendchild(Invoice);
     TDOMElement(Invoice).SetAttribute('invoiceId',inttostr(pBillId));
     TDOMElement(Invoice).SetAttribute('serviceId',inttostr(pClientId));
     TDOMElement(Invoice).SetAttribute('regNumber',pClientRegCode);



     //<InvoiceParties>
     InvoiceParties:=Doc.CreateElement('InvoiceParties');
     Invoice.Appendchild(InvoiceParties);
     // --------------------
     // SellerParty
     {
     <Name>Outzen OÜ</Name>
     <RegNumber>11933114</RegNumber>
     <VATRegNumber>EE101493079</VATRegNumber>

     <ContactData>
     <PhoneNumber>5032694</PhoneNumber>
    <E-mailAddress>marko@outzen.ee</E-mailAddress>

    <LegalAddress>
    <PostalAddress1>Veetorni 9</PostalAddress1>
    <City>Jüri alevik, Rae vald Harjumaa</City>
    <PostalCode>75301</PostalCode>
    </LegalAddress>

    <MailAddress>
    <PostalAddress1>Veetorni 9</PostalAddress1>
    <City>Jüri alevik, Rae vald Harjumaa</City>
    <PostalCode>75301</PostalCode>
    <Country>Eesti</Country>
    </MailAddress>
    </ContactData>

    <AccountInfo>
    <AccountNumber>221049920894</AccountNumber>
    <BankName>Swedbank</BankName>
    </AccountInfo>
    }
     SellerParty:=Doc.CreateElement('SellerParty');
     InvoiceParties.Appendchild(SellerParty);

     Item:=Doc.CreateElement('Name');
     Item.AppendChild(Doc.CreateTextNode(_sx(estbk_globvars.glob_currcompname)));
     SellerParty.AppendChild(Item);

     Item:=Doc.CreateElement('RegNumber');
     Item.AppendChild(Doc.CreateTextNode(_sx(estbk_globvars.glob_currcompregcode)));
     SellerParty.AppendChild(Item);

     Item:=Doc.CreateElement('VATRegNumber');
     Item.AppendChild(Doc.CreateTextNode(_sx(estbk_globvars.glob_currcompvatnr)));
     SellerParty.AppendChild(Item);

     ContactData:=Doc.CreateElement('ContactData');
     SellerParty.AppendChild(ContactData);

     Item:=Doc.CreateElement('PhoneNumber');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompPhoneNr)));
     ContactData.AppendChild(Item);

  if pCompEmail <> '' then
    begin
     Item:=Doc.CreateElement('E-mailAddress');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompEmail)));
     ContactData.AppendChild(Item);
    end;

     LegalAddress:=Doc.CreateElement('LegalAddress');
     ContactData.AppendChild(LegalAddress);


     Item:=Doc.CreateElement('PostalAddress1');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompPostalAddr)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('City');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompCity)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('PostalCode');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompPostalCode)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('Country');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompCountry)));
     LegalAddress.AppendChild(Item);

     (*
      if MailAddress <> '' then
       begin
         MailAddress:=Doc.CreateElement('MailAddress');
         ContactData.AppendChild(MailAddress);
       end;
     *)
     (*
     Item:=Doc.CreateElement('PostalAddress1');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompMailPostalAddr)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('City');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompMailCity)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('PostalCode');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompMailPostalCode)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('Country');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCompMailCountry)));
     LegalAddress.AppendChild(Item);*)
    // --------------------
    {
    <Name>MINGI FIRMA</Name>
    <RegNumber>11223344</RegNumber>
    <VATRegNumber>EE1111222333</VATRegNumber>
    <ContactData>
    <PhoneNumber>112233</PhoneNumber>
    <E-mailAddress>email@email.ee</E-mailAddress>
-   <LegalAddress>
    <PostalAddress1>Lai</PostalAddress1>
    <City>Tallinn</City>
    <PostalCode>10151</PostalCode>
    </LegalAddress>
    </ContactData>
    }

     BuyerParty:=Doc.CreateElement('BuyerParty');
     InvoiceParties.Appendchild(BuyerParty);

     Item:=Doc.CreateElement('Name');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomername)));
     BuyerParty.AppendChild(Item);

     Item:=Doc.CreateElement('RegNumber');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerregnr)));
     BuyerParty.AppendChild(Item);

     Item:=Doc.CreateElement('VATRegNumber');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerVATRegnr)));
     BuyerParty.AppendChild(Item);

     ContactData:=Doc.CreateElement('ContactData');
     BuyerParty.AppendChild(ContactData);

     Item:=Doc.CreateElement('PhoneNumber');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerPhoneNr)));
     ContactData.AppendChild(Item);


  if pCustomerEmail <> '' then
    begin
     Item:=Doc.CreateElement('E-mailAddress');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerEmail)));
     ContactData.AppendChild(Item);
    end;

     LegalAddress:=Doc.CreateElement('LegalAddress');
     ContactData.AppendChild(LegalAddress);


     Item:=Doc.CreateElement('PostalAddress1');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerPostalAddr)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('City');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerCity)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('PostalCode');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerPostalCode)));
     LegalAddress.AppendChild(Item);

     Item:=Doc.CreateElement('Country');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerCountry)));
     LegalAddress.AppendChild(Item);


    // --------------------
    // <InvoiceInformation>
    {
    <Type type="DEB" />
    <DocumentName>Arve</DocumentName>
    <InvoiceNumber>229</InvoiceNumber>
    <InvoiceContentText>Kodulehe arendustööd (sisumalli muudatused)</InvoiceContentText>
    <InvoiceDate>2012-03-20</InvoiceDate>
    <DueDate>2012-03-30</DueDate>
    <FineRatePerDay>0.05</FineRatePerDay>
    }
    {
    <Type type="DEB">
    <SourceInvoice>String</SourceInvoice>
    </Type>
    <FactorContractNumber>String</FactorContractNumber>
    <ContractNumber>String</ContractNumber>
    <DocumentName>String</DocumentName>
    <InvoiceNumber>String</InvoiceNumber>
    <InvoiceContentCode>String</InvoiceContentCode>
    <InvoiceContentText>String</InvoiceContentText>
    <PaymentReferenceNumber/>
    <PaymentMethod>String</PaymentMethod>
    <InvoiceDate>1967-08-13</InvoiceDate>
    <DueDate>1967-08-13</DueDate>
    <PaymentTerm>String</PaymentTerm>
    <FineRatePerDay>1.12</FineRatePerDay>
    <Period>
    <PeriodName>String</PeriodName>
    <StartDate>1967-08-13</StartDate>
    <EndDate>1967-08-13</EndDate>
    </Period>
    }
     InvoiceInformation:=Doc.CreateElement('InvoiceInformation');
     Invoice.Appendchild(InvoiceInformation);

     Item:=Doc.CreateElement('Type');
     // Item.AppendChild(Doc.CreateTextNode(_sx(pCustomerCountry));
     //TDOMElement(Invoice).SetAttribute('type','DEB'); // vaid müügiarved hetkel !! <Type type="DEB"/>
     // Item.AppendChild(Doc.CreateTextNode(_sx('DEB')));
     (*
     <xs:restriction base="xs:NMTOKEN">
									<xs:pattern value="DEB"/>
									<xs:pattern value="CRE"/>
     </xs:restriction>
     *)
     TDOMElement(Item).SetAttribute('type','DEB');
     InvoiceInformation.AppendChild(Item);

     Item:=Doc.CreateElement('DocumentName');
     Item.AppendChild(Doc.CreateTextNode(_sx('ARVE')));
     InvoiceInformation.AppendChild(Item);

     // ---
     // 04.05.2014 Ingmar; olin arve nr ära unustanud
     Item:=Doc.CreateElement('InvoiceNumber');
     Item.AppendChild(Doc.CreateTextNode(_sx(pBillNr)));
     InvoiceInformation.AppendChild(Item);

     //Item:=Doc.CreateElement('InvoiceContentText');
     //Item.AppendChild(Doc.CreateTextNode(_sx('MÜÜGIARVE'));
     //InvoiceInformation.AppendChild(Item);
     Item:=Doc.CreateElement('InvoiceDate');
     Item.AppendChild(Doc.CreateTextNode(_sx(formatdatetime(CEBillFmt,pBilldate))));
     InvoiceInformation.AppendChild(Item);

     Item:=Doc.CreateElement('DueDate');
     Item.AppendChild(Doc.CreateTextNode(_sx(formatdatetime(CEBillFmt,pBillDuedate))));
     InvoiceInformation.AppendChild(Item);

     Item:=Doc.CreateElement('FineRatePerDay');
     Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(CCurrentMoneyFmt2,[pBillFineRate]),',','.',[]))));
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
     InvoiceSumGroup:=Doc.CreateElement('InvoiceSumGroup');
     Invoice.Appendchild(InvoiceSumGroup);


 for i:=0 to pVATl.Count-1 do
   begin
       pVATId:=PtrInt(pVATl.Items[i]);
       VAT:=Doc.CreateElement('VAT');
       InvoiceSumGroup.AppendChild(VAT);
       pSumBeforeVAT:=0.00;
       pVATRate:=0.00;
       pVATSum:=0.00;


   for j:=0 to  pBillLines.Count-1 do
      begin
         pBillLine:=pBillLines.Items[j] as TvMergedBillLines;
      if PtrInt(pBillLine.FVatID)=pVATId then
        begin
         pVATRate:=pBillLine.FVatPerc;
         pVATSum:=pVATSum+pBillLine.FCalcLineVatSum;
         pSumBeforeVAT:=pSumBeforeVAT+pBillLine.FArtSalepr-pVATSum;
        end;
      end;

       Item:=Doc.CreateElement('SumBeforeVAT');
       Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pSumBeforeVAT]),',','.',[]))));
       VAT.AppendChild(Item);

       Item:=Doc.CreateElement('VATRate');
       Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(floattostr(pVATRate),',','.',[]))));
       VAT.AppendChild(Item);

       Item:=Doc.CreateElement('VATSum');
       Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pVATSum]),',','.',[]))));
       VAT.AppendChild(Item);

       Item:=Doc.CreateElement('Currency');
       Item.AppendChild(Doc.CreateTextNode(_sx(pBillCurrency)));
       VAT.AppendChild(Item);
   end;




      pCal:=pBillSum+pBillVATSum+pBillRoundSum;
      Item:=Doc.CreateElement('TotalSum');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pCal]),',','.',[]))));
      InvoiceSumGroup.AppendChild(Item);

      Item:=Doc.CreateElement('Currency');
      Item.AppendChild(Doc.CreateTextNode(_sx(pBillCurrency)));
      InvoiceSumGroup.AppendChild(Item);

      // <TotalSum>1525.43</TotalSum>
      // <Currency>EEK</Currency>




{
      for i:=0 to pBillLines.Count-1 do
   begin
     pVATId:=(pBillLines.Items[i] as TvMergedBillLines).FVatID;
 if (pVATId>0) and (pVATl.IndexOf(Pointer(PtrInt(pVATId)))=-1) then
     pVATl.Add(Pointer(PtrInt(pVATId)));
   // ---
   end;
}

     {
     <Balance>
     <BalanceDate>1967-08-13</BalanceDate>
     <BalanceBegin>1.12</BalanceBegin>
     <Inbound>1.12</Inbound>
     <Outbound>1.12</Outbound>
     <BalanceEnd>1.12</BalanceEnd>
     </Balance>
     }

     // <InvoiceSum>1.1234</InvoiceSum>
     // <PenaltySum>1.1234</PenaltySum>
     {
     <Addition addCode="DSC">
     <AddContent>String</AddContent>
     <AddRate>1.12</AddRate>
     <AddSum>1.1234</AddSum>
     </Addition>
     }
     // <Rounding>1.1234</Rounding>

     {
     <VAT vatId="TAX">
     <SumBeforeVAT>1.1234</SumBeforeVAT>
     <VATRate>1.12</VATRate>
     <VATSum>1.1234</VATSum>
     <Currency>AAA</Currency>
     <SumAfterVAT>1.1234</SumAfterVAT>
     <Reference extensionId="String">
     <InformationName>String</InformationName>
     <InformationContent>String</InformationContent>
     <CustomContent>
     <any/>
     </CustomContent>
     </Reference>
     </VAT>
     <TotalVATSum>1.12</TotalVATSum>
     <TotalSum>1.12</TotalSum>
     <TotalToPay>1.12</TotalToPay>
     <Currency>AAA</Currency>


     <Accounting>
     <Description>String</Description>
     <JournalEntry>
     <GeneralLedger>String</GeneralLedger>
     <GeneralLedgerDetail>String</GeneralLedgerDetail>
     <CostObjective>String</CostObjective>
     <Sum>1.1234</Sum>
     <VatSum>1.1234</VatSum>
     <VatRate>1.12</VatRate>
     </JournalEntry>
     <PartnerCode>String</PartnerCode>
     <BusinessCode>String</BusinessCode>
     <SourceCode>String</SourceCode>
     <CashFlowCode>String</CashFlowCode>
     <ClassificatorCode>String</ClassificatorCode>
     </Accounting>
     }


    // --------------------
    {
     <InvoiceItem>
     <InvoiceItemGroup groupId="">
     <ItemEntry>
      <Description>Kodulehe arendustööd (sisumalli muudatused)</Description>
      <ItemReserve extensionId="eakInvoiceItemIdentifier">
      <InformationContent>1871764</InformationContent>
      </ItemReserve>
      <ItemReserve extensionId="eakVatCode">
      <InformationContent>km</InformationContent>
      </ItemReserve>
      <ItemUnit>1</ItemUnit>
      <ItemAmount>1</ItemAmount>
      <ItemPrice>35</ItemPrice>
      <ItemSum>35</ItemSum>
      <VAT>
      <SumBeforeVAT>35</SumBeforeVAT>
      <VATRate>20</VATRate>
      <VATSum>7</VATSum>
      </VAT>
      <ItemTotal>42</ItemTotal>
      </ItemEntry>
      </InvoiceItemGroup>
      </InvoiceItem>
    }
     InvoiceItem:=Doc.CreateElement('InvoiceItem');
     Invoice.Appendchild(InvoiceItem);

     InvoiceItemGroup:=Doc.CreateElement('InvoiceItemGroup');
     InvoiceItem.Appendchild(InvoiceItemGroup);
     TDOMElement(InvoiceItemGroup).SetAttribute('groupId','');


 // ---
 for i := 0 to  pBillLines.Count - 1 do
    begin
      pBillLine := pBillLines.Items[i] as TvMergedBillLines;
      // @@@
      ItemEntry :=Doc.CreateElement('ItemEntry');
      InvoiceItemGroup.Appendchild(ItemEntry);

      Item := Doc.CreateElement('Description');
      Item.AppendChild(Doc.CreateTextNode(_sx(pBillLine.FArtOrigDescr)));
      ItemEntry.AppendChild(Item);
      (*
      Item := Doc.CreateElement('RowNo');
      Item.AppendChild(Doc.CreateTextNode(IntToStr(i)));
      ItemEntry.AppendChild(Item);
      *)
      (*
        <xs:element name="RowNo" type="NormalTextType" minOccurs="0"/>
				<xs:element name="SerialNumber" type="ShortTextType" minOccurs="0"/>
				<xs:element name="SellerProductId" type="ShortTextType" minOccurs="0"/>
				<xs:element name="BuyerProductId" type="ShortTextType" minOccurs="0"/>
      *)


      (*
       if pBillLine.FArtCode <> '' then
         begin
          Item := Doc.CreateElement('SerialNumber');
          Item.AppendChild(Doc.CreateTextNode(pBillLine.FArtCode));
          ItemEntry.AppendChild(Item);
         end; // --

       // --
       if pBillLine.FArtId > 0 then
         begin
          Item := Doc.CreateElement('SellerProductId');
          Item.AppendChild(Doc.CreateTextNode(IntToStr(pBillLine.FArtId)));
          ItemEntry.AppendChild(Item);
        end;
      *)
      (*
        <ItemReserve extensionId="eakInvoiceItemIdentifier">
         <InformationContent>1871764</InformationContent>
        </ItemReserve>
        <ItemReserve extensionId="eakVatCode">
         <InformationContent>km</InformationContent>
        </ItemReserve>
      *)
     // <ItemUnit>1</ItemUnit>

      ItemDetailInfo := Doc.CreateElement('ItemDetailInfo');
      ItemEntry.AppendChild(ItemDetailInfo);

      Item:=Doc.CreateElement('ItemUnit');
      Item.AppendChild(Doc.CreateTextNode(_sx(pBillLine.FUnit)));
      ItemDetailInfo.AppendChild(Item);

      // <ItemAmount>1</ItemAmount>
      Item:=Doc.CreateElement('ItemAmount');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(floattostr(pBillLine.FQty),',','.',[]))));
      ItemDetailInfo.AppendChild(Item);

      // <ItemPrice>35</ItemPrice>
      Item:=Doc.CreateElement('ItemPrice');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pBillLine.FPrice]),',','.',[]))));
      ItemDetailInfo.AppendChild(Item);

      // <ItemSum>35</ItemSum>
      Item:=Doc.CreateElement('ItemSum');
      //     Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pBillLine.FArtSalepr-pBillLine.FCalcLineVatSum]),',','.',[]))));
      // 04.05.2014 Ingmar; ikka ItemSum on kogusumma !
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pBillLine.FPrice * pBillLine.FQty]),',','.',[]))));
      ItemEntry.AppendChild(Item);


      VAT:=Doc.CreateElement('VAT');
      ItemEntry.AppendChild(VAT);


      pSumBeforeVAT:=pBillLine.FArtSalepr - pBillLine.FCalcLineVatSum;

      Item:=Doc.CreateElement('SumBeforeVAT');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pSumBeforeVAT]),',','.',[]))));
      VAT.AppendChild(Item);

      pVATRate:=pBillLine.FVatPerc;
      Item:=Doc.CreateElement('VATRate');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(floattostr(pVATRate),',','.',[]))));
      VAT.AppendChild(Item);


      pVATSum:=pBillLine.FCalcLineVatSum;

      Item:=Doc.CreateElement('VATSum');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pVATSum]),',','.',[]))));
      VAT.AppendChild(Item);


      Item:=Doc.CreateElement('ItemTotal');
      Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pBillLine.FArtSalepr]),',','.',[]))));
      ItemEntry.AppendChild(Item);
    end;



     // ---
     (*
     ItemReserve:=Doc.CreateElement('ItemReserve');
     ItemEntry.Appendchild(ItemReserve);
     *)



    // --------------------
    {
    <PaymentInfo>
    <Currency>EUR</Currency>
    <PaymentDescription>229</PaymentDescription>
    <Payable>YES</Payable>
    <PayDueDate>2012-03-30</PayDueDate>
    <PaymentTotalSum>42</PaymentTotalSum>
    <PayerName>MINGI FIRMA</PayerName>
    <PaymentId>826392</PaymentId>
    <PayToAccount>221049920894</PayToAccount>
    <PayToName>Outzen OÜ</PayToName>
    </PaymentInfo>
    }
     PaymentInfo:=Doc.CreateElement('PaymentInfo');
     Invoice.Appendchild(PaymentInfo);


   // --- millist kontot kuvada ?!? kas kõik ?!?
   with pQry,SQL do
   try

     close;
     clear;
     Add(estbk_sqlclientcollection._SQLSelectAccountsWithBankData(false));
     paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
     Open;
//   while not eof do
     first;
     Item:=Doc.CreateElement('Currency');
     Item.AppendChild(Doc.CreateTextNode(_sx(pBillCurrency)));
     PaymentInfo.AppendChild(Item);

     Item:=Doc.CreateElement('PaymentDescription');
     Item.AppendChild(Doc.CreateTextNode(_sx('Arve nr '+pBillNr)));
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
     Item:=Doc.CreateElement('Payable');
     Item.AppendChild(Doc.CreateTextNode(_sx('YES')));
     PaymentInfo.AppendChild(Item);

     Item:=Doc.CreateElement('PayDueDate');
     Item.AppendChild(Doc.CreateTextNode(_sx(formatdatetime(CEBillFmt,pBillDuedate))));
     PaymentInfo.AppendChild(Item);

     // arve kogusumma;
  if pCal<0.00 then
     pCal:=0.00;

     Item:=Doc.CreateElement('PaymentTotalSum');
     Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pCal]),',','.',[]))));
     PaymentInfo.AppendChild(Item);

     Item:=Doc.CreateElement('PayerName');
     Item.AppendChild(Doc.CreateTextNode(_sx(pCustomername)));
     PaymentInfo.AppendChild(Item);

     Item:=Doc.CreateElement('PaymentId');
     Item.AppendChild(Doc.CreateTextNode(_sx(pBillNr)));
     PaymentInfo.AppendChild(Item);

     // <PayToAccount>10002028538006</PayToAccount>
     // <PayToName>TESTMÜÜJA AS</PayToName>
     Item:=Doc.CreateElement('PayToAccount');
     Item.AppendChild(Doc.CreateTextNode(_sx(fieldbyname('account_nr').asString)));
     PaymentInfo.AppendChild(Item);

     Item:=Doc.CreateElement('PayToName');
     Item.AppendChild(Doc.CreateTextNode(_sx(estbk_globvars.glob_currcompname)));
     PaymentInfo.AppendChild(Item);
     {
     DirectDebitPayeeContract Number Panga ja raha saaja vahel sõlmitud otsekorralduse lepingu number (Saajalepingu number). ShortTextType EI
     DirectDebitPayerNumber Otsekorralduse maksetunnus (viitenumber, kliendikood, vms.). ReferenceType EI
     }
     // ---
    finally
     close;
     clear;
    end;



     // --- hetkel vaid üks arve !
     Footer:= Doc.CreateElement('Footer');
     Root.Appendchild(Footer);

     Item:=Doc.CreateElement('TotalNumberInvoices');
     Item.AppendChild(Doc.CreateTextNode(_sx('1')));
     Footer.AppendChild(Item);

     Item:=Doc.CreateElement('TotalAmount');
     Item.AppendChild(Doc.CreateTextNode(_sx(stringreplace(format(estbk_types.CCurrentMoneyFmt2,[pCal]),',','.',[]))));
     Footer.AppendChild(Item);

     // ---
     XMLWrite.WriteXML(Doc.DocumentElement,pStr);

     {
     assignfile(pTest,'c:\earve.xml');
     rewrite(pTest);
     writeln(pTest,pStr.DataString);
     closefile(pTest);
     }
     result:=utf8decode(pStr.DataString);

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

