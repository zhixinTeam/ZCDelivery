{*******************************************************************************
  作者: dmzn@163.com 2017-09-22
  描述: 模块业务对象
*******************************************************************************}
unit UWorkerBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  UBusinessConst, UMgrDBConn, UMgrParam, ULibFun, UFormCtrl, UBase64, ZnMD5, 
  USysLoger, USysDB, UMITConst;

type
  TBusWorkerQueryField = class(TBusinessWorkerBase)
  private
    FIn: TWorkerQueryFieldData;
    FOut: TWorkerQueryFieldData;
  public
    class function FunctionName: string; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    function DoWork(var nData: string): Boolean; override;
    //执行业务
  end;

  TMITDBWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //错误码
    FDBConn: PDBWorker;
    //数据通道
    FDataIn,FDataOut: PBWDataBase;
    //入参出参
    FDataOutNeedUnPack: Boolean;
    //需要解包
    procedure GetInOutData(var nIn,nOut: PBWDataBase); virtual; abstract;
    //出入参数
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //验证入参
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //数据业务
  public
    function DoWork(var nData: string): Boolean; override;
    //执行业务
    procedure WriteLog(const nEvent: string);
    //记录日志
  end;

  TWorkerBusinessCommander = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetCardUsed(var nData: string): Boolean;
    //获取卡片类型
    function Login(var nData: string):Boolean;
    function LogOut(var nData: string): Boolean;
    //登录注销，用于移动终端
    function GetServerNow(var nData: string): Boolean;
    //获取服务器时间
    function GetSerailID(var nData: string): Boolean;
    //获取串号
    function IsSystemExpired(var nData: string): Boolean;
    //系统是否已过期
    function SaveTruck(var nData: string): Boolean;
    function UpdateTruck(var nData: string): Boolean;
    //保存车辆到Truck表
    function GetTruckPoundData(var nData: string): Boolean;
    function SaveTruckPoundData(var nData: string): Boolean;
    //存取车辆称重数据
    function GetStockBatcode(var nData: string): Boolean;
    //获取品种批次号
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation

class function TBusWorkerQueryField.FunctionName: string;
begin
  Result := sBus_GetQueryField;
end;

function TBusWorkerQueryField.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_GetQueryField;
  end;
end;

function TBusWorkerQueryField.DoWork(var nData: string): Boolean;
begin
  FOut.FData := '*';
  FPacker.UnPackIn(nData, @FIn);

  case FIn.FType of
   cQF_Bill: 
    FOut.FData := '*';
  end;

  Result := True;
  FOut.FBase.FResult := True;
  nData := FPacker.PackOut(@FOut);
end;

//------------------------------------------------------------------------------
//Date: 2012-3-13
//Parm: 如参数护具
//Desc: 获取连接数据库所需的资源
function TMITDBWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser   := gSysParam.FAppFlag;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx

      Result := DoAfterDBWork(nData, True);
      if not Result then Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      nData := FPacker.PackOut(FDataOut);

      {$IFDEF DEBUG}
      WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end else DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
  end;
end;

//Date: 2012-3-22
//Parm: 输出数据;结果
//Desc: 数据业务执行完毕后的收尾操作
function TMITDBWorker.DoAfterDBWork(var nData: string; nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: 入参数据
//Desc: 验证入参数据是否有效
function TMITDBWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//Desc: 记录nEvent日志
procedure TMITDBWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMITDBWorker, FunctionName, nEvent);
end;

//------------------------------------------------------------------------------
class function TWorkerBusinessCommander.FunctionName: string;
begin
  Result := sBus_BusinessCommand;
end;

