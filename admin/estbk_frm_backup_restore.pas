// NB siin kompatiiblus kaob liiga Postgre põhine TODO muuta universaalsemaks !!
// Restore on lihtne ! C:\Documents and Settings\Ingmar>pg_restore -d estbk -U postgres -C -h localhost -p 4896 e:\stiigo_andmebaasid\backup_20110805.sql
unit estbk_frm_backup_restore;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, UTF8Process, AsyncProcess;

type

  { TformBackupRestore }

  TformBackupRestore = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnDoBackup: TBitBtn;
    btnClose: TBitBtn;
    chkboxConsole: TCheckBox;
    edtFilepath: TEdit;
    edtPgDumpLocation: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    btnBackupLocation: TSpeedButton;
    dlgFileSave: TSaveDialog;
    lblAppLoc: TLabel;
    lblLog: TLabel;
    memlog: TMemo;
    dlgFileOpen: TOpenDialog;
    procedure btnBackupLocationClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDoBackupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    FTerminateFlag: boolean;
    FRunning: boolean;
    FModeAsBackup: boolean;
  public
    class procedure createAndShow(const pModeAsBackup: boolean = True);
  end;

var
  formBackupRestore: TformBackupRestore;

implementation

uses dateutils, registry, IniFiles, process,
  estbk_strmsg, estbk_uivisualinitadmin,
  estbk_datamodule, estbk_types, estbk_dbcompability;

procedure TformBackupRestore.FormCreate(Sender: TObject);
{$ifdef windows}
  function SearchFile(const Dir: string; const FileLname: string = 'pg_dump.exe'): string;
  var
    SR: TSearchRec;
  begin
    // Result := '';
    if FindFirst(IncludeTrailingBackslash(Dir) + '*.*', faAnyFile or faDirectory, SR) = 0 then
      try
        repeat
          if (SR.Attr and faDirectory) = 0 then
          begin
            if ansilowercase(extractfilename(SR.Name)) = ansilowercase(FileLname) then
            begin
              Result := IncludeTrailingBackslash(Dir) + SR.Name;
              Exit;
            end
            else
              Continue;
          end
          else
          if (SR.Name <> '.') and (SR.Name <> '..') then
          begin
            Result := SearchFile(IncludeTrailingBackslash(Dir) + SR.Name, FileLname);  // recursive call!
            if Result <> '' then
              Break;
          end;
          sleep(1);
        until FindNext(Sr) <> 0;
      finally
        FindClose(SR);
      end;
  end;

  function LocatePgdump: string;
  const
    CHCodeddirs: array[0..1] of string = ('C:\Program Files (x86)\PostgreSQL', 'C:\Program Files\PostgreSQL');
  var
    i: integer;

  begin
    for i := low(CHCodeddirs) to high(CHCodeddirs) do
    begin
      Result := trim(SearchFile(CHCodeddirs[i]));
      if Result <> '' then
        Exit;
    end;
  end;

{$endif}
const
  CDefaultKey = '\SOFTWARE\PostgreSQL\Installations';
var
  pReg: TRegistry;
  pKeynames: TAStrlist;
