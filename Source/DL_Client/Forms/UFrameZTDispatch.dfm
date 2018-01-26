inherited fFrameZTDispatch: TfFrameZTDispatch
  Width = 656
  Height = 395
  ParentBackground = False
  object Bevel1: TBevel
    Left = 0
    Top = 59
    Width = 656
    Height = 3
    Align = alTop
    Shape = bsSpacer
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 22
    Width = 656
    Height = 37
    ButtonHeight = 35
    ButtonWidth = 67
    EdgeBorders = []
    Flat = True
    Images = FDM.ImageBar
    ShowCaptions = True
    TabOrder = 0
    OnAdvancedCustomDraw = ToolBar1AdvancedCustomDraw
    object BtnAdd: TToolButton
      Left = 0
      Top = 0
      Caption = #35013#36710#32447
      ImageIndex = 20
      OnClick = BtnAddClick
    end
    object S1: TToolButton
      Left = 67
      Top = 0
      Width = 8
      Caption = 'S1'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object BtnPrint: TToolButton
      Left = 75
      Top = 0
      Caption = ' '#35843#24230#27169#24335' '
      ImageIndex = 19
      OnClick = BtnPrintClick
    end
    object BtnRefresh: TToolButton
      Left = 142
      Top = 0
      Caption = #21047#26032
      ImageIndex = 14
      OnClick = BtnRefreshClick
    end
    object S3: TToolButton
      Left = 209
      Top = 0
      Width = 8
      Caption = 'S3'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object BtnExit: TToolButton
      Left = 217
      Top = 0
      Caption = #20851#38381
      ImageIndex = 7
      OnClick = BtnExitClick
    end
  end
  object TitlePanel1: TZnBitmapPanel
    Left = 0
    Top = 0
    Width = 656
    Height = 22
    Align = alTop
    object TitleBar: TcxLabel
      Left = 0
      Top = 0
      Align = alClient
      AutoSize = False
      Caption = #26632#21488#35013#36710#35843#24230
      ParentFont = False
      Style.BorderStyle = ebsNone
      Style.Edges = [bBottom]
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.TextColor = clGray
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.LabelEffect = cxleExtrude
      Properties.LabelStyle = cxlsLowered
      Properties.ShadowedColor = clBlack
      Transparent = True
      Height = 22
      Width = 656
      AnchorX = 328
      AnchorY = 11
    end
  end
  object dxChart1: TdxOrgChart
    Left = 0
    Top = 62
    Width = 656
    Height = 333
    DefaultNodeWidth = 60
    DefaultNodeHeight = 32
    IndentX = 25
    IndentY = 32
    BorderStyle = bsNone
    Options = [ocSelect, ocDblClick, ocShowDrag, ocAnimate]
    OnCollapsing = dxChart1Collapsing
    OnExpanded = dxChart1Expanded
    Align = alClient
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    PopupMenu = PMenu1
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PMenu1Popup
    Left = 12
    Top = 90
    object N1: TMenuItem
      Caption = #20462#25913#36890#36947
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #31227#20986#38431#21015
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N5: TMenuItem
      Tag = 10
      Caption = #21551#29992#21943#30721#26426
      GroupIndex = 12
      RadioItem = True
      OnClick = N5Click
    end
    object N6: TMenuItem
      Tag = 20
      Caption = #20851#38381#21943#30721#26426
      GroupIndex = 12
      RadioItem = True
      OnClick = N5Click
    end
  end
end
