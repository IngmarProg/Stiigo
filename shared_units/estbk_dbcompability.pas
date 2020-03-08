unit estbk_dbcompability;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface

uses
  Classes, SysUtils, StrUtils, ZConnection, estbk_types;

type
  TCTablenames = (__scclassificators = 0,
    __sccounty,
    __sccity,
    __scstreet,
    __sccity_street_rel,
    __sccompany, // jäta nagu on !
    //__scdepartment, pole vaja teeme seda läbi firma !!!
    __scdocument_tree_nodes,
    __scdocuments,
    __scdocument_files,
    __scdocumentfield_data_labels,
    __scdocumentfield_values,
    __scclient,
    __scclientcontactpersons,

    __scVAT,
    // 27.09.2009 ingmar; lihtsustasin, ennem olid toote ja teenuste tabel; nüüd articles tabel,
    // kus vastavalt tüübile saame andmed
    //__scproduct_groups,
    __scarticles_groups,
    __scarticles,  // goods/ product kõlab paremini
    __scarticles_attrb, // laiendus;
    __scarticles_price_table,
    //__scservices,
    //__scservice_price_table,
    __scclient_discount,
    __scemail,


    // 28.12.2010 Ingmar tulevikus taastame, ennem peab täpsemalt läbi mõtlema selle kampaaniate osa !!!
    //__sccampaign,
    //__sccampaign_bindings,

    __scaccounting_period,
    __screferencenumbers,
    //__scprepayment,

    // 05.12.2009 tõstsin ülespoole
    //__scaccountgroup,
    __scaccounts,
    __scaccounting_register,  // sisuliselt raamatuspidamiskirjendid
    __scaccounting_register_documents, // raamatuspidamiskirjendiga seotud dokumendid
    __scaccounting_records,  // deebet/kreeditkontod
    __scaccounting_rec_attrb,
    __scaccounting_prepayment_usage,

    //__scprepayment_dist_scheme,
    __scbills,
    __scbill_lines,
    __scpayment,
    __scpayment_data,
    __scpayment_files,

    __scorders,
    // algselt sai pandud nimi order, aga see on sql keyword ja postgres saatis mind kurke müüma selle peale create table order
    __scorder_billing_data,
    __scorder_lines,

    //__sclate_payments,
    __scincomings,
    __scincomings_sessions,
    __scincomings_bank,
    __scwarehouse,

    __scinventory,
    __scinventory_documents,

    __scemail_notifier,
    __scemail_notifier_sessions,
    // taastame siis, kui põhivara osa on selge !
    //__scassetgroup,
    //__scassets,
    __scclient_documents,
    //__scemployment_contract,
    //__scarticles_accounts,
    __scusers,
    __scuser_permission_descr,
    __scuser_permissions,
    __scuser_settings,
    __scrole,
    __scrole_permissions,
    __scrole_userroles,
    __scuser_company_acclist,
    __scconf,
    __scsystemconf,
    __scbanks,
    __scobjects,
    __scnumerators,
    __sccurrency_exc,
    __scaccounts_reqobjects,
    __scinternal_systemtypes,
    __scdefault_sysaccounts,
    __scstatus_report,
    __scstatus_report_lines,
    __scformd,
    __scformd_lines,
    __sctaxd_history,
    __sctaxd_history_lines,
    // 10.05.2011 Ingmar; peame nüüd hoidma infot, kas keegi on mingi arve avanud, siis märgime lukustatuks, sest mitu inimest ei tohi korraga asja muuta
    __sclocked_objects,
    __sctaxes,
    __scnumeratorcache,
    __scdynamicdnshost,
    __scwebusers,
    __scsentemails,
    __scsepafile,
    __scsepafileentry
    {$ifdef wagemodule_enabled}
    , __scemployee,
    __scemployee_id_document,
    __scemployment_contract,
    __scwage_types,
    //__scwage_type_taxes,
    __scemployee_wage,
    __scemployee_wage_lines,
    __scemployee_wtimetable,
    __scpayroll,
    __scpayroll_entry
    {$endif}
    );




type
  TSetOfTableNames = set of TCTablenames;

