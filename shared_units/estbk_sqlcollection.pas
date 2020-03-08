unit estbk_sqlcollection;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, estbk_types;

const
  CSQLCreateIndexMask = 'CREATE INDEX %s ON %s(%s)';
  CSQLCreateUIndexMask = 'CREATE UNIQUE INDEX %s ON %s(%s)';
  CSQLGrantPermission = 'GRANT %s ON %S TO %s';



const
  CSQLSelect: AStr = ' SELECT ';
  CSQLInsert: AStr = ' INSERT ';
  CSQLUpdate: AStr = ' UPDATE ';
  CSQLDelete: AStr = ' DELETE ';


const
  _SQLSelectAllCompanys = 'SELECT * FROM company ORDER BY id ASC'; // 'SELECT * FROM company ORDER BY name ASC';

  _SQLInsertCompany = 'INSERT INTO company(' + 'id,name, regnr, vatnumber, countrycode, county_id, city_id,' +
    'street_id, house_nr, apartment_nr, zipcode, phone, mobilephone,' +
    'fax, email, contactperson, contactperson_phone, contactperson_email,' +
    'descr,  rec_changedby, rec_addedby) ' + ' VALUES(' +
    ':id,:name, :regnr, :vatnumber, :countrycode, :county_id, :city_id,' +
    ':street_id, :house_nr, :apartment_nr, :zipcode, :phone, :mobilephone,' +
    ':fax, :email, :contactperson, :contactperson_phone, :contactperson_email,' +
    ':descr,:rec_changedby,:rec_addedby)';

  _SQLUpdateCompany = 'UPDATE company ' +
    'SET name=:name, regnr=:regnr, vatnumber=:vatnumber, countrycode=:countrycode, county_id=:county_id,' +
    'city_id=:city_id, street_id=:street_id, house_nr=:house_nr, apartment_nr=:apartment_nr, zipcode=:zipcode,' +
    'phone=:phone, mobilephone=:mobilephone, fax=:fax, email=:email, contactperson=:contactperson, contactperson_phone=:contactperson_phone,' +
    'contactperson_email=:contactperson_email, parent_id=0, descr=:descr,rec_changedby=:rec_changedby ' +
    'WHERE id=:id';

// 21.09.2011 Ingmar
const
  _SQLCopyCompanyAcc = ' INSERT INTO accounts(account_coding,account_name,init_balance,curr_balance,type_id,typecls_id, ' +
    ' balance_rep_line_id,incstat_rep_line_id,default_currency,parent_id,flags,valid,bank_id,company_id) ' +
    ' SELECT account_coding,account_name,0.00 as init_balance,0.00 as curr_balance,type_id,typecls_id, ' +
    ' 0 as balance_rep_line_id,0 as incstat_rep_line_id,default_currency,parent_id,flags,valid,0 as bank_id,:companyid2 as cpyCmp ' +
    ' FROM accounts ' + ' WHERE company_id=:companyid1 ' + '   AND rec_deleted=''f''';


const
  _SQLCopyDefaultAccPart1 = ' INSERT INTO default_sysaccounts(ordinal_nr,sys_descr,account_id,starts,company_id) ' +
    ' SELECT ordinal_nr,sys_descr,account_id,starts,:companyid2 ' + ' FROM default_sysaccounts ' +
    ' WHERE company_id=:companyid1 ' + '   AND ends is null';

  _SQLCopyDefaultAccPart2 = ' UPDATE  default_sysaccounts ' +
    ' SET  account_id=(select a.id from accounts a where a.account_coding=(select a1.account_coding from accounts a1 where a1.id=default_sysaccounts.account_id) and a.company_id=default_sysaccounts.company_id) ' + ' WHERE company_id=:companyid2 ';




const
  _SQLInsertCounty = 'INSERT INTO county(id, name,countrycode, rec_changedby, rec_addedby) ' +
    'VALUES (:id, :name,:countrycode, :rec_changedby,:rec_addedby)';

  _SQLInsertCity = 'INSERT INTO city(id, name,countrycode, rec_changedby, rec_addedby) ' +
    'VALUES (:id, :name,:countrycode, :rec_changedby,:rec_addedby)';

  _SQLInsertStreet = 'INSERT INTO street(id, name,countrycode, rec_changedby, rec_addedby) ' +
    'VALUES (:id, :name,:countrycode, :rec_changedby,:rec_addedby)';



