unit estbk_lib_commonevents;

{$mode objfpc}{$H+}
{$i estbk_defs.inc}

interface

uses
  Classes, SysUtils,ZDataset,db,estbk_types,estbk_lib_commoncls;


// kuna framade süsteem on täielikult eventdriven !
// EVENTS
type
 TQryEvent =   TDatasetNotifyEvent; //procedure(DataSet: TDataSet) of object;

type
 TStrCallback = procedure(var pRepfilename :AStr) of object;

type
 TKeyNotEvent = procedure(Sender: TObject; var Key: Word; Shift: TShiftState) of object;

type
 TTaskBarNotEvent =  procedure(Sender: TObject; stext : AStr) of object;


// ntx vanemat teavitatakse, et klient valiti; jne jne viimased parameetrid sõltuvad framest
type
 TFrameChooseCustomer = procedure(Sender: TObject; customerData : TClientData) of object;

type
 TFrameReqEvent = procedure(Sender: TObject;
                            evSender : TFrameEventSender;
                            itemId   : Int64; // Integer -> int 64 01.03.2011 Ingmar
                            miscData : Pointer = nil) of object;


// kui mingi frame tahab vanemalt teada uusi kursse, siis vanem haldab neid !!!
type
 TRequestForCurrUpdate = procedure(Sender: TObject; currDt : TDatetime) of object;

implementation

end.

