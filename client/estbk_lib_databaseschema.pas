{$i estbk_defs.inc}
unit estbk_lib_databaseschema;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, estbk_types, estbk_dbcompability, estbk_lib_mapdatatypes;

type

  TEstbk_databaseschema = class(TEstbk_MapDataTypes)
  protected
    FTableDefs: TTable_Defs;
    FDbObjectsWithFooter: TSetOfTableNames;
    FBackEndType: TCurrentDatabaseBackEnd;
    // ---
    function __GenerateAutonumber(const table: TCTablenames; const fieldName: AStr = 'id'): AStr;
    procedure __addModFooter(const table: TCTablenames; const tableDef: TAStrlist; const addDelTrackerField: boolean = True);
    procedure __addConstraint(const table: TCTablenames; const tableDef: TAStrlist);
  public
    property TableDefs: TTable_defs read FTableDefs;
    procedure DumpTableDefsInfo(const filename: string);

    function __createAutonumberSQL(const table: TCTablenames; const fieldName: AStr = 'id'): AStr;
    function __createSeqTriggerSQL(const table: TCTablenames; const fieldName: AStr = 'id'): AStr;
    procedure __generateIndexSQL(const table: TCTablenames; const IndexSQL: TAStrList);
    procedure __getSchemaUpdates(const updateSQLs: TAStrList);

    // ---
    constructor Create(const cDbBackend: TCurrentDatabaseBackEnd); reintroduce;
    destructor Destroy; override;
  end;

// 18.08.2009 Ingmar
// abifunktsioon, et kusagil poleks HARDCODED tabelinimesid !! gt - get table name
function _gtn(const table: TCTablenames): string;

implementation

uses estbk_utilities, estbk_globvars, estbk_sqlcollection;

function _gtn(const table: TCTablenames): string;
begin
  Result := CTable_names[table];
end;


// ---------------------------------------------------------------------------
// ÜKS TÄHTIS meetod, siin kanname hoolt, et schema ikka oleks uuendatud ning käitume vastavalt versioonile
// ---------------------------------------------------------------------------

procedure Testbk_databaseschema.__getSchemaUpdates(const updateSQLs: TAStrList);
// listi pannakse vajalikud uuendused
begin
end;



// ---------------------------------------------------------------------------
//  16.08.2009 Ingmar; et saaksime ülevaate enda tabeli struktuuridest...
procedure Testbk_databaseschema.DumpTableDefsInfo(const filename: string);
var
  i: TCTablenames;
  dmp: TextFile;
begin
  assignfile(dmp, filename);
  rewrite(dmp);
  // ---
  for i := low(TCTablenames) to high(TCTablenames) do
    writeln(dmp, self.FTableDefs[i]);
  closefile(dmp);
end;


function Testbk_databaseschema.__createAutonumberSQL(const table: TCTablenames; const fieldName: AStr = 'id'): AStr;
begin
  // 17.08.2009 Ingmar; olen täiesti teadlik Postgre serial muutujast...bigserial,serial; sequence annab parema portimise võimaluse Firebird, Oracle tarbeks
  // jätame vahele
  if not (table in [__scdocumentfield_values, __scclient_documents,
    //__scorder_billing_data,
    //__scpayment_order_data,
    __scemail_notifier_sessions, __scrole_permissions, __scuser_permissions,
    __scrole_userroles, __scinternal_systemtypes]) then
    case self.FBackEndType of
      __postGre: Result := ' CREATE SEQUENCE ' + CTable_names[table] + '_' + fieldName + '_seq START 1 ';
    end;
end;

function Testbk_databaseschema.__createSeqTriggerSQL(const table: TCTablenames; const fieldName: AStr = 'id'): AStr;
begin
  // reserved
  Result := '';
end;

procedure Testbk_databaseschema.__generateIndexSQL(const table: TCTablenames; const IndexSQL: TAStrList);
begin
  IndexSQL.Clear;
  with IndexSQL do
    case table of
      __scbanks:
      begin
        ///add(format(CSQLCreateUIndexMask,[_gtn(table)+'_uncc',_gtn(table),'name,account_nr,account_nr_iban,active,company_id']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_ubank', _gtn(table), 'name,swift,lcode,company_id']));
      end;

      __sccompany:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + 'parent_dp_id', _gtn(table), 'parent_id']));
      end;

      __scclassificators:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_type', _gtn(table), 'type_,name,company_id']));
        // 11.03.2011 Ingmar;
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_user_id', _gtn(table), 'user_id']));
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_cmp',_gtn(table),'company_id']));
      end;
      __sccounty,
      __scstreet:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_name', _gtn(table), 'name']));
      end;

      __sccity:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_name', _gtn(table), 'name']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_cty', _gtn(table), 'county_id']));
      end;
{
   __scdepartment:
                begin
                  add(format(CSQLCreateUIndexMask,[_gtn(table)+'_name',_gtn(table),'company_id,code']));
                end;
}
      __sccity_street_rel:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_cc_id', _gtn(table), 'city_id,street_id']));
      end;

      __scclient:
      begin
        // 19.08.2009 ingmar; indekseid pole mõtet siin kombineerida, isiklikele kogemustele tuginedes võin öelda, et kasutatakse eraldi välju
        add(format(CSQLCreateindexMask, [_gtn(table) + '_name', _gtn(table), 'name']));
        add(format(CSQLCreateindexMask, [_gtn(table) + '_lastname', _gtn(table), 'lastname']));
        add(format(CSQLCreateindexMask, [_gtn(table) + '_regnr', _gtn(table), 'regnr']));
        add(format(CSQLCreateindexMask, [_gtn(table) + '_county_id', _gtn(table), 'county_id']));
        add(format(CSQLCreateindexMask, [_gtn(table) + '_city_id', _gtn(table), 'city_id']));
        add(format(CSQLCreateindexMask, [_gtn(table) + '_street_id', _gtn(table), 'street_id']));
        // maja ja korteri nr jätame küll välja...tule taevas...peaministri juurde
        add(format(CSQLCreateindexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
        add(format(CSQLCreateindexMask, [_gtn(table) + '_srcval', _gtn(table), 'srcval']));
        // 12.02.2011
        add(format(CSQLCreateindexMask, [_gtn(table) + '_client_code', _gtn(table), 'client_code']));
      end;


      __scclientcontactpersons:
      begin
        add(format(CSQLCreateindexMask, [_gtn(table) + '_client_id', _gtn(table), 'client_id']));
      end;


      __scVAT:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pvatindx_1', _gtn(table), 'company_id,valid']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pvatindx_2', _gtn(table), 'base_rec_id']));

        //add(format(CSQLCreateUIndexMask,[_gtn(table)+'_descpc2',_gtn(table),'company_id,defaultvat']));

        add(format(CSQLCreateIndexMask, [_gtn(table) + 'acc1', _gtn(table), 'vat_account_id_s']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + 'acc2', _gtn(table), 'vat_account_id_i']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + 'acc3', _gtn(table), 'vat_account_id_p']));

      end;

      __scarticles_groups:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_comp', _gtn(table), 'company_id']));
      end;

      //__scproducts,
      //__scservices:
      __scarticles:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_name', _gtn(table), 'name']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_code', _gtn(table), 'code,company_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_comp', _gtn(table), 'company_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_art_type', _gtn(table), 'type_']));
        // me ei saa kontodele constrainti kohustuslikuks teha !!! kuna väärtused võivad 0 olla
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pacc', _gtn(table), 'purchase_account_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_sacc', _gtn(table), 'sale_account_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_scacc', _gtn(table), 'expense_account_id']));

        add(format(CSQLCreateIndexMask, [_gtn(table) + '_btc', _gtn(table), 'batch_number']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_btid', _gtn(table), 'batch_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_artgrp', _gtn(table), 'articles_groups_id']));

        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_warehouseid',_gtn(table),'warehouse_id']));
        // 05.05.2014 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_disp_web_dir', _gtn(table), 'disp_web_dir']));
      end;

      __scarticles_attrb:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_art_rec_type_id', _gtn(table), 'article_id, attrib_type']));
      end;

      //__scproducts_price_table:
      __scarticles_price_table:
      begin
        //add(format(CSQLCreateUIndexMask,[_gtn(table)+'_priceprod',_gtn(table),'article_id,begins,ends,type_']));
        // 05.12.2009 Ingmar; kahjuks on ka võimalus, et samal päeval mitu muutust !!!!
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_priceprod', _gtn(table), 'article_id,begins,ends,type_']));
      end;

      // 21.06.2009
   {
   __scarticles_accounts:
                begin
                  add(format(CSQLCreateUIndexMask,[_gtn(table)+'_art_id',_gtn(table),'article_id,type_']));
                  add(format(CSQLCreateUIndexMask,[_gtn(table)+'_acc_id',_gtn(table),'account_id']));
                end;
   }
   {
   __scservice_price_table:
                begin
                  add(format(CSQLCreateUIndexMask,[_gtn(table)+'_serviceprod',_gtn(table),'service_id,begins,ends']));
                end;
   }
      __scclient_discount:
      begin
        //add(format(CSQLCreateUIndexMask,[_gtn(table)+'_disc',_gtn(table),'client_id,productgroup_id,product_id,service_id,status']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_itemid_stat', _gtn(table), 'item_type,item_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_comp', _gtn(table), 'company_id']));
      end;
      // 28.12.2010 Ingmar
   {
   __sccampaign:begin
                  add(format(CSQLCreateUIndexMask,[_gtn(table)+'_uniqcamp',_gtn(table),'name,begins,ends']));
                end;

   __sccampaign_bindings:
                begin
                  add(format(CSQLCreateUIndexMask,[_gtn(table)+'_uniqcampbind',_gtn(table),'campaign_id,item_type,item_id']));
                end;
   }
      __scaccounting_period:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_aper', _gtn(table), 'name,period_start,period_end,company_id']));
      end;

      __screferencenumbers:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_refnr', _gtn(table), 'client_id,refnumber,status']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_billid', _gtn(table), 'bill_id']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_orderid', _gtn(table), 'order_id']));
      end;
{
   __scprepayment:
                begin
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_clientid',_gtn(table),'client_id,prtype']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_company_id',_gtn(table),'company_id']));
                end;

   __scprepayment_dist_scheme:
               begin
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_itemid_tp',_gtn(table),'item_id,item_type']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_pacc_rec_id',_gtn(table),'prp_acc_rec_id']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_uacc_rec_id',_gtn(table),'usg_acc_rec_id']));
               end;
               }
      __scbills:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_client_id', _gtn(table), 'client_id,status']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_bill_number', _gtn(table), ' bill_number']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_bill_date', _gtn(table), 'bill_date']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_due_date', _gtn(table), 'due_date']));



        add(format(CSQLCreateIndexMask, [_gtn(table) + '_payment_status', _gtn(table), 'payment_status']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_payment_date', _gtn(table), 'payment_date']));

        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_company_id',_gtn(table),'company_id']));
        // 05.12.2009 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_regid', _gtn(table), 'accounting_register_id']));
        // 15.12.2009 ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_wh_id', _gtn(table), 'warehouse_id']));

        // 25.01.2010 ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_cid', _gtn(table), 'credit_bill_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_csumid', _gtn(table), 'summary_id']));

        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_saleperson_id', _gtn(table), 'saleperson_id']));


        // 15.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_curr', _gtn(table), 'currency']));

        // 23.12.2009 Ingmar
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_order_id',_gtn(table),'order_id']));
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_offer_id',_gtn(table),'offer_id']));
      end;

      __scbill_lines:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_bill_id', _gtn(table), 'bill_id,linetype']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_item_id', _gtn(table), 'item_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_vat_id', _gtn(table), 'vat_id']));
        // 22.04.2010 ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_vat_acc_id', _gtn(table), 'vat_account_id']));

      end;

      __scorders:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_uniqord', _gtn(table), 'order_nr,order_date']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_cust_contrid', _gtn(table), 'client_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_warehouseid', _gtn(table), 'warehouse_id']));
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_ordbillid',_gtn(table),'order_gen_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_froffer', _gtn(table), 'offer_id']));
        // 03.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_saleperson_id', _gtn(table), 'saleperson_id']));
        // 05.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_order_ccperson_id', _gtn(table), 'order_ccperson_id']));

        // 15.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_curr', _gtn(table), 'currency']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_temp', _gtn(table), 'template']));

      end;

      __scorder_billing_data:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_order_id', _gtn(table), 'order_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_itemid_tp', _gtn(table), 'item_id,item_type']));
        // add(format(CSQLCreateUIndexMask,[_gtn(table)+'_uniqpmtdata',_gtn(table),'order_id,id']));
      end;



      __scorder_lines:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_order_id', _gtn(table), 'order_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_vat_id', _gtn(table), 'vat_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_vatacc', _gtn(table), 'vat_account_id']));
      end;

      __scpayment:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmtdocnr', _gtn(table), 'document_nr']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmtnrdt', _gtn(table), 'payment_nr,payment_date']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_custid', _gtn(table), 'client_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmtrcv', _gtn(table), 'payment_rcv_name']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmttype', _gtn(table), 'payment_type']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
        // deebet eraldi, kui makstakse ntx mingit riigilõivu or something
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmtacc', _gtn(table), 'c_account_id,d_account_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_accregid', _gtn(table), 'accounting_register_id']));

        // 15.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_curr', _gtn(table), 'currency']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_istemp', _gtn(table), 'template']));
      end;

      __scpayment_data:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmtdat_id', _gtn(table), 'payment_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_itemid_tp', _gtn(table), 'item_id,item_type']));
        // add(format(CSQLCreateUIndexMask,[_gtn(table)+'_uniqpmtdata',_gtn(table),'order_id,id']));
      end;

      __scpayment_files:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmtid', _gtn(table), 'payment_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id_ft', _gtn(table), 'company_id,file_type']));
      end;
{
   __sclate_payments:
               begin
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'source_id',_gtn(table),'source_id,status']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_lpnumber',_gtn(table),'lpnumber']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_company_id',_gtn(table),'company_id']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_clientid',_gtn(table),'client_id']));
               end;
}
      __scincomings:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_clientid', _gtn(table), 'client_id']));
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_id',_gtn(table),'id,status']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_bill_id', _gtn(table), 'bill_id']));    // tasutud arve ID
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_order_id', _gtn(table), 'order_id']));  // tellimuse ID; enamasti siis ettemaks !!!
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_prepayment_id',_gtn(table),'prepayment_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_accmrec_id', _gtn(table), 'accounting_register_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
        // add(format(CSQLCreateIndexMask,[_gtn(table)+'_source',_gtn(table),'source']));
        // 15.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_curr', _gtn(table), 'currency']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_incomings_bank_id', _gtn(table), 'incomings_bank_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_cash_register_id', _gtn(table), 'cash_register_id']));
      end;

      __scincomings_sessions:
      begin
        // 19.06.2010 ingmar
        // add(format(CSQLCreateIndexMask,[_gtn(table)+'_bank_id',_gtn(table),'bank_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_filename', _gtn(table), 'filename']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_created', _gtn(table), 'created']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
      end;

      __scincomings_bank:
      begin
        // add(format(CSQLCreateIndexMask,[_gtn(table)+'_company_id',_gtn(table),'company_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_imp_sess_id', _gtn(table), 'incomings_session_id']));

        // 30.12.2010 Ingmar; varsti meil euro, oh seda õnnetust !
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_client_id', _gtn(table), 'client_id']));

        // 11.06.2010 ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_arc_id', _gtn(table), 'bank_archcode']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_descr', _gtn(table), 'bank_description']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_refnr', _gtn(table), 'payer_refnumber']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_baccount', _gtn(table), 'bank_account']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_baccountibn', _gtn(table), 'bank_account_iban']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmtdate', _gtn(table), 'payment_date']));
        // add(format(CSQLCreateIndexMask,[_gtn(table)+'_acc_id',_gtn(table),'account_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_bacc_id', _gtn(table), 'bank_bk_account_id']));
        // 15.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_curr', _gtn(table), 'currency']));
      end;

      __scwarehouse:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_compwrname', _gtn(table), 'company_id,name']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_compcd', _gtn(table), 'company_id,code']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_caid', _gtn(table), 'charge_account_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_raid', _gtn(table), 'revenue_account_id']));

                  (*
                  add(format(CSQLCreateindexMask,[_gtn(table)+'_county_id',_gtn(table),'county_id']));
                  add(format(CSQLCreateindexMask,[_gtn(table)+'_state_id',_gtn(table),'state_id']));
                  add(format(CSQLCreateindexMask,[_gtn(table)+'_street_id',_gtn(table),'street_id']));
                  *)
      end;


      __scinventory:
      begin

        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_product_id',_gtn(table),'product_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_stt', _gtn(table), 'status']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_warehouse_id', _gtn(table), 'warehouse_id,company_id,article_id']));
        // add(format(CSQLCreateIndexMask,[_gtn(table)+'_art_id',_gtn(table),'article_id']));
      end;

      __scinventory_documents:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_inv_id', _gtn(table), 'inventory_id']));
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_prc_id',_gtn(table),'article_price_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_doc_id', _gtn(table), 'document_id']));
      end;

      __scemail_notifier:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_type_status', _gtn(table), 'type_,status']));
      end;

      __scemail_notifier_sessions:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_notif_email_id', _gtn(table), 'notification_id,email_id']));
      end;
{
kui loogika selge, siis taastame !
   __scassetgroup:
               begin
                  add(format(CSQLCreateUIndexMask,[_gtn(table)+'_namecomp',_gtn(table),'company_id,name']));
               end;

   __scassets: begin
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_asset_group_id',_gtn(table),'asset_group_id']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_sid',_gtn(table),'s_bill_id']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_bid',_gtn(table),'b_bill_id']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_source_document_id',_gtn(table),'source_document_id']));
                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_procurer_id',_gtn(table),'procurer_id']));
               end;
}
{
   __scdocumenttype:
               begin
                  add(format(CSQLCreateUIndexMask,[_gtn(table)+'_name',_gtn(table),'name,classificator_id']));
               end;
}

      __scdocument_tree_nodes:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_parent', _gtn(table), 'parent_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_status', _gtn(table), 'status']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
      end;

      __scdocuments:
      begin
        //add(format(CSQLCreateUIndexMask,[_gtn(table)+'_docnrdtt',_gtn(table),'document_nr,document_date,document_type_id']));
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_docdate',_gtn(table),'document_date']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_docdate', _gtn(table), 'document_date']));
        // 13.03.2010 Ingmar; enam ei ole uniq !
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_docnrdtt', _gtn(table), 'document_nr,document_type_id']));
        //add(format(CSQLCreateUIndexMask,[_gtn(table)+'_docnrdtt',_gtn(table),'document_nr,document_type_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_doccomp', _gtn(table), 'company_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_docdirnod', _gtn(table), 'document_tree_node_id']));
      end;

      __scdocument_files:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_document_id', _gtn(table), 'document_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_type', _gtn(table), 'type_']));
      end;

      // __scdocumentfield_data_labels:;
      __scdocumentfield_values:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_document_iddl', _gtn(table), 'document_id,datalabel_id']));
      end;

      __scclient_documents:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_doccl', _gtn(table), 'document_id,client_id,id']));
      end;

      //   __scaccountgroup:
      //               begin
      //                  add(format(CSQLCreateIndexMask,[_gtn(table)+'_company_id',_gtn(table),'company_id']));
      //               end;

      __scaccounts:
      begin
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_acc_group_id',_gtn(table),'accounts_group_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_parent_id', _gtn(table), 'parent_id']));
        // 05.03.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_accbbank_id', _gtn(table), 'bank_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_dispattr', _gtn(table), 'display_onbill,display_billtypes']));
        // ---
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_compcod', _gtn(table), 'company_id,account_coding']));

      end;

      __scaccounting_register:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_accnr_date', _gtn(table), 'entrynumber,transdate']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_accper', _gtn(table), 'accounting_period_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_accdate', _gtn(table), 'transdate']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
        // 03.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_linkedto_id', _gtn(table), 'linkedto_id']));

      end;

      __scaccounting_register_documents:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_accreg_doc', _gtn(table), 'accounting_register_id,document_id']));
      end;

      __scaccounting_records:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_regid', _gtn(table), 'accounting_register_id']));
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_acc_docid',_gtn(table),'document_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_id_type', _gtn(table), 'account_id,rec_type']));

        // 15.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_curr', _gtn(table), 'currency']));
        // 29.08.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_resref', _gtn(table), 'ref_item_id,ref_item_type']));

        add(format(CSQLCreateIndexMask, [_gtn(table) + '_prpflag', _gtn(table), 'ref_prepayment_flag']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_pmtflag', _gtn(table), 'ref_payment_flag']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_incflag', _gtn(table), 'ref_income_flag']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_dbtflag', _gtn(table), 'ref_debt_flag']));
        // 12.09.2010 Ingmar
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_taxflag', _gtn(table), 'ref_tax_flag']));

        // 02.09.2010 Ingmar
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_prprecid',_gtn(table),'ref_prepayment_accrec_id']));
      end;


      __scaccounting_rec_attrb:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_rec_type_id', _gtn(table), 'accounting_record_id, attrib_type']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_rec_attr_id', _gtn(table), 'attrib_id']));
      end;


      __scaccounting_prepayment_usage:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_src', _gtn(table), 'accounting_src_record_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_dest', _gtn(table), 'accounting_dest_record_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_acc_rf_item', _gtn(table), 'item_type,item_id']));
      end;
   (*
   hetkel ei toeta töölepinguid
   __scemployment_contract:
               begin
               end;
   *)
      __scusers:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_ulname', _gtn(table), 'loginname']));
      end;

      __scuser_permission_descr:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_permdescr', _gtn(table), 'description,valid']));
      end;

      __scuser_permissions:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_usrperm', _gtn(table), 'user_id,permission_descr_id']));
      end;

      __scuser_settings:
      begin
        // 06.02.2012 Ingmar; kuhu ma company_id jätsin :(
        //add(format(CSQLCreateUIndexMask,[_gtn(table)+'_usrid',_gtn(table),'user_id,item_name']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_usrid', _gtn(table), 'user_id,item_name,company_id']));
      end;


      __scrole:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_uniqname', _gtn(table), 'role_name']));
      end;

      __scrole_permissions:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_roleperm', _gtn(table), 'role_id,permission_descr_id']));
      end;

      __scrole_userroles:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_usrrole', _gtn(table), 'role_id,user_id']));
      end;

      __scuser_company_acclist:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_cmpacclist', _gtn(table), 'user_id,company_id']));
      end;

      __scconf:
      begin
        // add(format(CSQLCreateIndexMask,[_gtn(table)+'_varusr',_gtn(table),'user_id,var_name']));
      end;

      //__scbanks:  begin
      //               add(format(CSQLCreateIndexMask,[_gtn(table)+'_unqbcode',_gtn(table),'lcode,swift']));
      //            end;

      __scsystemconf:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_varname', _gtn(table), 'var_name']));
      end;

      __scobjects:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_clf_id', _gtn(table), 'classificator_id']));
        // 28.09.2009 ingmar; nime järgi otsing;
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_descr', _gtn(table), 'descr']));
      end;

      __scnumerators:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_uniqnr_idx', _gtn(table), 'cr_num_type,cr_valid,accounting_period_id,company_id']));
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_comp_id',_gtn(table),'company_id']));
      end;

      __sccurrency_exc:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_uniq_curr_idx', _gtn(table), 'curr_name,curr_date,valid']));
      end;

      // 24.10.2009  ingmar
      __scaccounts_reqobjects:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_uniq_acc_idx', _gtn(table), 'account_id,status']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_uniq_itemid_id', _gtn(table), 'item_id,type_']));
      end;

      __scinternal_systemtypes:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_uniqfakedual', _gtn(table), 'bbool,int4,bint']));
      end;


      __scdefault_sysaccounts:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_uniq', _gtn(table), 'ordinal_nr,account_id,company_id']));
      end;

      __scstatus_report:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_cd', _gtn(table), 'code,classificator_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_dt', _gtn(table), 'op_starts,op_ends']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
      end;

      __scstatus_report_lines:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_stat_rep_id', _gtn(table), 'status_report_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_code', _gtn(table), 'code']));
      end;

      __scformd:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_taxrdate', _gtn(table), 'valid_from,valid_until']));
      end;

      __scformd_lines:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_formd_id', _gtn(table), 'formd_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_parent_id', _gtn(table), 'parent_id']));
      end;

      __sctaxd_history:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_taxdhidx', _gtn(table), 'company_id,taxyear,taxmonth']));
      end;

      __sctaxd_history_lines:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_taxdline_id', _gtn(table), 'taxd_history_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_taxdformline_id', _gtn(table), 'taxd_form_line_id']));
      end;
      __sctaxes:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_taxnprc', _gtn(table), 'taxname,perc']));
      end;

      __scwebusers:
      begin
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_webcmp', _gtn(table), 'username,company_id']));
      end;

      __scsentemails:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_email_id', _gtn(table), 'email_id']));
        add(format(CSQLCreateUIndexMask, [_gtn(table) + '_uniq_emailitem_id', _gtn(table), 'item_id,item_type']));
      end;

      __scsepafile:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_sepa_bank', _gtn(table), 'company_id,bankcode']));
      end;

      __scsepafileentry:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_sepa_file_id', _gtn(table), 'sepa_file_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + 'payment_id', _gtn(table), 'payment_id']));
      end;


  {$ifdef wagemodule_enabled}
      // 12.01.2012 Ingmar
      __scemployee:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_lastname', _gtn(table), 'lastname']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_idnr', _gtn(table), 'personal_idnr']));
      end;

      __scemployee_id_document:
      begin
        //add(format(CSQLCreateIndexMask,[_gtn(table)+'_id_document_id',_gtn(table),'id_document_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_id_employee_id', _gtn(table), 'employee_id']));
      end;

      __scemployment_contract:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_employee_id', _gtn(table), 'employee_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_cr_date', _gtn(table), 'start_date,end_date']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_company_id', _gtn(table), 'company_id']));
      end;
{
  __sc_id_document:
                begin
                 add(format(CSQLCreateIndexMask,[_gtn(table)+'_doc_nr',_gtn(table),'doc_nr']));
                end;
}
      __scwage_types:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_account_id', _gtn(table), 'account_id']));
      end;

      __scemployee_wage:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_employee_id', _gtn(table), 'employee_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_employment_contract_id', _gtn(table), 'employment_contract_id']));
      end;

      __scemployee_wage_lines:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_ewage_id', _gtn(table), 'employee_wage_id']));
      end;
      __scpayroll:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_ewage_id', _gtn(table), 'employee_wage_id']));
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_wte_id', _gtn(table), 'employee_wtimetable_id']));
      end;

      __scemployee_wtimetable:
      begin
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_employee_id', _gtn(table), 'employee_id']));
      end;

      __scpayroll_entry:
      begin
        ;
        add(format(CSQLCreateIndexMask, [_gtn(table) + '_payroll_id', _gtn(table), 'payroll_id']));
      end;
   {$endif}
    end;
