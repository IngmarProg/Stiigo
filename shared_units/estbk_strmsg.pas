unit estbk_strmsg;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils;

resourcestring
  // Laekumiste nimekirja aken
  SCBtnCaptNewPayment = 'Uus tasumine';
  SCBtnCaptNewCsPayment = 'Uus makse';

  // --
  SCRegCode = 'Reg.kood: '; // kassa väljaminek / sissetulek
  SCPrivatePerson = 'ERAISIK'; // vaikimisi klient, mis luuakse kõikidele firmadele !



  SUndefComboChoise = '---';
  SDefaultWareHouse = 'Põhiladu';



  // tulevikus peaksid need aruannete nimed tulema eeldefineeritud XML failis
  //SCFTypeVatDecl = 'Käibemaksudeklaratsioon';
  SCFTypeVatDecl = 'Käibedeklaratsioon';
  SCFTypeTSD = 'TSD'; // soome / rootsi jaoks tuleb täpsemalt uurida
  SCFTypeBalance = 'Bilanss';
  SCFTypeIncStatement = 'Kasumiaruanne';
  SCFTypeAnnualReport = 'Aastaaruanne';




  // ----------------------------------------------------------------------
  // TODO: UI elementidele tõlked peale !!!! hetkel enamustel puudu
  // juhtnuppude ja labelite tekstid
  // ----------------------------------------------------------------------

  // estbk_customdialogsForm
  SConfirm = 'Kinnitan';
  SAnswerYes = '&Jah'; // 1-*
  SAnswerNo = '&Ei';  // 1-*


  // -- common;
  SCommYes = 'Jah';
  SCommNo = 'Ei';
  SCommDoubleClick = 'Topeltklikk';  // tegevuse hint

  SCommDone = 'Tehtud !';
  SCommFailed = 'Ebaõnnestus !';
  SCommSaved = 'Salvestatud';

  // hetkel adminn
  // juhtnupud
  SBtnCaptNewComp = '&Uus firma';
  SBtnCaptNewAccYr = '&Uus maj.aasta';
  SBtnCaptNewVat = '&Uus käibemaks';


  SBtnCaptCancel = '&Katkesta';
  SBtnCaptSave = '&Salvesta';
  SBtnCaptClose = '&Sulge';

  // laekumised; kui faili sisestus
  SBtnCaptContinue = '&Jätkame';



  // -------------------------------------------------------------------------

  // aadressid !
  SRememberdecision = ' Jätan meelde valiku ning rohkem kinnitust ei küsi';

  // estbk_frame_chooseaddr
  SDoWeAddnewAddrEntry = ' Kas lisame uue (maakonna/linna/tänava) andmebaasi ?'#13#10#13#10 +
    ' Seda valikut ei saa muidu sooritada, kuna hetkel puudub kirjeldus ! ';

  SConfSaveChanges = ' Kas salvestame muudatused andmebaasi ? ';
  SConfDoWePerformRenr = ' Kas Te tõesti soovite kõikide kannete numbrid uuesti omistada ? '#13#10 +
    ' HOIATUS: kui Teil rp. dokumentidel kande nr peal, siis need ei pole korrektsed !';


  // -------------------------------------------------------------------------
  // STANDARD POPUP menüü kirjeldused;
  CSPopCopyValue = 'Kopeeri lahtri väärtus';




  // -----
  // ntx faili salvestamisel faili nimi
  CSGenLedgerFile = 'pearaamat_%s';
  CSGenLedgerJournalFile = 'paevaraamat_%s';
  CSTurnoverFile = 'kaibeandmik_%s';
  CSCashBookFile = 'kassaraamat_%s';
  // --
  CSObject = 'Objekt: ';


  // --- võlglaste lehekülg
  CSDebtorFile = 'volglased';



  // ARVED VORM
  CSCmBillnr = 'Arve %s';
  CSSaleBillNr = 'Arve nr: %s';
  CSOrderNr = 'Tellimuse nr: %s';

  CSPurchBillNr = 'Ostuarve nr: %s';
  CSCrBillNr = 'Kreeditarve nr: %s';
  CSCrPrepaymentBillNr = 'Ettemaksuarve nr: %s';



  // ka arveinfo vormil groupbox caption
  CSBtnNameIncomings = 'Laekumised';  // samu captioneid kasutan ka arveinfo(aken) juures, kus kuvatakse tasumisi ja laekumisi
  CSBtnNamePayments = 'Tasumised';



  // --------------
  // ARVETE ARUANNE
  CSSaleBillNameUpper = 'ARVE';         // kuvatakse arvevormidel
  CSCreditBillNameUpper = 'KREEDITARVE';  // kuvatakse arvevormidel
  CSPrepaymentBillNameUpper = 'ETTEMAKSUARVE';


  // --- akende nimed, kui nime ei saa kätte groupbox kaudu
  CSWndNameSaleBill = 'Müügiarve';         // kuvatakse arvevormidel
  CSWndNameCreditBill = 'Kreeditarve';  // kuvatakse arvevormidel
  CSWndNamePurchBill = 'Ostuarve';
  CSWndNamePrepaymentBill = 'Ettemaksuarve';
  CSWndNameClient = 'Kliendid';




  // tasumine / maksekorraldus
  CSPaymentOrder = 'Maksekorralduse nr: %s';


  // 10.02.2011 Ingmar; pole pointi arve kohta uuesti dubleerida
  // grpbox captionid !
  CSBillName_Sale = '';
  CSBillName_Purch = '';
  CSBillName_Prepayment = '';
  CSCreditBillName2 = '';

  CSBillName_Credit = 'Kreeditarve arvele: %s (%s)'; // arve nr ja kuupäev !



  // ka orders lehe peal kasutusel !
  CSBillCp_Client = 'Klient';
  CSBillCp_Supplier = 'Hankija';


  //CSBillCp_Customer_id = CSBillCp_Customer+' id';
  //CSBillCp_supplier_id = CSBillCp_supplier+' id';

  CSBillCp_Client_id = 'Kliendi id';
  CSBillCp_Supplier_id = 'Hankija id';




  // --- KANDED TÜÜBID; kannete päring
  {
  CSAccMainLedgerEntry   = 'Pearaamat';
  CSAccSaleBillEntry     = 'Müügiarve';
  CSAccPurchBillEntry    = 'Ostuarve';
  CSAccPaymentOrderEntry = 'Tasumine';
  CSAccIncomeOrderEntry  = 'Laekumise kanne';
  CSAccInitBalanceEntry  = 'Algsaldode kanne';
  CSAccCashRegEntry      = 'Kassa kanne';
  }


  // -------------------------------------------------------------------------
  // klient
  CSCustPrivPer = 'füüsiline';
  CSCustJurPer = 'juriidiline';


  // artikkel
  CSArtAsGoods = 'Kaubad';
  CSArtAsStockGoods = 'Laokaubad';
  CSArtAsServices = 'Teenused';




  CSObjectCol = 'Objekt [%d]';
  // majandusaasta kirje staatused
  CSStatusOpen = 'Avatud';
  CSStatusClosed = 'Suletud';
  CSStatusDeleted = 'Kustutatud';

  CSAccRepDocNrWithAccDesc = 'kande nr: %s';

  // --
  CSDtToday = 'Täna';
  CSCurrWeek = 'Jooksev nädal';
  CSCurrMonth = 'Jooksev kuu';
  CSPrevWeek = 'Eelmine nädal';
  CSPrevMonth = 'Eelmine kuu';
  CSOvrPrevMonth = 'Üle-eelmine kuu';
  CSCurrentYear = 'Jooksev aasta';
  CSPrevYear = 'Eelmine aasta';
  CSOvrPrevYear = 'Üle-eelmine aasta';

  // käibemaks
  CSDefaultVat = ' Käibemaks %d%%';


  // -------------------------------------------------------------------------
  // ÜLDISED TEKSTID / VARIA
  // -------------------------------------------------------------------------

  // 03.09.2010 Ingmar
  SConfProceed = 'Kas jätkame ?';
  SCLoadingData = 'Palun oodake...laen andmeid';
  SCNotes = 'Märkus';

  SCPleaseWait = 'Palun oodake...';
  SCWorkDone = 'Töö lõpetatud...';



  // -- loob N grupi olgu objekti grupp / konto grupp
  SConfCreateNewGroup = ' Kas loome andmebaasi uue grupi "%s" ? ';
  SConfCreatDefaultAccountPlan = ' Kas koostame firmale ka automaatselt kontoplaani ?';
  SConfGenLedRecCancellation = 'Kas te tõesti soovite annuleerida kande nr "%s" !?';


  // 18.07.2011 Ingmar
  SCUpgradeCompleted = ' Stiigo struktuuride uuendamine lõpetatud. '#13#10#13#10 +
    ' Võite sulgeda administaatori liidese ja käivitada "Stiigo"';


  SConfCreateNewObjGroup = ' Sellist objektigruppi "%s" veel ei eksisteeri ! ' + #13#10 +
    ' Kas loome andmebaasi uue objektigrupi  ? ';

  SConfBfScrollSaveChg = ' Jätkamiseks palun salvestage või tühistage muudatused !';
  SConfOK = ' Tehtud !';

  SCFileInserted = ' Fail sisestatud ';
  SCPhone = ' telefon ';
  SCPleaseSelectItem = ' Palun valige rida ! ';

  SCConfChooseCompany = ' Palun valige firma:';


  // estbk_bankincselector
  SCRecCount = ' Kirjeid kokku: ';
  SCRecInvCount = ' Neist ebakorrektsed: ';


  // -- tüübi kirjeldus
  SCPLangBillName = 'Arve';
  SCPLangOrderName = 'Tellimus';



  // kinnitatud ja kinnitamata staatused erinevatest programmi kontekstides
  SCStatusConfirmed = 'kinnitatud';
  SCStatusUnConfirmed = 'kinnitamata';

  SCSourceManual = 'käsitsi';
  SCSourceFile = 'failist'; // ntx maksekorraldus / laekumine võib tulla ka faili kaudu

  // checklistide abi
  SCLstSelectAllItems = 'Märgista kõik valikud';
  SCLstUnSelectAllItems = 'Tühjenda kõik valikud';




  // ARTIKLID
  SConfArtSalePriceMixup = ' Artikli müügihind väiksem, kui ostuhind ! '#13#10 + 'Kas soovite jätkata ?';
  SConfNewArticleUnit = ' Te sisestasite uue artikli ühiku "%s".'#13#10#13#10 +
    ' Kas salvestame selle ühiku tüübi andmebaasi, et järgmine kord oleks ta valikus ?';

  SCNewArticleType = ' Uus artikli tüüp';
  SCNewArticleTypeName = ' Artikli tüübi nimetus';
  SCConfArticleDelete = ' Kas kustutame artikli "%s" ?';


  // lookupcombo capt.
  SArtCode = 'Kood';
  SArtName = 'Nimetus';



  // artikli tüüp ettemaks
  SArtSpLName_Prepayment = 'Ettemaks';
  SArtSpLName_Fine = 'Viivis';




  // KÄIBEMAKS
  SVATPerc = '%';
  SVATName = 'Käibemaksu nimetus';
  SCaptNoVat = ' Ei arvesta ';


  // KANDED
  SCConfGenLedLineDelConf = ' Kas kustutame antud kanderead ?';
  SCGenLedClosingRecDescr = ' Sulgemiskanne ';

  // #
  SGenLedNewObjectColumnHint = 'Lisame veel ühe objekti';
  SGenLedBackToObjGrpList = 'Objektide grupid avanevad uuesti [F5] vajutamisel';
  SGenLedChooseObjGrp = 'Valige grupp, mille objekte kuvame';
  SGenLedInitBalance = 'Algsaldo';
  SGenLedDefaultFilename = 'pearaamat_%s.csv'; // kui salvestatakse pearaamatus kanded


  // KONTOD
  SAccLongName = ' Kontod ';
  SAccCurrency = ' Valuuta ';
  SAccName = ' Konto nimi ';
  SAccCode = ' Konto kood ';
  SAccObjName = ' Objektid ';
  SAccObjGrpName = ' Objektide grupp ';

  SAccRecordCancelled = ' Kanne on annuleeritud !';
  SAccCurDownloadNeeded = ' Valuuta "%s" kurssi ei leitud seisuga "%s" ! '#13#10 +
    ' Kas üritame alla laadida valuutainfo ?';

  SConfAccDeleteAccount = ' Kas kustutame konto "%s" ?';

  SUpdatingCurrValues = ' Uuendan valuutakursse ...';
  SCaptGenLedgerReport = ' Aruanne: "Pearaamat"';
  SCaptJournalReport = ' Aruanne: "Päevaraamat"';
  SCaptDTurnoverReport = ' Aruanne: "Käibeandmik"';




  // KLIENT
  SCaptOrdClientSrc = ' Kliendi otsing ';
  SCaptOrdClientdata = ' Kliendi andmed';

  SCaptOrdSupplSrc = ' Hankija otsing ';
  SCaptOrdSuppldata = ' Hankija andmed';


  // ARVED
  SCBillLineDelConf = ' Kas kustutame antud arverea !';

  SConfBillGenCreditBill = ' Kas soovite arvele "%s" genereerida kreeditarve ? ';
  SConfBillChangeReq = ' Kas soovite arve taasavada muutmiseks ?';
  SPurchDebt = 'Võlg tarnijale';

  // --- arve maksmise staatus
  SCBillPaid = 'tasutud';
  SCBillPartPaid = 'osaliselt tasutud';
  SCBillUnPaid = 'tasumata';

  SCBillIssuedBy = 'Arve väljastas: %s';
  SCBillAcceptedBy = 'Võttis vastu : %s';
  SCBillOfmtFilename = 'arve_%s';




  // TASUMINE / KASSA
  SConfReopenPayment = ' Kas soovite taasavada tasumise ? ';
  SConfOrderReOpenAndPrpPaymentChk = ' Tasumise uuesti avamisel, toimub tekkinud ettemaksude lahtisidumine järgnevatel arvetel: '#13#10;




  // KASSA ---
  SCashrIncOrder = 'Sissetuleku order';
  SCashrOutpOrder = 'Väljamineku order';
  // -- nimekirjas
  SCashrIncOrder2 = 'Sissetulek';
  SCashrOutpOrder2 = 'Väljaminek';


  // TASUMISTE nimekirja captionid !
  SCaptAsPayment = 'Tasumiste nimekiri';
  SCaptAsCashRegPayment = 'Kassa maksed';


  // TASUMISTE INFO
  SSpmtSourceAsBank = 'Pank';
  SSpmtSourceAsCashReg = 'Kassa';


  // LADU
  SCaptCalcMethodAvarage = 'Keskmine omahind';
  SCaptCalcMethodFIFO = 'FIFO';


  // TELLIMUSED
  SCaptPurchaseOrder = ' Ostutellimus ';
  SCaptSaleOrder = ' Müügitellimus ';


  // combos tegevused...
  // SCmbActionSendOrderPerEmail = 'Saada tellimus e-kirjaga '; reserveeritud
  // SCmbActionOrderVerified     = 'Kinnita tellimus';
  SCmbActionDoPrepayment = 'Teeme ettemaksu';
  SCmbActionAddPrepaymentBill = 'Sisestame tellimuse ettemaksuarve';
  SCmbActionCreateBillFromOrd = 'Teeme tellimusest arve ';

  SConfReOpenVerifOrder = ' Kas taasavame tellimuse ?';
  SConfDeleteOrderLine = ' Kas kustutame tellimuse rea ?';

  // -- tellimuse sündmused
  SOrderPmtOrdData = ' Maksekorraldus (%s)';

  SCOrderCaptSuppl = 'Hankija'; // ostutellimusel
  SCOrderCaptBuyer = 'Ostja';   // müügitellimusel

  SCOrderCaptSum = 'Summa';
  SCOrderCaptRndSum = 'Ümardus';
  SCOrderCaptSumTotal = 'Kokku';




  // VAIKIMISI KONTOD
  SCASaleVatAccName = 'Müügi käibemaksu konto';
  SCABuyersUnpaidAccName = 'Ostjate laekumata arved ';
  SCASupplUnpaidAccName = 'Hankijatele tasumata arved ';
  SCACustPrepaymentAccName = 'Kliendi ettemaksu konto';
  SCASupplPrePayment = 'Hankija ettemaksu konto';
  SCAPurchaseAccName = 'Ostukonto';
  SCASaleAccName = 'Müügikonto';
  SCAExpenseAccName = 'Kulukonto';

  SCARoundCostAccName = 'Ümmardamise kulud';
  SCARoundRevenueAccName = 'Ümmardamise tulud';

  SCACurrRateCostAccName = 'Valuuta kulud';
  SCACurrRateRevenueAccName = 'Valuuta tulud';

  SCASupplPrepaymentVat = 'KM hankijate ettemaksetelt';
  SCASupplBuyerVat = 'KM ostjate ettemaksetelt';

  SCABankChargesAccName = 'Pangakulu';
  SCACashRegisterAccName = 'Kassa';

  SCInfoDefaultAccountsNotDefined = ' Palun defineerige esmalt vaikimisi kontod !'#13#10#13#10 +
    ' Menüü "Lisad" -> "Vaikimisi kontod" ';



  // -------------------------------------------------------------------------
  // aruannete labelite tekstid
  // -------------------------------------------------------------------------

  SCRepAccnrCapt = 'Kande nr';
  SCRepAccExplCapt = 'Selgitus';
  SCRepAccDocnrCapt = 'Dok nr';
  SCRepAccDate0Capt = 'Kande kpv';
  SCRepAccDate1Capt = 'Kuupäev';
  SCRepAccDrecCapt = 'Deebet';
  SCRepAccCrecCapt = 'Kreedit';
  SCRepAccBalanceCapt = 'Saldo';
  SCRepAccCurr0Capt = 'Valuuta';
  SCRepAccCurr1Capt = 'Val.';
  SCRepAccInitbalanceCapt = 'Algsaldo';

  SCRepAccountTotalLblCapt = ' kokku';

  // -------------------------------------------------------------------------
  // ARVED
  // -------------------------------------------------------------------------

  SCBillRepBillRecv = 'Arve saaja';
  SCCaptBillSum = 'Summa';
  SCCaptRndSum = 'Ümardus';
  SCCaptBillSumTotal = 'Arvesumma kokku';
  SCCaptBillSumToPay = 'Tasumisele kuulub';

  // -------------------------------------------------------------------------
  // TASUMINE
  // -------------------------------------------------------------------------

  SCPmtPerformSumSplit = ' Tasumisele kuuluv summa erineb valitud arvete/tellimuste summast ' + #13#10 +
    ' (kogusumma: %.2f; valitud arvete/tellimuste summa: %.2f)! ';



  // -------------------------------------------------------------------------
  // LAEKUMISTE FAILID
  // -------------------------------------------------------------------------
  SCSEPAFile = 'Laekumised panga ISO failist (camt.052 / camt.053)';
  SCIncInforLine = 'Lisarida';
  SCIncFileProcHdr = 'Käivitati "%s" faili sisestamine ';
  SCIncFilePorcFtr = 'Lõpetati  "%s" faili sisestamine ';
  SCIncDummyFilename = 'laekumine'; // kui märgitakse käsitsi laekumised, siis võetakse see nimi
  SConfIncFLinesSave = ' Salvestame failiga saabunud laekumised andmebaasi ?';


  // combo valik
  SCIncCmbAllRecs = 'Kõik kirjed';
  SCIncCmbUnknBnd = 'Kuva kirjed, kus ei õnnestunud laekumist siduda';
  SCIncCmbOnlyOkRecs = 'Kuva ainult korrektsed kirjed';
  SCIncCmbCritErrRecs = 'Kuva kriitiliste vigadega kirjed (pole võimalik sisestada)';

  // laekumiste vaade...
  SCIncLongDesc = ' Selgitus: %s'#13#10' - Fail: %s'#13#10' - Sisestaja: %s';




  // DEKLARATSIOONI VORMID
  SCDeclCommonName = 'Deklaratsioon';
  SCDeclGridCapt = 'Deklaratsioonide vormid';
  SCDeclColname = 'Rea nimetus';
  SCDeclLines = 'Ridade kirjeldus';
  SCDeclNewVatForm = 'Uus käibemaksu vorm:';

  // SEVatDeclForm = 'Käibemaksu deklaratsiooni vorm:';
  SEVatDeclForm = 'Käibedeklaratsioon vorm:';


  // valemi koostamise vormi nimi !
  SCDeclFormuleCrFormname = 'Disainer';
  SCDeclFormSVName = 'vorm_%s';  // kui vorm eksporditakse, siis default filename



  // LAEKUMISTE / TASUMISTE ÜLDINE INFO AKEN; GRID
  SCColPmt_nr_i = 'Nr';
  SCColPmt_date_i = 'Kuupäev';
  SCColPmt_bank_i = 'Pank';
  SCColPmt_account_i = 'Konto';
  SCColPmt_bankaccount_i = 'Pangakonto nr';
  SCColPmt_paidby_i = 'Tasus';
  SCColPmt_payer_accnr_i = 'Tasuja pangakonto nr';
  SCColPmt_sum_i = 'Summa';
  SCColPmt_currency_i = 'Valuuta';



  // tulevikus võib muutuda, tõlked tuleb hoida eraldi
  SCColPmt_nr_p = 'Nr';
  SCColPmt_date_p = 'Kuupäev';
  SCColPmt_bank_p = 'Pank';
  SCColPmt_account_p = 'Konto';
  SCColPmt_bankaccount_p = 'Pangakonto nr';
  SCColPmt_paidby_p = 'Saaja';
  SCColPmt_payer_accnr_p = 'Saaja a/a'; // saaja A/A
  SCColPmt_sum_p = 'Summa';
  SCColPmt_currency_p = 'Valuuta';




  // VÕLGLASTE NIMEKIRJAD
  SCDebtBillDate = 'Arve kuupäev';
  SCDebtDueDate = 'Maksetähtaeg';
  SCDebtSize = 'Võlasumma';
  SCDebtClientName = 'Hankija / Kliendi nimi';


  // grp info
  SCDebtBillTypeSale = 'Tasumata müügiarved';
  SCDebtBillTypePurch = 'Tasumata ostuarved';

  // ARVE FAILID
  SCDocDeleteFile = 'Kas kustutame faili ?';



  // PALK
  // SUGU
  SCGenderMID = 'M';
  SCGenderFID = 'N';

  SCFWageLineType = 'Palgarea tüüp';     // töötaja vaikimisi palk
  SCFWageTaxLine = 'Tasu / maksu liik'; // töötaja palga definitsioon

  // TÖÖAJA TABEL
  SCWrkTableWorkerName = ' Töötaja nimi ';
  SCWrkTableWorkerIDCode = ' Isikukood ';


  // -------------------------------------------------------------------------
  // NUMERAATORITE KIRJELDUS
  // -------------------------------------------------------------------------

  SNumMainGLSeries = 'Pearaamatu kandeseeria';
  SNumIncGLSeries = 'Laekumise kandeseeria';
  SNumSaleBillGLSeries = 'Müügiarve kandeseeria';
  SNumPurchBillGLSeries = 'Ostuarve kandeseeria';
  SNumCreditBillGLSeries = 'Kreeditarve kandeseeria';
  SNumPrpBillGLSeries = 'Ettemaksuarve kandeseeria';
  SNumDueBillGLSeries = 'Viivisarve kandeseeria';
  SNumPaymentGLSeries = 'Tasumise kandeseeria';
  SNumCashRegInGLSeries = 'Kassa sissetulekuorderi kandeseeria';
  SNumCashRegOutGLSeries = 'Kassa väljaminekuorderi kandeseeria';
  SNumSaleBillNr = 'Müügiarve nr';
  SNumCreditBillNr = 'Kreeditarve nr';
  SNumDueBillNr = 'Viivisarve nr';
  SNumPurchOrdNr = 'Ostutellimuse nr';
  SNumSalePurchOrdNr = 'Müügitellimuse nr';
  SNumOfferNr = 'Pakkumise nr';
  SNumPaymentOrderDocNr = 'Maksekorralduse dokumendi nr';
  SNumCachRegGLSeries = 'Kassa  dokumendi nr';

  SConfNumChanges = ' Kas olete kindel muudatuste korrektsuses ja salvestame ?';
  SECantGenNewNVal = ' Numbri genereerimine ebaõnnestus !'#13#10'Põhjus: suletud / defineerimata rp. periood';
  SENumMaskError = ' Numeraatori formaadi viga (mask) ';
  SECantFindNumFmt = ' Numeraatori formaadi määramise viga ! '#13#10#13#10'Raamatupidamisperiood avamata (%s)?';


  // -------------------------------------------------------------------------
  // Annetuste vorm
  SEDonCompanyNameIsMissing = 'Firma nimi puudub !';
  SEDonCompanyEmailIsMissing = 'E-post puudub !';
  SEDonCompanyCstPersonIsMissing = 'Kontaktisiku nimi puudub !';
  SEDonSum = 'Annetuse summa puudulik !';

  // --
  SCDonFinalMsg = 'Tänan Teid !'#13#10'Toetamise avaldus on edastatud !';



  // -------------------------------------------------------------------------
  // Elementide kustutamine
  SConfDeleteItemX = 'Kas kustutame %s nr %s ?';
  SCItemAsBill = 'arve';
  SCItemAsIncoming = 'laekumise';
  SCItemAsPayment = 'tasumise';
  SCItemAsCashReg = 'kassa tehingu'; // --
  SCItemAsOrder = 'tellimuse'; // --

  SECantDeleteConfItems = ' Kinnitatud rida ei saa kustutada !';
  // -------------------------------------------------------------------------
  // ÜLDISEMAD VEATEATED
  // -------------------------------------------------------------------------
  SEClientNotFound = ' Klient valimata / registreerimata !';
  SEOpNotSupported = ' Operatsioon pole toetatud !';

  SEInitializationZError = ' Initsialiseerimise viga %s '#13#10#13#10 + 'Klass: %s';
  SEMajorAppError = ' Programmis tekkis viga: '#13#10#13#10 + '%s';
  SESaveFailed = ' Salvestamine ebaõnnestus !'#13#10#13#10'Põhjus: %s';
  SESaveFailed2 = ' Salvestamine katkestati (ebakõla andmetes) !'#13#10#13#10'Põhjus: %s';
  SEQryFailed = ' Päring ebaõnnestus !'#13#10#13#10'Põhjus: %s';

  SECalcFailed = ' Arvutamine ebaõnnestus !'#13#10#13#10'Põhjus: %s'; // ntx käibedekl...


  SERepSourceDataIsInvalid = 'Aruande lähteandmed on puudulikud !';
  SEReportDataFileNotFound = 'Aruandluse definitsiooni faili "%s" ei leitud !';
  SEError = 'Viga: %s';



  SEConfFileIsInvalid = ' Konfiguratsioon fail on puudulik !';

  SEFileNameIsMissing = ' Failinimi puudub !';
  SEInvalidDirectory = ' Puudulik kataloog "%s"';
  SEFileNotFound = ' Faili "%s" ei leitud !';

  SEFileReadFailed = ' Faili "%s" lugemine ebaõnnestus !' + #13#10#13#10 + 'Põhjus: %s';
  SEFileTooBig = ' Faili lubatud suurus ületab "%d" MB !';
  SEFileTooBig2 = ' Fail liiga suur [%s] kb !';




  SEStreamIsMissing = ' Striim defineerimata !';

  SECantGetCurrVal = ' Valuutakursside uuendamine ebaõnnestus ! ' + #13#10 + ' Põhjus: %s';

  SEMissingCurrVal = ' Valuuta "%s" kurssi ei suudetud määrata !';
  SEIncorrectInputVal = ' Puudulik sisend "%s"'; // @@@@ Ntx gridi arvulises lahtrisse kopeeritakse suvaline tekst

  SECalcFailed2 = ' Arvutamine ebaõnnestus ! '#13#10#13#10'Põhjus: %s';
  // -------------------------------------------------------------------------
  // VARIA
  // -------------------------------------------------------------------------
  // ntx reasumma liiga suur arvutamiseks

  SEErr = ' Viga!';
  SEInvalidDate = ' Puudulik kuupäev !';
  SEEmptyDate = ' Kuupäev sisestamata !';
  SEDateNotChoosen = ' Kuupäev valimata !';
  SEDateInFuture = ' Kuupäev on tulevikus !';

  SEBankAccountIsMissing = ' Puudub arveldusarve !';
  SECantDetermineCurrVal = ' Puudub valuutakurss !';

  SEGrpNameTooShort = ' Grupi nimi liiga lühike (min pikkus 3) !';


  SEIncorrectInp = ' Ebakorrektne sisestus !';
  SEDataReadFailed = ' Andmete lugemine ebaõnnestus !' + #13#10 + 'Põhjus: %s';

  // 22.01.2011 Ingmar;
  SENotAllReqFieldsAreFilled = ' Osa andmeid sisestamata / ebakorrektsed !';



  SEStartDateQtEndDate = ' Alguskuupäev suurem, kui lõppkuupäev !';
  SENameIsMissing = ' Nimetus sisestamata !';
  SECustomerNotChoosen = ' Klient valimata/pole registreeritud !';
  SEContractorNotChoosen = ' Hankija valimata/pole registreeritud !!';


  SEMissingCurrConvExcRate = ' Puudub valuuta "%s" kurss !';
  SECurrTableUpdateFailed = ' Valuutakursse ei õnnestunud uuendada ! '#13#10' Põhjus: %s ';



  SEInvalidInput = ' Puudulikud sisendandmed [%d]'; // sisemine veakood


  // --- koopia; arve, kanne, jne aga ridu pole !
  SENothingToCopy = ' Puuduvad read, mida kopeerida !';
  SELogoFileIsTooBig = ' Logo fail on liiga suur !';

  // -------------------------------------------------------------------------
  // KONTOD
  // -------------------------------------------------------------------------

  SEAccountNameTooShort = ' Konto nimi puudub !';
  SEAccountWSnameExists = ' Sama nime/koodiga konto juba eksisteerib ! ';
  SENoEditorMode = ' Te pole redigeerimisreziimis !';
  SEIncorrectFormat = ' Sisestatud andmed on puudulikud ! '#13#10#13#10 + ' "%s" '#13#10 +
    ' Palun korrigeerige sisestust ';

  //SEAccountCodeTooShort = ' Kontokood on liialt lühike (min pikkus 2) !';
  SEAccountBankAlreadyDef = ' Pank antud valuuta ja sama konto numbriga on juba teise rp. konto [%s] juures defineeritud !';
  SEAccountTypeIsMissing = ' Konto tüüp valimata !';
  SEAccountNotChoosen = ' Konto valimata !';
  SEAccountFileIsNotValid = ' Eeldefineeritud kontode fail on puudulik !';
  SEAccountTypeUndef = ' Konto tüüp "%s" süsteemis defineerimata !';

  SEAccountClassificatorUndef = ' Konto klassifikaator "%s" süsteemis defineerimata !';
  SEAccountInitBalanceIDef = ' Konto algsaldo omistamine valesti teostatud ! ' + #13#10 + ' Lubatud: '#13#10 +
    ' aktiva=deebetsaldo, kulud=deebetsaldo; passiva=kreeditsaldo, tulud=kreeditsaldo';

  SEAccountHasSubElements = ' Kontot ei saa kustutada, kuna omab alamkontosid ! ';
  SEAccountHasBeenUsed = ' Kontot on kasutatud juba raamatupidamiskannetes; kontot ei saa kustutada ! ';
  SEAccountPlanAlreadyExists = ' Kontoplaani ei saa importida (kontoplaan juba sisestatud ?) !';

  // -------------------------------------------------------------------------
  // KANDED
  // -------------------------------------------------------------------------

  SEAccEntryDateEmpy = ' Kande kuupäev sisestamata !';
  SEAccDtPeriodClosed = ' Kannet ei saa teha suletud raamatupidamisperioodi !';
  SEAccDtPeriodNotFound = ' Sobivat raamatupidamisperioodi ei leitud !';
  // ntx laekumiste ja maksekorralduste juures, kui soovitakse kinnitatud makse uuesti peale märkida, aga rp. periood kinni
  SEAccDtPeriodClosed2 = ' Raamatupidamisaasta on suletud !';


  SEAccEntryDocEmpy = ' Dokumendi nr. sisestamata !';
  SEAccEntryNrEmpty = ' Kande number puudulik !';
  SEAccEntryUnBalanced = ' Kanne pole tasakaalus !';
  SEAccEntryWSNrExists = ' Kande number %s juba kasutusel ! Kande kuupäev: "%s"';
  SEAccEntryDocNrExists = ' Sama numbriga dokumenti "%s" on juba kasutatud kandes nr "%s" !';

  SEIncorrectAccnumbering = ' Puudulik kande number !';
  SEAccnumbRangeError = ' Kande number pole lubatud vahemikus !';
  SEAccRecordIsInvalid = ' Kande rida [%d] on puudulik !';
  SEAccRecordsMissing = ' Kande read täitmata !';
  SEAccCurrencyIsMissing = ' Kande real puudub valuuta tunnus !';

  SEAccRecodsHaveZVal = ' Kande ridadel puuduvad summad !';
  SEAccReqObjectsMissing = ' Konto "%s" nõuab järgmisi kohustuslikke objekte: '#13#10#13#10 + ' %s';
  SEAccCantUpdateCurrRates = ' Valuutakursse ei õnnestunud uuendada !';



  SEAccSGrpRecAlreadyExists = 'Sulgemiskanne juba eksisteerib antud perioodis (kander nr %s) !'#13#10 +
    'Kas kirjutame olemasoleva üle (No) või loome uue (Yes)  ?';

  // ----
  SENumeratorRangeExceeded = 'Nummerdamise vahemik ületatud. Lubatud vahemik on: %d-%d'#13#10#13#10 +
    'Kontrollige nummerdamise reegleid !';

  SENumeratorError = ' Nummerdamine ebaõnnestus ! Palun teavitage administraatorit !';
  // SULGEMISKANNE
  SENoAccRecsInPerX = 'Antud perioodis puudusid kanded !';

  // -------------------------------------------------------------------------
  // OBJEKTID
  // -------------------------------------------------------------------------

  SEGrpNameIsMissing = ' Objekti grupi nimi puudub või liialt lühike !';
  SEObjNameisMissing = ' Objekti nimi puudub !';

  // -------------------------------------------------------------------------
  // ARUANDED
  // -------------------------------------------------------------------------

  SECantCreateReport = ' Aruande koostamine ebaõnnestus !'#13#10#13#10 + ' Põhjus: %s';



  // PÄRINGUD; väike dubleerimine, tulevikus ühtlustada !
  SESrcParamsIncomplete = ' Päringu tingimused liiga üldised.'#13#10#13#10' Palun täpsustage !';
  SESrcParamsAreMissing = ' Päringu tingumused puuduvad   !';
  SESrcParamsTooShort = ' Päringu tingimus liiga lühike !';


  SEMissingSrcCriterias = ' Puuduvad päringu kriteeriumid !';
  SEIncorrectCriteria = ' Puudulik päringu parameeter !';
  SEQryRetNoData = ' Andmeid ei leitud !';




  // -------------------------------------------------------------------------
  // KLIENDID/HANKIJAD
  // -------------------------------------------------------------------------

  SEClientNameIsMissing = ' Puudub kliendi nimi või liialt lühike ! ';
  SEClientRegCodeIsMissing = ' Puudub kliendi reg./isikukood ! ';
  SEClientWithSameRegCodeExists = ' Sama reg./isikukoodiga klient juba olemas (id: %d)!';
  SEClientWithSameCCodeExists = ' Sama tunnusega klient on juba olema !';
  SEClientPTypeIsMissing = ' Palun valige ka isiku tüüp ! ';

  // -------------------------------------------------------------------------
  // ARTIKLID
  // -------------------------------------------------------------------------

  SEArtCodeExists = ' Artikkel koodiga "%s" on juba olemas !';
  SEArtDiscountIsInvalid = ' Allahindluse protsent saab olla vahemikus 1-99% !';
  SEArtSPPriceNeg = ' Artikli ostu/müügihind ei tohi olla negatiivne ';
  SEArtNotChoosen = ' Esmalt peate artikli valima !';

  SEArtVatNotFound = ' Artikli käibemaksu ei leitud !';
  SEArtNotFound = ' Puuduvad artiklid !';
  SEArtTypeAlreadyExists = ' Artikli tüüp %s on juba olemas !';
  SEArtCantDelete = ' Artiklit ei saa kustutada ! '#13#10 + ' Teda on kasutatud arvel / tellimusel nr: %s ';


  // -------------------------------------------------------------------------
  // ARVED
  // -------------------------------------------------------------------------
  SEVatPercNotFound = ' Käibemaksu %% ei leitud (%f) !';
  SEDCAccountNotFound = ' Kontot ei leitud !';
  SEBillNrIsMissing = ' Puudub arve number !';
  SEBillDateIsMissing = ' Puudub arve kuupäev !';
  SEBillDateInFuture = ' Arve kuupäev tulevikus !';
  SEBillLinesAreMissing = ' Puuduvad arveread !';
  SEBillNotFound = ' Arvet ei leitud !';
  SEArtNotChoosen2 = ' Artikkel valimata / kirjeldamata!';
  SEArtUnitUndefined = ' Artikli ühik defineerimata !';
  SEArtZSum = ' 0 hinnaga artikli rida ei lubata !';
  //  SEArtPriceIsMissing   = ' Artiklil puudub hind !';
  //  SEArtQtyIsZero        = ' Artikli real puudub kogus !';

  SEArtPriceIsMissing = ' Artikli hind puudulik !';
  SEArtQtyIsZero = ' Artikli rea kogus puudulik !';


  //SEArtQtyIsZero        = ' Artikli koguseks <=0 !';
  SEArtAccIsMissing = ' Puudub artikli konto !';
  SEArtVatIsMissing = ' Artikli käibemaks määramata !';
  SEArtVatAccIsMissing = ' Puudub käibemaksu konto !';
  //SEArtVatSumIsMissing  = ' Käibemaksu summa sisestamata !';
  //SEArtIncorrectDueDate = ' ';
  SEArtNotFoundInWareHouse = ' Artiklit ("%s") pole veel laos kirjeldatud ';
  SEBillFatalErrSumMismatch = ' Sisemine viga ! Arvutatud summad ei ühti: %s ¤ %s';
  SEBillCantCreateCrBill = ' Kinnitamata arvele ei saa koostada kreeditarvet !';
  SEBillHasCreditBill = ' Arvet ei saa muuta; arvele tehtud kreeditarve !';
  SEPurchSaleAccUndef = ' Ostu/müügikonto defineerimata !';
  SEBillHasPayment = ' Arvel on peal laekumine / tasumine ! '#13#10 +
    ' Arve muutmiseks peate laekumise / tasumise lahti siduma';

  SECrBillSumGreaterThenSource = ' Kreeditarve kogusumma on suurem, kui lähtearve oma !';
  SEBillWithNrAlreadyExists = ' "%s" numbriga  arve on juba olemas !';
  // 21.07.2011 Ingmar
  SEPrepaymentAccountNotDefined = ' Ettemaksukonto(d) defineeerimata (menüü Lisad -> Vaikimisi kontod) !';
  SEPrepaymentVATAccountNotDefined = ' Kontod KM hankijate / ostjate ettemaksetelt defineerimata (menüü Lisad -> Vaikimisi kontod) !';
  // -------------------------------------------------------------------------
  // Käibemaksud
  // -------------------------------------------------------------------------


  SEVatAccountNotSpecified = ' Käibemaksu konto defineerimata !';


  // -------------------------------------------------------------------------
  // PANGAD
  // -------------------------------------------------------------------------

  SEBankMissingName = ' Puudub panga nimetus !';
  SEBankMissingAccountNr = ' Puudub kontonumber !';
  SEBankMissingBkAccount = ' Puudub pangaga seotud raamatupidamiskonto !';

  // -------------------------------------------------------------------------
  // LADU
  // -------------------------------------------------------------------------

  SEWareHouseNameIsMissing = ' Puudub lao nimetus !';
  SEWareHouseCodeIsMissing = ' Puudub lao kood !';


  SEWareHouseNameExists = ' Sama nimega ladu olemas !';
  SEWareHouseCodeExists = ' Sama koodiga ladu olemas !';

  // -------------------------------------------------------------------------
  // TELLIMUS
  // -------------------------------------------------------------------------

  SEOrderDateNotDefined = ' Puudub tellimuse kuupäev !';
  SEOrderPPersonMissing = ' Puudub tellija nimi !';
  SEOrderHasNoValidLines = ' Tellimusel puuduvad andmeread !';
  SEOrderLinesIsInvalid = ' Puudulik tellimuse rida !';
  SEOrderItemAmountNotDefined = ' Te peate määrama artiklite koguse !';

  SEOrderArticleNotDefined = ' Tellimusel puudub artikkel !';
  SEOrderArticlePrcNotDefined = ' Tellimusel puudub artikli hind !';
  SEOrderArticleUnitNotDefined = ' Tellimusel puudub artikli ühik !';

  SEOrderIsNotVerified = ' Tellimus kinnitamata !';
  SEOrderVatNotDefined = ' Tellimuse käibemaks määramata !';
  SEOrderNotFound = ' Tellimust ei leitud !';

  // -------------------------------------------------------------------------
  // KASSA / TASUMINE
  // -------------------------------------------------------------------------

  //SEPmtOrderNrIsMissing    = ' Puudub maksekorralduse number !';
  // beneficiary
  SEPmtRecipientsNameIsMissing = ' Puudub makse saaja nimi !';
  SEPmtOrderSumIsEqOrLessZ = ' Summa ei tohi olla <=0 !'; // Maksekorralduse

  SEPmtCantChangeCreditBillDetected = ' Tasumist ei saa muuta ! ' + // Maksekorraldust
    ' Arvele: %s - %s on tehtud kreediarve.';

  SEPmtCantChangeIncomeSumLessZ = ' Tasumise muutmine ebaõnnestus ! ' + //  Maksekorraldust
    ' Arve: %s - %s summa muutus negatiivseks. ';

  SEPmtDescrIsMissing = ' Tasumisel puudub selgitus !'; // Maksekorraldusel
  SEPmtTotalSumDiffFromAccSum = ' Tasumise summa erineb kande summast !'; // Maksekorralduse
  SEPmtMiscLineIncomplete = ' Puudulikult täidetud rida !'; // Maksekorralduse
  SEPmtPresumAccSumMismatch = ' Tasumise eelkalkuleeritud summa [%.4f] ei ühti kande summaga [%.4f] (erinevus: %.4f) '; // Maksekorralduse


  //  SEPmtOrderReOpenAndPrpPaymentChk = ' Maksekorralduse uuesti avamiseks, peate järgnevate arvete laekumised lahti siduma : '#13#10;
  //  SEPmtOrderReOpenAndPrpPaymentChk = ' Maksekorralduse uuesti avamiseks, toimub laekumiste/ettemaksude lahtisidumine järgnevatel arvetel: '#13#10;

  SEPmtOrderPmtRollbackErr = ' Tasumise ümberarvutamine ebaõnnestus: %s'; // Maksekorralduse

  // kassa / laekumised / maksekorraldused
  SEPmtOrderBOSumLess0 = ' arve/tellimuse tasutud summa muutus negatiivseks !';
  SEPmtOnlyBaseCurrencyAllowed = 'SEPA maksetes on ainult baasvaluuta lubatud !';
  SEPmtOnlyVerifRecAreAllowed = 'SEPA maksete faili lisatakse vaid kinnitatud maksed';
  SEPmtSepaFileNotChoosed = 'SEPA fail valimata';
  SEPmtNegSumSelected = 'Negatiivse summaga rida ei saa valida';



  CSMissingConst = 'puudub';
  CSPmtCurrentBankBalance = 'Raha pangas';

  // --------------------------------------------------------------------------
  // laekumisfailide import/töötlus;
  // --------------------------------------------------------------------------

  SEIncfCantReadFile = ' Faili "%s" lugemine ebaõnnestus ! '#13#10'Viga: %s';
  SEIncfFileNotChoosen = ' Fail valimata !';
  SEIncfRootElementNotFound = ' Failist ei leitud juurelementi !';
  SEIncfFieldSepUnknown = ' Tundmatu väljade eraldaja !';
  SEIncfUnknownDataField = ' Tundmatu andmeväli "%s" !';
  SEIncfWrongBankIdfCode = ' Puudulik tunnuskood !';
  SEIncfFieldNrNotValid = ' Välja number puudu või pole numbrilises formaadis !';
  SEIncfFieldLenNotValid = ' Välja pikkus puudu või pole numbrilises formaadis !';
  SEIncfDataFieldNotDefined = ' Andmeväljad korrektselt defineerimata !';
  SEIncfBankCodeIsMissing = ' Puudub panga tunnuskood !';
  SEIncfBankNotChoosen = ' Panka pole valitud !';
  SEIncfCurrencyRates = ' Päevakurssi ei leitud %s [%] !';
  SEIncNotFound = ' Laekumisi ei leitud !';
  SEIncItemSumNEqWithTotal = ' Elementide summa %.2f ei võrdu laekumise kogusummaga %.2f !';


  // kui laekumised uuesti arvesti lahti seotakse
  SEIncRollbackErr = ' Laekumise ümberarvutamine ebaõnnestus: %s';
  SEIncPrepaymentUsed = ' Laekumistega tekkinud ettemaks on märgitud arvetele / tellimustele: '#13#10#13#10'%s';

  SEIncBfSaveRecord = ' Palun salvestage esmalt laekumise rea muudatused !';



  // eeldefineeritud vead aruandesse
  SEIncfdataLineIsTooShort = 'Laekumiste faili andmerida liiga lühike';
  SEIncfReqDataIsMissing = 'Kohustuslik andmeväli puudus laekumise failis';
  SEIncfInvDataFormat = 'Laekumiste faili andmeväli sisaldab ebakorrektseid andmeid';
  SEIncfRcvAccountUnknown = 'Puudus info selle kohta, kuhu pangakontole raha laekus'; // olukord võib tekkida kui laekumine tuli failist !
  SEIncfAccPerNotFound = 'Laekumine tuli suletud/avamata raamatupidamisperioodi';
  SEIncfRefNrNotFound = 'Antud viitenumbriga klienti meil ei ole';
  SEIncfCustNotFound = 'Klienti ei suudetud tuvastada';
  SEIncfBillNotFound = 'Laekumiste faili selgitus tuvastati küll arve, kuid sellist ei leita';
  SEIncfOrderNotFound = 'Laekumiste failis tuvastati küll tellimus, kuid sellist ei leita';
  SEIncfUnknown = 'Ei suutnud tuvastada, mille eest tasuti';
  SEIncfBkAccountNotFound = 'Laekumise valuutale ei leitud sobivat raamatupidamise kontot [pank]';
  SEIncfAlreadyExists = 'Sarnase panga arhiveerimistunnusega kirje on juba andmebaasis';
  SEUnknownSEPAIncFormat = 'Tundmatu laekumiste formaat (oodatakse cam.053 formaati)';
  // 17.01.2011 Ingmar
  SEIncfSrcBankAccNotFound = 'Pangalaekumise raamatupidamislik konto valimata ';
  SEIncfSrcAccNrNotFound = 'Puudub panga kontonumber, mille pealt saabus laekumine'; // tegemist siis nö "kande nr"
  SEIncfDateIsEmpty = 'Laekumisel puudub kuupäev'; // tegemist siis nö "kande nr"
  SEIncfSrcAccountNrEmpty = 'Laekumisel puudub kontonumber, mille pealt laekumine tuli'; // kliendi konto nr
  SEIncfCurrencyIsUnkn = 'Laekumisel puudu valuutakurss / valitud elemendil puudu valuutakurss ';
  SEIncfMissingObjects = 'Puudub info, mida laekumisega tasuti';
  SEIncfObjectAccIdUnkn = 'Arvel / tellimusel puudub raamatupidamislik konto';
  SEIncfSumIsZero = 'Laekumiste summa 0 / arvet ei leitud millega laekumine siduda';
  SEIncfZOkLines = 'Puuduvad korrektsed laekumiste kirjed, mida sisestada!';

  SEIncfLinesPartiallyOK = 'Hoiatus: kõik laekumiste kirjed pole korrektsed !' + #13#10 +
    'Ebakorrektseid ridu ei salvestata !' + #13#10#13#10 + 'Kas siiski salvestame ? ';

  SEIncIncomesNotFound = 'Failist ei leitud laekumisi !';
  SEIncMissingChargeAccount = 'Pangakulu konto on defineerimata vaikimisi kontodes !';

  // PALK
  SEWrkIDNrAlreadyExists = 'Sama isikukoodiga töötaja on juba olemas !';
  SEWrkFirstnameIsMissing = 'Töötaja eesnimi sisestamata !';
  SEWrkLastnameIsMissing = 'Töötaja perekonnanimi sisestamata !';
  SEWrkBirthDayIsMissing = 'Töötaja sünniaeg täitmata !';
  SEWrkGenderIsMissing = 'Töötaja sugu valimata !';
  //SEWrkBanknameIsMissing    = 'Töötaja juures pank valimata !';
  SEWrkBankAccIsMissing = 'Töötaja pangakonto sisestamata !';

  SESalaryTemplateIncorrectLine = 'Palgarida puudulikult defineeritud';

  // LEPING
  SEWrkContrNrIsMissing = 'Puudub töölepingu number !';
  SEWrkContrNrExists = 'Antud töölepingu number "%s" on juba kasutusel !';
  SEWrkContrDateIsIncorrect = 'Puudulik töölepingu kuupäev !';
  SEWrkContrSteDateExists = 'Vahemikus "%s" - "%s" kehtis leping "%s" !';
  SEWrkContrDateIsMissing = 'Puudub töölepingu sõlmimise kuupäev !';
  SEWrkContrStartDateInvalid = 'Töölepingu alguse kuupäev sisestamata !';
  SEWrkContrDateCrAsStartDate = 'Lepingu sõlmimise kuupäev > kui töö alguse kuupäev !';

  // ----------------------------------------------------------------------
  // DEKLARATSIOON / TÖÖTAJA PALK
  // ----------------------------------------------------------------------
  // TODO ühtlusta prefiksid
  SEDeclIncorrectLine = ' Valesti kirjeldatud deklaratsiooni rida !';
  SEDeclIncorrectFormula = ' Avaldis on ebakorrektne !';
  SEDeclCrossLinkedLines = ' Valemis ristlingitud read !';
  SEDeclBrokenRef = ' Viide tundmatu koodiga reale !';
  SEDeclCodeAlreadyDef = ' Rea kood on juba kasutusel !';
  SEDeclRefToSelf = ' Valemi rida viitab iseendale !';
  SEDeclUnknownAccAttrib = ' Tundmatu konto atribuut !';
  SEDeclUnknownAccount = ' Tundmatu konto !';
  SEDeclPossibleRecDetected = ' Valemis ilmnes rekursioon !';
  SEDeclWrongImportFormType = ' Imporditav vorm pole toetatud !';


  // uus moodul; estbk_lib_formulaparserext;
  SEFormulaIncorrect2 = 'Puudulik valem !';
  SEFormulaContainsUnkMarker = 'Tundmatu rea tunnus!';
  SEFormulasHasIncLogExpr = 'Loogika lause on valesti defineeritud !';
  SEFormulaEmpty = 'Valemi lahter täitmata !';


  // ######################################################################
  // ---- ADMIN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ######################################################################


  // ----------------------------------------------------------------------
  // üldised tekstid;
  // ----------------------------------------------------------------------

  SPermissionExcludeFromRole = ' Kas tõesti soovite antud rolliga seotud õiguse kasutajalt ära võtta ?';
  SPermissionRemovedFromSingleRole = ' Õigus on seotud ka rolliga "%s" '#13#10#13#10 +
    ' Kas tõesti soovite välistada antud õiguse tema rollist ?';
  ScPostGreIgnoreCurrentLocaleSettings = ' Postgre (Windowsi versioon) andmebaas vajab korrektseks tööks lokaali (%s) ! '#13#10 +
    ' Teie serveri lokaal on (%s)'#13#10#13#10 +
    ' Kas soovite tõesti andmebaasi luua ?';

  SCFirstRun = ' --- Võimalik põhjus: esmane käivitus / struktuuride uuendamine !';
  SCValidatingTables = ' Kontrollin andmestruktuure...';
  SCDoWeCreateTables = ' Kas loome puuduvad andmestruktuurid, et programm saaks normaalselt jätkata ?';
  SCCopyCompanyAttr = ' Kas omistame firmale "%s" firma "%s" seaded ?';

  SCNumeratorConversions = ' Kas muudame firma numeraatorid majandusaasta põhiseks ? '#13#10#13#10 +
    ' NB: antud valikut enam tagasi võtta ei saa !';
  SCNumeratorFlushCache = ' Kas tühjendame numeraatorite puhvrid ?';
  SCSaveAccPeriod = ' Te peate esmalt salvestama / koostama raamatupidamisperioodi !';

  // ----------------------------------------------------------------------
  // veatekstid
  // ----------------------------------------------------------------------
  // VEATASEMED
  SCErr_critical = 'Kriitiline';
  SCErr_warning = 'Hoiatus';
  SCErr_information = 'Info';



  SEMessageFixed = 'Parandatud !'; // kui mingeid bugisid programm parandab...


  SEEMailSubjectIsMissing = 'E-kirja subjekt on puudu !';
  SEEMailAddrIncorrect = 'E-kirja aadress on puudulik !';
  SEEMailSendFailed = 'E-kirja saatmine ebaõnnestus !'#13#10#13#10'Põhjus: %s';


  SEFilesMissing = ' Stiigo käivitamine kataloogis %s ebaõnnestus !'#13#10#13#10 +
    ' Kataloogis puudub fail: "%s".'#13#10#13#10 +
    ' Soovitan Stiigo failid uuesti alla laadida www.stiigo.com';

  SELibPQloadFailed = ' Faili "libpq.dll" laadimine ebaõnnestus ! '#13#10#13#10'Põhjus: %s';

  SEDbStructureTooOld = ' Teie andmebaasi struktuurid vajavad uuendamist.'#13#10#13#10 +
    ' Uuendamiseks käivitatakse "stiigoadmin". '#13#10#13#10 +
    ' Palun logige sinna administraatori parooliga !';


  SESomeTablesAreMissing = ' Tabel "%s" puudu !';
  SETableAutoCreateFailed = ' Andmestruktuuride loomine ebaõnnestus !';
  SEDatabaseNotCreated = ' Andmebaasi "%s" pole veel loodud !';
  SENoRightsToCreateDbObj = ' Teil puuduvad administraatori õigused.'#13#10#13#10;


  SEErrorOnExecScript = ' Viga skripti käivitamisel ! '#13#10'%s';
  SEErrorCmdDenied = ' Keelatud SQL käsk !';

  SECountyNotFound = ' Antud maakonda "%s" ei leitud !';
  SECityNotFound = ' Antud linna "%s" ei leitud  !';
  SEStreetNotFound = ' Antud tänavat "%s" ei leitud !';
  SELocationResolveError = ' Maakonna/linna/asukoha ID''d ei suudetud tuvastada ! Palun teavitage';
  SEDataError = ' Andmete mittevastavus !';
  SEMissingCompanyName = ' Firma nimi puudub või liialt lühike !';
  SEAddrIncomplete = ' Aadress puudulikus formaadis !';

  SELoginFailed = ' Andmebaasi logimine ebaõnnestus !';
  SEUsernameIncorrect = ' Kasutajanimi liialt lühike !';
  SEUsernameTaken = ' Antud kasutajanimi juba kasutusel !';
  SEInvalidPassword = ' Parool puudub või liialt lühike !';
  SEUserNotFound = ' Kasutajat ei leitud !';
  SEConfFileNotFound = ' Konfiguratsiooni faili ("stiigo_preconf.xml") ei leitud  !';
  SEConfFileNotValid = ' Konfiguratsiooni fail puuduliku struktuuriga !';
  SEStructUpgradeFailed = ' Andmebaasi uuendamine ebaõnnestus ! '#13#10 + 'Põhjus: %s';

  SEAccPeriodDeleteRecord = ' Kas tõesti soovite kustutada antud raamatupidamise aasta kirjet !? ';
  SEAccStartPerLtMaxPer = ' Algusperiood peab võrduma eelmise perioodi lõpuga (+ 1 päev) ! ';
  //SEAccPeriodLgThen        = ' Majandusaasta ei saa olla pikem, kui 12 kuud ! ';
  SEAccPeriodLgThen = ' Majandusaasta ei saa olla pikem, kui 18 kuud ! ';


  // käibemaksude sisestus
  SEVATPercIsnotValid = ' Lubatud käibemaksu protsent on vahemikus 0-100 !';
  SEVATNameIsTooShort = ' Käibemaksu kirjeldus on tühi !';

  // paymentmanager
  SERoundErrorSumTooBig = ' Ümmardamise viga ! Tekkinud vahe liiga suur: [%.4f] ';
  SECpyfDefaultAccPlanExists = ' Kopeerimine ebaõnnestus: firmal on juba kontoplaan !';

  SECantRenumber = 'Numeraatorite reastamine pole võimalik, kuna Teil rp. aasta põhised numeraatorid !';
  // --------------------------------------------------------------------------
  SECantGeneratePOFile = 'Tõlkefaili %s genereerimine ebaõnnestus !';
  SEPOFilenameIsMissing = 'Tõlkefaili nimi puudub';

  // E-arve impordi vead !
  SEBill_rootnameIncorrect = 'E-arve juurelement puudulik';
  SEBill_missingArticles = 'Arvel (%s) puuduvad artiklid';
  SEBill_numberIsMissing = 'Puudub arve nr (rida: %d)!';
  SEBill_currencyNotSupported = 'Arve valuuta pole toetatud (%s)';
  SEBill_vatsumIncorrect = 'Käibemaksude summad pole võrdsed (%f  %f) määr (%f)';
  SEBill_articlesumIncorrect = 'Artikli rea summa on vale (%f %f)';
  SEBill_articleTotalsumIncorrect = 'Artikli ridade kogusumma (%f) <> arve kogusummaga (%f)';
  SEBill_articleDescrIsMissing = 'Artikli kirjeldus puudub';
  SEBill_articleUnitIsMissing = 'Artikli ühik puudub';
  SEBill_billDateIsInvalid = 'Arve kuupäev puudulik !';
  SEBill_billDueDateIsInvalid = 'Arve maksetähtaeg puudulik !';
  SEBill_billSumIsNegative = 'Arve summa ei tohi olla negatiivne !';

  // --------------------------------------------------------------------------
  // --
  // Vigade aruanded

  // --------------------------------------------------------------------------
  // stiigoadmin varukoopiad
  SCDoBackup = 'Uus varukoopia';
  SCDoRestore = 'Taasta varukoopiast';
  SCPgDumpLoc = 'pg_dump asukoht:';
  SCPgRestoreLoc = 'pg_restore asukoht:';
  SConfRestorAct = 'Kas käivitame andmebaasi taastamise  ?';
  SCCopied = 'Kopeeritud !';

  // --------------------------------------------------------------------------
  // stiigoupdater
  SCSrcUpdates = 'Otsin uuendusi...';
  SCWaitUpdating = 'Palun oodake...uuendan faile';
  SCUpdatingFile = 'Toimub faili "%s" uuendamine';
  SCFileUpdated = 'Faili "%s" uuendamine lõpetatud';
  SCFileUpdateFailed = 'Faili "%s" uuendamine ebaõnnestus: %s';
  SCNothingToUpdate = 'Teil on kõige uuemad failid kasutusel';
  SCUpdateDone = 'Uuendamine lõpetatud';


  // -- uuendamise vead !
  SEInvalidUpdateData = 'Uuendamise info fail on vales formaadis !';
  SESoftwareIsRunning = 'Stiigo / Stiigo admin töötavad !'#13#10#13#10'Palun sulgege antud programmid.';

// õigused !
const
  SPermnameZ1 = 'Tohib luua/muuta kontosid';
  SPermnameZ2 = 'Tohib muuta numeratsiooni reegleid';
  SPermnameZ3 = 'Tohib luua/muuta objekte';
  SPermnameZ4 = 'Tohib teha kandeid pearaamatus';
  SPermnameZ5 = 'Tohib lisada / muuta artikleid';
  SPermnameZ6 = 'Tohib kinnitada müügiarveid';
  SPermnameZ7 = 'Tohib kinnitada ostuarveid';
  SPermnameZ8 = 'Tohib koostada kreeditarvet';
  SPermnameZ9 = 'Tohib kinnitada laekumisi';



  SPermnameZ10 = 'Tohib kinnitada tasumisi';
  SPermnameZ11 = 'Tohib kinnitada kassa tehinguid';
  SPermnameZ12 = 'Tohib koostada ostutellimust';

implementation

end.