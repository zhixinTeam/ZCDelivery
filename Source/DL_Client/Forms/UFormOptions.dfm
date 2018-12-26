inherited fFormOptions: TfFormOptions
  Left = 348
  Top = 164
  Width = 540
  Height = 423
  BorderStyle = bsSizeable
  Caption = #31995#32479#36873#39033
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label16: TLabel [0]
    Left = 31
    Top = 252
    Width = 66
    Height = 12
    Caption = #21253#35013#27491#35823#24046':'
  end
  object Label17: TLabel [1]
    Left = 221
    Top = 253
    Width = 198
    Height = 12
    Caption = '('#35831#36755#20837#23567#25968#20540'.'#20363#22914#35823#24046'1%'#23601#26159'0.01)'
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 524
    Height = 385
    inherited BtnOK: TButton
      Left = 378
      Top = 352
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 448
      Top = 352
      TabOrder = 2
    end
    object wPage: TcxPageControl [2]
      Left = 23
      Top = 36
      Width = 289
      Height = 193
      ActivePage = Sheet2
      ParentColor = False
      ShowFrame = True
      Style = 9
      TabOrder = 0
      TabSlants.Kind = skCutCorner
      OnChange = wPageChange
      ClientRectBottom = 192
      ClientRectLeft = 1
      ClientRectRight = 288
      ClientRectTop = 19
      object Sheet1: TcxTabSheet
        Caption = #26080#38656#21457#36135#21697#31181
        ImageIndex = 3
        object Label8: TLabel
          Left = 12
          Top = 210
          Width = 54
          Height = 12
          Caption = #21697#31181#32534#21495':'
        end
        object Label9: TLabel
          Left = 12
          Top = 235
          Width = 54
          Height = 12
          Caption = #21697#31181#21517#31216':'
        end
        object ListStockNF: TcxMCListBox
          Left = 0
          Top = 0
          Width = 287
          Height = 195
          Align = alTop
          HeaderSections = <
            item
              Text = #32534#21495
              Width = 240
            end
            item
              Text = #21517#31216
              Width = 240
            end>
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ItemHeight = 18
          ParentFont = False
          TabOrder = 0
        end
        object EditStockId2: TcxTextEdit
          Left = 70
          Top = 208
          ParentFont = False
          Properties.MaxLength = 50
          TabOrder = 1
          Width = 180
        end
        object BtnDel2: TcxButton
          Left = 250
          Top = 206
          Width = 55
          Height = 22
          Caption = #21024#38500
          TabOrder = 2
          OnClick = BtnDel2Click
        end
        object BtnAdd2: TcxButton
          Left = 250
          Top = 230
          Width = 55
          Height = 22
          Caption = #28155#21152
          TabOrder = 3
          OnClick = BtnAdd2Click
        end
        object EditStockName2: TcxTextEdit
          Left = 70
          Top = 232
          ParentFont = False
          Properties.MaxLength = 50
          TabOrder = 4
          Width = 180
        end
      end
      object Sheet2: TcxTabSheet
        Caption = #34955#35013#35823#24046#35774#32622
        ImageIndex = 5
        object ListDaiWuCha: TcxMCListBox
          Left = 0
          Top = 0
          Width = 287
          Height = 177
          Align = alTop
          HeaderSections = <
            item
              Alignment = taCenter
              Text = #36215#22987#21544#20301'('#21544')'
              Width = 80
            end
            item
              Alignment = taCenter
              Text = #32467#26463#21544#20301'('#21544')'
              Width = 80
            end
            item
              Alignment = taCenter
              Text = #27491#35823#24046
              Width = 80
            end
            item
              Alignment = taCenter
              Text = #36127#35823#24046
              Width = 80
            end
            item
              Alignment = taCenter
              Text = #25353#27604#20363#35745#31639
              Width = 80
            end
            item
              Alignment = taCenter
              Text = #30917#31449#32534#21495
              Width = 80
            end>
          ItemHeight = 18
          ParentFont = False
          TabOrder = 0
        end
        object EditStart: TcxTextEdit
          Left = 72
          Top = 180
          ParentFont = False
          TabOrder = 1
          Width = 121
        end
        object cxLabel1: TcxLabel
          Left = 8
          Top = 184
          Caption = #36215#22987#21544#20301':'
          ParentFont = False
          Style.Edges = []
        end
        object EditEnd: TcxTextEdit
          Left = 264
          Top = 180
          ParentFont = False
          TabOrder = 3
          Width = 121
        end
        object cxLabel2: TcxLabel
          Left = 200
          Top = 184
          Caption = #32467#26463#21544#20301':'
          ParentFont = False
          Style.Edges = []
        end
        object cxLabel3: TcxLabel
          Left = 8
          Top = 208
          Caption = #27491' '#35823' '#24046':'
          ParentFont = False
          Style.Edges = []
        end
        object EditZWC: TcxTextEdit
          Left = 72
          Top = 204
          ParentFont = False
          TabOrder = 6
          Width = 121
        end
        object cxLabel4: TcxLabel
          Left = 200
          Top = 208
          Caption = #36127' '#35823' '#24046':'
          ParentFont = False
          Style.Edges = []
        end
        object EditFWC: TcxTextEdit
          Left = 264
          Top = 204
          ParentFont = False
          TabOrder = 8
          Width = 121
        end
        object EditPercent: TcxCheckBox
          Left = 8
          Top = 235
          Caption = #25353#27604#20363#35745#31639': '#25353#27604#20363#35745#31639#26102',0.01'#34920#31034'1%;'#21542#21017','#20197'Kg'#20026#21333#20301'.'
          ParentFont = False
          TabOrder = 9
          Width = 350
        end
        object BtnAdd4: TcxButton
          Left = 384
          Top = 176
          Width = 60
          Height = 25
          Caption = #28155#21152
          TabOrder = 10
          OnClick = BtnAdd4Click
        end
        object BtnDel4: TcxButton
          Left = 384
          Top = 200
          Width = 60
          Height = 25
          Caption = #21024#38500
          TabOrder = 11
          OnClick = BtnDel4Click
        end
      end
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21442#25968#35774#32622
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxPageControl1'
          ShowCaption = False
          Control = wPage
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
