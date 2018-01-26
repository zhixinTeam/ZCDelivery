inherited fFrameBillCard: TfFrameBillCard
  Width = 879
  Height = 544
  inherited ToolBar1: TToolBar
    Width = 879
    inherited BtnAdd: TToolButton
      Caption = #21150#29702
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 205
    Width = 879
    Height = 339
    LevelTabs.Slants.Kind = skCutCorner
    LevelTabs.Style = 9
    RootLevelOptions.DetailTabsPosition = dtpTop
    OnActiveTabChanged = cxGrid1ActiveTabChanged
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
    object cxView2: TcxGridDBTableView [1]
      PopupMenu = PMenu2
      OnDblClick = cxView2DblClick
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    inherited cxLevel1: TcxGridLevel
      Caption = #24050#21150#29702
    end
    object cxLevel2: TcxGridLevel
      Caption = #26410#21150#29702
      GridView = cxView2
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 879
    Height = 138
    object EditBill: TcxButtonEdit [0]
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
      Width = 125
    end
    object EditTruck: TcxButtonEdit [1]
      Left = 269
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object EditCus: TcxButtonEdit [2]
      Left = 457
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object EditDate: TcxButtonEdit [3]
      Left = 645
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 3
      Width = 185
    end
    object cxTextEdit1: TcxTextEdit [4]
      Left = 81
      Top = 96
      Hint = 'T.L_ID'
      ParentFont = False
      TabOrder = 4
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [5]
      Left = 269
      Top = 96
      Hint = 'T.L_Truck'
      ParentFont = False
      TabOrder = 5
      Width = 125
    end
    object cxTextEdit2: TcxTextEdit [6]
      Left = 457
      Top = 96
      Hint = 'T.L_CusName'
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = EditBill
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item6: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 197
    Width = 879
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 879
    inherited TitleBar: TcxLabel
      Caption = #21150#29702#30913#21345#35760#24405
      Style.IsFontAssigned = True
      Width = 879
      AnchorX = 440
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 2
    Top = 262
  end
  inherited DataSource1: TDataSource
    Left = 30
    Top = 262
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PMenu1Popup
    Left = 2
    Top = 318
    object N1: TMenuItem
      Caption = #26597#35810#36873#39033
      object N5: TMenuItem
        Caption = #26080#25928#30913#21345
        OnClick = N5Click
      end
      object N8: TMenuItem
        Caption = #20923#32467#30913#21345
        OnClick = N8Click
      end
      object N6: TMenuItem
        Caption = #26597#35810#20840#37096
        OnClick = N6Click
      end
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object N9: TMenuItem
      Caption = #25346#22833#30913#21345
      OnClick = N9Click
    end
    object N10: TMenuItem
      Caption = #35299#38500#25346#22833
      OnClick = N10Click
    end
    object N11: TMenuItem
      Caption = #34917#21150#30913#21345
      OnClick = N11Click
    end
    object N12: TMenuItem
      Caption = #27880#38144#30913#21345
      OnClick = N12Click
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object N14: TMenuItem
      Caption = #20923#32467#30913#21345
      OnClick = N14Click
    end
    object N15: TMenuItem
      Caption = #35299#38500#20923#32467
      OnClick = N15Click
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object N17: TMenuItem
      Caption = #22791#27880#20449#24687
      OnClick = N17Click
    end
  end
  object DataSource2: TDataSource
    DataSet = SQLNo1
    Left = 30
    Top = 290
  end
  object SQLNo1: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 2
    Top = 290
  end
  object PMenu2: TPopupMenu
    AutoHotkeys = maManual
    Left = 30
    Top = 318
    object N2: TMenuItem
      Caption = #21150#29702#30913#21345
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #26597#35810#20840#37096
      OnClick = N4Click
    end
  end
end
