unit estbk_reportsqlcollection;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils,estbk_dbcompability,estbk_types,estbk_utilities;


   // pearaamatu päring !
   // periood
   // kontod
   // teine osapool

// ----------------------------------------------------------------------------

function _CSQLRepGeneralLegderEntrysSpeedUpTablePart1(const dCompanyId     : Integer;
                                                      var   dTempTableName : AStr;
                                                      const dSelAccounts   : TADynIntArray = nil):AStr;

function _CSQLRepGeneralLegderEntrysSpeedUpTablePart2(const dCompanyId     : Integer;
                                                      var   dTempTableName : AStr;
                                                      const dSelAccounts   : TADynIntArray = nil;
                                                      const dtStart : TDateTime = CZStartDate1980):AStr;

function _CSQLRepGeneralLegderEntrysSpeedUpTablePart3(const dCompanyId     : Integer;
                                                      const dTempTableName : AStr;
                                                      const dtStart : TDateTime = CZStartDate1980):AStr;
(*
function _CSQLRepGeneralLegderZBalance(const dCompanyId   : Integer;
                                       const dTempTableName : AStr;
                                       const dSelAccounts : TADynIntArray = nil;
                                       const dSelObjects  : TADynIntArray = nil; // reserved
                                       const dtStart : TDateTime = CZStartDate1980;
                                       const dtEnd   : TDateTime = CZStartDate1980):AStr;*)
// pearaamat
function _CSQLRepGeneralLegderEntrysSpeedUpTablePart4(const dCompanyId   : Integer;
                                                      var dTempTableName : AStr;
                                                      const dSelAccounts : TADynIntArray = nil;
                                                      const dSelObjects  : TADynIntArray = nil;
                                                      const dtStart : TDateTime = CZStartDate1980;
                                                      const dtEnd   : TDateTime = CZStartDate1980;
                                                      const dSortAsc: Boolean = true):AStr;

function _CSQLRepGeneralLegderEntrysFinalQry(const dCompanyId   : Integer;
                                             const dTempTableName : AStr; // eelmise kahe proc poolt puhverdatud andmed
                                             const dSortAsc: Boolean = true;
                                             const dNoZLines : Boolean = false):AStr;

// ----------------------------------------------------------------------------
// päevaraamatu päring
function _CSQLRepGeneralJournalEntrys(const dCompanyId   : Integer;
                                      const dSelAccounts : TADynIntArray = nil;
                                      const dSelObjects  : TADynIntArray = nil;
                                      const dtStart : TDateTime = CZStartDate1980;
                                      const dtEnd   : TDateTime = CZStartDate1980;
                                      const dSortAsc: Boolean = false;
                                      const onlyGenLedgerAcc : Boolean = true):AStr;

// ----------------------------------------------------------------------------
// käibeandmik
// ----------------------------------------------------------------------------

function _CSQLRepDTurnoverEntrysSpeedUpTablePart1(const dCompanyId     : Integer;
                                                  var   dTempTableName : AStr;
                                                  const dSelAccounts   : TADynIntArray = nil):AStr;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart2(const dCompanyId     : Integer;
                                                  const dTempTableName : AStr;
                                                  const dtStart : TDateTime = CZStartDate1980):AStr;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart3(const dCompanyId     : Integer;
                                                  const dTempTableName : AStr;
                                                  const dtStart : TDateTime = CZStartDate1980):AStr;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart4(const dCompanyId     : Integer;
                                                  const dTempTableName : AStr;
                                                  const dtStart : TDateTime = CZStartDate1980;
                                                  const dtEnd   : TDateTime = CZStartDate1980):AStr;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart5(const dTempTableName : AStr):AStr;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart6(const dTempTableName : AStr):AStr;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart7(const dTempTableName : AStr):AStr;

function _CSQLRepDTurnoverEntrys(const dTempTableName : AStr;
                                 const dSortAsc: Boolean = true):AStr;

// ----------------------------------------------------------------------------
// kassaraamat
// ----------------------------------------------------------------------------

function _CSQLRepCashBookSpeedUpTablePart1(const dCompanyId     : Integer;
                                           var   dTempTableName : AStr;
                                           const dCashBookAccounts : TADynIntArray):AStr; //  dCashRegAccounts = teoorias vaid üks..aga tulevik võib muutusi tuua

// 22.03.2012 Ingmar
function _CSQLRepCashBookSpeedUpTablePart2(const dCompanyId     : Integer;
                                           const dTempTableName : AStr;
                                           const dtStart : TDateTime = CZStartDate1980;
                                           const dtEnd   : TDateTime = CZStartDate1980):AStr;

function _CSQLRepCashBookSpeedUpTablePart3(const dCompanyId     : Integer;
                                           const dTempTableName : AStr;
                                           const dtStart : TDateTime = CZStartDate1980):AStr;

function _CSQLRepCashBookSpeedUpTablePart4(const dCompanyId     : Integer;
                                           const dTempTableName : AStr;
                                           const dDetailedView  : Boolean;
                                           const dDocType  : TSystemDocType; // _dsReceiptVoucherDocId
                                           const dClientId : Integer = 0;
                                           //const dPaymentStatusIndx : Integer = 0; // 0 -  kõik; 1 - kinnitatud 2 - kinnitamata
                                           const dtStart : TDateTime = CZStartDate1980;
                                           const dtEnd   : TDateTime = CZStartDate1980):AStr;


function _CSQLRepCashBookFinalQrt(const dTempTableName : AStr;
                                  const dSortAsc: Boolean = true):AStr;

implementation
uses estbk_globvars,estbk_sqlclientcollection,estbk_lib_mapdatatypes,estbk_lib_commonaccprop,estbk_clientdatamodule;



// ---------------------------------------------------------------------------
// pearaamat
// ---------------------------------------------------------------------------

function _CSQLRepGeneralLegderEntrysSpeedUpTablePart1(const dCompanyId     : Integer;
                                                      var   dTempTableName : AStr;
                                                      const dSelAccounts   : TADynIntArray = nil):AStr;
var
 pStr     : TAStrList;
 pAccList : AStr;
begin
     dTempTableName:='genld';
     result:='';
     pStr:=TAStrList.create;
     pAccList:=estbk_utilities.createSQLInList(dSelAccounts);
