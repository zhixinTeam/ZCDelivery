object fFormNewPurchaseCard: TfFormNewPurchaseCard
  Left = 203
  Top = 70
  BorderStyle = bsNone
  Caption = #29992#25143#33258#21161#21150#21345
  ClientHeight = 540
  ClientWidth = 938
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 938
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 256
      Top = 56
      Width = 297
      Height = 29
      AutoSize = False
      Caption = '('#21487#24405#20837#25110#25195#25551#20108#32500#30721')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object labelIdCard: TcxLabel
      Left = 0
      Top = 8
      Caption = #21830#22478#36135#21333#21495#65306
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -32
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
    object editWebOrderNo: TcxTextEdit
      Left = 176
      Top = 8
      AutoSize = False
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -32
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      OnKeyPress = editWebOrderNoKeyPress
      Height = 41
      Width = 377
    end
    object btnQuery: TcxButton
      Left = 576
      Top = 8
      Width = 209
      Height = 73
      Caption = #26174#31034#32593#19978#36135#21333#35814#24773
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnQueryClick
    end
    object btnClear: TcxButton
      Left = 792
      Top = 8
      Width = 113
      Height = 73
      Caption = #28165#38500#36755#20837
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnClearClick
    end
  end
  object PanelBody: TPanel
    Left = 0
    Top = 193
    Width = 938
    Height = 347
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 938
      Height = 347
      Align = alClient
      TabOrder = 0
      TabStop = False
      object BtnOK: TButton
        Left = 321
        Top = 242
        Width = 250
        Height = 41
        Caption = #30830#35748#26080#35823#24182#21150#21345
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        OnClick = BtnOKClick
      end
      object BtnExit: TButton
        Left = 577
        Top = 242
        Width = 107
        Height = 41
        Caption = #21462#28040
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
        OnClick = BtnExitClick
      end
      object EditValue: TcxTextEdit
        Left = 399
        Top = 187
        ParentFont = False
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 7
        Width = 266
      end
      object EditProv: TcxTextEdit
        Left = 399
        Top = 28
        ParentFont = False
        Properties.MaxLength = 15
        Properties.ReadOnly = True
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 1
        Width = 265
      end
      object EditID: TcxTextEdit
        Left = 78
        Top = 28
        ParentFont = False
        Properties.MaxLength = 100
        Properties.ReadOnly = True
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 259
      end
      object EditProduct: TcxTextEdit
        Left = 78
        Top = 71
        ParentFont = False
        Properties.ReadOnly = True
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 2
        Width = 259
      end
      object EditTruck: TcxButtonEdit
        Left = 78
        Top = 187
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.ButtonStyle = bts3D
        Style.IsFontAssigned = True
        TabOrder = 6
        Width = 259
      end
      object EditYear: TcxTextEdit
        Left = 78
        Top = 114
        AutoSize = False
        ParentFont = False
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 4
        Height = 37
        Width = 259
      end
      object EditModel: TcxTextEdit
        Left = 399
        Top = 71
        AutoSize = False
        ParentFont = False
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 3
        Height = 37
        Width = 265
      end
      object EditKD: TcxTextEdit
        Left = 399
        Top = 114
        AutoSize = False
        ParentFont = False
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 5
        Height = 37
        Width = 265
      end
      object chkIfPrint: TcxCheckBox
        Left = 10
        Top = 242
        Caption = #20986#21378#25171#21360#30917#21333
        ParentFont = False
        State = cbsChecked
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 8
        Transparent = True
        Width = 305
      end
      object dxLayoutGroup1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
          AutoAligns = [aaVertical]
          Caption = #22522#26412#20449#24687
          object dxGroupLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              Caption = #21512#21516#21333#21495
              Control = EditID
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item9: TdxLayoutItem
              Caption = #20379'  '#24212'  '#21830
              Control = EditProv
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group1: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxlytmLayout1Item3: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #21407'  '#26448'  '#26009
              Control = EditProduct
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item3: TdxLayoutItem
              Caption = #22411'        '#21495
              Control = EditModel
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item1: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #35760#36134#24180#26376
              Control = EditYear
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item4: TdxLayoutItem
              Caption = #30719'        '#28857
              Control = EditKD
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxGroup2: TdxLayoutGroup
          AutoAligns = [aaVertical]
          Caption = #36135#21333#20449#24687
          LayoutDirection = ldHorizontal
          object dxlytmLayout1Item12: TdxLayoutItem
            Caption = #20379#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            Caption = #21150#29702#21544#25968':'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutGroup3: TdxLayoutGroup
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            ShowCaption = False
            Control = chkIfPrint
            ControlOptions.ShowBorder = False
          end
          object dxLayoutItem1: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Control = BtnOK
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item2: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Control = BtnExit
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
  object pnlMiddle: TPanel
    Left = 0
    Top = 89
    Width = 938
    Height = 104
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlMiddle'
    TabOrder = 2
    object cxLabel1: TcxLabel
      Left = 0
      Top = 0
      Align = alTop
      Caption = #36135#21333#21015#34920
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -19
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
    object lvOrders: TListView
      Left = 0
      Top = 28
      Width = 938
      Height = 76
      Align = alClient
      Columns = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      RowSelect = True
      ParentFont = False
      TabOrder = 1
    end
  end
  object TimerAutoClose: TTimer
    Enabled = False
    OnTimer = TimerAutoCloseTimer
    Left = 528
    Top = 89
  end
end
