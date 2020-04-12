unit estbk_lib_sendemail;
// recommended to use Delphi 7

interface

uses estbk_types, IdSMTP, IdGlobal, IdMessageParts, IdMessage, IdAttachmentFile, IdText, SysUtils, Classes;

type
  TEstbkSendMail = class(TIdSMTP)
  private
    procedure SendHeader(amsg: TIdMessage); override;
  protected
    fMailidEMsg: AStr;
    fTimeOut: integer;
    fMakeNewConnection: boolean;
    procedure OnInitializeIsoEvent(var VHeaderEncoding: char; var VCharSet: string);
    function getLastErrorMsg: AStr;
    function getMimeType(const AFilename: AStr; var contentTransfer: AStr): AStr;
    function stringToCaseSelect(const fname: AStr; const sp: array of AStr): integer;

  public
    property lastErrorMsg: string read getLastErrorMsg;
    procedure tryToMakeNewConnection;
    function sendHTMLMail(const receiverAddress: AStr; const bccAddress: AStr; const CcAddress: AStr;
      const senderName: AStr; const fromAddr: AStr; const subject: AStr; const emailTekst: TStrings;
      const alternativeTekst: TStrings = nil; const filesToAttach: TStrings = nil; const mailFormatHTML: boolean = True;
      const defaultencoding: AStr = 'UTF-8'): boolean; overload;
    function sendHTMLMail(const receiverAddress: AStr; const senderName: AStr; const fromAddr: AStr; const subject: AStr;
      const emailTekst: TStrings; const alternativeTekst: TStrings = nil; const filesToAttach: TStrings = nil;
      const mailFormatHTML: boolean = True; const defaultencoding: AStr = 'UTF-8'): boolean; overload;
    constructor Create(const pSmtpserver: AStr; const pPort: integer; const pUsername: AStr; const pPassword: AStr;
      const pMailAgent: AStr; const pConnectOnCreate: boolean = True; const pTimeout: integer = 85); reintroduce;

    destructor Destroy; override;
  end;

implementation

uses IdCoderHeader, estbk_utilities;

procedure TEstbkSendMail.tryToMakeNewConnection;
begin
  fMakeNewConnection := True;
end;

constructor TEstbkSendMail.Create(const pSmtpserver: AStr; const pPort: integer; const pUsername: AStr; const pPassword: AStr;
  const pMailAgent: AStr; const pConnectOnCreate: boolean = True; const pTimeout: integer = 85);
begin
  inherited Create(nil);
  try
    fMakeNewConnection := False;
    self.Host := pSmtpserver;
    self.Port := pPort;
    self.Username := pUsername;
    self.Password := pPassword;
    // we use this parameter, to trick some spam filters:)))
    self.FMailAgent := pMailAgent;

    //IdGlobal.IdTimeoutDefault:=timeout;
    // self.FReadTimeout:=self.fTimeOut;
    if pConnectOnCreate then
      self.Connect;
  except
  end;
end;

function TEstbkSendMail.getLastErrorMsg: AStr;
begin
  Result := fMailidEMsg;
end;

procedure TEstbkSendMail.SendHeader(amsg: TIdMessage);
begin
  inherited sendheader(amsg);
end;

function TEstbkSendMail.stringToCaseSelect(const fname: AStr; const sp: array of AStr): integer;
var
  i: integer;
begin
  for i := low(sp) to high(sp) do
    if sp[i] = fname then
    begin
      Result := i;
      Break;
    end;
end;


function TEstbkSendMail.getMimeType(const AFilename: AStr; var contentTransfer: AStr): AStr;
const
  MimeTypes: array[0..12] of AStr = ('.gif', '.jpg', '.png', '.css', '.htm', 'html', '.asp', '.aspx', '.xml', '.js', '.pdf', '.txt', '.log');
begin
  contentTransfer := 'base64';
  case StringToCaseSelect(LowerCase(ExtractFileExt(AFilename)), MimeTypes) of
    0:  // gif
    begin
      Result := 'image/gif';
    end;
    1:  // jpg
    begin
      Result := 'image/jpg';
    end;
    2:  // png
    begin
      Result := 'image/png';
    end;
    3:  // css
    begin
      contentTransfer := 'quoted-printable'; // or 8 bit:P
      Result := 'text/css';
    end;
    4, 5:  // htm, html
    begin
      contentTransfer := 'quoted-printable'; // or 8 bit:P
      Result := 'text/html';
    end;
    6, 7, 11, 12:  // asp, aspx, .txt, .log !!!!
    begin
      contentTransfer := 'quoted-printable'; // or 8 bit:P
      Result := 'text/plain';
    end;
    8: // xml
    begin
      contentTransfer := 'quoted-printable'; // or 8 bit:P
      Result := 'text/xml';
    end;
    9: // js
    begin
      contentTransfer := 'quoted-printable'; // or 8 bit:P
      Result := 'text/javascript';
    end;
    10: // pdf
    begin
      // contentTransfer:='quoted-printable'; // or 8 bit:P
      Result := 'application/pdf';
    end
    else
    begin
      // Result := 'application/binary';
      Result := 'application/octet-stream';
    end;
  end;
end;

procedure TEstbkSendMail.OnInitializeIsoEvent(var VHeaderEncoding: char; var VCharSet: string);
begin
  VHeaderEncoding := 'Q';
  VCharSet := 'UTF-8';
end;

