unit estbk_acc_perfinalize;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZDataset, ZSqlUpdate, ZSequence, estbk_types, estbk_strmsg, Math, Dialogs,
  estbk_clientdatamodule, estbk_lib_commonaccprop, estbk_sqlclientcollection, estbk_globvars;

function _generateAccFinalizatingRec(const pPCAccountId: integer; // kasumi / kahjumi konto
  const pAddPer: TDatetime;  // kuhu rp. perioodi lisame
  // mis vahemiku saldod
  const pDateStarts: TDatetime; const pDateEnds: TDatetime;
  var pAccNrs: AStr; var pExistingAccRec: integer): boolean;  // ---

implementation

procedure _addNewRec(const pAccRegId: int64; const pAccSum: currency; const pAccId: integer;
  const pRecNr: integer; const pRecType: AStr);
var
  pparamChk: boolean;
begin
  with estbk_clientdatamodule.dmodule.tempQuery2, SQL do
    try
      pparamChk := ParamCheck;
      ParamCheck := True;
      Close;
      Clear;
      add(estbk_sqlclientcollection._CSQLInsertNewAccDCRec);
      paramByname('id').AsLargeInt := estbk_clientdatamodule.dmodule.qryGenLedgerAccRecId.GetNextValue;
      paramByname('accounting_register_id').AsLargeInt := pAccRegId;
      paramByname('account_id').AsLargeInt := pAccId;
      paramByname('descr').AsString := '';
      paramByname('rec_nr').AsInteger := pRecNr;
      paramByname('rec_sum').AsCurrency := pAccSum;
      paramByname('rec_type').AsString := pRecType;
      paramByname('currency').AsString := estbk_globvars.glob_baseCurrency;
      paramByname('currency_vsum').AsCurrency := pAccSum;
      paramByname('currency_id').AsInteger := 0;
      paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
      paramByname('currency_drate_ovr').AsCurrency := 1.00;
      paramByname('status').AsString := '';
      paramByname('rec_changed').AsDateTime := now;
      paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
      paramByname('client_id').AsInteger := 0;
      execSQL;
    finally
      ParamCheck := pparamChk;
      Close;
      Clear;
    end;

end;


function _generateAccFinalizatingRec(const pPCAccountId: integer; // kasumi / kahjumi konto
  const pAddPer: TDatetime;  // kuhu rp. perioodi lisame
  // mis vahemiku saldod
  const pDateStarts: TDatetime; const pDateEnds: TDatetime;
  var pAccNrs: AStr; var pExistingAccRec: integer): boolean;
var
  pparamChk: boolean;
  precType: AStr;
  pEntryNr: AStr;
  paccPer: integer;
  pGenLdrId: int64;
  pAccDocId: int64;
  b: boolean;
  pRnd: integer;
  pRecNr: integer;
  pARecCnt: integer; // mitu tükki summaga
  pDSum: double;
  pCSum: double;
  pBal: double;
  pFinalAcc: double;
