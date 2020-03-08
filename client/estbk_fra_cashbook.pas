unit estbk_fra_cashbook; 

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, LCLType, LCLproc, Forms, dialogs,
  Controls, StdCtrls, Buttons, estbk_uivisualinit, EditBtn, ExtCtrls, Menus,
  ComCtrls, ZDataset,estbk_fra_template, estbk_lib_commoncls, estbk_lib_commonevents,
  estbk_clientdatamodule, estbk_lib_commonaccprop, estbk_types, estbk_sqlclientcollection,estbk_reportsqlcollection,
  estbk_reportconst, estbk_globvars, estbk_utilities, estbk_strmsg,
  estbk_fra_customer, estbk_frm_choosecustmer, rxlookup, LR_Class, LR_DBSet, db, LR_DSet,
  LR_BarC, LR_Desgn, LR_View, lr_e_csv, lr_e_pdf;

type

  { TframeCashbook }

  TframeCashbook = class(Tfra_template)
    btnClean: TBitBtn;
    btnOpenClientList: TBitBtn;
    btnOutput: TBitBtn;
    btnReport: TBitBtn;
    cmbPreDefPer: TComboBox;
    reportdata: TfrDBDataSet;
    frReport: TfrReport;
    lblPerStart: TLabel;
    lblPerEnd: TLabel;
    lcpCashRegAccount: TRxDBLookupCombo;
    mnuItemCsv: TMenuItem;
    mnuItemPdfFile: TMenuItem;
    mnuItemScreen: TMenuItem;
    popupReportType: TPopupMenu;
    qryAccountsDs: TDatasource;
    dtEditEnd: TDateEdit;
    dtEditStart: TDateEdit;
    edtClientCode: TEdit;
    edtCustNameAndRegCode: TEdit;
    grpCashbook: TGroupBox;
    Label1: TLabel;
    lblCustId: TLabel;
    lblPermisc: TLabel;
    qryCashbookEntrys: TZQuery;
    qryAccounts: TZQuery;
    saveRep: TSaveDialog;
    procedure btnCleanClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure cmbPreDefPerChange(Sender: TObject);
    procedure dtEditStartExit(Sender: TObject);
    procedure edtClientCodeChange(Sender: TObject);
    procedure edtClientCodeExit(Sender: TObject);
    procedure edtClientCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtClientCodeKeyPress(Sender: TObject; var Key: char);
    procedure frReportGetValue(const ParName: String; var ParValue: Variant);
    procedure lcpCashRegAccountClosePopupNotif(Sender: TObject;
      SearchResult: boolean);
    procedure lcpCashRegAccountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lcpCashRegAccountSelect(Sender: TObject);
    procedure mnuItemScreenClick(Sender: TObject);

  private

    FInDocCount       : Integer;
    FOutDocCount      : Integer;
    FFinalBalance     : Double;
    // ---
    FreportDefPath    : AStr;
    FLastClientcode   : AStr;
    FSelectedClientId : Integer;

    FframeKillSignal  : TNotifyEvent;
    FParentKeyNotif   : TKeyNotEvent;
    FFrameDataEvent   : TFrameReqEvent;
    // --
    function    getDataLoadStatus: boolean;
    procedure   setDataLoadStatus(const v: boolean);
    procedure   assignClientData(const pClient : TClientData);
  public
    constructor create(frameOwner: TComponent); override;
    destructor  destroy; override;
  // RTTI teema;
  published
    property reportDefPath : AStr read FreportDefPath write FreportDefPath;
    property onFrameKillSignal     : TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif : TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent : TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property loadData  : boolean read getDataLoadStatus write setDataLoadStatus;
  end; 

implementation

const
  CIndxPaymentStatus_undefined   = 0;
  CIndxPaymentStatus_confirmed   = 1;
  CIndxPaymentStatus_unconfirmed = 2;
{ TframeCashbook }



procedure TframeCashbook.assignClientData(const pClient : TClientData);
var
  pTemp : AStr;
begin
    if not assigned(pClient) then
     begin
        edtClientCode.Text:='';
        edtCustNameAndRegCode.Text:='';

        self.FLastClientcode:='';
        self.FSelectedClientId:=0;
     end else
     begin
        pTemp:=pClient.FCustFullName;
     if trim(pClient.FCustRegNr)<>'' then
        pTemp:=pTemp+'('+pClient.FCustRegNr+')';


        // ---
        edtCustNameAndRegCode.Text:=pTemp;
        edtClientCode.text:=pClient.FClientCode;

        self.FSelectedClientId:=pClient.FClientId;
        self.FLastClientcode:=pClient.FClientCode;
     end;
