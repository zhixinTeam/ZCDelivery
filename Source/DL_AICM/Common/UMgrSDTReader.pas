{*******************************************************************************
作者: fendou116688@163.com 2016/6/3
描述: 身份证读卡器管理单元
*******************************************************************************}
unit UMgrSDTReader;

interface

uses
  Windows, SysUtils, Classes, Forms, Graphics, NativeXml, UWaitItem, ULibFun,
  USysLoger, JclUnicode, UMgrSDTReader_Head, SyncObjs, IdGlobal;

type
  PSDTReaderItem = ^TSDTReaderItem;
  TSDTReaderItem = record
    FID: string;            //标识
    FName: string;          //名称
    FIsUSB: Boolean;        //是否USB端口
    FEnabled: Boolean;      //是否启用
    FIfOpen: Integer;       //接口内部打开关闭端口
    FImgEnable: Boolean;    //是否生成图片

    FPort: Integer;         //端口号
    FBaud: Integer;         //波特率
    FMaxBytes: Integer;     //最大通讯字节
    FOpenPortRtn: Integer;  //端口是否打开
  end;

  TIdCardInfoStr = record
    FName: string;                        //姓名
    FSex : string;                        //性别

    FNation: string;                      //民族
    FBirthDay:string;                     //生日
    FAddr : string;                       //地址
    FIdSN : string;                       //证件号

    FIssueOrgan: string;                  //住址
    FVaildBegin: string;                  //有效期头
    FVaildEnd  : string;                  //有效期尾
    FtheNewestAddr: string;               //新地址
  end;

  TSDTReaderManager = class;
  TSDTReaderThread = class(TThread)
  private
    FOwner: TSDTReaderManager;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
    FNowItem: PSDTReaderItem;
    //当前对象
  protected
    procedure Execute; override;
    //执行线程
    procedure ReadCard(nRead: PSDTReaderItem);
    //读身份证号
    procedure UnPackIDCardInfo(var nCardStr: TIdCardInfoStr;
      nCardWChar: TIdCardInfoWChar);
    //转换身份证信息  
  public
    constructor Create(AOwner: TSDTReaderManager);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止线程
  end;

  TSDTProc  = procedure (const nCard: TIdCardInfoStr;const nReader: TSDTReaderItem);
  TSDTEvent = procedure (const nCard: TIdCardInfoStr;const nReader: TSDTReaderItem) of Object;
  //读卡事件
  TIMGProc  = procedure (const nFile: string; const nReader: TSDTReaderItem);
  TIMGEvent = procedure (const nFile: string; const nReader: TSDTReaderItem) of Object;
  //照片事件

  TSDTReaderManager = class(TObject)
  private
    FReaders: TList;
    //读卡器列表
    FTempDir: string;
    //临时目录
    FReader: TSDTReaderThread;
    //发送线程
    FSyncLock: TCriticalSection;
    //临界资源
    FSDTProc: TSDTProc;
    FSDTEvent: TSDTEvent;
    //事件相关
    FIMGProc: TIMGProc;
    FIMGEvent: TIMGEvent;
    //事件相关
  protected
    procedure ClearList(const nFree: Boolean);
    //清理资源
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure LoadConfig(const nFile: string);
    procedure StartReader;
    procedure StopReader;
    //启停读卡
    property Readers: TList read FReaders;
    property TempDir: string read FTempDir write FTempDir;
    //属性相关
    property OnSDTProc: TSDTProc read FSDTProc write FSDTProc;
    property OnSDTEvent: TSDTEvent read FSDTEvent write FSDTEvent;
    property OnIMGProc: TIMGProc read FIMGProc write FIMGProc;
    property OnIMGEvent: TIMGEvent read FIMGEvent write FIMGEvent;
    //事件相关
  end;

var
  gSDTReaderManager: TSDTReaderManager = nil;
  //全局使用

implementation

//------------------------------------------------------------------------------
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TSDTReaderManager, '身份证读卡器管理器', nEvent);
end;

