unit estbk_fra_genledgerentrys;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}
interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms,
  LCLType, StdCtrls, DBGrids, ExtCtrls, EditBtn, Buttons,StrUtils,estbk_fra_template,
  estbk_uivisualinit,estbk_clientdatamodule,estbk_lib_commonaccprop,
  estbk_sqlclientcollection, estbk_globvars, estbk_utilities,estbk_lib_commoncls,estbk_lib_commonevents,Graphics,
  estbk_types, estbk_strmsg, db, ZDataset, Controls, Grids;

type

  { TframeGenLedgerEntrys }

  TframeGenLedgerEntrys = class(Tfra_template)
    accEntrys: TDBGrid;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    btnDoSearch: TBitBtn;
    btnClose: TBitBtn;
    btnClear: TBitBtn;
    btnNewPayment: TBitBtn;
    btnOpen: TBitBtn;
    cmbDocTypes: TComboBox;
    lblAccType: TLabel;
    pmainPanel: TPanel;
    qryAccEntrysds: TDatasource;
    lblDateEdit: TDateEdit;
    lblEdtDocNr: TLabeledEdit;
    lblDate: TLabel;
    ldlEdtDescr: TLabeledEdit;
    lblEdtEntrynr: TLabeledEdit;
    grpBoxAccEntrys: TGroupBox;
    qryAccEntrys: TZQuery;
    procedure accEntrysDblClick(Sender: TObject);
    procedure accEntrysDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure accEntrysKeyPress(Sender: TObject; var Key: char);
    procedure accEntrysPrepareCanvas(sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure btnClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDoSearchClick(Sender: TObject);
    procedure btnNewPaymentClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure lblDateEditExit(Sender: TObject);
    procedure lblEdtEntrynrKeyPress(Sender: TObject; var Key: char);
    procedure mr2ChangeBounds(Sender: TObject);
  protected
    FSearchPerformed : Boolean;
    FframeKillSignal : TNotifyEvent;
    FParentKeyNotif  : TKeyNotEvent;
    FFrameDataEvent  : TFrameReqEvent;
    function  getDataLoadStatus:Boolean;
    procedure setDataLoadStatus(const v : Boolean);
  public
    procedure   refreshList;
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  published // RTTI
    property    onParentKeyPressNotif : TKeyNotEvent   read  FParentKeyNotif; // vanem teavitab
    property    onFrameKillSignal     : TNotifyEvent   read FframeKillSignal write FframeKillSignal;
    property    onFrameDataEvent      : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    // --------
    property    loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end; 

implementation
uses dialogs;
const
   Col_Sum = 4;


procedure TframeGenLedgerEntrys.lblEdtEntrynrKeyPress(Sender: TObject; var Key: char);
begin
 if key=#13 then
   begin
    SelectNext(Sender as twincontrol, True, True);
    key:=#0;
   end;
end;

procedure TframeGenLedgerEntrys.mr2ChangeBounds(Sender: TObject);
begin

end;



procedure TframeGenLedgerEntrys.btnCloseClick(Sender: TObject);
begin
  if assigned(onFrameKillSignal) then
     onFrameKillSignal(self);
end;

procedure TframeGenLedgerEntrys.accEntrysKeyPress(Sender: TObject; var Key: char);
begin
   if key=#13 then
     begin
      self.btnOpenClick(btnOpen);
      key:=#0;
     end;
end;

procedure TframeGenLedgerEntrys.accEntrysPrepareCanvas(sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin

  //  TDbGrid(sender).Canvas.Brush.Color:=clred;
if assigned(TDbGrid(sender).DataSource) and
//  (DataCol=TDbGrid(sender).Columns.Count)    and
  (pos('C',ansiuppercase(TDbGrid(sender).dataSource.Dataset.fieldbyname('accbrectype').asString))>0) and
  not (gdSelected in AState) then
  TDbGrid(sender).Canvas.Brush.Color:=estbk_types.MyFavGray;

end;

procedure TframeGenLedgerEntrys.btnClearClick(Sender: TObject);
begin

  lblEdtEntrynr.text:='';
  lblDateEdit.text:='';
  lblEdtDocNr.text:='';
  ldlEdtDescr.text:='';
  lblEdtEntrynr.setFocus;

  // ja olemegi piirangutest lahti...
  if  self.FSearchPerformed then
    begin
     self.loadData:=false;
     self.loadData:=true;
    end;

  // ---
  cmbDocTypes.itemIndex:=0;
end;

procedure TframeGenLedgerEntrys.accEntrysDblClick(Sender: TObject);
begin
  self.btnOpenClick(btnOpen);
end;

procedure TframeGenLedgerEntrys.accEntrysDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  p : TTextStyle;

begin
 with TDbGrid(sender) do
   begin
       Canvas.FillRect(Rect);
       p:=Canvas.TextStyle;
       p.Alignment := taLeftJustify;
       Canvas.TextStyle:=p;

    if DataCol=Col_Sum then
      begin
       p:=Canvas.TextStyle;
       p.Alignment := taRightJustify;
       Canvas.TextStyle:=p;

       Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,trim(format(estbk_types.CCurrentMoneyFmt2,[Column.Field.asFloat]))+#32,Canvas.TextStyle);
      end else
       DefaultDrawColumnCell(rect,datacol,column,state);
  end;
end;

// TODO kaotada ära see imelik bitmaski loogika, sai algselt teise eesmärgiga tehtud !
procedure TframeGenLedgerEntrys.btnDoSearchClick(Sender: TObject);
var
 pSql   : AStr;
 pSMask : SmallInt;
begin
   // ----
       pSMask:=0;
  if  (trim(lblEdtEntrynr.Text)<>'') then
       pSMask:=pSMask or 1;

  if  (trim(lblDateEdit.Text)<>'') then
       pSMask:=pSMask or 2;

  if  (trim(lblEdtDocNr.Text)<>'') then
       pSMask:=pSMask or 4;

  if  (trim(ldlEdtDescr.Text)<>'') then
       pSMask:=pSMask or 8;



 {
  if  pSMask=0 then
   begin
     dialogs.messageDlg(estbk_strmsg.SEMissingSrcCriterias,mterror,[mbOk],0);
     lblEdtEntrynr.setFocus;
     exit;
   end;

  if ((pSMask and 1)=1) and (strtointdef(lblEdtEntrynr.Text,-1)<1) then
   begin
     dialogs.messageDlg(estbk_strmsg.SEIncorrectCriteria,mterror,[mbOk],0);
     lblEdtEntrynr.setFocus;
     exit;
   end;
   }

  if  ((pSMask and 2)=2) and (strtodatedef(lblDateEdit.Text,now+1)>now) then
   begin
     dialogs.messageDlg(estbk_strmsg.SEIncorrectCriteria,mterror,[mbOk],0);
     lblDateEdit.setFocus;
     exit;
   end;



    // ---------------
    // sooritame uuesti päringu
    qryAccEntrys.close;
    qryAccEntrys.SQL.clear;


    pSql:='';
 if((pSMask and 1)=1) then
    pSql:=pSql+' AND a.entrynumber=:entrynumber ';

 if((pSMask and 2)=2) then
    pSql:=pSql+' AND a.transdate=:transdate ';

 if((pSMask and 4)=4) then
    pSql:=pSql+' AND e.document_nr=:document_nr ';

 if((pSMask and 8)=8) then
    pSql:=pSql+' AND a.transdescr like :transdescr ';


 // 15.05.2011 Ingmar
 if cmbDocTypes.itemIndex>0  then
    pSql:=pSql+format(' AND e.document_type_id=%d ',[Ptrint(cmbDocTypes.Items.Objects[cmbDocTypes.ItemIndex])]);



    qryAccEntrys.SQL.add(estbk_sqlclientcollection._CSQLSelectGenLedgerEntrys(pSql,true));
    // ----------------
    qryAccEntrys.paramByname('company_id').asInteger:=estbk_globvars.glob_company_id;

 if((pSMask and 1)=1) then
    qryAccEntrys.paramByname('entrynumber').asString:=copy(lblEdtEntrynr.Text,1,20);

 if((pSMask and 2)=2) then
    qryAccEntrys.paramByname('transdate').asDateTime:=strtodatedef(lblDateEdit.Text,now);

 if((pSMask and 4)=4) then
    qryAccEntrys.paramByname('document_nr').asString:=copy(lblEdtDocNr.Text,1,55);

 if((pSMask and 8)=8) then
    qryAccEntrys.paramByname('transdescr').asString:=ldlEdtDescr.Text+'%'; // % ette ära lisa, muidu ei kasutata indeksit !!!




    // ---
    qryAccEntrys.Open;

    //qryAccEntrys.SQL.SaveToFile('c:\debug\test.txt');


    self.FSearchPerformed:=true;
 // ------
 if qryAccEntrys.eof then
   begin
    dialogs.messageDlg(estbk_strmsg.SEQryRetNoData,mtInformation,[mbOk],0);
    lblEdtEntrynr.setFocus;
   end;
end;

procedure TframeGenLedgerEntrys.btnNewPaymentClick(Sender: TObject);
begin
     self.onFrameDataEvent(self,__frameCreateNewAccRcs,-1,nil)
end;

procedure TframeGenLedgerEntrys.btnOpenClick(Sender: TObject);
begin
  // ---
  if assigned(self.FFrameDataEvent) and not qryAccEntrys.isEmpty then
     self.FFrameDataEvent(Self,__frameOpenAccEntry,qryAccEntrys.fieldbyname('id').asInteger);
end;

procedure TframeGenLedgerEntrys.lblDateEditExit(Sender: TObject);
var
  fVdate   : TDatetime;
  fDateStr : AStr;
begin
   fVdate:=Now;
   fDateStr:=TDateEdit(Sender).Text;

if (trim(fDateStr)<>'') then
 if not validateMiscDateEntry(fDateStr,fVDate) then
  begin
      dialogs.messageDlg(estbk_strmsg.SEInvalidDate,mterror,[mbOk],0);
      TDateEdit(Sender).setFocus;
      exit;
  end else
      TDateEdit(Sender).text:=datetostr(fVDate);
end;


function  TframeGenLedgerEntrys.getDataLoadStatus:Boolean;
begin
   result:=qryAccEntrys.active;
end;

procedure TframeGenLedgerEntrys.setDataLoadStatus(const v : Boolean);
begin
    qryAccEntrys.connection:=estbk_clientdatamodule.dmodule.primConnection;
    qryAccEntrys.close;
    qryAccEntrys.SQL.clear;
    qryAccEntrys.SQL.add(estbk_sqlclientcollection._CSQLSelectGenLedgerEntrys('',true));

 if v then
    qryAccEntrys.paramByname('company_id').asInteger:=estbk_globvars.glob_company_id;
    qryAccEntrys.active:=v;
end;

constructor TframeGenLedgerEntrys.create(frameOwner: TComponent);
var
  i : TSystemDocType;
begin
    inherited Create(frameOwner);
    estbk_uivisualinit.__preparevisual(self);
    cmbDocTypes.AddItem(estbk_strmsg.SUndefComboChoise,TObject(0));


// TODO: muutub !
for i:=low(TSystemDocType) to high(TSystemDocType) do
 if not (i in [_dsDocUndefined,
               _dsWarehouseMovementDocId,
               _dsWarehouseWriteOffDocId,
               _dsWarehouseIncomeDocId,
               _dsWarehouseStockTakingDocid,
               _dsAmortization]) then  // LADU hetkel veel ei kuva !!
  begin
    cmbDocTypes.AddItem(_ac.sysDocumentLongName[i],TObject(Ptrint(_ac.sysDocumentId[i])));
  end;

    // --
    cmbDocTypes.ItemIndex:=0;
end;

destructor  TframeGenLedgerEntrys.destroy;
begin
  inherited destroy;
end;

procedure   TframeGenLedgerEntrys.refreshList;
begin
  self.loadData:=false;
  self.loadData:=true;
end;

initialization
  {$I estbk_fra_genledgerentrys.ctrs}

end.

