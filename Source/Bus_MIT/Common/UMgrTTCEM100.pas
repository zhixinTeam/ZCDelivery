{*******************************************************************************
  作者: fendou116688@163.com 2016/4/22
  描述: TTCE三合一读卡器管理单元
*******************************************************************************}
unit UMgrTTCEM100;

interface

uses
  Windows, Classes, SysUtils, SyncObjs, NativeXml, IdTCPClient, IdGlobal,
  UWaitItem, USysLoger, ULibFun;

const
  cM100Reader_Wait_Short     = 150;
  cM100Reader_Wait_Long      = 2 * 1000;
  cM100Reader_MaxThread      = 10;

  cTTCE_M100_ACK = $06;                      //肯定应答
  cTTCE_M100_NAK = $15;                      //否定应答
  cTTCE_M100_ENQ = $05;                      //执行命令请求
  cTTCE_M100_EOT = $04;                      //取消命令
  cTTCE_M100_STX = $02;                      //块起始符。固定为：0X02
  cTTCE_M100_ETX = $03;                      //块结束符。固定为：0x03
  cTTCE_M100_Success = 'P';                  //=0x50。表示命令执行成功
  cTTCE_M100_Failure = 'N';                  //=0x4E。表示命令执行失败

  cTTCE_M100_GetSiteErr = $FF;               //获取卡片位置失败
  cTTCE_M100_Config = 'TTCEM100.XML';

type
  PTTCE_M100_Send = ^TTTCE_M100_Send;
  TTTCE_M100_Send = record
    FSTX   : Char;                           //块起始符。固定为：0X02
    FLen   : Integer;                        //发送的数据包长。长度二个字节
    FCM    : Char;                           //命令代码
    FPM    : Char;                           //命令参数
    FSE_DATAB : string;                      //发送的数据包
    FETX   : Char;                           //块结束符。固定为：0x03
    FBCC   : Char;                           //异或校验和。计算方法：从STX（包括STX）到ETX（包括ETX）之间的每个数据进行异或
  end;

  PTTCE_M100_Recv = ^TTTCE_M100_Recv;
  TTTCE_M100_Recv = record
    FSTX   : Char;                           //块起始符。固定为：0X02
    FLen   : Integer;                        //返回数据包长。长度二个字节
    FACK   : Char;                           //返回码：'P':操作成功;'N':操作失败
    FCM    : Char;                           //命令代码
    FPM    : Char;                           //命令参数
    FRE_DATAB : string;                      //返回的数据包,或者错误代码
    FETX   : Char;                           //块结束符。固定为：0x03
    FBCC   : Char;                           //异或校验和。计算方法：从STX（包括STX）到ETX（包括ETX）之间的每个数据进行异或
  end;

  TM100ReaderVType = (rtInM100, rtOutM100, rtPoundM100, rtGateM100, rtQueueGateM100);
  //虚拟读头类型: 进,出,磅,门闸,队列门闸

  PM100ReaderItem = ^TM100ReaderItem;
  TM100ReaderItem = record
    FID     : string;          //读头标识
    FHost   : string;          //地址
    FPort   : Integer;         //端口

    FCard   : string;          //卡号
    FTunnel : string;          //通道号
    FEnable : Boolean;         //是否启用
    FLocked : Boolean;         //是否锁定
    FLastActive: Int64;        //上次活动

    FVirtual: Boolean;         //虚拟读头
    FVReader: string;          //读头标识
    FVPrinter: string;         //虚拟打印机
    FVHYPrinter: string;       //化验打印机
    FVType  : TM100ReaderVType;  //虚拟类型

    FKeepOnce: Integer;        //单次保持
    FKeepPeer: Boolean;        //保持模式
    FKeepLast: Int64;          //上次活动
    FClient : TIdTCPClient;    //通信链路
  end;

  TM100ReaderThreadType = (ttAll, ttActive);
  //线程模式: 全能;只读活动

  TM100ReaderManager = class;
  TM100Reader = class(TThread)
  private
    FOwner: TM100ReaderManager;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
    FActiveReader: PM100ReaderItem;
    //当前读头
    FThreadType: TM100ReaderThreadType;
    //线程模式
    //FSendItem: TTTCE_M100_Send;
    //FRecvItem: TTTCE_M100_Recv;
    //发送&返回指令
  protected
    procedure DoExecute;
    procedure Execute; override;
    //执行线程
    procedure ScanActiveReader(const nActive: Boolean);
    //扫描可用
    function ReadCard(const nReader: PM100ReaderItem): Boolean;
    //读卡片
    function IsCardValid(const nCard: string): Boolean;
    //校验卡号
  public
    constructor Create(AOwner: TM100ReaderManager; AType: TM100ReaderThreadType);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止线程
  end;

  //----------------------------------------------------------------------------
  THYReaderProc = procedure (const nItem: PM100ReaderItem);
  THYReaderEvent = procedure (const nItem: PM100ReaderItem) of Object;

  TM100ReaderManager = class(TObject)
  private
    FEnable: Boolean;
    //是否启用
    FMonitorCount: Integer;
    FThreadCount: Integer;
    //读卡线程
    FReaderIndex: Integer;
    FReaderActive: Integer;
    //读头索引
    FReaders: TList;
    //读头列表
    FCardLength: Integer;
    FCardPrefix: TStrings;
    //卡号标识
    FSyncLock: TCriticalSection;
    //同步锁定
    FThreads: array[0..cM100Reader_MaxThread-1] of TM100Reader;
    //读卡对象
    FOnProc: THYReaderProc;
    FOnEvent: THYReaderEvent;
    //事件定义
  protected
    procedure ClearReaders(const nFree: Boolean);
    //清理资源
    procedure CloseReader(const nReader: PM100ReaderItem);
    //关闭读头

    function SendStandardCmd(var nData: String;
      nClient: TIdTCPClient=nil): Boolean;
    //发送标准指令

    function InitReader(nPM: Word; nClient: TIdTCPClient=nil): Boolean;
    //初始化读卡器
    function CardMoveIn(nPM: Word; nClient: TIdTCPClient=nil): Boolean;
    //进卡
    function CardMoveOver(nPM: Word; nClient: TIdTCPClient=nil): Boolean;
    //移动卡
    function GetCardSite(nClient: TIdTCPClient=nil): Word;
    //卡片位置
    function HasCard(nClient: TIdTCPClient=nil): Boolean;
    //是否有卡在读卡位置
    function ReaderCancel(nClient: TIdTCPClient=nil): Boolean;
    //取消操作
    function GetCardSerial(nClient: TIdTCPClient=nil): string;
    //获取卡序列号
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure LoadConfig(const nFile: string);
    //载入配置
    procedure StartReader;
    procedure StopReader;
    //启停读头
    function DealtWithCard(const nReader: PM100ReaderItem;
      nRetain: Boolean = True): Boolean;
    //处理ID卡
    property OnCardProc: THYReaderProc read FOnProc write FOnProc;
    property OnCardEvent: THYReaderEvent read FOnEvent write FOnEvent;
    //属性相关
  end;

