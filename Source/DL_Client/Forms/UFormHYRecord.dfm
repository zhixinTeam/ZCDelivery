object fFormHYRecord: TfFormHYRecord
  Left = 988
  Top = 214
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 591
  ClientWidth = 587
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 120
  TextHeight = 15
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 587
    Height = 591
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlTabOrders = False
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 392
      Top = 549
      Width = 88
      Height = 28
      Caption = #20445#23384
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 485
      Top = 549
      Width = 88
      Height = 28
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BtnExitClick
    end
    object EditID: TcxButtonEdit
      Left = 87
      Top = 45
      Hint = 'E.R_SerialNo'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 2
      Width = 152
    end
    object EditStock: TcxComboBox
      Left = 87
      Top = 73
      Hint = 'E.R_PID'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      Properties.OnEditValueChanged = EditStockPropertiesEditValueChanged
      TabOrder = 4
      Width = 160
    end
    object wPanel: TPanel
      Left = 29
      Top = 169
      Width = 519
      Height = 327
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 3
      object Label17: TLabel
        Left = 8
        Top = 316
        Width = 91
        Height = 15
        Caption = '3'#22825#25239#21387#24378#24230':'
        Transparent = True
      end
      object Label18: TLabel
        Left = 8
        Top = 278
        Width = 91
        Height = 15
        Caption = '3'#22825#25239#25240#24378#24230':'
        Transparent = True
      end
      object Label25: TLabel
        Left = 256
        Top = 316
        Width = 99
        Height = 15
        Caption = '28'#22825#25239#21387#24378#24230':'
        Transparent = True
      end
      object Label26: TLabel
        Left = 256
        Top = 278
        Width = 99
        Height = 15
        Caption = '28'#22825#25239#25240#24378#24230':'
        Transparent = True
      end
      object Bevel2: TBevel
        Left = 8
        Top = 256
        Width = 500
        Height = 9
        Shape = bsBottomLine
      end
      object Label19: TLabel
        Left = 3
        Top = 136
        Width = 69
        Height = 15
        Caption = #30897' '#21547' '#37327':'
        Transparent = True
      end
      object Label20: TLabel
        Left = 180
        Top = 39
        Width = 69
        Height = 15
        Caption = #19981' '#28342' '#29289':'
        Transparent = True
      end
      object Label21: TLabel
        Left = 3
        Top = 169
        Width = 70
        Height = 15
        Caption = #31264'    '#24230':'
        Transparent = True
      end
      object Label22: TLabel
        Left = 3
        Top = 104
        Width = 70
        Height = 15
        Caption = #32454'    '#24230':'
        Transparent = True
      end
      object Label23: TLabel
        Left = 3
        Top = 234
        Width = 69
        Height = 15
        Caption = #27695' '#31163' '#23376':'
        Transparent = True
      end
      object Label24: TLabel
        Left = 3
        Top = 6
        Width = 69
        Height = 15
        Caption = #27687' '#21270' '#38209':'
        Transparent = True
      end
      object Label27: TLabel
        Left = 180
        Top = 71
        Width = 68
        Height = 15
        Caption = #21021#20957#26102#38388':'
        Transparent = True
      end
      object Label28: TLabel
        Left = 180
        Top = 104
        Width = 68
        Height = 15
        Caption = #32456#20957#26102#38388':'
        Transparent = True
      end
      object Label29: TLabel
        Left = 180
        Top = 6
        Width = 68
        Height = 15
        Caption = #27604#34920#38754#31215':'
        Transparent = True
      end
      object Label30: TLabel
        Left = 180
        Top = 136
        Width = 69
        Height = 15
        Caption = #23433' '#23450' '#24615':'
        Transparent = True
      end
      object Label31: TLabel
        Left = 3
        Top = 39
        Width = 68
        Height = 15
        Caption = #19977#27687#21270#30827':'
      end
      object Label32: TLabel
        Left = 3
        Top = 71
        Width = 69
        Height = 15
        Caption = #28903' '#22833' '#37327':'
      end
      object Label34: TLabel
        Left = 3
        Top = 200
        Width = 69
        Height = 15
        Caption = #28216' '#31163' '#38041':'
        Transparent = True
      end
      object Label38: TLabel
        Left = 180
        Top = 234
        Width = 69
        Height = 15
        Caption = #30789' '#37240' '#30416':'
        Transparent = True
      end
      object Label39: TLabel
        Left = 180
        Top = 200
        Width = 69
        Height = 15
        Caption = #38041' '#30789' '#27604':'
        Transparent = True
      end
      object Label40: TLabel
        Left = 180
        Top = 168
        Width = 69
        Height = 15
        Caption = #20445' '#27700' '#29575':'
        Transparent = True
      end
      object Label41: TLabel
        Left = 365
        Top = 6
        Width = 68
        Height = 15
        Caption = #30707#33167#31181#31867':'
        Transparent = True
      end
      object Label42: TLabel
        Left = 365
        Top = 39
        Width = 69
        Height = 15
        Caption = #30707' '#33167' '#37327':'
      end
      object Label43: TLabel
        Left = 365
        Top = 71
        Width = 68
        Height = 15
        Caption = #28151#21512#26448#31867':'
      end
      object Label44: TLabel
        Left = 365
        Top = 104
        Width = 68
        Height = 15
        Caption = #28151#21512#26448#37327':'
        Transparent = True
      end
      object cxTextEdit29: TcxTextEdit
        Left = 95
        Top = 271
        Hint = 'E.R_3DZhe1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 16
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit30: TcxTextEdit
        Left = 95
        Top = 303
        Hint = 'E.R_3DYa1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 19
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit31: TcxTextEdit
        Left = 355
        Top = 271
        Hint = 'E.R_28Zhe1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 25
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit32: TcxTextEdit
        Left = 355
        Top = 303
        Hint = 'E.R_28Ya1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 28
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit33: TcxTextEdit
        Left = 405
        Top = 271
        Hint = 'E.R_28Zhe2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 26
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit34: TcxTextEdit
        Left = 454
        Top = 271
        Hint = 'E.R_28Zhe3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 27
        OnKeyPress = cxTextEdit17KeyPress
        Width = 52
      end
      object cxTextEdit35: TcxTextEdit
        Left = 405
        Top = 303
        Hint = 'E.R_28Ya2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 29
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit36: TcxTextEdit
        Left = 454
        Top = 303
        Hint = 'E.R_28Ya3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 30
        OnKeyPress = cxTextEdit17KeyPress
        Width = 52
      end
      object cxTextEdit37: TcxTextEdit
        Left = 145
        Top = 271
        Hint = 'E.R_3DZhe2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 17
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit38: TcxTextEdit
        Left = 145
        Top = 303
        Hint = 'E.R_3DYa2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 20
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit39: TcxTextEdit
        Left = 195
        Top = 271
        Hint = 'E.R_3DZhe3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 18
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit40: TcxTextEdit
        Left = 195
        Top = 303
        Hint = 'E.R_3DYa3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 21
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit41: TcxTextEdit
        Left = 95
        Top = 324
        Hint = 'E.R_3DYa4'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 22
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit42: TcxTextEdit
        Left = 145
        Top = 324
        Hint = 'E.R_3DYa5'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 23
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit43: TcxTextEdit
        Left = 195
        Top = 324
        Hint = 'E.R_3DYa6'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 24
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit47: TcxTextEdit
        Left = 355
        Top = 324
        Hint = 'E.R_28Ya4'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 31
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit48: TcxTextEdit
        Left = 405
        Top = 324
        Hint = 'E.R_28Ya5'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 32
        OnKeyPress = cxTextEdit17KeyPress
        Width = 53
      end
      object cxTextEdit49: TcxTextEdit
        Left = 454
        Top = 324
        Hint = 'E.R_28Ya6'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 33
        OnKeyPress = cxTextEdit17KeyPress
        Width = 52
      end
      object cxTextEdit17: TcxTextEdit
        Left = 75
        Top = 0
        Hint = 'E.R_MgO'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 0
        OnKeyPress = cxTextEdit17KeyPress
        Width = 93
      end
      object cxTextEdit18: TcxTextEdit
        Left = 75
        Top = 225
        Hint = 'E.R_CL'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 7
        OnKeyPress = cxTextEdit17KeyPress
        Width = 93
      end
      object cxTextEdit19: TcxTextEdit
        Left = 75
        Top = 98
        Hint = 'E.R_XiDu'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 3
        OnKeyPress = cxTextEdit17KeyPress
        Width = 93
      end
      object cxTextEdit20: TcxTextEdit
        Left = 75
        Top = 163
        Hint = 'E.R_ChouDu'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 5
        OnKeyPress = cxTextEdit17KeyPress
        Width = 93
      end
      object cxTextEdit21: TcxTextEdit
        Left = 255
        Top = 33
        Hint = 'E.R_BuRong'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 9
        OnKeyPress = cxTextEdit17KeyPress
        Width = 94
      end
      object cxTextEdit22: TcxTextEdit
        Left = 75
        Top = 130
        Hint = 'E.R_Jian'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 4
        OnKeyPress = cxTextEdit17KeyPress
        Width = 93
      end
      object cxTextEdit23: TcxTextEdit
        Left = 75
        Top = 33
        Hint = 'E.R_SO3'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 1
        OnKeyPress = cxTextEdit17KeyPress
        Width = 93
      end
      object cxTextEdit24: TcxTextEdit
        Left = 75
        Top = 65
        Hint = 'E.R_ShaoShi'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 2
        OnKeyPress = cxTextEdit17KeyPress
        Width = 93
      end
      object cxTextEdit25: TcxTextEdit
        Left = 255
        Top = 130
        Hint = 'E.R_AnDing'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 12
        OnKeyPress = cxTextEdit17KeyPress
        Width = 94
      end
      object cxTextEdit26: TcxTextEdit
        Left = 255
        Top = 0
        Hint = 'E.R_BiBiao'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 8
        OnKeyPress = cxTextEdit17KeyPress
        Width = 94
      end
      object cxTextEdit27: TcxTextEdit
        Left = 255
        Top = 98
        Hint = 'E.R_ZhongNing'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 11
        OnKeyPress = cxTextEdit17KeyPress
        Width = 94
      end
      object cxTextEdit28: TcxTextEdit
        Left = 255
        Top = 65
        Hint = 'E.R_ChuNing'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 10
        OnKeyPress = cxTextEdit17KeyPress
        Width = 94
      end
      object cxTextEdit45: TcxTextEdit
        Left = 75
        Top = 194
        Hint = 'E.R_YLiGai'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 6
        OnKeyPress = cxTextEdit17KeyPress
        Width = 93
      end
      object cxTextEdit52: TcxTextEdit
        Left = 255
        Top = 228
        Hint = 'E.R_KuangWu'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 15
        OnKeyPress = cxTextEdit17KeyPress
        Width = 94
      end
      object cxTextEdit53: TcxTextEdit
        Left = 255
        Top = 194
        Hint = 'E.R_GaiGui'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 14
        OnKeyPress = cxTextEdit17KeyPress
        Width = 94
      end
      object cxTextEdit54: TcxTextEdit
        Left = 255
        Top = 161
        Hint = 'E.R_Water'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 13
        OnKeyPress = cxTextEdit17KeyPress
        Width = 94
      end
      object cxTextEdit55: TcxTextEdit
        Left = 435
        Top = 0
        Hint = 'E.R_SGType'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 34
        Width = 94
      end
      object cxTextEdit56: TcxTextEdit
        Left = 435
        Top = 33
        Hint = 'E.R_SGValue'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 35
        Width = 94
      end
      object cxTextEdit57: TcxTextEdit
        Left = 435
        Top = 65
        Hint = 'E.R_HHCType'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 36
        Width = 94
      end
      object cxTextEdit58: TcxTextEdit
        Left = 435
        Top = 98
        Hint = 'E.R_HHCValue'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 37
        Width = 94
      end
    end
    object EditDate: TcxDateEdit
      Left = 87
      Top = 101
      Hint = 'E.R_Date'
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 5
      Width = 194
    end
    object EditMan: TcxTextEdit
      Left = 332
      Top = 101
      Hint = 'E.R_Man'
      ParentFont = False
      TabOrder = 6
      Width = 151
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #22522#26412#20449#24687
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #27700#27877#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item12: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #25152#23646#21697#31181':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item2: TdxLayoutItem
            Caption = #21462#26679#26085#26399':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #24405#20837#20154':'
            Control = EditMan
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #26816#39564#25968#25454
        object dxLayoutControl1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'Panel1'
          ShowCaption = False
          Control = wPanel
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item10: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button3'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item11: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button4'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
