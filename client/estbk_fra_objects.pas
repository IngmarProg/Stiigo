unit estbk_fra_objects;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, DB, FileUtil, LResources, Forms, StdCtrls, Buttons,
  DBGrids, ExtCtrls, DBCtrls, Dialogs, Controls,
  ZDataset, ZSqlUpdate, ZSequence, LCLType,estbk_fra_template, estbk_uivisualinit,estbk_lib_commonevents,
  estbk_clientdatamodule, estbk_sqlclientcollection, estbk_globvars, estbk_utilities,
  estbk_types, estbk_strmsg;

type

  { TframeObjects }

  TframeObjects = class(Tfra_template)
    btnCancel:    TBitBtn;
    btnNewObject: TBitBtn;
    btnSave:      TBitBtn;
    cmbFilterByGrp: TComboBox;
    dbObjGrid: TDBGrid;
    edtSearchObject: TEdit;
    grpObjType:   TComboBox;
    dbEdtobjname: TDBEdit;
    lblFilt: TLabel;
    lblObjNimi:   TLabel;
    lblObjGrp:    TLabel;
    btnClose:     TBitBtn;
    lblSearch: TLabel;
    pgrpPanel: TPanel;
    panelLogSeparator: TPanel;
    qryObjDs:     TDatasource;
    grpBoxObjects: TGroupBox;
    qryObjects:   TZQuery;
    qryObjTypesMisc: TZQuery;
    qryObjInsUpt: TZUpdateSQL;
    qryObjSeq:    TZSequence;
    qryObjTypesSeq: TZSequence;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewObjectClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cmbFilterByGrpChange(Sender: TObject);
    procedure edtSearchObjectKeyPress(Sender: TObject; var Key: char);
    procedure edtSearchObjectUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure grpObjTypeChange(Sender: TObject);
    procedure grpObjTypeExit(Sender: TObject);
    procedure grpObjTypeKeyPress(Sender: TObject; var Key: char);
    procedure mrline4ChangeBounds(Sender: TObject);
    procedure qryObjectsAfterEdit(DataSet: TDataSet);
    procedure qryObjectsAfterPost(DataSet: TDataSet);
    procedure qryObjectsAfterScroll(DataSet: TDataSet);
    procedure qryObjectsBeforePost(DataSet: TDataSet);
    procedure qryObjectsBeforeScroll(DataSet: TDataSet);
  protected
    FDataIsNotSaved:   boolean;
    FNewObjectMode:    boolean;
    FSkipScrollEvents: boolean;
    FframeKillSignal:  TNotifyEvent;
    FParentKeyNotif:   TKeyNotEvent;
    FFrameDataEvent:   TFrameReqEvent;
    // --
    procedure loadComboData;
  private
    function   getDataLoadStatus: boolean;
    procedure  setDataLoadStatus(const v: boolean);
    procedure  addNewObjectGroupRequest;
  public
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  published // RTTI kala
    property onFrameKillSignal: TNotifyEvent Read FframeKillSignal Write FframeKillSignal;
    // saadame vanemale...
    // kuna frame ei võimalda keypreview'd, kasutame vanema võimalusi
    property onParentKeyPressNotif: TKeyNotEvent Read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent Read FFrameDataEvent Write FFrameDataEvent;
    // --------------
    property loadData: boolean Read getDataLoadStatus Write setDataLoadStatus;
  end;

implementation



function TframeObjects.getDataLoadStatus: boolean;
begin
  Result := qryObjects.active;
end;

