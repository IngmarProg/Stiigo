unit estbk_lib_bankfiledefs;
// 25.08.2011 Ingmar; tore üllatus swedpank on ära kaotanud maksja konto !
{$mode objfpc}
{$H+}
interface

uses
  Classes, SysUtils, LCLProc, DOM, XMLRead, Contnrs, Dialogs, XMLWrite, MD5, Typinfo, estbk_lib_rep_errorcodes,
  estbk_globvars, estbk_clientdatamodule,
  estbk_lib_erprtwriter, estbk_types, estbk_utilities, estbk_strmsg;

const
  CResolvedDataType_asMisc = 0;
  CResolvedDataType_asBill = 1;
  CResolvedDataType_asOrder = 2;



type
  TBankDataSepType = (_sepUnknown,
    _sepTypeAsFixed,
    _sepTypeAsTab,
    _sepTypeAsSpace,
    _sepTypeAsSemi
    );

const
  CBankDataSepators: array[TBankDataSepType] of AChar = (#32,
    #32,
    #09,
    #32,
    ';');

// -- peavad olema täidetud
// Kuupäev
// Maksja/saaja nimi
// Valuuta
// Arhiveerimistunnus
type
  // 5 välja, mida ignoreerime, kuid arvestame välja sisu reeglitega, kas =K
  TBankDataFields = (
    fld_null,
    fld_rule1,
    fld_rule2,
    fld_rule3,
    fld_rule4,
    fld_rule5,
    // ---
    fld_bank_code,       // @1
    fld_bank_archcode,   // @2;tehingu arhiveerimiskood
    fld_bank_rec_status, // @3
    fld_bank_op_code,    // @4
    fld_payer_name,      // @5
    fld_payer_refnumber, // @6
    fld_payer_payer_mk_nr,// @7
    fld_payment_sum,   // @8 money
    fld_nr, // @9 reanumber
    fld_state_treasury_refnr,    // @10
    fld_receiver_account_number, // @11
    fld_receiver_account_number_iban, // @12
    fld_payment_date, // @13 date
    fld_payer_code,   // @14
    fld_description,  // @15
    fld_bank_description, // @16
    fld_incoming_date,   // @17 date
    fld_payer_account,         // @18 maksja konto nr !!!
    fld_payer_account_iban,    // @19
    fld_currency,        // @20
    fld_currency_drate_ovr,  // @21
    fld_receiver_name, // @22
    // --- manual !
    fld_predef_client_id,
    fld_predef_bill_id,
    fld_predef_order_id,
    fld_new_record_flag,
    fld_record_status_flag
    );

const
  TExtraRuleSet: set of TBankDataFields = [fld_null, fld_rule1, fld_rule2, fld_rule3, fld_rule4, fld_rule5];

type
  TBankDataFieldsSet = set of TBankDataFields;

type
  TDataLPArr = array[TBankDataFields] of integer;

type
  TDataStrArr = array[TBankDataFields] of AStr;

type
  TDataStrList = array[TBankDataFields] of TAStrList;

type
  TvardataArr = array[TBankDataFields] of variant;


type
  TBankFieldData = class
  protected
    FData: TvardataArr;
    FLineNr: integer;
  public
    property lineNr: integer read FLineNr;
    property Data: TvardataArr read FData write FData;
    constructor Create;
  end;


type
  TBankFileDef = class(TCollectionItem)
  protected
    FBankName: AStr;
    FBankCode: AStr;
    FBankDataSep: TBankDataSepType;
    FDataPos: TDataLPArr; // ntx telehansa, kus positsioonilt midagi lugeda
    FDataPLen: TDataLPArr;
    FDataLSkpRule: TDataStrList;
    FskipLines: TADynIntArray; // TODO: tulevikus reegel, et saame täpsustada millistelt ridadelt lugeda
    Fforceutf8: boolean;
  public
    property bankName: AStr read FBankName;
    property bankCode: AStr read FBankCode;

    property skipLines: TADynIntArray read FskipLines;

    property dataPos: TDataLPArr read FDataPos write FDataPos;
    property dataPLen: TDataLPArr read FDataPLen write FDataPLen;
    property inclDatalineRule: TDataStrList read FDataLSkpRule write FDataLSkpRule; // 25.08.2011 Ingmar; viisin strlist peale !
    property bankDataSep: TBankDataSepType read FBankDataSep write FBankDataSep;
    property forceutf8: boolean read Fforceutf8 write Fforceutf8;

    constructor Create(Acoll: TCollection); reintroduce;
    destructor Destroy; override;
  end;


