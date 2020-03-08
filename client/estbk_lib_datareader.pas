unit estbk_lib_datareader;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, estbk_strmsg, estbk_types, estbk_utilities,
  {indy maailm !}
  IdHttp, IdSSL, IdAuthenticationDigest, IdAuthenticationSSPI, IdAuthentication, IdHeaderList,
  IdGlobalProtocols, IdSSLOpenSSL, IdException, IdURI, IdIOHandler, IdIOHandlerSocket,
  {$IFNDEF NOGUI}
  Dialogs,
  {$ENDIF}
  {kompressioon}
  AbGzTyp, AbUtils, DOM, XMLRead;
//IdZLibCompressorBase,IdCompressorAbbrevia;

// enam-vähem universaalne klass CSV/TAB failide lugemiseks
// 01.11.2009 ingmar; lisasin ka toetuse, et tõmbab failid otse veebist !
// ***
{$DEFINE preferBasicAuthentication}

type
  TOnReadLineNotification = function(const filename: AStr; const linenr: integer; const Data: AStr): boolean of object;

  TEstbkHttpReader = class
  protected
    FuseProxy: boolean;
    FProxyServer: AStr;
    FProxyUsr: AStr;
    FProxyPwd: AStr;
    FHttpUsrname: AStr;
    FHttpUsrpass: AStr;
    FProxyPort: integer;
    FDataStream: TStream;
    FWasError: boolean;
    FError: AStr;
    // --
    // misc
    fURL: Astr;
    fHttpObj: idHttp.TIdHTTP;


    fDefaultIOHandler: TIdIOHandler;
    fSslSupport: TIdSSLIOHandlerSocketOpenSSL;
    fUseRedirectedURL: boolean;
    fSslIOHandlerSet: boolean;
    fRedirectCount: integer;
    // ---
    procedure setHTTPsIOHandler;
    function resolveRelativeURLs_(const currentURL: string; const newLocation: string): string;



    procedure selectProxyAuthorization(Sender: TObject; var AuthenticationClass: TIdAuthenticationClass; AuthInfo: TIdHeaderList);
    procedure selectProxyAuthentication(Sender: TObject; Authentication: TIdAuthentication; var Handled: boolean);
    procedure proxyModifyAuthInformation(Sender: TObject; Authentication: TIdAuthentication);
    procedure selectAuthorization(Sender: TObject; var AuthenticationClass: TIdAuthenticationClass; AuthInfo: TIdHeaderList);

    procedure httpAuthentication(Sender: TObject; Authentication: TIdAuthentication; var Handled: boolean);
    procedure handleHttpRedirect(Sender: TObject; var dest: string; var NumRedirect: integer; var Handled: boolean; var VMethod: TIdHTTPMethod);

    function getIdObjContentType: Astr;
  public
    // vajalikud ainult veebi puhul
    property useProxy: boolean read FuseProxy write FuseProxy;
    property proxyServer: AStr read FProxyServer write FProxyServer;
    property proxyUsername: AStr read FProxyUsr write FProxyUsr;
    property proxyPassword: AStr read FProxyPwd write FProxyPwd;
    property proxyPorty: integer read FProxyPort write FProxyPort;
    property httpUsername: AStr read FHttpUsrname write FHttpUsrname;
    property httpPassword: AStr read FHttpUsrpass write FHttpUsrpass;
    property wasError: boolean read FWasError;
    property error: AStr read FError;

    // --- neid properteid miljon +1; hetkel ainult üks, mida meil vaja
    property contentType: AStr read getIdObjContentType;
    // ---
    property dataStream: TStream read FDataStream write FDataStream;
    property url: AStr read fURL write fURL;


    procedure getData(); virtual;
    // ---
    constructor Create;
    destructor Destroy; override;
  end;

  // läbi univ. readeris ei pea saama saama teised neid torkida !
  TEstbkHttpReaderPrv = class(TEstbkHttpReader)
  private
    property wasError;
    property error;
    property url;
    property dataStream;
    procedure getData(); override;
  end;

  TEstbkFilereader = class
  protected
    FName: AStr;
    FReadLineNot: TOnReadLineNotification;
  public
    property filename: AStr read FName write FName;
    property onReadLineNotification: TOnReadLineNotification read FReadLineNot write FReadLineNot;
    function startReader(const pstartReadingFromLine: integer = 1;
    // alates millisest read üldse alustame lugemist
      const pSkipLines: TADynIntArray = nil;
    // millistest ridadest hüppame üle, suht nö eriolukord
      const pSkipLineStartingWithStr: TADynStrArray = nil): boolean; virtual; // millist str. ei tohi rida sisaldada
  end;


  TEstbkCurrencyExcRateReader = class(TEstbkFilereader)
  protected
    FUrl: AStr;
    FHttpReader: TEstbkHttpReaderPrv;
    FcurrDate: TDatetime;
    FEUCentralBank: boolean;
    //procedure setReadLineNot(const v : TOnReadLineNotification);
    //function  getReadLineNot():TOnReadLineNotification;
  public
    // tegin avalikuks, juhul kui vaja proxy infot lisada või veebilehtede paroole jbne
    property url: AStr read FUrl write FUrl;
    property EUCentralBank: boolean read FEUCentralBank write FEUCentralBank;
    property currDate: TDatetime read FcurrDate write FcurrDate;
    property httpReader: TEstbkHttpReaderPrv read FHttpReader;
    //property    onReadLineNotification : TOnReadLineNotification read getReadLineNot write setReadLineNot;
    // ---
    function startReader(const pstartReadingFromLine: integer = 1; const pSkipLines: TADynIntArray = nil;
      const pSkipLineStartingWithStr: TADynStrArray = nil): boolean; override;
    constructor Create;
    destructor Destroy; override;
  end;

