unit estbk_fra_genledgreportcriterias;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface


uses
  Classes, SysUtils, FileUtil, LResources, LCLProc, Controls, Forms, StdCtrls, Calendar, Graphics,
  EditBtn, CheckLst, ExtCtrls, Buttons, Menus, Dialogs, estbk_fra_template, estbk_uivisualinit, estbk_clientdatamodule,
  estbk_lib_commonevents, estbk_reportconst, estbk_reportsqlcollection, estbk_types,
  estbk_globvars, LCLType, ComCtrls, LR_BarC, LR_Desgn, LR_Class, LR_View,
  LR_DSet, LR_DBSet, lr_e_csv, lr_e_pdf, DB, ZDataset;

type

  { TframeGenledreportcrit }

  TframeGenledreportcrit = class(Tfra_template)
    btnClose: TBitBtn;
    btnReport: TBitBtn;
    chkboxNoZLines: TCheckBox;
    chkBoxAccDate: TCheckBox;
    chkBoxAccDescr: TCheckBox;
    chkBoxAccDocnr: TCheckBox;
    chkBoxAccNr: TCheckBox;
    chkBoxAccObj: TCheckBox;
    chkBoxAccPartner: TCheckBox;
    chkBoxAccShowCurr: TCheckBox;
    chkboxsortOrderAZ: TCheckBox;
    cmbPreDefPer: TComboBox;
    dtEditEnd: TDateEdit;
    dtEditStart: TDateEdit;
    edtSrcAccount: TEdit;
    lblDispl: TLabel;
    lblPerEnd: TLabel;
    lblPermisc: TLabel;
    lblPerStart: TLabel;
    prightPanel: TPanel;
    pLeftPanel: TPanel;
    pMainResizePanel: TPanel;
    qryAccounts: TZQuery;
    qryObjects: TZQuery;
    repAccounts: TListView;
    pItemRemAllChk: TMenuItem;
    pItemMarkAllChk: TMenuItem;
    mnuItemCsv: TMenuItem;
    pAccListPopup: TPopupMenu;
    repObjects: TListView;
    reportdata: TfrDBDataSet;
    report: TfrReport;
    mnuItemScreen: TMenuItem;
    mnuItemPdfFile: TMenuItem;
    plogicalgrp: TGroupBox;
    popupReportType: TPopupMenu;
    saveRep: TSaveDialog;
    qryGetReportData: TZQuery;
    Splitter1: TSplitter;
    spRaptype: TSpeedButton;
    srcImage: TImage;
    srcListDelaydFocus: TTimer;
    procedure btnCloseClick(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure chkboxsortOrderAZChange(Sender: TObject);
    procedure cmbPreDefPerChange(Sender: TObject);
    procedure cmbPreDefPerKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure cmbPreDefPerKeyPress(Sender: TObject; var Key: char);
    procedure dtEditStartExit(Sender: TObject);
    procedure edtSrcAccountKeyPress(Sender: TObject; var Key: char);

    procedure mnuItemScreenClick(Sender: TObject);
    procedure pItemMarkAllChkClick(Sender: TObject);
    procedure pItemRemAllChkClick(Sender: TObject);
    procedure plogicalgrpClick(Sender: TObject);
    procedure repAccountsAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: boolean);
    procedure repAccountsClick(Sender: TObject);
    procedure repAccountsColumnClick(Sender: TObject; Column: TListColumn);
    procedure repAccountsCompare(Sender: TObject; Item1, Item2: TListItem; Data: integer; var Compare: integer);
    procedure repAccountsItemChecked(Sender: TObject; Item: TListItem);
    procedure repAccountsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure reportBeginBand(Band: TfrBand);
    procedure reportEndBand(Band: TfrBand);
    procedure reportEnterRect(Memo: TStringList; View: TfrView);
    procedure reportGetValue(const ParName: string; var ParValue: variant);
    procedure spRaptypeClick(Sender: TObject);
    procedure srcListDelaydFocusTimer(Sender: TObject);
  private
    FSelectedColumn: integer;
    //FPActiveTitleIndx : Integer;

    // 3 erineva aruandluse muutujad !
    FReportMode: TGenLedReportMode;
    FRepDefFile: AStr;

    FBalChgByAcc: double;
    // käibeandmikku summary footeri jaoks, meil lihtsam ise arvud kokku lüüa !
    Fstbalsum_d: double; // aktiva kontode d algsummad
    Fstbalsum_c: double; // passiva kontode k algsummad

    Ftr_dsum: double; // deebetkäive
    Ftr_csum: double; // kreeditkäive

    Fbsum_d: double; // aktiva kontode d lõppsumma
    Fbsum_c: double; // passiva kontode k lõppsumma

    // --
    FExtDataPosCorr: boolean;
    // ---------------------------
    FReportBMask: integer;
    FFrameKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    procedure canShowValuesOnReport(const pParlow: AStr; var pTempRez: variant);
    procedure repChkBoxItemVisStatus(const v: boolean);
    procedure setRepMode(const v: TGenLedReportMode);
  public
    // 22.11.2009 Ingmar
    procedure refreshAccountList;
    procedure refreshObjectList;
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published // RTTI probleem
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    // -----------
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
    property reportDefPath: AStr read FRepDefFile write FRepDefFile;
    property reportMode: TGenLedReportMode read FReportMode write setRepMode;
  end;

implementation

uses Math, variants, estbk_strmsg, estbk_utilities,
  estbk_sqlclientcollection, estbk_dbcompability, estbk_lib_mapdatatypes;

{

Code:


[SUM([dsReport."Price"])]



Where:
dsReport: TDataSet (TDbf, TSqlite or other)... LazReport need be connected with it...
Price: The field where sum will be calculate...
}

constructor TframeGenledreportcrit.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  // -------
  estbk_uivisualinit.__preparevisual(self);
  estbk_reportconst.fillReportDtPer(TAStrings(cmbPreDefPer.items));

  pItemRemAllChk.Caption := estbk_strmsg.SCLstUnSelectAllItems;
  pItemMarkAllChk.Caption := estbk_strmsg.SCLstSelectAllItems;


  repAccounts.Column[0].Tag := 1;
  repAccounts.Column[0].ImageIndex := estbk_clientdatamodule.img_indxitemChecked;

  repAccounts.Column[1].Tag := 0;
  repAccounts.Column[1].ImageIndex := estbk_clientdatamodule.img_indxitemUnChecked;
end;

destructor TframeGenledreportcrit.Destroy;
begin
  inherited Destroy;
end;


// reaalsuses seda vaja pole !
function TframeGenledreportcrit.getDataLoadStatus: boolean;
begin
  Result := qryAccounts.active;
end;

// 22.11.2009 Ingmar
procedure TframeGenledreportcrit.refreshAccountList;
var
  pIndex: integer;
  pListItem: TListItem;
begin
  with qryAccounts, SQL do
    try
      repAccounts.BeginUpdate;
      // ---

      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLGetAllAccounts);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      First;

      repAccounts.Clear;

      while not EOF do
      begin

        if FieldByName('id').AsInteger > 0 then
        begin
          pListItem := repAccounts.Items.Add;
          pListItem.Data := TObject(PtrInt(FieldByName('id').AsInteger));
          pListItem.Caption := FieldByName('account_coding').AsString;

          pListItem.SubItems.Add(FieldByName('account_name').AsString);
          pListItem.Checked := True;
        end;

        // --
        Next;
      end;


      // -- scroll fix
      repAccounts.Width := repAccounts.Width + 1;
      repAccounts.Width := repAccounts.Width - 1;
      qryAccounts.First;
    finally
      repAccounts.EndUpdate;
    end;
