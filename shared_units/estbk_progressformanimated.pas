unit estbk_progressformanimated;

{$mode objfpc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls; // AnimatedGif MemBitmap

type

  TformAnimatedProgress = class(TForm)
    Label1: TLabel;
    pAnimatedGif: TImage;
    repaintTimer: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure repaintTimerTimer(Sender: TObject);
  private
  public
  end;

var
  formAnimatedProgress: TformAnimatedProgress;

implementation

uses estbk_types;

procedure TformAnimatedProgress.FormShow(Sender: TObject);
const
  CPImgPath = 'progress.gif';
begin
  //pAnimatedGif.Picture.LoadFromFile('C:\LIBS\animatedgif\testgif\gif\Animaux-0.gif');
  if fileExists(CPImgPath) then
    try
      pAnimatedGif.Picture.LoadFromFile(CPImgPath);
    except
    end;
end;

procedure TformAnimatedProgress.FormCreate(Sender: TObject);
begin
  self.Color := estbk_types.MyFavGray;

end;

procedure TformAnimatedProgress.repaintTimerTimer(Sender: TObject);
begin
  pAnimatedGif.Invalidate;
end;

initialization
  {$I estbk_progressformanimated.ctrs}

end.
