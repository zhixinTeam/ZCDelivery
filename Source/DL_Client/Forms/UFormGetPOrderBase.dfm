inherited fFormGetPOrderBase: TfFormGetPOrderBase
  Left = 401
  Top = 134
  Width = 848
  Height = 542
  BorderStyle = bsSizeable
  Constraints.MinHeight = 300
  Constraints.MinWidth = 445
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 832
    Height = 504
    inherited BtnOK: TButton
      Left = 686
      Top = 471
      Caption = #30830#23450
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 756
      Top = 471
      TabOrder = 7
    end
    object EditProvider: TcxButtonEdit [2]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object ListQuery: TcxListView [3]
      Left = 23
      Top = 157
      Width = 417
      Height = 145
      Columns = <
        item
          Caption = #30003#35831#21333#32534#21495
          Width = 100
        end
        item
          Caption = #21407#26448#26009
          Width = 70
        end
        item
          Caption = #22411#21495
          Width = 40
        end
        item
          AutoSize = True
          Caption = #20379#24212#21830
          WidthType = (
            -197)
        end
        item
          Caption = #30719#28857
          Width = 140
        end
        item
          Caption = #35746#21333#21097#20313
          Width = 80
        end
        item
          Caption = #22791#27880
          Width = 80
        end
        item
          Caption = #35746#21333#34892
          Width = 100
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 5
      ViewStyle = vsReport
      OnDblClick = ListQueryDblClick
      OnKeyPress = ListQueryKeyPress
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 136
      Caption = #26597#35810#32467#26524':'
      ParentFont = False
      Transparent = True
    end
    object EditMate: TcxButtonEdit [5]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 3
      Width = 121
    end
    object EditYear: TcxComboBox [6]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      Width = 121
    end
    object EditOrderType: TcxComboBox [7]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #26222#36890#21407#26448#26009
        #20869#20498#21407#26448#26009)
      Properties.ReadOnly = False
      Properties.OnChange = orderange
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      Text = #26222#36890#21407#26448#26009
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #26597#35810#26465#20214
        object dxLayout1Item8: TdxLayoutItem
          Caption = #35746#21333#31867#22411':'
          Control = EditOrderType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #35760#36134#24180#26376':'
          Control = EditYear
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20379' '#24212' '#21830':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21407' '#26448' '#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListQuery
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
