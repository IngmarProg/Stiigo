unit estbk_frm_numerators;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, Buttons, estbk_utilities, estbk_datamodule, estbk_globvars,
  estbk_sqlcollection, estbk_types, estbk_lib_commonevents, estbk_strmsg,
  ZDataset;

// @@@@
type
  TNumTypes = record
    pNumeratorId: integer;
    pNumeratorIdf: AStr;
    pNumeratorVal: integer;
    pNumeratorFormat: AStr;
    pRowNr: integer;
  end;


type
  TNumTypesArr = array of TNumTypes;

type

  { TformNumerators }

  TformNumerators = class(TForm)
    btnClose: TBitBtn;
    btnSave: TBitBtn;
    gridNumeratorTypes: TStringGrid;
    grpboxNumerators: TGroupBox;
    qryNumerators: TZQuery;
    procedure btnSaveClick(Sender: TObject);
    procedure gridNumeratorTypesEditingDone(Sender: TObject);
    procedure gridNumeratorTypesKeyPress(Sender: TObject; var Key: char);
  private
    FNumArr: TNumTypesArr;
    FAccPeriodId: integer;
    FCompanyId: integer;
    FOnlyDefaultNumExists: boolean;
    function isConfigurable(const pNumeratorIdf: AStr; var pResolveLongName: AStr): boolean;
    procedure loadNumerators;
  public
    //    gridNumeratorTypesKeyPress
    constructor Create(const pOwner: TComponent); reintroduce;
    class procedure showAndCreate(const pCompanyId: integer; const pAccPeriodID: integer);
  end;

var
  formNumerators: TformNumerators;

implementation

const
  CCol_numname = 0;
  CCol_numval = 1;
  CCol_numprefix = 2;
  CCol_leadingZ = 3;

const
  CConcatMarker = '&';

constructor TformNumerators.Create(const pOwner: TComponent);
begin
  inherited Create(pOwner);
  (gridNumeratorTypes.EditorByStyle(cbsAuto) as TStringCellEditor).OnKeyPress := @self.gridNumeratorTypesKeyPress;
end;

procedure TformNumerators.btnSaveClick(Sender: TObject);
var
  i, ptempInt, pZCount: integer;
  pNumFmt: AStr;
