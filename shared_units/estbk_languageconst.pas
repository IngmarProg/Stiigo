unit estbk_languageconst;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

type
 TLangEntry = record
  tagId : Integer;
  trans : String;
 end;

// MAIN form control ID's
// TAG IDs from [1000 to 1100] reserved for (main app) menuitems
const
 SCMnuItem_file : TLangEntry = (tagId:1000;trans:''); // Main|Admin@File
 SCMnuItem_exit : TLangEntry = (tagId:1001;trans:''); // Main|Admin@Exit
 SCMnuItem_admin: TLangEntry = (tagId:1002;trans:''); // Main@Administer
 SCMnuItem_about: TLangEntry = (tagId:1003;trans:''); // Main@about

// TAG IDs from [1101 to 1150] reserved for (admin app) menuitems



// TAG IDs from [1151 to 1225] reserved for [child]form captions
 SCFormMain_capt  : TLangEntry = (tagId:1151;trans:'Vauing'); // Main@Vauing
 SCFormAdmin_capt : TLangEntry = (tagId:1152;trans:''); // Main@Administer



// TAG IDs from 45000>= are error messages !
 SEDatabaseNotConnected : TLangEntry = (tagId:45000;trans:'Not connected !'); // Main@Vauing



implementation
end.

