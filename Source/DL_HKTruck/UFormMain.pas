{*******************************************************************************
  作者: dmzn@163.com 2015-01-09
  描述: 车牌识别数据同步
*******************************************************************************}
unit UFormMain;

{.$DEFINE DEBUG}
{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, ComCtrls, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, uSuperObject;

const
  cHttpTimeOut          = 10;
  //日期相关
  sField_SQLServer_Now = 'getDate()';
  
type
  TfFormMain = class(TForm)
    GroupBox1: TGroupBox;
    MemoLog: TMemo;
    StatusBar1: TStatusBar;
    CheckSrv: TCheckBox;
    EditPort: TLabeledEdit;
    CheckAuto: TCheckBox;
    CheckLoged: TCheckBox;
    BtnConn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckLogedClick(Sender: TObject);
    procedure BtnConnClick(Sender: TObject);
    procedure CheckSrvClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*状态栏图标*}
    FRecordIndex: Integer;
    //记录索引
    procedure ShowLog(const nStr: string);
    //显示日志
    procedure StartHKClient;
    //启动车牌识别
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  ActiveX, IniFiles, Registry, TLHelp32, ShellAPI, ULibFun, UDataModule,
  UFormConn, UWaitItem, UFormCtrl, USysLoger, DB, USysDB;

type
  TSyncThread = class(TThread)
  private
    FStartIndex: Integer;
    //起始索引
    FWaiter: TWaitObject;
    //等待对象
    FListA,FListB,FListC: TStrings;
    //数据列表
    FIdHttp: TIdHTTP;
  protected
    procedure DoSync;
    procedure DoSync_Ex;
    procedure DoSyncEx;
    procedure Execute; override;
    //执行同步
    procedure SaveRecordIndex;
    //保存索引
  public
    constructor Create(const nStart: Integer);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止线程
  end;

var
  gPath: string;               //程序路径
  gSyncer: TSyncThread = nil;  //同步线程
  SrvUrl: string;
  BeforeTime: Double;
  TruckType:string;

resourcestring
  sHint               = '提示';
  sConfig             = 'Config.Ini';
  sDB                 = 'DBConn.Ini';
  sAutoStartKey       = 'HKTruck';

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFormMain, '车牌服务主单元', nEvent);
end;

function UnicodeToChinese(inputstr: string): string;
var
    i: Integer;
    index: Integer;
    temp, top, last: string;
begin
    index := 1;
    while index >= 0 do
    begin
        index := Pos('\u', inputstr) - 1;
        if index < 0 then
        begin
            last := inputstr;
            Result := Result + last;
            Exit;
        end;
        top := Copy(inputstr, 1, index); // 取出 编码字符前的 非 unic 编码的字符，如数字
        temp := Copy(inputstr, index + 1, 6); // 取出编码，包括 \u,如\u4e3f
        Delete(temp, 1, 2);
        Delete(inputstr, 1, index + 6);
        Result := Result + top + WideChar(StrToInt('$' + temp));
    end;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.FormCreate(Sender: TObject);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath+sConfig, gPath+sConfig, gPath+sDB);
  
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogEvent := ShowLog;

  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := Caption;
  FTrayIcon.Visible := True;

  nIni := nil;
  nReg := nil;
  try
    nIni := TIniFile.Create(gPath + sConfig);
    FRecordIndex := nIni.ReadInteger('Config', 'RecordStart', 0);

    EditPort.Text  := nIni.ReadString('Config', 'Port', '8000');
    Timer1.Enabled := nIni.ReadBool('Config', 'Enabled', False);
    SrvUrl         := nIni.ReadString('Config', 'SrvUrl', 'http://127.0.0.1');
    BeforeTime     := nIni.ReadFloat('Config','BeforeTime',0.002);
    TruckType      := nIni.ReadString('Config', 'TruckType', '大车');

    LoadFormConfig(Self, nIni); 
    nReg := TRegistry.Create;
    nReg.RootKey := HKEY_CURRENT_USER;

    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    CheckAuto.Checked := nReg.ValueExists(sAutoStartKey);
  finally
    nIni.Free;
    nReg.Free;
  end;
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  if Assigned(gSyncer) then
    gSyncer.StopMe;
  gSyncer := nil;

  nIni := nil;
  nReg := nil;
  try
    nIni := TIniFile.Create(gPath + 'Config.ini');
    nIni.WriteBool('Config', 'Enabled', CheckSrv.Checked);
    SaveFormConfig(Self, nIni);

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
end;

//Date: 2015-01-09
//Desc: 启动车牌识别客户端
procedure TfFormMain.StartHKClient;
var nStr: string;
    nRet: BOOL;
    nHwnd:THandle;
    nEntry:TProcessEntry32;
