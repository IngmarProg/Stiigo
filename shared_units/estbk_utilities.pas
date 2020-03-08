unit estbk_utilities;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils, DateUtils, types, typinfo, estbk_types, DB, ZDataset,
  {$IFNDEF NOGUI}Graphics, ComCtrls, Dialogs, Forms, Controls, StdCtrls,
  Grids, DBGrids, DBCtrls, LCLType, LCLProc, RxLookup,
  {$ENDIF}
  estbk_globvars
  {$IFDEF WINDOWS},
  Windows, shfolder
  {$ENDIF};

// viimane assert #1

type
  TMoneyRoundMode = (c5centmode, c10centmode, c10centDown); // !!!!!

  {$IFDEF NOGUI}
  // Dummy
  TForm = class
  end;

  {$ENDIF}

function _(const pStr: AStr): AStr;
procedure UseLanguage(const pUseLang: string);
procedure TranslateComponent(const pComp: TComponent);

procedure forceFirstDisplay(const pForm: TForm);
{$IFDEF WINDOWS}
procedure DebugOutput(const AClassname: string; const AFncName: string; const AData: string);
{$ENDIF}
function _doEdit(const pQuery: TZQuery): boolean;
procedure _doPost(const pQuery: TZQuery; const pNewSessionEditCalled: boolean);

function strToBase64(const pStr: AStr): AStr;
function base64ToStr(const pStr: AStr): AStr;
function EmailTitle(const pTitle: AStr): AStr;
function dataToValidJsonFormat(const pJSon: AStr): AStr;
function checkIBAN(const iban: string): boolean;
function Iso639_1ToIso639_3(const v: AStr): AStr; // hardcoded
function GetSpecialFolderPath(folder: integer): AStr;
function GetDesktopPath(): AStr;
// anna programmi jooksva kataloogi !
// GetAppConfigDir
function GetAppPath: AStr;
function GetTempDirPath: AStr;

function _intArrToStr(const pArr: TADynIntArray): AStr;

function doFilenameCleanup(const pStr: AStr): AStr;
// Bugfix: 000006 bugile redaktorisse suvaline tekst sisse ja crash..Ctrl+V abil
{$IFNDEF NOGUI}
procedure OnDbGridEditorExitFltCheck(pParentGrid: TDbGrid; pSender: TObject; pVerifyCol: integer);
{$ENDIF}

function odbcDateToLocalDate(const pdate: AStr; var pdateout: TDatetime): boolean;
function _normZero(const pVal: double): double;
// peidame tulevikus koodi ära nime;
// Copyright osa !
function _softwareCopyrightYearRange: AStr;
function _softwareCreator: AStr;

{$IFNDEF NOGUI}
procedure _focus(const pControl: TWinControl);
{$ENDIF}
function _resolveEscapeSeq(const pStr: AStr): AStr;


function fncSumIncWords(const pSum: double): AStr;
function formatByteSize(const bytes: int64): AStr;


// abistavad UI funktsioonid !
{$IFNDEF NOGUI}
function _comboboxIndexByIdVal(const pCombo: Tcombobox; const pVal: integer): integer;
function _setStatusBarText(const pText: AStr): AStr;
{$ENDIF}


function uGuid36: AStr; // unikaalne string GUID

function isAccountTypePassiva(const pAccTypeStr: AStr): boolean;
function isGenledgerRecord(const pAccMainRecType: AStr): boolean; // kas tegemist on pearaamatus tehtud kandega !


function billTypeFromStr(const pStr: AStr): TBillType;
function conv_strToStrDynArray(const pStr: AStr): TADynStrArray; // semikoolon


// otsib mingi "arvu" peale kindlat märksöna
procedure extractDescr(const pDescr: AStr; const pSrcWords: TADynStrArray; var pData: AStr);

function strToDateWithFormat(const pDtStr: AStr; const pDtFormat: AStr; var pDtRez: Tdatetime): boolean;

{$IFNDEF NOGUI}
// otsib strlisting elementi; nö "like" stiilis...
function strListLSearch(const pSrcPhrase: AStr; const pStrList: TStringList; var pSuccIndx: integer; const pSrcFromIndex: integer = 0): boolean;

procedure clearComboObjects(const cmb: TComboBox);
{$ENDIF}
procedure clearStrObject(const ps: TAStrings);
// kui ntx 1.000, siis kuvatakse ainult täisosa
function smartStrToFloat(const pItem: AStr; const pFailVal: double = 0): double;
function smartFloatFmt(const pItem: double; const fmt: AStr): AStr;
function stripExtraSpaces(const pStr: AStr): AStr;

{
  Simple encryption routines.
  Source: RX-Library
  21.11.2003  khoffrath
}
function rxXorEncode(const Key, Source: AStr): AStr;
function rxXorDecode(const Key, Source: AStr): AStr;
{$IFNDEF NOGUI}
procedure rxLibKeyDownHelper(Sender: TRxDBLookupCombo; var Key: word; Shift: TShiftState; valueAftDelAsNull: boolean = True);
procedure rxLibAndMainMenuFix;
{$ENDIF}

// ----------------------------------------------------------------------------
// nullid valuutakursid TCurrencyObjType;
{$IFNDEF NOGUI}
procedure miscResetCurrenyValList(const pCurrCmbList: TCustomComboBox);
{$ENDIF}
// tüüpiline, et gridis liidetakse aadress kokku ja muud trikid
// esiteks, kui mitu backendi, siis str. liitmine on väga rumal tegu
// teiseks, mõnedes riikides kuvatakse aadressi erinevalt, kui meil
function miscGenBuildAddr(const countryCode: AStr; const county: Astr; const city: Astr; const street: Astr;
  const housenr: Astr; const apartmnr: Astr; const zipcode: Astr; const addrFormat: TCAddrFormat = addr_defaultfmt): AStr;


// kasuta PrepareCanvas'e sees !
{$IFNDEF NOGUI}
procedure miscdbGridRowHighLighter(const pdbGrid: TDBGrid; const pdbSelState: TGridDrawState);
{$ENDIF}



// ----
procedure decodeDtRange(const dtmode: TdtPeriod; var dtStart: TDatetime; var dtEnd: TDatetime);

// ----
function datetoOdbcStr(const dt: TDatetime): AStr;
function ROT13(const s: AStr): AStr;

function passwordMixup(const loginname: AStr; const password: AStr): AStr;

function getStrDataFromPos(const sepChar: char; const dataRelPos: integer; const FString: AStr): AStr;

function createSQLInList(const ids: TADynIntArray): string;

function setRFloatSep(const strVal: AStr; const pRevMode: boolean = False): AStr;
// vaatab, et reaalarvul oleks sama eraldaja, mis süsteemis defineeritud !
function validateMiscDateEntry(newdate: AStr; var genDateTime: TDatetime): boolean;


// ----------------------------------------------------------------------------
{$IFNDEF NOGUI}
procedure grid_verifyNumericEntry(const pdbGrid: TDbGrid; const pColNumber: integer; var key: char; const pAllowSign: boolean = False);
// ---
procedure edit_verifyNumericEntry(const chkEdit: TCustomEdit; var key: char; const numericFrmt: boolean = False);

procedure edit_verifyNumericEntry_combo(const chkCombo: TCustomComboBox; var key: char; const numericFrmt: boolean = False);
// --
// KeyPress evendi jaoks
function edit_autoCustDataStrListAutoComp(const Sender: TObject; const pCustDataStrList: TAStrList; // otsing perekonna ja nimetuse järgi
  var pSmartEditSkipEventSignal: boolean;
  // ntx Ctrl+enter event, siis pole mõtet  eventi protsessida
  const pCurrentKey: TUTF8Char; var pSkipChar: boolean;
  // kui  väärtustaga #0, siis event jõuab ikka edasi, peame ansi keypressiga selle eventide ahela lõpetama
  var pLastSuccSrcPos: integer; // ntx leiti element, siis on see selle positsioon;
  const pCustIdEdit: TEdit = nil // kuhu nö peegeldatakse ka kliendi ID
  ): boolean;


// 29.03.2010 Ingmar; keypress ei tööta nagu ootaksin !
// kui panid key:=#0 või isegi #0#0, siis viimane sisestatud täht ikkagit toodi editisse
// kui ansi puhul, siis #0 ja nö viimati sisestatud täht "kaob"
procedure edit_autoCompData(const chkEdit: TCustomEdit; var key: char; const dataset: TDataset; const fieldName: AStr);

{$ENDIF}
// ----------------------------------------------------------------------------

function getSysLocname(): AStr;
function allowCharForNumericInp(const key: char): boolean;


// --- RTTI
{$IFNDEF NOGUI}
procedure changeWCtrlEnabledStatus(const cmp: TWinControl; const enable: boolean = True; const tagId: longint = 0);
procedure changeWCtrlReadOnlyStatus(const cmp: TWinControl; const ReadOnly: boolean = False; const tagId: longint = 0);
procedure clearControlsWithTextValue(const cmp: TWinControl; const tagId: longint = 0);
{$ENDIF}



function getDefaultCurrency: AStr;
function isTrueVal(str: AStr): boolean;


