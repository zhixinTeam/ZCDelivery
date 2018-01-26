{*******************************************************************************
  作者: dmzn@163.com 2012-03-10
  描述: 高效选择有效业务通道,平衡负载

  备注:
  *.通道每12分钟更新一次,相应最快的作为首选.
  *.若通道在24小时内无响应,且没有心跳返回该地址的信息,则被删除.
*******************************************************************************}
unit UChannelChooser;

interface

uses
  Windows, Classes, ComCtrls, SysUtils, SyncObjs, IniFiles, UWaitItem,
  UMgrChannel, UBusinessConst, UBusinessWorker, UBusinessPacker,
  MIT_Service_Intf, ULibFun;

type
  TChannelChoolser = class;
  TChannelRefresher = class(TThread)
  private
    FOwner: TChannelChoolser;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
  protected
    procedure Execute; override;
    //刷新通道
  public
    constructor Create(AOwner: TChannelChoolser);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止线程
  end;

  TChannelURLItem = record
    FSrvURL: string;       //服务地址
    FLastAct: TDateTime;   //上次活动
    FEnable: Boolean;      //是否有效
  end;

  TChannelChoolser = class(Tobject)
  private
    FFileName: string;
    //配置文件
    FModified: Boolean;
    //改动标记
    FIsValid: Boolean;
    //服务有效
    FFirstOne: string;
    FActiveOne: string;
    //激活通道
    FWaiter: TWaitObject;
    //等待对象
    FLastCheck: Int64;
    FNumChecker: Integer;
    //探测线程
    FRefresher: TChannelRefresher;
    //更新线程
    FLockOuter: TCriticalSection;
    FLockInner: TCriticalSection;
    //同步锁
    FAutoLocalList: Boolean;
    FURLs: array of TChannelURLItem;
    //通道列表
    function URLValid(const nURL: string): Boolean;
    function URLExists(const nURL: string): Integer;
    //通道已存在
  public
    constructor Create(const nFileName: string);
    destructor Destroy; override;
    //创建释放
    procedure RWData(const nRead: Boolean; const nFile:string);
    //读写数据
    procedure AddChanels(const nURL: string; const nFlag: string = #13#10);
    procedure AddChannelURL(const nURL: string);
    //添加通道
    function GetChannelURL: string;
    //获取通道
    procedure StartRefresh;
    procedure StopRefresh;
    //起停更新
    property FileName: string read FFileName;
    property ChannelValid: Boolean read FIsValid;
    property ActiveURL: string read FActiveOne write FActiveOne;
    property AutoUpdateLocal: Boolean read FAutoLocalList write FAutoLocalList;
    //属性相关
  end;

var
  gChannelChoolser: TChannelChoolser = nil;
  //全局使用

implementation

const
  cSystem = 'System';
  cSrvURL = 'ServiceURL';

type
  TChannelChecker = class(TThread)
  private
    FOwner: TChannelChoolser;
    //拥有者
    FChannelURL: string;
    //通道地址
  protected
    procedure Execute; override;
    //探测通道
    procedure SetURLStatus(const nActive: Boolean);
    //设置状态
  public
    constructor Create(AOwner: TChannelChoolser; nURL: string);
    destructor Destroy; override;
    //创建释放
  end;

constructor TChannelChecker.Create(AOwner: TChannelChoolser; nURL: string);
begin
  inherited Create(False);
  FreeOnTerminate := True;

  FOwner := AOwner;
  FChannelURL := nURL;
  InterlockedIncrement(FOwner.FNumChecker);
end;

destructor TChannelChecker.Destroy;
begin
  inherited;

  with FOwner do
  try
    FLockInner.Enter;
    if (FFirstOne = '') and (FNumChecker <= 1) then
    begin
      FIsValid := False;
      FWaiter.Wakeup;
    end; //the last one
  finally
    FLockInner.Leave;
  end;

  InterlockedDecrement(FOwner.FNumChecker);
  //for counter
end;

//Date: 2012-3-10
//Parm: 活动状态
//Desc: 依据nActive设置通道状态
procedure TChannelChecker.SetURLStatus(const nActive: Boolean);
var nIdx: Integer;
begin
  with FOwner do
  try
    FLockInner.Enter;
    //sync lock

    for nIdx:=Low(FURLs) to High(FURLs) do
    with FURLs[nIdx] do
    begin
      if FSrvURL <> FChannelURL then Continue;

      if nActive then
      begin
        FEnable := True;
        FLastAct := Now();
      end else

      if Now() - FLastAct >= 1 then
      begin
        FEnable := False;
        FModified := True;
      end;
    end;
  finally
    FLockInner.Leave;
  end;
end;

procedure TChannelChecker.Execute;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nChannel: PChannelItem;
begin
  nList:= nil;
  nChannel := nil;

  with FOwner do
  try
    nChannel := gChannelManager.LockChannel(cBus_Channel_Connection);
    if not Assigned(nChannel) then Exit;

    with nChannel^ do
    try
      if not Assigned(FChannel) then
        FChannel := CoSrvConnection.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := FChannelURL;
      if not ISrvConnection(FChannel).Action(sSys_SweetHeart, nStr) then Exit;
      SetURLStatus(True);
    except
      SetURLStatus(False);
      Exit;
    end;

    FLockInner.Enter;
    try
      if FFirstOne = '' then
      begin
        FFirstOne := FChannelURL;
        FIsValid := True;
        FWaiter.Wakeup;
      end;
    finally
      FLockInner.Leave;
    end;

    if FAutoLocalList and (nStr <> '') then
    begin
      nStr := PackerDecodeStr(nStr);
      nList := TStringList.Create;
      nList.Text := nStr;

      for nIdx:=0 to nList.Count - 1 do
        AddChannelURL(nList[nIdx]);
      //xxxxx
    end;
  finally
    nList.Free;
    gChannelManager.ReleaseChannel(nChannel);
    //release channel
  end;
end;

//------------------------------------------------------------------------------
constructor TChannelRefresher.Create(AOwner: TChannelChoolser);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 1000 * 60 * 12;
end;

destructor TChannelRefresher.Destroy;
begin
  FWaiter.Free;
  inherited;
end;

procedure TChannelRefresher.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TChannelRefresher.Execute;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    FOwner.GetChannelURL;
    //to refresh
  except
    //ignor any error
  end;
end;

//------------------------------------------------------------------------------
constructor TChannelChoolser.Create(const nFileName: string);
begin
  FLastCheck := 0;
  FNumChecker := 0;
  FAutoLocalList := True;

  FIsValid := True;
  FModified := False;
  FFileName := nFileName;

  FWaiter := TWaitObject.Create;   
  FLockInner := TCriticalSection.Create;
  FLockOuter := TCriticalSection.Create;

  FRefresher := nil;
  RWData(True, FFileName);
end;

destructor TChannelChoolser.Destroy;
begin
  StopRefresh;
  //stop

  while FNumChecker > 0 do ;
  //wait for checker free

  if FModified then
    RWData(False, FFileName);
  //save data

  FWaiter.Free;
  FLockInner.Free;
  FLockOuter.Free;
  inherited;
end;

//Date: 2012-3-10
//Parm: 读写;文件
//Desc: 读写服务列表文件
procedure TChannelChoolser.RWData(const nRead: Boolean; const nFile: string);
var nStr,nTag: string;
    nIni: TIniFile;
    nIdx,nLen: Integer;
begin
  if nFile = '' then Exit;
  nIni := TIniFile.Create(nFile);

  with nIni do
  try
    FLockInner.Enter;
    //to lock
    
    if nRead then
    begin
      SetLength(FURLs, 0);
      FActiveOne := ReadString(cSystem, 'Active', '');

      nIdx := ReadInteger(cSystem, 'Number', 0);
      Dec(nIdx);

      while nIdx >= 0 do
      try
        nTag := '_' + IntToStr(nIdx);
        nStr := ReadString(cSrvURL, 'URL' + nTag, '');
        if (not URLValid(nStr)) or (URLExists(nStr) > -1) then Continue;
        
        nLen := Length(FURLs);
        SetLength(FURLs, nLen + 1);

        with FURLs[nLen] do
        begin
          FSrvURL := nStr;
          FEnable := True;

          nStr := ReadString(cSrvURL, 'Act' + nTag, DateTime2Str(Now));
          FLastAct := Str2DateTime(nStr);
        end;
      finally
        Dec(nIdx);
      end;

      if nFile = FFileName then
        FModified := False;
      //xxxxx
    end else
    begin
      EraseSection(cSrvURL);
      nLen := 0;

      for nIdx:=Low(FURLs) to High(FURLs) do
      begin
        if not FURLs[nIdx].FEnable then Continue;
        nStr := '_' + IntToStr(nLen);
        Inc(nLen);

        WriteString(cSrvURL, 'URL' + nStr, FURLs[nIdx].FSrvURL);
        WriteString(cSrvURL, 'Act' + nStr, DateTime2Str(FURLs[nIdx].FLastAct));
      end;

      WriteString(cSystem, 'Active', FActiveOne);
      WriteInteger(cSystem, 'Number', Length(FURLs));

      if nFile = FFileName then
        FModified := False;
      //xxxxx
    end;
  finally
    FLockInner.Leave;
    nIni.Free;
  end;
end;

//Date: 2012-3-11
//Parm: 服务地址
//Desc: 测试nURL格式是否合法
function TChannelChoolser.URLValid(const nURL: string): Boolean;
var nStr: string;
begin
  nStr := LowerCase(Copy(nURL, 1, 7));
  Result := nStr = 'http://';
end;

//Date: 2012-3-10
//Parm: 服务地址
//Desc: 检测nURL是否已存在
function TChannelChoolser.URLExists(const nURL: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=Low(FURLs) to High(FURLs) do
  if CompareText(nURL, FURLs[nIdx].FSrvURL) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Date: 2012-3-10
//Parm: 服务地址
//Desc: 添加一个远程服务地址
procedure TChannelChoolser.AddChannelURL(const nURL: string);
var nLen: Integer;
begin
  if not URLValid(nURL) then Exit;
  //invalid url

  FLockInner.Enter;
  try
    nLen := URLExists(nURL);
    if nLen < 0 then
    begin
      nLen := Length(FURLs);
      SetLength(FURLs, nLen + 1);
      FURLs[nLen].FSrvURL := nURL;
    end;

    with FURLs[nLen] do
    begin
      FEnable := True;
      FLastAct := Now;

      if FActiveOne = '' then
        FActiveOne := nURL;
      FModified := True;
    end;
  finally
    FLockInner.Leave;
  end;
end;

//Date: 2012-5-28
//Parm: 地址列表;分割符
//Desc: 添加以nFlag为标记的nURL地址列表
procedure TChannelChoolser.AddChanels(const nURL, nFlag: string);
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    if nFlag = #13#10 then
         nList.Text := nURL
    else nList.Text := StringReplace(nURL, nFlag, #13#10, [rfReplaceAll]);

    for nIdx:=0 to nList.Count - 1 do
      AddChannelURL(nList[nIdx]);
    //xxxxx
  finally
    nList.Free;
  end;
end;

//Desc: 使用多线程探测可用的服务地址
function TChannelChoolser.GetChannelURL: string;
var nIdx,nNum: Integer;
begin
  FLockOuter.Enter;
  try
    Result := FActiveOne;
    if FNumChecker > 0 then Exit;
    if GetTickCount - FLastCheck < 60 * 1000 then Exit;

    FLockInner.Enter;
    try
      nNum := 0;
      FFirstOne := '';

      for nIdx:=Low(FURLs) to High(FURLs) do
      if FURLs[nIdx].FEnable then
      begin
        TChannelChecker.Create(Self, FURLs[nIdx].FSrvURL);
        Inc(nNum);
      end;
    finally
      FLockInner.Leave;
    end;

    if nNum > 0 then
    begin
      FWaiter.EnterWait;
      //wait check result

      FLockInner.Enter;
      try
        if (FFirstOne <> '') and
           (CompareText(FFirstOne, FActiveOne) <> 0) then
        begin
          FActiveOne := FFirstOne;
          Result := FFirstOne;
          FModified := True;
        end;
      finally
        FLockInner.Leave;
      end;
    end;

    FLastCheck := GetTickCount;
  finally
    FLockOuter.Leave;
  end;
end;

procedure TChannelChoolser.StartRefresh;
begin
  if not Assigned(FRefresher) then
   if Length(FURLs) > 0 then
    FRefresher := TChannelRefresher.Create(Self);
  //xxxxx
end;

procedure TChannelChoolser.StopRefresh;
begin
  if Assigned(FRefresher) then
  begin
    FRefresher.StopMe;
    FRefresher := nil;
  end;

  while FNumChecker > 0 do
    Sleep(1);
  //wait for release
end;

initialization
  gChannelChoolser := nil;
finalization
  FreeAndNil(gChannelChoolser);
end.


