unit estbk_fra_payment_information;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, ExtCtrls, StdCtrls,estbk_fra_template,
  Graphics, DbCtrls, EditBtn, DBGrids, rxlookup, Grids, Buttons, LCLType,LCLIntf,LCLProc,
  estbk_clientdatamodule, estbk_sqlclientcollection, estbk_globvars,
  estbk_utilities, estbk_types, estbk_uivisualinit, estbk_lib_commonevents,
  estbk_strmsg, db, ZDataset;
(*
 06.02.2011 Ingmar
  Laekumised; aga ostuarvetel peaks olema pigem pealkirjaks tasumised...
*)
type
  TPmtInfoType = (__pmtInfoIncomings,
                         __pmtInfoPayments);

type

  { TframePaymentInformation }

  TframePaymentInformation = class(Tfra_template)
    Bevel1: TBevel;
    btnClose: TBitBtn;
    pExtInform: TMemo;
    qryPaymentDataDs: TDatasource;
    gridPaymentItems: TDBGrid;
    grpItems: TGroupBox;
    qryPaymentData: TZReadOnlyQuery;
    procedure btnCloseClick(Sender: TObject);
    procedure gridPaymentItemsDblClick(Sender: TObject);
    procedure gridPaymentItemsDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure gridPaymentItemsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gridPaymentItemsPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure qryPaymentDataAfterScroll(DataSet: TDataSet);
  private
    FframeKillSignal   : TNotifyEvent;
    FParentKeyNotif    : TKeyNotEvent;
    FFrameDataEvent    : TFrameReqEvent;
    FCurrentPmtInfoType: TPmtInfoType;
    // ---
    function    getDataLoadStatus: boolean;
    procedure   setDataLoadStatus(const v: boolean);
    procedure   fillColumnsByDataMode(const pMode : TPmtInfoType);
  public
    property    onFrameKillSignal     : TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property    onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    property    onFrameDataEvent      : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property    loadData : boolean read getDataLoadStatus write setDataLoadStatus;

    procedure   openPaymentInformation(const pClientId : Integer = -1;
                                       const pBillId   : Integer = -1;
                                       const pOrderId  : Integer= -1);
    // ---
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  end; 

// LAEKUMISED / TASUMISED
const
   CCol_PaymentSource  = 0;
   CCol_PaymentAccNr   = 1; // laekumise nr
   CCol_PaymentDate    = 2;
   CCol_BankName       = 3;
   CCol_BankAccInformation = 4; // rp. konto info
   CCol_BankAccNumber      = 5;
   CCol_PayerName          = 6; // kes tasus arve...
   CCol_PayerAccNumber     = 7;
   CCol_PaymentSum         = 8;
   CCol_PaymentCurrency    = 9;

implementation

// standard wrapper !
function  TframePaymentInformation.getDataLoadStatus: boolean;
begin
   result:=qryPaymentData.Active;
end;

procedure TframePaymentInformation.setDataLoadStatus(const v: boolean);
begin
 if v then
    qryPaymentData.Connection:=dmodule.primConnection
 else
    qryPaymentData.Connection:=nil;
end;

procedure TframePaymentInformation.fillColumnsByDataMode(const pMode : TPmtInfoType);
begin
       self.FCurrentPmtInfoType:=pMode;
