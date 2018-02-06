{*******************************************************************************
  作者: dmzn@163.com 2009-5-20
  描述: 数据库连接、操作相关 
*******************************************************************************}
unit UDataModule;

{$I Link.Inc}
interface

uses
  Windows, Graphics, SysUtils, Classes, dxPSGlbl, dxPSUtl, dxPSEngn,
  dxPrnPg, ULibFun, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, cxLookAndFeels, dxPSCore, dxPScxCommon, dxPScxGrid6Lnk,
  XPMan, dxLayoutLookAndFeels, cxEdit, ImgList, Controls, cxGraphics, DB,
  ADODB, dxBkgnd, cxDrawTextUtils,
  dxPSPrVwStd, dxPScxEditorProducers, dxPScxExtEditorProducers,
  dxPScxPageControlProducer;

type
  TFDM = class(TDataModule)
    ADOConn: TADOConnection;
    SqlQuery: TADOQuery;
    Command: TADOQuery;
    SqlTemp: TADOQuery;
    ImageBig: TcxImageList;
    Imagesmall: TcxImageList;
    edtStyle: TcxDefaultEditStyleController;
    dxLayout1: TdxLayoutLookAndFeelList;
    ImageMid: TcxImageList;
    XPM1: TXPManifest;
    dxLayoutWeb1: TdxLayoutWebLookAndFeel;
    ImageBar: TcxImageList;
    dxPrinter1: TdxComponentPrinter;
    dxGridLink1: TdxGridReportLink;
    cxLoF1: TcxLookAndFeelController;
    Conn_Bak: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    function CheckQueryConnection(const nQuery: TADOQuery;
     const nUseBackdb: Boolean): Boolean;
    {*连接有效性*}
  public
    { Public declarations }
    function IsEnableBackupDB: Boolean;
    {*备用库*}
    function QuerySQL(const nSQL: string; const nUseBackdb: Boolean = False): TDataSet;
    function QueryTemp(const nSQL: string; const nUseBackdb: Boolean = False): TDataSet;
    procedure QueryData(const nQuery: TADOQuery; const nSQL: string;
     const nUseBackdb: Boolean = False);
    {*查询操作*}
    function ExecuteSQL(const nSQL: string; const nUseBackdb: Boolean = False): integer;
    {*执行写操作*}
    function AdjustAllSystemTables: Boolean;
    {*校正系统表*}
    function IconIndex(const nName: string): integer;
    procedure LoadSystemIcons(const nIconFile: string);
    {*载入图标*}
    function WriteSysLog(const nGroup,nItem,nEvent: string;
     const nHint: Boolean = True; const nExec: Boolean = True;
     const nKeyID: string = ''; const nMan: string = ''): string;
    {*系统日志*}
    function SQLServerNow: string;
    function ServerNow: TDateTime;
    {*服务器时间*}
    function GetFieldMax(const nTable,nField: string): integer;
    {*字段最大值*}
    function GetRandomID(const nPrefix: string; const nIDLen: Integer): string;
    function GetSerialID(const nPrefix,nTable,nField: string;
     const nIncLen: Integer = 3): string;
    function GetSerialID2(const nPrefix,nTable,nKey,nField: string;
     const nFixID: Integer; const nIncLen: Integer = 3): string;
    function GetNeighborID(const nID: string;const nNext: Boolean;
     const nIncLen: Integer = 3): string;
    {*自动编号*}
    procedure FillStringsData(const nList: TStrings; const nSQL: string;
      const nFieldLen: integer = 0; const nFieldFlag: string = '';
      const nExclude: TDynamicStrArray = nil);
    {*填充数据*}
    function LoadDBImage(const nDS: TDataSet; const nFieldName: string;
      const nPicture: TPicture): Boolean;
    function SaveDBImage(const nDS: TDataSet; const nFieldName: string;
      const nImage: string): Boolean; overload;
    function SaveDBImage(const nDS: TDataSet; const nFieldName: string;
      const nImage: TGraphic): Boolean; overload;
    {*读写图片*}
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}
uses
  Variants, cxImageListEditor, UFormCtrl, UMgrIni, USysLoger, USysConst, USysDB
  {$IFDEF UseReport},UDataReport{$ENDIF};

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TFDM, '数据模块', nEvent);
end;

