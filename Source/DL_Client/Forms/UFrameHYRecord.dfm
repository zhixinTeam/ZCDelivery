inherited fFrameHYRecord: TfFrameHYRecord
  Width = 621
  Height = 413
  inherited ToolBar1: TToolBar
    Width = 621
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
    Width = 621
    Height = 210
    inherited cxView1: TcxGridDBTableView
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 621
    Height = 136
    object EditStock: TcxButtonEdit [0]
      Left = 249
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
      Width = 105
    end
    object cxTextEdit2: TcxTextEdit [1]
      Left = 249
      Top = 93
      Hint = 'T.P_Stock'
      ParentFont = False
      TabOrder = 4
      Width = 105
    end
    object EditID: TcxButtonEdit [2]
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
      Width = 105
    end
    object cxTextEdit4: TcxTextEdit [3]
      Left = 81
      Top = 93
      Hint = 'T.R_SerialNo'
      ParentFont = False
      TabOrder = 3
      Width = 105
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 417
      Top = 93
      Hint = 'T.P_Name'
      ParentFont = False
      TabOrder = 5
      Width = 105
    end
    object EditDate: TcxButtonEdit [5]
      Left = 417
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 2
      Width = 175
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #27700#27877#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #27700#27877#21517#31216':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #26816#39564#26085#26399':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item7: TdxLayoutItem
          Caption = #27700#27877#32534#21495':'
          Control = cxTextEdit4
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
    Width = 621
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 621
    inherited TitleBar: TcxLabel
      Caption = #27700#27877#26816#39564#35760#24405
      Style.IsFontAssigned = True
      Width = 621
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
