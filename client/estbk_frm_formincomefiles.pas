unit estbk_frm_formincomefiles;

{$mode objfpc}
{$H+}
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, estbk_types, estbk_strmsg, estbk_clientdatamodule,
  estbk_lib_commoncls, ZDataset, estbk_frm_template;

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
  public
    function showmodal(var pFilename: AStr; var pBankId: integer; var pBankLCode: AStr): boolean;
      reintroduce;
  end;

var
  formSelectIncomeFiles: TformSelectIncomeFiles;

implementation

uses estbk_uivisualinit, estbk_sqlclientcollection, estbk_globvars;

procedure TformSelectIncomeFiles.FormCreate(Sender: TObject);
begin
  estbk_uivisualinit.__preparevisual(self);
  cmbBankList.ItemIndex := 0;
end;

procedure TformSelectIncomeFiles.cmbBankListKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TformSelectIncomeFiles.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TformSelectIncomeFiles.btnOkClick(Sender: TObject);
var
  pFilename: AStr;
begin

  pFilename := trim(edtFilename.Text);
  if pFilename = '' then
  begin
    Dialogs.MessageDlg(estbk_strmsg.SEFileNameIsMissing, mtError, [mbOK], 0);
    edtFilename.SetFocus;
    exit;
  end; // ---

  if not fileexists(pFilename) then
  begin
    Dialogs.MessageDlg(format(estbk_strmsg.SEFileNotFound, [pFilename]), mtError, [mbOK], 0);
    edtFilename.SetFocus;
    exit;
  end; // ---


  if cmbBankList.ItemIndex <= 0 then
  begin
    Dialogs.MessageDlg(estbk_strmsg.SEIncfBankNotChoosen, mtError, [mbOK], 0);
    cmbBankList.SetFocus;
    exit;
  end; // ---

  self.ModalResult := mrOk;
end;

procedure TformSelectIncomeFiles.btnSelectFileClick(Sender: TObject);
begin
  if pBankFile.Execute and (pBankFile.Files.Count > 0) then
  begin
    edtFilename.Text := pBankFile.Files.Strings[0];
  end;
end;

function TformSelectIncomeFiles.showmodal(var pFilename: AStr; var pBankId: integer;
  var pBankLCode: AStr): boolean;
var
  pDescr: estbk_lib_commoncls.TIntIDAndCTypes;
  pBankCode: AStr;
  i: integer;
begin
  cmbBankList.Clear;

  pFilename := '';
  pBankId := 0;
  pBankLCode := '';

  // ---
  with qryBanks, SQL do
    try

      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectBanksEx);
      parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      First;
      // ---

      cmbBankList.ItemIndex := cmbBankList.Items.AddObject(estbk_strmsg.SUnDefComboChoise, nil);

      while not EOF do
      begin
        pBankCode := trim(FieldByName('lcode').AsString);
        if pBankCode = '' then
          pBankCode := trim(FieldByName('swift').AsString)
        else
          pBankCode := pBankCode + '|' + trim(FieldByName('swift').AsString);


        if pBankCode <> '' then
        begin
          pDescr := estbk_lib_commoncls.TIntIDAndCTypes.Create;
          pDescr.id := FieldByName('id').AsInteger;
          pDescr.clf := pBankCode;

          // ---
          cmbBankList.Items.AddObject(FieldByName('bankname').AsString, pDescr);
          Next;
        end;
      end;
    finally
      Close;
      Clear;
    end; // --


  Result := inherited showmodal = mrOk;
  if Result then
  begin
    pFilename := edtFilename.Text;
    if cmbBankList.ItemIndex > 0 then
      with TIntIDAndCTypes(cmbBankList.Items.Objects[cmbBankList.ItemIndex]) do
      begin
        pBankId := id;
        pBankLCode := clf;
      end;
  end;


  // ---
  for i := 0 to cmbBankList.Items.Count - 1 do
    if assigned(cmbBankList.Items.Objects[i]) then
    begin
      cmbBankList.Items.Objects[i].Free;
      cmbBankList.Items.Objects[i] := nil;
    end;

  cmbBankList.Clear;


end;

initialization
  {$I estbk_frm_formincomefiles.ctrs}

end.
