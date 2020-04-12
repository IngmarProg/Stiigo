unit estbk_lib_asyncload;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, estbk_types
  {$IFDEF FINLAND}, estbk_http, estbk_lib_fin_sampo{$ENDIF};

type
  TOnAsyncLoadExec = procedure() of object;

type
  TAsyncLoadBase = class(TThread)
  protected
    FData: cardinal;
    FDelay: integer;
    FWorking: boolean;
    FError: AStr;
    FOnAsyncLoadExec: TOnAsyncLoadExec;
    procedure Task; virtual;
    procedure Execute; override;
  public
    property Error: AStr read FError write FError;
    property Working: boolean read FWorking;
    constructor Create(const pOnAsyncLoadExec: TOnAsyncLoadExec; const pSuspended: boolean = True; const pDelay: integer = 0;
      const Data: cardinal = 0); virtual;
    destructor Destroy; override;
  end;

  {$IFDEF FINLAND}
  TAsyncLoadGetBalance = class(TAsyncLoadBase)
  protected
    FURL: AStr;
    FCurrenctBalance: double;
    procedure Task; override;
  public
    property CurrenctBalance: double read FCurrenctBalance write FCurrenctBalance;
    constructor Create(const pBalanceURL: AStr; const pOnAsyncLoadExec: TOnAsyncLoadExec; const pSuspended: boolean = True;
      const pDelay: integer = 0; const Data: cardinal = 0); reintroduce;
  end;

  TAsyncSendSepaFile = class(TAsyncLoadBase)
  protected
    FPostURL: AStr;
    FPostFile: AStr;
    FStatus: AStr;
    FPaymentData: AStr;
    procedure Task; override;
  public
    property Status: AStr read FStatus;
    property PaymentData: AStr read FPaymentData;
    constructor Create(const pPostURL: AStr; const pPostFile: AStr; const pPaymentData: AStr;
      const pOnAsyncLoadExec: TOnAsyncLoadExec; const pSuspended: boolean = True); reintroduce;
  end;

  {$ENDIF}

implementation

uses DateUtils, LclIntf;

procedure TAsyncLoadBase.Task;
begin
  // dummy
end;

constructor TAsyncLoadBase.Create(const pOnAsyncLoadExec: TOnAsyncLoadExec; const pSuspended: boolean = True;
  const pDelay: integer = 0; const Data: cardinal = 0);
begin
  inherited Create(pSuspended);
  FOnAsyncLoadExec := pOnAsyncLoadExec;
  FDelay := pDelay;
  FData := Data;
end;

procedure TAsyncLoadBase.Execute;
var
  pstart, pend: DWord;
begin
  try
    FWorking := True;

    pstart := LclIntf.GetTickCount;
    pend := pstart + FDelay;
    while pstart <= pend do
    begin
      pstart := LclIntf.GetTickCount;
      sleep(5);
    end;

    Self.Task;

    if Assigned(FOnAsyncLoadExec) then
      Self.Synchronize(FOnAsyncLoadExec);

  finally
    FWorking := False;
  end;
end;

destructor TAsyncLoadBase.Destroy;
begin
  inherited Destroy;
end;

{$IFDEF FINLAND}

constructor TAsyncLoadGetBalance.Create(const pBalanceURL: AStr; const pOnAsyncLoadExec: TOnAsyncLoadExec;
  const pSuspended: boolean = True; const pDelay: integer = 0; const Data: cardinal = 0);
begin
  inherited Create(pOnAsyncLoadExec, pSuspended, pDelay, Data);
  FURL := pBalanceURL;
end;

procedure TAsyncLoadGetBalance.Task;
var
  pStr: TStringStream;
begin
  FCurrenctBalance := 0.00;
  try
    try
      pStr := TStringStream.Create('');
      estbk_http.downloadDatatoStream(FURL, pStr);
      pStr.Seek(0, 0);

      FCurrenctBalance := estbk_lib_fin_sampo.fin_parseBalance(pStr);
    finally
      FreeAndNil(pStr);
    end;

  except
    on e: Exception do
      FError := e.Message;
  end;
end;

constructor TAsyncSendSepaFile.Create(const pPostURL: AStr; const pPostFile: AStr; const pPaymentData: AStr;
  const pOnAsyncLoadExec: TOnAsyncLoadExec; const pSuspended: boolean = True);
begin
  inherited Create(pOnAsyncLoadExec, pSuspended, 0, 0);
  FPostURL := pPostURL;
  FPostFile := pPostFile;
  FPaymentData := ppaymentData;
end;

procedure TAsyncSendSepaFile.Task;
var
  pRez, pCommStatus, pData, pMessage: AStr;
  pStr: TStringStream;
begin
  try
    FStatus := '';
    FError := '';
    pStr := nil;
    pRez := estbk_http.uploadFile(self.FPostURL, self.FPostFile);
    try
      pStr := TStringStream.Create(pRez);
      pStr.Seek(0, 0);
      fin_parseCommonResp(pStr, pCommStatus, pData, pMessage);
      self.FStatus := pCommStatus;
    finally
      pStr.Free;
    end;
  except
    on e: Exception do
      FError := e.Message;
  end;
end;


{$ENDIF}

end.