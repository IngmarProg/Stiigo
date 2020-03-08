unit estbk_fra_formdrez;
// Üldiselt; kui pole vaja, siis ära seda moodulit eriti näpi ;)
// käibedekl /tuludekl[?] väljund
{$mode objfpc}
{$H+}
{$i estbk_defs.inc}


interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, Grids, Contnrs, ComCtrls,
  Dialogs, LCLType, LCLProc, Buttons, ExtCtrls, EditBtn, Menus, Clipbrd, estbk_fra_template,
  estbk_types, estbk_strmsg, estbk_lib_vat_ext2, estbk_lib_commonevents, estbk_clientdatamodule,
  estbk_lib_declcalc, estbk_lib_commoncls, estbk_debugwnd, estbk_lib_calcdhelper, memds, lr_e_csv,
  lr_e_pdf, LR_Class, LR_DBSet, ZDataset, LR_DSet;

type

  { TframeDeclRez }

  TframeDeclRez = class(Tfra_template)
    Bevel1: TBevel;
    btnCalcDecl: TBitBtn;
    btnOutput: TBitBtn;
    chkZSum: TCheckBox;
    chkBoxDetailedView: TCheckBox;
    cmbDateRange: TComboBox;
    fbfrDataset: TfrUserDataset;
    mnu1000eurbills: TMenuItem;
    mnuSep: TMenuItem;
    mnuItemCsv: TMenuItem;
    mnuItemPdfFile: TMenuItem;
    mnuItemScreen: TMenuItem;
    popupReportType: TPopupMenu;
    lblPeriod: TLabel;
    dtEditStart: TDateEdit;
    dtEditEnd: TDateEdit;
    grpBoxDefAccounts: TGroupBox;
    lblsep: TLabel;
    lblDate: TLabel;
    cpyvalue: TMenuItem;
    Panel1: TPanel;
    qryWorker: TZQuery;
    repDecldrez: TfrReport;
    dlgSaveBillFiles: TSaveDialog;
    saveRep: TSaveDialog;
    procedure btnCalcDeclClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure cmbDateRangeChange(Sender: TObject);
    procedure dtEditStartExit(Sender: TObject);
    procedure dtEditStartKeyPress(Sender: TObject; var Key: char);
    procedure fbfrDatasetCheckEOF(Sender: TObject; var EOF: boolean);
    procedure fbfrDatasetFirst(Sender: TObject);
    procedure fbfrDatasetNext(Sender: TObject);
    procedure mnu1000eurbillsClick(Sender: TObject);
    procedure mnuItemScreenClick(Sender: TObject);
    procedure repDecldrezBeginBand(Band: TfrBand);
    procedure repDecldrezEndBand(Band: TfrBand);
    procedure repDecldrezEnterRect(Memo: TStringList; View: TfrView);
    procedure repDecldrezExportFilterSetup(Sender: TfrExportFilter);
    procedure repDecldrezGetValue(const ParName: string; var ParValue: variant);
  private
    FFilteredRez: TObjectList;

    FzStartDate: boolean;
    FLoadStatus: boolean;
    FdeclFormId: integer;

    FQryDatetimeRange: AStr;
    FreportLongName: AStr;
    FreportFormType: AStr;
    FreportDefPath: AStr;
    FframeKillSignal: TNotifyEvent;
    FParentKeyNotif: TKeyNotEvent;
    FFrameDataEvent: TFrameReqEvent;


    FTaxDeclCalc: TDeclcalc;

    // aruanne
    FGrpUniqVal: integer;
    FCurrentFiltRezIndx: integer; // mitmendale reale on userdataset juba liikunud
    FPrevFiltRezIndx: integer;
    FCurrFormdLineNr: integer;
    FCurrAccListIndx: integer;
    FGrpHeader: TfrBand;
    FAccFlagUp: boolean;

    // bilanss / kasumiaruanne
    FLiveGroupName: AStr; // footeri jaoks, et teaksime millist bilansigruppi summeeritakse
    FInitBalanceSum: double;
    FBalanceChangeSum: double;
    FFinalBalanceSum: double;

    procedure createFiltRowList;
    function calculateFormd(const pRestoreFormula: boolean = True): boolean;
    // ---
    procedure setzStartDate(const v: boolean);
    function formSupportsDetailedView: boolean;
    function getDataLoadStatus: boolean;
    procedure setDataLoadStatus(const v: boolean);
    function isNextLineInsameGrp(const pLineNr: integer): boolean;

    // töödeldava aruande rea abifunktsioonid
    function extractActualFrmInf: TFormulaPreParser;
    function extractActualAccInf: TTaxdParsedAccounts; overload;
    function extractActualAccInf(var pCurrAccLevel: integer): TTaxdParsedAccounts; overload; // 22.05.2011 Ingmar
    procedure doOnclickFix(Sender: TObject);

    procedure OnKeyNotif(Sender: TObject; var Key: word; Shift: TShiftState);

  public
    procedure callDebugWindow;
    constructor Create(frameOwner: TComponent); override;
    destructor Destroy; override;
  published // RTTI probleem
    property onFrameKillSignal: TNotifyEvent read FframeKillSignal write FframeKillSignal;
    property onParentKeyPressNotif: TKeyNotEvent read FParentKeyNotif;
    property onFrameDataEvent: TFrameReqEvent read FFrameDataEvent write FFrameDataEvent;

    property zStartDate: boolean read FzStartDate write setzStartDate; // määrab ära enne loaddata, kas alguskuupäeva osa täidetakse
    property reportDefPath: AStr read FreportDefPath write FreportDefPath;
    property declFormId: integer read FdeclFormId write FdeclFormId;
    property loadData: boolean read getDataLoadStatus write setDataLoadStatus;
  end;

implementation

uses estbk_uivisualinit, estbk_globvars, estbk_sqlclientcollection,
  estbk_reportconst, estbk_utilities, dateutils, Math, TypInfo;

const
  CCol_description = 1;
  CCol_logrownr = 2;
  CCol_calcrez = 3;

procedure TframeDeclRez.callDebugWindow;
var
  pFrmp: TFormulaPreParser;
  pDebug: string;
  pStrList: TAStrList;
  i: integer;
  pdbForm: Tform_debug;
begin
  try
    pStrList := TAStrList.Create;
    pdbForm := Tform_debug.Create(nil);

    self.calculateFormd(False);
    with FTaxDeclCalc.declDataLines do
      for i := 0 to Count - 1 do
      begin
        pFrmp := TFormulaPreParser(Objects[i]);
        pDebug := pFrmp.lineLongDescr + ': ' + pFrmp.lastParsedFormula + ':' + pFrmp.formula;
        pStrList.Add(pDebug);
      end;

    pdbForm.showmodal(pStrList);

  finally
    FreeAndNil(pStrList);
    FreeAndNil(pdbForm);
  end; // --
end;

