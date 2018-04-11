{*******************************************************************************
  作者: dmzn@163.com 2012-4-21
  描述: 远程打印服务程序
*******************************************************************************}
unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IdContext, IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdGlobal, UMgrRemotePrint, SyncObjs, UTrayIcon, StdCtrls, ExtCtrls,
  ComCtrls;

type
  TfFormMain = class(TForm)
    GroupBox1: TGroupBox;
    MemoLog: TMemo;
    StatusBar1: TStatusBar;
    CheckSrv: TCheckBox;
    EditPort: TLabeledEdit;
    IdTCPServer1: TIdTCPServer;
    CheckAuto: TCheckBox;
    CheckLoged: TCheckBox;
    Timer1: TTimer;
    BtnConn: TButton;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckSrvClick(Sender: TObject);
    procedure CheckLogedClick(Sender: TObject);
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure BtnConnClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*状态栏图标*}
    FIsBusy: Boolean;
    FBillList: TStrings;
    FSyncLock: TCriticalSection;
    //同步锁
    procedure ShowLog(const nStr: string);
    //显示日志
    procedure DoExecute(const nContext: TIdContext);
    //执行动作
    procedure PrintBill(var nBase: TRPDataBase;var nBuf: TIdBytes;nCtx: TIdContext);
    //打印单据
    function IsOtherOrder(const nBill: string): Boolean;
    //是否为临时订单
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, Registry, ULibFun, UDataModule, UDataReport, USysLoger, UFormConn,
  DB, USysDB;

var
  gPath: string;               //程序路径

resourcestring
  sHint               = '提示';
  sConfig             = 'Config.Ini';
  sForm               = 'FormInfo.Ini';
  sDB                 = 'DBConn.Ini';
  sAutoStartKey       = 'RemotePrinter';

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFormMain, '打印服务主单元', nEvent);
end;

//------------------------------------------------------------------------------
procedure TfFormMain.FormCreate(Sender: TObject);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath+sConfig, gPath+sForm, gPath+sDB);
  
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogEvent := ShowLog;

  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := Caption;
  FTrayIcon.Visible := True;

  FIsBusy := False;
  FBillList := TStringList.Create;
  FSyncLock := TCriticalSection.Create;
  //new item 

  nIni := nil;
  nReg := nil;
  try
    nIni := TIniFile.Create(gPath + 'Config.ini');
    EditPort.Text := nIni.ReadString('Config', 'Port', '8000');
    Timer1.Enabled := nIni.ReadBool('Config', 'Enabled', False);

    nReg := TRegistry.Create;
    nReg.RootKey := HKEY_CURRENT_USER;

    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    CheckAuto.Checked := nReg.ValueExists(sAutoStartKey);
  finally
    nIni.Free;
    nReg.Free;
  end;

  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := BuildConnectDBStr;
  //数据库连接
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  nIni := nil;
  nReg := nil;
  try
    nIni := TIniFile.Create(gPath + 'Config.ini');
    //nIni.WriteString('Config', 'Port', EditPort.Text);
    nIni.WriteBool('Config', 'Enabled', CheckSrv.Enabled);

    nReg := TRegistry.Create;
    nReg.RootKey := HKEY_CURRENT_USER;

    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    if CheckAuto.Checked then
      nReg.WriteString(sAutoStartKey, Application.ExeName)
    else if nReg.ValueExists(sAutoStartKey) then
      nReg.DeleteValue(sAutoStartKey);
    //xxxxx
  finally
    nIni.Free;
    nReg.Free;
  end;

  FBillList.Free;
  FSyncLock.Free;
  //lock
end;

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  CheckSrv.Checked := True;
end;

procedure TfFormMain.CheckSrvClick(Sender: TObject);
begin
  if not IdTCPServer1.Active then
    IdTCPServer1.DefaultPort := StrToInt(EditPort.Text);
  IdTCPServer1.Active := CheckSrv.Checked;

  BtnConn.Enabled := not CheckSrv.Checked;
  EditPort.Enabled := not CheckSrv.Checked;

  FSyncLock.Enter;
  try
    FBillList.Clear;
    Timer2.Enabled := CheckSrv.Checked;
  finally
    FSyncLock.Leave;
  end;
end;

procedure TfFormMain.CheckLogedClick(Sender: TObject);
begin
  gSysLoger.LogSync := CheckLoged.Checked;
end;

