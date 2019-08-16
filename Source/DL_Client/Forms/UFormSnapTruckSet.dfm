inherited fFormSnapTruckSet: TfFormSnapTruckSet
  Left = 312
  Top = 312
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 133
  ClientWidth = 299
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 299
    Height = 133
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 139
      Top = 93
      Width = 72
      Height = 22
      Caption = #30830#23450
      TabOrder = 2
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 216
      Top = 93
      Width = 72
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 3
    end
    object cxComboBox1: TcxComboBox
      Left = 93
      Top = 61
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #21551#29992
        #20572#29992)
      Properties.OnChange = cxComboBox1PropertiesChange
      TabOrder = 1
      Text = #21551#29992
      Width = 121
    end
    object cxbPost: TcxComboBox
      Left = 93
      Top = 36
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cxbPostPropertiesChange
      TabOrder = 0
      Width = 121
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #36710#29260#35782#21035#25511#21046
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #23703#20301':'
          Control = cxbPost
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item2: TdxLayoutItem
          Caption = #20999#25442#27169#24335#20026':'
          Control = cxComboBox1
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
