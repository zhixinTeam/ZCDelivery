{*******************************************************************************
  作者: dmzn@163.com 2012-5-3
  描述: 数据模块
*******************************************************************************}
unit UDataModule;

interface

uses
  Windows, Graphics, SysUtils, Classes, dxPSGlbl, dxPSUtl, dxPSEngn,
  dxPrnPg, ULibFun, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, cxLookAndFeels, dxPSCore, dxPScxCommon, dxPScxGrid6Lnk,
  XPMan, dxLayoutLookAndFeels, cxEdit, ImgList, Controls, cxGraphics, DB,
  ADODB, dxBkgnd;

type
  TFDM = class(TDataModule)
    ADOConn: TADOConnection;
    SQLQuery1: TADOQuery;
    SqlTemp: TADOQuery;
    SqlQuery: TADOQuery;
    Command: TADOQuery;
    dxPrinter1: TdxComponentPrinter;
    dxGridLink1: TdxGridReportLink;
  private
    { Private declarations }
    function CheckQueryConnection(const nQuery: TADOQuery;
     const nUseBackdb: Boolean): Boolean;
  public
    { Public declarations }
    //查询数据库
    function QueryTemp(const nSQL:string;const nUseBackdb: Boolean = False):TDataSet;
    function ExecuteSQL(const nSQL: string; const nUseBackdb: Boolean = False): integer;
    function GetFieldMax(const nTable,nField: string): integer;
    function SaveDBImage(const nDS: TDataSet; const nFieldName: string;
      const nImage: string): Boolean; overload;
    function SaveDBImage(const nDS: TDataSet; const nFieldName: string;
      const nImage: TGraphic): Boolean; overload;
    procedure FillStringsData(const nList: TStrings; const nSQL: string;
      const nFieldLen: integer = 0; const nFieldFlag: string = '';
      const nExclude: TDynamicStrArray = nil);
    function GetSerialID2(const nPrefix,nTable,nKey,nField: string;
     const nFixID: Integer; const nIncLen: Integer = 3): string;
    function SQLServerNow: string;
    function QuerySQL(const nSQL: string; const nUseBackdb: Boolean = False): TDataSet;
    procedure QueryData(const nQuery: TADOQuery; const nSQL: string;
     const nUseBackdb: Boolean = False);
  end;

var
  FDM: TFDM;

implementation
uses
  UFormCtrl,USysLoger;
{$R *.dfm}

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TFDM, '数据模块', nEvent);
end;

//Date: 2012-5-3
//Parm: SQL;是否保持连接
//Desc: 执行SQL数据库查询
function TFDM.CheckQueryConnection(const nQuery: TADOQuery;
  const nUseBackdb: Boolean): Boolean;
var nBackDBEnabled: Boolean;
begin
  {$IFDEF EnableDoubleDB}
  nBackDBEnabled := True;
  {$ELSE}
  nBackDBEnabled := False;
  {$ENDIF}

  Result := False;
  if not (nUseBackdb and nBackDBEnabled) then
  begin
    if not ADOConn.Connected then
      ADOConn.Connected := True;
    Result := ADOConn.Connected;

    if not Result then
      raise Exception.Create('数据库连接已断开,且重新连接失败.');
    //xxxxx

    if nQuery.Connection <> ADOConn then
    begin
      nQuery.Close;
      nQuery.Connection := ADOConn;
    end;
  end;
  
  {$IFDEF EnableBackupDB}
  if not nUseBackdb then Exit;
  if (not nBackDBEnabled) and (IsEnableBackupDB <> gSysParam.FUsesBackDB) then
    raise Exception.Create('数据库服务异常,请重新登录系统.');
  //xxxxx

  if gSysParam.FUsesBackDB then
  begin
    if not Conn_Bak.Connected then
      Conn_Bak.Connected := True;
    Result := Conn_Bak.Connected;

    if not Result then
      raise Exception.Create('数据库连接已断开,且重新连接失败.');
    //xxxxx

    if nQuery.Connection <> Conn_Bak then
    begin
      nQuery.Close;
      nQuery.Connection := Conn_Bak;
    end;
  end;
  {$ENDIF}
end;

function TFDM.ExecuteSQL(const nSQL: string;
  const nUseBackdb: Boolean): integer;
