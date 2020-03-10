unit estbk_fra_debtorlist;


{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, Buttons,
  LCLType, Dialogs, EditBtn, ExtCtrls, Menus, Math, estbk_fra_template, estbk_uivisualinit,
  estbk_lib_commonevents, estbk_lib_commoncls, estbk_clientdatamodule, ComCtrls,
  estbk_sqlclientcollection, estbk_reportconst, estbk_globvars, estbk_utilities,
  estbk_types, estbk_strmsg, estbk_fra_customer, estbk_frm_choosecustmer, LR_Class,
  LR_DBSet, lr_e_csv, PrintersDlgs, lr_e_pdf, ZDataset;

type

  { TframeDebtors }

  TframeDebtors = class(Tfra_template)
    btnClean: TBitBtn;
    btnOutput: TBitBtn;
    btnReport: TBitBtn;
    btnOpenClientList: TBitBtn;
    chkBoxPartiallyPaid: TCheckBox;
    chkCurrencyDiff: TCheckBox;
    cmbBillCreatedby: TComboBox;
    cmbCurrencyList: TComboBox;
    lblCurrency: TLabel;
    mnuItemCsv: TMenuItem;
    mnuItemPdfFile: TMenuItem;
    mnuItemScreen: TMenuItem;
    popupReportType: TPopupMenu;
    reportdata: TfrDBDataSet;
    report: TfrReport;
    lblBillCreatedBy: TLabel;
    pchkboxSortOrder: TCheckBox;
    cmbSortByFields: TComboBox;
    dtBillsUntil: TDateEdit;
    edtDDaysOver: TEdit;
    edtClientCode: TEdit;
    edtCustNameAndRegCode: TEdit;
    grpDebt: TGroupBox;
    pSort: TLabel;
    lblDaysOvr: TLabel;
    lblOverDDate: TLabel;
    lblCustId: TLabel;
    lblBillsuntil: TLabel;
    qryDebtBills: TZReadOnlyQuery;
    saveRep: TSaveDialog;
    procedure btnCleanClick(Sender: TObject);
    procedure btnOpenClientListClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure btnSrcClick(Sender: TObject);
    procedure chkCurrencyDiffChange(Sender: TObject);
    procedure cmbCurrencyListChange(Sender: TObject);
    procedure cmbSortByFieldsChange(Sender: TObject);
    procedure dtBillsUntilChange(Sender: TObject);
    procedure dtBillsUntilExit(Sender: TObject);
    procedure edtClientCodeChange(Sender: TObject);
    procedure edtClientCodeExit(Sender: TObject);
    procedure edtClientCodeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtClientCodeKeyPress(Sender: TObject; var Key: char);
    procedure edtDDaysOverKeyPress(Sender: TObject; var Key: char);
    procedure mnuItemScreenClick(Sender: TObject);
    procedure reportBeginBand(Band: TfrBand);
    procedure reportBeginDoc;
    procedure reportEnterRect(Memo: TStringList; View: TfrView);
    procedure reportGetValue(const ParName: string; var ParValue: variant);
  private
    FCurrList: TAStrList;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;
    FReqCurrUpdate: TRequestForCurrUpdate;

    FLastClientcode: AStr;
    FSelectedClientId: integer;
    FBillTypeStr: AStr;
    FreportDefPath: AStr;

    FBillSumTotals: double;
    FPaidSumTotals: double;
    FToPaySumTotals: double;
    // -- 23.10.2011 Ingmar; ALL !
    FBillSumAll: double;
    FPaidSumAll: double;
    FToPaySumAll: double;

    function getReportNamePerBillType: AStr;
    procedure setBillType(const v: AStr);
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure assignClientData(const pClient: TClientData);
    procedure fetchCurrRates(const pCurrDate: TDatetime);
  public

    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
    // RTTI pole täielik, published puhul vaid erandid
  published
    property billType: AStr read FBillTypeStr write setBillType;
    property reportDefPath: AStr read FreportDefPath write FreportDefPath;
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;
    property onAskCurrencyDownload: TRequestForCurrUpdate read FReqCurrUpdate write FReqCurrUpdate;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

uses dateutils;

const
  CCmbIndexClientName = 0;
  CCmbIndexDueDate = 1;
  CCmbIndexDebtSize = 2;
  CCmbIndexBillDate = 3;

{
Ainult viivisarved
    Märgi see valik, kui soovid aruandesse kaasata ainult Viivisarved.

Näita arve kommentaari
    Märgi see valik, kui soovid aruandes näha Kommentaare Arve Tingimuste kaardilt.

Näita müügivõla kontosid
    IKui märgid selle valiku, näidatakse aruande lõpus Müügivõlgade kontod, mille seisu mõjutavad aruande põhiosas toodud Arved. Samuti näidatakse nende kontode saldod, mis arvutatakse vaid aruandesse kaasatud Arvete alusel. Sellel valikul pole tähtsust, kui oled märkinud valiku Kursivahed.

Näita osalisi makseid
}


constructor TframeDebtors.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);


  cmbSortByFields.AddItem(estbk_strmsg.SCDebtClientName, TObject(PtrInt(CCmbIndexClientName)));
  cmbSortByFields.AddItem(estbk_strmsg.SCDebtDueDate, TObject(PtrInt(CCmbIndexDueDate)));
  cmbSortByFields.AddItem(estbk_strmsg.SCDebtSize, TObject(PtrInt(CCmbIndexDebtSize)));
  cmbSortByFields.AddItem(estbk_strmsg.SCDebtBillDate, TObject(PtrInt(CCmbIndexBillDate)));

  cmbSortByFields.ItemIndex := 0;
  FCurrList := estbk_clientdatamodule.dmodule.createPrivateCurrListCopy();

  cmbCurrencyList.Items.Assign(FCurrList);
  cmbCurrencyList.Items.InsertObject(0, estbk_strmsg.SUndefComboChoise, nil);
  cmbCurrencyList.ItemIndex := 0;
  // ---
  dmodule.fillWorkerList(cmbBillCreatedby);

