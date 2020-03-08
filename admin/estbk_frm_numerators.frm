object formNumerators: TformNumerators
  Left = 366
  Height = 592
  Top = 279
  Width = 786
  BorderStyle = bsDialog
  Caption = 'Numeraatorid '
  ClientHeight = 592
  ClientWidth = 786
  Position = poScreenCenter
  LCLVersion = '0.9.30'
  object grpboxNumerators: TGroupBox
    Left = 5
    Height = 536
    Top = 5
    Width = 774
    Anchors = [akTop, akLeft, akRight, akBottom]
    ClientHeight = 518
    ClientWidth = 770
    TabOrder = 0
    object gridNumeratorTypes: TStringGrid
      Left = 6
      Height = 509
      Top = 3
      Width = 757
      Anchors = [akTop, akLeft, akRight, akBottom]
      ColCount = 4
      Columns = <      
        item
          Title.Caption = ' Tüüp'
          Width = 205
        end      
        item
          Title.Caption = ' Väärtus'
        end      
        item
          Title.Caption = ' Prefiks'
        end      
        item
          Title.Caption = ' 0 arv'
          Width = 85
        end>
      DefaultRowHeight = 21
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor, goSmoothScroll]
      RowCount = 1
      TabOrder = 0
      OnEditingDone = gridNumeratorTypesEditingDone
      OnKeyPress = gridNumeratorTypesKeyPress
    end
  end
  object btnSave: TBitBtn
    Tag = -1
    Left = 579
    Height = 30
    Top = 552
    Width = 99
    Anchors = [akRight, akBottom]
    Caption = 'Salvesta'
    Kind = bkAll
    OnClick = btnSaveClick
    TabOrder = 1
  end
  object btnClose: TBitBtn
    Tag = -1
    Left = 680
    Height = 30
    Top = 552
    Width = 99
    Anchors = [akRight, akBottom]
    Caption = 'Sulge'
    Kind = bkCancel
    ModalResult = 2
    TabOrder = 2
  end
  object qryNumerators: TZQuery
    Connection = admDatamodule.admConnection
    Params = <>
    left = 576
    top = 8
  end
end