procedure TframeObjects.setDataLoadStatus(const v: boolean);
begin
  qryObjects.Close;
  qryObjects.Connection := estbk_clientdatamodule.dmodule.primConnection;

  qryObjects.SQL.Clear;
  qryObjects.SQL.Add(estbk_sqlclientcollection._SQLGetAllObjectsExt);
  qryObjects.paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;

  qryObjTypesMisc.Close;
  qryObjTypesMisc.Connection := estbk_clientdatamodule.dmodule.primConnection;
  // -------

  qryObjInsUpt.ModifySQL.Clear;
  qryObjInsUpt.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdateObject);

  qryObjInsUpt.InsertSQL.Clear;
  qryObjInsUpt.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertObject);

  qryObjSeq.SequenceName := 'objects_id_seq';
  qryObjSeq.Connection   := estbk_clientdatamodule.dmodule.primConnection;

  qryObjTypesSeq.SequenceName := 'classificators_id_seq';
  qryObjTypesSeq.Connection   := estbk_clientdatamodule.dmodule.primConnection;

  qryObjects.sequencefield := 'id';
  qryObjects.active := v;
  // ---
  estbk_utilities.changeWCtrlEnabledStatus(self, not qryObjects.EOF);

  if v then
  begin
       grpBoxObjects.enabled:=True;

    if dbObjGrid.Enabled and  dbObjGrid.CanFocus and TWincontrol(self.Parent).Visible then
       dbObjGrid.SetFocus;

       self.loadComboData;
       // helistame iseendale
       self.qryObjectsAfterScroll(qryObjects);
  end
  else
    self.grpObjType.Clear;

end;

constructor TframeObjects.Create(frameOwner: TComponent);
begin
  // -------
  inherited Create(frameOwner);
  // -------
  estbk_uivisualinit.__preparevisual(self);
  //panelLogSeparator.Color:=estbk_types.MyFavOceanBlue;
end;

procedure TframeObjects.btnNewObjectClick(Sender: TObject);
begin
   estbk_utilities.changeWCtrlEnabledStatus(self, True);
   // filtrid ja stuff kinni
   estbk_utilities.changeWCtrlEnabledStatus(panelLogSeparator, False);
   // ------
   TBitBtn(Sender).Enabled := False;
   btnCancel.Enabled    := True;
   btnSave.Enabled      := True;
   //grpObjType.ItemIndex := -1;


   self.FNewObjectMode := True;
if grpObjType.ItemIndex<0 then
 begin
   if grpObjType.CanFocus then
      grpObjType.SetFocus;
 end else
if dbEdtobjname.CanFocus then
   dbEdtobjname.SetFocus;

 try
  FSkipScrollEvents:=true;
  qryObjects.Insert;
 finally
   FSkipScrollEvents:=false;
 end;
end;

procedure TframeObjects.btnCancelClick(Sender: TObject);
begin
  grpObjType.Text := '';
  qryObjects.CancelUpdates;
  //  qryObjects.Cancel;
  // TODO: vii kõik nuppude staatuse omistamised eventide alla; testversioonis võib nii olla
  btnNewObject.Enabled := True;
  btnCancel.Enabled    := False;
  btnSave.Enabled      := False;
  estbk_utilities.changeWCtrlEnabledStatus(panelLogSeparator, True);

  self.FDataIsNotSaved := False;
  self.FNewObjectMode  := False;
  // ----
  self.qryObjectsAfterScroll(qryObjects);
end;

procedure TframeObjects.btnCloseClick(Sender: TObject);
begin
  if assigned(FframeKillSignal) then
    FframeKillSignal(self);
end;

procedure TframeObjects.btnSaveClick(Sender: TObject);
var
  FCurrFltObjId: cardinal;
  i: integer;
  FntxSeqVal: int64;
begin
     FntxSeqVal := 0;
     FCurrFltObjId := 0;
     // ---

  if qryObjects.FieldByName('objtypeid').AsInteger=0 then
     grpObjTypeChange(grpObjType);

     // laseme ikka kirje üle kontrollida, kas kõik andmed saabunud !!!!
     self.qryObjectsBeforeScroll(qryObjects);



  // jätame hetke filtri meelde
  if cmbFilterByGrp.ItemIndex > 0 then
    FCurrFltObjId := cardinal(cmbFilterByGrp.Items.Objects[cmbFilterByGrp.ItemIndex])
  else
    FCurrFltObjId := 0;


  // ---
  with estbk_clientdatamodule.dmodule do
    try
      self.FSkipScrollEvents := True;
      // ----
      try
        primConnection.StartTransaction;

        qryObjects.ApplyUpdates;
        qryObjects.CommitUpdates;
        // ---
        primConnection.Commit;

        self.FDataIsNotSaved := False;
        self.FNewObjectMode  := False;

        // ---
        // Saadame signaali välja, et võiks andmeid ka mujal uuendada...
        if assigned(FFrameDataEvent) then
          FFrameDataEvent(self, __frameObjectAddedChanged, -1);

      except
        on e: Exception do
        begin
          if primConnection.inTransaction then
            try
              primConnection.Rollback
            except
            end;


          Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed,[e.message]), mtError, [mbOK], 0);
        end;
      end;
      // ---
    finally
      self.FSkipScrollEvents := False;
    end;



  if FCurrFltObjId = 0 then
    cmbFilterByGrp.ItemIndex := -1
  else
  begin
    // otsime uuesti õige indeksi üles
    // ---
    for i := 0 to cmbFilterByGrp.Items.Count - 1 do
      if cardinal(cmbFilterByGrp.Items.Objects[i]) = FCurrFltObjId then
      begin
        cmbFilterByGrp.ItemIndex := i;
        qryObjects.Filtered := False;
        qryObjects.Filter   := format('objtypeid=%d', [FCurrFltObjId]);
        qryObjects.Filtered := True;
        break;
      end;
  end; // --

   // ---------
   btnNewObject.Enabled := True;

