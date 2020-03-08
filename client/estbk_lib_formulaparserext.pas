unit estbk_lib_formulaparserext;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,StrUtils,estbk_types,estbk_strmsg,math,contnrs;

// ***************************************************************************
// TODO bilansi / kasumiaruannete valemite parsimine ka ühtlustada uue parseriga !
// Hetkel dubleerin loogikat ja IF loogikat ei ole bilansis ja käibemaksus
// ***************************************************************************

type
 TFormulaParserExt = class
 protected
   Faccumulator : Double;
   FRLines      : TAStrList;
   FIFParts     : TAStrList;
   FObjectRIndex: AStr;
   FFormulaLine : AStr;
   function   evaluatedVal(pIf : AStr):AStr;
   function   evaluateEq(var pFormula : AStr):Boolean; // IF
   procedure  parseMarkerContent(const pContent : AStr; const pStart : Integer; const pEnd : Integer);virtual; // kantsulguse sisu !
 public
   // akumulaator; ntx soovime rea läbi töödelda Poola kuju parseril
   property    accumulator     : Double read Faccumulator write Faccumulator;
   property    objectRIndexStr : AStr read  FObjectRIndex; // $1 või $2 jne
   // ---
   property    formula : AStr read FFormulaLine write FFormulaLine;
   property    RLines  : TAStrList read FRLines;
   property    logExpr : TAStrList read FIFParts; // IF lõigud !

    // RLines
   procedure   addValues(const pRValuesRep : TAStrList; const pWithEval : Boolean = true);
   procedure   parseLines(pFormulaLine : AStr); // skänneering; saad peada valemid ja R read, mida kasutatud
   constructor create(const pObjectRIndx : AStr);reintroduce;
   destructor  destroy;override;
 end;

// ***************************************************************************

type
  TWageFormulaParser = class(TFormulaParserExt)
  protected
   procedure  parseMarkerContent(const pContent : AStr; const pStart : Integer; const pEnd : Integer);override;
  end;


// arvutab kõikidele R ridadele väärtused !!!
// pFormulaObjects sisuliselt gridi read, millele on loodud objektid TWageFormulaParser
procedure calculateAll(const pFormulaObjects : TObjectList);
procedure replaceMarkers(const pFormulaObjects : TObjectList; const pMarkers : TAStrList);


implementation
uses estbk_lib_revpolish;


 // IF(9>4?$666:5)

function   TFormulaParserExt.evaluatedVal(pIf : AStr):AStr;
const
 CDoubleErr = 0.0001;
var
  pLogExpr : AStr;
  pPos1,i   : Integer;
  pSt1,pSt2 : Integer;

  pLNr1   : Double;
  pLNr2   : Double;
  b : Boolean;
  pIfPart1 : AStr;
  pIfPart2 : AStr;
begin

     result:='0X';
     delete(pIf,1,3);
     pIfPart1:='';
     pIfPart2:='';

 while length(pIf)>0 do
   begin

   if pIf[1]='(' then
     begin
      delete(pIf,1,1);
      continue;
     end;
     // ---
   if pIf[length(pIf)]=')' then
     begin
      delete(pIf,length(pIf),1);
      continue;
     end;

      // --
      break;
   end;

     pPos1:=pos('?',pIf);
 if (pPos1<1) then
     raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:12] '+pIf);

     pLogExpr:=trim(copy(pIf,1,pPos1-1));
 if  length(pLogExpr)<3 then
     raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:13] '+pIf);

     i:=1;
     pSt1:=0;
     pSt2:=0;
