unit estbk_uivisualinit;

{$mode objfpc}{$H+}

interface

uses
  Controls,Classes,ComCtrls, SysUtils,DBCtrls,EditBtn,TypInfo,
  Dialogs,StdCtrls,ExtCtrls,DBGrids,ZDataset,ZAbstractRODataset,Db,Graphics,Forms;

// ---------------------------------------------------------------------------

type
  TUIMiscHelperClass = class
  public
    // kui mdi saab tööle, siis seda pole enam vaja !
    procedure OnTitleClick(Column: TColumn); // TDBGrid/TStringGrid/TCustomGrid
    procedure OnClickEditFocusFix(Sender : TObject); // TEdit / TMemo
    // 29.05.2011 Ingmar nüüd lookupides olemas sorteerimime
    procedure OnLookupComboTitleClick(Column: TColumn);
  end;



var
 __intUIMiscHelperClass : TUIMiscHelperClass;


 // 20.09.2009 Ingmar; fixib võimalikud lazaruse probleemid;
 // samuti tulevikus paneb tõlked paika jne jne. Palju erinevaid võimalusi
 procedure __preparevisual(const pctrl : TWincontrol);
 //procedure __fixOnClickFocusBug(const pctrl : TWincontrol);



implementation

uses estbk_settings,estbk_globvars, estbk_lib_locals,rxpopupunit, rxdbgrid, rxlookup,
  estbk_clientdatamodule, estbk_utilities;


procedure TUIMiscHelperClass.OnTitleClick(Column: TColumn);
var
 pAscSort : Boolean;
begin
  if assigned(Column) and assigned(Column.Field) and (Column.Field.DataType<>ftBoolean) then
    begin
       // meil pole eriti palju muutujaid kasutada, sest tag muutujat columnil ei ole;
       // kasutame ära "tõeväärtuse" muutujad
       pAscSort:=(Column.ValueChecked='');
    if not pAscSort then
       pAscSort:=(Column.ValueChecked='D'); // desc / järelikult tuleb teha ASC sort
       TZQuery(Column.Field.DataSet).SortedFields:=Column.FieldName;

    if pAscSort then
      begin
       Column.ValueChecked:='A';
       TZQuery(Column.Field.DataSet).SortType:=stAscending;
      end else
      begin
       Column.ValueChecked:='D';
       TZQuery(Column.Field.DataSet).SortType:=stDescending;
      end;
    end;
end;

// Loodan, et tulevikus kaob lazaruse fookuse bugi edititi puhul
// TODO porgani fix !
procedure TUIMiscHelperClass.OnClickEditFocusFix(Sender : TObject);
begin
// TODO porgand tööle saada !
{
Mouse:= TMouse.Create;
for i:= 0 to Form1.ComponentCount - 1 do
if Form1.Components[ i ] is TCustomEdit then
begin
RelPos:= Mouse.CursorPos;
RelPos.X:= RelPos.X - Form1.ClientOrigin.X;
RelPos.Y:= RelPos.Y - Form1.ClientOrigin.Y;
if ( RelPos.X > TCustomEdit(Form1.Components[ i ]).Left ) and
( RelPos.X < ( TCustomEdit(Form1.Components[ i ]).Left + TCustomEdit(Form1.Components[ i ]).Width )) and
( RelPos.Y > TCustomEdit(Form1.Components[ i ]).Top ) and
( RelPos.Y < ( TCustomEdit(Form1.Components[ i ]).Top + TCustomEdit(Form1.Components[ i ]).Height )) then
Doit( TCustomEdit(Form1.Components[ i ]) );
}

  if Sender is TDateEdit then
  with TDateEdit(Sender) do
    begin

    if Focused then
      begin
         // 15.10.2011 ingmar
         TDateEdit(Sender).SelectAll;
        {
        if Sellength>0 then
          begin
           Sellength:=0;
           SelStart:=length(TDateEdit(Sender).Text);
          end; // ---
        }
      end else
    if CanFocus then
       SetFocus;
    end else
  // ---------
  if Sender.InheritsFrom(TCustomEdit) then
  with  TCustomEdit(Sender) do
    begin

     if Focused then
       begin
         // 15.10.2011 ingmar
         TCustomEdit(Sender).SelectAll;
         {
         if Sellength>0 then
           begin
            Sellength:=0;
            SelStart:=length(TCustomEdit(Sender).Text);
           end; // ---
         }
       end else
     if Canfocus then
        SetFocus;

    end else
  // ---------
  if Sender.InheritsFrom(TCustomCombobox) then
  with TCustomCombobox(Sender) do
    begin
     if Focused then
       begin
        TCustomCombobox(Sender).SelectAll;
        // 15.10.2011 ingmar
        {
        if Sellength>0 then
          begin
           Sellength:=0;
           SelStart:=length(TCustomCombobox(Sender).Text);
          end; // ---
         }
       end else
     if CanFocus then
        SetFocus;
    end;
 //    application.MainForm.Caption:=tedit(sender).name;
