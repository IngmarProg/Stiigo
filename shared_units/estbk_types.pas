unit estbk_types;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  DB, Classes, Contnrs, SysUtils, estbk_strmsg
  {$IFNDEF NOGUI}, Graphics {$ENDIF}
  {$IFDEF UNIX}, cwstring {$ENDIF};
// Fgl


const
  CCurrentDatabaseSchemaId = 1030; //  vaheversioon enne palka veaparandused !!!
// CCurrentDatabaseSchemaId = 1012; // täpsemalt öeldes kehtiv struktuuride versioon / programmi versioon siis ka
// = 18.07.2011; ver 1001 lisandus; et kõik laekumised, arved, kassa on täiesti erinevates nr seeriates ! samuti tuli kannete tabelile juurde billnr lahter !
// = 02.08.2011; ver 1002 parandasin arve triggeri ! kui arve summa oli negatiivne, siis märgiti ta laekunuks !
// = 07.08.2011; ver 1003 võtsin ära tobeda uniq indeksi user_settings pealt !
// = 08.08.2011; ver 1004 tobe bugi, mingitel hetkedel jäävad olematud aadressid andmebaasi !!! uuendan need 0 peale !
// = 10.08.2011; ver 1005 laekumiste kandeseeria kasutas pearaamatu numbriseeriat !
// = 18.08.2011; ver 1006 ära parandatud tõsine laekumiste bugi; kus laekumistele tekkis N + 1 kannet
// = 26.08.2011; ver 1007 käisin kõik kliendid üle ja parandasin nende CRC väärtused, ma olin tühiku valesti sisse jätnud
// = 30.08.2011; ver 1008 muutsin ära triggeri, mis arve staatuseid märgib !
// = 31.08.2011; ver 1009 incomings_bank omab nüüd teenustasu lahtrit !
// = 02.09.2011; ver 1010 artiklid tabelis rename reserved1 väljale, see nüüd arttype_id
// = 19.09.2011; ver 1011 numeraatorite rp perioodi võimalus juurde !
// = 23.12.2011; ver 1012 conf tabelis muutus userid -> company_id, sest meil confis vaja hoida vaid firma muutujaid !
// = 24.12.2011; ver 1013 lisasin portsu uusi õigusi
// = 13.02.2012; ver 1014; tegelikkuses midagi ei muutunudki, pidin vaheversiooni tegema; aga et uuesti töötajate tabelid looks, tõstame versiooni !
// = 18.02.2012; ver 1015; uued numeraatorid, lepingu number; siis kogu numeraatorite loogika muutmine; prefix väli numeraatorid tabelile
// = 02.03.2012; ver 1016; tuli tabel numerator cache, kus hoitakse kasutajate kasutamata numbreid
// = 06.03.2012; ver 1017; parandasin ära vea, kus TSD vormile pandi ka nimeks käibedeklaratsioon !
// = 05.04.2012; ver 1018; viitenumber arvetele, see puudus isegi ostuarvel ei saanud viitenumbrit salvestada !
// = 14.04.2012; ver 1019; lisasin kliendile swifti ja ibani !
// = 23.04.2012; ver 1020; lisasin triggeri, mis ei luba sama numbriga kannet samasse rp. perioodi !
// = 24.04.2012; ver 1021; pidin parandama ära triggeri vea !
// = 11.05.2012; ver 1022; triggeri fix; kassa väljaminek/sissetulek !
// = 09.08.2012; ver 1023; toetus sulgemiskandele, lisasin uue dok. tüübi
// = 02.03.2013; ver 1024; lisatud tabelid; __scwebusers  / __scwebusers
// = 06.05.2013; ver 1025; lisatud sentemails tabelile õigused, olin need ära unustanud !
// = 04.05.2014; ver 1026; lisasid täiendava välja artiklitesse, et teada mida kuvada; samuti kus arve pärit
// = 19.04.2015; ver 1027; lisasin kontoplaani auto km seotud väljad
// = 30.11.2015; ver 1028; lisatud sepa failide tabel
// = 01.12.2015; ver 1029; sepafile / sepafileentry vajavad ka õigusi !
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

const
  CAppName = 'Stiigo';

const
  CHttpStiigoUpdateDataURL = 'http://www.stiigo.com/updatelist.txt'; // muudatuste fail
  CHttpStiigoUpdateDirURL = 'http://www.stiigo.com/stiigofiles/';

const
  CUTF8BOM = #$EF#$BB#$BF;

const
  // CDummyEMailClient = 'Microsoft Office Outlook 12.0';
  CDummyEMailClient = 'Stiigo e-mailer ver 1.01';

// 09.08.2011 Ingmar; need ka juba teoreetiliselt konfitavad
const
  CProjectDatabaseNameDef = 'estbk';
  CProjectRolename = 'estbk_role';

const // samevalue viga
  CEpsilon = 0.00001;

const
  CEpsilon2 = 0.0001;

// TÜÜBID !
type
  AStr = string;
  AChar = char;
  TACSet = set of char;
  TABSet = set of byte;

  TAStrList = class(TStringList);
  TAStrings = class(TStrings);
  TADynIntArray = array of integer;
  TADynStrArray = array of AStr;
  WStr = WideString;

const
  CStiigoMutexId = 'B9B097C6231A43ADBD76FD493115660B'; // stiigo.exe
  CStiigoMutexId2 = 'B9B097C6231A43ADBD76FD493115660C'; // stiigoadmin.exe

const
  // CEMailRegExpr = '[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}';
  // CEMailRegExpr ='^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$';
  //  CEMailRegExpr ='^[\w]+(\.[\w]+)*@([a-z0-9]+(\.[a-z0-9]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$';
  //  CEMailRegExpr ='^[\w]+(\.[\w]+)*@([a-z0-9]+(\.[a-z0-9])*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$';
  // http://ex-parrot.com/~pdw/Mail-RFC822-Address.html
  CEMailRegExpr = '^[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$';



const
  CInternalConcatMarker = '&&';

// TDATETIME
const
  CZStartDate1980 = 29221; //19800101
  CZEndDate2050 = 54789; //20500101


// BASE DIR !
const
  CDir_Report = 'reports';
  CDir_Conf = 'conf';

// COMM FIESL
const
  CFile_bankfiledef = 'bankfiledef_incomings.xml';


// 26.11.2011 Ingmar lazarus leiab, et generics unit vigane !
//type
//    TIntegerList = specialize TFPGList<Integer>;
//    TDoubleList = specialize TFPGList<Double>;

