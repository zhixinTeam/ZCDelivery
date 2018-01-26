inherited fFormGetTruck: TfFormGetTruck
  Left = 503
  Width = 448
  Height = 309
  BorderStyle = bsSizeable
  Constraints.MinHeight = 220
  Constraints.MinWidth = 400
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 440
    Height = 282
    inherited BtnOK: TButton
      Left = 294
      Top = 249
      Caption = #30830#23450
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 364
      Top = 249
      TabOrder = 5
    end
    object EditTruck: TcxButtonEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object ListTruck: TcxListView [3]
      Left = 23
      Top = 82
      Width = 417
      Height = 145
      Columns = <
        item
          Caption = #36710#29260#21495#30721
          Width = 70
        end
        item
          Caption = #36710#20027#22995#21517
          Width = 70
        end
        item
          Caption = #32852#31995#26041#24335
          Width = 70
        end>
      HideSelection = False
      ParentFont = False
      PopupMenu = PMenu1
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 2
      ViewStyle = vsReport
      OnDblClick = ListTruckDblClick
      OnKeyPress = ListTruckKeyPress
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 61
      Caption = #26597#35810#32467#26524':'
      ParentFont = False
      Transparent = True
    end
    object Check1: TcxCheckBox [5]
      Left = 11
      Top = 249
      Caption = #26174#31034#20840#37096#36710#36742
      ParentFont = False
      TabOrder = 3
      Transparent = True
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #26597#35810#26465#20214
        object dxLayout1Item5: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #26597#35810#32467#26524':'
          ShowCaption = False
          Control = ListTruck
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem [0]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 28
    Top = 104
    object N1: TMenuItem
      Caption = #36710#20027#22995#21517
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #32852#31995#26041#24335
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Tag = 10
      Caption = #38544#34255#36710#36742
      OnClick = N4Click
    end
    object N5: TMenuItem
      Tag = 20
      Caption = #26174#31034#36710#36742
      OnClick = N4Click
    end
  end
end
