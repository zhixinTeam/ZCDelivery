inherited fFormIncInfo: TfFormIncInfo
  Left = 270
  Top = 173
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 249
  ClientWidth = 358
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 358
    Height = 249
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth]
    LookAndFeel = FDM.dxLayoutWeb1
    object EditName: TcxTextEdit
      Left = 81
      Top = 36
      ParentFont = False
      TabOrder = 0
      Width = 209
    end
    object EditPhone: TcxTextEdit
      Left = 81
      Top = 61
      ParentFont = False
      TabOrder = 1
      Width = 121
    end
    object EditWeb: TcxTextEdit
      Left = 81
      Top = 111
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object EditMail: TcxTextEdit
      Left = 81
      Top = 86
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object EditAddr: TcxTextEdit
      Left = 81
      Top = 136
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditMemo: TcxMemo
      Left = 81
      Top = 161
      Align = alClient
      ParentFont = False
      Properties.ScrollBars = ssVertical
      TabOrder = 5
      Height = 40
      Width = 252
    end
    object BtnExit: TButton
      Left = 272
      Top = 213
      Width = 75
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 7
    end
    object BtnOK: TButton
      Left = 192
      Top = 213
      Width = 75
      Height = 22
      Caption = #30830#23450
      TabOrder = 6
      OnClick = BtnOKClick
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #20844#21496#20449#24687
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #20844#21496#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item2: TdxLayoutItem
          Caption = #20844#21496#30005#35805':'
          Control = EditPhone
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          Caption = #20844#21496#37038#31665':'
          Control = EditMail
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item3: TdxLayoutItem
          Caption = #20844#21496#32593#22336':'
          Control = EditWeb
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item5: TdxLayoutItem
          Caption = #20844#21496#22320#22336':'
          Control = EditAddr
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item6: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AutoAligns = [aaVertical]
        AlignHorz = ahRight
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button2'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item7: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahRight
          AlignVert = avBottom
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
