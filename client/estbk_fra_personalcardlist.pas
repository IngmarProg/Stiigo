unit estbk_fra_personalcardlist;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Buttons, StdCtrls,LCLType,
  DBGrids,estbk_lib_commonevents,estbk_uivisualinit,estbk_clientdatamodule,estbk_fra_template,
  estbk_sqlclientcollection, estbk_globvars, estbk_utilities,
  estbk_types, estbk_strmsg, db, ZDataset;

type

  { TframePersonalCardList }

  TframePersonalCardList = class(Tfra_template)
    btnClose: TBitBtn;
    btnNew: TBitBtn;
    qryWorkersDS: TDatasource;
    gridWorkers: TDBGrid;
    grpWorkers: TGroupBox;
    qryWorkers: TZQuery;
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure gridWorkersDblClick(Sender: TObject);
    procedure gridWorkersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure qryWorkersFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    FframeKillSignal  : TNotifyEvent;
    FParentKeyNotif   : TKeyNotEvent;
    FFrameDataEvent   : TFrameReqEvent;

    function  getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
  published
    property onFrameKillSignal     : TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData         : boolean read getDataLoadStatus write setDataLoadStatus;
  end; 

implementation

procedure TframePersonalCardList.gridWorkersDblClick(Sender: TObject);
begin
if assigned(gridWorkers.SelectedRows) then // and (gridWorkers.SelectedRows.Count=1) then
   if assigned(onFrameDataEvent) then
      self.onFrameDataEvent(self,__frameOpenWorkerEntry,qryWorkers.FieldByname('id').asInteger,nil);
end;

procedure TframePersonalCardList.gridWorkersKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key=VK_RETURN then
    begin
     self.gridWorkersDblClick(Sender);
     key:=0;
    end;
end;

procedure TframePersonalCardList.qryWorkersFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept:=DataSet.FieldByName('code').AsString<>estbk_types.CEmployee_NULLusercode;
end;

procedure TframePersonalCardList.btnCloseClick(Sender: TObject);
begin
if assigned(self.FframeKillSignal) then
   self.FframeKillSignal(self);
end;

procedure TframePersonalCardList.btnNewClick(Sender: TObject);
begin
if assigned(onFrameDataEvent) then
   self.onFrameDataEvent(self,__frameReqCreateNewWorkerEntry,-1,nil);
end;

function  TframePersonalCardList.getDataLoadStatus: boolean;
begin
  result:=self.qryWorkers.Active;
end;

procedure TframePersonalCardList.setDataLoadStatus(const v: boolean);
begin
     self.qryWorkers.Active:=false;
     self.qryWorkers.SQL.Clear;

  if v then
   begin
     self.qryWorkers.Connection:=dmodule.primConnection;
     self.qryWorkers.SQL.Add(estbk_sqlclientcollection._SQLSelectEmployee);
     self.qryWorkers.ParamByName('id').Value:=null;
     self.qryWorkers.ParamByName('company_id').AsInteger:=estbk_globvars.glob_company_id;
     self.qryWorkers.Active:=v;
     self.qryWorkers.Filtered:=true;
   end else
     self.qryWorkers.Connection:=nil;
end;

initialization
  {$I estbk_fra_personalcardlist.ctrs}

end.

