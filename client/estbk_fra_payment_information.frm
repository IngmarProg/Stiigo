object framePaymentInformation: TframePaymentInformation
  Left = 0
  Height = 488
  Top = 0
  Width = 699
  ClientHeight = 488
  ClientWidth = 699
  TabOrder = 0
  DesignLeft = 248
  DesignTop = 260
  object grpItems: TGroupBox
    Left = 6
    Height = 416
    Top = 7
    Width = 687
    Anchors = [akTop, akLeft, akRight, akBottom]
    Caption = ' Laekumised '
    ClientHeight = 398
    ClientWidth = 683
    TabOrder = 0
    object gridPaymentItems: TDBGrid
      Left = 5
      Height = 336
      Top = 1
      Width = 672
      Anchors = [akTop, akLeft, akRight, akBottom]
      Color = clWindow
      Columns = <      
        item
          Title.Caption = 'Allikas'
          FieldName = 'source'
        end      
        item
          Title.Caption = 'Nr'
          Width = 65
          FieldName = 'acc_number'
        end      
        item
          Title.Caption = 'Kuupäev'
          FieldName = 'payment_date'
        end      
        item
          Title.Caption = 'Pank'
          Width = 105
          FieldName = 'bank_long_name'
        end      
        item
          Title.Caption = 'Konto'
          Width = 85
        end      
        item
          Title.Caption = 'Pangakonto nr'
          Width = 85
        end      
        item
          Title.Caption = 'Tasus'
          Width = 145
        end      
        item
          Title.Caption = 'Tasuja pangakonto nr'
          Width = 100
        end      
        item
          Title.Caption = 'Summa'
          Width = 85
        end      
        item
          Title.Caption = 'Valuuta'
        end>
      DataSource = qryPaymentDataDs
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
      TabOrder = 0
      TitleStyle = tsNative
      OnDrawColumnCell = gridPaymentItemsDrawColumnCell
      OnDblClick = gridPaymentItemsDblClick
      OnKeyDown = gridPaymentItemsKeyDown
      OnPrepareCanvas = gridPaymentItemsPrepareCanvas
    end
    object Bevel1: TBevel
      Left = 5
      Height = 5
      Top = 338
      Width = 672
      Anchors = [akLeft, akRight, akBottom]
      Shape = bsTopLine
    end
    object pExtInform: TMemo
      Left = 5
      Height = 55
      Top = 338
      Width = 672
      Anchors = [akLeft, akRight, akBottom]
      ReadOnly = True
      TabOrder = 1
    end
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
  object qryPaymentData: TZReadOnlyQuery
    AfterScroll = qryPaymentDataAfterScroll
    Params = <>
    left = 544
    top = 13
  end
  object qryPaymentDataDs: TDatasource
    AutoEdit = False
    DataSet = qryPaymentData
    left = 640
    top = 13
  end
end
