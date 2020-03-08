unit estbk_frm_sepapayments;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, estbk_types, db, ZDataset;

type

  { TformSepaPayments }

  TformSepaPayments = class(TForm)
    btnClose: TBitBtn;
    btnGenerate: TBitBtn;
    edtSepaFilePath: TEdit;
    grpfile: TGroupBox;
    lblSaveToFile: TLabel;
    btnSaveToFile: TSpeedButton;
    dlgSave: TSaveDialog;
    procedure btnCloseClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FPaymentIDs : TADynIntArray;
    FBankSwift : AStr;
    FCompanyId : Integer;
    FQuery : TZQuery;
    function generateFilename : AStr;
  public
    class function generateSepaPayments(const pBankSwift : AStr;
                                        const pCompanyId : Integer;
                                        const pPaymentIds : TADynIntArray;
                                        const pQuery : TZQuery;
                                        const pFilename : AStr) : AStr;
    constructor Create(const AOwner : TComponent;
                       const pBankSwift : AStr;
                       const pCompanyid : Integer;
                       const pPaymentIDs : TADynIntArray;
                       const pQuery : TZQuery);reintroduce;
  end;

var
  formSepaPayments: TformSepaPayments;

implementation
uses
  estbk_sqlclientcollection, estbk_utilities, estbk_strmsg, estbk_lib_sepa,
  estbk_globvars, math;

class function TformSepaPayments.generateSepaPayments(const pBankSwift : AStr;
                                                      const pCompanyId : Integer;
                                                      const pPaymentIds : TADynIntArray;
                                                      const pQuery : TZQuery;
                                                      const pFilename : AStr) : AStr;
var
  pSQL  : AStr;
  pColl : TSepaPaymentCollItem;
  pCollGrp : TCollection;
  pClientAddr : AStr;
  pFileId, i : Integer;
begin
  Result := '';
  pSQL := estbk_sqlclientcollection._SQLSearchPayments(pCompanyId,
                                                       0, // custid
                                                       Nan, // pmtorderdate,
                                                       '', // docnr
                                                       '', // billnr
                                                       '', // ordern
                                                       '', // recvaccnr
                                                       '', // descr
                                                       '', // custname
                                                       false, // iscashregister
                                                       0, // 0 - sissetulek; 1 - väljaminek
                                                       1000, // maxrowrs
                                                       pPaymentIds);

  with pQuery, SQL do
   try



      pCollGrp := TCollection.Create(TSepaPaymentCollItem);


      // --
      Close;
      Clear;
      Add(pSQL);
      Open;
      First;

      while not Eof do
        begin
         pColl := pCollGrp.Add as TSepaPaymentCollItem;
         pColl.PaymentId := FieldByname('pmtordid').AsInteger;
         pColl.PaymentDate := FieldByname('payment_date').AsDatetime;
         pColl.CompanyName := estbk_globvars.glob_currcompname;
         pColl.CompanyBankBic := FieldByname('compbankswift').AsString;
         pColl.CompanyBankName := FieldByname('compbankname').AsString;
         pColl.CompanyBankAccountNr := FieldByname('payer_account_nr').AsString;
         pColl.PaymentSum := FieldByname('sumtotal').AsFloat;
         pColl.PaymentCurrency := FieldByname('currency').AsString;

         pColl.PaymentInfoLine := FieldByname('descr').AsString;

         pColl.ClientBankBic := FieldByname('rcvbankswift').AsString;
         pColl.ClientBankName := FieldByname('rcvbankname').AsString;
         pColl.ClientName := FieldByname('custname').AsString;
         pColl.ClientCountry := FieldByname('custcountrycode').AsString;
         pColl.ClientBankAccountNr := FieldByname('payment_rcv_account_nr').AsString;

         pClientAddr := trim(FieldByname('client_city').AsString + ' ' +
                             FieldByname('client_street').AsString + ' ' +
                             FieldByname('client_housenr').AsString);
     if (pClientAddr <> '') and (FieldByname('client_apartmentnr').AsString <> '') then
         pClientAddr := pClientAddr + ' - ' + FieldByname('client_apartmentnr').AsString;

     // SEPA nõuab alati aadressi
     if (length(pClientAddr) < 2) then
         pClientAddr := estbk_strmsg.CSMissingConst;
         pColl.ClientPostalAddr := (pClientAddr);

         // ---
         Next;
        end;


       // DABAFIHX https://www-2.danskebank.com/link/swiftbic
       Result := TSepaPayment.GenerateXMLFile(now, pCollGrp, pBankSwift);

       // 30.11.2015 Ingmar
       Close;
       Clear;
       Add(estbk_sqlclientcollection._SQLInsertSepaFile);
       ParamByname('bankcode').AsString := pBankSwift;
       ParamByname('filename').AsString := Trim(pFilename);
       ParamByname('company_id').AsInteger := estbk_globvars.glob_company_id;
       ParamByname('rec_changed').AsDateTime := now;
       ParamByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
       ParamByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
       Open;

       pFileId := FieldByname('id').AsInteger;


   for i := 0 to pCollGrp.Count - 1 do
      begin
       pColl := pCollGrp.Items[i] as TSepaPaymentCollItem;
       Close;
       Clear;
       Add(estbk_sqlclientcollection._SQLInsertSepaFileEntry);
       ParamByname('sepa_file_id').AsInteger := pFileId;
       ParamByname('sepa_payment_id').AsInteger := pColl.PaymentId;
       ExecSQL;
     end;

   finally
      FreeAndNil(pCollGrp);
      // --
      Close;
      Clear;
   end;
