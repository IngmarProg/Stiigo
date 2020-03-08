unit estbk_acc_perfinalize; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZDataset, ZSqlUpdate, ZSequence,estbk_types,estbk_strmsg,math, dialogs,
  estbk_clientdatamodule,estbk_lib_commonaccprop,estbk_sqlclientcollection,estbk_globvars;

function   _generateAccFinalizatingRec(const pPCAccountId : Integer; // kasumi / kahjumi konto
                                       const pAddPer : TDatetime;  // kuhu rp. perioodi lisame
                                       // mis vahemiku saldod
                                       const pDateStarts : TDatetime;
                                       const pDateEnds   : TDatetime;
                                       var pAccNrs : AStr;
                                       var pExistingAccRec : Integer):Boolean;  // ---
implementation

procedure _addNewRec(const pAccRegId : Int64;
                     const pAccSum : Currency;
                     const pAccId : Integer;
                     const pRecNr : Integer;
                     const pRecType : AStr);
var
   pparamChk : Boolean;
begin
  with estbk_clientdatamodule.dmodule.tempQuery2,SQL do
   try
      pparamChk:=ParamCheck;
      ParamCheck:=true;
      close;
      clear;
      add(estbk_sqlclientcollection._CSQLInsertNewAccDCRec);
      paramByname('id').AsLargeInt:=estbk_clientdatamodule.dmodule.qryGenLedgerAccRecId.GetNextValue;
      paramByname('accounting_register_id').AsLargeInt:=pAccRegId;
      paramByname('account_id').AsLargeInt:=pAccId;
      paramByname('descr').AsString:='';
      paramByname('rec_nr').AsInteger:=pRecNr;
      paramByname('rec_sum').AsCurrency:=pAccSum;
      paramByname('rec_type').AsString:=pRecType;
      paramByname('currency').AsString:=estbk_globvars.glob_baseCurrency;
      paramByname('currency_vsum').AsCurrency:=pAccSum;
      paramByname('currency_id').AsInteger:=0;
      paramByname('company_id').AsInteger:=estbk_globvars.glob_company_id;
      paramByname('currency_drate_ovr').AsCurrency:=1.00;
      paramByname('status').AsString:='';
      paramByname('rec_changed').AsDateTime:=now;
      paramByname('rec_changedby').AsInteger:=estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger:=estbk_globvars.glob_worker_id;
      paramByname('client_id').AsInteger:=0;
      execSQL;
   finally
      ParamCheck:=pparamChk;
      close;
      clear;
   end;

end;


function  _generateAccFinalizatingRec(const pPCAccountId : Integer; // kasumi / kahjumi konto
                                      const pAddPer : TDatetime;  // kuhu rp. perioodi lisame
                                      // mis vahemiku saldod
                                      const pDateStarts : TDatetime;
                                      const pDateEnds   : TDatetime;
                                      var pAccNrs : AStr;
                                      var pExistingAccRec : Integer):Boolean;
var
  pparamChk : Boolean;
  precType  : AStr;
  pEntryNr  : AStr;
  paccPer   : Integer;
  pGenLdrId : Int64;
  pAccDocId : Int64;
  b : Boolean;
  pRnd : Integer;
  pRecNr   : Integer;
  pARecCnt : Integer; // mitu tükki summaga
  pDSum    : Double;
  pCSum    : Double;
  pBal     : Double;
  pFinalAcc: Double;
