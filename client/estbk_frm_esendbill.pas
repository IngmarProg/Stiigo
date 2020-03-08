unit estbk_frm_esendbill;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, estbk_types, estbk_lib_commonevents, estbk_frm_template;

type
  TformEMailBill = class(TfrmTemplate)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnSend: TBitBtn;
    btnCancel: TBitBtn;
    cbEBill: TCheckBox;
    GroupBox1: TGroupBox;
    lblExtDescr: TLabel;
    lblEMailSubject: TLabeledEdit;
    lblEMailrcv: TLabeledEdit;
    memoExtrDescr: TMemo;
    procedure btnSendClick(Sender: TObject);
    procedure lblEMailrcvKeyPress(Sender: TObject; var Key: char);
  protected
    FGenerateRepCbk: TStrCallback;
    FLogEmails: boolean;
    FItemId: integer;
    FItemType: AStr;
    FItemCommonNr: AStr;
    procedure logEmails(const pSendEMailTo: AStr; const pSubject: AStr; const pMailBodyAs: AStr);
    function validateEmail(var pemail: AStr): boolean;
  public
    class function createAndShow(const pGenerateRepCbk: TStrCallback; const pEMailAddr: AStr; const pEMailSubject: AStr;
      const pEMailExtDescr: AStr; const pLogEmail: boolean = False; const pItemID: integer = -1; const pItemType: AStr = '';
      const pItemCommonNr: AStr = ''): boolean;
  end;

var
  formEMailBill: TformEMailBill;
// http://webcache.googleusercontent.com/search?q=cache:OkHGA78X094J:www.regular-expressions.info/email.html+regexp+email&cd=1&hl=et&ct=clnk&gl=ee&source=www.google.ee
implementation

uses IdCoderHeader, estbk_strmsg, estbk_sqlclientcollection, estbk_lib_sendemail, estbk_ebill,
  estbk_clientdatamodule, estbk_settings, regexpr, estbk_globvars, estbk_utilities;

{ TformEMailBill }
// TODO muuta universaalsemaks; dialoogi pealkiri ära muuta; Arve saata aadressile ära muuta;
// siis saame seda moodulit ka mujal kasutada
class function TformEMailBill.createAndShow(const pGenerateRepCbk: TStrCallback; const pEMailAddr: AStr;
  const pEMailSubject: AStr; const pEMailExtDescr: AStr; const pLogEmail: boolean = False; const pItemID: integer = -1;
  const pItemType: AStr = ''; const pItemCommonNr: AStr = ''): boolean;

  function loadTemplate(const pBody: AStr): Astr;
  var
    pEKirjaTemplNimi: AStr;
    pTempf: TFileStream;
    pTemps: TStringStream;
  begin
    Result := Trim(pBody);
    pEKirjaTemplNimi := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0))) + 'templates\' +
      StringReplace(Utf8ToAnsi(estbk_globvars.glob_currcompname), #32, '_', [rfReplaceAll]) + '.htm';
    if FileExists(pEKirjaTemplNimi) then
      try
        pTemps := nil;
        pTempf := TFileStream.Create(pEKirjaTemplNimi, fmOpenRead);
        pTemps := TStringStream.Create('');
        pTemps.CopyFrom(pTempf, pTempf.Size);
        pTemps.Seek(0, 0);
        Result := pTemps.DataString;
        Result := StringReplace(Result, '<<companyname>>', estbk_globvars.glob_currcompname, [rfReplaceAll, rfIgnoreCase]);
        Result := StringReplace(Result, '<<companyregcode>>', estbk_globvars.glob_currcompregcode, [rfReplaceAll, rfIgnoreCase]);
        Result := StringReplace(Result, '<<companyaddress>>', estbk_globvars.glob_currcompaddr, [rfReplaceAll, rfIgnoreCase]);
        Result := StringReplace(Result, '<<companyvatnr>>', estbk_globvars.glob_currcompvatnr, [rfReplaceAll, rfIgnoreCase]);
      finally
        FreeAndNil(pTempf);
        FreeAndNil(pTemps);
      end;
  end;

begin
  with TformEMailBill.Create(nil) do
    try
      FGenerateRepCbk := pGenerateRepCbk;
      lblEMailrcv.Text := pEMailAddr;
      lblEMailSubject.Text := pEMailSubject;
      memoExtrDescr.Lines.Text := loadTemplate(pEMailExtDescr);
      FItemId := pItemId;
      FItemType := pItemType;
      FItemCommonNr := pItemCommonNr;

      cbEBill.Visible := Trim(FItemCommonNr) <> '';
      Result := Showmodal = mrOk;
    finally
      Free;
    end;
end;

procedure TformEMailBill.lblEMailrcvKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end; // --
end;

procedure TformEMailBill.logEmails(const pSendEMailTo: AStr; const pSubject: AStr; const pMailBodyAs: AStr);
var
  pParamCheck: boolean;
  pEmailRecId: integer;
begin
  try
    pEmailRecId := estbk_clientdatamodule.dmodule.qryEmailSeq.GetNextValue;
    with estbk_clientdatamodule.dmodule.tempQuery, SQL do
      try
        pParamCheck := ParamCheck;
        Close;
        Clear;

        ParamCheck := True;
        add(estbk_sqlclientcollection._SQLInsertEMail);
        paramByname('id').AsInteger := pEmailRecId;
        paramByname('email').AsString := pSendEMailTo;
        paramByname('subject').AsString := pSubject;
        paramByname('body').AsString := pSubject;
        paramByname('request_date').AsDateTime := now;
        paramByname('letter_send_date').AsDateTime := now;
        paramByname('when_to_send').AsDateTime := now;
        paramByname('status').AsString := 'OK'; // kui smtp läbi lasi, siis ok järelikult !
        paramByname('emsg').AsString := ''; // hetkel ma ei logi vigaseid asju
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        execSQL;


        // -- paneme ka paika seose saadetava elemendiga; et kasutaja saaks vältida topelt saatmist !
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLInsertSentMails);
        paramByname('email_id').AsInteger := pEmailRecId;
        paramByname('item_id').AsInteger := self.FItemId;
        paramByname('item_type').AsString := self.FItemType;
        paramByname('classificator_id').AsInteger := 0;
        paramByname('client_id').AsInteger := 0;
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        execSQL;
      finally
        Close;
        Clear;
        ParamCheck := pParamCheck;
      end;

  except // -- et meili saatmine siiski ei katkeks !
  end;
