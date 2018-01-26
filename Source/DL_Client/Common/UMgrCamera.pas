{*******************************************************************************
  作者: fendou116688@163.com 2014/12/31
  描述: 硬盘摄像机管理单元
*******************************************************************************}
unit UMgrCamera;

interface

uses
  Windows, SysUtils, Classes, Graphics, jpeg, StrUtils, SyncObjs, USysLoger;

const
  SERIALNO_LEN=48;
type
  TDeviceType = (dtHK, dtDH);

  {设备信息}
  PNET_DVR_DEVICEINFO = ^TNET_DVR_DEVICEINFO;
  {$EXTERNALSYM NET_DVR_DEVICEINFO}
  NET_DVR_DEVICEINFO = Record
    sSerialNumber: Array[0..SERIALNO_LEN - 1] of Char ;  //序列号
    byAlarmInPortNum: BYTE ;	 //DVR报警输入个数
    byAlarmOutPortNum: BYTE ;	 //DVR报警输出个数
    byDiskNum: BYTE;	         //DVR 硬盘个数
    byDVRType: BYTE;	         //DVR类型,
    byChanNum: BYTE;	         //DVR 通道个数
    byStartChan: BYTE;	       //起始通道号,例如DVS-1,DVR - 1
  end;
  TNET_DVR_DEVICEINFO = NET_DVR_DEVICEINFO;

  //图片质量
  PNET_DVR_JPEGPARA = ^LPNET_DVR_JPEGPARA;
  {$EXTERNALSYM NET_DVR_JPEGPARA}
  NET_DVR_JPEGPARA = Record
    wPicSize: WORD;	             // 0=CIF, 1=QCIF, 2=D1 */
  	wPicQuality: WORD;	         // 图片质量系数 0-最好 1-较好 2-一般 */
  end;
  LPNET_DVR_JPEGPARA = NET_DVR_JPEGPARA;

  TNET_DVR_Init     = function: Boolean; stdcall;
  TNET_DVR_Cleanup  = function: Boolean; stdcall;
  TNET_DVR_GetLastError = function ():LongWord; stdcall;

  TNET_DVR_Login = function(IPAddr:String;wDVRPort:WORD;UserName,PassWord:String;
  var nDeviceInfo: TNET_DVR_DEVICEINFO): longint; stdcall;
  {功能：注册用户到硬盘录像机}

  TNET_DVR_Logout = function(LoginID: longint): Boolean; stdcall;
  {功能：注册用户退出硬盘录像机}
  TNET_DVR_CaptureJPEGPicture = function(LoginID, lChannel: longint;
    nJpegPara: PNET_DVR_JPEGPARA; sPicFileName: String)
    :Boolean; stdcall;
  {功能：JPEG截图}

  { THKVNetSDK }
  THKVNetSDK = class(TObject)
  private
    FCLIENT_Init           : TNET_DVR_Init;
    FCLIENT_Cleanup        : TNET_DVR_Cleanup;
    FCLIENT_GetLastError   : TNET_DVR_GetLastError;

    FCLIENT_Login          : TNET_DVR_Login;
    FCLIENT_Logout         : TNET_DVR_Logout;

    FCLIENT_CapturePicture : TNET_DVR_CaptureJPEGPicture;

    FNeedClearUp: Boolean;
    FImagePath  : string;
    //FVideoPath  : string;
    FAppPath    : string; //应用程序路径
    FLibhandle  : HMODULE;
    FDllPath    : string;
  protected

  public
    constructor Create;
    destructor Destroy; override;

    function NET_DVR_Init: Boolean;
    function NET_DVR_Cleanup: Boolean;
    function NET_DVR_GetLastError():LongWord;

    function NET_DVR_Login(nPIPAddr: String; nDVRPort: WORD; nPUserName,
      nPPassWord: String; var nDeviceInfo: TNET_DVR_DEVICEINFO): longint;
    function NET_DVR_Logout(nLoginID: longint): Boolean;

    function NET_DVR_CaptureJPEGPicture(nLoginID, nChannel: longint;
       nJpegPara: NET_DVR_JPEGPARA; nPicFileName: String):Boolean;

    property dllpath:string  read FDllPath write FDllPath;
    property imagePath:string read FImagePath write FImagePath;
    //property videoPath:string read FVideoPath write FVideoPath;
  published

  end;

  //大华抓图设置
  PSNAP_PARAMS = ^SNAP_PARAMS;
  {$EXTERNALSYM SNAP_PARAMS}
  SNAP_PARAMS = Record
    Channel:  LongInt;
    Quality:  LongInt;
    ImageSize: LongInt;
    mode: LongInt;
    InterSnap: LongInt;
    CmdSerial: LongInt;
    Reserved : array [0..3] of LongInt;
  end;
  LPSNAP_PARAMS = SNAP_PARAMS;

  TDisConnect = procedure(nLoginID: LongInt; nDVRIP: String;
    nDVRPort: LongInt; nUser: LongWord); stdcall;
  //服务器断开回调原形
  TSnapRev = procedure(nLoginID: LongInt; npBuf: PByte; nRevLen: LongInt;
    nEncodeType: LongInt; nCmdSerial: LongWord; nUser: LongWord); stdcall;
  //抓图回调原形

  TCLIENT_Init=function (nDisConnect:TDisConnect;
    nUser:LongWord):Boolean;stdcall;
  //SDK初始化
  TCLIENT_Cleanup=procedure; stdcall;
  //SDK退出清理
  TCLIENT_SetConnectTime=procedure (nWaitTime: Integer;
    nTryTimes: Integer);stdcall;
  //设置连接服务器超时时间和尝试次数
  TCLIENT_GetSDKVersion=function: LongWord; stdcall;

  //获取SDK的版本信息
  TCLIENT_Login=function(nDVRIP: String; nDVRPort: WORD; nUserName: String;
    nPassword: String; var nDeviceInfo: TNET_DVR_DEVICEINFO;
    var nError: Integer): LongInt; stdcall;
  //向设备注册
  TCLIENT_Logout=function(nLoginID: LongInt): Boolean; stdcall;
  //向设备注销

  TCLIENT_RealPlay=function(nLoginID: LongInt; nChannelID: Integer;
    nHWnd: HWND): LongInt; stdcall;
  //开始实时预览
  TCLIENT_StopRealPlay=function(lRealHandle: LongInt)
    :Boolean; stdcall;
  //停止实时预览

  TCLIENT_SetDevConfig=function(nLoginID:LongInt; nCommand:DWORD;nChannel:LongInt;
    nPIn:Pointer;nInLen:DWORD;nWaittime:Integer=500)
    :Boolean;stdcall;
  //设置设备的配置信息

  TCLIENT_SnapPicture=function(nLoginID:LongInt;  nPar: PSNAP_PARAMS)
    :LongBool;stdcall;
  //获取实时图片
  TCLIENT_SnapPictureEx=function(nLoginID:LongInt;  nPar: PSNAP_PARAMS;
    nReserved:Pinteger):LongBool;stdcall;
  //获取实时图片
  TCLIENT_SaveRealData=function(nRealHandle:LongInt;
    const nVdoFileName:string):Boolean ; stdcall;
  //开始保存实时监视数据,对前端设备监视的图像进行数据保存,形成录像文件
  //,此数据是设备端传送过来的原始视频数据

  TCLIENT_GetLastError=function:LongInt; stdcall;
  //返回函数执行失败代码，当调用SDK接口失败时，可以用该函数获取失败的代码

  TCLIENT_SetSnapRevCallBack=procedure(OnSnapRevMessage:TSnapRev; dwUser:LongWord);stdcall;
  //异步返回
{ TDHNetSDK }
  TDHNetSDK = class(TObject)
  private
    FDisConnect            : TDisConnect;
    FCLIENT_SetConnectTime : TCLIENT_SetConnectTime;

    FCLIENT_Init           : TCLIENT_Init;
    FCLIENT_Cleanup        : TCLIENT_Cleanup;
    FCLIENT_GetLastError   : TCLIENT_GetLastError;

    FCLIENT_Login          : TCLIENT_Login;
    FCLIENT_Logout         : TCLIENT_Logout;

    FCLIENT_RealPlay       : TCLIENT_RealPlay;
    FCLIENT_StopRealPlay   : TCLIENT_StopRealPlay;

    FCLIENT_SnapPicture    : TCLIENT_SnapPicture;
    FCLIENT_SnapPictureEx  : TCLIENT_SnapPictureEx;
    FCLIENT_SaveRealData   : TCLIENT_SaveRealData;

    FCLIENT_SetSnapRevCallBack: TCLIENT_SetSnapRevCallBack;

    FNeedClearUp: Boolean;
    FImagePath  : string;
    FVideoPath  : string;
    FAppPath    : string; //应用程序路径
    FLibhandle  : HMODULE;
    FDllPath    : string;
  protected
    function NET_DVR_Init: Boolean;
    function NET_DVR_Cleanup: Boolean;
    function NET_DVR_GetLastError():LongWord;

    function NET_DVR_Login(nPIPAddr: String; nDVRPort: WORD; nPUserName,
      nPPassWord: String; var nDeviceInfo: TNET_DVR_DEVICEINFO): longint;
    function NET_DVR_Logout(nLoginID: longint): Boolean;

    function NET_DVR_CaptureJPEGPicture(nLoginID, nChannel: longint;
       nJpegPara: NET_DVR_JPEGPARA; nPicFileName: String):Boolean;

    function NET_DVR_SaveRealData(nLoginID, nChannel: longint;
      nVideoFileName: String; nHWnd: HWND=0):Boolean;

    function NET_DVR_RealPlay(nLoginID: LongInt; nChannelID: Integer;
      nHWnd: HWND=0): LongInt;
    function NET_DVR_StopRealPlay(nRealHandle: LongInt) :Boolean;

    procedure Bmp2JPEG(nBmpFile, nJPGFile:string; nQuality:Integer);
  public
    constructor Create;
    destructor Destroy; override;

    property dllpath:string  read FDllPath write FDllPath;
    property imagePath:string read FImagePath write FImagePath;
    property videoPath:string read FVideoPath write FVideoPath;
  published

  end;

