object frmEBillImport: TfrmEBillImport
  Left = 216
  Height = 359
  Top = 149
  Width = 601
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'E-arvete import'
  ClientHeight = 359
  ClientWidth = 601
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  Position = poMainFormCenter
  LCLVersion = '0.9.30'
  object pnlFileContainer: TPanel
    Left = 5
    Height = 307
    Top = 5
    Width = 589
    Anchors = [akTop, akLeft, akRight]
    BevelInner = bvLowered
    ClientHeight = 307
    ClientWidth = 589
    TabOrder = 0
    object memoImportLog: TMemo
      Left = 5
      Height = 298
      Top = 5
      Width = 580
      Anchors = [akTop, akLeft, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object btnChoosefile: TBitBtn
    Left = 496
    Height = 30
    Top = 320
    Width = 96
    Caption = 'E-arve fail'
    OnClick = btnChoosefileClick
    TabOrder = 1
  end
  object dlgOpenEBill: TOpenDialog
    Title = 'Imporditav e-arve fail'
    Filter = 'XML faili|*.xml|Kõik failid|*.*'
    left = 24
    top = 8
  end
end
