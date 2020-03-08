unit estbk_fra_personalcard;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, DbCtrls,
  Dialogs, ExtCtrls, EditBtn, Buttons, ComCtrls, DBGrids,estbk_fra_template,
  estbk_lib_commonevents, estbk_uivisualinit, estbk_lib_commoncls,
  estbk_clientdatamodule, estbk_sqlclientcollection, estbk_globvars,
  estbk_utilities, estbk_types, estbk_strmsg, db, ZDataset, ZSqlUpdate,
  ZSequence;

type

  { TframePersonalCard }

  TframePersonalCard = class(Tfra_template)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    bh3: TBevel;
    btnAddPicture: TSpeedButton;
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    btnNew: TBitBtn;
    btnSave: TBitBtn;
    bv3: TBevel;
    chkboxNonresident: TCheckBox;
    docTypeName: TDBComboBox;
    qryIdDocumentDs: TDatasource;
    dbCmbWorkerBank: TDBComboBox;
    dbCombGender: TDBComboBox;
    dbEditBankAccount: TDBEdit;
    dbEditBCountryname: TDBEdit;
    dbEditFirstname: TDBEdit;
    dbEditIdnr: TDBEdit;
    dbEditIssuer: TDBEdit;
    dbEditLastname: TDBEdit;
    dbEditMigPermitNr: TDBEdit;
    dbEditNationality: TDBEdit;
    dbEditPDocnr: TDBEdit;
    dbEditResCountryName: TDBEdit;
    dbEditWorkerAddr: TDBEdit;
    dbEditWorkerEMail: TDBEdit;
    dbEditWorkerPhone: TDBEdit;
    dbEditWorkerPostalIndx: TDBEdit;
    dbEditWorkPermitNr: TDBEdit;
    dbGridContracts: TDBGrid;
    DBMemo1: TDBMemo;
    dtBirthday: TDateEdit;
    dtIssuedDate: TDateEdit;
    dtValidUntil: TDateEdit;
    lblBankAccount: TLabel;
    lblBankName: TLabel;
    lblBirthday: TLabel;
    lblDocName: TLabel;
    lblDocPnr: TLabel;
    lblDocValidUntil: TLabel;
    lblEducation: TLabel;
    lblEmail: TLabel;
    lblFirstname: TLabel;
    lblGender: TLabel;
    lblIDNumber: TLabel;
    lblIssuer: TLabel;
    lblIssuer1: TLabel;
    lblLastname: TLabel;
    lblLastname1: TLabel;
    lblMigPermitNr: TLabel;
    lblNation: TLabel;
    lblNation1: TLabel;
    lblPhone: TLabel;
    lblPostalIndex: TLabel;
    lblRCountryname: TLabel;
    lblSec2: TLabel;
    lblWorkerPict: TLabel;
    lblWorkPermitNr: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    panelPictCont: TPanel;
    pmemoCont: TPanel;
    qryEmployeeDs: TDatasource;
    grpWorker: TGroupBox;
    qryEmployeeContracsDs: TDatasource;
    qryIdDocumentSeq: TZSequence;
    tabWorkerData: TTabSheet;
    tabWorkerContracts: TTabSheet;
    qryEmployee: TZQuery;
    qryUptInsEmployee: TZUpdateSQL;
    qryEmployeeSeq: TZSequence;
    qryIdDocument: TZQuery;
    qryTemp: TZQuery;
    qryUptInsIdDocument: TZUpdateSQL;
    workerPict: TImage;
    qryEmployeeContracs: TZReadOnlyQuery;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure chkboxNonresidentChange(Sender: TObject);
    procedure dbEditFirstnameKeyPress(Sender: TObject; var Key: char);
    procedure dbGridContractsDblClick(Sender: TObject);
    procedure dtBirthdayAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure dtBirthdayChange(Sender: TObject);
    procedure dtBirthdayExit(Sender: TObject);
    procedure dtIssuedDateAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure dtIssuedDateExit(Sender: TObject);
    procedure dtValidUntilChange(Sender: TObject);
    procedure qryEmployeeAfterEdit(DataSet: TDataSet);
    procedure qryEmployeeAfterInsert(DataSet: TDataSet);
    procedure qryEmployeeAfterScroll(DataSet: TDataSet);
    procedure qryEmployeeBeforePost(DataSet: TDataSet);
    procedure qryIdDocumentAfterEdit(DataSet: TDataSet);
    procedure qryIdDocumentAfterInsert(DataSet: TDataSet);
    procedure qryIdDocumentAfterScroll(DataSet: TDataSet);
    procedure qryIdDocumentBeforePost(DataSet: TDataSet);
    procedure btnAddPictureClick(Sender: TObject);
  private
    //FworkerId         : Integer;
    FLastWorkerId     : Integer;
    FNewRecord        : Boolean;
    FSkipQryEvents : Boolean;
    FframeKillSignal  : TNotifyEvent;
    FParentKeyNotif   : TKeyNotEvent;
    FFrameDataEvent   : TFrameReqEvent;
    function  getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure validateAndAssignDate(const Sender : TObject);
    procedure validateAndAssignIssuedDate(const Sender : TObject);
  public
    procedure   openPersonalCard(const pId : Integer);
    procedure   refreshContractData(); // !!
    procedure   createNewWorker();
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  // RTTI pole täielik, published puhul vaid erandid
  published
    // property workerId : Integer read FworkerId write FworkerId;
    property onFrameKillSignal     : TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData         : boolean read getDataLoadStatus write setDataLoadStatus;
  end; 