end;

procedure TframeCashbook.btnOpenClientListClick(Sender: TObject);
var
   pClient : TClientData;
begin
   try
      pClient:=estbk_frm_choosecustmer.__chooseClient(edtClientCode.text);
      assignClientData(pClient);

   if cmbPreDefPer.CanFocus then
      cmbPreDefPer.SetFocus;
   finally
      freeAndNil(pClient);
   end;
end;

procedure TframeCashbook.btnOutputClick(Sender: TObject);
var
  pFindPOwner : TWincontrol;
begin
      pFindPOwner:=self.Parent;
while assigned(pFindPOwner) do
   begin
     if (pFindPOwner is TPageControl) or (pFindPOwner is TForm) then
         break;

         // ---
         pFindPOwner:=pFindPOwner.Parent;
   end;

     popupReportType.PopUp(TForm(pFindPOwner).left+TSpeedButton(sender).left+TSpeedButton(sender).width+1,
                           TForm(pFindPOwner).top+TSpeedButton(sender).top+TSpeedButton(sender).height+118);
end;

procedure TframeCashbook.btnReportClick(Sender: TObject);

var
  pCursor    : TCursor;
  pAccountId : Integer;
  pAccArr    : TADynIntArray;
  pBfrTable  : AStr;
  pDtStart   : TDatetime;
  pDtEnd     : TDatetime;
  pSql       : AStr;
  pRepFile   : AStr;
  pFileName  : AStr;

begin
      self.FInDocCount:=0;
      self.FOutDocCount:=0;
      self.FFinalBalance:=0.00;

      pDtStart:=CZStartDate1980;
      pDtEnd:=CZEndDate2050;

  if  trim(dtEditStart.Text)<>'' then
      pDtStart:=dtEditStart.Date;

  if  trim(dtEditEnd.Text)<>'' then
      pDtEnd:=dtEditEnd.Date;


    if (trim(dtEditStart.Text)<>'') and (trim(dtEditEnd.Text)<>'') and (pDtStart>pDtEnd) then
      begin
         dialogs.messageDlg(estbk_strmsg.SEStartDateQtEndDate,mterror,[mbOk],0);
      if dtEditStart.CanFocus then
         dtEditStart.setFocus;
         Exit;
      end;


    if (trim(dtEditStart.Text)<>'') and (pDtStart>now) then
      begin
         dialogs.messageDlg(estbk_strmsg.SEDateInFuture,mterror,[mbOk],0);
      if dtEditStart.CanFocus then
         dtEditStart.setFocus;
         Exit;
      end;


  // ---
  try
       pCursor:=Screen.Cursor;
       Screen.Cursor:=crHourGlass;
  with qryCashbookEntrys,SQL do
    try
       // kompatiiblus postgre jaoks...ja ka firebird; muidu poleks transaktsiooni vaja !
       dmodule.primConnection.StartTransaction;

       setlength(pAccArr,1);
    if trim(lcpCashRegAccount.Text)<>'' then
       pAccountId:=qryAccounts.FieldByName('id').AsInteger
    else
       pAccountId:=_ac.sysAccountId[_accCashRegister];

       pAccArr[0]:=pAccountId;
       pBfrTable:='creg';
       close;
       clear;


       add(estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart1(estbk_globvars.glob_company_id,pBfrTable,pAccArr));
       execsql;

       // 22.03.2012 Ingmar
       close;
       clear;
       add(estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart2(estbk_globvars.glob_company_id,pBfrTable,pDtStart,pDtEnd));
       execsql;

       close;
       clear;
       add(estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart3(estbk_globvars.glob_company_id,pBfrTable));
       execsql;

       // SISSETULEKU ORDER
       pSql:=estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart4(estbk_globvars.glob_company_id,
                                                                         pBfrTable,
                                                                         true,
                                                                         estbk_types._dsReceiptVoucherDocId,
                                                                         self.FSelectedClientId,
                                                                         //cmbCashRegPmtStatus.ItemIndex,
                                                                         // ---
                                                                         pDtStart,
                                                                         pDtEnd
                                                                         );

       close;
       clear;
       add(pSql);
       execsql;


       // VÄLJAMINEKU ORDER
       close;
       clear;
       pSql:=estbk_reportsqlcollection._CSQLRepCashBookSpeedUpTablePart4(estbk_globvars.glob_company_id,
                                                                         pBfrTable,
                                                                         true,
                                                                         estbk_types._dsPaymentVoucherDocId,
                                                                         self.FSelectedClientId,
                                                                         //cmbCashRegPmtStatus.ItemIndex,
                                                                         // ---
                                                                         pDtStart,
                                                                         pDtEnd
                                                                         );

       add(pSql);
       execsql;


       close; clear;
       add(_CSQLRepCashBookFinalQrt(pBfrTable));
       open;

       dmodule.primConnection.Commit;

    if qryCashbookEntrys.Eof then
       messageDlg(estbk_strmsg.SEQryRetNoData,mtinformation,[mbOk],0)
    else
     begin
          self.FFinalBalance:=FieldByname('init_balance').AsFloat;
          pRepFile:=includetrailingbackslash(self.reportDefPath)+  estbk_reportconst.CCashRegisterReportFilename;
       if not fileExists(pRepFile) then
          raise exception.CreateFmt(estbk_strmsg.SEReportDataFileNotFound,[pRepFile]);

          Screen.Cursor:=pCursor;
          frReport.LoadFromFile(pRepFile);
          frReport.ShowProgress:=true;
     if   mnuItemScreen.checked then
        begin
          //frReport.PrepareReport:=true;
          frReport.ShowReport;

        end else
     // http://lazarus.developpez.com/cours/lazreport/
     // TfrTextExportFilter
     // TfrHTMExport
     if   mnuItemPdfFile.checked then
        begin
              // TODO
              pFileName:=stringreplace(dtEditStart.text,'.','',[rfReplaceAll])+
                         '_'+stringreplace(dtEditEnd.text,'.','',[rfReplaceAll]);

              saveRep.FileName:=format(CSCashBookFile,[pFileName])+'.pdf';
           if saveRep.Execute then
            begin
            	if frReport.PrepareReport then
    	           frReport.ExportTo(TFrTNPDFExportFilter,saveRep.Files.Strings[0]);
            end;
            // ----
        end else
     if mnuItemCsv.checked then
        begin
              // TODO
              pFileName:=stringreplace(dtEditStart.text,'.','',[rfReplaceAll])+
                         '_'+stringreplace(dtEditEnd.text,'.','',[rfReplaceAll]);

              saveRep.FileName:=format(CSCashBookFile,[pFileName])+'.csv';
           if saveRep.Execute then
            begin
            	if frReport.PrepareReport then
    	           frReport.ExportTo(TfrCSVExportFilter,saveRep.Files.Strings[0]);
            end;

        // ----
        end;
     end;
     // ---
    except on e : exception do
     begin
     if  dmodule.primConnection.InTransaction then
     try dmodule.primConnection.RollBack; except end;
       dialogs.MessageDlg(format(estbk_strmsg.SECantCreateReport,[e.Message]),mtError,[mbOk],0);
     end;
    end;

  finally
     Screen.Cursor:=pCursor;
  end;
