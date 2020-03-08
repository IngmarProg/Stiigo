unit estbk_frm_choosebank;


{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,LCLType,LCLProc,
  StdCtrls, ExtCtrls, Buttons, estbk_clientdatamodule, estbk_strmsg,estbk_sqlclientcollection,
  estbk_uivisualinit,estbk_types,estbk_globvars,estbk_frm_template, ZDataset, db;

type

  { TformChooseBank }

  TformChooseBank = class(TfrmTemplate)
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    chkboxAutoChk: TCheckBox;
    cmbBankList: TComboBox;
    grp: TGroupBox;
    lblBank: TLabel;
    edtlFilename: TLabeledEdit;
    oFiles: TOpenDialog;
    openFile: TSpeedButton;
    qryBanks: TZReadOnlyQuery;
    procedure cmbBankListChange(Sender: TObject);
    procedure edtlFilenameChange(Sender: TObject);
    procedure edtlFilenameExit(Sender: TObject);
    procedure edtlFilenameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure openFileClick(Sender: TObject);
    procedure qryBanksFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end; 

// static call
function  __chooseBankFile(var pBankCode : AStr;
                           var pFilename : AStr;
                           var pMarkOkItemsAsChecked : Boolean):Boolean;


implementation
const
  CSpecialMarker = $FFFFFF;

function  __chooseBankFile(var pBankCode : AStr;
                           var pFilename : AStr;
                           var pMarkOkItemsAsChecked : Boolean):Boolean;
begin
     Result:=false;
     pBankCode:='';
     pFilename:='';
     pMarkOkItemsAsChecked:=false;
with TformChooseBank.Create(nil) do
  try
      Result:= showmodal=mrOk;
   if Result then
     begin
     // SEPA laekumised !
     if PtrInt(cmbBankList.Items.Objects[cmbBankList.ItemIndex]) = CSpecialMarker then
       begin
         pFilename := edtlFilename.Text;
         pMarkOkItemsAsChecked := chkboxAutoChk.Checked;
         pBankCode := 'SEPA';
       end else
     if qryBanks.Locate('id',PtrInt(cmbBankList.Items.Objects[cmbBankList.ItemIndex]),[]) then
       begin
         pBankCode:=qryBanks.FieldByName('lcode').AsString;
         Assert(trim(pBankCode)<>'','#1');
         pFilename:=edtlFilename.Text;
         pMarkOkItemsAsChecked:=chkboxAutoChk.Checked;
       end;
     end;

  finally
     Free;
  end;
end;



// ----------------------------------------------------------------------------

procedure TformChooseBank.FormCreate(Sender: TObject);
begin
  estbk_uivisualinit.__preparevisual(self);
  cmbBankList.Items.AddObject(estbk_strmsg.SUndefComboChoise, TObject(0));
  cmbBankList.ItemIndex:=0;

  cmbBankList.Items.AddObject(estbk_strmsg.SCSEPAFile, TObject(CSpecialMarker));

  qryBanks.Close;
  qryBanks.SQL.Clear;
  qryBanks.Connection:=dmodule.primConnection;
  qryBanks.SQL.Add(estbk_sqlclientcollection._SQLSelectBanks);
  qryBanks.ParamByName('company_id').AsInteger:=estbk_globvars.glob_company_id;
  qryBanks.Open;

  qryBanks.Filtered:=false;
  qryBanks.Filtered:=true;
  qryBanks.First;
  while not qryBanks.EOF do
  begin
    cmbBankList.Items.AddObject(qryBanks.FieldByName('bankname').AsString, TObject(PtrInt(qryBanks.FieldByName('id').AsInteger)));
    qryBanks.Next;
  end;
end;

procedure TformChooseBank.openFileClick(Sender: TObject);
begin
  // --
  if oFiles.Execute and (oFiles.Files.Count=1) then
    begin
     btnOk.Enabled:=(cmbBankList.ItemIndex>0);
     edtlFilename.Text:=oFiles.Files.Strings[0];
    end else
     btnOk.Enabled:=false;
end;

procedure TformChooseBank.qryBanksFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept:=trim(DataSet.FieldByname('lcode').AsString)<>'';
end;

procedure TformChooseBank.edtlFilenameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_RETURN) and (Shift=[ssCtrl]) then
   begin
     openFileClick(openFile);
     key:=0;
   end;
end;

procedure TformChooseBank.edtlFilenameChange(Sender: TObject);
begin
  with TLabeledEdit(Sender) do
       btnOk.Enabled:=trim(text)<>'';
end;

procedure TformChooseBank.edtlFilenameExit(Sender: TObject);
begin
   with TLabeledEdit(Sender) do
     if (trim(text)<>'') and not fileExists(text) then
         btnOk.Enabled:=false;
end;

procedure TformChooseBank.cmbBankListChange(Sender: TObject);
begin
      btnOk.Enabled:=(trim(edtlFilename.text)<>'') and (TCombobox(Sender).ItemIndex>0);
end;

initialization
  {$I estbk_frm_choosebank.ctrs}

end.

