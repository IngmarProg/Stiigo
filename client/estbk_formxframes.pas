unit estbk_formxframes;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}


interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms,Buttons, Controls, Graphics, Dialogs,ComCtrls,TypInfo,Messages,EditBtn,DbCtrls,estbk_uivisualinit,
  LCLProc, LCLType, ExtCtrls, StdCtrls,estbk_utilities,estbk_lib_commonevents,estbk_clientdatamodule,estbk_fra_configureaccounts,
  estbk_types,estbk_strmsg,estbk_fra_articles,estbk_fra_generalledger,estbk_fra_genledgerentrys,estbk_fra_bills,estbk_fra_orders,estbk_fra_formdrez,
  estbk_fra_createmodaccounts,estbk_fra_objects,estbk_fra_genledgreportcriterias,estbk_fra_payment_list,estbk_fra_incomings_list,estbk_fra_docfilesmgr,
  estbk_fra_incomings_edit,estbk_reportconst,estbk_fra_bill_list,estbk_fra_order_list,estbk_fra_banks,estbk_fra_debtorlist,estbk_fra_appsettings,
  estbk_fra_cashregister,estbk_frm_about,estbk_fra_customer,estbk_fra_warehouse,estbk_fra_payment_information, estbk_fra_cashbook,
  SMNetGradient,estbk_fra_personalcardlist,estbk_fra_personalcard,estbk_fra_workcontract,estbk_fra_employee_wagetemplate,
  estbk_frm_template;



{
type
  TXFormUseFrame = (_frTest,            // jätsin ühe testframe sisse võimalike lazbugide leidmiseks !
                    _frPaymentOrder,    // reserveeritud !
                    _frFormulaCreator
                    );
}
type

  { TformXFrames }

  TformXFrames = class(TfrmTemplate)
    Image1: TImage;
    psCaptPanel: TNetGradient;
    pnMaincontainer: TPanel;
    waitAndKillTimer: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure loadDataTimerTimer(Sender: TObject);
    procedure waitAndKillTimerTimer(Sender: TObject);
  private

  protected
    FUseFrame    : TCSModules;
    FActiveFrame : TFrame;
    FFreeOnClose : Boolean;
    FInitDone    : Boolean;
    FStrRez      : AStr;
    FIntRez      : Integer;
    // ---
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FautoLoadData       : Boolean;
    FautoCreateNewEntry : Boolean;
//     FParentKeyNotif : TKeyNotEvent;
    // ---
    procedure   frameKillSignal(Sender: TObject);
    procedure   frameDataEventSignal(Sender: TObject; evSender: TFrameEventSender; itemId: Int64; data : Pointer);

    procedure   downloadCurrData(Sender: TObject; currDt: TDatetime);
    // ---
    procedure   createparams(var Params: TCreateParams);override;
    procedure   doCaptRename(const pCmp : TComponent);
    procedure   doLoadData;
  public

    //    procedure   WMNCACTIVATE(var Msg: TWMNCActivate) ; message WM_NCACTIVATE;
    // saadab signaali välja ! forwarder
    property    onFrameDataEvent: TFrameReqEvent Read FFrameDataEvent Write FFrameDataEvent;
    property    onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    // 15.02.2011 Ingmar; kas laeme ka frame andmed
    property    autoLoadData : Boolean read FautoLoadData write FautoLoadData;
    property    autoCreateNewEntry : Boolean read FautoCreateNewEntry write FautoCreateNewEntry; // kui ntx vaja luua uue arve sisestamise vaade


    // frame poolt tagastatud str väärtus ! samut input, kui vaja
    property    strRez : AStr read FStrRez write FStrRez;
    property    intRez : Integer read FIntRez write FIntRez;
    procedure   changeSubCaption(const pCapt : AStr);
    // ---
    function    initForm(const pUseFrame   : TCSModules;
                         const pFormWidth  : Integer = 480;
                         const pFormHeight : Integer = 512):TFrame; // tagastab instansi, läbi mille saame meetoditele ligi
    function    showmodal():boolean;reintroduce;
    procedure   show();reintroduce;

    constructor create(const pCmpowner : TComponent;
                       const pShowModal : Boolean   = false;
                       const pFreeOnClose : Boolean = true);reintroduce;
    destructor  destroy;override;
  end; 

// teavitamiseks peame teadma kõikide objektide instanse; ntx lisame uue rp. objekti, siis peame finantskannete vormi uuendama
var
   glob_fncwnd_slots : Array[TCSModules] of TList;
   glob_fncwnd_finalterm : Boolean = false;


const
   CCaptPanelFontSize = 8;

const
  CFakeCaptSpacing = 4;

implementation
uses
     estbk_fra_paymentorders,estbk_fra_declforms,estbk_fra_declformulacreator,estbk_testframe,estbk_settings,windows;

// http://delphihaven.wordpress.com/2010/04/22/setting-up-a-custom-title-bar-reprise/


constructor TformXFrames.create(const pCmpowner  : TComponent;
                                const pShowModal : Boolean   = false;
                                const pFreeOnClose : Boolean = true);
begin
   inherited create(pCmpowner);
   self.FFreeOnClose:=pFreeOnClose;
   self.FautoLoadData:=true;
   self.DoubleBuffered:=true;
   // linuxis me ei saa selliseid mänge mängida !
   // {$if defined(WINDOWS)}
   self.BorderIcons:=[biSystemMenu,biMinimize,biMaximize];

if istrueval(dmodule.userStsValues[Csts_forms_as_sdi]) or pShowModal then
   self.FormStyle:=fsNormal
else
   self.FormStyle:=fsMDIChild;

//   BorderStyle := bsSizeToolWin;
//{$endif}
//self.AlphaBlendValue:=250;
//self.AlphaBlend:=true;
end;

