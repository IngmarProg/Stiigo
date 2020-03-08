object FrameAddrPicker: TFrameAddrPicker
  Left = 0
  Height = 72
  Top = 0
  Width = 450
  ClientHeight = 72
  ClientWidth = 450
  Constraints.MaxWidth = 750
  LCLVersion = '0.9.30'
  TabOrder = 0
  Visible = False
  DesignLeft = 479
  DesignTop = 455
  object lbCounty: TLabel
    Left = -2
    Height = 14
    Top = 5
    Width = 136
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Maakond:'
    ParentColor = False
  end
  object lbCity: TLabel
    Left = -2
    Height = 14
    Top = 27
    Width = 136
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Linn / Vald:'
    ParentColor = False
  end
  object lbStreet: TLabel
    Left = -2
    Height = 14
    Top = 50
    Width = 136
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Tänav:'
    ParentColor = False
  end
  object comboCounty: TComboBox
    Tag = 1
    Left = 142
    Height = 21
    Top = 1
    Width = 283
    Anchors = [akTop, akLeft, akRight]
    AutoComplete = True
    AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactRetainPrefixCase, cbactSearchAscending]
    AutoSize = False
    ItemHeight = 13
    OnEnter = comboCountyEnter
    OnExit = comboCountyExit
    OnKeyDown = comboCountyKeyDown
    OnKeyPress = comboCountyKeyPress
    OnSelect = comboCountySelect
    TabOrder = 0
  end
  object comboCity: TComboBox
    Tag = 2
    Left = 142
    Height = 21
    Top = 24
    Width = 283
    Anchors = [akTop, akLeft, akRight]
    AutoComplete = True
    AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactRetainPrefixCase, cbactSearchAscending]
    AutoSize = False
    ItemHeight = 13
    OnEnter = comboCountyEnter
    OnExit = comboCountyExit
    OnKeyDown = comboCityKeyDown
    OnKeyPress = comboCountyKeyPress
    OnSelect = comboCountySelect
    TabOrder = 1
  end
  object comboStreet: TComboBox
    Tag = 3
    Left = 142
    Height = 21
    Top = 47
    Width = 283
    Anchors = [akTop, akLeft, akRight]
    AutoComplete = True
    AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactRetainPrefixCase, cbactSearchAscending]
    AutoSize = False
    ItemHeight = 13
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
    left = 176
    top = 32
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
    left = 72
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
    left = 120
  end
  object qryCountySeq: TZSequence
    SequenceName = 'county_id_seq'
    left = 176
  end
  object qryCitySeq: TZSequence
    SequenceName = 'city_id_seq'
    left = 248
  end
  object qryStreetSeq: TZSequence
    SequenceName = 'street_id_seq'
    left = 320
  end
  object qryInsertCounty: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    left = 392
  end
  object qryInsertCity: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    left = 320
    top = 40
  end
  object qryInsertStreet: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    left = 248
    top = 32
  end
end
