{*******************************************************************************
  作者: juner11212436@163.com 2018-10-25
  描述: 恒河久远相关业务和数据处理
*******************************************************************************}
unit UWorkerBussinessHHJY;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, SysUtils, DB, ADODB, NativeXml, UBusinessWorker,
  UBusinessPacker, UBusinessConst, UMgrDBConn, UMgrParam, UFormCtrl, USysLoger,
  ZnMD5, ULibFun, USysDB, UMITConst, UMgrChannel,IdHTTP,Graphics,
  Variants, uSuperObject, MsMultiPartFormData, uLkJSON, DateUtils;

const
  cHttpTimeOut          = 10;
  
type
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
    FPackOut: Boolean;
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

  TBusWorkerBusinessHHJY = class(TMITDBWorker)
  private
    FListA,FListB,FListC,FListD,FListE: TStrings;
    //list
    FIn: TWorkerHHJYData;
    FOut: TWorkerHHJYData;
    //in out
    FIdHttp : TIdHTTP;
    FUrl    : string;
    Ftoken  : string;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;

    function UnicodeToChinese(inputstr: string): string;
    function GetLoginToken(var nData: string): Boolean;
    function GetOrderInfoEx(var nData: string): Boolean;
    function GetSaleInfo(var nData: string): Boolean;
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
      if FPackOut then
      begin
        WriteLog('打包');
        nData := FPacker.PackOut(FDataOut);
      end;

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
class function TBusWorkerBusinessHHJY.FunctionName: string;
begin
  Result := sBus_BusinessHHJY;
end;

constructor TBusWorkerBusinessHHJY.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  FListD := TStringList.Create;
  FListE := TStringList.Create;
  FidHttp := TIdHTTP.Create(nil);
  FidHttp.ConnectTimeout := cHttpTimeOut * 1000;
  FidHttp.ReadTimeout := cHttpTimeOut * 1000;
  inherited;
end;

destructor TBusWorkerBusinessHHJY.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  FreeAndNil(FListD);
  FreeAndNil(FListE);
  FreeAndNil(FidHttp);
  inherited;
end;

function TBusWorkerBusinessHHJY.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessHHJY;
  end;
end;

procedure TBusWorkerBusinessHHJY.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: 命令;数据;参数;输出
//Desc: 本地调用业务对象
class function TBusWorkerBusinessHHJY.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerHHJYData;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessHHJY);
    nPacker.InitData(@nIn, True, False);
    //init

    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessHHJY);
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
function TBusWorkerBusinessHHJY.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := '业务执行成功.';
  end;
  FPackOut := True;

  case FIn.FCommand of
    cBC_GetLoginToken        : Result := GetLoginToken(nData);
    cBC_GetOrderInfoEx       : Result := GetOrderInfoEx(nData);
    cBC_GetSaleInfo          : Result := GetSaleInfo(nData);    
  else
    begin
      Result := False;
      nData := '无效的业务代码(Code: %d Invalid Command).';
      nData := Format(nData, [FIn.FCommand]);
    end;
  end;
end;

function TBusWorkerBusinessHHJY.GetOrderInfoEx(var nData: string): Boolean;
var nStr, nProStr, nMatStr, nYearStr, nSQL : string;
    nHasDone: Double;
    nYearMonth,szUrl : string;
    ReJo, OneJo : ISuperObject;
    ArrsJa,ArrsJaSub: TSuperArray;
    wParam: TStrings;
    ReStream:TStringstream;
    nIdx: Integer;
    nO_Valid: string;
    nYear, nMonth, nDays : Word;
    nDataStream: TMsMultiPartFormDataStream;
