object frameVATs: TframeVATs
  Left = 0
  Height = 439
  Top = 0
  Width = 590
  ClientHeight = 439
  ClientWidth = 590
  TabOrder = 0
  DesignLeft = 223
  DesignTop = 299
  object leftPanel: TPanel
    Left = 0
    Height = 439
    Top = 0
    Width = 243
    Align = alLeft
    BevelOuter = bvNone
    ClientHeight = 439
    ClientWidth = 243
    Constraints.MaxWidth = 350
    Constraints.MinWidth = 100
    TabOrder = 0
    object gridVat: TDBGrid
      Left = 3
      Height = 435
      Top = 2
      Width = 239
      Anchors = [akTop, akLeft, akRight, akBottom]
      Color = clWindow
      Columns = <      
        item
          Title.Caption = 'Nimetus'
          Width = 160
          FieldName = 'description'
        end      
        item
          Title.Caption = '%'
          Width = 40
          FieldName = 'perc'
        end>
      DataSource = qryVatDs
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleStyle = tsNative
    end
  end
  object Splitter1: TSplitter
    Left = 243
    Height = 439
    Top = 0
    Width = 5
  end
  object rightPanel: TPanel
    Left = 248
    Height = 439
    Top = 0
    Width = 342
    Align = alClient
    BevelOuter = bvNone
    ClientHeight = 439
    ClientWidth = 342
    TabOrder = 2
    object lblVatname: TLabel
      Left = 33
      Height = 14
      Top = 24
      Width = 101
      AutoSize = False
      Caption = 'Käibemaksu nimetus:'
      ParentColor = False
    end
    object dbEdtVatName: TDBEdit
      Left = 136
      Height = 21
      Top = 22
      Width = 184
      DataField = 'description'
      DataSource = qryVatDs
      Anchors = [akTop, akLeft, akRight]
      CharCase = ecNormal
      Constraints.MaxWidth = 285
      MaxLength = 255
      TabOrder = 0
      OnKeyPress = dbEdtVatNameKeyPress
    end
    object lblVatPerc: TLabel
      Left = 29
      Height = 14
      Top = 48
      Width = 105
      Caption = 'Käibemaksu protsent:'
      ParentColor = False
    end
    object dbEdtVatPerc: TDBEdit
      Left = 136
      Height = 21
      Top = 45
      Width = 53
      DataField = 'oprc'
      DataSource = qryVatDs
      CharCase = ecNormal
      MaxLength = 3
      TabOrder = 1
      OnKeyPress = dbEdtVatPercKeyPress
    end
    object ptrnVat: TCheckBox
      Left = 136
      Height = 17
      Top = 120
      Width = 128
      AutoSize = False
      Caption = 'Pöördkäibemaks'
      OnChange = ptrnVatChange
      OnKeyPress = dbEdtVatNameKeyPress
      TabOrder = 4
    end
    object lblSaleVat: TLabel
      Left = 16
      Height = 14
      Top = 71
      Width = 118
      Caption = 'Müügikäibemaksu konto:'
      ParentColor = False
    end
    object lblSaleVat1: TLabel
      Left = 13
      Height = 14
      Top = 94
      Width = 121
      Caption = 'Sisendkäibemaksu konto:'
      ParentColor = False
    end
    object dblComboVat_svat: TRxDBLookupCombo
      Left = 136
      Height = 21
      Top = 68
      Width = 128
      AutoSize = True
      ButtonOnlyWhenFocused = False
      ButtonWidth = 15
      Color = clWindow
      DataField = 'vat_account_id_s'
      DataSource = qryVatDs
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
          Width = 45
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
          Width = 255
        end>
      PopUpFormOptions.DropDownWidth = 355
      PopUpFormOptions.Options = [pfgColLines, pfgRowLines, pfgColumnResize]
      PopUpFormOptions.ShowTitles = True
      PopUpFormOptions.TitleButtons = True
      Flat = False
      Glyph.Data = {
        72000000424D7200000000000000360000002800000005000000030000000100
        2000000000003C00000064000000640000000000000000000000000000000000
        0000000000FF000000000000000000000000000000FF000000FF000000FF0000
        0000000000FF000000FF000000FF000000FF000000FF
      }
      NumGlyphs = 1
      OnClosePopupNotif = dblComboVat_svatClosePopupNotif
      OnKeyPress = dbEdtVatNameKeyPress
      OnSelect = dblComboVat_svatSelect
      ParentColor = False
      ReadOnly = False
      TabOrder = 2
      TabStop = True
      DropDownWidth = 355
      LookupDisplay = 'account_coding;account_name'
      LookupField = 'id'
      LookupSource = qryAccNVat
    end
    object dblComboVat_ipvat: TRxDBLookupCombo
      Left = 136
      Height = 21
      Top = 91
      Width = 128
      AutoSize = True
      ButtonOnlyWhenFocused = False
      ButtonWidth = 15
      Color = clWindow
      DataField = 'vat_account_id_i'
      DataSource = qryVatDs
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
          Width = 45
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
          Width = 255
        end>
      PopUpFormOptions.DropDownWidth = 355
      PopUpFormOptions.Options = [pfgColLines, pfgRowLines, pfgColumnResize]
      PopUpFormOptions.ShowTitles = True
      PopUpFormOptions.TitleButtons = True
      Flat = False
      Glyph.Data = {
        72000000424D7200000000000000360000002800000005000000030000000100
        2000000000003C00000064000000640000000000000000000000000000000000
        0000000000FF000000000000000000000000000000FF000000FF000000FF0000
        0000000000FF000000FF000000FF000000FF000000FF
      }
      NumGlyphs = 1
      OnClosePopupNotif = dblComboVat_svatClosePopupNotif
      OnKeyPress = dbEdtVatNameKeyPress
      OnSelect = dblComboVat_svatSelect
      ParentColor = False
      ReadOnly = False
      TabOrder = 3
      TabStop = True
      DropDownWidth = 355
      LookupDisplay = 'account_coding;account_name'
      LookupField = 'id'
      LookupSource = qryAccIVat
    end
    object ptrnVat50perc: TCheckBox
      Left = 136
      Height = 17
      Top = 136
      Width = 128
      AutoSize = False
      Caption = '50% auto KM'
      OnChange = ptrnVatChange
      OnKeyPress = dbEdtVatNameKeyPress
      TabOrder = 5
    end
  end
  object qryVatDs: TDatasource
    DataSet = qryVat
    left = 176
    top = 8
  end
  object qryVat: TZQuery
    Connection = admDatamodule.admConnection
    AfterScroll = qryVatAfterScroll
    UpdateObject = dummy
    CachedUpdates = True
    AfterInsert = qryVatAfterEdit
    AfterEdit = qryVatAfterEdit
    BeforePost = qryVatBeforePost
    Params = <>
    left = 40
    top = 8
  end
  object qryAccountsSaleVat: TZReadOnlyQuery
    Connection = admDatamodule.admConnection
    OnFilterRecord = qryAccountsSaleVatFilterRecord
    Params = <>
    left = 40
    top = 200
  end
  object qryAccNVat: TDatasource
    AutoEdit = False
    DataSet = qryAccountsSaleVat
    left = 176
    top = 72
  end
  object qryAccIVat: TDatasource
    AutoEdit = False
    DataSet = qryAccountsPurchVat
    left = 176
    top = 136
  end
  object qryWorker: TZQuery
    Connection = admDatamodule.admConnection
    Params = <>
    left = 39
    top = 72
  end
  object qryAccountsPurchVat: TZReadOnlyQuery
    Connection = admDatamodule.admConnection
    OnFilterRecord = qryAccountsSaleVatFilterRecord
    Params = <>
    left = 39
    top = 136
  end
  object dummy: TZUpdateSQL
    InsertSQL.Strings = (
      'update __int_systemtypes'
      'set bint=bint'
      'where bint=999999'
    )
    ModifySQL.Strings = (
      'update __int_systemtypes'
      'set bint=bint'
      'where bint=999999'
    )
    UseSequenceFieldForRefreshSQL = False
    left = 40
    top = 264
  end
end
