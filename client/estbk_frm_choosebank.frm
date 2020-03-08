inherited formChooseBank: TformChooseBank
  Left = 258
  Height = 150
  Top = 350
  Width = 432
  BorderStyle = bsDialog
  Caption = 'Laekumiste fail'
  ClientHeight = 150
  ClientWidth = 432
  Color = clWhite
  OnCreate = FormCreate
  Position = poDesktopCenter
  object grp: TGroupBox[0]
    Left = 6
    Height = 100
    Top = 4
    Width = 420
    Anchors = [akTop, akLeft, akRight]
    ClientHeight = 82
    ClientWidth = 416
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object edtlFilename: TLabeledEdit
      Left = 90
      Height = 21
      Top = 24
      Width = 286
      AutoSize = False
      EditLabel.AnchorSideLeft.Control = edtlFilename
      EditLabel.AnchorSideTop.Control = edtlFilename
      EditLabel.AnchorSideTop.Side = asrCenter
      EditLabel.AnchorSideRight.Control = edtlFilename
      EditLabel.AnchorSideBottom.Control = edtlFilename
      EditLabel.Left = 64
      EditLabel.Height = 14
      EditLabel.Top = 27
      EditLabel.Width = 23
      EditLabel.Caption = 'Fail:'
      EditLabel.ParentColor = False
      LabelPosition = lpLeft
      TabOrder = 1
      OnChange = edtlFilenameChange
      OnExit = edtlFilenameExit
      OnKeyDown = edtlFilenameKeyDown
    end
    object lblBank: TLabel
      Left = 8
      Height = 14
      Top = 4
      Width = 80
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pank:'
      ParentColor = False
    end
    object cmbBankList: TComboBox
      Left = 90
      Height = 21
      Top = 1
      Width = 310
      ItemHeight = 13
      OnChange = cmbBankListChange
      Style = csDropDownList
      TabOrder = 0
    end
    object openFile: TSpeedButton
      Left = 376
      Height = 22
      Top = 24
      Width = 23
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000FF0000
        00FF00000000000000FF000000FF388EDAFF388EDAFF388EDAFF388EDAFF388E
        DAFF388EDAFF388EDAFF388EDAFF388EDAFFE1EDF8FFFFFFFF00FFFFFF00FFFF
        FF00000000FFD5F1FAFF92E1F6FF95E2F7FF8EE0F6FF88DEF4FF82DCF4FF7BD9
        F3FF75D8F3FF5DCFF0FFACEBF7FF388EDAFFCCE1F1FFFDFCFB00FFFFFF00FFFF
        FF00000000FFDFF6FCFF8DE4F7FF91E5F8FF88E2F7FF7DE0F7FF72E0F8FF66DC
        F7FF5ADBF8FF31CFF5FF9AF1FFFF388EDAFFD0F0FFFFFFFFFF00FFFFFF00FFFF
        FF00000000FFDDF5FBFF7DDFF5FF87E0F6FF81DFF7FF8BDEF0FF8CDBEAFF86D6
        E7FF80D3E3FF62C7DAFFADDEDFFF388EDAFFCC895BFFEBC7B1FFFFFFFF00FFFF
        FF00000000FFF7FDFEFFDAF9FDFFDEFBFEFFDEFAFEFF9DE2F1FF89D9EBFF8FD9
        E7FF91D6E4FF84CEDDFFC4E4E0FF388EDAFFB9AFAEFFD07C4AFFFFFFFF00FFFF
        FF00000000FFDEF0F8FF8BC4EAFF7AB9E6FF9ACBECFFE3F0F3FFEDFEFDFFEEFD
        FFFFEFFEFFFFE8FAFEFFFEFFFFFF388EDAFFC5E6F5FFD88B5EFFFFFFFF00FFFF
        FF00000000FFD6F0F9FF77D1EFFF6BC4EBFF388EDAFF388EDAFF388EDAFF388E
        DAFF388EDAFF388EDAFF388EDAFF388EDAFFD4E4EBFFD48959FFFFFFFF00FFFF
        FF00000000FFF3FDFFFFA3EAFAFFB4E6F4FFBCF0FFFFCC895BFFEEDED2FFF3E8
        DEFFF2E3D7FFF3E2D6FFF3E0D3FFF8DDC8FFFFF5ECFFCC895BFFFFFFFF00FFFF
        FF00000000FFCBEBF4FFD1ECF6FFCFEBF3FFCDEDF8FFCC895BFFFEEDDEFFFFEA
        D9FFFEE7D4FFFEE5D0FFFCE4CCFFFADDC1FFFEF1E4FFCD8A5CFF000000FF0000
        00FF00000000000000FF000000FF388EDAFF388EDAFFCC895BFFFDEDDFFFFCE8
        D8FFFCE4D1FFFAE1CCFFF8DCC2FFF4D1AEFFFAEBDAFFCE8D5FFFFFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC895BFFF8EADDFFFDE7
        D5FFFAE2CEFFF9DDC5FFF5DCC4FFF4E0CCFFFBF7F2FFCB8656FFFFFFFF00FFFF
        FF00FAFDFE00FAFDFE00FAFDFE00F9FBFB00FAFDFE00CC895BFFF9E8D9FFFCE0
        C9FFFADFC6FFF6D2B3FFF7E5D3FFFDF5EBFFF4D8B8FFCC895BFFFFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FEFDFC00FFFFFF00CC895BFFF9F1E6FFFDF1
        E6FFFBEEE2FFF9E8D8FFFAF3E9FFF2D3AEFFCC895BFFF6EDE9EEFFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FEFDFC00FFFFFF00CC895BFFCC895BFFCC89
        5BFFCC895BFFCC895BFFCC895BFFCC895BFFF4E5DEFFFFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      }
      NumGlyphs = 0
      OnClick = openFileClick
    end
    object chkboxAutoChk: TCheckBox
      Left = 90
      Height = 17
      Top = 51
      Width = 212
      Caption = 'Märgi korrektsed read kinnitatuks'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object btnCancel: TBitBtn[1]
    Left = 351
    Height = 30
    Top = 112
    Width = 75
    Caption = 'Cancel'
    Kind = bkCancel
    ModalResult = 2
    TabOrder = 1
  end
  object btnOk: TBitBtn[2]
    Left = 274
    Height = 30
    Top = 112
    Width = 75
    Caption = '&OK'
    Default = True
    Enabled = False
    Kind = bkOK
    ModalResult = 1
    TabOrder = 0
  end
  object oFiles: TOpenDialog[3]
    Title = 'Avan faili'
    left = 32
    top = 8
  end
  object qryBanks: TZReadOnlyQuery[4]
    OnFilterRecord = qryBanksFilterRecord
    Params = <>
    left = 36
    top = 65
  end
end
