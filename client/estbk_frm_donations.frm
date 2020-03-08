object formDonation: TformDonation
  Left = 220
  Height = 420
  Top = 209
  Width = 453
  ActiveControl = edtCompName
  BorderStyle = bsDialog
  Caption = 'Toetamine'
  ClientHeight = 420
  ClientWidth = 453
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '0.9.30'
  object GroupBox1: TGroupBox
    Left = 5
    Height = 192
    Top = 3
    Width = 440
    Anchors = [akTop, akLeft, akRight, akBottom]
    ClientHeight = 174
    ClientWidth = 436
    TabOrder = 0
    object mDescr: TMemo
      Left = 4
      Height = 174
      Top = -3
      Width = 426
      Lines.Strings = (
        'Antud vormi kaudu rahaliselt toetada "entusiasmi", sest ka entusiasm vajab toetust. '
        'Mida rohkem toetajaid, seda enam saab pühenduda vaid Stiigo arendamisele !'
        ''
        'Eraisikud saavad pealehelt läbi Paypal annetuse toetada. '
        ''
        'Selle vormi abil saadetakse toetusavaldus serverisse ja koostatakse Teie firmale arve, '
        'et saaksite juriidiliselt korrektselt väljaminekuid kajastada.'
        'Arve koostatakse 1 nädala jooksul.'
        ''
        'Toetussumma saate kirjutada vabal valikul ...'
        ''
        'Tänan kõiki toetajaid !'
      )
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Label1: TLabel
    Left = 8
    Height = 20
    Top = 208
    Width = 168
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Teie firma nimi:  '
    Color = clInfoBk
    Layout = tlCenter
    ParentColor = False
    Transparent = False
  end
  object Label2: TLabel
    Left = 8
    Height = 20
    Top = 232
    Width = 168
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'E-post:  '
    Color = clInfoBk
    Layout = tlCenter
    ParentColor = False
    Transparent = False
  end
  object Label3: TLabel
    Left = 8
    Height = 20
    Top = 256
    Width = 168
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Kontaktisiku nimi:  '
    Color = clInfoBk
    Layout = tlCenter
    ParentColor = False
    Transparent = False
  end
  object Label4: TLabel
    Left = 8
    Height = 20
    Top = 280
    Width = 168
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Tahan toetada summas:  '
    Color = clInfoBk
    Layout = tlCenter
    ParentColor = False
    Transparent = False
  end
  object edtCompName: TEdit
    Left = 179
    Height = 21
    Top = 208
    Width = 261
    OnKeyPress = edtCompNameKeyPress
    TabOrder = 1
  end
  object edtCompEmail: TEdit
    Left = 179
    Height = 21
    Top = 232
    Width = 261
    TabOrder = 2
  end
  object edtContactPerson: TEdit
    Left = 179
    Height = 21
    Top = 256
    Width = 261
    TabOrder = 3
  end
  object edtDonSum: TEdit
    Left = 179
    Height = 21
    Top = 280
    Width = 53
    MaxLength = 3
    TabOrder = 4
  end
  object Bevel1: TBevel
    Left = 8
    Height = 8
    Top = 360
    Width = 434
    Shape = bsTopLine
  end
  object btnClose: TBitBtn
    Left = 351
    Height = 30
    Top = 376
    Width = 91
    Caption = '&Sulgen'
    Kind = bkCancel
    OnClick = btnCloseClick
    TabOrder = 6
  end
  object btnSupport: TBitBtn
    Left = 256
    Height = 30
    Top = 376
    Width = 91
    Caption = '&Toetan'
    Default = True
    Kind = bkOK
    OnClick = btnSupportClick
    TabOrder = 5
  end
  object Label5: TLabel
    Left = 237
    Height = 20
    Top = 280
    Width = 168
    AutoSize = False
    Caption = ' koos KM''ga (alates 6€)'
    Color = clInfoBk
    Layout = tlCenter
    ParentColor = False
    Transparent = False
  end
end
