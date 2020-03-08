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


procedure DrawRotateText(Canvas: TCanvas; const R: TRect; const Text: String; RotateType: TRotateType);
// procedure performFadeIn(const ABitMap: TBitMap);
procedure GradHorizontal(Canvas:TCanvas; Rect:TRect; FromColor, ToColor:TColor) ;
procedure GradVertical(Canvas:TCanvas; Rect:TRect; FromColor, ToColor:TColor) ;


implementation
uses math;
{
//horizontal gradient from RED to BLUE
  GradHorizontal(PaintBox1.Canvas, PaintBox1.ClientRect, clRed, clBlue) ;

  PaintBox1.Canvas.Brush.Style := bsClear;
  PaintBox1.Canvas.TextOut(5,10,'Transparent text') ;
}

procedure DrawRotateText(Canvas: TCanvas; const R: TRect;
  const Text: String; RotateType: TRotateType);
var
  TextExtent: TSize;
  SavedOrientation: Integer;
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


procedure GradHorizontal(Canvas:TCanvas; Rect:TRect; FromColor, ToColor:TColor) ;
 var
   X:integer;
   dr,dg,db:Extended;
   C1,C2:TColor;
   r1,r2,g1,g2,b1,b2:Byte;
   R,G,B:Byte;
   cnt:integer;
 begin
   C1 := FromColor;
   R1 := GetRValue(C1) ;
   G1 := GetGValue(C1) ;
   B1 := GetBValue(C1) ;

   C2 := ToColor;
   R2 := GetRValue(C2) ;
   G2 := GetGValue(C2) ;
   B2 := GetBValue(C2) ;

   dr := (R2-R1) / Rect.Right-Rect.Left;
   dg := (G2-G1) / Rect.Right-Rect.Left;
   db := (B2-B1) / Rect.Right-Rect.Left;

   cnt := 0;
   for X := Rect.Left to Rect.Right-1 do
   begin
     R := R1+Ceil(dr*cnt) ;
     G := G1+Ceil(dg*cnt) ;
     B := B1+Ceil(db*cnt) ;

     Canvas.Pen.Color := RGB(R,G,B) ;
     Canvas.MoveTo(X,Rect.Top) ;
     Canvas.LineTo(X,Rect.Bottom) ;
     inc(cnt) ;
   end;
 end;

 procedure GradVertical(Canvas:TCanvas; Rect:TRect; FromColor, ToColor:TColor) ;
 var
   Y:integer;
   dr,dg,db:Extended;
   C1,C2:TColor;
   r1,r2,g1,g2,b1,b2:Byte;
   R,G,B:Byte;
   cnt:Integer;
 begin
    C1 := FromColor;
    R1 := GetRValue(C1) ;
    G1 := GetGValue(C1) ;
    B1 := GetBValue(C1) ;

    C2 := ToColor;
    R2 := GetRValue(C2) ;
    G2 := GetGValue(C2) ;
    B2 := GetBValue(C2) ;

    dr := (R2-R1) / Rect.Bottom-Rect.Top;
    dg := (G2-G1) / Rect.Bottom-Rect.Top;
    db := (B2-B1) / Rect.Bottom-Rect.Top;

    cnt := 0;
    for Y := Rect.Top to Rect.Bottom-1 do
    begin
       R := R1+Ceil(dr*cnt) ;
       G := G1+Ceil(dg*cnt) ;
       B := B1+Ceil(db*cnt) ;

       Canvas.Pen.Color := RGB(R,G,B) ;
       Canvas.MoveTo(Rect.Left,Y) ;
       Canvas.LineTo(Rect.Right,Y) ;
       Inc(cnt) ;
    end;
 end;

// http://www.efg2.com/Lab/Graphics/Colors/HSV.htm


