object rxShortCutForm: TrxShortCutForm
  Left = 505
  Height = 104
  Top = 526
  Width = 463
  Caption = 'ShortCut'
  ClientHeight = 104
  ClientWidth = 463
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '6.9'
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 46
    Top = 52
    Width = 451
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 0
    ShowButtons = [pbOK, pbCancel, pbHelp]
  end
  object CheckBox1: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox1
    AnchorSideTop.Side = asrCenter
    Left = 6
    Height = 23
    Top = 12
    Width = 55
    BorderSpacing.Left = 6
    BorderSpacing.Right = 6
    Caption = 'Shift'
    TabOrder = 1
  end
  object CheckBox2: TCheckBox
    AnchorSideLeft.Control = CheckBox1
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox1
    AnchorSideTop.Side = asrCenter
    Left = 67
    Height = 23
    Top = 12
    Width = 44
    BorderSpacing.Left = 6
    BorderSpacing.Right = 6
    Caption = 'Alt'
    TabOrder = 2
  end
  object CheckBox3: TCheckBox
    AnchorSideLeft.Control = CheckBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox1
    AnchorSideTop.Side = asrCenter
    Left = 117
    Height = 23
    Top = 12
    Width = 49
    BorderSpacing.Left = 6
    BorderSpacing.Right = 6
    Caption = 'Ctrl'
    TabOrder = 3
  end
  object ComboBox1: TComboBox
    AnchorSideLeft.Control = CheckBox3
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = Owner
    AnchorSideRight.Control = Button1
    Left = 172
    Height = 34
    Top = 6
    Width = 210
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 0
    TabOrder = 4
    Text = 'ComboBox1'
  end
  object Button1: TButton
    AnchorSideTop.Control = Owner
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 388
    Height = 33
    Top = 6
    Width = 69
    Anchors = [akTop, akRight]
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Grab key'
    OnClick = Button1Click
    TabOrder = 5
  end
end