const
  CTable_names: array[TCTablenames] of AStr = (
    'classificators',
    'county',
    'city',
    'street',
    'city_street_rel',
    'company',
    'document_tree_nodes',
    'documents',
    'document_files',
    'document_field_labels',
    'document_field_values',
    //'department',
    'client',
    'client_contact_persons',
    'vat',
    //'product_group', // ---
    'articles_group', // ---
    'articles',
    'articles_attrb',
    'articles_price_table',
    //'services',
    //'services_price_table',
    'client_discount',
    'email',
    // 28.12.2010 Ingmar; tulevikus taastada, kui kampaaniate osa paremini läbi mõeldud !
    //'campaign',
    //'campaign_bindings',
    'accounting_period',
    'referencenumbers',
    //'prepayment',
    // 05.12.2009 Ingmar
    //'account_group', // ---
    'accounts',
    'accounting_register',
    'accounting_register_documents',
    'accounting_records',
    'accounting_records_attrb',
    // 01.12.2010
    'accounting_prepayment_usage',
    // 02.09.2010 Ingmar
    //'prepayment_dist_scheme', // ettemaksude jaotus
    'bills',
    'bill_lines',
    'payment',
    'payment_data',
    'payment_files',

    'orders',
    'order_billing_data',
    'order_lines',

    //'late_payments',
    'incomings',
    'incomings_sessions',
    'incomings_bank',
    'warehouse',

    'inventory',
    'inventory_documents',

    'email_notifier',
    'email_notifier_sessions',
    //'asset_group', // ---
    //'assets',
    'client_documents',
    //'employment_contract',
    //'articles_accounts',
    'users',
    'user_permission_descr',
    'user_permissions',
    'user_settings',
    'role',
    'role_permissions',
    'user_roles',
    'user_company_acclist', // sisuliselt mis firmade alt kasutaja saab töötada
    'conf',
    'system_conf',
    'banks',
    'objects',
    'numerators',
    'currency_exc',
    'accounts_reqobjects',
    '__int_systemtypes',
    'default_sysaccounts',
    'status_report',
    'status_report_lines',
    'formd',
    'formd_lines',
    'taxd_history',
    'taxd_history_lines',
    // 10.05.2011 Ingmar
    'locked_objects',
    'taxes', // 22.01.2012 Ingmar
    'numeratorcache',
    'dynamicdnshost',
    'webusers',
    'sentemails',
    'sepafile',
    'sepafileentry'
    {$ifdef wagemodule_enabled}
    , 'employee',
    'employee_id_document',
    'employment_contract',
    'wage_types',
    //'wage_type_taxes',
    'employee_wage',
    'employee_wage_lines',
    'employee_wtimetable',
    'payroll',
    'payroll_entry'
    {$endif}
    );


type
  TTable_Defs = array[TCTablenames] of AStr;

// http://www.postgresql.org/docs/8.1/interactive/sql-createtable.html
type

  TSqlCompatibility = class
    FCurrentBackEnd: TCurrentDatabaseBackEnd;
  public
    // 31.08.2009 ingmar; hetkel postgre, järgmiseks ehk firebird
    // saame öelda, millise backendiga töötame;
    property currentBackEnd: TCurrentDatabaseBackEnd read FCurrentBackEnd;
    // -- init connection;
    procedure getCurrentBackEndDefaultServerAndPort(var defaultHost: AStr; var defaultPort: integer); // ntx postgre default port: 5432
    function getCurrentBackEndProtocol: AStr;
    procedure initPropertiesByBackend(const prop: TStrings);

    // -- return selects !
    function _isUserAdminSQL: AStr; // rezField: use fieldindex 1 !!  superuser|admin
    function _encodePassword(const pwd: AStr): AStr;
    function _decodePassword(const pwd: AStr): AStr;
    function _createUserSQL(const username: AStr; const password: AStr): AStr;
    function _chgPasswordSQL(const username: AStr; const password: AStr): AStr;
    function _getDatabaseNamesSQL: AStr; // rezField: databasename
    function _getCurrentschemaSQL: AStr; // rezField: schemaname
    function _getDatabaseVerSQL: AStr;   // rezField: version
    function _getAllTablesSQL: AStr;     // rezField:  tablename;etc per db ver
    function _getDefaultDatabaseName: AStr;


    // TSQL->LIKE
    function _getCurrDateTime: AStr;
    function _like(): AStr;
    function _doSafeSQLStrConcat(const pFields: array of const): AStr;
    function _datediff(const pdtBegins: AStr; const pdtEnds: AStr): AStr; // days !


    // 10.10.2009 Ingmar
    function _getHdrLimitRowsSQL(const rowCnt: integer; const offset: integer): AStr; // ntx MSSQL TOP 45

    function _getFtrLimitRowsSQL(const rowCnt: integer; const offset: integer): AStr; // ntx LIMIT 0,15

    function _generateForeignKeySQL(const keytoChk: AStr; const tableToChk: AStr; const keyInTable: AStr): AStr;
    function _booleanValForCurrBackEnd(const trueFalse: boolean): AStr;
    function _getLastIdSQL(const tableName: TCTablenames): AStr;


    function _aquireUTF8ConnectionSQL: AStr;
    // DB testid !
    function assert_test_1_9559: AStr;
    // ########################################################################
    // temp tabelite nimed hea tava hoida täiendavalt unikaalsed;
    function _create_temptable(var pTableName: AStr; const pBodyStr: AStr; const pGetQryBodyFromSelect: boolean = False;
      const pDropOnCommitFlag: boolean = True): AStr;
    function _create_databaseSQL(const defaultdbName: AStr = CProjectDatabaseNameDef; const fullLocale: AStr = ''): AStr;
    // ---
    constructor Create(const backend: TCurrentDatabaseBackEnd = __postGre); reintroduce;
  end;

