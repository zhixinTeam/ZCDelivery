inherited fFormTodoSend: TfFormTodoSend
  Left = 530
  Top = 295
  Width = 470
  Height = 298
  BorderStyle = bsSizeable
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 462
    Height = 271
    inherited BtnOK: TButton
      Left = 316
      Top = 238
      Caption = #21457#36865
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 386
      Top = 238
      Caption = #20851#38381
      ModalResult = 2
      TabOrder = 3
    end
    object EditPart: TcxComboBox [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 20
      TabOrder = 0
      Width = 121
    end
    object EditEvent: TcxMemo [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.MaxLength = 200
      Properties.ScrollBars = ssVertical
      TabOrder = 1
      Height = 146
      Width = 310
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #20107#20214#20869#23481
        object dxLayout1Item3: TdxLayoutItem
          Caption = #25509#25910#37096#38376':'
          Control = EditPart
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #20107#20214#20869#23481':'
          Control = EditEvent
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
