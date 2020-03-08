object frameWarehouses: TframeWarehouses
  Left = 0
  Height = 488
  Top = 0
  Width = 699
  ClientHeight = 488
  ClientWidth = 699
  TabOrder = 0
  DesignLeft = 143
  DesignTop = 269
  object grpBoxWarehouse: TGroupBox
    Left = 6
    Height = 418
    Top = 4
    Width = 687
    Anchors = [akTop, akLeft, akRight, akBottom]
    Caption = ' Ladu '
    ClientHeight = 400
    ClientWidth = 683
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object pmainPanel: TPanel
      Left = 0
      Height = 400
      Top = 0
      Width = 683
      Align = alClient
      BevelOuter = bvNone
      ClientHeight = 400
      ClientWidth = 683
      TabOrder = 0
      object leftPanel: TPanel
        Left = 0
        Height = 400
        Top = 0
        Width = 271
        Align = alLeft
        Anchors = [akTop, akLeft, akRight, akBottom]
        BevelOuter = bvNone
        ClientHeight = 400
        ClientWidth = 271
        Constraints.MaxWidth = 325
        Constraints.MinWidth = 180
        TabOrder = 0
        object dbWhGrid: TDBGrid
          Tag = -1
          Left = 7
          Height = 393
          Top = 0
          Width = 264
          Anchors = [akTop, akLeft, akRight, akBottom]
          AutoEdit = False
          Color = clWindow
          Columns = <          
            item
              Title.Caption = 'Kood'
              Width = 40
              FieldName = 'warehousecode'
            end          
            item
              Title.Caption = 'Nimi'
              Title.ImageIndex = 1
              Title.ImageLayout = blGlyphLeft
              Width = 220
              FieldName = 'warehousename'
            end>
          DataSource = qryWarehouseDs
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgHeaderHotTracking, dgHeaderPushedLook]
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          TitleStyle = tsNative
        end
      end
      object rightPanel: TPanel
        Left = 277
        Height = 400
        Top = 0
        Width = 406
        Align = alClient
        BevelOuter = bvNone
        ClientHeight = 400
        ClientWidth = 406
        Constraints.MinWidth = 180
        TabOrder = 1
        object lblWarehouseCode: TLabel
          Left = 5
          Height = 15
          Top = 4
          Width = 140
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Lao kood:'
          ParentColor = False
        end
        object dbEdtWarehouseCode: TDBEdit
          Left = 148
          Height = 21
          Top = 1
          Width = 164
          DataField = 'warehousecode'
          DataSource = qryWarehouseDs
          CharCase = ecNormal
          MaxLength = 0
          TabOrder = 0
          OnKeyPress = dbEdtWarehouseCodeKeyPress
        end
        object lblWhCountry: TLabel
          Left = 6
          Height = 14
          Top = 50
          Width = 139
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Riik:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbCountry: TComboBox
          Left = 148
          Height = 21
          Top = 47
          Width = 164
          AutoComplete = True
          AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactSearchAscending]
          ItemHeight = 13
          OnChange = cmbCountryChange
          OnKeyPress = dbEdtWarehouseCodeKeyPress
          Style = csDropDownList
          TabOrder = 2
        end
        object lblWarehouseName: TLabel
          Left = 6
          Height = 15
          Top = 27
          Width = 139
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nimetus:'
          ParentColor = False
        end
        object dbEdtWarehouseName: TDBEdit
          Left = 148
          Height = 21
          Top = 24
          Width = 232
          DataField = 'warehousename'
          DataSource = qryWarehouseDs
          CharCase = ecNormal
          MaxLength = 0
          TabOrder = 1
          OnKeyPress = dbEdtWarehouseCodeKeyPress
        end
        object lblWarehouseHouseNr: TLabel
          Left = 5
          Height = 15
          Top = 142
          Width = 140
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Maja nr:'
          ParentColor = False
        end
        object dbEdtWarehouseHousenr: TDBEdit
          Left = 148
          Height = 21
          Top = 139
          Width = 164
          DataField = 'house_nr'
          DataSource = qryWarehouseDs
          CharCase = ecNormal
          MaxLength = 0
          TabOrder = 4
          OnKeyPress = dbEdtWarehouseCodeKeyPress
        end
        object lblWarehouseApartmentnr: TLabel
          Left = 5
          Height = 15
          Top = 165
          Width = 140
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Korteri nr:'
          ParentColor = False
        end
        object dbWarehouseApNr: TDBEdit
          Left = 148
          Height = 21
          Top = 162
          Width = 164
          DataField = 'apartment_nr'
          DataSource = qryWarehouseDs
          CharCase = ecNormal
          MaxLength = 0
          TabOrder = 5
          OnKeyPress = dbEdtWarehouseCodeKeyPress
        end
        object lbWarehousePostIdx: TLabel
          Left = 6
          Height = 14
          Top = 188
          Width = 139
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Postiindeks:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object dbEdtWarehousePostIndex: TDBEdit
          Left = 148
          Height = 21
          Top = 185
          Width = 164
          DataField = 'zipcode'
          DataSource = qryWarehouseDs
          CharCase = ecNormal
          MaxLength = 0
          TabOrder = 6
          OnKeyPress = dbEdtWarehouseCodeKeyPress
        end
        object lblWarehousePhone: TLabel
          Left = 5
          Height = 14
          Top = 211
          Width = 140
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Telefon:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object dbEdtCustPhone: TDBEdit
          Left = 148
          Height = 21
          Top = 208
          Width = 232
          DataField = 'phone'
          DataSource = qryWarehouseDs
          CharCase = ecNormal
          MaxLength = 0
          TabOrder = 7
          OnKeyPress = dbEdtWarehouseCodeKeyPress
        end
        object lblWarehouseEmail: TLabel
          Left = 5
          Height = 14
          Top = 234
          Width = 140
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'E-post:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object dbEdtWarehouseEMail: TDBEdit
          Left = 148
          Height = 21
          Top = 231
          Width = 232
          DataField = 'email'
          DataSource = qryWarehouseDs
          CharCase = ecNormal
          MaxLength = 0
          TabOrder = 8
          OnKeyPress = dbEdtWarehouseCodeKeyPress
        end
        object lblWarehouseChief: TLabel
          Left = 6
          Height = 14
          Top = 257
          Width = 139
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Juhataja:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object dbEdtWarehouseChief: TDBEdit
          Left = 148
          Height = 21
          Top = 254
          Width = 232
          DataField = 'head'
          DataSource = qryWarehouseDs
          CharCase = ecNormal
          MaxLength = 0
          TabOrder = 9
          OnKeyPress = dbEdtWarehouseCodeKeyPress
        end
        object lblWarehousePriceCalcMeth: TLabel
          Left = 6
          Height = 14
          Top = 326
          Width = 139
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kuluarvestuse meetod:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbPrCalcMeth: TComboBox
          Left = 148
          Height = 21
          Top = 323
          Width = 164
          ItemHeight = 13
          OnChange = cmbPrCalcMethChange
          Style = csDropDownList
          TabOrder = 10
        end
        object lblWarehousePriceCalcMeth1: TLabel
          Left = 3
          Height = 13
          Top = 349
          Width = 139
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Lisainfo:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object dummyTabFix: TEdit
          Left = 148
          Height = 21
          Top = 71
          Width = 2
          ReadOnly = True
          TabOrder = 3
          Text = 'dummyTabFix'
        end
        object lblWarehouseAcc: TLabel
          Left = 6
          Height = 14
          Top = 280
          Width = 139
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Lao konto:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbSaleAcc: TRxDBLookupCombo
          Left = 148
          Height = 21
          Top = 277
          Width = 188
          AutoSize = True
          ButtonOnlyWhenFocused = False
          ButtonWidth = 15
          Color = clWindow
          DataField = 'revenue_account_id'
          DataSource = qryWarehouseDs
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
              Width = 135
            end>
          PopUpFormOptions.DropDownCount = 15
          PopUpFormOptions.DropDownWidth = 280
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
          OnSelect = cmbSaleAccSelect
          ParentColor = False
          ReadOnly = False
          TabOrder = 11
          TabStop = True
          DropDownCount = 15
          DropDownWidth = 280
          LookupDisplay = 'account_coding;account_name'
          LookupField = 'id'
          LookupSource = qryWarehouseAccDs
        end
        object lblWarehouseExpAcc: TLabel
          Left = 6
          Height = 14
          Top = 303
          Width = 139
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Lao kulukonto:'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object cmbSaleAcc1: TRxDBLookupCombo
          Left = 148
          Height = 21
          Top = 300
          Width = 188
          AutoSize = True
          ButtonOnlyWhenFocused = False
          ButtonWidth = 15
          Color = clWindow
          DataField = 'charge_account_id'
          DataSource = qryWarehouseDs
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
              Width = 135
            end>
          PopUpFormOptions.DropDownCount = 15
          PopUpFormOptions.DropDownWidth = 280
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
          OnSelect = cmbSaleAccSelect
          ParentColor = False
          ReadOnly = False
          TabOrder = 12
          TabStop = True
          DropDownCount = 15
          DropDownWidth = 280
          LookupDisplay = 'account_coding;account_name'
          LookupField = 'id'
          LookupSource = qryWarehouseExpAccDs
        end
        object cPanel: TPanel
          Left = 148
          Height = 36
          Top = 346
          Width = 232
          Anchors = [akTop, akLeft, akRight, akBottom]
          BevelOuter = bvNone
          ClientHeight = 36
          ClientWidth = 232
          Constraints.MaxHeight = 300
          Constraints.MaxWidth = 300
          TabOrder = 13
          object dbMemoextinfo: TDBMemo
            Left = 0
            Height = 36
            Top = 0
            Width = 232
            Align = alClient
            DataField = 'descr'
            DataSource = qryWarehouseDs
            TabOrder = 0
          end
        end
      end
      object Splitter1: TSplitter
        Left = 271
        Height = 400
        Top = 0
        Width = 6
      end
    end
  end
  object btnNewWarehouse: TBitBtn
    Tag = -1
    Left = 264
    Height = 30
    Top = 443
    Width = 95
    Anchors = [akRight, akBottom]
    Caption = 'Uus ladu'
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
    OnClick = btnNewWarehouseClick
    TabOrder = 1
  end
  object btnSave: TBitBtn
    Tag = -1
    Left = 360
    Height = 30
    Top = 443
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
    Left = 456
    Height = 30
    Top = 443
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
    TabOrder = 4
  end
  object qryWarehouse: TZQuery
    AutoCalcFields = False
    BeforeScroll = qryWarehouseBeforeScroll
    AfterScroll = qryWarehouseAfterScroll
    UpdateObject = qryWarehouseUpdt
    CachedUpdates = True
    AfterInsert = qryWarehouseAfterInsert
    AfterEdit = qryWarehouseAfterEdit
    BeforePost = qryWarehouseBeforePost
    Params = <>
    Sequence = qryWarehouseSeq
    SequenceField = 'id'
    left = 48
    top = 8
  end
  object qryWarehouseDs: TDatasource
    DataSet = qryWarehouse
    left = 144
    top = 8
  end
  object qryWarehouseUpdt: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    left = 48
    top = 72
  end
  object qryWarehouseSeq: TZSequence
    SequenceName = 'warehouse_id_seq'
    left = 144
    top = 72
  end
  object qryWarehouseAcc: TZQuery
    AutoCalcFields = False
    ReadOnly = True
    Params = <>
    left = 48
    top = 128
  end
  object qryWarehouseExpAcc: TZQuery
    AutoCalcFields = False
    ReadOnly = True
    Params = <>
    left = 144
    top = 128
  end
  object qryWarehouseAccDs: TDatasource
    AutoEdit = False
    DataSet = qryWarehouseAcc
    left = 49
    top = 184
  end
  object qryWarehouseExpAccDs: TDatasource
    AutoEdit = False
    DataSet = qryWarehouseExpAcc
    left = 144
    top = 184
  end
  object qryVerifyData: TZReadOnlyQuery
    AutoCalcFields = False
    Params = <>
    left = 232
    top = 8
  end
end