// DEPR 04.04.2011 !
(*
  with gridPaymentItems.Columns do
  case pMode of
    __pmtInfoIncomings:
        begin
         grpItems.Caption:=estbk_strmsg.CSBtnNameIncomings;
         Items[CCol_PaymentAccNr].Title.Caption:=estbk_strmsg.SCColPmt_nr_i;
         Items[CCol_PaymentAccNr].FieldName:='acc_number';

         Items[CCol_PaymentDate].Title.Caption:=estbk_strmsg.SCColPmt_date_i;
         Items[CCol_PaymentDate].FieldName:='payment_date';

         Items[CCol_BankName].Title.Caption:=estbk_strmsg.SCColPmt_bank_i;
         Items[CCol_BankName].FieldName:='bank_long_name';

         Items[CCol_BankAccInformation].Title.Caption:=estbk_strmsg.SCColPmt_account_i;
         Items[CCol_BankAccInformation].FieldName:='';

         Items[CCol_BankAccNumber].Title.Caption:=estbk_strmsg.SCColPmt_bankaccount_i;
         Items[CCol_BankAccNumber].FieldName:='';

         Items[CCol_PayerName].Title.Caption:=estbk_strmsg.SCColPmt_paidby_i;
         Items[CCol_PayerName].FieldName:='';

         Items[CCol_PayerAccNumber].Title.Caption:=estbk_strmsg.SCColPmt_payer_accnr_i;
         Items[CCol_PayerAccNumber].FieldName:='';

         Items[CCol_PaymentSum].Title.Caption:=estbk_strmsg.SCColPmt_sum_i;
         Items[CCol_PaymentSum].FieldName:='';

         Items[CCol_PaymentCurrency].Title.Caption:=estbk_strmsg.SCColPmt_currency_i;
         Items[CCol_PaymentCurrency].FieldName:='';
        end;

    __pmtInfoPayments:
        begin
        grpItems.Caption:=estbk_strmsg.CSBtnNamePayments;
        Items[CCol_PaymentAccNr].Title.Caption:=estbk_strmsg.SCColPmt_nr_p;
        Items[CCol_PaymentAccNr].FieldName:='acc_number';

        Items[CCol_PaymentDate].Title.Caption:=estbk_strmsg.SCColPmt_date_p;
        Items[CCol_PaymentDate].FieldName:='payment_date';

        Items[CCol_BankName].Title.Caption:=estbk_strmsg.SCColPmt_bank_p;
        Items[CCol_BankName].FieldName:='bank_long_name';

        Items[CCol_BankAccInformation].Title.Caption:=estbk_strmsg.SCColPmt_account_p;
        Items[CCol_BankAccInformation].FieldName:='';

        Items[CCol_BankAccNumber].Title.Caption:=estbk_strmsg.SCColPmt_bankaccount_p;
        Items[CCol_BankAccNumber].FieldName:='';

        Items[CCol_PayerName].Title.Caption:=estbk_strmsg.SCColPmt_paidby_p;
        Items[CCol_PayerName].FieldName:='';

        Items[CCol_PayerAccNumber].Title.Caption:=estbk_strmsg.SCColPmt_payer_accnr_p;
        Items[CCol_PayerAccNumber].FieldName:='';

        Items[CCol_PaymentSum].Title.Caption:=estbk_strmsg.SCColPmt_sum_p;
        Items[CCol_PaymentSum].FieldName:='';

        Items[CCol_PaymentCurrency].Title.Caption:=estbk_strmsg.SCColPmt_currency_p;
        Items[CCol_PaymentCurrency].FieldName:='';
        end;
  end; *)
end;

procedure TframePaymentInformation.openPaymentInformation(const pClientId : Integer = -1;
                                                          const pBillId   : Integer = -1;
                                                          const pOrderId  : Integer= -1);
var
  pData : AStr;
begin
       self.fillColumnsByDataMode(__pmtInfoIncomings);
  with qryPaymentData,SQL do
   begin
      close;
      clear;
      pData:=estbk_sqlclientcollection._SQLItemPaymentInfo(estbk_globvars.glob_company_id,
                                                           pClientId,
                                                           pBillId,
                                                           pOrderId,
                                                           false);
   if pData<>'' then
     begin
        add(pData);
        Open;


     // ---
     if recordcount<1 then
        gridPaymentItems.DataSource:=nil
     else
        gridPaymentItems.DataSource:=qryPaymentDataDs;
     end;
   end;
end;

procedure TframePaymentInformation.gridPaymentItemsDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  pts   : TTextStyle;
  pData : AStr;