end;


destructor TframeDebtors.Destroy;
begin
  estbk_utilities.clearStrObject(TAStrings(self.FCurrList));
  FreeAndNil(self.FCurrList);
  inherited Destroy;
end;

procedure TframeDebtors.edtClientCodeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;

procedure TframeDebtors.edtDDaysOverKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end
  else
  begin
    if key in ['+', '-'] then
      key := #0
    else
      estbk_utilities.edit_verifyNumericEntry(TCustomEdit(Sender), Key, False);
  end;
end;

procedure TframeDebtors.mnuItemScreenClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to self.popupReportType.Items.Count - 1 do
    self.popupReportType.Items[i].Checked := False;
  TMenuItem(Sender).Checked := True;

  if btnReport.CanFocus then
    btnReport.SetFocus;
end;


// interest invoices
procedure TframeDebtors.reportBeginBand(Band: TfrBand);
begin
  // 06.03.2011 Ingmar; lazReport kala ! Band.name = tühjus
  //if ansilowercase(Band.Name)='grpheader' then
  if Band.Typ = btGroupHeader then
  begin
    self.FBillSumTotals := 0;
    self.FPaidSumTotals := 0;
    self.FToPaySumTotals := 0;
  end
  else
  //if ansilowercase(Band.Name)='detailband' then
  if Band.Typ = btMasterData then
    with qryDebtBills do
    begin
      self.FBillSumTotals := self.FBillSumTotals + FieldByName('bill_sum').AsFloat;
      self.FPaidSumTotals := self.FPaidSumTotals + FieldByName('paid').AsFloat;
      self.FToPaySumTotals := self.FToPaySumTotals + FieldByName('to_pay').AsFloat;


      // 23.11.2011 Ingmar
      self.FBillSumAll := self.FBillSumAll + FieldByName('bill_sum').AsFloat;
      self.FPaidSumAll := self.FPaidSumAll + FieldByName('paid').AsFloat;
      self.FToPaySumAll := self.FToPaySumAll + FieldByName('to_pay').AsFloat;


      if chkCurrencyDiff.Checked then
        Band.Height := 41
      else
        Band.Height := 21;
    end; // else
  //if ansilowercase(Band.Name)='grpfooter' then

  if (cmbSortByFields.ItemIndex <> CCmbIndexClientName) and (Band.Typ in [btGroupHeader, btGroupFooter]) then
  begin
    Band.Visible := False;
    Band.Height := 0;
  end;