{ TCameraNetSDKMgr }

  TCameraNetSDKMgr = class(TObject)
  private
    FAppPath    :string; //应用程序路径
    FNetSDKType :TDeviceType; //驱动类型

    FHKWNetSDK  :THKVNetSDK;
    FDHNetSDK   :TDHNetSDK;
  protected
    procedure SetDeviceType(nDevType: TDeviceType);
  public
    constructor Create;
    destructor Destroy; override;

    function NET_DVR_Init: Boolean;
    function NET_DVR_Cleanup: Boolean;
    function NET_DVR_GetLastError():LongWord;

    function NET_DVR_Login(nPIPAddr: String; nDVRPort: WORD; nPUserName,
      nPPassWord: String; var nDeviceInfo: TNET_DVR_DEVICEINFO): longint;
    function NET_DVR_Logout(nLoginID: longint): Boolean;

    function NET_DVR_CaptureJPEGPicture(nLoginID, nChannel: longint;
       nJpegPara: NET_DVR_JPEGPARA; nPicFileName: String):Boolean;

    function NET_DVR_SaveRealData(nLoginID, nChannel: longint;
      nVideoFileName: String; nHWnd: HWND=0):Boolean;

    function NET_DVR_RealPlay(nLoginID: LongInt; nChannelID: Integer;
      nHWnd: HWND=0): LongInt;
    function NET_DVR_StopRealPlay(nRealHandle: LongInt) :Boolean;

    function NET_DVR_SetDevType(nDevType: string):Boolean;

    procedure SetImagePath(nImagePath: string);
    procedure SetDevDllPath(nDriverPath: string);

    property netsdktype: TDeviceType write SetDeviceType;
  published

  end;