constructor TWorkerBusinessCommander.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessCommander.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessCommander.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessCommander.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: 命令;数据;参数;输出
//Desc: 本地调用业务对象
class function TWorkerBusinessCommander.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nPacker.InitData(@nIn, True, False);
    //init
    
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(FunctionName);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2012-3-22
//Parm: 输入数据
//Desc: 执行nData业务指令
function TWorkerBusinessCommander.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := '业务执行成功.';
  end;

  case FIn.FCommand of
   cBC_GetCardUsed         : Result := GetCardUsed(nData);
   cBC_ServerNow           : Result := GetServerNow(nData);
   cBC_GetSerialNO         : Result := GetSerailID(nData);
   cBC_IsSystemExpired     : Result := IsSystemExpired(nData);

   cBC_SaveTruckInfo       : Result := SaveTruck(nData);
   cBC_UpdateTruckInfo     : Result := UpdateTruck(nData);
   cBC_GetTruckPoundData   : Result := GetTruckPoundData(nData);
   cBC_SaveTruckPoundData  : Result := SaveTruckPoundData(nData);

   cBC_UserLogin           : Result := Login(nData);
   cBC_UserLogOut          : Result := LogOut(nData);
   cBC_GetStockBatcode     : Result := GetStockBatcode(nData);
   else
    begin
      Result := False;
      nData := '无效的业务代码(Code: %d Invalid Command).';
      nData := Format(nData, [FIn.FCommand]);
    end;
  end;
end;

//Date: 2014-09-05
//Desc: 获取卡片类型：销售S;采购P;其他O
function TWorkerBusinessCommander.GetCardUsed(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr := 'Select C_Used From %s Where C_Card=''%s'' ' +
          'or C_Card3=''%s'' or C_Card2=''%s''';
  nStr := Format(nStr, [sTable_Card, FIn.FData, FIn.FData, FIn.FData]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then
    begin
      nData := '磁卡[ %s ]信息不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    FOut.FData := Fields[0].AsString;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: 用户名,密码;返回用户数据
//Desc: 用户登录
function TWorkerBusinessCommander.Login(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  FListA.Clear;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if FListA.Values['User'] = '' then Exit;
  //未传递用户名

  nStr := 'Select U_Password From %s Where U_Name=''%s''';
  nStr := Format(nStr, [sTable_User, FListA.Values['User']]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then Exit;

    nStr := Fields[0].AsString;
    if nStr <> FListA.Values['Password'] then Exit;
    Result := True;
  end;
end;

//Date: 2015/9/9
//Parm: 用户名;验证数据
//Desc: 用户注销
function TWorkerBusinessCommander.LogOut(var nData: string): Boolean;
begin
  Result := True;
end;

//Date: 2014-09-05
//Desc: 获取服务器当前时间
function TWorkerBusinessCommander.GetServerNow(var nData: string): Boolean;
var nStr: string;
begin
  nStr := 'Select ' + sField_SQLServer_Now;
  //sql

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    FOut.FData := DateTime2Str(Fields[0].AsDateTime);
    Result := True;
  end;
end;

//Date: 2012-3-25
//Desc: 按规则生成序列编号
function TWorkerBusinessCommander.GetSerailID(var nData: string): Boolean;
var nInt: Integer;
    nStr,nP,nB: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    Result := False;
    FListA.Text := FIn.FData;
    //param list

    nStr := 'Update %s Set B_Base=B_Base+1 ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, FListA.Values['Group'],
            FListA.Values['Object']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Select B_Prefix,B_IDLen,B_Base,B_Date,%s as B_Now From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_SerialBase,
            FListA.Values['Group'], FListA.Values['Object']]);
    //xxxxx

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '没有[ %s.%s ]的编码配置.';
        nData := Format(nData, [FListA.Values['Group'], FListA.Values['Object']]);

        FDBConn.FConn.RollbackTrans;
        Exit;
      end;

      nP := FieldByName('B_Prefix').AsString;
      nB := FieldByName('B_Base').AsString;
      nInt := FieldByName('B_IDLen').AsInteger;

      if FIn.FExtParam = sFlag_Yes then //按日期编码
      begin
        nStr := Date2Str(FieldByName('B_Date').AsDateTime, False);
        //old date

        if (nStr <> Date2Str(FieldByName('B_Now').AsDateTime, False)) and
           (FieldByName('B_Now').AsDateTime > FieldByName('B_Date').AsDateTime) then
        begin
          nStr := 'Update %s Set B_Base=1,B_Date=%s ' +
                  'Where B_Group=''%s'' And B_Object=''%s''';
          nStr := Format(nStr, [sTable_SerialBase, sField_SQLServer_Now,
                  FListA.Values['Group'], FListA.Values['Object']]);
          gDBConnManager.WorkerExec(FDBConn, nStr);

          nB := '1';
          nStr := Date2Str(FieldByName('B_Now').AsDateTime, False);
          //now date
        end;

        System.Delete(nStr, 1, 2);
        //yymmdd
        nInt := nInt - Length(nP) - Length(nStr) - Length(nB);
        FOut.FData := nP + nStr + StringOfChar('0', nInt) + nB;
      end else
      begin
        nInt := nInt - Length(nP) - Length(nB);
        nStr := StringOfChar('0', nInt);
        FOut.FData := nP + nStr + nB;
      end;
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-05
//Desc: 验证系统是否已过期
function TWorkerBusinessCommander.IsSystemExpired(var nData: string): Boolean;
var nStr: string;
    nDate: TDate;
    nInt: Integer;
begin
  nDate := Date();
  //server now

  nStr := 'Select D_Value,D_ParamB From %s ' +
          'Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ValidDate]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := 'dmzn_stock_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));

    if nStr = Fields[1].AsString then
      nDate := Str2Date(Fields[0].AsString);
    //xxxxx
  end;

  nInt := Trunc(nDate - Date());
  Result := nInt > 0;

  if nInt <= 0 then
  begin
    nStr := '系统已过期 %d 天,请联系管理员!!';
    nData := Format(nStr, [-nInt]);
    Exit;
  end;

  FOut.FData := IntToStr(nInt);
  //last days

  if nInt <= 7 then
  begin
    nStr := Format('系统在 %d 天后过期', [nInt]);
    FOut.FBase.FErrDesc := nStr;
    FOut.FBase.FErrCode := sFlag_ForceHint;
  end;