begin
  Result := False;

  FListA.Clear;
  FListB.Clear;
  FListC.Clear;
  FListD.Clear;
  FListE.Clear;
  Result      := True;
  wParam      := TStringList.Create;
  ReStream    := TStringstream.Create('');
  nDataStream := TMsMultiPartFormDataStream.Create;

  FListA.Text := PackerDecodeStr(FIn.FData);
  try
    wParam.Clear;
    wParam.Values['token']     := Ftoken;

    if FListA.Values['YearPeriod'] <> '' then
    begin
      nYearMonth := FListA.Values['YearPeriod'];
      nYear      := StrToInt(Copy(nYearMonth,1,Pos('-',nYearMonth)-1));
      nMonth     := StrToInt(Copy(nYearMonth,Pos('-',nYearMonth)+1,MaxInt));
      nDays      := DaysInAMonth(nYear,nMonth);
      wParam.Values['starttime'] := FListA.Values['YearPeriod']+'-01 00:00:00';
      wParam.Values['endtime']   := FListA.Values['YearPeriod']+'-'+inttostr(nDays)+' 23:59:59';
    end
    else
    begin
      wParam.Values['starttime'] := DateTime2Str(IncMonth(Now,-1));
      wParam.Values['endtime']   := DateTime2Str(Now);
    end;
    if FListA.Values['Materiel'] <> '' then
      wParam.Values['product_name'] := FListA.Values['Materiel'];
    if FListA.Values['Provider'] <> '' then
      wParam.Values['partner_name'] := FListA.Values['Provider'];

    nStr := 'token:'+Ftoken;
    WriteLog('查询采购订单入参：' + nStr);

    nDataStream.AddFormField('token', Ftoken);
    if FListA.Values['YearPeriod'] <> '' then
    begin
      nYearMonth := FListA.Values['YearPeriod'];
      nYear      := StrToInt(Copy(nYearMonth,1,Pos('-',nYearMonth)-1));
      nMonth     := StrToInt(Copy(nYearMonth,Pos('-',nYearMonth)+1,MaxInt));
      nDays      := DaysInAMonth(nYear,nMonth);
      nDataStream.AddFormField('starttime', FListA.Values['YearPeriod']+'-01 00:00:00');
      if (FListA.Values['Materiel'] = '') and (FListA.Values['Provider'] = '') then
        nDataStream.AddFormField('endtime', FListA.Values['YearPeriod']+'-'+inttostr(nDays)+' 23:59:59'+ CRLF)
      else
        nDataStream.AddFormField('endtime', FListA.Values['YearPeriod']+'-'+inttostr(nDays)+' 23:59:59');
    end
    else
    begin
      nDataStream.AddFormField('starttime', DateTime2Str(IncMonth(Now,-1)));
      if (FListA.Values['Materiel'] = '') and (FListA.Values['Provider'] = '') then
        nDataStream.AddFormField('endtime', DateTime2Str(Now)+ CRLF)
      else
        nDataStream.AddFormField('endtime', DateTime2Str(Now));
    end;

    if FListA.Values['Materiel'] <> '' then
    begin
      nDataStream.AddFormField('product_name', FListA.Values['Materiel']);
    end;
    if FListA.Values['Provider'] <> '' then
    begin
      nDataStream.AddFormField('partner_name', FListA.Values['Provider']);
    end;
    nDataStream.done;

    szUrl := gSysParam.FWXERPUrl + '/purchaseorder';
    FIdHttp.HTTPOptions:=FIdHttp.HTTPOptions+[hoKeepOrigProtocol];
    FidHttp.ProtocolVersion:= pv1_1;
    FidHttp.Request.ContentType := nDataStream.RequestContentType;
    FidHttp.Post(szUrl, nDataStream, ReStream);
    nStr := ReStream.DataString;
    nStr := UTF8Decode(ReStream.DataString);
    nStr := UnicodeToChinese(nStr);


    WriteLog('采购订单出参：' + nStr);
    FListA.Clear;
    FListB.Clear;
    if nStr <> '' then
    begin
      ReJo    := SO(nStr);
      ReJo    := SO(ReJo.S['Response']);
      ArrsJa  := ReJo.A['Infos'];
      if ArrsJa <> nil then
      begin
        if ArrsJa.Length = 0 then
        begin
          WriteLog('此期间无采购订单');
          Result     := True;
          FOut.FData :='';
          FOut.FBase.FResult := True;
        end
        else
        begin
          for nIdx := 0 to ArrsJa.Length - 1 do
          begin
            OneJo := SO(ArrsJa.S[nIdx]);
            
            WriteLog('获取普通原材料进厂计划:'+OneJo.S['ordername']);

            nO_Valid := 'Y';
            if OneJo.B['is_closed'] then
              nO_Valid := 'N'
            else
              nO_Valid := 'Y';

            ArrsJaSub          := OneJo.A['products'];
            try
              nHasDone := SO(ArrsJaSub.S[0]).D['product_qty']
                          - SO(ArrsJaSub.S[0]).D['remainder'];
              nHasDone := Float2PInt(nHasDone, cPrecision, False) / cPrecision;
              if nHasDone <= 0 then
                nHasDone := 0;
            except
              nHasDone := 0;
            end;
            nStr := MakeSQLByStr([
                SF('B_ID',        OneJo.S['ordername']),
                SF('B_ProID',     OneJo.S['partner_name']),
                SF('B_ProName',   OneJo.S['partner_name']),
                SF('B_StockNo',   SO(ArrsJaSub.S[0]).S['productid']),
                SF('B_StockName', SO(ArrsJaSub.S[0]).S['product_name']),
                SF('B_Value',     SO(ArrsJaSub.S[0]).S['product_qty']),
                SF('B_SentValue', FloatToStr(nHasDone)),
                SF('B_RestValue', FloatToStr(SO(ArrsJaSub.S[0]).D['remainder'])),
                SF('B_BStatus',   nO_Valid),
                SF('B_Date',  Now,sfDateTime)
                ], sTable_OrderBase, '', True);
            FListA.Add(nStr);

            nStr := SF('B_ID', OneJo.S['ordername']);
            nStr := MakeSQLByStr([
                SF('B_ProID',     OneJo.S['partner_name']),
                SF('B_ProName',   OneJo.S['partner_name']),
                SF('B_StockNo',   SO(ArrsJaSub.S[0]).S['productid']),
                SF('B_StockName', SO(ArrsJaSub.S[0]).S['product_name']),
                SF('B_Value',     FloatToStr(SO(ArrsJaSub.S[0]).D['product_qty'])),
                SF('B_SentValue', FloatToStr(nHasDone)),
                SF('B_RestValue', FloatToStr(SO(ArrsJaSub.S[0]).D['remainder'])),
                SF('B_BStatus',   nO_Valid),
                SF('B_Date',  Now,sfDateTime)
                ], sTable_OrderBase, nStr, False);
            FListC.Add(nStr);

            nStr := 'Select * from %s where B_ID = ''%s'' ';
            nStr := Format(nStr, [sTable_OrderBase, OneJo.S['ordername']]);
            FListD.Add(nStr);
            