destructor TformXFrames.Destroy;
begin
//if (pnMaincontainer.ComponentCount>0) and (pnMaincontainer.Components[0] is TFrame) then
//  begin
//    TFrame(pnMaincontainer.Components[0]).Parent:=nil;
//    TFrame(pnMaincontainer.Components[0]).Free;
//  end;
 if assigned(self.FActiveFrame) then
    glob_fncwnd_slots[self.FUseFrame].Remove(Pointer( self.FActiveFrame));

    // --
    inherited destroy;
end;

procedure  TformXFrames.createparams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;
  CS_SAVEBITS   = $00000800;
begin
   inherited CreateParams(Params);

   // no ei tööta lazaruses !
   if istrueval(dmodule.userStsValues[Csts_forms_as_sdi]) then
     begin

         {$if defined(WINDOWS)}
            with Params do
              begin
               ExStyle := ExStyle or WS_EX_APPWINDOW; // teeb taskbarile eraldi akna

               // lazarus täielikult ignoreerib neid lippa...sürr
               Style:= WS_POPUP or WS_THICKFRAME or WS_CLIPCHILDREN;
               WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
              end;
         {$endif}
    end;
end;



procedure TformXFrames.waitAndKillTimerTimer(Sender: TObject);
begin
   // ps peame timerit jälle kasutama, asi selle, et kui frame kohe kaotada, siis jäävad paljud evendid protessimata
   // ja tulemuseks tore AV
   TTimer(Sender).Enabled:=False;
   Self.Close;
end;

procedure TformXFrames.FormClose(Sender: TObject; var CloseAction: TCloseAction);
//var
//  i   : Integer;
//  prp : PPropInfo;
begin
  if self.FFreeOnClose then
    CloseAction:=caFree;
(*
 for i:=0 to self.pnMaincontainer.ComponentCount-1 do
   if (self.pnMaincontainer.Components[i] is TFrame) then
   try
        prp:=FindPropInfo(self.pnMaincontainer.Components[i], 'loaddata');
     if assigned(prp)  then
       begin
        SetOrdProp(self.pnMaincontainer.Components[i],'loaddata',ord(false)) ;
        break;
       end;
    except
    end;
*)
  if not glob_fncwnd_finalterm then
     glob_fncwnd_slots[self.FUseFrame].Remove(Pointer( self.FActiveFrame));
end;

procedure TformXFrames.FormDeactivate(Sender: TObject);
begin
//if self.WindowState=wsMinimized then
//if self.WindowState=wsMinimized then
//   self.Caption:=trim(psCaptPanel.Caption)
//else
//   self.Caption:='';
end;

procedure TformXFrames.FormActivate(Sender: TObject);
begin
   self.Caption:='';
end;

procedure TformXFrames.FormDestroy(Sender: TObject);
begin
  // --
  //self.Caption:='';
end;

procedure TformXFrames.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
procedure __fndBtn(const pComponent : TComponent; const pType : AStr = 'new');
var
  i    : Integer;
  pBtn : TBitBtn;
begin
    for i:=0 to pComponent.ComponentCount-1 do
      begin
      if (pComponent.Components[i] is TWinControl) and (TWinControl(pComponent.Components[i]) is TBitBtn) then
         begin
            pBtn:=TWinControl(pComponent.Components[i]) as TBitBtn;
         if pos(ansilowercase(pType),ansilowercase(pBtn.Name))>0 then
           begin
            if pBtn.Enabled then
              begin
                 // -- 29.08.2011 Ingmar; peab fookuse ka omistama, muidu nx arve salvestamisel paljudes kohtades ei teki Exit Eventi !
              if pBtn.CanFocus then // peab saama igal juhul fokuseerida !
                begin

                  try
                   pBtn.SetFocus;
                   pBtn.OnClick(pBtn);
                  except
                  end;
                end; // --
               Exit;
              end;
           end; // --
         end;
         __fndBtn(pComponent.Components[i]);
      end;
end;

var
  pConfirmChkbox : TCheckbox;

begin

  // 30.11.2011 Ingmar; et saaks debugida !
  if (key=VK_F3) and (self.FActiveFrame is TframeDeclRez)  then
    begin
       TframeDeclRez(self.FActiveFrame).callDebugWindow;
    end else
// -- CTRL + S salvestame !
if (Shift=[ssCtrl]) then
 begin
  if ((key=ord('s')) or (key=ord('S'))) then // SALVESTAME
     begin

     if assigned(self.FActiveFrame) then
        __fndBtn(self.FActiveFrame,'save');
        key:=0;
     end else
 if ((key=ord('n')) or (key=ord('N'))) then // UUS
       begin

       if assigned(self.FActiveFrame) then
          __fndBtn(self.FActiveFrame,'new');
          key:=0;
       end else
 // -- 29.08.2011 Ingmar; kinnita shortcut !
 if ((key=ord('k')) or (key=ord('K'))) then
       begin
           pConfirmChkbox:=nil;
       // häbenen natuke, nii pole ilus otse pöörduda, aga teine variant oleks tüütu rtti
       if assigned(self.FActiveFrame) then
        // ARVED
        if self.FActiveFrame is TframeBills then
           pConfirmChkbox:=TframeBills(self.FActiveFrame).chkBillConfirmed
        else
        // LAEKUMISED
        if self.FActiveFrame is TframeBankIncomeManually then
           pConfirmChkbox:=TframeBankIncomeManually(self.FActiveFrame).pChkbVerified
        else
        // TASUMISED
        if self.FActiveFrame is TframePaymentOrder then
           pConfirmChkbox:=TframePaymentOrder(self.FActiveFrame).chkboxConfPmtDone
        // KASSA
        else
        if self.FActiveFrame is TframeCashRegister then
          pConfirmChkbox:=TframeCashRegister(self.FActiveFrame).pVerifiedChkbox;
        // --
        if assigned(pConfirmChkbox) then
        with pConfirmChkbox do
          if not Checked and CanFocus then
            begin

             try
              setFocus;
              checked:=true;

             except
             end;
            // ---
            end;
         key:=0;
       end else
 if ((key=ord('q')) or (key=ord('Q'))) then // SULGE
       begin
       if assigned(self.FActiveFrame) then
          __fndBtn(self.FActiveFrame,'close');
          key:=0;
       end;
 end else
 if assigned(FParentKeyNotif) then
    FParentKeyNotif(Sender,Key,Shift);

