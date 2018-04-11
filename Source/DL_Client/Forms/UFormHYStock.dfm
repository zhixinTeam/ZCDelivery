object fFormHYStock: TfFormHYStock
  Left = 351
  Top = 99
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 515
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 480
    Height = 515
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 324
      Top = 482
      Width = 70
      Height = 22
      Caption = #20445#23384
      TabOrder = 7
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 399
      Top = 482
      Width = 70
      Height = 22
      Caption = #21462#28040
      TabOrder = 8
      OnClick = BtnExitClick
    end
    object EditID: TcxButtonEdit
      Left = 81
      Top = 36
      Hint = 'T.P_ID'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      Width = 121
    end
    object EditStock: TcxComboBox
      Left = 81
      Top = 61
      Hint = 'T.P_Stock'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 10
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      Properties.OnEditValueChanged = EditStockPropertiesEditValueChanged
      TabOrder = 1
      Width = 185
    end
    object EditMemo: TcxMemo
      Left = 81
      Top = 111
      Hint = 'T.P_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      TabOrder = 5
      Height = 35
      Width = 331
    end
    object EditType: TcxComboBox
      Left = 329
      Top = 61
      Hint = 'T.P_Type'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'D=D'#12289#34955#35013
        'S=S'#12289#25955#35013)
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 125
    end
    object EditName: TcxTextEdit
      Left = 81
      Top = 86
      Hint = 'T.P_Name'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 3
      Width = 185
    end
    object wPage: TcxPageControl
      Left = 11
      Top = 158
      Width = 428
      Height = 288
      ActivePage = Sheet2
      ParentColor = False
      ShowFrame = True
      Style = 9
      TabOrder = 6
      TabSlants.Kind = skCutCorner
      ClientRectBottom = 287
      ClientRectLeft = 1
      ClientRectRight = 427
      ClientRectTop = 19
      object Sheet1: TcxTabSheet
        Caption = #22269#26631#21442#25968
        ImageIndex = 0
        object Label1: TLabel
          Left = 12
          Top = 255
          Width = 72
          Height = 12
          Caption = '3'#22825#25239#21387#24378#24230':'
          Transparent = True
        end
        object Label2: TLabel
          Left = 12
          Top = 233
          Width = 72
          Height = 12
          Caption = '3'#22825#25239#25240#24378#24230':'
          Transparent = True
        end
        object Label3: TLabel
          Left = 12
          Top = 117
          Width = 54
          Height = 12
          Caption = #30897' '#21547' '#37327':'
          Transparent = True
        end
        object Label4: TLabel
          Left = 165
          Top = 39
          Width = 54
          Height = 12
          Caption = #19981' '#28342' '#29289':'
          Transparent = True
        end
        object Label5: TLabel
          Left = 12
          Top = 143
          Width = 54
          Height = 12
          Caption = #31264'    '#24230':'
          Transparent = True
        end
        object Label6: TLabel
          Left = 12
          Top = 91
          Width = 54
          Height = 12
          Caption = #32454'    '#24230':'
          Transparent = True
        end
        object Label7: TLabel
          Left = 13
          Top = 195
          Width = 54
          Height = 12
          Caption = #27695' '#31163' '#23376':'
          Transparent = True
        end
        object Label8: TLabel
          Left = 12
          Top = 13
          Width = 54
          Height = 12
          Caption = #27687' '#21270' '#38209':'
          Transparent = True
        end
        object Label9: TLabel
          Left = 231
          Top = 255
          Width = 78
          Height = 12
          Caption = '28'#22825#25239#21387#24378#24230':'
          Transparent = True
        end
        object Label10: TLabel
          Left = 231
          Top = 233
          Width = 78
          Height = 12
          Caption = '28'#22825#25239#25240#24378#24230':'
          Transparent = True
        end
        object Label11: TLabel
          Left = 165
          Top = 65
          Width = 54
          Height = 12
          Caption = #21021#20957#26102#38388':'
          Transparent = True
        end
        object Label12: TLabel
          Left = 165
          Top = 90
          Width = 54
          Height = 12
          Caption = #32456#20957#26102#38388':'
          Transparent = True
        end
        object Label13: TLabel
          Left = 165
          Top = 13
          Width = 54
          Height = 12
          Caption = #27604#34920#38754#31215':'
          Transparent = True
        end
        object Label14: TLabel
          Left = 165
          Top = 195
          Width = 54
          Height = 12
          Caption = #30789' '#37240' '#30416':'
          Transparent = True
        end
        object Label15: TLabel
          Left = 12
          Top = 39
          Width = 54
          Height = 12
          Caption = #19977#27687#21270#30827':'
        end
        object Label16: TLabel
          Left = 12
          Top = 65
          Width = 54
          Height = 12
          Caption = #28903' '#22833' '#37327':'
        end
        object Bevel1: TBevel
          Left = 12
          Top = 216
          Width = 420
          Height = 7
          Shape = bsBottomLine
        end
        object Label33: TLabel
          Left = 12
          Top = 168
          Width = 54
          Height = 12
          Caption = #28216' '#31163' '#38041':'
          Transparent = True
        end
        object Label35: TLabel
          Left = 165
          Top = 168
          Width = 54
          Height = 12
          Caption = #38041' '#30789' '#27604':'
          Transparent = True
        end
        object Label36: TLabel
          Left = 165
          Top = 142
          Width = 54
          Height = 12
          Caption = #20445' '#27700' '#29575':'
          Transparent = True
        end
        object Label37: TLabel
          Left = 165
          Top = 116
          Width = 54
          Height = 12
          Caption = #23433' '#23450' '#24615':'
          Transparent = True
        end
        object cxTextEdit2: TcxTextEdit
          Left = 67
          Top = 8
          Hint = 'T.P_MgO'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 0
          Text = #8804
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit3: TcxTextEdit
          Left = 68
          Top = 190
          Hint = 'T.P_CL'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 7
          Text = #8804
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit14: TcxTextEdit
          Left = 67
          Top = 86
          Hint = 'T.P_XiDu'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 3
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit16: TcxTextEdit
          Left = 67
          Top = 138
          Hint = 'T.P_ChouDu'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 5
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit15: TcxTextEdit
          Left = 220
          Top = 34
          Hint = 'T.P_BuRong'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 9
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit1: TcxTextEdit
          Left = 67
          Top = 112
          Hint = 'T.P_Jian'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 4
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit6: TcxTextEdit
          Left = 67
          Top = 34
          Hint = 'T.P_SO3'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 1
          Text = #8804
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit5: TcxTextEdit
          Left = 67
          Top = 60
          Hint = 'T.P_ShaoShi'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 2
          Text = #8804
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit13: TcxTextEdit
          Left = 220
          Top = 190
          Hint = 'T.P_KuangWu'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 15
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit7: TcxTextEdit
          Left = 220
          Top = 8
          Hint = 'T.P_BiBiao'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 8
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit4: TcxTextEdit
          Left = 220
          Top = 60
          Hint = 'T.P_ChuNing'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 10
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit8: TcxTextEdit
          Left = 220
          Top = 85
          Hint = 'T.P_ZhongNing'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 11
          Text = #8804
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit11: TcxTextEdit
          Left = 86
          Top = 230
          Hint = 'T.P_3DZhe'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 16
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 85
        end
        object cxTextEdit9: TcxTextEdit
          Left = 86
          Top = 252
          Hint = 'T.P_3DYa'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 17
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 85
        end
        object cxTextEdit12: TcxTextEdit
          Left = 310
          Top = 230
          Hint = 'T.P_28Zhe'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 18
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 85
        end
        object cxTextEdit10: TcxTextEdit
          Left = 310
          Top = 252
          Hint = 'T.P_28Ya'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 19
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 85
        end
        object cxTextEdit44: TcxTextEdit
          Left = 67
          Top = 163
          Hint = 'T.P_YLiGai'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 6
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit46: TcxTextEdit
          Left = 220
          Top = 163
          Hint = 'T.P_GaiGui'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 14
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit50: TcxTextEdit
          Left = 220
          Top = 137
          Hint = 'T.P_Water'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 13
          Text = #8805
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit51: TcxTextEdit
          Left = 220
          Top = 111
          Hint = 'T.P_AnDing'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 12
          Text = #21512#26684
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
      end
      object Sheet2: TcxTabSheet
        Caption = #26816#39564#21442#25968
        ImageIndex = 1
        object Label17: TLabel
          Left = 12
          Top = 264
          Width = 72
          Height = 12
          Caption = '3'#22825#25239#21387#24378#24230':'
          Transparent = True
        end
        object Label18: TLabel
          Left = 12
          Top = 233
          Width = 72
          Height = 12
          Caption = '3'#22825#25239#25240#24378#24230':'
          Transparent = True
        end
        object Label19: TLabel
          Left = 12
          Top = 117
          Width = 54
          Height = 12
          Caption = #30897' '#21547' '#37327':'
          Transparent = True
        end
        object Label20: TLabel
          Left = 165
          Top = 39
          Width = 54
          Height = 12
          Caption = #19981' '#28342' '#29289':'
          Transparent = True
        end
        object Label21: TLabel
          Left = 12
          Top = 143
          Width = 54
          Height = 12
          Caption = #31264'    '#24230':'
          Transparent = True
        end
        object Label22: TLabel
          Left = 12
          Top = 91
          Width = 54
          Height = 12
          Caption = #32454'    '#24230':'
          Transparent = True
        end
        object Label23: TLabel
          Left = 12
          Top = 195
          Width = 54
          Height = 12
          Caption = #27695' '#31163' '#23376':'
          Transparent = True
        end
        object Label24: TLabel
          Left = 12
          Top = 13
          Width = 54
          Height = 12
          Caption = #27687' '#21270' '#38209':'
          Transparent = True
        end
        object Label25: TLabel
          Left = 231
          Top = 264
          Width = 78
          Height = 12
          Caption = '28'#22825#25239#21387#24378#24230':'
          Transparent = True
        end
        object Label26: TLabel
          Left = 231
          Top = 233
          Width = 78
          Height = 12
          Caption = '28'#22825#25239#25240#24378#24230':'
          Transparent = True
        end
        object Label27: TLabel
          Left = 165
          Top = 65
          Width = 54
          Height = 12
          Caption = #21021#20957#26102#38388':'
          Transparent = True
        end
        object Label28: TLabel
          Left = 165
          Top = 91
          Width = 54
          Height = 12
          Caption = #32456#20957#26102#38388':'
          Transparent = True
        end
        object Label29: TLabel
          Left = 165
          Top = 13
          Width = 54
          Height = 12
          Caption = #27604#34920#38754#31215':'
          Transparent = True
        end
        object Label30: TLabel
          Left = 165
          Top = 117
          Width = 54
          Height = 12
          Caption = #23433' '#23450' '#24615':'
          Transparent = True
        end
        object Label31: TLabel
          Left = 12
          Top = 39
          Width = 54
          Height = 12
          Caption = #19977#27687#21270#30827':'
        end
        object Label32: TLabel
          Left = 12
          Top = 65
          Width = 54
          Height = 12
          Caption = #28903' '#22833' '#37327':'
        end
        object Bevel2: TBevel
          Left = 12
          Top = 216
          Width = 420
          Height = 7
          Shape = bsBottomLine
        end
        object Label34: TLabel
          Left = 12
          Top = 168
          Width = 54
          Height = 12
          Caption = #28216' '#31163' '#38041':'
          Transparent = True
        end
        object Label38: TLabel
          Left = 165
          Top = 195
          Width = 54
          Height = 12
          Caption = #30789' '#37240' '#30416':'
          Transparent = True
        end
        object Label39: TLabel
          Left = 165
          Top = 168
          Width = 54
          Height = 12
          Caption = #38041' '#30789' '#27604':'
          Transparent = True
        end
        object Label40: TLabel
          Left = 165
          Top = 142
          Width = 54
          Height = 12
          Caption = #20445' '#27700' '#29575':'
          Transparent = True
        end
        object Label41: TLabel
          Left = 314
          Top = 13
          Width = 54
          Height = 12
          Caption = #30707#33167#31181#31867':'
          Transparent = True
        end
        object Label42: TLabel
          Left = 314
          Top = 39
          Width = 54
          Height = 12
          Caption = #30707' '#33167' '#37327':'
        end
        object Label43: TLabel
          Left = 314
          Top = 65
          Width = 54
          Height = 12
          Caption = #28151#21512#26448#31867':'
        end
        object Label44: TLabel
          Left = 314
          Top = 91
          Width = 54
          Height = 12
          Caption = #28151#21512#26448#37327':'
          Transparent = True
        end
        object cxTextEdit17: TcxTextEdit
          Left = 67
          Top = 8
          Hint = 'E.R_MgO'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 0
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit18: TcxTextEdit
          Left = 67
          Top = 188
          Hint = 'E.R_CL'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 7
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit19: TcxTextEdit
          Left = 67
          Top = 86
          Hint = 'E.R_XiDu'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 3
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit20: TcxTextEdit
          Left = 67
          Top = 138
          Hint = 'E.R_ChouDu'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 5
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit21: TcxTextEdit
          Left = 220
          Top = 34
          Hint = 'E.R_BuRong'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 9
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit22: TcxTextEdit
          Left = 67
          Top = 112
          Hint = 'E.R_Jian'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 4
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit23: TcxTextEdit
          Left = 67
          Top = 34
          Hint = 'E.R_SO3'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 1
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit24: TcxTextEdit
          Left = 67
          Top = 60
          Hint = 'E.R_ShaoShi'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 2
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit25: TcxTextEdit
          Left = 220
          Top = 112
          Hint = 'E.R_AnDing'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 12
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit26: TcxTextEdit
          Left = 220
          Top = 8
          Hint = 'E.R_BiBiao'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 8
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit27: TcxTextEdit
          Left = 220
          Top = 86
          Hint = 'E.R_ZhongNing'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 11
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit28: TcxTextEdit
          Left = 220
          Top = 60
          Hint = 'E.R_ChuNing'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 10
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit29: TcxTextEdit
          Left = 83
          Top = 228
          Hint = 'E.R_3DZhe1'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 16
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit30: TcxTextEdit
          Left = 83
          Top = 253
          Hint = 'E.R_3DYa1'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 19
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit31: TcxTextEdit
          Left = 311
          Top = 228
          Hint = 'E.R_28Zhe1'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 25
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit32: TcxTextEdit
          Left = 311
          Top = 253
          Hint = 'E.R_28Ya1'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 28
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit33: TcxTextEdit
          Left = 350
          Top = 228
          Hint = 'E.R_28Zhe2'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 26
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit34: TcxTextEdit
          Left = 389
          Top = 228
          Hint = 'E.R_28Zhe3'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 27
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit35: TcxTextEdit
          Left = 350
          Top = 253
          Hint = 'E.R_28Ya2'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 29
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit36: TcxTextEdit
          Left = 389
          Top = 253
          Hint = 'E.R_28Ya3'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 30
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit37: TcxTextEdit
          Left = 122
          Top = 228
          Hint = 'E.R_3DZhe2'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 17
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit38: TcxTextEdit
          Left = 122
          Top = 253
          Hint = 'E.R_3DYa2'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 20
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit39: TcxTextEdit
          Left = 162
          Top = 228
          Hint = 'E.R_3DZhe3'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 18
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit40: TcxTextEdit
          Left = 162
          Top = 253
          Hint = 'E.R_3DYa3'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 21
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit41: TcxTextEdit
          Left = 83
          Top = 270
          Hint = 'E.R_3DYa4'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 22
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit42: TcxTextEdit
          Left = 122
          Top = 270
          Hint = 'E.R_3DYa5'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 23
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit43: TcxTextEdit
          Left = 162
          Top = 270
          Hint = 'E.R_3DYa6'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bRight, bBottom]
          TabOrder = 24
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit47: TcxTextEdit
          Left = 311
          Top = 270
          Hint = 'E.R_28Ya4'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bTop, bBottom]
          TabOrder = 31
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit48: TcxTextEdit
          Left = 350
          Top = 270
          Hint = 'E.R_28Ya5'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bRight, bBottom]
          TabOrder = 32
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit49: TcxTextEdit
          Left = 389
          Top = 270
          Hint = 'E.R_28Ya6'
          ParentFont = False
          Properties.MaxLength = 20
          Style.Edges = [bLeft, bRight, bBottom]
          TabOrder = 33
          OnKeyPress = cxTextEdit2KeyPress
          Width = 42
        end
        object cxTextEdit45: TcxTextEdit
          Left = 67
          Top = 163
          Hint = 'E.R_YLiGai'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 6
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit52: TcxTextEdit
          Left = 220
          Top = 190
          Hint = 'E.R_KuangWu'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 15
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit53: TcxTextEdit
          Left = 220
          Top = 163
          Hint = 'E.R_GaiGui'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 14
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit54: TcxTextEdit
          Left = 220
          Top = 137
          Hint = 'E.R_Water'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 13
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit55: TcxTextEdit
          Left = 372
          Top = 8
          Hint = 'E.R_SGType'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 34
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit56: TcxTextEdit
          Left = 372
          Top = 34
          Hint = 'E.R_SGValue'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 35
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit57: TcxTextEdit
          Left = 372
          Top = 60
          Hint = 'E.R_HHCType'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 36
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
        object cxTextEdit58: TcxTextEdit
          Left = 372
          Top = 86
          Hint = 'E.R_HHCValue'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 37
          OnKeyPress = cxTextEdit2KeyPress
          Width = 75
        end
      end
    end
    object EditQLevel: TcxTextEdit
      Left = 329
      Top = 86
      Hint = 'T.P_QLevel'
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 4
      Width = 125
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #22522#26412#20449#24687
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #21697#31181#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item12: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #27700#27877#21517#31216':'
            Control = EditStock
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item2: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27700#27877#31867#22411':'
            Control = EditType
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item3: TdxLayoutItem
            Caption = #21697#31181#31561#32423':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #24378#24230#31561#32423':'
            Control = EditQLevel
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item8: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Item25: TdxLayoutItem
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = 'cxPageControl1'
        ShowCaption = False
        Control = wPage
        ControlOptions.AutoColor = True
        ControlOptions.ShowBorder = False
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
