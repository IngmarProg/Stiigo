inherited formChooseCustomer: TformChooseCustomer
  Left = 259
  Height = 607
  Top = 220
  Width = 697
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Laiendatud kliendi otsing'
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  Position = poScreenCenter
  object initFocusTimer: TTimer[0]
    Enabled = False
    Interval = 45
    OnTimer = initFocusTimerTimer
    left = 632
    top = 16
  end
end
