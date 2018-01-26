inherited fFormPassword: TfFormPassword
  Left = 312
  Top = 312
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 152
  ClientWidth = 266
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 266
    Height = 152
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object EditOld: TcxTextEdit
      Left = 81
      Top = 36
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 0
      Width = 158
    end
    object EditNext: TcxTextEdit
      Left = 81
      Top = 86
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 2
      Width = 121
    end
    object EditNew: TcxTextEdit
      Left = 81
      Top = 61
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 1
      Width = 166
    end
    object BtnOK: TButton
      Left = 106
      Top = 118
      Width = 72
      Height = 22
      Caption = #30830#23450
      TabOrder = 3
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 183
      Top = 118
      Width = 72
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 4
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #30331#24405#23494#30721
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #26087#23494#30721':'
          Control = EditOld
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item3: TdxLayoutItem
          Caption = #26032#23494#30721':'
          Control = EditNew
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item2: TdxLayoutItem
          Caption = #20877#36755#19968#27425':'
          Control = EditNext
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
