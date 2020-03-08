unit estbk_sqlclientcollection;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils,math,estbk_types;

{
Firebird
CREATE DOMAIN T_BOOLEAN_INT

  AS SMALLINT

  DEFAULT 0

  NOT NULL

  CHECK (VALUE IN (0,1))

Or

CREATE DOMAIN T_BOOLEAN_CHAR

  AS CHAR(1)

  DEFAULT 'F'

  NOT NULL

  CHECK (VALUE IN ('T', 'F'))
}
const
   CDefaultMaxRows = 6000; // EVEGA tekkis probleem, et kõiki kliente ei kuvatud, sest 200 oli piirang, neil oli 900


const


   // #########################################################################
   // VARIA
   // #########################################################################

   _SQLConfSelectLogo = ' SELECT id,val_blob '+
                        ' FROM conf '+
                        ' WHERE company_id=:company_id'+
                        '   AND var_name=''billlogo''';



   _CSQLSelectCompany = ' SELECT c.id, c.name as company_name, c.regnr, c.vatnumber, c.countrycode, '+
                        ' c.county_id,d.name as county_name, c.city_id,e.name as city_name, c.street_id, '+
                        ' f.name as street_name, c.house_nr, c.apartment_nr, c.zipcode, c.phone, c.mobilephone, '+
                        ' c.fax, c.email, c.contactperson, c.contactperson_phone, c.contactperson_email, '+
                        ' c.logo, c.parent_id, c.descr, c.department_object_id '+
                        ' FROM company c '+
                        ' LEFT OUTER JOIN county d ON '+
                        ' d.id=c.county_id '+
                        ' LEFT OUTER JOIN city e ON '+
                        ' e.id=c.city_id '+
                        ' LEFT OUTER JOIN street f ON '+
                        ' f.id=c.street_id '+
                        ' WHERE c.id=:company_id';



   _CSQLSelectFromClassificator = ' SELECT id,parent,name as clfname,type_ as clftype,shortidef,weight '+
                                  ' FROM classificators '+
                                  ' WHERE type_=:clftype '+
                                  '   AND company_id=:company_id '+
                                  ' ORDER BY name ';

  _CSQLInsertClassificator= ' INSERT INTO classificators(id, parent, name, shortidef, type_, weight, company_id) '+
                            ' VALUES (:id, :parent, :classfname, '''',:classtype, :weight, :company_id)';


  // ehk firmad, mille all tohib kasutaja tegutseda !
  _CSQLUserCompanyList = ' SELECT  u.company_id,c.name as company_name '+
                         ' FROM user_company_acclist u'+
                         ' INNER JOIN company c ON'+
                         ' c.id=u.company_id'+
                         ' WHERE user_id=:user_id '+
                         ' UNION '+ // ROOT saab alati kõikjale ligi ! 0 kasutajanimega logimist nimetame kui root logimist
                         ' SELECT c.id as company_id,c.name as company_name '+
                         ' FROM company c '+
                         ' WHERE c.id=(CASE WHEN COALESCE(:user_id,0)=0 THEN c.id ELSE 0 END) '+
                         ' ORDER BY company_name';


   // maksetähtajad
   _CSQLSelectPaymentTerms = ' SELECT  c.id,c.name,c.value '+
                             ' FROM classificators c '+
                             ' WHERE c.type_=''payment_terms'''+
                             '  AND c.company_id=0 '+
                             '  AND not exists(select c1.id from classificators c1 where c1.company_id=:company_id and  c1.type_=''payment_terms'') '+
                             ' UNION '+
                             ' SELECT c.id,c.name,c.value '+
                             ' FROM classificators c '+
                             ' WHERE c.type_=''payment_terms'''+
                             '   AND c.company_id=:company_id '+
                             ' ORDER BY id ';
   // #########################################################################
   // - VALUUTAINFO

   _CSQLInsertCurrencySQL = ' INSERT INTO currency_exc(curr_name, curr_date, curr_rate,'+
                            ' rec_changed, rec_changedby,rec_addedby) '+
                            ' SELECT :curr_name,:curr_date,:curr_rate,:rec_changed,:rec_changedby,:rec_addedby '+
                            ' FROM __int_systemtypes '+
                            ' WHERE NOT EXISTS(SELECT * FROM currency_exc WHERE curr_name=:curr_name AND curr_date=:curr_date) '+
                            '   AND bbool=''t''';

   _SQLVerifyNeedOfCurrFetch = ' SELECT id FROM currency_exc WHERE curr_date=:curr_date';

   _SQLSelectCurrencyNames   = ' SELECT DISTINCT curr_name as cname '+
                               ' FROM currency_exc '+
                               ' ORDER BY curr_name ASC';

   _SQLFullSelectCurrencys   = ' SELECT id, curr_name, curr_date, curr_rate, rec_changed, rec_changedby, rec_addedby '+
                               ' FROM currency_exc '+
                               ' WHERE curr_date=COALESCE(:curr_date,curr_date) '+
                               ' ORDER BY curr_name ASC';




   // #########################################################################
   // - KONTOD

   // #########################################################################
   // KONTO PÄRING; kas peaks hetkesaldo ka arvutama ?!?
   // _CSQLGetAllAccounts viisin funktsiooni !





   // open = tohin kasutada; mõneti disainiviga ! Flags on bitmask kujul !!!
   // _CSQLGetOpenAccounts  fnc




   // küsime nö kõik objektid ja panen neile ka konto info külge; kontode sisestamine
   _CSQLGetAllAccReqObjects = ' SELECT c.id as account_id,a.classificator_id as objgrp_id,d.name as objgrpname,'+
                              ' a.id as object_id,a.descr as objname,c.valid as chkfield,b.id '+
                              //' coalesce(case when b.id>0 then true else false end,false) as chkfield   '+ kõik tore, aga zeos ei luba hiljem sisu muuta ...
                              ' FROM objects a '+
                              ' LEFT OUTER JOIN accounts_reqobjects b ON '+
                              ' b.item_id=a.id AND b.type_=''O''  AND b.status='''' AND b.account_id=:account_id  '+
                              ' LEFT OUTER JOIN  accounts c ON '+
                              ' c.id=b.account_id AND c.company_id=a.company_id  '+
                              ' LEFT OUTER JOIN  classificators d ON '+
                              ' d.id=a.classificator_id '+
                              ' WHERE a.rec_deletedby=0 '+
                              '   AND a.company_id=:company_id '+
                              ' ORDER BY d.name asc,a.descr ';

   // kasutan pearaamatus, firma kontode kaupa jätam meelde nõutud objektid !
   _CSQLGetAllAccMarkedObjects = ' SELECT c.id as account_id,a.classificator_id as objgrp_id,d.name as objgrpname,'+
                                 ' a.id as object_id,a.descr as objname,b.id '+
                                 ' FROM objects a '+
                                 ' INNER JOIN accounts_reqobjects b ON '+
                                 ' b.item_id=a.id AND b.type_=''O''  AND b.status='''' '+
                                 ' INNER JOIN  accounts c ON '+
                                 ' c.id=b.account_id AND c.company_id=a.company_id  '+
                                 ' LEFT OUTER JOIN  classificators d ON '+
                                 ' d.id=a.classificator_id '+
                                 ' WHERE a.rec_deletedby=0 '+
                                 '   AND a.company_id=:company_id '+
                                  ' ORDER BY d.name asc,a.descr ';

   // kontrollime, kas peame uuesti pearaamatus kontodega seotud objektide nimistu laadima
   _CSQLGetMaxAccMarkedObjectID = ' SELECT max(b.id) as maxobjid,count(b.id) as objcnt '+
                                  ' FROM objects a '+
                                  ' INNER JOIN accounts_reqobjects b ON '+
                                  ' b.item_id=a.id AND b.type_=''O''  AND b.status='''' '+
                                  ' INNER JOIN  accounts c ON '+
                                  ' c.id=b.account_id AND c.company_id=a.company_id  '+
                                  ' WHERE a.rec_deletedby=0 '+
                                 '   AND a.company_id=:company_id ';

   // pearaamatu kande kirjete annuleerimine
   _SQLCancelAccRecSQL = ' INSERT INTO accounting_records( '+
                         ' accounting_register_id, account_id, '+
                         ' rec_nr, rec_sum, rec_type, currency, currency_vsum,currency_drate_ovr,currency_id, '+
                         ' company_id, status, archive_rec_id, rec_changed, rec_changedby,rec_addedby, '+
                         ' client_id,flags,ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag, '+ // 17.02.2011 Ingmar lisasin kõik väljad !
                         ' ref_debt_flag,ref_tax_flag) '+

                         ' SELECT a.accounting_register_id, a.account_id, '+
                         ' a.rec_nr, -a.rec_sum, a.rec_type, a.currency, -a.currency_vsum,a.currency_drate_ovr,a.currency_id, '+ // teeme vastandmärgiga kanderea
                         ' a.company_id, ''D'', id,  :rec_changed, :rec_changedby, :rec_addedby, '+
                         ' a.client_id,a.flags,a.ref_item_type,a.ref_item_id,a.ref_prepayment_flag,a.ref_payment_flag,a.ref_income_flag,a.ref_debt_flag,a.ref_tax_flag '+

                         ' FROM  accounting_records a '+
                         ' WHERE a.accounting_register_id=:accounting_register_id '+
                         '   AND a.status not like ''%D%'''+
                         // 15.01.2010 Ingmar
                         '   AND a.id>(SELECT COALESCE(max(b.id),0) '+
                         '             FROM accounting_records b '+
                         '             WHERE b.accounting_register_id=a.accounting_register_id '+
                         '               AND b.status like ''%D%'')'+
                         ' ORDER BY a.rec_nr ';


   // 10.01.2010 ingmar;
   _SQLCancelAccRecSQLR= ' INSERT INTO accounting_records( '+
                         ' accounting_register_id, account_id, '+
                         ' rec_nr, rec_sum, rec_type, currency, currency_vsum,currency_drate_ovr,currency_id, '+
                         ' company_id, status, archive_rec_id, rec_changed, rec_changedby,rec_addedby, '+
                         ' client_id,flags,ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag, '+ // 17.02.2011 Ingmar lisasin kõik väljad !
                         ' ref_debt_flag,ref_tax_flag) '+


                         ' SELECT accounting_register_id, account_id, '+
                         ' rec_nr, -rec_sum, rec_type, currency, -currency_vsum,currency_drate_ovr,currency_id, '+ // teeme vastandmärgiga kanderea
                         ' company_id, ''D'', id,  :rec_changed, :rec_changedby, :rec_addedby, '+
                         ' client_id,flags,ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag,ref_debt_flag,ref_tax_flag '+ // 17.02.2011 Ingmar lisasin kõik väljad !

                         ' FROM  accounting_records '+
                         ' WHERE id=:acc_rec_id '+
                         '   AND status not like ''%D%''';

   // pearaamatu kannete aluskirje
   // uue kande puhul
   _CSQLInsertNewAccReg = ' INSERT INTO accounting_register( '+
                          ' id, entrynumber, transdescr, transdate, company_id, '+
                          '  rec_changed, rec_changedby, rec_addedby,type_,accounting_period_id) '+
                          ' VALUES (:id,:entrynumber,:transdescr,:transdate,:company_id,:rec_changed,'+
                          ':rec_changedby,:rec_addedby,:type_,:accounting_period_id)';

   _CSQLInsertNewAccReg2= ' INSERT INTO accounting_register( '+
                          '  entrynumber, transdescr, transdate, company_id, '+
                          '  rec_changed, rec_changedby, rec_addedby,type_,accounting_period_id) '+
                          ' VALUES (:entrynumber,:transdescr,:transdate,:company_id,:rec_changed,'+
                          ':rec_changedby,:rec_addedby,:type_,:accounting_period_id) RETURNING *';

   // üldiselt kande põhikirjel meil pole status välja, see eest tüüp; G - sõnast general ledger
   // kui type='CG'; siis on tegemist annuleeritud kandega; kande kustutamist kui sellist pole !!!!
   // vana kande uuendamine
   _CSQLUpdateAccReg = ' UPDATE accounting_register '+
                       ' SET transdescr=:transdescr,transdate=:transdate,accounting_period_id=:accounting_period_id,'+
                       ' type_=COALESCE(:type_,type_), rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                       ' WHERE id=:id ';

   // baaskirje annuleerimine
   // (''C''||replace(type_,''C'','')) ei tööta rumal zeos ei leia siis enam parameetreid !
   _SQLUpdCancelAccReg = ' UPDATE accounting_register '+
                         ' SET type_=(''C''||type_),rec_changed=:rec_changed,rec_changedby=:rec_changedby '+ //  31.07.2012 Ingmar originaaltüüp ei säilinud !; type_=''CG''
                         ' WHERE id=:id ';



    // ja sellega tühistame lõplikult aktiivsed kirjed
    _SQLCancelAccRecSQL2= ' UPDATE accounting_records '+
                          ' SET status=''D'',archive_rec_id=id, rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                          ' WHERE accounting_register_id=:accounting_register_id ';


   // 04.08.2011 Ingmar
   // seoses arvetega selgus, et kui arve seotakse lahti ning muudetakse kande ja arve kuupäev ära
   // siis kande kuupäeva enam ei uuendata !
   _SQLUpdateAccRecCommonAttr = ' UPDATE accounting_register '+
                                ' SET transdescr=:transdescr,transdate=:transdate,rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                                ' WHERE id=:id ';


   // konto defineerimine !
   // kontoga seotud kohustuslikud objektid !!
   _CSQLInsertAccReqObjects = ' INSERT INTO accounts_reqobjects(id, account_id, item_id, type_,'+
                              ' rec_changed, rec_changedby,rec_addedby) '+ // rec_deletedby, rec_deleted
                              ' VALUES (:id,:account_id,:object_id,:type_, :rec_changed,'+
                              ' :rec_changedby,:rec_addedby) ';


   _CSQLDeleteAccReqObjects = ' UPDATE accounts_reqobjects '+
                              ' SET  rec_changed=:rec_changed,rec_changedby=:rec_changedby,status=''D'' '+ // D on standardne Delete tunnus meil !!!
                              ' WHERE id=:id ';



   // #########################################################################
   // KONTROLLIB kas antud konto või kood eksisteerib

   _CSQLVerifyAccountName= ' SELECT id '+
                           ' FROM accounts '+
                           ' WHERE account_name=:account_name '+
                           '   AND company_id=:company_id '+
                           '   AND id<>coalesce(:id,0) '+
                           ' UNION '+
                           ' SELECT id '+
                           ' FROM accounts '+
                           ' WHERE account_coding=:account_coding '+
                           '   AND company_id=:company_id '+
                           '   AND id<>coalesce(:id,0) ';


    // tohib olla vaid üks pangakonto antud valuutaga
    _CSQLVerifyAccBankData= ' SELECT account_coding '+
                            ' FROM accounts '+
                            ' WHERE '+
                            '       bank_id>0 '+
                            '   AND account_coding<>:account_coding '+
                            '   AND bank_id=:bank_id '+
                            '   AND default_currency=:default_currency '+
                            '   AND account_nr=:account_nr '+
                            '   AND company_id=:company_id ';


    // -- kontrollime konto kasutamist;  TODO peaks vaatama üle [union] arved / tasumised / laekumised / jne
    _CSQLIsAccountBeenUsed = ' SELECT MAX(id) as id '+
                             ' FROM accounting_records '+
                             ' WHERE account_id=:account_id ';

    _CSQLDeleteAccount = ' UPDATE accounts '+
                         ' SET valid=''f'',rec_changed=:rec_changed,rec_deletedby=:rec_deletedby,rec_deleted=''t'''+
                         ' WHERE id=:id '+
                         '   AND company_id=:company_id ';



  // account_group_id=:account_group_id,

   _CSQLUpdateAccount   =  ' UPDATE accounts '+
                           ' SET  account_coding=:account_coding,default_currency=:default_currency,'+
                           ' account_name=:account_name, type_id=:type_id,typecls_id=:typecls_id,balance_rep_line_id=:balance_rep_line_id,incstat_rep_line_id=:incstat_rep_line_id, '+
                           ' bank_id=:bank_id, account_nr=:account_nr,account_nr_iban=:account_nr_iban,'+
                           ' display_onbill=:display_onbill,display_billtypes=:display_billtypes, '+
                           ' parent_id=:parent_id,flags=:flags,rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                           ' WHERE id=:id';


  // account_group_id
  // :account_group_id
   _CSQLInsertAccount =' INSERT INTO accounts(id, account_coding, account_name,default_currency, company_id,balance_rep_line_id,incstat_rep_line_id, '+
                       ' init_balance,type_id,parent_id,bank_id,account_nr,account_nr_iban,display_onbill,display_billtypes,'+
                       ' rec_changed, rec_changedby, rec_addedby) '+
                       ' VALUES(:id,:account_coding,:account_name,:default_currency,:company_id,'+
                       ' :balance_rep_line_id,:incstat_rep_line_id,:init_balance,:type_id,:parent_id,:bank_id, :account_nr, :account_nr_iban,:display_onbill,:display_billtypes,'+
                       ' :rec_changed,:rec_changedby,:rec_addedby)';


  // #########################################################################
  // - KASUTAJA FIRMAD
  // #########################################################################
  _CSQLUserAccCompList  = ' SELECT c.id, c.name '+
                          ' FROM company c '+
                          ' INNER JOIN user_company_acclist a ON '+
                          ' a.company_id=c.id AND a.user_id=:user_id '+
                          ' ORDER BY c.name ';


  // #########################################################################
  // KÄIBEMAKSUD; firmapõhiseks teha ?!?
  // 19.01.2010; kui perc on väiksem <0, siis käibemaksu ei arvesta
  _CSQLGetVAT = ' SELECT id,description,(CASE WHEN perc<0 THEN NULL ELSE perc END) as perc,flags as vatflags,'+
                ' defaultvat,vat_account_id_s,vat_account_id_i,vat_account_id_p,valid '+
                ' FROM vat '+
                ' WHERE valid=''t'' '+  // tohib kasutada !
                '   AND company_id=:company_id '+
                ' ORDER BY perc,flags ';
                //' ORDER by ID asc ';

   // #########################################################################
   // annab KM grupi viimase KM%
   _CSQLGetActiveVATId = ' SELECT v3.* ' +
                         ' FROM vat v3 ' +
                         ' WHERE v3.id = ' +
                         ' (SELECT MAX(v2.id) ' +
                         '  FROM vat v2 ' +
                         '  WHERE v2.base_rec_id = ' +
                         '  (SELECT v1.base_rec_id FROM vat v1 WHERE v1.id = :vatid)) ';

   // #########################################################################
   // Klassifikaatorid !
   // - KONTO TÜÜBID
  _CSQLAccountTypes     = ' SELECT id,shortidef as accshortident,name as accname '+
                          ' FROM classificators '+
                          ' WHERE type_=''account_type'''+
                          ' ORDER BY id ';

   // - KONTO KLASS
   _CSQLAccountClassfTypes = ' SELECT id,shortidef as accshortident,name as accname '+
                             ' FROM classificators '+
                             ' WHERE type_=''account_classificator'''+
                             ' ORDER BY id ';



  // - DOKUMENDI TÜÜBID
  _CSQLDocumentTypes    = ' SELECT id,shortidef as docshortident,name as docname '+
                          ' FROM classificators '+
                          ' WHERE type_=''document_types'''+
                          //'  AND shortidef<>''UD'''+ // defineerimata valikut ei kuva !
                          ' ORDER BY id ';

  // - RIIGID
  _CSQLCountryNames     = ' SELECT id,shortidef as iso3,name as countyname '+
                          ' FROM classificators '+
                          ' WHERE type_=''iso3166codes'''+
                          ' ORDER BY name ';

  // - ARTIKLITE ÜHIKUD
  _CSQLAmountNames      = ' SELECT id,shortidef as qtype,name as amountname '+
                          ' FROM classificators '+
                          ' WHERE type_=''amount_type'''+
                          ' ORDER BY id ';

  // - KASUTAJA DEFINEERITUD ARTIKLITE TÜÜBID
  _CSQLArticleTypes     = ' SELECT id,shortidef as qtype,name as arttypename '+
                          ' FROM classificators '+
                          ' WHERE type_=''articleutype'''+
                          '   AND company_id=:company_id '+
                          ' ORDER BY id ';

  // #########################################################################
  // NUMERAATORID
  // cr_num_type

  _CSQLGetNumerator    = ' SELECT id,cr_num_val,cr_vrange_start,cr_vrange_end,cr_version '+
                         ' FROM numerators '+
                         ' WHERE cr_valid=''t'' '+
                         '   AND company_id=:company_id '+
                         '   AND cr_num_type=:cr_num_type '+
                         '   AND accounting_period_id=COALESCE(:accounting_period_id,accounting_period_id)'; // 14.04.2012 Ingmar


  // 10.10.2013 Ingmar; fix bugile, kus ei olnud rp. perioodi põhine numeraator, aga oli loodud mitu numeraatorit !
  _CSQLGetNumerator2   = ' SELECT n.id,n.cr_num_val,n.cr_vrange_start,n.cr_vrange_end,n.cr_version '+
                         ' FROM numerators n'+
                         ' WHERE n.cr_valid=''t'' '+
                         '   AND n.company_id=:company_id '+
                         '   AND n.cr_num_type=:cr_num_type '+
                         '   AND n.accounting_period_id=COALESCE(:accounting_period_id,n.accounting_period_id) '+
                         '   AND n.rec_changed = (SELECT MAX(n1.rec_changed) '+
                         '                        FROM numerators n1 '+
                         '                        WHERE n1.cr_valid=''t'' '+
                         '                          AND n1.company_id=:company_id '+
                         '                          AND n1.cr_num_type=:cr_num_type '+
                         '                           AND n1.accounting_period_id=COALESCE(:accounting_period_id,n1.accounting_period_id))';



  _CSQLUpdateNumerator = ' UPDATE numerators '+
                         ' SET cr_num_val=:cr_num_val, cr_num_start=coalesce(:cr_num_start,cr_num_start),'+
                         ' cr_vrange_start=coalesce(:cr_vrange_start,cr_vrange_start),'+
                         ' cr_vrange_end=coalesce(:cr_vrange_end,cr_vrange_end),'+
                         ' cr_version=coalesce(:cr_version,cr_version), '+
                         ' cr_valid=coalesce(:cr_valid,cr_valid),'+
                         ' cr_srbfr=coalesce(:cr_srbfr,cr_srbfr),'+
                         ' company_id=coalesce(:company_id,company_id) '+
                         ' WHERE id=:id';
                         // rec_changed=?, rec_changedby=?, rec_addedby=?, rec_deletedby=?,rec_deleted=? pole vajadust uuendada



  // #########################################################################
  // DOKUMENDID
  // universaalne insert, ära seda seo konteerimisega ainult !!!
  // #########################################################################

  _CSQLInsertNewDoc = ' INSERT INTO documents(id, document_nr, document_date, document_type_id, sdescr, company_id, '+
                      ' rec_changed, rec_changedby, rec_addedby) '+
                      ' VALUES (:id,:document_nr,:document_date,:document_type_id,:sdescr,:company_id, '+
                      ' :rec_changed,:rec_changedby,:rec_addedby)';

  _CSQLInsertNewDoc2= ' INSERT INTO documents(document_nr, document_date, document_type_id, sdescr, company_id, '+
                      ' rec_changed, rec_changedby, rec_addedby) '+
                      ' VALUES (:document_nr,:document_date,:document_type_id,:sdescr,:company_id, '+
                      ' :rec_changed,:rec_changedby,:rec_addedby)  RETURNING *';


  // vana dokumendi kirje uuendamine
  // jätame coalescega võimaluse uuendada vaid ühte parameetrit ! NULLe ma enamus väljadel ei luba !!!
  _CSQLUpdateDoc    = ' UPDATE documents '+
                      ' SET  document_nr=coalesce(:document_nr,document_nr), document_date=coalesce(:document_date,document_date),'+
                      ' document_type_id=coalesce(:document_type_id,document_type_id), sdescr=coalesce(:sdescr,sdescr),'+
                      ' status=coalesce(:status,status),rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                      ' WHERE id=:id';

  _CSQLInsertDocFiles = ' INSERT INTO document_files(id,document_id, rec_nr, filename, size, md5, rawdoc,type_, company_id, '+
                        ' rec_changed, rec_changedby, rec_addedby) '+
                        ' VALUES (:id,:document_id,:rec_nr, :filename, :size, :md5, :rawdoc,:type_,:company_id,'+
                        ' :rec_changed, :rec_changedby, :rec_addedby)';

  _CSQLDeleteDocFile =  ' UPDATE document_files '+
                        ' SET rec_deleted=''t'','+
                        '     rec_changed=:rec_changed,'+
                        '     rec_changedby=:rec_changedby '+
                        ' WHERE id=:id '+
                        '   AND company_id=:company_id';

  _CSQLUpdateDocFiles = ' UPDATE document_files '+
                        ' SET rec_nr=COALESCE(:rec_nr,rec_nr),'+
                        '     filename=COALESCE(:filename,filename),'+
                        '     size=COALESCE(:size,size),'+
                        '     md5=COALESCE(:md5,md5),'+
                        '     rawdoc=COALESCE(:rawdoc,rawdoc),'+
                        '     type_=COALESCE(:type_,type_),'+
                        '     rec_changed=:rec_changed,'+
                        '     rec_changedby=:rec_changedby '+
                        ' WHERE id=:id';

  _CSQLSelectFile    = ' SELECT rawdoc,filename,size,rec_changed,rec_changedby,rec_addedby '+
                       ' FROM document_files '+
                       ' WHERE id=:id '+
                       '   AND company_id=:company_id '+
                       '   AND rec_deleted=''f''';

  _SQLSelectFilesByDocId = ' SELECT id as file_id,filename,size,md5 '+
                           ' FROM document_files '+
                           ' WHERE document_id=:document_id '+ // hetkel toetame vaid 1-1 seost, aga tulevikus võib mitu dokumenti lisada !
                           '   AND company_id=:company_id '+
                           '   AND rec_deleted=''f''';


  // #########################################################################

 _SQLSelectUndefDocClsId = ' SELECT id '+
                           ' FROM  classificators '+
                           ' WHERE shortidef=''UD'' and type_=''document_types''';

  // #########################################################################
  // KANDED
  // #########################################################################

 _CSQLInsertNewAccRegDoc = ' INSERT INTO accounting_register_documents(accounting_register_id, document_id, '+
                           ' rec_changed, rec_changedby,rec_addedby) '+
                           ' VALUES (:accounting_register_id,:document_id,:rec_changed,:rec_changedby,:rec_addedby)';




 _CSQLInsertNewAccDCRec = ' INSERT INTO accounting_records(id,accounting_register_id, account_id, '+
                          ' descr, rec_nr, rec_sum, rec_type, currency, currency_vsum,currency_id,'+
                          ' company_id,currency_drate_ovr, status, rec_changed, rec_changedby,rec_addedby,client_id) '+
                          ' VALUES (:id,:accounting_register_id,:account_id,'+
                          ' :descr,:rec_nr,:rec_sum,:rec_type,:currency,:currency_vsum,:currency_id,'+
                          ' :company_id,:currency_drate_ovr,:status,:rec_changed,:rec_changedby,:rec_addedby,:client_id)';

 // 29.08.2010 Ingmar; viitega kanded !
 _CSQLInsertNewAccDCRecEx= ' INSERT INTO accounting_records(id,accounting_register_id, account_id, '+
                           ' descr, rec_nr, rec_sum, rec_type, currency, currency_vsum,currency_id,'+
                           ' company_id,currency_drate_ovr, status, rec_changed, rec_changedby,rec_addedby,client_id,tr_partner_name, '+
                           ' ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag,ref_debt_flag,ref_tax_flag,flags) '+
                           ' VALUES (:id,:accounting_register_id,:account_id,'+
                           ' :descr,:rec_nr,:rec_sum,:rec_type,:currency,:currency_vsum,:currency_id,'+
                           ' :company_id,:currency_drate_ovr,:status,:rec_changed,:rec_changedby,:rec_addedby,:client_id,:tr_partner_name,'+
                           ' :ref_item_type,:ref_item_id,:ref_prepayment_flag,:ref_payment_flag,:ref_income_flag,:ref_debt_flag,:ref_tax_flag,:flags)';



 _CSQLInsertNewAccDCRecAttrb = ' INSERT INTO accounting_records_attrb(id, accounting_record_id, attrib_type, attrib_id, attrib_val,'+
                               ' rec_changed, rec_changedby, rec_addedby) '+
                               ' VALUES (:id,:accounting_record_id,:attrib_type,:attrib_id,:attrib_val,'+
                               ' :rec_changed,:rec_changedby,:rec_addedby)';

 // ilma ID'ta
 _CSQLInsertNewAccDCRecAttrb2= ' INSERT INTO accounting_records_attrb(accounting_record_id, attrib_type, attrib_id, attrib_val,'+
                                ' rec_changed, rec_changedby, rec_addedby) '+
                                ' VALUES (:accounting_record_id,:attrib_type,:attrib_id,:attrib_val,'+
                                ' :rec_changed,:rec_changedby,:rec_addedby)';


  // kontrollid pearaamatus
 _CSQLVerifyEntryNr = ' SELECT id,transdate '+
                      ' FROM accounting_register '+
                      ' WHERE entrynumber=:entrynumber AND '+
                      '   company_id=:company_id AND '+
                      '   archive_rec_id=0 AND '+
                      '   type_=''G''';  // G = pearaamatu kande tüüp


 _CSQLVerifyDocNr  = ' SELECT a.id,a.transdate,a.entrynumber '+
                     ' FROM accounting_register a,accounting_register_documents b,documents c'+
                     ' WHERE  a.company_id=:company_id '+
                     '  AND a.archive_rec_id=0 '+
                     '  AND b.accounting_register_id=a.id '+
                     '  AND c.id=b.document_id '+
                     '  AND c.document_nr=:document_nr '+
                     '  AND a.type_ not like ''C%''';




  // kontrollime ntx kande vastavust rp. perioodile
 _SQLCheckAccperiod  = ' SELECT id, name, period_start, period_end,status '+
                       ' FROM accounting_period '+
                       ' WHERE :accdate between period_start AND coalesce(period_end,period_start+999) '+
                       '  AND company_id=:company_id';
                       //' WHERE id=:id ';

  _SQLSelectAllAccPeriods = ' SELECT id, name, period_start, period_end,status '+
                            ' FROM accounting_period '+
                            ' WHERE company_id=:company_id '+
                            ' ORDER BY id DESC ';


  // #########################################################################
 // kande avamisel sooritatavad päringud; kanne ise; all kontod

 _SQLGetAccRegFullSelectExt = ' SELECT  a.entrynumber, a.transdescr,a.transdate,c.id as document_id, '+
                              ' c.document_nr as docnr,c.document_date as docdate, '+
                              ' f.id as doctypeid,f.name as doctypename,a.type_ as entrytype,a.template '+
                              ' FROM accounting_register a '+
                              ' INNER JOIN accounting_register_documents b ON '+
                              ' b.accounting_register_id=a.id '+
                              ' INNER JOIN documents c ON '+
                              ' c.id=b.document_id '+
                              ' LEFT OUTER JOIN classificators f ON '+
                              ' f.id=c.document_type_id AND f.type_=''document_types'' AND shortidef<>''UD'''+
                              ' WHERE a.id=:id '+
                              '  AND a.company_id=:company_id';

  // #########################################################################
  // OBJEKTID
  // #########################################################################
  // kas ka ainult firma põhised tüübid ?!?
  _CSQLObjectTypes      = ' SELECT id,name as objname '+
                          ' FROM classificators '+
                          ' WHERE type_=''object_types'''+
                          ' ORDER BY name ';
                          //' ORDER BY id ';


  _CSQLInsertObjType    = ' INSERT INTO classificators(id, parent, name, shortidef, type_, weight, company_id) '+
                          ' VALUES (:id, :parent, :objname, :shortidef,''object_types'' , :weight, :company_id)';


  _CSQLAllObjects       =  ' SELECT id,classificator_id, descr '+
                           ' FROM objects '+
                           ' WHERE company_id=:company_id '+
                           '   AND rec_deleted=''f'''+
                           ' ORDER BY descr asc ';


 _SQLGetAllObjectsExt = ' SELECT o.id,o.descr as objname,o.classificator_id as objtypeid, '+
                        ' c.name as objtype,o.rec_changed,o.company_id,o.rec_changedby,o.rec_addedby '+
                        ' FROM objects o '+
                        ' INNER JOIN classificators c ON '+
                        ' c.id=o.classificator_id '+
                        ' WHERE o.company_id=:company_id ' +
                        ' ORDER BY c.name,o.descr '; // sorteerime gruppide järgi


 _SQLInsertObject  = ' INSERT INTO objects(id, classificator_id, descr, company_id, rec_changed, rec_changedby,rec_addedby) '+
                     ' VALUES (:id,:objtypeid,:objname,:company_id,:rec_changed,:rec_changedby,:rec_addedby) ';


 _SQLUpdateObject  = ' UPDATE objects '+
                     ' SET classificator_id=:objtypeid, descr=:objname,'+
                     ' company_id=:company_id, rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                     ' WHERE id=:id ';



  // #########################################################################
  // kui avame kande, siis kande kirjed

  // 31.10.2009 ingmar; tegin ümber, et saaks ka annuleeritud kandekirjet avada
  // SQL viidud funktsiooni !
  //_SQLGetAccRecsFullSelect;

  // #########################################################################


 // kande reaga seotud objektid; eraldi päring
 _SQLGetAccObjFullSelect = ' SELECT a.id, a.accounting_record_id, a.attrib_type, a.attrib_id, '+
                           ' a.attrib_val,o.id as objid,o.classificator_id as objgrp,'+
                           ' a.attrib_type as objtypesc,o.descr as objname '+
                           ' FROM accounting_records_attrb a '+
                           ' INNER JOIN objects o ON '+
                           ' o.id=attrib_id '+
                           ' WHERE a.accounting_record_id=:accounting_record_id '+
                           '  AND  a.attrib_type=''O'' '+
                           ' ORDER BY a.id ';

 // #########################################################################
 // KLIENDID
 // #########################################################################
 // reserved1, reserved2, reserved3, reserved4 tulevikus kontod

 _SQLVerifyCustRegCode = 'SELECT id FROM client WHERE regnr=:regnr AND company_id=COALESCE(:company_id,company_id)';
 _SQLVerifyClientCode  = 'SELECT id FROM client WHERE client_code=:client_code AND company_id=COALESCE(:company_id,company_id)';


 _SQLInsertClient = ' INSERT INTO client(id,ctype,countrycode,name, middlename, lastname, regnr, county_id, '+
                      ' city_id, street_id, house_nr, apartment_nr, zipcode, phone, mobilephone, '+
                      ' fax, email, postal_addr, notes, type_, payment_duetime, '+
                      ' credit_limit, company_id, bank_account1,bank_id1,webpage, rec_changed, rec_changedby,'+
                      ' rec_addedby,srcval,client_code,vatnumber) '+
                      ' VALUES(:id,:ctype,:countrycode,:custname,:middlename,:lastname,:regnr,:county_id, '+
                      ' :city_id,:street_id,:house_nr,:apartment_nr,:zipcode,:phone,:mobilephone, '+
                      ' :fax,:email,:postal_addr,:notes,:type_,:payment_duetime, '+
                      ' :credit_limit,:company_id, :bank_accounts,:bank_id,:webpage, :rec_changed,'+
                      ' :rec_changedby, :rec_addedby,:srcval,:client_code,:vatnumber) '; // hetkel = kliendi kood ja ID tulevikus kliendi koodi saab muuta ! COMPABILITY !! varchar probleem !

 _SQLUpdateClient   = ' UPDATE client '+
                      ' SET ctype=:ctype, countrycode=:countrycode,name=:custname, middlename=:middlename, lastname=:lastname, regnr=:regnr,'+
                      ' county_id=:county_id, city_id=:city_id, street_id=:street_id, house_nr=:house_nr,notes=:notes, '+
                      ' apartment_nr=:apartment_nr,zipcode=:zipcode, phone=:phone, mobilephone=:mobilephone,'+
                      ' fax=:fax, email=:email, postal_addr=:postal_addr, type_=:type_, payment_duetime=:payment_duetime,'+
                      ' credit_limit=:credit_limit,  bank_account1=:bank_accounts,bank_id1=:bank_id,webpage=:webpage,'+
                      ' rec_changed=:rec_changed, rec_changedby=:rec_changedby,srcval=:srcval,client_code=:client_code,vatnumber=:vatnumber '+
                      ' WHERE id=:id';

 // -- kontaktisikud; ilma ID'ta !
 _SQLSelectClientCPersons = ' SELECT * '+
                            ' FROM client_contact_persons '+
                            ' WHERE client_id=:client_id '+
                            '   AND status NOT LIKE ''%D%'''+
                            '   AND rec_deleted=''f''';


 _SQLInsertClientCPersons2 = 'INSERT INTO client_contact_persons(client_id, cname, caddr, cphone, cemail, type_,'+
                             'status, rec_changed,rec_changedby, rec_addedby) '+
                             'VALUES(:client_id, :cname, :caddr, :cphone, :cemail, :type_,:status, '+
                             ':rec_changed,:rec_changedby, :rec_addedby)';

 _SQLUpdateClientCPersons =  'UPDATE client_contact_persons '+
                             'SET cname=COALESCE(:cname,cname), '+
                             '    caddr=COALESCE(:caddr,caddr), '+
                             '    cphone=COALESCE(:cphone,cphone), '+
                             '    cemail=COALESCE(:cemail,cemail), '+
                             '    type_=COALESCE(:type_,type_),'+
                             '    status=COALESCE(:status,status),'+
                             '    rec_changed=:rec_changed,'+
                             '    rec_changedby=:rec_changedby '+
                             'WHERE id=:id';

 _SQLDeleteClientCPersons =  ' UPDATE client_contact_persons '+
                             ' SET rec_changed=:rec_changed,'+
                             '     rec_deletedby=:rec_deletedby,'+
                             '     rec_deleted=''t'' '+
                             ' WHERE id=:id';


 // #########################################################################
 // ARTIKLID / TEENUSED; sõltub tüübist
 // #########################################################################

 // purchase_account_id = konto, kus võeti maha toote ostusumma
 // sale_account_id = toote müügist saadud tulu nö
 // expense_account = müügiga seotud kulud; mida iganes; ntx toote saatmisele kulu jne jne
 // barcode_def_id tuleb klassifikaatoritest !!!

 _SQLInsertArticle = ' INSERT INTO articles(id, code, name, unit, type_, vat_id,barcode_def_id,'+
                     ' barcode, ean_code, descr,dim_h,dim_l,dim_w, url, purchase_account_id, sale_account_id,'+
                     ' expense_account_id,status, archive_rec_id,arttype_id,disp_web_dir,'+
                     ' company_id, rec_changed, rec_changedby, rec_addedby) '+
                     ' VALUES (:id,:artcode,:artname,:unit,:arttype,COALESCE(:vat_id,0),:barcode_def_id,'+ // km id = 0, ntx ettemaksude puhul !
                     ' :barcode, :ean_code, :descr,:dim_h,:dim_l,:dim_w, :url, :purchase_account_id, :sale_account_id,:expense_account_id,'+
                     ' :status,:archive_rec_id,:arttype_id,COALESCE(:disp_web_dir,false),:company_id, :rec_changed, :rec_changedby, :rec_addedby)';
                     // reserved1;reserved2 jäetud täiendava konto info jaoks !!!

 _SQLUpdateArticles =  ' UPDATE articles '+
                       ' SET code=:artcode, name=:artname, unit=:unit, type_=:arttype, vat_id=COALESCE(:vat_id,0),'+ // km id = 0, ntx ettemaksude puhul !
                       ' barcode_def_id=:barcode_def_id, barcode=:barcode, ean_code=:ean_code,dim_h=:dim_h,dim_l=:dim_l,'+
                       ' dim_w=:dim_w,descr=:descr, url=:url, purchase_account_id=:purchase_account_id, sale_account_id=:sale_account_id,'+
                       ' expense_account_id=:expense_account_id,status=:status, archive_rec_id=:archive_rec_id,arttype_id=:arttype_id,'+
                       ' rec_changed=:rec_changed, rec_changedby=:rec_changedby, '+ // company_id=:company_id
                       ' disp_web_dir=COALESCE(:disp_web_dir,false) ' +
                       ' WHERE id=:id';


 _SQLVerifArtCode  =   ' SELECT id '+
                       ' FROM articles '+
                       ' WHERE code=:artcode '+
                       '   AND company_id=:company_id '+
                       '   AND rec_deleted=''f''';

 // 02.04.2011 Ingmar; viimase artikli kontod, lihtsustab sisestamist
 _SQLLastArticleAccounts = ' SELECT a.purchase_account_id,a.sale_account_id,a.expense_account_id '+
                           ' FROM articles a '+
                           ' WHERE a.company_id=:company_id '+
                           '   AND a.id=(SELECT max(a1.id) FROM articles a1 '+
                           '             WHERE a1.special_type_flags=0 AND '+
                           '                   a1.company_id=:company_id AND '+
                           '                   ((a1.sale_account_id>0) or (a1.purchase_account_id>0)) AND '+
                           '                   a1.status=''Y'') ';



 // ARTIKLITE HINNAKIRI
 _SQLGetLastActArticlePrice = ' SELECT id, price,discount_perc'+
                              ' FROM articles_price_table'+
                              ' WHERE article_id=:article_id'+
                              '   AND type_=:type_'+
                              '   AND ends IS NULL';

 _SQLInsertArticlePrice = ' INSERT INTO articles_price_table(id, article_id, price,discount_perc, '+
                          ' begins, ends, type_,prsource,warehouse_id, rec_changed, rec_changedby,rec_addedby) '+
                          ' VALUES (:id,:article_id,:price,:discount_perc,:begins,:ends,'+
                          ':type_,:prsource,:warehouse_id,:rec_changed,:rec_changedby,:rec_addedby)';

 _SQLUpdateArticlePrice0 = ' UPDATE articles_price_table '+
                           ' SET price=:price,discount_perc=:discount_perc, begins=:begins, ends=:ends,'+
                           ' type_=:type_,prsource=:prsource,warehouse_id=:warehouse_id,'+
                           ' rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                           ' WHERE id=:id';

  // vana hind  arhiivi...
 _SQLUpdateArticlePrice1 = ' UPDATE articles_price_table '+
                           ' SET ends=:ends, rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                           ' WHERE article_id=:article_id '+
                           '   AND type_=:type_';


 _SQLArtSelectInv = ' SELECT id, warehouse_id, article_id, current_quantity, status '+
                    ' FROM inventory '+
                    ' WHERE company_id=:company_id '+
                    '   AND warehouse_id=:warehouse_id '+
                    '   AND article_id=coalesce(:article_id,article_id)';

 _SQLCheckArticleUsage = ' SELECT b.bill_number as nr '+
                         ' FROM bills b '+
                         ' WHERE  b.id=(SELECT MAX(bp.bill_id) '+
                         ' FROM bill_lines bp '+
                         ' WHERE b.company_id=:company_id '+
                         '   AND bp.item_id=:article_id '+
                         '   AND bp.rec_deleted=''f'') '+
                         '   AND b.rec_deleted=''f'' '+
                         ' UNION '+
                         ' SELECT o.order_nr as nr '+
                         ' FROM orders o '+
                         ' WHERE  o.id=(SELECT MAX(bo.order_id) '+
                         ' FROM order_lines bo '+
                         ' WHERE o.company_id=:company_id '+
                         '   AND bo.item_id=:article_id '+
                         '   AND bo.rec_deleted=''f'') '+
                         '   AND o.rec_deleted=''f''';

  _SQLDeleteArticle  = ' UPDATE articles '+
                       ' SET code=COALESCE(:code,code),'+
                       '     rec_deleted=''t'','+
                       '     rec_deletedby=:rec_deletedby '+
                       ' WHERE id=:article_id '+
                       '   AND company_id=:company_id ';


 // laos kirjeldatud artiklid
 // märkus !!! hetkel current_quantity välja ei kasuta !!! see tuleb arvutada jooksvalt inventory_documents pealt !
 // trigger teha, mis seda arvutab.
 _SQLArtInventory = ' INSERT INTO inventory(id, warehouse_id, article_id, current_quantity,'+
                    ' status,company_id, rec_changed,rec_changedby, rec_addedby) '+
                    ' VALUES(:id, :warehouse_id, :article_id, :current_quantity, :status,:company_id,'+
                    ' :rec_changed,:rec_changedby,:rec_addedby)';


 _SQLArtInventoryDoc = ' INSERT INTO inventory_documents(id, inventory_id, price,'+
                       ' document_id, quantity, status,rec_changed, rec_changedby, rec_addedby)'+
                       ' VALUES (:id, :inventory_id, :price,:document_id,:quantity,:status,'+
                       ' :rec_changed, :rec_changedby, :rec_addedby)';

  // ntx
 _SQLArtUpdtInvDoc   = ' UPDATE inventory_documents '+
                       ' SET  quantity=:quantity,price=:price,'+
                       ' status=:status,rec_changed=:rec_changed, rec_changedby=:rec_changedby '+
                       ' WHERE id=:id ';


 _SQLArtUpdtInvDoc2  = ' UPDATE inventory_documents '+
                       ' SET  quantity=quantity-(:quantity),price=:price,'+
                       ' status=coalesce(:status,status),rec_changed=:rec_changed, rec_changedby=:rec_changedby '+
                       ' WHERE inventory_id=:inventory_id';



 // ntx arve annuleeriti
 _SQLArtDelInvDoc    = ' UPDATE inventory_documents '+
                       ' SET  quantity=-quantity,status=''D'','+
                       ' rec_changed=:rec_changed, rec_changedby=:rec_changedby '+
                       ' WHERE document_id=:document_id';


 _SQLSelectInvDocId  = ' SELECT id,status '+
                       ' FROM inventory_documents '+
                       ' WHERE inventory_id=:inventory_id '+
                       '   AND document_id=:document_id '+
                       '   AND NOT status LIKE ''%D%''';

 // #########################################################################
 // ARVED/READ; //' a.purch_billnr, a.purch_billdate,a.purch_billdue_date,'+
 // #########################################################################

 _SQLSelectBillType      = ' SELECT  bill_type'+
                           ' FROM bills '+
                           ' WHERE id=:id';

 _SQLSelectBillMainRec   = ' SELECT  a.id,  a.client_id,  a.bill_number,  a.bill_date,'+
                           ' a.billing_addr2, a.bill_type, a.descr, a.due_date,'+
                           ' a.overdue_perc, a.totalsum,a.roundsum,a.vatsum,a.uprepaidsum,a.prepaidsum,a.incomesum,'+
                           ' a.currency, a.accounting_register_id,a.dc_account_id,'+ // a.roundsum
                           ' a.status, a.openedby, a.closedby, '+ // a.order_id, a.offer_id,
                           ' a.rec_changed, a.rec_changedby, a.rec_addedby '+
                           ' FROM bills a'+
                           ' LEFT OUTER JOIN client c ON '+
                           ' c.id=a.client_id '+
                           ' WHERE a.id=:id '+
                           '   AND a.company_id=:company_id '+
                           '   AND NOT a.status LIKE ''%D%''';

 _SQLInsertBillMainRec   = ' INSERT INTO bills(id, client_id, bill_number, bill_date, billing_addr2, bill_type, descr, due_date, '+
                           ' overdue_perc, totalsum,vatsum,vatsum2,roundsum, currency,currency_id,currency_drate_ovr, accounting_register_id,dc_account_id,vat_flags,credit_bill_id, '+
                           ' status,openedby,closedby,company_id,paymentterm, rec_changed, rec_changedby, rec_addedby,ref_nr,ref_nr_id)'+ // order_id, offer_id,
                           ' VALUES (:id, :client_id, :bill_number, :bill_date,:billing_addr2, :bill_type, :descr, :due_date,'+
                           ' :overdue_perc, :totalsum,:vatsum,:vatsum2,:roundsum, :currency,:currency_id,:currency_drate_ovr, :accounting_register_id,'+
                           ' :dc_account_id,:vat_flags,:credit_bill_id,:status, :openedby, :closedby,:company_id,'+
                           ' :paymentterm,:rec_changed, :rec_changedby, :rec_addedby,:ref_nr,:ref_nr_id)'; // :order_id, :offer_id,

 // wb service tarbeks
  _SQLInsertBillMainRec2  = ' INSERT INTO bills(client_id, bill_number, bill_date, billing_addr2, bill_type, descr, due_date, '+
                            ' overdue_perc, totalsum,vatsum,vatsum2,roundsum, currency,currency_id,currency_drate_ovr, accounting_register_id,dc_account_id,vat_flags,credit_bill_id, '+
                            ' status,openedby,closedby,company_id,paymentterm, rec_changed, rec_changedby, rec_addedby,ref_nr,ref_nr_id)'+ // order_id, offer_id,
                            ' VALUES (:client_id, :bill_number, :bill_date,:billing_addr2, :bill_type, :descr, :due_date,'+
                            ' :overdue_perc, :totalsum,:vatsum,:vatsum2,:roundsum, :currency,:currency_id,:currency_drate_ovr, :accounting_register_id,'+
                            ' :dc_account_id,:vat_flags,:credit_bill_id,:status, :openedby, :closedby,:company_id,'+
                            ' :paymentterm,:rec_changed, :rec_changedby, :rec_addedby,:ref_nr,:ref_nr_id) '+
                            ' RETURNING *';


  _SQLUpdateBillMainRec   = ' UPDATE bills '+
                            ' SET client_id=coalesce(:client_id,client_id), '+
                            ' bill_number=coalesce(:bill_number,bill_number), '+
                            ' bill_date=coalesce(:bill_date,bill_date),'+
                            ' billing_addr2=coalesce(:billing_addr2,billing_addr2),'+
                            ' descr=coalesce(:descr,descr),'+
                            ' due_date=coalesce(:due_date,due_date),'+
                            ' paymentterm=coalesce(:paymentterm,paymentterm),'+
                            ' overdue_perc=coalesce(:overdue_perc,overdue_perc),'+
                            ' openedby=coalesce(:openedby,openedby),'+
                            ' closedby=coalesce(:closedby,closedby),'+
                            ' totalsum=:totalsum,'+
                            ' vatsum=:vatsum,'+
                            ' vatsum2=:vatsum2,'+
                            ' roundsum=:roundsum,'+
                            ' status=:status,'+      // peavad olema !!!
                            ' currency=coalesce(:currency,currency),'+
                            ' currency_id=coalesce(:currency_id,currency_id),'+
                            ' currency_drate_ovr=coalesce(:currency_drate_ovr,currency_drate_ovr),'+
                            ' vat_flags=coalesce(:vat_flags,vat_flags),'+
                            ' credit_bill_id=coalesce(:credit_bill_id,credit_bill_id),'+
                            ' dc_account_id=coalesce(:dc_account_id,dc_account_id),'+
                            ' ref_nr=:ref_nr,'+
                            ' ref_nr_id=:ref_nr_id,'+
                            ' rec_changed=:rec_changed,'+
                            ' rec_changedby=:rec_changedby '+
                            ' WHERE id=:id';

   // 30.01.2010 Ingmar
  _SQLUpdateBillCredBillLink = ' UPDATE bills '+
                               ' set credit_bill_id=:credit_bill_id,rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                               ' WHERE id=:bill_id';


  _SQLSelectCrBillSource = ' SELECT id as source_bill_id,bill_type,accounting_register_id,totalsum,roundsum,vatsum,'+
                           ' incomesum,prepaidsum,uprepaidsum,payment_status,status,currency,currency_drate_ovr '+
                           ' FROM bills '+
                           ' WHERE  credit_bill_id=:credit_bill_id '+
                           '     AND rec_deleted=''f''';

   // 02.08.2011 Ingmar; trigger fix
   _SQLFixTriggerPaymentStatusBug = ' UPDATE bills '+
                                    ' SET payment_status='''' '+
                                    ' WHERE id=:id '+
                                    '   AND (incomesum+prepaidsum+uprepaidsum)=0.00';


  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // selgitus; unprepaidsum on ettemaksu osa, mis ära kasutati arve tasumisel varasematest ettemaksudest

  _SQLUpdateBillPmtData = ' UPDATE bills '+
                          ' SET incomesum=incomesum+COALESCE(:incomesum,0), '+
                          '     prepaidsum=prepaidsum+COALESCE(:prepaidsum,0), '+
                          '     uprepaidsum=uprepaidsum+COALESCE(:uprepaidsum,0), '+
                          // '     payment_status=COALESCE(:payment_status,payment_status), '+
                          '     payment_date=COALESCE(:payment_date,payment_date) '+
                          ' WHERE id=:id '+
                          '   AND NOT status LIKE ''%D%''';


  _SQLUpdateBillPmtData2= ' UPDATE bills '+
                          ' SET incomesum=COALESCE(:incomesum,incomesum), '+
                          '     prepaidsum=COALESCE(:prepaidsum,prepaidsum), '+
                          '     uprepaidsum=COALESCE(:uprepaidsum,uprepaidsum), '+
                          '     crprepaidsum=COALESCE(:crprepaidsum,crprepaidsum), '+  // ehk hoiame meeles ettemaksu summat, mis tõsteti üles kui tehti kreeditarve !!!
                          '     payment_status=COALESCE(:payment_status,payment_status), '+
                          '     payment_date=COALESCE(:payment_date,payment_date) '+
                          ' WHERE id=:id '+
                          '   AND NOT status LIKE ''%D%''';

  // -- lihtsustatud SQL; võiks ka eelmist kasutada, aga eelistan siiski neid lahus hoida !
  _SQLUpdateCrBillRaisedPrepaymentRec = ' UPDATE bills '+
                                        ' SET crprepaidsum=:crprepaidsum '+
                                        ' WHERE id=:id '+
                                        '   AND NOT status LIKE ''%D%''';

  _SQLUpdateAccEntBillLine = ' UPDATE bill_lines '+
                             //' SET accounting_record_id=coalesce(:accounting_record_id,accounting_record_id),'+ 17.02.2010 Ingmar
                             ' SET '+
                             ' discount_perc=coalesce(:discount_perc,discount_perc),'+
                             ' cust_discount_id=coalesce(:cust_discount_id,cust_discount_id),'+
                             ' item_price=coalesce(:item_price,item_price),'+
                             ' item_account_id=coalesce(:item_account_id,item_account_id),'+
                             ' quantity=coalesce(:quantity,quantity),'+
                             ' total=:total,'+
                             ' vat_id=coalesce(:vat_id,vat_id),'+
                             ' vat_account_id=coalesce(:vat_account_id,vat_account_id),'+
                             ' vat_rsum=coalesce(:vat_rsum,vat_rsum),'+
                             ' descr2=coalesce(:descr2,descr2),'+
                             ' unit2=coalesce(:unit2,unit2),'+
                             ' object_id=coalesce(:object_id,object_id),'+
                             ' rec_changed=:rec_changed,'+
                             ' rec_changedby=:rec_changedby, '+
                             ' vat_cperc=:vat_cperc '+
                             ' WHERE id=:id ';


  // accounting_record_id
  _SQLInsertBillLine  = 'INSERT INTO bill_lines(id, bill_id, linetype, discount_perc, cust_discount_id,'+
                        'item_id, item_price, quantity, total, vat_id, vat_account_id,vat_rsum, descr2, unit2,'+
                        'item_account_id,object_id, company_id,status, rec_changed, rec_changedby, rec_addedby,vat_cperc)'+
                        'VALUES(:id, :bill_id, :linetype, :discount_perc, :cust_discount_id,'+
                        ':item_id, :item_price, :quantity, :total, :vat_id,:vat_account_id,:vat_rsum, :descr2, :unit2,'+
                        ':item_account_id,:object_id, :company_id,:status, :rec_changed, :rec_changedby, :rec_addedby,:vat_cperc)';

  // veebiteenus kasutab seda !
  _SQLInsertBillLine2 = 'INSERT INTO bill_lines(bill_id, linetype, discount_perc, cust_discount_id,'+
                        'item_id, item_price, quantity, total, vat_id, vat_account_id,vat_rsum, descr2, unit2,'+
                        'item_account_id,object_id, company_id,status, rec_changed, rec_changedby, rec_addedby)'+
                        'VALUES(:bill_id, :linetype, :discount_perc, :cust_discount_id,'+
                        ':item_id, :item_price, :quantity, :total, :vat_id,:vat_account_id,:vat_rsum, :descr2, :unit2,'+
                        ':item_account_id,:object_id, :company_id,:status, :rec_changed, :rec_changedby, :rec_addedby)';


  _SQLDeleteBillLine = ' UPDATE bill_lines '+
                       ' SET status=''D'', rec_changed=:rec_changed, rec_deletedby=:rec_deletedby,rec_changedby=:rec_changedby '+
                       ' WHERE id=:bill_lineid';


  // tellimusest ettemaksuarve tegemine
  _SQLSelectOrderLastCPmtOrder = 'SELECT o.payment_nr,o.payment_date,p.splt_sum as isum, o.currency_id,o.currency,o.currency_drate_ovr '+
                                ' FROM payment o '+
                                ' INNER JOIN payment_data p ON '+
                                ' p.payment_id=o.id AND p.item_type=:item_type AND  p.item_id=:item_id AND p.status NOT LIKE ''%D%'''+
                                ' WHERE (o.id=p.payment_id) '+
                                '  AND  (o.rec_deleted=''f'')'+
                                '  AND  (o.status NOT LIKE ''%D%'')'+
                                '  AND  (o.status LIKE ''%C%'')'+
                                //'  AND  (o.payment_confirmed=''t'')'+
                                '  AND o.id=(SELECT MAX(o1.id) '+
                                '            FROM payment_data p1 '+
                                '            INNER JOIN  payment o1 ON '+
                                '            (o1.id=p1.payment_id)   AND '+
                                '            (o1.rec_deleted=''f'') AND '+
                                '            (o1.status NOT LIKE ''%D%'') AND '+
                                //'            (o1.payment_confirmed=''t'')'+
                                '            (o1.status LIKE ''%C%'') '+
                                '            WHERE p1.item_type=:item_type'+
                                '             AND  p1.item_id=:item_id'+
                                '             AND  p1.status NOT LIKE ''%D%'')';

  _SQLDoesBillExists = ' SELECT id,bill_date,bill_number '+
                       ' FROM bills '+
                       ' WHERE company_id=:company_id '+
                       '   AND bill_type=:bill_type '+
                       '   AND bill_number=:bill_number '+
                       '   AND client_id=:client_id '+ // 30.08.2011 Ingmar; bugi ! Klienti polnud !
                       '   AND rec_deleted=''f'''+
                       ' ORDER BY id DESC ';

   // et korrigeerida kanneteta arvete probleemi
   _SQLUpdateBillAccRegID = ' UPDATE bills '+
                            ' SET accounting_register_id=:accounting_register_id '+
                            ' WHERE company_id=:company_id '+
                            '   AND id=:id';

  // #########################################################################
  // PANGAKONTOD
  // #########################################################################

  _SQLInsertBank        = ' INSERT INTO banks(id, name, lcode, swift, company_id, rec_changed, rec_changedby, rec_addedby)'+
                          ' VALUES (:id,:bankname,:lcode,:swift,:company_id, :rec_changed, :rec_changedby, :rec_addedby)';

  _SQLUpdateBank        = ' UPDATE banks '+
                          ' SET name=:bankname, lcode=:lcode, swift=:swift,'+
                          ' rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                          ' WHERE id=:id';

  _SQLSelectBanks        = ' SELECT id, name as bankname, lcode, swift, company_id, rec_changed, rec_changedby, rec_addedby '+
                           ' FROM banks '+
                           ' WHERE company_id=:company_id '+
                           ' ORDER BY name ASC ';

  // et pank on ka raamatupidamise kontoga seotud
  _SQLSelectBanksEx      = ' SELECT b.id, b.name as bankname, b.lcode, b.swift, b.company_id, b.rec_changed, b.rec_changedby, b.rec_addedby '+
                           ' FROM banks b '+
                           ' WHERE b.company_id=:company_id '+
                           '   AND b.rec_deleted=''f'''+
                           '   AND EXISTS(SELECT * '+
                           '              FROM    accounts a '+
                           '              WHERE   a.bank_id=b.id '+
                           '                AND   a.rec_deleted=''f'' '+
                           '                AND   a.flags=0 '+  // ohtlik koht ! Tulevikus pane bitmask paika, et konto ei tohi olla suletud !
                           '                AND ((a.account_nr<>'''') or (a.account_nr_iban<>''''))'+
                           '                AND a.company_id=b.company_id) '+
                           ' ORDER BY b.name ASC ';


  // #########################################################################
  // LADU
  // #########################################################################

  _SQLSelectWarehouse  = ' SELECT id, code as warehousecode, name as warehousename, vatnumber,'+
                         ' countrycode, county_id, city_id, street_id, house_nr, apartment_nr,zipcode,postal_addr, '+
                         ' phone, mobile, email, head,opening_times, descr, price_calc_meth, '+
                         ' charge_account_id, revenue_account_id,company_id, status, rec_changed,rec_changedby, rec_addedby '+
                         ' FROM warehouse '+
                         ' WHERE company_id=:company_id '+
                         ' ORDER BY id ';

  _SQLInsertWarehouse = ' INSERT INTO warehouse(id, code, "name", vatnumber, countrycode, county_id, city_id,'+
                        ' street_id, house_nr, apartment_nr,zipcode, postal_addr, phone, mobile, email, head,'+
                        ' opening_times, descr, price_calc_meth, charge_account_id, revenue_account_id,'+
                        ' company_id, status, rec_changed, rec_changedby, rec_addedby) '+
                        ' VALUES(:id, :warehousecode, :warehousename, :vatnumber, :countrycode, :county_id, :city_id,'+
                        ' :street_id, :house_nr, :apartment_nr,:zipcode,:postal_addr, :phone, :mobile, :email, :head,'+
                        ' :opening_times, :descr, :price_calc_meth, :charge_account_id, :revenue_account_id,'+
                        ' :company_id, :status, :rec_changed, :rec_changedby, :rec_addedby) ';

  _SQLUpdateWarehouse = ' UPDATE warehouse '+
                        ' SET code=:warehousecode, name=:warehousename, vatnumber=:vatnumber,countrycode=:countrycode,'+
                        ' county_id=:county_id,city_id=:city_id, street_id=:street_id, house_nr=:house_nr, '+
                        ' apartment_nr=:apartment_nr, phone=:phone,mobile=:mobile, email=:email, head=:head, '+
                        ' opening_times=:opening_times, descr=:descr, price_calc_meth=:price_calc_meth,'+
                        ' charge_account_id=:charge_account_id, revenue_account_id=:revenue_account_id,status=:status,'+
                        ' rec_changed=:rec_changed, rec_changedby=:rec_changedby,'+
                        ' zipcode=:zipcode, postal_addr=:postal_addr '+
                        ' WHERE id=:id';

  _SQLCheckWarehouseCN = ' SELECT a.id,1 as item '+
                         ' FROM warehouse a '+
                         ' WHERE a.company_id=:company_id '+
                         '   AND a.code=:warehousecode '+
                         '   AND a.id<>:id '+
                         ' UNION '+
                         ' SELECT b.id,2 as item '+
                         ' FROM warehouse b '+
                         ' WHERE b.company_id=:company_id '+
                         '   AND b.name=:warehousename '+
                         '   AND b.id<>:id ';


  // #########################################################################
  // TELLIMUS
  // #########################################################################

  _SQLInsertOrder = ' INSERT INTO orders(id, order_nr, order_date, order_type,order_prp_due_date, order_prp_perc,'+
                    ' rel_delivery_date, client_id,warehouse_id, descr, countrycode, county_id, city_id, street_id,'+
                    ' house_nr, apartment_nr, zipcode, phone, mobilephone, fax, email, '+
                    ' contact, order_channel_id, order_channel,order_ccperson_id, order_ccperson, order_senddate,'+
                    ' order_confdate, transport_type_id, delivery_statment_id, delivered_by, '+
                    ' delivered_date, delivery_accept_date, delivery_accept_by,template,order_sum,order_vatsum, '+
                    ' status,saleperson_id, company_id, rec_changed, rec_changedby, rec_addedby,currency,currency_drate_ovr) '+
                    ' VALUES(:id, :order_nr, :order_date, :order_type,:order_prp_due_date, :order_prp_perc,'+
                    ' :rel_delivery_date, :client_id,:warehouse_id, :descr, :countrycode, :county_id, :city_id, :street_id,'+
                    ' :house_nr, :apartment_nr, :zipcode, :phone, :mobilephone,:fax, :email, '+
                    ' :contact, :order_channel_id, :order_channel,:order_ccperson_id, :order_ccperson, :order_senddate,'+
                    ' :order_confdate, :transport_type_id, :delivery_statment_id, :delivered_by, '+
                    ' :delivered_date, :delivery_accept_date, :delivery_accept_by,:template,:order_sum,:order_vatsum, '+
                    ' :status,:saleperson_id, :company_id, :rec_changed, :rec_changedby, :rec_addedby,:currency,:currency_drate_ovr)';

  _SQLUpdateOrder = ' UPDATE orders '+
                    ' SET order_date=:order_date, order_prp_due_date=:order_prp_due_date,'+
                    ' order_prp_perc=:order_prp_perc, rel_delivery_date=:rel_delivery_date, '+
                    ' client_id=:client_id, warehouse_id=:warehouse_id, descr=:descr, '+
                    ' countrycode=:countrycode, county_id=:county_id, city_id=:city_id, '+
                    ' street_id=:street_id, house_nr=:house_nr, apartment_nr=:apartment_nr, '+
                    ' zipcode=:zipcode, phone=:phone, mobilephone=:mobilephone, fax=:fax, email=:email, '+
                    ' contact=:contact, order_channel_id=:order_channel_id, order_channel=:order_channel, '+
                    ' order_ccperson_id=:order_ccperson_id,order_ccperson=:order_ccperson,order_senddate=:order_senddate, order_confdate=:order_confdate,'+
                    ' transport_type_id=:transport_type_id, delivery_statment_id=:delivery_statment_id,'+
                    ' delivered_by=:delivered_by, delivered_date=:delivered_date, delivery_accept_date=:delivery_accept_date,'+
                    ' delivery_accept_by=:delivery_accept_by,template=:template,order_sum=:order_sum,order_vatsum=:order_vatsum,'+
                    ' status=:status,saleperson_id=:saleperson_id,'+
                    ' rec_changed=:rec_changed, rec_changedby=:rec_changedby, '+
                    ' currency=:currency,currency_drate_ovr=:currency_drate_ovr '+ // 17.02.2011 Ingmar
                    ' WHERE id=:id';



   // order_sum=order_sum+COALESCE(:order_sum,0), '+
   _SQLUpdateOrderPmtData2= ' UPDATE orders '+
                            ' SET paid_sum=paid_sum+COALESCE(:paid_sum,0) '+ // '     payment_status=COALESCE(:payment_status,payment_status) '+ 31.03.2011 Ingmar
                            ' WHERE id=:id ';


   _SQLSelectOrderChannel = ' SELECT id,shortidef as idtype,name as chname '+
                            ' FROM classificators '+
                            ' WHERE type_=''order_chtypes'''+
                            ' ORDER BY id ';

   _SQLInsertOrderLines = ' INSERT INTO order_lines(id, order_id, item_id, quantity, price, price2,vat_id,vat_perc,'+
                          ' vat_account_id,vat_rsum,descr, unit, partcode, status, rec_changed, rec_changedby, rec_addedby)'+
                          ' VALUES(:id,:order_id,:item_id,:quantity,:price,:price2,:vat_id,:vat_perc,:vat_account_id,:vat_rsum,'+
                          ' :descr, :unit, :partcode, :status, :rec_changed, :rec_changedby, :rec_addedby)';

   _SQLUpdateOrderLines = ' UPDATE order_lines '+
                          ' SET item_id=:item_id, quantity=:quantity, price=:price, price2=:price2,vat_id=:vat_id,vat_perc=:vat_perc,'+
                          ' vat_account_id=:vat_account_id,vat_rsum=:vat_rsum,'+
                          ' descr=:descr, unit=:unit, partcode=:partcode, status=:status, rec_changed=:rec_changed,'+
                          ' rec_changedby=:rec_changedby '+
                          ' WHERE id=:id';

   _SQLDeleteOrderLine  = ' UPDATE order_lines '+
                          ' SET status=''D'', rec_changed=:rec_changed,rec_deletedby=:rec_deletedby,rec_deleted=''t'' '+
                          ' WHERE id=:id';


   // c.name as cfname,c.middlename as cfmname,c.lastname as cflname, '+
   // c.regnr as cfregnr, c.phone as cfphone,c.email as cfemail,c.webpage as cfwebpage,
   _SQLSelectOrder      = ' SELECT o.id, o.order_nr, o.order_date, o.order_type,'+
                          ' o.offer_id, o.order_prp_due_date, o.order_prp_perc, o.rel_delivery_date,'+
                          ' o.client_id,o.warehouse_id, o.descr, o.countrycode, o.county_id, o.city_id,'+ // !! customerid siin on pigem hankija !
                          ' o.street_id, o.house_nr, o.apartment_nr, o.zipcode, o.phone, o.mobilephone,'+
                          ' o.order_sum,o.order_roundsum,o.order_vatsum,o.paid_sum,o.currency,o.currency_id,o.currency_drate_ovr,'+
                          ' o.fax, o.email, o.contact, o.order_channel_id, o.order_channel, o.order_ccperson,o.order_ccperson_id,'+
                          ' o.order_senddate, o.order_confdate, o.transport_type_id, o.delivery_statment_id,'+
                          ' o.delivered_by, o.delivered_date, o.delivery_accept_date, o.delivery_accept_by,'+
                          ' o.template, o.status,o.saleperson_id, o.company_id, o.rec_changed, o.rec_changedby, o.rec_addedby '+
                          ' FROM orders  o '+
                          ' LEFT OUTER JOIN client c ON '+
                          ' c.id=o.client_id '+
                          ' WHERE o.id=:id '+
                          '   AND o.company_id=:company_id';


   _SQLSelectOrderLines = ' SELECT l.id, l.item_id,a.code as item_code,l.partcode, l.quantity, l.price, l.price2, '+
                          ' l.descr, l.unit, l.partcode,l.vat_id,l.vat_account_id,l.vat_rsum,'+
                          ' v.perc as vat_perc,v.description as vat_descr,v.flags as vat_flags,l.status,l.rec_changed,l.rec_changedby '+
                          ' FROM order_lines l'+
                          ' LEFT OUTER JOIN articles a ON '+
                          ' a.id=l.item_id AND NOT a.type_ in ('''+CArtSpTypeCode_Prepayment+''','''+CArtSpTypeCode_Fine+''') '+ // 07.04.2011 Ingmar
                          ' LEFT OUTER JOIN vat v ON '+
                          ' v.id=l.vat_id '+
                          ' WHERE order_id=:order_id'+
                          '   AND l.status NOT LIKE ''%D%'''+
                          ' ORDER BY l.id ASC ';



   // INFO
   // 18.08.2010 Ingmar; saame jälgida tellimuse tasumist !!!
   _SQLSelectOrderPmtData = ' SELECT p.account_id,p.splt_sum as isum, '+
                            ' o.payment_nr,o.payment_date,o.document_nr,'+ // o.payment_confirmed,
                            ' o.currency_id,o.currency,o.currency_drate_ovr,o.status '+
                            ' FROM payment_data p '+
                            ' INNER JOIN payment o ON '+
                            ' p.payment_id=o.id '+
                            ' WHERE p.item_type=:item_type '+
                            '  AND  p.item_id=:item_id '+
                            '  AND  p.status NOT LIKE ''%D%'''+
                            '  AND  o.rec_deleted=''f'''+
                            '  AND  o.status NOT LIKE ''%D%''';





   // info, kus  hoiame into tellimusega seotud maksete kohta !!!
   _SQLInsertOrderBillingData = ' INSERT INTO order_billing_data(order_id, item_type, item_id, status) '+
                                ' VALUES (:order_id,:item_type,:item_id, :status)';

   _SQLInsertOrderBillingDataEx= ' INSERT INTO order_billing_data(order_id, item_type, item_id, status) '+
                                 ' SELECT :order_id,:item_type,:item_id, :status '+
                                 ' FROM __int_systemtypes d '+
                                 ' WHERE d.bbool=''t'''+
                                 '  AND NOT EXISTS(SELECT d.id '+
                                 '                 FROM order_billing_data d '+
                                 '                 WHERE d.item_type=:item_type '+
                                 '                   AND d.status NOT LIKE  ''%D%'''+
                                 '                   AND d.item_id=:item_id) ';


   _SQLUpdateOrderBillingData = ' UPDATE order_billing_data '+
                                ' SET status=:status '+
                                ' WHERE order_id=:order_id '+
                                '   AND item_type=:item_type '+
                                '   AND item_id=:item_id ';


  // #########################################################################
  // MAKSEKORRALDUS / KASSA
  // #########################################################################

    // p.document_nr = d.document_id !
    _SQLSelectPayment = ' SELECT p.id, p.payment_type, p.document_nr,d.document_type_id, p.c_account_id, p.d_account_id, p.payer_account_nr,'+
                        ' p.payment_rcv_name,p.payment_rcv_account_nr, p.payment_rcv_bank_id, '+
                        ' p.payment_rcv_bank, p.payment_rcv_refnr, p.payment_rcv_account_nr,'+
                        ' p.client_id,p.client_name2, p.optype, p.accounting_register_id,p.sumtotal,p.trcost, '+
                        ' p.currency,p.currency_drate_ovr,p.payment_nr,p.payment_date, '+
                        ' p.descr, p.status, p.company_id, p.rec_changed, p.rec_changedby, p.rec_addedby '+
                        ' FROM payment p '+
                        ' LEFT OUTER JOIN accounting_register_documents r ON '+
                        ' r.accounting_register_id=p.accounting_register_id '+
                        ' LEFT OUTER JOIN documents d ON '+
                        ' d.id=r.document_id AND d.rec_deleted=''f'' '+
                        ' WHERE p.id=:id '+
                        '   AND p.payment_type=:payment_type '+
                        '   AND p.company_id=:company_id'; // ' payment_confirmed,  payment_confdate, '+

    // tellimuse tasumise info !
    _SQLSelectOrderPmtData2 = ' SELECT p.account_id,p.splt_sum,p.item_id,p.item_type '+
                              ' FROM payment_data p '+
                              ' WHERE p.payment_id=:payment_id '+
                              '  AND  p.status NOT LIKE ''%D%''';




   // payment_confirmed
   // TASUMINE
   _SQLInsertPayment = ' INSERT INTO payment(id, payment_type, document_nr, c_account_id, d_account_id, payer_account_nr,'+
                       ' payment_rcv_name, payment_rcv_bank_id, payment_rcv_bank, payment_rcv_refnr,payment_rcv_account_nr,'+
                       ' client_id, optype,sumtotal,trcost, accounting_register_id, currency,currency_drate_ovr,payment_nr,payment_date,'+
                       ' descr, status, company_id, rec_changed, rec_changedby, rec_addedby)'+
                       ' VALUES(:id, :payment_type, :document_nr, :c_account_id, :d_account_id, :payer_account_nr,'+
                       ' :payment_rcv_name, :payment_rcv_bank_id, :payment_rcv_bank, :payment_rcv_refnr,:payment_rcv_account_nr,'+
                       ' :client_id, :optype,:sumtotal,:trcost, :accounting_register_id, :currency,:currency_drate_ovr,:payment_nr,:payment_date,'+
                       ' :descr, :status, :company_id, :rec_changed, :rec_changedby, :rec_addedby)';

   // KASSA !
   _SQLInsertPayment2= ' INSERT INTO payment(id, payment_type, document_nr, c_account_id, d_account_id, '+
                       ' payment_rcv_bank_id,payment_rcv_account_nr,client_id,client_name2, optype,sumtotal,trcost, '+
                       ' accounting_register_id, currency,payment_nr,payment_date,'+
                       ' descr, status, company_id, rec_changed, rec_changedby, rec_addedby)'+
                       ' VALUES(:id, :payment_type, :document_nr, :c_account_id, :d_account_id,'+
                       ' :payment_rcv_bank_id,:payment_rcv_account_nr,:client_id,:client_name2, :optype,'+
                       ' :sumtotal,:trcost, :accounting_register_id, :currency,:payment_nr,:payment_date,'+
                       ' :descr, :status, :company_id, :rec_changed, :rec_changedby, :rec_addedby)';


  //' payment_confirmed=:payment_confirmed '+
  // TASUMINE
  _SQLUpdatePayment = ' UPDATE payment '+ // direction=:direction,
                      ' SET  document_nr=:document_nr, c_account_id=:c_account_id, d_account_id=:d_account_id,'+
                      ' payer_account_nr=:payer_account_nr, payment_rcv_name=:payment_rcv_name, payment_rcv_bank_id=:payment_rcv_bank_id,'+
                      ' payment_rcv_bank=:payment_rcv_bank, payment_rcv_refnr=:payment_rcv_refnr,payment_rcv_account_nr=:payment_rcv_account_nr,'+
                      ' client_id=:client_id, optype=:optype,sumtotal=:sumtotal,trcost=:trcost,'+
                      ' accounting_register_id=coalesce(:accounting_register_id,accounting_register_id),payment_date=:payment_date,'+
                      ' currency=:currency,currency_drate_ovr=:currency_drate_ovr, descr=:descr, status=:status,rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                      ' WHERE id=:id';

  // KASSA; ei kasutata payment_rcv_name
  // payment_rcv_account_nr=:payment_rcv_account_nr vajalik siiski kande jaoks

  // Raha laekumine kassasse pangast
  // D kassa K pank
  // ja
  // Raha kassast panka
  // D pank K kassa
  _SQLUpdatePayment2= ' UPDATE payment '+ // direction=:direction,
                      ' SET  document_nr=:document_nr, c_account_id=:c_account_id, d_account_id=:d_account_id,'+
                      ' client_id=:client_id,client_name2=:client_name2, optype=:optype,sumtotal=:sumtotal,trcost=:trcost,'+
                      ' accounting_register_id=coalesce(:accounting_register_id,accounting_register_id),payment_date=:payment_date,'+
                      ' payment_rcv_bank_id=:payment_rcv_bank_id,payment_rcv_account_nr=:payment_rcv_account_nr, '+
                      ' currency=:currency,currency_drate_ovr=:currency_drate_ovr, descr=:descr, status=:status,rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                      ' WHERE id=:id';




  _SQLInsertPaymentData  = ' INSERT INTO payment_data(id,payment_id, item_type, item_id,item_descr,'+
                           ' splt_sum,account_id, status) '+
                           ' VALUES(:id,:payment_id, :item_type, :item_id,:item_descr,'+
                           ' :splt_sum,:account_id, :status)';




  // !!!!!!!!!!
  // maksekorralduse read, mis pole ei arved / ega tellimused, ntx riigilõivud
  // siin viitab item_id iseendale !!!
  _SQLInsertPaymentData2= ' INSERT INTO payment_data(id,payment_id, item_type, item_id,item_descr,'+
                           ' splt_sum,account_id, status) '+
                           ' SELECT :id,:payment_id, '''+estbk_types.CCommTypeAsMisc+''',:id,:item_descr,'+
                           ' :splt_sum,:account_id, :status '+
                           ' FROM __int_systemtypes x '+
                           ' WHERE COALESCE(:account_id,0)>0 '+
                           '   AND x.bbool=''t''';



   // summa staatus
  _SQLUpdatePaymentDataStatus  = ' UPDATE payment_data '+
                                 ' SET  status=COALESCE(:status,status),'+
                                 ' splt_sum=COALESCE(:splt_sum,splt_sum), '+ // säilitame vana staatuse !
                                 ' item_descr=COALESCE(:item_descr,item_descr), '+ // säilitame vana staatuse !
                                 ' account_id=COALESCE(:account_id,account_id) '+
                                 ' WHERE id=:id ';

   // delete stiilis update
   _SQLDeletePaymentMiscData   = ' UPDATE payment_data '+
                                  ' SET  status=''D'''+
                                  ' WHERE id=:id ';


   // kõik kirjed annuleerida
   _SQLDeletePaymentMiscData2    = ' UPDATE payment_data '+
                                   ' SET  status=''D'''+
                                   ' WHERE payment_id=:payment_id '+
                                   '   AND status NOT LIKE ''%D%''';



   // MAKSEKORRALDUSE LISA; LAEKUMISED; abistavad päringud
   _SQLPyGetBillMiscData = ' SELECT b.bill_number,b.bill_date,b.client_id,b.credit_bill_id,b.accounting_register_id, b.status, '+
                           ' b.totalsum,b.roundsum,b.vatsum,b.incomesum,b.prepaidsum,b.payment_status,c.accounting_period_id '+
                           ' FROM bills b '+
                           ' INNER JOIN accounting_register c ON '+
                           ' c.id=b.accounting_register_id '+
                           ' WHERE b.company_id=:company_id '+
                           '   AND b.id=COALESCE(:id,b.id)';


   _SQLPyUpdateBillPaymentData = ' UPDATE bills '+
                                 ' SET incomesum=incomesum+(:incomesum),prepaidsum=prepaidsum+(:prepaidsum),'+
                                 // ' payment_status=:payment_status, '+ 31.03.2011 Ingmar
                                 ' rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                                 ' WHERE id=:id';


   // SÜSTEEMSED KONTOD; ehk vaikekontod
   _SQLSelectSysAccounts = ' SELECT d.id, d.ordinal_nr, d.sys_descr, d.account_id,a.account_coding, '+
                           ' a.account_name,a.default_currency as currency, d.starts, d.ends, '+
                           ' d.rec_changed, d.rec_changedby, d.rec_addedby '+
                           ' FROM default_sysaccounts d'+
                           ' INNER JOIN accounts a ON '+
                           ' a.id=d.account_id '+
                           ' WHERE d.company_id=:company_id '+
                           '   AND d.ends IS NULL '+
                           // ühe totra vea parandamiseks
                           '   AND d.id=(SELECT MAX(d1.id) '+
                           '             FROM default_sysaccounts d1 '+
                           '             WHERE d1.company_id=:company_id '+
                           '               AND d1.ordinal_nr=d.ordinal_nr '+
                           '               AND d1.ends IS NULL'+
                           '            )'+
                           ' ORDER BY d.id DESC';

   _SQLSelectUnassignedSysAccounts = '  SELECT count(id) as cnt,(SELECT  max(id) FROM default_sysaccounts WHERE company_id=:company_id) as maxid '+
                                     '  FROM default_sysaccounts '+
                                     '  WHERE company_id=:company_id '+
                                     '    AND COALESCE(account_id,0)<1 ';


   _SQLSelectSysDocuments = ' SELECT id,shortidef,name as docname '+
                            ' FROM classificators '+
                            ' WHERE type_=''document_types'''+
                            '   AND ((company_id=:company_id) OR (company_id=0)) '+
                            ' ORDER BY ID ASC';


   // kirjeldus ei luba muuta; tegemist süsteemse kirjeldusega !!!
   _SQLUpdateSysAccount2 = ' UPDATE default_sysaccounts '+
                           ' SET ends=:ends,rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                           ' WHERE id=:id';




   _SQLInsertSysAccount = ' INSERT INTO default_sysaccounts(id, ordinal_nr, sys_descr, account_id, starts, ends, company_id,'+
                          ' rec_changed, rec_changedby, rec_addedby) '+
                          ' VALUES (:id,:ordinal_nr,:sys_descr,:account_id,:starts,:ends,:company_id,'+
                          ' :rec_changed, :rec_changedby, :rec_addedby) ';



   // tegevuste aruanded; ntx sisestati fail, et mis vead seal olid
   _SQLInsertStatusRepMRec = ' INSERT INTO status_report(id, code, classificator_id, misc_data, hdr_data, ftr_data, op_starts,'+
                             ' op_ends, status, parent_id, company_id, rec_changed, rec_changedby,rec_addedby) '+
                             ' VALUES (:id, :code, :classificator_id, :misc_data, :hdr_data, :ftr_data, :op_starts,:op_ends,'+
                            ' :status, :parent_id, :company_id, :rec_changed, :rec_changedby,:rec_addedby)';

   _SQLUpdateStatusRepMRec = ' UPDATE status_report '+
                             ' SET misc_data=COALESCE(:misc_data,misc_data), '+
                             ' hdr_data=COALESCE(:hdr_data,hdr_data), '+
                             ' ftr_data=COALESCE(:ftr_data,ftr_data),'+
                             ' op_starts=COALESCE(:op_starts,op_starts),'+
                             ' op_ends=COALESCE(:op_ends,op_ends) '+
                             ' WHERE id=:id ';

   _SQLInsertStatReportLines = ' INSERT INTO status_report_lines(id, status_report_id, code, severity, ldescr,ddescr,line_nr, '+
                               ' misc_id, rec_changed,rec_changedby, rec_addedby) '+
                               ' VALUES(:id,:status_report_id,:code,:severity,:ldescr,:ddescr,:line_nr, :misc_id,'+
                               ' :rec_changed,:rec_changedby,:rec_addedby)';



   // PANGAFAILID
   _SQLInsertIncomingsSessions = ' INSERT INTO incomings_sessions('+
                                 ' id, session_name, filename,created,'+
                                 ' type_, company_id, rec_changed, rec_changedby, rec_addedby)'+
                                 ' VALUES (:id, :session_name, :filename,:created,'+
                                 ' :type_, :company_id, :rec_changed, :rec_changedby, :rec_addedby)';


   _SQLSelectSessionPerDate  = ' SELECT id,session_name,filename FROM incomings_sessions '+
                               ' WHERE company_id=:company_id AND created=:created AND rec_deleted=''f''';



   _SQLInsertIncomingsBank   = ' INSERT INTO incomings_bank(id,incomings_session_id,client_id, bank_id,bank_code, bank_archcode, bank_rec_status,'+
                               ' bank_op_code, payer_name, payer_refnumber, payer_mk_nr, payment_sum,'+
                               ' nr, state_treasury_refnr, receiver_account_number, receiver_account_number_iban,'+
                               ' payment_date, payer_code, description, bank_description, incoming_date,'+
                               ' bank_account, bank_account_iban, bank_bk_account_id, currency, currency_drate_ovr,service_charges,'+
                               ' status, rec_changed, rec_changedby, rec_addedby) '+
                               ' VALUES(:id,:incomings_import_session_id,:client_id,:bank_id, :bank_code, :bank_archcode, :bank_rec_status,'+
                               ' :bank_op_code, :payer_name, :payer_refnumber, :payer_mk_nr, :payment_sum,'+
                               ' :nr, :state_treasury_refnr, :receiver_account_number, :receiver_account_number_iban,'+
                               ' :payment_date, :payer_code, :description, :bank_description, :incoming_date,'+
                               ' :bank_account, :bank_account_iban, :bank_bk_account_id, :currency, :currency_drate_ovr,:service_charges,'+
                               ' :status, :rec_changed, :rec_changedby, :rec_addedby)';


    _SQLInsertIncoming = ' INSERT INTO incomings(id, client_id, bill_id, order_id, rec_nr, incoming_date, payment_date,'+
                         ' income_sum, currency, currency_id, currency_drate_ovr,conv_income_sum,conv_currency,conv_currency_id,conv_currency_drate_ovr,'+
                         ' account_id,accounting_register_id,incomings_bank_id,cash_register_id,direction,status,company_id,rec_changed, rec_changedby, rec_addedby) '+
                         ' VALUES(:id,:client_id,:bill_id,:order_id,:rec_nr,:incoming_date,:payment_date,:income_sum,:currency,:currency_id,'+
                         ' :currency_drate_ovr,:conv_income_sum,:conv_currency,:conv_currency_id,:conv_currency_drate_ovr,:account_id,' +
                         ' :accounting_register_id,:incomings_bank_id,:cash_register_id,:direction, :status,:company_id,:rec_changed,:rec_changedby,:rec_addedby)';

    _SQLUpdateIncomingStatus = ' UPDATE incomings '+
                               ' SET status=:status,rec_changed=:rec_changed,rec_changedby=:rec_changedby '+
                               ' WHERE id=:id';



   // MAKSE / MAKSEKORRALDUS / KASSA
   {
   _SQLInsertPayment  = ' INSERT INTO payment(id, client_id, bill_id, order_id, rec_nr, incoming_date,'+
                        ' payment_date, total, currency, currency_id, currency_drate_ovr,accounting_register_id,'+
                        ' status,company_id, rec_changed, rec_changedby, rec_addedby) '+
                        ' VALUES(:id, :client_id, :bill_id, :order_id, :rec_nr, :incoming_date,'+
                        ' :payment_date, :total, :currency, :currency_id, :currency_drate_ovr,:accounting_register_id,'+
                        ' :status,:company_id, :rec_changed, :rec_changedby, :rec_addedby)';
   }


   // (MAKSU)DEKLARATSIOON
   _SQLSelectDFormsByType       = ' SELECT id,form_name,form_type,descr,url,valid_from,valid_until '+
                                  ' FROM formd '+
                                  ' WHERE company_id=:company_id '+
                                  '  AND  form_type=:formtype '+
                                  '  AND  rec_deleted=''f'' '+
                                  ' ORDER BY valid_from DESC ';

   _SQLSelectDFormDetailedLines = ' SELECT id,parent_id,line_descr,row_nr,log_nr,formula,row_id,baserecord_id '+
                                  ' FROM formd_lines '+
                                  ' WHERE formd_id=:formd_id '+
                                  '   AND rec_deleted=''f'''+
                                  //' and row_id like ''%$52%'' '+
                                  ' ORDER BY row_nr,log_nr'; // järjestus muudetud ! row_nr,log_nr
                                  //' ORDER BY log_nr';


   // kontod, mis viitavad vaikimisi reale kirjutasin funktsiooniks !
   // _SQLSelectRefDFormLines


   _SQLInsertDFormDetailedLine =  ' INSERT INTO formd_lines(id,formd_id,parent_id,line_descr,row_nr,row_id,'+
                                  ' log_nr, formula,rec_changed, rec_changedby, rec_addedby,baserecord_id) '+
                                  ' VALUES (:id,:formd_id,:parent_id,:line_descr,:row_nr,:row_id,:log_nr,:formula, '+
                                  ' :rec_changed, :rec_changedby, :rec_addedby,:baserecord_id)';


   _SQLDeleteDFormDetailedLine = ' UPDATE formd_lines '+
                                 ' SET rec_deletedby=:rec_deletedby, rec_deleted=:rec_deleted,rec_changed=:rec_changed '+
                                 ' WHERE id=:id ';

   _SQLDeleteAllDFormLines     = ' UPDATE formd_lines '+
                                 ' SET rec_deletedby=:rec_deletedby, rec_deleted=:rec_deleted,rec_changed=:rec_changed '+
                                 ' WHERE formd_id=:formd_id '+
                                 '   AND rec_deleted=''f''';

   _SQLUpdateDFormDetailedLineRowNr = ' UPDATE formd_lines '+
                                      ' SET row_nr=:row_nr,rec_changedby=:rec_changedby,rec_changed=:rec_changed '+
                                      ' WHERE id=:id ';


   _SQLInsertNewFormdEntry = ' INSERT INTO formd(id, form_name, form_type, descr, url, valid_from, valid_until, '+
                             ' company_id, rec_changed, rec_changedby, rec_addedby) '+
                             ' VALUES(:id, :form_name, :form_type, :descr, :url, :valid_from, :valid_until, '+
                             ' :company_id, :rec_changed, :rec_changedby, :rec_addedby)';


   _SQLSelectLastFormIDByType = ' SELECT MAX(id) as idmax '+
                                ' FROM formd '+
                                ' WHERE company_id=:company_id'+
                                '   AND form_type=:form_type';

   // 13.04.2011 Ingmar
   _SQLSelectGetSettingValue = ' SELECT id,item_value '+
                               ' FROM user_settings '+
                               ' WHERE  user_id=:user_id '+
                               '    AND item_name=:item_name '+
                               '    AND NOT item_name IN (%s) '+
                               ' UNION '+
                               ' SELECT id,item_value '+
                               ' FROM user_settings '+
                               ' WHERE  company_id=COALESCE(:company_id,company_id)'+
                               '    AND user_id=:user_id '+
                               '    AND item_name=:item_name '+
                               '    AND item_name IN (%s)'+
                               ' ORDER BY id ASC ';



   _SQLSelectAllUsrSettings   = ' SELECT id,item_name,item_value '+
                                ' FROM user_settings '+
                                ' WHERE  user_id=:user_id '+
                                // '    AND company_id=COALESCE(:company_id,company_id)'+
                                '    AND NOT item_name IN (%s)'+
                                ' UNION '+
                                ' SELECT id,item_name,item_value '+
                                ' FROM user_settings '+
                                ' WHERE  company_id=COALESCE(:company_id,company_id)'+
                                '    AND user_id=:user_id '+
                                '    AND item_name IN (%s)'+
                                ' ORDER BY id ASC ';

   _SQLInsertSettingValue = ' INSERT INTO user_settings(user_id, item_name, item_value, company_id) '+
                            ' VALUES (:user_id,:item_name, :item_value, :company_id) ';

   _SQLUpdateSettingValue = ' UPDATE user_settings '+
                            ' SET item_value=:item_value '+
                            ' WHERE user_id=:user_id '+
                            '  AND  item_name=:item_name ';

   _SQLUpdateSettingValue2= ' UPDATE user_settings '+
                            ' SET item_value=:item_value '+
                            ' WHERE company_id=:company_id '+
                            '  AND  item_name=:item_name ';


