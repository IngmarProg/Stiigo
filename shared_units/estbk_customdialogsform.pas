unit estbk_customdialogsform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons,estbk_types, estbk_frm_template;

type

  { TformCustomDialog }

  TformCustomDialog = class(TfrmTemplate)
    btnYes: TBitBtn;
    btnNo: TBitBtn;
    ChkBxRemdecision: TCheckBox;
    GroupBox1: TGroupBox;
    lblExplain: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    // 25.08.2009 ingmar; lihtsa kui dialoog küsib, kas jätame otsuse meelde ning järgmine kord ei küsi;
    // siis välja kutsudes seda ei tehta
    function showmodal(const dialogCaption  : AStr;
                       const dialogLongText : AStr;
                       const decisionChkBoxVisible     : Boolean;
                       var   decisionDontDisplayDialog : Boolean):boolean;overload;reintroduce; // ... kui true...siis YES val
    function showmodal(const dialogCaption  : AStr;
                       const dialogLongText : AStr):boolean;overload;reintroduce;
  end; 

// -----------------------
function simpleYesNoDialogExt(const dialogCaption  : AStr;
                              const dialogLongText : AStr;
                              const decisionChkBoxVisible     : Boolean;
                              var   decisionDontDisplayDialog : Boolean):Boolean;

function simpleYesNoDialog(const dialogCaption  : AStr;
                           const dialogLongText : AStr):Boolean;

implementation
uses estbk_strmsg;
// ---

function simpleYesNoDialogExt(const dialogCaption  : AStr;
                              const dialogLongText : AStr;
                              const decisionChkBoxVisible     : Boolean;
                              var   decisionDontDisplayDialog : Boolean):Boolean;
var
   pCstDialog : TformCustomDialog;
begin
 try
   pCstDialog:=TformCustomDialog.Create(nil);
   result:=pCstDialog.showmodal(dialogCaption,dialogLongText,decisionChkBoxVisible,decisionDontDisplayDialog);
 finally
   freeAndNil(pCstDialog);
 end;
end;

function simpleYesNoDialog(const dialogCaption  : AStr;
                           const dialogLongText : AStr):Boolean;
var
  dummy : Boolean;
begin
  dummy :=false;
  result:=simpleYesNoDialogExt(dialogCaption,
                               dialogLongText,
                               false,
                               dummy);
end;

procedure TformCustomDialog.FormCreate(Sender: TObject);
begin
  btnYes.caption:=estbk_strmsg.SAnswerYes;
  btnNo.caption:=estbk_strmsg.SAnswerNo;
  ChkBxRemdecision.caption:=estbk_strmsg.SRememberdecision;

end;

function TformCustomDialog.showmodal(const dialogCaption  : AStr;
                                     const dialogLongText : AStr;
                                     const decisionChkBoxVisible     : Boolean;
                                     var   decisionDontDisplayDialog : Boolean):boolean;
begin
 if decisionDontDisplayDialog then
    result:=true // kasutaja avaldanud soovi antud dialoogi mitte näha
 else
  begin
    self.ChkBxRemdecision.visible:=decisionChkBoxVisible;
    self.Caption:=dialogCaption;
    lblExplain.Caption:=dialogLongText;
    result:=(inherited showmodal)=mrYes;
    decisionDontDisplayDialog:= self.ChkBxRemdecision.checked;
  end;
end;

function TformCustomDialog.showmodal(const dialogCaption  : AStr;
                                     const dialogLongText : AStr):boolean;
begin
    self.ChkBxRemdecision.visible:=False;
    self.Caption:=dialogCaption;
    lblExplain.Caption:=dialogLongText;
    result:=(inherited showmodal)=mrYes;
end;

initialization
  {$I estbk_customdialogsform.ctrs}

end.

