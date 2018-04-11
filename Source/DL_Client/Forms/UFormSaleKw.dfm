inherited fFormSaleKw: TfFormSaleKw
  Left = 275
  Top = 100
  ClientHeight = 562
  ClientWidth = 711
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 711
    Height = 562
    inherited BtnOK: TButton
      Left = 565
      Top = 529
      Caption = #20462#25913
      TabOrder = 15
    end
    inherited BtnExit: TButton
      Left = 635
      Top = 529
      TabOrder = 16
    end
    object EditMate: TcxTextEdit [2]
      Left = 81
      Top = 242
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 125
    end
    object EditID: TcxTextEdit [3]
      Left = 81
      Top = 192
      ParentFont = False
      Properties.MaxLength = 100
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 125
    end
    object EditCName: TcxTextEdit [4]
      Left = 81
      Top = 217
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 121
    end
    object editMemo: TcxTextEdit [5]
      Left = 81
      Top = 392
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 9
      Width = 121
    end
    object ListQuery: TcxListView [6]
      Left = 11
      Top = 11
      Width = 529
      Height = 151
      Align = alClient
      Columns = <
        item
          Caption = #25552#36135#21333#21495
          Width = 90
        end
        item
          Caption = #36710#29260#21495
          Width = 90
        end
        item
          Caption = #29289#26009#21517#31216
          Width = 90
        end
        item
          Caption = #21253#35013#26041#24335
          Width = 70
        end
        item
          Caption = #30003#35831#21333#21495
          Width = 110
        end
        item
          Caption = #23458#25143#21517#31216
          Width = 140
        end
        item
          Caption = #30382#37325
          Width = 46
        end
        item
          Caption = #27611#37325
          Width = 46
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      ViewStyle = vsReport
    end
    object EditType: TcxTextEdit [7]
      Left = 81
      Top = 267
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 121
    end
    object EditPValue: TcxTextEdit [8]
      Left = 81
      Top = 342
      ParentFont = False
      TabOrder = 7
      Width = 121
    end
    object EditMValue: TcxTextEdit [9]
      Left = 81
      Top = 367
      ParentFont = False
      TabOrder = 8
      Width = 121
    end
    object chkReSync: TcxCheckBox [10]
      Left = 23
      Top = 417
      Caption = #20462#25913#23436#25104#21518#37325#26032#19978#20256
      ParentFont = False
      TabOrder = 10
      Width = 149
    end
    object cxLabel1: TcxLabel [11]
      Left = 177
      Top = 417
      Caption = '('#27880#24847':'#21246#36873#27492#36873#39033#21069#35831#30830#35748#21407#22987#25552#36135#21333#22312'ERP'#24050#32463#34987#20316#24223',ERP'#20316#24223#27493#39588#22914#19979':)'
      ParentFont = False
      Style.TextColor = clRed
    end
    object EditValue: TcxTextEdit [12]
      Left = 81
      Top = 292
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 121
    end
    object EditTruck: TcxTextEdit [13]
      Left = 81
      Top = 317
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    object cxLabel2: TcxLabel [14]
      Left = 23
      Top = 443
      Caption = '1'#12289#22312'ERP'#36827#34892#38144#21806#21453#23457#26680#12290
      ParentFont = False
    end
    object cxLabel3: TcxLabel [15]
      Left = 23
      Top = 464
      Caption = '2'#12289#22312'ERP'#36827#34892#21457#36135#21453#23457#26680#12290
      ParentFont = False
    end
    object cxLabel4: TcxLabel [16]
      Left = 23
      Top = 485
      Caption = '3'#12289#22312'ERP'#36827#34892#25552#36135#21333#20316#24223#12290
      ParentFont = False
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      object dxLayout1Item3: TdxLayoutItem [0]
        Control = ListQuery
        ControlOptions.ShowBorder = False
      end
      inherited dxGroup1: TdxLayoutGroup
        AutoAligns = []
        Caption = #20462#25913#21518#20449#24687
        object dxLayout1Item5: TdxLayoutItem
          Caption = #30003#35831#21333#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item3: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #29289#26009#21517#31216':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #21253#35013#26041#24335':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          Caption = #35746#21333#20313#37327':'
          Control = EditValue
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item13: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30382'    '#37325':'
          Control = EditPValue
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #27611'    '#37325':'
          Control = EditMValue
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #22791'    '#27880':'
          Control = editMemo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = chkReSync
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item11: TdxLayoutItem
            Caption = 'cxLabel1'
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item14: TdxLayoutItem
          Caption = 'cxLabel2'
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = 'cxLabel3'
          ShowCaption = False
          Control = cxLabel3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item16: TdxLayoutItem
          Caption = 'cxLabel4'
          ShowCaption = False
          Control = cxLabel4
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
