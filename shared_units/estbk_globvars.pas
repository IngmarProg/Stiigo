unit estbk_globvars;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils,{$IFNDEF NOGUI}XMLPropStorage, Graphics,{$ENDIF}estbk_types;

const
  Cglob_DefaultCountryCodeISO3166_1 = 'EST';  // http://en.wikipedia.org/wiki/ISO_3166-1


var
  glob_dbbackendType: TCurrentDatabaseBackEnd = __postGre; // kui ei tea, mida teed, ära muuda !!!!!


// Ingmar
// nüüd meil EUR ! 01.01.2011
var
  glob_baseCurrency: AStr = 'EUR';
  glob_baseCurrencyShortname: AStr = '€';


  glob_worker_id: integer = 1; // peale logimist kasutaja ID
  glob_company_id: integer = 1; // millise firma alt kasutaja tööd teeb

  glob_overDuePerc: double = 0.07;

  //glob_openacc_per_id : Integer = 1;
  glob_usrname: AStr = ''; // kasutaja kelle nime all logiti sisse
  glob_usrIsadmin: boolean = False;

  // FIRMA ANDMED
  glob_currcompname: AStr = ''; // firma nimi mille all tööd tehakse
  glob_currcompaddr: AStr = ''; // formateeritud; Tänav#CRLF Postiindeks / vald/ linn
  glob_currcompcontacts: AStr = ''; // firma kontaktkanalid
  glob_currcompvatnr: AStr = ''; // VAT nr
  glob_currcompregcode: AStr = ''; // firma registrikood



  glob_preDefCountryCodes: TAStrList;

  // ---
  glob_orderprepayment_wdays: integer = 10; // ntx meile tehakse ostutellimus, mitu päeva peale seda peab olema ettemaksuarve makstud
  glob_orderprepayment_mperc: byte = 50; // 50% ettemaks !


  // --
  glob_defaultDateFmt: Astr = 'dd.mm.yyyy';



  // laekumiste import !
  glob_inc_billSrcPhrases: AStr = '';
  glob_inc_orderSrcPhrases: AStr = '';


  // tasumise terminid
  glob_default_paymentterm: AStr = '';

  // active country ! ehk millise riigi reziimis töötame
  glob_activecountryCode: AStr = Cglob_DefaultCountryCodeISO3166_1;

  // palgamoodul
  glob_holidayd_peryear: integer = 28; // puhkepäevi aastas
  glob_zemployee: integer = 0; // nö null töötaja ehk template alus

  // glob_fsettings: TXMLPropStorage;
  glob_accPeriontypeNumerators: boolean = False;
  glob_minAccPeriodForStaticNumerators: integer = 0;

  glob_active_language: AStr = 'et';


implementation


// ------
initialization
  glob_preDefCountryCodes := TAStrList.Create;

finalization
  FreeAndNil(glob_preDefCountryCodes);
end.
