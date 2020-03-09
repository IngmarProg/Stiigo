unit estbk_lib_commonaccprop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, ZSqlUpdate, estbk_types;

type
  TCommonAccprop = class
  protected
    FSystemDocumentIds: estbk_types.TSystemDocIdArr;
    FSystemDocumentLongName: estbk_types.TSystemDocStrArr;
    FSystemAccountIds: estbk_types.TSystemAccIdArr;
    FSystemAccountLongName: estbk_types.TSystemAccAStrArr; // nimi, mis on omistatud kontole kasutaja poolt !!!
    FSystemAccountCurr: estbk_types.TSystemAccAStrArr;

    function getDocumentId(index: TSystemDocType): integer;
    procedure setDocumentId(index: TSystemDocType; Value: integer);
    function getDocumentLongname(Index: TSystemDocType): AStr;
    procedure setDocumentLongname(Index: TSystemDocType; Value: AStr);
    function getAccountId(index: TSystemAccType): integer;
    procedure setAccountId(index: TSystemAccType; Value: integer);
    function getAccountLongname(index: TSystemAccType): AStr;
    procedure setAccountLongname(index: TSystemAccType; Value: AStr);
    function getAccountCurr(index: TSystemAccType): AStr;
    procedure setAccountCurr(index: TSystemAccType; Value: AStr);
  public

    property sysDocumentId[Index: TSystemDocType]: integer read getDocumentId write setDocumentId;
    property sysDocumentLongName[Index: TSystemDocType]: AStr read getDocumentLongname write setDocumentLongname;


    // kontod; teha üks property ja läbi klassi ? las hetkel olla
    property sysAccountId[Index: TSystemAccType]: integer read getAccountId write setAccountId;
    property sysAccountLongName[Index: TSystemAccType]: AStr read getAccountLongname write setAccountLongname;
    property sysAccountCurr[Index: TSystemAccType]: AStr read getAccountCurr write setAccountCurr;

    // load
    procedure loadDocumentList(const pQry: TZQuery);
    procedure loadDefaultSysAccounts(const pQry: TZQuery);
  end;

var
  _ac: TCommonaccprop;

implementation

uses estbk_sqlclientcollection, estbk_globvars;

procedure TCommonAccprop.loadDocumentList(const pQry: TZQuery);
var
  pOrd: byte;
  i: TSystemDocType;
begin
  with pQry, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectSysDocuments);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;

      First;
      while not EOF do
      begin

        for i := low(TSystemDocType) to high(TSystemDocType) do
          if AnsiUpperCase(estbk_types.CSystemDocStrArr[i]) = AnsiUpperCase(trim(FieldByName('shortidef').AsString)) then
          begin
            //self.sysDocumentId[i]:=fieldByname('id').AsInteger;
            //self.sysDocumentLongName[i]:=fieldbyname('docname').AsString;

            estbk_lib_commonaccprop._ac.sysDocumentId[i] := FieldByName('id').AsInteger;
            estbk_lib_commonaccprop._ac.sysDocumentLongName[i] := FieldByName('docname').AsString;
            // --
            break;
          end;

        Next;
      end;
    finally
      Close;
      Clear;
    end;

  // 07.03.2011 Ingmar; väljendame siirast rahulolematust !
  assert(Self.sysDocumentId[_dsBankIncomes] > 0, '#2 default documents are undefined !');
end;


procedure TCommonAccprop.loadDefaultSysAccounts(const pQry: TZQuery);
var
  pOrd: byte;
  i: TSystemAccType;
begin
  with pQry, SQL do
    try

      Close;
      Clear;

      // ---------------------------------------------------------------------
      // Laadime vaikimis kontode info !
      // ---------------------------------------------------------------------
      for i := low(TSystemAccType) to high(TSystemAccType) do
      begin
        self.sysAccountId[i] := 0;
        self.sysAccountCurr[i] := '';
        self.sysAccountLongName[i] := '';
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
        pOrd := byte(FieldByName('ordinal_nr').AsInteger);
        if (pOrd >= byte(low(TSystemAccType))) and (pOrd <= byte(high(TSystemAccType))) then
        begin
          self.sysAccountId[TSystemAccType(pOrd)] := FieldByName('account_id').AsInteger;
          // ---
          if FieldByName('currency').AsString <> '' then
            self.sysAccountCurr[TSystemAccType(pOrd)] := FieldByName('currency').AsString
          else
            self.sysAccountCurr[TSystemAccType(pOrd)] := estbk_globvars.glob_baseCurrency;
          self.sysAccountLongName[TSystemAccType(pOrd)] := FieldByName('account_name').AsString;
        end;

        Next;
      end;

    finally
      Close;
      Clear;
    end;
end;


function TCommonAccprop.getDocumentId(index: TSystemDocType): integer;
begin
  Result := FSystemDocumentIds[index];
end;

procedure TCommonAccprop.setDocumentId(index: TSystemDocType; Value: integer);
begin
  FSystemDocumentIds[index] := Value;
end;

function TCommonAccprop.getAccountId(index: TSystemAccType): integer;
begin
  Result := FSystemAccountIds[index];
end;

procedure TCommonAccprop.setAccountId(index: TSystemAccType; Value: integer);
begin
  FSystemAccountIds[index] := Value;
end;


function TCommonAccprop.getDocumentLongname(Index: TSystemDocType): AStr;
begin
  Result := FSystemDocumentLongName[index];
end;


procedure TCommonAccprop.setDocumentLongname(Index: TSystemDocType; Value: AStr);
begin
  FSystemDocumentLongName[index] := Value;
end;



function TCommonAccprop.getAccountLongname(index: TSystemAccType): AStr;
begin
  // --
  Result := FSystemAccountLongName[index];
end;

procedure TCommonAccprop.setAccountLongname(index: TSystemAccType; Value: AStr);
begin
  // --
  FSystemAccountLongName[index] := Value;
end;


function TCommonAccprop.getAccountCurr(index: TSystemAccType): AStr;
begin
  Result := self.FSystemAccountCurr[index];
end;


procedure TCommonAccprop.setAccountCurr(index: TSystemAccType; Value: AStr);
begin
  self.FSystemAccountCurr[index] := Value;
end;


initialization
  _ac := TCommonAccprop.Create;

finalization
  _ac.Free;
  _ac := nil;
end.