var
  gM100ReaderManager: TM100ReaderManager = nil;
  //全局使用
  
implementation

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TM100ReaderManager, '三合一读卡器', nEvent);
end;

constructor TM100ReaderManager.Create;
var nIdx: Integer;
begin
  FEnable := False;
  FThreadCount := 1;
  FMonitorCount := 1;  

  for nIdx:=Low(FThreads) to High(FThreads) do
    FThreads[nIdx] := nil;
  //xxxxx

  FCardLength := 0;
  FCardPrefix := TStringList.Create;
  
  FReaders := TList.Create;
  FSyncLock := TCriticalSection.Create;
end;

destructor TM100ReaderManager.Destroy;
begin
  StopReader;
  ClearReaders(True);
  FCardPrefix.Free;

  FSyncLock.Free;
  inherited;
end;

procedure TM100ReaderManager.ClearReaders(const nFree: Boolean);
var nIdx: Integer;
    nItem: PM100ReaderItem;
begin
  for nIdx:=FReaders.Count - 1 downto 0 do
  begin
    nItem := FReaders[nIdx];
    nItem.FClient.Free;
    nItem.FClient := nil;
    
    Dispose(nItem);
    FReaders.Delete(nIdx);
  end;

  if nFree then
    FReaders.Free;
  //xxxxx
end;

procedure TM100ReaderManager.StartReader;
var nIdx,nNum: Integer;
    nType: TM100ReaderThreadType;
