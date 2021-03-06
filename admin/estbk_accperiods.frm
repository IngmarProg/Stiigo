object frameAccPeriods: TframeAccPeriods
  Left = 0
  Height = 545
  Top = 0
  Width = 874
  ClientHeight = 545
  ClientWidth = 874
  DesignTimePPI = 120
  ParentFont = False
  TabOrder = 0
  DesignLeft = 23
  DesignTop = 215
  object lblPerName: TLabel
    Left = 28
    Height = 18
    Top = 24
    Width = 112
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Nimetus:'
    ParentColor = False
  end
  object dbEdtPerName: TDBEdit
    Left = 146
    Height = 28
    Top = 20
    Width = 404
    DataField = 'accname'
    DataSource = qryAccPeriodsDS
    CharCase = ecNormal
    MaxLength = 0
    ParentFont = False
    TabOrder = 0
    OnKeyPress = dbEdtPerNameKeyPress
  end
  object lblDateStart: TLabel
    Left = 30
    Height = 18
    Top = 54
    Width = 112
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Algus:'
    ParentColor = False
  end
  object dtEdtStart: TDateEdit
    Left = 146
    Height = 28
    Top = 51
    Width = 154
    CalendarDisplaySettings = [dsShowHeadings, dsShowDayNames]
    OnAcceptDate = dtEdtEndAcceptDate
    DefaultToday = True
    DateOrder = doNone
    ButtonWidth = 29
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D69E
      72C4D3996EF4D19668FFCE9263FFCB8E5EFFC98A5BFFC78756FFC38452FFC384
      52FFC38452FFC38452FFC38452FFC38452FFBB7742B0FFFFFF00FFFFFF00D7A1
      75FFF8F2EDFFF7F0EAFFF6EDE6FFF4EAE2FFF3E7DEFFF1E4DBFFF0E2D8FFEAD6
      C8FFF2E5DCFFFAF4F1FFF9F3F0FFFAF5F2FFC58A5DFDFFFFFF00FFFFFF00D9A4
      7AFFF9F3EEFFEBD2BEFFFFFFFFFFEBD3BFFFFFFFFFFFEBD3C0FFFFFFFFFFEAC7
      ADFFECD9CDFFF1E4DBFFF9F3F0FFF9F2EFFFC68C5FFFFFFFFF00FFFFFF00DDA8
      7EFFF9F3EFFFEBD0BAFFEBD0BBFF75B57AFF75B57AFF75B57AFFEBD1BDFFEACD
      B5FFFAF4F0FFEBD9CCFFF1E4DBFFFAF4F1FFC68A5CFFFFFFFF00FFFFFF00DFAA
      82FFF9F3EFFFEACEB7FFFFFFFFFF75B57AFF94D49BFF74B579FFFFFFFFFFEACF
      BAFFFBF6F2FFFAF3F0FFEBD8CBFFF2E6DDFFC88D5FFFFFFFFF00FFFFFF00E1AE
      87FFFAF4F0FFEACBB2FFEACCB3FF75B57AFF74B579FF73B478FFEACEB7FF70B3
      75FF6FB274FF6EB172FFE8C8AEFFEAD7C9FFC48654FFFFFFFF00FFFFFF00E3B1
      8CFFFAF6F1FFEAC9AEFFFFFFFFFFEAC9B0FFFFFFFFFFE9CBB3FFFFFFFFFF6FB1
      73FF8ED295FF6BAF6FFFFFFFFFFFF1E5DBFFC68655FFFFFFFF00FFFFFF00E5B4
      8FFFFAF6F2FFE9C6AAFFE9C6ACFFEAC7ACFFE9C7ADFFE9C9AEFFE9C9B0FF6CB0
      71FF6AAF6EFF68AD6DFFE8CCB5FFF2E7DEFFC88A59FFFFFFFF00FFFFFF00E7B7
      94FFFBF7F4FFE9C3A6FFFFFFFFFFE8C4A9FFFFFFFFFFE9C6AAFFFFFFFFFFE8C7
      ACFFFFFFFFFFE8C8B0FFFFFFFFFFF7F1EBFFCB8F5FFFFFFFFF00FFFFFF00E9BA
      98FFFBF7F4FF65A4FFFF64A3FFFF62A2FFFF61A1FFFF5F9FFFFF5C9DFFFF5A9A
      FFFF5798FFFF5495FFFF5294FFFFFBF7F4FFCE9364FFFFFFFF00FFFFFF00EBBD
      9BFFFBF7F4FF64A4FFFF79BDFFFF75BBFFFF71B9FFFF6DB8FFFF68B3FFFF61B0
      FFFF5AABFFFF54A7FFFF3B7DFFFFFBF7F4FFD1976AFFFFFFFF00FFFFFF00ECBF
      9EFFFBF7F4FF65A4FFFF64A3FFFF60A0FFFF5D9EFFFF5899FFFF5496FFFF4D90
      FFFF478BFFFF4284FFFF3D7FFFFFFBF7F4FFD49B6FFFFFFFFF00FFFFFF00EEC1
      A1EBFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFD7A074F8FFFFFF00FFFFFF00EFC2
      A37EEFC1A2E3EDC09FFFEBBE9DFFEBBC9AFFE9BA96FFE7B793FFE6B590FFE4B2
      8CFFE2AF88FFE0AC84FFDDA980FFDCA57DFFDAA37ACAFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
    }
    NumGlyphs = 1
    MaxLength = 0
    OnExit = dtEdtStartExit
    OnKeyPress = dbEdtPerNameKeyPress
    ParentFont = False
    TabOrder = 1
  end
  object dtEdtEnd: TDateEdit
    Left = 146
    Height = 28
    Top = 82
    Width = 154
    CalendarDisplaySettings = [dsShowHeadings, dsShowDayNames]
    OnAcceptDate = dtEdtEndAcceptDate
    DefaultToday = True
    DateOrder = doNone
    ButtonWidth = 29
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D69E
      72C4D3996EF4D19668FFCE9263FFCB8E5EFFC98A5BFFC78756FFC38452FFC384
      52FFC38452FFC38452FFC38452FFC38452FFBB7742B0FFFFFF00FFFFFF00D7A1
      75FFF8F2EDFFF7F0EAFFF6EDE6FFF4EAE2FFF3E7DEFFF1E4DBFFF0E2D8FFEAD6
      C8FFF2E5DCFFFAF4F1FFF9F3F0FFFAF5F2FFC58A5DFDFFFFFF00FFFFFF00D9A4
      7AFFF9F3EEFFEBD2BEFFFFFFFFFFEBD3BFFFFFFFFFFFEBD3C0FFFFFFFFFFEAC7
      ADFFECD9CDFFF1E4DBFFF9F3F0FFF9F2EFFFC68C5FFFFFFFFF00FFFFFF00DDA8
      7EFFF9F3EFFFEBD0BAFFEBD0BBFF75B57AFF75B57AFF75B57AFFEBD1BDFFEACD
      B5FFFAF4F0FFEBD9CCFFF1E4DBFFFAF4F1FFC68A5CFFFFFFFF00FFFFFF00DFAA
      82FFF9F3EFFFEACEB7FFFFFFFFFF75B57AFF94D49BFF74B579FFFFFFFFFFEACF
      BAFFFBF6F2FFFAF3F0FFEBD8CBFFF2E6DDFFC88D5FFFFFFFFF00FFFFFF00E1AE
      87FFFAF4F0FFEACBB2FFEACCB3FF75B57AFF74B579FF73B478FFEACEB7FF70B3
      75FF6FB274FF6EB172FFE8C8AEFFEAD7C9FFC48654FFFFFFFF00FFFFFF00E3B1
      8CFFFAF6F1FFEAC9AEFFFFFFFFFFEAC9B0FFFFFFFFFFE9CBB3FFFFFFFFFF6FB1
      73FF8ED295FF6BAF6FFFFFFFFFFFF1E5DBFFC68655FFFFFFFF00FFFFFF00E5B4
      8FFFFAF6F2FFE9C6AAFFE9C6ACFFEAC7ACFFE9C7ADFFE9C9AEFFE9C9B0FF6CB0
      71FF6AAF6EFF68AD6DFFE8CCB5FFF2E7DEFFC88A59FFFFFFFF00FFFFFF00E7B7
      94FFFBF7F4FFE9C3A6FFFFFFFFFFE8C4A9FFFFFFFFFFE9C6AAFFFFFFFFFFE8C7
      ACFFFFFFFFFFE8C8B0FFFFFFFFFFF7F1EBFFCB8F5FFFFFFFFF00FFFFFF00E9BA
      98FFFBF7F4FF65A4FFFF64A3FFFF62A2FFFF61A1FFFF5F9FFFFF5C9DFFFF5A9A
      FFFF5798FFFF5495FFFF5294FFFFFBF7F4FFCE9364FFFFFFFF00FFFFFF00EBBD
      9BFFFBF7F4FF64A4FFFF79BDFFFF75BBFFFF71B9FFFF6DB8FFFF68B3FFFF61B0
      FFFF5AABFFFF54A7FFFF3B7DFFFFFBF7F4FFD1976AFFFFFFFF00FFFFFF00ECBF
      9EFFFBF7F4FF65A4FFFF64A3FFFF60A0FFFF5D9EFFFF5899FFFF5496FFFF4D90
      FFFF478BFFFF4284FFFF3D7FFFFFFBF7F4FFD49B6FFFFFFFFF00FFFFFF00EEC1
      A1EBFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFD7A074F8FFFFFF00FFFFFF00EFC2
      A37EEFC1A2E3EDC09FFFEBBE9DFFEBBC9AFFE9BA96FFE7B793FFE6B590FFE4B2
      8CFFE2AF88FFE0AC84FFDDA980FFDCA57DFFDAA37ACAFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
    }
    NumGlyphs = 1
    MaxLength = 0
    OnExit = dtEdtStartExit
    OnKeyPress = dbEdtPerNameKeyPress
    ParentFont = False
    TabOrder = 2
  end
  object lblDateEnd: TLabel
    Left = 28
    Height = 18
    Top = 86
    Width = 112
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Lõpp:'
    ParentColor = False
  end
  object dbChkBoxClose: TCheckBox
    Left = 146
    Height = 21
    Top = 116
    Width = 374
    AutoSize = False
    Caption = ' Suletud'
    OnClick = dbChkBoxCloseClick
    ParentFont = False
    TabOrder = 3
  end
  object mrline3: TBevel
    Left = 20
    Height = 8
    Top = 146
    Width = 832
    Anchors = [akTop, akLeft, akRight]
    Shape = bsTopLine
  end
  object accEntrys: TDBGrid
    Left = 20
    Height = 339
    Top = 151
    Width = 832
    Anchors = [akTop, akLeft, akRight, akBottom]
    Color = clWindow
    Columns = <    
      item
        MinSize = 12
        MaxSize = 250
        Title.Caption = 'Nimetus'
        Width = 219
        FieldName = 'accname'
      end    
      item
        MinSize = 12
        MaxSize = 250
        Title.Caption = 'Algus'
        Width = 119
        FieldName = 'period_start'
      end    
      item
        MinSize = 12
        MaxSize = 250
        Title.Caption = 'Lõpp'
        Width = 119
        FieldName = 'period_end'
      end    
      item
        MinSize = 12
        MaxSize = 250
        Title.Caption = 'Staatus'
        FieldName = 'status'
      end    
      item
        Alignment = taCenter
        ButtonStyle = cbsButtonColumn
        MinSize = 12
        MaxSize = 250
        ReadOnly = True
        Title.Caption = '  '
        Width = 40
        FieldName = 'btncapt'
      end>
    DataSource = qryAccPeriodsDS
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    TitleStyle = tsNative
    OnCellClick = accEntrysCellClick
    OnDrawColumnCell = accEntrysDrawColumnCell
    OnEditButtonClick = accEntrysEditButtonClick
    OnKeyDown = accEntrysKeyDown
    OnSelectEditor = accEntrysSelectEditor
  end
  object mrline4: TBevel
    Left = 20
    Height = 8
    Top = 144
    Width = 832
    Anchors = [akTop, akLeft, akRight]
    Shape = bsTopLine
  end
  object pchkboxAccPer: TCheckBox
    Tag = -1
    Left = 20
    Height = 24
    Top = 499
    Width = 500
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = ' Numeraatorid majandusaasta põhised'
    OnChange = pchkboxAccPerChange
    TabOrder = 5
  end
  object qryAccPeriods: TZQuery
    AutoCalcFields = False
    BeforeScroll = qryAccPeriodsBeforeScroll
    AfterScroll = qryAccPeriodsAfterScroll
    UpdateObject = qryAccPeriodsUpdSQL
    CachedUpdates = True
    AfterInsert = qryAccPeriodsAfterInsert
    AfterEdit = qryAccPeriodsAfterEdit
    AfterCancel = qryAccPeriodsAfterCancel
    BeforeDelete = qryAccPeriodsBeforeDelete
    Params = <>
    Sequence = qryAccPeriodsSeq
    Left = 780
    Top = 20
  end
  object qryAccPeriodsDS: TDataSource
    DataSet = qryAccPeriods
    Left = 780
    Top = 96
  end
  object qryAccPeriodsSeq: TZSequence
    Left = 780
    Top = 180
  end
  object qryAccPeriodsUpdSQL: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = True
    Left = 650
    Top = 20
  end
  object qryVerifySQL: TZQuery
    AutoCalcFields = False
    ReadOnly = True
    Params = <>
    Left = 650
    Top = 96
  end
end
