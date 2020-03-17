{$M+}
unit UTools;
// 05.05.2014 Ingmar
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,TypInfo,estbk_types,fpjson,jsonparser;

procedure SetClassFieldProp(const pObj : TObject; const pFieldname : AStr; const pValue : Variant);
function ClassFieldNamesAsSQL(const pObj : TObject) : AStr;
function ClassToJSON(const pObj : TObjArray):String; overload;
function ClassToJSON(const pObj : TObject;
                     const pAddResultInfo : Boolean = true;
                     const pRemoveEndMarkers : Boolean = true):String;overload;

implementation
uses Variants;

procedure SetClassFieldProp(const pObj : TObject; const pFieldname : AStr; const pValue : Variant);
var
  PropInfos: PPropList;
  PropInfo: PPropInfo;
  i, Count : Integer;
  pName : AStr;
  pvType: Integer;
begin
  Count := GetPropList(pObj.ClassInfo, tkAny, nil);
  GetMem(PropInfos, Count * SizeOf(PPropInfo));
  try
        GetPropList(pObj.ClassInfo, tkAny, PropInfos);
    for i := 0 to Count - 1 do
      begin
               pName := PropInfos^[i]^.Name;
            if Ansilowercase(pName) <> Ansilowercase(pFieldname) then
               Continue;

               PropInfo := GetPropInfo(pObj.ClassInfo, pName);
               pvType := VarType(pValue) and VarTypeMask;
          case pvType of

             varEmpty,
             varNull :
               begin
               end;

             varSmallInt,
             varInteger,
             varByte,
             varWord,
             varLongWord :
               begin
                  SetOrdProp(pObj, PropInfo, Integer(pValue));
               end;

             varSingle,
             varDouble,
             varCurrency :
               begin
                  SetFloatProp(pObj, PropInfo, Double(pValue));
               end;

             varDate:
               begin
                   SetFloatProp(pObj, PropInfo, Double(VarToDateTime(pValue)));
               end;

             varOleStr,
             varString:
               begin
                  SetStrProp(pObj, PropInfo, VarToStr(pValue));
               end;
          end;
      end;

  finally
    FreeMem(PropInfos, Count * SizeOf(PPropInfo));
  end;
end;

function ClassFieldNamesAsSQL(const pObj : TObject) : AStr;
var
  PropInfos: PPropList;
  PropInfo: PPropInfo;
  i, Count : Integer;
begin
   Count := GetPropList(pObj.ClassInfo, tkAny, nil);
   GetMem(PropInfos, Count * SizeOf(PPropInfo));
   try
        GetPropList(pObj.ClassInfo, tkAny, PropInfos);
     for i := 0 to Count - 1 do
       begin
       if Result <> '' then
          Result := Result + ',';
          Result := Result + PropInfos^[i]^.Name;
       end;
   finally
     FreeMem(PropInfos, Count * SizeOf(PPropInfo));
   end;
end;

function ClassToJSON(const pObj : TObjArray):String;
var i : Integer;
begin
  Result := '';
  if assigned(pObj) then
  for i := low(pObj) to high(pObj)  do
  begin
  if Result <> '' then
     Result := Result + ',';
     Result := Result + '{'+ClassToJSON(pObj[i], false)+'}';
  end;
  Result := '{"result":['+ Result + ']}';
end;

// http://www.blong.com/Conferences/BorConUK98/DelphiRTTI/CB140.htm
function ClassToJSON(const pObj : TObject;
                     const pAddResultInfo : Boolean = true;
                     const pRemoveEndMarkers : Boolean = true):String;
var
  PropInfos: PPropList;
  PropInfo: PPropInfo;
  OrdVal: Longint;
  Propname : String;
  StrVal: String;
  FloatVal: Extended;
  MethodVal: TMethod;
  Count, i: Integer;
  ja : TJSONArray;
  jo: TJSONObject;
begin
  Result := '';
  ja := TJSONArray.Create;

  // @@
  //Find out how many properties we'll be considering
  Count := GetPropList(pObj.ClassInfo, tkAny, nil);
  // Allocate memory to hold their RTTI data
  GetMem(PropInfos, Count * SizeOf(PPropInfo));
  try
    // Get hold of the property list in our new buffer
    GetPropList(pObj.ClassInfo, tkAny, PropInfos);


    // Loop through all the selected properties
    for i := 0 to Count - 1 do
    begin
        Propname := PropInfos^[i]^.Name;
        PropInfo := GetPropInfo(pObj.ClassInfo, PropName);
      // Check the general type of the property and read/write it in an appropriate way
      case PropInfos^[i]^.PropType^.Kind of
        tkInteger, tkChar, tkEnumeration,
        tkSet, tkClass{$ifdef Win32}, tkWChar{$endif}:
        begin
          OrdVal := GetOrdProp(pObj, PropInfos^[i]);
          {
          O:=TJSONObject.Create(['Age',44,
                         'Firstname','Michael',
                         'Lastname','Van Canneyt']);}
          jo := TJSONObject.Create;
          jo.Add(Propname, OrdVal);
          ja.Add(jo);

          {
          if Assigned(PropInfo) then
             SetOrdProp(ObjTo, PropInfo, OrdVal);
          }
        end;
        tkFloat:
        begin
          FloatVal := GetFloatProp(pObj, PropInfos^[i]);
          jo := TJSONObject.Create;
          jo.Add(Propname, FloatVal);
          ja.Add(jo);
          {
          if Assigned(PropInfo) then
            SetFloatProp(ObjTo, PropInfo, FloatVal);
          }
        end;

        tkSString,tkLString,tkAString,tkWString,tkUString:
        begin

          //if UpperCase(PropInfos^[Loop]^.Name) = 'NAME' then
          //   Continue;
             StrVal := GetStrProp(pObj, PropInfos^[i]);
             jo := TJSONObject.Create;
             jo.Add(Propname, StrVal);
             ja.Add(jo);

          {
          if Assigned(PropInfo) then
             SetStrProp(ObjTo, PropInfo, StrVal);
          }
        end;
        tkMethod:
        begin
          {
          MethodVal := GetMethodProp(ObjFrom, PropInfos^[Loop]);
          if Assigned(PropInfo) then
             SetMethodProp(ObjTo, PropInfo, MethodVal);
          }
        end
      end
    end

  finally
    FreeMem(PropInfos, Count * SizeOf(PPropInfo));
  end;


  // Result := ja.ToString;
  if pAddResultInfo then
  try
    jo := TJSONObject.Create;
    jo.Add('result', ja);
    Result := jo.AsJSON;
  finally
    jo.Free;
  end else
  begin
      Result := ja.AsJSON;


   // @@@ võtame alguse ja lõpu markerid ära, sest me enamasti kasutame seda mergemisel
   // mitmene objektide array

  if pRemoveEndMarkers then
    begin
      if (Result<>'') and (Result[1]='[') then
          system.Delete(Result,1,1);

      if (Result<>'') and (Result[length(Result)]=']') then
          system.Delete(Result,length(Result),1);

          Result := StringReplace(Result,'{','',[rfReplaceAll]);
          Result := StringReplace(Result,'}','',[rfReplaceAll]);

    end;
      // @@@
      ja.Free;
  end;
end;

end.