var
  gSnapFilePath: string='';
  gCameraNetSDKMgr:TCameraNetSDKMgr=nil;
  gSnapCriticalSection: TCriticalSection;
implementation

const
  gDHNetSDKDll  = 'dhnetsdk.dll';  //大华
  gHCNetSDKDll  = 'HCNetSDK.dll';  //海康威视

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TCameraNetSDKMgr, '硬盘录像管理模块', nEvent);
end;

function IsAssignedFunc(nPFunc: Pointer; const nFuncName: string):Boolean;
var
  nLog:string;
begin
  if not Assigned(nPFunc) then
  begin
    nLog := '获取函数池[%s]失败';
    nLog := Format(nLog, [nFuncName]);

    WriteLog(nLog);Result:= False;
    Exit;
  end;
  Result := True;
end;

{ TCameraNetSDKMgr }
constructor TCameraNetSDKMgr.Create;
begin
  FAppPath := ExtractFilePath(ParamStr(0));
  if not Assigned(gSysLoger) then
    gSysLoger := TSysLoger.Create(FAppPath + 'logs\');

  FNetSDKType := dtDH;

  FDHNetSDK := TDHNetSDK.Create;
  FHKWNetSDK := THKVNetSDK.Create;
end;

destructor TCameraNetSDKMgr.Destroy;
begin
  FDHNetSDK.Free;
  FHKWNetSDK.Free;
end;

procedure TCameraNetSDKMgr.SetDeviceType(nDevType: TDeviceType);
begin
  FNetSDKType := nDevType;
end;

function TCameraNetSDKMgr.NET_DVR_SetDevType(nDevType: string):Boolean;
begin
  Result := True;
  if UpperCase(nDevType) = 'DH' then       //大华驱动
    FNetSDKType := dtDH
  else if UpperCase(nDevType) = 'HKV' then //海康驱动
    FNetSDKType := dtHK
  else //无此驱动
    Result := False;
end;  


function TCameraNetSDKMgr.NET_DVR_Init: Boolean;
begin
  case FNetSDKType of
  dtHK:
  begin
    Result := FHKWNetSDK.NET_DVR_Init;
  end;
  dtDH:
  begin
    Result := FDHNetSDK.NET_DVR_Init;
  end;
  end;
end;

function TCameraNetSDKMgr.NET_DVR_Cleanup: Boolean;
begin
  case FNetSDKType of
  dtHK:
  begin
    Result := FHKWNetSDK.NET_DVR_Cleanup;
  end;
  dtDH:
  begin
    Result := FDHNetSDK.NET_DVR_Cleanup;
  end;
  end;
end;

function TCameraNetSDKMgr.NET_DVR_GetLastError():LongWord;
begin
  case FNetSDKType of
  dtHK:
    Result := FHKWNetSDK.NET_DVR_GetLastError;
  dtDH:
    Result := FDHNetSDK.NET_DVR_GetLastError;
  end;
end;


function TCameraNetSDKMgr.NET_DVR_Login(nPIPAddr: string; nDVRPort: WORD;
  nPUserName,nPPassWord: string; var nDeviceInfo: TNET_DVR_DEVICEINFO):LongInt;
begin
  case FNetSDKType of
  dtHK:
    Result := FHKWNetSDK.NET_DVR_Login(nPIPAddr, nDVRPort, nPUserName,
      nPPassWord, nDeviceInfo);
  dtDH:
    Result := FDHNetSDK.NET_DVR_Login(nPIPAddr, nDVRPort, nPUserName,
      nPPassWord, nDeviceInfo);
  end;
end;

function TCameraNetSDKMgr.NET_DVR_Logout(nLoginID: longint): Boolean;
begin
  case FNetSDKType of
  dtHK:
    Result := FHKWNetSDK.NET_DVR_Logout(nLoginID);
  dtDH:
    Result := FDHNetSDK.NET_DVR_Logout(nLoginID);
  end;
end;

function TCameraNetSDKMgr.NET_DVR_CaptureJPEGPicture(nLoginID, nChannel: longint;
       nJpegPara: NET_DVR_JPEGPARA; nPicFileName: String):Boolean;
begin
  case FNetSDKType of
  dtHK:
    Result := FHKWNetSDK.NET_DVR_CaptureJPEGPicture(nLoginID, nChannel,
      nJpegPara, nPicFileName);
  dtDH:
    Result := FDHNetSDK.NET_DVR_CaptureJPEGPicture(nLoginID, nChannel,
      nJpegPara, nPicFileName);
  end;
end;


function TCameraNetSDKMgr.NET_DVR_RealPlay(nLoginID: LongInt; nChannelID: Integer;
  nHWnd: HWND=0): LongInt;
begin
  case FNetSDKType of
  dtHK:;
  dtDH:
    Result := FDHNetSDK.NET_DVR_RealPlay(nLoginID, nChannelID, nHWnd);
  end;
end;

function TCameraNetSDKMgr.NET_DVR_StopRealPlay(nRealHandle: LongInt) :Boolean;
begin
  case FNetSDKType of
  dtHK:;
  dtDH:
    Result := FDHNetSDK.NET_DVR_StopRealPlay(nRealHandle);
  end;
end;

function TCameraNetSDKMgr.NET_DVR_SaveRealData(nLoginID, nChannel: longint;
  nVideoFileName: string; nHWnd: HWND=0):Boolean;
begin
  case FNetSDKType of
  dtHK:;
  dtDH:
    Result := FDHNetSDK.NET_DVR_SaveRealData(nLoginID, nChannel, nVideoFileName,
      nHWnd);
  end;
end;

procedure TCameraNetSDKMgr.SetImagePath(nImagePath: string);
begin
  case FNetSDKType of
  dtHK:
    FHKWNetSDK.imagePath := nImagePath;
  dtDH:
    FDHNetSDK.imagePath := nImagePath;
  end;
end;
procedure TCameraNetSDKMgr.SetDevDllPath(nDriverPath: string);
begin
  case FNetSDKType of
  dtHK:
    FHKWNetSDK.dllpath := nDriverPath;
  dtDH:
    FDHNetSDK.dllpath := nDriverPath;
  end;
end;

//------------------------------------------------------------------------------

constructor THKVNetSDK.Create;
begin
  FAppPath := ExtractFilePath(ParamStr(0));

  FImagePath   := FAppPath + 'images\';
  FDllPath     := FAppPath + 'HKVNETSDKS\';
  //xxxxxx

  FNeedClearUp := False;
end;

destructor THKVNetSDK.Destroy;
begin
  if FNeedClearUp then
  begin
    NET_DVR_Cleanup;
    FreeLibrary(FLibhandle);
  end;
end;

function THKVNetSDK.NET_DVR_Init: Boolean;
var
  nLog, nErr: string;
begin
  FLibhandle := SafeLoadLibrary(FDllPath + gHCNetSDKDll);
  if FLibhandle <= 0 then
  begin
    nLog := '设备驱动[%s]加载失败';
    nErr := FDllPath + gHCNetSDKDll;
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog);Result := False;
    Exit;
  end;

  FCLIENT_Init            :=  GetProcAddress(FLibhandle, 'NET_DVR_Init');
  FCLIENT_Cleanup         :=  GetProcAddress(FLibhandle, 'NET_DVR_Cleanup');

  FCLIENT_Login           :=  GetProcAddress(FLibhandle, 'NET_DVR_Login');
  FCLIENT_Logout          :=  GetProcAddress(FLibhandle, 'NET_DVR_Logout');

  FCLIENT_GetLastError    :=  GetProcAddress(FLibhandle, 'NET_DVR_GetLastError');
  FCLIENT_CapturePicture  :=  GetProcAddress(FLibhandle, 'NET_DVR_CaptureJPEGPicture');


  Result := IsAssignedFunc(@FCLIENT_Init, 'NET_DVR_Init');
  if not Result then Exit;

  Result := FCLIENT_Init;
  if not Result then
  begin
    nLog := '设备初始化失败，返回错误码[%s]';
    nErr := IntToHex(NET_DVR_GetLastError,2);
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog);
    Exit;
  end;

  FNeedClearUp := True;
