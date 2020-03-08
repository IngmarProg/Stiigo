unit estbk_frm_template;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs;

type
  TfrmTemplate = class(TForm)
  private
  public
    constructor Create(powner: TComponent); reintroduce;
  end;

var
  frmTemplate: TfrmTemplate;

implementation

uses estbk_fra_template, // gnugettext_fpc, gnugettext uus FPC ei toeta seda
  estbk_globvars, estbk_types, estbk_settings, estbk_clientdatamodule;

constructor TfrmTemplate.Create(powner: TComponent);
begin
  inherited Create(owner);
  // translateObject(Self);
end;

initialization
  {$I estbk_frm_template.ctrs}

end.
