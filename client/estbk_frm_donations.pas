unit estbk_frm_donations;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, estbk_uivisualinit, estbk_strmsg,estbk_frm_template,
  estbk_utilities, estbk_types, DCPblowfish, idHttp;

type

  { TformDonation }

  TformDonation = class(TfrmTemplate)
    Bevel1: TBevel;
    btnClose: TBitBtn;
    btnSupport: TBitBtn;
    edtContactPerson: TEdit;
    edtCompName: TEdit;
    edtCompEmail: TEdit;
    edtDonSum: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mDescr: TMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure btnSupportClick(Sender: TObject);
    procedure edtCompNameKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  private
    function __crypt_data(const pData : AStr; const pKey : AStr; const pCryptData : Boolean = true):AStr;
  public
    { public declarations }
  end; 

var
  formDonation: TformDonation;

implementation
uses DCPrijndael, DCPsha256;

function TformDonation.__crypt_data(const pData : AStr; const pKey : AStr; const pCryptData : Boolean = true):AStr;
var
  S1, S2: String;
  c: TDCP_rijndael;
begin
  c := TDCP_rijndael.Create(nil);
  try
    c.InitStr(pKey, TDCP_sha256);
 if pCryptData then
    result:=c.EncryptString(pData)
 else
    result:=c.DecryptString(pData);
    //S1 := c.DecryptString(SomeEncryptedVariable);
    c.Reset;
    //S2 := c.DecryptString(SomeEncryptedVariable);
  finally
    c.Free;
  end;
end;
{ TformDonation }

procedure TformDonation.btnSupportClick(Sender: TObject);
procedure _edialogs(const pHasData : Boolean; const pIndex : Byte);
begin
   if not pHasData then
   begin
     case pIndex of
      1: dialogs.MessageDlg(estbk_strmsg.SEDonCompanyNameIsMissing,mterror,[mbOk],0);
      2: dialogs.MessageDlg(estbk_strmsg.SEDonCompanyEmailIsMissing,mterror,[mbOk],0);
      3: dialogs.MessageDlg(estbk_strmsg.SEDonCompanyCstPersonIsMissing,mterror,[mbOk],0);
      4: dialogs.MessageDlg(estbk_strmsg.SEDonSum,mterror,[mbOk],0);
     end;

     sysutils.Abort;
   end;

end;
const
  CDonSupportAddr = 'http://www.stiigo.com/donation.php';
var
  pCompName  : AStr;
  pCompEmail : AStr;
  pCompCPerson : AStr;
  pCompDonSum  : AStr;
  pDonSum : Double;
  pRespStr: AStr;
  pHttp   : TIdHttp;
  pData   : TStringStream;
  pCConcat: AStr;
begin
     pDonSum:=0.00;
     pCompName:=trim(edtCompName.Text);
     _edialogs(pCompName<>'',1);

     pCompEmail:=trim(edtCompEmail.Text);
     _edialogs(pCompEmail<>'',2);

     pCompCPerson:=trim(edtContactPerson.Text);
     _edialogs(pCompCPerson<>'',3);

     pCompDonSum:=trim(edtDonSum.Text);
     _edialogs(pCompDonSum<>'',4);
     pDonSum:=strtofloatdef(pCompDonSum,0.00);
     _edialogs(pDonSum>=6.00,4);

     // --
 try
   try
       pHttp:=TIdHttp.Create(nil);
       pCConcat:=pCompName+'||'+pCompEmail+'||'+pCompCPerson+'||'+floattostr(pDonSum)+'||';
       pCConcat:=pCConcat+inttohex(length(pCConcat),8)+'||'+stringofchar('x',random(1024));
       pData:=TStringStream.Create(__crypt_data(pCConcat,estbk_utilities._donationReqDataKey()));
       pData.Seek(0,0);


       pRespStr:=pHttp.Post(CDonSupportAddr,pData);
    if pos('ERR:',pRespStr)>0 then
       raise exception.Create(pRespStr);

   finally
       freeAndNil(pData);
       freeAndNil(pHttp);
   end;
 except on e : exception do
  begin
    dialogs.MessageDlg('Error: '+e.Message,mtError,[mbOk],0);
    Exit; // ---
  end;
 end;

     dialogs.MessageDlg(estbk_strmsg.SCDonFinalMsg,mtConfirmation,[mbOk],0);
  if btnClose.CanFocus then
     btnClose.SetFocus;
end;

procedure TformDonation.edtCompNameKeyPress(Sender: TObject; var Key: char);
begin
 if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end else
  if Sender = self.edtDonSum then
  begin
    estbk_utilities.edit_verifyNumericEntry(Sender as TCustomEdit,key,false);
  end;
end;

procedure TformDonation.FormCreate(Sender: TObject);
begin
   estbk_uivisualinit.__preparevisual(self);
end;

procedure TformDonation.btnCloseClick(Sender: TObject);
begin
   self.Close;
end;

initialization
  {$I estbk_frm_donations.ctrs}

end.

