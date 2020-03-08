unit estbk_frm_accperfinalize;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  DateUtils, rxlookup, ExtCtrls, StdCtrls, EditBtn, Buttons, estbk_uivisualinit,
  estbk_acc_perfinalize, estbk_utilities, estbk_clientdatamodule,
  estbk_globvars, estbk_sqlclientcollection, estbk_types, estbk_strmsg, estbk_frm_template,
  ZDataset, db;

type

  { TformAccPerFinalize }

  TformAccPerFinalize = class(TfrmTemplate)
    Bevel1: TBevel;
    btnGenerate: TBitBtn;
    btnClose: TBitBtn;
    qryAccountsDs: TDatasource;
    dtAccDate: TDateEdit;
    dtBalStart: TDateEdit;
    dtBalEnd: TDateEdit;
    Label1: TLabel;
    lblAccDate: TLabel;
    lblBalDate: TLabel;
    lblPAccs: TLabel;
    rxLookup: TRxDBLookupCombo;
    qryAccounts: TZReadOnlyQuery;
    procedure btnGenerateClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure dtAccDateExit(Sender: TObject);
    procedure dtAccDateKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure fillDateTimeEdt;
  public
    class procedure showAndCreate;
  end; 

var
  formAccPerFinalize: TformAccPerFinalize;

implementation

class procedure TformAccPerFinalize.showAndCreate;
begin
  with self.Create(nil) do
       showmodal;
end;

{ TformAccPerFinalize }
procedure TformAccPerFinalize.fillDateTimeEdt;
var
  b : Boolean;
  pPerStart : TDatetime;
  pPerEnd   : TDatetime;
begin
  with estbk_clientdatamodule.dmodule.tempQuery,SQL do
  try
     b:=ParamCheck;
     ParamCheck:=true;
     close;
     clear;
     add(estbk_sqlclientcollection._SQLPrevAccPeriods);
     paramByname('company_id').AsInteger:=estbk_globvars.glob_company_id;
     open;
  if eof then
    begin
       pPerEnd:=now;
       pPerStart:=dateutils.StartOfAYear(YearOf(pPerEnd));
    end else
    begin
       pPerStart:=fieldByname('period_start').AsDateTime;
    if fieldByname('period_end').IsNull then
       pPerEnd:=dateutils.EndOfAYear(YearOf(pPerStart))
    else
       pPerEnd:=fieldByname('period_end').AsDateTime;
    end;
    // ---
    dtBalStart.Date:=pPerStart;
    dtBalStart.Text:=datetostr(pPerStart);

    dtBalEnd.Date:=pPerEnd;
    dtBalEnd.Text:=datetostr(pPerEnd);


    dtAccDate.Date:=pPerEnd;
    dtAccDate.Text:=datetostr(pPerEnd);

  finally
    close;
    clear;
    ParamCheck:=b;

  end;

end;

procedure TformAccPerFinalize.FormCreate(Sender: TObject);
begin
  estbk_uivisualinit.__preparevisual(self);
  self.fillDateTimeEdt();
  qryAccounts.Close;
  qryAccounts.SQL.Clear;
  qryAccounts.SQL.Text:=estbk_sqlclientcollection._CSQLGetAllAccounts;
  qryAccounts.paramByname('company_id').AsInteger:=estbk_globvars.glob_company_id;
  qryAccounts.Open;
  // PS see vaid hetke lahendus, tulevikus tee konfitavaks !!!!!!!!!!!!!!!!!!!!!!
  // me oletame, et tegemist vaid vaikimisi kontoplaaniga
  qryAccounts.Locate('account_coding','22270',[]);
  rxLookup.Value:=inttostr(qryAccounts.FieldByName('id').AsInteger);

end;

procedure TformAccPerFinalize.dtAccDateKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
      begin
          SelectNext(Sender as twincontrol, True, True);
          key := #0;
      end
end;

procedure TformAccPerFinalize.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TformAccPerFinalize.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TformAccPerFinalize.dtAccDateExit(Sender: TObject);
var
  cval : TDatetime;
  pStr : AStr;
begin
  cval:=now;
  pStr:=trim(TEdit(Sender).Text);
  if pStr<>'' then
  begin
    if not estbk_utilities.validateMiscDateEntry(pStr,cval) then
    begin
      dialogs.messageDlg(estbk_strmsg.SEInvalidDate,mterror,[mbOk],0);
      if TEdit(Sender).CanFocus then
        TEdit(Sender).SetFocus;
      Exit;
    end
    else
      TEdit(Sender).Text:=datetostr(cval);
  end;
end;

procedure TformAccPerFinalize.btnGenerateClick(Sender: TObject);
var
  pAccNrs : AStr;
  pExistsAccRec : Integer;
  b : Boolean;
  pPcAccID : Integer; // kasumi / kahjumi konto !
begin
  // ---
  if (dtBalStart.Text='') or (dtBalEnd.Text='') or (dtBalStart.Date>dtBalEnd.Date) then
  begin
    dialogs.MessageDlg(estbk_strmsg.SEInvalidDate,mtError,[mbOk],0);
    if dtBalStart.CanFocus then
      dtBalStart.SetFocus;
    Exit;
  end;

  pAccNrs:='';
  pExistsAccRec:=0;
  // pPcAccID:=585;
  pPcAccID:=qryAccounts.FieldByName('id').AsInteger;
  Assert(pPcAccID>0,'#1');
  try
    b:=estbk_acc_perfinalize._generateAccFinalizatingRec(pPcAccID,dtAccDate.Date,dtBalStart.Date,dtBalEnd.Date,pAccNrs,pExistsAccRec);
    // vahemikus juba kanne olemas !
    if not b and (pAccNrs<>'') then
     if dialogs.MessageDlg(format(estbk_strmsg.SEAccSGrpRecAlreadyExists,[pAccNrs]),mtConfirmation,[mbYes,mbNo],0)=mrYes then
     begin
       pExistsAccRec:=99999999;
       b:=estbk_acc_perfinalize._generateAccFinalizatingRec(pPcAccID,dtAccDate.Date,dtBalStart.Date,dtBalEnd.Date,pAccNrs,pExistsAccRec);
     end
     else
     b:=estbk_acc_perfinalize._generateAccFinalizatingRec(pPcAccID,dtAccDate.Date,dtBalStart.Date,dtBalEnd.Date,pAccNrs,pExistsAccRec);

    if b then
      Dialogs.MessageDlg(estbk_strmsg.SCommDone,mtinformation,[mbOk],0)
    else
      Dialogs.MessageDlg(estbk_strmsg.SCommFailed,mtinformation,[mbOk],0);
      estbk_utilities.changeWCtrlEnabledStatus(self,false);
      Self.Enabled:=true;
  except
    on E : exception do
      dialogs.MessageDlg(format(estbk_strmsg.SESaveFailed,[e.message]),mtError,[mbOk],0);
  end;
end;

initialization
  {$I estbk_frm_accperfinalize.ctrs}

end.

