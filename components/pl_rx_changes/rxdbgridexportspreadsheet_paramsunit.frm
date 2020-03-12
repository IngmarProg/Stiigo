object RxDBGridExportSpreadSheet_ParamsForm: TRxDBGridExportSpreadSheet_ParamsForm
  Left = 483
  Height = 328
  Top = 235
  Width = 548
  Caption = 'Export params'
  ClientHeight = 328
  ClientWidth = 548
  OnCloseQuery = FormCloseQuery
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
    Width = 530
    Filter = 'All files (*.*)|*.*|LibreOffice/OpenOffice (*.ods)|*.ods|Excel 97-2003|*.xls|Excel 2007-2013|*.xlsx'
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
  object Label3: TLabel
    AnchorSideLeft.Control = Label4
    AnchorSideTop.Control = cbExportGrpData
    AnchorSideTop.Side = asrBottom
    Left = 280
    Height = 17
    Top = 185
    Width = 67
    BorderSpacing.Around = 6
    Caption = 'Page name'
    FocusControl = edtPageName
    ParentColor = False
  end
  object edtPageName: TEdit
    AnchorSideLeft.Control = Label3
    AnchorSideTop.Control = Label3
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 286
    Height = 34
    Top = 208
    Width = 256
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    TabOrder = 7
  end
  object cbExportColumnFooter: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = cbExportColumnHeader
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 127
    Width = 155
    BorderSpacing.Around = 6
    Caption = 'Export column footer'
    TabOrder = 3
  end
  object cbOpenAfterExport: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = FileNameEdit1
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 69
    Width = 133
    BorderSpacing.Around = 6
    Caption = 'Open after export'
    TabOrder = 1
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 46
    Top = 276
    Width = 536
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 8
    ShowButtons = [pbOK, pbCancel, pbHelp]
  end
  object cbExportColumnHeader: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = cbOpenAfterExport
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 98
    Width = 159
    BorderSpacing.Around = 6
    Caption = 'Export column header'
    TabOrder = 2
  end
  object cbExportCellColors: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = cbExportColumnFooter
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 156
    Width = 130
    BorderSpacing.Around = 6
    Caption = 'Export cell colors'
    TabOrder = 4
  end
  object Label4: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideLeft.Side = asrCenter
    AnchorSideTop.Control = Owner
    Left = 274
    Height = 1
    Top = 0
    Width = 1
    ParentColor = False
  end
  object cbOverwriteExisting: TCheckBox
    AnchorSideLeft.Control = Label4
    AnchorSideTop.Control = cbExportFormula
    AnchorSideTop.Side = asrBottom
    Left = 280
    Height = 23
    Top = 98
    Width = 155
    BorderSpacing.Around = 6
    Caption = 'Overwrite existing file'
    TabOrder = 6
  end
  object cbExportFormula: TCheckBox
    AnchorSideLeft.Control = Label4
    AnchorSideTop.Control = FileNameEdit1
    AnchorSideTop.Side = asrBottom
    Left = 280
    Height = 23
    Top = 69
    Width = 117
    BorderSpacing.Around = 6
    Caption = 'Export formula'
    TabOrder = 5
  end
  object cbExportSelectedRows: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = cbExportCellColors
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 185
    Width = 151
    BorderSpacing.Around = 6
    Caption = 'Export selected rows'
    TabOrder = 9
  end
  object cbHideZeroValues: TCheckBox
    AnchorSideLeft.Control = Label4
    AnchorSideTop.Control = cbOverwriteExisting
    AnchorSideTop.Side = asrBottom
    Left = 280
    Height = 23
    Top = 127
    Width = 123
    BorderSpacing.Around = 6
    Caption = 'Hide zero values'
    TabOrder = 10
  end
  object cbMergeCells: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = cbExportSelectedRows
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 214
    Width = 99
    BorderSpacing.Around = 6
    Caption = 'Merge cell''s'
    TabOrder = 11
  end
  object cbExportGrpData: TCheckBox
    AnchorSideLeft.Control = Label4
    AnchorSideTop.Control = cbHideZeroValues
    AnchorSideTop.Side = asrBottom
    Left = 280
    Height = 23
    Top = 156
    Width = 135
    BorderSpacing.Around = 6
    Caption = 'Export group data'
    TabOrder = 12
  end
end
