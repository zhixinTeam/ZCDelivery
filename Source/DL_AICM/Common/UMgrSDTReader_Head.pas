unit UMgrSDTReader_Head;

interface

uses
  SysUtils, Windows, Classes, Forms;

const
  DLL_SDTAPI = 'sdtapi.dll';
  DLL_WLTRS = 'WltRS.dll';

  cReader_OperateOK  = 144;
  cReader_FindCardOK = 159;

  cTry_Times          = 2;      //询卡次数


type
  TIdCardInfoWChar = packed record
    Name: array[0..14] of WideChar;
    Sex : array[0..0] of WideChar;
    Nation: array[0..1] of WideChar;
    BirthDay:array[0..7] of WideChar;
    Addr : array[0..34] of WideChar;
    IdSN : array[0..17] of WideChar;
    IssueOrgan: array[0..14] of WideChar;
    VaildBegin: array[0..7] of WideChar;
    VaildEnd : array[0..7] of WideChar;
    theNewestAddr: array[0..34] of WideChar;
  end;

//查看串口当前波特率
function SDT_GetCOMBaud(iPort: integer; puiBaudRate: Pinteger): integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口，puiBaudRate[out]无符号指针，指向普通串口当前波特率，返回值
0X90-成功，0x1-端口打开失败/端口号不合法，0x5无法获得SAM_V的波特率，串口不可用。}


function SDT_StetCOMBaud(iPort: integer; uiCurrBaud: integer; uiSetBaud: integer): integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口, uiCurrBaud[in]调用改API前已设置的业务终端与SAM_V通信的波特率(出厂默认为115200)
uiCurrBaud只能为115200,57600,378400,19200,9600。如果uiCurrBaud数值不是这些值之一，函数返回0x21，如果和已设置的不一样，
函数返回0x02表示不能设置调用API不成功。uiSetBaud[in]将要设置的SAM_V波特率,只能为(同上)那些值，如果不是这些数值，返回也同上
函数返回0x90-成功，0x1-端口打开失败/端口号不合法，0x2-超时，设置不成功，0x21-uiCurrBaud、uiSetBaud输入参数数值错误}
//设置SAM_V的串口的波特率

function SDT_OpenPort(iPort: integer): integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，1-16(十进制)为串口，1001-1016(十进制)为USB口，缺省的一个USB设备端口是1001。
函数返回0x90-打开端口成功,1-打开端口失败/端口号不合法}
//打开串口/USB

function SDT_ClosePort(iPort: integer): integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，返回值0x90-关闭串口成功，0x01-端口号不合法}
//关闭串口/USB

function SDT_ResetSAM(iPort: integer; ilfOpen: integer): integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，目前串口和USB只支持16个，串口：0001-0016，USB：1001-1016。
ilfOpen[in]表示不在该函数内部打开和关闭串口，非0表示在API函数内部包含了打开串口和关闭串口函数，之前不需要调用
SDT_OpenPort和SDT_ClosePort
返回值0x90-成功，其他 失败}
//对SAM_V复位

//设置射频适配器最大通信字节数
function SDT_SetMaxRFByte(iPort: integer;ucByte: Char;blfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，ucByte[in]无符号字符,24-255，表示射频适配器最大通信字节数，ilfOpen[in]参见SDT_ResetSAM
返回值0x90-成功,其他-失败}

//对SAM_V进行状态检测
function SDT_GetSAMStatus(iPort: integer;ilfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，ilfOpen参见SDT_ResetSAM
返回值0x90-SAM_V正常，0x60-自检失败，不能接收命令，其他-命令失败}

//读取SAM_V的编号
function SDT_GetSAMID(iPort: integer;pusSAMID: Pbyte;ilfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，pusSAMID[out]无符号字符串指针SAM_V编号，16字节，
返回值0x90-成功，其他-失败}


//读取SAM_V的编号
function SDT_GetSAMIDToStr(iPort: integer;pusSAMID: Pbyte;ilfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iport[in]表示端口号，pusSAMID[out]SAM_V编号,ilfOpen[in]整数，参见SDT_ResetSAM
返回值0x90-成功，其他-失败}

//开始找卡
function SDT_StartFindIDCard(iPort: integer; var pucManaInfo: Integer; ilfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iport[in]表示端口号，pucManaInfo[out]无符号指针，证/卡芯片管理号，4个字节，ilfOpen[in]参见SDT_ResetSAM
返回值0x9f-找卡成功，0x80-找卡失败}

//选卡
function SDT_SelectIDCard(iPort: integer; var pucManaMsg: integer;ilfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，pucManaMsg[out]无符号指针，证/卡芯片序列号，8个字节，ilfOpen[in]参见SDT_ResetSAM
返回值0x90-选卡成功，0x81-选卡失败}