// erinevate andmebaasi tabelite puhul, kus võrdleme päringu tulemust ning max. id
// ennekõik üritame maksimaalselt cacheda andmeid
function chgchkSum(const maxID: integer; const rows: integer): integer;
function hashpjw(const str: AStr): integer;

function trimLdZeros(const str: AStr): AStr; // kustutab kõik 0 stringi eest
function isSSLProtocol(const url: AStr): boolean;


function roundToNormalMValue(const psum: double; const mode: TMoneyRoundMode): double;
function _donationReqDataKey(): AStr;
// ----------
implementation

uses {$IFNDEF NOGUI}ExtCtrls, Editbtn, Fileutil, Menus,{$ENDIF}
  Math, IdCoderMIME, estbk_strmsg, estbk_lib_commoncls, estbk_lib_suminwords;

// Tõlge
// TODO : GNU tekst tööle panna
function _(const pStr: AStr): AStr;
begin
  Result := pStr;
end;

procedure UseLanguage(const pUseLang: string);
begin
end;

procedure TranslateComponent(const pComp: TComponent);
begin
end;

// kui mitu kuvarit, siis osa vorm liigub valele kuvarile !!!
procedure forceFirstDisplay(const pForm: TForm);
{$IFNDEF NOGUI}
var
  b: boolean;
{$ENDIF}
begin
  {$IFNDEF NOGUI}
  b := (pForm.Caption = 'Login') or (Screen.MonitorCount > 1); // Hack in dos ...
  //  poOwnerFormCenter Instead of poMainFormCenter
  if b then
  begin
    if pForm.FormStyle = fsMDIChild then
      pForm.Position := poMainFormCenter
    else
      pForm.Position := poScreenCenter;
  end;
  {$ENDIF}
end;

{$IFDEF WINDOWS}
procedure DebugOutput(const AClassname: string; const AFncName: string; const AData: string);
{$IFDEF DEBUGMODE}
var
  msg: string;
{$ENDIF}
begin
  {$IFDEF DEBUGMODE}
  msg := ' --- ' + AClassname + ':' + AFncName + ' - ' + AData;
  OutputDebugString(PChar(msg)); // Ctrl + Alt + V  Event log
  {$ENDIF}
end;

{$ENDIF}


function _doEdit(const pQuery: TZQuery): boolean;
begin
  if not Assigned(pQuery) then
  begin
    Result := False;
    Exit;
  end;

  Result := not (pQuery.State in [dsEdit, dsInsert]);
  if Result then
    pQuery.Edit;
end;

procedure _doPost(const pQuery: TZQuery; const pNewSessionEditCalled: boolean);
begin
  if Assigned(pQuery) and pQuery.Active and (pQuery.State in [dsEdit, dsInsert]) and pNewSessionEditCalled then
    // pNewSessionEditCalled kas seda oleks üldse vaja !?
  begin
    pQuery.Post;
  end;
end;


function strToBase64(const pStr: AStr): AStr;
var
  base64: TIdEncoderMIME;
begin
  try
    base64 := TIdEncoderMIME.Create;
    Result := base64.EncodeString(pStr);
  finally
    base64.Free;
  end;
end;

function base64ToStr(const pStr: AStr): AStr;
var
  base64: TIdDecoderMIME;
begin
  try
    base64 := TIdDecoderMIME.Create;
    Result := base64.DecodeString(pStr);
  finally
    base64.Free;
  end;
end;

function EmailTitle(const pTitle: AStr): AStr;
begin
  Result := '=?UTF-8?B?' + StrToBase64(pTitle) + '?=';
end;

function dataToValidJsonFormat(const pJSon: AStr): AStr;
var
  i: integer;
  haschar: boolean;
  replwithsq: AStr;
begin
  Result := pJSon;
  // --- quite often exists, so don't scan !
  Result := StringReplace(Result, '/', '\/', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  for i := 0 to 31 do
  begin
    haschar := pos(chr(i), Result) > 0; // prescan faster as stringreplace scan
    if haschar then
    begin
      case i of
        7: replwithsq := '\a'; // Bell
        8: replwithsq := '\b'; // Backspace
        9: replwithsq := '\t'; // Horizontal Tab
        10: replwithsq := '\n'; // Line feed
        11: replwithsq := '\v'; // Vertical Tab
        12: replwithsq := '\f'; // Form feed
        13: replwithsq := '\r'; // Carriage return
        else
          replwithsq := '\u' + ansilowercase(inttohex(i, 4))
      end;

      Result := StringReplace(Result, chr(i), '\"', [rfReplaceAll]);
    end;
    // ----------
  end;

  Result := Trim(Result);
end;

// http://www.swissdelphicenter.ch/torry/showcode.php?id=1470
function ChangeAlpha(input: string): string;
  // A -> 10, B -> 11, C -> 12 ...
var
  a: char;
begin
  Result := input;
  for a := 'A' to 'Z' do
  begin
    Result := StringReplace(Result, a, IntToStr(Ord(a) - 55), [rfReplaceAll]);
  end;
end;

function CalculateDigits(iban: string): integer;
var
  v, l: integer;
  alpha: string;
  number: longint;
  rest: integer;
begin
  iban := UpperCase(iban);
  if Pos('IBAN', iban) > 0 then
    Delete(iban, Pos('IBAN', iban), 4);
  iban := iban + Copy(iban, 1, 4);
  Delete(iban, 1, 4);
  iban := ChangeAlpha(iban);
  v := 1;
  l := 9;
  rest := 0;
  alpha := '';
  try
    while v <= Length(iban) do
    begin
      if l > Length(iban) then
        l := Length(iban);
      alpha := alpha + Copy(iban, v, l);
      number := StrToInt(alpha);
      rest := number mod 97;
      v := v + l;
      alpha := IntToStr(rest);
      l := 9 - Length(alpha);
    end;
  except
    rest := 0;
  end;
  Result := rest;
end;

function checkIBAN(const iban: string): boolean;
var
  piban: AStr;
begin
  piban := StringReplace(iban, ' ', '', [rfReplaceAll]);
  if CalculateDigits(piban) = 1 then
    Result := True
  else
    Result := False;
end;

function Iso639_1ToIso639_3(const v: AStr): AStr;
begin
  Result := AnsiUpperCase(v);
  if (v = 'EST') or (v = 'ET') then
    Result := 'EE'
  else
  if (v = 'FIN') then
    Result := 'FI';
end;

function GetSpecialFolderPath(folder: integer): AStr;
{$IFDEF WINDOWS}
const
  SHGFP_TYPE_CURRENT = 0;

var
  path: array [0..MAX_PATH] of char;
{$ENDIF}
begin
  {$IFDEF WINDOWS}
  if SUCCEEDED(SHGetFolderPath(0, folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
  {$ELSE}
  Result := '';
  {$ENDIF}
end;

function GetDesktopPath(): AStr;
begin
  {$IFDEF WINDOWS}
  Result := IncludeTrailingBackSlash(GetSpecialFolderPath(CSIDL_DESKTOPDIRECTORY));
  {$ELSE}
  Result := IncludeTrailingBackSlash(GetAppConfigDir(False));
  {$ENDIF}
end;

function GetAppPath: AStr;
begin
  Result := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)));
end;

function GetTempDirPath: AStr;
begin
  Result := IncludeTrailingBackSlash(GetTempDir);
end;

function _intArrToStr(const pArr: TADynIntArray): AStr;
var
  i: integer;
begin
  Result := '';
  if length(pArr) < 1 then
    Result := '-1'
  else
    for i := low(pArr) to high(pArr) do
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + IntToStr(pArr[i]);
    end;
end;

function doFilenameCleanup(const pStr: AStr): AStr;
begin
  Result := StringReplace(pStr, '/', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '?', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '*', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '+', '_', [rfReplaceAll]);
end;

{$IFNDEF NOGUI}
procedure OnDbGridEditorExitFltCheck(pParentGrid: TDbGrid; pSender: TObject; pVerifyCol: integer);
var
  pCurrCellVal: AStr;
  pTestDouble: double;
begin
  // Sender on kahjuks Grid !!!
  //if gridClientUnpaidItems.EditorByStyle(cbsAuto) is TCustomEdit then
  // --

  if (pSender is TStringCellEditor) and assigned(pParentGrid.SelectedColumn) and (pParentGrid.SelectedColumn.Index = pVerifyCol) then
  begin

    pCurrCellVal := Trim(TStringCellEditor(pSender).Text);
    if pCurrCellVal = '' then
      pCurrCellVal := '0';

    pTestDouble := strtofloatDef(pCurrCellVal, Math.NaN);
    if Math.isNan(pTestDouble) then
    begin
      TStringCellEditor(pSender).Text := '0';
      //gridClientUnpaidItems.SelectedColumn.Field.AsFloat:=0.00;
      Dialogs.MessageDlg(format(estbk_strmsg.SEIncorrectInputVal, [pCurrCellVal]), mtError, [mbOK], 0);
    end;
  end;
end;

{$ENDIF}

// 2014-12-25
function odbcDateToLocalDate(const pdate: AStr; var pdateout: TDatetime): boolean;
var
  pYear: word;
  pMonth: word;
  pDay: word;
