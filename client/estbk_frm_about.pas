unit estbk_frm_about;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, EditBtn,estbk_types;

type


  { TformAbout }

  TformAbout = class(TForm)
    closeImg: TImage;
    pStiigoPath: TEdit;
    Image1: TImage;
    Label1: TLabel;
    lblOpenStiigoUrl: TLabel;
    lblCopyright: TLabel;
    lblVersion: TLabel;
    pCpPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure closeImgClick(Sender: TObject);
    procedure lblOpenStiigoUrlDblClick(Sender: TObject);
  private
  public
  end;
(*

  LCLVersion, ...
...
{$IF (lcl_major > 0) OR (lcl_minor > 9) OR ((lcl_minor = 9) AND (lcl_release >= 31))}

  //estbk_formchoosecustmer.__chooseCustomer(pInt1,pdata,pdata1);
  //showmessage(pdata1);
  // http://www.freepascal.org/docs-html/prog/progsu38.html
  pdata := 'Kompilaatori ver: ' +
  {$I %FPCVERSION%}
    +#13#10;
  pdata := pdata + 'CPU tüüp: ' +
  {$I %FPCTARGET%}
    +#13#10;
  pdata := pdata + 'Op.sys  : ' +
  {$I %FPCTARGETOS%}
    +#13#10;
  pdata := pdata + 'Kompileeritud : ' +
  {$I %DATE%}
    +#13#10;
*)
//      CAppVersion
var
  formAbout: TformAbout;

implementation
uses estbk_main,estbk_uivisualinit,estbk_utilities,LCLIntf;
{ TformAbout }

procedure TformAbout.FormCreate(Sender: TObject);
begin
 estbk_uivisualinit.__preparevisual(self);
 self.pCpPanel.Color:=estbk_types.MyFavGray;
 self.lblVersion.Caption:=estbk_main.CAppVersion;
 Label1.Font.Style:=[fsbold];
 lblVersion.Font.Style:=[fsbold];
 lblCopyright.Caption:=estbk_utilities._softwareCreator+' © '+estbk_utilities._softwareCopyrightYearRange;
 pStiigoPath.Text:=extractFilepath(ParamStr(0));

end;


procedure TformAbout.closeImgClick(Sender: TObject);
begin
 self.Close;
end;

procedure TformAbout.lblOpenStiigoUrlDblClick(Sender: TObject);
begin
  LCLIntf.OpenURL(TLabel(Sender).Caption);
end;

initialization
  {$I estbk_frm_about.ctrs}

end.

