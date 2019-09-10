// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://www.hnzxtech.cn/wxplatform/ws/revicews?wsdl
// Encoding : UTF-8
// Version  : 1.0
// (2016/9/27 11:51:33 - 1.33.2.5)
// ************************************************************************ //

unit wechat_soap;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"



  // ************************************************************************ //
  // Namespace : http://ws.webservice.zhixin.com/
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : ReviceWSImplServiceSoapBinding
  // service   : ReviceWSImplService
  // port      : ReviceWSImplPort
  // URL       : http://www.hnzxtech.cn/wxplatform/ws/revicews
  // ************************************************************************ //
  ReviceWS = interface(IInvokable)
  ['{D55EC9EA-5462-0127-93DF-231DF6B5573E}']
    function  mainfuncs(const arg0: WideString; const arg1: WideString): WideString; stdcall;
  end;

function GetReviceWS(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ReviceWS;


implementation

function GetReviceWS(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ReviceWS;
const
  defWSDL = 'http://www.hnzxtech.cn/wxplatform/ws/revicews?wsdl';
  defURL  = 'http://www.hnzxtech.cn/wxplatform/ws/revicews';
  defSvc  = 'ReviceWSImplService';
  defPrt  = 'ReviceWSImplPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as ReviceWS);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  InvRegistry.RegisterInterface(TypeInfo(ReviceWS), 'http://ws.webservice.zhixin.com/', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ReviceWS), '');
//  InvRegistry.RegisterInvokeOptions(TypeInfo(ReviceWS), ioDocument);

end.