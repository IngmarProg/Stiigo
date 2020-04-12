unit estbk_lib_revpolish;
// http://en.wikipedia.org/wiki/Reverse_Polish_notation
// http://users.ece.gatech.edu/mleach/revpol/
{$mode objfpc}{$H+}
{$ASSERTIONS ON}
// 30.10.2010 Ingmar

interface

uses
  Classes, SysUtils, Contnrs, estbk_types;

type
  TTokenOp = (t_undef,
    t_number,
    t_plus,
    t_minus,
    t_unaryminus,
    t_multiply,
    t_divide,
    t_leftparenthesis,
    t_rightParenthesis,
    // hetkel veel tegemata; eeltöötlus ei tunne neid fraase
    t_sine,
    t_cosine,
    t_tangent,
    t_constant, // pii ja eksponent
    t_exponent
    );


type
  TRevPolishToken = class
    FtokenValue: AStr;
    FtokenType: TTokenOp;
  end;


type
  TRevPolish = class
  private
    FoutputList: TObjectList;
    FPolishToken: AStr;
    FlastError: AStr;
    procedure preparseItems(const pq: AStr; const pstrLst: TAStrList);
    function isOperator(const pt: TTokenOp): boolean;
    function pfxEquation(const pEq: AStr): AStr;
    function isFunction(const pt: TTokenOp): boolean;
    function crpDouble(const pValue: double): PDouble;
    function popDoubleref(const pValue: PDouble): double;

  public
    property polishTokenStr: AStr read FPolishToken write FPolishToken;
    property lastError: AStr read FlastError;

    function parseEquation(const pq: AStr): boolean;
    function eval: double;

    procedure selfTest;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses Math, estbk_utilities;

constructor TRevPolish.Create;
begin
  inherited Create;
  FoutputList := TObjectList.Create(True);
end;


// kui regexpr hakkab korralikult tööle, siis hakkame seda kasutama !
procedure TRevPolish.preparseItems(const pq: AStr; const pstrLst: TAStrList);
const
  pOperators: set of char = ['+', '-', '*', '/', '^', '~'];

var
  i: integer;
  pNrFound: boolean; // kas leidsime nr jada
  pSepFound: boolean; // koma lipp üles
  pParanCnt: integer; // sulgude loend
  pNrStr: AStr;
  pPrevChar: AChar;
begin
  //  + - * / ^ ( )

  pNrFound := False;
  pSepFound := False;
  pParanCnt := 0;
  pPrevChar := #0;
  pstrLst.Clear;
  i := 1;
  while (i <= length(pq)) do
  begin

    // - number ?
    if pq[i] in ['0'..'9'] then
    begin
      // --


      if not pNrFound then
        pNrStr := '';
      pNrStr := pNrStr + pq[i];
      pNrFound := True;
      pSepFound := False;

    end
    else
    if pq[i] in ['.', ','] then
    begin
      // ,15 varianti ei luba !
      if not pNrFound then
        raise Exception.Create('ERR:001 ' + pq);
      pNrStr := pNrStr + pq[i];
      pSepFound := True;
    end
    else
    begin

      if pSepFound then
        raise Exception.Create('ERR:002 ' + pq);

      // kirjutame numbri puhvrisse ära
      if pNrFound then
      begin
        if trim(pNrStr) = '' then
          raise Exception.Create('ERR:003 ' + pq);

        pstrLst.add(pNrStr);
        pNrFound := False;
        pNrStr := '';
      end;



      if pq[i] = '(' then
      begin
        // vahepeal peab olema operaator !
        if pPrevChar = ')' then
          raise Exception.Create('ERR:004 ' + pq);

        Inc(pParanCnt);
        pstrLst.add(pq[i]);
      end
      else
      if pq[i] = ')' then
      begin
        if pPrevChar = '(' then
          raise Exception.Create('ERR:005 ' + pq);

        Dec(pParanCnt);
        pstrLst.add(pq[i]);
      end
      else
      if pq[i] in pOperators then
      begin
        // operaatorid ei tohi kõrvuti olla
        if pPrevChar in pOperators then
          raise Exception.Create('ERR:006 ' + pq);
        pstrLst.add(pq[i]);
      end
      else
      if Ord(pq[i]) <= 32 then // lihtsalt ignoreerime
      begin
        pPrevChar := #0;
        continue;
      end
      else
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // TODO; tee siia keywordide pii,e,sin,tan,cos,minus äratundmine !
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        raise Exception.Create('ERR:007 {' + pq[i] + '} ' + pq);

      // ---
    end;


    pPrevChar := pq[i];
    Inc(i);
  end;

  if pParanCnt <> 0 then
    raise Exception.Create('ERR:008 ' + pq);

  // -- kas viimanegi nr on ära kirjutatud !
  if pNrFound then
    pstrLst.add(pNrStr);
