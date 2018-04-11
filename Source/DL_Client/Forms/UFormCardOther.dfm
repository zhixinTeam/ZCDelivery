inherited fFormCardOther: TfFormCardOther
  Left = 402
  Top = 116
  Caption = #20020#26102#19994#21153
  ClientHeight = 526
  ClientWidth = 462
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 462
    Height = 526
    inherited BtnOK: TButton
      Left = 316
      Top = 493
      Caption = #30830#23450
      TabOrder = 14
    end
    inherited BtnExit: TButton
      Left = 386
      Top = 493
      TabOrder = 15
    end
    object EditTruck: TcxTextEdit [2]
      Left = 81
      Top = 300
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 8
      OnKeyPress = EditTruckKeyPress
      Width = 121
    end
    object cxLabel1: TcxLabel [3]
      Left = 23
      Top = 96
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Transparent = True
      Height = 10
      Width = 331
    end
    object EditCard: TcxTextEdit [4]
      Left = 81
      Top = 325
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 9
      OnKeyPress = EditCardKeyPress
      Width = 121
    end
    object EditMName: TcxComboBox [5]
      Left = 81
      Top = 66
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.OnChange = EditMNamePropertiesChange
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 2
      Width = 275
    end
    object EditRName: TcxComboBox [6]
      Left = 81
      Top = 275
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.MaxLength = 32
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 7
      Width = 275
    end
    object EditCName: TcxComboBox [7]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.MaxLength = 80
      Properties.OnChange = EditCNamePropertiesChange
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 0
      Width = 275
    end
    object cxLabel2: TcxLabel [8]
      Left = 23
      Top = 260
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Transparent = True
      Height = 10
      Width = 331
    end
    object Check1: TcxCheckBox [9]
      Left = 11
      Top = 493
      Caption = #22266#23450#21345': '#20986#21378#26102#19981#27880#38144'.'
      ParentFont = False
      TabOrder = 13
      Transparent = True
      Width = 165
    end
    object CheckOnePValue: TcxCheckBox [10]
      Left = 23
      Top = 434
      Caption = #21333#27425#31216#30382'('#27880':'#39318#27425#31216#30382#37325','#21518#32493#36807#30917#20381#27492#20026#30382#37325')'
      ParentFont = False
      TabOrder = 11
      Transparent = True
      Width = 121
    end
    object CheckOneDoor: TcxCheckBox [11]
      Left = 23
      Top = 460
      Caption = #21333#21521#36890#36807'('#27880':'#21496#26426#20498#36710#20986#30917')'
      ParentFont = False
      TabOrder = 12
      Transparent = True
      Width = 121
    end
    object cbbystd: TcxComboBox [12]
      Left = 81
      Top = 350
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 10
      Width = 121
    end
    object BtnAdd: TButton [13]
      Left = 361
      Top = 36
      Width = 75
      Height = 25
      Caption = #28155#21152
      TabOrder = 1
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [14]
      Left = 361
      Top = 66
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 3
      OnClick = BtnDelClick
    end
    object ListQuery: TcxListView [15]
      Left = 23
      Top = 111
      Width = 568
      Height = 144
      Align = alClient
      Columns = <
        item
          Caption = #21457#36135#21333#20301#21517#31216
          Width = 240
        end
        item
          Caption = #29289#26009#21517#31216
          Width = 160
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 5
      ViewStyle = vsReport
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            Caption = #21457#36135#21333#20301':'
            Control = EditCName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item13: TdxLayoutItem
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnAdd
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #29289#26009#21517#31216':'
            Control = EditMName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item17: TdxLayoutItem
            Caption = 'Button2'
            ShowCaption = False
            Control = BtnDel
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Control = ListQuery
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #25910#36135#21333#20301':'
          Control = EditRName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#33337#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item16: TdxLayoutItem
          Caption = #39564#25910#36890#36947
          Control = cbbystd
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group2: TdxLayoutGroup [1]
        Caption = #38468#21152#21442#25968
        object dxLayout1Item14: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = CheckOnePValue
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = 'cxCheckBox2'
          ShowCaption = False
          Control = CheckOneDoor
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item11: TdxLayoutItem [0]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    Timeouts.ReadTotalMultiplier = 10
    Timeouts.ReadTotalConstant = 100
    OnRxChar = ComPort1RxChar
    Left = 14
    Top = 4
  end
end
