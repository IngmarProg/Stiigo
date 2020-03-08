unit estbk_testunit;

{$mode objfpc}{$H+}
{$ASSERTIONS ON}

interface

uses
  Classes, SysUtils; 

implementation
uses estbk_utilities,dialogs;
var
 ptmp1 : double;
 ptmp2 : double;

initialization
 begin
  ptmp1:=roundToNormalMValue(4.91,c5centmode);
  ptmp2:=4.90;
  //raise exception.create(floattostr(ptmp1)+' '+floattostr(ptmp2));
  assert(ptmp1=ptmp2,'[T1]');

  ptmp1:=roundToNormalMValue(4.96,c5centmode);
  ptmp2:=4.95;
  assert(ptmp1=ptmp2,'[T2]');


  ptmp1:=roundToNormalMValue(4.99,c5centmode);
  ptmp2:=5.00;
  assert(ptmp1=ptmp2,'[T3]');

  ptmp1:=roundToNormalMValue(5.04,c5centmode);
  ptmp2:=5.05;
  assert(ptmp1=ptmp2,'[T4]');

  ptmp1:=roundToNormalMValue(5.06,c5centmode);
  ptmp2:=5.05;
  assert(ptmp1=ptmp2,'[T5]');
end;
end.