function TEstbkSendMail.sendHTMLMail(const receiverAddress: AStr; const bccAddress: AStr; const CcAddress: AStr;
  const senderName: AStr; const fromAddr: AStr; const subject: AStr; const emailTekst: TStrings;
  const alternativeTekst: TStrings = nil; const filesToAttach: TStrings = nil; const mailFormatHTML: boolean = True;
  const defaultencoding: AStr = 'UTF-8'): boolean;
var
  pId: TIdMessage;
  pIdText, pIdText1: TIdText;
  pIndyHack, I: integer;
  pIdAttach: array of TIdAttachmentFile;
  contentTransfer: AStr;
begin
  try
    try
      pIdText1 := nil;
      fMailidEMsg := '';

      Result := False;
      if not connected or fMakeNewConnection then
      begin
        try
          self.Disconnect;
        except
        end;

        //  self.fTimeOut
        //self.FReadTimeout:=self.fTimeOut;
        self.Connect;
        fMakeNewConnection := False;
      end;

      pid := TidMessage.Create(self);
      pid.Priority := mpNormal;
      pid.Sender.Address := FromAddr;
      pid.From.Address := FromAddr;
      pid.From.Name := senderName;
      pid.Recipients.EMailAddresses := ReceiverAddress;

      if length(BccAddress) > 0 then
        pid.BccList.EMailAddresses := BccAddress; // BlindCarbonCopy

      if length(CcAddress) > 0 then
        pid.CCList.EMailAddresses := CCAddress;
     {
       text/plain
       text/html
       text/xml
       text/enhanced
       image/jpeg
       image/gif
       audio/basic
       audio/au
       video/mpeg
       application/octet-stream
       application/postscript
       application/ms-word
       application/ms-excel
       application/rtf
       multipart/mixed
       multipart/alternative
       multipart/parallel
       multipart/related
       message/rfc822
       message/external-body
     }

      pid.Subject := '';
      pid.ExtraHeaders.Values['Subject'] := EmailTitle(subject); // UTF8
      pid.CharSet := DefaultEncoding;
      // pid.OnInitializeISO := @OnInitializeIsoEvent;
      // pid.OnInitializeISO
      pid.Date := Now;
      if mailFormatHTML then
        pid.ContentType := 'text/html'
      else
        pid.ContentType := 'text/plain';
      // #
      pIdText := TIdText.Create(pid.MessageParts, emailTekst);
      if mailFormatHTML then
        pIdText.ContentType := 'text/html'
      else
        pIdText.ContentType := 'text/plain';

      pIdText.ContentTransfer := '8bit';
      // Et saaksime ikka utf 8 subjekti saata
      // pIdText.ExtraHeaders.Values['Subject'] := EncodeHeader(subject, '', 'Q', 'UTF-8');
      // pIdText.ExtraHeaders.Values['Subject'] := UTF8EmailTitle(subject);
      // ###
      if Assigned(alternativeTekst) and (alternativeTekst.Count > 0) then
      begin
        if not assigned(filesToAttach) or (filesToAttach.Count = 0) then
          pid.ContentType := 'multipart/alternative';
        // #
        pIdText1 := TIdText.Create(pid.MessageParts, alternativeTekst);
        pIdText1.ContentType := 'text/plain';
        pIdText1.ContentTransfer := '8bit';
      end;

      // #
      if Assigned(filesToAttach) and (filesToAttach.Count > 0) then
      begin
        pid.ContentType := 'multipart/mixed';
        SetLength(pIdAttach, filesToAttach.Count);
        for i := low(pIdAttach) to high(pIdAttach) do
        begin
          pIdAttach[i] := TIdAttachmentFile.Create(pid.MessageParts, filesToAttach[i]);
          pIdAttach[i].ContentType := getMimeType(filesToAttach[i], contentTransfer);
          pIdAttach[i].ContentTransfer := contentTransfer;
          pIdAttach[i].FileName := (filesToAttach[i]);
          //Content-Type: text/plain; name="test5.txt"
          //Content-Disposition: attachment; filename="test5.txt"
          //Content-Transfer-Encoding: quoted-printable
          // Ingmar detected a bug, if we are dealing with text files, I must use queted-printable,
          // because base64 is "huge"
          // pid.DoCreateAttachment(pIdAttach[i].Headers,pIdAttach[i]);
          // pIdAttach[i].OpenLoadStream;
          // pIdAttach[i].CloseLoadStream;
        end;
        //   idAttach.ContentDisposition := 'inline';
      end;


      self.Send(pid);
      Result := True;

    finally
      if Assigned(pIdText) then
        pIdText.Free;

      if assigned(pIdText1) then
        pIdText1.Free;

      if assigned(pid) then
        pid.Free;

      // Indy frees the object by itsself
      //   if assigned(pIdAttach) then
      //   for i:=low(pIdAttach) to high(pIdAttach) do
      //        pIdAttach[i].Free;
    end;

  except
    on E: Exception do
      fMailidEMsg := E.message;
  end;
end;

function TEstbkSendMail.sendHTMLMail(const receiverAddress: AStr; const senderName: AStr; const fromAddr: AStr;
  const subject: AStr; const emailTekst: TStrings; const alternativeTekst: TStrings = nil; const filesToAttach: TStrings = nil;
  const mailFormatHTML: boolean = True; const defaultencoding: AStr = 'UTF-8'): boolean;
begin
  Result := sendHTMLMail(receiverAddress, '',// bccAddress : AStr;
    '',// CcAddress  : AStr;
    senderName, fromAddr, subject, emailTekst, alternativeTekst, filesToAttach, mailFormatHTML, defaultencoding);
end;

destructor TEstbkSendMail.Destroy;
begin
  if self.Connected then
    self.Disconnect;
  inherited Destroy;
end;

end.

