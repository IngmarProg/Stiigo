unit estbk_choose_dform;


{$mode objfpc}{$H+}
{$i estbk_defs.inc}


interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons,estbk_uivisualinit, estbk_strmsg, estbk_clientdatamodule,estbk_types,
  estbk_sqlclientcollection, estbk_globvars, estbk_utilities, ZDataset;

type

  { TformChoosedFrm }

  TformChoosedFrm = class(TForm)
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    cmbActiveForms: TComboBox;
    grpIBox: TGroupBox;
    lblItemname: TLabel;
    qryActiveDForms: TZReadOnlyQuery;
  private
    { private declarations }
  public
    function showmodal(const pMiscDescr: AStr; var pSelectedItemId : Integer; const pformType : AStr):Boolean;reintroduce;
  end; 

var
  formChoosedFrm: TformChoosedFrm;

implementation

function TformChoosedFrm.showmodal(const pMiscDescr: AStr; var pSelectedItemId : Integer; const pformType : AStr):Boolean;
var
  pId : Integer;
begin
       pSelectedItemId:=0;
       result:=false;
       // ---
       qryActiveDForms.Connection:=dmodule.primConnection;
  with qryActiveDForms,SQL do
    try
          close;
          clear;
          add(estbk_sqlclientcollection._SQLSelectDFormsByType);
          parambyname('company_id').asInteger:=estbk_globvars.glob_company_id;
          parambyname('formtype').asString:=pformType;
          open;
          first;

    while not eof do
      begin
          pId:=fieldByname('id').AsInteger;
          cmbActiveForms.AddItem(fieldByname('form_name').AsString,TObject(PtrInt(pId)));
          // ---
          next;
      end;

         // ---
         cmbActiveForms.ItemIndex:=0;

    finally
        close;
        clear;
    end;

        btnOk.Enabled:=(cmbActiveForms.Items.Count>0);
     if not btnOk.Enabled then
        btnCancel.SetFocus;

     // kui mitu vormi, siis tuleb valik !
     if (cmbActiveForms.Items.Count>1) then
       begin
        // ---
          lblItemname.Caption:=pMiscDescr;
          result:=(inherited showmodal=mrOk) and (cmbActiveForms.ItemIndex>=0);
       if result then
         begin
          pSelectedItemId:=PtrInt(cmbActiveForms.Items.Objects[cmbActiveForms.ItemIndex]);
         end;

       end else
       begin
         result:=true;
         pSelectedItemId:=pId;
       end;
end;

initialization
  {$I estbk_choose_dform.ctrs}

end.