begin
  if not FEnable then Exit;
  FReaderIndex := 0;
  FReaderActive := 0;

  nNum := 0;
  //init
  
  for nIdx:=Low(FThreads) to High(FThreads) do
  begin
    if (nNum >= FThreadCount) or
       (nNum > FReaders.Count) then Exit;
    //线程不能超过预定值,或不多余读头个数

    if nNum < FMonitorCount then
         nType := ttAll
    else nType := ttActive;

    if not Assigned(FThreads[nIdx]) then
      FThreads[nIdx] := TM100Reader.Create(Self, nType);
    Inc(nNum);
  end;
end;

procedure TM100ReaderManager.CloseReader(const nReader: PM100ReaderItem);
begin
  if not FEnable then Exit;

  if Assigned(nReader) and Assigned(nReader.FClient) then
  begin
    if not  nReader.FEnable then Exit;
    ReaderCancel(nReader.FClient);
    //取消读卡器操作
    
    nReader.FClient.Disconnect;
    if Assigned(nReader.FClient.IOHandler) then
      nReader.FClient.IOHandler.InputBuffer.Clear;
    //xxxxx
  end;
end;

procedure TM100ReaderManager.StopReader;
var nIdx: Integer;
begin
  for nIdx:=Low(FThreads) to High(FThreads) do
   if Assigned(FThreads[nIdx]) then
    FThreads[nIdx].Terminate;
  //设置退出标记

  for nIdx:=Low(FThreads) to High(FThreads) do
  begin
    if Assigned(FThreads[nIdx]) then
      FThreads[nIdx].StopMe;
    FThreads[nIdx] := nil;
  end;

  FSyncLock.Enter;
  try
    for nIdx:=FReaders.Count - 1 downto 0 do
      CloseReader(FReaders[nIdx]);
    //关闭读头
  finally
    FSyncLock.Leave;
  end;
end;

procedure TM100ReaderManager.LoadConfig(const nFile: string);
var nIdx, i: Integer;
    nXML: TNativeXml;  
    nReader: PM100ReaderItem;
    nRoot,nNode,nTmp: TXmlNode;
begin
  FEnable := False;
  if not FileExists(nFile) then Exit;

  nXML := nil;
  try
    nXML := TNativeXml.Create;
    nXML.LoadFromFile(nFile);

    nRoot := nXML.Root.FindNode('config');
    if Assigned(nRoot) then
    begin
      nNode := nRoot.FindNode('enable');
      if Assigned(nNode) then
        Self.FEnable := nNode.ValueAsString <> 'N';
      //xxxxx

      nNode := nRoot.FindNode('cardlen');
      if Assigned(nNode) then
           FCardLength := nNode.ValueAsInteger
      else FCardLength := 0;

      nNode := nRoot.FindNode('cardprefix');
      if Assigned(nNode) then
           SplitStr(UpperCase(nNode.ValueAsString), FCardPrefix, 0, ',')
      else FCardPrefix.Clear;

      nNode := nRoot.FindNode('thread');
      if Assigned(nNode) then
           FThreadCount := nNode.ValueAsInteger
      else FThreadCount := 1;

      if (FThreadCount < 1) or (FThreadCount > cM100Reader_MaxThread) then
        raise Exception.Create('TTCE_M100 Reader Thread-Num Need Between 1-10.');
      //xxxxx

      nNode := nRoot.FindNode('monitor');
      if Assigned(nNode) then
           FMonitorCount := nNode.ValueAsInteger
      else FMonitorCount := 1;

      if (FMonitorCount < 1) or (FMonitorCount > FThreadCount) then
        raise Exception.Create(Format(
          'TTCE_M100 Reader Monitor-Num Need Between 1-%d.', [FThreadCount]));
      //xxxxx
    end;

    //--------------------------------------------------------------------------
    nRoot := nXML.Root.FindNode('readers');
    if not Assigned(nRoot) then Exit;
    ClearReaders(False);

    for nIdx:=0 to nRoot.NodeCount - 1 do
    begin
      nNode := nRoot.Nodes[nIdx];
      if CompareText(nNode.Name, 'reader') <> 0 then Continue;

      New(nReader);
      FReaders.Add(nReader);

      with nNode,nReader^ do
      begin
        FLocked := False;
        FKeepLast := 0;
        FLastActive := GetTickCount;

        FID := AttributeByName['id'];
        FHost := NodeByName('ip').ValueAsString;
        FPort := NodeByName('port').ValueAsInteger;
        FEnable := NodeByName('enable').ValueAsString <> 'N';

        nTmp := FindNode('tunnel');
        if Assigned(nTmp) then
          FTunnel := nTmp.ValueAsString;
        //通道号

        nTmp := FindNode('virtual');
        if Assigned(nTmp) then
        begin
          FVirtual := nTmp.ValueAsString = 'Y';
          FVReader := nTmp.AttributeByName['reader'];
          FVPrinter:= nTmp.AttributeByName['printer'];
          FVHYPrinter := nTmp.AttributeByName['hy_printer'];

          i := StrToIntDef(nTmp.AttributeByName['type'], 0);
          case i of
           1: FVType := rtInM100;
           2: FVType := rtOutM100;
           3: FVType := rtPoundM100;
           4: FVType := rtGateM100;
           5: FVType := rtQueueGateM100 else FVType := rtGateM100;
          end;
        end else
        begin
          FVirtual := False;
          //默认不虚拟
        end;

        nTmp := FindNode('keeponce');
        if Assigned(nTmp) then
        begin
          FKeepOnce := nTmp.ValueAsInteger;
          FKeepPeer := nTmp.AttributeByName['keeppeer'] = 'Y';
        end else
        begin
          FKeepOnce := 0;
          //默认不合并
        end;

        FClient := TIdTCPClient.Create;
        with FClient do
        begin
          Host := FHost;
          Port := FPort;
          ReadTimeout := 3 * 1000;
          ConnectTimeout := 3 * 1000;   
        end;  
      end;
    end;
  finally
    nXML.Free;
  end;
