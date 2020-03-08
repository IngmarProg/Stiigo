unit estbk_comp_dbgridframe;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, DBGrids,estbk_datamodule;
// 24.08.2009 Ingmar; tunnistan ausalt see frame megatobe, aga dünaamilist tabi teha on parim framega
// saad runtimega asju paika keerata, üldse progemine pole nii hull
// - aga miks gridi ei loonud käsitsi, naljakas probleem. TGridColumn, aga fieldname properti nähtamatu;
// paistab, et mingi 0.9.27 bugi; eks siis teeb tobeda frame
type

  { TFrameCompanyList }

  TFrameCompanyList = class(TFrame)
  private
    { private declarations }
  public
    { public declarations }
  end; 

implementation

initialization
  {$I estbk_comp_dbgridframe.ctrs}

end.

