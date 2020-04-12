// ###########################################################################################
// Module Copyright http://ingmar.planet.ee 2006
// Ingmar created simple wininet class; 
// ###########################################################################################


unit estbk_wininet;

interface

uses Windows, WinInet, Classes, SysUtils;

type
  TWinInetReqMethod = (wininet_get, wininet_post, wininet_put);

  TWininet_http_conn = class(TObject)
  protected
    // 28.05.2008 added extra params
    FSendTimeOut: cardinal;
    FReceiveTimeOut: cardinal;
    FConnectTimeOut: cardinal;
    // ---
    iNetHandle: WinInet.HINTERNET;
    fuseragent: string;
    fusername: string;
    fpassword: string;
    furl: string;
    fHeaders: TStringList;
    fdownloadToStream: TMemoryStream;
    FHttpCode: integer;
    // --
    function stringToCaseSelect(const fname: string; const sp: array of string): integer;
    function contentTypeFromExt(const AFilename: string): string;
    function extractData(const dataItem: string): string;
    function getCookieData: string;
    procedure setCookieData(const v: string);
    function getContentType: string;
    function getContentLength: integer;
  public

    property sendTimeOutSec: cardinal read FSendTimeOut write FSendTimeOut;
    property receiveTimeOutSec: cardinal read FReceiveTimeOut write FReceiveTimeOut;
    property connectTimeOutSec: cardinal read FConnectTimeOut write FConnectTimeOut;

    //property     userAgent: String read fuseragent write fuseragent;
    property username: string read fusername write fusername;
    property password: string read fpassword write fpassword;
    property url: string read furl write furl;
    // extract from headers special items...cookie, content-type
    property cookie: string read getCookieData write setCookieData;
    property contentType: string read getContentType;
    property contentLength: integer read getContentLength;
    property httpCode: integer read FHttpCode;
    // ------------
    property headers: TStringList read fHeaders;
    property stream_gp: TMemoryStream read fdownloadToStream write fdownloadToStream;
    // ------------
    constructor Create();
    destructor Destroy; override;
    procedure execCmd(const method: TWinInetReqMethod = wininet_get; const datafromfile: string = '';
    //  file to upload per POST cmd
      postData: string = '' // for example file input name
      ); virtual;
    // ------------
  end;

implementation

const
  CCookieStr = 'Cookie:';
  CContentType = 'Content-Type:';
  CContentLength = 'Content-Length:';
  ReqMethods: array[TWinInetReqMethod] of string = ('GET', 'POST', 'PUT');

// 01.05.2008 Ingmar; TODO support InternetConnectW in future
constructor TWininet_http_conn.Create;
begin
  inherited Create;
  fHeaders := TStringList.Create;

  FSendTimeOut := 180;    // 3 minutes
  FReceiveTimeOut := 300; // 5 minutes
  FConnectTimeOut := 120; // 2 minutes
end;

function TWininet_http_conn.stringToCaseSelect(const fname: string; const sp: array of string): integer;
var
  i: integer;
begin
  for i := low(sp) to high(sp) do
    if sp[i] = fname then
    begin
      Result := i;
      break;
    end;
end;


function TWininet_http_conn.contentTypeFromExt(const AFilename: string): string;
const
  MimeTypes: array[0..15] of string = ('.gif',
    '.jpg',
    '.png',
    '.css',
    '.htm',
    '.html',
    '.asp',
    '.aspx',
    '.xml',
    '.js',
    '.txt',
    '.log',
    '.csv',
    '.pdf',
    '.rtf',
    '.zip');
begin

  case StringToCaseSelect(LowerCase(ExtractFileExt(AFilename)), MimeTypes) of
    0: Result := 'image/gif';
    1: Result := 'image/jpg';
    2: Result := 'image/png';
    3: Result := 'text/css';
    4, 5: // htm, html
      Result := 'text/html';
    6, 7, 10, 11: // asp, aspx, .txt, .log
      Result := 'text/plain';
    8: // xml
      Result := 'text/xml';
    9: // js
      Result := 'text/javascript';
    12: Result := 'text/csv';
    13: Result := 'application/pdf';
    14: Result := 'application/rtf';
    15: Result := 'application/zip';
    else
    begin
      // Result := 'application/binary';
      Result := 'application/octet-stream';
    end;
  end;