end;


//------------------------------------------------------------------------------
//Date: 2015-02-08
//Parm: 字符串信息;字符数组
//Desc: 字符串转数组
function Str2Buf(const nStr: string; var nBuf: TIdBytes): Integer;
var nIdx: Integer;
begin
  Result := Length(nStr);;
  SetLength(nBuf, Result);

  for nIdx:=1 to Result do
    nBuf[nIdx-1] := Ord(nStr[nIdx]);
  //xxxxx
end;

//Date: 2015-07-08
//Parm: 目标字符串;原始字符数组
//Desc: 数组转字符串
function Buf2Str(const nBuf: TIdBytes): string;
var nIdx,nLen: Integer;
begin
  nLen := Length(nBuf);
  SetLength(Result, nLen);

  for nIdx:=1 to nLen do
    Result[nIdx] := Char(nBuf[nIdx-1]);
  //xxxxx
end;

//Date: 2015-12-06
//Parm: 二进制串
//Desc: 格式化nBin为十六进制串
function HexStr(const nBin: string): string;
var nIdx,nLen: Integer;
begin
  nLen := Length(nBin);
  SetLength(Result, nLen * 2);

  for nIdx:=1 to nLen do
    StrPCopy(@Result[2*nIdx-1], IntToHex(Ord(nBin[nIdx]), 2));
  //xxxxx
end;

//Date: 2016/4/22
//Parm: 
//Desc: BCC异或校验算法
function CalcStringBCC(const nData: string; const nLen: Integer=-1;
  const nInit: Word=0): Word;
var nIdx, nLenTemp: Integer;
begin
  Result := nInit;

  if nLen < 0 then
       nLenTemp := Length(nData)
  else nLenTemp := nLen;

  for nIdx := 1 to nLenTemp do
    Result := Result xor Ord(nData[nIdx]);
end;

//Date: 2016/4/22
//Parm:
//Desc: 封装读卡器指令
function PackSendData(const nData:PTTCE_M100_Send): string;
var nBCC: Word;
begin
  Result := nData.FSTX +
            Chr(nData.FLen div 256) +
            Chr(nData.FLen mod 256) +
            nData.FCM +
            nData.FPM +
            nData.FSE_DATAB +
            nData.FETX;
  //len addr cmd data

  nBCC := CalcStringBCC(Result);
  Result := Result + Chr(nBCC);
end;

//Date: 2015-07-08
//Parm: 目标结构;待解析
//Desc: 华益通信协议解析
function UnPackRecvData(const nItem:PTTCE_M100_Recv; const nData: string): Boolean;
var nInt,nLen: Integer;
    nBCC: Word;