constructor TSDTReaderThread.Create(AOwner: TSDTReaderManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FOwner := AOwner;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 5 * 10;
end;

destructor TSDTReaderThread.Destroy;
begin
  FWaiter.Free;
  inherited;
end;

//Desc: 停止(外部调用)
procedure TSDTReaderThread.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TSDTReaderThread.Execute;
var nIdx: Integer;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Break;

    with FOwner do
    begin
      FSyncLock.Enter;
      try
        for nIdx := 0 to FReaders.Count - 1 do
        begin
          FNowItem := FReaders[nIdx];
          if not FNowItem.FEnabled then Continue;

          ReadCard(FNowItem);
        end;  
      finally
        FSyncLock.Leave;
      end;
    end;
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

procedure TSDTReaderThread.ReadCard(nRead: PSDTReaderItem);
var nErr: string;
    nFS: TFileStream;
    nCardInfoStr: TIdCardInfoStr;
    nCardInfoWC:TIdCardInfoWChar;
    nRet, nIdx, nMInfo, nSNO: Integer;
    nIDInfo, nWLTInfo: array [0..2048] of Byte;
begin
  with nRead^ do
  begin
    if Terminated then Exit;

    if FIsUSB then
    begin
      if (FPort < 1001) or (FPort > 1016)  then
      begin
        for nIdx := 1001 to 1016 do
        begin
          FOpenPortRtn:= SDT_OpenPort(nIdx);
          if FOpenPortRtn = cReader_OperateOK then
          begin
            FPort:= nIdx;
            break;
          end;
        end;
      end else

      begin
        FOpenPortRtn:= SDT_OpenPort(FPort);
      end;
    end else

    begin
      if (FPort < 0) or (FPort > 16) then
      begin
        for nIdx := 1 to 16 do     //串口1-16
        begin
          FOpenPortRtn:= SDT_OpenPort(nIdx);
          if FOpenPortRtn = cReader_OperateOK then
          begin
            FPort:= nIdx;
            break;
          end;
        end;
      end else

      begin
        FOpenPortRtn:= SDT_OpenPort(FPort);
      end;
    end;

    if FOpenPortRtn <> cReader_OperateOK then
    begin
      nErr := ERROR_ICREADER_OPEN_PORT;
      {$IFDEF DEBUG}
      WriteLog(nErr);
      {$ENDIF}
      Exit;
    end;

    //下面找卡
    for nIdx := 0 to cTry_Times -1 do
    begin
      nRet:= SDT_StartFindIDCard(FPort, nMInfo, FIfOpen);

      if nRet = cReader_FindCardOK then Break;
    end;  

//    if nRet <> cReader_FindCardOK then
//    begin
//      SDT_ClosePort(FPort);
//      nErr := TIP_ICREADER_NO_CARD;
//      {$IFDEF DEBUG}
//      WriteLog(nErr);
//      {$ENDIF}
//      Exit;
//    end;

    //选卡
    for nIdx := 0 to cTry_Times -1 do
    begin
      nRet:= SDT_SelectIDCard(FPort, nSNO, FIfOpen);

      if nRet = cReader_OperateOK then Break;
    end;  

//    if nRet <> cReader_OperateOK then
//    begin
//      SDT_ClosePort(FPort);
//      nErr := TIP_ICREADER_READ_FAILED;
//      {$IFDEF DEBUG}
//      WriteLog(nErr);
//      {$ENDIF}
//      Exit;
//    end;

    if FOwner.TempDir = '' then FOwner.TempDir := 'D:\身份证读卡列表\';
    if not DirectoryExists(FOwner.TempDir) then
      ForceDirectories(FOwner.TempDir);

    //注意，在这里，用户必须有应用程序当前目录的读写权限
    if FileExists(FOwner.TempDir + TIP_FILE_TXT) then
      DeleteFile(FOwner.TempDir + TIP_FILE_TXT);
    if FileExists(FOwner.TempDir + TIP_FILE_BMP) then
      DeleteFile(FOwner.TempDir + TIP_FILE_BMP);
    if FileExists(FOwner.TempDir + TIP_FILE_WLT) then
      DeleteFile(FOwner.TempDir + TIP_FILE_WLT);

//    nRet := SDT_ReadBaseMsgToFile(FPort,
//            PAnsiChar(FOwner.TempDir + TIP_FILE_TXT), nMInfo,
//            PAnsiChar(FOwner.TempDir + TIP_FILE_WLT), nSNO, 1);

    FillChar(nIDInfo, SizeOf(nIDInfo), #0);
    FillChar(nWLTInfo, SizeOf(nWLTInfo), #0);
    nRet := SDT_ReadBaseMsg(FPort, @nIDInfo, nMInfo, @nWLTInfo, nSNO, 1);
    if nRet <> cReader_OperateOK then
    begin
      SDT_ClosePort(FPort);
      nErr := TIP_ICREADER_READ_FAILED;
      {$IFDEF DEBUG}
      WriteLog(nErr);
      {$ENDIF}
      Exit;
    end;

    SDT_ClosePort(FPort);
    //关闭端口
//
//    nFS := TFileStream.Create(FOwner.TempDir + TIP_FILE_TXT, fmOpenRead);
//    try
//      nFS.Position:= 0;
//      nFS.Read(nCardInfoWC ,SizeOf(TIdCardInfoWChar));
//    finally
//      FreeAndNil(nFS);
//    end;
    if FImgEnable then
    begin
      try
        nFS := TFileStream.Create(FOwner.TempDir + TIP_FILE_WLT, fmCreate);

        nFS.Write(nWLTInfo, nSNO);
      finally
        FreeAndNil(nFS);
      end;
    end;

    Move(nIDInfo, nCardInfoWC, nMInfo);
    UnPackIDCardInfo(nCardInfoStr, nCardInfoWC);
    //转换身份证信息

    if Assigned(FOwner.OnSDTProc) then
      FOwner.OnSDTProc(nCardInfoStr, nRead^);

    if Assigned(FOwner.OnSDTEvent) then
      FOwner.OnSDTEvent(nCardInfoStr, nRead^);

    if FImgEnable then
    try
      case FIsUSB of
      True : nRet := GetBmp(PChar(FOwner.TempDir + TIP_FILE_WLT), 2);
      False: nRet := GetBmp(PChar(FOwner.TempDir + TIP_FILE_WLT), 1);
      end;
      //注意，如果在C盘根目录下没有机具厂商的授权文件Termb.Lic，照片解析将会失败

      case nRet of
      0: nErr := TIP_ICREADER_CALL_DLL_FAILED;
      1: nErr := TIP_OK;
      -1: nErr := TIP_ICREADER_PICTURE_DECODE_FAILED;
      -2: nErr := TIP_ICREADER_WLT_FILE_EXTEND_FAILED;
      -3: nErr := TIP_ICREADER_WLT_FILE_OPEN_FAILED;
      -4: nErr := TIP_ICREADER_WLT_FILE_FORMAT_FAILED;
      -5: nErr := TIP_ICREADER_NO_LICENSE;
      -6: nErr := TIP_ICREADER_DEVICE_FAILED;
      -7: nErr := TIP_ICREADER_CALL_WLTDLL_FAILED;
      -8: nErr := TIP_ICREADER_CALL_GetBmp_FAILED;
      end;

      if nRet <> 1 then
      begin
        {$IFDEF DEBUG}
        WriteLog(nErr);
        {$ENDIF}
        Exit;
      end;

      if Assigned(FOwner.OnIMGProc) then
        FOwner.OnIMGProc(FOwner.TempDir + TIP_FILE_BMP, nRead^);

      if Assigned(FOwner.OnIMGEvent) then
        FOwner.OnIMGEvent(FOwner.TempDir + TIP_FILE_BMP, nRead^);
    except
      on E: Exception do
      begin
        WriteLog(E.Message);
      end;
    end;
  end;
end;

procedure TSDTReaderThread.UnPackIDCardInfo(var nCardStr: TIdCardInfoStr;
  nCardWChar: TIdCardInfoWChar);
begin
  with nCardStr, nCardWChar do
  begin
    FName := AnsiString(Name);
    //姓名

    if AnsiString(Sex)= '1' then
         FSex := '男'
    else FSex := '女';
    //性别

    FNation := EthnicNoToName(AnsiString(Nation));
    //民族
    FBirthDay:= Trim(AnsiString(BirthDay));
    //出生年月日
    FAddr   := Trim(AnsiString(Addr));
    //住址
    FIdSN   := Trim(AnsiString(IdSN));
    //身份证号码

    FIssueOrgan:= Trim(AnsiString(IssueOrgan));
    //发证机构
    FVaildBegin:= Trim(AnsiString(VaildBegin));
    //有效日期开始
    if Trim(AnsiString(VaildEnd)) = '长期' then
         FVaildEnd:= FormatDateTime('yyyy-MM-dd', MaxDateTime)
    else FVaildEnd:= Trim(AnsiString(VaildEnd));
    //有效日期结束
  end;
end;    

//------------------------------------------------------------------------------
constructor TSDTReaderManager.Create;
begin
  FReaders := TList.Create;
  FSyncLock := TCriticalSection.Create;
end;

destructor TSDTReaderManager.Destroy;
begin
  StopReader;
  ClearList(True);
  FSyncLock.Free;
  inherited;
end;

procedure TSDTReaderManager.ClearList(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FReaders.Count - 1 downto 0 do
  begin
    Dispose(PSDTReaderItem(FReaders[nIdx]));
    FReaders.Delete(nIdx);
  end;

  if nFree then FreeAndNil(FReaders);
end;

procedure TSDTReaderManager.StartReader;
begin
  if not Assigned(FReader) then
    FReader := TSDTReaderThread.Create(Self);
  FReader.FWaiter.Wakeup;
end;

procedure TSDTReaderManager.StopReader;
begin
  if Assigned(FReader) then
    FReader.StopMe;
  FReader := nil;
end;

//------------------------------------------------------------------------------
//Desc: 读取nFile
procedure TSDTReaderManager.LoadConfig(const nFile: string);
var nIdx: Integer;
    nItem: TSDTReaderItem;
    nReader: PSDTReaderItem;
    nXML: TNativeXml;
    nNode,nTmp: TXmlNode;
begin
  nXML := TNativeXml.Create;
  try
    ClearList(False);
    nXML.LoadFromFile(nFile);
    
    for nIdx:=0 to nXML.Root.NodeCount - 1 do
    with nItem do
    begin
      nNode := nXML.Root.Nodes[nIdx];
      FID := nNode.AttributeByName['ID'];
      FName := nNode.AttributeByName['Name'];

      nTmp := nNode.FindNode('IsUSB');
      if Assigned(nTmp) then
           FIsUSB := nTmp.ValueAsString <> 'N'
      else FIsUSB := True;

      nTmp := nNode.FindNode('enable');
      if Assigned(nTmp) then
           FEnabled := nTmp.ValueAsString <> 'N'
      else FEnabled := True;

      nTmp := nNode.FindNode('port');
      if Assigned(nTmp) then
           FPort := nTmp.ValueAsInteger
      else FPort := 0;

      nTmp := nNode.FindNode('baud');
      if Assigned(nTmp) then
           FBaud := nTmp.ValueAsInteger
      else FBaud := 9600;

      nTmp := nNode.FindNode('MaxBytes');
      if Assigned(nTmp) then
           FMaxBytes := nTmp.ValueAsInteger
      else FMaxBytes := 9600;

      nTmp := nNode.FindNode('IfOpen');
      if Assigned(nTmp) then
           FIfOpen := nTmp.ValueAsInteger
      else FIfOpen := 1;

      nTmp := nNode.FindNode('IMGEnable');
      if Assigned(nTmp) then
           FImgEnable := nTmp.ValueAsString = 'Y'
      else FImgEnable := False;

      New(nReader);
      FReaders.Add(nReader);
      nReader^ := nItem;
    end;
  finally
    nXML.Free;
  end;
end;

initialization
  gSDTReaderManager := TSDTReaderManager.Create;
finalization
  FreeAndNil(gSDTReaderManager);
end.


