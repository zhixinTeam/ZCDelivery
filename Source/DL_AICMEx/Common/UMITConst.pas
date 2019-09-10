{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 常量定义
*******************************************************************************}
unit UMITConst;

{$I Link.Inc}
interface

uses
  Windows, SysUtils, Classes, ComCtrls, Forms, IniFiles, USysMAC;

const
  cSBar_Date          = 0;                           //日期面板索引
  cSBar_Time          = 1;                           //时间面板索引
  cSBar_User          = 2;                           //用户面板索引

const
  {*Frame ID*}
  cFI_FrameRunlog     = $0002;                       //运行日志
  cFI_FrameSummary    = $0005;                       //信息摘要
  cFI_FrameConfig     = $0006;                       //基本设置
  cFI_FrameParam      = $0007;                       //参数配置
  cFI_FramePlugs      = $0008;                       //插件管理

  {*Form ID*}
  cFI_FormPack        = $0050;                       //参数包
  cFI_FormDB          = $0051;                       //数据库
  cFI_FormSAP         = $0052;                       //sap
  cFI_FormPerform     = $0053;                       //性能配置
  cFI_FormServiceURL  = $0055;                       //服务地址

  {*Command*}
  cCmd_AdminChanged   = $0001;                       //管理切换
  cCmd_RefreshData    = $0002;                       //刷新数据
  cCmd_ViewSysLog     = $0003;                       //系统日志

  cCmd_ModalResult    = $1001;                       //Modal窗体
  cCmd_FormClose      = $1002;                       //关闭窗口
  cCmd_AddData        = $1003;                       //添加数据
  cCmd_EditData       = $1005;                       //修改数据
  cCmd_ViewData       = $1006;                       //查看数据

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //版权声明

    FAppFlag    : string;                            //程序标识
    FParam      : string;                            //启动参数
    FIconFile   : string;                            //图标文件

    FAdminPwd   : string;                            //管理员密码
    FIsAdmin    : Boolean;                           //管理员状态
    FAdminKeep  : Integer;                           //状态保持

    FLocalIP    : string;                            //本机IP
    FLocalMAC   : string;                            //本机MAC
    FLocalName  : string;                            //本机名称

    FDisplayDPI : Integer;                           //屏幕分辨率
    FAutoMin    : Boolean;                           //自动最小化
  end;
  //系统参数

var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure ActionSysParameter(const nIsRead: Boolean);
//读写系统配置参数

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//在状态栏显示信息

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'Bus_MIT';                   //默认标识
  sAppTitle           = 'Bus_MIT';                   //程序标题
  sMainCaption        = '通用中间件';                //主窗口标题
  sHintText           = '通用中间件服务';            //提示内容

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '错误';                      //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  
  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sLogDir             = 'Logs\';                     //日志目录
  sLogSyncLock        = 'SyncLock_MIT_CommonMIT';    //日志同步锁

  sPlugDir            = 'Plugs\';                    //插件目录
  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出
  
implementation

procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Desc: 读写系统配置参数
procedure ActionSysParameter(const nIsRead: Boolean);
var nIni: TIniFile;
begin
  nIni := nil;
  try
    nIni := TIniFile.Create(gPath + sConfigFile);
    //config file

    with nIni,gSysParam do
    begin
      if nIsRead then
      begin
        FProgID    := ReadString(sConfigSec, 'ProgID', sProgID);
        //程序标识决定以下所有参数          
        FAppTitle  := ReadString(FProgID, 'AppTitle', sAppTitle);
        FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
        FHintText  := ReadString(FProgID, 'HintText', '');

        FCopyRight := ReadString(FProgID, 'CopyRight', '');
        FCopyRight := StringReplace(FCopyRight, '\n', #13#10, [rfReplaceAll]);
        FAppFlag   := ReadString(FProgID, 'AppFlag', 'COMMIT');

        FParam     := ParamStr(1);
        FIconFile  := ReadString(FProgID, 'IconFile', gPath + 'Icons\Icon.ini');
        FIconFile  := StringReplace(FIconFile, '$Path\', gPath, [rfIgnoreCase]);

        FLocalMAC   := MakeActionID_MAC;
        GetLocalIPConfig(FLocalName, FLocalIP);
        FDisplayDPI := GetDeviceCaps(GetDC(0), LOGPIXELSY);
      end;
    end;
  finally
    nIni.Free;
  end; 
end;

//------------------------------------------------------------------------------
//Desc: 在全局状态栏最后一个Panel上显示nMsg消息
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: 在索引nIdx的Panel上显示nMsg消息
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > nIdx) and
     (nIdx > -1) then
  begin
    gStatusBar.Panels[nIdx].Text := nMsg;
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) +
                                     Trunc(gSysParam.FDisplayDPI * Length(nMsg) / 50);
    //Application.ProcessMessages;
  end;
end;

end.