type
  TBankFileReader = class
  private
    FReportWriter: TStatusRepWriter;
  protected
    FCurrBankFile: AStr; // pangafaili nimi, mida hetkel sisestatakse
    FBankFileDefsColl: TCollection;
    FRequiredFields: TBankDataFieldsSet;
    function internalLogWrite(const pErrorCode: AStr; const pLongDescr: AStr; // enamasti pikk veakirjeldus
      const pLineNr: integer; const pItemDescr: AStr = ''; const pItemIdf: integer = 0): boolean;

    function fieldNameAsStr(const pIndex: TBankDataFields): AStr;
    function performDataCpy(const pDataIndex: TBankDataFields; const pFieldData: TBankFieldData; const pDataFmt: AStr;
    // hetkel kasutusel vaid kuupäeva puhul
      const pStrData: AStr; var pErrorCode: AStr; var pLongErrDescr: AStr): boolean;


    function fieldMatchesDataLineRule(const pData: AStr; const pDataPos: integer; const pSkiprules: TAStrList): boolean;
  public
    // sisuliselt kirjutatakse objektlisti sisu andmebaasi temptabelisse !
    procedure processIncomeEntrys(const pBufferedData: TObjectList; const pFileName: AStr; const pMD5: AStr;
    // 29.11.2010 Ingmar; seoses käsitsi sisestusega ! override
      const pBankId: integer = 0; const pBankCode: AStr = ''; const pIncomingFromFile: boolean = True); virtual; abstract;

    function getBankFileDef(const pBankCode: AStr): TBankFileDef;
    // panga lokaalne arvelduskood või SWIFT ntx HABAEE2X; mitu koodi | eraldajaga !!!
    function loadBankIFrmtFileDefs(const pDefFile: AStr; var pDefError: Astr): boolean;
    // @@ alati esmalt laadida definitsioonid !
    function readFiles(const pBankFiles: TAStrList; const pBankCode: AStr; var pError: Astr): boolean;
      virtual; // loeb/töötleb andmed pangafailist, mille definitsioon klapib !
    function readSEPAFiles(const pBankFiles: TAStrList; const pBankCode: AStr; var pError: Astr): boolean; virtual;
    constructor Create(const pStatusRepInstance: TStatusRepWriter); reintroduce;
    destructor Destroy; override;
  end;


implementation

uses estbk_lib_bankfilesconverr, estbk_lib_fin_sampo;

constructor TBankFileDef.Create(Acoll: TCollection);
var
  i: TBankDataFields;
  tmp: TDataStrList;
begin
  inherited Create(Acoll);
  for i := low(TBankDataFields) to high(TBankDataFields) do
  begin
    tmp := inclDatalineRule;
    tmp[i] := TAStrList.Create;
    inclDatalineRule := tmp;
  end;
end;

destructor TBankFileDef.Destroy;
var
  i: TBankDataFields;
begin
  for i := low(TBankDataFields) to high(TBankDataFields) do
    if assigned(self.inclDatalineRule[i]) then
      self.inclDatalineRule[i].Free;

  inherited Destroy;
end;

// ---------
constructor TBankFieldData.Create;
var
  i: TBankDataFields;
begin
  inherited Create;
  for i := low(TBankDataFields) to high(TBankDataFields) do
    // parim viis varianti defineerida
    case i of
      fld_payment_sum,
      fld_currency_drate_ovr: FData[i] := currency(0.00);
      // hetke kp
      fld_payment_date,
      fld_incoming_date: FData[i] := Date;
      else
        FData[i] := AStr('');
    end;
end;



function TBankFileReader.internalLogWrite(const pErrorCode: AStr; const pLongDescr: AStr;
  // enamasti pikk veakirjeldus
  const pLineNr: integer; const pItemDescr: AStr = ''; const pItemIdf: integer = 0): boolean;
begin
  Result := True;
  self.FReportWriter.writeEntry(pErrorCode, pLongDescr, pLineNr, pItemDescr, pItemIdf);
end;


function TBankFileReader.loadBankIFrmtFileDefs(const pDefFile: AStr; var pDefError: Astr): boolean;
const
  CSepNames: array[TBankDataSepType] of AStr = ('',
    'fixed',
    'tab',
    'space',
    'semicolon');

var
  i, j: integer;
  k: TBankDataSepType;
  pXmlDoc: TXMLDocument;
  pRoot: TDomNode;
  pFileDef: TDomNode;
  pRPosNode: TDomNode;
  pAttrNode: TDomNode;
  pFieldData: TDomNode;
  pStrData: AStr;
  pNodeName: AStr;
  pInclDataLineRule: AStr;
  pFileDefName: AStr;
  pFieldNr: integer;
  pFieldLen: integer;
  pSeparator: TBankDataSepType;
  pSkipLines: TADynIntArray;
  pSkipLnStr: TAStrList;
  pSkipLnInt: integer;
  pBankFileDef: TBankFileDef;
  pFieldDatOrd: TBankDataFields;
  pForceUTF8: boolean;
  pTemp: TBankFileDef;
  pTempDataPos: TDataLPArr;
  pTempDataLen: TDataLPArr;
begin

