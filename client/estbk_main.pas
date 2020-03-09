unit estbk_main;



{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  estbk_globvars, {$IFDEF FINLAND}estbk_lib_fin_sampo, estbk_http,{$ENDIF} // !!
  Classes, SysUtils, FileUtil, DateUtils, LResources, Forms, Controls, Graphics, Dialogs,SMNetGradient,
  LCLType, Menus, ExtCtrls, estbk_frame_chooseaddr, estbk_lib_locals,
  estbk_utilities, ComCtrls, estbk_types,estbk_choose_dform,
  estbk_sqlclientcollection, estbk_fra_generalledger, estbk_fra_objects,estbk_fra_createmodaccounts,
  estbk_fra_genledgerentrys, estbk_clientdatamodule, estbk_fra_genledgreportcriterias,estbk_fra_cashregister,
  estbk_strmsg, StdCtrls, DbCtrls,estbk_frm_currlist,
  Buttons, AsyncProcess, types, typinfo, estbk_dbcompability, estbk_fra_customer, estbk_frm_choosecustmer, estbk_fra_articles, estbk_fra_bills, estbk_fra_banks,
  estbk_fra_bill_list, estbk_fra_warehouse, estbk_fra_orders, estbk_fra_paymentorders,
  estbk_fra_payment_list, estbk_fra_configureaccounts,estbk_fra_workcontract,
  estbk_lib_incomings, estbk_lib_commoncls, RTTIGrids,estbk_lib_vat_ext2,
  ZDataset, ZSqlMonitor, rxdbgrid, estbk_testframe,estbk_settings,estbk_fra_personalcardlist,estbk_fra_personalcard,
  estbk_fra_order_list, estbk_fra_declforms,estbk_fra_debtorlist, estbk_frm_ebill_import,
  estbk_fra_declformulacreator, estbk_lib_declcalc, estbk_fra_formdrez,estbk_fra_docfilesmgr,estbk_fra_cashbook,
  estbk_progressformanimated, estbk_frm_formincomefiles, estbk_fra_incomings_edit,estbk_frm_choosebank,
  estbk_fra_payment_information,estbk_frm_about, LR_Desgn, LR_Class,estbk_lib_revpolish,estbk_lib_suminwords,
  estbk_ebill,estbk_frm_accperfinalize,estbk_frm_template,estbk_lib_ebillimporter,
  estbk_frm_sepapayments;




// --------------------------------------------------------------------------
// PROGRAMMI VERSIOONI INFO
// --------------------------------------------------------------------------

const
  CAppVersion            = '1.05'; // -- 26.06.2013 Ingmar; 08.09.2016 versioon 1.00
  CDefaultFirstPanelText = '   ';

// --------------------------------------------------------------------------


const
  CCreateNewEntry = true;


type

  { TestBkMainForm }

  TestBkMainForm = class(TForm)
    asyncExec: TAsyncProcess;
    bh3: TBevel;
    bh4: TBevel;
    btnOpenClientList: TBitBtn;
    bv3: TBevel;
    bv4: TBevel;
    cmbChannelType: TComboBox;
    edtCustname1: TEdit;
    edtSupplAddr: TEdit;
    edtSupplier: TEdit;
    edtSupplname: TEdit;
    Image1: TImage;
    lblCurrDate: TLabel;
    MenuItem1: TMenuItem;
    mnuImportEBills: TMenuItem;
    mnuSep85: TMenuItem;
    mnuSep18: TMenuItem;
    mnuInfo: TMenuItem;
    mnuClosingAccRec: TMenuItem;
    mnusep16: TMenuItem;
    mnuCurrency: TMenuItem;
    test2: TMenuItem;
    mnuItemWorker: TMenuItem;
    mnuSalary: TMenuItem;
    mnuUpdateStiigo: TMenuItem;
    mnuDebug: TMenuItem;
    mnuSep66: TMenuItem;
    mnucashbook: TMenuItem;
    mnuSep65: TMenuItem;
    mnuCboxPayments: TMenuItem;
    mnuCashbox: TMenuItem;
    mnuIncomingsManualc: TMenuItem;
    mnuIncomingsFromFilec: TMenuItem;
    mnuPaymentsc: TMenuItem;
    mnuSep28: TMenuItem;
    mnuBankCl: TMenuItem;
    mnuDebtPurch: TMenuItem;
    mnuSep21: TMenuItem;
    mnuDebtorsSale: TMenuItem;
    mnuSep20: TMenuItem;
    mnuItemIncStatement: TMenuItem;
    mnuItemBalance: TMenuItem;
    mnuRepDesigner: TMenuItem;
    mnuVatDeclRez: TMenuItem;
    mnuSep15: TMenuItem;
    mnuSep14: TMenuItem;
    mnuItemDefAccounts: TMenuItem;
    mnuBanks: TMenuItem;
    mnuSep12: TMenuItem;
    lblChannel: TLabel;
    lblChannelType: TLabel;
    lblSec2: TLabel;
    lblSec4: TLabel;
    lblSuppl: TLabel;
    lblSupplAddr: TLabel;
    lblSupplId: TLabel;
    mnuWarehouseList: TMenuItem;
    mnuWarehouseEx: TMenuItem;
    mnuItemVatDecl: TMenuItem;
    mnuForms: TMenuItem;
    mnuAppSettings: TMenuItem;
    mnuMiscSettings: TMenuItem;
    mnuArticlesList: TMenuItem;
    mnuArticles: TMenuItem;
    mnuClientList: TMenuItem;
    mnuItemClient: TMenuItem;
    mnuPurcOrderReq: TMenuItem;
    mnuSaleOffer: TMenuItem;
    mnuOffers: TMenuItem;
    mnuSep8: TMenuItem;
    mnuSep6: TMenuItem;
    mnuPurchBill: TMenuItem;
    mnuSaleBill: TMenuItem;
    mnuObjects: TMenuItem;
    mnuProfitRep: TMenuItem;
    mnuBalance: TMenuItem;
    mnuSep2: TMenuItem;
    mnuAccTurnover: TMenuItem;
    mnuDailyJournal: TMenuItem;
    mnuGenLedgerRep: TMenuItem;
    mnuSep: TMenuItem;
    mnuAccounts: TMenuItem;
    myAppProp: TApplicationProperties;
    mnuFIX: TMenuItem;
    mnuItemGenLedger: TMenuItem;
    mnuPurcRez: TMenuItem;
    Mnumain:     TMainMenu;
    mnuAbout:    TMenuItem;
    mnuSalesRez:      TMenuItem;
    MnuFinance:      TMenuItem;
    Mnuexit:     TMenuItem;
    Mnufail:     TMenuItem;
    pgControl: TPageControl;
    pMainTabSheet: TTabSheet;
    pStatusBar: TStatusBar;
    SQLTrace: TZSQLMonitor;
    heightFix: TTimer;

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure heightFixTimer(Sender: TObject);

    procedure mnucashbookClick(Sender: TObject);
    procedure mnuCboxPaymentsClick(Sender: TObject);
    procedure mnuClosingAccRecClick(Sender: TObject);
    procedure mnuCurrencyClick(Sender: TObject);
    procedure mnuDebugClick(Sender: TObject);
    procedure mnuDonationClick(Sender: TObject);
    procedure mnuFormsClick(Sender: TObject);
    procedure mnuImportEBillsClick(Sender: TObject);
    procedure mnuInfoClick(Sender: TObject);
    procedure mnuItemCashRegListClick(Sender: TObject);
    procedure mnuItemWorkerClick(Sender: TObject);
    procedure mnuPaymentOrderListClick(Sender: TObject);
    procedure mnuAccountingListClick(Sender: TObject);
    procedure mnuAccTurnoverClick(Sender: TObject);
    procedure mnuAppSettingsClick(Sender: TObject);
    procedure mnuBalanceClick(Sender: TObject);
    procedure mnuBalanceDeclRezClick(Sender: TObject);
    procedure mnuCashboxClick(Sender: TObject);
    procedure mnuDailyJournalClick(Sender: TObject);
    procedure mnuDebtorsSaleClick(Sender: TObject);
    procedure mnuDebtPurchClick(Sender: TObject);
    procedure mnuGenLedgerRepClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuAccountsClick(Sender: TObject);
    procedure mnuArticlesListClick(Sender: TObject);
    procedure mnuBanksClick(Sender: TObject);
    procedure mnuBillListClick(Sender: TObject);
    procedure mnuClientListClick(Sender: TObject);
    procedure MnuexitClick(Sender: TObject);
    procedure mnuIncomingsFromFilecClick(Sender: TObject);
    procedure mnuIncomingsManualcClick(Sender: TObject);
    procedure mnuIncomingsManualClick(Sender: TObject);
    procedure mnuItemBalanceClick(Sender: TObject);
    procedure mnuItemDefAccountsClick(Sender: TObject);
    procedure mnuItemGenLedgerClick(Sender: TObject);
    procedure mnuItemIncStatementClick(Sender: TObject);
    procedure mnuItemPurchBillListClick(Sender: TObject);
    procedure mnuItemVatDeclClick(Sender: TObject);
    procedure mnuObjectsClick(Sender: TObject);
    procedure mnuPaymentscClick(Sender: TObject);
    procedure mnuPaymentsClick(Sender: TObject);
    procedure mnuProfitRepClick(Sender: TObject);
    procedure mnuPurchBillClick(Sender: TObject);
    procedure mnuPurchOrderListClick(Sender: TObject);
    procedure mnuPurcOrderReqClick(Sender: TObject);
    procedure mnuRepDesignerClick(Sender: TObject);
    procedure mnuSaleBillClick(Sender: TObject);
    procedure mnuUpdateStiigoClick(Sender: TObject);
    procedure mnuVatDeclRezClick(Sender: TObject);
    procedure mnuWarehouseListClick(Sender: TObject);

    procedure myAppPropException(Sender: TObject; E: Exception);
    procedure myAppPropRestore(Sender: TObject);
    procedure myAppPropShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure pBackgroundimgClick(Sender: TObject);
    procedure pMainTabSheetContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure pStatusBarClick(Sender: TObject);
    procedure pStatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;const Rect: TRect);
    procedure SQLTraceLogTrace(Sender: TObject; Event: TZLoggingEvent);
    procedure test2Click(Sender: TObject);
  protected
    FlFocusedLastCtrl     : TWinControl;
    FlFocusedCtrlOrigColor: TColor;
    procedure _getNews;
    function  _appversion:AStr;
    // ------------------------------------------------------------------------
    // Akende haldurid
    // ------------------------------------------------------------------------
    procedure _calcBestPosBylastWnd(var pLeft : Integer;
                                    var pTop  : Integer);

    procedure preValidateSettings(const pReqModule : TCSModules);

    function  _alwaysModalWindows(const pReqModule : TCSModules):Boolean;
    procedure _crwndManager(const pReqModule     : TCSModules;
                            const pManageMnuItem : TMenuItem;
                            const pModalWnd : Boolean = true;
                            const pCreateNewEntry : Boolean = false);

    procedure _crwndManagerExt(const pReqModule : TCSModules;
                               var   pXForm     : Tform;
                               var   pXFrame    : TFrame;
                               const pShowForm  : Boolean = true;
                               const pModalWnd  : Boolean = true;
                               const pManageMnuItem : TMenuItem = nil;
                               const pCreateNewEntry : Boolean = false);

    // vahendab moodulite sõnumeid
    procedure dataEvents(Sender: TObject; evSender: TFrameEventSender; itemId: Int64; data : Pointer); // 01.03.2011 Ingmar; nüüd Int64 !

    // ------------------------------------------------------------------------
    procedure perfEnterColor(Sender: TWinControl);
    procedure perfExitColor(Sender: TWinControl);
    procedure screenActiveControlChange(Sender: TObject);

    procedure openFormdLines(const pType : AStr;
                             const pManageMnuItem : TMenuItem = nil);
    procedure openFormdCalc(const pFormdId : Integer;
                            const pManageMnuItem : TMenuItem = nil;
                            const pStartDateAsZero : Boolean = false);
  private
    { private declarations }
     p: TDeclcalc;
  public
    { public declarations }
  end;


