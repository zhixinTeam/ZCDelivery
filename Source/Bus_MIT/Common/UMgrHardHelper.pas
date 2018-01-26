{*******************************************************************************
  作者: dmzn@163.com 2012-4-21
  描述: 硬件守护服务链接器
*******************************************************************************}
unit UMgrHardHelper;

{$I Link.Inc}
interface

uses
  Windows, Classes, SysUtils, SyncObjs, NativeXml, IdComponent, IdTCPConnection,
  IdTCPClient, IdUDPServer, IdGlobal, IdSocketHandle, USysLoger, UWaitItem;

type
  PHHDataBase = ^THHDataBase;
  THHDataBase = record
    FCommand   : Byte;     //命令字
    FDataLen   : Word;     //数据长
  end;

  PHHOpenDoor = ^THHOpenDoor;
  THHOpenDoor = record
    FBase      : THHDataBase;
    FReaderID  : string;
  end;

const
  cHHCmd_GetCards  = $12;  //获取卡号
  cHHCmd_OpenDoor  = $27;  //道闸抬杆
  cSizeHHBase      = SizeOf(THHDataBase);
  
type
  THHReaderType = (rtIn, rtOut, rtPound, rtGate, rtQueueGate);
  //读头类型:进,出,磅,门闸,队列门闸

  THHReaderItem = record
    FID      : string;
    FType    : THHReaderType;
    FPound   : string;
    FCard    : string;
    FCardExt : string;
    FPrinter : string;
    FLast    : Int64;
    FKeep    : Word;
    FOKTime  : Int64;
    FOptions : TStrings;          //附加参数
  end;

  THardwareHelper = class;
  THardwareConnector = class(TThread)
  private
    FOwner: THardwareHelper;
    //拥有者
    FBuffer: TList;
    //发送缓冲
    FWaiter: TWaitObject;
    //等待对象
    FClient: TIdTCPClient;
    FServer: TIdUDPServer;
    //网络对象
  protected
    procedure DoCardAction;
    procedure DoExuecte;
    procedure Execute; override;
    //执行线程
    procedure SetReaderCard(const nReader,nCard: string);
    //解析卡片
    procedure OnUDPRead(AThread: TIdUDPListenerThread;
      AData: TIdBytes; ABinding: TIdSocketHandle);
    //卡片数据
  public
    constructor Create(AOwner: THardwareHelper);
    destructor Destroy; override;
    //创建释放
    procedure WakupMe;
    //唤醒线程
    procedure StopMe;
    //停止线程
  end;

  THHProce = procedure (const nReader: THHReaderItem);
  THHEvent = procedure (const nReader: THHReaderItem) of Object;
  //事件相关

  THardwareHelper = class(TObject)
  private
    FHostIP: string;
    FHostPort: Integer;
    FUDPPort: Integer;
    FConnHelper: Boolean;
    //服务主机
    FItems: array of THHReaderItem;
    //读头列表
    FReader: THardwareConnector;
    //读对象
    FBuffData: TList;
    //临时缓冲
    FSyncLock: TCriticalSection;
    //同步锁
    FProce: THHProce;
    FEvent: THHEvent;
    //事件相关
  protected
    procedure ClearBuffer(const nList: TList);
    //清理缓冲
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure LoadConfig(const nFile: string);
    //读取配置
    procedure StartRead;
    procedure StopRead;
    //启停读取
    function GetPoundCard(const nPound: string; var nReader: string): string;
    procedure SetPoundCardExt(const nPound,nExtCard: string);
    //磅站卡号
    procedure OpenDoor(const nReader: string);
    //道闸抬杆
    procedure SetReaderCard(const nReader,nCard: string;
      const nVirtualReader: Boolean = True);
    function GetCardLastDone(const nCard,nReader: string): Int64;
    procedure SetCardLastDone(const nCard,nReader: string);
    function GetReaderLastOn(const nCard: string): string;
    //磁卡活动
    property ConnHelper: Boolean read FConnHelper write FConnHelper;
    property OnProce: THHProce read FProce write FProce;
    property OnEvent: THHEvent read FEvent write FEvent;
    //事件相关
  end;

var
  gHardwareHelper: THardwareHelper = nil;
  //全局使用

implementation

uses
  ULibFun;

//------------------------------------------------------------------------------
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(THardwareHelper, '硬件守护辅助', nEvent);
end;

constructor THardwareHelper.Create;
begin
  FReader := nil;
  FBuffData := TList.Create;
  FSyncLock := TCriticalSection.Create;
end;

destructor THardwareHelper.Destroy;
var nIdx: Integer;
begin
  for nIdx:=Low(FItems) to High(FItems) do
    FreeAndNil(FItems[nIdx].FOptions);
  //xxxxx

  StopRead;
  ClearBuffer(FBuffData);
  FBuffData.Free;

  FSyncLock.Free;
  inherited;
