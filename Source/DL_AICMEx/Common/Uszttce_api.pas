{*******************************************************************************
  作者: 289525016@163.com 2016-10-24
  描述: 深圳市天腾实业有限公司三合一读卡器（TTCE发卡器） 型号KCDF-360
*******************************************************************************}
unit Uszttce_api;

interface
uses
  Classes,ExtCtrls;
const
  C_MacAddr:char=chr($0F);//读卡器默认地址

  C_CMD_Position_CardPort:string='FC0';//发卡到卡口
  C_CMD_Position_ReadCard:string='FC7';//发卡到读卡位置
  C_CMD_RecycleCard:string='CP'; //回收卡片

  C_MachineStatus_CardBoxEmpty:string='0018'; //无卡，发卡箱空
  C_MachineStatus_Ready1:string='0004'; //就绪：卡在传感器3位置
  C_MachineStatus_Ready2:string='0014'; //就绪：卡在传感器3位置
  C_MachineStatus_OverlapedCard:string='0040'; //重叠卡
  C_MaahineStatus_CloggedCard:string='0020'; //堵塞卡
  C_MaahineStatus_RecycleBoxFull1:string='0133'; //回收箱满
  C_MaahineStatus_RecycleBoxFull2:string='0132'; //回收箱满
  C_MaahineStatus_ReadyForRead1:string='0003'; //读卡就绪：卡在传感器1-2位置
  C_MaahineStatus_ReadyForRead2:string='0013'; //读卡就绪：卡在传感器1-2位置
  C_MaahineStatus_Status_Error1:string='0016'; //读卡就绪：卡在传感器1-2位置

  C_EMPTY_CARD_NO:string='000000000000';
type
  //设备状态
  TMachineStatus = record
    msCode:string;
    msDesc:string;
  end;

  TSzttceApi = class(TObject)
  private
    FFileName_K720:string;
    FFileName_Config:string;
    FLibModule:Integer;
    FComHandle:THandle;
    FPort:string;
    FRecordInfo:array[0..255] of Char;
    FStateInfo:array[0..3] of Char;
    FMachineStatus:TMachineStatus;
    FParentWnd:THandle;
    //动态库版本信息
    //K720_GetSysVersion:function (ComHandle:THandle; strVersion:PChar):Integer;stdcall;
    //寻卡
    //K720_S50DetectCard:function(ComHandle:THandle;MacAddr:Char;RecordInfo:PChar):Integer;stdcall;
    //一般查询，D1801状态信息，返回3字节的状态信息
    //K720_Query:function(ComHandle:THandle;MacAddr:Char;StateInfo:PByte;RecordInfo:PChar):Integer;stdcall;
    //打开串口，默认的波特率"9600, n, 8, 1"
    K720_CommOpen:function (Port:PChar):THandle;stdcall;
    //关闭当前打开的串口
    K720_CommClose:function (ComHandle:THandle):Integer;stdcall;
    //发送D1801的操作命令
    K720_SendCmd:function (ComHandle:THandle; MacAddr:Char; p_Cmd:PChar; CmdLen:Integer; RecordInfo:PChar):Integer;stdcall;

    //读取序列号
    K720_S50GetCardID:function(ComHandle:THandle;MacAddr:Char;CardID:PByte;RecordInfo:PChar):Integer;stdcall;

    //高级查询，D1801状态信息，返回4字节的状态信息
    K720_SensorQuery :function(ComHandle:THandle;MacAddr:Char;StateInfo:PByte;RecordInfo:PChar):Integer;stdcall;

    //解析卡片序列号
    function ParseCardNO(var nCardid: array of Byte):string;
    //打开串口
    function OpenComPort:Boolean;

    function ParseStateInfo:Boolean;