begin
  Result := False;
  nInt := Length(nData);
  if nInt < 1 then Exit;    

  nLen := Ord(nData[2]) * 256 + Ord(nData[3]);
  if nLen <> nInt-5 then Exit;
  //数据长度不对,

  nBCC := CalcStringBCC(nData);
  if nBCC <> 0 then Exit;
  //BCC error

  with nItem^ do
  begin
    FSTX     := nData[1];
    FLen     := nLen;

    FACK     := nData[4];
    FCM      := nData[5];
    FPM      := nData[6];

    FRE_DATAB:= Copy(nData, 7, nLen-3);
    FETX     := nData[nLen + 4];

    Result   := FACK = cTTCE_M100_Success;
    //correct command
  end;
end;

//Date: 2016/4/23
//Parm: 
//Desc: 发送读卡器指令
function TM100ReaderManager.SendStandardCmd(var nData: String;
  nClient: TIdTCPClient): Boolean;
var nLen: Integer;
    nByteBuf: TIdBytes;
    nStr, nSend: string;
begin
  Result := False;
  if not Assigned(nClient) then Exit;

  with nClient do
  try
    if Assigned(IOHandler) then
      IOHandler.InputBuffer.Clear;
    //Clear Input Buffer

    if not Connected then Connect;
    //xxxxx

    nSend := nData;
    nLen  := Str2Buf(nSend, nByteBuf);
    Socket.Write(nByteBuf, nLen, 0);
    //Send Command

    nData := '';
    //Init Result

    SetLength(nByteBuf, 0);
    Socket.ReadBytes(nByteBuf, 1, False);
    nStr := Buf2Str(nByteBuf);

    if nStr = Chr(cTTCE_M100_EOT) then
    begin
      nData := '取消命令操作成功';

      WriteLog(nData);
      Exit;
    end else
    //Cancel Operation

    if nStr = Chr(cTTCE_M100_NAK) then
    begin
      nData := '读卡器校验BCC失败';

      WriteLog(nData);
      Exit;
    end;
    //BCC Error

    if nStr <> Chr(cTTCE_M100_ACK) then Exit;
    //If not ACK

    nStr := Chr(cTTCE_M100_ENQ);
    nLen := Str2Buf(nStr, nByteBuf);
    Socket.Write(nByteBuf, nLen, 0);
    //Send ENQ

    while True do
    begin
      if not Connected then Exit;

      SetLength(nByteBuf, 0);
      Socket.ReadBytes(nByteBuf, 1, False);
      nStr := Buf2Str(nByteBuf);
      if nStr = Chr(cTTCE_M100_STX) then Break;
    end;
    // Get STX

    nData := nData + nStr;
    //STX

    SetLength(nByteBuf, 0);
    Socket.ReadBytes(nByteBuf, 2, False);
    nStr := ToHex(nByteBuf);
    nLen := StrToInt('$' + nStr);
    //Get Length

    nData := nData + Buf2Str(nByteBuf);
    //Length

    SetLength(nByteBuf, 0);
    Socket.ReadBytes(nByteBuf, nLen+2, False);
    //Get Data

    nData := nData + Buf2Str(nByteBuf);
    //Data

    nLen := CalcStringBCC(nData, Length(nData), 0);
    if nLen <> 0 then
    begin
      nData := nData + nStr;

      WriteLog('读卡器发送的数据BCC校验失败');
      Exit;
    end;  
    //Check BCC
    
    Result := True;
  except
    on E: Exception do
    begin
      if Connected then
      begin
        Disconnect;
        if Assigned(IOHandler) then
          IOHandler.InputBuffer.Clear;
      end;

      WriteLog(E.Message);
    end;  
  end;
end;

//Date: 2016/4/22
//Parm: 
//Desc: 初始化读卡器($30、复位无动作;$31、复位并前端弹卡;$32、复位并后端弹卡;$33、复位重入卡)
function TM100ReaderManager.InitReader(nPM: Word; nClient: TIdTCPClient): Boolean;
var nCmd: string;
    nSendItem: TTTCE_M100_Send;
    nRecvItem: TTTCE_M100_Recv;