begin
  Result := False;
  pRecNr := 0;
  pAccNrs := '';
  paccPer := 0;
  pDSum := 0.00;
  pCSum := 0.00;
  b := estbk_clientdatamodule.dmodule.isValidAccountingPeriod(pAddPer, paccPer);
  if not b then
    raise Exception.Create(estbk_strmsg.SEAccDtPeriodNotFound + ' ' + DateToStr(pAddPer));

  try
    Assert(not estbk_clientdatamodule.dmodule.primConnection.InTransaction);
    estbk_clientdatamodule.dmodule.primConnection.StartTransaction; // TODO shorter begin tran
    with estbk_clientdatamodule.dmodule.tempQuery, SQL do
      try
        pparamChk := ParamCheck;
        ParamCheck := True;
        Close;
        Clear;
        // ---
        // vaatame, kas sellist kannet juba pole;
        // estbk_sqlclientcollection._SQLSelectNonXAccSum
        // kui olemasolev kirje, siis tühistame eelmised kanded !
        if pExistingAccRec <= 0 then
        begin
          add(estbk_sqlclientcollection._SQLSelectXAccItems);
          paramByname('paccperiodstart').AsDate := pDateStarts;
          paramByname('paccperiodend').AsDate := pDateEnds;
          paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
          // SQL.SaveToFile('c:\log.txt');
          Open;
          First; // ---
          if not EOF then
            while not EOF do
            begin
              if pAccNrs <> '' then
                pAccNrs := pAccNrs + ';';

              pAccNrs := pAccNrs + FieldByName('entrynumber').AsString;
              pExistingAccRec := FieldByName('id').AsInteger;
              Next;
            end;

          if pAccNrs <> '' then
          begin
            estbk_clientdatamodule.dmodule.primConnection.Rollback;
            Exit;
          end;
          // SEAccSGrpRecAlreadyExists
        end
        else
        begin
          add(estbk_sqlclientcollection._SQLCancelAccRecSQL);
          paramByname('accounting_register_id').AsInteger := pExistingAccRec;
          paramByname('rec_changed').AsDateTime := now;
          paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
          paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
          execSQL;
        end;

        // Koostame pearaamatu kirje !
        pgenLdrId := estbk_clientdatamodule.dmodule.qryGenLedgerEntrysSeq.GetNextValue;
        Randomize;
        pRnd := random(high(integer) - 1);
        pEntryNr := dmodule.getUniqNumberFromNumerator(PtrUInt(pRnd), '', pAddPer, False, estbk_types.CAccGen_rec_nr, True, True);
        dmodule.markNumeratorValAsUsed(PtrUInt(pRnd), estbk_types.CAccGen_rec_nr, pEntryNr, pAddPer, True);

        Close;
        Clear;
        add(estbk_sqlclientcollection._CSQLInsertNewAccReg);
        paramByname('id').AsLargeInt := pgenLdrId;
        paramByname('entrynumber').AsString := pEntryNr;
        paramByname('transdescr').AsString := estbk_strmsg.SCGenLedClosingRecDescr + ' ' + datetostr(pDateStarts) + ' - ' + datetostr(pDateEnds);
        paramByname('transdate').AsDateTime := pAddPer;
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        paramByname('rec_changed').AsDateTime := now;
        paramByname('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByname('type_').AsString := estbk_types.CAddRecIdendAsClosingRec;
        paramByname('accounting_period_id').AsInteger := paccPer;
        execSQL;

        // 20.07.2012 Ingmar
        Close;
        Clear;
        add(estbk_sqlclientcollection._CSQLInsertNewDoc);
        pAccDocId := estbk_clientdatamodule.dmodule.qryGetdocumentIdSeq.GetNextValue;
        parambyname('id').asLargeInt := pAccDocId;
        parambyname('document_nr').AsString := trim(pEntryNr);
        parambyname('document_date').asDate := now; // tänane kuupäev !

        parambyname('document_type_id').AsInteger := _ac.sysDocumentId[_dsAccClosingRec];
        parambyname('sdescr').AsString := estbk_strmsg.SCGenLedClosingRecDescr + ' ' + datetostr(pDateStarts) + ' - ' + datetostr(pDateEnds);

        paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByName('company_id').AsInteger := estbk_globvars.glob_company_id;
        parambyname('rec_changed').AsDateTime := now;
        execSQL;

        // 20.07.2012 Ingmar
        Close;
        Clear;
        add(estbk_sqlclientcollection._CSQLInsertNewAccRegDoc);
        parambyname('accounting_register_id').AsInteger := pgenLdrId;
        // 05.12.2009 Ingmar
        parambyname('document_id').AsLargeInt := pAccDocId;
        paramByName('rec_changedby').AsInteger := estbk_globvars.glob_worker_id;
        paramByName('rec_addedby').AsInteger := estbk_globvars.glob_worker_id;
        parambyname('rec_changed').AsDateTime := now;
        execSQL;

        Close;
        Clear;
        add(estbk_sqlclientcollection._SQLSelectNonXAccSum);
        paramByname('paccperiodstart').AsDateTime := pDateStarts;
        paramByname('paccperiodend').AsDateTime := pDateEnds;
        paramByname('company_id').AsInteger := estbk_globvars.glob_company_id;
        Open;
        //sql.SaveToFile('c:\test.txt');
        while not EOF do
        begin
        {
          Deebet müügitulu 10000
          Kreedit kaubakulu 4000
          Kreedit aruandeaasta kasum 6000
        }
          Inc(pRecNr);
          // kulukontol peaks tulema saldo kreeditisse valemiga Deebet-Kreedit
          if FieldByName('commidf').AsString = estbk_types.CAccTypeAsCost then // KULUD !
          begin
            precType := 'C';
            pBal := FieldByName('dside').AsFloat - FieldByName('cside').AsFloat;
            pCSum := pCSum + pBal;
            //pCSum:=pCSum+fieldByname('bal').AsCurrency;
          end
          else if FieldByName('commidf').AsString = estbk_types.CAccTypeAsProfit then // TULUD ! Tulukontol peaks tulema saldo deebetisse valemiga Kreedit-Deebet
          begin
            precType := 'D';
            pBal := FieldByName('cside').AsFloat - FieldByName('dside').AsFloat;
            pDSum := pDSum + pBal;
            // pDSum:=pDSum+fieldByname('bal').AsCurrency;
          end;


          if not Math.IsZero(pBal, 0.000001) then
          begin
            Inc(pARecCnt);
            _addNewRec(pgenLdrId,
              pBal, // fieldByname('bal').AsCurrency,
              FieldByName('acc_id').AsInteger,
              pRecNr,
              precType);
          end;

          Next;
        end;

      finally
        ParamCheck := pparamChk;
        Close;
        Clear;
      end;

    // 08.08.2012 Ingmar
    if pARecCnt < 1 then
      raise Exception.Create(estbk_strmsg.SENoAccRecsInPerX);

    // Aruandeaasta kasum
    pFinalAcc := pDSum - pCSum;


    precType := 'C';
    Inc(pRecNr);
    _addNewRec(pgenLdrId,
      pFinalAcc, // fieldByname('bal').AsCurrency,
      pPCAccountId,
      pRecNr,
      precType);

    estbk_clientdatamodule.dmodule.primConnection.Commit;
    // estbk_clientdatamodule.dmodule.primConnection.Rollback;
    Result := True;
  except
    on
      E: Exception do
    begin
      if estbk_clientdatamodule.dmodule.primConnection.InTransaction then
        try
          estbk_clientdatamodule.dmodule.primConnection.Rollback;
        except
        end;
      raise Exception.CreateFmt(estbk_strmsg.SESaveFailed, [e.message]);
    end;
  end;
end;

end.