end;

function Testbk_databaseschema.__GenerateAutonumber(const table: TCTablenames; const fieldName: AStr = 'id'): AStr;
begin
  case self.FBackEndType of
    __postGre: Result := ' DEFAULT nextval(''' + CTable_names[table] + '_' + fieldName + '_seq'') ';
  end;
end;

procedure Testbk_databaseschema.__addModFooter(const table: TCTablenames; const tableDef: TAStrlist; const addDelTrackerField: boolean = True);
begin
  with tableDef do
  begin

    add(' ,rec_changed ' + __MapModDateTime() + '  NOT NULL,');
    add('  rec_changedby  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
    add('  rec_addedby    ' + __MapIntType() + ' NOT NULL DEFAULT 0');

    if addDelTrackerField then
    begin
      add('  ,rec_deletedby  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('   rec_deleted ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f''');
    end;
    // -----
  end;
end;

// ka seosed, sisuliselt foreign key ka omamoodi constraint ! Ärme Cascade delete propageeri !
procedure Testbk_databaseschema.__addConstraint(const table: TCTablenames; const tableDef: TAStrlist);
const
  // --------
  SPrimaryKeyIdField = 'id';
  SCompanyIdField = 'company_id';
  // SProductGrpIdField  = 'productgroup_id';
  // SProductIdField     = 'product_id';

  SArticleIdField = 'article_id';
  //SServiceIdField     = 'service_id';
  SclientIdField = 'client_id';
  SCBillIdField = 'bill_id';
  SCBillIdField2 = 'source_id';
  SCaccounting_period_id = 'accounting_period_id';
  SCVAT_id = 'vat_id';
  SCIImportSession_id = 'incomings_session_id';
  SWarehouseIdField = 'warehouse_id';
  SInventoryIdField = 'inventory_id';
  SEmailNotIdField = 'notification_id';
  SCAssetGrpIdField = 'asset_group_id';
  SDocumentTypeIdField = 'document_type_id';
  SDocumentIdField = 'document_id';
  SDocDataLabelId = 'datalabel_id';
  SAccRegIdField = 'accounting_register_id';
  //SAccDebIdField         = 'd_account_id';
  //SAccCreIdField         = 'c_account_id';
  SItemAccIdField = 'item_account_id';
  SAccIdField = 'account_id';
  SAccBankAccIdField = 'bk_account_id';
  SCaccounting_rec_id = 'accounting_record_id';
  SCaccount_reg_id = 'accounting_register_id';

  SUserIdField = 'user_id';
  SCRoleIdField = 'role_id';
  SCPermissionIdField = 'permission_descr_id';
  SCampaignIdField = 'campaign_id';
  SEmailIdField = 'email_id';
  SClassificatorIdField = 'classificator_id';

  //SInventoryIdField      = 'inventory_id';
  //SArticlePrTableIdField = 'article_price_id';
  // 07.02.2010 Ingmar
  SAccountTypeId = 'type_id';
  SOrderId = 'order_id';

  // maksekorraldus
  SItemAccDebIdField = 'd_account_id';
  SItemAccCredIdField = 'c_account_id';

  SPaymentIdField = 'payment_id';

  // ---
  STaxFormIdField = 'formd_id';    // __sctaxdform_lines
  STaxFormLineIdField = 'taxd_form_line_id'; // __sctaxd_history_lines
  STaxHistoryId = 'taxd_history_id';   // __sctaxd_history_lines

  SSEPAFileIdField = 'sepa_file_id';

  // ---
  SID_document_IdField = 'id_document_id';
  SID_employee_IdField = 'employee_id';
  SID_payroll_IdField = 'payroll_id';
  STaxIdField = 'tax_id';
  SEmployeewageId = 'employee_wage_id';
  SEMailID = 'email_id';
begin
  // CHECK käsk ikka  suht ühilduv erinevate andmebaaside vahel; isnull ei tohi kasutada vaid coalesce jne jne
  // ---
  with tableDef do
    case table of
      __sccompany:
      begin
      end;

      __scclient:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField)); // Firma peab eksisteerima !
        // add(', CHECK (ctype=''P'' OR ctype=''L'')');
        add(', CHECK (ctype in (''P'',''L''))');
      end;

      __scclientcontactpersons:
      begin
        add(',' + sqlp._generateForeignKeySQL(SClientIdField, _gtn(__scclient), SPrimaryKeyIdField)); // Firma peab eksisteerima !
      end;


      // 28.12.2010
  {
   __sccampaign_bindings:
                  begin
                    add(','+SqlCompatibility._generateForeignKeySQL(SCampaignIdField,_gtn(__sccampaign),SPrimaryKeyIdField)); // Firma peab eksisteerima !
                    add(', CHECK (coalesce(item_id,0)>0 AND coalesce(item_type,'''')<>'''')');
                  end;
  }
      __scbanks:
      begin
        //add(','+SqlCompatibility._generateForeignKeySQL(SAccBankAccIdField,_gtn(__scaccounts),SPrimaryKeyIdField));
        //add(','+SqlCompatibility._generateForeignKeySQL(SCompanyIdField,_gtn(__sccompany),SPrimaryKeyIdField));
        add(', CHECK (coalesce(name,'''')<>'''')');
      end;

      __scaccounting_period,
      //__sccampaign,
      //__scproduct_groups,
      __scarticles_groups,
      __scwarehouse,
      __scarticles:
        //__scservices:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(', CHECK (coalesce(name,'''')<>'''')');
      end;

      __scsepafile:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
      end;

      __scsepafileentry:
      begin
        add(',' + sqlp._generateForeignKeySQL(SSEPAFileIdField, _gtn(__scsepafile), SPrimaryKeyIdField));
        // kas peaks ka maksetele viite tegema ?
      end;

      __scarticles_attrb:
      begin
        add(',' + sqlp._generateForeignKeySQL(SArticleIdField, _gtn(__scarticles), SPrimaryKeyIdField));
      end;

      __scarticles_price_table:
      begin
        add(',' + sqlp._generateForeignKeySQL(SArticleIdField, _gtn(__scarticles), SPrimaryKeyIdField));
      end;

      // 21.10.2009 ingmar
   {
   __scarticles_accounts:
                 begin
                    add(','+SqlCompatibility._generateForeignKeySQL(SArticleIdField,_gtn(__scarticles),SPrimaryKeyIdField));
                    add(','+SqlCompatibility._generateForeignKeySQL(SAccIdField,_gtn(__scaccounts),SPrimaryKeyIdField));
                 end;
                 }

  {
   __scservice_price_table:
                  begin
                    add(','+SqlCompatibility._generateForeignKeySQL(SServiceIdField,_gtn(__scservices),SPrimaryKeyIdField));
                  end;
  }

      __scclient_discount:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SclientIdField, _gtn(__scclient), SPrimaryKeyIdField));
        //add(', CHECK (coalesce(productgroup_id,0)>0 OR coalesce(product_id,0)>0 OR coalesce(service_id,0)>0)');
      end;

      // __scaccountgroup, hetkel lubame ka firmat mitte valida
      //__scemployment_contract,
      __screferencenumbers:
      begin
        add(',' + sqlp._generateForeignKeySQL(SclientIdField, _gtn(__scclient), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(', CHECK (coalesce(refnumber,'''')<>'''')');
      end;

      __scaccounting_register:
        //__scusers: hetkel me ei seo töötajat konkreetse firmaga, ntx tuleb raamatupidaja, kes ei töötagi selle firma all !
        //__scassetgroup:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
      end;

{
   __scprepayment:begin
                    add(','+SqlCompatibility._generateForeignKeySQL(SCompanyIdField,_gtn(__sccompany),SPrimaryKeyIdField));
                    add(','+SqlCompatibility._generateForeignKeySQL(SclientIdField,_gtn(__scclient),SPrimaryKeyIdField));
                    // 19.08.2010 Ingmar
                    // add(','+SqlCompatibility._generateForeignKeySQL(SCaccounting_period_id,_gtn(__scaccounting_period),SPrimaryKeyIdField));
                  end;
}
      //     D - K = ettemaksu saldo
{
 __scprepayment_dist_scheme:
                  begin
                     add(','+SqlCompatibility._generateForeignKeySQL('prp_acc_rec_id',_gtn(__scaccounting_records),SPrimaryKeyIdField));
                     add(','+SqlCompatibility._generateForeignKeySQL('usg_acc_rec_id',_gtn(__scaccounting_records),SPrimaryKeyIdField));
                  end;
}
      __scbills:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SclientIdField, _gtn(__scclient), SPrimaryKeyIdField));
        //add(','+SqlCompatibility._generateForeignKeySQL(SCVAT_id,_gtn(__scVAT),SPrimaryKeyIdField));
        // 06.01.2010 Ingmar seoses avatud arvetega mis kandeid ei loo, ei ole mõtet sellist piirangut kasutada ! ja NULL ei taha ma kasutusele võtta !
        // add(','+SqlCompatibility._generateForeignKeySQL(SCaccount_reg_id,_gtn(__saccounting_register),SPrimaryKeyIdField));
      end;

      __scbill_lines:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SCBillIdField, _gtn(__scbills), SPrimaryKeyIdField));
        //add(','+SqlCompatibility._generateForeignKeySQL(SItemAccIdField,_gtn(__scaccounts),SPrimaryKeyIdField));
        //add(','+SqlCompatibility._generateForeignKeySQL(SItemVatAccIdField,_gtn(__scaccounts),SPrimaryKeyIdField));
        // 06.01.2010 Ingmar seoses avatud arvetega mis kandeid ei loo, ei ole mõtet sellist piirangut kasutada ! ja NULL ei taha ma kasutusele võtta !
        // add(','+SqlCompatibility._generateForeignKeySQL(SCaccounting_rec_id,_gtn(__scaccounting_records),SPrimaryKeyIdField));
        add(', CHECK (coalesce(linetype,'''')<>'''')');
      end;

      __scorders:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(', CHECK ((coalesce(order_nr,'''')<>'''') AND (coalesce(order_type,'''')<>''''))');
      end;

      __scorder_billing_data:
      begin
        add(',' + sqlp._generateForeignKeySQL(SOrderId, _gtn(__scorders), SPrimaryKeyIdField));
        add(', CHECK (coalesce(item_id,0)>0 AND coalesce(item_type,'''')<>'''')');
        //add(','+SqlCompatibility._generateForeignKeySQL( SCBillIdField,_gtn(__scbills),SPrimaryKeyIdField));
      end;

      __scorder_lines:
      begin
        add(',' + sqlp._generateForeignKeySQL(SOrderId, _gtn(__scorders), SPrimaryKeyIdField));
      end;

      __scpayment:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        // 06.04.2010 Ingmar; nüüd hoitakse valitud arvete puhul, konto infot payment_order_data juures !!!
        // add(','+SqlCompatibility._generateForeignKeySQL(SItemAccDebIdField,_gtn(__scaccounts),SPrimaryKeyIdField));
        // add(','+sqlp._generateForeignKeySQL(SItemAccCredIdField,_gtn(__scaccounts),SPrimaryKeyIdField));

        //add(','+SqlCompatibility._generateForeignKeySQL(SCaccount_reg_id,_gtn(__saccounting_register),SPrimaryKeyIdField));
      end;

      __scpayment_data:
      begin
        add(',' + sqlp._generateForeignKeySQL(SPaymentIdField, _gtn(__scpayment), SPrimaryKeyIdField));
        //add(','+SqlCompatibility._generateForeignKeySQL(SAccIdField,_gtn(__scaccounts),SPrimaryKeyIdField));
        add(', CHECK (coalesce(item_id,0)>0 AND coalesce(item_type,'''')<>'''')');
      end;

      __scpayment_files:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SPaymentIdField, _gtn(__scpayment), SPrimaryKeyIdField));
      end;


{   __sclate_payments:
                  begin
                    add(','+SqlCompatibility._generateForeignKeySQL(SCompanyIdField,_gtn(__sccompany),SPrimaryKeyIdField));
                    add(','+SqlCompatibility._generateForeignKeySQL(SCBillIdField2,_gtn(__scbills),SPrimaryKeyIdField));
                    add(','+SqlCompatibility._generateForeignKeySQL(SclientIdField,_gtn(__scclient),SPrimaryKeyIdField));
                  end;
}
      __scincomings:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        // 28.02.2010 Ingmar; enam pole ainult arved vaid laekumine saab ka tellimusele tulla !!!!!!!!!!!!!!!!!!!!!!!
        //add(','+SqlCompatibility._generateForeignKeySQL(SCBillIdField,_gtn(__scbills),SPrimaryKeyIdField));
        // ei saa nõuda, kui meie makse teeme !
        //add(','+SqlCompatibility._generateForeignKeySQL(SclientIdField,_gtn(__scclient),SPrimaryKeyIdField));
        //add(','+SqlCompatibility._generateForeignKeySQL(SCaccounting_period_id,_gtn(__scaccounting_period),SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SCaccount_reg_id, _gtn(__scaccounting_register), SPrimaryKeyIdField));
      end;

      __scVAT: ;
      __scincomings_sessions: ;
      __scincomings_bank:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCIImportSession_id, _gtn(__scincomings_sessions), SPrimaryKeyIdField));
      end;

      __scinventory:
      begin
        // 04.01.2010 Ingmar; lubasin ka 0 ladu !!
        //add(','+SqlCompatibility._generateForeignKeySQL(SWarehouseIdField,_gtn(__scwarehouse),SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SArticleIdField, _gtn(__scarticles), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
      end;


      __scinventory_documents:
      begin
        add(',' + sqlp._generateForeignKeySQL(SInventoryIdField, _gtn(__scinventory), SPrimaryKeyIdField));
        // 15.01.2010 Ingmar; lubame ka 0; tavaliste müügiarvete puhul !
        //add(','+SqlCompatibility._generateForeignKeySQL(SArticlePrTableIdField,_gtn(__scarticles_price_table),SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SDocumentIdField, _gtn(__scdocuments), SPrimaryKeyIdField));
      end;


      //   __scorder:    begin
      //                  end;

      // __scemail_notifier:;
      __scemail_notifier_sessions:
      begin
        add(',' + sqlp._generateForeignKeySQL(SEmailNotIdField, _gtn(__scemail_notifier), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SEmailIdField, _gtn(__scemail), SPrimaryKeyIdField));
      end;
{
   __scassets:    begin
                    add(','+SqlCompatibility._generateForeignKeySQL(SCompanyIdField,_gtn(__sccompany),SPrimaryKeyIdField));
                    add(','+SqlCompatibility._generateForeignKeySQL(SCAssetGrpIdField,_gtn(__scassetgroup),SPrimaryKeyIdField));
                    // ülejäänud väljad suht valikulised !!!!
                  end;
}
      //__scdocumenttype:;
      __scdocuments:
      begin
        add(',' + sqlp._generateForeignKeySQL(SDocumentTypeIdField, _gtn(__scclassificators), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
      end;

      __scdocument_files:
      begin
        add(',' + sqlp._generateForeignKeySQL(SDocumentIdField, _gtn(__scdocuments), SPrimaryKeyIdField));
      end;

      //__scdocumentfield_data_labels:;

      __scdocumentfield_values:
      begin
        add(',' + sqlp._generateForeignKeySQL(SDocumentIdField, _gtn(__scdocuments), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SDocDataLabelId, _gtn(__scdocumentfield_data_labels), SPrimaryKeyIdField));
      end;

      __scclient_documents:
      begin
        add(',' + sqlp._generateForeignKeySQL(SDocumentIdField, _gtn(__scdocuments), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SclientIdField, _gtn(__scclient), SPrimaryKeyIdField));
      end;

      __scaccounts:
      begin
        add(',' + sqlp._generateForeignKeySQL(SAccountTypeId, _gtn(__scclassificators), SPrimaryKeyIdField));
      end;
      // __saccounting_register:;

      __scaccounting_register_documents:
      begin
        add(',' + sqlp._generateForeignKeySQL(SAccRegIdField, _gtn(__scaccounting_register), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SDocumentIdField, _gtn(__scdocuments), SPrimaryKeyIdField));
      end;

      __scaccounting_records:
      begin

        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SAccIdField, _gtn(__scaccounts), SPrimaryKeyIdField));
        //add(','+SqlCompatibility._generateForeignKeySQL(SAccCreIdField,_gtn(__scaccounts),SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SAccRegIdField, _gtn(__scaccounting_register), SPrimaryKeyIdField));
        add(', CHECK (coalesce(rec_type  ,'''') in (''D'',''C'',''F''))');

      end;

      __scaccounting_rec_attrb:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCaccounting_rec_id, _gtn(__scaccounting_records), SPrimaryKeyIdField));
      end;
      // __scemployment_contract:;
      // __scusers:; ma ei saa töölepingut kohustuslikuks teha
      // __scuser_permission_descr:;
      // __scrole:;  hetkel ei seo veel firmaga !!!!

      __scrole_permissions:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCRoleidField, _gtn(__scrole), SPrimaryKeyIdField));  // ok
        add(',' + sqlp._generateForeignKeySQL(SCPermissionidField, _gtn(__scuser_permission_descr), SPrimaryKeyIdField));
      end;

      __scrole_userroles:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCRoleidField, _gtn(__scrole), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SUserIdfield, _gtn(__scusers), SPrimaryKeyIdField));
        // add(','+SqlCompatibility._generateForeignKeySQL(SCompanyIdField,_gtn(__sccompany),SPrimaryKeyIdField)); hetkel ei seo õigusi firmaga
      end;

      __scuser_permissions:
      begin
        add(',' + sqlp._generateForeignKeySQL(SUserIdField, _gtn(__scusers), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SCPermissionIdField, _gtn(__scuser_permission_descr), SPrimaryKeyIdField));
        // add(','+SqlCompatibility._generateForeignKeySQL(SCompanyIdField,_gtn(__sccompany),SPrimaryKeyIdField)); sama siin
      end;

      __scuser_company_acclist:
      begin
        add(',' + sqlp._generateForeignKeySQL(SUserIdField, _gtn(__scusers), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
      end;

      __scobjects:
      begin
        // ärme hetkel tee kohustuslikuks
        // add(','+SqlCompatibility._generateForeignKeySQL(SCompanyIdField,_gtn(__sccompany),SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SClassificatorIdField, _gtn(__scclassificators), SPrimaryKeyIdField));
      end;

      __scaccounts_reqobjects:
      begin
        add(',' + sqlp._generateForeignKeySQL(SAccIdField, _gtn(__scaccounts), SPrimaryKeyIdField));
      end;

      __scdefault_sysaccounts:
      begin
        add(',' + sqlp._generateForeignKeySQL(SAccIdField, _gtn(__scaccounts), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
      end;

      __scformd_lines:
      begin
        add(',' + sqlp._generateForeignKeySQL(STaxFormIdField, _gtn(__scformd), SPrimaryKeyIdField));
      end;

      __sctaxd_history:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
      end;

      __sctaxd_history_lines:
      begin
        add(',' + sqlp._generateForeignKeySQL(STaxFormLineIdField, _gtn(__scformd_lines), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(STaxHistoryId, _gtn(__sctaxd_history), SPrimaryKeyIdField));
      end;

      // 22.01.2012 Ingmar
      __sctaxes:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(', CHECK (coalesce(taxname,'''')<>'''')');
      end;

      // 02.03.2013 Ingmar
      __scsentemails:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SEMailID, _gtn(__scemail), SPrimaryKeyIdField));
      end;

      __scwebusers:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SClientIdField, _gtn(__scclient), SPrimaryKeyIdField));
      end;



    {$ifdef wagemodule_enabled}
      // 12.01.2012 Ingmar
      //    __sc_id_document,
      __scemployee,
      __scwage_types:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
      end;
{
    __scwage_type_taxes:
                  begin
                    add(','+sqlp._generateForeignKeySQL(STaxIdField,_gtn(__sctaxes),SPrimaryKeyIdField));
                 end;
}
      __scemployee_id_document:
      begin
        //add(','+sqlp._generateForeignKeySQL(SID_document_idField,_gtn(__sc_id_document),SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SID_employee_idField, _gtn(__scemployee), SPrimaryKeyIdField));
      end;

      __scemployment_contract:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SID_employee_idField, _gtn(__scemployee), SPrimaryKeyIdField));
      end;

      __scemployee_wage:
      begin
        add(',' + sqlp._generateForeignKeySQL(SCompanyIdField, _gtn(__sccompany), SPrimaryKeyIdField));
        add(',' + sqlp._generateForeignKeySQL(SID_employee_idField, _gtn(__scemployee), SPrimaryKeyIdField));
      end;

      __scemployee_wage_lines:
      begin
        add(',' + sqlp._generateForeignKeySQL(SEmployeewageId, _gtn(__scemployee_wage), SPrimaryKeyIdField));
      end;

      __scemployee_wtimetable:
      begin
        add(',' + sqlp._generateForeignKeySQL(SID_employee_idField, _gtn(__scemployee), SPrimaryKeyIdField));
      end;

      __scpayroll_entry:
      begin
        add(',' + sqlp._generateForeignKeySQL(SID_payroll_idField, _gtn(__scpayroll), SPrimaryKeyIdField));
      end;
    {$endif}
      //__scconf:;
      // -------
    end;