implementation
{
§ 2. Isikukaardile kantavad andmed

(1) Isikukaardile kantakse järgmised isikuandmed ja andmed töö kohta:
1) töötaja ees- ja perekonnanimi;
2) isikut tõendav dokument (nimetus, nr, väljaandja, väljaandmise ja kehtivuse aeg);
3) isikukood;
4) kontaktaadress, sihtnumber, telefoninumber, e-posti aadress;
5) ülalpeetavad ja nende isikukoodid;
6) haridustase (vastavalt haridusseadusele), eriala nimetus, lõpetatud haridusasutused ja nende lõpetamise aastad;
7) elamisloa kehtivusaeg (isikul, kes ei ole Eesti Vabariigi kodanik);
8) tööloa kehtivusaeg (isikul, kellel Eestis töötamiseks peab olema tööluba);
9) ametinimetus(ed) ja kood(id) ametite klassifikaatori alusel;
10) tööle asumise aeg;
11) töösuhte lõpetamise aeg ja alus.

(2) Täiendavaid isikuandmeid võib töötajalt nõuda ja isikukaardile kanda töötaja nõusolekul või juhul, kui nende nõudmise õigus tuleneb muudest seadustest.

(3) Käesoleva paragrahvi lõike 1 punktides 1–3, 5–8 nõutud andmed kantakse isikukaardile töötaja poolt esitatud dokumentide alusel.
}
procedure   TframePersonalCard.refreshContractData();
begin
 if qryEmployee.Active then
 with qryEmployeeContracs,SQL do
  begin
    close;
    clear;
    add(estbk_sqlclientcollection._SQLSelectWorkContract2);
    paramByname('employee_id').AsInteger:=qryEmployee.FieldByName('id').AsInteger;
    paramByname('company_id').AsInteger:=estbk_globvars.glob_company_id;
    open;
  end;
end;

procedure   TframePersonalCard.createNewWorker();
begin
  if btnNew.Enabled then
     btnNew.OnClick(btnNew);
end;

