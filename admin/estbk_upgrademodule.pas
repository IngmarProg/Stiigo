// antud moodul tegeleb uuenduste läbi viimisega;
unit estbk_upgrademodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LCLProc, estbk_crc32;

procedure __doDatabaseUpgrade;

implementation

uses estbk_types, estbk_strmsg, estbk_datamodule, estbk_dbcompability,
  estbk_sqlcollection, estbk_lib_mapdatatypes, estbk_permissions, Dialogs;

// NB NB tulevikus võib need osad versioonide uuendamise koodid välja visata !
procedure __doDatabaseUpgrade;
var
  i, k: integer;
  j: TCNumeratorTypes;
  pSchemaVer: integer;
  pCompList: TADynIntArray;
  pTempStr: AStr;
  pParamCheck: boolean;
  pTempArray: TADynIntArray;   // 1005 jaoks
  pFullname: AStr;
  pCRC: DWord;
  // --
  zPerm: TPermIdentType;
begin
  if estbk_datamodule.admDatamodule.admConnection.Connected then
    with  estbk_datamodule.admDatamodule, admTempQuery, SQL do
      try
        estbk_datamodule.admDatamodule.admConnection.StartTransaction;
        try
          pParamCheck := estbk_datamodule.admDatamodule.admTempQuery.ParamCheck;
          estbk_datamodule.admDatamodule.admTempQuery.ParamCheck := True;
          // mingi ajalooline probleem, et kahele tabelile ei saa mõnikord ligi !
          try
            Close;
            Clear;
            Add('GRANT SELECT ON users TO estbk_role');
            execSQL;

            Close;
            Clear;
            Add('GRANT SELECT,UPDATE,INSERT ON user_settings TO estbk_role');
            execSQL;

            Close;
            Clear;
            Add('GRANT SELECT,UPDATE,INSERT ON numerators TO estbk_role');
            execSQL;
          except
          end;

          Close;
          Clear;
          add('SELECT id,var_misc FROM conf WHERE var_name=''estbk_schemaver''');
          Open;
          pSchemaVer := strtointdef(FieldByName('var_misc').AsString, 0);

          if pSchemaVer < estbk_types.CCurrentDatabaseSchemaId then
          begin
            // @@ 1000<=
            // -- esmane versioon 1000; alates 1001 tulid eraldi kandeseeriad kõikidele toimingutele, eraldi arvetele, tasumised, kassa...
            if pSchemaVer <= 1000 then
            begin
              Close;
              Clear;
              add('ALTER TABLE accounting_records');
              add('ADD billnrs ' + TEstbk_MapDataTypes.__MapVarcharType(1024) + 'NOT NULL DEFAULT ''''');
              try
                execSQL;
              except
              end;

              // vaatame, kas nummerdajad / numeraatorid on kõikidel firmadel olemas;
              // nüüd tuli terve ports uusi
              Close;
              Clear;
              add('SELECT id FROM company');
              Open;
              First;
              setLength(pCompList, RecordCount + 1);

              i := low(pCompList) + 1;
              pCompList[low(pCompList)] := 0; // -- 0 on süsteemne firma, keda tuleb samuti uuendada ! tema pealt päritakse tulevikus tunnused !


              while not EOF do
              begin
                pCompList[i] := FieldByName('id').AsInteger;
                Inc(i);
                Next;
              end;


              // vaatame, milline numeraator puudu !
              for i := low(pCompList) to high(pCompList) do
                for j := low(TCNumeratorTypes) to high(TCNumeratorTypes) do
                begin
                  pTempStr := TNumeratorTypesSDescr[j];
                  Close;
                  Clear;
                  Add('SELECT id FROM numerators WHERE cr_num_type=:crnumtype AND company_id=:company_id');
                  paramByname('crnumtype').AsString := pTempStr;
                  paramByname('company_id').AsInteger := pCompList[i]; // ---
                  Open;

                  if RecordCount < 1 then
                  begin
                    Close;
                    Clear;
                    add('INSERT INTO numerators(cr_num_val, cr_num_start, cr_num_type, cr_vrange_start, cr_vrange_end,');
                    add('cr_version, cr_valid, cr_srbfr, company_id, rec_changed, rec_changedby,rec_addedby)');
                    add('VALUES(:cr_num_val, :cr_num_start, :cr_num_type, :cr_vrange_start, :cr_vrange_end,');
                    add(':cr_version, :cr_valid, :cr_srbfr, :company_id, :rec_changed, :rec_changedby,:rec_addedby)');
                    paramByname('cr_num_val').AsInteger := 0;
                    paramByname('cr_num_start').AsInteger := 0;
                    paramByname('cr_num_type').AsString := pTempStr;
                    paramByname('cr_vrange_start').AsInteger := 0;
                    paramByname('cr_vrange_end').AsInteger := 0;
                    paramByname('cr_version').AsInteger := 1;
                    paramByname('cr_valid').AsString := estbk_types.SCFalseTrue[True];
                    paramByname('cr_srbfr').AsString := '';
                    paramByname('company_id').AsInteger := pCompList[i];
                    paramByname('rec_changed').AsDateTime := now;
                    paramByname('rec_changedby').AsInteger := 0;
                    paramByname('rec_addedby').AsInteger := 0;
                    execSQL;
                  end;
                  // ----
                end;

              // kuna arve kande nr lõime eraldi, siis tuleb anda viimase kande väärtus kõigile ! see ohutum !
              Close;
              Clear;
              add('UPDATE numerators');
              add('SET cr_num_val=(SELECT c.cr_num_val FROM numerators c WHERE c.cr_num_type=''ABLNR'' AND c.company_id=numerators.company_id)');
              add('WHERE numerators.cr_num_type IN (''ABPNR'',''ABCNR'',''ABRNR'',''ABDNR'')');
              add('  AND numerators.company_id>0');
              execSQL;


              // ---
            end;

            // @@ 1001<= triggeri probleem, arve märgiti laekunuks, kui arve summa oli <0.00 !
            if pSchemaVer <= 1001 then
              admDatamodule.addFncTriggers(False);

            // @@ 1002<= user_settings pealt ära tobe uniq index
            //if pSchemaVer<=1002 then
            if pSchemaVer <= 1012 then
            begin
              Close;
              Clear;
              add('drop index user_settings_usrid');
              execSQL;

              Close;
              Clear;
              add('CREATE  INDEX user_settings_usrid');
              add('ON user_settings');
              add('USING btree');
              add('(company_id,user_id, item_name)');
              execSQL;
            end;

            // @@ 1003<= mingitel hetkedel tulevad aadressitele olematud tänavate ID'd !
            if pSchemaVer <= 1003 then
            begin
              Close;
              Clear;
              add('update client');
              add('set street_id=0');
              add('where not exists(select * from street where street.id=client.street_id) and client.street_id>0');
              execSQL;
            end;

            // @@ 1004<= et laekumised kasutaks ka eraldi kandeseeriat !!!! ta oli pearaamatuga sama seeria peal !
            if pSchemaVer <= 1004 then
            begin
              Close;
              Clear;
              add('update numerators');
              add('set ');
              add('  cr_num_val=cast( ');
              add(' (select coalesce(max(a.entrynumber),''1'') as maxaccnr');
              add(' from incomings i');
              add(' inner join accounting_register a on');
              add(' a.id=i.accounting_register_id');
              add(' where i.company_id=numerators.company_id) as int)');
              add(' where cr_num_type=''INCNR''');
              execSQL;
            end;

            // @@ 1005<= väga suur jama oli, selgus et laekumised paneb järjest sisestamisel kandeid aina juurde
            // Probleemiks oli see, et puudub loendur, kas eelmistel laekumistel reaalselt ka midagi muutus
            if pSchemaVer <= 1005 then
            begin
              Close;
              Clear;
              add('select ');
              add('ro.id as accregid,');
              add('i.bill_id,');
              add('l.bill_number,');
              add('l.payment_status,');
              add('(l.totalsum+l.roundsum+l.vatsum+l.fine) as billsum,');
              add('l.incomesum as billincomesum,');
              add('l.prepaidsum,');
              add('ro.entrynumber,');
              add('cast(');
              add('(select sum(s.rec_sum)');
              add('from accounting_register r');
              add('inner join accounting_records s on');
              add('s.accounting_register_id=r.id and');
              add('s.rec_type=''C'' and');
              add('s.ref_item_id=i.bill_id');
              add('and s.id>(select coalesce(max(s1.id),0) from accounting_records s1 where s1.accounting_register_id=r.id and s1.status=''D'' and s1.archive_rec_id>0)');
              add('where r.rec_deleted=''f'' and type_ not like ''%C%'' and r.id=i.accounting_register_id ) as numeric(18,4))  as acc_sum,');
              add('i.income_sum as incsum');

              add('from incomings i');
              add('inner join bills l on');
              add('l.id=i.bill_id');
              add('inner join incomings_bank b on');
              add('b.status=''C'' and b.id=i.incomings_bank_id');
              add('inner join accounting_register ro on');
              add('ro.id=i.accounting_register_id');
              // and ro.id=53
              add('and (select sum(s.rec_sum)');
              add('     from accounting_register r');
              add('     inner join accounting_records s on');
              add('     s.accounting_register_id=r.id and');
              add('     s.rec_type=''D''');
              add('     and s.id>(select coalesce(max(s1.id),0) from accounting_records s1 where s1.accounting_register_id=r.id and s1.status=''D'' and s1.archive_rec_id>0)');
              add('     where r.rec_deleted=''f'' and type_ not like ''%C%'' and r.id=i.accounting_register_id )>i.income_sum');
              add('     where i.currency=''EUR''');
              Open;


              setlength(pTempArray, 1);
              i := low(pTempArray);
              // jätame meelde kanded, mille sisu tuleb annuleerida !
              First;
              while not EOF do
              begin
                // -- vaatame, kas peakirje ID on juba meil massiivis !
                for k := low(pTempArray) to high(pTempArray) do
                  if pTempArray[k] = FieldByName('accregid').AsInteger then
                  begin
                    Next;
                    continue;
                  end;


                if i > high(pTempArray) then
                  setlength(pTempArray, length(pTempArray) + 1);

                // ---
                pTempArray[i] := FieldByName('accregid').AsInteger;
                Inc(i);
                Next;
              end;

              // ---
              First;

              // teeme valmis ajutise tabeli, kuhu sisestame viimased kanded
              admTempQuery2.Close;
              admTempQuery2.SQL.Clear;
              admTempQuery2.SQL.Text := ' create temporary table pfixbug00014 ' +
                // ' on commit drop '+
                ' as ' + ' select accounting_register_id,account_id,descr,rec_nr,rec_sum,rec_type,client_id,tr_partner_name, ' +
                ' currency,currency_id,currency_vsum,currency_drate_ovr,status,flags,archive_rec_id, ' +
                ' ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag, ' +
                ' ref_debt_flag,ref_tax_flag,reserved1,reserved2,company_id,rec_changed, ' +
                ' rec_changedby,rec_addedby,rec_deletedby,rec_deleted,billnrs ' + ' from accounting_records rr0 ' + ' where 0=1';
              admTempQuery2.ExecSQL;

              // --- hakkame siis parandamisega pihta, jätame esmalt meelde korras kirjed st viimased kanded neid dublikaatidest !
              for k := low(pTempArray) to high(pTempArray) do
              begin
                // --
                admTempQuery2.Close;
                admTempQuery2.SQL.Clear;
                admTempQuery2.SQL.Text := ' delete from pfixbug00014 ';
                admTempQuery2.ExecSQL;

                admTempQuery2.Close;
                admTempQuery2.SQL.Clear;

                admTempQuery2.SQL.Text := ' insert into pfixbug00014 ' +
                  ' select accounting_register_id,account_id,descr,rec_nr,rec_sum,rec_type,client_id,tr_partner_name, ' +
                  ' currency,currency_id,currency_vsum,currency_drate_ovr,status,flags,archive_rec_id, ' +
                  ' ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag, ' +
                  ' ref_debt_flag,ref_tax_flag,reserved1,reserved2,company_id,rec_changed, ' +
                  ' rec_changedby,rec_addedby,rec_deletedby,rec_deleted,billnrs ' + ' from accounting_records rr0 ' +
                  ' where ' + '      rr0.accounting_register_id=' + IntToStr(pTempArray[k]) + '  and rr0.rec_changed=( ' +
                  '  select rr1.rec_changed ' + '  from accounting_records rr1 ' +
                  '  where (rr1.id= (select max(rr2.id) from accounting_records rr2 where rr2.accounting_register_id=rr0.accounting_register_id and rec_type=''D''))) ';
                admTempQuery2.ExecSQL;


                // peab olema kirjeid !
                if admTempQuery2.RowsAffected > 1 then
                begin
                  admTempQuery2.Close;
                  admTempQuery2.SQL.Clear;
                  admTempQuery2.SQL.Text := ' INSERT INTO accounting_records( ' + ' accounting_register_id, account_id, ' +
                    ' rec_nr, rec_sum, rec_type, currency, currency_vsum,currency_drate_ovr,currency_id, ' +
                    ' company_id, status, archive_rec_id, rec_changed, rec_changedby,rec_addedby, ' +
                    ' client_id,flags,ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag, ' +
                    // 17.02.2011 Ingmar lisasin kõik väljad !
                    ' ref_debt_flag,ref_tax_flag) ' + ' SELECT a.accounting_register_id, a.account_id, ' +
                    ' a.rec_nr, -a.rec_sum, a.rec_type, a.currency, -a.currency_vsum,a.currency_drate_ovr,a.currency_id, ' +
                    // teeme vastandmärgiga kanderea
                    ' a.company_id, ''D'', id,  :rec_changed, :rec_changedby, :rec_addedby, ' +
                    ' a.client_id,a.flags,a.ref_item_type,a.ref_item_id,a.ref_prepayment_flag,a.ref_payment_flag,a.ref_income_flag,a.ref_debt_flag,a.ref_tax_flag '
                    + ' FROM  accounting_records a ' +
                    ' WHERE a.accounting_register_id=:accounting_register_id ' + '   AND a.status not like ''%D%''' +
                    '   AND a.id>(SELECT COALESCE(max(b.id),0) ' + '             FROM accounting_records b ' +
                    '             WHERE b.accounting_register_id=a.accounting_register_id ' +
                    '               AND b.status like ''%D%'')' + ' ORDER BY a.rec_nr ';
                  // ---
                  admTempQuery2.ParamByName('accounting_register_id').AsInteger := pTempArray[k];
                  admTempQuery2.ParamByName('rec_changed').AsDateTime := now;
                  admTempQuery2.ParamByName('rec_changedby').AsInteger := 0;
                  admTempQuery2.ParamByName('rec_addedby').AsInteger := 0;
                  admTempQuery2.ExecSQL;

                  // kirjutame kõlblikud kanded tagasi !
                  admTempQuery2.Close;
                  admTempQuery2.SQL.Clear;
                  admTempQuery2.SQL.Text := ' insert into accounting_records (' +
                    ' accounting_register_id,account_id,descr,rec_nr,rec_sum,rec_type,client_id,tr_partner_name, ' +
                    ' currency,currency_id,currency_vsum,currency_drate_ovr,status,flags,archive_rec_id, ' +
                    ' ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag, ' +
                    ' ref_debt_flag,ref_tax_flag,reserved1,reserved2,company_id,rec_changed, ' +
                    ' rec_changedby,rec_addedby,rec_deletedby,rec_deleted,billnrs ' + ')' +
                    ' select accounting_register_id,account_id,descr,rec_nr,rec_sum,rec_type,client_id,tr_partner_name, ' +
                    ' currency,currency_id,currency_vsum,currency_drate_ovr,status,flags,archive_rec_id, ' +
                    ' ref_item_type,ref_item_id,ref_prepayment_flag,ref_payment_flag,ref_income_flag, ' +
                    ' ref_debt_flag,ref_tax_flag,reserved1,reserved2,company_id,rec_changed, ' +
                    ' rec_changedby,rec_addedby,rec_deletedby,rec_deleted,billnrs ' + ' from pfixbug00014 ';
                  admTempQuery2.ExecSQL;



                  // ja nüüd korrastame arved ära
                  First; // arvete dataset !
                  while not EOF do
                  begin

                    if FieldByName('accregid').AsInteger = pTempArray[k] then
                    begin
                      admTempQuery2.Close;
                      admTempQuery2.SQL.Clear;
                      admTempQuery2.SQL.Text := ' UPDATE bills ' + ' SET prepaidsum=:prepaidsum, ' +
                        '     incomesum=:incomesum ' + ' WHERE id=:id ';
                      admTempQuery2.ParamByName('prepaidsum').AsFloat := 0.00;
                      admTempQuery2.ParamByName('incomesum').AsFloat := FieldByName('incsum').AsFloat;
                      admTempQuery2.ParamByName('id').AsInteger := FieldByName('bill_id').AsInteger;
                      admTempQuery2.ExecSQL;

                    end;
                    // ---
                    Next;
                  end;

                end;

              end; // k loop
              // ---


              admTempQuery2.Close;
              admTempQuery2.SQL.Clear;
              admTempQuery2.SQL.Text := 'drop table pfixbug00014';
              admTempQuery2.ExecSQL;

            end; // -- 1005

            // @@ 1006 korrigeerime klientidel ära CRC väärtuse, programm omistas need valesti
            if pSchemaVer <= 1006 then
            begin
              Close;
              Clear;
              add('SELECT * FROM client');
              Open;
              // ---
              admTempQuery2.Close;
              admTempQuery2.SQL.Clear;
              admTempQuery2.SQL.Text := 'update client set srcval=:srcval where id=:id';

              while not EOF do
              begin
                pCRC := 0;
                pFullname := UpperCase(trim(FieldByName('name').AsString + ' ' + FieldByName('lastname').AsString));


                if pFullname <> '' then
                  estbk_crc32.CRC32(@pFullname[1], length(pFullname), pCRC);
                admTempQuery2.paramByname('srcval').AsLargeInt := pCRC;
                admTempQuery2.paramByname('id').AsInteger := FieldByName('id').AsInteger;
                admTempQuery2.ExecSQL;

                Next;
              end;
              Close;
              Clear;
              // ---
              admTempQuery2.Close;
              admTempQuery2.SQL.Clear;

            end; // -- 1006

            //add('ALTER TABLE bills RENAME COLUMN reserved1 TO object_id1');
            // uuendame ära arve triggeri, mis paneb staatusi; seoses igasugu miinustega eelmine loogika pole pädev
            if pSchemaVer <= 1007 then
            begin
              admDatamodule.addFncTriggers(False);
            end;

            // 30.08.2011 Ingmar; pangateenustasu väli juurde incomings_bank tabelisse !
            if pSchemaVer <= 1008 then
              try
                Close;
                Clear;
                add('ALTER TABLE incomings_bank');
                add('ADD service_charges ' + TEstbk_MapDataTypes.__MapMoneyType() + ' NOT NULL DEFAULT 0.00 ');
                execSQL;
              except
              end;


            // 02.09.2011 Ingmar;
            if pSchemaVer <= 1009 then
              try
                Close;
                Clear;
                add('ALTER TABLE articles RENAME COLUMN reserved1 TO arttype_id');
                execSQL;
              except
              end;


            // 19.09.2011 Ingmar; nüüd ka numeraatoritele toetus rp. perioodide jaoks
            if pSchemaVer <= 1010 then
              try
                Close;
                Clear;
                add('ALTER TABLE numerators ADD accounting_period_id integer NOT NULL DEFAULT 0');
                execSQL;
              except
              end;


            // 23.12.2011 Ingmar;
            if pSchemaVer <= 1011 then
              try
                // ---
                Close;
                Clear;
                add('DROP INDEX conf_varusr');
                execSQL;

                Close;
                Clear;
                add('ALTER TABLE conf RENAME COLUMN user_id TO company_id');
                execSQL;
              except
              end;


            // 24.12.2011 Ingmar;
            if pSchemaVer <= 1012 then
              try
                // --
                for zperm := __perm_canChangeAddArticles to __perm_canCreatePurchOrders do
                begin
                  Close;
                  Clear;
                  add(_SQLInsertNewPermission);
                  paramByname('system_alias').AsString := TPermDescrShortTerms[zperm];
                  paramByname('description').AsString := TPermDescrLongTerms[zperm];
                  paramByname('type_').AsString := '';
                  execSQL;
                end;
                // ---
              except
              end;

            // 18.02.2012 Ingmar; paljud ver. olid veaparandused, nüüd hüppame kõvasti edasi...
            // paneme ka töölepingu nr
            if pSchemaVer <= 1014 then
              try
                Close;
                Clear;
                add('INSERT INTO numerators(cr_num_val,cr_num_start,cr_num_type,cr_version,accounting_period_id,company_id)');
                add('SELECT DISTINCT 0,1,''WRKCT'',1,accounting_period_id,company_id');
                add('FROM numerators');
                execSQL;

                Close;
                Clear;
       {
       CREATE UNIQUE INDEX numerators_uniqnr_idx
         ON numerators
         USING btree
         (cr_num_type, cr_valid, company_id);
       }
                add('DROP INDEX numerators_uniqnr_idx');
                execSQL;

                Close;
                Clear;
                add('CREATE UNIQUE INDEX numerators_uniqnr_idx ON numerators');
                add('(cr_num_type, cr_valid, accounting_period_id, company_id)');
                execSQL;
                // ---
              except
              end;

            // 02.03.2012 Ingmar
            // --- numeraatorite cache, peame õigused andma
            if pSchemaVer <= 1015 then
              try
                Close;
                Clear;
                add('GRANT SELECT,UPDATE,INSERT ON numeratorcache TO estbk');
                execSQL;
              except
              end;

            // 06.03.2012 Ingmar
            if pSchemaVer <= 1016 then
              try
                Close;
                Clear;
                // olin TSD nimeks ka pannud käibedeklaratsioon
                add('UPDATE formd');
                add('SET form_name=''TSD''');
                add('WHERE form_type=''D''');
                execSQL;
              except
              end;

            // 06.03.2012 Ingmar viitenumbrid arve infole juurde !
            if pSchemaVer <= 1017 then
              try
                Close;
                Clear;
                add('alter table bills');
                add('add ref_nr varchar(30) NOT NULL DEFAULT ''''');
                execsql;

                Close;
                Clear;
                add('alter table bills');
                add('add ref_nr_id  int NOT NULL DEFAULT 0');
                execsql;
              except
              end;

            // 14.04.2012 Ingmar; swift ja iban kliendile
            if pSchemaVer <= 1018 then
              try
                Close;
                Clear;
                add('ALTER TABLE client ');
                add('add  iban varchar(45) NOT NULL DEFAULT ''''');
                execSQL;

                Close;
                Clear;
                add('ALTER TABLE client ');
                add('add swift varchar(11) NOT NULL  DEFAULT ''''');
                execSQL;

              except
              end;

            // 23.04.2012 Ingmar; et ei saaks sama tüübiga kannet teha samasse perioodi !
            if pSchemaVer <= 1019 then
              try

                admDatamodule.addFncTriggers(False);
                Close;
                Clear;
                add('CREATE TRIGGER acc_uniq_nr_trig');
                add('BEFORE INSERT OR UPDATE ON accounting_register');
                add('FOR EACH ROW EXECUTE PROCEDURE acc_uniq_nrv_fnc();');
                execSQL;
              except
              end;

            // 24.04.2012 Ingmar; update ja insert osa tuli viia lahku !
            if pSchemaVer <= 1020 then
              try
                admDatamodule.addFncTriggers(False);  // uuendame süntaksi igaks juhuks ära !
              except
              end;

            // 11.05.2012 Ingmar; uuenda uuesti triggerit, sest kassa laekumistega jama !!! kuna kande tüüp nii väljaminekul, sissetulekul sama !!!
            if pSchemaVer <= 1021 then
              try
                admDatamodule.addFncTriggers(False);  // uuendame süntaksi igaks juhuks ära !
              except
              end;


            // 08.08.2012 Ingmar; sulgemiskande toetus
            if pSchemaVer <= 1022 then
              try
                Close;
                Clear;
                add('insert into classificators(name,shortidef,type_)');
                add('values(''Sulgemiskanne'',''SK'',''document_types'')');
                execSQL;
              except
              end;


            // 02.03.2013 Ingmar;
            if pSchemaVer <= 1023 then
              try
                Close;
                Clear;
                add('alter table bills');
                add('add billhash  varchar(255) NOT NULL DEFAULT ''''');
                execSQL;

                Close;
                Clear;
                add('alter table client');
                add('add billtemplate_path  varchar(255) NOT NULL DEFAULT ''''');
                execSQL;

                Close;
                Clear;
                add('alter table client');
                add('add reserved2 varchar(255) NOT NULL DEFAULT ''''');
                execSQL;

              except
              end;


            // 06.05.2013 Ingmar; kasutajad väidavad, et olin ära unustanud sentemails tabelile õigused anda
            if pSchemaVer <= 1024 then
              try
                Close;
                Clear;
                add('GRANT SELECT,UPDATE,INSERT ON sentemails TO estbk_role');
                execSQL;
              except
              end;

            // 05.05.2014 Ingmar; natuke lisavälju
            if pSchemaVer <= 1025 then
            begin

              // @@@
              try

                Close;
                Clear;
                add('ALTER TABLE articles');
                Add('ADD disp_web_dir ' + TEstbk_MapDataTypes.__MapModBoolean() + ' NOT NULL DEFAULT ''f''');
                execSQL;
                // --
                Close;
                Clear;
                Add('CREATE INDEX articles_disp_web_dir ON articles(disp_web_dir)');
                execSQL;

                Close;
                Clear;
                add('ALTER TABLE bills');
                add('ADD bill_source_ptn  ' + TEstbk_MapDataTypes.__MapVarCharType(100) + ' NOT NULL DEFAULT ''''');
                execSQL;
              except
              end;

            end;


            // 19.04.2015 Ingmar; nüüd see autokäibemaksu jura, kus tohid vaid POOL maha arvata, peame kontoplaanid ära korrastama
            if pSchemaVer <= 1026 then
            begin

              // @@@
              try

                Close;
                Clear;
                add('ALTER TABLE bill_lines');
                add('ADD vat_cperc  ' + TEstbk_MapDataTypes.__MapMoneyType() + ' NOT NULL DEFAULT 100');
                execSQL;

                Close;
                Clear;
                Add('INSERT INTO accounts(account_coding,account_name,init_balance,curr_balance,type_id,typecls_id,valid,company_id,default_currency)');
                Add('SELECT ''20112111'',''Ostu KM 100% autokuludelt'',0.00,0.00,a.type_id,a.typecls_id,''t'',a.company_id,a.default_currency');
                Add('FROM accounts a');
                Add('WHERE a.account_coding = ''2011211''');
                Add('  AND NOT EXISTS(SELECT 1 FROM accounts a1 WHERE a1.account_coding = ''20112111'' AND a1.company_id = a.company_id)');
                execSQL;

                Close;
                Clear;
                Add('INSERT INTO accounts(account_coding,account_name,init_balance,curr_balance,type_id,typecls_id,valid,company_id,default_currency)');
                Add('SELECT ''20112112'',''Ostu KM 50% autokuludelt'',0.00,0.00,a.type_id,a.typecls_id,''t'',a.company_id,a.default_currency');
                Add('FROM accounts a');
                Add('WHERE a.account_coding = ''2011211''');
                Add('  AND NOT EXISTS(SELECT 1 FROM accounts a1 WHERE a1.account_coding = ''20112112'' AND a1.company_id = a.company_id)');
                execSQL;

              except
              end;

            end; // --

            if pSchemaVer <= 1029 then
              try
                Close;
                Clear;
                add('GRANT SELECT,UPDATE,INSERT ON sepafile TO estbk_role');
                execSQL;

                Close;
                Clear;
                add('GRANT SELECT,UPDATE,INSERT ON sepafileentry TO estbk_role');
                execSQL;

              except
              end;

     {
     if pSchemaVer<=1020 then
      try
       try
       close;
       clear;
       add('DROP TRIGGER acc_uniq_nr_trig ON accounting_register;');
       execSQL;
       except
       end;
       // ---
       close;
       clear;
       add('CREATE TRIGGER acc_uniq_nr_trig_ins');
       add('BEFORE INSERT');
       add('ON accounting_register');
       add('FOR EACH ROW');
       add('EXECUTE PROCEDURE acc_uniq_nrv_fnc();');
       execSQL;

       // --
       close;
       clear;
       add('CREATE TRIGGER acc_uniq_nr_trig_upt');
       add('AFTER UPDATE');
       add('ON accounting_register');
       add('FOR EACH ROW');
       add('EXECUTE PROCEDURE acc_uniq_nrv_fnc();');
       execSQL;

      except
      end;}
            // -->
            // !!!!!!!!!!!!!!!!!
            // uuendame schema nr ära !
            // !!!!!!!!!!!!!!!!!



            Close;
            Clear;
            add('UPDATE conf');
            add('SET var_misc=:var_misc');
            add('WHERE var_name=''estbk_schemaver''');
            paramByname('var_misc').AsString := IntToStr(estbk_types.CCurrentDatabaseSchemaId);
            execSQL;

            // 01.09.2011 Ingmar; on olukord, kus installis ei õnnestu konfi lisada, siis jääbki igavesti uuendama !
            if rowsAffected < 1 then
            begin
              Close;
              Clear;
              add('INSERT INTO conf(var_name,var_misc,var_val)');
              add(format('VALUES(''estbk_schemaver'',''%s'','''')', [IntToStr(estbk_types.CCurrentDatabaseSchemaId)]));
              execSQL;
            end;


            // ----
            messageDlg(estbk_strmsg.SCUpgradeCompleted, mtInformation, [mbOK], 0);
          end; // @@@UPTEND

        finally
          Close;
          Clear;
          estbk_datamodule.admDatamodule.admTempQuery.ParamCheck := pParamCheck;
        end;

        estbk_datamodule.admDatamodule.admConnection.Commit;
      except
        on e: Exception do
        begin
          if estbk_datamodule.admDatamodule.admConnection.InTransaction then
            try
              estbk_datamodule.admDatamodule.admConnection.Rollback;
            except
            end;

          messageDlg(format(SEStructUpgradeFailed, [e.message]), mtError, [mbOK], 0);
        end;
        // ---
      end;

end;

end.
