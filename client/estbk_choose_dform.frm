object formChoosedFrm: TformChoosedFrm
  Left = 365
  Height = 103
  Top = 428
  Width = 500
  BorderStyle = bsDialog
  ClientHeight = 103
  ClientWidth = 500
  Color = clWindow
  Position = poDesktopCenter
  LCLVersion = '0.9.29'
  object grpIBox: TGroupBox
    Left = 8
    Height = 58
    Top = 0
    Width = 482
    ClientHeight = 40
    ClientWidth = 478
    TabOrder = 0
    object lblItemname: TLabel
      Left = 14
      Height = 16
      Top = 9
      Width = 200
      Alignment = taRightJustify
      AutoSize = False
      Caption = '#'
      ParentColor = False
    end
    object cmbActiveForms: TComboBox
      Left = 224
      Height = 21
      Top = 6
      Width = 242
      ItemHeight = 13
      Style = csDropDownList
      TabOrder = 0
    end
  end
  object btnOk: TBitBtn
    Left = 332
    Height = 30
    Top = 64
    Width = 75
    Caption = '&OK'
    Default = True
    Kind = bkOK
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 412
    Height = 30
    Top = 64
    Width = 75
    Cancel = True
    Caption = '&Katkesta'
    Kind = bkCancel
    ModalResult = 2
    TabOrder = 2
  end
  object qryActiveDForms: TZReadOnlyQuery
    Params = <>
    left = 40
    top = 48
  end
end
