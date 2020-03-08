unit estbk_lib_fin_sampo;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  ZDataset, ZAbstractRODataset, Classes, SysUtils, Math, dialogs,
  DOM, XMLRead, XMLWrite, XMLCfg, XMLUtils,estbk_globvars, estbk_types;

type
  TFI_camt_053_item = class(TCollectionItem)
  protected
    FRecvAccountIBAN : AStr; // raha saaja konto nr
    FBankName : AStr;
    FBankBIC : AStr;
    FRefs : AStr;
    FCurrency  : AStr;
    FIncomeSum : Double;
    FTransType : AStr;
    FBankTransactionCode: AStr;
    FStatus : AStr;
    FBookingDateStr : AStr;
    FValDateStr     : AStr;
    FTransactionId  : AStr;
    FDebtor : AStr;
    FDebtorAccount : AStr;
    FCreditor : AStr; // DEMO2 AS maksja
    FCreditorAccount : AStr; // Maksja konto
    FDescript  : AStr; // Makse kirjeldus
    FError : AStr;
  public
    property BankName : AStr read FBankName;
    property BankBIC : AStr read FBankBIC;
    property RecvAccountIBAN : AStr read FRecvAccountIBAN;
    property Refs: AStr read FRefs;
    property Currency: AStr read FCurrency;
    property IncomeSum: Double read FIncomeSum;
    property TransType : AStr read FTransType;
    property BankTransactionCode: AStr read FBankTransactionCode;
    property Status : AStr read FStatus;
    property BookingDateStr : AStr read FBookingDateStr;
    property ValDateStr : AStr read FValDateStr;
    property TransactionId : AStr read FTransactionId;
    property Debtor : AStr read FDebtor;
    property DebtorAccount : AStr read FDebtorAccount;
    property Creditor : AStr read FCreditor;
    property CreditorAccount : AStr read FCreditorAccount;
    property Descript : AStr read FDescript;
    property Error : AStr read FError;
    function Validated : Boolean;
  end;

  // camt053_Tiliote
  TFI_camt_053 = class
  protected
    class function readNodeCont(const pNode : TDomNode) : AStr;
  public
    class function ReadCamt053Short(const pStream : TStringStream;
                                    const pColl : TCollection) : Boolean;
    // pole vaja; eelmine funktsioon oskab lugeda camt 052 ja camt 053
    class function ReadCamt053Full(const pStream : TStringStream;
                                   const pColl : TCollection) : Boolean; // deprecated
  end;

  // camt052_Saldo_Tapahtumaote
  TFI_camt_052 = class
  public
    class function Read(const pStream : TStringStream;
                       var pdtStart : TDatetime;
                       var pdtEnd : TDatetime;
                       var pOpeningBal : Double;
                       var pClosingBal : Double;
                       var pError : Astr) : Boolean;
  end;

// * NB specific to finnish customer;
// http://212.47.212.48/balance

(*

{"status":"ok","data":{"EUR":"57.49"}}

*)

