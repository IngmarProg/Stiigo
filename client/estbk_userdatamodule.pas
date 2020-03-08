{
      Copyright © 2009 Ingmar Tammeväli
      http://www.stiigo.com

      This program is free software; you can redistribute it and/or modify it under the terms of
      the GNU General Public License as published by the Free Software Foundation; either version 2
      of the License, or (at your option) any later version.

      This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
      without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      See the GNU General Public License for more details. http://www.gnu.org/copyleft/gpl.html
}
{$i ./../estbk_defs.inc}

unit estbk_userdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Dialogs,
  ZConnection, ZCompatibility, ZSequence, ZDataset, ZSqlMetadata,
  estbk_utilities,estbk_types,estbk_struct;

type

  { Tuserdm }
  Tuserdm = class(TDataModule)
    user_connection: TZConnection;
    user_helperconnection: TZConnection;
    confQuery: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
   FuserIsDbAdmin : Boolean; // database admin !
   FdatabaseVer   : String;
   function  getConnectionStatus:Boolean;
   procedure setConnectionStatus(const v : Boolean);
  public
    property  connected : boolean read getConnectionStatus write setConnectionStatus;
    property  databaseVer   : String  read FdatabaseVer;
    property  userIsDbAdmin : Boolean read FuserIsDbAdmin;
    // -------------
    procedure initDefaultConnParams(const server   : AStr;
                                    const username : AStr;
                                    const password : AStr;
                                    const port : Integer = 0);
     procedure validateUserTables;
  end;


var
  userdm: Tuserdm;

implementation
uses estbk_dbcompability,estbk_languageconst,estbk_tables;






initialization
  {$I estbk_userdatamodule.ctrs}

end.

