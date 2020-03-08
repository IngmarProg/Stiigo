unit estbk_fra_template;
// 09.02.2014 Ingmar; proovime tõlked ka peale saada
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, typinfo, estbk_types, estbk_strmsg;

type
  Tfra_template = class(TFrame)
  private
  protected
  public
    constructor Create(frameOwner: TComponent); virtual;
    destructor Destroy; override;
  end;

procedure translateObject(const pObj: TComponent; const pActiveLang: AStr = '');
procedure enumAllRezStrings(const pUnitname: string; const pToStrList: TStringList);
// --
function IsWriteProp(Info: PPropInfo): boolean;
function IsReadProp(Info: PPropInfo): boolean;
function IsStoredProp(FObj: TObject; Info: PPropInfo): boolean;


implementation

uses  Grids, DBGrids, ComCtrls, Menus, Dialogs, estbk_globvars, estbk_clientdatamodule, estbk_utilities;
// gnugettext_fpc, gnugettext TODO uue FPC'ga ei tööta

type
  TTranslationHelper = class
  protected
    function useTranslationCache: boolean;
    procedure TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string; const pVsDataValue: string;
      const pWndControl: TWinControl); overload;

    procedure TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string; const pVsDataValue: string;
      const pWndComp: TComponent); overload;

    procedure TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string; const pVsDataValue: string;
      const pWndComp: TMenuItem); overload;

    procedure TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string; const pVsDataValue: string;
      const pWndComp: TColumn); overload;

    procedure TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string; const pVsDataValue: string;
      const pPropname: string; const pPropComp: TObject); overload;
    procedure Translator(obj: TObject);
    procedure TranslateObject(const pObj: TComponent; const pActiveLang: AStr = '');
  end;

var
  pTransHelper: TTranslationHelper;
  __transStrlistCache: TAStrList;
  __resStringsAlreadyTranslated: boolean = False;

function resModIterator(Name, Value: ansistring; Hash: longint; arg: pointer): ansistring;
begin
  Result := Value;
  if assigned(arg) and (trim(Value) <> '') then
    TStringList(arg).Add(Name + '=' + Value);
end;

// kui freepascal 2.6 + tuleb kasutusele, vöta otsesed apid http://www.freepascal.org/docs-html/prog/progse39.html
procedure enumAllRezStrings(const pUnitname: string; const pToStrList: TStringList);
(*
type
  PResStringRec = ^TResStringRec;
  TResStringRec = record
    DefStr: string;
    NewStr: string;
  end;

var
  Rec: TResStringRec;
*)
begin
  if pUnitname = '' then
    objpas.SetResourceStrings(@ResModIterator, pToStrList)
  else
    objpas.SetUnitResourceStrings(pUnitName, @ResModIterator, pToStrList);
end;

function ResModIterator2(Name, Value: ansistring; Hash: longint; arg: pointer): ansistring;
begin
  // Result := _(Value);
  if trim(Value) <> '' then
    Result := utf8encode(_(utf8decode((Value))))
  else
    Result := Value;
end;

procedure translateAllResourceStrings();
begin
  if not __resStringsAlreadyTranslated then
  begin
    objpas.SetUnitResourceStrings('estbk_strmsg', @ResModIterator2, nil);
    __resStringsAlreadyTranslated := True;
  end;
end;

function IsWriteProp(Info: PPropInfo): boolean;
begin
  Result := Assigned(Info) and (Info^.SetProc <> nil);
end;

function IsReadProp(Info: PPropInfo): boolean;
begin
  Result := Assigned(Info) and (Info^.GetProc <> nil);
end;

function IsStoredProp(FObj: TObject; Info: PPropInfo): boolean;
begin
  Result := Assigned(Info) and TYPINFO.IsStoredProp(FObj, Info);
end;

