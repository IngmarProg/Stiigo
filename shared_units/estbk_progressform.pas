unit estbk_progressform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls,estbk_types;

type

  { Tform_progress }

  Tform_progress = class(TForm)
    Panel1: TPanel;
    prgbar_misc: TProgressBar;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    FautomFormRelease  : Boolean;
    FStatusBarOrigText : AStr;
    FnewStatusBarText  : AStr;
    // ---
  public
    property    statusBarText : AStr read FnewStatusBarText write FnewStatusBarText;
    procedure   show;
    // ---
    constructor create(const form_owner    : TComponent;
                       const startVal  : Integer = 1;
                       const endVal    : Integer = 100;
                       const automFormRelease : Boolean = true);reintroduce;
    procedure   doStepping(const value : Integer = -1);
  end; 

implementation
uses estbk_utilities;

procedure Tform_progress.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
    estbk_utilities._setStatusBarText(self.FStatusBarOrigText);

 if self.FautomFormRelease then
    CloseAction:=caFree;
end;

constructor Tform_progress.create(const form_owner    : TComponent;
                                  const startVal      : Integer = 1;
                                  const endVal        : Integer = 100;
                                  const automFormRelease : Boolean = true);
begin
    inherited create(form_owner);
    self.prgbar_misc.Min:=startVal;
    self.prgbar_misc.Max:=endVal;

    self.FautomFormRelease:=automFormRelease;
end;


procedure Tform_progress.show;
begin
 try
      // 16.08.2009 Ingmar
      // otsime alati esimese taskbari, kuhu viskame info selle kohta...mida progressime...
      // 02.11.2009 Ingmar; adminni all see loogika sobis, aga klient ?!?! pole täitsa kindel, samas ei sega ka   !
      self.FStatusBarOrigText:=estbk_utilities._setStatusBarText(self.FnewStatusBarText);

  if  assigned(application.MainForm) then
   begin
        if not application.MainForm.Visible then
           self.Position:=poDesktopCenter //poScreenCenter
        else
           self.Position:=poMainFormCenter;
   end;

      // ---
      inherited show;

 except
 end;
end;

procedure   Tform_progress.doStepping(const value : Integer = -1);
var
 FNewPos : Integer;
begin
try

     if value>=0 then
        FNewPos:=value
     else
        FNewPos:=self.prgbar_misc.Position+1;

        self.prgbar_misc.Position:=FNewPos;

     if FNewPos>=self.prgbar_misc.Max then
       begin
          sleep(100);
          self.Visible:=false;
       if self.FautomFormRelease then
          self.Close;
       end;

 except
 end; // --
end;

initialization
  {$I estbk_progressform.ctrs}

end.