end;

// 15.10.2011 Ingmar
procedure TframeGenledreportcrit.refreshObjectList;
var
  pListItem: TListItem;
begin
  with qryObjects, SQL do
    try
      repObjects.BeginUpdate;
      repObjects.Clear;
      // ---

      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLAllObjects);
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      Open;
      First;
      while not EOF do
      begin

        if FieldByName('id').AsInteger > 0 then
        begin
          pListItem := repObjects.Items.Add;
          pListItem.Data := TObject(PtrInt(FieldByName('id').AsInteger));
          pListItem.Caption := FieldByName('descr').AsString;
          pListItem.Checked := False;
        end;

        // --
        Next;
      end;

    finally
      repObjects.EndUpdate;
    end;
end;

// lazarusel oli bugi, et frame kaotab aeg-ajalt ära connection objekti !!!!!!!!!!!!!!!!!
procedure TframeGenledreportcrit.setDataLoadStatus(const v: boolean);
begin
  case v of
    True:
    begin
      qryGetReportData.Connection := estbk_clientdatamodule.dmodule.primConnection;
      qryAccounts.Connection := estbk_clientdatamodule.dmodule.primConnection;
      qryObjects.Connection := estbk_clientdatamodule.dmodule.primConnection;
      // --------
      self.refreshAccountList();
      self.refreshObjectList;
    end;

    False:
    begin
      qryGetReportData.Connection := nil;
      qryAccounts.Connection := nil;
      qryObjects.Connection := nil;
    end;
  end;
end;

procedure TframeGenledreportcrit.repChkBoxItemVisStatus(const v: boolean);
var
  i: integer;
begin
  lblDispl.Visible := v;
  for i := 0 to self.ComponentCount - 1 do
    if (self.Components[i] is TCheckBox) and (TCheckBox(self.Components[i]).tag = 0) then
      TCheckBox(self.Components[i]).Visible := v;

end;

procedure TframeGenledreportcrit.setRepMode(const v: TGenLedReportMode);
begin
  self.FReportMode := v;

  case v of
    CRep_generalledger:
    begin
      self.plogicalgrp.Caption := estbk_strmsg.SCaptGenLedgerReport;
      self.repAccounts.Visible := True;
      self.repObjects.Visible := True;
      self.srcImage.Visible := True;
      self.edtSrcAccount.Visible := True;

      // 11.03.2012 Ingmar
      //chkboxNoZLines.Visible:=false;
      chkboxNoZLines.Visible := True;
      self.chkboxsortOrderAZ.Checked := True;
      // ---
      repChkBoxItemVisStatus(True);

      cmbPreDefPer.ItemIndex := 1;
      cmbPreDefPer.onChange(cmbPreDefPer);
    end;

    CRep_journal:
    begin
      self.plogicalgrp.Caption := estbk_strmsg.SCaptJournalReport;
      self.repAccounts.Visible := False;
      self.repObjects.Visible := False;
      self.srcImage.Visible := False;
      self.edtSrcAccount.Visible := False;

      chkboxNoZLines.Visible := False;
      self.chkboxsortOrderAZ.Checked := True;
      repChkBoxItemVisStatus(True);

      cmbPreDefPer.ItemIndex := 1;
      cmbPreDefPer.onChange(cmbPreDefPer);
    end;

    CRep_turnover:
    begin
      chkboxNoZLines.Visible := True;
      self.plogicalgrp.Caption := estbk_strmsg.SCaptDTurnoverReport;
      self.repAccounts.Visible := True;
      self.repObjects.Visible := False;
      self.srcImage.Visible := True;
      self.edtSrcAccount.Visible := True;


      self.chkboxsortOrderAZ.Checked := True;

      repChkBoxItemVisStatus(False);

      cmbPreDefPer.ItemIndex := 4;
      cmbPreDefPer.onChange(cmbPreDefPer);
    end;
  end;
end;

procedure TframeGenledreportcrit.spRaptypeClick(Sender: TObject);
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

  //  if pFindPOwner is TPageControl then
  //     popupReportType.PopUp(TForm(self.owner).left+TSpeedButton(sender).left+TSpeedButton(sender).width+10,
  //                           TForm(self.owner).top+TSpeedButton(sender).top+TSpeedButton(sender).height+98)
  //  else
  popupReportType.PopUp(TForm(pFindPOwner).left + TSpeedButton(Sender).left + TSpeedButton(Sender).Width + 4,
    TForm(pFindPOwner).top + TSpeedButton(Sender).top + TSpeedButton(Sender).Height + 127);

  // popupReportType.PopUp(TSpeedButton(sender).left+TSpeedButton(sender).width+10,
  //                       TSpeedButton(sender).top+TSpeedButton(sender).height+98);

end;

procedure TframeGenledreportcrit.srcListDelaydFocusTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;

  // võtame fookuse tagasi

  // if edtSrcAccount.CanFocus then
  //    edtSrcAccount.SetFocus;

end;


procedure TframeGenledreportcrit.btnReportClick(Sender: TObject);
var
  i: integer;
  pgSQL: AStr;
  pCompanyId: integer;
  pSelAccounts: TADynIntArray;
  pSelObjects: TADynIntArray;
  pStart: TDateTime;
  pEnd: TDateTime;
  pCrs: TCursor;
  pFileName: AStr;
  pDefFileName: AStr;
  dTempTableName: AStr;
  pOnlyGenLederEntry: boolean;
