unit estbk_testframe;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, StdCtrls, ComCtrls,
  ExtCtrls, EditBtn, DbCtrls, Buttons, DBGrids, ZDataset, ZSqlUpdate, ZSequence,
  rxlookup, db;

type

  { TframeX }

  TframeX = class(TFrame)
  private
    { private declarations }
  public
    { public declarations }
  end; 

implementation

initialization
  {$I estbk_testframe.ctrs}

end.

