inherited fFramePurchaseOrder: TfFramePurchaseOrder
  Width = 957
  Height = 436
  inherited ToolBar1: TToolBar
    Width = 957
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Visible = False
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 957
    Height = 234
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 957
    Height = 135
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
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object cxTextEdit1: TcxTextEdit [1]
      Left = 81
      Top = 93
      Hint = 'T.O_ID'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 125
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 257
      Top = 93
      Hint = 'T.O_ProName'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [3]
      Left = 445
      Top = 93
      Hint = 'T.O_Project'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 121
    end
    object EditCustomer: TcxButtonEdit [4]
      Left = 257
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object EditDate: TcxButtonEdit [5]
      Left = 635
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 3
      Width = 185
    end
    object EditTruck: TcxButtonEdit [6]
      Left = 445
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20379#24212#21333#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = ' '#26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20379#24212#32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #24037#31243#21517#31216':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 957
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 957
    inherited TitleBar: TcxLabel
      Caption = #37319#36141#35746#21333#31649#29702
      Style.IsFontAssigned = True
      Width = 957
      AnchorX = 479
      AnchorY = 11
    end
  end
  object Check1: TcxCheckBox [5]
    Left = 826
    Top = 95
    Caption = #26597#35810#24050#21024#38500
    ParentFont = False
    TabOrder = 5
    Transparent = True
    OnClick = Check1Click
    Width = 110
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 236
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 236
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 264
    object N1: TMenuItem
      Caption = #21150#29702#30913#21345
      Visible = False
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #27880#38144#30913#21345
      OnClick = N2Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #20462#25913#36710#29260#21495
      OnClick = N3Click
    end
    object N10: TMenuItem
      Caption = #20462#25913#33337#21495
      OnClick = N10Click
    end
    object N9: TMenuItem
      Caption = #25209#37327#20462#25913#29289#26009
      OnClick = N9Click
    end
    object N11: TMenuItem
      Caption = #20462#25913#36827#21378#35745#21010'WSDL'
      OnClick = N11Click
    end
    object N12: TMenuItem
      Caption = #25209#37327#20462#25913#36827#21378#35745#21010'('#22266#23450#21345')'
      OnClick = N12Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #39564#25910#26102#25235#25293
      OnClick = N4Click
    end
    object N7: TMenuItem
      Caption = #39564#25910#36890#36947
      OnClick = N7Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
  end
end
