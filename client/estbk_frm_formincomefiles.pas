unit estbk_frm_formincomefiles;

{$mode objfpc}
{$H+}
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons,estbk_types,estbk_strmsg,estbk_clientdatamodule,
  estbk_lib_commoncls, ZDataset,estbk_frm_template;

type

  { TformSelectIncomeFiles }

  TformSelectIncomeFiles = class(TfrmTemplate)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    btnSelectFile: TBitBtn;
    cmbBankList: TComboBox;
    edtFilename: TEdit;
    GroupBox1: TGroupBox;
    lblBank: TLabel;
    lblFilename: TLabel;
    pBankFile: TOpenDialog;
    qryBanks: TZQuery;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnSelectFileClick(Sender: TObject);
    procedure cmbBankListKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    function showmodal(var pFilename : AStr;
                       var pBankId   : Integer;
                       var pBankLCode : AStr):Boolean;reintroduce;
  end; 

var
  formSelectIncomeFiles: TformSelectIncomeFiles;

implementation
uses estbk_uivisualinit,estbk_sqlclientcollection,estbk_globvars;

procedure TformSelectIncomeFiles.FormCreate(Sender: TObject);
begin
   estbk_uivisualinit.__preparevisual(self);
   cmbBankList.ItemIndex:=0;
end;

procedure TformSelectIncomeFiles.cmbBankListKeyPress(Sender: TObject;
  var Key: char);
begin
 if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TformSelectIncomeFiles.btnCancelClick(Sender: TObject);
begin
  self.ModalResult:=mrCancel;
end;

procedure TformSelectIncomeFiles.btnOkClick(Sender: TObject);
var
  pFilename : AStr;
begin

    pFilename:=trim(edtFilename.Text);
 if pFilename='' then
   begin
    dialogs.MessageDlg(estbk_strmsg.SEFileNameIsMissing,mtError,[mbOk],0);
    edtFilename.SetFocus;
    exit;
   end; // ---

 if not fileexists(pFilename) then
   begin
    dialogs.MessageDlg(format(estbk_strmsg.SEFileNotFound,[pFilename]),mtError,[mbOk],0);
    edtFilename.SetFocus;
    exit;
   end; // ---


 if cmbBankList.ItemIndex<=0 then
   begin
    dialogs.MessageDlg(estbk_strmsg.SEIncfBankNotChoosen,mtError,[mbOk],0);
    cmbBankList.SetFocus;
    exit;
   end; // ---

   self.ModalResult:=mrOk;
end;

procedure TformSelectIncomeFiles.btnSelectFileClick(Sender: TObject);
begin
 if pBankFile.Execute and (pBankFile.Files.Count>0) then
   begin
    edtFilename.Text:=pBankFile.Files.Strings[0];
   end;
end;

function  TformSelectIncomeFiles.showmodal(var pFilename : AStr;
                                           var pBankId   : Integer;
                                           var pBankLCode : AStr):Boolean;
var
  pDescr    : estbk_lib_commoncls.TIntIDAndCTypes;
  pBankCode : AStr;
  i : Integer;
begin
     cmbBankList.Clear;

     pFilename:='';
     pBankId:=0;
     pBankLCode:='';

     // ---
with qryBanks,SQL do
 try

       close;
       clear;
       add(estbk_sqlclientcollection._SQLSelectBanksEx);
       parambyname('company_id').asInteger:=estbk_globvars.glob_company_id;
       open;
       first;
       // ---

       cmbBankList.ItemIndex:=cmbBankList.Items.AddObject(estbk_strmsg.SUnDefComboChoise,nil);

 while not eof do
   begin
       pBankCode:=trim(fieldByname('lcode').asString);
    if pBankCode='' then
       pBankCode:=trim(fieldByname('swift').asString)
    else
       pBankCode:=pBankCode+'|'+trim(fieldByname('swift').asString);


    if pBankCode<>'' then
      begin
        pDescr:=estbk_lib_commoncls.TIntIDAndCTypes.Create;
        pDescr.id:=fieldByname('id').asInteger;
        pDescr.clf:=pBankCode;

        // ---
        cmbBankList.Items.AddObject(fieldByname('bankname').asString,pDescr);
        next;
      end;
   end;
 finally
      close;
      clear;
 end; // --


     result:=inherited showmodal=mrOk;
  if result then
    begin
         pFilename:=edtFilename.Text;
    if   cmbBankList.ItemIndex>0 then
    with TIntIDAndCTypes(cmbBankList.Items.Objects[cmbBankList.ItemIndex]) do
      begin
         pBankId:=id;
         pBankLCode:=clf;
      end;
    end;


  // ---
 for i:=0 to cmbBankList.Items.Count-1 do
 if  assigned(cmbBankList.Items.Objects[i]) then
   begin
     cmbBankList.Items.Objects[i].Free;
     cmbBankList.Items.Objects[i]:=nil;
   end;

      cmbBankList.Clear;
end;

initialization
  {$I estbk_frm_formincomefiles.ctrs}

end.