// http://212.47.212.48/statements/2015-11-11/2015-11-30
(*

{"status":"ok","data":["<Ntry>  <NtryRef>1</NtryRef>  <Amt Ccy=\"EUR\">19.98</Amt>  <CdtDbtInd>DBIT</CdtDbtInd>  <Sts>BOOK</Sts>  <BookgDt>    <Dt>2015-11-17</Dt>  </BookgDt>  <ValDt>    <Dt>2015-11-17</Dt>  </ValDt>  <AcctSvcrRef>1511178E6073784906</AcctSvcrRef>  <BkTxCd>    <Domn>      <Cd>PMNT</Cd>      <Fmly>        <Cd>ICDT</Cd>        <SubFmlyCd>NTAV</SubFmlyCd>      </Fmly>    </Domn>    <Prtry>      <Cd>702 LASKUJEN MAKSUPALVELU</Cd>      <Issr>FFFS</Issr>    </Prtry>  </BkTxCd>  <AddtlInfInd>    <MsgNmId>DSH13TIQHFKB1F</MsgNmId>  </AddtlInfInd>  <NtryDtls>    <Btch>      <MsgId>SEPA-KING/1447766544</MsgId>      <PmtInfId>SEPA-KING/1447766544/1</PmtInfId>      <NbOfTxs>1</NbOfTxs>    </Btch>    <TxDtls>      <Refs>        <EndToEndId>NOTPROVIDED</EndToEndId>      </Refs>      <AmtDtls>        <InstdAmt>          <Amt Ccy=\"EUR\">19.98</Amt>        </InstdAmt>        <TxAmt>          <Amt Ccy=\"EUR\">19.98</Amt>        </TxAmt>      </AmtDtls>      <RltdPties>        <Cdtr>          <Nm>JUKKA HATVA</Nm>        </Cdtr>        <CdtrAcct>          <Id>            <IBAN>FI4080002250317400</IBAN>          </Id>        </CdtrAcct>      </RltdPties>      <RltdAgts>        <CdtrAgt>          <FinInstnId>            <BIC>DABAFIHH</BIC>          </FinInstnId>        </CdtrAgt>      </RltdAgts>      <RltdDts>        <AccptncDtTm>2015-11-17T01:01:01</AccptncDtTm>      </RltdDts>    </TxDtls>  </NtryDtls></Ntry>","<Ntry>  <NtryRef>1</NtryRef>  <Amt Ccy=\"EUR\">3.33</Amt>  <CdtDbtInd>CRDT</CdtDbtInd>  <Sts>BOOK</Sts>  <BookgDt>    <Dt>2015-11-11</Dt>  </BookgDt>  <ValDt>    <Dt>2015-11-11</Dt>  </ValDt>  <AcctSvcrRef>REFP1500001</AcctSvcrRef>  <BkTxCd>    <Domn>      <Cd>PMNT</Cd>      <Fmly>        <Cd>RCDT</Cd>        <SubFmlyCd>NTAV</SubFmlyCd>      </Fmly>    </Domn>    <Prtry>      <Cd>705 VIITESIIRROT</Cd>      <Issr>FFFS</Issr>    </Prtry>  </BkTxCd>  <NtryDtls>    <Btch>      <NbOfTxs>1</NbOfTxs>    </Btch>  </NtryDtls></Ntry>","<Ntry>  <NtryRef>2</NtryRef>  <Amt Ccy=\"EUR\">2.86</Amt>  <CdtDbtInd>CRDT</CdtDbtInd>  <Sts>BOOK</Sts>  <BookgDt>    <Dt>2015-11-11</Dt>  </BookgDt>  <ValDt>    <Dt>2015-11-11</Dt>  </ValDt>  <AcctSvcrRef>1511118E6057743331</AcctSvcrRef>  <BkTxCd>    <Domn>      <Cd>PMNT</Cd>      <Fmly>        <Cd>RCDT</Cd>        <SubFmlyCd>NTAV</SubFmlyCd>      </Fmly>    </Domn>    <Prtry>      <Cd>700 SIIRTO</Cd>      <Issr>FFFS</Issr>    </Prtry>  </BkTxCd>  <AddtlInfInd>    <MsgNmId>CS511WS1TOHD1F</MsgNmId>  </AddtlInfInd>  <NtryDtls>    <TxDtls>      <Refs>        <EndToEndId>201511118E6057743328</EndToEndId>      </Refs>      <AmtDtls>        <InstdAmt>          <Amt Ccy=\"EUR\">2.86</Amt>        </InstdAmt>        <TxAmt>          <Amt Ccy=\"EUR\">2.86</Amt>        </TxAmt>      </AmtDtls>      <RltdPties>        <Dbtr>          <Nm>HATVA JUKKA HEIKKI</Nm>          <PstlAdr>            <Ctry>FI</Ctry>          </PstlAdr>        </Dbtr>        <Cdtr>          <Nm>NOT PROVIDED</Nm>          <PstlAdr>            <Ctry>FI</Ctry>          </PstlAdr>        </Cdtr>      </RltdPties>      <RmtInf>        <Ustrd>siinä</Ustrd>      </RmtInf>      <RltdDts>        <AccptncDtTm>2015-11-11T01:01:01</AccptncDtTm>      </RltdDts>    </TxDtls>  </NtryDtls></Ntry>"]}

*)
procedure fin_parseCommonResp(const pJsonStream : TStringStream; var pcommstatus : AStr; var pdata : AStr; var pmessage : AStr);
function fin_parseBalance(const pJsonStream : TStringStream) : Double;


implementation
uses
  estbk_utilities, fpjson, jsonParser, jsonConf, jsonScanner, estbk_strmsg;

procedure fin_parseCommonResp(const pJsonStream : TStringStream; var pcommstatus : AStr; var pdata : AStr; var pmessage : AStr);
Var
  pparse : TJSONParser;
  pjdata  : TJSONData;
  pobj,psubobj   : TJSONObject;
  pname : AStr;
  i, j : Integer;
  pcam : TFI_camt_053_item;