(*
   _SQLUpdateAccountBalDLineId = ' UPDATE accounts '+
                                 ' SET balance_rep_line_id=:new_line_id '+
                                 ' WHERE company_id=:company_id '+
                                 '   AND balance_rep_line_id=:old_line_id';

   _SQLUpdateAccountIncDLineId = ' UPDATE accounts '+
                                 ' SET incstat_rep_line_id=:new_line_id '+
                                 ' WHERE company_id=:company_id '+
                                 '   AND incstat_rep_line_id=:old_line_id';
*)

// ===
  _SQLSelectEmployee = 'SELECT * FROM employee WHERE id=COALESCE(:id,id) AND company_id=:company_id AND rec_deleted=''f'' ORDER BY lastname';
  _SQLSelectNullEmployee = 'SELECT * FROM employee WHERE company_id=:company_id AND flags=:flags AND code=:code';
  _SQLSelectEmployeeRegCode = 'SELECT * FROM employee WHERE personal_idnr=:personal_idnr AND company_id=:company_id AND id<>COALESCE(:ID,id)';

  _SQLInsertEmployee = 'INSERT INTO employee(id,code, firstname, middlename, lastname, personal_idnr, bday, '+
                       'bmonth, byear,gender, address, postalcode, phone, email, bank, bankaccount,'+
                       'nationality, nonresident, resident_countryname, resident_countrycode,'+
                       'lpermitnr, wpermitnr, education, picture,contact_person, contact_person_addr,'+
                       'contact_person_phone, flags,company_id, rec_changed, rec_changedby, rec_addedby) '+
                       'VALUES (:id,:code, :firstname, :middlename, :lastname, :personal_idnr, :bday,'+
                       ':bmonth,:byear,:gender, :address, :postalcode, :phone, :email, :bank, :bankaccount,'+
                       ':nationality,:nonresident, :resident_countryname, :resident_countrycode,'+
                       ':lpermitnr, :wpermitnr, :education, :picture,:contact_person, :contact_person_addr,'+
                       ':contact_person_phone, :flags,:company_id, :rec_changed, :rec_changedby, :rec_addedby) ';

  _SQLUpdateEmployee = 'UPDATE employee '+
                       'SET code=:code,'+
                       'firstname=:firstname,'+
                       'middlename=:middlename,'+
                       'lastname=:lastname,'+
                       'personal_idnr=:personal_idnr,'+
                       'bday=:bday,'+
                       'bmonth=:bmonth,'+
                       'byear=:byear,'+
                       'gender=:gender,'+
                       'address=:address,'+
                       'postalcode=:postalcode,'+
                       'phone=:phone,'+
                       'email=:email,'+
                       'bank=:bank,'+
                       'bankaccount=:bankaccount,'+
                       'nationality=:nationality,'+
                       'nonresident=:nonresident,'+
                       'resident_countryname=:resident_countryname,'+
                       'resident_countrycode=:resident_countrycode,'+
                       'lpermitnr=:lpermitnr,'+
                       'wpermitnr=:wpermitnr,'+
                       'education=:education,'+
                       'picture=:picture,'+
                       'contact_person=:contact_person,'+
                       'contact_person_addr=:contact_person_addr,'+
                       'contact_person_phone=:contact_person_phone,'+
                       'flags=:flags,'+
                       'rec_changed=:rec_changed,'+
                       'rec_changedby=:rec_changedby,'+
                       'rec_addedby=:rec_addedby '+
                       'WHERE id=:id '+
                       '  AND company_id=:company_id';

  _SQLSelectIdDocument = 'SELECT * FROM employee_id_document WHERE id=:id';
  _SQLInsertIdDocument = 'INSERT INTO employee_id_document(id, doc_name, doc_nr, doc_descr, issuer, issued, valid_until,'+
                         'flags,employee_id, company_id, rec_changed, rec_changedby, rec_addedby) '+
                         'VALUES(:id, :doc_name, :doc_nr, :doc_descr, :issuer, :issued, :valid_until,'+
                         ':flags,:employee_id, :company_id, :rec_changed, :rec_changedby, :rec_addedby)';

  _SQLUpdateIdDocument = 'UPDATE employee_id_document '+
                         'SET  doc_name=:doc_name,'+
                         'doc_nr=:doc_nr,'+
                         'doc_descr=:doc_descr,'+
                         'issuer=:issuer,'+
                         'issued=:issued,'+
                         'valid_until=:valid_until,'+
                         'flags=:flags,'+
                         'rec_changed=:rec_changed,'+
                         'rec_changedby=:rec_changedby '+
                         'WHERE id=:id';

  // viimane kehtiv dokument
  _SQLSelectMaxIdDocument = 'SELECT e.* FROM employee_id_document e '+
                            'WHERE e.id=(SELECT MAX(p.ID) FROM employee_id_document p WHERE p.employee_id=:employee_id AND p.rec_deleted=''f'')';

  _SQLSelectWorkContract = 'SELECT * FROM employment_contract WHERE id=COALESCE(:id,id) AND company_id=:company_id';


  _SQLSelectWorkContract2= 'SELECT * '+
                           'FROM employment_contract '+
                           'WHERE employee_id=:employee_id '+
                           '  AND company_id=:company_id '+
                           '  AND rec_deleted=''f'' '+
                           ' ORDER BY start_date DESC ';

  _SQLSelectWorkContract3 = 'SELECT * FROM employment_contract WHERE nr=:nr AND company_id=:company_id';

  _SQLInsertWorkContract = 'INSERT INTO employment_contract(id, employee_id, classificator_id, nr, contract_date, norm_workhours,'+
                           'start_date, end_date, "position", holidays_per_year, tfcalc_beginning,'+ // NB position on reserveeritud lause postgres !!!
                           'early_retirement_date, flags, company_id,'+
                           'rec_changed, rec_changedby, rec_addedby) '+
                           'VALUES(:id, :employee_id, :classificator_id, :nr, :contract_date, :norm_workhours,'+
                           ':start_date,:end_date,:position, :holidays_per_year, :tfcalc_beginning,'+
                           ':early_retirement_date,:flags,:company_id,:rec_changed,:rec_changedby,:rec_addedby)';

  _SQLUpdateWorkContract = 'UPDATE employment_contract '+
                           'SET  classificator_id=:classificator_id, nr=:nr, contract_date=:contract_date,'+
                           'norm_workhours=:norm_workhours, start_date=:start_date, end_date=:end_date,'+
                           '"position"=:position, holidays_per_year=:holidays_per_year,'+
                           'tfcalc_beginning=:tfcalc_beginning, early_retirement_date=:early_retirement_date,'+
                           'flags=:flags,rec_changed=:rec_changed, rec_changedby=:rec_changedby '+
                           'WHERE id=:id';





  // PS PS fikseeritud palgaread !
  {
  _SQLSelectFixedWageTypes = ' SELECT id,name as wage_name '+
                             ' FROM classificators '+
                             ' WHERE type_=''wage_type'' '+
                             '  AND shortidef IN (''P'',''V'') '+ // vaid tüübiga palk
                             '  AND company_id in (0,:company_id) '+
                             ' ORDER BY id ASC ';
  }

  // kasutame palgatüüpe
  _SQLSelectFixedWageTypes = ' SELECT id,"name" as wage_name '+
                             ' FROM wage_types '+
                             ' WHERE sub_type IN (''P'',''V'') '+
                             '  AND company_id in (0,:company_id) '+
                             ' ORDER BY id ASC ';

  // palgaread;
  _SQLSelectEmpWageDef = 'SELECT l.id as prec_id,e.id,e.unit,e.price,e.flags,row_id,l.valid_from,l.valid_until,w.id as wage_id,w.name as wage_name '+
                         'FROM employee_wage l '+
                         'INNER JOIN employee_wage_lines e ON '+
                         'e.employee_wage_id=l.id '+
                         'INNER JOIN wage_types w ON '+
                         'w.id=e.wage_type_id '+
                         'WHERE l.employment_contract_id=:employment_contract_id '+
                         '  AND l.rec_deleted=''f'''+
                         '  AND e.rec_deleted=''f''';


  _SQLSelectEmpWageDef2= 'SELECT e.id,e.unit,e.price,e.flags,row_id,e.valid_from,e.valid_until,e.formula, '+
                         'coalesce(w.id,0) as wage_id,w.name as wage_name, '+
                         'coalesce(t.id,0) as tax_id,t.taxname,e.account_id,a.account_coding '+
                         'FROM employee_wage l '+
                         'INNER JOIN employee_wage_lines e ON '+
                         'e.employee_wage_id=l.id '+
                         'LEFT OUTER JOIN accounts a ON '+
                         'a.id=e.account_id '+
                         'LEFT OUTER JOIN wage_types w ON '+
                         'w.id=e.wage_type_id '+
                         'LEFT OUTER JOIN taxes t ON '+
                         't.id=e.tax_id '+
                         //'WHERE l.employee_id=:employee_id '+
                         //'  AND l.employment_contract_id=COALESCE(:employment_contract_id,l.employment_contract_id) '+
                         'WHERE '+
                         '      l.id=:id '+
                         '  AND l.rec_deleted=''f'' '+
                         '  AND e.rec_deleted=''f'' '+
                         '  AND ((l.valid_from is null) or (l.valid_from>=COALESCE(:valid_from,l.valid_from))) '+
                         '  AND ((l.valid_until is null) or (l.valid_until<=COALESCE(:valid_until,l.valid_until))) '+
                         ' ORDER BY e.row_id ASC ';




   _SQLInsertEmpWageDefMRec= 'INSERT INTO employee_wage(id, employee_id, employment_contract_id, valid_from, valid_until,'+
                             'flags, template, company_id, rec_changed, rec_changedby,rec_addedby) '+
                             'VALUES(:id,:employee_id,:employment_contract_id,:valid_from,:valid_until, '+
                             ':flags, :template, :company_id, :rec_changed, :rec_changedby,:rec_addedby)';


  _SQLSelectEmpWageDefMRec = ' SELECT  * '+
                             ' FROM employee_wage '+
                             ' WHERE employee_id=:employee_id '+
                             '  AND  template=COALESCE(:template,template) '+
                             '  AND  employment_contract_id=COALESCE(:employment_contract_id,employment_contract_id) '+
                             '  AND ((valid_from is null) or (valid_from>=COALESCE(:valid_from,valid_from))) '+
                             '  AND ((valid_until is null) or (valid_until<=COALESCE(:valid_until,valid_until))) '+
                             '  AND  rec_deleted=''f'' ';


  _SQLSelectEmpWageDefMRec2 = ' SELECT  * '+
                              ' FROM employee_wage '+
                              ' WHERE employee_id=:employee_id '+
                              '  AND  company_id=:company_id '+
                              '  AND  template=''t'' '+
                              '  AND  rec_deleted=''f'' '+
                              ' ORDER BY 1 DESC ';


  _SQLInsertEmpWageDef = 'INSERT INTO employee_wage_lines(employee_wage_id, wage_type_id, row_id, '+
                         'formula, valid_from, valid_until, unit, price, flags, rec_changed,'+
                         'rec_changedby, rec_addedby) '+
                         'VALUES(:employee_wage_id, :wage_type_id, :row_id,'+
                         ':formula, :valid_from, :valid_until, :unit, :price, :flags, :rec_changed,:rec_changedby,:rec_addedby) ';


  _SQLUpdateEmpWageDef = 'UPDATE employee_wage_lines '+
                         'SET  wage_type_id=:wage_type_id,'+
                         'row_id=:row_id,'+
                         'formula=:formula,'+
                         'valid_from=:valid_from,'+
                         'valid_until=:valid_until,'+
                         'unit=:unit,'+
                         'price=:price,'+
                         'flags=:flags,'+
                         'rec_changed=:rec_changed,'+
                         'rec_changedby=:rec_changedby '+
                         'WHERE id=:id';


   _SQLInsertEmpWageDef2= 'INSERT INTO employee_wage_lines(employee_wage_id, wage_type_id,tax_id, row_id, '+
                          'formula, valid_from, valid_until, unit, price, account_id, flags, rec_changed,rec_changedby, rec_addedby) '+
                          'VALUES(:employee_wage_id, :wage_type_id,:tax_id, :row_id,'+
                          ':formula, :valid_from, :valid_until, :unit, :price,:account_id, :flags, :rec_changed,:rec_changedby,:rec_addedby) ';

   _SQLUpdateEmpWageDef2 = 'UPDATE employee_wage_lines '+
                           'SET  wage_type_id=:wage_type_id,'+
                           'tax_id=:tax_id,'+
                           'row_id=:row_id,'+
                           'formula=:formula,'+
                           'unit=:unit,'+
                           'price=:price,'+
                           'account_id=:account_id,'+
                           'flags=:flags,'+
                           'rec_changed=:rec_changed,'+
                           'rec_changedby=:rec_changedby '+
                           'WHERE id=:id';

  _SQLDeleteEmpWageDef = 'UPDATE employee_wage_lines '+
                         'SET '+
                         'rec_deletedby=:rec_deletedby, '+
                         'rec_deleted=:rec_deleted,'+
                         'rec_changed=:rec_changed,'+
                         'rec_changedby=:rec_changedby '+
                         'WHERE id=:id';

  // nö "kustutamine"
  _SQLDeleteBill = 'UPDATE bills '+
                   'SET rec_deleted=''t'', '+
                   'rec_deletedby=:rec_deletedby, '+
                   'rec_changed=:rec_changed '+
                   'WHERE id=:id '+
                   '  AND status NOT LIKE ''%C%''';

  // kui kustutatakse kreeditarve, peame viite sellele ära võtma
  _SQLDeleteBillResetCB = 'UPDATE bills ' +
                          'SET credit_bill_id=0,rec_changed=:rec_changed, rec_deletedby=:rec_deletedby ' +
                          'WHERE bills.credit_bill_id=:id';