end;

procedure THardwareHelper.ClearBuffer(const nList: TList);
var nIdx: Integer;
    nBase: PHHDataBase;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    nBase := nList[nIdx];

    case nBase.FCommand of
     cHHCmd_OpenDoor : Dispose(PHHOpenDoor(nBase));
    end;

    nList.Delete(nIdx);
  end;
end;

procedure THardwareHelper.StartRead;
begin
  if not Assigned(FReader) then
    FReader := THardwareConnector.Create(Self);
  FReader.WakupMe;
end;

procedure THardwareHelper.StopRead;
begin
  if Assigned(FReader) then
    FReader.StopMe;
  FReader := nil;
end;

//Desc: 获取nPound当前卡号
function THardwareHelper.GetPoundCard(const nPound: string;
    var nReader: string): string;
var nIdx: Integer;
begin
  FSyncLock.Enter;
  try
    Result := '';

    for nIdx:=Low(FItems) to High(FItems) do
    if CompareText(nPound, FItems[nIdx].FPound) = 0 then
    begin
      if GetTickCount - FItems[nIdx].FLast <= FItems[nIdx].FKeep * 1000 then
        Result := FItems[nIdx].FCard;
      //xxxxx

      FItems[nIdx].FCard := '';
      if Result <> '' then
      begin
        nReader := FItems[nIdx].FID;
        Break;
      end;
      //loop get card
    end;
  finally
    FSyncLock.Leave;
  end;
end;

//Desc: 设定扩展卡号,用于特定比对业务
procedure THardwareHelper.SetPoundCardExt(const nPound, nExtCard: string);
var nIdx: Integer;
begin
  FSyncLock.Enter;
  try
    for nIdx:=Low(FItems) to High(FItems) do
     if CompareText(nPound, FItems[nIdx].FPound) = 0 then
      FItems[nIdx].FCardExt := nExtCard;
    //xxxxx
  finally
    FSyncLock.Leave;
  end;
end;

//Desc: 对nReader读头执行抬杆操作
procedure THardwareHelper.OpenDoor(const nReader: string);
var nIdx: Integer;
    nPtr: PHHOpenDoor;
    nBase: PHHDataBase;
begin
  FSyncLock.Enter;
  try
    for nIdx:=FBuffData.Count - 1 downto 0 do
    begin
      nBase := FBuffData[nIdx];
      if nBase.FCommand <> cHHCmd_OpenDoor then Continue;

      nPtr := PHHOpenDoor(nBase);
      if CompareText(nReader, nPtr.FReaderID) = 0 then Exit;
    end;

    New(nPtr);
    FBuffData.Add(nPtr);

    nPtr.FBase.FCommand := cHHCmd_OpenDoor;
    nPtr.FReaderID := nReader;

    if Assigned(FReader) then
      FReader.WakupMe;
    //xxxxx
  finally
    FSyncLock.Leave;
  end;
end;

//Desc: 获取nCard在nReader读头上的最后活动时间
function THardwareHelper.GetCardLastDone(const nCard,nReader: string): Int64;
var nIdx: Integer;
begin
  Result := 0;

  for nIdx:=Low(FItems) to High(FItems) do
  with FItems[nIdx] do
  begin
    if (FCard <> nCard) or (FID <> nReader) then Continue;
    //match reader and card_no

    Result := FOKTime;
    Break;
  end;
end;

//Desc: 获取nCard在nReader读头上的最后活动时间
procedure THardwareHelper.SetCardLastDone(const nCard,nReader: string);
var nIdx: Integer;
begin
  for nIdx:=Low(FItems) to High(FItems) do
  with FItems[nIdx] do
  begin
    if (FCard <> nCard) or (FID <> nReader) then Continue;
    //match reader and card_no

    FOKTime := GetTickCount;
    Break;
  end;
end;

//Date: 2012-12-15
//Parm: 读头号;磁卡号;是否虚拟读头
//Desc: 设置nReader上的磁卡号.若为虚拟读头,则格式化读头号.
procedure THardwareHelper.SetReaderCard(const nReader, nCard: string;
 const nVirtualReader: Boolean);
var nStr: string;
begin
  if Assigned(FReader) then
  begin
    if nVirtualReader then
    begin
      nStr := 'V' + Copy(nReader, 2, Length(nReader) - 1);
      FReader.SetReaderCard(nStr, nCard);

      WriteLog(Format('向虚拟读头[ %s ]发送卡号[ %s ].',  [nStr, nCard]));
    end else FReader.SetReaderCard(nReader, nCard);
  end;