procedure TfFormMain.ShowLog(const nStr: string);
var nIdx: Integer;
begin
  MemoLog.Lines.BeginUpdate;
  try
    MemoLog.Lines.Insert(0, nStr);
    if MemoLog.Lines.Count > 100 then
     for nIdx:=MemoLog.Lines.Count - 1 downto 50 do
      MemoLog.Lines.Delete(nIdx);
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

//Desc: 测试nConnStr是否有效
function ConnCallBack(const nConnStr: string): Boolean;
begin
  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := nConnStr;
  FDM.ADOConn.Open;
  Result := FDM.ADOConn.Connected;
end;

//Desc: 数据库配置
procedure TfFormMain.BtnConnClick(Sender: TObject);
begin
  if ShowConnectDBSetupForm(ConnCallBack) then
  begin
    FDM.ADOConn.Close;
    FDM.ADOConn.ConnectionString := BuildConnectDBStr;
    //数据库连接
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.IdTCPServer1Execute(AContext: TIdContext);
begin
  try
    DoExecute(AContext);
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
      AContext.Connection.Socket.InputBuffer.Clear;
    end;
  end;
end;

procedure TfFormMain.DoExecute(const nContext: TIdContext);
var nBuf: TIdBytes;
    nBase: TRPDataBase;
begin
  with nContext.Connection do
  begin
    Socket.ReadBytes(nBuf, cSizeRPBase, False);
    BytesToRaw(nBuf, nBase, cSizeRPBase);

    case nBase.FCommand of
     cRPCmd_PrintBill :
      begin
        PrintBill(nBase, nBuf, nContext);
        //print
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-4-1
//Parm: 交货单号;提示;数据对象;打印机
//Desc: 打印nBill交货单号
function PrintBillReport(const nBill: string; var nHint: string;
 const nPrinter: string = ''; const nMoney: string = '0'): Boolean;
var nStr: string;
    nDS: TDataSet;
begin
  nHint := '';
  Result := False;
  
  nStr := 'Select *,%s As L_ValidMoney From %s Where L_ID=''%s''';
  nStr := Format(nStr, [nMoney, sTable_Bill, nBill]);

  nDS := FDM.SQLQuery(nStr, FDM.SQLQuery1);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nHint := '交货单[ %s ] 已无效!!';
    nHint := Format(nHint, [nBill]);
    Exit;
  end;

  nStr := gPath + 'Report\LadingBill.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nHint := '无法正确加载报表文件';
    Exit;
  end;

  if nPrinter = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_Printer'
  else FDR.Report1.PrintOptions.Printer := nPrinter;

  FDR.Dataset1.DataSet := FDM.SQLQuery1;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;

  {$IFDEF PrintGLF}
  if nDS.FieldByName('L_PrintGLF').AsString <> 'Y' then Exit;

  nStr := gPath + 'Report\BillLoad.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nHint := '无法正确加载报表文件: ' + nStr;
    Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SQLQuery1;
  FDR.PrintReport;
  {$ENDIF}
end;

//Date: 2012-4-1
//Parm: 采购单号;提示;数据对象;打印机
//Desc: 打印nOrder采购单号
function PrintOrderReport(const nOrder: string; var nHint: string;
 const nPrinter: string = ''; const nMoney: string = '0'): Boolean;
var nStr: string;
    nDS: TDataSet;
begin
  nHint := '';
  Result := False;

  {nStr := 'Select * From %s oo Inner Join %s od on oo.O_ID=od.D_OID Where D_ID=''%s''';
  nStr := Format(nStr, [sTable_Order, sTable_OrderDtl, nOrder]);

  nDS := FDM.SQLQuery(nStr, FDM.SQLQuery1);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nHint := '采购单[ %s ] 已无效!!';
    nHint := Format(nHint, [nOrder]);
    Exit;
  end;}

  nStr := gPath + 'Report\PurchaseOrder.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nHint := '无法正确加载报表文件: ' + nStr;
    Exit;
  end;

  if nPrinter = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_Printer'
  else FDR.Report1.PrintOptions.Printer := nPrinter;

  FDR.Dataset1.DataSet := FDM.SQLQuery1;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2018-3-4
//Parm: 采购单号;提示;数据对象;打印机
//Desc: 打印nOrder采购单号
function PrintPoundReport(const nOrder: string; var nHint: string;
 const nPrinter: string = ''; const nMoney: string = '0'): Boolean;
var nStr: string;
    nDS: TDataSet;