begin
  result:=false;
  pRecNr:=0;
  pAccNrs:='';
  paccPer:=0;
  pDSum:=0.00;
  pCSum:=0.00;
  b:=estbk_clientdatamodule.dmodule.isValidAccountingPeriod(pAddPer,paccPer);
  if not b then
    raise exception.Create(estbk_strmsg.SEAccDtPeriodNotFound + ' ' + DateToStr(pAddPer));

  try
    Assert(not estbk_clientdatamodule.dmodule.primConnection.InTransaction);
    estbk_clientdatamodule.dmodule.primConnection.StartTransaction; // TODO shorter begin tran
    with estbk_clientdatamodule.dmodule.tempQuery,SQL do
    try
      pparamChk:=ParamCheck;
      ParamCheck:=True;
      Close;
      Clear;
      // ---
      // vaatame, kas sellist kannet juba pole;
      // estbk_sqlclientcollection._SQLSelectNonXAccSum
      // kui olemasolev kirje, siis tühistame eelmised kanded !
      if pExistingAccRec <= 0 then
      begin
        add(estbk_sqlclientcollection._SQLSelectXAccItems);
        paramByname('paccperiodstart').AsDate:=pDateStarts;
        paramByname('paccperiodend').AsDate:= pDateEnds;
        paramByname('company_id').AsInteger:= estbk_globvars.glob_company_id;
        // SQL.SaveToFile('c:\log.txt');
        Open;
        First; // ---
        if not Eof then
        while not Eof do
        begin
          if pAccNrs <> '' then
            pAccNrs := pAccNrs + ';';

          pAccNrs := pAccNrs + Fieldbyname('entrynumber').AsString;
          pExistingAccRec := FieldByName('id').AsInteger;
          Next;
        end;

        if pAccNrs<>'' then
        begin
          estbk_clientdatamodule.dmodule.primConnection.Rollback;
          Exit;
        end;
         // SEAccSGrpRecAlreadyExists
      end
      else
      begin
        add(estbk_sqlclientcollection._SQLCancelAccRecSQL);
        paramByname('accounting_register_id').AsInteger:=pExistingAccRec;
        paramByname('rec_changed').AsDateTime:=now;
        paramByname('rec_changedby').AsInteger:=estbk_globvars.glob_worker_id;
        paramByname('rec_addedby').AsInteger:=estbk_globvars.glob_worker_id;
        execSQL;
      end;

      // Koostame pearaamatu kirje !
      pgenLdrId:=estbk_clientdatamodule.dmodule.qryGenLedgerEntrysSeq.GetNextValue;
      Randomize;
      pRnd:=random(high(integer)-1);
      pEntryNr:=dmodule.getUniqNumberFromNumerator(PtrUInt(pRnd),'',pAddPer,false,estbk_types.CAccGen_rec_nr,true,true);
      dmodule.markNumeratorValAsUsed(PtrUInt(pRnd),estbk_types.CAccGen_rec_nr,pEntryNr,pAddPer,true);

      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLInsertNewAccReg);
      paramByname('id').AsLargeInt:=pgenLdrId;
      paramByname('entrynumber').AsString:=pEntryNr;
      paramByname('transdescr').AsString:=estbk_strmsg.SCGenLedClosingRecDescr+' '+datetostr(pDateStarts)+' - '+datetostr(pDateEnds);
      paramByname('transdate').AsDatetime:=pAddPer;
      paramByname('company_id').AsInteger:=estbk_globvars.glob_company_id;
      paramByname('rec_changed').AsDateTime:=now;
      paramByname('rec_changedby').AsInteger:=estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger:=estbk_globvars.glob_worker_id;
      paramByname('type_').AsString:=estbk_types.CAddRecIdendAsClosingRec;
      paramByname('accounting_period_id').AsInteger:=paccPer;
      execSQL;

      // 20.07.2012 Ingmar
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLInsertNewDoc);
      pAccDocId:=estbk_clientdatamodule.dmodule.qryGetdocumentIdSeq.GetNextValue;
      parambyname('id').asLargeInt:=pAccDocId;
      parambyname('document_nr').asString:=trim(pEntryNr);
      parambyname('document_date').asDate:=now; // tänane kuupäev !

      parambyname('document_type_id').asInteger:=_ac.sysDocumentId[_dsAccClosingRec];
      parambyname('sdescr').asString:=estbk_strmsg.SCGenLedClosingRecDescr+' '+datetostr(pDateStarts)+' - '+datetostr(pDateEnds);

      paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;
      parambyname('rec_changed').asDateTime:=now;
      execSQL;

      // 20.07.2012 Ingmar
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLInsertNewAccRegDoc);
      parambyname('accounting_register_id').asInteger:=pgenLdrId;
      // 05.12.2009 Ingmar
      parambyname('document_id').AsLargeInt:=pAccDocId;
      paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      parambyname('rec_changed').asDateTime:=now;
      execSQL;

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectNonXAccSum);
      paramByname('paccperiodstart').AsDateTime:=pDateStarts;
      paramByname('paccperiodend').AsDateTime:=pDateEnds;
      paramByname('company_id').AsInteger:= estbk_globvars.glob_company_id;
      Open;
      //sql.SaveToFile('c:\test.txt');
      while not eof do
      begin
        {
          Deebet müügitulu 10000
          Kreedit kaubakulu 4000
          Kreedit aruandeaasta kasum 6000
        }
        Inc(pRecNr);
        // kulukontol peaks tulema saldo kreeditisse valemiga Deebet-Kreedit
        if Fieldbyname('commidf').AsString = estbk_types.CAccTypeAsCost then // KULUD !
        begin
          precType := 'C';
          pBal := FieldByname('dside').AsFloat - FieldByname('cside').AsFloat;
          pCSum := pCSum + pBal;
          //pCSum:=pCSum+fieldByname('bal').AsCurrency;
        end else if Fieldbyname('commidf').AsString=estbk_types.CAccTypeAsProfit then // TULUD ! Tulukontol peaks tulema saldo deebetisse valemiga Kreedit-Deebet
        begin
          precType := 'D';
          pBal := FieldByname('cside').AsFloat - FieldByname('dside').AsFloat;
          pDSum := pDSum + pBal;
          // pDSum:=pDSum+fieldByname('bal').AsCurrency;
        end;


        if not math.IsZero(pBal,0.000001) then
        begin
          Inc(pARecCnt);
          _addNewRec(pgenLdrId,
                     pBal, // fieldByname('bal').AsCurrency,
                     fieldbyname('acc_id').AsInteger,
                     pRecNr,
                     precType);
        end;

        Next;
      end;

    finally
      ParamCheck:=pparamChk;
      Close;
      Clear;
    end;

    // 08.08.2012 Ingmar
    if pARecCnt < 1 then
      raise exception.Create(estbk_strmsg.SENoAccRecsInPerX);

    // Aruandeaasta kasum
    pFinalAcc := pDSum - pCSum;


    precType:='C';
    Inc(pRecNr);
    _addNewRec( pgenLdrId,
                pFinalAcc, // fieldByname('bal').AsCurrency,
                pPCAccountId,
                pRecNr,
                precType);

    estbk_clientdatamodule.dmodule.primConnection.Commit;
    // estbk_clientdatamodule.dmodule.primConnection.Rollback;
    Result:=true;
  except on
    E : exception do
    begin
      if estbk_clientdatamodule.dmodule.primConnection.InTransaction then
      try estbk_clientdatamodule.dmodule.primConnection.Rollback; except end;
        raise exception.CreateFmt(estbk_strmsg.SESaveFailed,[e.message]);
    end;
  end;