begin
//  nHwnd := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS,0);
//  try
//    nEntry.dwSize := Sizeof(nEntry);
//    nRet := Process32First(nHwnd, nEntry);
//    while nRet do
//    begin
//      nStr := Trim(nEntry.szExeFile);
//      nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
//
//      if CompareText('ITCClient', nStr) = 0 then Exit;
//      //客户端已启动 
//      nRet := Process32Next(nHwnd, nEntry);
//    end;
//  finally
//    CloseHandle(nHwnd);
//  end;
//
//  nStr := gPath + 'bin\ITCClient.exe';
//  ShellExecute(GetDesktopWindow, nil, PChar(nStr), nil, nil, SW_ShowNormal);
end;

//------------------------------------------------------------------------------
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  CheckSrv.Checked := True;

  {$IFDEF DEBUG}
  CheckLoged.Checked := True;
  {$ELSE}
  FTrayIcon.Minimize;
  {$ENDIF}

//  StartHKClient;
  //启动车牌识别客户端
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
  ShowConnectDBSetupForm(ConnCallBack);
end;

//Desc: 启动服务
procedure TfFormMain.CheckSrvClick(Sender: TObject);
begin
  BtnConn.Enabled := not CheckSrv.Checked;
  EditPort.Enabled := not CheckSrv.Checked;

  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := BuildConnectDBStr;

  FDM.ADOLocal.Close;
  FDM.ADOLocal.ConnectionString := BuildConnectDBStr(nil, '本地');

  if CheckSrv.Checked then
  begin
    if not Assigned(gSyncer) then
      gSyncer := TSyncThread.Create(FRecordIndex);
    //xxxxx
  end else
  begin
    if Assigned(gSyncer) then
      gSyncer.StopMe;
    gSyncer := nil;
  end;
end;

//------------------------------------------------------------------------------
constructor TSyncThread.Create(const nStart: Integer);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FStartIndex := nStart;
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 1 * 1000;

  FidHttp := TIdHTTP.Create(nil);
  FidHttp.ConnectTimeout := cHttpTimeOut * 1000;
  FidHttp.ReadTimeout := cHttpTimeOut * 1000;
end;

destructor TSyncThread.Destroy;
begin
  FWaiter.Free;
  FreeAndNil(FidHttp);
  inherited;
end;

procedure TSyncThread.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TSyncThread.SaveRecordIndex;
var nIni: TIniFile;
begin
  nIni := nil;
  try
    nIni := TIniFile.Create(gPath + sConfig);
    nIni.WriteInteger('Config', 'RecordStart', FStartIndex);
  finally
    nIni.Free;
  end;
end;

procedure TSyncThread.Execute;
begin
  CoInitialize(nil);

  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    DoSync;
    //进厂记录执行
    sleep(20);
    DoSync_Ex;
//    //出厂记录执行
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;

  CoUninitialize;
end;

procedure TSyncThread.DoSync;
var nStr, szUrl: string;
    nDS: TDataSet;
    nTruck, nTruckEx: WideString;
    nIdx,nInt: Integer;
    nLastTime : TDateTime;
    ReJo, OneJo : ISuperObject;
    ArrsJa,ArrsJaSub: TSuperArray;
    wParam: TStrings;
    ReStream:TStringstream;
    nlast:string;