(*
<income_file_defs>
 <income_file>
   <name>Telehansa formaat</name>
   <separator>fixed/tab/space/semicolon</separator>
   <skipline></skipline>
   <data>
    <rpos field="bank_code">
       <fieldnr>5</fieldnr>
       <fieldlen>15</fieldlen>
    </rpos>
   </data>
 </income_file>
</income_file_defs>
*)

  self.FBankFileDefsColl.Clear;
  Result := False;


  pForceUTF8 := False;
  pSkipLnInt := 0;
  pFieldNr := 0;
  pFieldLen := 0;
  pSkipLnStr := nil;
  pDefError := '';

  try
    pXmlDoc := nil;
    ReadXMLFile(pXmlDoc, pDefFile);
    pRoot := pXmlDoc.DocumentElement;

    if not assigned(pRoot) or (ansilowercase(pRoot.NodeName) <> 'income_file_defs') then
      raise Exception.Create(SEIncfRootElementNotFound);



    setlength(pskipLines, 1);
    for i := 0 to pRoot.ChildNodes.Count - 1 do
    begin
      pFileDef := pRoot.ChildNodes.Item[i];
      if ansilowercase(pFileDef.NodeName) = 'income_file' then
      begin

        // loome kirjeldamise klassi
        pBankFileDef := TBankFileDef.Create(self.FBankFileDefsColl);
        pFileDefName := '';

        if assigned(pFileDef.Attributes) then
        begin
          pAttrNode := pFileDef.Attributes.GetNamedItem('bank_code');
          if not assigned(pAttrNode) or (trim(pAttrNode.NodeValue) = '') then
            raise Exception.Create(estbk_strmsg.SEIncfBankCodeIsMissing);
        end
        else
          raise Exception.Create(estbk_strmsg.SEIncfBankCodeIsMissing);
        pBankFileDef.FBankCode := trim(pAttrNode.NodeValue);


        // kammime nüüd läbi alamelemendid
        pFileDef := pFileDef.FirstChild;
        while assigned(pFileDef) do
        begin

          pStrData := Trim(utf8encode(pFileDef.TextContent));
          pNodeName := Ansilowercase(pFileDef.Nodename);

          if (pNodeName = 'name') then
            pBankFileDef.FbankName := Copy(pStrData, 1, 1024)
          else
          if (pNodeName = 'skipline') then
            try
              pSkipLnStr := TAStrList.Create;
              pSkipLnStr.Delimiter := ',';
              pSkipLnStr.DelimitedText := pStrData;

              for  j := 0 to pSkipLnStr.Count - 1 do
              begin
                pSkipLnInt := strtointdef(pSkipLnStr.Strings[j], 0);
                if pSkipLnInt > 0 then
                begin
                  if pskipLines[0] = 0 then
                    pskipLines[0] := pSkipLnInt
                  else
                  begin
                    setlength(pskipLines, length(pskipLines) + 1);
                    pskipLines[length(pskipLines) - 1] := pSkipLnInt;
                  end;
                end;
              end;
            finally
              FreeAndNil(pSkipLnStr);
            end
          else
          if (pNodeName = 'separator') then
          begin
            pSeparator := _sepUnknown;
            for k := low(TBankDataSepType) to high(TBankDataSepType) do
              if CSepNames[k] = pStrData then
              begin
                pSeparator := k;
                break;
              end;
          end
          else
          // 19.03.2011 Ingmar
          if (pNodeName = 'forceutf8') then
          begin
            pForceUTF8 := estbk_utilities.isTrueVal(pStrData);
          end
          else
          // väljade pikkused
          if (pNodeName = 'data') then
          begin

            pRPosNode := pFileDef.FirstChild;
            while assigned(pRPosNode) do
            begin
              pNodeName := AnsiLowercase(pRPosNode.NodeName);
              if (pNodeName = 'rpos') then
              begin

                // --
                if not assigned(pRPosNode.Attributes) then
                  raise Exception.Create(estbk_strmsg.SEIncfDataFieldNotDefined);


                pAttrNode := pRPosNode.Attributes.GetNamedItem('field');
                if not assigned(pAttrNode) then
                  raise Exception.Create(estbk_strmsg.SEIncfDataFieldNotDefined);



                // küsime andmevälja nime
                pStrData := copy(trim(utf8encode(pAttrNode.TextContent)), 1, 255);
                // ---
                pFieldData := pRPosNode.FirstChild;
                if not assigned(pFieldData) or (pStrData = '') then
                  raise Exception.Create(estbk_strmsg.SEIncfDataFieldNotDefined);

                pStrData := 'fld_' + pStrData;
                pFieldDatOrd := TBankDataFields(GetEnumValue(TypeInfo(TBankDataFields), pStrData));

                if (cardinal(pFieldDatOrd) = high(cardinal)) or (pFieldDatOrd in [fld_predef_client_id,
                  fld_predef_bill_id, fld_predef_order_id, fld_new_record_flag, fld_record_status_flag]) then
                  raise Exception.createFmt(SEIncfUnknownDataField, [pStrData]);


                pInclDataLineRule := '';
                pAttrNode := pRPosNode.Attributes.GetNamedItem('includelineif');
                if assigned(pAttrNode) then
                begin
                  pInclDataLineRule := pAttrNode.TextContent;

                  // vana hea gt ja lt
                  pInclDataLineRule := stringreplace(pInclDataLineRule, '&gt;', '>', []);
                  pInclDataLineRule := stringreplace(pInclDataLineRule, 'lt;', '<', []);
                end;



                pFieldNr := 0;
                pFieldLen := 0;

                // null on vaid inforida, aga läbi selle saame ka öelda, millise rea tõmbame sisse !
                if (not (pFieldDatOrd in TExtraRuleSet)) or ((pFieldDatOrd in TExtraRuleSet) and (trim(pInclDataLineRule) <> '')) then
                begin

                  // otsime nüüd positsioonid üles !
                  while assigned(pFieldData) do
                  begin
                    pStrData := copy(trim(utf8encode(pFieldData.TextContent)), 1, 255);
                    pNodeName := ansilowercase(pFieldData.NodeName);

                    if pNodeName = 'fieldpos' then
                    begin
                      pFieldNr := strtointdef(pStrData, -1);
                    end
                    else
                    if pNodeName = 'fieldlen' then
                    begin
                      pFieldLen := strtointdef(pStrData, -1);
                    end;

                    // ------
                    pFieldData := pFieldData.NextSibling;
                  end;



                  if pFieldNr < 1 then
                    raise Exception.Create(estbk_strmsg.SEIncfFieldNrNotValid);


                  // kui antud reegel välja juures erineb, siis antud rida ei loeta sisse !
                  // pBankFileDef.InclDatalineRule[pFieldDatOrd] :=pInclDataLineRule;
                  // 25.08.2011 null data saab omada mitu tingimust erinevatel ridadel !
                  if pInclDataLineRule <> '' then
                    pBankFileDef.InclDatalineRule[pFieldDatOrd].AddObject(pInclDataLineRule, TObject(PtrInt(pFieldNr)));


                  if (pSeparator = _sepTypeAsFixed) and (pFieldLen < 1) then
                    raise Exception.Create(estbk_strmsg.SEIncfFieldLenNotValid);

                  pTemp := pBankFileDef;
                  // pBankFileDef.dataPos[pFieldDatOrd] := pFieldNr;
                  // pBankFileDef.dataPLen[pFieldDatOrd] := pFieldLen;
                  // Freepascal ei luba enam otse assigniga !
                  pTempDataPos := pTemp.dataPos;
                  pTempDataLen := pTemp.dataPLen;
                  pTempDataPos[pFieldDatOrd] := pFieldNr;
                  pTempDataLen[pFieldDatOrd] := pFieldLen;
                  pTemp.dataPos := pTempDataPos;
                  pTemp.dataPLen := pTempDataLen;
                  pBankFileDef := pTemp;
                end;

                // ---
              end; // rpos end
              pRPosNode := pRPosNode.NextSibling;
            end;


            // -- koostame klassi !
            // separaator defineerimata !
            if pSeparator = _sepUnknown then
              raise Exception.Create(estbk_strmsg.SEIncfFieldSepUnknown);



            // väärtustame ülejäänud väljad
            pBankFileDef.bankDataSep := pSeparator;
            pBankFileDef.forceutf8 := pForceUTF8;


            setlength(pBankFileDef.FskipLines, length(pskipLines));
            for j := low(pskipLines) to high(pskipLines) do
              pBankFileDef.skipLines[j] := pskipLines[j];



            // reset puhvrile !
            setlength(pskipLines, 1);
            pskipLines[0] := 0;
          end;

          // ---
          pFileDef := pFileDef.NextSibling;
        end;

  (*
<income_file_defs>
 <income_file>
   <name>Telehansa formaat</name>
   <separator>fixed/tab/space/semicolon</separator>
   <skipline></skipline>
   <data>
    <rpos field="bank_code">
       <fieldnr>5</fieldnr>
       <fieldlen>15</fieldlen>
    </rpos>
   </data>
 </income_file>
</income_file_defs>
*)
      end;
    end; // --




    Result := FBankFileDefsColl.Count > 0;
  except
    on e: Exception do
    begin
      pDefError := e.message;
      self.FBankFileDefsColl.Clear;
    end;
  end;
