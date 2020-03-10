unit estbk_reportconst;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, estbk_clientdatamodule, estbk_types, estbk_utilities, estbk_strmsg;

const
  CGenLedgerReportFilename = 'report_genledger.lrf';
  CGenJournalReportFilename = 'report_journal_1.lrf';
  CGenTurnoverReportFilename = 'report_dturnover.lrf'; // ?!?
  CInvoiceReportFileName = 'report_invoice.lrf';
  COrderReportFilename = 'report_order.lrf';
  CFormDReportFilename = 'report_formdrez.lrf';
  CFormBalanceReportFilename = 'report_balance.lrf';
  CFormIncStatementReportFilename = 'report_incstatement.lrf';
  CGenLedgerMFReportFilename = 'report_genledger_mf.lrf';

  COverDueBillsFilename = 'report_bdept.lrf';
  CIncOrderReportFilename = 'report_ipmto.lrf'; // sissetuleku order
  COutOrderReportFilename = 'report_opmto.lrf';
  CCashRegisterReportFilename = 'report_cashbook.lrf';

  CBillListReportFilename = 'report_bill_list.lrf';


// pearaamat !
const
  CGenLed_accnr = 1;
  CGenLed_accdate = 2;
  CGenLed_accdocnr = 4;
  CGenLed_accdescr = 8;
  CGenLed_accdebt = 16;
  CGenLed_acccred = 32;
  CGenLed_accshowcurr = 64;
  CGenLed_accobj = 128;



type
  TGenLedReportMode = (
    CRep_generalledger, // pearaamat
    CRep_journal,       // päevaraamat
    CRep_turnover       // käibeandmik
    );


type
  TReportOutput = (CRep_Screen,
    CRep_Excel);



procedure fillReportDtPer(const pstr: TAStrings; const pSkipPeriod: TdtPeriodSet = []); // kuvab vahemiku !

implementation

procedure fillReportDtPer(const pstr: TAStrings; const pSkipPeriod: TdtPeriodSet = []);
var
  i: estbk_types.TdtPeriod;
begin

  if assigned(pstr) then
  begin
    pstr.Clear;

    for i := low(estbk_types.TdtPeriod) to high(estbk_types.TdtPeriod) do
      if not (i in pSkipPeriod) then
        case i of
          cdt_undefined: pstr.AddObject('', TObject(cardinal(i)));
          cdt_today: pstr.AddObject(estbk_strmsg.CSDtToday, TObject(cardinal(i)));
          cdt_currweek: pstr.AddObject(estbk_strmsg.CSCurrWeek, TObject(cardinal(i)));
          cdt_prevweek: pstr.AddObject(estbk_strmsg.CSPrevWeek, TObject(cardinal(i)));
          cdt_currmonth: pstr.AddObject(estbk_strmsg.CSCurrMonth, TObject(cardinal(i)));
          cdt_prevmonth: pstr.AddObject(estbk_strmsg.CSPrevMonth, TObject(cardinal(i)));
          cdt_ovrprevmonth: pstr.AddObject(estbk_strmsg.CSOvrPrevMonth, TObject(cardinal(i)));
          cdt_currentYear: pstr.AddObject(estbk_strmsg.CSCurrentYear, TObject(cardinal(i)));

          cdt_prevYear: pstr.AddObject(estbk_strmsg.CSPrevYear, TObject(cardinal(i)));
          cdt_ovrprevYear: pstr.AddObject(estbk_strmsg.CSOvrPrevYear, TObject(cardinal(i)));

        end;
  end;
end;
// -----
end.