if btnNewObject.CanFocus then
   btnNewObject.SetFocus;
   TBitBtn(Sender).Enabled := False;
   btnCancel.Enabled := False;
   estbk_utilities.changeWCtrlEnabledStatus(panelLogSeparator, True);

end;

procedure TframeObjects.cmbFilterByGrpChange(Sender: TObject);
begin
  // --
  with TCombobox(Sender) do
    if ItemIndex > 0 then
    begin
      qryObjects.Filtered := False;
      qryObjects.Filter   := Format('objtypeid=%d', [cardinal(items.Objects[ItemIndex])]);
      qryObjects.Filtered := True;
    end
    else
    begin
      qryObjects.Filtered := False;
      qryObjects.Filter   := '';
    end;

  self.qryObjectsAfterScroll(qryObjects);
end;

procedure TframeObjects.edtSearchObjectKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    Key := #0;
    Exit;
  end else
    edit_autoCompData(Sender As TCustomEdit,
                      Key,
                      qryObjects,
                      'objname');
end;


procedure TframeObjects.edtSearchObjectUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
begin
  // ---
end;


procedure TframeObjects.grpObjTypeChange(Sender: TObject);
var
  pNewEdt : boolean;
  pCmb    :    TComboBox;
begin

  if not self.FSkipScrollEvents and TComboBox(Sender).Focused then //  and TComboBox(Sender).Focused then
  try
        self.FSkipScrollEvents:=true;
        pCmb    := Sender as TComboBox;
        // peaks ehk lahti jätma, muidu pidev eventidega tõmblemine
        pNewEdt := not (qryObjects.state in [dsEdit, dsInsert]);
    if  pNewEdt then
        qryObjects.Edit;

    // ----
    if (pCmb.items.indexOf(pCmb.Text) >= 0) and (trim(pCmb.Text) <> '') then
    begin
      qryObjects.FieldByName('objtypeid').AsInteger :=cardinal(TComboBox(Sender).Items.Objects[TComboBox(Sender).ItemIndex]);
      qryObjects.FieldByName('objtype').AsString    := TComboBox(Sender).Text;
    end else
      qryObjects.FieldByName('objtype').AsString    := '';

    {
    else
    begin
      qryObjects.FieldByName('objtype').AsString    := '';
      qryObjects.FieldByName('objtypeid').AsInteger := 0;
    end;
    }
    // --
    if pNewEdt then
       qryObjects.Post;
    // ---
    //self.qryObjectsAfterScroll(qryObjects);
  finally
      self.FSkipScrollEvents:=false;
  end;
end;

procedure TframeObjects.addNewObjectGroupRequest;
var
  i          : Integer;
  pCmbVal    : AStr;
  pntxSeqVal : int64;
  pNewSession: boolean;