begin
  Result := False;
  //Init Result

  with nSendItem do
  begin
    FSTX := Chr(cTTCE_M100_STX);
    FETX := Chr(cTTCE_M100_ETX);
    FCM  := Chr($30);
    FPM  := Chr(nPM);
    FSE_DATAB:= '';
    FLen := 2 + Length(FSE_DATAB);
  end;

  nCmd := PackSendData(@nSendItem);
  if not SendStandardCmd(nCmd, nClient) then Exit;

  Result := UnPackRecvData(@nRecvItem, nCmd);
end;  

//Date: 2016/4/22
//Parm:
//Desc: 进卡($30、等待方式前进卡;$31、磁卡等待方式前进卡;$32、等待方式后进卡;
//      $33、禁止进卡;$34、立即前进卡;$35、磁卡立即进卡)
function TM100ReaderManager.CardMoveIn(nPM: Word; nClient: TIdTCPClient): Boolean;
var nCmd: string;
    nSendItem: TTTCE_M100_Send;
    nRecvItem: TTTCE_M100_Recv;
begin
  Result := False;
  //Init Result

  with nSendItem do
  begin
    FSTX := Chr(cTTCE_M100_STX);
    FETX := Chr(cTTCE_M100_ETX);
    FCM  := Chr($32);
    FPM  := Chr(nPM);
    FSE_DATAB:= '';
    FLen := 2 + Length(FSE_DATAB);
  end;

  nCmd := PackSendData(@nSendItem);
  if not SendStandardCmd(nCmd, nClient) then Exit;

  Result := UnPackRecvData(@nRecvItem, nCmd);
end;

//Date: 2016/4/22
//Parm:
//Desc: 移动卡($30、将卡片移到读卡器内部;$31、将卡片移到IC卡位置;$32、将卡片移到前端夹卡位置;
//      $33、将卡片移到后端夹卡位置;$34、将卡片从前端弹出;$35、将卡片从后端弹出)
function TM100ReaderManager.CardMoveOver(nPM: Word; nClient: TIdTCPClient): Boolean;
var nCmd: string;
    nSendItem: TTTCE_M100_Send;
    nRecvItem: TTTCE_M100_Recv;
begin
  Result := False;
  //Init Result

  with nSendItem do
  begin
    FSTX := Chr(cTTCE_M100_STX);
    FETX := Chr(cTTCE_M100_ETX);
    FCM  := Chr($33);
    FPM  := Chr(nPM);
    FSE_DATAB:= '';
    FLen := 2 + Length(FSE_DATAB);
  end;

  nCmd := PackSendData(@nSendItem);
  if not SendStandardCmd(nCmd, nClient) then Exit;

  Result := UnPackRecvData(@nRecvItem, nCmd);
end;

//Date: 2016/4/22
//Parm: 
//Desc: 获取卡片位置
function TM100ReaderManager.GetCardSite(nClient: TIdTCPClient): Word;
var nCmd: string;
    nSendItem: TTTCE_M100_Send;
    nRecvItem: TTTCE_M100_Recv;
begin
  Result := cTTCE_M100_GetSiteErr;
  with nSendItem do
  begin
    FSTX := Chr(cTTCE_M100_STX);
    FETX := Chr(cTTCE_M100_ETX);
    FCM  := Chr($31);
    FPM  := Chr($30);
    FSE_DATAB:= '';
    FLen := 2 + Length(FSE_DATAB);
  end;

  nCmd := PackSendData(@nSendItem);
  if not SendStandardCmd(nCmd, nClient) then Exit;
  if (not UnPackRecvData(@nRecvItem, nCmd)) or (nRecvItem.FRE_DATAB = '') then Exit;

  Result := StrToInt(nRecvItem.FRE_DATAB);
end;

//Date: 2016/4/22
//Parm: 
//Desc: 是否有卡在读卡位置
function TM100ReaderManager.HasCard(nClient: TIdTCPClient): Boolean;
var nSite: Integer;
begin
  nSite := GetCardSite(nClient);
  Result := (nSite = 3) or (nSite = 2) or (nSite = 6);
end;  

function TM100ReaderManager.ReaderCancel(nClient: TIdTCPClient): Boolean;
var nCmd :string;
begin
  nCmd := Chr(cTTCE_M100_EOT);
  Result := SendStandardCmd(nCmd, nClient);
end;

//Date: 2012-4-22
//Parm: 16位卡号数据
//Desc: 格式化nCard为标准卡号
function ParseCardNO(const nCard: string; const nHex: Boolean): string;
var nInt: Int64;
    nIdx: Integer;
