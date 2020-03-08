object frameWorkerTimeTable: TframeWorkerTimeTable
  Left = 0
  Height = 500
  Top = 0
  Width = 700
  ClientHeight = 500
  ClientWidth = 700
  TabOrder = 0
  DesignLeft = 380
  DesignTop = 275
  object grpContract: TGroupBox
    Left = 8
    Height = 436
    Top = 3
    Width = 683
    Anchors = [akTop, akLeft, akRight, akBottom]
    Caption = ' Tööaja tabel '
    ClientHeight = 418
    ClientWidth = 679
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object gridWorkerTimeTable: TStringGrid
      Left = 6
      Height = 410
      Top = 2
      Width = 667
      Anchors = [akTop, akLeft, akRight, akBottom]
      ColCount = 0
      FixedCols = 0
      FixedRows = 0
      RowCount = 0
      TabOrder = 0
      TitleFont.Style = [fsBold]
      TitleStyle = tsNative
    end
  end
  object qryWorker: TZQuery
    Params = <>
    left = 608
    top = 8
  end
end
