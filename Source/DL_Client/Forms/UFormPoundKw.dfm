inherited fFormPoundKw: TfFormPoundKw
  Left = 293
  Top = 114
  ClientHeight = 554
  ClientWidth = 815
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 815
    Height = 554
    inherited BtnOK: TButton
      Left = 669
      Top = 521
      Caption = #20462#25913
      TabOrder = 14
    end
    inherited BtnExit: TButton
      Left = 739
      Top = 521
      TabOrder = 15
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
    object EditProvider: TcxTextEdit [4]
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
      Top = 442
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 11
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
          Caption = #30003#35831#21333#21495
          Width = 110
        end
        item
          Caption = #30382#37325
          Width = 46
        end
        item
          Caption = #27611#37325
          Width = 46
        end
        item
          Caption = #22411#21495
        end
        item
          Caption = #33337#21495
          Width = 80
        end
        item
          Caption = #35760#36134#24180#26376
          Width = 70
        end
        item
          Caption = #30719#28857
          Width = 110
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
    object EditModel: TcxTextEdit [7]
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
      Top = 392
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 9
      Width = 121
    end
    object EditMValue: TcxTextEdit [9]
      Left = 81
      Top = 417
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 10
      Width = 121
    end
    object chkReSync: TcxCheckBox [10]
      Left = 23
      Top = 467
      Caption = #20462#25913#23436#25104#21518#37325#26032#19978#20256
      ParentFont = False
      TabOrder = 12
      Width = 149
    end
    object cxLabel1: TcxLabel [11]
      Left = 177
      Top = 467
      Caption = '('#27880#24847':'#21246#36873#27492#36873#39033#21069#35831#30830#35748#21407#22987#30917#21333#22312'ERP'#24050#32463#34987#27880#38144')'
      ParentFont = False
      Style.TextColor = clRed
    end
    object EditShip: TcxTextEdit [12]
      Left = 81
      Top = 367
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 8
      Width = 121
    end
    object EditTruck: TcxTextEdit [13]
      Left = 81
      Top = 342
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Width = 121
    end
    object EditYear: TcxTextEdit [14]
      Left = 81
      Top = 292
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 121
    end
    object EditKD: TcxTextEdit [15]
      Left = 81
      Top = 317
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 6
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
          Caption = #20379' '#24212' '#21830':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #21407' '#26448' '#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #22411'    '#21495':'
          Control = EditModel
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem
          Caption = #35760#36134#24180#26376':'
          Control = EditYear
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = #30719'    '#28857':'
          Control = EditKD
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item13: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          Caption = #33337'    '#21495':'
          Control = EditShip
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