//            if nO_Valid = 'Y' then
//            begin
//              with FListB do
//              begin
//                Values['Order']         := OneJo.S['ordername'];
//                Values['ProName']       := OneJo.S['partner_name'];
//                Values['ProID']         := OneJo.S['partner_name'];
//                ArrsJaSub               := OneJo.A['products'];
//                Values['StockName']     := SO(ArrsJaSub.S[0]).S['product_name'];
//                Values['StockID']       := SO(ArrsJaSub.S[0]).S['productid'];
//                Values['StockNo']       := SO(ArrsJaSub.S[0]).S['productid'];
//                try
//                  nHasDone := StrToFloatDef(SO(ArrsJaSub.S[0]).S['product_qty'],0)
//                              - StrToFloatDef(SO(ArrsJaSub.S[0]).S['remainder'],0);
//                  nHasDone := Float2PInt(nHasDone, cPrecision, False) / cPrecision;
//                  if nHasDone <= 0 then
//                    nHasDone := 0;
//                except
//                  nHasDone := 0;
//                end;
//                Values['PlanValue']     := SO(ArrsJaSub.S[0]).S['product_qty'];//审批量
//                Values['EntryValue']    := FloatToStr(nHasDone);//已进厂量
//                Values['Value']         := FloatToStr(StrToFloatDef(SO(ArrsJaSub.S[0]).S['remainder'], StrToFloat(SO(ArrsJaSub.S[0]).S['product_qty'])));//剩余量
//                Values['Model']         := '';//型号
//                Values['KD']            := '';//矿点
//                FListA.Add(PackerEncodeStr(FListB.Text));
//              end;
//            end;

            FOut.FData := PackerEncodeStr(FListA.Text);
            Result := True;
          end;
        end;
      end                                                             
      else
      begin
        WriteLog('获取采购订单失败');
        Result     := False;
        FOut.FData :='获取采购订单失败';
        FOut.FBase.FResult := True;
      end;
    end;

    if (FListD.Count > 0) then
    try
      FDBConn.FConn.BeginTrans;
      //开启事务
      for nIdx:=0 to FListD.Count - 1 do
      begin
        with gDBConnManager.WorkerQuery(FDBConn,FListD[nIdx]) do
        begin
          if RecordCount>0 then
          begin
            gDBConnManager.WorkerExec(FDBConn,FListC[nIdx]);
          end else
          begin
            gDBConnManager.WorkerExec(FDBConn,FListA[nIdx]);
          end;
        end;
      end;
      FDBConn.FConn.CommitTrans;
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    ReStream.Free;
    nDataStream.Free;
    wParam.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetSaleInfo(var nData: string): Boolean;
