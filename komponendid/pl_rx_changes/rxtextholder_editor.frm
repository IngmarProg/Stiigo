object RxTextHolder_EditorForm: TRxTextHolder_EditorForm
  Left = 86
  Height = 592
  Top = 86
  Width = 806
  Caption = 'RxTextHolder'
  ClientHeight = 592
  ClientWidth = 806
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '6.7'
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 34
    Top = 552
    Width = 794
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 0
    ShowButtons = [pbOK, pbCancel, pbHelp]
  end
  object Panel1: TPanel
    Left = 0
    Height = 546
    Top = 0
    Width = 170
    Align = alLeft
    ClientHeight = 546
    ClientWidth = 170
    TabOrder = 1
    object ListBox1: TListBox
      AnchorSideLeft.Control = Panel1
      AnchorSideTop.Control = Panel1
      AnchorSideRight.Control = Panel1
      AnchorSideRight.Side = asrBottom
      AnchorSideBottom.Control = BitBtn1
      Left = 1
      Height = 519
      Top = 1
      Width = 168
      Anchors = [akTop, akLeft, akRight, akBottom]
      ItemHeight = 0
      OnClick = ListBox1Click
      OnSelectionChange = ListBox1SelectionChange
      PopupMenu = PopupMenu1
      ScrollWidth = 166
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      AnchorSideLeft.Control = Panel1
      AnchorSideRight.Control = CLabel1
      AnchorSideBottom.Control = Panel1
      AnchorSideBottom.Side = asrBottom
      Left = 1
      Height = 25
      Top = 520
      Width = 84
      Action = itemAdd
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = True
      TabOrder = 1
    end
    object BitBtn2: TBitBtn
      AnchorSideLeft.Control = CLabel1
      AnchorSideRight.Control = Panel1
      AnchorSideRight.Side = asrBottom
      AnchorSideBottom.Control = Panel1
      AnchorSideBottom.Side = asrBottom
      Left = 85
      Height = 25
      Top = 520
      Width = 84
      Action = itemRemove
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = True
      TabOrder = 2
    end
    object CLabel1: TLabel
      AnchorSideLeft.Control = Panel1
      AnchorSideLeft.Side = asrCenter
      AnchorSideTop.Control = Panel1
      Left = 85
      Height = 1
      Top = 1
      Width = 1
      ParentColor = False
    end
  end
  object Splitter1: TSplitter
    Left = 170
    Height = 546
    Top = 0
    Width = 5
  end
  object Panel2: TPanel
    Left = 175
    Height = 546
    Top = 0
    Width = 631
    Align = alClient
    ClientHeight = 546
    ClientWidth = 631
    TabOrder = 3
    object Edit1: TEdit
      AnchorSideLeft.Control = Label1
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = Panel2
      AnchorSideRight.Control = Panel2
      AnchorSideRight.Side = asrBottom
      Left = 49
      Height = 23
      Top = 1
      Width = 581
      Anchors = [akTop, akLeft, akRight]
      OnExit = Edit1Exit
      TabOrder = 0
    end
    object Label1: TLabel
      AnchorSideLeft.Control = Panel2
      AnchorSideBottom.Control = Edit1
      AnchorSideBottom.Side = asrBottom
      Left = 1
      Height = 15
      Top = 9
      Width = 42
      Anchors = [akLeft, akBottom]
      BorderSpacing.Right = 6
      Caption = 'Caption'
      ParentColor = False
    end
    object Memo1: TMemo
      AnchorSideLeft.Control = Panel2
      AnchorSideTop.Control = Edit1
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = Panel2
      AnchorSideRight.Side = asrBottom
      AnchorSideBottom.Control = Panel2
      AnchorSideBottom.Side = asrBottom
      Left = 1
      Height = 521
      Top = 24
      Width = 629
      Anchors = [akTop, akLeft, akRight, akBottom]
      Lines.Strings = (
        'Memo1'
      )
      OnExit = Memo1Exit
      TabOrder = 1
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 64
    Top = 336
    object MenuItem1: TMenuItem
      Action = itemAdd
    end
    object MenuItem2: TMenuItem
      Action = itemRemove
    end
  end
  object ActionList1: TActionList
    Left = 200
    Top = 336
    object itemAdd: TAction
      Caption = 'Add'
      OnExecute = itemAddExecute
    end
    object itemRemove: TAction
      Caption = 'Remove'
      OnExecute = itemRemoveExecute
    end
  end
end