//    procedure WriteLog(const nMsg:string);

    function InitApiInterface:Boolean;
    //回收卡片
    function RecycleCard:Boolean;
    //等待设备空闲
    procedure WaitforIdle;
    function GetComPort:string;
  public
    ErrorCode:Integer;
    ErrorMsg:string;
    constructor Create;
    destructor Destroy; override;
    //发卡，返回卡号
    function IssueOneCard(var nCardno:string):Boolean;
    //插卡后读卡，读完再退卡
    function ReadCardSerialNo(var nCardSerialNo:string):Boolean;
    
    //获取机器当前状态
    function GetCurrentStatus(var nMachineStatus:TMachineStatus):Boolean;
    //是否插卡
    function IsInsertedCard:Boolean;

    function ResetMachine:Boolean;

    property ParentWnd:THandle read FParentWnd write FParentWnd;
  end;

implementation
uses
  SysUtils,Windows,IniFiles;
{ TSzttceApi }

constructor TSzttceApi.Create;
var
  nPath,nPort:string;
begin
  nPath := ExtractFilePath(ParamStr(0));
  FFileName_K720 := nPath+'K720_Dll.dll';
  FFileName_Config := nPath+'com.ini';
  FComHandle := 0;
  nPort := GetComPort;
  if nPort='' then Exit;
  FPort := nPort;
  InitApiInterface;
  FParentWnd := 0;
  ErrorCode := 0;
  ErrorMsg := '';
end;

destructor TSzttceApi.Destroy;
begin
  if FComHandle<>0 then
  begin
    K720_CommClose(FComHandle);
  end;
  if FLibModule>32 then
  begin
    FreeLibrary(FLibModule);
  end;
  inherited;
end;

function TSzttceApi.GetComPort: string;
var
  nini:TIniFile;
begin
  Result := '';
  if not FileExists(FFileName_Config) then
  begin
    ErrorCode := 990;
    ErrorMsg := 'com口配置文件['+FFileName_Config+']不存在';
    Exit;
  end;
  nini := TIniFile.Create(FFileName_Config);
  try
    Result := nini.ReadString('com','port','');
  finally
    nini.Free;
  end;
end;

function TSzttceApi.GetCurrentStatus(var nMachineStatus:TMachineStatus):Boolean ;
var
  nRet:Integer;
begin
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  ZeroMemory(@FStateInfo,SizeOf(FStateInfo));
  if not OpenComPort then Exit;
  nRet := K720_SensorQuery(FComHandle,C_MacAddr,@FStateInfo,@FRecordInfo);
  if nRet<>0 then
  begin
    ErrorCode := 1000;
    ErrorMsg := '查询状态失败';
    Exit;
  end;
  Result := ParseStateInfo;
  nMachineStatus := FMachineStatus;
end;

function TSzttceApi.InitApiInterface: Boolean;
begin
  Result := False;
  if not FileExists(FFileName_K720) then
  begin
    ErrorCode := 1010;
    ErrorMsg := '动态库文件[ '+FFileName_K720+' ]不存在！';
    Exit;
  end;

  FLibModule := Loadlibrary(PChar(FFileName_K720));
  if (FLibModule<=32) then
  begin
    ErrorCode := 1020;
    ErrorMsg := '加载驱动程序文件[ '+FFileName_K720+' ]失败！';
    Exit;
  end;

  //K720_GetSysVersion := GetProcAddress(FLibModule,'K720_GetSysVersion');
  K720_CommOpen := GetProcAddress(FLibModule,'K720_CommOpen');
  K720_CommClose := GetProcAddress(FLibModule,'K720_CommClose');
  K720_SendCmd := GetProcAddress(FLibModule,'K720_SendCmd');
  //K720_S50DetectCard := GetProcAddress(FLibModule,'K720_S50DetectCard');
  K720_S50GetCardID := GetProcAddress(FLibModule,'K720_S50GetCardID');
  //K720_Query := GetProcAddress(FLibModule,'K720_Query');
  K720_SensorQuery := GetProcAddress(FLibModule,'K720_SensorQuery');
  Result := True;
end;

function TSzttceApi.IsInsertedCard: Boolean;
begin
  Result := False;
  if not OpenComPort then Exit;
  GetCurrentStatus(FMachineStatus);
  Result := (FMachineStatus.msCode=C_MaahineStatus_ReadyForRead1) or (FMachineStatus.msCode=C_MaahineStatus_ReadyForRead2);
