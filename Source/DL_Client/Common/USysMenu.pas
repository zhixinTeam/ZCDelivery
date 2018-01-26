unit USysMenu;

interface

uses
  Windows, Classes, DB, Menus, SysUtils, UDataModule, UMgrMenu, USysDB,
  USysConst, USysPopedom;

type
  TSysMenuManager = class(TBaseMenuManager)
  protected
    function QuerySQL(const nSQL: string;
      var nDS: TDataSet; var nAutoFree: Boolean): Boolean; override;
    function ExecSQL(const nSQL: string): integer; override;

    function GetItemValue(const nItem: integer): string; override;
    function IsTableExists(const nTable: string): Boolean; override;
    {*基本方法*}
    procedure BuildSubMenu(const nMenu: TMenu; const nPItem: TMenuItem;
     const nSub: TList; const nEvent: TNotifyEvent);
    {*载入子菜单*}
    procedure EnumSubList(const nList,nSub: TList);
    {*枚举子菜单项*}
  public
    function BuildMenu(const nMenu: TMenu; const nEntity: string;
     const nEvent: TNotifyEvent): Boolean;
    {*载入指定菜单*}
    function BuildMenuItemList(const nMenuID: string;
      const nList: TList): Boolean; overload;
    function BuildMenuItemList(const nList: TList): Boolean; overload;
    {*获取菜单项列表*}

    function IsValidProgID: Boolean;
    {*当前标识是否有效*}
    function MenuName(const nEntity,nMenuID: string): string;
    {*构建菜单名*}
  end;

var
  gMenuManager: TSysMenuManager = nil;
  //全局菜单管理器

ResourceString
  //主菜单实体名
  sEntity_MenuMain   = 'MAIN';

  //重新登录
  sMenuItem_ReLoad   = 'SYSRELOAD';

  //关闭系统
  sMenuItem_Close    = 'SYSCLOSE';

  cMenuFlag_SS       = '|';        //分割符,Split Symbol
  cMenuFlag_NSS      = '_';        //分隔符,Name Split Symbol
  cMenuFlag_Open     = 'EX';       //Execute,执行命令
  
  cMenuFlag_UF       = 'UF';       //常用功能,usually function
  cMenuFlag_NB       = 'NB';       //不显示在导航栏上,No Navbar
  cMenuFlag_NR       = 'NR';       //不显示在最近使用导航区,NoRecent

implementation

function TSysMenuManager.ExecSQL(const nSQL: string): integer;
begin
  FDM.Command.Close;
  FDM.Command.SQL.Text := nSQL;
  Result := FDM.Command.ExecSQL;
end;

function TSysMenuManager.GetItemValue(const nItem: integer): string;
begin
  case nItem of
    cMenuTable_Menu: Result := sTable_Menu;
  end;
end;

function TSysMenuManager.IsTableExists(const nTable: string): Boolean;
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    FDM.ADOConn.GetTableNames(nList);
    Result := nList.IndexOf(nTable) > 0;
  finally
    nList.Free;
  end;
end;

function TSysMenuManager.QuerySQL(const nSQL: string; var nDS: TDataSet;
  var nAutoFree: Boolean): Boolean;
begin
  FDM.SqlTemp.Close;
  FDM.SqlTemp.SQL.Text := nSQL;
  FDM.SqlTemp.Open;

  nDS := FDM.SqlTemp;
  Result := FDM.SqlTemp.RecordCount > 0;
end;

//Date: 2008-09-18
//Desc: 判断当前程序标识是否合法
function TSysMenuManager.IsValidProgID: Boolean;
var nList: TList;
    i,nCount: integer;
    nItem: PMenuItemData;
begin
  Result := False;
  nList := Self.GetProgList;
  nCount := nList.Count - 1;

  for i:=0 to nCount do
  begin
    nItem := nList[i];
    if nItem.FProgID = gSysParam.FProgID then
    begin
      Result := True; Break;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2008-09-18
//Parm: 结果列表
//Desc: 枚举当前所有没有子菜单的菜单项,存入nList中
function TSysMenuManager.BuildMenuItemList(const nList: TList): Boolean;
begin
  Result := False;
  if Assigned(nList) then
  begin
    nList.Clear;
    EnumSubList(nList, TopMenus);
    Result := nList.Count > 0;
  end;
