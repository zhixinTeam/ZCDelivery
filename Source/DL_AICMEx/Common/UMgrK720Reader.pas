unit UMgrK720Reader;

interface

uses
  SysUtils, Classes, SyncObjs, UWaitItem, UMemDataPool, UMgrKCDF360,
  NativeXml, USysLoger;

{.$DEFINE DEBUG}  
const
  cK720ReaderData = 'K720ReaderData';

  cK720Reader_CmdRecycle = 'CP';          //回收卡片
  cK720Reader_CmdFC7     = 'FC7';         //发卡到读卡位置

  cK720Reader_CmdInterval     = 20;       //命令间隔
  cK720Reader_FreshInterval   = 200;      //刷新频率
type
  TK720ReaderComport = record
    FPort     : string;          //串口号,如'COM1'
    FAddr     : Integer;         //机器地址,有效值(0-15)
  end;

  TK720OutData = array [0..512] of Char;
  //传出数据

  TK720ReaderAction = (raQueryStatus, raRead, raRecycle, raControl);
  //帧动作: 查询状态,读卡, 回收, 控制

  TK720ReaderDataOwner = (roIgnore, roCaller, roThread);
  //数据管理: 忽略,呼叫方,服务线程

  PK720ReaderDataItem = ^TK720ReaderDataItem;
  TK720ReaderDataItem = record
    FEnable : Boolean;                  //是否启用
    FAction : TK720ReaderAction;        //执行动作
    FOwner: TK720ReaderDataOwner;       //释放方式

    FDataStr: string;                   //字符数据
    FDataBool: Boolean;                 //布尔数据

    FResultStr : string;                //字符返回
    FResultBool: Boolean;               //布尔返回
    FWaiter: TWaitObject;               //等待对象
  end;

  TK720ReaderManager = class;
  TK720Reader = class(TThread)
  private
    { Private declarations }
    FOwner: TK720ReaderManager;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
    FReaderHandle: Cardinal;
    //读卡器句柄
  protected
    procedure Execute; override;
    procedure DoExecute;
    //执行线程

    procedure ClosePort;
    procedure AddQueryFrame(const nList: TList);
    //查询指令
    procedure SendDataFrame(const nItem: PK720ReaderDataItem);
    //发送指令
  public
    constructor Create(AOwner: TK720ReaderManager);
    destructor Destroy; override;
    //创建释放
    procedure WakupMe;
    //唤醒线程
    procedure StopMe;
    //停止线程
  end;

  TOnCardEvent = procedure (const nCard: string) of object;
  TOnCardProc = procedure (const nCard: string);
  //读卡事件

  TOnStatusEvent = procedure (const nStatus: string) of object;
  TOnStatusProc = procedure (const nStatus: string);
  //读卡器状态

  TK720ReaderManager = class(TObject)
  private
    { Private declarations }
    FReader: TK720Reader;
    //读卡器线程
    FSyncLock: TCriticalSection;
    //互斥锁
    FBuffer, FTmpList: TList;
    //指令缓冲
    FIDK720ReaderData: Integer;
    //线程数据
    FPortParam: TK720ReaderComport;
    //串口配置

    FEvent: TOnCardEvent;
    FProc:  TOnCardProc;

    FStatusEvent: TOnStatusEvent;
    FStatusProc: TOnStatusProc;
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放

    procedure RegisterDataType;
    //注册数据类型
    function NewK720ReaderData(const nInterval: Integer): PK720ReaderDataItem;
    //新建指令数据
    procedure DeleteK720ReaderDataItem(const nData: PK720ReaderDataItem;
              nList: TList);
    //删除指令
    procedure ClearBuffer(const nList: TList; const nFree: Boolean=False);
    //清除指令缓冲

    procedure LoadConfig(const nFile: string);
    //读取配置
    procedure StartReader;
    procedure StopReader;
    //启停读卡器
    function ReadCard(var nCard: string): Boolean;
    //读取磁卡序列号
    procedure RecycleCard;
    //回收卡片
    function SendReaderCmd(const nCMD: string): Boolean;
    //发送读卡器指令

    function ParseCardNO(const nCardHex: string): string;
    //解析卡号

    property OnEvent: TOnCardEvent read FEvent write FEvent;
    property OnProc: TOnCardProc read FProc write FProc;
    //事件属性

    property OnStatusEvent: TOnStatusEvent read FStatusEvent write FStatusEvent;
    property OnStatusProc: TOnStatusProc read FStatusProc write FStatusProc;
    //事件属性
  end;

