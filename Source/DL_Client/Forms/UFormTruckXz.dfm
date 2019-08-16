inherited fFormTruckXz: TfFormTruckXz
  Left = 482
  Top = 252
  ClientHeight = 350
  ClientWidth = 414
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 414
    Height = 350
    inherited BtnOK: TButton
      Left = 268
      Top = 317
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 338
      Top = 317
      TabOrder = 10
    end
    object CheckValid: TcxCheckBox [2]
      Left = 23
      Top = 284
      Caption = #38480#36733#26377#25928
      ParentFont = False
      TabOrder = 8
      Transparent = True
      Width = 80
    end
    object EditDefXz: TcxTextEdit [3]
      Left = 81
      Top = 62
      ParentFont = False
      TabOrder = 1
      Text = '49'
      Width = 121
    end
    object ChkUseXz: TcxCheckBox [4]
      Left = 23
      Top = 36
      Caption = #21551#29992#36710#36742#38480#36733
      ParentFont = False
      TabOrder = 0
      Width = 121
    end
    object EditCus: TcxComboBox [5]
      Left = 81
      Top = 134
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.IncrementalSearch = False
      Properties.OnChange = EditCusPropertiesChange
      TabOrder = 2
      Width = 121
    end
    object EditXz: TcxTextEdit [6]
      Left = 81
      Top = 184
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditBegin: TcxTimeEdit [7]
      Left = 81
      Top = 209
      EditValue = 0d
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    object EditEnd: TcxTimeEdit [8]
      Left = 81
      Top = 234
      EditValue = 0.999988425925926d
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    object EditMemo: TcxTextEdit [9]
      Left = 81
      Top = 259
      ParentFont = False
      TabOrder = 7
      Width = 121
    end
    object EditType: TcxComboBox [10]
      Left = 81
      Top = 159
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 3
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #38480#36733#24635#25511#21046
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = ChkUseXz
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          Caption = #40664#35748#38480#36733':'
          Control = EditDefXz
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #38480#36733#21442#25968
        object dxLayout1Item5: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #36710#36724#31867#22411':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #38480#36733#21544#20301':'
          Control = EditXz
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #36215#22987#26102#38388':'
          Control = EditBegin
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #32467#26463#26102#38388':'
          Control = EditEnd
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #38480#36733#22791#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = CheckValid
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
