inherited fFramePoundAuto: TfFramePoundAuto
  Width = 872
  Height = 519
  object WorkPanel: TScrollBox
    Left = 0
    Top = 0
    Width = 872
    Height = 246
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnMouseWheel = WorkPanelMouseWheel
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 246
    Width = 872
    Height = 8
    HotZoneClassName = 'TcxXPTaskBarStyle'
    AlignSplitter = salBottom
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 254
    Width = 872
    Height = 265
    Align = alBottom
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 16
    Top = 14
  end
end