end;

constructor TformSepaPayments.Create(const AOwner : TComponent;
                                     const pBankSwift : AStr;
                                     const pCompanyid : Integer;
                                     const pPaymentIDs : TADynIntArray;
                                     const pQuery : TZQuery);
begin
  inherited Create(AOwner);
  FPaymentIDs := pPaymentIDs;
  FCompanyId := pCompanyid;
  FQuery := pQuery;
  FBankSwift := pBankSwift;
end;

function TformSepaPayments.generateFilename : AStr;
begin
  Result := 'sepa' + FormatDateTime('ddmmyyyy', now) + '.xml';
end;

procedure TformSepaPayments.FormCreate(Sender: TObject);
begin
  {$ifdef debug}
   edtSepaFilePath.Text := 'c:\testsepa.xml';
  {$else}
   //edtSepaFilePath.Text := GetDesktopPath + FormatDateTime('sepa_dd_mm_yy.xml', now);
   edtSepaFilePath.Text := GetDesktopPath + generateFilename;
  {$endif}
end;

procedure TformSepaPayments.btnGenerateClick(Sender: TObject);
var
  pXML : AStr;
  pTextFile : TextFile;
begin
  if edtSepaFilePath.Text <> '' then
   begin

    pXML := Self.generateSepaPayments(FBankSwift, FCompanyId, FPaymentIDs, FQuery, edtSepaFilePath.Text);
    try
      Self.Close;

      AssignFile(pTextFile, edtSepaFilePath.Text);
      Rewrite(pTextFile);
      Writeln(pTextFile, CUTF8BOM + pXML);
      CloseFile(pTextFile);


      // --
      dialogs.ShowMessage(estbk_strmsg.SCommDone);
    except on e : exception do
      dialogs.MessageDlg(e.message, MtError, [MbOk], 0);
    end;
   end else
    dialogs.messageDlg(estbk_strmsg.SEPmtSepaFileNotChoosed, mtError, [mbOk], 0);
end;

procedure TformSepaPayments.btnSaveToFileClick(Sender: TObject);
begin
     dlgSave.FileName := generateFilename;
  if dlgSave.Execute then
     edtSepaFilePath.Text := dlgSave.Files.Strings[0];
end;

procedure TformSepaPayments.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

initialization
  {$I estbk_frm_sepapayments.ctrs}

end.

