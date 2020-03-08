unit estbk_clientdatamodule;
// @@07.03.2015 Ingmar; nüüdsest numeraatorid eraldi klassis, aga jätame meetodid siia dmodule sisse kui forwarderid
// tulevikus siis viitame uuele klassile




{$i estbk_defs.inc}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, ExtCtrls, StdCtrls, LCLProc, Graphics,
  Dialogs, Contnrs, base64, ZConnection, ZDataset, ZSqlUpdate, ZSequence, md5,
  estbk_lib_numerators, estbk_dbcompability, estbk_sqlcollection,
  estbk_types, estbk_strmsg, estbk_utilities, estbk_globvars, estbk_progressform, estbk_lib_datareader,
  estbk_settings, estbk_lib_commoncls, DB, Math, Dateutils, IniFiles;

type

  { Tdmodule }

  Tdmodule = class(TDataModule)
    FCurrDownloadDummyTimer: TTimer;
    sharedImages: TImageList;
    qryAccPeriods: TZQuery;
    qryEmployeeSeq2: TZSequence;
    qryDocumentFilesSeq: TZSequence;
    qryEmployeeWageSeq: TZSequence;
    qryIncomingsBankSeq: TZSequence;
    qrydFormLinesSeq: TZSequence;
    qryIncomingsSeq: TZSequence;
    qryClassificatorSeq: TZSequence;
    primConnection: TZConnection;
    qryInventorySeq: TZSequence;
    qryGenLedgerAccRecId: TZSequence;
    qryBillLineSeq: TZSequence;
    qryBillMainRecSeq: TZSequence;
    qryGenLedgerEntrysSeq: TZSequence;
    qryGetdocumentIdSeq: TZSequence;
    qryArticlePriceSeq: TZSequence;
    qryInventoryDocIdSeq: TZSequence;
    qryPaymentDataSeq: TZSequence;
    qryPaymentSeq: TZSequence;
    tempQuery: TZQuery;
    qryQuickSrcClientData: TZReadOnlyQuery;
    tempQuery2: TZQuery;
    qryEmailSeq: TZSequence;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FCurrDownloadDummyTimerStartTimer(Sender: TObject);
    procedure FCurrDownloadDummyTimerTimer(Sender: TObject);
    procedure qryAccPeriodsFilterRecord(DataSet: TDataSet; var Accept: boolean);

  private
    FGlobalIni: IniFiles.TIniFile; // TODO; tulevikus login.ini ära kaotada !
    FCompanyLogo: TImage;
    // vaikimisi käibemaksu ID
    FDefaultVATId: integer;
    FDefaultVATPerc: double;
    FDefaultDuePerc: double;
    FDefaultDueDays: integer;

    FUserSettingsMD5: AStr;

    // ---
    FCurrDataList: TAStrList; // sharetud valuutade loend
    FPaymentTerms: TAStrList;
    FCurrencyDataOK: boolean;
    FDownLoadCurrProgForm: Tform_progress;
    // kiire klientide lookup...hoiame osa kliente mälus
    FClientFastSrcList: TAStrList; //THashedStringList
    // ---
    FStsValues: estbk_settings.TUserStsValues;
    FCheckAccPerLastDate: TDatetime;
    FCheckAccPerLastID: integer;
    procedure loadCompanyLogo(const pCompanyId: integer);
    function getStsData(index: TStsIndex): AStr;
    procedure setStsData(index: TStsIndex; Value: AStr);


    function __usrSettingsSpecialRange: AStr; // hoiame kasutamata numbreid, olgu arve, kanne jne
    function generateUserSettingsMD5: AStr;
    procedure selfCheck;
    procedure loadListOfCurrencys;
    function onReadLineNotification(const filename: AStr; const linenr: integer; const Data: AStr): boolean;




    // 14.03.2012 Ingmar; see numeraatorite osa on sajandi häkk !
    function couldbeCustomNumerator(const pNumVal: string; const pDate: TDatetime; const pNumFmt: AStr): boolean;
    function queryNumFormat(const pNumType: AStr; const pAccPeriodId: integer; var pNumPrefix: AStr; var pNumFmt: AStr): boolean;
    function doFinalNumeratorFmt(const pVal: AStr; const pNumType: AStr; const pAccPeriodId: integer; const pDate: TDatetime): AStr;
    function extractNumberFromNumerator(const pNumVal: AStr; const pNumFmt: AStr): AStr;
    function formatNumerator(const pNumVal: string; const pDate: TDatetime; const pNumFmt: string; const pThrowException: boolean = True): string;

    function __resolveNumType(const pNumTypeAsStr: AStr): TCNumeratorTypes;
    function __getNumeratorCacheIndex(const pNumeratorType: TCNumeratorTypes;
      const pCacheGenledgerAccNr: boolean = False // ainus koht, kus kande number nö "cachetakse" on pearaamat 02.08.2011 Ingmar
      ): TStsIndex;

    function __getNumeratorCacheExt(const pCallerId: PtrUInt; const pCurrentNumVal: AStr; const pNumeratorType: TCNumeratorTypes;
      const pNumeratorDate: TDate; const pBookNumber: boolean; // st. kui false, siis võtame välja cachest ja kõik
      const pReloadNumber: boolean): AStr;

    procedure __markNumeratorValAsReserved(const pNumeratorType: TCNumeratorTypes; const pnumVal: AStr;
      const pCallerIsGeneralLedgerModule: boolean = False);

    procedure __markNumeratorValAsReservedExt(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
      const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pReloadNumber: boolean; const pCallerIsGeneralLedgerModule: boolean);


    procedure __markNumeratorValAsUsedExt(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
      const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pCallerIsGeneralLedgerModule: boolean = False);

    procedure loadNumeratorValHistory;
    procedure saveNumeratorValHistory;
    // 20.09.2013 Ingmar
    function findValidWorkingDay(const pdate: TDatetime): TDatetime;

  public
    property companyLogo: TImage read FCompanyLogo write FCompanyLogo;
    property globalIni: TIniFile read FGlobalIni;
    // viiviseprotsent !
    property defaultDuePerc: double read FDefaultDuePerc write FDefaultDuePerc;
    property defaultDueDays: integer read FDefaultDueDays write FDefaultDueDays;


    // tee meetodiga createPrivateCurrListCopy koopia, asi selles, et kui ntx arvetes muudetakse päevakurssi
    // siis muutuks kõikjal, mis kasutaks currencyListi !!!
    property currencyList: TAStrList read FCurrDataList;
    property currencyDataOK: boolean read FCurrencyDataOK write FCurrencyDataOK;
    property paymentTerms: TAStrList read FPaymentTerms write FPaymentTerms;


    // TODO: viia üle estbk_Client moodulisse !
    property custFastSrcList: TAStrList read FClientFastSrcList;
   {
   // "OA" - Ostuarve; vaikimisi
   // "AR" - Arve; müügiarve
   // "MK" - Maksekorraldus
   // "SO" - Sissetuleku order
   }

    // Property Left   : Longint Index 0 read GetCoord write SetCoord;
    // Property Coords[Index: Integer] : Longint read GetCoord write SetCoord;
    // property documentIdse[Index : TSystemDocType] :estbk_types.TSystemDocIdArr read getDocumentId write setDocumentId;

    // 14.04.2011 Ingmar
    // kasutaja kõik seaded, mis andmebaasist laaditi ! ntx mingi lahtri värvus, midagi jäeti meelde jne
    property userStsValues[Index: TStsIndex]: AStr read getStsData write setStsData;
    procedure notifyNumerators(const pCallerId: PtrUInt);

    // @@@
   {$ifdef wagemodule_enabled}
    function createZEmployeeTemplate: integer;   // palk
    function createZEmployeeWageTemplate: integer;
   {$endif}

    function _loadSpecialVarFromConf(const pLoadVar: AStr; const pCompanyID: integer): AStr;
    function _verifySchemaVer: boolean;

    // kasutaja seaded elemendi kaupa
    function _readItemSettings(const pItemID: integer): AStr; //  _user_id / _compid globaalselt !
    function _writeItemSettings(const pItemID: integer; const pItemValue: AStr): boolean;


    procedure saveUserSettings;
    // firmaga seotud töötajate nimistu
    procedure fillWorkerList(const pCombobox: TCustomCombobox);
    procedure fetchAccRefFormdLine(const pFormId: integer; const pRefFormdAccData: TObjectList);
    function buildDefaultFormulaLine(const pLineId: integer; const pRefFormdAccData: TObjectList): AStr;



    function areDefaultAccountsAssigned: boolean;
    // FIRMA mille all tööd tehakse !
    procedure setUserCurrentWrkCompany();

    function readDocumentFile(const pFileId: integer; const pOutputStream: TStream; var pFilename: AStr): boolean;

    procedure deleteDocumentFile(const pFileId: integer);
    // 28.02.2011 Ingmar
    function addDocumentFile(const pDocId: int64; const pFilename: AStr; const pFileId: integer = 0): integer;
    // kui fileID>0 siis uuendatakse faili !

    function getDFormMaxIdByType(const pType: AStr): integer;
    // ---
    procedure loadPaymentTerms;
    procedure loadAllUserSettings;


    procedure initApp;

    // TODO: viia üle estbk_customer moodulisse !
    procedure reloadSharedCustData(const clientId: integer = -1);


    // 20.02.2011 Ingmar
    procedure loadClassificatorsIntoCombo(const pCombo: TCombobox; const pClassifType: AStr);
    // --

    // teeb pearaamatu uue peakirje !
    function createNewGenLedgerMainRec(const pAccperiod: integer; // rp. period
      const pAccDate: TDate;   // kande kuupäev
      const pAccDesc: AStr;    // kirjeldus pearaamatu päises
      const pDocTypeId: TSystemDocType; const pDocNumber: AStr; const pGenLedgerRecType: AStr;
    // G;  CAccRecIdentAsGenLedger / CAccRecIdentAsBill ntx
      var pGenEntryMainRecId: integer; var pDocId: int64; const pOvrAccRecNumber: AStr = ''; const pDisplayMsg: boolean = True): boolean;

    function createAccChildRec(const paccRec: TAccoutingRec; const doConversion: boolean = True): int64;

    function updateGenLedgerMainRec(const pGenEntryMainRecId: integer; // kande aluskirje mida uuendada
      const pAccDate: TDate;   // kande kuupäev
      const pAccDesc: AStr;    // kirjeldus pearaamatu päises
      const pDocNumber: AStr;
    // reserveeritud !!!
      const pDisplayMsg: boolean = True // ntx kontrollime, kas samas perioodis on sama nr kanne, sama doc
      ): boolean;
    // kontrollib rp.
    function getAccoutingPerId(const pDate: TDate; const pDisplayMsg: boolean = True): integer;
    function getAccoutingPerId2(const pDate: TDate): integer; // TODO; hashtable/range põhine !


    // --- laeb valuuta ühikud stringlist
    function createPrivateCurrListCopy(): TAStrList;
    // ---
    function downloadCurrencyData(const useIntDate: boolean = True; const altDate: TDateTime = -1): boolean;

    // 02.02.2011 Ingmar
    procedure resetCurrObjVals(pCurrDate: TDate; const pStrLstObj: TAStrList);

    function revalidateCurrObjVals(pCurrDate: TDate; const pStrLstObj: TAStrList): boolean;

    procedure markNumeratorValAsUsed(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
      const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pCallerIsGeneralLedgerModule: boolean = False);

    function getUniqNumberFromNumerator(const pCallerId: PtrUInt; const pCurrentNumVal: AStr;
    // 01.03.2012 Ingmar
      const pNumeratorDate: TDate;   // 29.02.2012 Ingmar
      const pReloadNumber: boolean; // ---- viitab sellele, et tuleks kontrollida, kas numeraator sobilik
      const pNumeratorType: TCNumeratorTypes = estbk_types.CAccGen_rec_nr; const pBookSrNr: boolean = True;
    // -- kas märgime numbri broneerituks
      const pCallerIsGeneralLedgerModule: boolean = False): AStr;

    function __generateClientData(const pClientName: AStr; const pClientRegCode: AStr; const pClientCode: AStr;
      const pClientVatNr: AStr; const pCountry: AStr = ''; const pCounty: AStr = ''; const pCity: AStr = '';
      const pStreet: AStr = ''; const pHouseNr: AStr = ''; const pApartmentNr: AStr = ''): TClientData;


    function generateStaticNumAccPeriod(const pNumeratorType: TCNumeratorTypes; var pAccPeriod: integer): boolean;
    // 17.01.2011 Ingmar; kontrollfunktsioon rp. perioodi jaoks !
    function isValidAccountingPeriod(const pDate: TDatetime; var pAccPeriodId: integer): boolean;

    // ---
    procedure connect(const serverName: AStr; const serverPort: integer; // hetkel seda ei toeta
      const usrName: AStr; const usrPassword: AStr; var pDbVerIsOk: boolean;
    // 10.08.2011 Ingmar
      const onlyPreinit: boolean = False);
  end;