end;

function TformEMailBill.validateEmail(var pemail: AStr): boolean;
var
  pExpr: TRegExpr;
  pEmails: TAStrList;
  i: integer;
begin
  try
    Result := True; // ***
    pExpr := TRegExpr.Create();
    pEmails := TAStrlist.Create;
    pEmail := trim(lblEMailrcv.Text);
    pEmail := stringreplace(pEmail, ';', ',', [rfReplaceAll]);
    pEmails.Delimiter := ',';
    pEmails.DelimitedText := pEmail;

    pEmail := ''; // kirjutame trimmitult puhvrisse tagasi !
    pExpr.Expression := estbk_types.CEMailRegExpr;
    for i := 0 to pEmails.Count - 1 do
    begin
      Result := Result and pExpr.Exec(pEmails.Strings[i]);
      if not Result then
      begin
        pEmail := '';
        Exit;
      end;

      if pEmail <> '' then
        pEmail := pEmail + ',';
      pEmail := pEmail + trim(pEmails.Strings[i]);
    end;

  finally
    FreeAndNil(pExpr);
    FreeAndNil(pEmails);
  end;
end;

procedure TformEMailBill.btnSendClick(Sender: TObject);

var
  pMailObj: TEstbkSendMail;
  pRepTempfile: AStr;
  pMailBody: AStr;
  pMailBodyAsTAStr: TAStrList;
  pFilesToAttach: TAStrList;
  pCursor: TCursor;
  pSenderName: AStr;
  pEmailRcvAddr: AStr;
  pAtPos: integer;
  pDummyMsgId: AStr;
  pEBillfilePath: AStr;
  pEBillFile: TextFile;