end;


// lookup combo sorteerimise rutiin !
procedure TUIMiscHelperClass.OnLookupComboTitleClick(Column: TColumn);
begin
  if assigned(column.Field) and assigned(column.Field.DataSet)  then
    begin

          TZQuery(column.Field.DataSet).SortedFields:=column.FieldName;
      if (column.ValueChecked='') or (column.ValueChecked='0') then
        begin
          TZQuery(column.Field.DataSet).SortType:=stAscending;
          column.ValueChecked:='1';
        end else
        begin
          TZQuery(column.Field.DataSet).SortType:=stDescending;
          column.ValueChecked:='0';
        end;
    end;
end;

// ---------------------------------------------------------------------------


procedure __initFont(const pctrl : TWincontrol);
const
 CDefaultEditHeight  = 21;
 CDefaultComboHeight = CDefaultEditHeight;
 CDefaultLabelHeight = 14;
 CDefaultRowHeight   = 18;

var
 i,j : Integer;
 boldEnabled : Boolean;
 fontColor   : TColor;
 pFont       : TFont;
begin
     boldEnabled:=glob_userSettings.boldDataLabels;
     fontColor  :=glob_userSettings.uvc_colors[uvc_labelColors];

 // TODO
 // ntx seade, et ei luba bold: labelit;
 for i:=0 to pctrl.ComponentCount-1 do
   begin

        // if IsPublishedProp(pctrl.Components[i], 'AutoSize') then
        //   typinfo.SetOrdProp(pctrl.Components[i],'AutoSize',ord(false));

           pFont:=nil;
        if IsPublishedProp(pctrl.Components[i], 'Font') then
           pFont:=TFont(GetObjectProp(pctrl.Components[i], 'Font', TFont));


        if IsPublishedProp(pctrl.Components[i], 'AutoSelect') then
           typinfo.SetOrdProp(pctrl.Components[i],'AutoSelect',ord(true));



        if assigned(pFont) then
         begin
         if not boldEnabled and (pctrl.Components[i].Tag >= 0) then
            pFont.Style:=[];
            // !!!!!!!!!!! kui fonti pole määratud on koheselt Large font puhul paras katastroof
            pFont.Size:=8;
            pFont.Name:='Tahoma'// 'Arial';
         end;

      {
       if IsPublishedProp(pctrl.Components[i], 'Autosize') then
          typinfo.SetOrdProp(pctrl.Components[i],'Autosize',ord(true));


       // ---------------------------------------------------------------------
       // 19.02.2011 Ingmar
       // AUTOSIZE on saatanast ! Windows 7 peal kogu disain päris metsas !

       // Kõrgused käsitsi paika !
       if  pctrl.Components[i] is TDateEdit then
           TDateEdit(pctrl.Components[i]).Height:=CDefaultEditHeight
       else
       if  pctrl.Components[i] is TEdit then
           TCustomEdit(pctrl.Components[i]).Height:=CDefaultEditHeight
       else
       if  pctrl.Components[i] is TLabeledEdit then
           TLabeledEdit(pctrl.Components[i]).Height:=CDefaultEditHeight
       else
       if  pctrl.Components[i] is TCalcEdit then
           TLabeledEdit(pctrl.Components[i]).Height:=CDefaultEditHeight+1  // TCalcEditil on mingi teistsugune arusaam kõrgusest ! +2 arvatavasti button border
       else
       if  pctrl.Components[i] is TCombobox then
         begin
           TCombobox(pctrl.Components[i]).Height:=CDefaultComboHeight;
           //TCombobox(pctrl.Components[i]).ItemHeight:=13;
         end else
       if  pctrl.Components[i] is TRxDBLookupCombo then
           TRxDBLookupCombo(pctrl.Components[i]).Height:=CDefaultComboHeight
       else
       if  pctrl.Components[i] is TLabel then
           TLabel(pctrl.Components[i]).Height:=CDefaultLabelHeight
       else
       if  pctrl.Components[i] is TDBComboBox then
           TDBComboBox(pctrl.Components[i]).Height:=CDefaultComboHeight
       else
       if  pctrl.Components[i] is TDBEdit then
           TDBEdit(pctrl.Components[i]).Height:=CDefaultEditHeight
       else
       if  pctrl.Components[i] is TDBLookupComboBox then
           TDBLookupComboBox(pctrl.Components[i]).Height:=CDefaultEditHeight
       else
       if  pctrl.Components[i] is TDBGrid then
           TDBGrid(pctrl.Components[i]).DefaultRowHeight:=CDefaultRowHeight;
       }

       // ---------------------------------------------------------------------

       if  (pctrl.Components[i] is TDBGrid) then
          begin
           if not boldEnabled then
           for j:=0 to TDBGrid(pctrl.Components[i]).Columns.Count-1 do
              TDBGrid(pctrl.Components[i]).Columns.Items[j].Font.Style:=[];
          end else
       if  (pctrl.Components[i] is TPageControl) then
          begin
          if not boldEnabled then
            begin
                  TPageControl(pctrl.Components[i]).Font.Style:=[];
              for j:=0 to TPageControl(pctrl.Components[i]).PageCount-1 do
                  __initFont(TPageControl(pctrl.Components[i]).Pages[j]);
            end; // --
          end;
   end;



 // --
 for i:=0 to pctrl.ControlCount-1 do
 if  pctrl.Controls[i] is TWincontrol then
     __initFont(pctrl.Controls[i] as TWincontrol);
