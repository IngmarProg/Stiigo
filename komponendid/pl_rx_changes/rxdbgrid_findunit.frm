object rxDBGridFindForm: TrxDBGridFindForm
  Left = 688
  Height = 287
  Top = 327
  Width = 508
  ActiveControl = Edit1
  Caption = 'Find'
  ClientHeight = 287
  ClientWidth = 508
  OnCreate = FormCreate
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '6.9'
  object Label1: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Owner
    AnchorSideBottom.Control = Edit1
    AnchorSideBottom.Side = asrBottom
    Left = 6
    Height = 17
    Top = 6
    Width = 69
    BorderSpacing.Around = 6
    Caption = 'Text to find'
    FocusControl = Edit1
    ParentColor = False
  end
  object BtnFind: TButton
    AnchorSideRight.Control = Button2
    AnchorSideBottom.Control = Owner
    AnchorSideBottom.Side = asrBottom
    Left = 352
    Height = 41
    Top = 240
    Width = 86
    Anchors = [akRight, akBottom]
    AutoSize = True
    BorderSpacing.Around = 6
    BorderSpacing.InnerBorder = 4
    Caption = 'Find more'
    Default = True
    OnClick = BtnFindClick
    TabOrder = 2
  end
  object Button2: TButton
    AnchorSideTop.Control = BtnFind
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = Owner
    AnchorSideBottom.Side = asrBottom
    Left = 444
    Height = 41
    Top = 240
    Width = 58
    Anchors = [akRight, akBottom]
    AutoSize = True
    BorderSpacing.Around = 6
    BorderSpacing.InnerBorder = 4
    Cancel = True
    Caption = 'Close'
    OnClick = Button2Click
    TabOrder = 3
  end
  object Edit1: TEdit
    AnchorSideLeft.Control = ComboBox1
    AnchorSideTop.Control = Label1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 18
    Height = 34
    Top = 29
    Width = 484
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    AnchorSideLeft.Control = RadioButton1
    AnchorSideTop.Control = RadioButton1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 12
    Height = 33
    Top = 98
    Width = 490
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 0
    Style = csDropDownList
    TabOrder = 1
  end
  object RadioGroup1: TRadioGroup
    AnchorSideLeft.Control = Panel1
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = RadioButton2
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = Panel1
    AnchorSideBottom.Side = asrBottom
    Left = 139
    Height = 66
    Top = 166
    Width = 363
    Anchors = [akTop, akLeft, akRight, akBottom]
    AutoFill = True
    AutoSize = True
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Right = 6
    Caption = 'Direction'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.TopBottomSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 3
    ClientHeight = 48
    ClientWidth = 361
    Columns = 3
    Items.Strings = (
      'All'
      'Forward'
      'Backward'
    )
    TabOrder = 4
  end
  object Panel1: TPanel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = RadioButton2
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 66
    Top = 166
    Width = 127
    AutoSize = True
    BorderSpacing.Around = 6
    ClientHeight = 66
    ClientWidth = 127
    TabOrder = 5
    object CheckBox2: TCheckBox
      AnchorSideLeft.Control = Panel1
      AnchorSideTop.Control = CheckBox1
      AnchorSideTop.Side = asrBottom
      Left = 7
      Height = 23
      Top = 36
      Width = 88
      BorderSpacing.Around = 6
      Caption = 'Partial key'
      TabOrder = 0
    end
    object CheckBox1: TCheckBox
      AnchorSideLeft.Control = Panel1
      AnchorSideTop.Control = Panel1
      Left = 7
      Height = 23
      Top = 7
      Width = 113
      BorderSpacing.Around = 6
      Caption = 'Case sensetive'
      TabOrder = 1
    end
  end
  object RadioButton1: TRadioButton
    AnchorSideLeft.Control = Label1
    AnchorSideTop.Control = Edit1
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 69
    Width = 98
    Caption = 'Find at field'
    Checked = True
    OnClick = RadioButton1Click
    TabOrder = 6
    TabStop = True
  end
  object RadioButton2: TRadioButton
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox1
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 137
    Width = 121
    BorderSpacing.Around = 6
    Caption = 'Find in all fields'
    OnClick = RadioButton1Click
    TabOrder = 7
  end
end
