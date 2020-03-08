unit estbk_frm_numerators;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, Buttons, estbk_utilities, estbk_datamodule, estbk_globvars,
  estbk_sqlcollection, estbk_types, estbk_lib_commonevents, estbk_strmsg,
  ZDataset;

// @@@@
type
   TNumTypes = record
     pNumeratorId : Integer;
     pNumeratorIdf: AStr;
     pNumeratorVal: Integer;
     pNumeratorFormat : AStr;
     pRowNr       : Integer;
   end;


type
   TNumTypesArr = array of TNumTypes;

type

  { TformNumerators }

  TformNumerators = class(TForm)
    btnClose: TBitBtn;
    btnSave: TBitBtn;
    gridNumeratorTypes: TStringGrid;
    grpboxNumerators: TGroupBox;
    qryNumerators: TZQuery;
    procedure btnSaveClick(Sender: TObject);
    procedure gridNumeratorTypesEditingDone(Sender: TObject);
    procedure gridNumeratorTypesKeyPress(Sender: TObject; var Key: char);
  private
    FNumArr      : TNumTypesArr;
    FAccPeriodId : Integer;
    FCompanyId   : Integer;
    FOnlyDefaultNumExists : Boolean;
    function  isConfigurable(const pNumeratorIdf : AStr; var pResolveLongName : AStr):Boolean;
    procedure loadNumerators;
  public
//    gridNumeratorTypesKeyPress
    constructor create(const pOwner : TComponent);reintroduce;
    class procedure showAndCreate(const pCompanyId   : Integer;
                                  const pAccPeriodID : Integer);
  end;

var
  formNumerators: TformNumerators;

implementation
const
   CCol_numname   = 0;
   CCol_numval    = 1;
   CCol_numprefix = 2;
   CCol_leadingZ  = 3;

const
   CConcatMarker  = '&';

constructor TformNumerators.create(const pOwner : TComponent);
begin
  inherited create(pOwner);
 (gridNumeratorTypes.EditorByStyle(cbsAuto) as TStringCellEditor).OnKeyPress:=@self.gridNumeratorTypesKeyPress;
end;

procedure   TformNumerators.btnSaveClick(Sender: TObject);
var
   i,ptempInt,pZCount : Integer;
   pNumFmt    : AStr;
begin
if dialogs.MessageDlg(estbk_strmsg.SConfNumChanges,mtConfirmation,[mbYes,mbNo],0)=mrNo then
  begin
  if gridNumeratorTypes.CanFocus then
     gridNumeratorTypes.SetFocus;
     Exit;
  end;




 try
   admDatamodule.admConnection.StartTransaction;
   // --
       with qryNumerators,SQL do
       try
            close;
            clear;
         if self.FOnlyDefaultNumExists then
            add(estbk_sqlcollection._SQLInsertNumerators2)
         else
            add(estbk_sqlcollection._SQLUpdateNumerators);

      {
        _SQLInsertNumerators = ' INSERT INTO numerators(cr_num_val, cr_num_start, cr_num_type, '+
                             'cr_vrange_start, cr_vrange_end, cr_version, company_id) '+
                             'VALUES (:cr_num_val,:cr_num_start,:cr_num_type,:cr_vrange_start,'+
                             ':cr_vrange_end,:cr_version,:company_id)';}

        for  i:=low(FNumArr) to high(FNumArr) do
          begin

          if FNumArr[i].pRowNr>=0 then
           begin
              ptempInt:=strtointdef(gridNumeratorTypes.Cells[CCol_numval,FNumArr[i].pRowNr],0);
              paramByname('cr_num_val').asInteger:=ptempInt;
           end else
          if  self.FOnlyDefaultNumExists then
              paramByname('cr_num_val').asInteger:=FNumArr[i].pNumeratorVal
          else
              paramByname('cr_num_val').asInteger:=0;

              paramByname('cr_num_start').asInteger:=1;
              paramByname('cr_num_type').asString:=FNumArr[i].pNumeratorIdf;
           // ---
           // paneme siis formaadi-stringi paika !
           if FNumArr[i].pRowNr>=0 then
             begin
                 // kasutaja formateering !
                 pZCount:=strtointdef(gridNumeratorTypes.Cells[CCol_leadingZ,FNumArr[i].pRowNr],-1);
             if (pZCount<0) or (pZCount>9) then
                 pZCount:=0;

                 // --
                 pNumFmt:=copy(gridNumeratorTypes.Cells[CCol_numprefix,FNumArr[i].pRowNr],1,10)+CConcatMarker+inttostr(pZCount);
                 paramByname('cr_srbfr').asString:=trim(pNumFmt);
             end else
              paramByname('cr_srbfr').asString:=trim(FNumArr[i].pNumeratorFormat+CConcatMarker+'0');

              // ---
              paramByname('cr_vrange_start').asInteger:=0;
              paramByname('cr_vrange_end').asInteger:=0;
              paramByname('cr_version').asInteger:=0;

           // -- siis vaid uuendamise teema; sest uue maj. aasta puhul luuakse ka numeraatorid; juhul kui see firmal valitud
           if not self.FOnlyDefaultNumExists then
              paramByname('id').asInteger:=FNumArr[i].pNumeratorId
           else
           // järelikult genereerime rp. aasta põhise default 0 numeraatori järgi
            begin
              paramByname('company_id').asInteger:=self.FCompanyId;
              paramByname('accounting_period_id').asInteger:=self.FAccPeriodId;
            end;

              // --
              execSQL;
          end;

         // 15.04.2012 Ingmar; peame ka numerators cache tühjaks kustutama !
         close;
         clear;
         add(estbk_sqlcollection._SQLFlushNumeratorCache);
         paramByname('company_id').asInteger:=self.FCompanyId;
         execSQL;


         // --
       finally
          close;
          clear;
       end;

  // ---
  btnSave.Enabled:=false;

  // --
  admDatamodule.admConnection.Commit;

 except on e : exception do
  begin
  if  admDatamodule.admConnection.InTransaction then
  try admDatamodule.admConnection.Rollback; except end;
      dialogs.messageDlg(format(estbk_strmsg.SESaveFailed,[e.message]),mtError,[mbok],0);
  end;
 end;