//读取卡体管理号
function SDT_ReadMngInfo(iPort: integer;pucManageMsg: Pbyte;ilfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，pucManageMsg[out]无符号字符指针，卡体管理号，28字节，ilfOpen[in]
返回值0x90-成功，其他-读失败}


//读取证/卡固定信息
function SDT_ReadBaseMsg(iPort: integer;pucCHMsg: Pbyte; var puiCHMsgLen: Integer;pucPHMsg: Pbyte; var puiPHMsgLen: Integer;ilfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，pucCHMsg[out]指向读到的文字信息，puiCHMsgLen[out]指向读到的文字信息长度
pucPHMsg[out]指向读到的照片信息，puiPHMsgLen[out]指向读到的照片信息长度，ilfOpen[in]参见SDT_ResetSAM
返回值0x90-读固定信息成功，其他读固定信息失败}


//读取追加信息
function SDT_ReadNewAppMsg(iPort: integer;pucAppMsg: Pbyte;puiAppMsgLen: Pinteger;ilfOpen: integer):integer;stdcall;External DLL_SDTAPI;
{iPort[in]表示端口号，pucAppMsg[out]指向读到的追加信息，puiAppMsgLen[out]指向读到的追加信息长度，ilfOpen[in]参见SDT_ResetSAM
返回值0x90-读取追加信息成功，其他-读取追加信息失败}

//将读到的身份证信息保存到文件
function SDT_ReadBaseMsgToFile(iPortID: Integer; fileName1: PAnsiChar; var puiCHMsgLen: Integer; fileName2: PAnsiChar; var puiPHMsgLen: Integer; iIfOpen: Integer): Integer; stdcall; external DLL_SDTAPI name 'SDT_ReadBaseMsgToFile';

//照片解码函数
function GetBmp(Wlt_File: PChar;intf: integer):integer;stdcall;External DLL_WLTRS;
{Wlt_File-wlt文件名，intf阅读设备通讯接口类型(1-RS-232C,2-USB)
返回值：生成*.bmp和以下返回信息:1-相片解码正确，0-调用sdtapi.dll错误,-1-相片解码错误，-2-wlt文件后缀错误，
-3-wlt文件打开错误，-4-wlt文件格式错误，-5-软件未授权，-6-设备连接错误}

function EthnicNoToName(ANo: string): string;
function GetBmp_ByFile(nFile: string; nFlag: Integer=2): Integer;
function ReadICCard(var ACardInfo: TIdCardInfoWChar; var AErrMsg: string): Boolean;

resourcestring
  //生成文件
  TIP_FILE_TXT = 'wz.txt';
  TIP_FILE_BMP = 'wz.bmp';
  TIP_FILE_WLT = 'wz.wlt';

  //提示信息
  TIP_OK    = '解码成功';
  TIP_TITLE = '提示';
  TIP_ICREADER_RESET_FAILED = '设备复位失败！';
  TIP_ICREADER_NO_CARD = '未放卡或者卡未放好，请重新放卡！';
  TIP_ICREADER_READ_FAILED = '读卡失败！';
  TIP_ICREADER_CALL_DLL_FAILED = '调用sdtapi.dll错误！';
  TIP_ICREADER_CALL_WLTDLL_FAILED = '调用WltRS.dll错误！';
  TIP_ICREADER_CALL_GetBmp_FAILED = '获取函数GetBmp错误！';
  TIP_ICREADER_PICTURE_DECODE_FAILED = '相片解码错误！';
  TIP_ICREADER_WLT_FILE_EXTEND_FAILED = 'wlt文件后缀错误！';
  TIP_ICREADER_WLT_FILE_OPEN_FAILED = 'wlt文件打开错误！';
  TIP_ICREADER_WLT_FILE_FORMAT_FAILED = 'wlt文件格式错误！';
  TIP_ICREADER_NO_LICENSE = '软件未授权！';
  TIP_ICREADER_DEVICE_FAILED = '设备连接错误！';
  TIP_PRINT_NO_CARD_FOUND = '未找到身份证相关信息，请将证件放在天线上后重试！';
  TIP_ICREADER_SAVE_SUCCESS = '保存成功，身份信息已自动录入本地数据库！';
  TIP_ICREADER_BLACK_CARD_FOUND = '发现黑名单内包括的人员！';
  ERROR_ICREADER_OPEN_PORT = '端口打开失败，请检测相应的端口或者重新连接读卡器！';

var
  LstEthnic: TStrings;

implementation

function GetBmp_ByFile(nFile: string; nFlag: Integer=2): Integer;
var nHandle: Cardinal;
    nFunc:function(Wlt_File: PChar;intf: integer):integer;
