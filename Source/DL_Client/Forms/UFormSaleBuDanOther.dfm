inherited fFormSaleBuDanOther: TfFormSaleBuDanOther
  Left = 275
  Top = 100
  ClientHeight = 364
  ClientWidth = 705
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 705
    Height = 364
    inherited BtnOK: TButton
      Left = 559
      Top = 331
      Caption = #30830#23450
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 629
      Top = 331
      TabOrder = 7
    end
    object ListQuery: TcxListView [2]
      Left = 11
      Top = 11
      Width = 529
      Height = 151
      Align = alClient
      Columns = <
        item
          Caption = #35746#21333#32534#21495':'
          Width = 110
        end
        item
          Caption = #25552#36135#21333#21495
          Width = 90
        end
        item
          Caption = #36710#29260#21495
          Width = 90
        end
        item
          Caption = #29289#26009#32534#21495
          Width = 80
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
          Caption = #23458#25143#21517#31216
          Width = 140
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
    object EditPValue: TcxTextEdit [3]
      Left = 81
      Top = 217
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object EditMValue: TcxTextEdit [4]
      Left = 81
      Top = 267
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditTruck: TcxTextEdit [5]
      Left = 81
      Top = 192
      ParentFont = False
      TabOrder = 1
      Width = 121
    end
    object EditPTime: TcxDateEdit [6]
      Left = 81
      Top = 242
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 3
      Width = 121
    end
    object EditMTime: TcxDateEdit [7]
      Left = 81
      Top = 292
      ParentFont = False
      Properties.Kind = ckDateTime
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
        Caption = #34917#21333#20449#24687
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
        object dxLayout1Item4: TdxLayoutItem
          Caption = #30382#37325#26102#38388':'
          Control = EditPTime
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #27611'    '#37325':'
          Control = EditMValue
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #27611#37325#26102#38388':'
          Control = EditMTime
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
