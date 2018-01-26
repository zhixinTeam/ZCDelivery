{*******************************************************************************
  作者: dmzn@163.com 2008-1-3
  描述: 系统权限管理单元
*******************************************************************************}
unit USysPopedom;

{$I Link.inc}
interface

uses
  Windows, Classes, DB, SysUtils, ULibFun, UMgrPopedom, UDataModule,
  USysDB, USysConst;
  
type
  TPopedomManager = class(TBasePopedomManager)
  protected
    function QuerySQL(const nSQL: string;
      var nDS: TDataSet; var nAutoFree: Boolean): Boolean; override;
    function ExecSQL(const nSQL: string): integer; override;

    function GetItemValue(const nItem: integer): string; override;
    function IsTableExists(const nTable: string): Boolean; override;
  public
    function GetUserIdentity(const nUser: string): integer;
    {*用户身份*}
    function HasPopedom(const nItem,nPopedom: string): Boolean;
    {*可读取验证*}
  end;

var
  gPopedomManager: TPopedomManager = nil;
  //全局权限管理器

implementation

//------------------------------------------------------------------------------
//Desc: 执行SQL语句
function TPopedomManager.ExecSQL(const nSQL: string): integer;
begin
  with FDM do
  begin
    Command.Close;
    Command.SQL.Text := nSQL;
    Result := Command.ExecSQL;
  end;
end;

//Desc: 检测nTable表是否存在
function TPopedomManager.IsTableExists(const nTable: string): Boolean;
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

//Desc: 执行SQL查询
function TPopedomManager.QuerySQL(const nSQL: string; var nDS: TDataSet;
  var nAutoFree: Boolean): Boolean;
begin
  FDM.SqlTemp.Close;
  FDM.SqlTemp.SQL.Text := nSQL;
  FDM.SqlTemp.Open;

  nDS := FDM.SqlTemp;
  Result := FDM.SqlTemp.RecordCount > 0;
end;

//Desc: 获取nUser的身份(0,管理员)
function TPopedomManager.GetUserIdentity(const nUser: string): integer;
var nSQL: string;
begin
  nSQL := 'Select U_IDENTITY,U_STATE,U_GROUP From $a Where U_NAME=''$b''';
  nSQL := MacroValue(nSQL, [MI('$a', sTable_User), MI('$b',nUser)]);

  FDM.SqlQuery.Close;
  FDM.SqlQuery.SQL.Text := nSQL;
  FDM.SqlQuery.Open;

  if FDM.SqlQuery.RecordCount > 0 then
  with FDM.SqlQuery do
  begin
    Result := FieldByName('U_IDENTITY').AsInteger;
    gSysParam.FIsAdmin := Result = cPopedomUser_Admin;
    gSysParam.FGroupID := FieldByName('U_GROUP').AsString;
    gSysParam.FIsNormal := FieldByName('U_STATE').AsInteger = cPopedomUser_Normal;
  end else
  begin
    Result := cPopedomUser_User;
    gSysParam.FIsAdmin := False;
    gSysParam.FGroupID := '0';
    gSysParam.FIsNormal := False;
  end;
end;

function TPopedomManager.GetItemValue(const nItem: integer): string;
begin
  case nItem of
    cPopedomTable_User    : Result := sTable_User;
    cPopedomTable_Group   : Result := sTable_Group;
    cPopedomTable_Popedom : Result := sTable_Popedom;
    cPopedomTable_PopItem : Result := sTable_PopItem;
  end;
end;

//Desc: 验证当前用户对nItem是否有nPopedom权限
function TPopedomManager.HasPopedom(const nItem, nPopedom: string): Boolean;
begin
  if gSysParam.FIsAdmin then
       Result := True
  else Result := Pos(nPopedom, FindGroupPopedom(gSysParam.FGroupID, nItem)) > 0;
end;

initialization
  gPopedomManager := TPopedomManager.Create;
finalization
  FreeAndNil(gPopedomManager);
end.