const
  _SQLSelectAllusers = 'SELECT * FROM users';

  _SQLSelectUsrByLName = 'SELECT * FROM users WHERE loginname=:loginname'; // parameetriga select !

  _SQLInsertWorker = 'INSERT INTO users(id, loginname, regnr_personalcode, name, middlename, lastname,' +
    'position, phone, email, employment_contract_id, company_id,' +
    'lastlogin, fromip, allowlogin, rec_changed, rec_changedby, rec_addedby)' +
    'VALUES (:id, :loginname,:regnr_personalcode ,:name,:middlename,:lastname,' +
    ':position,:phone,:email,:employment_contract_id,:company_id,' +
    ':lastlogin,:fromip,:allowlogin,:rec_changed,:rec_changedby,:rec_addedby)';

  _SQLInsertDummyAdminRec = ' INSERT INTO users(loginname,name) ' + ' VALUES(''admin'',''admin'')';




  _SQLUpdateWorker = 'UPDATE users ' +
    'SET loginname=:loginname, regnr_personalcode=:regnr_personalcode, name=:name, middlename=:middlename,' +
    'lastname=:lastname,position=:position, phone=:phone, email=:email, employment_contract_id=0,' +
    //  employment_contract_id hetkel pole toetatud
    'company_id=:company_id, lastlogin=:lastlogin, fromip=:fromip, allowlogin=:allowlogin, rec_changed=:rec_changed,' +
    'rec_changedby=:rec_changedby, rec_addedby=:rec_addedby ' + 'WHERE id=:id';

const
  _SQLUserCompAccListSelect = ' SELECT company_id ' + ' FROM user_company_acclist ' +
    ' WHERE user_id=:user_id';

  _SQLUserCompAccListInsert = ' INSERT INTO user_company_acclist(user_id, company_id) ' +
    ' VALUES (:user_id, :company_id)';

  _SQLUserCompAccListDelete = ' DELETE FROM user_company_acclist WHERE user_id=:user_id AND company_id=:company_id ';

// TODO: not exists lisada !
const
  //_SQLInsertNewConfValueSimple = ' INSERT INTO conf(var_name, var_val, var_misc, user_id) '+
  //                               ' VALUES (:var_name,:var_val,:var_misc,:user_id)';
  _SQLInsertNewConfValueSimple = ' INSERT INTO conf(var_name, var_val, var_misc) ' +
    ' VALUES (:var_name,:var_val,:var_misc)';


const
  _SQLInsertNewSystemConfValue = ' INSERT INTO system_conf(var_name, var_val, var_misc) ' +
    ' VALUES (:var_name,:var_val,:var_misc)';




// KÄIBEMAKS !
// antud SQL kasutab vaikeseadete protseduur;
const
  _SQLInsertNewVATZValue = ' INSERT INTO vat(id,description, perc,country_code,defaultvat,flags,base_rec_id) ' +
    ' VALUES(:id,:description,:perc,:country_code,:defaultvat,:flags,COALESCE(:base_rec_id,:id)) ';

const
  _SQLInsertNewVATZValue2 = ' INSERT INTO vat(id,description, perc,country_code,vat_account_id_s,vat_account_id_i,vat_account_id_p,' +
    ' defaultvat,flags,base_rec_id,company_id,rec_changed,rec_changedby,rec_addedby) ' +
    ' VALUES(:id,:description,:perc,:country_code,:vat_account_id_s,:vat_account_id_i,:vat_account_id_p,' +
    ' :defaultvat,:flags,:base_rec_id,:company_id,:rec_changed,:rec_changedby,:rec_addedby) ';

// pangad
const
  _SQLInsertBanks = ' INSERT INTO banks(name, lcode, swift, company_id, rec_changed, rec_changedby, rec_addedby) ' +
    ' VALUES(:bank_name,:lcode,:swift,:company_id,:rec_changed,:rec_changedby,:rec_addedby)';


// tühistab hetkel kehtiva kirje !!!
const
  _SQLUpdtAsVatPreviousRec = ' UPDATE vat ' + ' SET valid=''f'',' +
    '     rec_changed=:rec_changed,' + '     rec_changedby=:rec_changedby ' +
    ' WHERE id=:id';

const
  _SQLUpdtVatDescr = ' UPDATE vat ' + ' SET description=:description,' +
    '     rec_changed=:rec_changed,' + '     rec_changedby=:rec_changedby ' +
    ' WHERE id=:id';


const
  _CSQLGetVAT = ' SELECT id,description,(CASE WHEN perc<0 THEN NULL ELSE perc END) as perc,perc as oprc,flags as vatflags,' +
    ' defaultvat,vat_account_id_s,vat_account_id_i,vat_account_id_p,base_rec_id, ' +
    ' base_rec_id,rec_changed,rec_changedby,rec_addedby ' + ' FROM vat ' +
    ' WHERE valid=''t'' ' +  // tohib kasutada !
    '   AND company_id=:company_id ' + ' ORDER by perc asc ';