end;

function TRevPolish.isOperator(const pt: TTokenOp): boolean;
begin
  Result := pt in [t_plus, t_minus, t_multiply, t_divide, t_unaryminus, t_exponent];
end;


function TRevPolish.isFunction(const pt: TTokenOp): boolean;
begin
  Result := pt in [t_sine, t_cosine, t_tangent];
end;

// 07.03.2011 Ingmar
function TRevPolish.pfxEquation(const pEq: AStr): AStr;

  function unaryMinusFix(const pEquation: AStr): AStr;
  begin
    Result := pEquation;
    Result := stringreplace(Result, '(-', '(~', [rfReplaceAll]);
    Result := stringreplace(Result, '(+', '(', [rfReplaceAll]);
    if length(Result) > 0 then
    begin
      if Result[1] = '+' then
        system.Delete(Result, 1, 1)
      else
      if Result[1] = '-' then
        Result[1] := '~';
    end;
  end;

var
  i: integer;
  pBuildStr: AStr;
  pRealSign: AStr;
begin
  i := 1;
  pBuildStr := '';

  while i <= length(pEq) do
  begin

    if (pEq[i] in ['+', '-']) and (pEq[i + 1] in ['+', '-']) then
      while (i <= length(pEq)) do
      begin

        // märgimaagia alles algas
        if pRealSign = '' then
          pRealSign := pEq[i]
        else
        begin
          if (pRealSign = '+') and (pEq[i] = '-') then
            pRealSign := '-'
          else
          if (pRealSign = '-') and (pEq[i] = '-') then
            pRealSign := '+'
          else
          if ((pRealSign = '-') and (pEq[i] = '+')) or ((pRealSign = '+') and (pEq[i] = '+')) then
            pRealSign := '+'
          else
            break; // märgid otsas...
        end;

        Inc(i);
      end;

    // ---
    if pRealSign <> '' then
    begin
      pBuildStr := pBuildStr + pRealSign;
      pRealSign := '';
      //dec(i);
      Continue;
    end;


    pBuildStr := pBuildStr + pEq[i];
    Inc(i);
  end;

  // --
  Result := unaryMinusFix(pBuildStr);

  // 30.05.2011 Ingmar
  // kukub kokku
  // prevpolish.parseEquation('-(-5+5+5)')
end;


function TRevPolish.parseEquation(const pq: AStr): boolean;
var
  ptoken: TAStrList;
  pstc: TStack;
  i: integer;
  ptk: TRevPolishToken;
  chkptk: TRevPolishToken;

