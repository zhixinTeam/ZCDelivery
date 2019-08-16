inherited fFormPMaterailControl: TfFormPMaterailControl
  Left = 482
  Top = 252
  ClientHeight = 248
  ClientWidth = 414
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 414
    Height = 248
    inherited BtnOK: TButton
      Left = 268
      Top = 215
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 338
      Top = 215
      TabOrder = 6
    end
    object CheckValid: TcxCheckBox [2]
      Left = 23
      Top = 182
      Caption = #25511#21046#26377#25928
      ParentFont = False
      TabOrder = 4
      Transparent = True
      Width = 80
    end
    object ChkUseControl: TcxCheckBox [3]
      Left = 23
      Top = 36
      Caption = #21551#29992#21407#26448#26009#36827#21378#25511#21046
      ParentFont = False
      TabOrder = 0
      Width = 121
    end
    object EditCus: TcxComboBox [4]
      Left = 81
      Top = 107
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.IncrementalSearch = False
      Properties.OnChange = EditCusPropertiesChange
      TabOrder = 1
      Width = 121
    end
    object EditMemo: TcxTextEdit [5]
      Left = 81
      Top = 157
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object EditStock: TcxComboBox [6]
      Left = 81
      Top = 132
      ParentFont = False
      Properties.OnChange = EditStockPropertiesChange
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21407#26448#26009#36827#21378#24635#25511#21046
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = ChkUseControl
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #25511#21046#21442#25968
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20379' '#24212' '#21830':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #21407' '#26448' '#26009':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #25511#21046#22791#27880':'
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