//' ORDER by ID asc ';

//_SQLRemCurren

// --



// kui uus firma tehakse, siis kopeerin templatest vaikimisi käibemaksud;
// 0 väärtus on sisuliselt template !
const
  _SQLCloneVATValue = ' INSERT INTO vat(description, perc, ldescription, country_code, valid, defaultvat,flags,base_rec_id,company_id) ' +
    ' SELECT description, perc, ldescription, country_code, valid, defaultvat,flags,base_rec_id,:company_id' +
    ' FROM vat ' + ' WHERE company_id=0 ' + ' ORDER BY id ';

const
  _SQLInsertZClient = ' INSERT INTO client(id,lastname,flags,company_id,client_code) ' +
    ' VALUES(:id,:lastname,:flags,:company_id,:client_code) ';


const
  _SQLCloneBanks = ' INSERT INTO banks(name,lcode,swift,company_id) ' +
    ' SELECT b.name,b.lcode,b.swift,:company_id ' + ' FROM banks b' +
    ' WHERE b.company_id=0 ' + ' ORDER BY id ';



const
  _SQLInsertNewClassificator = ' INSERT INTO classificators(name, shortidef, type_, weight,value) ' +
    ' VALUES (:name,:shortidef,:type_,:weight,:value)';

const
  _SQLInsertNewClassificator2 = ' INSERT INTO classificators(name, shortidef, type_, weight,value,company_id) ' +
    ' VALUES (:name,:shortidef,:type_,:weight,:value,:company_id)';

const
  _SQLInsertNewClassificator3 = ' INSERT INTO classificators(id,name, shortidef, type_, weight,value,company_id) ' +
    ' VALUES (:id,:name,:shortidef,:type_,:weight,:value,:company_id)';


const
  _SQLGetMaxArticleTypeClassificatorShortId =
    'SELECT max(shortidef) as shortidef FROM classificators  WHERE type_=''amount_type'' AND company_id in (0,:company_id)';

const
  _SQLInsertNewPermission = ' INSERT INTO user_permission_descr(system_alias, description, type_) ' +
    ' VALUES (:system_alias,:description,:type_)';