end;

function TSzttceApi.IssueOneCard(var nCardno: string): Boolean;
var
  nRet:Integer;
  nCardID:array[0..3] of Byte;
begin
  nCardno := '';
  Result := False;
  if not OpenComPort then Exit;
  GetCurrentStatus(FMachineStatus);
  if (FMachineStatus.msCode=c_MachineStatus_CardBoxEmpty)
    or (FMachineStatus.msCode=C_MachineStatus_OverlapedCard)
    or (FMachineStatus.msCode=C_MaahineStatus_RecycleBoxFull1)
    or (FMachineStatus.msCode=C_MaahineStatus_RecycleBoxFull2) then
  begin
    ErrorCode := StrToInt(FMachineStatus.msCode);
    ErrorMsg := FMachineStatus.msDesc;
    if FParentWnd<>0 then
    begin
      MessageBeep($FFFFFFFF);
      MessageBox(FParentWnd,PChar(ErrorMsg),'Error',0);
    end;
    Exit;
  end;

  //复位
  if not ResetMachine then Exit;
//发卡到读卡位置
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  nRet := K720_SendCmd(FComHandle, C_MacAddr, PChar(C_CMD_Position_ReadCard), Length(C_CMD_Position_ReadCard),@FRecordInfo);
  if 0<>nRet then
  begin
    ErrorCode := 1040;
    ErrorMsg := '到达读卡位置失败';
    Exit;
  end;
  Sleep(200);

  //读取卡号
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  ZeroMemory(@nCardID,SizeOf(nCardID));
  nRet := K720_S50GetCardID(FComHandle,C_MacAddr,@nCardID,@FRecordInfo);
  if nRet=-107 then
  begin
    ResetMachine;
    ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
    nRet := K720_S50GetCardID(FComHandle,C_MacAddr,@nCardID,@FRecordInfo);
  end;
  if 0<>nRet then
  begin
    ErrorCode := 1050;
    ErrorMsg := '读取卡序号失败，请联系网络管理员处理';
  end;

  nCardno := ParseCardNO(nCardID);

  //读取卡号失败，说明卡片已失效，开始回收
  while nCardno=C_EMPTY_CARD_NO do
  begin
    ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
//    Sleep(1000);
    if not RecycleCard then
    begin
      ErrorCode := 1060;
      ErrorMsg := '回收卡片失败';
      Exit;
    end;
    GetCurrentStatus(FMachineStatus);
    if (FMachineStatus.msCode=c_MachineStatus_CardBoxEmpty)
      or (FMachineStatus.msCode=C_MachineStatus_OverlapedCard)
      or (FMachineStatus.msCode=C_MaahineStatus_RecycleBoxFull1)
      or (FMachineStatus.msCode=C_MaahineStatus_RecycleBoxFull2) then
    begin
      ErrorCode := StrToInt(FMachineStatus.msCode);
      ErrorMsg := FMachineStatus.msDesc;
      if FParentWnd<>0 then
      begin
        MessageBeep($FFFFFFFF);
        MessageBox(FParentWnd,PChar(ErrorMsg),'Error',0);
      end;
      Result := False;
      Exit;
    end;
    //重新发卡
    if IssueOneCard(nCardno) then
    begin
      Result := True;
      Exit;
    end;
  end;

  //移动到卡口位置
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  nRet := K720_SendCmd(FComHandle, C_MacAddr, PChar(C_CMD_Position_CardPort),Length(C_CMD_Position_CardPort),@FRecordInfo);
  if 0<>nRet then
  begin
    ErrorCode := 1070;
    ErrorMsg := '移动到卡口位置失败';
    Exit;
  end;
  //复位
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  nRet := K720_SendCmd(FComHandle, C_MacAddr, 'RS', 2,@FRecordInfo);
  WaitforIdle;
  Result := True;
end;

function TSzttceApi.OpenComPort: Boolean;
begin
  Result := False;
  if FComHandle>0 then
  begin
    Result := True;
    Exit;
  end;
  FComHandle := K720_CommOpen(PChar(FPort));
  if FComHandle=0 then
  begin
    ErrorCode := 1080;
    ErrorMsg := '打开串口['+FPort+']失败';
    Exit;
  end;
  Result := True;
