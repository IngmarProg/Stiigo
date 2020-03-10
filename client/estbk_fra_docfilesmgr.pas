unit estbk_fra_docfilesmgr;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}


interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, DBGrids, Graphics,
  Buttons, estbk_uivisualinit, estbk_fra_template, estbk_lib_commoncls, estbk_lib_commonevents,
  estbk_clientdatamodule, estbk_sqlclientcollection, estbk_globvars, estbk_utilities,
  estbk_types, estbk_strmsg, DB, ZDataset, Grids, Dialogs{$IFDEF windows}, Windows{$ENDIF};

type

  { TframeDocFilesMgr }

  TframeDocFilesMgr = class(Tfra_template)
    btnClose: TBitBtn;
    btnNewFile: TBitBtn;
    btnOpenFile: TBitBtn;
    pDialog: TOpenDialog;
    qryFileListDs: TDatasource;
    dbGridFiles: TDBGrid;
    grpFilesGrpFox: TGroupBox;
    qryFileList: TZReadOnlyQuery;
    pSave: TSaveDialog;
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewFileClick(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure dbGridFilesDblClick(Sender: TObject);
    procedure dbGridFilesDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure dbGridFilesKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure dbGridFilesPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
  private
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FDummy: boolean;
    FDocumentId: int64;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    class procedure clearTempFiles;
  public
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
    // RTTI pole täielik, published puhul vaid erandid
  published
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property documentId: int64 read FDocumentId write FDocumentId;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

var
  pTempFiles: TStringList;

const
  CCol_filename = 0;
  CCol_filesize = 1;

procedure TframeDocFilesMgr.dbGridFilesDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
//mouseInGrid : TPoint;
//gridCoord: TGridCoord;
var
  pData: AStr;
  pBmp: Graphics.TBitmap;
  pSize: int64;
  pRectCpy: TRect;
  pBmpWidth: integer;
begin
  //Convert "Screen" Mouse to "Grid" Mouse
  //mouseInGrid := DBGrid1.ScreenToClient(Mouse.CursorPos) ;
  //gridCoord := DBGrid1.MouseCoord(mouseInGrid.X, mouseInGrid.Y) ;
  pRectCpy := Rect;

  // ---
  if assigned(Column) then
    with TDbGrid(Sender) do
    begin

      // ---
      Canvas.FillRect(Rect);
      // ---
      Brush.Color := estbk_types.MyFavGray;
      case Column.Index of
        CCol_filename:
        begin
          pData := extractfilename(qryFileList.FieldByName('filename').AsString);
          pBmp := Graphics.TBitmap.Create;
          try
            dmodule.sharedImages.GetBitmap(img_indxBoxImage, pBmp);
            pRectCpy.Left := pRectCpy.Left + 1;
            pRectCpy.Top := pRectCpy.Top - 1;
            pRectCpy.Bottom := pRectCpy.Bottom - 1;

            pBmpWidth := (Rect.Bottom - Rect.Top);
            pRectCpy.Right := Rect.Left + pBmpWidth;

            Canvas.StretchDraw(pRectCpy, pBmp);
          finally
            pBmp.Free;
          end;

          pRectCpy := Rect;
          pRectCpy.Left := Rect.Left + pBmpWidth;
        end;

        CCol_filesize:
        begin
          pSize := qryFileList.FieldByName('size').AsLargeInt;
          pData := estbk_utilities.formatByteSize(pSize) + #32;
        end;
      end;

      // -------
      Canvas.TextRect(pRectCpy, pRectCpy.Left + 5, pRectCpy.Top + 2, pData, Canvas.TextStyle);
    end;
end;

procedure TframeDocFilesMgr.dbGridFilesKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  i: integer;
begin
  if (key = VK_DELETE) and (Shift = [ssCtrl]) then
    if Dialogs.messageDlg(estbk_strmsg.SCDocDeleteFile, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin

      if TDbGrid(Sender).SelectedRows.Count = 0 then
        TDbGrid(Sender).SelectedRows.CurrentRowSelected := True;

      if TDbGrid(Sender).SelectedRows.Count > 0 then
        with TDbGrid(Sender).DataSource.DataSet do
          for i := 0 to TDbGrid(Sender).SelectedRows.Count - 1 do
          begin
            GotoBookmark(Pointer(TDbGrid(Sender).SelectedRows.Items[i]));
            dmodule.deleteDocumentFile(FieldByName('file_id').AsInteger);
          end;

      // --
      TDbGrid(Sender).DataSource.DataSet.Active := False;
      TDbGrid(Sender).DataSource.DataSet.Active := True;
    end;
end;

procedure TframeDocFilesMgr.btnNewFileClick(Sender: TObject);
begin
  if (pDialog.Execute) and (pDialog.Files.Count > 0) then
  begin
    dmodule.addDocumentFile(self.documentId, pDialog.Files.Strings[0]);
    qryFileList.Active := False;
    qryFileList.Active := True;
    btnOpenFile.Enabled := qryFileList.RecordCount > 0;
    dbGridFiles.DataSource := qryFileListDs;
  end;
end;

procedure TframeDocFilesMgr.btnCloseClick(Sender: TObject);
begin
  if assigned(onFrameKillSignal) then
    self.onFrameKillSignal(self);
end;

procedure TframeDocFilesMgr.btnOpenFileClick(Sender: TObject);
begin
  self.dbGridFilesDblClick(dbGridFiles);
end;



procedure TframeDocFilesMgr.dbGridFilesDblClick(Sender: TObject);

var
  i: integer;
  pdefFname: AStr;
  pTempStream: TMemoryStream;
  pFileStream: TFileStream;
  pTempFile: AStr;
begin
  if TDbGrid(Sender).SelectedRows.Count = 0 then
    TDbGrid(Sender).SelectedRows.CurrentRowSelected := True;

  // teeme koheselt toetuse mitmesele selectile, see võib tulevikus suht vajalik olla !
  if TDbGrid(Sender).SelectedRows.Count > 0 then
    with TDbGrid(Sender).DataSource.DataSet do
      for i := 0 to TDbGrid(Sender).SelectedRows.Count - 1 do
        try

          pTempStream := TMemoryStream.Create;
          GotoBookmark(Pointer(TDbGrid(Sender).SelectedRows.Items[i]));
          pdefFname := '';
          dmodule.readDocumentFile(FieldByName('file_id').AsInteger, pTempStream, pdefFname);

            {$IFDEF windows}
          pTempFile := getTempDirPath + 'tmp' + inttohex(random(100000), 10) + '_' + ExtractFilename(pdefFname);

          try
            pFileStream := TFileStream.Create(pTempFile, fmCreate);
            pTempStream.Seek(0, 0);
            pFileStream.CopyFrom(pTempStream, pTempStream.Size);
          finally
            FreeAndNil(pFileStream);
          end;

          ShellExecute(0, 'open', PChar(pTempFile), nil, nil, SW_SHOWNORMAL);
          pTempFiles.Add(pTempFile);
            {$ELSE}
          pSave.FileName := extractfilename(pdefFname);
          if pSave.Execute and (pSave.Files.Count > 0) then
            try
              pFileStream := TFileStream.Create(pSave.Files.Strings[0], fmCreate);
              pTempStream.Seek(0, 0);
              pFileStream.CopyFrom(pTempStream, pTempStream.Size);
            finally
              FreeAndNil(pFileStream);
            end;
            {$ENDIF}


          // 15.04.2015 Ingmar; ntx oli kaks faili, siis ilma selleta ei lubanud teist faili avada
          TDbGrid(Sender).SelectedRows.CurrentRowSelected := False;

          // ---
        finally
          FreeAndNil(pTempStream);
        end;
end;

procedure TframeDocFilesMgr.dbGridFilesPrepareCanvas(Sender: TObject; DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin
  // ---
  with TDbGrid(Sender) do
  begin
    if gdSelected in AState then
      Brush.Color := clBackGround
    else
    if (qryFileList.RecNo mod 2) <> 0 then
    begin
      Canvas.Brush.Color := estbk_types.MyFavGray;
    end
    else
    begin
      Canvas.Brush.Color := clWindow;
    end;
  end;
end;

function TframeDocFilesMgr.getDataLoadStatus: boolean;
begin
  Result := qryFileList.Active;
end;

procedure TframeDocFilesMgr.setDataLoadStatus(const v: boolean);
begin
  qryFileList.Close;
  qryFileList.SQL.Clear;

  if v then
  begin
    qryFileList.Connection := dmodule.primConnection;
    qryFileList.SQL.Add(estbk_sqlclientcollection._SQLSelectFilesByDocId);
    qryFileList.ParamByName('document_id').AsLargeInt := self.documentId;
    qryFileList.ParamByName('company_id').AsInteger := estbk_globvars.glob_company_id;
    qryFileList.Open;
    btnOpenFile.Enabled := qryFileList.RecordCount > 0;
    if qryFileList.RecordCount < 1 then
      dbGridFiles.DataSource := nil
    else
      dbGridFiles.DataSource := qryFileListDs;

  end
  else
    qryFileList.Connection := nil;
end;

constructor TframeDocFilesMgr.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
end;


destructor TframeDocFilesMgr.Destroy;
begin
  inherited Destroy;
end;


class procedure TframeDocFilesMgr.clearTempFiles;
var
  i: integer;
begin
  for i := 0 to pTempFiles.Count - 1 do
    SysUtils.DeleteFile(pTempFiles.Strings[i]);
end;

initialization
  {$I estbk_fra_docfilesmgr.ctrs}
  pTempFiles := TStringList.Create;

finalization
  TframeDocFilesMgr.clearTempFiles();
  FreeAndNil(pTempFiles);
end.