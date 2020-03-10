unit estbk_lib_erprtwriter;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils, ZDataset, ZSequence, ZConnection, LCLProc, estbk_lib_rep_errorcodes,
  estbk_types, estbk_sqlclientcollection, estbk_globvars;

type
  TStatusRepWriter = class
  protected
    FRepBaseRecId: integer;
    FRepBaseRecCreated: boolean;
    FGenRepCode: AStr; // aruande baaskirje kood !
    FGenRepMiscData: AStr; // ntx vigade puhul failinimi
    FWrkQuery: TZQuery;
    FGenRecSeq: TZSequence;
    FLnRecSeq: TZSequence;

    FGenRepHdrData: AStr;
    FGenRepFtrData: AStr;
    FreportTaskStarts: TDatetime;
    FreportTaskEnds: TDatetime;
    // ---
    procedure createBaseRecId;
    procedure setNullParams(const pQry: TZQuery);
    procedure setMiscData(const pMiscData: AStr);
    procedure setGenRepHdr(const pHdrInfo: AStr);
    procedure setGenRepFtr(const pFtrInfo: AStr);
    procedure setReportTaskStart(const v: TDatetime);
    procedure setReportTaskEnd(const v: TDatetime);
  public
    property report_code: AStr read FGenRepCode;
    property baserecId: integer read FRepBaseRecId;
    property miscData: AStr read FGenRepMiscData write setMiscData;
    // nö tegevuse algus
    property taskStarts: TDatetime read FreportTaskStarts write setReportTaskStart;
    property taskEnds: TDatetime read FreportTaskEnds write setReportTaskEnd;
    property hdrData: AStr read FGenRepHdrData write setGenRepHdr;
    property ftrData: AStr read FGenRepFtrData write setGenRepFtr;
    // ---
    procedure resetReportGeneralRec; // teeb uue baaskirje koodiga, mis tuli konstruktorist
    // kui baaskirjet pole loodud; siis see luuakse ning kirjutatakse genRepStInfo
    procedure writeEntry(const pRepLCode: AStr; // ntx veakood, mingi informatiivne kood
      const pRepLongDescr: AStr; // ntx vea pikk kirjeldus
      const pRepLineNr: integer = 0; // suvaline reainfo
      const pRepIdentDescr: AStr = ''; const pRepIdentif: integer = 0 // mingi reaga seotud kood; kliendiID ntx
      );
    // ---
    constructor Create(const pGenConnection: TZConnection; const pGenRepCode: AStr); reintroduce;
    destructor Destroy; override;
  end;

implementation

procedure TStatusRepWriter.createBaseRecId;
begin
  // --
  self.FRepBaseRecId := FGenRecSeq.GetNextValue;
  with self.FWrkQuery, SQL do
    try
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLInsertStatusRepMRec);
      paramByname('id').AsInteger := self.FRepBaseRecId;
      paramByname('code').AsString := self.FGenRepCode;
      paramByname('classificator_id').AsInteger := 0;
      paramByname('misc_data').AsString := self.FGenRepMiscData;
      paramByname('hdr_data').AsString := self.FGenRepHdrData;
      paramByname('ftr_data').AsString := self.FGenRepFtrData;
      paramByname('op_starts').AsDateTime := self.FreportTaskStarts;
      paramByname('op_ends').AsDateTime := self.FreportTaskEnds;

      paramByname('status').AsString := '';
      paramByname('parent_id').AsInteger := 0;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      execSQL;
      self.FRepBaseRecCreated := True;
    finally
      Close;
      Clear;
    end; // --

end;


procedure TStatusRepWriter.setNullParams(const pQry: TZQuery);
var
  i: integer;
begin
  if assigned(pQry) then
    for i := 0 to pQry.Params.Count - 1 do
      pQry.Params[i].Value := null;
end;

procedure TStatusRepWriter.setMiscData(const pMiscData: AStr);
begin
  self.FGenRepMiscData := pMiscData;
  if self.FRepBaseRecCreated then
    with self.FWrkQuery, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateStatusRepMRec);
        self.setNullParams(self.FWrkQuery);
        paramByname('id').AsInteger := self.FRepBaseRecId;
        paramByname('misc_data').AsString := pMiscData;
        execSQL;
      finally
        Close;
        Clear;
      end;
end;

