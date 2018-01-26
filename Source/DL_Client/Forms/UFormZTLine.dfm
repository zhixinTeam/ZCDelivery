inherited fFormZTLine: TfFormZTLine
  Left = 536
  Top = 401
  Caption = #35013#36710#32447#37197#32622
  ClientHeight = 247
  ClientWidth = 550
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 550
    Height = 247
    inherited BtnOK: TButton
      Left = 404
      Top = 214
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 474
      Top = 214
      TabOrder = 12
    end
    object EditName: TcxTextEdit [2]
      Left = 354
      Top = 36
      Hint = 'T.Z_Name'
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 1
      Width = 110
    end
    object EditID: TcxTextEdit [3]
      Left = 81
      Top = 36
      Hint = 'T.Z_ID'
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 0
      Width = 210
    end
    object EditMax: TcxTextEdit [4]
      Left = 81
      Top = 111
      Hint = 'T.Z_QueueMax'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      TabOrder = 6
      Text = '3'
      Width = 210
    end
    object CheckValid: TcxCheckBox [5]
      Left = 11
      Top = 214
      Hint = 'T.Z_Valid'
      Caption = #36890#36947#26377#25928
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 10
      Transparent = True
      Width = 80
    end
    object EditStockName: TcxTextEdit [6]
      Left = 354
      Top = 61
      Hint = 'T.Z_Stock'
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object cxLabel2: TcxLabel [7]
      Left = 296
      Top = 111
      Caption = #27880': '#35813#21442#25968#29992#20110#25511#21046#27599#38431#26368#22810#26377#22810#23569#36710#36742'.'
      ParentFont = False
      Transparent = True
    end
    object EditPeer: TcxTextEdit [8]
      Left = 81
      Top = 136
      Hint = 'T.Z_PeerWeight'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      TabOrder = 8
      Text = '50'
      Width = 210
    end
    object cxLabel4: TcxLabel [9]
      Left = 296
      Top = 136
      Caption = #27880': '#35813#21442#25968#29992#20110#35013#36710#35745#25968#26102#35745#31639#34955#25968'.'
      ParentFont = False
      Transparent = True
    end
    object EditStockID: TcxComboBox [10]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ItemHeight = 20
      Properties.MaxLength = 20
      Properties.OnChange = EditStockIDPropertiesChange
      TabOrder = 2
      Width = 210
    end
    object EditType: TcxComboBox [11]
      Left = 81
      Top = 86
      Hint = 'T.Z_VIPLine'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 20
      Properties.Items.Strings = (
        '1.'#26222#36890
        '2.VIP'
        '3.'#26632#21488
        '4.'#33337#36816)
      TabOrder = 4
      Text = '1.'#26222#36890
      Width = 210
    end
    object cxLabel5: TcxLabel [12]
      Left = 296
      Top = 86
      Caption = #27880': '#35813#21442#25968#24433#21709#36827#38431#21015#30340#21457#36135#21333#31867#22411'.'
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object LayItem1: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #26632#21488#32534#21495':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #26632#21488#21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item21: TdxLayoutItem
            Caption = #21697#31181#32534#21495':'
            Control = EditStockID
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21697#31181#21517#31216':'
            Control = EditStockName
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group10: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item3: TdxLayoutItem
              Caption = #26632#21488#31867#22411':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item22: TdxLayoutItem
              AutoAligns = [aaVertical]
              ShowCaption = False
              Control = cxLabel5
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group12: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item4: TdxLayoutItem
              Caption = #38431#21015#23481#37327':'
              Control = EditMax
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              Caption = 'cxLabel2'
              ShowCaption = False
              Control = cxLabel2
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Group9: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item19: TdxLayoutItem
            Caption = #21333#34955#37325#37327':'
            Control = EditPeer
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item20: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel4
            ControlOptions.ShowBorder = False
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item7: TdxLayoutItem [0]
          ShowCaption = False
          Control = CheckValid
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
