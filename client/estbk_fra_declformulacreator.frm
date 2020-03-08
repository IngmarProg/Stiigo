object frameFormulaCreator: TframeFormulaCreator
  Left = 0
  Height = 488
  Top = 0
  Width = 699
  ClientHeight = 488
  ClientWidth = 699
  TabOrder = 0
  DesignLeft = 223
  DesignTop = 224
  object grpFormulas: TGroupBox
    Left = 6
    Height = 418
    Top = 4
    Width = 690
    Anchors = [akTop, akLeft, akRight, akBottom]
    Caption = ' Valem '
    ClientHeight = 400
    ClientWidth = 686
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object pmainRezsizepanel: TPanel
      Left = 5
      Height = 394
      Top = 0
      Width = 675
      Anchors = [akTop, akLeft, akRight, akBottom]
      BevelOuter = bvNone
      ClientHeight = 394
      ClientWidth = 675
      TabOrder = 0
      object pleftpanel: TPanel
        Left = 0
        Height = 394
        Top = 0
        Width = 291
        Align = alClient
        BevelOuter = bvNone
        ClientHeight = 394
        ClientWidth = 291
        Constraints.MinWidth = 280
        TabOrder = 0
        object pSrcAccount: TEdit
          Left = 0
          Height = 21
          Top = 10
          Width = 285
          Anchors = [akTop, akLeft, akRight]
          Constraints.MinWidth = 200
          MaxLength = 255
          OnKeyPress = pSrcAccountKeyPress
          TabOrder = 0
        end
        object pAccounts: TVirtualStringTree
          Left = 0
          Height = 362
          Top = 32
          Width = 285
          Anchors = [akTop, akLeft, akRight, akBottom]
          Color = clWindow
          Colors.BorderColor = clWindowText
          Colors.HotColor = clBlack
          Constraints.MinHeight = 100
          Constraints.MinWidth = 100
          DefaultNodeHeight = 20
          DefaultText = 'Node'
          DragImageKind = diMainColumnOnly
          DragMode = dmAutomatic
          DragOperations = [doCopy]
          DragType = dtVCL
          DrawSelectionMode = smBlendedRectangle
          Header.AutoSizeIndex = 1
          Header.Columns = <          
            item
              MaxWidth = 400
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coFixed]
              Position = 0
              Text = 'Kood'
              Width = 75
            end          
            item
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coFixed]
              Position = 1
              Text = 'Kirjeldus'
              Width = 206
            end>
          Header.DefaultHeight = 17
          Header.Font.Height = -11
          Header.Font.Name = 'MS Sans Serif'
          Header.Height = 18
          Header.Images = dmodule.sharedImages
          Header.MaxHeight = 2000
          Header.Options = [hoAutoResize, hoColumnResize, hoShowImages, hoVisible, hoAutoSpring]
          HintMode = hmHint
          IncrementalSearch = isAll
          IncrementalSearchTimeout = 500
          Indent = 19
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TreeOptions.AnimationOptions = [toAnimatedToggle]
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.MiscOptions = [toEditable, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
          TreeOptions.StringOptions = [toAutoAcceptEditChange]
          OnAdvancedHeaderDraw = pAccountsAdvancedHeaderDraw
          OnBeforeCellPaint = pAccountsBeforeCellPaint
          OnColumnDblClick = pAccountsColumnDblClick
          OnCompareNodes = pAccountsCompareNodes
          OnFocusChanged = pAccountsFocusChanged
          OnFreeNode = pAccountsFreeNode
          OnGetText = pAccountsGetText
          OnHeaderClick = pAccountsHeaderClick
          OnInitNode = pAccountsInitNode
          OnKeyDown = pAccountsKeyDown
        end
      end
      object Splitter1: TSplitter
        Left = 291
        Height = 394
        Top = 0
        Width = 5
        Align = alRight
        ResizeAnchor = akRight
      end
      object prightpanel: TPanel
        Left = 296
        Height = 394
        Top = 0
        Width = 379
        Align = alRight
        BevelOuter = bvNone
        ClientHeight = 394
        ClientWidth = 379
        Constraints.MinWidth = 200
        TabOrder = 2
        object lblEq: TLabel
          Left = 256
          Height = 14
          Top = 13
          Width = 83
          Anchors = [akTop, akRight]
          Caption = 'Vaikimisi tehe:'
          ParentColor = False
        end
        object grpBoxCAccounts: TCheckGroup
          Left = 11
          Height = 118
          Top = 276
          Width = 364
          Anchors = [akLeft, akRight, akBottom]
          AutoFill = True
          Caption = ' Valitud konto'
          ChildSizing.LeftRightSpacing = 6
          ChildSizing.TopBottomSpacing = 6
          ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
          ChildSizing.EnlargeVertical = crsHomogenousChildResize
          ChildSizing.ShrinkHorizontal = crsScaleChilds
          ChildSizing.ShrinkVertical = crsScaleChilds
          ChildSizing.Layout = cclLeftToRightThenTopToBottom
          ChildSizing.ControlsPerLine = 1
          Items.Strings = (
            '1. konto Deebetkäive'
            '2. konto Kreeditkäive'
            '3. konto Saldo'
          )
          OnClick = grpBoxCAccountsClick
          OnItemClick = grpBoxCAccountsItemClick
          TabOrder = 3
          Data = {
            03000000020202
          }
        end
        object cmbEqType: TComboBox
          Left = 343
          Height = 21
          Top = 10
          Width = 32
          Anchors = [akTop, akRight]
          ItemHeight = 13
          ItemIndex = 0
          Items.Strings = (
            '+'
            '-'
            '*'
            '/'
          )
          OnChange = cmbEqTypeChange
          Style = csDropDownList
          TabOrder = 1
          Text = '+'
        end
        object lstSelectedAccounts: TListView
          Left = 11
          Height = 236
          Top = 32
          Width = 364
          Anchors = [akTop, akLeft, akRight, akBottom]
          Columns = <          
            item
              AutoSize = True
              Width = 360
            end>
          HideSelection = False
          PopupMenu = extpopup
          ReadOnly = True
          RowSelect = True
          SmallImages = dmodule.sharedImages
          TabOrder = 2
          ViewStyle = vsReport
          OnCustomDraw = lstSelectedAccountsCustomDraw
          OnCustomDrawItem = lstSelectedAccountsCustomDrawItem
          OnDragOver = lstSelectedAccountsDragOver
          OnKeyDown = lstSelectedAccountsKeyDown
          OnSelectItem = lstSelectedAccountsSelectItem
        end
        object edtEq: TEdit
          Left = 11
          Height = 21
          Top = 10
          Width = 240
          Anchors = [akTop, akLeft, akRight]
          CharCase = ecUppercase
          HideSelection = False
          MaxLength = 350
          OnChange = edtEqChange
          OnExit = edtEqExit
          TabOrder = 0
        end
      end
    end
  end
  object btnClose: TBitBtn
    Tag = -1
    Left = 596
    Height = 30
    Top = 443
    Width = 80
    Anchors = [akRight, akBottom]
    Caption = 'Sulge'
    OnClick = btnCloseClick
    TabOrder = 1
  end
  object btnSave: TBitBtn
    Tag = -1
    Left = 512
    Height = 30
    Top = 443
    Width = 80
    Anchors = [akRight, akBottom]
    Caption = 'Rakenda'
    Enabled = False
    OnClick = btnSaveClick
    TabOrder = 2
  end
  object qryAccounts: TZQuery
    CachedUpdates = True
    Params = <>
    left = 656
    top = 65528
  end
  object extpopup: TPopupMenu
    left = 56
    top = 112
    object mnuitemdelline: TMenuItem
      Caption = 'Kustuta rida'
      OnClick = mnuitemdellineClick
    end
  end
end
