inherited fFormStockNo: TfFormStockNo
  Left = 401
  Top = 134
  Width = 466
  Height = 300
  BorderStyle = bsSizeable
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 458
    Height = 266
    AutoContentSizes = [acsWidth, acsHeight]
    inherited BtnOK: TButton
      Left = 312
      Top = 233
      Caption = #30830#23450
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 382
      Top = 233
      TabOrder = 4
    end
    object EditNo: TcxButtonEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNoPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object ListStock: TcxListView [3]
      Left = 23
      Top = 82
      Width = 417
      Height = 145
      Columns = <
        item
          Caption = #27700#27877#32534#21495
          Width = 70
        end
        item
          Caption = #27700#27877#21517#31216
          Width = 75
        end
        item
          Alignment = taCenter
          Caption = #24050#24320#37327'('#21544')'
          Width = 70
        end
        item
          Alignment = taCenter
          Caption = #21097#20313#37327'('#21544')'
          Width = 75
        end
        item
          Caption = #21462#26679#26102#38388
          Width = 75
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 2
      ViewStyle = vsReport
      OnDblClick = ListStockDblClick
      OnKeyPress = ListStockKeyPress
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 61
      Caption = #26597#35810#32467#26524':'
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #26597#35810#26465#20214
        object dxLayout1Item5: TdxLayoutItem
          Caption = #27700#27877#32534#21495':'
          Control = EditNo
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
          Control = ListStock
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
