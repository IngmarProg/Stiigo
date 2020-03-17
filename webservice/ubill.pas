unit UBill;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, Math, DOM, XMLRead, XMLUtils, DateUtils,
  estbk_utilities, estbk_types, estbk_globvars, estbk_lib_commoncls,
  estbk_sqlclientcollection, estbk_lib_commonaccprop, estbk_lib_numerators;

{
<?xml version="1.0" encoding="utf-8"?>
<invoicerequest>
  <header>
    <customername>12345</customername>
    <customercode>1</customercode>
    <customeremail></customeremail>
    <billdate>2015-03-01</billdate>
    <orderhash></orderhash>
    <orderinformation></orderinformation>
  </header>
  <invoicelines>
    <article>
      <code>F0001</code>
      <qty>1.000</qty>
      <price>124</price>
      <vat>24.8</vat>
      <total>148.8</total>
    </article>
  </invoicelines>
</invoicerequest>
}

type
  TBill = class
  public
    class function generateBill(const pConn: TZConnection; const pXML: AStr; const pArticleTemplateCode: AStr): AStr;
  end;


implementation

const
  SCWebGenBill = 'Veebiarve nr: %s';
  SEBillReq_RootNameIncorrect = 'Root name incorrect';
  SEBillReq_HeaderIsMissing = 'Header tag is missing';
  SEBillReq_InvLinesIsMissing = 'Invoicelines tag is missing ';
  SEBillReq_CustcodeIsMissing = 'Customer code is missing';
  SEBillReq_CustcodeNotFound = 'Customer not found';
  SEBillReq_IncorrectBDate = 'Incorrect invoice date';
  SEBillReq_IncorrectDueDate = 'Incorrect due date';

  SEBillReq_ArtCodeIsMissing = 'Article code is missing';
  SEBillReq_ArtPriceIsMissing = 'Article price is missing or incorrect';
  SEBillReq_ArtVATSumIsMissing = 'Article VAT sum is missing or incorrect';
  SEBillReq_ArtWCodeNotFound = 'Article with code %s not found';
  SEBillReq_ArtSaleAccMissing = 'Article doesn''t sale account not specified';
  SEBillReq_VATNotFound = 'VAT record not found';
  SEBillReq_VATAccNotAssigned = 'VAT account not assigned (check VAT settings)';
  SEBillReq_ArtVatSumIncorrect = 'Article VAT sum incorrect %f %f';
  SEBillReq_CustNotFound = 'Customer not found';
  SEBillReq_IncorrectArtPrice = 'Incorrect article price';
  SEBillReq_IncorrectAryQty = 'Incorrect article quantity ';
  SEBillReq_ArtTotalSumIncorrect = 'Total sum incorrect %f %f ';
  SEBillReq_ArticlesNotSpec = 'Articles are missing !';
  SEBillReq_AccPerClosed = 'Accounting period not found';