implementation
// TODO: muuta konfitavaks; üle 10 MB faili ei toeta !!!
const
  CCriticalSize = 10485760;
  CdefaultHTTPTimeout = 1000 * 55; // 55 seconds
  CdefaultHTTPReadTimeout = cdefaultHTTPTimeout;


constructor TEstbkHttpReader.Create;
var
  httpObjOpt: TIdHTTPOptions;
begin
  inherited Create;
  fHttpObj := idHttp.TIdHTTP.Create;
  // -----
  fHttpObj := idHttp.TIdHTTP.Create(nil);
  // fBfrStream:=TStringStream.Create('');


  fHttpObj.Request.AcceptCharSet := 'ISO-8859-1,utf-8;q=0.7,*;q=0.7';
  fHttpObj.Request.Accept := '*/*';


  fHttpObj.Request.AcceptEncoding := 'gzip,deflate'; // 'gzip,identity';

  fHttpObj.HandleRedirects := True;
  fHttpObj.RedirectMaximum := 5;
  // fHttpObj.IOHandler:=fDefaultIOHandler;

  fHttpObj.ConnectTimeout := CdefaultHTTPTimeout;
  fHttpObj.ReadTimeout := CdefaultHTTPReadTimeout;

  fHttpObj.AllowCookies := False; // pole meile seda puru vaja


  fHttpObj.Request.BasicAuthentication := False;
  fHttpObj.ProxyParams.BasicAuthentication := False;

  fDefaultIOHandler := TIdIOHandler.MakeIOHandler(TIdIOHandlerSocket, nil);
  fDefaultIOHandler.ConnectTimeout := CdefaultHTTPTimeout;
  fDefaultIOHandler.ReadTimeout := CdefaultHTTPReadTimeout;


  httpObjOpt := fHttpObj.HTTPOptions;
  include(httpObjOpt, hoInProcessAuth);
  fHttpObj.HTTPOptions := httpObjOpt;

  fHttpObj.MaxAuthRetries := 4; // ###

  fHttpObj.IOHandler := fDefaultIOHandler;
  fHttpObj.ManagedIOHandler := False;


  fHttpObj.OnAuthorization := @self.httpAuthentication;
  fHttpObj.OnSelectAuthorization := @self.selectAuthorization;

  fHttpObj.OnSelectProxyAuthorization := @self.selectProxyAuthorization;
  fHttpObj.OnProxyAuthorization := @self.selectProxyAuthentication;
  // Viimase Indyga enam pole meetodit
  // fhttpObj.OnProxyVerifyAuthBeforeRedirect := @self.proxyModifyAuthInformation;
  //  fHttpObj.OnWork:=cbHttpWork; // Indy 10.0.52 compatible
  fHttpObj.OnRedirect := @self.handleHttpRedirect;
end;

procedure TEstbkHttpReader.httpAuthentication(Sender: TObject; Authentication: TIdAuthentication; var Handled: boolean);
begin

  if assigned(Authentication) then
  begin
    Authentication.Username := self.FHttpUsrname;
    Authentication.Password := self.FHttpUsrpass;
    Handled := True;
  end;
  // -->
 {
  if Authentication.ClassName=TIdNTLMAuthentication.ClassName then
    begin
//      build1Msg:=TIdNTLMAuthentication(Authentication).Authentication;//TIdNTLMAuthentication(Authentication).type1Msg;
      build1Msg:=TIdNTLMAuthentication(Authentication).type1Msg;

      TIdHttp(Sender).Request.RawHeaders.Add('Authorization=NTLM '+build1Msg);
//      TIdNTLMAuthentication(Authentication).Next:=
      //      'NTLM '+build1Msg;

    end;
}
end;

function TEstbkHttpReader.getIdObjContentType: Astr;
begin
  Result := self.fHttpObj.Response.ContentType;