begin
  if Dialogs.MessageDlg(estbk_strmsg.SConfNumChanges, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  begin
    if gridNumeratorTypes.CanFocus then
      gridNumeratorTypes.SetFocus;
    Exit;
  end;




  try
    admDatamodule.admConnection.StartTransaction;
    // --
    with qryNumerators, SQL do
      try
        Close;
        Clear;
        if self.FOnlyDefaultNumExists then
          add(estbk_sqlcollection._SQLInsertNumerators2)
        else
          add(estbk_sqlcollection._SQLUpdateNumerators);

      {
        _SQLInsertNumerators = ' INSERT INTO numerators(cr_num_val, cr_num_start, cr_num_type, '+
                             'cr_vrange_start, cr_vrange_end, cr_version, company_id) '+
                             'VALUES (:cr_num_val,:cr_num_start,:cr_num_type,:cr_vrange_start,'+
                             ':cr_vrange_end,:cr_version,:company_id)';}

        for  i := low(FNumArr) to high(FNumArr) do
        begin

          if FNumArr[i].pRowNr >= 0 then
          begin
            ptempInt := strtointdef(gridNumeratorTypes.Cells[CCol_numval, FNumArr[i].pRowNr], 0);
            paramByname('cr_num_val').AsInteger := ptempInt;
          end
          else
          if self.FOnlyDefaultNumExists then
            paramByname('cr_num_val').AsInteger := FNumArr[i].pNumeratorVal
          else
            paramByname('cr_num_val').AsInteger := 0;

          paramByname('cr_num_start').AsInteger := 1;
          paramByname('cr_num_type').AsString := FNumArr[i].pNumeratorIdf;
          // ---
          // paneme siis formaadi-stringi paika !
          if FNumArr[i].pRowNr >= 0 then
          begin
            // kasutaja formateering !
            pZCount := strtointdef(gridNumeratorTypes.Cells[CCol_leadingZ, FNumArr[i].pRowNr], -1);
            if (pZCount < 0) or (pZCount > 9) then
              pZCount := 0;

            // --
            pNumFmt := copy(gridNumeratorTypes.Cells[CCol_numprefix, FNumArr[i].pRowNr], 1, 10) + CConcatMarker + IntToStr(pZCount);
            paramByname('cr_srbfr').AsString := trim(pNumFmt);
          end
          else
            paramByname('cr_srbfr').AsString := trim(FNumArr[i].pNumeratorFormat + CConcatMarker + '0');

          // ---
          paramByname('cr_vrange_start').AsInteger := 0;
          paramByname('cr_vrange_end').AsInteger := 0;
          paramByname('cr_version').AsInteger := 0;

          // -- siis vaid uuendamise teema; sest uue maj. aasta puhul luuakse ka numeraatorid; juhul kui see firmal valitud
          if not self.FOnlyDefaultNumExists then
            paramByname('id').AsInteger := FNumArr[i].pNumeratorId
          else
            // järelikult genereerime rp. aasta põhise default 0 numeraatori järgi
          begin
            paramByname('company_id').AsInteger := self.FCompanyId;
            paramByname('accounting_period_id').AsInteger := self.FAccPeriodId;
          end;

          // --
          execSQL;
        end;

        // 15.04.2012 Ingmar; peame ka numerators cache tühjaks kustutama !
        Close;
        Clear;
        add(estbk_sqlcollection._SQLFlushNumeratorCache);
        paramByname('company_id').AsInteger := self.FCompanyId;
        execSQL;


        // --
      finally
        Close;
        Clear;
      end;

    // ---
    btnSave.Enabled := False;

    // --
    admDatamodule.admConnection.Commit;

  except
    on e: Exception do
    begin
      if admDatamodule.admConnection.InTransaction then
        try
          admDatamodule.admConnection.Rollback;
        except
        end;
      Dialogs.messageDlg(format(estbk_strmsg.SESaveFailed, [e.message]), mtError, [mbOK], 0);
    end;
  end;
end;

procedure TformNumerators.gridNumeratorTypesEditingDone(Sender: TObject);
begin
  //  btnSave.Enabled:=true;
end;

procedure TformNumerators.gridNumeratorTypesKeyPress(Sender: TObject; var Key: char);
var
  bfrVal: string;
begin
  if key > #32 then
    btnSave.Enabled := True;
  // ---
  if key in ['%', '&'] then // väldime kasutaja leidlikkust !
    key := #0
  else
  if (gridNumeratorTypes.Col in [CCol_numval, CCol_leadingZ]) then
  begin
    bfrVal := trim(gridNumeratorTypes.Cells[gridNumeratorTypes.Col, gridNumeratorTypes.Row]);
    if length(bfrVal) > 10 then
      key := #0
    else
      estbk_utilities.edit_verifyNumericEntry(gridNumeratorTypes.Editor as TCustomEdit, key);
  end; //  --
end;

function TformNumerators.isConfigurable(const pNumeratorIdf: AStr; var pResolveLongName: AStr): boolean;
const
  CPIsConfigurable: TCNumeratorTypesSet =
    [CAccGen_rec_nr,    // pearaamaatu kandeseeriad
    CAccInc_rec_nr,    // laekumiste lausendite kande number
    CAccSBill_rec_nr,  // ABLNR => müügiarve lausendite seerianumbrer
    CAccPBill_rec_nr,  // ostuarve lausendite seerianumber
    CAccCBill_rec_nr,  // kreeditarve lausendite seerianumber
    CAccRBill_rec_nr,  // ettemaksuarve lausendi seerianumber; reaalselt pole see "arve"
    CAccDBill_rec_nr,  // viivisarved ka eraldi seeriatesse
    CAccPmt_rec_nr,    // tasumise kandeseeria nr
    CAccCri_rec_nr,    // kassa laekumise kandeseeria nr => sissetulekuorder
    CAccCro_rec_nr,    // kassa laekumise kandeseeria nr => väljaminekuorder
    // DOKUMENTIDE NUMBRISEERIAD; KA TOOTED !
    CBill_doc_nr,      // - müügiarve number
    CCBill_doc_nr,     // - kreeditarve number;
    CDBill_doc_nr,     // - viivisarve number

    CPOrder_doc_nr,    // - ostutellimuse number
    CSOrder_doc_nr,    // - müügitellimuse number
    COffer_doc_nr,     // - pakkumise number
    CPMOrder_doc_nr,   // - (payment order)maksekorralduse nr
    CCSRegister_doc_recnr  // -  kassa dokumendi seeria nr
    ];
var
  i: TCNumeratorTypes;
begin
  Result := False;
  pResolveLongName := '';
  for i := low(TCNumeratorTypes) to high(TCNumeratorTypes) do
    if TNumeratorTypesSDescr[i] = pNumeratorIdf then
    begin
      Result := (i in CPIsConfigurable);
      if Result then
      begin
        pResolveLongName := trim(TNumeratorTypesLongName[i]);
        if pResolveLongName = '' then
          raise Exception.Create(pNumeratorIdf);
      end; // --
      break;
    end;
end;

procedure TformNumerators.loadNumerators;
var
  i, prownr: integer;
  pResTypename: AStr;
  pFmtLine: AStr;
  pMarkerPos: integer;
  b: boolean;
begin

  gridNumeratorTypes.Columns.Items[CCol_numname].Color := estbk_types.MyFavLightYellow;
  gridNumeratorTypes.Columns.Items[CCol_numname].ReadOnly := True;
  gridNumeratorTypes.Columns.Items[CCol_numval].ReadOnly := False;
  gridNumeratorTypes.Columns.Items[CCol_numprefix].ReadOnly := False;
  gridNumeratorTypes.Columns.Items[CCol_leadingZ].ReadOnly := False;




  // ---
  with qryNumerators, SQL do
    try
      // 15.04.2012 Ingmar; lukustame, kui vähemalt üks kanne, et prefikseid ei saaks muuta !
      Close;
      Clear;
      add(estbk_sqlcollection._SQLIsNumUsed);
      paramByname('accounting_period_id').AsInteger := self.FAccPeriodId;
      Open;
      b := FieldByName('accr_id').AsInteger > 0;
      gridNumeratorTypes.Columns.Items[CCol_numprefix].ReadOnly := b;
      if b then
        gridNumeratorTypes.Columns.Items[CCol_numprefix].Color := estbk_types.MyFavGray;


      gridNumeratorTypes.RowCount := 1;
      Close;
      Clear;
      add(estbk_sqlcollection._SQLSelectAccPeriodById);
      paramByname('id').AsInteger := self.FAccPeriodId;
      Open;
      if not EOF then
        self.Caption := self.Caption + ' (' + FieldByName('name').AsString + ')';


      // ---
      Close;
      Clear;
      add(estbk_sqlcollection._SQLSelectAccPeriodNumerators(True));
      paramByname('company_id').AsInteger := self.FCompanyId;
      paramByname('accounting_period_id').AsInteger := self.FAccPeriodId;
      Open;
      self.FOnlyDefaultNumExists := (RecordCount < 1);


      // küsime siis hetke numeraatorite info
      if self.FOnlyDefaultNumExists then
      begin
        Close;
        // proovime saada jooksvad numeraatorid ilma rp. perioodita !
        paramByname('accounting_period_id').AsInteger := 0;
        Open;
        assert(RecordCount > 0, '#1');
      end;

      setlength(self.FNumArr, RecordCount);
      i := low(self.FNumArr);

      // ---
      First;

      while not EOF do
      begin

        // ---
        prownr := -1;
        if self.isConfigurable(FieldByName('cr_num_type').AsString, presTypename) then
        begin

          gridNumeratorTypes.RowCount := gridNumeratorTypes.RowCount + 1;
          prownr := gridNumeratorTypes.RowCount - 1;
          gridNumeratorTypes.Cells[CCol_numname, prownr] := '  ' + presTypename;
          gridNumeratorTypes.Cells[CCol_numval, prownr] := FieldByName('cr_num_val').AsString;


          pFmtLine := trim(FieldByName('cr_srbfr').AsString);
          pMarkerPos := pos(CConcatMarker, pFmtLine);
          gridNumeratorTypes.Cells[CCol_numprefix, prownr] := copy(pFmtLine, 1, pMarkerPos - 1);
          gridNumeratorTypes.Cells[CCol_leadingZ, prownr] := IntToStr(strtointdef(copy(pFmtLine, pMarkerPos + 1, 255), 0));

        end;


        // ---
        FNumArr[i].pNumeratorId := FieldByName('id').AsInteger;
        FNumArr[i].pNumeratorIdf := FieldByName('cr_num_type').AsString;
        FNumArr[i].pNumeratorVal := FieldByName('cr_num_val').AsInteger;
        FNumArr[i].pNumeratorFormat := FieldByName('cr_srbfr').AsString;
        FNumArr[i].pRowNr := prownr;

        // ---
        Inc(i);

        Next;
      end;

    finally
      Close;
      Clear;
    end;

  // -- !
  btnSave.Enabled := False;
end;

class procedure TformNumerators.showAndCreate(const pCompanyId: integer;
  const pAccPeriodID: integer);
begin
  with TformNumerators.Create(nil) do
    try
      FAccPeriodId := pAccPeriodID;
      FCompanyId := pCompanyId;
      loadNumerators;
      // ---
      showmodal;
    finally
      Free;
    end;
end;

initialization
  {$I estbk_frm_numerators.ctrs}

end.