end;


function TWininet_http_conn.extractData(const dataItem: string): string;
var
  i: integer;
  pst: string;
begin
  Result := '';
  for i := 0 to self.fHeaders.Count - 1 do
  begin
    pst := self.fHeaders.Strings[i];
    if pos(ansilowercase(dataItem), ansilowercase(pst)) = 1 then
    begin
      Delete(pst, 1, length(dataItem));
      Result := trim(pst);
      break;
    end;
  end;

end;


function TWininet_http_conn.getCookieData: string;
begin
  Result := extractData(CCookieStr);
end;

procedure TWininet_http_conn.setCookieData(const v: string);
var
  i: integer;
  pst: string;
begin
  for i := 0 to self.fHeaders.Count - 1 do
  begin
    pst := self.fHeaders.Strings[i];
    if pos(ansilowercase(CCookieStr), ansilowercase(pst)) = 1 then
    begin
      self.fHeaders.Strings[i] := CCookieStr + #32 + v;
      exit;
    end;
  end;
  // --------------
  self.fHeaders.Add(CCookieStr + #32 + v);
end;

function TWininet_http_conn.getContentType: string;
begin
  Result := extractData(CContentType);
end;

function TWininet_http_conn.getContentLength: integer;
var
  pd: string;
begin
  Result := 0;
  pd := trim(extractData(CContentLength));
  if length(pd) > 0 then
    try
      Result := StrToInt(pd);
    except
      Result := 0;
    end;
end;


procedure TWininet_http_conn.execCmd(const method: TWinInetReqMethod = wininet_get; const datafromfile: string = ''; postData: string = '');
const
  INTERNET_OPTION_HTTP_DECODING = 65;
const
  maxBufferSize = 1024 * 5;

var
  i, j: integer;
  //       dataString  : String;
  connectToHost: string;
  errorMsg: string;
  getPath: string;
  convertToWide: WideString;
  bufferLen: DWord;
  errorCode: DWord;
  lastWAIerr: DWord;
  BLen: Dword;
  dataLen: Dword;
  dummyIndx: Dword;
  // --------
  pcomp: wininet.URL_COMPONENTS;
  pibfr: wininet.INTERNET_BUFFERS;
  ppos: integer;
  iConnection: WinInet.HINTERNET;
  iReqHandle: WinInet.HINTERNET;
  Buffer: array[0..maxBufferSize - 1] of char;
  accept: array[0..1] of PChar;
  pfuploadBfr: array[0..1023] of char;
  // ----------
  hasData: boolean;
  pHttpHeader: string; // currently for cookie
  pHttpFullHeaderBfr: string;
  pBoundary: string;
  pFileToUpload: THandle;
  // ----------
  fileReadCnt: DWord;
  actualRead: DWord;
  httpWriteCnt: DWord;
  actualWrite: DWord;
  pBuildFileHeader: string;
  pBuildFileFooter: string;
  pHasFile: boolean;
  // ----------
  toMilliSec: cardinal;
  Dummy: longbool;
begin
  if not assigned(stream_gp) and (method = wininet_get) then
    raise Exception.Create('Resultstream not assigned !');

  // ----------
  try

    // fCookieData:='';
    pHttpHeader := '';
    iReqHandle := nil;
    accept[0] := '*/*';
    accept[1] := nil;

    iConnection := nil;
    iReqHandle := nil;

    iNetHandle := InternetOpen('Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14',
      //'Internet Explorer',
      INTERNET_OPEN_TYPE_PRECONFIG,//INTERNET_OPEN_TYPE_DIRECT,
      nil, nil, 0);  // INTERNET_FLAG_NO_CACHE_WRITE
    if not assigned(iNetHandle) then
      raiselastOsError;


    // ------------------
    setlength(connectToHost, 1024);
    setlength(getPath, 4096);
    fillchar(pcomp, sizeof(pcomp), 0);
    pcomp.dwStructSize := sizeof(pcomp);

    pcomp.lpszHostName := PChar(connectToHost);
    pcomp.dwHostNameLength := length(connectToHost);

    pcomp.lpszUrlPath := PChar(getPath);
    pcomp.dwUrlPathLength := length(getPath);


    // 22.05.2008 Ingmar; add SSL
    //if  not InternetCrackUrl(pchar(url),length(url),ICU_DECODE,pcomp) then
    //    raiselastosError;
    // INTERNET_FLAG_SECURE
    // InternetSetOption hRequest, INTERNET_OPTION_USERNAME, sUserName, Len(sUserName)
    // InternetSetOption hRequest, INTERNET_OPTION_PASSWORD, sPassword, Len(sPassword

    if not InternetCrackUrl(PChar(url), length(url), 0, pcomp) then // 22.05.2008 Ingmar; 0 keep path as is no encode !!!
      raiselastosError;


    setlength(getPath, pcomp.dwUrlPathLength);
    setlength(connectToHost, pcomp.dwHostNameLength);
    // ---
    if length(trim(connectToHost)) < 3 then
      raise Exception.Create('Incorrect URL !');

    getPath := trim(getPath);
    if length(getPath) = 0 then
      getPath := '/';
    iConnection := InternetConnect(iNetHandle, PChar(connectToHost), INTERNET_DEFAULT_HTTP_PORT,
      // INTERNET_DEFAULT_HTTPS_PORT ;INTERNET_DEFAULT_FTP_PORT
      PChar(username) {usename}, PChar(password){password}, INTERNET_SERVICE_HTTP, // INTERNET_SERVICE_FTP
      0, // INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_NO_COOKIES,
      0);
    if not assigned(iConnection) then
      raiselastOsError;


    toMilliSec := FSendTimeOut * 1000;
    if not InternetSetOption(iConnection, wininet.INTERNET_OPTION_SEND_TIMEOUT, @toMilliSec, sizeof(toMilliSec)) then
      raiselastOsError;

    toMilliSec := FReceiveTimeOut * 1000;
    if not InternetSetOption(iConnection, wininet.INTERNET_OPTION_RECEIVE_TIMEOUT, @toMilliSec, sizeof(toMilliSec)) then
      raiselastOsError;

    toMilliSec := FConnectTimeOut * 1000;
    if not InternetSetOption(iConnection, wininet.INTERNET_OPTION_CONNECT_TIMEOUT, @toMilliSec, sizeof(toMilliSec)) then
      raiselastOsError;

    // 25.09.2009 ingmar; pakime ikka andmed ka lahti
    Dummy := True;
    if not InternetSetOption(iConnection, INTERNET_OPTION_HTTP_DECODING, @Dummy, sizeof(Dummy)) then
      raiselastOsError;


    //getPath:=newsbrain_Utilities.urlEncode_(getPath);

    BufferLen := 0;
    iReqHandle := HttpOpenRequest(iConnection, PChar(ReqMethods[method]), PChar(getPath), 'HTTP/1.1', nil, @accept,
      INTERNET_FLAG_NO_UI or INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_NO_COOKIES or INTERNET_FLAG_RELOAD or INTERNET_FLAG_KEEP_CONNECTION,
      // INTERNET_FLAG_SECURE
      0);
    if not assigned(iReqHandle) then
      raiselastoserror;




    // ------
{
       datalen:=8192;
       setlength(pHttpHeader,datalen);
    if not HttpQueryInfo(iReqHandle,
                        HTTP_QUERY_FLAG_REQUEST_HEADERS, //  or HTTP_QUERY_SET_COOKIE,
                        pchar(pHttpHeader),
                        dataLen,
                        dummyIndx)  or (dataLen<1) or (dataLen>high(word)) then
       pHttpHeader:=''
    else
     begin
       setlength(pHttpHeader,dataLen);
     end;
             //  raiselastoserror; raise exception.Create('Can''t set cookie !');
             // end;

}
    // fHeaders.Add('Cookie: tegemist on ingmari testiga !!!!!!!!!!!!!!!!!!');
    // -----
    pHttpHeader := 'Accept-Encoding: gzip';
    dataLen := length(pHttpHeader);
    if not HttpAddRequestHeaders(iReqHandle, PChar(pHttpHeader), dataLen, HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE) then
      raiselastOsError;


    for i := 0 to fHeaders.Count - 1 do
    begin
      if length(trim(fHeaders.Strings[i])) = 0 then
        continue;
      // ---
      pHttpHeader := trim(fHeaders.Strings[i]) + #13#10;
      dataLen := length(pHttpHeader);
      if not HttpAddRequestHeaders(iReqHandle, PChar(pHttpHeader), dataLen, HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE) then
        raiselastOsError;

    end;

    //pHttpHeader:=self.fHeaders.Text;
    //datalen:=length(pHttpHeader);



    if method = wininet_get then
    begin

      if HttpSendRequest(iReqHandle, nil, 0, nil, 0) then
      begin
        // ---------------

        dummyIndx := 0;
        dataLen := 8192;
        pHttpFullHeaderBfr := '';
        setlength(pHttpFullHeaderBfr, dataLen);
        if not HttpQueryInfo(iReqHandle,
          // HTTP_QUERY_FLAG_RESPONSE_HEADERS
          // HTTP_QUERY_FLAG_REQUEST_HEADERS
          HTTP_QUERY_RAW_HEADERS_CRLF, PChar(pHttpFullHeaderBfr), dataLen, dummyIndx) or (dataLen < 1) or (dataLen > high(word)) then
          pHttpFullHeaderBfr := ''
        else
          setlength(pHttpFullHeaderBfr, datalen);
        fHeaders.Clear;
        fHeaders.Text := pHttpFullHeaderBfr;

        dummyIndx := 0;
        datalen := sizeof(FHttpCode);
        pHttpHeader := '';
        if not HttpQueryInfo(iReqHandle, HTTP_QUERY_FLAG_NUMBER or HTTP_QUERY_STATUS_CODE, @FHttpCode, datalen, dummyIndx) or
          (dataLen < 1) or (dataLen > high(word)) then
          FHttpCode := -1;


        // for i:=0 to fHeaders.Count-1 do
        //showmessage(fHeaders.Strings[i]);

        dataLen := 0;
        //InternetSetFilePointer(iReqHandle,1,nil, FILE_BEGIN, 0);
        hasData := InternetQueryDataAvailable(iReqHandle, dataLen, 0, 0) and (dataLen > 0);
        if hasData then
        begin

          repeat

            bLen := SizeOf(Buffer);
            fillchar(Buffer[0], sizeof(Buffer), 0);
            InternetReadFile(iReqHandle, @Buffer,
              SizeOf(Buffer),
              bLen);
            stream_gp.Write(Buffer[0], bLen);
          until bLen < 1;
        end;
      end
      else
        raiseLastOsError;
      // -----------------
      stream_gp.Seek(0, 0);
      // -----------------
    end
    else
    // if (method = wininet_put) then similar to post...but needs to be tested !
    if (method = wininet_post) then
      try

        // Ingmar; haven't tested yet !!
        // http://support.microsoft.com/kb/184352
        // currently only one file at the time is supported, multiple file download requeired more work
        dummyIndx := 0;
        actualRead := 0;
        actualWrite := 0;
        pFileToUpload := 0;
        // ------------------------------------------------------------------
        pHasFile := length(datafromfile) > 0;
        // ------------------------------------------------------------------
        if pHasFile then
        begin
          // -------
          pFileToUpload := CreateFile(PChar(datafromfile), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING,
            FILE_ATTRIBUTE_NORMAL, dummyIndx);
          if (pFileToUpload = INVALID_HANDLE_VALUE) then
            raiselastoserror;

          // ingmar; my two cents...
          fillchar(pibfr, 0, sizeof(wininet._INTERNET_BUFFERSA));
          pibfr.dwStructSize := sizeof(wininet._INTERNET_BUFFERSA);
          pibfr.dwBufferTotal := GetFileSize(pFileToUpload, nil);
          // Content-Type: multipart/form-data; boundary=---------------------------273813197224385
          // Content-Length: 27287
          // 1310

          // Content-Disposition: form-data; name="file"; filename="sepa25112015.xml"
          // pBoundary:='---------------------------ing'+inttohex(gettickcount,12);
          pBoundary := '---------------------------' + 'stiigo' + inttohex(gettickcount, 12) + IntToStr(random(high(word)));
          pBuildFileHeader := '--' + pBoundary + chr(13) + chr(10);

          if postData = '' then
            postData := 'name="file"';

          pBuildFileHeader := pBuildFileHeader + 'Content-Disposition: form-data; ' + postData + '; filename="' +
            extractfilename(datafromfile) + '"' + chr(13) + chr(10);
          pBuildFileHeader := pBuildFileHeader + 'Content-Type: ' + contentTypeFromExt(extractfilename(datafromfile)) +
            chr(13) + chr(10) + chr(13) + chr(10);
          pBuildFileFooter := chr(13) + chr(10) + '--' + pBoundary + '--' + chr(13) + chr(10);


          pHttpHeader := 'Content-Type: multipart/form-data; boundary=' + pBoundary + chr(13) + chr(10);
          // delphi goes bogus with # 13 # 10 ??????
          //           dataLen:=length(pHttpHeader);
          //         if not HttpAddRequestHeaders(iReqHandle,
          //                                      pchar(pHttpHeader),
          //                                      dataLen,
          //                                       HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE) then
          //           raiselastOsError;
          // -----------------------------------------------------------------



          //pHttpHeader:=pHttpHeader+format('Content-Length: %d'+chr(13)+chr(10),[pibfr.dwBufferTotal+2+length(pBuildFileHeader)+length(pBuildFileFooter)]); // #13#10
          pibfr.lpcszHeader := PChar(pHttpHeader);
          pibfr.dwHeadersLength := length(pHttpHeader);
          pibfr.dwHeadersTotal := pibfr.dwHeadersLength;

          //           dataLen:=length(pHttpHeader);
          //         if not HttpAddRequestHeaders(iReqHandle,
          //                                      pchar(pHttpHeader),
          //                                      dataLen,
          //                                       HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE) then
          //           raiselastOsError;


          pibfr.dwBufferTotal := pibfr.dwBufferTotal + length(pBuildFileHeader) + length(pBuildFileFooter);
          pibfr.dwBufferLength := 0;



          if not HttpSendRequestEx(iReqHandle, @pibfr, nil, HSR_INITIATE, 0) then
            raiselastoserror;



          fileReadCnt := 0;
          httpWriteCnt := 0;


          // ---- Ingmar send headers different way

          if not InternetWriteFile(iReqHandle, PChar(pBuildFileHeader), length(pBuildFileHeader), actualWrite) then
            raiselastoserror;



          repeat

            actualRead := 0;
            if not ReadFile(pFileToUpload, pfuploadBfr[0], sizeof(pfuploadBfr), actualRead, nil) then
              raiselastoserror;
            fileReadCnt := fileReadCnt + actualRead;
            // ----------
            actualWrite := 0;
            if not InternetWriteFile(iReqHandle, @pfuploadBfr[0], actualRead, actualWrite) then
              raiselastoserror;
            httpWriteCnt := httpWriteCnt + actualWrite;
          until actualRead <> sizeof(pfuploadBfr); // file actual read

          actualWrite := 0;
          if not InternetWriteFile(iReqHandle, PChar(pBuildFileFooter), length(pBuildFileFooter), actualWrite) then
            raiselastoserror;


          if not HttpEndRequest(iReqHandle, nil, 0, 0) then
            raiselastoserror;

          datalen := sizeof(FHttpCode);
          if not HttpQueryInfo(iReqHandle, HTTP_QUERY_FLAG_NUMBER or HTTP_QUERY_STATUS_CODE, @FHttpCode, datalen, dummyIndx) or
            (dataLen < 1) or (dataLen > high(word)) then
            FHttpCode := -1;
          // tahan ka posti vastust !
          dataLen := 0;
          hasData := InternetQueryDataAvailable(iReqHandle, dataLen, 0, 0) and (dataLen > 0);
          if hasData and assigned(stream_gp) then
          begin

            repeat

              bLen := SizeOf(Buffer);
              fillchar(Buffer[0], sizeof(Buffer), 0);
              InternetReadFile(iReqHandle, @Buffer,
                SizeOf(Buffer),
                bLen);
              stream_gp.Write(Buffer[0], bLen);
            until bLen < 1;
            // -----------------
            stream_gp.Seek(0, 0);
            // -----------------

          end;

        end
        else
        begin
          // post only input items ?!? postData
          // banners1=test&banners2=test1&banners3=test2 multiple items
          pHttpHeader := 'Content-Type: application/x-www-form-urlencoded';
          dataLen := length(pHttpHeader);
          if not HttpAddRequestHeaders(iReqHandle, PChar(pHttpHeader), dataLen, HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE) then
            raiselastOsError;

          if HttpSendRequest(iReqHandle, nil, 0, PChar(postData), length(postData)) then
          begin
            // ---------------

            dummyIndx := 0;
            dataLen := 8192;
            setlength(pHttpFullHeaderBfr, dataLen);
            if not HttpQueryInfo(iReqHandle,
              // HTTP_QUERY_FLAG_RESPONSE_HEADERS
              // HTTP_QUERY_FLAG_REQUEST_HEADERS
              HTTP_QUERY_RAW_HEADERS_CRLF, PChar(pHttpFullHeaderBfr), dataLen, dummyIndx) or (dataLen < 1) or
              (dataLen > high(word)) then
              pHttpFullHeaderBfr := ''
            else
              setlength(pHttpFullHeaderBfr, datalen);
            fHeaders.Clear;
            fHeaders.Text := pHttpFullHeaderBfr;


            // for i:=0 to fHeaders.Count-1 do
            //showmessage(fHeaders.Strings[i]);

            dataLen := 0;
            //InternetSetFilePointer(iReqHandle,1,nil, FILE_BEGIN, 0);
            hasData := InternetQueryDataAvailable(iReqHandle, dataLen, 0, 0) and (dataLen > 0);
            if hasData and assigned(stream_gp) then
            begin

              repeat

                bLen := SizeOf(Buffer);
                fillchar(Buffer[0], sizeof(Buffer), 0);
                InternetReadFile(iReqHandle, @Buffer,
                  SizeOf(Buffer),
                  bLen);
                stream_gp.Write(Buffer[0], bLen);
              until bLen < 1;
              // -----------------
              stream_gp.Seek(0, 0);
              // -----------------
            end;

            datalen := sizeof(FHttpCode);
            if not HttpQueryInfo(iReqHandle, HTTP_QUERY_FLAG_NUMBER or HTTP_QUERY_STATUS_CODE, @FHttpCode, datalen, dummyIndx) or
              (dataLen < 1) or (dataLen > high(word)) then


              FHttpCode := -1;
          end
          else
            raiseLastOsError;
        end;
      finally
        if (pFileToUpload > 0) and (pFileToUpload <> INVALID_HANDLE_VALUE) then
          closehandle(pFileToUpload);
      end;



  finally
    if assigned(iReqHandle) then
      InternetCloseHandle(iReqHandle);

    if assigned(iConnection) then
      InternetCloseHandle(iConnection);

    if assigned(iNetHandle) then
      InternetCloseHandle(iNetHandle);
  end;
end;

destructor TWininet_http_conn.Destroy;
begin
  //if assigned(iNetHandle) then
  //   InternetCloseHandle(iNetHandle);

  fHeaders.Free;
  inherited Destroy;
end;

initialization
  Randomize;
end.