end;

// 01.11.2009 Ingmar; jube keemia, et digest, basic ja ntml töötaks !
procedure TEstbkHttpReader.SelectAuthorization(Sender: TObject; var AuthenticationClass: TIdAuthenticationClass; AuthInfo: TIdHeaderList);
var
  wwwAuthStr, reqMeth, build1Msg: AStr;
  isBasicAuth: boolean;
  isDigestAuth: boolean;
  isNTLM: boolean;
  digestAuth: TIdDigestAuthentication;
  idduri: TIdURI;
begin

  // -->
  with TidHttp(Sender) do
  begin

    Request.Username := self.FHttpUsrname;
    Request.Password := self.FHttpUsrpass;

    //wwwAuthStr:=trim(Response.RawHeaders.Values['WWW-Authenticate']);
    wwwAuthStr := Response.WWWAuthenticate.Values['WWW-Authenticate'];

    isBasicAuth := (length(wwwAuthStr) > 0) and (pos('Basic ', wwwAuthStr) > 0);
    if isBasicAuth then
    begin
      //         AuthenticationClass := TIdBasicAuthentication;
      Request.BasicAuthentication := True;
    end
    else
    begin
      isDigestAuth := (length(wwwAuthStr) > 0) and (pos('Digest ', wwwAuthStr) > 0);
      if isDigestAuth then
      begin

        // 12.04.2006
        // if assigned(ProxyParams.Authentication) and (ProxyParams.Authentication is TIdDigestAuthentication) then
        //  TIdDigestAuthentication(ProxyParams.Authentication).LiveSession := True;


        if assigned(Request.Authentication) then
        begin
          Request.Authentication.Free;
          Request.Authentication := nil;
        end;


        digestAuth := IdAuthenticationDigest.TIdDigestAuthentication.Create;

        try
          try
            idduri := TIdURI.Create(FURL);
            digestAuth.Uri := concat(idduri.Path + idduri.Document + idduri.Params);
          finally
            idduri.Free;
          end;
        except
          exit;
        end;

        digestAuth.Username := Request.Username;
        digestAuth.Password := Request.Password;

        // case Request.Method of
        //   hmGet : reqMeth:='GET';
        //   hmPost: reqMeth:='POST';
        //   hmPut : reqMeth:='PUT';
        // end;
        reqMeth := AnsiUpperCase(Request.Method); // ---

        digestAuth.Method := reqMeth;
        Request.Authentication := digestAuth;
        // -->
      end
      else
      begin
        isNTLM := (length(wwwAuthStr) > 0) and (pos('NTLM ', wwwAuthStr) > 0);
      end;
    end;

  end;
end;

procedure TEstbkHttpReader.selectProxyAuthentication(Sender: TObject; Authentication: TIdAuthentication; var Handled: boolean);
begin
  if assigned(Authentication) then
  begin
    Authentication.Username := self.FProxyUsr;
    Authentication.Password := self.FProxyPwd;
    Handled := True;
  end;
  // ---
end;


procedure TEstbkHttpReader.selectProxyAuthorization(Sender: TObject; var AuthenticationClass: TIdAuthenticationClass; AuthInfo: TIdHeaderList);
//var

var
  reCreateAuthclass: boolean;
  idduri: TIdURI;
  i: integer;
  digestAuth: TIdDigestAuthentication;
  reqMeth: AStr;
  wwwProxAuthStr: AStr;
  sBAuthMethod: AStr;