// ntx kuvada vaid read, kus summa >0
procedure TframeDeclRez.createFiltRowList;
var
  i: integer;
  b: boolean; // ntx vaid read, kus tulemus pole 0 !
  prez: double;
  pFrmp: TFormulaPreParser;
  pAccs: TTaxdParsedAccounts;
begin
  // ----
  FFilteredRez.Clear;


  // ----
  b := chkZSum.Checked;

  with FTaxDeclCalc.declDataLines do
    for i := 0 to Count - 1 do
    begin
      pFrmp := TFormulaPreParser(Objects[i]);

      // 27.11.2011 Ingmar; keepTogether
      if (trim(pFrmp.formula) = '') or ((self.FreportFormType = estbk_types.CFormTypeAsBalance) and pFrmp.keepTogether) then // tühi/inforida
        FFilteredRez.Add(Objects[i])
      else
      begin
        //pFrmp:=TFormulaPreParser(Objects[i]);
        pRez := pFrmp.formulaRez + pFrmp.formulaAltRez; // altrez; käive
        if b then // vaid read, kus tulemus <> 0 !
        begin

          // paistab mingile reale tuli tulemus
          if not (Math.isZero(pRez)) then
          begin
            FFilteredRez.Add(Objects[i]);
            // 20.05.2011 Ingmar; kustutame ära ka 0 tulemusega kontod !
                 {
                 for j:=pFrmp.accounts.Count-1 downto 0 do
                    begin
                       pAccs:=pFrmp.accounts.Items[j] as TTaxdParsedAccounts;
                    if double(pAccs.FAccFormulaSum+pAccs.FBalanceChange)=0.00 then
                       pFrmp.accounts.Delete(j);
                    end;
                 }
          end;

          // ---
        end
        else
          FFilteredRez.Add(Objects[i]);
      end; // --

    end;
end;

function TframeDeclRez.calculateFormd(const pRestoreFormula: boolean = True): boolean;
var
  pCursor: TCursor;
  pErr: AStr;
  pTotalLineSum: double;
  b: boolean;
  i, j: integer;
begin
  Result := False;
  // (dtEditStart.Text='') or
  if (dtEditEnd.Text = '') or (dtEditStart.Date > dtEditEnd.Date) or (dtEditStart.Date > now) then
  begin
    Dialogs.MessageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
    exit;
  end;



  // ---
  try
    pCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    pErr := '';

    try


      self.FQryDatetimeRange := '';
      if dtEditStart.Text <> '' then
      begin
        FTaxDeclCalc.declStart := dtEditStart.Date;
        self.FQryDatetimeRange := datetostr(dtEditStart.Date) + ' - ' + datetostr(dtEditEnd.Date);
      end
      else
      begin
        FTaxDeclCalc.declStart := CZStartDate1980;
        self.FQryDatetimeRange := datetostr(dtEditEnd.Date);
      end;



      FTaxDeclCalc.declEnd := dtEditEnd.Date;
      // !!!!!!!!!!!!!!!!
      // tegemist võrdleva päringuga ! algsaldo versus lõppsaldo N perioodil; + muutus; ainult bilansi puhul kehtib !
      b := (self.FreportFormType = estbk_types.CFormTypeAsBalance);
      FTaxDeclCalc.doCalc(b, pErr, b);

      if trim(pErr) <> '' then
        raise Exception.Create(pErr);

      // 01.05.2011 Ingmar
      self.createFiltRowList();



      // ###################################################################
      // VIGA ! Taastame algse valemi !
      // 17.04.2011 Ingmar; peale arvutamist saavad valemis kontod väärtuse; [11@DS]+[110@KS] tulem on 5+9
      // ###################################################################

      if pRestoreFormula then
        with FTaxDeclCalc.declDataLines do
          for i := 0 to Count - 1 do
            if assigned(Objects[i]) then
              with TFormulaPreParser(Objects[i]) do
              begin
                //TFormulaPreParser(Objects[i]).formulaRez:=0;
                //TFormulaPreParser(Objects[i]).formulaRez2:=0;
                formula := lastParsedFormula;
                formulaAlt := formula;
                //TFormulaPreParser(Objects[i]).parseFormula(TFormulaPreParser(Objects[i]).formula);
              end;




    except
      on e: Exception do
      begin
        Dialogs.messageDlg(Format(estbk_strmsg.SECalcFailed, [e.message]), mtError, [mbOK], 0);
      end;
    end;

    // ---
  finally
    Screen.Cursor := pCursor;
  end;
  // ---
  Result := True;
end;



procedure TframeDeclRez.btnCalcDeclClick(Sender: TObject);
var
  pRepDef: AStr;
begin
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // sooritame arvutused
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  if not self.calculateFormd then
    Exit;



  self.FInitBalanceSum := 0;
  self.FBalanceChangeSum := 0;
  self.FFinalBalanceSum := 0;

  self.FPrevFiltRezIndx := -1;
  self.FGrpUniqVal := 0;
  self.FGrpHeader := nil;

  // --
  if self.FreportFormType = estbk_types.CFormTypeAsBalance then
    pRepDef := includetrailingbackslash(self.reportDefPath) + estbk_reportconst.CFormBalanceReportFilename
  else
  if self.FreportFormType = estbk_types.CFormTypeAsIncStatement then
    pRepDef := includetrailingbackslash(self.reportDefPath) + estbk_reportconst.CFormIncStatementReportFilename
  else
    pRepDef := includetrailingbackslash(self.reportDefPath) + estbk_reportconst.CFormDReportFilename; // üldine aruandevorm D ridadele !

  if not FileExists(pRepDef) then
    raise Exception.CreateFmt(estbk_strmsg.SEReportDataFileNotFound, [pRepDef]);

  repDecldrez.LoadFromFile(pRepDef);
  // väljund !
  if mnuItemScreen.Checked then
    repDecldrez.ShowReport
  else
  if mnuItemPdfFile.Checked then
  begin
    saveRep.FileName := ansilowercase(self.FreportLongName) + '.pdf';
    if saveRep.Execute then
    begin
      if repDecldrez.PrepareReport then
        repDecldrez.ExportTo(TFrTNPDFExportFilter, saveRep.Files.Strings[0]);
    end; // --
  end
  else
  if mnuItemCsv.Checked then
  begin
    saveRep.FileName := ansilowercase(self.FreportLongName) + '.csv';
    if saveRep.Execute then
    begin
      if repDecldrez.PrepareReport then
        repDecldrez.ExportTo(TfrCSVExportFilter, saveRep.Files.Strings[0]);
    end; // --
  end;
end;

procedure TframeDeclRez.btnOutputClick(Sender: TObject);
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

  popupReportType.PopUp(TForm(pFindPOwner).left + TSpeedButton(Sender).left + TSpeedButton(Sender).Width + 6,
    TForm(pFindPOwner).top + TSpeedButton(Sender).top + TSpeedButton(Sender).Height + 123);
end;


procedure TframeDeclRez.cmbDateRangeChange(Sender: TObject);
var
  pDtType: estbk_types.TdtPeriod;
  pdtstart: TDatetime;
  pdtEnd: TDatetime;
  zVal: boolean;