begin
  FListA.Clear;
  FListB.Clear;

  wParam   := TStringList.Create;
  ReStream := TStringstream.Create('');
  nlast    := DateTimeToStr(Now - BeforeTime);
  try
    wParam.Clear;
    wParam.Values['do']            := 'queryEnterRecord';
    wParam.Values['start_time']    := nlast;
    wParam.Values['car_type_name'] := Ansitoutf8(TruckType) ;

    szUrl := SrvUrl + '/plugin/passRecord.action';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := ReStream.DataString;
    nStr := UTF8Decode(ReStream.DataString);
    nStr := UnicodeToChinese(nStr);


   // WriteLog('入场车辆查询出参：' + nStr);

    if nStr <> '' then
    begin
      ReJo    := SO(nStr);
      if ReJo = nil then Exit;

      if ReJo.S['result_code'] = '0' then
      begin
        ArrsJa  := ReJo.A['data'];
        if ArrsJa <> nil then
        begin
          for nIdx := 0 to ArrsJa.Length - 1 do
          begin
            OneJo := SO(ArrsJa.S[nIdx]);

            WriteLog('获取入场车辆:'+OneJo.S['enter_car_plate_no']);

            nTruck   := OneJo.S['enter_car_plate_no'];
            nTruckEx := OneJo.S['enter_car_plate_no'];

            nStr := MakeSQLByStr([
              SF('T_LastTime', OneJo.S['enter_time'])
              ], sTable_Truck, SF('T_Truck', nTruck), False);
              FListA.Values[nTruck] := nStr;

            nStr := MakeSQLByStr([SF('T_Truck', nTruck),
                    SF('T_PY', GetPinYinOfStr(nTruck)),
                    SF('T_PlateColor', ''),
                    SF('T_Type', OneJo.S['enter_car_type_name']),
                    SF('T_LastTime', OneJo.S['enter_time']),
                    SF('T_NoVerify', sFlag_No),
                    SF('T_Valid', sFlag_Yes)
                    ], sTable_Truck, '', True);
            FListB.Values[nTruck] := nStr;
          end;
        end;
      end
      else
      begin
        WriteLog('获取入场车辆失败');
      end;
    end;
  finally
    ReStream.Free;
    wParam.Free;
    FidHttp.Disconnect;
  end;

  FDM.ADOConn.Connected := False;

  FDM.ADOConn.Connected := True;

  if FDM.ADOConn.InTransaction then
    FDM.ADOConn.RollbackTrans;

  FDM.ADOConn.BeginTrans;
    //开启事务

  try
    for nIdx:=FListA.Count - 1 downto 0 do
    begin
      nStr := FListA.Names[nIdx];
      FDM.SQLTemp.Close;
      FDM.SQLTemp.SQL.Text := FListA.Values[nStr]; //update
      nInt := FDM.SQLTemp.ExecSQL;

      if nInt < 1 then
      begin
        FDM.SQLTemp.Close;
        FDM.SQLTemp.SQL.Text := FListB.Values[nStr]; //update
        FDM.SQLTemp.ExecSQL;
      end;
    end;

    FDM.ADOConn.CommitTrans;
    nStr := '共成功传输车牌[ %d ]个.';
    nStr := Format(nStr, [FListA.Count]);

    WriteLog(nStr);
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

procedure TSyncThread.DoSyncEx;
var nStr, szUrl: string;
    nDS: TDataSet;
    nTruck, nTruckEx: WideString;
    nIdx,nInt: Integer;
    nLastTime : TDateTime;
    ReJo, OneJo : ISuperObject;
    ArrsJa,ArrsJaSub: TSuperArray;
    wParam: TStrings;
    ReStream:TStringstream;
    nlast:string;
begin
  FListA.Clear;
  FListB.Clear;

  wParam   := TStringList.Create;
  ReStream := TStringstream.Create('');
  nlast    := DateTimeToStr(Now - BeforeTime);
  try
    wParam.Clear;
    wParam.Values['do']         := 'queryExitRecord';
    wParam.Values['start_time'] := nlast;

    WriteLog('出场车辆查询入参：' + wParam.Text);

    szUrl := SrvUrl + '/plugin/passRecord.action';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := ReStream.DataString;
    nStr := UTF8Decode(ReStream.DataString);
    nStr := UnicodeToChinese(nStr);


    WriteLog('出场车辆查询出参：' + nStr);

    if nStr <> '' then
    begin
      ReJo    := SO(nStr);
      if ReJo = nil then Exit;

      if ReJo.S['result_code'] = '0' then
      begin
        ArrsJa  := ReJo.A['data'];
        if ArrsJa <> nil then
        begin
          for nIdx := 0 to ArrsJa.Length - 1 do
          begin
            OneJo := SO(ArrsJa.S[nIdx]);

            WriteLog('获取出场车辆:'+OneJo.S['exit_car_plate_no']);

            nTruck   := OneJo.S['exit_car_plate_no'];
            nTruckEx := OneJo.S['exit_car_plate_no'];

            nStr := MakeSQLByStr([
              SF('T_LastTime', OneJo.S['exit_time'])
              ], sTable_Truck, SF('T_Truck', nTruck), False);
              FListA.Values[nTruck] := nStr;

            nStr := MakeSQLByStr([SF('T_Truck', nTruck),
                    SF('T_PY', GetPinYinOfStr(nTruck)),
                    SF('T_PlateColor', ''),
                    SF('T_Type', OneJo.S['exit_car_type_name']),
                    SF('T_LastTime', OneJo.S['exit_time']),
                    SF('T_NoVerify', sFlag_No),
                    SF('T_Valid', sFlag_Yes)
                    ], sTable_Truck, '', True);
            FListB.Values[nTruck] := nStr;
          end;
        end;
      end
      else
      begin
        WriteLog('获取出场车辆失败');
      end;
    end;
  finally
    ReStream.Free;
    wParam.Free;
    FidHttp.Disconnect;
  end;

  FDM.ADOConn.Connected := False;

  FDM.ADOConn.Connected := True;

  if FDM.ADOConn.InTransaction then
    FDM.ADOConn.RollbackTrans;

  FDM.ADOConn.BeginTrans;
    //开启事务

  try
    for nIdx:=FListA.Count - 1 downto 0 do
    begin
      nStr := FListA.Names[nIdx];
      FDM.SQLTemp.Close;
      FDM.SQLTemp.SQL.Text := FListA.Values[nStr]; //update
      nInt := FDM.SQLTemp.ExecSQL;

      if nInt < 1 then
      begin
        FDM.SQLTemp.Close;
        FDM.SQLTemp.SQL.Text := FListB.Values[nStr]; //update
        FDM.SQLTemp.ExecSQL;
      end;
    end;

    FDM.ADOConn.CommitTrans;
    nStr := '共成功传输车牌[ %d ]个.';
    nStr := Format(nStr, [FListA.Count]);

    WriteLog(nStr);
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