const
  _SQLGetAllPermissionDescr = ' SELECT id,system_alias,description,type_,valid ' + ' FROM user_permission_descr' +
    ' ORDER BY description ';

  _SQLUserPermissions = ' SELECT up.permission_descr_id, up.descriptors, ud.system_alias ' +
    ' FROM user_permissions up,user_permission_descr ud ' + ' WHERE up.user_id=:user_id ' +
    '   AND ud.id=up.permission_descr_id ' + ' ORDER BY ud.description ';

  _SQLUserPermissionsInsert = ' INSERT INTO user_permissions(user_id, permission_descr_id, descriptors) ' +
    ' VALUES (:user_id, :permission_descr_id, :descriptors)';

  _SQLUserPermissionsDelete = ' DELETE FROM user_permissions WHERE user_id=:user_id AND permission_descr_id=:permission_descr_id';
  _SQLUserPermissionsDeleteExc =
    ' DELETE FROM user_permissions WHERE user_id=:user_id AND permission_descr_id=:permission_descr_id AND descriptors=''D''';

  _SQLUserRoleInsert = ' INSERT INTO user_roles(role_id, user_id) VALUES (:role_id, :user_id)';
  _SQLUserRoleDelete = ' DELETE FROM user_roles WHERE  role_id=:role_id AND user_id=:user_id';


  _SQLUserRole = ' SELECT id,role_name FROM role ORDER BY role_name';
  _SQLUserAssignedRoles = ' SELECT role_id FROM user_roles WHERE user_id=:user_id';
  _SQLAllRolePermissions = ' SELECT role_id, permission_descr_id ' + ' FROM role_permissions ';



  // SPECIAL VIEWS ehk viewd mis teevad meil elu kõikjal lihtsaks ja andmebaasi tegemisel automaatselt luuakse
  _SQLCreatePermView = ' CREATE VIEW v_permissions ' + '  as ' +
    '  select up.user_id,ud.system_alias,ud.type_ ' + '  from user_permissions up,user_permission_descr ud ' +
    '  where  ud.id=up.permission_descr_id ' + '     and ud.valid=true ' +
    '     and ud.type_<>''D''' + ' union ' +
    ' select ur.user_id,ud.system_alias,ud.type_ ' +
    ' from user_roles ur,role_permissions rp,user_permission_descr ud ' +
    ' where  rp.role_id=ur.role_id ' + ' and ud.id=rp.permission_descr_id ' +
    ' and ud.valid=true ';

  _SQLCreateAccInitBalanceView = ' CREATE VIEW v_accinitbalance ' + ' AS ' +
    ' SELECT  a.account_id,a.rec_type,c.shortidef as account_type,sum(a.rec_sum) as rec_sum,r.company_id ' +
    ' FROM  accounting_records a ' + ' INNER JOIN accounting_register r ON ' +
    ' r.id=a.accounting_register_id  and r.type_=''A''' + ' INNER JOIN accounts r1 ON ' +
    ' r1.id=a.account_id and r1.rec_deleted=''f''' +
    ' LEFT OUTER JOIN classificators c ON ' + ' c.id=r1.type_id ' +
    ' WHERE a.status not like ''%D%''' +
    ' GROUP BY a.account_id,a.rec_type,c.shortidef,r.company_id ';

  // #########################################################################
  // 18.02.2012

  _SQLSelectAccPeriodById = 'SELECT * FROM accounting_period WHERE id=:id AND rec_deleted=''f''';


  // #########################################################################
  // numeraatorid tabelisse
  _SQLInsertNumerators = 'INSERT INTO numerators(cr_num_val, cr_num_start, cr_num_type, ' +
    'cr_vrange_start, cr_vrange_end, cr_version, company_id) ' +
    'VALUES (:cr_num_val,:cr_num_start,:cr_num_type,:cr_vrange_start,' +
    ':cr_vrange_end,:cr_version,:company_id)';

  _SQLInsertNumerators2 = 'INSERT INTO numerators(cr_num_val, cr_num_start, cr_num_type, ' +
    'cr_vrange_start, cr_vrange_end, cr_version,cr_srbfr, company_id,accounting_period_id) ' +
    'VALUES (:cr_num_val,:cr_num_start,:cr_num_type,:cr_vrange_start,' +
    ':cr_vrange_end,:cr_version,:cr_srbfr,:company_id,:accounting_period_id)';


  _SQLUpdateNumerators = 'UPDATE numerators ' + 'SET cr_num_val=:cr_num_val,' +
    '    cr_num_start=:cr_num_start,' + '    cr_num_type=:cr_num_type,' +
    '    cr_vrange_start=:cr_vrange_start,' + '    cr_vrange_end=:cr_vrange_end,' +
    '    cr_version=:cr_version, ' + '    cr_srbfr=:cr_srbfr ' +
    // '    company_id,accounting_period_id
    'WHERE id=:id';

  // #########################################################################

  _SQLCloneDefaultNumerator = ' INSERT INTO numerators(cr_num_val, cr_num_start, cr_num_type, ' +
    ' cr_vrange_start, cr_vrange_end,cr_version, cr_valid, cr_srbfr,company_id)' +
    ' SELECT cr_num_val, cr_num_start, cr_num_type, cr_vrange_start, cr_vrange_end,' +
    ' cr_version, cr_valid, cr_srbfr,:company_id ' + ' FROM numerators ' +
    ' WHERE company_id=0 ';


  // #########################################################################

  _SQLUpdateDefaultNumerator = ' UPDATE numerators ' + ' SET cr_num_val=:cr_num_val ' +
    ' WHERE company_id=:company_id ' + '   AND cr_num_type=:cr_num_type';

  // kandeseeriad majandusaasta põhiseks
  _SQLInsertAPCtype = ' INSERT INTO conf(var_name,var_val,var_misc,company_id) ' + ' VALUES(''apcnumerators'',1,1,:company_id)';

  _SQLSelectACPVar = ' SELECT * FROM conf WHERE company_id=:company_id AND var_name=''apcnumerators''';


  // #########################################################################
  // uus rp. aasta
  _SQLInsertNewAccPer = ' INSERT INTO accounting_period(id,name, period_start, period_end, status, company_id, rec_changed,' +
    ' rec_changedby, rec_addedby) ' +
    ' VALUES (:id, :accname,:period_start,:period_end,:status,:company_id,:rec_changed,' +
    ' :rec_changedby,:rec_addedby) ';


  // #########################################################################
  _SQLUpdateAccPer = ' UPDATE accounting_period ' +
    ' SET name=:accname, period_start=:period_start, period_end=:period_end, status=:status,' +
    ' rec_changed=:rec_changed, rec_changedby=:rec_changedby ' + ' WHERE id=:id ';


  // #########################################################################

  _SQLDeleteAccPer = ' UPDATE accounting_period ' + ' SET status=''D'',rec_changed=:rec_changed, rec_changedby=:rec_changedby,' +
    ' rec_deletedby=:rec_deletedby,rec_deleted=:rec_deleted ' + ' WHERE id=:id ';

  // #########################################################################
  // kontod ja klassifikaatorid
  _CSQLAccountTypes2 = ' SELECT id,shortidef as accshortident,name as accname ' + ' FROM classificators ' +
    ' WHERE type_=''account_type''' + ' ORDER BY id ';

  // #########################################################################

  _CSQLAccountCls2 = ' SELECT id,shortidef as accshortident,name as accclsname ' + ' FROM classificators ' +
    ' WHERE type_=''account_classificator''' + ' ORDER BY id ';

  // #########################################################################

  _CSQLGetRepFormId = ' SELECT id ' + ' FROM formd ' + ' WHERE company_id=:company_id ' +
    '   AND form_type=:form_type';

  // lihtsustatud variant sellest !
  _CSQLInsertRepFormLines = ' INSERT INTO formd_lines(id, formd_id, parent_id, line_descr, row_nr, row_id, log_nr, ' +
    ' baserecord_id, rec_changed, rec_changedby,rec_addedby) ' +
    ' VALUES (:id, :formd_id,:parent_id,:line_descr,:row_nr,:row_id,:log_nr,' +
    ' :baserecord_id, :rec_changed, :rec_changedby,:rec_addedby) ';