begin
  nHint := '';
  Result := False;

  nStr := 'Select top 1 * From %s Where P_OrderBak=''%s'' order by R_ID desc';
  nStr := Format(nStr, [sTable_PoundLog, nOrder]);

  nDS := FDM.SQLQuery(nStr, FDM.SQLQuery1);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nHint := '磅单[ %s ] 已无效!!';
    nHint := Format(nHint, [nOrder]);
    Exit;
  end;

  nStr := gPath + 'Report\Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nHint := '无法正确加载报表文件: ' + nStr;
    Exit;
  end;

  if nPrinter = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_Printer'
  else FDR.Report1.PrintOptions.Printer := nPrinter;

  FDR.Dataset1.DataSet := FDM.SQLQuery1;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2018-4-4
//Parm: 采购单号;提示;数据对象;打印机
//Desc: 打印nOrder采购单号
function PrintPoundOtherReport(const nOrder: string; var nHint: string;
 const nPrinter: string = ''; const nMoney: string = '0'): Boolean;
var nStr: string;
    nDS: TDataSet;
begin
  nHint := '';
  Result := False;

  nStr := 'Select top 1 * From %s pl '+
  'Left Join %s oo On oo.R_ID=pl.P_OrderBak'+
  ' Where pl.P_OrderBak=''%s'' order by pl.R_ID desc';
  nStr := Format(nStr, [sTable_PoundLog, sTable_CardOther, nOrder]);

  nDS := FDM.SQLQuery(nStr, FDM.SQLQuery1);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nHint := '磅单[ %s ] 已无效!!';
    nHint := Format(nHint, [nOrder]);
    Exit;
  end;

  nStr := gPath + 'Report\PoundOther.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nHint := '无法正确加载报表文件: ' + nStr;
    Exit;
  end;

  if nPrinter = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_Printer'
  else FDR.Report1.PrintOptions.Printer := nPrinter;

  FDR.Dataset1.DataSet := FDM.SQLQuery1;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 获取nStock品种的报表文件
function GetReportFileByStock(const nStock: string): string;
begin
  Result := GetPinYinOfStr(nStock);

  if Pos('dj', Result) > 0 then
    Result := gPath + 'Report\HuaYan42_DJ.fr3'
  else if Pos('gsysl', Result) > 0 then
    Result := gPath + 'Report\HuaYan_gsl.fr3'
  else if Pos('kzf', Result) > 0 then
    Result := gPath + 'Report\HuaYan_kzf.fr3'
  else if Pos('qz', Result) > 0 then
    Result := gPath + 'Report\HuaYan_qz.fr3'
  else if Pos('32', Result) > 0 then
    Result := gPath + 'Report\HuaYan32.fr3'
  else if Pos('42', Result) > 0 then
    Result := gPath + 'Report\HuaYan42.fr3'
  else if Pos('52', Result) > 0 then
    Result := gPath + 'Report\HuaYan42.fr3'
  else Result := '';
end;

//Desc: 打印标识为nHID的化验单
function PrintHuaYanReport(const nBill: string; var nHint: string;
 const nPrinter: string = ''): Boolean;
var nStr,nSR: string;
begin
  nHint := '';
  Result := False;
  
  nSR := 'Select * From %s sr ' +
         ' Left Join %s sp on sp.P_ID=sr.R_PID';
  nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);

  nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          'Where H_Reporter=''$ID''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nBill)]);
  //xxxxx

  if FDM.SQLQuery(nStr, FDM.SqlTemp).RecordCount < 1 then
  begin
    nHint := '提货单[ %s ]没有对应的化验单';
    nHint := Format(nHint, [nBill]);
    Exit;
  end;

  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
  nStr := GetReportFileByStock(nStr);

  if not FDR.LoadReportFile(nStr) then
  begin
    nHint := '无法正确加载报表文件: ' + nStr;
    Exit;
  end;

  if nPrinter = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
  else FDR.Report1.PrintOptions.Printer := nPrinter;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印标识为nID的合格证
function PrintHeGeReport(const nBill: string; var nHint: string;
 const nPrinter: string = ''): Boolean;
var nStr,nSR: string;
    nField: TField;
begin
  nHint := '';
  Result := False;

  nStr := 'Select * From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  if FDM.SQLQuery(nStr, FDM.SqlTemp).RecordCount < 1 then
  begin
    nHint := '提货单[ %s ]没有对应的合格证';
    nHint := Format(nHint, [nBill]);
    Exit;
  end;

  with FDM.SqlTemp do
  begin
    nField := FindField('L_PrintHY');
    if Assigned(nField) and (nField.AsString <> sFlag_Yes) then
    begin
      nHint := '交货单[ %s ]无需打印合格证.';
      nHint := Format(nHint, [nBill]);
      Exit;
    end;
  end;

  nStr := gPath + 'Report\HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nHint := '无法正确加载报表文件: ' + nStr;
    Exit;
  end;

  if nPrinter = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
  else FDR.Report1.PrintOptions.Printer := nPrinter;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//------------------------------------------------------------------------------