procedure TSyncThread.DoSync_Ex;
var nStr, szUrl: string;
    nDS: TDataSet;
    nTruck, nTruckEx: WideString;
    nIdx,nInt: Integer;
    nLastTime : TDateTime;
    ReJo, OneJo : ISuperObject;
    ArrsJa,ArrsJaSub: TSuperArray;
    wParam: TStrings;
    ReStream:TStringstream;
    nlast:string;
begin
  FListA.Clear;
  FListB.Clear;

  wParam   := TStringList.Create;
  ReStream := TStringstream.Create('');
  nlast    := DateTimeToStr(Now - BeforeTime);
  try
    wParam.Clear;
    wParam.Values['do']            := 'queryEnterRecord';
    wParam.Values['start_time']    := nlast;

    szUrl := SrvUrl + '/plugin/passRecord.action';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := ReStream.DataString;
    nStr := UTF8Decode(ReStream.DataString);
    nStr := UnicodeToChinese(nStr);


   // WriteLog('入场车辆查询出参：' + nStr);

    if nStr <> '' then
    begin
      ReJo    := SO(nStr);
      if ReJo = nil then Exit;

      if ReJo.S['result_code'] = '0' then
      begin
        ArrsJa  := ReJo.A['data'];
        if ArrsJa <> nil then
        begin
          for nIdx := 0 to ArrsJa.Length - 1 do
          begin
            OneJo := SO(ArrsJa.S[nIdx]);

            WriteLog('获取入场车辆:'+OneJo.S['enter_car_plate_no']);

            nTruck   := OneJo.S['enter_car_plate_no'];
            nTruckEx := OneJo.S['enter_car_plate_no'];

            nStr := MakeSQLByStr([
              SF('T_LastTime', OneJo.S['enter_time'])
              ], sTable_Truck, SF('T_Truck', nTruck), False);
              FListA.Values[nTruck] := nStr;

            nStr := MakeSQLByStr([SF('T_Truck', nTruck),
                    SF('T_PY', GetPinYinOfStr(nTruck)),
                    SF('T_PlateColor', ''),
                    SF('T_Type', OneJo.S['enter_car_type_name']),
                    SF('T_LastTime', OneJo.S['enter_time']),
                    SF('T_NoVerify', sFlag_No),
                    SF('T_Valid', sFlag_Yes)
                    ], sTable_Truck, '', True);
            FListB.Values[nTruck] := nStr;
          end;
        end;
      end
      else
      begin
        WriteLog('获取入场车辆失败');
      end;
    end;
  finally
    ReStream.Free;
    wParam.Free;
    FidHttp.Disconnect;
  end;

  FDM.ADOConn.Connected := False;

  FDM.ADOConn.Connected := True;

  if FDM.ADOConn.InTransaction then
    FDM.ADOConn.RollbackTrans;

  FDM.ADOConn.BeginTrans;
    //开启事务

  try
    for nIdx:=FListA.Count - 1 downto 0 do
    begin
      nStr := FListA.Names[nIdx];
      FDM.SQLTemp.Close;
      FDM.SQLTemp.SQL.Text := FListA.Values[nStr]; //update
      nInt := FDM.SQLTemp.ExecSQL;

      if nInt < 1 then
      begin
        FDM.SQLTemp.Close;
        FDM.SQLTemp.SQL.Text := FListB.Values[nStr]; //update
        FDM.SQLTemp.ExecSQL;
      end;
    end;

    FDM.ADOConn.CommitTrans;
    nStr := '共成功传输车牌[ %d ]个.';
    nStr := Format(nStr, [FListA.Count]);

    WriteLog(nStr);
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

end.