// ---------------------------------------------------------------------------
// 26.10.2010 Ingmar
// lazaruse bugi; ma ei tea juba mitmes, neid liiga palju, kui imagelist frame peal,
// siis suur tõenäosus, et asi jookseb lihtsalt kokku.Kõik sõltub objekti loomise järjekorrast
// selletõttu dmodules ikoone hoida on kordades ohutuma
const
  img_indxSimpleDel = 0;
  img_indxAddItem = 1;  // + märk
  img_indxExtDel = 2;
  img_indxOk = 3;
  img_indError = 4;
  img_indQuestionMark = 5;
  img_indxAddition = 6;  // liitmine
  img_indxSubstr = 7;  // lahutamine
  img_indxMultiply = 8;  // korrutamine
  img_indxDivide = 9;  // jagamine
  img_indxitemChecked = 10; // checkbox valitud
  img_indxitemUnChecked = 11; // checkbox valimata
  img_indxboxImage = 12; // nö faililogo
  img_indxItemVerified = 13; // ntx maksekorralduse juures näitab, et tegemist meie süsteemis kirjeldatud kliendiga
  img_indxUpSign = 14; // üles märk
  img_indxDownSign = 15; // alla märk
  img_indxEmptyImg = 16; // 16x16 tühi pilt, hea kasutada mingi regiooni "kustutamisel"




// ---------------------------------------------------------------------------

var
  dmodule: Tdmodule;
  glob_userSettings: estbk_settings.TUserSettings;



implementation

uses estbk_inputformex, estbk_sqlclientcollection, estbk_lib_commonaccprop, Variants;

{$ifdef wagemodule_enabled}
// 26.01.2012 Ingmar; kuna palk sai lisatud alles hiljem, siis teeme kasutaja nimega template;
function Tdmodule.createZEmployeeTemplate: integer;
var
  pSQL: AStr;
begin
  with tempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectNullEmployee);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('flags').AsInteger := estbk_types.CEmployee_flasNULLuser; // tulevikus tuleb or sqlis teha !
      paramByname('code').AsString := estbk_types.CEmployee_NULLusercode;
      Open;
      Result := FieldByName('id').AsInteger;

      // järelikult nö template kirjet pole, loome selle
      if Result < 1 then
      begin
        Close;
        Clear;
        Result := qryEmployeeSeq2.GetNextValue;
        pSQL := estbk_sqlclientcollection._SQLInsertEmployee;

        add(pSQL);
        paramByname('id').AsInteger := Result;
        paramByname('code').AsString := estbk_types.CEmployee_NULLusercode;
        paramByname('firstname').AsString := '';
        paramByname('middlename').AsString := '';
        paramByname('lastname').AsString := '';
        paramByname('personal_idnr').AsString := '';
        paramByname('bday').AsInteger := 0;
        paramByname('bmonth').AsInteger := 0;
        paramByname('byear').AsInteger := 0;
        paramByname('gender').AsString := '';
        paramByname('address').AsString := '';
        paramByname('postalcode').AsString := '';
        paramByname('phone').AsString := '';
        paramByname('email').AsString := '';
        paramByname('bank').AsString := '';
        paramByname('bankaccount').AsString := '';
        paramByname('nationality').AsString := '';
        paramByname('nonresident').AsString := 'f';
        paramByname('resident_countryname').AsString := '';
        paramByname('resident_countrycode').AsString := '';
        paramByname('lpermitnr').AsString := '';
        paramByname('wpermitnr').AsString := '';
        paramByname('education').AsString := '';
        paramByname('picture').Value := null;
        paramByname('contact_person').AsString := '';
        paramByname('contact_person_addr').AsString := '';
        paramByname('contact_person_phone').AsString := '';
        paramByname('flags').AsInteger := estbk_types.CEmployee_flasNULLuser;
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        execSQL;
      end;

    finally
      Close;
      Clear;
    end;
end;

function Tdmodule.createZEmployeeWageTemplate: integer;
var
  pTemplEmployee: integer;
begin
  with tempQuery, SQL do
    try
      pTemplEmployee := self.createZEmployeeTemplate;
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectEmpWageDefMRec2);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('employee_id').AsInteger := pTemplEmployee;
      Open;
      Result := FieldByName('id').AsInteger;

      // järelikult puudu template kirje, mis kehtib kõikidele töötajatele
      if Result < 1 then
      begin
        Result := qryEmployeeWageSeq.GetNextValue;
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLInsertEmpWageDefMRec);
        ParamByname('id').AsInteger := Result;
        ParamByname('employee_id').AsInteger := pTemplEmployee;
        ParamByname('employment_contract_id').AsInteger := Result;
        ParamByname('valid_from').AsDateTime := date;
        ParamByname('valid_until').Value := null;
        ParamByname('flags').AsInteger := 0;
        ParamByname('template').AsString := 't'; // !!!
        ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        ParamByname('rec_changed').AsDateTime := now;
        ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        execSQL;
      end;
    finally
      Close;
      Clear;
    end;
end;

{$endif}

// 02.05.2014 Ingmar; et automaatselt e-arve impordil loob kliendi andmed
// eeldame, et juriidiline klient !
function Tdmodule.__generateClientData(const pClientName: AStr; const pClientRegCode: AStr; const pClientCode: AStr;
  const pClientVatNr: AStr; const pCountry: AStr = ''; const pCounty: AStr = ''; const pCity: AStr = '';
  const pStreet: AStr = ''; const pHouseNr: AStr = ''; const pApartmentNr: AStr = ''): TClientData;
var
  prstatus: boolean;
  psql: AStr;
  pid: integer;
begin
  Result := nil;
  pid := 0;
  with tempQuery, SQL do
    try

      if trim(pClientName) = '' then
        raise Exception.Create(estbk_strmsg.SEClientNameIsMissing);
(*
       if trim(pClientRegCode) = '' then
          raise exception.Create(estbk_strmsg.SEClientRegCodeIsMissing);
*)

      prstatus := ParamCheck;
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLAutoSelectClientData);
      paramByname('regnr').AsString := pClientRegCode;
      paramByname('name').AsString := trim(pClientName);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      First; // ---
      if EOF then
      begin
        // ***
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLAutoCreateNewclient);
        paramByname('ctype').AsString := 'L';
        paramByname('name').AsString := trim(pClientName);
        paramByname('regnr').AsString := pClientRegCode;
        // -- teeme ajutise kliendi koodi, et pärast sinna ID uuendada
        if trim(pClientCode) = '' then
          paramByname('client_code').AsString := inttohex(random(99999), 10)
        else
          paramByname('client_code').AsString := pClientCode;
        paramByname('countrycode').AsString := estbk_globvars.glob_activecountryCode;
        // hetkel aadressi osa puudub !
        paramByname('county_id').AsInteger := 0;
        paramByname('city_id').AsInteger := 0;
        paramByname('street_id').AsInteger := 0;
        paramByname('house_nr').AsString := '';
        paramByname('apartment_nr').AsString := '';
        paramByname('zipcode').AsString := '';
        paramByname('phone').AsString := '';
        paramByname('mobilephone').AsString := '';
        paramByname('vatnumber').AsString := pClientVatNr;
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        Open;
        pid := FieldByName('id').AsInteger;

      end;

      Result := TClientData.Create;
      Result.FClientCode := FieldByName('client_code').AsString;
      Result.FClientId := FieldByName('id').AsInteger;
      Result.FCustType := FieldByName('ctype').AsString;
      Result.FCustFirstname := FieldByName('name').AsString;
      Result.FCustVatNr := FieldByName('vatnumber').AsString;
      Result.FCustRegNr := FieldByName('regnr').AsString;

      // korrigeerime koodi ära
      if pid > 0 then
      begin
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLAutoCreateCodeToclientID);
        paramByname('client_code').AsString := IntToStr(pid);
        paramByname('id').AsInteger := pid;
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        ExecSQL;
      end;
    finally
      Close;
      Clear;
      ParamCheck := prstatus;
    end;
end;




procedure Tdmodule.loadCompanyLogo(const pCompanyId: integer);
var
  pBase64: AStr;
  pStrStream: TStringStream;
  pMemStream: TMemoryStream;
  pBase64Str: TBase64DecodingStream;
begin

  try

    // ---
    with tempQuery, SQL do
      try
        self.FCompanyLogo.Picture.Clear;
        // 20.02.2012 Ingmar; muidu tekkis viga kui pdf faili salvestati;   Invalid horizontal pixel index 0.
        self.FCompanyLogo.Width := 0;
        self.FCompanyLogo.Height := 0;

        pStrStream := nil;
        pBase64Str := nil;
        pMemStream := TMemoryStream.Create;

        Close;
        Clear;
        add(estbk_sqlcollection._SQLConfSelectLogo);
        paramByname('company_id').AsInteger := pCompanyId;
        Open;
        if EOF then
          Exit; // ---


        pBase64 := trim(FieldByName('val_blob').AsString);
        pStrStream := TStringStream.Create(pBase64);
        pStrStream.Seek(0, 0);
        pBase64Str := TBase64DecodingStream.Create(pStrStream);

        pStrStream.Seek(0, 0);
        pMemStream.CopyFrom(pBase64Str, pBase64Str.Size);


        pMemStream.Seek(0, 0);
        self.FCompanyLogo.Color := clWindow;
        self.FCompanyLogo.Picture.Bitmap.Clear;

        self.FCompanyLogo.Width := 200;
        self.FCompanyLogo.Height := 80;
        self.FCompanyLogo.Stretch := True;
        self.FCompanyLogo.Picture.LoadFromStream(pMemStream);
      finally
        Close;
        Clear;
        // ---
        if assigned(pStrStream) then
          FreeAndNil(pStrStream);

        if assigned(pMemStream) then
          FreeAndNil(pMemStream);

        if assigned(pBase64Str) then
          FreeAndNil(pBase64Str);
      end;

    // 26.03.2013 Ingmar
    // vales formaadis pilt võib põhjustada seda, et stiigosse ei saagi sisse logida
  except
    on e: Exception do
      self.FCompanyLogo.Picture.Clear;
  end;
