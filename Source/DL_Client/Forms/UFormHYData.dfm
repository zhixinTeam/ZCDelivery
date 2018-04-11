inherited fFormHYData: TfFormHYData
  Left = 323
  Top = 208
  ClientHeight = 263
  ClientWidth = 473
  Constraints.MinHeight = 245
  Constraints.MinWidth = 460
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 473
    Height = 263
    inherited BtnOK: TButton
      Left = 327
      Top = 230
      Caption = #30830#23450
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 397
      Top = 230
      TabOrder = 9
    end
    object EditTruck: TcxTextEdit [2]
      Left = 81
      Top = 156
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 6
      OnKeyPress = EditTruckKeyPress
      Width = 147
    end
    object EditValue: TcxTextEdit [3]
      Left = 303
      Top = 156
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 7
      Width = 403
    end
    object EditSMan: TcxComboBox [4]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 35
      Properties.OnEditValueChanged = EditSManPropertiesEditValueChanged
      TabOrder = 0
      Width = 121
    end
    object EditCustom: TcxComboBox [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      TabOrder = 1
      OnKeyPress = EditCustomKeyPress
      Width = 121
    end
    object EditNo: TcxButtonEdit [6]
      Left = 303
      Top = 131
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNoPropertiesButtonClick
      TabOrder = 5
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditDate: TcxDateEdit [7]
      Left = 81
      Top = 131
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 4
      Width = 147
    end
    object EditName: TcxTextEdit [8]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 80
      TabOrder = 2
      Width = 121
    end
    object cxLabel2: TcxLabel [9]
      Left = 23
      Top = 111
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Vert = taBottomJustify
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 15
      Width = 466
      AnchorY = 126
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #19994' '#21153' '#21592':'
          Control = EditSMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustom
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #24320#21333#23458#25143':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #25552#36135#26085#26399':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27700#27877#32534#21495':'
            Control = EditNo
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#37327'('#21544'):'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