class function TBill.generateBill(const pConn: TZConnection; const pXML: AStr; const pArticleTemplateCode: AStr): AStr;
{
_SQLGetLastActArticlePrice = ' SELECT id, price,discount_perc'+
                             ' FROM articles_price_table'+
                             ' WHERE article_id=:article_id'+
                             '   AND type_=:type_'+
                             '   AND ends IS NULL';
}

  function __findCustomerId(const pQry: TZQuery; const pCustomerCode: AStr): integer;
  var
    pSQL: AStr;
  begin
    with pQry, SQL do
      try
        Close;
        Clear;
        pSQL := ' SELECT id ' + ' FROM client ' + ' WHERE regnr=%s ' + '   AND regnr<>''''' + '   AND company_id=%d ' +
          ' UNION ' + ' SELECT id ' + ' FROM client ' + ' WHERE client_code=%s' + '   AND client_code<>''''' + '   AND company_id=%d ';
        Add(format(pSQL, [QuotedStr(pCustomerCode), estbk_globvars.glob_company_id, QuotedStr(pCustomerCode),
          estbk_globvars.glob_company_id]));
        Open;
        if EOF or (RecordCount <> 1) then
          raise Exception.Create(SEBillReq_CustNotFound);

        Result := FieldByName('id').AsInteger;
      finally
        Close;
        Clear;
      end;
  end;

  function __createArticleByTemplate(const pQry: TZQuery; const pArticleTemplateCode: AStr;
    // externalcode from web;
  const pArticleCode: AStr; const FArticlename: AStr): integer;
  var
    pSQL: AStr;
  begin
    Result := -1;
    with pQry, SQL do
      try
        Close;
        Clear;
        Add('SELECT id FROM articles WHERE code=:FArticlecode AND company_id=:FCompanyid');
        ParamByname('FArticlecode').AsString := pArticleCode;
        ParamByname('FCompanyid').AsInteger := estbk_globvars.glob_company_id;
        Open;
        Result := FieldByName('id').AsInteger;
        if Result > 0 then
          Exit;

        Close;
        Clear;
        Add('SELECT nextval(''articles_id_seq'')  as nextid');
        Open;
        Result := FieldByName('nextid').AsInteger;


        Close;
        Clear;
        pSql := 'INSERT INTO articles(id,articles_groups_id,code,"name",unit,type_,vat_id,descr,' +
          'purchase_account_id,sale_account_id,expense_account_id,price_calc_meth,arttype_id, ' +
          'status,company_id,disp_web_dir)' + ' SELECT ' + ' :Fid, ' + ' a.articles_groups_id, ' + ' :FArticlecode, ' +
          ' :FArticlename, ' + ' a.unit, ' + ' a.type_, ' + ' a.vat_id, ' + ' a.descr, ' + ' a.purchase_account_id, ' +
          ' a.sale_account_id, ' + ' a.expense_account_id, ' + ' a.price_calc_meth, ' + ' a.arttype_id, ' +
          ' a.status, ' + ' a.company_id, ' + ' ''t''' + ' FROM articles a ' + ' WHERE a.code=:FTemplarticlecode' +
          '   AND a.company_id=:FCompanyid ';
        Add(pSql);
        ParamByname('Fid').AsInteger := Result;
        ParamByname('FTemplarticlecode').AsString := pArticleTemplateCode;
        ParamByname('FArticlecode').AsString := pArticleCode;
        ParamByname('FArticlename').AsString := FArticlename;
        ParamByname('FCompanyid').AsInteger := estbk_globvars.glob_company_id;
        ExecSQL;

      finally
        Close;
        Clear;
      end;
  end;

  // TODO käibemaksude qry tulemus tulevikus puhverdada
  procedure __findArticleParams(const pQry: TZQuery; const pBillline: TvMergedBillLines);
  var
    pSQL: AStr;
    pVATsum: double;
    pArtId: integer;
  begin
    with pQry, SQL do
      try
        Close;
        Clear;
        pSQL := ' SELECT a.*,ac.id as sale_acc_id ' + ' FROM articles a ' + ' LEFT OUTER JOIN accounts ac ON ' +
          // kontrollime, kas see konto ikka reaalselt ka olemas !
          ' ac.id = a.sale_account_id ';

        // ehk siis artiklite koodid ON juba stiigos olemas ja välisest süsteemist nad ei tule AUTOCREATE süsteemis
        if (trim(pArticleTemplateCode) = '') then
        begin
          pSQL := pSQL + ' WHERE a.code=%s ' + '  AND a.company_id=%d ' + '  AND a.type_ IN (%s,%s) ' + '  AND a.disp_web_dir=''t''';
          pSQL := format(pSQL, [quotedStr(pBillline.FArtCode), estbk_globvars.glob_company_id,
            quotedStr(estbk_types._CItemAsProduct), quotedStr(estbk_types._CItemAsUsrDefined)]);
        end
        else
          // võetakse stiigo artikkel malliks ja automaatselt luuakse need artiklid stiigosse
        begin
          pArtId := __createArticleByTemplate(pQry, pArticleTemplateCode, pBillline.FArtCode, pBillline.FArtDescr);
          pSQL := pSQL + format(' WHERE a.id=%d', [pArtId]);
        end;



        // --
        Add(pSql);
        Open;
        First;

        if EOF then
          raise Exception.CreateFmt(SEBillReq_ArtWCodeNotFound, [pBillline.FArtCode]);



        pBillline.FAccountID := FieldByName('sale_acc_id').AsInteger;
        if pBillline.FAccountID < 1 then
          raise Exception.Create(SEBillReq_ArtSaleAccMissing);



        pBillline.FArtId := FieldByName('id').AsInteger;
        pBillline.FUnit := FieldByName('unit').AsString;
        pBillline.FArtOrigDescr := FieldByName('name').AsString;

        pBillline.FVatID := FieldByName('vat_id').AsInteger;
        if (pBillline.FVatID = 0) or Math.isZero(pBillline.FCalcLineVatSum) then
          // järelikult pole käibemaksu kohuslane firma ja pöördumine ka korrektne
          Exit;

        // -- kontrollime üle siis km % ja summad
        Close;
        Clear;

        Add(estbk_sqlclientcollection._CSQLGetActiveVATId);
        ParamByname('vatid').AsInteger := pBillline.FVatID;
        Open;
        if EOF then
          raise Exception.Create(SEBillReq_VATNotFound);

        pVATsum := 0.00;
        if FieldByName('perc').AsFloat > 0.00 then
          pVATsum := RoundTo(RoundTo(pBillline.FPrice * pBillline.FQty, Z2) * (FieldByName('perc').AsFloat / 100), Z2);


        // @@@
        // vaatame, kas saadetud käibemaksu summa klapib !
        if not Math.IsZero(pBillline.FCalcLineVatSum - pVATsum, 0.01) or not Math.IsZero(pBillline.FVatPerc - FieldByName('perc').AsFloat, 0.01) then
          raise Exception.CreateFmt(SEBillReq_ArtVatSumIncorrect, [pBillline.FCalcLineVatSum, pVATsum]);

        pBillline.FVatAccountId := FieldByName('vat_account_id_s').AsInteger;
        if pBillline.FVatAccountId < 1 then
          raise Exception.Create(SEBillReq_VATAccNotAssigned);



      finally
        Close;
        Clear;
      end;
  end;


  function __createBill(const pQry: TZQuery; const pCustID: integer; const pBillDate: TDatetime; const pDueDate: TDatetime;
  const pCustEmail: AStr; const pOrderHash: AStr; const pOrderInform: AStr; const pArtItemsCollection: TCollection; const pRefNr: AStr = ''): AStr;
  var
    i, pAccRegId, pDCAccountId, pBillId, pAccperID, pSysDocId, pRecDocId: integer;
    pBillline: TvMergedBillLines;
    pBillNr, pAccEntryNr: AStr;
    pTotalSum, pVatsum, pRoundSum: double;
  begin
    Result := '';

    // numeraatorid käivitavad enda transaktsiooni !!!
    // MÜÜK
    pAccEntryNr := _nm.getUniqNumberFromNumerator(PtrUInt(self), '', pBillDate, False, estbk_types.CAccSBill_rec_nr, False);

    pBillNr := _nm.getUniqNumberFromNumerator(PtrUInt(self), '', pBillDate, False, estbk_types.CBill_doc_nr);

    try
      pQry.Connection.StartTransaction;
      // @@

      with pQry, SQL do
        try
          Close;
          Clear;
          Add(estbk_sqlclientcollection._SQLCheckAccperiod);
          ParamByname('accdate').AsDateTime := pBillDate;
          ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          Open;
          pAccperID := FieldByName('id').AsInteger;
          if (pAccperID < 1) or (FieldByName('status').AsString <> 'O') then
            raise Exception.Create(SEBillReq_AccPerClosed);


          // -- teeme default kande kirje
          Close;
          Clear;
          Add(estbk_sqlclientcollection._CSQLInsertNewAccReg2);
          ParamByname('entrynumber').AsString := pAccEntryNr;
          ParamByname('transdate').AsDateTime := pBillDate;
          ParamByname('transdescr').AsString := format(SCWebGenBill, [pBillNr]);
          ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          ParamByname('rec_changed').AsDateTime := now;
          ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          ParamByname('type_').AsString := 'B'; // müügiarve !
          ParamByname('accounting_period_id').AsInteger := pAccperID; // milline kande periood ?!!?
          Open;
          pAccRegId := FieldByName('id').AsInteger;


          // dokumendid kõikjal paika !
          Close;
          Clear;
          add(estbk_sqlclientcollection._CSQLInsertNewDoc2);
          //parambyname('document_nr').asString:=pNextDocSystemNr;
          parambyname('document_nr').AsString := pBillNr;
          parambyname('document_date').asDate := pBillDate;
          parambyname('sdescr').AsString := format(SCWebGenBill, [pBillNr]); // jätame hetkel tühjaks ?


          // -----
          pSysDocId := estbk_lib_commonaccprop._ac.sysDocumentId[_dsSaleBillDocId];
          parambyname('document_type_id').AsInteger := pSysDocId;

          // ------------
          paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByName('rec_changed').AsDateTime := now;
          paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;
          Open;
          pRecDocId := FieldByName('id').AsInteger;


          Close;
          Clear;
          add(estbk_sqlclientcollection._CSQLInsertNewAccRegDoc);
          paramByName('accounting_register_id').AsInteger := pAccRegId;
          paramByName('document_id').AsInteger := pRecDocId;

          paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByName('rec_changed').AsDateTime := now;
          execSQL;



          Close;
          Clear;
          Add(estbk_sqlclientcollection._SQLInsertBillMainRec2);


          // kontrollida kas arve õiges rp. perioodis !
          // estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '',now,false,estbk_types.CBill_doc_nr)
          Result := pBillNr;

          pRoundSum := 0; // kuidas arvutada, jooksvalt summadelt ?
          pTotalSum := 0;
          pVatsum := 0;

          // --
          pDCAccountId := _ac.sysAccountId[_accBuyersUnpaidBills];

          // ---
          for i := 0 to pArtItemsCollection.Count - 1 do
          begin
            pBillline := pArtItemsCollection.Items[i] as TvMergedBillLines;

            pVatsum := pVatsum + pBillline.FCalcLineVatSum;
            pTotalSum := pTotalSum + pBillline.FQty * pBillline.FPrice;
            // 30.10.2015 Ingmar
            pRoundSum := pRoundSum + pBillline.FRoundCorr;
          end;

          ParamByname('client_id').AsInteger := pCustID;
          ParamByname('bill_number').AsString := pBillNr;
          ParamByname('bill_date').AsDateTime := pBillDate;
          ParamByname('due_date').AsDateTime := pDueDate;
          ParamByname('billing_addr2').AsString := copy(pOrderHash + ';' + pCustEmail + ';' + pOrderInform, 1, 255);
          ParamByname('bill_type').AsString := estbk_types._CItemSaleBill;
          ParamByname('descr').AsString := '';
          // global vars viia !
          ParamByname('overdue_perc').AsFloat := estbk_globvars.glob_overDuePerc;
          ParamByname('totalsum').AsFloat := pTotalSum;
          ParamByname('vatsum').AsFloat := pVatsum;
          ParamByname('vatsum2').AsFloat := 0.00;
          ParamByname('roundsum').AsFloat := pRoundSum;
          ParamByname('currency').AsString := estbk_globvars.glob_baseCurrency;
          ParamByname('currency_id').AsInteger := 0;
          ParamByname('currency_drate_ovr').AsFloat := 1.000;
          ParamByname('accounting_register_id').AsInteger := pAccRegId;
          ParamByname('dc_account_id').AsInteger := pDCAccountId;
          ParamByname('vat_flags').AsInteger := 0;
          ParamByname('credit_bill_id').AsInteger := 0;
          ParamByname('status').AsString := estbk_types.CBillStatusOpen;
          // TODO, mis või kes panna webservice kasutajaks ?!? Mingi kasutaja tuleks laadida ? webservice panna ?!?
          ParamByname('openedby').AsInteger := 0;
          ParamByname('closedby').AsInteger := 0;
          ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          ParamByname('paymentterm').AsInteger := 0;
          ParamByname('rec_changed').AsDateTime := now;
          ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          ParamByname('ref_nr').AsString := pRefNr;
          ParamByname('ref_nr_id').AsInteger := 0;
          Open;

          pBillId := FieldByName('id').AsInteger;
          // ---
          for i := 0 to pArtItemsCollection.Count - 1 do
          begin
            pBillline := pArtItemsCollection.Items[i] as TvMergedBillLines;
            Close;
            Clear;
            Add(estbk_sqlclientcollection._SQLInsertBillLine2);
            ParamByname('bill_id').AsInteger := pBillId;
            ParamByname('linetype').AsString := 'P';
            ParamByname('discount_perc').AsFloat := 0.00;
            ParamByname('cust_discount_id').AsInteger := 0;
            ParamByname('item_id').AsInteger := pBillline.FArtId;
            ParamByname('item_price').AsFloat := pBillline.FPrice;
            ParamByname('quantity').AsFloat := pBillline.FQty;
            ParamByname('total').AsFloat := pBillline.FArtPurcpr;

            ParamByname('vat_id').AsInteger := pBillline.FVatID;
            ParamByname('vat_account_id').AsInteger := pBillline.FVatAccountId;
            ParamByname('vat_rsum').AsFloat := pBillline.FCalcLineVatSum;
            ParamByname('descr2').AsString := pBillline.FArtOrigDescr;
            ParamByname('unit2').AsString := pBillline.FUnit;

            ParamByname('item_account_id').AsInteger := pBillline.FAccountID;
            ParamByname('object_id').AsInteger := 0;
            ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
            ParamByname('status').AsString := '';
            ParamByname('rec_changed').AsDateTime := now;
            ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
            ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
            ExecSQL;

          end;

        finally
          Close;
          Clear;
        end;

      pQry.Connection.Commit;
    except
      on e: Exception do
      begin
        if pQry.Connection.InTransaction then
          try
            pQry.Connection.Rollback;
          except
          end;
        raise Exception.Create(e.Message); // raise; lihtsalt võib AV'd põhjustada !

      end;
    end;
  end;