begin

  if assigned(AuthenticationClass) then
    with TidHttp(Sender) do
    begin
      // ===================================================================
         {$ifdef preferBasicAuthentication}
      for i := 0 to Response.ProxyAuthenticate.Count - 1 do
      begin
        sBAuthMethod := Response.ProxyAuthenticate[i];
        // HTTP/1.1 407 Proxy Authentication Required
        // ( The ISA Server requires authorization to fulfill the request.
        // Access to the Web Proxy service is denied.  )..Via:1.1 SYNBASISA5..
        // Proxy-Authenticate: NTLM
        // Proxy-Authenticate: Basic realm="SYNBASISA5.syncpqalf.org"
        // Proxy-Authenticate: Kerberos
        // Proxy-Authenticate: Negotiate
        // Connection: Keep-Alive
        // Proxy-Connection: Keep-Alive


        if (pos('Basic ', sBAuthMethod) > 0) then
        begin

          reCreateAuthclass := assigned(AuthenticationClass);
          if reCreateAuthclass then
            reCreateAuthclass :=
              (AuthenticationClass.ClassName <> TIdBasicAuthentication.ClassName);

          if reCreateAuthclass then
          begin
            if assigned(ProxyParams.Authentication) then
            begin
              ProxyParams.Authentication.Free;
              ProxyParams.Authentication := nil;
            end;

            ProxyParams.Authentication := TIdBasicAuthentication.Create;
            ProxyParams.Authentication.Username := ProxyParams.ProxyUsername;
            ProxyParams.Authentication.Password := ProxyParams.ProxyPassword;


            // -->
            AuthenticationClass := TIdBasicAuthentication;  // just for safety
            Exit;
          end;
        end;
      end;
          {$endif}
      // ===================================================================

      // ...is it digest !
      wwwProxAuthStr := TIdHttp(Sender).Response.ProxyAuthenticate.Text;
      if pos('Digest ', wwwProxAuthStr) > 0 then
      begin

        if assigned(ProxyParams.Authentication) then
        begin
          ProxyParams.Authentication.Free;
          ProxyParams.Authentication := nil;
        end;

        digestAuth := IdAuthenticationDigest.TIdDigestAuthentication.Create;
        digestAuth.Username := TIdHttp(Sender).ProxyParams.ProxyUsername;
        digestAuth.Password := TIdHttp(Sender).ProxyParams.ProxyPassword;
        digestAuth.Uri := '';


        try
          try
            idduri := TIdURI.Create(FURL);
            // idduri.Host+
            // Proxy digest requires full uri ???
            digestAuth.Uri :=
              concat(idduri.Path + idduri.Document + idduri.Params);
          finally
            // 18.04.2006 Ingmar memory leak, this class was not freed !
            if assigned(idduri) then
              idduri.Free;
          end;
        except
          exit;
        end;


        //case Request.Method of
        //  hmGet : reqMeth:='GET';
        //  hmPost: reqMeth:='POST';
        //  hmPut : reqMeth:='PUT';
        //end;
        reqMeth := AnsiUpperCase(Request.Method);
        // Uue indyga pole pole toetatud
        // digestAuth.setKeepAliveFlag(True); // keep proxy connecyion up ?
        digestAuth.Method := reqMeth;
        ProxyParams.Authentication := digestAuth;
      end;
    end;
  // #
end;

procedure TEstbkHttpReader.ProxyModifyAuthInformation(Sender: TObject; Authentication: TIdAuthentication);
var
  idduri: TIdURI;
begin
  // ...digest authentication...is quite a chemistry....
  if assigned(Authentication) then
    if (Authentication is TIdDigestAuthentication) then
      with TIdDigestAuthentication(Authentication) do
      begin
        // Pole toetatud enam uue Indiga
        // LiveSession := True; // <--
        try
          try
            idduri := TIdURI.Create(TidHttp(Sender).Response.Location);
            // Proxy digest requires full uri ???
            Uri := concat(idduri.Path + idduri.Document);
          finally
            idduri.Free;
          end;
        except
          exit;
        end;
      end;
end;


// http
// SSL IO handler on bugine nigu see asi
procedure TEstbkHttpReader.setHTTPsIOHandler;
var
  fprvURl: AStr;
begin
  fprvURl := self.Furl;
  if isSSLProtocol(fprvURl) then
  begin
    // set HTTPS Handler ---
    {
    if fSslIOHandlerSet then // recreate handler to prevent various errors, SSL handler is buggy !
      begin
         fSslSupport:=TIdSSLIOHandlerSocketOpenSSL.Create(fHttpObj);
         fSslSupport.SSLOptions.Mode:=sslmUnassigned;
         fSslSupport.SSLOptions.Method := sslvSSLv23;
         //fSslSupport.WriteBufferFlush;
         fHttpObj.IOHandler:=fSslSupport; // !!!!!!!!!!!!!!!!
         fSslIOHandlerSet:=true;
         //fHttpObj.IOHandler.Port:=443;
      end;
      }

    fHttpObj.IOHandler := self.fDefaultIOHandler;

    if self.fSslIOHandlerSet and assigned(self.fSslSupport) then
      // recreate handler to prevent various errors, SSL handler is buggy !
      FreeAndNil(fSslSupport);

    // fHttpObj.IOHandler:=self.fDefaultIOHandler;
    //begin
    fSslSupport := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    fSslSupport.SSLOptions.Mode := sslmUnassigned;
    fSslSupport.SSLOptions.Method := sslvSSLv23;

    // fSslSupport.SSLOptions.Method:=sslvSSLv3;
    //fSslSupport.WriteBufferFlush;

    fHttpObj.IOHandler := self.fSslSupport; // !!!!!!!!!!!!!!!!
    fHttpObj.IOHandler.ConnectTimeout := CdefaultHTTPTimeout;
    fHttpObj.IOHandler.ReadTimeout := CdefaultHTTPReadTimeout;
    fSslIOHandlerSet := True;

    //fHttpObj.IOHandler.Port:=443;
    //end;

  end
  else
    fHttpObj.IOHandler := self.fDefaultIOHandler;
  // -------
