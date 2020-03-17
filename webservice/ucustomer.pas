unit UCustomer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, ZConnection, ZDataset, Math, DOM, XMLRead, XMLUtils, DateUtils,
  estbk_utilities, estbk_types, estbk_globvars, estbk_lib_commoncls;

type
  TCustomer = class
  public
    class function createUpdate(const pConn: TZConnection; const pXML: AStr; const pID: integer = 0): AStr;
  end;


implementation

uses estbk_sqlclientcollection, estbk_crc32;

class function TCustomer.createUpdate(const pConn: TZConnection; const pXML: AStr; const pID: integer = 0): AStr;
var
  doc: TXMLDocument;
  root, node: TDOMNode;
  nodename: AStr;
  i, j, pcountryid, pcountyid, pclientid, pcityid, pstreetid: integer;
  pQry: TZQuery;
  pregcode, pvatnr, pfirstname, pfullname, plastname, pemail, pphone, pcountry, pcounty, pcity, pstreet, phousenr,
  papartmentnr, pzipcode, pcountrycode, pSQL: AStr;
  s: TStringStream;
  pCRC32: DWord;
begin
  try
    pQry := TZQuery.Create(nil);
    pQry.Connection := pConn;

    doc := nil;
    s := TStringStream.Create(pXML);
    ReadXMLFile(doc, s);

    root := doc.FirstChild;
    if not Assigned(root) or (AnsiLowerCase(root.Nodename) <> 'customer') then
      raise Exception.Create('Customer tag is missing !');

    for i := 0 to root.ChildNodes.Count - 1 do
    begin
      node := root.ChildNodes.Item[i];
      nodename := AnsiLowerCase(node.NodeName);
      if nodename = 'regcode' then
        pregcode := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'vatnr' then
        pvatnr := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'firstname' then
        pfirstname := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'lastname' then
        plastname := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'email' then
        pemail := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'phone' then
        pphone := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'country' then
        pcountry := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'county' then
        pcounty := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'city' then
        pcity := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'street' then
        pstreet := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'housenr' then
        phousenr := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'apartmentnr' then
        papartmentnr := trim(Utf8Encode(node.TextContent))
      else
      if nodename = 'zipcode' then
        pzipcode := trim(Utf8Encode(node.TextContent));
    end;

    pfullname := trim(pfirstname + plastname);
    if pfullname = '' then
      raise Exception.Create('Customer name is missing ');

    pcountryid := 0;
    pcountyid := 0;
    pcityid := 0;
    pstreetid := 0;
    with pQry, SQL do
      try
        Close;
        Clear;
        pSQL := ' SELECT id, name, shortidef ' + ' FROM classificators ' + ' WHERE type_=''iso3166codes''' +
          '  AND shortidef = :FShortidef' + '  AND company_id IN (0, :FCompanyId)';
        add(pSQL);
        pcountrycode := AnsiUpperCase(Copy(IfThen(pcountry <> '', pcountry, estbk_globvars.Cglob_DefaultCountryCodeISO3166_1), 1, 3));
        ParamByname('FShortidef').AsString := pcountrycode;
        ParamByname('FCompanyId').AsInteger := estbk_globvars.glob_company_id;
        Open;
        pcountryid := FieldByName('id').AsInteger;
        // --

        if pcounty <> '' then
        begin
          Close;
          Clear;
          add('SELECT id');
          add('FROM county');
          add('WHERE LOWER("name")=LOWER(:FName)');
          paramByname('FName').AsString := pcounty;
          Open;
          pcountyid := FieldByName('id').AsInteger;

          if (pcountyid < 1) then
          begin
            pSQL := ' INSERT INTO county(name,countrycode) ' + ' VALUES (:name,:countrycode) ' + ' RETURNING id ';
            Close;
            Clear;
            add(pSQL);
            paramByname('name').AsString := pcounty;
            paramByname('countrycode').AsString := pcountrycode;
            Open;

            pcountyid := FieldByName('id').AsInteger;
          end;
        end;


        if pcity <> '' then
        begin
          Close;
          Clear;
          add('SELECT id');
          add('FROM city');
          add('WHERE LOWER("name")=LOWER(:FName)');
          paramByname('FName').AsString := pcity;
          Open;
          pcityid := FieldByName('id').AsInteger;

          if (pcityid < 1) then
          begin
            pSQL := ' INSERT INTO city(name,countrycode) ' + ' VALUES (UPPER(:name),:countrycode) ' + ' RETURNING id ';
            Close;
            Clear;
            add(pSQL);
            paramByname('name').AsString := pcity;
            paramByname('countrycode').AsString := pcountrycode;
            Open;

            pcityid := FieldByName('id').AsInteger;
          end;
        end;


        if pstreet <> '' then
        begin
          Close;
          Clear;
          add('SELECT id');
          add('FROM street');
          add('WHERE LOWER("name")=LOWER(:FName)');
          paramByname('FName').AsString := pstreet;
          Open;
          pstreetid := FieldByName('id').AsInteger;

          if (pstreetid < 1) then
          begin
            pSQL := ' INSERT INTO street(name,countrycode) ' + ' VALUES (UPPER(:name),:countrycode) ' + ' RETURNING id ';
            Close;
            Clear;
            add(pSQL);
            paramByname('name').AsString := pstreet;
            paramByname('countrycode').AsString := pcountrycode;
            Open;

            pstreetid := FieldByName('id').AsInteger;
          end;
        end;



        pCRC32 := 0;
        if pfullname <> '' then
          estbk_crc32.CRC32(@pfullname[1], length(pfullname), pCRC32);

        Close;
        Clear;
        pClientid := pId;
        if (pClientid < 1) then
        begin
          Close;
          Clear;
          Add('SELECT nextval(''client_id_seq'')  as nextid');
          Open;
          pclientid := FieldByName('nextid').AsInteger;


          pSQL := ' INSERT INTO client(id,ctype,countrycode,name, middlename, lastname, regnr, county_id, ' +
            ' city_id, street_id, house_nr, apartment_nr, zipcode, phone, mobilephone,fax,webpage, ' +
            ' email, notes, company_id, rec_changed, rec_changedby,' +
            ' rec_addedby,srcval,client_code,vatnumber,postal_addr,type_,payment_duetime,' +
            ' credit_limit,bank_account1,bank_id1) ' +
            ' VALUES(:id,:ctype,:countrycode,UPPER(:custname),:middlename,UPPER(:lastname),:regnr,:county_id, ' +
            ' :city_id,:street_id,:house_nr,:apartment_nr,:zipcode,:phone,:mobilephone,:fax,:webpage, ' +
            ' :email,:notes,:company_id, :rec_changed,:rec_changedby, :rec_addedby,' +
            ' :srcval,:client_code,:vatnumber,:postal_addr,:type_,:payment_duetime,' + ' :credit_limit,:bank_accounts,:bank_id) ';

          Close;
          Clear;
          Add(pSQL);
          ParamByname('id').AsInteger := pclientid;
          ParamByname('ctype').AsString := 'P';
          ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          ParamByname('client_code').AsString := IntToStr(pclientid);
          ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        end
        else
        begin
          pSQL := ' UPDATE client ' + ' SET countrycode=:countrycode,name=UPPER(:custname), ' +
            ' middlename=UPPER(:middlename), lastname=UPPER(:lastname), regnr=:regnr,' +
            ' county_id=:county_id, city_id=:city_id, street_id=:street_id, house_nr=:house_nr,notes=:notes,' +
            ' apartment_nr=:apartment_nr,zipcode=:zipcode, phone=:phone, mobilephone=:mobilephone,' +
            ' fax=:fax, email=:email, postal_addr=:postal_addr, type_=:type_, payment_duetime=:payment_duetime,' +
            ' credit_limit=:credit_limit,  bank_account1=:bank_accounts,bank_id1=:bank_id,webpage=:webpage,' +
            ' rec_changed=:rec_changed, rec_changedby=:rec_changedby,srcval=:srcval,vatnumber=:vatnumber ' + ' WHERE id=:id';
          Close;
          Clear;
          Add(pSQL);
          ParamByname('id').AsInteger := pclientid;
        end;


        ParamByname('countrycode').AsString := pcountrycode;
        ParamByname('custname').AsString := pfullname;
        ParamByname('middlename').AsString := '';
        ParamByname('lastname').AsString := '';
        ParamByname('regnr').AsString := pregcode;
        ParamByname('county_id').AsInteger := pcountyid;
        ParamByname('city_id').AsInteger := pcityid;
        ParamByname('street_id').AsInteger := pstreetid;
        ParamByname('house_nr').AsString := phousenr;
        ParamByname('apartment_nr').AsString := papartmentnr;
        ParamByname('zipcode').AsString := pzipcode;
        ParamByname('phone').AsString := pphone;
        ParamByname('mobilephone').AsString := '';
        ParamByname('fax').AsString := '';
        ParamByname('webpage').AsString := '';
        ParamByname('postal_addr').AsString := '';
        ParamByname('type_').AsString := '';


        ParamByname('email').AsString := pemail;
        ParamByname('notes').AsString := ''; // TODO
        ParamByname('rec_changed').AsDateTime := now;
        ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        ParamByname('srcval').AsLargeInt := pCRC32;
        ParamByname('vatnumber').AsString := pvatnr;
        ParamByname('payment_duetime').AsInteger := 0;
        ParamByname('credit_limit').AsInteger := 0;
        ParamByname('bank_accounts').AsString := '';
        ParamByname('bank_id').AsInteger := 0;
        ExecSQL;


        Result := IntToStr(pclientid);

      finally
        Close;
        Clear;
      end;

  finally
    FreeAndNil(pQry);
    FreeAndNil(s);
  end;
end;



end.