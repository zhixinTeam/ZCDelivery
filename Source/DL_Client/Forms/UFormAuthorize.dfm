inherited fFormAuthorize: TfFormAuthorize
  Left = 530
  Top = 295
  Caption = #25509#20837#30003#35831
  ClientHeight = 359
  ClientWidth = 348
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 348
    Height = 359
    inherited BtnOK: TButton
      Left = 201
      Top = 326
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 272
      Top = 326
      TabOrder = 11
    end
    object EditName: TcxTextEdit [2]
      Left = 84
      Top = 56
      ParentFont = False
      Properties.MaxLength = 100
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 96
    end
    object EditMAC: TcxTextEdit [3]
      Left = 84
      Top = 29
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 0
      Width = 96
    end
    object EditFact: TcxTextEdit [4]
      Left = 84
      Top = 122
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 4
      Width = 96
    end
    object EditSerial: TcxTextEdit [5]
      Left = 84
      Top = 83
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 2
      Width = 96
    end
    object EditPoubdID: TcxTextEdit [6]
      Left = 84
      Top = 149
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    object EditDepart: TcxComboBox [7]
      Left = 84
      Top = 176
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      Properties.MaxLength = 32
      TabOrder = 6
      Width = 121
    end
    object cxLabel1: TcxLabel [8]
      Left = 24
      Top = 110
      AutoSize = False
      ParentFont = False
      Transparent = True
      Height = 6
      Width = 10
    end
    object EditMITURL: TcxComboBox [9]
      Left = 84
      Top = 215
      ParentFont = False
      Properties.ItemHeight = 20
      TabOrder = 8
      Width = 121
    end
    object EditHardURL: TcxComboBox [10]
      Left = 84
      Top = 242
      ParentFont = False
      Properties.ItemHeight = 20
      TabOrder = 9
      Width = 231
    end
    object cxLabel2: TcxLabel [11]
      Left = 24
      Top = 203
      AutoSize = False
      ParentFont = False
      Transparent = True
      Height = 6
      Width = 311
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          AllowRemove = False
          Caption = #30005#33041#26631#35782':'
          Control = EditMAC
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30005#33041#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30005#33041#32534#21495':'
          Control = EditSerial
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #24037#21378#32534#21495':'
          Control = EditFact
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #30917#31449#32534#21495':'
          Control = EditPoubdID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #25152#23646#37096#38376':'
          Control = EditDepart
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = #19994#21153#22320#22336':'
          Control = EditMITURL
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          Caption = #30828#20214#23432#25252':'
          Control = EditHardURL
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