end;

function TSzttceApi.ParseCardNO(var nCardid: array of Byte): string;
var
  nIdx:Integer;
  nInt: Int64;
begin
  Result := '';
  for nIdx := High(nCardid) downto Low(nCardid) do
  begin
    Result := Result+IntToHex(nCardid[nIdx],2);
  end;
  nInt := StrToInt64('$' + Result);
  Result := IntToStr(nInt);
  Result := StringOfChar('0', 12 - Length(Result)) + Result;
end;

function TSzttceApi.ParseStateInfo: Boolean;
var
  nStr:string;
begin
  Result := True;
  nStr := Copy(StrPas(@FStateInfo),1,4);
  FMachineStatus.msCode := nStr;
  if nStr = '8000' then
  begin
    FMachineStatus.msDesc := '回收箱满';
    Exit;
  end;
  if nStr='4000' then
  begin
    FMachineStatus.msDesc := '准备卡失败';
    Exit;
  end;
  if nStr='2000' then
  begin
    FMachineStatus.msDesc := '正在准备卡';
    Exit;
  end;
  if nStr='1000' then
  begin
    FMachineStatus.msDesc := '正在发卡';
    Exit;
  end;
  if nStr='0800' then
  begin
    FMachineStatus.msDesc := '正在收卡';
    Exit;
  end;
  if nStr='0400' then
  begin
    FMachineStatus.msDesc := '发卡出错';
    Exit;
  end;
  if nStr='0232' then
  begin
    FMachineStatus.msDesc := '发卡出错';
    Exit;
  end;
  if nStr='0133' then
  begin
    FMachineStatus.msDesc := '收卡出错,请检查回收箱是否已满';
    Exit;
  end;
  if nStr='0132' then
  begin
    FMachineStatus.msDesc := '收卡出错,请检查回收箱是否已满';
    Exit;
  end;
  if nStr='0100' then
  begin
    FMachineStatus.msDesc := '未知状态';
    Exit;
  end;
  if nStr='0080' then
  begin
    FMachineStatus.msDesc := '未知状态';
    Exit;
  end;
  if nStr='0040' then
  begin
    FMachineStatus.msDesc := '重叠卡';
    Exit;
  end;
  if nStr='0020' then
  begin
    FMachineStatus.msDesc := '堵塞卡';
    Exit;
  end;
  if nStr='0018' then
  begin
    FMachineStatus.msDesc := '卡箱已空';
    Exit;
  end;
  if nStr='0016' then
  begin
    FMachineStatus.msDesc := '卡在传感器2-3位置';
    Exit;
  end;
  if nStr='0014' then
  begin
    FMachineStatus.msDesc := '卡在传感器3位置';
    Exit;
  end;
  if nStr='0013' then
  begin
    FMachineStatus.msDesc := '卡在传感器1-2位置';
    Exit;
  end;
  if nStr='0010' then
  begin
    FMachineStatus.msDesc := '卡箱已空';
    Exit;
  end;
  if nStr='0008' then
  begin
    FMachineStatus.msDesc := '卡箱已空';
    Exit;
  end;
  if nStr='0004' then
  begin
    FMachineStatus.msDesc := '卡在传感器3位置';
    Exit;
  end;
  if nStr='0003' then
  begin
    FMachineStatus.msDesc := '卡在传感器1-2位置';
    Exit;
  end;
  if nStr='0002' then
  begin
    FMachineStatus.msDesc := '卡在传感器2位置';
    Exit;
  end;
  if nStr='0001' then
  begin
    FMachineStatus.msDesc := '卡在传感器1位置';
    Exit;
  end;
  Result := False;
  FMachineStatus.msCode := '9999';
  FMachineStatus.msDesc := '未知状态';
end;

function TSzttceApi.ReadCardSerialNo(var nCardSerialNo: string): Boolean;
var
  nRet:Integer;
  nCardID:array[0..3] of Byte;