procedure TStatusRepWriter.setGenRepHdr(const pHdrInfo: AStr);
begin
  self.FGenRepHdrData := pHdrInfo;
  if self.FRepBaseRecCreated then
    with self.FWrkQuery, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateStatusRepMRec);
        self.setNullParams(self.FWrkQuery);
        paramByname('id').AsInteger := self.FRepBaseRecId;
        paramByname('hdr_data').AsString := pHdrInfo;
        execSQL;
      finally
        Close;
        Clear;
      end;
end;

procedure TStatusRepWriter.setGenRepFtr(const pFtrInfo: AStr);
begin
  self.FGenRepFtrData := pFtrInfo;

  if self.FRepBaseRecCreated then
    with self.FWrkQuery, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateStatusRepMRec);
        self.setNullParams(self.FWrkQuery);
        paramByname('id').AsInteger := self.FRepBaseRecId;
        paramByname('ftr_data').AsString := pFtrInfo;
        execSQL;
      finally
        Close;
        Clear;
      end;
end;

procedure TStatusRepWriter.setReportTaskStart(const v: TDatetime);
begin
  self.FreportTaskStarts := v;
  if self.FRepBaseRecCreated then
    with self.FWrkQuery, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateStatusRepMRec);
        self.setNullParams(self.FWrkQuery);
        paramByname('id').AsInteger := self.FRepBaseRecId;
        paramByname('op_starts').AsDateTime := v;
        execSQL;
      finally
        Close;
        Clear;
      end;
end;

procedure TStatusRepWriter.setReportTaskEnd(const v: TDatetime);
begin

  self.FreportTaskEnds := v;
  if self.FRepBaseRecCreated then
    with self.FWrkQuery, SQL do
      try
        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLUpdateStatusRepMRec);
        self.setNullParams(self.FWrkQuery);
        paramByname('id').AsInteger := self.FRepBaseRecId;
        paramByname('op_ends').AsDateTime := v;
        execSQL;
      finally
        Close;
        Clear;
      end;
end;

procedure TStatusRepWriter.resetReportGeneralRec;
begin
  self.FRepBaseRecCreated := False;
  self.FRepBaseRecId := 0;
  self.FGenRepHdrData := '';
  self.FGenRepFtrData := '';
end;

procedure TStatusRepWriter.writeEntry(const pRepLCode: AStr; const pRepLongDescr: AStr;
  // enamasti vea pikk kirjeldus !
  const pRepLineNr: integer = 0; // suvaline reainfo
  const pRepIdentDescr: AStr = ''; const pRepIdentif: integer = 0);


var
  pSeqId: int64;
begin
  if not self.FRepBaseRecCreated then
    self.createBaseRecId;

  with self.FWrkQuery, SQL do
    try
      pSeqId := FLnRecSeq.GetNextValue;
      // ---
      Close;
      Clear;
      add(estbk_sqlclientcollection._SQLInsertStatReportLines);
      paramByname('id').asLargeInt := pSeqId;
      paramByname('status_report_id').AsInteger := self.FRepBaseRecId;
      paramByname('code').AsString := pRepLCode;
      paramByname('severity').AsInteger := 0;

      paramByname('ldescr').AsString := copy(pRepLongDescr, 1, 512);
      paramByname('ddescr').AsString := copy(pRepIdentDescr, 1, 512);
      // 23.11.2010 Ingmar
      paramByname('line_nr').AsInteger := pRepLineNr;
      paramByname('misc_id').AsInteger := pRepIdentif;
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      execSQL;
    finally
      Close;
      Clear;
    end;
end;

constructor TStatusRepWriter.Create(const pGenConnection: TZConnection; const pGenRepCode: AStr);
begin
  inherited Create;
  FWrkQuery := TZQuery.Create(nil);
  FWrkQuery.Connection := pGenConnection;

  FGenRecSeq := TZSequence.Create(nil);
  FLnRecSeq := TZSequence.Create(nil);

  FGenRecSeq.SequenceName := 'status_report_id_seq';
  FGenRecSeq.Connection := pGenConnection;

  FLnRecSeq.SequenceName := 'status_report_lines_id_seq';
  FLnRecSeq.Connection := pGenConnection;
  // --
  self.FreportTaskStarts := now;
  self.FreportTaskEnds := now;
  self.FGenRepCode := pGenRepCode;
end; // --

destructor TStatusRepWriter.Destroy;
begin
  FreeAndNil(FWrkQuery);
  FreeAndNil(FGenRecSeq);
  FreeAndNil(FLnRecSeq);
  inherited Destroy;
end;


end.