while (i<=length(pIf)) do
  begin
     case pIf[i] of
      '0'..'9','.',',':
                   begin
                   end;

      '<','>','=': begin
                   if pSt1=0 then
                      pSt1:=i;
                      pSt2:=i;
                   end;
     else
       break;
        // raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:14] '+pIf);
     end;
     // ---
     inc(i);
  end;

  if  (pSt1=0) or ((pSt2-pSt1+1)>=3) then
      raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:14] '+pIf);

 // IF(9>4?$666)
      pLNr1:=strToFloatDef(copy(pIf,1,pSt1-1),Nan);
      pLNr2:=strToFloatDef(copy(pIf,pSt2+1,pPos1-pSt2-1),Nan);

   if isNan(pLNr1) or isNan(pLNr2) then
      raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:15] '+pIf);



      // CDoubleErr
      pLogExpr:=copy(pIf,pSt1,(pSt2-pSt1)+1);
  if  pLogExpr='=' then
      b:=math.SameValue(pLNr1,pLNr2,CDoubleErr)
  else
  if  pLogExpr='<' then
      b:=pLNr1<pLNr2
  else
  if  pLogExpr='>' then
      b:=pLNr1>pLNr2
  else
  if  pLogExpr='<=' then
      b:=(pLNr1<pLNr2) or math.SameValue(pLNr1,pLNr2,CDoubleErr)
  else
  if  pLogExpr='>=' then
      b:=(pLNr1>pLNr2) or math.SameValue(pLNr1,pLNr2,CDoubleErr)
  else
      raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:15] '+pIf);

      // --
      pPos1:=pos('?',pIf);
      pLogExpr:=trim(copy(pIf,pPos1+1,255));
   if(length(pLogExpr)<3) then
      raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:16] '+pIf);



      pPos1:=pos(':',pLogExpr);
   if pPos1=0 then
      raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:17] '+pIf);

      pIfPart1:=trim(copy(pLogExpr,1,pPos1-1));
      pIfPart2:=trim(copy(pLogExpr,pPos1+1,255));

   if(pIfPart1='') or (pIfPart2='') then
       raise exception.Create(SEFormulasHasIncLogExpr+' [ERR:18] '+pIf);

 // -------------
 case b of
  true : result:=pIfPart1;
  false: result:=pIfPart2;
 end;
end;


// esmalt tuleb leida kõige sisemine IF !
function   TFormulaParserExt.evaluateEq(var pFormula : AStr):Boolean;
var
 pPos,i   : Integer;
 pLastIf  : Integer;
 pLastPos : Integer;
 pEndOfStr: Integer;
 pIfCnt   : Integer;
 pParity  : Integer;
 pIfRepPart : AStr;
begin
       pIfCnt:=0;

       pLastIf:=0;
       pLastPos:=0;
       pFormula:=ansiuppercase(pFormula);
       pPos:=PosEx('IF',pFormula,pLastPos); // IF(
       pLastIf:=pPos;
       pLastPos:=pPos+1;
       result:=pPos>0;
while (pPos>0) do
   begin
       inc(pIfCnt);
       pPos:=PosEx('IF',pFormula,pLastPos);
    if pPos>0 then
       pLastIf:=pPos;
       pLastPos:=pPos+1;
   end; // ---

  if  (pLastIf>0) then
    begin
          i:=pLastIf;
          pEndOfStr:=i;
          pParity:=0;
    while i<=length(pFormula) do
       begin

        case pFormula[i] of
         '(':  begin
                  inc(pParity);
               end;
         ')':  begin
                  dec(pParity);
               if pParity=0 then
                 begin
                  pEndOfStr:=i;
                  break;
                 end;
               end;
        end;
          // ---
          inc(i);
       end;



       pIfRepPart:=copy(pFormula,pLastIf,(pEndOfStr- pLastIf)+1);
       delete(pFormula,pLastIf,(pEndOfStr- pLastIf)+1);
       insert(evaluatedVal(pIfRepPart),pFormula,pLastIf);


    end;

        result:= result or (pIfCnt>0);
     if result then
        result:=evaluateEq(pFormula);
end;

procedure   TFormulaParserExt.AddValues(const pRValuesRep : TAStrList; const pWithEval : Boolean = true);
var
 i,pLastPos,pPos : Integer;
 pStr     : AStr;
 pMrk     : AStr;
 pDone    : Boolean;
 pFoundRLines : TAStrList;