end;

function THKVNetSDK.NET_DVR_Cleanup: Boolean;
begin
  Result := IsAssignedFunc(@FCLIENT_Cleanup, 'NET_DVR_Clearup');
  if not Result then Exit;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=False;
    Exit;
  end;

  FCLIENT_Cleanup;
  Result:= True;

  FNeedClearUp := False;
  FreeLibrary(FLibhandle);
end;

function THKVNetSDK.NET_DVR_GetLastError():LongWord;
begin
  if (not IsAssignedFunc(@FCLIENT_GetLastError, 'NET_DVR_GetLastError'))then
  begin
    Result := LongWord(-1);
    Exit;
  end;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=LongWord(-1);
    Exit;
  end;

  Result := FCLIENT_GetLastError;
end;


function THKVNetSDK.NET_DVR_Login(nPIPAddr: string; nDVRPort: WORD;
  nPUserName,nPPassWord: string; var nDeviceInfo: TNET_DVR_DEVICEINFO):LongInt;
var
  nLog: string;
  nDevLoginID: Integer;
begin
  if (not IsAssignedFunc(@FCLIENT_Login, 'NET_DVR_Login')) then
  begin
    Result := -1;Exit;
  end;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=-1;
    Exit;
  end;

  nDevLoginID := FCLIENT_Login(nPIPAddr, nDVRPort, nPUserName,
                               nPPassWord, nDeviceInfo);
  //xxxxxx

  if nDevLoginID < 0 then
  begin
    nLog := '注册用户到设备失败，返回错误码[%s]';
    nLog := Format(nLog, [IntToHex(NET_DVR_GetLastError,2)]);

    WriteLog(nLog);
  end;

  Result := nDevLoginID;
