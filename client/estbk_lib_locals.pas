unit estbk_lib_locals;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, estbk_types;

// 17.09.2009 Ingmar; hetkel toetame eestit
procedure initDefaultLocalSettings(const countryCode: AStr = CDefaultCountry);

implementation

uses estbk_globvars, FileUtil;

procedure initDefaultLocalSettings(const countryCode: AStr = CDefaultCountry);
begin
  if countryCode = 'EST' then // vana hea kodumaa
  begin
    // 19.09.2009 Ingmar; need lokaalsed seaded peaks overridema ?
    // http://www.delphibasics.co.uk/RTL.asp?Name=NegCurrFormat
    SysUtils.NegCurrFormat := 8; // ?8 = -1.23 ?
    SysUtils.DecimalSeparator := ',';
    // http://www.delphibasics.co.uk/RTL.asp?Name=CurrencyFormat
    SysUtils.CurrencyFormat := 3; //  Format 3 = 12 ?
    //SysUtils.ThousandSeparator:=' ';
    SysUtils.ThousandSeparator := ' '; //#$C2 #$A0; //systoutf8(#32);
    SysUtils.ShortDateFormat := 'dd.mm.yyyy';
    SysUtils.LongTimeFormat := SysUtils.ShortDateFormat;
    SysUtils.DateSeparator := '.';

    SysUtils.CurrencyString := estbk_globvars.glob_baseCurrency; // estbk_globvars.glob_baseCurrencyShortname; ohutum nime mitte kuvada

  end;
end;

end.
