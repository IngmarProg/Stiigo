unit estbk_fra_appsettings;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, Buttons, Graphics,Dialogs,
  ExtCtrls, estbk_fra_template,estbk_uivisualinit, estbk_strmsg, estbk_clientdatamodule,
  estbk_types, LCLType, ComCtrls, estbk_globvars, estbk_lib_commonevents;

type


  { TframeAppSettings }

  TframeAppSettings = class(Tfra_template)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnDefaultSettings: TBitBtn;
    btnClose: TBitBtn;
    btnEMailSettings: TBitBtn;
    chkDisplayBillLinesObjField: TCheckBox;
    chkBoxGetLatestCurrExcRates: TCheckBox;
    chkBoxFormType: TCheckBox;
    chkDisplayBillLinesCarVatField: TCheckBox;
    cmbActiveLang: TComboBox;
    edtBillRepFileLocation: TEdit;
    lblBillRepTemplateOvr: TLabel;
    lblActiveLanguage: TLabel;
    lblEmailSendername: TLabeledEdit;
    lblEmail: TLabeledEdit;
    lblSMTPPort: TLabeledEdit;
    lblSmtpServer: TLabeledEdit;
    btnChooseFile: TSpeedButton;
    dlgBillRepFile: TOpenDialog;
    tabPgCtrl: TPageControl;
    pgrp: TGroupBox;
    tabCommonSettings: TTabSheet;
    tabEmail: TTabSheet;
    procedure btnChooseFileClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDefaultSettingsClick(Sender: TObject);
    procedure btnEMailSettingsClick(Sender: TObject);
    procedure lblEmailKeyPress(Sender: TObject; var Key: char);
    procedure lblSMTPPortKeyPress(Sender: TObject; var Key: char);
    procedure tabPgCtrlChange(Sender: TObject);
  private
    // ---
    FframeKillSignal:  TNotifyEvent;
    FParentKeyNotif:   TKeyNotEvent;
    FFrameDataEvent:   TFrameReqEvent;

    function  getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure loadLanguages(const pLanguageCode : AStr);
    procedure refreshSettings;
  public
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  // RTTI probleem
  published
    property onFrameKillSignal     : TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData         : boolean read getDataLoadStatus write setDataLoadStatus;
  end; 

implementation
uses estbk_utilities,estbk_settings,languagecodes;

type
   TStrLangObject =  class
     pLangCode : AStr;
   end;

procedure TframeAppSettings.btnCloseClick(Sender: TObject);
begin
  if assigned(self.onFrameKillSignal) then
     self.onFrameKillSignal(self);
end;

procedure TframeAppSettings.btnChooseFileClick(Sender: TObject);
begin
  if dlgBillRepFile.Execute then
     edtBillRepFileLocation.Text:= dlgBillRepFile.Files.Strings[0];
end;

procedure TframeAppSettings.btnDefaultSettingsClick(Sender: TObject);
begin
 tabPgCtrl.ActivePage:=tabCommonSettings;
 //btnDefaultSettings.Enabled:=false;
 //btnEMailSettings.Enabled:=true;
end;

procedure TframeAppSettings.btnEMailSettingsClick(Sender: TObject);
begin
 tabPgCtrl.ActivePage:=tabEmail;
 //btnDefaultSettings.Enabled:=true;
 //btnEMailSettings.Enabled:=false;
end;

procedure TframeAppSettings.lblEmailKeyPress(Sender: TObject; var Key: char);
begin
 if key=#13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeAppSettings.lblSMTPPortKeyPress(Sender: TObject; var Key: char);
begin
 if key=#13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end else
    estbk_utilities.edit_verifyNumericEntry(Sender as TCustomEdit,key);
end;

procedure TframeAppSettings.tabPgCtrlChange(Sender: TObject);
//var
//  pPageCapt : AStr;
begin
 if tabPgCtrl.ActivePage =  tabCommonSettings then
   begin
     btnDefaultSettings.Font.Style:=[fsBold];
     btnEMailSettings.Font.Style:=[];
   end else
 if tabPgCtrl.ActivePage =  tabEmail then
   begin
     btnDefaultSettings.Font.Style:=[];
     btnEMailSettings.Font.Style:=[fsBold];
   end;

