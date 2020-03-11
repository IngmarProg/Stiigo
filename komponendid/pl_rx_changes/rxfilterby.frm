object rxFilterByForm: TrxFilterByForm
  Left = 86
  Height = 498
  Top = 86
  Width = 644
  Caption = 'Filter conditions'
  ClientHeight = 498
  ClientWidth = 644
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '6.7'
  object Label1: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Owner
    Left = 6
    Height = 15
    Top = 6
    Width = 176
    BorderSpacing.Around = 6
    Caption = 'Select filter expression for data'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Label1
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 15
    Top = 27
    Width = 47
    BorderSpacing.Around = 6
    Caption = 'On field:'
    Font.Color = clRed
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label3: TLabel
    AnchorSideTop.Control = Label1
    AnchorSideTop.Side = asrBottom
    Left = 168
    Height = 15
    Top = 27
    Width = 62
    BorderSpacing.Around = 6
    Caption = 'Operation :'
    Font.Color = clRed
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label4: TLabel
    AnchorSideTop.Control = Label1
    AnchorSideTop.Side = asrBottom
    Left = 271
    Height = 15
    Top = 27
    Width = 64
    BorderSpacing.Around = 6
    Caption = 'Conditions :'
    Font.Color = clRed
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label5: TLabel
    AnchorSideLeft.Control = ComboBox3
    AnchorSideTop.Control = Label1
    AnchorSideTop.Side = asrBottom
    Left = 533
    Height = 15
    Top = 27
    Width = 54
    BorderSpacing.Around = 6
    Caption = 'Operand :'
    Font.Color = clRed
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label6: TLabel
    AnchorSideLeft.Control = ComboBox3
    AnchorSideTop.Side = asrBottom
    AnchorSideBottom.Control = ComboBox25
    AnchorSideBottom.Side = asrBottom
    Left = 527
    Height = 15
    Top = 304
    Width = 23
    Anchors = [akLeft, akBottom]
    Caption = 'End.'
    Font.Color = clRed
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object ComboBox1: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = Label2
    AnchorSideTop.Side = asrBottom
    Left = 6
    Height = 23
    Top = 48
    Width = 153
    BorderSpacing.Around = 6
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 0
  end
  object ComboBox2: TComboBox
    AnchorSideTop.Control = Label2
    AnchorSideTop.Side = asrBottom
    Left = 168
    Height = 23
    Top = 48
    Width = 96
    BorderSpacing.Around = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 1
  end
  object ComboBox3: TComboBox
    AnchorSideTop.Control = Label2
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 527
    Height = 23
    Top = 48
    Width = 111
    Anchors = [akTop, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 2
  end
  object ComboBox4: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox1
    AnchorSideRight.Side = asrBottom
    Left = 8
    Height = 23
    Top = 79
    Width = 149
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Around = 2
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 3
  end
  object ComboBox5: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideTop.Control = ComboBox1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox2
    AnchorSideRight.Side = asrBottom
    Left = 168
    Height = 23
    Top = 77
    Width = 96
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Top = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 4
  end
  object ComboBox6: TComboBox
    AnchorSideTop.Control = ComboBox1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 527
    Height = 23
    Top = 77
    Width = 111
    Anchors = [akTop, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 5
  end
  object ComboBox7: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox4
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox1
    AnchorSideRight.Side = asrBottom
    Left = 8
    Height = 23
    Top = 110
    Width = 149
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Around = 2
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 6
  end
  object ComboBox8: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideTop.Control = ComboBox4
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox2
    AnchorSideRight.Side = asrBottom
    Left = 168
    Height = 23
    Top = 108
    Width = 96
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Top = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 7
  end
  object ComboBox9: TComboBox
    AnchorSideTop.Control = ComboBox4
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 527
    Height = 23
    Top = 108
    Width = 111
    Anchors = [akTop, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 8
  end
  object ComboBox10: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox7
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox1
    AnchorSideRight.Side = asrBottom
    Left = 8
    Height = 23
    Top = 141
    Width = 149
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Around = 2
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 9
  end
  object ComboBox11: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideTop.Control = ComboBox7
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox2
    AnchorSideRight.Side = asrBottom
    Left = 168
    Height = 23
    Top = 139
    Width = 96
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Top = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 10
  end
  object ComboBox12: TComboBox
    AnchorSideTop.Control = ComboBox7
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 527
    Height = 23
    Top = 139
    Width = 111
    Anchors = [akTop, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 11
  end
  object ComboBox13: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox10
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox1
    AnchorSideRight.Side = asrBottom
    Left = 8
    Height = 23
    Top = 172
    Width = 149
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Around = 2
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 12
  end
  object ComboBox14: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideTop.Control = ComboBox10
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox2
    AnchorSideRight.Side = asrBottom
    Left = 168
    Height = 23
    Top = 170
    Width = 96
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Top = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 13
  end
  object ComboBox15: TComboBox
    AnchorSideTop.Control = ComboBox10
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 527
    Height = 23
    Top = 170
    Width = 111
    Anchors = [akTop, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 14
  end
  object ComboBox16: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox13
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox1
    AnchorSideRight.Side = asrBottom
    Left = 8
    Height = 23
    Top = 203
    Width = 149
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Around = 2
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 15
  end
  object ComboBox17: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideTop.Control = ComboBox13
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox2
    AnchorSideRight.Side = asrBottom
    Left = 168
    Height = 23
    Top = 201
    Width = 96
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Top = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 16
  end
  object ComboBox18: TComboBox
    AnchorSideTop.Control = ComboBox13
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 527
    Height = 23
    Top = 201
    Width = 111
    Anchors = [akTop, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 17
  end
  object ComboBox19: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox16
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox1
    AnchorSideRight.Side = asrBottom
    Left = 8
    Height = 23
    Top = 234
    Width = 149
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Around = 2
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 18
  end
  object ComboBox20: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideTop.Control = ComboBox16
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox2
    AnchorSideRight.Side = asrBottom
    Left = 168
    Height = 23
    Top = 232
    Width = 96
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Top = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 19
  end
  object ComboBox21: TComboBox
    AnchorSideTop.Control = ComboBox16
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 527
    Height = 23
    Top = 232
    Width = 111
    Anchors = [akTop, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 20
  end
  object ComboBox22: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox19
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox1
    AnchorSideRight.Side = asrBottom
    Left = 8
    Height = 23
    Top = 265
    Width = 149
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Around = 2
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 21
  end
  object ComboBox23: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideTop.Control = ComboBox19
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox2
    AnchorSideRight.Side = asrBottom
    Left = 168
    Height = 23
    Top = 263
    Width = 96
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Top = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 22
  end
  object ComboBox24: TComboBox
    AnchorSideTop.Control = ComboBox19
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 527
    Height = 23
    Top = 263
    Width = 111
    Anchors = [akTop, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 23
  end
  object ComboBox25: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = ComboBox22
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox1
    AnchorSideRight.Side = asrBottom
    Left = 8
    Height = 23
    Top = 296
    Width = 149
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    BorderSpacing.Around = 2
    ItemHeight = 15
    Style = csDropDownList
    TabOrder = 24
  end
  object ComboBox26: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideTop.Control = ComboBox22
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox2
    AnchorSideRight.Side = asrBottom
    Left = 168
    Height = 23
    Top = 294
    Width = 96
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Top = 6
    DropDownCount = 9
    ItemHeight = 15
    OnChange = ComboBoxChange
    Style = csDropDownList
    TabOrder = 25
  end
  object ComboBox27: TComboBox
    AnchorSideLeft.Control = Owner
    AnchorSideBottom.Control = Owner
    AnchorSideBottom.Side = asrBottom
    Left = 6
    Height = 23
    Top = 469
    Width = 58
    Anchors = [akLeft, akBottom]
    BorderSpacing.Around = 6
    ItemHeight = 15
    Items.Strings = (
      'And'
      'Or'
    )
    Style = csDropDownList
    TabOrder = 26
    Visible = False
  end
  object Button1: TButton
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = Owner
    AnchorSideBottom.Side = asrBottom
    Left = 581
    Height = 25
    Top = 467
    Width = 57
    Anchors = [akRight, akBottom]
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Apply'
    Default = True
    OnClick = Button1Click
    TabOrder = 27
  end
  object Button2: TButton
    AnchorSideRight.Control = Button1
    AnchorSideBottom.Control = Owner
    AnchorSideBottom.Side = asrBottom
    Left = 513
    Height = 25
    Top = 467
    Width = 62
    Anchors = [akRight, akBottom]
    AutoSize = True
    BorderSpacing.Around = 6
    Cancel = True
    Caption = 'Cancel'
    OnClick = Button2Click
    TabOrder = 28
  end
  object Button3: TButton
    AnchorSideRight.Control = Button2
    AnchorSideBottom.Control = Owner
    AnchorSideBottom.Side = asrBottom
    Left = 427
    Height = 25
    Top = 467
    Width = 80
    Anchors = [akRight, akBottom]
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Clear filter'
    OnClick = Button3Click
    TabOrder = 29
  end
  object Edit1: TComboBox
    AnchorSideTop.Control = Label2
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 271
    Height = 23
    Top = 48
    Width = 250
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 30
  end
  object Edit2: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 270
    Height = 23
    Top = 77
    Width = 251
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 31
  end
  object Edit3: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox4
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 270
    Height = 23
    Top = 108
    Width = 251
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 32
  end
  object Edit4: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox7
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 270
    Height = 23
    Top = 139
    Width = 251
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 33
  end
  object Edit5: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox10
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 270
    Height = 23
    Top = 170
    Width = 251
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 34
  end
  object Edit6: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox13
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 270
    Height = 23
    Top = 201
    Width = 251
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 35
  end
  object Edit7: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox16
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 270
    Height = 23
    Top = 232
    Width = 251
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 36
  end
  object Edit8: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox19
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 270
    Height = 23
    Top = 263
    Width = 251
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 37
  end
  object Edit9: TComboBox
    AnchorSideLeft.Control = ComboBox2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = ComboBox22
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = ComboBox3
    Left = 270
    Height = 23
    Top = 294
    Width = 251
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 6
    BorderSpacing.Top = 6
    ItemHeight = 15
    OnChange = EditChange
    TabOrder = 38
  end
end