end;

// 01.07.2011 Ingmar; kontrollib programmi versiooni; false = vana versioon
function Tdmodule._verifySchemaVer: boolean;
begin
  if self.primConnection.Connected then
    with tempQuery, SQL do
      try
        Result := True;
        Close;
        Clear;
        add('SELECT id,var_misc FROM conf WHERE var_name=''estbk_schemaver''');
        Open;

        if strtointdef(FieldByName('var_misc').AsString, 0) < estbk_types.CCurrentDatabaseSchemaId then
        begin
          Dialogs.MessageDlg(estbk_strmsg.SEDbStructureTooOld, mtWarning, [mbOK], 0);
          Result := False;
        end

      finally
        Close;
        Clear;
      end; // --
end;


function Tdmodule._loadSpecialVarFromConf(const pLoadVar: AStr; const pCompanyID: integer): AStr;
begin
  if self.primConnection.Connected then
    with tempQuery, SQL do
      try
        Close;
        Clear;
        add(format('SELECT var_misc FROM conf WHERE var_name=''%s'' AND company_id=%d', [pLoadVar, pCompanyID]));
        Open;

        Result := FieldByName('var_misc').AsString;
      finally
        Close;
        Clear;
      end; // --
end;

function Tdmodule.getStsData(index: TStsIndex): AStr;
begin
  Result := FStsValues[index];
end;

procedure Tdmodule.setStsData(index: TStsIndex; Value: AStr);
begin
  FStsValues[index] := Value;
end;




// 06.03.2011 Ingmar; kas kõik vaikimisi kontod on seadistatud !
function Tdmodule.areDefaultAccountsAssigned: boolean;
begin
  Result := False;
  with tempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectUnassignedSysAccounts);
      parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      Result := (FieldByName('cnt').AsInteger = 0) and (FieldByName('maxid').AsInteger > 0);
    finally
      Close;
      Clear;
    end;
end;

// millise firma alt tööd tehakse !
procedure Tdmodule.setUserCurrentWrkCompany();
var
  pBfrItems: TAStrList;
  pSelectedCmp: integer;
begin
  with tempQuery, SQL do
    try
      pBfrItems := TAStrList.Create;
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLUserCompanyList);

      // if  estbk_globvars.glob_worker_id>0 then
      if not estbk_globvars.glob_usrIsadmin then
        parambyname('user_id').AsInteger := estbk_globvars.glob_worker_id
      else
        parambyname('user_id').Value := null; // järelikult adminn !!!
      Open;
      First;

      while not EOF do
      begin
        pBfrItems.AddObject(FieldByName('company_name').AsString, TObject(PtrInt(FieldByName('company_id').AsInteger)));
        Next;
      end;

      Close;
      Clear;
    {$ifndef debugmode}
      pSelectedCmp := 0;
      if pBfrItems.Count = 1 then
        pSelectedCmp := integer(PtrInt(pBfrItems.Objects[0]))
      else if not estbk_inputformex.inputFormEx2(estbk_strmsg.SCConfChooseCompany, pBfrItems, pSelectedCmp) or (pSelectedCmp < 1) then
        Application.Terminate;
    {$else}
      pSelectedCmp := 1;
    {$endif}
      // firma kelle andmeid kasutatakse !
      estbk_globvars.glob_company_id := pSelectedCmp;
    finally
      Close;
      Clear;
      FreeAndNil(pBfrItems);
    end;

  // PALK; default mallid ! Z töötaja ja palgamall
  {$ifdef wagemodule_enabled}
  estbk_globvars.glob_zemployee := self.createZEmployeeTemplate;
  createZEmployeeWageTemplate;
  {$endif}

  estbk_lib_numerators._nm.forwardStsValues := Self.FStsValues;
  estbk_lib_numerators._nm.connection := Self.primConnection;
  estbk_lib_numerators._nm.active := True;
  estbk_lib_numerators._nm.IsValidAccountingPeriod := @Self.isValidAccountingPeriod;

  // -- võtame logo ka koheselt
  self.loadCompanyLogo(estbk_globvars.glob_company_id);
  if estbk_globvars.glob_accPeriontypeNumerators then
    self.loadNumeratorValHistory;
end;

function Tdmodule.readDocumentFile(const pFileId: integer; const pOutputStream: TStream; var pFilename: AStr): boolean;
var
  pStrStream: TStringStream;
  pDecStrStream: TStringStream;
  pDecode: TBase64DecodingStream;
begin
  Result := False;
  if assigned(pOutputStream) and (pFileId > 0) then
    with tempQuery, SQL do
      try
        pOutputStream.Seek(0, 0);

        pStrStream := TStringStream.Create('');
        pDecStrStream := TStringStream.Create('');
        pDecode := TBase64DecodingStream.Create(pDecStrStream);

        pFilename := '';
        Close;
        Clear;
        add(estbk_sqlclientcollection._CSQLSelectFile);
        parambyname('id').AsInteger := pFileId;
        parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;

        Open;
        First;
        if not EOF then
        begin
          Result := True;
          pFilename := FieldByName('filename').AsString;
          if estbk_dbcompability.sqlp.currentBackEnd = __postGre then
            pDecStrStream.WriteString(FieldByName('rawdoc').AsString);

          pDecStrStream.Seek(0, 0);
          // dekodeeritud stream !
          pStrStream.CopyFrom(pDecode, pDecode.Size);
          pStrStream.Seek(0, 0);


          pOutputStream.CopyFrom(pStrStream, pStrStream.Size);
          pOutputStream.Seek(0, 0);
        end;

      finally
        FreeAndNil(pStrStream);
        FreeAndNil(pDecStrStream);
        FreeAndNil(pDecode);

        Close;
        Clear;
      end;
end;

procedure Tdmodule.deleteDocumentFile(const pFileId: integer);
begin
  with tempQuery, SQL do
    try
      Close;
      Clear;
      Add(estbk_sqlclientcollection._CSQLDeleteDocFile);
      ParamByname('id').AsInteger := pFileId;
      ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      ParamByname('rec_changed').AsDateTime := now;
      execSQL;
    finally
      Close;
      Clear;
    end;
end;

// document_files tabel !
function Tdmodule.addDocumentFile(const pDocId: int64; const pFilename: AStr; const pFileId: integer = 0): integer;
var
  i: integer;
  b: boolean;
  pExt: AStr;
  pEncode: TBase64EncodingStream;
  pStrStream: TStringStream;
  pEncStrStream: TStringStream;
  pFsStream: TFileStream;
  pFileSize: int64;
begin
  Result := pFileId;
  if not fileExists(pFilename) then
    raise Exception.CreateFmt(estbk_strmsg.SEFileNotFound, [pFilename]);


  // --
  with tempQuery, SQL do
    try
      pStrStream := TStringStream.Create('');  // faili sisuke siia !
      pEncStrStream := TStringStream.Create('');
      pFsStream := TFileStream.Create(pFilename, fmOpenRead);
      // ---
      pFileSize := pFsStream.Size;
      if pFileSize > estbk_types.CAllowedMaxDocFileSize then
        raise Exception.CreateFmt(estbk_strmsg.SEFileTooBig2, [pFileSize div 1024]);




      pFsStream.Seek(0, 0);
      pStrStream.CopyFrom(pFsStream, pFsStream.Size);
      pStrStream.Seek(0, 0);

      pEncode := TBase64EncodingStream.Create(pEncStrStream);
      pEncode.CopyFrom(pStrStream, pStrStream.Size);


      pEncStrStream.Seek(0, 0);
      pStrStream.Seek(0, 0);


      Close;
      Clear;
      b := pFileId <= 0;
      if b then
        add(estbk_sqlclientcollection._CSQLInsertDocFiles)
      else
        add(estbk_sqlclientcollection._CSQLUpdateDocFiles);

      for i := 0 to Params.Count - 1 do
        Params.Items[i].Value := null;

      if b then  // UUS !
      begin
        Result := qryDocumentFilesSeq.GetNextValue;
        // --
        ParamByname('id').AsInteger := Result;
        ParamByname('document_id').AsLargeInt := pDocId;
        ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      end
      else
        ParamByname('id').AsInteger := pFileId;
      ParamByname('rec_nr').AsInteger := 0; // hetkel üks fail per dokument; tulevikus ehk järjekord ka omistada !
      ParamByname('filename').AsString := copy(pFilename, 1, 1024);
      ParamByname('size').AsLargeInt := pFileSize;


      ParamByname('md5').AsString := ''; // hetkel ei arvuta; suurte failide lisamise muudab liiga aeglaseks !
      pExt := extractfileext(pFilename);
      if (pExt <> '') and (pExt[1] = '.') then
        system.Delete(pExt, 1, 1);
      ParamByname('type_').AsString := copy(AnsiUpperCase(pExt), 1, 10);
      ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      ParamByname('rec_changed').AsDateTime := now;


      // --- faili lisamine sõltub nüüd 100% backendist; kus on blog, kus pole blobi...oeh...
      if estbk_dbcompability.sqlp.currentBackEnd = __postGre then
      begin
        // ei tööta, kui fail suurem, kui 500 mb
        //ParamByname('rawdoc').AsMemo:= pEncStrStream.DataString; // ainus võimalus ongi meil BASE64
     {
      Params.CreateParam(ftBlob,'rawdoc', ptInput);
      ParamByName('rawdoc').LoadfromStream(pEncStrStream,ftBlob);}
        //ParamByname('rawdoc').AsString:= copy(pEncStrStream.DataString,1,8192);
        ParamByname('rawdoc').AsString := pEncStrStream.DataString;

      end
      else
        assert(1 = 0);
      execSQL;


      // ---
    finally
      FreeAndNil(pFsStream);
      FreeAndNil(pEncode);
      FreeAndNil(pStrStream);
      FreeAndNil(pEncStrStream);
      Close;
      Clear;
    end;

end;


// -- EXT
function Tdmodule.getDFormMaxIdByType(const pType: AStr): integer;
begin
  Result := 0;
  with tempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectLastFormIDByType);

      parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
      parambyname('form_type').AsString := pType;
      Open;
      Result := FieldByName('idmax').AsInteger;

    finally
      Close;
      Clear;
    end;
end;

// 13.04.2011 Ingmar
function Tdmodule._readItemSettings(const pItemID: integer): AStr; //  _user_id / _compid globaalselt !
var
  pSQL: AStr;
  pSpecialRange: AStr;
