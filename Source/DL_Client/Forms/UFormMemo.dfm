inherited fFormMemo: TfFormMemo
  Left = 562
  Top = 312
  Width = 384
  Height = 241
  BorderStyle = bsSizeable
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 376
    Height = 214
    inherited BtnOK: TButton
      Left = 230
      Top = 181
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 300
      Top = 181
      TabOrder = 2
    end
    object Memo1: TcxMemo [2]
      Left = 23
      Top = 36
      ParentFont = False
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 0
      Height = 89
      Width = 185
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #22791#27880#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxMemo1'
          ShowCaption = False
          Control = Memo1
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        inherited dxLayout1Item1: TdxLayoutItem
          AutoAligns = []
          AlignVert = avBottom
        end
      end
    end
  end
end
