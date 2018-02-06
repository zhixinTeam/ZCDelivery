inherited fFrameOtherCard: TfFrameOtherCard
  Width = 917
  Height = 462
  inherited ToolBar1: TToolBar
    Width = 917
    inherited BtnAdd: TToolButton
      Caption = #20379#24212#21345
      Visible = False
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #20020#26102#21345
      ImageIndex = 0
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 187
    Width = 917
    Height = 275
    PopupMenu = PMenu1
    LevelTabs.Slants.Kind = skCutCorner
    RootLevelOptions.DetailTabsPosition = dtpTop
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
    inherited cxLevel1: TcxGridLevel
      Caption = #20020#26102#19994#21153
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 917
    Height = 120
    object EditCard: TcxButtonEdit [0]
      Left = 264
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
      Width = 120
    end
    object EditDate: TcxButtonEdit [1]
      Left = 630
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
    object EditTruck: TcxButtonEdit [2]
      Left = 447
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
      Width = 120
    end
    object EditID: TcxButtonEdit [3]
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
      Width = 120
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #35760#24405#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 179
    Width = 917
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 917
    inherited TitleBar: TcxLabel
      Caption = #20020#26102#31216#37325
      Style.IsFontAssigned = True
      Width = 917
      AnchorX = 459
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
      object N8: TMenuItem
        Caption = #20923#32467#30913#21345
        OnClick = N8Click
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
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #39564#25910#26102#25235#25293
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N5: TMenuItem
      Caption = #25171#21360#30917#21333
      OnClick = N5Click
    end
  end
end