begin
  Result := '';
  with tempQuery, SQL do
    try
      Close;
      Clear;
      pSpecialRange := self.__usrSettingsSpecialRange;
      pSQL := estbk_sqlclientcollection._SQLSelectGetSettingValue;
      add(format(pSQL, [pSpecialRange, pSpecialRange]));
      parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('user_id').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('item_name').AsString := format('item_%d', [pItemID]);
      Open;
      Result := FieldByName('item_value').AsString;

    finally
      Close;
      Clear;
    end;
end;

function Tdmodule._writeItemSettings(const pItemID: integer; const pItemValue: AStr): boolean;
var
  pItemExists: boolean;
  pCItemValue: AStr;
  pSpecialRange: AStr;
  pSQL: AStr;
  pUserId: integer;
begin
  try
    Result := False;
    with tempQuery, SQL do
      try
        Close;
        Clear;

        pUserId := estbk_globvars.glob_worker_id;
        pSpecialRange := self.__usrSettingsSpecialRange;
        pSQL := estbk_sqlclientcollection._SQLSelectGetSettingValue;
        add(format(pSQL, [pSpecialRange, pSpecialRange]));
        paramByname('user_id').AsInteger := pUserId;
        paramByname('item_name').AsString := format('item_%d', [pItemID]);
        parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;

        pItemExists := FieldByName('id').AsInteger > 0;
        pCItemValue := FieldByName('item_value').AsString;
        if not pItemExists then
        begin
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLInsertSettingValue);
          paramByname('user_id').AsInteger := pUserId;
          paramByname('item_name').AsString := format('item_%d', [pItemID]);
          paramByname('item_value').AsString := copy(pItemValue, 1, 255);
          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          execSQL;
        end
        else
        if pCItemValue <> pItemValue then
        begin

          // -- pItemID specialrange !
          if (pItemID >= Ord(Csts_reserved1_id)) and (pItemID <= Ord(Csts_reserved20_id)) then
          begin
            Close;
            Clear;
            add(estbk_sqlclientcollection._SQLUpdateSettingValue2);
            paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
            paramByname('item_name').AsString := format('item_%d', [pItemID]);
            paramByname('item_value').AsString := copy(pItemValue, 1, 255);
            execSQL;
          end
          else
          begin
            Close;
            Clear;
            add(estbk_sqlclientcollection._SQLUpdateSettingValue);
            paramByname('user_id').AsInteger := pUserId;
            paramByname('item_name').AsString := format('item_%d', [pItemID]);
            paramByname('item_value').AsString := copy(pItemValue, 1, 255);
            execSQL;
          end; // ---
        end;

      finally
        Close;
        Clear;
      end;

    Result := True;
  except
    on e: Exception do
      messageDlg(e.message + ' item_' + IntToStr(pItemID) + ' ' + pItemValue, mtError, [mbOK], 0);
  end; // ---
end;

function Tdmodule.generateUserSettingsMD5: AStr;
var
  i: TStsIndex;
  pUserSettings: TAStrList;
  pDigest: TMD5Digest;
begin
  Result := '';
  // --

  try
    pUserSettings := TAStrList.Create;
    for i := low(TStsIndex) to high(TStsIndex) do
      pUserSettings.Add(self.FStsValues[i]);

    pDigest := md5.MD5String(pUserSettings.Text);
    Result := md5.MD5Print(pDigest);
  finally
    pUserSettings.Free;
  end;
end;

procedure Tdmodule.saveUserSettings;
var
  i: TStsIndex;
  pFailureCnt: integer;
begin
  // pole mõtet andmebaasi koormata, kui mitte midagi pole muutunud !
  if self.FUserSettingsMD5 = self.generateUserSettingsMD5 then
    Exit;

  // --
  pFailureCnt := 0;
  for i := low(TStsIndex) to high(TStsIndex) do
    try

      if pFailureCnt = 3 then
        SysUtils.abort;

      if not self._writeItemSettings(Ord(i), self.FStsValues[i]) then
        Inc(pFailureCnt);

    except
      break;
    end;
  // --
  self.FUserSettingsMD5 := self.generateUserSettingsMD5;
end;


procedure Tdmodule.fillWorkerList(const pCombobox: TCustomCombobox);
begin
  // TODO !
  pCombobox.Clear;
  pCombobox.Items.AddObject(estbk_strmsg.SUndefComboChoise, TObject(PtrInt(0)));
end;


procedure Tdmodule.fetchAccRefFormdLine(const pFormId: integer; const pRefFormdAccData: TObjectList);
var
  pBfrObj: TIntIDAndCTypes;
  pFormSubType: AStr;
begin
  with tempQuery, SQL do
    try
      Close;
      Clear;
      add(format('SELECT form_type FROM formd WHERE id=%d', [pFormId]));
      Open;
      pFormSubType := FieldByName('form_type').AsString;

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectRefDFormLines(pFormId, pFormSubType));

      Open;
      First;
      while not EOF do
      begin
        pBfrObj := TIntIDAndCTypes.Create;
        pBfrObj.id := FieldByName('baserecord_id').AsInteger;
        pBfrObj.id2 := FieldByName('line_id').AsInteger;
        pBfrObj.clf := FieldByName('account_coding').AsString;
        pBfrObj.clf2 := FieldByName('shortidef').AsString;

        pRefFormdAccData.Add(pBfrObj);
        Next;
      end;
      // --
    finally
      Close;
      Clear;
    end;
end;

// kasutab _declform / _formdrez
function Tdmodule.buildDefaultFormulaLine(const pLineId: integer; const pRefFormdAccData: TObjectList): AStr;
const
  //  CDefaultOperation = '[%s@DS]'; // deebetsaldo !
  CDefaultOperation = '[%s@SA]';
var
  i: integer;
begin
  Result := '';
  for i := 0 to pRefFormdAccData.Count - 1 do
    with TIntIDAndCTypes(pRefFormdAccData.Items[i]) do
      //if id=pLineId then
      if id2 = pLineId then // id üks on baserecord !!!
      begin

        if Result = '' then
          Result := format(CDefaultOperation, [clf]) // clf2 aktiva;passiva;
        else
          Result := Result + '+' + format(CDefaultOperation, [clf]);
      end;
  // --
end;

procedure Tdmodule.selfCheck;
const
  CTestValue: double = 1.9559;
  CTestValue2: double = 1.96;
begin
  with tempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_dbcompability.sqlp.assert_test_1_9559);
      Open;
      assert(CTestValue = double(FieldByName('test').AsFloat), '#1');
      assert(double(roundto(strtofloat(floattostr(CTestValue)), -2)) = double(CTestValue2), '#2');
    finally
      Close;
      Clear;
    end;
end;


procedure Tdmodule.loadClassificatorsIntoCombo(const pCombo: TCombobox; const pClassifType: AStr);
begin
  pCombo.Clear;
  pCombo.Items.AddObject(estbk_strmsg.SUndefComboChoise, TObject(0));
  // ---
  with self.TempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLSelectFromClassificator);
      parambyname('clftype').AsString := pClassifType;
      parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      First;
      while not EOF do
      begin
        pCombo.AddItem(FieldByName('clfname').AsString, TObject(PtrUInt(FieldByName('id').AsInteger)));
        // --
        Next;
      end;

      // --
      pCombo.ItemIndex := 0;
    finally
      Close;
      Clear;
    end;
end;

function Tdmodule.createNewGenLedgerMainRec(const pAccperiod: integer; // rp. period
  const pAccDate: TDate;   // kande kuupäev
  const pAccDesc: AStr;    // kirjeldus pearaamatu päises
  const pDocTypeId: TSystemDocType; const pDocNumber: AStr; const pGenLedgerRecType: AStr;
  // G;  CAccRecIdentAsGenLedger / CAccRecIdentAsBill ntx
  var pGenEntryMainRecId: integer; var pDocId: int64;
  // 28.12.2010 Ingamr
  // meie poolt loodud kande nr !
  const pOvrAccRecNumber: AStr = '';
  // reserveeritud !!!
  const pDisplayMsg: boolean = True // ntx kontrollime, kas samas perioodis on sama nr kanne, sama doc
  ): boolean;

var
  pNewGenLedgerEntry: integer;
  pNextLedgerEntryNr: AStr;
  pNextDocSystemNr: AStr;
  pNewDocumentRecId: int64;
  pSysDocId: integer;

begin
  Result := False;

  //---
  pDocId := 0;
  pNewGenLedgerEntry := 0;
  pGenEntryMainRecId := 0;



  // 16.02.2011 Ingmar seoses W7 bugiga
  if pAccDate < (now - 10 * 365) then
    raise Exception.Create(estbk_strmsg.SEInvalidDate + ' # ' + datetostr(pAccDate));



  // with qryGenLedgerEntrys,SQL do
  with tempQuery, SQL do
    try



      pNewGenLedgerEntry := estbk_clientdatamodule.dmodule.qryGenLedgerEntrysSeq.GetNextValue;

      if trim(pOvrAccRecNumber) = '' then
        pNextLedgerEntryNr := estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(PtrUInt(self), '',
          pAccDate, False, estbk_types.CAccGen_rec_nr, False)
      else
        pNextLedgerEntryNr := pOvrAccRecNumber;


      Close;
      Clear;
      add(estbk_sqlclientCollection._CSQLInsertNewAccReg);
      // pNewGenLedgerEntry
      paramByname('id').AsInteger := pNewGenLedgerEntry;
      paramByname('entrynumber').AsString := copy(pNextLedgerEntryNr, 1, 20);
      paramByname('transdescr').AsString := pAccDesc;
      paramByname('transdate').asDate := pAccDate;
      paramByname('accounting_period_id').AsInteger := pAccperiod;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;



      // 04.01.2010 ingmar
      paramByname('type_').AsString := pGenLedgerRecType;
      execSQL;
      //end; // ---



      // --------------------------------------------------------------------
      // dokument ka juurde !!!
      // automaatset nummerdamist enam ei kasuta !
      //pNextDocSystemNr:=estbk_clientdatamodule.dmodule.getUniqNumberFromNumerator(estbk_types.CDoc_recnr);
      pNewDocumentRecId := estbk_clientdatamodule.dmodule.qryGetdocumentIdSeq.GetNextValue;


      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLInsertNewDoc);

      parambyname('id').AsLargeInt := pNewDocumentRecId;
      //parambyname('document_nr').asString:=pNextDocSystemNr;
      parambyname('document_nr').AsString := pDocNumber;
      parambyname('document_date').asDate := pAccDate;
      parambyname('sdescr').AsString := ''; // jätame hetkel tühjaks ?


      // -----
      pSysDocId := estbk_lib_commonaccprop._ac.sysDocumentId[pDocTypeId];
      parambyname('document_type_id').AsInteger := pSysDocId;

      // ------------
      paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      parambyname('rec_changed').AsDateTime := now;
      paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;
      execSQL;


      // ---
      pDocId := pNewDocumentRecId;
      // --------------------------------------------------------------------


      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLInsertNewAccRegDoc);
      parambyname('accounting_register_id').AsInteger := pNewGenLedgerEntry;
      parambyname('document_id').AsLargeInt := pNewDocumentRecId;
      paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      parambyname('rec_changed').AsDateTime := now;
      execSQL;


      // ---
      Result := True; // OK
      pGenEntryMainRecId := pNewGenLedgerEntry;

    finally
      Close;
      Clear;
    end;