end;

//Date: 2009-5-26
//Parm: 菜单ID;结果列表
//Desc: 枚举nMenuID所有没有子菜单的菜单项,存入nList中
function TSysMenuManager.BuildMenuItemList(const nMenuID: string;
  const nList: TList): Boolean;
var nP: PMenuItemData;
begin
  Result := False;
  if Assigned(nList) then
  begin
    nList.Clear;
    nP := GetMenuItem(sEntity_MenuMain, nMenuID);
    
    if Assigned(nP) and Assigned(nP.FSubMenu) then
      EnumSubList(nList, nP.FSubMenu);
    Result := nList.Count > 0;
  end;
end;

//Date: 2007-11-26
//Parm: 结果列表;子菜单列表
//Desc: 将nSub子菜单中所有没有子菜单的项存入nList中
procedure TSysMenuManager.EnumSubList(const nList, nSub: TList);
var i,nCount: integer;
    nData: PMenuItemData;
begin
  nCount := nSub.Count - 1;
  for i:=0 to nCount do
  begin
    nData := nSub[i];
    if (nData.FMenuID = '') or (nData.FTitle = '-') then Continue;
    
    if Assigned(nData.FSubMenu) then
         EnumSubList(nList, nData.FSubMenu)
    else nList.Add(nData);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 构建实体nEntity中nMenuID菜单项的组建名称
function TSysMenuManager.MenuName(const nEntity, nMenuID: string): string;
begin
  Result := nEntity + cMenuFlag_NSS + nMenuID;
end;

//Date: 2008-09-18
//Parm: 主菜单;上级菜单;子菜单列表;事件
//Desc: 将nSub添加到nPItem,同时关联事件nEvent
procedure TSysMenuManager.BuildSubMenu(const nMenu: TMenu;
  const nPItem: TMenuItem; const nSub: TList; const nEvent: TNotifyEvent);
var nStr: string;
    nItem: TMenuItem;
    i,nCount: integer;
    nData: PMenuItemData;
begin
  nCount := nSub.Count  - 1;
  for i:=0 to nCount do
  begin
    nData := nSub[i];
    nStr := MenuName(nData.FEntity, nData.FMenuID);
    if nData.FTitle <> '-' then
      if not gPopedomManager.HasPopedom(nStr, sPopedom_Read) then Continue;

    nItem := TMenuItem.Create(nMenu);

    nItem.Name := nStr;
    nItem.OnClick := nEvent;
    nItem.Caption := nData.FTitle;

    nPItem.Add(nItem);
    if Assigned(nData.FSubMenu) then
      BuildSubMenu(nMenu, nItem, nData.FSubMenu, nEvent);
  end; 
end;

//Date: 2008-09-18
//Parm: 主菜单;实体标识;事件
//Desc: 将实体为nEntity的菜单项载入到nMenu上,同时关联事件nEvent
function TSysMenuManager.BuildMenu(const nMenu: TMenu;
  const nEntity: string; const nEvent: TNotifyEvent): Boolean;
var nStr: string;
    nList: TList;
    nItem: TMenuItem;
    i,nCount: integer;
    nData: PMenuItemData;
begin
  Result := False;
  nMenu.Items.Clear;
  nList := TList.Create;
  try
    if GetMenuList(nList, nEntity) then
    begin
      nCount := nList.Count - 1;
      for i:=0 to nCount do
      begin
        nData := nList[i];
        nStr := MenuName(nData.FEntity, nData.FMenuID);
        if nData.FTitle <> '-' then
          if not gPopedomManager.HasPopedom(nStr, sPopedom_Read) then Continue;

        nItem := TMenuItem.Create(nMenu);  
        nItem.Name := nStr;
        nItem.Caption := nData.FTitle;

        nItem.OnClick := nEvent;
        nItem.ImageIndex := nData.FImgIndex;
        nMenu.Items.Add(nItem);
        
        if Assigned(nData.FSubMenu) then
          BuildSubMenu(nMenu, nItem, nData.FSubMenu, nEvent);
      end;

      Result := True;
    end;
  finally
    nList.Free;
  end;
end;

initialization
  gMenuManager := TSysMenuManager.Create;
finalization
  FreeAndNil(gMenuManager);
end.
