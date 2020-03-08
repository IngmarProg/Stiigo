object formCustomDialog: TformCustomDialog
  Left = 301
  Height = 241
  Top = 270
  Width = 608
  HorzScrollBar.Page = 635
  VertScrollBar.Page = 367
  ActiveControl = btnYes
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'formCustomDialog'
  ClientHeight = 241
  ClientWidth = 608
  Color = clWhite
  OnCreate = FormCreate
  Position = poMainFormCenter
  LCLVersion = '0.9.30'
  object GroupBox1: TGroupBox
    Left = 8
    Height = 144
    Top = 0
    Width = 592
    ClientHeight = 126
    ClientWidth = 588
    Color = clCaptionText
    ParentColor = False
    TabOrder = 0
    object lblExplain: TLabel
      Left = 6
      Height = 119
      Top = 1
      Width = 576
      Anchors = [akTop, akLeft, akRight, akBottom]
      AutoSize = False
      Color = clWhite
      ParentColor = False
      Transparent = False
    end
  end
  object btnYes: TBitBtn
    Left = 224
    Height = 30
    Top = 200
    Width = 75
    ModalResult = 6
    TabOrder = 1
  end
  object btnNo: TBitBtn
    Left = 312
    Height = 30
    Top = 200
    Width = 75
    ModalResult = 7
    TabOrder = 2
  end
  object ChkBxRemdecision: TCheckBox
    Left = 16
    Height = 17
    Top = 152
    Width = 584
    AutoSize = False
    TabOrder = 3
  end
end