end;



function TBankFileReader.getBankFileDef(const pBankCode: AStr): TBankFileDef;
var
  i, pmPos: integer;
  pCmpCode: AStr;
  pCode1: AStr;
  pCode2: AStr;
begin
  // --
  Result := nil;
  // if (pIndex < 0) or (pIndex > self.FBankFileDefsColl.Count - 1) then algselt oli vaid indeksipõhine !
  if length(trim(pBankCode)) <= 1 then
    raise Exception.Create(estbk_strmsg.SEIncfWrongBankIdfCode);


  // ntx soovitakse lokaalset pangakoodid 767 ja swifti üheaegselt anda ! 767|HABAEE2X
  pmPos := pos('|', pBankCode);
  if pmPos = 0 then
    pCode1 := AnsiUpperCase(pBankCode)
  else
  begin
    pCode1 := AnsiUpperCase(copy(pBankCode, 1, pmPos - 1));
    pCode2 := AnsiUpperCase(copy(pBankCode, pmPos + 1, (length(pBankCode) - pmPos) + 2));
  end;

  for i := 0 to self.FBankFileDefsColl.Count - 1 do
  begin
    pCmpCode := AnsiUpperCase(TBankFileDef(self.FBankFileDefsColl.Items[i]).FBankCode);
    if (pCmpCode = pCode1) or (pCmpCode = pCode2) then
    begin
      Result := TBankFileDef(self.FBankFileDefsColl.Items[i]);
      break;
    end;
  end;
end;