// generic TList<T> = class
// end;
// TIntegerList = specialize TList<Integer>;

const
  // hetkel toetama Eesti keelset versiooni
  // et sorteerimine toimiks ja ka uppercase postgres
  //PostRequiredCollationAndCType  : AStr = 'Estonian_Estonia.1257'; // tulevikus muudetav vastavalt keelele !
  //CPostRequiredCollationAndCType = 'Estonian_Estonia';
  CPostRequiredCollationAndCType = 'Estonian';




const
  CLVRecStatus = [dsEdit, dsInsert];


//  TÄHTIS: siin ütleme, mis backendiga töötame !
// ------------------------------------------------
type
  TCurrentDatabaseBackEnd = (__postGre,
    __mySQL,
    __Oracle);



// All Users\Application Data\stiigo...
const
  CLoginDialogIniFileName = 'login.ini';
  CStiigoGeneralIniFileName = 'stiigo.ini';
  CStiigoGeneralIniSect = 'misc'; // sektsioon
  CStiigoNewsURL = 'http://www.stiigo.com/news.php?lang=%s';



// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


const
  CAllowedMaxDocFileSize = 8192 * 1024; // umbes 8 MB


// Numeratsiooniga tekkis disaini faasis kõige suurem segadus - kahjuks !
// väike disaini bugi, numeraatorid võiks viia osaliselt lahku;
// jutt käib tabelitest !
// NUMERAATORID

// ----------------------------------------------------------------------------
// NB !!! kõik tegevused peavad toimuma ENDA kandeseerias
// Jätan originaali alles, tulevikus võib ära kustutada ! TCNumeratorTypes2
// ----------------------------------------------------------------------------

type
  TCNumeratorTypes = (// RP.LAUSENDITE NR SEERIAD
    CAccGen_rec_nr,    // raamatupidamiskirjendi number; vaikimisi / pearaamat
    // TODO !!!!!
    CAccInc_rec_nr,    // laekumiste lausendite seerianumbrid

    // ARVED
    CAccSBill_rec_nr,  //  ABLNR => müügiarve lausendite seerianumbrer
    CAccPBill_rec_nr,  // ostuarve lausendite seerianumber
    CAccCBill_rec_nr,  // kreeditarve lausendite seerianumber
    CAccRBill_rec_nr,  // ettemaksuarve lausendi seerianumber; reaalselt pole see "arve"
    CAccDBill_rec_nr,  // viivisarved ka eraldi seeriatesse
    // --

    // TASUMINE
    CAccPmt_rec_nr,    // tasumise kandeseeria nr
    CAccCri_rec_nr,    // kassa laekumise kandeseeria nr => sissetulekuorder
    CAccCro_rec_nr,    // kassa laekumise kandeseeria nr => väljaminekuorder



    // DOKUMENTIDE NUMBRISEERIAD; KA TOOTED !
    CBill_doc_nr,      // - müügiarve number
    CCBill_doc_nr,     // - kreeditarve number;
    CDBill_doc_nr,     // - viivisarve number


    CPOrder_doc_nr,    // - ostutellimuse number
    CSOrder_doc_nr,    // - müügitellimuse number

    COffer_doc_nr,     // - pakkumise number
    CContr_doc_nr,     // - lepingu number

    CProd_sr_nr,       // - toote number/kood sõltub süsteemist; artikkel
    CSrv_sr_nr,        // - teenusekood
    CWProc_sr_nr,      // - lao artikkel

    CGen_doc_nr,      // - automaatne dokumentide numeratsioon
    // --

    CPMOrder_doc_nr,        // - (payment order)maksekorralduse nr
    CCSRegister_doc_recnr,  // -  kassa dokumendi numbriseeria

    // spetsiifiline !
    CClientId_idef,     // kliendi kood firma põhiselt !
    CWorkContr_nr       // töölepingu number
    );

type
  TCNumeratorTypesSet = set of TCNumeratorTypes;

// ostuarve, müügiarve, laekumine, tasumine, kassa, pank
const
  TNumeratorTypesSDescr: array[TCNumeratorTypes] of AStr = ('ACNR',  // # pearaamatu kanded
    'INCNR', // # laekumise kandeseeria nr

    'ABLNR', // # arvete kandeseeria nr; nüüdsest müügiarve !
    'ABPNR', // # ostuarvete kandeseeria
    'ABCNR', // # kreeditarve kandeseeria
    'ABRNR', // # ettemaksuarve kandeseeria
    'ABDNR', // # viivisarve kandeseeria ; reaalselt seda ei lähe vaja...veel mitte

    // --
    // tasumine
    'APMNR', // # panga tasumiste kandeseeria
    'ACINR', // # sissetulekuorder kandeseeria
    'ACONR', // # väljaminekuorder kandeseeria

    // ---- tavalised dok. numbrid
    'BLNR',  // müügiarve nr
    'CBLNR', // kreeditarve nr
    'CDLNR', // viivisarve nr
    'PONR',  // ostutellimuse nr
    'PSNR',  // müügitellimuse nr
    'OFFNR', // pakkumise nr
    'CNTNR', // lepingu (dok)nr
    'PDNR',  // toote/artikli nr
    'SRVNR', // teenusekoodi nr
    'WPNR',  // laoartikli nr;
    'DOCNR', // üldiste doc. nr

    // ---
    'PMONR',  // maksekorralduse doc. nr
    'CSRNR',  // kassa kande seeria nr


    'CLID',  //  kliendi tunnused firma põhiselt
    'WRKCT'  //  töölepingu number
    );