end;

procedure TframeCashbook.btnCleanClick(Sender: TObject);
begin
   estbk_utilities.clearControlsWithTextValue(grpCashbook);

   // reset
   qryAccounts.Locate('id',_ac.sysAccountId[_accCashRegister],[]);
   lcpCashRegAccount.Value:=inttostr(_ac.sysAccountId[_accCashRegister]);
   lcpCashRegAccount.Text:='';


//   cmbPreDefPer.ItemIndex:=1;
//   cmbPreDefPer.OnChange(cmbPreDefPer);
//   cmbCashRegPmtStatus.ItemIndex:=0;

if edtClientCode.CanFocus then
   edtClientCode.SetFocus;


   edtCustNameAndRegCode.Text:='';
   FLastClientcode:='';
   FSelectedClientId:=0;


   dtEditStart.Date:=now;
   dtEditEnd.Date:=now;
end;

procedure TframeCashbook.cmbPreDefPerChange(Sender: TObject);
var
  pDtType : estbk_types.TdtPeriod;
  pdtStart  : TDatetime;
  pdtEnd    : TDatetime;
  zVal      : Boolean;
begin
        zVal:=true;
   with TComboBox(sender) do
   if itemIndex>=0 then
     begin
         pDtType:=estbk_types.TdtPeriod(Cardinal(Items.Objects[itemIndex]));
      if pDtType<>cdt_undefined then
        begin
            estbk_utilities.decodeDtRange(pDtType,pdtStart,pdtEnd);

            dtEditStart.date:=pdtStart;
            dtEditEnd.date:=pdtEnd;

            dtEditStart.Text:=datetostr(pdtStart);
            dtEditEnd.Text:=datetostr(pdtEnd);
            zVal:=false;
        end;
     end;

  // ----
  if zVal then
     begin
      dtEditStart.date:=now;
      dtEditEnd.date:=now;

      dtEditStart.Text:='';
      dtEditEnd.Text:='';
     end;
