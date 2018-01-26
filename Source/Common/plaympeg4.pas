unit plaympeg4;

interface

uses
{$IFDEF WIN32}
  Windows;
{$ELSE}
  Wintypes, WinProcs;
{$ENDIF}

//Stream type
//#define STREAME_REALTIME 0
//#define STREAME_FILE	 1
const
    STREAME_REALTIME = 0;
const
    STREAME_FILE = 1;

//PLAYM4_API BOOL __stdcall PlayM4_GetPort(LONG* nPort);
type
PLongInt = ^LongInt;
type LPByte = ^Byte;
function PlayM4_GetPort(nPort: PLongInt):BOOL;stdcall; external 'PlayCtrl.dll'

//PLAYM4_API BOOL __stdcall	PlayM4_SetStreamOpenMode(LONG nPort,DWORD nMode);
function PlayM4_SetStreamOpenMode(nPort:LongInt; nMode:DWORD): BOOL;stdcall; external 'PlayCtrl.dll'

//BOOL __stdcall PlayM4_OpenStream(LONG nPort,PBYTE pFileHeadBuf,DWORD nSize,DWORD nBufPoolSize);
function PlayM4_OpenStream(nPort: LongInt; pFileHeadBuf: LPByte; nsize:DWORD; nBufPoolSize:DWORD):BOOL;stdcall; external 'PlayCtrl.dll'

//BOOL __stdcall PlayM4_OpenStream(LONG nPort,PBYTE pFileHeadBuf,DWORD nSize,DWORD nBufPoolSize);
//function PlayM4_OpenStream(nPort:LongInt; pFileHeadBuf:PByte; nSize:DWORD; nBufPoolSize:DWORD ):BOOL;stdcall; external 'PlayCtrl.dll'

//BOOL __stdcall PlayM4_Play(LONG nPort, HWND hWnd);
function PlayM4_Play(nPort:LongInt; hWnd:HWND):BOOL;stdcall; external 'PlayCtrl.dll'

//PLAYM4_API BOOL __stdcall PlayM4_InputData(LONG nPort,PBYTE pBuf,DWORD nSize);
function PlayM4_InputData(nPort:LongInt; pBuf:LPByte; nSize:DWORD):BOOL;stdcall; external 'PlayCtrl.dll'

implementation

end.