end;

//Date: 2012-12-16
//Parm: 磁卡号
//Desc: 获取nCard最后一次刷卡所在读头
function THardwareHelper.GetReaderLastOn(const nCard: string): string;
var nIdx,nLast: Integer;
begin
  Result := '';
  nLast := -1;

  for nIdx:=Low(FItems) to High(FItems) do
  with FItems[nIdx] do
  begin
    if (FCard <> nCard) and (FCardExt <> nCard) then Continue;
    //match card_no

    if nLast < 0 then nLast := nIdx;
    if FLast >= FItems[nLast].FLast then
    begin
      Result := FID;
      nLast := nIdx;
    end;
  end;
end;

//Desc: 载入nFile配置文件
procedure THardwareHelper.LoadConfig(const nFile: string);
var i,nIdx,nInt: Integer;
    nXML: TNativeXml;
    nNode,nTP: TXmlNode;
begin
  nXML := TNativeXml.Create;
  try
    nXML.LoadFromFile(nFile);
    nNode := nXML.Root.NodeByName('helper');

    FHostIP := nNode.NodeByName('ip').ValueAsString;
    FHostPort := nNode.NodeByName('port').ValueAsInteger;

    nTP := nNode.FindNode('enable');
    if Assigned(nTP) then
         FConnHelper := nTP.ValueAsString <> 'N'
    else FConnHelper := True;

    nTP := nNode.FindNode('local_udp');
    if Assigned(nTP) then
         FUDPPort := nTP.ValueAsInteger
    else FUDPPort := 5005;

    nNode := nXML.Root.NodeByName('readers');
    nInt := 0;
    SetLength(FItems, nNode.NodeCount);

    for nIdx:=0 to nNode.NodeCount - 1 do
    with nNode.Nodes[nIdx],FItems[nInt] do
    begin
      FCard := '';
      FCardExt := '';

      FLast := 0;
      FOKTime := 0;
      FID := AttributeByName['ID'];

      i := NodeByName('type').ValueAsInteger;
      case i of
       1: FType := rtIn;
       2: FType := rtOut;
       3: FType := rtPound;
       4: FType := rtGate;
       5: FType := rtQueueGate else FType := rtGate;
      end;

      nTP := NodeByName('pound');
      if Assigned(nTP) then
           FPound := nTP.ValueAsString
      else FPound := '';

      nTP := NodeByName('printer');
      if Assigned(nTP) then
           FPrinter := nTP.ValueAsString
      else FPrinter := '';

      nTP := NodeByName('options');
      if Assigned(nTP) then
      begin
        FOptions := TStringList.Create;
        SplitStr(nTP.ValueAsString, FOptions, 0, ';');
      end else FOptions := nil;

      nTP := NodeByName('keeptime');
      if Assigned(nTP) then
      begin
        i := nTP.ValueAsInteger;
        if i < 1 then
             FKeep := 1
        else FKeep := i;
      end else
      begin
        if FType = rtPound then
             FKeep := 20
        else FKeep := 3;
      end;

      Inc(nInt);
    end;
  finally
    nXML.Free;
  end;
end;

//------------------------------------------------------------------------------
constructor THardwareConnector.Create(AOwner: THardwareHelper);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FOwner := AOwner;
  
  FBuffer := TList.Create;
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 500; //3 * 1000;

  FClient := TIdTCPClient.Create;
  FClient.ReadTimeout := 5 * 1000;

  FServer := TIdUDPServer.Create;
  FServer.OnUDPRead := OnUDPRead;
  FServer.DefaultPort := FOwner.FUDPPort;

  FServer.Active := True;
  //udp server
end;

destructor THardwareConnector.Destroy;
begin
  FClient.Disconnect;
  FClient.Free;

  FServer.Active := False;
  FServer.Free;

  FOwner.ClearBuffer(FBuffer);
  FBuffer.Free;

  FWaiter.Free;
  inherited;
end;

procedure THardwareConnector.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure THardwareConnector.WakupMe;
begin
  FWaiter.Wakeup;
end;

procedure THardwareConnector.Execute;
var nIdx: Integer;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    if not FOwner.FConnHelper then
    begin
      DoCardAction;
      FOwner.ClearBuffer(FOwner.FBuffData);
      Continue;
    end;

    try
      if not FClient.Connected then
      begin
        FClient.Host := FOwner.FHostIP;
        FClient.Port := FOwner.FHostPort;

        FClient.ConnectTimeout := 5 * 1000;
        FClient.Connect;
      end;
    except
      WriteLog('连接硬件辅助服务失败.');
      FClient.Disconnect;
      Continue;
    end;

    FOwner.FSyncLock.Enter;
    try
      for nIdx:=0 to FOwner.FBuffData.Count - 1 do
        FBuffer.Add(FOwner.FBuffData[nIdx]);
      FOwner.FBuffData.Clear;
    finally
      FOwner.FSyncLock.Leave;
    end;

    try
      DoExuecte;
      FOwner.ClearBuffer(FBuffer);
    except
      FOwner.ClearBuffer(FBuffer);
      FClient.Disconnect;
      
      if Assigned(FClient.IOHandler) then
        FClient.IOHandler.InputBuffer.Clear;
      raise;
    end;

    DoCardAction;
    //处理卡
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