end;

function THKVNetSDK.NET_DVR_Logout(nLoginID: longint): Boolean;
var
  nLog, nErr: string;
begin
  Result := IsAssignedFunc(@FCLIENT_Logout, 'NET_DVR_Logout');
  if (not Result) then Exit;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=False;
    Exit;
  end;

  Result := FCLIENT_Logout(nLoginID);

  if not Result then
  begin
    nLog := '用户退出设备失败，返回错误码[%s]';
    nErr := IntToHex(NET_DVR_GetLastError,2);
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog);
  end;
end;

function THKVNetSDK.NET_DVR_CaptureJPEGPicture(nLoginID, nChannel: longint;
       nJpegPara: NET_DVR_JPEGPARA; nPicFileName: String):Boolean;
var
  nLog, nErr: string;
begin
  Result := IsAssignedFunc(@FCLIENT_CapturePicture, 'NET_DVR_CaptureJPEGPicture');
  if (not Result) then Exit;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=False;
    Exit;
  end;

  Result := FCLIENT_CapturePicture(nLoginID,nChannel,@nJpegPara,nPicFileName);
  if not Result then
  begin
    nLog := '实时抓图失败，返回错误码[%s]';
    nErr := IntToHex(NET_DVR_GetLastError,2);
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog);
    Exit;
  end;