begin
  nHandle := LoadLibrary(DLL_WLTRS);
  try
    if nHandle <> 0 then
    begin
      @nFunc:=GetProcAddress(nHandle, 'GetBmp');
      if Assigned(@nFunc) then
           Result := nFunc(PChar(nFile), nFlag)
      else Result := -8;
    end else Result := -7;
  finally
    FreeLibrary(nHandle);
  end;
end;

function EthnicNoToName(ANo: string): string;
begin
  Result:= LstEthnic.Values[ANo];
end;

function FormatDateStr(AValue: string): string;
begin
  Result:= Copy(AValue, 1, 4) + '-' +
  Copy(AValue, 5, 2) + '-' +
  Copy(AValue, 7, 2);
end;

function ReadICCard(var ACardInfo: TIdCardInfoWChar; var AErrMsg: string): Boolean;
var
  iPort: Integer;
  intOpenPortRtn: Integer;
  bUsbPort: Boolean;
  EdziPortID: Integer;
  iRet: Integer;
  pucIIN: Integer;
  EdziIfOpen: Integer;
  pucSN: Integer;
  puiCHMsgLen: Integer;
  puiPHMsgLen: Integer;
  fs: TFileStream;
begin
  AErrMsg:= '';
  //Result:= False;
  bUsbPort:= False;
  EdziIfOpen:= 1;
  EdziPortID:= 0;
  puiCHMsgLen:= 0;
  puiPHMsgLen:= 0;
  //检测usb口的机具连接，必须先检测usb
  for iPort := 1001 to 1016 do
  begin
    intOpenPortRtn:= SDT_OpenPort(iPort);
    if intOpenPortRtn = 144 then
    begin
      EdziPortID:= iPort;
      bUsbPort:= true;
      break;
    end;
  end;

  //检测串口的机具连接
  if not bUsbPort then
  begin
    for iPort := 1 to 2 do
    begin
      intOpenPortRtn:= SDT_OpenPort(iPort);
      if intOpenPortRtn = 144 then
      begin
        EdziPortID:= iPort;
        bUsbPort:= False;
        Break;
      end;
    end;
  end;

  if intOpenPortRtn <> 144 then
  begin
    AErrMsg:= ERROR_ICREADER_OPEN_PORT;
    Result:= False;
    Exit;
  end;
  //下面找卡
  iRet:= SDT_StartFindIDCard(EdziPortID, pucIIN, EdziIfOpen);
  if iRet <> 159 then
  begin
    iRet:= SDT_StartFindIDCard(EdziPortID, pucIIN, EdziIfOpen);//再找卡
    if iRet <> 159 then
    begin
      SDT_ClosePort(EdziPortID);
      AErrMsg:= TIP_ICREADER_NO_CARD;
      Result:= False;
      Exit;
    end;
  end;
  //选卡
  iRet:= SDT_SelectIDCard(EdziPortID, pucSN, EdziIfOpen);
  if iRet <> 144 then
  begin
    iRet:= SDT_SelectIDCard(EdziPortID, pucSN, EdziIfOpen);
    if iRet <> 144 then
    begin
      SDT_ClosePort(EdziPortID);
      AErrMsg:= TIP_ICREADER_READ_FAILED;
      Result:= False;
      Exit;
    end;
  end;

  //注意，在这里，用户必须有应用程序当前目录的读写权限
  if FileExists('wz.txt') then SysUtils.DeleteFile('wz.txt');
  if FileExists('zp.bmp') then SysUtils.DeleteFile('zp.bmp');
  if FileExists('zp.wlt') then SysUtils.DeleteFile('zp.wlt');

  iRet:= SDT_ReadBaseMsgToFile(EdziPortID, PAnsiChar(AnsiString('wz.txt')), puiCHMsgLen, PAnsiChar(AnsiString('zp.wlt')), puiPHMsgLen, 1);
  if iRet <> 144 then
  begin
    SDT_ClosePort(EdziPortID);
    AErrMsg:= TIP_ICREADER_READ_FAILED;
    Result:= False;
    Exit;
  end;

  SDT_ClosePort(EdziPortID);
  //关闭

  //下面解析照片，注意，如果在C盘根目录下没有机具厂商的授权文件Termb.Lic，照片解析将会失败
  if bUsbPort then
    iRet:= GetBmp_ByFile(PAnsiChar(AnsiString('zp.wlt')), 2)
  else
    iRet:= GetBmp_ByFile(PAnsiChar(AnsiString('zp.wlt')), 1);

  case iRet of
    0:
    begin
    //Application.MessageBox(TIP_ICREADER_CALL_DLL_FAILED);
    end;
    1: //正常
    begin
    end;
    -1:
    begin
    //Application.MessageBox(TIP_ICREADER_PICTURE_DECODE_FAILED);
    end;
    -2:
    begin
    //Application.MessageBox(TIP_ICREADER_WLT_FILE_EXTEND_FAILED);
    end;
    -3:
    begin
    //Application.ShowMessage(TIP_ICREADER_WLT_FILE_OPEN_FAILED);
    end;
    -4:
    begin
    //Application.MessageBox(TIP_ICREADER_WLT_FILE_FORMAT_FAILED);
    end;
    -5:
    begin
    //Application.MessageBox(TIP_ICREADER_NO_LICENSE);
    end;
    -6:
    begin
    //Application.MessageBox(TIP_ICREADER_DEVICE_FAILED);
    end;
  end;

  fs:= TFileStream.Create('wz.txt', fmOpenRead);
  fs.Position:= 0;
  fs.Read(ACardInfo ,SizeOf(ACardInfo));
  fs.Free;
  //
  // 姓名 ：AnsiString(idCardInfo.Name);
  // 性别 ： if AnsiString(idCardInfo.Sex)= '1' then 性别:= '男' else 性别:= '女';
  // 民族 ： EthnicNoToName(AnsiString(idCardInfo.Nation));
  // 出生年月日： FormatDateStr(AnsiString(idCardInfo.BirthDay));
  // 住址： Address:= Trim(AnsiString(idCardInfo.Addr));
  //身份证号码： Id:= Trim(AnsiString(idCardInfo.IdSN));
  //发证机构： Place:= Trim(AnsiString(idCardInfo.IssueOrgan));
  //有效日期开始 ValidDateStart:= FormatDateStr(AnsiString(idCardInfo.VaildBegin));
  //有效日期结束 if Trim(AnsiString(idCardInfo.VaildEnd)) = '长期' then
  // ValidDateEnd:= FormatDateTime('yyyy-MM-dd', MaxDateTime)
  // else
  // ValidDateEnd:= FormatDateStr(AnsiString(idCardInfo.VaildEnd));
  //
  Result:= True;
