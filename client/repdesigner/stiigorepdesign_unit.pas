unit stiigorepdesign_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LR_Desgn,
  LR_View, LR_Class;

type

  { TpDesignerForm }

  TpDesignerForm = class(TForm)
    frRepCreator: TfrReport;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  pDesignerForm: TpDesignerForm;

implementation

{$R *.frm}

{ TpDesignerForm }



{ TpDesignerForm }

procedure TpDesignerForm.FormShow(Sender: TObject);
begin

end;

procedure TpDesignerForm.FormCreate(Sender: TObject);
begin
  frRepCreator.DesignReport;
  Application.Terminate;
end;

end.

