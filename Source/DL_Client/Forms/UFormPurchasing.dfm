inherited fFormPurchasing: TfFormPurchasing
  Left = 374
  Top = 76
  Width = 486
  Height = 566
  BorderStyle = bsSizeable
  Caption = #36710#36742#20986#21378
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 470
    Height = 528
    inherited BtnOK: TButton
      Left = 324
      Top = 495
      Caption = #25918#34892
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 394
      Top = 495
      TabOrder = 8
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 314
      Height = 172
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 236
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      OnClick = ListInfoClick
    end
    object ListBill: TcxListView [3]
      Left = 23
      Top = 324
      Width = 350
      Height = 115
      Columns = <
        item
          Caption = #37319#36141#21333#21495
          Width = 80
        end
        item
          Alignment = taCenter
          Caption = #37319#36141#37327'('#21544')'
          Width = 100
        end
        item
          Caption = #27700#27877#31867#22411
          Width = 80
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 3
      ViewStyle = vsReport
      OnSelectItem = ListBillSelectItem
    end
    object EditCus: TcxTextEdit [4]
      Left = 105
      Top = 238
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 110
    end
    object EditBill: TcxTextEdit [5]
      Left = 105
      Top = 213
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 105
    end
    object EditKZValue: TcxTextEdit [6]
      Left = 105
      Top = 463
      ParentFont = False
      Properties.OnEditValueChanged = EditKZValuePropertiesEditValueChanged
      TabOrder = 4
      Width = 96
    end
    object EditMemo: TcxTextEdit [7]
      Left = 264
      Top = 463
      ParentFont = False
      Properties.OnEditValueChanged = EditKZValuePropertiesEditValueChanged
      TabOrder = 5
      Width = 176
    end
    object YSValid: TcxCheckBox [8]
      Left = 11
      Top = 495
      Caption = #25298#25910
      ParentFont = False
      TabOrder = 6
      Transparent = True
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #37319#36141#21333#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object LayItem1: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #37319#36141#21333#21495':'
            Control = EditBill
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #23458#25143#21517#31216':'
            Control = EditCus
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #37319#36141#21333#21015#34920
        object dxLayout1Item7: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxListView1'
          ShowCaption = False
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #20379#24212#25187#26434'('#21544'):'
            Control = EditKZValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Caption = #22791'    '#27880':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem [0]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = YSValid
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
