object RxDBGridFooterTools_SetupForm: TRxDBGridFooterTools_SetupForm
  Left = 86
  Height = 290
  Top = 86
  Width = 341
  Caption = 'Setup footer row'
  ClientHeight = 290
  ClientWidth = 341
  OnCreate = FormCreate
  Position = poScreenCenter
  ShowHint = True
  LCLVersion = '6.7'
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 34
    Top = 250
    Width = 329
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
  object PageControl1: TPageControl
    Left = 0
    Height = 244
    Top = 0
    Width = 341
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Functions'
      ClientHeight = 216
      ClientWidth = 333
      object StringGrid1: TStringGrid
        Left = 0
        Height = 216
        Top = 0
        Width = 333
        Align = alClient
        AutoFillColumns = True
        ColCount = 2
        Columns = <        
          item
            ReadOnly = True
            Title.Alignment = taCenter
            Title.Caption = 'Collumn name'
            Width = 164
          end        
          item
            PickList.Strings = (
              'fvtNon'
              'fvtSum'
              'fvtAvg'
              'fvtCount'
              'fvtFieldValue'
              'fvtStaticText'
              'fvtMax'
              'fvtMin'
              'fvtRecNo'
            )
            Title.Alignment = taCenter
            Title.Caption = 'Function'
            Width = 165
          end>
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goSmoothScroll]
        TabOrder = 0
        TitleStyle = tsNative
        ColWidths = (
          164
          165
        )
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Other options'
      ClientHeight = 203
      ClientWidth = 331
      object Label1: TLabel
        AnchorSideLeft.Control = TabSheet2
        AnchorSideTop.Control = TabSheet2
        Left = 6
        Height = 19
        Top = 6
        Width = 109
        BorderSpacing.Around = 6
        Caption = 'Footer row color'
        ParentColor = False
      end
      object ColorBox1: TColorBox
        AnchorSideLeft.Control = Label1
        AnchorSideTop.Control = Label1
        AnchorSideTop.Side = asrBottom
        AnchorSideRight.Control = TabSheet2
        AnchorSideRight.Side = asrBottom
        Left = 12
        Height = 24
        Top = 31
        Width = 313
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
        Anchors = [akTop, akLeft, akRight]
        BorderSpacing.Around = 6
        ItemHeight = 16
        TabOrder = 0
      end
    end
  end
end