{
  _SQLDeleteIncoming = 'UPDATE incomings '+
                       'SET rec_deleted=''t'', '+
                       'rec_deletedby=:rec_deletedby, '+
                       'rec_changed=:rec_changed '+
                       'WHERE id=:id '+
                       ' AND NOT EXISTS('+
                       ' SELECT b.* '+
                       ' FROM incomings_bank b '+
                       ' WHERE b.id=incomings.incomings_bank_id AND b.status NOT LIKE ''%C%'')';
}
  _SQLDeleteIncoming = 'UPDATE incomings_bank '+
                       'SET rec_deleted=''t'', '+
                       'rec_deletedby=:rec_deletedby, '+
                       'rec_changed=:rec_changed '+
                       'WHERE id=:id '+
                       '  AND status NOT LIKE ''%C%''';


  _SQLDeletePayment  = 'UPDATE payment '+
                       'SET rec_deleted=''t'', '+
                       'rec_deletedby=:rec_deletedby, '+
                       'rec_changed=:rec_changed '+
                       'WHERE id=:id '+
                       '  AND status NOT LIKE ''%C%''';


  _SQLDeleteOrder    = 'UPDATE orders '+
                       'SET rec_deleted=''t'', '+
                       'rec_deletedby=:rec_deletedby, '+
                       'rec_changed=:rec_changed '+
                       'WHERE id=:id'+
                       '  AND status NOT LIKE ''%C%''';


  _SQLDeleteCashReg  = _SQLDeletePayment;


  // numeraatorite teema, kui see muutuja olemas, siis sisuliselt kasutatakse firmal maj. aasta põhiseid numeraatoreid
  // Kui seda pole, siis kõik nagu vanasti
  _SQLSelectACPVar   = ' SELECT * FROM conf WHERE company_id=:company_id AND var_name=''apcnumerators''';

  _SQLInsertNumCache = ' INSERT INTO numeratorcache(num_type, num_value, num_acc_period_id, flags,user_id, company_id) '+
                       ' VALUES(:num_type,:num_value,:num_acc_period_id,:flags,:user_id,:company_id) ';

  _SQLUpdateNumCache = ' UPDATE numeratorcache '+
                       ' SET num_type=:num_type, num_value=:num_value, num_acc_period_id=:num_acc_period_id, flags=:flags '+
                       ' WHERE id=:id';

  _SQLDeleteNumCache = ' DELETE FROM numeratorcache WHERE id=:id ';

  _SQLSelectNumCache = ' SELECT n.*,a.period_start as num_perstart,a.period_end as num_perend '+
                       ' FROM numeratorcache n '+
                       ' LEFT OUTER JOIN accounting_period a  ON'+
                       ' a.id=n.num_acc_period_id '+
                       ' WHERE n.company_id=:company_id '+
                       '   AND n.user_id=COALESCE(:user_id,n.user_id) '+
                       '   AND n.flags=COALESCE(:flags,n.flags) ';

  _SQLSelectNumFmts =  ' SELECT id,cr_num_type,cr_srbfr,accounting_period_id as acc_id '+
                       ' FROM numerators '+
                       ' WHERE accounting_period_id>0 '+
                       '   AND company_id=:company_id';

  _SQLSelectMinNumFst = ' SELECT MIN(accounting_period_id) as macc_period '+
                        ' FROM numerators '+
                        ' WHERE accounting_period_id>0 '+
                        '   AND company_id=:company_id';

