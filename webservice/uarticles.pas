{$M+}
unit UArticles;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, UBase, estbk_types;

type
  TArticles = class(TBase)
  protected
    FID   : Integer;
    FCode : AStr;
    FName : AStr;
    FBarCode : AStr;
    FUnit  : AStr;
    FDescr : AStr;
    FURL   : AStr;
    FPrice : Double;
    function buildDefaultWhere(const pOvr : AStr = '') : AStr;override;
    function buildDefaultOrderBy(const pOvr : AStr = '') : AStr;override;
    class function createRemappedFields : TAStrList; override;
  published
    property ID : Integer read FId write FId;
    property Code : AStr read FCode write FCode;
    property Name : AStr read FName write FName;
    property ArtUnit : AStr read FUnit write FUnit;
    property BarCode : AStr read FBarCode write FBarCode;
    property Descr : AStr read FDescr write FDescr;
    property Url : AStr read FURL write FURL;
    // TODO
    //property Price : Double read FPrice write FPrice;
  public
    constructor Create;override;
  end;

implementation
uses estbk_globvars;

constructor TArticles.Create;
begin
   Inherited Create;
end;

class function TArticles.createRemappedFields : TAStrList;
begin
   Result := TAStrList.Create;
   Result.Add('unit=artunit');
end;

function TArticles.buildDefaultWhere(const pOvr : AStr = '') : AStr;
begin
   // NB see default tingimus PEAB alati jääma !
   Result := 'company_id=' + inttostr(estbk_globvars.glob_company_id) +
     ' AND disp_web_dir=''t'' AND rec_deleted=''f'' AND special_type_flags=0' + pOvr;
end;

function TArticles.buildDefaultOrderBy(const pOvr : AStr = '') : AStr;
begin
if pOvr = '' then
   Result := ' name ASC ';
end;

initialization
   RegisterClass(TArticles);
end.