end;

// 05.10.2015 Ingmar
// väidetavalt printimisel summad topelt ?!?!?
procedure TframeDebtors.reportBeginDoc;
begin
  self.FBillSumTotals := 0.00;
  self.FPaidSumTotals := 0.00;
  self.FToPaySumTotals := 0.00;

  self.FBillSumAll := 0.00;
  self.FPaidSumAll := 0.00;
  self.FToPaySumAll := 0.00;
end;

procedure TframeDebtors.reportEnterRect(Memo: TStringList; View: TfrView);
begin
  //--
  //if View is TfrBandView then
end;

procedure TframeDebtors.reportGetValue(const ParName: string; var ParValue: variant);
const
  SCCompanyName = '@sccompanyname';
  SCDeptRepDetails = '@scdebtrepdetails';
  SCGroupLabel = '@scgrouplabel';
  SCClientName2 = '@scclientname2'; // masterdata juures, kui pole valitud, et andmed sorteeritud kliendi järgi
  SCBillnr = '@scbillnr';
  SCBillDate = '@scdate';
  SCDueDate = '@scduedate';
  SCBillSum = '@scbillsum';
  SCPaidSum = '@scpaidsum';
  SCToPay = '@sctopay';
  SCCurrency = '@sccurrency';
  SCCEmail = '@scemail';
  SCCPhone = '@scphone';
  // kursivahed
  SCCurrencyDiff = '@sccurrencydiff';
  SCExcRatesInfo = '@scexcratesinfo';

  // samas ise grupi väljundit arvutades jätame endale võimaluse nö customiseerida
  // [sum([reportdata."bill_sum"], MasterData1)]
  SCGrpBillSumTotal = '@scbillsumtotal';
  SCGrpPaidSumTotal = '@scpaidsumtotal';
  SCGrpToPayTotal = '@sctopaytotal';
  // 23.10.2011 Ingmar
  SCBillSumAll = '@scbillsumall';
  SCPaidSumAll = '@scpaidsumall';
  SCToPayAll = '@sctopayall';

var
  pnLower: AStr;
begin
  pnLower := ansilowercase(ParName);
  if pos('@', pnLower) > 0 then
    with reportdata.DataSet do
    begin
      ParValue := '';
      if pnLower = SCCompanyName then
        parValue := estbk_globvars.glob_currcompname
      else
      if pnLower = SCDeptRepDetails then
        parValue := self.getReportNamePerBillType
      else
      if pnLower = SCGroupLabel then
      begin
        parValue := FieldByName('client_name').AsString;
      end
      else
      if pnLower = SCClientName2 then
      begin
        if cmbSortByFields.ItemIndex <> CCmbIndexClientName then
          parValue := FieldByName('client_name').AsString
        else
          parValue := '';
      end
      else
      if pnLower = SCBillnr then
        parValue := FieldByName('bill_number').AsString
      else
      if pnLower = SCBillDate then
        parValue := datetostr(FieldByName('bill_date').AsDateTime)
      else
      if pnLower = SCDueDate then
        parValue := datetostr(FieldByName('due_date').AsDateTime)
      else
      if pnLower = SCBillSum then
      begin
        parValue := format(estbk_types.CCurrentMoneyFmt2, [FieldByName('bill_sum').AsFloat]);
      end
      else
      if pnLower = SCPaidSum then
      begin
        parValue := format(estbk_types.CCurrentMoneyFmt2, [FieldByName('paid').AsFloat]);
      end
      else
      if pnLower = SCToPay then
      begin
        parValue := format(estbk_types.CCurrentMoneyFmt2, [FieldByName('to_pay').AsFloat]);
      end
      else
      if pnLower = SCCurrency then
        parValue := FieldByName('currency').AsString
      else
      if pnLower = SCCEmail then
        parValue := FieldByName('email').AsString
      else
      if pnLower = SCCPhone then
        parValue := FieldByName('phone').AsString
      else
      if pnLower = SCGrpBillSumTotal then
        parValue := format(estbk_types.CCurrentMoneyFmt2, [self.FBillSumTotals])
      else
      if pnLower = SCGrpPaidSumTotal then
        parValue := format(estbk_types.CCurrentMoneyFmt2, [self.FPaidSumTotals])
      else
      if pnLower = SCGrpToPayTotal then
        parValue := format(estbk_types.CCurrentMoneyFmt2, [self.FToPaySumTotals])
      else // arvutame kursivahed võlainfolt
      if pnLower = SCGrpToPayTotal then
      begin
      end
      else
      if pnLower = SCExcRatesInfo then
      begin
      end
      else
      // 23.10.2011 Ingmar
      if pnLower = SCBillSumAll then
      begin
        parValue := format(estbk_types.CCurrentMoneyFmt2, [self.FBillSumAll]);
      end
      else
      if pnLower = SCPaidSumAll then
      begin
        parValue := format(estbk_types.CCurrentMoneyFmt2, [self.FPaidSumAll]);
      end
      else
      if pnLower = SCToPayAll then
      begin
        parValue := format(estbk_types.CCurrentMoneyFmt2, [self.FToPaySumAll]);
      end;

      // ----
    end;