end;



function Tdmodule.createAccChildRec(const paccRec: TAccoutingRec; const doConversion: boolean = True): int64;
var
  pCurrExcRate: double;
  pCurr: AStr;
  pCurrRate: double;
  pAccountingRec: int64;
begin
  assert(assigned(paccRec) and (paccRec.currencyIdentf <> ''));
  // ---
  with self.tempQuery, SQL do
    try
      Close;
      Clear;


      pCurrRate := 0; // --
      pCurr := estbk_globvars.glob_baseCurrency;



      // --------
      add(estbk_sqlclientCollection._CSQLInsertNewAccDCRec);

      pAccountingRec := self.qryGenLedgerAccRecId.GetNextValue;
      paramByname('id').asLargeInt := pAccountingRec;
      paramByname('accounting_register_id').AsInteger := paccRec.regMRec;
      paramByname('account_id').AsInteger := paccRec.accountId;


      paramByname('descr').AsString :=
{$IFNDEF NOGUI}
        copy(paccRec.descr, 1, 255);
{$ELSE}
      copy(paccRec.descr, 1, 255);
{$ENDIF}
      paramByname('rec_nr').AsInteger := paccRec.recNr;
      paramByname('client_id').AsInteger := paccRec.clientId;



      // kui puudub valuuta ID, siis eeldame valuutakurss antakse ette !
      if paccRec.currencyID < 1 then
      begin
        pCurrRate := paccRec.currencyRate;
        if pCurr = estbk_globvars.glob_baseCurrency then
          paramByname('currency_drate_ovr').asCurrency := 1.00
        else
          paramByname('currency_drate_ovr').asCurrency := pCurrRate; // nö summa rida originaal valuutas !!!
      end;



      if pCurrRate = 0 then
        pCurrRate := 1;



      // KANDEREA PÕHISUMMA ALATI BAASVALUUTAS, ORIGINAALSUMMA ON currency_vsum väljal !!!!!
      paramByname('rec_sum').asCurrency := roundto(paccRec.sum * pCurrRate, Z2);
      paramByname('rec_type').AsString := paccRec.recType;


      paramByname('currency_id').AsInteger := paccRec.currencyID;
      paramByname('currency').AsString := pCurr;

      paramByname('currency_vsum').asCurrency := paccRec.sum; // nö summa rida originaal valuutas !!!



      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('status').AsString := '';
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      execSQL;


      // -------
      Result := pAccountingRec;

    finally
      Close;
      Clear;
    end;
end;

// -- kuivõrd korrektne sees on; kannet niisama uuendada, kas peaks tegema koopia kandest ?!?
function Tdmodule.updateGenLedgerMainRec(const pGenEntryMainRecId: integer; // kande aluskirje mida uuendada
  const pAccDate: TDate;   // kande kuupäev
  const pAccDesc: AStr;    // kirjeldus pearaamatu päises
  const pDocNumber: AStr;
  // reserveeritud !!!
  const pDisplayMsg: boolean = True // ntx kontrollime, kas samas perioodis on sama nr kanne, sama doc
  ): boolean;  // hetkel väljund ei oma erilist tähtsust !
var
  pPossibleNewAccPeriod: integer;
begin
  Result := False;
  with tempQuery, SQL do
    try
      // ntx võtame maksekorralduse, raamatupidaja oli segaduses ja soovib siiski kanda teise raamatupidamisaastasse summa
      pPossibleNewAccPeriod := self.getAccoutingPerId(pAccDate);
      if pPossibleNewAccPeriod <= 0 then
        abort;

      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLUpdateAccReg);
      paramByname('transdescr').AsString :=
{$IFNDEF NOGUI}
        copy(pAccDesc, 1, 255);
{$ELSE}
      copy(pAccDesc, 1, 255);
{$ENDIF}
      paramByname('transdate').AsDateTime := pAccDate;

      // ---
      paramByname('accounting_period_id').AsInteger := pPossibleNewAccPeriod;

      paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_changed').AsDateTime := now;
      paramByName('id').AsInteger := pGenEntryMainRecId;
      execSQL;
      // --
      Result := True;
    finally
      Close;
      Clear;
    end;
end;

function Tdmodule.getAccoutingPerId(const pDate: TDate; const pDisplayMsg: boolean = True): integer;
begin
  Result := 0;
  // --
  with tempQuery, SQL do
    try

      // kas periood üldse on olemas...
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLCheckAccperiod);
      //paramByName('accdate').asString:=estbk_utilities.datetoOdbcStr(billDate.date);
      paramByName('accdate').AsString := estbk_utilities.datetoOdbcStr(pDate);
      paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;

      Open;
      if EOF then
      begin

        if pDisplayMsg then
          Dialogs.messageDlg(estbk_strmsg.SEAccDtPeriodNotFound, mtError, [mbOK], 0);
        // ----
        //billDate.setFocus;
        Exit;
      end;

      // ---
      // C - closed
      if pos('C', AnsiUpperCase(FieldByName('status').AsString)) > 0 then
      begin

        if pDisplayMsg then
          Dialogs.messageDlg(estbk_strmsg.SEAccDtPeriodClosed, mtError, [mbOK], 0);
        // ----
        //billDate.setFocus;
        Exit;
      end;

      Result := FieldByName('id').AsInteger;
    finally
      Close;
      Clear;
    end; // ---
end;

// hetkel kutsub välja panga laekumised !
// lugeda avatud per vahemikud hash tabelisse, kiirus N x suurem
function Tdmodule.getAccoutingPerId2(const pDate: TDate): integer;
begin
  self.getAccoutingPerId(pDate, False);
end;

procedure Tdmodule.loadListOfCurrencys;
const
  CCommonPreDefCurr: array[0..2] of AStr = ('EUR', 'USD', 'GBP');
var
  i: integer;
begin
  estbk_utilities.clearStrObject(TAStrings(self.FCurrDataList));


  // self.FCurrDataList.Add('');
  FCurrDataList.addObject(estbk_globvars.glob_baseCurrency, nil);

  for i := low(CCommonPreDefCurr) to high(CCommonPreDefCurr) do
    if (CCommonPreDefCurr[i] <> estbk_globvars.glob_baseCurrency) then
      FCurrDataList.addObject(CCommonPreDefCurr[i], nil);




  with tempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectCurrencyNames);
      Open;
      while not EOF do
      begin
        if self.FCurrDataList.indexOf(AnsiUpperCase(FieldByName('cname').AsString)) = -1 then
          self.FCurrDataList.addObject(AnsiUpperCase(FieldByName('cname').AsString), nil);
        // --
        Next;
      end;
    finally
      Close;
      Clear;
    end;
  // ------------

end;

function Tdmodule.createPrivateCurrListCopy(): TAStrList;
var
  i: integer;
  pValObj: estbk_lib_commoncls.TCurrencyObjType;
begin
  Result := TAStrlist.Create;
  //if  creatEmptyEntry then
  //    result.addObject('',estbk_types.TCurrencyObjType.create);




  for i := 0 to self.FCurrDataList.Count - 1 do
  begin
    pValObj := estbk_lib_commoncls.TCurrencyObjType.Create;
    Result.addObject(self.FCurrDataList.Strings[i], pValObj);

    if self.FCurrDataList.Strings[i] = estbk_globvars.glob_baseCurrency then
      pValObj.currVal := 1.000;
  end;
end;