begin

 if assigned(pRValuesRep) and (self.FFormulaLine<>'')  then
  try
         pFoundRLines:=TAStrList.Create;
         pFoundRLines.Duplicates:=dupIgnore;
     for i:=0 to pRValuesRep.Count-1 do
       begin
            //pStr:=trim(pRValuesRep.Strings[i]);
             pStr:=trim(pRValuesRep.Names[i]);
             pDone:=false;
             pLastPos:=1;
         if (pStr='') or not (pStr[1] in ['[','$']) then
             raise exception.Create(SEFormulaContainsUnkMarker);

             pPos:=posEx(pStr,self.FFormulaLine, pLastPos);
             pLastPos:=pPos+1;
       while(pPos>0) do
           begin
                // vaatame, et $1 ei asenda $11 !!
            if ((pPos+length(pStr))=length(self.FFormulaLine)) or not ( self.FFormulaLine[pPos+length(pStr)] in ['0'..'9']) then
                begin
                 pFoundRLines.Add(pStr);
                 delete(self.FFormulaLine,pPos,length(pStr));
                 insert(pRValuesRep.ValueFromIndex[i],self.FFormulaLine,pPos);
                 pLastPos:=(pPos+length(pRValuesRep.ValueFromIndex[i]))-1;
                 //pLastPos:=1;
                end;

                pPos:=posEx(pStr,self.FFormulaLine, pLastPos);
                pLastPos:=pPos+1;
           end;
       end;

  // ---
  finally
   freeAndNil(pFoundRLines);
  end;

if pWithEval then
   self.evaluateEq(self.FFormulaLine);
end;


procedure  TFormulaParserExt.parseMarkerContent(const pContent : AStr; const pStart : Integer; const pEnd : Integer);
begin
  // --
end;


procedure   TFormulaParserExt.parseLines(pFormulaLine : AStr);
const
 TFormulaOKChars  =  ['(',')','+','-','/','*',',','.','0'..'9'];
 TFormulaOKChars2 =  ['(',')','+','-','/','*',',','<','>','=','?',':','.','0'..'9']; // IF SEES

var
 pParity,pParity2,i : Integer;
 pDone : Boolean;
 pLgIf : Boolean;
 pBracketOpen : Boolean;
 pPos1,pPos2  : Integer;
 pRMPos,
 pRMPos2: Integer; // ridade arv;
 pCont : AStr;

// @ sub
procedure   __detectrlines();
begin
            pRMPos:=i;
            inc(i);
            pDone:=false;
      while((i<=length(pFormulaLine)) and not pDone) do
          begin
          if(pFormulaLine[i] in ['0'..'9']) then
             pRMPos2:=i
          else
          if pFormulaLine[i] in ['+','-','*','/','?',':','<','>','=',')'] then
            begin
             pDone:=true;
             dec(i)
            end else
             raise exception.Create(SEFormulaContainsUnkMarker+' [ERR:5]');

          if not pDone then
             inc(i);
          end;


         pCont:=ansiuppercase(copy(pFormulaLine,pRMPos+1,(pRMPos2-pRMPos)));
         FRLines.Add('$'+pCont+format('=%d:%d',[pRMPos+1,pRMPos2]));
         FRLines.Add(pCont);

      // --
      if trim(pCont)='' then
         raise exception.Create(SEFormulaContainsUnkMarker+' [ERR:6]');
         pRMPos:=0;
end;