end;

end.

{

aga kuida siis on kulud D poolelt ja tulu K ?
[14.07.2012 22:14:23] Ingmar Tammeväli: nende saldo selle kuupäeva seisuga ?
[14.07.2012 22:14:28] Ingmar Tammeväli: sinna kannetesse
[14.07.2012 22:14:35] Ingmar Tammeväli: või lihtsalt ongi loll kanne, kus polegi ridu :D
[14.07.2012 22:14:42] K: kõik kolme ja viiega algavate kontodega teed nii
[14.07.2012 22:15:04] K: muidu aasta jooksul kogud kulud deebetisse ja tulud kreeditisse
[14.07.2012 22:15:30] Ingmar Tammeväli: saad ehk näite teha, sa ju tead, mul vaja puust ja punaseks
[14.07.2012 22:15:32] Ingmar Tammeväli: siis teen õiget asja
[14.07.2012 22:15:48] K: siis teed vastupidise kande: tulude saldode summad deebetis ja kulude saldode summad kreeditis ja siis nende vahe läheb majandusaasta kasumi/kahjumi kontole
[14.07.2012 22:16:14] Ingmar Tammeväli: aa vastaskanne
[14.07.2012 22:16:20] K: jep
[14.07.2012 22:16:28] Ingmar Tammeväli: ma ei saa konto nr järgi mängida
[14.07.2012 22:16:37] Ingmar Tammeväli: pean ikka seda tüüpi jälgima
[14.07.2012 22:16:40] Ingmar Tammeväli: et kas kulu või tuli
[14.07.2012 22:16:42] Ingmar Tammeväli: tulu
[14.07.2012 22:16:44] Ingmar Tammeväli: see meil olemas
[14.07.2012 22:16:45] Ingmar Tammeväli: kontodel
[14.07.2012 22:17:01] K: see on lihtsas keeles öeldult kokkuvõtte tegemine. Et tulud-kulud=kasum/kahjum. olenevalt siis, kas tulud on ikka suuremad kui kulud
[14.07.2012 22:17:17] K: aaa. no seda enam
[14.07.2012 22:17:29] Ingmar Tammeväli: ja seda spetsiifilist kannet arvestan vaid bilansis ning kasumiaruandes
[14.07.2012 22:17:45] Ingmar Tammeväli: et sisuliselt algsaldo seal algab sellest lõppkandest uuesti;
[14.07.2012 22:17:54] K: jep
[14.07.2012 22:17:57] Ingmar Tammeväli: ala 31.12.2012 tehakse
[14.07.2012 22:18:09] Ingmar Tammeväli: siis algab pidu uuesti kontodel 01.01.2013 pihta
[14.07.2012 22:18:11] K: tegelikult peaks ka pearaamatus peale seda kontod nulli minema
[14.07.2012 22:18:16] K: jep
[14.07.2012 22:18:31] Ingmar Tammeväli: kus seda ei tohi arvestada
[14.07.2012 22:18:33] Ingmar Tammeväli: seda kannet
[14.07.2012 22:18:54] K: ja kasumiaruandest kribasin mina ja see foorumi onu seepärast, et sa pead leidma lahenduse, kuidas kasumiaruanne peale seda kannet tühjaks ei läheks
[14.07.2012 22:19:14] Ingmar Tammeväli: (wait)ehk kasumiaruandes ei tohi seda arvestada
[14.07.2012 22:19:18] K: jep
[14.07.2012 22:19:28] Ingmar Tammeväli: mul tegelikult on kannetel tüübid
[14.07.2012 22:19:36] Ingmar Tammeväli: saan selle järgi filtreerida
[14.07.2012 22:19:39] K: aga aasta algusesse ei tohi jällegi kasumiaruanne neid saldosid võtta. aga see vist ei võta nagunii, kui saldod on nullis
[14.07.2012 22:19:42] K: on nii?
[14.07.2012 22:19:50] Ingmar Tammeväli: võta pearaamat
[14.07.2012 22:19:52] Ingmar Tammeväli: seal ju tüübid
[14.07.2012 22:19:53] Ingmar Tammeväli: kannetel
[14.07.2012 22:20:07] K: väga hea
[14.07.2012 22:20:14] Ingmar Tammeväli: saldod nullis ?
[14.07.2012 22:20:16] K: pane sinna uus liik. Sulgemiskanne
[14.07.2012 22:20:21] Ingmar Tammeväli: aga ei ole ju
[14.07.2012 22:20:26] Ingmar Tammeväli: kui ma ei tohi seda kannet arvestada
[14.07.2012 22:20:26] Ingmar Tammeväli: :D
[14.07.2012 22:20:41] K: ma üritan kuidagi algusest seletada
[14.07.2012 22:20:46] K: sry, kui jobult teen seda
[14.07.2012 22:20:48] K: :)
[14.07.2012 22:20:56] Ingmar Tammeväli: :)poolest sain juba pihta
[14.07.2012 22:20:58] Ingmar Tammeväli: pool veel udune
[14.07.2012 22:21:03] K: vaata. sul tekib aasta jooksul müük ja kaubakulu
[14.07.2012 22:21:17] K: müük jookseb müügikonto kreeditis. Saldoks tekib 10000
[14.07.2012 22:21:32] K: kulu jookseb kaubakulu konto deebetis. Saldoks tekib 4000
[14.07.2012 22:22:32] K: nüüd kui võtad 31.12.2012 bilansi, siis näed seal aruandeaasta kasumi/kahjumi real summat 10000-4000=6000
[14.07.2012 22:22:52] K: ja siis on aktivas näiteks raha pangakontol ka 6000 (müügid-ostud)
[14.07.2012 22:22:56] K: bilanss klapib
[14.07.2012 22:23:02] K: vaatad kasumiaruannet
[14.07.2012 22:23:12] K: seal on müügitulu +10000
[14.07.2012 22:23:22] K: kaubakulu -4000
[14.07.2012 22:23:29] K: aruandeaasta kasum 6000
[14.07.2012 22:24:41] K: Nüüd teed sulgemiskande:
Deebet müügitulu 10000
Kreedit kaubakulu 4000
Kreedit aruandeaasta kasum 6000
[14.07.2012 22:24:53] K: Sellega läksid müügitulu ja kaubakulu saldod nulliks
[14.07.2012 22:24:55] K: onju
[14.07.2012 22:24:57] K: P
[14.07.2012 22:25:19] K: Pearaamatut vaadates näed nende kontodel liikumisi, aga saldod on 31.12.12 seisuga nullid
[14.07.2012 22:26:15] Ingmar Tammeväli: uhuuu,...nagu mat analüüs 2 :D
[14.07.2012 22:26:39] K: küsi, kus järg kadus?
[14.07.2012 22:26:55] Ingmar Tammeväli: häbi küsida, aga ikka mul segane, mis juhul ei tohi ma üldse seda sulgemiskannet arvestada
[14.07.2012 22:27:11] K: hea küsimus
[14.07.2012 22:27:22] K: pearaamatu aruande suhtes on sul pilt ees ja selge?
[14.07.2012 22:27:46] Ingmar Tammeväli: pearaamatus kõik ju tavaliselt ? või sain valesti aru, st sulgemiskanded panevad seal asjad paika
[14.07.2012 22:27:48] Ingmar Tammeväli: read
[14.07.2012 22:27:52] Ingmar Tammeväli: või sain valesti aru
[14.07.2012 22:28:01] K: õigesti said siis
[14.07.2012 22:28:15] Ingmar Tammeväli: nö tavaline kanne ju, mida tahetakse mugavalt teha
[14.07.2012 22:28:31] K: et pearaamatus on niikaua seal liikumised, kuni teed sulgemiskande, siis on liikumine konto vastaspoolel ja saldo on nullis 31.12.2012 seisuga
[14.07.2012 22:28:36] K: said nii aru onju?
[14.07.2012 22:28:46] K: ma igaksjuhuks küsin üle, et saada pihta, kus toppama jääd
[14.07.2012 22:29:08] Ingmar Tammeväli: :)eks tõe saab teada, kui sulle kondi annan :D
[14.07.2012 22:29:10] K: tavaline kanne jah pearaamatu mõistes
[14.07.2012 22:29:28] K: nüüd kui oled selle tavalise "kande" ära teinud
[14.07.2012 22:29:43] K: ja võtad kasumiaruande seisuga 31.12.2012, siis on see tühi
[14.07.2012 22:29:54] K: sest sul on tulu ja kulu kontodel saldod nullis
[14.07.2012 22:30:12] K: et seda ei juhtuks, siis sa seda tüüpi kannet "Sulgemiskanne" ei võta kasumiaruandes arvesse
[14.07.2012 22:30:36] K: Sest sa tahad ikka näha, kust see kasum tekkis, millised olid tulud ja millised täpsemad kulud jne
[14.07.2012 22:30:40] Ingmar Tammeväli: ehee...et seal siis ei arvestaks neid üldse
[14.07.2012 22:30:47] K: jep
[14.07.2012 22:30:47] Ingmar Tammeväli: see nagu siis ainus koht ?
[14.07.2012 22:30:50] Ingmar Tammeväli: aga käibedekl ?
[14.07.2012 22:30:51] K: jep
[14.07.2012 22:31:01] Ingmar Tammeväli: seda ei mõjuta ?
[14.07.2012 22:31:39] K: käibedeklar ei tohiks kah arvestada, sest reaalselt ei teki käivet, kuna müük ei muutu, ainult müügikontot näpitakse veits:D
[14.07.2012 22:31:58] Ingmar Tammeväli: (happy)
[14.07.2012 22:32:05] Ingmar Tammeväli: otsin viina välja....
[14.07.2012 22:32:10] Ingmar Tammeväli: et sokke teha :D
[14.07.2012 22:32:14] K: ok
[14.07.2012 22:32:22] Ingmar Tammeväli: aga ok, kuidas seda kannet tehakse
[14.07.2012 22:32:34] Ingmar Tammeväli: kuidas see võiks välja näha
[14.07.2012 22:32:49] Ingmar Tammeväli: et kas kui majandusaasta kinni pannakse, siis teeb ?=
[14.07.2012 22:33:05] K: ei. nii automaatselt oleks nõme
[14.07.2012 22:33:22] K: mul eevas on näiteks nii, et võin seda kannet korduvalt teha, st ümberarvestusi teha kui vaja
[14.07.2012 22:33:41] Ingmar Tammeväli: kui mitte eevalik teha
[14.07.2012 22:33:46] Ingmar Tammeväli: siis kuidas see genereerida ?
[14.07.2012 22:33:54] Ingmar Tammeväli: mingi menüüpunkt ?
[14.07.2012 22:33:54] Ingmar Tammeväli: kus
[14.07.2012 22:34:02] K: sest vahel on nii, et peale sulgemiskande tegemist selgub, et mingi oluline kulu oli näiteks kajastamata. siis kajastad, aga selleks on vaja ka sulgemiskanne üle arvutada
[14.07.2012 22:34:21] Ingmar Tammeväli: :Dkuhu ma nupu panen laisklooma nupp
[14.07.2012 22:34:24] Ingmar Tammeväli: aka sulgemiskanded
[14.07.2012 22:34:33] Ingmar Tammeväli: või mis talle menüüs nimeks panna
[14.07.2012 22:34:36] K: ma paneksin selle Finantsi alla
[14.07.2012 22:35:28] Ingmar Tammeväli: kas oleks menüüpukt, et genereeri sulgemiskanne ?
[14.07.2012 22:36:07] K: uhh. ma mõtlen, mis kõige mõttekam oleks
[14.07.2012 22:36:15] K: seda tehakse siiski suhteliselt harva
[14.07.2012 22:36:25] Ingmar Tammeväli: (worry)
[14.07.2012 22:36:31] Ingmar Tammeväli: ja kui oleks menüüpunkt
[14.07.2012 22:36:34] Ingmar Tammeväli: siis mis oleks sisend ?
[14.07.2012 22:36:38] K: tegelt oleks see hea
[14.07.2012 22:36:44] Ingmar Tammeväli: peaks ju mingi kuupäeva valima ?
[14.07.2012 22:36:55] K: kuupäevade vahemik peab olema
[14.07.2012 22:36:57] Ingmar Tammeväli: või majandusaasta ikka !!
[14.07.2012 22:37:01] Ingmar Tammeväli: vahemik ?
[14.07.2012 22:37:04] Ingmar Tammeväli: oh issake
[14.07.2012 22:37:06] K: algus ja lõpp
[14.07.2012 22:37:10] Ingmar Tammeväli: seal suudavad ikka jama kokku keerata
[14.07.2012 22:37:34] Ingmar Tammeväli: aga mis siis kui ühes aastas tehakse mitu kannet ?
[14.07.2012 22:37:38] Ingmar Tammeväli: sulgemiskannet ?
[14.07.2012 22:37:41] Ingmar Tammeväli: erinevad vahemikud
[14.07.2012 22:37:44] Ingmar Tammeväli: nagu pudru ja kapsad
[14.07.2012 22:38:05] K: vat ma ei tea, kuidas seda tehniliselt lahendatakse
[14.07.2012 22:38:11] K: ma võin teha sada korda seda kannet
[14.07.2012 22:38:45] K: kui teen samas vahemikus, siis programm küsib, et valitud perioodis on juba kanne tehtud, kas kustutada vana või moodustada uus ja jätta vana alles, või üldse loobuda
[14.07.2012 22:39:02] Ingmar Tammeväli: hmmm
[14.07.2012 22:39:47] Ingmar Tammeväli: kas järsku teeks nii, et vaikimisi valik olemas
[14.07.2012 22:40:00] Ingmar Tammeväli: võtab jooksva maj. aasta algus kuupäeva
[14.07.2012 22:40:05] Ingmar Tammeväli: ja arvutab lõpu
[14.07.2012 22:40:12] Ingmar Tammeväli: paneb need vaikimisi sinna paika
[14.07.2012 22:40:15] Ingmar Tammeväli: mida saad kruttida
[14.07.2012 22:40:26] K: aga ma ise arvutan tihti mitmeid kordi seda kannet ümber. näiteks kui omast arust olen aasta kokku võtnud ja aruande audiitorile esitanud. Tema aga ütleb, et mingi kulu on valesti kajastatud. Siis parandan selle kuluga seonduva ära ja sellega muutub ka kontode seis kohe. Siis pean uuesti selle sulgemiskande tegema ja programm parandab ära.
[14.07.2012 22:40:41] K: jep
[14.07.2012 22:40:44] K: see oleks hea
}