//------------------------------------------------------------------------------
//Date: 2009-5-27
//Parm: 图标配置文件
//Desc: 载入nIconFile对应的图标列表
procedure TFDM.LoadSystemIcons(const nIconFile: string);
var nStr,nPath: string;
    i,nCount: integer;
    nItem: PIniDataItem;
    nBig,nMid,nSmall: TStrings;
    nEditor: TcxImageListEditor;
begin
  if gIniManager.LoadIni(nIconFile) then
  begin
    ImageBig.Clear;
    ImageMid.Clear;
    ImageSmall.Clear;
  end else Exit;

  nPath := ExtractFilePath(nIconFile);
  nCount := gIniManager.Items.Count - 1;

  nEditor := nil;
  nBig := TStringList.Create;
  nMid := TStringList.Create;
  nSmall := TStringList.Create;
  try
    for i:=0 to nCount do
    begin
      nItem := gIniManager.Items[i];
      nStr := nPath + nItem.FKeyValue;

      if FileExists(nStr) then
       if CompareText(nItem.FSection, 'Large') = 0 then
         nItem.FExtValue := nBig.Add(nStr) else
       if CompareText(nItem.FSection, 'Middle') = 0 then
         nItem.FExtValue := nMid.Add(nStr) else
       if CompareText(nItem.FSection, 'Small') = 0 then
         nItem.FExtValue := nSmall.Add(nStr);
    end;

    if nBig.Count > 0 then
    begin
      {$IFDEF cxLibrary42}
        nEditor := TcxImageListEditor.Create;
      {$ELSE}
        nEditor := TcxImageListEditor.Create(Self);
      {$ENDIF}
      nEditor.ImageList := ImageBig;
      nEditor.AddImages(nBig, amAdd);
      nEditor.ApplyChanges;
      FreeAndNil(nEditor);
    end;

    if nMid.Count > 0 then
    begin
      {$IFDEF cxLibrary42}
        nEditor := TcxImageListEditor.Create;
      {$ELSE}
        nEditor := TcxImageListEditor.Create(Self);
      {$ENDIF}
      nEditor.ImageList := ImageMid;
      nEditor.AddImages(nMid, amAdd);
      nEditor.ApplyChanges;
      FreeAndNil(nEditor);
    end;
    
    if nSmall.Count > 0 then
    begin
      {$IFDEF cxLibrary42}
        nEditor := TcxImageListEditor.Create;
      {$ELSE}
        nEditor := TcxImageListEditor.Create(Self);
      {$ENDIF}
      nEditor.ImageList := ImageSmall;
      nEditor.AddImages(nSmall, amAdd);
      nEditor.ApplyChanges;
      FreeAndNil(nEditor);
    end;
  finally
    nBig.Free;
    nMid.Free;
    nSmall.Free;
    if Assigned(nEditor) then nEditor.Free;
  end;
end;

//Date: 2009-5-27
//Parm: 图标名称
//Desc: 获取nName图标的索引
function TFDM.IconIndex(const nName: string): integer;
var nItem: PIniDataItem;
begin
  nItem := gIniManager.FindItem(nName);
  if Assigned(nItem) and (not VarIsEmpty(nItem.FExtValue)) then
       Result := nItem.FExtValue
  else Result := -1;
end;

//Desc: 校正系统表,不存在则生成
function TFDM.AdjustAllSystemTables: Boolean;
var nStr: string;
    nList: TStrings;
    nP: PSysTableItem;
    i,nCount: integer;