with pStr do
  try
     // muidu on nii, et passiva kontodel on Kreeditkäibed-Deebetkäibed
     // aktiva kontodel on Deebetkäibed-kreeditkäibed
     // tulukontode puhul on kreedit-deebet
     // kulukontode puhul siis deebet-kreedit
     add('SELECT ');
     add('c.id AS account_id,');

     add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS init_balance,');  // algsaldo
     add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS lside,');  // nö deebet  sõltub kontotüübist !
     add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS rside,');  // nö kreedit sõltub kontotüübist !

     add('CAST(t.shortidef AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarCharType(2)+') AS account_type,');  // nö kreedit sõltub kontotüübist !

     add('CAST(');
     add('  (CASE ');
     add('    WHEN t.shortidef IN ');
     add('     ('+QuotedStr(estbk_types.CAccTypeAsActiva)+','+QuotedStr(estbk_types.CAccTypeAsCost)+') THEN '+ QuotedStr(estbk_types.CAccRecTypeAsDebit));
     add('    WHEN t.shortidef IN ');
     add('     ('+QuotedStr(estbk_types.CAccTypeAsPassiva)+','+QuotedStr(estbk_types.CAccTypeAsProfit)+') THEN '+ QuotedStr(estbk_types.CAccRecTypeAsCredit));
     add('   END)');
     add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapCharType(1)+') AS lsideidf,');

     add('CAST(');
     add('  (CASE ');
     add('    WHEN t.shortidef IN ');
     add('     ('+QuotedStr(estbk_types.CAccTypeAsActiva)+','+QuotedStr(estbk_types.CAccTypeAsCost)+') THEN '+ QuotedStr(estbk_types.CAccRecTypeAsCredit));
     add('    WHEN t.shortidef IN ');
     add('     ('+QuotedStr(estbk_types.CAccTypeAsPassiva)+','+QuotedStr(estbk_types.CAccTypeAsProfit)+') THEN '+ QuotedStr(estbk_types.CAccRecTypeAsDebit));
     add('   END)');
     add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapCharType(1)+') AS rsideidf');
     // 28.12.2011 Ingmar
     //add('CAST(0 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapIntType()+') as client_id,');
     //add('CAST('''' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarcharType(255)+') as client_name');


     add('FROM accounts c');
     add('INNER JOIN classificators t ON');
     add('t.id=c.type_id');
     add(format('WHERE c.company_id=%d',[dCompanyId]));

  if pAccList<>'' then
     add('  AND c.id in ('+pAccList+')');
     result:=sqlp._create_temptable(dTempTableName,pStr.Text,true);

  finally
   freeAndNil(pStr);
  end;
end;


//15.11.2010 Ingmar; kaheosaline päring !
// pearaamatu päring kestis muidu terve igaviku !; tulevikus ka view'd teha !
function _CSQLRepGeneralLegderEntrysSpeedUpTablePart2(const dCompanyId     : Integer;
                                                      var   dTempTableName : AStr;
                                                      const dSelAccounts   : TADynIntArray = nil;
                                                      const dtStart : TDateTime = CZStartDate1980):AStr;
var
 pStr     : TAStrList;
 pAccList : AStr;
