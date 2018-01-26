inherited fFormGetZhiKa: TfFormGetZhiKa
  Left = 351
  Top = 280
  Width = 745
  Height = 430
  BorderStyle = bsSizeable
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 737
    Height = 403
    inherited BtnOK: TButton
      Left = 591
      Top = 370
      Caption = #30830#23450
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 661
      Top = 370
      TabOrder = 3
    end
    object GridOrders: TcxGrid [2]
      Left = 23
      Top = 61
      Width = 250
      Height = 200
      TabOrder = 1
      object cxView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        object cxView1Column1: TcxGridDBColumn
          Caption = #35746#21333#32534#21495
          DataBinding.FieldName = 'VBELN'
        end
        object cxView1Column2: TcxGridDBColumn
          Caption = #29289#26009#32534#21495
          DataBinding.FieldName = 'MATNR'
        end
        object cxView1Column3: TcxGridDBColumn
          Caption = #29289#26009#25551#36848
          DataBinding.FieldName = 'ARKTX'
        end
        object cxView1Column4: TcxGridDBColumn
          Caption = #23458#25143#32534#21495
          DataBinding.FieldName = 'KUNNR'
        end
        object cxView1Column5: TcxGridDBColumn
          Caption = #23458#25143#25551#36848
          DataBinding.FieldName = 'KUNNRDESC'
        end
        object cxView1Column6: TcxGridDBColumn
          Caption = #24037#21378
          DataBinding.FieldName = 'WERKS'
        end
        object cxView1Column7: TcxGridDBColumn
          Caption = #24037#21378#25551#36848
          DataBinding.FieldName = 'WERKSDESC'
        end
        object cxView1Column8: TcxGridDBColumn
          Caption = #38144#21806#26426#26500
          DataBinding.FieldName = 'VKORG'
        end
        object cxView1Column9: TcxGridDBColumn
          Caption = #38144#21806#21306#22495
          DataBinding.FieldName = 'BZIRK'
        end
        object cxView1Column10: TcxGridDBColumn
          Caption = #29255#21306
          DataBinding.FieldName = 'KONDA'
        end
        object cxView1Column11: TcxGridDBColumn
          Caption = #29255#21306#25551#36848
          DataBinding.FieldName = 'VTEXTK'
        end
        object cxView1Column12: TcxGridDBColumn
          Caption = #20998#38144#28192#36947
          DataBinding.FieldName = 'VTWEG'
        end
        object cxView1Column13: TcxGridDBColumn
          Caption = #28192#36947#25551#36848
          DataBinding.FieldName = 'VTEXTV'
        end
        object cxView1Column14: TcxGridDBColumn
          Caption = #21253#35013#26041#24335
          DataBinding.FieldName = 'VTEXT'
        end
        object cxView1Column15: TcxGridDBColumn
          Caption = #35746#21333#25968#37327
          DataBinding.FieldName = 'KWMENG'
        end
        object cxView1Column16: TcxGridDBColumn
          Caption = #21487#25552#25968#37327
          DataBinding.FieldName = 'ZAVA'
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
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #35746#21333#21015#34920
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
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
