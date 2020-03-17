unit Ubase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, estbk_types;

type
  TBase = class(TPersistent)
  protected
    FDataListing: TObjArray; // viimane objektide select
    function buildDefaultWhere(const pOvr: AStr = ''): AStr; virtual; abstract;
    function buildDefaultOrderBy(const pOvr: AStr = ''): AStr; virtual; abstract;
    // *** create on call
    class function createRemappedFields: TAStrList; virtual; abstract; // ntx unit artikli puhul ei saa prop. sellise nimega kasutada;
  public
    function getData(const pConnection: ZConnection.TZConnection; const pOfs: integer = 0; const pLimit: integer = 100;
      const pQField: AStr = '';
    // mille järgi otsitakse; ntx object name=%aaa%
      const pOrderByDir: AStr = 'asc'; const pOrderByField: AStr = ''; const pSQLFieldsOverride: AStr = ''): TObjArray;
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
  end;

implementation

uses UTools, ZDataset, uarticles;

constructor TBase.Create;
begin
  inherited Create;
end;

function TBase.getData(const pConnection: ZConnection.TZConnection; const pOfs: integer = 0; const pLimit: integer = 100;
  const pQField: AStr = ''; const pOrderByDir: AStr = 'asc'; const pOrderByField: AStr = ''; const pSQLFieldsOverride: AStr = ''): TObjArray;
var
  pSQL: AStr;
  pQuery: ZDataset.TZReadOnlyQuery;
  pSQLFull, pWhere, pOrderBy, pPropName: AStr;
  pParseList, pRemapFields: TAStrList;
  i, j, arrindx: integer;
  pCommonBase: TBase;
begin
  Result := nil;
  pRemapFields := self.createRemappedFields;

  if pSQLFieldsOverride <> '' then
    pSQL := pSQLFieldsOverride
  else
    try
      pParseList := TAStrList.Create;



      pParseList.Delimiter := ',';
      pParseList.DelimitedText := AnsiLowerCase(ClassFieldNamesAsSQL(Self));
      for i := 0 to pParseList.Count - 1 do
      begin
        for j := 0 to pRemapFields.Count - 1 do
          if pRemapFields.ValueFromIndex[j] = pParseList.Strings[i] then
            pParseList.Strings[i] := pRemapFields.Names[j];
      end;

      pSQL := pParseList.DelimitedText;
      // pSQL := AnsiLowerCase(ClassFieldNamesAsSQL(Self));
    finally
      FreeAndNil(pParseList);
    end;


  try
    pQuery := ZDataset.TZReadOnlyQuery.Create(nil);
    pQuery.Connection := pConnection;

    pWhere := ''; // pQFieldi puhul täpsustada !
    pWhere := Self.buildDefaultWhere(pWhere);
    pOrderBy := Self.buildDefaultOrderBy(pOrderByField);
    pSQLFull := 'SELECT ' + pSQL + ' FROM ' + Copy(Self.ClassName, 2, 255) + ' WHERE ' + pWhere + ' ORDER BY ' + pOrderBy;
    pSQLFull := pSQLFull + format('LIMIT %d OFFSET %d', [pLimit, pOfs]);

    pQuery.SQL.Text := pSQLFull;
    pQuery.Open;
    pQuery.First;
    if pQuery.RecordCount > 0 then
      SetLength(Self.FDataListing, pQuery.RecordCount);

    arrindx := low(Self.FDataListing);
    while not pQuery.EOF do
    begin
      pCommonBase := FindClass(Self.ClassName).Create as TBase;

      for i := 0 to pQuery.Fields.Count - 1 do
      begin
        pPropName := pQuery.Fields.Fields[i].FieldName;
        if pRemapFields.Values[pPropName] <> '' then
          pPropName := pRemapFields.Values[pPropName];

        UTools.SetClassFieldProp(pCommonBase, pPropName, pQuery.Fields.Fields[i].Value);
      end;


      Self.FDataListing[arrindx] := pCommonBase;
      Inc(arrindx);
      pQuery.Next;
    end;


    pQuery.Close;
  finally
    FreeAndNil(pQuery);
    FreeAndNil(pRemapFields);
  end;

  Result := Self.FDataListing;
end;


destructor TBase.Destroy;
var
  i: integer;
begin
  if Assigned(FDataListing) then
    for i := low(FDataListing) to high(FDataListing) do
      if assigned(FDataListing[i]) then
      begin
        FDataListing[i].Free;
        FDataListing[i] := nil;
      end;

  inherited Destroy;
end;

initialization
  RegisterClass(TBase);
end.