begin
  nList := TStringList.Create;
  try
    FDM.ADOConn.GetTableNames(nList);
    nCount := gSysTableList.Count - 1;

    for i:=0 to nCount do
    begin
      nP := gSysTableList[i];
      if nList.IndexOf(nP.FTable) > -1 then Continue;

      if gSysDBType = dtAccess then
      begin
        nStr := MacroValue(nP.FNewSQL, [MI('$Inc', sField_Access_AutoInc),
                                        MI('$Float', sField_Access_Decimal),
                                        MI('$Image', sField_Access_Image)]);
      end else

      if gSysDBType = dtSQLServer then
      begin
        nStr := MacroValue(nP.FNewSQL, [MI('$Inc', sField_SQLServer_AutoInc),
                                        MI('$Float', sField_SQLServer_Decimal),
                                        MI('$Image', sField_SQLServer_Image)]);
      end;

      nStr := MacroValue(nStr, [MI('$Table', nP.FTable),
                                MI('$Integer', sFlag_Integer),
                                MI('$Decimal', sFlag_Decimal)]);
      FDM.ExecuteSQL(nStr);
    end;

    nList.Free;
    Result := True;
  except
    nList.Free;
    Result := False;
  end;
end;

//Date: 2009-6-8
//Parm: 信息分组;标识;事件;错误提示;执行;辅助标识;操作人
//Desc: 像系统日志表写入一条日志记录
function TFDM.WriteSysLog(const nGroup,nItem,nEvent: string;
 const nHint,nExec: Boolean; const nKeyID,nMan: string): string;
var nStr,nSQL: string;
begin
  nSQL := 'Insert Into $T(L_Date,L_Man,L_Group,L_ItemID,L_KeyID,L_Event) ' +
          'Values($D,''$M'',''$G'',''$I'',''$K'',''$E'')';
  nSQL := MacroValue(nSQL, [MI('$T', sTable_SysLog), MI('$D', SQLServerNow),
                            MI('$G', nGroup), MI('$I', nItem),
                            MI('$E', nEvent), MI('$K', nKeyID)]);

  if nMan = '' then
       nStr := gSysParam.FUserName
  else nStr := nMan;

  nSQL := MacroValue(nSQL, [MI('$M', nStr)]);
  Result := nSQL;

  if nExec then
  try
    ExecuteSQL(nSQL);
  except
    Result := '';
    if nHint then ShowMsg('系统日志写入错误', sHint);
  end;
end;

//Date: 2010-3-5
//Desc: sql语句中可用的服务器时间
function TFDM.SQLServerNow: string;
begin
  if gSysDBType = dtSQLServer then
       Result := sField_SQLServer_Now
  else Result := Format('''%s''', [DateTime2Str(Now)]);
end;

//Date: 2010-3-19
//Parm: 只取其日期
//Desc: 返回服务器的时间
function TFDM.ServerNow: TDateTime;
var nStr: string;
begin
  nStr := 'Select ' + sField_SQLServer_Now;
  Result := FDM.QueryTemp(nStr).Fields[0].AsDateTime;
end;

//Date: 2009-6-10
//Parm: 表名;字段
//Desc: 获取nTable.nField的最大值
function TFDM.GetFieldMax(const nTable, nField: string): integer;
var nStr: string;
begin
  nStr := 'Select Max(%s) From %s';
  nStr := Format(nStr, [nField, nTable]);

  with QueryTemp(nStr) do
  begin
    Result := Fields[0].AsInteger;
  end;
end;  

//Desc: 生成前缀为nPrefix,长度为nIDLen的随机编号
function TFDM.GetRandomID(const nPrefix: string; const nIDLen: Integer): string;
var nStr,nChar: string;
    nIdx,nMid: integer;