begin
     pCmbVal := trim(grpObjType.Text);
 if (pCmbVal <> '') and (grpObjType.items.indexOf(pCmbVal) = -1) then
 begin


   if Dialogs.MessageDlg(format(estbk_strmsg.SConfCreateNewObjGroup,[pCmbVal]), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
   begin
      self.qryObjectsAfterScroll(qryObjects);

   if grpObjType.CanFocus then
      grpObjType.SetFocus;
      grpObjType.DroppedDown := True;

      // --
      exit;
   end;


   // kas tulevikus peaks ehk nupu tegema loo grupp, mitte nii, et sisestab ja siis luuakse onlines...hmmm
   // samas selline meetod väga kiire ja mõnus
   with estbk_clientdatamodule.dmodule do
     try

       try
         self.FSkipScrollEvents := True;
         primConnection.StartTransaction;


         // vana hea sequence
         pntxSeqVal := qryObjTypesSeq.GetNextValue;

         qryObjTypesMisc.Close;
         qryObjTypesMisc.SQL.Clear;
         qryObjTypesMisc.SQL.Add(estbk_sqlclientcollection._CSQLInsertObjType);
         qryObjTypesMisc.parambyname('id').AsInteger     := pntxSeqVal;
         qryObjTypesMisc.parambyname('parent').AsInteger := 0;
         qryObjTypesMisc.parambyname('objname').AsString := pcmbVal;
         qryObjTypesMisc.parambyname('shortidef').AsString := '';
         qryObjTypesMisc.parambyname('weight').AsInteger := 0;
         qryObjTypesMisc.parambyname('company_id').AsInteger := estbk_globvars.glob_company_id;
         qryObjTypesMisc.ExecSQL;


         // ----------
         primConnection.Commit;


         grpObjType.Items.addObject(pcmbVal, TObject(cardinal(pntxSeqVal)));
         // nõme; generics alles 2.3.0 versioonis
         grpObjType.Sorted    := True;
         grpObjType.Sorted    := False;
         grpObjType.ItemIndex := grpObjType.items.indexOf(pcmbVal);

         // --- peame ka grupi lisama; reg. reziim, kui puudub...
         pNewSession := not (qryObjects.state in [dsEdit, dsInsert]);
      if pNewSession then
         qryObjects.Edit;



         // ---- onchange suht mõttetu; pidevalt tõmbaksime evente käime !
         qryObjects.FieldByName('objtypeid').AsInteger := pntxSeqVal;
         qryObjects.FieldByName('objtype').AsString    := grpObjType.Text;



      // sulgeme sisestuse ...
      if pNewSession then
         qryObjects.Post;


         // filtreerime
         cmbFilterByGrp.Items.Assign(grpObjType.Items);
         cmbFilterByGrp.Items.Insert(0, ' '); // tühi valik...

       finally
         self.FSkipScrollEvents := False;
         qryObjTypesMisc.Close;
         qryObjTypesMisc.SQL.Clear;
       end;

    // ---
    if dbEdtobjname.CanFocus then
       dbEdtobjname.SetFocus;
     except
       on e: Exception do
       begin
         if primConnection.inTransaction then
           try
             primConnection.Rollback;
           except
           end;

            Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]),mtError, [mbOK], 0);
       end;
     end;

   // ---------
 end
 else

 if pCmbVal = '' then
   for i := 0 to grpObjType.items.Count - 1 do
     if PtrInt(grpObjType.items.objects[i]) =PtrInt(qryObjects.FieldByName('objtypeid').AsInteger) then
     try
        self.FSkipScrollEvents:=true;
        // -----
     if pNewSession then
        qryObjects.Edit;


        qryObjects.FieldByName('objtype').AsString:=grpObjType.items.Strings[i];
        // --
        grpObjType.ItemIndex := i;
        grpObjType.Text:=grpObjType.items.Strings[i]; // imelik värk; item index ei aita igakord :(

     if pNewSession then
        qryObjects.Post;
        break;

     finally
        self.FSkipScrollEvents:=false;
     end;
     // --
end;


procedure TframeObjects.grpObjTypeExit(Sender: TObject);
begin
  self.addNewObjectGroupRequest;
end;

procedure TframeObjects.grpObjTypeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
  // ----------
end;

procedure TframeObjects.mrline4ChangeBounds(Sender: TObject);
begin

end;

procedure TframeObjects.qryObjectsAfterEdit(DataSet: TDataSet);
begin
  self.FDataIsNotSaved := True;
  btnSave.Enabled      := True;
  btnCancel.Enabled    := True;
end;