begin

  if not assigned(pJsonStream) then
     Exit;



     pJsonStream.Seek(0, 0);
     pparse :=TJSONParser.Create(pJsonStream);

    try
      // pparse.Strict := true;
      pjdata := pparse.Parse;
      pobj := TJSONObject(pjdata);
      pcommstatus := '';
      pdata := '';
      pmessage := '';

      // {"status":"ok","data":{"EUR":"57.49"}}
      for i := 0 to pobj.Count - 1 do
        begin
           pname := pobj.Names[i];
        if pname = 'status' then
           pcommstatus := pobj.Items[i].AsString
        else
        if pname = 'data' then
        begin
        if not (pobj.Items[i] is TJSONObject) then
          begin
           pdata := JSONStringToString(pobj.Items[i].AsJson);
           pdata := stringreplace(pdata,'["', '', []);
           pdata := stringreplace(pdata,'"]', '', []);
          end;  // else ?!?!
        end else
        if pname = 'message' then
           pmessage :=  pobj.Items[i].AsString;
        end;

    finally
      pparse.Free;
    end;

end;

function fin_parseBalance(const pJsonStream : TStringStream) : Double;
Var
  pparse : TJSONParser;
  pdata  : TJSONData;
  pobj,psubobj   : TJSONObject;
  pname, pcommstatus, pcommstr  : AStr;
  i, j : Integer;
begin
  Result := 0.00;
  if not assigned(pJsonStream) then
     Exit;

  pJsonStream.Seek(0, 0);
  pparse :=TJSONParser.Create(pJsonStream);

  try
    // pparse.Strict := true;
    pdata := pparse.Parse;
    pobj := TJSONObject(pdata);
    pcommstatus := '';
    pcommstr := '';
    // {"status":"ok","data":{"EUR":"57.49"}}
    for i := 0 to pobj.Count - 1 do
      begin
         pname := pobj.Names[i];
      if pname = 'status' then
         pcommstatus := pobj.Items[i].AsString
      else
      if pname = 'data' then
      begin
          // pcommstr :=  pobj.Items[i].
          psubobj := TJSONObject(pobj.Items[i]);
      for j := 0 to psubobj.Count - 1 do
      if  ansiuppercase(psubobj.Names[j]) = 'EUR' then
        begin
          pcommstr := psubobj.Items[j].AsString;
          Result := StrToFloatDef(setRFloatSep(pcommstr), 0.00);
          break;
        end;
      end else
      if pname = 'message' then
         pcommstr :=  pobj.Items[i].AsString;
      end;

    if pcommstatus <> 'ok' then
       raise Exception.Create(pcommstr);
  finally
    pparse.Free;
  end;
end;

function _vsep(const pt : AStr) : AStr;
begin
  Result := StringReplace(pt, '.', sysutils.DecimalSeparator, []);
end;

{ TFI_camt_053_item }

function TFI_camt_053_item.Validated : Boolean;
begin
  Result := true; // TODO
end;

{ TFI_camt_053 }

class function TFI_camt_053.readNodeCont(const pNode : TDomNode) : AStr;
begin
  Result := '';
  if Assigned(pNode) then
    Result := Utf8Encode(Trim(pNode.TextContent));
  // 19.10.2017 Ingmar; vahel täitmata väli saab väärtuseks pankades NOTPROVIDED, meie võtame seda kui tühja stringi
  if AnsiUpperCase(Result) = 'NOTPROVIDED' then
    Result := '';
end;


// ---------------------------------------------------------------------------
// camt053_Saldo_Tapahtumaote
// ---------------------------------------------------------------------------
(*
Meaning of this values you can find here:

https://www.danskebank.com/en­uk/ci/Products­Services/Transaction­Services/Online­Services/Integration­Services/Documents/Formats/FormatDescriptionISO20022_camt.053.001.02/camt.053.001.02.pdf
*)
// KREEDIT: laekumine meile
// DEEBET : maksed kellegile

class function TFI_camt_053.ReadCamt053Short(const pStream : TStringStream;
                                             const pColl : TCollection) : Boolean;
const
  CNotProvided = 'NOTPROVIDED';

var
  Doc: TXMLDocument;
  pconv, pBankBIC, pBankName, pRecvAccountIBAN: AStr;
  pcItem : TFI_camt_053_item;
  iscamt053, iscamt052: Boolean;
  pIterator, Root, Amt, Attr, Dt, TxDtls, RmtInf, Dbtr, Cdtr, DbtrAcct, FinInstnId, Domn, Cd, BkTxCd, Prtry,
  NtryDtls, RltdPties, CdtrAcct, Id, Iban, Refs, GrpHdr, Svcr, Strd, CdtrRefInf, xmlns : TDomNode;