begin
      result:='';
      pStr:=TAStrList.create;
      pAccList:=estbk_utilities.createSQLInList(dSelAccounts);
      // ------
{
26.05.2011
siis kuidas sina paneksid kuupäevade vahemikud
[10:02:15] Ingmar Tammeväli: järelikult siis on hoopis
[10:02:46] Ingmar Tammeväli: algsaldo <=01.01.2011; muutus >01.01.2011 ja lõppsaldo <= 25.05.2011
[10:02:55] Ingmar Tammeväli: hetkel on
[10:03:15] Ingmar Tammeväli: algsaldo <01.01.2011; muutus >=01.01.2011 ja lõppsaldo <= 25.05.2011
[10:03:27] K: vist jah nii nagu esimesena kirjutasid
}
 with pStr do
   try

      add(format('UPDATE %s',[dTempTableName]));
      add('SET lside=');
      add('CAST(');
      add('(');
      add(' SELECT coalesce(SUM(z0.rec_sum),0)');
      add(' FROM  accounting_records z0');
      add(' INNER JOIN accounting_register w0 ON');
      add(' w0.id=z0.accounting_register_id AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));

   // teoorias on alguskuupäev alati olemas !!
   if dtStart<>CZStartDate1980 then
      add(' AND w0.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));
      // add('   AND w0.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart))); 26.05.2011 Ingmar
      // 27.11.2011 Ingmar
      add(' AND w0.template=''f''');

      add(format(' WHERE z0.account_id=%s.account_id',[dTempTableName]));
      add(format('   AND z0.rec_type=%s.lsideidf',[dTempTableName]));  // D
      //add('   AND z0.status NOT LIKE ''%D%'''); 07.04.2011 Ingmar peame kõiki kandeid arvestama, ka tühistatuid !
      add(' )');
      add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+'),'); // tavaliselt deebetsumma !


      add('rside=');
      add('CAST(');
      add('(');
      add(' SELECT coalesce(SUM(z1.rec_sum),0)');
      add(' FROM  accounting_records z1');
      add(' INNER JOIN accounting_register w1 ON');
      add(' w1.id=z1.accounting_register_id AND w1.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));

   if dtStart<>CZStartDate1980 then
      add('   AND w1.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));  // 26.05.2011 Ingmar
      //add('   AND w1.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));

      // 27.11.2011 Ingmar
      add(' AND w1.template=''f''');

      add(format(' WHERE z1.account_id=%s.account_id',[dTempTableName]));
      add(format('   AND z1.rec_type=%s.rsideidf',[dTempTableName]));   // C
      // add('   AND z1.status NOT LIKE ''%D%'''); // 25.08.2011 Ingmar, siin oli tühistatud unustatud !
      add(' )');
      add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+')');

      // ---
      result:=pStr.Text;


   finally
      freeAndNil(pStr);
   end;
end;


function _CSQLRepGeneralLegderEntrysSpeedUpTablePart3(const dCompanyId     : Integer;
                                                      const dTempTableName : AStr;
                                                      const dtStart : TDateTime = CZStartDate1980):AStr;
var
   pStr  : TAStrList;
   p1,p2 : AStr;
begin
 {
26.05.2011
siis kuidas sina paneksid kuupäevade vahemikud
[10:02:15] Ingmar Tammeväli: järelikult siis on hoopis
[10:02:46] Ingmar Tammeväli: algsaldo <=01.01.2011; muutus >01.01.2011 ja lõppsaldo <= 25.05.2011
[10:02:55] Ingmar Tammeväli: hetkel on
[10:03:15] Ingmar Tammeväli: algsaldo <01.01.2011; muutus >=01.01.2011 ja lõppsaldo <= 25.05.2011
[10:03:27] K: vist jah nii nagu esimesena kirjutasid
}
     result:='';
     p1:='';
     p2:='';
     pStr:=TAStrList.create;
     // ------
  with pStr do
  try
      add(format('UPDATE %s',[dTempTableName]));
      add('SET init_balance=COALESCE((');
  if  dtStart<>CZStartDate1980 then
    begin
      //p1:=p1+' AND accounting_register.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart));   // <? või  <= ?
      p1:=p1+' AND accounting_register.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart));   // 26.05.2011 Ingmar
      // 27.11.2011 Ingmar
      p1:=p1+' AND accounting_register.template=''f''';
   end;

      p2:=' AND accounts.id='+dTempTableName+'.account_id'; // accounts
      add(estbk_sqlclientcollection._SQLSelectAccountInitBalance(estbk_globvars.glob_company_id,p1,p2));
      add('),0.00)');
      result:=pStr.Text;
  finally
     freeAndNil(pStr);
  end;
end;


(*
function _CSQLRepGeneralLegderZBalance(const dCompanyId   : Integer;
                                       const dTempTableName : AStr;
                                       const dSelAccounts : TADynIntArray = nil;
                                       const dSelObjects  : TADynIntArray = nil; // reserved
                                       const dtStart : TDateTime = CZStartDate1980;
                                       const dtEnd   : TDateTime = CZStartDate1980):AStr;
var
 pStr     : TAStrList;
 pAccList : AStr;
 pObjList : AStr;
 p1,p2    : AStr;
begin
    result:='';
    pStr:=TAStrList.create;

    pAccList:=estbk_utilities.createSQLInList(dSelAccounts);
    pObjList:=estbk_utilities.createSQLInList(dSelObjects);
    // ------
with pStr do
 try

 if  dtStart<>CZStartDate1980 then
  begin
   //p1:=p1+' AND accounting_register.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart));   // <? või  <= ?
   p1:=p1+' AND accounting_register.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart));   // 26.05.2011 Ingmar
   // 27.11.2011 Ingmar
   p1:=p1+' AND accounting_register.template=''f''';
  end;

   p2:=' AND accounts.id=xt.id'; // accounts
   // ---


   add('INSERT INTO '+ dTempTableName+'(account_id,init_balance,lside,rside,account_type,lsideidf,rsideidf)');
   add('SELECT xt.id,');

   // @@@ ALGSALDO
   add('COALESCE(('+estbk_sqlclientcollection._SQLSelectAccountInitBalance(estbk_globvars.glob_company_id,p1,p2)+'),0.00),');
   add('0 as lside,');
   add('0 as rside,');
   add(''''' as  account_type,');
   add(''''' as  lsideidf,');
   add(''''' as  rsideidf');

   // @@@
   add('FROM accounts xt ');
   add('WHERE xt.id IN ('+pAccList+')');
   add(' AND NOT EXISTS(SELECT g.* FROM '+dTempTableName+' g WHERE g.account_id=xt.id)');
   // add(' AND a.rec_deleted=''f''');

   result:=pStr.text;
 finally
   freeAndNil(pStr);
 end;
end; *)



function _CSQLRepGeneralLegderEntrysSpeedUpTablePart4(const dCompanyId   : Integer;
                                                      var dTempTableName : AStr;
                                                      const dSelAccounts : TADynIntArray = nil;
                                                      const dSelObjects  : TADynIntArray = nil;
                                                      const dtStart : TDateTime = CZStartDate1980;
                                                      const dtEnd   : TDateTime = CZStartDate1980;
                                                      const dSortAsc: Boolean = true):AStr;
var
 pStr     : TAStrList;
 pAccList : AStr;
 pObjList : AStr;
begin
      result:='';
      pStr:=TAStrList.create;

      pAccList:=estbk_utilities.createSQLInList(dSelAccounts);
      pObjList:=estbk_utilities.createSQLInList(dSelObjects);
      // ------
 with pStr do
   try
        add('SELECT q.*');
        add('FROM (');
        // --- kui vahemikus pole tehinguid, siis ei kuvata algsaldo rida !
        // @@
        add('SELECT '''' as object1,');
        add(''''' as entrynumber,');
        add('null as transdate,');
        add(''''' as transdescr,');
        add(''''' as document_type,');
        add(''''' as document_nr,');
        add(''''' as accmrec_type,');
        add('-1   as id,');
        add(''''' as descr,');
        add('0 as rec_nr,');
        // --
        add('x.account_type,');
        add('CAST((x.init_balance+x.lside-x.rside) AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as init_balance,');
        add('0 as rec_sum_d,');
        add('0 as rec_sum_c,');
        // add('CAST((p.init_balance+p.lside-p.rside) AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as curr_balance,'); // saldo enne kuupäeva
        // add('x.init_balance as curr_balance,');
        add('CAST((x.init_balance+x.lside-x.rside) AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as curr_balance,'); // saldo enne kuupäeva
        add(''''' as rec_type,');
        add('0    as client_id,');
        add(''''' as  client_name,');

        // add('a.tr_partner_name,');
        add('a.default_currency as currency,');
        //add('x.init_balance as currval_override,');
        add('CAST((x.init_balance+x.lside-x.rside) AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as currval_override,');

        add(''''' as status,');
        add('x.account_id,');
        add('a.account_coding,');
        add('a.account_name');

        add('FROM '+dTempTableName+' x ');
        add('INNER JOIN accounts a ON');
        add('a.id=x.account_id');
        add('WHERE NOT EXISTS(');
        add(' SELECT w.*');
        add(' FROM accounting_register w ');
        add(' INNER JOIN accounting_records r ON ');
        add(' r.accounting_register_id=w.id AND r.rec_deleted=''f'' AND r.account_id=x.account_id');
        // ---
     if dtStart<>CZStartDate1980 then
        add('   AND w.transdate>='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));

     if dtEnd<>CZStartDate1980 then
        add('   AND w.transdate<='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtEnd)));
        add(')');
        // @@@


        add('UNION ');

        add('SELECT ');
        // 31.08.2011 Ingmar
        add('  COALESCE(');
        add('   (SELECT o.descr');
        add('    FROM accounting_records_attrb tr');
        add('    INNER JOIN objects o ON');
        add('    o.id=tr.attrib_id');
        add('    WHERE tr.accounting_record_id=a.id');
        add('      AND tr.attrib_type=''O''');
        add('      AND tr.id=(SELECT MAX(tr1.id)');
        add('                 FROM  accounting_records_attrb tr1');
        add('                 WHERE tr1.accounting_record_id=a.id');
        add('                   AND tr1.attrib_type=''O''');
        add('     )),'''') as object1,');

        add('b.entrynumber,');
        add('b.transdate,');
        // 21.06.2011 Ingmar
        add('b.transdescr,');

        add('(CASE WHEN t.shortidef=''UD'' THEN '''' ELSE t.shortidef END) as document_type,'); // UD - undefined !
        add('e.document_nr,');
        add('b.type_ as accmrec_type,');
        add('a.id,');
        add('a.descr,');
        add('a.rec_nr,');

        add('p.account_type,');
        add('p.init_balance,');

        // aruandlus kordades lihtsam teha, ei pea eventides häkkima !
        add('(CASE WHEN a.rec_type=''D'' THEN a.rec_sum ELSE null END)  as rec_sum_d,'); // DEEBIT
        add('(CASE WHEN a.rec_type=''C'' THEN a.rec_sum ELSE null END)  as rec_sum_c,');  // KREEDIT


        //add('(CASE WHEN a.rec_type=''C'' THEN -a.rec_sum ELSE null END) as rec_sum_c,'); // baasis summad negatiivsed meie kuvame positiivselt
        // siin peame ka annuleeritud kirjed kokku summeerima !!!
        add('CAST((p.init_balance+p.lside-p.rside) AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as curr_balance,'); // saldo enne kuupäeva


        add('a.rec_type,');
        add('a.client_id,');

        // 28.12.2011 Ingmar; taheti ka klienti; tulevikus päringut optimiseerida !
        add('(');
        add(' CASE WHEN COALESCE(a.tr_partner_name,'''')<>'''' THEN');
        add('  a.tr_partner_name');
        add(' ELSE');
        add(' (SELECT ');
        add('  CAST('+sqlp._doSafeSQLStrConcat([AStr('k.name'),AStr(''' '''),AStr('k.lastname')])+' AS '+TEstbk_MapDataTypes.__MapVarcharType(255)+')');
        add('  FROM client k');
        add('  WHERE k.id=a.client_id');
        add('    AND k.rec_deleted=''f''');
        add('  )');
        add(' END) as  client_name,');

        // add('a.tr_partner_name,');
        add('a.currency,');
        add('a.currency_vsum as currval_override,');
        add('a.status,');
        add('a.account_id,');
        add('c.account_coding,');
        add('c.account_name');



        add('FROM accounting_records a');
        add('INNER JOIN accounting_register b ON');
        add('b.id=a.accounting_register_id AND b.type_ NOT LIKE ''%D%'' AND b.template=''f''');

     //if onlyGenLedgerAcc then
     //   add(' AND b.type_ like  ''%G%''');

        add('INNER JOIN accounts c ON');
        add('c.id=a.account_id');

        add(format('INNER JOIN %s p ON',[dTempTableName]));
        add('p.account_id=a.account_id');

        add('INNER JOIN accounting_register_documents d ON');
        add('d.accounting_register_id=b.id');

        add('INNER JOIN documents e ON');
        add('e.id=d.document_id');

        add('LEFT OUTER JOIN classificators t ON');
        add('t.id=e.document_type_id');



        add(format('WHERE a.company_id=%d',[dCompanyId]));

     // ----
     if pAccList<>'' then
        add('   AND a.account_id IN ('+pAccList+')');
        //add('   AND a.status NOT LIKE ''%D%'''); // pole tegemist pearaamatu annuleeritud kirjetega !
        add('    AND a.id>(SELECT COALESCE(MAX(a1.id),0) FROM accounting_records a1 WHERE a1.accounting_register_id=b.id AND a1.status LIKE ''%D%'')');


     if dtStart<>CZStartDate1980 then
        add('   AND b.transdate>='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));

     if dtEnd<>CZStartDate1980 then
        add('   AND b.transdate<='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtEnd)));

     // 15.10.2011 Ingmar
     if pObjList<>'' then
       begin
        add('   AND EXISTS');
        add('     (');
        add('       SELECT o.* ');
        add('       FROM accounting_records_attrb o');
        add('       WHERE o.accounting_record_id=a.id');
        add('         AND o.attrib_type=''O''');
        add('         AND o.attrib_id IN ('+pObjList+')');
        add('         AND o.rec_deleted=''f'')');
       end;


        // @@@
        add(') as q ');

        // !!! length rikub kompatiibluse ära !
        //add('ORDER BY c.account_coding '+estbk_types.SCAscDesc[dSortAsc]+',length(c.account_coding),b.transdate ASC,entrynumber ASC,a.rec_nr ASC');
        add('ORDER BY q.account_coding '+estbk_types.SCAscDesc[dSortAsc]+',length(q.account_coding),q.transdate ASC,q.entrynumber ASC,q.rec_nr ASC');


        //  add('ORDER BY c.name '+estbk_types.SCAscDesc[dSortAsc]+',b.transdate ASC,entrynumber ASC,a.rec_nr ASC');
        // account_coding,length(account_coding),transdate ASC,entrynumber ASC

        result:=sqlp._create_temptable(dTempTableName,pStr.Text,true);
        //result:=pStr.text;
        // pStr.SaveToFile('c:\test.txt');
   finally
        freeAndNil(pStr);
   end;
end;

function _CSQLRepGeneralLegderEntrysFinalQry(const dCompanyId   : Integer;
                                             const dTempTableName : AStr; // eelmise kahe proc poolt puhverdatud andmed
                                             const dSortAsc: Boolean = true;
                                             const dNoZLines : Boolean = false):AStr;
begin
if dNoZLines then
   result:='SELECT p.* FROM '+dTempTableName+' p '+
           ' WHERE  EXISTS(SELECT p1.* FROM '+dTempTableName+' p1 '+
           ' WHERE p1.account_id=p.account_id AND  '+
           ' ( '+
           '   COALESCE(p1.init_balance,0.00)<>0.00 OR '+
           '   COALESCE(p1.rec_sum_d,0.00)<>0.00 OR '+
           '   COALESCE(p1.rec_sum_c,0.00)<>0.00 '+
           ' ))'


else
 begin
   // kõik
   result:='SELECT p.* FROM '+dTempTableName+' p'
 end; // --
end;

// ---------------------------------------------------------------------------
// päevaraamatu päring
// ---------------------------------------------------------------------------

function _CSQLRepGeneralJournalEntrys(const dCompanyId   : Integer;
                                      const dSelAccounts : TADynIntArray = nil;
                                      const dSelObjects  : TADynIntArray = nil;
                                      const dtStart : TDateTime = CZStartDate1980;
                                      const dtEnd   : TDateTime = CZStartDate1980;
                                      const dSortAsc: Boolean = false;
                                      const onlyGenLedgerAcc : Boolean = true):AStr;
  // ---
  // hetkel sama päring; tuleviku suhtes on parem hoia need funktsioonid eraldi, tunduvalt lihtsam muuta asju
  // 99 % sarnane pearaamatu päringule !
  // siin minnakse nö otse kande baaskirje juurde
var
 pStr     : TAStrList;
 pAccList : AStr;
begin
      result:='';
      pStr:=TAStrList.create;
      pAccList:=estbk_utilities.createSQLInList(dSelAccounts);
      // ------
 with pStr do
   try

        add('SELECT ');

        // 31.08.2011 Ingmar
        add('  COALESCE(');
        add('   (SELECT o.descr');
        add('    FROM accounting_records_attrb tr');
        add('    INNER JOIN objects o ON');
        add('    o.id=tr.attrib_id');
        add('    WHERE tr.accounting_record_id=a.id');
        add('      AND tr.attrib_type=''O''');
        add('      AND tr.id=(SELECT MAX(tr1.id)');
        add('                 FROM  accounting_records_attrb tr1');
        add('                 WHERE tr1.accounting_record_id=a.id');
        add('                   AND tr1.attrib_type=''O''');
        add('     )),'''') as object1,');

        add('b.entrynumber,');
        add('b.transdate,');
        add('b.transdescr,');
        add('e.document_nr,');
        add('a.id,');
        add('a.descr,');
        add('a.rec_nr,');
        //add('c.init_balance,');
        add('CAST(t.shortidef AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarCharType(2)+') AS account_type,');
        // aruandlus kordades lihtsam teha, ei pea eventides häkkima !
        add('(CASE WHEN a.rec_type=''D'' THEN a.rec_sum ELSE null END) AS rec_sum_d,'); // DEEBIT
        add('(CASE WHEN a.rec_type=''C'' THEN a.rec_sum ELSE null END) AS rec_sum_c,');  // KREEDIT
        //add('(CASE WHEN a.rec_type=''C'' THEN -a.rec_sum ELSE null END) as rec_sum_c,'); // baasis summad negatiivsed meie kuvame positiivselt


        add('a.rec_type,');
        add('a.client_id,');
        //add('a.tr_partner_name,');
        // 28.12.2011 Ingmar; taheti ka klienti; tulevikus päringut optimiseerida !
        add('(');
        add(' CASE WHEN COALESCE(a.tr_partner_name,'''')<>'''' THEN');
        add('  a.tr_partner_name');
        add(' ELSE');
        add(' (SELECT ');
        add('  CAST('+sqlp._doSafeSQLStrConcat([AStr('k.name'),AStr(''' '''),AStr('k.lastname')])+' AS '+TEstbk_MapDataTypes.__MapVarcharType(255)+')');
        add('  FROM client k');
        add('  WHERE k.id=a.client_id');
        add('    AND k.rec_deleted=''f''');
        add('  )');
        add(' END) as  client_name,');

        add('a.currency,');
        add('a.currency_vsum as currval_override,');
        //add('a.currval_override,');
        add('a.status,');
        add('a.account_id,');
        add('c.account_coding,');
        add('c.account_name,');
        add('a.accounting_register_id');
        add('FROM accounting_register b');

        add('INNER JOIN accounting_records a ON ');
        add('a.accounting_register_id=b.id');

        // ----
     if pAccList<>'' then
        add('   AND a.account_id in ('+pAccList+')');
        //add('   AND a.status NOT LIKE ''D%'''); // pole tegemist pearaamatu annuleeritud kirjetega !

        add('    AND a.id>(SELECT COALESCE(MAX(a1.id),0) FROM accounting_records a1 WHERE a1.accounting_register_id=b.id AND a1.status LIKE ''%D%'')');


        add('INNER JOIN accounts c ON');
        add('c.id=a.account_id');
        add('INNER JOIN accounting_register_documents d ON');
        add('d.accounting_register_id=b.id');
        add('INNER JOIN documents e ON');
        add('e.id=d.document_id');

        add('INNER JOIN classificators t ON');
        add('t.id=c.type_id');

        add(format('WHERE b.company_id=%d',[dCompanyId]));
        add(' AND b.type_ not like ''%D%'' AND b.template=''f''');

     if onlyGenLedgerAcc then
        add(' AND b.type_ like  ''%G%''');

     if dtStart<>CZStartDate1980 then
        add('   AND b.transdate>='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));

     if dtEnd<>CZStartDate1980 then
        add('   AND b.transdate<='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtEnd)));
        // AND w1.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance)

        //add('ORDER BY b.transdate DESC,b.id,b.entrynumber ASC,a.rec_nr ASC');
        add('ORDER BY b.transdate '+estbk_types.SCAscDesc[dSortAsc]+',b.entrynumber ASC,a.rec_nr ASC');

        result:=pStr.text;
   finally
        freeAndNil(pStr);
   end;
