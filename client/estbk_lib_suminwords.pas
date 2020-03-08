unit estbk_lib_suminWords;

{$mode objfpc}{$H+}
// minu üks vana kood :)))


interface

uses
  Classes, SysUtils, estbk_types;

type
  TSuminWords_Base = class(TPersistent)
  public
    class function sumInWords(const Arvud: double): AStr; virtual; abstract;
  end;


type
  TSuminWords_EST = class(TSuminWords_Base)
  protected
    class function Sendid(Fract: AStr): AStr;
    class function Nr(Ints: AStr): Word;
    class function NullideArv(Ints: AStr): Word;
    class function Nullid(Ints: AStr; Start, Finish: Word): AStr;
    class function YtleSajaTuhandelisedArvud(const Kokku: AStr): AStr;
    class function YtleKumneTuhandelisedArvud(const Kokku: AStr): AStr;
    class function YtleTuhandelisedArvud(const Kokku: AStr): AStr;
    class function YtleSajalisedArvud(const Kokku: AStr): AStr;
    class function YtleKumnedArvud(Ints: AStr; Index: Word): AStr;
    class function MiljoniteAbimees(const Kokku: AStr): AStr;
  public
    // class function ArvudSonadega(Const Arvud : Double):AStr;
    class function sumInWords(const Arvud: double): AStr; override;
  end;


implementation
// Ingmar
// Viimati muudetud: 30.11.2001

const
  Tuhik = ' ';
  Tuhi = '';
  Uksikud: array[0..9] of AStr = ('null', 'üks', 'kaks', 'kolm', 'neli', 'viis', 'kuus', 'seitse', 'kaheksa', 'üheksa');
  Jargud: array[1..4] of AStr = ('kümmend ', 'sada', 'tuhat', 'miljon');
  Kumme = 'kümme';
  Senti = ' senti ';
  Teist = 'teist';
  //Krooni  = ' krooni';
  Eurot = ' eurot';

class function TSuminWords_EST.Sendid(Fract: AStr): AStr;
begin
  if Fract = '0' then
    Result := Tuhi
  else
    Result := Fract + Senti;
end;

class function TSuminWords_EST.Nr(Ints: AStr): Word;
begin
  Result := StrToInt(Ints);
end;

class function TSuminWords_EST.NullideArv(Ints: AStr): Word;
var
  Pikkus: Word;
  Kordus: Word;
  Nulle: Word;
begin
  Result := 0;
  Nulle := 0;
  Pikkus := Length(Ints);
  for Kordus := 2 to Pikkus do
    if Ints[Kordus] = '0' then
      Inc(Nulle);
  if Pikkus - 1 = Nulle then
    Result := Nulle
  else
    Result := 0;
end;

class function TSuminWords_EST.Nullid(Ints: AStr; Start, Finish: Word): AStr;
var
  Edasta: AStr;
  Kordus: Word;
begin
  for Kordus := Start to Finish do
    Edasta := Edasta + Ints[Kordus];
  Ints := Edasta;
  Edasta := Tuhi;
  case NullideArv(Ints) of
    2: if Ints[1] = '1' then
        Edasta := Jargud[2]
      else
        Edasta := Tuhik + Uksikud[Nr(Ints[1])] + Jargud[2] + Tuhik;
    3: Edasta := Tuhik + Uksikud[Nr(Ints[1])] + Tuhik + Jargud[3] + Tuhik;
    4: if Ints[1] = '1' then
        Edasta := Kumme + Tuhik + Jargud[3] + Tuhik
      else
        Edasta := Uksikud[Nr(Ints[1])] + Jargud[1] + Tuhik + Jargud[3] + Tuhik;
    5: if Ints[1] = '1' then
        Edasta := Jargud[2] + Tuhik + Jargud[3] + Tuhik
      else
        Edasta := Uksikud[Nr(Ints[1])] + Jargud[2] + Tuhik + Jargud[3] + Tuhik;
    6: if Ints[1] = '1' then
        Edasta := Uksikud[Nr(Ints[1])] + Tuhik + Jargud[4] + Tuhik
      else
        Edasta := Uksikud[Nr(Ints[1])] + Tuhik + Jargud[4] + 'it' + Tuhik;
    else
      Edasta := Tuhi;
  end;
  Result := Edasta;
end;


class function TSuminWords_EST.YtleSajaTuhandelisedArvud(const Kokku: AStr): AStr;
begin
  Result := Uksikud[Nr(Kokku[1])] + Jargud[2] + Tuhik;
  Result := Result + YtleKumnedArvud(Kokku, 2) + Tuhik + Jargud[3] + Tuhik;
  if Nr(Kokku[4]) <> 0 then
    Result := Result + Uksikud[Nr(Kokku[4])] + Jargud[2] + Tuhik;
  Result := Result + YtleKumnedArvud(Kokku, 5);
end;

class function TSuminWords_EST.YtleKumneTuhandelisedArvud(const Kokku: AStr): AStr;
begin
  Result := YtleKumnedArvud(Kokku, 1) + Tuhik + Jargud[3] + Tuhik;
  if Nr(Kokku[3]) <> 0 then
    Result := Result + Uksikud[Nr(Kokku[3])] + Jargud[2];
  Result := Result + Tuhik + YtleKumnedArvud(Kokku, 4);
end;