begin
  nStr := FloatToStr(Now);
  while Length(nStr) < nIDLen do
    nStr := nStr + FloatToStr(Now);
  //xxxxx

  nStr := StringReplace(nStr, '.', '0', [rfReplaceAll]);
  nMid := Trunc(Length(nStr) / 2);

  for nIdx:=1 to nMid do
  begin
    nChar := nStr[nIdx];
    nStr[nIdx] := nStr[2 * nMid - nIdx];
    nStr[2 * nMid - nIdx] := nChar[1];
  end;

  Result := nPrefix + Copy(nStr, 1, nIDLen - Length(nPrefix));
end;

//Date: 2009-8-30
//Parm: 前缀;表名;字段;自增连续编号长
//Desc: 生成前缀为nPrefix,以nTable.nField为参考的连续编号
function TFDM.GetSerialID(const nPrefix, nTable, nField: string;
 const nIncLen: Integer = 3): string;
var nStr,nTmp: string;
begin
  Result := '';
  try
    nStr := 'Select getDate()';
    nTmp := FormatDateTime('YYMMDD', QueryTemp(nStr).Fields[0].AsDateTime);

    nStr := 'Select Top 1 $F From $T Where $F Like ''$P$D%'' Order By $F DESC';
    nStr := MacroValue(nStr, [MI('$T', nTable), MI('$F', nField),
            MI('$D', nTmp), MI('$P', nPrefix)]);
    //xxxxx

    with QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nStr := Fields[0].AsString;
      nStr := Copy(nStr, Length(nStr) - nIncLen + 1, nIncLen);

      if IsNumber(nStr, False) then
           nStr := IntToStr(StrToInt(nStr) + 1)
      else nStr := '1';
    end else nStr := '1';

    nStr := StringOfChar('0', nIncLen - Length(nStr)) + nStr;
    Result := nPrefix + nTmp + nStr;
  except
    //ignor any error
  end;
end;

//Date: 2010-3-4
//Parm: 前缀;表名;自增主键;字段;主键序号;编号长
//Desc: 生成nFixID对应的以nPrefix为前缀,nTable.nField为参考的连续编号
function TFDM.GetSerialID2(const nPrefix, nTable, nKey, nField: string;
  const nFixID: Integer; const nIncLen: Integer): string;
var nInt: Integer;
    nStr,nTmp: string;
begin
  Result := '';
  try
    nStr := 'Select getDate()';
    nTmp := FormatDateTime('YYMMDD', QueryTemp(nStr).Fields[0].AsDateTime);

    nStr := 'Select Top 1 $K,$F From $T Where $F Like ''$P$D%'' Order By $F DESC';
    nStr := MacroValue(nStr, [MI('$T', nTable), MI('$F', nField),
            MI('$D', nTmp), MI('$K', nKey), MI('$P', nPrefix)]);
    //xxxxx

    with QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      if nFixID = Fields[0].AsInteger then
      begin
        Result := Fields[1].AsString; Exit;
      end;

      if nFixID < Fields[0].AsInteger then
      begin
        nStr := 'Select $F From $T Where $K=$ID';
        nStr := MacroValue(nStr, [MI('$F', nField), MI('$T', nTable),
                MI('$K', nKey), MI('$ID', IntToStr(nFixID))]);
        //xxxxx

        with FDM.QueryTemp(nStr) do
        if RecordCount > 0 then
          Result := Fields[0].AsString;
        Exit;
      end;

      nStr := Fields[1].AsString;
      System.Delete(nStr, 1, Length(nPrefix + nTmp));

      if IsNumber(nStr, False) then
      begin
        nInt := Fields[0].AsInteger - StrToInt(nStr);
        nStr := IntToStr(nFixID - nInt);
      end else nStr := '1';
    end else nStr := '1';

    nStr := StringOfChar('0', nIncLen - Length(nStr)) + nStr;
    Result := nPrefix + nTmp + nStr;
  except
    //ignor any error
  end;
end;