end;

// ---------------------------------------------------------------------------
// käibeandmik
// ---------------------------------------------------------------------------

function _CSQLRepDTurnoverEntrysSpeedUpTablePart1(const dCompanyId     : Integer;
                                                  var   dTempTableName : AStr;
                                                  const dSelAccounts   : TADynIntArray = nil):AStr;
var
 pStr     : TAStrList;
 pAccList : AStr;
begin

       dTempTableName:='turnover';
       result:='';
       pStr:=TAStrList.create;
       pAccList:=estbk_utilities.createSQLInList(dSelAccounts);
  with pStr do
    try
       add('SELECT ');
       add('c.id AS account_id,');
       add('c.account_coding,');
       add('c.account_name,');
       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS init_balance,');  // algsaldo
       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS dsum,'); // DS
       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS csum,'); // KS

       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS dsum_r,'); // DK
       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS csum_r,'); // KK
       // ###
       // 01.12.2011 Ingmar; aruandel ei kuvanud õiget summmat peale seda kui ülemkontole summeerisime ka allkontod !
       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS dsum_sub ,'); // DS
       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS csum_sub,'); // KS

       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS dsum_rsub,'); // DK
       add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS csum_rsub,'); // KK

       add('CAST(t.shortidef AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarCharType(2)+') AS account_type,');  // nö kreedit sõltub kontotüübist !

       // passivad allapoole
       add(' CAST((CASE ');
       add('        WHEN t.shortidef IN ');
       add('          ('+QuotedStr(estbk_types.CAccTypeAsActiva)+','+QuotedStr(estbk_types.CAccTypeAsCost)+') THEN '+ QuotedStr('0'));
       add('        WHEN t.shortidef IN ');
       add('       ('+QuotedStr(estbk_types.CAccTypeAsPassiva)+','+QuotedStr(estbk_types.CAccTypeAsProfit)+') THEN '+ QuotedStr('1'));
       add('       END)');
       add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapCharType(1)+') AS sortval');
       add('FROM accounts c');
       add('INNER JOIN classificators t ON');
       add('t.id=c.type_id');
       add(format('WHERE c.company_id=%d',[dCompanyId]));

  if   pAccList<>'' then
       add('  AND c.id in ('+pAccList+')');
       result:=sqlp._create_temptable(dTempTableName,pStr.Text,true);
    finally
       freeAndNil(pStr);
    end;