// #########################################################################

const
  _CSQLInsertSpecialArticles = ' INSERT INTO articles(code, code2, name, unit, dim_h, dim_l, dim_w, type_, vat_id,' +
    ' barcode_def_id, barcode, cn8, ean_code, descr, manufacturer,' +
    ' url, shelfnumber, purchase_account_id, sale_account_id, expense_account_id,' +
    ' qty_flags, qty_minlevel, qty_maxlevel, price_calc_meth, special_type_flags, ' +
    ' status, archive_rec_id, company_id, rec_changed, rec_changedby,rec_addedby) ' +
    ' VALUES(:code, :code2, :name, :unit, :dim_h, :dim_l, :dim_w, :type_, :vat_id,' +
    ' :barcode_def_id, :barcode, :cn8, :ean_code, :descr, :manufacturer,' +
    ' :url, :shelfnumber, :purchase_account_id, :sale_account_id, :expense_account_id,' +
    ' :qty_flags, :qty_minlevel, :qty_maxlevel, :price_calc_meth, :special_type_flags, ' +
    ' :status, :archive_rec_id, :company_id, :rec_changed, :rec_changedby,:rec_addedby)';


// --------------
// kontod !
const
  _CSQLInsertNewAcc = ' INSERT INTO accounts(account_coding, account_name, company_id, init_balance,type_id,typecls_id,default_currency,' +
    ' parent_id, rec_changed, rec_changedby, rec_addedby,balance_rep_line_id,incstat_rep_line_id) ' +
    ' VALUES(:account_coding,:account_name,:company_id,:init_balance,:type_id,:typecls_id,:default_currency,' +
    ' :parent_id,:rec_changed,:rec_changedby,:rec_addedby,:balance_rep_line_id,:incstat_rep_line_id)';

const
  _CSQLGetAllAccounts = ' SELECT a.id,a.parent_id,' + //  a.account_group_id,b.name as accgrpname,
    ' a.account_coding, a.account_name,a.default_currency, a.company_id,a.balance_rep_line_id,a.incstat_rep_line_id, ' +
    ' a.init_balance,a.type_id,a.typecls_id,c.name as acctype,c1.name as accclassname,a.flags, ' +
    ' a.rec_changed, a.rec_changedby,a.rec_addedby,a.rec_deleted,a.bank_id, ' +
    ' a.account_nr,a.account_nr_iban,a.display_onbill,a.display_billtypes ' + ' FROM accounts a ' +
    //' LEFT OUTER JOIN account_group b ON '+
    //' b.id=a.account_group_id '+
    ' LEFT OUTER JOIN classificators c ON ' + ' c.type_=''account_type'' AND c.id=a.type_id ' +
    ' LEFT OUTER JOIN classificators c1 ON ' +
    ' c1.type_=''account_classificator'' AND c1.id=a.typecls_id ' +
    ' WHERE a.company_id IN (0,:company_id) ' + '  ORDER BY a.account_coding ASC ';

const
  _SQLCountAccounts = ' SELECT count(a.id) as acc_cnt FROM accounts a WHERE company_id=:company_id';

const
  _SQLCountAccounts2 = ' SELECT count(a.id) as acc_cnt FROM accounts a WHERE a.company_id=:company_id AND a.rec_deleted=''f''';

const
  _SQLInsertNewFormdEntry2 = ' INSERT INTO formd( form_name, form_type, descr, url, valid_from, valid_until, ' +
    ' company_id, rec_changed, rec_changedby, rec_addedby) ' +
    ' VALUES(:form_name, :form_type, :descr, :url, :valid_from, :valid_until, ' +
    ' :company_id, :rec_changed, :rec_changedby, :rec_addedby)';

