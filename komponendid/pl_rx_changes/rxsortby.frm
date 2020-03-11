object rxSortByForm: TrxSortByForm
  Left = 450
  Height = 398
  Top = 243
  Width = 684
  ActiveControl = AddBtn
  Caption = 'Sort by fields'
  ClientHeight = 398
  ClientWidth = 684
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '6.1'
  object Label1: TLabel
    AnchorSideLeft.Control = AddBtn
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = Owner
    Left = 421
    Height = 20
    Top = 6
    Width = 113
    BorderSpacing.Around = 6
    Caption = '&Fields for sorting:'
    FocusControl = ListBox1
    ParentColor = False
  end
  object Label2: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Owner
    Left = 6
    Height = 20
    Top = 6
    Width = 60
    BorderSpacing.Around = 6
    Caption = '&All fields:'
    FocusControl = ListBox2
    ParentColor = False
  end
  object ListBox2: TListBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Label2
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = AddBtn
    AnchorSideBottom.Control = CheckBox1
    Left = 6
    Height = 282
    Top = 32
    Width = 258
    Anchors = [akTop, akLeft, akRight, akBottom]
    BorderSpacing.Around = 6
    ItemHeight = 0
    OnDblClick = ListBox2DblClick
    ScrollWidth = 256
    TabOrder = 0
    TopIndex = -1
  end
  object RemoveBtn: TBitBtn
    AnchorSideLeft.Control = AddBtn
    AnchorSideTop.Control = AddBtn
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = AddBtn
    AnchorSideRight.Side = asrBottom
    Left = 270
    Height = 35
    Top = 73
    Width = 145
    Anchors = [akTop, akLeft, akRight]
    AutoSize = True
    BorderSpacing.Top = 6
    Caption = '&Remove'
    Glyph.Data = {
      8A010000424D8A01000000000000760000002800000018000000170000000100
      0400000000001401000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      C80000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777777777777777777777877777777777777777777770077777777777777
      7777777090777777777777777777770990777777777777777777709990777777
      7777777777770999907777777777777777709999900000008777777777099999
      999999990777777770999999999999990777777709999999999999990777777F
      999999999999999907777777F999999999999999077777777F99999999999999
      0777777777F999999999999907777777777F999998FFFFFF877777777777F999
      987777777777777777777F999877777777777777777777F99877777777777777
      7777777F987777777777777777777777F877777777777777777777777F777777
      7777777777777777777777777777
    }
    OnClick = RemoveBtnClick
    TabOrder = 2
  end
  object UpBtn: TBitBtn
    AnchorSideLeft.Control = AddBtn
    AnchorSideTop.Control = RemoveBtn
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = AddBtn
    AnchorSideRight.Side = asrBottom
    Left = 270
    Height = 36
    Top = 114
    Width = 145
    Anchors = [akTop, akLeft, akRight]
    AutoSize = True
    BorderSpacing.Top = 6
    Caption = 'M&ove up'
    Glyph.Data = {
      96010000424D9601000000000000760000002800000017000000180000000100
      0400000000002001000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      C80000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777777707777777777777777777777707777777777777777777777707777
      77780000000877777770777777709999999F77777770777777709999999F7777
      7770777777709999999F77777770777777709999999F77777770777777709999
      999F77777770777777709999999F77777770780000009999999888888F707709
      9999999999999999F7707770999999999999999F7770777709999999999999F7
      777077777099999999999F7777707777770999999999F7777770777777709999
      999F7777777077777777099999F7777777707777777770999F77777777707777
      77777709F7777777777077777777777F77777777777077777777777777777777
      7770777777777777777777777770777777777777777777777770
    }
    OnClick = UpBtnClick
    TabOrder = 3
  end
  object DownBtn: TBitBtn
    AnchorSideLeft.Control = AddBtn
    AnchorSideTop.Control = UpBtn
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = AddBtn
    AnchorSideRight.Side = asrBottom
    Left = 270
    Height = 36
    Top = 156
    Width = 145
    Anchors = [akTop, akLeft, akRight]
    AutoSize = True
    BorderSpacing.Top = 6
    Caption = '&Move down'
    Glyph.Data = {
      96010000424D9601000000000000760000002800000017000000180000000100
      0400000000002001000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      C80000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777777707777777777777777777777707777777777777777777777707777
      7777777F777777777770777777777709F777777777707777777770999F777777
      777077777777099999F777777770777777709999999F77777770777777099999
      9999F777777077777099999999999F777770777709999999999999F777707770
      999999999999999F777077099999999999999999F77078000000999999988888
      8F70777777709999999F77777770777777709999999F77777770777777709999
      999F77777770777777709999999F77777770777777709999999F777777707777
      77709999999F7777777077777778000000087777777077777777777777777777
      7770777777777777777777777770777777777777777777777770
    }
    OnClick = DownBtnClick
    TabOrder = 4
  end
  object ListBox1: TListBox
    AnchorSideLeft.Control = AddBtn
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = Label1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = CheckBox1
    Left = 421
    Height = 282
    Top = 32
    Width = 257
    Anchors = [akTop, akLeft, akRight, akBottom]
    BorderSpacing.Around = 6
    ItemHeight = 0
    OnDblClick = SpeedButton1Click
    OnDrawItem = ListBox1DrawItem
    ScrollWidth = 255
    Style = lbOwnerDrawFixed
    TabOrder = 5
    TopIndex = -1
  end
  object AddBtn: TBitBtn
    AnchorSideLeft.Control = Owner
    AnchorSideLeft.Side = asrCenter
    AnchorSideTop.Control = ListBox1
    Left = 270
    Height = 35
    Top = 32
    Width = 145
    AutoSize = True
    Caption = '&Add field to sort'
    Glyph.Data = {
      8A010000424D8A01000000000000760000002800000018000000170000000100
      0400000000001401000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      C80000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777777777777777777877777777777777777777777007777777777777777
      7777770907777777777777777777770990777777777777777777770999077777
      7777777777777709999077777777777800000009999907777777777099999999
      9999907777777770999999999999990777777770999999999999999077777770
      9999999999999999F7777770999999999999999F7777777099999999999999F7
      777777709999999999999F7777777778FFFFFF899999F7777777777777777789
      999F7777777777777777778999F7777777777777777777899F77777777777777
      77777789F7777777777777777777778F7777777777777777777777F777777777
      7777777777777777777777777777
    }
    Layout = blGlyphRight
    OnClick = AddBtnClick
    TabOrder = 1
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 42
    Top = 350
    Width = 672
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 6
    ShowButtons = [pbOK, pbCancel, pbHelp]
  end
  object CheckBox1: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Side = asrBottom
    AnchorSideBottom.Control = ButtonPanel1
    Left = 6
    Height = 24
    Top = 320
    Width = 158
    Anchors = [akLeft, akBottom]
    BorderSpacing.Around = 6
    Caption = 'Case insensitive sort'
    Enabled = False
    TabOrder = 7
  end
end
