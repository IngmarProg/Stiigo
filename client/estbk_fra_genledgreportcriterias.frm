object frameGenledreportcrit: TframeGenledreportcrit
  Left = 0
  Height = 488
  Top = 0
  Width = 699
  ClientHeight = 488
  ClientWidth = 699
  TabOrder = 0
  DesignLeft = 307
  DesignTop = 314
  object plogicalgrp: TGroupBox
    Left = 8
    Height = 418
    Top = 8
    Width = 681
    Anchors = [akTop, akLeft, akRight, akBottom]
    Caption = ' # '
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = plogicalgrpClick
  end
  object btnClose: TBitBtn
    Tag = -1
    Left = 596
    Height = 30
    Top = 443
    Width = 95
    Anchors = [akRight, akBottom]
    Caption = 'Sulge'
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001D63
      9B1619609839145D9562105A92880D5890A4135C92FC0C578FED999999FF7171
      71FF545454FF515151FF4F4F4FFF4C4C4CFF4A4A4AFF474747FF454545FF2567
      9DFF3274A8FF3D7CAFFF4784B5FF4E8ABAFF3E7EADFF0C578FEAFFFFFF00FFFF
      FF00585858FFA2A2A2FFA2A2A2FFA3A3A3FFA4A4A4FFA4A4A4FFA5A5A5FF2F6F
      A5FF78ABD2FF78ABD3FF73A7D1FF69A0CDFF407FAEFF0F5991EAFFFFFF00FFFF
      FF005C5C5CFFA1A1A1FF3C7340FFA0A1A1FFA3A3A3FFA3A3A3FFA4A4A4FF3674
      AAFF7DAFD4FF5B9AC9FF5495C7FF5896C8FF4180AEFF135C94EAFFFFFF00FFFF
      FF00606060FFA0A0A0FF3D7641FF367139FFA2A2A2FFA2A2A2FFA3A3A3FF3D79
      B0FF82B3D7FF629FCCFF5A9AC9FF5E9BCAFF4381AFFF196098EA37823EFF347E
      3BFF317937FF2E7534FF499150FF468F4CFF39733DFFA1A1A1FFA2A2A2FF457E
      B4FF88B7D9FF67A3CFFF619ECCFF639FCCFF4583B1FF1F649CEA3B8742FF89CB
      92FF84C88DFF80C688FF7BC383FF77C17FFF478F4DFF3B743FFFA1A1A1FF4C84
      BAFF8DBBDBFF6EA8D1FF66A6D1FF5FB4DFFF4785B1FF2569A1EA3E8B46FF8FCE
      99FF7DC687FF78C381FF73C07CFF74C07CFF79C281FF49904FFF547F57FF5489
      BFFF94BFDDFF75ADD4FF63B8E1FF4BD4FFFF428BB8FF2C6EA6EA41904AFF94D2
      9FFF91D09AFF8DCD96FF89CB92FF84C88DFF519858FF417C46FF9F9F9FFF5A8E
      C4FF98C3E0FF7CB3D7FF74AFD6FF5EC4EDFF4B88B3FF3473ABEA44944DFF4291
      4BFF3F8D48FF3D8945FF5DA465FF5AA061FF45834BFF9E9E9EFF9E9E9EFF6092
      C9FF9EC7E2FF83B8DAFF7DB4D7FF7EB3D7FF4F89B4FF3B79B1EAFFFFFF00FFFF
      FF00777777FF9A9A9AFF3D8A45FF498A4FFF9C9C9CFF9D9D9DFF9D9D9DFF6696
      CCFFA2CBE3FF89BDDCFF83B9DAFF84B9DAFF518BB5FF437EB6EAFFFFFF00FFFF
      FF007A7A7AFF999999FF529159FF999A99FF9B9B9BFF9C9C9CFF9C9C9CFF6C9A
      D0FFA7CEE5FF8FC1DFFF89BDDCFF8BBDDCFF538DB6FF4B84BCEAFFFFFF00FFFF
      FF007D7D7DFF999999FF999999FF9A9A9AFF9A9A9AFF9B9B9BFF9B9B9BFF6F9D
      D3FFAAD1E7FFABD1E7FF98C7E1FF91C2DEFF568FB7FF5289C1EAFFFFFF00FFFF
      FF00808080FF7E7E7EFF7C7C7CFF7A7A7AFF777777FF757575FF727272FF719E
      D4FF6F9ED6FF87B2DCFFABD3E8FFA9D0E6FF5890B8FF598EC6EAFFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00709ED6DB6D9CD4FF85B1DAFF5A91B9FF6093CBEAFFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF006D9CD4896A9AD2FB6697CFEE
    }
    OnClick = btnCloseClick
    TabOrder = 1
  end
  object pMainResizePanel: TPanel
    Left = 16
    Height = 397
    Top = 24
    Width = 670
    Anchors = [akTop, akLeft, akRight, akBottom]
    BevelOuter = bvNone
    ClientHeight = 397
    ClientWidth = 670
    TabOrder = 2
    object pLeftPanel: TPanel
      Left = 0
      Height = 397
      Top = 0
      Width = 394
      Align = alLeft
      BevelOuter = bvNone
      ClientHeight = 397
      ClientWidth = 394
      Constraints.MinWidth = 150
      TabOrder = 0
      object lblPermisc: TLabel
        Left = 5
        Height = 14
        Top = 16
        Width = 99
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Periood:'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object cmbPreDefPer: TComboBox
        Left = 106
        Height = 21
        Top = 14
        Width = 172
        ItemHeight = 13
        OnChange = cmbPreDefPerChange
        OnKeyDown = cmbPreDefPerKeyDown
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        Style = csDropDownList
        TabOrder = 0
      end
      object btnReport: TBitBtn
        Tag = -1
        Left = 295
        Height = 30
        Top = 9
        Width = 80
        Caption = 'Aruanne'
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
          FF00FFFFFF00C89662FDCA9865FFCA9765FFCA9765FFCA9765FFCA9764FFC997
          64FFC99764FFCA9865FFC89562FDFFFFFF00FFFFFF00FFFFFF00A1A1A1C27A7A
          7ADA585858FFC79561FFF9F7F6FFF9F1ECFFF9F1EBFFF8F0E9FFF7EDE6FFF4EA
          E1FFF2E8DEFFFAF8F6FFC79461FF242424FF4B4B4BD9969696BF6B6B6BFDA7A7
          A7FFB5B5B5FF818181FFAFACAAFFC5C0BDFFC5C0BDFFC5C0BDFFC5C0BDFFC5C0
          BDFFC5C0BDFFADAAA8FF2C2C2CFFB5B5B5FF9B9B9BFF232323FF707070FFB5B5
          B5FFB5B5B5FF959595FF818181FF818181FF797979FF6E6E6EFF616161FF5252
          52FF434343FF424242FF6E6E6EFFB5B5B5FFB5B5B5FF252525FF757575FFBBBB
          BBFFBBBBBBFF8D8D8DFFD4D4D4FFB9B9B9FFB9B9B9FFB9B9B9FFB9B9B9FFB9B9
          B9FFB9B9B9FFD3D3D3FF838383FFBBBBBBFFBBBBBBFF2A2A2AFF7A7A7AFFD7D7
          D7FFD7D7D7FF979797FFD8D8D8FFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBF
          BFFFBFBFBFFFD7D7D7FF8E8E8EFFD7D7D7FFD7D7D7FF3F3F3FFF7E7E7EFFF9F9
          F9FFF9F9F9FFABABABFFDFDFDFFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCB
          CBFFCBCBCBFFDFDFDFFFA3A3A3FFF9F9F9FFF9F9F9FF616161FF848484F9FCFC
          FCFFFCFCFCFFCBCBCBFFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
          F2FFF2F2F2FFF2F2F2FFC6C6C6FFFCFCFCFFFCFCFCFF717171FE979797DAD2D2
          D2FFE8E8E8FF7D7D7DFF7D7D7DFF7D7D7DFF7D7D7DFF7D7D7DFF7D7D7DFF7D7D
          7DFF7D7D7DFF7D7D7DFF7D7D7DFFE8E8E8FFC4C4C4FF6D6D6DE1DDDDDDCD9A9A
          9AFFCCCCCCFFC78B4EFFF9F4EDFFFEE8D8FFFEE8D7FFFDE5D3FFFCE4D1FFFAE0
          C7FFF9DDC3FFFAF4EDFFC7854AFFC3C3C3FF747474FFCDCDCDCDFFFFFF00CECE
          CEC2878787F4C5894CFFF9F4EFFFFEE7D7FFFDE7D5FFFCE6D2FFFBE1CCFFF8DC
          C2FFF6DABDFFFAF4EFFFC48348FF616161F4BCBCBCC2FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00C68C4FF9F9F4F0FFFCE6D3FFFDE7D3FFFBE3CDFFFAE0C8FFF5D6
          BBFFF3D4B5FFF8F4F0FFC4854AF9FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00C88D51F7F9F5F1FFFCE3CFFFFCE4CFFFFAE1CAFFF9DDC4FFF4E9
          DFFFF7F2ECFFF5EFE9FFC38048FBFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00C88D52F6F9F5F1FFFCE3CDFFFBE3CDFFF9E0C8FFF8DCC2FFFDFB
          F8FFFCE6CDFFE2B684FFD5A884C5FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00C5884DFAF7F2ECFFF8F4EEFFF8F3EDFFF8F3EDFFF8F2ECFFF2E6
          D7FFE2B27DFFDB9569F6FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00E8CEB9C3D7AA7CCDC88C50FEC88C4FFFCA9155F7CB9055F7C589
          4DFEDDAF8DC1FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        }
        OnClick = btnReportClick
        TabOrder = 1
      end
      object spRaptype: TSpeedButton
        Left = 374
        Height = 21
        Hint = 'Väljundi formaat'
        Top = 13
        Width = 16
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000061CE1BFFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000061CE0E004CA4DA0069
          DE0BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000061CE7E0050A9FF0038
          7777FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000061CE0E0061CEEE0051ADFF0038
          77EA0038770BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000061CE7E0066D7FF0052B0FF0038
          77FF00387777FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF000061CE0E0065D5EE0075F6FF0079FFFF006A
          DFFF004087EA0038770BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF000061CE2E0066D77F0076FB7F0076FB7F0076
          FB7F0069E07F0038772BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        }
        NumGlyphs = 0
        OnClick = spRaptypeClick
        ShowHint = True
        ParentFont = False
        ParentShowHint = False
      end
      object lblPerStart: TLabel
        Left = 6
        Height = 14
        Top = 40
        Width = 98
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Perioodi algus:'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object dtEditStart: TDateEdit
        Left = 106
        Height = 21
        Top = 37
        Width = 95
        CalendarDisplaySettings = [dsShowHeadings, dsShowDayNames]
        OKCaption = 'OK'
        CancelCaption = 'Cancel'
        DateOrder = doNone
        ButtonWidth = 23
        CharCase = ecNormal
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
        NumGlyphs = 0
        MaxLength = 0
        OnExit = dtEditStartExit
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        TabOrder = 2
      end
      object lblPerEnd: TLabel
        Left = 5
        Height = 14
        Top = 63
        Width = 99
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Perioodi lõpp:'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object dtEditEnd: TDateEdit
        Left = 106
        Height = 21
        Top = 60
        Width = 95
        CalendarDisplaySettings = [dsShowHeadings, dsShowDayNames]
        OKCaption = 'OK'
        CancelCaption = 'Cancel'
        DateOrder = doNone
        ButtonWidth = 23
        CharCase = ecNormal
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
        NumGlyphs = 0
        MaxLength = 0
        OnExit = dtEditStartExit
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        TabOrder = 3
      end
      object chkboxsortOrderAZ: TCheckBox
        Tag = 1
        Left = 297
        Height = 17
        Top = 42
        Width = 82
        Caption = 'Järjestus A-Z'
        Checked = True
        OnChange = chkboxsortOrderAZChange
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        State = cbChecked
        TabOrder = 5
        TabStop = False
      end
      object edtSrcAccount: TEdit
        Left = 106
        Height = 21
        Top = 107
        Width = 284
        Anchors = [akTop, akLeft, akRight]
        AutoSelect = False
        Constraints.MaxWidth = 500
        HideSelection = False
        OnKeyPress = edtSrcAccountKeyPress
        TabOrder = 6
      end
      object srcImage: TImage
        Left = 70
        Height = 25
        Top = 107
        Width = 25
        Picture.Data = {
          1754506F727461626C654E6574776F726B477261706869632904000089504E47
          0D0A1A0A0000000D494844520000001A0000001A08020000002628DB99000000
          097048597300000B1200000B1201D2DD7EFC000003B549444154789C9DD4FD4F
          DA681C00F0FD8FCB12DDEEB265714BF43618EAB5D0FA429FD6D6B6BC4EB83334
          8A7AC1608EA146DD9891CD9D4027CB91E804A34191E8CDA9C035DAF1D2DAA7F7
          03C99DBB4D44BF3F3FDFCF37DF973CB7F4E6024258AD5665593E3B3B93655955
          D5EF3EBBD58C2549D2D6D6D6F2F2F2ECEC6C28149A99991145717777B752A95C
          8F5355359FCF2F2C2C78BD5EBBDDCE711CCBB28383832CCB7A3C9E4824522C16
          9BE5CECFCF0F0E0EC2E1B0D3E9641806C77104415014C5711C00405114C330E3
          E3E3A7A7A74D718787878140C0E170D0344D10442A9592244992A4D5D5559224
          098200000000A6A6A66AB5DA159CAAAAF3F3F30E8783A2280CC352A954AD56CB
          6E6FEFE7F39AA6D52BD1346DB55A49928CC5625770C5627178789861189EE713
          8984AEEB27C7C73C4D4F8C8EAA8AA2EBFAD1D191DFEF0700F4F4F40483C172B9
          DC885B5F5F773A9D56AB757171515194ECF676F2FDFB5E1475715C269DFEEBE0
          0042188BC5789EC771DCE572EDEFEF37E2E2F138CFF37D7D7DA22842089FB5B7
          B73F7CF8E39D3B0F5A5A7E6A6BFBF5F9735555B3D9ECD0D010866124496E6E6E
          36E262B118C771FDFDFD2B2B2B9AA6AD8AE2EB972FCD26134310B177EF363319
          08E1CECE8ED7EBB5582C00802BB8B5B53596650982F0F97CA55249D7F5E3A3A3
          4100FC82509F1D8430994CBA5C2E14456D36DB15CD964A25BBDD4E51546F6FEF
          DCDC9CAEEBE572F9CF0F1F36D3694DD3745D2F140AA1500800D0D5D5E5F7FBAB
          D56A234E5194C9C9498AA24892A4282A9148689A06350D42582F168D466D369B
          C5624110241E8FD7B32EE52084B9DD5D1BCF0382200882A66941109696964451
          8C44223E9F8FA228B3D96C341AC7C6C6FECDBA94FB22CB732F5E380606109309
          C7F1FAB9D234CD304CFD7A1104311A8D6EB75B92A4ABB95432391D0C021C6FBD
          7D1BB758300C4351D46C36A328DADDDD6D3018300C0B87C38542E162D6F7B95C
          363BE1F3FD62B73F7DFC1847D1F4C64626930985422E978BE3384110A2D1E8DE
          DE5E7DFC8D3808E1E74F9F7E0F043882400C86674F9E6C7CFC08218410AAAA5A
          ABD5AAD5AAA228F5E57E1BFFE7E4B3B395376F2604A11F45EFDFBDFBFAD5ABFA
          2A9B8CAF38555553C9646064C4CDB2F75B5B3D6EF7C5BFECDA5C3E97133C1ED6
          6A7DFAE851B7C9747272722DEB2BEE8B2C4F078393A3A39D1D1D0FEEDD4B6F6C
          5CD7FA8FAB542AD148243836867576FED0D232333DAD28CACDB962A1F0DBC8C8
          404F4F475B9BC7EDFEBB54BA81A55F6C3697CDFEF1F6EDCF26D35E2E77334BFF
          76B39F0F0F2FBBA966E21F0652CF2965E8EE230000001A74455874417574686F
          7200556C6561642053797374656D732C20496E632EC91D3E760000000049454E
          44AE426082
        }
        Transparent = True
      end
      object repAccounts: TListView
        Left = 106
        Height = 266
        Top = 129
        Width = 284
        Anchors = [akTop, akLeft, akRight, akBottom]
        Checkboxes = True
        Columns = <        
          item
            Caption = 'Konto'
            ImageIndex = 10
            MaxWidth = 85
            Width = 85
          end        
          item
            Caption = 'Nimetus'
            ImageIndex = 11
            MaxWidth = 250
            Width = 175
          end>
        Constraints.MaxWidth = 600
        HideSelection = False
        PopupMenu = pAccListPopup
        ReadOnly = True
        RowSelect = True
        SmallImages = dmodule.sharedImages
        SortType = stText
        TabOrder = 7
        ViewStyle = vsReport
        OnAdvancedCustomDrawItem = repAccountsAdvancedCustomDrawItem
        OnClick = repAccountsClick
        OnColumnClick = repAccountsColumnClick
        OnCompare = repAccountsCompare
        OnItemChecked = repAccountsItemChecked
        OnKeyPress = cmbPreDefPerKeyPress
        OnMouseDown = repAccountsMouseDown
      end
      object chkboxNoZLines: TCheckBox
        Tag = -1
        Left = 106
        Height = 17
        Top = 86
        Width = 110
        Caption = '0 ridu mitte kuvada'
        Checked = True
        State = cbChecked
        TabOrder = 4
        Visible = False
      end
    end
    object Splitter1: TSplitter
      Left = 394
      Height = 397
      Top = 0
      Width = 5
    end
    object prightPanel: TPanel
      Left = 399
      Height = 397
      Top = 0
      Width = 271
      Align = alClient
      BevelOuter = bvNone
      ClientHeight = 397
      ClientWidth = 271
      Constraints.MinWidth = 150
      TabOrder = 2
      object chkBoxAccObj: TCheckBox
        Left = 37
        Height = 17
        Top = 184
        Width = 224
        AutoSize = False
        Caption = ' Objektid'
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        TabOrder = 6
        Visible = False
      end
      object chkBoxAccPartner: TCheckBox
        Left = 37
        Height = 17
        Top = 160
        Width = 224
        AutoSize = False
        Caption = ' Osapool'
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        TabOrder = 5
        Visible = False
      end
      object chkBoxAccShowCurr: TCheckBox
        Left = 37
        Height = 17
        Top = 136
        Width = 224
        AutoSize = False
        Caption = ' Valuuta summad'
        Checked = True
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        State = cbChecked
        TabOrder = 4
        Visible = False
      end
      object chkBoxAccDescr: TCheckBox
        Left = 37
        Height = 17
        Top = 112
        Width = 224
        AutoSize = False
        Caption = ' Selgitus'
        Checked = True
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        State = cbChecked
        TabOrder = 3
      end
      object chkBoxAccDocnr: TCheckBox
        Left = 37
        Height = 17
        Top = 88
        Width = 224
        AutoSize = False
        Caption = ' Dokumendi nr.'
        Checked = True
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        State = cbChecked
        TabOrder = 2
      end
      object chkBoxAccDate: TCheckBox
        Left = 37
        Height = 17
        Top = 64
        Width = 224
        AutoSize = False
        Caption = ' Kande kuupäev'
        Checked = True
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        State = cbChecked
        TabOrder = 1
      end
      object chkBoxAccNr: TCheckBox
        Left = 37
        Height = 17
        Top = 40
        Width = 224
        AutoSize = False
        Caption = ' Kande nr'
        Checked = True
        OnKeyPress = cmbPreDefPerKeyPress
        ParentFont = False
        State = cbChecked
        TabOrder = 0
      end
      object lblDispl: TLabel
        Left = 17
        Height = 14
        Top = 16
        Width = 61
        Caption = '- Kuvame: '
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object repObjects: TListView
        Left = 17
        Height = 187
        Top = 208
        Width = 249
        Anchors = [akTop, akLeft, akRight, akBottom]
        Checkboxes = True
        Columns = <        
          item
            Caption = 'Objektid'
            MaxWidth = 245
            Width = 245
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        SortType = stText
        TabOrder = 7
        ViewStyle = vsReport
        OnAdvancedCustomDrawItem = repAccountsAdvancedCustomDrawItem
        OnCompare = repAccountsCompare
        OnItemChecked = repAccountsItemChecked
        OnKeyPress = cmbPreDefPerKeyPress
      end
    end
  end
  object popupReportType: TPopupMenu
    left = 632
    top = 216
    object mnuItemScreen: TMenuItem
      Caption = 'Ekraanile'
      Checked = True
      OnClick = mnuItemScreenClick
    end
    object mnuItemPdfFile: TMenuItem
      Caption = 'PDF faili'
      OnClick = mnuItemScreenClick
    end
    object mnuItemCsv: TMenuItem
      Caption = 'CSV faili'
      OnClick = mnuItemScreenClick
    end
  end
  object qryGetReportData: TZQuery
    AutoCalcFields = False
    CachedUpdates = True
    Params = <>
    left = 624
    top = 32
  end
  object report: TfrReport
    Dataset = reportdata
    InitialZoom = pzDefault
    Options = []
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    DataType = dtDataSet
    OnBeginBand = reportBeginBand
    OnEndBand = reportEndBand
    OnGetValue = reportGetValue
    OnEnterRect = reportEnterRect
    left = 464
    top = 32
    ReportForm = {
      19000000
    }
  end
  object reportdata: TfrDBDataSet
    DataSet = qryGetReportData
    left = 632
    top = 152
  end
  object saveRep: TSaveDialog
    Title = 'Salvestame'
    DefaultExt = '.*.pdf'
    left = 520
    top = 32
  end
  object pAccListPopup: TPopupMenu
    left = 632
    top = 280
    object pItemRemAllChk: TMenuItem
      OnClick = pItemRemAllChkClick
    end
    object pItemMarkAllChk: TMenuItem
      OnClick = pItemMarkAllChkClick
    end
  end
  object qryAccounts: TZQuery
    AutoCalcFields = False
    CachedUpdates = True
    Params = <>
    left = 632
    top = 96
  end
  object srcListDelaydFocus: TTimer
    Enabled = False
    Interval = 100
    OnTimer = srcListDelaydFocusTimer
    left = 632
    top = 352
  end
  object qryObjects: TZQuery
    AutoCalcFields = False
    Params = <>
    left = 560
    top = 96
  end
end