end;

initialization
  LstEthnic:= TStringList.Create;
  with LstEthnic do
  begin
    Add('01' + '=' + '汉族');
    Add('02' + '=' + '蒙古族');
    Add('03' + '=' + '回族');
    Add('04' + '=' + '藏族');
    Add('05' + '=' + '维吾尔族');
    Add('06' + '=' + '苗族');
    Add('07' + '=' + '彝族');
    Add('08' + '=' + '壮族');
    Add('09' + '=' + '布依族');
    Add('10' + '=' + '朝鲜族');
    Add('11' + '=' + '满族');
    Add('12' + '=' + '侗族');
    Add('13' + '=' + '瑶族');
    Add('14' + '=' + '白族');
    Add('15' + '=' + '土家族');
    Add('16' + '=' + '哈尼族');
    Add('17' + '=' + '哈萨克族');
    Add('18' + '=' + '傣族');
    Add('19' + '=' + '黎族');
    Add('20' + '=' + '傈僳族');
    Add('21' + '=' + '佤族');
    Add('22' + '=' + '畲族');
    Add('23' + '=' + '高山族');
    Add('24' + '=' + '拉祜族');
    Add('25' + '=' + '水族');
    Add('26' + '=' + '东乡族');
    Add('27' + '=' + '纳西族');
    Add('28' + '=' + '景颇族');
    Add('29' + '=' + '柯尔克孜族');
    Add('30' + '=' + '土族');
    Add('31' + '=' + '达翰尔族');
    Add('32' + '=' + '仫佬族');
    Add('33' + '=' + '羌族');
    Add('34' + '=' + '布朗族');
    Add('35' + '=' + '撒拉族');
    Add('36' + '=' + '毛南族');
    Add('37' + '=' + '仡佬族');
    Add('38' + '=' + '锡伯族');
    Add('39' + '=' + '阿昌族');
    Add('40' + '=' + '普米族');
    Add('41' + '=' + '塔吉克族');
    Add('42' + '=' + '怒族');
    Add('43' + '=' + '乌孜别克族');
    Add('44' + '=' + '俄罗斯族');
    Add('45' + '=' + '鄂温克族');
    Add('46' + '=' + '德昂族');
    Add('47' + '=' + '保安族');
    Add('48' + '=' + '裕固族');
    Add('49' + '=' + '京族');
    Add('50' + '=' + '塔塔尔族');
    Add('51' + '=' + '独龙族');
    Add('52' + '=' + '鄂伦春族');
    Add('53' + '=' + '赫哲族');
    Add('54' + '=' + '门巴族');
    Add('55' + '=' + '珞巴族');
    Add('56' + '=' + '基诺族');
    Add('57' + '=' + '其它');
    Add('98' + '=' + '外国人入籍');
  end;
finalization
  LstEthnic.Free;
end.
//事先请准备好sdtapi.dll WltRS.dll WltRS.lic 这三个文件,放在同目录下