end;

constructor Testbk_databaseschema.Create(const cDbBackend: TCurrentDatabaseBackEnd);
var
  tmpBfr: TAStrList;

begin
  inherited Create;
  try
    // ---
    tmpBfr := TAStrList.Create;
    self.FBackEndType := cDbBackend;


    with tmpBfr do
    begin
      // --------------------------------------------------------------------
      // @@1: COMMENT:
      Clear; // ntx erinevad tüübid, dokumendid tüübid; objekti tüübid, kliendi tüübid
      add('create table ' + CTable_names[__scclassificators]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scclassificators) + ',');
      add('  parent ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  name ' + __MapVarcharType(255) + ' NOT NULL,');
      add('  shortidef ' + __MapCharType(3) + ' NOT NULL DEFAULT '''',');
      add('  type_ ' + __MapVarcharType(25) + ' NOT NULL,');
      add('  weight ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  value ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      // 12.12.2010 Ingmar; keel ! EE/ES jne
      add('  lang ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // 0 st default mask !
      add('  user_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // kasutaja spetsiifilised seaded !
      add('  rec_deleted ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f''');
      add(')');
      FTableDefs[__scclassificators] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // http://www.postgresql.org/docs/8.2/static/functions-datetime.html
      // http://www.postgresql.org/docs/7.1/static/functions-AStr.html
      // @@2:
      Clear;
      add('create table ' + Ctable_names[__sccounty]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__sccounty) + ',');
      add('  name ' + __MapVarcharType(255) + ' NOT NULL,');
      // 15.11.2009 Ingmar; erinevate riikide aadressite toetus !
      add('  countrycode ' + __MapCharType(3) + ' NOT NULL DEFAULT ' + QuotedStr(Cglob_DefaultCountryCodeISO3166_1) + ',');
      add('  valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'''); // COMMENT: kui false ei tohi seda enam valikutes lubada kasutada
      self.__addModFooter(__sccounty, tmpBfr);
      self.__addConstraint(__sccounty, tmpBfr);
      add(')');
      FTableDefs[__sccounty] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@3:
      Clear;
      add('create table ' + Ctable_names[__sccity]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__sccity) + ',');
      add('  name ' + __MapVarcharType(255) + ' NOT NULL,');
      add('  county_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  countrycode ' + __MapCharType(3) + ' NOT NULL DEFAULT ' + QuotedStr(Cglob_DefaultCountryCodeISO3166_1) + ',');
      add('  valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'''); // COMMENT: kui false ei tohi seda enam valikutes lubada kasutada
      self.__addModFooter(__sccity, tmpBfr);
      self.__addConstraint(__sccity, tmpBfr);
      add(')');
      FTableDefs[__sccity] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@4:
      Clear;
      add('create table ' + Ctable_names[__scstreet]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scstreet) + ',');
      add('  name ' + __MapVarcharType(255) + ' NOT NULL,');
      add('  countrycode ' + __MapCharType(3) + ' NOT NULL DEFAULT ' + QuotedStr(Cglob_DefaultCountryCodeISO3166_1) + ',');
      add('  valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'''); // COMMENT: kui false ei tohi seda enam valikutes lubada kasutada
      self.__addModFooter(__scstreet, tmpBfr);
      self.__addConstraint(__scstreet, tmpBfr);
      add(')');
      FTableDefs[__scstreet] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@5:
      // hetkel me ei kasuta seda
      // 19.08.2009 Ingmar
      // tänavate asukohtade tabeli seosed ka panna ?!? siis oleks mingit regio andmebaasi vaja...
      Clear;
      add('create table ' + Ctable_names[__sccity_street_rel]);
      add('(');
      add('  city_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  street_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'''); // COMMENT: kui false ei tohi seda enam valikutes lubada kasutada
      self.__addModFooter(__sccity_street_rel, tmpBfr);
      self.__addConstraint(__sccity_street_rel, tmpBfr);
      add(')');
      FTableDefs[__sccity_street_rel] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@6:
      // COMMENT: 08.07.2009 Ingmar - mis firma all hetkel tööd tehakse !
      Clear;
      add('create table ' + Ctable_names[__sccompany]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__sccompany) + ',');
      add('  name    ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  regnr   ' + __MapVarcharType(50) + ' NOT NULL DEFAULT '''',');
      add('  vatnumber ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  countrycode ' + __MapCharType(3) + ' NOT NULL DEFAULT ' + QuotedStr(Cglob_DefaultCountryCodeISO3166_1) + ',');
      add('  county_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // COMMENT: maakond üldiselt on seotud linnaga;
      add('  city_id ' + __MapIntType() + ' NOT NULL  DEFAULT 0,');
      add('  street_id ' + __MapIntType() + '  NOT NULL  DEFAULT 0,');
      add('  house_nr ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''','); // COMMENT: võib olla pikk talunimi !!!
      add('  apartment_nr ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  zipcode ' + __MapVarcharType(15) + ' NOT NULL DEFAULT '''',');
      add('  phone   ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  mobilephone ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  fax ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  email ' + __MapVarcharType(300) + ' NOT NULL DEFAULT '''',');
      add('  contactperson ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  contactperson_phone ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  contactperson_email ' + __MapVarcharType(300) + ' NOT NULL DEFAULT '''',');
      // 04.01.2010 ingmar
      add('  logo ' + __MapBlobField() + ' NULL,');
      // COMMENT: 17.08.2009 peale pikka mõtlemist; ostustasin teha osakonnad parent and child relation tüüpi
      // kui tegemist osakonnaga, siis  parentCompanyId<>0
      add('  parent_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  descr ' + __MapLongText + '  NOT NULL DEFAULT '''',');
      // COMMENT: 17.08.2009 üldiselt põhitegevusalade kirjeldus ntx jne jne aga see pole üldse kohustuslik; hetkel reserveeritud !
      // 07.02.2010 Ingmar; osakonna objektile viide !
      add('  department_object_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // seostub tabeliga objects
      add('  department_short_idf  ' + __MapVarcharType(25) + ' NOT NULL DEFAULT ''''');
      // mod stat
      self.__addModFooter(__sccompany, tmpBfr);
      self.__addConstraint(__sccompany, tmpBfr);
      add(')');
      FTableDefs[__sccompany] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // @@7: osakond paika, lihtsustab konteerimist jne
      // 27.09.2009 ingmar; lihtsustame, teeme läbi tabeli firmad
{
        clear;
        add('create table '+Ctable_names[__scdepartment]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scdepartment)+',');
        add('  code '+__MapCharType(3)+' NOT NULL DEFAULT ''000'',');
        add('  name '+__MapVarcharType(300)+' NOT NULL DEFAULT '''',');
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0');
        // mod stat
        self.__addModFooter(__scdepartment,tmpBfr);
        self.__addConstraint(__scdepartment,tmpBfr);
        add(')');
        FTableDefs[__scdepartment]:=tmpBfr.Text;
}
      // --------------------------------------------------------------------
      // @@8:
      Clear;
      add('create table ' + Ctable_names[__scclient]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scclient) + ',');
      // COMMENT: 08.07.2009 Ingmar -  P - füüsiline isik / eraisik; L - legal person; juriidiline isik
      add('  ctype ' + __MapCharType(1) + ' NOT NULL DEFAULT ''P'',');
      add('  name  ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''',');
      add('  middlename ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''',');
      add('  lastname ' + __MapVarcharType(75) + ' NOT NULL DEFAULT '''',');
      add('  regnr   ' + __MapVarcharType(50) + ' NOT NULL DEFAULT '''',');
      add('  countrycode ' + __MapCharType(3) + ' NOT NULL DEFAULT ' + QuotedStr(Cglob_DefaultCountryCodeISO3166_1) + ',');
      add('  county_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  city_id ' + __MapIntType() + ' NOT NULL  DEFAULT 0,');
      add('  street_id ' + __MapIntType() + '  NOT NULL  DEFAULT 0,');
      add('  house_nr ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''','); // COMMENT: võib olla pikk talunimi !!!
      add('  apartment_nr ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  zipcode ' + __MapVarcharType(15) + ' NOT NULL DEFAULT '''',');
      add('  phone   ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  mobilephone ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  fax ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  email ' + __MapVarcharType(300) + ' NOT NULL DEFAULT '''',');
      add('  webpage ' + __MapVarcharType(512) + ' NOT NULL DEFAULT '''',');
      // arved tavaliselt saata sellele aadressile
      add('  postal_addr ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      // add('  notes '+__MapVarcharType(300)+' NOT NULL DEFAULT '''',');
      // 16.11.2009 Ingmar
      add('  notes ' + __MapLongText() + ' NOT NULL DEFAULT '''',');
      add('  type_ ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // reserveeritud !

      // ---
      add('  vatnumber ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  prefnumber ' + __MapVarCharType(30) + ' NOT NULL DEFAULT '''','); // ! hankija poolt antud viitenumber
      add('  payment_duetime ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // võimaldab mõnele kliendile anda pikemat makseaega
      add('  credit_limit ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');


      // vajalikud kontod, millest ma hetkel midagi ei tea !
      add('  prepayment_account_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // # ettemaksukonto
      add('  debt_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');        // # võlakonto
      add('  charge_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');      // # kulukonto

      // ----
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // hetkel pole eraldi tabelit; vaid kodeering: ntx 401:332413123123123;
      // 05.03.2010 Ingmar
      add('  bank_account1 ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  bank_id1 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // ---
      add('  bank_account2 ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  bank_id2 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // 17.06.2010 ingmar; CRC32, et suudaksime teha väga kiiret täisnime järgi päringut;
      // md5 oleks andmebaasiruumi raiskamine
      add('  srcval  ' + __MapBigIntType() + ' NOT NULL DEFAULT 0,');
      // teistes rp. tarkvarades kutsutakse seda kui kliendi koodiks
      add('  client_code ' + __MapVarcharType(10) + ' NOT NULL DEFAULT '''',');

      add('  iban' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  swift ' + __MapVarcharType(11) + ' NOT NULL  DEFAULT '''',');
      // 02.03.2013 Ingmar; et saaks määrata spetsiifilise arve malli
      add('  billtemplate_path ' + __MapVarcharType(255) + ' NOT NULL  DEFAULT '''',');
      add('  reserved2 ' + __MapVarcharType(255) + ' NOT NULL  DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scclient, tmpBfr);
      self.__addConstraint(__scclient, tmpBfr);
      add(')');
      FTableDefs[__scclient] := tmpBfr.Text;


      // client_accounts
      // võlakonto
      // ettemaksukonto
      // 05.08.2010 Ingmar;
      Clear;
      add('create table ' + Ctable_names[__scclientcontactpersons]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scclientcontactpersons) + ',');
      add('  client_id ' + __MapIntType() + ' NOT NULL,');
      add('  cname ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  caddr ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  cphone ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  cemail ' + __MapVarcharType(300) + ' NOT NULL DEFAULT '''',');
      add('  type_ ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // reserveeritud
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT ''''');
      self.__addModFooter(__scclientcontactpersons, tmpBfr);
      self.__addConstraint(__scclientcontactpersons, tmpBfr);
      add(')');
      FTableDefs[__scclientcontactpersons] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@9:
      Clear;
      add('create table ' + Ctable_names[__scemail]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scemail) + ',');
      add('  email ' + __MapVarcharType(255) + ' NOT NULL,');
      add('  subject ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  body ' + __MapLongText() + ' NOT NULL DEFAULT '''',');
      add('  request_date  ' + __MapdateTimeVariable() + ' NOT NULL DEFAULT ' + __DefaultDate() + ','); // COMMENT: millal tellimus tuli
      add('  letter_send_date  ' + __MapdateTimeVariable() + '  NULL ,'); // COMMENT: millal lõpuks reaalselt kiri ära saadeti
      add('  when_to_send  ' + __MapdateTimeVariable() + '  NULL ,'); // COMMENT: saab määrata, mis kuupäevast saata; võib puududa
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // COMMENT: S (sent) - saadetud;
      // D - (deleted), sisuliselt tellimus annuleeritud
      // F - (failure), midagi läks väga untsu
      add('  emsg ' + __MapVarcharType(512) + ' NOT NULL DEFAULT '''',');
      add('  reserved1  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // COMMENT: tulevikus; client_id; user_id; töötaja kliendi põhised kirjad ja nende monitoorimine
      add('  reserved2  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      add(')');
      FTableDefs[__scemail] := tmpBfr.Text;
      //add('  sentdate '+__MapdateTimeVariable()+' NOT NULL DEFAULT '+__DefaultDate()+',');


      // --------------------------------------------------------------------
      // @@10:
      // 28.12.2010 Ingmar; tulevikus taastada !
        {
        clear;
        add('create table '+Ctable_names[__sccampaign]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__sccampaign)+',');
        add('  name varchar(255)  NOT NULL DEFAULT '''',');
        add('  description text  NOT NULL DEFAULT '''',');
        // COMMENT: 08.07.2009 Ingmar - millise firma alt kampaania tehakse
        //add('  company_id  integer NOT NULL references '+FTableNames[__sccompany]+'(company_id),');
        add('  begins '+__MapdateTimeVariable()+' NOT NULL DEFAULT '+__DefaultDate()+',');
        add('  ends   '+__MapdateTimeVariable()+' NULL,');
        add('  stop '+__MapModBoolean()+' NOT NULL DEFAULT ''f'','); // COMMENT: tavaliselt kampaania kestab mingist ajast mingi ajani; aga on alati hetki, kus tuleb enneaegselt ta peatada
        add('  stop_reason  '+__MapLongText+'  NOT NULL DEFAULT '''',');
        add('  status '+__MapCharType(2)+' NOT NULL DEFAULT '''','); // COMMENT: hetkel reserveeritud !
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0');
         // mod stat
        self.__addModFooter(__sccampaign,tmpBfr);
        self.__addConstraint(__sccampaign,tmpBfr);
        add(')');
        FTableDefs[__sccampaign]:=tmpBfr.Text;

        // --------------------------------------------------------------------
        // @@11:
        clear;
        add('create table '+Ctable_names[__sccampaign_bindings]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__sccampaign_bindings)+',');
        add('  campaign_id '+__MapIntType()+' NOT NULL,');
        add('  item_type '+__MapCharType(2)+' NOT NULL DEFAULT '''','); // S - service; teenused; P - product; tooted; PG - tootegrupp
        add('  item_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        //add('  product_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        //add('  service_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  descr '+__MapVarcharType(512)+' NOT NULL  DEFAULT ''''');
        // mod stat
        self.__addModFooter(__sccampaign_bindings,tmpBfr);
        self.__addConstraint(__sccampaign_bindings,tmpBfr);
        // add('  CONSTRAINT '+FTableNames[__sccampaign_bindings]+'_chk CHECK (campaignbinding_productgroup_id>0 OR campaignbinding_product_id>0 OR campaignbinding_service_id>0)');
        add(')');
        FTableDefs[__sccampaign_bindings]:=tmpBfr.Text;
       }
      // --------------------------------------------------------------------
      // @@12:
      Clear;
      add('create table ' + Ctable_names[__scarticles_groups]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scarticles_groups) + ',');
      add('  parent_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  name ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  descr ' + __MapLongText + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scarticles_groups, tmpBfr);
      self.__addConstraint(__scarticles_groups, tmpBfr);
      add(')');
      FTableDefs[__scarticles_groups] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // @@13:
      // 27.09.2009 ingmar; lihtsustasin ennem olid toote tabel, teenuste tabel jne jne...keerukaks ajab asjad !!!
      Clear;
      add('create table ' + Ctable_names[__scarticles]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scarticles) + ','); // palju palju palju andmeid
      add('  articles_groups_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  code ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''',');
      // char võib osutuda varieeruvate tootekoodide puhul mõttetuks; kohtasin seda erinevates firmades
      // saabunu toote originaal kood; ntx tarbija arvel olnud kood !!!!
      add('  code2 ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''',');

      //add('  grpid integer NOT NULL references '+FTableNames[__scproduct_groups]+'(productgroup_id),');
      add('  name ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  unit ' + __MapVarcharType(30) + ' NOT NULL DEFAULT '''',');
      // tulevikus lubame ka mõõte sisestada
      //add('  dimensions '+__MapVarcharType(20)+' NOT NULL DEFAULT '''',');
      add('  dim_h ' + __MapVarcharType(8) + ' NOT NULL DEFAULT '''',');
      add('  dim_l ' + __MapVarcharType(8) + ' NOT NULL DEFAULT '''',');
      add('  dim_w ' + __MapVarcharType(8) + ' NOT NULL DEFAULT '''',');

      add('  type_ ' + __MapCharType(2) + ' NOT NULL DEFAULT ''P'','); // P - product toode; S- service; teenus
      // ntx 5%,9%. kui = 0 siis vaikimis käibemaks !
      add('  vat_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // COMMENT: reserveeritud; kui on vaikimisi kuupäev ei pea seda välja täitma !!!!
      // 08.11.2009 ingmar; definitsioon määrab ntx, kui milline on min ja max pikkus;
      // samuti tüübid ntx: Code 128
      add('  barcode_def_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // tuleb klassifikaator tabelist !!!
      // http://en.wikipedia.org/wiki/Code_128
      add('  barcode ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      // EAN 13 code : 3566835483458 CN8 code : 84021910
      add('  cn8 ' + __MapVarcharType(8) + ' NOT NULL DEFAULT '''',');
      // http://en.wikipedia.org/wiki/European_Article_Number
      add('  ean_code ' + __MapVarcharType(20) + ' NOT NULL DEFAULT '''','); // teoorias peaks olema max: 17 kohta !
      //add('  company_id  integer NOT NULL,');
      add('  descr ' + __MapLongText + ' NOT NULL DEFAULT '''',');
      add('  manufacturer ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      // ntx tootega seotud täiendav info; kasvõi help failid jne jne
      add('  url ' + __MapVarcharType(512) + ' NOT NULL DEFAULT '''',');

      //  lao puhul riiuli number/kood
      add('  shelfnumber ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');

      // partii ID, kui tekib ka tootmise tabel !!!
      add('  batch_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // 20.11.2010 Ingmar
      add('  batch_number ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''','); // partiinumber


      add('  manufacturing_date ' + __MapdateTimeVariable() + ' NULL,'); // valmistamise kuupäev
      add('  packaging_date ' + __MapdateTimeVariable() + ' NULL,');     // pakendamise kuupäev
      add('  best_before  ' + __MapdateTimeVariable() + ' NULL,');       // parim enne
      add('  expiry ' + __MapdateTimeVariable() + ' NULL,');       // kõlblik kuni kuupäev

      // arvutus ntx tootehinna jaoks
      add('  formula ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');


      // 09.11.2009 Ingmar; soovitati selliseid kontosid hoida artiklite juures
      // kas neid mitu ei või olla ühe artikli juures
      add('  purchase_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ostukonto  !
      add('  sale_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');     // müügikonto !
      add('  expense_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // müügikulu; ntx müüsin maja, pidin notarile tasuma N krooni; jne jne



      // 23.12.2009 Ingmar; alles nüüd tulin selle peale, et kogus võib arvel ka olla ntx 0.3 kg jne
      // st. jätame lipud, mille järgi koguse reziimi määratakse
      add('  qty_flags  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // rohkem vaja lao juures; tuleviku jaoks !
      add('  qty_minlevel ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  qty_maxlevel ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      add('  price_calc_meth ' + __MapCharType(1) + ' NOT NULL DEFAULT ''A'','); // A-avarage keskmine


      // ntx artiklid; transport; mida iganes...seda artiklit koheldakse teisiti; hetkel on ETTEMAKS tüüp reserveeritud !
      add('  special_type_flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  arttype_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // 05.05.2014 Ingmar
      add('   disp_web_dir ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');

      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // COMMENT: ntx toote müük lõpetatud, toode on ettetellitav;
      add('  archive_rec_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');

      // mod stat
      self.__addModFooter(__scarticles, tmpBfr);
      self.__addConstraint(__scarticles, tmpBfr);
      //        add('  CONSTRAINT '+FTableNames[__scproducts]+'_chk CHECK (product_tax_perc>=0 AND trim(product_code)<>'''' AND trim(product_name)<>''''),');
      //        add('  CONSTRAINT '+FTableNames[__scproducts]+'_contr FOREIGN KEY(product_grpid) REFERENCES '+FTableNames[__scproduct_groups]+'(productgroup_id) ON DELETE RESTRICT');
      add(')');
      FTableDefs[__scarticles] := tmpBfr.Text;

      // --------------------------------------------------------------------

      Clear;
      add('create table ' + CTable_names[__scarticles_attrb]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scarticles_attrb) + ',');
      add('  article_id  ' + __MapIntType() + ' NOT NULL,');
      add('  attrib_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  attrib_val ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  attrib_descr ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  classificator_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scarticles_attrb, tmpBfr);
      add(')');
      FTableDefs[__scarticles_attrb] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@14: läbi antud tabeli saame artikli hinnakujundust väga detailselt jälgida !
      Clear;
      add('create table ' + Ctable_names[__scarticles_price_table]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scarticles_price_table) + ',');
      add('  article_id ' + __MapIntType() + ' NOT NULL,');
      add('  price ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      add('  discount_perc  ' + __MapPercType() + ' NOT NULL,');
      add('  begins ' + __MapdateTimeVariable() + ' NOT NULL DEFAULT ' + __DefaultDate() + ',');
      add('  ends   ' + __MapdateTimeVariable() + ' NULL,');
      add('  type_ ' + __MapCharType(1) + ' NOT NULL DEFAULT ''P'',');
      // P - sisseostu hind; S - müügihind; C - kampaaniahind ehk peale selle lõppemist võetakse hind
      add('  prsource ' + __MapCharType(1) + ' NOT NULL DEFAULT ''M'','); // M - manual, hinda muudeti käsitsi !
      // 26.12.2009 Ingmar peame siduma laoga !
      add('  warehouse_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''''); // reserveeritud
      // mod stat
      self.__addModFooter(__scarticles_price_table, tmpBfr);
      self.__addConstraint(__scarticles_price_table, tmpBfr);
      add(')');
      FTableDefs[__scarticles_price_table] := tmpBfr.Text;




      // --------------------------------------------------------------------
        {
        // @@15:
        clear;
        add('create table '+Ctable_names[__scservices]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scservices)+',');
        add('  name '+__MapVarcharType(255)+' NOT NULL DEFAULT '''',');
        add('  code '+__MapVarCharType(15)+' NOT NULL DEFAULT '''','); // COMMENT: võimaldab organiseerida sisemisi teenuseid; programm peaks tootekoodi alati nõudma !!!
        add('  unit '+__MapVarcharType(20)+' NOT NULL DEFAULT '''',');
        add('  price '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');
        add('  status '+__MapCharType(2)+' NOT NULL DEFAULT '''',');
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  archive_rec_id '+__MapIntType()+'  NOT NULL DEFAULT 0,');
        add('  reserved1 '+__MapIntType()+' NOT NULL DEFAULT 0');
        // mod stat
        self.__addModFooter(__scservices,tmpBfr);
        self.__addConstraint(__scservices,tmpBfr);
        add(')');
        FTableDefs[__scservices]:=tmpBfr.Text;

        // --------------------------------------------------------------------
        // @@16:
        clear;
        add('create table '+Ctable_names[__scservice_price_table]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scproducts_price_table)+',');
        add('  service_id  '+__MapIntType()+' NOT NULL,');
        add('  price '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');
        add('  begins '+__MapdateTimeVariable()+' NOT NULL DEFAULT '+__DefaultDate()+',');
        add('  ends   '+__MapdateTimeVariable()+' NULL');
        // mod stat
        self.__addModFooter(__scservice_price_table,tmpBfr);
        self.__addConstraint(__scservice_price_table,tmpBfr);
        add(')');
        FTableDefs[__scservice_price_table]:=tmpBfr.Text;


        }

      // --------------------------------------------------------------------
      // @@17: vouchers / discount
      Clear;
      add('create table ' + CTable_names[__scclient_discount]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scclient_discount) + ',');
      add('  name ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  descr ' + __MapLongText + ' NOT NULL DEFAULT '''',');
      add('  client_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  item_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // COMMENT: S - service; teenused; P - product; tooted; PG - tootegrupp
      add('  item_id ' + __MapBigIntType() + ' NOT NULL DEFAULT 0,');
      // COMMENT: millele allahindlus kehtib; ÜKS 3 st !
      // add('  productgroup_id  '+__MapIntType()+' NOT NULL DEFAULT 0,');
      // add('  product_id  '+__MapIntType()+' NOT NULL DEFAULT 0,');
      // add('  service_id  '+__MapIntType()+' NOT NULL DEFAULT 0,');
      add('  discount_perc ' + __MapPercType() + ' NOT NULL DEFAULT 0,');
      add('  discount_validfrom   ' + __MapdateVariable() + ' NOT NULL DEFAULT ' + __DefaultDate() + ',');
      add('  discount_validuntil  ' + __MapdateVariable() + ' NULL,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  archive_rec_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0'); // COMMENT: firma/osakond, mille piires allahindlus
      // mod stat
      self.__addModFooter(__scclient_discount, tmpBfr);
      self.__addConstraint(__scclient_discount, tmpBfr);
      add(')');
      FTableDefs[__scclient_discount] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@18: ettemaksud
{
        clear;
        add('create table '+CTable_names[__scprepayment ]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scprepayment)+',');
        add('  client_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  prepaidsum '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'','); // kogu ettemaks
        add('  sumleft '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');    // palju jäänud kasutada


        add('  reserved1 '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  currency '+__MapCharType(3)+'  NOT NULL DEFAULT  '''+getDefaultCurrency+''',');
        add('  currency_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  currency_drate_ovr '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');

        // 27.06.2010 ingmar
        add('  prtype '+__MapCharType(1)+' NOT NULL DEFAULT '''',');
        add('  status '+__MapCharType(2)+' NOT NULL DEFAULT '''',');
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0'); // COMMENT: firma, mille piires allahindlus

        // mod stat
        self.__addModFooter(__scprepayment,tmpBfr);
        self.__addConstraint(__scprepayment,tmpBfr);
        add(')');
        FTableDefs[__scprepayment]:=tmpBfr.Text;

        clear;
        add('create table '+CTable_names[__scprepayment_dist_scheme]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scprepayment_dist_scheme)+',');
        add('  client_id  '+__MapIntType()+' NOT NULL,');
        add('  item_type '+__MapCharType(2)+' NOT NULL DEFAULT '''',');
        add('  item_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  prp_acc_rec_id '+__MapBigIntType()+' NOT NULL,');
        add('  usg_acc_rec_id '+__MapBigIntType()+' NOT NULL,');
        // --
        add('  sum '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');
        add('  sumovr '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');
        add('  status '+__MapCharType(2)+' NOT NULL DEFAULT ''''');

        self.__addModFooter(__scprepayment_dist_scheme,tmpBfr);
        self.__addConstraint(__scprepayment_dist_scheme,tmpBfr);
        add(')');
        FTableDefs[__scprepayment_dist_scheme]:=tmpBfr.Text;
        }


      // --------------------------------------------------------------------
      // @@19:
      Clear;
      add('create table ' + CTable_names[__scbills]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scbills) + ',');
      add('  client_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  client_vatnumber ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');

      // tavaline müügiarve, samuti firma ostuarve; standartne !
      //add('  number '+__MapBigIntType+' NOT NULL,');
      add('  bill_number ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''',');
      add('  bill_date ' + __MapDateVariable + ' NOT NULL,');

      // 19.02.2010 Ingmar; ei näe andmete dubleerimisel mõtet !
      // hankijalt saadud ostuarve andmed;
      //add('  purch_billnr '+__MapVarCharType(35)+' NOT NULL DEFAULT '''','); // hankija poolt saadetud arve nr.
      //add('  purch_billdate '+__MapDateVariable()+' NULL,'); // hankija poolt saadetud arve kp.
      //add('  purch_billdue_date '+__MapDateVariable()+' NULL,'); // hankija poolt antud maksetähtaeg

      // kehtib tavalise arve puhul !
      // tavaliselt võetakse nö saatmiseaadress arve pealt, aga lubame siis ka seda nö ülekirjutada
      add('  billing_addr2 ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');

      // COMMENT: ntx 1 müügiarve, 2 sisseostu arve, 3 kuluarve (bill of costs), 4 ettemaksuarve jne arvetüübid teha hardcoded formaadis...
      add('  bill_type  ' + __MapCharType(2) + '  NOT NULL DEFAULT '''',');  // !!!!!!!!!!!!!!!!!!!
      // parem arvutada, kui koheselt arveridade summad meil siin !!! andmebaasi säästame
      //add('  totalsum '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'','); 19.02.2010
      // sum(a.summa + a.kaibemaks + a.ymardamine - a.laekunudsumma - a.ettemsumma) as Saldo


      // SUMMAD !
      //       Add('A.Summa+A.KaibeMaks+A.ViivisSumma+A.Ymardamine-A.EttemSumma-A.LaekunudSumma As Makstud,');

      add('  totalsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');         // arveridade summa, ilma käibemaksuta
      add('  roundsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');    // --
      add('  vatsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');      // käibemaks
      //  ennekõike mõeldud pöördkäibemaksu info hoidmiseks ei oma nö kriitilist väärtust
      add('  vatsum2 ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');      // käibemaks 2;

      add('  incomesum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');   // laekunud summa
      add('  prepaidsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');  // summa, mis laekumisest jäi üle

      // --- 30.03.2011 Ingmar
      add('  crprepaidsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      // kui kreeditarvega tõsteti üles ettemaks, siis jätame selle summa meelde !!!
      // ---
      add('  fine ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');  // viivissumma


      // 27.06.2010 Ingmar
      add('  uprepaidsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // ettemaksusumma, mis kasutati ära antud arve tasumisel
      // ------------

      add('  form_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // arvevormide kirjeldused
      add('  due_date ' + __MapDateVariable + ' NULL,');  // maksetähtaeg

      add('  paymentterm ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // 30.03.2011 Ingmar; paymentterm_id ->  paymentterm
      add('  overdue_perc   ' + __MapPercType() + ' NOT NULL DEFAULT 0,'); // TODO: see tüüp pole just parim !!!  arve viiviseprotsent


      add('  descr  ' + __MapVarCharType(512) + '  NOT NULL DEFAULT '''','); // reserveeritud

      add('  currency ' + __MapCharType(3) + '  NOT NULL DEFAULT  ''' + getDefaultCurrency + ''',');
      add('  currency_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // 16.03.2010 Ingmar; et ikka reaalne kurss olemas !!!
      add('  currency_drate_ovr ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // daily rate !

      // --- ARVE
      // finants: kõik on peegeldatud ju ka pearaamatus !
      add('  accounting_register_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // 04.01.2009 ingmar; ntx kui väljastaja keegi teine, kui arve tegija
      add('  issued2 ' + __MapVarCharType(45) + ' NOT NULL DEFAULT '''',');
      add('  msg_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');


      // kauge tulevik
      add('  saleperson_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // add('  vat_id smallint  NOT NULL DEFAULT 0,');  // COMMENT: üldine käibemaksumäär
      // add('  accounting_period_id  '+__MapIntType()+' NOT NULL DEFAULT 0,');
      add('  openedby ' + __MapIntType() + ' NOT NULL DEFAULT 0,');  // COMMENT: kes arve avas
      add('  closedby ' + __MapIntType() + ' NOT NULL DEFAULT 0,');  // COMMENT: kes arve sulges; tavaliselt ideaalses maailmas avaja = sulgeja


      // Ntx hankijale võlgu kontod; ostjate võlad kontod võivad olla ka erinevad
      //  - müügiarve puhul siis deebetkonto
      //  - ostuaarve puhul kreeditkontoga
      add('  dc_account_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // 14.01.2010 ingmar
      add('  vat_flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');  // kuidas käibemaksuga arveldame; ntx USA'sse saates ei pane jne jne

      // ------- täiendavad lipud !
      add('  prepayment_required ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'','); // COMMENT: nõutav ettemaks !


      add('  payment_status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      // 11.07.2010 Ingmar
      add('  payment_date  ' + __MapDateVariable + ' NULL,');

      // http://www.emta.ee/index.php?id=14397
      add('  vat_references ' + __MapVarCharType(1024) + ' NOT NULL DEFAULT '''',');

      // ----
      add('  transport_type_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // meretransport, maismaatransport jne
      add('  transport_flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      add('  delivery_statment_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // CFR  / CIF / CIP
      add('  delivery_trcode ' + __MapVarCharType(65) + ' NOT NULL DEFAULT '''',');
      add('  delivery_addcost ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');  // reserveerime arve lisakulud !

      add('  delivery_addr ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  delivery_weight ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      add('  delivered_by  ' + __MapVarCharType(100) + ' NOT NULL DEFAULT '''','); // ntx USPS kaudu
      add('  delivered_by2 ' + __MapIntType() + ' NOT NULL  DEFAULT 0,'); // eeldefineeritud kanalid
      add('  delivery_date ' + __MapDateVariable + '  NULL,'); // millal firmast kaup välja saadeti

      // ----
      add('  credit_bill_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');


      add('  summary_id ' + __MapIntType() + ' NOT NULL  DEFAULT 0,'); // koondarve ID !
      add('  warehouse_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');


      // COMMENT: yldised staatused; ntx arve annuleeritud ...
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');     // COMMENT: millise firma alt arve tehtud
      // 06.04.2012 Ingmar; viitenumbrid olid puudu !!!! ntx ostuarvel peaks saama ka viitenumbrit sisestada, mitte pole kliendi ID'ga seotud !
      add('  ref_nr ' + __MapVarCharType(30) + ' NOT NULL DEFAULT '''',');
      add('  ref_nr_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');


      add('  reserved1  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  reserved2  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // 02.03.2013 Ingmar; veebiarve jaoks hash
      add('  billhash  ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      // 05.05.2014 Ingmar; ntx ilus oleks tulevikus panna märge, kus see arve imporditi !
      add('  bill_source_ptn  ' + __MapVarCharType(100) + ' NOT NULL DEFAULT ''''');

      // mod stat
      self.__addModFooter(__scbills, tmpBfr);
      self.__addConstraint(__scbills, tmpBfr);
      add(')');
      FTableDefs[__scbills] := tmpBfr.Text;

      // --------------------------------------------------------------------


      Clear;
      add('create table ' + CTable_names[__scpayment]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scpayment) + ',');
      add('  payment_type ' + __MapCharType(1) + ' NOT NULL DEFAULT ''P'','); // maksekorraldus paymentorder
      add('  payment_nr ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''','); // 06.03.2010 ingmar
      add('  payment_date ' + __MapDateVariable + ' NULL,');

      // INCOMINGNR
      add('  document_nr ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''',');
      add('  c_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  d_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // ---
      add('  payer_account_nr ' + __MapVarcharType(35) + ' NOT NULL DEFAULT '''','); // --
      add('  payment_rcv_name ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''','); //  Saaja nimi:: Kliendi nimi, kellele raha tasutakse.
      add('  payment_rcv_bank_id ' + __MapIntType() + ' NULL,');
      add('  payment_rcv_bank ' + __MapVarcharType(50) + ' NOT NULL DEFAULT '''',');
      // Saaja panga nimi; täita siis kui meil polnud sellist panka defineeritud
      add('  payment_rcv_account_nr ' + __MapVarcharType(35) + ' NOT NULL DEFAULT '''','); // --
      add('  payment_rcv_refnr ' + __MapVarcharType(30) + ' NOT NULL DEFAULT '''',');  // Saaja viitenumber

      // kui klient on meil süsteemis defineeritud, siis tema ID siia ...
      add('  client_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  client_name2 ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''','); // süsteemis registreerimata klient

      // Kas tavaline (panka käsitsi sisestatav maksekorraldus), telehansa (swedi tekstifail otse panka laadimiseks); U-neti makse (u-net’i tekstifail)
      add('  optype  ' + __MapCharType(2) + ' NOT NULL DEFAULT ''M'',');  // maksekorralduse tüüp; vaikimisi käsitsi
      add('  descr ' + __MapLongText + '  NOT NULL DEFAULT '''',');

      // võimaldab kiiremaid päringuid teha !
      add('  sumtotal ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');  // tasutav summa
      add('  trcost ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');    // pangatasud !
      add('  retrnsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');  // kassa puhul, mitu krooni tagasi


      add('  currency_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  currency ' + __MapCharType(3) + ' NOT NULL DEFAULT ''' + getDefaultCurrency + ''',');
      add('  currency_drate_ovr ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // daily rate !


      // 25.03.2010 ingmar
      // peame reaalselt ka küsima, kas makse ka sooritatud !!!!
      //add('  payment_confirmed '+__MapModBoolean()+' NOT NULL DEFAULT ''f'',');
      //add('  payment_confdate '+__MapdateVariable()+'  NULL ,'); // COMMENT: saab määrata, mis kuupäevast saata; võib puududa

      // tulevik;
      add('  card_payment ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  card_nr ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');


      add('  template ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  template_name ' + __MapVarcharType(35) + ' NOT NULL DEFAULT '''',');

      // pearaamatu kanne...
      add('  accounting_register_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // 12.02.2011 Ingmar;
      // --- objekti põhine arvestus; reaalselt on objektid ka raamatupidamises kande juures !
      add('  object_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');

      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scpayment, tmpBfr);
      self.__addConstraint(__scpayment, tmpBfr);
      add(')');
      FTableDefs[__scpayment] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // 07.03.2010
      Clear;
      add('create table ' + CTable_names[__scpayment_data]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scpayment_data) + ',');
      add('  payment_id ' + __MapIntType() + '  NOT NULL  DEFAULT 0,');
      add('  item_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  item_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  item_descr ' + __MapVarcharType(120) + ' NOT NULL DEFAULT '''',');
      add('  splt_sum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // kui põhisumma on jaotatud mitme arve peale ntx

      // 06.04.2010 Ingmar; Peaksime ka seal hoidma konto infot !
      add('  account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT ''''');
      self.__addConstraint(__scpayment_data, tmpBfr);
      add(')');
      FTableDefs[__scpayment_data] := tmpBfr.Text;

      // --------------------------------------------------------------------
      Clear;
      add('create table ' + CTable_names[__scpayment_files]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scpayment_files) + ',');
      add('  file_type ' + __MapCharType(1) + ' NOT NULL DEFAULT ''E'','); // ekspordi fail
      add('  payment_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  filename ' + __MapVarCharType(1024) + '  NOT NULL DEFAULT '''',');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scpayment_files, tmpBfr);
      self.__addConstraint(__scpayment_files, tmpBfr);
      add(')');
      FTableDefs[__scpayment_files] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@20:
      Clear;
      add('create table ' + CTable_names[__screferencenumbers]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__screferencenumbers) + ',');
      add('  refnumber ' + __MapVarCharType(30) + ',');
      add('  client_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  fixed ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'',');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // D kustutatud

      // 23.11.2010 Ingmar tunduvalt kergem ju elu, kui viitenr seotud konkreetselt arve või tellimusega
      add('  bill_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  order_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__screferencenumbers, tmpBfr);
      self.__addConstraint(__screferencenumbers, tmpBfr);
      add(')');
      FTableDefs[__screferencenumbers] := tmpBfr.Text;

      // --------------------------------------------------------------------
        {
          Margus Tammeraja
          Mul on mõned ideed, mille teostatavust peaks testima – kas on nt võimalik kasutada universaalset toimingupõhist lähenemist.
          Teoreetiliselt peaks iga raamatupidamises registreeritav kanderida olema mingi pearaamatu kontoga seonduv kirje,
           mis võib olla seotud nö allsüsteemi (nt müügi- või ostureskontro) puhul hulga täiendavate atribuutidega.
           Ehk siis kas on mõtet teha nt eraldi arveridade tabel või on arveridade
           info nö kandekirjes ehk siis kasutatakse ühte supertabelit.

           Klassikaline jama on kui nt müügireskontrot võetakse eraldi tabelite pealt võrreldes temaga seotud kannetega,
           mis on omaette pearaamatu kandekirjete tabelis ning saadakse erinev tulemus.

           Kuidas teil on hetkel selle teema lahendus plaanitud?
        }
      // @@21:
      // COMMENT: vanad head arve read
      Clear;
      add('create table ' + CTable_names[__scbill_lines]);
      add('(');
      // 20.08.2009 ingmar; paranoia; kui paljud firmad võivad int tüübi ikka täis saada :( On selliseid kogemusi
      add('  id ' + __MapBigIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scbill_lines) + ',');
      add('  bill_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  linetype ' + __MapCharType(2) + ' NOT NULL DEFAULT ''P'','); // COMMENT: P - tooted; S - teenused; A - firma sisesed varad jne

      // 14.01.2010 viskasin minema; tekitas vaid segadust !
      //add('  rec_nr smallint  NOT NULL DEFAULT 0,'); // COMMENT: et arveread oleks ikka samad; üldiselt ei pea kasutama; order by abiks; aga võtame tuleviku tarbeks
      // tuleb artikli küljest
      add('  discount_perc   ' + __MapPercType() + '  NOT NULL DEFAULT 0, ');

      // täidetud siis ja ainult siis, kui kliendil on määratud allahindlust !!!!!
      add('  cust_discount_id ' + __MapIntType() + ' NOT NULL DEFAULT 0, ');

      add('  item_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // COMMENT: saab ainult eksisteerida, kui P ja S read;
      add('  item_price ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      // kui on lisatud toode / teenus, siis võetakse sealt kehtiv hind; eraldi teenus tuleb summa sisestada

      // 08.01.2010 Ingmar; seoses sellega, et avatud arvete puhul finantskannete tabelisse midagi ei tule
      // peame jätma meelde salvestamisel ka kasutatud kontode info;
      add('  item_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // toote/teenuse kogus !
      add('  quantity  ' + __MapMoneyType() + ' NOT NULL DEFAULT ''0.00'',');
      add('  total ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // reasumma


      // 05.12.2009 Ingmar
      //add('  vat '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'','); // käibemaksu %
      add('  vat_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');  // COMMENT: kasutusel siis, kui on tegemist teise käibemaksumääraga ntx 5% 9% jne
      // 22.04.2010 Ingmar
      add('  vat_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // 27.04.2010 Ingmar; käibemaksu summat vaja ka hoida; "ohutum"
      add('  vat_rsum  ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');


      // COMMENT: vajalik siis ja ainult siis; kui pannakse rida, mida pole teenustes toodetes kirjeldatud veel; kasvõi postikulud kuhugi riiki jne
      //add('  descr2  '+__MapVarCharType(255)+'  NOT NULL DEFAULT '''',');
      add('  descr2  ' + __MapVarCharType(255) + '  NULL,'); // see täidetud, siis ja ainult siis, kui kasutaja ise pannud uue kirjelduse
      add('  unit2 ' + __MapVarCharType(30) + ' NULL,'); // sama lugu siin !!!


      // 05.12.2009 Ingmar
      // viide ka pearaamatu kande kirjendile !
      // add('  accounting_record_id '+__MapBigIntType()+' NOT NULL DEFAULT 0,');
        {
         kõige kergem oleks nii
         aga ma mõtlen, et kui arve peal on kaks toodet 1 tikutops hinnaga 5 krooni ja
         1 kuuba sigar hinnaga 500 kr. Transport on 1000, siis ei saaks kohe mitte jagada,
         et tikutopsi hind on 5kr+ 500kr ja kuuba sigar on 500kr+500kr panimõmm?
         oleks vaja vist mingi proportsioon välja arvutada
         et kui suure osa kogusummast moodustab see üks toode ning siis sama suure osa transpordist jagad sellele tootele
        }
      add('  dist_transport_cost ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');

      add('  reserved1 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // 12.02.2011 Ingmar;
      // --- objekti põhine arvestus; reaalselt on objektid ka raamatupidamises kande juures !
      add('  object_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');

      // 25.04.2015 Ingmar; seoses auto käibemaksuga, siin hoitakse mitu protsenti käibemaksust tohib summast maha võtta !
      add('  vat_cperc  ' + TEstbk_MapDataTypes.__MapMoneyType() + ' NOT NULL DEFAULT 100,');
      //add('  reserved3 '+__MapIntType()+' NOT NULL DEFAULT 0,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // COMMENT: arverea lisainfo
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0'); // COMMENT: millise firma arve
      // mod stat
      self.__addModFooter(__scbill_lines, tmpBfr);
      self.__addConstraint(__scbill_lines, tmpBfr);
      add(')');
      FTableDefs[__scbill_lines] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // 21.02.2010 Ingmar
      Clear;
      add('create table ' + CTable_names[__scorders]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scorders) + ',');
      add('  order_nr ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''',');
      add('  order_date ' + __MapDateVariable + ' NOT NULL,');
      add('  order_type  ' + __MapCharType(2) + '  NOT NULL DEFAULT ''P'','); // purchase order - ostutellimus
      // ---
      // add('  order_gen_id  '+__MapIntType()+' NOT NULL DEFAULT 0,');       // tellimusest koostatud arve ! ostuarve ntx !!!
      // first half ! tavaliselt ongi esimene osa ...
      // add('  order_prpayment_id  '+__MapIntType()+' NOT NULL DEFAULT 0,'); // tekkinud ettemaksuarve seotud ostu/müügitellimusega


      // -- offer_id
      add('  offer_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // pakkumisest tekkinud müügitellimus
      add('  quantity  ' + __MapMoneyType() + ' NOT NULL DEFAULT ''0.00'',');
      // --
      add('  order_prp_due_date ' + __MapDateVariable + ' NULL,'); // ettemaksu kuupäev !
      add('  order_prp_perc ' + __MapPercType + ' NOT NULL DEFAULT ''0.00'','); // ettemaksu protsent
      // --
      //add('  rel_pcksend_date '+__MapDateVariable+' NOT NULL,'); // sisuliselt planeeritud aeg, mis ajaks võiks kaup kohal olla; relatiivne prognoos
      add('  rel_delivery_date ' + __MapDateVariable + '  NULL,'); // ostutellimuse puhul relatiivne aeg, millal võiks kaup saabuda;
      // müügitellimuse puhul, millal reaalselt kaup välja läks

      add('  client_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ka hankija; kui on meiepoolne ostutellimus
      add('  warehouse_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  descr  ' + __MapVarCharType(512) + '  NULL,'); // see täidetud, siis ja ainult siis, kui kasutaja ise pannud uue kirjelduse

      // --
      add('  order_sum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // tellimuse ridade kogusumma; vähendab vajadust teha SUM
      // 16.07.2010 ingmar
      add('  order_roundsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      add('  order_vatsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');



      add('  paid_sum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // -->
      add('  payment_status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');



      add('  currency ' + __MapCharType(3) + '  NOT NULL DEFAULT  ''' + getDefaultCurrency + ''',');
      add('  currency_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  currency_drate_ovr ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');



      // sisuliselt, kuhu tellimus saata; ostu-/müügitellimus ostu puhul, kus meile saata, tellimuse puhul, kuhu tellijatele saata
      add('  countrycode ' + __MapCharType(3) + ' NOT NULL DEFAULT ' + QuotedStr(Cglob_DefaultCountryCodeISO3166_1) + ',');
      add('  county_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  city_id ' + __MapIntType() + ' NOT NULL  DEFAULT 0,');
      add('  street_id ' + __MapIntType() + '  NOT NULL  DEFAULT 0,');
      add('  house_nr ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''','); // COMMENT: võib olla pikk talunimi !!!
      add('  apartment_nr ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  zipcode ' + __MapVarcharType(15) + ' NOT NULL DEFAULT '''',');
      add('  phone   ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  mobilephone ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  fax ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  email ' + __MapVarcharType(300) + ' NOT NULL DEFAULT '''',');
      add('  contact  ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');


      // ntx meie tellime kaupa ekirja kaudu
      add('  order_channel_id ' + __MapIntType() + '  NOT NULL  DEFAULT 0,'); // klassifikaatoritest, mis kanali kaudu tellimus tehti
      add('  order_channel ' + __MapVarcharType(300) + ' NOT NULL DEFAULT '''','); // ntx ekirja aadress, kuhu tellimus saadeti

      // ---
      add('  order_ccperson_id  ' + __MapIntType() + '  NOT NULL  DEFAULT 0,');
      add('  order_ccperson ' + __MapVarcharType(85) + ' NOT NULL DEFAULT '''','); // isik kellele tellimus edastati; reserveeritud

      add('  order_senddate ' + __MapDateVariable + '  NULL,'); // millal reaalselt saatsime tellimus
      add('  order_confdate ' + __MapDateVariable + '  NULL,'); // millal tuli kinnitus; kasvõi palve ettemaks tasuda !!!

      add('  transport_type_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');     // kuidas kaup saata; tuleb klassifikaatoritest !!!!
      // ---
      add('  delivery_statment_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // ntx kaup saadetakse 3-4 päeva jooksul; tuleb klassifikaatoritest !!!
      add('  delivered_by  ' + __MapVarCharType(100) + ' NOT NULL DEFAULT '''','); // ---
      add('  delivered_date ' + __MapDateVariable + '  NULL,'); // millal kaup tuli

      // ----
      // ntx tuli lattu, laojuht vaatas peale, et okei...sobib ja pani accepti, tulevikumuusika !
      add('  delivery_accept_date ' + __MapDateVariable + '  NULL,');
      add('  delivery_accept_by' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // 01.03.2010 Ingmar
      add('  process_order_flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  saleperson_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');


      add('  template ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  template_name ' + __MapVarcharType(35) + ' NOT NULL DEFAULT '''',');

      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // kas ootel; ootel/täitmisel; kinnitatud

      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scorders, tmpBfr);
      self.__addConstraint(__scorders, tmpBfr);
      add(')');
      FTableDefs[__scorders] := tmpBfr.Text;



      // --------------------------------------------------------------------

      Clear;
      add('create table ' + CTable_names[__scorder_billing_data]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scorder_billing_data) + ',');
      add('  order_id ' + __MapIntType() + '  NOT NULL  DEFAULT 0,');
      add('  item_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // S - service; teenused; P - product; tooted; PG - tootegrupp
      add('  item_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT ''''');
      //self.__addModFooter(__scorder_billing_data,tmpBfr);
      self.__addConstraint(__scorder_billing_data, tmpBfr);
      add(')');
      FTableDefs[__scorder_billing_data] := tmpBfr.Text;

      // --------------------------------------------------------------------
      Clear;
      add('create table ' + CTable_names[__scorder_lines]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scorder_lines) + ',');
      add('  order_id ' + __MapIntType() + ' NOT NULL,');
      add('  item_id ' + __MapIntType() + ' NOT NULL  DEFAULT 0,');
      add('  quantity  ' + __MapMoneyType() + ' NOT NULL DEFAULT ''0.00'',');
      add('  price ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // ilma käibemaksuta
      add('  price2 ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // koos käibemaksuga

      add('  vat_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ntx VAT id
      add('  vat_perc ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      add('  vat_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  vat_rsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');


      add('  reserved1 ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ntx konto
      add('  descr  ' + __MapVarCharType(255) + '  NULL DEFAULT '''','); // see täidetud, siis ja ainult siis, kui kasutaja ise pannud uue kirjelduse
      add('  unit ' + __MapVarCharType(30) + ' NULL DEFAULT '''','); // sama lugu siin !!!
      add('  partcode ' + __MapVarCharType(255) + '  NULL DEFAULT '''','); // tarnija poolt edastatud kood; võõtkood CN8 jne jne
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''''); // D kui rida kustutati
      self.__addModFooter(__scorder_lines, tmpBfr);
      self.__addConstraint(__scorder_lines, tmpBfr);
      add(')');
      FTableDefs[__scorder_lines] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // LATE PAYMENTS
      // past due bills; võlas arved ja viivised
      // @@22:
{
        clear;
        add('create table '+CTable_names[__sclate_payments]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__sclate_payments)+',');
        add('  source_id    '+__MapIntType()+' NOT NULL DEFAULT 0,');
        //add('  lpnumber '+__MapBigIntType+',');
        add('  lpnumber '+__MapVarCharType(35)+' NOT NULL,');
        add('  lpdate   '+__MapDateVariable+' NOT NULL,');
        add('  client_id  '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  due_days   '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  period_start '+__MapDateVariable+' NOT NULL DEFAULT '+__DefaultDate()+',');
        add('  period_end '+__MapDateVariable+' NULL,');
        add('  total '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'','); // COMMENT: viivisearve kogusumma
        add('  reserved1 '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  reserved2 '+__MapIntType()+' NOT NULL DEFAULT 0,');
        //add('  reserved3 '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  status '+__MapCharType(2)+' NOT NULL DEFAULT '''',');
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0');
        // mod stat
        self.__addModFooter(__sclate_payments,tmpBfr);
        self.__addConstraint(__sclate_payments,tmpBfr);
        add(')');
        FTableDefs[__sclate_payments]:=tmpBfr.Text;
 }
      // --------------------------------------------------------------------
      // @@23:
      Clear;
      add('create table ' + CTable_names[__scincomings]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scincomings) + ',');
      add('  client_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // maksta saab, kas
      // A) arvet või
      // B) tellimust; ntx müügitellimus ja me nõuame ettemaksu !!!
      add('  bill_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  order_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // tellimuse ID !!!!!!!!!!!!!!

      // --- !!
      // add('  prepayment_id '+__MapIntType()+' NOT NULL DEFAULT 0,');

      //add('  source_account '+__MapVarcharType(50)+' NOT NULL DEFAULT '''',');
      add('  rec_nr smallint  NOT NULL DEFAULT 0,'); // COMMENT: laekumiste järjestus; postgre ja order keyword pole sõbrad
      add('  incoming_date  ' + __MapDateVariable + ',');  // COMMENT: laekumise kuupäev
      add('  payment_date  ' + __MapDateVariable + ',');   // COMMENT: makse kuupäev



      // ------
      // laekumise originaalsumma !
      add('  income_sum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // COMMENT: laekunud summa
      // ---

      //add('  usedsum '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');  // arve summa
      //add('  prpsum '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');   // ettemaksuks
      add('  currency ' + __MapCharType(3) + ' NOT NULL DEFAULT ''' + getDefaultCurrency + ''',');
      add('  currency_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  currency_drate_ovr ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');



      // konverteeritud vastavalt siis arve valuutasse !
      add('  conv_income_sum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // see summa märgitakse laekumistes arvele / tellimusele peale !
      // ---

      add('  conv_currency ' + __MapCharType(3) + ' NOT NULL DEFAULT ''' + getDefaultCurrency + ''',');
      add('  conv_currency_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  conv_currency_drate_ovr ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');

      // ------------
      // -- !!!
      add('  account_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  accounting_register_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // kande peakirje !


      // 28.12.2010 Ingmar
      add('  incomings_bank_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  cash_register_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');  // ntx tulevikus kassa ID !!!!

      add('  reserved1 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      //add('  reserved3 '+__MapIntType()+' NOT NULL DEFAULT 0,');

      //add('  source '+__MapCharType(1)+' NOT NULL DEFAULT ''B'','); // kuskohast siis raha tuli
      add('  direction ' + __MapCharType(1) + ' NOT NULL DEFAULT ''I'','); // kas sissetulek või hoopis siiski "väljaminek"
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      // COMMENT: ntx sissetulek annuleeriti mingil põhjusel; hetkel vaid D annuleeritud

      // 12.02.2011 Ingmar;
      // --- objekti põhine arvestus; reaalselt on objektid ka raamatupidamises kande juures !
      add('  object_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      // ---
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');   // COMMENT: millise firma laekumisega tegemist on
      // mod stat
      self.__addModFooter(__scincomings, tmpBfr);
      self.__addConstraint(__scincomings, tmpBfr);
      add(')');
      FTableDefs[__scincomings] := tmpBfr.Text;
      // tellimuste arved...TODO

      // --------------------------------------------------------------------
      // @@24:
      Clear;
      add('create table ' + CTable_names[__scaccounting_period]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scaccounting_period) + ',');
      add('  name ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''',');
      add('  period_start ' + __MapDateVariable + ' NOT NULL,');
      add('  period_end ' + __MapDateVariable + ' NULL,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scaccounting_period, tmpBfr);
      self.__addConstraint(__scaccounting_period, tmpBfr);
      add(')');
      FTableDefs[__scaccounting_period] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // COMMENT: käibemaksud
      // @@25:
      Clear;
      add('create table ' + CTable_names[__scVAT]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scVAT) + ',');
      add('  description ' + __MapVarcharType(40) + ' NOT NULL DEFAULT '''',');
      add('  perc  ' + __MapPercType() + ' NOT NULL,');
      add('  ldescription ' + __MapVarcharType(512) + ' NOT NULL DEFAULT '''',');


      // http://www.emta.ee/?id=4361
        {
        5.2.1.4.3. Käibemaksu võlgnevus
        Käibemaksu tagasiarvestusel kasutatakse sisendkäibemaksu otsearvestuse ja proportsionaalse mahaarvamise segameetodit.
        Tulenevalt riigi raamatupidamise üldeeskirja nõudest kantakse sisendkäibemaksu tagastamisele mittekuuluv osa eraldi kulukontole.

        Käibemaks kajastatakse järgmistel kontodel:
        Käibemaksu kohustus
        Arvestatud käibemaks
        Sisendkäibemaks

         Kui klient maksab kauba või teenuse eest ette, siis tuleb ettemaksult arvestada käibemaksu,
         olenemata sellest, kas käive raamatupidamise seisukohast toimus või mitte.
         http://www.rmp.ee/foorum/20/7235?HL=saldoga



         Oh, seletage mulle ühte asja. Pole varem käibemaksuga reaalselt üldse kokku puutunud,
         väga algelised põhimõtted on enam-vähem, kuid detailselt on kehvad lood.
         Kontoplaanis on mitu erinevat KM kontot - aktivapoolel on "Sisendkäibemaks" ja "Käibemaksu ettemaks",
         passivapoolel "Müügikäibemaks" ( võlad ).

         1. Kui mul tuleb sisse mingi ostuarve, kas siis suureneb "Sisendkäibemaks"?
         Ja kui olen käibemaksudeklaratsiooni ära teinud, siis kannan selle summa "Käibemaksu ettemaksu" kontole?
         2. Kui on müügiarve, siis suureneb "Müügikäibemaks". Kui selle ära deklareerin,
         siis maksan summa maksuametile ja konto läheb jälle nulli. On nii?
         Kui on nii ostuarve kui müügiarve, kuidas siis teha?

         -----------------------------------------------------

         Re: Käibemaksu kontod
         Maksuametile tuleb tasuda müügikäibemaksu ja ostukäibemaksu vahe.Kui teed müüki siis:
         K tulu 1000
         K müügikäibemaks 180
         D ostja võlg 1180

         Kui saad ostuarve siis:
         D kulu 500
         D sisendkäibemaks 90
         K võlg tarnijale 590

         Seega maksuametile tuleb tasuda 180-90=90

         -----------------------------------------------------


       }

      add('  vat_account_id_s  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');  //  Müügikäibemaks
      add('  vat_account_id_i  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');  //  Sisendkäibemaks
      add('  vat_account_id_p  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');  //  Käibemaksu ettemaks ?

      //add('  country_code '+__MapCharType(2)+' NOT NULL DEFAULT '''+estbk_types.CDefaultCountry+''','); // COMMENT: hetkel vaikimisi maa eesti
      // 06.04.2011 Ingmar
      add('  vat_code ' + __MapVarcharType(15) + ' NOT NULL DEFAULT '''',');
      add('  country_code ' + __MapCharType(3) + ' NOT NULL DEFAULT ' + QuotedStr(Cglob_DefaultCountryCodeISO3166_1) + ',');
      add('  valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'','); // COMMENT: kui false, siis ei tohi seda käibemaksu enam kasutada !!!


      // 05.12.2009 Ingmar
      // vaikimisi käibemaks ! meil ntx 20%
      add('  defaultvat boolean DEFAULT ''f'',');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // viitab aluskirjele
      add('  base_rec_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scVAT, tmpBfr);
      self.__addConstraint(__scVAT, tmpBfr);
      add(')');
      FTableDefs[__scVAT] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // COMMENT: erinevat tüüpi laekumiste failid pankadest; tuleb formaadid leida ...
      // @@26:
      Clear;
      add('create table ' + CTable_names[__scincomings_sessions]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scincomings_sessions) + ',');
      add('  session_name ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      // 18.02.2010 Ingmar
      add('  filename ' + __MapVarcharType(512) + ' NOT NULL DEFAULT '''',');
      //add('  accounting_register_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
      //add('  reserved1 '+__MapVarcharType(512)+' NOT NULL DEFAULT '''',');
      //add('  reserved2 '+__MapIntType()+' NOT NULL,');
      add('  type_ ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');  // tüüp; reserveeritud
      add('  created  ' + __MapdateTimeVariable() + '  NULL ,'); // COMMENT: millal lõpuks reaalselt kiri ära saadeti
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0'); // COMMENT: millise firma alt failid konverteeriti

      // mod stat
      self.__addModFooter(__scincomings_sessions, tmpBfr);
      self.__addConstraint(__scincomings_sessions, tmpBfr);
      add(')');
      FTableDefs[__scincomings_sessions] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // COMMENT: erinevat tüüpi laekumiste failid pankadest; tuleb formaadid leida ...
      // @@27:
      Clear;
      add('create table ' + CTable_names[__scincomings_bank]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scincomings_bank) + ',');
      add('  incomings_session_id  ' + __MapIntType() + '  NOT NULL,');
      // 30.12.2010 Ingmar
      add('  client_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  bank_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  bank_code ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''','); // +BIC kui vaja
      add('  bank_archcode ' + __MapVarcharType(128) + ' NOT NULL DEFAULT '''',');    // COMMENT: arhiveerimistunnus
      add('  bank_rec_status ' + __MapVarcharType(128) + ' NOT NULL DEFAULT '''',');  // COMMENT: täiendav märgend, vastavalt pangale
      add('  bank_op_code ' + __MapVarcharType(128) + ' NOT NULL DEFAULT '''',');     // COMMENT: pank, tehingutüüp
      add('  payer_name ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  payer_refnumber ' + __MapVarCharType(30) + ' NOT NULL DEFAULT '''',');
      // COMMENT: üldiselt meie süsteemis on viitenumber 10 kohaline !!! aga pankadest tihti tuleb huvitavat kraami :)
      add('  payer_mk_nr ' + __MapVarcharType(20) + ' NOT NULL DEFAULT '''','); // COMMENT: reserveeritud, erinevad failide formaadid
      add('  payment_sum ' + __MapMoneyType + ' NOT NULL,'); // COMMENT: laekunud summa...
      // reaalsuses seda pole, aga selgitust parsides võime selle leida juurde
      add('  nr ' + __MapVarcharType(35) + ' NOT NULL DEFAULT '''',');
      add('  state_treasury_refnr ' + __MapVarcharType(30) + ' NOT NULL DEFAULT '''',');
      add('  receiver_account_number' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  receiver_account_number_iban' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  payment_date ' + __MapDateVariable + ' NOT NULL,');
      add('  payer_code ' + __MapVarcharType(30) + ' NOT NULL DEFAULT '''',');
      add('  description ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  bank_description ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''','); // COMMENT: selgitavad read panga poolt ? sõltub formaadist
      add('  incoming_date ' + __MapDateVariable + ' NOT NULL,'); // COMMENT: millal laekus, st millal kasvõi tulid failid ja konverteeriti
      // 27.06.2010 ingmar
      add('  bank_account ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  bank_account_iban ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');

      //add('  account_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
      // 06.12.2010 Ingmar
      add('  bank_bk_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      add('  currency ' + __MapCharType(3) + ' NOT NULL DEFAULT ''' + getDefaultCurrency + ''',');
      add('  currency_drate_ovr ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // daily rate !

      // add('  incoming_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
      add('  reserved1 ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');  // TODO

      // 30.08.2011 Ingmar
      add('  service_charges ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00''');

      // mod stat
      self.__addModFooter(__scincomings_bank, tmpBfr);
      self.__addConstraint(__scincomings_bank, tmpBfr);
      add(')');
      FTableDefs[__scincomings_bank] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@28:
      Clear;
      add('create table ' + CTable_names[__scwarehouse]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scwarehouse) + ',');
      add('  code ' + __MapVarCharType(20) + ' NOT NULL DEFAULT '''',');
      // COMMENT: osadel firmadel on nö mitu ladu ühes hoones ja orienteerutakse koodide abil
      add('  name ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  vatnumber ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      // add('  address '+__MapVarcharType(512)+' NOT NULL DEFAULT '''',');
      add('  countrycode ' + __MapCharType(3) + ' NOT NULL DEFAULT ' + QuotedStr(Cglob_DefaultCountryCodeISO3166_1) + ',');
      add('  county_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  city_id ' + __MapIntType() + ' NOT NULL  DEFAULT 0,');
      add('  street_id ' + __MapIntType() + '  NOT NULL  DEFAULT 0,');
      add('  house_nr ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''','); // COMMENT: võib olla pikk talunimi !!!
      add('  apartment_nr ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');

      // 13.02.2010 Ingmar
      add('  zipcode ' + __MapVarcharType(15) + ' NOT NULL DEFAULT '''',');
      add('  phone ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  mobile ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''',');
      add('  email ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');

      // 13.02.2010 Ingmar
      add('  postal_addr ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  head ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''','); // COMMENT: info sellekohta, millal ladu avatud
      // add('  head_id '+__MapIntType()+' NOT NULL DEFAULT 0,'); // COMMENT: (töötaja id) lao juhataha/asetäitja jne
      add('  opening_times ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''','); // COMMENT: info sellekohta, millal ladu avatud
      add('  descr ' + __MapLongText + ' NOT NULL DEFAULT '''',');
      // 13.12.2009 Ingmar;
      add('  price_calc_meth ' + __MapCharType(1) + ' NOT NULL DEFAULT ''A'','); // A-avarage keskmine
      // tulukonto ja kulukonto; Revenue Account
      add('  charge_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  revenue_account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      add('  reserved1 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0'); // COMMENT: millise firma ladu
      // mod stat
      self.__addModFooter(__scwarehouse, tmpBfr);
      self.__addConstraint(__scwarehouse, tmpBfr);
      add(')');
      FTableDefs[__scwarehouse] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // @@29:
      Clear;
      add('create table ' + CTable_names[__scinventory]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scinventory) + ',');
      add('  warehouse_id ' + __MapIntType() + ' NOT NULL,');
      add('  article_id ' + __MapIntType() + ' NOT NULL,');
      add('  current_quantity ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scinventory, tmpBfr);
      self.__addConstraint(__scinventory, tmpBfr);
      add(')');
      FTableDefs[__scinventory] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // 26.12.2009 Ingmar; dokumendid, mille alusel erinevad liikumised toimunud
      Clear;
      add('create table ' + CTable_names[__scinventory_documents]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scinventory_documents) + ',');
      add('  inventory_id ' + __MapIntType() + ' NOT NULL,');
      //add('  article_price_id '+__MapIntType()+' NOT NULL,');
      add('  price  ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      add('  document_id ' + __MapBigIntType() + ' NOT NULL,');
      add('  quantity  ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT ''''');
      // mod stat
      self.__addModFooter(__scinventory_documents, tmpBfr);
      self.__addConstraint(__scinventory_documents, tmpBfr);
      add(')');
      FTableDefs[__scinventory_documents] := tmpBfr.Text;




      // --------------------------------------------------------------------

      // @@31: COMMENT: teavitussüsteem, kui midagi hakkab lõppema ! tegin universaalsemaks
      Clear;
      add('create table ' + CTable_names[__scemail_notifier]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scemail_notifier) + ',');
      add('  notication_ruleset ' + __MapVarcharType(2000) + ' NOT NULL DEFAULT '''',');
      add('  start ' + __MapdateTimeVariable() + ' NULL DEFAULT ' + __DefaultDate() + ',');
      // kui ntx 1980-01-01 aga aeg on; > 09:00 siis tähendab alates kella 9 saata
      add('  stop  ' + __MapdateTimeVariable() + ' NULL,');
      add('  emails ' + __MapVarcharType(300) + ' NOT NULL DEFAULT '''','); // COMMENT: keda teavitada
      add('  intv ' + __MapSmallIntType() + '  NOT NULL DEFAULT 0,'); // COMMENT: kui tihti teavitust kordame !
      //add('  minamount  '+__MapIntType()+' NOT NULL,'); // COMMENT: kogus, millest alates hakatakse teavitama
      add('  item_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  type_ ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT ''''');
      // mod stat
      self.__addModFooter(__scemail_notifier, tmpBfr);
      self.__addConstraint(__scemail_notifier, tmpBfr);
      add(')');
      FTableDefs[__scemail_notifier] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@32:
      Clear;
      add('create table ' + CTable_names[__scemail_notifier_sessions]);
      add('(');
      add('  notification_id ' + __MapIntType() + ' NOT NULL,');
      add('  email_id ' + __MapIntType() + ' NOT NULL');
      //add('  sentdate '+__MapdateTimeVariable()+' NOT NULL DEFAULT '+__DefaultDate()+',');
      //add('  emsg '+__MapVarcharType(1024)+' NOT NULL DEFAULT ''''');
      self.__addConstraint(__scemail_notifier_sessions, tmpBfr);
      add(')');
      FTableDefs[__scemail_notifier_sessions] := tmpBfr.Text;

      // --------------------------------------------------------------------
{
        // @@33:
        clear;
        add('create table '+CTable_names[__scassetgroup]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scassetgroup)+',');
        add('  name '+__MapVarcharType(255)+' NOT NULL DEFAULT '''',');
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0');
        // mod stat
        self.__addModFooter(__scassetgroup,tmpBfr);
        self.__addConstraint(__scassetgroup,tmpBfr);
        add(')');
        FTableDefs[__scassetgroup]:=tmpBfr.Text;

        // --------------------------------------------------------------------
        // @@34:
        // TÄPSUSTADA !!!
        clear;
        add('create table '+CTable_names[__scassets]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scassets)+',');
        add('  asset_group_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  b_bill_id '+__MapIntType()+'  NOT NULL DEFAULT 0,');   // COMMENT: varaga seotud ostuarve
        add('  s_bill_id '+__MapIntType()+'  NOT NULL DEFAULT 0,');   // COMMENT: kui mahakantud vara müüdi maha
        add('  contract_id '+__MapIntType()+' NOT NULL DEFAULT 0,'); // COMMENT: reserveeritud;
        add('  source_document_id '+__MapBigIntType()+' NOT NULL,');    // COMMENT: ostudokument;  skänneeritud dokument jne jne
        add('  asset_name '+__MapVarcharType(512)+' NOT NULL DEFAULT '''',');
        add('  asset_number '+__MapVarcharType(25)+' NOT NULL DEFAULT '''',');
        add('  asset_descr '+__MapLongText()+' NOT NULL DEFAULT '''',');
        add('  asset_location '+__MapVarcharType(512)+' NOT NULL DEFAULT '''','); // COMMENT: kus vara paikneb; ntx firma aadress või isiku nimi jne
        add('  fixed_asset '+__MapModBoolean()+' NOT NULL DEFAULT ''t'','); // COMMENT: enamus kandeid ongi põhovara !!!!!!!
        add('  acquisition_cost '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'',');         // COMMENT: soetamisväärtus
        add('  acquisition_date '+__MapDateVariable+' NOT NULL DEFAULT '+__DefaultDate()+','); // COMMENT: millal ostetud või saabunud antud vara
        add('  procurer_id '+__MapIntType()+' NOT NULL DEFAULT 0,');   // COMMENT: vara soetaja/hankija; kusagilt pidi tekkima, keegi pidi seotama
        add('  supervisor_id '+__MapIntType()+' NULL DEFAULT 0,'); // COMMENT: vastutaja, kellele antud kasutada
        add('  amortization_perc '+__MapPercType()+'  NOT NULL DEFAULT 0,');
        add('  amortization_algorithm_nr smallint  NOT NULL DEFAULT 0,');
        add('  residual_value '+__MapMoneyType+' NOT NULL DEFAULT ''0.00'','); // COMMENT: jääkväärtus
        // COMMENT: mahakandmise info
        add('  written_off '+__MapModBoolean()+' NOT NULL DEFAULT ''f'',');
        add('  written_off_date '+__MapDateVariable+' NULL ,');
        add('  written_off_reason '+__MapLongText()+' NOT NULL DEFAULT '''','); // COMMENT: (soovituslik) ntx auto sõideti sodiks...jne jne
        add('  written_off_document_id '+__MapBigIntType()+' NOT NULL DEFAULT 0,');           // COMMENT: alusdokument, mille alusel vara mahakirjutamine toimus
        add('  archive_rec_id '+__MapIntType()+'  NOT NULL DEFAULT 0,');                    // COMMENT: selleks on kõige esimese kirje ID, mis kandub aina edasi, mille põhjal saab ajalugu vaadata
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0');
        // mod stat
        self.__addModFooter(__scassets,tmpBfr);
        self.__addConstraint(__scassets,tmpBfr);
        add(')');
        FTableDefs[__scassets]:=tmpBfr.Text;
}
      // --------------------------------------------------------------------

      Clear;
      add('create table ' + CTable_names[__scdocument_tree_nodes]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scdocument_tree_nodes) + ',');
      add('  parent_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  node_name ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  weight ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ntx dokumenti õigused; permission matrix ID
      add('  permission_mtx_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ntx dokumenti õigused; permission matrix ID
      // ---
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // D kustutatud !
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scdocument_tree_nodes, tmpBfr);
      self.__addConstraint(__scdocument_tree_nodes, tmpBfr);
      add(')');
      FTableDefs[__scdocument_tree_nodes] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@36:
      Clear;
      add('create table ' + CTable_names[__scdocuments]);
      add('(');
      add('  id ' + __MapBigIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scdocuments) + ',');
      // 06.12.2009 Ingmar; ettevalmistus dokumendihalduse tarbeks
      add('  document_tree_node_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  permission_mtx_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ntx dokumenti õigused; permission matrix ID
      // COMMENT: ntx dokumendid: maksekorraldus; AR: arve; OA: ostuarve...
      // kõik sõltub, kuidas kasutaja selle defineerib; antud dokument on rohkem firmasisene
      add('  document_nr ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''',');
      // ntx mingi väline dokument;
      add('  document_nr2 ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''',');

      add('  document_date ' + __MapDateVariable + ' NOT NULL DEFAULT ' + __DefaultDate() + ',');
      add('  document_type_id   ' + __MapIntType() + ' NOT NULL DEFAULT 0,');        // klassifikaatoritest
      add('  sdescr ' + __MapLongText() + ' NOT NULL DEFAULT '''',');
      // ---
      // 07.12.2010 Ingmar
      add('  valid_from ' + __MapDateVariable + ' NULL,');
      add('  valid_until ' + __MapDateVariable + ' NULL,');

      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // D kustutatud !
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ntx kas dokument on indekseeritud

      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scdocuments, tmpBfr);
      self.__addConstraint(__scdocuments, tmpBfr);
      add(')');
      FTableDefs[__scdocuments] := tmpBfr.Text;

      // dokumenti staatused !!! lisada !!!

      // --------------------------------------------------------------------
      // @@37:
      Clear;
      add('create table ' + CTable_names[__scdocument_files]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scdocument_files) + ',');
      add('  document_id ' + __MapBigIntType() + '  NOT NULL,');
      add('  rec_nr ' + __MapSmallIntType() + '  NOT NULL DEFAULT 1,');
      // COMMENT: postgrele ei meeldi order sõna...parem ei kasuta, muidu hiljem kantsulud ja muu jama
      add('  filename ' + __MapVarcharType(1024) + ' NOT NULL DEFAULT '''',');
      add('  size ' + __MapBigIntType() + ' NOT NULL DEFAULT 0,');
      add('  md5 ' + __MapVarcharType(50) + ' NOT NULL DEFAULT '''',');
      add('  rawdoc ' + __MapBlobField() + ' NOT NULL,');
      add('  type_ ' + __MapVarcharType(10) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scdocument_files, tmpBfr);
      self.__addConstraint(__scdocument_files, tmpBfr);
      add(')');
      FTableDefs[__scdocument_files] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@38: COMMENT: andmeväljade nimed
      Clear;
      add('create table ' + CTable_names[__scdocumentfield_data_labels]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scdocumentfield_data_labels) + ',');
      add('  label ' + __MapVarcharType(512) + ' NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scdocumentfield_data_labels, tmpBfr);
      add(')');
      FTableDefs[__scdocumentfield_data_labels] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@39: COMMENT: dokument võib sisaldada N + 1 välja
      Clear;
      add('create table ' + CTable_names[__scdocumentfield_values]);
      add('(');
      add('  document_id ' + __MapBigIntType() + ' NOT NULL,');
      add('  datalabel_id  ' + __MapIntType() + ' NOT NULL,');       // COMMENT: väljanimi; ntx lepingunr
      add('  val_as_shortdata ' + __MapVarcharType(512) + ' NULL DEFAULT '''',');  // COMMENT: ntx: ostja nimi;st document_field_id
      add('  val_as_longdata ' + __MapLongText() + ' NULL DEFAULT '''',');
      Add('  val_type ' + __MapSmallIntType() + '  NOT NULL DEFAULT 0,'); // COMMENT: hetkel me ei kasuta andmetüüpi !
      add('  archive_rec_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      // COMMENT: selleks on kõige esimese kirje ID, mis kandub aina edasi, mille põhjal saab ajalugu vaadata
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      //self.__addModFooter(__scdocumentfield_values,tmpBfr);
      self.__addConstraint(__scdocumentfield_values, tmpBfr);
      add(')');
      FTableDefs[__scdocumentfield_values] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@40: COMMENT: kliendi dokumendid; dokumendihaldus !
      Clear;
      add('create table ' + CTable_names[__scclient_documents]);
      add('(');
      add('  document_id ' + __MapBigIntType() + ' NOT NULL,');
      add('  client_id ' + __MapIntType() + ' NOT NULL,');
      add('  id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // COMMENT: arve hetkel võib puududa
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      // self.__addModFooter(__scclient_documents,tmpBfr);
      self.__addConstraint(__scclient_documents, tmpBfr);
      add(')');
      FTableDefs[__scclient_documents] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@41:
        (*
        clear;
        add('create table '+CTable_names[__scaccountgroup]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scaccountgroup)+',');
        add('  name '+__MapVarcharType(255)+' NOT NULL DEFAULT '''','); // COMMENT: ntx: Varad, Võlad, Tulud jne
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0');
        // mod stat
        self.__addModFooter(__scaccountgroup,tmpBfr);
        self.__addConstraint(__scaccountgroup,tmpBfr);
        add(')');
        FTableDefs[__scaccountgroup]:=tmpBfr.Text;
        *)

      // --------------------------------------------------------------------
      // @@42: COMMENT: raamatupidamiskontod
      Clear;
      add('create table ' + CTable_names[__scaccounts]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scaccounts) + ',');
      //add('  account_group_id '+__MapIntType()+'  NOT NULL DEFAULT 0,');
      // 07.02.2010 Ingmar; muutsin 20 peale
      //add('  account_coding '+__MapCharType(8)+' NOT NULL DEFAULT ''10000000'',');

      add('  account_coding ' + __MapVarCharType(20) + ' NOT NULL DEFAULT ''1'',');
      add('  account_name ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      // COMMENT: ntx Osakapital nimiväärtuses, Tulud teenuste müügist, Rendikulu

      add('  init_balance ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // 02.09.2009 ingmar; konto algseis
      add('  curr_balance ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // reserveeritud



      // ------ väike disaini apsakas, oleks võinud mõistlikumad väljanimed anda !
      //add('  classificator_type_id  '+__MapIntType()+'  NOT NULL DEFAULT 0,'); // üld/detailne/koond
      add('  type_id  ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      // !!! kontotyyp !!! Aktivakontod, Passivakontod, Tulemuskonto classificators->"account_type"
      add('  typecls_id  ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      // !!! klassifikaator !!! üld, detailne jne                    classificators->""account_classificator""

      // 17.02.2011 Ingmar
      add('  balance_rep_line_id  ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      add('  incstat_rep_line_id  ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      add('  reserved2  ' + __MapIntType() + '  NOT NULL DEFAULT 0,');


      add('  default_currency ' + __MapCharType(3) + ' NOT NULL DEFAULT ''' + getDefaultCurrency + ''',');
      //add('  department_id  '+__MapIntType()+' NOT NULL DEFAULT 0,'); // osakond
      add('  parent_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // bit tüüpi tunnused, mis kirjeldavad ära konto tunnused; ntx objekt kohustuslik jne jne
      // otseselt selle järgi programm päringuid ei tee
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'',');
      // COMMENT: sellega saab konto kasutamise ära keelata, teda ei tule valikutesse !!
      // 05.03.2010 Ingmar; Siiski tuleb ka pangakontoda raamatupidamiskonto siduda

      // ntx; swedpank EEK;
      add('  bank_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  account_nr ' + __MapVarcharType(45) + ' NOT NULL  DEFAULT '''',');
      add('  account_nr_iban ' + __MapVarcharType(45) + ' NOT NULL  DEFAULT '''',');

      // kas arvel kuvada
      add('  display_onbill ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'','); // 05.03.2010 ingmar; false !!!!!!!!
      // millistel siis
      add('  display_billtypes ' + __MapVarCharType(20) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scaccounts, tmpBfr);
      self.__addConstraint(__scaccounts, tmpBfr);
      add(')');
      FTableDefs[__scaccounts] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@43: COMMENT: raamatupidamiskirjendid
      Clear;
      add('create table ' + CTable_names[__scaccounting_register]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scaccounting_register) + ',');
      add('  accounting_period_id ' + __MapIntType() + '  NOT NULL,'); // COMMENT: raamatupidamisperioodi_id
      add('  entrynumber ' + __MapVarcharType(20) + ' NOT NULL,'); // COMMENT: raamatupidamiskirjendi number !!!!!!
      add('  transdescr ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      //  COMMENT: lausend: huvitav, kas ei peaks võimaldama eeldefineeritud lausendeid
      add('  transdate  ' + __MapdateVariable() + ' NOT NULL DEFAULT ' + __DefaultDate() + ',');// COMMENT: 17.08.2009 Ingmar tehingu toimumise kuupäev
      add('  type_  ' + __MapCharType(2) + ' NOT NULL DEFAULT ''G'',');   // COMMENT: G pearaamatu kanne
      add('  archive_rec_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      // COMMENT: kui tühistatud, seotakse see tühistava või korrigeeritud kirjendiga...
      add('  reserved1 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // 03.08.2010 Ingmar; linkedto_id
      add('  linkedto_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // 28.08.2010 ingmar
      add('  template ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  template_name ' + __MapVarcharType(35) + ' NOT NULL DEFAULT '''',');
      // 28.09.2009 Ingmar
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // mod stat
      self.__addModFooter(__scaccounting_register, tmpBfr);
      self.__addConstraint(__scaccounting_register, tmpBfr);
      add(')');
      FTableDefs[__scaccounting_register] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@44: COMMENT: sissekandega seotud dokumendid; tavaliselt 1; jätame võimaluse N tükki
      Clear;
      add('create table ' + CTable_names[__scaccounting_register_documents]);
      add('(');
      add('  accounting_register_id  ' + __MapIntType() + ' NOT NULL,');
      add('  document_id ' + __MapBigIntType() + ' NOT NULL');
      // mod stat
      self.__addModFooter(__scaccounting_register_documents, tmpBfr);
      self.__addConstraint(__scaccounting_register_documents, tmpBfr);
      add(')');
      FTableDefs[__scaccounting_register_documents] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@45: COMMENT: kirjendiga seotud konteerimine
      Clear;
      add('create table ' + CTable_names[__scaccounting_records]);
      add('(');
      add('  id ' + __MapBigIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scaccounting_records) + ',');
      add('  accounting_register_id ' + __MapIntType() + ' NOT NULL,');

      //add('  D_account_id '+__MapIntType()+'  NOT NULL,');  // COMMENT: deebetkonto
      //add('  C_account_id '+__MapIntType()+'  NOT NULL,');  // COMMENT: krediitkonto
      add('  account_id ' + __MapIntType() + '  NOT NULL,');
      add('  descr ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');

      add('  rec_nr ' + __MapSmallIntType() + '  NOT NULL DEFAULT 0,'); // COMMENT: nö sisestatud raamatupidamiskirjendite originaal järjekord
      add('  rec_sum   ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');  // COMMENT: tehingu summa
      add('  rec_type  ' + __MapCharType(1) + ' NOT NULL DEFAULT ''D'',');   // COMMENT: summa tyyp: d/k


      // 09.11.2009 Ingmar; tehingupartner/klient/osapool; kui baasis olemas, siis
      add('  client_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      // kui sellist klienti pole baasis ning ei soovita ka lisada, siis kirjutatakse see nimi siia tekstiväljale !
      add('  tr_partner_name ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');

      add('  currency ' + __MapCharType(3) + '  NOT NULL DEFAULT  ''' + getDefaultCurrency + ''',');
      add('  currency_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // 16.03.2010 Ingmar; et ikka reaalne kurss olemas !!!
      add('  currency_vsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      add('  currency_drate_ovr ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'','); // daily rate !

      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // COMMENT: reserveeritud
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  archive_rec_id ' + __MapBigIntType() + ' NOT NULL DEFAULT 0,');
      // crossreference !
      // kanderida seotud konkreetse arve või tellimusega ! ntx tasumine / laekumine / ettemaks
      add('  ref_item_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  ref_item_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      // 28.08.2010 Ingmar; sõltub reziimist
      add('  ref_prepayment_flag ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  ref_payment_flag ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  ref_income_flag ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  ref_debt_flag ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  ref_tax_flag ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');

      add('  reserved1 ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  reserved2 ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');

      // ntx arvel võetakse peale ettemaks, siis viitame, millise ettemaksu kanderida me kasutasime selle arve jaoks
      //add('  ref_prepayment_accrec_id '+__MapBigIntType()+' NOT NULL DEFAULT 0,');

      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // 18.07.2011 Ingmar
      add('  billnrs ' + __MapVarCharType(1024) + ' NOT NULL DEFAULT ''''');
      // mod stat
      self.__addModFooter(__scaccounting_records, tmpBfr);
      self.__addConstraint(__scaccounting_records, tmpBfr);
      add(')');
      FTableDefs[__scaccounting_records] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@46: COMMENT: konteeringu kirje laiendus, mis võib erinevat infot sisaldada
      Clear;
      add('create table ' + CTable_names[__scaccounting_rec_attrb]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scaccounting_rec_attrb) + ',');
      add('  accounting_record_id  ' + __MapBigIntType() + ' NOT NULL,');
      add('  attrib_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');     // - sisuliselt seosetüüp "objektid" O; "firmad" C; jne...
      add('  attrib_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  attrib_val ' + __MapVarcharType(512) + ' NOT NULL DEFAULT '''''); // midagi, mis pole standardselt kirjeldatud
      self.__addModFooter(__scaccounting_rec_attrb, tmpBfr);
      self.__addConstraint(__scaccounting_rec_attrb, tmpBfr);
      add(')');
      FTableDefs[__scaccounting_rec_attrb] := tmpBfr.Text;

      // --------------------------------------------------------------------
      Clear;
      add('create table ' + CTable_names[__scaccounting_prepayment_usage]);
      add('(');
      add('  accounting_src_record_id  ' + __MapBigIntType() + ' NOT NULL,');
      add('  accounting_dest_record_id  ' + __MapBigIntType() + ' NOT NULL,');
      // millise elemendiga ettemaks seoti; summat pole mõtet dubleerida, selle saab accounting_dest_record_id pealt !
      add('  item_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  item_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scaccounting_prepayment_usage, tmpBfr);
      self.__addConstraint(__scaccounting_prepayment_usage, tmpBfr);
      add(')');
      FTableDefs[__scaccounting_prepayment_usage] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // @@47: COMMENT: tööleping; üldiselt tulevikus tekib toetus, hetkel reserveerime struktuuri
        (*
        clear;
        add('create table '+CTable_names[__scemployment_contract]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scemployment_contract)+',');
        add('  contr_number '+__MapVarcharType(55)+' NOT NULL DEFAULT '''',');
        add('  contr_date '+__MapDateVariable+' NOT NULL DEFAULT '+__DefaultDate()+',');   // COMMENT: töölepingu sõlmimise kuupäev
        add('  contr_ppersonalcode '+__MapIntType()+' NOT NULL DEFAULT 0,');   // COMMENT: isikukood
        add('  contr_person '+__MapVarcharType(75)+' NOT NULL DEFAULT '''',');        // COMMENT: kellega leping sõlmiti
        add('  contr_person_addr '+__MapVarcharType(255)+' NOT NULL DEFAULT '''',');  // COMMENT: töötaja elukoht
        add('  contr_person_phone '+__MapVarcharType(120)+' NOT NULL DEFAULT '''',');
        add('  contr_person_email '+__MapVarcharType(255)+' NOT NULL DEFAULT '''',');
        add('  contr_begins '+__MapDateVariable+' NOT NULL DEFAULT '+__DefaultDate()+','); // COMMENT: mis hetkest kehtib
        add('  contr_ends '+__MapDateVariable+' NULL ,'); // COMMENT: kui täitmata, siis tähtajatu
        add('  contr_cperson '+__MapVarcharType(75)+' NOT NULL DEFAULT '''','); // COMMENT: isik, kes sõlmis selle töölepingu; juhtivtöötaja, pensonaliosakond jne jne
        add('  contr_status '+__MapVarcharType(2)+' NOT NULL DEFAULT ''A'',');   //  COMMENT: A  - active; ehk tööleping kehtib
                                                                                 //           E  - ended;
                                                                                 //           T  - temporary ehk tähtajaline
                                                                                 //           TE - temporary ended; ntx raseduspuhkus
        add('  archive_rec_id '+__MapIntType()+'  NOT NULL DEFAULT 0,');         //  töölepingute arhiivi alus
        add('  reserved1 '+__MapIntType()+' NOT NULL DEFAULT 0,');

        add('  picture '+__MapBlobField()+' NULL,'); // inimese pilt
        add('  signature_pict '+__MapBlobField()+' NULL,'); // allkirja pilt
        add('  company_id  '+__MapIntType()+' NOT NULL DEFAULT 0');
        // mod stat
        self.__addModFooter(__scemployment_contract,tmpBfr);
        self.__addConstraint(__scemployment_contract,tmpBfr);
        add(')');
        FTableDefs[__scemployment_contract]:=tmpBfr.Text;
        *)

      // --------------------------------------------------------------------
        {
        clear;
        // 21.10.2009
        add('create table '+Ctable_names[__scarticles_accounts]);
        add('(');
        add('  article_id '+__MapBigIntType()+' NOT NULL,');
        add('  account_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  type_ '+__MapCharType(2)+' NOT NULL DEFAULT ''''');
        // mod stat
        self.__addModFooter(__scarticles_accounts,tmpBfr);
        self.__addConstraint(__scarticles_accounts,tmpBfr);
        add(')');
        FTableDefs[__scarticles_accounts]:=tmpBfr.Text;
        }
      // --------------------------------------------------------------------
      // @@48: COMMENT: kasutajad;
      Clear;
      add('create table ' + CTable_names[__scusers]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scusers) + ',');
      add('  loginname ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''','); // COMMENT: peab olema täpselt sama, mis andmebaasis logimisel !
      add('  regnr_personalcode ' + __MapIntType() + ' NOT NULL DEFAULT 0,');   // COMMENT: isikukood
      add('  name ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''','); // COMMENT: laiendatud nimi; kui eraisik, siis eesnimi muidu firma nimetus
      add('  middlename ' + __MapVarcharType(55) + ' NOT NULL DEFAULT '''',');
      add('  lastname ' + __MapVarcharType(65) + ' NOT NULL DEFAULT '''',');
      add('  position  ' + __MapVarcharType(45) + ' NOT NULL DEFAULT '''',');
      add('  phone ' + __MapVarcharType(120) + ' NOT NULL DEFAULT '''',');
      add('  email ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      add('  employment_contract_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');   // COMMENT: töölepingu id
      // 04.01.2010 Ingmar; osakonnad on objekti tüübiga
      add('  division_object_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  lastlogin ' + __MapdateTimeVariable() + ' NULL,');
      add('  fromIP ' + __MapVarcharType(40) + ' NULL,'); // COMMENT: oleme valmis juba IPV6 jaoks !!!
      add('  allowlogin ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'','); // COMMENT: sellega saab ajutiselt logimise keelata
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      add('');
      // mod stat
      self.__addModFooter(__scusers, tmpBfr);
      self.__addConstraint(__scusers, tmpBfr);
      add(')');
      FTableDefs[__scusers] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@49: COMMENT: kasutajad; hetkel dubleerime;  sest tööleping võib puududa !!
      Clear;
      add('create table ' + CTable_names[__scuser_permission_descr]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scuser_permission_descr) + ',');
      add('  system_alias ' + __MapCharType(3) + ' NULL,'); // COMMENT: selle genereerib süsteem automaatselt; suudame kergemini õigusi töödelda
      add('  description ' + __MapVarcharType(255) + ' NOT NULL,');
      add('  type_ ' + __MapCharType(1) + ' NOT NULL DEFAULT ''O'',');
      // COMMENT: - P avab mingi programmi funktsionaalsuse; / O ordinary - mingi tavaline õigus funktsionaalsuse avamiseks
      add('  valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'''); // COMMENT: on võimalus terve õigus tühistada / kasvõi igaveseks
      self.__addConstraint(__scuser_permission_descr, tmpBfr);
      add(')');
      FTableDefs[__scuser_permission_descr] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@50: COMMENT: rollid
      Clear;
      add('create table ' + CTable_names[__scrole]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scrole) + ',');
      add('  role_name ' + __MapVarCharType(255) + ' NOT NULL');
      self.__addConstraint(__scrole, tmpBfr);
      add(')');
      FTableDefs[__scrole] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@51: COMMENT: rollidega seotud õigused
      Clear;
      add('create table ' + CTable_names[__scrole_permissions]);
      add('(');
      add('  role_id ' + __MapIntType() + '  NOT NULL DEFAULT 0,');
      add('  permission_descr_id' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scrole_permissions, tmpBfr);
      add(')');
      FTableDefs[__scrole_permissions] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@52:
      Clear;
      add('create table ' + CTable_names[__scrole_userroles]);
      add('(');
      add('  role_id ' + __MapIntType() + '  NOT NULL,');
      add('  user_id' + __MapIntType() + ' NOT NULL,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // COMMENT: jätame võimaluse, et saab ka firma põhiselt jagada rolle; ühes firmas kehtib üks / teises teine
      self.__addConstraint(__scrole_userroles, tmpBfr);
      add(')');
      FTableDefs[__scrole_userroles] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // @@53: COMMENT: kasutajad; hetkel dubleerime;  sest tööleping võib puududa !!
      Clear;
      add('create table ' + CTable_names[__scuser_permissions]);
      add('(');
      add('  user_id ' + __MapIntType() + '  NOT NULL,');
      add('  permission_descr_id' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  descriptors ' + __MapVarcharType(5) + ' NOT NULL,'); // ntx täiendab õigust, et ainult lugemiseks jne jne
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scuser_permissions, tmpBfr);
      add(')');
      FTableDefs[__scuser_permissions] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // 13.04.2011 Ingmar; per kasutaja salvestame seaded !
      Clear;
      add('create table ' + CTable_names[__scuser_settings]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scuser_settings) + ',');
      add('  user_id ' + __MapIntType() + '  NOT NULL,');
      add('  item_name ' + __MapVarcharType(15) + ' NOT NULL,');
      add('  item_value ' + __MapVarcharType(255) + ' NOT NULL,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scuser_settings, tmpBfr);
      add(')');
      FTableDefs[__scuser_settings] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // @@54: milliste firmade alt saab kasutaja tööd teha
      Clear;
      add('create table ' + CTable_names[__scuser_company_acclist]);
      add('(');
      add('  user_id ' + __MapIntType() + '  NOT NULL,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL');
      self.__addConstraint(__scuser_company_acclist, tmpBfr);
      add(')');
      FTableDefs[__scuser_company_acclist] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // @@55: COMMENT: erinevad kasutaja konfiguratsiooni muutajd
      // kui user_id = 0 siis on üldine seade !
      Clear;
      add('create table ' + CTable_names[__scconf]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scconf) + ',');
      add('  var_name ' + __MapVarcharType(45) + ' NOT NULL,');
      add('  var_val ' + __MapVarcharType(1024) + ' NOT NULL,');
      add('  var_misc  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  val_blob ' + self.__MapBlobField() + ' NULL,');
      // add('  user_id  '+__MapIntType()+' NOT NULL DEFAULT 0');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scconf, tmpBfr);
      add(')');
      FTableDefs[__scconf] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@56: COMMENT: üldiselt seda tabelit saab ainult DBO õigustega inimene täita ja muuta
      Clear;
      add('create table ' + CTable_names[__scsystemconf]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scsystemconf) + ',');
      add('  var_name ' + __MapVarcharType(45) + ' NOT NULL,');
      add('  var_val ' + __MapVarcharType(1024) + ' NOT NULL,');
      add('  var_misc  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  val_blob ' + self.__MapBlobField() + ' NULL,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL  DEFAULT 0');
      add(')');
      FTableDefs[__scsystemconf] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // @@57: COMMENT:
        {
        695  Svenska Handelsbanken
        699  Vereins- und Westbank
        700  Parex Pank
        741  ERA-PANK
        742  Eesti Krediidipank
        767  Swedbank
        401  SEB Pank
        793  Tallinna Äripank
        798  Marfin Pank Eesti
        801  Nordea Pank
        703  EVEA Pank
        720  Sampo Pank
        721  Eesti Investeerimispank

        http://en.wikipedia.org/wiki/Bank_code
        }
      Clear;
      add('create table ' + CTable_names[__scbanks]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scbanks) + ',');
      add('  name ' + __MapVarcharType(55) + ' NOT NULL,');
      add('  lcode ' + __MapVarcharType(5) + ' NOT NULL  DEFAULT '''','); // localcode
      add('  swift ' + __MapVarcharType(11) + ' NOT NULL  DEFAULT '''','); // http://en.wikipedia.org/wiki/ISO_9362
      //add('  account_nr '+__MapVarcharType(45)+' NOT NULL  DEFAULT '''',');
      //add('  account_nr_iban '+__MapVarcharType(45)+' NOT NULL  DEFAULT '''',');
      //add('  bk_account_id '+__MapIntType()+' NOT NULL  DEFAULT 0,');
      //add('  active '+__MapModBoolean()+' NOT NULL DEFAULT ''t'','); // kas tohib kasutada
      add('  company_id  ' + __MapIntType() + ' NOT NULL  DEFAULT 0');
      self.__addModFooter(__scbanks, tmpBfr);
      self.__addConstraint(__scbanks, tmpBfr);
      add(')');
      FTableDefs[__scbanks] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@58: fiktiivsed objektid; ntx auto; lambipirn; naabrimehe vanaema :)
      // samuti objekt võib olla osakond
      Clear;
      add('create table ' + CTable_names[__scobjects]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scobjects) + ',');
      add('  classificator_id ' + __MapIntType() + ' NOT NULL,');   // tüüp;
      add('  descr ' + __MapVarcharType(512) + ' NOT NULL,');
      add('  descr2 ' + __MapVarcharType(512) + ' NOT NULL DEFAULT '''',');
      add('  subtype ' + __MapCharType(2) + ' NOT NULL DEFAULT '''','); // reserveeritud on tüüp: D - division; osakond
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scobjects, tmpBfr);
      self.__addConstraint(__scobjects, tmpBfr);
      add(')');
      FTableDefs[__scobjects] := tmpBfr.Text;

      // --------------------------------------------------------------------
      // @@59: numeratsioon ükstapuha, milline objekt !! sequence ei sobi selleks 100%
      // jah tõesti bigint MÕTLEME suurelt
      Clear;
      add('create table ' + CTable_names[__scnumerators]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scnumerators) + ',');
      add('  cr_num_val ' + __MapBigIntType() + ' NOT NULL,'); // hetke väärtus nummerdajal
      add('  cr_num_start ' + __MapBigIntType() + 'NOT NULL DEFAULT 1,');
      add('  cr_num_type ' + __MapVarcharType(5) + ' NOT NULL,');
      // saab ka määrata lubatud vahemiku
      add('  cr_vrange_start ' + __MapBigIntType() + 'NOT NULL DEFAULT 0,');
      add('  cr_vrange_end ' + __MapBigIntType() + 'NOT NULL DEFAULT 0,');
      add('  cr_version ' + __MapIntType() + ' NOT NULL DEFAULT 1,');
      add('  cr_valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'','); // ntx tuli uus vahemik, siis eelmine tühistatakse
      add('  cr_srbfr ' + __MapVarcharType(255) + ' NOT NULL DEFAULT '''',');
      // 19.09.2011 Ingmar; ettevalmistus samad rp. numbrid. erinev periood
      add('  accounting_period_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0'); // kui 0, siis on see vaikeseade; tulevikus vaid firmapõhine !
      self.__addModFooter(__scnumerators, tmpBfr);
      self.__addConstraint(__scnumerators, tmpBfr);
      add(')');
      FTableDefs[__scnumerators] := tmpBfr.Text;
      //  [ NOWAIT ]

      // --------------------------------------------------------------------
      // jooksvad valuutakursid; ntx EP CSV lehelt; mingi task või demon teha, kes kursse alla tõmbab ?!?
      Clear;
      add('create table ' + CTable_names[__sccurrency_exc]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__sccurrency_exc) + ',');
      add('  curr_name ' + __MapCharType(3) + ' NOT NULL,');
      add('  curr_date ' + __MapDateVariable() + ','); // kuupäev; sisuliselt millal allatõmmati
      add('  curr_rate ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00'',');
      // jätame võimaluse ntx keegi soovib valuutat muuta !
      add('  valid ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t''');
      self.__addModFooter(__sccurrency_exc, tmpBfr);
      self.__addConstraint(__sccurrency_exc, tmpBfr);
      add(')');
      FTableDefs[__sccurrency_exc] := tmpBfr.Text;

      // --------------------------------------------------------------------
      Clear;
      add('create table ' + CTable_names[__scaccounts_reqobjects]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scaccounts_reqobjects) + ',');
      add('  account_id ' + __MapIntType() + ' NOT NULL,');
      add('  item_id ' + __MapIntType() + ' NOT NULL,');
      add('  type_ ' + __MapCharType(2) + ' NOT NULL DEFAULT ''O'','); // jätame ka võimaluse, et saab määrata X grupp peab eksisteerima
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT ''''');
      self.__addModFooter(__scaccounts_reqobjects, tmpBfr);
      self.__addConstraint(__scaccounts_reqobjects, tmpBfr);
      add(')');
      FTableDefs[__scaccounts_reqobjects] := tmpBfr.Text;


      // --------------------------------------------------------------------
      // ZEOS jaoks vajalik, kui teen Cast(null as boolean) siis pole võimalus programmis seda välja redigeerida
      // sama on ka teist väljadega
      Clear;
      add('create table ' + CTable_names[__scinternal_systemtypes]);
      add('(');
      add('  bint ' + __MapBigIntType() + ' NULL,');
      add('  int4 ' + __MapIntType() + ' NULL,');
      add('  bbool ' + __MapModBoolean() + ' NULL,');
      add('  mtype ' + __MapMoneyType + ' NULL,');
      add('  mdt ' + __MapDateTimeVariable() + '  NULL,');
      add('  ch2 ' + __MapCharType(2) + ' NULL,');
      add('  vchr_255 ' + __MapVarCharType(255) + ' NULL,');
      add('  vchr_512 ' + __MapVarcharType(512) + ' NULL,');
      add('  vchr_1024 ' + __MapVarcharType(1024) + ' NULL,');
      add('  ccblob ' + self.__MapBlobField() + ' NULL');
      add(')');
      FTableDefs[__scinternal_systemtypes] := tmpBfr.Text;



      // --------------------------------------------------------------------
      // 19.04.2010
      Clear;
      add('create table ' + CTable_names[__scdefault_sysaccounts]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scdefault_sysaccounts) + ',');
      add('  ordinal_nr  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  sys_descr ' + __MapVarCharType(255) + ' NULL,');
      add('  account_id ' + __MapIntType() + ' NOT NULL,');
      add('  starts ' + __MapDateVariable() + '  NULL,');
      add('  ends ' + __MapDateVariable() + '  NULL,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0'); // kui 0, siis on see vaikeseade; tulevikus vaid firmapõhine !
      self.__addModFooter(__scdefault_sysaccounts, tmpBfr);
      self.__addConstraint(__scdefault_sysaccounts, tmpBfr);
      add(')');
      FTableDefs[__scdefault_sysaccounts] := tmpBfr.Text;

      // 06.06.2010
      Clear;
      add('create table ' + CTable_names[__scstatus_report]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scstatus_report) + ',');
      add('  code ' + __MapVarCharType(6) + ' NOT NULL,');
      add('  classificator_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ntx kombineeritud aruanne
      add('  misc_data ' + __MapVarCharType(1024) + ' NOT NULL DEFAULT '''','); // ntx sisestatud failinimi
      add('  hdr_data ' + __MapLongText() + ' NULL DEFAULT '''',');
      add('  ftr_data ' + __MapLongText() + ' NULL DEFAULT '''',');
      add('  op_starts ' + __MapDateTimeVariable() + ' NULL,');
      add('  op_ends ' + __MapDateTimeVariable() + ' NULL,');
      add('  status ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  parent_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ntx kombineeritud aruanne
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0'); // kui 0, siis on see vaikeseade; tulevikus vaid firmapõhine !
      self.__addModFooter(__scstatus_report, tmpBfr);
      self.__addConstraint(__scstatus_report, tmpBfr);
      add(')');
      FTableDefs[__scstatus_report] := tmpBfr.Text;


      Clear;
      add('create table ' + CTable_names[__scstatus_report_lines]);
      add('(');
      add('  id ' + __MapBigIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scstatus_report_lines) + ',');
      add('  status_report_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  code ' + __MapVarCharType(6) + ' NOT NULL,'); // veakood
      add('  severity ' + __MapSmallIntType() + ' NOT NULL DEFAULT 0,');
      add('  line_nr  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  ldescr ' + __MapVarCharType(512) + ' NOT NULL DEFAULT '''','); // vea pikk kirjeldus
      add('  ddescr ' + __MapVarCharType(512) + ' NOT NULL DEFAULT '''','); // ntx kliendi info
      add('  misc_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0'); // kliendi ID, kes teab mida veel
      self.__addModFooter(__scstatus_report_lines, tmpBfr);
      self.__addConstraint(__scstatus_report_lines, tmpBfr);
      add(')');
      FTableDefs[__scstatus_report_lines] := tmpBfr.Text;


      // -----------
      // 24.10.2010 ingmar
      Clear;
      add('create table ' + CTable_names[__scformd]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scformd) + ',');
      add('  form_name ' + __MapVarCharType(45) + ' NOT NULL DEFAULT '''',');
      add('  form_type ' + __MapCharType(1) + ' NOT NULL  DEFAULT '''',');
      add('  descr ' + __MapVarCharType(512) + ' NOT NULL DEFAULT '''',');
      add('  url ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  valid_from ' + __MapDateVariable() + ' NULL,');
      add('  valid_until ' + __MapDateVariable() + ' NULL,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scformd, tmpBfr);
      self.__addConstraint(__scformd, tmpBfr);
      add(')');
      FTableDefs[__scformd] := tmpBfr.Text;


      Clear;
      add('create table ' + CTable_names[__scformd_lines]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scformd_lines) + ',');
      add('  formd_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  parent_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  line_descr ' + __MapVarCharType(1024) + ' NOT NULL DEFAULT '''',');
      add('  row_nr ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // 20.02.2011 Ingmar; see sisuliselt vajalik sorteerimiseks ridade järjestus
      add('  row_id ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''',');
      // aga see on rea unikaalne ID, mis ei muutu, kui mingi rida vahelt kustutatakse või lisatakse ! seda kasutatakse valemist !
      add('  log_nr ' + __MapVarCharType(20) + ' NOT NULL DEFAULT '''',');
      add('  formula ' + __MapVarCharType(1024) + ' NOT NULL DEFAULT '''',');

      // 23.02.2011 Ingmar;
      add('  ext_definition ' + __MapVarCharType(90) + '  NOT NULL DEFAULT '''',');
      // fonti definitsioon; vajalik aruande jaoks; samas lippudega mängides saab laiendada selle mõistet
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  baserecord_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');

      self.__addModFooter(__scformd_lines, tmpBfr);
      self.__addConstraint(__scformd_lines, tmpBfr);
      add(')');
      FTableDefs[__scformd_lines] := tmpBfr.Text;

      Clear;
      add('create table ' + CTable_names[__sctaxd_history]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__sctaxd_history) + ',');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  client_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // reserveeritud
      // EE:EEAEEAA/
      add('  vatnumber ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  taxyear ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  taxmonth ' + __MapSmallIntType() + ' NOT NULL DEFAULT 0,');
      add('  currency ' + __MapCharType(3) + '  NOT NULL DEFAULT  ''' + getDefaultCurrency + ''',');
      add('  decl_sent ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  decl_sent_date ' + __MapDateVariable() + ' NULL,');
      add('  type_ ' + __MapCharType(1) + ' NOT NULL DEFAULT ''''');
      self.__addModFooter(__sctaxd_history, tmpBfr);
      self.__addConstraint(__sctaxd_history, tmpBfr);
      add(')');
      FTableDefs[__sctaxd_history] := tmpBfr.Text;


      Clear;
      add('create table ' + CTable_names[__sctaxd_history_lines]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__sctaxd_history_lines) + ',');
      add('  taxd_history_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  taxd_form_line_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  taxsum ' + __MapMoneyType + ' NOT NULL DEFAULT ''0.00''');
      self.__addModFooter(__sctaxd_history_lines, tmpBfr);
      self.__addConstraint(__sctaxd_history_lines, tmpBfr);
      add(')');
      FTableDefs[__sctaxd_history_lines] := tmpBfr.Text;


      // 10.05.2011 Ingmar
      Clear;
      add('create table ' + CTable_names[__sclocked_objects]);
      add('(');
      add('  id ' + __MapBigIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__sclocked_objects) + ',');
      add('  item_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  item_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  user_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  lock_init ' + __MapdateTimeVariable() + ' NOT NULL DEFAULT ' + __DefaultDate() + ',');
      add('  lock_expires  ' + __MapdateTimeVariable() + '  NULL,');
      add('  data ' + __MapCharType(25) + ' NOT NULL DEFAULT '''','); // võimalik, et vaja hoida mingit infot, mis lukustusega seotud
      add('  flags' + __MapIntType() + ' NOT NULL DEFAULT 0');
      add(')');
      FTableDefs[__sclocked_objects] := tmpBfr.Text;

      // 22.01.2012
      Clear;
      add('create table ' + CTable_names[__sctaxes]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__sctaxes) + ',');
      add('  taxname ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  perc  ' + __MapPercType() + ' NOT NULL,');
      add('  valid_from ' + __MapDateVariable() + ' NULL,');
      add('  valid_until ' + __MapDateVariable() + ' NULL,');
      add('  account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  minsum ' + __MapMoneyType + ' NOT NULL DEFAULT 0.00,');
      add('  maxsum ' + __MapMoneyType + ' NOT NULL DEFAULT 0.00,');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  type_ ' + __MapCharType(1) + ' NOT NULL DEFAULT '''','); // maksuliik T (tulumaks),sotsiaalmaks S
      add('  baserec_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__sctaxes, tmpBfr);
      self.__addConstraint(__sctaxes, tmpBfr);
      add(')');
      FTableDefs[__sctaxes] := tmpBfr.Text;


      // 02.03.2012 Ingmar
      Clear;
      add('create table ' + CTable_names[__scnumeratorcache]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scnumeratorcache) + ',');
      add('  num_type ' + __MapVarCharType(10) + ' NOT NULL DEFAULT '''',');
      add('  num_value ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''',');
      add('  num_acc_period_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // 1 reserved; 2 private
      add('  reserved1 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  user_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      add(')');
      FTableDefs[__scnumeratorcache] := tmpBfr.Text;

      // 06.03.2012 Ingmar
      Clear;
      add('create table ' + CTable_names[__scdynamicdnshost]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scdynamicdnshost) + ',');
      add('  dynhostname ' + __MapVarCharType(1024) + ' NOT NULL DEFAULT '''',');
      add('  customername ' + __MapVarCharType(128) + ' NOT NULL DEFAULT '''',');
      add('  databasename ' + __MapVarCharType(1024) + ' NOT NULL DEFAULT '''',');
      add('  current_ip ' + __MapVarCharType(40) + ' NOT NULL DEFAULT '''',');
      add('  previous_ip ' + __MapVarCharType(40) + ' NOT NULL DEFAULT '''',');
      add('  iptype ' + __MapVarCharType(5) + ' NOT NULL DEFAULT '''',');
      add('  rec_changed ' + __MapModDateTime() + ',');
      add('  active ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'',');
      // ---
      add('  user_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      add(')');
      FTableDefs[__scdynamicdnshost] := tmpBfr.Text;


      // 02.03.2013 Ingmar
      Clear;
      add('create table ' + CTable_names[__scwebusers]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scwebusers) + ',');
      add('  username ' + __MapVarcharType(25) + '  NOT NULL DEFAULT '''',');
      add('  password ' + __MapVarcharType(45) + '  NOT NULL DEFAULT '''',');
      add('  lastloginfrom_ip ' + __MapVarCharType(40) + ' NOT NULL DEFAULT '''',');
      add('  lastlogin ' + __MapModDateTime() + ',');
      add('  permissionstr ' + __MapVarcharType(512) + '  NOT NULL DEFAULT '''',');
      add('  active ' + __MapModBoolean() + ' NOT NULL DEFAULT ''t'',');
      add('  client_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  reserved1  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scwebusers, tmpBfr);
      self.__addModFooter(__scwebusers, tmpBfr);
      add(')');
      FTableDefs[__scwebusers] := tmpBfr.Text;


      Clear;
      add('create table ' + CTable_names[__scsentemails]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scsentemails) + ',');
      add('  email_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  item_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  item_type ' + __MapCharType(2) + ' NOT NULL DEFAULT '''',');
      add('  classificator_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  client_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  reserved1  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scsentemails, tmpBfr);
      self.__addModFooter(__scsentemails, tmpBfr);
      add(')');
      FTableDefs[__scsentemails] := tmpBfr.Text;



      // 30.11.2015 Ingmar;
      Clear;
      add('create table ' + CTable_names[__scsepafile]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scsepafile) + ',');
      add('  bankcode ' + __MapVarCharType(15) + ' NOT NULL DEFAULT '''',');
      add('  file_generated ' + __MapdateTimeVariable() + ' NOT NULL DEFAULT ' + __DefaultDate() + ',');
      add('  file_name ' + __MapVarCharType(512) + ' NOT NULL DEFAULT '''',');
      add('  company_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  reserved1  ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addConstraint(__scsepafile, tmpBfr);
      self.__addModFooter(__scsepafile, tmpBfr);
      add(')');
      FTableDefs[__scsepafile] := tmpBfr.Text;


      // 30.11.2015 Ingmar;
      Clear;
      add('create table ' + CTable_names[__scsepafileentry]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scsepafileentry) + ',');
      add('  sepa_file_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  payment_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      add(')');
      FTableDefs[__scsepafileentry] := tmpBfr.Text;

      // 06.01.2012 Ingmar
        {$ifdef wagemodule_enabled}


      // ---
      Clear;
      add('create table ' + CTable_names[__scemployee]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scemployee) + ',');
      add('  code ' + __MapVarCharType(20) + ' NOT NULL DEFAULT '''',');
      add('  firstname ' + __MapVarCharType(30) + ' NOT NULL DEFAULT '''',');
      add('  middlename ' + __MapVarCharType(30) + ' NOT NULL DEFAULT '''',');
      add('  lastname ' + __MapVarCharType(30) + ' NOT NULL DEFAULT '''',');
      add('  gender ' + __MapCharType(1) + ' NOT NULL DEFAULT '''',');
      add('  personal_idnr ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''',');  // isikukood
      add('  bday ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  bmonth ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  byear ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  address ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  postalcode ' + __MapVarCharType(20) + ' NOT NULL DEFAULT '''',');
      add('  phone ' + __MapVarCharType(55) + ' NOT NULL DEFAULT '''',');
      add('  email ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  bank ' + __MapVarCharType(50) + ' NOT NULL DEFAULT '''',');
      add('  bankaccount ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''',');
      add('  nationality ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''',');
      add('  nonresident ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  resident_countryname ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''',');
      add('  resident_countrycode ' + __MapVarCharType(5) + ' NOT NULL DEFAULT '''',');
      add('  lpermitnr ' + __MapVarCharType(30) + ' NOT NULL DEFAULT '''',');
      add('  wpermitnr ' + __MapVarCharType(30) + ' NOT NULL DEFAULT '''',');
      add('  education ' + __MapLongText() + '  NULL,');
      add('  picture ' + __MapBlobField() + '  NULL,');

      add('  reserved1 ' + __MapVarCharType(50) + ' NOT NULL DEFAULT '''',');
      add('  reserved2 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');

      add('  contact_person ' + __MapVarCharType(40) + ' NOT NULL DEFAULT '''',');
      add('  contact_person_addr ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  contact_person_phone ' + __MapVarCharType(55) + ' NOT NULL DEFAULT '''',');
      add('  flags' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scemployee, tmpBfr);
      self.__addConstraint(__scemployee, tmpBfr);
      add(')');
      FTableDefs[__scemployee] := tmpBfr.Text;

      Clear;
      add('create table ' + CTable_names[__scemployee_id_document]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scemployee_id_document) + ',');
      add('  employee_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  doc_name ' + __MapCharType(25) + ' NOT NULL DEFAULT '''','); // dok. nimi
      add('  doc_nr ' + __MapCharType(25) + ' NOT NULL DEFAULT '''',');
      add('  doc_descr ' + __MapCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  issuer ' + __MapCharType(35) + ' NOT NULL DEFAULT '''',');
      add('  issued  ' + __MapdateTimeVariable() + ' NULL,');
      add('  valid_until ' + __MapdateTimeVariable() + ' NULL,');
      add('  flags' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scemployee_id_document, tmpBfr);
      self.__addConstraint(__scemployee_id_document, tmpBfr);
      add(')');
      FTableDefs[__scemployee_id_document] := tmpBfr.Text;

      // ---
{
        clear;
        add('create table '+CTable_names[__scemployee_id_document]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scemployee_id_document)+',');
        add('  id_document_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  employee_id '+__MapIntType()+' NOT NULL DEFAULT 0');
        self.__addModFooter(__scemployee_id_document,tmpBfr);
        self.__addConstraint(__scemployee_id_document,tmpBfr);
        add(')');
        FTableDefs[__scemployee_id_document]:=tmpBfr.Text;
}
      Clear;
      add('create table ' + CTable_names[__scemployment_contract]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scemployment_contract) + ',');
      add('  employee_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  classificator_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // lepingu tüüp
      add('  nr ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''',');
      add('  contract_date ' + __MapdateTimeVariable() + ' NULL,');
      add('  norm_workhours ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // töötunde nädalas
      add('  start_date ' + __MapdateTimeVariable() + ' NULL,');
      add('  end_date ' + __MapdateTimeVariable() + ' NULL,');
      add('  position ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  holidays_per_year ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  tfcalc_beginning  ' + __MapdateTimeVariable() + ' NULL,');      // maksuvaba tulu arvestuse algus
      add('  early_retirement_date ' + __MapdateTimeVariable() + ' NULL,');  // ennetähtaegse pensioni algus
      add('  reserved1 ' + __MapdateTimeVariable() + ' NULL,');
      add('  reserved2 ' + __MapdateTimeVariable() + ' NULL,');
      // NB lipud, siis hoiame erinevat infot ja erinevate riikide kohta !!!
      // siin tuleb palju lippe, selletõttu ta ka bigint !
      // CWorkContract_soc_sec_tax_minimum = 1; 2^0
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scemployment_contract, tmpBfr);
      self.__addConstraint(__scemployment_contract, tmpBfr);
      add(')');
      FTableDefs[__scemployment_contract] := tmpBfr.Text;

      Clear;
      add('create table ' + CTable_names[__scwage_types]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scwage_types) + ',');
      add('  classificator_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  name ' + __MapVarCharType(130) + ' NOT NULL DEFAULT '''',');
      add('  account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  parent_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  refcode ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''',');  // Väljamakse kood TSD deklaratsioonil
      // --
      add('  acc_type ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''','); // D või C
      add('  sub_type ' + __MapCharType(1) + ' NOT NULL DEFAULT '''','); // -- ntx info kas me nö maksame makse; maksude rida; T ntx taxes

      add('  perc ' + __MapPercType() + ' NOT NULL DEFAULT ''0.00'',');
      add('  perc1 ' + __MapPercType() + ' NOT NULL DEFAULT ''0.00'',');
      add('  reserved1 ' + __MapVarCharType(35) + ' NOT NULL DEFAULT '''',');
      add('  reserved2 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scwage_types, tmpBfr);
      self.__addConstraint(__scwage_types, tmpBfr);
      add(')');
      FTableDefs[__scwage_types] := tmpBfr.Text;

      // ----
{
        clear;
        add('create table '+CTable_names[__scwage_type_taxes]);
        add('(');
        add('  id '+__MapIntType()+' PRIMARY KEY '+__GenerateAutonumber(__scwage_type_taxes)+',');
        add('  tax_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  account_id '+__MapIntType()+' NOT NULL DEFAULT 0,');
        add('  flags '+__MapIntType()+' NOT NULL DEFAULT 0');
        self.__addModFooter(__scwage_type_taxes,tmpBfr);
        self.__addConstraint(__scwage_type_taxes,tmpBfr);
        add(')');
        FTableDefs[__scwage_type_taxes]:=tmpBfr.Text;
}

      // ---
      Clear;
      add('create table ' + CTable_names[__scemployee_wage]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scemployee_wage) + ',');
      add('  employee_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  employment_contract_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  valid_from ' + __MapdateTimeVariable() + ' NULL,');
      add('  valid_until ' + __MapdateTimeVariable() + ' NULL,');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  template_name ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''',');
      add('  template ' + __MapModBoolean() + ' NOT NULL DEFAULT ''f'',');
      add('  parent_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // tavaline töötaja palgamoodul viitab mallile, mis aluseks võtta
      add('  baserecord_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  company_id ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scemployee_wage, tmpBfr);
      self.__addConstraint(__scemployee_wage, tmpBfr);
      add(')');
      FTableDefs[__scemployee_wage] := tmpBfr.Text;


      // ---
      Clear;
      add('create table ' + CTable_names[__scemployee_wage_lines]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scemployee_wage_lines) + ',');
      add('  employee_wage_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  wage_type_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  tax_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // ***
      add('  account_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  row_id ' + __MapVarCharType(15) + ' NOT NULL DEFAULT '''',');
      add('  formula ' + __MapVarCharType(255) + ' NOT NULL DEFAULT '''',');
      add('  unit ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''',');

      // kaua see rida kehtis ! ntx määrati ühes kuus preemia, siis töötajale lisati see rida
      add('  valid_from ' + __MapdateTimeVariable() + ' NULL,');
      add('  valid_until ' + __MapdateTimeVariable() + ' NULL,');
      add('  price ' + __MapMoneyType() + ' NOT NULL DEFAULT ''0.00'',');
      add('  reserved1 ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scemployee_wage_lines, tmpBfr);
      self.__addConstraint(__scemployee_wage_lines, tmpBfr);
      add(')');
      FTableDefs[__scemployee_wage_lines] := tmpBfr.Text;


      // ----
      Clear;
      add('create table ' + CTable_names[__scemployee_wtimetable]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scemployee_wtimetable) + ',');
      add('  employee_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  employment_contract_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  wyear ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  wmonth ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      // 5.2;
      // d
      // -9 algusega näitab, et tegemist on põhjuseta puudumisega
      // -8 algusega näitab, et tegemist oli haigusega
      // -7 algusega näitab, et tegemist on puhkusega
      add('  d1 ' + __MapVarCharType(6) + '  NOT NULL DEFAULT '''','); // 5.2 tüüp, sobib meile hästi !!!
      add('  d2 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d3 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d4 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT ''0.00'',');
      add('  d5 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d6 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d7 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d8 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d9 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d10 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d11 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d12 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d13 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d14 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d15 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d16 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d17 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d18 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d19 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d20 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d21 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d22 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d23 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d24 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d25 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d26 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d27 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d28 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d29 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d30 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');
      add('  d31 ' + __MapVarCharType(6) + ' NOT NULL DEFAULT '''',');

      add('  overtime ' + __MapPercType() + ' NOT NULL DEFAULT ''0.00'',');      // ületundide arv
      add('  holidaytime ' + __MapPercType() + ' NOT NULL DEFAULT ''0.00'',');   // palju tunde tehti pühade aeg
      add('  absencetime ' + __MapPercType() + ' NOT NULL DEFAULT ''0.00'',');   // põhjuseta puudumise päevi
      add('  sicknesstime  ' + __MapPercType() + ' NOT NULL DEFAULT ''0.00'','); // haiguse päevi
      // reserveeritud
      add('  m1 ' + __MapdateTimeVariable() + ' NULL,');
      add('  m2 ' + __MapdateTimeVariable() + ' NULL,');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      // ---
      self.__addModFooter(__scemployee_wtimetable, tmpBfr);
      self.__addConstraint(__scemployee_wtimetable, tmpBfr);
      add(')');
      FTableDefs[__scemployee_wtimetable] := tmpBfr.Text;

      Clear;
      // Palk Isikukaardi töövõimetuse lehele on lisatud veerud "Tasustamata päeva tüüp", "Tasustatud päeva tüüp" ja "Haigekassa tasustatud päeva tüüp" , kuhu sisestatud tähiseid kasutatakse tööajatabeli täitmisel.
      add('create table ' + CTable_names[__scpayroll]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scpayroll) + ',');
      add('  nr ' + __MapVarCharType(20) + ' NOT NULL DEFAULT '''',');
      add('  payment_date  ' + __MapdateTimeVariable() + ' NULL,');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  employee_wage_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // viitame palgaaluseks olnud tööaja tabelile
      add('  employee_wtimetable_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,'); // viitame palgaaluseks olnud tööaja tabelile
      add('  bank_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  bankaccount ' + __MapVarCharType(25) + ' NOT NULL DEFAULT '''',');
      add('  accounting_register_id  ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  comments ' + __MapLongText() + '  NULL,');
      add('  reserved1 ' + __MapIntType() + ' NOT NULL DEFAULT 0');
      self.__addModFooter(__scpayroll, tmpBfr);
      self.__addConstraint(__scpayroll, tmpBfr);
      add(')');
      FTableDefs[__scpayroll] := tmpBfr.Text;

      Clear;
      add('create table ' + CTable_names[__scpayroll_entry]);
      add('(');
      add('  id ' + __MapIntType() + ' PRIMARY KEY ' + __GenerateAutonumber(__scpayroll_entry) + ',');
      add('  payroll_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  wage_type_id ' + __MapIntType() + ' NOT NULL DEFAULT 0,');
      add('  sumtotal ' + __MapMoneyType() + ' NOT NULL DEFAULT ''0.00'',');
      add('  pstart  ' + __MapdateTimeVariable() + ' NULL,');
      add('  pend  ' + __MapdateTimeVariable() + ' NULL,');
      add('  flags ' + __MapIntType() + ' NOT NULL DEFAULT 0');

      self.__addModFooter(__scpayroll_entry, tmpBfr);
      self.__addConstraint(__scpayroll_entry, tmpBfr);
      add(')');
      FTableDefs[__scpayroll_entry] := tmpBfr.Text;

        {$endif}
    end;
    // ----
  finally
    tmpBfr.Free;
  end;
end;

destructor Testbk_databaseschema.Destroy;
begin
  inherited Destroy;
end;

{


-- alltables
SELECT relname FROM pg_class WHERE relname NOT LIKE 'pg_%' AND relkind = 'r';
SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type != 'VIEW' AND table_name NOT LIKE 'pg_ts_%%'

-- allsequence
SELECT sequence_name FROM information_schema.sequences
                 WHERE sequence_schema='public'

products


product_price






services
- service_service_id
- service_name
- amount



}

end.
