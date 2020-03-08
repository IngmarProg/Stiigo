unit estbk_http;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,estbk_types;

function  uploadFile(const pURL : AStr; const pFilePath : AStr; const pFilePostData : AStr = '') : AStr;
procedure downloadDatatoStream(const pURL : AStr; const pStream : TStream);

implementation
uses IdHttp,IdUri{$ifdef windows},estbk_wininet{$endif};
const
    CConnectTimeout = 60000; // 60 sek
    CReadTimeOut    = 45000; // 45 sek
{
POST /new HTTP/1.1
User-Agent: curl/7.41.0
Host: www.stiigo.com
Accept: */*
Content-Length: 4783
Expect: 100-continue
Content-Type: multipart/form-data; boundary=------------------------1b3f54ff62dcc117
HTTP/1.1 100 Continue

--------------------------1b3f54ff62dcc117
Content-Disposition: form-data; name="file"; filename="sepa25112015.xml"
Content-Type: application/xml

...

--------------------------1b3f54ff62dcc117--
}
function uploadFile(const pURL : AStr; const pFilePath : AStr; const pFilePostData : AStr = '') : AStr;
{$ifdef windows}
var
    pHttpCode : Integer;
    pHttpData : TWininet_http_conn;
    pStrStream : TStringStream;
    pMemStream : TMemoryStream;
{$endif}
begin
{$ifdef windows}
  try
     pStrStream := TStringStream.Create('');
     pMemStream := TMemoryStream.Create;
     pHttpData := TWininet_http_conn.create();
     pHttpData.url := pURL;
     pHttpData.stream_gp := pMemStream;


     pHttpData.execCmd(wininet_post, pFilePath, pFilePostData);
     pHttpCode := pHttpData.httpCode;

     pMemStream.Seek(0, 0);
     pStrStream.CopyFrom(pMemStream, pMemStream.Size);


     pStrStream.Seek(0, 0);
     Result := pStrStream.DataString;

 if (pHttpCode <> 200) and (pHttpCode <> 300) and (pHttpCode <> 301) and (pHttpCode <> 302) then
     raise exception.CreateFmt('%d: error',[pHttpCode]);


 finally
     FreeAndNil(pHttpData);
     FreeAndNil(pStrStream);
     FreeAndNil(pMemStream);
 end;
{$endif}
end;

procedure downloadDatatoStream(const pURL : AStr; const pStream : TStream);
var
  {$ifdef windows}
    pHttpCode : Integer;
    pHttpData : TWininet_http_conn;
  {$else}
    pHttpData : TIdHttp;
  {$endif}
    pMemoryStream : TMemoryStream;
begin
  {
  {$ifdef win32}
   ConfigFilePath := ExtractFilePath(Application.EXEName) + 'myapp.ini';
  {$endif}
  {$ifdef Unix}
   ConfigFilePath := GetAppConfigFile(False) + '.conf';
  {$endif}
  }

    if (pURL<>'') and assigned(pStream) then
      try
            pMemoryStream:=TMemoryStream.Create;
        {$ifdef windows}

            // 21.08.2011 Ingmar
            // windowsis wininet parem, siis ei pea me proxy probleemidega mässama ! Paljud kliendid ju proxy taga !
            // indys olemas; aga kliendid ei oska või ei taha proxyt konfida !
            pHttpData:=TWininet_http_conn.create();
            pHttpData.url:=pURL;
            pHttpData.stream_gp:=pMemoryStream;
            pHttpData.execCmd();
            pHttpCode:=pHttpData.httpCode;

        if (pHttpCode<>200) and (pHttpCode<>300) and (pHttpCode<>301) and (pHttpCode<>302) then
            raise exception.CreateFmt('%d: error',[pHttpCode]);


        {$else}
            pHttpData:=TIdHttp.Create;
            // pHttpData.ProxyParams.ProxyServer
            // pHttpData.ProxyParams.ProxyUsername
            // pHttpData.ProxyParams.ProxyPassword
            // pHttpData.ProxyParams.ProxyPort
            pHttpData.ConnectTimeout:=CConnectTimeout;
            pHttpData.ReadTimeout:=CReadTimeOut;

            pHttpData.MaxAuthRetries:=1;
            pHttpData.RedirectMaximum:=3;

            pHttpData.Get(pURL,pMemoryStream);

        {$endif}

            pMemoryStream.Seek(0,0);
            pStream.CopyFrom(pMemoryStream,pMemoryStream.Size);

      finally
            freeAndNil(pHttpData);
            freeAndNil(pMemoryStream);
      end;
end;

end.

