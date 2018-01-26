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
    Left = 28
    Top = 74
  end
  object SQLTemp: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 82
    Top = 74
  end
end