end;

procedure TformNumerators.gridNumeratorTypesEditingDone(Sender: TObject);
begin
 //  btnSave.Enabled:=true;
end;

procedure TformNumerators.gridNumeratorTypesKeyPress(Sender: TObject;
  var Key: char);
var
   bfrVal : String;
begin
  if  key>#32 then
      btnSave.Enabled:=true;
  // ---
  if   key in ['%','&'] then // väldime kasutaja leidlikkust !
       key:=#0
  else
  if  (gridNumeratorTypes.Col in [CCol_numval,CCol_leadingZ]) then
    begin
       bfrVal:=trim(gridNumeratorTypes.Cells[gridNumeratorTypes.Col,gridNumeratorTypes.Row]);
    if length(bfrVal)>10 then
       key:=#0
    else
      estbk_utilities.edit_verifyNumericEntry( gridNumeratorTypes.Editor as TCustomEdit,key);
    end; //  --
end;

function  TformNumerators.isConfigurable(const pNumeratorIdf : AStr; var pResolveLongName : AStr):Boolean;
const
   CPIsConfigurable : TCNumeratorTypesSet =
                      [  CAccGen_rec_nr,    // pearaamaatu kandeseeriad
                         CAccInc_rec_nr,    // laekumiste lausendite kande number
                         CAccSBill_rec_nr,  // ABLNR => müügiarve lausendite seerianumbrer
                         CAccPBill_rec_nr,  // ostuarve lausendite seerianumber
                         CAccCBill_rec_nr,  // kreeditarve lausendite seerianumber
                         CAccRBill_rec_nr,  // ettemaksuarve lausendi seerianumber; reaalselt pole see "arve"
                         CAccDBill_rec_nr,  // viivisarved ka eraldi seeriatesse
                         CAccPmt_rec_nr,    // tasumise kandeseeria nr
                         CAccCri_rec_nr,    // kassa laekumise kandeseeria nr => sissetulekuorder
                         CAccCro_rec_nr,    // kassa laekumise kandeseeria nr => väljaminekuorder
                         // DOKUMENTIDE NUMBRISEERIAD; KA TOOTED !
                         CBill_doc_nr,      // - müügiarve number
                         CCBill_doc_nr,     // - kreeditarve number;
                         CDBill_doc_nr,     // - viivisarve number

                         CPOrder_doc_nr,    // - ostutellimuse number
                         CSOrder_doc_nr,    // - müügitellimuse number
                         COffer_doc_nr,     // - pakkumise number
                         CPMOrder_doc_nr,   // - (payment order)maksekorralduse nr
                         CCSRegister_doc_recnr  // -  kassa dokumendi seeria nr
                      ];
var
   i : TCNumeratorTypes;
begin
      result:=false;
      pResolveLongName:='';
  for i:=low(TCNumeratorTypes) to high(TCNumeratorTypes) do
   if TNumeratorTypesSDescr[i]=pNumeratorIdf then
     begin
        result:=(i in CPIsConfigurable);
     if result then
       begin
          pResolveLongName:=trim(TNumeratorTypesLongName[i]);
       if pResolveLongName='' then
          raise exception.Create(pNumeratorIdf);
       end; // --
        break;
     end;