// 17.02.2014 Ingmar
function generateTranslationFile(var pFilename: AStr; const pDisplayError: boolean = True): boolean;
begin
  pFilename := '';
  Result := FindCmdLineSwitch('generatepofile', ['/', '\', '-'], True);
  if not Result then
    Exit;

  Result := Paramcount - 1 > 0;
  if not Result then
  begin
    if pDisplayError then
      Dialogs.messageDlg(estbk_strmsg.SEPOFilenameIsMissing, mtError, [mbOK], 0);
  end
  else
    pFilename := ParamStr(paramcount);
end;


function compareNames(List: TStringList; Index1, Index2: integer): integer;
var
  s1, s2: AStr;
begin

  s1 := (List.Names[Index1]);
  s2 := (List.Names[Index2]);
  if s1 < s2 then
    Result := -1
  else
  if s1 > s2 then
    Result := 1
  else
    Result := 0;
end;

procedure writePOFileIfRequired();

  function __fncNormalizePOStr(const poStr: AStr): AStr;
  begin
    Result := Stringreplace(poStr, '"', chr(39), [rfReplaceAll]);
    Result := Stringreplace(Result, #13#10, '\n', [rfReplaceAll]);
  end;

{
var
d1, d2: TDateTime;
begin
d1 := StrToDate(List[Index1]);
d2 := StrToDate(List[Index2]);
if d1 < d2 then
Result := -1
else if d1 > d2 then Result := 1
else
Result := 0;
end;
}
var
  pUniqStrMsg: TStringList;
  pWrittenItems: TStringList;
  i, j: integer;
  b: boolean;
  pFilename: AStr;
  pTransStr: AStr;
  pPOFile: Textfile;
begin
  // ##
{
#: soojusricheditprobleem/FDokumendiPohjaKujundamine.dfm:225
#. RichTextAken..RichEdit..Font.Name
#: soojusricheditprobleem/FRichText.dfm:25
#. RichTextAken..RichEdit_1..Font.Name
#: soojusricheditprobleem/FRichText.dfm:41
#. Form1..RVStyle1......FontName
#: soojustest/Unit1.dfm:51
#. Form1..RVStyle1......FontName
#: soojustest/Unit1.dfm:55
#. Form1..RVStyle1......FontName
#: soojustest/Unit1.dfm:61
#. Form1..RVStyle1......FontName
#: soojustest/Unit1.dfm:67
#. Form1..RVStyle1......FontName
#: soojustest/Unit1.dfm:73
#. Form1..RVStyle1......FontName
#: soojustest/Unit1.dfm:80
#. Form1..RVStyle1......FontName
#: soojustest/Unit2.dfm:61
#. Form1..RVStyle1......FontName
#: soojustest/Unit2.dfm:65
#. Form1..RVStyle1......FontName
#: soojustest/Unit2.dfm:71
#. Form1..RVStyle1......FontName
#: soojustest/Unit2.dfm:77
#. Form1..RVStyle1......FontName
#: soojustest/Unit2.dfm:83
#. Form1..RVStyle1......FontName
#: soojustest/Unit2.dfm:90
msgid "Arial"
msgstr ""
}
  try
    pUniqStrMsg := TStringList.Create;
    pWrittenItems := TStringList.Create;
    __transStrlistCache.CustomSort(@compareNames);

    for i := 0 to __transStrlistCache.Count - 1 do
      if pUniqStrMsg.indexOf(__transStrlistCache.ValueFromIndex[i]) = -1 then
        pUniqStrMsg.Add(__transStrlistCache.ValueFromIndex[i]);

    b := generateTranslationFile(pFilename);
    if b then
    begin
      assignfile(pPOFile, pFilename);
      rewrite(pPOFile);
      writeln(pPOFile, 'msgid ""');
      writeln(pPOFile, 'msgstr ""');

      writeln(pPOFile, '"Project-Id-Version: 1.2\n"');
      writeln(pPOFile, '"POT-Creation-Date: 2014-02-15 17:31\n"');
      writeln(pPOFile, '"PO-Revision-Date: 2014-02-15 17:31\n"');
      writeln(pPOFile, '"Last-Translator: Ingmar Tammeväli <stiigo@stiigo.com>\n"');
      writeln(pPOFile, '"MIME-Version: 1.0\n"');
      writeln(pPOFile, '"Content-Type: text/plain; charset=UTF-8\n"');
      writeln(pPOFile, '"Content-Transfer-Encoding: 8bit\n"');
         {$IFNDEF FINLAND}
      writeln(pPOFile, '"X-Generator: Stiigo 0.9.5\n"');
      writeln(pPOFile, '"Language: et\n"');
         {$ENDIF}
      writeln(pPOFile);


      for i := 0 to pUniqStrMsg.Count - 1 do
      begin

        pTransStr := (__fncNormalizePOStr(pUniqStrMsg.Strings[i]));
        if pWrittenItems.indexOf(trim(pTransStr)) >= 0 then
          continue;

        // 27.06.2015 Ingmar; pole mõtet numbreid ja ühemärgilist stringi tõlkida !
        if ((length(pTransStr) <= 1) or ((pTransStr[1] in ['0'..'9']) and (StrToIntdef(pTransStr, -123) <> -123))) then
          continue;

        // @@@
        for j := 0 to __transStrlistCache.Count - 1 do
        begin
          if __transStrlistCache.ValueFromIndex[j] = pUniqStrMsg.Strings[i] then
            writeln(pPOFile, '#.' + __transStrlistCache.names[j]);
        end;

        writeln(pPOFile, '#: ');
        writeln(pPOFile, format('msgid "%s"', [pTransStr]));
        writeln(pPOFile, format('msgstr "%s"', [pTransStr]));
        writeln(pPOFile);

        pWrittenItems.Add(trim(pTransStr));
      end;

      writeln(pPOFile, '#.Resources');
      pUniqStrMsg.Clear;
      enumAllRezStrings('estbk_strmsg', pUniqStrMsg);

      for i := 0 to pUniqStrMsg.Count - 1 do
      begin

        pTransStr := (__fncNormalizePOStr(pUniqStrMsg.ValueFromIndex[i]));
        if pWrittenItems.indexOf(trim(pTransStr)) >= 0 then
          continue;




        writeln(pPOFile, '#: ' + pUniqStrMsg.names[i]);
        writeln(pPOFile, format('msgid "%s"', [pTransStr]));
        writeln(pPOFile, format('msgstr "%s"', [pTransStr]));
        writeln(pPOFile);

        pWrittenItems.Add(trim(pTransStr));
      end;

      closefile(pPOFile);
    end;

    // --
    __transStrlistCache.Clear;


  finally
    pUniqStrMsg.Free;
    pWrittenItems.Free;
  end;
end;

function TTranslationHelper.useTranslationCache: boolean;
var
  b: boolean;
  dummy: AStr;
begin
  dummy := '';
  b := generateTranslationFile(dummy, False);
  Result := b;
end;


procedure TTranslationHelper.TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string;
  const pVsDataValue: string; const pWndControl: TWinControl);
begin
  // @@@
  if useTranslationCache then
  begin
    pVsData.Values[pVsDataName] := pVsDataValue;
  end;
end;

procedure TTranslationHelper.TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string;
  const pVsDataValue: string; const pWndComp: TComponent);
begin
  // @@@
  if useTranslationCache then
  begin
    pVsData.Values[pVsDataName] := pVsDataValue;
  end;
end;


procedure TTranslationHelper.TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string;
  const pVsDataValue: string; const pWndComp: TMenuItem);
