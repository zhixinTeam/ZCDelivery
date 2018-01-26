{*******************************************************************************
  作者: dmzn@163.com 2008-8-6
  描述: 统主单元,负责其它模块的调用
*******************************************************************************}
unit UFormMain;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrMenu, UTrayIcon, UDataModule, USysFun, UFrameBase, cxGraphics,
  cxControls, cxLookAndFeelPainters, ExtCtrls, Menus,
  UBitmapPanel, cxPC, cxClasses, dxNavBarBase, dxNavBarCollns, dxNavBar,
  cxSplitter, ComCtrls, StdCtrls, cxLookAndFeels;

type
  TfMainForm = class(TForm)
    MainMenu1: TMainMenu;
    HintPanel: TPanel;
    sBar: TStatusBar;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    Timer1: TTimer;
    N1: TMenuItem;
    Splitter1: TcxSplitter;
    NavBar1: TdxNavBar;
    BarGroup1: TdxNavBarGroup;
    BarGroup2: TdxNavBarGroup;
    wPage: TcxPageControl;
    Sheet1: TcxTabSheet;
    PanelBG: TZnBitmapPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure wPagePageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure wPageChange(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*状态栏图标*}
  protected
    { Protected declarations }
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
    procedure SetHintText(const nLabel: TLabel);
    {*提示信息*}
    procedure DoMenuClick(Sender: TObject);
    {*菜单事件*}
    procedure BuildNavBarItems;
    procedure LinkIntoRecentMenu(const nMenuID: string);
    procedure AddNavBarItem(nGroup: TdxNavBarGroup; nMenu: PMenuItemData);
    procedure AddNavBarItems(nGroup: TdxNavBarGroup; const nMenu: string);
    {*导航信息*}
    procedure WMFrameChange(var nMsg: TMessage); message WM_FrameChange;
    procedure DoFrameChange(const nName: string; const nCtrl: TWinControl;
      const nState: TControlChangeState);
    {*组件变动*}
  public
    { Public declarations }
  end;

var
  fMainForm: TfMainForm;

implementation

{$R *.dfm}

uses
  ShellAPI, IniFiles, UcxChinese, ULibFun, UMgrControl, UMgrIni,
  USysLoger, USysDB, USysConst, USysModule, USysMenu, USysPopedom,
  UFormWait, UFormLogin, UFormBase;

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfMainForm, '系统主模块', nEvent);
end;

//------------------------------------------------------------------------------
//Date: 2007-10-15
//Parm: 标签
//Desc: 在nLabel上显示提示信息
procedure TfMainForm.SetHintText(const nLabel: TLabel);
begin
  nLabel.Font.Color := clWhite;
  nLabel.Font.Size := 12;
  nLabel.Font.Style := nLabel.Font.Style + [fsBold];

  nLabel.Caption := gSysParam.FHintText;
  nLabel.Left := 8;
  nLabel.Top := (HintPanel.Height + nLabel.Height - 12) div 2;
end;

//Desc: 载入窗体配置
procedure TfMainForm.FormLoadConfig;
var nStr: string;
    nIni: TIniFile;