var nStep: Integer;
    nException: string;
begin
  Result := -1;
  if not CheckQueryConnection(Command, nUseBackdb) then Exit;

  nException := '';
  nStep := 0;
  
  while nStep <= 2 do
  try
    if nStep = 1 then
    begin
      SqlTemp.Close;
      SqlTemp.Connection := Command.Connection;
      SqlTemp.SQL.Text := 'select 1';
      SqlTemp.Open;

      SqlTemp.Close;
      Break;
      //connection is ok
    end else

    if nStep = 2 then
    begin
      Command.Connection.Close;
      Command.Connection.Open;
    end; //reconnnect

    Command.Close;
    Command.SQL.Text := nSQL;
    Result := Command.ExecSQL;

    nException := '';
    Break;
  except
    on E:Exception do
    begin
      Inc(nStep);
      nException := E.Message;
      WriteLog(nException);
    end;
  end;

  if nException <> '' then
    raise Exception.Create(nException);
  //xxxxx
end;

procedure TFDM.FillStringsData(const nList: TStrings; const nSQL: string;
  const nFieldLen: integer; const nFieldFlag: string;
  const nExclude: TDynamicStrArray);
var nPos: integer;
    nStr,nPrefix: string;
begin
  nList.Clear;
  try
    nStr := nSQL;
    nPos := Pos('=', nSQL);

    if nPos > 1 then
    begin
      nPrefix := Copy(nSQL, 1, nPos - 1);
      System.Delete(nStr, 1, nPos);
    end else
    begin
      nPrefix := '';
    end;

    LoadDataToList(QueryTemp(nStr), nList, nPrefix, nFieldLen,
                                    nFieldFlag, nExclude);
  except
  end;
end;

function TFDM.GetFieldMax(const nTable, nField: string): integer;
begin
//
end;

function TFDM.GetSerialID2(const nPrefix, nTable, nKey, nField: string;
  const nFixID, nIncLen: Integer): string;
begin
//
end;

procedure TFDM.QueryData(const nQuery: TADOQuery; const nSQL: string;
  const nUseBackdb: Boolean);
begin
//
end;

function TFDM.QuerySQL(const nSQL: string;
  const nUseBackdb: Boolean): TDataSet;
var nInt: Integer;
begin
  Result := nil;
  nInt := 0;

  while nInt < 2 do
  try
    if not ADOConn.Connected then
      ADOConn.Connected := True;
    //xxxxx

    SQLQuery1.Close;
    SQLQuery1.SQL.Text := nSQL;
    SQLQuery1.Open;

    Result := SQLQuery1;
    Exit;
  except
    ADOConn.Connected := False;
    Inc(nInt);
  end;
end;

function TFDM.QueryTemp(const nSQL:string;const nUseBackdb: Boolean): TDataSet;
var nStep: Integer;
    nException: string;
begin
  Result := nil;
  if not CheckQueryConnection(SQLTemp, nUseBackdb) then Exit;

  nException := '';
  nStep := 0;

  while nStep <= 2 do
  try
    if nStep = 1 then
    begin
      SQLTemp.Close;
      SQLTemp.SQL.Text := 'select 1';
      SQLTemp.Open;

      SQLTemp.Close;
      Break;
      //connection is ok
    end else

    if nStep = 2 then
    begin
      SQLTemp.Connection.Close;
      SQLTemp.Connection.Open;
    end; //reconnnect

    SQLTemp.Close;
    SQLTemp.SQL.Text := nSQL;
    SQLTemp.Open;

    Result := SQLTemp;
    nException := '';
    Break;
  except
    on E:Exception do
    begin
      Inc(nStep);
      nException := E.Message;
      WriteLog(nException);
    end;
  end;

  if nException <> '' then
    raise Exception.Create(nException);
  //xxxxx
end;

function TFDM.SaveDBImage(const nDS: TDataSet; const nFieldName,
  nImage: string): Boolean;
begin
//
end;

function TFDM.SaveDBImage(const nDS: TDataSet; const nFieldName: string;
  const nImage: TGraphic): Boolean;
begin
//
end;

function TFDM.SQLServerNow: string;
begin
//
end;

end.