// Numeraatorite pikad kirjeldused !
const
  TNumeratorTypesLongName: array[TCNumeratorTypes] of AStr = (SNumMainGLSeries,       // SNumMainGLSeries   = Pearaamatu kandeseeria
    SNumIncGLSeries,        // SNumIncGLSeries = Laekumise kandeseeria
    SNumSaleBillGLSeries,   // SNumSaleBillGLSeries = Müügiarve kandeseeria
    SNumPurchBillGLSeries,  // SNumPurchBillGLSeries = Ostuarve kandeseeria
    SNumCreditBillGLSeries, // SNumCreditBillGLSeries = Kreeditarve kandeseeria
    SNumPrpBillGLSeries,    // SNumPrpBillGLSeries =  Ettemaksuarve kandeseeria
    SNumDueBillGLSeries,    // SNumDueBillGLSeries =  Viivisarve kandeseeria
    SNumPaymentGLSeries,    // SNumPaymentGLSeries = Tasumise kandeseeria
    SNumCashRegInGLSeries,  // SNumCashRegInGLSeries = Kassa sissetulekuorderi kandeseeria
    SNumCashRegOutGLSeries,
    // SNumCashRegOutGLSeries = Kassa väljaminekuorderi kandeseeria
    SNumSaleBillNr,         // SNumSaleBillNr = Müügiarve nr
    SNumCreditBillNr,       // SNumCreditBillNr = Kreeditarve nr
    SNumDueBillNr,          // SNumDueBillNr = Viivisarve nr
    SNumPurchOrdNr,         // SNumPurchOrdNr = Ostutellimuse nr
    SNumSalePurchOrdNr,     // SNumSalePurchOrdNr = Müügitellimuse nr
    SNumOfferNr,            // SNumOfferNr = Pakkumise nr
    '', // lepingu (dok)nr  tulevikus ntx teenuslepingud klientidega; reserveeritud
    '', // toote/artkli nr *** 3 järgnevat seotud artikliga
    '', // teenusekoodi nr
    '', // laoartikli nr;
    '', // üldine dokumentide numeratsioon; kasvõi dokumendihalduses
    SNumPaymentOrderDocNr,  // SNumPaymentOrderDocNr = Maksekorralduse dokumendi nr
    SNumCachRegGLSeries,    // SNumCachRegGLSeries = Kassa kandeseeria
    '', // kliendi tunnused firma põhiselt
    ''  // töölepingu number
    );




type
  TCNumeratorTypesDepr2 = (// RP.LAUSENDITE NR SEERIAD
    DeprCAccGen_rec_nr,   // raamatupidamiskirjendi number; vaikimisi / pearaamat
    // TODO !!!!!
    DeprCAccInc_rec_nr,   // laekumiste lausendite seerianumbrid
    DeprCAccBill_rec_nr,  // arvete lausendite seerianumbrid
    // --

    // DOKUMENTIDE NUMBRISEERIAD; KA TOOTED !
    DeprCBill_rec_nr,      // müügiarve number
    DeprCCBill_recnr,      // kreeditarve number;
    DeprCDBill_recnr,      // viivisarve number

    DeprCPOrder_recnr,     // ostutellimuse number
    DeprCSOrder_recnr,     // müügitellimuse number

    DeprCOffer_recnr,      // pakkumise number
    DeprCContr_recnr,      // lepingu number
    DeprCProd_recnr,       // toote number/kood sõltub süsteemist; artikkel
    DeprCSrv_recnr,        // teenusekood
    DeprCWProc_recnr,      // lao artikkel

    DeprCDoc_recnr,        // automaatne dokumentide numeratsioon
    // --
    DeprCPMOrder_recnr,    // (payment order)maksekorralduse nr
    DeprCCSRegister_recnr, // kassa numbriseeria
    // spetsiifiline !
    DeprCClientId_idef     // kliendi kood firma põhiselt !
    );

// ostuarve, müügiarve, laekumine, tasumine, kassa, pank
const
  TNumeratorTypesSDescr2: array[TCNumeratorTypesDepr2] of string =
    ('ACNR',  // pearaamatu kanded
    'INCNR', // laekumise kande seeria nr
    'ABLNR', // arvete kande seeria nr


    // ----
    'BLNR',  // müügiarve nr
    'CBLNR', // kreeditarve nr
    'CDLNR', // viivisarve nr
    'PONR',  // ostutellimuse nr
    'PSNR',  // müügitellimuse nr
    'OFFNR', // pakkumise nr
    'CNTNR', // lepingu (dok)nr
    'PDNR',  // toote/artikli nr
    'SRVNR', // teenusekoodi nr
    'WPNR',  // laoartikli nr;
    'DOCNR', // üldiste doc. nr

    'PMONR',  // maksekorralduse doc. nr
    'CSRNR',  // kassa kande seeria nr

    // --- kliendi tunnused firma põhiselt
    'CLID'
    );


// ----------------------------------------------------------------------------

// süsteemsed tunnused/muutujad
// TODO: vii eraldi unitisse
const
  CExcludePermission = 'D'; // on täiendav õiguse kirjeldus, mis näitab, et mingid õigused tuleb rollist välja arvata !


// ----------------------------------------------------------------------------
// konf muutujad
const
  CSchemaVer = 'estbk_schemaver';        // siin vastavalt versioonile hakkame uuendame tabeli struktuure
  CSchemaLastPerm = 'estbk_schema_lastperm';  // antud muutujad hoiame viimase õiguse indeksit; arenduse käigus tuleb õigusi juurde


// ----------------------------------------------------------------------------
const
  CDefaultCountry = 'EST'; // sisuliselt programm laeb selle järgi lokaalid; ntx valuutaühik kroon jne jne
// Operatsioonisüsteemi lokaalid pole alati just parimad, inimesed ei saa nende muutmisega hakkama

// ----------------------------------------------------------------------------
// COMMENT: 12.08.2009 ingmar; meil tunduvalt lihtsam ka vajadusel Delphisse portida, kui siin defineerime Str tüübid eraldi !!!!
const
  CRLF = #13#10;

// ---------------------------------------------------------------------------
// värvid
const

  MyFavGray = $EAEAEA; // silmale sõbralik helehall
  MyFavDarkGray = $8E8E8E;
  MyFavMediumGray = $CECECE;


  MyFavRed = $2F41C5;  // tumepunane, mis ei söö nö silmi välja
  MyFavRed2 = $3939DE;  // tumepunane2


  //MyFavOranc#D96E35
  MyFavBlue = $F4EEE1; // kena helesinine
  //MyFavOceanBlue = $FEF3E2; // suht meeldib helesinine
  //MyFavOceanBlue = $F1D8C0; // natuke tumedama tooniga helesinine
  //MyFavOceanBlue = $F8E4D8;
  //#DFE7FF

  MyFavLightRed = $D1E0F8;

  //MyFavOceanBlue = $FFE7DF;
  MyFavOceanBlue = $FFF4EE;
  MyFavOceanBlue2 = $FDF6E5;
  MyFavGreen = $D7FEDD;
 {$IFNDEF NOGUI}
  MyFavLightYellow = clInfoBk;
 {$ENDIF}
  MyFavUltaLightGreen = $DAFFEF;
  MyFavYellowGreen = $D4F4EF;



const
  MinAllowedDate = 35431;



const
  CDataOK = 0; // universaalne veakood, mis näitab, et kõik korras


// TIntegerList = TList<integer>;