begin
  zVal := True;
  with TComboBox(Sender) do
    if ItemIndex >= 0 then
    begin
      pDtType := estbk_types.TdtPeriod(PtrInt(Items.Objects[ItemIndex]));
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

procedure TframeDeclRez.dtEditStartExit(Sender: TObject);
var
  cval: TDatetime;
  pStr: AStr;

begin
  cval := now;
  pStr := trim(TEdit(Sender).Text);
  if pStr <> '' then
  begin
    if not estbk_utilities.validateMiscDateEntry(pStr, cval) then
    begin
      Dialogs.messageDlg(estbk_strmsg.SEInvalidDate, mtError, [mbOK], 0);
      if TEdit(Sender).CanFocus then
        TEdit(Sender).SetFocus;
    end
    else
      TEdit(Sender).Text := datetostr(cval);
  end;
end;

procedure TframeDeclRez.dtEditStartKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    SelectNext(Sender as twincontrol, True, True);
    key := #0;
  end;
end;


procedure TframeDeclRez.fbfrDatasetCheckEOF(Sender: TObject; var EOF: boolean);
begin
  // ---
  EOF := (FCurrentFiltRezIndx > FFilteredRez.Count - 1) or not assigned(FFilteredRez.items[FCurrentFiltRezIndx]);
end;

// 22.04.2011 Ingmar; peame vaatama kas footerit kuvada, aga selleks peame kontrollima, kas järgmine rida on sama grupis, mis hetkel aktiivne
// FCurrFormdLineNr = bilansirea ID = nimetus
function TframeDeclRez.isNextLineInsameGrp(const pLineNr: integer): boolean;
var
  pFrmParserNext: TFormulaPreParser;
  pFrmParserCurr: TFormulaPreParser;

begin
  Result := False;
  //  ---
  if not chkBoxDetailedView.Checked or (self.FCurrentFiltRezIndx > FFilteredRez.Count - 1) then
    Exit;

  // --- leiame siis reaalne bilansi read FormdLineNr
  pFrmParserCurr := FFilteredRez.items[self.FCurrentFiltRezIndx] as TFormulaPreParser;

  // detailne vaade, kas kõik kontod kuvatud
  //if  (pFrmParserCurr.accounts.Count>0)  then
  if (pFrmParserCurr.distinctAccounts.Count > 0) then
  begin
    //result:=self.FCurrAccListIndx<=pFrmParserCurr.accounts.Count-1;
    Result := self.FCurrAccListIndx <= pFrmParserCurr.distinctAccounts.Count - 1;

  end
  else
  if (self.FCurrentFiltRezIndx + 1 <= FFilteredRez.Count - 1) then
  begin
    pFrmParserNext := FFilteredRez.items[self.FCurrentFiltRezIndx + 1] as TFormulaPreParser;
    Result := assigned(pFrmParserNext) and (pFrmParserNext.miscVal = self.FCurrFormdLineNr);
  end; // --
end;

procedure TframeDeclRez.fbfrDatasetFirst(Sender: TObject);
begin
  self.FCurrentFiltRezIndx := 0;
  self.FGrpHeader := nil;


  // bilanss / kasumiaruanne
  self.FLiveGroupName := '';
  self.FInitBalanceSum := 0.00;
  self.FBalanceChangeSum := 0.00;
  self.FFinalBalanceSum := 0.00;

  self.FPrevFiltRezIndx := -1;
  self.FCurrAccListIndx := 0; // peame kontod eraldi ridadena välja tooma !
  self.FGrpUniqVal := 1;

  self.FAccFlagUp := False;
end;

// algoritmi tähtsaim osa, mis teeb kindlaks detailse vaate puhul, kas alustame uue grpbandiga !
procedure TframeDeclRez.fbfrDatasetNext(Sender: TObject);
var
  pFrmp: TFormulaPreParser;
begin

  if self.formSupportsDetailedView then // bilansi detailne vorm !
  begin

    // kui detailne vaade ntx bilanss või kasumiaruanne, siis lood muutuvad !
    if chkBoxDetailedView.Checked then
    begin

      if self.FCurrentFiltRezIndx > self.FFilteredRez.Count - 1 then
        exit;



      pFrmp := self.FFilteredRez.Items[self.FCurrentFiltRezIndx] as TFormulaPreParser;
      if assigned(pFrmp) then
      begin

        // --
        if pFrmp.keepTogether then
        begin
          Inc(self.FCurrentFiltRezIndx);
        end
        else
        begin

          // detailne bilanss
          // tekitame siis read kontode kaupa !
          //if  (pFrmp.formula='') or (self.FCurrAccListIndx>pFrmp.accounts.Count-1) then
          if (pFrmp.formula = '') or (self.FCurrAccListIndx > pFrmp.distinctAccounts.Count - 1) then
          begin
            Inc(self.FCurrentFiltRezIndx); // liigume järgmise kirje peale !
            self.FAccFlagUp := False;
            self.FCurrAccListIndx := 0;
          end
          else
          begin
            Inc(self.FCurrAccListIndx); // ütleme, et võtame järgmise konto detailid !
            self.FAccFlagUp := True;     // märgime ära, et hetkel koostame aruanded konto rida
          end; // --
        end;




        // mitmes bilansirida...nagu andmebaasis defineeriud VARA  jne jne
        self.FCurrFormdLineNr := pFrmp.miscVal;


        // -----------------------------------------------------------------
        // Sisuliselt mitmes fetch ! vaja selleks, et group band tuleks igakord uuesti.
        // Peale igat rida me vaid ütleme, millal ta ka nähtav !
        // -----------------------------------------------------------------
        Inc(self.FGrpUniqVal);
      end;
      // ---
    end
    else
      Inc(self.FCurrentFiltRezIndx); // mitmes andmerida on ; filtrez !
  end
  else
    Inc(self.FCurrentFiltRezIndx); // tavaline vorm; ntx käibemaks, liigume lihtsalt read läbi
end;

procedure TframeDeclRez.mnu1000eurbillsClick(Sender: TObject);
var
  prp: TFormulaPreParser;
  i, j, Count: integer;
  pVatvars: TVatExtVars2; // vars
  pvatb: TVatExt2; // gen
  prez, pprop: AStr;
  pfilename: AStr;
  pfile: Textfile;
  ppInfo: PPropInfo;
  pList: PPropList;
  pDbrez: double;
