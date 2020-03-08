object frameBillList: TframeBillList
  Left = 0
  Height = 433
  Top = 0
  Width = 699
  ClientHeight = 433
  ClientWidth = 699
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  DesignLeft = 274
  DesignTop = 258
  object grpBoxObjects: TGroupBox
    Left = 3
    Height = 177
    Top = 3
    Width = 693
    Anchors = [akTop, akLeft, akRight]
    Caption = ' Arvete nimekiri'
    ClientHeight = 159
    ClientWidth = 689
    Color = clBtnFace
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object btnOpenClientList: TBitBtn
      Left = 209
      Height = 21
      Top = 7
      Width = 16
      Cancel = True
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
      OnClick = btnOpenClientListClick
      TabOrder = 1
    end
    object edtClientCode: TEdit
      Left = 112
      Height = 21
      Top = 7
      Width = 95
      MaxLength = 10
      OnExit = edtClientCodeExit
      OnKeyDown = edtClientCodeKeyDown
      OnKeyPress = edtClientCodeKeyPress
      TabOrder = 0
    end
    object lblCustId: TLabel
      Left = 2
      Height = 14
      Top = 10
      Width = 106
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Klient/Hankija id:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lblAccDate: TLabel
      Left = 2
      Height = 14
      Top = 33
      Width = 106
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Kande kuupäev:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object dtEdtAccDate: TDateEdit
      Left = 112
      Height = 21
      Top = 30
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
      MaxLength = 20
      OnExit = dtEdtAccDateExit
      OnKeyPress = edtClientCodeKeyPress
      TabOrder = 2
    end
    object lblAccNr: TLabel
      Left = 234
      Height = 14
      Top = 33
      Width = 157
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Kande nr:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object edtAccRecnr: TEdit
      Left = 395
      Height = 21
      Top = 30
      Width = 152
      MaxLength = 45
      OnKeyPress = edtClientCodeKeyPress
      TabOrder = 3
    end
    object lblBillDate: TLabel
      Left = 2
      Height = 14
      Top = 56
      Width = 106
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Arve kuupäev:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object edtEdtBillDate: TDateEdit
      Left = 112
      Height = 21
      Top = 53
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
      MaxLength = 20
      OnExit = dtEdtAccDateExit
      OnKeyPress = edtClientCodeKeyPress
      TabOrder = 4
    end
    object lblBillNr: TLabel
      Left = 234
      Height = 14
      Top = 56
      Width = 157
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Arve nr:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object edtBillNr: TEdit
      Left = 395
      Height = 21
      Top = 53
      Width = 152
      MaxLength = 45
      OnKeyPress = edtClientCodeKeyPress
      TabOrder = 5
    end
    object edtCustNameAndAddr: TEdit
      Tag = -1
      Left = 235
      Height = 21
      Top = 7
      Width = 312
      Color = cl3DLight
      ReadOnly = True
      TabStop = False
      TabOrder = 11
    end
    object btnSrc: TBitBtn
      Tag = -1
      Left = 552
      Height = 30
      Top = 6
      Width = 110
      Caption = 'Otsi'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000064000000640000000000000000000000FFFFFF008588
        87FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A
        88FF858A88FF858A88FF858A88FF858A88FF949695FFFFFFFF00898C8BFFBBBC
        BBFFE5E5E5FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE1E2E2FFB6B7B7FF878A88FF858A88FFEBEB
        EAFFD0CFCFFFCFCFCFFFCBCBCBFFCCCBCBFFCBCCCCFFCCCBCCFFCCCCCCFFD0CF
        D0FFD0CFD0FFD0CFD0FFD0D0D0FFD3D4D3FFEBEAEAFF858A88FF858A88FFFFFF
        FFFFD6D6D6FF969696FF959696FF969696FF969596FF969696FF959596FF9696
        96FF969696FF969695FF959696FFD6D5D6FFEFEEEEFF858A88FF858A88FFFFFF
        FFFFDDDDDCFFDDDDDDFFDDDCDDFFDDDDDDFFDDDDDCFFDDDCDDFFD8D8D8FFD7D7
        D8FFD8D8D8FFD8D8D8FFD8D8D8FFDDDDDDFFF3F3F3FF858A88FF858A88FFFFFF
        FFFFE3E3E3FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFE3E3E3FFA1A1A1FFA1A1
        A1FFA1A1A1FFA1A1A1FFA1A1A1FFE3E3E3FFF9F9F9FF858A88FF858A88FFFFFF
        FFFFE3E3E3FFA0A0A0FFBEBEBEFFBEBEBEFFA0A0A0FFE3E3E3FFE3E3E3FFE3E3
        E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFFFFFFFFF858A88FF858A88FFFFFF
        FFFFE9E9E9FFA0A0A0FFBEBEBEFFBEBEBEFFA0A0A0FFE9E9E9FFA0A0A0FFA0A0
        A0FFA0A0A0FFA0A0A0FFA0A0A0FFE9E9E9FFFFFFFFFF858A88FF858A88FFFFFF
        FFFFE9E9E9FFA0A0A0FFBEBEBEFFBEBEBEFFA0A0A0FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFFFFFFFFF858A88FF858A88FFFFFF
        FFFFE9E9E9FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFE9E9E9FFA0A0A0FFA0A0
        A0FFA0A0A0FFA0A0A0FFA0A0A0FFE9E9E9FFFFFFFFFF858A88FF858A88FFFFFF
        FFFFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFFFFFFFFF858A88FF858A88FFFFFF
        FFFFE9E9E9FF6C6C6CFF6C6C6CFF6C6C6CFF6C6C6CFF6C6C6CFF6C6C6CFFE9E9
        E9FFE9E9E9FFA0A0A0FFA0A0A0FFE9E9E9FFFFFFFFFF858A88FF858A88FFFFFF
        FFFFE9E9E9FF6C6C6CFF6C6C6CFFA0A0A0FF6C6C6CFF6C6C6CFFA0A0A0FFE9E9
        E9FFE9E9E9FFA0A0A0FFA0A0A0FFE9E9E9FFFFFFFFFF858A88FF858A88FFFFFF
        FFFFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFFFFFFFFF858A88FF858A88FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF858A88FF858A88FF858A
        88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A
        88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      }
      OnClick = btnSrcClick
      TabOrder = 12
    end
    object btnClean: TBitBtn
      Tag = -1
      Left = 552
      Height = 30
      Top = 38
      Width = 110
      Caption = 'Puhasta'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00008B9C1F008C9DED008D9EEC008D
        9E9E008B9C21FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00008B9C13008D9EE24FC3D2FD5BD3E1FF30B5
        C6FA0890A1F6008D9FA9008B9C14FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00008E9FC536B5C5FA5FD8E7FF26CADFFF4ED4
        E5FF6DD9E7FF32B4C5FB008D9EE6008B9C26FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00008B9C431A9BABF66CDAE8FF10C5DCFF03C2DAFF03C2
        DAFF15C6DCFF5BD7E7FF56C8D6FE058FA0F1008B9C3FFFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00018EA0D45ECFDDFF46DAEDFF18D0E7FF11CBE3FF07C4
        DCFF03C2DAFF03C2DAFF4CD3E4FF58CDDCFF048E9FF4008B9C1CFFFFFF00FFFF
        FF00FFFFFF00008B9C1A1194A5F78BEDFBFF3CE5FCFF37E4FBFF2FDEF6FF23D7
        EEFF14CDE5FF04C3DBFF03C2DAFF56D6E6FF33B6C6FB008E9FA8FFFFFF00FFFF
        FF00FFFFFF00007F9C5F2FB0C0F58AEFFDFF5FEAFDFF61EBFDFF52E9FDFF3CE6
        FDFF2ADBF3FF18D0E7FF10C6DCFF49D2E4FF67D4E2FF018D9FE9FFFFFF00FFFF
        FF00008B9C070024A1D71342ADFC84EAFBFF6BECFDFF84EFFDFF6DECFDFF52E9
        FDFF44E5FBFF65E3F3FF77DDEBFF49C1CFFE1B9EAEF3008C9DEAFFFFFF00008B
        9C5F008D9EEB29A5BBF6284ABBFF1D38B8FF61D8F6FF63EAFDFF6CEBFDFF7DEE
        FDFF88EAF8FF45BECDFA058F9FF7008E9FA3008B9C40008B9C02FFFFFF00008B
        9C5A018D9EF64FC8D8FF68DCECFF336DC8FF0D1BABFF62B1D7FF72DCEAFF43BD
        CCF70990A2F6018E9F9F008B9C1BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF000064878100889CFE41BDCDFF77DEEBFF1769B0F70036A0E4018FA0D2008C
        9D77008B9C15FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000487802004A
        7B95014E80F40B76B2FF0188A1FF32AEBEFE1DA0B1F2008B9C3DFFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000049796F0352
        86F40F7ABCFF107DC1FF015284F200859ACE008B9CFF008B9C29FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00004A7BED0C72
        B2FF107DC1FF0A6BA9FF004A7BDA00698A02008B9C82008B9C13FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00004A7BE50A69
        A6FF0B6DABFF004A7BF500487844FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000048783B004B
        7CDA004A7BE300487847FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      }
      OnClick = btnCleanClick
      TabOrder = 13
    end
    object lblBillTypes: TLabel
      Left = 2
      Height = 14
      Top = 83
      Width = 106
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Arve tüübid:'
      ParentColor = False
    end
    object chkbxSaleBill: TCheckBox
      Left = 122
      Height = 17
      Top = 82
      Width = 85
      Caption = 'Müügiarved'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object chkbxPurchBill: TCheckBox
      Left = 122
      Height = 17
      Top = 99
      Width = 77
      Caption = 'Ostuarved'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object chkbxCreditBill: TCheckBox
      Left = 122
      Height = 17
      Top = 116
      Width = 92
      Caption = 'Kreeditarved'
      TabOrder = 9
    end
    object chkbxPrepaymentBill: TCheckBox
      Left = 122
      Height = 17
      Top = 133
      Width = 112
      Caption = 'Ettemaksuarved'
      TabOrder = 10
    end
    object lblStatus: TLabel
      Left = 234
      Height = 14
      Top = 79
      Width = 157
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Staatus:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object cmbStaatus: TComboBox
      Left = 395
      Height = 21
      Top = 76
      Width = 152
      ItemHeight = 13
      OnKeyPress = edtClientCodeKeyPress
      Style = csDropDownList
      TabOrder = 6
    end
    object Bevel1: TBevel
      Left = 117
      Height = 67
      Top = 83
      Width = 4
      Shape = bsLeftLine
    end
    object btnPrint: TBitBtn
      Tag = -1
      Left = 552
      Height = 30
      Top = 70
      Width = 110
      Caption = 'Prindi'
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
      OnClick = btnPrintClick
      TabOrder = 14
    end
    object btnNewBill: TBitBtn
      Tag = -1
      Left = 552
      Height = 30
      Top = 109
      Width = 110
      Caption = '&Uus arve'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000064000000640000000000000000000000FFFFFF00BB6A
        346BBA6530BCBB6631EDBA6630F7BA6630F7BA6630F7BA6530F7BA652FF7B965
        2EF7B9652EF7B9642EF7B9642EEFB7622CBDB7622E63FFFFFF00FFFFFF00BC69
        33DEF8F1EAF2F7ECDFFDF6EBDEFFF6EADEFFF6EADCFFF6EADCFFFAF3EBFFFAF3
        EBFFFAF2EAFFFCF7F3FFFCF8F4FDFEFEFDF0B7602AD5FFFFFF00FFFFFF00BF71
        38F5F5EBDFFEFDBF68FFFCBD67FFFBBE65FFFCBE64FFFCBE64FFFCBD62FFFBBD
        63FFFBBC61FFFCBE60FFFCBC62FFFDFBF8FDB9642DF3FFFFFF00FFFFFF00C178
        3CF7F7EDE3FFFDC26EFFFFD8A0FFFFD79EFFFFD69BFFFFD798FFFFD696FFFFD6
        95FFFFD594FFFFD493FFFBBE65FFFBF7F4FFBB6731F7FFFFFF00FFFFFF00C47C
        40F7F7F0E6FFF8B455FFF7B456FFF7B554FFF8B453FFF8B253FFF7B352FFF7B3
        52FFF7B251FFF7B24FFFF7B24FFFFCF9F5FFBF6F36F7FFFFFF00FFFFFF00C580
        42F7F8F1E8FFFEE5D5FFFDE5D3FFFDE5D3FFFCE5D3FFFCE5D3FFFCE4D1FFFCE2
        CEFFFCE2CCFFFBE0C9FFFBE1C8FFFDFAF7FFC1763BF7FFFFFF00FFFFFF00C582
        45F7F8F2EBFFFEE7D6FFFDE7D6FFFDE7D6FFFDE7D6FFFDE6D5FFFDE5D3FFFCE4
        D1FFFCE2CDFFFBE1CBFFFBE1C9FFFBF7F2FFC57C3FF7FFFFFF00FFFFFF00C684
        47F7F9F3ECFFFEE8D6FFFEE8D7FFFDE7D6FFFDE7D6FFFDE7D5FFFDE5D3FFFBE4
        D0FFFBE3CCFFFADFC7FFFADFC6FFFAF2EAFFC68042F7FFFFFF00FFFFFF00C688
        49F7F9F4EDFFFEE8D8FFFEE8D8FFFEE8D7FFFEE7D6FFFDE5D3FFFCE4D1FFFBE1
        CCFFFAE0C7FFF9DDC3FFF8DCC2FFFAF4EDFFC68245F7FFFFFF00FFFFFF00C688
        4AF7F9F4EFFFFEE7D7FFFDE7D6FFFDE7D5FFFDE6D4FFFCE6D2FFFBE1CCFFFADF
        C7FFF8DCC2FFF6DABDFFF6D8BBFFFAF4EFFFC68346F7FFFFFF00FFFFFF00C689
        4BF7F9F4F0FFFCE6D3FFFCE6D4FFFDE7D3FFFCE4D1FFFBE3CDFFFAE0C8FFF8DC
        C2FFF5D6BBFFF3D4B5FFF1D2B3FFF8F4F0FFC48246F7FFFFFF00FFFFFF00C689
        4BF7F9F5F1FFFCE3CFFFFBE4D0FFFCE4CFFFFCE3CDFFFAE1CAFFF9DDC4FFF6D9
        BCFFF4E9DFFFF7F2ECFFFBF7F3FFF5EFE9FFC27E45FBFFFFFF00FFFFFF00C689
        4CF6F9F5F1FFFCE3CDFFFBE3CEFFFBE3CDFFFBE2CBFFF9E0C8FFF8DCC2FFF5D6
        BAFFFDFBF8FFFCE6CDFFFAE5C9FFE2B684FFBF7942A6FFFFFF00FFFFFF00C588
        4BEAFAF6F2FCFAE0C7FFFBE1C9FFFBE2C9FFFBE0C8FFF9DFC5FFF8DBC1FFF4D6
        B8FFFFFBF8FFF6D8B4FFE1B07DFFDB9264F6B46B3E07FFFFFF00FFFFFF00C485
        49C3F7F2ECECF8F4EEFCF8F4EDFFF8F3EDFFF8F3EDFFF8F3EDFFF8F2ECFFF7F2
        ECFFF2E6D7FFE2B27DFFDB9465F5B3683B07FFFFFF00FFFFFF00FFFFFF00C17D
        4460C88B4DBBC88C4FEEC88C4FF6C88C4FF7C88C4FF7C88D4FF7C98C4FF7C78B
        4FF7C5894BD4C4763B91B3683C06FFFFFF00FFFFFF00FFFFFF00
      }
      OnClick = btnNewBillClick
      TabOrder = 15
    end
    object Bevel2: TBevel
      Left = 552
      Height = 8
      Top = 103
      Width = 110
      Shape = bsTopLine
    end
    object Bevel3: TBevel
      Left = 552
      Height = 8
      Top = 105
      Width = 110
      Shape = bsTopLine
    end
    object Bevel4: TBevel
      Left = 552
      Height = 8
      Top = 142
      Width = 110
      Shape = bsTopLine
    end
    object Bevel5: TBevel
      Left = 552
      Height = 8
      Top = 144
      Width = 110
      Shape = bsTopLine
    end
  end
  object btnClose: TBitBtn
    Tag = -1
    Left = 596
    Height = 30
    Top = 388
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
  object parentPanel: TPanel
    Left = 3
    Height = 188
    Top = 176
    Width = 693
    Anchors = [akTop, akLeft, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ClientHeight = 188
    ClientWidth = 693
    Color = clInactiveCaptionText
    ParentColor = False
    TabOrder = 2
    object billsGrid: TDBGrid
      Left = 3
      Height = 182
      Top = 3
      Width = 687
      Anchors = [akTop, akLeft, akRight, akBottom]
      Color = clWindow
      Columns = <      
        item
          Title.Caption = 'Kande nr'
          Width = 69
          FieldName = 'accentry_nr'
        end      
        item
          Title.Caption = 'Kande kp.'
          Width = 70
          FieldName = 'accentry_date'
        end      
        item
          Title.Caption = 'Tüüp'
          Width = 65
          FieldName = 'bill_type'
        end      
        item
          Title.Caption = 'Arve nr.'
          Width = 80
          FieldName = 'bill_number'
        end      
        item
          Title.Caption = 'Arve kp.'
          Width = 70
          FieldName = 'bill_date'
        end      
        item
          Title.Caption = 'Klient'
          Width = 175
          FieldName = 'cust_name'
        end      
        item
          Title.Caption = 'Tähtaeg'
          Width = 70
          FieldName = 'due_date'
        end      
        item
          Alignment = taRightJustify
          Title.Caption = 'Summa'
          Width = 70
          FieldName = 'totalsum'
        end      
        item
          Alignment = taRightJustify
          Title.Caption = 'Tasutud'
          FieldName = 'incomesum'
        end      
        item
          Title.Caption = 'Tasuda'
          FieldName = 'to_pay2'
        end      
        item
          Title.Caption = 'Valuuta'
          Width = 45
          FieldName = 'currency'
        end      
        item
          Title.Caption = 'E-kiri'
          Width = 35
          FieldName = 'isemailsent'
        end>
      DataSource = qryBillSrcDs
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 0
      TitleStyle = tsNative
      OnDrawColumnCell = billsGridDrawColumnCell
      OnDblClick = billsGridDblClick
      OnKeyDown = billsGridKeyDown
      OnKeyPress = billsGridKeyPress
      OnPrepareCanvas = billsGridPrepareCanvas
    end
  end
  object qryBillSrc: TZQuery
    AutoCalcFields = False
    OnCalcFields = qryBillSrcCalcFields
    Params = <>
    left = 32
    top = 216
  end
  object qryBillSrcDs: TDatasource
    DataSet = qryBillSrc
    left = 32
    top = 280
  end
  object report: TfrReport
    InitialZoom = pzDefault
    Options = []
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    DataType = dtDataSet
    OnGetValue = reportGetValue
    left = 112
    top = 216
    ReportForm = {
      19000000
    }
  end
  object repdata: TfrDBDataSet
    DataSet = qryBillSrc
    left = 112
    top = 280
  end
end