// LISAKONFIGURATSIOON !
const
  CSmallWndWidth  = 630;
  CSmallWndHeight = 225;



var
  estBkMainForm: TestBkMainForm;

implementation
uses estbk_formxframes, estbk_uivisualinit, estbk_fra_template, estbk_lib_fin_sampo,
  IdHttp,StrUtils,Math{$IFDEF debugmode},estbk_lib_erprtwriter,estbk_lib_bankfiledefs{$ENDIF};


// ############################################################################

function  TestBkMainForm._appversion:AStr;
begin
 result:=AStr('Copyright '+(_softwareCreator)+utf8encode(' © Stiigo ver ')+CAppVersion);
end;

// 02.12.2011 Ingmar; kuidagi peab sõnumit kasutajatele saama
// - CStiigoGeneralIniSect
// -CStiigoNewsURL
procedure TestBkMainForm._getNews;
var
  pIdHttp  : TIdHttp;
  pRez     : AStr;
  pStrList : TAStrList;
  pDaysToDisp : Integer;
  pMessageExpDate : Integer;
  pCurrMsgId  : Integer;
  pMessageId  : Integer;
  pCheckIntv  : Integer;
  pRdNextCheck: Integer;
  pNotExpired : Boolean;
begin
 try
   // --
   try
          pIdHttp:=TIdHttp.Create(nil);
          pStrList:=TAStrList.Create;

          pIdHttp.ConnectTimeout:=5000; // 5 sek
          pIdHttp.ReadTimeout:=5000;

          // --
          pRdNextCheck:=dmodule.globalIni.ReadInteger(CStiigoGeneralIniSect,'nextmessagecheck',Trunc(now));
          // --
          pMessageExpDate:=dmodule.globalIni.ReadInteger(CStiigoGeneralIniSect,'messageexpires',Trunc(now)+365);
          pNotExpired:=Trunc(now)<pMessageExpDate;

       // --
       if pNotExpired then
          pStatusBar.Panels.Items[0].Text:= dmodule.globalIni.ReadString(CStiigoGeneralIniSect,'lastmessage','')
       else
          pStatusBar.Panels.Items[0].Text:='';

       if pRdNextCheck>Trunc(now) then
          Exit;

          // 24.02.2013 Ingmar; server andis muidu 406 vea !
          pIdHttp.Request.UserAgent:='Stiigo';
          pIdHttp.Request.Accept:='text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';

          pRez:=pIdHttp.Get(format(estbk_types.CStiigoNewsURL,[estbk_globvars.glob_activecountryCode]));
          // esimene number näitab, mitu päeva teadet kuvada, kui kaob
          // teine on teate ID
          // kolmas, kui tihti päevades kontrollida uusi teateid
          // neljas teade ise
          // 3;1;5;TESTTESTTEST
          pStrList.Delimiter:=';';
          pStrList.DelimitedText:=pRez;

       if (pStrList.count=4) then
         begin
             pDaysToDisp:=strtointdef(pStrList.Strings[0],0);
             pMessageId:=strtointdef(pStrList.Strings[1],0);
             pCheckIntv:=strtointdef(pStrList.Strings[2],0);
             pRez:=copy(trim(pStrList.Strings[3]),1,2048);
             // --
             dmodule.globalIni.WriteInteger(CStiigoGeneralIniSect,'nextmessagecheck',Trunc(now)+pCheckIntv);

             pCurrMsgId:=dmodule.globalIni.ReadInteger(CStiigoGeneralIniSect,'messageid',-1);
         // täiesti uus teade !
         if (pCurrMsgId<>pMessageId) or ((pCurrMsgId=pMessageId) and (pNotExpired)) then
           begin
               // -- loogika lisada !
               pStatusBar.Panels.Items[0].Text:='  '+pRez;
               dmodule.globalIni.WriteString(CStiigoGeneralIniSect,'lastmessage',pStatusBar.Panels.Items[0].Text);

           // uus teade tuli; kaua kuvame ...
           if (pCurrMsgId<>pMessageId) then
               dmodule.globalIni.WriteInteger(CStiigoGeneralIniSect,'messageexpires',Trunc(now)+pDaysToDisp);
           end;

             // -- @@@
             dmodule.globalIni.WriteInteger(CStiigoGeneralIniSect,'messageid',pMessageId);
         end;

   finally
         freeAndNil(pIdHttp);
         freeAndNil(pStrList);
   end;

 // --
 except
    pStatusBar.Panels.Items[0].Text:='';
 end;
end;

// ############################################################################

procedure TestBkMainForm.FormCreate(Sender: TObject);
begin


 try
  estbk_uivisualinit.__preparevisual(self);
  //pageCtrlClient.DoubleBuffered := True;
  // lokaalsed seaded paika
  // estbk_locals.initDefaultLocalSettings(estbk_types.CDefaultCountry);

  //  self.pToday.Caption:=datetostr(date);
  //self.leftPanel.Width := 0;
  self.lblCurrDate.Caption:=datetostr(date);
  self.lblCurrDate.Tag:=-1;



  // väga hea näide; http://delphi.about.com/od/vclusing/a/coloringfocused_2.htm
  // imestan, et ise selle peale ei tulnud !!!
  Screen.OnActiveControlChange := @ScreenActiveControlChange;

  // -------------------------------
  // seoses W7 peame MDI'd kasutama !
  // -------------------------------

  //{$if defined(WINDOWS)}
  self.FormStyle:=fsMDIForm;
  //{$endif}


  // ---
  //  lblCpy.Caption:=self._appversion;
  //  lblCpy.Font.Color:=$009B9B9B;


  pStatusBar.Panels.Items[0].Text:=utf8encode(CDefaultFirstPanelText);

  mnuDebug.Visible:={$ifdef debugmode}true{$else}false{$endif};
  // 02.12.2011 Ingmar
  self._getNews;
  {$ifdef wagemodule_enabled}
  mnuSalary.Visible:=true;
  {$else}
  mnuSalary.Visible:=false;
  {$endif}
  // ---
  translateObject(Self);

 except on e : exception do
   showmessage('ERR:'+e.Message);
 end;
