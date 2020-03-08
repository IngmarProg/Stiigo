unit estbk_lib_sepa;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface

uses ZDataset, ZAbstractRODataset, Classes, SysUtils, Math,
     DOM, XMLRead, XMLWrite, XMLCfg, XMLUtils,estbk_globvars, estbk_types;

type
    TSepaPaymentCollItem = class(TCollectionItem)
    protected
      FPaymentId : Integer;
      FPaymentDate : TDatetime;
      FCompanyName : AStr;
      FCompanyBankAccountNr : AStr;
      FCompanyBankBic : AStr;
      FPaymentSum : Double;
      FPaymentCurrency : AStr;
      FClientBankBic : AStr;
      FCompanyBankName : AStr;
      FClientBankName : AStr;
      FClientName : AStr;
      FClientCountry : AStr;
      FClientPostalAddr : AStr;
      FClientBankAccountNr : AStr;
      FPaymentInfoLine : AStr;
    public
      property PaymentId : Integer Read FPaymentId Write FPaymentId;
      property PaymentDate : TDatetime Read FPaymentDate Write FPaymentDate;
      property CompanyName : AStr Read FCompanyName Write FCompanyName;
      property CompanyBankAccountNr : AStr Read FCompanyBankAccountNr Write FCompanyBankAccountNr;
      property CompanyBankBic : AStr Read FCompanyBankBic Write FCompanyBankBic;
      property CompanyBankName : AStr Read FCompanyBankName Write FCompanyBankName;
      property PaymentSum : Double Read FPaymentSum Write FPaymentSum;
      property PaymentCurrency : AStr Read FPaymentCurrency Write FPaymentCurrency;
      property ClientBankBic : AStr Read FClientBankBic Write FClientBankBic;
      property ClientBankName : AStr Read FClientBankName Write FClientBankName;
      property ClientName : AStr Read FClientName Write FClientName;
      property ClientCountry : AStr Read FClientCountry Write FClientCountry;
      property ClientPostalAddr : AStr Read FClientPostalAddr Write FClientPostalAddr;
      property ClientBankAccountNr : AStr Read FClientBankAccountNr Write FClientBankAccountNr;
      property PaymentInfoLine : AStr Read FPaymentInfoLine Write FPaymentInfoLine;
    end;

    TSepaPayment = class
    public
      class function GenerateXMLFile(const pPaymentCreatedLongDt : TDatetime;
                                     const pPaymentLines : TCollection;
                                     const pBankSwift : AStr = '') : AStr; // DABAFIHX https://www-2.danskebank.com/link/swiftbic
    end;




implementation
uses estbk_utilities, Strutils, DateUtils{$IFDEF DEBUGMODE},Dialogs{$ENDIF};

// validate iban [A-Z]{2,2}[0-9]{2,2}[a-zA-Z0-9]{1,30}


// 03_pain 001 001 03_Examples_Foreign.pdf
class function TSepaPayment.GenerateXMLFile(const pPaymentCreatedLongDt : TDatetime;
                                            const pPaymentLines : TCollection;
                                            const pBankSwift : AStr = '') : AStr;
function _nfloat(pval : Double) : AStr;
begin
  Result := format(CCurrentMoneyFmt2,[pval]);
  Result := StringReplace(Result, ',', '.', []);
end;

function _nstring(pval : AStr) : AStr;
begin
  Result := pVal;
end;

var
  doc: TXMLDocument;
  rootnode, ptext, PmtTpInf, CstmrCdtTrfInitn, Cdtr, GrpHdr, CreDtTm, NbOfTxs, Nm, Cd,
  MsgId, InitgPty, PmtInf, PmtInfId, PmtId, PmtMtd,ReqdExctnDt, RmtInf,
  SvcLvl, Dbtr, DbtrAcct, Id_, DbtrAgt, Bic, ChrgBr, CdtTrfTxInf,
  InstrId, EndToEndId, Amt, InstdAmt, CdtrAgt, FinInstnId, PstlAdr,
  Ctry, AdrLine, CdtrAcct, RgltryRptg, Dtls, Ustrd, Iban : TDOMNode;
  i, paymentRecCnt : Integer;
  pStr : TStringStream;
  pday,pmonth,pyear,phour,pmin,psec,pmssec : Word;