end;

procedure TframeCashbook.dtEditStartExit(Sender: TObject);
var
  fVdate   : TDatetime;
  fDateStr : AStr;
  b : Boolean;
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

procedure TframeCashbook.edtClientCodeChange(Sender: TObject);
begin
 with TEdit(Sender) do
 if Focused then
  begin
  if trim(text)='' then
    begin
     self.FSelectedClientId:=0;
     edtCustNameAndRegCode.Text:='';
    end;
  end; // --
end;

procedure TframeCashbook.edtClientCodeExit(Sender: TObject);
var
   pClient : TClientData;
begin
       pClient:=nil;
  with TEdit(Sender) do
  if text<>'' then
   try
    if self.FLastClientcode<>text then
      begin
        pClient:=estbk_fra_customer.getClientDataWUI(text);
        self.assignClientData(pClient);
      end;

   finally
     freeAndNil(pClient);
   end else
    self.assignClientData(pClient);
end;

procedure TframeCashbook.edtClientCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_RETURN) and (Shift=[ssCtrl]) then
    begin
      self.btnOpenClientListClick(btnOpenClientList);
      key:=0;
    end;
end;

procedure TframeCashbook.edtClientCodeKeyPress(Sender: TObject; var Key: char);
begin
 if key=#13 then
  begin
     SelectNext(Sender as twincontrol, True, True);
     key:=#0;
  end;
end;

procedure TframeCashbook.frReportGetValue(const ParName: String; var ParValue: Variant);
const
   SCAccountInitBalance = '@scaccountinitbalance';
   SCperiod         = '@scperiod';
   SCCashregAccCode = '@sccashregacccode';
   SCCashregLongname= '@sccashreglongname';

   SCTrandate       = '@sctrandate';
   SCClientname     = '@scclientname';
   SCDescr          = '@scdescr';
   SCcompname       = '@sccompname';

   SCIncr           = '@scincr';
   SCOutr           = '@scoutr';
   SCAccountFinalBalance = '@scaccountfinalbalance';


   SCInDocCnt  = '@scindoccnt';
   SCOutDocCnt = '@scoutdoccnt';


var
   pLowParam : AStr;
   pTemp     : AStr;
begin
  // ---
  if pos('@',parname)>0 then
   begin
              ParValue:='';
              pLowParam:=ansilowercase(ParName);
           if pLowParam=SCAccountInitBalance then
              ParValue:=format(CCurrentMoneyFmt2,[qryCashbookEntrys.FieldByName('init_balance').AsFloat])
           else
           if pLowParam=SCperiod then
            begin
                  pTemp:='';
              if  dtEditStart.Text<>'' then
                  pTemp:=datetostr(dtEditStart.date)+' - ';

              if dtEditEnd.Text<>'' then
               begin
               if pTemp='' then
                  pTemp:=' - ';
                  pTemp:=pTemp+datetostr(dtEditEnd.date);
               end;
                  // ---
                  ParValue:=pTemp;
             end else
           if pLowParam=SCCashregAccCode then // KASSA
              ParValue:=qryCashbookEntrys.FieldByName('account_coding').AsString
           else
           if pLowParam=SCCashregLongname then // KASSA konto pikk nimi
              ParValue:=qryCashbookEntrys.FieldByName('account_name').AsString
           else
           if pLowParam=SCTrandate then
              ParValue:=datetostr(qryCashbookEntrys.FieldByName('trdate').asDatetime)
           else
           if pLowParam=SCClientname then
              ParValue:=trim(qryCashbookEntrys.FieldByName('firstname').AsString+' '+qryCashbookEntrys.FieldByName('lastname').AsString)
           else
           if pLowParam=SCDescr then
              ParValue:=trim(qryCashbookEntrys.FieldByName('descr').AsString) // kande kirjeldus; per rida ! longdescr on kogu kirjeldus, mis maksega seotud !
           else
           if pLowParam=SCcompname then
              ParValue:=estbk_globvars.glob_currcompname
           else
           if ((pLowParam=SCIncr) or (pLowParam=SCOutr)) then
            begin
               if (qryCashbookEntrys.FieldByname('srline').AsInteger=2) and (pLowParam=SCIncr) then // tunnus sissetuleku order !
                 begin
                   ParValue:=format(CCurrentMoneyFmt2,[qryCashbookEntrys.FieldByName('incr').AsFloat]);
                   self.FFinalBalance:=self.FFinalBalance+qryCashbookEntrys.FieldByName('incr').AsFloat;
                   inc(self.FInDocCount);
                 end else
               if (qryCashbookEntrys.FieldByname('srline').AsInteger=3) and (pLowParam=SCOutr) then // tunnus väljamineku order !
                 begin
                   ParValue:=format(CCurrentMoneyFmt2,[qryCashbookEntrys.FieldByName('outr').AsFloat]);
                   //self.FFinalBalance:=self.FFinalBalance+qryCashbookEntrys.FieldByName('outr').AsFloat;
                   self.FFinalBalance:=self.FFinalBalance-qryCashbookEntrys.FieldByName('outr').AsFloat;
                   inc(self.FOutDocCount);
                 end else
                   ParValue:='';
            end else // --
            if pLowParam=SCAccountFinalBalance then
               ParValue:=format(CCurrentMoneyFmt2,[  self.FFinalBalance])
            else
            if pLowParam=SCInDocCnt then
               ParValue:=inttostr(self.FInDocCount)
            else
            if pLowParam=SCOutDocCnt then
               ParValue:=inttostr(self.FOutDocCount);
   end;
