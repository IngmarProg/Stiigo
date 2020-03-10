unit estbk_lib_grapheffects;

{$mode objfpc}{$H+}

interface

// tänud wikile ja lazarusele
// http://wiki.lazarus.freepascal.org/Developing_with_Graphics#A_fading_example
uses
  Classes,
  Types,
  SysUtils,
  Graphics,
  LclIntf,
  LCLType, // HBitmap type
  IntfGraphics, // TLazIntfImage type
  fpImage; // TFPColor type

type
  TRotateType = (rtNone, rtCounterClockWise, rtClockWise, rtFlip);


procedure DrawRotateText(Canvas: TCanvas; const R: TRect; const Text: string; RotateType: TRotateType);
// procedure performFadeIn(const ABitMap: TBitMap);
procedure GradHorizontal(Canvas: TCanvas; Rect: TRect; FromColor, ToColor: TColor);
procedure GradVertical(Canvas: TCanvas; Rect: TRect; FromColor, ToColor: TColor);


implementation

uses Math;

{
//horizontal gradient from RED to BLUE
  GradHorizontal(PaintBox1.Canvas, PaintBox1.ClientRect, clRed, clBlue) ;

  PaintBox1.Canvas.Brush.Style := bsClear;
  PaintBox1.Canvas.TextOut(5,10,'Transparent text') ;
}

procedure DrawRotateText(Canvas: TCanvas; const R: TRect; const Text: string; RotateType: TRotateType);
var
  TextExtent: TSize;
  SavedOrientation: integer;
begin
  SavedOrientation := Canvas.Font.Orientation;
  TextExtent := Canvas.TextExtent(Text);
  case RotateType of
    rtNone:
    begin
      Canvas.Font.Orientation := 0;
      Canvas.TextOut((R.Right - R.Left - TextExtent.cx) div 2,
        (R.Bottom - R.Left - TextExtent.cy) div 2, Text);
    end;
    rtCounterClockWise:
    begin
      Canvas.Font.Orientation := 900;
      Canvas.TextOut((R.Right - R.Left - TextExtent.cy) div 2,
        (R.Bottom - R.Left + TextExtent.cx) div 2, Text);
    end;
    rtFlip:
    begin
      Canvas.Font.Orientation := 1800;
      Canvas.TextOut((R.Right - R.Left + TextExtent.cx) div 2,
        (R.Bottom - R.Left + TextExtent.cy) div 2, Text);
    end;
    rtClockWise:
    begin
      Canvas.Font.Orientation := -900;
      Canvas.TextOut((R.Right - R.Left + TextExtent.cy) div 2,
        (R.Bottom - R.Left - TextExtent.cx) div 2, Text);
    end;
  end;
  Canvas.Font.Orientation := SavedOrientation;
end;


procedure GradHorizontal(Canvas: TCanvas; Rect: TRect; FromColor, ToColor: TColor);
var
  X: integer;
  dr, dg, db: extended;
  C1, C2: TColor;
  r1, r2, g1, g2, b1, b2: byte;
  R, G, B: byte;
  cnt: integer;
begin
  C1 := FromColor;
  R1 := GetRValue(C1);
  G1 := GetGValue(C1);
  B1 := GetBValue(C1);

  C2 := ToColor;
  R2 := GetRValue(C2);
  G2 := GetGValue(C2);
  B2 := GetBValue(C2);

  dr := (R2 - R1) / Rect.Right - Rect.Left;
  dg := (G2 - G1) / Rect.Right - Rect.Left;
  db := (B2 - B1) / Rect.Right - Rect.Left;

  cnt := 0;
  for X := Rect.Left to Rect.Right - 1 do
  begin
    R := R1 + Ceil(dr * cnt);
    G := G1 + Ceil(dg * cnt);
    B := B1 + Ceil(db * cnt);

    Canvas.Pen.Color := RGB(R, G, B);
    Canvas.MoveTo(X, Rect.Top);
    Canvas.LineTo(X, Rect.Bottom);
    Inc(cnt);
  end;
end;

procedure GradVertical(Canvas: TCanvas; Rect: TRect; FromColor, ToColor: TColor);
var
  Y: integer;
  dr, dg, db: extended;
  C1, C2: TColor;
  r1, r2, g1, g2, b1, b2: byte;
  R, G, B: byte;
  cnt: integer;
begin
  C1 := FromColor;
  R1 := GetRValue(C1);
  G1 := GetGValue(C1);
  B1 := GetBValue(C1);

  C2 := ToColor;
  R2 := GetRValue(C2);
  G2 := GetGValue(C2);
  B2 := GetBValue(C2);

  dr := (R2 - R1) / Rect.Bottom - Rect.Top;
  dg := (G2 - G1) / Rect.Bottom - Rect.Top;
  db := (B2 - B1) / Rect.Bottom - Rect.Top;

  cnt := 0;
  for Y := Rect.Top to Rect.Bottom - 1 do
  begin
    R := R1 + Ceil(dr * cnt);
    G := G1 + Ceil(dg * cnt);
    B := B1 + Ceil(db * cnt);

    Canvas.Pen.Color := RGB(R, G, B);
    Canvas.MoveTo(Rect.Left, Y);
    Canvas.LineTo(Rect.Right, Y);
    Inc(cnt);
  end;
end;

// http://www.efg2.com/Lab/Graphics/Colors/HSV.htm
end.
