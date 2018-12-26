{*******************************************************************************
  作者: dmzn@163.com 2013-11-19
  描述: 中间件通用框架主单元
*******************************************************************************}
unit UFormMain;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UTrayIcon, UcxChinese, UMgrPlug, cxGraphics, cxControls,
  cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxNavBar2Painter, cxContainer, cxEdit,
  ExtCtrls, ComCtrls, cxLabel, dxNavBarCollns, cxClasses, dxNavBarBase,
  dxNavBar, cxLookAndFeels;

type
  TfFormMain = class(TForm)
    PanelTitle: TPanel;
    ImgLeft: TImage;
    ImgClient: TImage;
    LabelHint: TcxLabel;
    SBar: TStatusBar;
    Timer1: TTimer;
    Timer2: TTimer;
    PanelWork: TPanel;
    dxNavBar1: TdxNavBar;
    BarGroup1: TdxNavBarGroup;
    BarGroup2: TdxNavBarGroup;
    BarGroup3: TdxNavBarGroup;
    SysSummary: TdxNavBarItem;
    SysRunlog: TdxNavBarItem;
    SysConfig: TdxNavBarItem;
    SysRunParam: TdxNavBarItem;
    BarGroup4: TdxNavBarGroup;
    BarGroup4Control: TdxNavBarGroupControl;
    LabelCopy: TcxLabel;
    LabelAdmin: TcxLabel;
    Timer3: TTimer;
    SysService: TdxNavBarItem;
    Timer4: TTimer;
    SysPlugs: TdxNavBarItem;
    SysStatus: TdxNavBarItem;
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SysSummaryClick(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure LabelAdminClick(Sender: TObject);
    procedure SysServiceClick(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*状态栏图标*}
  protected
    procedure SetHintText(const nLabel: TcxLabel);
    {*提示信息*}
    procedure DoMenuClick(Sender: TObject);
    {*菜单事件*}
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
    procedure PMRestoreForm(var nMsg: TMessage); message PM_RestoreForm;
    procedure PMRefreshMenu(var nMsg: TMessage); message PM_RefreshMenu;
    {*消息处理*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UBase64, UROModule, USysLoger, UFormWait, UFormInputbox,
  UFrameBase, UFormBase, UMITModule, UMITConst;

//------------------------------------------------------------------------------
//Date: 2007-10-15
//Parm: 标签
//Desc: 在nLabel上显示提示信息
procedure TfFormMain.SetHintText(const nLabel: TcxLabel);
begin
  with nLabel.Properties do
  begin
    Depth := 2;
    ShadowedColor := clGray;

    LabelEffect := cxleCool;
    LabelStyle := cxlsNormal;
  end;

  with nLabel.Style do
  begin
    Font.Color := clWhite;
    Font.Size := 15;
    //Font.Style := Font.Style + [fsBold];
  end;
              
  with nLabel do
  begin
    Caption := gSysParam.FHintText;
    Left := PanelTitle.Width - Width - 12;
    Top := (PanelTitle.Height - Height) div 2 + 2;
  end;
end;
       
//Desc: 载入配置
procedure TfFormMain.FormLoadConfig;
var nStr: string;
    nIni: TIniFile;
begin
  dxNavBar1.Width := ImgLeft.Width - 65;
  PanelTitle.Height := ImgLeft.Picture.Height;
  //宽度校正,使用不同放大比例的屏幕

  gStatusBar := sBar;
  PanelTitle.DoubleBuffered := True; 

  SetHintText(LabelHint);
  LabelCopy.Caption := gSysParam.FCopyRight;
  BarGroup4Control.Height := LabelCopy.Height + LabelAdmin.Height + 8 * 2;

  nStr := Format(sDate, [DateToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Date);
  nStr := Format(sTime, [TimeToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Time);

  FDM.LoadSystemIcons(gSysParam.FIconFile);
  //载入图标
  CreateBaseFrameItem(cFI_FrameSummary, PanelWork);
  //创建主面板

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    with gSysParam do
    begin
      FIsAdmin := False;
      FAdminPwd := nIni.ReadString('System', 'AdminPwd', '');
      FAdminPwd := DecodeBase64(FAdminPwd);

      FAdminKeep := nIni.ReadInteger('System', 'AdminKeep', 60);
      FAutoMin := nIni.ReadBool('System', 'AutoMin', False);
    end;

     LoadFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

//Desc: 保存窗体配置
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    with gSysParam do
    begin
      nIni.WriteString('System', 'AdminPwd', EncodeBase64(FAdminPwd));
      nIni.WriteInteger('System', 'AdminKeep', FAdminKeep);
      nIni.WriteBool('System', 'AutoMin', FAutoMin);
    end;

    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  ActionSysParameter(False);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  nStr := ChangeFileExt(Application.ExeName, '.ico');
  if FileExists(nStr) then
    Application.Icon.LoadFromFile(nStr);
  //change app icon

  FormLoadConfig;
  //load config
  
  InitSystemObject(Handle);
  //system object

  RunSystemObject;
  //run object
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nStr: string;
begin
  ShowWaitForm(Self, '正在退出系统', True);
  try
    ROModule.ActiveServer([stTcp, stHttp], False, nStr);
    //stop server

    FormSaveConfig;
    //save config

    FreeSystemObject;
    //system object
                             
    {$IFNDEF debug}
    Sleep(2200);
    {$ENDIF}
  finally
    CloseWaitForm;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 恢复窗体状态
procedure TfFormMain.PMRestoreForm(var nMsg: TMessage);
begin
  if Assigned(FTrayIcon) then FTrayIcon.Restore;
end;

//Desc: 任务栏日期,时间
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  sBar.Panels[cSBar_Date].Text := Format(sDate, [DateToStr(Now)]);
  sBar.Panels[cSBar_Time].Text := Format(sTime, [TimeToStr(Now)]);
end;

//Desc: 延时处理系统逻辑
procedure TfFormMain.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := (FTrayIcon = nil);
  //verify timer's valid

  if not Assigned(FTrayIcon) then
  begin
    if FindWindow('Shell_TrayWnd', nil) > 0 then
    begin
      FTrayIcon := TTrayIcon.Create(Self);
      FTrayIcon.Hint := gSysParam.FAppTitle;
      FTrayIcon.Visible := True;
    end;
  end;
end;

//Desc: 延时启动服务
procedure TfFormMain.Timer4Timer(Sender: TObject);
begin
  Timer4.Enabled := False;
  //once

  if gSysParam.FAutoMin and (not ROModule.IsServiceRun) then
  begin
    SysService.OnClick(nil);
    //try to start

    {$IFNDEF DEBUG}
    if ROModule.IsServiceRun then
      PostMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
    //xxxxx
    {$ENDIF}
  end;
end;

//Desc: 延时退出管理员状态
procedure TfFormMain.Timer3Timer(Sender: TObject);
begin
  Timer3.Tag := Timer3.Tag - 1;
  if Timer3.Tag > 0 then
  begin
    LabelAdmin.Caption := Format('管理状态: %d ', [Timer3.Tag]);
  end else
  begin
    Timer3.Enabled := False;
    LabelAdmin.Caption := '管理员登录 ';
    LabelAdmin.Hint := '点击进入管理状态';

    gSysParam.FIsAdmin := False;
    PostMessage(Handle, PM_RefreshMenu, PM_RM_OnlyStatus, 0);
    BroadcastFrameCommand(nil, cCmd_AdminChanged);
  end;  
end;

//Desc: 管理员登录
procedure TfFormMain.LabelAdminClick(Sender: TObject);
var nStr: string;
begin
  if Timer3.Tag > 0 then
  begin
    LabelAdmin.Caption := '';
    Timer3.Tag := 0;
    Exit;
  end;

  while ShowInputPWDBox('请输入管理员密码:', '登录', nStr) do
  begin
    if nStr = gSysParam.FAdminPwd then
    begin
      Timer3.Tag := gSysParam.FAdminKeep;
      Timer3.Enabled := True;

      LabelAdmin.Caption := '';
      LabelAdmin.Hint := '点击注销管理员';

      gSysParam.FIsAdmin := True;
      PostMessage(Handle, PM_RefreshMenu, PM_RM_OnlyStatus, 0);
      BroadcastFrameCommand(nil, cCmd_AdminChanged);
      
      ShowMsg('管理员登录成功', sHint);
      Break;
    end else ShowMsg('密码错误,请新输入', sHint);
  end;
end;

//Desc: 标准菜单动作
procedure TfFormMain.SysSummaryClick(Sender: TObject);
begin
  LockWindowUpdate(PanelWork.Handle);
  try
    if Sender = SysSummary then
      CreateBaseFrameItem(cFI_FrameSummary, PanelWork) else
    if Sender = SysRunlog then
      CreateBaseFrameItem(cFI_FrameRunlog, PanelWork) else
    if Sender = SysConfig then
      CreateBaseFrameItem(cFI_FrameConfig, PanelWork) else
    if Sender = SysRunParam then
      CreateBaseFrameItem(cFI_FrameParam, PanelWork) else
    if Sender = SysPlugs then
      CreateBaseFrameItem(cFI_FramePlugs, PanelWork) else
    if Sender = SysStatus then
      CreateBaseFrameItem(cFI_FrameStatus, PanelWork);
  finally
    LockWindowUpdate(0);
  end;
end;

//Desc: 启动服务
procedure TfFormMain.SysServiceClick(Sender: TObject);
var nStr: string;
begin
  if ROModule.ActiveServer([stHttp], not ROModule.IsServiceRun, nStr) then
       PostMessage(Handle, PM_RefreshMenu, PM_RM_OnlyStatus, 0)
  else ShowMsg('服务启动失败', '请查阅日志');
end;

//Desc: 刷新菜单
procedure TfFormMain.PMRefreshMenu(var nMsg: TMessage);
var nIdx: Integer;
    nItem: TdxNavBarItem;
    nMenus: TPlugMenuItems;
begin
  if csDestroying in ComponentState then Exit;
  //filter

  with dxNavBar1 do
   for nIdx:=Groups.Count - 1 downto 0 do
    Groups[nIdx].LargeImageIndex := FDM.IconIndex(Groups[nIdx].Name);
  //image index

  for nIdx:=dxNavBar1.Items.Count - 1 downto 0 do
  begin
    if (nMsg.WParam = PM_RM_FullStatus) and
       Assigned(BarGroup3.FindLink(dxNavBar1.Items[nIdx])) then
    begin
      BarGroup3.RemoveLinks(dxNavBar1.Items[nIdx]);
      dxNavBar1.Items.Delete(nIdx);
    end else

    with dxNavBar1 do
    begin
      if Items[nIdx] = SysService then
      begin
        Items[nIdx].Enabled := gSysParam.FIsAdmin;
        //xxxxx
        
        if ROModule.IsServiceRun then
             Items[nIdx].Caption := '停止服务'
        else Items[nIdx].Caption := '启动服务';
      end;

      Items[nIdx].SmallImageIndex := FDM.IconIndex(Items[nIdx].Name);
      //update icon
    end;
  end;

  if nMsg.WParam <> PM_RM_FullStatus then Exit;
  SetLength(nMenus, 0);
  nMenus := gPlugManager.GetMenuItems(True);
  
  for nIdx:=Low(nMenus) to High(nMenus) do
  begin
    nItem := dxNavBar1.Items.Add;

    with nItem,nMenus[nIdx] do
    begin
      Name := FName;
      Caption := FCaption;
      Tag := FFormID;

      OnClick := DoMenuClick;
      SmallImageIndex := FDM.IconIndex(FName);
      BarGroup3.CreateLink(nItem);

      if FDefault then
        DoMenuClick(nItem);
      //click
    end;
  end;
end;

//Desc: 扩展菜单动作
procedure TfFormMain.DoMenuClick(Sender: TObject);
var nStr: string;
begin
  nStr := BoolToStr(gSysParam.FIsAdmin, True);
  CreateBaseFormItem(TdxNavBarItem(Sender).Tag, nStr);
end;

end.