end;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart2(const dCompanyId     : Integer;
                                                  const dTempTableName : AStr;
                                                  const dtStart : TDateTime = CZStartDate1980):AStr;
var
 pStr  : TAStrList;
 p1,p2 : AStr;
begin
 pStr:=TAStrList.create;
  with pStr do
    try
       // 01.12.2011 Ingmar; muidu ei klappinud summad;
      add(format('UPDATE %s',[dTempTableName]));
      add('SET init_balance=0.00');

{
      add(format('UPDATE %s',[dTempTableName]));
      add('SET init_balance=COALESCE((');
  if  dtStart<>CZStartDate1980 then
    begin
      p1:=p1+' AND accounting_register.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)); //   <? või  <= ?
      p1:=p1+' AND accounting_register.template=''f''';
    end;
      p2:=' AND accounts.id='+dTempTableName+'.account_id'; // accounts
      add(estbk_sqlclientcollection._SQLSelectAccountInitBalance(estbk_globvars.glob_company_id,p1,p2));
      add('),0.00)');}
      // ---
      result:=pStr.Text;
    finally
      freeAndNil(pStr);
    end;
end;


function _CSQLRepDTurnoverEntrysSpeedUpTablePart3(const dCompanyId     : Integer;
                                                  const dTempTableName : AStr;
                                                  const dtStart : TDateTime = CZStartDate1980):AStr;
var
 pStr  : TAStrList;
begin
       pStr:=TAStrList.create;
  with pStr do
    try
      // dsum ja ksum algsaldo jaoks !
      add(format('UPDATE %s',[dTempTableName]));
      add('SET dsum=');
      add('CAST(');
      add('(');
      add(' SELECT coalesce(SUM(z0.rec_sum),0)');
      add(' FROM  accounting_records z0');
      add(' INNER JOIN accounting_register w0 ON');
      add(' w0.id=z0.accounting_register_id');
      // 01.12.2011 Ingmar; muidu ei klappinud summad;
      //add('AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));
      // 28.11.2011 Ingmar
      add(' AND w0.template=''f''');

   if dtStart<>CZStartDate1980 then
      add('   AND w0.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));

      add(format(' WHERE z0.account_id=%s.account_id',[dTempTableName]));
      add(format('   AND z0.rec_type=%s',[QuotedStr(estbk_types.CAccRecTypeAsDebit)]));  // D
      // add('   AND z0.status NOT LIKE ''%D%'''); 07.04.2011 Ingmar peame kõiki kandeid arvestama, ka tühistatuid !
      add(' )');
      add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+'),');

      add('csum=');
      add('CAST(');
      add('(');
      add(' SELECT coalesce(SUM(z0.rec_sum),0)');
      add(' FROM  accounting_records z0');
      add(' INNER JOIN accounting_register w0 ON');
      add(' w0.id=z0.accounting_register_id');
      // 01.12.2011 Ingmar; muidu ei klappinud summad;
      //add('AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));
      // 28.11.2011 Ingmar
      add(' AND w0.template=''f''');

   if dtStart<>CZStartDate1980 then
      add('   AND w0.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));

      add(format(' WHERE z0.account_id=%s.account_id',[dTempTableName]));
      add(format('   AND z0.rec_type=%s',[QuotedStr(estbk_types.CAccRecTypeAsCredit)]));  // C
      // add('   AND z0.status NOT LIKE ''%D%'''); 07.04.2011 Ingmar peame kõiki kandeid arvestama, ka tühistatuid !
      add(' )');
      add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+')');

      result:=pStr.Text;
    finally
      freeAndNil(pStr);
    end;
