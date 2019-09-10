object ROModule: TROModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 345
  Top = 450
  Height = 178
  Width = 327
  object ROBinMsg: TROBinMessage
    Envelopes = <>
    Left = 96
    Top = 14
  end
  object ROSOAPMsg: TROSOAPMessage
    Envelopes = <>
    SerializationOptions = [xsoSendUntyped, xsoStrictStructureFieldOrder, xsoDocument, xsoSplitServiceWsdls]
    Left = 96
    Top = 66
  end
  object ROHttp1: TROIndyHTTPServer
    Dispatchers = <
      item
        Name = 'ROBinMsg'
        Message = ROBinMsg
        Enabled = True
        PathInfo = 'Bin'
      end
      item
        Name = 'ROSOAPMsg'
        Message = ROSOAPMsg
        Enabled = True
        PathInfo = 'SOAP'
      end>
    OnAfterServerActivate = ROHttp1AfterServerActivate
    OnAfterServerDeactivate = ROHttp1AfterServerActivate
    IndyServer.Bindings = <>
    IndyServer.DefaultPort = 8099
    IndyServer.OnConnect = ROHttp1InternalIndyServerConnect
    IndyServer.OnDisconnect = ROHttp1InternalIndyServerDisconnect
    Port = 8099
    Left = 30
    Top = 16
  end
  object ROTcp1: TROIndyTCPServer
    Dispatchers = <
      item
        Name = 'ROBinMsg'
        Message = ROBinMsg
        Enabled = True
      end>
    OnAfterServerActivate = ROHttp1AfterServerActivate
    OnAfterServerDeactivate = ROHttp1AfterServerActivate
    IndyServer.Bindings = <>
    IndyServer.DefaultPort = 8090
    IndyServer.OnConnect = ROTcp1InternalIndyServerConnect
    IndyServer.OnDisconnect = ROTcp1InternalIndyServerDisconnect
    Port = 8090
    Left = 30
    Top = 68
  end
end
