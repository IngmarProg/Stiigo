unit UErrorLogger;

{$mode objfpc}{$H+}

interface

uses

  SysUtils
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  ,cthreads,
  cmem // the c memory manager is on some systems much faster for multi-threading
  {$ENDIF}{$ENDIF}
  ,Classes, SyncObjs,estbk_types;

type
  TErrorSeverity = (_errInformation, _errWarning,_errError,_errFatal);

type
  TErrorLogger = class
  protected
   Flogdir : AStr;
  public
    property logdir : AStr read Flogdir write Flogdir;
    class function msg(const pemsg : AStr; const perrType : TErrorSeverity = _errError) : Boolean;  // hetkel ainult staatiline
  end;


implementation
var
  __safelog : TCriticalSection;

class function TErrorLogger.msg(const pemsg : AStr; const perrType : TErrorSeverity = _errError) : Boolean;
var
  pLogFileDir : AStr;
  pLogFile : TextFile;
begin
    Result := false;

    pLogFileDir := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)))+'log'+System.DirectorySeparator;
 if not DirectoryExists(pLogFileDir) then
    ForceDirectories(pLogFileDir);
    // @@
    pLogFileDir := pLogFileDir + 'stiigoweb_'+formatdatetime('yyyy_mm_dd',now)+'.log';

 try

   try
      __safelog.Enter;
      AssignFile(pLogFile, pLogFileDir);
   if not FileExists(pLogFileDir) then
      Rewrite(pLogFile)
   else
      Append(pLogFile);
      Writeln(pLogFile,'[',formatdatetime('dd.mm.yyyy hh:mm',now),'] '+pemsg);
      CloseFile(pLogFile);
   finally
      __safelog.Leave;
   end;
    // ---
    Result := true;
 except
 end;
end;

(*
   procedure DbgOutThreadLog(const Msg: string); overload;
   procedure DebuglnThreadLog(const Msg: string); overload;
   procedure DebuglnThreadLog(Args: array of const); overload;
   procedure DebuglnThreadLog; overload;
*)

initialization
 __safelog := TCriticalSection.Create;
finalization
 FreeAndNil(__safelog);
end.

