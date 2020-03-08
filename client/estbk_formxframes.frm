inherited formXFrames: TformXFrames
  Left = 323
  Height = 512
  Top = 165
  Width = 480
  ClientHeight = 512
  ClientWidth = 480
  Constraints.MinHeight = 165
  Constraints.MinWidth = 250
  KeyPreview = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  OnWindowStateChange = FormWindowStateChange
  Position = poScreenCenter
  object pnMaincontainer: TPanel[0]
    Left = 0
    Height = 487
    Top = 25
    Width = 480
    Align = alClient
    BevelOuter = bvNone
    ParentFont = False
    TabOrder = 0
  end
  object psCaptPanel: TNetGradient[1]
    Tag = -1
    Left = 0
    Height = 25
    Top = 0
    Width = 480
    BeginColor = 15637062
    EndColor = 14079702
    Font.CharSet = BALTIC_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Pitch = fpVariable
    Font.Quality = fqDraft
    Font.Style = [fsBold]
    Align = alTop
    object Image1: TImage
      Left = -8
      Height = 18
      Top = 4
      Width = 29
      Picture.Data = {
        1754506F727461626C654E6574776F726B47726170686963CA00000089504E47
        0D0A1A0A0000000D494844520000002D00000011080600000049A2254C000000
        097048597300000B1200000B1201D2DD7EFC0000007C49444154789CEDD0A10D
        C2601485D1A6028B446260003C8E11308CC0085DAB23B04207E800480C39EAD5
        C006FFDFF625159FBD39B94D4434D95A1CB0A1D75CB1219C71C8867EE0830EBB
        4CE8F835E29E0DFDEF854B3674E08B6B26748F5396A707DC4A636BA1DF78A2AD
        052E8D3E625F135B1C3D678B0336F49A9B008EEF073EC18DA0EF000000004945
        4E44AE426082
      }
    end
  end
  object waitAndKillTimer: TTimer[2]
    Enabled = False
    Interval = 45
    OnTimer = waitAndKillTimerTimer
    left = 424
    top = 8
  end
end
