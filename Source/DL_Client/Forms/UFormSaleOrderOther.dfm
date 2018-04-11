inherited fFormSaleOrderOther: TfFormSaleOrderOther
  Left = 454
  Top = 216
  Caption = #20020#26102#35746#21333
  ClientHeight = 370
  ClientWidth = 509
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 509
    Height = 370
    inherited BtnOK: TButton
      Left = 363
      Top = 337
      Caption = #30830#23450
      TabOrder = 14
    end
    inherited BtnExit: TButton
      Left = 433
      Top = 337
      TabOrder = 15
    end
    object EditPAmount: TcxTextEdit [2]
      Left = 81
      Top = 191
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 7
      Text = '0'
      Width = 121
    end
    object cxLabel1: TcxLabel [3]
      Left = 23
      Top = 111
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Transparent = True
      Height = 10
      Width = 331
    end
    object EditFName: TcxTextEdit [4]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 2
      Width = 121
    end
    object EditMName: TcxComboBox [5]
      Left = 81
      Top = 126
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 4
      Width = 275
    end
    object EditType: TcxComboBox [6]
      Left = 81
      Top = 151
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 5
      Width = 275
    end
    object cxLabel2: TcxLabel [7]
      Left = 23
      Top = 176
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Transparent = True
      Height = 10
      Width = 331
    end
    object EditDAmount: TcxTextEdit [8]
      Left = 81
      Top = 216
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 8
      Text = '0'
      Width = 324
    end
    object EditOID: TcxTextEdit [9]
      Left = 81
      Top = 36
      ParentFont = False
      TabOrder = 0
      Width = 121
    end
    object EditSAmount: TcxTextEdit [10]
      Left = 81
      Top = 276
      ParentFont = False
      TabOrder = 12
      Text = '50'
      Width = 121
    end
    object ChkValid: TcxCheckBox [11]
      Left = 23
      Top = 301
      Caption = #35746#21333#26377#25928
      ParentFont = False
      State = cbsChecked
      TabOrder = 13
      Width = 217
    end
    object EditCName: TcxComboBox [12]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.IncrementalSearch = False
      Properties.OnChange = EditCNamePropertiesChange
      Style.Edges = [bBottom]
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 121
    end
    object EditFAmount: TcxTextEdit [13]
      Left = 81
      Top = 246
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 10
      Text = '0'
      Width = 121
    end
    object BtnDone: TButton [14]
      Left = 411
      Top = 216
      Width = 75
      Height = 25
      Caption = #35843#25972#23436#25104#37327
      TabOrder = 9
      OnClick = BtnDoneClick
    end
    object BtnFreeze: TButton [15]
      Left = 411
      Top = 246
      Width = 75
      Height = 25
      Caption = #35843#25972#20923#32467#37327
      TabOrder = 11
      OnClick = BtnFreezeClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem
          Caption = #35746#21333#32534#21495':'
          Control = EditOID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #23458#25143#21517#31216
          Control = EditCName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #29983#20135#22330#22320':'
          Control = EditFName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #29289#26009#21517#31216':'
          Control = EditMName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #21253#35013#31867#22411':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #35745#21010#25968#37327':'
          Control = EditPAmount
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item13: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #23436#25104#25968#37327':'
            Control = EditDAmount
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item15: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnDone
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item14: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20923#32467#25968#37327':'
            Control = EditFAmount
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item16: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button2'
            ShowCaption = False
            Control = BtnFreeze
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20572#21333#38480#20540':'
          Control = EditSAmount
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = ChkValid
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
