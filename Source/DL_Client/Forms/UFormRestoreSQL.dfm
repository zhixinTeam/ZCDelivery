inherited fFormRestoreSQL: TfFormRestoreSQL
  Left = 286
  Top = 161
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 296
  ClientWidth = 416
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 416
    Height = 296
    Align = alClient
    TabOrder = 0
    TabStop = False
    LookAndFeel = FDM.dxLayoutWeb1
    object EditName: TcxTextEdit
      Left = 81
      Top = 166
      ParentFont = False
      Properties.MaxLength = 30
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 100
    end
    object EditMemo: TcxMemo
      Left = 81
      Top = 191
      ParentFont = False
      Properties.MaxLength = 100
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 3
      Height = 58
      Width = 310
    end
    object EditTime: TcxTextEdit
      Left = 220
      Top = 166
      TabStop = False
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 135
    end
    object BtnOK: TButton
      Left = 268
      Top = 261
      Width = 65
      Height = 22
      Caption = #24320#22987
      TabOrder = 4
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 338
      Top = 261
      Width = 65
      Height = 22
      Caption = #21462#28040
      TabOrder = 5
      OnClick = BtnExitClick
    end
    object BackList1: TcxMCListBox
      Left = 23
      Top = 36
      Width = 368
      Height = 125
      HeaderSections = <
        item
          DataIndex = 1
          Text = #22791#20221#21517#31216
          Width = 74
        end
        item
          AutoSize = True
          DataIndex = 2
          Text = #22791#20221#26102#38388
          Width = 290
        end>
      ParentFont = False
      PopupMenu = PMenu1
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      OnClick = BackList1Click
    end
    object dxLayout1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayout1Group1: TdxLayoutGroup
        Caption = #25551#36848#20449#24687
        object dxLayout1Item8: TdxLayoutItem
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = BackList1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item2: TdxLayoutItem
            Caption = #22791#20221#21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #26102#38388':'
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
      object dxLayout1Group2: TdxLayoutGroup
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
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 34
    Top = 70
    object N1: TMenuItem
      Caption = #21047#26032
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #21024#38500
      OnClick = N2Click
    end
  end
end
