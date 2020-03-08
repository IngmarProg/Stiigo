unit estbk_frm_currlist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBGrids, EditBtn, estbk_clientdatamodule, estbk_frm_template, db, ZDataset;

type

  { TformCurrlist }

  TformCurrlist = class(TfrmTemplate)
    qryCurrListDs: TDatasource;
    pCurrDate: TDateEdit;
    gridCurr: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    qryCurrList: TZReadOnlyQuery;
    procedure FormCreate(Sender: TObject);
    procedure pCurrDateAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure pCurrDateChange(Sender: TObject);
    procedure pCurrDateExit(Sender: TObject);
    procedure qryCurrListFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    FOnChangeEventOcc : Boolean;
    procedure validateCurrList(const pDate : TDatetime);
  public
    class function showAndCreate():Boolean;
  end; 

var
  formCurrlist: TformCurrlist;

implementation
uses estbk_sqlclientcollection,estbk_types,estbk_utilities,estbk_strmsg,dateutils;

procedure TformCurrlist.validateCurrList(const pDate : TDatetime);
var
   pRCnt : Integer;
begin
   qryCurrList.Filtered:=false;
   qryCurrList.Filtered:=true;

// küsime kursid !
   pRCnt:=qryCurrList.RecordCount;
if pRCnt<1 then
  begin
    estbk_clientdatamodule.dmodule.downloadCurrencyData(false,pDate);

    qryCurrList.Filtered:=false;
    qryCurrList.Active:=false;
    qryCurrList.Active:=true;

    pRCnt:=qryCurrList.RecordCount;
   end;

    // ---
    qryCurrList.Filtered:=pRCnt>0;
end;

procedure TformCurrlist.pCurrDateAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
   AcceptDate:=ADate<=now;
if AcceptDate then
   self.validateCurrList(ADate);
end;

procedure TformCurrlist.pCurrDateChange(Sender: TObject);
begin
   // 22.04.2012 Ingmar; peab olema fokuseeritud !
if TDateEdit(Sender).Focused then
  begin

   if (length(pCurrDate.text)>=10) then
     begin
       self.FOnChangeEventOcc:=false;
       self.validateCurrList(pCurrDate.Date)
     end else
       self.FOnChangeEventOcc:=true;
  end;
end;

procedure TformCurrlist.FormCreate(Sender: TObject);
begin
  // --
  qryCurrList.Close;
  qryCurrList.SQL.Clear;
  qryCurrList.SQL.Text:=estbk_sqlclientcollection._SQLFullSelectCurrencys;
  qryCurrList.ParamByName('curr_date').Value:=null;
  qryCurrList.Open;

  pCurrDate.Date:=now-1;
  pCurrDate.Text:=datetostr(pCurrDate.Date);
  self.validateCurrList(pCurrDate.Date);
end;

procedure TformCurrlist.pCurrDateExit(Sender: TObject);
var
   pStr : AStr;
   cval : TDatetime;
begin
   pStr:=trim(TEdit(Sender).Text);
if pStr<>'' then
  begin
    if not estbk_utilities.validateMiscDateEntry(pStr,cval) then
      begin
         dialogs.messageDlg(estbk_strmsg.SEInvalidDate,mterror,[mbOk],0);
      if TEdit(Sender).CanFocus then
         TEdit(Sender).SetFocus;
         Exit;
      end else
         TEdit(Sender).Text:=datetostr(cval);

      if self.FOnChangeEventOcc then
        begin
         self.FOnChangeEventOcc:=false;
         self.validateCurrList(cval);
        end;
  // --
  end;
end;

procedure TformCurrlist.qryCurrListFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
if pCurrDate.Text<>'' then
   // Accept:=round(Dataset.FieldByname('curr_date').AsDateTime-pCurrDate.Date)=0
  begin
   Accept:=dateutils.DaysBetween(Dataset.FieldByname('curr_date').AsDateTime,pCurrDate.Date)=0;
  end else
   Accept:=false;
end;

class function TformCurrlist.showAndCreate():Boolean;
begin
 with self.Create(nil) do
  try
    result:=showmodal=mrOk;
  finally
    free;
  end;
end;

initialization
  {$I estbk_frm_currlist.ctrs}

end.

