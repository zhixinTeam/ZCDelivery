inherited fFormPurchaseOrder: TfFormPurchaseOrder
  Left = 451
  Top = 243
  ClientHeight = 396
  ClientWidth = 524
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 524
    Height = 396
    inherited BtnOK: TButton
      Left = 378
      Top = 363
      Caption = #24320#21333
      TabOrder = 16
    end
    inherited BtnExit: TButton
      Left = 448
      Top = 363
      TabOrder = 17
    end
    object EditValue: TcxTextEdit [2]
      Left = 320
      Top = 250
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 11
      Text = '0.00'
      OnKeyPress = EditLadingKeyPress
      Width = 138
    end
    object EditMate: TcxTextEdit [3]
      Left = 87
      Top = 86
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 125
    end
    object EditID: TcxTextEdit [4]
      Left = 87
      Top = 36
      ParentFont = False
      Properties.MaxLength = 100
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      OnKeyPress = EditLadingKeyPress
      Width = 125
    end
    object EditProvider: TcxTextEdit [5]
      Left = 87
      Top = 61
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditTruck: TcxButtonEdit [6]
      Left = 87
      Top = 250
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 7
      OnKeyPress = EditLadingKeyPress
      Width = 135
    end
    object EditCardType: TcxComboBox [7]
      Left = 87
      Top = 275
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        'L=L'#12289#20020#26102#21345
        'G=G'#12289#38271#26399#21345)
      Properties.OnChange = EditCardTypePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 8
      Width = 121
    end
    object cxLabel1: TcxLabel [8]
      Left = 262
      Top = 275
      Caption = #27880':'#20020#26102#21345#20986#21378#26102#22238#25910';'#22266#23450#21345#20986#21378#26102#19981#22238#25910
      ParentFont = False
    end
    object chkNeiDao: TcxCheckBox [9]
      Left = 23
      Top = 325
      AutoSize = False
      Caption = #20869#37096#20498#36816'('#30382#37325#12289#27611#37325#12289#30382#37325#12289#27611#37325'...)'
      ParentFont = False
      TabOrder = 10
      Height = 21
      Width = 234
    end
    object editMemo: TcxTextEdit [10]
      Left = 87
      Top = 186
      ParentFont = False
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 121
    end
    object EditOppositeValue: TcxTextEdit [11]
      Left = 87
      Top = 300
      ParentFont = False
      TabOrder = 9
      Text = '0.00'
      Width = 121
    end
    object dtexpiretime: TcxDateEdit [12]
      Left = 320
      Top = 321
      ParentFont = False
      TabOrder = 14
      Width = 121
    end
    object EditShip: TcxTextEdit [13]
      Left = 320
      Top = 296
      ParentFont = False
      TabOrder = 13
      Width = 121
    end
    object chkIfPrint: TcxCheckBox [14]
      Left = 11
      Top = 363
      Caption = #20986#21378#25171#21360#30917#21333
      ParentFont = False
      TabOrder = 15
      Width = 121
    end
    object EditModel: TcxTextEdit [15]
      Left = 87
      Top = 111
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 121
    end
    object EditKD: TcxTextEdit [16]
      Left = 87
      Top = 136
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 121
    end
    object EditYear: TcxTextEdit [17]
      Left = 87
      Top = 161
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #30003#35831#21333#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item3: TdxLayoutItem
          Caption = #20379' '#24212' '#21830':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #21407' '#26448' '#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem
          Caption = #22411'    '#21495':'
          Control = EditModel
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = #30719'    '#28857':'
          Control = EditKD
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item16: TdxLayoutItem
          Caption = #35760#36134#24180#26376':'
          Control = EditYear
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #22791'    '#27880':'
          Control = editMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #25552#21333#20449#24687
        LayoutDirection = ldHorizontal
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxlytmLayout1Item12: TdxLayoutItem
            Caption = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            Caption = #21345#29255#31867#22411':'
            Control = EditCardType
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item11: TdxLayoutItem
            Caption = #23545#26041#20132#36135#37327
            Control = EditOppositeValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = chkNeiDao
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = #21150#29702#21544#25968':'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item12: TdxLayoutItem
            Caption = #30721#22836#33337#21495':'
            Control = EditShip
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            Caption = #21040#26399#26102#38388':'
            Control = dtexpiretime
            ControlOptions.ShowBorder = False
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem [0]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = chkIfPrint
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