begin

  if trim(dtEditStart.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEDateNotChoosen, mtError, [mbOK], 0);
    if dtEditStart.CanFocus then
      dtEditStart.SetFocus;
  end;

  if trim(dtEditEnd.Text) = '' then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEDateNotChoosen, mtError, [mbOK], 0);
    if dtEditEnd.CanFocus then
      dtEditEnd.SetFocus;
  end;

  if (dtEditStart.date > dtEditEnd.date) then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEStartDateQtEndDate, mtError, [mbOK], 0);
    if dtEditStart.CanFocus then
      dtEditStart.SetFocus;
    exit;
  end;

  // -- üldiselt võiks siin teha eelpuhverduse, aga õnneks pole palju andmeid võib ka nii teha
  pSelAccounts := nil;
  pSelObjects := nil;


  if repAccounts.Visible then
    for i := 0 to repAccounts.Items.Count - 1 do
      if repAccounts.Items.Item[i].Checked then
      begin
        setLength(pSelAccounts, length(pSelAccounts) + 1);
        pSelAccounts[high(pSelAccounts)] := PtrInt(repAccounts.Items.Item[i].Data);
      end;



  if (length(pSelAccounts) < 1) and repAccounts.Visible then
  begin
    Dialogs.messageDlg(estbk_strmsg.SEAccountNotChoosen, mtError, [mbOK], 0);
    if repAccounts.CanFocus then
      repAccounts.SetFocus;
    Exit;
  end;

  // 15.10.2011 Ingmar
  if repObjects.Visible then
    for i := 0 to repObjects.Items.Count - 1 do
      if repObjects.Items.Item[i].Checked then
      begin
        setLength(pSelObjects, length(pSelObjects) + 1);
        pSelObjects[high(pSelObjects)] := PtrInt(repObjects.Items.Item[i].Data);
      end;




  pStart := dtEditStart.date;
  pEnd := dtEditEnd.date;

  // hetkel vaikimisi firma !
  pCompanyId := estbk_globvars.glob_company_id;
  // ---

  if chkBoxAccNr.Checked then
    FReportBMask := FReportBMask + estbk_reportconst.CGenLed_accnr;

  if chkBoxAccDate.Checked then
    FReportBMask := FReportBMask + estbk_reportconst.CGenLed_accdate;

  if chkBoxAccDocnr.Checked then
    FReportBMask := FReportBMask + estbk_reportconst.CGenLed_accdocnr;

  if chkBoxAccDescr.Checked then
    FReportBMask := FReportBMask + estbk_reportconst.CGenLed_accdescr;

  //   if chkBoxAccDebt.checked  then
  //      FReportBMask:=FReportBMask+estbk_reportconst.CGenLed_accdebt;

  //   if chkBoxAccCred.checked  then
  //      FReportBMask:=FReportBMask+estbk_reportconst.CGenLed_acccred;

  if chkBoxAccShowCurr.Checked then
    FReportBMask := FReportBMask + estbk_reportconst.CGenLed_accshowcurr;

  // 15.10.2011 Ingmar
  //    if chkBoxAccObj.checked  then
  //       FReportBMask:=FReportBMask+estbk_reportconst.CGenLed_accobj;
  pOnlyGenLederEntry := False;


  try
    // ---------------------------------------------------------------------
    // et erinevate platvormide puhul ajutine tabel kenasti kustutataks !
    dmodule.primConnection.StartTransaction;
    // ---------------------------------------------------------------------
    try

      pCrs := screen.cursor;
      screen.cursor := crHourGlass;

      // --- teeme päringu
      qryGetReportData.Close;
      qryGetReportData.SQL.Clear;
      dTempTableName := '';
      // --
      case self.reportMode of
        CRep_generalledger:
        begin
          // esimene puhverdus; tulevikus teha view'd
          pgSQL := estbk_reportsqlcollection._CSQLRepGeneralLegderEntrysSpeedUpTablePart1(pCompanyId, dTempTableName, pSelAccounts);

          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;



          // teine puhverdus;
          // saldoinfo enne kuupäeva pStart !
          pgSQL := estbk_reportsqlcollection._CSQLRepGeneralLegderEntrysSpeedUpTablePart2(pCompanyId, dTempTableName,
            pSelAccounts, pStart);

          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;


          pgSQL := estbk_reportsqlcollection._CSQLRepGeneralLegderEntrysSpeedUpTablePart3(pCompanyId, dTempTableName, pStart);

          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;
          // ----------------
          // 11.03.2012 Ingmar
                               (*
                               pgSQL:=estbk_reportsqlcollection._CSQLRepGeneralLegderZBalance(pCompanyId,
                                                                                              dTempTableName,
                                                                                              pSelAccounts,
                                                                                              pSelObjects,
                                                                                              pStart,
                                                                                              pEnd);


                               qryGetReportData.Close;
                               qryGetReportData.SQL.Clear;
                               qryGetReportData.SQL.add(pgSQL);
                               qryGetReportData.ExecSQL;*)


          // ----------------

          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;


          // lõplik select !
          pgSQL := estbk_reportsqlcollection._CSQLRepGeneralLegderEntrysSpeedUpTablePart4(pCompanyId, dTempTableName,
            pSelAccounts, pSelObjects, pStart, pEnd, chkboxsortOrderAZ.Checked);
          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;
          // @@@@  11.03.2012 Ingmar
          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          pgSQL := estbk_reportsqlcollection._CSQLRepGeneralLegderEntrysFinalQry(pCompanyId, dTempTableName,
            chkboxsortOrderAZ.Checked, chkboxNoZLines.Checked);


          pDefFileName := estbk_strmsg.CSGenLedgerFile;
        end;

        CRep_journal:
        begin
          pgSQL := estbk_reportsqlcollection._CSQLRepGeneralJournalEntrys(pCompanyId, pSelAccounts, nil,// objektid tulevad veel
            pStart, pEnd, chkboxsortOrderAZ.Checked, pOnlyGenLederEntry);
          pDefFileName := estbk_strmsg.CSGenLedgerJournalFile;
        end;
        // 26.11.2009 Ingmar;
        CRep_turnover:
        begin
          // @1
          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          pgSQL := estbk_reportsqlcollection._CSQLRepDTurnoverEntrysSpeedUpTablePart1(pCompanyId, dTempTableName, pSelAccounts);
          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;

          // @2
          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          pgSQL := estbk_reportsqlcollection._CSQLRepDTurnoverEntrysSpeedUpTablePart2(pCompanyId, dTempTableName, pStart);
          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;


          // @3
          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          pgSQL := estbk_reportsqlcollection._CSQLRepDTurnoverEntrysSpeedUpTablePart3(pCompanyId, dTempTableName, pStart);
          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;


          // @4
          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          pgSQL := estbk_reportsqlcollection._CSQLRepDTurnoverEntrysSpeedUpTablePart4(pCompanyId, dTempTableName, pStart, pEnd);


          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;

          // --
          // 5 25.11.2011 Ingmar; allkontode teema !
                              {
                              qryGetReportData.Close;
                              qryGetReportData.SQL.Clear;
                              pgSQL:=estbk_reportsqlcollection._CSQLRepDTurnoverEntrysSpeedUpTablePart5(dTempTableName);
                              qryGetReportData.SQL.add(pgSQL);
                              qryGetReportData.ExecSQL;
                              }

          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          pgSQL := estbk_reportsqlcollection._CSQLRepDTurnoverEntrysSpeedUpTablePart6(dTempTableName);
          qryGetReportData.SQL.add(pgSQL);
          qryGetReportData.ExecSQL;

          if chkboxNoZLines.Checked then
          begin
            // 01.12.2011 Ingmar
            qryGetReportData.Close;
            qryGetReportData.SQL.Clear;
            pgSQL := estbk_reportsqlcollection._CSQLRepDTurnoverEntrysSpeedUpTablePart7(dTempTableName);
            qryGetReportData.SQL.add(pgSQL);
            qryGetReportData.ExecSQL;
          end;



          qryGetReportData.Close;
          qryGetReportData.SQL.Clear;
          pgSQL := estbk_reportsqlcollection._CSQLRepDTurnoverEntrys(dTempTableName, chkboxsortOrderAZ.Checked);
          pDefFileName := estbk_strmsg.CSTurnoverFile;
        end;
        // ------------
      end;




      // ---
      qryGetReportData.SQL.add(pgSQL);
      qryGetReportData.Open;




      // --
    finally
      screen.cursor := pCrs;
    end;


    if qryGetReportData.EOF then
      messageDlg(estbk_strmsg.SEQryRetNoData, mtInformation, [mbOK], 0)
    else
    begin
           {
                frReport1.LoadFromFile('TheReportFile.lrf');
       if frReport1.PrepareReport then
          frReport1.ExportTo(TFrTNPDFExportFilter, 'TheOutputPDFReport.pdf');
           }
      self.FExtDataPosCorr := False;
      self.Fstbalsum_d := 0;
      self.Fstbalsum_c := 0;

      self.Ftr_dsum := 0;
      self.Ftr_csum := 0;

      self.Fbsum_d := 0;
      self.Fbsum_c := 0;

      self.FBalChgByAcc := 0;

      // --- !!!!!
      //report.ShowPreparedReport;
      report.ShowProgress := True;

      // millist aruande def. faili me siis kasutame !
      case self.reportMode of
        CRep_generalledger: report.LoadFromFile(includetrailingbackslash(self.reportDefPath) +
            estbk_reportconst.CGenLedgerReportFilename);

        CRep_journal: report.LoadFromFile(includetrailingbackslash(self.reportDefPath) + estbk_reportconst.CGenJournalReportFilename);

        CRep_turnover: report.LoadFromFile(includetrailingbackslash(self.reportDefPath) + estbk_reportconst.CGenTurnoverReportFilename);
      end;




      //report.Dataset:=reportdata;
      if mnuItemScreen.Checked then
        report.ShowReport
      else

      // http://lazarus.developpez.com/cours/lazreport/
      // TfrTextExportFilter
      // TfrHTMExport
      if mnuItemPdfFile.Checked then
      begin
        // TODO
        pFileName := stringreplace(dtEditStart.Text, '.', '', [rfReplaceAll]) + '_' + stringreplace(
          dtEditEnd.Text, '.', '', [rfReplaceAll]);

        saveRep.FileName := format(pDefFileName, [pFileName]) + '.pdf';
        if saveRep.Execute then
        begin
          if report.PrepareReport then
            report.ExportTo(TFrTNPDFExportFilter, saveRep.Files.Strings[0]);
        end;
        // ----
      end
      else
      if mnuItemCsv.Checked then
      begin
        // TODO
        pFileName := stringreplace(dtEditStart.Text, '.', '', [rfReplaceAll]) + '_' + stringreplace(
          dtEditEnd.Text, '.', '', [rfReplaceAll]);

        saveRep.FileName := format(pDefFileName, [pFileName]) + '.csv';
        if saveRep.Execute then
        begin
          if report.PrepareReport then
            report.ExportTo(TfrCSVExportFilter, saveRep.Files.Strings[0]);
        end;

        // ----
      end;
    end;


    // ---------------------------------------------------------------------
    // et erinevate platvormide puhul ajutine tabel kenasti kustutataks !
    dmodule.primConnection.Commit;
    // ---------------------------------------------------------------------

  except
    on e: Exception do
    begin
      if dmodule.primConnection.InTransaction then
        try
          dmodule.primConnection.Rollback;
        except
        end;
      Dialogs.messageDlg(format(estbk_strmsg.SECantCreateReport, [e.message]), mtError, [mbOK], 0);
    end;
  end;
  // ---