end;

//------------------------------------------------------------------------------

procedure SetSnapPath(nPath :string='');
begin
  gSnapCriticalSection.Enter;
  try
    gSnapFilePath := nPath;
  finally
    gSnapCriticalSection.Leave;
  end;
end;  

procedure SnapCallBack(nLoginID: LongInt; npBuf: PByte; nRevLen: LongInt;
  nEncodeType: LongInt; nCmdSerial: LongWord; nUser: LongWord); stdcall;
var
  nFileS:TFileStream;
begin
  gSnapCriticalSection.Enter;
  nFileS := TFileStream.Create(gSnapFilePath, fmcreate);
  try
    nFileS.Write(npBuf^,nRevLen);
  finally
    nFileS.Free;
    gSnapCriticalSection.Leave;
  end;
end;

constructor TDHNetSDK.Create;
begin
  FAppPath := ExtractFilePath(ParamStr(0));

  FImagePath   := FAppPath + 'images\';
  FVideoPath   := FAppPath + 'videos\';
  FDllPath     := FAppPath + 'DHNETSDKS\';
  //xxxxxx

  FNeedClearUp := False;
  FDisConnect := nil;
end;

destructor TDHNetSDK.Destroy;
begin
  if FNeedClearUp then
  begin
    NET_DVR_Cleanup;
    FreeLibrary(FLibhandle);
  end;
end;

function TDHNetSDK.NET_DVR_Init: Boolean;
var
  nLog, nErr: string;
