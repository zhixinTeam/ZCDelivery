inherited fFramePlugs: TfFramePlugs
  Width = 620
  Height = 406
  object ListPlugs: TZnValueList
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
    OnPopup = PMenu1Popup
    Left = 4
    Top = 28
    object N1: TMenuItem
      Caption = #21368#36733#25554#20214
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #21047#26032#21015#34920
      OnClick = N3Click
    end
  end
end
