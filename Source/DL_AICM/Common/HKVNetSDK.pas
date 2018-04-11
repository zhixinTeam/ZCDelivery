{*******************************************************************************
  作者: dmzn@163.com 2014-03-07
  描述: 海康威视HCNetSDK.dll头文件
*******************************************************************************}
unit HKVNetSDK;

interface

uses
  Windows, Classes, HKVConst;

const
  cNetSDK  = 'HCNetSDK.dll';
  
type
  PIPItems = ^TIPItems;
  TIPItems = array[0..15, 0..15] of Char;

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

function NET_DVR_Init: Boolean; stdcall; external cNetSDK;
function NET_DVR_Cleanup: Boolean; stdcall; external cNetSDK;
function NET_DVR_GetLastError():LongWord; stdcall; external cNetSDK;

function NET_DVR_Login(IPAddr: PChar;wDVRPort: WORD;UserName: PChar;PassWord: PChar;
  lpDeviceInfo: PNET_DVR_DEVICEINFO): longint; stdcall; external cNetSDK;
{功能：注册用户到硬盘录像机}

function NET_DVR_Logout(LoginID: longint): Integer; stdcall;external cNetSDK;
{功能：注册用户退出硬盘录像机}
function NET_DVR_CaptureJPEGPicture(LoginID: longint; lChannel: longint;
 lpJpegPara: PNET_DVR_JPEGPARA; sPicFileName: PChar):Boolean; stdcall;external cNetSDK;
{功能：JPEG截图}

implementation

end.
