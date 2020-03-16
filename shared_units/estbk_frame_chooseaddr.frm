object FrameAddrPicker: TFrameAddrPicker
  Left = 0
  Height = 90
  Top = 0
  Width = 562
  ClientHeight = 90
  ClientWidth = 562
  Constraints.MaxWidth = 938
  DesignTimePPI = 120
  ParentFont = False
  TabOrder = 0
  Visible = False
  DesignLeft = 452
  DesignTop = 200
  object lbCounty: TLabel
    Left = -2
    Height = 18
    Top = 6
    Width = 170
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Maakond:'
    ParentColor = False
  end
  object lbCity: TLabel
    Left = -2
    Height = 18
    Top = 34
    Width = 170
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Linn / Vald:'
    ParentColor = False
  end
  object lbStreet: TLabel
    Left = -2
    Height = 18
    Top = 62
    Width = 170
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Tänav:'
    ParentColor = False
  end
  object comboCounty: TComboBox
    Tag = 1
    Left = 178
    Height = 28
    Top = 1
    Width = 353
    Anchors = [akTop, akLeft, akRight]
    AutoComplete = True
    AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactRetainPrefixCase, cbactSearchAscending]
    AutoSize = False
    ItemHeight = 20
    OnEnter = comboCountyEnter
    OnExit = comboCountyExit
    OnKeyDown = comboCountyKeyDown
    OnKeyPress = comboCountyKeyPress
    OnSelect = comboCountySelect
    TabOrder = 0
  end
  object comboCity: TComboBox
    Tag = 2
    Left = 178
    Height = 28
    Top = 30
    Width = 353
    Anchors = [akTop, akLeft, akRight]
    AutoComplete = True
    AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactRetainPrefixCase, cbactSearchAscending]
    AutoSize = False
    ItemHeight = 20
    OnEnter = comboCountyEnter
    OnExit = comboCountyExit
    OnKeyDown = comboCityKeyDown
    OnKeyPress = comboCountyKeyPress
    OnSelect = comboCountySelect
    TabOrder = 1
  end
  object comboStreet: TComboBox
    Tag = 3
    Left = 178
    Height = 28
    Top = 59
    Width = 353
    Anchors = [akTop, akLeft, akRight]
    AutoComplete = True
    AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactRetainPrefixCase, cbactSearchAscending]
    AutoSize = False
    ItemHeight = 20
    OnEnter = comboCountyEnter
    OnExit = comboCountyExit
    OnKeyDown = comboCityKeyDown
    OnKeyPress = comboCountyKeyPress
    OnSelect = comboCountySelect
    TabOrder = 2
  end
  object qryCounty: TZQuery
    AutoCalcFields = False
    UpdateObject = qryInsertCounty
    CachedUpdates = True
    BeforePost = qryCountyBeforePost
    ParamCheck = False
    Params = <>
    Sequence = qryCountySeq
    SequenceField = 'id'
    Left = 220
    Top = 40
  end
  object qryCity: TZQuery
    AutoCalcFields = False
    UpdateObject = qryInsertCity
    CachedUpdates = True
    BeforePost = qryCountyBeforePost
    ParamCheck = False
    Params = <>
    Sequence = qryCitySeq
    SequenceField = 'id'
    Left = 90
  end
  object qryStreet: TZQuery
    AutoCalcFields = False
    UpdateObject = qryInsertStreet
    CachedUpdates = True
    BeforePost = qryCountyBeforePost
    ParamCheck = False
    Params = <>
    Sequence = qryStreetSeq
    SequenceField = 'id'
    Left = 150
  end
  object qryCountySeq: TZSequence
    SequenceName = 'county_id_seq'
    Left = 220
  end
  object qryCitySeq: TZSequence
    SequenceName = 'city_id_seq'
    Left = 310
  end
  object qryStreetSeq: TZSequence
    SequenceName = 'street_id_seq'
    Left = 400
  end
  object qryInsertCounty: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    Left = 490
  end
  object qryInsertCity: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    Left = 400
    Top = 50
  end
  object qryInsertStreet: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    Left = 310
    Top = 40
  end
end