end;


function TEstbkHttpReader.resolveRelativeURLs_(const currentURL: string; const newLocation: string): string;

var
  currentURICt: TIdURI;
  newloc: TIdURI;
  newurl: string;
  prot1, prot2: string;

begin

  try
    Result := currentURL;
    try
      newurl := '';

      currentURICt := TIdURI.Create(currentURL);
      newloc := TIdURI.Create(newLocation);

      // 02.08.2006  fixed, if protocol has changed !
      prot1 := AnsiUpperCase(trim(currentURICt.Protocol));
      prot2 := AnsiUpperCase(trim(newloc.Protocol));

      //  ok protocol has changed, example http->https
      if (length(prot1) > 0) and (length(prot2) > 0) and (prot1 <> prot2) then
      begin
        Result := newLocation;
        exit;
      end;

      // --->
      newurl := currentURICt.Protocol + '://';
      if length(newloc.Host) = 0 then
      begin
        newurl := concat(newurl, currentURICt.Host);
        // ----------
        // 15.06.2007 Ingmar: port was incorretly added !
        // ----------
        if length(currentURICt.Port) > 0 then
          newurl := concat(newurl, ':', currentURICt.Port);
      end
      else
      begin
        newurl := concat(newurl, newloc.Host);
        // ----------
        // 15.06.2007 Ingmar: port was incorretly added !
        // ----------
        if length(newloc.Port) > 0 then
          newurl := concat(newurl, ':', newloc.Port);
      end;



      if newloc.Path = '' then
      begin
        newurl := concat(newurl, currentURICt.path);
      end
      else
        newurl := concat(newurl, newloc.Path);

      if length(newurl) > 0 then
      begin
        if newurl[length(newurl)] <> '/' then
          newurl := concat(newurl, '/');

        newurl := concat(newurl, newloc.Document, newloc.Params);
        Result := newurl;
      end;


    finally
      if assigned(currentURICt) then
        currentURICt.Free;

      if assigned(newloc) then
        newloc.Free;
    end;

    // -->
  except
  end;
end;

procedure TEstbkHttpReader.handleHttpRedirect(Sender: TObject; var dest: string; var NumRedirect: integer;
  var Handled: boolean; var VMethod: TIdHTTPMethod);

begin

  with TIdHttp(Sender) do
  begin
    Inc(fRedirectCount);

    dest := resolveRelativeURLs_(self.fURL, dest);
    // 301 Moved Permanently
    // 302 Moved Temporarily
    // 307 Temporary Redirect
    if ResponseCode = 301 then
    begin
      FUseRedirectedURL := True;
      self.fURL := dest;
    end;



    // =================================================================
    // -->
    Handled := (ResponseCode = 301) or (ResponseCode = 302) or (ResponseCode = 307);
    // and (currentJobType<>CgetEnclosure);

    if Handled then
    begin

      if isSSLProtocol(self.fURL) then
        setHTTPsIOHandler();

      //sleep(45);
    end;
  end;
end;

procedure TEstbkHttpReader.getData;
var
  // --
  tryReconnUrl: AStr;
  tryConnEntr: byte;
  terminatePLoop: boolean;
  pTempStream: TMemoryStream;
  pTempUpStream: TMemoryStream;
  pdeCompressionReq: boolean;
  // ---
  aType: TAbArchiveType;
  aGz: TAbGzipStreamHelper;