function TBankFileReader.fieldNameAsStr(const pIndex: TBankDataFields): AStr;
begin
  Result := GetEnumName(TypeInfo(TBankDataFields), Ord(pIndex));
end;

function TBankFileReader.performDataCpy(const pDataIndex: TBankDataFields; const pFieldData: TBankFieldData; const pDataFmt: AStr;
  // hetkel kasutusel vaid kuupäeva puhul
  const pStrData: AStr; var pErrorCode: AStr; var pLongErrDescr: AStr): boolean;
const
  CBadValue = -9999999;

  // --
var
  pTmpstr: AStr;
  pFmt: AStr;
  pCurrVal: currency;
  pConvDate: TDatetime;
  pTemp: TvardataArr;
begin

  Result := True;
  pErrorCode := '';
  pConvDate := date;
  pTmpstr := trim(pStrData);

  // kontrollime üle, kas on kohustuslik väli !!!
  if (pDataIndex in self.FRequiredFields) and (pTmpstr = '') then
  begin
    pErrorCode := estbk_lib_rep_errorcodes.SEC_IncreqDataIsMissing;
    pLongErrDescr := fieldNameAsStr(pDataIndex);
    Result := False;
    exit;
  end; // -->



  // --
  case pDataIndex of
    fld_currency_drate_ovr:
    begin
      pTmpstr := estbk_utilities.setRFloatSep(pStrData);
      if pTmpstr = '' then
        pTmpstr := '1';

      pCurrVal := StrToCurrDef(pTmpstr, CBadValue);
      Result := (pCurrVal <> CBadValue) and (pCurrVal >= 0.00);
      if not Result then
        pErrorCode := SEC_IncinvDataFormat
      else
      begin
        pTemp := pFieldData.Data;
        pTemp[pDataIndex] := pCurrVal;
        pFieldData.Data := pTemp;
      end;
    end;

    fld_payment_sum:
    begin
      pTmpstr := estbk_utilities.setRFloatSep(pStrData);

      Result := (pTmpstr <> '');
      if not Result then
        pErrorCode := estbk_lib_rep_errorcodes.SEC_IncreqDataIsMissing
      else
      begin
        pCurrVal := StrToCurrDef(pTmpstr, CBadValue);
        Result := (pCurrVal <> CBadValue) and (pCurrVal >= 0.00);
        if not Result then
          pErrorCode := SEC_IncInvDataFormat
        else
        begin
          pTemp := pFieldData.Data;
          pTemp[pDataIndex] := pCurrVal;
          pFieldData.Data := pTemp;
        end;
      end;
      // ---
    end;

    fld_incoming_date,
    fld_payment_date:
    begin
      pFmt := trim(pDataFmt);
      // 26.08.2011 Ingmar kasutame kuupäeva automaatset tuvastust
      if pFmt = '' then
      begin
        Result := estbk_utilities.validateMiscDateEntry(pTmpstr, pConvDate);
        // pFmt := estbk_globvars.glob_defaultDateFmt;
      end
      else
        Result := estbk_utilities.strToDateWithFormat(pTmpstr, pFmt, pConvDate);

      if not Result then
        pErrorCode := SEC_IncInvDataFormat
      else
      begin
        pTemp := pFieldData.Data;
        pTemp[pDataIndex] := pConvDate;
        pFieldData.Data := pTemp;
      end;

    end
    else // CASE ELSE
    begin
      pTemp := pFieldData.Data;
      pTemp[pDataIndex] := pTmpstr;
      pFieldData.Data := pTemp;
    end;
  end;

  // ---
  if not Result then
    pLongErrDescr := fieldNameAsStr(pDataIndex)
  else
    pLongErrDescr := '';
end;


// TODO: natuke targem võrdlus teha !
// skiplnrule
// st kui antud väljal pole tingimust täidetud; siis andmerida jäetakse vahele ntx puudub arhiveerimistunnus
// enamasti siis tegemist kas lõpp või algsaldo reaga
// 25.08.2011 Ingmar; lisasin ka nö or tingumise;  =K;I  et rida võrdub kas K või I
function TBankFileReader.fieldMatchesDataLineRule(const pData: AStr; const pDataPos: integer; const pSkiprules: TAStrList): boolean;
var
  pRule: AStr;
  pMatchData: AStr;
  pSkiprule: AStr;
  pSplit: TAStrList;
  i: integer;
