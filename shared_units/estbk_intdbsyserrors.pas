unit estbk_intdbsyserrors;

{$mode objfpc}

interface

uses
  Classes, SysUtils;

// moodul, mis kirjeldab ntx süsteemsed vead; mingi kontrolltrigger viskab vea;
// hetkel triggereid vähe, aga tulevikus serveri protseruurid, mida iganes

const
  CPrefix = 'ERR:';
  // ---
  CDbError_unknown = CPrefix + '-1'; // tundmatu viga
  CDbError_negartcount = CPrefix + '1'; // artiklite summa muutus negatiivseks



implementation

end.