procedure   TframePersonalCard.openPersonalCard(const pId : Integer);
begin

     estbk_utilities.changeWCtrlEnabledStatus(grpWorker,false,0);
     grpWorker.Enabled:=false;
     btnAddPicture.Enabled:=false;
     // _SQLSelectEmployee
     qryEmployee.Close;
     qryEmployee.ParamByName('id').AsInteger:=pId;
     qryEmployee.ParamByName('company_id').AsInteger:=estbk_globvars.glob_company_id;
     qryEmployee.Open;

  if not qryEmployee.eof then
   try
     self.FSkipQryEvents:=true;
     estbk_utilities.changeWCtrlEnabledStatus(grpWorker,true,0);
     grpWorker.Enabled:=true;
     btnAddPicture.Enabled:=true;

     // ---
     qryIdDocument.Close;
     qryIdDocument.SQL.Clear;
     qryIdDocument.SQL.Add(estbk_sqlclientcollection._SQLSelectMaxIdDocument);
     qryIdDocument.ParamByName('employee_id').AsInteger:=pId; // -- qryEmployee.FieldByName('id').AsInteger;
     qryIdDocument.Open;

     self.FLastWorkerId:=pId;
   finally
     self.FSkipQryEvents:=false;

     // - et ikka event tekiks ka !
     qryEmployeeAfterScroll(qryEmployee);
     qryIdDocumentAfterScroll(qryIdDocument);
   end;

     self.refreshContractData();
     btnNew.Enabled:=true;
     btnSave.Enabled:=false;
     btnCancel.Enabled:=false;
end;

constructor TframePersonalCard.Create(frameOwner: TComponent);
var
  pClfType : TIntIDAndCTypes;
begin
  inherited create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
  dbCombGender.Items.Add(estbk_strmsg.SCGenderMID);
  dbCombGender.Items.Add(estbk_strmsg.SCGenderFID);
  // --
  PageControl1.ActivePage:=tabWorkerData;
  estbk_utilities.changeWCtrlEnabledStatus(grpWorker,false,0);
  grpWorker.Enabled:=true;
  btnAddPicture.Enabled:=false;
end;

destructor TframePersonalCard.destroy;
begin
  estbk_utilities.clearComboObjects(TCombobox(docTypeName));
  inherited destroy;
end;

procedure TframePersonalCard.qryEmployeeAfterScroll(DataSet: TDataSet);
var
  pdate : TDatetime;
  b : Boolean;
begin

if DataSet.Active and not self.FSkipQryEvents then
 begin
    chkboxNonresident.Checked:=ansilowercase(DataSet.FieldByName('nonresident').AsString)=SCFalseTrue[false];
 if DataSet.FieldByName('byear').AsInteger>1900 then
   begin
    pDate:=now;
    b:=tryEncodeDate(DataSet.FieldByName('byear').AsInteger,
                     DataSet.FieldByName('bmonth').AsInteger,
                     DataSet.FieldByName('bday').AsInteger,
                     pdate);
    assert(b,'#1');
    dtBirthday.Date:=pDate;
    dtBirthday.Text:=datetoStr(pDate);
   end;
 // ---
 end;
end;

procedure TframePersonalCard.qryEmployeeAfterInsert(DataSet: TDataSet);
begin
   DataSet.FieldByName('code').AsString:='';
   DataSet.FieldByName('flags').AsInteger:=0; // reserveeritud
   DataSet.FieldByName('nonresident').AsString:=SCFalseTrue[false];
   // --
   btnNew.Enabled:=false;
   btnSave.Enabled:=true;
   btnCancel.Enabled:=true;
   self.FNewRecord:=true;
end;


procedure TframePersonalCard.validateAndAssignDate(const Sender : TObject);
var
  pStr        : AStr;
  cval        : TDatetime;
  pNewSession : Boolean;
  pday,pmonth,pyear : Word;