end;

procedure TframeDebtors.dtBillsUntilExit(Sender: TObject);
var
  fVdate: TDatetime;
  fDateStr: AStr;
  b: boolean;
begin
  fVdate := Now;
  fDateStr := TDateEdit(Sender).Text;

  if (trim(fDateStr) <> '') then
    if not validateMiscDateEntry(fDateStr, fVDate) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
      TDateEdit(Sender).SetFocus;
      exit;
    end
    else
      TDateEdit(Sender).Text := datetostr(fVDate);

  b := trim(TDateEdit(Sender).Text) <> '';
  chkCurrencyDiff.Checked := b;
  chkCurrencyDiff.Enabled := b;



  // TODO valuuta kahjud ja kasum !
  // küsime kursid üle...
  //if b and chkCurrencyDiff.checked then
  //   self.fetchCurrRates(TDateEdit(Sender).Date);

end;

procedure TframeDebtors.edtClientCodeChange(Sender: TObject);
begin
  with TEdit(Sender) do
    if Focused then
    begin
      if trim(Text) = '' then
      begin
        self.FSelectedClientId := 0;
        edtCustNameAndRegCode.Text := '';
      end;

    end; // --
end;

function TframeDebtors.getReportNamePerBillType: AStr;
begin
  if self.FBillTypeStr = estbk_types._CItemSaleBill then
    Result := estbk_strmsg.SCDebtBillTypeSale
  else
  if self.FBillTypeStr = estbk_types._CItemPurchBill then
    Result := estbk_strmsg.SCDebtBillTypePurch;
end;

procedure TframeDebtors.setBillType(const v: AStr);
begin
  self.FBillTypeStr := v;
  grpDebt.Caption := ' ' + getReportNamePerBillType + ' ';
end;

procedure TframeDebtors.assignClientData(const pClient: TClientData);
var
  pTemp: AStr;
begin
  if not assigned(pClient) then
  begin
    edtClientCode.Text := '';
    edtCustNameAndRegCode.Text := '';

    self.FLastClientcode := '';
    self.FSelectedClientId := 0;
  end
  else
  begin
    pTemp := pClient.FCustFullName;
    if trim(pClient.FCustRegNr) <> '' then
      pTemp := pTemp + '(' + pClient.FCustRegNr + ')';


    // ---
    edtCustNameAndRegCode.Text := pTemp;
    edtClientCode.Text := pClient.FClientCode;

    self.FSelectedClientId := pClient.FClientId;
    self.FLastClientcode := pClient.FClientCode;
  end;
end;

