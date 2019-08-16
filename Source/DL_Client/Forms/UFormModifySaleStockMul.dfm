inherited fFormModifySaleStockMul: TfFormModifySaleStockMul
  Left = 275
  Top = 100
  ClientHeight = 394
  ClientWidth = 717
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 717
    Height = 394
    inherited BtnOK: TButton
      Left = 571
      Top = 361
      Caption = #20462#25913
      Enabled = False
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 641
      Top = 361
      TabOrder = 8
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
      Top = 317
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 6
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
          Caption = #20928#37325
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
    object EditValue: TcxTextEdit [8]
      Left = 81
      Top = 292
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 121
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
        object dxLayout1Item10: TdxLayoutItem
          Caption = #22791'    '#27880':'
          Control = editMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
