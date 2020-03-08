object formBackupRestore: TformBackupRestore
  Left = 228
  Height = 433
  Top = 211
  Width = 643
  BorderStyle = bsDialog
  Caption = 'Varukoopia'
  ClientHeight = 433
  ClientWidth = 643
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '0.9.30'
  object GroupBox1: TGroupBox
    Left = 11
    Height = 384
    Top = 8
    Width = 616
    Anchors = [akTop, akLeft, akRight, akBottom]
    ClientHeight = 366
    ClientWidth = 612
    TabOrder = 0
    object Label1: TLabel
      Left = 3
      Height = 18
      Top = 8
      Width = 134
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Koopia asukoht:'
      ParentColor = False
    end
    object edtFilepath: TEdit
      Left = 147
      Height = 21
      Top = 5
      Width = 427
      TabOrder = 0
    end
    object btnBackupLocation: TSpeedButton
      Left = 576
      Height = 22
      Top = 4
      Width = 23
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF002C86
        D8702D88D8A62D87D8EA2D88D8F72D88D8F72D88D8F72D88D8F72D88D8F72D88
        D8F72D88D8F72D88D8F72D87D8F72D88D8F12C86D893FFFFFF00FFFFFF00338E
        D9E6DCF0FAF0A7DDF4FD9EDBF4FF96DAF3FF8ED8F3FF86D7F3FF7FD4F2FF79D3
        F2FF72D2F1FF6CD0F1FF69CFF1FFC2EAF8FE338ED9F0FFFFFF00FFFFFF003594
        DAF7EFFAFEFFA1E9F9FF91E5F8FF81E1F7FF72DEF6FF63DAF5FF54D7F4FF47D3
        F3FF39D0F2FF2ECDF1FF26CBF0FFCAF2FBFF3594DAF7FFFFFF00FFFFFF00369A
        DAF8F2FAFDFFB3EDFAFFA4E9F9FF95E6F8FF85E2F7FF76DEF6FF65DBF5FF57D7
        F4FF49D4F3FF3BD1F2FF30CEF1FFCCF2FBFF3598DAF7FFFFFF00FFFFFF0036A1
        DAF9F6FCFEFFC8F2FCFFB9EFFBFFACECFAFF9CE8F9FF8BE3F7FF7CE0F6FF6CDC
        F6FF5DD9F5FF4FD6F4FF44D3F3FFD0F3FCFF359FDAF7FFFFFF00FFFFFF0037A6
        DAFAFEFFFFFFF8FDFFFFF6FDFFFFF5FCFFFFF3FCFEFFD8F6FCFF94E6F8FF85E3
        F7FF76DFF6FF68DBF5FF5CD8F4FFD7F4FCFF35A4DAF7FFFFFF00FFFFFF0035AB
        DAFAE8F6FBFF94D4EFFF88CEEEFF73C1E9FFC9E9F6FFF2FCFEFFF3FCFEFFF2FC
        FEFFF0FCFEFFEFFBFEFFEEFBFEFFFEFFFFFF36ABDAF7FFFFFF00FFFFFF0036AA
        DAF2F1FAFDFF94DEF5FF93DCF4FF81D5F2FF6ACAEDFF6CCBEAFF85D3EFFF80D2
        EFFF7AD0EFFF76CFEEFF72CFEEFFE9F7FBFF34AEDAF3FFFFFF00FFFFFF0035AF
        DAF0F7FCFEFF8EE4F8FF91DEF5FF9FE0F5FFACE1F6FFEFFBFEFFF4FDFEFFF3FC
        FEFFF1FCFEFFEFFBFEFFEEFBFEFFFAFDFFF936AFDAD4FFFFFF00FFFFFF0036B3
        DAF8FDFEFEFFFEFFFFFFFEFEFFFFFDFEFFFFFEFFFFFFEAF7FBFF6BC7E4F96BC7
        E3F86BC7E3F86BC7E3F879CDE6F774CAE5E132B1D956FFFFFF00FFFFFF0034B4
        D9D05EC2E1FA60C3E2FA60C3E2FA60C3E2FA5FC3E2FA3CB6DBDD2CB2D8162CB2
        D80F2CB2D80F2CB2D80F2CB2D80F2CB3D80F2CB3D804FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      }
      NumGlyphs = 0
      OnClick = btnBackupLocationClick
    end
    object Bevel1: TBevel
      Left = 11
      Height = 18
      Top = 82
      Width = 120
      Shape = bsTopLine
    end
    object lblLog: TLabel
      Left = 147
      Height = 18
      Top = 76
      Width = 56
      AutoSize = False
      Caption = 'Logi'
      ParentColor = False
    end
    object Bevel2: TBevel
      Left = 219
      Height = 18
      Top = 82
      Width = 384
      Shape = bsTopLine
    end
    object memlog: TMemo
      Left = 11
      Height = 250
      Top = 104
      Width = 588
      ReadOnly = True
      TabOrder = 3
    end
    object lblAppLoc: TLabel
      Left = 3
      Height = 22
      Top = 32
      Width = 139
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'pg_dump asukoht:'
      ParentColor = False
    end
    object edtPgDumpLocation: TEdit
      Left = 147
      Height = 21
      Top = 29
      Width = 427
      TabOrder = 1
    end
    object chkboxConsole: TCheckBox
      Left = 147
      Height = 17
      Top = 56
      Width = 100
      Caption = 'Konsool nähtaval'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object btnDoBackup: TBitBtn
    Left = 424
    Height = 30
    Top = 397
    Width = 99
    Caption = '&Käivita'
    Default = True
    Kind = bkOK
    OnClick = btnDoBackupClick
    TabOrder = 1
  end
  object btnClose: TBitBtn
    Left = 528
    Height = 30
    Top = 397
    Width = 99
    Cancel = True
    Caption = 'Sulge'
    Kind = bkCancel
    ModalResult = 2
    OnClick = btnCloseClick
    TabOrder = 2
  end
  object dlgFileSave: TSaveDialog
    Title = 'Varukoopia'
    Filter = 'Kõik|*.*|SQL|*.sql'
    left = 24
    top = 376
  end
  object dlgFileOpen: TOpenDialog
    Title = 'Varukoopia'
    Filter = 'Kõik|*.*|SQL|*.sql'
    left = 88
    top = 376
  end
end
