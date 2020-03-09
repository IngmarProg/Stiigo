object estBkMainForm: TestBkMainForm
  Left = 23
  Height = 718
  Top = 215
  Width = 1031
  HorzScrollBar.Page = 799
  HorzScrollBar.Range = 205
  VertScrollBar.Page = 526
  Align = alClient
  Caption = 'Stiigo'
  ClientHeight = 693
  ClientWidth = 1031
  Constraints.MinHeight = 625
  Constraints.MinWidth = 1000
  DesignTimePPI = 120
  KeyPreview = True
  Menu = Mnumain
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  Position = poDesktopCenter
  LCLVersion = '7.0'
  object pgControl: TPageControl
    Left = 0
    Height = 664
    Top = 0
    Width = 1031
    TabStop = False
    ActivePage = pMainTabSheet
    Align = alClient
    ParentFont = False
    TabIndex = 0
    TabOrder = 0
    object pMainTabSheet: TTabSheet
      ClientHeight = 631
      ClientWidth = 1023
      OnContextPopup = pMainTabSheetContextPopup
      ParentFont = False
      TabVisible = False
      object Image1: TImage
        Left = 35
        Height = 192
        Top = 22
        Width = 200
        Transparent = True
      end
      object lblCurrDate: TLabel
        Tag = -1
        Left = 75
        Height = 18
        Top = 102
        Width = 100
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'lblCurrDate'
        Font.Color = 8487297
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
    end
  end
  object pStatusBar: TStatusBar
    Left = 0
    Height = 29
    Top = 664
    Width = 1031
    Panels = <    
      item
        Style = psOwnerDraw
        Text = '    '
        Width = 675
      end    
      item
        Alignment = taRightJustify
        Style = psOwnerDraw
        Text = '  '
        Width = 324
      end>
    ParentFont = False
    SimplePanel = False
    OnClick = pStatusBarClick
    OnDrawPanel = pStatusBarDrawPanel
  end
  object Mnumain: TMainMenu
    Left = 940
    Top = 20
    object Mnufail: TMenuItem
      Caption = 'Fail'
      object Mnuexit: TMenuItem
        Caption = '&Väljun'
        OnClick = MnuexitClick
      end
    end
    object MnuFinance: TMenuItem
      Caption = 'Finants'
      object mnuItemGenLedger: TMenuItem
        Caption = 'F&inantskanded'
        OnClick = mnuItemGenLedgerClick
      end
      object mnuAccounts: TMenuItem
        Caption = '&Kontod'
        OnClick = mnuAccountsClick
      end
      object mnuObjects: TMenuItem
        Caption = '&Objektid'
        OnClick = mnuObjectsClick
      end
      object mnuSep: TMenuItem
        Caption = '-'
      end
      object mnuGenLedgerRep: TMenuItem
        Caption = 'P&earaamat'
        OnClick = mnuGenLedgerRepClick
      end
      object mnuDailyJournal: TMenuItem
        Caption = '&Päevaraamat'
        OnClick = mnuDailyJournalClick
      end
      object mnuAccTurnover: TMenuItem
        Caption = 'Käi&beandmik'
        OnClick = mnuAccTurnoverClick
      end
      object mnuSep2: TMenuItem
        Caption = '-'
      end
      object mnuBalance: TMenuItem
        Caption = '&Bilanss'
        OnClick = mnuBalanceClick
      end
      object mnuProfitRep: TMenuItem
        Caption = 'K&asumiaruanne'
        OnClick = mnuProfitRepClick
      end
      object mnuSep15: TMenuItem
        Caption = '-'
      end
      object mnuVatDeclRez: TMenuItem
        Caption = 'Käibedeklaratsioon'
        OnClick = mnuVatDeclRezClick
      end
      object mnusep16: TMenuItem
        Caption = '-'
      end
      object mnuClosingAccRec: TMenuItem
        Caption = 'Sulgemiskanne'
        OnClick = mnuClosingAccRecClick
      end
    end
    object mnuSalesRez: TMenuItem
      Caption = 'Müük'
      object mnuSaleBill: TMenuItem
        Caption = '&Arved'
        OnClick = mnuSaleBillClick
      end
      object mnuSep8: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuSaleOffer: TMenuItem
        Caption = 'Pakkumised'
        Visible = False
      end
      object mnuOffers: TMenuItem
        Caption = 'Tellimuste nimekiri'
        Visible = False
      end
      object mnuSep20: TMenuItem
        Caption = '-'
      end
      object mnuDebtorsSale: TMenuItem
        Caption = 'Võlgnevused'
        OnClick = mnuDebtorsSaleClick
      end
    end
    object mnuPurcRez: TMenuItem
      Caption = 'Ost'
      object mnuPurchBill: TMenuItem
        Caption = '&Arved'
        OnClick = mnuPurchBillClick
      end
      object mnuSep6: TMenuItem
        Caption = '-'
      end
      object mnuPurcOrderReq: TMenuItem
        Caption = 'T&ellimused'
        OnClick = mnuPurcOrderReqClick
      end
      object mnuSep21: TMenuItem
        Caption = '-'
      end
      object mnuDebtPurch: TMenuItem
        Caption = 'Võlgnevused'
        OnClick = mnuDebtPurchClick
      end
      object mnuSep85: TMenuItem
        Caption = '-'
      end
      object mnuImportEBills: TMenuItem
        Caption = 'Impordi e-arve'
        OnClick = mnuImportEBillsClick
      end
    end
    object mnuBankCl: TMenuItem
      Caption = 'Pank'
      object mnuPaymentsc: TMenuItem
        Caption = 'Tasumine'
        OnClick = mnuPaymentscClick
      end
      object mnuSep28: TMenuItem
        Caption = '-'
      end
      object mnuIncomingsManualc: TMenuItem
        Caption = 'Laekumine'
        OnClick = mnuIncomingsManualcClick
      end
      object mnuSep66: TMenuItem
        Caption = '-'
      end
      object mnuIncomingsFromFilec: TMenuItem
        Caption = 'Laekumine (failist)'
        OnClick = mnuIncomingsFromFilecClick
      end
    end
    object mnuCashbox: TMenuItem
      Caption = 'Kassa'
      OnClick = mnuCashboxClick
      object mnuCboxPayments: TMenuItem
        Caption = 'Makse'
        OnClick = mnuCboxPaymentsClick
      end
      object mnuSep65: TMenuItem
        Caption = '-'
      end
      object mnucashbook: TMenuItem
        Caption = 'Kassaraamat'
        OnClick = mnucashbookClick
      end
    end
    object mnuItemClient: TMenuItem
      Caption = 'Kliendid'
      object mnuClientList: TMenuItem
        Caption = '&Nimekiri'
        OnClick = mnuClientListClick
      end
    end
    object mnuArticles: TMenuItem
      Caption = 'Artiklid'
      object mnuArticlesList: TMenuItem
        Caption = 'Nimekiri'
        OnClick = mnuArticlesListClick
      end
    end
    object mnuWarehouseEx: TMenuItem
      Caption = 'Ladu'
      Visible = False
      object mnuWarehouseList: TMenuItem
        Caption = 'Nimekiri'
        OnClick = mnuWarehouseListClick
      end
    end
    object mnuMiscSettings: TMenuItem
      Caption = 'Lisad'
      object mnuItemDefAccounts: TMenuItem
        Caption = 'Vaikimisi kontod'
        OnClick = mnuItemDefAccountsClick
      end
      object mnuBanks: TMenuItem
        Caption = 'Pangad'
        OnClick = mnuBanksClick
      end
      object mnuSep12: TMenuItem
        Caption = '-'
      end
      object mnuAppSettings: TMenuItem
        Caption = 'Seaded'
        OnClick = mnuAppSettingsClick
      end
      object mnuRepDesigner: TMenuItem
        Caption = 'Aruande disainer'
        OnClick = mnuRepDesignerClick
      end
      object mnuSep14: TMenuItem
        Caption = '-'
      end
      object mnuForms: TMenuItem
        Caption = 'Vormide defineerimine'
        OnClick = mnuFormsClick
        object mnuItemVatDecl: TMenuItem
          Caption = 'Käibedeklaratsioon'
          OnClick = mnuItemVatDeclClick
        end
        object mnuItemBalance: TMenuItem
          Caption = 'Bilanss'
          OnClick = mnuItemBalanceClick
        end
        object mnuItemIncStatement: TMenuItem
          Caption = 'Kasumiaruanne'
          OnClick = mnuItemIncStatementClick
        end
      end
      object MenuItem1: TMenuItem
        Caption = '-'
      end
      object mnuCurrency: TMenuItem
        Caption = 'Valuutakursid'
        OnClick = mnuCurrencyClick
      end
      object mnuUpdateStiigo: TMenuItem
        Caption = 'Programmi uuendamine'
        OnClick = mnuUpdateStiigoClick
      end
    end
    object mnuSalary: TMenuItem
      Caption = 'Palk'
      object mnuItemWorker: TMenuItem
        Caption = 'Töötajad'
        OnClick = mnuItemWorkerClick
      end
      object test2: TMenuItem
        Caption = 'Palga mall'
        OnClick = test2Click
      end
    end
    object mnuAbout: TMenuItem
      Caption = '&Programmist'
      OnClick = mnuAboutClick
      object mnuInfo: TMenuItem
        Caption = '&Info'
        OnClick = mnuInfoClick
      end
      object mnuSep18: TMenuItem
        Caption = '-'
      end
    end
    object mnuDebug: TMenuItem
      Caption = 'Debug'
      OnClick = mnuDebugClick
    end
    object mnuFIX: TMenuItem
      Visible = False
    end
  end
  object myAppProp: TApplicationProperties
    OnException = myAppPropException
    OnRestore = myAppPropRestore
    OnShowHint = myAppPropShowHint
    Left = 30
    Top = 10
  end
  object SQLTrace: TZSQLMonitor
    FileName = 'c:\debug\sql.txt'
    MaxTraceCount = 100
    OnLogTrace = SQLTraceLogTrace
    Left = 30
    Top = 100
  end
  object asyncExec: TAsyncProcess
    Active = False
    Options = []
    Priority = ppNormal
    StartupOptions = []
    ShowWindow = swoNone
    WindowColumns = 0
    WindowHeight = 0
    WindowLeft = 0
    WindowRows = 0
    WindowTop = 0
    WindowWidth = 0
    FillAttribute = 0
    Left = 30
    Top = 190
  end
  object heightFix: TTimer
    Interval = 600
    OnTimer = heightFixTimer
    Left = 19
    Top = 600
  end
end