begin
  nCardSerialNo := '';
  Result := False;
  if not OpenComPort then Exit;
  GetCurrentStatus(FMachineStatus);
  if (FMachineStatus.msCode=c_MachineStatus_CardBoxEmpty) then
  begin
    ErrorCode := 1108;
    ErrorMsg := '未插卡';
    Exit;
  end;
  if (FMachineStatus.msCode<>C_MaahineStatus_ReadyForRead1) and (FMachineStatus.msCode<>C_MaahineStatus_ReadyForRead2) then
  begin
    ErrorCode := 1109;
    ErrorMsg := '设备读卡状态未就绪';
    Exit;
  end;
  //读取卡号
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  ZeroMemory(@nCardID,SizeOf(nCardID));
  nRet := K720_S50GetCardID(FComHandle,C_MacAddr,@nCardID,@FRecordInfo);
  if nRet=-107 then
  begin
    ResetMachine;
    ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
    nRet := K720_S50GetCardID(FComHandle,C_MacAddr,@nCardID,@FRecordInfo);
  end;
  if 0<>nRet then
  begin
    ErrorCode := 1110;
    ErrorMsg := '读取卡序列号失败';
    ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  end;
  nCardSerialNo := ParseCardNO(nCardID);

  //读取卡号完毕，开始退卡
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  nRet := K720_SendCmd(FComHandle, C_MacAddr, PChar(C_CMD_Position_CardPort),Length(C_CMD_Position_CardPort),@FRecordInfo);
  if 0<>nRet then
  begin
    ErrorCode := 1140;
    ErrorMsg := '到达卡口位置失败';
    Exit;
  end;
  Sleep(500);
  //后一张卡在传感器2-3的位置，需要回收
  GetCurrentStatus(FMachineStatus);
  if (FMachineStatus.msCode=C_MaahineStatus_Status_Error1) then
  begin
    if not RecycleCard then
    begin
      ErrorCode := 1139;
      ErrorMsg := '回收卡片失败';
      Exit;
    end;
  end;
//  FTimerStatus.Enabled := True;
  Result := True;
end;

function TSzttceApi.RecycleCard: Boolean;
var
  nRet :Integer;
begin
  Result := False;
  if not OpenComPort then Exit;
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  nRet := K720_SendCmd(FComHandle, C_MacAddr, PChar(C_CMD_RecycleCard),Length(C_CMD_RecycleCard),@FRecordInfo);
  if nRet<>0 then
  begin
    ErrorCode := 1150;
    ErrorMsg := '回收卡片失败';
    Exit;
  end;
  Result := True;
end;

//procedure TSzttceApi.WriteLog(const nMsg: string);
//var
//  nfilename:string;
//  nstrs:TStringList;
//begin
//  nfilename := ExtractFilePath(ParamStr(0))+'SzttceApi.log';
//  nstrs := TStringList.Create;
//  try
//    if FileExists(nfilename) then
//    begin
//      nstrs.LoadFromFile(nfilename);
//    end;
//    nstrs.Add(nMsg);
//    nstrs.SaveToFile(nfilename);
//  finally
//    nstrs.Free;
//  end;
//end;

function TSzttceApi.ResetMachine:Boolean;
var
  nRet :integer;
begin
  Result := False;
  //复位
  ZeroMemory(@FRecordInfo,SizeOf(FRecordInfo));
  nRet := K720_SendCmd(FComHandle, C_MacAddr, 'RS', 2,@FRecordInfo);
  if 0<>nRet then
  begin
    ErrorCode := 1030;
    ErrorMsg := '读卡器复位失败';
    Exit;
  end;
  Result := True;
end;

procedure TSzttceApi.WaitforIdle;
begin
  while True do
  begin
    GetCurrentStatus(FMachineStatus);
    if (FMachineStatus.msCode=c_MachineStatus_Ready1) or (FMachineStatus.msCode=c_MachineStatus_Ready2) or (FMachineStatus.msCode=c_MachineStatus_CardBoxEmpty) then Break;
    Sleep(10);
  end;
end;

end.
