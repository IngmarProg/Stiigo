unit estbk_permissions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,estbk_strmsg;
// 30.08.2009 ingmar
// ehk system alias; lühend, mis võimaldab meil paremini õigustega mängida, kui lihtsalt mingi fixed numbriga

type
  TPermIdentType = (
                    __perm_canCreateAccounts=0,
                    __perm_canChangeNumerators,
                    __perm_canCrChObjects,
                    __perm_canUseGenLedger,
                    __perm_canChangeAddArticles,
                    __perm_canConfSaleBills,
                    __perm_canConfPurchBills,
                    __perm_canCreateCreditBills,
                    __perm_canConfIncomings,
                    __perm_canConfPayments,
                    __perm_canConfCashRegPayments,
                    __perm_canCreatePurchOrders
                   );

const
  TPermDescrShortTerms : Array[TPermIdentType] of String =
                  (
                    'ACD',   //Z1: Tohib luua kontosid
                    'ACN',   //Z2: Tohib muuta nummerdamise reegleid
                    'AOO',   //Z3: Tohib lisada objekte
                    'AGL',   //Z4: Tohib sisestada kandeid pearaamatus
                    'AII',   //Z5: Tohib lisada / muuta artikleid
                    'ACA',   //Z6: Tohib kinnitada müügiarveid
                    'ACP',   //Z7: Tohib kinnitada ostuarveid
                    'ACC',   //Z8: Tohib koostada kreeditarvet
                    'ACI',   //Z9: Tohib kinnitada laekumisi
                    'ACK',   //Z10:Tohib kinnitada tasumisi
                    'ACR',   //Z11:Tohib kinnitada kassa tehinguid
                    'APO'    //Z12:Tohib koostada ostutellimust
                  );


// seda massiivi kasutatakse ainult admin puhul;
const
  TPermDescrLongTerms : Array[TPermIdentType] of String =
                  (
                   SPermnameZ1,
                   SPermnameZ2,
                   SPermnameZ3,
                   SPermnameZ4,
                   SPermnameZ5,
                   SPermnameZ6,
                   SPermnameZ7,
                   SPermnameZ8,
                   SPermnameZ9,
                   SPermnameZ10,
                   SPermnameZ11,
                   SPermnameZ12
                  );
implementation

end.

