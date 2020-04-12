unit estbk_debugwnd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, estbk_types;

type

  { Tform_debug }

  Tform_debug = class(TForm)
    Memo1: TMemo;
  private
    { private declarations }
  public
    function showmodal(const pLog: TAStrList): boolean; reintroduce;
  end;

var
  form_debug: Tform_debug;

implementation

function Tform_debug.showmodal(const pLog: TAStrList): boolean;
begin
  Memo1.Lines.Assign(pLog);
  Result := inherited showmodal = mrOk;

end;

initialization
  {$I estbk_debugwnd.ctrs}

end.