begin

       // ---
       pStr:=trim(TEdit(Sender).Text);
    if pStr<>'' then
      begin


        if not estbk_utilities.validateMiscDateEntry(pStr,cval) then
          begin
             dialogs.messageDlg(estbk_strmsg.SEInvalidDate,mterror,[mbOk],0);
          if TEdit(Sender).CanFocus then
             TEdit(Sender).setFocus;
          end else
             TEdit(Sender).Text:=datetostr(cval);

        if   Sender=dtBirthday then
         try
             pNewSession:=not (qryEmployee.State in [dsEdit,dsInsert]);
          if pNewSession then
             qryEmployee.Edit;

             // ---
             decodeDate(cval,pyear, pmonth, pday);
             qryEmployee.FieldByName('bday').AsInteger:=pday;
             qryEmployee.FieldByName('bmonth').AsInteger:=pmonth;
             qryEmployee.FieldByName('byear').AsInteger:=pyear;

             // jah, aga dokumendid on meil eraldi
         finally
         if pNewSession then
            qryEmployee.Post;
         end else
        if (Sender=dtIssuedDate) or (Sender=dtValidUntil) then
         try
             pNewSession:=not (qryIdDocument.State in [dsEdit,dsInsert]);
         if (Sender=dtIssuedDate) then
             qryIdDocument.FieldByName('issued').AsString:=estbk_utilities.datetoOdbcStr(cval)
         else
             qryIdDocument.FieldByName('valid_until').AsString:=estbk_utilities.datetoOdbcStr(cval);
         finally
         if pNewSession then
            qryIdDocument.Post;
         end;
         // ----
      end else
      begin

      if Sender=dtBirthday then
         try
             pNewSession:=not (qryEmployee.State in [dsEdit,dsInsert]);
          if pNewSession then
             qryEmployee.Edit;
             qryEmployee.FieldByName('bday').AsInteger:=0;
             qryEmployee.FieldByName('bmonth').AsInteger:=0;
             qryEmployee.FieldByName('byear').AsInteger:=0;
         finally
         if pNewSession then
            qryEmployee.Post;
         end else
         if (Sender=dtIssuedDate) or (Sender=dtValidUntil) then
         try
              pNewSession:=not (qryIdDocument.State in [dsEdit,dsInsert]);
          if (Sender=dtIssuedDate) then
              qryIdDocument.FieldByName('issued').Value:=null
          else
              qryIdDocument.FieldByName('valid_until').Value:=null;
         finally
         if pNewSession then
            qryIdDocument.Post;
         end;
      // ---
      end;
end;

procedure TframePersonalCard.dtBirthdayExit(Sender: TObject);
begin
    self.validateAndAssignDate(Sender);
end;

procedure TframePersonalCard.dtIssuedDateAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
   AcceptDate:=ADate<now;
if AcceptDate then
  begin
    TDateEdit(Sender).Text:=datetostr(ADate);
    self.validateAndAssignIssuedDate(Sender);
  end;
end;


procedure TframePersonalCard.validateAndAssignIssuedDate(const Sender : TObject);
var
  pNewSession : Boolean;
  pStr        : AStr;
  cval        : TDatetime;
begin
       // ---
       pStr:=trim(TEdit(Sender).Text);

    try
       pNewSession:=not (qryIdDocument.State in [dsEdit,dsInsert]);
    if pNewSession then
       qryIdDocument.Edit;

    if pStr<>'' then
     begin
        // ---
        if not estbk_utilities.validateMiscDateEntry(pStr,cval) then
          begin
             dialogs.messageDlg(estbk_strmsg.SEInvalidDate,mterror,[mbOk],0);
          if TEdit(Sender).CanFocus then
             TEdit(Sender).setFocus;
          end else
             TEdit(Sender).Text:=datetostr(cval);
          if Sender = dtIssuedDate then
              qryIdDocument.FieldByName('issued').asDateTime:=cval
          else
          if Sender = dtValidUntil then
             qryIdDocument.FieldByName('valid_until').asDateTime:=cval;
     end else
     begin
     if Sender = dtIssuedDate then
        qryIdDocument.FieldByName('issued').Value:=null
     else
     if Sender = dtValidUntil then
        qryIdDocument.FieldByName('valid_until').Value:=null
     end;



    finally
    if pNewSession then
       qryIdDocument.Post;
    end;
