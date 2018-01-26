{*******************************************************************************
  作者: juner11212436@163.com 2017-12-1
  描述: 海康威门岗抓拍摄像机
*******************************************************************************}
unit UHKDoorSnap;

interface

uses
  Windows, Classes, SysUtils, SyncObjs, NativeXml, UWaitItem, USysLoger;

type
  PHKDoorSnapParam = ^THKDoorSnapParam;
  THKDoorSnapParam = record
    FID        : string;            //标识
    FName      : string;            //名称
    FHost      : string;            //IP
    FPort      : Integer;           //端口
    
    FUser     : string;           //登陆名
    FPassword : string;           //密码
    FChannel  : string;           //通道号
    FLinkMode : Integer;          //连接方式
    FUserID   : Integer;          //注册成功返回ID
    FRealHandle : LongInt;        //预览返回句柄
    FFortifyHandle : Integer      //布防返回句柄
  end;

  THKDoorSnapManager = class;
  THKDoorSnapSender = class(TThread)
  private
    FOwner: THKDoorSnapManager;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: THKDoorSnapManager);
    destructor Destroy; override;
    //创建释放
    procedure WakupMe;
    //唤醒线程
    procedure StopMe;
    //停止线程
  end;

  THKDoorSnapManager = class(TObject)
  private
    FEnabled: Boolean;
    //是否启用
    FDoorSnaps: array of THKDoorSnapParam;
    //卡列表
    FSender: THKDoorSnapSender;
    //发送线程
    FSyncLock: TCriticalSection;
    //同步锁定
  protected
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure LoadConfig(const nFile: string);
    //读取配置
    procedure StartSnap;
    procedure StopSnap;
    //启停发送
    procedure GetDoorSnapList(const nList: TStrings);
    //获取列表
  end;

var
  gHKDoorSnapManager: THKDoorSnapManager = nil;
  //全局使用

implementation

uses HCNetSDK, plaympeg4, UFormMain, UDataModule, USysDB, ULibFun;

const
  sPost_In   = 'in';

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(THKDoorSnapManager, '海康威视抓拍', nEvent);
end;

procedure MessageCallback(lCommand: Longint; pAlarmer: LPNET_DVR_ALARMER;
               pAlarmInfo: PChar; dwBufLen: Longword; pUser: Pointer); stdcall
    var dwReturn:DWORD;
var struPlateResult:LPNET_DVR_PLATE_RESULT;
    nStr: string;
begin
  if (lCommand = COMM_UPLOAD_PLATE_RESULT) then
  begin
    struPlateResult := AllocMem(sizeof(NET_DVR_PLATE_RESULT));
    CopyMemory(struPlateResult,pAlarmInfo, sizeof(NET_DVR_PLATE_RESULT));

    nStr := Format('抓拍摄像机抓拍到车牌号: %s',
              [struPlateResult.struPlateInfo.sLicense]);
    WriteLog(nStr);
    fFormMain.SaveSnapTruck(sPost_In,struPlateResult.struPlateInfo.sLicense);
  end;
end;

//------------------------------------------------------------------------------
constructor THKDoorSnapManager.Create;
begin
  FEnabled := True;
  FSender := nil;

  FSyncLock := TCriticalSection.Create;
end;

destructor THKDoorSnapManager.Destroy;
begin
  StopSnap;
  FSyncLock.Free;
  inherited;
end;

procedure THKDoorSnapManager.StartSnap;
var nErrIdx,nIdx,nCount: Integer;
    nStruDeviceInfo: NET_DVR_DEVICEINFO_V30;
    nStruPlayInfo: NET_DVR_CLIENTINFO;
    nStr: string;
    nStruSnapCfg :NET_DVR_SNAPCFG ;
