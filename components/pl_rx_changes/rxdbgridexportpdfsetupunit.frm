object RxDBGridExportPdfSetupForm: TRxDBGridExportPdfSetupForm
  Left = 544
  Height = 454
  Top = 316
  Width = 522
  Caption = 'Export params'
  ClientHeight = 454
  ClientWidth = 522
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '7.0'
  object Label1: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Owner
    Left = 6
    Height = 17
    Top = 6
    Width = 99
    BorderSpacing.Around = 6
    Caption = 'Export file name'
    FocusControl = FileNameEdit1
    ParentColor = False
  end
  object FileNameEdit1: TFileNameEdit
    AnchorSideLeft.Control = Label1
    AnchorSideTop.Control = Label1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 12
    Height = 34
    Top = 29
    Width = 504
    Filter = 'All files (*.*)|*.*|LibreOffice/OpenOffice (*.ods)|*.ods|Excell 97-2003|*.xls|Excell 2007-2013|*.xlxs'
    FilterIndex = 0
    HideDirectories = False
    ButtonWidth = 23
    NumGlyphs = 1
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    MaxLength = 0
    Spacing = 0
    TabOrder = 0
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 46
    Top = 402
    Width = 510
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
  object GroupBox1: TGroupBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = FileNameEdit1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 6
    Height = 144
    Top = 69
    Width = 510
    Anchors = [akTop, akLeft, akRight]
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Global'
    ClientHeight = 126
    ClientWidth = 508
    TabOrder = 2
    object ColorBox1: TColorBox
      AnchorSideLeft.Control = Label5
      AnchorSideTop.Control = Label5
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = GroupBox1
      AnchorSideRight.Side = asrBottom
      Left = 266
      Height = 33
      Top = 87
      Width = 236
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
      Anchors = [akTop, akLeft, akRight]
      BorderSpacing.Around = 6
      ItemHeight = 16
      TabOrder = 0
    end
    object Label5: TLabel
      AnchorSideLeft.Control = Label3
      AnchorSideTop.Control = CheckBox6
      AnchorSideTop.Side = asrBottom
      Left = 260
      Height = 17
      Top = 64
      Width = 61
      BorderSpacing.Around = 6
      Caption = 'Title color'
      ParentColor = False
    end
    object CheckBox6: TCheckBox
      AnchorSideLeft.Control = Label3
      AnchorSideTop.Control = cbOverwriteExisting
      AnchorSideTop.Side = asrBottom
      Left = 260
      Height = 23
      Top = 35
      Width = 112
      BorderSpacing.Around = 6
      Caption = 'Export images'
      TabOrder = 1
    end
    object cbOverwriteExisting: TCheckBox
      AnchorSideLeft.Control = Label3
      AnchorSideTop.Control = GroupBox1
      Left = 260
      Height = 23
      Top = 6
      Width = 155
      BorderSpacing.Around = 6
      Caption = 'Overwrite existing file'
      Enabled = False
      TabOrder = 2
    end
    object cbOpenAfterExport: TCheckBox
      AnchorSideLeft.Control = GroupBox1
      AnchorSideTop.Control = GroupBox1
      Left = 6
      Height = 23
      Top = 6
      Width = 133
      BorderSpacing.Around = 6
      Caption = 'Open after export'
      TabOrder = 3
    end
    object cbExportColumnHeader: TCheckBox
      AnchorSideLeft.Control = GroupBox1
      AnchorSideTop.Control = cbOpenAfterExport
      AnchorSideTop.Side = asrBottom
      Left = 6
      Height = 23
      Top = 35
      Width = 159
      BorderSpacing.Around = 6
      Caption = 'Export column header'
      TabOrder = 4
    end
    object cbExportColumnFooter: TCheckBox
      AnchorSideLeft.Control = GroupBox1
      AnchorSideTop.Control = cbExportColumnHeader
      AnchorSideTop.Side = asrBottom
      Left = 6
      Height = 23
      Top = 64
      Width = 155
      BorderSpacing.Around = 6
      Caption = 'Export column footer'
      TabOrder = 5
    end
    object cbExportCellColors: TCheckBox
      AnchorSideLeft.Control = GroupBox1
      AnchorSideTop.Control = cbExportColumnFooter
      AnchorSideTop.Side = asrBottom
      Left = 6
      Height = 23
      Top = 93
      Width = 130
      BorderSpacing.Around = 6
      Caption = 'Export cell colors'
      TabOrder = 6
    end
    object Label3: TLabel
      AnchorSideLeft.Control = GroupBox1
      AnchorSideLeft.Side = asrCenter
      AnchorSideTop.Control = GroupBox1
      Left = 254
      Height = 1
      Top = 0
      Width = 1
      ParentColor = False
    end
  end
  object GroupBox2: TGroupBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = GroupBox1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 6
    Height = 169
    Top = 219
    Width = 510
    Anchors = [akTop, akLeft, akRight]
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'PDF Options'
    ClientHeight = 151
    ClientWidth = 508
    TabOrder = 3
    object CheckBox1: TCheckBox
      AnchorSideTop.Control = GroupBox2
      Left = 6
      Height = 23
      Top = 6
      Width = 73
      BorderSpacing.Around = 6
      Caption = 'Out line'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      AnchorSideLeft.Control = GroupBox2
      AnchorSideTop.Control = CheckBox1
      AnchorSideTop.Side = asrBottom
      Left = 6
      Height = 23
      Top = 35
      Width = 113
      BorderSpacing.Around = 6
      Caption = 'Compress text'
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      AnchorSideLeft.Control = GroupBox2
      AnchorSideTop.Control = CheckBox2
      AnchorSideTop.Side = asrBottom
      Left = 6
      Height = 23
      Top = 64
      Width = 122
      BorderSpacing.Around = 6
      Caption = 'Compress fonts'
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      AnchorSideLeft.Control = GroupBox2
      AnchorSideTop.Control = CheckBox3
      AnchorSideTop.Side = asrBottom
      Left = 6
      Height = 23
      Top = 93
      Width = 133
      BorderSpacing.Around = 6
      Caption = 'Compress images'
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      AnchorSideLeft.Control = GroupBox2
      AnchorSideTop.Control = CheckBox4
      AnchorSideTop.Side = asrBottom
      Left = 6
      Height = 23
      Top = 122
      Width = 108
      BorderSpacing.Around = 6
      Caption = 'Use raw JPEG'
      TabOrder = 4
    end
    object Label2: TLabel
      AnchorSideLeft.Control = Label4
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = GroupBox2
      Left = 261
      Height = 17
      Top = 6
      Width = 64
      BorderSpacing.Around = 6
      Caption = 'Paper type'
      ParentColor = False
    end
    object ComboBox1: TComboBox
      AnchorSideLeft.Control = Label2
      AnchorSideTop.Control = Label2
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = GroupBox2
      AnchorSideRight.Side = asrBottom
      Left = 267
      Height = 33
      Top = 29
      Width = 235
      Anchors = [akTop, akLeft, akRight]
      BorderSpacing.Around = 6
      ItemHeight = 0
      Style = csDropDownList
      TabOrder = 5
    end
    object RadioGroup1: TRadioGroup
      AnchorSideLeft.Control = Label4
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = ComboBox1
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = GroupBox2
      AnchorSideRight.Side = asrBottom
      Left = 261
      Height = 64
      Top = 68
      Width = 241
      Anchors = [akTop, akLeft, akRight]
      AutoFill = True
      AutoSize = True
      BorderSpacing.Around = 6
      Caption = 'Orientation'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 46
      ClientWidth = 239
      Items.Strings = (
        'Portrait'
        'Landscape'
      )
      TabOrder = 6
    end
    object Label4: TLabel
      AnchorSideLeft.Control = GroupBox2
      AnchorSideLeft.Side = asrCenter
      AnchorSideTop.Control = GroupBox2
      Left = 254
      Height = 1
      Top = 0
      Width = 1
      ParentColor = False
    end
  end
end
