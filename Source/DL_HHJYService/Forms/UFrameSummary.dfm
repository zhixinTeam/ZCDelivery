inherited fFrameSummary: TfFrameSummary
  Width = 620
  Height = 406
  object ListSummary: TZnValueList
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
  object TimerMon: TTimer
    OnTimer = TimerMonTimer
    Left = 12
    Top = 34
  end
end