end;

procedure TframeGenledreportcrit.btnCloseClick(Sender: TObject);
begin
  if assigned(self.FFrameKillSignal) then
    self.FFrameKillSignal(self);
end;

procedure TframeGenledreportcrit.chkboxsortOrderAZChange(Sender: TObject);
const
  CrepStr: array[boolean] of AStr = ('A-Z', 'Z-A');
var
  b: boolean;
begin
  b := TCheckBox(Sender).Checked;
  TCheckBox(Sender).Caption := stringreplace(TCheckBox(Sender).Caption, CrepStr[b], CrepStr[not b], []);
end;


procedure TframeGenledreportcrit.cmbPreDefPerChange(Sender: TObject);
var
  pDtType: estbk_types.TdtPeriod;
  pdtStart: TDatetime;
  pdtEnd: TDatetime;
  zVal: boolean;
begin
  zVal := True;
  with TComboBox(Sender) do
    if ItemIndex >= 0 then
    begin
      pDtType := estbk_types.TdtPeriod(cardinal(Items.Objects[ItemIndex]));
      if pDtType <> cdt_undefined then
      begin
        estbk_utilities.decodeDtRange(pDtType, pdtStart, pdtEnd);

        dtEditStart.date := pdtStart;
        dtEditEnd.date := pdtEnd;

        dtEditStart.Text := datetostr(pdtStart);
        dtEditEnd.Text := datetostr(pdtEnd);
        zVal := False;
      end;
    end;

  // ----
  if zVal then
  begin
    dtEditStart.date := now;
    dtEditEnd.date := now;

    dtEditStart.Text := '';
    dtEditEnd.Text := '';
  end;

end;

procedure TframeGenledreportcrit.cmbPreDefPerKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    TComboBox(Sender).DroppedDown := not TComboBox(Sender).DroppedDown;
    key := 0;
  end;
end;

procedure TframeGenledreportcrit.cmbPreDefPerKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    key := #0;
  end;
end;

procedure TframeGenledreportcrit.dtEditStartExit(Sender: TObject);
var
  fVdate: TDatetime;
  fDateStr: AStr;
begin
  fVdate := Now;
  fDateStr := TDateEdit(Sender).Text;

  if (trim(fDateStr) <> '') then
    if not validateMiscDateEntry(fDateStr, fVDate) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
      TDateEdit(Sender).SetFocus;
      Exit;
    end
    else
    begin
      TDateEdit(Sender).Text := datetostr(fVDate);
    end;
end;

procedure TframeGenledreportcrit.edtSrcAccountKeyPress(Sender: TObject; var Key: char);
var
  pFieldname: AStr;
  i: integer;
begin
  if key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    key := #0;
  end
  else
  begin
    if self.FSelectedColumn = 0 then
      pFieldname := 'account_coding'
    else
    if self.FSelectedColumn = 1 then
      pFieldname := 'account_name';
    estbk_utilities.edit_autoCompData(Sender as TCustomEdit, key, qryAccounts, pFieldname);
    //TCustomEdit(Sender).SelectAll;
    //TCustomEdit(Sender).SelStart:=length(TCustomEdit(Sender).Text);
    // TODO: optimiseerida otsingut !
    for i := 0 to repAccounts.Items.Count - 1 do
      if PtrInt(repAccounts.Items.Item[i].Data) = PtrInt(qryAccounts.FieldByName('id').AsInteger) then
      begin
        // et pika listi puhul scroll ikka ära toimuks !


        repAccounts.ItemFocused := repAccounts.Items.Item[i];
        repAccounts.ItemFocused.MakeVisible(False);

        // if repAccounts.CanFocus then
        //    repAccounts.SetFocus;

        repAccounts.Selected := repAccounts.Items.Item[i];
        repAccounts.Selected.Focused := True;

        //srcListDelaydFocus.Enabled:=true;
        break;
      end;
    // ---
  end;
end;




procedure TframeGenledreportcrit.mnuItemScreenClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to self.popupReportType.Items.Count - 1 do
    self.popupReportType.Items[i].Checked := False;
  TMenuItem(Sender).Checked := True;

  if btnReport.CanFocus then
    btnReport.SetFocus;
end;

procedure TframeGenledreportcrit.pItemMarkAllChkClick(Sender: TObject);
var
  i: integer;
begin
  with repAccounts do
    for i := 0 to Items.Count - 1 do
      items.item[i].Checked := True;
end;

procedure TframeGenledreportcrit.pItemRemAllChkClick(Sender: TObject);
var
  i: integer;
