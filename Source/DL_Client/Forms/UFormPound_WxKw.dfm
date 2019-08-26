inherited fFormPound_WxKw: TfFormPound_WxKw
  Left = 293
  Top = 114
  ClientHeight = 391
  ClientWidth = 571
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 571
    Height = 391
    inherited BtnOK: TButton
      Left = 425
      Top = 358
      Caption = #20462#25913
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 495
      Top = 358
      TabOrder = 8
    end
    object EditStockNo: TcxTextEdit [2]
      Left = 81
      Top = 192
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 300
    end
    object editMemo: TcxTextEdit [3]
      Left = 81
      Top = 292
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 121
    end
    object ListQuery: TcxListView [4]
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
          Caption = #19994#21153#31867#22411
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
          Caption = #29289#26009#32534#21495
          Width = 80
        end
        item
          Caption = #29289#26009#21517#31216
          Width = 80
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
    object EditPValue: TcxTextEdit [5]
      Left = 81
      Top = 242
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 121
    end
    object EditMValue: TcxTextEdit [6]
      Left = 81
      Top = 267
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 121
    end
    object chkReSync: TcxCheckBox [7]
      Left = 23
      Top = 317
      Caption = #20462#25913#23436#25104#21518#37325#26032#19978#20256'              '
      ParentFont = False
      TabOrder = 6
      Width = 149
    end
    object EditTruck: TcxTextEdit [8]
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
        object dxLayout1Item9: TdxLayoutItem
          Caption = #29289#26009#32534#30721':'
          Control = EditStockNo
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
        object dxLayout1Item8: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = chkReSync
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
