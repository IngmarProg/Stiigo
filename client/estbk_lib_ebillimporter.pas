unit estbk_lib_ebillimporter;
// 23.04.2014 Ingmar
{$mode objfpc}{$H+}
{$i estbk_defs.inc}


interface

uses
  Classes, ZConnection, ZDataset, ZSqlUpdate, SysUtils, contnrs, estbk_lib_commoncls,
  estbk_globvars, estbk_types, estbk_strmsg, estbk_clientdatamodule, estbk_utilities,
  DOM, XMLRead, XMLUtils{$ifdef debugmode}, Dialogs{$endif};

type
  EEBillReaderError = class(Exception);

  TCEBillReaderErrorLevel = (__err_information,
    __err_warning,
    __err_fatal);

  TOnEBillReaderError = procedure(const pTaginfo: AStr; const pError: AStr; const pErrorLevel: TCEBillReaderErrorLevel;
    var pResume: boolean) of object;

  TOnEBillProcessingUIMod = procedure(const pInvoiceNr: AStr; const pInvoiceDate: TDatetime; const pInvoiceDueDate: TDatetime;
    const pCustomername: AStr; const pCustomerregCode: AStr; const pCustomerVAT: AStr; const pVatDateObjList: TObjectList;
    const pItemObjList: TObjectList) of object;

type
  TEbillImporter = class
  protected
    FFilename: AStr;
    FReaderErrorEvent: TOnEBillReaderError;
    FEBillProcessingModEvent: TOnEBillProcessingUIMod;
    procedure ProcessData(const pInvoiceItemCnt: integer; const pInvoiceType: AStr; const pInvoiceDoc: AStr;
      const pInvoiceNumber: AStr; const pInvoiceContentText: AStr; const pInvoiceDate: AStr; const pDueDate: AStr;
      const pTotalSum: double; const pInvoiceSum: double; const pCurrency: AStr; const pObjSellerParty: TDomNode;
      const pObjBuyerParty: TDomNode; const pObjPaymentInfo: TDomNode; const pBillItems: TObjectList; const pVATSummaryItems: TObjectList);
  public
    property Filename: AStr read FFilename write FFilename;
    property OnEBillReaderError: TOnEBillReaderError read FReaderErrorEvent write FReaderErrorEvent;
    property OnEBillProcessingUIModEvent: TOnEBillProcessingUIMod read FEBillProcessingModEvent write FEBillProcessingModEvent;
    // üldiselt teeb tagataustal arve frame, edastab andmed ja loodab parimat !
    function Exec: boolean;
    constructor Create(const pReaderErrorEvent: TOnEBillReaderError; const pEBillProcessingUIModEvent: TOnEBillProcessingUIMod = nil);
      reintroduce;
    destructor Destroy; override;
  end;

implementation

uses Math;

constructor TEbillImporter.Create(const pReaderErrorEvent: TOnEBillReaderError; const pEBillProcessingUIModEvent: TOnEBillProcessingUIMod = nil);
begin
  inherited Create;
  FReaderErrorEvent := pReaderErrorEvent;
  FEBillProcessingModEvent := pEBillProcessingUIModEvent;
end;

procedure TEbillImporter.ProcessData(const pInvoiceItemCnt: integer; const pInvoiceType: AStr; const pInvoiceDoc: AStr;
  const pInvoiceNumber: AStr; const pInvoiceContentText: AStr; const pInvoiceDate: AStr; const pDueDate: AStr;
  const pTotalSum: double; const pInvoiceSum: double; const pCurrency: AStr; const pObjSellerParty: TDomNode;
  const pObjBuyerParty: TDomNode; const pObjPaymentInfo: TDomNode; const pBillItems: TObjectList; const pVATSummaryItems: TObjectList);
var
  presume: boolean;
  i, j: integer;
  pVAT: TEBillVATClass;
  pItem: TEBillItemClass;
  pCalcTotalSum: double;
  pInvoiceDateCnv: TDatetime;
  pDueDateCnv: TDatetime;
  pCustomername: AStr;
  pCustomerregCode: AStr;
  pCustomerVAT: AStr;
  pNode: TDomNode;
  pNodename: AStr;