begin
  FLibhandle              := SafeLoadLibrary(FDllPath + gDHNetSDKDll);
  if FLibhandle <= 0 then
  begin
    nLog := '设备驱动[%s]加载失败';
    nErr := FDllPath + gHCNetSDKDll;
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog); Result := False;
    Exit;
  end;

  FCLIENT_Init            :=  GetProcAddress(FLibhandle, 'CLIENT_Init');
  FCLIENT_Cleanup         :=  GetProcAddress(FLibhandle, 'CLIENT_Cleanup');
  FCLIENT_SetConnectTime  :=  GetProcAddress(FLibhandle, 'CLIENT_SetConnectTime');

  FCLIENT_Login           :=  GetProcAddress(FLibhandle, 'CLIENT_Login');
  FCLIENT_Logout          :=  GetProcAddress(FLibhandle, 'CLIENT_Logout');

  FCLIENT_RealPlay        :=  GetProcAddress(FLibhandle, 'CLIENT_RealPlay');
  FCLIENT_StopRealPlay    :=  GetProcAddress(FLibhandle, 'CLIENT_StopRealPlay');

  FCLIENT_SnapPicture     :=  GetProcAddress(FLibhandle, 'CLIENT_SnapPicture');
  FCLIENT_SnapPictureEx   :=  GetProcAddress(FLibhandle, 'CLIENT_SnapPictureEx');
  FCLIENT_SaveRealData    :=  GetProcAddress(FLibhandle, 'CLIENT_SaveRealData');

  FCLIENT_GetLastError    :=  GetProcAddress(FLibhandle, 'CLIENT_GetLastError');

  FCLIENT_SetSnapRevCallBack  :=  GetProcAddress(FLibhandle, 'CLIENT_SetSnapRevCallBack');


  Result := IsAssignedFunc(@FCLIENT_Init, 'CLIENT_Init');
  if not Result then Exit;

  Result := FCLIENT_Init(FDisConnect , 0);
  if not Result then
  begin
    nLog := '设备初始化失败，返回错误码[%s]';
    nErr := IntToHex(NET_DVR_GetLastError,2);
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog);
    Exit;
  end;

  if Assigned(FCLIENT_SetConnectTime) then
    FCLIENT_SetConnectTime(5000,3);
  if Assigned(FCLIENT_SetSnapRevCallBack) then
    FCLIENT_SetSnapRevCallBack(SnapCallBack, 0);
  FNeedClearUp := True;
end;

function TDHNetSDK.NET_DVR_Cleanup: Boolean;
begin
  Result := IsAssignedFunc(@FCLIENT_Cleanup, 'CLIENT_Clearup');
  if (not Result) then Exit;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=False;
    Exit;
  end;

  FCLIENT_Cleanup;
  Result:= True;

  FNeedClearUp := False;
  FreeLibrary(FLibhandle);
end;

function TDHNetSDK.NET_DVR_GetLastError():LongWord;
begin
  if (not IsAssignedFunc(@FCLIENT_GetLastError, 'CLIENT_GetLastError')) then
  begin
    Result := LongWord(-1);
    Exit;
  end;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=LongWord(-1);
    Exit;
  end;

  Result := FCLIENT_GetLastError;
end;


function TDHNetSDK.NET_DVR_Login(nPIPAddr: string; nDVRPort: WORD;
  nPUserName,nPPassWord: string; var nDeviceInfo: TNET_DVR_DEVICEINFO):LongInt;
var
  nLog: string;
  nErr,nDevLoginID: Integer;
begin
  if (not IsAssignedFunc(@FCLIENT_Login, 'CLIENT_Login')) then
  begin
    Result := -1;Exit;
  end;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=-1;
    Exit;
  end;

  nDevLoginID := FCLIENT_Login(nPIPAddr, nDVRPort, nPUserName,
                               nPPassWord, nDeviceInfo, nErr);
  //xxxxxx

  if nDevLoginID<=0 then
  begin
    nLog := '注册用户到设备失败，返回错误码[%d:%s]';
    nLog := Format(nLog, [nErr,IntToHex(NET_DVR_GetLastError,2)]);

    WriteLog(nLog);
  end;

  Result := nDevLoginID;
end;

function TDHNetSDK.NET_DVR_Logout(nLoginID: longint): Boolean;
var
  nLog, nErr: string;
begin
  Result := IsAssignedFunc(@FCLIENT_Logout, 'CLIENT_Logout');
  if (not Result) then Exit;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=False;
    Exit;
  end;

  Result := FCLIENT_Logout(nLoginID);

  if not Result then
  begin
    nLog := '用户退出设备失败，返回错误码[%s]';
    nErr := IntToHex(NET_DVR_GetLastError,2);
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog);
  end;
end;

function TDHNetSDK.NET_DVR_CaptureJPEGPicture(nLoginID, nChannel: longint;
       nJpegPara: NET_DVR_JPEGPARA; nPicFileName: String):Boolean;
var
  nReserved: Integer;
  nLog, nErr: string;
  nSnapparams: SNAP_PARAMS;
begin
  Result := IsAssignedFunc(@FCLIENT_SnapPictureEx, 'CLIENT_SnapPictureEx');
  if (not Result) then Exit;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=False;
    Exit;
  end;

  SetSnapPath(nPicFileName);
  with nSnapparams do
  begin
    mode := 0;
    InterSnap := 0;
    CmdSerial := 120;

    Channel := nChannel;
    ImageSize := nJpegPara.wPicSize;
    Quality := nJpegPara.wPicQuality;
  end;
  //Result := FCLIENT_SnapPicture(nLoginID,@nSnapparams);
  Result := FCLIENT_SnapPictureEx(nLoginID,@nSnapparams,@nReserved);
  if not Result then
  begin
    nLog := '异步抓图失败，返回错误码[%s]';
    nErr := IntToHex(NET_DVR_GetLastError,2);
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog); Exit;
  end;
  Sleep(1500);
