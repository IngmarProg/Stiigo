unit estbk_choose_dform;


{$mode objfpc}{$H+}
{$i estbk_defs.inc}


interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, estbk_uivisualinit, estbk_strmsg, estbk_clientdatamodule, estbk_types,
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
    function showmodal(const pMiscDescr: AStr; var pSelectedItemId: integer; const pformType: AStr): boolean; reintroduce;
  end;

var
  formChoosedFrm: TformChoosedFrm;

implementation

function TformChoosedFrm.showmodal(const pMiscDescr: AStr; var pSelectedItemId: integer; const pformType: AStr): boolean;
var
  pId: integer;
begin
  pSelectedItemId := 0;
  Result := False;
  // ---
  qryActiveDForms.Connection := dmodule.primConnection;
  with qryActiveDForms, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLSelectDFormsByType);
      parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
      parambyname('formtype').AsString := pformType;
      Open;
      First;

      while not EOF do
      begin
        pId := FieldByName('id').AsInteger;
        cmbActiveForms.AddItem(FieldByName('form_name').AsString, TObject(PtrInt(pId)));
        // ---
        Next;
      end;

      // ---
      cmbActiveForms.ItemIndex := 0;

    finally
      Close;
      Clear;
    end;

  btnOk.Enabled := (cmbActiveForms.Items.Count > 0);
  if not btnOk.Enabled then
    btnCancel.SetFocus;

  // kui mitu vormi, siis tuleb valik !
  if (cmbActiveForms.Items.Count > 1) then
  begin
    // ---
    lblItemname.Caption := pMiscDescr;
    Result := (inherited showmodal = mrOk) and (cmbActiveForms.ItemIndex >= 0);
    if Result then
    begin
      pSelectedItemId := PtrInt(cmbActiveForms.Items.Objects[cmbActiveForms.ItemIndex]);
    end;

  end
  else
  begin
    Result := True;
    pSelectedItemId := pId;
  end;
end;

initialization
  {$I estbk_choose_dform.ctrs}

end.