begin

  if not self.calculateFormd or (dtEditEnd.Text = '') then
    Exit;


  dlgSaveBillFiles.FileName := Format('kmd_inf_vorm_a_%d_%d.xml', [monthOf(dtEditEnd.Date), yearOf(dtEditEnd.Date)]);
  if not dlgSaveBillFiles.Execute then
    Exit;

  pVatvars := TVatExtVars2.Create;

  //count := GetPropList(TypeInfo(TVatExtVars2), tkAny, nil);
  Count := GetPropList(pVatvars.ClassInfo, tkAny, nil);
  GetMem(plist, Count * SizeOf(PPropInfo));
  Count := GetPropList(pVatvars.ClassInfo, tkAny, plist);

  try
    pfilename := dlgSaveBillFiles.Files.Strings[0];


    for i := 0 to self.FFilteredRez.Count - 1 do
    begin
      // @@ ---
      prp := self.FFilteredRez.Items[i] as TFormulaPreParser;
      if assigned(prp) then
      begin

        for j := 0 to Count - 1 do
        begin
          ppInfo := pList^[j];
          pprop := ppInfo^.Name;
          pprop := system.Copy(pprop, 1, pos('_', pprop) - 1);
          system.Delete(pprop, 1, 1);
          if ((length(pprop) >= 2) and (pprop[2] = 'x')) then
            system.Delete(pprop, length(pprop), 1);
          pprop := Trim(pprop);

          if (pprop = prp.lineLogNr) then
          begin
            pDbrez := prp.formulaRez;
            SetFloatProp(pVatvars, ppInfo, pDbrez);
          end;
        end;
      end;
    end; // ---


    try
      pvatb := TVatExt2.Create(dmodule.tempQuery);
      prez := pvatb.VatBillExtf(pVatvars, dtEditStart.date, dtEditEnd.date, yearOf(dtEditEnd.Date), monthOf(dtEditEnd.Date));

      AssignFile(pfile, pfilename);
      Rewrite(pfile);
      Writeln(pfile, prez);
      CloseFile(pfile);
    finally
      FreeAndNil(pvatb);
    end;

  finally
    FreeMem(plist, Count * SizeOf(PPropInfo));
    FreeAndNil(pVatvars);
  end; // @@
end;

procedure TframeDeclRez.mnuItemScreenClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to self.popupReportType.Items.Count - 1 do
    self.popupReportType.Items[i].Checked := False;
  TMenuItem(Sender).Checked := True;

  if btnCalcDecl.CanFocus then
    btnCalcDecl.SetFocus;
end;



// Kas on võimalik kirjutada veel keerulisemat koodi -:) Ikka on...
procedure TframeDeclRez.repDecldrezBeginBand(Band: TfrBand);
const
  SCGrpname = '@scgrpname';
  // TODO; jätta klassi siseselt esimene väärtus meelde ja siis vastavalt vajadusele originaalkõrgused taastada !
  CDefaultBandNormalHeight = 20;
  CDefaultBandSummaryHeight = 44;
  CGroupFooterHeight = 36; // bilansi puhul !
  CGroupFooterHeight2 = 67; // bilansi puhul !

var
  i: integer;
  pAccountLevel: integer;
  pV: TfrView;
  pIsGrpBand: boolean; // peame ise masterdata bandidega looma groupbandi, sest olemasolev ei tööta userdatasetiga !
  pFrmp: TFormulaPreParser;
  pCAccs: TTaxdParsedAccounts; // detailne bilanss konto mille peal hetkel ollakse !
  pZLine: boolean;
  pRez: double;
begin

  if self.formSupportsDetailedView then // bilanns / kasumiaruanne !
  begin

    // Omamoodi hack-in-dos, meil on vaja imiteerida groupheaderi tööd
    if Band.Typ = btGroupHeader then //btGroupHeader
    begin

      // 20.04.2011 Ingmar; kuna LazReport on bugine ja bandi nime ei anna, siis peame elemendid üle vaatama;
      // elemendi nime järgi teeme kindlaks, kas see on nö meie fake detail band või mitte
      self.FGrpHeader := Band;
      pIsGrpBand := False;
      // ---
      for i := 0 to Band.Objects.Count - 1 do
      begin
        pV := TfrView(Band.Objects[i]);
        pIsGrpBand := (pV is TfrMemoView) and (pos(SCGrpname, ansilowercase(TfrMemoView(pV).Memo.Text)) > 0);
        if pIsGrpBand then
          break;
      end;

      if pIsGrpBand then
      begin

        if not chkBoxDetailedView.Checked then
        begin
          FGrpHeader.GroupCondition := IntToStr(self.FGrpUniqVal - 1);
          Band.GroupCondition := IntToStr(self.FGrpUniqVal - 1);

          Band.Height := 0;
          Band.Visible := False;
          Exit; // -->
        end;




        // ----------------------------------------------------------
        // UUS GRUPP !
        // ----------------------------------------------------------
        // -- kas nö muudame grupi nähtavaks... peame ise tegelema grupeerimise, et millal band on nähtav, millal mitte ...
        if (self.FPrevFiltRezIndx <> self.FCurrentFiltRezIndx) then //  FPrevFormdLineNr / FCurrFormdLineNr defineeritud vormi andmerea nr
        begin

          self.FInitBalanceSum := 0.00;
          self.FBalanceChangeSum := 0.00;
          self.FFinalBalanceSum := 0.00;


          pFrmp := TFormulaPreParser(self.FFilteredRez.Items[self.FCurrentFiltRezIndx]);
          // 27.11.2011 Ingmar; ntx olid kokkuvõtvad read &algusega siis neid ei kuvatud; keeptogether lipp välistas !
          //if pFrmp.keepTogether or (trim(pFrmp.formula)='') or math.isZero(pFrmp.formulaRez+pFrmp.formulaAltRez)  then
          if pFrmp.keepTogether or (trim(pFrmp.formula) = '') then
          begin
            Band.Height := 0;
            Band.Visible := False;
          end
          else
          begin
            Band.Visible := True;
            Band.Height := CDefaultBandNormalHeight;
          end;



          self.FPrevFiltRezIndx := self.FCurrentFiltRezIndx;
          self.FCurrFormdLineNr := TFormulaPreParser(self.FFilteredRez.Items[self.FCurrentFiltRezIndx]).miscVal;
          // ---
        end
        else
        begin
          Band.Height := 0;
          Band.Visible := False;
        end;

        // ----------------
        // kuna meil reaalset datasetti pole, siis group kutsub välja next eventi, peame uuesti tagasi tõmbama kontode indeksi !'
        if self.FCurrAccListIndx > 0 then
          Dec(self.FCurrAccListIndx);


        // --
        Band.GroupCondition := IntToStr(self.FGrpUniqVal);
        // self.FOrigCurrFormdLineNr:=self.FCurrFormdLineNr;
      end;
    end
    else
    if Band.Typ = btGroupFooter then //btGroupHeader
    begin

      // workaround: kuna bookmarki ju pole, siis peame mitte kontode puhul tagasi tõmbama indeksi !
      // self.FCurrFormdLineNr:= self.FOrigCurrFormdLineNr;
      // Kas footer kuvada; detailne bilanss !

      if chkBoxDetailedView.Checked then
      begin

        self.FCurrentFiltRezIndx := self.FPrevFiltRezIndx;
        if not self.isNextLineInsameGrp(self.FCurrentFiltRezIndx) and chkBoxDetailedView.Checked then
        begin
          // 28.05.2011 Ingmar; aruanne tuli laiemaks tõmmata !
          if self.FreportFormType = estbk_types.CFormTypeAsIncStatement then
            Band.Height := CGroupFooterHeight2
          else
            Band.Height := CGroupFooterHeight;
          Band.Visible := True;
        end
        else
        begin
          Band.Height := 0;
          Band.Visible := False;
        end;




        // kui on nö koondrida või tühi rida, siis FOOTERIT ei tee !
        pFrmp := self.extractActualFrmInf;
        // if pFrmp.keepTogether or (trim(pFrmp.formula)='') or math.isZero(pFrmp.formulaRez+pFrmp.formulaAltRez) then
        if pFrmp.keepTogether or (trim(pFrmp.formula) = '') or Math.isZero(pFrmp.formulaRez + pFrmp.formulaAltRez) then
        begin
          Band.Height := 0;
          Band.Visible := False;
        end;
      end
      else
      begin
        Band.Height := 0;
        Band.Visible := False;
      end;
      // --------
    end
    else
    if Band.Typ = btMasterData then
    begin

      // ----
      pFrmp := self.extractActualFrmInf;
      // ----



      // detailne bilanss !
      if chkBoxDetailedView.Checked then
      begin

        if not assigned(pFrmp) then
        begin
          Band.Height := 0;
          Band.Visible := False;
        end
        else
        begin
          Band.Height := CDefaultBandNormalHeight;
          Band.Visible := True;

          pAccountLevel := 0;
          pCAccs := self.extractActualAccInf();

          if assigned(pCAccs) then
          begin
            pRez := pCAccs.FAccFormulaSum + pCAccs.FBalanceChange;



            // 20.05.2011 Ingmar; 0 rida ei kuva !
            // pFrmp; koondrida ikka kuvame; & märgendiga, muidu kadusid käibevara kokku jne jne read
            if (self.FreportFormType = estbk_types.CFormTypeAsBalance) then
            begin
              if chkZSum.Checked and (pRez = 0.00) and not pFrmp.keepTogether then
              begin
                Band.Height := 0;
                Band.Visible := False;
              end;
            end
            else
            if chkZSum.Checked and (pRez = 0.00) then
            begin
              Band.Height := 0;
              Band.Visible := False;
            end;
          end;
          // ---
        end;
      end; {else // ---
            //  27.11.2011 Ingmar
            if assigned(pFrmp) then
             begin
                   pRez:=pFrmp.formulaRez+pFrmp.formulaAltRez;
               if (self.FreportFormType=estbk_types.CFormTypeAsBalance) then
                 begin
                   if chkZSum.Checked and (pRez=0.00) and not pFrmp.keepTogether then
                     begin
                       Band.Height:=0;
                       Band.Visible:=false;
                     end;
                 end else
                 if chkZSum.Checked and (pRez=0.00) then
                   begin
                     Band.Height:=0;
                     Band.Visible:=false;
                   end;
                // 27.11.2011 Ingmar
                //pFrmp.formulaAlt:=;
             end; }



      if assigned(FGrpHeader) then
      begin
        FGrpHeader.GroupCondition := IntToStr(self.FGrpUniqVal - 1);
        Band.GroupCondition := IntToStr(self.FGrpUniqVal - 1);
      end;
    end; // ---
  end;
