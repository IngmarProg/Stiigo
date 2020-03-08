inherited framePaymentOrder: TframePaymentOrder
  Height = 492
  Width = 936
  ClientHeight = 492
  ClientWidth = 936
  DesignLeft = 99
  DesignTop = 212
  object grpPmtOrder: TGroupBox[0]
    Left = 8
    Height = 422
    Top = 7
    Width = 924
    Anchors = [akTop, akLeft, akRight, akBottom]
    Caption = ' Tasumine '
    ClientHeight = 404
    ClientWidth = 920
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object lblPmtOrderDate1: TLabel
      Left = 0
      Height = 14
      Top = 9
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Nr:'
      ParentColor = False
    end
    object edtOrderNr: TEdit
      Tag = -1
      Left = 137
      Height = 21
      Top = 6
      Width = 124
      Color = cl3DLight
      ReadOnly = True
      TabStop = False
      TabOrder = 1
    end
    object lblPmtOrderDate: TLabel
      Left = 0
      Height = 14
      Top = 32
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Kuupäev:'
      ParentColor = False
    end
    object pmtDate: TDateEdit
      Left = 137
      Height = 21
      Top = 29
      Width = 124
      CalendarDisplaySettings = [dsShowHeadings, dsShowDayNames]
      OnAcceptDate = pmtDateAcceptDate
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
      OnChange = pmtDateChange
      OnExit = pmtDateExit
      OnKeyPress = pmtDateKeyPress
      TabOrder = 2
    end
    object lblPmtDocNumber: TLabel
      Left = 0
      Height = 14
      Top = 55
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Dokumendi nr:'
      ParentColor = False
    end
    object dbEdtDocNr: TDBEdit
      Left = 137
      Height = 21
      Top = 52
      Width = 147
      DataField = 'document_nr'
      DataSource = qryPmtOrderDs
      CharCase = ecNormal
      MaxLength = 0
      ParentFont = False
      TabOrder = 3
      OnKeyPress = pmtDateKeyPress
    end
    object lblPmtCreditAcc: TLabel
      Left = 0
      Height = 14
      Top = 78
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Konto (K):'
      ParentColor = False
    end
    object dbLookupComboCredit: TRxDBLookupCombo
      Left = 137
      Height = 21
      Top = 75
      Width = 147
      AutoSize = True
      ButtonOnlyWhenFocused = False
      ButtonWidth = 15
      Color = clWindow
      DataField = 'c_account_id'
      DataSource = qryPmtOrderDs
      PopUpFormOptions.Columns = <      
        item
          Alignment = taLeftJustify
          Color = clWindow
          FieldName = 'account_coding'
          Title.Orientation = toHorizontal
          Title.Alignment = taCenter
          Title.Layout = tlTop
          Title.Caption = 'Kood'
          Title.Color = clBtnFace
          Width = 85
        end      
        item
          Alignment = taLeftJustify
          Color = clWindow
          FieldName = 'account_name'
          Title.Orientation = toHorizontal
          Title.Alignment = taCenter
          Title.Layout = tlTop
          Title.Caption = 'Nimetus'
          Title.Color = clBtnFace
          Width = 215
        end>
      PopUpFormOptions.DropDownWidth = 385
      PopUpFormOptions.Options = [pfgColLines, pfgRowLines, pfgColumnResize]
      PopUpFormOptions.ShowTitles = True
      Flat = False
      Glyph.Data = {
        72000000424D7200000000000000360000002800000005000000030000000100
        2000000000003C00000064000000640000000000000000000000000000000000
        0000000000FF000000000000000000000000000000FF000000FF000000FF0000
        0000000000FF000000FF000000FF000000FF000000FF
      }
      NumGlyphs = 1
      OnChange = dbLookupComboCreditChange
      OnClosePopupNotif = dbLookupComboCreditClosePopupNotif
      OnKeyDown = dbLookupComboCreditKeyDown
      OnKeyPress = pmtDateKeyPress
      OnSelect = dbLookupComboCreditSelect
      ParentColor = False
      ReadOnly = False
      TabOrder = 4
      TabStop = True
      DropDownWidth = 385
      LookupDisplay = 'account_coding;account_name'
      LookupField = 'id'
      LookupSource = qryGetCBanksAccountsDs
    end
    object lblAccCName: TLabel
      Tag = -1
      Left = 283
      Height = 20
      Top = 75
      Width = 343
      AutoSize = False
      Color = 15000804
      Constraints.MaxWidth = 345
      Layout = tlCenter
      ParentColor = False
      Transparent = False
    end
    object bv1: TBevel
      Tag = -1
      Left = 283
      Height = 8
      Top = 95
      Width = 345
      Shape = bsTopLine
    end
    object edtrecpname: TDBEdit
      Left = 137
      Height = 21
      Top = 121
      Width = 473
      DataField = 'payment_rcv_name'
      DataSource = qryPmtOrderDs
      CharCase = ecNormal
      MaxLength = 85
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnChange = edtrecpnameChange
      OnKeyDown = edtrecpnameKeyDown
      OnKeyPress = pmtDateKeyPress
    end
    object lblbankacc: TLabel
      Left = 0
      Height = 14
      Top = 101
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Maksja arveldusarve:'
      ParentColor = False
    end
    object dbEdtbankAcc: TDBEdit
      Left = 137
      Height = 21
      Top = 98
      Width = 147
      DataField = 'payer_account_nr'
      DataSource = qryPmtOrderDs
      CharCase = ecNormal
      MaxLength = 0
      ParentFont = False
      TabOrder = 5
      OnKeyPress = pmtDateKeyPress
    end
    object lblPaymentrcv: TLabel
      Left = 0
      Height = 14
      Top = 124
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Saaja nimi:'
      ParentColor = False
    end
    object lblPaymentrcv1: TLabel
      Left = 0
      Height = 14
      Top = 147
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Saaja pank:'
      ParentColor = False
    end
    object dbRcvBankList: TRxDBLookupCombo
      Left = 137
      Height = 21
      Top = 144
      Width = 147
      AutoSize = True
      ButtonOnlyWhenFocused = False
      ButtonWidth = 15
      Color = clWindow
      DataField = 'payment_rcv_bank_id'
      DataSource = qryPmtOrderDs
      PopUpFormOptions.Columns = <      
        item
          Alignment = taLeftJustify
          Color = clWindow
          FieldName = 'bankname'
          Title.Orientation = toHorizontal
          Title.Alignment = taCenter
          Title.Layout = tlTop
          Title.Caption = 'Nimetus'
          Title.Color = clBtnFace
          Width = 155
        end      
        item
          Alignment = taLeftJustify
          Color = clWindow
          FieldName = 'swift'
          Title.Orientation = toHorizontal
          Title.Alignment = taCenter
          Title.Layout = tlTop
          Title.Caption = 'Swift'
          Title.Color = clBtnFace
          Width = 85
        end>
      PopUpFormOptions.DropDownWidth = 315
      PopUpFormOptions.Options = [pfgColLines, pfgRowLines, pfgColumnResize]
      PopUpFormOptions.ShowTitles = True
      Flat = False
      Glyph.Data = {
        72000000424D7200000000000000360000002800000005000000030000000100
        2000000000003C00000064000000640000000000000000000000000000000000
        0000000000FF000000000000000000000000000000FF000000FF000000FF0000
        0000000000FF000000FF000000FF000000FF000000FF
      }
      NumGlyphs = 1
      OnClosePopupNotif = dbLookupComboCreditClosePopupNotif
      OnKeyDown = dbLookupComboCreditKeyDown
      OnKeyPress = pmtDateKeyPress
      ParentColor = False
      ReadOnly = False
      TabOrder = 7
      TabStop = True
      DropDownWidth = 315
      LookupDisplay = 'swift;bankname'
      LookupDisplayIndex = 1
      LookupField = 'id'
      LookupSource = qryPmtBanksDs
    end
    object lblPaymentrcvname: TLabel
      Left = 361
      Height = 14
      Top = 147
      Width = 99
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Saaja a/a:'
      ParentColor = False
    end
    object dbEdtRecvAcc: TDBEdit
      Left = 463
      Height = 21
      Top = 144
      Width = 147
      DataField = 'payment_rcv_account_nr'
      DataSource = qryPmtOrderDs
      CharCase = ecNormal
      MaxLength = 0
      ParentFont = False
      TabOrder = 8
      OnKeyPress = pmtDateKeyPress
    end
    object btnOpenClientList: TBitBtn
      Left = 610
      Height = 21
      Top = 121
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
      TabOrder = 0
      TabStop = False
    end
    object pimgisverifiedclient: TImage
      Left = 628
      Height = 21
      Top = 124
      Width = 24
      ParentShowHint = False
      ShowHint = True
    end
    object lblRefNumber: TLabel
      Left = 0
      Height = 14
      Top = 170
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Saaja viitenumber:'
      ParentColor = False
    end
    object dbEdtRecpRefNr: TDBEdit
      Left = 137
      Height = 21
      Top = 167
      Width = 147
      DataField = 'payment_rcv_refnr'
      DataSource = qryPmtOrderDs
      CharCase = ecNormal
      MaxLength = 0
      ParentFont = False
      TabOrder = 9
      OnKeyPress = pmtDateKeyPress
    end
    object lblCurrency: TLabel
      Left = 361
      Height = 14
      Top = 170
      Width = 99
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Valuuta:'
      ParentColor = False
    end
    object cmbCurrency: TComboBox
      Left = 463
      Height = 21
      Top = 167
      Width = 57
      ItemHeight = 13
      OnChange = cmbCurrencyChange
      OnKeyPress = pmtDateKeyPress
      Style = csDropDownList
      TabOrder = 10
    end
    object pLblcurrVal: TLabel
      Left = 524
      Height = 19
      Top = 167
      Width = 40
      AutoSize = False
      Color = 13487565
      Font.Height = -9
      Layout = tlCenter
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object miscSumDbGrid: TDBGrid
      Left = 137
      Height = 64
      Top = 314
      Width = 747
      Anchors = [akTop, akLeft, akRight]
      Color = clWindow
      Columns = <      
        item
          Title.Caption = 'Selgitus'
          Width = 265
          FieldName = 'item_descr'
        end      
        item
          Title.Caption = 'Summa'
          Width = 85
          FieldName = 'splt_sum'
        end      
        item
          Title.Caption = 'Konto'
          Width = 100
          FieldName = 'account_coding'
        end>
      DataSource = qryGetMiscPmtItemsDs
      DefaultRowHeight = 21
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowEditor, dgHeaderHotTracking]
      ParentFont = False
      PopupMenu = popupMiscGridActions
      TabOrder = 11
      TitleStyle = tsNative
      OnCellClick = miscSumDbGridCellClick
      OnColEnter = miscSumDbGridColEnter
      OnColExit = miscSumDbGridColExit
      OnDrawColumnCell = miscSumDbGridDrawColumnCell
      OnEnter = miscSumDbGridEnter
      OnExit = miscSumDbGridExit
      OnKeyDown = miscSumDbGridKeyDown
      OnKeyPress = miscSumDbGridKeyPress
      OnSelectEditor = miscSumDbGridSelectEditor
      OnTitleClick = miscSumDbGridTitleClick
    end
    object lblMrgDescr: TLabel
      Left = 0
      Height = 14
      Top = 374
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Koondselgitus:'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object dbGridAllItems: TDBGrid
      Left = 137
      Height = 122
      Top = 190
      Width = 747
      Anchors = [akTop, akLeft, akRight]
      Color = clWindow
      Columns = <      
        item
          MinSize = 25
          ReadOnly = True
          Title.Caption = 'Ostuarved / tellimused'
          Width = 110
          FieldName = 'nr'
        end      
        item
          MinSize = 25
          ReadOnly = True
          Title.Caption = 'Esitaja'
          Width = 175
          FieldName = 'cstname'
        end      
        item
          MinSize = 25
          ReadOnly = True
          Title.Caption = 'Tähtaeg'
          Width = 70
          FieldName = 'ldate'
        end      
        item
          ReadOnly = True
          Title.Caption = 'Summa'
          Width = 65
          FieldName = 'to_pay2'
        end      
        item
          ReadOnly = True
          Title.Caption = 'Tasutud'
          Width = 65
          FieldName = 'incomesum'
        end      
        item
          Alignment = taRightJustify
          MinSize = 25
          ReadOnly = True
          Title.Caption = 'Tasuda'
          Width = 65
          FieldName = 'to_pay'
        end      
        item
          ReadOnly = True
          Title.Caption = 'Valuuta'
          Width = 45
          FieldName = 'currency'
        end      
        item
          Title.Caption = 'Märgitav summa'
          Width = 85
          FieldName = 'splt_sum'
        end      
        item
          ButtonStyle = cbsButton
          MinSize = 25
          MaxSize = 25
          ReadOnly = True
          Title.Caption = ' '
          Width = 32
          FieldName = 'lsitemhlp'
        end>
      DataSource = qryGetPmtItemsDs
      DefaultRowHeight = 20
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowEditor, dgCancelOnExit, dgHeaderHotTracking]
      ParentFont = False
      ShowHint = True
      TabOrder = 12
      TitleStyle = tsNative
      OnCellClick = dbGridAllItemsCellClick
      OnColEnter = dbGridAllItemsColEnter
      OnColExit = dbGridAllItemsColExit
      OnDrawColumnCell = dbGridAllItemsDrawColumnCell
      OnEnter = dbGridAllItemsEnter
      OnExit = dbGridAllItemsExit
      OnKeyDown = dbGridAllItemsKeyDown
      OnKeyPress = dbGridAllItemsKeyPress
      OnPrepareCanvas = dbGridAllItemsPrepareCanvas
      OnSelectEditor = dbGridAllItemsSelectEditor
      OnUserCheckboxBitmap = dbGridAllItemsUserCheckboxBitmap
    end
    object Label5: TLabel
      Left = 137
      Height = 22
      Top = 292
      Width = 747
      Anchors = [akTop, akLeft, akRight]
      AutoSize = False
      Color = clSilver
      ParentColor = False
      Transparent = False
    end
    object rcornerimg: TImage
      Left = 811
      Height = 28
      Top = 382
      Width = 162
      Anchors = [akRight, akBottom]
      Picture.Data = {
        1754506F727461626C654E6574776F726B477261706869631001000089504E47
        0D0A1A0A0000000D49484452000000720000001B08020000002F444CB8000000
        097048597300000B1200000B1201D2DD7EFC000000C249444154789CEDDABB0E
        83300C85E1BCFF4B2552DBA19D6C05C19B34081BB90BBDD09544E0F6A07F46F0
        2912C321A86885746E9188B66CAED7724F7B5E4145C772278A687B6FD6B114A2
        380C379CD68DA79528BE6E1E9853DF5F1BBFC05FB462EDBAD3EE0FF41BAD5873
        062B580FDB24445126012B588F1F58C1EA297CB2C0EA27B082D54F6005AB9FC0
        0A563F8115AC7E62066BED72BE3027B0D6353D13C5CF712F98D9EE83A5F31273
        FCDA4C839955DD201BCEA58DF6DDA52AFF4B8015ACFE581F5551D8C4880FBD2A
        0000000049454E44AE426082
      }
      Transparent = True
    end
    object pconstrpanel: TPanel
      Left = 137
      Height = 2
      Top = 376
      Width = 748
      Anchors = [akTop, akLeft, akRight, akBottom]
      BevelOuter = bvNone
      ClientHeight = 2
      ClientWidth = 748
      Color = cl3DLight
      Constraints.MaxHeight = 85
      ParentColor = False
      TabOrder = 13
      object dbExplMemo: TDBMemo
        Tag = 1
        Left = 0
        Height = 1
        Top = 1
        Width = 747
        Anchors = [akTop, akLeft, akRight, akBottom]
        DataField = 'descr'
        DataSource = qryPmtOrderDs
        OnKeyPress = dbExplMemoKeyPress
        TabOrder = 0
      end
    end
    object lblTransactionCost: TLabel
      Left = 0
      Height = 13
      Top = 384
      Width = 134
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Pangakulu:'
      ParentColor = False
    end
    object dbEdtBankCost: TDBEdit
      Left = 137
      Height = 21
      Top = 381
      Width = 47
      DataField = 'trcost'
      DataSource = qryPmtOrderDs
      Anchors = [akLeft, akBottom]
      CharCase = ecNormal
      MaxLength = 5
      ParentFont = False
      TabOrder = 14
      OnKeyPress = dbedtBillSumKeyPress
    end
    object lblPaymentSumTotal: TLabel
      Left = 196
      Height = 14
      Top = 383
      Width = 139
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Makse summa kokku:'
      ParentColor = False
    end
    object dbEdtSumtotal: TDBEdit
      Tag = -1
      Left = 338
      Height = 21
      Top = 381
      Width = 96
      DataField = 'sumtotal'
      DataSource = qryPmtOrderDs
      ReadOnly = True
      Anchors = [akLeft, akBottom]
      CharCase = ecNormal
      Color = cl3DLight
      MaxLength = 0
      ParentFont = False
      TabOrder = 15
      OnKeyPress = dbedtBillSumKeyPress
    end
    object lblVerified: TLabel
      Left = 839
      Height = 14
      Top = 387
      Width = 59
      Anchors = [akRight, akBottom]
      Caption = 'kinnitatud'
      Enabled = False
      ParentColor = False
    end
    object Bevel1: TBevel
      Left = 626
      Height = 21
      Top = 75
      Width = 26
      Shape = bsLeftLine
    end
  end
  object btnNewPayment: TBitBtn[1]
    Tag = -1
    Left = 501
    Height = 30
    Top = 447
    Width = 95
    Anchors = [akRight, akBottom]
    Caption = 'Uus makse'
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
    OnClick = btnNewPaymentClick
    TabOrder = 2
  end
  object btnSave: TBitBtn[2]
    Tag = -1
    Left = 597
    Height = 30
    Top = 447
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
    TabOrder = 0
  end
  object btnCancel: TBitBtn[3]
    Tag = -1
    Left = 693
    Height = 30
    Top = 447
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
    TabOrder = 1
  end
  object btnClose: TBitBtn[4]
    Tag = -1
    Left = 833
    Height = 30
    Top = 447
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
    TabOrder = 4
  end
  object btnOpenAccEntry: TBitBtn[5]
    Left = 13
    Height = 30
    Top = 447
    Width = 95
    Anchors = [akLeft, akBottom]
    Caption = 'Ava kanne'
    Enabled = False
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000064000000640000000000000000000000545655FF5456
      55FF545655FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C4C4C4FF8484
      84FF848484FF848484FF848484FF848484FF848484FFFFFFFF00545655FF0EB2
      5FFF7ECAA3FF545655FFFFFFFF00848484FF848484FF848484FF848484FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF848484FFFFFFFF00545655FF0EB2
      5FFF0EB25FFF7ECAA3FF545655FF848484FFFFFFFF00FFFFFF00848484FF8484
      84FF848484FF848484FF848484FF848484FFC4C4C4FFFFFFFF00FFFFFF005456
      55FF0EB25FFF0EB25FFF7ECAA3FF545655FFFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00545655FF0EB25FFF0EB25FFF7ECAA3FF545655FF545655FF545655FF5456
      55FF545655FF848484FF848484FF848484FF848484FFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00545655FF0EB25FFF545655FF545655FFE4B881FFB97F5FFFE2B6
      8EFF545655FF545655FFE5E5E5FFE5E5E5FF848484FFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00545655FF545655FFE4B881FFE4B881FFB97F5FFFB67A
      58FFBD7C4FFF545655FF545655FF848484FFC4C4C4FFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00545655FF947868FFE4B881FFDCBAA0FFD9BFA9FFD7C1
      B4FFDFB896FFE3BB7EFF545655FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00545655FFAD795DFFDFBB94FFD4C3C0FFD8C0AEFFAD85
      6BFFC1824DFFA87F66FF545655FF848484FF848484FFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00545655FF8F746BFFC67B3CFF9D8B86FF9C8D8AFFD8C0
      AEFFE3BB7EFFE4B881FF545655FFE5E5E5FF848484FFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00545655FF545655FFD4B2A4FFD4C3C0FFF9E9D8FFD4C3
      C0FFBA774FFF545655FF545655FF848484FFC4C4C4FFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00545655FF545655FFD4C3C0FFF9E9D8FFD4C3
      C0FF545655FF545655FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00C4C4C4FF8484
      84FF848484FF848484FFFFFFFF00848484FF545655FF545655FF545655FF5456
      55FF545655FF848484FF848484FF848484FF848484FFFFFFFF00848484FFE5E5
      E5FFE5E5E5FF848484FF848484FF848484FF848484FF848484FF848484FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF848484FFFFFFFF00848484FF8484
      84FF848484FFC4C4C4FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00848484FF8484
      84FF848484FF848484FF848484FF848484FFC4C4C4FFFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
    }
    OnClick = btnOpenAccEntryClick
    TabOrder = 3
  end
  object chkboxConfPmtDone: TCheckBox[6]
    Tag = -1
    Left = 832
    Height = 15
    Top = 406
    Width = 14
    Anchors = [akRight, akBottom]
    AutoSize = False
    Enabled = False
    OnChange = chkboxConfPmtDoneChange
    TabOrder = 6
  end
  object qryPmtOrder: TZQuery[7]
    AutoCalcFields = False
    AfterScroll = qryPmtOrderAfterScroll
    UpdateObject = qryPmtOrderUpt
    CachedUpdates = True
    AfterInsert = qryPmtOrderAfterInsert
    BeforeEdit = qryPmtOrderBeforeEdit
    BeforePost = qryPmtOrderBeforePost
    Params = <>
    Sequence = dmodule.qryPaymentSeq
    SequenceField = 'id'
    left = 480
    top = 56
  end
  object qryPmtOrderDs: TDatasource[8]
    DataSet = qryPmtOrder
    left = 768
    top = 176
  end
  object qryPmtOrderUpt: TZUpdateSQL[9]
    UseSequenceFieldForRefreshSQL = False
    left = 872
    top = 120
  end
  object qryGetCBanksAccounts: TZReadOnlyQuery[10]
    AutoCalcFields = False
    OnFilterRecord = qryGetCBanksAccountsFilterRecord
    Params = <>
    left = 872
  end
  object qryGetCBanksAccountsDs: TDatasource[11]
    DataSet = qryGetCBanksAccounts
    left = 872
    top = 248
  end
  object qryPmtBanksDs: TDatasource[12]
    DataSet = qryPmtBanks
    left = 768
    top = 120
  end
  object qryPmtBanks: TZReadOnlyQuery[13]
    AutoCalcFields = False
    OnFilterRecord = qryGetCBanksAccountsFilterRecord
    Params = <>
    left = 688
  end
  object qryDataWrt: TZQuery[14]
    AutoCalcFields = False
    Params = <>
    left = 688
    top = 176
  end
  object qryGetUserPmtItems: TZQuery[15]
    AutoCalcFields = False
    CachedUpdates = True
    BeforeInsert = qryGetUserPmtItemsBeforeInsert
    BeforeEdit = qryGetUserPmtItemsBeforeEdit
    AfterEdit = qryGetUserPmtItemsAfterEdit
    AfterPost = qryGetUserPmtItemsAfterPost
    Params = <>
    left = 600
  end
  object qryGetPmtItemsDs: TDatasource[16]
    DataSet = qryGetUserPmtItems
    left = 768
  end
  object qryManagePaymentData: TZQuery[17]
    Params = <>
    left = 480
  end
  object qryGetAccounts: TZQuery[18]
    OnFilterRecord = qryGetAccountsFilterRecord
    Params = <>
    left = 688
    top = 56
  end
  object qryGetAccountsDs: TDatasource[19]
    DataSet = qryGetAccounts
    left = 600
    top = 56
  end
  object qryGetMiscPmtItems: TZQuery[20]
    AutoCalcFields = False
    UpdateObject = qryGetMiscPmtItemsUptInst
    CachedUpdates = True
    BeforeEdit = qryGetUserPmtItemsBeforeEdit
    AfterEdit = qryGetMiscPmtItemsAfterEdit
    BeforePost = qryGetMiscPmtItemsBeforePost
    AfterPost = qryGetMiscPmtItemsAfterPost
    Params = <>
    SequenceField = 'id'
    left = 768
    top = 56
  end
  object qryGetMiscPmtItemsDs: TDatasource[21]
    DataSet = qryGetMiscPmtItems
    left = 872
    top = 184
  end
  object qryGetMiscPmtItemsUptInst: TZUpdateSQL[22]
    UseSequenceFieldForRefreshSQL = False
    left = 872
    top = 56
  end
  object lazFocusFix: TTimer[23]
    Enabled = False
    Interval = 45
    OnTimer = lazFocusFixTimer
    left = 688
    top = 128
  end
  object popupMiscGridActions: TPopupMenu[24]
    left = 872
    top = 304
    object mnuItemDelLine: TMenuItem
      Caption = 'Kustuta rida'
      OnClick = mnuItemDelLineClick
    end
  end
end