//Date: 2009-8-20
//Parm: 编号;是否下一个
//Desc: 生成与nID相邻的下一个或上一个编号
function TFDM.GetNeighborID(const nID: string;const nNext: Boolean;
 const nIncLen: Integer = 3): string;
var nStr: string;
    nLen: integer;
begin
  nLen := Length(nID);
  nStr := Copy(nID, nLen - nIncLen - 1, nIncLen);

  if IsNumber(nStr, False) then
  begin
    if nNext then
         nStr := IntToStr(StrToInt(nStr) + 1)
    else nStr := IntToStr(StrToInt(nStr) - 1);
  end else nStr := '1';

  nStr := StringOfChar('0', nIncLen - Length(nStr)) + nStr;
  Result := Copy(nID, 1, nLen - nIncLen) + nStr;
end;

//Date: 2009-6-12
//Parm: 待填充列表;SQL(Prefix=SQL);字段长;分隔符;排除字段
//Desc: 用nSQL查询的结果填充nList列表
procedure TFDM.FillStringsData(const nList: TStrings; const nSQL: string;
 const nFieldLen: integer = 0; const nFieldFlag: string = '';
 const nExclude: TDynamicStrArray = nil);
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
    //fill record into list
  except
    //ignor any error
  end;
end;

//------------------------------------------------------------------------------
//Date: 2009-7-4
//Parm: 数据集;字段名;图像数据
//Desc: 将nImage图像存入nDS.nField字段
function TFDM.SaveDBImage(const nDS: TDataSet; const nFieldName: string;
  const nImage: TGraphic): Boolean;
var nField: TField;
    nStream: TMemoryStream;
    nBuf: array[1..MAX_PATH] of Char;
begin
  Result := False;
  nField := nDS.FindField(nFieldName);
  if not (Assigned(nField) and (nField is TBlobField)) then Exit;

  nStream := nil;
  try
    if not Assigned(nImage) then
    begin
      nDS.Edit;
      TBlobField(nField).Clear;
      nDS.Post; Result := True; Exit;
    end;
    
    nStream := TMemoryStream.Create;
    nImage.SaveToStream(nStream);
    nStream.Seek(0, soFromEnd);

    FillChar(nBuf, MAX_PATH, #0);
    StrPCopy(@nBuf[1], nImage.ClassName);
    nStream.WriteBuffer(nBuf, MAX_PATH);

    nDS.Edit;
    nStream.Position := 0;
    TBlobField(nField).LoadFromStream(nStream);

    nDS.Post;
    FreeAndNil(nStream);
    Result := True;
  except
    if Assigned(nStream) then nStream.Free;
    if nDS.State = dsEdit then nDS.Cancel;
  end;
end;

//Date: 2009-6-14
//Parm: 数据集;字段;图片文件
//Desc: 将nImage文件存入nDS.nField字段
function TFDM.SaveDBImage(const nDS: TDataSet; const nFieldName: string;
 const nImage: string): Boolean;
var nPic: TPicture;
begin
  Result := False;
  if not FileExists(nImage) then Exit;

  nPic := nil;
  try
    nPic := TPicture.Create;
    nPic.LoadFromFile(nImage);

    SaveDBImage(nDS, nFieldName, nPic.Graphic);
    FreeAndNil(nPic);
  except
    if Assigned(nPic) then nPic.Free;
  end;
end;

//Date: 2009-6-14
//Parm: 数据集;字段;图像控件;临时路径
//Desc: 读取nDS.nField的图片数据,放入nPicture中
function TFDM.LoadDBImage(const nDS: TDataSet; const nFieldName: string;
  const nPicture: TPicture): Boolean;
var nField: TField;
    nStream: TMemoryStream;
    nBuf: array[1..MAX_PATH] of Char;
    nImage: TGraphic;
    nClass: TPersistentClass;
begin
  Result := False;
  nPicture.Graphic := nil;
  
  nField := nDS.FindField(nFieldName);
  if not (Assigned(nField) and (nField is TBlobField)) then Exit;

  nImage := nil;
  nStream := nil;
  try
    nStream := TMemoryStream.Create;
    TBlobField(nField).SaveToStream(nStream);

    if nStream.Size < MAX_PATH then Exit;
    nStream.Seek(-MAX_PATH, soFromEnd);
    nStream.ReadBuffer(nBuf, MAX_PATH);

    nClass := FindClass(PChar(@nBuf[1]));
    if Assigned(nClass) then
    begin
      nImage := TGraphicClass(nClass).Create;
      nStream.Size := nStream.Size - MAX_PATH;
      nStream.Seek(0, soFromBeginning);

      nImage.LoadFromStream(nStream);
      nPicture.Graphic := nImage;
      FreeAndNil(nImage);
    end;

    FreeAndNil(nStream);
    Result := True;
  except
    if Assigned(nImage) then nImage.Free;
    if Assigned(nStream) then nStream.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 是否启用备用数据库
function TFDM.IsEnableBackupDB: Boolean;
var nStr: string;
begin
  {$IFDEF EnableDoubleDB}
  Result := True;
  Exit;
  {$ENDIF}

  {$IFDEF EnableBackupDB}
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_EnableBakdb)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