end;


function TDHNetSDK.NET_DVR_RealPlay(nLoginID: LongInt; nChannelID: Integer;
  nHWnd: HWND=0): LongInt;
var
  nLog, nErr: string;
begin
  if (not IsAssignedFunc(@FCLIENT_RealPlay, 'CLIENT_RealPlay'))then
  begin Result := -1;  Exit; end;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=-1;
    Exit;
  end;

  Result := FCLIENT_RealPlay(nLoginID, nChannelID, nHWnd);
  if Result=0 then
  begin
    nLog := '启动实时监视失败，返回错误码[%s]';
    nErr := IntToHex(NET_DVR_GetLastError,2);
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog);
    Exit;
  end;
end;

function TDHNetSDK.NET_DVR_StopRealPlay(nRealHandle: LongInt) :Boolean;
var
  nLog, nErr: string;
begin
  Result := IsAssignedFunc(@FCLIENT_StopRealPlay, 'CLIENT_StopRealPlay');
  if (not Result) then Exit;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=False;
    Exit;
  end;

  Result := FCLIENT_StopRealPlay(nRealHandle);
  if not Result then
  begin
    nLog := '停止实时监视失败，返回错误码[%s]';
    nErr := IntToHex(NET_DVR_GetLastError,2);
    nLog := Format(nLog, [nErr]);

    WriteLog(nLog);
    Exit;
  end;
end;

function TDHNetSDK.NET_DVR_SaveRealData(nLoginID, nChannel: longint;
  nVideoFileName: string; nHWnd: HWND=0):Boolean;
var
  nLog, nErr: string;
  nRealHandle :LongInt;
begin
  Result := IsAssignedFunc(@FCLIENT_SaveRealData, 'CLIENT_SaveRealData');
  if (not Result) then Exit;

  if not FNeedClearUp then
  begin
    WriteLog('未初始化SDK，请初始化');
    Result:=False;
    Exit;
  end;

  nRealHandle := NET_DVR_RealPlay(nLoginID, nChannel, nHWnd);
  try
    if nRealHandle=0 then
    begin
      nLog := '启动实时监视失败，返回错误码[%s]';
      nErr := IntToHex(NET_DVR_GetLastError,2);
      nLog := Format(nLog, [nErr]);

      WriteLog(nLog);
      Exit;
    end;

    Result := FCLIENT_SaveRealData(nRealHandle, nVideoFileName);
    if not Result then
    begin
      nLog := '实时监控保存失败，返回错误码[%s]';
      nErr := IntToHex(NET_DVR_GetLastError,2);
      nLog := Format(nLog, [nErr]);

      WriteLog(nLog);
      Exit;
    end;
  finally
    
  end;
end;

procedure TDHNetSDK.Bmp2JPEG(nBmpFile, nJPGFile:string; nQuality:Integer);
var
  nBmp: TBitmap;
  nJpeg: TJpegImage;
begin
  if not DirectoryExists(ExtractFilePath(nBmpFile)) then
    nBmpFile := FImagePath + nBmpFile;
  if not DirectoryExists(ExtractFilePath(nJPGFile)) then
    nJPGFile := FImagePath + nJPGFile;

  if FileExists(nBmpFile) then
  begin
    nBmp:= TBitmap.Create;
    nJpeg:= TJpegImage.Create;

    try
      nBmp.LoadFromFile(nBmpFile);

      with nJpeg do
      begin
        Assign(nBmp);
        CompressionQuality := nQuality;
        Compress;

        SaveToFile(nJPGFile);
      end;
    finally
      nBmp.free;
      nJpeg.free;
    end;
  end;
end;

initialization
  gCameraNetSDKMgr := TCameraNetSDKMgr.Create;
  gSnapCriticalSection := TCriticalSection.Create;
finalization
  gSnapCriticalSection.Free;
  FreeAndNil(gCameraNetSDKMgr);
end.
