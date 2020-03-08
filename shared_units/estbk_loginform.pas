unit estbk_loginform;


{$mode objfpc}{$H+}
{$I C:\Projektid\Stiigo\client\estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, IniFiles, estbk_Types, ZConnection;

const
     CDefaultHeight =  195; // 156
     CFullHeight = 369;

type

  { Tform_login }

  Tform_login = class(TForm)
    Bevel1: TBevel;
    btn_exit: TBitBtn;
    btn_login: TBitBtn;
    extConf: TCheckBox;
    edtServerAddr: TLabeledEdit;
    edtServerPort: TLabeledEdit;
    edt_username: TLabeledEdit;
    edt_password: TLabeledEdit;
    panel_login: TPanel;
    procedure btn_exitClick(Sender: TObject);
    procedure edtServerPortKeyPress(Sender: TObject; var Key: char);
    procedure edt_usernameKeyPress(Sender: TObject; var Key: char);
    procedure extConfClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
  end;




function loginDialog(out pUsername: AStr; out pPassword: AStr; out pHostname: AStr; out pDefaultPort: integer): boolean;

implementation

uses estbk_utilities, estbk_dbcompability{$ifdef autofind_test_server_ip}, idHttp{$endif};
// -----
{$ifdef autofind_test_server_ip}
procedure _getTestServerIpAndPort(var pIP: AStr; var pPort: integer);
var
  p: TIdHttp;
  s: TAStrList;

begin
  try
    p := TIdHttp.Create(nil);
    s := TAStrList.Create;
    s.Delimiter := #$0D;
    s.DelimitedText := p.Get('http://ingmar.planet.ee/ip.txt');
    pIP := 'localhost';
    pPort := 5432;
    if s.Count >= 2 then
    begin
      pIP := trim(s.Strings[0]);
      pPort := strtointdef(s.Strings[1], 5432);
    end;

  finally
    p.Free;
    s.Free;
  end;
end;

{$endif}


function loginDialog(out pUsername: AStr; out pPassword: AStr; out pHostname: AStr; out pDefaultPort: integer): boolean;
const
  SCSimpleXorKey = #93#17#14#186;
  SCLogin = 'login';

var
  FloginForm: Tform_login;
  FDefHost: AStr;
  FTmpCr: AStr;
  FTmpPort: integer;
  FLogparams: IniFiles.TIniFile;
  {$ifdef autofind_test_server_ip}
  pTmp1: AStr;
  pTmp2: integer;
  {$endif}
begin
  Result := False;

  FDefHost := '';
  pUsername := '';
  pPassword := '';
  pHostname := '';
  pDefaultPort := 0;
  // ---

  try
    FloginForm := Tform_login.Create(nil);
    // -- täiest reaalse ntx windows7 ei luba kirjutada faili !
    try
      FLogparams := nil;

      FTmpCr := GetAppConfigDir(True);
      if not DirectoryExists(FTmpCr) then
        ForceDirectories(FTmpCr);

      FLogparams := IniFiles.TIniFile.Create(FTmpCr + estbk_types.CLoginDialogIniFileName);
    except
      FreeAndNil(FLogparams);
    end;




    // ---
    FTmpPort := 0;
    estbk_dbcompability.sqlp.getCurrentBackEndDefaultServerAndPort(FDefHost, pDefaultPort);


    FloginForm.edt_username.Text := '';
    FloginForm.edtServerAddr.Text := '';
    FloginForm.edtServerPort.Text := '0';


    // -- !
    if assigned(FLogparams) then
    begin

      FloginForm.edt_username.Text := rxXorDecode(SCSimpleXorKey, FLogparams.ReadString(SCLogin, 'log_usrname', ''));
      // if (FloginForm.edt_username.text<>'') and (FloginForm.edt_password.CanFocus) then
      //     FloginForm.edt_password.setFocus;


      FloginForm.edtServerAddr.Text := rxXorDecode(SCSimpleXorKey, FLogparams.ReadString(SCLogin, 'log_srvname', ''));
      FTmpPort := strtointdef(FLogparams.ReadString(SCLogin, 'log_srvport', ''), 0);
      if FTmpPort > 0 then
        pDefaultPort := FTmpPort;

      FloginForm.edtServerPort.Text := IntToStr(pDefaultPort);
    end;



    // VAID TESTIMISE ajal !
      {$ifdef autofind_test_server_ip}
    _getTestServerIpAndPort(pTmp1, pTmp2);
    FloginForm.edtServerAddr.Text := pTmp1;
    FloginForm.edtServerPort.Text := IntToStr(pTmp2);
      {$endif}


    Result := (FloginForm.showmodal = mrOk);

    // -- !
    if assigned(FLogparams) then
    begin
      FLogparams.WriteString(SCLogin, 'log_usrname', rxXorEncode(SCSimpleXorKey, FloginForm.edt_username.Text));
      FLogparams.WriteString(SCLogin, 'log_srvname', rxXorEncode(SCSimpleXorKey, FloginForm.edtServerAddr.Text));
      FLogparams.WriteString(SCLogin, 'log_srvport', FloginForm.edtServerPort.Text);
    end;
    // -----


    if Result then
      with FloginForm do
      begin

        pUsername := edt_username.Text;
        pPassword := edt_password.Text;
        pHostname := trim(edtServerAddr.Text);

        if pHostname = '' then
          pHostname := FDefHost;

        pDefaultPort := StrToIntDef(trim(edtServerPort.Text), -1);
        if pDefaultPort <= 0 then
          pDefaultPort := FTmpPort;
      end;

    // ----
  finally
    FreeAndNil(FloginForm);

    if assigned(FLogparams) then
      FreeAndNil(FLogparams);
  end;
end;

procedure Tform_login.edtServerPortKeyPress(Sender: TObject; var Key: char);
begin
  if not estbk_utilities.allowCharForNumericInp(key) then
    key := #0;
end;

procedure Tform_login.btn_exitClick(Sender: TObject);
begin
end;

procedure Tform_login.edt_usernameKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    key := #0;
  end;
end;

procedure Tform_login.extConfClick(Sender: TObject);
begin
  case TCheckbox(Sender).Checked of
    True: self.Height := CFullHeight;
    False: self.Height := CDefaultHeight;
  end;
end;

procedure Tform_login.FormCreate(Sender: TObject);
begin
  self.Height := CDefaultHeight;
  forceFirstDisplay(Self);
end;

procedure Tform_login.FormShow(Sender: TObject);
begin
  if (self.edt_username.Text <> '') and (self.edt_password.CanFocus) then
    self.edt_password.SetFocus;
end;



initialization
  {$I estbk_loginform.ctrs}
end.