object form_progress: Tform_progress
  Left = 266
  Height = 43
  Top = 440
  Width = 601
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'form_progress'
  ClientHeight = 43
  ClientWidth = 601
  FormStyle = fsSplash
  OnClose = FormClose
  Position = poScreenCenter
  LCLVersion = '0.9.30'
  object Panel1: TPanel
    Left = 0
    Height = 43
    Top = 0
    Width = 601
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    ClientHeight = 43
    ClientWidth = 601
    TabOrder = 0
    object prgbar_misc: TProgressBar
      Left = 8
      Height = 25
      Top = 8
      Width = 584
      TabOrder = 0
    end
  end
end
