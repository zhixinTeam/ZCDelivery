inherited fFrameQueryDispatch: TfFrameQueryDispatch
  Width = 1052
  Height = 478
  inherited ToolBar1: TToolBar
    Width = 1052
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
    Top = 209
    Width = 1052
    Height = 269
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PopupMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1052
    Height = 142
    object cxTextEdit5: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.T_Truck'
      ParentFont = False
      TabOrder = 1
      Width = 121
    end
    object cxTextEdit1: TcxTextEdit [1]
      Left = 265
      Top = 93
      Hint = #25152#22312#38431#21015':'
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 449
      Top = 93
      Hint = 'T.T_InTime'
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object cxTextEdit3: TcxTextEdit [3]
      Left = 633
      Top = 93
      Hint = 'T.T_InFact'
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditTruck: TcxButtonEdit [4]
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
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #25152#22312#38431#21015':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #36827#38431#26102#38388':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36827#21378#26102#38388':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 201
    Width = 1052
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1052
    inherited TitleBar: TcxLabel
      Caption = #25490#38431#35843#24230#36710#36742#26597#35810
      Style.IsFontAssigned = True
      Width = 1052
      AnchorX = 526
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 240
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 240
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 268
    object N1: TMenuItem
      Caption = #36710#36742#25554#38431#39318
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #36710#36742#37325#25490#38431
      OnClick = N2Click
    end
    object N7: TMenuItem
      Caption = #20132#36135#21333#25805#20316
      object N9: TMenuItem
        Tag = 10
        Caption = #36827#20837#38431#21015
        OnClick = N9Click
      end
      object N8: TMenuItem
        Tag = 20
        Caption = #31227#20986#38431#21015
        OnClick = N9Click
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object N11: TMenuItem
        Caption = #28165#29702#38431#21015
        OnClick = N11Click
      end
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #25351#23450#36947#35013#36710
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Caption = #26597#35810#36710#24207#21015
      OnClick = N6Click
    end
  end
end