var
  doc: TXMLDocument;
  root, node, header, invoicelines, item: TDOMNode;
  xmlffile, nodename: AStr;
  i, j: integer;

  pcustname, pcustcode, pcustemail, pbilldate, pduedate, porderhash, porderinformation, parttotal, particlecode,
  particledescr, particleprice, particleqty, particlevat, pcustmrefnr, partvatperc, partroundval: AStr;
  partpriced, partvatd, partvatpercd, partqtyd, parttotald, partroundvald: double;
  pbilldatev, pduedatev: TDatetime;
  pcustid: integer;
  pyear, pmonth, pday: word;

  pArtItemsCollection: TCollection;
  pBillline: TvMergedBillLines;
  pCommonQry: TZQuery;
  S: TStringStream;
  delta: double;
begin
  try
    S := TStringStream.Create(pXML);
    pCommonQry := TZQuery.Create(nil);
    pCommonQry.Connection := pConn;


    pArtItemsCollection := TCollection.Create(TvMergedBillLines);

    doc := nil;
    //ReadXMLFile(doc, xmlffile);
    ReadXMLFile(doc, s);

    root := doc.FirstChild;
    if not Assigned(root) or (AnsiLowerCase(root.Nodename) <> 'invoicerequest') then
      raise Exception.Create(SEBillReq_RootnameIncorrect);

    for i := 0 to root.ChildNodes.Count - 1 do
    begin
      node := root.ChildNodes.Item[i];
      nodename := AnsiLowerCase(node.NodeName);

      if nodename = 'header' then
        header := node
      else
      if nodename = 'invoicelines' then
        invoicelines := node;
    end; // ---

    if not assigned(header) then
      raise Exception.Create(SEBillReq_HeaderIsMissing);


    if not assigned(invoicelines) then
      raise Exception.Create(SEBillReq_InvLinesIsMissing);


    for i := 0 to header.ChildNodes.Count - 1 do
    begin
      node := header.ChildNodes.Item[i];
      nodename := AnsiLowerCase(node.NodeName);
      if nodename = 'customername' then
        pcustname := Utf8Encode(node.TextContent)
      else
      if nodename = 'customercode' then
        pcustcode := Utf8Encode(node.TextContent)
      else
      if nodename = 'customeremail' then
        pcustemail := Utf8Encode(node.TextContent)
      else
      if nodename = 'billdate' then
        pbilldate := Utf8Encode(node.TextContent)
      else
      if nodename = 'duedate' then
        pduedate := Utf8Encode(node.TextContent)
      else
      if nodename = 'orderhash' then
        porderhash := Utf8Encode(node.TextContent)
      else
      if nodename = 'orderinformation' then
        porderinformation := Utf8Encode(node.TextContent)
      else
      // 06.10.2015 Ingmar
      if nodename = 'refnr' then
        pcustmrefnr := Utf8Encode(node.TextContent);
    end;

    if trim(pcustcode) = '' then
      raise Exception.Create(SEBillReq_CustcodeIsMissing);

    if trim(pbilldate) = '' then
      raise Exception.Create(SEBillReq_IncorrectBDate);

    // 2015-11-12
    //  dateutils.TryEncodeDateDay();
    pyear := strtointdef(copy(pbilldate, 1, 4), 0);
    pmonth := strtointdef(copy(pbilldate, 6, 2), 0);
    pday := strtointdef(copy(pbilldate, 9, 2), 0);

    if not TryEncodeDateTime(pyear, pmonth, pday, 0, 0, 0, 0, pbilldatev) then
      raise Exception.Create(SEBillReq_IncorrectBDate);


    // 14 päeva by default, peaks pikema olema ?!?
    pduedatev := pbilldatev + 14;
    if pduedate <> '' then
    begin
      pyear := strtointdef(copy(pduedate, 1, 4), 0);
      pmonth := strtointdef(copy(pduedate, 6, 2), 0);
      pday := strtointdef(copy(pduedate, 9, 2), 0);

      if not TryEncodeDateTime(pyear, pmonth, pday, 0, 0, 0, 0, pduedatev) then
        raise Exception.Create(SEBillReq_IncorrectDueDate);

    end;


    pcustid := __findCustomerId(pCommonQry, pcustcode);
    if pcustid < 1 then
      raise Exception.Create(SEBillReq_CustcodeNotFound);

    for i := 0 to invoicelines.ChildNodes.Count - 1 do
    begin
      item := invoicelines.ChildNodes.Item[i];
      nodename := AnsiLowerCase(item.NodeName);
      if (nodename <> 'article') then
        continue;

      // @@
      particlecode := '';
      particleqty := '';
      particleprice := '';
      particlevat := '';
      partvatperc := '';
      particledescr := '';
      partroundval := '';


      // artiklite infot
      for j := 0 to item.ChildNodes.Count - 1 do
      begin
        node := item.ChildNodes.Item[j];
        nodename := AnsiLowerCase(node.NodeName);
        if nodename = 'code' then
          particlecode := trim(Utf8Encode(node.TextContent))
        else
        if nodename = 'price' then
          particleprice := trim(Utf8Encode(node.TextContent))
        else
        if nodename = 'qty' then
          particleqty := trim(Utf8Encode(node.TextContent))
        else
        if nodename = 'vat' then
          particlevat := trim(Utf8Encode(node.TextContent))
        else
        if nodename = 'vatperc' then // 09.10.2015 Ingmar
          partvatperc := trim(Utf8Encode(node.TextContent))
        else
        if nodename = 'total' then
          parttotal := trim(Utf8Encode(node.TextContent))
        else
        if nodename = 'descr' then
          particledescr := trim(Utf8Encode(node.TextContent))
        else
        if nodename = 'roundval' then
          partroundval := trim(Utf8Encode(node.TextContent));
      end;


      if particlecode = '' then
        raise Exception.Create(SEBillReq_ArtCodeIsMissing);

      partpriced := Roundto(StrToFloatDef(setRFloatSep(particleprice), Math.Nan), Z2);
      partvatd := Roundto(StrToFloatDef(setRFloatSep(particlevat), Math.Nan), Z2);
      partvatpercd := Roundto(StrToFloatDef(setRFloatSep(partvatperc), 0.00), Z2); // 05.10.2015 Ingmar; soovituslik parameeter km protsent !
      partqtyd := Roundto(StrToFloatDef(setRFloatSep(particleqty), Math.Nan), Z3);
      parttotald := Roundto(StrToFloatDef(setRFloatSep(parttotal), Math.Nan), Z2);
      partroundvald := Roundto(StrToFloatDef(setRFloatSep(partroundval), 0.00), Z4);

      if trim(particledescr) = '' then
        particledescr := '-';


      // Loome mingid piirid mida kontrollida; igasugust jama ka läbi ei luba !
      if Math.IsNan(partpriced) or (partpriced < 0.00) or (partpriced > 60000) then
        raise Exception.Create(SEBillReq_ArtPriceIsMissing);

      if Math.IsNan(partvatd) or (partvatd < 0.00) or (partvatd > 30000) or (partvatd > partpriced) then
        raise Exception.Create(SEBillReq_ArtVATSumIsMissing);

      if Math.IsNan(partqtyd) or (partqtyd < 0.00) then
        raise Exception.Create(SEBillReq_IncorrectAryQty);

      delta := Roundto(partpriced * partqtyd + partvatd, Z2);
      if not Math.SameValue(delta, parttotald, Abs(IfThen(IsZero(partroundvald), 0.01, partroundvald))) then
        raise Exception.CreateFmt(SEBillReq_ArtTotalSumIncorrect, [delta, parttotald]);

      pBillLine := TvMergedBillLines.Create(pArtItemsCollection);
      pBillLine.FArtCode := particlecode;
      pBillLine.FArtDescr := particledescr;
      // 30.10.2015 Ingmar
      pBillLine.FRoundCorr := partroundvald;
      pBillLine.FArtSalepr := partpriced;
      // siia ...kogusumma
      pBillLine.FArtPurcpr := parttotald;

      // hoiame siin KM summat
      pBillLine.FCalcLineVatSum := partvatd;
      pBillLine.FPrice := partpriced;
      pBillLine.FQty := partqtyd;

      if Math.IsZero(partpriced) and not Math.IsZero(partvatd) then
        raise Exception.Create(SEBillReq_ArtVATSumIsMissing);

      if not Math.IsZero(partvatpercd) then
        pBillLine.FVatPerc := partvatpercd
      else
      if not Math.IsZero(partvatd) then
        pBillLine.FVatPerc := (partvatd / partpriced * partqtyd) * 100;

    end;

    // vaatame üle, kas artikli koodid olemas;
    for i := 0 to pArtItemsCollection.Count - 1 do
    begin
      pBillline := pArtItemsCollection.Items[i] as TvMergedBillLines;
      __findArticleParams(pCommonQry, pBillline);
    end;


    if pArtItemsCollection.Count > 0 then
    begin
      Result := __createBill(pCommonQry, pCustid, pBilldatev, pDuedatev, pCustemail, pOrderhash, pOrderinformation,
        pArtItemsCollection, pCustmrefnr);

    end
    else
      raise Exception.Create(SEBillReq_ArticlesNotSpec);



  finally

    if assigned(pArtItemsCollection) then
      FreeAndNil(pArtItemsCollection);

    if assigned(Doc) then
      FreeAndNil(Doc);


    if assigned(pCommonQry) then
    begin
      pCommonQry.Connection := nil;
      FreeAndNil(pCommonQry);
    end;

    FreeAndNil(S);
  end;
end;

end.