end;

procedure TframeCashbook.lcpCashRegAccountClosePopupNotif(Sender: TObject;
  SearchResult: boolean);
begin
  estbk_utilities.rxLibAndMainMenuFix;
end;

procedure TframeCashbook.lcpCashRegAccountKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  estbk_utilities.rxLibKeyDownHelper(Sender as TRxDbLookupCombo,key,Shift);
end;

procedure TframeCashbook.lcpCashRegAccountSelect(Sender: TObject);
var
  pcode : AStr;
begin
  pcode:=qryAccounts.FieldByName('account_coding').AsString;
  lcpCashRegAccount.Hint:=pcode;
  lcpCashRegAccount.Text:=pcode;
end;

procedure TframeCashbook.mnuItemScreenClick(Sender: TObject);
var
  i : Integer;
begin
  for i:=0 to self.popupReportType.Items.Count-1 do
      self.popupReportType.Items[i].Checked:=false;
      TMenuItem(Sender).Checked:=true;

   if btnReport.CanFocus then
      btnReport.setFocus;
end;


function   TframeCashbook.getDataLoadStatus: boolean;
begin
  result:=qryCashbookEntrys.Active;
end;

procedure  TframeCashbook.setDataLoadStatus(const v: boolean);
begin
   qryCashbookEntrys.Close;
   qryCashbookEntrys.SQL.Clear;

   qryAccounts.Close;
   qryAccounts.SQL.Clear;

if v then
 begin
   qryCashbookEntrys.Connection:=dmodule.primConnection;
   qryAccounts.Connection:=dmodule.primConnection;
   qryAccounts.SQL.Add(estbk_sqlclientcollection._CSQLGetAllAccounts);
   qryAccounts.ParamByName('company_id').AsInteger:=estbk_globvars.glob_company_id;
   qryAccounts.Active:=v;
   qryAccounts.Locate('id',_ac.sysAccountId[_accCashRegister],[]);
   lcpCashRegAccount.Value:=inttostr(_ac.sysAccountId[_accCashRegister]);
   lcpCashRegAccount.Text:='';
 end else
   qryCashbookEntrys.Connection:=nil;
end;


constructor TframeCashbook.Create(frameOwner: TComponent);
begin
   inherited create(frameOwner);
   estbk_uivisualinit.__preparevisual(self);


//   cmbCashRegPmtStatus.Items.Add(estbk_strmsg.SUndefComboChoise);
//   cmbCashRegPmtStatus.Items.Add(estbk_strmsg.SCStatusConfirmed);
//   cmbCashRegPmtStatus.Items.Add(estbk_strmsg.SCStatusUnConfirmed);

   estbk_reportconst.fillReportDtPer(TAStrings(cmbPreDefPer.items));
   cmbPreDefPer.ItemIndex:=1;
   cmbPreDefPer.OnChange(cmbPreDefPer);
//   cmbCashRegPmtStatus.ItemIndex:=0;
end;


destructor TframeCashbook.Destroy;
begin
   inherited destroy;
end;

initialization
  {$I estbk_fra_cashbook.ctrs}

end.
