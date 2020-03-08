object pDesignerForm: TpDesignerForm
  Left = 114
  Height = 679
  Top = 6
  Width = 612
  Caption = 'Stiigo aruannete disainer'
  Constraints.MinHeight = 300
  Constraints.MinWidth = 400
  OnCreate = FormCreate
  OnShow = FormShow
  LCLVersion = '0.9.30'
  object frRepCreator: TfrReport
    InitialZoom = pzDefault
    Options = []
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    DataType = dtDataSet
    left = 24
    top = 8
    ReportForm = {
      19000000
    }
  end
end