procedure TframeDebtors.edtClientCodeExit(Sender: TObject);
var
  pClient: TClientData;
begin
  pClient := nil;
  with TEdit(Sender) do
    if Text <> '' then
      try
        if self.FLastClientcode <> Text then
        begin
          pClient := estbk_fra_customer.getClientDataWUI(Text);
          self.assignClientData(pClient);
        end;

      finally
        FreeAndNil(pClient);
      end
    else
      self.assignClientData(pClient);
end;

procedure TframeDebtors.edtClientCodeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    self.btnOpenClientListClick(btnOpenClientList);
    key := 0;
  end;
end;

procedure TframeDebtors.btnSrcClick(Sender: TObject);
begin
end;

procedure TframeDebtors.chkCurrencyDiffChange(Sender: TObject);
begin
  with TCheckbox(Sender) do
    if Focused and Checked and (trim(dtBillsUntil.Text) <> '') then
      self.fetchCurrRates(dtBillsUntil.Date);
end;

procedure TframeDebtors.fetchCurrRates(const pCurrDate: TDatetime);
var
  pCurrFnd: boolean;
  pIndex: integer;
  pValue: double;
begin
  if chkCurrencyDiff.Checked then
    try
      // --- testime dollariga !

      if cmbCurrencyList.ItemIndex > 0 then
        pIndex := self.FCurrList.IndexOf(cmbCurrencyList.Text)
      else
        pIndex := self.FCurrList.IndexOf('USD'); // et kõik kursid tuleks
      pValue := TCurrencyObjType(self.FCurrList.Objects[pIndex]).currVal;


      // --
      if (dateutils.daysBetween(TCurrencyObjType(self.FCurrList.Objects[0]).currDate, pCurrDate) <> 0) or not Math.isZero(pValue) then
      begin

        pCurrFnd := estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pCurrDate, self.FCurrList);
        if not pCurrFnd then
          if assigned(self.onAskCurrencyDownload) then
          begin
            self.onAskCurrencyDownload(self, pCurrDate);
            estbk_clientdatamodule.dmodule.revalidateCurrObjVals(pCurrDate, self.FCurrList); // küsime uuesti kurssi !
          end;
      end;


    except
      on e: Exception do
        if (e is EAbort) then
          estbk_utilities.miscResetCurrenyValList(cmbCurrencyList)
        else
          raise;
    end;
end;

procedure TframeDebtors.cmbCurrencyListChange(Sender: TObject);
begin
  // --
  //  if (TCombobox(Sender).ItemIndex>0) then
end;

procedure TframeDebtors.cmbSortByFieldsChange(Sender: TObject);
begin
  with TCombobox(Sender) do
    if Focused and qryDebtBills.Active and (qryDebtBills.RecordCount > 0) then
    begin
      //btnReport.Enabled:=false;
      //btnOutput.Enabled:=false;

      if btnReport.CanFocus then
        btnReport.SetFocus;
    end; // --
end;

procedure TframeDebtors.dtBillsUntilChange(Sender: TObject);
var
  b: boolean;
begin
  b := trim(TDateEdit(Sender).Text) <> '';
  chkCurrencyDiff.Checked := b;
  chkCurrencyDiff.Enabled := b;
end;

procedure TframeDebtors.btnCleanClick(Sender: TObject);
begin
  FLastClientcode := '';
  FSelectedClientId := 0;
  edtClientCode.Text := '';
  edtCustNameAndRegCode.Text := '';


  dtBillsUntil.Date := now;
  dtBillsUntil.Text := '';
  edtDDaysOver.Text := '';

  cmbCurrencyList.ItemIndex := 0;
  cmbBillCreatedby.ItemIndex := 0;
  //btnReport.Enabled:=false;
  //btnOutput.Enabled:=false;

  chkCurrencyDiff.Checked := False;
  chkCurrencyDiff.Enabled := False;


  if edtClientCode.CanFocus then
    edtClientCode.SetFocus;
end;


procedure TframeDebtors.btnOpenClientListClick(Sender: TObject);
var
  pClient: TClientData;