begin
  Result := False;
  self.FlastError := '';
  self.FoutputList.Clear;

  try
    ptoken := TAStrList.Create;
    pstc := TStack.Create;



    // --
    try
      self.FPolishToken := '';
      self.preparseItems(self.pfxEquation(pq), ptoken);
      Result := trim(ptoken.Text) <> '';

      if not Result then
        exit;

      for i := 0 to ptoken.Count - 1 do
      begin
        ptk := TRevPolishToken.Create;
        ptk.FtokenType := t_number;
        ptk.FtokenValue := ptoken.Strings[i];

        if not isNan(strtofloatdef(estbk_utilities.setRFloatSep(ptoken.Strings[i]), Nan)) then
        begin
          self.FoutputList.Add(ptk);
          continue;
        end;

        //  @1
        if (ptoken.Strings[i] = '+') or (ptoken.Strings[i] = '-') then
        begin
          // tüüp ikka paika !
          if (ptoken.Strings[i] = '+') then
            ptk.FtokenType := t_plus
          else
            ptk.FtokenType := t_minus;

          if pstc.Count > 0 then
          begin
            chkptk := TRevPolishToken(pstc.Peek);
            while isOperator(chkptk.FtokenType) do
            begin
              self.FoutputList.Add(TRevPolishToken(pstc.Pop));
              if pstc.Count > 0 then
                chkptk := TRevPolishToken(pstc.Peek)
              else
                break;
            end;
          end;

          // ---
          pstc.Push(Pointer(ptk));
        end
        else
        //  @2
        if (ptoken.Strings[i] = '*') or (ptoken.Strings[i] = '/') then
        begin
          if (ptoken.Strings[i] = '*') then
            ptk.FtokenType := t_multiply
          else
            ptk.FtokenType := t_divide;

          if pstc.Count > 0 then
          begin
            chkptk := TRevPolishToken(pstc.Peek);
            while isOperator(chkptk.FtokenType) do
            begin
              if (chkptk.FtokenType = t_plus) or (chkptk.FtokenType = t_minus) then
                break
              else
              begin
                self.FoutputList.Add(TRevPolishToken(pstc.Pop));
                if pstc.Count > 0 then
                  chkptk := TRevPolishToken(pstc.Peek)
                else
                  break;
              end;
            end; // ---
          end;

          // ---
          pstc.Push(Pointer(ptk));
        end
        else
        if (ptoken.Strings[i] = '(') then
        begin
          ptk.FtokenType := t_leftparenthesis;
          pstc.Push(Pointer(ptk));
        end
        else
        if (ptoken.Strings[i] = ')') then
        begin
          ptk.FtokenType := t_rightparenthesis;
          if (pstc.Count > 0) then
          begin
            chkptk := TRevPolishToken(pstc.Peek);
            while (chkptk.FtokenType <> t_leftparenthesis) do
            begin
              self.FoutputList.Add(TRevPolishToken(pstc.Pop));
              if pstc.Count > 0 then
                chkptk := TRevPolishToken(pstc.Peek)
              else
                raise Exception.Create('ERR:008');
            end;

            // --- vasak sulg välja
            pstc.Pop;
          end;

          // ---
          if (pstc.Count > 0) then
          begin
            chkptk := TRevPolishToken(pstc.Peek);
            if (isFunction(chkptk.FtokenType)) then
              self.FoutputList.Add(TRevPolishToken(pstc.Pop));
          end;
        end
        else
        if (ptoken.Strings[i] = '^') then
        begin
          ptk.FtokenType := t_exponent;
          pstc.Push(Pointer(ptk));
        end
        else
        if (ptoken.Strings[i] = '~') then
        begin
          ptk.FtokenType := t_unaryminus;
          pstc.Push(Pointer(ptk));
        end
        else
        if (ptoken.Strings[i] = 'sin') then
        begin
          ptk.FtokenType := t_sine;
          pstc.Push(Pointer(ptk));
        end
        else
        if (ptoken.Strings[i] = 'cos') then
        begin
          ptk.FtokenType := t_cosine;
          pstc.Push(Pointer(ptk));
        end
        else
        if (ptoken.Strings[i] = 'tan') then
        begin
          ptk.FtokenType := t_tangent;
          pstc.Push(Pointer(ptk));
        end
        else
        if ((ptoken.Strings[i] = 'pi') or (ptoken.Strings[i] = 'e')) then
        begin
          ptk.FtokenType := t_constant;
          self.FoutputList.Add(ptk);
        end;
        // --- FOR
      end;

      while (pstc.Count > 0) do
      begin
        chkptk := TRevPolishToken(pstc.pop);
        if (chkptk.FtokenType = t_leftparenthesis) then
          raise Exception.Create('ERR:008')
        else
          self.FoutputList.Add(TRevPolishToken(chkptk));
      end;



      for i := 0 to self.FoutputList.Count - 1 do
      begin
        if TRevPolishToken(self.FoutputList.Items[i]).FtokenType = t_number then
          self.FPolishToken := self.FPolishToken + ' ';
        self.FPolishToken := self.FPolishToken + TRevPolishToken(self.FoutputList.Items[i]).FtokenValue;
      end;


      Result := True;
    except
      on e: Exception do
      begin
        self.FlastError := e.Message;
        Result := False;
      end;
      // ---
    end;

  finally
    FreeAndNil(ptoken);
    FreeAndNil(pstc);
  end;
end;


function TRevPolish.crpDouble(const pValue: double): PDouble;
begin
  Result := nil;
  getmem(Result, sizeof(double));
  Result^ := pValue;
end;

function TRevPolish.popDoubleref(const pValue: PDouble): double;
begin
  Result := pValue^;
  freemem(pValue, sizeof(double));
end;

function TRevPolish.eval: double;
var
  i: integer;
  rezstc: TStack;
  chkptk: TRevPolishToken;
  accum: PDouble; // akumulaator
  calc1, calc2, tempRez: double;