procedure TframeObjects.qryObjectsAfterPost(DataSet: TDataSet);
begin
  // filtreerimise paneel uuesti lubatud
  estbk_utilities.changeWCtrlEnabledStatus(panelLogSeparator, True);
  btnNewObject.Enabled := not self.FNewObjectMode;
end;

procedure TframeObjects.qryObjectsAfterScroll(DataSet: TDataSet);
var
  i: integer;
begin

  // selle evendiga välistame onchange evendi, mis võiks põhjustada rekursiooni
  if not FSkipScrollEvents then
    try
      self.FSkipScrollEvents := True;
      // ----------

      btnSave.Enabled      := self.FDataIsNotSaved;
      btnCancel.Enabled    := self.FDataIsNotSaved;
      btnNewObject.Enabled := not self.FNewObjectMode;
      // ----------
      self.FNewObjectMode  := False;


      if DataSet.FieldByName('objtypeid').AsInteger > 0 then
      begin
        // ---
        for i := 0 to grpObjType.Items.Count - 1 do
          if PtrInt(grpObjType.Items.Objects[i]) = PtrInt(DataSet.FieldByName('objtypeid').AsInteger) then
          begin
            grpObjType.ItemIndex := i;
            break;
          end;
      end
      else
        grpObjType.ItemIndex := -1;

    finally
      self.FSkipScrollEvents := False;
    end;
end;



procedure TframeObjects.qryObjectsBeforePost(DataSet: TDataSet);
begin
  if self.FNewObjectMode then
    dataSet.FieldByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;

  dataSet.FieldByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
  dataSet.FieldByName('rec_changed').AsDateTime  := now;
  dataSet.FieldByName('company_id').AsInteger    := estbk_globvars.glob_company_id;
end;

procedure TframeObjects.qryObjectsBeforeScroll(DataSet: TDataSet);
begin
 if not self.FSkipScrollEvents then
   begin
        // if (length(trim(qryObjects.FieldByName('objname').AsString)) < 1) then
        if DataSet.FieldByName('objtypeid').AsInteger < 1 then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEGrpNameIsMissing, mtError, [mbOK], 0);
          grpObjType.SetFocus;
          abort;
        end;


        if (length(trim(qryObjects.FieldByName('objname').AsString)) < 1) then
        begin
          Dialogs.messageDlg(estbk_strmsg.SEObjNameisMissing, mtError, [mbOK], 0);
          dbEdtobjname.SetFocus;
          abort;
        end;


      {
           if self.FDataIsNotSaved then
            begin
                 self.FDataIsNotSaved:=False;
              if dialogs.messageDlg(estbk_strmsg.SConfSaveChanges,mtconfirmation,[mbyes,mbno],0)=mrno then
                 self.btnCancelClick(btnCancel)
              else
                 self.btnSaveClick(btnSave);
              end;
      }
   end; // --
end;

 // ei aita meid DBCombo; ega lookupcombo, meil nö loose sisestus
 // Kui elementi pole, siis luuakse uus
procedure TframeObjects.loadComboData;
begin
  grpObjType.items.Clear;

  with qryObjTypesMisc, SQL do
    try
      self.FSkipScrollEvents := True;
      Close;
      Clear;
      Add(estbk_sqlclientCollection._CSQLObjectTypes);
      Open;
      // ---
      First;
      while not EOF do
      begin
        // järjekordselt ... välistame isegi võimatu olukorra...
        if FieldByName('id').AsInteger > 0 then
          grpObjType.items.addObject(trim(FieldByName('objname').AsString),
            TObject(cardinal(FieldByName('id').AsInteger)));
        Next;
      end;

      // ---
      grpObjType.ItemIndex := -1;
    finally
      Close;
      Clear;
      self.FSkipScrollEvents := False;
    end;

  // ---
  cmbFilterByGrp.Sorted := False;
  cmbFilterByGrp.Items.Assign(grpObjType.Items);
  cmbFilterByGrp.Items.Insert(0, ' '); // tühi valik...
  cmbFilterByGrp.Sorted := True;

end;

destructor TframeObjects.Destroy;
begin
  inherited Destroy;
end;


initialization
  {$I estbk_fra_objects.ctrs}

end.