begin
  // pole tingimusi, järelikult lubame rea !
  if pSkiprules.Count < 1 then
  begin
    Result := True;
    exit; // --
  end;

  pSkiprule := '';
  for i := 0 to pSkiprules.Count - 1 do
    if Ptrint(pSkiprules.Objects[i]) = pDataPos then
    begin
      pSkiprule := pSkiprules.Strings[i];
      break;
    end;




  Result := False;
  pRule := trim(pSkiprule);


  try
    pSplit := TAStrList.Create;
    pSplit.Delimiter := ';';
    if pRule <> '' then
    begin

      if pRule[1] in ['<', '>', '='] then
        // viskame operaatori minema
      begin
        pMatchData := ansilowercase(copy(pRule, 2, length(pRule) - 1));
        pSplit.DelimitedText := pMatchData;
        for i := 0 to pSplit.Count - 1 do
        begin

          case pRule[1] of
            '<': Result := Result or (pSplit.Strings[i] < ansilowercase(pData));
            '>': Result := Result or (pSplit.Strings[i] > ansilowercase(pData));
            '=': Result := Result or (pSplit.Strings[i] = ansilowercase(pData));
          end;

          if Result then
            exit;
        end;
      end
      else
      if (length(pRule) >= 2) and (pRule[1] = '!') and (pRule[2] = '=') then
      begin
        pMatchData := ansilowercase(copy(pRule, 3, length(pRule) - 2));
        pSplit.DelimitedText := pMatchData;
        for i := 0 to pSplit.Count - 1 do
        begin
          Result := Result or (ansilowercase(pData) <> pSplit.Strings[i]);
          if Result then
            exit; // ---
        end;
      end;

    end
    else
      Result := True; // 25.08.2011 Ingmar;

  finally
    FreeAndNil(pSplit);
  end;
end;

function TBankFileReader.readSEPAFiles(const pBankFiles: TAStrList; const pBankCode: AStr; var pError: Astr): boolean;
var
  readCam053: TFI_camt_053;
  camFile: TFileStream;
  camStream: TStringStream;
  camEntry: TFI_camt_053_item;
  camColl: TCollection;
  pBufferedData: TObjectList;
  pFieldData: TBankFieldData;
  i, j: integer;
  pMD5Digest: TMD5Digest;
  incomingDate: TDatetime;
  pTemp: TvardataArr;
begin
  Result := True;
  for i := 0 to pBankFiles.Count - 1 do
  begin
    readCam053 := TFI_camt_053.Create;
    camStream := TStringStream.Create('');
    camFile := TFileStream.Create(pBankFiles.Strings[i], fmOpenRead);
    pBufferedData := TObjectList.Create(True);

    try
      camStream.CopyFrom(camFile, camFile.Size);
      camStream.Seek(0, 0);
      // teeme kirjele reset...
      FReportWriter.resetReportGeneralRec;
      FCurrBankFile := pBankFiles.Strings[i];
      FReportWriter.miscData := FCurrBankFile;
      FReportWriter.hdrData := format(estbk_strmsg.SCIncFileProcHdr, [pBankFiles.Strings[i]]);
      FReportWriter.ftrData := '';
      FReportWriter.taskStarts := now;
      FReportWriter.taskEnds := now;
      camColl := TCollection.Create(TFI_camt_053_item);
      readCam053.ReadCamt053Short(camStream, camColl);
      camStream.Seek(0, 0);
      pMD5Digest := MD5.MD5String(camStream.DataString);
      for j := 0 to camColl.Count - 1 do
      begin
        camEntry := camColl.Items[j] as TFI_camt_053_item;
        // mis oleks õige reatüüp ?!?!?!? Status = BOOK ja TransType siis CRDT ????
        if AnsiUpperCase(camEntry.TransType) <> 'CRDT' then
          Continue;


        if not camEntry.Validated then
          internalLogWrite(estbk_lib_rep_errorcodes.SEC_IncReqDataIsMissing, camEntry.Error, 0)
        else
        begin
          pFieldData := TBankFieldData.Create;
          pTemp := pFieldData.Data;
          pTemp[fld_payer_name] := camEntry.Debtor;
          pTemp[fld_payer_account] := camEntry.DebtorAccount;
          pTemp[fld_payer_account_iban] := camEntry.DebtorAccount;
          pTemp[fld_description] := camEntry.Descript;
          pTemp[fld_bank_description] := pFieldData.Data[fld_description];
          // Rumal viga; pidi olema makse saaja konto nr, mis failid ID ja IBAN sektsioonis
          // pFieldData.data[fld_receiver_account_number] := camEntry.CreditorAccount;
          // pFieldData.data[fld_receiver_account_number_iban] := camEntry.CreditorAccount;
          pTemp[fld_receiver_account_number] := camEntry.RecvAccountIban;
          pTemp[fld_receiver_account_number_iban] := camEntry.RecvAccountIban;
          pTemp[fld_receiver_name] := camEntry.Creditor; // mis siis kui raha saaja ei võrdu firma nimega ? kas peaks vea tõstatama

          if validateMiscDateEntry(camEntry.BookingDateStr, incomingDate) then
          begin
            pTemp[fld_incoming_date] := incomingDate;
            pTemp[fld_payment_date] := incomingDate;
          end
          else
            pTemp[fld_incoming_date] := now;
          pTemp[fld_currency] := camEntry.currency;
          pTemp[fld_currency_drate_ovr] := 1.00; // mis kurss siia panna ?! Peaks antud päeva kursi võtma, kui laekus summa...huh
          pTemp[fld_bank_archcode] := camEntry.TransactionId;
          pTemp[fld_payer_refnumber] := camEntry.Refs;
          pTemp[fld_payment_sum] := camEntry.IncomeSum;
          pTemp[fld_bank_code] := camEntry.BankBIC;
          //                         RecvAccountIBAN
          pFieldData.Data := pTemp;
          pBufferedData.Add(pFieldData);
        end;
      end;

      Result := pBufferedData.Count > 0;
      if Result then
        processIncomeEntrys(pBufferedData, self.FCurrBankFile, md5.MD5Print(pMD5Digest));

    finally
      try
        FReportWriter.taskEnds := now;
        FReportWriter.ftrData := format(estbk_strmsg.SCIncFilePorcFtr, [pBankFiles.Strings[i]]);
      except
      end;

      FreeAndNil(readCam053);
      FreeAndNil(camStream);
      FreeAndNil(camColl);
      FreeAndNil(camFile);
      FreeAndNil(pBufferedData);
    end;
  end;