begin
  if not assigned(self.FDataStream) then
    raise Exception.Create(estbk_strmsg.SEStreamIsMissing);


  self.FWasError := False;
  self.FError := '';


  // ---- paneme tulevikus propertite abil normaalselt paika ! Inimese moodi ...
  if self.FuseProxy then
  begin

    fHttpObj.ProxyParams.ProxyServer := self.FProxyServer;
    fHttpObj.ProxyParams.ProxyUsername := self.FProxyUsr;
    fHttpObj.ProxyParams.ProxyPassword := self.FProxyPwd;
    fHttpObj.ProxyParams.ProxyPort := self.FProxyPort;

  end
  else
    try
      fHttpObj.ProxyParams.ProxyServer := '';
      fHttpObj.ProxyParams.ProxyUsername := '';
      fHttpObj.ProxyParams.ProxyPassword := '';
      fHttpObj.ProxyParams.ProxyPort := 0;

      if assigned(fHttpObj.ProxyParams.Authentication) then
      begin
        fHttpObj.ProxyParams.Authentication.Free;
        fHttpObj.ProxyParams.Authentication := nil;
      end;

    except
    end;



  // 01.11.2009 Ingmar
  // --- üritame siis veebist lugeda andmed; nagu newsbrainis tegin, sama loogika
  // osa toredaid saiti selle järgi otsustavad, kas anname andmeid või mitte...
  fHttpObj.Request.UserAgent := 'Mozilla/5.0 (Windows; U; Windows NT 5.1; et; rv:1.9.1.4) Gecko/20091016 Firefox/3.5.4 (.NET CLR 3.5.30729)';
  //'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2)';
  tryConnEntr := 1;
  terminatePLoop := False;

  while (tryConnEntr > 0) do
    try
      Dec(tryConnEntr);
      try
        pTempStream := TMemoryStream.Create;
        // rõõmsalt küsime andmeid...
        fHttpObj.Get(self.fURL, pTempStream);

        //  self.fDataStream
      finally
        begin
          // 02.11.2009 Ingmar; ma ei kasuta indy ZLib selletõttu, seal palju ASMi ja obj faile
          // mis ei võimalda ntx 64 bitist portimist teha jne. Palju probleeme !!!
          pdeCompressionReq := pos('gzip', ansilowercase(fHttpObj.Response.ContentEncoding)) > 0;
          if not pdeCompressionReq then
          begin
            if pTempStream.Size > 0 then
            begin
              pTempStream.seek(0, 0);
              self.fDataStream.CopyFrom(pTempStream, pTempStream.Size);
            end;
            // ---
          end
          else // pakime streami lahti
          begin
            //pTempStream.Seek(0,0);
            // aType:=VerifyGZip(pTempStream);
            //if (aType=atGzip) then
            //begin
            pTempStream.seek(0, 0);
            aGz := TAbGzipStreamHelper.Create(pTempStream);

            try
              pTempUpStream := TMemoryStream.Create;
              aGz.ExtractItemData(pTempUpStream);
              pTempUpStream.Seek(0, 0);

              /// kopeerime lahtipakitud andmed õigesse streami !
              self.DataStream.CopyFrom(pTempUpStream, pTempUpStream.Size);

            finally
              FreeAndNil(aGz);
              FreeAndNil(pTempUpStream);
            end;
            //end else
            //  raise exception.create('Unknown compression method !');
            // --------
          end;
          // ---
          FreeAndNil(pTempStream);
        end;
        // ------
      end;



    except
      // tuleb siis, kui server saadab andmed ära ning paneb socketid kinni
      // heal juhul on headeris connection:closed !! "heal" juhul
      on E: EIdConnClosedGracefully do
      begin
        if terminatePLoop then
        begin
          //raise exception.create(e.message); // FPC bugid
          self.FWasError := True;
          self.FError := e.message;
          Exit;
        end;

        // ----
        tryReconnUrl := fHttpObj.URL.GetFullURI();
        if length(tryReconnUrl) > 1 then
          self.fURL := tryReconnUrl;


        if assigned(fHttpObj.Request) and assigned(fHttpObj.Request.Authentication) and (isSSLProtocol(self.fURL)) and
          (length(fHttpObj.Request.Authentication.Password) > 0) then
          // try again...it seems that password is provided
        begin

          if fHttpObj.Connected then
            try
              fHttpObj.Disconnect;
            except
            end;



          setHTTPsIOHandler();

          terminatePLoop := True; // !!!
          tryConnEntr := 1;
          Continue;
        end;


        if fDataStream.Size < 10 then
        begin
          self.FWasError := True;
          self.FError := e.message;
          Exit;
        end;

        //raise exception.create(e.message); // FPC bugid
      end;


      on E: Exception do
      begin
        if fHttpObj.ResponseCode <> 200 then
        begin
          self.FWasError := True;
          self.FError := e.message;
          //raise exception.create(e.message); // FPC bugid
        end;
      end;
    end;
end;

destructor TEstbkHttpReader.Destroy;
begin
  if assigned(fDefaultIOHandler) then
    try
      FreeAndNil(fDefaultIOHandler);
    except
    end;

  if assigned(fSslSupport) then
    try
      FreeAndNil(fSslSupport);
    except
    end;
  // -----------
  FreeAndNil(fHttpObj);

  inherited Destroy;
end;


// ----------------------------------------------------------------------------
// ainult skoobi peitmiseks !

procedure TEstbkHttpReaderPrv.getData();
begin
  inherited getData();
end;

// ----------------------------------------------------------------------------

function TEstbkFilereader.startReader(const pstartReadingFromLine: integer = 1; const pSkipLines: TADynIntArray = nil;
  const pSkipLineStartingWithStr: TADynStrArray = nil): boolean;

const
  READ_ONLY = 0;
  WRITE_ONLY = 1;
  READ_WRITE = 2;
var
  FoldMode: byte;
  FSize: int64;
  FTxtFile: textFile;
  FDummyChk: file of byte; // peame kuidagi faili suuruse teada saama !
  FIsOpen: boolean;
  FSkipLine: boolean;
  FLine: AStr;
  FLineNr, i: integer;