begin
  Result := False;
  try
    Doc := nil;
    ReadXMLFile(Doc, pStream);
    Root := Doc.DocumentElement;
    if Root.NodeName = 'Document' then
    begin
      // 09.09.2016 Ingmar; mingeid jamasid formaate me ei loe !
      xmlns := nil;
      if Assigned(Root.Attributes) then
        xmlns := Root.Attributes.GetNamedItem('xmlns');
      iscamt052 := Pos('camt.052', readNodeCont(xmlns)) > 0;
      iscamt053 := Pos('camt.053', readNodeCont(xmlns)) > 0;

      if not Assigned(xmlns) or (not iscamt052 and not iscamt053) then
        raise Exception.Create(estbk_strmsg.SEUnknownSEPAIncFormat);

      if iscamt053 then
        pIterator := Root.FindNode('BkToCstmrStmt') // Root.FirstChild;
      else if iscamt052 then
        pIterator := Root.FindNode('BkToCstmrAcctRpt');

      if not Assigned(pIterator) then
        Exit;

      GrpHdr := pIterator.FindNode('GrpHdr');
      // <GrpHdr>
      // <MsgId>10315662</MsgId>
      // <CreDtTm>2016-08-25T11:35:26</CreDtTm>
      // </GrpHdr>
      if iscamt053 then
        pIterator := pIterator.FindNode('Stmt')
      else if iscamt052 then
        pIterator := pIterator.FindNode('Rpt');

      if not Assigned(pIterator) then
        Exit;

      pIterator := pIterator.FirstChild;;
      while Assigned(pIterator) do
      begin
        {
         <Acct>
           <Id>
             <IBAN>EE307700771000685026</IBAN>
           </Id>
           <Ccy>EUR</Ccy>
           <Svcr>
             <FinInstnId>
               <BIC>LHVBEE22XXX</BIC>
               <Nm>AS LHV Pank</Nm>
               <PstlAdr>
                 <AdrTp>BIZZ</AdrTp>
                 <StrtNm>Tartu mnt.</StrtNm>
                 <BldgNb>2</BldgNb>
                 <PstCd>10145</PstCd>
                 <TwnNm>Tallinn</TwnNm>
                 <CtrySubDvsn>Harjumaa</CtrySubDvsn>
                 <Ctry>EE</Ctry>
               </PstlAdr>
             </FinInstnId>
           </Svcr>
         </Acct>
        }
        if pIterator.NodeName = 'Acct' then
        begin
          Id := pIterator.FindNode('Id');
          if Assigned(Id) then
          begin
            //  <Acct>
            //    <Id>
            //      <IBAN>EE352200221024651777</IBAN>
            //    </Id>
            // millal siin seda standardit muudeti, enne oli ID all ju välja nr ?
            pRecvAccountIBAN := readNodeCont(Id);
            if pRecvAccountIBAN = '' then
              pRecvAccountIBAN := readNodeCont(Id.FindNode('IBAN'));
          end;

          Svcr := pIterator.FindNode('Svcr');
          if Assigned(Svcr) then
          begin
            FinInstnId := Svcr.FindNode('FinInstnId');
            if Assigned(FinInstnId) then
            begin
              pBankBIC := Copy(readNodeCont(FinInstnId.FindNode('BIC')), 1, 8); // 8 märgine bic !
              pBankName :=  readNodeCont(FinInstnId.FindNode('Nm'));
            end;
          end;
        end else if pIterator.NodeName = 'Ntry' then
        begin
          pcItem := pColl.Add as TFI_camt_053_item;
          pcItem.FRecvAccountIBAN := pRecvAccountIBAN;
          pcItem.FBankBIC := pBankBIC;
          pcItem.FBankName := pBankName;
          // NtryRef = pIterator.FindNode('NtryRef'); // Unique reference for the entry.
          Amt := pIterator.FindNode('Amt');
          if Assigned(Amt) and Amt.HasAttributes then
          begin
            Attr := Amt.Attributes.GetNamedItem('Ccy');
            if Assigned(Attr) then
              pcItem.FCurrency := Attr.TextContent;
            pconv := setRFloatSep(Amt.TextContent);
            pcItem.FIncomeSum := StrToFloatDef(pconv, 0.00);
          end;

          pcItem.FTransType := readNodeCont(pIterator.FindNode('CdtDbtInd')); //Following values can be used DBIT = Debit CRDT = Credit
          pcItem.FStatus := readNodeCont(pIterator.FindNode('Sts')); // BOOK = Booked PDNG = Pending INFO = Information
          Dt := pIterator.FindNode('BookgDt');
          if Assigned(dt) then
            pcItem.FBookingDateStr := readNodeCont(Dt.FindNode('Dt')); // Date and time when an entry is posted to an account on the account servicer's books.
          // entrySet.ChildNodes['BkTxCd'].ChildNodes['Prtry'].ChildNodes['Cd'].Text;
          // BankTransactionCode
          {
               -<BkTxCd>
               -<Domn>
                 <Cd>PMNT</Cd>

                 -<Fmly>
                   <Cd>RCDT</Cd>
                   <SubFmlyCd>BOOK</SubFmlyCd>

                 </Fmly>
               </Domn>

               </BkTxCd>
          }
          BkTxCd := pIterator.FindNode('BkTxCd');
          if Assigned(BkTxCd) then
          begin
            // Varem ei olnud Domn tagi seal ! vaid oli kohe otse Cd väli
            Domn := BkTxCd.FindNode('Domn');
            if Assigned(Domn) then
              pcItem.FBankTransactionCode := readNodeCont(Domn.FindNode('Cd'))
             else
             begin
              Prtry := BkTxCd.FindNode('Prtry');
              if Assigned(Prtry) then
                pcItem.FBankTransactionCode := readNodeCont(Prtry.FindNode('Cd'))
             end;
          end;

          Dt := pIterator.FindNode('ValDt');
          if Assigned(dt) then
            pcItem.FValDateStr := readNodeCont(Dt.FindNode('Dt')); // Date and time assets become available the account owner (in a debitentry)
          pcItem.FTransactionId := readNodeCont(pIterator.FindNode('AcctSvcrRef'));// The account servicing institution's reference for the transaction (kreediti puhul maksja konto ?).

          NtryDtls := pIterator.FindNode('NtryDtls'); (* This provides a breakdown of the transaction details when the entry is 'batched'. If
                                                         the entry is not batched and transaction details are to be reported, then
                                                         transaction details must only occur once
                                                       *)
          if Assigned(NtryDtls) then
          begin
            TxDtls := NtryDtls.FindNode('TxDtls');
            if Assigned(TxDtls) then
            begin
              Refs := TxDtls.FindNode('Refs');
              if Assigned(Refs) then
              begin
                pcItem.FRefs := readNodeCont(Refs.FindNode('EndToEndId'));
                if AnsiUpperCase(pcItem.FRefs) = CNotProvided then
                  pcItem.FRefs := '';
              end;

              RltdPties := TxDtls.FindNode('RltdPties');  // Set of elements identifying the parties related to the underlying transaction
              // soome testfaili puhul failib !!
              if not Assigned(RltdPties) then
              begin
                pIterator := pIterator.NextSibling;
                Continue;
              end;

              Dbtr := RltdPties.FindNode('Dbtr');
              (*
                Party that owes an amount of money to the (ultimate) creditor

                For outward payments, report if different from account owner.
                For inward payments, report where available.
                In instances where the ReversalIndicator <RvslInd> is TRUE, the
                Creditor and Debtor must be the same as the Creditor and Debtor of the original entry. EPC mandated for SEPA
              *)
              if Assigned(Dbtr) then
                pcItem.FDebtor := readNodeCont(Dbtr.FindNode('Nm'));

              DbtrAcct := RltdPties.FindNode('DbtrAcct');
              if Assigned(DbtrAcct) then
              begin
                // DbtrAcct := DbtrAcct.FirstChild;
                id := DbtrAcct.FindNode('Id');
                pcItem.FDebtorAccount := readNodeCont(id);
              end;

              Cdtr := RltdPties.FindNode('Cdtr');  // DEMO2 AS maksja
              (*
                 Party Identification Component
               *)

              if Assigned(Cdtr) then
                pcItem.FCreditor := readNodeCont(Cdtr.FindNode('Nm')); // DEMO OÜ makse saaja firma

              (*
                 Information that enables the matching, ie,reconciliation, of a payment with the items that the payment is intended to
                 settle, eg,commercial invoices in an account receivable system.
              *)

              (*
                <RmtInf>
                  <Ustrd>arve maksmine</Ustrd>
                    <Strd>
                      <CdtrRefInf>
                        <Ref>709010579</Ref>
                      </CdtrRefInf>
                    </Strd>
                </RmtInf>
              *)

              // CreditorReferenceInformation
              RmtInf  := TxDtls.FindNode('RmtInf');
              if Assigned(RmtInf) then
              begin
                pcItem.FDescript := readNodeCont(RmtInf.FindNode('Ustrd'));
                Strd := RmtInf.FindNode('Strd');
                // siit proovime viitenr saada ?!?
                if Assigned(Strd) and (pcItem.FRefs = '') then
                begin
                  CdtrRefInf := Strd.FindNode('CdtrRefInf');
                  if Assigned(CdtrRefInf) then
                    pcItem.FRefs := readNodeCont(CdtrRefInf.FindNode('Ref'));
                end;
              end;

              (*
                 Unambiguous identification of the account of the creditor of the payment transaction
               *)
              CdtrAcct := RltdPties.FindNode('CdtrAcct');
              if Assigned(CdtrAcct) then
              begin
                Id := CdtrAcct.FindNode('Id');
                if Assigned(Id) then
                  pcItem.FCreditorAccount := readNodeCont(Id.FindNode('IBAN'));
              end;
            end;
          end;
        end;

          // RfrdDocInf
          pIterator := pIterator.NextSibling;
      end; // while
    end; // rootnode

  finally
    Doc.Free;
  end;
