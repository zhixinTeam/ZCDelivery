inherited fFormGetZhiKa: TfFormGetZhiKa
  Left = 351
  Top = 280
  Width = 904
  Height = 430
  BorderStyle = bsSizeable
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 888
    Height = 392
    inherited BtnOK: TButton
      Left = 742
      Top = 359
      Caption = #30830#23450
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 812
      Top = 359
      TabOrder = 5
    end
    object GridOrders: TcxGrid [2]
      Left = 23
      Top = 66
      Width = 250
      Height = 200
      TabOrder = 3
      object cxView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        object cxView1Column1: TcxGridDBColumn
          Caption = #35746#21333#32534#21495
          DataBinding.FieldName = 'O_Order'
        end
        object cxView1Column2: TcxGridDBColumn
          Caption = #29983#20135#21378
          DataBinding.FieldName = 'O_Factory'
        end
        object cxView1Column3: TcxGridDBColumn
          Caption = #25552#36135#23458#25143
          DataBinding.FieldName = 'O_CusName'
        end
        object cxView1Column4: TcxGridDBColumn
          Caption = #21697#31181#35268#26684
          DataBinding.FieldName = 'O_StockName'
        end
        object cxView1Column5: TcxGridDBColumn
          Caption = #21253#35013#26041#24335
          DataBinding.FieldName = 'O_StockType'
        end
        object cxView1Column6: TcxGridDBColumn
          Caption = #25552#36135#26041#24335
          DataBinding.FieldName = 'O_Lading'
        end
        object cxView1Column7: TcxGridDBColumn
          Caption = #35745#21010#25968#37327
          DataBinding.FieldName = 'O_PlanAmount'
        end
        object cxView1Column8: TcxGridDBColumn
          Caption = #24320#31080#25968#37327
          DataBinding.FieldName = 'O_PlanDone'
        end
        object cxView1Column9: TcxGridDBColumn
          Caption = #35745#21010#20313#37327
          DataBinding.FieldName = 'O_PlanRemain'
        end
        object cxView1Column10: TcxGridDBColumn
          Caption = #20923#32467#37327
          DataBinding.FieldName = 'O_Freeze'
        end
        object cxView1Column11: TcxGridDBColumn
          Caption = #36215#22987#26085#26399
          DataBinding.FieldName = 'O_PlanBegin'
        end
        object cxView1Column12: TcxGridDBColumn
          Caption = #25130#27490#26085#26399
          DataBinding.FieldName = 'O_PlanEnd'
        end
        object cxView1Column13: TcxGridDBColumn
          Caption = #20379#36135#21333#20301
          DataBinding.FieldName = 'O_Company'
        end
        object cxView1Column14: TcxGridDBColumn
          Caption = #37096#38376
          DataBinding.FieldName = 'O_Depart'
        end
        object cxView1Column15: TcxGridDBColumn
          Caption = #38144#21806#21592
          DataBinding.FieldName = 'O_SaleMan'
        end
        object cxView1Column16: TcxGridDBColumn
          Caption = #22791#27880
          DataBinding.FieldName = 'O_Remark'
        end
      end
      object cxLevel1: TcxGridLevel
        GridView = cxView1
      end
    end
    object EditCus: TcxButtonEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      ParentShowHint = False
      Properties.Buttons = <
        item
          Default = True
          Hint = #26597#25214
          Kind = bkEllipsis
        end
        item
          Caption = #8730
          Hint = #21047#26032
          Kind = bkText
        end>
      Properties.OnButtonClick = EditCusPropertiesButtonClick
      ShowHint = True
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 228
    end
    object EditCusList: TcxComboBox [4]
      Left = 366
      Top = 36
      ParentFont = False
      Properties.IncrementalSearch = False
      Properties.OnChange = EditCusListPropertiesChange
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 312
    end
    object BtnSearch: TcxButton [5]
      Left = 683
      Top = 36
      Width = 75
      Height = 25
      Caption = #26597#35810
      TabOrder = 2
      OnClick = BtnSearchClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #35746#21333#21015#34920
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #23458#25143#21517#31216':'
            Control = EditCus
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #23458#25143#21015#34920
            Control = EditCusList
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Caption = 'cxButton1'
            ShowCaption = False
            Control = BtnSearch
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxGrid1'
          ShowCaption = False
          Control = GridOrders
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 44
    Top = 122
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 72
    Top = 122
  end
end
