inherited fFrameHYStock: TfFrameHYStock
  Width = 622
  Height = 374
  inherited ToolBar1: TToolBar
    Width = 622
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
    Top = 203
    Width = 622
    Height = 171
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 622
    Height = 136
    object EditID: TcxButtonEdit [0]
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
      Width = 121
    end
    object EditType: TcxButtonEdit [1]
      Left = 265
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
      Width = 121
    end
    object cxTextEdit1: TcxTextEdit [2]
      Left = 81
      Top = 93
      Hint = 'T.P_ID'
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 265
      Top = 93
      Hint = 'T.P_Stock'
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 449
      Top = 93
      Hint = 'T.P_Name'
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #21697#31181#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #27700#27877#21517#31216':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          Caption = #21697#31181#32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #27700#27877#21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #31561#32423#21517#31216':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 195
    Width = 622
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 622
    inherited TitleBar: TcxLabel
      Caption = #27700#27877#21697#31181#31649#29702
      Style.IsFontAssigned = True
      Width = 622
      AnchorX = 311
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 236
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 236
  end
end
