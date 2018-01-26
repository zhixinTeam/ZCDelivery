inherited fFrameSaleDetailTotal: TfFrameSaleDetailTotal
  Width = 1089
  Height = 429
  inherited ToolBar1: TToolBar
    Width = 1089
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
    inherited S1: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 205
    Width = 1089
    Height = 224
    inherited cxView1: TcxGridDBTableView
      PopupMenu = pmPMenu1
      DataController.Summary.Options = [soNullIgnore]
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1089
    Height = 138
    object cxtxtdt1: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.L_CusName'
      ParentFont = False
      TabOrder = 5
      Width = 165
    end
    object EditDate: TcxButtonEdit [1]
      Left = 309
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 1
      Width = 185
    end
    object EditCustomer: TcxButtonEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 165
    end
    object cxtxtdt2: TcxTextEdit [3]
      Left = 569
      Top = 93
      Hint = 'T.L_Value'
      ParentFont = False
      TabOrder = 7
      Width = 168
    end
    object cxtxtdt4: TcxTextEdit [4]
      Left = 309
      Top = 93
      Hint = 'T.L_StockName'
      ParentFont = False
      TabOrder = 6
      Width = 185
    end
    object Radio1: TcxRadioButton [5]
      Left = 580
      Top = 36
      Width = 70
      Height = 17
      Caption = #21516#23458#25143
      Checked = True
      ParentColor = False
      TabOrder = 3
      TabStop = True
    end
    object Radio2: TcxRadioButton [6]
      Left = 655
      Top = 36
      Width = 115
      Height = 17
      Caption = #21516#23458#25143#21516#21697#31181
      ParentColor = False
      TabOrder = 4
    end
    object cxLabel1: TcxLabel [7]
      Left = 499
      Top = 36
      Caption = '   '#21512#35745#26041#24335':'
      ParentFont = False
      Style.BorderStyle = ebsNone
      Style.Edges = [bBottom]
      Transparent = True
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = 'cxRadioButton1'
          ShowCaption = False
          Control = Radio1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxRadioButton2'
          ShowCaption = False
          Control = Radio2
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #23458#25143#21517#31216':'
          Control = cxtxtdt1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21697#31181#21517#31216':'
          Control = cxtxtdt4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20132#36135#37327'('#21544'):'
          Control = cxtxtdt2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 197
    Width = 1089
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1089
    inherited TitleBar: TcxLabel
      Caption = #32047#35745#21457#36135#32479#35745#26597#35810
      Style.IsFontAssigned = True
      Width = 1089
      AnchorX = 545
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 10
    Top = 252
  end
  inherited DataSource1: TDataSource
    Left = 38
    Top = 252
  end
  object pmPMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 10
    Top = 280
    object mniN1: TMenuItem
      Caption = #26102#38388#27573#26597#35810
      OnClick = mniN1Click
    end
  end
end
