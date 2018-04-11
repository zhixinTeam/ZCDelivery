inherited fFormSaleKwOther: TfFormSaleKwOther
  Left = 275
  Top = 100
  ClientHeight = 359
  ClientWidth = 711
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 711
    Height = 359
    inherited BtnOK: TButton
      Left = 565
      Top = 326
      Caption = #20462#25913
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 635
      Top = 326
      TabOrder = 5
    end
    object ListQuery: TcxListView [2]
      Left = 11
      Top = 11
      Width = 529
      Height = 151
      Align = alClient
      Columns = <
        item
          Caption = #30917#21333#32534#21495
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
          Caption = #25552#36135#21333#21495
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
    object EditPValue: TcxTextEdit [3]
      Left = 81
      Top = 217
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object EditMValue: TcxTextEdit [4]
      Left = 81
      Top = 242
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object EditTruck: TcxTextEdit [5]
      Left = 81
      Top = 192
      ParentFont = False
      TabOrder = 1
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
      end
    end
  end
end