// valuutakursside download "teenus"
// ---------------------------------------------------------------------------
// --- VALUUTAKURSID ---------------------------------------------------------
// ---------------------------------------------------------------------------
//  http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html
(*
"AED";"2,8834400000"
"ARS";"2,7754200000"
"AZN";"13,1811000000"
"AUD";"9,6023200000"
"BGN";"7,9992400000"
"BRL";"6,0056700000"
"BYR";"0,0038681500"
"CAD";"9,8046600000"
"CHF";"10,3660000000"
"CNY";"1,5511400000"
"CZK";"0,5915110000"
"DKK";"2,1024900000"
"EGP";"1,9340200000"
"EUR";"15,6466000000"
"GBP";"17,3703000000"
"GEL";"6,3181200000"
*)
// antud lugemine teha universaalsemaks !!!
// ntx välispankade formaadid; samuti EP formaat võiks olla universaalselt kirjeldatud !
function Tdmodule.OnReadLineNotification(const filename: AStr; const linenr: integer; const Data: AStr): boolean;
  // --
  function remUnnecessaryChars(const str: AStr): AStr;
  begin
    Result := trim(str);
    Result := stringreplace(Result, '"', '', [rfReplaceAll]);
    Result := stringreplace(Result, chr(39), '', [rfReplaceAll]);
    Result := stringreplace(Result, #32, '', [rfReplaceAll]);
  end;

const
  CBankCSeparator = ';';

var
  FErrorLine: AStr;
  FCurrShortDesc: AStr;
  FCurrVal: AStr;
  FCurrDate: AStr;
  FCurrValDbl: double;

begin
  Result := True;
  // nö peaks olema positsioonide definitsioonide valik; hetkel hardcoded !
  FCurrShortDesc := estbk_utilities.getStrDataFromPos(CBankCSeparator, 1, Data);
  FCurrShortDesc := remUnnecessaryChars(FCurrShortDesc);

  FCurrVal := trim(estbk_utilities.getStrDataFromPos(CBankCSeparator, 2, Data));
  FCurrVal := remUnnecessaryChars(FCurrVal);
  FCurrVal := estbk_utilities.setRFloatSep(FCurrVal);

  FCurrDate := trim(estbk_utilities.getStrDataFromPos(CBankCSeparator, 3, Data));
  FCurrDate := remUnnecessaryChars(FCurrDate);


  if (length(FCurrShortDesc) = 3) and (length(FCurrVal) > 0) then
    with tempQuery do
      try
        // siin peaks tulevikus laskma ka separaatori defineerida !!
        // SetRoundMode
        if not Math.isZero(StrToFloatDef(FCurrVal, 0)) then
          FCurrValDbl := RoundTo(1 / StrToFloatDef(FCurrVal, 0), -4) // toetame 4 kohta peale koma !
        else
          FCurrValDbl := 0.00;
        paramByname('curr_name').AsString := FCurrShortDesc;
        paramByname('curr_rate').AsFloat := FCurrValDbl;
        paramByname('curr_date').AsString := FCurrDate;
        execSQL;

      except
        on e: Exception do
        begin
          Result := False;
          FErrorLine := format(estbk_strmsg.SECurrTableUpdateFailed, ['(' + FCurrShortDesc + ':' + FCurrDate + ') ' + #13#10 + e.message]);
          Dialogs.MessageDlg(FErrorLine, mtError, [mbOK], 0);

          abort;
        end;
      end;

  application.ProcessMessages;

end;


// TODO !!!
// TODO: panna ka konf, kus kohast me andmed võtame !!!!!
// hetkel hardcoded Eesti Panga url
function Tdmodule.downloadCurrencyData(const useIntDate: boolean = True; const altDate: TDateTime = -1): boolean;

var
  FGetCurr: TEstbkCurrencyExcRateReader;
  Fdummy: TDatetime;
  FCurrVal: TDatetime;
  FCurrFetchDt: TDatetime;
  FDownLoadCurr: boolean;
begin

  try
    Result := False;

    if assigned(Application.MainForm) then
      Application.MainForm.Enabled := False;

    // --------------------------------------------
    self.FCurrDownloadDummyTimer.Tag := 0;
    self.FCurrDownloadDummyTimer.Enabled := True;

    // --
    try
      FGetCurr := TEstbkCurrencyExcRateReader.Create;

      if useIntDate then
      begin
        FCurrFetchDt := now; // date-1
        if dateutils.HourOf(FCurrFetchDt) < 12 then
          FCurrFetchDt := date - 1;
      end
      else
        FCurrFetchDt := altDate;

      if FCurrFetchDt > now then
        Exit;




      // !!!!!!!!!!!!!!!!!!!!!!! HARDCODED
      // 'http://nowhere'
      // Alates 01.01.2011 meil Euroopa Keskpanga kursid !
      // 'http://www.eestipank.info/dynamic/erp/erp_csv.jsp?day=%d&month=%d&year=%d&type=4&lang=et',
      {
      FGetCurr.url := format('http://www.eestipank.info/dynamic/erp/erp_csv.jsp?day=%d&month=%d&year=%d&type=4&lang=et',
                             [dateutils.DayOf(FCurrFetchDt),
                              dateutils.MonthOf(FCurrFetchDt),
                              dateutils.YearOf(
                              FCurrFetchDt)]);

      }

      // nüüd pean kuupäeva etteandma, et teada saada, millise kuupäeva asju tehatakse
      // miskitpärast keskpank ei anna ajalugu ? Vaid üks suur zip faili 1999 aastasse välja tsiisas
      // tuleb arvestada kuupäevadega ja linkidega; ntx tänased kursid ja >=90 päeva ning ajalugu




      // ------------------ konf faili panna !
      FGetCurr.currDate := FCurrFetchDt;

      if dateutils.DaysBetween(now, FCurrFetchDt) = 0 then
        FGetCurr.url := 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'
      else
      if dateutils.DaysBetween(now, FCurrFetchDt) <= 90 then
        FGetCurr.url := 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'
      else
        FGetCurr.url := 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.xml'; // jube monstrum xml :(



      FGetCurr.OnReadLineNotification := @self.OnReadLineNotification;




      // jätame mulje, et timer ka midagi tegi
      FDummy := now;
      //Fdummy:=dateutils.incsecond(FDummy,10); mingi eriti loll FPC bugi 2.2.4; 1899 aasta tuleb !
      FDummy := now + (3 / 24 / 60 / 60);
      FCurrVal := now;

      while FDummy > FCurrVal do
      begin
        application.ProcessMessages;
        FCurrVal := now;
      end;

      //with estbk_clientdatamodule.dmodule do
      try

        primConnection.StartTransaction;
        // ---
        with tempQuery, SQL do
        begin

          FDownLoadCurr := False;
          Close;
          Clear;
          add(estbk_sqlclientcollection._SQLVerifyNeedOfCurrFetch);
          // 05.11.2009 Ingmar;
          // ja ei töötagi otse datetimega kutsudes päringud, täitsa masendav
          // paramByname('curr_date').AsString :='2009-11-05'; // FCurrFetchDt;

          paramByname('curr_date').AsString := estbk_utilities.datetoOdbcStr(FCurrFetchDt); // FCurrFetchDt;
          Open;



          FDownLoadCurr := tempQuery.EOF;
          // --------
          if FDownLoadCurr then
          begin
            Close;
            Clear;

            // lukustus peale, et teised samal ajal ei hakkaks andmeid sisestama
            // There is no UNLOCK TABLE command; locks are always released at transaction end
            case estbk_dbcompability.sqlp.currentBackEnd of
              __postGre:
              begin
                add('LOCK TABLE currency_exc');
                execSQL;
              end;
            end;

            // insert SQL peale
            Close;
            Clear;
            add(estbk_sqlclientcollection._CSQLInsertCurrencySQL);
            // --
            paramByname('curr_date').AsDateTime := FCurrFetchDt;
            paramByname('rec_changed').AsDateTime := now;
            paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
            paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
            // event paneb paika ülejäänud parameetrid !!!




            // HARDCODED
            // 01.01.2011 Ingmar; seoses euroga ja formaadi muutusest, loeme ju ekp'st andmed !
            // result:=FGetCurr.startreader(2); // HARCODED alates 2 reast loeme andmeid
            Result := FGetCurr.startreader(1);


            // -- mingi viga; USD ei leita, samas teised kursid leitakse; kas keskpank edastab osaliselt kursse ?!?
            // -- 20.02.2011 Ingmar; müstika, keskpank ei edasta nädalavahetuse kursse
            // peame küsima, kuidas teha, kui arve kp on nädalavahetusel, siis peaks võtma reedesed kursid ?!?
                    {$ifdef debugmode}
                    (*
                    Close;
                    Clear;
                    Add('select * from currency_exc where curr_date=:curr_date and curr_name=''USD''');
                    parambyname('curr_date').AsString:=datetoOdbcStr(FCurrFetchDt);
                    open;



                    first;
                 if eof then
                    raise exception.Create('Not all exc rates are updated ! '+datetoOdbcStr(FCurrFetchDt)+' (USD)');
                    Close;
                    Clear;
                    *)
                    {$endif}

            // ------------------
          end; // -->
        end;

        primConnection.Commit;

      except
        if primConnection.InTransaction then
          try
            primConnection.Rollback;
          except
          end;
        raise; // laseme viimasel handleril ära teha kogu räpase töö
      end;

    finally

      if assigned(Application.MainForm) then
        Application.MainForm.Enabled := True;


      FCurrDownloadDummyTimer.Tag := 100;
      self.FDownLoadCurrProgForm.Close;  // caFree vorm !!! ära kutsu freeAndNil !
      self.FDownLoadCurrProgForm := nil;
      //self.Enabled := True;
      // -
      FreeAndNil(FGetCurr);

      tempQuery.Close;
      tempQuery.SQL.Clear;
    end;

    // ---

  except
    on e: Exception do
    begin
      Result := False; // ***
      FCurrDownloadDummyTimer.Enabled := False;
      Dialogs.messageDlg(format(estbk_strmsg.SECantGetCurrVal, [e.message]), mtError, [mbOK], 0);
    end;
    // ------
  end;
end;


{
4. Ristkurss. Erakliendid või väiksemad pangad võivad soovida teha tehingud mitte USA dollarites,
vaid vahetades naelu Šveitsi frankide vastu või kasutades muud valuutakombinatsioone.
Sellistel juhtudel kasutatakse ristkursi.

Ristkurss (cross rate) on kahe valuuta omavaheline kurss, mis on arvutatud kolmanda valuuta kaudu.

Näide. Oletame, et Uus-Meremaa dollari (NZ$) ja Indoneesia ruupia noteeringud on vastavalt NZ$1,9552/US$ ja IR 2054/US$. Missugune on Uus-Meremaa dollari ristkurss  Indoneesia ruupiates?

Lahendus.


Vastus. Uus-Meremaa dollari ristkurss on 1050,5 Indoneesia ruupiat.

Et noteeringus näidatakse nii ostu- kui ka müügikursi, siis sama kehtib ristkurss puhul.

Näide. Indoneesia firma soovib osta Uus-Meremaa dollareid. Pank  noteering on:

NZ$1,9535–1,9560/US$

IR2050–2075/US$.

Missugune on ostu ristkurss?

Lahendus.


Vastus. Uus-Meremaa dollari ostu ristkurss on 1062,21 Indoneesia ruupiat.
}

// otsime üles viimase tööpäeva valuutakursid, ntx oli  nädalavahetuse arve
function Tdmodule.findValidWorkingDay(const pdate: TDatetime): TDatetime;
begin
  Result := pdate;
  if dateutils.DayOfTheWeek(Result) >= 6 then
    while dateutils.DayOfTheWeek(Result) >= 6 do
      Result := Result - 1;
end;


procedure Tdmodule.resetCurrObjVals(pCurrDate: TDate; (* const pCurrDate  : TDate; *)
  const pStrLstObj: TAStrList);
var
  i: integer;
begin
  // 20.09.2013 Ingmar
  pCurrDate := self.findValidWorkingDay(pCurrDate);

  // ---
  for i := 0 to pStrLstObj.Count - 1 do
    if assigned(pStrLstObj.Objects[i]) then
      with TCurrencyObjType(pStrLstObj.Objects[i]) do
      begin
        if AnsiUpperCase(pStrLstObj.Strings[i]) = estbk_globvars.glob_baseCurrency then
        begin
          currDate := pCurrDate;
          currVal := 1.00;
          id := 0;
        end
        else
        begin
          currDate := pCurrDate;
          currVal := 0;
          id := 0;
        end;
        // ---
      end;
end;

function Tdmodule.revalidateCurrObjVals(pCurrDate: TDate; (* const pCurrDate  : TDate; *)
  const pStrLstObj: TAStrList): boolean;
var
  pIndex: integer;
begin
  Result := False;

  // 20.09.2013 Ingmar
  pCurrDate := self.findValidWorkingDay(pCurrDate);

  // ---
  self.resetCurrObjVals(pCurrDate, pStrLstObj);
  // ---

  with tempQuery, SQL do
    try

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLFullSelectCurrencys);
      paramByname('curr_date').AsString := estbk_utilities.datetoOdbcStr(pCurrDate);
      Open;
      First;

      Result := not EOF;
      if Result then
      begin
        First;
        while not EOF do
        begin
          pIndex := pStrLstObj.indexOf(FieldByName('curr_name').AsString);
          if pIndex >= 0 then
          begin
            TCurrencyObjType(pStrLstObj.objects[pIndex]).currVal := FieldByName('curr_rate').AsFloat;
            TCurrencyObjType(pStrLstObj.objects[pIndex]).id := FieldByName('id').AsInteger;
          end;

          Next;
        end;
      end;

      pIndex := pStrLstObj.IndexOf(estbk_globvars.glob_baseCurrency);
      TCurrencyObjType(pStrLstObj.Objects[pIndex]).currVal := 1; // !!!!

    finally
      Close;
      Clear;
    end;
end;

// kasutaja seadetes hoitakse alles viimast nr
function Tdmodule.__getNumeratorCacheIndex(const pNumeratorType: TCNumeratorTypes; const pCacheGenledgerAccNr: boolean = False): TStsIndex;
begin
  Result := _nm.__getNumeratorCacheIndex(pNumeratorType, pCacheGenledgerAccNr);
end;

function Tdmodule.__resolveNumType(const pNumTypeAsStr: AStr): TCNumeratorTypes;
begin
  Result := _nm.__resolveNumType(pNumTypeAsStr);
end;

function Tdmodule.__getNumeratorCacheExt(const pCallerId: PtrUInt; const pCurrentNumVal: AStr; const pNumeratorType: TCNumeratorTypes;
  const pNumeratorDate: TDate; const pBookNumber: boolean;
  // st. kui false, siis võtame välja cachest ja kõik
  const pReloadNumber: boolean): AStr;
begin
  Result := _nm.__getNumeratorCacheExt(pCallerId, pCurrentNumVal, pNumeratorType, pNumeratorDate, pBookNumber, pReloadNumber);
end;

// märgime ära, et küsisime sellise järgmise seeria numbri...kui kohe ei kasuta, siis järgmine kord pakutakse ikka seda !
procedure Tdmodule.__markNumeratorValAsReserved(const pNumeratorType: TCNumeratorTypes; const pNumVal: AStr;
  const pCallerIsGeneralLedgerModule: boolean = False);
begin
  _nm.__markNumeratorValAsReserved(pNumeratorType, pNumVal, pCallerIsGeneralLedgerModule);
end;

procedure Tdmodule.__markNumeratorValAsReservedExt(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
  const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pReloadNumber: boolean; const pCallerIsGeneralLedgerModule: boolean);
begin
  _nm.__markNumeratorValAsReservedExt(pCallerId,
    pNumeratorType,
    pNumeratorVal,
    pNumeratorDate,
    pReloadNumber,
    pCallerIsGeneralLedgerModule);
end;

// 09.03.2012 Ingmar
procedure Tdmodule.__markNumeratorValAsUsedExt(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
  const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pCallerIsGeneralLedgerModule: boolean = False);
begin
  _nm.__markNumeratorValAsUsedExt(pCallerId,
    pNumeratorType,
    pNumeratorVal,
    pNumeratorDate,
    pCallerIsGeneralLedgerModule);
end;

procedure Tdmodule.markNumeratorValAsUsed(const pCallerId: PtrUInt; const pNumeratorType: TCNumeratorTypes;
  const pNumeratorVal: AStr; const pNumeratorDate: TDatetime; const pCallerIsGeneralLedgerModule: boolean = False);
begin
  _nm.markNumeratorValAsUsed(pCallerId,
    pNumeratorType,
    pNumeratorVal,
    pNumeratorDate,
    pCallerIsGeneralLedgerModule);
end;

// frame karjub, et ta pannakse kinni ning sisuliselt broneeritud numeraatorid võib vabaks lasta ja tabelisse kirjutada
procedure Tdmodule.notifyNumerators(const pCallerId: PtrUInt);
begin
  _nm.notifyNumerators(pCallerId);
end;

function Tdmodule.formatNumerator(const pNumVal: string; const pDate: TDatetime; const pNumFmt: string;
  const pThrowException: boolean = True): string;
begin
  Result := _nm.formatNumerator(pNumVal, pDate, pNumFmt, pThrowException);
end;


function Tdmodule.extractNumberFromNumerator(const pNumVal: AStr; const pNumFmt: AStr): AStr;
begin
  Result := _nm.extractNumberFromNumerator(pNumVal, pNumFmt);
end;

function Tdmodule.couldbeCustomNumerator(const pNumVal: string; const pDate: TDatetime; const pNumFmt: AStr): boolean;
begin
  Result := _nm.couldbeCustomNumerator(pNumVal, pDate, pNumFmt);
end;

function Tdmodule.queryNumFormat(const pNumType: AStr; const pAccPeriodId: integer; var pNumPrefix: AStr; var pNumFmt: AStr): boolean;
begin
  Result := _nm.queryNumFormat(pNumType, pAccPeriodId, pNumPrefix, pNumFmt);
end;

function Tdmodule.doFinalNumeratorFmt(const pVal: AStr; const pNumType: AStr; const pAccPeriodId: integer; const pDate: TDatetime): AStr;
begin
  Result := _nm.doFinalNumeratorFmt(pVal, pNumType, pAccPeriodId, pDate);
end;

// 19.09.2009 Ingmar; nummerdamise koht ümber teha, hetkel näen sellega palju probleeme.
// Test lahendus !
function Tdmodule.getUniqNumberFromNumerator(const pCallerId: PtrUInt; const pCurrentNumVal: AStr; const pNumeratorDate: TDate;
  const pReloadNumber: boolean; // ----
  const pNumeratorType: TCNumeratorTypes = estbk_types.CAccGen_rec_nr; const pBookSrNr: boolean = True;
  const pCallerIsGeneralLedgerModule: boolean = False): AStr;
begin
  Result := _nm.getUniqNumberFromNumerator(pCallerId, pCurrentNumVal, pNumeratorDate, pReloadNumber, pNumeratorType,
    pBookSrNr, pCallerIsGeneralLedgerModule);
end;

// ntx osad numeraatorid ei tohigi muutuda ! seome need kõige esimese maj. aastaga;
function Tdmodule.generateStaticNumAccPeriod(const pNumeratorType: TCNumeratorTypes; var pAccPeriod: integer): boolean;
begin
  Result := _nm.generateStaticNumAccPeriod(pNumeratorType, pAccPeriod);
end;

procedure Tdmodule.qryAccPeriodsFilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  pDate: TDatetime;
  pStart: TDatetime;
  pEnd: TDatetime;
begin
  if DataSet.Tag > 0 then
  begin

    pDate := TDatetime(DataSet.Tag);
    pStart := Trunc(Dataset.FieldByName('period_start').AsDateTime);
    if Dataset.FieldByName('period_end').IsNull then
      pEnd := Trunc(pStart + 999)
    else
      pEnd := Trunc(Dataset.FieldByName('period_end').AsDateTime);

    Accept := pos(estbk_types.CRecIsClosed, DataSet.FieldByName('status').AsString) = 0;
    if Accept then
      Accept := Accept and (pDate >= pStart) and (pDate <= pEnd);
  end;
end;


function Tdmodule.isValidAccountingPeriod(const pDate: TDatetime; var pAccPeriodId: integer): boolean;
var
  pTag: PtrInt;
begin
  Result := False;
  // 14.03.2012 Ingmar; meil pole pidevalt mõttekas tõmmelda kuupäeva otsimisel, tihti ka sama kuupäev !
  if not Math.IsNan(self.FCheckAccPerLastDate) and (FCheckAccPerLastID > 0) then
  begin
    // me ei saa kuu kaupa võrrelda !
    if dateutils.DaysBetween(pDate, FCheckAccPerLastDate) = 0 then
    begin
      Result := True;
      pAccPeriodId := self.FCheckAccPerLastID;
      Exit; // ---
    end;
  end;


  with qryAccPeriods do
    try
      pTag := tag;
      pAccPeriodId := 0;

      First;
      Filtered := False;

      // * locate trikid ei pruugi toimida vararrayof([])
      // * üldiselt filter muutuja kaudu ei tööta asjad õigesti; teeme ühe "hacki", kasutame onfilterrecord eventi, et sooritada võrdlused õigesti !
      //Filter:='period_start<>null'
      Tag := PtrInt(Trunc(pDate)); // aus olles meid huvitab vaid kuupäev !
      Filtered := True;

      Result := RecordCount = 1;
      if Result then
      begin
        pAccPeriodId := FieldByName('id').AsInteger;
        self.FCheckAccPerLastID := pAccPeriodId;
        self.FCheckAccPerLastDate := pDate;
      end
      else
      begin
        self.FCheckAccPerLastDate := Nan;
        self.FCheckAccPerLastID := -1;
      end; // ---
    finally
      tag := pTag;
    end;
end;

procedure Tdmodule.DataModuleCreate(Sender: TObject);
var
  pAppSetDir, pLocalIni: AStr;
begin
  FCheckAccPerLastDate := Nan;
  FCheckAccPerLastID := -1;
  glob_userSettings := estbk_settings.TUserSettings.Create(self.FStsValues); // need kirjutatakse baasi, mitte kettale
  FCompanyLogo := TImage.Create(nil);

  self.FCurrDataList := TAStrList.Create;
  self.FClientFastSrcList := TAStrList.Create;
  self.FPaymentTerms := TAStrList.Create;



  // glob vars'i viia !!
  self.FDefaultDuePerc := 0.07;
  // 02.12.2011 Ingmar
  try
    // * first check in current dir; but don't autocreate files
    pLocalIni := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0))) + estbk_types.CStiigoGeneralIniFileName;
    if not FileExists(pLocalIni) then
    begin
      pAppSetDir := SysUtils.GetAppConfigDir(True);

      if not SysUtils.DirectoryExists(pAppSetDir) then
        SysUtils.ForceDirectories(pAppSetDir);
    end
    else
      pAppSetDir := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)));

    self.FGlobalIni := IniFiles.TIniFile.Create(pAppSetDir + estbk_types.CStiigoGeneralIniFileName);
  except
    FreeAndNil(self.FGlobalIni);
  end;