var
  sqlp: TSqlCompatibility;

implementation

uses variants;

constructor TSqlCompatibility.Create(const backend: TCurrentDatabaseBackEnd = __postGre);
begin
  inherited Create;
  FCurrentBackEnd := backend;
end;


procedure TSqlCompatibility.getCurrentBackEndDefaultServerAndPort(var defaultHost: AStr; var defaultPort: integer);
const
  SCLocal = 'localhost';
begin
  defaultHost := '';
  defaultPort := 0;
  // ---
  case FCurrentBackEnd of
    __postGre:
    begin
      defaultPort := 5432;
      defaultHost := SCLocal;
    end;
  end;
end;

function TSqlCompatibility.getCurrentBackEndProtocol: AStr;
begin
  // currently support postgresql-8 and higher !
  case FCurrentBackEnd of
    __postGre:
    begin
      // libpq81.dll
      // libpq.dll
      // default path in windows: C:\Program Files\PgOleDB
      Result := 'postgresql';
    end;
  end;
end;

procedure TSqlCompatibility.initPropertiesByBackend(const prop: TStrings);
begin
  // ---
  case FCurrentBackEnd of
    __postGre: prop.Add('codepage=UTF8');
  end;
end;

// is_superuser:
(*
  postgre vars
   SESSION_USER; CURRENT_USER
   http://www.postgresql.org/docs/8.2/static/sql-show.html

   SHOW IS_SUPERUSER
   - IS_SUPERUSER
   - True if the current role has superuser privileges.
*)

function TSqlCompatibility._isUserAdminSQL: AStr;
begin
  // ---
  case FCurrentBackEnd of
    __postGre: Result := 'SHOW IS_SUPERUSER';
    // __msSql   : select IS_SRVROLEMEMBER ('sysadmin');
  end;
end;

// tuleviku jaoks !
function TSqlCompatibility._EncodePassword(const pwd: AStr): AStr;
begin
  Result := pwd;
end;

function TSqlCompatibility._DecodePassword(const pwd: AStr): AStr;
begin
  Result := pwd;
end;

function TSqlCompatibility._createUserSQL(const username: AStr; const password: AStr): AStr;
begin
  case FCurrentBackEnd of
    // 02.10.2017 Ingmar; alates 9.6.4 ei toeta enam postgres süntaksit
    // __postGre : result:=format('CREATE USER %s WITH  PASSWORD ''%s'' NOCREATEUSER NOCREATEDB ',[username,self._EncodePassword(password)]);
    // 18.11.2018 Ingmar
    // NOCREATEUSER pole enam toetatud !!!
    __postGre: Result := format('CREATE ROLE %s WITH  LOGIN PASSWORD %s  NOCREATEDB ', [username, QuotedStr(self._EncodePassword(password))]);
    // __msSql   : select IS_SRVROLEMEMBER ('sysadmin');
  end;
end;

function TSqlCompatibility._chgPasswordSQL(const username: AStr; const password: AStr): AStr;
begin
  case FCurrentBackEnd of
    // __postGre : result:=format('ALTER USER %s IDENTIFIED BY %s',[username,self._EncodePassword(password)]);
    __postGre: Result := format('ALTER ROLE %s WITH PASSWORD %s', [username, QuotedStr(self._EncodePassword(password))]);
  end;