begin
       FRLines.Clear;
       self.FIFParts.Clear;

       //FRLines.Duplicates:=dupIgnore;
       self.FFormulaLine:=pFormulaLine;
       pParity:=0;
       pParity2:=0;
       pFormulaLine:=stringreplace(pFormulaLine,#32,'',[]);

   // vaatame üle paarsuse
   for i:=1 to length(pFormulaLine) do
   case pFormulaLine[i] of
    '[' : inc(pParity);
     ']': dec(pParity);
     '(': inc(pParity2);
     ')': dec(pParity2);
   end;

  // ---
  if ((pParity<>0) or (pParity2<>0)) then
      raise exception.Create(SEFormulaIncorrect2);
      pLgIf:=false;
      pBracketOpen:=false;
      pRMPos:=0;
      pRMPos2:=0;
      i:=1;

while i<=length(pFormulaLine) do
   begin

       case pFormulaLine[i] of
        '[':  begin
              if pBracketOpen or (pRMPos>0) then
                 raise exception.Create(SEFormulaIncorrect2+' [ERR:1]');
                 pBracketOpen:=true;
                 pPos1:=i;
              end;

         ']': begin
              if not pBracketOpen or (pRMPos>0) then
                 raise exception.Create(SEFormulaIncorrect2+' [ERR:2]');

                 pPos2:=i;
                 pCont:=ansiuppercase(copy(pFormulaLine,pPos1+1,(pPos2-pPos1)-1));

                 self.parseMarkerContent(pCont,pPos1+1,(pPos2-pPos1)-1);
                 pBracketOpen:=false;
              end;

         '$': begin
                if (pBracketOpen)  then
                    raise exception.Create(SEFormulaIncorrect2+' [ERR:4]');

                    __detectrlines();
              end;

         // IF(5+88>=85?856:455)
        'I':  begin

                 if (i=length(pFormulaLine)) or (ansiuppercase(pFormulaLine[i+1])<>'F') then
                     raise exception.Create(SEFormulaIncorrect2+' [ERR:7]');
                     pParity2:=0;

                     // nüüd ootame sulgu !
                     i:=i+2; // IF ...
                     pDone:=false;
                     pPos1:=0;

              // otsime üles kus reaalselt andmed algavad; IF     ( on lubatud
              while (i<=length(pFormulaLine)) do
                  begin
                   case pFormulaLine[i] of
                      'I':  begin

                            if (i=length(pFormulaLine)) or (ansiuppercase(pFormulaLine[i+1])<>'F') then
                                raise exception.Create(SEFormulaIncorrect2+' [ERR:8]');
                                inc(i,2);
                            end;

                      '(':  begin
                            if pPos1=0 then
                               pPos1:=i;
                               // pPos1:=i; meil vaja ikka esimest positsiooni; ntx IF IF sees
                               inc(pParity2);
                            end;

                      // ----------
                      '$': __detectrlines();
                      // ----------

                      ')':  begin
                               dec(pParity2);
                            if pParity2=0 then
                             begin
                               pDone:=true;
                               pPos2:=i;
                               break;
                             end; // --
                            end else
                       if not (pFormulaLine[i] in TFormulaOKChars2) then
                          raise exception.Create(SEFormulaIncorrect2+' [ERR:9] '+pFormulaLine[i]);

                   end;
                     // --------
                     inc(i);
                  end;


                     // nii väga tore, algus leitud
                     pCont:=copy(pFormulaLine,pPos1-2,(pPos2-pPos1)+3);
                     self.FIFParts.Add(pCont);
                     //FRLines.Add(pCont+format('=%d:%d',[pPos1,pPos2]));

                     pPos1:=0;
                     pPos2:=0;
                  // --
                  if not pDone then
                     raise exception.Create(SEFormulaIncorrect2+' [ERR:10]');

              end;
       else
       // ---
       // ntx ($5<5:9) peab algama IF algusega !!!
       if  not pBracketOpen and not (pFormulaLine[i] in TFormulaOKChars) then
           raise exception.Create(SEFormulaIncorrect2+' [ERR:11] '+pFormulaLine[i]);
       end; // ---

      // --
      inc(i);
   end;
end;

constructor TFormulaParserExt.create(const pObjectRIndx : AStr);
begin
 inherited create;
 self.FObjectRIndex:=pObjectRIndx;
 FRLines:=TAStrList.create;
 FIFParts:=TAStrList.create;
end;

destructor  TFormulaParserExt.destroy;
begin
 FRLines.Free;
 FIFParts.Free;
 inherited destroy;
end;


// ***************************************************************************

procedure  TWageFormulaParser.parseMarkerContent(const pContent : AStr; const pStart : Integer; const pEnd : Integer);
begin
  // eeldefineeritud tüübid !
  if(pContent<>CMarkWhours) and (pContent<>CMarkMhours) and  (pContent<>CMarkSickDays) then
     raise exception.Create(SEFormulaIncorrect2+' [ERR:3]');
end;

// ***************************************************************************
// üritame kõik read ära arvutada ning valemid resolvida
// ***************************************************************************

procedure calculateAll(const pFormulaObjects : TObjectList);
const
  CMaxLoops = 999999;
var
  i,j : Integer;
  pDone    : Boolean;
  pWgObj   : TFormulaParserExt;
  pWgObj2  : TFormulaParserExt;
  pRevEval :   estbk_lib_revpolish.TRevPolish;
  pParsedCnt : Integer;
  pWatchdog  : Integer;
  pRObjRepl  : TAStrList;
//  pTemp : AStr;
  pFormula : AStr;
begin
  try
       pRevEval:=estbk_lib_revpolish.TRevPolish.create;
       pRObjRepl:=TAStrList.Create;

       // ---
       pDone:=false;
    if assigned(pFormulaObjects) then
    begin

      // et uuesti ei parsiks !
      for i:=0 to pFormulaObjects.Count-1 do
        begin
          pWgObj:=pFormulaObjects.Items[i] as  TFormulaParserExt;
          pWgObj.accumulator:=Nan;
        end;

            // arvutame läbi read, mida saab otse arvutada !
            pWatchdog:=0;
        while not pDone do
         begin

             pParsedCnt:=0;
         for i:=0 to pFormulaObjects.Count-1 do
           begin
               pWgObj:=pFormulaObjects.Items[i] as  TFormulaParserExt;
               pFormula:=pWgObj.formula;
               assert(pFormula<>'','#1');
               pWgObj.parseLines(pFormula);
               pWgObj.formula:=pFormula;

           if (pWgObj.RLines.Count=0) and (pWgObj.logExpr.Count=0) then
             begin

                 inc(pParsedCnt);
              if isNan(pWgObj.accumulator) then
                 begin
                   pFormula:=pWgObj.formula;
                   pRevEval.parseEquation(pFormula);
                   pWgObj.accumulator:=pRevEval.eval;
                   pWgObj.formula:=floattostr( pWgObj.accumulator);
                 end;
             end ; // ---
           end;


        for i:=0 to pFormulaObjects.Count-1 do
          begin

              pWgObj:=pFormulaObjects.Items[i] as  TFormulaParserExt;
          //if math.IsNan(pWgObj.accumulator) then
          //    Continue;

              pRObjRepl.Clear;
           if not math.IsNan(pWgObj.accumulator) then
              pRObjRepl.Add(pWgObj.objectRIndexStr+'='+floattostr(pWgObj.accumulator));

          for j:=0 to pFormulaObjects.Count-1 do
          if  i<>j then
             begin
                pWgObj2:=pFormulaObjects.Items[j] as  TFormulaParserExt;
                pWgObj2.addValues(pRObjRepl,false);
                // parsime uuesti iseennast...
                pFormula:=pWgObj2.formula;
                pWgObj2.parseLines(pFormula);

             // ok kõik markerid on asendatud ! proovime IF'idest lahti saada
             if(pWgObj2.RLines.Count=0) and (pWgObj2.logExpr.Count>0) then
               begin
                 pFormula:=pWgObj2.formula;
                 pWgObj2.evaluateEq(pFormula);
                 pWgObj2.formula:=trim(pFormula);
                 assert(pWgObj2.formula<>'','#2');
               end;
             end;

          end;

            // ---
            pDone:=pParsedCnt=pFormulaObjects.Count;
            inc(pWatchdog);
        if  pWatchdog>CMaxLoops then
            raise exception.Create(estbk_strmsg.SEDeclPossibleRecDetected);

         end;
    // ---
    end;

  finally
     freeAndNil(pRevEval);
     freeAndNil(pRObjRepl);
  end;
end;

procedure replaceMarkers(const pFormulaObjects : TObjectList; const pMarkers : TAStrList);
var
  pWgObj : TFormulaParserExt;
  pStr   : AStr;
  i,j : Integer;
begin
   for i:=0 to pFormulaObjects.Count-1 do
        begin
             pWgObj:=pFormulaObjects.Items[i] as  TFormulaParserExt;
             pStr:=pWgObj.formula;
         for j:=0 to pMarkers.Count-1 do
           begin
             pStr:=stringreplace(pStr,pMarkers.Names[j], pMarkers.ValueFromIndex[j],[rfReplaceAll]);
           end;

             pWgObj.formula:=pStr;
             //pWgObj.accumulator:=Nan;
        end;

end;

end.