// COMMENT: 12.08.2009 ingmar; kui võimalik PALUN ära kasuta widestringi; lazarus ja freepascal töötavad kenasti UTF8 peal
// widestring - aeglane; täielik mäluröövel
// TIntegerList = TList<Integer>;


// FloatToStrT(FloatValue,ffFixed, 18, -1)
// RAHAÜHIKUTE FORMAAT (format)
const
  CCurrentMoneyFmt1 = '%12.2f';   // format
  CCurrentMoneyFmt2 = '%.2f';     // format
  CCurrentAmFmt3 = '%.3f';     // format
  CCurrentAmFmt4 = '%.4f';     // format
  //CCurrentCurrFmt   = '#,##0.00'; // formatCurr
  CCurrentCurrFmt = '# ##0,00'; // formatCurr; # ##0.00
  CCurrentCurrFmt2 = '##0.00';   // formatFloat;
//  #,###,##0.00kr

//CCurrentCurrFmt   = '#'+#$A0+'##0,00';

// m ei sobi !
// Format('%.2n', [1234.56])
// FloatToStrF



// SEDA -2 muutes PEAD TEADMA MIDA TEED, KUI EI TEA, ÄRA MUUDA !!!!!!!!!!!!!
const
  Z2 = -2; // ümmardame 2 kohta peale koma
  Z3 = -3; // ümmardame 3 kohta peale koma
  Z4 = -4; // ümmardame 4 kohta peale koma

// sort order !
const
  SCAscDesc: array[boolean] of AStr = (' DESC ', ' ASC ');



// postgre ja teiste baaside kompatiibluse jaoks; eriti Oracle
const
  SCFalseTrue: array[boolean] of AStr = ('f', 't');




type
  TdtPeriod = (cdt_undefined = 0,
    cdt_today,
    cdt_currweek,
    cdt_prevweek,
    cdt_currmonth,
    cdt_prevmonth,
    cdt_ovrprevmonth,
    cdt_currentYear,
    // 14.07.2012 Ingmar
    cdt_prevYear,
    cdt_ovrprevYear
    );

  TdtPeriodSet = set of TdtPeriod;




// AADRESSI KUVAMISE FORMATEERING
type
  TCAddrFormat = (addr_defaultfmt,  // default formaat
    addr_companyfmt,  // firma mille all töötatakse
    addr_billfmt,     // arve
    addr_orderfmt,    // tellimus
    addr_pmtorderfmt  // sissetuleku order / väljamineku order
    );


// KONTOKLASS ntx hansas on;  Varad, Võlad, Omakapital, Tulud, Kulud
{
http://materjalid.tmk.edu.ee/evi_kikas/HR131010/kontode_liigitamine_ja_sisu.html
// ----
Olenemata sellest, kas on tegu bilansi- või kasumiaruande kontodega,
käituvad kontod ainult kahte moodi: ühed suurenevad deebetis ja vähenevad kreeditis (aktivakontod) ja
teised vastupidid deebetis vähenevad ja kreeditis suurenevad (passivakontod).

Õiglaseks ja õigeks raamatupidamisaruandluse koostamiseks on kasutusel veel korrigeerimiskontod - kontrakontod.
}

// KLIENDI SPETSIAALSED LIPUD
const
  CClient_defaultClientFlag = 1; // 2^0;



// KONTOD; lühikesed tüübi classificators tabelist !
const
  CAccTypeAsActiva = 'A';    // Aktiva
  CAccTypeAsPassiva = 'P';    // Passiva
  CAccTypeAsCost = 'CO';   // Kulud
  CAccTypeAsProfit = 'IN';   // Tulud



// KLIENDI TÜÜBID
const
  CCust_LType = 'L'; // juriidiline isik
  CCust_PType = 'P'; // eraisik


// KANDED
const
  CAccRecIdentAsGenLedger = 'G';  // kanne tehtud otse pearaamatust !  tavaline kanne
  CAccRecIdentAsInitBalance = 'A';  // algsaldode omistamise kanne !!!
  CAccRecIdentAsBill = 'B';  // arvega tekkinud kanne; müügiarve / kreeditarve
  CAccRecIdentAsPuchBill = 'P';  // ostuarvega tekkinud kanne
  CAddRecIdentAsPaymentOrder = 'O';  // tasumine !
  CAddRecIdentAsIncome = 'I';  // sissetulek / laekumine
  CAddRecIdentAsCashReg = 'R';  // kassa ->  !!!!  VIGA ÄRA KASUTA C'd, see on CANCEL tunnus -> 10.04.2011 Ingmar; nüüd
  CAddRecIdendAsClosingRec = 'X';  // sulgemiskanne
  // ---
  // 08.10.2013 Ingmar; probleem; kreeditarve ei luba teise tähega kannet st kui arve 1 oli tunnusega B ja nr 2013-01,
  // siis kreeditarve tegemine ebaõnnestus, kuna tüüp oli ka B kannete trigger tõmbas tagasi transaktsiooni
  CAccRecIdentAsCreditBill = 'K';



// KANDEREA TÜÜP !!!!!!!!!
const
  CAccRecTypeAsCredit = 'C';
  CAccRecTypeAsDebit = 'D';




// konteeringu atribuudi tunnus; enamasti ongi vaid objektid, mis veel tulevikus tuleb, ei tea
const
  CAttrecordObjType = 'O';




// MÄRKUS
// D - siis tegemist on süsteemis annuleeritud kirjega
// C - viitab kirje sulgemisele; sõltub kontekstist

const
  CRecIsOpen = 'O';
  CRecIsClosed = 'C';
  CRecIsCanceled = 'D';




// Konto lipud; tegemist on bitmaskidega !!! flags väli
const
  //CAccFlagsDeleted = 1; // 2~0
  CAccFlagsClosed = 1; // 2~0




// estbk_taxformformulacreator
// valemi koostaja atribuudid valitud kontole
const
  CFCreator_DC_Flag = 1; // DK deebetkäive
  CFCreator_CC_Flag = 2; // KK kreeditkäive
  CFCreator_SA_Flag = 4; // SA - saldo
  CFCreator_TR_Flag = 8; // MT - muutus
// 21.04.2011 Ingmar; Debet/kreeditsaldo oli vaid info pärast, kontol saab olla vaid üks saldo
//CFCreator_DS_Flag = 4; // DS kreeditsaldo
//CFCreator_CS_Flag = 8; // KS deebetsaldo

const
  CFCreator_DC_FlagAsStr = 'DK';
  CFCreator_CC_FlagAsStr = 'KK';
  CFCreator_SA_FlagAsStr = 'SA';
  CFCreator_TR_FlagAsStr = 'MT'; // muutus; 31.05.2011 Ingmar