begin
  if not FEnabled then Exit;
  //xxxxx

  if Length(FDoorSnaps) < 1 then
    raise Exception.Create('DoorSnap List Is Null.');
  //xxxxx

  for nIdx:=Low(FDoorSnaps) to High(FDoorSnaps) do
  with FDoorSnaps[nIdx] do
  begin
    NET_DVR_Init();
    //1初始化
    nErrIdx := NET_DVR_GetLastError();

    if nErrIdx <> 0 then
    begin

      nStr := Format('抓拍摄像机[ %s ]初始化失败,返回值: %d', [FID, nErrIdx]);
      WriteLog(nStr);
      Exit;
    end
    else
    begin
      nStr := Format('抓拍摄像机[ %s ]初始化成功', [FID]);
      WriteLog(nStr);
    end;

    FUserID:= NET_DVR_Login_V30(PAnsiChar(AnsiString(FHost)),FPort,
                                PAnsiChar(AnsiString(FUser)),
                                PAnsiChar(AnsiString(FPassword)),@nStruDeviceInfo);
    //2.注册用户
    if FUserID < 0 then
    begin
      nErrIdx := NET_DVR_GetLastError();

      nStr := Format('抓拍摄像机[ %s ]注册失败,返回值: %d', [FID, nErrIdx]);
      WriteLog(nStr);
      Exit;
    end
    else
    begin
      nStr := Format('抓拍摄像机[ %s ]注册成功,返回值: %d', [FID, FUserID]);
      WriteLog(nStr);
    end;

    nStruPlayInfo.lChannel := StrtoInt(FChannel);
    nStruPlayInfo.lLinkMode := FLinkMode;       //TCP
    nStruPlayInfo.sMultiCastIP := NIL;
    nStruPlayInfo.hPlayWnd := fFormMain.SnapView1.Handle;

    FRealHandle := NET_DVR_RealPlay_V30(FUserID, @nStruPlayInfo, nil,  nil, TRUE);
    //3预览
    if FRealHandle < 0 then
    begin
      nErrIdx := NET_DVR_GetLastError();

      nStr := Format('抓拍摄像机[ %s ]预览失败,返回值: %d', [FID, nErrIdx]);
      WriteLog(nStr);
      Exit;
    end
    else
    begin
      nStr := Format('抓拍摄像机[ %s ]预览成功,返回值: %d', [FID, FRealHandle]);
      WriteLog(nStr);
    end;

    NET_DVR_SetDVRMessageCallBack_V30(@MessageCallback, nil);
    //第一个参数为回调函数指针，第二个参数用于向回调函数传递参数

    FFortifyHandle := NET_DVR_SetupAlarmChan_V30(FUserID);
    //4.布防
    if FFortifyHandle < 0 then
    begin
      nErrIdx := NET_DVR_GetLastError();

      nStr := Format('抓拍摄像机[ %s ]布防失败,返回值: %d', [FID, nErrIdx]);
      WriteLog(nStr);
      Exit;
    end
    else
    begin
      nStr := Format('抓拍摄像机[ %s ]布防成功,返回值: %d', [FID, FFortifyHandle]);
      WriteLog(nStr);
    end;

    for nCount :=0 to 23 do
      nStruSnapCfg.byRes2[nCount]:=0;

    nStruSnapCfg.dwSize := sizeof(NET_DVR_SNAPCFG);
    nStruSnapCfg.byRelatedDriveWay := 0;
    nStruSnapCfg.bySnapTimes := 2;
    nStruSnapCfg.wSnapWaitTime := 1000;
    nStruSnapCfg.wIntervalTime[0] := 100;
    nStruSnapCfg.wIntervalTime[1] := 0;
    nStruSnapCfg.wIntervalTime[2] := 0;
    nStruSnapCfg.wIntervalTime[3] := 0;

    NET_DVR_ContinuousShoot(FUserID,@nStruSnapCfg);
    //5.抓拍
    nErrIdx := NET_DVR_GetLastError();

    if nErrIdx <> 0 then
    begin

      nStr := Format('抓拍摄像机[ %s ]设置抓拍失败,返回值: %d', [FID, nErrIdx]);
      WriteLog(nStr);
      Exit;
    end
    else
    begin
      nStr := Format('抓拍摄像机[ %s ]设置抓拍成功', [FID]);
      WriteLog(nStr);
    end;
  end;

  if not Assigned(FSender) then
    FSender := THKDoorSnapSender.Create(Self);
  FSender.WakupMe;