// PARANDUSED / SQL; kaob kompatiiblus !
  _SQLNumeratorQryFixSQL1 = ' SELECT id FROM accounting_register '+
                            ' WHERE type_=''R'' AND '+
                            ' transdescr like ''%issetuleku%'' AND '+
                            ' accounting_period_id=:acc_period AND '+
                            ' entrynumber=:entrynumber';

  _SQLNumeratorQryFixSQL2 = ' SELECT id FROM accounting_register '+
                            ' WHERE type_=''R'' AND '+
                            ' transdescr like ''%ljamineku%'' AND '+
                            ' accounting_period_id=:acc_period AND '+
                            ' entrynumber=:entrynumber';

  _SQLNumeratorQryFixSQL3= ' SELECT id FROM accounting_register '+
                            ' WHERE type_=:ptype AND '+
                            ' accounting_period_id=:acc_period AND '+
                            ' entrynumber=:entrynumber';


  // 15.07.2012 Ingmar; sulgemiskande jaoks päring; sulgemiskanne on tunnusega X
  _SQLSelectNonXAccSum= ' SELECT  a.id as acc_id, a.account_coding, c0.name as acctypname, '+
                        ' c0.shortidef as acctypeidf, c1.name as commtype,c1.shortidef as commidf,'+
                        '(SELECT COALESCE(SUM(d.rec_sum),0.00) '+
                        ' FROM accounting_register r '+
                        ' INNER JOIN accounting_records d ON '+
                        ' d.accounting_register_id=r.id AND d.account_id=a.id '+
                        ' WHERE r.transdate>=:paccperiodstart '+
                        '   AND r.transdate<=:paccperiodend '+
                        '   AND r.company_id=:company_id '+
                        '   AND r.type_<>''X'''+
                        '   AND d.rec_type=''D'') as dside, '+

                        '(SELECT COALESCE(SUM(d.rec_sum),0.00) '+
                        ' FROM accounting_register r '+
                        ' INNER JOIN accounting_records d ON '+
                        ' d.accounting_register_id=r.id AND d.account_id=a.id '+
                        ' WHERE r.transdate>=:paccperiodstart '+
                        '   AND r.transdate<=:paccperiodend '+
                        '   AND r.company_id=:company_id '+
                        '   AND r.type_<>''X'''+
                        '   AND d.rec_type=''C'') as cside '+
                        ' FROM accounts a '+
                        ' LEFT OUTER JOIN classificators  c0 ON '+
                        ' c0.id=a.typecls_id '+
                        ' INNER JOIN classificators  c1 ON '+
                        ' c1.id=a.type_id AND c1.shortidef IN (''CO'',''IN'') '+
                        ' WHERE a.company_id=:company_id '+
                        ' ORDER BY a.account_coding,c1.shortidef ';


 _SQLSelectXAccItems =  ' SELECT id,entrynumber,transdate '+
                        ' FROM accounting_register '+
                        ' WHERE  transdate BETWEEN :paccperiodstart AND :paccperiodend '+
                        '    AND company_id=:company_id '+
                        '    AND type_=''X''';


 _SQLPrevAccPeriods   = ' SELECT p1.* '+
                        ' FROM accounting_period p1'+
                        ' WHERE p1.company_id=:company_id'+
                        ' AND p1.rec_deleted=''f'''+
                        ' AND p1.id< '+
                        ' (SELECT MAX(p2.ID)'+
                        ' FROM accounting_period p2'+
                        ' WHERE p2.company_id=:company_id'+
                        '   AND p2.rec_deleted=''f'')'+
                        ' ORDER BY p1.id DESC';

 _SQLInsertEMail = ' INSERT INTO email(id, email, subject, body, request_date, letter_send_date, when_to_send,status, emsg, company_id) '+
                   ' VALUES (:id, :email, :subject, :body, :request_date, :letter_send_date, :when_to_send, :status, :emsg, :company_id) ';

 _SQLInsertSentMails = ' INSERT INTO sentemails(email_id, item_id, item_type, classificator_id, client_id,'+
                       ' company_id, rec_changed, rec_changedby, rec_addedby) '+
                       ' VALUES(:email_id, :item_id, :item_type, :classificator_id, :client_id,'+
                       ' :company_id, :rec_changed, :rec_changedby, :rec_addedby) ';



 // ###########################################################################
 // E-arve sisestus

 const
   _SQLAutoCreateNewclient = ' INSERT INTO client(ctype, name, client_code, regnr, countrycode, county_id, '+
                             ' city_id, street_id, house_nr, apartment_nr, zipcode, phone, mobilephone, '+
                             ' vatnumber, company_id, rec_changed,rec_changedby, rec_addedby) '+
                             ' VALUES(:ctype, :name, :client_code, :regnr, :countrycode, :county_id, '+
                             ' :city_id, :street_id, :house_nr, :apartment_nr, :zipcode, :phone, :mobilephone, '+
                             ' :vatnumber, :company_id, :rec_changed,:rec_changedby, :rec_addedby) '+
                             ' RETURNING *';

   _SQLAutoCreateCodeToclientID = ' UPDATE client '+
                                  ' SET client_code=:client_code '+
                                  ' WHERE id = :id '+
                                  '   AND company_id = :company_id';

   _SQLAutoSelectClientData = ' SELECT * '+
                              ' FROM client '+
                              ' WHERE regnr=:regnr '+
                              '   AND name=:name '+
                              '   AND company_id=COALESCE(:company_id,company_id)';

   _SQLAutoDetectPurchaseAccID = ' SELECT a.purchase_account_id as account_id,a.vat_id,c.account_coding '+
                                 ' FROM articles a' +
                                 ' INNER JOIN accounts c ON '+
                                 ' c.id = a.purchase_account_id '+
                                 ' WHERE a.type_=''S''' +
                                 '   AND a.purchase_account_id>0 '+
                                 '   AND a.rec_deleted=''f''' +
                                 '   AND ((a.name= ''ebill'') OR (a.name= ''ebillimporter'') OR (a.name=''e-arve import''))' + // teha selline artikkel, et saaks arveid importida ?
                                 '   AND a.company_id = :company_id' +
                                 '  UNION '+
                                 '  SELECT a.purchase_account_id as account_id,a.vat_id,c.account_coding ' +
                                 '  FROM articles a' +
                                 '  INNER JOIN accounts c ON '+
                                 '  c.id = a.purchase_account_id '+
                                 '  WHERE a.type_=''S''' +
                                 '    AND a.purchase_account_id>0 ' +
                                 '    AND a.rec_deleted=''f''' +
                                 '    AND a.company_id = :company_id' +
                                 // puhas heauristika üle arvete
                                 '  UNION ' +
                                 ' SELECT s0.account_id,s0.vat_id,c.account_coding ' +
                                 ' FROM (SELECT  MIN(b1.item_account_id) as account_id,MAX(b1.vat_id) as vat_id ' +
                                 ' FROM bills b ' +
                                 ' INNER JOIN bill_lines b1 ON ' +
                                 ' b1.bill_id = b.id ' +
                                 ' WHERE b.bill_type=''B''' +
                                 ' AND b.company_id=:company_id ' +
                                 ' AND b.id = (SELECT MAX(b0.id) FROM bills b0 WHERE b0.bill_type=''B'' AND b0.company_id=:company_id)) as s0 ' +
                                 ' INNER JOIN accounts c ON ' +
                                 ' c.id = s0.account_id AND c.flags=0 ' +
                                 ' LIMIT 1 ';


// ############################################################################
// SEPA MAKSED
const
   _SQLInsertSepaFile = ' INSERT INTO sepafile(bankcode,file_name, company_id,rec_changed, rec_changedby, rec_addedby) ' +
                        ' VALUES(:bankcode, :filename, :company_id, :rec_changed, :rec_changedby, :rec_addedby) ' +
                        ' RETURNING id';

   _SQLInsertSepaFileEntry = ' INSERT INTO sepafileentry(sepa_file_id, payment_id) '+
                             ' VALUES(:sepa_file_id, :sepa_payment_id)';



// ============================================================================
// FNC SQL
// ============================================================================
// 15.03.2012 Ingmar

function _SQLStatementOfHolding(const pClientId : Integer;
                                const pPrepayments : Boolean = false;
                                const pAllPrpBills : Boolean = false):AStr;

function _SQLCheckForCurrentlyValidContracts(const pEmployeeId : Integer;
                                             const pContrId : Integer;
                                             const pCtStart : TDatetime;
                                             const pCtEnd   : TDatetime):AStr;

function _CSQLWageTemplateItems(const pCompanyId : Integer; const pIncludeTaxes : Boolean = true):AStr;
function _CSQLGetAllAccounts(const pExcludeClosedAccounts : Boolean = true):AStr;

// 05.03.2011 Ingmar
function _SQLGetUnpaidBills(const pCompanyId  : Integer;
                            const pBillType   : AStr;
                            const pClientId   : Integer = -1;
                            const pDaysOver   : Integer = 0;
                            const pBillsUntil : TDatetime = Nan; // arved kuni <=
                            const pBillCurrency : AStr = '';
                            const pOnlyPartiallyPaidBills : Boolean = false;
                            const pSalePerson : Integer = -1;
                            const pSortByField: Integer = 0;
                            const pSortOrderAZ: Boolean = true
                            ):AStr;



function _SQLSelectRefDFormLines(const pFormId      : Integer;
                                 const pFormRefType : AStr = 'B'
                                 ):AStr;

function _SQLSelectFormLines(const pCompanyId : Integer;
                             const pFormType  : AStr):AStr;

function _SQLSrcIncomings(const pCompanyId : Integer;
                          const pClientId  : Integer = -1;
                          const pRefNr : AStr = '';
                          const pIncNr : AStr = '';
                          const pAccountId : Integer = -1; // rp konto
                          const pFilename  : AStr = '';
                          const pIncSource : Byte = 0; // 0;  1:käsitsi     2: failist
                          const pIncStatus : Byte = 0; // 0;  1:kinnitatud  2: kinnitamata
                          const pIncDateStart : TDatetime = Nan;
                          const pIncDateEnd : TDatetime = Nan):AStr;

// ARVEGA SEOTUD LAEKUMISTE JA TASUMISTE INFO !!!
function _SQLItemPaymentInfo(const pCompanyId : Integer;
                                const pClientId  : Integer = -1;
                                const pBillId  : Integer = -1;
                                const pOrderId : Integer = -1;
                                const pItemDetails : Boolean = true
                                ):AStr;

// ---


function _SQLSelectAccountInitBalance(const dCompanyId   : Integer;
                                      const dAccMainRecExtSQL : Astr = '';  // accounting_register.
                                      const dAccExtSQL        : Astr = '';  // accounts.
                                      const dAccRecExtSQL     : Astr = ''   // accounting_records.
                                      ):AStr;

function _SQLSelectClassificators(const pClsIdentf : AStr;
                                  const pCompanyId : Integer;
                                  const pClsIdentAsType : Boolean = true // siis otsitakse tüübi järgi ! teisel juhul nime järgi
                                  ):AStr;

function _SQLSelectGetTaxForms(const pDFormId         : Integer = 0;
                               const pDFormType       : AStr = '';       // milline dekl. vorm kuvada
                               const pOnlyNonExpForms : Boolean = true;  // ainult kehtivad dekl. vormid
                               const pCompanyId       : Integer = 0      // võimalik ülekirjeldada maksuvormi template
                               ):AStr;


function _SQLSrcOrders(const pOrderType   : Byte = 0; // Defineerimata = 0 / COrderTypeAsPurchOrder = 1 / COrderTypeAsSaleOrder  = 2
                       const pOrderStatus : Byte = 0; // Defineerimata = 0 / COrderStatusConfirmed   = 1 / COrderStatusUnConfirmed = 2
                       const pClientId : Integer = 0 ; // -- tulevikus tuleb lisada ka kontaktisik
                       const pOrderNr        : AStr = '';
                       const pOrderStartDate : TDatetime = Nan;
                       const pOrderEndDate   : TDatetime = Nan;
                       const pOrderContactPerson  : AStr = '';
                       const pFinalBillMustExists : Boolean = False
                       ):AStr;

function _SQLSelectGetOrderPrepaymentBills(const pOrderId: Integer):AStr;

function _SQLSelectOrderLines2(const pOrderId: Integer;
                               const pIsPurchBill : Boolean = true):AStr;


// kontrollime, kas müügi/ostutellimisel tehtud arve
function _SQLGetOrderBillingData(const pOrderId : Integer;
                                 const companyId: Integer):AStr;

// !!!!!!!!!!!!!!!!!!!!!!!
// maksekorraldus / laekumised
function _SQLGetPaymentRefItems(const pAccMainRecId : Integer):AStr;
function _SQLCheckIsCurrPaymentPrePaymentUsed(const pAccMainRecId : Integer):AStr; // kande peakirje
// function _SQLGetAccRecsWherePrepaymentIsUsed(const pAccChldRecId : Int64):AStr;  // - child




function _SQLGetWarehouses(const companyId   : Integer;
                           const warehouseId : Integer = 0):AStr;

function  _SQLGetCustomerUnpaidItems(const clientId : Integer;
                                     const companyId : Integer;
                                     const includeOrders : Boolean = true) :AStr;


function  _SQLSelectAccountsWithBankData(const allItems : Boolean = true):AStr;
function  _CSQLGetOpenAccounts(const pOrderByname : Boolean = false):AStr;

function  _CSQLSelectGenLedgerEntrys(const eSQL : AStr = '';
                                     const pOnlyGenLdRecWithEntrys : Boolean = false
                                     ):AStr;
function  _SQLGetAccRecsFullSelect(const AccRecCancelled : Boolean = false):AStr; // annuleeritud kirjete jaoks pane true lipp !

// klient ! dünaamilised parameetrid !
function  _SQLGetClientNPSQL(const companyId  : Integer;
                             const clientId   : Integer = -1;
                             const regCode    : AStr = '';
                             const cname      : AStr = '';
                             const clastname  : AStr = '';
                             const countyId   : Integer = -1;
                             const cityId     : Integer = -1;
                             const streetId   : Integer = -1;
                             const housenr    : AStr = '';
                             const apartmentnr: AStr = '';
                             // -- 12.02.2011 Ingmar
                             const clientCode : AStr = '';
                             // -- 09.09.2011 Ingmar; panin tänava ka; kui korrektsuse nimel on see lõpus !
                             const country : AStr = '';
                             const maxRows    : Integer = CDefaultMaxRows):AStr;