end;

procedure TframePersonalCard.dtIssuedDateExit(Sender: TObject);
begin
  self.validateAndAssignIssuedDate(Sender);
end;

procedure TframePersonalCard.dtValidUntilChange(Sender: TObject);
begin

end;


procedure TframePersonalCard.qryEmployeeAfterEdit(DataSet: TDataSet);
begin
   btnNew.Enabled:=false;
   btnSave.Enabled:=true;
   btnCancel.Enabled:=true;

if not self.FNewRecord and (DataSet.FieldByname('id').AsInteger<1) then
   self.FNewRecord:=true;
end;

procedure TframePersonalCard.dbEditFirstnameKeyPress(Sender: TObject;
  var Key: char);
begin
 if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframePersonalCard.dbGridContractsDblClick(Sender: TObject);
begin
 if assigned(onFrameDataEvent) then
  if (qryEmployee.FieldByname('id').AsInteger>0) and (qryEmployeeContracs.RecordCount<1) then
   begin
       self.onFrameDataEvent(self,__frameReqCreateNewContractEntry,qryEmployee.FieldByname('id').AsInteger,nil);
   end else
  if   qryEmployeeContracs.FieldByName('id').AsInteger>0 then
       self.onFrameDataEvent(self,__frameOpenWorkContractEntry, qryEmployeeContracs.FieldByName('id').AsInteger,nil);
end;

procedure TframePersonalCard.dtBirthdayAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
   AcceptDate:=ADate<now;
if AcceptDate then
 begin
   TDateEdit(Sender).Text:=Datetostr(ADate);
   self.validateAndAssignDate(Sender); // datasetis ka paika asjad !
 end;
end;

procedure TframePersonalCard.dtBirthdayChange(Sender: TObject);
begin
// kui nupust valitakse kuupäev, siis onexit eventi ei teki !!
// if TDateEdit(Sender).Focused then
//if not self.FSkipQryEvents and not TDateEdit(Sender).Focused then
//   self.dtBirthdayExit(Sender);
end;

procedure TframePersonalCard.chkboxNonresidentChange(Sender: TObject);
var
  pNewSession : Boolean;
begin
 with TCheckBox(Sender) do
   if Focused then
     try
        pNewSession:=not (qryEmployee.State in [dsEdit,dsInsert]);
     if pNewSession then
        qryEmployee.Edit;
        // kompatiibluse pärast ei saa TDBCheckboxi kasutada !
        qryEmployee.FieldByName('nonresident').AsString:=estbk_types.SCFalseTrue[checked];

     finally
     // --
     if pNewSession then
        qryEmployee.Post;
     end;
end;

procedure TframePersonalCard.btnNewClick(Sender: TObject);
begin
 try
    tabWorkerContracts.Visible:=false;
    PageControl1.ActivePage:=tabWorkerData;

    self.FSkipQryEvents:=true;
    self.FNewRecord:=true;
    // ---
    chkboxNonresident.Checked:=false;
    dtBirthday.Date:=now;
    dtBirthday.Text:='';

    dtIssuedDate.Date:=now;
    dtIssuedDate.Text:='';

    dtValidUntil.Date:=now;
    dtValidUntil.Text:='';

    estbk_utilities.changeWCtrlEnabledStatus(grpWorker,true,0);
    grpWorker.Enabled:=true;
    btnAddPicture.Enabled:=true;

    // hetkel nii, et vanade dokumentide ajalugu ei hoia, muidu on meil võimalus hoida N dokumendi ajalugu
    // kui vaja siis teeme N kirje võimaluse
    qryIdDocument.Close;
    qryIdDocument.SQL.Clear;
    qryIdDocument.SQL.Add(estbk_sqlclientcollection._SQLSelectIdDocument);
    qryIdDocument.ParamByName('id').AsInteger:=0;
    qryIdDocument.Open;

    qryIdDocument.Insert;

    qryEmployee.Close;
    qryEmployee.ParamByName('id').AsInteger:=0;
    qryEmployee.ParamByName('company_id').AsInteger:=0;
    qryEmployee.Open;

    qryEmployee.Insert;

    // tühjendame lepingud !
    self.refreshContractData();

    dbCombGender.ItemIndex:=-1;
    docTypeName.ItemIndex:=-1;


 if dbEditFirstname.CanFocus then
    dbEditFirstname.SetFocus;
 finally
    self.FSkipQryEvents:=false;
 end;
 // ----
