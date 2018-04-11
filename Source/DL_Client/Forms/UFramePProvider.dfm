inherited fFrameProvider: TfFrameProvider
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
    inherited BtnRefresh: TToolButton
      Caption = '   '#21047#26032'   '
    end
    inherited BtnExit: TToolButton
      Caption = #20851#38381
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
      Left = 69
      Top = 93
      Hint = 'T.P_Name'
      ParentFont = False
      TabOrder = 1
      Width = 125
    end
    object EditName: TcxButtonEdit [1]
      Left = 69
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
      Left = 257
      Top = 93
      Hint = 'T.P_Memo'
      ParentFont = False
      TabOrder = 2
      Width = 274
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = cxTextEdit2
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
      Caption = #21407#26009#20379#24212#21830#31649#29702
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
    OnPopup = PMenu1Popup
    Left = 232
    Top = 272
    object N1: TMenuItem
      Caption = #21516#27493'ERP'#20379#24212#21830
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #20851#32852#24494#20449#21830#22478#36134#25143
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #21462#28040#21830#22478#36134#21495#20851#32852
      OnClick = N3Click
    end
  end
end