begin
  with TDbGrid(Sender) do
   begin
          Canvas.FillRect(Rect);
          pts := Canvas.TextStyle;
          pts.Alignment := taLeftJustify;
          Canvas.TextStyle := pts;

      if  self.FCurrentPmtInfoType=__pmtInfoIncomings then
        begin
                if assigned(Column)  then  // pageCtrlClient.activepage:=TabSheet24;
                  begin
                  if  Column.Index=CCol_BankAccInformation then
                      pData:=trim(qryPaymentData.FieldByname('acc_for_bank').AsString+' / '+qryPaymentData.FieldByname('acc_for_bank_name').AsString)
                  else
                  if  Column.Index=CCol_BankAccNumber then // meie konto nr, kuhu raha laekus
                    begin
                        pData:=trim(qryPaymentData.FieldByname('receiver_account_number').AsString);
                    if (pData<>'') and  (trim(qryPaymentData.FieldByname('receiver_account_number_iban').AsString)<>'') then
                        pData:=pData+' / '+qryPaymentData.FieldByname('receiver_account_number_iban').AsString
                    else
                        pData:=qryPaymentData.FieldByname('receiver_account_number_iban').AsString;
                    end else
                  if  Column.Index=CCol_PayerName then
                    begin
                        pData:=trim(qryPaymentData.FieldByname('payer_name').AsString);
                    end else
                  if Column.Index=CCol_PayerAccNumber then
                    begin
                        pData:=trim(qryPaymentData.FieldByname('bank_account').AsString);
                    if (pData<>'') and  (trim(qryPaymentData.FieldByname('bank_account_iban').AsString)<>'') then
                        pData:=pData+' / '+qryPaymentData.FieldByname('bank_account_iban').AsString
                    else
                        pData:=pData+qryPaymentData.FieldByname('bank_account_iban').AsString;
                    end else
                  if Column.Index=CCol_PaymentSum then
                    begin
                        pData:=format(CCurrentMoneyFmt2,[qryPaymentData.FieldByName('income_sum').AsCurrency]);
                    end else
                  if Column.Index=CCol_PaymentCurrency then
                    begin
                        pData:=qryPaymentData.FieldByName('currency').AsString+' '+format(CCurrentAmFmt3,[qryPaymentData.FieldByName('currency_drate_ovr').asFloat]);
                    end else
                        pData:=Column.Field.AsString;

                  end else
                      pData:='';
                      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 3,trim(pData) + #32, Canvas.TextStyle);
        end else
      if  self.FCurrentPmtInfoType=__pmtInfoPayments then
        begin
             pData:='';
          if assigned(Column)  then
            begin
             // if  Column.Index=CCol_BankAccInformation then
             if  Column.Index=CCol_PaymentAccNr then
                 pData:=trim(qryPaymentData.FieldByname('payment_nr').AsString)
             else
             if  Column.Index=CCol_PayerName then
                begin
                    pData:=trim(qryPaymentData.FieldByname('payment_rcv_name').AsString); // antud juhul, kellele maksime !
                end else
             if Column.Index=CCol_PaymentSum then
                begin
                    pData:=format(CCurrentMoneyFmt2,[qryPaymentData.FieldByName('splt_sum').AsCurrency]);
                end else
              if Column.Index=CCol_PaymentCurrency then
                begin
                    pData:=qryPaymentData.FieldByName('currency').AsString+' '+format(CCurrentAmFmt3,[qryPaymentData.FieldByName('currency_drate_ovr').asFloat]);
                end else
              if Column.Index=CCol_PayerAccNumber then // antud juhul tegemist inimese konto nr, kellele raha saadame
                begin
                    pData:=trim(qryPaymentData.FieldByname('payment_rcv_account_nr').AsString);
                end else
              if Column.Index=CCol_BankName then
                begin
                    pData:=trim(qryPaymentData.FieldByname('bank_long_name').AsString)
                end else
              if Column.Index=CCol_BankAccInformation then
                begin
                   pData:=trim(qryPaymentData.FieldByname('acc_for_bank').AsString+' / '+qryPaymentData.FieldByname('acc_for_bank_name').AsString)
                end else
              if Column.Index=CCol_BankAccNumber then
                begin
                   pData:=trim(qryPaymentData.FieldByname('payer_account_nr').AsString);
                end else
              if Column.Index=CCol_PaymentDate then
                begin
                    pData:=trim(qryPaymentData.FieldByname('payment_date').AsString);
                end else
                    pData:=''; //Column.Field.AsString;
            end;

             // --
             Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 3,trim(pData) + #32, Canvas.TextStyle);
        end;
   end;
end;

procedure TframePaymentInformation.gridPaymentItemsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  // --
 if key=VK_F5 then
   begin
    if trim(qryPaymentData.SQL.Text)<>'' then
      begin
       qryPaymentData.Active:=false;
       qryPaymentData.Active:=true;
      end;

       // --
       key:=0;
   end;
end;

procedure TframePaymentInformation.gridPaymentItemsPrepareCanvas(
  sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
   with TDbGrid(Sender).Canvas do
   begin

          Font.Color := clWindowText;
      if (gdSelected in AState)  then // or (Column.Index=CColItems_pcheckbox)
        begin
          Brush.Color:=clHighlight;
          Font.Color:=clWindow;
        end else
        begin
        if (pos(estbk_types.CRecIsClosed,qryPaymentData.FieldByName('status').asString)=0) then
            Brush.Color:=estbk_types.MyFavLightYellow
        else
            Brush.Color:=clWindow;
        end;
   // ----
   end;
end;

procedure TframePaymentInformation.btnCloseClick(Sender: TObject);
begin
  if assigned(self.FframeKillSignal) then
     self.FframeKillSignal(self);
end;

procedure TframePaymentInformation.gridPaymentItemsDblClick(Sender: TObject);
begin
  // --
end;

procedure TframePaymentInformation.qryPaymentDataAfterScroll(DataSet: TDataSet);
var
  pDescr : AStr;
begin
  if  self.FCurrentPmtInfoType=__pmtInfoIncomings then
   begin
        pDescr:=format(estbk_strmsg.SCIncLongDesc,[Dataset.FieldByName('description').asString,
                                                   Dataset.FieldByName('filename').asString,
                                                   trim(Dataset.FieldByName('icr_firstname').asString+' '+Dataset.FieldByName('icr_lastname').asString)
                                                   ]);

        pExtInform.Caption:=pDescr;
   end;
end;


constructor TframePaymentInformation.create(frameOwner: TComponent);
begin
  inherited create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
  pExtInform.Color:=estbk_types.MyFavGray;
end;

destructor  TframePaymentInformation.destroy;
begin
 inherited destroy;
end;


initialization
  {$I estbk_fra_payment_information.ctrs}

end.