end;

procedure TestBkMainForm.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveControlChange := nil;
end;

procedure TestBkMainForm.myAppPropException(Sender: TObject; E: Exception);
begin
  dialogs.messageDlg(format(estbk_strmsg.SEMajorAppError,[e.message]),mterror,[mbOk],0);
end;

procedure TestBkMainForm.myAppPropRestore(Sender: TObject);
begin
 // ---
end;

procedure TestBkMainForm.myAppPropShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  HintInfo.ReshowTimeout:=0;
end;

procedure TestBkMainForm.pBackgroundimgClick(Sender: TObject);
begin
  // --
end;

procedure TestBkMainForm.pMainTabSheetContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  // --
end;

procedure TestBkMainForm.pStatusBarClick(Sender: TObject);

var

 prv : TRevPolish;
 pRez : double;
//  p : TFormulaPreParser;
begin
 exit;
  prv:=TRevPolish.create;
  prv.parseEquation('-2,8--2,8');

//   prv.parseEquation('~(((15/(7-(1+1)))*3)-(2+1+1))');
  pRez:=prv.eval;
  showmessage(floattostr(pRez));
//showmessage(prefixEquation('-2,8+-2,8'));

//  showmessage(floattostr(pRez));


  // ---
// p:=TFormulaPreParser.create();
 //p.parseFormula('($1+$2*[10555@14])*2');

// showmessage(p.errorCode);
// p.Free;
end;

procedure TestBkMainForm.pStatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
const
  CPanelColor = $757575;
var
  pts  : TTextStyle;

