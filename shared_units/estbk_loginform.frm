object form_login: Tform_login
  Left = 306
  Height = 295
  Top = 312
  Width = 435
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 295
  ClientWidth = 435
  DesignTimePPI = 120
  OnCreate = FormCreate
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '7.0'
  object panel_login: TPanel
    Left = 0
    Height = 295
    Top = 0
    Width = 435
    Align = alClient
    BevelInner = bvLowered
    ClientHeight = 295
    ClientWidth = 435
    ParentFont = False
    TabOrder = 0
    object Bevel1: TBevel
      Left = 20
      Height = 9
      Top = 156
      Width = 400
      Shape = bsTopLine
    end
    object extConf: TCheckBox
      Left = 160
      Height = 21
      Top = 166
      Width = 260
      AutoSize = False
      Caption = 'Kuva täiendavaid seadeid'
      Font.Height = -14
      OnClick = extConfClick
      ParentFont = False
      TabOrder = 4
    end
    object edtServerAddr: TLabeledEdit
      Left = 160
      Height = 26
      Top = 210
      Width = 230
      AutoSize = False
      EditLabel.Height = 20
      EditLabel.Width = 102
      EditLabel.Caption = 'Serveri aadress:'
      EditLabel.ParentColor = False
      EditLabel.ParentFont = False
      Font.Height = -15
      LabelPosition = lpLeft
      LabelSpacing = 5
      MaxLength = 255
      ParentFont = False
      TabOrder = 5
      TabStop = False
      Text = 'localhost'
    end
    object edtServerPort: TLabeledEdit
      Left = 160
      Height = 26
      Top = 251
      Width = 100
      AutoSize = False
      EditLabel.Height = 20
      EditLabel.Width = 80
      EditLabel.Caption = 'Serveri port:'
      EditLabel.ParentColor = False
      EditLabel.ParentFont = False
      Font.Height = -15
      LabelPosition = lpLeft
      LabelSpacing = 5
      MaxLength = 8
      ParentFont = False
      TabOrder = 6
      Text = '5432'
      OnKeyPress = edtServerPortKeyPress
    end
    object edt_username: TLabeledEdit
      Left = 160
      Height = 26
      Top = 24
      Width = 230
      AutoSize = False
      EditLabel.Height = 20
      EditLabel.Width = 88
      EditLabel.Caption = 'Kasutajanimi:'
      EditLabel.ParentColor = False
      EditLabel.ParentFont = False
      Font.Height = -15
      LabelPosition = lpLeft
      LabelSpacing = 5
      ParentFont = False
      TabOrder = 0
      OnKeyPress = edt_usernameKeyPress
    end
    object edt_password: TLabeledEdit
      Left = 160
      Height = 26
      Top = 65
      Width = 230
      AutoSize = False
      EchoMode = emPassword
      EditLabel.Height = 20
      EditLabel.Width = 45
      EditLabel.Caption = 'Parool:'
      EditLabel.ParentColor = False
      EditLabel.ParentFont = False
      Font.Height = -15
      LabelPosition = lpLeft
      LabelSpacing = 5
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      OnKeyPress = edt_usernameKeyPress
    end
    object btn_exit: TBitBtn
      Left = 300
      Height = 38
      Top = 110
      Width = 90
      Anchors = [akTop, akRight]
      Caption = '&Katkestan'
      Font.Height = -16
      ModalResult = 2
      OnClick = btn_exitClick
      ParentFont = False
      TabOrder = 3
    end
    object btn_login: TBitBtn
      Left = 205
      Height = 38
      Top = 110
      Width = 90
      Anchors = [akTop, akRight]
      Caption = '&Logime'
      Font.Height = -16
      ModalResult = 1
      ParentFont = False
      TabOrder = 2
    end
  end
end