class function TSuminWords_EST.YtleTuhandelisedArvud(const Kokku: AStr): AStr;
begin
  Result := Uksikud[Nr(Kokku[1])] + Tuhik + Jargud[3] + Tuhik;
  if Nr(Kokku[2]) <> 0 then
    Result := Result + Uksikud[Nr(Kokku[2])] + Jargud[2] + Tuhik;
  Result := Result + YtleKumnedArvud(Kokku, 3);
end;

class function TSuminWords_EST.YtleSajalisedArvud(const Kokku: AStr): AStr;
begin
  Result := Uksikud[Nr(Kokku[1])] + Jargud[2] + Tuhik;
  Result := Result + YtleKumnedArvud(Kokku, 2);
end;

class function TSuminWords_EST.YtleKumnedArvud(Ints: AStr; Index: Word): AStr;
var
  Kokku: AStr;
begin
  if Ints[Index] + Ints[Index + 1] = '00' then
    Kokku := Tuhi
  else
  if (Nr(Ints[Index]) = 0) and (Nr(Ints[Index + 1]) <> 0) then
    Kokku := Uksikud[StrToInt(Ints[Index + 1])]
  else
  if Ints[Index] + Ints[Index + 1] = '10' then
    Kokku := Kumme
  else
  if Nr(Ints[Index]) = 1 then
    Kokku := Uksikud[Nr(Ints[Index + 1])] + Teist
  else
  if Nr(Ints[Index + 1]) = 0 then
    Kokku := Uksikud[Nr(Ints[Index])] + Jargud[1]
  else
    Kokku := Uksikud[Nr(Ints[Index])] + Jargud[1] + Tuhik + Uksikud[Nr(Ints[Index + 1])];
  Result := Kokku;
end;

class function TSuminWords_EST.MiljoniteAbimees(const Kokku: AStr): AStr;
begin
  Result := '';
  if Nr(Kokku[1]) <> 0 then
    Result := YtleSajaTuhandelisedArvud(Kokku)
  else
  if Nr(Kokku[2]) <> 0 then
    Result := YtleKumneTuhandelisedArvud(Copy(Kokku, 2, Length(Kokku)))
  else
  if Nr(Kokku[3]) <> 0 then
    Result := YtleTuhandelisedArvud(Copy(Kokku, 3, Length(Kokku)))
  else
  if Nr(Kokku[4]) <> 0 then
    Result := YtleSajalisedArvud(Copy(Kokku, 4, Length(Kokku)))
  else
  if Nr(Kokku[5]) <> 0 then
    Result := YtleKumnedArvud(Kokku, 5)
  else
  if Nr(Kokku[6]) <> 0 then
    Result := Uksikud[StrToInt(Kokku[Length(Kokku)])];
end;

class function TSuminWords_EST.sumInWords(const Arvud: double): AStr;
var
  Kokku: AStr;
  Ints: AStr;
  Fract: AStr;
  IntArv: integer;
begin
  Result := '';
  try
    IntArv := Round(Int(Arvud));
    Ints := IntToStr(Abs(IntArv));
    Fract := IntToStr(Abs(Round(Frac(Arvud) * 100)));
    if Length(Nullid(Ints, 1, Length(Ints))) <> 0 then
      Kokku := Nullid(Ints, 1, Length(Ints))
    else
      case Length(Ints) of
        // *******************************************************************
        1: if Nr(Ints) = 1 then
            Kokku := Uksikud[Nr(Ints)]
          else
            Kokku := Uksikud[Nr(Ints)];
        // *******************************************************************
        2: Kokku := YtleKumnedArvud(Ints, 1);
        // *******************************************************************
        3: Kokku := YtleSajalisedArvud(Ints);
        // *******************************************************************
        4: Kokku := YtleTuhandelisedArvud(Ints);
        // *******************************************************************
        5: Kokku := YtleKumneTuhandelisedArvud(Ints);
        // *******************************************************************
        6: Kokku := YtleSajaTuhandelisedArvud(Ints);
        // *******************************************************************
        7:
        begin
          if Nr(Ints[1]) = 1 then
            Kokku := Uksikud[Nr(Ints[1])] + Tuhik + Jargud[4] + Tuhik
          else
            Kokku := Uksikud[Nr(Ints[1])] + Tuhik + Jargud[4] + 'it' + Tuhik;
          Kokku := Kokku + MiljoniteAbimees(Copy(Ints, 2, Length(Kokku) - 1));
        end;
        // *******************************************************************
        8:
        begin
          Kokku := YtleKumnedArvud(Ints, 1) + Tuhik + Jargud[4] + 'it' + Tuhik;
          Kokku := Kokku + MiljoniteAbimees(Copy(Ints, 3, Length(Kokku) - 2));
        end;
        // *******************************************************************
        // 27.09.2000
        9:
        begin
          Kokku := Kokku + Uksikud[Nr(Ints[1])] + Jargud[2] + Tuhik + YtleKumnedArvud(Ints, 2) + Tuhik + Jargud[4] + 'it' + Tuhik;
          Kokku := Kokku + MiljoniteAbimees(Copy(Ints, 4, Length(Kokku) - 3));
        end
        else
        begin
          Kokku := '';
          Exit;
        end;
      end;
    Kokku := Trim(Kokku + eurot + Tuhik + Sendid(Fract));
    Result := Kokku;
    // *** 30.11.2001
    if (IntArv < 0) then
      Result := 'miinus' + Tuhik + Result
{
Else
  Begin
  If Result[1]='ü' Then
     Result[1]:='Ü'
  Else
     Result[1]:=UpCase(Result[1]);
  End; }
  except
  end;
end;

initialization
  RegisterClass(TSuminWords_EST);
end.