begin
  with repAccounts do
    for i := 0 to Items.Count - 1 do
      items.item[i].Checked := False;
end;

procedure TframeGenledreportcrit.plogicalgrpClick(Sender: TObject);
begin
  // --
end;

// http://delphi.about.com/od/delphitips2007/qt/listviewchecked.htm
(*

   //position of the mouse cursor related to ListView
   lvCursosPos := lv.ScreenToClient(Mouse.CursorPos) ;

   //click where?
   hts := lv.GetHitTestInfoAt(lvCursosPos.X, lvCursosPos.Y);

   //locate the state-clicked item
   if htOnStateIcon in hts then
   begin
     li := lv.GetItemAt(lvCursosPos.X, lvCursosPos.Y);
     if Assigned(li) then
     begin
       if li.StateIndex = lisNonSelectable then Exit;

       for lii in lv.Items do
        if lii.StateIndex <> lisNonSelectable then lii.StateIndex := lisNotSelectd;

       li.StateIndex := lisSelected;
     end;
   end;
*)

procedure TframeGenledreportcrit.repAccountsAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: boolean);
var
  r: TRect;
begin
  r := item.DisplayRect(drIcon);
  if stage = cdPostPaint then
  begin
    // 15.10.2011 Ingmar; muidu jättis tobeda triibu W7 all nähtavaks !
    Sender.Canvas.FillRect(r);
    dmodule.sharedImages.Draw(Sender.Canvas, r.Left - 20, r.Top + 1, estbk_clientdatamodule.img_indxEmptyImg);
    // värvime nö olemasoleva checkboxi üle !

    if item.Checked then
      dmodule.sharedImages.Draw(Sender.Canvas, r.Left - 14, r.Top + 1, estbk_clientdatamodule.img_indxitemChecked) // -11
    else
      dmodule.sharedImages.Draw(Sender.Canvas, r.Left - 14, r.Top + 1, estbk_clientdatamodule.img_indxitemUnChecked);
  end;
end;

procedure TframeGenledreportcrit.repAccountsClick(Sender: TObject);
begin
  // ---
end;

procedure TframeGenledreportcrit.repAccountsColumnClick(Sender: TObject; Column: TListColumn);
const
  CCursorDeltaPx = 36;
  CShiftRangePx = 6;

var
  i: integer;
  prelX: integer;
  pMouseX: integer;
  pLastCol: integer;
  pParent: TWinControl;
begin
  self.FSelectedColumn := Column.Index;


  pMouseX := Mouse.CursorPos.X;
  prelX := 0; // TListView(Sender).Left;
  pParent := TListView(Sender);
  while assigned(pParent) do
  begin
    prelX := prelX + pParent.Left;
    pParent := pParent.Parent;
  end;

  if Column.Index = 0 then
    prelX := prelX + CCursorDeltaPx
  else
    for i := 0 to repAccounts.Columns.Count - 1 do
      if i < Column.Index then
        prelX := prelX + repAccounts.Columns.Items[i].Width + CCursorDeltaPx
      else
        break;



  if (pMouseX >= prelX - CShiftRangePx) and (pMouseX <= prelX + CShiftRangePx) then
  begin

    for i := 0 to repAccounts.Columns.Count - 1 do
      repAccounts.Columns.Items[i].ImageIndex := estbk_clientdatamodule.img_indxitemUnChecked;
    Column.ImageIndex := estbk_clientdatamodule.img_indxitemChecked;
    edtSrcAccount.Text := '';
  end
  else
  begin
    repAccounts.SortType := stNone;

    // ASC/DESC järjestus !
    if repAccounts.Columns.Items[FSelectedColumn].Tag = 0 then
      repAccounts.Columns.Items[FSelectedColumn].Tag := 1
    else
      repAccounts.Columns.Items[FSelectedColumn].Tag := 0;
    repAccounts.SortColumn := FSelectedColumn;
    repAccounts.SortType := stText;
  end;

end;

procedure TframeGenledreportcrit.repAccountsCompare(Sender: TObject; Item1, Item2: TListItem; Data: integer; var Compare: integer);
var
  p1: AStr;
  p2: AStr;
begin
  if FSelectedColumn = 0 then
  begin
    p1 := Item1.Caption;
    p2 := Item2.Caption;
  end
  else
  begin
    p1 := Item1.SubItems.Strings[0];
    p2 := Item2.SubItems.Strings[0];
  end;

  // TODO utf8 peale !
  case TListView(Sender).Column[FSelectedColumn].tag of
    0: Compare := AnsiCompareStr(p1, p2); // asc
    1: Compare := AnsiCompareStr(p2, p1); // desc
  end;
end;

procedure TframeGenledreportcrit.repAccountsItemChecked(Sender: TObject; Item: TListItem);
var
  pItemCode: AStr;
  i: integer;
begin
  // ---
  if TListView(Sender).Tag = 0 then
    try
      TListView(Sender).Tag := 1;
      if Item.Checked then
      begin
        pItemCode := Item.Caption;
        for i := Item.Index + 1 to TListView(Sender).Items.Count - 1 do
        begin
          // --
          if pos(pItemCode, TListView(Sender).Items.Item[i].Caption) = 1 then
          begin
            TListView(Sender).Items.Item[i].Checked := True;
          end
          else
            break;
        end;
      end;

    finally
      TListView(Sender).Tag := 0;
    end;
end;

procedure TframeGenledreportcrit.repAccountsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  //   with Sender as TListView do
  //    ItemFocused := GetItemAt(X, Y);
end;


procedure TframeGenledreportcrit.reportBeginBand(Band: TfrBand);
var
  pChangeDelta: double;
  pDisplayObjects: boolean;
begin

  if band.Typ = btGroupHeader then
    self.FBalChgByAcc := 0
  else
  // accountdataband
  if band.Typ = btMasterData then
  begin

    Band.Height := 20; //  vaikimisi laius bandil, kui tulevad objektid ja tehingu osapooled, siis tõmbame bandi laiemaks; 41
    if self.FReportMode = CRep_generalledger then
    begin

      // 11.03.2012 Ingmar
      // tühi fiktiivne "algsaldo" rida
      Band.Visible := not qryGetReportData.FieldByName('transdate').IsNull;

      // --- saldo muutused !!!!
      if (qryGetReportData.FieldByName('account_type').AsString = estbk_types.CAccTypeAsActiva) or
        (qryGetReportData.FieldByName('account_type').AsString = estbk_types.CAccTypeAsCost) then
        pChangeDelta := qryGetReportData.FieldByName('rec_sum_d').AsCurrency - qryGetReportData.FieldByName('rec_sum_c').AsCurrency
      else
        pChangeDelta := qryGetReportData.FieldByName('rec_sum_c').AsCurrency - qryGetReportData.FieldByName('rec_sum_d').AsCurrency;
      self.FBalChgByAcc := self.FBalChgByAcc + pChangeDelta;
    end;


    // 31.08.2011 Ingmar; nüüd kuvame ka objekte; st kuvame kõige viimast !
    if (self.FReportMode in [CRep_generalledger, CRep_journal]) and chkBoxAccObj.Checked and
      (trim(qryGetReportData.FieldByName('object1').AsString) <> '') then
      Band.Height := 36;
    // ---
  end;

end;

