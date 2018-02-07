inherited fFormMaterails: TfFormMaterails
  Left = 476
  Top = 299
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 500
  ClientWidth = 465
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 120
  TextHeight = 15
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 465
    Height = 500
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object EditName: TcxTextEdit
      Left = 87
      Top = 73
      Hint = 'T.M_Name'
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 1
      OnKeyDown = FormKeyDown
      Width = 173
    end
    object EditMemo: TcxMemo
      Left = 87
      Top = 157
      Hint = 'T.M_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 6
      Height = 50
      Width = 335
    end
    object InfoList1: TcxMCListBox
      Left = 29
      Top = 308
      Width = 496
      Height = 131
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 105
        end
        item
          AutoSize = True
          Text = #20869#23481
          Width = 387
        end>
      ParentFont = False
      Style.BorderStyle = cbsOffice11
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 11
    end
    object InfoItems: TcxComboBox
      Left = 87
      Top = 252
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 30
      TabOrder = 7
      Width = 94
    end
    object EditInfo: TcxTextEdit
      Left = 87
      Top = 280
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 9
      Width = 113
    end
    object BtnAdd: TButton
      Left = 380
      Top = 252
      Width = 56
      Height = 22
      Caption = #28155#21152
      TabOrder = 8
      OnClick = BtnAddClick
    end
    object BtnDel: TButton
      Left = 380
      Top = 280
      Width = 56
      Height = 22
      Caption = #21024#38500
      TabOrder = 10
      OnClick = BtnDelClick
    end
    object BtnOK: TButton
      Left = 272
      Top = 458
      Width = 87
      Height = 28
      Caption = #20445#23384
      TabOrder = 12
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 364
      Top = 458
      Width = 87
      Height = 28
      Caption = #21462#28040
      TabOrder = 13
      OnClick = BtnExitClick
    end
    object cxTextEdit3: TcxTextEdit
      Left = 87
      Top = 101
      Hint = 'T.M_Unit'
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 2
      Text = #21544
      OnKeyDown = FormKeyDown
      Width = 115
    end
    object EditPrice: TcxTextEdit
      Left = 289
      Top = 101
      Hint = 'T.M_Price'
      HelpType = htKeyword
      HelpKeyword = 'D'
      ParentFont = False
      TabOrder = 3
      Text = '0'
      Width = 133
    end
    object EditPValue: TcxComboBox
      Left = 87
      Top = 129
      Hint = 'T.M_PrePValue'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'Y'#12289#20801#35768
        'N'#12289#31105#27490)
      TabOrder = 4
      Width = 115
    end
    object EditPTime: TcxTextEdit
      Left = 289
      Top = 129
      Hint = 'T.M_PrePTime'
      ParentFont = False
      TabOrder = 5
      Text = '1'
      Width = 151
    end
    object EditID: TcxTextEdit
      Left = 87
      Top = 45
      Hint = 'T.M_ID'
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 0
      OnKeyDown = FormKeyDown
      Width = 353
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #22522#26412#20449#24687
        object dxLayoutControl1Group9: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Item13: TdxLayoutItem
            Caption = #21407#26009#32534#21495':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item2: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21407#26009#21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item14: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #35745#37327#21333#20301':'
              Control = cxTextEdit3
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item1: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21333#20215'('#20803'/'#21544'):'
              Control = EditPrice
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Group8: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item3: TdxLayoutItem
            Caption = #39044#32622#30382#37325':'
            Control = EditPValue
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item12: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #39044#32622#26102#38480'('#22825'):'
            Control = EditPTime
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #38468#21152#20449#24687
        object dxLayoutControl1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20449' '#24687' '#39033':'
              Control = InfoItems
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group10: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item7: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20449#24687#20869#23481':'
              Control = EditInfo
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item9: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button2'
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Item5: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = InfoList1
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item10: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button3'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item11: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button4'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
