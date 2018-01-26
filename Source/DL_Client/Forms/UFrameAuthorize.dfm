inherited fFrameAuthorize: TfFrameAuthorize
  Width = 830
  Height = 422
  inherited ToolBar1: TToolBar
    Width = 830
    inherited BtnAdd: TToolButton
      Caption = #30003#35831
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #25209#20934
      ImageIndex = 18
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Caption = #31105#27490
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 205
    Width = 830
    Height = 217
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 830
    Height = 138
    object EditName: TcxButtonEdit [0]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 135
    end
    object EditMAC: TcxButtonEdit [1]
      Left = 273
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 135
    end
    object cxTextEdit1: TcxTextEdit [2]
      Left = 81
      Top = 96
      Hint = 'T.W_Name'
      ParentFont = False
      TabOrder = 2
      Width = 135
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 273
      Top = 96
      Hint = 'T.W_MAC'
      ParentFont = False
      TabOrder = 3
      Width = 135
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 471
      Top = 96
      Hint = 'T.W_Departmen'
      ParentFont = False
      TabOrder = 4
      Width = 135
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #30005#33041#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = 'MAC'#22320#22336':'
          Control = EditMAC
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30005#33041#21517#31216':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'MAC'#22320#22336':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #25152#23646#37096#38376':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 197
    Width = 830
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 830
    inherited TitleBar: TcxLabel
      Caption = #31995#32479#35748#35777#31649#29702
      Style.IsFontAssigned = True
      Width = 830
      AnchorX = 415
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Top = 242
  end
  inherited DataSource1: TDataSource
    Top = 242
  end
end