begin
   with StatusBar.Canvas do
   begin

          pts:=Canvas.TextStyle;
          pts.Alignment := taLeftJustify;
          Canvas.TextStyle:=pts;
          Brush.Color := clBtnFace;
     case Panel.Index of
       0:
       begin
         //  Brush.Color := clBtnFace; // statusbari lahtri värv
         //Brush.Color := estbk_types.MyFavGray;
         Font.Color := CPanelColor; // kirja värv
         Font.Style :=[];
         //Font.Style := [fsBold];
       end;
       1:
       begin
         //Brush.Color := estbk_types.MyFavGray;

         Font.Color :=CPanelColor; // MyFavDarkGray;
         Font.Style := [];
         pts.Alignment:=taRightJustify;
         Panel.Text:=self._appversion+astr(stringofchar(#32,10));
       end;
     end;

     //Panel background color
     FillRect(Rect) ;
     //Panel Text
     TextRect(Rect,Rect.Left+2,Rect.Top+2,Panel.Text,pts);
     // ImageList1.Draw(StatusBar1.Canvas, Rect.Left, Rect.Top, Panel.Index) ;
   end;

end;

procedure TestBkMainForm.SQLTraceLogTrace(Sender: TObject; Event: TZLoggingEvent
  );
begin
  // ---
end;

procedure TestBkMainForm.test2Click(Sender: TObject);
begin
    self._crwndManager(__csmWageDefinitionWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;


procedure TestBkMainForm.perfEnterColor(Sender: TWinControl);
var
  pAcceptCtrl: boolean;
begin

  if Sender <> nil then
  begin
    pAcceptCtrl := (Sender is TCustomEdit) or
      (Sender is TCustomComboBox);

    if IsPublishedProp(Sender, 'Color') then
    begin
      FlFocusedCtrlOrigColor := GetOrdProp(Sender, 'Color');
     {
     tulevikus lubame
     if pAcceptCtrl and (FlFocusedCtrlOrigColor=clWindow) then
        SetOrdProp(Sender,'Color', clInfoBk) ;
     }
      //SetOrdProp(Sender,'Color', $E9F3F3) ; // meeldiv helehall

    end;
  end;
end;


procedure TestBkMainForm.perfExitColor(Sender: TWinControl);
begin
  if Sender <> nil then
  begin
    if IsPublishedProp(Sender, 'Color') then
    begin
      SetOrdProp(Sender, 'Color', FlFocusedCtrlOrigColor);
    end;
  end;
end;

procedure TestBkMainForm.ScreenActiveControlChange(Sender: TObject);
var
  pdoEnter, pdoExit:     boolean;
  previousActiveControl: TWinControl;
begin
// TAASTADA
// exit;

  if Screen.ActiveControl = nil then
  begin

    FlFocusedLastCtrl := nil;
    Exit;
  end;


  pdoEnter := True;
  pdoExit  := True;

  //CheckBox
  if Screen.ActiveControl is TButtonControl then
    pdoEnter := False;

  previousActiveControl := FlFocusedLastCtrl;
  if previousActiveControl <> nil then
  begin
    //CheckBox
    if previousActiveControl is TButtonControl then
      pdoExit := False;
  end;

  FlFocusedLastCtrl := Screen.ActiveControl;
  {$ifdef debugmode}
  self.Caption:=FlFocusedLastCtrl.Name+' : visible '+booltostr(FlFocusedLastCtrl.Visible,true)+' left: '+inttostr(FlFocusedLastCtrl.left)+' top: '+inttostr(FlFocusedLastCtrl.top);
  {$endif}

  if pdoExit then
    perfExitColor(previousActiveControl);

  if pdoEnter then
    perfEnterColor(FlFocusedLastCtrl);
end;


procedure TestBkMainForm.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // ---
end;

procedure TestBkMainForm.FormResize(Sender: TObject);
//var
// i : TCSModules;
begin
 pStatusBar.Panels.Items[0].Width:=self.Width-259;
// if self.Visible then
// for i:=low(TCSModules) to high(TCSModules) do
//  if assigned(glob_fncwnd_slots[i]) and (TFrame(glob_fncwnd_slots[i]).Parent is TForm) then
//      TForm(TFrame(glob_fncwnd_slots[i]).Parent).Repaint;
end;

// pole päris cascade, aga suht sarnane !
procedure TestBkMainForm._calcBestPosBylastWnd(var pLeft : Integer;
                                               var pTop  : Integer);

const
  CLDelta = 10;
var
  i : Integer;
  pLastLeft : Integer;
  pLastTop  : Integer;


begin
      pLastLeft:=135;
      pLastTop:=35;

  for i:=0 to pMainTabSheet.ControlCount-1 do
  if pMainTabSheet.Controls[i] is TForm then
   begin
      pLastLeft:=TForm(pMainTabSheet.Controls[i]).Left;
      pLastTop:=TForm(pMainTabSheet.Controls[i]).Top;
   end;

      pLeft:=pLastLeft+CLDelta;
      pTop:=pLastTop+CLDelta;

end;

procedure TestBkMainForm.preValidateSettings(const pReqModule : TCSModules);
begin

  if not (pReqModule in ([__csmAccountsWnd,
                          __csmAccountingWnd,
                          __csmClientsListWnd,
                          __csmBanksListWnd,
                          __csmWareHouseListwnd,
                          __csmArticlesListWnd,
                          __csmDefaultAccountsWnd,
                          __csmAppConfDialog,
                          __csmAboutWnd,
                          //__csmFormdCalcPrintWnd,
                          __csmDeclDetailedLinesWnd
                         {$ifdef wagemodule_enabled}
                         ,__csmWorkerListWnd,
                          __csmWorkerEntryWnd,
                          __csmWorkContractEntry,
                          __csmWageDefinitionWnd
                         {$endif}

                         ]))  then
   if not dmodule.areDefaultAccountsAssigned then
    begin
      dialogs.MessageDlg(estbk_strmsg.SCInfoDefaultAccountsNotDefined,MtError,[mbok],0);
      abort; // --
    end;
end;

function  TestBkMainForm._alwaysModalWindows(const pReqModule : TCSModules):Boolean;
begin
  result:=pReqModule in [__csmClientsListWnd,__csmRPFormulaCreatorWnd];
end;

procedure TestBkMainForm._crwndManager(const pReqModule     : TCSModules;
                                       const pManageMnuItem : TMenuItem;
                                       const pModalWnd : Boolean = true;
                                       const pCreateNewEntry : Boolean = false);
var
  i          : Integer;
  pDefWidth  : Integer;
  pDefHeight : Integer;
  pParent    : TWinControl;
  pLeft      : Integer;
  pTop       : Integer;
  pXFrame    : TFrame;
begin
 self.preValidateSettings(pReqModule);

 {$ifdef mdistyle}
  pParent:=pMainTabSheet; // self;
 {$else}
  pParent:=pMainTabSheet;
 {$endif}
  pLeft := 0;
  pTop := 0;

// vorm vabastab ennast ise !
//with TformXFrames.Create(nil,true) do
with TformXFrames.Create(nil,self._alwaysModalWindows(pReqModule) or pModalWnd,true) do
  begin
      // --- algseis paika
      self._calcBestPosBylastWnd(pLeft,pTop);
   if not istrueval(dmodule.userStsValues[Csts_forms_as_sdi]) then
      parent:=pParent
   else
      parent:=nil;
      pDefWidth:=940;
      pDefHeight:=650;




      Left:=pLeft;
      Top:=pTop;



      autoCreateNewEntry:=pCreateNewEntry;
      // ----------------
      pXFrame:=initForm(pReqModule,pDefWidth,pDefHeight);
      // ----------------
      onFrameDataEvent:=@self.dataEvents;

  // vormi alampealkirjaks menüüpunkti nimetus
  if (pXFrame is TframeDeclForms)  then
   begin

    if (TframeDeclForms(pXFrame).declFrameMode=__declDisplayForms) then
         if assigned(pManageMnuItem) then
           for i:=0 to ComponentCount-1 do
           if (Components[i] is TNetGradient) then
             begin
               TNetGradient(Components[i]).Caption:=AStr(stringofchar(#32,estbk_formxframes.CFakeCaptSpacing))+pManageMnuItem.Caption;
               break;
             end;
   end;

      //sysutils.Sleep(40);
  if  pModalWnd then
      Showmodal
  else
    begin
      Show;
      //Update;
    end;

      // ----
//      Application.Restore;
//      Application.ProcessMessages;
  end;
end;

procedure TestBkMainForm._crwndManagerExt(const pReqModule : TCSModules;
                                          var   pXForm     : TForm;
                                          var   pXFrame    : TFrame;
                                          const pShowForm  : Boolean = true;
                                          const pModalWnd  : Boolean = true;
                                          const pManageMnuItem : TMenuItem = nil;
                                          const pCreateNewEntry : Boolean = false);
var
  pDefWidth  : Integer;
  pDefHeight : Integer;
  pParent    : TWinControl;
  pLeft      : Integer;
  pTop       : Integer;
begin

      self.preValidateSettings(pReqModule);
     {$ifdef mdistyle}
      pParent:=pMainTabSheet; // self;
     {$else}
      pParent:=pMainTabSheet;
     {$endif}

//      pParent:=self.pgStartup;
//   if pModalWnd then
//      pParent:=pMainTab;
      pLeft:=0;
      pTop:=0;

      pXFrame:=nil;
      pXForm:=TformXFrames.Create(nil,self._alwaysModalWindows(pReqModule) or pModalWnd,true);
 with pXForm as TformXFrames do
  begin
   //if not (pReqModule in [__csmSaleBillDebtors,__csmPurchBillDebtors]) then
      self._calcBestPosBylastWnd(pLeft,pTop);

   if not istrueval(dmodule.userStsValues[Csts_forms_as_sdi]) then
      parent:=pParent
   else
      parent:=nil;
      pDefWidth:=940;
      pDefHeight:=650;


      Left:=pLeft;
      Top:=pTop;


      autoLoadData:=false;
      autoCreateNewEntry:=pCreateNewEntry;

      // ----------------
      pXFrame:=initForm(pReqModule,pDefWidth,pDefHeight);

      // ----------------
      //sysutils.Sleep(40);
      onFrameDataEvent:=@self.dataEvents;





   if pShowForm then
     begin
      if pModalWnd then
         Showmodal
      else
       begin
         Show;
         //Update;
       end;
     end;

  // ----
  //Application.ProcessMessages;
  end;
end;


// 24.02.2011 Ingmar; head aastapäeva
procedure TestBkMainForm.openFormdLines(const pType : AStr;
                                        const pManageMnuItem : TMenuItem = nil);
var
  pFrm : TForm;
  pFra : TFrame;
  pitemId,i : Integer;
  pCapt     : AStr;
begin
     pitemId:=dmodule.getDFormMaxIdByType(pType);
     self._crwndManagerExt(__csmDeclDetailedLinesWnd,
                           pFrm,
                           pFra,
                           false,
                           false);

     TframeDeclForms(pFra).selectedFormId:=pitemId;
     TframeDeclForms(pFra).formDefaultSubType:=pType;
     TframeDeclForms(pFra).loadData:=true;

 // täpsustame pealkirja...
 for i:=0 to pFrm.ControlCount-1 do
  if  (pFrm.Controls[i] is TNetGradient) and (pType<>'') then
   begin
         pCapt:='';
    case pType[1] of
      CFormTypeAsVatDecl      : pCapt:=estbk_strmsg.SCFTypeVatDecl;
      CFormTypeAsTSD          : pCapt:=estbk_strmsg.SCFTypeTSD;
      CFormTypeAsBalance      : pCapt:=estbk_strmsg.SCFTypeBalance;
      CFormTypeAsIncStatement : pCapt:=estbk_strmsg.SCFTypeIncStatement;
    end;

       TNetGradient(pFrm.Controls[i]).Caption:=AStr(stringofchar(#32,estbk_formxframes.CFakeCaptSpacing+2))+pCapt;
       // ---
       break;
   end;

 if  glob_userSettings.showWndAsModal then
     pFrm.ShowModal
  else
  begin
     pFrm.Show;
     pFrm.Update;
  end;
end;

procedure TestBkMainForm.openFormdCalc(const pFormdId : Integer;
                                       const pManageMnuItem : TMenuItem = nil;
                                       const pStartDateAsZero : Boolean = false);
var
 pXForm     : TForm;
 pXFrame    : TFrame;
begin
         // ---
         _crwndManagerExt(__csmFormdCalcPrintWnd,
                          pXForm,
                          pXFrame,
                          false,
                          false,
                          pManageMnuItem);


         TframeDeclRez(pXFrame).declFormId:=pFormdId;
         TframeDeclRez(pXFrame).loadData:=true;
         TframeDeclRez(pXFrame).zStartDate:=pStartDateAsZero;

         pXForm.Width:=CSmallWndWidth;
         pXForm.Height:=CSmallWndHeight;

         TformXFrames(pXForm).Constraints.MinWidth:=pXForm.Width;
         TformXFrames(pXForm).Constraints.MinHeight:=pXForm.Height;

    if   glob_userSettings.showWndAsModal then
         pXForm.ShowModal
    else
     begin
         pXForm.Show;
         pXForm.Update;
     end;
end;

procedure TestBkMainForm.dataEvents(Sender: TObject; evSender: TFrameEventSender; itemId: Int64; data : Pointer);
var
  pFrm : TForm;
  pFra : TFrame;
  i : Integer;
begin
  // ---

  case evSender of
    // 29.05.2011 Ingmar; et saaks kohe arvelt artikli sisestada !
    __frameOpenArticleEntry:
    begin
            self._crwndManagerExt(__csmArticlesListWnd,
                                  pFrm,
                                  pFra,
                                  false,
                                  false);

             TframeArticles(pFra).loadData:=true;
         if  glob_userSettings.showWndAsModal then
             pFrm.ShowModal
         else
          begin
             pFrm.Show;
             pFrm.Update;
          end;

    end;


    __frameOpenBillEntry:
    begin
            self._crwndManagerExt(__csmSaleBillWnd,
                                   pFrm,
                                   pFra,
                                   false,
                                   false);




            TframeBills(pFra).loadData:=true;
            TframeBills(pFra).openBill(Integer(itemId));

        if  glob_userSettings.showWndAsModal then
            pFrm.ShowModal
        else
         begin

            pFrm.Show;
            pFrm.Update;

         end;
    //      self.pageCtrlClient.ActivePage := self.TabSheet13;
    //      self.frameBills4.openBill(itemId);
    end;


    __frameOpenAccEntry:
    begin
          self._crwndManagerExt(__csmAccountingWnd,
                                 pFrm,
                                 pFra,
                                 false,
                                 false);

          TframeGeneralLedger(pFra).loadData:=true;
          TframeGeneralLedger(pFra).openEntry(Integer(itemId));
      if  glob_userSettings.showWndAsModal then
          pFrm.ShowModal
      else
       begin
          pFrm.Show;
          pFrm.Update;
       end;
     // self.pageCtrlClient.ActivePage := self.TabSheet2;
     // self.frameGeneralLedger1.openEntry(itemId);
    end;

    __frameObjectAddedChanged:
    begin
       // käime pesad läbi ja karjume, et uuenda andmeid
       for i:=0 to glob_fncwnd_slots[__csmAccountsWnd].Count-1 do
       if  assigned(glob_fncwnd_slots[__csmAccountsWnd].Items[i]) then
           TframeManageAccounts(glob_fncwnd_slots[__csmAccountsWnd].Items[i]).refreshObjectList();

       for i:=0 to glob_fncwnd_slots[__csmAccountingWnd].Count-1 do
       if  assigned(glob_fncwnd_slots[__csmAccountingWnd].Items[i]) then
           TframeGeneralLedger(glob_fncwnd_slots[__csmAccountingWnd].Items[i]).refreshObjectList();
           //self.frameManageAccounts1.refreshObjectList();
           //self.frameGeneralLedger1.refreshObjectList();
    end;

    __frameAccAddedChanged:
    begin


      for i:=0 to glob_fncwnd_slots[__csmGeneralLedgerRepWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmGeneralLedgerRepWnd].Items[i]) then
          TframeGenledreportcrit(glob_fncwnd_slots[__csmGeneralLedgerRepWnd].Items[i]).refreshAccountList();


      for i:=0 to glob_fncwnd_slots[__csmDailyJournalRepWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmDailyJournalRepWnd].Items[i]) then
          TframeGenledreportcrit(glob_fncwnd_slots[__csmDailyJournalRepWnd].Items[i]).refreshAccountList();


      for i:=0 to glob_fncwnd_slots[__csmTurnoverRepWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmTurnoverRepWnd].Items[i]) then
          TframeGenledreportcrit(glob_fncwnd_slots[__csmTurnoverRepWnd].Items[i]).refreshAccountList();



      for i:=0 to glob_fncwnd_slots[__csmSaleBillWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmSaleBillWnd].Items[i]) then
          TframeBills(glob_fncwnd_slots[__csmSaleBillWnd].Items[i]).refreshAccountList();


      for i:=0 to glob_fncwnd_slots[__csmPurchBillWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmPurchBillWnd].Items[i]) then
          TframeBills(glob_fncwnd_slots[__csmPurchBillWnd].Items[i]).refreshAccountList();


      for i:=0 to glob_fncwnd_slots[__csmPrepaymentBillWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmPrepaymentBillWnd].Items[i]) then
          TframeBills(glob_fncwnd_slots[__csmPrepaymentBillWnd].Items[i]).refreshAccountList();



      for i:=0 to glob_fncwnd_slots[__csmCreditBillWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmCreditBillWnd].Items[i]) then
          TframeBills(glob_fncwnd_slots[__csmCreditBillWnd].Items[i]).refreshAccountList();


      for i:=0 to glob_fncwnd_slots[__csmDefaultAccountsWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmDefaultAccountsWnd].Items[i]) then
          TframeConfAccounts(glob_fncwnd_slots[__csmDefaultAccountsWnd].Items[i]).refreshAccounts();
      {
      self.frameGeneralLedger1.refreshAccountList;
      self.frameGenledreportcrit1.refreshAccountList;
      self.frameGenledreportcrit2.refreshAccountList;
      self.frameGenledreportcrit3.refreshAccountList;
 //     self.frameBankIncomeManually1.refreshAccountList;
      frameBills1.refreshAccountList;
      frameBills2.refreshAccountList;
     frameConfAccounts1.refreshAccounts; }
    end;

    __frameGenLedEntryChanged:
    begin
     // self.frameGenLedgerEntrys1.refreshList;
    end;

    __frameArticleDataChanged:
    begin

      for i:=0 to glob_fncwnd_slots[__csmSaleBillWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmSaleBillWnd].Items[i]) then
          TframeBills(glob_fncwnd_slots[__csmSaleBillWnd].Items[i]).refreshArticleList(itemId);


      for i:=0 to glob_fncwnd_slots[__csmPurchBillWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmPurchBillWnd].Items[i]) then
          TframeBills(glob_fncwnd_slots[__csmPurchBillWnd].Items[i]).refreshArticleList(itemId);


      for i:=0 to glob_fncwnd_slots[__csmPrepaymentBillWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmPrepaymentBillWnd].Items[i]) then
          TframeBills(glob_fncwnd_slots[__csmPrepaymentBillWnd].Items[i]).refreshArticleList(itemId);



      for i:=0 to glob_fncwnd_slots[__csmCreditBillWnd].Count-1 do
      if  assigned(glob_fncwnd_slots[__csmCreditBillWnd].Items[i]) then
          TframeBills(glob_fncwnd_slots[__csmCreditBillWnd].Items[i]).refreshArticleList(itemId);
