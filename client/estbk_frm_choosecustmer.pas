unit estbk_frm_choosecustmer;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, estbk_types, estbk_lib_commoncls,
  estbk_fra_customer, estbk_frm_template, ZDataset;

type

  { TformChooseCustomer }

  TformChooseCustomer = class(TfrmTemplate)
    initFocusTimer: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure initFocusTimerTimer(Sender: TObject);
  private
    FframeChooseCustomer : TframeCustomers; // lazarus on täielik õnnetuse hunnik RUNTIME crashib kui vormile frame panna !
    FSaveAndCloseMode    : Boolean;
    // frame koostab klassi !
    FSelectClientWithId  : Integer;
    FClientDataClass     : TClientData;

    FNewClientMode       : Boolean;  // kas automaatselt käivitatakse uue kliendi sisestus
    FNewClientName       : AStr;

    procedure setSaveAndCloseMode(const v : Boolean);
    // kuna kogu elu läbi framede, siis peame forwardima tulemit !
    procedure onClientChoosen(Sender    : TObject; chClientData: TClientData);
    procedure onFrameKillSignal(Sender : TObject);
  public
    property saveAndCloseMode : Boolean  read FSaveAndCloseMode write setSaveAndCloseMode;
  end; 



  function __createClient(const pClientName : AStr):TClientData;
  // kui valikut ei sooritatud, siis NIL; muidu peab päringutulemuse vabastama !
  function __chooseClient(const clientId  : integer; const pSaveAndClose : Boolean = true):TClientData;overload; // custid hetkel ei kasuta
  function __chooseClient(const clientCode  : AStr;const pSaveAndClose : Boolean = true):TClientData;overload;
  function __chooseClient(const clientId  : integer; const pClientName : AStr;const pSaveAndClose : Boolean = true):TClientData;overload; // antud juhul pole klienti defineeritud või soovitakse täpsustada !


implementation

// ----------------------------------------------------------------------------

//pForm.frameChooseCustomerA.Name:='fr'+inttohex(random(99999),8); // mingid imelikud laz. bugid seoses nimedega
//pForm.frameChooseCustomerA.lblEdtClientId.SetFocus;
//pForm.frameChooseCustomerA.currentCustId:=custId;
//pForm.FOpenCustomer:=custId;

function __createClient(const pClientName : AStr):TClientData;
var
 pForm : TformChooseCustomer;
begin
  try
     result:=nil;
     // --
     pForm:=TformChooseCustomer.create(nil);
     pForm.FNewClientMode:=true;
     pForm.FNewClientName:=pClientName;
     pForm.FSelectClientWithId:=0;


 if (pForm.Showmodal=mrOk) then
     result:=pForm.FClientDataClass;

 finally
    freeAndNil(pForm);
 end;
 // ---
end;

function __chooseClient(const clientId  : integer;const pSaveAndClose : Boolean = true):TClientData;
var
 pForm : TformChooseCustomer;
begin

 try
     result:=nil;
     // --
     pForm:=TformChooseCustomer.create(nil);
     pForm.FSelectClientWithId:=clientId;
     pForm.saveAndCloseMode:=pSaveAndClose;

 if (pForm.Showmodal=mrOk) then
     result:=pForm.FClientDataClass;

 finally
    freeAndNil(pForm);
 end;
 // ---
end;


function __chooseClient(const clientCode  : AStr;const pSaveAndClose : Boolean = true):TClientData;
var
 pForm : TformChooseCustomer;
begin

 try
     result:=nil;
     // --
     pForm:=TformChooseCustomer.create(nil);
     pForm.saveAndCloseMode:=pSaveAndClose;
 if (pForm.Showmodal=mrOk) then
     result:=pForm.FClientDataClass;

 finally
    freeAndNil(pForm);
 end;
 // ---
end;


function __chooseClient(const clientId  : integer; const pClientName : AStr;const pSaveAndClose : Boolean = true):TClientData;
var
 pForm : TformChooseCustomer;
begin
 try
     result:=nil;
     // --
     pForm:=TformChooseCustomer.create(nil);
     pForm.FSelectClientWithId:=clientId;
     pForm.saveAndCloseMode:=pSaveAndClose;

 if (pForm.Showmodal=mrOk) then
     result:=pForm.FClientDataClass;

 finally
    freeAndNil(pForm);
 end;
 // ---
end;


// ----------------------------------------------------------------------------
// FRAMEGA seoses paras segadus reziimidega; kui lazaruse framed töötavad korrektselt tee väike refakt.

{ TformChooseCustomer }
procedure TformChooseCustomer.FormCreate(Sender: TObject);
begin
    FframeChooseCustomer := TframeCustomers.Create(Self);
    FframeChooseCustomer.Parent := Self;
    FframeChooseCustomer.onFrameItemChoosen:=@self.onClientChoosen;
    FframeChooseCustomer.onFrameKillSignal:=@self.onFrameKillSignal;

    FframeChooseCustomer.loadData:=true;
    FframeChooseCustomer.saveDataAndClose:=false;   // !!!
    FframeChooseCustomer.chooseCustomerMode:=true;
    FframeChooseCustomer.Align := alClient;
end;


procedure TformChooseCustomer.setSaveAndCloseMode(const v : Boolean);
begin
   self.FSaveAndCloseMode:=v;
   self.FframeChooseCustomer.saveDataAndClose:=v;
end;

procedure TformChooseCustomer.FormActivate(Sender: TObject);
begin
  // --
end;

procedure TformChooseCustomer.FormShow(Sender: TObject);
begin
 if not self.FNewClientMode then
    FframeChooseCustomer.displaySrcTab:=true
 else
    FframeChooseCustomer.displaySrcTab:=false;

    // asi selles, et siis pole veel frame initsialiseeritud !
    //lf.frameChooseCustomerA.currentCustId:=self.FSelectClientWithId;
    initFocusTimer.Enabled:=true;
end;

// FRAME initsialiseerimise probleem !
procedure TformChooseCustomer.initFocusTimerTimer(Sender: TObject);
begin
   TTimer(Sender).Enabled:=false;

if self.FNewClientMode then
   self.FframeChooseCustomer.addNewClient(self.FNewClientName)
else
   self.FframeChooseCustomer.forceFocus(FSelectClientWithId);
end;

procedure TformChooseCustomer.onClientChoosen(Sender    : TObject;
                                              ChClientData: TClientData);
begin
   self.FClientDataClass:=ChClientData;

if assigned(ChClientData) then
   self.ModalResult:=mrOk
else
   self.ModalResult:=mrCancel;
end;

// TEAN, et see on äärmiselt tobe; framded hea tehnoloogia,
// kuid frame peab jõudma ära töödelda selle hiirekliki, muidu AV meil !
procedure TformChooseCustomer.onFrameKillSignal(Sender : TObject);
begin
   self.ModalResult:=mrCancel;
end;

initialization
  {$I estbk_frm_choosecustmer.ctrs}

end.

