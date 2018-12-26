inherited fFormTruckOutOverTime: TfFormTruckOutOverTime
  Left = 312
  Top = 312
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 102
  ClientWidth = 291
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 291
    Height = 102
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 131
      Top = 68
      Width = 72
      Height = 22
      Caption = #30830#23450
      TabOrder = 2
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 208
      Top = 68
      Width = 72
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 3
    end
    object EditValue: TcxTextEdit
      Left = 105
      Top = 36
      TabOrder = 0
      Text = '10'
      Width = 121
    end
    object cxLabel1: TcxLabel
      Left = 231
      Top = 36
      Caption = #20998#38047
      ParentFont = False
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #27169#24335#29366#24577
        LayoutDirection = ldHorizontal
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #20986#21378#36229#26102#26102#38388':'
          Control = EditValue
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item2: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item5: TdxLayoutItem
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
