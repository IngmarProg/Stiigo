unit estbk_debugwnd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls,estbk_types;

type

  { Tform_debug }

  Tform_debug = class(TForm)
    Memo1: TMemo;
  private
    { private declarations }
  public
    function showmodal(const pLog : TAStrList):Boolean;reintroduce;
  end; 

var
  form_debug: Tform_debug;

implementation

function Tform_debug.showmodal(const pLog : TAStrList):Boolean;
begin
  Memo1.Lines.Assign(pLog);
  result:=inherited showmodal=mrok;

end;

initialization
  {$I estbk_debugwnd.ctrs}

end.

