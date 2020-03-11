object form_admin: Tform_admin
  Left = 23
  Height = 750
  Top = 215
  Width = 1000
  Caption = 'Stiigo administraator'
  ClientHeight = 725
  ClientWidth = 1000
  Constraints.MinHeight = 750
  Constraints.MinWidth = 1000
  DesignTimePPI = 120
  KeyPreview = True
  Menu = mnu_main
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '7.0'
  object Label3: TLabel
    Left = 722
    Height = 20
    Top = 666
    Width = 44
    Caption = 'Label3'
    ParentColor = False
    ParentFont = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Height = 29
    Top = 696
    Width = 1000
    Panels = <>
    ParentFont = False
  end
  object adm_mainpanel: TPanel
    Left = 0
    Height = 664
    Top = 32
    Width = 1000
    Align = alClient
    BevelInner = bvLowered
    Caption = 'adm_mainpanel'
    ClientHeight = 664
    ClientWidth = 1000
    ParentFont = False
    TabOrder = 1
    object admPages: TPageControl
      Left = 2
      Height = 660
      Top = 2
      Width = 996
      ActivePage = tabComp
      Align = alClient
      ParentFont = False
      TabIndex = 1
      TabOrder = 0
      object firstpage: TTabSheet
        Caption = '...'
        ClientHeight = 501
        ClientWidth = 788
        ParentFont = False
        object copyrightLabel: TLabel
          Left = 0
          Height = 58
          Top = 443
          Width = 788
          Align = alBottom
          Alignment = taRightJustify
          AutoSize = False
          Caption = '© Ingmar Tammeväli 2014'
          Color = clInactiveBorder
          Font.CharSet = BALTIC_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Pitch = fpVariable
          Font.Quality = fqDraft
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          Transparent = False
        end
        object l1: TBevel
          Left = 22
          Height = 14
          Top = 25
          Width = 62
          Shape = bsTopLine
        end
        object Label2: TLabel
          Left = 95
          Height = 14
          Top = 18
          Width = 27
          Caption = 'INFO'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object l2: TBevel
          Left = 142
          Height = 14
          Top = 25
          Width = 626
          Anchors = [akTop, akLeft, akRight]
          Shape = bsTopLine
        end
        object Label4: TLabel
          Left = 149
          Height = 14
          Top = 88
          Width = 67
          Caption = 'Arvuti lokaal: '
          ParentColor = False
          ParentFont = False
        end
        object lblLocData: TLabel
          Left = 242
          Height = 18
          Top = 88
          Width = 682
          AutoSize = False
          Caption = 'lblLocData'
          ParentColor = False
          ParentFont = False
        end
        object Label5: TLabel
          Left = 95
          Height = 14
          Top = 58
          Width = 110
          Caption = 'Andmebaasi versioon: '
          ParentColor = False
          ParentFont = False
        end
        object lblLocDbVersion: TLabel
          Left = 242
          Height = 18
          Top = 58
          Width = 682
          AutoSize = False
          Caption = 'lblLocData'
          ParentColor = False
          ParentFont = False
        end
      end
      object tabComp: TTabSheet
        Caption = 'Firma'
        ClientHeight = 627
        ClientWidth = 988
        ParentFont = False
        TabVisible = False
        object Panel1: TPanel
          Left = 0
          Height = 627
          Top = 0
          Width = 312
          Align = alLeft
          BevelInner = bvLowered
          ClientHeight = 627
          ClientWidth = 312
          Constraints.MinWidth = 250
          ParentFont = False
          TabOrder = 0
          object dbGridcmp: TDBGrid
            Left = 6
            Height = 616
            Top = 6
            Width = 301
            Anchors = [akTop, akLeft, akRight, akBottom]
            AutoEdit = False
            Color = clWindow
            Columns = <            
              item
                MinSize = 12
                MaxSize = 250
                Title.Caption = 'ID'
                Width = 38
                FieldName = 'id'
              end            
              item
                MinSize = 12
                MaxSize = 250
                Title.Caption = 'Nimi'
                Width = 212
                FieldName = 'name'
              end>
            DataSource = admCompListDataset
            Flat = True
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
            ParentFont = False
            PopupMenu = mnuCmpActions
            ReadOnly = True
            TabOrder = 0
          end
        end
        object Panel2: TPanel
          Tag = -1
          Left = 318
          Height = 627
          Top = 0
          Width = 670
          Align = alClient
          BevelOuter = bvNone
          ClientHeight = 627
          ClientWidth = 670
          Constraints.MinWidth = 125
          ParentFont = False
          TabOrder = 1
          object btnCancel: TBitBtn
            Tag = -1
            Left = 367
            Height = 38
            Top = 575
            Width = 124
            Anchors = [akRight, akBottom]
            Caption = 'Katkesta'
            Enabled = False
            Kind = bkNo
            OnClick = btnCancelClick
            ParentFont = False
            TabOrder = 1
          end
          object btnSave: TBitBtn
            Tag = -1
            Left = 241
            Height = 38
            Top = 575
            Width = 124
            Anchors = [akRight, akBottom]
            Caption = 'Salvesta'
            Enabled = False
            Kind = bkAll
            OnClick = btnSaveClick
            ParentFont = False
            TabOrder = 0
          end
          object btnClose: TBitBtn
            Tag = -1
            Left = 541
            Height = 38
            Top = 575
            Width = 124
            Anchors = [akRight, akBottom]
            Caption = 'Sulge'
            Kind = bkCancel
            ModalResult = 2
            OnClick = btnCloseClick
            ParentFont = False
            TabOrder = 2
          end
          object pageCompControl: TPageControl
            Left = 0
            Height = 555
            Top = 4
            Width = 668
            ActivePage = tabCompContact
            Anchors = [akTop, akLeft, akRight, akBottom]
            ParentFont = False
            TabIndex = 0
            TabOrder = 3
            OnChange = pageCompControlChange
            object tabCompContact: TTabSheet
              Caption = ' Kontaktandmed  '
              ClientHeight = 522
              ClientWidth = 660
              ParentFont = False
              object lbCompanyName: TLabel
                Left = 10
                Height = 18
                Top = 25
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Firma nimi:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtCompname: TDBEdit
                Left = 200
                Height = 28
                Top = 21
                Width = 418
                DataField = 'name'
                DataSource = admCompListDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 0
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbCompregcode: TLabel
                Left = 10
                Height = 18
                Top = 55
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Registrikood:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtRegnr: TDBEdit
                Left = 200
                Height = 28
                Top = 50
                Width = 222
                DataField = 'regnr'
                DataSource = admCompListDataset
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 1
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbVatnumber: TLabel
                Left = 10
                Height = 18
                Top = 82
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Käibemaksukohustuslase nr:'
                ParentColor = False
                ParentFont = False
              end
              object dbVatnumber: TDBEdit
                Left = 200
                Height = 28
                Top = 79
                Width = 222
                DataField = 'vatnumber'
                DataSource = admCompListDataset
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 2
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbMaja: TLabel
                Left = 7
                Height = 23
                Top = 200
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Maja:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtHouse: TDBEdit
                Left = 200
                Height = 28
                Top = 196
                Width = 222
                DataField = 'house_nr'
                DataSource = admCompListDataset
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 4
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbKorter: TLabel
                Left = 19
                Height = 18
                Top = 229
                Width = 168
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Korter:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtApartment: TDBEdit
                Left = 200
                Height = 28
                Top = 225
                Width = 222
                DataField = 'apartment_nr'
                DataSource = admCompListDataset
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 5
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbZipcode: TLabel
                Left = 6
                Height = 18
                Top = 258
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Postiindeks:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtZipcode: TDBEdit
                Left = 200
                Height = 28
                Top = 254
                Width = 222
                DataField = 'zipcode'
                DataSource = admCompListDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 6
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbPhone: TLabel
                Left = 10
                Height = 18
                Top = 286
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Telefon:'
                ParentColor = False
                ParentFont = False
              end
              object dbPhone: TDBEdit
                Left = 200
                Height = 28
                Top = 284
                Width = 222
                DataField = 'phone'
                DataSource = admCompListDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 7
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbMobile: TLabel
                Left = 10
                Height = 18
                Top = 316
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Mobiil:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtMobile: TDBEdit
                Left = 200
                Height = 28
                Top = 313
                Width = 222
                DataField = 'mobilephone'
                DataSource = admCompListDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 8
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbFax: TLabel
                Left = 10
                Height = 18
                Top = 345
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Faks:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtFax: TDBEdit
                Left = 200
                Height = 28
                Top = 342
                Width = 222
                DataField = 'fax'
                DataSource = admCompListDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 9
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object lbEmail: TLabel
                Left = 10
                Height = 18
                Top = 375
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'E-post:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtEmail: TDBEdit
                Left = 200
                Height = 28
                Top = 371
                Width = 418
                DataField = 'email'
                DataSource = admCompListDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 10
                OnKeyPress = dbEdtCompnameKeyPress
              end
              inline frameCompCAddr: TFrameAddrPicker
                Left = 20
                Height = 86
                Top = 109
                Width = 487
                ClientHeight = 86
                ClientWidth = 487
                TabOrder = 3
                Visible = True
                DesignLeft = 599
                DesignTop = 569
                inherited lbCounty: TLabel
                  Left = 105
                  Height = 20
                  Top = 3
                  Width = 65
                  Anchors = [akTop]
                  AutoSize = True
                  ParentFont = False
                end
                inherited lbCity: TLabel
                  Left = 97
                  Height = 20
                  Top = 33
                  Width = 73
                  Anchors = [akTop]
                  AutoSize = True
                  ParentFont = False
                end
                inherited lbStreet: TLabel
                  Left = 128
                  Height = 20
                  Top = 61
                  Width = 41
                  Anchors = [akTop]
                  AutoSize = True
                  ParentFont = False
                end
                inherited comboCounty: TComboBox
                  Left = 180
                  Height = 28
                  Top = 0
                  Width = 305
                  ItemHeight = 20
                  ParentFont = False
                end
                inherited comboCity: TComboBox
                  Left = 180
                  Height = 28
                  Top = 29
                  Width = 305
                  ItemHeight = 20
                  ParentFont = False
                end
                inherited comboStreet: TComboBox
                  Left = 180
                  Height = 28
                  Top = 58
                  Width = 305
                  ItemHeight = 20
                  ParentFont = False
                end
                inherited qryCity: TZQuery
                  Left = 535
                  Top = 107
                end
                inherited qryStreet: TZQuery
                  Left = 519
                  Top = 65427
                end
                inherited qryInsertCounty: TZUpdateSQL
                  Left = 495
                  Top = 11
                end
              end
            end
            object tabPageAccPeriod: TTabSheet
              Caption = ' Majandusaasta '
              ClientHeight = 522
              ClientWidth = 660
              ParentFont = False
              inline frameAccPeriods1: TframeAccPeriods
                Height = 522
                Width = 660
                Align = alClient
                ClientHeight = 522
                ClientWidth = 660
                DesignLeft = 340
                DesignTop = 329
                inherited lblPerName: TLabel
                  Top = 20
                  ParentFont = False
                end
                inherited dbEdtPerName: TDBEdit
                  Top = 16
                end
                inherited lblDateStart: TLabel
                  Left = 28
                  Top = 50
                  ParentFont = False
                end
                inherited dtEdtStart: TDateEdit
                  Top = 47
                end
                inherited dtEdtEnd: TDateEdit
                  Top = 79
                end
                inherited lblDateEnd: TLabel
                  Top = 84
                  ParentFont = False
                end
                inherited mrline3: TBevel
                  Width = 618
                end
                inherited accEntrys: TDBGrid
                  Height = 316
                  Width = 618
                end
                inherited mrline4: TBevel
                  Width = 618
                end
                inherited pchkboxAccPer: TCheckBox
                  Top = 476
                  ParentFont = False
                end
              end
            end
            object tabVat: TTabSheet
              Caption = 'Käibemaksud'
              ClientHeight = 522
              ClientWidth = 660
              ParentFont = False
              inline frameVATMgr: TframeVATs
                Height = 522
                Width = 660
                Align = alClient
                ClientHeight = 522
                ClientWidth = 660
                DesignLeft = 279
                DesignTop = 374
                inherited leftPanel: TPanel
                  Height = 522
                  ClientHeight = 522
                  ParentFont = False
                  inherited gridVat: TDBGrid
                    Height = 518
                    Width = 293
                    ParentFont = False
                  end
                end
                inherited Splitter1: TSplitter
                  Height = 522
                end
                inherited rightPanel: TPanel
                  Height = 522
                  Width = 350
                  ClientHeight = 522
                  ClientWidth = 350
                  ParentFont = False
                  inherited lblVatname: TLabel
                    Left = 22
                    Height = 20
                    Top = 23
                    Width = 139
                    AutoSize = True
                    ParentFont = False
                  end
                  inherited dbEdtVatName: TDBEdit
                    Left = 170
                    Top = 21
                    Width = 152
                    ParentFont = False
                  end
                  inherited lblVatPerc: TLabel
                    Left = 20
                    Top = 58
                    ParentFont = False
                  end
                  inherited dbEdtVatPerc: TDBEdit
                    Left = 170
                    Top = 54
                    ParentFont = False
                  end
                  inherited ptrnVat: TCheckBox
                    Left = 170
                    Top = 170
                    ParentFont = False
                  end
                  inherited lblSaleVat: TLabel
                    Left = -2
                    Top = 93
                    ParentFont = False
                  end
                  inherited lblSaleVat1: TLabel
                    Left = -2
                    Top = 131
                    ParentFont = False
                  end
                  inherited dblComboVat_svat: TRxDBLookupCombo
                    Left = 170
                    Top = 88
                    Width = 150
                    ParentFont = False
                  end
                  inherited dblComboVat_ipvat: TRxDBLookupCombo
                    Left = 170
                    Top = 125
                    Width = 150
                    ParentFont = False
                  end
                  inherited ptrnVat50perc: TCheckBox
                    Left = 170
                    Top = 190
                    ParentFont = False
                  end
                end
              end
            end
            object tabLogo: TTabSheet
              Caption = ' Logo '
              ClientHeight = 522
              ClientWidth = 660
              ParentFont = False
              object lbCompanyName1: TLabel
                Left = 10
                Height = 18
                Top = 25
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Firma logo:'
                ParentColor = False
                ParentFont = False
              end
              object panelCompLogo: TPanel
                Left = 199
                Height = 125
                Top = 25
                Width = 256
                BevelInner = bvLowered
                ClientHeight = 125
                ClientWidth = 256
                ParentFont = False
                TabOrder = 0
                OnClick = panelCompLogoClick
                object compLogoPct: TImage
                  Left = 2
                  Height = 121
                  Top = 2
                  Width = 252
                  Align = alClient
                  Stretch = True
                end
              end
              object SpeedButton1: TSpeedButton
                Left = 459
                Height = 28
                Hint = 'Lisan pildi'
                Top = 25
                Width = 29
                Glyph.Data = {
                  36040000424D3604000000000000360000002800000010000000100000000100
                  2000000000000004000064000000640000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  00000000000018A6C3691AA7C46900A0C4180000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  00000000000000A0C45D66DBEAB211A6C2AE0000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  00000000000000A0C42243C4DBFC43C5D8FE23A6C07F00000000000000000000
                  00000000000000000000000000000000000000A0C4FF00000000000000000000
                  000000000000000000000EAACBFE5DDAE9FE23A6C0EF00000000000000000000
                  000000000000000000000000000000A0C4FF00A0C4FF00000000000000000000
                  000000000000009EC11A02ACC8FF88E7F2FE11A2C2FF00000000000000000000
                  00000000000005797D1100A0C4FF76EDFBFF00A0C4FF000000000000000000A0
                  C4300099B95000A0C4C96DE6F5FF76E2EFFF19A3C1FF00000000000000000000
                  000005797D1100A0C4FF76EDFBFF76EDFBFF00A0C4FF00A0C4FF00A0C4FF00A0
                  C4FF01A9C4FF6EE1EEFF0FC9DFFF69E4F2FF1AA4C0F800000000000000000579
                  7D1100A0C4FF76EDFBFF04C3DAFF76EDFBFF69EAF9FF69EAF9FF69EAF9FF69EA
                  F9FF05DDF7FF0AC8DFFF07C2D8FF6FDCEBFF1BA3BFF40000000005797E1100A0
                  C4FF79EDFBFF32E2F8FF2CDFF4FF04C0D6FF04C0D6FF04C0D6FF1DD2E8FF1DD2
                  E8FF1DD2E8FF0BC8DFFF6AE5F3FF1BABC5F815A0BCCB0000000000A0C4FFADF3
                  FBFF2FE0F6FF32E2F8FF32E2F7FF32E2F7FF2FE0F5FF29DBF1FF1DD2E8FF1DD2
                  E8FF1DD2E8FF36D9ECFF40CDE1FF16A1BDCA05797D0A0000000005797D0A00A0
                  C4FFADF3FBFF2FE0F6FF32E2F7FF29DBF1FF2FE0F5FF29DBF1FF16CDE3FF36D9
                  ECFF69E7F6FF41CEE3FE13A3C1E405797D320000000000000000000000000579
                  7D1100A0C4FFADF3FBFF31E1F6FF20E3FAFF73ECFAFF6FEBFAFF6EE8F7FF6CE8
                  F7F814A1BCD414A3C1D505797D1C000000000000000000000000000000000000
                  000005797D1100A0C4FFADF3FBFF25E4FBFF00A0C4FF00A0C4FF13A1BEE7159F
                  BBCF1BA1BBA4067A7C0B00000000000000000000000000000000000000000000
                  00000000000005797D1100A0C4FFADF3FBFF00A0C4FF00000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  00000000000000000000009DBF1400A0C4FF00A0C4FF00000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  00000000000000000000000000000000000000A0C4FF00000000000000000000
                  0000000000000000000000000000000000000000000000000000
                }
                OnClick = SpeedButton1Click
                ShowHint = True
                ParentFont = False
                ParentShowHint = False
              end
            end
          end
          object btnNewItem: TBitBtn
            Tag = -1
            Left = 115
            Height = 38
            Top = 575
            Width = 124
            Anchors = [akRight, akBottom]
            Caption = 'Uus firma'
            Kind = bkYes
            OnClick = btnNewItemClick
            ParentFont = False
            TabOrder = 4
          end
        end
        object Splitter1: TSplitter
          Left = 312
          Height = 627
          Top = 0
          Width = 6
        end
      end
      object tabWorkerMgm: TTabSheet
        Caption = 'Kasutajate haldus'
        ClientHeight = 501
        ClientWidth = 788
        ParentFont = False
        TabVisible = False
        object leftpanelWrk: TPanel
          Left = 0
          Height = 501
          Top = 0
          Width = 312
          Align = alLeft
          BevelInner = bvLowered
          ClientHeight = 501
          ClientWidth = 312
          Constraints.MaxWidth = 475
          Constraints.MinWidth = 250
          ParentFont = False
          TabOrder = 0
          object dbGridWorkers: TDBGrid
            Left = 5
            Height = 490
            Top = 6
            Width = 240
            Anchors = [akTop, akLeft, akRight, akBottom]
            AutoEdit = False
            Color = clWindow
            Columns = <            
              item
                MinSize = 12
                MaxSize = 250
                Title.Caption = 'Kasutajanimi'
                Width = 212
                FieldName = 'loginname'
              end>
            DataSource = admWorkerMgmDataset
            Flat = True
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgCancelOnExit]
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
          end
        end
        object rightpanelWrk: TPanel
          Tag = -1
          Left = 255
          Height = 501
          Top = 0
          Width = 533
          Align = alClient
          BevelOuter = bvNone
          ClientHeight = 501
          ClientWidth = 533
          Constraints.MinWidth = 125
          ParentFont = False
          TabOrder = 1
          object pageCtrlUserMgr: TPageControl
            Tag = -1
            Left = 0
            Height = 430
            Top = 5
            Width = 529
            ActivePage = tabOverAllDescr
            Anchors = [akTop, akLeft, akRight, akBottom]
            ParentFont = False
            TabIndex = 0
            TabOrder = 0
            object tabOverAllDescr: TTabSheet
              Caption = 'Üldine kirjeldus'
              ClientHeight = 418
              ClientWidth = 522
              ParentFont = False
              object lbWorkerLoginname: TLabel
                Left = 9
                Height = 18
                Top = 28
                Width = 181
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Kasutajanimi:'
                ParentColor = False
                ParentFont = False
              end
              object lbWrkName: TLabel
                Left = 10
                Height = 18
                Top = 85
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Nimi:'
                ParentColor = False
                ParentFont = False
              end
              object lbWrkMiddleName: TLabel
                Left = 10
                Height = 18
                Top = 114
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Teine eesnimi:'
                ParentColor = False
                ParentFont = False
              end
              object lbWrkLastname: TLabel
                Left = 10
                Height = 18
                Top = 144
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Perekonnanimi:'
                ParentColor = False
                ParentFont = False
              end
              object lbWrkPosition: TLabel
                Left = 10
                Height = 18
                Top = 170
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Ametikoht:'
                ParentColor = False
                ParentFont = False
              end
              object lbWrkEmail: TLabel
                Left = 10
                Height = 18
                Top = 199
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'E-post:'
                ParentColor = False
                ParentFont = False
              end
              object lbWrkLastLogin: TLabel
                Left = 10
                Height = 18
                Top = 229
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Viimane logimine:'
                ParentColor = False
                ParentFont = False
              end
              object lbWrkLastLoginCIP: TLabel
                Left = 10
                Height = 18
                Top = 256
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Masina IP:'
                ParentColor = False
                ParentFont = False
              end
              object lbWrkLoginAllowed: TLabel
                Left = 9
                Height = 18
                Top = 288
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Tohib logida:'
                ParentColor = False
                ParentFont = False
              end
              object lbWorkerPassword: TLabel
                Left = 10
                Height = 18
                Top = 56
                Width = 180
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Parool:'
                ParentColor = False
                ParentFont = False
              end
              object dbEdtWrkLastlogin: TDBEdit
                Tag = -1
                Left = 200
                Height = 21
                Top = 224
                Width = 248
                DataField = 'lastlogin'
                DataSource = admWorkerMgmDataset
                ReadOnly = True
                CharCase = ecNormal
                Color = clBtnFace
                MaxLength = 0
                ParentFont = False
                TabOrder = 9
                TabStop = False
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object dbEdtWorkUsername: TDBEdit
                Left = 200
                Height = 21
                Top = 22
                Width = 262
                DataField = 'loginname'
                DataSource = admWorkerMgmDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 0
                OnKeyPress = dbEdtWorkUsernameKeyPress
              end
              object dbEdtWorkName: TDBEdit
                Left = 200
                Height = 21
                Top = 80
                Width = 262
                DataField = 'name'
                DataSource = admWorkerMgmDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 2
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object dbEdtWorMiddleName: TDBEdit
                Left = 200
                Height = 21
                Top = 109
                Width = 262
                DataField = 'middlename'
                DataSource = admWorkerMgmDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 3
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object dbEdtWrkLastname: TDBEdit
                Left = 200
                Height = 21
                Top = 138
                Width = 262
                DataField = 'lastname'
                DataSource = admWorkerMgmDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 4
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object dbEdtWrkPosition: TDBEdit
                Left = 200
                Height = 21
                Top = 166
                Width = 152
                DataField = 'position'
                DataSource = admWorkerMgmDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 5
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object dbEdtWrkEmail: TDBEdit
                Left = 200
                Height = 21
                Top = 195
                Width = 152
                DataField = 'email'
                DataSource = admWorkerMgmDataset
                Anchors = [akTop, akLeft, akRight]
                CharCase = ecNormal
                MaxLength = 0
                ParentFont = False
                TabOrder = 6
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object dbEdtWrLoginFromIp: TDBEdit
                Tag = -1
                Left = 200
                Height = 21
                Top = 252
                Width = 248
                DataField = 'fromip'
                DataSource = admWorkerMgmDataset
                ReadOnly = True
                CharCase = ecNormal
                Color = clBtnFace
                MaxLength = 0
                ParentFont = False
                TabOrder = 8
                TabStop = False
                OnKeyPress = dbEdtCompnameKeyPress
              end
              object dbChkboxAllowLogin: TDBCheckBox
                Left = 201
                Height = 21
                Top = 286
                Width = 135
                DataField = 'allowlogin'
                DataSource = admWorkerMgmDataset
                ParentFont = False
                TabOrder = 7
                ValueChecked = 'True'
                ValueUnchecked = 'False'
              end
              object edEdtWrkPassword: TEdit
                Left = 200
                Height = 21
                Top = 51
                Width = 328
                EchoMode = emPassword
                OnChange = edEdtWrkPasswordChange
                OnKeyPress = dbEdtWorkUsernameKeyPress
                ParentFont = False
                PasswordChar = '*'
                TabOrder = 1
              end
            end
            object tabAction: TTabSheet
              Caption = 'Tegevused'
              ClientHeight = 418
              ClientWidth = 522
              ParentFont = False
              object pgControlUserPrm: TPageControl
                Tag = -1
                Left = 0
                Height = 412
                Top = 6
                Width = 522
                ActivePage = tabCompanyPermission
                Anchors = [akTop, akLeft, akRight, akBottom]
                ParentFont = False
                TabIndex = 0
                TabOrder = 0
                object tabCompanyPermission: TTabSheet
                  Caption = 'Lubatud firmad'
                  ClientHeight = 387
                  ClientWidth = 514
                  ParentFont = False
                  object chkLstBoxAllowedCmp: TCheckListBox
                    Left = 4
                    Height = 369
                    Top = 10
                    Width = 501
                    Anchors = [akTop, akLeft, akRight, akBottom]
                    ItemHeight = 0
                    OnClick = chkLstBoxAllowedCmpClick
                    ParentFont = False
                    TabOrder = 0
                  end
                end
                object tabOverAllpermission: TTabSheet
                  Caption = 'Kõik õigused'
                  ClientHeight = 387
                  ClientWidth = 514
                  ParentFont = False
                  object chkLstBoxPermission: TCheckListBox
                    Left = 4
                    Height = 369
                    Top = 10
                    Width = 501
                    Anchors = [akTop, akLeft, akRight, akBottom]
                    ItemHeight = 0
                    OnClick = chkLstBoxAllowedCmpClick
                    OnItemClick = chkLstBoxPermissionItemClick
                    ParentFont = False
                    TabOrder = 0
                  end
                end
                object tabRole: TTabSheet
                  Caption = 'Roll'
                  ClientHeight = 387
                  ClientWidth = 514
                  ParentFont = False
                  object Label1: TLabel
                    Left = 5
                    Height = 14
                    Top = 160
                    Width = 118
                    Caption = 'Rollis sisalduvad õigused'
                    ParentColor = False
                    ParentFont = False
                  end
                  object chkLstBoxUserRoles: TCheckListBox
                    Left = 4
                    Height = 144
                    Top = 10
                    Width = 501
                    Anchors = [akTop, akLeft, akRight]
                    ItemHeight = 0
                    OnClick = chkLstBoxAllowedCmpClick
                    OnItemClick = chkLstBoxUserRolesItemClick
                    ParentFont = False
                    TabOrder = 0
                  end
                  object chkLstBoxUserRolePermListing: TCheckListBox
                    Left = 4
                    Height = 193
                    Top = 184
                    Width = 501
                    Anchors = [akTop, akLeft, akRight, akBottom]
                    ItemHeight = 0
                    OnClick = chkLstBoxAllowedCmpClick
                    OnItemClick = chkLstBoxUserRolePermListingItemClick
                    ParentFont = False
                    TabOrder = 1
                  end
                end
              end
            end
          end
          object btnSaveWorker: TBitBtn
            Tag = -1
            Left = 100
            Height = 38
            Top = 449
            Width = 124
            Anchors = [akRight, akBottom]
            Caption = '&Salvesta'
            Enabled = False
            Kind = bkAll
            ModalResult = 8
            OnClick = btnSaveWorkerClick
            ParentFont = False
            Spacing = 2
            TabOrder = 2
          end
          object btnCancelWorkerEdit: TBitBtn
            Tag = -1
            Left = 230
            Height = 38
            Top = 449
            Width = 124
            Anchors = [akRight, akBottom]
            Caption = '&Katkesta'
            Enabled = False
            Kind = bkNo
            OnClick = btnCancelWorkerEditClick
            ParentFont = False
            TabOrder = 3
          end
          object btnNewWorker: TBitBtn
            Tag = -1
            Left = -30
            Height = 38
            Top = 449
            Width = 124
            Anchors = [akRight, akBottom]
            Caption = '&Uus kasutaja'
            Default = True
            Kind = bkYes
            OnClick = btnNewWorkerClick
            ParentFont = False
            TabOrder = 1
          end
          object btnWorkerMgrTabClose: TBitBtn
            Tag = -1
            Left = 407
            Height = 38
            Top = 449
            Width = 124
            Anchors = [akRight, akBottom]
            Cancel = True
            Caption = 'Sulge'
            Kind = bkCancel
            OnClick = btnWorkerMgrTabCloseClick
            ParentFont = False
            TabOrder = 4
          end
        end
        object Splitter2: TSplitter
          Left = 250
          Height = 501
          Top = 0
          Width = 6
        end
      end
    end
  end
  object actionToolbar: TToolBar
    Left = 0
    Top = 0
    Width = 1000
    Caption = 'actionToolbar'
    Images = ImageList1
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = actionToolbarClick
    object btnMngComp: TToolButton
      Left = 1
      Top = 2
      Caption = 'btnMngComp'
      ImageIndex = 2
      OnClick = btnMngCompClick
    end
    object btnMgnUsers: TToolButton
      Left = 30
      Top = 2
      Caption = 'btnMgnUsers'
      ImageIndex = 0
      OnClick = btnMgnUsersClick
    end
    object ToolButton1: TToolButton
      Left = 59
      Top = 2
      Caption = 'ToolButton1'
    end
  end
  object mnu_main: TMainMenu
    Left = 940
    Top = 40
    object mnu_exit: TMenuItem
      Caption = 'Väljun'
      OnClick = mnu_exitClick
    end
    object mnuBackup: TMenuItem
      Caption = 'Uus varukoopia'
      OnClick = mnuBackupClick
    end
    object mnuRestore: TMenuItem
      Caption = 'Taasta varukoopiast'
      OnClick = mnuRestoreClick
    end
    object mnuVacuumDb: TMenuItem
      Caption = 'Korrasta andmebaas (vacuum)'
      OnClick = mnuVacuumDbClick
    end
    object FIX: TMenuItem
      Caption = ' '
      Visible = False
    end
    object mnuDebug: TMenuItem
      Caption = 'DEBUG'
      Visible = False
      OnClick = mnuDebugClick
    end
  end
  object ImageList1: TImageList
    Left = 940
    Bitmap = {
      4C690400000010000000100000008000800080008000800080007F7F7FFF0000
      00FF000000FF000000FF000000FF7F7F7FFF8000800080008000800080008000
      80008000800080008000800080008000800080008000000000FF7F7F7FFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF000000FF7F7F7FFF80008000800080008000
      800080008000800080008000800080008000000000FF00FFFFFF00FFFFFF0080
      80FF008080FF00FFFFFF00FFFFFF00FFFFFF000000FF80008000800080008000
      80008000800080008000800080007F7F7FFF7F7F7FFF00FFFFFF000000FF0000
      00FF008080FF00FFFFFF00FFFFFF00FFFFFF000000FF80008000800080008000
      8000800080008000800080008000000000FF00FFFFFF00FFFFFF000000FF0000
      00FF008080FF00FFFFFF00FFFFFF000000FF7F7F7FFF80008000800080008000
      8000800080008000800080008000000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF000000FF8000800080008000800080008000
      8000800080008000800080008000000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF008080FF00FFFFFF000000FF80008000800080008000
      80008000800080008000800080007F7F7FFF000000FF00FFFFFF00FFFFFF00FF
      FFFF000000FF000000FF00FFFFFF008080FF00FFFFFF000000FF800080008000
      8000800080008000800080008000800080007F7F7FFF000000FF000000FF0000
      00FF80008000000000FF000000FF000000FF008080FF00FFFFFF000000FF8000
      8000800080008000800080008000800080008000800080008000800080008000
      8000800080008000800080008000000000FF00FFFFFF008080FF00FFFFFF0000
      00FF800080008000800080008000800080008000800080008000800080008000
      8000800080008000800080008000000000FF000000FF00FFFFFF008080FF00FF
      FFFF000000FF8000800080008000800080008000800080008000800080008000
      800080008000800080008000800080008000000000FF000000FF000000FF0080
      80FF00FFFFFF000000FF80008000800080008000800080008000800080008000
      8000800080008000800080008000800080008000800080008000000000FF00FF
      FFFF008080FF00FFFFFF000000FF800080008000800080008000800080008000
      8000800080008000800080008000800080008000800080008000000000FF0000
      00FF000000FF00FFFFFF000000FF800080008000800080008000800080008000
      8000800080008000800080008000800080008000800080008000800080008000
      8000000000FF00FFFFFF000000FF800080008000800080008000800080008000
      8000800080008000800080008000800080008000800080008000800080008000
      8000000000FF000000FF000000FF8000800080008000800080007F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF8000800080008000800080008000
      800080008000800080008000800080008000800080007F7F7FFF80008000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFF7F7F7FFF80008000800080008000
      8000800080008000800080008000800080007F7F7FFF80008000FFFFFFFF8000
      8000800080008000800080008000800080007F7F7FFFFFFFFFFF800080008000
      80008000800080008000800080007F7F7FFF80008000FFFFFFFF7F7F7FFF7F7F
      7FFF800080008000800080008000800080007F7F7FFFFFFFFFFF800080008000
      80008000800080008000800080007F7F7FFFFFFFFFFF800080007F7F7FFF7F7F
      7FFFFFFFFFFF80008000800080007F7F7FFF80008000FFFFFFFF800080008000
      80008000800080008000800080007F7F7FFFFFFFFFFF8000800080008000FFFF
      FFFFFFFFFFFF80008000800080007F7F7FFFFFFFFFFF80008000800080008000
      80008000800080008000800080007F7F7FFFFFFFFFFF80008000800080008000
      8000800080008000800080008000800080007F7F7FFF80008000800080008000
      80008000800080008000800080007F7F7FFF7F7F7FFF80008000800080008000
      80007F7F7FFF7F7F7FFF8000800080008000800080007F7F7FFF800080008000
      8000800080008000800080008000800080007F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF800080007F7F7FFF7F7F7FFF7F7F7FFF80008000800080007F7F7FFF8000
      80008000800080008000800080008000800080008000FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF80008000FFFFFFFF7F7F7FFFFFFFFFFF80008000800080007F7F
      7FFF800080008000800080008000800080008000800080008000800080008000
      80008000800080008000800080007F7F7FFF7F7F7FFF80008000800080008000
      80007F7F7FFF8000800080008000800080008000800080008000800080008000
      8000800080008000800080008000800080007F7F7FFF7F7F7FFF7F7F7FFF8000
      8000800080007F7F7FFF80008000800080008000800080008000800080008000
      80008000800080008000800080008000800080008000FFFFFFFF7F7F7FFFFFFF
      FFFF80008000800080007F7F7FFF800080008000800080008000800080008000
      80008000800080008000800080008000800080008000800080007F7F7FFF7F7F
      7FFF7F7F7FFF800080007F7F7FFF800080008000800080008000800080008000
      800080008000800080008000800080008000800080008000800080008000FFFF
      FFFF7F7F7FFFFFFFFFFF7F7F7FFF800080008000800080008000800080008000
      8000800080008000800080008000800080008000800080008000800080008000
      80007F7F7FFF7F7F7FFF7F7F7FFF8000800080008000000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF80008000800080008000800080008000000000FF7F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF000000FF000000FF000000FF7F7F
      7FFF000000FF80008000800080008000800080008000000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFFFFFFFFFFFFFFFFFFFFFFFFF0000
      00FF000000FF80008000800080008000800080008000000000FFFFFFFFFF7F7F
      7FFF7F7F7FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF000000FF80008000800080008000800080008000000000FF000000FFFFFF
      FFFFFFFFFFFFFFFFFFFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF800080008000800080008000000000FF000000FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF000000FF000000FF80008000000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00FF
      FFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FF
      FFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00FF
      FFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF0000
      00FF7F7F7FFF7F7F7FFF00FFFFFF00FFFFFF00FFFFFF7F7F7FFF7F7F7FFF0000
      00FF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00FF
      FFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF000000FF80008000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF8000800080008000800080007F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF800080008000800080008000800080007F7F7FFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFF7F7F7FFF7F7F7FFFFFFF
      FFFF7F7F7FFFFFFFFFFF8000800080008000800080007F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF80008000FFFFFFFFFFFFFFFF7F7F
      7FFF7F7F7FFFFFFFFFFF8000800080008000800080007F7F7FFFFFFFFFFF7F7F
      7FFF7F7F7FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFF80008000800080008000
      80007F7F7FFFFFFFFFFF8000800080008000800080007F7F7FFF7F7F7FFF8000
      8000FFFFFFFFFFFFFFFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFFFFFFFFFF80008000800080007F7F7FFF7F7F7FFFFFFFFFFFFFFF
      FFFF800080008000800080008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF7F7F7FFF7F7F7FFF800080007F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF7F7F7FFF7F7F7FFFFFFFFFFF80008000800080008000
      80007F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF8000
      800080008000800080007F7F7FFF7F7F7FFFFFFFFFFF80008000800080008000
      80007F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFFFFFF
      FFFF80008000800080007F7F7FFF7F7F7FFFFFFFFFFF80008000800080008000
      80007F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFFFFFF
      FFFF80008000800080007F7F7FFF7F7F7FFFFFFFFFFF80008000800080008000
      800080008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF80008000800080007F7F7FFF7F7F7FFFFFFFFFFF80008000800080007F7F
      7FFF7F7F7FFF80008000800080008000800080008000800080007F7F7FFF7F7F
      7FFF80008000800080007F7F7FFF7F7F7FFFFFFFFFFF80008000800080008000
      80007F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFFFFFF
      FFFFFFFFFFFF800080007F7F7FFF7F7F7FFFFFFFFFFF80008000800080008000
      800080008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF80008000800080007F7F7FFF800080007F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF80008000
    }
  end
  object admCompListQry: TZQuery
    Connection = admDatamodule.admConnection
    AutoCalcFields = False
    BeforeScroll = admCompListQryBeforeScroll
    AfterScroll = admCompListQryAfterScroll
    UpdateObject = admDatamodule.admCompListUpSql
    CachedUpdates = True
    AfterInsert = admCompListQryAfterEdit
    BeforeEdit = admCompListQryBeforeEdit
    AfterEdit = admCompListQryAfterEdit
    BeforePost = admCompListQryBeforePost
    AfterPost = admCompListQryAfterPost
    OnEditError = admCompListQryEditError
    OnPostError = admCompListQryEditError
    ParamCheck = False
    Params = <>
    Sequence = admDatamodule.admCompListSeq
    SequenceField = 'id'
    Left = 270
    Top = 16374
  end
  object admWorkerMgmQry: TZQuery
    Connection = admDatamodule.admConnection
    AutoCalcFields = False
    BeforeScroll = admWorkerMgmQryBeforeScroll
    AfterScroll = admWorkerMgmQryAfterScroll
    UpdateObject = admDatamodule.admWorkerMgmSql
    CachedUpdates = True
    AfterInsert = admWorkerMgmQryAfterEdit
    AfterEdit = admWorkerMgmQryAfterEdit
    BeforePost = admWorkerMgmQryBeforePost
    AfterPost = admWorkerMgmQryAfterPost
    ParamCheck = False
    Params = <>
    Sequence = admDatamodule.admWorkerMgmSeq
    SequenceField = 'id'
    Left = 390
    Top = 16374
  end
  object admWorkerMgmDataset: TDataSource
    DataSet = admWorkerMgmQry
    Left = 660
    Top = 16374
  end
  object admCompListDataset: TDataSource
    DataSet = admCompListQry
    Left = 520
    Top = 16374
  end
  object tempQry: TZQuery
    Connection = admDatamodule.admConnection
    AutoCalcFields = False
    Params = <>
    Left = 110
    Top = 16374
  end
  object qryClientSeq: TZSequence
    Connection = admDatamodule.admConnection
    SequenceName = 'client_id_seq'
    Left = 790
    Top = 16374
  end
  object mnuCmpActions: TPopupMenu
    Left = 920
    Top = 520
    object MenuItem1: TMenuItem
      Caption = 'Impordi kontoplaan'
      OnClick = MenuItem1Click
    end
    object mnu_copySettings: TMenuItem
      Caption = 'Kopeeri seaded firmalt'
    end
    object mnuSep5: TMenuItem
      Caption = '-'
    end
    object mnuItemExecScript: TMenuItem
      Caption = 'Käivita skript'
      OnClick = mnuItemExecScriptClick
    end
    object mnuReinitRole: TMenuItem
      Caption = 'Reinitsialiseeri Stiigo roll'
      OnClick = mnuReinitRoleClick
    end
  end
  object openAccFile: TOpenDialog
    Title = 'Impordi kontoplaan'
    Filter = 'Teksti failid|*.txt|Kõik failid|*.*'
    Left = 810
    Top = 520
  end
  object openCompLogo: TOpenDialog
    Title = 'Valige logo'
    Filter = 'Jpeg fail|*.jpg'
    Left = 720
    Top = 520
  end
  object loadLogo: TTimer
    Enabled = False
    Interval = 400
    OnTimer = loadLogoTimer
    Left = 640
    Top = 520
  end
  object openScriptFile: TOpenDialog
    Title = 'Käivitame skripti'
    Filter = 'SQL fail|*.sql|Kõik failid|*.*'
    Left = 920
    Top = 460
  end
end