procedure TframeGenledreportcrit.reportEndBand(Band: TfrBand);
begin
  // ---
end;

procedure TframeGenledreportcrit.reportEnterRect(Memo: TStringList; View: TfrView);
const
  CExtData = 'extdata';
  CLeftPos1 = 79;
  CLeftPos2 = 97;
  CTopCorr = 12;
var
  pTopCorr: integer;
begin

  // 01.09.2011 Ingmar; no on alles häkk !!!
  if (view.Name = CExtData) and assigned(view.Parent) then
  begin

    //view.Visible:=false;
    if chkBoxAccObj.Checked and (trim(qryGetReportData.FieldByName('object1').AsString) <> '') then
    begin
      // peame labeli bandis alla poole liigutama, asi selle kui kohe see sinna panna, siis ei saa bandi laiust muuta !!!
      // view.Top:=pGetTop+12;

      // view.Top:=view.Top-CTopCorr;
      if not FExtDataPosCorr then
        view.Top := view.Top + CTopCorr;
      view.Visible := True;

      FExtDataPosCorr := True;
      if self.reportMode = CRep_generalledger then
        view.Left := CLeftPos1
      else
        view.Left := CLeftPos2;
    end
    else
    if FExtDataPosCorr then
    begin
      view.Left := 0;
      //view.Visible:=false;
      view.Top := view.Top - CTopCorr;
      FExtDataPosCorr := False;
    end;
  end;
  // if View.Name='extdata' then
  //    View.Height:=0.00; // 0.00;  18
end;

{

const
  CExtData  = 'extdata';
  CLeftPos1 = 79;
  CLeftPos2 = 97;
  CTopCorr  = 12;
var
  pTopCorr : Integer;
begin
// 01.09.2011 Ingmar; no on alles häkk !!!
if (view.Name=CExtData) and assigned(view.Parent) then
  begin

     //view.Visible:=false;
  if chkBoxAccObj.Checked  and (trim(qryGetReportData.FieldByName('object1').AsString)<>'')  then
    begin
    // peame labeli bandis alla poole liigutama, asi selle kui kohe see sinna panna, siis ei saa bandi laiust muuta !!!
    // view.Top:=pGetTop+12;
   { if FExtDataPosCorr then
      view.Top:=view.Top-CTopCorr;}

       view.Top:=view.Top+CTopCorr;
       view.Visible:=true;
       FExtDataPosCorr:=true;
   if  self.reportMode=CRep_generalledger then
       view.Left:=CLeftPos1
   else
       view.Left:=CLeftPos2;
    end{ else
    if FExtDataPosCorr then
    begin
       view.Left:=0;
       view.Visible:=false;
       view.Top:=view.Top-CTopCorr;
       FExtDataPosCorr:=false;
    end;}
  end;
// if View.Name='extdata' then
//    View.Height:=0.00; // 0.00;  18
end;

}

{
[reportdata.document_nr]
[reportdata.transdescr]
[reportdata.rec_sum_d]
[reportdata.rec_sum_c]
[@d_origcval]
[@c_origcval]
[@SCRepAccnr]
[@SCRepAccDate0]
[@SCRepAccDocnr]
[@SCRepAccExpl]
[@SCRepAccDrec]
[@SCRepAccCrec]
}

procedure TframeGenledreportcrit.canShowValuesOnReport(const pParlow: AStr; var pTempRez: variant);
begin
  // tulevikus ka teised vaated !
  //case self.FReportMode of
  //  CRep_generalledger:
  //  begin
  // ---
  if not chkBoxAccNr.Checked and (pParlow = 'reportdata.entrynumber') then
    pTempRez := '';

  if not chkBoxAccDate.Checked and (pParlow = '@scaccdate') then
    pTempRez := '';

  if not chkBoxAccDocnr.Checked and (pParlow = 'reportdata.document_nr') then
    pTempRez := '';

  if not chkBoxAccDescr.Checked and ((pParlow = 'reportdata.transdescr') or (pParlow = 'reportdata.descr')) then
    pTempRez := '';
  //  end;
  //end;
end;

// TODO !
// ja siin toimub labelite maagia; hashtable teha ! siis kiirem väljastus !
procedure TframeGenledreportcrit.reportGetValue(const ParName: string; var ParValue: variant);
var
  pParlow: AStr;
  pArChar: AStr;
  pRecType: AStr;
  //pTempRez: AStr;
  pCurrVal: double;
  pCalc: double;
  pDescrField: boolean;
