unit estbk_fra_workertimetable;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, ExtCtrls,
  EditBtn, DbCtrls, Grids,estbk_fra_template,
  estbk_lib_commonevents,estbk_uivisualinit,estbk_clientdatamodule,
  estbk_sqlclientcollection, estbk_globvars, estbk_utilities,DateUtils,
  estbk_types, estbk_strmsg, db, ZDataset;

type

  { TframeWorkerTimeTable }

  TframeWorkerTimeTable = class(Tfra_template)
    grpContract: TGroupBox;
    gridWorkerTimeTable: TStringGrid;
    qryWorker: TZQuery;
  private
    FframeKillSignal       : TNotifyEvent;
    FParentKeyNotif        : TKeyNotEvent;
    FFrameDataEvent        : TFrameReqEvent;
    function  getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure performCleanup;
  public
    procedure   fillWorkTimeTable(const pMonth : Integer; const pYear : Integer);
    constructor Create(frameOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end; 

implementation

const
  CCol_workerName    = 0;
  CCol_workerRegCode = 1;

type
  TWorkerTimeTable = class
    FEmployeeId : Integer;

  end;

function  TframeWorkerTimeTable.getDataLoadStatus: boolean;
begin
  result:=true;
end;

procedure TframeWorkerTimeTable.setDataLoadStatus(const v: boolean);
begin
end;

procedure  TframeWorkerTimeTable.performCleanup;
var
  i, j : Integer;
begin
for i:=0 to gridWorkerTimeTable.RowCount-1 do
   for j:=0 to gridWorkerTimeTable.ColCount-1 do
      if assigned(gridWorkerTimeTable.Objects[j,i]) then
       begin
         gridWorkerTimeTable.Objects[j,i].Free;
         gridWorkerTimeTable.Objects[j,i]:=nil;
       end;

         gridWorkerTimeTable.Clean(0,0,gridWorkerTimeTable.ColCount-1,gridWorkerTimeTable.RowCount-1,[gzNormal]);
         gridWorkerTimeTable.Columns.Clear;
end;

procedure   TframeWorkerTimeTable.fillWorkTimeTable(const pMonth : Integer; const pYear : Integer);
var
  pWorkerDtTable : TWorkerTimeTable;
  pGridItem : TGridColumn;
  prow,i : Integer;
begin
      self.performCleanup;
 with qryWorker,SQL do
   try
       close;
       clear;
       add(estbk_sqlclientcollection._SQLSelectEmployee);
       paramByname('id').value:=null;
       paramByname('company_id').asInteger:=estbk_globvars.glob_company_id;
       open;
       first;

       // pealkirjad paika
       pGridItem:=gridWorkerTimeTable.Columns.Add;
       pGridItem.Width:=145;
       pGridItem.Title.Caption:=estbk_strmsg.SCWrkTableWorkerName;

       pGridItem:=gridWorkerTimeTable.Columns.Add;
       pGridItem.Width:=80;
       pGridItem.Title.Caption:=estbk_strmsg.SCWrkTableWorkerIDCode;
       prow:=1;

   for i:=1 to dateUtils.DaysInAMonth(pYear,pMonth) do
      begin
        pGridItem:=gridWorkerTimeTable.Columns.Add;
        pGridItem.Width:=25;
        pGridItem.Title.Caption:=inttostr(i);
        pGridItem.Alignment:=taRightJustify;
      end;

   // ---
   while not eof do
     begin
        pWorkerDtTable:=TWorkerTimeTable.Create;
        pWorkerDtTable.FEmployeeId:=FieldByname('id').asInteger;
        gridWorkerTimeTable.Objects[CCol_workerName,prow]:=pWorkerDtTable;
        gridWorkerTimeTable.Cells[CCol_workerName,prow]:=trim(FieldByname('firstname').AsString+' '+FieldByname('lastname').AsString);

        // --
        inc(prow);
        next;
     end;


       // järgmine samm oleks, et vaadata, kas töötajal on selle N vahemikus kehtivaid lepinguid;
       // ps leping võib kehtida pool ühes kuus, pool teises samas lepingu summa teine !!!

   finally
       close;
       clear;
   end;
end;

constructor TframeWorkerTimeTable.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
end;

destructor TframeWorkerTimeTable.Destroy;
begin
  self.performCleanup;
  inherited Destroy;
end;

initialization
  {$I estbk_fra_workertimetable.ctrs}

end.

