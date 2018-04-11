inherited fFormPoundKwOther: TfFormPoundKwOther
  Left = 433
  Top = 126
  ClientHeight = 439
  ClientWidth = 560
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 560
    Height = 439
    inherited BtnOK: TButton
      Left = 414
      Top = 406
      Caption = #20462#25913
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 484
      Top = 406
      TabOrder = 11
    end
    object EditMate: TcxTextEdit [2]
      Left = 81
      Top = 242
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 125
    end
    object EditProvider: TcxTextEdit [3]
      Left = 81
      Top = 192
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 121
    end
    object editMemo: TcxTextEdit [4]
      Left = 81
      Top = 342
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Width = 121
    end
    object ListQuery: TcxListView [5]
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
          Caption = #21407#26448#26009
          Width = 90
        end
        item
          Caption = #21457#36135#21333#20301
          Width = 150
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
    object EditPValue: TcxTextEdit [6]
      Left = 81
      Top = 292
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 121
    end
    object EditMValue: TcxTextEdit [7]
      Left = 81
      Top = 317
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 121
    end
    object chkReSync: TcxCheckBox [8]
      Left = 23
      Top = 367
      Caption = #20462#25913#23436#25104#21518#37325#26032#19978#20256
      ParentFont = False
      TabOrder = 8
      Width = 149
    end
    object cxLabel1: TcxLabel [9]
      Left = 177
      Top = 367
      Caption = '('#27880#24847':'#21246#36873#27492#36873#39033#21069#35831#30830#35748#21407#22987#30917#21333#22312'ERP'#24050#32463#34987#27880#38144')'
      ParentFont = False
      Style.TextColor = clRed
    end
    object EditTruck: TcxTextEdit [10]
      Left = 81
      Top = 267
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 121
    end
    object EditRec: TcxTextEdit [11]
      Left = 81
      Top = 217
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 2
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
        object dxlytmLayout1Item3: TdxLayoutItem
          Caption = #21457#36135#21333#20301':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #25910#36135#21333#20301':'
          Control = EditRec
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #21407' '#26448' '#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
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
      end
    end
  end
end
