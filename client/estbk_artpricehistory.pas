unit estbk_artpricehistory;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms,estbk_uivisualinit,estbk_clientdatamodule,
  estbk_sqlclientcollection, estbk_globvars, estbk_utilities,estbk_types, estbk_strmsg;

type
  TframeArticlePriceHist = class(TFrame)
  private
    { private declarations }
  public
    // ----------------
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  end; 

implementation

constructor TframeArticlePriceHist.create(frameOwner: TComponent);
begin
  // -------
  inherited create(frameOwner);
  // -------
  estbk_uivisualinit.__preparevisual(self);
end;

destructor TframeArticlePriceHist.destroy;
begin
  inherited destroy;
end;


initialization
  {$I estbk_artpricehistory.ctrs}

end.

