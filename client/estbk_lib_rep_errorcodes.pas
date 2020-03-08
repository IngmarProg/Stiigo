unit estbk_lib_rep_errorcodes;

{$mode objfpc}

interface

uses
  Classes, SysUtils,estbk_strmsg,estbk_types;

type
 TLogEntryType = (_logImportBankIncFiles);
 TRepDescrStruct = record
   SRepCode     : Astr;
   SRepLongDesc : Astr;
 end;

 TLogEntrysRange = 0..20;

// ----------------------------------------------------------------------------
// laekumisfailide ridade töötlemisel tekkinud vead
// ----------------------------------------------------------------------------
const
  CID_IncomeFilesOp = 'INC';

const
  SEE_UnknownError  = 'UNKN';

// LAEKUMISED !
const
  SEC_IncDataLineIsTooShort  = 'Q001';
  SEC_IncReqDataIsMissing    = 'Q002';
  SEC_IncInvDataFormat       = 'Q003';
  SEC_IncRcvAccountUnknown   = 'Q004';
  SEC_IncAccPerNotFound      = 'Q005';
  SEC_IncRefNrNotFound       = 'Q006';
  SEC_IncCustNotFound        = 'Q007';
  SEC_IncBillNotFound        = 'Q008';
  SEC_IncOrderNotFound       = 'Q009';
  SEC_IncUnknownPmt          = 'Q010'; // st selgituse järgi ei suudetud dekoreerida, mis maksega tegemist !
  SEC_IncCantDetermbkAccount = 'Q011';
  SEC_IncAlreadyExists       = 'Q012';
  // 17.01.2011 Ingmar; veel täiendavaid koode !
  SEC_IncSrcBankAccNotFound  = 'Q013';  // pangaga seotud rp. konto valimata, mitte segi ajada otseselt füüsilise kontoga
  SEC_IncSrcAccIncNrNotFound = 'Q014';
  SEC_IncDateIsEmpty         = 'Q015';
  SEC_IncSrcAccountNrEmpty   = 'Q016'; // konto nr, mille peale tasumine tuli
  SEC_IncCurrencyUnkn        = 'Q017';
  SEC_IncMissingObjects      = 'Q018';
  SEC_IncObjectAccIdUnkn     = 'Q019';
  SEC_IncSumIszero           = 'Q020';






const
 CrepResolveCodes : Array[TLogEntryType,TLogEntrysRange] Of TRepDescrStruct =
 (
   // -----------------------------------------------------------------------
   // -- laekumiste sisestamine
   // -----------------------------------------------------------------------
   ( // -->
    (
      SRepCode    :SEC_IncdataLineIsTooShort;
      SRepLongDesc:SEIncfdataLineIsTooShort;
     ),

    (
      SRepCode    :SEC_IncreqDataIsMissing;
      SRepLongDesc:SEIncfreqDataIsMissing;
    ),

    (
      SRepCode    :SEC_IncinvDataFormat;
      SRepLongDesc:SEIncfinvDataFormat;
     ),

     (
      SRepCode    :SEC_IncaccPerNotFound;
      SRepLongDesc:SEIncfAccPerNotFound;
     ),

     (
      SRepCode    :SEC_IncrefNrNotFound;
      SRepLongDesc:SEIncfrefNrNotFound;
     ),

     (
      SRepCode    :SEC_InccustNotFound;
      SRepLongDesc:SEIncfcustNotFound;
     ),

     (
      SRepCode    :SEC_IncbillNotFound;
      SRepLongDesc:SEIncfbillNotFound;
     ),

     (
      SRepCode    :SEC_IncorderNotFound;
      SRepLongDesc:SEIncforderNotFound;
     ),

    (
      SRepCode    :SEC_IncunknownPmt;
      SRepLongDesc:SEIncfunknown;
     ),
     (
      SRepCode    :SEC_IncrcvAccountUnknown;
      SRepLongDesc:SEIncfRcvAccountUnknown;
     ),
     (
      SRepCode    :SEC_InccantDetermbkAccount;
      SRepLongDesc:SEIncfBkAccountNotFound;
     ),
     (
      SRepCode    :SEC_IncAlreadyExists;
      SRepLongDesc:SEIncfAlreadyExists;
     ),
     (
      SRepCode    :SEC_IncSrcBankAccNotFound;
      SRepLongDesc:SEIncfSrcBankAccNotFound;
     ),
     (
      SRepCode    :SEC_IncSrcAccIncNrNotFound;
      SRepLongDesc:SEIncfSrcAccNrNotFound;
     ),
     (
      SRepCode    :SEC_IncDateIsEmpty;
      SRepLongDesc:SEIncfDateIsEmpty;
     ),
     (
      SRepCode    :SEC_IncSrcAccountNrEmpty;
      SRepLongDesc:SEIncfSrcAccNrNotFound;
     ),
     (
      SRepCode    :SEC_IncCurrencyUnkn;
      SRepLongDesc:SEIncfCurrencyIsUnkn;
     ),
     (
      SRepCode    :SEC_IncMissingObjects;
      SRepLongDesc:SEIncfMissingObjects;
     ),
     (
      SRepCode    :SEC_IncObjectAccIdUnkn;
      SRepLongDesc:SEIncfObjectAccIdUnkn;
     ),
     (
      SRepCode    :SEC_IncSumIszero;
      SRepLongDesc:SEIncfSumIsZero;
     ),()
   ) // <--
   // -----------------------------------------------------------------------
  );


function fndReportCodeLongDescr(const pReportcode : Astr):Astr; // annab veakoodi pika kirjelduse
function fndBuildECodeRsvCaseSQL(const pOperationType :TLogEntryType):AStr; // koostab case, mis nö tõlgib lahti SQL's kõik raporti koodid


implementation
uses estbk_lib_mapdatatypes;

function fndReportCodeLongDescr(const pReportcode : Astr):Astr;
var
  i : TLogEntryType;
  j : Integer;
begin
  Result:='';
  if pReportcode <> '' then
  for  i := Low(TLogEntryType) to High(TLogEntryType) do
    for j := Low(TLogEntrysRange) to High(TLogEntrysRange) do
    if CrepResolveCodes[i,j].SRepCode = pReportcode then
    begin
        Result := CrepResolveCodes[i,j].SRepLongDesc;
        Break;
    end;
end;

function fndBuildECodeRsvCaseSQL(const pOperationType :TLogEntryType):AStr; // koostab case, mis nö tõlgib lahti SQL's kõik raporti koodid
var
  j : Integer;
begin
     result:='CAST((CASE ';
 for j:=low(TLogEntrysRange) to high(TLogEntrysRange) do
 with CrepResolveCodes[pOperationType,j] do
 if SRepCode<>'' then
   begin
     result:=result+format(' WHEN code=''%s'' THEN ''%s'' ',[SRepCode,SRepLongDesc]);
   end;
     // ---
     result:=result+' ELSE '''' END) AS '+estbk_lib_mapdatatypes.TEstbk_MapDataTypes.__MapVarcharType(255)+') as logldescr ';
end;

end.