end;


function _CSQLRepDTurnoverEntrysSpeedUpTablePart4(const dCompanyId     : Integer;
                                                  const dTempTableName : AStr;
                                                  const dtStart : TDateTime = CZStartDate1980;
                                                  const dtEnd   : TDateTime = CZStartDate1980):AStr;
var
 pStr  : TAStrList;
begin
       pStr:=TAStrList.create;
  with pStr do
    try
      // käive !
      add(format('UPDATE %s',[dTempTableName]));
      add('SET dsum_r=');
      add('CAST(');
      add('(');
      add(' SELECT coalesce(SUM(z0.rec_sum),0)');
      add(' FROM  accounting_records z0');
      add(' INNER JOIN accounting_register w0 ON');
      add(' w0.id=z0.accounting_register_id ');
// 01.12.2011 Ingmar; muidu ei klappinud summad;
//      add('AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));
      // 28.11.2011 Ingmar
      add(' AND w0.template=''f''');

   if dtStart<>CZStartDate1980 then
      add('   AND w0.transdate>='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));

   if dtEnd<>CZStartDate1980 then
      add('   AND w0.transdate<='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtEnd)));


      add(format(' WHERE z0.account_id=%s.account_id',[dTempTableName]));
      add(format('   AND z0.rec_type=%s',[QuotedStr(estbk_types.CAccRecTypeAsDebit)]));  // D
      //add('   AND z0.status NOT LIKE ''%D%'''); 07.04.2011 Ingmar peame kõiki kandeid arvestama, ka tühistatuid !
      add(' )');
      add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+'),');

      add('csum_r=');
      add('CAST(');
      add('(');
      add(' SELECT coalesce(SUM(z0.rec_sum),0)');
      add(' FROM  accounting_records z0');
      add(' INNER JOIN accounting_register w0 ON');
      add(' w0.id=z0.accounting_register_id ');
// 01.12.2011 Ingmar; muidu ei klappinud summad;
//      add(' AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));

      // 28.11.2011 Ingmar
      add(' AND w0.template=''f''');

   if dtStart<>CZStartDate1980 then
      add('   AND w0.transdate>='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));

   if dtEnd<>CZStartDate1980 then
      add('   AND w0.transdate<='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtEnd)));

      add(format(' WHERE z0.account_id=%s.account_id',[dTempTableName]));
      add(format('   AND z0.rec_type=%s',[QuotedStr(estbk_types.CAccRecTypeAsCredit)]));  // C
      // add('   AND z0.status NOT LIKE ''%D%'''); 07.04.2011 Ingmar peame kõiki kandeid arvestama, ka tühistatuid !
      add(' )');
      add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+')');

      result:=pStr.Text;
    finally
      freeAndNil(pStr);
    end;
end;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart5(const dTempTableName : AStr):AStr;
var
 pStr  : TAStrList;
 pt    : AStr;
begin
       pStr:=TAStrList.create;
    with pStr do
      try
        pt:=dTempTableName;
        add(format('UPDATE %s',[pt]));
        add('SET dsum_ro=dsum_r,csum_ro=csum_r,dsum_or=dsum,csum_or=csum');
        // käive...vahemikus...
        //        add(format('SET dsum_ro=COALESCE((SELECT SUM(q1.dsum_r) FROM %s q1),0.00),',[pt,pt,pt]));
        //        add(format('csum_ro=COALESCE((SELECT SUM(q1.csum_r) FROM %s q1),0.00),',[pt,pt,pt]));
        // saldo kuni ... originaal väärtused
        //add(format('dsum_or=COALESCE((SELECT SUM(q1.dsum) FROM %s q1),0.00),',[pt,pt,pt]));
        //add(format('csum_or=COALESCE((SELECT SUM(q1.csum) FROM %s q1),0.00)',[pt,pt,pt]));
        result:=pStr.Text;
      finally
         freeAndNil(pStr);
      end;
end;

// 25.11.2011 Ingmar;  käibeadmikus tuleb allkontode summad ka lisada ! ehk kui 55 algusega peakonto, siis seal peavad ka 5500 ... 5501 summad olema
function _CSQLRepDTurnoverEntrysSpeedUpTablePart6(const dTempTableName : AStr):AStr;
var
 pStr  : TAStrList;
 pt    : AStr;
begin
       // account_coding
       pStr:=TAStrList.create;
  with pStr do
    try
       pt:=dTempTableName;
       // NB kompatiiblus kaob concati juures !
       //add(format('UPDATE %s',[pt]));
       //add('set account_id=account_id');

       add(format('UPDATE %s',[pt]));
       add(' SET ');
       add(format('dsum_rsub=COALESCE((SELECT SUM(q1.dsum_r) FROM %s q1 WHERE q1.account_coding LIKE %s.account_coding||''%%'' AND q1.account_coding<>%s.account_coding),0.00),',[pt,pt,pt]));
       add(format('csum_rsub=COALESCE((SELECT SUM(q1.csum_r) FROM %s q1 WHERE q1.account_coding LIKE %s.account_coding||''%%'' AND q1.account_coding<>%s.account_coding),0.00),',[pt,pt,pt]));
       add(format('dsum_sub=COALESCE((SELECT SUM(q1.dsum) FROM %s q1 WHERE q1.account_coding LIKE %s.account_coding||''%%'' AND q1.account_coding<>%s.account_coding),0.00),',[pt,pt,pt]));
       add(format('csum_sub=COALESCE((SELECT SUM(q1.csum) FROM %s q1 WHERE q1.account_coding LIKE %s.account_coding||''%%'' AND q1.account_coding<>%s.account_coding),0.00)',[pt,pt,pt]));
       // 30.11.2011 Ingmar
       //add(format(',init_balance=init_balance+COALESCE((SELECT SUM(q1.init_balance) FROM %s q1 WHERE q1.account_coding LIKE %s.account_coding||''%%'' AND q1.account_coding<>%s.account_coding),0.00)',[pt,pt,pt]));
       //add(format(',init_balance=COALESCE((SELECT SUM(q1.init_balance) FROM %s q1 WHERE q1.account_coding LIKE %s.account_coding||''%%'' ),0.00)',[pt,pt]));

       result:=pStr.Text;
    finally
       freeAndNil(pStr);
    end;
end;

function _CSQLRepDTurnoverEntrysSpeedUpTablePart7(const dTempTableName : AStr):AStr;
var
 pStr  : TAStrList;
begin
       // account_coding
       pStr:=TAStrList.create;
  with pStr do
    try
       add(format('DELETE FROM %s WHERE dsum_rsub=0.00 AND csum_rsub=0.00 AND dsum_sub=0.00 AND csum_sub=0.00 AND dsum_r=0.00 AND csum_r=0.00 AND dsum=0.00 AND csum=0.00 AND init_balance=0.00',[dTempTableName]));
       result:=pStr.Text;
    finally
       freeAndNil(pStr);
    end;
end;


function _CSQLRepDTurnoverEntrys(const dTempTableName : AStr;
                                 const dSortAsc: Boolean = true):AStr;
begin
   result:=format('SELECT * FROM %s ORDER BY account_coding '+estbk_types.SCAscDesc[dSortAsc]+',sortval ASC',[dTempTableName]);
end;

