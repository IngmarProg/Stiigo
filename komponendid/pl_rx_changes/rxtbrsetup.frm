object ToolPanelSetupForm: TToolPanelSetupForm
  Left = 383
  Height = 487
  Top = 176
  Width = 657
  ActiveControl = PageControl1
  Caption = 'Tool panel setup'
  ClientHeight = 487
  ClientWidth = 657
  OnClose = FormClose
  OnResize = FormResize
  Position = poScreenCenter
  LCLVersion = '6.7'
  object PageControl1: TPageControl
    Left = 0
    Height = 429
    Top = 0
    Width = 657
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Visible buttons'
      ClientHeight = 398
      ClientWidth = 647
      object Label1: TLabel
        AnchorSideLeft.Control = btnLeft2
        AnchorSideLeft.Side = asrBottom
        AnchorSideTop.Control = TabSheet1
        Left = 339
        Height = 17
        Top = 6
        Width = 105
        BorderSpacing.Around = 6
        Caption = 'Avaliable buttons'
        FocusControl = ListBtnAvaliable
        ParentColor = False
      end
      object Label2: TLabel
        AnchorSideTop.Control = TabSheet1
        Left = 8
        Height = 17
        Top = 6
        Width = 90
        BorderSpacing.Around = 6
        Caption = 'Visible buttons'
        FocusControl = ListBtnVisible
        ParentColor = False
      end
      object btnLeft2: TBitBtn
        AnchorSideLeft.Control = btnRight2
        AnchorSideTop.Control = btnLeft
        AnchorSideTop.Side = asrBottom
        AnchorSideRight.Control = btnRight2
        AnchorSideRight.Side = asrBottom
        Left = 313
        Height = 30
        Top = 125
        Width = 20
        Anchors = [akTop, akLeft, akRight]
        BorderSpacing.Top = 6
        BorderSpacing.InnerBorder = 2
        OnClick = btnLeft2Click
        TabOrder = 0
      end
      object btnLeft: TBitBtn
        AnchorSideLeft.Control = btnRight2
        AnchorSideTop.Control = btnRight
        AnchorSideTop.Side = asrBottom
        AnchorSideRight.Control = btnRight2
        AnchorSideRight.Side = asrBottom
        Left = 313
        Height = 20
        Top = 99
        Width = 20
        Anchors = [akTop, akLeft, akRight]
        AutoSize = True
        BorderSpacing.Top = 6
        BorderSpacing.InnerBorder = 2
        OnClick = btnLeftClick
        TabOrder = 1
      end
      object btnRight: TBitBtn
        AnchorSideLeft.Control = btnRight2
        AnchorSideTop.Control = btnRight2
        AnchorSideTop.Side = asrBottom
        AnchorSideRight.Control = btnRight2
        AnchorSideRight.Side = asrBottom
        Left = 313
        Height = 38
        Top = 55
        Width = 20
        Anchors = [akTop, akLeft, akRight]
        BorderSpacing.Top = 6
        BorderSpacing.InnerBorder = 2
        OnClick = btnRightClick
        TabOrder = 2
      end
      object btnRight2: TBitBtn
        AnchorSideLeft.Control = TabSheet1
        AnchorSideLeft.Side = asrCenter
        AnchorSideTop.Control = ListBtnAvaliable
        Left = 313
        Height = 20
        Top = 29
        Width = 20
        AutoSize = True
        BorderSpacing.InnerBorder = 2
        OnClick = btnRight2Click
        TabOrder = 3
      end
      object ListBtnAvaliable: TListBox
        AnchorSideLeft.Control = btnLeft2
        AnchorSideLeft.Side = asrBottom
        AnchorSideTop.Control = Label1
        AnchorSideTop.Side = asrBottom
        AnchorSideRight.Control = TabSheet1
        AnchorSideRight.Side = asrBottom
        AnchorSideBottom.Control = cbShowCaption
        Left = 339
        Height = 266
        Top = 29
        Width = 302
        Anchors = [akTop, akLeft, akRight, akBottom]
        BorderSpacing.Around = 6
        IntegralHeight = True
        Items.Strings = (
          '111'
          '222'
          '333'
          '44'
          '555'
          '666'
          '777'
        )
        ItemHeight = 0
        OnClick = ListBtnAvaliableClick
        OnDblClick = ListBtnVisibleDblClick
        OnDrawItem = ListBox1DrawItem
        ScrollWidth = 300
        Style = lbOwnerDrawFixed
        TabOrder = 4
      end
      object ListBtnVisible: TListBox
        AnchorSideLeft.Control = btnUp
        AnchorSideLeft.Side = asrBottom
        AnchorSideTop.Control = Label2
        AnchorSideTop.Side = asrBottom
        AnchorSideRight.Control = btnRight2
        AnchorSideBottom.Control = cbShowCaption
        Left = 32
        Height = 266
        Top = 29
        Width = 275
        Anchors = [akTop, akLeft, akRight, akBottom]
        BorderSpacing.Around = 6
        DragMode = dmAutomatic
        ItemHeight = 0
        OnClick = ListBtnAvaliableClick
        OnDblClick = ListBtnVisibleDblClick
        OnDragDrop = ListBtnVisibleDragDrop
        OnDragOver = ListBtnVisibleDragOver
        OnDrawItem = ListBox1DrawItem
        ScrollWidth = 273
        Style = lbOwnerDrawFixed
        TabOrder = 5
        TopIndex = -1
      end
      object Panel1: TPanel
        AnchorSideBottom.Control = TabSheet1
        AnchorSideBottom.Side = asrBottom
        Left = 3
        Height = 62
        Top = 330
        Width = 635
        Alignment = taLeftJustify
        Anchors = [akLeft, akRight, akBottom]
        BorderSpacing.Around = 6
        BevelOuter = bvLowered
        FullRepaint = False
        TabOrder = 6
      end
      object cbShowCaption: TCheckBox
        AnchorSideLeft.Control = TabSheet1
        AnchorSideBottom.Control = Panel1
        Left = 6
        Height = 23
        Top = 301
        Width = 108
        Anchors = [akLeft, akBottom]
        BorderSpacing.Around = 6
        Caption = 'Show caption'
        OnChange = cbShowCaptionChange
        TabOrder = 7
      end
      object btnUp: TBitBtn
        Tag = -1
        AnchorSideLeft.Control = TabSheet1
        AnchorSideTop.Control = Label2
        AnchorSideTop.Side = asrBottom
        AnchorSideRight.Control = btnRight2
        AnchorSideRight.Side = asrBottom
        Left = 6
        Height = 20
        Top = 29
        Width = 20
        AutoSize = True
        BorderSpacing.Around = 6
        BorderSpacing.InnerBorder = 2
        OnClick = btnUpClick
        TabOrder = 8
      end
      object btnDown: TBitBtn
        Tag = 1
        AnchorSideLeft.Control = TabSheet1
        AnchorSideTop.Control = btnUp
        AnchorSideTop.Side = asrBottom
        AnchorSideRight.Control = btnRight2
        AnchorSideRight.Side = asrBottom
        Left = 6
        Height = 20
        Top = 55
        Width = 20
        AutoSize = True
        BorderSpacing.Around = 6
        BorderSpacing.InnerBorder = 2
        OnClick = btnUpClick
        TabOrder = 9
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Options'
      ClientHeight = 398
      ClientWidth = 647
      object cbShowHint: TCheckBox
        AnchorSideLeft.Control = TabSheet2
        AnchorSideTop.Control = cbTransp
        AnchorSideTop.Side = asrBottom
        Left = 6
        Height = 23
        Top = 169
        Width = 87
        BorderSpacing.Around = 6
        Caption = 'Show hint'
        TabOrder = 0
      end
      object cbTransp: TCheckBox
        AnchorSideLeft.Control = TabSheet2
        AnchorSideTop.Control = cbFlatBtn
        AnchorSideTop.Side = asrBottom
        Left = 6
        Height = 23
        Top = 140
        Width = 100
        BorderSpacing.Around = 6
        Caption = 'Transparent'
        TabOrder = 1
      end
      object cbFlatBtn: TCheckBox
        AnchorSideLeft.Control = TabSheet2
        AnchorSideTop.Control = RadioGroup1
        AnchorSideTop.Side = asrBottom
        Left = 6
        Height = 23
        Top = 111
        Width = 100
        BorderSpacing.Around = 6
        Caption = 'Flat buttons'
        TabOrder = 2
      end
      object RadioGroup1: TRadioGroup
        AnchorSideLeft.Control = Panel2
        AnchorSideLeft.Side = asrBottom
        AnchorSideTop.Control = TabSheet2
        AnchorSideRight.Control = TabSheet2
        AnchorSideRight.Side = asrBottom
        Left = 331
        Height = 99
        Top = 6
        Width = 310
        Anchors = [akTop, akLeft, akRight]
        AutoFill = False
        AutoSize = True
        BorderSpacing.Around = 6
        Caption = 'Button align'
        ChildSizing.LeftRightSpacing = 6
        ChildSizing.TopBottomSpacing = 6
        ChildSizing.ShrinkHorizontal = crsScaleChilds
        ChildSizing.ShrinkVertical = crsScaleChilds
        ChildSizing.Layout = cclLeftToRightThenTopToBottom
        ChildSizing.ControlsPerLine = 1
        ClientHeight = 81
        ClientWidth = 308
        Items.Strings = (
          'None'
          'Left'
          'Rignt'
        )
        TabOrder = 3
        TabStop = True
      end
      object RadioGroup2: TRadioGroup
        AnchorSideLeft.Control = TabSheet2
        AnchorSideTop.Control = TabSheet2
        AnchorSideRight.Control = Panel2
        Left = 6
        Height = 99
        Top = 6
        Width = 310
        Anchors = [akTop, akLeft, akRight]
        AutoFill = True
        AutoSize = True
        BorderSpacing.Around = 6
        Caption = 'Tool bar style'
        ChildSizing.LeftRightSpacing = 6
        ChildSizing.TopBottomSpacing = 6
        ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
        ChildSizing.EnlargeVertical = crsHomogenousChildResize
        ChildSizing.ShrinkHorizontal = crsScaleChilds
        ChildSizing.ShrinkVertical = crsScaleChilds
        ChildSizing.Layout = cclLeftToRightThenTopToBottom
        ChildSizing.ControlsPerLine = 1
        ClientHeight = 81
        ClientWidth = 308
        Items.Strings = (
          'Standart'
          'Windows XP'
          'Native'
        )
        TabOrder = 4
        TabStop = True
      end
      object Panel2: TPanel
        AnchorSideLeft.Control = TabSheet2
        AnchorSideLeft.Side = asrCenter
        AnchorSideTop.Control = TabSheet2
        AnchorSideBottom.Control = TabSheet2
        AnchorSideBottom.Side = asrBottom
        Left = 322
        Height = 386
        Top = 6
        Width = 3
        Anchors = [akTop, akLeft, akBottom]
        BorderSpacing.Around = 6
        TabOrder = 5
      end
    end
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 46
    Top = 435
    Width = 645
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 1
    ShowButtons = [pbClose, pbHelp]
  end
end
