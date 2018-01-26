inherited fFormNormal: TfFormNormal
  Left = 489
  Top = 305
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 129
  ClientWidth = 223
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 223
    Height = 129
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 77
      Top = 96
      Width = 65
      Height = 22
      Caption = #20445#23384
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 147
      Top = 96
      Width = 65
      Height = 22
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BtnExitClick
    end
    object dxLayout1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxGroup1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #22522#26412#20449#24687
      end
      object dxLayout1Group1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayout1Item1: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
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