const
  _SQLConfSelectLogo = ' SELECT id,val_blob ' + ' FROM conf ' + ' WHERE company_id=:company_id' +
    '   AND var_name=''billlogo''';

const
  _SQLUpdateLogo = ' UPDATE conf ' + ' SET val_blob=:val_blob,var_val=:var_val ' +
    ' WHERE company_id=:company_id' + '   AND var_name=''billlogo''';

const
  _SQLInsertLogo = ' INSERT INTO conf(var_name,var_val,val_blob,company_id) ' +
    ' VALUES(''billlogo'',:var_val,:val_blob,:company_id)';

const
  _SQLSelectMissingANumItems = ' SELECT p.id ' + ' FROM accounting_period p ' +
    ' WHERE NOT EXISTS(SELECT * FROM numerators n WHERE accounting_period_id=p.id) ' +
    '  AND p.company_id=:company_id';

const
  _SQLFlushNumeratorCache = ' DELETE FROM numeratorcache WHERE company_id=:company_id';

const
  _SQLIsNumUsed = ' SELECT MAX(a.id) as accr_id ' + ' FROM accounting_register a ' +
    ' WHERE a.accounting_period_id=:accounting_period_id ' + '   AND a.rec_deleted=''f'' ' +
    '   AND a.template=''f'' ' + '   AND EXISTS(SELECT n.id FROM numerators n ' +
    '        WHERE n.accounting_period_id=:accounting_period_id AND length(cr_srbfr)>2 )'; // &6 on ntx vaid pikkus


const
  _SQLFindActiveLanguage = ' SELECT item_value ' + ' FROM user_settings ' +
    ' WHERE item_name=''item_36'' ' + // selle võib hardcodeda see on useri language setting !!!
    '   AND user_id = 1 ';




function _SQLStaticNumToAccPerTypeNum(const pCompanyId: integer;
  const pPredefAccPeriodId: integer = -1): AStr;
function _SQLStaticNumToAccPerTypeNumExt(const pCompanyId: integer;
  const pPredefAccPeriodId: integer): AStr;

function _SQLSelectAccPeriodNumerators(const pEqualMode: boolean): AStr;
// 21.08.2009 ingmar
// kuna üritame "võimatut", et saaks suvalisele baasile ümbertõsta ilma uut toodet downloadimata
function _CSQLChangeUserPassword(const usrname: AStr; const usrpwd: AStr): AStr;
function _CSQLDbPrePublicRevokes: TAStrList;
function _CSQLCreateRole: AStr;
function _CSQLGrantRole: AStr;
function _SQLCountyList(const onlyValidItems: boolean = True): AStr;
function _SQLCityList(const onlyValidItems: boolean = True; const countyId: integer = -1): AStr;
function _SQLStreetList(const onlyValidItems: boolean = True; const cityId: integer = -1): AStr;

function _SQLGetAccListODesc(): AStr;

// -----------

implementation

uses estbk_dbcompability;

function _SQLStaticNumToAccPerTypeNum(const pCompanyId: integer;
  const pPredefAccPeriodId: integer = -1): AStr;
var
  pAStrList: TAStrList;
begin
  try
    pAStrList := TAStrList.Create;
    with pAStrList do
    begin
      add('INSERT INTO numerators(cr_num_val,cr_num_start,cr_num_type,cr_vrange_end,');
      add('cr_version,cr_valid,cr_srbfr,company_id,rec_changed,rec_changedby,rec_addedby,accounting_period_id)');
      // hetkel kehtib nö mitte rp. perioodiga numeraator !
      add('SELECT DISTINCT p.cr_num_val,p.cr_num_start,p.cr_num_type,p.cr_vrange_end,');
      add('p.cr_version,p.cr_valid,p.cr_srbfr,p.company_id,p.rec_changed,p.rec_changedby,p.rec_addedby,a.id');
      add('FROM numerators p');
      add('INNER JOIN accounting_period a ON');
      if pPredefAccPeriodId < 1 then
        add(format('1=1 AND a.company_id=%d', [pCompanyId]))
      else
        add(format('a.id=%d', [pPredefAccPeriodId]));

      // jama selles, et peame juba varasematele maj. aastatele ka genereerima numeraatorid, kõigile tuleb konv. hetkel üks !
      add(format('WHERE p.company_id=%d', [pCompanyId]));
      add('  AND COALESCE(p.accounting_period_id,0)=0');
      add('  AND NOT EXISTS(SELECT p1.id FROM numerators p1 WHERE p1.accounting_period_id=a.id AND p1.cr_num_type=p.cr_num_type AND p1.company_id=p.company_id)');
      // --
      // paStrlist.SaveToFile('c:\test.txt');
      Result := pAStrList.Text;
    end;
  finally
    FreeAndNil(pAStrList);
  end;