begin
  try
    pRepTempfile := '';
    pMailBodyAsTAStr := TAStrList.Create();
    pFilesToAttach := TAStrList.Create();
    pMailObj := TEstbkSendMail.Create(dmodule.userStsValues[Csts_smtp_srv], strtointdef(dmodule.userStsValues[Csts_smtp_port], 25),
      // hetkel smtp parooli ei toeta !
      '', '', CDummyEMailClient


      //'Microsoft Outlook Express 6.00.2900.5931'); jäi kinni zone spämmi filtrisse !
      // teisel juhul võivad spämmimootorid meid spämmeriks tunnistada !);
      );
    //r:=generateregexprengine(estbk_types.CEMailRegExpr,[ref_caseinsensitive]);
    {
              pExpr.Expression:=estbk_types.CEMailRegExpr;
           if not pExpr.Exec(lblEMailrcv.Text) then
             begin
              dialogs.messageDlg(estbk_strmsg.SEEMailAddrIncorrect,mtError,[mbOk],0);
              Exit; // --
             end;
    }
    pEmailRcvAddr := '';
    if not self.validateEmail(pEmailRcvAddr) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEEMailAddrIncorrect, mtError, [mbOK], 0);
      Exit; // --
    end;

    if Trim(lblEMailSubject.Text) = '' then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEEMailSubjectIsMissing, mtError, [mbOK], 0);
      Exit; // --
    end;

    try
      pEBillfilePath := '';
      pCursor := Screen.Cursor;
      Screen.Cursor := crHourglass;

      if assigned(FGenerateRepCbk) then
        TStrCallback(self.FGenerateRepCbk)(pRepTempfile);

      // 10.09.2016 Ingmar; annan võimaluse ka automaatselt e-arve faili lisada
      if cbEBill.Checked then
      begin
        pEBillfilePath := GetTempDirPath() + Format('ebill_%s.xml', [FItemCommonNr]);
        AssignFile(pEBillFile, pEBillfilePath);
        Rewrite(pEBillFile);
        Writeln(pEBillFile, chr($EF) + chr($BB) + chr($BF) + estbk_ebill._generateEBill(FItemId));
        CloseFile(pEBillFile);

        pFilesToAttach.Add(pEBillfilePath);
      end;

      if Trim(pRepTempfile) <> '' then
        pFilesToAttach.Add(pRepTempfile);

      pMailBody := trim(memoExtrDescr.Text);
      if pMailBody = '' then
        pMailBody := lblEMailSubject.Text;

      pMailBodyAsTAStr.Add(pMailBody);

      // 06.05.2013 Ingmar
      if pos('<html', ansilowercase(pMailBodyAsTAStr.Text)) = 0 then
      begin
        pMailBodyAsTAStr.Text := '<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /></head><body>' +
          StringReplace(pMailBodyAsTAStr.Text, #13#10, '<br>', [rfReplaceAll]) + '</body></html>';
      end;

      pSenderName := '';
      if Trim(dmodule.userStsValues[Csts_email_sendername]) <> '' then
        pSenderName := EmailTitle(Trim(dmodule.userStsValues[Csts_email_sendername]))
      else
        pSenderName := EmailTitle(estbk_globvars.glob_currcompname);
      // failsafe !
      if Trim(pSenderName) = '' then
        pSenderName := dmodule.userStsValues[Csts_email_addr]; // from

      {$ifdef debugmode}
      // lblEMailrcv.Text:='stiigo@stiigo.com';
      //pEmailRcvAddr:='stiigo@stiigo.com,support@stiigo.com';
      pEmailRcvAddr := 'stiigo@stiigo.com';
      {$endif}
      // <9D3FF3506DE0DA4394000F4A387821F8299F5DE1@EX1.astk.ee> kuidas valiidne msg lisada ?
      // ---
      // @@@ SAATMINE @@@
      pDummyMsgId := dmodule.userStsValues[Csts_email_addr];
      pAtPos := Pos('@', pDummyMsgId);
      if pAtPos > 0 then
      begin
        Delete(pDummyMsgId, 1, pAtPos - 1);
        pDummyMsgId := '<' + IntToHex(Random(9999999), 10) + IntToHex(Random(9999999), 10) + pDummyMsgId + '>';
      end
      else
        pDummyMsgId := '';

      pMailObj.sendHTMLMail(pEmailRcvAddr, //lblEMailrcv.Text,  // receiverAddress
        pSenderName, //  senderName
        dmodule.userStsValues[Csts_email_addr], //  fromAddr
        lblEMailSubject.Text, // subject
        pMailBodyAsTAStr, // emailTekst
        nil, // alternativeTekst
        pFilesToAttach,  // filesToAttach
        True,
        'UTF-8'
        );
      // 03.03.2013 Ingmar;
      logEmails(lblEMailrcv.Text, lblEMailSubject.Text, pMailBodyAsTAStr.Text);
    finally
      Screen.Cursor := pCursor;
      if FileExists(pRepTempfile) then
        DeleteFile(pRepTempfile);
      if (pEBillfilePath <> '') and FileExists(pEBillfilePath) then
        DeleteFile(pEBillfilePath);
    end;

    self.ModalResult := mrOk;
  finally
    FreeAndNil(pMailObj);
    FreeAndNil(pFilesToAttach);
    FreeAndNil(pMailBodyAsTAStr);
    //destroyRegExprEngine(r);
  end;
end;

initialization
  {$I estbk_frm_esendbill.ctrs}

end.