end;

// 02.03.2012 Ingmar;
procedure Tdmodule.loadNumeratorValHistory;
begin
  _nm.loadNumeratorValHistory;
end;


procedure Tdmodule.saveNumeratorValHistory;
begin
  _nm.saveNumeratorValHistory;
end;

procedure Tdmodule.DataModuleDestroy(Sender: TObject);
begin

  // 08.08.2011 Ingmar; kui polnud connected oli probleem olemas
  if self.primConnection.Connected then
  begin
    self.saveNumeratorValHistory;
    self.saveUserSettings;
  end;


  FreeAndNil(glob_userSettings);

  estbk_utilities.clearStrObject(TAStrings(self.FCurrDataList));
  estbk_utilities.clearStrObject(TAStrings(self.FClientFastSrcList));

  FreeAndNil(self.FCurrDataList);
  FreeAndNil(self.FClientFastSrcList);
  FreeAndNil(self.FPaymentTerms);
  FreeAndNil(FCompanyLogo);

  if assigned(self.FGlobalIni) then
    try
      FreeAndNil(self.FGlobalIni);
    except
    end;
end;


procedure Tdmodule.FCurrDownloadDummyTimerStartTimer(Sender: TObject);
begin
  // tõmbame alla valuutakursid
  if not assigned(self.FDownLoadCurrProgForm) then
  begin
    self.FDownLoadCurrProgForm := Tform_progress.Create(self, 1, 100);
    // vorm vabastab ise ennast !
    self.FDownLoadCurrProgForm.statusBarText := estbk_strmsg.SUpdatingCurrValues;

    self.FDownLoadCurrProgForm.Show;
    //self.Enabled := False;
  end;
end;

procedure Tdmodule.FCurrDownloadDummyTimerTimer(Sender: TObject);
var
  FCVal, pTmp: integer;
  //FDEnd: boolean;
begin

  FCVal := TTimer(Sender).Tag;
  if FCVal < 99 then
  begin
    //Inc(TTimer(Sender).Tag) FRC2.4.0 ei luba enam seda
    pTmp := TTimer(Sender).Tag;
    Inc(pTmp);
    TTimer(Sender).Tag := pTmp;
  end
  else
  begin
    TTimer(Sender).Enabled := False;
    //FCVal := 100;
    //FDEnd:=true;
  end;
  // fiktiivne stepping !
  self.FDownLoadCurrProgForm.doStepping(FCVal);

  //if FDEnd then
  //   self.FDownLoadCurrProgForm := nil;
  // application.processmessages;
end;




procedure Tdmodule.loadPaymentTerms;
var
  pVal: PtrInt;