var nStr, nProStr, nMatStr, nYearStr: string;
    nO_Valid, nStockName: string;
    nValue: Double;
    nYearMonth,szUrl, nType : string;
    ReJo, OneJo : ISuperObject;
    ArrsJa,ArrsJaSub: TSuperArray;
    wParam: TStrings;
    ReStream,PostStream:TStringstream;
    nIdx: Integer;
    nYear, nMonth, nDays : Word;
    nDataStream: TMsMultiPartFormDataStream;
begin
  Result := True;

  wParam      := TStringList.Create;
  ReStream    := TStringstream.Create('');
  nDataStream := TMsMultiPartFormDataStream.Create;

  FListA.Text := PackerDecodeStr(FIn.FData);
  try
    wParam.Clear;
    wParam.Values['token']     := Ftoken;

    wParam.Values['starttime'] := DateTime2Str(IncMonth(Now,-12));
    wParam.Values['endtime']   := DateTime2Str(Now);

    if FListA.Text <> '' then
      wParam.Values['partner_name'] := FListA.Text;

    nStr := 'token:'+Ftoken;
    WriteLog('查询销售订单入参：' + wParam.Text);

    nDataStream.AddFormField('token', Ftoken);
    nDataStream.AddFormField('starttime', DateTime2Str(IncMonth(Now,-12)));


    if FListA.Text <> '' then
    begin
      nDataStream.AddFormField('endtime', DateTime2Str(Now));
      nDataStream.AddFormField('partner_name', Ansitoutf8(FListA.Text));
    end
    else
      nDataStream.AddFormField('endtime', DateTime2Str(Now) + CRLF);
    nDataStream.done;

    szUrl := gSysParam.FWXERPUrl + '/saleorder';
    nStr      := Ansitoutf8(wParam.Text);
    PostStream:= TStringStream.Create(nStr);

    FIdHttp.HTTPOptions:=FIdHttp.HTTPOptions+[hoKeepOrigProtocol];
    FidHttp.ProtocolVersion:= pv1_1;
    FidHttp.Request.ContentType := nDataStream.RequestContentType;
    FidHttp.Post(szUrl, nDataStream, ReStream);
    nStr := ReStream.DataString;
    nStr := UTF8Decode(ReStream.DataString);
    nStr := UnicodeToChinese(nStr);


    WriteLog('销售订单出参：' + nStr);
    FListA.Clear;
    FListC.Clear;
    FListD.Clear;
    if nStr <> '' then
    begin
      ReJo    := SO(nStr);
      ReJo    := SO(ReJo.S['Response']);
      ArrsJa  := ReJo.A['Infos'];
      if ArrsJa <> nil then
      begin
        if ArrsJa.Length = 0 then
        begin
          WriteLog('此期间无销售订单');
          Result     := True;
          FOut.FData :='';
          FOut.FBase.FResult := True;
        end
        else
        begin
          for nIdx := 0 to ArrsJa.Length - 1 do
          begin
            OneJo := SO(ArrsJa.S[nIdx]);

            ArrsJaSub  := OneJo.A['products'];

            if Pos('袋',SO(ArrsJaSub.S[0]).S['product_uom']) > 0 then
              nType := '袋装'
            else
              nType := '散装';

            if StrToFloatDef(SO(ArrsJaSub.S[0]).S['remainder'],0) <> 0 then
            begin
              //
            end;
            
            nO_Valid := 'Y';
            if OneJo.B['is_closed'] then
              nO_Valid := 'N'
            else
              nO_Valid := 'Y';

            if (Trim(SO(ArrsJaSub.S[0]).S['specification']) <> 'null')
              and (Trim(SO(ArrsJaSub.S[0]).S['specification']) <> '') then
              nStockName := SO(ArrsJaSub.S[0]).S['specification']
            else
              nStockName := SO(ArrsJaSub.S[0]).S['product_name'];

            nStr := MakeSQLByStr([SF('O_Order', OneJo.S['ordername']),
                SF('O_Factory', ''),
                SF('O_CusName', OneJo.S['partner_name']),
                SF('O_ConsignCusName', ''),
                SF('O_StockName', nStockName),
                SF('O_StockType', nType),
                SF('O_Lading', '买方自提'),
                SF('O_CusPY', GetPinYinOfStr(OneJo.S['partner_name'])),
                SF('O_PlanAmount', FloatToStr(SO(ArrsJaSub.S[0]).D['product_qty'])),        //数量
                SF('O_PlanDone', '0'),
                SF('O_PlanRemain', FloatToStr(SO(ArrsJaSub.S[0]).D['remainder'])),          //剩余未出库量
                SF('O_PlanBegin', StrToDateDef(OneJo.S['confirmation_date'],Now),sfDateTime),
                SF('O_PlanEnd', StrToDateDef(OneJo.S['confirmation_date'],Now),sfDateTime),
                SF('O_Company', ''),
                SF('O_Depart', ''),
                SF('O_SaleMan', OneJo.S['seller']),
                SF('O_Remark', ''),
                SF('O_Price', SO(ArrsJaSub.S[0]).D['price_unit'],sfVal),
                SF('O_Valid', nO_Valid),
                SF('O_Freeze', 0, sfVal),
                SF('O_HasDone', 0, sfVal),
                SF('O_CompanyID', ''),
                SF('O_CusID', OneJo.S['partner_name']),
                SF('O_StockID', SO(ArrsJaSub.S[0]).S['productid']),
                SF('O_PackingID', ''),
                SF('O_FactoryID', ''),
                SF('O_Create', Now,sfDateTime),
                SF('O_Modify', Now,sfDateTime)
                ], sTable_SalesOrder, '', True);
            FListA.Add(nStr);

            nStr := SF('O_Order', OneJo.S['ordername']);
            nStr := MakeSQLByStr([
                SF('O_Factory', ''),
                SF('O_CusName', OneJo.S['partner_name']),
                SF('O_ConsignCusName', ''),
                SF('O_StockName', nStockName),
                SF('O_StockType', nType),
                SF('O_Lading', '买方自提'),
                SF('O_CusPY',      GetPinYinOfStr(OneJo.S['partner_name'])),
                SF('O_PlanAmount', FloatToStr(SO(ArrsJaSub.S[0]).D['product_qty'])),
                SF('O_PlanDone', '0'),
                SF('O_PlanRemain',FloatToStr(SO(ArrsJaSub.S[0]).D['remainder'])),
                SF('O_PlanBegin', StrToDateDef(OneJo.S['confirmation_date'],Now),sfDateTime),
                SF('O_PlanEnd', StrToDateDef(OneJo.S['confirmation_date'],Now),sfDateTime),
                SF('O_Company', ''),
                SF('O_Depart', ''),
                SF('O_SaleMan', OneJo.S['seller']),
                SF('O_Remark', ''),
                SF('O_Price', SO(ArrsJaSub.S[0]).D['price_unit'],sfVal),
                SF('O_Valid',  nO_Valid),
                SF('O_Freeze', 0, sfVal),
                SF('O_HasDone', 0, sfVal),
                SF('O_CompanyID', ''),
                SF('O_CusID',   OneJo.S['partner_name']),
                SF('O_StockID', SO(ArrsJaSub.S[0]).S['productid']),
                SF('O_PackingID', ''),
                SF('O_FactoryID', ''),
                SF('O_Create', Now,sfDateTime),
                SF('O_Modify', Now,sfDateTime)
                ], sTable_SalesOrder, nStr, False);
            FListC.Add(nStr);

            nStr := 'Select * from %s where O_Order = ''%s'' ';
            nStr := Format(nStr, [sTable_SalesOrder, OneJo.S['ordername']]);
            FListD.Add(nStr);
          end;
        end;
      end
      else
      begin
        WriteLog('获取销售订单失败');
        Result     := False;
        FOut.FData :='获取销售订单失败';
        FOut.FBase.FResult := True;
      end;
    end;

    if (FListD.Count > 0) then
    try
      FDBConn.FConn.BeginTrans;
      //开启事务
      for nIdx:=0 to FListD.Count - 1 do
      begin
        with gDBConnManager.WorkerQuery(FDBConn,FListD[nIdx]) do
        begin
          if RecordCount>0 then
          begin
            gDBConnManager.WorkerExec(FDBConn,FListC[nIdx]);
          end else
          begin
            gDBConnManager.WorkerExec(FDBConn,FListA[nIdx]);
          end;
        end;
      end;
      FDBConn.FConn.CommitTrans;
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    ReStream.Free;
    nDataStream.Free;
    PostStream.Free;
    wParam.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetLoginToken(var nData: string): Boolean;
