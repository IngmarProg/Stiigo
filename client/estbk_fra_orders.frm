object frameOrders: TframeOrders
  Left = 0
  Height = 508
  Top = 0
  Width = 793
  ClientHeight = 508
  ClientWidth = 793
  TabOrder = 0
  DesignLeft = 186
  DesignTop = 352
  object grpOrder: TGroupBox
    Left = 5
    Height = 321
    Top = 4
    Width = 782
    Anchors = [akTop, akLeft, akRight]
    Caption = 'grpOrder'
    ClientHeight = 303
    ClientWidth = 778
    TabOrder = 6
    object pMainPanel: TPanel
      Left = 0
      Height = 303
      Top = 0
      Width = 778
      Align = alClient
      Anchors = [akTop, akLeft, akRight]
      BevelOuter = bvNone
      ClientHeight = 303
      ClientWidth = 778
      TabOrder = 0
      object pOrderData: TPanel
        Left = 1
        Height = 128
        Top = 4
        Width = 376
        BevelOuter = bvNone
        ClientHeight = 128
        ClientWidth = 376
        TabOrder = 4
        object lblSec1: TLabel
          Left = 8
          Height = 18
          Top = 5
          Width = 364
          Alignment = taCenter
          AutoSize = False
          Caption = 'Tellimus'
          Color = clActiveBorder
          Layout = tlCenter
          ParentColor = False
          Transparent = False
        end
        object bh1: TBevel
          Left = 370
          Height = 20
          Top = 5
          Width = 6
          Shape = bsLeftLine
        end
        object bv1: TBevel
          Left = 8
          Height = 4
          Top = 23
          Width = 364
          Shape = bsTopLine
        end
        object edtVerifOrdernr: TEdit
          Left = 264
          Height = 21
          Hint = 'Hankija poolt kinnitatud tellimuse nr'
          Top = 32
          Width = 101
          OnKeyPress = edtVerifOrdernrKeyPress
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Visible = False
        end
        object lblVerifOrdernr: TLabel
          Left = 233
          Height = 14
          Top = 35
          Width = 23
          Caption = 'k.nr'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Visible = False
        end
        object edtOrderNr: TEdit
          Tag = -1
          Left = 126
          Height = 21
          Top = 32
          Width = 95
          Color = cl3DLight
          ReadOnly = True
          TabStop = False
          TabOrder = 1
        end
        object lblOrdNr: TLabel
          Left = 8
          Height = 14
          Top = 35
          Width = 116
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nr:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object lblOrdDt: TLabel
          Left = 8
          Height = 14
          Top = 58
          Width = 116
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kuupäev:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object dbOrderDate: TDateEdit
          Left = 126
          Height = 21
          Top = 55
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
          OnExit = dbOrderDateExit
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 2
        end
        object lblPrepaimentDue: TLabel
          Left = 8
          Height = 14
          Top = 83
          Width = 116
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Ettemaksu tähtaeg:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object dbPrePaymentDuedate: TDateEdit
          Left = 126
          Height = 21
          Top = 80
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
          OnExit = dbOrderDateExit
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 3
        end
        object lblPrepaymentPerc: TLabel
          Left = 8
          Height = 14
          Top = 106
          Width = 116
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Ettemaksu %:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtPrepaymentPerc: TEdit
          Left = 126
          Height = 21
          Top = 104
          Width = 64
          MaxLength = 3
          OnKeyPress = edtVerifOrdernrKeyPress
          ReadOnly = True
          TabOrder = 4
          Text = '50'
        end
      end
      object pSupplPanel: TPanel
        Left = 1
        Height = 152
        Top = 84
        Width = 376
        BevelOuter = bvNone
        ClientHeight = 152
        ClientWidth = 376
        TabOrder = 0
        object lblSec2: TLabel
          Left = 8
          Height = 18
          Top = 5
          Width = 364
          Alignment = taCenter
          AutoSize = False
          Caption = 'Hankija'
          Color = clActiveBorder
          Layout = tlCenter
          ParentColor = False
          Transparent = False
        end
        object bv3: TBevel
          Left = 8
          Height = 5
          Top = 23
          Width = 363
          Shape = bsTopLine
        end
        object bh3: TBevel
          Left = 370
          Height = 20
          Top = 5
          Width = 5
          Shape = bsLeftLine
        end
        object lblSupplId: TLabel
          Left = 22
          Height = 14
          Top = 31
          Width = 100
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Tunnus:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtSupplierCode: TEdit
          Left = 126
          Height = 21
          Top = 28
          Width = 94
          MaxLength = 10
          OnExit = edtSupplierCodeExit
          OnKeyDown = edtSupplierCodeKeyDown
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 0
        end
        object btnOpenClientList: TBitBtn
          Left = 220
          Height = 21
          Top = 27
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
          OnClick = btnOpenClientListClick
          TabOrder = 1
        end
        object lbSupplMiscContact: TLabel
          Left = 22
          Height = 14
          Top = 53
          Width = 100
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kontakt:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtSupplMiscContact: TEdit
          Tag = -1
          Left = 126
          Height = 21
          Top = 51
          Width = 234
          Color = cl3DLight
          ReadOnly = True
          TabStop = False
          TabOrder = 2
        end
        object lblSupplAddr: TLabel
          Left = 22
          Height = 14
          Top = 77
          Width = 100
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kontaktisik:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbSupplCont: TComboBox
          Left = 126
          Height = 21
          Top = 74
          Width = 234
          Color = cl3DLight
          ItemHeight = 13
          OnChange = cmbSupplContChange
          OnKeyPress = edtVerifOrdernrKeyPress
          Style = csDropDownList
          TabOrder = 3
          TabStop = False
        end
        object lblCPersonEmail: TLabel
          Left = 22
          Height = 14
          Top = 100
          Width = 100
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'E-post:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtCPersonEmail: TEdit
          Tag = -1
          Left = 126
          Height = 21
          Top = 97
          Width = 234
          Color = cl3DLight
          ReadOnly = True
          TabStop = False
          TabOrder = 4
        end
        object lblCPersonPhone: TLabel
          Left = 22
          Height = 14
          Top = 124
          Width = 100
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Telefon:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtCPersonPhone: TEdit
          Tag = -1
          Left = 126
          Height = 21
          Top = 120
          Width = 234
          Color = cl3DLight
          ReadOnly = True
          TabStop = False
          TabOrder = 5
        end
      end
      object pOrderChannelPanel: TPanel
        Left = 1
        Height = 136
        Top = 236
        Width = 376
        BevelOuter = bvNone
        ClientHeight = 136
        ClientWidth = 376
        TabOrder = 1
        object lblSec4: TLabel
          Left = 7
          Height = 18
          Top = 6
          Width = 364
          Alignment = taCenter
          AutoSize = False
          Caption = 'Tellimuse esitamise kanal'
          Color = clActiveBorder
          Layout = tlCenter
          ParentColor = False
          Transparent = False
        end
        object bv4: TBevel
          Left = 7
          Height = 8
          Top = 24
          Width = 364
          Shape = bsTopLine
        end
        object bh4: TBevel
          Left = 370
          Height = 20
          Top = 6
          Width = 3
          Shape = bsLeftLine
        end
        object lblChannelType: TLabel
          Left = 10
          Height = 14
          Top = 35
          Width = 108
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kanali tüüp:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbChannelType: TComboBox
          Left = 122
          Height = 21
          Top = 32
          Width = 194
          AutoComplete = True
          AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactSearchAscending]
          ItemHeight = 13
          OnKeyPress = edtVerifOrdernrKeyPress
          Style = csDropDownList
          TabOrder = 0
        end
        object lblChannel: TLabel
          Left = 10
          Height = 14
          Top = 57
          Width = 108
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kanali aadress:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtChannelUsed: TEdit
          Left = 122
          Height = 21
          Top = 55
          Width = 229
          MaxLength = 300
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 1
        end
        object lblOrderAddedBy: TLabel
          Left = 10
          Height = 14
          Top = 79
          Width = 108
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Tellimuse koostas:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbOrderPlacedBy: TComboBox
          Left = 122
          Height = 21
          Top = 78
          Width = 194
          AutoComplete = True
          AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactSearchAscending]
          ItemHeight = 13
          OnKeyPress = edtVerifOrdernrKeyPress
          Style = csDropDownList
          TabOrder = 2
        end
        object lblOrderToWarehouse: TLabel
          Left = 10
          Height = 14
          Top = 104
          Width = 108
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Ladu:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbWarehouse: TComboBox
          Left = 122
          Height = 21
          Top = 101
          Width = 194
          AutoComplete = True
          AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactSearchAscending]
          ItemHeight = 13
          OnKeyPress = edtVerifOrdernrKeyPress
          Style = csDropDownList
          TabOrder = 3
        end
      end
      object pactPanel: TPanel
        Left = 390
        Height = 48
        Top = 268
        Width = 376
        BevelOuter = bvNone
        ClientHeight = 48
        ClientWidth = 376
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 3
        Visible = False
        object lblActionToPerform: TLabel
          Left = -4
          Height = 14
          Top = 8
          Width = 127
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sooritame tegevuse:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbPerfAction: TComboBox
          Left = 127
          Height = 21
          Top = 5
          Width = 197
          ItemHeight = 13
          OnChange = cmbPerfActionChange
          OnKeyPress = edtVerifOrdernrKeyPress
          ParentFont = False
          Style = csDropDownList
          TabOrder = 0
        end
        object btnPeformTask: TBitBtn
          Left = 327
          Height = 27
          Top = 2
          Width = 48
          Caption = 'OK'
          Enabled = False
          OnClick = btnPeformTaskClick
          ParentFont = False
          TabOrder = 1
        end
        object cmbVerified: TCheckBox
          Left = 127
          Height = 16
          Top = 28
          Width = 245
          AutoSize = False
          Caption = 'Tellimus kinnitatud'
          OnChange = cmbVerifiedChange
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 2
        end
      end
      object pOrdppanel: TPanel
        Left = 390
        Height = 264
        Top = 4
        Width = 376
        BevelOuter = bvNone
        ClientHeight = 264
        ClientWidth = 376
        TabOrder = 2
        object bv2: TBevel
          Left = 5
          Height = 8
          Top = 23
          Width = 365
          Shape = bsTopLine
        end
        object lblSec3: TLabel
          Left = 5
          Height = 18
          Top = 5
          Width = 364
          Alignment = taCenter
          AutoSize = False
          Caption = 'Tellija andmed'
          Color = clActiveBorder
          Layout = tlCenter
          ParentColor = False
          Transparent = False
        end
        object bh2: TBevel
          Left = 369
          Height = 20
          Top = 5
          Width = 6
          Shape = bsLeftLine
        end
        object lblHousenr2: TLabel
          Left = 36
          Height = 14
          Top = 32
          Width = 126
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nimi:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtContName: TEdit
          Left = 165
          Height = 21
          Top = 29
          Width = 199
          MaxLength = 255
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 0
        end
        object lblCustCountry: TLabel
          Left = 36
          Height = 14
          Top = 54
          Width = 126
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Riik:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbCountry: TComboBox
          Left = 165
          Height = 21
          Top = 52
          Width = 199
          AutoComplete = True
          AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactSearchAscending]
          ItemHeight = 13
          OnKeyPress = edtVerifOrdernrKeyPress
          Style = csDropDownList
          TabOrder = 1
        end
        object dummyTabFix: TEdit
          Left = 165
          Height = 21
          Top = 76
          Width = 4
          ReadOnly = True
          TabOrder = 2
          Text = 'dummyTabFix'
        end
        object lblHousenr: TLabel
          Left = 36
          Height = 14
          Top = 133
          Width = 126
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Maja:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtHousenr: TEdit
          Left = 165
          Height = 21
          Top = 130
          Width = 67
          MaxLength = 65
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 3
        end
        object lblHousenr1: TLabel
          Left = 36
          Height = 14
          Top = 156
          Width = 126
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Korter:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtAparmNr: TEdit
          Left = 165
          Height = 21
          Top = 153
          Width = 67
          MaxLength = 45
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 4
        end
        object lblPostalIdx: TLabel
          Left = 36
          Height = 14
          Top = 179
          Width = 126
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Postiindeks:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtPostalIndx: TEdit
          Left = 165
          Height = 21
          Top = 176
          Width = 111
          MaxLength = 15
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 5
        end
        object lblPhone: TLabel
          Left = 36
          Height = 14
          Top = 202
          Width = 126
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Telefon:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtMobPhone: TEdit
          Left = 165
          Height = 21
          Top = 199
          Width = 199
          MaxLength = 65
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 6
        end
        object lblEmail: TLabel
          Left = 36
          Height = 14
          Top = 225
          Width = 126
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'E-post:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object edtEMail: TEdit
          Left = 165
          Height = 21
          Top = 222
          Width = 199
          MaxLength = 300
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 7
        end
      end
      object pInformationPanel: TPanel
        Left = 390
        Height = 128
        Top = 132
        Width = 376
        BevelOuter = bvNone
        ClientHeight = 128
        ClientWidth = 376
        TabOrder = 5
        object lstboxOrderInfr: TListBox
          Left = 5
          Height = 98
          Top = 26
          Width = 365
          Anchors = [akTop, akLeft, akRight, akBottom]
          ItemHeight = 0
          OnKeyPress = edtVerifOrdernrKeyPress
          TabOrder = 0
        end
        object lblOrderEvents: TLabel
          Left = 5
          Height = 18
          Top = 6
          Width = 364
          Alignment = taCenter
          AutoSize = False
          Caption = 'Tellimuse sündmused'
          Color = clActiveBorder
          Layout = tlCenter
          ParentColor = False
          Transparent = False
        end
        object bv5: TBevel
          Left = 5
          Height = 8
          Top = 24
          Width = 365
          Shape = bsTopLine
        end
        object bh5: TBevel
          Left = 369
          Height = 20
          Top = 6
          Width = 6
          Shape = bsLeftLine
        end
      end
    end
  end
  object panelbottom: TPanel
    Tag = -1
    Left = 5
    Height = 120
    Top = 328
    Width = 782
    Anchors = [akTop, akLeft, akRight, akBottom]
    BevelOuter = bvNone
    BorderStyle = bsSingle
    ClientHeight = 116
    ClientWidth = 778
    Color = clCaptionText
    Font.Color = clCaptionText
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object gridOrderLines: TStringGrid
      Tag = -1
      Left = 2
      Height = 42
      Top = 1
      Width = 774
      Anchors = [akTop, akLeft, akRight, akBottom]
      ColCount = 11
      Columns = <      
        item
          Title.Caption = 'Artikkel'
          Width = 80
        end      
        item
          Title.Caption = 'Hankija tootekood'
          Width = 135
        end      
        item
          Title.Caption = 'Kirjeldus'
          Width = 150
        end      
        item
          ButtonStyle = cbsPickList
          DropDownRows = 15
          Title.Caption = 'Ühik'
          Width = 65
        end      
        item
          Title.Caption = 'Kogus'
          Width = 75
        end      
        item
          Title.Caption = 'Hind km-ta'
          Width = 85
        end      
        item
          Title.Caption = 'Käibemaks'
          Width = 100
        end      
        item
          ReadOnly = True
          Title.Caption = 'KM summa'
          Width = 85
        end      
        item
          ReadOnly = True
          Title.Caption = 'Kokku'
          Width = 85
        end      
        item
          MinSize = 32
          MaxSize = 32
          ReadOnly = True
          Title.Caption = ' '
          Width = 0
          Visible = False
        end>
      Constraints.MinHeight = 20
      DefaultColWidth = 16
      DefaultRowHeight = 22
      Flat = True
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor, goSmoothScroll]
      ParentFont = False
      RowCount = 999
      TabOrder = 0
      OnClick = gridOrderLinesClick
      OnDrawCell = gridOrderLinesDrawCell
      OnEditingDone = gridOrderLinesEditingDone
      OnEnter = gridOrderLinesEnter
      OnExit = gridOrderLinesExit
      OnKeyDown = gridOrderLinesKeyDown
      OnKeyPress = gridOrderLinesKeyPress
      OnPickListSelect = gridOrderLinesPickListSelect
      OnPrepareCanvas = gridOrderLinesPrepareCanvas
      OnSelectEditor = gridOrderLinesSelectEditor
      OnSelection = gridOrderLinesSelection
      OnSelectCell = gridOrderLinesSelectCell
    end
    object lbltotalSum: TLabel
      Tag = -1
      Left = 506
      Height = 14
      Top = 48
      Width = 155
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'Summa käibemaksuta:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object edtSumtotal: TEdit
      Tag = -1
      Left = 664
      Height = 21
      Top = 47
      Width = 104
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BorderStyle = bsNone
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabStop = False
      TabOrder = 3
    end
    object lblvattotal: TLabel
      Tag = -1
      Left = 506
      Height = 14
      Top = 71
      Width = 155
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'Käibemaks:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object edtVatSumTotal: TEdit
      Tag = -1
      Left = 664
      Height = 21
      Top = 70
      Width = 104
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BorderStyle = bsNone
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabStop = False
      TabOrder = 1
    end
    object lbltotalosum: TLabel
      Tag = -1
      Left = 506
      Height = 14
      Top = 94
      Width = 155
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'Kokku:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object edtSumTotalWVat: TEdit
      Tag = -1
      Left = 664
      Height = 21
      Top = 93
      Width = 104
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BorderStyle = bsNone
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabStop = False
      TabOrder = 2
    end
  end
  object btnClose: TBitBtn
    Tag = -1
    Left = 690
    Height = 30
    Top = 463
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
    TabOrder = 5
  end
  object btnSave: TBitBtn
    Tag = -1
    Left = 358
    Height = 30
    Top = 463
    Width = 95
    Anchors = [akRight, akBottom]
    Caption = 'Salvesta'
    Enabled = False
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00BA6833C5C38458FFD38B68FFE18F70FFDC8D
      6CFFDA8B6DFFD78A6EFFCD8B6CFFAB6D44FFA65F2EFFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C68355FFEFCEBAFFDDFFFFFF87EEC7FFA2F4
      D7FFA2F6D7FF8CEEC7FFE0FFFFFFDDA285FFAB6A3EFFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00BA6833ACC38458DEC37F51FFEFB69AFFEAF3E8FF51BF84FF6FC9
      98FF71C999FF54BF84FFE4F4E9FFDD9C7BFFAA693AFFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C68355DEEFCEBADEC48154FFEAB697FFF3F3EAFFEDF1E6FFEFF1
      E6FFEFF0E6FFEDF1E5FFF3F5EDFFD59C79FFB07044FFFFFFFF00FFFFFF00BA68
      339BC38458C9C58053F8EEB296F8C98B61FFE6B592FFE2A781FFE1A781FFDEA3
      7DFFDCA17BFFDB9F79FFD99E77FFD49A73FFBB7E57FFFFFFFF00FFFFFF00C683
      55C9EFCEBAC9C78E66F8E0BC9CF8CA8D65FFEAB899FFDDA57EFFDDA680FFDBA3
      7CFFD9A07AFFD9A079FFD89F78FFD89E78FFBF845DFFFFFFFF00FFFFFF00C37F
      51C9EFB69AC9CC966FF8D6B691F8C8885DFFEFBFA1FFFDFCFAFFFEFCFBFFFEFD
      FDFFFEFDFCFFFDFBFAFFFDFCFBFFDDA885FFC17F53FFFFFFFF00FFFFFF00C481
      54C9EAB697C9CE9873F8EABEA1F8C7865BFFEFC09EFFFFFFFFFFCC936EFFFFFF
      FFFFFFFFFFFFFFFBF7FFFFF8F1FFE4AF8CFFC78A61FFFFFFFF00FFFFFF00C98B
      61C9E6B592C9CB8B61F8EEBC9EF8CC8D65FFF3CDB0FFFFFFFFFFE3C7B3FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFEABFA1FFC98960FFFFFFFF00FFFFFF00CA8D
      65C9EAB899C9C9895FF8EDBD9BF8D4976EFFD49E7BFFD09871FFD6A482FFCD8E
      68FFCD9069FFD09A75FFD19973FFC88B62FFAD5A2036FFFFFF00FFFFFF00C888
      5DC9EFBFA1C9D19975F8F4D2B8F8FFFFFFF8E6CDBBF8FFFFFEF8FFFFFFF8FBF6
      F2F8F8F1EDF8EABFA1DEC98960DEFFFFFF00FFFFFF00FFFFFF00FFFFFF00C786
      5BC9EFC09EC9D9A27DF8D39D7AF8D5A380F8DAAE8FF8D29A77F8D29B77F8D29C
      77F8D09771F8C88B62DEAD5A202FFFFFFF00FFFFFF00FFFFFF00FFFFFF00CC8D
      65C9F3CDB0C9FFFFFFC9E3C7B3C9FFFFFFC9FFFFFFC9FFFFFFC9FFFFFFC9EABF
      A1C9C98960C9FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D497
      6EC9D49E7BC9D09871C9D6A482C9CD8E68C9CD9069C9D09A75C9D19973C9C88B
      62C9AD5A202BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
    }
    OnClick = btnSaveClick
    TabOrder = 2
  end
  object btnCancel: TBitBtn
    Tag = -1
    Left = 454
    Height = 30
    Top = 463
    Width = 95
    Anchors = [akRight, akBottom]
    Caption = 'Katkesta'
    Enabled = False
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D9AB8EFFBC6A39FFBD6D3CFFBD6D
      3BFFBD6D3BFFBD6D3BFFBB6937FFBB6937FFC68258FFE2C1AAFFFFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FAFAFF00FFFFFF00D29769FFFBF3ECFFFBF3ECFFFBF3
      ECFFFBF3ECFFFBF3ECFFFBF3ECFFFBF3ECFFFBF3ECFFC1784BFFFFFFFF00FFFF
      FF00FFFFFF005D56E8FFBC6A39FFF2EAEB9FCD8646FFF8B762FFF6BF78FFF1B1
      6DFFFABE63FFFABF66FF463DDBFFFBB956FFFBEBD0FFC07342FFFFFFFF00FFFF
      FF006967F6FF6F69EFFF6258E3FFBC6A39FFF4EDECFFF8B762FFF6BF78FFF8F1
      F0FFFABE63FF544CE3FF5E56E6FF463DDBFFFBEBD0FFC07342FFFFFFFF00FFFF
      FF00FFFFFF007068EBFF7F7EFDFF6A66F5FFCF7536FFECAB75FFF7F1F0FFDE8D
      47FF5953E9FF726DF5FF5C55E9FFF7C589FFFBEDDCFFC47D49FFFFFFFF00D9AB
      8EFFBC6A39FFCD8646FF736BECFF8078F0FF6960E8FFFADFCFFFF9DECAFF6057
      E6FF756EF1FF615CEFFFFCE7D9FFFCE7D9FFFBF3ECFFC6834BFFFFFFFF00D297
      69FFFBF3ECFFCF7536FFE8AB5CFF746CEAFF817AF2FF817CFAFF7E7AFAFF7B73
      F0FF665DE7FFF2C8A8FFFADEC4FFFADEC4FFFAF1E6FFC98951FFFFFFFF00CF75
      36FFE8AB5CFFEDBC83FFFCE3D3FFFCE3D3FF827AEEFF6964F8FF6761F6FF7F79
      F3FFF8DDC3FFF8E0CBFFF5E3D2FFF5E3D2FFFBF3ECFFC07C3FFFE8AE70FFE8A7
      6EFFFADFCFFFD98F3CFFFAF4F5FFF2C79BFF867EF1FF6F6AFBFF6B66F9FF8480
      FAFFFADDC2FFF7F3F4FFE8CCAFFFE8CCAFFFEEC7ABFFE3C6AEFFE8AB5CFFEDBC
      83FFFCE3D3FFF6F0EEFFF9DAB9FF7E78F4FF8984F3FF8B88FDFF8985FBFF8683
      FBFF6E6BF5FFEFDFD0FFF7F3F3FFE2B687FFF0D1B7FFFFFFFF00FFFFFF00D98F
      3CFFF2C79BFFD6A576FF8580F9FF938DFBFF817BF2FFD0A170FFD1A272FF7770
      ECFF847DF0FF6C65EBFFD9AC82FFF6F2F200FFFFFF00FFFFFF00FFFFFF00D98F
      3CFFF2C79BFF867FF0FF9691FBFF8A85F9FFE0BFA1FFD0A170FFD1A272FFD1A2
      72FF7872ECFF867FF2FF6D67EBFFD9AC82FFFDFDFF00FFFFFF00FFFFFF00D096
      57FF8781F8FF8A84F3FF8E8AFCFFFBF5ECFFF7ECDFFFF7EBDFFFF8EEE4FFEFDF
      D0FFE2B687FF7C77F4FF8B8AFFFF726FF9FFFFFFFF00FFFFFF00FFFFFF00D6A5
      76FFFFE9D7FF857FF5FFD0A170FFD0A170FFD1A272FFD1A272FFD0A070FFD5AC
      81FFD9AC82FFFFFFFF007978FAFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00DAB2
      8BFFFBF5ECFFF7ECDFFFF7EBDFFFF7EBDFFFF8EEE4FFEFDFD0FFE2B687FFF0D1
      B7FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E0BF
      A1FFD0A170FFD1A272FFD1A272FFD1A272FFD0A070FFD5AC81FFD9AC82FFFFFF
      FF00FFFFFF00FFFFFF00FAFAFF00FFFFFF00FFFFFF00FFFFFF00
    }
    OnClick = btnCancelClick
    TabOrder = 3
  end
  object btnNewOrder: TBitBtn
    Left = 262
    Height = 30
    Top = 463
    Width = 95
    Anchors = [akRight, akBottom]
    Caption = 'Uus tellimus'
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
    OnClick = btnNewOrderClick
    TabOrder = 1
  end
  object btnPrint: TBitBtn
    Tag = -1
    Left = 550
    Height = 30
    Top = 463
    Width = 95
    Anchors = [akRight, akBottom]
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
    TabOrder = 4
  end
  object qryRWOrder: TZQuery
    AutoCalcFields = False
    Params = <>
    left = 400
    top = 65520
  end
  object qryHelper: TZQuery
    AutoCalcFields = False
    Params = <>
    left = 464
    top = 65520
  end
  object qryOrderSeq: TZSequence
    SequenceName = 'orders_id_seq'
    left = 528
    top = 65520
  end
  object qryArticles: TZQuery
    AutoCalcFields = False
    Params = <>
    left = 688
    top = 65520
  end
  object qryArticlesDs: TDatasource
    DataSet = qryArticles
    left = 352
    top = 65520
  end
  object qryOrderLinesSeq: TZSequence
    SequenceName = 'order_lines_id_seq'
    left = 608
    top = 65520
  end
  object lazFocusFix: TTimer
    Enabled = False
    Interval = 45
    OnTimer = lazFocusFixTimer
    left = 288
    top = 65520
  end
  object qryVat: TZQuery
    AutoCalcFields = False
    ReadOnly = True
    Params = <>
    left = 736
    top = 65520
  end
  object qryVatDs: TDatasource
    AutoEdit = False
    DataSet = qryVat
    left = 736
    top = 48
  end
  object frrepdataset: TfrDBDataSet
    DataSet = frrepmemdataset
    left = 32
    top = 24
  end
  object frreport: TfrReport
    Dataset = frrepdataset
    InitialZoom = pzDefault
    Options = []
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    DataType = dtDataSet
    OnBeginBand = frreportBeginBand
    OnGetValue = frreportGetValue
    OnEnterRect = frreportEnterRect
    left = 32
    top = 88
    ReportForm = {
      19000000
    }
  end
  object frrepmemdataset: TMemDataset
    FieldDefs = <>
    left = 32
    top = 168
  end
end
