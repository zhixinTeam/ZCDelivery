inherited fFramePoundManual: TfFramePoundManual
  Width = 872
  Height = 519
  object WorkPanel: TScrollBox
    Left = 0
    Top = 0
    Width = 872
    Height = 249
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
    Top = 249
    Width = 872
    Height = 8
    HotZoneClassName = 'TcxXPTaskBarStyle'
    AlignSplitter = salBottom
    Control = cxGrid1
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 257
    Width = 872
    Height = 262
    Align = alBottom
    BorderStyle = cxcbsNone
    TabOrder = 2
    object cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxLevel1: TcxGridLevel
      GridView = cxView1
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 16
    Top = 14
  end
  object SQLQuery: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 4
    Top = 298
  end
  object DataSource1: TDataSource
    DataSet = SQLQuery
    Left = 32
    Top = 298
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 326
    object N1: TMenuItem
      Caption = #21047#26032#25968#25454
      OnClick = N1Click
    end
  end
end