end;

procedure TformXFrames.FormKeyPress(Sender: TObject; var Key: char);
begin
 // --
end;

procedure TformXFrames.FormResize(Sender: TObject);
begin
  if (self.FActiveFrame is TframeDeclForms) and self.FActiveFrame.Visible then
      TframeDeclForms(self.FActiveFrame).forceResize;
end;


// groupbox pealkiri siis paneelile
procedure TformXFrames.doCaptRename(const pCmp : TComponent);

var
  j : Integer;
begin

   // nüüd väike hack; igale framele pandi groupbox pealkirjaga, nüüd teeme nii, et võtame selle nime groupboxilt ära
   // paneme transparent paneelile

     for j:=0 to pCmp.ComponentCount-1 do
        begin

         if (pCmp.Components[j] is TGroupBox) and (TGroupBox(pCmp.Components[j]).Height>90) then
          begin

            // --
            if (TGroupBox(pCmp.Components[j]).Caption<>'') and (psCaptPanel.Caption='') then // pealkiri puudub...järelikult tuleb omistada
              begin
               psCaptPanel.Caption:=AStr(Stringofchar(#32,CFakeCaptSpacing+1))+TGroupBox(pCmp.Components[j]).Caption;
               TGroupBox(pCmp.Components[j]).Top:=TGroupBox(pCmp.Components[j]).Top-3;
              end;

              // ---
              TGroupBox(pCmp.Components[j]).Caption:='';
              break;
          end;

          // otsime edasi...
          doCaptRename(pCmp.Components[j]);
        end;

end;

procedure  TformXFrames.changeSubCaption(const pCapt : AStr);
begin
  psCaptPanel.Caption:=AStr(Stringofchar(#32,CFakeCaptSpacing+1))+pCapt;
end;

procedure TformXFrames.FormShow(Sender: TObject);
function  __setfirstControl(const pComponent : TComponent):Boolean;
var
   i : Integer;
   pMinTabOrd : Integer;
   pFndCtrl   : TWinControl;
begin
      result:=false;
      // fokusseerime taborderi järgi !
      pMinTabOrd:=999999999;
      pFndCtrl:=nil;

//if (pComponent is TWinControl) and (TWinControl(pComponent).CanFocus) then
//    begin

     for i:=0 to pComponent.ComponentCount-1 do
        begin
        if  (pComponent.Components[i] is TWinControl) then
           begin

             if not (pComponent.Components[i] is TGroupbox)    and
                not (pComponent.Components[i] is TPanel)       and
                TWinControl(pComponent.Components[i]).CanFocus and
               (TWinControl(pComponent.Components[i]).TabOrder<pMinTabOrd) then
               begin
                 pFndCtrl:=TWinControl(pComponent.Components[i]);
                 pMinTabOrd:=pFndCtrl.TabOrder;
               end;
           end;
        end; // ---

     if assigned(pFndCtrl) and pFndCtrl.CanFocus then
     try
        pFndCtrl.SetFocus

     except
     end else
     for i:=0 to pComponent.ComponentCount-1 do
        __setfirstControl(pComponent.Components[i]);
//  end;
end;

var
   i : Integer;
   pCapt  : Astr;
   pSkipc    : Boolean;
   //Properties: PPropList;
   //nProperties: Integer;
   //Info: PPropInfo;
begin
     // vaatame, et spetsiifilistel akendel tuleks õige pealkiri, sest seal mitu grpbox elementi kasutusel !
     self.Caption:='';

     pSkipc:=false;
  if self.FUseFrame in [__csmPurchBillWnd,
                        __csmSaleBillWnd,
                        __csmPrepaymentBillWnd,
                        __csmCreditBillWnd,
                        __csmClientsListWnd
                        ] then
    begin
           pcapt:='';
           pSkipc:=true;

      if   self.FUseFrame=__csmClientsListWnd then
           pcapt:=estbk_strmsg.CSWndNameClient
      else
      case TframeBills(self.FActiveFrame).billMode of
       CB_purcInvoice  : pcapt:=estbk_strmsg.CSWndNamePurchBill;
       CB_salesInvoice : pcapt:=estbk_strmsg.CSWndNameSaleBill;
       CB_prepaymentInvoice: pcapt:=estbk_strmsg.CSWndNamePrepaymentBill;
       CB_creditInvoice : pcapt:=estbk_strmsg.CSWndNameCreditBill;
      end;

      // ---
      psCaptPanel.Caption:=AStr(stringofchar(#32,CFakeCaptSpacing+2))+pcapt;
    end;


 for i:=0 to self.pnMaincontainer.ComponentCount-1 do
  if (self.pnMaincontainer.Components[i] is TFrame) then
  try

    if not pSkipc then
       self.doCaptRename(self.pnMaincontainer.Components[i]);
  except
  end;


  psCaptPanel.Font.Size:=9;

 // -- AUTOMAATSELT kutsume välja sisestuse !
 // 20.02.2011 Ingmar
 if assigned(self.FActiveFrame) and self.FautoCreateNewEntry  then
  if (self.FActiveFrame is TframeBills) then
   begin
      // # ARVED
      TframeBills(self.FActiveFrame).callNewBillEvent();
   end else
  if (self.FActiveFrame is TframeCashRegister) then
   begin
      // # KASSA
      TframeCashRegister(self.FActiveFrame).callNewCashRegEvent();
   end else
  if (self.FActiveFrame is TframePaymentOrder) then
   begin
      // # TASUMISED
      TframePaymentOrder(self.FActiveFrame).callNewPaymentEvent();
   end else
  if (self.FActiveFrame is TframeBankIncomeManually) then
   begin
      // # LAEKUMISED
      TframeBankIncomeManually(self.FActiveFrame).callNewIncomingEvent()
   end else
  if (self.FActiveFrame is TframeOrders) then
   begin
      // # TELLIMUSED
      TframeOrders(self.FActiveFrame).callCreateNewOrder()
   end else
  if (self.FActiveFrame is TframeGeneralLedger) then
   begin
     // # PEARAAMAT
     TframeGeneralLedger(self.FActiveFrame).callNewGenEntryEvent()
   end;

  // proovime leida esimese sobiliku elemendi, kellele fookus suunata !
  if not self.FautoCreateNewEntry then
  for i:=0 to self.FActiveFrame.ControlCount-1 do
   begin
      __setfirstControl(self.FActiveFrame);
   end;


  (*
    for i:=0 to self.ComponentCount-1 do
     if (self.Components[i] is TFrame) then
     begin
         // Freepascali 2.4.3 all ei tööta ?!
         // prp:=FindPropInfo(self.Components[i], 'loaddata');
         //      if assigned(prp) then
         //         SetOrdProp(self.Components[i],'loaddata',ord(true)) ;
         nProperties := GetPropList(self.Components[i].ClassInfo, Properties);
      if nProperties > 0 then
       try

          for j:= 0 to nProperties-1 do
          begin
             Info := Properties^[j];

          if not Assigned(Info^.GetProc) then // ainult kirjutamiseks
             continue;

           case Info^.PropType^.Kind of
           tkClass: begin
                     // Obj := GetObjectProp(Other, Info);
                    end;
           end;
          end;

        // --
        finally
           FreeMem(Properties);
        end;
         //self.Controls[i].Visible:=true;
     end;   *)
end;

procedure TformXFrames.FormWindowStateChange(Sender: TObject);
begin
  // --
 case self.WindowState of
  wsMinimized: self.Caption:=trim(psCaptPanel.Caption);
  wsNormal,
  wsMaximized: self.Caption:='';
 end;
end;

procedure TformXFrames.doLoadData;
var
  prp : PPropinfo;
  pSaveCurs : TCursor;
begin
 try
      pSaveCurs:=Screen.Cursor;
      Screen.Cursor:=crHourGlass;

   if self.FautoLoadData then
     begin
           prp:=FindPropInfo(self.FActiveFrame, 'loaddata');
        if assigned(prp) then
           SetOrdProp(self.FActiveFrame,'loaddata',ord(true));
     end;




 finally
     Screen.Cursor:=pSaveCurs;
 end;
end;

procedure TformXFrames.loadDataTimerTimer(Sender: TObject);
begin
    TTimer(Sender).Enabled:=false;
end;


procedure   TformXFrames.frameKillSignal(Sender: TObject);
begin
  // frame saatis signaali; nägemist...võtame temalt veel rez väärtuse ka, kui see olemas !
  if Sender.InheritsFrom(TFrame)   then
     case self.FUseFrame of
      __csmRPFormulaCreatorWnd
                       : begin
                           self.FStrRez:= TframeFormulaCreator(Sender).Formula;
                         end;
     end;

  // --
  waitAndKillTimer.Enabled:=true;
end;

// forwarder !
procedure TformXFrames.frameDataEventSignal(Sender: TObject; evSender: TFrameEventSender; itemId: Int64; data : Pointer);
begin
 if assigned(self.onFrameDataEvent) then
    self.onFrameDataEvent(Sender,evSender,itemId,data);
end;

procedure TformXFrames.downloadCurrData(Sender: TObject; currDt: TDatetime);
begin
  if not dmodule.downloadCurrencyData(False, currDt) then
     abort;
end;

function    TformXFrames.initForm(const pUseFrame   : TCSModules;
                                  const pFormWidth  : Integer = 480;
                                  const pFormHeight : Integer = 512):TFrame; // tagastab instansi, läbi mille saame meetoditele ligi


// @@@
function  reportPath:AStr;
begin
  result:='reports\';
end;

var
  pStatusBarOrigText : AStr;
begin
 try


             self.Caption:='';
             pStatusBarOrigText:=estbk_utilities._setStatusBarText(estbk_strmsg.SCLoadingData);


             FStrRez:='';
             FIntRez:=0;



             // ---
             self.FUseFrame:=pUseFrame;



             self.Width:=pFormWidth;
             self.Height:=pFormHeight;



          if assigned(self.FActiveFrame) then
             freeAndNil( self.FActiveFrame);


          // TODO võta kasutusele RTTI, et ei peaks pidevalt kordama koodi !
          case pUseFrame of
            __csmTestFrame: begin
                                 result:=TframeX.create(pnMaincontainer);
                                 with result as TframeX do
                                    begin
                                      parent:=pnMaincontainer;
                                      align:=alClient;
                                      //visible:=true;
                                    end;

                            end;

            // finantskannete aken
            __csmAccountingWnd:
                            begin
                                 result:=TframeGeneralLedger.create(pnMaincontainer);
                            with result as TframeGeneralLedger do
                               begin
                                 parent:=pnMaincontainer;
                                 align:=alClient;
                                 //visible:=true;
                                 // ---
                                 //loadData:=true;
                                 // 11.04.2013 Ingmar
                                 reportDefPath:=estbk_utilities.getAppPath+reportPath;

                                 onFrameKillSignal:=@self.frameKillSignal;
                                 onAskCurrencyDownload:=@self.downloadCurrData;
                                 onFrameDataEvent := @self.frameDataEventSignal;


                               end;
                            end;

            // raamatupidamislikud kontod / haldus
            __csmAccountsWnd:
                            begin
                                 result:=TframeManageAccounts.create(pnMaincontainer);
                            with result as TframeManageAccounts do
                               begin
                                 parent:=pnMaincontainer;
                                 align:=alClient;
                                 //visible:=true;
                                 // ---
                                 //loadData:=true;
                                 onFrameKillSignal:=@self.frameKillSignal;
                                 onFrameDataEvent := @self.frameDataEventSignal;
                               end;
                            end;

           // raamatupidamislikud objektid
           __csmAccountingObjectsWnd:
                            begin
                                 result:=TframeObjects.create(pnMaincontainer);
                            with result as TframeObjects do
                               begin
                                 parent:=pnMaincontainer;
                                 align:=alClient;
                                 //visible:=true;
                                 // ---
                                 //loadData:=true;
                                 onFrameKillSignal:=@self.frameKillSignal;
                                 onFrameDataEvent :=@self.frameDataEventSignal;
                               end;
                            end;

           // finantskanded nimekiri
           __csmGeneralLedgEntryListWnd:
                            begin
                                  result:=TframeGenLedgerEntrys.create(pnMaincontainer);
                             with result as TframeGenLedgerEntrys do
                                begin
                                  parent:=pnMaincontainer;
                                  align:=alClient;
                                  //visible:=true;
                                  // ---
                                  //loadData:=true;
                                  onFrameKillSignal:=@self.frameKillSignal;
                                  onFrameDataEvent :=@self.frameDataEventSignal;
                                end;
                            end;

           // pearaamatu aruanne
           __csmGeneralLedgerRepWnd:
                            begin
                                  result:=TframeGenledreportcrit.create(pnMaincontainer);
                             with result as TframeGenledreportcrit do
                                begin
                                  parent:=pnMaincontainer;
                                  align:=alClient;

                                  // ---
                                  //loadData:=true;
                                  onFrameKillSignal:=@self.frameKillSignal;
                                  onFrameDataEvent :=@self.frameDataEventSignal;
                                  // ---

                                  reportDefPath:=estbk_utilities.getAppPath+reportPath;
                                  reportMode:=CRep_generalledger;
                                  //visible:=true;
                                end;
                            end;

           // päevaraamatu aruanne
           __csmDailyJournalRepWnd:
                           begin
                                 result:=TframeGenledreportcrit.create(pnMaincontainer);
                            with result as TframeGenledreportcrit do
                               begin
                                 parent:=pnMaincontainer;
                                 align:=alClient;
                                 // ---
                                 //loadData:=true;
                                 onFrameKillSignal:=@self.frameKillSignal;
                                 onFrameDataEvent :=@self.frameDataEventSignal;
                                 // ---
                                 reportDefPath:=estbk_utilities.getAppPath+reportPath;
                                 reportMode:=CRep_journal;
                                 //visible:=true;
                               end;
                           end;

           // käibeandmik
           __csmTurnoverRepWnd:
                           begin
                                 result:=TframeGenledreportcrit.create(pnMaincontainer);
                            with result as TframeGenledreportcrit do
                               begin
                                 parent:=pnMaincontainer;
                                 align:=alClient;
                                 // ---
                                 //loadData:=true;
                                 onFrameKillSignal:=@self.frameKillSignal;
                                 onFrameDataEvent :=@self.frameDataEventSignal;
                                 // ---
                                 reportDefPath:=estbk_utilities.getAppPath+reportPath;
                                 reportMode:=CRep_turnover;
                                 //visible:=true;
                               end;
                           end;

           // bilanss
           __csmBalanceRepWnd:
                           begin
                           end;

           // kasumi aruanne
           __csmProfitRepWnd:
                          begin
                          end;

            // müügiarve aken
            __csmSaleBillWnd:
                          begin
                                 result:=TframeBills.create(pnMaincontainer);
                            with result as TframeBills do
                               begin
                                 parent:=pnMaincontainer;
                                 align:=alClient;

                                 // ---
                                 billMode:=CB_salesInvoice;
                                 warehousemode:=false;

                                 reportDefPath:=estbk_utilities.getAppPath+reportPath;
                                 //visible:=true;
                                 // ---
                                 //loadData:=true;
                                 onFrameKillSignal:=@self.frameKillSignal;
                                 onFrameDataEvent :=@self.frameDataEventSignal;
                                 onAskCurrencyDownload:= @self.downloadCurrData;


                               end;
                          end;

           // ostuarve aken
           __csmPurchBillWnd:
                          begin
                                result:=TframeBills.create(pnMaincontainer);
                           with result as TframeBills do
                              begin
                                parent:=pnMaincontainer;
                                align:=alClient;

                                // ---
                                billMode:=CB_purcInvoice;
                                warehousemode:=false;

                                reportDefPath:=estbk_utilities.getAppPath+reportPath;
                                //visible:=true;
                                // ---
                                //loadData:=true;
                                onFrameKillSignal:=@self.frameKillSignal;
                                onFrameDataEvent :=@self.frameDataEventSignal;
                                onAskCurrencyDownload:= @self.downloadCurrData;


                              end;
                          end;

           // ettemaksuarve aken
           __csmPrepaymentBillWnd:
                          begin
                                result:=TframeBills.create(pnMaincontainer);
                           with result as TframeBills do
                              begin
                                parent:=pnMaincontainer;
                                align:=alClient;

                                // ---
                                billMode:=CB_prepaymentInvoice;
                                warehousemode:=false;

                                reportDefPath:=estbk_utilities.getAppPath+reportPath;
                                //visible:=true;
                                // ---
                                //loadData:=true;
                                onFrameKillSignal:=@self.frameKillSignal;
                                onFrameDataEvent :=@self.frameDataEventSignal;
                                onAskCurrencyDownload:= @self.downloadCurrData;


                              end;
                          end;

           // # kreeditarve aken
           __csmCreditBillWnd:
                          begin
                                result:=TframeBills.create(pnMaincontainer);
                          with result as TframeBills do
                              begin
                                parent:=pnMaincontainer;
                                align:=alClient;

                                // ---
                                billMode:=CB_CreditInvoice;
                                warehousemode:=false;

                                reportDefPath:=estbk_utilities.getAppPath+reportPath;
                                //visible:=true;
                                // ---
                                //loadData:=true;
                                onFrameKillSignal:=@self.frameKillSignal;
                                onFrameDataEvent :=@self.frameDataEventSignal;
                                onAskCurrencyDownload:= @self.downloadCurrData;


                              end;
                          end;

           // laekumised käsitsi
           __csmIncomingsManualWnd:
                          begin
                                result:=TframeBankIncomeManually.create(pnMaincontainer);
                           with result as TframeBankIncomeManually do
                              begin
                                parent:=pnMaincontainer;
                                align:=alClient;
                                //visible:=true;
                                // ---
                                fileMode:=false;
                                //loadData:=true;
                                onFrameKillSignal:=@self.frameKillSignal;
                                onFrameDataEvent :=@self.frameDataEventSignal;
                                onAskCurrencyDownload:= @self.downloadCurrData;


                              end;
                          end;

           // laekumised pangafailist
           __csmIncomingsFileWnd:
                          begin
                                result:=TframeBankIncomeManually.create(pnMaincontainer);
                           with result as TframeBankIncomeManually do
                              begin
                                parent:=pnMaincontainer;
                                align:=alClient;
                                // ---
                                fileMode:=true;
                                //loadData:=true;
                                onFrameKillSignal:=@self.frameKillSignal;
                                onFrameDataEvent :=@self.frameDataEventSignal;
                                onAskCurrencyDownload:= @self.downloadCurrData;
                                // ---
                                //visible:=true;
                              end;
                          end;

           // müügitellimus
           __csmSaleOrderWnd:
                         begin

                         end;

           // pakkumised
           __csmOffersWnd:
                         begin

                         end;

           // arvete nimekiri
           __csmSaleBillListWnd,
           __csmPurchBillListWnd:
                         begin


                                result:=TframeBillList.create(pnMaincontainer);
                           with result as TframeBillList do
                              begin


                                parent:=pnMaincontainer;
                                align:=alClient;

                                // ---
                                //loadData:=true;
                                onFrameKillSignal:=@self.frameKillSignal;
                                onFrameDataEvent :=@self.frameDataEventSignal;
                                reportDefPath:=estbk_utilities.getAppPath+reportPath;

                             // paneme vaikimisi arved paika !
                             if pUseFrame=__csmSaleBillListWnd then
                                preSelectedBillTypes:=[CB_salesInvoice]
                             else
                                preSelectedBillTypes:=[CB_purcInvoice];
                                // ---
                                //visible:=true;
                              end;
                         end;

           // TODO:
           // laekumiste nimekiri
           __csmIncomingsListWnd:
                         begin
                                result:=TframeIncomingsList.create(pnMaincontainer);
                           with result as TframeIncomingsList do
                              begin
                                parent:=pnMaincontainer;
                                align:=alClient;
                                // ---
                                //loadData:=true;
                                onFrameKillSignal:=@self.frameKillSignal;
                                onFrameDataEvent :=@self.frameDataEventSignal;
                                // ---
                                //visible:=true;
                              end;
                         end;

           // tasumised / maksekorraldus
           __csmPaymentsWnd:
                         begin // _frPaymentOrder
                               result:=TframePaymentOrder.create(pnMaincontainer);
                          with result as TframePaymentOrder do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;
                               //visible:=true;
                               // ---
                               //loadData:=true;
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                               onAskCurrencyDownload:= @self.downloadCurrData;


                             end;
                             // --
                         end;

           // (panga)tasumiste nimekiri
           __csmPaymentsListWnd:
                         begin
                               result:=TframePaymentList.create(pnMaincontainer);
                          with result as TframePaymentList do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;
                               //visible:=true;
                               // ---
                               //loadData:=true;
                               cashRegisterMode:=false; // panga tasumised !
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                             end;
                         end;

           // (kassa)tasumiste nimekiri
           __csmCashRegPaymentsListWnd:
                         begin
                               result:=TframePaymentList.create(pnMaincontainer);
                          with result as TframePaymentList do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;
                               //visible:=true;
                               // ---
                               //loadData:=true;
                               cashRegisterMode:=true; // kassa maksed !
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                             end;
                         end;

           // ostutellimus
           __csmPurchaseOrderWnd:
                         begin

                               result:=TframeOrders.create(pnMaincontainer);
                          with result as TframeOrders do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;

                               reportDefPath:=estbk_utilities.getAppPath+reportPath;
                               orderType:=estbk_types._coPurchOrder;


                               //visible:=true;
                               // ---
                               //loadData:=true;
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                               onAskCurrencyDownload:= @self.downloadCurrData;


                             end;
                         end;

           // ostutellimuste nimekiri
           __csmPurchaseOrderListWnd:
                         begin
                               result:=TframeOrderList.create(pnMaincontainer);
                          with result as TframeOrderList do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;

                               //loadData:=true;
                               //visible:=true;
                               // ---
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                             end;
                         end;

           // käibemaksudekl. vormid / bilansiga seotud vormid \
           __csmRPFormCreatorWnd:
                         begin
                         end;

           // vormiga seotud read / üks ja sama frame erinevad reziimid
           __csmRPFormCreatorLinesWnd:
                         begin
                         end;

           // valemi generaator
           __csmRPFormulaCreatorWnd:
                         begin
                                 result:=TframeFormulaCreator.create(pnMaincontainer);
                          with result as TframeFormulaCreator do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;
                               //visible:=true;
                               // ---
                               //loadData:=true;
                               onFrameKillSignal:=@self.frameKillSignal;
                             end;
                         end;

           // artiklite nimekiri
           __csmArticlesListWnd:
                         begin
                               result:=TframeArticles.create(pnMaincontainer);
                          with result as TframeArticles do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;

                               //loadData:=true;
                               //visible:=true;
                               // ---
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                             end;
                         end;

           // vaikimisi kontode frame
           __csmDefaultAccountsWnd:
                        begin
                               result:=TframeConfAccounts.create(pnMaincontainer);
                          with result as TframeConfAccounts do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;

                               //loadData:=true;
                               //visible:=true;
                               // ---
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                             end;
                        end;

           // pankade nimekiri
           __csmBanksListWnd:
                        begin
                               result:=TframeBanks.create(pnMaincontainer);
                          with result as TframeBanks do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;

                               //loadData:=true;
                               //visible:=true;
                               // ---
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                             end;
                        end;

           // klientide nimekiri
           __csmClientsListWnd:
                        begin
                               result:=TframeCustomers.create(pnMaincontainer);
                          with result as TframeCustomers do
                             begin
                               parent:=pnMaincontainer;
                               align:=alClient;

                               // ---
                               onFrameKillSignal:=@self.frameKillSignal;
                               onFrameDataEvent :=@self.frameDataEventSignal;
                             end;
                        end;

            // arve tasumiste / laekumiste info aken
            __csmBillIncomingsInfoWnd,
            __csmBillPaymentInfoWnd:
                         begin
                             result:=TframePaymentInformation.create(pnMaincontainer);
                        with result as TframePaymentInformation do
                           begin
                             parent:=pnMaincontainer;
                             align:=alClient;

                             // ---
                             onFrameKillSignal:=@self.frameKillSignal;
                             onFrameDataEvent :=@self.frameDataEventSignal;
                           end;
                      end;
            // ladude nimekiri
            __csmWareHouseListwnd:
                       begin
                              result:=TframeWarehouses.create(pnMaincontainer);
                         with result as TframeWarehouses do
                            begin
                              parent:=pnMaincontainer;
                              align:=alClient;

                              //loadData:=true;
                              //visible:=true;
                              // ---
                              onFrameKillSignal:=@self.frameKillSignal;
                              onFrameDataEvent :=@self.frameDataEventSignal;
                            end;
                       end;

            __csmVATDeclDefWnd:
                      begin
                              result:=TframeDeclForms.create(pnMaincontainer);
                         with result as TframeDeclForms do
                            begin
                              parent:=pnMaincontainer;
                              align:=alClient;

                              declFrameMode:=__declDisplayForms;
                              //loadData:=true;
                              //visible:=true;
                              // ---
                              onFrameKillSignal:=@self.frameKillSignal;
                              onFrameDataEvent :=@self.frameDataEventSignal;
                              forceResize;
                            end;
                      end;

             // olgu see bilansivorm/käibedekl. vorm jne jne. Siin tema detailsed def
             __csmDeclDetailedLinesWnd:
                      begin
                            result:=TframeDeclForms.create(pnMaincontainer);
                       with result as TframeDeclForms do
                          begin
                            parent:=pnMaincontainer;
                            align:=alClient;
                            declFrameMode:=__declDisplayFormContent;
                            //loadData:=true;
                            //visible:=true;
                            // ---
                            onFrameKillSignal:=@self.frameKillSignal;
                            onFrameDataEvent :=@self.frameDataEventSignal;
                          end;
                      end;

             // programmi konfiguratsioon
             __csmAppConfDialog:
                      begin

                              result:=TframeAppSettings.create(pnMaincontainer);
                         with result as TframeAppSettings do
                            begin
                              parent:=pnMaincontainer;
                              align:=alClient;



                              //loadData:=true;
                              //visible:=true;
                              // ---
                              onFrameKillSignal:=@self.frameKillSignal;
                              onFrameDataEvent :=@self.frameDataEventSignal;
                            end;

                      end;

              // aruande vormi kalkulatsioon; olgu käibekas, ükstapuha
              __csmFormdCalcPrintWnd:
                     begin
                           result:=TframeDeclRez.create(pnMaincontainer);
                      with result as TframeDeclRez do
                         begin
                           parent:=pnMaincontainer;
                           align:=alClient;

                           reportDefPath:=estbk_utilities.getAppPath+reportPath;
                           // ---
                           onFrameKillSignal:=@self.frameKillSignal;
                           onFrameDataEvent :=@self.frameDataEventSignal;
                         end;
                     end;

              // dokumendi failid
              __csmDocumentFilesWnd:
                     begin
                           result:=TframeDocFilesMgr.create(pnMaincontainer);
                      with result as TframeDocFilesMgr do
                         begin
                           parent:=pnMaincontainer;
                           align:=alClient;

                           // ---
                           onFrameKillSignal:=@self.frameKillSignal;
                           onFrameDataEvent :=@self.frameDataEventSignal;
                         end;
                     end;

              // võlas arvete nimistu
              __csmSaleBillDebtors,
              __csmPurchBillDebtors:
                     begin
                           result:=TframeDebtors.create(pnMaincontainer);
                      with result as TframeDebtors do
                         begin
                           parent:=pnMaincontainer;
                           align:=alClient;
                           reportDefPath:=estbk_utilities.getAppPath+reportPath;
                           // ---
                           onFrameKillSignal:=@self.frameKillSignal;
                           onFrameDataEvent :=@self.frameDataEventSignal;
                           onAskCurrencyDownload:= @self.downloadCurrData;
                         end;
                     end;

              // kassa aken
              __csmCashRegister:
                     begin
                           result:=TframeCashRegister.create(pnMaincontainer);
                      with result as TframeCashRegister do
                         begin
                           parent:=pnMaincontainer;
                           align:=alClient;

                           reportDefPath:=estbk_utilities.getAppPath+reportPath;

                           // ---
                           onFrameKillSignal:=@self.frameKillSignal;
                           onFrameDataEvent :=@self.frameDataEventSignal;
                           onAskCurrencyDownload:= @self.downloadCurrData;


                         end;
                     end;

              // kassaraamat
              __csmCashBook:
                     begin
                           result:=TframeCashbook.create(pnMaincontainer);
                      with result as TframeCashbook do
                         begin
                           parent:=pnMaincontainer;
                           align:=alClient;


                           reportDefPath:=estbk_utilities.getAppPath+reportPath;
                           // ---
                           onFrameKillSignal:=@self.frameKillSignal;
                           onFrameDataEvent :=@self.frameDataEventSignal;
                         end;
                     end;

               // töötajate nimekiri
               __csmWorkerListWnd:
                    begin

                           result:=TframePersonalCardList.create(pnMaincontainer);
                      with result as TframePersonalCardList do
                         begin
                           parent:=pnMaincontainer;
                           align:=alClient;

                           // ---
                           onFrameKillSignal:=@self.frameKillSignal;
                           onFrameDataEvent :=@self.frameDataEventSignal;
                         end;
                    end;

               // töötaja ankeet
               __csmWorkerEntryWnd:
                    begin
                           result:=TframePersonalCard.create(pnMaincontainer);
                      with result as TframePersonalCard do
                         begin
                           parent:=pnMaincontainer;
                           align:=alClient;

                           // ---
                           onFrameKillSignal:=@self.frameKillSignal;
                           onFrameDataEvent :=@self.frameDataEventSignal;
                         end;
                    end;

               // töötaja leping
               __csmWorkContractEntry:
                    begin
                          result:=TframeWorkContract.create(pnMaincontainer);
                     with result as TframeWorkContract do
                        begin
                          parent:=pnMaincontainer;
                          align:=alClient;

                          // ---
                          onFrameKillSignal:=@self.frameKillSignal;
                          onFrameDataEvent :=@self.frameDataEventSignal;
                        end;
                    end;

               // töötajate palga definitsioonid
               __csmWageDefinitionWnd:
                    begin

                          result:=TframeEmpwageTypeDefTemplate.create(pnMaincontainer);
                     with result as TframeEmpwageTypeDefTemplate do
                        begin
                          parent:=pnMaincontainer;
                          align:=alClient;

                          // ---
                          onFrameKillSignal:=@self.frameKillSignal;
                          onFrameDataEvent :=@self.frameDataEventSignal;
                        end;
                    end;
            // ---
          end;


          // --
          self.FActiveFrame:=result;
          self.FInitDone:=true;




 finally
     estbk_utilities._setStatusBarText(pStatusBarOrigText);
 end;
end;

function    TformXFrames.showmodal():boolean;
var
   pComp  : TComponent;
   pIndex : Integer;
begin

       // 19.05.2011 Ingmar; bugi !
       self.FormStyle:=fsNormal;
    if glob_fncwnd_slots[self.FUseFrame].IndexOf(Pointer( self.FActiveFrame))=-1 then
       glob_fncwnd_slots[self.FUseFrame].Add(Pointer( self.FActiveFrame));

    // --
    case self.FUseFrame of
      __csmRPFormulaCreatorWnd
                       : begin

                         if assigned(self.FActiveFrame) and (self.FActiveFrame is TframeFormulaCreator) then
                           begin
                              TframeFormulaCreator(FActiveFrame).Clear;
                           if not TframeFormulaCreator(FActiveFrame).loadData then
                              TframeFormulaCreator(FActiveFrame).loadData:=true;
                              TframeFormulaCreator(FActiveFrame).formula:=strRez;
                           end;
                         end;
    end;


       // 15.02.2011 Ingmar
       //estbk_uivisualinit.__fixOnClickFocusBug(FActiveFrame);
       psCaptPanel.Font.Size:=CCaptPanelFontSize;
    if self.FInitDone then
       result:=inherited showmodal=mrOk
    else
       result:=false;

end;

procedure TformXFrames.show();
var
   pSdiMode : Boolean;

begin

  if glob_fncwnd_slots[self.FUseFrame].IndexOf(Pointer( self.FActiveFrame))=-1 then
     glob_fncwnd_slots[self.FUseFrame].Add(Pointer( self.FActiveFrame));

     psCaptPanel.Font.Size:=CCaptPanelFontSize;
     // 15.02.2011 Ingmar
     //estbk_uivisualinit.__fixOnClickFocusBug(FActiveFrame);
     // kuna MDI ei tööta korrektselt, siis järjekordne tore bugi fix
     self.Width:=self.Width+1;
     self.Width:=self.Width-1;


     pSdiMode:=istrueval(dmodule.userStsValues[Csts_forms_as_sdi]);
  if not pSdiMode then
   begin
     self.doLoadData;
   end;


     // --------------
     inherited show;
     // --------------

  if pSdiMode then
    begin

      self.Color:=clBtnface;
      self.FActiveFrame.Color:=clBtnface;
      self.doLoadData;
    end;
     //self.Invalidate;
end;

procedure initSlots;
var
 i : TCSModules;
begin
 for i:=low(TCSModules) to high(TCSModules) do
     glob_fncwnd_slots[i]:=TList.Create;
end;

procedure freeSlots;
var
  i : TCSModules;
begin
  for i:=low(TCSModules) to high(TCSModules) do
      freeAndNil(glob_fncwnd_slots[i]);
end;

initialization
  {$I estbk_formxframes.ctrs}
  initSlots;
finalization
  freeSlots;
end.

