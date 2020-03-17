unit UConnectionpool;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDbcIntfs, estbk_types, estbk_dbcompability;

const
  CMaxPoolObj = 12;

type
  TPoolData = class
    FPooledConn: TZConnection;
    FLocked: boolean;
    FBadConnection: boolean;
    FLockedDt: TDatetime;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TConnectionpool = class
  protected
    FHost: AStr;
    FPort: integer;
    FLogin: AStr;
    FPassword: AStr;
    FDatabase: AStr;
    FThreadlist: TThreadList;
    FTerminate: boolean;
    class procedure Log(const pMsg: AStr);
    procedure createPoolObj(const pPoolItemCnt: integer = CMaxPoolObj);
    procedure cleanupConnObjects;
  public
    function AcquireConnection(): TZConnection;
    procedure ReleaseConnection(const pUsedConn: TZConnection);
    procedure StartPool;
    constructor Create(const pHost: AStr; const pPort: integer; const pUsername: AStr; const pPassword: AStr;
      const pDatabase: AStr = estbk_types.CProjectDatabaseNameDef; const pPoolSize: integer = CMaxPoolObj);
    destructor Destroy(); override;
  end;

implementation

constructor TPoolData.Create;
begin
  inherited Create;
  FPooledConn := TZConnection.Create(nil);
  FPooledConn.Protocol := sqlp.getCurrentBackEndProtocol;
  FPooledConn.TransactIsolationLevel := tiReadCommitted;
  sqlp.initPropertiesByBackend(FPooledConn.Properties);
end;


destructor TPoolData.Destroy;
begin
  FreeAndNil(FPooledConn);
  inherited Destroy;
end;

class procedure TConnectionpool.Log(const pMsg: AStr);
var
  plog: Textfile;
begin

end;

function TConnectionpool.AcquireConnection(): TZConnection;
var
  pPoolData: TPoolData;
  i: integer;
begin
  Result := nil;

  try

    // @@
    with self.FThreadlist.LockList do
      try
        // vahetades otsingujärjekorda saab vahel parema tulemuse
        if random(4) mod 2 = 0 then
          for i := 0 to Count - 1 do
          begin
            pPoolData := TPoolData(Items[i]);
            if not pPoolData.FBadConnection and not pPoolData.FLocked then
            begin
              pPoolData.FLocked := True;
              pPoolData.FLockedDt := now;
              Result := pPoolData.FPooledConn;

              if not Result.Connected then
                Result.Connect;

              // try to reconnect
              try
                pPoolData.FPooledConn.ExecuteDirect('SELECT 1');
              except
                on e: Exception do
                begin
                  TConnectionpool.Log(e.message);
                  Sleep(1000);
                  pPoolData.FPooledConn.Connected := False;
                  pPoolData.FPooledConn.Connected := True;
                end;
              end;

              Break;
            end;
          end
        else
          for i := Count - 1 downto 0 do
          begin
            pPoolData := TPoolData(Items[i]);
            if not pPoolData.FBadConnection and not pPoolData.FLocked then
            begin
              pPoolData.FLocked := True;
              pPoolData.FLockedDt := now;
              Result := pPoolData.FPooledConn;


              if not Result.Connected then
                Result.Connect;


              try
                pPoolData.FPooledConn.ExecuteDirect('SELECT 1');
              except
                on e: Exception do
                begin
                  TConnectionpool.Log(e.message);
                  Sleep(1000);
                  pPoolData.FPooledConn.Connected := False;
                  pPoolData.FPooledConn.Connected := True;
                end;
              end;

              Break;
            end;
          end;

      finally
        self.FThreadlist.UnlockList;
      end;

  except
    on e: Exception do
      raise Exception.Create('No more free connections / server down ?');
  end;
end;

// TODO: viia kahendpuu peale siis päringud kiiremad !
procedure TConnectionpool.ReleaseConnection(const pUsedConn: TZConnection);
var
  pPoolData: TPoolData;
  i: integer;
begin
  // @@
  with self.FThreadlist.LockList do
    try
      for i := 0 to Count - 1 do
      begin
        pPoolData := TPoolData(Items[i]);
        if pPoolData.FPooledConn = pUsedConn then
        begin
          pPoolData.FLockedDt := now - 1;
          pPoolData.FLocked := False;
          // ei tohiks sellist olukord tekkida; teeme commiti defauldina ? või teha raise exception ?
          if pUsedConn.InTransaction then
            try
              TConnectionpool.Log('Transaction is open !');
              pUsedConn.Commit;
            except
              on e: Exception do
                TConnectionpool.Log(e.message);
            end;

          Break;
        end;
      end;
    finally
      self.FThreadlist.UnlockList;
    end;
end;

procedure TConnectionpool.StartPool;
var
  i: integer;
  pconnobj: TZConnection;
begin
  // @@
  with self.FThreadlist.LockList do
    try

      for i := 0 to Count - 1 do
      begin
        pconnobj := TPoolData(Items[i]).FPooledConn;
        if not TPoolData(Items[i]).FBadConnection and assigned(pconnobj) then
        begin
          pconnobj.HostName := self.FHost;
          pconnobj.Database := self.FDatabase;
          pconnobj.User := self.FLogin;
          pconnobj.Password := self.FPassword;
          pconnobj.Port := self.FPort;
          pconnobj.Connect;
        end;

      end;

    finally
      self.FThreadlist.UnlockList;
    end;
end;

constructor TConnectionpool.Create(const pHost: AStr; const pPort: integer; const pUsername: AStr; const pPassword: AStr;
  const pDatabase: AStr = estbk_types.CProjectDatabaseNameDef; const pPoolSize: integer = CMaxPoolObj);




begin
  inherited Create;
  FThreadlist := TThreadList.Create;
  FHost := pHost;
  FPort := pPort;
  if FPort < 1 then
    FPort := 5432;

  FLogin := pUsername;
  FPassword := pPassword;
  FDatabase := pDatabase;
  createPoolObj(pPoolSize);
end;

procedure TConnectionpool.createPoolObj(const pPoolItemCnt: integer = CMaxPoolObj);
var
  i: integer;
  pPoolData: TPoolData;
begin
  self.cleanupConnObjects;
  with self.FThreadlist.LockList do
    try

      for i := 1 to pPoolItemCnt do
      begin
        pPoolData := TPoolData.Create;
        Add(pPoolData);

        pPoolData.FLocked := False;
        pPoolData.FLockedDt := now;
        pPoolData.FPooledConn.User := self.FLogin;
        pPoolData.FPooledConn.Password := self.FPassword;
        pPoolData.FPooledConn.HostName := self.FHost;
        pPoolData.FPooledConn.Port := self.FPort;
        pPoolData.FPooledConn.Database := self.FDatabase;
      end;

    finally
      self.FThreadlist.UnlockList;
    end;
end;

procedure TConnectionpool.cleanupConnObjects;
var
  i: integer;
begin
  with self.FThreadlist.LockList do
    try

      for i := 0 to Count - 1 do
        if Assigned(Items[i]) then
        begin
          TPoolData(Items[i]).Free;
          Items[i] := nil;
        end;

      Clear;
    finally
      self.FThreadlist.UnlockList;
    end;
end;

destructor TConnectionpool.Destroy();
begin
  FTerminate := True;
  cleanupConnObjects;
  FThreadlist.Free;
  inherited Destroy;
end;

end.