//Desc: 打印单据
procedure TfFormMain.PrintBill(var nBase: TRPDataBase; var nBuf: TIdBytes;
  nCtx: TIdContext);
var nStr: WideString;
begin
  nCtx.Connection.Socket.ReadBytes(nBuf, nBase.FDataLen, False);
  nStr := Trim(BytesToString(nBuf));

  FSyncLock.Enter;
  try
    FBillList.Add(nStr);
  finally
    FSyncLock.Leave;
  end;

  WriteLog(Format('添加打印交货单: %s', [nStr]));
  //loged
end;

procedure TfFormMain.Timer2Timer(Sender: TObject);
var nPos: Integer;
    nBill,nHint,nPrinter,nHYPrinter,nMoney, nType: string;
begin
  if not FIsBusy then
  begin
    FSyncLock.Enter;
    try
      if FBillList.Count < 1 then Exit;
      nBill := FBillList[0];
      FBillList.Delete(0);
    finally
      FSyncLock.Leave;
    end;

    //bill #9 printer #8 money #7 CardType #6 HYPrinter
    nPos := Pos(#6, nBill);
    if nPos > 1 then
    begin
      nHYPrinter := nBill;
      nBill := Copy(nBill, 1, nPos - 1);
      System.Delete(nHYPrinter, 1, nPos);
    end else nHYPrinter := '';

    nPos := Pos(#7, nBill);
    if nPos > 1 then
    begin
      nType := nBill;
      nBill := Copy(nBill, 1, nPos - 1);
      System.Delete(nType, 1, nPos);
    end else nType := '';

    nPos := Pos(#8, nBill);
    if nPos > 1 then
    begin
      nMoney := nBill;
      nBill := Copy(nBill, 1, nPos - 1);
      System.Delete(nMoney, 1, nPos);

      if not IsNumber(nMoney, True) then
        nMoney := '0';
      //xxxxx
    end else nMoney := '0';

    nPos := Pos(#9, nBill);
    if nPos > 1 then
    begin
      nPrinter := nBill;
      nBill := Copy(nBill, 1, nPos - 1);
      System.Delete(nPrinter, 1, nPos);
    end else nPrinter := '';

    WriteLog('开始打印: ' + nBill);
    try
      FIsBusy := True;
      //set flag

      if nType = sFlag_Mul then
      begin
        PrintPoundOtherReport(nBill, nHint, nPrinter);
        if nHint <> '' then WriteLog(nHint);
      end else
      if (nType = 'P') or IsOtherOrder(nBill) then
      begin
//        PrintOrderReport(nBill, nHint, nPrinter);
        PrintPoundReport(nBill, nHint, nPrinter);
        if nHint <> '' then WriteLog(nHint);
      end else
      begin
        PrintBillReport(nBill, nHint, nPrinter, nMoney);
        if nHint <> '' then WriteLog(nHint);

        {$IFDEF PrintHYEach}
          {$IFNDEF HeGeZhengOnly}
          PrintHuaYanReport(nBill, nHint, nHYPrinter);
          if nHint <> '' then WriteLog(nHint);
          {$ENDIF}

          PrintHeGeReport(nBill, nHint, nHYPrinter);
          if nHint <> '' then WriteLog(nHint);
        {$ENDIF}
      end;
    except
      on E: Exception do
        WriteLog(E.Message);
      //xxxxx
    end;

    FIsBusy := False;
    WriteLog('打印结束.');
  end;
end;

//Desc: 是否为临时订单
function TfFormMain.IsOtherOrder(const nBill: string): Boolean;
var nStr,nPreFix,nOrder: string;
    nDS: TDataSet;
begin
  Result := False;

  nStr := 'Select L_ZhiKa From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  nDS := FDM.SQLQuery(nStr, FDM.SQLQuery1);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    Exit;
  end;
  nOrder := nDS.Fields[0].AsString;

  nPreFix := 'WY';
  nStr := 'Select B_Prefix From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

  nDS := FDM.SQLQuery(nStr, FDM.SQLQuery1);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount > 0 then
  begin
    nPreFix := nDS.Fields[0].AsString;
  end;

  if Pos(nPreFix,nOrder) > 0 then
  begin
    Result := True;
  end;
end;

end.
