object FDM: TFDM
  OldCreateOrder = False
  Left = 550
  Top = 431
  Height = 211
  Width = 299
  object ADOConn: TADOConnection
    LoginPrompt = False
    Left = 20
    Top = 97
  end
  object SQLQuery1: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 84
    Top = 95
  end
  object SQLTemp: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 142
    Top = 97
  end
  object QueryLocal: TADOQuery
    Connection = ADOLocal
    Parameters = <>
    Left = 86
    Top = 22
  end
  object ADOLocal: TADOConnection
    Left = 22
    Top = 22
  end
end