end;

// ----------------------------------------------------------------------------

procedure TframeDeclRez.repDecldrezEndBand(Band: TfrBand);
begin
  // vaatame üle, kas andmed muutusid peame teatama grp objektile !
  // if (Band.Typ=btMasterData)
  // if (Band.Typ=btGroupFooter) and assigned(FGrpBandInst) then

end;

procedure TframeDeclRez.repDecldrezEnterRect(Memo: TStringList; View: TfrView);
var
  pAccountLevel: integer;
  pIsDetailedFormSp: boolean;
  // pAccount : TTaxdParsedAccounts;
begin
  //    pIsDetailedFormSp:=(self.FreportFormType=estbk_types.CFormTypeAsBalance); // BILANSS ! bilansi puhul tehakse allkontode astendus


  // kas on detailne bilanss...
  // if  pIsDetailedFormSp and
  if self.formSupportsDetailedView and chkBoxDetailedView.Checked and (pos('@scaccountcode', ansilowercase(Memo.Text)) > 0) then
    //    (TFrBandView(View).BandType=btMasterData) and
  begin
    // @@@
    // 0 ridade puhul kaob puu struktuur !
    if not chkZSum.Checked then
    begin
      pAccountLevel := 0;
      // --
      self.extractActualAccInf(pAccountLevel); // meid huvitab vaid nivoo !

      if pAccountLevel = 1 then
        View.Left := 20 + pAccountLevel * 3.5
      else
        View.Left := 20 + pAccountLevel * 2.5;
    end;
    // ---
    // if TFrBandView(View).BandType=btGroupHeader then  // btMasterData
    // btMasterData
    // inttostr(self.FCurrFormdLineNr);
  end;

end;

procedure TframeDeclRez.repDecldrezExportFilterSetup(Sender: TfrExportFilter);
begin
  // --
end;

function TframeDeclRez.extractActualFrmInf: TFormulaPreParser;
begin
  Result := nil;
  if (self.FCurrentFiltRezIndx < 0) or (self.FCurrentFiltRezIndx > self.FFilteredRez.Count - 1) then
    exit;

  Result := TFormulaPreParser(self.FFilteredRez.items[self.FCurrentFiltRezIndx]);
end;

// analüüsib jooksvat rida, mis peab minema aruandele ja väljastab selle reaga seotud kontode info; vajalik detailse aruande puhul
function TframeDeclRez.extractActualAccInf: TTaxdParsedAccounts;
var
  pRowFormulaRez: TFormulaPreParser;
begin
  Result := nil;

  // ---
  pRowFormulaRez := self.extractActualFrmInf;
  // if assigned(pRowFormulaRez) and  (self.FCurrAccListIndx>=0) and (self.FCurrAccListIndx<=pRowFormulaRez.accounts.Count-1) then
  //    result:=TTaxdParsedAccounts(pRowFormulaRez.accounts.Items[self.FCurrAccListIndx]);
  if assigned(pRowFormulaRez) and (self.FCurrAccListIndx >= 0) and (self.FCurrAccListIndx <= pRowFormulaRez.distinctAccounts.Count - 1) then
    Result := TTaxdParsedAccounts(pRowFormulaRez.distinctAccounts.Items[self.FCurrAccListIndx]);
end;


// 22.05.2011 Ingmar astendus !
// 102
// 1020
// 10200
function TframeDeclRez.extractActualAccInf(var pCurrAccLevel: integer): TTaxdParsedAccounts;

  function _remlikeMarker(const pAccountCode: AStr): AStr;
  begin
    Result := stringreplace(pAccountcode, '%', '', []);
  end;