//CFCreator_DS_FlagAsStr = 'DS';
//CFCreator_CS_FlagAsStr = 'KS';



// KLIENT
// klientide tüüpid; üks tabel erinevad tunnused !
type
  TCCustomerType = (_csTypeAsStandard,
    //_csTypeAsContractor,
    _csTypeAsSupplier);



const
  SCustomerTypeAsIdent: array[TCCustomerType] of AStr = ('', // A
    'R'); //'C',



// ARTIKLI STAATUSED;
const
  _CArticleCanbeUsedInSale = 'Y';


// ARTIKLI TÜÜPIDE LÜHENDID
const
  _CItemAsWProduct = 'WP'; // laokaup
  _CItemAsProduct = 'P';  // kaup
  _CItemAsService = 'S';  // teenus
  _CItemAsUsrDefined = 'U';  // kasutaja poolt loodud

// classificators
const
  _CItemUserDefArticleTypeName = 'articleutype';



// ARTIKLITE TABELI TUNNUSED
const
  _CArtPurchPrice = 'I'; // toode sisseostu hind !
  _CArtSalePrice = 'S'; // toote müügihind




// kuskohast on pärit artikli hinna muutus
const
  _CArtPriceChangeSrcManual = 'M';
  _CArtPriceChangeSrcBill = 'B';  // ostuhind ntx muutus seoses ostuarvega !




// TELLIMUS
type
  TCOrderType = (_coPurchOrder,
    _coSaleOrder);


const
  _COAsPurchOrder = 'P';
  _COAsSaleOrder = 'S';


// andmebaasi def
const
  SCOrderTypes: array[TCOrderType] of AStr = (_COAsPurchOrder,
    _COAsSaleOrder);


// pikk kirjeldus ntx tellimuse printimine
const
  SCOrderLongDescr: array[TCOrderType] of AStr = (estbk_strmsg.SCaptPurchaseOrder,
    estbk_strmsg.SCaptSaleOrder);



const
  // TELLIMUSE  ARVE INFO TUNNUSED order_billing_data->item_type
  // --
  _COBdataAsBill = 'B'; // tellimusega seotud arve
  _COBdataAsOrder = 'O'; // tellimusega seotud arve




// LAEKUMISTE STAATUSED (TELLIMUS) !
const
  COrderPaymentUd = '';  // laekumine puudub
  COrderPaymentOk = 'R'; // kõik ok
  COrderPaymentPt = 'P'; // osaline

// 31.08.2011 Ingmar; nüüd kui tasumistes pannakse küll kanded tabelisse ettemaksu lipuga
// siis vaja täpsustavat lippu, mis ütleb, et summa siiski võtta maha income välja pealt !!! kui seda ei teha on paras jama majas !
const
  CAccRecIncomeAsPrepaymentFlag = 1;


// DOKUMENDID
// DEFINEERITUD tüüpdokumendid

const
  CDocShortType_undefined = 'UD'; // "UD" - Määratlemata dokument
  CDocShortType_purchBill = 'OA'; // "OA" - Ostuarve; vaikimisi
  CDocShortType_saleBill = 'AR'; // "AR" - Arve; müügiarve
  CDocShortType_creaditBill = 'KR'; // "KR" - Kreediarve
  CDocShortType_incomeOrder = 'SO'; // "SO" - Sissetuleku order
  CDocShortType_withdrawalOrder = 'VA'; // "VA" - Väljamineku order

  CDocShortType_income = 'LA'; // "LA" - Laekumine / sissetulek pangast
  CDocShortType_paymentOrder = 'MK'; // "MK" - Maksekorraldus
  CDocShortType_warehouseMvt = 'LL'; // "LL" - Laoliikumine
  CDocShortType_warehouseInc = 'LS'; // "LS" - Lao sissetulek
  CDocShortType_warehouseWrtOff = 'LM'; // "LM" - Lao mahakandmised
  CDocShortType_accInitBalance = 'AL'; // "AL" - Algsaldod
  CDocShortType_miscDocType = 'MM'; // "MM" - "Memoriaalorder":), või lihtsalt mingi "Muu sissetulek" "Muu väljaminek" jne
  CDocShortType_inventory = 'IV'; // "IV" - Inventuur
  CDocShortType_amortization = 'AM'; // "AM" - Amortisatsioon
  CDocShortType_mutualSettlements = 'TA'; // "TA" - Tasaarveldus
  CDocShortType_captialAssets = 'PV'; // "PV" - Põhivara
  CDocShortType_salary = 'PL'; // "PL" - Palk
  CDocShortType_AccClsRec = 'SK'; // "SK" - Sulgemiskanne 20.07.2012


// töötajad -> palk
const
  CDocWorkerIDDocTypes = 'id_doctype';

type
  TObjArray = array of TObject;



type
  TSystemDocType = (_dsDocUndefined,
    _dsInitialBalance,           // algsaldod

    // FINANTS !
    _dsPaymentDocId,             // maksekorraldus
    _dsSaleBillDocId,            // müügiarve
    _dsPurchaseBillDocId,        // ostuarve
    _dsCreditBillDocId,          // kreeditarve
    _dsMemDocId,                 // memoriaalorder

    // --
    _dsReceiptVoucherDocId,
    // kassa sissetuleku order; TODO; nimeta ümber; hetkel nimeks justkui kassa tsekk, see tekitab segadust !
    _dsPaymentVoucherDocId,       // kassa väljamineku order
    // --
    _dsBankIncomes,               // pangalaekumised
    // ---
    _dsWarehouseMovementDocId,    // laoliikumise dokument
    _dsWarehouseIncomeDocId,      // lao sissetuleku dokument
    _dsWarehouseWriteOffDocId,    // lao mahakandmise dokument
    _dsWarehouseStockTakingDocid, // lao inventuuri dokument
    _dsAmortization,              // amortisatsioon
    _dsCaptialAssets,             // põhivara
    _dsSalary,                    // palk
    _dsAccClosingRec              // sulgemiskanne
    );

type
  TSystemDocIdArr = array[TSystemDocType] of integer;

// dokumentide lühendid !
const
  CSystemDocStrArr: array[TSystemDocType] of AStr = (
    CDocShortType_undefined,
    CDocShortType_accInitBalance,
    CDocShortType_paymentOrder,
    CDocShortType_saleBill,
    CDocShortType_purchBill,
    CDocShortType_creaditBill,
    CDocShortType_miscDocType,

    CDocShortType_incomeOrder,
    CDocShortType_withdrawalOrder,
    CDocShortType_income,

    CDocShortType_warehouseMvt,
    CDocShortType_warehouseInc,
    CDocShortType_warehouseWrtOff,
    CDocShortType_inventory,
    CDocShortType_amortization,
    CDocShortType_captialAssets,
    CDocShortType_salary,
    CDocShortType_AccClsRec
    );