begin
  Result := False;

  if length(trim(self.filename)) = 0 then
    raise Exception.Create(SEFileNameIsMissing);

  //  -----
  if assigned(onReadLineNotification) then
    try



      FIsOpen := False;
      FoldMode := system.Filemode;
      system.Filemode := READ_ONLY;

      // teeme kindlaks faili suuruse
      Assignfile(FDummyChk, self.filename);
      Reset(FDummyChk);
      FSize := FileSize(FDummyChk);
      closefile(FDummyChk);

      if FSize > CCriticalSize then
        raise Exception.CreateFmt(SEFileTooBig, [10]); // 10 MB

      // ja alustame lugemist...
      Assign(FTxtFile, self.filename);
      Reset(FTxtFile);
      // kas ikka avamine ka õnnestus !
      FIsOpen := True;

      // ---
      while not system.EOF(FTxtFile) do
      begin
        readln(FTxtFile, FLine);
        Inc(FLineNr);

        if (FLineNr >= pstartReadingFromLine) and (trim(FLine) <> '') then
        begin
          // --
          FSkipLine := False;

          // TODO
          // ideaalis võiks olla sorteeritud nimistu, ei peaks pidevalt üle käima 0 indeksist
          if assigned(pSkipLines) then
            for i := low(pSkipLines) to high(pSkipLines) do
            begin
              FSkipLine := pSkipLines[i] = FLineNr;
              if FSkipLine then
                Break;
            end;

          if not FSkipLine and assigned(pSkipLineStartingWithStr) then
            for i := low(pSkipLineStartingWithStr) to high(pSkipLineStartingWithStr) do
            begin
              FSkipLine := pos(pSkipLineStartingWithStr[i], FLine) = 1;
              if FSkipLine then
                Break;
            end;


          if not FSkipLine then
          begin

            // vajadusel..."mirror" ka streami, kuigi vajadus suht lahtine !
            // sest antud juhtudel võiks kasutada TStringlist.LoadFromFile
            if not onReadLineNotification(self.Filename, FLineNr, FLine) then
              Break;
          end;
        end;
        // ---
      end;

      Result := (FLineNr > 0);

    finally

      // --
      if FIsOpen then
        closefile(FTxtFile);

      // --
      system.Filemode := FoldMode;
    end;
  // --
end;

// ---------------------------------------------------------------------------

constructor TEstbkCurrencyExcRateReader.Create;
begin
  inherited Create;
  FHttpReader := TEstbkHttpReaderPrv.Create;
  FEUCentralBank := True; // 01.01.2011 Ingmar
end;


function TEstbkCurrencyExcRateReader.startReader(const pstartReadingFromLine: integer = 1;
  const pSkipLines: TADynIntArray = nil;
  const pSkipLineStartingWithStr: TADynStrArray = nil): boolean;
var
  pStream: TStringStream;
  //pStrBfr : Astr;
  pCurrDate: AStr;
  pCurrMergeStr: AStr;

  pStrABfr: TAStrList;
  pConfDoc: TXMLDocument;
  pChildNode: TDomNode;
  pCubNodeColl: TDomNode;
  pCubNode: TDomNode;
  pCurrAttr1: TDomNode;
  pCurrAttr2: TDomNode;
  pSkipLine: boolean;
  i, j, k: integer;