var
  nStr, szUrl: string;
  ReJo, ReSubJo : ISuperObject;
  ArrsJa: TSuperArray;
  wParam: TStrings;
  ReStream:TStringstream;
begin
  Result   := True;
  wParam   := TStringList.Create;
  ReStream := TStringstream.Create('');

  try
    wParam.Clear;
    wParam.Values['username']:= FIn.FData;
    wParam.Values['password']:= FIn.FExtParam;
    nStr := 'username:'+FIn.FData+'password'+FIn.FExtParam;
    WriteLog('登录接口入参：' + nStr);

    szUrl := gSysParam.FWXERPUrl+'/login';
    WriteLog('登录接口地址：' + szUrl);
    FidHttp.Request.ContentType := 'application/x-www-form-urlencoded';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := ReStream.DataString;
    nStr := UTF8Decode(ReStream.DataString);
    nStr := UnicodeToChinese(nStr);

    WriteLog('登录接口出参：' + nStr);
    if nStr <> '' then
    begin
      ReJo    := SO(nStr);
      ReSubJo := SO(ReJo.S['Response']);
      if ReSubJo.S['token'] <> '' then
      begin
        Ftoken := ReSubJo.S['token'];
        WriteLog('问信登录Token：' + Ftoken);
        Result := True;
        FOut.FData := sFlag_Yes;
        FOut.FBase.FResult := True;
      end
      else
      begin
        WriteLog('问信登录失败：' + ReSubJo.S['Message']);
        Result     := True;
        FOut.FData := ReSubJo.S['Message'];
        FOut.FBase.FResult := True;
      end;
    end;
  finally
    ReStream.Free;
    wParam.Free;
  end;
end;

function TBusWorkerBusinessHHJY.UnicodeToChinese(inputstr: string): string;
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

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerBusinessHHJY, sPlug_ModuleBus);
end.