begin
  // @@@
  if useTranslationCache then
  begin
    pVsData.Values[pVsDataName] := pVsDataValue;
  end
  else
  begin
    //    if not glob_active_lang_forceutf8recode then
    pWndComp.Caption := utf8encode(_(utf8decode((pVsDataValue))));
    //    else
    //       pWndComp.Caption := utf8encode(_(pVsDataValue));
  end;
end;

procedure TTranslationHelper.TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string;
  const pVsDataValue: string; const pWndComp: TColumn);
begin
  // @@@
  if useTranslationCache then
  begin
    pVsData.Values[pVsDataName] := pVsDataValue;
  end
  else
  begin
    //    if not glob_active_lang_forceutf8recode then
    pWndComp.Title.Caption := utf8encode(_(utf8decode((pVsDataValue))));
    //    else
    //       pWndComp.Title.Caption := utf8encode(_(pVsDataValue));
  end;
end;


procedure TTranslationHelper.TranslatorHelperCallback(const pVsData: TStringList; const pVsDataName: string;
  const pVsDataValue: string; const pPropname: string; const pPropComp: TObject);
begin
  // @@@
  if useTranslationCache then
  begin
    pVsData.Values[pVsDataName] := pVsDataValue;
  end
  else
  begin
    //    if not glob_active_lang_forceutf8recode then
    SetStrProp(pPropComp, pPropname, utf8encode(_(utf8decode((pVsDataValue)))));
    //else
    //       SetStrProp(pPropComp,pPropname,utf8encode(_(pVsDataValue)));
  end;
