unit estbk_frm_ebill_import;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, contnrs,
  ExtCtrls, StdCtrls, Buttons, estbk_strmsg, estbk_types, estbk_fra_bills, estbk_lib_ebillimporter;

type

  { TfrmEBillImport }

  TfrmEBillImport = class(TForm)
    btnChoosefile: TBitBtn;
    memoImportLog: TMemo;
    dlgOpenEBill: TOpenDialog;
    pnlFileContainer: TPanel;
    procedure btnChoosefileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FBills : TframeBills;
    FEBillImp : TEbillImporter;
  protected
    procedure OnEBillReaderError(const pTaginfo : AStr;
                                 const pError : AStr;
                                 const pErrorLevel : TCEBillReaderErrorLevel;
                                 var pResume : Boolean);

    procedure OnEBillProcessingUIMod(const pInvoiceNr : AStr;
                                     const pInvoiceDate : TDatetime;
                                     const pInvoiceDueDate : TDatetime;
                                     const pCustomername : AStr;
                                     const pCustomerregCode : AStr;
                                     const pCustomerVAT : AStr;
                                     const pVatDateObjList : TObjectList;
                                     const pItemObjList : TObjectList);
  public
    class function showAndCreate() : Boolean;
  end; 

var
  frmEBillImport: TfrmEBillImport;

implementation
uses estbk_clientdatamodule;
{ TfrmEBillImport }

class function TfrmEBillImport.showAndCreate() : Boolean;
begin
  with TfrmEBillImport.Create(nil) do
  try
     Showmodal;
  finally
     Free;
  end;
end;

procedure TfrmEBillImport.OnEBillReaderError(const pTaginfo : AStr;
                                             const pError : AStr;
                                             const pErrorLevel : TCEBillReaderErrorLevel;
                                             var pResume : Boolean);
const
  CErrList : array[TCEBillReaderErrorLevel] of AStr = (SCErr_information, SCErr_warning, SCErr_critical);
begin
  pResume := pErrorLevel <> __err_fatal;
  memoImportLog.Lines.Add(CErrList[pErrorLevel] + ': '+ pTaginfo +' '+pError);
end;

procedure TfrmEBillImport.OnEBillProcessingUIMod(const pInvoiceNr : AStr;
                                                 const pInvoiceDate : TDatetime;
                                                 const pInvoiceDueDate : TDatetime;
                                                 const pCustomername : AStr;
                                                 const pCustomerregCode : AStr;
                                                 const pCustomerVAT : AStr;
                                                 const pVatDateObjList : TObjectList;
                                                 const pItemObjList : TObjectList);
begin
  FBills.tryToImportEBillData(pInvoiceNr,
                              pInvoiceDate,
                              pInvoiceDueDate,
                              pCustomername,
                              pCustomerregCode,
                              pCustomerVAT,
                              pVatDateObjList,
                              pItemObjList);
end;

procedure TfrmEBillImport.FormCreate(Sender: TObject);
begin
  FBills := TframeBills.create(nil);
  FBills.Visible:= False;
  FBills.loadData := True;
  FEBillImp:=TEbillImporter.Create(nil);
end;

procedure TfrmEBillImport.btnChoosefileClick(Sender: TObject);
var
  pFilename : AStr;
begin
if dlgOpenEBill.Execute then
  begin
      pFilename := dlgOpenEBill.Files.Strings[0];
      memoImportLog.Clear;
      FEBillImp.OnEBillProcessingUIModEvent := @OnEBillProcessingUIMod;
      FEBillImp.OnEBillReaderError := @OnEBillReaderError;

      FEBillImp.Filename := pFilename;
      FEBillImp.Exec;
      memoImportLog.Lines.Add(estbk_strmsg.SCommDone);
  end; // @@@
end;

procedure TfrmEBillImport.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEBillImp);
  FreeAndNil(FBills);
end;

initialization
  {$I estbk_frm_ebill_import.ctrs}

end.