end;

class function TFI_camt_053.ReadCamt053Full(const pStream : TStringStream;
                                            const pColl : TCollection) : Boolean;
var
  Doc: TXMLDocument;
  pIterator, Root : TDomNode;
begin
  try
       Doc := nil;
       ReadXMLFile(Doc, pStream);
       Root := Doc.DocumentElement;
    if Root.NodeName = 'Document' then
     begin
        pIterator := Root.FirstChild;
       while  Assigned(pIterator) do
         begin

         // reaalne tehingurida
         if pIterator.NodeName = 'Ntry' then
           begin
           end else
         if pIterator.NodeName = 'FrToDt' then
           begin
           end else
         if pIterator.NodeName = 'TxsSummry' then
           begin
           (*
            <TxsSummry>
			    <!-- total number of statement entries for reconciliation -->
			    <TtlNtries>
				    <NbOfNtries>10</NbOfNtries>
			    </TtlNtries>
			    <!-- Deposits)-->
			    <TtlCdtNtries>
				    <NbOfNtries>6</NbOfNtries>
				    <Sum>23075.00</Sum>
			    </TtlCdtNtries>
			    <!-- withdrawls)-->
			    <TtlDbtNtries>
				    <NbOfNtries>4</NbOfNtries>
				    <Sum>9430.17</Sum>
			    </TtlDbtNtries>
			    <!-- reporting transaction code based summaries if service is considered useful-->
			    <!--
			    <TtlNtriesPerBkTxCd>
			    </TtlNtriesPerBkTxCd>
			    -->
	    </TxsSummry>
           *)
           (*

               SALDO 29.10.201023 644,83 +
               KÄYTTÖVARA 29.10.2010 33644,83 +

               PANOT YHTEENSÄ KPL 6 23075.00 +
               OTOT YHTEENSÄ KPL 4 9430.17 -

           *)
           end else
         if pIterator.NodeName = 'Bal' then
           begin
           (*
            <Bal>
		    <Tp>
			    <CdOrPrtry>
				    <Cd>OPBD</Cd>
			    </CdOrPrtry>
		    </Tp>
		    <!-- Limit value (not included into the balance)-->
		    <CdtLine>
			    <Incl>false</Incl>
			    <Amt Ccy="EUR">10000.00</Amt>
		    </CdtLine>
		    <Amt Ccy="EUR">10000.00</Amt>
		    <CdtDbtInd>CRDT</CdtDbtInd>
		    <!-- OPBD reports the same date as the CLBD (in a daily statement) -->
		    <Dt>
			    <Dt>2010-10-29</Dt>
		    </Dt>
	    </Bal>
	    <!-- PRCD balance might also be used as complement for OPBD since it is recommended by SWIFT MT940-conversion guideline -->
	    <Bal>
		    <Tp>
			    <CdOrPrtry>
				    <Cd>PRCD</Cd>
			    </CdOrPrtry>
		    </Tp>
		    <CdtLine>
			    <Incl>false</Incl>
			    <Amt Ccy="EUR">10000.00</Amt>
		    </CdtLine>
		    <Amt Ccy="EUR">10000.00</Amt>
		    <CdtDbtInd>CRDT</CdtDbtInd>
		    <!-- Since PRCD must equal with previous camt.053 CLBD also the dates reported should equal: PRCD reports same date as the previous statements CLBD date -->
		    <Dt>
			    <Dt>2010-10-28</Dt>
		    </Dt>
	    </Bal>
	    <Bal>
		    <!-- Booked closing balanceOpening balance on the next banking date -->
		    <Tp>
			    <CdOrPrtry>
				    <Cd>CLBD</Cd>
			    </CdOrPrtry>
		    </Tp>
		    <!-- Limit value (not included into the balance)-->
		    <CdtLine>
			    <Incl>false</Incl>
			    <Amt Ccy="EUR">10000.00</Amt>
		    </CdtLine>
		    <Amt Ccy="EUR">23644.83</Amt>
		    <CdtDbtInd>CRDT</CdtDbtInd>
		    <!-- equals -->
		    <Dt>
			    <Dt>2010-10-29</Dt>
		    </Dt>
	    </Bal>
	    <Bal>
		    <!-- CLAV in Finnish TITO-meaning is to used to report CLBD + Credit Line and in this sense CLAV may be omitted because of OPBD and CLBD embedded credit line.  -->
		    <!-- When used to report meaning like MT940 64-tag info the CLAV is used to report funds available at the reported date based on the value date based bookings-->
		    <Tp>
			    <CdOrPrtry>
				    <Cd>CLAV</Cd>
			    </CdOrPrtry>
		    </Tp>
		    <Amt Ccy="EUR">33644.83</Amt>
		    <CdtDbtInd>CRDT</CdtDbtInd>
		    <Dt>
			    <Dt>2010-10-29</Dt>
		    </Dt>
	    </Bal>
           *)
           end else
         if pIterator.NodeName = 'RltdAcct' then
           begin
           (*
           <RltdAcct>
           	    <!-- Parent account of the current account and not used at all in case of single account reported within statement -->
           	    <!-- TITO-structure of corporate group account statements is not repeated but Related Account info is enough to build up the structure at customer applications -->
           	    <Id>
           		    <IBAN>FI1533010001911270</IBAN>
           	    </Id>
           	    <Ccy>EUR</Ccy>
            </RltdAcct>
           *)
           end else
         if pIterator.NodeName = 'Acct' then
           begin
           (*
           			<!-- Bank Account of which statement is reported -->
			<Acct>
				<Id>
					<!-- always and only in IBAN format -->
					<IBAN>FI7433010001222090</IBAN>
				</Id>
				<!-- optional info from the bank to identify account type, in this case Current account -->
				<Tp>
					<Cd>CACC</Cd>
				</Tp>
				<!-- "Main" Currency of the account.  In case of multicurrency account there should be own Stmt -instances for each currency pocket statement per booking date -->
				<Ccy>EUR</Ccy>
				<!-- Account owner per bank's register -->
				<Ownr>
					<Nm>BANK ACCOUNT OWNER</Nm>
					<PstlAdr>
						<StrtNm>HELSINGINKATU</StrtNm>
						<BldgNb>31</BldgNb>
						<PstCd>00100</PstCd>
						<TwnNm>HELSINKI</TwnNm>
						<Ctry>FI</Ctry>
					</PstlAdr>
					<Id>
						<OrgId>
							<Othr>
								<!-- Finnish Organisation Id (Y-tunnus) -->
								<Id>12345678901</Id>
								<SchmeNm>
									<!-- Recipient's bank Id.  In case of Finnish Y-tunnus use "CUST" -->
									<Cd>BANK</Cd>
								</SchmeNm>
							</Othr>
						</OrgId>
					</Id>
				</Ownr>
				<!-- Reporting bank identified only by BIC but it is always available-->
				<Svcr>
					<FinInstnId>
						<BIC>ESSEFIHX</BIC>
					</FinInstnId>
				</Svcr>
			</Acct>
           *)
           end;
            pIterator := pIterator.NextSibling;
       end;
     end;
  finally
    Doc.Free;
  end;