begin

  Result := length(Trim(pdate)) = 10;
  if not Result then
    Exit;

  pYear := StrToIntDef(copy(pdate, 1, 4), 0);
  pMonth := StrToIntDef(copy(pdate, 6, 2), 0);
  pDay := StrToIntDef(copy(pdate, 9, 2), 0);

  Result := dateutils.TryEncodeDateTime(pYear, pMonth, pDay, 0, 0, 0, 0, pdateout);
  if not Result then
    pdateout := now;
end;

function _normZero(const pVal: double): double;
begin
  Result := pVal;
  if Math.IsZero(pVal, 0.000001) then
    Result := 0.00;
{
if result=-0.00 then
   result:=0.00;
    }
end;

function _softwareCreator: AStr;
begin
  Result := 'Ingmar Tammeväli';
end;

function _softwareCopyrightYearRange: AStr;
begin
  // result:='2011-2012';
  Result := '2014';
end;

{$IFNDEF NOGUI}
procedure _focus(const pControl: TWinControl);
begin
  try

    if Assigned(pControl) and pControl.CanFocus then
      pControl.SetFocus;

  except
  end;
end;

{$ENDIF}

// 26.01.2013 Ingmar; väga huvitav viga Rasmus põllul ' ja \ puhul tuleb escape char lugemisel ! ja ka kirjutamisel !
function _resolveEscapeSeq(const pStr: AStr): AStr;
begin
  Result := pStr;
  // Rasmus Põld
  // Lisaks on müügiarvete kirjelduse lahtri puhul probleemiks, et salvestades muutub ülakoma (') koodiks \047
  //  \ muutub koodiks \134
  // Miks Postgre mõne inimese arvutis nii käitub ei tea hetkel !
  Result := stringreplace(Result, '\134', '\', [rfReplaceAll]);
  Result := stringreplace(Result, '\047', chr(39), [rfReplaceAll]);
end;

function fncSumIncWords(const pSum: double): AStr;
var
  pClass: TClass;
  pNewInst: TSuminWords_Base;
begin
  Result := '';
  pClass := FindClass('TSuminWords_' + estbk_globvars.glob_activecountryCode);
  if assigned(pClass) then
  begin
    pNewInst := pClass.Create as TSuminWords_Base;
    Result := TSuminWords_Base(pNewInst).sumInWords(pSum);
  end;
end;

// delphi.about.com kena kood !
function formatByteSize(const bytes: int64): AStr;
const
  B = 1; //byte
  KB = 1024 * B; //kilobyte
  MB = 1024 * KB; //megabyte
  GB = 1024 * MB; //gigabyte
begin
  if bytes > GB then
    Result := FormatFloat('#.## GB', bytes / GB)
  else
  if bytes > MB then
    Result := FormatFloat('#.## MB', bytes / MB)
  else
  if bytes > KB then
    Result := FormatFloat('#.## KB', bytes / KB)
  else
    Result := FormatFloat('#.## bytes', bytes);
end;

{$IFNDEF NOGUI}
function _comboboxIndexByIdVal(const pCombo: Tcombobox; const pVal: integer): integer;
var
  i: integer;
begin
  Result := -1;
  if assigned(pCombo) then
    for i := 0 to pCombo.Items.Count - 1 do
      if PtrInt(pCombo.Items.Objects[i]) = PtrInt(pVal) then
      begin
        Result := i;
        break;
      end;
end;


function _setStatusBarText(const pText: AStr): AStr;
var
  pStatusbar: TStatusBar;
  i: integer;
begin
  Result := '';
  for i := 0 to application.MainForm.ComponentCount - 1 do
    if (application.MainForm.Components[i] is TStatusBar) then
    begin
      pStatusbar := application.MainForm.Components[i] as TStatusbar;
      if pStatusbar.Visible then
      begin
        if pStatusbar.Panels.Count > 0 then
        begin
          Result := pStatusbar.Panels.Items[0].Text;
          pStatusbar.Panels.Items[0].Text := pText;
        end
        else
        begin
          Result := pStatusbar.SimpleText;
          pStatusbar.SimpleText := pText;
        end;
        pStatusbar.Repaint;
        break;
      end;
    end;
end;

{$ENDIF}

function uGuid36: AStr;
var
  pGuid: TGuid;
begin
  // OnCreateGUID kui meil vaja override teha
  SysUtils.CreateGUID(pGuid);
  Result := Trim(GUIDToString(pGuid));
  Result := stringreplace(Result, '{', '', []);
  Result := stringreplace(Result, '}', '', []);
  assert(length(Result) > 10, '#1');
end;

function isAccountTypePassiva(const pAccTypeStr: AStr): boolean;
var
  pTemp: AStr;
begin
  pTemp := AnsiUpperCase(pAccTypeStr);
  Result := (pTemp = estbk_types.CAccTypeAsPassiva) or ((pTemp = estbk_types.CAccTypeAsProfit));
end;

function isGenledgerRecord(const pAccMainRecType: AStr): boolean;
begin
  Result := (pos(estbk_types.CAccRecIdentAsGenLedger, pAccMainRecType) > 0) or
    (pos(estbk_types.CAccRecIdentAsInitBalance, pAccMainRecType) > 0) or
    // 31.07.2012 Ingmar; lubame ka sulgemiskannet !
    (pos(estbk_types.CAddRecIdendAsClosingRec, pAccMainRecType) > 0);
end;

// 28.09.2010 Ingmar; meil vaja seda kasutada mitmes kohas !
function billTypeFromStr(const pStr: AStr): TBillType;
begin
  Result := estbk_types.CB_salesInvoice;
  if pStr = _CItemSaleBill then
    Result := estbk_types.CB_salesInvoice
  else
  if pStr = _CItemPurchBill then
    Result := estbk_types.CB_purcInvoice
  else
  if pStr = _CItemPrepaymentBill then
    Result := estbk_types.CB_prepaymentInvoice
  else
  if pStr = _CItemCreditBill then
    Result := estbk_types.CB_creditInvoice;

end;


// 28.03.2010 Ingmar; pean endale kohe lausa funktsioonid üles kirjutama; Delphis neid polnud
{
function  Copy(const s: string; StartCharIndex, CharCount: integer): string;
function  Length(const s: string): integer;
function  Pos(const SearchForText, SearchInText: string): integer;
procedure Delete(var S: string; Index, Size: integer);
procedure Insert(const Source: string; var S: string; Index: integer);
}
function conv_strToStrDynArray(const pStr: AStr): TADynStrArray; // semikoolon
var
  pTmpconv: TAStrList;
  i: integer;
begin
  Result := nil;
  if pStr <> '' then
    try
      pTmpconv := TAStrList.Create;
      pTmpconv.Delimiter := ';';
      pTmpconv.DelimitedText := pStr;
      setLength(Result, pTmpconv.Count);

      // ---
      for i := 0 to pTmpconv.Count - 1 do
        Result[i] := pTmpconv.Strings[i];

    finally
      FreeAndNil(pTmpconv);
    end;
end;

procedure extractDescr(const pDescr: AStr; const pSrcWords: TADynStrArray; var pData: AStr);
var
  pPos, i, j: integer;
  pSrc, pBfr: AStr;
begin
  pData := '';
  for i := low(pSrcWords) to high(pSrcWords) do
  begin
    pSrc := (pSrcWords[i]);
    pPos := pos(pSrc, pDescr);

    if pPos > 0 then
    begin
      pBfr := '';
      for j := (PPos + length(pSrc)) + 1 to length(pDescr) do
        if not (pDescr[j] in ['0'..'9']) and (length(pBfr) > 0) then
          break
        else
        if (pDescr[j] in ['0'..'9']) then
          pBfr := pBfr + pDescr[j];
      break;
    end;
  end;

  pData := pBfr;
end;


// ----------------------------------------------------------------------------
// TODO: funktsioon lõpuni ehitada, hetkel on väga lihtsustatud versioon
// DateTimeToString, aga teistpidi formaati pole kahjuks D7 all
(*
- d  Displays the day as a number without a leading zero (1-31).
- dd  Displays the day as a number with a leading zero (01-31).
- ddd  Displays the day as an abbreviation (Sun-Sat) using the strings given by the ShortDayNames global variable.
- dddd  Displays the day as a full name (Sunday-Saturday) using the strings given by the LongDayNames global variable.
- ddddd  Displays the date using the format given by the ShortDateFormat global variable.
- dddddd  Displays the date using the format given by the LongDateFormat global variable.


- m  Displays the month as a number without a leading zero (1-12). If the m specifier immediately follows an h or hh specifier, the minute rather than the month is displayed.
- mm  Displays the month as a number with a leading zero (01-12). If the mm specifier immediately follows an h or hh specifier, the minute rather than the month is displayed.
- mmm  Displays the month as an abbreviation (Jan-Dec) using the strings given by the ShortMonthNames global variable.
- mmmm  Displays the month as a full name (January-December) using the strings given by the LongMonthNames global variable.


yy  Displays the year as a two-digit number (00-99).
yyyy  Displays the year as a four-digit number (0000-9999).
*)
// funktsioon poolik
function strToDateWithFormat(const pDtStr: AStr; const pDtFormat: AStr; var pDtRez: Tdatetime): boolean;
  // hetkel toetame vaid 2 tüüpi
const
  CDayFmt: array[0..0] of AStr = ('dd');

const
  CMonFmt: array[0..0] of AStr = ('mm');

const
  CYearFmt: array[0..1] of AStr = ('yyyy', 'yy');

var
  pParseDt: Astr;
  pDayStr: Astr;
  pYearStr: Astr;
  pMonStr: Astr;
  i, pStPos: integer;
begin
  Result := False;
  pDtRez := now;
  pParseDt := Trim(pDtStr);

  // ---
  if pParseDt <> '' then
    try

      pDayStr := '';
      pMonStr := '';
      pYearStr := '';

      // kontrollime juhtmärgid üle
      for i := 1 to length(pDtFormat) do
        if pDtFormat[i] in ['.', '-', '/', '\'] then
        begin
          if i > length(pParseDt) then
            exit;

          if pParseDt[i] <> pDtFormat[i] then
            exit;
        end;

      for i := low(CYearFmt) to high(CYearFmt) do
      begin
        pStPos := pos(CYearFmt[i], ansilowercase(pDtFormat));
        if pStPos > 0 then
        begin
          pYearStr := copy(pParseDt, pStPos, length(CYearFmt[i]));
          break;
        end;
        // --
      end;

      for i := low(CMonFmt) to high(CMonFmt) do
      begin
        pStPos := pos(CMonFmt[i], ansilowercase(pDtFormat));
        if pStPos > 0 then
        begin
          pMonStr := copy(pParseDt, pStPos, length(CMonFmt[i]));
          break;
        end;
        // --
      end;

      for i := low(CDayFmt) to high(CDayFmt) do
      begin
        pStPos := pos(CDayFmt[i], ansilowercase(pDtFormat));
        if pStPos > 0 then
        begin
          pDayStr := copy(pParseDt, pStPos, length(CDayFmt[i]));
          break;
        end;
        // --
      end;


      if (pDayStr = '') or (pMonStr = '') or (pYearStr = '') then
        exit;

      Result := TryEncodeDate(strToIntDef(pYearStr, 0), strToIntDef(pMonStr, 0), strToIntDef(pDayStr, 0), pDtRez);

    except
    end;
end;

{$IFNDEF NOGUI}
function strListLSearch(const pSrcPhrase: AStr; const pStrList: TStringList; var pSuccIndx: integer; const pSrcFromIndex: integer = 0): boolean;
var
  i: integer;
  pSrcPhraseUp: AStr;
  pSrcCItem: AStr;
begin
  Result := False;
  pSrcPhraseUp := UpperCase(pSrcPhrase);
  pSuccIndx := -1;
  if (length(pSrcPhrase) > 0) and (pSrcFromIndex >= 0) then
    for i := pSrcFromIndex to pStrList.Count - 1 do
      if length(pStrList.Strings[i]) > 0 then
      begin
        // Kiirendame otsingut, esmalt kontrollime, kas esimene täht klapib, kui ei siis ei tee pikka võrdlust
        if UpperCase(pSrcPhraseUp[1]) <> UpperCase(Copy(pStrList.Strings[i], 1, 1)) then
          Continue;

        pSrcCItem := UpperCase(pStrList.Strings[i]);
        pSrcCItem := StringReplace(pSrcCItem, estbk_types.CInternalConcatMarker, ' ', []);
        if Pos(pSrcPhraseUp, pSrcCItem) = 1 then
        begin
          Result := True;
          pSuccIndx := i;
          Break;
        end;
      end;
end;

procedure clearComboObjects(const cmb: TComboBox);
var
  i: integer;
begin
  if assigned(cmb) then
  begin
    for i := 0 to cmb.Items.Count - 1 do
      if assigned(cmb.Items.Objects[i]) then
      begin

        cmb.Items.Objects[i].Free;
        cmb.Items.Objects[i] := nil;
      end;

    cmb.Clear;
  end;
end;

{$ENDIF}

procedure clearStrObject(const ps: TAStrings);
var
  i: integer;
begin
  if assigned(ps) then
  begin
    for i := 0 to ps.Count - 1 do
      if assigned(ps.objects[i]) then
      begin
        ps.objects[i].Free;
        ps.objects[i] := nil;
      end;

    ps.Clear;
  end;
end;

function smartStrToFloat(const pItem: AStr; const pFailVal: double = 0): double;
begin
  Result := strToFloatDef(pItem, pFailVal);
end;

// TODO !!
function smartFloatFmt(const pItem: double; const fmt: AStr): AStr;
begin
  Result := format(fmt, [pItem]);
end;

// TODO; ntx nimi on  INGMAR     TAMMEVÄLI, saab INGMAR TAMMEVÄLI
function stripExtraSpaces(const pStr: AStr): AStr;
begin
  Result := pStr;
end;

function rxXorEncode(const Key, Source: AStr): AStr;
var
  I: integer;
  C: byte;
begin
  Result := '';
  for I := 1 to Length(Source) do
  begin
    if Length(Key) > 0 then
      C := byte(Key[1 + ((I - 1) mod Length(Key))]) xor byte(Source[I])
    else
      C := byte(Source[I]);
    Result := Result + AnsiLowerCase(IntToHex(C, 2));
  end;
end;

function rxXorDecode(const Key, Source: AStr): AStr;
var
  I: integer;
  C: char;
begin
  Result := '';
  for I := 0 to Length(Source) div 2 - 1 do
  begin
    C := Chr(StrToIntDef('$' + Copy(Source, (I * 2) + 1, 2), Ord(' ')));
    if Length(Key) > 0 then
      C := Chr(byte(Key[1 + (I mod Length(Key))]) xor byte(C));
    Result := Result + C;
  end;
end;

{$IFNDEF NOGUI}
// RX abi !!!!!!!
procedure rxLibKeyDownHelper(Sender: TRxDBLookupCombo; var Key: word; Shift: TShiftState; valueAftDelAsNull: boolean = True);
begin
  if (shift = []) then
  begin
    if key = VK_DELETE then
    begin
      TRxDBLookupCombo(Sender).Text := '';
      // RX kasutab values stringi mitte reaalset varianti; väga sürrr
      if valueAftDelAsNull then
        TRxDBLookupCombo(Sender).Value := ''
      else
        TRxDBLookupCombo(Sender).Value := '0';
      key := 0;
    end;
  end
  else
  if (shift = [ssCtrl]) then
  begin
    if key = VK_RETURN then
    begin
      TRxDBLookupCombo(Sender).PopupVisible := True;
      key := 0;
    end;
  end;
end;

procedure rxLibAndMainMenuFix;
//var
// pFndMainForm :
var
  i, j: integer;
  pMnuItem: TMenuItem;
begin

  // 22.11.2009 Ingmar; ega bugi veel ei lĆµppe !
  // peale popupwindow tulekut on menĆ¼Ć¼ Ć¼leval kadunud, mingi repaint teema
  //if self.Owner is TCustomForm then
  //   TCustomForm(Self.Owner).Repaint;
  //if TRxDBLookupCombo(Sender).PopupVisible then

  if assigned(Screen.ActiveForm) then
    for i := 0 to screen.ActiveForm.ComponentCount - 1 do
      if screen.ActiveForm.Components[i] is TMainmenu then
      begin
        for j := 0 to TMainmenu(screen.ActiveForm.Components[i]).Items.Count - 1 do
        begin
          pMnuItem := TMainmenu(screen.ActiveForm.Components[i]).Items.Items[j];
          if Pos('FIX', pMnuItem.Name) > 0 then // tee peidetud menüü item nimega FIX ja see jäta alati viimaseks !
          begin
            pMnuItem.Visible := True;
            pMnuItem.Visible := False;
            Break;
          end;
        end;
        //mnuRBug
      end;
end;

procedure miscResetCurrenyValList(const pCurrCmbList: TCustomComboBox);
var
  pTmp, i: integer;
begin
  pTmp := pCurrCmbList.Items.IndexOf(estbk_globvars.glob_baseCurrency);
  if pTmp >= 0 then
    pCurrCmbList.ItemIndex := pTmp
  else
    pCurrCmbList.ItemIndex := -1;
  // TODO; pole just eriti arukas igakord uuesti kursse baasist küsida ?!? tulevikus parem loogika teha
  for i := 0 to pCurrCmbList.items.Count - 1 do
    if assigned(pCurrCmbList.items.objects[i]) and (i <> pTmp) then // !!! baaskurssi ei nulli 1.0000000000
    begin
      TCurrencyObjType(pCurrCmbList.items.objects[i]).currVal := 0;
      TCurrencyObjType(pCurrCmbList.items.objects[i]).currDate := now + 1;
      TCurrencyObjType(pCurrCmbList.items.objects[i]).id := 0;
    end;
end;

{$ENDIF}

function miscGenBuildAddr(const countryCode: AStr; const county: Astr; const city: Astr; const street: Astr;
  const housenr: Astr; const apartmnr: Astr; const zipcode: Astr; const addrFormat: TCAddrFormat = addr_defaultfmt): AStr;
var
  pRez: AStr;
begin
{
Mustamäe 85-45
12500 Tallinn
Harjumaa
}
  // hetkel riiki ei kuva... TODO tulevikus lisada !
  pRez := '';
  case addrFormat of
    addr_defaultfmt:
    begin
      pRez := street + ' ' + housenr;
      if Trim(apartmnr) <> '' then
        pRez := pRez + ' - ' + apartmnr;
      pRez := Trim(pRez);

      pRez := pRez + ' ' + city + ' ' + county;
      pRez := Trim(pRez);
    end;


    addr_companyfmt,
    addr_billfmt,
    addr_orderfmt,
    addr_pmtorderfmt:
    begin
      pRez := street + ' ' + housenr;
      if Trim(apartmnr) <> '' then
        pRez := pRez + ' - ' + apartmnr;

      pRez := Trim(pRez) + #13#10;
      pRez := pRez + Trim(zipcode + ' ' + city) + #13#10;
      pRez := pRez + Trim(county);
    end;
  end;

  Result := pRez;
end;

{$IFNDEF NOGUI}
procedure miscdbGridRowHighLighter(const pdbGrid: TDBGrid; const pdbSelState: TGridDrawState);
begin
  pdbGrid.Canvas.Font.Color := clBlack;
  if (gdSelected in pdbSelState) then
  begin
    pdbGrid.Canvas.Brush.Color := clHighlight;
    pdbGrid.Canvas.Font.Color := clHighlightText;
  end
  else
  if ((pdbGrid.DataSource.Dataset.RecNo mod 2) <> 0) then
  begin
    pdbGrid.Canvas.Brush.Color := MyFavGray;
  end
  else
    pdbGrid.Canvas.Brush.Color := clWindow;
end;

{$ENDIF}

procedure decodeDtRange(const dtmode: TdtPeriod; var dtStart: TDatetime; var dtEnd: TDatetime);
// cmptoday:=StartOfTheDay(dtToday);
begin
  case dtmode of
    cdt_undefined:
    begin
    end;

    cdt_today:
    begin
      dtStart := date;
      dtEnd := date;
    end;

    cdt_currweek:
    begin
      dtStart := dateutils.StartOfTheWeek(date);
      dtEnd := date;
    end;

    cdt_prevweek:
    begin
      dtStart := dateutils.StartOfTheWeek(date);
      dtStart := dateutils.StartOfTheWeek(dtStart - 1);
      dtEnd := dateutils.EndOfTheWeek(dtStart);
    end;

    cdt_currmonth:
    begin
      dtStart := dateutils.StartOfTheMonth(date);
      dtEnd := date;
    end;


    cdt_prevmonth:
    begin
      dtStart := dateutils.StartOfTheMonth(dateutils.StartOfTheMonth(date) - 1);
      dtEnd := dateutils.EndOfTheMonth(dtStart);
    end;

    cdt_ovrprevmonth:
    begin
      dtStart := dateutils.StartOfTheMonth(dateutils.StartOfTheMonth(dateutils.StartOfTheMonth(date) - 1) - 1);
      dtEnd := dateutils.EndOfTheMonth(dtStart);
    end;

    cdt_currentYear:
    begin
      dtStart := dateutils.StartOfAYear(dateutils.YearOf(date));
      dtEnd := date;
    end;
    // 14.07.2012
    cdt_prevYear:
    begin
      dtStart := dateutils.StartOfAYear(dateutils.YearOf(date) - 1);
      dtEnd := dateutils.EndOfAYear(dateutils.YearOf(date) - 1);
    end;
    cdt_ovrprevYear:
    begin
      dtStart := dateutils.StartOfAYear(dateutils.YearOf(date) - 2);
      dtEnd := dateutils.EndOfAYear(dateutils.YearOf(date) - 2);
    end; // --
  end;
end;

function datetoOdbcStr(const dt: TDateTime): Astr;
begin
  Result := formatdatetime('yyyy-mm-dd', dt);
end;

function ROT13(const s: AStr): AStr;
var
  i: integer;
begin
  Result := s;
  for i := 1 to length(Result) do
  begin
    if (Result[i] in ['A'..'M', 'a'..'m']) then
      Result[i] := CHR(Ord(Result[i]) + 13)
    else
    if Result[i] in ['N'..'Z', 'n'..'z'] then
      Result[i] := CHR(Ord(Result[i]) - 13);
  end;
end;

function passwordMixup(const loginname: AStr; const password: AStr): AStr;
var
  ptotal: AStr;
  ptmp: AStr;
  i: integer;
begin
  Result := '';
  ptotal := 'A'; // lihtsalt segamiseks
  for i := 1 to length(loginname) do
  begin
    if i <= length(password) then
    begin
      if loginname[i] > password[i] then
        ptotal := ptotal + password[i]
      else
        ptotal := ptotal + loginname[i];
    end
    else
      break;
  end;


  if length(ptotal) > 0 then
  begin
    ptmp := ptotal[length(ptotal)];
    ptotal[length(ptotal)] := ptotal[1];
    ptotal[1] := ptmp[1];
  end;

  if length(loginname) > length(password) then
    for i := 1 to length(loginname) do
    begin
      if (i mod 2) = 0 then
        ptotal := ptotal + loginname[i];
    end
  else
    for i := 1 to length(password) do
    begin
      if (i mod 2) = 1 then
        ptotal := ptotal + password[i];
    end;

  Result := ptotal;

  ptotal := inttohex(Ord(ptotal[1]) xor 65, 4);
  if ptotal[length(ptotal)] <> 'A' then
    Result := 'A' + Result + rot13(password) + inttohex(length(loginname) + length(password), 2);

  // nüüd peaks neil paras segadus olema
  ptotal := IntToStr(length(Result));
  for  i := 2 to strtointdef(ptotal, 0) do
  begin
    if i = 2 then
      ptotal := '';
    if ((Ord(Result[i]) >= 65) and (Ord(Result[i]) <= 90)) or ((Ord(Result[i]) >= 97) and (Ord(Result[i]) <= 120)) then
      // meelega jätsin; 120 mitte 122 !!!
      ptotal := ptotal + Result[i]
    else
      ptotal := ptotal + inttohex(Ord(Result[i]), 2);

  end;

  Result := copy(ptotal, 1, 65);
end;

// 02.11.2009 Ingmar; nostalgiline ja vana hea kood, mis siiani töötab, natuke kohendasin ...
// 28.08.2000
function getStrDataFromPos(const sepChar: char; const dataRelPos: integer; const FString: AStr): AStr;
var
  MarkPos: integer;
  StrIndex: integer;
  StrPikkus: integer;
  Kordus: integer;
  OigePosits: integer;
  TempString: AStr;

begin
  Result := FString;
  MarkPos := Pos(sepChar, Result);


  if (dataRelPos = 1) and (MarkPos > 0) then
  begin
    Result := Copy(Result, 1, MarkPos - 1);
    Exit;
  end;

  StrPikkus := Length(Result);
  if StrPikkus = 0 then
    Exit;
  OigePosits := 1;
  StrIndex := 1;
  while (StrIndex <> StrPikkus) do
  begin

    if (Result[StrIndex] = sepChar) then
      while (StrIndex <> StrPikkus) do
      begin
        Inc(StrIndex);
        if (StrIndex <= length(Result)) and (Result[StrIndex] <> sepChar) then
        begin
          Inc(OigePosits);
          TempString := Copy(Result, StrIndex, (StrPikkus - StrIndex) + 1);
          MarkPos := Pos(sepChar, TempString);
          if MarkPos > 0 then
            StrIndex := (StrIndex + MarkPos) - 1;

          if OigePosits = dataRelPos then
          begin
            // !!!
            if MarkPos = 0 then
              Result := TempString
            else
              Result := Copy(TempString, 1, MarkPos - 1);
            Exit;
          end
          else
            Break;
        end
        else
        begin
          Result := '';
          Inc(OigePosits);
        end;

      end
    else
      Inc(StrIndex);
  end;

  // 17.03.2011 Ingmar; järelikult ei leitud positsioonilt midagi !
  Result := '';
end;

function createSQLInList(const ids: TADynIntArray): AStr;
var
  upindx, i: integer;
begin
  Result := '';
  upindx := high(Ids);

  if (upindx = 0) and (Ids[0] < 1) then
    exit;

  for i := low(Ids) to upindx do
  begin
    Result := Result + IntToStr(ids[i]);
    if i <> upindx then
      Result := Result + ',';
  end;
end;

function setRFloatSep(const strVal: AStr; const pRevMode: boolean = False): AStr;
begin
  // -----
  Result := strVal;
  // -----
  if not pRevMode then
  begin
    if (SysUtils.DecimalSeparator = ',') then
      Result := stringreplace(Result, '.', ',', [])
    else
    if (SysUtils.DecimalSeparator = '.') then
      Result := stringreplace(Result, ',', '.', []);
  end
  else
    // inverteeritud
  begin
    if (SysUtils.DecimalSeparator = ',') then
      Result := stringreplace(Result, ',', '.', [])
    else
    if (SysUtils.DecimalSeparator = '.') then
      Result := stringreplace(Result, '.', ',', []);
  end;
end;

// RoundTo
// protseduur üritab parsida kuupäeva igasugustesse imelistesse formaatidesse
function validateMiscDateEntry(newdate: AStr; var genDateTime: TDatetime): boolean;
const
  fStartYear = 2000;
const
  CZStartDate1980 = 29221; //19800101
  CZEndDate2050 = 54789; //20500101

const
  // TODO: muuta regioonivabaks !!!!!!!!!!!
  fDefEstMonthName: array[1..12] of string =
    (
    'jaanuar',
    'veebruar',
    'märts',
    'aprill',
    'mai',
    'juuni',
    'juuli',
    'august',
    'september',
    'oktoober',
    'novermber',
    'detsember'
    );

  function daysInMonth(const dt: TDateTime): byte;
  var
    pYear, pMonth, pDay: word;
  begin
    DecodeDate(dt, pYear, pMonth, pDay);
    if pMonth in [1, 3, 5, 7, 8, 10, 12] then
      Result := 31
    else
    if pMonth in [4, 6, 9, 11] then
      Result := 30
    else
    if DateUtils.IsInLeapYear(dt) then
      //If pYear Mod 4=0 Then
      Result := 29
    else
      Result := 28;
  end;

var
  pBadDtMarker: TDatetime;
  pNewDtTime: TDatetime;
  //pParseDate   : AStr;
  pDay: word;
  pMonth: word;
  pYear: word;
  tmpVar: word;
  tmpVar1: word;
  pStrList: TStringList;
  i, dpos: integer;
  tmp: string;
begin
  try
    Result := False;
    pDay := 0;
    pMonth := 0;
    pYear := 0;

    //pParseDate:=newDate;
    newdate := Trim(stringreplace(newdate, ',', SysUtils.DateSeparator, [rfReplaceAll]));
    if Trim(newdate) = '' then
      exit;

    // --------------
    pBadDtMarker := now + 365;
    // --------------
    pNewDtTime := CZStartDate1980;

    try
      pNewDtTime := StrToDateDef(newdate, pBadDtMarker);
    except
      // seda ei tohiks juhtuda, teades cmp muudatusi ei saa vĆ¤listada !
    end;
    //dateutils.TryEncodeDateTime()
    Result := (pNewDtTime <> pBadDtMarker);
    if Result then
      genDateTime := pNewDtTime
    else
      try
        pStrList := TStringList.Create;
        if length(newdate) = 4 then
        begin
          // 3001
          pDay := strtointdef(copy(newdate, 1, 2), 0);
          pMonth := strtointdef(copy(newdate, 3, 4), 0);
          pYear := dateutils.YearOf(now);
          // -------
          pNewDtTime := pBadDtMarker;
          dateutils.TryEncodeDateTime(pYear, pMonth, pDay, 0, 0, 0, 0, pNewDtTime);
          if pNewDtTime = pBadDtMarker then
            exit;


          genDateTime := pNewDtTime;
          Result := True;
        end
        else
        if (length(newdate) = 6) then
        begin
          pDay := strtointdef(copy(newdate, 1, 2), 0);
          pMonth := strtointdef(copy(newdate, 3, 2), 0);
          pYear := 2000 + strtointdef(copy(newdate, 5, 2), 0);

          pNewDtTime := pBadDtMarker;
          dateutils.TryEncodeDateTime(pYear, pMonth, pDay, 0, 0, 0, 0, pNewDtTime);
          if pNewDtTime = pBadDtMarker then
            exit;


          genDateTime := pNewDtTime;
          Result := True;
        end
        else
        if (length(newdate) = 8) then
        begin

          pDay := strtointdef(copy(newdate, 1, 2), 0);
          pMonth := strtointdef(copy(newdate, 3, 2), 0);
          pYear := strtointdef(copy(newdate, 5, 4), 0);

          pNewDtTime := pBadDtMarker;
          dateutils.TryEncodeDateTime(pYear, pMonth, pDay, 0, 0, 0, 0, pNewDtTime);
          if pNewDtTime = pBadDtMarker then
            Exit;


          genDateTime := pNewDtTime;
          Result := True;

        end
        else
        if (length(newdate) = 10) then
        begin
          // 30.01.2009  - vĆµib jĆµuda siia, kui lokaalsed seaded teise formaadiga !!!
          // 30-01-2009
          // 2009-01-30
          // --- jĆ¤rsku odbc
          pStrList.Delimiter := '.';
          pStrList.DelimitedText := newdate;
          if pStrList.Count <> 3 then
          begin
            pStrList.Clear;
            pStrList.Delimiter := '-';
            pStrList.DelimitedText := newdate;
            if pStrList.Count <> 3 then // jĆ¤re
              exit;

            pDay := strtointdef(pStrList.strings[0], 0);
            pMonth := strtointdef(pStrList.strings[1], 0);
            pYear := strtointdef(pStrList.strings[2], 0);
          end
          else
          begin
            pDay := strtointdef(pStrList.strings[0], 0);
            pMonth := strtointdef(pStrList.strings[1], 0);
            pYear := strtointdef(pStrList.strings[2], 0);
          end;


          // jĆ¤rsku odbc
          if pDay > fStartYear then
          begin
            tmpVar := pYear;
            pYear := pDay;
            tmpVar1 := pMonth;
            pMonth := tmpVar1;
            pDay := tmpVar;
          end;



          if pYear < fStartYear then
            pYear := fStartYear + pYear;

          pNewDtTime := pBadDtMarker;
          dateutils.TryEncodeDateTime(pYear, pMonth, pDay, 0, 0, 0, 0, pNewDtTime);
          if pNewDtTime = pBadDtMarker then
            exit;


          genDateTime := pNewDtTime;
          Result := True;
        end
        else
        if length(newdate) > 10 then
        begin
          tmp := ansilowercase(newdate);
          for i := 1 to 12 do
            if pos(fDefEstMonthName[i], tmp) > 0 then
            begin
              pMonth := i;
              tmp := stringreplace(tmp, fDefEstMonthName[i], '', []); // kuu nimi vĆ¤lja
              dpos := pos('.', tmp);
              if dpos = 0 then
                dpos := pos(' ', tmp);

              if dpos <= 1 then
                exit;

              pDay := strtointdef(copy(tmp, 1, dpos - 1), 0);
              if (pDay <= 0) or (pDay > 31) then
                exit;

              Delete(tmp, 1, pos(fDefEstMonthName[i], tmp) + length(fDefEstMonthName[i]));
              tmp := Trim(tmp);

              pYear := strtointdef(tmp, 0);
              if pYear < fStartYear then
                pYear := fStartYear + pYear;

              pNewDtTime := pBadDtMarker;
              dateutils.TryEncodeDateTime(pYear, pMonth, pDay, 0, 0, 0, 0, pNewDtTime);
              if pNewDtTime = pBadDtMarker then
                exit;


              genDateTime := pNewDtTime;
              Result := True;
              // ----
              break;
            end;
          // formaadid
          // 30.jaanuar 2009
        end;

        // ---------------
      finally
        FreeAndNil(pStrList);
      end;
    // -----
  except
    Result := False;
  end;
end;


{$IFNDEF NOGUI}
// 27.03.2010 ingamr
procedure grid_verifyNumericEntry(const pdbGrid: TDbGrid; const pColNumber: integer; var key: char; const pAllowSign: boolean = False);
var
  pFieldVal: AStr;
begin
  if assigned(pdbGrid) and (assigned(pdbGrid.SelectedColumn)) and (pdbGrid.SelectedColumn.Index = pColNumber) then
  begin
    //pFieldVal:=Trim(TDbgrid(sender).SelectedColumn.Field.AsString));
    pFieldVal := Trim(TCustomEdit(pdbGrid.EditorByStyle(cbsAuto)).Text);

    if key < #32 then
      Exit;

    if (key in ['+', '-']) then
      if pAllowSign then
      begin
        if (pos('+', pFieldVal) > 0) or (pos('-', pFieldVal) > 0) then
          key := #0
        else
        if TCustomEdit(pdbGrid.EditorByStyle(cbsAuto)).SelStart <> 0 then
          key := #0;
      end
      else
        key := #0;

    if ((key in [',', '.']) and ((pFieldVal = '') or (pos('.', pFieldVal) > 0) or (pos(',', pFieldVal) > 0))) then
      key := #0
    else
    //TDbgrid(sender).SelectedColumn.Field     if key in []
    if not pdbGrid.SelectedColumn.Field.IsValidChar(key) then
      key := #0;
  end;
end;

// TEST
// KeyPress evendi jaoks
function edit_autoCustDataStrListAutoComp(const Sender: TObject; const pCustDataStrList: TAStrList; // otsing perekonna ja nimetuse järgi
  var pSmartEditSkipEventSignal: boolean;
  // ntx Ctrl+enter event, siis pole mõtet  eventi protsessida
  const pCurrentKey: TUTF8Char; var pSkipChar: boolean;
  // kui  väärtustaga #0, siis event jõuab ikka edasi, peame ansi keypressiga selle eventide ahela lõpetama
  var pLastSuccSrcPos: integer; // ntx leiti element, siis on see selle positsioon;
  const pCustIdEdit: TEdit = nil // kuhu nö peegeldatakse ka kliendi ID
  ): boolean;
var
  pSrcInst: TAStrList;
  pSrcPhrase: AStr;
  pNorm: AStr;
  pBackSpaceMod: boolean;
  pSelectedLen, pSelectedPos: integer;
begin
  Result := False;
  if not (Sender is TCustomEdit) then
    Exit;

  pSelectedLen := TEdit(Sender).SelLength;
  pSelectedPos := TEdit(Sender).SelStart;

  // 28.03.2010 Ingmar;
  if pSmartEditSkipEventSignal then
  begin
    //memo1.lines.add('keypress '+inttostr(ord(key[1])));
    pSmartEditSkipEventSignal := False;
    Exit;
  end;


  // lazaruse bugi, kui siin panna, et key=#0 pole mingit kasu sellest, peame ansikeypressile teatama, et kuule peata see märk !
  pSkipChar := False;
  pBackSpaceMod := False;
  if pCurrentKey = #13 then
  begin
    //TEdit(Sender).SelectNext(Sender as twincontrol, True, True);
    //Key:=#0;
    pSkipChar := True;
    Result := True;
    Exit;
  end
  else
    pSrcPhrase := TEdit(Sender).Text;
  //if (Key>=#32) then
  //     pSrcPhrase:=pSrcPhrase+Key
  //else
  if (pCurrentKey = #09) then
  begin
    Result := True;
    Exit;
  end
  else if (pCurrentKey = #08) then
  begin
    //pSrcPhrase:=Copy(TEdit(Sender).Text,1,Length(TEdit(Sender).Text)-1)
    if Assigned(pCustIdEdit) then
      pCustIdEdit.Text := '';
    // ---
    pSkipChar := True;
    if (TEdit(Sender).SelLength = 0) then
    begin
      pSrcPhrase := Copy(TEdit(Sender).Text, 1, Length(TEdit(Sender).Text) - 1);
    end
    else
    begin
      pSrcPhrase := TEdit(Sender).Text;
      Delete(pSrcPhrase, pSelectedPos + 1, pSelectedLen);
      pBackSpaceMod := True;
    end;
    // ---
    //self.FSmartEditSkipChar:=true;
  end
  else
  begin
    //pSrcPhrase:=pSrcPhrase+key;
    if (pSelectedLen > 0) and (pSelectedLen = length(TEdit(Sender).Text)) then
    begin
      //TEdit(Sender).SelLength:=TEdit(Sender).SelLength-1;
      //TEdit(Sender).SelStart:=1;
      pSrcPhrase := pCurrentKey;
    end
    else
    begin
      pSrcPhrase := Copy(TEdit(Sender).Text, 1, pSelectedPos);
      pSrcPhrase := pSrcPhrase + pCurrentKey;
    end;

    //Key:=#0;
    pSkipChar := True;
  end;

  // viide nimede nimistule
  pSrcInst := pCustDataStrList; //estbk_clientdatamodule.dmodule.custFastSrcList;
  // ---



  if strListLSearch(pSrcPhrase, pSrcInst, pLastSuccSrcPos) then
  begin
    pNorm := stringreplace(pSrcInst.Strings[pLastSuccSrcPos], estbk_types.CInternalConcatMarker, ' ', []);
    if not pBackSpaceMod then
    begin
      TEdit(Sender).Text := pNorm;
      TEdit(Sender).SelStart := length(pSrcPhrase);
      TEdit(Sender).SelLength := (length(TEdit(Sender).Text) - length(pSrcPhrase)) + 1;
      TEdit(Sender).ShowHint := False;
      TEdit(Sender).Hint := TClientData(pSrcInst.Objects[pLastSuccSrcPos]).FCustRegNr;


      //edtCustId.Text:=TCustomerSrcData(pSrcInst.Objects[self.FSmartEditLastSuccIndx]).FCustRegNr;
      // 20.02.2011 Ingmar nüüdsest kasutame ju kliendikoodi !
      if assigned(pCustIdEdit) then
        pCustIdEdit.Text := TClientData(pSrcInst.Objects[pLastSuccSrcPos]).FClientCode;
      //inttostr(TClientData(pSrcInst.Objects[pLastSuccSrcPos]).FClientId);

      // ---
      TEdit(Sender).ShowHint := True;

    end
    else
      // backspace abil kustutamine
    begin
      TEdit(Sender).Text := pSrcPhrase;
      TEdit(Sender).Hint := '';
      TEdit(Sender).SelStart := length(pSrcPhrase);
      TEdit(Sender).SelLength := 0;

      if assigned(pCustIdEdit) then
        pCustIdEdit.Text := '';
      //edtCustId.Text:='';
      //TEdit(Sender).SelStart:=length(pSrcPhrase);
      //TEdit(Sender).SelLength:=(length(pNorm)-length(pSrcPhrase))+1;
    end;

    // ---
    Result := True;
    //TEdit(Sender).SelLength:=(length(TEdit(Sender).Text)-TEdit(Sender).SelStart)+1;
    //TEdit(Sender).SelStart:=length(pSrcPhrase);
    //TEdit(Sender).SelLength:=length(pSrcPhrase)-TEdit(Sender).SelStart;
  end
  else
  begin
    TEdit(Sender).Text := pSrcPhrase;
    TEdit(Sender).SelStart := length(pSrcPhrase);
    if assigned(pCustIdEdit) then
      pCustIdEdit.Text := '';
    pLastSuccSrcPos := -1;
    Result := False;
  end;
end;

// regexpr, tmaskedit ei ole alati parim lahendus
procedure edit_verifyNumericEntry(const chkEdit: TCustomEdit; var key: char; const numericFrmt: boolean = False);
var
  cText: AStr;
begin
  // enter,tab, backspace...
  if (key in [#13, #09, #08]) then
    exit;

  if (chkEdit is TDbEdit) then
    cText := TDbEdit(chkEdit).Text // TDbEdit(chkEdit).Field.AsString;
  else
  if (chkEdit is TCustomEdit) then
    cText := TCustomEdit(chkEdit).Text;




  // 01111 varianti ei luba !
  if (length(cText) = 1) and (cText[1] = '0') and (chkEdit.SelLength <> length(cText)) and not (key in [',', '.']) then
  begin
    key := #0;
  end
  else
  if (not numericFrmt and (key in ['.', ','])) then
    key := #0
  else
  if (not (key in ['0'..'9', '+', '-', '.', ','])) then
    key := #0
  else
  // märk tohib ainult olla esimene...ja vaid korra...
  if (key in ['+', '-']) and ((chkEdit.SelStart <> 0) or (pos('+', cText) > 0) or (pos('-', cText) > 0)) then
    key := #0
  else
  if numericFrmt and (key in ['.', ',']) then
  begin
    // peale märki ei tohi olla koma !!!
    if (chkEdit.SelStart = 1) and (length(cText) >= 1) and (cText[1] in ['+', '-']) then
      key := #0
    else
    // koma üritatakse valele positsioonile toppida või ta juba olemas !!!
    if ((chkEdit.SelStart < 1) or (pos('.', cText) > 0) or (pos(',', cText) > 0)) then
      key := #0;
  end;
end;


procedure edit_verifyNumericEntry_combo(const chkCombo: TCustomComboBox; var key: char; const numericFrmt: boolean = False);
var
  cText: AStr;
begin
  // enter,tab, backspace...
  if (key in [#13, #09, #08]) then
    exit;


  cText := TCustomComboBox(chkCombo).Text;
  if (length(cText) = 1) and (cText[1] = '0') and (chkCombo.SelLength <> length(cText)) and not (key in [',', '.']) then
  begin
    key := #0;
  end
  else
  if (not numericFrmt and (key in ['.', ','])) then
    key := #0
  else
  if (not (key in ['0'..'9', '+', '-', '.', ','])) then
    key := #0
  else
  // märk tohib ainult olla esimene...ja vaid korra...
  if (key in ['+', '-']) and ((chkCombo.SelStart <> 0) or (pos('+', cText) > 0) or (pos('-', cText) > 0)) then
    key := #0
  else
  if numericFrmt and (key in ['.', ',']) then
  begin
    // peale märki ei tohi olla koma !!!
    if (chkCombo.SelStart = 1) and (length(cText) >= 1) and (cText[1] in ['+', '-']) then
      key := #0
    else
    // koma üritatakse valele positsioonile toppida või ta juba olemas !!!
    if ((chkCombo.SelStart < 1) or (pos('.', cText) > 0) or (pos(',', cText) > 0)) then
      key := #0;
  end;
end;


procedure edit_autoCompData(const chkEdit: TCustomEdit; var key: char; const dataset: TDataset; const fieldName: AStr);

var
  ppRez: boolean;
  pStat: boolean;
  tempStr: AStr;
  pEdt: TEdit;

begin
  // -------
  ppRez := Key = #08;
  if (not ppRez and (key < #32)) or (Trim(fieldName) = '') then
    exit;


  //Copy
  pEdt := chkEdit as TEdit; // TDBEdit isegi ei pahanda siin...
  with pEdt do
    if ppRez then
    begin
      TempStr := Text;
      if SelLength = 0 then
      begin
        System.Delete(TempStr, SelStart, 1);
        Text := TempStr;
        //SelStart := Length(Text);
        SelStart := length(Text);
      end
      else
      begin
        System.Delete(TempStr, SelStart + 1, SelLength);
        Text := TempStr;
        //pRealBl :=length(Text);
        SelStart := length(Text);
      end;

      key := #0;
      Exit;
    end
    else
      TempStr := ConCat(Copy(Text, 1, SelStart), Key);

  if TempStr = '' then
    Exit;




  //pStat := qryObjects.Locate('objname', TempStr, [loCaseInsensitive, loPartialKey]);
  pStat := dataset.Locate(fieldName, TempStr, [loCaseInsensitive, loPartialKey]);
  // ---
  with pEdt do
    if pStat then
    begin
      Text := dataset.FieldByName(fieldName).AsString;

      SelStart := Length(TempStr);
      SelLength := Length(Text) - SelStart;
    end;

  key := #0;
end;

{$ENDIF}



// 02.09.2009 Ingmar; postgre üks imelik asi windowsi all; ta collationid ja upper  käsud sõltuvad süsteemi vaikeseadest; tule taevas Kappi
// seoses postega vajalik
function getSysLocname(): AStr;
{$IFDEF WINDOWS}
  // LOCALE_IDEFAULTCODEPAGE
  function _readSettings(const sType: cardinal = LOCALE_IDEFAULTANSICODEPAGE): AStr;
  var
    plen: longint;
  begin
    plen := 255;
    setlength(Result, plen);
    plen := Windows.GetLocaleInfo(Windows.GetSystemDefaultLCID, sType, PChar(@Result[1]), plen);
    if plen > 0 then
      setlength(Result, plen - 1) // 0 char maha
    else
      Result := '';
  end;

{$ENDIF}
begin
  Result := '';
 {$IFDEF WINDOWS}
  Result := _readSettings(LOCALE_SENGLANGUAGE) + '_' + _readSettings(LOCALE_SCOUNTRY) + '.' + _readSettings(LOCALE_IDEFAULTANSICODEPAGE);
 {$ENDIF}
  //  ------------
end;



function allowCharForNumericInp(const key: char): boolean;
begin
  Result := ((key in [#08, #09, #13]) or (key in ['0'..'9']));
end;


{$IFNDEF NOGUI}
// teeme omal elu lihtsamaks, et suur ports controleid ära keelata ja lubada; tagidega juhine nende tegevust
procedure changeWCtrlEnabledStatus(const cmp: TWinControl; const enable: boolean = True; const tagId: longint = 0);
var
  i: integer;
  Prp: PPropInfo;
  pc: TControl;
begin

  if assigned(cmp) then
  begin
    if (cmp.Tag >= 0) and (cmp.Tag = tagId) then
      // negatiivne nr tähendab seda, et me ei soovi antud elemendi staatuse muutmist
    begin
      Prp := GetPropInfo(cmp.ClassInfo, 'Enabled');
      if assigned(Prp) then
        SetOrdProp(cmp, Prp, longint(enable));

      Prp := GetPropInfo(cmp.ClassInfo, 'Color');
      if assigned(Prp) and ( // inheritsfrom ei toimi siin 100%; uurida miks ei tööta TCustomEdit
        (cmp is TEdit) or (cmp is TCalcEdit) or (cmp is TDateEdit) or (cmp is TDbEdit) or (cmp is TMemo) or
        (cmp is TDbMemo) or (cmp is TStringGrid) or (cmp is TDbGrid) or (cmp is TComboBox) or (cmp is TDbComboBox) or
        (cmp is TListBox) or (cmp is TDBLookupComboBox) or (cmp is TRxDBLookupCombo)
        // (cmp.InheritsFrom(TDBLookupComboBox))
        ) then
        case enable of
          False: SetOrdProp(cmp, Prp, longint(cl3DLight));//SetOrdProp(cmp, Prp, longint(clBtnFace));
          True: SetOrdProp(cmp, Prp, longint(clWindow));
        end;
      // --
    end;

    for i := 0 to cmp.ControlCount - 1 do
      // ikka põhjani:)))
      if (cmp.Controls[i] is TWinControl) then
        changeWCtrlEnabledStatus((cmp.Controls[i] as TWinControl), enable, tagId);
  end;
end;


procedure changeWCtrlReadOnlyStatus(const cmp: TWinControl; const ReadOnly: boolean = False; const tagId: longint = 0);
var
  i: integer;
  Prp: PPropInfo;
  pc: TControl;
begin

  if assigned(cmp) then
  begin

    if (cmp.Tag >= 0) and (cmp.Tag = tagId) then
    begin
      // 25.01.2010 ingmar; fix:
      if (cmp is TListbox) then
        changeWCtrlEnabledStatus(cmp, not ReadOnly, tagId)
      else
      begin
        if not ((cmp is TCombobox) and (TCombobox(cmp).Style = csDropDownList)) then
        begin
          Prp := GetPropInfo(cmp.ClassInfo, 'ReadOnly');
          if assigned(Prp) then
            SetOrdProp(cmp, Prp, longint(ReadOnly));
        end;
      end; // ---
    end;

    for i := 0 to cmp.ControlCount - 1 do
      if (cmp.Controls[i] is TWinControl) then
        changeWCtrlReadOnlyStatus((cmp.Controls[i] as TWinControl), ReadOnly, tagId);
  end;
end;

procedure clearControlsWithTextValue(const cmp: TWinControl; const tagId: longint = 0);
var
  Prp: PPropInfo;
  i: integer;
begin
  if assigned(cmp) then
  begin

    if (cmp.Tag >= 0) and (cmp.Tag = tagId) then
    begin
      Prp := GetPropInfo(cmp.ClassInfo, 'Text');
      if assigned(Prp) then
        setStrProp(cmp, Prp, '');
    end;

    for i := 0 to cmp.ControlCount - 1 do
      if (cmp.Controls[i] is TWinControl) then
        clearControlsWithTextValue((cmp.Controls[i] as TWinControl), tagId);
  end;
end;

{$ENDIF}

function getDefaultCurrency: AStr;
begin
  Result := 'EUR';
end;


function isTrueVal(str: AStr): boolean;
begin
  Result := False;
  str := Trim(ansilowercase(str));
  if str <> '' then
    Result := ((str[1] = 't') or (str = '1') or (str = 'yes') or (str = 'true') or ((str = 'on')));
end;


function chgChkSum(const maxID: integer; const rows: integer): integer;
begin
  Result := (maxID xor rows shl 1);
end;

// derived from hashpjw, Dragon Book P436.
// http://list-archive.xemacs.org/xemacs-patches/200104/msg00134.html
// http://www.google.com/codesearch?hl=en&q=+hashpjw+show:143EAOXFOVk:7W1tn6b-
//i1Y:0WyDtzlEIfk&sa=N&cd=5&ct=rc&cs_p=http://www.geocities.com/ResearchTriangle/Node/9405/smoke16-20020728.tgz&cs_f=smoke16/src/hashpjw.c#a0
// ----------------------------------------------------------------------------
{
 hashpjw returns an integer by hashing the character string s */
/* hashpjw was obtained from the March 1986 edition of Compilers
   by Aho, Sethi and Ullman; the algorithm was developed
   by P. J. Weinberger for his C compiler. */
/* tested 12/31/1993 - BS */
/* filenames changed to lowercase & far pointers removed, also added
   conditional DEBUG compilation directives for debug purposes.
   compiled to object file successfully 1/21/1995 - BS */
}

(*
   h = 0;
   for ( p = instring; *p != EOS; p = p+1 ) {
      h = (h << 4) + (unsigned long int)( *p);
      if ((g = h&0xf0000000L) != 0) {
   h = h ^ (g >> 24);
   h = h ^ g;
      }
   }
*)

function hashpjw(const str: AStr): integer;
var

  hash, g, i: longint;
begin
  hash := 0;
  for i := 1 to length(str) do
  begin
    hash := (hash shl 4) + byte(str[i]);
    g := hash and $F0000000;
    if (g <> 0) then
      hash := (hash xor (g shr 24)) xor g;
  end;
  Result := hash;
end;


function trimLdZeros(const str: AStr): AStr;
begin
  Result := str;
  while length(Result) > 0 do
  begin
    if Result[1] = '0' then
      system.Delete(Result, 1, 1)
    else
      break;
  end;
end;

function isSSLProtocol(const url: AStr): boolean;
begin
  Result := pos('https://', Trim(ansilowercase(url))) = 1;
end;

// ----------------------------------------------------------------------------
// raha ümmardamise osa !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// double ka piisavalt kindel, currency muutujaga oli pigem freepascalis probleeme !!!
// ----------------------------------------------------------------------------


function roundto5Cent(const psum: double): double;
begin
  Result := round(psum * 20) / 20;
end;

function roundto10Cent(const psum: double): double;
begin
  Result := round(psum * 10) / 10;
end;

function roundto5CentUp(const psum: double): double;
begin
  Result := roundto5Cent(psum);
  if abs(Result) < abs(psum) then
  begin
    if psum > 0 then
      Result := Result + 0.05;
    if psum < 0 then
      Result := Result - 0.05;
  end;
end;


function roundto10centDown(const psum: double): double;
begin
  Result := roundto10Cent(psum);
  if abs(Result) > abs(psum) then
  begin
    if psum > 0 then
      Result := Result - 0.1;
  end;
end;

function roundToNormalMValue(const psum: double; const mode: TMoneyRoundMode): double;
begin
  case mode of
    c10centmode: Result := roundto10Cent(psum);
    c10centDown: Result := roundto10centDown(psum);
    else
      Result := roundto5Cent(psum);
  end;
end;

function _donationReqDataKey(): AStr;
const
  CPkey = #$AF#$0A#$0D#$C1;
begin
  Result := #$85 + copy(CPkey, 4, 1);
  Result := Result + #12#85#95;
  Delete(Result, length(Result), 1);
end;

end.