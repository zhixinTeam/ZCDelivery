inherited fFrameSysLog: TfFrameSysLog
  Width = 761
  inherited ToolBar1: TToolBar
    Width = 761
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
    Top = 199
    Width = 761
    Height = 168
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 761
    Height = 132
    object cxTextEdit3: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.L_Date'
      ParentFont = False
      TabOrder = 3
      Width = 115
    end
    object cxTextEdit4: TcxTextEdit [1]
      Left = 259
      Top = 93
      Hint = 'T.L_ItemID'
      ParentFont = False
      TabOrder = 4
      Width = 115
    end
    object cxTextEdit5: TcxTextEdit [2]
      Left = 437
      Top = 93
      Hint = 'T.L_Event'
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    object EditMan: TcxButtonEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditManPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object EditItem: TcxButtonEdit [4]
      Left = 259
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditManPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object EditDate: TcxButtonEdit [5]
      Left = 437
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 2
      Width = 175
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item6: TdxLayoutItem
          Caption = #25805' '#20316' '#20154':'
          Control = EditMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20107#20214#23545#35937':'
          Control = EditItem
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #26102#38388#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #25805#20316#26102#38388':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #20107#20214#23545#35937':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #20107#20214#20869#23481':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 191
    Width = 761
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 761
    inherited TitleBar: TcxLabel
      Caption = #31995#32479#25805#20316#26085#24535
      Style.IsFontAssigned = True
      Width = 761
      AnchorX = 381
      AnchorY = 11
    end
  end
end