//    pPageCapt:=TPageControl(Sender).ActivePage.Caption;
//if (TPageControl(Sender).ActivePage.ControlCount>0) and (TPageControl(Sender).ActivePage.Controls[0] is TGroupBox) then
//   (TPageControl(Sender).ActivePage.Controls[0] as TGroupBox).Caption:=pPageCapt;
end;

function   TframeAppSettings.getDataLoadStatus: boolean;
begin
  result:=true;
end;

// dummy
procedure  TframeAppSettings.setDataLoadStatus(const v: boolean);
begin
end;



constructor TframeAppSettings.create(frameOwner: TComponent);
var
 pTemp : AStr;
begin
 inherited create(frameOwner);
 estbk_uivisualinit.__preparevisual(self);
 tabPgCtrl.ShowTabs:=false;
 tabPgCtrl.ActivePage:=self.tabCommonSettings;

 chkBoxGetLatestCurrExcRates.Tag:=ord(estbk_settings.Csts_downloadlatestCurrRates);
 chkBoxGetLatestCurrExcRates.Checked:=isTrueVal(dmodule.userStsValues[estbk_settings.Csts_downloadlatestCurrRates]);

 chkBoxFormType.Tag:=ord(estbk_settings.Csts_forms_as_sdi);
 chkBoxFormType.Checked:=isTrueVal(dmodule.userStsValues[estbk_settings.Csts_forms_as_sdi]);

 lblEmail.Tag:=ord(estbk_settings.Csts_email_addr);
 lblEmail.Text:=dmodule.userStsValues[estbk_settings.Csts_email_addr];

 lblSmtpServer.Tag:=ord(estbk_settings.Csts_smtp_srv);
 lblSmtpServer.Text:=dmodule.userStsValues[estbk_settings.Csts_smtp_srv];

 lblSMTPPort.Tag:=ord(estbk_settings.Csts_smtp_port);
 lblSMTPPort.Text:=dmodule.userStsValues[estbk_settings.Csts_smtp_port];

 chkDisplayBillLinesObjField.Tag:=ord(estbk_settings.CstsShowObjFieldInBillLines);
 chkDisplayBillLinesObjField.Checked:=isTrueVal(dmodule.userStsValues[estbk_settings.CstsShowObjFieldInBillLines]);

 // 20.04.2015 Ingmar
 chkDisplayBillLinesCarVatField.Tag:=ord(estbk_settings.CstsShowVATReturnFieldInBillLines);
 chkDisplayBillLinesCarVatField.Checked:=isTrueVal(dmodule.userStsValues[estbk_settings.CstsShowVATReturnFieldInBillLines]);


 lblEmailSendername.Tag:=ord(estbk_settings.Csts_email_sendername);
 lblEmailSendername.Text:=dmodule.userStsValues[estbk_settings.Csts_email_sendername];
 // --
 // 11.04.2013 Ingmar
 edtBillRepFileLocation.Tag:=ord(estbk_settings.Csts_bill_rep_templatename);




 pTemp:=dmodule.userStsValues[estbk_settings.Csts_bill_rep_templatename];
 pTemp:=StringReplace(pTemp,'\134','\',[rfReplaceAll]);
 edtBillRepFileLocation.Text:=pTemp;
 // chkBoxGetLatestCurrExcRates.Checked:=glob_userSettings.stn_fetchLatestCurrRatesOnLoad;

 cmbActiveLang.Tag:=ord(estbk_settings.Csts_active_language);
 loadLanguages(dmodule.userStsValues[estbk_settings.Csts_active_language]);
end;


procedure   TframeAppSettings.loadLanguages(const pLanguageCode : AStr);
var
 pLangCode  : AStr;
 pAppPath   : AStr;
 pTrandname : AStr;
 psrcResult : TSearchRec;
 ppos : Integer;
 plangObj : TStrLangObject;
 pLangLongname   : AStr;
 pActiveLangIndx : Integer;
begin
    pActiveLangIndx:=-1;
    pAppPath:=includeTrailingBackSlash(extractfilepath(paramStr(0)))+'locale\*.*';
    // --
 try

 if FindFirst(pAppPath, faDirectory, psrcResult) = 0 then
  begin
    repeat
      if (psrcResult.attr and faDirectory) = faDirectory then
        begin
           pTrandname:=psrcResult.name;
        if(pTrandname='.') or (pTrandname='..') then
           continue;

           pLangCode:=trim(pTrandname);
           ppos:= pos('_',pLangCode);
        if ppos>0 then
           pLangCode:= trim(system.copy(pLangCode,1,ppos-1));

           pLangLongname:= trim(languagecodes.getlanguagename(pLangCode));
        if pLangLongname='' then
           continue;

           plangObj:=TStrLangObject.Create;
           plangObj.pLangCode:=pLangCode;

        if(pLangCode=pLanguageCode) or ((pLangCode='et') and (pLanguageCode='')) then
           pActiveLangIndx:=cmbActiveLang.Items.AddObject(pLangLongname,plangObj)
        else
           cmbActiveLang.Items.AddObject(pLangLongname,plangObj);
        end;

    until FindNext(psrcResult) <> 0;

  end;
  finally
    FindClose(psrcResult);
  end;
    // @@@
    cmbActiveLang.ItemIndex:=pActiveLangIndx;
end;

procedure   TframeAppSettings.refreshSettings;
var
  i,j : Integer;
  pTagToOrd : Integer;
  pStsIndx  : TStsIndex;
  pPage     : TTabSheet;
  pEditVal  : AStr;
begin

  for i:=0 to tabPgCtrl.PageCount-1 do
   begin
           pPage:=tabPgCtrl.Pages[i];
       for j:=0 to pPage.ControlCount-1 do
        if pPage.Controls[j] = self.cmbActiveLang then
          begin
               pTagToOrd:=self.cmbActiveLang.Tag;
          if  (pTagToOrd>=ord(low(TStsIndex))) and (pTagToOrd<=ord(high(TStsIndex))) then
             begin

             if self.cmbActiveLang.ItemIndex>=0 then
                dmodule.userStsValues[TStsIndex(pTagToOrd)]:= TStrLangObject(cmbActiveLang.Items.Objects[cmbActiveLang.ItemIndex]).pLangCode
             else
                dmodule.userStsValues[TStsIndex(pTagToOrd)]:= 'et';
             end;


          end else
        if pPage.Controls[j] is TCheckbox then
         begin
              pTagToOrd:=TCheckbox(pPage.Controls[j]).Tag;
         if  (pTagToOrd>=ord(low(TStsIndex))) and (pTagToOrd<=ord(high(TStsIndex))) then
              dmodule.userStsValues[TStsIndex(pTagToOrd)]:=estbk_types.SCFalseTrue[TCheckbox(pPage.Controls[j]).Checked];
         end else
        if (pPage.Controls[j] is TEdit) or (pPage.Controls[j] is TLabeledEdit) then
         begin
             pTagToOrd:=TEdit(pPage.Controls[j]).Tag;
         if (pTagToOrd>=ord(low(TStsIndex))) and (pTagToOrd<=ord(high(TStsIndex))) then
           begin

               pEditVal:=trim(TEdit(pPage.Controls[j]).Text);
           // postgre escape teema !
           //if (pos('\\',pEditVal)=0) and (pos('\',pEditVal)>0) then
               pEditVal:=StringReplace(pEditVal,'\134','\',[rfReplaceAll]);
               dmodule.userStsValues[TStsIndex(pTagToOrd)]:=pEditVal;
           end;
         end;
   end;
end;

destructor  TframeAppSettings.destroy;
var
 i : Integer;
begin
     self.refreshSettings;
     dmodule.saveUserSettings;
 for i:= 0 to cmbActiveLang.Items.Count - 1 do
  if assigned(cmbActiveLang.Items.Objects[i]) then
    begin
     cmbActiveLang.Items.Objects[i].Free;
     cmbActiveLang.Items.Objects[i]:=nil;
    end;

     // glob_userSettings.stn_fetchLatestCurrRatesOnLoad:=chkBoxGetLatestCurrExcRates.Checked;
     inherited destroy;

end;

initialization
  {$I estbk_fra_appsettings.ctrs}

end.

