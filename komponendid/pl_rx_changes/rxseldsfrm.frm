object SelectDataSetForm: TSelectDataSetForm
  Left = 86
  Height = 315
  Top = 86
  Width = 400
  ActiveControl = CheckBox1
  Caption = 'Select dataset to copy to'
  ClientHeight = 315
  ClientWidth = 400
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '6.7'
  object Label1: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = CheckBox1
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 15
    Top = 31
    Width = 76
    BorderSpacing.Around = 6
    Caption = 'Sourse dataset'
    FocusControl = DataSetList
    ParentColor = False
  end
  object CheckBox1: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Owner
    Left = 6
    Height = 19
    Top = 6
    Width = 127
    BorderSpacing.Around = 6
    Caption = 'Copy only metadata'
    OnChange = CheckBox1Change
    TabOrder = 0
  end
  object DataSetList: TListBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Label1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = ButtonPanel1
    Left = 6
    Height = 217
    Top = 52
    Width = 388
    Anchors = [akTop, akLeft, akRight, akBottom]
    BorderSpacing.Around = 6
    ItemHeight = 0
    OnDblClick = ListBox1DblClick
    OnKeyPress = ListBox1KeyPress
    ScrollWidth = 386
    TabOrder = 1
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 34
    Top = 275
    Width = 388
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 2
    ShowButtons = [pbOK, pbCancel, pbHelp]
  end
end
