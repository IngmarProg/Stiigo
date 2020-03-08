object admDatamodule: TadmDatamodule
  OnCreate = DataModuleCreate
  OldCreateOrder = False
  Height = 378
  HorizontalOffset = 504
  VerticalOffset = 373
  Width = 863
  PPI = 120
  object admConnection: TZConnection
    ControlsCodePage = cCP_UTF8
    Port = 0
    Left = 230
    Top = 20
  end
  object admCompListUpSql: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = True
    MultiStatements = False
    Left = 230
    Top = 110
  end
  object admCompListSeq: TZSequence
    Connection = admConnection
    SequenceName = 'company_id_seq'
    Left = 530
    Top = 110
  end
  object admWorkerMgmSql: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = True
    MultiStatements = False
    Left = 360
    Top = 110
  end
  object admWorkerMgmSeq: TZSequence
    Connection = admConnection
    SequenceName = 'users_id_seq'
    Left = 750
    Top = 110
  end
  object admTempQuery: TZQuery
    Connection = admConnection
    AutoCalcFields = False
    CachedUpdates = True
    ReadOnly = True
    Params = <>
    Left = 370
    Top = 20
  end
  object admBufferedRolePermRelations: TZQuery
    Connection = admConnection
    AutoCalcFields = False
    Params = <>
    Left = 530
    Top = 20
  end
  object qryVatSeq: TZSequence
    Connection = admConnection
    SequenceName = 'vat_id_seq'
    Left = 640
    Top = 110
  end
  object qryFormLinesSeq: TZSequence
    Connection = admConnection
    SequenceName = 'formd_lines_id_seq'
    Left = 230
    Top = 200
  end
  object admTempQuery2: TZQuery
    Connection = admConnection
    AutoCalcFields = False
    CachedUpdates = True
    ReadOnly = True
    Params = <>
    Left = 360
    Top = 200
  end
end