end;

function TSqlCompatibility._getDatabaseNamesSQL: AStr;
begin
  // ---
  // 18.03.2010 ingmar; datcollate puudub postgres 8.3 ver
  case FCurrentBackEnd of
    // SELECT datname as databasename,pg_encoding_to_char(encoding),datacl FROM pg_database
    //__postGre : result:='SELECT datname as databasename,pg_encoding_to_char(encoding),datacl FROM pg_database';
    __postGre: Result := 'SELECT datname as databasename,pg_encoding_to_char(encoding) as encoding,datacl,datcollate,datistemplate FROM pg_database';
  end;
end;

// schemaname
function TSqlCompatibility._getCurrentschemaSQL: AStr;
begin
  // ---
  case FCurrentBackEnd of
    __postGre: Result := 'SELECT current_schema() as schemaname';
    // __msSQL: result:='select schema_name() as schemaname';
  end;
end;

function TSqlCompatibility._getDatabaseVerSQL: AStr;
begin
  // ---
  case FCurrentBackEnd of
    __postGre: Result := 'SELECT VERSION() as version';
  end;
end;

function TSqlCompatibility._getAllTablesSQL: AStr;     // rezField: tablename; etc per db ver
begin
  // ---
  case FCurrentBackEnd of
 (*
   r = ordinary table, i = index, S = sequence, v = view, c = composite type, t = TOAST table
  SELECT relname as tablename, relacl
  FROM pg_class WHERE  relkind IN ('r', 'v') AND relname !~ '^pg_'
     rolename=xxxx -- privileges granted to a role
              =xxxx -- privileges granted to PUBLIC

                  r -- SELECT ("read")
                  w -- UPDATE ("write")
                  a -- INSERT ("append")
                  d -- DELETE
                  x -- REFERENCES
                  t -- TRIGGER
                  X -- EXECUTE
                  U -- USAGE
                  C -- CREATE
                  c -- CONNECT
                  T -- TEMPORARY
             arwdxt -- ALL PRIVILEGES (for tables)
                  * -- grant option for preceding privilege

              /yyyy -- role that granted this privilege
  *)
    __postGre: Result := ' SELECT relname as tablename, relacl ' + ' FROM pg_class WHERE  relkind IN (''r'', ''v'') AND relname !~ ''^pg_''';
    // __msSQL   : result:='SELECT id, owner = user_name(uid), name, status FROM dbo.sysobjects WHERE type = N'U' order by name'; 26.08.2009 Ingmar; MSSQL kauges tulevikus
  end;
end;

// hetkel ühenduse põhine temptabel; globaalset "veel" ei ole vaja
function TSqlCompatibility._create_temptable(var pTableName: AStr; const pBodyStr: AStr; const pGetQryBodyFromSelect: boolean = False;
  const pDropOnCommitFlag: boolean = True): AStr;
var
  tTablePrefix: AStr;
  tAttr: AStr;
begin
  if pBodyStr <> '' then
  begin
    tTablePrefix := inttohex(random(20000) + 10000, 5) + '_' + inttohex(random(65000), 5);
    pTableName := pTableName + tTablePrefix;

    case FCurrentBackEnd of
      __postGre:
      begin
        tAttr := '';
        if pDropOnCommitFlag then
          tAttr := ' ON COMMIT DROP ';

        if pGetQryBodyFromSelect then
          tAttr := tAttr + ' AS ';


        case pGetQryBodyFromSelect of
          //true : result:=format('CREATE  TEMPORARY TABLE %s  %s  AS %s ',[pTableName,tAttr,pBodyStr]);
          True: Result := format('CREATE  TEMPORARY TABLE %s  %s %s ', [pTableName, tAttr, pBodyStr]);
          False: Result := format('CREATE  TEMPORARY TABLE %s %s %s', [pTableName, pBodyStr, tAttr]);
        end;

      end;
    end;
    // --
  end;
  // ---
end;


function TSqlCompatibility._create_databaseSQL(const defaultdbName: AStr = CProjectDatabaseNameDef; const fullLocale: AStr = ''): AStr;
begin
{

CREATE DATABASE postgres
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       LC_COLLATE = 'Estonian, Estonia'
       LC_CTYPE = 'Estonian, Estonia'
       CONNECTION LIMIT = -1;
}
  // Hetkel oleme veel eestipärased...
  case FCurrentBackEnd of
    __postGre: Result := 'CREATE DATABASE ' + __dbNameOverride(defaultdbName) + ' WITH ENCODING=''UTF8''  CONNECTION LIMIT = -1 ' +
        ifthen(length(fullLocale) > 0, format(' LC_COLLATE = ''%s'' ', [fullLocale]), ' ') +
        ifthen(length(fullLocale) > 0, format(' LC_CTYPE = ''%s'' ', [fullLocale]), ' '); // ntx C või Posix

  end;
