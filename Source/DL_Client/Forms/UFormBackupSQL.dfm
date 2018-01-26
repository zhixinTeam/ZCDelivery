inherited fFormBackupSQL: TfFormBackupSQL
  Left = 391
  Top = 219
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25968#25454#22791#20221
  ClientHeight = 282
  ClientWidth = 393
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 393
    Height = 282
    Align = alClient
    TabOrder = 0
    TabStop = False
    LookAndFeel = FDM.dxLayoutWeb1
    object EditLastName: TcxTextEdit
      Left = 81
      Top = 36
      TabStop = False
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 85
    end
    object EditName: TcxTextEdit
      Left = 81
      Top = 118
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 2
      Width = 85
    end
    object EditMemo: TcxMemo
      Left = 81
      Top = 168
      ParentFont = False
      Properties.MaxLength = 100
      Properties.ScrollBars = ssVertical
      TabOrder = 4
      Height = 67
      Width = 286
    end
    object EditLastTime: TcxTextEdit
      Left = 81
      Top = 61
      TabStop = False
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 135
    end
    object EditTime: TcxTextEdit
      Left = 81
      Top = 143
      TabStop = False
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 135
    end
    object BtnOK: TButton
      Left = 244
      Top = 247
      Width = 65
      Height = 22
      Caption = #24320#22987
      TabOrder = 5
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 314
      Top = 247
      Width = 65
      Height = 22
      Caption = #21462#28040
      TabOrder = 6
      OnClick = BtnExitClick
    end
    object dxLayout1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayout1Group5: TdxLayoutGroup
        Caption = #19978#27425#22791#20221
        object dxLayout1Item1: TdxLayoutItem
          Caption = #22791#20221#21517#31216':'
          Control = EditLastName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #22791#20221#26102#38388':'
          Control = EditLastTime
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group1: TdxLayoutGroup
        Caption = #26412#27425#22791#20221
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item2: TdxLayoutItem
            Caption = #22791#20221#21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #22791#20221#26102#38388':'
            Control = EditTime
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #22791#20221#25551#36848':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group4: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button2'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