end;

procedure TframePersonalCard.btnCancelClick(Sender: TObject);
begin
    try
       self.FSkipQryEvents:=true;

       dtBirthday.Text:='';
       dtIssuedDate.Text:='';
       dtValidUntil.Text:='';
       // --

    if self.FLastWorkerId<1 then
      begin
         estbk_utilities.changeWCtrlEnabledStatus(grpWorker,not qryEmployee.eof,0);
         btnAddPicture.Enabled:=not qryEmployee.eof;
         grpWorker.Enabled:=true;
         self.FNewRecord:=false;

      if qryEmployee.Active then
         qryEmployee.CancelUpdates;

      if qryIdDocument.Active then
         qryIdDocument.CancelUpdates;
     end else
       self.openPersonalCard(self.FLastWorkerId);

       btnNew.Enabled:=true;
       btnSave.Enabled:=false;
       btnCancel.Enabled:=false;

    finally
       self.FSkipQryEvents:=false;
    end;
end;


procedure TframePersonalCard.btnCloseClick(Sender: TObject);
begin
  if assigned(self.FframeKillSignal) then
     self.FframeKillSignal(self);
end;

procedure TframePersonalCard.btnSaveClick(Sender: TObject);
var
  pDummy   : TDatetime;
  pIdDocId : Integer;
  pEmployeeId : Integer;
  pYear,pMonth,pDay : Integer;