begin
  if nHex then
  begin
    Result := '';
    for nIdx:=Length(nCard) downto 1 do
      Result := Result + IntToHex(Ord(nCard[nIdx]), 2);
    //xxxxx
  end else Result := nCard;

  nInt := StrToInt64('$' + Result);
  Result := IntToStr(nInt);
  Result := StringOfChar('0', 12 - Length(Result)) + Result;
end;

function TM100ReaderManager.GetCardSerial(nClient: TIdTCPClient=nil): string;
var nCmd: string;
    nSendItem: TTTCE_M100_Send;
    nRecvItem: TTTCE_M100_Recv;
begin
  Result := '';
  with nSendItem do
  begin
    FSTX := Chr(cTTCE_M100_STX);
    FETX := Chr(cTTCE_M100_ETX);
    FCM  := Chr($3C);
    FPM  := Chr($31);
    FSE_DATAB:= '';
    FLen := 2 + Length(FSE_DATAB);
  end;

  nCmd := PackSendData(@nSendItem);
  if not SendStandardCmd(nCmd, nClient) then Exit;
  if not UnPackRecvData(@nRecvItem, nCmd) then Exit;

  nCmd := Copy(nRecvItem.FRE_DATAB, 1, 4);
  Result := ParseCardNO(nCmd, True);
  //卡序列号 4位
end;

//Date: 2016/4/23
//Parm: 
//Desc: 业务完成后根据读卡器类型处理磁卡
function TM100ReaderManager.DealtWithCard(const nReader: PM100ReaderItem;
  nRetain: Boolean): Boolean;
begin
  if (nReader.FVType = rtOutM100) and nRetain then
         Result := InitReader($32, nReader.FClient)
  else   Result := InitReader($31, nReader.FClient);
end;

//------------------------------------------------------------------------------
constructor TM100Reader.Create(AOwner: TM100ReaderManager;
  AType: TM100ReaderThreadType);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FThreadType := AType;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := cM100Reader_Wait_Short;
end;

destructor TM100Reader.Destroy;
begin
  FWaiter.Free;
  inherited;
end;

procedure TM100Reader.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TM100Reader.Execute;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    FActiveReader := nil;
    try
      DoExecute;
    finally
      if Assigned(FActiveReader) then
      begin
        FOwner.FSyncLock.Enter;
        FActiveReader.FLocked := False;
        FOwner.FSyncLock.Leave;
      end;
    end;
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      Sleep(500);
    end;
  end;
end;

//Date: 2015-12-06
//Parm: 活动&不活动读头
//Desc: 扫描nActive读头,若可用存入FActiveReader.
procedure TM100Reader.ScanActiveReader(const nActive: Boolean);
var nIdx: Integer;
    nReader: PM100ReaderItem;
begin
  if nActive then //扫描活动读头
  with FOwner do
  begin
    if FReaderActive = 0 then
         nIdx := 1
    else nIdx := 0; //从0开始为完整一轮

    while True do
    begin
      if FReaderActive >= FReaders.Count then
      begin
        FReaderActive := 0;
        Inc(nIdx);

        if nIdx >= 2 then Break;
        //扫描一轮,无效退出
      end;

      nReader := FReaders[FReaderActive];
      Inc(FReaderActive);
      if nReader.FLocked or (not nReader.FEnable) then Continue;

      if nReader.FLastActive > 0 then 
      begin
        FActiveReader := nReader;
        FActiveReader.FLocked := True;
        Break;
      end;
    end;
  end else

  with FOwner do //扫描不活动读头
  begin
    if FReaderIndex = 0 then
         nIdx := 1
    else nIdx := 0; //从0开始为完整一轮

    while True do
    begin
      if FReaderIndex >= FReaders.Count then
      begin
        FReaderIndex := 0;
        Inc(nIdx);

        if nIdx >= 2 then Break;
        //扫描一轮,无效退出
      end;

      nReader := FReaders[FReaderIndex];
      Inc(FReaderIndex);
      if nReader.FLocked or (not nReader.FEnable) then Continue;

      if nReader.FLastActive = 0 then 
      begin
        FActiveReader := nReader;
        FActiveReader.FLocked := True;
        Break;
      end;
    end;
  end;
end;