end;


// 20.10.2010 Ingmar; lahtrite sorteerimine grididesse !
procedure __initColSortEvents(const pctrl : TWincontrol);
var
 i : Integer;
begin
 for i:=0 to pctrl.ComponentCount-1 do
 if  (pctrl.Components[i] is TDBGrid) then
      TDBGrid(pctrl.Components[i]).OnTitleClick:=@__intUIMiscHelperClass.OnTitleClick;
 // --
 for i:=0 to pctrl.ControlCount-1 do
 if  pctrl.Controls[i] is TWincontrol then
     __initColSortEvents(pctrl.Controls[i] as TWincontrol);
end;

{
  @@15.02.2011 Ingmar Täiesti sürreaalne Lazaruse viga !!!
  Kui panna Frame ja see on Parent vormi peal ning selle parem on TPageControl, siis hiirega enam TCustomEdit komponent fookust ei võta !?!?!?!?
}

procedure __fixOnClickFocusBug(const pctrl : TWincontrol);
var
 i : Integer;
begin

 try

 for i:=0 to pctrl.ControlCount-1 do
 if (
      // miks inheritedfrom ei tööta ?!?!
     ((pctrl.Controls[i] is TCombobox) and (TCombobox(pctrl.Controls[i]).Style in [csDropDown,csSimple])) or
     (pctrl.Controls[i] is TEdit)   or
     (pctrl.Controls[i] is TLabeledEdit)   or
     (pctrl.Controls[i] is TDbEdit) or
     (pctrl.Controls[i] is TMemo)   or
     (pctrl.Controls[i] is TCalcEdit)   or
     (pctrl.Controls[i] is TDateEdit)   or
     (pctrl.Controls[i] is TDBComboBox) or
     (pctrl.Controls[i] is TDBMemo) or
     (pctrl.Controls[i] is TDBGrid) or
     (pctrl.Controls[i] is TDBEdit) or
     (pctrl.Controls[i] is TDBLookupComboBox)) then
     if not assigned(TWincontrol(pctrl.Controls[i]).OnClick) then
        TWincontrol(pctrl.Controls[i]).OnClick:=@__intUIMiscHelperClass.OnClickEditFocusFix;


//     TWincontrol(pctrl.Controls[i]).OnClick:=@__intUIMiscHelperClass.OnClickEditFocusFix;
 for i:=0 to pctrl.ControlCount-1 do
 if  pctrl.Controls[i] is TWincontrol then
     __fixOnClickFocusBug(pctrl.Controls[i] as TWincontrol);

 // ---
 except on e : exception do
 end;
end;

procedure __preparevisual(const pctrl : TWincontrol);
begin
  // 18.12.2017 Ingmar; mitme ekraani puhul läksid osa vorme valesse kohta
  if pctrl is TForm then
    forceFirstDisplay(pctrl as TForm);
  __initFont(pctrl);
  __initColSortEvents(pctrl);
  __fixOnClickFocusBug(pctrl);
  // 16.02.2011 Ingmar; mingil põhjusel W7 muudab ära datetime short format osa ?!?
  estbk_lib_locals.initDefaultLocalSettings(estbk_globvars.Cglob_DefaultCountryCodeISO3166_1);
end;

initialization
  __intUIMiscHelperClass:=TUIMiscHelperClass.Create;
finalization
  freeAndNil(__intUIMiscHelperClass);
end.