//Desc: 检查nQuery.Connetion是否有效
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

//Desc: 执行nSQL写操作
function TFDM.ExecuteSQL(const nSQL: string; const nUseBackdb: Boolean): integer;
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

//Desc: 常规查询
function TFDM.QuerySQL(const nSQL: string; const nUseBackdb: Boolean): TDataSet;
var nStep: Integer;
    nException: string;
begin
  Result := nil;
  if not CheckQueryConnection(SQLQuery, nUseBackdb) then Exit;

  nException := '';
  nStep := 0;

  while nStep <= 2 do
  try
    if nStep = 1 then
    begin
      SQLQuery.Close;
      SQLQuery.SQL.Text := 'select 1';
      SQLQuery.Open;

      SQLQuery.Close;
      Break;
      //connection is ok
    end else

    if nStep = 2 then
    begin
      SQLQuery.Connection.Close;
      SQLQuery.Connection.Open;
    end; //reconnnect

    SQLQuery.Close;
    SQLQuery.SQL.Text := nSQL;
    SQLQuery.Open;

    Result := SQLQuery;
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

//Desc: 临时查询
function TFDM.QueryTemp(const nSQL: string; const nUseBackdb: Boolean): TDataSet;
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

//Desc: 用nQuery执行nSQL语句
procedure TFDM.QueryData(const nQuery: TADOQuery; const nSQL: string;
 const nUseBackdb: Boolean);
var nStep: Integer;
    nException: string;
    nBookMark: Pointer;
begin
  if not CheckQueryConnection(nQuery, nUseBackdb) then Exit;
  nException := '';
  nStep := 0;

  while nStep <= 2 do
  try
    if nStep = 1 then
    begin
      SqlTemp.Close;
      SqlTemp.Connection := nQuery.Connection;
      SqlTemp.SQL.Text := 'select 1';
      SqlTemp.Open;

      SqlTemp.Close;
      Break;
      //connection is ok
    end else

    if nStep = 2 then
    begin
      nQuery.Connection.Close;
      nQuery.Connection.Open;
    end; //reconnnect

    nQuery.DisableControls;
    nBookMark := nQuery.GetBookmark;
    try
      nQuery.Close;
      nQuery.SQL.Text := nSQL;
      nQuery.Open;
                 
      nException := '';
      nStep := 3;
      //delay break loop

      if nQuery.BookmarkValid(nBookMark) then
        nQuery.GotoBookmark(nBookMark);
    finally
      nQuery.FreeBookmark(nBookMark);
      nQuery.EnableControls;
    end;
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

//------------------------------------------------------------------------------
procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF UseReport}
  FDR := TFDR.Create(Self.Owner);
  {$ENDIF}
end;

end.