begin

  pCustomername := '';
  pCustomerregCode := '';
  pCustomerVAT := '';

  try

    if assigned(pObjBuyerParty) then
      for i := 0 to pObjBuyerParty.ChildNodes.Count - 1 do
      begin
        pNode := pObjBuyerParty.ChildNodes.Item[i];
        pNodename := ansilowercase(pNode.NodeName);
        // <UniqueCode>13501</UniqueCode> ??? kliendi kood erinevate rp. tarkvarade vahel ???
        if pNodename = 'name' then  // <Name>ELUKAAR OÜ</Name>
          pCustomername := Utf8Encode(pNode.TextContent)
        else
        if pNodename = 'regnumber' then  // <Name>ELUKAAR OÜ</Name>
          pCustomerregCode := Utf8Encode(pNode.TextContent)
        else
        if pNodename = 'vatregnumber' then   // <VATRegNumber>EE100698053</VATRegNumber>
          pCustomerVAT := Utf8Encode(pNode.TextContent);
      end;
    // TODO tulevikus see data ka resolvida !
     (*
       <ContactData>
          <PhoneNumber>6061990</PhoneNumber>
          <LegalAddress>
            <PostalAddress1>Lahe 3/A.Alle 11</PostalAddress1>
            <City>Tallinn</City>
            <PostalCode>10150</PostalCode>
          </LegalAddress>
        </ContactData>
      *)
    // ***
    presume := True;
    if Trim(pInvoiceNumber) = '' then
      raise EEBillReaderError.CreateFmt(SEBill_numberIsMissing, [pInvoiceItemCnt]);

    if pBillItems.Count < 1 then
      raise EEBillReaderError.CreateFmt(SEBill_missingArticles, [pInvoiceNumber]);

    if (pCurrency <> '') and (Ansilowercase(pCurrency) <> Ansilowercase(estbk_globvars.glob_baseCurrency)) then
      raise EEBillReaderError.CreateFmt(SEBill_currencyNotSupported, [pCurrency]);

    if not odbcDateToLocalDate(pInvoiceDate, pInvoiceDateCnv) then
      raise EEBillReaderError.Create(SEBill_billDateIsInvalid);

    if not odbcDateToLocalDate(pDueDate, pDueDateCnv) then
      raise EEBillReaderError.Create(SEBill_billDueDateIsInvalid);


    // @@ kontrollime üle käibemaksude summa; see eeldab meil olemas võrdlusbaas !
    if pVATSummaryItems.Count > 0 then
      for i := 0 to pVATSummaryItems.Count - 1 do
      begin
        pVat := pVATSummaryItems.Items[i] as TEBillVATClass;
        pCalcTotalSum := 0.00;
        for j := 0 to pBillItems.Count - 1 do
        begin
          pItem := pBillItems.Items[i] as TEBillItemClass;
          if Math.SameValue(pItem.FVatRate, pVat.FVatRate, estbk_types.CEpsilon2) then
            pCalcTotalSum := pCalcTotalSum + pItem.FVatSum;
        end;

        if not Math.SameValue(pVat.FVATSum, pCalcTotalSum, estbk_types.CEpsilon2) then
          raise EEBillReaderError.CreateFmt(SEBill_vatsumIncorrect, [pVat.FVATSum, pCalcTotalSum, pVat.FVatRate]);
      end;

    pCalcTotalSum := 0.00;
    // @@ kontrollime üle artikli ridade summad
    for i := 0 to pBillItems.Count - 1 do
    begin
      pItem := pBillItems.Items[i] as TEBillItemClass;


      if assigned(FReaderErrorEvent) then
      begin
        presume := True;
        if (Trim(pItem.FItemUnit) = '') then
          FReaderErrorEvent(pInvoiceNumber, SEBill_articleUnitIsMissing, __err_warning, presume);

        if (Trim(pItem.FDescr) = '') then
        begin
          pItem.FDescr := ' --- ';
          FReaderErrorEvent(pInvoiceNumber, SEBill_articleDescrIsMissing, __err_warning, presume);
        end;

      end;



      pCalcTotalSum := pCalcTotalSum + pItem.FItemTotalSum;
      if not Math.SameValue(pItem.FItemSum + pItem.FVatSum, pItem.FItemTotalSum, estbk_types.CEpsilon2) then
        raise EEBillReaderError.CreateFmt(SEBill_articlesumIncorrect, [pItem.FItemSum + pItem.FVatSum, pItem.FItemTotalSum]);
    end;

    if not Math.SameValue(pCalcTotalSum, pTotalSum, estbk_types.CEpsilon2) then
      raise EEBillReaderError.CreateFmt(SEBill_articleTotalsumIncorrect, [pCalcTotalSum, pTotalSum]);

    if (pTotalSum < 0.00) or (pInvoiceSum < 0.00) then
      raise EEBillReaderError.Create(SEBill_billSumIsNegative);

    // @edastame töödeldava info edasi arve framele, kui äriloogika protsessib edasi
    if assigned(self.OnEBillProcessingUIModEvent) then
      self.OnEBillProcessingUIModEvent(pInvoiceNumber, pInvoiceDateCnv, pDueDateCnv, pCustomername, pCustomerregCode,
        pCustomerVAT, pVATSummaryItems, pBillItems);

    if assigned(FReaderErrorEvent) then
    begin
      presume := True;
      FReaderErrorEvent(pInvoiceNumber, 'OK', __err_information, presume);
    end;


  except
    on e: Exception do
      if assigned(FReaderErrorEvent) then
      begin
        FReaderErrorEvent(pInvoiceNumber, e.message, __err_fatal, presume);
        if not presume then
          SysUtils.Abort;
      end;

  end;