begin
  Result := '';

  try
    DecodeDateTime(pPaymentCreatedLongDt, pyear, pmonth, pday,
                   phour, pmin, psec, pmssec);
    doc := TXMLDocument.Create;
    pStr:=TStringStream.Create('');

    rootnode := doc.CreateElement('Document');
    TDOMElement(rootnode).SetAttribute('xmlns', 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03');
    TDOMElement(rootnode).SetAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
    doc.Appendchild(rootnode);

    CstmrCdtTrfInitn := doc.CreateElement('CstmrCdtTrfInitn');
    rootnode.Appendchild(CstmrCdtTrfInitn);

    paymentRecCnt := pPaymentLines.Count;
    GrpHdr  := doc.CreateElement('GrpHdr');
    CstmrCdtTrfInitn.Appendchild(GrpHdr);

    ptext := Doc.CreateTextNode(FormatDateTime('yyyy-mm-dd', pPaymentCreatedLongDt) + 'T' + FormatDateTime('hh:nn:ss', pPaymentCreatedLongDt)); // @VAR
    MsgId := doc.CreateElement('MsgId');
    MsgId.Appendchild(ptext);
    GrpHdr.Appendchild(MsgId);


    ptext := Doc.CreateTextNode(FormatDateTime('yyyy-mm-dd', pPaymentCreatedLongDt) + 'T' + FormatDateTime('hh:nn:ss', pPaymentCreatedLongDt)); // @VAR
    CreDtTm := doc.CreateElement('CreDtTm');
    CreDtTm.Appendchild(ptext);
    GrpHdr.Appendchild(CreDtTm);


    ptext := Doc.CreateTextNode(IntToStr(paymentRecCnt));
    NbOfTxs := doc.CreateElement('NbOfTxs');
    NbOfTxs.Appendchild(ptext);
    GrpHdr.Appendchild(NbOfTxs);

    (*
      <MsgId>2015-10-08T11:27:34</MsgId>
      <CreDtTm>2015-10-08T00:00:00</CreDtTm>
      <NbOfTxs>6</NbOfTxs>
      <InitgPty>
        <Nm>HABAEE2X</Nm>
      </InitgPty>
     *)

 if pBankSwift <> '' then
    ptext := Doc.CreateTextNode(_nstring(pBankSwift)) // @VAR
 else
 if pPaymentLines.Count > 0 then
    ptext := Doc.CreateTextNode(_nstring(TSepaPaymentCollItem(pPaymentLines.Items[0]).CompanyBankBic))
 else
    ptext := Doc.CreateTextNode('');


    Nm :=  doc.CreateElement('Nm');
    Nm.AppendChild(ptext);

    InitgPty := doc.CreateElement('InitgPty');
    InitgPty.AppendChild(Nm);
    GrpHdr.Appendchild(InitgPty);


    for i := 0 to pPaymentLines.Count - 1 do
     with TSepaPaymentCollItem(pPaymentLines.Items[i]) do
      begin

          PmtInf := doc.CreateElement('PmtInf');
          CstmrCdtTrfInitn.AppendChild(PmtInf);

          ptext := Doc.CreateTextNode(IntToStr(FPaymentId));  // @VAR
          PmtInfId := doc.CreateElement('PmtInfId');
          PmtInfId.AppendChild(ptext);
          PmtInf.AppendChild(PmtInfId);

          PmtMtd := doc.CreateElement('PmtMtd'); // lühendi selgitus siia !
          ptext := Doc.CreateTextNode('TRF');
          PmtMtd.AppendChild(ptext);
          PmtInf.AppendChild(PmtMtd);
{
          <PmtInfId>32</PmtInfId>
          <PmtMtd />
          <PmtTpInf>TRF</PmtTpInf>
          <ReqdExctnDt />


          <PmtInfId>114895</PmtInfId><PmtMtd>TRF</PmtMtd><PmtTpInf><SvcLvl><Cd>SEPA</Cd></SvcLvl></PmtTpInf>
}

          PmtTpInf := doc.CreateElement('PmtTpInf');
          SvcLvl := doc.CreateElement('SvcLvl');
          PmtTpInf.AppendChild(SvcLvl);

          PmtInf.AppendChild(PmtTpInf);

          ptext := Doc.CreateTextNode('SEPA');
          Cd := doc.CreateElement('Cd');
          Cd.AppendChild(ptext);
          SvcLvl.AppendChild(Cd);



          ReqdExctnDt := doc.CreateElement('ReqdExctnDt');
          ptext := Doc.CreateTextNode(FormatDateTime('yyyy-mm-dd', FPaymentDate));  // @VAR
          ReqdExctnDt.AppendChild(ptext);
          PmtInf.AppendChild(ReqdExctnDt);

          Dbtr :=  doc.CreateElement('Dbtr');
          PmtInf.AppendChild(Dbtr);

          Nm :=  doc.CreateElement('Nm');
          ptext := Doc.CreateTextNode(UTF8Decode(FCompanyName));  // @VAR
          Nm.AppendChild(ptext);
          Dbtr.AppendChild(Nm);

          (*
          <Dbtr>
            <PstlAdr>
             <Ctry>DK</Ctry>
            </PstlAdr>
          </Dbtr>
          *)


          Id_ := doc.CreateElement('Id');
          Dbtr.AppendChild(Id_);

          DbtrAcct := doc.CreateElement('DbtrAcct');
          DbtrAcct.AppendChild(Id_);

          ptext := Doc.CreateTextNode(_nstring(FCompanyBankAccountNr));  // @VAR
          Iban := doc.CreateElement('IBAN');
          Iban.AppendChild(ptext);

          Id_.AppendChild(Iban);

          PmtInf.AppendChild(DbtrAcct);


          DbtrAgt := doc.CreateElement('DbtrAgt');
          PmtInf.AppendChild(DbtrAgt);



          FinInstnId := doc.CreateElement('FinInstnId');
          DbtrAgt.AppendChild(FinInstnId);

          (*
          <FinInstnId>
            <BIC>DABADKKK</BIC>
            <PstlAdr>
            <Ctry>DK</Ctry>
            </PstlAdr>
           </FinInstnId>
          *)

          ptext := Doc.CreateTextNode(_nstring(FCompanyBankBic));  // @VAR; SWIFT
          Bic := doc.CreateElement('BIC');
          Bic.AppendChild(ptext);
          FinInstnId.AppendChild(Bic);

          Nm :=  doc.CreateElement('Nm');
          ptext := Doc.CreateTextNode(_nstring(FCompanyBankName));  // @VAR
          Nm.AppendChild(ptext);
          FinInstnId.AppendChild(Nm);


          ChrgBr := doc.CreateElement('ChrgBr');
          ptext := Doc.CreateTextNode('SLEV'); // lühendi selgitus siia !
          ChrgBr.AppendChild(ptext);
          PmtInf.AppendChild(ChrgBr);


          CdtTrfTxInf := doc.CreateElement('CdtTrfTxInf');
          PmtInf.AppendChild(CdtTrfTxInf);

          PmtId := doc.CreateElement('PmtId');
          CdtTrfTxInf.AppendChild(PmtId);

          InstrId := doc.CreateElement('InstrId');
          ptext := Doc.CreateTextNode(IntToStr(FPaymentId));  // @VAR
          InstrId.AppendChild(ptext);
          PmtId.AppendChild(InstrId);

          EndToEndId := doc.CreateElement('EndToEndId');
          ptext := Doc.CreateTextNode(IntToStr(FPaymentId));  // @VAR
          EndToEndId.AppendChild(ptext);
          PmtId.AppendChild(EndToEndId);


          Amt := doc.CreateElement('Amt');
          CdtTrfTxInf.AppendChild(Amt);

          InstdAmt := doc.CreateElement('InstdAmt');
          Amt.AppendChild(InstdAmt);

          ptext := Doc.CreateTextNode(_nfloat(FPaymentSum)); // @VAR
          InstdAmt.AppendChild(ptext);
          TDOMElement(InstdAmt).SetAttribute('Ccy', _nstring(FPaymentCurrency));  // @VAR


          CdtrAgt := doc.CreateElement('CdtrAgt');
          CdtTrfTxInf.AppendChild(CdtrAgt);

          FinInstnId := doc.CreateElement('FinInstnId');
          CdtrAgt.AppendChild(FinInstnId);


          ptext := Doc.CreateTextNode(_nstring(FClientBankBic));  // @VAR; SWIFT
          Bic := doc.CreateElement('BIC');
          Bic.AppendChild(Bic);
          Bic.AppendChild(ptext);
          FinInstnId.AppendChild(Bic);


          Nm :=  doc.CreateElement('Nm');
          ptext := Doc.CreateTextNode(_nstring(FClientBankName));  // @VAR
          Nm.AppendChild(ptext);
          FinInstnId.AppendChild(Nm);

          Cdtr := doc.CreateElement('Cdtr');
          CdtTrfTxInf.AppendChild(Cdtr);
          Nm :=  doc.CreateElement('Nm');
          ptext := Doc.CreateTextNode(_nstring(UTF8Decode(FClientName)));  // @VAR
          Nm.AppendChild(ptext);

          Cdtr.AppendChild(Nm);


          PstlAdr := Doc.CreateElement('PstlAdr');
          Cdtr.AppendChild(PstlAdr);


          Ctry := Doc.CreateElement('Ctry');
          PstlAdr.AppendChild(Ctry);
          ptext := Doc.CreateTextNode(_nstring(Iso639_1ToIso639_3(FClientCountry)));  // @VAR
          Ctry.AppendChild(ptext);

          AdrLine := Doc.CreateElement('AdrLine');
          PstlAdr.AppendChild(AdrLine);

          ptext := Doc.CreateTextNode(_nstring(UTF8Decode(FClientPostalAddr)));  // @VAR
          AdrLine.AppendChild(ptext);


          CdtrAcct := Doc.CreateElement('CdtrAcct');
          CdtTrfTxInf.AppendChild(CdtrAcct);

          ptext := Doc.CreateTextNode(_nstring(FClientBankAccountNr));  // @VAR
          Id_ := doc.CreateElement('Id');

          Iban := Doc.CreateElement('IBAN');
          Iban.AppendChild(ptext);
          Id_.AppendChild(Iban);
          CdtrAcct.AppendChild(Id_);

          RgltryRptg := Doc.CreateElement('RgltryRptg');
          CdtTrfTxInf.AppendChild(RgltryRptg);

          Dtls := Doc.CreateElement('Dtls');
          Ctry := Doc.CreateElement('Ctry');
          RgltryRptg.AppendChild(Dtls);

          Dtls.AppendChild(Ctry);

       // Sepas peab olema alati täidetud
       if FClientCountry =  '' then
          FClientCountry := Iso639_1ToIso639_3(estbk_globvars.glob_active_language);
          ptext := Doc.CreateTextNode(_nstring(Iso639_1ToIso639_3(FClientCountry)));  // @VAR
          Ctry.AppendChild(ptext);


          RmtInf := Doc.CreateElement('RmtInf');
          CdtTrfTxInf.AppendChild(RmtInf);

          Ustrd :=  Doc.CreateElement('Ustrd');
          RmtInf.AppendChild(Ustrd);

          ptext := Doc.CreateTextNode(_nstring(UTF8Decode(FPaymentInfoLine)));  // @VAR
          Ustrd.AppendChild(ptext);


          (*
          <Amt>
           <InstdAmt Ccy="EUR">12.90</InstdAmt>
          </Amt>
          *)

          (*
          <ChrgBr>CRED</ChrgBr>  mida need lühendid märgivad ?
          <ChqInstr>
          <ChqTp>BCHQ</ChqTp>    mida need lühendid märgivad ?
          <DlvryMtd>
          <Cd>MLDB</Cd>
          </DlvryMtd>
          <FrmsCd>CROSSED</FrmsCd
          </ChqInstr>
          <Cdtr>
          <Nm>Creditor</Nm>
          <PstlAdr>
          <Ctry>DE</Ctry>
          <AdrLine>AdrLine1</AdrLine
          <AdrLine>AdrLine2</AdrLine
          </PstlAdr>
          </Cdtr>
          *)


          (*
            <PmtInf>
            <PmtInfId>114895</PmtInfId>
            <PmtMtd>TRF</PmtMtd>
            <PmtTpInf>
              <SvcLvl>
                <Cd>SEPA</Cd>
              </SvcLvl>
            </PmtTpInf>
            <ReqdExctnDt>2015-10-08</ReqdExctnDt>
            <Dbtr>
              <Nm>K. HEINONEN EESTI OÜ</Nm>
            </Dbtr>
            <DbtrAcct>
              <Id>
                <IBAN>EE582200221001196860</IBAN>
              </Id>
            </DbtrAcct>
            <DbtrAgt>
              <FinInstnId>
                <BIC>HABAEE2X</BIC>
              </FinInstnId>
            </DbtrAgt>
            <ChrgBr>SLEV</ChrgBr>
            <CdtTrfTxInf>
              <PmtId>
                <InstrId>114895</InstrId>
                <EndToEndId>114895</EndToEndId>
              </PmtId>
              <Amt>
                <InstdAmt Ccy="EUR">12.90</InstdAmt>
              </Amt>
              <CdtrAgt>
                <FinInstnId>
                  <BIC>HABAEE2X</BIC>
                  <Nm>Swedbank</Nm>
                </FinInstnId>
              </CdtrAgt>
              <Cdtr>
                <Nm>ELKDATA OÜ</Nm>
                <PstlAdr>
                  <Ctry>EE</Ctry>
                  <AdrLine>TALLINN Tondi 51-1</AdrLine>
                </PstlAdr>
              </Cdtr>
              <CdtrAcct>
                <Id>
                  <IBAN>EE962200221011388257</IBAN>
                </Id>
              </CdtrAcct>
              <RgltryRptg>
                <Dtls>
                  <Ctry>EE</Ctry>
                </Dtls>
              </RgltryRptg>
              <RmtInf>
                <Ustrd>Arve 758647</Ustrd>
              </RmtInf>
            </CdtTrfTxInf>
          </PmtInf>
          *)
      end;



    XMLWrite.WriteXML(Doc.DocumentElement,pStr);
    pStr.Seek(0, 0);
    Result := pStr.DataString;
  finally
    FreeAndNil(doc);
    FreeAndNil(pStr);
  end;
end;

end.

