{*******************************************************************************
  作者: dmzn@163.com 2013-12-07
  描述: 常规业务处理工作对象
*******************************************************************************}
unit UPlugWorker;

{$I Link.Inc}
interface

uses
  Windows, Classes, SysUtils, ULibFun, UMgrDBConn, UBusinessWorker,
  UBusinessPacker, UBusinessConst;

type
  TPlugWorkerBase = class(TBusinessWorkerBase)
  protected
    FInBase: PBWDataBase;
    FOutBase: PBWDataBase;
    //入参出参
    FInInfo: TBWWorkerInfoType;
    FOutInfo: TBWWorkerInfoType;
    //对象信息
    FDataResult: string;
    //结果数据
    procedure SetIOData(const nIn,nOut: Pointer); virtual;
    procedure GetIOData(var nIn,nOut: Pointer); virtual;
    function DoPlugWork: Boolean; virtual; abstract;
    //子类业务
    procedure SetOutBaseInfo;
    //输出信息
  public
    class procedure SetResult(const nData: PBWDataBase; 
      const nResult: Boolean; const nCode,nDesc: string);
    //结果赋值
    function DoWork(var nData: string): Boolean; overload; override;
    function DoWork(const nIn,nOut: Pointer): Boolean; overload; override;
    //执行业务
  end;

  TPlugDBWorker = class(TPlugWorkerBase)
  protected
    FErrNum: Integer;
    //错误码
    FDBConn: PDBWorker;
    //数据通道
    FDataOutNeedUnPack: Boolean;
    //封包参数
    function VerifyParamIn: Boolean; virtual;
    //验证入参
    function DoAfterDBWork(const nResult: Boolean): Boolean; virtual;
    function DoDBWork: Boolean; virtual; abstract;
    //数据业务
  public
    function DoPlugWork: Boolean; override;
    //执行业务
  end;

implementation

uses
  UMgrParam, UEventWorker, USysLoger;

//Date: 2013-12-07
//Parm: 入参;出参
//Desc: 执行以nIn为入参的业务,输出nOut结果
function TPlugWorkerBase.DoWork(const nIn, nOut: Pointer): Boolean;
begin
  FInBase := nIn;
  FOutBase := nOut;

  FOutInfo := itFinal;
  SetIOData(FInBase, FOutBase);
  //delivery param

  FPacker.InitData(FOutBase, False, True, False);
  //init exclude base
  
  FOutBase^ := FInBase^;
  SetResult(FOutBase, True, 'S.00', '业务完成');

  Result := DoPlugWork;
  //do business

  SetOutBaseInfo;
  //fill woker info
end;

//Date: 2013-12-07
//Parm: 如参数护具
//Desc: 获取连接数据库所需的资源
function TPlugWorkerBase.DoWork(var nData: string): Boolean;
begin
  FOutInfo := itFinal;   
  GetIOData(Pointer(FInBase), Pointer(FOutBase));
  FPacker.UnPackIn(nData, FInBase);

  FPacker.InitData(FOutBase, False, True, False);
  //init exclude base
  
  FOutBase^ := FInBase^;
  SetResult(FOutBase, True, 'S.00', '业务完成');
  //default result
  
  Result := DoPlugWork;
  //do business

  if Result then
  begin
    SetOutBaseInfo;
    //fill woker info
    nData := FPacker.PackOut(FOutBase);
    //pack data
  end else
  begin
    nData := FDataResult;
    //return error message
  end;
end;

//Date: 2013-12-07
//Parm: 数据;结果;错误码;错误描述
//Desc: 设置nData的相关数据
class procedure TPlugWorkerBase.SetResult(const nData: PBWDataBase;
  const nResult: Boolean; const nCode,nDesc: string);
begin
  with nData^ do
  begin
    FResult := nResult;
    FErrCode := nCode;
    FErrDesc := nDesc;
  end;
end;

//Desc: 从子类获取入参出参
procedure TPlugWorkerBase.GetIOData(var nIn,nOut: Pointer);
var nStr: string;
begin
  nStr := '工作对象[ %s ]不支持远程调用.';
  nStr := Format(nStr, [FunctionName]);
  raise Exception.Create(nStr);
end;

//Desc: 设置子类入参出参
procedure TPlugWorkerBase.SetIOData(const nIn,nOut: Pointer);
var nStr: string;
begin
  nStr := '工作对象[ %s ]不支持本地调用.';
  nStr := Format(nStr, [FunctionName]);
  raise Exception.Create(nStr);
end;

//Desc: 填写输出信息
procedure TPlugWorkerBase.SetOutBaseInfo;
  procedure SetWorkerInfo(var nInfo: TBWWorkerInfo);
  begin
    with nInfo do
    begin
      FUser   := gPlugRunParam.FLocalName;
      FIP     := gPlugRunParam.FLocalIP;
      FMAC    := gPlugRunParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := GetTickCount - FWorkTimeInit;
    end;
  end;
begin
  case FOutInfo of
   itFrom  : SetWorkerInfo(FOutBase.FFrom);
   itVia   : SetWorkerInfo(FOutBase.FVia);
   itFinal : SetWorkerInfo(FOutBase.FFinal);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2013-12-07
//Desc: 获取连接数据库所需的资源
function TPlugDBWorker.DoPlugWork: Boolean;
begin
  Result := False;
  FDBConn := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      FDataResult := '连接[ %s ]数据库失败(ErrCode: %d).';
      FDataResult := Format(FDataResult, [FDB.FID, FErrNum]);
      
      SetResult(FOutBase, False, 'E.00', FDataResult);
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FDataOutNeedUnPack := False;
    //
    if not VerifyParamIn then Exit;
    //invalid input parameter

    Result := DoDBWork;
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(FDataResult, FOutBase);
      Result := DoAfterDBWork(True);
    end else DoAfterDBWork(False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
  end;
end;

//Desc: 数据库操作完毕后收尾业务
function TPlugDBWorker.DoAfterDBWork( const nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Desc: 验证入参是否有效
function TPlugDBWorker.VerifyParamIn: Boolean;
begin
  Result := True;
end;

end.