{
 procedure performFadeIn(const ABitMap: TBitMap);
 var
   SrcIntfImg, TempIntfImg: TLazIntfImage;
   ImgHandle,ImgMaskHandle: HBitmap;
   FadeStep: Integer;
   px, py: Integer;
   CurColor: TFPColor;
   TempBitmap: TBitmap;
 begin
   SrcIntfImg:=TLazIntfImage.Create(0,0);
   SrcIntfImg.LoadFromBitmap(ABitmap.Handle,ABitmap.MaskHandle);
   TempIntfImg:=TLazIntfImage.Create(0,0);
   TempIntfImg.LoadFromBitmap(ABitmap.Handle,ABitmap.MaskHandle);
   TempBitmap:=TBitmap.Create;
   for FadeStep:=1 to 32 do begin
     for py:=0 to SrcIntfImg.Height-1 do begin
       for px:=0 to SrcIntfImg.Width-1 do begin
         CurColor:=SrcIntfImg.Colors[px,py];
         CurColor.Red:=(CurColor.Red*FadeStep) shr 5;
         CurColor.Green:=(CurColor.Green*FadeStep) shr 5;
         CurColor.Blue:=(CurColor.Blue*FadeStep) shr 5;
         TempIntfImg.Colors[px,py]:=CurColor;
       end;
     end;
     TempIntfImg.CreateBitmaps(ImgHandle,ImgMaskHandle,false);
     TempBitmap.Handle:=ImgHandle;
     TempBitmap.MaskHandle:=ImgMaskHandle;
     Canvas.Draw(0,0,TempBitmap);
   end;
   SrcIntfImg.Free;
   TempIntfImg.Free;
   TempBitmap.Free;
 end;
}
{
 Since Lazarus 0.9.16 you can use LCL to take screenshots of the screen on a cross-platform way.
 The following example code does it (works on gtk2 and win32, but not gtk1 currently):

  uses LCLIntf, LCLType;

  ...

var
  MyBitmap: TBitmap;
  ScreenDC: HDC;
begin
  MyBitmap := TBitmap.Create;
  ScreenDC := GetDC(0);
  MyBitmap.LoadFromDevice(ScreenDC);
  ReleaseDC(ScreenDC);

  ...
}

{

 procedure RotateBitmap(aSource,aDest:Graphics.TBitmap; aAngle:double; aAxis,aOffset:TPoint);
 var
   x            :integer;
   xDest        :integer;
   xOriginal    :integer;
   xPrime       :integer;
   xPrimeRotated:integer;
   //
   y            :integer;
   yDest        :integer;
   yOriginal    :integer;
   yPrime       :integer;
   yPrimeRotated:integer;
   //
   Radians      :double;
   RadiansCos   :double;
   RadiansSin   :double;
   NormalImg    :TLazIntfImage;
   RotateImg    :TLazIntfImage;
   aDestHandle  : HBITMAP;
   aDestMaskHandle: HBITMAP;
 begin
   // create intermediary images
   NormalImg := TLazIntfImage.Create(0, 0);
   NormalImg.LoadFromBitmap(aSource.Handle, aSource.MaskHandle);

   RotateImg := TLazIntfImage.Create(0, 0);
   RotateImg.LoadFromBitmap(aDest.Handle, aDest.MaskHandle);

   // Convert degrees to radians. Use minus sign to force clockwise rotation.
   Radians   :=aAngle*PI/180;
   RadiansSin:=sin(Radians);
   RadiansCos:=cos(Radians);
   // Step through each row of rotated image.
   for y:=0 to aDest.Height-1 do
   begin
     yDest  :=y-aOffset.y;
     yPrime :=2*(yDest-aAxis.y)+1; // center y: -1,0,+1
     // Step through each col of rotated image.
     for x:=0 to aDest.Width-1 do
     begin
       xDest :=x-aOffset.x;
       xPrime:=2*(xDest-aAxis.x)+1; // center x: -1,0,+1
       // Rotate (xPrime, yPrime) to location of desired pixel
       // Note:  There is negligible difference between floating point and scaled integer arithmetic here, so keep the math simple (and readable).
       xPrimeRotated:=round(xPrime*RadiansCos-yPrime*RadiansSin);
       yPrimeRotated:=round(xPrime*RadiansSin+yPrime*RadiansCos);
       // Transform back to pixel coordinates of image, including translation
       // of origin from axis of rotation to origin of image.
       xOriginal:=(xPrimeRotated-1) div 2+aAxis.x;
       yOriginal:=(yPrimeRotated-1) div 2+aAxis.y;
       // Make sure (xOriginal, yOriginal) is in aSource.  If not, assign blue color to corner points.
       if (xOriginal>=0) and (xOriginal<=aSource.Width-1) and (yOriginal>=0) and (yOriginal<=aSource.Height-1) then
       begin
         // Assign pixel from rotated space to current pixel in aDest
         RotateImg.Colors[x,y]:=NormalImg.Colors[xOriginal,yOriginal];
       end
       else if aSource.Height>0 then
       begin
         RotateImg.Colors[x,y]:=NormalImg.Colors[0,0];
       end
       else
         RotateImg.Colors[x,y]:=TColorToFPColor(clBlack);
     end;
   end;
   RotateImg.CreateBitmaps(aDestHandle, aDestMaskHandle);
   aDest.Handle:=aDestHandle;
   aDest.MaskHandle:=aDestMaskHandle;
   RotateImg.Destroy;
   NormalImg.Destroy;
 end;
 }

end.