end;

function _SQLStaticNumToAccPerTypeNumExt(const pCompanyId: integer;
  const pPredefAccPeriodId: integer): AStr;
var
  pAStrList: TAStrList;
begin
  try
    pAStrList := TAStrList.Create;
    with pAStrList do
    begin
      add('INSERT INTO numerators(cr_num_val,cr_num_start,cr_num_type,cr_vrange_end,');
      add('cr_version,cr_valid,cr_srbfr,company_id,rec_changed,rec_changedby,rec_addedby,accounting_period_id)');

      //add('SELECT p.cr_num_val,p.cr_num_start,p.cr_num_type,p.cr_vrange_end,');
      add('SELECT 0 as cr_num_val,1 as cr_num_start,p.cr_num_type,p.cr_vrange_end,');
      add(format('p.cr_version,p.cr_valid,p.cr_srbfr,p.company_id,p.rec_changed,p.rec_changedby,p.rec_addedby,%d', [pPredefAccPeriodId]));
      add('FROM numerators p');
      add(format('WHERE p.company_id=%d', [pCompanyId]));
      // ei tohi olla juba seostatud rp. kirjega !
      add(format('  AND NOT EXISTS(SELECT p1.id FROM numerators p1 WHERE p1.accounting_period_id=%d AND p1.cr_num_type=p.cr_num_type AND p1.company_id=p.company_id)', [pPredefAccPeriodId]));
      add(' AND p.id=(');
      add('            SELECT MAX(p1.id) FROM numerators p1 WHERE p1.cr_num_type=p.cr_num_type AND p1.company_id=p.company_id');
      add('             AND p1.accounting_period_id=COALESCE((SELECT max(ap.accounting_period_id) FROM numerators ap WHERE ap.cr_num_type=p.cr_num_type AND ap.company_id=p.company_id  ) ,0)');
      add('          )');
      // --
      Result := pAStrList.Text;

    end;
  finally
    FreeAndNil(pAStrList);
  end;
end;


// ümbermappimine !
function _SQLSelectAccPeriodNumerators(const pEqualMode: boolean): AStr;
var
  pAStrList: TAStrList;
begin
  try
    pAStrList := TAStrList.Create;
    with pAStrList do
    begin
      // ---
      add('SELECT * ');
      add('FROM numerators');
      add('WHERE company_id=:company_id ');


      if pEqualMode then
        add('  AND  accounting_period_id=:accounting_period_id ')
      else
        add('  AND (accounting_period_id<>:accounting_period_id) AND (accounting_period_id>0)');
      add('  AND  rec_deleted=''f''');

      add('ORDER BY ');
      add(' (');
      add('   CASE WHEN cr_num_type=''ACNR''  THEN 1 ');  // # pearaamatu kanded
      add('        WHEN cr_num_type=''ABLNR'' THEN 2 ');  // # arvete kandeseeria nr; nüüdsest müügiarve !
      add('        WHEN cr_num_type=''ABPNR'' THEN 3 ');  // # ostuarvete kandeseeria
      add('        WHEN cr_num_type=''ABCNR'' THEN 4 ');  // # kreeditarve kandeseeria
      add('        WHEN cr_num_type=''ABRNR'' THEN 5 ');  // # ettemaksuarve kandeseeria
      add('        WHEN cr_num_type=''ABDNR'' THEN 6 ');  // # viivisarve kandeseeria
      add('        WHEN cr_num_type=''INCNR'' THEN 7 ');  // # laekumise kandeseeria nr
      add('        WHEN cr_num_type=''APMNR'' THEN 8 ');  // # panga tasumiste kandeseeria
      add('        WHEN cr_num_type=''ACINR'' THEN 9 ');  // # kassa sissetulekuorderi kandeseeria
      add('        WHEN cr_num_type=''ACONR'' THEN 10 '); // # kassa väljaminekuorder kandeseeria

      add('        WHEN cr_num_type=''BLNR''  THEN 11 '); // # müügiarve nr
      add('        WHEN cr_num_type=''CBLNR'' THEN 12 '); // # kreeditarve nr
      add('        WHEN cr_num_type=''CDLNR'' THEN 13 '); // # viivisarve nr
      add('        WHEN cr_num_type=''PONR''  THEN 14 '); // # ostutellimuse nr
      add('        WHEN cr_num_type=''PSNR''  THEN 15 '); // # müügitellimuse nr
      add('        WHEN cr_num_type=''OFFNR'' THEN 16 '); // # pakkumise nr
      add('        WHEN cr_num_type=''PMONR'' THEN 17 '); // # maksekorralduse doc. nr
      add('        WHEN cr_num_type=''CSRNR'' THEN 18 '); // # kassa dokumendi number
      add('     ELSE ');
      add('        99');
      add('     END');
      add(' )');
      Result := pAStrList.Text;

    end;
  finally
    FreeAndNil(pAStrList);
  end;
