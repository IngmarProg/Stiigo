object frameVATs: TframeVATs
  Left = 0
  Height = 549
  Top = 0
  Width = 738
  ClientHeight = 549
  ClientWidth = 738
  DesignTimePPI = 120
  ParentFont = False
  TabOrder = 0
  DesignLeft = 23
  DesignTop = 215
  object leftPanel: TPanel
    Left = 0
    Height = 549
    Top = 0
    Width = 304
    Align = alLeft
    BevelOuter = bvNone
    ClientHeight = 549
    ClientWidth = 304
    Constraints.MaxWidth = 438
    Constraints.MinWidth = 125
    TabOrder = 0
    object gridVat: TDBGrid
      Left = 4
      Height = 545
      Top = 2
      Width = 299
      Anchors = [akTop, akLeft, akRight, akBottom]
      Color = clWindow
      Columns = <      
        item
          MinSize = 12
          MaxSize = 250
          Title.Caption = 'Nimetus'
          Width = 200
          FieldName = 'description'
        end      
        item
          MinSize = 12
          MaxSize = 250
          Title.Caption = '%'
          Width = 50
          FieldName = 'perc'
        end>
      DataSource = qryVatDs
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleStyle = tsNative
    end
  end
  object Splitter1: TSplitter
    Left = 304
    Height = 549
    Top = 0
    Width = 6
  end
  object rightPanel: TPanel
    Left = 310
    Height = 549
    Top = 0
    Width = 428
    Align = alClient
    BevelOuter = bvNone
    ClientHeight = 549
    ClientWidth = 428
    TabOrder = 2
    object lblVatname: TLabel
      Left = 41
      Height = 18
      Top = 30
      Width = 126
      AutoSize = False
      Caption = 'Käibemaksu nimetus:'
      ParentColor = False
    end
    object dbEdtVatName: TDBEdit
      Left = 189
      Height = 28
      Top = 28
      Width = 230
      DataField = 'description'
      DataSource = qryVatDs
      Anchors = [akTop, akLeft, akRight]
      CharCase = ecNormal
      Constraints.MaxWidth = 356
      MaxLength = 255
      TabOrder = 0
      OnKeyPress = dbEdtVatNameKeyPress
    end
    object lblVatPerc: TLabel
      Left = 36
      Height = 20
      Top = 63
      Width = 142
      Caption = 'Käibemaksu protsent:'
      ParentColor = False
    end
    object dbEdtVatPerc: TDBEdit
      Left = 189
      Height = 28
      Top = 59
      Width = 66
      DataField = 'oprc'
      DataSource = qryVatDs
      CharCase = ecNormal
      MaxLength = 3
      TabOrder = 1
      OnKeyPress = dbEdtVatPercKeyPress
    end
    object ptrnVat: TCheckBox
      Left = 189
      Height = 21
      Top = 168
      Width = 160
      AutoSize = False
      Caption = 'Pöördkäibemaks'
      OnChange = ptrnVatChange
      OnKeyPress = dbEdtVatNameKeyPress
      TabOrder = 4
    end
    object lblSaleVat: TLabel
      Left = 20
      Height = 20
      Top = 99
      Width = 165
      Caption = 'Müügikäibemaksu konto:'
      ParentColor = False
    end
    object lblSaleVat1: TLabel
      Left = 16
      Height = 20
      Top = 134
      Width = 166
      Caption = 'Sisendkäibemaksu konto:'
      ParentColor = False
    end
    object dblComboVat_svat: TRxDBLookupCombo
      Left = 189
      Height = 32
      Top = 93
      Width = 128
      AutoSize = True
      ButtonOnlyWhenFocused = False
      ButtonWidth = 19
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
      Left = 189
      Height = 32
      Top = 130
      Width = 128
      AutoSize = True
      ButtonOnlyWhenFocused = False
      ButtonWidth = 19
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
      Left = 189
      Height = 21
      Top = 188
      Width = 160
      AutoSize = False
      Caption = '50% auto KM'
      OnChange = ptrnVatChange
      OnKeyPress = dbEdtVatNameKeyPress
      TabOrder = 5
    end
  end
  object qryVatDs: TDataSource
    DataSet = qryVat
    Left = 220
    Top = 10
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
    Left = 50
    Top = 10
  end
  object qryAccountsSaleVat: TZReadOnlyQuery
    Connection = admDatamodule.admConnection
    OnFilterRecord = qryAccountsSaleVatFilterRecord
    Params = <>
    Left = 50
    Top = 250
  end
  object qryAccNVat: TDataSource
    AutoEdit = False
    DataSet = qryAccountsSaleVat
    Left = 220
    Top = 90
  end
  object qryAccIVat: TDataSource
    AutoEdit = False
    DataSet = qryAccountsPurchVat
    Left = 220
    Top = 170
  end
  object qryWorker: TZQuery
    Connection = admDatamodule.admConnection
    Params = <>
    Left = 49
    Top = 90
  end
  object qryAccountsPurchVat: TZReadOnlyQuery
    Connection = admDatamodule.admConnection
    OnFilterRecord = qryAccountsSaleVatFilterRecord
    Params = <>
    Left = 49
    Top = 170
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
    Left = 50
    Top = 330
  end
end