end;

procedure TformNumerators.loadNumerators;
var
 i,prownr : Integer;
 pResTypename : AStr;
 pFmtLine     : AStr;
 pMarkerPos   : Integer;
 b : Boolean;
begin


 gridNumeratorTypes.Columns.Items[CCol_numname].Color:=estbk_types.MyFavLightYellow;
 gridNumeratorTypes.Columns.Items[CCol_numname].ReadOnly:=true;
 gridNumeratorTypes.Columns.Items[CCol_numval].ReadOnly:=false;
 gridNumeratorTypes.Columns.Items[CCol_numprefix].ReadOnly:=false;
 gridNumeratorTypes.Columns.Items[CCol_leadingZ].ReadOnly:=false;




 // ---
 with qryNumerators,SQL do
  try
      // 15.04.2012 Ingmar; lukustame, kui vähemalt üks kanne, et prefikseid ei saaks muuta !
      close;
      clear;
      add(estbk_sqlcollection._SQLIsNumUsed);
      paramByname('accounting_period_id').AsInteger:=self.FAccPeriodId;
      open;
      b:=fieldByname('accr_id').AsInteger>0;
      gridNumeratorTypes.Columns.Items[CCol_numprefix].ReadOnly:=b;
   if b then
      gridNumeratorTypes.Columns.Items[CCol_numprefix].Color:=estbk_types.MyFavGray;


      gridNumeratorTypes.RowCount:=1;
      close;
      clear;
      add(estbk_sqlcollection._SQLSelectAccPeriodById);
      paramByname('id').AsInteger:=self.FAccPeriodId;
      open;
   if not eof then
      self.caption:=self.caption+' ('+fieldByname('name').AsString+')';


      // ---
      close;
      clear;
      add(estbk_sqlcollection._SQLSelectAccPeriodNumerators(true));
      paramByname('company_id').AsInteger:=self.FCompanyId;
      paramByname('accounting_period_id').AsInteger:=self.FAccPeriodId;
      open;
      self.FOnlyDefaultNumExists:=(recordcount<1);


   // küsime siis hetke numeraatorite info
   if self.FOnlyDefaultNumExists then
     begin
       close;
       // proovime saada jooksvad numeraatorid ilma rp. perioodita !
       paramByname('accounting_period_id').AsInteger:=0;
       open;
       assert(recordcount>0,'#1');
     end;

      setlength(self.FNumArr,recordcount);
      i:=low(self.FNumArr);

      // ---
      first;

    while not eof do
     begin

         // ---
         prownr:=-1;
     if self.isConfigurable(fieldByname('cr_num_type').AsString,presTypename) then
       begin

         gridNumeratorTypes.RowCount:=gridNumeratorTypes.RowCount+1;
         prownr:=gridNumeratorTypes.RowCount-1;
         gridNumeratorTypes.Cells[CCol_numname,prownr]:='  '+presTypename;
         gridNumeratorTypes.Cells[CCol_numval,prownr]:=fieldByname('cr_num_val').asString;


         pFmtLine:=trim(fieldByname('cr_srbfr').asString);
         pMarkerPos:=pos(CConcatMarker,pFmtLine);
         gridNumeratorTypes.Cells[CCol_numprefix,prownr]:=copy(pFmtLine,1,pMarkerPos-1);
         gridNumeratorTypes.Cells[CCol_leadingZ,prownr]:=inttostr(strtointdef(copy(pFmtLine,pMarkerPos+1,255),0));

       end;


         // ---
         FNumArr[i].pNumeratorId:=fieldByname('id').AsInteger;
         FNumArr[i].pNumeratorIdf:=fieldByname('cr_num_type').AsString;
         FNumArr[i].pNumeratorVal:=fieldByname('cr_num_val').AsInteger;
         FNumArr[i].pNumeratorFormat:=fieldByname('cr_srbfr').asString;
         FNumArr[i].pRowNr:=prownr;

         // ---
         inc(i);

         next;
     end;

   finally
      close;
      clear;
   end;

    // -- !
    btnSave.Enabled:=false;
end;

class procedure TformNumerators.showAndCreate(const pCompanyId   : Integer;
                                              const pAccPeriodID : Integer);
begin
  with TformNumerators.Create(nil) do
   try
       FAccPeriodId:=pAccPeriodID;
       FCompanyId:=pCompanyId;
       loadNumerators;
       // ---
       showmodal;
   finally
       free;
   end;
end;

initialization
  {$I estbk_frm_numerators.ctrs}

end.