begin

  if self.reportMode = CRep_journal then
    pArChar := ':'
  else
    pArChar := '';
  pCalc := 0;

  // ----------
  pParlow := trim(ansilowercase(parname));
  if pos('@', parname) > 0 then
    ParValue := '';


  // TODO; kood sai tehtud algul vaid testimiseks; tulevikus koodipuhtuse nimel muudan selle massiivide peale
  // nagu alati ajutised asjad on kõige püsivamad !
  //  tõlked @descr jne

  // --- käibeandmiku spetsiifika !
  if (pParlow = '@startbal_d') or (pParlow = '@startbal_c') then
  begin
    ParValue := '';
    if estbk_utilities.isAccountTypePassiva(qryGetReportData.FieldByName('account_type').AsString) then
    begin
      if (pParlow = '@startbal_c') then
      begin
        pCalc := qryGetReportData.FieldByName('init_balance').AsCurrency;
        pCalc := pCalc + (qryGetReportData.FieldByName('csum').AsCurrency - qryGetReportData.FieldByName('dsum').AsCurrency);
        pCalc := pCalc + (qryGetReportData.FieldByName('csum_sub').AsCurrency - qryGetReportData.FieldByName('dsum_sub').AsCurrency);

        // 01.12.2011 Ingmar; allkontode summasid ei võta uuesti koondi peale
        if (qryGetReportData.FieldByName('csum_sub').AsCurrency = 0.00) and (qryGetReportData.FieldByName('dsum_sub').AsCurrency = 0.00) then
          self.Fstbalsum_c := self.Fstbalsum_c + pCalc;
        ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, pCalc);
      end;
    end
    else
    if (pParlow = '@startbal_d') then
    begin
      pCalc := qryGetReportData.FieldByName('init_balance').AsCurrency;
      pCalc := pCalc + qryGetReportData.FieldByName('dsum').AsCurrency - qryGetReportData.FieldByName('csum').AsCurrency;
      pCalc := pCalc + (qryGetReportData.FieldByName('dsum_sub').AsCurrency - qryGetReportData.FieldByName('csum_sub').AsCurrency);

      // 01.12.2011 Ingmar; allkontode summasid ei võta uuesti koondi peale
      if (qryGetReportData.FieldByName('csum_sub').AsCurrency = 0.00) and (qryGetReportData.FieldByName('dsum_sub').AsCurrency = 0.00) then
        self.Fstbalsum_d := self.Fstbalsum_d + pCalc;
      ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, pCalc);
    end;
    // ---
  end
  else
  if (pParlow = '@turnover_d') or (pParlow = '@turnover_c') then
  begin
    ParValue := '';
    if (pParlow = '@turnover_c') then
    begin
      pCalc := qryGetReportData.FieldByName('csum_r').AsCurrency;
      pCalc := pCalc + qryGetReportData.FieldByName('csum_rsub').AsCurrency;
      if not Math.IsZero(pCalc) then
        ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, pCalc);
      if (qryGetReportData.FieldByName('csum_rsub').AsCurrency = 0.00) then
        self.Ftr_csum := self.Ftr_csum + pCalc;
    end
    else
    if (pParlow = '@turnover_d') then
    begin
      pCalc := qryGetReportData.FieldByName('dsum_r').AsCurrency;
      pCalc := pCalc + qryGetReportData.FieldByName('dsum_rsub').AsCurrency;
      if not Math.IsZero(pCalc) then
        ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, pCalc);
      if (qryGetReportData.FieldByName('dsum_rsub').AsCurrency = 0.00) then
        self.Ftr_dsum := self.Ftr_dsum + pCalc;
    end;
  end
  else
  if (pParlow = '@finalbal_d') or (pParlow = '@finalbal_c') then
  begin

    ParValue := '';
    if estbk_utilities.isAccountTypePassiva(qryGetReportData.FieldByName('account_type').AsString) then
    begin
      if (pParlow = '@finalbal_c') then
      begin
        pCalc := qryGetReportData.FieldByName('init_balance').AsCurrency;
        pCalc := pCalc + (qryGetReportData.FieldByName('csum').AsCurrency - qryGetReportData.FieldByName('dsum').AsCurrency);
        pCalc := pCalc + (qryGetReportData.FieldByName('csum_r').AsCurrency - qryGetReportData.FieldByName('dsum_r').AsCurrency);
        // allkontode summad;
        pCalc := pCalc + (qryGetReportData.FieldByName('csum_sub').AsCurrency - qryGetReportData.FieldByName('dsum_sub').AsCurrency);
        pCalc := pCalc + (qryGetReportData.FieldByName('csum_rsub').AsCurrency - qryGetReportData.FieldByName('dsum_rsub').AsCurrency);

        // 01.12.2011 Ingmar; allkontode summasid ei võta uuesti koondi peale
        if (qryGetReportData.FieldByName('csum_sub').AsCurrency = 0.00) and (qryGetReportData.FieldByName('dsum_sub').AsCurrency = 0.00) and
          (qryGetReportData.FieldByName('csum_rsub').AsCurrency = 0.00) and
          (qryGetReportData.FieldByName('dsum_rsub').AsCurrency = 0.00) then
          self.Fbsum_c := self.Fbsum_c + pCalc;
        ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, pCalc);
      end;
    end
    else
    if (pParlow = '@finalbal_d') then
    begin
      pCalc := qryGetReportData.FieldByName('init_balance').AsCurrency;
      pCalc := pCalc + (qryGetReportData.FieldByName('dsum').AsCurrency - qryGetReportData.FieldByName('csum').AsCurrency);
      pCalc := pCalc + (qryGetReportData.FieldByName('dsum_r').AsCurrency - qryGetReportData.FieldByName('csum_r').AsCurrency);
      // allkontode summad;
      pCalc := pCalc + (qryGetReportData.FieldByName('dsum_sub').AsCurrency - qryGetReportData.FieldByName('csum_sub').AsCurrency);
      pCalc := pCalc + (qryGetReportData.FieldByName('dsum_rsub').AsCurrency - qryGetReportData.FieldByName('csum_rsub').AsCurrency);

      //   pCalc:=pCalc+(qryGetReportData.FieldByName('dsum_sub').AsCurrency-qryGetReportData.FieldByName('csum_sub').AsCurrency);
      // 01.12.2011 Ingmar; allkontode summasid ei võta uuesti koondi peale
      if (qryGetReportData.FieldByName('csum_sub').AsCurrency = 0.00) and (qryGetReportData.FieldByName('dsum_sub').AsCurrency = 0.00) and
        (qryGetReportData.FieldByName('csum_rsub').AsCurrency = 0.00) and (qryGetReportData.FieldByName('dsum_rsub').AsCurrency = 0.00) then
        self.Fbsum_d := self.Fbsum_d + pCalc;
      ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, pCalc);
    end;
  end
  else
  // @@@
  // käibeandmiku jalus ! 01.12.2011 Ingmar; summa tuleb nüüd võtta datasetist !
  if (pParlow = '@stbalsum_d') then
  begin
    // *** ! kuna peakontodele tuleb allkontode summa arvutada, siis vana loogika ei tööta
    ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.Fstbalsum_d);
  end
  else
  if (pParlow = '@stbalsum_c') then
  begin
    ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.Fstbalsum_c);
  end
  else
  if (pParlow = '@tr_dsum') then
  begin
    ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.Ftr_dsum);
  end
  else
  if (pParlow = '@tr_csum') then
  begin
    ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.Ftr_csum);
  end
  else
  if (pParlow = '@fbsum_d') then
  begin
    ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.Fbsum_d);
  end
  else
  if (pParlow = '@fbsum_c') then
  begin
    ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.Fbsum_c);
  end
  else

  // @@@
  // ---  käibeandmiku spetsiifika lõpp !
  if pParlow = '@screpaccnr' then
    ParValue := estbk_strmsg.SCRepAccnrCapt + pArChar
  else
  if pParlow = '@screpaccexpl' then
    ParValue := estbk_strmsg.SCRepAccExplCapt + pArChar
  else
  if pParlow = '@screpaccdocnr' then
    ParValue := estbk_strmsg.SCRepAccDocnrCapt + pArChar
  else
  if pParlow = '@screpaccdate0' then
    ParValue := estbk_strmsg.SCRepAccDate0Capt + pArChar
  else
  if pParlow = '@screpaccdate1' then
    ParValue := estbk_strmsg.SCRepAccDate1Capt + pArChar
  // - ilma semikoolonita !
  else
  if pParlow = '@screpaccdrec' then
    ParValue := estbk_strmsg.SCRepAccDrecCapt
  else
  if pParlow = '@screpacccrec' then
    ParValue := estbk_strmsg.SCRepAccCrecCapt
  else
  if pParlow = '@screpacccrec' then
    ParValue := estbk_strmsg.SCRepAccCrecCapt
  else
  if pParlow = '@screpaccbalance' then
    ParValue := estbk_strmsg.SCRepAccBalanceCapt
  else
  if pParlow = '@screpacccurr0' then
    ParValue := estbk_strmsg.SCRepAccCurr0Capt
  else
  if pParlow = '@screpacccurr1' then
    ParValue := estbk_strmsg.SCRepAccCurr1Capt
  else
  if pParlow = '@screpaccinitbalance' then
    ParValue := estbk_strmsg.SCRepAccInitbalanceCapt
  else
  //  andmed ---
  if (pParlow = '@extdata') then
  begin
    ParValue := ''; // siia tulevikus objektide loend ja osapool !
    case self.FReportMode of
      CRep_generalledger,
      CRep_journal:
      begin

        if chkBoxAccObj.Checked and (trim(qryGetReportData.FieldByName('object1').AsString) <> '') then
          ParValue := estbk_strmsg.CSObject + ' ' + trim(qryGetReportData.FieldByName('object1').AsString);
      end;
    end;
    // ---
  end
  else
  if (pParlow = '@balancechange') then
    ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.FBalChgByAcc) //formatfloat('0,##',self.FBalChgByAcc)  //floattostr(self.FBalChgByAcc)
  else
  if (pParlow = '@balance') then
    ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, qryGetReportData.FieldByName('curr_balance').AsFloat + (self.FBalChgByAcc))
  else
  // saldo enne kuupäeva X
  if (pParlow = '@curr_balance_d') or (pParlow = '@curr_balance_c') then
  begin
    ParValue := '';
    if estbk_utilities.isAccountTypePassiva(qryGetReportData.FieldByName('account_type').AsString) then
    begin
      if (pParlow = '@curr_balance_c') then
        ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, qryGetReportData.FieldByName('curr_balance').AsFloat);
    end
    else
    if (pParlow = '@curr_balance_d') then
      ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, qryGetReportData.FieldByName('curr_balance').AsFloat);
  end
  else
  // muutused vastavalt kontotüüpidele
  if (pParlow = '@balancechange_d') or (pParlow = '@balancechange_c') then
  begin
    ParValue := '';
    if estbk_utilities.isAccountTypePassiva(qryGetReportData.FieldByName('account_type').AsString) then
    begin
      if pParlow = '@balancechange_c' then
        ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.FBalChgByAcc);
    end
    else
    if (pParlow = '@balancechange_d') then
      ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, self.FBalChgByAcc);
  end
  else
  // peame õigele poole info panema vastavalt, kas aktiva või passiva konto
  // lõppsaldo
  if (pParlow = '@finalbalance_d') or (pParlow = '@finalbalance_c') then
  begin
    ParValue := '';
    if estbk_utilities.isAccountTypePassiva(qryGetReportData.FieldByName('account_type').AsString) then
    begin
      if (pParlow = '@finalbalance_c') then
        ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, qryGetReportData.FieldByName('curr_balance').AsFloat + (self.FBalChgByAcc));
    end
    else
    if (pParlow = '@finalbalance_d') then
      ParValue := formatFloat(estbk_types.CCurrentCurrFmt2, qryGetReportData.FieldByName('curr_balance').AsFloat + (self.FBalChgByAcc));
  end
  else
  if (pParlow = '@compname') then
    ParValue := estbk_globvars.glob_currcompname
  else
  if (pParlow = '@period') then
    ParValue := datetostr(dtEditStart.date) + ' - ' + datetostr(dtEditEnd.date)
  // originaal valuuta summad !
  else
  if (pParlow = '@d_origcval') or (pParlow = '@c_origcval') then
  begin

    ParValue := '';
    if AnsiUpperCase(qryGetReportData.FieldByName('currency').AsString) <> estbk_globvars.glob_baseCurrency then
    begin
      pRecType := AnsiUpperCase(qryGetReportData.FieldByName('rec_type').AsString);
      pCurrVal := qryGetReportData.FieldByName('currval_override').AsFloat;

      if (pParlow = '@d_origcval') then
      begin
        if pRecType = estbk_types.CAccRecTypeAsDebit then
          ParValue := '(' + formatFloat(estbk_types.CCurrentCurrFmt2, pCurrVal) + ')';
      end
      else
      if pRecType = estbk_types.CAccRecTypeAsCredit then
      begin
        ParValue := '(' + formatFloat(estbk_types.CCurrentCurrFmt2, pCurrVal) + ')';
      end;
      // ------
    end;
  end
  else
  // lihtsalt baasvaluuta kuvamine ikka suht mõttetu ?!?
  if (pParlow = 'reportdata.currency') then
  begin
    if AnsiUpperCase(qryGetReportData.FieldByName('currency').AsString) = estbk_globvars.glob_baseCurrency then
      ParValue := '';
  end
  else // 21.02.2011 Ingmar
  if (pParlow = '@scaccdate') then
  begin
    ParValue := datetostr(qryGetReportData.FieldByName('transdate').AsDateTime);
  end
  else
  // 16.04.2011 Ingmar
  if (pParlow = '@scdoctypeidf') then
    ParValue := trim(qryGetReportData.FieldByName('document_type').AsString);

  // ---
  // hetkel hack nr 2, kliendi nimi liidetakse selgitusele juurde !
  pDescrField := False;
  if (pParlow = 'reportdata.transdescr') then
  begin
    ParValue := AStr(qryGetReportData.FieldByName('transdescr').AsString);
    pDescrField := True;
  end
  else
  if (pParlow = 'reportdata.descr') then
  begin
    ParValue := AStr(qryGetReportData.FieldByName('descr').AsString);
    pDescrField := True;
  end;
  // 27.12.2011 Ingmar; meil olid checkboxid, mis reguleerisid tööd, mida kuvada, mida mitte...kahjuks need ei töötanud
  // eveast taheti, et võiks töötada, teeme järjekordse hacki !
  self.canShowValuesOnReport(pParlow, ParValue);

  // ---  ja nüüd klient juurde !
  if chkBoxAccPartner.Checked and pDescrField and assigned(qryGetReportData.Fields.FindField('client_name')) then
  begin
    // -- pearaamatus saame selgitust wrappida, päevaraamatus mitte
    if self.reportMode = CRep_generalledger then
    begin
      if trim(vartostr(ParValue)) <> '' then
        ParValue := ParValue + AStr(CRLF) + qryGetReportData.FieldByName('client_name').AsString
      else
        ParValue := qryGetReportData.FieldByName('client_name').AsString;
    end
    else  // ---
      ParValue := ParValue + AStr(' ') + qryGetReportData.FieldByName('client_name').AsString;
  end;