// ---------------------------------------------------------------------------
// kassaraamat
// ---------------------------------------------------------------------------
// kopeerime natuke pearaamatu aruannet !
function _CSQLRepCashBookSpeedUpTablePart1(const dCompanyId     : Integer;
                                           var   dTempTableName : AStr;
                                           const dCashBookAccounts : TADynIntArray):AStr; //  dCashRegAccounts = teoorias vaid üks..aga tulevik võib muutusi tuua
var
 pStr     : TAStrList;
 pAccList : AStr;
begin
     dTempTableName:='cashbld';
     result:='';
     pStr:=TAStrList.create;

     pAccList:=estbk_utilities.createSQLInList(dCashBookAccounts);

with pStr do
  try

     add('SELECT ');

     add('CAST(1 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapIntType()+') AS srline,'); // selle reaga hakkame mängima
     add('CAST(0 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapIntType()+') AS client_id,'); // selle reaga hakkame mängima
     add('CAST(0 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapIntType()+') AS payment_id,');

     add('CAST('''' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarcharType(35)+') AS entrynumber,');

     add('CAST(NULL AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapDateVariable()+') AS trdate,');
     add('CAST('''' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarcharType(255)+') AS descr,');

     add('c.id AS account_id,');
     add('CAST(0 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapIntType()+') AS crp_account_id,');
     add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS init_balance,');  // algsaldo
     // 22.03.2012 + algsaldo kanne ise + käive, bugi seda polnud !!!
     add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS lside,');  // algsaldo
     add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS rside,');  // algsaldo

     add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS incr,');  // sissetulek; kassa -> kreedit
     add('CAST(0.00 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') AS outr,');  // väljaminek  kassa -> deebet
     // @@@
     add('CAST(t.shortidef AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarCharType(2)+') AS account_type,');
     // jätame päringusse sisse...sest üllatusi võib tulevikus tulla !
     add('CAST(');
     add('  (CASE ');
     add('    WHEN t.shortidef IN ');
     add('     ('+QuotedStr(estbk_types.CAccTypeAsActiva)+','+QuotedStr(estbk_types.CAccTypeAsCost)+') THEN '+ QuotedStr(estbk_types.CAccRecTypeAsDebit));
     add('    WHEN t.shortidef IN ');
     add('     ('+QuotedStr(estbk_types.CAccTypeAsPassiva)+','+QuotedStr(estbk_types.CAccTypeAsProfit)+') THEN '+ QuotedStr(estbk_types.CAccRecTypeAsCredit));
     add('   END)');
     add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapCharType(1)+') AS lsideidf,');

     add('CAST(');
     add('  (CASE ');
     add('    WHEN t.shortidef IN ');
     add('     ('+QuotedStr(estbk_types.CAccTypeAsActiva)+','+QuotedStr(estbk_types.CAccTypeAsCost)+') THEN '+ QuotedStr(estbk_types.CAccRecTypeAsCredit));
     add('    WHEN t.shortidef IN ');
     add('     ('+QuotedStr(estbk_types.CAccTypeAsPassiva)+','+QuotedStr(estbk_types.CAccTypeAsProfit)+') THEN '+ QuotedStr(estbk_types.CAccRecTypeAsDebit));
     add('   END)');
     add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapCharType(1)+') AS rsideidf');

     add('FROM accounts c');
     add('INNER JOIN classificators t ON');
     add('t.id=c.type_id');
     add(format('WHERE c.company_id=%d',[dCompanyId]));

  if pAccList<>'' then
     add('  AND c.id in ('+pAccList+')');
     result:=sqlp._create_temptable(dTempTableName,pStr.Text,true);

  finally
   freeAndNil(pStr);
  end;
end;


function _CSQLRepCashBookSpeedUpTablePart2(const dCompanyId     : Integer;
                                           const dTempTableName : AStr;
                                           const dtStart : TDateTime = CZStartDate1980;
                                           const dtEnd   : TDateTime = CZStartDate1980):AStr;
var
   pStr  : TAStrList;