var
  pRowFormulaRez: TFormulaPreParser;
  pCmp: TTaxdParsedAccounts;
  pAccLvlCode, p1, p2: AStr;
  i, pLen: integer;
begin
  Result := nil;
  pCurrAccLevel := 0;

  pRowFormulaRez := self.extractActualFrmInf;
  //if assigned(pRowFormulaRez) and  (self.FCurrAccListIndx>=0) and (self.FCurrAccListIndx<=pRowFormulaRez.accounts.Count-1) then
  if assigned(pRowFormulaRez) and (self.FCurrAccListIndx >= 0) and (self.FCurrAccListIndx <= pRowFormulaRez.distinctAccounts.Count - 1) then
  begin
    // 22.05.2011 Ingmar; bug viskame markeri välja !
    //pAccLvlCode:=_remlikeMarker(TTaxdParsedAccounts(pRowFormulaRez.accounts.Items[self.FCurrAccListIndx]).FAccountCode);
    pAccLvlCode := _remlikeMarker(TTaxdParsedAccounts(pRowFormulaRez.distinctAccounts.Items[self.FCurrAccListIndx]).FAccountCode);
    pLen := length(pAccLvlCode);
    //result:=TTaxdParsedAccounts(pRowFormulaRez.accounts.Items[self.FCurrAccListIndx]);
    Result := TTaxdParsedAccounts(pRowFormulaRez.distinctAccounts.Items[self.FCurrAccListIndx]);


    // teeme kindlast mitmenda taseme konto on antud bilasirea all...
    for i := self.FCurrAccListIndx - 1 downto 0 do
    begin
      //pCmp:=TTaxdParsedAccounts(pRowFormulaRez.accounts.Items[i]);
      pCmp := TTaxdParsedAccounts(pRowFormulaRez.distinctAccounts.Items[i]);
      if (length(_remlikeMarker(pCmp.FAccountCode)) > pLen) or (pLen < 1) then
        Exit
      else
      // sama taseme konto, samas vaatame kas prefix ka klapib
      if length(_remlikeMarker(pCmp.FAccountCode)) = length(pAccLvlCode) then
      begin
        p1 := ansilowercase(_remlikeMarker(pCmp.FAccountCode));
        p2 := ansilowercase(copy(p1, 1, length(p1) - 1));

        // täiesti uus konto, aga kood erineb ... pole samast numbriseeriast...nägemist
        if pos(p2, p1) = 0 then
          Exit;
      end
      else
      if length(_remlikeMarker(pCmp.FAccountCode)) < pLen then
      begin
        pLen := length(_remlikeMarker(pCmp.FAccountCode));

        // 10 asemel ntx 20
        if pos(_remlikeMarker(pCmp.FAccountCode), pAccLvlCode) = 0 then
          Exit;

        pLen := length(_remlikeMarker(pCmp.FAccountCode));
        pAccLvlCode := copy(pAccLvlCode, 1, pLen);

        Inc(pCurrAccLevel);
      end;
      // ---
    end;
    // ---
  end;

end;


procedure TframeDeclRez.repDecldrezGetValue(const ParName: string; var ParValue: variant);
// -- trimmime tühikud vaid, kui tegemist on detailse bilansi vaatega !
  function __trimGrpName(const pGrpname: AStr): AStr;
  begin
    Result := pGrpname;
    if chkBoxDetailedView.Checked then
      Result := trim(Result);
  end;

const

  SCAccountCode = '@scaccountcode';
  SCGrpname = '@scgrpname';
  SCGrpnameSum = '@scgrpnamesum';

  SCLine = '@scline';
  SCLineSum = '@sclinesum';
  SCLogicalNr = '@sclogicalnr';
  SCRepName = '@screpname';
  SCRepdtrange = '@screpdtrange';
  SCRepCompanyName = '@screpcompanyname';

  SCRepBalDate1 = '@screpbaldate1';
  SCRepBalDate2 = '@screpbaldate2';

  SCInitBalance = '@scinitbalance';   // algsaldo seisuga
  SCBalanceChange = '@scbalancechange'; // muutus
  SCFinalBalance = '@scfinalbalance';  // lõppsaldo

  // koondsummad grupi kohta; siin lihtsalt summeeritakse summad kokku, ilma valemit arvestamata !
  SCInitBalanceSum = '@scinitbalancesum';   // kontode algsaldode summa
  SCBalanceChangeSum = '@scbalancechangesum'; // kontode saldo muutuste summa
  SCFinalBalanceSum = '@scfinalbalancesum';  // kontode saldo muutuste lõppsumma

  // lõppsumma vastavalt valemile ! grupi lõpp !
  SCGrpInitBalSum = '@scgrpinitsum';   // algsaldo; valem !
  SCGrpChangeSum = '@scgrpchangesum'; // muutused kokku; valem !
  SCGrpFinalSum = '@scgrpfinalsum';  // lõppsaldo; valem !

  // ---
  SCLineSummary = '@sclinesummary';

var
  pNameLower: Astr;
  pDtRange: Astr;
  pAccount: TTaxdParsedAccounts;
  pRowFormulaRez: TFormulaPreParser;
  pIsDetailedFormSp: boolean;

