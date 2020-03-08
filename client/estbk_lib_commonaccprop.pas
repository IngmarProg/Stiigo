unit estbk_lib_commonaccprop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, ZSqlUpdate, estbk_types;


type
  TCommonAccprop = class
  protected
   FSystemDocumentIds     : estbk_types.TSystemDocIdArr;
   FSystemDocumentLongName: estbk_types.TSystemDocStrArr;
   FSystemAccountIds      : estbk_types.TSystemAccIdArr;
   FSystemAccountLongName : estbk_types.TSystemAccAStrArr; // nimi, mis on omistatud kontole kasutaja poolt !!!
   FSystemAccountCurr     : estbk_types.TSystemAccAStrArr;

   function  getDocumentId(index: TSystemDocType): Integer;
   procedure setDocumentId(index: TSystemDocType; value: Integer);
   function  getDocumentLongname(Index : TSystemDocType):AStr;
   procedure setDocumentLongname(Index: TSystemDocType; value: AStr);
   function  getAccountId(index: TSystemAccType): Integer;
   procedure setAccountId(index: TSystemAccType; value: Integer);
   function  getAccountLongname(index: TSystemAccType):AStr;
   procedure setAccountLongname(index: TSystemAccType; value: AStr);
   function  getAccountCurr(index: TSystemAccType):AStr;
   procedure setAccountCurr(index: TSystemAccType; value: AStr);
  public

   property sysDocumentId[Index : TSystemDocType] :Integer read getDocumentId write setDocumentId;
   property sysDocumentLongName[Index : TSystemDocType] :AStr read getDocumentLongname write setDocumentLongname;


   // kontod; teha üks property ja läbi klassi ? las hetkel olla
   property sysAccountId[Index : TSystemAccType] :Integer read getAccountId write setAccountId;
   property sysAccountLongName[Index : TSystemAccType] :AStr read getAccountLongname write setAccountLongname;
   property sysAccountCurr[Index : TSystemAccType] :AStr read getAccountCurr write setAccountCurr;

   // load
   procedure loadDocumentList(const pQry : TZQuery);
   procedure loadDefaultSysAccounts(const pQry : TZQuery);
  end;

var
  _ac : TCommonaccprop;

implementation
uses estbk_sqlclientcollection, estbk_globvars;

procedure TCommonAccprop.loadDocumentList(const pQry : TZQuery);
var
 pOrd : Byte;
 i : TSystemDocType;
begin
 with pQry,SQL do
  try
       close;
       clear;
       add(estbk_sqlclientcollection._SQLSelectSysDocuments);
       paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
       Open;

       First;
   while not EOF do
    begin

    for i:=low(TSystemDocType) to high(TSystemDocType) do
    if  ansiuppercase(estbk_types.CSystemDocStrArr[i])=ansiuppercase(trim(fieldbyname('shortidef').asString)) then
       begin
        //self.sysDocumentId[i]:=fieldByname('id').AsInteger;
        //self.sysDocumentLongName[i]:=fieldbyname('docname').AsString;

        estbk_lib_commonaccprop._ac.sysDocumentId[i]:=fieldByname('id').AsInteger;
        estbk_lib_commonaccprop._ac.sysDocumentLongName[i]:=fieldbyname('docname').AsString;
        // --
        break;
       end;

        next;
    end;
   finally
      close;
      clear;
   end;

   // 07.03.2011 Ingmar; väljendame siirast rahulolematust !
   assert(Self.sysDocumentId[_dsBankIncomes]>0,'#2 default documents are undefined !');
end;


procedure TCommonAccprop.loadDefaultSysAccounts(const pQry : TZQuery);
var
 pOrd : Byte;
 i : TSystemAccType;
begin
 with pQry,SQL do
  try

     close;
     clear;

     // ---------------------------------------------------------------------
     // Laadime vaikimis kontode info !
     // ---------------------------------------------------------------------
 for i:=low(TSystemAccType) to high(TSystemAccType) do
   begin
      self.sysAccountId[i]:=0;
      self.sysAccountCurr[i]:='';
      self.sysAccountLongName[i]:='';
   end;

     // --
     Close;
     Clear;
     Add(estbk_sqlclientcollection._SQLSelectSysAccounts);
     paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
     Open;



     First;

  while not EOF do
  begin
      pOrd:=byte(FieldByname('ordinal_nr').AsInteger);
  if (pOrd>=byte(low(TSystemAccType))) and (pOrd<=byte(high(TSystemAccType))) then
    begin
       self.sysAccountId[TSystemAccType(pOrd)]:=FieldByName('account_id').asInteger;
       // ---
    if FieldByName('currency').asString<>'' then
       self.sysAccountCurr[TSystemAccType(pOrd)]:=FieldByName('currency').asString
    else
       self.sysAccountCurr[TSystemAccType(pOrd)]:=estbk_globvars.glob_baseCurrency;
       self.sysAccountLongName[TSystemAccType(pOrd)]:=FieldByName('account_name').asString;
    end;

      Next;
    end;

  finally
    close;
    clear;
   end;
end;


function  TCommonAccprop.getDocumentId(index: TSystemDocType): Integer;
begin
 result:=FSystemDocumentIds[index];
end;

procedure TCommonAccprop.setDocumentId(index: TSystemDocType; value: Integer);
begin
  FSystemDocumentIds[index]:=value;
end;

function  TCommonAccprop.getAccountId(index: TSystemAccType): Integer;
begin
  result:=FSystemAccountIds[index];
end;

procedure TCommonAccprop.setAccountId(index: TSystemAccType; value: Integer);
begin
  FSystemAccountIds[index]:=value;
end;


function  TCommonAccprop.getDocumentLongname(Index : TSystemDocType):AStr;
begin
  result:=FSystemDocumentLongName[index];
end;


procedure  TCommonAccprop.setDocumentLongname(Index: TSystemDocType; value: AStr);
begin
  FSystemDocumentLongName[index]:=value;
end;



function  TCommonAccprop.getAccountLongname(index: TSystemAccType):AStr;
begin
  // --
  result:=FSystemAccountLongName[index];
end;

procedure TCommonAccprop.setAccountLongname(index: TSystemAccType; value: AStr);
begin
  // --
  FSystemAccountLongName[index]:=value;
end;


function  TCommonAccprop.getAccountCurr(index: TSystemAccType):AStr;
begin
  result:=self.FSystemAccountCurr[index];
end;


procedure TCommonAccprop.setAccountCurr(index: TSystemAccType; value: AStr);
begin
   self.FSystemAccountCurr[index]:=value;
end;


initialization
 _ac := TCommonAccprop.Create;
finalization
 _ac.Free;
 _ac := nil;
end.