begin
  estbk_uivisualinitadmin.__preparevisual(self);


  // TODO backup ka teiste backendide jaoks !!!
 {$ifdef windows}
  try
    pReg := TRegistry.Create(KEY_READ);
    pKeynames := TAStrlist.Create;

    pReg.RootKey := HKEY_LOCAL_MACHINE;
    if pReg.OpenKey(CDefaultKey, False) then
    begin
      pReg.GetKeyNames(pKeynames);
      if pKeynames.Count > 0 then
      begin
        pReg.CloseKey;
        if pReg.OpenKey(CDefaultKey + '\' + pKeynames.Strings[pKeynames.Count - 1], False) then
        begin
          edtPgDumpLocation.Text := includetrailingbackslash(pReg.ReadString('Base Directory')) + 'bin' + directoryseparator;

          pReg.CloseKey;
        end; // --
      end;
    end;

  finally
    FreeAndNil(pReg);
    FreeAndNil(pKeynames);
  end;

  // 01.03.2015 Ingmar; järelikult midagi mõistlikku ei leitud, üritame kataloogide otsingu teha;
  if ((edtPgDumpLocation.Text = '') or (copy(edtPgDumpLocation.Text, 1, 1) = '\') or (copy(edtPgDumpLocation.Text, 1, 1) = '/')) then
    edtPgDumpLocation.Text := includetrailingbackslash(extractFilePath(LocatePgdump));
 {$endif}

end;

procedure TformBackupRestore.FormShow(Sender: TObject);
var
  pInitDir: AStr;
begin

  pInitDir := includetrailingbackslash(extractfilepath(ParamStr(0))) + 'backup' + directoryseparator;

  if self.FModeAsBackup then
  begin
    lblAppLoc.Caption := estbk_strmsg.SCPgDumpLoc;
    self.Caption := estbk_strmsg.SCDoBackup;

    dlgFileSave.InitialDir := pInitDir;
    dlgFileSave.FileName := 'backup_' + formatdatetime('yyyymmdd', now) + '.sql';
    edtFilepath.Text := dlgFileSave.InitialDir + dlgFileSave.FileName;
  end
  else
  begin
    self.Caption := estbk_strmsg.SCDoRestore;
    lblAppLoc.Caption := estbk_strmsg.SCPgRestoreLoc;

    dlgFileOpen.InitialDir := pInitDir;
  end; // --
end;

procedure TformBackupRestore.btnDoBackupClick(Sender: TObject);
const
  READ_BYTES = 2048;

var
  pSqldump: TProcess;

  pBytesRead, n: integer;
  pHost: AStr;
  pUsername: AStr;
  pPassword: AStr;
  pPort: integer;
  pTempSQLFName: AStr;
  pBackupFilePath: AStr;
  pCmdLine: AStr;
  pPassWdPrompt: AStr;
  pTmpRez: AStr;
  M: TMemoryStream;
  P: TStringStream;
  pAppSetDir: AStr;
  FCommonIni: IniFiles.TIniFile;
begin
  if self.FRunning then
    Exit;

  M := TMemoryStream.Create;
  P := TStringStream.Create('');
  self.FTerminateFlag := False;
  pSqldump := TProcess.Create(nil);

{
Usage:
  pg_dump [OPTION]... [DBNAME]

General options:
  -f, --file=FILENAME         output file name
  -F, --format=c|t|p          output file format (custom, tar, plain text)
  -v, --verbose               verbose mode
  -Z, --compress=0-9          compression level for compressed formats
  --lock-wait-timeout=TIMEOUT fail after waiting TIMEOUT for a table lock
  --help                      show this help, then exit
  --version                   output version information, then exit

Options controlling the output content:
  -a, --data-only             dump only the data, not the schema
  -b, --blobs                 include large objects in dump
  -c, --clean                 clean (drop) database objects before recreating
  -C, --create                include commands to create database in dump
  -E, --encoding=ENCODING     dump the data in encoding ENCODING
  -n, --schema=SCHEMA         dump the named schema(s) only
  -N, --exclude-schema=SCHEMA do NOT dump the named schema(s)
  -o, --oids                  include OIDs in dump
  -O, --no-owner              skip restoration of object ownership in
                              plain-text format
  -s, --schema-only           dump only the schema, no data
  -S, --superuser=NAME        superuser user name to use in plain-text format
  -t, --table=TABLE           dump the named table(s) only
  -T, --exclude-table=TABLE   do NOT dump the named table(s)
  -x, --no-privileges         do not dump privileges (grant/revoke)
  --binary-upgrade            for use by upgrade utilities only
  --inserts                   dump data as INSERT commands, rather than COPY
  --column-inserts            dump data as INSERT commands with column names
  --disable-dollar-quoting    disable dollar quoting, use SQL standard quoting
  --disable-triggers          disable triggers during data-only restore
  --no-tablespaces            do not dump tablespace assignments
  --role=ROLENAME             do SET ROLE before dump
  --use-set-session-authorization
                              use SET SESSION AUTHORIZATION commands instead of
                              ALTER OWNER commands to set ownership

Connection options:
  -h, --host=HOSTNAME      database server host or socket directory
  -p, --port=PORT          database server port number
  -U, --username=NAME      connect as specified database user
  -w, --no-password        never prompt for password
  -W, --password           force password prompt (should happen automatically)

If no database name is supplied, then the PGDATABASE environment
variable value is used.
}


  // -->
  with estbk_datamodule.admDatamodule.admConnection do
  begin
    pHost := HostName;
    pUsername := User;
    pPassword := Password;
    pPort := Port;
  end; // <--

  try
    try
      btnDoBackup.Enabled := False;
      edtFilepath.Enabled := False;
      btnBackupLocation.Enabled := False;



      pSqldump.Options := [poUsePipes, poStderrToOutPut];
      if not chkboxConsole.Checked then
        pSqldump.Options := pSqldump.Options + [poNoConsole] // [poUsePipes,poNewConsole];
      else
        pSqldump.Options := pSqldump.Options + [poNewConsole];

      pPassWdPrompt := '';
      if chkboxConsole.Checked then
        pPassWdPrompt := '-W'
      else
        pPassWdPrompt := '-w';

      // ----------------------------------------------------------------------
      // @@BACKUP
      // ----------------------------------------------------------------------
      if FModeAsBackup then
      begin

        pTempSQLFName := trim(extractfilename(edtFilepath.Text));
        if (pTempSQLFName = '') or (extractfileext(pTempSQLFName) = '') then
          raise Exception.Create(estbk_strmsg.SEFileNameIsMissing);


        pTempSQLFName := copy(pTempSQLFName, 1, pos('.', pTempSQLFName) - 1) + '.sql';
        pBackupFilePath := includetrailingbackslash(extractfilepath(trim(edtFilepath.Text)));
        if not DirectoryExists(pBackupFilePath) then
          if not ForceDirectories(pBackupFilePath) then
            raise Exception.Create(estbk_strmsg.SEInvalidDirectory);


        pCmdLine := format(includetrailingbackslash(edtPgDumpLocation.Text) + 'pg_dump -h%s -U%s -p%d %s -Z9 -Fc -v -f "%s" %s',
          [pHost, pUsername, pPort, pPassWdPrompt, pBackupFilePath + pTempSQLFName, __dbNameOverride(estbk_types.CProjectDatabaseNameDef)]);
        pSqldump.CommandLine := pCmdLine;

        try

          pAppSetDir := GetAppConfigDir(True);
          if not DirectoryExists(pAppSetDir) then
            ForceDirectories(pAppSetDir);

          try
            FCommonIni := IniFiles.TIniFile.Create(pAppSetDir + estbk_types.CStiigoGeneralIniFileName);
            FCommonIni.WriteString(CStiigoGeneralIniSect, 'lastbackup', IntToStr(Round(Int(now))));
          finally
            FreeAndNil(FCommonIni);
          end;

        except
        end;

      end
      else
      // ----------------------------------------------------------------------
      // @@RESTORE
      // ----------------------------------------------------------------------
      if messageDlg(estbk_strmsg.SConfRestorAct, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin

        // viskame ühenduse maha !
        admDatamodule.admConnection.Disconnect;
        admDatamodule.admConnection.Database := 'postgres';
        admDatamodule.admConnection.Connect;

        // peame andmebaasi välja viskama !
        admDatamodule.admTempQuery.Close;
        admDatamodule.admTempQuery.SQL.Clear;
        admDatamodule.admTempQuery.SQL.Text := format('DROP DATABASE %s', [__dbNameOverride(estbk_types.CProjectDatabaseNameDef)]);
        admDatamodule.admTempQuery.ExecSQL;

        // TODO restore peab ka õiget collationit nägema !
        if (estbk_dbcompability.sqlp.currentBackEnd = __postGre) then
          pTmpRez := estbk_dbcompability.sqlp._create_databaseSQL(__dbNameOverride(estbk_types.CProjectDatabaseNameDef),
            admDatamodule.pgCollation(estbk_types.CPostRequiredCollationAndCType)) + '  TEMPLATE template0 '

        else
          pTmpRez := estbk_dbcompability.sqlp._create_databaseSQL;

        // taastame uuesti andmebaasi
        admDatamodule.admTempQuery.Close;
        admDatamodule.admTempQuery.SQL.Clear;
        admDatamodule.admTempQuery.SQL.Text := pTmpRez;
        admDatamodule.admTempQuery.ExecSQL;

        admDatamodule.admConnection.Disconnect;
        admDatamodule.admConnection.Database := __dbNameOverride(estbk_types.CProjectDatabaseNameDef);


        pBackupFilePath := edtFilepath.Text;
        pCmdLine := format(includetrailingbackslash(edtPgDumpLocation.Text) + 'pg_restore -d %s -U %s -C -h %s -p %d %s "%s"',
          [__dbNameOverride(estbk_types.CProjectDatabaseNameDef), pUsername, pHost, pPort, pPassWdPrompt, pBackupFilePath]);

        pSqldump.CommandLine := pCmdLine;
      end
      else
        Exit;

      // ---
      memlog.Lines.Clear;
      memlog.Lines.Add(pCmdLine);
      memlog.Lines.Add('');
      memlog.Lines.Add(estbk_strmsg.SCPleaseWait);
      memlog.Lines.Add('----------------------------');


      self.FRunning := True;
      pSqldump.Execute;
      pBytesRead := 0;

      // kui otse väljastas memosse toimuvat, siis jooksis kinni, kui puhverdasime ära outputi polnud probleemi !!!
      while pSqldump.Running and not self.FTerminateFlag do
      begin
        Application.ProcessMessages;
        // make sure we have room
        M.SetSize(pBytesRead + READ_BYTES);

        // try reading it
        n := pSqldump.Output.Read((M.Memory + pBytesRead)^, READ_BYTES);
        if n > 0 then
        begin
          Inc(pBytesRead, n);

        end
        else
        begin
          // no data, wait 100 ms
          Sleep(100);
        end;
      end;
      // read last part
      repeat
        // make sure we have room
        M.SetSize(pBytesRead + READ_BYTES);
        // try reading it
        n := pSqldump.Output.Read((M.Memory + pBytesRead)^, READ_BYTES);
        if n > 0 then
        begin
          Inc(pBytesRead, n);

        end;
      until n <= 0;


      M.Seek(0, 0);
      P.CopyFrom(M, M.Size);
      P.Seek(0, 0);

      memlog.Lines.add(P.DataString);

      memlog.Lines.Add('----------------------------');
      memlog.Lines.Add(estbk_strmsg.SCWorkDone);


    except
      on e: Exception do
      begin
        memlog.Lines.Add(e.message);
        Dialogs.messageDlg(e.message, mtError, [mbOK], 0);
      end;
    end;


    if not admDatamodule.admConnection.Connected then
      admDatamodule.admConnection.Connect;
  finally

    btnDoBackup.Enabled := True;
    edtFilepath.Enabled := True;
    btnBackupLocation.Enabled := True;

    self.FRunning := False;
    FreeAndNil(pSqldump);
    FreeAndNil(M);
    FreeAndNil(P);

    // --
    admDatamodule.admTempQuery.Close;
    admDatamodule.admTempQuery.SQL.Clear;
  end;



  if self.FTerminateFlag then
    self.Close;
end;

procedure TformBackupRestore.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  self.FTerminateFlag := True;   // et ikka sulgemine oleks kindel !
end;

procedure TformBackupRestore.btnCloseClick(Sender: TObject);
begin

  if not self.FRunning then
    self.Close;
  self.FTerminateFlag := True;
end;

procedure TformBackupRestore.btnBackupLocationClick(Sender: TObject);
begin
  // ---
  case self.FModeAsBackup of
    True: if dlgFileSave.Execute then
        edtFilepath.Text := dlgFileSave.Files.Strings[0];

    False: if dlgFileOpen.Execute then
        edtFilepath.Text := dlgFileOpen.Files.Strings[0];
  end;
end;

class procedure TformBackupRestore.createAndShow(const pModeAsBackup: boolean = True);
begin
  with self.Create(nil) do
    try
      FModeAsBackup := pModeAsBackup;
      Showmodal;
      // ---
    finally
      Free;
    end;
end;

initialization
  {$I estbk_frm_backup_restore.ctrs}

end.