end;


procedure TTranslationHelper.Translator(obj: TObject);

  procedure __trans(const pVsData: TStringList; const parentname: string; const pWk: TWincontrol);
  var
    i: integer;
    PropList: PPropList;
    PropInfo: PPropInfo;

    UCompname: string;
    UPropName: string;

    old: WideString;
    Count, j: integer;
  begin
    for i := 0 to pWk.ComponentCount - 1 do
      if pWk.Components[i] is TMainmenu then
        for j := 0 to TMainmenu(pWk.Components[i]).Items.Count - 1 do
        begin
          UCompname := pWk.Components[i].Name;

          TranslatorHelperCallback(pVsData,
            parentname + '.' + UCompname + TMainmenu(pWk.Components[i]).Items.Items[j].Name,
            TMainmenu(pWk.Components[i]).Items.Items[j].Caption,
            TMainmenu(pWk.Components[i]).Items.Items[j]);
          // pVsData.Values[parentname + '.' + UCompname+ TMainmenu(pWk.Components[i]).Items.Items[j].name]:= TMainmenu(pWk.Components[i]).Items.Items[j].Caption;
        end;

    for i := 0 to pWk.Controlcount - 1 do
    begin

      UCompname := pWk.Controls[i].Name;
      Count := GetPropList(pWk.Controls[i], PropList);

      try
        for j := 0 to Count - 1 do
        begin
          PropInfo := PropList^[j];
          UPropName := uppercase(PropInfo^.Name);

          if (UPropName = 'HINT') or (UPropName = 'CAPTION') or (UPropName = 'TEXT') then
            case PropInfo^.PropType^.Kind of
              tkString, tkLString, tkWString
{$IFDEF FPC}
                , tkAString
{$ENDIF}
                :
              begin

                old := GetStrProp(pWk.Controls[i], UPropName);
                // pole mötet tavalise captioniga asju tölkida...
                if (old <> '') and (IsWriteProp(PropInfo)) then
                  if (pos('Button', old) = 0) and (pos('Memo', old) = 0) and (pos('LabeledEdit', old) = 0) and
                    (pos('Label', old) = 0) and (pos('Panel', old) = 0) and (pos('GroupBox', old) = 0) and
                    (pos('CheckBox', old) = 0) and (old <> '-') and (old <> '...') and (old <> '---') then















                  begin
                    // pVsData.Values[parentname + '.' + UCompname]:= old;
                    TranslatorHelperCallback(pVsData,
                      parentname + '.' + UCompname,
                      old,
                      UPropName,
                      pWk.Controls[i]);

                  end;

              end;
            end;
        end;

      finally
        FreeMem(PropList);
      end;


      // 18.02.2014 Ingmar
      if pWk.Controls[i] is TDBGrid then
        with TDBGrid(pWk.Controls[i]).Columns do
          for j := 0 to Count - 1 do
            if Items[j].Title.Caption <> '' then
            begin
              TranslatorHelperCallback(pVsData,
                parentname + '.' + UCompname + '.column' + IntToStr(j),
                Items[j].Title.Caption,
                Items[j]);
              // pVsData.Values[parentname + '.' + UCompname+'.column'+inttostr(j)]:= Items[j].Title.Caption;
            end;


      if (pWk.Controls[i] is TStringGrid) and (TStringGrid(pWk.Controls[i]).FixedRows = 1) then
        with TStringGrid(pWk.Controls[i]) do
          for j := 0 to ColCount - 1 do
            if trim(Cells[j, 0]) <> '' then
            begin
              pVsData.Values[parentname + '.' + UCompname + '.column' + IntToStr(j)] := Cells[j, 0];
            end;

      if (pWk.Controls[i] is TPageControl) then
        with TPageControl(pWk.Controls[i]) do
          for j := 0 to PageCount - 1 do
          begin
            //pVsData.Values[parentname + '.' + UCompname+'.tab.'+Pages[j].name]:= Pages[j].Caption;
            TranslatorHelperCallback(pVsData,
              parentname + '.' + UCompname + '.tab.' + Pages[j].Name,
              Pages[j].Caption,
              Pages[j]);
            __trans(pVsData, parentname + '.' + UCompname + '.tab.' + Pages[j].Name, Pages[j]);

          end;

      if pWk.Controls[i] is TWinControl then
        __trans(pVsData, parentname + '.' + UCompname, pWk.Controls[i] as TWinControl);

    end;
  end;

