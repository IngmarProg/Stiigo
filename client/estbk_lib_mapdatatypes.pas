unit estbk_lib_mapdatatypes;

{$mode objfpc}

interface

uses
  Classes, SysUtils, estbk_globvars, estbk_types;

type
  TEstbk_MapDataTypes = class
  public
    //backend: TBackendtype; static;
    class function __DefaultDate(): AStr;
    class function __MapDateTimeVariable(): AStr;
    class function __MapDateVariable(): AStr;
    class function __MapModBoolean(): AStr;
    class function __MapLongText(): AStr;
    class function __MapBlobField(): AStr;
    class function __MapModDateTime(): AStr;
    class function __MapCharType(const fieldLen: integer): AStr;
    class function __MapIntType(): AStr;
    class function __MapSmallIntType(): AStr;
    class function __MapBigIntType(): AStr;
    class function __MapVarcharType(const fieldLen: integer): AStr;
    class function __MapMoneyType(): AStr;
    class function __MapPercType(): AStr;
  end;


implementation

// http://www.postgresql.org/docs/7.4/interactive/datatype.html
class function TEstbk_MapDataTypes.__DefaultDate(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' current_date ';
  end;
end;

class function TEstbk_MapDataTypes.__MapDateTimeVariable(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' timestamp ';  // with time zone
  end;
end;

class function TEstbk_MapDataTypes.__MapDateVariable(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' date ';
  end;
end;

class function TEstbk_MapDataTypes.__MapModBoolean(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' boolean ';
  end;
end;

class function TEstbk_MapDataTypes.__MapLongText(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' text ';
  end;
end;

class function TEstbk_MapDataTypes.__MapBlobField(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' text ';
  end;
end;

class function TEstbk_MapDataTypes.__MapModDateTime(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' timestamp WITH time zone DEFAULT now() ';
  end;
end;


class function TEstbk_MapDataTypes.__MapCharType(const fieldLen: integer): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := format(' char(%d) ', [fieldLen]);
  end;
end;

class function TEstbk_MapDataTypes.__MapIntType(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' integer ';
  end;
end;

class function TEstbk_MapDataTypes.__MapSmallIntType(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' smallint ';
  end;
end;



class function TEstbk_MapDataTypes.__MapBigIntType(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' bigint ';
  end;
end;


class function TEstbk_MapDataTypes.__MapVarcharType(const fieldLen: integer): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := format(' varchar(%d) ', [fieldLen]);
  end;
end;

// 09.09.2009 Ingmar; kurivaim; postgre money type tõi kaasa niipalju probleeme,
// et kõige mõttekam kasutada numeric formaati !!!!!!!!!!!!!!!!!!!!!!
class function TEstbk_MapDataTypes.__MapMoneyType(): AStr;
begin
  // 19.08.2009 Ingmar
  // kui MYSQL tuleb, siis saan hallid juuksekarvad ehk siis võtta decimal(10,2)
  // Oracle puhul, siis numeric (19,4)
  // Postgres kasutame normaalset formaati
  case estbk_globvars.glob_dbbackendType of
    //__postGre : result:=' money ';
    __postGre: Result := ' numeric(19,4) ';
  end;
end;

// Teen omale lihtustuse % muutjate pealt
class function TEstbk_MapDataTypes.__MapPercType(): AStr;
begin
  case estbk_globvars.glob_dbbackendType of
    __postGre: Result := ' numeric(5,2) ';
  end;
end;

end.