end;

//Date: 2014-10-02
//Parm: 车牌号[FIn.FData];
//Desc: 保存车辆到sTable_Truck表
function TWorkerBusinessCommander.SaveTruck(var nData: string): Boolean;
var nStr: string;
begin
  Result := True;
  FIn.FData := UpperCase(FIn.FData);
  
  nStr := 'Select T_Phone From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, FIn.FData]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nStr := MakeSQLByStr([
              SF('T_Truck', FIn.FData),
              SF('T_PY', GetPinYinOfStr(FIn.FData)),
              SF('T_Phone', FIn.FExtParam),
              SF('T_Valid', sFlag_Yes)
              ], sTable_Truck, '', True);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else
    begin
      First;
      if (FIn.FExtParam <> '') and (FIn.FExtParam <> Fields[0].AsString) then
      begin
        nStr := 'Update %s Set T_Phone=''%s'' Where T_Truck=''%s''';
        nStr := Format(nStr, [sTable_Truck, FIn.FExtParam, FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn, nStr);
      end;
    end;
  end;
end;

//Date: 2016-02-16
//Parm: 车牌号(Truck); 表字段名(Field);数据值(Value)
//Desc: 更新车辆信息到sTable_Truck表
function TWorkerBusinessCommander.UpdateTruck(var nData: string): Boolean;
var nStr: string;
    nValInt: Integer;
    nValFloat: Double;
begin
  Result := True;
  FListA.Text := FIn.FData;

  if FListA.Values['Field'] = 'T_PValue' then
  begin
    nStr := 'Select T_PValue, T_PTime From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, FListA.Values['Truck']]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nValInt := Fields[1].AsInteger;
      nValFloat := Fields[0].AsFloat;
    end else Exit;

    nValFloat := nValFloat * nValInt + StrToFloatDef(FListA.Values['Value'], 0);
    nValFloat := nValFloat / (nValInt + 1);
    nValFloat := Float2Float(nValFloat, cPrecision);

    nStr := 'Update %s Set T_PValue=%.2f, T_PTime=T_PTime+1 Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nValFloat, FListA.Values['Truck']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
end;

//Date: 2014-09-25
//Parm: 车牌号[FIn.FData]
//Desc: 获取指定车牌号的称皮数据(使用配对模式,未称重)
function TWorkerBusinessCommander.GetTruckPoundData(var nData: string): Boolean;
var nStr: string;
    nPound: TLadingBillItems;
begin
  SetLength(nPound, 1);
  FillChar(nPound[0], SizeOf(TLadingBillItem), #0);

  nStr := 'Select * From %s Where P_Truck=''%s'' And ' +
          'P_MValue Is Null And P_PModel=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, FIn.FData, sFlag_PoundPD]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr),nPound[0] do
  begin
    if RecordCount > 0 then
    begin
      FCusID      := FieldByName('P_CusID').AsString;
      FCusName    := FieldByName('P_CusName').AsString;
      FTruck      := FieldByName('P_Truck').AsString;

      FType       := FieldByName('P_MType').AsString;
      FStockNo    := FieldByName('P_MID').AsString;
      FStockName  := FieldByName('P_MName').AsString;

      with FPData do
      begin
        FStation  := FieldByName('P_PStation').AsString;
        FValue    := FieldByName('P_PValue').AsFloat;
        FDate     := FieldByName('P_PDate').AsDateTime;
        FOperator := FieldByName('P_PMan').AsString;
      end;  

      FFactory    := FieldByName('P_FactID').AsString;
      FPModel     := FieldByName('P_PModel').AsString;
      FPType      := FieldByName('P_Type').AsString;
      FPoundID    := FieldByName('P_ID').AsString;

      FStatus     := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckBFM;
      FSelected   := True;
    end else
    begin
      FTruck      := FIn.FData;
      FPModel     := sFlag_PoundPD;

      FStatus     := '';
      FNextStatus := sFlag_TruckBFP;
      FSelected   := True;
    end;
  end;

  FOut.FData := CombineBillItmes(nPound);
  Result := True;
end;

//Date: 2014-09-25
//Parm: 称重数据[FIn.FData]
//Desc: 获取指定车牌号的称皮数据(使用配对模式,未称重)
function TWorkerBusinessCommander.SaveTruckPoundData(var nData: string): Boolean;
var nStr,nSQL: string;
    nPound: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
begin
  AnalyseBillItems(FIn.FData, nPound);
  //解析数据

  with nPound[0] do
  begin
    if FPoundID = '' then
    begin
      TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, FTruck, '', @nOut);
      //保存车牌号

      FListC.Clear;
      FListC.Values['Group'] := sFlag_BusGroup;
      FListC.Values['Object'] := sFlag_PoundID;

      if not CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      FPoundID := nOut.FData;
      //new id

      if FPModel = sFlag_PoundLS then
           nStr := sFlag_Other
      else nStr := sFlag_Provide;

      nSQL := MakeSQLByStr([
              SF('P_ID', FPoundID),
              SF('P_Type', nStr),
              SF('P_Truck', FTruck),
              SF('P_CusID', FCusID),
              SF('P_CusName', FCusName),
              SF('P_MID', FStockNo),
              SF('P_MName', FStockName),
              SF('P_MType', sFlag_San),
              SF('P_PValue', FPData.FValue, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_FactID', FFactory),
              SF('P_PStation', FPData.FStation),
              SF('P_Direction', '进厂'),
              SF('P_PModel', FPModel),
              SF('P_Status', sFlag_TruckBFP),
              SF('P_Valid', sFlag_Yes),
              SF('P_PrintNum', 1, sfVal)
              ], sTable_PoundLog, '', True);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end else
    begin
      nStr := SF('P_ID', FPoundID);
      //where

      if FNextStatus = sFlag_TruckBFP then
      begin
        nSQL := MakeSQLByStr([
                SF('P_PValue', FPData.FValue, sfVal),
                SF('P_PDate', sField_SQLServer_Now, sfVal),
                SF('P_PMan', FIn.FBase.FFrom.FUser),
                SF('P_PStation', FPData.FStation),
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', DateTime2Str(FMData.FDate)),
                SF('P_MMan', FMData.FOperator),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //称重时,由于皮重大,交换皮毛重数据
      end else
      begin
        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //xxxxx
      end;

      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    FOut.FData := FPoundID;
    Result := True;
  end;
end;

//Date: 2016-02-24
//Parm: 物料编号[FIn.FData];预扣减量[FIn.ExtParam];
//Desc: 按规则生成指定品种的批次编号
function TWorkerBusinessCommander.GetStockBatcode(var nData: string): Boolean;
var nStr,nP: string;
    nNew: Boolean;
    nInt,nInc: Integer;
    nVal,nPer: Double;

    //生成新批次号
    function NewBatCode: string;
    var nOld,nID,nName: string;
    begin
      nStr := 'Select * From %s Where B_Stock=''%s''';
      nStr := Format(nStr, [sTable_StockBatcode, FIn.FData]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      begin
        nP := FieldByName('B_Prefix').AsString;
        nStr := FieldByName('B_UseYear').AsString;
        nOld := FieldByName('B_Batcode').AsString;

        nID := FieldByName('B_Stock').AsString;
        nName := FieldByName('B_Name').AsString;
        nVal := FieldByName('B_Value').AsFloat;

        if nStr = sFlag_Yes then
        begin
          nStr := Copy(Date2Str(Now()), 3, 2);
          nP := nP + nStr;
          //前缀后两位年份
        end;

        nStr := FieldByName('B_Base').AsString;
        nInt := FieldByName('B_Length').AsInteger;
        nInt := nInt - Length(nP + nStr);

        if nInt > 0 then
             Result := nP + StringOfChar('0', nInt) + nStr
        else Result := nP + nStr;

        nStr := '物料[ %s.%s ]将立即使用批次号[ %s ],请通知化验室确认已采样.';
        nStr := Format(nStr, [FieldByName('B_Stock').AsString,
                              FieldByName('B_Name').AsString, Result]);
        //xxxxx

        FOut.FBase.FErrCode := sFlag_ForceHint;
        FOut.FBase.FErrDesc := nStr;
      end;

      FDBConn.FConn.BeginTrans;
      try
        nStr := MakeSQLByStr([SF('B_Batcode', Result),
                SF('B_FirstDate', sField_SQLServer_Now, sfVal),
                SF('B_HasUse', 0, sfVal),
                SF('B_LastDate', sField_SQLServer_Now, sfVal)
                ], sTable_StockBatcode, SF('B_Stock', FIn.FData), False);
        gDBConnManager.WorkerExec(FDBConn, nStr);

        FOut.FExtParam := DateTime2Str(Now);
        //批次号启用时间

        nStr := MakeSQLByStr([
                SF('R_LastDate', sField_SQLServer_Now, sfVal)
                ], sTable_BatRecord, SF('R_Batcode', nOld), False);
        gDBConnManager.WorkerExec(FDBConn, nStr); //封存旧编号

        nStr := MakeSQLByStr([SF('R_Batcode', Result),
                SF('R_Stock', nID),
                SF('R_Name', nName),
                SF('R_Value', nVal, sfVal),
                SF('R_Used', 0, sfVal),
                SF('R_FirstDate', sField_SQLServer_Now, sfVal)
                ], sTable_BatRecord, '', True);
        gDBConnManager.WorkerExec(FDBConn, nStr); //添加新编号

        FDBConn.FConn.CommitTrans;
      except
        on nErr: Exception do
        begin
          FDBConn.FConn.RollbackTrans;
          //rollback
          
          nData := '创建物料[ %s ]批次号失败,描述: %s';
          nData := Format(nData, [FIn.FData, nErr.Message]);
          raise Exception.Create(nData);
        end;
      end;
    end;
begin
  Result := True;
  FOut.FData := '';
  
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_BatchAuto]);
  
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := Fields[0].AsString;
    if nStr <> sFlag_Yes then Exit;
  end  else Exit;
  //默认不使用批次号

  Result := False; //Init
  nStr := 'Select *,%s as ServerNow From %s Where B_Stock=''%s''';
  nStr := Format(nStr, [sField_SQLServer_Now, sTable_StockBatcode, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '物料[ %s ]未配置批次号规则.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    FOut.FData := FieldByName('B_Batcode').AsString;
    FOut.FExtParam := DateTime2Str(FieldByName('B_FirstDate').AsDateTime);
    nInc := FieldByName('B_Incement').AsInteger;

    nNew := False;
    if FieldByName('B_UseDate').AsString = sFlag_Yes then
    begin
      nP := FieldByName('B_Prefix').AsString;
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime, False);

      nInt := FieldByName('B_Length').AsInteger;
      nInt := Length(nP + nStr) - nInt;

      if nInt > 0 then
      begin
        System.Delete(nStr, 1, nInt);
        FOut.FData := nP + nStr;
      end else
      begin
        nStr := StringOfChar('0', -nInt) + nStr;
        FOut.FData := nP + nStr;
      end;

      nNew := True;
    end;

    if (not nNew) and (FieldByName('B_AutoNew').AsString = sFlag_Yes) then      //元旦重置
    begin
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime);
      nStr := Copy(nStr, 1, 4);
      nP := Date2Str(FieldByName('B_LastDate').AsDateTime);
      nP := Copy(nP, 1, 4);

      if nStr <> nP then
      begin
        nStr := 'Update %s Set B_Base=1 Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, FIn.FData]);
        
        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
        nNew := True;
      end;
    end;

    if not nNew then //编号超期
    begin
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime);
      nP := Date2Str(FieldByName('B_FirstDate').AsDateTime);

      if (Str2Date(nP) > Str2Date('2000-01-01')) and
         (Str2Date(nStr) - Str2Date(nP) > FieldByName('B_Interval').AsInteger) then
      begin
        nStr := 'Update %s Set B_Base=B_Base+%d Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, nInc, FIn.FData]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
        nNew := True;
      end;
    end;

    if not nNew then //编号超发
    begin
      nVal := FieldByName('B_HasUse').AsFloat + StrToFloat(FIn.FExtParam);
      //已使用+预使用
      nPer := FieldByName('B_Value').AsFloat * FieldByName('B_High').AsFloat / 100;
      //可用上限

      if nVal >= nPer then //超发
      begin
        nStr := 'Update %s Set B_Base=B_Base+%d Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, nInc, FIn.FData]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
      end else
      begin
        nPer := FieldByName('B_Value').AsFloat * FieldByName('B_Low').AsFloat / 100;
        //提醒
      
        if nVal >= nPer then //超发提醒
        begin
          nStr := '物料[ %s.%s ]即将更换批次号,请通知化验室准备取样.';
          nStr := Format(nStr, [FieldByName('B_Stock').AsString,
                                FieldByName('B_Name').AsString]);
          //xxxxx

          FOut.FBase.FErrCode := sFlag_ForceHint;
          FOut.FBase.FErrDesc := nStr;
        end;
      end;
    end;
  end;

  if FOut.FData = '' then
    FOut.FData := NewBatCode;
  //xxxxx

  Result := True;
  FOut.FBase.FResult := True;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerQueryField, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessCommander, sPlug_ModuleBus);
end.