end;


{
VAr FromPg, ToPg, Cpy: Integer;
     ind: Integer;
     St: String;
     Collap: Boolean;
begin
 / / Load the state
  St:=ExtractFilePath(ParamStr(0));
 frReport1.LoadFromFile(St+' rap1.frf');
  / / Changing the default printer
 ind: = Printer.PrinterIndex;
  / / Prépare the state, to leave if the preparation did not function
  Yew Not frReport1.PrepareReport then Exit;

  / / Initialise limps it of dialogue for paramètrer the edition
  with PrintDialog1 C
  begin
   Options:=[poPageNums ]; / / Authorizes the selection of pages
   Copies: = 1;       / / Only one specimen
   Collate: = True;     / / sorted Copies
   FromPage: = 1;     / / Page of beginning
   ToPage: = frReport1.EMFPages.Count;  / / Last page, by defect totality
   MaxPage: = frReport1.EMFPages.Count; / / a Number of maximum pages, by defect totality
    yew Execute then    / / Exécution of limps of dialogue
    begin
      was yew Printer.PrinterIndex < > ind then  / / there a change of printer?
       does yew frReport1.CanRebuild then    / / owe one regénérer the state?
         yew frReport1.ChangePrinter(ind, Printer.PrinterIndex) then / / Change of printer
           frReport1.PrepareReport
         else exit; / / the change of printer badly occurred

      yew PrintDialog1.PrintRange = prPageNums then / / one made a selection of pages
      begin
       FromPg: = PrintDialog1.FromPage; / / first page
       ToPg: = PrintDialog1.ToPage;      / / last page
      end;

     Cpy:=PrintDialog1.Copies;   / / a Number of copies
     Collap:=PrintDialog1.Collate;  / / Exemplary sorted

      / / Lance the edition of the page " FromPg " with " ToPg ", " Cpy " exmplaires sorted (Collap))
     frReport1.PrintPreparedReport(FromPg, ToPg, Cpy, Collap);
    end;
  end;
}

initialization
  {$I estbk_fra_genledgreportcriterias.ctrs}

end.