end;

function TSqlCompatibility._getDefaultDatabaseName: AStr;
begin
  case FCurrentBackEnd of
    __postGre: Result := 'postgres';
  end;
end;

function TSqlCompatibility._getCurrDateTime: AStr;
begin
  case FCurrentBackEnd of
    __postGre: Result := ' now() ';
  end;
end;

// 12.02.2011 Ingmar; like on ka erinev !
function TSqlCompatibility._like(): AStr;
begin
  Result := ' LIKE ';
  case FCurrentBackEnd of
    __postGre: Result := ' ILIKE ';// isensitive case ! meil vaja, et  päringud poleks tõusutundlikud !
  end;
end;

// 08.03.2010 ingmar
function TSqlCompatibility._doSafeSQLStrConcat(const pFields: array of const): AStr;
var
  i: integer;
  pCntMarker: AStr;
begin
  // MYSQL on ntx concat(......)
  pCntMarker := ',';
  case FCurrentBackEnd of
    __postGre: pCntMarker := '||';
    else
      pCntMarker := '+';
  end;


  Result := '';

  for i := low(pFields) to high(pFields) do
  begin
    if i <> low(pFields) then
      Result := Result + pCntMarker;
    Result := Result + AStr(pFields[i].VAnsiString);
  end;
end;

function TSqlCompatibility._datediff(const pdtBegins: AStr; const pdtEnds: AStr): AStr;
begin
  Result := '';
  case FCurrentBackEnd of
    __postGre: Result := format(' date_part(''days'',%s-%s) ', [pdtBegins, pdtEnds]);
  end;
end;

function TSqlCompatibility._getHdrLimitRowsSQL(const rowCnt: integer; const offset: integer): AStr;
begin
  Result := '';
end;

function TSqlCompatibility._getFtrLimitRowsSQL(const rowCnt: integer; const offset: integer): AStr;
begin
  case FCurrentBackEnd of
    __postGre: Result := format(' LIMIT %d OFFSET  %d', [rowCnt, offset]);
  end;
end;

function TSqlCompatibility._generateForeignKeySQL(const keytoChk: AStr; const tableToChk: AStr; const keyInTable: AStr): AStr;
const
  SForeignKeyMask_Postgre = ' FOREIGN KEY (%s) REFERENCES %s(%s) MATCH FULL ON DELETE RESTRICT ';
begin
  case FCurrentBackEnd of
    __postGre: Result := format(SForeignKeyMask_Postgre, [keytoChk, tableToChk, keyInTable]);
  end;
end;

function TSqlCompatibility._booleanValForCurrBackEnd(const trueFalse: boolean): AStr;
begin
  case FCurrentBackEnd of
    __postGre: if trueFalse then
        Result := ' true '
      else
        Result := ' false ';
  end;
end;

function TSqlCompatibility._getLastIdSQL(const tableName: TCTablenames): AStr;
const
  SIdSeqMask = '%s_id_seq'; // 23.08.2009 ingmar sequence tore asi, aga firebirdil polnud viimane sequence sessioonipõhine !!!
begin
  case FCurrentBackEnd of
    __postGre: Result := format(SIdSeqMask, [CTable_names[tableName]]);
  end;
end;

function TSqlCompatibility._aquireUTF8ConnectionSQL: AStr;
begin
  Result := ' SELECT 1';
  case FCurrentBackEnd of
    __postGre: Result := 'set client_encoding = ''UTF-8''';
  end;
end;

// 23.03.2010 Ingmar; lisasin testi, sest mingitel hetkedel postgres andis numeric välja väärtuseks 0
// kas zeose bugi ei tea !!!
function TSqlCompatibility.assert_test_1_9559: AStr;
begin
  Result := '#';
  case FCurrentBackEnd of
    __postGre: Result := 'select cast(''1.9559'' as numeric(19,4)) as test';
  end;
end;


initialization
  if not assigned(sqlp) then
    sqlp := TSqlCompatibility.Create;

finalization
  sqlp.Free;
end.