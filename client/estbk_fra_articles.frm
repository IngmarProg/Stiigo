inherited frameArticles: TframeArticles
  Height = 504
  Width = 720
  ClientHeight = 504
  ClientWidth = 720
  DesignLeft = 284
  DesignTop = 223
  object grpBoxObjects: TGroupBox[0]
    Left = 6
    Height = 434
    Top = 4
    Width = 711
    Anchors = [akTop, akLeft, akRight, akBottom]
    Caption = ' Artiklid '
    ClientHeight = 409
    ClientWidth = 707
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object panelLeft: TPanel
      Left = 0
      Height = 409
      Top = 0
      Width = 375
      Align = alLeft
      BevelOuter = bvNone
      ClientHeight = 409
      ClientWidth = 375
      Constraints.MinWidth = 150
      TabOrder = 0
      object dbObjGrid: TDBGrid
        Tag = -1
        Left = 4
        Height = 373
        Top = 34
        Width = 370
        Anchors = [akTop, akLeft, akRight, akBottom]
        AutoEdit = False
        Color = clWindow
        Columns = <        
          item
            Title.ImageLayout = blGlyphLeft
            Title.Caption = 'Tüüp'
            Width = 88
            FieldName = 'arttype'
          end        
          item
            Title.ImageLayout = blGlyphLeft
            Title.Caption = 'Kood'
            Width = 65
            FieldName = 'artcode'
          end        
          item
            Title.ImageLayout = blGlyphLeft
            Title.Caption = 'Nimetus'
            Width = 181
            FieldName = 'artname'
          end>
        DataSource = qryArticlesDs
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgHeaderHotTracking, dgHeaderPushedLook]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        TitleImageList = dmodule.sharedImages
        TitleStyle = tsNative
        OnDrawColumnCell = dbObjGridDrawColumnCell
        OnKeyDown = dbObjGridKeyDown
        OnMouseDown = dbObjGridMouseDown
        OnMouseMove = dbObjGridMouseMove
        OnPrepareCanvas = dbObjGridPrepareCanvas
        OnTitleClick = dbObjGridTitleClick
      end
      object panelLeftInnerSrc: TPanel
        Left = 0
        Height = 34
        Top = 0
        Width = 375
        Align = alTop
        BevelOuter = bvNone
        ClientHeight = 34
        ClientWidth = 375
        TabOrder = 1
        object edtSrc: TEdit
          Left = 46
          Height = 28
          Top = 7
          Width = 327
          Anchors = [akTop, akLeft, akRight]
          OnKeyDown = edtSrcKeyDown
          OnKeyPress = edtSrcKeyPress
          ParentFont = False
          TabOrder = 0
        end
        object Image1: TImage
          Left = 14
          Height = 25
          Top = 7
          Width = 25
          Transparent = True
        end
      end
    end
    object panelRight: TPanel
      Left = 379
      Height = 409
      Top = 0
      Width = 328
      Align = alClient
      BevelOuter = bvNone
      ClientHeight = 409
      ClientWidth = 328
      Constraints.MinWidth = 200
      TabOrder = 1
      object pageCtrlArt: TPageControl
        Tag = 1
        Left = 0
        Height = 409
        Top = 0
        Width = 328
        ActivePage = pageArtMainData
        Align = alClient
        TabIndex = 0
        TabOrder = 0
        object pageArtMainData: TTabSheet
          Caption = 'Artikkel'
          ClientHeight = 376
          ClientWidth = 320
          object lblArtType: TLabel
            Left = 14
            Height = 14
            Top = 6
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Tüüp:'
            ParentColor = False
          end
          object cmbArtType: TComboBox
            Left = 121
            Height = 28
            Top = 4
            Width = 112
            ItemHeight = 20
            OnChange = cmbArtTypeChange
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = dbEdtProdCodeKeyPress
            ParentFont = False
            Style = csDropDownList
            TabOrder = 0
          end
          object lblProdcode: TLabel
            Left = 14
            Height = 14
            Top = 30
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Kood:'
            ParentColor = False
          end
          object dbEdtProdCode: TDBEdit
            Left = 121
            Height = 28
            Top = 27
            Width = 112
            DataField = 'artcode'
            DataSource = qryArticlesDs
            CharCase = ecNormal
            Constraints.MaxWidth = 300
            Constraints.MinWidth = 112
            MaxLength = 0
            ParentFont = False
            TabOrder = 1
            OnKeyPress = dbEdtProdCodeKeyPress
          end
          object lblname: TLabel
            Left = 14
            Height = 14
            Top = 54
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Nimetus:'
            ParentColor = False
          end
          object dbEdtProdName: TDBEdit
            Left = 121
            Height = 28
            Top = 50
            Width = 133
            DataField = 'artname'
            DataSource = qryArticlesDs
            Anchors = [akTop, akLeft, akRight]
            CharCase = ecNormal
            Constraints.MaxWidth = 300
            Constraints.MinWidth = 112
            MaxLength = 0
            ParentFont = False
            TabOrder = 2
            OnKeyPress = dbEdtProdCodeKeyPress
          end
          object lblUnit: TLabel
            Left = 14
            Height = 14
            Top = 78
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Ühik:'
            ParentColor = False
          end
          object cmbUnit: TDBComboBox
            Left = 121
            Height = 28
            Top = 73
            Width = 133
            AutoDropDown = True
            DataField = 'unit'
            DataSource = qryArticlesDs
            ItemHeight = 20
            MaxLength = 0
            OnClick = cmbUnitClick
            OnExit = cmbUnitExit
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = dbEdtProdCodeKeyPress
            ParentFont = False
            TabOrder = 3
          end
          object lblSalePrice: TLabel
            Left = 14
            Height = 14
            Top = 100
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Müügihind:'
            ParentColor = False
          end
          object edtSalePrice: TCalcEdit
            Left = 121
            Height = 21
            Top = 96
            Width = 109
            CalculatorLayout = clNormal
            AsInteger = 0
            OnAcceptValue = edtSalePriceAcceptValue
            ButtonWidth = 23
            DialogTop = 0
            DialogLeft = 0
            NumGlyphs = 1
            AutoSize = False
            MaxLength = 0
            ParentFont = False
            TabOrder = 4
            OnChange = edtSalePriceChange
            OnEnter = edtSalePriceEnter
            OnExit = edtSalePriceExit
            OnKeyPress = edtSalePriceKeyPress
            Text = '0'
          end
          object lbllpurchaseprice: TLabel
            Left = 14
            Height = 14
            Top = 122
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Ostuhind:'
            ParentColor = False
          end
          object edtPurcPrice: TCalcEdit
            Left = 121
            Height = 21
            Top = 119
            Width = 109
            CalculatorLayout = clNormal
            AsInteger = 0
            ButtonWidth = 23
            DialogTop = 0
            DialogLeft = 0
            NumGlyphs = 1
            AutoSize = False
            MaxLength = 0
            ParentFont = False
            TabOrder = 5
            OnChange = edtSalePriceChange
            OnEnter = edtSalePriceEnter
            OnExit = edtSalePriceExit
            OnKeyPress = edtSalePriceKeyPress
            Text = '0'
          end
          object lblVat: TLabel
            Left = 14
            Height = 14
            Top = 145
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Käibemaks:'
            ParentColor = False
          end
          object cmbVatLookup: TDBLookupComboBox
            Left = 121
            Height = 28
            Top = 142
            Width = 132
            DataField = 'vat_id'
            KeyField = 'id'
            ListField = 'description'
            ListFieldIndex = 0
            LookupCache = False
            OnKeyPress = dbEdtDiscountPercKeyPress
            Style = csDropDownList
            TabOrder = 6
          end
          object lbBarCode: TLabel
            Left = 14
            Height = 14
            Top = 168
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Vöötkood:'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object dbEdtBarcode: TDBEdit
            Left = 182
            Height = 28
            Top = 165
            Width = 71
            DataField = 'barcode'
            DataSource = qryArticlesDs
            Anchors = [akTop, akLeft, akRight]
            CharCase = ecNormal
            Constraints.MaxWidth = 200
            MaxLength = 0
            ParentFont = False
            TabOrder = 8
            OnKeyPress = dbEdtProdCodeKeyPress
          end
          object cmbBarCodeTypes: TComboBox
            Left = 121
            Height = 28
            Top = 165
            Width = 58
            ItemHeight = 20
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = dbEdtProdCodeKeyPress
            ParentFont = False
            TabOrder = 7
          end
          object lblSaleAcc: TLabel
            Left = 14
            Height = 14
            Top = 236
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Müük:'
            ParentColor = False
          end
          object cmbSaleAcc: TRxDBLookupCombo
            Left = 121
            Height = 32
            Top = 234
            Width = 132
            AutoSize = True
            ButtonOnlyWhenFocused = False
            ButtonWidth = 15
            Color = clWindow
            DataField = 'sale_account_id'
            DataSource = qryArticlesDs
            PopUpFormOptions.BorderStyle = bsSingle
            PopUpFormOptions.Columns = <            
              item
                Alignment = taLeftJustify
                Color = clWindow
                FieldName = 'account_coding'
                Title.Orientation = toHorizontal
                Title.Alignment = taCenter
                Title.Layout = tlTop
                Title.Caption = 'Konto'
                Title.Color = clBtnFace
                Width = 65
              end            
              item
                Alignment = taLeftJustify
                Color = clWindow
                FieldName = 'account_name'
                Title.Orientation = toHorizontal
                Title.Alignment = taCenter
                Title.Layout = tlTop
                Title.Caption = 'Konto nimetus'
                Title.Color = clBtnFace
                Width = 215
              end>
            PopUpFormOptions.DropDownCount = 15
            PopUpFormOptions.DropDownWidth = 385
            PopUpFormOptions.ShowTitles = True
            PopUpFormOptions.TitleButtons = True
            Flat = False
            Glyph.Data = {
              72000000424D7200000000000000360000002800000005000000030000000100
              2000000000003C00000064000000640000000000000000000000000000000000
              0000000000FF000000000000000000000000000000FF000000FF000000FF0000
              0000000000FF000000FF000000FF000000FF000000FF
            }
            EmptyValue = ' '
            NumGlyphs = 1
            OnClosePopupNotif = cmbSaleAccClosePopupNotif
            OnKeyDown = cmbSaleAccKeyDown
            OnKeyPress = cmbSaleAccKeyPress
            OnSelect = cmbSaleAccSelect
            ParentColor = False
            ReadOnly = False
            TabOrder = 13
            TabStop = True
            DropDownCount = 15
            DropDownWidth = 385
            LookupDisplay = 'account_coding;account_name'
            LookupField = 'id'
            LookupSource = qrySaleAccountsDs
          end
          object lblPurcAcc: TLabel
            Left = 14
            Height = 14
            Top = 258
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Ost:'
            ParentColor = False
          end
          object cmbPurcAcc: TRxDBLookupCombo
            Left = 121
            Height = 32
            Top = 257
            Width = 132
            AutoSize = True
            ButtonOnlyWhenFocused = False
            ButtonWidth = 15
            Color = clWindow
            DataField = 'purchase_account_id'
            DataSource = qryArticlesDs
            PopUpFormOptions.BorderStyle = bsSingle
            PopUpFormOptions.Columns = <            
              item
                Alignment = taLeftJustify
                Color = clWindow
                FieldName = 'account_coding'
                Title.Orientation = toHorizontal
                Title.Alignment = taCenter
                Title.Layout = tlTop
                Title.Caption = 'Konto'
                Title.Color = clBtnFace
                Width = 65
              end            
              item
                Alignment = taLeftJustify
                Color = clWindow
                FieldName = 'account_name'
                Title.Orientation = toHorizontal
                Title.Alignment = taCenter
                Title.Layout = tlTop
                Title.Caption = 'Konto nimetus'
                Title.Color = clBtnFace
                Width = 215
              end>
            PopUpFormOptions.DropDownCount = 15
            PopUpFormOptions.DropDownWidth = 385
            PopUpFormOptions.ShowTitles = True
            PopUpFormOptions.TitleButtons = True
            Flat = False
            Glyph.Data = {
              72000000424D7200000000000000360000002800000005000000030000000100
              2000000000003C00000064000000640000000000000000000000000000000000
              0000000000FF000000000000000000000000000000FF000000FF000000FF0000
              0000000000FF000000FF000000FF000000FF000000FF
            }
            EmptyValue = ' '
            NumGlyphs = 1
            OnClosePopupNotif = cmbSaleAccClosePopupNotif
            OnKeyDown = cmbSaleAccKeyDown
            OnKeyPress = cmbSaleAccKeyPress
            OnSelect = cmbSaleAccSelect
            ParentColor = False
            ReadOnly = False
            TabOrder = 14
            TabStop = True
            DropDownCount = 15
            DropDownWidth = 385
            LookupDisplay = 'account_coding;account_name'
            LookupField = 'id'
            LookupSource = qryPurcAccountsDs
          end
          object lbCostAcc: TLabel
            Left = 14
            Height = 14
            Top = 282
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Kulu:'
            ParentColor = False
          end
          object cmbCostAcc: TRxDBLookupCombo
            Left = 121
            Height = 32
            Top = 280
            Width = 132
            AutoSize = True
            ButtonOnlyWhenFocused = False
            ButtonWidth = 15
            Color = clWindow
            DataField = 'expense_account_id'
            DataSource = qryArticlesDs
            PopUpFormOptions.BorderStyle = bsSingle
            PopUpFormOptions.Columns = <            
              item
                Alignment = taLeftJustify
                Color = clWindow
                FieldName = 'account_coding'
                Title.Orientation = toHorizontal
                Title.Alignment = taCenter
                Title.Layout = tlTop
                Title.Caption = 'Konto'
                Title.Color = clBtnFace
                Width = 65
              end            
              item
                Alignment = taLeftJustify
                Color = clWindow
                FieldName = 'account_name'
                Title.Orientation = toHorizontal
                Title.Alignment = taCenter
                Title.Layout = tlTop
                Title.Caption = 'Konto nimetus'
                Title.Color = clBtnFace
                Width = 215
              end>
            PopUpFormOptions.DropDownCount = 15
            PopUpFormOptions.DropDownWidth = 385
            PopUpFormOptions.ShowTitles = True
            PopUpFormOptions.TitleButtons = True
            Flat = False
            Glyph.Data = {
              72000000424D7200000000000000360000002800000005000000030000000100
              2000000000003C00000064000000640000000000000000000000000000000000
              0000000000FF000000000000000000000000000000FF000000FF000000FF0000
              0000000000FF000000FF000000FF000000FF000000FF
            }
            EmptyValue = ' '
            NumGlyphs = 1
            OnClosePopupNotif = cmbSaleAccClosePopupNotif
            OnKeyDown = cmbSaleAccKeyDown
            OnKeyPress = cmbSaleAccKeyPress
            OnSelect = cmbSaleAccSelect
            ParentColor = False
            ReadOnly = False
            TabOrder = 15
            TabStop = True
            DropDownCount = 15
            DropDownWidth = 385
            LookupDisplay = 'account_coding;account_name'
            LookupField = 'id'
            LookupSource = qryPurcAccountsDs
          end
          object Image2: TImage
            Left = 4
            Height = 47
            Top = 4
            Width = 48
            Stretch = True
            Transparent = True
          end
          object lblArtAmount: TLabel
            Tag = -1
            Left = 14
            Height = 14
            Top = 329
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Saadavus:'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object lblDimension: TLabel
            Left = 14
            Height = 14
            Top = 191
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Mõõdud:'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object dbEdtDimH: TDBEdit
            Left = 121
            Height = 28
            Top = 188
            Width = 37
            DataField = 'dim_h'
            DataSource = qryArticlesDs
            CharCase = ecNormal
            Constraints.MaxWidth = 300
            MaxLength = 0
            ParentFont = False
            TabOrder = 9
            OnKeyPress = dbEdtProdCodeKeyPress
          end
          object lblManufacturer: TLabel
            Left = 14
            Height = 14
            Top = 214
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Tootja:'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object cmbManufacturer: TDBComboBox
            Left = 121
            Height = 28
            Top = 211
            Width = 133
            DataField = 'manufacturer'
            DataSource = qryArticlesDs
            ItemHeight = 20
            MaxLength = 0
            OnClick = cmbUnitClick
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = dbEdtProdCodeKeyPress
            ParentFont = False
            TabOrder = 12
          end
          object lblShelfNumber: TLabel
            Left = 14
            Height = 14
            Top = 306
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Riiuli number:'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object dbRankNr: TDBEdit
            Left = 121
            Height = 28
            Top = 303
            Width = 133
            DataField = 'shelfnumber'
            DataSource = qryArticlesDs
            CharCase = ecNormal
            Constraints.MaxWidth = 300
            Constraints.MinWidth = 120
            MaxLength = 0
            ParentFont = False
            TabOrder = 16
            OnKeyPress = dbEdtProdCodeKeyPress
          end
          object edtArtRelAmountTotal: TEdit
            Tag = -1
            Left = 121
            Height = 28
            Top = 326
            Width = 132
            Alignment = taRightJustify
            Color = 16772810
            Constraints.MinWidth = 120
            MaxLength = 25
            ReadOnly = True
            TabStop = False
            TabOrder = 17
          end
          object dbEdtDimL: TDBEdit
            Left = 169
            Height = 28
            Top = 188
            Width = 37
            DataField = 'dim_l'
            DataSource = qryArticlesDs
            CharCase = ecNormal
            Constraints.MaxWidth = 300
            MaxLength = 0
            ParentFont = False
            TabOrder = 10
            OnKeyPress = dbEdtProdCodeKeyPress
          end
          object dbEdtDimW: TDBEdit
            Left = 217
            Height = 28
            Top = 188
            Width = 37
            DataField = 'dim_w'
            DataSource = qryArticlesDs
            CharCase = ecNormal
            Constraints.MaxWidth = 300
            MaxLength = 0
            ParentFont = False
            TabOrder = 11
            OnKeyPress = dbEdtProdCodeKeyPress
          end
          object x1: TLabel
            Left = 160
            Height = 20
            Top = 191
            Width = 8
            Caption = 'x'
            ParentColor = False
          end
          object x2: TLabel
            Left = 209
            Height = 20
            Top = 191
            Width = 8
            Caption = 'x'
            ParentColor = False
          end
          object chkboxAllowedInSale: TCheckBox
            Left = 121
            Height = 24
            Top = 369
            Width = 135
            Caption = 'Artikkel müügis'
            Checked = True
            OnChange = chkboxAllowedInSaleChange
            State = cbChecked
            TabOrder = 19
          end
          object btnNewArticleType: TSpeedButton
            Left = 236
            Height = 22
            Hint = 'Uus tüüp'
            Top = 4
            Width = 23
            Enabled = False
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              2000000000000004000064000000640000000000000000000000FFFFFF00898E
              8C94858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A
              88FF858A88FF858A88FF858A88FF858A88FF8A8F8D94FFFFFF00FFFFFF00858A
              88FEF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FF000000FFF8F8
              F8FF000000FFF8F8F8FFF8F8F8FFF8F8F8FF888D8BFEFFFFFF00FFFFFF00858A
              88FFF9F9F9FFDBC3ADFFDCC4AEFFDDC5AFFFDEC6B0FFDFC7B1FFE0C8B2FF0000
              00FFF7F7F7FFF9F9F9FFF8F8F8FFF7F7F7FF888D8BFFFFFFFF00FFFFFF00858A
              88FFF9F9F9FFDBC3ADFFB09882FFB09882FFB09882FFB09882FFE0C8B2FF0000
              00FFF7F7F7FFF8F8F8FFF7F7F7FFF7F7F7FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFAFAFAFFDBC3ADFFDCC4AEFFDDC5AFFFDEC6B0FFDFC7B1FFE0C8B2FF0000
              00FFF5F5F5FFF6F6F6FFF6F6F6FFF7F7F7FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFBFBFBFFDBC3ADFFDCC4AEFFDDC5AFFFDEC6B0FFDEC6B0FF000000FFE0C8
              B2FF000000FFE1C9B3FFF4F4F4FFF7F7F7FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFBFBFBFFDAC2ACFFAF9781FFAF9781FFAF9781FFAF9781FFAF9781FFAF97
              81FFAF9781FFE0C8B2FFF2F2F2FFF7F7F7FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFCFCFCFFDAC2ACFFDBC3ADFFDCC4AEFFDDC5AFFFDDC5AFFFDEC6B0FFDEC6
              B0FFDFC7B1FFDFC7B1FFF0F0F0FFF8F8F8FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFCFCFCFFDAC2ACFFDAC2ACFFDBC3ADFFDCC4AEFFDDC5AFFFDDC5AFFFDEC6
              B0FFDEC6B0FFDEC6B0FFEEEEEEFFF8F8F8FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFCFCFCFFD9C1ABFFAF9781FFAF9781FFAF9781FFAF9781FFDCC4AEFFAF97
              81FFAF9781FFDDC5AFFFECECECFFF8F8F8FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFDFDFDFFD8C0AAFFAF9781FFAF9781FFAF9781FFAF9781FFDBC3ADFFDCC4
              AEFFDCC4AEFFDCC4AEFFEBEBEBFFF8F8F8FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFDFDFDFFD8C0AAFFAF9781FFAF9781FFAF9781FFAF9781FFDBC3ADFFDBC3
              ADFFDBC3ADFFDBC3ADFFDBC3ADFFF8F8F8FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFEFEFEFFD7BFA9FFAF9781FFAF9781FFAF9781FFAF9781FFDAC2ACFFAF97
              81FFAF9781FFAF9781FFDAC2ACFFF8F8F8FF888D8BFFFFFFFF00FFFFFF00858A
              88FFFDFDFDFFD6BEA8FFD7BFA9FFD7BFA9FFD8C0AAFFD8C0AAFFD9C1ABFFD9C1
              ABFFD9C1ABFFD9C1ABFFD9C1ABFFF8F8F8FF888D8BFFFFFFFF00FFFFFF00858A
              88FEFDFDFDFFFEFEFEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFB
              FBFFFBFBFBFFFAFAFAFFFAFAFAFFF9F9F9FF888D8BFEFFFFFF00FFFFFF00898D
              8B94858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A
              88FF858A88FF858A88FF858A88FF858A88FF898E8C94FFFFFF00
            }
            OnClick = btnNewArticleTypeClick
            ShowHint = True
            ParentShowHint = False
          end
          object chkboxAllowedInweb: TCheckBox
            Left = 121
            Height = 24
            Top = 350
            Width = 209
            Caption = 'Kuvatakse veebikataloogis'
            OnChange = chkboxAllowedInSaleChange
            TabOrder = 18
          end
        end
        object tabProductSeries: TTabSheet
          Caption = 'Kombineeri'
        end
        object tabPageExtInfo: TTabSheet
          Caption = 'Täiendav info'
          ClientHeight = 390
          ClientWidth = 320
          object lblDescr: TLabel
            Left = 20
            Height = 14
            Top = 4
            Width = 104
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Kirjeldus:'
            ParentColor = False
          end
          object pResizeFix: TPanel
            Left = 129
            Height = 210
            Top = 4
            Width = 186
            Anchors = [akTop, akLeft, akRight]
            BevelInner = bvLowered
            ClientHeight = 210
            ClientWidth = 186
            Constraints.MinHeight = 100
            Constraints.MinWidth = 65
            TabOrder = 0
            object memProdDesc: TDBMemo
              Left = 3
              Height = 205
              Top = 3
              Width = 181
              Anchors = [akTop, akLeft, akRight, akBottom]
              DataField = 'descr'
              DataSource = qryArticlesDs
              ParentFont = False
              ScrollBars = ssAutoBoth
              TabOrder = 0
            end
          end
        end
      end
    end
    object Splitter1: TSplitter
      Left = 375
      Height = 409
      Top = 0
      Width = 4
      Color = clBtnFace
      ParentColor = False
    end
  end
  object btnNewArticle: TBitBtn[1]
    Tag = -1
    Left = 285
    Height = 30
    Top = 459
    Width = 95
    Anchors = [akRight, akBottom]
    Caption = 'Uus artikkel'
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
    OnClick = btnNewArticleClick
    TabOrder = 1
  end
  object btnSave: TBitBtn[2]
    Tag = -1
    Left = 381
    Height = 30
    Top = 459
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
  object btnCancel: TBitBtn[3]
    Tag = -1
    Left = 477
    Height = 30
    Top = 459
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
  object btnClose: TBitBtn[4]
    Tag = -1
    Left = 617
    Height = 30
    Top = 459
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
  object qryArticles: TZQuery[5]
    AutoCalcFields = False
    BeforeScroll = qryArticlesBeforeScroll
    AfterScroll = qryArticlesAfterScroll
    UpdateObject = qryArtInsUpdt
    CachedUpdates = True
    AfterInsert = qryArticlesAfterInsert
    AfterEdit = qryArticlesAfterEdit
    BeforePost = qryArticlesBeforePost
    AfterPost = qryArticlesAfterPost
    Params = <>
    Sequence = qryArticlesSeq
    SequenceField = 'id'
    Left = 40
    Top = 384
  end
  object qryArticlesDs: TDataSource[6]
    DataSet = qryArticles
    Left = 208
    Top = 384
  end
  object qryArtInsUpdt: TZUpdateSQL[7]
    UseSequenceFieldForRefreshSQL = False
    Left = 120
    Top = 384
  end
  object imageCapt: TImageList[8]
    Left = 216
    Bitmap = {
      4C69020000001000000010000000FFF7FAFFF9F5FBFFF8FBFFFFF1F9FFFFF5FA
      FDFFF7F8F4FFFFFFF8FFFFFFF7FFFFFFFCFFF5EDEEFFFFFDFDFFFFFEFEFFFFFA
      FAFFF2EEF3FFF4FBFFFF00000000FFFFD5FF7D5122FF714E26FF6A4A26FF7253
      26FF775323FF815C24FF724A15FF744C1CFF896033FF7A4C1DFF744414FF8858
      24FF835728FFFFFDD9FF00000000FFFFF0FF594C3EFFD6D3CFFFE0E4E5FFDADF
      DDFFD2D6D1FFE3E3DDFFE4E3DFFFDFE1E1FFEEEDEFFFEDE6E3FFFFF8F2FFFBEE
      E0FF544A40FFFBF8F4FF00000000FFFFE2FF5F4A34FFE2DCCFFFCFD1CBFFDBDF
      D9FFDFE3DDFFDEE3DAFFE6EAE5FFE3E7E8FFE6E8E9FFF8F1EEFFFFF6ECFFFFF7
      E4FF564734FFFFFAEDFF00000000FFFDE8FF5C4F41FFDFE0DCFFD8E1E5FFDEEA
      EEFFD4E2E8FFCEDCE2FFDFEEF7FFD8E8F5FFE3EEFCFFF0F6FDFFEFEDEDFFFAF1
      E7FF595046FFFCFCF6FF00000000FFFFE4FF5A452FFFDAD4C7FFE1E3DDFFDEE4
      DFFFE2E8E3FFE8EEE9FFE1E6E5FFE9F0F3FFEDF0F4FFEAE7E3FFFFFEF4FFFFFD
      ECFF564635FFFFFFF2FF00000000FFFFECFF5F4F3EFFEBE7E2FFE1E3E3FFD9E0
      DDFFE1E6E4FFF6FAF4FFEBEEECFFECF1F4FFF9FCFFFFF8F3F2FFFFFAF4FFFFF9
      EBFF544739FFFFFEF9FF00000000FFFFEAFF584939FFE8E4DFFFDEE0E0FFF1F5
      F0FFE8E9E5FFEFF0E7FFF3F2EEFFF2F2F2FFF1EEF0FFFFF9F4FFFFF7EFFFFFFC
      EFFF5B4F43FFFFFAF7FF00000000FFFFEAFF5A4C3AFFEDEAE5FFE0E2E2FFE1E6
      E5FFF2F7F6FFE7EAE8FFF5F9FAFFEFFAFEFFE6EFF3FFFCFEFEFFFFFCF4FFFFFF
      F3FF53483AFFFFFFF9FF00000000FFFCE3FF5C4D3AFFEBE8E0FFEEEFEDFFF4F5
      F1FFF5F6F2FFF9F9F3FFEBECEAFFECF4F4FFF8FDFFFFFDFCF8FFFFFFF8FFFFFD
      EDFF564939FFFFFEF5FF00000000FFFFEAFF564530FFF5EEE5FFFAF7F3FFF8F6
      EEFFEBE8E0FFFDFBF0FFFFFFF7FFF9FDF8FFFFFFFEFFFAF8EEFFFFFFF5FFFFFF
      F0FF5A4A39FFFFFFF8FF00000000FFFFE8FF504230FFFFFBF4FFF1EEEAFFF2EF
      EAFFFFFBF2FFFCF8EDFFFAF5ECFFFAFBF7FFF7F5F4FFFFFFF8FFFFFFF5FFFFFF
      F1FF4F4030FFFFFAF3FF00000000FFFFF5FF59514AFFE3E5E6FFEEF2F7FFF8FC
      FDFFF7F8F6FFF8F5F0FFFFFFFCFFFBFFFFFFF9FCFFFFFFFFFEFFFFFFFBFFF4EB
      E2FF5B524EFFFFFEFFFF00000000FFFFCEFF7A5222FF6B4B22FF6A4D28FF7959
      2EFF6B491BFF7A531FFF754D1CFF715023FF6D4B20FF6B4719FF78501FFF8457
      24FF83592AFFFFF7D1FF00000000FFFFF6FFFFF9F5FFFDFFFFFFF9FCFFFFF4F5
      F3FFFDFAF5FFFFFFF7FFFFFAF1FFFFFFF9FFFFFFFCFFFFFDF8FFFFFFF8FFFFF7
      EDFFFEF5F1FFFFFDFFFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EFFCFFFFEEF3FFFFFFFBFFFFFFF3F9FFFFFB
      FCFFFFFDF9FFFDF7ECFFFFFFF6FFFFF6EDFFFEFBF3FFFBFFF9FFF3FBF4FFFDFB
      FBFFFFFAFDFFFFFAFFFF00000000FFFCC8FF845C2CFF6C3F19FF794C2AFF7554
      2DFF72522EFF795634FF724823FF8D592AFF8A5824FF6E4818FF755024FF8151
      27FF7B4B29FFFFFFE4FF00000000FFFFE4FF53492BFFF0ECD9FFE2E7D8FFD3E3
      D2FFD4E5DAFFCCDEDDFFE5EBEAFFEDE4D6FFFCEEDCFFF0F0E4FFFCFAF0FFFFF1
      E5FF544A40FFF3FCF9FF00000000FFF5EBFF60433CFFEBDDD7FFEAE5E4FFE1DD
      E2FFE3E5EDFFE2EBF5FFDCE0EBFFFFF2FAFFFAEEF4FFEBEFF0FFFAFAFAFFFFED
      EDFF5C4341FFFFFFFCFF00000000FFFFEBFF5A4D37FFEEEEDEFFDBDCD8FFEBEB
      F7FFDCDDEBFFD8E6E4FFE2F8ECFFD7F1DFFFCFF3D5FF578B5BFFE0FFD6FFFCFA
      DBFF5C4D3AFFFCFAE8FF00000000FFF8DCFF5B4833FFEDE1DDFFEAE1EBFFE2DF
      F5FFECEAFFFFF1EFF5FFE0EFE1FFD6FFDDFF47884AFF4D8A40FFE9FFCCFFFFFF
      E3FF5E4434FFFFF4FAFF00000000FFFFE6FF584D31FFEBEBDBFFD7EDD5FF4D85
      52FFC2FCC5FFE6FFE0FFD9FFD1FF389638FF2E912FFF478641FFEFFFDCFFFFFF
      D4FF554E2DFFFFFFF8FF00000000FFFAFBFF503B39FFE9EEE5FFD0FED0FF2E99
      25FF319E24FFD1FFC8FF478245FF2A992FFF2B933BFFE0FFFAFFEFF0FAFFFFFF
      F0FF4F4F31FFF3FDEDFF00000000FFF9F6FF624743FFE5ECE7FFD7FFE2FF3889
      3AFF2D9A26FF29AC1CFF2A9E1BFF428633FFEFFFE3FFF0FEECFFFCF9F4FFFFFD
      F1FF5C4D44FFFAF3F0FF00000000FFFBE5FF654D3BFFEDF1E6FFDAF7E0FFC6FF
      CAFF479849FF2E8F2EFF388E36FFE8FFE2FFE4F3DEFFFFFFFBFFFFFFFCFFFFFF
      F4FF574838FFFFFFF5FF00000000FFFFE0FF614D2EFFEDE9DEFFEBF8F0FFE7FF
      ECFFD1FADAFF4C8159FFE2FFECFFF4FDF3FFFFFDFFFFFFFCFFFFFFF5F3FFFFFD
      EDFF5B503AFFF9F7E5FF00000000FFFFDCFF58452AFFFFF9F0FFF8F8F8FFF2F4
      F5FFEAF2F1FFEDFFF8FFECF7F4FFFFF3FBFFFFFAFFFFFFF3F6FFFFFFF9FFFFFF
      F1FF524B38FFFFFFF7FF00000000FFFBEFFF5E524CFFF4F2F2FFF3F1F7FFF6F1
      FAFFFFFCFFFFF1F8FBFFFBFEFFFFFFF5FBFFFFFCFFFFFFFFFBFFFFFFF8FFFFFF
      F7FF494540FFF9FDFFFF00000000FFFFDFFF764C22FF765125FF714A1DFF7F54
      23FF7C5120FF745322FF765222FF8A5A2AFF784715FF7D5B1FFF725316FF7650
      1AFF6E471AFFFFFFE4FF00000000FDF3FFFFFFFDFFFFFCFDF3FFFFFFEFFFFFFF
      F1FFFFFFF4FFFAF7EFFFFDF8F5FFFFFAFBFFFFFCFAFFF9F9EDFFFFFFF7FFFFFF
      F8FFFFFAF7FFFFFCFFFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000
    }
  end
  object qryVerifData: TZReadOnlyQuery[9]
    AutoCalcFields = False
    Params = <>
    Left = 296
    Top = 384
  end
  object qryArticlesSeq: TZSequence[10]
    SequenceName = 'articles_id_seq'
    Left = 40
    Top = 328
  end
  object qrySavePriceChanges: TZQuery[11]
    AutoCalcFields = False
    Params = <>
    Left = 120
    Top = 328
  end
  object qryVAT: TZQuery[12]
    AutoCalcFields = False
    CachedUpdates = True
    Params = <>
    Left = 208
    Top = 328
  end
  object qryVATds: TDataSource[13]
    DataSet = qryVAT
    Left = 296
    Top = 224
  end
  object qrySaleAccounts: TZReadOnlyQuery[14]
    AutoCalcFields = False
    Params = <>
    Left = 40
    Top = 224
  end
  object qryPurcAccounts: TZReadOnlyQuery[15]
    AutoCalcFields = False
    Params = <>
    Left = 120
    Top = 224
  end
  object qryExpensesAccounts: TZReadOnlyQuery[16]
    AutoCalcFields = False
    Params = <>
    Left = 208
    Top = 224
  end
  object qrySaleAccountsDs: TDataSource[17]
    DataSet = qrySaleAccounts
    Left = 40
    Top = 280
  end
  object qryPurcAccountsDs: TDataSource[18]
    DataSet = qryPurcAccounts
    Left = 120
    Top = 280
  end
  object qryExpensesAccountsDs: TDataSource[19]
    DataSet = qryExpensesAccounts
    Left = 208
    Top = 280
  end
end