end;


// ---------------------------------------------------------------------------
// camt052_Saldo_Tapahtumaote
// ---------------------------------------------------------------------------


class function TFI_camt_052.Read(const pStream : TStringStream;
                                 var pdtStart : TDatetime;
                                 var pdtEnd : TDatetime;
                                 var pOpeningBal : Double;
                                 var pClosingBal : Double;
                                 var pError : Astr) : Boolean;
var
  Doc: TXMLDocument;
  Root, BkToCstmrAcctRpt,GrpHdr, FrToDt, pDtIter, FrDtTm, ToDtTm,
  Rpt, OpeningBalance, ClosingBalance, pIterator, Bal, Amt : TDomNode;
  pStrFrDtTm, pStrToDtTm : AStr;

begin
{
<FrToDt>
				<!-- Times also sepcified to indicate transaction report time limits within day -->
				<FrDtTm>2010-10-30T10:00:00+02:00</FrDtTm>
				<ToDtTm>2010-10-30T12:00:00+02:00</ToDtTm>
			</FrToDt>
}
  try
     pStrFrDtTm := '';
     pStrToDtTm := '';
     pOpeningBal := 0.00;
     pOpeningBal := 0.00;
     pdtStart := now;
     pdtEnd := now;
     Doc := nil;

     ReadXMLFile(Doc, pStream);
     Root := Doc.DocumentElement;
  if Root.NodeName = 'Document' then
    begin
       BkToCstmrAcctRpt := Root.FirstChild;
    if BkToCstmrAcctRpt.NodeName = 'BkToCstmrAcctRpt' then
      begin
          pIterator := BkToCstmrAcctRpt.FirstChild;
          GrpHdr := nil;
          Rpt := nil;
          OpeningBalance := nil;
          ClosingBalance := nil;
       while Assigned(pIterator) do
        begin
        if pIterator.nodename = 'GrpHdr' then
          begin
           // TODO
          end else
        if pIterator.nodename = 'Rpt' then
          begin
             Rpt := pIterator;
             pDtIter := Rpt.FindNode('FrToDt');
          if (pStrFrDtTm = '') and assigned(pDtIter) then
             begin
                // pDtIter := pIterator.FirstChild;
                FrDtTm := pDtIter.FindNode('FrDtTm');
                ToDtTm := pDtIter.FindNode('ToDtTm');
             if Assigned(FrDtTm) then
                pStrFrDtTm := FrDtTm.TextContent;

             if Assigned(ToDtTm) then
                pStrToDtTm := ToDtTm.TextContent;
             end;

             // --
          if Assigned( Rpt.FindNode('Bal')) then
            begin

                 Rpt :=  Rpt.FirstChild;
             while Assigned( Rpt) do
              begin

                if Rpt.NodeName = 'Bal' then
                  if not Assigned(OpeningBalance) then
                   begin
                        OpeningBalance := Rpt;
                        Amt := OpeningBalance.FindNode('Amt');
                     if assigned(Amt) then
                        pOpeningBal := StrToFloatDef(_vsep(Amt.TextContent), 0.00);
                   end else
                  if not Assigned(ClosingBalance) then
                   begin
                      ClosingBalance := Rpt;
                      Amt := ClosingBalance.FindNode('Amt');
                   if assigned(Amt) then
                      pClosingBal := StrToFloatDef(_vsep(Amt.TextContent), 0.00);
                   end else
                   begin
                      raise Exception.Create('Unknown balance node !');
                   end;

                 // ---
                 Rpt := Rpt.NextSibling;
              end;

            end;

          end;
            //  intra-day reports the ITAV and ITBD
            pIterator := pIterator.NextSibling;
        end;
      end;
    end;

  finally
    Doc.Free;
  end;
