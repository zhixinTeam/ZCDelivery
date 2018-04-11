inherited fFormModifyStock: TfFormModifyStock
  Left = 347
  Top = 12
  ClientHeight = 621
  ClientWidth = 730
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 730
    Height = 621
    inherited BtnOK: TButton
      Left = 584
      Top = 588
      Caption = #20462#25913
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 654
      Top = 588
      TabOrder = 10
    end
    object EditMate: TcxTextEdit [2]
      Left = 81
      Top = 424
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
      Top = 374
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
      Top = 399
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 121
    end
    object editMemo: TcxTextEdit [5]
      Left = 81
      Top = 549
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 8
      Width = 121
    end
    object ListQuery: TcxListView [6]
      Left = 11
      Top = 11
      Width = 496
      Height = 333
      Align = alClient
      Columns = <
        item
          Caption = #35746#21333#32534#21495
          Width = 100
        end
        item
          Caption = #36710#29260#21495
          Width = 80
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
      Top = 449
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 121
    end
    object EditShip: TcxTextEdit [8]
      Left = 81
      Top = 524
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Width = 121
    end
    object EditKD: TcxTextEdit [9]
      Left = 81
      Top = 499
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 121
    end
    object EditYear: TcxTextEdit [10]
      Left = 81
      Top = 474
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
        object dxLayout1Item8: TdxLayoutItem
          Caption = #35760#36134#24180#26376':'
          Control = EditYear
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #30719'    '#28857':'
          Control = EditKD
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #33337'    '#21495':'
          Control = EditShip
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
