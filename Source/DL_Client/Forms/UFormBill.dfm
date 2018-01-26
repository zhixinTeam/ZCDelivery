inherited fFormBill: TfFormBill
  Left = 608
  Top = 168
  ClientHeight = 533
  ClientWidth = 468
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 468
    Height = 533
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 322
      Top = 500
      Caption = #24320#21333
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 392
      Top = 500
      TabOrder = 16
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 368
      Height = 224
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 290
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditValue: TcxTextEdit [3]
      Left = 289
      Top = 336
      ParentFont = False
      TabOrder = 6
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditTruck: TcxTextEdit [4]
      Left = 289
      Top = 311
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 4
      OnKeyPress = EditLadingKeyPress
      Width = 116
    end
    object EditStock: TcxComboBox [5]
      Left = 81
      Top = 336
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 15
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'B003=B003.'#29087#26009
        'B004=B004.'#27700#27877)
      TabOrder = 5
      OnKeyPress = EditLadingKeyPress
      Width = 145
    end
    object EditLading: TcxComboBox [6]
      Left = 81
      Top = 311
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'T=T'#12289#33258#25552
        'S=S'#12289#36865#36135
        'X=X'#12289#36816#21368)
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 145
    end
    object EditFQ: TcxTextEdit [7]
      Left = 289
      Top = 286
      ParentFont = False
      Properties.MaxLength = 100
      Properties.OnEditValueChanged = EditFQPropertiesEditValueChanged
      TabOrder = 2
      Width = 120
    end
    object EditType: TcxComboBox [8]
      Left = 81
      Top = 286
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'C=C'#12289#26222#36890
        'Z=Z'#12289#26632#21488
        'V=V'#12289'VIP'
        'S=S'#12289#33337#36816)
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 145
    end
    object PrintGLF: TcxCheckBox [9]
      Left = 11
      Top = 500
      Caption = #25171#21360#36807#36335#36153
      ParentFont = False
      TabOrder = 9
      Transparent = True
      Width = 95
    end
    object PrintHY: TcxCheckBox [10]
      Left = 111
      Top = 500
      Caption = #25171#21360#21270#39564#21333
      ParentFont = False
      TabOrder = 10
      Transparent = True
      Width = 95
    end
    object cxLabel1: TcxLabel [11]
      Left = 23
      Top = 361
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 8
      Width = 370
    end
    object EditPhone: TcxTextEdit [12]
      Left = 289
      Top = 374
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 7
      Width = 121
    end
    object EditUnloading: TcxMemo [13]
      Left = 81
      Top = 399
      ParentFont = False
      Properties.ScrollBars = ssVertical
      TabOrder = 8
      OnKeyPress = EditLadingKeyPress
      Height = 89
      Width = 185
    end
    object EditDate: TcxDateEdit [14]
      Left = 81
      Top = 374
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 17
      Width = 145
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #25552#21333#26126#32454
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #25552#36135#36890#36947':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20986#21378#32534#21495':'
              Control = EditFQ
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item12: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #25552#36135#26041#24335':'
              Control = EditLading
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item9: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #25552#36135#36710#36742':'
              Control = EditTruck
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #24211#23384#22320#28857':'
            Control = EditStock
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21150#29702#21544#25968':'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item15: TdxLayoutItem
            Caption = #34917#21333#26102#38388
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21496#26426#30005#35805':'
            Control = EditPhone
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = #21368#36135#22320#28857':'
          Control = EditUnloading
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem [0]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Visible = False
          Control = PrintGLF
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem [1]
          ShowCaption = False
          Control = PrintHY
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
