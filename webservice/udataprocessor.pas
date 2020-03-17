unit UDataprocessor;

{$mode objfpc}{$H+}

interface
uses Classes, SysUtils, ZConnection, estbk_types, UTools;

type
 TCdatatoprocess = (_dcarticles);

type
  TDataprocessorCommon = class(TObject)
  protected
    FDataType : TCdatatoprocess;
    FSortField : AStr;
    FSortOrd : AStr;
    FSearchParam : AStr;
    FSearchField : AStr;
    FLimit : Integer;
    FOffset: Integer;
  public
    constructor create(const pSortField : Astr = '';
                       const pSortOrd : Astr = 'asc';
                       const pSearchParam : AStr = '';
                       const pLimit : Integer = 500;
                       const pOffset : Integer = 0);reintroduce;
  end;

type
  TDataprocessorReader = class(TDataprocessorCommon)
  protected
    FJSONData : AStr;
    FConnection : ZConnection.TZConnection;
  public
    property ConnectionToUse : ZConnection.TZConnection read FConnection write FConnection;
    property JSONdata : AStr read FJSONData;
  end;

const
 SEObjectNotFound = 'Object not found';

function GenerateReader(const pConnectionToUse : ZConnection.TZConnection;
                        const pClassname : AStr;
                        const pSortField : Astr = '';
                        const pSortOrd : Astr = 'asc';
                        const pSearchParam : AStr = '';
                        const pLimit : Integer = 500;
                        const pOffset : Integer = 0) : TDataprocessorReader;

implementation
uses UArticles, UBase;

constructor TDataprocessorCommon.create(const pSortField : Astr = '';
                                        const pSortOrd : Astr = 'asc';
                                        const pSearchParam : AStr = '';
                                        const pLimit : Integer = 500;
                                        const pOffset : Integer = 0);
begin
 inherited Create;
 FSortField := pSortField;
 FSortOrd := pSortOrd;
 FSearchParam := pSearchParam;
 FLimit := pLimit;
 FOffset := pOffset;
end;

// @@@
function GenerateReader(const pConnectionToUse : ZConnection.TZConnection;
                        const pClassname : AStr;
                        const pSortField : Astr = '';
                        const pSortOrd : Astr = 'asc';
                        const pSearchParam : AStr = '';
                        const pLimit : Integer = 500;
                        const pOffset : Integer = 0) : TDataprocessorReader;
var
   pDstClass : TPersistent;
begin
    Result := nil;
 try
    pDstClass := FindClass('T'+pClassname).Create; // exception kui pole
    Result := TDataprocessorReader.Create(pSortField,pSortOrd,pSearchParam,pLimit,pOffset); // peab vabastama !
    Result.ConnectionToUse := pConnectionToUse;
    Result.FJSONData := ClassToJSON(TBase(pDstClass).getData(Result.ConnectionToUse,pOffset,pLimit,pSearchParam,pSortOrd,pSortField));
 finally
    pDstClass.Free;
 end;
end;

end.