procedure THardwareConnector.DoExuecte;
var nIdx: Integer;
    nBuf,nTmp: TIdBytes;
    //nBase: THHDataBase;
    nPBase: PHHDataBase;
begin
  FClient.Socket.InputBuffer.Clear;
  for nIdx:=FBuffer.Count - 1 downto 0 do
  begin
    nPBase := FBuffer[nIdx];

    if nPBase.FCommand = cHHCmd_OpenDoor then
    begin
      SetLength(nTmp, 0);
      nTmp := ToBytes(PHHOpenDoor(nPBase).FReaderID);
      nPBase.FDataLen := Length(nTmp);

      nBuf := RawToBytes(nPBase^, cSizeHHBase);
      AppendBytes(nBuf, nTmp);
      FClient.Socket.Write(nBuf);
    end;
  end;
end;

//Desc: 设置nReader的当前卡为nCard
procedure THardwareConnector.SetReaderCard(const nReader, nCard: string);
var nIdx: Integer;
begin
  {$IFDEF DEBUG}
  WriteLog(nReader + ' ::: ' + nCard);
  {$ENDIF}

  for nIdx:=Low(FOwner.FItems) to High(FOwner.FItems) do
  with FOwner.FItems[nIdx] do
  begin
    if CompareText(nReader, FID) = 0 then
    begin
      {$IFDEF DEBUG}
      WriteLog(nReader + ' ::: 匹配成功.');
      {$ENDIF}

      if FType = rtPound then
      begin
        FLast := GetTickCount;
        //磅读头开启卡有效计时
      end else

      if GetTickCount - FLast <= FKeep * 1000 then
      begin
        Break;
        //短时间重复刷卡无效
      end;

      FCard := nCard;
      WriteLog(Format('接收到卡号: %s,%s', [nReader, nCard]));
      Break;
    end;
  end;
end;

//Desc: 执行卡片动作
procedure THardwareConnector.DoCardAction;
var nIdx,nNum: Integer;
    nItem: THHReaderItem;
begin
  while True do
  with FOwner do
  begin
    FSyncLock.Enter;
    try
      nNum := -1;

      for nIdx:=Low(FItems) to High(FItems) do
      if (FItems[nIdx].FCard <> '') and (FItems[nIdx].FType <> rtPound) then
      begin
        FItems[nIdx].FLast := GetTickCount + 500;
        //重复刷卡间隔处理,多延后500ms

        nItem := FItems[nIdx];
        FItems[nIdx].FCard := '';

        {$IFDEF DEBUG}
        WriteLog(nItem.FID + ' ::: 已被选定.');
        {$ENDIF}

        nNum := nIdx;
        Break;
      end;
    finally
      FSyncLock.Leave;
    end;

    if nNum < 0 then Exit;
    //处理完毕
    WriteLog(nItem.FID + ' ::: 开始执行业务.');
    //loged

    if Assigned(FProce) then FProce(nItem);
    if Assigned(FEvent) then FEvent(nItem);

    WriteLog(nItem.FID + ' ::: 业务完毕.');
    //loged
  end;
end;

//Desc: UDP播发卡号
procedure THardwareConnector.OnUDPRead(AThread: TIdUDPListenerThread;
  AData: TIdBytes; ABinding: TIdSocketHandle);
var nStr,nR: string;
    nPos: Integer;
begin
  nStr := BytesToString(AData);
  nPos := Pos('NEWDATA', nStr);
  if nPos < 1 then Exit;

  System.Delete(nStr, nPos, 7);
  nPos := Pos(' ', nStr);
  if nPos < 1 then Exit;

  nR := Copy(nStr, 1, nPos - 1);
  System.Delete(nStr, 1, nPos);
  //reader

  nPos := Pos(' ', nStr);
  if nPos > 1 then
  try
    FOwner.FSyncLock.Enter;
    nStr := Copy(nStr, 1, nPos - 1);
    SetReaderCard(nR, nStr);
  finally
    FOwner.FSyncLock.Leave;
  end;
end;

initialization
  gHardwareHelper := nil;
finalization
  FreeAndNil(gHardwareHelper);
end.