//      frameBills1.refreshArticleList;
//      frameBills2.refreshArticleList;
    end;

    __frameOpenPaymentEntry:
     begin
         self._crwndManagerExt(__csmPaymentsWnd,
                               pFrm,
                               pFra,
                               false,
                               false);

          TframePaymentOrder(pFra).loadData:=true;
          TframePaymentOrder(pFra).openPayment(Integer(itemId));
      if  glob_userSettings.showWndAsModal then
          pFrm.ShowModal
      else
       begin
          pFrm.Show;
          pFrm.Update;
       end;
//      framePaymentOrder1.openPmtOrder(itemId);
//      self.pageCtrlClient.ActivePage := self.TabSheet6;
     end;



    // 04.04.2011 Ingmar;
    // avab siis kassamakse
    __frameOpenCashRegrEntry:
           begin
                 self._crwndManagerExt(__csmCashRegister,
                                       pFrm,
                                       pFra,
                                       false,
                                       false);

                  TframeCashRegister(pFra).loadData:=true;
                  TframeCashRegister(pFra).openCashRegPayment(Integer(itemId));
              if  glob_userSettings.showWndAsModal then
                  pFrm.ShowModal
              else
               begin
                  pFrm.Show;
                  pFrm.Update;
               end;
           end;

    __frameReqCreateNewPrepaymentBill:
     with  TReqOrderMiscData(Data) do
      try
             self._crwndManagerExt(__csmPrepaymentBillWnd,
                                    pFrm,
                                    pFra,
                                    false,
                                    false);

             TframeBills(pFra).loadData:=true;
             TframeBills(pFra).createPrepaymentBill(Integer(FItemId));
         if  glob_userSettings.showWndAsModal then
             pFrm.ShowModal
         else
          begin
             pFrm.Show;
             pFrm.Update;
          end;
//         self.pageCtrlClient.ActivePage := self.TabSheet19;
//         frameBills3.createPrepaymentBill(FItemId);

      finally
      if assigned(Data) then
         TReqOrderMiscData(Data).Free;
      end;



    __frameReqCreateNewPaymentOrder:
     with  TReqOrderMiscData(Data) do
      try // peame andmeklassi vabastama
           self._crwndManagerExt(__csmPaymentsWnd,
                                  pFrm,
                                  pFra,
                                  false,
                                  false);

           TframePaymentOrder(pFra).loadData:=true;
        if FItemType=cOrdItemAsPurchOrder then
           TframePaymentOrder(pFra).createNewPaymentWithPreDefOrder(Integer(FItemId),Integer(FclientID));

        if glob_userSettings.showWndAsModal then
           pFrm.ShowModal
        else
        begin
           pFrm.Show;
           pFrm.Update;
        end;
//          self.pageCtrlClient.ActivePage := self.TabSheet6;
//       if FItemType=cOrdItemAsPurchOrder then
//          framePaymentOrder1.createNewPaymentWithPreDefOrder(FItemId,FclientID);
      finally
      if assigned(Data) then
         TReqOrderMiscData(Data).Free;
      end;



    __frameCreateBillFromOrder:
      with  TReqOrderMiscData(Data) do
      try
             self._crwndManagerExt(__csmPurchBillWnd,
                                    pFrm,
                                    pFra,
                                    false,
                                    false);

             TframeBills(pFra).loadData:=true;
             TframeBills(pFra).createFinalBillFromOrder(Integer(FItemId));

         if  glob_userSettings.showWndAsModal then
             pFrm.ShowModal
          else
          begin
             pFrm.Show;
             pFrm.Update;
          end;
//         self.pageCtrlClient.ActivePage := self.TabSheet10;
//         frameBills1.createFinalBillFromOrder(FItemId);
      finally
      if assigned(Data) then
         TReqOrderMiscData(Data).Free;
      end;



    __frameOpenOrderEntry:
      begin
             self._crwndManagerExt(__csmPurchaseOrderWnd,
                                    pFrm,
                                    pFra,
                                    false,
                                    false);

             TframeOrders(pFra).loadData:=true;
             TframeOrders(pFra).openOrder(Integer(itemid));

         if  glob_userSettings.showWndAsModal then
             pFrm.ShowModal
          else
          begin
             pFrm.Show;
             pFrm.Update;
          end;
//         frameOrders1.openOrder(itemid);
//         self.pageCtrlClient.ActivePage := self.TabSheet15;
      end;





    // arve tasumised
    __frameOpenBillPayments:
      begin

                self._crwndManagerExt(__csmBillPaymentInfoWnd,
                                      pFrm,
                                      pFra,
                                      false,
                                      false);

                TframePaymentInformation(pFra).loadData:=true;
                TframePaymentInformation(pFra).openPaymentInformation(-1,Integer(itemid));

                pFrm.Caption:=estbk_strmsg.CSBtnNamePayments;
                TformXFrames(pFrm).changeSubCaption(estbk_strmsg.CSBtnNamePayments);
            if  glob_userSettings.showWndAsModal then
                pFrm.ShowModal
             else
             begin
                pFrm.Show;
                pFrm.Update;
             end;
      end;


    // arve laekumised ja tasumised...
    __frameOpenBillIncomings:
      begin
             self._crwndManagerExt(__csmBillIncomingsInfoWnd,
                                    pFrm,
                                    pFra,
                                    false,
                                    false);

             TframePaymentInformation(pFra).loadData:=true;
             TframePaymentInformation(pFra).openPaymentInformation(-1,Integer(itemid));
             pFrm.Caption:=estbk_strmsg.CSBtnNameIncomings;
             TformXFrames(pFrm).changeSubCaption(estbk_strmsg.CSBtnNameIncomings);
         if  glob_userSettings.showWndAsModal then
             pFrm.ShowModal
          else
          begin
             pFrm.Show;
             pFrm.Update;
          end;
