inherited formEMailBill: TformEMailBill
  Left = 302
  Height = 555
  Top = 219
  Width = 485
  BorderStyle = bsDialog
  Caption = 'Arve e-postiga'
  ClientHeight = 555
  ClientWidth = 485
  object GroupBox1: TGroupBox[0]
    Left = 8
    Height = 507
    Top = 0
    Width = 470
    Anchors = [akTop, akLeft, akRight, akBottom]
    ClientHeight = 489
    ClientWidth = 466
    TabOrder = 0
    object lblEMailrcv: TLabeledEdit
      Left = 135
      Height = 21
      Top = 0
      Width = 328
      EditLabel.AnchorSideLeft.Control = lblEMailrcv
      EditLabel.AnchorSideTop.Control = lblEMailrcv
      EditLabel.AnchorSideTop.Side = asrCenter
      EditLabel.AnchorSideRight.Control = lblEMailrcv
      EditLabel.AnchorSideBottom.Control = lblEMailrcv
      EditLabel.Left = 23
      EditLabel.Height = 14
      EditLabel.Top = 3
      EditLabel.Width = 109
      EditLabel.Caption = 'Arve saata aadressile:'
      EditLabel.ParentColor = False
      LabelPosition = lpLeft
      TabOrder = 0
      OnKeyPress = lblEMailrcvKeyPress
    end
    object lblEMailSubject: TLabeledEdit
      Left = 135
      Height = 21
      Top = 24
      Width = 328
      EditLabel.AnchorSideLeft.Control = lblEMailSubject
      EditLabel.AnchorSideTop.Control = lblEMailSubject
      EditLabel.AnchorSideTop.Side = asrCenter
      EditLabel.AnchorSideRight.Control = lblEMailSubject
      EditLabel.AnchorSideBottom.Control = lblEMailSubject
      EditLabel.Left = 91
      EditLabel.Height = 14
      EditLabel.Top = 27
      EditLabel.Width = 41
      EditLabel.Caption = 'Subjekt:'
      EditLabel.ParentColor = False
      LabelPosition = lpLeft
      TabOrder = 1
      OnKeyPress = lblEMailrcvKeyPress
    end
    object Bevel1: TBevel
      Left = 3
      Height = 2
      Top = 56
      Width = 111
      Shape = bsTopLine
    end
    object lblExtDescr: TLabel
      Left = 135
      Height = 14
      Top = 49
      Width = 58
      Caption = 'E - kirja sisu'
      ParentColor = False
      ParentFont = False
    end
    object Bevel2: TBevel
      Left = 207
      Height = 7
      Top = 56
      Width = 256
      Shape = bsTopLine
    end
    object memoExtrDescr: TMemo
      Left = 3
      Height = 402
      Top = 62
      Width = 460
      Anchors = [akTop, akLeft, akBottom]
      TabOrder = 2
    end
    object cbEBill: TCheckBox
      Left = 3
      Height = 17
      Top = 469
      Width = 164
      Caption = 'Lisa manusesse ka e - arve fail'
      TabOrder = 3
    end
  end
  object btnSend: TBitBtn[1]
    Left = 322
    Height = 30
    Top = 516
    Width = 75
    Anchors = [akRight, akBottom]
    Caption = '&Saada'
    Default = True
    Kind = bkOK
    OnClick = btnSendClick
    TabOrder = 1
  end
  object btnCancel: TBitBtn[2]
    Left = 403
    Height = 30
    Top = 516
    Width = 75
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Katkesta'
    Kind = bkCancel
    ModalResult = 2
    TabOrder = 2
  end
end
