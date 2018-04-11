object FDM: TFDM
  OldCreateOrder = False
  Left = 300
  Top = 286
  Height = 211
  Width = 299
  object ADOConn: TADOConnection
    LoginPrompt = False
    Left = 28
    Top = 20
  end
  object SQLQuery1: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 82
    Top = 20
  end
  object SqlTemp: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 136
    Top = 16
  end
  object SqlQuery: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 184
    Top = 24
  end
  object Command: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 24
    Top = 72
  end
  object dxPrinter1: TdxComponentPrinter
    CurrentLink = dxGridLink1
    Version = 0
    Left = 112
    Top = 72
    object dxGridLink1: TdxGridReportLink
      PrinterPage.DMPaper = 9
      PrinterPage.Footer = 6350
      PrinterPage.Header = 6350
      PrinterPage.Margins.Bottom = 12700
      PrinterPage.Margins.Left = 12700
      PrinterPage.Margins.Right = 12700
      PrinterPage.Margins.Top = 12700
      PrinterPage.PageSize.X = 210000
      PrinterPage.PageSize.Y = 297000
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 2
      BuiltInReportLink = True
    end
  end
end
