object userdm: Tuserdm
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 300
  HorizontalOffset = 290
  VerticalOffset = 186
  Width = 400
  object user_connection: TZConnection
    Protocol = 'postgresql-8'
    HostName = 'localhost'
    TransactIsolationLevel = tiReadCommitted
    left = 16
    top = 16
  end
  object user_helperconnection: TZConnection
    Protocol = 'postgresql-8'
    HostName = 'localhost'
    TransactIsolationLevel = tiReadCommitted
    left = 48
    top = 16
  end
  object confQuery: TZQuery
    Connection = user_connection
    Params = <>
    left = 160
    top = 16
  end
end
