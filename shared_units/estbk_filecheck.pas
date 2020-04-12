// 25.07.2011 Ingmar
unit estbk_filecheck;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, estbk_types;

function __verifyFiles: boolean;

implementation

uses Dialogs, estbk_strmsg, estbk_dbcompability {$ifdef windows}, Windows{$endif};

function __verifyFiles: boolean;
const
  pPostgreReqFile: array[0..11] of AStr = ('comerr32.dll',
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
  pStiigoPath: AStr;
  i: integer;
  {$ifdef windows}
  pLibtest: THandle;
  {$endif}
begin
  Result := False;

  // backend postgres !
{$ifdef windows}
  if sqlp.currentBackEnd = __postGre then
  begin
    // --
    pStiigoPath := includetrailingbackslash(extractfilepath(ParamStr(0)));

    for i := low(pPostgreReqFile) to high(pPostgreReqFile) do
      if not fileExists(pStiigoPath + pPostgreReqFile[i]) then
      begin
        Dialogs.messageDlg(format(estbk_strmsg.SEFilesMissing, [extractfilepath(ParamStr(0)), pPostgreReqFile[i]]), mtError, [mbOK], 0);
        // --
        Exit;
      end;

    // -- proovime ka postgre suhtlusfaili laadimist
    pLibtest := loadLibrary('libpq.dll');
    if pLibtest <= 0 then
    begin

      Dialogs.messageDlg(format(estbk_strmsg.SELibPQloadFailed, [SysErrorMessage(GetLastError)]), mtError, [mbOK], 0);
      // --
      Exit;
    end;

    // ---
    Freelibrary(pLibtest);

  end
  else
{$endif}
    Result := True;

  // ---
  Result := True;
end;

end.