end;


(*


<Bal>
			<!-- "Opening balance" as interim booked on specific time of intra-day.  May be also OPBD if it is really Opening Booked Balance for the reporting day -->
			<Tp>
				<CdOrPrtry>
					<Cd>ITBD</Cd>
				</CdOrPrtry>
			</Tp>
			<CdtLine>
				<Incl>false</Incl>
				<Amt Ccy="EUR">1000.00</Amt>
			</CdtLine>
			<Amt Ccy="EUR">1000.00</Amt>
			<CdtDbtInd>CRDT</CdtDbtInd>
			<Dt>
				<DtTm>2010-11-01T10:00:00+02:00</DtTm>
			</Dt>
</Bal>

---------------------------------------------

.2.4
Pankki palauttaa oletusarvon lisäksi palautesanomia seuraavasti:
Asiakas voi maksuaineiston Group Header
–
osion <Authstn>
-
tagissa määritellä
minkälaisen palautteen hän  pankista haluaa. Jos tietoa ei anneta, palautesanoma
annetaan oletusarvoi
sesti.
Maksujen palautesanoman sisällön voi valita käyttäen Feedback
=
xxx,  jossa xxx:n
tilalla käytetään yhtä alla olevista arvoista.
XBU = vain hylätyt ja veloitustilille palautetut maksut (ns. U
-
käännös)
XAU = vain onnistuneet maksut
XDU = hylätyt s
ekä onnistuneet maksut
XDY = hylätyt, onnistuneet maksut ja keskeneräiset maksut
Esim. <Authstn>Feedback=XBU</Authstn>
Feedback
–
arvo
n mukainen palaute tulee
kahdella eri maksujen käsittelyn
palautesanomalla.
Pain.002
v
ersion 3 muut
kuin oletusarvoiset pa
lautteet on kuvattu tarkemmin
version 3 liitteessä

*)

end.