type
  TSystemDocStrArr = array[TSystemDocType] of AStr;

// soovitatud tüüpkontod !
// TÜÜPKONTOD
type
  TSystemAccType = (_accSaleVat = 0,            // Müügi käibemaksu konto
    _accBuyersUnpaidBills,  // OLA = ostjate laekumata arved
    _accSupplUnpaidBills,   // TTA = tarnijatele tasumata arved

    _accPrepayment,         // Kliendi ettemaksu konto
    _accSupplPrePayment,    // Hankijale tehtud ettemaksude konto

    _accPurchase,           // Ostukonto
    _accSale,               // Müügikonto
    _accExpense,            // Kulukonto

    _accRoundCost,          // Ümmardamise kulud
    _accRoundRevenue,       // Ümmardamise tulud
    // ---
    _accCurrRateCost,          // Valuuta kulud
    _accCurrRateRevenue,       // Valuuta tulud

    // 12.09.2010 Ingmar
    _accSupplPrepaymentVat,   //  KM hankijate ettemaksetelt
    _accBuyerPrepaymentVat,   //  KM klientide ettemaksetelt

    // --- default
    //_accPaymentOrderDebit,  // Maksekorralduse deebit pool
    //_accPaymentOrderCredit, // Maksekorralduse kreedit pool
    _accBankCharges,          // Pangakulud / ntx maksad arve ja võetakse sealt 6 eeku
    _accCashRegister          // Kassa !

    );

type
  TSystemAccIdArr = array[TSystemAccType] of integer;

type
  TSystemAccAStrArr = array[TSystemAccType] of AStr;


// 14.04.2010 Ingmar; anname kontole süsteemsed nimed !
const
  TSystemAccNames: array[TSystemAccType] of AStr = (estbk_strmsg.SCASaleVatAccName,
    estbk_strmsg.SCABuyersUnpaidAccName,
    estbk_strmsg.SCASupplUnpaidAccName,
    estbk_strmsg.SCACustPrepaymentAccName,
    estbk_strmsg.SCASupplPrePayment,

    estbk_strmsg.SCAPurchaseAccName,
    estbk_strmsg.SCASaleAccName,
    estbk_strmsg.SCAExpenseAccName,

    estbk_strmsg.SCARoundCostAccName,
    estbk_strmsg.SCARoundRevenueAccName,

    estbk_strmsg.SCACurrRateCostAccName,
    estbk_strmsg.SCACurrRateRevenueAccName,

    estbk_strmsg.SCASupplPrepaymentVat,
    estbk_strmsg.SCASupplBuyerVat,

    estbk_strmsg.SCABankChargesAccName,
    estbk_strmsg.SCACashRegisterAccName
    );




// ----------------------------------------------------------------------------
// KÄIBEMAKSUDE bitmaskid !!!
const
  _CVtmode_normal = 0; // 0 = kõik vastavalt tüüpreeglitele
  _CVtmode_turnover_tax = 1; // 2~0; pöördkäibemaks
  _CVtmode_dontAdd = 2; // 2~1; käibemaksu üldse ei lisata, ei teki ka kandesse !!!  Ei arvesta tüüp ntx
  // 17.04.2015 Ingmar; autoga seotud KM 50%
  _CVtmode_carVAT50 = 4;




// ----------------------------------------------------------------------------
// ARVE TÜÜPIDE LÜHENDID
// ----------------------------------------------------------------------------

type
  TBillType = (
    CB_salesInvoice,  // müügiarve
    CB_purcInvoice,   // ostuarve
    CB_creditInvoice, // kreeditarve
    CB_prepaymentInvoice // ettemaksuarve
    );

type
  TBillTypeSet = set of TBillType;


// arve tunnused
const
  _CItemSaleBill = 'S';  // müügiarved
  _CItemPurchBill = 'B';  // ostuarved
  _CItemCreditBill = 'C';  // kreeditarve
  _CItemPrepaymentBill = 'P';  // ettemaksuarve




const
  CBillTypeAsIdent: array[TBillType] of AStr = (_CItemSaleBill,
    _CItemPurchBill,
    _CItemCreditBill,
    _CItemPrepaymentBill
    );


// Kirjutatakse arve päisesse !!!!!!
const
  CLongBillName: array[TBillType] of AStr = (estbk_strmsg.CSSaleBillNameUpper,
    '', // ostuarvel hetkel pealkiri puudub
    estbk_strmsg.CSCreditBillNameUpper,
    estbk_strmsg.CSPrepaymentBillNameUpper
    );


// Näidatakse päringutes; et mis tüüpi arvega tegemist
const
  CLongBillName2: array[TBillType] of AStr = (estbk_strmsg.CSWndNameSaleBill,
    estbk_strmsg.CSWndNamePurchBill,
    estbk_strmsg.CSWndNameCreditBill,
    estbk_strmsg.CSWndNamePrepaymentBill
    );


// TASUMINE; TÜÜBID; vaja eristada nö makseid panga kaudu ja kassat
const
  CPayment_aspmtord = 'P';
  CPayment_ascashreg = 'R';


// ELEMENDI TÜÜBID; PAYMENT_DATA; ACCOUNTING_RECORDS
const
  CCommTypeAsOrder = 'O'; // tuvastatav, kui tellimus
  CCommTypeAsBill = 'B'; // tuvastatav, kui arve
  CCommTypeAsMisc = 'M'; // maksekorraldusega maksti ntx riigilõivu; jne




// ----------------------------------------------------------------------------
// ARVE STAATUSED
const
  CBillStatusOpen = 'O'; // arve avatud - nö tooted broneeritud
  CBillStatusClosed = 'C'; // arve suletud
  CBillStatusDeleted = 'D'; // arve annuleeritud
//CBillStatusPaid     = 'R'; // arve lõplikult laekunud


// MAKSETINGIMUSTE ERANDID
const
  CPaymentTermAsCashPayment = -1;
  CPaymentTermAsCreditCard = -2;


// ARVE LAEKUMISTE STAATUSED
const
  CBillPaymentUd = '';  // laekumine puudub
  CBillPaymentOk = 'R'; // received;  st. arve täielikult laekunud
  CBillPaymentPt = 'P'; // partially; st. arve osaliselt laekunud