//        framePaymentInformation1.loadPaymentInformation(-1,itemid);
//        self.pageCtrlClient.ActivePage := self.TabSheet25;
      end;


    // deklaratsiooni detailsed definitsioonid
    __frameOpenDeclDetails:
      begin
             self._crwndManagerExt(__csmDeclDetailedLinesWnd,
                                   pFrm,
                                   pFra,
                                   false,
                                   false);

             TframeDeclForms(pFra).selectedFormId:=Integer(itemId);
             TframeDeclForms(pFra).loadData:=true;

         if  glob_userSettings.showWndAsModal then
             pFrm.ShowModal
          else
          begin
             pFrm.Show;
             pFrm.Update;
          end;
      end;


     // tuli palve ja avatakse laekumine(vajadusel ka redigeerimiseks)
     __frameOpenIncoming:
     begin
            self._crwndManagerExt(__csmIncomingsManualWnd,
                                  pFrm,
                                  pFra,
                                  false,
                                  false);
            TframeBankIncomeManually(pFra).loadData:=true;
            TframeBankIncomeManually(pFra).loadIncomingById(Integer(itemId));

        if  glob_userSettings.showWndAsModal then
            pFrm.ShowModal
         else
         begin
            pFrm.Show;
            pFrm.Update;
         end;

     end;

     // 23.04.2012 Ingmar; avab kassa, kui uus arve ning tasumise liik kassa !
     __frameOpenCashRegister:
     begin
         self._crwndManagerExt(__csmCashRegister,
                               pFrm,
                               pFra,
                               false,
                               false);
         TframeCashRegister(pFra).loadData:=true;
         TframeCashRegister(pFra).callNewCashRegEventExt(itemId,PtrUInt(Data));

     if  glob_userSettings.showWndAsModal then
         pFrm.ShowModal
     else
        begin
         pFrm.Show;
         pFrm.Update;
       end;
     end;

     // dokumendi failide haldus
     __frameOpenDocumentFiles:
     begin
           self._crwndManagerExt(__csmDocumentFilesWnd,
                                 pFrm,
                                 pFra,
                                 false,
                                 false);

           TframeDocFilesMgr(pFra).documentId:=itemId;
           TframeDocFilesMgr(pFra).loadData:=true;

       if  glob_userSettings.showWndAsModal then
           pFrm.ShowModal
        else
        begin
           pFrm.Show;
           pFrm.Update;
        end;
     end;

     // 10.01.2012 Ingmar
     // töötaja
     __frameOpenWorkerEntry:
     begin
           self._crwndManagerExt(__csmWorkerEntryWnd,
                                 pFrm,
                                 pFra,
                                 false,
                                 false);

           // workerId:=itemId;
           TframePersonalCard(pFra).loadData:=true;
           TframePersonalCard(pFra).openPersonalCard(itemId);

       if  glob_userSettings.showWndAsModal then
           pFrm.ShowModal
        else
        begin
           pFrm.Show;
           pFrm.Update;
        end;
     end;

     __frameReqCreateNewWorkerEntry:
      with  TReqOrderMiscData(Data) do
       begin
              self._crwndManagerExt(__csmWorkerEntryWnd,
                                     pFrm,
                                     pFra,
                                     false,
                                     false);

              TframePersonalCard(pFra).loadData:=true;
              TframePersonalCard(pFra).createNewWorker();
          if  glob_userSettings.showWndAsModal then
              pFrm.ShowModal
          else
           begin
              pFrm.Show;
              pFrm.Update;
           end;
        end;

       __frameOpenWorkContractEntry:
        with  TReqOrderMiscData(Data) do
         begin
                self._crwndManagerExt(__csmWorkContractEntry,
                                       pFrm,
                                       pFra,
                                       false,
                                       false);

                TframeWorkContract(pFra).loadData:=true;
                TframeWorkContract(pFra).loadContract(itemId);

            if  glob_userSettings.showWndAsModal then
                pFrm.ShowModal
            else
             begin
                pFrm.Show;
                pFrm.Update;
             end;
         end;


       __frameReqCreateNewContractEntry:
        with  TReqOrderMiscData(Data) do
         begin
                self._crwndManagerExt(__csmWorkContractEntry,
                                       pFrm,
                                       pFra,
                                       false,
                                       false);

                TframeWorkContract(pFra).loadData:=true;
                TframeWorkContract(pFra).createContract();
                TframeWorkContract(pFra).employeeId:=itemId;

            if  glob_userSettings.showWndAsModal then
                pFrm.ShowModal
            else
             begin
                pFrm.Show;
                pFrm.Update;
             end;
         end;

       // 10.08.2012 Ingmar
       __frameCreateNewSaleBill :
         begin
           self._crwndManager(__csmSaleBillWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
         end;

       __frameCreateNewPurchBill:
        begin
          self._crwndManager(__csmPurchBillWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
        end;

       __frameCreateNewPayment:
        begin
          self._crwndManager(__csmPaymentsWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
        end;

       __frameCreateNewAccPayment:
       begin
         self._crwndManager(__csmCashRegister,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
       end;

       __frameCreateNewIncoming:
       begin
         self._crwndManager(__csmIncomingsManualWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
       end;

       __frameCreateNewPOrder:
       begin
         self._crwndManager(__csmPurchaseOrderWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
       end;

       __frameCreateNewAccRcs:
       begin
         self._crwndManager(__csmAccountingWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
       end;
  end;  // ---
end;

// ärme unusta, et formshow event tekib; kui visile muutub trueks !
procedure TestBkMainForm.FormShow(Sender: TObject);
const
   CSDIFormHeight = 45;
begin
 // 10.08.2011 Ingmar millise firma alt töötame !
 self.Caption:=CAppName+' - '+estbk_globvars.glob_currcompname;



 try
  // ----------------------------------------------------------------------
  // ----- uuendame ära valuutakursid baasis !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ----------------------------------------------------------------------
  //{$ifndef debugmode}

    if istrueval(dmodule.userStsValues[Csts_forms_as_sdi]) then
      begin
       self.FormStyle:=fsNormal;
       //fsSystemStayOnTop;
       self.Constraints.MinHeight:=CSDIFormHeight;
       self.Constraints.MaxHeight:=CSDIFormHeight;
       self.Height:=CSDIFormHeight;
      end;


  with estbk_clientdatamodule.dmodule do
  begin

     if istrueval(userStsValues[Csts_downloadlatestCurrRates]) then
       begin
          if not currencyDataOK then
          begin
            downloadCurrencyData;
            currencyDataOK := True;
          end;
       end; // ---
  end;

  //{$endif}
  // -------------

  //p:=dmodule.createPrivateCurrListCopy();


{
  // pärast viska minema
  with estbk_clientdatamodule.dmodule.tempQuery, SQL do
  begin
    Close;
    Clear;
    add('select * from accounting_period');
    Open;
    if EOF then
    begin
      Close;
      Clear;
      add('INSERT INTO accounting_period("name", period_start, company_id, rec_changed,');
      add('rec_changedby, rec_addedby)');
      add('values(''periood 2009'',''2009-01-01'',1,''2009-10-10'',1,1)');
      execSQL;
    end;
  end;
}

//  pageCtrlClient.activePage:=tabShee1_;

  // ---------

//  self.frameGeneralLedger1.onAskCurrencyDownload := @self.onReqDownloadCurrData;
//  self.frameGeneralLedger1.loadData := True;

//  self.frameManageAccounts1.onFrameDataEvent := @self.dataEvents;
//  self.frameManageAccounts1.loadData := True;

//  self.frameObjects1.onFrameDataEvent := @self.dataEvents;
//  self.frameObjects1.loadData := True;

//  frameGenLedgerEntrys1.onFrameDataEvent := @self.dataEvents;
//  frameGenLedgerEntrys1.loadData := True;




{
  frameGenledreportcrit1.reportDefPath:=estbk_utilities.getAppPath+'\reports\';
  frameGenledreportcrit1.reportMode:=CRep_generalledger;
  frameGenledreportcrit1.loadData := True;

  frameGenledreportcrit2.reportDefPath:=estbk_utilities.getAppPath+'\reports\';
  frameGenledreportcrit2.reportMode:=CRep_journal;
  frameGenledreportcrit2.loadData := True;

  frameGenledreportcrit3.reportDefPath:=estbk_utilities.getAppPath+'\reports\';
  frameGenledreportcrit3.reportMode:=CRep_turnover;
  frameGenledreportcrit3.loadData := True;
}







  self.WindowState:=wsMaximized;


// pageCtrlClient.activepage:=TabSheet15;
//pageCtrlClient.activepage:=TabSheet10;


//

//  frameTaxForms1.declFrameMode:=__declDisplayFormContent;
  // frameTaxForms1.declFrameMode:=__declDisplayForms;
///  frameTaxForms1.selectedFormId:=1;


//  frameTaxForms1.loadData:=true;
//  frameTaxDeclRez1.declFormId:=1;
// frameTaxDeclRez1.loadData:=true;



//  pageCtrlClient.activepage:=TabSheet21;
//pageCtrlClient.activepage:=TabSheet2;
// pageCtrlClient.activepage:=TabSheet21;
//pageCtrlClient.activepage:=TabSheet22;


 //frameBankIncomeManually1.fileMode:=true;



{
 frameBankIncomeManually1.onAskCurrencyDownload := @self.onReqDownloadCurrData;
frameBankIncomeManually1.onFrameDataEvent := @self.dataEvents;
frameBankIncomeManually1.loadData:=true;

  }


//pageCtrlClient.activepage:=TabSheet6;
//pageCtrlClient.activepage:=TabSheet2;

//pageCtrlClient.activepage:=TabSheet24;

//tabsheet24.PageIndex:=1;
//pageCtrlClient.activepage:=TabSheet24;


// framePaymentInformation1.loadData:=true;
// framePaymentInformation1.loadPaymentInformation(1);


// pageCtrlClient.activepage:=TabSheet24;
   {
 frameTaxDeclRez1.declFormId:=1;
 frameTaxDeclRez1.loadData:=true; }
  {
  frameTaxForms1.forceResize;
   }

except on e : exception do
  showmessage('viga: '+e.message);
end;

end;


procedure TestBkMainForm.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  edit_verifyNumericEntry(tedit(Sender), key, False);
end;


{
procedure TestBkMainForm.Button1Click(Sender: TObject);
var
  p : TIncomings_base;
  s : astr;
  f : tastrlist;

  xxx : TStatusRepWriter;
begin

 p:= TIncomings_base.create(estbk_clientdatamodule.dmodule.primConnection);
 p.loadBankIFrmtFileDefs('c:\test1.xml',s);
 //p.loadBankIFrmtFileDefs('c:\test.xml',s);
 f:=tastrlist.create;
 //f.Add('c:\abc.txt');
 f.Add('c:\abc1.txt');
 p.readFiles(f,'767',s);


 f.free;
 p.free;
  {
  xxx:=TStatusRepWriter.create(dmodule.primConnection,'XXX');
  xxx.doRepCodeWrite('X1','TEST');
  xxx.ftrData:='FTR';
  xxx.hdrData:='HDR';

  xxx.taskStarts:=now;
  xxx.taskEnds:=now;

  xxx.free;}
end;
  }


// ---------------------------------------------------------------------------

procedure TestBkMainForm.mnuAboutClick(Sender: TObject);
begin
end;

procedure TestBkMainForm.mnuAccountsClick(Sender: TObject);
begin
  self._crwndManager(__csmAccountsWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuArticlesListClick(Sender: TObject);
begin
  self._crwndManager(__csmArticlesListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuBanksClick(Sender: TObject);
begin
   self._crwndManager(__csmBanksListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuBillListClick(Sender: TObject);
begin

end;

procedure TestBkMainForm.mnuClientListClick(Sender: TObject);
begin
  self._crwndManager(__csmClientsListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuWarehouseListClick(Sender: TObject);
begin
  self._crwndManager(__csmWareHouseListwnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;


procedure TestBkMainForm.mnuPurchOrderListClick(Sender: TObject);
begin
end;

procedure TestBkMainForm.mnuPurcOrderReqClick(Sender: TObject);
begin
  // self._crwndManager(__csmPurchaseOrderWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
  self._crwndManager(__csmPurchaseOrderListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuRepDesignerClick(Sender: TObject);
  //pRepDesigner : TFrDesigner;
  //pRepMainFrm  : TfrReport;
begin
 // 0000004 aruande disainer jookseb kokku, viisin eraldi appks !
 // http://www.stiigo.com/mantis/view.php?id=4
 asyncExec.CommandLine := 'stiigorepdesign';
 asyncExec.Execute;
// stiigorepdesign.exe
 //try
   //pRepDesigner:=TFrDesigner.Create(nil);
   //pRepMainFrm:=TfrReport.Create(nil);
   //pRepMainFrm.DesignReport;

 //finally
   //freeAndNil(pRepDesigner);
   //freeAndNil(pRepMainFrm);
 //end;
 // --
end;

procedure TestBkMainForm.mnuSaleBillClick(Sender: TObject);
begin
  //self._crwndManager(__csmSaleBillWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
  self._crwndManager(__csmSaleBillListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;


procedure TestBkMainForm.mnuUpdateStiigoClick(Sender: TObject);
begin
 asyncExec.CommandLine := 'stiigoupdater';
 asyncExec.Execute;
end;


// Käibemaksude hetkeseis
procedure TestBkMainForm.mnuVatDeclRezClick(Sender: TObject);
var
  pChooseFrm    : TformChoosedFrm;
  pVATDeclFrmID : Integer;
begin
      preValidateSettings(__csmFormdCalcPrintWnd);
  try
      pVATDeclFrmID:=0;
      // --
      pChooseFrm:=TformChoosedFrm.Create(nil);
   if pChooseFrm.showmodal(estbk_strmsg.SEVatDeclForm,pVATDeclFrmID,estbk_types.CFormTypeAsVatDecl) then
      self.openFormdCalc(pVATDeclFrmID,TMenuItem(Sender));

  finally
      freeAndNil(pChooseFrm)
  end;
end;

procedure TestBkMainForm.mnuProfitRepClick(Sender: TObject);
var
  pInstSt : Integer;
begin
   preValidateSettings(__csmFormdCalcPrintWnd);
   pInstSt:=dmodule.getDFormMaxIdByType(estbk_types.CFormTypeAsIncStatement);
//if pInstSt>0 then
   self.openFormdCalc(pInstSt,TMenuItem(Sender),true);
end;

procedure TestBkMainForm.mnuPurchBillClick(Sender: TObject);
begin
   //self._crwndManager(__csmPurchBillWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
   self._crwndManager(__csmPurchBillListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;


procedure TestBkMainForm.mnuItemPurchBillListClick(Sender: TObject);
begin

end;

procedure TestBkMainForm.mnuItemVatDeclClick(Sender: TObject);
begin
    self.openFormdLines(CFormTypeAsVatDecl,TMenuItem(Sender));
    // mõtlen, kas on hea anda üldse käibemaksu vormi valida; teen lihtsustuse, et üks vaikimisivorm avaneb
    // tulevikus ehk taastan selle akna
    //self._crwndManager(__csmVATDeclDefWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuObjectsClick(Sender: TObject);
begin
 self._crwndManager(__csmAccountingObjectsWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;


procedure TestBkMainForm.mnuPaymentscClick(Sender: TObject);
begin
  // self._crwndManager(__csmPaymentsWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal,CCreateNewEntry);
  self._crwndManager(__csmPaymentsListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuPaymentsClick(Sender: TObject);
begin

end;


procedure TestBkMainForm.mnuItemBalanceClick(Sender: TObject);
begin
   self.openFormdLines(CFormTypeAsBalance,TMenuItem(Sender));
end;

procedure TestBkMainForm.mnuItemDefAccountsClick(Sender: TObject);
begin
   self._crwndManager(__csmDefaultAccountsWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuItemGenLedgerClick(Sender: TObject);
begin
  self._crwndManager(__csmGeneralLedgEntryListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuItemIncStatementClick(Sender: TObject);
begin
    self.openFormdLines(CFormTypeAsIncStatement,TMenuItem(Sender));
end;

procedure TestBkMainForm.mnuIncomingsFromFilecClick(Sender: TObject);
var
  pFrm : TForm;
  pFra : TFrame;
  pBankCode : AStr;
  pFilename : AStr;
  pMarkAsOkItemsAsVerif : Boolean;
begin
   if estbk_frm_choosebank.__chooseBankFile(pBankCode,pFilename,pMarkAsOkItemsAsVerif) then
     begin
             self._crwndManagerExt(__csmIncomingsFileWnd,
                                  pFrm,
                                  pFra,
                                  false,
                                  false);
            TframeBankIncomeManually(pFra).loadData:=true;
            TframeBankIncomeManually(pFra).readBankFile(pFilename,pBankCode,pMarkAsOkItemsAsVerif, pBankCode = 'SEPA');
            // TframeBankIncomeManually(pFra).readBankFile('C:\LAZUNITS\i386-win32\conf\u_net_kvv.csv','401');
            // TframeBankIncomeManually(pFra).readBankFile('C:\LAZUNITS\i386-win32\conf\statement.csv','767');
        if  glob_userSettings.showWndAsModal then
            pFrm.ShowModal
         else
         begin
            pFrm.Show;
            pFrm.Update;
         end;
     end;
end;




procedure TestBkMainForm.mnuIncomingsManualcClick(Sender: TObject);
begin
  self._crwndManager(__csmIncomingsListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuIncomingsManualClick(Sender: TObject);
begin

end;

procedure TestBkMainForm.mnuGenLedgerRepClick(Sender: TObject);
begin
  self._crwndManager(__csmGeneralLedgerRepWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuDailyJournalClick(Sender: TObject);
begin
   self._crwndManager(__csmDailyJournalRepWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

{
 SCDebtBillTypeSale  = 'Tasumata müügiarved';
 SCDebtBillTypePurch = 'Tasumata ostuarved';
}

procedure TestBkMainForm.mnuDebtorsSaleClick(Sender: TObject);
var
  pFrm : TForm;
  pFra : TFrame;
begin
           self._crwndManagerExt(__csmSaleBillDebtors,
                                  pFrm,
                                  pFra,
                                  false,
                                  false);
            pFra.Align:=alNone;
            TframeDebtors(pFra).billType:=estbk_types._CItemSaleBill;
            TframeDebtors(pFra).loadData:=true;
              {
            TformXFrames(pFrm).Constraints.MinWidth:=CDebtWndWidth;
            TformXFrames(pFrm).Constraints.MinHeight:=CDebtWndHeight;

            TformXFrames(pFrm).Constraints.MaxWidth:=CDebtWndWidth;
            TformXFrames(pFrm).Constraints.MaxHeight:=CDebtWndHeight; }


            pFrm.Width:=CSmallWndWidth;
            pFrm.Height:=CSmallWndHeight;

            TformXFrames(pFrm).Constraints.MinWidth:=pFrm.Width;
            TformXFrames(pFrm).Constraints.MinHeight:=pFrm.Height;

            //TformXFrames(pFrm).Constraints.MaxWidth:=pFrm.Width-5;
            //TformXFrames(pFrm).Constraints.MaxHeight:=pFrm.Height-5;

            pFra.Align:=alClient;
            pFrm.Position:=poDesktopCenter;
        if  glob_userSettings.showWndAsModal then
            pFrm.ShowModal
         else
         begin
            pFrm.Show;
            pFrm.Update;
         end;
end;

procedure TestBkMainForm.mnuDebtPurchClick(Sender: TObject);
var
  pFrm : TForm;
  pFra : TFrame;
begin

           self._crwndManagerExt(__csmPurchBillDebtors,
                                  pFrm,
                                  pFra,
                                  false,
                                  false);

            TframeDebtors(pFra).billType:=estbk_types._CItemPurchBill;
            TframeDebtors(pFra).loadData:=true;

            TformXFrames(pFrm).Constraints.MinWidth:=CSmallWndWidth;
            TformXFrames(pFrm).Constraints.MinHeight:=CSmallWndHeight;

            TformXFrames(pFrm).Constraints.MaxWidth:=CSmallWndWidth;
            TformXFrames(pFrm).Constraints.MaxHeight:=CSmallWndHeight;

            pFrm.Width:=CSmallWndWidth;
            pFrm.Height:=CSmallWndHeight;
            pFrm.Position:=poDesktopCenter;
        if  glob_userSettings.showWndAsModal then
            pFrm.ShowModal
         else
         begin
            pFrm.Show;
            pFrm.Update;
         end;
end;

procedure TestBkMainForm.mnuAccTurnoverClick(Sender: TObject);
begin
   self._crwndManager(__csmTurnoverRepWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuAppSettingsClick(Sender: TObject);
begin
     self._crwndManager(__csmAppConfDialog,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuBalanceClick(Sender: TObject);
var
  pBalDeclFrmID : Integer;
begin
   preValidateSettings(__csmFormdCalcPrintWnd);
   pBalDeclFrmID:=dmodule.getDFormMaxIdByType(estbk_types.CFormTypeAsBalance);
//if pBalDeclFrmID>0 then
   self.openFormdCalc(pBalDeclFrmID,TMenuItem(Sender),true);


end;

procedure TestBkMainForm.mnuBalanceDeclRezClick(Sender: TObject);
begin
end;

procedure TestBkMainForm.mnuCashboxClick(Sender: TObject);
begin

end;


procedure TestBkMainForm.mnuAccountingListClick(Sender: TObject);
begin

end;

procedure TestBkMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   i : TCSModules;
   j : Integer;
   pForm : TForm;
begin

  {$ifndef mdistyle}
       estbk_formxframes.glob_fncwnd_finalterm:=true;
  for  i:=low(TCSModules) to high(TCSModules) do
   for j:=glob_fncwnd_slots[i].Count-1 downto 0 do
    if assigned(glob_fncwnd_slots[i].Items[j]) then
    begin
      if TFrame(glob_fncwnd_slots[i].Items[j]).Parent is TPanel then
       begin
       if TPanel(TFrame(glob_fncwnd_slots[i].Items[j]).Parent).Parent is TForm then
         begin
           pForm:=TForm(TPanel(TFrame(glob_fncwnd_slots[i].Items[j]).Parent).Parent);
           pForm.Close;
           pForm.Free;
         end;

       end;
    end;
  {$endif}
end;


procedure TestBkMainForm.heightFixTimer(Sender: TObject);
var
   bForceFormSize : Boolean;
begin

// if Self.Visible And (Self.Height < Self.Constraints.MinHeight) then
 if Self.Visible then
    try

       bForceFormSize := FindCmdLineSwitch('forceformsize',['-','/'], true);
    if bForceFormSize then
      begin

         Self.Constraints.MinHeight := 600;
         Self.Constraints.MinWidth := 800;

         Application.BringToFront;
         Self.WindowState := wsNormal;
         Self.WindowState := wsMaximized;
         Application.Restore;

      end;
      // ---
    finally
      TTimer(Sender).Enabled := false;
    end;
end;

procedure TestBkMainForm.mnucashbookClick(Sender: TObject);
var
  pFrm : TForm;
  pFra : TFrame;
begin
           self._crwndManagerExt(__csmCashBook,
                                  pFrm,
                                  pFra,
                                  false,
                                  false);
            pFra.Align:=alNone;
            TframeCashbook(pFra).loadData:=true;


            pFrm.Width:=CSmallWndWidth;
            pFrm.Height:=CSmallWndHeight;

            TformXFrames(pFrm).Constraints.MinWidth:=pFrm.Width;
            TformXFrames(pFrm).Constraints.MinHeight:=pFrm.Height;

            //TformXFrames(pFrm).Constraints.MaxWidth:=pFrm.Width-5;
            //TformXFrames(pFrm).Constraints.MaxHeight:=pFrm.Height-5;

            pFra.Align:=alClient;
            pFrm.Position:=poDesktopCenter;
        if  glob_userSettings.showWndAsModal then
            pFrm.ShowModal
         else
         begin
            pFrm.Show;
            pFrm.Update;
         end;
end;

procedure TestBkMainForm.mnuCboxPaymentsClick(Sender: TObject);
begin
  self._crwndManager(__csmCashRegPaymentsListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuClosingAccRecClick(Sender: TObject);
begin
  estbk_frm_accperfinalize.TformAccPerFinalize.showAndCreate;
end;

procedure TestBkMainForm.mnuCurrencyClick(Sender: TObject);
begin
  estbk_frm_currlist.TformCurrlist.showAndCreate();
end;



procedure TestBkMainForm.mnuDebugClick(Sender: TObject);
function getBalance(const pStr : TStringStream) : Double;
begin

end;

{$ifdef debugmode}
{$endif}
begin
{$ifdef debugmode}
{$endif}
end;

procedure TestBkMainForm.mnuDonationClick(Sender: TObject);
begin
end;

procedure TestBkMainForm.mnuFormsClick(Sender: TObject);
begin
  // ---
end;

procedure TestBkMainForm.mnuImportEBillsClick(Sender: TObject);
begin
  estbk_frm_ebill_import.TfrmEBillImport.showAndCreate();
end;

procedure TestBkMainForm.mnuInfoClick(Sender: TObject);
begin
with estbk_frm_about.TformAbout.Create(self) do
 try
  //showmodal;
  show;
 finally
  //free;
 end;
end;

procedure TestBkMainForm.mnuItemCashRegListClick(Sender: TObject);
begin
end;

procedure TestBkMainForm.mnuItemWorkerClick(Sender: TObject);
begin
 self._crwndManager(__csmWorkerListWnd,TMenuItem(Sender),glob_userSettings.showWndAsModal);
end;

procedure TestBkMainForm.mnuPaymentOrderListClick(Sender: TObject);
begin
end;


procedure TestBkMainForm.MnuexitClick(Sender: TObject);
begin
  Application.Terminate;
end;



initialization
  {$I estbk_main.ctrs}

end.