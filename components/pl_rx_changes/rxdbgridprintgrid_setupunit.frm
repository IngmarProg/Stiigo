object RxDBGridPrintGrid_SetupForm: TRxDBGridPrintGrid_SetupForm
  Left = 560
  Height = 403
  Top = 232
  Width = 607
  Caption = 'Print grid setup'
  ClientHeight = 403
  ClientWidth = 607
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '6.7'
  object GroupBox1: TGroupBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Owner
    AnchorSideRight.Control = CLabel
    AnchorSideBottom.Control = CheckBox1
    Left = 6
    Height = 100
    Top = 6
    Width = 291
    Anchors = [akTop, akLeft, akRight]
    AutoSize = True
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Right = 6
    Caption = 'Page margins'
    ClientHeight = 80
    ClientWidth = 289
    TabOrder = 0
    object Label1: TLabel
      AnchorSideLeft.Control = GroupBox1
      AnchorSideBottom.Control = SpinEdit1
      AnchorSideBottom.Side = asrBottom
      Left = 6
      Height = 19
      Top = 18
      Width = 25
      Anchors = [akLeft, akBottom]
      BorderSpacing.Left = 6
      Caption = 'Top'
      ParentColor = False
    end
    object SpinEdit1: TSpinEdit
      AnchorSideTop.Control = GroupBox1
      AnchorSideRight.Control = Label5
      Left = 78
      Height = 31
      Top = 6
      Width = 60
      Anchors = [akTop, akRight]
      BorderSpacing.Around = 6
      MaxValue = 1000
      TabOrder = 0
    end
    object Label2: TLabel
      AnchorSideLeft.Control = GroupBox1
      AnchorSideBottom.Control = SpinEdit2
      AnchorSideBottom.Side = asrBottom
      Left = 6
      Height = 19
      Top = 55
      Width = 26
      Anchors = [akLeft, akBottom]
      BorderSpacing.Left = 6
      Caption = 'Left'
      ParentColor = False
    end
    object SpinEdit2: TSpinEdit
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = SpinEdit1
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = Label5
      Left = 78
      Height = 31
      Top = 43
      Width = 60
      Anchors = [akTop, akRight]
      BorderSpacing.Around = 6
      MaxValue = 1000
      TabOrder = 1
    end
    object SpinEdit3: TSpinEdit
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = GroupBox1
      AnchorSideRight.Control = GroupBox1
      AnchorSideRight.Side = asrBottom
      Left = 223
      Height = 31
      Top = 6
      Width = 60
      Anchors = [akTop, akRight]
      BorderSpacing.Around = 6
      MaxValue = 1000
      TabOrder = 2
    end
    object Label3: TLabel
      AnchorSideLeft.Control = Label5
      AnchorSideLeft.Side = asrBottom
      AnchorSideBottom.Control = SpinEdit3
      AnchorSideBottom.Side = asrBottom
      Left = 145
      Height = 19
      Top = 18
      Width = 34
      Anchors = [akLeft, akBottom]
      Caption = 'Right'
      ParentColor = False
    end
    object Label4: TLabel
      AnchorSideLeft.Control = Label5
      AnchorSideLeft.Side = asrBottom
      AnchorSideBottom.Control = SpinEdit4
      AnchorSideBottom.Side = asrBottom
      Left = 145
      Height = 19
      Top = 55
      Width = 49
      Anchors = [akLeft, akBottom]
      Caption = 'Bottom'
      ParentColor = False
    end
    object SpinEdit4: TSpinEdit
      AnchorSideTop.Control = SpinEdit3
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = GroupBox1
      AnchorSideRight.Side = asrBottom
      Left = 223
      Height = 31
      Top = 43
      Width = 60
      Anchors = [akTop, akRight]
      BorderSpacing.Around = 6
      MaxValue = 1000
      TabOrder = 3
    end
    object Label5: TLabel
      AnchorSideLeft.Control = GroupBox1
      AnchorSideLeft.Side = asrCenter
      AnchorSideTop.Control = GroupBox1
      Left = 144
      Height = 1
      Top = 0
      Width = 1
      ParentColor = False
    end
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 42
    Top = 355
    Width = 595
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 1
    ShowButtons = [pbOK, pbCancel, pbHelp]
  end
  object CheckGroup1: TCheckGroup
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = GroupBox1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 6
    Height = 124
    Top = 112
    Width = 595
    Anchors = [akTop, akLeft, akRight]
    AutoFill = True
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Print options'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.TopBottomSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 2
    ClientHeight = 104
    ClientWidth = 593
    Columns = 2
    Items.Strings = (
      'Show title'
      'Show footer'
      'Show footer color'
      'Show grid color'
      'Show report title'
      'Hide zero values'
      'Merge cell''s'
      'Show preview'
    )
    TabOrder = 2
    Data = {
      080000000202020202020202
    }
  end
  object RadioGroup1: TRadioGroup
    AnchorSideLeft.Control = CLabel
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = Owner
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = GroupBox1
    AnchorSideBottom.Side = asrBottom
    Left = 304
    Height = 100
    Top = 6
    Width = 297
    Anchors = [akTop, akLeft, akRight, akBottom]
    AutoFill = True
    AutoSize = True
    BorderSpacing.Top = 6
    BorderSpacing.Right = 6
    Caption = 'Orientation'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 1
    ClientHeight = 80
    ClientWidth = 295
    Items.Strings = (
      'Portrait'
      'Landscape'
    )
    TabOrder = 3
  end
  object Label6: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = CheckBox1
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 19
    Top = 271
    Width = 73
    BorderSpacing.Around = 6
    Caption = 'Report title'
    ParentColor = False
  end
  object Edit1: TEdit
    AnchorSideLeft.Control = Label6
    AnchorSideTop.Control = Label6
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 12
    Height = 31
    Top = 296
    Width = 589
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = CheckGroup1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = CheckGroup1
    AnchorSideBottom.Side = asrBottom
    Left = 6
    Height = 23
    Top = 242
    Width = 236
    BorderSpacing.Around = 6
    Caption = 'Show column header on all page'
    TabOrder = 5
  end
  object CLabel: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideLeft.Side = asrCenter
    AnchorSideTop.Control = Owner
    Left = 303
    Height = 1
    Top = 0
    Width = 1
    ParentColor = False
  end
end
