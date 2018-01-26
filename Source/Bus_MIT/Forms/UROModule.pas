{*******************************************************************************
  作者: dmzn@163.com 2012-3-6
  描述: 远程服务调用单元
*******************************************************************************}
unit UROModule;

{$I Link.Inc}
interface

uses
  SysUtils, Classes, SyncObjs, IdContext, uROServerIntf, uROClassFactories,
  uROIndyTCPServer, uROClient, uROServer, uROIndyHTTPServer, uROSOAPMessage,
  uROBinMessage;

type
  TROServerType = (stTcp, stHttp);
  TROServerTypes = set of TROServerType;
  //服务类型
  
  PROModuleStatus = ^TROModuleStatus;
  TROModuleStatus = record
    FSrvTCP: Boolean;
    FSrvHttp: Boolean;               //服务状态
    FNumTCPActive: Cardinal;
    FNumTCPTotal: Cardinal;
    FNumTCPMax: Cardinal;
    FNumHttpActive: Cardinal;
    FNumHttpMax: Cardinal;
    FNumHttpTotal: Cardinal;         //连接计数
    FNumConnection: Cardinal;
    FNumBusiness: Cardinal;          //请求计数
    FNumActionError: Cardinal;       //执行错误计数
  end;

  TROModule = class(TDataModule)
    ROBinMsg: TROBinMessage;
    ROSOAPMsg: TROSOAPMessage;
    ROHttp1: TROIndyHTTPServer;
    ROTcp1: TROIndyTCPServer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ROHttp1AfterServerActivate(Sender: TObject);
    procedure ROTcp1InternalIndyServerConnect(AContext: TIdContext);
    procedure ROHttp1InternalIndyServerConnect(AContext: TIdContext);
    procedure ROHttp1InternalIndyServerDisconnect(AContext: TIdContext);
    procedure ROTcp1InternalIndyServerDisconnect(AContext: TIdContext);
  private
    { Private declarations }
    FStatus: TROModuleStatus;
    //运行状态
    FSrvConnection: IROClassFactory;
    //连接服务类厂
    FSrvBusiness: IROClassFactory;
    //数据服务类厂
    FSyncLock: TCriticalSection;
    //同步锁
    procedure RegClassFactories;
    //注册类厂
    procedure UnregClassFactories;
    //反注册
    procedure WriteLog(const nLog: string);
    //记录日志
  public
    { Public declarations }
    function ActiveServer(const nServer: TROServerTypes; const nActive: Boolean;
     var nMsg: string): Boolean;
    //服务操作
    function IsServiceRun: Boolean;
    function LockModuleStatus: PROModuleStatus;
    procedure ReleaseStatusLock;
    //获取状态
  end;

var
  ROModule: TROModule;

implementation

{$R *.dfm}

uses
  UMgrParam, UMgrPlug, USysLoger, SrvBusiness_Impl, SrvConnection_Impl,
  MIT_Service_Invk;