// LAEKUMISTE TABELISSE KIRJE PÄRITOLU STAATUS;
const
  CIncSrcFromBank = 'B'; //  laekumine tuli pangafaili kaudu
  CIncSrcManual = 'M'; //  laekumine pandi peale käsitsi

// LAEKUMISE SUUND
const
  CIncDirectionIN = 'I';


// LAEKUMISTE STAATUS
const
  CIncomeRecStatusOpen = '';
  CIncomeRecStatusClosed = 'C';

// TASUMISTE STAATUS
const
  CPaymentRecStatusOpen = CIncomeRecStatusOpen;
  CPaymentRecStatusClosed = CIncomeRecStatusClosed;




// ----------------------------------------------------------------------------
// ARTIKLID; inventuuri staatused

const
  CInvItemReserved = 'B'; // arve avati; valiti artiklid, siis tuleb need ära broneerida !!!
  CInvItemServed = 'S'; // reaalse liikumine toimunud; toode läks poest/laost välja
  CInvItemReturned = 'R'; // lattu tagastati toode



// ----------------------------------------------------------------------------
// ARTIKLID; arvutusmeetod
const
  CArtPriceCalcTypeAvarage = 'A';
  CArtPriceCalcTypeFIFO = 'F';


// ARTIKLITE ERITÜÜPIDE KOODID !!!
const
  CArtSpTypeCode_Prepayment = 'E';
  CArtSpTypeCode_Fine = 'V';



// ARTIKLITE ERITÜÜPIDE BITMASKID
const
  CArtSpTypeCode_PrepaymentFlag = 1; // 2^0
  CArtSpTypeCode_FineFlag = 2; // 2^1



// ---------------------------------------------------------------------------
// TELLIMUS order_billing_data=> item_type väärtused
const
  COrderData_bill_id = 'P'; // tüüp ettemaksuarve
  COrderData_purchbill_id = 'C'; // tellimusest tehtud (lõplik) ostuarve
  COrderData_salebill_id = 'S'; // tellimusest tehtud (lõplik) müügiarve


// ---------------------------------------------------------------------------
// ETTEMAKS prtype =>
const
  CPrpCustomer = 'C'; // klientide ettemaks
  CPrpCompany = 'I'; // meie maksed tarnijatele




// TELLIMUSE STAATUS
const
  COrderVerified = 'C';




// DEKLARATSIOONID
// MA vormide kirjeldused
const
  CFormTypeAsVatDecl = 'V'; // käibemaksudeklaratsioon
  CFormTypeAsTSD = 'D'; // tulumaks / sotsmaksu deklaratsioon http://www.emta.ee/?id=1310
  CFormTypeAsBalance = 'B'; // bilanss
  CFormTypeAsIncStatement = 'I'; // kasumiaruamme
  CFormTypeAsAnnualReport = 'A'; // aastaaruanne
  CFormTypeAsMisc = 'M'; // varia




// spetsiaalne märgend, mis näitab, et tegemist valemi reaga
const
  CFormulaLineSpecialMarker = '$';
  CFormulaLineKeepTogether = '&'; // kui valem algab; &[11%@SA] st ntx detailses bilansis jätta rida kokku

// PALK -> tööleping lipud !
const
  CntrWorkerFullTime = 1; // täiskohaga töötaja
  CntrSocialMinTaxCalc = 2; // sotsmaksu miinimumi arvestus


const
  CSalaryTypeMain = 'P'; // töötasu:põhipalk
  CSalaryTypePHour = 'V'; // töötasu:tunnipõhine
  CSalaryTypeBonus = 'B'; // preemia / http://www.emta.ee/erisoodustus
  CSalaryTypeBTripm = 'C';
  // komandeeringurahad http://www.maksumaksjad.ee/modules/news/article.php?storyid=1402 /  http://www.rmp.ee/foorum/mitmesugust/20417
  CSalaryTypeCarComp = 'R'; // autokompensatsioon http://www.emta.ee/index.php?id=27384
  CSalaryTypeSckComp = 'T'; // haigushüvitis      http://www.haigekassa.ee/kindlustatule/hyvitised/haigus/naited
  CSalaryTypePension = 'L'; // pension; reserveeritud tuleviku jaoks ntx tööandja maksab ise ka pensioni juurde


const
  CEmployee_flasNULLuser = 1; // st kasutame seda palgaarvestuse template info hoidmiseks; samas contraint jääb tööle

const
  CEmployee_NULLusercode = 'TEMPLATE';

// palga valemi muutujad
const
  CMarkWhours = '@TT'; // töötunnid
  CMarkMhours = '@PT'; // puudutud tunnid
  CMarkSickDays = '@HP'; // haiguspäevad



// -- taheti kustutamist, siis märgistan ära elemendid, mida kustutada !
type
  TCBDeleteItem = (cbDeleteBill,
    cbDeleteIncoming,
    cbDeletePayment,
    cbDeleteCashReg,
    cbDeleteOrder // ostu / müügitellimus !
    );

// ---------------------------------------------------------------------------
// FRAMEDE SÜNDMUSED
// ---------------------------------------------------------------------------
// ntx. frame teavitab, sooviti näha kannet 5;