end;

function TEbillImporter.Exec: boolean;

  function _rDouble(const pVal: AStr; const pAllowNan: boolean = True): double;
  begin
    if pAllowNan then
      Result := StrToFloatDef(setRFloatSep(pVal), Math.NaN)
    else
      Result := StrToFloatDef(setRFloatSep(pVal), 0.00);
  end;

var
  Doc: TXMLDocument;
  node, node1, node2, node3, Root, Header, Footer, Invoice, InvoiceParties, SellerParty, BuyerParty, InvoiceInformation,
  InvoiceSumGroup, InvoiceItem, InvoiceItemGroup, ItemEntry, ContactData, VAT, Item, TextNode, LegalAddress, MailAddress, PaymentInfo: TDOMNode;
  pInvoiceItemCnt, i, j, k, z, w, x: integer;
  nodename, val: AStr;
  pInvoiceType, pInvoiceDoc, pInvoiceNumber, pInvoiceContentText, pInvoiceDate, pDueDate, pCurrency: AStr;
  pVATObjList: TObjectList;
  pItemObjList: TObjectList;
  pVATObj: TEBillVATClass;
  pItemObj: TEBillItemClass;
  pTotalSum, pInvoiceSum: double;

begin
  Result := False;
  if trim(FFilename) = '' then
    raise EEBillReaderError.Create(estbk_strmsg.SEFileNameIsMissing);

  if not FileExists(FFilename) then
    raise EEBillReaderError.CreateFmt(estbk_strmsg.SEFileNotFound, [FFilename]);

  // ehk peaks SAX readeriga tegema ?
  try
    pVATObjList := TObjectList.Create(True);
    pItemObjList := TObjectList.Create(True);

    pInvoiceItemCnt := 0;
    ReadXMLFile(Doc, FFilename);
    Root := Doc.FirstChild;
    if not Assigned(Root) or (AnsiLowerCase(Root.Nodename) <> 'e_invoice') then
      raise EEBillReaderError.Create(SEBill_rootnameIncorrect);

    for i := 0 to Root.ChildNodes.Count - 1 do
    begin

      node := Root.ChildNodes.Item[i];
      nodename := AnsiLowerCase(node.NodeName);

      if nodename = 'header' then
        Header := node
      else
      if nodename = 'footer' then
        footer := node
      else
      // <Invoice invoiceId="2072248" regNumber="000" accountNumber="">
      if nodename = 'invoice' then
      begin // @@INVOICE
        Inc(pInvoiceItemCnt);
        pInvoiceType := ''; // <Type type="DEB"/>
        pInvoiceDoc := '';// <DocumentName>Invoice</DocumentName>
        pInvoiceNumber := ''; // <InvoiceNumber>13518001</InvoiceNumber>
        pInvoiceContentText := '';
        // <InvoiceContentText>LENNUPILET/ID - FLUGSCHEIN/E X8YXGE Lufthansa Doris Scholz / Helmut Weiss        Flug 1   Samstag, 28.</InvoiceContentText>
        pInvoiceDate := ''; // <InvoiceDate>2014-02-17</InvoiceDate>
        pDueDate := ''; // <DueDate>2014-02-21</DueDate>
        pTotalSum := 0.00;
        pInvoiceSum := 0.00;


        node1 := nil;
        node2 := nil;
        node3 := nil;

        Header := nil;
        Footer := nil;
        Invoice := nil;
        InvoiceParties := nil;
        SellerParty := nil;
        BuyerParty := nil;
        InvoiceInformation := nil;
        InvoiceSumGroup := nil;
        InvoiceItem := nil;
        InvoiceItemGroup := nil;
        ItemEntry := nil;
        ContactData := nil;
        VAT := nil;
        Item := nil;
        TextNode := nil;
        LegalAddress := nil;
        MailAddress := nil;
        PaymentInfo := nil;

        pItemObjList.Clear;
        pVATObjList.Clear;
        Invoice := node;


        // @@INVOICE
        for j := 0 to Invoice.ChildNodes.Count - 1 do
        begin

          node := Invoice.ChildNodes.Item[j];
          nodename := AnsiLowerCase(node.NodeName);


          // ***
          if nodename = 'invoiceparties' then
          begin

            for k := 0 to node.ChildNodes.Count - 1 do
            begin
              nodename := AnsiLowerCase(node.ChildNodes.Item[k].NodeName);
              if nodename = 'sellerparty' then
                SellerParty := node.ChildNodes.Item[k]  // @@NOD
              else
              if nodename = 'buyerparty' then
                BuyerParty := node.ChildNodes.Item[k]; // @@NOD
            end;

          end
          else
          if nodename = 'invoiceinformation' then
          begin

            node1 := node;
            for z := 0 to node1.ChildNodes.Count - 1 do
            begin
              // ---
              node3 := node1.ChildNodes.Item[z];

              nodename := AnsiLowerCase(node3.NodeName);
              val := Utf8Encode(node3.TextContent);
              if nodename = 'type' then
                pInvoiceType := val
              else
              if nodename = 'documentname' then
                pInvoiceDoc := val
              else
              if nodename = 'invoicenumber' then
                pInvoiceNumber := val
              else
              if nodename = 'invoicecontenttext' then
                pInvoiceContentText := val
              else
              if nodename = 'invoicedate' then
                pInvoiceDate := val
              else
              if nodename = 'duedate' then
                pDueDate := val;
            end;
          end
          else
          if nodename = 'invoicesumgroup' then
            for k := 0 to node.ChildNodes.Count - 1 do // LOOP
            begin
              node1 := node.ChildNodes.Item[k];
              nodename := AnsiLowerCase(node1.NodeName);
              //  <Balance/>
              if nodename = 'invoicesum' then
                pInvoiceSum := _rDouble(node1.TextContent)
              else
              if nodename = 'vat' then // >> KÄIBEMAKS
              begin
                pVATObj := TEBillVATClass.Create;
                pVATObjList.Add(pVATObj);
                for z := 0 to node1.ChildNodes.Count - 1 do
                begin
                  node3 := node1.ChildNodes.Item[z];
                  nodename := AnsiLowerCase(node3.NodeName);
                  val := node3.TextContent;
                  if nodename = 'sumbeforevat' then
                    pVATObj.FSumBefVat := _rDouble(val)
                  else
                  if nodename = 'vatrate' then
                    pVATObj.FVatRate := _rDouble(val)
                  else
                  if nodename = 'vatsum' then
                    pVATObj.FVATSum := _rDouble(val);
                end;
              end
              else // << KÄIBEMAKS
              if nodename = 'totalsum' then
              begin
                pTotalSum := _rDouble(node1.TextContent);
              end
              else
              if nodename = 'currency' then
                pCurrency := Trim(Utf8Encode(node1.TextContent));


              // <Extension extensionId="TotalVATSum"><InformationContent>0.00</InformationContent></Extension>
              // ---
            end
          else // LOOP
          // NB artikli read !
          if nodename = 'invoiceitem' then
          begin

            for k := 0 to Node.ChildNodes.Count - 1 do // LOOP
            begin

              node1 := Node.ChildNodes.Item[k];
              nodename := AnsiLowerCase(node1.NodeName);

              // --
              if nodename = 'invoiceitemgroup' then // @invoiceitemgroup
              begin

                // loop da loop; otsime nüüd itementry !!!
                for z := 0 to Node1.ChildNodes.Count - 1 do
                begin

                  if Ansilowercase(Node1.ChildNodes.Item[z].NodeName) = 'itementry' then
                  begin
                    pItemObj := TEBillItemClass.Create;
                    pItemObjList.Add(pItemObj);

                    for x := 0 to Node1.ChildNodes.Item[z].ChildNodes.Count - 1 do
                    begin // @1

                      node2 := Node1.ChildNodes.Item[z].ChildNodes.Item[x];


                      // ---
                      nodename := Ansilowercase(node2.NodeName);
                      val := Utf8Encode(node2.TextContent);

                      if nodename = 'description' then
                        pItemObj.FDescr := val
                      else
                      if nodename = 'itemunit' then
                        pItemObj.FItemUnit := val
                      else
                      if nodename = 'itemamount' then
                        pItemObj.FItemAmount := _rDouble(val, False)
                      else
                      if nodename = 'itemprice' then
                        pItemObj.FItemPrice := _rDouble(val, False)
                      else
                      if nodename = 'itemsum' then
                        pItemObj.FItemSum := _rDouble(val, False)
                      else
                      if nodename = 'itemtotal' then
                        pItemObj.FItemTotalSum := _rDouble(val, False)
                      else
                      if nodename = 'vat' then // artikli rea käibemaks
                        for w := 0 to Node2.ChildNodes.Count - 1 do
                        begin
                          node3 := node2.ChildNodes.Item[w];
                          nodename := AnsiLowerCase(node3.NodeName);

                          val := Utf8Encode(node3.TextContent);
                          if nodename = 'sumbeforevat' then
                            pItemObj.FSumBefVat := _rDouble(val, False)
                          else
                          if nodename = 'vatrate' then
                            pItemObj.FVatRate := _rDouble(val, False)
                          else
                          if nodename = 'vatsum' then
                            pItemObj.FVatSum := _rDouble(val, False);
                        end; // --

                    end;  // @1

                    // ---
                  end;
                end;
              end; // @invoiceitemgroup
              // ---
            end;
          end
          else
          if nodename = 'paymentinfo' then
            PaymentInfo := node;
        end;

        // @@INVOICE
        // töötlemine !
        Self.ProcessData(pInvoiceItemCnt,
          pInvoiceType,
          pInvoiceDoc,
          pInvoiceNumber,
          pInvoiceContentText,
          pInvoiceDate,
          pDueDate,
          pTotalSum,
          pInvoiceSum,
          pCurrency,
          SellerParty,
          BuyerParty,
          PaymentInfo,
          pItemObjList,
          pVATObjList);
      end;
      // ---
    end;
  finally
    FreeAndNil(pVATObjList);
    FreeAndNil(pItemObjList);
    if Assigned(Doc) then
      FreeAndNil(Doc);
  end;
end;

destructor TEbillImporter.Destroy;
begin
  inherited Destroy;
end;


end.
