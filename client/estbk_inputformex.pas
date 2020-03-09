unit estbk_inputformex;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, estbk_types, LCLType, LCLIntf, LCLProc, Buttons;

type

  { TinputExForm }

  TinputExForm = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    cmbChooseItem: TComboBox;
    edtNewItemname: TEdit;
    grpIBox: TGroupBox;
    lblItemname: TLabel;
    procedure edtNewItemnameChange(Sender: TObject);
  private
    { private declarations }
  public
    function showmodal(const pMiscDescr: AStr; var pNewValue: AStr): boolean; overload; reintroduce; // TEDIT
    function showmodal(const pMiscDescr: AStr; const pComboItems: TAStrList; var pSelectedId: integer): boolean; overload; reintroduce; // TCOMBO
  end;

// ----
function inputFormEx(const descr: AStr; var Value: AStr): boolean;
function inputFormEx2(const descr: AStr; const items: TAStrList; var id: integer): boolean;
// ----
implementation

function inputFormEx(const descr: AStr; var Value: AStr): boolean;
begin
  with TinputExForm.Create(nil) do
    try
      Result := showmodal(descr, Value);
    finally
      Free;
    end;
end;


function inputFormEx2(const descr: AStr; const items: TAStrList; var id: integer): boolean;
begin
  with TinputExForm.Create(nil) do
    try
      Result := showmodal(descr, items, id);
    finally
      Free;
    end;
end;

procedure TinputExForm.edtNewItemnameChange(Sender: TObject);
begin
  btnOk.Enabled := trim(TEdit(Sender).Text) <> '';
end;

function TinputExForm.showmodal(const pMiscDescr: AStr; var pNewValue: AStr): boolean;
begin
  cmbChooseItem.Visible := False;
  edtNewItemname.Visible := True;

  lblItemname.Caption := pMiscDescr;
  edtNewItemname.Text := pNewValue;

  btnOk.Enabled := trim(pNewValue) <> '';
  Result := inherited showmodal = mrOk;
  if Result then
    pNewValue := trim(edtNewItemname.Text);
end;

function TinputExForm.showmodal(const pMiscDescr: AStr; const pComboItems: TAStrList; var pSelectedId: integer): boolean;
begin
  pSelectedId := 0;
  cmbChooseItem.Visible := True;
  edtNewItemname.Visible := False;

  lblItemname.Caption := pMiscDescr;
  cmbChooseItem.Items.Assign(pComboItems);

  btnOk.Enabled := cmbChooseItem.Items.Count > 0;
  if cmbChooseItem.Items.Count > 0 then
    cmbChooseItem.ItemIndex := 0; // märgistame ära esimese valiku, tulevikus jätame meelde viimase firma ja pakume uuesti seda !

  Result := (inherited showmodal = mrOk) and (cmbChooseItem.ItemIndex >= 0);
  if Result then
    pSelectedId := PtrInt(cmbChooseItem.Items.Objects[cmbChooseItem.ItemIndex]);
end;

initialization
  {$I estbk_inputformex.ctrs}

end.