begin
 // ---
 if dbEditIdnr.Text<>'' then
 with qryTemp,SQL do
  try
     close;
     clear;
     add(estbk_sqlclientcollection._SQLSelectEmployeeRegCode);
     paramByname('company_id').AsInteger:=estbk_globvars.glob_company_id;
     paramByname('personal_idnr').AsString:=dbEditIdnr.Text;
  if self.FNewRecord then
     paramByname('id').value:=null
  else
     paramByname('id').asInteger:=qryEmployee.FieldByname('id').AsInteger;
     open;
  if not eof then
    begin
     dialogs.MessageDlg(estbk_strmsg.SEWrkIDNrAlreadyExists,MtError,[mbOk],0);
     exit;
    end;
    // ---
  finally
     close;
     clear;
  end;


 if trim(qryEmployee.FieldByName('firstname').AsString)='' then
  begin
    dialogs.MessageDlg(estbk_strmsg.SEWrkFirstnameIsMissing,MtError,[mbOk],0);
    Exit;
  end;

 if trim(qryEmployee.FieldByName('lastname').AsString)='' then
  begin
    dialogs.MessageDlg(estbk_strmsg.SEWrkLastnameIsMissing,MtError,[mbOk],0);
    Exit;
  end;


     pYear:=qryEmployee.FieldByName('byear').AsInteger;
     pMonth:=qryEmployee.FieldByName('bmonth').AsInteger;
     pDay:=qryEmployee.FieldByName('bday').AsInteger;
     pDummy:=now;
  if not tryEncodeDate(pYear,
                       pMonth,
                       pDay,
                       pDummy) then
  begin
    dialogs.MessageDlg(estbk_strmsg.SEWrkBirthDayIsMissing,MtError,[mbOk],0);
    Exit;
  end;

 if trim(dbCombGender.Text)='' then
  begin
    dialogs.MessageDlg(estbk_strmsg.SEWrkGenderIsMissing,MtError,[mbOk],0);
    Exit;
  end;


 if trim(qryEmployee.FieldByName('bankaccount').AsString)='' then
  begin
    dialogs.MessageDlg(estbk_strmsg.SEWrkBankAccIsMissing,MtError,[mbOk],0);
    Exit;
  end;

 // ----
 with estbk_clientdatamodule.dmodule do
  try

  // if assigned(FFrameDataEvent) then
  //  FFrameDataEvent(self,__frameArticleDataChanged,-1);
      dmodule.primConnection.StartTransaction;

  if  self.FNewRecord then
     begin
      pEmployeeId:=qryEmployeeSeq.GetNextValue;
      pIdDocId:=qryIdDocumentSeq.GetNextValue;

      qryEmployee.Edit;
      qryEmployee.FieldByName('id').AsInteger:=pEmployeeId;
      qryEmployee.Post;

      // --
      qryIdDocument.FieldByName('id').AsInteger:=pIdDocId;
      qryIdDocument.FieldByName('employee_id').AsInteger:=pEmployeeId;
     end;



      qryEmployee.ApplyUpdates;
      qryIdDocument.ApplyUpdates;


      // --
      dmodule.primConnection.Commit;

      qryIdDocument.CommitUpdates;
      qryEmployee.CommitUpdates;

      // --
      self.FLastWorkerId:=0;
      self.FNewRecord:=false;
      btnNew.Enabled:=true;
      btnSave.Enabled:=false;
      btnCancel.Enabled:=false;
      tabWorkerContracts.Visible:=true;

  except on e : exception do
    begin
    if  primConnection.inTransaction then
    try primConnection.Rollback; except end;
    if  not (e is eabort) then
        dialogs.messageDlg(format(estbk_strmsg.SESaveFailed,[e.message]),mtError,[mbok],0);
    end;
  end;
  // --
end;

procedure TframePersonalCard.qryEmployeeBeforePost(DataSet: TDataSet);
begin
  // --
    if self.FNewRecord then
     begin
       DataSet.FieldByName('rec_addedby').AsInteger:=estbk_globvars.glob_worker_id;
       DataSet.FieldByName('company_id').AsInteger:=estbk_globvars.glob_company_id;
     end;

       // --
       DataSet.FieldByName('rec_changedby').AsInteger:=estbk_globvars.glob_worker_id;
       DataSet.FieldByName('rec_changed').AsDateTime:=now;
end;

procedure TframePersonalCard.qryIdDocumentAfterEdit(DataSet: TDataSet);
begin
   btnNew.Enabled:=false;
   btnSave.Enabled:=true;
   btnCancel.Enabled:=true;
end;

procedure TframePersonalCard.qryIdDocumentAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('doc_name').AsString:='';
  DataSet.FieldByName('doc_nr').AsString:='';
  DataSet.FieldByName('doc_descr').AsString:='';
  DataSet.FieldByName('flags').AsInteger:=0;
  DataSet.FieldByName('company_id').AsInteger:=estbk_globvars.glob_company_id;
end;

procedure TframePersonalCard.qryIdDocumentAfterScroll(DataSet: TDataSet);
begin

  if DataSet.Active and (DataSet.Recordcount>0) and not self.FSkipQryEvents then
     begin

       if not DataSet.FieldByName('issued').IsNull then
         begin
          dtIssuedDate.Date:=DataSet.FieldByName('issued').AsDateTime;
          dtIssuedDate.Text:=datetostr(dtIssuedDate.Date);
         end else
         begin
          dtIssuedDate.Date:=now;
          dtIssuedDate.Text:='';
         end;

       // ---
       if not DataSet.FieldByName('valid_until').IsNull then
         begin
          dtValidUntil.Date:=DataSet.FieldByName('valid_until').AsDateTime;
          dtValidUntil.Text:=datetostr(dtValidUntil.Date);
         end else
         begin
          dtValidUntil.Date:=now;
          dtValidUntil.Text:='';
         end;
     end;
