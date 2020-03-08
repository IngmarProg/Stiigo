unit estbk_uivisualinitadmin;

{$mode objfpc}{$H+}

interface

uses
  Controls,Classes,ComCtrls, SysUtils,DBCtrls,EditBtn,TypInfo;


procedure __preparevisual(const pctrl : TWincontrol);


implementation

uses dialogs,StdCtrls,ExtCtrls,DBGrids,ZDataset,ZAbstractRODataset,Db,Graphics,Forms,estbk_globvars,estbk_lib_locals;




procedure __initFont(const pctrl : TWincontrol);
var
 i,j : Integer;
 boldEnabled : Boolean;
 fontColor   : TColor;
 pFont       : TFont;
begin
     boldEnabled:=false;
     fontColor  :=clDefault;

 // TODO
 // ntx seade, et ei luba bold: labelit;
 for i:=0 to pctrl.ComponentCount-1 do
   begin

        if IsPublishedProp(pctrl.Components[i], 'AutoSize') then
           typinfo.SetOrdProp(pctrl.Components[i],'AutoSize',ord(false));

           pFont:=nil;
        if IsPublishedProp(pctrl.Components[i], 'Font') then
           pFont:=TFont(GetObjectProp(pctrl.Components[i], 'Font', TFont));


        if IsPublishedProp(pctrl.Components[i], 'AutoSelect') then
           typinfo.SetOrdProp(pctrl.Components[i],'AutoSelect',ord(true));



        if assigned(pFont) then
         begin
         if not boldEnabled and (pctrl.Components[i].Tag>=0) then
            pFont.Style:=[];
            // !!!!!!!!!!! kui fonti pole mĆ¤Ć¤ratud on koheselt Large font puhul paras katastroof
            pFont.Size:=8;
            pFont.Name:='Tahoma'// 'Arial';
         end;

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


// tulevikus tõmbab ka tõlked peale !
procedure __preparevisual(const pctrl : TWincontrol);
begin
  __initFont(pctrl);
end;

end.

