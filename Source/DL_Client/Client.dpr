program Client;

uses
  Forms,
  Windows,
  ULibFun,
  USysFun,
  UsysConst,
  UDataModule in 'Forms\UDataModule.pas' {FDM: TDataModule},
  UFormMain in 'Forms\UFormMain.pas' {fMainForm},
  UFrameBase in 'Forms\UFrameBase.pas' {BaseFrame: TBaseFrame},
  UFormBase in 'Forms\UFormBase.pas' {BaseForm},
  UFrameNormal in 'Forms\UFrameNormal.pas' {fFrameNormal: TFrame},
  UFormNormal in 'Forms\UFormNormal.pas' {fFormNormal};

{$R *.res}
var
  gMutexHwnd: Hwnd;
  //互斥句柄

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_KGDelivery');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例

  InitSystemEnvironment;
  //初始化运行环境
  LoadSysParameter;
  //载入系统配置信息

  if not IsValidConfigFile(gPath + sConfigFile, gSysParam.FProgID) then
  begin
    ShowDlg(sInvalidConfig, sHint, GetDesktopWindow); Exit;
  end; //配置文件被改动
  
  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfMainForm, fMainForm);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.