var
  gMgrK720Reader: TK720ReaderManager = nil;
  //全局使用

implementation

//------------------------------------------------------------------------------
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TK720ReaderManager, '720读卡器服务', nEvent);
end;

//------------------------------------------------------------------------------
constructor TK720ReaderManager.Create;
begin
  FSyncLock := TCriticalSection.Create;
  FBuffer := TList.Create;
  FTmpList:= TList.Create;

  with FPortParam do
  begin
    FPort := 'COM1';
    FAddr := 15;
  end;

  RegisterDataType;
  //由内存管理数据  
end;

destructor TK720ReaderManager.Destroy;
begin
  StopReader;
  //停止读卡
  
  ClearBuffer(FBuffer, True);
  ClearBuffer(FTmpList, True);
  //xxxxxx

  FSyncLock.Free;
end;

//Desc: 载入nFile配置文件
procedure TK720ReaderManager.LoadConfig(const nFile: string);
var nXML: TNativeXml;
    nNode: TXmlNode;
begin
  nXML := TNativeXml.Create;
  try
    nXML.LoadFromFile(nFile);
    nNode := nXML.Root.NodeByName('comport');

    with FPortParam do
    begin
      FPort     := nNode.NodeByName('port').ValueAsString;
      if FPort = '' then FPort := 'COM1';
      FAddr     := StrToIntDef(nNode.NodeByName('addr').ValueAsString, -1);
    end;
  finally
    nXML.Free;
  end;
end;

procedure TK720ReaderManager.StartReader;
begin
  if not Assigned(FReader) then
    FReader := TK720Reader.Create(Self);
  FReader.WakupMe;
end;

procedure TK720ReaderManager.StopReader;
begin
  if Assigned(FReader) then
    FReader.StopMe;
  FReader := nil;
end;

function TK720ReaderManager.ReadCard(var nCard: string): Boolean;
var nItem: PK720ReaderDataItem;
begin
  FSyncLock.Enter;
  try
    nItem := NewK720ReaderData(1*1000);
    nItem.FAction := raRead;
    FBuffer.Add(nItem);

    FReader.WakupMe;
  finally
    FSyncLock.Leave;
  end;

  nItem.FWaiter.EnterWait;
  //等待反馈
  Result := nItem.FResultBool;
  nCard := nItem.FResultStr;

  {$IFDEF DEBUG}
  WriteLog('ReadCard:::' + nItem.FResultStr);
  {$ENDIF}

  DeleteK720ReaderDataItem(nItem, FBuffer);
  //删除指令
end;

procedure TK720ReaderManager.RecycleCard;
var nItem: PK720ReaderDataItem;
begin
  FSyncLock.Enter;
  try
    nItem := NewK720ReaderData(500);
    nItem.FAction := raRecycle;
    FBuffer.Add(nItem);

    FReader.WakupMe;
  finally
    FSyncLock.Leave;
  end;

  nItem.FWaiter.EnterWait;
  //等待指令结束

  {$IFDEF DEBUG}
  WriteLog('RecycleCard:::' + nItem.FResultStr);
  {$ENDIF}

  DeleteK720ReaderDataItem(nItem, FBuffer);
  //删除指令
end;

function TK720ReaderManager.SendReaderCmd(const nCMD: string): Boolean;
var nItem: PK720ReaderDataItem;
begin
  FSyncLock.Enter;
  try
    nItem := NewK720ReaderData(10 * 100);
    nItem.FAction := raControl;
    nItem.FDataStr:= nCMD;
    FBuffer.Add(nItem);

    FReader.WakupMe;
  finally
    FSyncLock.Leave;
  end;

  nItem.FWaiter.EnterWait;
  //等待指令结束
  Result := nItem.FResultBool;

  {$IFDEF DEBUG}
  WriteLog('SendReaderCmd:::' + nItem.FResultStr);
  {$ENDIF}

  DeleteK720ReaderDataItem(nItem, FBuffer);
  //删除指令
end;

function TK720ReaderManager.ParseCardNO(const nCardHex: string): string;
var nIdx:Integer;
    nInt: Int64;
    nHexTmp: string;
begin
  Result := '';
  if Length(nCardHex) < 4 then Exit;
  //xxxxx

  nHexTmp := Copy(nCardHex, 1, 4);
  //定长4位
  for nIdx := Length(nHexTmp) downto 1 do
    Result := Result + IntToHex(Ord(nHexTmp[nIdx]), 2);

  nInt := StrToInt64('$' + Result);
  Result := IntToStr(nInt);
  Result := StringOfChar('0', 12 - Length(Result)) + Result;
