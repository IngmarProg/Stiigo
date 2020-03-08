unit estbk_inputformex;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls,estbk_types,LCLType,LCLIntf,LCLProc, Buttons;

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
    function showmodal(const pMiscDescr: AStr; var pNewValue : AStr):Boolean;overload;reintroduce; // TEDIT
    function showmodal(const pMiscDescr: AStr; const pComboItems : TAStrList; var pSelectedId : Integer):Boolean;overload;reintroduce; // TCOMBO
  end; 

// ----
function inputFormEx(const descr : AStr; var value : AStr):Boolean;
function inputFormEx2(const descr : AStr; const items : TAStrList; var id : Integer):Boolean;
// ----
implementation

function inputFormEx(const descr : AStr; var value : AStr):Boolean;
begin
  with TinputExForm.Create(nil) do
   try
      result:=showmodal(descr,value);
   finally
      free;
   end;
end;


function inputFormEx2(const descr : AStr; const items : TAStrList; var id : Integer):Boolean;
begin
   with TinputExForm.Create(nil) do
   try
      result:=showmodal(descr,items,id);
   finally
      free;
   end;
end;

procedure TinputExForm.edtNewItemnameChange(Sender: TObject);
begin
     btnOk.Enabled:=trim(TEdit(Sender).Text)<>'';
end;

function TinputExForm.showmodal(const pMiscDescr: AStr; var pNewValue : AStr):Boolean;
begin
     cmbChooseItem.Visible:=false;
     edtNewItemname.Visible:=true;

     lblItemname.Caption:=pMiscDescr;
     edtNewItemname.Text:=pNewValue;

     btnOk.Enabled:=trim(pNewValue)<>'';
     result:=inherited showmodal=mrOk;
  if result then
     pNewValue:=trim(edtNewItemname.Text);
end;

function TinputExForm.showmodal(const pMiscDescr: AStr; const pComboItems : TAStrList; var pSelectedId : Integer):Boolean;
begin
     pSelectedId:=0;
     cmbChooseItem.Visible:=true;
     edtNewItemname.Visible:=false;

     lblItemname.Caption:=pMiscDescr;
     cmbChooseItem.Items.Assign(pComboItems);

     btnOk.Enabled:=cmbChooseItem.Items.Count>0;
  if cmbChooseItem.Items.Count>0 then
     cmbChooseItem.ItemIndex:=0; // märgistame ära esimese valiku, tulevikus jätame meelde viimase firma ja pakume uuesti seda !

     result:=(inherited showmodal=mrOk) and (cmbChooseItem.ItemIndex>=0);
  if result then
     pSelectedId:=PtrInt(cmbChooseItem.Items.Objects[cmbChooseItem.ItemIndex]);
end;

initialization
  {$I estbk_inputformex.ctrs}

end.