begin
  with tempQuery, SQL do
    try
      FPaymentTerms.Clear;
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLSelectPaymentTerms);

      Open;
      First;
      while not EOF do
      begin

        pVal := strtointdef(FieldByName('value').AsString, 0);
        if pVal < 0 then
          case pVal of
            CPaymentTermAsCashPayment: pVal := high(PtrInt) + CPaymentTermAsCashPayment + 1;
            CPaymentTermAsCreditCard: pVal := high(PtrInt) + CPaymentTermAsCreditCard + 1;
          end;

        FPaymentTerms.addObject(FieldByName('name').AsString, TObject(pVal));
        Next;
      end;

    finally
      Close;
      Clear;
    end;
end;

// NB !!! jätab meelde ntx viimased arve nr, maksekorralduse nr
function Tdmodule.__usrSettingsSpecialRange: AStr;
var
  pSpecialRange: TStsIndex;
begin
  Result := '';
  for pSpecialRange := Csts_reserved1_id to Csts_reserved20_id do
  begin
    if Result <> '' then
      Result := Result + ',';
    Result := Result + quotedStr(format('item_%d', [Ord(pSpecialRange)]));
  end;
end;

procedure Tdmodule.loadAllUserSettings;
var
  pOrdNr: integer;
  pSQL: AStr;
  pSPRange: AStr;

begin
  with tempQuery, SQL do
    try

      Close;
      Clear;
      // 07.08.2011 Ingmar; bugfix !
      pSQL := estbk_sqlclientcollection._SQLSelectAllUsrSettings;
      pSPRange := __usrSettingsSpecialRange;

      add(format(pSQL, [pSPRange, pSPRange]));
      paramByname('company_id').Value := estbk_globvars.glob_company_id;
      paramByname('user_id').AsInteger := estbk_globvars.glob_worker_id;
      Open; // ----


      // FIRMA põhised seaded, mis peavad kõigil samad olema !
      First;
      while not EOF do
      begin
        pOrdNr := strtointdef(stringreplace(FieldByName('item_name').AsString, 'item_', '', []), -1);
        if (pOrdNr >= Ord(low(TStsIndex))) and (pOrdNr <= Ord(high(TStsIndex))) then
          self.FStsValues[TStsIndex(pOrdNr)] := FieldByName('item_value').AsString;

        Next;
      end; // --


      self.FUserSettingsMD5 := self.generateUserSettingsMD5;
    finally
      Close;
      Clear;
    end;
end;

procedure Tdmodule.initApp;
begin

  // TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST
  // TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST
  // TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST


  // ka klassifikaatoritesse panna
  glob_inc_billSrcPhrases := 'arve nr:;arve';
  glob_inc_orderSrcPhrases := 'tellimus;tellimuse nr';




  // dokumendid
  estbk_lib_commonaccprop._ac.loadDocumentList(Self.tempQuery);


  // valuutad
  self.loadListOfCurrencys;

  // süsteemsed kontod
  estbk_lib_commonaccprop._ac.loadDefaultSysAccounts(Self.tempQuery);


  // maksetähtajad
  self.loadPaymentTerms;

  // kasutaja seaded
  self.loadAllUserSettings;

  // globaalsed spets. kasutajaseaded
  //estbk_globvars.glob_active_lang_forcerecode := isTrueVal(self._loadSpecialVarFromConf('encode_translations',0));


  // 03.01.2011 Ingmar
  // jätame meelde avatud raamatupidamisperioodid; kiiremad kontrollid !
  with qryAccPeriods, SQL do
  begin
    Close;
    Clear;
    add(estbk_sqlclientcollection._SQLSelectAllAccPeriods);
    paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
    Open;
  end;




  // küsime firma atribuudid
  with tempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLSelectCompany);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;

      estbk_globvars.glob_currcompname := FieldByName('company_name').AsString;
      estbk_globvars.glob_currcompregcode := FieldByName('regnr').AsString;
      estbk_globvars.glob_currcompvatnr := FieldByName('vatnumber').AsString;
      estbk_globvars.glob_currcompaddr := estbk_utilities.miscGenBuildAddr(FieldByName('countrycode').AsString,
        FieldByName('county_name').AsString, FieldByName('city_name').AsString, FieldByName('street_name').AsString,
        FieldByName('house_nr').AsString, FieldByName('apartment_nr').AsString, FieldByName('zipcode').AsString, addr_companyfmt);
      // ---------------------------------------------------------------------
      // --- Loeme sisse riikide info
      // ---------------------------------------------------------------------

      estbk_globvars.glob_preDefCountryCodes.Clear;
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLCountryNames);
      Open;
      First;
      while not EOF do
      begin
        estbk_globvars.glob_preDefCountryCodes.Values[trim(FieldByName('iso3').AsString)] := FieldByName('countyname').AsString;
        Next;
      end;

    finally
      Close;
      Clear;
    end;


  // --
  // 25.02.2014 Ingmar
  if trim(self.userStsValues[Csts_active_language]) <> '' then
    estbk_globvars.glob_active_language := trim(self.userStsValues[Csts_active_language]);

end;


// -- üldiselt autocomplete, kliendi kiireks leidmiseks
// UTF-8 LOCATE ei tööta ZEOS'es vähemalt Postgre baasiga !!!

procedure Tdmodule.reloadSharedCustData(const clientId: integer = -1);
var
  pSql: AStr;
  pName: AStr;
  pAddr: AStr;
  pCtype: AStr;
  pClientData: TClientData;
begin
  // kuvame esimesed 200 klienti
  with qryQuickSrcClientData, SQL do
    try
      estbk_utilities.clearStrObject(TAStrings(FClientFastSrcList));


      self.FClientFastSrcList.Duplicates := dupAccept;
      self.FClientFastSrcList.CaseSensitive := False;

      Close;
      Clear;
      psql := estbk_sqlclientcollection._SQLGetClientNPSQL(estbk_globvars.glob_company_id, clientId, '', '',
        '', -1, -1, -1, '', '', '', '', 9999999);



      // ----
      add(psql);
      // või teha load on request stiilis ! programm laeb kiiremini
      Open;

      First;
      while not EOF do
      begin
        pName := FieldByName('lastname').AsString;
        pCtype := FieldByName('ctype').AsString;

        if pCtype = estbk_types.CCust_LType then // juriidiline !
          pName := trim(FieldByName('custname').AsString)
        else
          pName := trim(pName + estbk_types.CInternalConcatMarker + FieldByName('custname').AsString);


        // Copy(sText, 1, iSelStart)
        // -- antud kiirotsing ei lae kõiki välju !
        pClientData := TClientData.Create();
        pClientData.FClientId := FieldByName('id').AsInteger;
        pClientData.FCustRegNr := FieldByName('regnr').AsString;
        //result.FCustName:=trim(FieldByName('custname').AsString + #32 +FieldByName('lastname').AsString);
        pClientData.FCustJCountry := FieldByName('countrycode').AsString;
        pClientData.FCustJCounty := FieldByName('countyname').AsString;
        pClientData.FCustJCity := FieldByName('cityname').AsString;
        pClientData.FCustJStreet := FieldByName('streetname').AsString;
        pClientData.FCustJHouseNr := FieldByName('house_nr').AsString;
        pClientData.FCustJApartNr := FieldByName('apartment_nr').AsString;

        {
        pAddr:= estbk_utilities.miscGenBuildAddr(fieldByName('countrycode').AsString,
                                                 fieldByName('countyname').AsString,
                                                 fieldByName('cityname').AsString,
                                                 fieldByName('streetname').AsString,
                                                 fieldByName('house_nr').AsString,
                                                 fieldByName('apartment_nr').AsString);
       }

        pClientData.FCustPurchRefNr := FieldByName('prefnumber').AsString;
        pClientData.FCustBankAccount := FieldByName('bank_accounts').AsString;
        pClientData.FClientCode := FieldByName('client_code').AsString;

        // ---------------
        // järjestus TAMMEVÄLI INGMAR !
        self.FClientFastSrcList.AddObject(pName, pClientData);
        //LowerCase
        //UpperCase
        Next;
        // ---
      end;
    finally
      Close;
      Clear;
    end;
end;

procedure Tdmodule.connect(const serverName: AStr; const serverPort: integer; const usrName: AStr; const usrPassword: AStr;
  var pDbVerIsOk: boolean; // 10.08.2011 Ingmar
  const onlyPreinit: boolean = False);
begin
  pDbVerIsOk := True;
  // ---
  with primConnection do
  begin
    LibraryLocation := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0))) + 'libpq.dll';
    User := usrName;
    // me välistame selle, et kasutaja saaks otse oma parooliga andmebaasile ligi !!!!
     {$ifndef debugmode}
    Password := estbk_utilities.passwordMixup(usrName, usrPassword);
     {$else}
    Password := usrPassword;
     {$endif}



    Protocol := estbk_dbcompability.sqlp.getCurrentBackEndProtocol;
    estbk_dbcompability.sqlp.initPropertiesByBackend(primConnection.Properties);
    Database := __dbNameOverride(estbk_types.CProjectDatabaseNameDef);

    HostName := serverName;
    Port := serverPort;
    if onlyPreinit then
      Exit; // -->


    // 08.11.2009 Ingmar
    try
      Connect; // ühendume...logimise protsessis püüa exception kinni
    except
      // proovime ka otse, siin peaks tulevikus kontrollima, kas ikka dbo, kui ei siis viskame kasutaja välja !!!!!!!!!!!!!!
      begin
        Password := usrPassword;
        Connect;
      end;
      // ----
    end;
    // 16.10.2009 ingmar; turvalisuse nimel kustutame parooli mälust !
    Password := '';
  end;


  // -- user_id ka meile vajalik; üldiselt admin saab kõike teha
  with tempQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_dbcompability.sqlp._isUserAdminSQL);
      Open;
      estbk_globvars.glob_usrIsadmin := isTrueVal(fields.FieldByNumber(1).AsString);


      // --
      Close;
      Clear;
      add('SELECT id,name,lastname FROM users WHERE loginname=:loginname');
      parambyName('loginname').AsString := usrName;
      Open;

      if not EOF then
      begin
        estbk_globvars.glob_worker_id := FieldByName('id').AsInteger;
        estbk_globvars.glob_usrname := trim(FieldByName('name').AsString + #32 + FieldByName('lastname').AsString);
      end
      else
      if not estbk_globvars.glob_usrIsadmin then
        raise Exception.Create(SEUserNotFound);

      // admin on 0 IDga
      // estbk_globvars.glob_worker_id:=0;
      // ------
    finally
      Close;
      Clear;
    end;



  // kontrollime, kas andmebaasi struktuurid on korras ja uuema versiooniga !
  pDbVerIsOk := self._verifySchemaVer;
  if not pDbVerIsOk then
    Exit;


  // FIRMA VALIK TEHA !!!!!!!!!!!!!!!
  // ----------------------------------
  // initsialiseerimine !!


  self.selfCheck;
  // ----------------------------------
  self.setUserCurrentWrkCompany();
  // ----------------------------------
  self.initApp;

  // ---
  self.reloadSharedCustData;
  self.loadListOfCurrencys;
end;

initialization
  {$I estbk_clientdatamodule.ctrs}

end.