procedure TM100Reader.DoExecute;
begin
  FOwner.FSyncLock.Enter;
  try
    if FThreadType = ttAll then
    begin
      ScanActiveReader(False);
      //优先扫描不活动读头

      if not Assigned(FActiveReader) then
        ScanActiveReader(True);
      //辅助扫描活动项
    end else

    if FThreadType = ttActive then //只扫活动线程
    begin
      ScanActiveReader(True);
      //优先扫描活动读头

      if Assigned(FActiveReader) then
      begin
        FWaiter.Interval := cM100Reader_Wait_Short;
        //有活动读头,加速
      end else
      begin
        FWaiter.Interval := cM100Reader_Wait_Long;
        //无活动读头,降速
        ScanActiveReader(False);
        //辅助扫描不活动项
      end;
    end;
  finally
    FOwner.FSyncLock.Leave;
  end;

  if Assigned(FActiveReader) and (not Terminated) then
  try
    if ReadCard(FActiveReader) then
    begin
      if FThreadType = ttActive then
        FWaiter.Interval := cM100Reader_Wait_Short;
      FActiveReader.FLastActive := GetTickCount;
    end else
    begin
      if (FActiveReader.FLastActive > 0) and
         (GetTickCount - FActiveReader.FLastActive >= 5 * 1000) then
        FActiveReader.FLastActive := 0;
      //无卡片时,自动转为不活动
    end;
  except
    on E:Exception do
    begin
      FActiveReader.FLastActive := 0;
      //置为不活动

      WriteLog(Format('Reader:[ %s:%d ] Msg: %s', [FActiveReader.FHost,
        FActiveReader.FPort, E.Message]));
      //xxxxx

      FOwner.CloseReader(FActiveReader);
      //focus reconnect
    end;
  end;
end;

//Date: 2015-12-07
//Parm: 卡号
//Desc: 验证nCard是否有效
function TM100Reader.IsCardValid(const nCard: string): Boolean;
var nIdx: Integer;
begin
  with FOwner do
  begin
    Result := False;
    nIdx := Length(Trim(nCard));
    if (nIdx < 1) or ((FCardLength > 0) and (nIdx < FCardLength)) then Exit;
    //leng verify

    Result := FCardPrefix.Count = 0;
    if Result then Exit;

    for nIdx:=FCardPrefix.Count - 1 downto 0 do
     if Pos(FCardPrefix[nIdx], nCard) = 1 then
     begin
       Result := True;
       Exit;
     end;
  end;
end;

function TM100Reader.ReadCard(const nReader: PM100ReaderItem): Boolean;
var nCard: string;
begin
  Result := False;
  //Init Result

  with FOwner, nReader^ do
  try
    if not FClient.Connected then
    begin
      FClient.Connect;
      InitReader($31, FClient);
    end;
    //读卡器初次连接,复位并弹出卡片

    if HasCard(FClient) then
    begin
      nCard := GetCardSerial(FClient);
      if nCard = '' then
      begin
        InitReader($31, FClient);
        Exit;
      end;
      //读卡失败,复位并且弹卡
    end else

    begin
      CardMoveIn($34, FClient);
      Exit;
      //如果没有卡片,发送立即进卡指令
    end;

    if (not Terminated) then
    begin
      Result := True;
      //read success
    
      if nReader.FKeepOnce > 0 then
      begin
        if CompareText(nCard, nReader.FCard) = 0 then
        begin
          if GetTickCount - nReader.FKeepLast < nReader.FKeepOnce then
          begin
            if not nReader.FKeepPeer then
              nReader.FKeepLast := GetTickCount;
            Exit;
          end;
        end;

        nReader.FKeepLast := GetTickCount;
        //同卡号连刷压缩
      end;

      nReader.FCard := nCard;
      //multi card
    
      if Assigned(FOwner.FOnProc) then
        FOwner.FOnProc(nReader);
      //xxxxx

      if Assigned(FOwner.FOnEvent) then
        FOwner.FOnEvent(nReader);
      //xxxxx
    end;
  except
    on E: Exception do
    begin
      FClient.Disconnect;
      if Assigned(FClient.IOHandler) then
        FClient.IOHandler.InputBuffer.Clear;
      //xxxxx

      WriteLog(E.Message);
    end;
  end;
end;

initialization
  gM100ReaderManager := nil;
finalization
  FreeAndNil(gM100ReaderManager);
end.
