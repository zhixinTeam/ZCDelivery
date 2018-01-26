inherited fFormRFIDCard: TfFormRFIDCard
  Caption = #20851#32852#30005#23376#26631#31614
  ClientHeight = 148
  ClientWidth = 332
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 332
    Height = 148
    inherited BtnOK: TButton
      Left = 186
      Top = 115
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 256
      Top = 115
      TabOrder = 4
    end
    object edtTruck: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      Style.HotTrack = False
      TabOrder = 0
      Width = 121
    end
    object edtRFIDCard: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.ReadOnly = True
      Style.HotTrack = False
      TabOrder = 1
      Width = 121
    end
    object chkValue: TcxCheckBox [4]
      Left = 11
      Top = 115
      Caption = #21551#29992#30005#23376#26631#31614
      ParentFont = False
      State = cbsChecked
      Style.HotTrack = False
      TabOrder = 2
      Transparent = True
      Width = 105
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item6: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = edtTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30005#23376#26631#31614':'
          Control = edtRFIDCard
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem [0]
          Control = chkValue
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object tmrReadCard: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrReadCardTimer
    Left = 24
    Top = 80
  end
end