begin
  try
    pClient := estbk_frm_choosecustmer.__chooseClient(edtClientCode.Text);
    assignClientData(pClient);
  finally
    FreeAndNil(pClient);
  end;
end;

procedure TframeDebtors.btnOutputClick(Sender: TObject);
var
  pFindPOwner: TWincontrol;
begin
  pFindPOwner := self.Parent;
  while assigned(pFindPOwner) do
  begin
    if (pFindPOwner is TPageControl) or (pFindPOwner is TForm) then
      break;

    // ---
    pFindPOwner := pFindPOwner.Parent;
  end;

  popupReportType.PopUp(TForm(pFindPOwner).left + TSpeedButton(Sender).left + TSpeedButton(Sender).Width + 2,
    TForm(pFindPOwner).top + TSpeedButton(Sender).top + TSpeedButton(Sender).Height + 119);
end;


procedure TframeDebtors.btnReportClick(Sender: TObject);
var
  pBillDate: TDatetime;
  pSalePersonId: integer;
  pSortByField: integer;
  pCurrency: AStr;
begin
  FBillSumAll := 0;
  FPaidSumAll := 0;
  FToPaySumAll := 0;

  with qryDebtBills, SQL do
  begin
    Close;
    Clear;

    if dtBillsUntil.Text <> '' then
      pBillDate := dtBillsUntil.date
    else
      pBillDate := Math.Nan;
    pSalePersonId := 0;
    pSortByField := 0;

    if cmbBillCreatedby.ItemIndex > 0 then
      pSalePersonId := PtrInt(cmbBillCreatedby.Items.Objects[cmbBillCreatedby.ItemIndex]);


    if cmbSortByFields.ItemIndex >= 0 then
      pSortByField := PtrInt(cmbSortByFields.Items.Objects[cmbSortByFields.ItemIndex]);

    if cmbCurrencyList.ItemIndex > 0 then
      pCurrency := cmbCurrencyList.Text
    else
      pCurrency := '';
    add(estbk_sqlclientcollection._SQLGetUnpaidBills(estbk_globvars.glob_company_id, billType, self.FSelectedClientId,
      strtointdef(edtDDaysOver.Text, 0), pBillDate, pCurrency, chkBoxPartiallyPaid.Checked, pSalePersonId,
      pSortByField, pchkboxSortOrder.Checked));




    Open;
    First;

    // sql.SaveToFile('c:\debug\test.txt');
    // --
    //btnReport.Enabled:=not eof;
    //btnOutput.Enabled:=not eof;
    if EOF then
      Dialogs.MessageDlg(estbk_strmsg.SEQryRetNoData, mtError, [mbOK], 0)
    else
    begin
      report.ShowProgress := True;
      report.LoadFromFile(includetrailingbackslash(self.reportDefPath) + estbk_reportconst.COverDueBillsFilename);
      if mnuItemScreen.Checked then
        report.ShowReport
      else
      if mnuItemPdfFile.Checked then
      begin
        saveRep.FileName := estbk_strmsg.CSDebtorFile + '.pdf';
        if saveRep.Execute then
        begin
          if report.PrepareReport then
            report.ExportTo(TFrTNPDFExportFilter, saveRep.Files.Strings[0]);
        end; // --
      end
      else
      if mnuItemCsv.Checked then
      begin
        saveRep.FileName := estbk_strmsg.CSDebtorFile + '.csv';
        if saveRep.Execute then
        begin
          if report.PrepareReport then
            report.ExportTo(TFrTNPDFExportFilter, saveRep.Files.Strings[0]);
        end; // --
      end;
      // ---
    end;
  end;
end;

function TframeDebtors.getDataLoadStatus: boolean;
begin
  Result := qryDebtBills.Active;
end;

procedure TframeDebtors.setDataLoadStatus(const v: boolean);
begin
  qryDebtBills.Close;
  qryDebtBills.SQL.Clear;
  if v then
    qryDebtBills.Connection := dmodule.primConnection
  else
    qryDebtBills.Connection := nil;
end;

initialization
  {$I estbk_fra_debtorlist.ctrs}

end.