begin
  Result := 0;
  // unary minus on üks vastik asi !
  // -2,8 = 2,8-
  // parser muidugit lõi valemi lahku
  // 07.03.2011 Ingmar; järsku ongi vaid arv !
  if (self.FoutputList.Count = 2) then
  begin
    tempRez := strtofloatdef(estbk_utilities.setRFloatSep(TRevPolishToken(self.FoutputList.Items[1]).FtokenValue +
      TRevPolishToken(self.FoutputList.Items[0]).FtokenValue), Math.Nan);
    if not Math.IsNan(tempRez) then
    begin
      Result := tempRez;
      Exit;
    end;
  end;




  // --
  calc1 := 0;
  calc2 := 0;
  // --
  try
    rezstc := TStack.Create;

    for i := 0 to self.FoutputList.Count - 1 do
    begin
      chkptk := self.FoutputList.Items[i] as TRevPolishToken;
      case chkptk.FtokenType of
        t_number:
        begin
          rezstc.Push(crpDouble(strtofloatdef(estbk_utilities.setRFloatSep(chkptk.FtokenValue), 0)));
        end;

        t_constant:
        begin
          // teha !
          //rezstc.Push(crpDouble(resolveConstVal(chkptk.FtokenValue))); // pii
        end;

        t_plus:
        begin
          if (rezstc.Count >= 2) then
          begin
            calc2 := popDoubleref(rezstc.Pop);
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(calc1 + calc2));
          end
          else
            raise Exception.Create('ERR:009');
        end;

        t_minus:
        begin
          if (rezstc.Count >= 2) then
          begin
            calc2 := popDoubleref(rezstc.Pop);
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(calc1 - calc2));
          end
          else
            raise Exception.Create('ERR:010');
        end;

        t_multiply:
        begin
          if (rezstc.Count >= 2) then
          begin
            calc2 := popDoubleref(rezstc.Pop);
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(calc1 * calc2));
          end
          else
            raise Exception.Create('ERR:011');
        end;

        t_divide:
        begin
          if (rezstc.Count >= 2) then
          begin
            calc2 := popDoubleref(rezstc.Pop);
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(calc1 / calc2));
          end
          else
            raise Exception.Create('ERR:012');
        end;

        t_exponent:
        begin
          if (rezstc.Count >= 2) then
          begin
            calc2 := popDoubleref(rezstc.Pop);
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(power(calc1, calc2)));
          end
          else
            raise Exception.Create('ERR:013');
        end;

        t_unaryminus:
        begin
          if (rezstc.Count >= 1) then
          begin
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(-calc1));
          end
          else
            raise Exception.Create('ERR:014');
        end;

        t_sine:
        begin
          if (rezstc.Count >= 1) then
          begin
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(sin(calc1)));
          end
          else
            raise Exception.Create('ERR:015');
        end;

        t_cosine:
        begin
          if (rezstc.Count >= 1) then
          begin
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(cos(calc1)));
          end
          else
            raise Exception.Create('ERR:016');
        end;

        t_tangent:
        begin
          if (rezstc.Count >= 1) then
          begin
            calc1 := popDoubleref(rezstc.Pop);
            rezstc.Push(crpDouble(tan(calc1)));
          end
          else
            raise Exception.Create('ERR:017');
        end;
        // ----
      end;
    end;


    if rezstc.Count = 1 then
      Result := popDoubleref(rezstc.Pop)
    else
      raise Exception.Create('ERR:018');

  finally
    while rezstc.Count > 0 do
      popDoubleref(rezstc.Pop);
    FreeAndNil(rezstc);
  end;
end;


procedure TRevPolish.selfTest;
var
  pRez: double;
  pTVal: double;
begin
  self.parseEquation('((15/(7-(1+1)))*3)-(2+1+1)');
  pRez := self.eval;
  pTVal := 5.00;
  assert(double(pRez) = double(pTVal), '#1');

  self.parseEquation('(4+8)/2');
  pRez := self.eval;
  pTVal := 6.00;
  assert(double(pRez) = double(pTVal), '#2');

  self.parseEquation('2^10');
  pRez := self.eval;
  pTVal := 1024;
  assert(double(pRez) = double(pTVal), '#3');
end;

destructor TRevPolish.Destroy;
begin
  FreeAndNil(FoutputList);
  inherited Destroy;
end;

// http://webcache.googleusercontent.com/search?q=cache:3n8LIwCNFPIJ:www.wordiq.com/definition/Reverse_polish_notation+Polish+notation+example&cd=12&hl=et&ct=clnk&gl=ee
// ((1 + 2) * 4) + 3
// 1 2 + 4 * 3 +
{
Input   Stack   Operation
1   1   Push operand
2   1, 2   Push operand
+   3   Addition
4   3, 4   Push operand
*   12   Multiplication
3   12, 3   Push operand
+   15   Addition


The algorithm in detail

    * While there are tokens to be read:

        Read a token.

            * If the token is a number, then add it to the output queue.
            * If the token is an operator, o1, then:

            1) while there is an operator, o2, at the top of the stack, and either

                        o1 is left-associative and its precedence is less than or equal to that of o2, or
                        o1 is right-associative and its precedence is less than that of o2,

                pop o2 off the stack, onto the output queue;

            2) push o1 onto the operator stack.

            * If the token is a left parenthesis, then push it onto the stack.
            * If the token is a right parenthesis, then pop operators off the stack, onto the output queue, until the token at the top of the stack is a left parenthesis, at which point it is popped off the stack but not added to the output queue. If the stack runs out without finding a left parenthesis, then there are mismatched parentheses.

    * When there are no more tokens to read, pop all the tokens, if any, off the stack, add each to the output as it is popped out and exit. (These must only be operators; if a left parenthesis is popped, then there are mismatched parentheses.)

}
end.
