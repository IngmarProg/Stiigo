// 25.07.2011 Ingmar
unit estbk_filecheck;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,estbk_types;

function __verifyFiles:Boolean;

{
 Seoses murega hakkasin faile kontrollima !

 Ann
 õigepealt tänud programmi tegijale :)
Kasutasin ka ja töö sujus täitsa kenasti, vahepeal pidasin paar kuud pausi ja nüüd püüdes uuesti sisse logida, sain teate: "Andmebaasi logimine ebaõnnestus. None of the dynamic libraries can be found: libpq81.dll, libpq.dll".
Olen nõutu, mis ma peaks tegema?
}

implementation
uses dialogs,estbk_strmsg,estbk_dbcompability {$ifdef windows},windows{$endif};

function __verifyFiles:Boolean;
const
  pPostgreReqFile : Array[0..11]  of AStr = ('comerr32.dll',
                                             'gssapi32.dll',
                                             'k5sprt32.dll',
                                             'krb5_32.dll',
                                             'libeay32.dll ',
                                             'libiconv-2.dll',
                                             'libintl-8.dll',
                                             'libpq.dll',
                                             'libxml2.dll',
                                             'libxslt.dll',
                                             'msvcr71.dll',
                                             'ssleay32.dll');
var
  pStiigoPath : AStr;
  i : Integer;
  {$ifdef windows}
  pLibtest : THandle;
  {$endif}
begin
    result:=false;

// backend postgres !
{$ifdef windows}
if  sqlp.currentBackEnd=__postGre then
   begin
          // --
          pStiigoPath:=includetrailingbackslash(extractfilepath(paramstr(0)));

      for i:=low(pPostgreReqFile) to high(pPostgreReqFile) do
       if not fileExists(pStiigoPath+ pPostgreReqFile[i]) then
         begin
          dialogs.messageDlg(format(estbk_strmsg.SEFilesMissing,[extractfilepath(paramstr(0)), pPostgreReqFile[i]]),mtError,[mbOk],0);
          // --
          Exit;
         end;

         // -- proovime ka postgre suhtlusfaili laadimist
         pLibtest:=loadLibrary('libpq.dll');
      if pLibtest<=0 then
        begin

          dialogs.messageDlg(format(estbk_strmsg.SELibPQloadFailed,[SysErrorMessage(GetLastError)]),mtError,[mbOk],0);
          // --
          Exit;
        end;

         // ---
         Freelibrary(pLibtest);

   end else
{$endif}
      result:=true;

      // ---
      result:=true;
end;

end.