begin

  //pIsDetailedFormSp:=(self.FreportFormType=estbk_types.CFormTypeAsBalance); // BILANSS !
  pIsDetailedFormSp := self.formSupportsDetailedView;
  if pos('@', ParName) > 0 then
  begin
    pRowFormulaRez := self.extractActualFrmInf;
    // ---
    ParValue := '';
    pNameLower := ansilowercase(ParName);

    if (pNameLower = SCLogicalNr) and not pIsDetailedFormSp then // Bilansi puhul loogilist rida ei kuva !
    begin
      if assigned(pRowFormulaRez) then
        ParValue := pRowFormulaRez.lineLogNr;
    end
    else
    // ---
    if (pNameLower = SCRepBalDate1) then
      ParValue := datetostr(dtEditStart.Date)
    else
    if (pNameLower = SCRepBalDate2) then
      ParValue := datetostr(dtEditEnd.Date)
    else
    // detailne bilanss näiteks !
    if pNameLower = SCGrpname then
    begin

      self.FLiveGroupName := '';
      if assigned(pRowFormulaRez) then
        self.FLiveGroupName := stringreplace(pRowFormulaRez.lineLongDescr, '\n', CRLF, [rfReplaceAll, rfIgnoreCase]);
      ParValue := __trimGrpName(self.FLiveGroupName);

    end
    else

    if pNameLower = SCGrpnameSum then
    begin

      // kui sõna kokku juba sees, siis rohkem ei liida !
      if pos(estbk_strmsg.SCRepAccountTotalLblCapt, ansilowercase(self.FLiveGroupName)) = 0 then
        ParValue := __trimGrpName(self.FLiveGroupName) + estbk_strmsg.SCRepAccountTotalLblCapt
      else
        ParValue := __trimGrpName(self.FLiveGroupName);

    end
    else

    if (pNameLower = SCLine) or (pNameLower = SCAccountCode) then
    begin

      // @@ detailne bilanss !!!!
      // kirjutame kontode väärtused lahti ridadena !
      if pIsDetailedFormSp and chkBoxDetailedView.Checked then
      begin

        pAccount := self.extractActualAccInf();
        // ---
        if assigned(pAccount) then
        begin

          // 28.11.2011 Ingmar;
          // &[...] kontode puhul kuvame vaid rea kirjelduse !
          if assigned(pRowFormulaRez) and (pRowFormulaRez.keepTogether) then
          begin
            if (pNameLower = SCAccountCode) then
              ParValue := ''
            else
              ParValue := pRowFormulaRez.lineLongDescr; // <--
          end
          else
          // konto kood !
          if (pNameLower = SCAccountCode) then
            ParValue := stringreplace(pAccount.FAccountCode, '%', '', [])  // kaotame % markeri
          else
            ParValue := pAccount.FAccountLongName;
        end
        else
        if (trim(pRowFormulaRez.formula) = '') and (pNameLower = SCLine) then // tühja rea nimetuse peame kuvama !
        begin
          if assigned(pRowFormulaRez) then
            ParValue := pRowFormulaRez.lineLongDescr; // <--
        end
        else
          ParValue := '';

      end
      else // default rida, mis aruanded

      if (pNameLower = SCLine) then
      begin
        if assigned(pRowFormulaRez) then
          ParValue := stringreplace(pRowFormulaRez.lineLongDescr, '\n', CRLF, [rfReplaceAll, rfIgnoreCase]);
      end;
    end
    else

    // ----------------------------------------------------
    // üldine
    // ----------------------------------------------------

    if (pNameLower = SCInitBalance) and not chkBoxDetailedView.Checked then  // algsaldo
    begin

      // extractActualFrmInf:TFormulaPreParser;
      if assigned(pRowFormulaRez) and (pRowFormulaRez.formula <> '') then
        ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez)])
      else
        ParValue := '';

    end
    else

    if (pNameLower = SCBalanceChange) and not chkBoxDetailedView.Checked then // muutus
    begin

      if assigned(pRowFormulaRez) and (pRowFormulaRez.formula <> '') then
      begin
        //if (pRowFormulaRez.accounts.Count>0) then
        if (pRowFormulaRez.distinctAccounts.Count > 0) then
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaAltRez)])
        else
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [0.00]); // lihtsalt valem 1+5
      end
      else
        ParValue := '';

    end
    else

    if (pNameLower = SCFinalBalance) and not chkBoxDetailedView.Checked then // lõppsaldo
    begin

      if assigned(pRowFormulaRez) and (pRowFormulaRez.formula <> '') then
      begin
        //if (pRowFormulaRez.accounts.Count>0) then
        if (pRowFormulaRez.distinctAccounts.Count > 0) then
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez + pRowFormulaRez.formulaAltRez)])
        else
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez)]);
      end
      else
        ParValue := '';
    end
    else

    // ----------------------------------------------------
    // masterdata bandi peal ! ainult detailse vaate puhul
    // ----------------------------------------------------

    if (pNameLower = SCInitBalance) and chkBoxDetailedView.Checked then
    begin

      pAccount := self.extractActualAccInf;

      // tavaline reziim detailse bilansi puhul, kus kuvan kõik kontode saldod
      if not pRowFormulaRez.keepTogether then
      begin
        // extractActualFrmInf:TFormulaPreParser;
        if assigned(pAccount) then
        begin
          self.FInitBalanceSum := self.FInitBalanceSum + pAccount.FAccFormulaSum;
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pAccount.FAccFormulaSum)]);
          // pigem kas deebit / kreeditrea saldo või summa !
        end
        else
          self.FInitBalanceSum := pRowFormulaRez.formulaRez;

      end
      else
      begin
        ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez)]);
      end;
      // ---
    end
    else

    if (pNameLower = SCBalanceChange) and chkBoxDetailedView.Checked then
    begin

      if not pRowFormulaRez.keepTogether then
      begin

        pAccount := self.extractActualAccInf;
        if assigned(pAccount) then
        begin
          self.FBalanceChangeSum := self.FBalanceChangeSum + pAccount.FBalanceChange;
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pAccount.FBalanceChange)]);
        end
        else // --
          self.FBalanceChangeSum := 0.00;

      end
      else
        // kui bilansirida ei lööda laiali, siis peame valemi järgi summa kuvama
      begin
        ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaAltRez)]);
      end;
      // ---
    end
    else

    if (pNameLower = SCFinalBalance) and chkBoxDetailedView.Checked then
    begin

      pAccount := self.extractActualAccInf;
      if not pRowFormulaRez.keepTogether then
      begin

        if assigned(pAccount) then
        begin
          self.FFinalBalanceSum := self.FFinalBalanceSum + (pAccount.FAccFormulaSum + pAccount.FBalanceChange);
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pAccount.FAccFormulaSum + pAccount.FBalanceChange)]);
        end
        else
        begin
          self.FFinalBalanceSum := pRowFormulaRez.formulaRez;
          if trim(pRowFormulaRez.formula) <> '' then
            ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez)]);
        end;

      end
      else
      begin
        if assigned(pAccount) then
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez + pRowFormulaRez.formulaAltRez)])
        else
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez)]);
      end;
    end
    else

    // ----------------------------------------------------

    if (pNameLower = SCInitBalanceSum) and chkBoxDetailedView.Checked then
    begin
      ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(self.FInitBalanceSum)]);
    end
    else

    if (pNameLower = SCBalanceChangeSum) and chkBoxDetailedView.Checked then
    begin

      // kui lihtsalt valem (pole kontosid) siis pole midagi kuvada ! kontrollime jooksvat rida !
      //if assigned(pRowFormulaRez) and (pRowFormulaRez.accounts.Count=0) then
      if assigned(pRowFormulaRez) and (pRowFormulaRez.distinctAccounts.Count = 0) then
        ParValue := Format(estbk_types.CCurrentMoneyFmt2, [double(0.00)])
      else
        ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(self.FBalanceChangeSum)]); // -->

    end
    else

    if (pNameLower = SCFinalBalanceSum) and chkBoxDetailedView.Checked then
    begin
      ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(self.FFinalBalanceSum)]);
    end
    else

    // 30.05.2011 Ingmar; grupi kokkuvõte vastavalt valemile !
    if pNameLower = SCGrpInitBalSum then
    begin
      if assigned(pRowFormulaRez) and (pRowFormulaRez.formula <> '') then
      begin
        //if pRowFormulaRez.accounts.Count>0 then // teisel juhul lihtsalt valem $1 või $2
        if pRowFormulaRez.distinctAccounts.Count > 0 then
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez)])
        else
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [0.00]);
      end;
    end
    else

    if pNameLower = SCGrpChangeSum then
    begin

      if assigned(pRowFormulaRez) and (pRowFormulaRez.formula <> '') then
      begin
        //if pRowFormulaRez.accounts.Count>0 then
        if pRowFormulaRez.distinctAccounts.Count > 0 then
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaAltRez)])
        else
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [0.00]);
      end;
    end
    else

    if pNameLower = SCGrpFinalSum then
    begin

      if assigned(pRowFormulaRez) and (pRowFormulaRez.formula <> '') then
      begin

        //if pRowFormulaRez.accounts.Count>0 then // teisel juhul lihtsalt valem $1 või $2
        if pRowFormulaRez.distinctAccounts.Count > 0 then
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez + pRowFormulaRez.formulaAltRez)])
        else
          ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez)]);
      end;
    end
    else

    // ----------------------------------------------------
    // üldise vormi summa; ntx käibedekl !
    // ----------------------------------------------------
    if pNameLower = SCLineSum then
    begin
      if assigned(pRowFormulaRez) then
        ParValue := Format(estbk_types.CCurrentMoneyFmt2, [_normZero(pRowFormulaRez.formulaRez)]);
    end
    else
    if pNameLower = SCRepName then
      ParValue := self.FreportLongName
    else
    if pNameLower = SCRepCompanyName then
      ParValue := estbk_globvars.glob_currcompname
    else
    if pNameLower = SCRepdtrange then
    begin
      ParValue := self.FQryDatetimeRange;
    end;
  end;
  // --