end;

function TBankFileReader.readFiles(const pBankFiles: TAStrList; const pBankCode: AStr; var pError: Astr): boolean;
var
  pFMode: byte;
  pTxtFile: Textfile;
  pTmpFile: file of byte;
  // --
  pTmpErrCode: AStr;
  pTmpFullDescr: AStr;
  pDataLine: AStr;
  pStrData: AStr;
  i, k: integer;
  j: TBankDataFields;
  pLineNr: integer;
  pBankFileDef: TBankFileDef;
  pLineContErrors: boolean;
  pFieldData: TBankFieldData;
  pBufferedData: TObjectList;
  pskipLines: integer;
  pSkipLine: boolean;
  pMD5Digest: TMD5Digest;

  pFileSize: integer;
  pDataPos: integer;
  pOkEntry: boolean;

begin
  try
    try
      pOkEntry := False;
      pFMode := FileMode;
      FileMode := fmOpenRead;
      pError := '';
      pLineNr := 0;
      pFileSize := 0;

      pskipLines := high(integer);
      Result := False;
      if not assigned(pBankFiles) or (pBankFiles.Count < 1) then
      begin
        pError := estbk_strmsg.SEIncfFileNotChoosen;
        exit;
      end;



      // ------------------------------------------------------------------
      // otsime välja definitsiooni !!!
      // ------------------------------------------------------------------
      pBankFileDef := getBankFileDef(pBankCode);
      assert(dmodule.primConnection.InTransaction = False, '#3');
      // ---


      for i := 0 to pBankFiles.Count - 1 do
        try
          pBufferedData := TObjectList.Create(True);
          pLineNr := 0;

          // teeme kirjele reset...
          FReportWriter.resetReportGeneralRec;
          self.FCurrBankFile := pBankFiles.Strings[i];
          FReportWriter.miscData := self.FCurrBankFile;

          // logime tegevuse !
          FReportWriter.hdrData := format(estbk_strmsg.SCIncFileProcHdr, [pBankFiles.Strings[i]]);
          FReportWriter.ftrData := '';
          FReportWriter.taskStarts := now;
          FReportWriter.taskEnds := now;

          assignfile(pTmpFile, pBankFiles.Strings[i]);
          reset(pTmpFile, 1);
          // ---

          pFileSize := FileSize(pTmpFile);
          closefile(pTmpFile);


          assignfile(pTxtFile, pBankFiles.Strings[i]);
          reset(pTxtFile);

          //pFileSize:=FileSize(pTxtFile);
          // otsime üles reainfo, millisest reast alatest hakata lugema; tulevikus asi võimaldab paremini reegled kehtestada !
          for k := low(pBankFileDef.skipLines) to high(pBankFileDef.skipLines) do
            if (pBankFileDef.skipLines[k] > 0) and (pBankFileDef.skipLines[k] < pskipLines) then
            begin
              pskipLines := pBankFileDef.skipLines[k];
              break;
            end;


          while not EOF(pTxtFile) do
          begin
            Inc(pLineNr);
            readln(pTxtFile, pDataLine);

            // 09.06.2010 ingmar; alustame kammimist
            if (pskipLines > 0) and (pskipLines <> high(integer)) then
            begin
              pSkipLine := False;
              for k := low(pBankFileDef.skipLines) to high(pBankFileDef.skipLines) do
              begin
                pSkipLine := pBankFileDef.skipLines[k] = pLineNr;
                if pSkipLine then
                  break;
              end;

              if pSkipLine then
                Continue;
            end;
            //       for j:=0 to pBankFileDef
            // ja rõõmsalt loeme
            if pDataLine <> '' then
              try


                // puhver...
                pFieldData := TBankFieldData.Create;
                pFieldData.FLineNr := pLineNr;
                pLineContErrors := False;

                for j := low(TBankDataFields) to high(TBankDataFields) do
                  // if j<>fld_null then
                  if pBankFileDef.dataPos[j] > 0 then
                  begin

                    // @@ 1
                    // -- fikseeritud välja pikkusega fail
                    if pBankFileDef.bankDataSep = _sepTypeAsFixed then
                    begin

                      if pBankFileDef.dataPos[j] > length(pDataLine) then
                      begin
                        // false ntx võib olla vaid hoiatus !
                        pLineContErrors := self.internalLogWrite(estbk_lib_rep_errorcodes.SEC_IncDataLineIsTooShort, '', pLineNr);
                        if pLineContErrors then
                          break;
                      end;

                      (*
                      if (pBankFileDef.dataPos[j]+pBankFileDef.dataPLen[j])>length(pDataLine) then
                        begin
                           // false ntx võib olla vaid hoiatus !
                           pLineContErrors:=writetoErrLog(pLineNr,estbk_rep_errorcodes.SEC_dataLineIsTooShort,'');
                        if pLineContErrors then
                           break;
                        end;
                       *)
                      // kopeerime välja sisu
                      pTmpFullDescr := '';
                      pTmpErrCode := '';


                      pStrData := trim(copy(pDataLine, pBankFileDef.dataPos[j], pBankFileDef.dataPLen[j]));
                      if ((j in TExtraRuleSet) and (pBankFileDef.InclDatalineRule[j].Count < 1)) then  // 0 rida ilma reegliteta, ignoreerime !
                        continue;


                      // 18.03.2011 Ingmar; semikoolonitel pole pointi !
                      pStrData := StringReplace(pStrData, '"', '', [rfReplaceAll]);

                      // märgime rea, just nagu viga...tegelikkuses vaja lihtsalt andmete vabastamise jaoks
                      pLineContErrors := not fieldMatchesDataLineRule(pStrData, pBankFileDef.dataPos[j], pBankFileDef.InclDatalineRule[j]);


                      // üritame andmed siis ära kopeerida
                      if not pLineContErrors then
                      begin
                        //showmessage(pStrData+':'+fieldNameAsStr(j));
                        pLineContErrors := not self.performDataCpy(j, pFieldData, '' {fmt}, pStrData, pTmpErrCode, pTmpFullDescr);
                        if pLineContErrors then
                        begin
                          pLineContErrors := internalLogWrite(pTmpErrCode, pTmpFullDescr, pLineNr, '', 0);
                          if pLineContErrors then
                            break;
                        end;
                      end
                      else
                        break;
                      // ---
                    end
                    else
                      // @@ 2
                      // liigume mööda markereid ja arvutame positsioone pDataPos
                    begin
                      pDataPos := pBankFileDef.dataPos[j];
                      pStrData := trim(estbk_utilities.getStrDataFromPos(CBankDataSepators[pBankFileDef.bankDataSep],
                        pDataPos, pDataLine));


                      if pBankFileDef.forceutf8 then
                        pStrData := utf8encode(pStrData);

                      if ((j in TExtraRuleSet) and (pBankFileDef.InclDatalineRule[j].Count < 1)) then  // 0 rida ilma reegliteta, ignoreerime !
                        continue;

                      // 18.03.2011 Ingmar; semikoolonitel pole pointi !
                      pStrData := StringReplace(pStrData, '"', '', [rfReplaceAll]);
                      // ---
                      pLineContErrors := not fieldMatchesDataLineRule(pStrData, pDataPos, pBankFileDef.InclDatalineRule[j]);
                      if not pLineContErrors then
                      begin
                        //showmessage(pStrData+':'+fieldNameAsStr(j));
                        pLineContErrors := not self.performDataCpy(j, pFieldData, '' {fmt}, pStrData, pTmpErrCode, pTmpFullDescr);
                        if pLineContErrors then
                        begin
                          pLineContErrors := internalLogWrite(pTmpErrCode, pTmpFullDescr, pLineNr, '', 0);
                          if pLineContErrors then
                            break;
                        end;
                      end
                      else
                        break;
                    end;
                    // ---
                  end;



              finally
                if pLineContErrors then
                  FreeAndNil(pFieldData)
                else
                  pBufferedData.Add(pFieldData);
              end;
          end;

          // ---
          closefile(pTxtFile);




          // --------------------------------------------------------------------
          // ---  kirjutame puhverdatud read andmebaasi !
          // --------------------------------------------------------------------

          pMD5Digest := MD5.MD5File(self.FCurrBankFile, pFileSize);
          self.processIncomeEntrys(pBufferedData, self.FCurrBankFile, md5.MD5Print(pMD5Digest));


          // see kinnitab meie finally jaoks, et kõik sujus plaanipäraselt !
          pOkEntry := True;


        finally
          FreeAndNil(pBufferedData);
          // ntx ühendus kukub maha, siis saame vale vea
          try
            FReportWriter.taskEnds := now;
            FReportWriter.ftrData := format(estbk_strmsg.SCIncFilePorcFtr, [pBankFiles.Strings[i]]);
          except
          end;
        end;

    finally
      begin
        FileMode := pFMode;
        //self.FCurrBankFile := ''; 21.03.2011 Ingmar; aktiivse faili info peab üles jääma, kuna me siiski töötleme reaalselt ühte faili korraga
      end;
    end;

    // --
  except
    on e: Exception do
    begin
      pError := e.message;
      self.internalLogWrite(estbk_lib_rep_errorcodes.SEE_UnknownError, pError, pLineNr);
    end;
  end;
end;


constructor TBankFileReader.Create(const pStatusRepInstance: TStatusRepWriter);
begin
  inherited Create;
  self.FReportWriter := pStatusRepInstance;
  FBankFileDefsColl := TCollection.Create(TBankFileDef);
end;

destructor TBankFileReader.Destroy;
begin
  FreeAndNil(FBankFileDefsColl);
  inherited Destroy;
end;

end.