// Artiklid
// parameetrid
// - :company_id
// - :itemtype
// type: P = toode;
//       S = teenus
//  ...
function _SQLGetArticles(const pAllowSpecialArticleTypes : Boolean = false):AStr;
function _SQLGetBillMainRec(const pSearchByCust : Boolean = false;
                            const pReversedCrBillMode : Boolean = false):AStr;

function _SQLSelectBillLines():AStr;
// ============================================================================

function _SQLSearchBills(const companyId : Integer;
                         const billId : Integer = 0;
                         const custId : Integer = 0;
                         const accDate : TDatetime = Nan; // kande kuupäev
                         const accNr   : AStr  = ''; // kande kuupäev
                         const billDate: TDatetime = Nan; // arve kuupäev
                         const billNr  : AStr = ''; // arve number
                         const billTypes  : AStr = ''; // arvetüübid ! 'B','C'  jne
                         const billFlags  : Byte = 0;  // kõik; 1 kinnitatud; 2 kinnitamata
                         const maxRows    : Integer = CDefaultMaxRows):AStr; // tarnija arve number

function _SQLSearchPayments(const companyId : Integer;
                            const custId    : Integer = 0;
                            const pmtOrderDate : TDatetime = Nan;
                            const docNr     : AStr = '';
                            const billBr    : AStr = '';
                            const orderNr   : AStr = '';
                            const recvAccNr : AStr = '';
                            const descr     : AStr = '';
                            const custName  : AStr = '';
                            const isCashRegister   : Boolean = false; // vaid kassa tehingud / teisel juhul panga tasumised !
                            const cashRegTransType : Byte = 0; // 0 - sissetulek; 1 - väljaminek
                            const maxRows   : Integer = CDefaultMaxRows;
                            const paymentIDs : TADynIntArray = nil):AStr;

function _SQLGetPaymentDataMiscSum(const pmtOrderID  : Integer):AStr;


// tasumine | kassa tuleb info vaid kliendi/hankija põhiselt
function _SQLGetDataForPayment(const pCustId       : Integer;
                               const pPaymentId    : Integer;
                               const pCompanyId    : Integer;
                               const pBillType     : AStr = estbk_types._CItemPurchBill;
                               const pOrderType    : AStr = estbk_types._COAsPurchOrder
                               ):AStr;



implementation
uses estbk_utilities,estbk_dbcompability,estbk_lib_mapdatatypes,estbk_globvars,estbk_lib_commonaccprop,
     estbk_lib_databaseschema,estbk_strmsg{$IFNDEF NOGUI},estbk_clientdatamodule,lclproc{$ENDIF};

// --
function _SQLStatementOfHolding(const pClientId : Integer;
                                const pPrepayments : Boolean = false;
                                const pAllPrpBills : Boolean = false):AStr;
var
 pStr   : TAStrList;
 pStDate: TDatetime;
begin
 try
       pStDate:=now;
       pStr:=TAStrList.Create;
  with pStr do
    begin
     if pPrepayments then
     begin
        // -- ettemaksud peame koostama üle arvete !!!! teisendame eurodeks ära, samas valuutaarved ? peaks jooksva kursi võtma saldoteatise päeval hmmm
        Add(' SELECT ');
        Add('  CAST(');
        Add('        SUM(');
        Add('           (CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum+');
        Add('            COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+')');
        Add('            )*b.currency_drate_ovr) as ');
        Add('     '+TEstbk_MapDataTypes.__MapMoneyType()+') as ppsum,');

     if not pAllPrpBills then
        Add('b.bill_type')
     else
        Add('b.bill_type,b.bill_number,b.bill_date');

        // -----
        Add('FROM bills b');
        Add('LEFT OUTER JOIN bills ccb ON');
        Add(format('ccb.id=b.credit_bill_id AND ccb.rec_deleted=''f'' AND ccb.status=%s',[QuotedStr(estbk_types.CBillStatusClosed)]));
        Add(format('WHERE b.client_id=%d',[pClientId])); // !!!
        Add(format('  AND b.payment_status=%s',[QuotedStr(estbk_types.CBillPaymentOk)])); // ei ole lõpuni tasutud
        Add(format('  AND b.status=%s',[QuotedStr(estbk_types.CBillStatusClosed)]));
        Add(format('  AND b.bill_type IN (%s,%s)',[QuotedStr(estbk_types._CItemSaleBill),QuotedStr(estbk_types._CItemPurchBill)]));
        Add(' AND b.rec_deleted=''f''');
        Add(' AND CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum+');
        Add('          COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+')<0.00');
        Add('GROUP BY ');

     // @@@
     if not pAllPrpBills then
        Add(' b.bill_type')
     else
        Add(' b.bill_type,b.bill_number,b.bill_date');


     end else
     begin
       // MÜÜGIARVE
       Add('SELECT ');
       Add('b.bill_type,');
       Add('b.bill_number,');
       Add('b.bill_date,');
       Add('CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum+');
       Add('COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS to_pay,');

       // --
       Add('CAST(b.totalsum+b.roundsum+b.vatsum+b.fine+');
       Add('COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS  bill_sum,');

       // --
       Add('b.currency as bill_currency,');
       Add('b.currency_drate_ovr');

       Add('FROM bills b');
       Add('LEFT OUTER JOIN bills ccb ON');
       Add(format('ccb.id=b.credit_bill_id AND ccb.rec_deleted=''f'' AND ccb.status=%s',[QuotedStr(estbk_types.CBillStatusClosed)]));
       Add(format('WHERE b.client_id=%d',[pClientId])); // !!!
       Add(format('  AND b.payment_status<>%s',[QuotedStr(estbk_types.CBillPaymentOk)])); // ei ole lõpuni tasutud
       Add(format('  AND b.status=%s',[QuotedStr(estbk_types.CBillStatusClosed)]));
       Add(format('  AND b.bill_type=%s',[QuotedStr(estbk_types._CItemSaleBill)]));
       Add(' AND b.rec_deleted=''f''');
       Add(format(' AND b.due_date<%s',[QuotedStr(estbk_utilities.datetoOdbcStr(pStDate))])); //
       Add(' AND ((b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum)+');
       Add('       COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00))>0.00');

       Add('UNION');
       // OSTUARVE

       Add('SELECT ');
       Add('b.bill_type,');
       Add('b.bill_number,');
       Add('b.bill_date,');
       Add('CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum+');
       Add('COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS to_pay,');

       // --
       Add('CAST(b.totalsum+b.roundsum+b.vatsum+b.fine+');
       Add('COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS  bill_sum,');

       // --
       Add('b.currency as bill_currency,');
       Add('b.currency_drate_ovr');

       Add('FROM bills b');
       Add('LEFT OUTER JOIN bills ccb ON');
       Add(format('ccb.id=b.credit_bill_id AND ccb.rec_deleted=''f'' AND ccb.status=%s',[QuotedStr(estbk_types.CBillStatusClosed)]));
       Add(format('WHERE b.client_id=%d',[pClientId])); // !!!
       Add(format('  AND b.payment_status<>%s',[QuotedStr(estbk_types.CBillPaymentOk)])); // ei ole lõpuni tasutud
       Add(format('  AND b.status=%s',[QuotedStr(estbk_types.CBillStatusClosed)]));
       Add(format('  AND b.bill_type=%s',[QuotedStr(estbk_types._CItemPurchBill)]));
       Add(' AND b.rec_deleted=''f''');
       // Ostuarve puhul ei arvesta maksetähtaega ?!?
       //Add(format(' AND b.due_date<%s',[QuotedStr(estbk_utilities.datetoOdbcStr(pStDate))])); //
       Add(' AND ((b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum)+');
       Add('       COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00))>0.00');
     end; // ----
       // ---
       Result:=pStr.Text;
       //pStr.SaveToFile('c:\test.txt');
    end;
 finally
  freeAndNil(pStr);
 end;
end;

// kontrollime kehtivaid lepinguid perioodis !
function _SQLCheckForCurrentlyValidContracts(const pEmployeeId : Integer;
                                             const pContrId : Integer;
                                             const pCtStart : TDatetime;
                                             const pCtEnd   : TDatetime):AStr;
var
 pStr   : TAStrList;
 pStart : AStr;
 pEnd   : AStr;
begin
    try
         pStr:=TAStrList.Create;
         pStart:='null';
         pEnd:='null';
      if not isNan(pCtStart) then
         pStart:=quotedStr(datetoOdbcStr(pCtStart));

      if not isNan(pCtEnd) then
         pEnd:=quotedStr(datetoOdbcStr(pCtEnd));

    with pStr do
     begin
       add('SELECT *');
       add('FROM employment_contract');
       add(format('WHERE employee_id=%d ',[pEmployeeId]));
       add(format('  AND CAST(COALESCE(%s,''1980-01-01'') AS '+TEstbk_MapDataTypes.__MapDateVariable()+')',[pStart]));
       add('>=CAST(COALESCE(start_date,''1980-01-01'') AS '+TEstbk_MapDataTypes.__MapDateVariable()+')');
       add(format('  AND CAST(COALESCE(%s,''2050-01-01'') AS '+TEstbk_MapDataTypes.__MapDateVariable()+')',[pEnd]));
       add('<=CAST(COALESCE(end_date,''2050-01-01'') AS '+TEstbk_MapDataTypes.__MapDateVariable()+')');
       add('  AND rec_deleted=''f''');
    if pContrId>0 then
       add(format('  AND id<>%d',[pContrId]));
       result:=pStr.Text;
   end;
   // ---
   finally
     freeAndNil(pStr);
    end;
end;


function _CSQLWageTemplateItems(const pCompanyId : Integer; const pIncludeTaxes : Boolean = true):AStr;
var
 pStr : TAStrList;
begin
   try
         pStr:=TAStrList.Create;
    with pStr do
     begin
       add(' SELECT *');
       // -- dblookup jaoks vajalik !
       add( ',CAST(('+
           sqlp._doSafeSQLStrConcat([AStr('type_'),AStr('CAST(id as '+TEstbk_MapDataTypes.__MapVarCharType(10)+')')]));
       add(') as  '+TEstbk_MapDataTypes.__MapVarCharType(15));
       add(') as strid');

       add(' FROM ');
       add(' (SELECT  w.id,w.name as item_name,w.account_id,');
       add('  CAST(0 as '+TEstbk_MapDataTypes.__MapMoneyType+') as minsum,');
       add('  CAST(0 as '+TEstbk_MapDataTypes.__MapMoneyType+') as maxsum,');
       add('  CAST(0.00 as '+TEstbk_MapDataTypes.__MapPercType+') as perc,');
       add('  w.flags,CAST(''R'' as '+TEstbk_MapDataTypes.__MapCharType(1)+') as type_'); // PALK/TASU
       add('  FROM wage_types w');
       add('  WHERE w.rec_deleted=''f''');
       add(format('    AND w.company_id=%d',[pCompanyId]));
       add('  UNION');
       add('  SELECT t.id,t.taxname as item_name,t.account_id,t.minsum,t.maxsum,t.perc,');
       add('  t.flags,CAST(''T'' as '+TEstbk_MapDataTypes.__MapCharType(1)+') as type_'); // MAKSUD
       add('  FROM taxes t');
       add('  WHERE t.rec_deleted=''f''');
       //add('    AND t.company_id=:company_id');
       add(format('    AND t.company_id=%d',[pCompanyId]));
       add(' ) AS ttype');
       add(' ORDER BY type_,id');
       result:=pStr.Text;
     end;
  // ---
  finally
   freeAndNil(pStr);
  end;
end;

function _CSQLGetAllAccounts(const pExcludeClosedAccounts : Boolean = true):AStr;
var
 pStr : TAStrList;
begin
   try
         pStr:=TAStrList.Create;
    with pStr do
     begin
        add(' SELECT a.id,a.parent_id, ');
        add(' a.account_coding, a.account_name,a.default_currency, a.company_id, ');
        add(' a.init_balance,a.type_id,a.typecls_id,c.name as account_typelong,c.shortidef as account_type,');
        add(' c1.name as account_classname,a.flags, ');
        add(' a.rec_changed, a.rec_changedby,a.rec_addedby,a.rec_deleted,a.bank_id, ');
        add(' a.account_nr,a.account_nr_iban,a.display_onbill,a.display_billtypes,a.balance_rep_line_id,a.incstat_rep_line_id ');
        add(' FROM accounts a ');
        //' LEFT OUTER JOIN account_group b ON '
        //' b.id=a.account_group_id '+
        add(' LEFT OUTER JOIN classificators c ON ');
        add(' c.type_=''account_type'' AND c.id=a.type_id ');
        add(' LEFT OUTER JOIN classificators c1 ON ');
        add(' c1.type_=''account_classificator'' AND c1.id=a.typecls_id ');
        //' c.type_=''account_type'' AND c.id=a.classificator_id '+
        //' WHERE a.company_id IN (0,:company_id) '+ // tegi päringu liiga aeglaseks !!! 13.03.2011 Ingmar
        add(' WHERE a.company_id=:company_id ');
        add('   AND a.rec_deleted=''f'' ');

     if pExcludeClosedAccounts then
        add('   AND a.flags=0'); // hetkel on nii, et flagsi kasutatakse vaid märkimaks, et konto suletud !
        add('  ORDER BY a.account_coding ASC ');
        //' ORDER BY a.account_name ';
        result:=pStr.Text;
     end;

   finally
      freeAndNil(pStr);
   end;
end;


// 11.03.2011 Ingmar; selline väike aga, et ostuarvete ja müügiarvete tasumistest tuleb maha lahutada kreeditarve summa, kuidas ma selle unustasin
function _crbillsum(const pBillAlias : AStr = 'b.'):AStr;
var
 pStr : TAStrList;
begin
   try
         pStr:=TAStrList.Create;
    with pStr do
     begin
       Add('(SELECT CAST(COALESCE(SUM(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine),0) AS '+TEstbk_MapDataTypes.__MapMoneyType()+')');
       Add(' FROM bills ccb');
       Add(' WHERE ccb.id='+pBillAlias+'.id');
       Add(format('  AND ccb.bill_type=%s',[QuotedStr(estbk_types._CItemCreditBill)]));
       Add('  AND ccb.status LIKE ''%C%%');
       Add('  AND ccb.rec_deleted=''f'')');
     end;

      // ---
      result:=pStr.Text;
      // ---
   finally
      freeAndNil(pStr);
   end;
end;

// TODO päring ära optimiseerida; tee subselectid ja group by ning sum
// 05.03.2011 Ingmar
function _SQLGetUnpaidBills(const pCompanyId  : Integer;
                            const pBillType   : AStr;
                            const pClientId   : Integer = -1;
                            const pDaysOver   : Integer = 0;
                            const pBillsUntil : TDatetime = Nan; // arved kuni <=
                            const pBillCurrency : AStr = '';
                            const pOnlyPartiallyPaidBills : Boolean = false;
                            const pSalePerson : Integer = -1;
                            const pSortByField: Integer = 0;
                            const pSortOrderAZ: Boolean = true
                            ):AStr;
var
 pStr : TAStrList;
begin
   try
         pStr:=TAStrList.Create;
    with pStr do
     begin
         Add('SELECT s.client_id,s.bill_number,s.bill_date,s.due_date,s.bill_sum,(s.to_pay-s.incomesum_dt) as to_pay,');
         Add('(s.paid+s.incomesum_dt) as paid,s.currency,s.currency_drate_ovr,s.dover,s.client_name,s.phone,email');
         Add('FROM (');

         // SUB ---
         Add('SELECT b.client_id,b.bill_number,b.bill_date,b.due_date,');

         // 13.03.2011 Ingmar; lisasin kreeditarve toetuse ! st algsest arvest - kreeditarve !
         Add('CAST(b.totalsum+b.roundsum+b.vatsum+b.fine AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as bill_sum,');

         // 30.08.2011 Ingmar;  -b.uprepaidsum nüüd + märgiga, sest tabelis on ta neg !
         //Add('CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum AS '+TEstbk_MapDataTypes.__MapMoneyType()+')+');
         //Add('CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as to_pay,');

         Add('CAST(b.totalsum+b.roundsum+b.vatsum+b.fine-b.prepaidsum+b.uprepaidsum AS '+TEstbk_MapDataTypes.__MapMoneyType()+')+');
         Add('CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as to_pay,');


     // [10:29:08] K: et kui võtan 12.01.2012 kuupäeva, siis seal kuvab kõiki neid arveid ainult, mis mingiski summas on selle kuupäeva seisuga tasumata
     if pBillType=estbk_types._CItemPurchBill then
       begin
        // --
        if not isNan(pBillsUntil) then
          begin
             Add('COALESCE(');
             Add('(');
             Add('  SELECT SUM(d.splt_sum) ');
             Add('  FROM payment p');
             Add('  INNER JOIN payment_data d ON');
             Add('  d.payment_id=p.id AND d.item_id=b.id AND d.item_type=''B'' AND d.status NOT LIKE ''%D%''');
             Add('  INNER JOIN accounting_register a ON');
             Add('  a.id=p.accounting_register_id');
             Add('  WHERE p.status=''C''');
             Add('    AND p.rec_deleted=''f''');
             Add(format('    AND p.payment_date<=%s',[QuotedStr(datetoOdbcStr(pBillsUntil))]));
             Add('),0.00) as incomesum_dt,'); // summa laekunud kuupäevaks X
          end else
             Add('b.incomesum as incomesum_dt,');
       end else
       begin
        // --
        if not isNan(pBillsUntil) then
          begin
             Add('COALESCE(');
             Add('(');
             Add('  SELECT SUM(i.conv_income_sum)');
             Add('  FROM incomings i');
             Add('  INNER JOIN incomings_bank n ON');
             Add('  n.id=i.incomings_bank_id');
             Add('  WHERE i.bill_id=b.id');
             Add('    AND i.status=''''');
             Add('    AND n.status=''C''');
             Add('    AND n.rec_deleted=''f''');
             Add(format('    AND i.incoming_date<=%s',[QuotedStr(datetoOdbcStr(pBillsUntil))]));
             Add('),0.00) as incomesum_dt,');
          end else
             Add('b.incomesum as incomesum_dt,');
       end;

         //Add('CAST(b.incomesum+b.prepaidsum+b.uprepaidsum AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as paid,');
         Add('CAST(b.prepaidsum+b.uprepaidsum AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as paid,');
         Add('b.currency,b.currency_drate_ovr,');

         Add(sqlp._datediff('b.due_date',sqlp._getCurrDateTime())+' AS dover,');
         Add('CAST('+sqlp._doSafeSQLStrConcat([AStr('c.name'),AStr(''' '''),AStr('c.lastname')])+' AS '+TEstbk_MapDataTypes.__MapVarcharType(255)+') as client_name,');
         Add('CAST('+sqlp._doSafeSQLStrConcat([AStr('w.name'),AStr(''' '''),AStr('w.lastname')])+' AS '+TEstbk_MapDataTypes.__MapVarcharType(255)+') as saleperson_name,');

         Add('c.phone,c.email');

         Add('FROM  bills b');
         Add('INNER JOIN client c ON');
         Add('c.id=b.client_id');


         // 13.03.2011 Ingmar
         Add(' LEFT OUTER JOIN  bills ccb ON ');
         Add('ccb.id=b.credit_bill_id');
         Add(format('  AND ccb.bill_type=%s',[QuotedStr(estbk_types._CItemCreditBill)]));
         Add('  AND ccb.status LIKE ''%C%''');
         Add('  AND ccb.rec_deleted=''f''');


         Add('LEFT OUTER JOIN users w ON');
         Add('w.id=b.saleperson_id');
         Add(format('WHERE b.bill_type=%s',[QuotedStr(pBillType)]));
         Add(format(' AND b.company_id=%d',[pCompanyId]));


      if pClientId>0 then
         Add(format(' AND b.client_id=%d',[pClientId]));

      if pSalePerson>0 then
         Add(format(' AND b.saleperson_id=%d',[pSalePerson]));

      if not isNan(pBillsUntil) then
         Add(format(' AND b.bill_date<=%s',[QuotedStr(datetoOdbcStr(pBillsUntil))]));

      if not isNan(pBillsUntil) then
        begin

          if pBillType=estbk_types._CItemPurchBill then
            begin
               //
              Add('AND ');
              Add('COALESCE(');
              Add('(');

              Add('  SELECT SUM(d.splt_sum) ');
              Add('  FROM payment p');
              Add('  INNER JOIN payment_data d ON');
              Add('  d.payment_id=p.id AND d.item_id=b.id AND d.item_type=''B'' AND d.status NOT LIKE ''%D%''');
              Add('  INNER JOIN accounting_register a ON');
              Add('  a.id=p.accounting_register_id');
              Add('  WHERE p.status=''C''');
              Add('    AND p.rec_deleted=''f''');
              Add(format('    AND p.payment_date<=%s',[QuotedStr(datetoOdbcStr(pBillsUntil))]));
              Add('),0.00)<>(b.totalsum+b.roundsum+b.vatsum)+COALESCE((ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine),0.00)');

            end else
            begin
              Add('AND ');
              Add('COALESCE(');
              Add('(');
              Add('  SELECT SUM(i.conv_income_sum)');
              Add('  FROM incomings i');
              Add('  INNER JOIN incomings_bank n ON');
              Add('  n.id=i.incomings_bank_id');
              Add('  WHERE i.bill_id=b.id');
              Add('    AND i.status=''''');
              Add('    AND n.status=''C''');
              Add('    AND n.rec_deleted=''f''');
              Add(format('    AND i.incoming_date<=%s',[QuotedStr(datetoOdbcStr(pBillsUntil))]));
              Add('),0.00)<>(b.totalsum+b.roundsum+b.vatsum)+COALESCE((ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine),0.00)');
            end; // ---
        end else
        begin

        // -- 06.03.2011 Ingmar ainult kinnitatud arved !
        if   pOnlyPartiallyPaidBills then
             Add(format(' AND b.payment_status=%s',[QuotedStr(CBillPaymentPt)]))
        else
             Add(format(' AND b.payment_status<>%s',[QuotedStr(CBillPaymentOk)]));
        end;

         // ---
         Add(' AND ((b.totalsum+b.roundsum+b.vatsum)+COALESCE((ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine),0.00)<>0.00)');
         Add(format(' AND b.status=%s',[QuotedStr(estbk_types.CBillStatusClosed)]));


      if pBillCurrency<>'' then
         Add(format(' AND b.currency=%s',[QuotedStr(pBillCurrency)]));

         // mida teeme siis, kui arvele tehtud kreeditarve ?!?
         //Add(' AND b.credit_bill_id=0');
         Add('ORDER BY ');

        case pSortByField of
            0: Add('c.lastname '+estbk_types.SCAscDesc[pSortOrderAZ]+',c.name '+estbk_types.SCAscDesc[pSortOrderAZ]+',b.due_date');
            1: Add('b.due_date'+estbk_types.SCAscDesc[pSortOrderAZ]);
            // 30.08.2011 Ingmar;  -b.uprepaidsum nüüd + märgiga, sest tabelis on ta neg !
            2: Add('(b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum)+COALESCE((ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine),0.00) '+estbk_types.SCAscDesc[pSortOrderAZ]);
            3: Add('b.bill_date '+estbk_types.SCAscDesc[pSortOrderAZ]);
        else
            Add('b.bill_date '+estbk_types.SCAscDesc[pSortOrderAZ]);
        end;
          // END SUB
          Add(') As s');

     end;

     // ---
     //pStr.SaveToFile('c:\debug\test.txt');
     result:=pStr.Text;
   finally
     freeAndNil(pStr);
   end;
end;


// 25.02.2011
function _SQLSelectRefDFormLines(const pFormId      : Integer;
                                 const pFormRefType : AStr = 'B'
                                 ):AStr;
var
 pStr      : TAStrList;
 pMaxIdRel : Boolean;
begin
   try
         pStr:=TAStrList.Create;
    with pStr do
     begin
      pMaxIdRel:=false;
      add('SELECT d.form_name,d.form_type,d.valid_from,d.valid_until,l.id as line_id,');
      add('l.baserecord_id,l.line_descr,l.row_nr,l.row_id,a.account_coding,');
      add('a.account_name,a.default_currency,c.shortidef');
      add('FROM formd d');
      add('INNER JOIN formd_lines l ON ');
      add('l.formd_id=d.id AND l.rec_deleted=''f''');
      add('INNER JOIN accounts a ON ');

   if pFormRefType=estbk_types.CFormTypeAsBalance then
     begin
      pMaxIdRel:=true;
      add('l.baserecord_id=a.balance_rep_line_id');
     end else
   if pFormRefType=estbk_types.CFormTypeAsIncStatement then
     begin
      pMaxIdRel:=true;
      add('l.baserecord_id=a.incstat_rep_line_id');
     end else
      add('a.id=0');

      add('INNER JOIN classificators c ON ');
      add('c.id=a.type_id');
      add(format('WHERE d.id=%d',[pFormId]));
      add(' AND  d.rec_deleted=''f''');

   if pMaxIdRel then
      add('AND l.id=(SELECT max(l1.id) FROM formd_lines l1 WHERE l1.baserecord_id=l.baserecord_id AND l1.rec_deleted=''f'')');


      add(' ORDER BY l.row_nr');
     end;

     //pStr.SaveToFile('c:\test.txt');
     // ---
     result:=pStr.Text;
   finally
     freeAndNil(pStr);
   end;
end;

// -- aruande read; ntx combo valikud
function _SQLSelectFormLines(const pCompanyId : Integer;
                             const pFormType  : AStr):AStr;
var
 pStr : TAStrList;
begin
  try
       pStr:=TAStrList.Create;
  with pStr do
   begin
      add('SELECT d.id as formid,l.id as lineid,l.line_descr,l.row_nr,l.row_id,l.log_nr,l.formula,l.flags,l.baserecord_id');
      add('FROM formd d');
      add('INNER JOIN formd_lines l ON');
      add('l.formd_id=d.id AND l.rec_deleted=''f''');
      add(format('WHERE d.form_type=%s AND d.company_id=%d AND d.rec_deleted=''f''',[QuotedStr(pFormType),estbk_globvars.glob_company_id]));
      add('ORDER BY l.row_nr ASC');
      // ---
      result:=pStr.Text;
   end;

  finally
      freeAndNil(pStr);
  end;
end;


function _SQLSrcIncomings(const pCompanyId : Integer;
                          const pClientId  : Integer = -1;
                          const pRefNr : AStr = '';
                          const pIncNr : AStr = '';
                          const pAccountId : Integer = -1; // rp konto
                          const pFilename  : AStr = '';
                          const pIncSource : Byte = 0; // 0;  1:käsitsi     2: failist
                          const pIncStatus : Byte = 0; // 0;  1:kinnitatud  2: kinnitamata
                          const pIncDateStart : TDatetime = Nan;
                          const pIncDateEnd : TDatetime = Nan):AStr;


var
 pStr : TAStrList;
 pMaxRows : Integer;

begin
     result:='';
     pMaxRows:=CDefaultMaxRows;

 if (pClientId<>0) or
    (pRefNr<>'') or
    (pIncNr<>'') or
    (pAccountId>0)  or
    (pFilename<>'') or
//    (pIncSource>0)  or
//    (pIncStatus>0)  or
    (not isnan(pIncDateStart))  or
    (not isnan(pIncDateEnd))  then
     pMaxRows:=9999;

  // ------
  try
       pStr:=TAStrList.Create;
  with pStr do
   begin
               // CIncSrcFromBank = 'B'
               // CIncSrcManual   = 'M'
               add('SELECT '+estbk_dbcompability.sqlp._getHdrLimitRowsSQL(1000,0));

               add(' b.id as parent_entry_id,b.bank_id,CAST(k.name AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarcharType(40)+') as bank_name,');
               add(' b.bank_code,b.bank_archcode, (CASE WHEN COALESCE(b.payer_name,'''') != '''' THEN b.payer_name ELSE c.name END) AS payer_name,');
               add(' b.payer_refnumber,payer_mk_nr,b.payment_sum,b.currency,b.currency_drate_ovr,b.receiver_account_number,');
               add(' b.receiver_account_number_iban,b.payment_date,b.description,');
               add(' b.incoming_date,b.bank_account,b.status,');
               add(' b.bank_account,b.bank_account_iban,');

               add(' (SELECT DISTINCT a.entrynumber');
               add(' FROM incomings i');
               add(' INNER JOIN accounting_register a ON');
               add(' a.id=i.accounting_register_id');
               add(' WHERE i.incomings_bank_id=b.id');
               add('  AND i.status NOT LIKE ''%D%'') as income_number,');

               add(' q.account_coding,q.account_name,s.filename, c.name AS fullname');
               add(' FROM incomings_bank b');
               add(' LEFT OUTER JOIN client c ON');
               add(' c.id=b.client_id');
               add(' LEFT OUTER JOIN banks k ON');
               add(' k.id=b.bank_id');
               add(' INNER JOIN incomings_sessions s ON');
               add(' s.id=b.incomings_session_id');

            if trim(pFilename)<>'' then
               add(format(' AND s.filename LIKE %s',[QuotedStr(copy(trim(pFilename),1,255))]));

          // --
          //CIncSrcFromBank = 'B';
          //CIncSrcManual   = 'M';
          case pIncSource of
            1: add(' AND s.type_=''M'''); // käsitsi
            2: add(' AND s.type_=''B'''); // pank
          end;


              // AND s.type_='M' -- AND s.filename LIKE 'D'
              add(' INNER JOIN accounts q ON');
              add(' q.id=b.bank_bk_account_id');


              add(format(' WHERE b.status NOT LIKE ''%%D%%'' AND s.company_id=%d',[pCompanyId])); // ei tohi olla kustutatud


          // -- kirje staatus
          case pIncStatus of
            1: add(' AND b.status LIKE ''%C%'''); // kinnitatud
            2: add(' AND b.status NOT LIKE ''%C%'''); // kinnitamata
          end;


         if not isNan(pIncDateStart) then
            add(format(' AND b.payment_date>=%s',[QuotedStr(datetoOdbcStr(pIncDateStart))]));

         if not isNan(pIncDateEnd) then
            add(format(' AND b.payment_date>=%s',[QuotedStr(datetoOdbcStr(pIncDateEnd))]));

         if pAccountId>0 then
            add(format(' AND b.bank_bk_account_id=%d',[pAccountId]));

         if pClientId>0 then
            add(format(' AND b.client_id=%d',[pAccountId]));

         if trim(pRefNr)<>'' then
            add(format(' AND b.payer_refnumber=%s',[QuotedStr(pRefNr)]));

         // laekumise number
         if trim(pIncNr)<>'' then
           begin
            add(' AND EXISTS(SELECT a.id');
            add('            FROM incomings i');
            add('            INNER JOIN accounting_register a ON');
            add(format('            a.id=i.accounting_register_id AND a.entrynumber=%s',[QuotedStr(pIncNr)]));
            add('            WHERE i.incomings_bank_id=b.id');
            add('              AND i.status NOT LIKE ''%D%'')');
           end;
           // -- 20.10.2011 Ingmar
           add('  AND b.rec_deleted=''f''');

           // --
           add('ORDER BY b.id DESC'); // uuemad eespool !
   end;
      // ---
      result:=pStr.Text;
  finally
      freeAndNil(pStr);
  end;