end;

// 28.05.2011 Ingmar
function TframeDeclRez.formSupportsDetailedView: boolean;
begin
  Result := (self.FreportFormType = estbk_types.CFormTypeAsBalance) or (self.FreportFormType = estbk_types.CFormTypeAsIncStatement);
end;


function TframeDeclRez.getDataLoadStatus: boolean;
begin
  Result := self.FLoadStatus;
end;


procedure TframeDeclRez.setDataLoadStatus(const v: boolean);
var
  pErr: AStr;
  pTemp: AStr;
  pFormType: AStr;
  i, pPos: integer;
  b: boolean;
begin
  self.FLoadStatus := v;
  // --
  qryWorker.Close;
  qryWorker.SQL.Clear;



  if v then
  begin

    cmbDateRange.ItemIndex := 1;
    cmbDateRange.OnChange(cmbDateRange);

    qryWorker.Connection := estbk_clientdatamodule.dmodule.primConnection;
    //qryWorker.SQL.Add(estbk_sqlclientcollection._SQLSelectGetTaxForms(self.FdeclFormId,estbk_types.CFormTypeAsVatDecl));
    qryWorker.SQL.Add(estbk_sqlclientcollection._SQLSelectGetTaxForms(self.FdeclFormId));
    qryWorker.Open;

    self.FreportLongName := qryWorker.FieldByName('form_name').AsString;
    self.FreportFormType := qryWorker.FieldByName('form_type').AsString;

    // 21.11.2011 Ingmar; ebameeldiv workaround
    if pos('ibemaksudeklaratsioon', self.FreportLongName) > 0 then
      self.FreportLongName := estbk_strmsg.SCFTypeVatDecl;

       {
        CFormTypeAsVatDecl      = 'V'; // käibemaksudeklaratsioon
        CFormTypeAsTSD          = 'D'; // tulumaks / sotsmaksu deklaratsioon http://www.emta.ee/?id=1310
        CFormTypeAsBalance      = 'B'; // bilanss
        CFormTypeAsIncStatement = 'I'; // kasumiaruamme
        CFormTypeAsAnnualReport = 'A'; // aastaaruanne
        CFormTypeAsMisc         = 'M'; // varia
      }



    b := self.formSupportsDetailedView; // bilanss / kasumiaruanne
    chkBoxDetailedView.Checked := b;
    chkBoxDetailedView.Visible := b;


    chkBoxDetailedView.Checked := False;
    // (self.FreportFormType=estbk_types.CFormTypeAsIncStatement); // kasumiaraunne peab olema detailses vaates
    grpBoxDefAccounts.Caption := ' ' + self.FreportLongName + ' ';




    // --
    qryWorker.Close;
    qryWorker.SQL.Clear;


    pErr := '';
    // 09.08.2012 Ingmar
    self.FTaxDeclCalc.hasDetailedAccLinesSupport := (self.FreportFormType <> estbk_types.CFormTypeAsVatDecl);
    // käibedeklari ja kasumiaruande puhul ei tohi sulgemiskannet arvestada !
    b := (self.FreportFormType = estbk_types.CFormTypeAsVatDecl) or (self.FreportFormType = estbk_types.CFormTypeAsIncStatement);



    self.FTaxDeclCalc.skipFinSummaryRec := b;
    self.FTaxDeclCalc.prepareCalc(self.FdeclFormId, pErr);


    if pErr <> '' then
      raise Exception.Create(pErr);

    // 09.11.2014 Ingmar; 1000 eur arvete fail
    // http://www.emta.ee/index.php?id=35598#5
    b := (self.FreportFormType = estbk_types.CFormTypeAsVatDecl);
    mnuSep.Visible := b;
    mnu1000eurbills.Visible := b;
    // ---
  end
  else
    qryWorker.Connection := nil;
end;


procedure TframeDeclRez.setzStartDate(const v: boolean);
begin
  self.FzStartDate := v;
  // if  v then
  //   begin
  //     dtEditStart.Date:=CZStartDate1980;
  //     dtEditStart.Text:='';
  //   end else
  //   begin
  cmbDateRange.ItemIndex := 1; // eelmine kuu !
  cmbDateRange.OnChange(cmbDateRange);
  //   end;
end;

procedure TframeDeclRez.doOnclickFix(Sender: TObject);
begin
  if (Sender is TWinControl) then
    with TWinControl(Sender) do
      if CanFocus then
        SetFocus;
end;

procedure TframeDeclRez.OnKeyNotif(Sender: TObject; var Key: word; Shift: TShiftState);
begin
end;

constructor TframeDeclRez.Create(frameOwner: TComponent);
var
  i: integer;
begin
  inherited Create(frameOwner);
  estbk_uivisualinit.__preparevisual(self);
  self.FParentKeyNotif := @self.OnKeyNotif;

  FTaxDeclCalc := TDeclcalc.Create;
  estbk_reportconst.fillReportDtPer(TAStrings(cmbDateRange.items), [cdt_undefined, cdt_today, cdt_currweek, cdt_prevweek]);

  self.FFilteredRez := TObjectList.Create(False);
  //TStringCellEditor(pTaxRezGrid.EditorByStyle(cbsAuto)).OnClick:=@self.doOnclickFix;
  // TButtonCellEditor(pTaxRezGrid.EditorByStyle(cbsButtonColumn)).OnClick:=@self.doOnclickFix;
end;

destructor TframeDeclRez.Destroy;
begin
  self.FFilteredRez.Free;
  FreeAndNil(FTaxDeclCalc);
  inherited Destroy;
end;


initialization
  {$I estbk_fra_formdrez.ctrs}

end.