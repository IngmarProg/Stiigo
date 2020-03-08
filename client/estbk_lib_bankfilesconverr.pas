unit estbk_lib_bankfilesconverr;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils,estbk_types,estbk_lib_rep_errorcodes {raporti veakoodid üle kõikide klasside};





// töötlemisel tekkinud standardsed veakoodid
const
  CErrIncCodeBaseStart   = 16;
  // ---
  CErrIncRecvBankAccountNotFound = 17;
  CErrIncValidAccPeriodNotFound  = 18;
  CErrIncRefNrNotFound           = 19;
  CErrIncCustNotFound            = 20;
  CErrIncBillWNrNotFound         = 21;
  CErrIncOrderWNrNotFound        = 22;
  CErrIncCantResPayment          = 23;
  CErrIncCantDetermAccount       = 24;
  CErrIncAlreadyExists           = 25;

  // käsitsi redigeerimisel eelkontrollis tekkinud vead
  CErrIncBankAccNotFound    = 26;  // pangaga seotud raamatupidamislik konto valimata
  CErrIncAccNrNotFound      = 27;  // rp. kirjendi number tühi; see on olemas st nõutav vaid kinnitatud kirjel !
  CErrIncDateIsEmpty        = 28;  // laekumise kuupäev on tühi
  CErrIncSrcAccountNrEmpty  = 29;  // ehk meil vaja ikka teada ka maksja konto nr; aruannetes see alati olemas
  CErrIncCurrencyIsUnkn     = 30;  // laekumise valuuta tühi või tundmatu valuuta !
  CErrIncMissingObjects     = 31;  // reserveeritud; mingi arve või tellimus peab olema, mida tasutakse või vähemalt summa suurem >0s
  CErrIncObjectAccIdUnkn    = 32;  // reserveeritud; arve ja tellimuse küljes peab ka olema rp. konto
  CErrIncSumIszero          = 33;  // laekumise summa 0
  // ---
  CErrRangeLastItem = CErrIncSumIszero+1;  // -- peab olema viimane

// teisendame loetavateks aruande koodideks !
const
  CIncErrTranslate : Array[CErrIncCodeBaseStart + 1..CErrRangeLastItem - 1] of AStr = (estbk_lib_rep_errorcodes.SEC_IncrcvAccountUnknown,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncAccPerNotFound,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncRefNrNotFound,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncCustNotFound, // Q007
                                                                                       estbk_lib_rep_errorcodes.SEC_IncBillNotFound,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncOrderNotFound,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncUnknownPmt,
                                                                                       estbk_lib_rep_errorcodes.SEC_InccantDetermbkAccount,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncAlreadyExists,
                                                                                       // 17.01.2011 Ingmar
                                                                                       estbk_lib_rep_errorcodes.SEC_IncSrcBankAccNotFound,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncSrcAccIncNrNotFound,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncDateIsEmpty,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncSrcAccountNrEmpty,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncCurrencyUnkn,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncMissingObjects, // arveid / tellimusi mõeldakse selle all
                                                                                       estbk_lib_rep_errorcodes.SEC_IncObjectAccIdUnkn,
                                                                                       estbk_lib_rep_errorcodes.SEC_IncSumIsZero   // Q020
                                                                                );

implementation

end.

