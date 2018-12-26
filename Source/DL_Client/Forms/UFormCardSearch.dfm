inherited fFormCardSearch: TfFormCardSearch
  Left = 402
  Top = 116
  Caption = #30913#21345#26597#35810
  ClientHeight = 321
  ClientWidth = 461
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 461
    Height = 321
    inherited BtnOK: TButton
      Left = 315
      Top = 288
      Caption = #30830#23450
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 385
      Top = 288
      TabOrder = 11
    end
    object EditTruck: TcxTextEdit [2]
      Left = 81
      Top = 251
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 9
      Width = 121
    end
    object EditCard: TcxTextEdit [3]
      Left = 81
      Top = 51
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 1
      Width = 121
    end
    object cxLabel2: TcxLabel [4]
      Left = 23
      Top = 36
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Transparent = True
      Height = 10
      Width = 331
    end
    object EditUse: TcxTextEdit [5]
      Left = 81
      Top = 76
      TabOrder = 2
      Width = 121
    end
    object EditFreeze: TcxTextEdit [6]
      Left = 81
      Top = 126
      TabOrder = 4
      Width = 121
    end
    object EditCType: TcxTextEdit [7]
      Left = 81
      Top = 151
      TabOrder = 5
      Width = 121
    end
    object EditID: TcxTextEdit [8]
      Left = 81
      Top = 176
      TabOrder = 6
      Width = 121
    end
    object EditUTime: TcxTextEdit [9]
      Left = 81
      Top = 101
      TabOrder = 3
      Width = 121
    end
    object EditCusName: TcxTextEdit [10]
      Left = 81
      Top = 201
      TabOrder = 7
      Width = 121
    end
    object EditStockName: TcxTextEdit [11]
      Left = 81
      Top = 226
      TabOrder = 8
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item12: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20351#29992#29366#24577':'
          Control = EditUse
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #20351#29992#26102#38388':'
          Control = EditUTime
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20923#32467#29366#24577':'
          Control = EditFreeze
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #30913#21345#31867#22411':'
          Control = EditCType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #21333#25454#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCusName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = #29289#26009#21517#31216':'
          Control = EditStockName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#33337#21495#30721':'
          Control = EditTruck
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