var
  i: integer;
  pStrlist: TStringList;
begin

  //  if not generateTranslationFile(pDummy) then
  //     Exit;


  try
    pStrlist := TStringList.Create;

    if (obj is twincontrol) then
    begin
      if (obj is TForm) then
      begin
        __trans(pStrlist, TForm(obj).Name, TForm(obj));
      end
      else
      if (obj is TFrame) then
      begin
        __trans(pStrlist, TFrame(obj).Name, TForm(obj));
      end;
    end;



    // kopeerida vaid need elemendid uuesti, mida veel siin nimistus pole !
    for i := 0 to pStrlist.Count - 1 do
      if __transStrlistCache.IndexOfName(pStrlist.Names[i]) = -1 then
        __transStrlistCache.Add(pStrlist.Strings[i]);


  finally
    FreeAndNil(pStrlist);
  end;
  // --
end;


procedure TTranslationHelper.TranslateObject(const pObj: TComponent; const pActiveLang: AStr = '');
var
  pUseLang: AStr;

begin
  //  pActiveLang:= trim(estbk_clientdatamodule.dmodule.userStsValues[Csts_active_language]);
  pUseLang := pActiveLang;
  if pUseLang = '' then
    pUseLang := estbk_globvars.glob_active_language
  else
    estbk_globvars.glob_active_language := pUseLang;
  // @@@
  //UseLanguage(estbk_globvars.glob_active_language+'_'+ansiuppercase(estbk_globvars.glob_active_language));
  UseLanguage(pUseLang);
  TranslateComponent(pObj);

  //  TranslateAllResourceStrings();
(*
UseLanguage('de_DE');
TranslateComponent(self);
//gnugettext.TranslateComponent(self,'plurals');
ShowMessage(_('Thank you for clicking this button'));
*)

end;

constructor Tfra_template.Create(frameOwner: TComponent);
begin
  inherited Create(frameOwner);
  TranslateObject(Self);
end;

destructor Tfra_template.Destroy;
begin
  inherited Destroy;
end;

procedure translateObject(const pObj: TComponent; const pActiveLang: AStr = '');
begin
  pTransHelper.TranslateObject(pObj, pActiveLang);
  translateAllResourceStrings();
end;

initialization
  {$I estbk_fra_template.ctrs}
  pTransHelper := TTranslationHelper.Create;

  __transStrlistCache := TAStrList.Create;
  // TODO taastada tõlked
  // TP_GlobalHandleClass(TForm, @pTransHelper.translator);
  // TP_GlobalHandleClass(TFrame, @pTransHelper.translator);

finalization
  FreeAndNil(pTransHelper);

  writePOFileIfRequired();
  FreeAndNil(__transStrlistCache);
end.