end;


function _CSQLChangeUserPassword(const usrname: AStr; const usrpwd: AStr): AStr;
begin
  Result := format('ALTER USER %s WITH PASSWORD ''%s''', [usrname, usrpwd]);
end;

// trikiga koht, anname välja vajalikud grandid, et kasutajad ei saa kuritarvitada oma õigusruumi;
// TULEMUS tuleb vabastada !! Teise backendide puhul võib tulem olla NIL
function _CSQLDbPrePublicRevokes: TAStrList;
begin
  Result := TAStrList.Create;
  Result.Add('REVOKE ALL ON DATABASE ' + estbk_types.CProjectDatabaseNameDef + ' FROM public');
  Result.Add('REVOKE ALL ON SCHEMA public FROM public');
  Result.Add('GRANT ALL ON SCHEMA public TO postgres');
  Result.Add('GRANT USAGE ON SCHEMA public TO ' + estbk_types.CProjectRolename);
  Result.Add('GRANT CONNECT,TEMPORARY ON DATABASE ' + estbk_types.CProjectDatabaseNameDef + ' TO ' + estbk_types.CProjectRolename);
  //result.Add('GRANT '+estbk_types.CProjectDatabaseNameDef+' TO '+estbk_types.CProjectRolename);
  // CSQLRemAllPermFromPublic = 'REVOKE ALL PRIVILEGES ON SCHEMA public FROM public';   // anname õigused ise;
  // 'REVOKE ALL PRIVILEGES ON SCHEMA %s FROM %s';
end;


function _CSQLCreateRole: AStr;
begin
  // TODO: teiste baaside case ka lisada !
  Result := 'CREATE ROLE %s NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE';
end;

function _CSQLGrantRole: AStr;
begin
  Result := 'GRANT %s TO %s';
end;



// -------------
function _SQLCountyList(const onlyValidItems: boolean = True): AStr;
begin
  Result := ' SELECT id,name,valid,rec_changed,rec_changedby, rec_addedby,countrycode ' + ' FROM county ';
  if onlyValidItems then
    Result := Result + ' WHERE valid=' + estbk_dbcompability.sqlp._booleanValForCurrBackEnd(True);
  Result := Result + ' ORDER BY name ';
end;

function _SQLCityList(const onlyValidItems: boolean = True; const countyId: integer = -1): AStr;
begin
  Result := ' SELECT id,name,valid,rec_changed,rec_changedby, rec_addedby,countrycode  ' + ' FROM city ';
  if onlyValidItems then
    Result := Result + ' WHERE valid=' + estbk_dbcompability.sqlp._booleanValForCurrBackEnd(True);
  Result := Result + ' ORDER BY name ';
end;

function _SQLStreetList(const onlyValidItems: boolean = True; const cityId: integer = -1): AStr;
begin
  Result := ' SELECT id,name,valid,rec_changed,rec_changedby, rec_addedby,countrycode  ' + ' FROM street ';
  if onlyValidItems then
    Result := Result + ' WHERE valid=' + estbk_dbcompability.sqlp._booleanValForCurrBackEnd(True);
  Result := Result + ' ORDER BY name ';
end;


// raamatupidamisaasta päringud
function _SQLGetAccListODesc(): AStr;
var
  pStr: TAStrList;
begin
  try
    pStr := TAStrList.Create;
    with pStr do
    begin
      // selline jama draiveriga, kui teeme casti, siis pole võimalik kuidagi teda redigeerida !!!
      // välja peal saad invalid format
      Add('SELECT a.id, a.name as accname, a.period_start, a.period_end, a.company_id, a.rec_changed,a.status,');
      // char 25 kindel mats; ilma, et peaksime compability klassi kasutama
      Add('a.rec_changedby, a.rec_addedby, a.rec_deletedby, a.rec_deleted,'); // dummystat et saaksime checkboxi muretult kasutada !
      // 14.04.2012 Ingmar
      Add('''...'' as btncapt');
      Add('FROM accounting_period a');
      Add('WHERE a.company_id=:company_id');
      Add(' AND a.status<>''D'''); // et kirjet poleks kustutatud   !!!!!!!
      Add('ORDER BY a.period_end DESC');
      Result := pStr.Text;
    end;

  finally
    FreeAndNil(pStr);
  end;
  // ----------

end;


end.