type
  TFrameEventSender = (__frameOpenArticleEntry,      // avab artiklite akna !
    __frameOpenAccEntry,          // avati kanne; aktiivsel vormil avada kanne
    __frameOpenBillEntry,         // avati arve; otsida sobiv vorm, kus arve avada
    __frameBillDataChanged,       // arve muutmine/salvestus
    __frameOpenPaymentEntry,      // avada pangatasumine
    __framePaymentChanged,        // tasumiste muutmine / salvestus; õigem kutsuda tasumine...

    __frameOpenCashRegrEntry,     // avada kassa makse
    __frameCashRegChanged,        // kassast tasumise muutmine / salvestus
    __frameGenLedEntryChanged,    // pearaamatu kanne lisati või muutus
    __frameObjectAddedChanged,    // uus rp. objekt lisati
    __frameAccAddedChanged,           // konto loodi või muudeti
    __frameCustdataChanged,           // klient muutus // loodi
    __frameArticleDataChanged,        // lisati/muudeti artiklit
    __frameBankDataChanged,           // lisati/muudeti panga infot
    __frameWarehouseDataChanged,      // lisati/muudeti ladu

    __frameReqCreateNewPaymentOrder,  // soovitakse teha maksekorraldust; class ->TReqCreateNewPaymentOrder
    __frameReqCreateNewPrepaymentBill,// soovitakse luua uut ettemaksuarvet !
    __frameCreateBillFromOrder,       // soovitakse tellimusest arvet luua
    __frameOpenOrderEntry,            // avab ostu/müügitellimuse
    __frameOpenDeclDetails,           // avab deklaratsiooni vormi definitsioonid

    __frameOpenIncoming,              // avab konkreetse laekumise rea !
    __frameOpenClientIncomings,       // avab kliendi laekumised/tasumised
    __frameOpenBillIncomings,         // avab arve laekumised
    __frameOpenBillPayments,          // avab arve tasumised
    __frameOpenOrderIncomings,        // tellimusega seotud laekumised
    __frameOpenCashRegister,          // avab kassa
    __frameOpenDocumentFiles,         // dokumendiga seotud failide haldus !
    __frameReqCreateNewWorkerEntry,   // uue töötaja lisamine
    __frameOpenWorkerEntry,           // töötaja andmed / personalikaart

    __frameReqCreateNewContractEntry, // loob uue lepingu
    __frameOpenWorkContractEntry,     // töötaja lepingu aken; konkreetne leping !
    __frameWageDefinition,            // palgaarvutamise frame
    // 10.08.2012 ingmar; uued evendid, et saaks ka arvet mujalt välja kutsuda; nimekirjadest väljakutse !
    __frameCreateNewSaleBill,
    __frameCreateNewPurchBill,
    __frameCreateNewPayment, // uus tasumine
    __frameCreateNewAccPayment, // kassa makse
    __frameCreateNewIncoming,
    __frameCreateNewPOrder, // ostu-tellimus
    __frameCreateNewAccRcs  // uus pearaamatu kanne
    );


type
  TFrameReqItemType = (cOrdItemAsBill,
    cOrdItemAsPurchOrder);




// 07.02.2011 Ingmar; ehk siis vastavalt menüüpunktile luuakse vastav aken või tab
type
  TCSModules = (
    __csmTestFrame, // sisemiseks testimiseks
    __csmAccountingWnd,   // finantskannete aken
    __csmAccountsWnd,     // raamatupidamislikud kontod / haldus
    __csmAccountingObjectsWnd,  // raamatupidamislikud objektid
    __csmGeneralLedgEntryListWnd,     // finantskanded nimekiri
    __csmGeneralLedgerRepWnd,   // pearaamatu aruanne
    __csmDailyJournalRepWnd,    // päevaraamatu aruanne
    __csmTurnoverRepWnd,        // käibeandmik
    __csmBalanceRepWnd,         // bilanss
    __csmProfitRepWnd,          // kasumi aruanne
    __csmSaleBillWnd,           // müügiarve aken
    __csmIncomingsManualWnd,    // laekumised käsitsi
    __csmIncomingsFileWnd,      // laekumised pangafailist
    __csmSaleOrderWnd,          // müügitellimus
    __csmOffersWnd,             // pakkumised
    __csmSaleBillListWnd,       // müügiarvete nimekiri
    __csmIncomingsListWnd,      // laekumiste nimekiri
    __csmPurchBillWnd,          // ostuarve aken
    __csmPaymentsWnd,           // tasumised
    __csmPaymentsListWnd,       // tasumiste nimekiri
    __csmPurchaseOrderWnd,      // ostutellimus
    __csmPurchBillListWnd,      // ostuarvete nimekiri
    __csmPurchaseOrderListWnd,  // ostutellimuste nimekiri
    __csmPrepaymentBillWnd,     // # ettemaksuarve aken
    __csmCreditBillWnd,         // # kreeditarve aken
    __csmBillIncomingsInfoWnd,  // laekumiste info aken
    __csmBillPaymentInfoWnd,    // tasumiste info aken; kassa - pangatasumised !
    __csmRPFormCreatorWnd,      // käibemaksudekl. vormid / bilansiga seotud vormid \
    __csmRPFormCreatorLinesWnd, // vormiga seotud read                              / üks ja sama frame erinevad reziimid
    __csmRPFormulaCreatorWnd,   // nö valemirea koostamise frame
    __csmArticlesListWnd,       // artiklite nimekiri
    __csmDefaultAccountsWnd,    // vaikimisi kontode frame
    __csmBanksListWnd,          // pankade nimekiri
    __csmClientsListWnd,        // klientide nimekiri; tegelikkuses klientide jaoks on täiesti oma aken
    __csmWareHouseListwnd,      // ladude nimekiri;
    __csmVATDeclDefWnd,         // käibemaksu defineerimise aken
    __csmDeclDetailedLinesWnd,  // -- deklaratsiooni / bilansi jne detailsed read !
    __csmFormdCalcPrintWnd,     // aruande tulemuste arvutus; olgu tegemist käibedeklaratsiooni; TSD
    __csmAppConfDialog,         // programmi seaded
    __csmAboutWnd,              // programmi info
    __csmDocumentFilesWnd,      // dokumendiga seotud failide info
    __csmSaleBillDebtors,       // müügiarvete võlglased !
    __csmPurchBillDebtors,      // ostarvete võlglased !
    __csmCashRegister,          // kassa
    __csmCashRegPaymentsListWnd, // kassa maksete nimistu
    __csmCashBook,               // kassaraamat
    // PALK
    __csmWorkerListWnd,          // töötajate nimekiri
    __csmWorkerEntryWnd,         // konkreetse töötaja ankeet
    __csmWorkContractEntry,      // töötaja lepingu vorm !
    __csmWageDefinitionWnd       // palga definitsiooni aken
    );


function __dbNameOverride(const pCurrname: AStr): AStr;

implementation

var
  __ovrDbname: AStr = '';

procedure __ovrDBNameFromfile();
const
  CDBOverride = 'databaseovr.txt';
  CREAD_ONLY = 0;
var
  pText: TextFile;
  pFilemode: byte;
begin

  __ovrDbname := '';
  if fileexists(CDBOverride) then
    try
      try
        pFileMode := FileMode;


        FileMode := CREAD_ONLY;
        assignfile(pText, CDBOverride);
        reset(pText);
        readln(pText, __ovrDbname);
        closefile(pText);
        // --
        __ovrDbname := trim(__ovrDbname);

      finally
        FileMode := pFileMode;
      end;
      // --
    except
    end;
end;

function __dbNameOverride(const pCurrname: AStr): AStr;
begin
  if trim(__ovrDbname) = '' then
    Result := CProjectDatabaseNameDef
  else
    Result := __ovrDbname;
end;

initialization
  __ovrDBNameFromfile();

end.