end;

procedure TK720ReaderManager.ClearBuffer(const nList: TList; const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx := nList.Count - 1 downto 0 do
    DeleteK720ReaderDataItem(nList[nIdx], nList);

  if nFree then
    nList.Free;
end;

procedure OnNew(const nFlag: string; const nType: Word; var nData: Pointer);
var nItem: PK720ReaderDataItem;
begin
  if nFlag = cK720ReaderData then
  begin
    New(nItem);
    nData := nItem;
    nItem.FWaiter := nil;
  end;
end;

procedure OnFree(const nFlag: string; const nType: Word; const nData: Pointer);
var nItem: PK720ReaderDataItem;
begin
  if nFlag = cK720ReaderData then
  begin
    nItem := nData;
    if Assigned(nItem.FWaiter) then
      FreeAndNil(nItem.FWaiter);
    Dispose(nItem);
  end;
end;

procedure TK720ReaderManager.RegisterDataType;
begin
  if not Assigned(gMemDataManager) then
    gMemDataManager := TMemDataManager.Create;
  //xxxxx

  with gMemDataManager do
    FIDK720ReaderData := RegDataType(cK720ReaderData, 'K720ReaderManager',
                         OnNew, OnFree, 2);
  //xxxxx
end;

//Date: 2016-09-13
//Parm: 等待对象间隔
//Desc: 新建服务数据项
function TK720ReaderManager.NewK720ReaderData(
  const nInterval: Integer): PK720ReaderDataItem;
begin
  Result := gMemDataManager.LockData(FIDK720ReaderData);
  with Result^ do
  begin
    FEnable := True;
    FAction := raQueryStatus;
    FOwner := roCaller;

    FDataStr := '';
    FDataBool := False;

    FResultStr  := '';
    FResultBool := False;

    if nInterval > 0 then
    begin
      if not Assigned(FWaiter) then
        FWaiter := TWaitObject.Create;
      FWaiter.Interval := nInterval;
    end;
  end;
end;

procedure TK720ReaderManager.DeleteK720ReaderDataItem(
  const nData: PK720ReaderDataItem; nList: TList);
var nIdx: Integer;
begin
  FSyncLock.Enter;
  try
    gMemDataManager.UnLockData(nData);
    nIdx := nList.IndexOf(nData);
    if Assigned(nData.FWaiter) then
    begin
      nData.FWaiter.Free;
      nData.FWaiter := nil;
    end;

    if nIdx >= 0 then
      nList.Delete(nIdx);
    //xxxxx
  finally
    FSyncLock.Leave;
  end;
end;

//------------------------------------------------------------------------------
constructor TK720Reader.Create(AOwner: TK720ReaderManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FOwner := AOwner;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 1000;

  FReaderHandle := 0;
end;

destructor TK720Reader.Destroy;
begin
  ClosePort;
  FWaiter.Free;
  inherited;
end;

procedure TK720Reader.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TK720Reader.WakupMe;
begin
  FWaiter.Wakeup;
end;

procedure TK720Reader.ClosePort;
begin
  if FReaderHandle > 0 then
    K720_CommClose(FReaderHandle);

  FReaderHandle := 0;
end;  

procedure TK720Reader.Execute;
begin
  { Place thread code here }
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    DoExecute;
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      ClosePort;
    end;  
  end;  
end;

procedure TK720Reader.DoExecute;
var nIdx: Integer;
begin
  with FOwner do
  begin
    if FReaderHandle <= 0 then
      FReaderHandle := K720_CommOpen(FPortParam.FPort);

    FSyncLock.Enter;
    try
      for nIdx := FBuffer.Count - 1 downto 0 do
        FTmpList.Add(FBuffer[nIdx]);
    finally
      FSyncLock.Leave;
    end;

    if FTmpList.Count < 1 then
      AddQueryFrame(FTmpList);
    //添加查询帧

    try
      for nIdx:=0 to FTmpList.Count - 1 do
      begin
        SendDataFrame(FTmpList[nIdx]);
        //发送数据帧

        if nIdx < FTmpList.Count - 1 then
          Sleep(cK720Reader_FreshInterval);
        //多帧发送时需延时
      end;

      ClearBuffer(FTmpList);
    except
      ClearBuffer(FTmpList);
      raise;
    end;
  end;  
end;

//Desc: 在nList中添加查询帧
procedure TK720Reader.AddQueryFrame(const nList: TList);
var nItem: PK720ReaderDataItem;
begin
  nItem := FOwner.NewK720ReaderData(0); //10s
  nList.Add(nItem);
  nItem.FAction := raQueryStatus;
  nItem.FOwner  := roThread;
end;

//Desc: 发送数据
procedure TK720Reader.SendDataFrame(const nItem: PK720ReaderDataItem);
var nOut, nRecord: TK720OutData;
    nRet, nIdx: Integer;
begin
  if not nItem.FEnable then Exit;
  nItem.FEnable := False;

  if FReaderHandle <= 0 then Exit;
  //无操作句柄

  case nItem.FAction of
  raQueryStatus :
  begin
    if FOwner.FPortParam.FAddr < 0 then
    for nIdx := 0 to 15 do
    begin
      nRet := K720_SensorQuery(FReaderHandle, nIdx, nOut, nRecord);

      if nRet <> 0 then Continue;

      FOwner.FPortParam.FAddr := nIdx;
      Break;
    end else nRet := K720_SensorQuery(FReaderHandle, FOwner.FPortParam.FAddr,
                     nOut, nRecord);
    //获取状态

    {$IFDEF DEBUG}
    WriteLog('当前状态:' + StrPas(nOut));
    WriteLog('通讯记录:' + StrPas(nRecord));
    {$ENDIF}

    nItem.FResultStr := StrPas(nOut);
    nItem.FResultBool := nRet = 0;
    if not nItem.FResultBool then FOwner.FPortParam.FAddr := -1;

    if Assigned(nItem.FWaiter) then
      nItem.FWaiter.Wakeup();
    //xxxxx

    if Assigned(FOwner.FStatusEvent) then
      FOwner.FStatusEvent(StrPas(nOut));

    if Assigned(FOwner.FStatusProc) then
      FOwner.FStatusProc(StrPas(nOut));
  end;
  raRead :
  begin
    K720_SendCmd(FReaderHandle, FOwner.FPortParam.FAddr,
      cK720Reader_CmdFC7, Length(cK720Reader_CmdFC7), nRecord);
    //发卡到读卡位置

    {$IFDEF DEBUG}
    WriteLog('发卡到读卡位置:' + StrPas(nRecord));
    {$ENDIF}

    nRet := K720_S50GetCardID(FReaderHandle, FOwner.FPortParam.FAddr,
            nOut, nRecord);
    //获取ID号

    {$IFDEF DEBUG}
    WriteLog('50CardID:' + StrPas(nOut));
    WriteLog('通讯记录:' + StrPas(nRecord));
    {$ENDIF}

    nItem.FResultStr := StrPas(nOut);
    nItem.FResultBool := nRet = 0;

    if Assigned(nItem.FWaiter) then
      nItem.FWaiter.Wakeup();
    //xxxxx

    if Assigned(FOwner.FEvent) then
      FOwner.FEvent(StrPas(nOut));

    if Assigned(FOwner.FProc) then
      FOwner.FProc(StrPas(nOut));
  end;
  raRecycle :
  begin
    nRet := K720_SendCmd(FReaderHandle, FOwner.FPortParam.FAddr,
            cK720Reader_CmdRecycle, Length(cK720Reader_CmdRecycle), nRecord);
    //回收卡片

    {$IFDEF DEBUG}
    WriteLog('通讯记录:' + StrPas(nRecord));
    {$ENDIF}

    nItem.FResultStr := '';
    nItem.FResultBool := nRet = 0;

    if Assigned(nItem.FWaiter) then
      nItem.FWaiter.Wakeup();
    //xxxxx
  end;
  raControl :
  begin
    nRet := K720_SendCmd(FReaderHandle, FOwner.FPortParam.FAddr,
            nItem.FDataStr, Length(nItem.FDataStr), nRecord);
    //发送指令

    {$IFDEF DEBUG}
    WriteLog('通讯记录:' + StrPas(nRecord));
    {$ENDIF}

    nItem.FResultStr := '';
    nItem.FResultBool := nRet = 0;

    if Assigned(nItem.FWaiter) then
      nItem.FWaiter.Wakeup();
    //xxxxx
  end;       
  end;   
end;

initialization
  gMgrK720Reader := nil;
finalization
  FreeAndNil(gMgrK720Reader);
end.