begin
     result:='';
     pStr:=TAStrList.create;
     // ------
  with pStr do
  try

      add(format('UPDATE %s',[dTempTableName]));
      add('SET lside=');
      add('CAST(');
      add('(');
      add(' SELECT coalesce(SUM(z0.rec_sum),0)');
      add(' FROM  accounting_records z0');
      add(' INNER JOIN accounting_register w0 ON');
      add(' w0.id=z0.accounting_register_id AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));

   if dtStart<>CZStartDate1980 then
      add(' AND w0.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));
      add(' AND w0.template=''f''');


      add('INNER JOIN accounting_register_documents dr ON');
      add('dr.accounting_register_id=w0.id');

      add('INNER JOIN documents d ON');
      add(format('d.id=dr.document_id AND d.document_type_id IN (%d,%d)',[_ac.sysDocumentId[_dsReceiptVoucherDocId],
                                                                          _ac.sysDocumentId[_dsPaymentVoucherDocId]]));  //

      add(format(' WHERE z0.account_id=%s.account_id',[dTempTableName]));
      add(format('   AND z0.rec_type=%s.lsideidf',[dTempTableName]));  // D
      //add('   AND z0.status NOT LIKE ''%D%'''); Ingmar peame kõiki kandeid arvestama, ka tühistatuid !
      add(' )');
      add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+'),'); // tavaliselt deebetsumma !

      add('rside=');
      add('CAST(');
      add('(');
      add(' SELECT coalesce(SUM(z1.rec_sum),0)');
      add(' FROM  accounting_records z1');
      add(' INNER JOIN accounting_register w1 ON');
      add(' w1.id=z1.accounting_register_id AND w1.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));

   if dtStart<>CZStartDate1980 then
      add('   AND w1.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));  // 26.05.2011 Ingmar
      // 27.11.2011 Ingmar
      add(' AND w1.template=''f''');

      add('INNER JOIN accounting_register_documents dr ON');
      add('dr.accounting_register_id=w1.id');

      add('INNER JOIN documents d ON');
      add(format('d.id=dr.document_id AND d.document_type_id IN (%d,%d)',[_ac.sysDocumentId[_dsReceiptVoucherDocId],
                                                                          _ac.sysDocumentId[_dsPaymentVoucherDocId]]));  //

      add(format(' WHERE z1.account_id=%s.account_id',[dTempTableName]));
      add(format('   AND z1.rec_type=%s.rsideidf',[dTempTableName]));   // C
      // add('   AND z1.status NOT LIKE ''%D%'''); // Ingmar, siin oli tühistatud unustatud !
      add(' )');
      add(' AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+')');
      // @@@
      result:=text;
   finally
      free;
   end;
end;

function _CSQLRepCashBookSpeedUpTablePart3(const dCompanyId     : Integer;
                                           const dTempTableName : AStr;
                                           const dtStart : TDateTime = CZStartDate1980):AStr;
var
   pStr  : TAStrList;
   p1,p2 : AStr;
begin
     result:='';
     p1:='';
     p2:='';
     pStr:=TAStrList.create;
     // ------
  with pStr do
  try
      add(format('UPDATE %s',[dTempTableName]));
      add('SET init_balance=COALESCE((');
  if  dtStart<>CZStartDate1980 then
    begin
      p1:=p1+' AND accounting_register.transdate<'+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)); //  <? või  <= ?
      p1:=p1+' AND w0.template=''f''';
    end;
      p2:=' AND accounts.id='+dTempTableName+'.account_id'; // accounts
      add(estbk_sqlclientcollection._SQLSelectAccountInitBalance(estbk_globvars.glob_company_id,p1,p2));
      add(format('),0.00)+COALESCE(%s.lside-%s.rside,0.00)',[dTempTableName,dTempTableName]));
      // srline=1 pole vaja, sest see teine päring tabel on veel tühi !
      result:=pStr.Text;
  finally
     freeAndNil(pStr);
  end;
end;



// multiple select ei tööta hästi !
function _CSQLRepCashBookSpeedUpTablePart4(const dCompanyId     : Integer;
                                           const dTempTableName : AStr;
                                           const dDetailedView  : Boolean;
                                           const dDocType  : TSystemDocType; // _dsReceiptVoucherDocId
                                           const dClientId : Integer = 0;
                                           //const dPaymentStatusIndx : Integer = 0; // 0 -  kõik; 1 - kinnitatud 2 - kinnitamata
                                           const dtStart : TDateTime = CZStartDate1980;
                                           const dtEnd   : TDateTime = CZStartDate1980):AStr;
var
 pStr  : TAStrList;
begin


       pStr:=TAStrList.create;
  with pStr do
    try
       if dDocType=_dsReceiptVoucherDocId then
          add(format('INSERT INTO %s(incr,srline,account_id,crp_account_id,init_balance,outr,payment_id,client_id,entrynumber,trdate,descr,account_type,lsideidf,rsideidf)',[dTempTableName]))
       else
       if dDocType=_dsPaymentVoucherDocId then
          add(format('INSERT INTO %s(outr,srline,account_id,crp_account_id,init_balance,incr,payment_id,client_id,entrynumber,trdate,descr,account_type,lsideidf,rsideidf)',[dTempTableName]));


          add('SELECT ');

          add(' SUM(z0.rec_sum),'); // --
       if dDocType=_dsReceiptVoucherDocId then
          add(' 2 as srline,')     //  srline 2; sissetuleku order
       else
       if dDocType=_dsPaymentVoucherDocId then
          add(' 3 as srline,');    //  srline 3; väljamineku order

          add(' b.account_id,');   // kassa konto
          add(' z0.account_id as crp_account_id,');  // vastaskonto
          {
           Ainar Rohule
          Alustasime kannetega Jaanuari kuus, panen siia jaanuari kuu kassaraamatu. Siin on kõik korras kuna jaanuari alguses oligi kassa jääk 0.- eurot.
          Nüüd kui soovin Veebruari kuu kohta kassa raamatut, siis Algsaldo peab olema sama mis jaanuari Lõppsaldo ehk 6,93 eurot.

          Aga kuvab valesti ehk näitab 0,- eurot, ning seetõttu on ka Lõppsaldo vale. Õige Lõppsaldo peab olema 6,93+178,72=185,65
          }
          add(' b.init_balance,');
          add(' 0.00 as iotr,');
          add(' p.id as payment_id,');
          add(' z0.client_id,');

          add(' w0.entrynumber,');
          add(' w0.transdate as trdate,');

          add(' z0.descr,');
          add(' b.account_type,');
          add(' b.lsideidf,');
          add(' b.rsideidf');

          add(format('FROM %s b ',[dTempTableName]));

          add(' INNER JOIN accounting_register w0 ON');
          //add(' w0.id=z0.accounting_register_id AND w0.type_<>'+QuotedStr(estbk_types.CAccRecIdentAsInitBalance));
          add('  w0.type_='+QuotedStr(estbk_types.CAddRecIdentAsCashReg));
          // 28.11.2011 Ingmar
          add(' AND w0.template=''f''');

       if dtStart<>CZStartDate1980 then
          add('   AND w0.transdate>='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtStart)));
       if dtEnd<>CZStartDate1980 then
          add('   AND w0.transdate<='+ QuotedStr(estbk_utilities.datetoOdbcStr(dtEnd)));


       if dDetailedView then
         begin
            add('   AND EXISTS(SELECT z1.* ');
            add('              FROM accounting_records z1 ');
            add('              WHERE z1.accounting_register_id=w0.id ');


          case dDocType of
          _dsReceiptVoucherDocId : begin
                                     add(format(' AND z1.rec_type=%s',[QuotedStr(CAccRecTypeAsDebit)]));
                                   end;

          _dsPaymentVoucherDocId : begin
                                      add(format(' AND z1.rec_type=%s',[QuotedStr(CAccRecTypeAsCredit)]));
                                   end;
          end;
            add('               AND z1.account_id=b.account_id');
            // ---
            add(')');
         end;

          add('INNER JOIN accounting_register_documents dr ON');
          add('dr.accounting_register_id=w0.id');

          add('INNER JOIN documents d ON');
          add(format('d.id=dr.document_id AND d.document_type_id=%d',[_ac.sysDocumentId[dDocType]]));  //


         add(' INNER JOIN accounting_records z0 ON ');
         add(' z0.accounting_register_id=w0.id');

       case dDocType of
       _dsReceiptVoucherDocId : begin
                                if dDetailedView then
                                   add(format(' AND z0.rec_type=%s',[QuotedStr(CAccRecTypeAsCredit)]))
                                else
                                   add(format(' AND z0.rec_type=%s',[QuotedStr(CAccRecTypeAsDebit)]));
                                end;

       _dsPaymentVoucherDocId : begin
                                if dDetailedView then
                                   add(format(' AND z0.rec_type=%s',[QuotedStr(CAccRecTypeAsDebit)]))
                                else
                                   add(format(' AND z0.rec_type=%s',[QuotedStr(CAccRecTypeAsCredit)]));
                                end;
       end;

          // -- annuleerimisi mitte kuvada ?!?
          add(' AND z0.id>(SELECT COALESCE(max(zc.id),0) FROM accounting_records zc WHERE zc.accounting_register_id=w0.id AND zc.status LIKE ''%D%'')');


          // ---
          add('INNER JOIN payment p ON ');
          add('p.accounting_register_id=w0.id ');


      if  dClientId>0 then
          add(format(' AND p.client_id=%d',[dClientId]));

          add('WHERE b.srline=1');



      add('GROUP BY b.account_id,z0.account_id,b.init_balance,p.id,z0.client_id,w0.entrynumber,w0.transdate,z0.descr,b.account_type,b.lsideidf,b.rsideidf');


      result:=pStr.Text;
      // pStr.SaveToFile('c:\test.txt');
    finally
      freeAndNil(pStr);
    end;
end;


function _CSQLRepCashBookFinalQrt(const dTempTableName : AStr;
                                  const dSortAsc: Boolean = true):AStr;
var
   pStr  : TAStrList;
begin


         pStr:=TAStrList.create;
    with pStr do
    try
      add('SELECT z.*,p.descr as longdescr,c.name as firstname,c.lastname,c.regnr,');
      add('a.account_coding,a.account_name,a1.account_coding as cpaccount_coding,a1.account_name as cpaccount_name');
      add(format('FROM %s z',[dTempTableName]));
      add('INNER JOIN accounts a ON '); // KASSA
      add('a.id=z.account_id');
      add('LEFT OUTER JOIN accounts a1 ON '); // KASSA
      add('a1.id=z.crp_account_id');

      add('INNER JOIN payment p ON ');
      add('p.id=z.payment_id');
      add('LEFT OUTER JOIN client c ON');
      add('c.id=z.client_id');

      add('ORDER BY z.account_id,z.trdate ASC,z.payment_id ASC');
      result:=pStr.Text;
    finally
      freeAndNil(pStr);
    end;
end;

// --
end.