end;

procedure TframePersonalCard.qryIdDocumentBeforePost(DataSet: TDataSet);
begin
    self.qryEmployeeBeforePost(DataSet);
end;

procedure TframePersonalCard.btnAddPictureClick(Sender: TObject);
begin
   // qryIdDocumentAfterEdit
end;

function  TframePersonalCard.getDataLoadStatus: boolean;
begin
     result:=qryEmployee.Active;
end;

procedure TframePersonalCard.setDataLoadStatus(const v: boolean);
var
   pClfType: TIntIDAndCTypes;
begin
     qryEmployee.Active:=false;
     qryUptInsEmployee.InsertSQL.Clear;
     qryUptInsEmployee.ModifySQL.Clear;
     qryUptInsIdDocument.InsertSQL.Clear;
     qryUptInsIdDocument.ModifySQL.Clear;
     qryEmployee.SQL.Clear;
     qryIdDocument.SQL.Clear;

  if v then
   begin
     qryEmployeeContracs.Connection:=estbk_clientdatamodule.dmodule.primConnection;
     qryTemp.Connection:=estbk_clientdatamodule.dmodule.primConnection;
     qryIdDocument.Connection:=estbk_clientdatamodule.dmodule.primConnection;
     qryIdDocumentSeq.Connection:=estbk_clientdatamodule.dmodule.primConnection;
     qryEmployee.Connection:=estbk_clientdatamodule.dmodule.primConnection;
     qryEmployeeSeq.Connection:=estbk_clientdatamodule.dmodule.primConnection;

     qryEmployee.SQL.Add(estbk_sqlclientcollection._SQLSelectEmployee);
     qryIdDocument.SQL.Add(estbk_sqlclientcollection._SQLSelectIdDocument);

     qryUptInsEmployee.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertEmployee);
     qryUptInsEmployee.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdateEmployee);

     qryUptInsIdDocument.InsertSQL.Add(estbk_sqlclientcollection._SQLInsertIdDocument);
     qryUptInsIdDocument.ModifySQL.Add(estbk_sqlclientcollection._SQLUpdateIdDocument);

     // 0 dataset
     qryEmployee.ParamByname('id').AsInteger:=0;
     qryEmployee.ParamByname('company_id').AsInteger:=0;
     qryEmployee.Open;


     qryIdDocument.ParamByName('id').AsInteger:=0;
     qryIdDocument.Open;

     // --
     estbk_utilities.clearComboObjects(TCombobox(docTypeName));
with qryTemp,SQL do
      try
            close;
            clear;
            add(estbk_sqlclientcollection._CSQLSelectFromClassificator);
            paramByname('company_id').AsInteger:=0;
            paramByname('clftype').AsString:=estbk_types.CDocWorkerIDDocTypes;
            open;
      while not eof do
        begin
            pClfType:=TIntIDAndCTypes.Create;
            pClfType.id:=fieldByname('id').AsInteger;
            pClfType.clf:=fieldByname('shortidef').AsString;
            docTypeName.AddItem(fieldByname('clfname').AsString,pClfType);
            next;
        end;
        // --
      finally
         close;
         clear;
      end;
      // ---


   end else
   begin
     qryEmployeeContracs.Connection:=nil;
     qryTemp.Connection:=nil;
     qryEmployee.Connection:=nil;
     qryEmployeeSeq.Connection:=nil;
     qryIdDocument.Connection:=nil;
     qryIdDocumentSeq.Connection:=nil;
   end;
     // ---
     qryEmployee.Active:=v;
end;

initialization
  {$I estbk_fra_personalcard.ctrs}

end.

