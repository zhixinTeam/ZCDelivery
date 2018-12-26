{*******************************************************************************
  作者: dmzn@163.com 2017-09-21
  描述: 中间件业务数据封包对象
*******************************************************************************}
unit UMITPacker;

interface

uses
  Windows, SysUtils, Classes, ULibFun, UBusinessPacker, UBusinessConst;

type
  TMITPackerBase = class(TBusinessPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  end;

  TMITQueryField = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;

  TMITBusinessCommand = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;

  TMITBusinessWebChat = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;

  TMITBusinessHHJY = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;

implementation

//Date: 2017-09-21
//Parm: 参数数据
//Desc: 对输入数据nData打包处理
procedure TMITPackerBase.DoPackIn(const nData: Pointer);
begin
  inherited;
  
  with FStrBuilder,PBWDataBase(nData)^ do
  begin
    Values['Worker'] := PackerName;
    Values['MSGNO'] := PackerEncode(FMsgNo);
    Values['KEY']   := PackerEncode(FKey);

    PackWorkerInfo(FStrBuilder, FFrom, 'Frm');
    PackWorkerInfo(FStrBuilder, FVia, 'Via');
    PackWorkerInfo(FStrBuilder, FFinal, 'Fin');
  end;
end;

//Date: 2017-09-21
//Parm: 字符数据
//Desc: 对nStr拆包处理
procedure TMITPackerBase.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PBWDataBase(nData)^ do
  begin
    PackerDecode(Values['MSGNO'], FMsgNO);
    PackerDecode(Values['KEY'], FKey);

    PackWorkerInfo(FStrBuilder, FFrom, 'Frm', False);
    PackWorkerInfo(FStrBuilder, FVia, 'Via', False);
    PackWorkerInfo(FStrBuilder, FFinal, 'Fin', False);
  end;
end;

//Date: 2017-09-21
//Parm: 结构数据
//Desc: 对结构数据nData打包处理
procedure TMITPackerBase.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PBWDataBase(nData)^ do
  begin
    Values['Worker'] := PackerName;
    Values['Result'] := BoolToStr(FResult);
    Values['ErrCode'] := PackerEncode(FErrCode);
    Values['ErrDesc'] := PackerEncode(FErrDesc);

    PackWorkerInfo(FStrBuilder, FFrom, 'Frm');
    PackWorkerInfo(FStrBuilder, FVia, 'Via');
    PackWorkerInfo(FStrBuilder, FFinal, 'Fin');
  end;
end;

//Date: 2017-09-21
//Parm: 字符数据
//Desc: 对nStr拆包处理
procedure TMITPackerBase.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PBWDataBase(nData)^ do
  begin
    if Values['Result'] = '' then
         FResult := False
    else FResult := StrToBool(Values['Result']);
    
    PackerDecode(Values['ErrCode'], FErrCode);
    PackerDecode(Values['ErrDesc'], FErrDesc);

    PackWorkerInfo(FStrBuilder, FFrom, 'Frm', False);
    PackWorkerInfo(FStrBuilder, FVia, 'Via', False);
    PackWorkerInfo(FStrBuilder, FFinal, 'Fin', False);
  end; 
end;

//------------------------------------------------------------------------------
class function TMITQueryField.PackerName: string;
begin
  Result := sBus_GetQueryField;
end;

procedure TMITQueryField.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerQueryFieldData(nData)^ do
  begin
    Values['Type'] := IntToStr(FType);
    Values['Data']   := PackerEncode(FData);
  end;
end;

procedure TMITQueryField.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerQueryFieldData(nData)^ do
  begin
    PackerDecode(Values['Type'], FType);
    PackerDecode(Values['Data'], FData);
  end;
end;

procedure TMITQueryField.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerQueryFieldData(nData)^ do
  begin
    Values['Type']   := IntToStr(FType);
    Values['Data']   := PackerEncode(FData);
  end;
end;

procedure TMITQueryField.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerQueryFieldData(nData)^ do
  begin
    PackerDecode(Values['Type'], FType);
    PackerDecode(Values['Data'], FData);
  end;
end;

//------------------------------------------------------------------------------
class function TMITBusinessCommand.PackerName: string;
begin
  Result := sBus_BusinessCommand;
end;

procedure TMITBusinessCommand.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerBusinessCommand(nData)^ do
  begin
    Values['Command'] := IntToStr(FCommand);
    Values['Data']    := PackerEncode(FData);
    Values['ExtParam']  := PackerEncode(FExtParam);
  end;
end;

procedure TMITBusinessCommand.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerBusinessCommand(nData)^ do
  begin
    PackerDecode(Values['Command'], FCommand);
    PackerDecode(Values['Data'], FData);
    PackerDecode(Values['ExtParam'], FExtParam);
  end;
end;

procedure TMITBusinessCommand.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerBusinessCommand(nData)^ do
  begin
    Values['Command'] := IntToStr(FCommand);
    Values['Data']    := PackerEncode(FData);
    Values['ExtParam']  := PackerEncode(FExtParam);
  end;
end;

procedure TMITBusinessCommand.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerBusinessCommand(nData)^ do
  begin
    PackerDecode(Values['Command'], FCommand);
    PackerDecode(Values['Data'], FData);
    PackerDecode(Values['ExtParam'], FExtParam);
  end;
end;

//------------------------------------------------------------------------------
class function TMITBusinessWebChat.PackerName: string;
begin
  Result := sBus_BusinessWebchat;
end;

procedure TMITBusinessWebChat.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerWebChatData(nData)^ do
  begin
    Values['Command'] := IntToStr(FCommand);
    Values['Data']    := PackerEncode(FData);
    Values['ExtParam']  := PackerEncode(FExtParam);
    Values['RemoteUL']  := PackerEncode(FRemoteUL);
  end;
end;

procedure TMITBusinessWebChat.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerWebChatData(nData)^ do
  begin
    PackerDecode(Values['Command'], FCommand);
    PackerDecode(Values['Data'], FData);
    PackerDecode(Values['ExtParam'], FExtParam);
    PackerDecode(Values['RemoteUL'], FRemoteUL);
  end;
end;

procedure TMITBusinessWebChat.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerWebChatData(nData)^ do
  begin
    Values['Command'] := IntToStr(FCommand);
    Values['Data']    := PackerEncode(FData);
    Values['ExtParam']  := PackerEncode(FExtParam);
    Values['RemoteUL']  := PackerEncode(FRemoteUL);
  end;
end;

procedure TMITBusinessWebChat.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerWebChatData(nData)^ do
  begin
    PackerDecode(Values['Command'], FCommand);
    PackerDecode(Values['Data'], FData);
    PackerDecode(Values['ExtParam'], FExtParam);
    PackerDecode(Values['RemoteUL'], FRemoteUL);
  end;
end;

//------------------------------------------------------------------------------
class function TMITBusinessHHJY.PackerName: string;
begin
  Result := sBus_BusinessHHJY;
end;

procedure TMITBusinessHHJY.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerHHJYData(nData)^ do
  begin
    Values['Command'] := IntToStr(FCommand);
    Values['Data']    := PackerEncode(FData);
    Values['ExtParam']  := PackerEncode(FExtParam);
    Values['RemoteUL']  := PackerEncode(FRemoteUL);
  end;
end;

procedure TMITBusinessHHJY.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerHHJYData(nData)^ do
  begin
    PackerDecode(Values['Command'], FCommand);
    PackerDecode(Values['Data'], FData);
    PackerDecode(Values['ExtParam'], FExtParam);
    PackerDecode(Values['RemoteUL'], FRemoteUL);
  end;
end;

procedure TMITBusinessHHJY.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerHHJYData(nData)^ do
  begin
    Values['Command'] := IntToStr(FCommand);
    Values['Data']    := PackerEncode(FData);
    Values['ExtParam']  := PackerEncode(FExtParam);
    Values['RemoteUL']  := PackerEncode(FRemoteUL);
  end;
end;

procedure TMITBusinessHHJY.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerHHJYData(nData)^ do
  begin
    PackerDecode(Values['Command'], FCommand);
    PackerDecode(Values['Data'], FData);
    PackerDecode(Values['ExtParam'], FExtParam);
    PackerDecode(Values['RemoteUL'], FRemoteUL);
  end;
end;

initialization
  gBusinessPackerManager.RegistePacker(TMITQueryField, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITBusinessCommand, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITBusinessWebChat, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITBusinessHHJY, sPlug_ModuleBus);
end.
