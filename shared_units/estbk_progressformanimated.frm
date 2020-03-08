object formAnimatedProgress: TformAnimatedProgress
  Left = 355
  Height = 150
  Top = 314
  Width = 299
  AlphaBlend = True
  AlphaBlendValue = 145
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 150
  ClientWidth = 299
  DesignTimePPI = 120
  OnCreate = FormCreate
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '7.0'
  object pAnimatedGif: TImage
    Left = 5
    Height = 109
    Top = 6
    Width = 289
    Anchors = [akTop, akLeft, akRight, akBottom]
  end
  object Label1: TLabel
    Left = 5
    Height = 20
    Top = 125
    Width = 122
    Caption = 'Töötlen andmeid...'
    ParentColor = False
    ParentFont = False
  end
  object repaintTimer: TTimer
    Interval = 200
    OnTimer = repaintTimerTimer
    Left = 410
    Top = 10
  end
end