procedure TROModule.DataModuleCreate(Sender: TObject);
begin
  FSrvConnection := nil;
  FSrvBusiness := nil;
  
  FillChar(FStatus, SizeOf(FStatus), #0);
  FSyncLock := TCriticalSection.Create;
end;

procedure TROModule.DataModuleDestroy(Sender: TObject);
begin
  UnregClassFactories;
  FreeAndNil(FSyncLock);
end;

procedure TROModule.WriteLog(const nLog: string);
begin
  gSysLoger.AddLog(TROModule, '远程服务模块', nLog);
end;

//Desc: 同步锁定模块状态
function TROModule.LockModuleStatus: PROModuleStatus;
begin
  FSyncLock.Enter;
  Result := @FStatus;
end;

//Desc: 释放模块同步锁
procedure TROModule.ReleaseStatusLock;
begin
  FSyncLock.Leave;
end;

//Desc: 服务器启动
procedure TROModule.ROHttp1AfterServerActivate(Sender: TObject);
begin
  with LockModuleStatus^ do
  begin
    FSrvTCP := ROTcp1.Active;
    FSrvHttp := ROHttp1.Active;
    ReleaseStatusLock;
  end;
end;

//Desc: TCP新连接
procedure TROModule.ROTcp1InternalIndyServerConnect(AContext: TIdContext);
begin
  with LockModuleStatus^ do
  begin
    FNumTCPTotal := FNumTCPTotal + 1;
    FNumTCPActive := FNumTCPActive + 1;

    if FNumTCPActive > FNumTCPMax then
      FNumTCPMax := FNumTCPActive;
    ReleaseStatusLock;
  end;
end;

//Desc: Http新连接
procedure TROModule.ROHttp1InternalIndyServerConnect(AContext: TIdContext);
begin
  with LockModuleStatus^ do
  begin
    FNumHttpTotal := FNumHttpTotal + 1;
    FNumHttpActive := FNumHttpActive + 1;

    if FNumHttpActive > FNumHttpMax then
      FNumHttpMax := FNumHttpActive;
    ReleaseStatusLock;
  end;
end;

//Desc: TCP断开
procedure TROModule.ROTcp1InternalIndyServerDisconnect(AContext: TIdContext);
begin
  with LockModuleStatus^ do
  begin
    FNumTCPActive := FNumTCPActive - 1;
    ReleaseStatusLock;
  end;
end;

//Desc: HTTP断开
procedure TROModule.ROHttp1InternalIndyServerDisconnect(AContext: TIdContext);
begin
  with LockModuleStatus^ do
  begin
    FNumHttpActive := FNumHttpActive - 1;
    ReleaseStatusLock;
  end;
end;

//Desc: 服务是否运行
function TROModule.IsServiceRun: Boolean;
begin
  with LockModuleStatus^ do
  begin
    Result := FSrvTCP or FSrvHttp;
    ReleaseStatusLock;
  end;
end;

//------------------------------------------------------------------------------
procedure Create_SrvBusiness(out anInstance : IUnknown);
begin
  anInstance := TSrvBusiness.Create;
end;

procedure Create_SrvConnection(out anInstance : IUnknown);
begin
  anInstance := TSrvConnection.Create;
end;

//Desc: 注册类厂
procedure TROModule.RegClassFactories;
begin
  UnregClassFactories;
  //unreg first

  with gParamManager.ActiveParam.FPerform^ do
  begin
    FSrvConnection := TROPooledClassFactory.Create('SrvConnection',
                Create_SrvConnection, TSrvConnection_Invoker,
                FPoolSizeConn, TRoPoolBehavior(FPoolBehaviorConn));
    FSrvBusiness := TROPooledClassFactory.Create('SrvBusiness',
                Create_SrvBusiness, TSrvBusiness_Invoker,
                FPoolSizeBusiness, TRoPoolBehavior(FPoolBehaviorBusiness));
  end;
end;

//Desc: 注销类厂
procedure TROModule.UnregClassFactories;
begin
  if Assigned(FSrvConnection) then
  begin
    UnRegisterClassFactory(FSrvConnection);
    FSrvConnection := nil;
  end;

  if Assigned(FSrvBusiness) then
  begin
    UnRegisterClassFactory(FSrvBusiness);
    FSrvBusiness := nil;
  end;
end;

//Date: 2010-8-7
//Parm: 服务类型;动作;提示信息
//Desc: 对nServer执行nActive动作
function TROModule.ActiveServer(const nServer: TROServerTypes;
  const nActive: Boolean; var nMsg: string): Boolean;
begin
  try
    if nActive and ((not ROTcp1.Active) and (not ROHttp1.Active)) then
    begin
      with gParamManager do
       if not (Assigned(ActiveParam) and Assigned(ActiveParam.FPerform)) then
        raise Exception.Create('无效的Active参数包.');
      //no active parameters
      
      if (FSrvConnection = nil) or (FSrvBusiness = nil) then
        RegClassFactories;
      gPlugManager.BeforeStartServer;
    end; //启动前准备

    if not nActive then
      gPlugManager.BeforeStopServer;
    //关闭前准备

    if stTcp in nServer then
    begin
      if nActive then
      begin
        ROTcp1.Active := False;
        ROTcp1.Port := gParamManager.ActiveParam.FPerform.FPortTCP;
      end;

      ROTcp1.Active := nActive;
    end;

    if stHttp in nServer then
    begin
      if nActive then
      begin
        ROHttp1.Active := False;
        ROHttp1.Port := gParamManager.ActiveParam.FPerform.FPortHttp;
      end;
      
      ROHttp1.Active := nActive;
    end;

    if ROTcp1.Active or ROHttp1.Active then
    begin
      gPlugManager.AfterServerStarted;
      //通知插件已启动
    end else
    begin
      UnregClassFactories;
      //卸载类厂
      gPlugManager.AfterStopServer;
      //关闭善后
    end;

    Result := True;
    nMsg := '';
  except
    on nE:Exception do
    begin
      Result := False;
      nMsg := nE.Message;
      WriteLog(nMsg);
    end;
  end;
end;

end.