begin
  Result := False;
  try

    if length(self.filename) > 0 then
      Result := inherited startReader(pstartReadingFromLine, pSkipLines, pSkipLineStartingWithStr)
    else
    if (length(self.url) > 0) and assigned(self.onReadLineNotification) then
      try

        pStream := TStringStream.Create('');
        pStrABfr := TAStrList.Create;

        FHttpReader.url := self.url;
        FHttpReader.dataStream := pStream;
        FHttpReader.getData();


        // FPC läks täiesti lolliks kui exceptione järjest forwardida raisega !
        if FHttpReader.wasError then
          raise Exception.Create(FHttpReader.Error);
        //raise exception.create(FHttpReader.error);


        // nüüd siis euroopa keskpanga formaat, aga see XML kujul
        // http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml
              {
                <gesmes:Envelope>
                  <gesmes:subject>Reference rates</gesmes:subject>
                  −
                  <gesmes:Sender>
                  <gesmes:name>European Central Bank</gesmes:name>
                  </gesmes:Sender>
                  −
                  <Cube>
                  −
                  <Cube time="2011-01-03">
                  <Cube currency="USD" rate="1.3348"/>
                  <Cube currency="JPY" rate="108.70"/>
                  <Cube currency="BGN" rate="1.9558"/>
                  <Cube currency="CZK" rate="25.088"/>
                  <Cube currency="DKK" rate="7.4531"/>
                  <Cube currency="ILS" rate="4.7278"/>
                  <Cube currency="GBP" rate="0.86131"/>
                  </Cube>
                 </Cube>
                 </gesmes:Envelope>
              }
        pCurrMergeStr := '';
        if FEUCentralBank then
        begin
          // Euroopa keskpanga formaat
          if pos('text/xml', ansilowercase(FHttpReader.contentType)) > 0 then
            try
              pCubNode := nil;
              pStream.seek(0, 0);
              ReadXmlFile(pConfDoc, pStream);
              if assigned(pConfDoc.DocumentElement) then
              begin
                pCubNodeColl := pConfDoc.DocumentElement;
                if pCubNodeColl.NodeName = 'gesmes:Envelope' then
                  for i := 0 to pCubNodeColl.ChildNodes.Count - 1 do
                    if pCubNodeColl.ChildNodes[i].NodeName = 'Cube' then
                    begin
                      pCubNodeColl := pCubNodeColl.ChildNodes.Item[i];
                      for  j := 0 to pCubNodeColl.ChildNodes.Count - 1 do
                        if pCubNodeColl.ChildNodes[j].NodeName = 'Cube' then
                        begin
                          pCubNode := pCubNodeColl.ChildNodes.Item[j];  // + <Cube time="2011-01-03">
                          if assigned(pCubNode) then
                          begin

                            if not assigned(pCubNode.Attributes) then
                              Continue;

                            pCurrAttr1 := pCubNode.Attributes.GetNamedItem('time');
                            if not assigned(pCurrAttr1) then
                              Continue;

                            pCurrDate := trim(AStr(pCurrAttr1.NodeValue));
                            if pCurrDate <> '' then
                              for k := 0 to pCubNode.ChildNodes.Count - 1 do
                              begin
                                // jätame alles Eesti keskpanga formaadi toetuse, krt seda teab...järsku tuleb veel kroon tagasi;)
                                // "AED";"2,8834400000"
                                pChildNode := pCubNode.ChildNodes.Item[k];
                                if not assigned(pChildNode.Attributes) then
                                  Continue;

                                pCurrAttr1 := pChildNode.Attributes.GetNamedItem('currency');
                                pCurrAttr2 := pChildNode.Attributes.GetNamedItem('rate');

                                if assigned(pCurrAttr1) and assigned(pCurrAttr2) then
                                begin
                                  pCurrMergeStr :=
                                    Format('"%s";"%s";"%s"', [AStr(pCurrAttr1.NodeValue), AStr(pCurrAttr2.NodeValue), pCurrDate]);
                                  if not self.onReadLineNotification(self.url, j + 1, pCurrMergeStr) then
                                    Break;
                                end;
                                // ---
                              end;
                          end;

                        end;
                      // -- Cube leitud; ja rohkem me ei uuri
                      Break;
                      // ---
                    end;
              end;
            finally
              FreeAndNil(pConfDoc);
            end;
        end
        else
        // algselt tegin selle Eesti panga formaadi jaoks !
        if Pos('text/html', ansilowercase(FHttpReader.contentType)) > 0 then
        begin

          pStream.Seek(0, 0);
          pStrABfr.LoadFromStream(pStream);
          //pStrBfr:=pStream.datastring;
          // emuleerime readline olukord;


          for i := 0 to pStrABfr.Count - 1 do
          begin
            if i + 1 < pstartReadingFromLine then
              Continue;

            // --
            pSkipLine := False;
            if assigned(pSkipLines) then
              for j := low(pSkipLines) to high(pSkipLines) do
              begin
                pSkipLine := pSkipLines[j] = (i + 1);
                if pSkipLine then
                  Break;
              end;

            if not pSkipLine and assigned(pSkipLineStartingWithStr) then
              for j := low(pSkipLineStartingWithStr) to high(pSkipLineStartingWithStr) do
              begin
                pSkipLine := pos(pSkipLineStartingWithStr[j], pStrABfr.Strings[i]) = 1;
                if pSkipLine then
                  Break;
              end;

            if not pSkipLine then
              if not self.onReadLineNotification(self.url, i + 1, pStrABfr.Strings[i]) then
                Break;
            // ------
          end;
          // ---
          Result := True;
        end;
      finally
        FreeAndNil(pStream);
        FreeAndNil(pStrABfr);
      end;
    // ------

  except
    on e: Exception do
    begin
      Result := False;
     {$IFNDEF NOGUI}
      Dialogs.messageDlg(format(estbk_strmsg.SEDataReadFailed, [e.message]), mtError, [mbOK], 0);
     {$ELSE}
      raise;
     {$ENDIF}
    end;
  end;
end;

destructor TEstbkCurrencyExcRateReader.Destroy;
begin
  FreeAndNil(FHttpReader);
  inherited Destroy;
end;

end.
