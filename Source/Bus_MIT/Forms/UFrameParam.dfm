inherited fFrameParam: TfFrameParam
  Width = 620
  Height = 406
  Font.Height = -15
  object ListParam: TZnValueList
    Left = 0
    Top = 0
    Width = 620
    Height = 406
    Align = alClient
    BorderStyle = bsNone
    DefaultDrawing = False
    DefaultRowHeight = 22
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goColSizing, goThumbTracking]
    ParentFont = False
    PopupMenu = PMenu1
    TabOrder = 0
    OnDblClick = ListParamDblClick
    AutoFocus = True
    ColorGroup = 10475007
    ColorSelected = clSkyBlue
    SpaceGroup = 5
    SpaceItem = 15
    SpaceValue = 5
    ColWidths = (
      150
      468)
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 14
    Top = 40
    object N1: TMenuItem
      Tag = 10
      Caption = #21442#25968#32452
      OnClick = N1Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #25968#25454#24211
      Visible = False
      OnClick = N1Click
    end
    object N3: TMenuItem
      Tag = 30
      Caption = 'SAP'#37197#32622
      Visible = False
      OnClick = N1Click
    end
    object N4: TMenuItem
      Tag = 40
      Caption = #24615#33021#37197#32622
      OnClick = N1Click
    end
    object N5: TMenuItem
      Tag = 50
      Caption = #26381#21153#22320#22336
      OnClick = N1Click
    end
  end
end