end;


// --> LAEKUMISTE INFO AKEN !
// ARVE / TELLIMUSTE LAEKUMISED
function _SQLItemPaymentInfo(const pCompanyId : Integer;
                                const pClientId  : Integer = -1;
                                const pBillId  : Integer = -1;
                                const pOrderId : Integer = -1;
                                const pItemDetails : Boolean = true
                                ):AStr;
var
 pStr : TAStrList;
begin
    result:='';
if (pClientId>0) or (pBillId>0) or (pOrderId>0) then
  try
       pStr:=TAStrList.Create;
  with pStr do
   begin

        // LAEKUMISED PANGAST !
        add('SELECT DISTINCT ');
        add(format('%s as source,',[QuotedStr(estbk_strmsg.SSpmtSourceAsBank)]));

        add('i.client_id,');
        add('i.bill_id,');
        add('i.order_id,');
        add('i.incoming_date,');
        add('i.payment_date,');
        add('i.income_sum,');
        add('i.currency,');

        add('i.conv_income_sum,');
        add('i.conv_currency,');
        add('i.conv_currency_drate_ovr,');

        add('i.accounting_register_id,');
        add('i.direction,');
        add('c.account_coding as acc_for_bank,');
        add('c.account_name as acc_for_bank_name,');
        add('c.default_currency as acc_for_bank_curr,');
        add('b.name as bank_long_name,');
        add('b.lcode,');
        add('b.swift,');
        add('n.bank_code,');
        add('n.bank_archcode,');
        add('n.payer_name,');
        add('n.payer_refnumber,');
        add('n.payer_mk_nr,');
        add('n.payment_sum,');
        add('i.currency,');
        add('i.currency_drate_ovr,');


        add('n.description,');
        // kliendi konto nr mille pealt laekus
        add('n.bank_account,');
        add('n.bank_account_iban,');
        add('c1.account_coding as acc_item_coding,');
        add('c1.account_name as acc_item_name,');
        add('c1.default_currency as acc_item_curr,');
        add('s.session_name,');
        add('s.filename,');
        // ehk siis konto mille peale summa laekus
        add('n.receiver_account_number,');
        add('n.receiver_account_number_iban,');

        // kas kinnitatud /  kinnitamata
        add('n.status,');

        add('(SELECT acc.entrynumber FROM accounting_register acc WHERE acc.id=i.accounting_register_id) as acc_number,');

        add('u.name as icr_firstname,');
        add('u.lastname as icr_lastname');

     // ---
     if pItemDetails then
       begin
        add(',COALESCE(l.bill_number,o.order_nr) as srcitem_nr,');
        add('COALESCE(l.bill_date,o.order_date) as srcitem_date');
       end;


        add('FROM incomings i');
        add('INNER JOIN accounts c ON');
        add('c.id=i.account_id');
        add('LEFT OUTER JOIN incomings_bank n ON');
        add('n.id=i.incomings_bank_id');
        add('LEFT OUTER JOIN incomings_sessions s ON');
        add('s.id=n.incomings_session_id');
        add('LEFT OUTER JOIN accounts c1 ON');
        add('c1.id=n.bank_bk_account_id');
        add('LEFT OUTER JOIN banks b ON');
        add('b.id=c1.bank_id');

        add('LEFT OUTER JOIN users u ON');
        add('u.id=s.rec_addedby');

    // ---
    if pItemDetails then
      begin
        add('LEFT OUTER JOIN bills l ON');
        add('l.id=i.bill_id');

        add('LEFT OUTER JOIN orders o ON');
        add('o.id=i.order_id');
      end;


        add(format('WHERE i.company_id=%d',[pCompanyId]));

    if  pClientId>0 then
        add(format(' AND i.client_id=%d',[pClientId]));

    if  pBillId>0 then
        add(format(' AND i.bill_id=%d',[pBillId]));

    if  pOrderId>0 then
        add(format(' AND i.order_id=%d',[pOrderId]));

        // ---
        add('  AND i.status NOT LIKE ''%D%''');

        // ---
        add(' UNION ');






        // TASUMINE KASSAST
        add('SELECT DISTINCT');
        add(format('%s as source,',[QuotedStr(estbk_strmsg.SSpmtSourceAsCashReg)]));

        add(' p.client_id,');
        add(' 0 as bill_id,');
        add(' 0 as order_id,');
        add(' p.payment_date as incoming_date,');
        add(' p.payment_date as payment_date,');
        add(' d.splt_sum as income_sum,'); // summa, mis märgiti konkreetselt sellele elemendile !
        add(' p.currency,');

        add(' d.splt_sum as conv_income_sum,');
        add(' p.currency as conv_currency,');
        add(' p.currency_drate_ovr as conv_currency_drate_ovr,');


        add(' p.accounting_register_id,');
        add(' ''I'' as direction,');

        add('c.account_coding as acc_for_bank,');
        add('c.account_name as acc_for_bank_name,');
        add('c.default_currency as acc_for_bank_curr,');
        add(' '''' as bank_long_name,');
        add(' '''' as lcode,');
        add(' '''' as swift,');
        add(' '''' as bank_code,');
        add(' '''' as bank_archcode,');
        add(' p.client_name2 as payer_name,');
        add(' '''' as payer_refnumber,');
        add(' '''' as payer_mk_nr,');
        add(' d.splt_sum as payment_sum,');
        add(' p.currency,');
        add(' p.currency_drate_ovr,');


        add(' p.descr as description,');
        // kliendi konto nr mille pealt laekus
        add(' '''' as bank_account,');
        add(' '''' as bank_account_iban,');
        add(' '''' as acc_item_coding,');
        add(' '''' as acc_item_name,');
        add(' '''' as acc_item_curr,');
        add(' '''' as session_name,');
        add(' '''' as filename,');
        // ehk siis konto mille peale summa laekus
        add(' '''' as receiver_account_number,');
        add(' '''' as receiver_account_number_iban,');

        // kas kinnitatud /  kinnitamata
        add('p.status,');

        add('(SELECT acc.entrynumber FROM accounting_register acc WHERE acc.id=p.accounting_register_id) as acc_number,');

        add(''''' as icr_firstname,');
        add(''''' as icr_lastname');

     // ---
     if pItemDetails then
       begin
        add(','''' as srcitem_nr,');
        add(' '''' as srcitem_date');
       end;




        //add('p.payment_date,');
        //add('p.document_nr,');
        //add('p.payer_account_nr,'); // ehk siis meie rp. kontoga seotud pangakonto !
        //add('p.payment_rcv_name,');
        //add('p.payment_rcv_account_nr,');
        //add('p.sumtotal,');
        //add('p.status,');
        //add('p.card_payment,');
        //add('p.card_nr,');
        //add('b.name as bank_long_name,');
        //add('b.lcode,');
        //add('b.swift');

        add('FROM payment p');
        add('INNER JOIN payment_data d ON');
        add('p.id=d.payment_id ');

     if pBillId>0 then
        add(format(' AND d.item_id=%d AND d.item_type=%s AND d.status NOT LIKE ''%%D%%''',[pBillId,QuotedStr(estbk_types.CCommTypeAsBill)]));

     if pOrderId>0 then
        add(format(' AND d.item_id=%d AND d.item_type=%s AND d.status NOT LIKE ''%%D%%''',[pOrderId,QuotedStr(estbk_types.CCommTypeAsOrder)]));

        add('INNER JOIN accounts c ON ');
        add('c.id=(CASE WHEN p.d_account_id>0 THEN d_account_id ELSE p.c_account_id END)');
        add('LEFT OUTER JOIN banks b ON ');
        add('b.id=c.bank_id ');
        add(format('WHERE p.company_id=%d',[pCompanyId]));
        // add( ' AND p.payment_type=''P'''); ka kassa lubada ?!?

    if  pClientId>0 then
        add(format(' AND p.client_id=%d',[pClientId]));

        add('ORDER BY payment_date DESC');

        //pStr.SaveToFile('c:\test.txt');
        result:=pStr.Text;
   end;

  // ---
  finally
      freeAndNil(pStr);
  end;
end;



// SALDO seisuga X
function _SQLSelectAccountInitBalance(const dCompanyId   : Integer;
                                      const dAccMainRecExtSQL : Astr = '';  // accounting_register.
                                      const dAccExtSQL        : Astr = '';  // accounts.
                                      const dAccRecExtSQL     : Astr = ''   // accounting_records.
                                      ):AStr;
var
 pStr : TAStrList;
begin
  try
       pStr:=TAStrList.Create;
  with pStr do
   begin
//    a.account_id,a.rec_type,c.shortidef as account_type
      add('SELECT  sum(accounting_records.rec_sum)');
      add('FROM  accounting_records  ');
      add('INNER JOIN accounting_register  ON ');
      add(' accounting_register.id=accounting_records.accounting_register_id AND ');
      add(' accounting_register.type_='+QuotedStr(estbk_types.CAccRecIdentAsInitBalance)+' AND ');
      add(' accounting_register.company_id='+inttostr(dCompanyId)+' AND ');
      // 27.11.2011 Ingmar
      add(' accounting_register.template=''f''');

   if dAccMainRecExtSQL<>'' then
      add(dAccMainRecExtSQL);

      // ---
      add('INNER JOIN accounts  ON ');
      add('accounts.id=accounting_records.account_id AND accounts.rec_deleted=''f''');

   if dAccExtSQL<>'' then
      add(dAccExtSQL);
      // ---
      add('LEFT OUTER JOIN classificators  ON ');
      add('classificators.id=accounts.type_id');
      add('WHERE accounting_records.status NOT LIKE ''%D%''');

   if dAccRecExtSQL<>'' then
      add(dAccRecExtSQL);
      // ---  // Aktiva=deebetsald passiva=kreeditsaldo tulud=kreeditsaldo kulud=deebetsaldo

      add(' AND accounting_records.rec_type=');
      add('(CASE ');
      add('   WHEN classificators.shortidef IN ('+QuotedStr(CAccTypeAsActiva)+','+QuotedStr(CAccTypeAsCost)+') THEN ''D''');
      add('   WHEN classificators.shortidef IN ('+QuotedStr(CAccTypeAsPassiva)+','+QuotedStr(CAccTypeAsProfit)+') THEN ''C''');
      add(' END )');

      result:=pStr.Text;
   end;
  finally
      freeAndNil(pStr);
  end;
end;



function _SQLSelectClassificators(const pClsIdentf : AStr;
                                  const pCompanyId : Integer;
                                  const pClsIdentAsType : Boolean = true // siis otsitakse tüübi järgi ! teisel juhul nime järgi
                                  ):AStr;
var
 pStr : TAStrList;
begin
  try
         pStr:=TAStrList.Create;
    with pStr do
     begin
        add('SELECT id,parent,shortidef,name as clsname,type_ as clstype,value');
        add('FROM classificators');
        add('WHERE ');
     if pClsIdentAsType then
        add(' type_='+quotedStr(pClsIdentf))
     else
        add(' name='+quotedStr(pClsIdentf));
        add(' AND company_id=0'); // vaikimisi seaded !

        add('UNION');

        add('SELECT id,parent,shortidef,name as clsname,type_ as clstype,value');
        add('FROM classificators');
        add('WHERE ');
     if pClsIdentAsType then
        add(' type_='+quotedStr(pClsIdentf))
     else
        add(' name='+quotedStr(pClsIdentf));
        add(format(' AND company_id=%d',[pCompanyId]));
        add('ORDER BY ID');
     end;
        // ---
        result:=pStr.Text;
  finally
        freeAndNil(pStr);
  end;
end;

function _SQLSelectGetTaxForms(const pDFormId         : Integer = 0;
                               const pDFormType       : AStr = '';
                               const pOnlyNonExpForms : Boolean = true;
                               const pCompanyId       : Integer = 0
                               ):AStr;
var
 pStr : TAStrList;
begin
  try
        pStr:=TAStrList.Create;
  with pStr do
   begin
       add('SELECT d.id,d.form_type,d.form_name,d.url,d.descr,d.valid_from,d.valid_until');
       add('FROM formd d');
       add('WHERE d.rec_deleted=''f''');

    if pCompanyId>0 then
       add(format(' AND d.company_id=%d',[pCompanyId]))
    else
       add(format(' AND d.company_id=%d',[estbk_globvars.glob_company_id]));

    if pDFormId>0 then
       add(format(' AND d.id=%d',[pDFormId]));

    // millise dekl. vormi kuvame
    if pDFormType<>'' then
       add(format(' AND d.form_type=%s',[quotedStr(pDFormType)]));


    if pOnlyNonExpForms then
      begin
       add(' AND (valid_from<='+quotedStr(datetoOdbcStr(now))+')');
       add(' AND (valid_until IS NULL) OR (valid_until>='+quotedStr(datetoOdbcStr(now))+')');
      end;

       // ---
       add('ORDER BY d.form_name');
       result:=pStr.Text;
   end;

  finally
      freeAndNil(pStr);
  end;
end;



// siin tuleb natuke nüansse eristada !
// kui on tegemist ostutellimusega, siis client_id=hankija
(*

   - on siis tellija firma/osakonna rekvisiidid

  o.county_id,c.name as county_name,o.city_id,c1.name as city_name,o.street_id,s.name as street_name,
  o.house_nr,o.apartment_nr,o.email,o.contact,o.mobilephone,
  c1.name as firstname,cl.lastname,cl.regnr

*)
// kui müügitellimus; siis on need tellija andmed;  kui olemas juba reg. client, siis client_id>0 muidu võib 0 olla
(*

c.name as county_name,o.city_id,c1.name as city_name,o.street_id,s.name as street_name,
o.house_nr,o.apartment_nr,o.email,o.contact,o.mobilephone,
c1.name as firstname,cl.lastname,cl.regnr

*)


function _SQLSrcOrders(const pOrderType   : Byte = 0; // Defineerimata = 0 / COrderTypeAsPurchOrder = 1 / COrderTypeAsSaleOrder  = 2
                       const pOrderStatus : Byte = 0; // Defineerimata = 0 / COrderStatusConfirmed   = 1 / COrderStatusUnConfirmed = 2
                       const pClientId : Integer = 0 ; // -- tulevikus tuleb lisada ka kontaktisik
                       const pOrderNr        : AStr = '';
                       const pOrderStartDate : TDatetime = Nan;
                       const pOrderEndDate   : TDatetime = Nan;
                       const pOrderContactPerson  : AStr = '';
                       const pFinalBillMustExists : Boolean = False
                       ):AStr;
var
 pStr : TAStrList;
begin
  try
        pStr:=TAStrList.Create;
  with pStr do
   begin
        add('SELECT '+estbk_dbcompability.sqlp._getHdrLimitRowsSQL(CDefaultMaxRows,0));
        add('o.id,o.order_nr,o.order_date,o.order_prp_due_date,o.order_type,o.status as order_status,');
        // summad eraldi !
        add('o.order_sum,o.order_roundsum,o.order_vatsum,');

        add('CAST(o.order_sum+o.order_roundsum+o.order_vatsum AS '+ estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as order_sumtotal,');
        add('o.paid_sum,o.payment_status,o.currency,o.county_id,c.name as county_name,o.city_id,y.name as city_name,o.street_id,s.name as street_name,');
        add('o.house_nr,o.apartment_nr,o.email,o.contact,o.mobilephone,o.order_ccperson,');
        add('o.client_id,k.name as firstname,k.lastname,k.regnr,');
        add('k.county_id as county_id2,c1.name as county_name2,k.city_id as city_id2,');
        add('y1.name as city_name2,k.street_id as street_id2,s1.name as street_name2,');
        add('k.house_nr as house_nr2,k.apartment_nr as apartment_nr2,');

        // mitu ettemaksuarvet
        add('(SELECT count(d.id)');
        add(' FROM order_billing_data d ');
        add(' INNER JOIN bills b ON');
        add(' b.id=d.item_id AND b.bill_type='+quotedStr(estbk_types._CItemPrepaymentBill));
        add('   AND b.credit_bill_id=0 AND b.status NOT LIKE ''%D%''');
        add(' WHERE d.order_id=o.id');
        add('   AND d.item_type='+quotedStr(estbk_types.CCommTypeAsBill));
        add('   AND d.status NOT LIKE ''%D%'') as prpbill_cnt,');

        // lõplik arve = teoorias 1-1 seos
        add('(SELECT count(d.id)');
        add(' FROM order_billing_data d ');
        add(' INNER JOIN bills b ON');
        add(' b.id=d.item_id AND b.bill_type IN ('+quotedStr(estbk_types._CItemSaleBill)+','+quotedStr(estbk_types._CItemPurchBill)+')');
        add(' AND b.credit_bill_id=0 AND b.status NOT LIKE ''%D%''');
        add(' WHERE d.order_id=o.id');
        add('   AND d.item_type='+quotedStr(estbk_types.CCommTypeAsBill));
        add('   AND d.status NOT LIKE ''%D%'') as fnbill_cnt');

        add('FROM orders o');
        add('INNER JOIN county c ON');
        add('c.id=o.county_id');
        add('INNER JOIN city y ON');
        add('y.id=o.city_id');
        add('INNER JOIN street s ON');
        add('s.id=o.street_id');
        add('LEFT OUTER JOIN client k ON');
        add('k.id=o.client_id');
        add('LEFT OUTER JOIN county c1 ON');
        add('c1.id=k.county_id');
        add('LEFT OUTER JOIN city y1 ON');
        add('y1.id=k.city_id');
        add('LEFT OUTER JOIN street s1 ON');
        add('s1.id=k.street_id');
        add('WHERE 1=1');
        // company_id


   // ---
   case pOrderStatus of
     1: add(' AND o.status='+quotedStr(estbk_types.COrderVerified)); //  COrderStatusConfirmed   = 1;
     2: add(' AND o.status='''''); //  COrderStatusUnConfirmed = 2;
   end;

   // ---
   case pOrderType of
     1: add(' AND o.order_type='+quotedStr(estbk_types._COAsPurchOrder)); // COrderTypeAsPurchOrder
     2: add(' AND o.order_type='+quotedStr(estbk_types._COAsSaleOrder));  // COrderTypeAsSaleOrder
   end;

   if pOrderNr<>'' then
      add(' AND o.order_nr LIKE '+quotedStr({$IFNDEF NOGUI}Copy{$ELSE}Copy{$ENDIF}(pOrderNr,1,35)));


 if  not  isNan(pOrderStartDate) or not isNan(pOrderEndDate) then
   begin

   // ---
   if isNan(pOrderStartDate) and not isNan(pOrderEndDate) then
      add(' AND o.order_date='+quotedStr(datetoOdbcStr(pOrderEndDate)))
   else
   if not isNan(pOrderStartDate) and  isNan(pOrderEndDate) then
      add(' AND o.order_date='+quotedStr(datetoOdbcStr(pOrderStartDate)))
   else
      add(' AND o.order_date BETWEEN '+quotedStr(datetoOdbcStr(pOrderStartDate))+' AND '+quotedStr(datetoOdbcStr(pOrderEndDate)));
   end;

   if pClientId<>0 then
      add(format(' AND o.client_id=%d',[pClientId]));

   if pOrderContactPerson<>'' then
      add(' o.order_ccperson LIKE '+quotedStr({$IFNDEF NOGUI}Copy{$ELSE}Copy{$ENDIF}(pOrderContactPerson,1,85)));


   if pFinalBillMustExists then
     begin
      add(' AND EXISTS (SELECT d.id');
      add('             FROM order_billing_data d ');
      add('             INNER JOIN bills b ON');
      add('                 b.id=d.item_id AND b.bill_type IN ('+quotedStr(estbk_types._CItemSaleBill)+','+quotedStr(estbk_types._CItemPurchBill)+')');
      add('             AND b.credit_bill_id=0 AND b.status NOT LIKE ''%D%''');
      add('             WHERE d.order_id=o.id');
      add('               AND d.item_type='+quotedStr(estbk_types.CCommTypeAsBill));
      add('               AND d.status NOT LIKE ''%D%'')');
     end;

      // --- 04.04.2011 Ingmar; firma oli ununenud !
      add(format(' AND o.company_id=%d',[estbk_globvars.glob_company_id]));

      add('ORDER BY o.status,o.order_date DESC');
      add(estbk_dbcompability.sqlp._getFtrLimitRowsSQL(CDefaultMaxRows,0));
      // ---
      result:=pStr.Text;

  end;

  finally
      freeAndNil(pStr);
  end;
end;

// 29.05.2011 Ingmar; item_descr => name
function _SQLSelectGetOrderPrepaymentBills(const pOrderId: Integer):AStr;
var
 pStr : TAStrList;
begin
  try
        pStr:=TAStrList.Create;
   with pStr do
    begin
      add('SELECT b1.bill_id,b1.discount_perc,b1.item_id,a.code as item_code,a.special_type_flags as item_flags,a.name as item_descr,');
      // add('a.descr as item_descr,');
      add('b1.item_price,ac1.account_coding as item_acc_coding,b1.item_account_id,b1.quantity,b1.total,b1.vat_id,v.perc as vat_perc,');
      add('v.flags as vat_flags,v.description as vat_descr,ac2.account_coding as vat_account_coding,b1.vat_account_id,b1.vat_rsum');
      add('FROM order_billing_data d');
      add('INNER JOIN bills b ON');
      add('b.id=d.item_id AND b.bill_type='+quotedStr(estbk_types._CItemPrepaymentBill)+' AND b.credit_bill_id=0 AND b.status NOT LIKE ''%D%''');
      add('INNER JOIN bill_lines b1 ON ');
      add('b1.bill_id=b.id AND b1.status NOT LIKE ''%D%''');
      add('INNER JOIN articles a ON');
      add('a.id=b1.item_id');
      add('INNER JOIN vat v ON');
      add('v.id=b1.vat_id ');
      add('LEFT OUTER JOIN accounts ac1 ON');
      add('ac1.id=b1.item_account_id');
      add('LEFT OUTER JOIN accounts ac2 ON');
      add('ac2.id=b1.vat_account_id');
      add('WHERE d.item_type='+quotedStr(estbk_types.CCommTypeAsBill));
      add('AND d.status NOT LIKE ''%D%''');
      add(format('AND d.order_id=%d',[pOrderId]));
       // ---
      result:=pStr.Text;

    end;

  finally
     freeAndNil(pStr);
  end;
end;

// tellimusest arve koostamine
function _SQLSelectOrderLines2(const pOrderId: Integer;
                               const pIsPurchBill : Boolean = true):AStr;
var
 pStr : TAStrList;
begin
  try
        pStr:=TAStrList.Create;
   with pStr do
    begin
      add(' SELECT l.id, l.item_id,a.code as item_code,l.partcode, l.quantity, l.price, l.price2, ');
      add(' a.name as artname, l.descr, l.unit, l.partcode,l.vat_id,l.vat_account_id,ac2.account_coding as vat_account_coding,l.vat_rsum,');
      add(' v.perc as vat_perc,v.description as vat_descr,v.flags as vat_flags,l.status,l.rec_changed,l.rec_changedby,');
      add(' i.id as inventory_id,i.status as invstatus,ac1.id as account_id,ac1.account_coding '); // account_coding artikli konto
      add(' FROM order_lines l');
      add(' LEFT OUTER JOIN articles a ON ');
      add(' a.id=l.item_id ');

      add(' LEFT OUTER JOIN accounts ac1 ON ');
   // millise artikli konto võtame
   if pIsPurchBill then
      add(' ac1.id=a.purchase_account_id')
   else
      add(' ac1.id=a.sale_account_id');
      add(' LEFT OUTER JOIN accounts ac2 ON ');
      add(' ac2.id=l.vat_account_id');
      // ---
      add(' LEFT OUTER JOIN inventory i ON ');
      add(' i.article_id=a.id AND NOT i.status LIKE ''%D%''');
      add(' LEFT OUTER JOIN vat v ON ');
      add(' v.id=l.vat_id ');
      add(format(' WHERE order_id=%d',[pOrderId]));
      add('   AND l.status NOT LIKE ''%D%''');
      add(' ORDER BY l.id ASC ');

      // ---
      result:=pStr.Text;
    end;

  finally
     freeAndNil(pStr);
  end;
end;

function _SQLGetOrderBillingData(const pOrderId : Integer;
                                 const companyId: Integer):AStr;
 var
  pStr : TAStrList;
 begin
   try
         pStr:=TAStrList.Create;
    with pStr do
     begin
        add('SELECT  b.bill_number,b.bill_date,b.payment_date,b.bill_type,b.status,b.totalsum,b.roundsum,b.vatsum,');
        add('        b.currency,b.currency_id,b.currency_drate_ovr,b.accounting_register_id');
        add('FROM order_billing_data o');
        add('INNER JOIN bills b ON');
        add(format('b.id=o.item_id AND b.company_id=%d AND b.status NOT LIKE ''%%D%%''',[companyId]));
        add(format('WHERE o.order_id=%d',[pOrderId]));
        add('    AND o.item_type='+quotedStr(estbk_types.CCommTypeAsBill));
        add('    AND o.status NOT LIKE ''%D%''');
        // ---
        result:=pStr.Text;
     end;

   finally
     freeAndNil(pStr);
   end;
end;


// vaatame, kuhu ja mis summad kandega peale läinud ! arve / tellimus jne
function _SQLGetPaymentRefItems(const pAccMainRecId : Integer):AStr;
var
 pStr : TAStrList;
begin
  try
        pStr:=TAStrList.Create;
   with pStr do
    begin
       // :: ARVE
       add('SELECT a1.id,a1.ref_item_type,a1.ref_item_id,a1.rec_sum,a1.currency_vsum,a1.currency,a1.rec_type,');
       add('       a1.ref_prepayment_flag,a1.ref_payment_flag,a1.ref_debt_flag,a1.ref_income_flag,a1.flags,');

       // 13.03.2011 Ingmar
       add('      CAST(b1.totalsum+b1.roundsum+b1.vatsum+b1.fine AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+')+');
       add('      CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as topay,'); // tasuda

       add('       b1.incomesum,');   // makstud
       add('       b1.prepaidsum,');  // ettemaks
       add('       b1.uprepaidsum');  // teiste arvete pealt tekkinud ettemaksu summa st mis ära kasutati selle arve tasumiseks

       add(' FROM accounting_records a1');
       add(' INNER JOIN bills b1 ON');
       add(' b1.id=a1.ref_item_id');

       // 13.03.2011 Ingmar
       Add('LEFT OUTER JOIN  bills ccb ON ');
       Add('ccb.id=b1.credit_bill_id');
       Add(format('  AND ccb.bill_type=%s',[QuotedStr(estbk_types._CItemCreditBill)]));
       Add('  AND ccb.status LIKE ''%C%''');
       Add('  AND ccb.rec_deleted=''f''');

       add(format(' WHERE a1.accounting_register_id=%d',[pAccMainRecId]));
       add(' AND a1.ref_item_type='+QuotedStr(estbk_types.CCommTypeAsBill));
       add(' AND a1.ref_item_id>0');
       // 17.02.2011 Ingmar
       //add(' AND b1.credit_bill_id=0');

       // kõik tore, aga sama registri annuleeritud kirjeid me enam ei kuva !
       add(' AND NOT EXISTS(SELECT n.id FROM accounting_records n WHERE n.archive_rec_id=a1.id)');
       add(' AND a1.status not like ''%D%''');

       add('UNION ALL');

       // ::  TELLIMUS
       add('SELECT a2.id,a2.ref_item_type,a2.ref_item_id,a2.rec_sum,a2.currency_vsum,a2.currency,a2.rec_type,');
       add('       a2.ref_prepayment_flag,a2.ref_payment_flag,a2.ref_debt_flag,a2.ref_income_flag,a2.flags,');

       add('      CAST(o2.order_sum+o2.order_roundsum+o2.order_vatsum AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as topay,'); // tasuda
       add('      paid_sum AS incomesum,');  // makstud
       add('       CAST(0 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as prepaidsum,');
       add('       CAST(0 AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType()+') as uprepaidsum');
       add(' FROM accounting_records a2');
       add(' INNER  JOIN orders o2 ON');
       add(' o2.id=a2.ref_item_id ');
       add(format(' WHERE a2.accounting_register_id=%d',[pAccMainRecId]));
       add(' AND a2.ref_item_type='+QuotedStr(estbk_types.CCommTypeAsOrder));
       add(' AND a2.ref_item_id>0');

       // kõik tore, aga sama registri annuleeritud kirjeid me enam ei kuva !
       add(' AND NOT EXISTS(SELECT n.id FROM accounting_records n WHERE n.archive_rec_id=a2.id)');
       add(' AND a2.status not like ''%D%''');

       // ÄRA MUUDA !
       add('ORDER BY ref_item_id,ref_item_type');
       // ---
       result:=pStr.Text;

       //@@debug
       //pStr.SaveToFile('c:\debug\refitems.txt');
    end;

  finally
    freeAndNil(pStr);
  end;
end;


// KONTROLLIDA !
(*
   Üldiselt kontrollib, kas antud kandega seotud ettemaksu on kusagil juba kasutatud; arve/tellimus jne
   Sellega saame teada, et JAH selle makse ettemaksu on kasutatud !
   - järgmise SQL saame siis tead need arved/tellimused, kus seda kasutatud !
*)

function _SQLCheckIsCurrPaymentPrePaymentUsed(const pAccMainRecId : Integer):AStr;
var
 pStr : TAStrList;
begin
  try
        pStr:=TAStrList.Create;
   with pStr do
    begin
       add('SELECT  ');

       // algse raamatupidamiskande andmed
       add(' c1.id,c1.ref_item_type,c1.ref_item_id,c1.rec_sum,c1.currency_vsum,c1.currency,c1.rec_type,');
       add(' c1.ref_prepayment_flag,c1.ref_payment_flag,c1.ref_debt_flag,');

       // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       // arve või tellimus millele ettemaks märgiti; ka lähtekande andmed
       // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

       add(' COALESCE(b1.bill_number,o1.order_nr) as srcitem_nr,');
       add(' COALESCE(b1.bill_date,o1.order_date) as srcitem_date,');

       add(' c2.id as id2,c2.ref_item_type as ref_item_type2,c2.ref_item_id as ref_item_id2,');
       add(' c2.rec_sum as rec_sum2,c2.currency_vsum as currency_vsum2,c2.currency as currency2,c2.rec_type as rec_type2,');
       add(' c2.ref_prepayment_flag as ref_prepayment_flag2,c2.ref_payment_flag as ref_payment_flag2,c2.ref_debt_flag as ref_debt_flag2');

       add('FROM accounting_records c1');

       // vaatame, kus meie kandekirjet on kasutatud !
       add('INNER JOIN accounting_prepayment_usage u ON ');
       add('u.accounting_src_record_id=c1.id AND u.status<>''%D%''');
       // --
       add('INNER JOIN  accounting_records c2 ON');
       add('c2.id=u.accounting_dest_record_id AND c2.status<>''%D%''');

       add(' LEFT OUTER JOIN bills b1 ON');
       add(' b1.id=(CASE WHEN c2.ref_item_type='+QuotedStr(estbk_types.CCommTypeAsBill)+' THEN c2.ref_item_id ELSE -1 END)');

       add(' LEFT OUTER JOIN orders o1 ON');
       add(' o1.id=(CASE WHEN c2.ref_item_type='+QuotedStr(estbk_types.CCommTypeAsOrder)+' THEN c2.ref_item_id ELSE -1 END)');


       add(format('WHERE c1.accounting_register_id=%d',[pAccMainRecId]));
       add('  AND c1.status=''''');
       // ref_prepayment_flag=''t''
       // ---
       result:=pStr.Text;

    end;

 finally
    freeAndNil(pStr);
 end;
end;

{
TAASTADA st ümber kirjutada !
function _SQLGetAccRecsWherePrepaymentIsUsed(const pAccChldRecId : Int64):AStr;
var
  pStr : TAStrList;
begin
 try
         pStr:=TAStrList.Create;
    with pStr do
     begin

        add('SELECT a1.id,a1.ref_item_type,a1.ref_item_id,a1.rec_sum,a1.currency_vsum,a1.currency,a1.rec_type,');
        add('a1.ref_prepayment_flag,a1.ref_payment_flag,a1.ref_debt_flag,');
        add(' COALESCE(b1.bill_number,o1.order_nr) as srcitem_nr,');
        add(' COALESCE(b1.bill_date,o1.order_date) as srcitem_date');
        add(' FROM accounting_records a1');

        add(' LEFT OUTER JOIN bills b1 ON');
        add(' b1.id=(CASE WHEN a1.ref_item_type='+QuotedStr(estbk_types.CCommTypeAsBill)+' THEN a1.ref_item_id ELSE -1 END)');
        add(' LEFT OUTER JOIN orders o1 ON');
        add(' o1.id=(CASE WHEN a1.ref_item_type='+QuotedStr(estbk_types.CCommTypeAsOrder)+' THEN a1.ref_item_id ELSE -1 END)');

        add(format(' WHERE a1.ref_prepayment_accrec_id=%d',[pAccChldRecId]));
        add(' AND a1.status=''''');
        // ---
        result:=pStr.Text;

     end;

  finally
     freeAndNil(pStr);
  end;
end;
}
// võib muutuda !
function _SQLGetWarehouses(const companyId   : Integer;
                           const warehouseId : Integer = 0):AStr;
var
  pStr : TAStrList;
begin
 try
       pStr:=TAStrList.Create;
  with pStr do
   begin
       add('SELECT id,code,name');
       add('FROM warehouse');
       add(format('WHERE company_id=%d',[companyId]));
    if warehouseId>0 then
       add(format(' AND id=%d',[warehouseId]));
       add('ORDER BY name');
       result:=pStr.Text;
    end;

 finally
    freeAndNil(pStr);
 end;
end;

// MAKSEKORRALDUS~TASUMINE
function  _SQLGetCustomerUnpaidItems(const clientId : Integer;
                                     const companyId : Integer;
                                     const includeOrders : Boolean = true) :AStr;
var
 pStr : TAStrList;
begin
 try
        pStr:=TAStrList.Create;
   with pStr do
    begin
       //add('SELECT tmpfix.* '); // et qry ei kisaks liiga palju tabeleid lingitud...
       //add('FROM (');

       add('SELECT CAST(''B'' AS CHAR(1)) as ptype,b.id as itemid, b.bill_number as nr,  b.bill_date as idate,  b.payment_date as pmtdate,');
       add('CAST(');
       // 30.08.2011 Ingmar;  -b.uprepaidsum nüüd + märgiga, sest tabelis on ta neg !
       add('      (b.totalsum+b.roundsum+b.vatsum+b.fine+COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00)-b.incomesum-b.prepaidsum+b.uprepaidsum)'); // 29.11.2010 Ingmar;  uprepaidsum - prepaidsum asemele !
       add('       AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS to_pay,');
       add('CAST(');
       add('      (b.totalsum+b.roundsum+b.vatsum+b.fine) '); // +COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00)
       add('       AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS sumtotal,');
       add('       b.incomesum as paid_sum,');
       add('       b.currency,');

       // UI jaoks
       //add('      (SELECT s.bbool FROM __int_systemtypes s WHERE s.bbool=''f'') as checked');
       add('       s.bbool as itemchk');

       add('FROM bills b');

       // 13.03.2011 Ingmar
       Add(' LEFT OUTER JOIN  bills ccb ON ');
       Add(' ccb.id=b.credit_bill_id');
       Add(format('  AND ccb.bill_type=%s',[QuotedStr(estbk_types._CItemCreditBill)]));
       Add('  AND ccb.status LIKE ''%C%''');
       Add('  AND ccb.rec_deleted=''f''');

       add('INNER JOIN client c ON ');
       add('c.id=b.client_id');
       add('INNER JOIN __int_systemtypes s ON ');
       add('s.bbool=''f''');

       add(format('WHERE    b.client_id=%d',[clientId]));
       add(format('    AND  b.company_id=%d',[companyId]));
       add('     AND  NOT  b.payment_status LIKE ''%'+estbk_types.CBillPaymentOk+'%''');
       add('     AND  NOT  b.status LIKE ''%'+estbk_types.CRecIsCanceled+'%''');

       // 13.03.2011 Ingmar
       //Add(format('  AND b.bill_type=%s',[QuotedStr(estbk_types._CItemPurchBill)]));

       add('     AND  b.rec_deleted=''f''');
       //add('     AND  COALESCE(payment_date,''1980-01-01'')<='''+formatdatetime('yyyy-mm-dd',now)+'''');



    if includeOrders then
      begin

       add('UNION ALL');
       add('SELECT CAST(''O'' AS CHAR(1)) as ptype,o.id as itemid,o.order_nr as nr,o.order_date as idate,o.order_prp_due_date as pmtdate,');
       add('CAST(');
       add('(CASE WHEN (o.order_sum+o.order_roundsum+o.order_vatsum-o.paid_sum)<0 THEN 0'); // ettemaks !
       add(' ELSE ');
       add('      o.order_sum+o.order_roundsum+o.order_vatsum-o.paid_sum ');
       add(' END) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as to_pay,');
       add('CAST(');
       add(' o.order_sum+o.order_roundsum+o.order_vatsum AS '+TEstbk_MapDataTypes.__MapMoneyType()+')');
       add(' AS sumtotal,');

       add(' o.paid_sum,');
       add(' o.currency,');
       // UI jaoks
       add(' s1.bbool as itemchk');


       add('FROM orders o');
       add('INNER JOIN client c1 ON ');
       add('c1.id=o.client_id');
       add('INNER JOIN __int_systemtypes s1 ON ');
       add('s1.bbool=''f''');
       add(format('WHERE    o.client_id=%d',[clientId]));
       add(format('    AND  o.company_id=%d',[companyId]));
       add('     AND NOT  o.payment_status LIKE ''%'+estbk_types.COrderPaymentOk+'%''');
       add('     AND  NOT  o.status LIKE ''%'+estbk_types.CRecIsCanceled+'%''');
       add('     AND  o.rec_deleted=''f''');
      end;
       // CAST((CASE WHEN COALESCE(pd1.id,0)>0 THEN ''t'' ELSE ''f'' END) AS '+TEstbk_MapDataTypes.__MapModBoolean()+')'
       // --
       add('ORDER BY pmtdate ASC');
       // ---
       //add(') as tmpfix');
       result:=pStr.Text;
     end;

 finally
     freeAndNil(pStr);
 end;
end;


function  _SQLSelectAccountsWithBankData(const allItems : Boolean = true) :AStr;
var
 pStr : TAStrList;

begin
 try
        pStr:=TAStrList.Create;
   with pStr do
    begin
      add('SELECT a.id,a.account_coding,a.account_name,a.bank_id,b.name as bankname,');
      add('a.account_nr,a.account_nr_iban,a.flags,a.display_billtypes,a.default_currency');
      add('FROM accounts a');
      add('INNER JOIN banks b ON');
      add('b.id=a.bank_id ');
      add('WHERE  (a.bank_id>0)');
      add('  AND ((a.account_nr<>'''') OR (account_nr_iban<>''''))');

   // siis kuvatakse ainult need, mida lubatud arvel kuvada
   if not allItems then
      add('  AND   a.display_onbill=''t''');
      // ---
      add('  AND   a.valid=''t''');
      add('  AND   a.rec_deleted=''f''');
      add('  AND   a.company_id=:company_id');
      add(' ORDER BY b.name ASC');
      // ---
      result:=pStr.Text;
    end;
 finally
    freeAndNil(pStr);
 end;
end;

// kontode lihtnimistu !
function  _CSQLGetOpenAccounts(const pOrderByname : Boolean = false):AStr;
var
 pStr : TAStrList;

begin
 try
        pStr:=TAStrList.Create;
   with pStr do
    begin
      add('SELECT a.id, a.account_coding, a.account_name');
      add('FROM accounts a ');
      add('WHERE a.company_id IN (0,:company_id)');
      add('  AND  a.flags&'+inttostr(estbk_types.CAccFlagsClosed)+'=0 '); // kompatiibluse kadumise OHT !!!!! & ei ole universaalne baasides
      add('  AND  a.rec_deleted=''f''');
      add(' ORDER BY ');

   if not pOrderByname then
      add(' a.account_coding ')
   else
      add(' a.account_name  ');

      // ---
      result:=pStr.Text;
    end;
 finally
    freeAndNil(pStr);
 end;
end;

// TODO; nö tulevikus see eSQL hack ära kaotada !!!
function  _CSQLSelectGenLedgerEntrys(const eSQL : AStr = '';
                                     const pOnlyGenLdRecWithEntrys : Boolean = false):AStr;
var
 pStr : TAStrList;

begin

 try
      pStr:=TAStrList.Create;
 with pStr do
  begin

    // numeric olemas oracles, mssql, firebird, postgre
    add('SELECT '+estbk_dbcompability.sqlp._getHdrLimitRowsSQL(CDefaultMaxRows,0)); // 500 kirjet
    add('   a.id,a.entrynumber,a.transdescr,a.transdate,c.name as cname, a.type_ as accbrectype, ');

    add('   coalesce(');
//    add('     (SELECT (CASE WHEN sum(b.rec_sum)=0 THEN NULL ELSE sum(b.rec_sum) END)');
    add('     (SELECT CAST(sum(b.rec_sum) as numeric(19,4)) ');
    add('      FROM accounting_records b');
    add('      WHERE b.accounting_register_id=a.id');
    add('        AND b.rec_type like ''D%'''); // deebet read
//    add('        AND b.archive_rec_id=0');

    add('        AND b.id>');
    add('            (SELECT coalesce(max(b1.id),0)');
    add('             FROM  accounting_records b1 ');
    add('             WHERE b1.rec_type like ''D%'''); // deebet read
    add('              AND  b1.accounting_register_id=a.id');
    // seoses annuleerimisega
    add('              AND  b1.archive_rec_id=b1.id)),');
    //add('        AND b.status not like ''D%''');

    add('     (SELECT CAST(sum(b.rec_sum) as numeric(19,4)) ');
    add('      FROM accounting_records b');
    add('      WHERE b.accounting_register_id=a.id');
    add('        AND b.rec_type like ''C%'''); // deebet read

//    add('        AND b.archive_rec_id=0');
    add('        AND b.id>');
    add('            (SELECT coalesce(max(b1.id),0)');
    add('             FROM  accounting_records b1 ');
    add('             WHERE b1.rec_type like ''C%'''); // deebet read
    add('              AND  b1.accounting_register_id=a.id');
    // seoses annuleerimisega
    add('              AND  b1.archive_rec_id=b1.id))) ');

    add(' as accsum,'); // korrespondeeruvate summade puhul on see üks ja sama summa...
    add(' e.document_nr as docnr,');
    add(' ap.name as apname,');
    //10.08.2012 Ingmar; häkk pean võtma lisavälja kasutusele, et teisendada ära kande numbrid ja teha neist numbrid
    // sest zeos ei oska sorteerida !!! a.id sobib kenasti int väljana; zeos ka rõõmus
    add(' a.id as sortorder');



    add(' FROM accounting_register a ');

    add(' INNER JOIN company c ON');
    add(' c.id=a.company_id');
    // hetkel 1:1 per kanne, aga tulevikus rohkem
    add(' INNER JOIN accounting_register_documents d ON');
    add(' d.accounting_register_id=a.id');
    add(' INNER JOIN documents e ON ');
    add(' e.id=d.document_id');


    // -- ntx mysql ei luba subselectis kasutada limitid ja firebirdil ning teistel omad hädad kasutame natuke teist lähenemist
    // -- kannete küljes RP periood; ma ei tea kas teoorias on võimalik,
    // et üks kanne ühes RP aastas / teine teises, krt kõik siis maailmas võimalik


    add(' INNER JOIN accounting_period ap ON ');
    add(' ap.id=a.accounting_period_id');
    {
    (SELECT max(b1.accounting_period_id)'); // subselect ...äääk
    add('        FROM accounting_records b1');
    add('        WHERE b1.accounting_register_id=a.id)');
    }
    // add('         AND b1.archive_rec_id=0');
    // add('          AND b1.status not like ''D%'')');

    add(' WHERE (a.archive_rec_id=0');
    add('   AND  a.company_id=:company_id');
    // 27.11.2011 Ingmar
    add('   AND  a.template=''f''');


 // 26.08.2011 Ingmar; päring oli valesti, ei kuvatud pooli kandeid
 // Eesmärk oli vaid neid kuvada, kus on ka reaalselt kanderidu, aga päring oli vigane, kuvati vaid muudetud kandeid
 if pOnlyGenLdRecWithEntrys then
   begin
    add('  AND  EXISTS(');
    // peab olema ka aktiivseid kanderidu !
    add('                   SELECT rr1.id   ');
    add('                   FROM accounting_records rr1');
    // 19.09.2012 Ingmar; kõik on tore, aga kuhu jäi rr1.accounting_register_id seos !!!!!
    add('                   WHERE ');
    add('                         ');
    add('                     rr1.accounting_register_id=a.id'); // -- 19.09.2012 Ingmar;
    add('                 AND rr1.status=''''');                 // -- 19.09.2012 Ingmar;
    add('                 AND ');                                // -- 19.09.2012 Ingmar;
    add('                     rr1.id>=');
    add('                    (SELECT COALESCE(MAX(rr.id),0)');
    add('                     FROM accounting_records rr ');
    add('                     WHERE rr.accounting_register_id=a.id');
    add('                       AND rr.status LIKE ''%D%'' ');
    add('                       AND rr.archive_rec_id>0 ');
    add('                       AND rr.rec_deleted=''f''');
    add('                     )');

    add('                     AND (SELECT count(rr1.ID) ');
    add('                          FROM accounting_records rr1 ');
    add('                          WHERE rr1.accounting_register_id=a.id)>0');


    // 19.09.2012 Ingmar
    // -- aga aga !!! ps annuleeritud pearaamatu kandeid tuleb ka kuvada !
    add('                   UNION ');

    add('                   SELECT 1');
    add('                   FROM accounting_register rx');
    add('                   WHERE rx.id=a.id');
    add('                    AND  rx.type_=''CG''');

    add('                  )');

   end;

    // ---
    add('        )');
    // if onlyGenLedgerEntrys then
    //    add('   AND a.type_ like ''%G%''');

    // täiendavad tingimused...
    add(eSQL);
    //add(' ORDER BY a.transdate DESC');
    add(' ORDER BY a.id DESC');


    // ---
    add(estbk_dbcompability.sqlp._getFtrLimitRowsSQL(CDefaultMaxRows,0));

  end;
      // --------------
      result:=pStr.Text;
      // pStr.SaveToFile('c:\debug\TEST.txt');
 finally
      freeAndNil(pStr);
 end; // ---
end;


function  _SQLGetAccRecsFullSelect(const AccRecCancelled : Boolean = false):AStr;
var
 pStr : TAStrList;
begin
 try
       pStr:=TAStrList.Create;
   with pStr do
    begin
       add(' SELECT r.id,r.account_id,a.account_coding,a.account_name,c.shortidef as account_type, ');
       add(' r.descr, r.rec_nr,r.rec_sum,r.rec_type,r.currency,r.currency_id,r.currency_drate_ovr, r.currency_vsum, ');
       add(' r.client_id,l.name as firstname,l.lastname,r.tr_partner_name');
       add(' FROM accounting_records r ');
       add(' INNER JOIN accounts a ON ');
       add(' a.id=r.account_id ');
       add(' LEFT OUTER JOIN classificators c ON ');
       add(' c.id=a.type_id');

       add(' LEFT OUTER JOIN client l ON ');
       add(' l.id=r.client_id');
       add(' WHERE r.accounting_register_id=:accounting_register_id ');
       add('   AND r.archive_rec_id=0 ');
       add('   AND r.status not like ''%D%''');



    // sõltumata baasist on UNION üks kiiremaid ja paremaid lahendusi !!!
    if AccRecCancelled then
      begin
       add(' UNION ');
       add(' SELECT r1.id,r1.account_id,a1.account_coding,a1.account_name,c1.shortidef as account_type,  ');
       add(' r1.descr, r1.rec_nr,r1.rec_sum,r1.rec_type,r1.currency,r1.currency_id,r1.currency_drate_ovr, r1.currency_vsum, ');
       add(' r1.client_id,l1.name as firstname,l1.lastname,r1.tr_partner_name');

       add(' FROM accounting_records r1 ');
       add(' INNER JOIN accounts a1 ON ');
       add(' a1.id=r1.account_id ');
       add(' LEFT OUTER JOIN classificators c1 ON ');
       add(' c1.id=a1.type_id');

       add(' LEFT OUTER JOIN client l1 ON ');
       add(' l1.id=r1.client_id');

       add(' WHERE r1.accounting_register_id=:accounting_register_id2 ');
       add('   AND r1.id>');
       add('    (SELECT coalesce(max(b1.id),0)');
       add('     FROM  accounting_records b1 ');
       add('     WHERE  b1.rec_type=r1.rec_type');
       add('       AND  b1.accounting_register_id=a1.id');
       add('       AND  b1.archive_rec_id=b1.id)');
      end else
      // 27.02.2010 Ingmar; antud juhul ei peaks me kuvama tühistatud kandeid
      begin
       add(' AND r.id>(SELECT coalesce(max(b2.id),0)');
       add('           FROM  accounting_records b2 ');
       add('           WHERE b2.accounting_register_id=:accounting_register_id');
       add('            AND  b2.status like ''%D%'')');
      end;

       //add(' ORDER BY rec_nr,id asc ');
       add(' ORDER BY id asc,rec_nr ');
       result:=pStr.Text;
    end;

 // ------
 finally
  freeAndNil(pStr);
 end;
end;

// seekord ilma parameetrideta !
function  _SQLGetClientNPSQL(const companyId  : Integer;
                             const clientId   : Integer = -1;
                             const regCode    : AStr = '';
                             const cname      : AStr = '';
                             const clastname  : AStr = '';
                             const countyId   : Integer = -1;
                             const cityId     : Integer = -1;
                             const streetId   : Integer = -1;
                             const housenr    : AStr = '';
                             const apartmentnr: AStr = '';
                             // -- 12.02.2011 Ingmar
                             const clientCode : AStr = '';
                             const country : AStr = '';
                             const maxRows    : Integer = CDefaultMaxRows):AStr;
var
 pStr : TAStrList;
begin
 try
        pStr:=TAStrList.Create;
   with pStr do
    begin
       add(' SELECT '+estbk_dbcompability.sqlp._getHdrLimitRowsSQL(maxRows,0));
       add('  c.id,');
       add('  c.client_code,');
       add('  c.ctype,');
       add('  c.name as custname,');
       add('  c.middlename,');
       add('  c.lastname,');
       add('  c.regnr,');
       add('  c.countrycode,');
       add('  c.county_id,');
       // väldime SQLis str liitmist, sest see on erinevatel baasidel erinev
       // elu tõestanud, et tee parem liitmised aruandluses ja gridides !!!
       add('  coalesce(o.name,'''') as countyname,');
       add('  c.city_id,');
       add('  coalesce(s.name,'''') as cityname,');
       add('  c.street_id,');
       add('  coalesce(t.name,'''') as streetname,');
       add('  c.house_nr,');
       add('  c.apartment_nr,');
       add('  c.zipcode,');
       add('  c.phone,');
       add('  c.mobilephone,');
       add('  c.fax,');
       add('  c.email,');
       add('  c.postal_addr,');
//       add('  c.contact_person,');
//       add('  c.contact_personaddr,');
//       add('  c.contact_person_phone,');
//       add('  c.contact_person_email,');
       add('  c.notes,');
       add('  c.type_,');
       add('  c.payment_duetime,');
       add('  c.credit_limit,');
       // 05.03.2010 Ingmar
       add('  c.bank_account1 as bank_accounts,');
       add('  c.bank_id1  as bank_id,');
       add('  c.rec_changed,');
       add('  c.rec_changedby,');
       add('  c.rec_addedby,');
       add('  c.company_id,');
       add('  c.webpage,');
       // üldiselt lisa siia viitenumbrid, kui prefnumber tühi !
       add('  c.prefnumber,');
       add('  c.vatnumber,');
       //add('  cast(''a'' as varchar(255)) as crefnumber,');
       //       add('  rf.refnumber as crefnumber');
       // 29.03.2010 Ingmar; vägagi huvitav, kui left joinina panna ref nr külge, siis Zeos sõimab,
       // et ei suuda erinevaid tabeleid uuendada, kui nii subselecti tehes ei kurda !
       add('  (SELECT rf.refnumber FROM referencenumbers rf ');
       add('   WHERE rf.client_id=c.id AND NOT rf.status LIKE ''%D%'' AND rf.fixed=''T'') as crefnumber,');
       // 17.06.2010
       add('  c.srcval');
       // ---
       add('  FROM client c');
       add('  LEFT OUTER JOIN county o ON');
       add('  o.id=c.county_id');
       add('  LEFT OUTER JOIN city s ON');
       add('  s.id=c.city_id');
       add('  LEFT OUTER JOIN street t ON');
       add('  t.id=c.street_id');
       {
       add('  LEFT OUTER JOIN referencenumbers rf ON ');
       add('  rf.client_id=c.id AND NOT rf.status LIKE ''%D%'' AND rf.fixed=''T''');}

       // seekord ilma query parameetriteta !!!
       add(format('WHERE c.company_id=%d',[companyId]));

       // 15.01.2010 ingmar
    if clientId>0 then
       add(format(' AND c.id=%d',[clientId]));

    if trim(clientCode)<>'' then
       add(format(' AND c.client_code=%s',[QuotedStr(copy(clientCode,1,10))]));


    if trim(regCode)<>'' then // like kasutada ?!?
       add(format(' AND c.regnr=%s',[QuotedStr(copy(regCode,1,50))]));

    if trim(cname)<>'' then
       add(format(' AND c.name like %s',[QuotedStr(copy(cname,1,55))]));

    if trim(clastname)<>'' then
       add(format(' AND c.lastname like %s',[QuotedStr(copy(clastname,1,75))]));


    if countyId>0 then
       add(format(' AND c.county_id=%d',[countyId]));

    if cityId>0 then
       add(format(' AND c.city_id=%d',[cityId]));

    if streetId>0 then
       add(format(' AND c.city_id=%d',[streetId]));

    if streetId>0 then
       add(format(' AND c.street_id=%d',[streetId]));

    if trim(housenr)<>'' then
       add(format(' AND c.house_nr like %s',[QuotedStr(copy(housenr,1,65))]));

    if trim(apartmentnr)<>'' then
       add(format(' AND c.apartment_nr like %s',[QuotedStr(copy(apartmentnr,1,45))]));

    // 09.09.2011 Ingmar
    if trim(country)<>'' then
       add(format(' AND c.countrycode=%s',[QuotedStr(copy(country,1,3))]));

       // ---
       add('ORDER BY  c.lastname,c.name');
       add(estbk_dbcompability.sqlp._getFtrLimitRowsSQL(maxRows,0));
       result:=pStr.text;

    end;

 // ---
 finally
      freeAndNil(pStr);
 end;
end;


// type: P = toode;
//       S = teenus
//  ...
function _SQLGetArticles(const pAllowSpecialArticleTypes : Boolean = false):AStr;
var
 pStr    : TAStrList;
 pCurrDt : AStr;
begin

        pStr:=TAStrList.Create;
   with pStr do
    try
        // I - sisseostu hind;
        // S - müügihind
        // C - reserveeritud: kampaaniahind ehk peale selle lõppemist taastatakse hind, mis oli  enne kampaania kirjet !

        pCurrDt:=estbk_dbcompability.sqlp._getCurrDateTime();
        // -------

        add(' SELECT a.id, a.code as artcode, a.name as artname, a.unit, a.type_ as arttype,a.arttype_id, p.discount_perc,');
        add(' a.barcode_def_id,c.type_ as barcodetype,c.name as barcodedef,a.dim_h,a.dim_l,a.dim_w,a.manufacturer,a.shelfnumber, ');
        add(' a.barcode, a.ean_code, a.descr, a.url, a.purchase_account_id, a.sale_account_id, ');
        add(' a.expense_account_id, a.status, a.disp_web_dir, a.archive_rec_id,p.price as currsale_price,p1.price as purchase_price,');
        add(' a.price_calc_meth,a.special_type_flags,');
        add(' a.company_id, a.rec_changed, a.rec_changedby, a.rec_addedby, a.rec_deletedby, a.rec_deleted, ');


        // 20.09.2010 Ingmar; selline lugu, et artikli juures peame KUVAMA viimase kehtiva käibemaksu ID !!!!!!!!!!
        //add('a.vat_id,');
        // 20.11.2010 Ingmar;  JÄRJEKORDNE zeose kala, kui ei ole joinitud, siis ütleb invalid argument index...
        {
        add('CAST(');
        add(' (SELECT COALESCE(v.id,a.vat_id)');
        add('  FROM vat v');
        add('  WHERE v.base_rec_id=(SELECT v1.base_rec_id ');
        add('                       FROM vat v1');
        add('                       WHERE v1.id=a.vat_id)');
        add('   AND v.valid=''t'') AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapIntType+')AS vat_id,');
         }

         add('v.id AS vat_id,');

        // 12.02.2010 Ingmar
        //add('CAST((SELECT SUM(i.current_quantity) FROM inventory i WHERE i.article_id=a.id) AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapMoneyType+') AS artqty');
        add('(SELECT SUM(i.current_quantity) FROM inventory i WHERE i.article_id=a.id) AS artqty');

        add(' FROM articles a ');
        add(' LEFT OUTER JOIN classificators c ON ');
        add(' c.id=a.barcode_def_id');


        // ainult kehtiv käibemaks !
        add(' LEFT OUTER JOIN vat v ON');
        add(' v.id=(SELECT (CASE WHEN (MAX(v1.id)=0) THEN v.id ELSE MAX(v1.id) END)');
        add('       FROM vat v1');
        add('       INNER JOIN vat v2 ON');
        add('       v2.id=a.vat_id');
        //add('       WHERE v1.base_rec_id=v2.base_rec_id AND v2.company_id=a.company_id');
        // 10.04.2011 Ingmar
        add('       WHERE v1.base_rec_id=v2.base_rec_id AND v1.company_id=a.company_id');
        add('       )');
        add(' AND v.valid=''t''');


        // MÜÜK TEENUS/KAUP jne
        add(' LEFT OUTER  JOIN articles_price_table p ON ');
        add(' p.article_id=a.id ');
        //26.12.2009 Ingmar; hinnad nüüd lao põhised !!!!
        add(' AND p.warehouse_id=:warehouse_id');
        add(' AND p.id=(SELECT max(p1.id)');
        add('           FROM articles_price_table p1');
        add('           WHERE  p1.article_id=a.id ');
        add('                    AND  p1.type_=''S''');
        add(format('             AND  p1.begins<=%s',[pCurrDt]));
        add(format('             AND  COALESCE(p1.ends,(%s))>=%s)',[pCurrDt,pCurrDt]));


        // OST
        add(' LEFT OUTER  JOIN articles_price_table p1 ON ');
        add(' p1.article_id=a.id ');
        //26.12.2009 Ingmar; hinnad nüüd lao põhised !!!!
        add(' AND p1.warehouse_id=:warehouse_id');
        add(' AND p1.id=(SELECT max(p2.id)');
        add('           FROM articles_price_table p2');
        add('           WHERE  p2.article_id=a.id ');
        add('                    AND  p2.type_=''I''');
        add(format('             AND  p2.begins<=%s',[pCurrDt]));
        add(format('             AND  coalesce(p2.ends,(%s))>=%s)',[pCurrDt,pCurrDt]));
        add(' WHERE a.company_id=:company_id');

    // 11.09.2010 Ingmar; me ei tohi lubada eritüübiga artikleid; ntx Ettemaks
     if pAllowSpecialArticleTypes then
        add('   AND a.special_type_flags=0');
        //add('   AND a.type_=:itemtype');
        add('   AND a.type_ NOT IN ('''+CArtSpTypeCode_Fine+''') '); // 07.04.2011 Ingmar; viiviserea peidame hetkel ära kuniks hakkame viivistega tegelema !
        // 06.02.2012 Ingmar; kustutatuid ei kuva !
        add('   AND a.rec_deleted=''f''');
        add(' ORDER BY a.special_type_flags ASC,a.name DESC');
        result:=pStr.Text;
    // ---
    //pStr.SaveToFile('c:\test.txt');
    finally
      freeAndNil(pStr);
    end;
end;

// TODO; viia tavaliste protseduuride parameetrite peale üle !
function _SQLGetBillMainRec(const pSearchByCust : Boolean = false;
                            const pReversedCrBillMode : Boolean = false):AStr;
var
 pStr    : TAStrList;
begin

        pStr:=TAStrList.Create;
   with pStr do
    try
       add('SELECT  b.id,  b.client_id,');
       // c.name as firstname,c.lastname, c.regnr,c.countrycode,d1.name as county_name,');
       //add('d2.name as city_name,d3.name as street_name, c.house_nr, c.apartment_nr, c.zipcode,');
       //add('c.phone, c.mobilephone,c.email,c.prefnumber,c.bank_accounts,');
       //add('c.payment_duetime,c.credit_limit,c.prepayment_account_id, c.debt_account_id, c.charge_account_id,');
       add('b.bill_number,  b.bill_date, b.billing_addr2,  b.bill_type,  b.descr,  b.due_date, b.paymentterm,');
       add('b.overdue_perc,  b.totalsum,b.vatsum,b.roundsum,b.incomesum,b.prepaidsum,b.uprepaidsum,b.payment_status,b.vat_flags,b.currency,');
       add('b.accounting_register_id,b.dc_account_id,');//  b.roundsum
       add('ar.entrynumber as accentry_nr, ar.transdate as accentry_date,');
       add('ad.document_id,dk.document_nr,b.status,');
       add('b.issued2,b.vat_flags,b.credit_bill_id,bc.bill_type as cr_origtype, '); // b.order_id,  b.offer_id

       // kreediarve info; kreeditarve puhul viitab originaalarvele, muidu vastupidi !
       add('bc.bill_number as cr_origbillnr,');
       add('bc.bill_date as cr_origbilldate,');
       add('COALESCE(bc.totalsum+bc.roundsum+bc.vatsum+bc.fine,0.00) as cr_origbillsum,');

       // 13.09.2010 Ingmar
       add('bd.order_id,');
       // reserveeritud !
       add('b.openedby,');

       add('b.closedby,');
       add('CAST('+sqlp._doSafeSQLStrConcat([AStr('u.name'),AStr(''' '''),AStr('u.lastname')])+' AS '+TEstbk_MapDataTypes.__MapVarcharType(255)+') as bill_createdby,');

       // -- TODO tekitada viitenumbrite toetus müügiarvetele !
       add('b.ref_nr,');
       add('b.ref_nr_id');

       add('FROM bills b');
       add('INNER JOIN client c ON');
       add('c.id=b.client_id');

       add('LEFT OUTER JOIN accounting_register ar ON');
       add('ar.id=b.accounting_register_id');

       add('LEFT OUTER JOIN accounting_register_documents ad ON ');
       add('ad.accounting_register_id=ar.id');

       add('LEFT OUTER JOIN documents dk ON ');
       add('dk.id=ad.document_id');

    if not pReversedCrBillMode then
     begin
       add('LEFT OUTER JOIN bills bc ON ');
       add('bc.credit_bill_id=b.id AND NOT bc.status LIKE ''%D%''');
     end else
     begin
       add('LEFT OUTER JOIN bills bc ON ');
       add('bc.id=b.credit_bill_id AND NOT bc.status LIKE ''%D%''');
     end;

       // 06.04.2012 Ingmar
       add('LEFT OUTER JOIN users  u ON ');
       add('u.id=b.closedby');


       add('LEFT OUTER JOIN order_billing_data  bd ON ');
       add('bd.item_id=b.id AND bd.item_type='+QuotedStr(estbk_types.CCommTypeAsBill)+' AND NOT bd.status LIKE ''%D%''');


       //add('INNER JOIN documents dk ON ');
       //add('dk.id=ar.id');

       //add('LEFT OUTER JOIN  county d1 ON');
       //add('d1.id=c.county_id');
       //add('LEFT OUTER JOIN city d2 ON');
       //add('d2.id=c.city_id');
       //add('LEFT OUTER JOIN street d3 ON');
       //add('d3.id=c.street_id');
       add('WHERE b.company_id=:company_id');



    if not pSearchByCust then
       add(' AND b.id=:bill_id')
    else
       add(' AND b.id=:client_id');
       add(' AND NOT b.status LIKE ''%D%''');
       add('ORDER BY b.id DESC');
       result:=pStr.Text;
    // ---
    finally
      freeAndNil(pStr);
    end;
end;

function _SQLSelectBillLines():AStr;
var
 pStr    : TAStrList;
begin
        pStr:=TAStrList.Create;
   with pStr do
    try
       // mõtle kontode loogika ümber; hetkel natuke jama asi account_coding/ account_coding2
       add('SELECT b.id, b.linetype, b.discount_perc, b.cust_discount_id,');
       add('b.item_id, b.item_price,ac1.account_coding,b.item_account_id as account_id,');
       // ac2.account_coding as account_coding2,
       add('b.quantity, b.total,b.descr2,b.unit2,b.status,'); //  b.vat_perc, b.accounting_record_id
       add('a.code,a.code2, a.name as artname, a.unit as artunit, a.type_ as arttype, a.status as artstatus,a.special_type_flags,b.vat_rsum,');
       add('b.vat_id,b.vat_account_id,ac2.account_coding as vat_account_coding,v.description as vatdescr,'); // v.perc as vatperc,
       add('(CASE WHEN v.perc<0 THEN NULL ELSE v.perc END) as vatperc,v.flags as vatflags,b.vat_cperc,');
       add(' v.vat_account_id_s,v.vat_account_id_i,v.vat_account_id_p, ');
       // 15.01.2010 ingmar
       add('i.id as inventory_id,i.status as invstatus,');

       // 18.08.2011 Ingmar
       add('b.object_id,');
       add('o.descr as objectname1');

       add('FROM bill_lines b');
       // 22.04.2010 Ingmar; enam ei ole artikkel alati kohustuslik !!!!!!!!!!
       // add('INNER JOIN articles a ON');
       add('LEFT OUTER JOIN articles a ON');
       add('a.id=b.item_id');
       add('INNER JOIN vat v ON');
       add('v.id=b.vat_id');
       //add('LEFT OUTER JOIN accounting_records r ON');
       //add('r.id=accounting_record_id');
       //add('LEFT OUTER JOIN accounts ac1 ON ');
       //add('ac1.id=r.account_id');
       add('LEFT OUTER JOIN accounts ac1 ON ');
       add('ac1.id=b.item_account_id');
       add('LEFT OUTER JOIN accounts ac2 ON ');
       add('ac2.id=b.vat_account_id');

       // 18.08.2011 Ingmar
       add('LEFT OUTER JOIN objects o ON ');
       add('o.id=b.object_id');

       // 15.01.2010 Ingmar; inventuuri baaskirjed ka juurde
       add('LEFT OUTER JOIN inventory i ON ');
       add('i.article_id=a.id AND NOT i.status LIKE ''%D%''');
       add('WHERE b.bill_id=:bill_id ');
       add('  AND NOT b.status LIKE ''%D%''');  // nö arve rida pole annuleeritud

       add('ORDER BY b.id');
       result:=pStr.Text;

       //pStr.SaveToFile('c:\test.txt');
    // ---
    finally
      freeAndNil(pStr);
    end;
end;

// --- arvete päring
function _SQLSearchBills(const companyId : Integer;
                         const billId : Integer = 0;
                         const custId : Integer = 0;
                         const accDate : TDatetime = Nan; // kande kuupäev
                         const accNr   : AStr  = ''; // kande kuupäev
                         const billDate: TDatetime = Nan; // arve kuupäev
                         const billNr  : AStr = ''; // arve number
                         const billTypes  : AStr = '';
                         const billFlags  : Byte = 0;  // kõik; 1 kinnitatud; 2 kinnitamata 12.03.2011 Ingmar
                         const maxRows    : Integer = CDefaultMaxRows):AStr; // tarnija arve numbervar
var
 pStr    : TAStrList;
begin

        //  a.summa + a.kaibemaks + a.viivissumma + a.ymardamine - a.laekunudsumma - a.ettemsumma as volg
        pStr:=TAStrList.Create;
   with pStr do
    try
       add('SELECT '+estbk_dbcompability.sqlp._getHdrLimitRowsSQL(maxRows,0));
       add(' b.id,  b.client_id,b.bill_number,  b.bill_date,b.vat_flags,b.billing_addr2,');
       add(' b.bill_type,  b.descr,  b.due_date,');

       // 13.03.2011 Ingmar
       add(' CAST((b.totalsum+b.roundsum+b.vatsum+b.fine) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as totalsum,');
       //add(' CAST(COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as totalsum,');


       add(' b.incomesum,');
       // --- TASUDA SUMMA
       add(' CAST(');
       add('      (CASE WHEN ');
       // 30.08.2011 Ingmar;  -b.uprepaidsum nüüd + märgiga, sest tabelis on ta neg !
       add('        (b.totalsum+b.roundsum+b.vatsum+b.fine+COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00)-b.incomesum-b.prepaidsum+b.uprepaidsum)<=0.00 THEN 0.00 ');
       add('        ELSE');
       add('        (b.totalsum+b.roundsum+b.vatsum+b.fine+COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00)-b.incomesum-b.prepaidsum+b.uprepaidsum) END)');
       add('     AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS to_pay,');


       // ---
       add(' CAST(');
       // 30.08.2011 Ingmar;  -b.uprepaidsum nüüd + märgiga, sest tabelis on ta neg !
       add('      b.totalsum+b.roundsum+b.vatsum+b.fine+COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00)-b.incomesum-b.prepaidsum+b.uprepaidsum'); // 27.11.2010 Ingmar
       add('     AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS to_pay2,');


       add('b.currency,  b.accounting_register_id,'); //  b.roundsum
       add(' ar.entrynumber as accentry_nr, ar.transdate as accentry_date,');
       add(' ad.document_id,dk.document_nr,b.status,  b.openedby,  b.closedby,b.issued2,');
       add(' c.name as cust_name,c.lastname as cust_lastname,c.regnr as custregnr,');
       add(' c.email as cust_email,c.phone as cust_phone,c.mobilephone as cust_mphone,');
       // 04.03.2013
       add(' ( ');
       add('   SELECT CAST(COALESCE((CASE WHEN MAX(em.id)>0 THEN ''X'' ELSE '' '' END),'' '') AS CHAR(1))  ');
       add('   FROM email em ');
       add('   INNER JOIN sentemails sn ON ');
       add('   sn.email_id=em.id ');
       add('   WHERE sn.item_type=''B'''); // et tegemist ikka arvega
       add('     AND sn.item_id=b.id');
       add(') as isemailsent');

       add(' FROM bills b');
       add(' INNER JOIN client c ON');
       add(' c.id=b.client_id');

       // 13.03.2011 Ingmar
       add(' LEFT OUTER JOIN  bills ccb ON ');
       add('ccb.id=b.credit_bill_id');
       add(format('  AND ccb.bill_type=%s',[QuotedStr(estbk_types._CItemCreditBill)]));
       add('  AND ccb.status LIKE ''%C%''');
       add('  AND ccb.rec_deleted=''f''');

       add(' LEFT OUTER JOIN accounting_register ar ON'); // INNER JOIN
       add(' ar.id=b.accounting_register_id');
       add(' LEFT OUTER JOIN accounting_register_documents ad ON ');   // INNER JOIN
       add(' ad.accounting_register_id=ar.id');
       add(' LEFT OUTER JOIN documents dk ON '); // INNER JOIN
       add(' dk.id=ad.document_id');

       // tihti lihtsam teha päringut otse kui mängida parameetritega;
       // natuke võib jõudlus kannatada, aga suht vähe !
       add('WHERE ');
       add(format('b.company_id=%d AND ',[companyId]));

    if billId>0 then
       add(format('b.id=%d AND ',[billId]));

    if custId>0 then
       add(format('b.client_id=%d AND ',[custId]));

    if not isNan(accDate) then
       add(format('ar.transdate=%s AND ',[QuotedStr(datetoOdbcStr(accDate))]));

    if trim(accNr)<>'' then
       add(format('ar.entrynumber=%s AND ',[QuotedStr(accNr)]));

    if not isNan(billDate) then
       add(format('b.bill_date=%s AND ',[QuotedStr(datetoOdbcStr(billDate))]));

    if trim(billNr)<>'' then
       add(format('b.bill_number=%s AND ',[QuotedStr(billNr)]));

    if billTypes<>'' then
       add('b.bill_type in ('+billTypes+') AND ');


      // 12.03.2011 Ingmar
      case billFlags of
       1 : add('  b.status LIKE ''%'+estbk_types.CBillStatusClosed+'%'' AND');
       2 : add('  b.status LIKE ''%'+estbk_types.CBillStatusOpen+'%'' AND ');
      end;

       add(' NOT b.status LIKE ''%D%''');
       // 23.02.2012 Ingmar
       add(' AND b.rec_deleted=''f''');
       add(' ORDER BY b.bill_date DESC');
       add(estbk_dbcompability.sqlp._getFtrLimitRowsSQL(maxRows,0));
       result:=pStr.Text;
    // ---
    finally
      freeAndNil(pStr);
    end;
end;



function _SQLSearchPayments(const companyId : Integer;
                            const custId    : Integer = 0;
                            const pmtOrderDate : TDatetime = Nan;
                            const docNr     : AStr = '';
                            const billBr    : AStr = '';
                            const orderNr   : AStr = '';
                            const recvAccNr : AStr = '';
                            const descr     : AStr = '';
                            const custName  : AStr = '';
                            const iscashRegister : Boolean = false; // ehk muidu on tasumine läbi panga; nö maksekorraldus...tasusime hankija arve pangast
                            const cashRegTransType : Byte = 0; // 0 - sissetulek; 1 - väljaminek
                            const maxRows   : Integer = CDefaultMaxRows;
                            const paymentIDs : TADynIntArray = nil
                            ):AStr;
var
  pStr    : TAStrList;
begin
       pStr:=TAStrList.Create;
  with pStr do
    try
         add('SELECT '+estbk_dbcompability.sqlp._getHdrLimitRowsSQL(maxRows,0));
         add(' TRIM(COALESCE(cc.name,'''') || '' ''|| COALESCE(cc.lastname,'''')) as custname,cc.countrycode as custcountrycode,');
         add(' bk.name as compbankname,bk.swift as compbankswift, st.int4,');
         add(' a.entrynumber,d.document_type_id,o.id as pmtordid, o.payment_type,');
         add(' o.payment_nr, o.payment_date, o.document_nr,');
         add(' o.c_account_id, o.d_account_id, o.payer_account_nr,');
      if not iscashRegister then
         add('o.payment_rcv_name,')
      else
         add('o.client_name2 as payment_rcv_name,');


         add(' o.payment_rcv_bank_id, o.payment_rcv_bank, o.payment_rcv_account_nr,');
         add(' o.payment_rcv_refnr, o.client_id, o.optype, o.accounting_register_id,');
         add(' o.sumtotal, o.currency, o.status,'); // o.payment_confirmed, o.payment_confdate,
         // 10.04.2010 ingmar
         add('CAST(o.descr AS '+TEstbk_MapDataTypes.__MapVarcharType(512)+') as descr,');
         add('bb.name as rcvbankname,bb.swift as rcvbankswift,');
         add('c1.name as client_city,');
         add('sr.name as client_street,');
         add('cc.house_nr as client_housenr,');
         add('cc.apartment_nr as client_apartmentnr');
         add(' FROM payment o');

         // seoses SEPAga !
         add('LEFT OUTER JOIN accounts at ON');
         add('at.id = o.c_account_id');
         add('LEFT OUTER JOIN banks bk ON');
         add('bk.id = at.bank_id');

         add('LEFT OUTER JOIN banks bb ON');
         add('bb.id = o.payment_rcv_bank_id');

         add('LEFT OUTER JOIN client cc ON');
         add('cc.id = o.client_id');

         add('LEFT OUTER JOIN  city c1 ON');
         add('c1.id = cc.city_id');

         add('LEFT OUTER JOIN  street sr ON');
         add('sr.id = cc.street_id');

     // ---
     if  trim(orderNr)<>'' then
        begin
         add(' INNER JOIN payment_data pd ON ');
         add(' pd.payment_id=o.id AND NOT pd.status LIKE ''%D%'' AND pd.item_type='+QuotedStr(estbk_types.CCommTypeAsOrder));
         add(' INNER JOIN orders d ON ');
         add(format(' d.id=pd.item_id AND d.order_nr=%s',[QuotedStr(orderNr)]));
        end;


     // ---
     if  trim(billBr)<>'' then
        begin
         add(' INNER JOIN payment_data pd1 ON ');
         add(' pd1.payment_id=o.id AND NOT pd1.status LIKE ''%D%'' AND pd1.item_type='+QuotedStr(estbk_types.CCommTypeAsBill));
         add(' INNER JOIN bills bl ON ');
         add(format(' bl.id=pd1.item_id AND bl.bill_number=%s',[QuotedStr(billBr)]));
        end;



   //if (trim(docNr)<>'')  then
    //begin
        add('INNER JOIN accounting_register a ON ');
        add('a.id=o.accounting_register_id');
{
    if  trim(descr)<>'' then
        add(format(' AND a.transdescr LIKE %s',[QuotedStr(descr+'%')]));
}
        add('INNER JOIN accounting_register_documents ad ON ');
        add('ad.accounting_register_id=a.id');
        add('INNER JOIN documents d ON ');
        add('d.id=ad.document_id');

    if (trim(docNr)<>'') then
        add(format(' AND d.document_nr=%s',[QuotedStr(docNr)]));
    //end;

        // 23.10.2015 Ingmar
        add('LEFT OUTER JOIN __int_systemtypes st ON');
        add('st.bbool=''f''');
        add('WHERE ');
        add(format('o.company_id=%d ',[companyId]));

    // kassamakse !
    if isCashRegister then
      begin
            add(format(' AND o.payment_type=%s ',[QuotedStr(estbk_types.CPayment_ascashreg)]));

            // cashRegTransType
       case cashRegTransType of
         1: add(format(' AND d.document_type_id=%d',[estbk_lib_commonaccprop._ac.sysDocumentId[_dsReceiptVoucherDocId]]));
         2: add(format(' AND d.document_type_id=%d',[estbk_lib_commonaccprop._ac.sysDocumentId[_dsPaymentVoucherDocId]]));
       end;
       // ----
      end else
       // tavaline tasumine pangast !
       add(format(' AND o.payment_type=%s ',[QuotedStr(estbk_types.CPayment_aspmtord)]));



    if  not isNan(pmtOrderDate) then
        add(format(' AND o.payment_date=%s',[QuotedStr(datetoOdbcStr(pmtOrderDate))]));

    if (trim(descr)<>'') then
        add(format(' AND o.descr LIKE %s',[QuotedStr('%'+descr+'%')]));

    if  custId>0 then
        Add(format(' AND o.client_id=%d',[custId]));

    if (trim(custName)<>'') and (custId<=0) then
        Add(format(' AND o.payment_rcv_name LIKE %s',[QuotedStr('%'+custName+'%')]));


        add(' AND NOT o.status LIKE ''%D%''');
        // 23.02.2012 Ingmar
        add(' AND o.rec_deleted=''f''');

        // 25.10.2015
     if length(paymentIDs) > 0 then
        add(' AND o.id IN (' + _IntArrToStr(paymentIDs) + ')');


        //add(' ORDER BY o.payment_confirmed DESC, o.payment_order_date ASC');
        add(' ORDER BY o.payment_date DESC');
        add(estbk_dbcompability.sqlp._getFtrLimitRowsSQL(maxRows,0));

        result:=pStr.Text;
       // pStr.SaveToFile('c:\test.txt');
    // ---
    finally
       freeAndNil(pStr);
    end;

end;

function _SQLGetPaymentDataMiscSum(const pmtOrderID  : Integer):AStr;
var
 pStr    : TAStrList;
begin
        pStr:=TAStrList.Create;
   with pStr do
    try

         add('SELECT p.id,'+QuotedStr(estbk_types.CCommTypeAsMisc)+' as litemtype,p.status,');
         add('p.payment_id,p.splt_sum,p.splt_sum as or_splt_sum,p.item_descr,p.account_id,');
         add('acc.account_coding,acc.default_currency');
         add('FROM payment_data p');
         add('INNER JOIN accounts acc ON');
         add('acc.id=p.account_id');
         add('WHERE ');
         add(format(' p.payment_id=%d',[pmtOrderID]));
         add('  AND NOT p.status LIKE '+QuotedStr('%'+estbk_types.CRecIsCanceled+'%'));
         add('  AND p.item_type='+QuotedStr(estbk_types.CCommTypeAsMisc));
         //add('  AND p.item_type='+QuotedStr(estbk_types._COBdataAsBill));
         result:=pStr.Text;
    finally
        freeAndNil(pStr);
    end;
 // --
end;

// 09.03.2010 Ingmar
function _SQLGetDataForPayment(const pCustId       : Integer;
                               const pPaymentId    : Integer;
                               const pCompanyId    : Integer;
                               const pBillType     : AStr = estbk_types._CItemPurchBill;
                               const pOrderType    : AStr = estbk_types._COAsPurchOrder
                               ):AStr;
                                    //const onlyNonPaidItems : Boolean = true):AStr;
var
 pStr    : TAStrList;
begin
        pStr:=TAStrList.Create;
   with pStr do
    try
       add('SELECT '+QuotedStr(estbk_types.CCommTypeAsBill)+' as litemtype,');
       // üldiselt tulevikus mõtleme läbi, kuidas ilma selle tobeda hackita asju teha !!
       add(' dummy1.bbool as lsitemhlp,');
       //add(' cast(null as boolean) as lsitemhlp,');
       add(' b.id, b.client_id,pd.id as pmtdata_id,pd.splt_sum,pd.splt_sum as or_splt_sum,'); // lsitemhlp kasutame checkboxis, et saaksime elemente valida
       add('CAST('+sqlp._doSafeSQLStrConcat([AStr('b.bill_number')])+' as '+TEstbk_MapDataTypes.__MapVarcharType(85)+') as nr, ');
       add(' b.bill_date as cdate,b.due_date as ldate,');

{
       add(' CAST(');
       add('      (CASE ');
       // 30.08.2011 Ingmar;  -b.uprepaidsum nüüd + märgiga, sest tabelis on ta neg !
       add('        WHEN (b.totalsum+b.roundsum+b.vatsum+b.fine-b.incomesum-b.prepaidsum+b.uprepaidsum)<=0 THEN 0.00');
       add('        ELSE ');
       // 30.08.2011 Ingmar;  -b.uprepaidsum nüüd + märgiga, sest tabelis on ta neg !
       add('       (b.totalsum+b.roundsum+b.vatsum+b.fine+COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00)-b.incomesum-b.prepaidsum+b.uprepaidsum) END)');
       add('     AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS to_pay,');
}


       add(' CAST(');
       add('       (b.totalsum+b.roundsum+b.vatsum+b.fine+COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00)-b.incomesum-b.prepaidsum+b.uprepaidsum) ');
       add('     AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS to_pay,');


       add('CAST(');


       add('      (b.totalsum+b.roundsum+b.vatsum+b.fine)+COALESCE(ccb.totalsum+ccb.roundsum+ccb.vatsum+ccb.fine,0.00) AS '+TEstbk_MapDataTypes.__MapMoneyType());
       add('    ) AS to_pay2,');

       add('b.incomesum,'); // lihtsalt laekumine/tasumine; pank / kassa
       // 30.08.2011 Ingmar;  -b.uprepaidsum nüüd + märgiga, sest tabelis on ta neg !
       add('b.prepaidsum+b.uprepaidsum as prepaidsum,'); // ettemaksud


       // meil vaja ka eraldi summasid !
       add('(b.totalsum+b.roundsum+b.fine)+COALESCE(ccb.totalsum+ccb.roundsum+ccb.fine,0.00) as sumwvat,'); // summa ilma km'ta
       add('b.vatsum+COALESCE(ccb.vatsum,0.00) as vatsum,');




       add('b.currency,c1.id as currency_id,c1.curr_rate as currrate,');
       add('b.dc_account_id as account_id,'); // !!!!!!!!!!!!!!!!!!!
       add('acc.account_coding,acc.default_currency,');
       // add('acc.account_name,');
       add('CAST(');
//       CSBillName_Purch
       add(sqlp._doSafeSQLStrConcat([AStr('c.name'),
                                     AStr('c.lastname'),
                                     AStr(QuotedStr(' (')),
                                     AStr('c.regnr'),
                                     AStr(QuotedStr(')'))])+' as '+TEstbk_MapDataTypes.__MapVarcharType(512)+') as cstname');
       add('FROM bills b');

       // 13.03.2011 Ingmar
       Add(' LEFT OUTER JOIN  bills ccb ON ');
       Add('ccb.id=b.credit_bill_id');
       Add(format('  AND ccb.bill_type=%s',[QuotedStr(estbk_types._CItemCreditBill)]));
       Add('  AND ccb.status LIKE ''%C%''');
       Add('  AND ccb.rec_deleted=''f''');

       add('INNER JOIN client c ON');
       add('c.id=b.client_id');

    if pCustId>=0 then
       add(format('  AND  c.id=%d',[pCustId]));

       // ---
       add('LEFT OUTER JOIN payment_data pd ON');
       add('pd.item_type='+QuotedStr(estbk_types._COBdataAsBill));
       add(' AND pd.item_id=b.id AND NOT pd.status LIKE '+QuotedStr('%'+estbk_types.CRecIsCanceled+'%'));
       add(format(' AND pd.payment_id=%d',[pPaymentId]));

       add('LEFT OUTER JOIN accounts acc ON');
       add('acc.id=(CASE WHEN COALESCE(pd.account_id,0)=0 THEN b.dc_account_id ELSE pd.account_id END)');


       // kompatiibluse loomiseks; asi selles, kui teha cast('T' as Boolean) siis zeos muudab fieldi RO'ks !!!!!
       add('INNER JOIN __int_systemtypes dummy1 ON');
       add('dummy1.bbool=CAST((CASE WHEN COALESCE(pd.id,0)>0 THEN ''t'' ELSE ''f'' END) AS '+TEstbk_MapDataTypes.__MapModBoolean()+')');



       add('LEFT OUTER JOIN currency_exc c1 ON');
       add('c1.id=b.currency_id');

       add(' WHERE '); // 03.04.2011 Ingmar
   if pBillType<>'' then
       add('   b.bill_type='+QuotedStr(pBillType))
   else
       add('   1=1 ');
       // add(format('  AND  b.client_id=%d',[custId]));
       add(format('  AND  c.company_id=%d',[pCompanyId]));
       add('  AND  NOT b.status like '+QuotedStr('%'+estbk_types.CBillStatusDeleted+'%'));
       //add('  AND  NOT b.status like '+QuotedStr('%'+estbk_types.CBillStatusPaid+'%'));
       add('  AND  NOT b.status like '+QuotedStr('%'+estbk_types.CBillStatusOpen+'%'));


    //  16.07.2010 Ingmar; tasumata arve või maksekorraldusega seotud arved !
    // if onlyNonPaidItems then
    //    add('  AND  ((NOT b.payment_status like '+QuotedStr('%'+estbk_types.CBillPaymentOk+'%')+') OR (pd.item_id>0))' );


       add('  AND (((b.totalsum+b.roundsum+b.fine+b.vatsum+COALESCE(ccb.totalsum+ccb.roundsum+ccb.fine,0.00)-'+
           '  (b.incomesum+b.prepaidsum+b.crprepaidsum))<>0.00)  OR (pd.item_id>0)) ');


    // (b.totalsum+b.roundsum+b.fine)+COALESCE(ccb.totalsum+ccb.roundsum+ccb.fine,0.00)-


    // 27.08.2010 Ingmar; nullpäring uue maksekorralduse jaoks !
    if pPaymentId=-1 then
       add('  AND b.id=0 ');

       add('UNION');

       add('SELECT '+QuotedStr(estbk_types.CCommTypeAsOrder)+' as litemtype,');

       // üldiselt tulevikus mõtleme läbi, kuidas ilma selle tobeda hackita asju teha !!
       add('dummy2.bbool as lsitemhlp,');
       //add(' cast(null as boolean) as lsitemhlp,');

       add('p.id,p.client_id,pd1.id as pmtdata_id,pd1.splt_sum,pd1.splt_sum as or_splt_sum,');
       add('CAST('+sqlp._doSafeSQLStrConcat([AStr('p.order_nr')])+' as '+TEstbk_MapDataTypes.__MapVarcharType(85)+') as nr, ');
       add(' p.order_date as cdate,p.order_prp_due_date as ldate,');


       //add('(SELECT SUM(ol.price)  FROM order_lines ol WHERE ol.order_id=p.id AND NOT ol.status LIKE '+QuotedStr('%'+estbk_types.CRecIsDeleted+'%')+')  as to_pay,');
       //add('CAST((p.order_sum+p.order_roundsum+p.order_vatsum) AS '+TEstbk_MapDataTypes.__MapMoneyType()+') as to_pay,');
       add(' CAST(');
       add('      (CASE WHEN (p.order_sum+p.order_roundsum+p.order_vatsum-p.paid_sum)<=0 THEN 0 ');
       add('            ELSE (p.order_sum+p.order_roundsum+p.order_vatsum-p.paid_sum) END)');
       add('     AS '+TEstbk_MapDataTypes.__MapMoneyType()+') AS to_pay,');
       add('CAST(');
       add('      (p.order_sum+p.order_roundsum+p.order_vatsum) AS '+TEstbk_MapDataTypes.__MapMoneyType());
       add('    ) AS to_pay2,');


       add(' p.paid_sum as incomesum,');
       add(' 0 as prepaidsum,');

       //add(' 0 as uprepaidsum,');
       //add('(SELECT SUM(po.splt_sum) FROM payment_data po WHERE po.item_type='+QuotedStr(estbk_types.CPmtOrder_order_id));
       //add('  AND NOT  po.status LIKE '+QuotedStr('%'+estbk_types.CRecIsDeleted+'%')+')  as incomesum, ');

       add('(p.order_sum+p.order_roundsum) as sumwvat,'); // summa ilma km'ta
       add(' p.order_vatsum as vatsum,');



       // tellimusega me ei tea veel valuutat
       add('p.currency,0 as currency_id,p.currency_drate_ovr as currrate,'); // ka ühik on 1
       add('acc1.id as account_id,'); // !!!!!!!!!!!!!!!!!!!
       add('acc1.account_coding,acc1.default_currency,');

       //add(''''' as account_name,');

       add('CAST(');
       add(sqlp._doSafeSQLStrConcat([AStr('c1.name'),
                                     AStr('c1.lastname'),
                                     AStr(QuotedStr(' (')),
                                     AStr('c1.regnr'),
                                     AStr(QuotedStr(')'))])+' as '+TEstbk_MapDataTypes.__MapVarcharType(512)+') as cstname');
       add('FROM orders p');
       add('INNER JOIN client c1 ON');
       add('c1.id=p.client_id');

       add('LEFT OUTER JOIN payment_data pd1 ON');
       add('     pd1.item_type='+QuotedStr(estbk_types._COBdataAsOrder));
       add(' AND pd1.item_id=p.id AND NOT pd1.status LIKE '+QuotedStr('%'+estbk_types.CRecIsCanceled+'%'));
       add(format(' AND pd1.payment_id=%d',[pPaymentId]));

       add('INNER JOIN __int_systemtypes dummy2 ON');
       add('dummy2.bbool=CAST((CASE WHEN COALESCE(pd1.id,0)>0 THEN ''t'' ELSE ''f'' END) AS '+TEstbk_MapDataTypes.__MapModBoolean()+')');

       add('LEFT OUTER JOIN accounts acc1 ON');
       add(format('acc1.id=(CASE WHEN COALESCE(pd1.account_id,0)=0 THEN %d ELSE pd1.account_id END)',[estbk_lib_commonaccprop._ac.sysAccountId[_accSupplPrePayment]]));


       add('WHERE');
       add(format('  p.company_id=%d',[pCompanyId]));

    if pOrderType<>'' then
       add('   AND p.order_type='+QuotedStr(pOrderType))
      else
       add('   AND 1=1 ');


    if pCustId>=0 then
       add(format('  AND  p.client_id=%d',[pCustId]));
       // ---
       add('  AND  NOT p.status like '+QuotedStr('%'+estbk_types.CRecIsCanceled+'%'));

    // 16.07.2010 Ingmar;
    //if onlyNonPaidItems then
       add('  AND  ((NOT p.payment_status like '+QuotedStr('%'+estbk_types.COrderPaymentOk+'%')+') OR (pd1.item_id>0))');


       // kuvame ainult tellimused, millest pole tekkinud ostuarvet !!!!!!!!!!!!!!!!!!!!
       add('  AND NOT EXISTS(SELECT pm.order_id FROM order_billing_data pm WHERE pm.order_id=p.id ');
       add('  AND pm.item_type='+QuotedStr(estbk_types._COBdataAsOrder));
       Add('  AND NOT pm.status LIKE '+QuotedStr('%'+estbk_types.CRecIsCanceled+'%'));
       add('  )');


    // 27.08.2010 Ingmar; nullpäring uue tasumise jaoks !
    if pPaymentId=-1 then
       add('  AND p.id=0 ');

       add('ORDER BY ldate ASC');

       // ---
       result:=pStr.Text;
       //pstr.SaveToFile('c:\debug\test.txt');
    finally
      freeAndNil(pStr);
    end;
end;

end.