end;

procedure THKDoorSnapManager.StopSnap;
var nIdx: Integer;
begin
  if Assigned(FSender) then
    FSender.StopMe;
  //xxxxx

  FSender := nil;

  try
    for nIdx:=Low(FDoorSnaps) to High(FDoorSnaps) do
    with FDoorSnaps[nIdx] do
    begin
      //stop play
      if FRealHandle>=0 then
      begin
          NET_DVR_StopRealPlay(FRealHandle);
          FRealHandle := -1;
      end;
      //logout
      if  FUserID>=0 then
      begin
          NET_DVR_Logout_V30(FUserID);
          FUserID := -1;
      end;
      NET_DVR_Cleanup();

      fFormMain.SnapView1.Caption := 'Stop!';
    end;
  except
  end;
end;

//Date: 2017-12-1
//Parm: 列表
//Desc: 获取可用抓拍标识列表
procedure THKDoorSnapManager.GetDoorSnapList(const nList: TStrings);
var nIdx: Integer;
begin
  nList.Clear;
  for nIdx:=Low(FDoorSnaps) to High(FDoorSnaps) do
   with FDoorSnaps[nIdx] do
    nList.Values[FID] := FName;
  //xxxxx
end;

procedure THKDoorSnapManager.LoadConfig(const nFile: string);
var nIdx,nInt: Integer;
    nXML: TNativeXml;
    nNode,nTmp: TXmlNode;
begin
  nXML := TNativeXml.Create;
  try
    SetLength(FDoorSnaps, 0);
    nXML.LoadFromFile(nFile);
    nTmp := nXML.Root.FindNode('config');

    if Assigned(nTmp) then
    begin
      nIdx := nTmp.NodeByName('enable').ValueAsInteger;
      FEnabled := nIdx = 1;
    end;

    nTmp := nXML.Root.FindNode('Snaps');
    if Assigned(nTmp) then
    begin
      for nIdx:=0 to nTmp.NodeCount - 1 do
      begin
        nNode := nTmp.Nodes[nIdx];
        if nNode.NodeByName('enable').ValueAsInteger <> 1 then Continue;

        nInt := Length(FDoorSnaps);
        SetLength(FDoorSnaps, nInt + 1);

        with FDoorSnaps[nInt] do
        begin
          FID := nNode.AttributeByName['id'];
          FName := nNode.AttributeByName['name'];

          FHost := nNode.NodeByName('ip').ValueAsString;
          FPort := nNode.NodeByName('port').ValueAsInteger;

          FUser := nNode.NodeByName('User').ValueAsString;
          FPassword := nNode.NodeByName('Password').ValueAsString;
          FChannel := nNode.NodeByName('Channel').ValueAsString;
          FLinkMode := nNode.NodeByName('LinkMode').ValueAsInteger;
          FUserID := -1;
          FRealHandle := -1;
          FFortifyHandle := -1;
        end;
      end;
    end;
  finally
    nXML.Free;
  end;
end;

//------------------------------------------------------------------------------
constructor THKDoorSnapSender.Create(AOwner: THKDoorSnapManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 1000;
end;

destructor THKDoorSnapSender.Destroy;
begin
  FWaiter.Free;
  inherited;
end;

procedure THKDoorSnapSender.WakupMe;
begin
  FWaiter.Wakeup;
end;

procedure THKDoorSnapSender.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure THKDoorSnapSender.Execute;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;
  except
    on nErr: Exception do
    begin
      WriteLog(nErr.Message);
    end;
  end;
end;

initialization
  gHKDoorSnapManager := nil;
finalization
  FreeAndNil(gHKDoorSnapManager);
end.
