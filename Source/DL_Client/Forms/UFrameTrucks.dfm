inherited fFrameTrucks: TfFrameTrucks
  Width = 686
  inherited ToolBar1: TToolBar
    Width = 686
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 686
    Height = 165
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 686
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.T_Truck'
      ParentFont = False
      TabOrder = 1
      Width = 125
    end
    object EditName: TcxButtonEdit [1]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 269
      Top = 93
      Hint = 'T.T_Owner'
      ParentFont = False
      TabOrder = 2
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [3]
      Left = 457
      Top = 93
      Hint = 'T.T_PValue'
      ParentFont = False
      TabOrder = 3
      Width = 125
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#20027#22995#21517':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #26377#25928#30382#37325':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 686
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 686
    inherited TitleBar: TcxLabel
      Caption = #36710#36742#26723#26696#31649#29702
      Style.IsFontAssigned = True
      Width = 686
      AnchorX = 343
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Top = 234
  end
  inherited DataSource1: TDataSource
    Top = 234
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PMenu1Popup
    Left = 6
    Top = 262
    object N2: TMenuItem
      Caption = #36710#36742#31614#21040
      OnClick = N2Click
    end
    object N8: TMenuItem
      Caption = #21150#29702#20869#20498
      OnClick = N8Click
    end
    object N3: TMenuItem
      Caption = '-'
      Enabled = False
    end
    object N9: TMenuItem
      Caption = #8251#30005#23376#26631#31614#8251
      Enabled = False
    end
    object N4: TMenuItem
      Caption = 'a.'#21150#29702
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = 'b.'#21551#29992
      OnClick = N5Click
    end
    object N7: TMenuItem
      Caption = 'c.'#20572#29992
      OnClick = N7Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object VIP3: TMenuItem
      Caption = #8251'VIP'#8251
      Enabled = False
    end
    object VIP1: TMenuItem
      Caption = 'a.'#21551#29992
      OnClick = VIP1Click
    end
    object VIP2: TMenuItem
      Caption = 'b.'#20851#38381
      OnClick = VIP2Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Caption = #26597#30475#39044#21046#30382#37325#25235#25293
      OnClick = N10Click
    end
  end
end