begin
  HintPanel.DoubleBuffered := True;
  gStatusBar := sBar;
  nStr := Format(sDate, [DateToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Date);

  nStr := Format(sTime, [TimeToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Time);

  nStr := Format(sUser, [gSysParam.FUserName]);
  StatusBarMsg(nStr, cSBar_User);

  SetHintText(HintLabel);
  SetFrameChangeEvent(DoFrameChange);
  PostMessage(Handle, WM_FrameChange, 0, 0);
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    nStr := nIni.ReadString(Name, 'NavBar', '');
    if IsNumber(nStr, False) then NavBar1.Width := StrToInt(nStr);

    nStr := nIni.ReadString(Name, 'BgImage', gPath + sImageDir + 'bg.bmp');
    nStr := ReplaceGlobalPath(nStr);
    if FileExists(nStr) then PanelBG.LoadBitmap(nStr);
  finally
    nIni.Free;
  end;
end;

//Desc: 保存窗体配置
procedure TfMainForm.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    if Splitter1.State = ssClosed then
      Splitter1.State := ssOpened;
    Application.ProcessMessages;

    SaveFormConfig(Self, nIni);
    nIni.WriteInteger(Name, 'NavBar', NavBar1.Width);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 创建
procedure TfMainForm.FormCreate(Sender: TObject);
var nStr: string;
begin
  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig, gPath + sDBConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  InitSystemObject;
  //系统对象

  if ShowLoginForm then
  begin
    FDM.LoadSystemIcons(gSysParam.FIconFile);
    //载入图标
    gMenuManager.BuildMenu(MainMenu1, sEntity_MenuMain, DoMenuClick);
    //载入主菜单
    BuildNavBarItems;
    //载入导航栏
    FormLoadConfig;
    //载入配置

    FTrayIcon := TTrayIcon.Create(Self);
    FTrayIcon.Visible := True;
    {$IFDEF AppAtTaskBar}
    FTrayIcon.Hide := False;
    {$ENDIF}

    RunSystemObject;
    //run them
    WriteLog('系统启动');
  end else
  begin
    FreeSystemObject;
    ShowWindow(Handle, SW_MINIMIZE);

    Application.ProcessMessages;
    Application.Terminate; Exit;
  end;
end;

//Desc: 释放
procedure TfMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFNDEF debug}
  if not QueryDlg(sCloseQuery, sHint) then
  begin
    Action := caNone; Exit;
  end;
  {$ENDIF}

  ShowWaitForm(Self, '正在退出系统', True);
  try
    FormSaveConfig;          //窗体配置

    WriteLog('系统关闭');
    {$IFNDEF debug}
    Sleep(2200);
    {$ENDIF}
    FreeSystemObject;        //系统对象
  finally
    CloseWaitForm;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 展开收起导航栏
procedure TfMainForm.Image1DblClick(Sender: TObject);
begin
  if Splitter1.State = ssOpened then
       Splitter1.State := ssClosed
  else Splitter1.State := ssOpened;
end;

//Desc: 任务栏日期,时间
procedure TfMainForm.Timer1Timer(Sender: TObject);
begin
  sBar.Panels[cSBar_Date].Text := Format(sDate, [DateToStr(Now)]);
  sBar.Panels[cSBar_Time].Text := Format(sTime, [TimeToStr(Now)]);
end;

//Date: 2009-5-26
//Parm: 分组;菜单项
//Desc: 在导航栏nGroup分组上添加nMenu菜单项的对应按钮
procedure TfMainForm.AddNavBarItem(nGroup: TdxNavBarGroup; nMenu: PMenuItemData);
var nStr: string;
    nObj: TObject;
    nItem: TdxNavBarItem;
begin
  nStr := gMenuManager.MenuName(nMenu.FEntity, nMenu.FMenuID);
  if not gPopedomManager.HasPopedom(nStr, sPopedom_Read) then Exit;

  nObj := NavBar1.Items.ItemByName(nStr);
  if nObj is TdxNavBarItem then
  begin
    nItem := nObj as TdxNavBarItem;
  end else
  begin
    nItem := NavBar1.Items.Add;
    nItem.Name := nStr;
    nItem.Caption := nMenu.FTitle;
    nItem.OnClick := DoMenuClick;
    nItem.SmallImageIndex := FDM.IconIndex(nStr);
  end;

  nGroup.CreateLink(nItem);
end;

//Date: 2009-5-27
//Parm: 分组;菜单名称
//Desc: 将nMenu子菜单中需要显示在导航栏的项添加到nGroup中
procedure TfMainForm.AddNavBarItems(nGroup: TdxNavBarGroup;
  const nMenu: string);
var nStr: string;
    nList: TList;
    i,nCount: integer;
    nData: PMenuItemData;
begin
  nList := TList.Create;
  try
    if not gMenuManager.BuildMenuItemList(nMenu, nList) then Exit;
    nCount := nList.Count - 1;

    for i:=0 to nCount do
    begin
      nData := nList[i];
      nStr := gMenuManager.MenuName(nData.FEntity, nData.FMenuID);
      
      if (Pos(cMenuFlag_NB, nData.FFlag) < 1) and
         gPopedomManager.HasPopedom(nStr, sPopedom_Read) then AddNavBarItem(nGroup, nData);
      //显示在导航栏,且有浏览权限
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 处理导航栏
procedure TfMainForm.BuildNavBarItems;
var nStr: string;
    nList: TList;
    i,nCount: integer;
    nData: PMenuItemData;
    nGroup: TdxNavBarGroup;
begin
  nList := TList.Create;
  try
    NavBar1.Items.Clear;
    //clear all items

    nCount := NavBar1.Groups.Count - 1;
    while nCount > 0 do
    begin
      if (nCount <> BarGroup1.Index) and (nCount <> BarGroup2.Index) then
        NavBar1.Groups.Delete(nCount);
      Dec(nCount);
    end;
    //clear all groups

    if gMenuManager.BuildMenuItemList(nList) then
    begin
      nCount := nList.Count - 1;

      for i:=0 to nCount do
      begin
        nData := PMenuItemData(nList[i]);
        if Pos(cMenuFlag_UF, nData.FFlag) > 0 then
          AddNavBarItem(BarGroup1, nData);
        //xxxxx
      end;
    end;
    //usually function

    BarGroup1.LargeImageIndex := FDM.IconIndex('BarGroup1');
    BarGroup2.LargeImageIndex := FDM.IconIndex('BarGroup2');
    //group icon

    if gMenuManager.GetMenuList(nList, sEntity_MenuMain) then
    begin
      nCount := nList.Count - 1;
      for i:=0 to nCount do
      begin
        nData := nList[i];
        nStr := gMenuManager.MenuName(nData.FEntity, nData.FMenuID);

        if Pos(cMenuFlag_NB, nData.FFlag) > 0 then Continue;  
        if not gPopedomManager.HasPopedom(nStr, sPopedom_Read) then Continue;

        nGroup := NavBar1.Groups.Add;
        nGroup.Name := nStr;
        nGroup.Caption := nData.FTitle;

        nGroup.Expanded := False;
        nGroup.UseSmallImages := False;
        nGroup.LargeImageIndex := FDM.IconIndex(nStr);

        AddNavBarItems(nGroup, nData.FMenuID);
        //添加子项
      end;
    end;
    //menu items
  finally
    nList.Free;
  end;
end;

//Desc: 将nMenu添加到"最近使用"导航区
procedure TfMainForm.LinkIntoRecentMenu(const nMenuID: string);
var nItem: TObject;
    nStr,nEntity: string;
    nData: PMenuItemData;
    i,nCount,nPos: integer;
begin
  nCount := BarGroup2.LinkCount - 1;
  for i:=0 to nCount do
  if BarGroup2.Links[i].Item.Name = nMenuID then
  begin
    BarGroup2.Links[i].Index := 0; Exit;
  end;

  nPos := Pos(cMenuFlag_NSS, nMenuID);
  nEntity := Copy(nMenuID, 1, nPos - 1);

  nStr := nMenuID;
  System.Delete(nStr, 1, nPos + Length(cMenuFlag_NSS) - 1);

  nData := gMenuManager.GetMenuItem(nEntity, nStr);
  if not Assigned(nData) then Exit;

  if (Pos(cMenuFlag_UF, nData.FFlag) > 0) or
     (Pos(cMenuFlag_NR, nData.FFlag) > 0) then Exit;
  //在"常用功能"区,或不使用"最近"导航

  if BarGroup2.LinkCount >= gSysParam.FRecMenuMax then
  begin
    nPos := BarGroup2.LinkCount - 1;
    BarGroup2.RemoveLink(nPos);
  end;
  //删除过旧导航项

  AddNavBarItem(BarGroup2, nData);
  nStr := gMenuManager.MenuName(nData.FEntity, nData.FMenuID);
  nItem := NavBar1.Items.ItemByName(nStr);

  if Assigned(nItem) and (nItem is TdxNavBarItem) then
  begin
    nItem := BarGroup2.FindLink(TdxNavBarItem(nItem));
    if Assigned(nItem) and (nItem is TdxNavBarItemLink) then
      TdxNavBarItemLink(nItem).Index := 0;
  end;
end;

//Desc: 执行nMenuID指定的动作
procedure DoFixedMenuActive(const nMenuID: string);
var nPos: integer;
    nStr,nEntity: string;
    nData: PMenuItemData;
begin
  nPos := Pos(cMenuFlag_NSS, nMenuID);
  nEntity := Copy(nMenuID, 1, nPos - 1);

  nStr := nMenuID;
  System.Delete(nStr, 1, nPos + Length(cMenuFlag_NSS) - 1);

  nData := gMenuManager.GetMenuItem(nEntity, nStr);
  if not Assigned(nData) then Exit;

  if Pos(cMenuFlag_Open, nData.FFlag) > 0 then
  begin
    nStr := StringReplace(nData.FAction, '$Path\', gPath, [rfIgnoreCase]);
    ShellExecute(GetDesktopWindow, nil, PChar(nStr), nil, nil, SW_SHOWNORMAL);
  end;
end;

//Desc: 获取nMenu对应的模块索引
function GetMenuModuleIndex(const nMenu: string; var nIdx: integer): Boolean;
var i,nCount: integer;
    nP: PMenuModuleItem;
begin
  Result := False;
  nCount := gMenuModule.Count - 1;

  for i:=0 to nCount do
  begin
    nP := gMenuModule[i];

    if CompareText(nMenu, nP.FMenuID) = 0 then
    begin
      nIdx := i;
      Result := True; Break;
    end;
  end;
end;

//Date: 2014-06-26
//Parm: 标识；多页签；是否创建
//Desc: 检索nPage中标识为nTag的页面，不存在则创建
function GetSheet(const nTag: Integer; const nPage: TcxPageControl;
  const nNew: Boolean = True): TcxTabSheet;
var nIdx: Integer;
begin
  Result := nil;

  for nIdx:=nPage.PageCount - 1 downto 0 do
  if nPage.Pages[nIdx].Tag = nTag then
  begin
    Result := nPage.Pages[nIdx];
    Exit;
  end;

  if not nNew then Exit;
  Result := TcxTabSheet.Create(nPage);
  //new item

  with Result do
  begin
    Tag := nTag;
    PageControl := nPage;
  end;
end;

//Desc: 处理菜单
procedure TfMainForm.DoMenuClick(Sender: TObject);
var nPos: integer;
    nFull,nName: string;
    nP: PMenuModuleItem;
begin
  if Sender is TComponent then
       nFull := TComponent(Sender).Name
  else Exit;

  if Sender is TMenuItem then
  begin
    if TMenuItem(Sender).Count > 0 then
         Exit
    else LinkIntoRecentMenu(nFull);
  end else

  if Sender is TdxNavBarItem then
  begin
    if not (Assigned(NavBar1.HotTrackedLink) and
      (NavBar1.HotTrackedLink.Group = BarGroup2)) then LinkIntoRecentMenu(nFull);
    //xxxxx
  end else Exit;

  nName := nFull;
  nPos := Pos(cMenuFlag_NSS, nName);
  System.Delete(nName, 1, nPos + Length(cMenuFlag_NSS) - 1);

  //----------------------------------------------------------------------------
  if nName = sMenuItem_ReLoad then //重新登陆
  begin
    if not ShowLoginForm then Exit;
    nName := Format(sUser, [gSysParam.FUserName]);
    StatusBarMsg(nName, cSBar_User);

    gControlManager.FreeAllCtrl;
    gMenuManager.BuildMenu(MainMenu1, sEntity_MenuMain, DoMenuClick);
    BuildNavBarItems;
  end else

  if nName = sMenuItem_Close then //退出系统
  begin
    Close;
  end else

  if GetMenuModuleIndex(nFull, nPos) then
  begin
    nP := gMenuModule[nPos];
    //模块映射项

    if nP.FItemType = mtForm then
         CreateBaseFormItem(nP.FModule, nFull)
    else CreateBaseFrameItem(nP.FModule, GetSheet(nP.FModule, wPage), nFull);
  end else DoFixedMenuActive(nFull);
end;

//------------------------------------------------------------------------------
//Desc: 增减Frame
procedure TfMainForm.DoFrameChange(const nName: string;
  const nCtrl: TWinControl; const nState: TControlChangeState);
var nStr: string;
    nInt: Integer;
    nSheet: TcxTabSheet;
begin
  if csDestroying in ComponentState then Exit;
  //主窗口退出时不处理

  if nCtrl is TBaseFrame then
       nInt := (nCtrl as TBaseFrame).FrameID
  else Exit;

  nSheet := GetSheet(nInt, wPage, False);
  if not Assigned(nSheet) then Exit;

  if nState = fsNew then
  begin
    nSheet.Caption := '启动中...';
  end;

  if nState = fsActive then
  begin
    if nSheet.Caption <> nName then
    begin
      nSheet.Caption := nName;
      nStr := TBaseFrame(nCtrl).PopedomItem;
      nSheet.ImageIndex := FDM.IconIndex(nStr);
    end;
    
    wPage.ActivePage := nSheet;
    //active
    Exit;
  end;

  if nState = fsFree then
  begin
    //nothing
  end;

  PostMessage(Handle, WM_FrameChange, 0, 0);
  //update tab status
end;

//Desc: 依据状态设置Page风格
procedure TfMainForm.WMFrameChange(var nMsg: TMessage);
var nIdx: Integer;
begin
  for nIdx:=wPage.PageCount - 1 downto 0 do
   if wPage.Pages[nIdx].ControlCount < 1 then
    wPage.Pages[nIdx].Free;
  //xxxxx

  if wPage.PageCount > 1 then
  begin
    Sheet1.TabVisible := False;
    wPage.ShowFrame := True;
  end else
  begin
    Sheet1.TabVisible  := False;
    wPage.ShowFrame := False;
    wPage.ActivePage := Sheet1;
  end;
end;

//Desc：避免切换闪烁
procedure TfMainForm.wPagePageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  LockWindowUpdate(Handle);
end;

procedure TfMainForm.wPageChange(Sender: TObject);
begin
  LockWindowUpdate(0);
end;

end.
