{*******************************************************************************
  作者: dmzn@163.com 2017-09-27
  描述: 系统业务处理
*******************************************************************************}
unit USysBusiness;

{$I Link.inc}
interface

uses
  Windows, DB, Classes, Controls, SysUtils, UBusinessPacker, UBusinessWorker,
  UBusinessConst, ULibFun, UAdjustForm, UFormCtrl, UDataModule, UDataReport,
  UFormBase, cxMCListBox, UMgrPoundTunnels, UMgrCamera, UBase64, USysConst,
  USysDB, USysLoger;

type
  TLadingStockItem = record
    FID: string;         //编号
    FType: string;       //类型
    FName: string;       //名称
    FParam: string;      //扩展
  end;

  TDynamicStockItemArray = array of TLadingStockItem;
  //系统可用的品种列表

  PZTLineItem = ^TZTLineItem;
  TZTLineItem = record
    FID       : string;      //编号
    FName     : string;      //名称
    FStock    : string;      //品名
    FWeight   : Integer;     //袋重
    FValid    : Boolean;     //是否有效
    FPrinterOK: Boolean;     //喷码机
  end;

  PZTTruckItem = ^TZTTruckItem;
  TZTTruckItem = record
    FTruck    : string;      //车牌号
    FLine     : string;      //通道
    FBill     : string;      //提货单
    FValue    : Double;      //提货量
    FDai      : Integer;     //袋数
    FTotal    : Integer;     //总数
    FInFact   : Boolean;     //是否进厂
    FIsRun    : Boolean;     //是否运行    
  end;

  TZTLineItems = array of TZTLineItem;
  TZTTruckItems = array of TZTTruckItem;

  PSalePlanItem = ^TSalePlanItem;
  TSalePlanItem = record
    FOrderNo: string;        //订单号     
    FInterID: string;        //主表编号
    FEntryID: string;        //附表编号
    FStockID: string;        //物料编号
    FStockName: string;      //物料名称

    FTruck: string;          //车牌号码
    FValue: Double;          //开单量
    FSelected: Boolean;      //状态
  end;
  TSalePlanItems = array of TSalePlanItem;
  
//------------------------------------------------------------------------------
function AdjustHintToRead(const nHint: string): string;
//调整提示内容
function WorkPCHasPopedom: Boolean;
//验证主机是否已授权
function GetSysValidDate: Integer;
//获取系统有效期
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean = True): string;
//获取串行编号
function GetLadingStockItems(var nItems: TDynamicStockItemArray): Boolean;
//可用品种列表
function GetCardUsed(const nCard: string): string;
//获取卡片类型
function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
//读取系统字典项
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
//读取业务员列表
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
//读取客户列表

function VerifyFQSumValue: Boolean;
//是否校验封签号
function SaveBill(const nBillData: string): string;
//保存交货单
function DeleteBill(const nBill: string): Boolean;
//删除交货单
function PostBill(const nBill: string): Boolean;
//交货单过账
function ReserveBill(const nBill: string): Boolean;
//交货单冲销
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
//更改提货车辆
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
//交货单调拨
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
//为交货单办理磁卡
function SaveBillLSCard(const nCard,nTruck: string): Boolean;
//办理厂内零售磁卡
function SaveBillCard(const nBill, nCard: string): Boolean;
//保存交货单磁卡
function LogoutBillCard(const nCard: string): Boolean;
//注销指定磁卡
function SetTruckRFIDCard(nTruck: string; var nRFIDCard: string;
  var nIsUse: string; nOldCard: string=''): Boolean;
//绑定车辆电子标签

function GetLadingBills(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//获取指定岗位的交货单列表
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
//载入单据信息到列表
function SaveLadingBills(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil;const nLogin: Integer = -1): Boolean;
//保存指定岗位的交货单

function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
//获取指定车辆的已称皮重信息
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems;const nLogin: Integer = -1): Boolean;
//保存车辆过磅记录
function ReadPoundCard(const nTunnel: string; var nReader: string): string;
//读取指定磅站读头上的卡号
procedure CapturePicture(const nTunnel: PPTTunnelItem;
                         const nLogin: Integer; nList: TStrings);
//抓拍指定通道
function GetTruckNO(const nTruck: WideString; const nLong: Integer=12): string;
function GetValue(const nValue: Double): string;
//显示格式化

function GetTruckEmptyValue(const nTruck: string): Double;
//获取车辆皮重
function GetTruckLastTime(const nTruck: string): Integer;
//最后一次过磅时间
function IsStrictSanValue: Boolean;
//判断是否严格执行散装禁止超发

procedure GetPoundAutoWuCha(var nWCValZ,nWCValF: Double; const nVal: Double;
 const nStation: string = '');
//获取误差范围
function AddManualEventRecord(const nEID,nKey,nEvent:string;
 const nFrom: string = sFlag_DepBangFang ;
 const nSolution: string = sFlag_Solution_YN;
 const nDepartmen: string = sFlag_DepDaTing;
 const nReset: Boolean = False; const nMemo: string = ''): Boolean;
//添加待处理事项记录
function VerifyManualEventRecord(const nEID: string; var nHint: string;
 const nWant: string = sFlag_Yes): Boolean;
//检查事件是否通过处理

function IsTunnelOK(const nTunnel: string): Boolean;
//查询通道光栅是否正常
procedure TunnelOC(const nTunnel: string; const nOpen: Boolean);
//控制通道红绿灯开合
procedure ProberShowTxt(const nTunnel, nText: string);
//车检发送小屏
function PlayNetVoice(const nText,nCard,nContent: string): Boolean;
//经中间件播发语音

function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean = False): Boolean;
//读取车辆队列
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
//启停喷码机
function ChangeDispatchMode(const nMode: Byte): Boolean;
//切换调度模式
function OpenDoorByReader(const nReader: string; nType: string = 'Y'): Boolean;
//读卡器打开道闸

function GetHYMaxValue: Double;
function GetHYValueByStockNo(const nNo: string): Double;
//获取化验单已开量

function getCustomerInfo(const nData: string): string;
//获取客户注册信息
function get_Bindfunc(const nData: string): string;
//客户与微信账号绑定
function send_event_msg(const nData: string): string;
//发送消息
function edit_shopclients(const nData: string): string;
//新增商城用户
function edit_shopgoods(const nData: string): string;
//添加商品
function get_shoporders(const nData: string): string;
//获取订单信息
function complete_shoporders(const nData: string): string;
//更新订单状态
procedure SaveWebOrderMsg(const nLID, nWebOrderID: string);
//插入推送消息

//------------------------------------------------------------------------------
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
//打印提货单
function PrintCNSReport(nBill: string; const nAsk: Boolean): Boolean;
//打印质量承诺书
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
//打印榜单
function PrintPoundOtherReport(const nPound: string; nAsk: Boolean): Boolean;
//打印临时称重过磅单
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean): Boolean;
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
//化验单,合格证
function PrintBillHD(const nBatcode: string; const nAsk: Boolean): Boolean;
//打印销售回答

function SetOrderCard(const nOrder,nTruck: string; nVerify: Boolean): Boolean;
//为采购单办理磁卡

function LogoutOrderCard(const nCard: string;const nNeiDao:string=''): Boolean;
//注销指定磁卡

function DeleteOrder(const nOrder: string): Boolean;
//删除采购单

function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
//修改车牌号

function PrintOrderReport(const nOrder: string;  const nAsk: Boolean): Boolean;
//打印采购单

function SaveOrder(const nOrderData: string): string;

function SaveOrderCard(const nOrder, nCard: string): Boolean;
//保存采购单磁卡

//获取预置皮重车辆预置信息
function getPrePInfo(const nTruck:string;var nPrePValue: Double; var nPrePMan: string;
  var nPrePTime: TDateTime):Boolean;
function GetLastPInfo(const nID:string;var nPValue: Double; var nPMan: string;
  var nPTime: TDateTime):Boolean;

function GetPurchaseOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//获取指定岗位的采购单列表
function SavePurchaseOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil;const nLogin: Integer = -1): Boolean;
//保存指定岗位的采购单

procedure LoadOrderItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);

function SyncPProvider(const nProID: string): Boolean;
//同步ERP采购供应商
function SyncPMaterail(const nMID: string): Boolean;
//同步ERP采购物料
function GetHhOrderPlan(const nStr: string): string;
//获取ERP采购进厂计划
function GetHhSaleWTTruck(const nStr: string): string;
//获取ERP委托车辆
function SyncHhOrderData(const nDID: string): Boolean;
//同步ERP采购磅单
function GetHhNeiDaoOrderPlan(const nStr: string): string;
//获取ERP采购内倒进厂计划
function SyncHhNdOrderData(const nDID: string): Boolean;
//同步ERP内倒采购磅单
function SyncHhOtherOrderData(const nDID: string): Boolean;
//同步ERP备品备件采购磅单
function GetCardGInvalid: Boolean;
//长期卡是否失效
function GetShipName(const nStockName :string): string;
//Desc: 获取码头船号(上次同品种)
function GetLastPID(const nOID :string): string;
//Desc: 获取最新磅单号
function GetHhSalePlan(const nFactoryName: string): Boolean;
//获取ERP销售计划
function SyncSMaterail(const nMID: string): Boolean;
//获取ERP销售物料
function SyncSCustomer(const nCusID: string): Boolean;
//Desc: 同步ERP销售客户
function SyncHhSaleDetail(const nDID: string): Boolean;
//Desc: 同步ERP销售明细
procedure SaveTruckPrePValue(const nTruck, nValue: string);
//保存预制皮重
function GetPrePValueSet: Double;
//获取系统设定皮重
function GetMinNetValue: Double;
//获取销售净重限值
function SaveTruckPrePicture(const nTruck: string;const nTunnel: PPTTunnelItem;
                             const nLogin: Integer = -1): Boolean;
//保存nTruck的预制皮重照片
function InitCapture(const nTunnel: PPTTunnelItem; var nLogin: Integer): Boolean;
//初始化抓拍(因中材安徽抓拍出现客户端崩溃,改为打开称重界面进行初始化)
function FreeCapture(nLogin: Integer): Boolean;
//释放抓拍
procedure UpdateTruckStatus(const nID: string);
//修改车辆状态
function GetMaxMValue(const nID: string): Double;
//获取毛重限值
function GetSaleOrderRestValue(const nID: string): Double;
//获取订单余量
function IsTruckCanPound(const nItem: TLadingBillItem): Boolean;
//临时销售订单业务车辆是否可以上磅
function GetBatchCode(const nStockNo,nCusName: string; nValue: Double): string;
//获取批次号
function GetStockNo(const nStockName,nStockType: string): string;
//获取物料编号
procedure SaveWebOrderDelMsg(const nLID, nBillType: string);
//插入推送消息
function GetSaleOrderDoneValue(const nOID: string): string;
//查询外运业务完成量
function GetSaleOrderFreezeValue(const nOID: string): string;
//查询外运业务冻结量
function CheckTruckCard(const nTruck: string; var nLID: string): Boolean;
//检查车辆是否存在未注销磁卡的提货单(针对外运业务)
function IsOtherOrder(const nItem: TLadingBillItem): Boolean;
 //检查是否为临时订单
function IsTruckTimeOut(const nLID: string): Boolean;
//验证车辆是否出厂超时
function GetEventDept: string;
//获取过磅事件推送部门

//=====================================================================
function SyncPProviderWSDL(const nProID: string): Boolean;
//同步ERP采购供应商
function GetHhOrderPlanWSDL(const nStr: string): string;
//获取ERP采购进厂计划
function GetHhSaleWTTruckWSDL(const nStr: string): string;
//获取ERP委托车辆
function SyncHhOrderDataWSDL(const nDID: string): Boolean;
//同步ERP采购磅单
function GetHhNeiDaoOrderPlanWSDL(const nStr: string): string;
//获取ERP采购内倒进厂计划
function SyncHhNdOrderDataWSDL(const nDID: string): Boolean;
//同步ERP内倒采购磅单
function SyncHhOtherOrderDataWSDL(const nDID: string): Boolean;
//同步ERP备品备件采购磅单
function GetHhSalePlanWSDL(const nWhere, nFactoryName: string): Boolean;
//获取ERP销售计划
function SyncSMaterailWSDL(const nMID: string): Boolean;
//获取ERP销售物料
function SyncSCustomerWSDL(const nCusID: string): Boolean;
//Desc: 同步ERP销售客户
function SyncHhSaleDetailWSDL(const nDID: string): Boolean;
//Desc: 同步ERP销售明细
function GetHhSaleWareNumberWSDL(const nOrder, nValue: string;
                                 var nHint: string): string;
//Desc: 获取批次号
function PoundVerifyHhSalePlanWSDL(const nLID: string; nValue: Double;
                                   nPriceDate:string; var nHint: string): Boolean;
//===================================================================
function GetCusID(const nCusName :string): string;
function IsMulMaoStock(const nStockNo :string): Boolean;
function IsAsternStock(const nStockName :string): Boolean;

implementation

//Desc: 记录日志
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(nEvent);
end;

//------------------------------------------------------------------------------
//Desc: 调整nHint为易读的格式
function AdjustHintToRead(const nHint: string): string;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Text := nHint;
    for nIdx:=0 to nList.Count - 1 do
      nList[nIdx] := '※.' + nList[nIdx];
    Result := nList.Text;
  finally
    nList.Free;
  end;
end;

//Desc: 验证主机是否已授权接入系统
function WorkPCHasPopedom: Boolean;
begin
  Result := gSysParam.FSerialID <> '';
  if not Result then
  begin
    ShowDlg('该功能需要更高权限,请向管理员申请.', sHint);
  end;
end;

//Date: 2017-09-27
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的业务命令对象
function CallBusinessCommand(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2017-09-27
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessSaleBill(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessSaleBill);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2017-09-27
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessPurchaseOrder(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessPurchaseOrder);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2017-09-27
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessHardware(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_HardwareCommand);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2017-10-26
//Parm: 命令;数据;参数;服务地址;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessWechat(const nCmd: Integer; const nData,nExt,nSrvURL: string;
  const nOut: PWorkerWebChatData; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerWebChatData;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;
    nIn.FRemoteUL := nSrvURL;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //close hint param
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessWebchat);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2017-10-26
//Parm: 命令;数据;参数;服务地址;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessHHJY(const nCmd: Integer; const nData,nExt,nSrvURL: string;
  const nOut: PWorkerHHJYData; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerHHJYData;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;
    nIn.FRemoteUL := nSrvURL;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //close hint param

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessHHJY);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2017-09-27
//Parm: 分组;对象;使用日期编码模式
//Desc: 依据nGroup.nObject生成串行编号
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean): string;
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Group'] := nGroup;
    nList.Values['Object'] := nObject;

    if nUseDate then
         nStr := sFlag_Yes
    else nStr := sFlag_No;

    if CallBusinessCommand(cBC_GetSerialNO, nList.Text, nStr, @nOut) then
      Result := nOut.FData;
    //xxxxx
  finally
    nList.Free;
  end;   
end;

//Desc: 获取系统有效期
function GetSysValidDate: Integer;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_IsSystemExpired, '', '', @nOut) then
       Result := StrToInt(nOut.FData)
  else Result := 0;
end;

function GetCardUsed(const nCard: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_GetCardUsed, nCard, '', @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

//Desc: 获取当前系统可用的水泥品种列表
function GetLadingStockItems(var nItems: TDynamicStockItemArray): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select D_Value,D_Memo,D_ParamB From $Table ' +
          'Where D_Name=''$Name'' Order By D_Index ASC';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_StockItem)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    SetLength(nItems, RecordCount);
    if RecordCount > 0 then
    begin
      nIdx := 0;
      First;

      while not Eof do
      begin
        nItems[nIdx].FType := FieldByName('D_Memo').AsString;
        nItems[nIdx].FName := FieldByName('D_Value').AsString;
        nItems[nIdx].FID := FieldByName('D_ParamB').AsString;

        Next;
        Inc(nIdx);
      end;
    end;
  end;

  Result := Length(nItems) > 0;
end;

//Date: 2017-10-01
//Parm: 字典项;列表
//Desc: 从SysDict中读取nItem项的内容,存入nList中
function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
var nStr: string;
begin
  nList.Clear;
  nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                      MI('$Name', nItem)]);
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with Result do
  begin
    First;

    while not Eof do
    begin
      nList.Add(FieldByName('D_Value').AsString);
      Next;
    end;
  end else Result := nil;
end;

//Desc: 读取业务员列表到nList中,包含附加数据
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'S_ID=Select S_ID,S_PY,S_Name From %s ' +
          'Where IsNull(S_InValid, '''')<>''%s'' %s Order By S_PY';
  nStr := Format(nStr, [sTable_Salesman, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.', DSA(['S_ID']));
  
  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: 读取客户列表到nList中,包含附加数据
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'C_ID=Select C_ID,C_Name From %s ' +
          'Where IsNull(C_XuNi, '''')<>''%s'' %s Order By C_PY';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.');

  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//------------------------------------------------------------------------------
//Date: 2017-09-27
//Parm: 记录标识;车牌号;图片文件
//Desc: 将nFile存入数据库
procedure SavePicture(const nID, nTruck, nMate, nFile: string);
var nStr: string;
    nRID: Integer;
begin
  FDM.ADOConn.BeginTrans;
  try
    nStr := MakeSQLByStr([
            SF('P_ID', nID),
            SF('P_Name', nTruck),
            SF('P_Mate', nMate),
            SF('P_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Picture, '', True);
    //xxxxx

    if FDM.ExecuteSQL(nStr) < 1 then Exit;
    nRID := FDM.GetFieldMax(sTable_Picture, 'R_ID');

    nStr := 'Select P_Picture From %s Where R_ID=%d';
    nStr := Format(nStr, [sTable_Picture, nRID]);
    FDM.SaveDBImage(FDM.QueryTemp(nStr), 'P_Picture', nFile);

    FDM.ADOConn.CommitTrans;
  except
    FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: 构建图片路径
function MakePicName: string;
begin
  while True do
  begin
    Result := gSysParam.FPicPath + IntToStr(gSysParam.FPicBase) + '.jpg';
    if not FileExists(Result) then
    begin
      Inc(gSysParam.FPicBase);
      Exit;
    end;

    DeleteFile(Result);
    if FileExists(Result) then Inc(gSysParam.FPicBase)
  end;
end;

//Date: 2017-09-27
//Parm: 通道;列表
//Desc: 抓拍nTunnel的图像
procedure CapturePicture(const nTunnel: PPTTunnelItem;
                         const nLogin: Integer; nList: TStrings);
const
  cRetry = 2;
  //重试次数
var nStr: string;
    nIdx,nInt: Integer;
    nErr: Integer;
    nPic: NET_DVR_JPEGPARA;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  nList.Clear;
  if not Assigned(nTunnel.FCamera) then Exit;
  //not camera
  if nLogin <= -1 then Exit;

  WriteLog(nTunneL.FID + '开始抓拍');
  if not DirectoryExists(gSysParam.FPicPath) then
    ForceDirectories(gSysParam.FPicPath);
  //new dir

  if gSysParam.FPicBase >= 100 then
    gSysParam.FPicBase := 0;
  //clear buffer

  try

    nPic.wPicSize := nTunnel.FCamera.FPicSize;
    nPic.wPicQuality := nTunnel.FCamera.FPicQuality;

    for nIdx:=Low(nTunnel.FCameraTunnels) to High(nTunnel.FCameraTunnels) do
    begin
      if nTunnel.FCameraTunnels[nIdx] = MaxByte then continue;
      //invalid

      for nInt:=1 to cRetry do
      begin
        nStr := MakePicName();
        //file path

        gCameraNetSDKMgr.NET_DVR_CaptureJPEGPicture(nLogin,
                                   nTunnel.FCameraTunnels[nIdx],
                                   nPic, nStr);
        //capture pic

        nErr := gCameraNetSDKMgr.NET_DVR_GetLastError;

        if nErr = 0 then
        begin
          WriteLog('通道'+IntToStr(nTunnel.FCameraTunnels[nIdx])+'抓拍成功');
          nList.Add(nStr);
          Break;
        end;

        if nIdx = cRetry then
        begin
          nStr := '抓拍图像[ %s.%d ]失败,错误码: %d';
          nStr := Format(nStr, [nTunnel.FCamera.FHost,
                   nTunnel.FCameraTunnels[nIdx], nErr]);
          WriteLog(nStr);
        end;
      end;
    end;
  except
  end;
end;

//------------------------------------------------------------------------------
//Date: 2017-10-17
//Parm: 车牌号;保留长度
//Desc: 将nTruck整合为长度为nLen的字符串
function GetTruckNO(const nTruck: WideString; const nLong: Integer): string;
var nStr: string;
    nIdx,nLen,nPos: Integer;
begin
  nPos := 0;
  nLen := 0;

  for nIdx:=Length(nTruck) downto 1 do
  begin
    nStr := nTruck[nIdx];
    nLen := nLen + Length(nStr);

    if nLen >= nLong then Break;
    nPos := nIdx;
  end;

  Result := Copy(nTruck, nPos, Length(nTruck));
  nIdx := nLong - Length(Result);
  Result := Result + StringOfChar(' ', nIdx);
end;

function GetValue(const nValue: Double): string;
var nStr: string;
begin
  nStr := Format('      %.2f', [nValue]);
  Result := Copy(nStr, Length(nStr) - 6 + 1, 6);
end;

//Date: 2017-09-27
//Parm: 包装正负误差;票重;磅站号
//Desc: 计算nVal的误差范围
procedure GetPoundAutoWuCha(var nWCValZ,nWCValF: Double; const nVal: Double;
 const nStation: string);
var nStr: string;
begin
  nWCValZ := 0;
  nWCValF := 0;
  if nVal <= 0 then Exit;

  nStr := 'Select * From %s Where P_Start<=%.2f and P_End>%.2f';
  nStr := Format(nStr, [sTable_PoundDaiWC, nVal, nVal]);

  if Length(nStation) > 0 then
    nStr := nStr + ' And P_Station=''' + nStation + '''';
  //xxxxx

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    if FieldByName('P_Percent').AsString = sFlag_Yes then 
    begin
      nWCValZ := nVal * 1000 * FieldByName('P_DaiWuChaZ').AsFloat;
      nWCValF := nVal * 1000 * FieldByName('P_DaiWuChaF').AsFloat;
      //按比例计算误差
    end else
    begin     
      nWCValZ := FieldByName('P_DaiWuChaZ').AsFloat;
      nWCValF := FieldByName('P_DaiWuChaF').AsFloat;
      //按固定值计算误差
    end;
  end;
end;

//Date: 2017-09-27
//Parm: 参数描述
//Desc: 添加异常事件处理
function AddManualEventRecord(const nEID,nKey,nEvent:string;
 const nFrom,nSolution,nDepartmen: string;
 const nReset: Boolean; const nMemo: string): Boolean;
var nStr: string;
    nUpdate: Boolean;
begin
  Result := False;
  if Trim(nSolution) = '' then
  begin
    WriteLog('请选择处理方案.');
    Exit;
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nEID]);

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    nStr := '事件记录:[ %s ]已存在';
    WriteLog(Format(nStr, [nEID]));

    if not nReset then Exit;
    nUpdate := True;
  end else nUpdate := False;

  nStr := SF('E_ID', nEID);
  nStr := MakeSQLByStr([
          SF('E_ID', nEID),
          SF('E_Key', nKey),
          SF('E_From', nFrom),
          SF('E_Memo', nMemo),
          SF('E_Result', 'Null', sfVal),
          
          SF('E_Event', nEvent),
          SF('E_Solution', nSolution),
          SF('E_Departmen', nDepartmen),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx

  FDM.ExecuteSQL(nStr);
  Result := True;
end;

//Date: 2017-09-27
//Parm: 事件ID;预期结果;错误返回
//Desc: 判断事件是否处理
function VerifyManualEventRecord(const nEID: string; var nHint: string;
 const nWant: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select E_Result, E_Event From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nEID]);

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Trim(FieldByName('E_Result').AsString);
    if nStr = '' then
    begin
//      nHint := FieldByName('E_Event').AsString;
      Exit;
    end;

    if nStr <> nWant then
    begin
      nHint := '请联系管理员，做换票处理';
      Exit;
    end;

    Result := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2017-09-27
//Parm: 通道号
//Desc: 查询nTunnel的光栅状态是否正常
function IsTunnelOK(const nTunnel: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessHardware(cBC_IsTunnelOK, nTunnel, '', @nOut) then
       Result := nOut.FData = sFlag_Yes
  else Result := False;
end;

procedure TunnelOC(const nTunnel: string; const nOpen: Boolean);
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nOpen then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  CallBusinessHardware(cBC_TunnelOC, nTunnel, nStr, @nOut);
end;

procedure ProberShowTxt(const nTunnel, nText: string);
var nOut: TWorkerBusinessCommand;
begin
  CallBusinessHardware(cBC_ShowTxt, nTunnel, nText, @nOut);
end;

//Date: 2017-09-27
//Parm: 文本;语音卡;内容
//Desc: 用nCard播发nContent模式的nText文本.
function PlayNetVoice(const nText,nCard,nContent: string): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := 'Card=' + nCard + #13#10 +
          'Content=' + nContent + #13#10 + 'Truck=' + nText;
  //xxxxxx

  Result := CallBusinessHardware(cBC_PlayVoice, nStr, '', @nOut);
  if not Result then
    WriteLog(nOut.FBase.FErrDesc);
  //xxxxx
end;

//Date: 2017-09-27
//Parm: 车牌号
//Desc: 获取nTruck的称皮记录
function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetTruckPoundData, nTruck, '', @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nPoundData);
  //xxxxx
end;

//Date: 2017-09-27
//Parm: 称重数据
//Desc: 保存nData称重数据
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems; const nLogin: Integer): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessCommand(cBC_SaveTruckPoundData, nStr, '', @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  nList := TStringList.Create;
  try
    try
      CapturePicture(nTunnel, nLogin, nList);
      //capture file
    except
      on e: Exception do
      begin
        WriteLog('抓拍失败:'+e.Message);
      end;
    end;

    for nIdx:=0 to nList.Count - 1 do
      SavePicture(nOut.FData, nData[0].FTruck,
                              nData[0].FStockName, nList[nIdx]);
    //save file
  finally
    nList.Free;
  end;
end;

//Date: 2017-09-27
//Parm: 通道号
//Desc: 读取nTunnel读头上的卡号
function ReadPoundCard(const nTunnel: string; var nReader: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nReader:= '';
  //卡号

  if CallBusinessHardware(cBC_GetPoundCard, nTunnel, '', @nOut) then
  begin
    Result := Trim(nOut.FData);
    nReader:= Trim(nOut.FExtParam);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2017-09-27
//Parm: 通道;车辆
//Desc: 读取车辆队列数据
function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean): Boolean;
var nIdx: Integer;
    nSLine,nSTruck: string;
    nListA,nListB: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    if nRefreshLine then
         nSLine := sFlag_Yes
    else nSLine := sFlag_No;

    Result := CallBusinessHardware(cBC_GetQueueData, nSLine, '', @nOut);
    if not Result then Exit;

    nListA.Text := PackerDecodeStr(nOut.FData);
    nSLine := nListA.Values['Lines'];
    nSTruck := nListA.Values['Trucks'];

    nListA.Text := PackerDecodeStr(nSLine);
    SetLength(nLines, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nLines[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FID       := Values['ID'];
      FName     := Values['Name'];
      FStock    := Values['Stock'];
      FValid    := Values['Valid'] <> sFlag_No;
      FPrinterOK:= Values['Printer'] <> sFlag_No;

      if IsNumber(Values['Weight'], False) then
           FWeight := StrToInt(Values['Weight'])
      else FWeight := 1;
    end;

    nListA.Text := PackerDecodeStr(nSTruck);
    SetLength(nTrucks, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nTrucks[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FTruck    := Values['Truck'];
      FLine     := Values['Line'];
      FBill     := Values['Bill'];

      if IsNumber(Values['Value'], True) then
           FValue := StrToFloat(Values['Value'])
      else FValue := 0;

      FInFact   := Values['InFact'] = sFlag_Yes;
      FIsRun    := Values['IsRun'] = sFlag_Yes;
           
      if IsNumber(Values['Dai'], False) then
           FDai := StrToInt(Values['Dai'])
      else FDai := 0;

      if IsNumber(Values['Total'], False) then
           FTotal := StrToInt(Values['Total'])
      else FTotal := 0;
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

//Date: 2017-09-27
//Parm: 通道号;启停标识
//Desc: 启停nTunnel通道的喷码机
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nEnable then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  CallBusinessHardware(cBC_PrinterEnable, nTunnel, nStr, @nOut);
end;

//Date: 2017-09-27
//Parm: 调度模式
//Desc: 切换系统调度模式为nMode
function ChangeDispatchMode(const nMode: Byte): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessHardware(cBC_ChangeDispatchMode, IntToStr(nMode), '',
            @nOut);
  //xxxxx
end;

//Date: 2017-09-27
//Parm: 开单数据
//Desc: 保存交货单,返回交货单号列表
function SaveBill(const nBillData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessSaleBill(cBC_SaveBills, nBillData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2017-09-27
//Parm: 交货单号
//Desc: 删除nBill单据
function DeleteBill(const nBill: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_DeleteBill, nBill, '', @nOut);
end;

//Date: 2017-10-10
//Parm: 交货单号
//Desc: 过账nBill单据
function PostBill(const nBill: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_PostBill, nBill, '', @nOut);
end;

//Date: 2017-10-14
//Parm: 交货单号
//Desc: 冲销nBill单据
function ReserveBill(const nBill: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_ReverseBill, nBill, '', @nOut);
end;

//Date: 2017-09-27
//Parm: 交货单;新车牌
//Desc: 修改nBill的车牌为nTruck.
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_ModifyBillTruck, nBill, nTruck, @nOut);
end;

//Date: 2017-09-27
//Parm: 交货单;纸卡
//Desc: 将nBill调拨给nNewZK的客户
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaleAdjust, nBill, nNewZK, @nOut);
end;

//Date: 2017-09-27
//Parm: 交货单;车牌号;校验制卡开关
//Desc: 为nBill交货单制卡
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nBill;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Sale;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Desc: 是否需要验证封签
function VerifyFQSumValue: Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_VerifyFQValue]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsString = sFlag_Yes;
  //xxxxx
end;

//Date: 2017-09-27
//Parm: 磁卡号;车牌号
//Desc: 为nTruck办理厂内零售磁卡
function SaveBillLSCard(const nCard,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaveBillLSCard, nCard, nTruck, @nOut);
end;

//Date: 2017-09-27
//Parm: 交货单号;磁卡
//Desc: 绑定nBill.nCard
function SaveBillCard(const nBill, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaveBillCard, nBill, nCard, @nOut);
end;

//Date: 2017-09-27
//Parm: 磁卡号
//Desc: 注销nCard
function LogoutBillCard(const nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_LogoffCard, nCard, '', @nOut);
end;

//Date: 2017-09-27
//Parm: 磁卡号;岗位;交货单列表
//Desc: 获取nPost岗位上磁卡为nCard的交货单列表
function GetLadingBills(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nBills);
  //xxxxx
end;

//Date: 2017-09-27
//Parm: 岗位;交货单列表;磅站通道
//Desc: 保存nPost岗位上的交货单数据
function SaveLadingBills(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem;const nLogin: Integer): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessSaleBill(cBC_SavePostBills, nStr, nPost, @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  if Assigned(nTunnel) then //过磅称重
  begin
    nList := TStringList.Create;
    try
      CapturePicture(nTunnel, nLogin, nList);
      //capture file

      for nIdx:=0 to nList.Count - 1 do
        SavePicture(nOut.FData, nData[0].FTruck,
                                nData[0].FStockName, nList[nIdx]);
      //save file
    finally
      nList.Free;
    end;
  end;
end;

//Date: 2017-09-27
//Parm: 交货单项; MCListBox;分隔符
//Desc: 将nItem载入nMC
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  with nItem,nMC do
  begin
    Clear;
    Add(Format('车牌号码:%s %s', [nDelimiter, FTruck]));
    Add(Format('当前状态:%s %s', [nDelimiter, TruckStatusToStr(FStatus)]));

    Add(Format('%s ', [nDelimiter]));
    Add(Format('交货单号:%s %s', [nDelimiter, FId]));
    Add(Format('交货数量:%s %.3f 吨', [nDelimiter, FValue]));
    if FType = sFlag_Dai then nStr := '袋装' else nStr := '散装';

    Add(Format('品种类型:%s %s', [nDelimiter, nStr]));
    Add(Format('品种名称:%s %s', [nDelimiter, FStockName]));
    
    Add(Format('%s ', [nDelimiter]));
    Add(Format('提货磁卡:%s %s', [nDelimiter, FCard]));
    Add(Format('单据类型:%s %s', [nDelimiter, BillTypeToStr(FIsVIP)]));
    Add(Format('客户名称:%s %s', [nDelimiter, FCusName]));
  end;
end;

//Date: 2017-09-27
//Parm: 车牌号；电子标签；是否启用；旧电子标签
//Desc: 读标签是否成功；新的电子标签
function SetTruckRFIDCard(nTruck: string; var nRFIDCard: string;
  var nIsUse: string; nOldCard: string=''): Boolean;
var nP: TFormCommandParam;
begin
  nP.FParamA := nTruck;
  nP.FParamB := nOldCard;
  nP.FParamC := nIsUse;
  CreateBaseFormItem(cFI_FormMakeRFIDCard, '', @nP);

  nRFIDCard := nP.FParamB;
  nIsUse    := nP.FParamC;
  Result    := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Desc: 车辆有效皮重
function GetTruckEmptyValue(const nTruck: string): Double;
var nStr: string;
begin
  Result := 0;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_VerifyTruckP]);

  with FDM.QueryTemp(nStr) do
  if Recordcount > 0 then
  begin
    nStr := Fields[0].AsString;
    if nStr <> sFlag_Yes then Exit;
    //不校验皮重
  end;

  nStr := 'Select T_PValue From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsFloat;
  //xxxxx
end;

//Date: 2017-09-27
//Parm: 车牌号
//Desc: 查看车辆上次过磅时间间隔
function GetTruckLastTime(const nTruck: string): Integer;
var nStr: string;
    nNow, nPDate, nMDate: TDateTime;
begin
  Result := -1;
  //默认允许

  nStr := 'Select Top 1 %s as T_Now,P_PDate,P_MDate ' +
          'From %s Where P_Truck=''%s'' Order By P_ID Desc';
  nStr := Format(nStr, [sField_SQLServer_Now, sTable_PoundLog, nTruck]);
  //选择最后一次过磅

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nNow   := FieldByName('T_Now').AsDateTime;
    nPDate := FieldByName('P_PDate').AsDateTime;
    nMDate := FieldByName('P_MDate').AsDateTime;

    if nPDate > nMDate then
         Result := Trunc((nNow - nPDate) * 24 * 60 * 60)
    else Result := Trunc((nNow - nMDate) * 24 * 60 * 60);
  end;
end;

//Desc: 严格控制散装超发
function IsStrictSanValue: Boolean;
var nSQL: string;
begin
  Result := False;

  nSQL := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, sFlag_StrictSanVal]);

  with FDM.QueryTemp(nSQL) do
   if RecordCount > 0 then
    Result := Fields[0].AsString = sFlag_Yes;
  //xxxxx
end;

//Date: 2017-09-27
//Parm: 读卡器;主&副
//Desc: 道闸抬杆
function OpenDoorByReader(const nReader: string; nType: string = 'Y'): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessHardware(cBC_OpenDoorByReader, nReader, nType,
            @nOut, False);
  //xxxxx
end;  

//------------------------------------------------------------------------------
//Desc: 每批次最大量
function GetHYMaxValue: Double;
var nStr: string;
begin
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_HYValue]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsFloat
  else Result := 0;
end;

//Desc: 获取nNo水泥编号的已开量
function GetHYValueByStockNo(const nNo: string): Double;
var nStr: string;
begin
  nStr := 'Select R_SerialNo,Sum(H_Value) From %s ' +
          ' Left Join %s on H_SerialNo= R_SerialNo ' +
          'Where R_SerialNo=''%s'' Group By R_SerialNo';
  nStr := Format(nStr, [sTable_StockRecord, sTable_StockHuaYan, nNo]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[1].AsFloat
  else Result := -1;
end;

//------------------------------------------------------------------------------
//获取客户注册信息
function getCustomerInfo(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_getCustomerInfo, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//客户与微信账号绑定
function get_Bindfunc(const nData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessWechat(cBC_WX_get_Bindfunc, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//发送消息
function send_event_msg(const nData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessWechat(cBC_WX_send_event_msg, nData, '', '', @nOut,false) then
       Result := nOut.FData
  else Result := '';
end;

//新增商城用户
function edit_shopclients(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_edit_shopclients, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//添加商品
function edit_shopgoods(const nData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessWechat(cBC_WX_edit_shopgoods, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//获取订单信息
function get_shoporders(const nData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessWechat(cBC_WX_get_shoporders, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//更新订单状态
function complete_shoporders(const nData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessWechat(cBC_WX_complete_shoporders, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//------------------------------------------------------------------------------
//Desc: 打印提货单
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印提货单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //添加引号
  
  nStr := 'Select * From %s b Where L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill, nBill]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;
  if Length(FDM.QueryTemp(nStr).FieldByName('L_OutFact').AsString) > 0 then
    nStr := gPath + sReportDir + 'LadingBill.fr3'
  else
    nStr := gPath + sReportDir + 'LadingPlanBill.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  if gSysParam.FPrinterBill = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
  else FDR.Report1.PrintOptions.Printer := gSysParam.FPrinterBill;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印质量承诺书
function PrintCNSReport(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印提货单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //添加引号

  nStr := 'Select * From %s b Where L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill, nBill]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  if gSysParam.FPrinterBill = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
  else FDR.Report1.PrintOptions.Printer := gSysParam.FPrinterBill;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2017-09-27
//Parm: 过磅单号;是否询问
//Desc: 打印nPound过磅记录
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印过磅单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nPound]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '称重记录[ %s ] 已无效!!';
    nStr := Format(nStr, [nPound]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;

  if Result  then
  begin
    nStr := 'Update %s Set P_PrintNum=P_PrintNum+1 Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nPound]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Date: 2017-09-27
//Parm: 过磅单号;是否询问
//Desc: 打印nPound过磅记录
function PrintPoundOtherReport(const nPound: string; nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印过磅单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select top 1 * From %s pl '+
  'Left Join %s oo On oo.R_ID=pl.P_OrderBak'+
  ' Where pl.P_ID=''%s'' order by pl.R_ID desc';
  nStr := Format(nStr, [sTable_PoundLog, sTable_CardOther, nPound]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '称重记录[ %s ] 已无效!!';
    nStr := Format(nStr, [nPound]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'PoundOther.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;

  if Result  then
  begin
    nStr := 'Update %s Set P_PrintNum=P_PrintNum+1 Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nPound]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Desc: 获取nStock品种的报表文件
function GetReportFileByStock(const nStock: string): string;
begin
  Result := GetPinYinOfStr(nStock);

  if Pos('dj', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42_DJ.fr3'
  else if Pos('gsysl', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan_gsl.fr3'
  else if Pos('kzf', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan_kzf.fr3'
  else if Pos('qz', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan_qz.fr3'
  else if Pos('32', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan32.fr3'
  else if Pos('42', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42.fr3'
  else if Pos('52', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42.fr3'
  else Result := '';
end;

//Desc: 打印标识为nHID的化验单
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印化验单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nSR := 'Select * From %s sr ' +
         ' Left Join %s sp on sp.P_ID=sr.R_PID';
  nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);

  nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          'Where H_ID in ($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nHID)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的化验单记录已无效!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
  nStr := GetReportFileByStock(nStr);

  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  if gSysParam.FPrinterHYDan = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
  else FDR.Report1.PrintOptions.Printer := gSysParam.FPrinterHYDan;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印标识为nID的合格证
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印合格证?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nStr := 'Select * From $HY hy ' +
          '  Left Join $Bill b On b.L_ID=hy.H_Bill ' +
          '  Left Join $SP sp On sp.P_Stock=b.L_StockNo ' +
          'Where H_ID in ($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$SP', sTable_StockParam), MI('$SR', sTable_StockRecord),
          MI('$Bill', sTable_Bill), MI('$ID', nHID)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的化验单记录已无效!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  if gSysParam.FPrinterHYDan = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
  else FDR.Report1.PrintOptions.Printer := gSysParam.FPrinterHYDan;
  
  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2017-10-17
//Parm: 批次列表;询问
//Desc: 打印nBatcode的发货回单
function PrintBillHD(const nBatcode: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印发货回单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nStr := 'Select * From %s Where R_Batcode in (%s)';
  nStr := Format(nStr, [sTable_BatRecord, nBatcode]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的批次记录已无效!!';
    nStr := Format(nStr, [nBatcode]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'BatRecord.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select L_ID,L_CusName,L_Type,L_Value,L_OutFact,L_HYDan From %s ' +
          'Where L_HYDan In (%s)';
  nStr := Format(nStr, [sTable_Bill, nBatcode]);

  FDM.QuerySQL(nStr);
  //发货明细

  if gSysParam.FPrinterHYDan = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
  else FDR.Report1.PrintOptions.Printer := gSysParam.FPrinterHYDan;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);
  
  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2017-11-22
//Parm: 交货单号,商城申请单
//Desc: 插入推送消息
procedure SaveWebOrderMsg(const nLID, nWebOrderID: string);
var nStr: string;
    nBool: Boolean;
begin
  if nWebOrderID = '' then
    Exit;
  //手工单

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
//    nStr := 'Delete From %s  Where WOM_LID=''%s''';
//    nStr := Format(nStr, [sTable_WebOrderMatch, nLID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(WOM_WebOrderID,WOM_LID,WOM_StatusType,' +
            'WOM_MsgType,WOM_BillType) Values(''%s'',''%s'',%d,' +
            '%d,''%s'')';
//    nStr := Format(nStr, [sTable_WebOrderMatch, nWebOrderID, nLID, c_WeChatStatusDeleted,
//            cSendWeChatMsgType_DelBill, sFlag_Sale]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
  except
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Date: 2014-09-17
//Parm: 交货单;车牌号;校验制卡开关
//Desc: 为nBill交货单制卡
function SetOrderCard(const nOrder,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nOrder;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Provide;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2014-09-17
//Parm: 磁卡号
//Desc: 注销nCard
function LogoutOrderCard(const nCard: string;const nNeiDao:string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_LogOffOrderCard, nCard, nNeiDao, @nOut);
end;

//Date: 2014-09-15
//Parm: 交货单号
//Desc: 删除nBillID单据
function DeleteOrder(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrder, nOrder, '', @nOut);
end;

//Date: 2014-09-15
//Parm: 交货单;新车牌
//Desc: 修改nOrder的车牌为nTruck.
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_ModifyBillTruck, nOrder, nTruck, @nOut);
end;

//Date: 2012-4-1
//Parm: 采购单号;提示;数据对象;打印机
//Desc: 打印nOrder采购单号
function PrintOrderReport(const nOrder: string;  const nAsk: Boolean): Boolean;
var nStr: string;
    nDS: TDataSet;
    nParam: TReportParamItem;
    nPath:string;
begin
  Result := False;
  nPath := '';
  
  if nAsk then
  begin
    nStr := '是否要打印采购单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s oo Inner Join %s od on oo.O_ID=od.D_OID Where D_ID=''%s''';
  nStr := Format(nStr, [sTable_Order, sTable_OrderDtl, nOrder]);

  nDS := FDM.QueryTemp(nStr);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount>0 then
  begin
    nPath := gPath + 'Report\PurchaseOrder.fr3';
  end
  else begin
    nStr := 'Select * From %s oo where R_id=''%s''';
    nStr := Format(nStr, [sTable_CardOther, nOrder]);

    nDS := FDM.QueryTemp(nStr);
    if not Assigned(nDS) then Exit;
    if nDS.RecordCount>0 then
    begin
      nPath := gPath + 'Report\TempOrder.fr3';
    end;    
  end;

  if nPath='' then
  begin
    nStr := '采购单或临时单[ %s ] 已无效!!';
    ShowMsg(nStr, sHint);
    Exit;
  end;

  if not FDR.LoadReportFile(nPath) then
  begin
    nStr := '无法正确加载报表文件['+nPath+']';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2014-09-15
//Parm: 开单数据
//Desc: 保存采购单,返回采购单号列表
function SaveOrder(const nOrderData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrder, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-17
//Parm: 交货单号;磁卡
//Desc: 绑定nBill.nCard
function SaveOrderCard(const nOrder, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_SaveOrderCard, nOrder, nCard, @nOut);
end;

function getPrePInfo(const nTruck:string;var nPrePValue: Double; var nPrePMan: string;
  var nPrePTime: TDateTime):Boolean;
var
  nStr:string;
begin
  Result := False;
  nPrePValue := 0;
  nPrePMan := '';
  nPrePTime := 0;

  nStr := 'select T_PrePValue,T_PrePMan,T_PrePTime from %s where t_truck=''%s'' and T_PrePUse=''%s''';
  nStr := format(nStr,[sTable_Truck,nTruck,sflag_yes]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount>0 then
    begin
      nPrePTime := FieldByName('T_PrePTime').asDateTime;
      nPrePValue := FieldByName('T_PrePValue').asFloat;;
      nPrePMan := FieldByName('T_PrePMan').asString;
      Result := True;
    end;
  end;
end;

function GetLastPInfo(const nID:string;var nPValue: Double; var nPMan: string;
  var nPTime: TDateTime):Boolean;
var
  nStr:string;
begin
  Result := False;
  nPValue := 0;
  nPMan := '';
  nPTime := 0;

  nStr := 'select top 1 P_PValue,P_PMan,P_PDate from %s' +
          ' where P_OrderBak=''%s'' order by R_ID desc';
  nStr := format(nStr,[sTable_PoundLog,nID]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount>0 then
    begin
      nPTime := FieldByName('P_PDate').asDateTime;
      nPValue := FieldByName('P_PValue').asFloat;;
      nPMan := FieldByName('P_PMan').asString;
      Result := True;
    end;
  end;
end;

//Date: 2014-09-17
//Parm: 磁卡号;岗位;交货单列表
//Desc: 获取nPost岗位上磁卡为nCard的交货单列表
function GetPurchaseOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_GetPostOrders, nCard, nPost, @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nBills);
  //xxxxx
end;

//Date: 2014-09-18
//Parm: 岗位;交货单列表;磅站通道
//Desc: 保存nPost岗位上的交货单数据
function SavePurchaseOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem;const nLogin: Integer): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
    nIsPreTruck:Boolean;
    nPrePValue: Double;
    nPrePMan: string;
    nPrePTime: TDateTime;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessPurchaseOrder(cBC_SavePostOrders, nStr, nPost, @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  if Assigned(nTunnel) then //过磅称重
  begin
    nList := TStringList.Create;
    try
      CapturePicture(nTunnel, nLogin, nList);
      //capture file

      //采购长期卡矿山有多条称重记录
      nStr := '';
      if nPost = sFlag_TruckBFM then
      begin
        nIsPreTruck := getPrePInfo(nData[0].FTruck,nPrePValue,nPrePMan,nPrePTime);
        if (nData[0].FCtype=sFlag_CardGuDing) and nIsPreTruck then
        begin
          nStr := GetLastPID(nData[0].FID);
        end;
      end;
      if nStr = '' then
        nStr := nOut.FData;

      for nIdx:=0 to nList.Count - 1 do
        SavePicture(nStr, nData[0].FTruck,
                                nData[0].FStockName, nList[nIdx]);
      //save file
    finally
      nList.Free;
    end;
  end;
end;

//Date: 2014-09-17
//Parm: 交货单项; MCListBox;分隔符
//Desc: 将nItem载入nMC
procedure LoadOrderItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  with nItem,nMC do
  begin
    Clear;
    Add(Format('车牌号码:%s %s', [nDelimiter, FTruck]));
    Add(Format('当前状态:%s %s', [nDelimiter, TruckStatusToStr(FStatus)]));

    Add(Format('%s ', [nDelimiter]));
    Add(Format('采购单号:%s %s', [nDelimiter, FZhiKa]));
//    Add(Format('交货数量:%s %.3f 吨', [nDelimiter, FValue]));
    if FType = sFlag_Dai then nStr := '袋装' else nStr := '散装';

    Add(Format('品种类型:%s %s', [nDelimiter, nStr]));
    Add(Format('品种名称:%s %s', [nDelimiter, FStockName]));

    Add(Format('%s ', [nDelimiter]));
    Add(Format('送货磁卡:%s %s', [nDelimiter, FCard]));
    Add(Format('单据类型:%s %s', [nDelimiter, BillTypeToStr(FIsVIP)]));
    Add(Format('供 应 商:%s %s', [nDelimiter, FCusName]));
  end;
end;

//Date: 2018-02-06
//Parm: 供应商ID
//Desc: 同步ERP采购供应商
function SyncPProvider(const nProID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncHhProvider, nProID, '', @nOut);
end;

//Date: 2018-02-06
//Parm: 物料ID
//Desc: 同步ERP采购物料
function SyncPMaterail(const nMID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncHhProvideMateriel, nMID, '', @nOut);
end;

//Date: 2018-02-06
//Parm: 供应商,物料,计划年月
//Desc: 获取ERP采购进厂计划
function GetHhOrderPlan(const nStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetHhOrderPlan, nStr, '', @nOut) then
    Result := nOut.FData
  else Result := '';
end;

//Date: 2018-03-23
//Parm: 客户ID,公司ID,物料ID,包装类型ID
//Desc: 获取ERP委托车辆
function GetHhSaleWTTruck(const nStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_SyncHhSaleWTTruck, nStr, '', @nOut) then
    Result := nOut.FData
  else Result := '';
end;

//Date: 2018-02-08
//Parm: 物料,计划年月
//Desc: 获取ERP采购内倒进厂计划
function GetHhNeiDaoOrderPlan(const nStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetHhNeiDaoOrderPlan, nStr, '', @nOut) then
    Result := nOut.FData
  else Result := '';
end;

//Date: 2018-02-06
//Parm: 采购明细ID
//Desc: 同步ERP采购磅单
function SyncHhOrderData(const nDID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncHhOrderPoundData, nDID, '', @nOut);
end;

//Date: 2018-02-08
//Parm: 磅单ID
//Desc: 同步ERP内倒采购磅单
function SyncHhNdOrderData(const nDID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncHhNdOrderPoundData, nDID, '', @nOut);
end;

//Date: 2018-03-06
//Parm: 磅单ID
//Desc: 同步ERP备品备件采购磅单
function SyncHhOtherOrderData(const nDID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncHhOtOrderPoundData, nDID, '', @nOut);
end;

//Desc: 长期卡是否失效
function GetCardGInvalid: Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_CardGInvalid]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsString = sFlag_Yes;
  //xxxxx
end;

//Param: StockName
//Desc: 获取码头船号(上次同品种)
function GetShipName(const nStockName :string): string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select top 1 O_Ship From %s Where O_StockName=''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_Order, nStockName]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsString;
  //xxxxx
end;

//Param: 采购单号
//Desc: 获取最新磅单号
function GetLastPID(const nOID :string): string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select top 1 P_ID From %s Where P_OrderBak =''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_PoundLog, nOID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsString;
  //xxxxx
end;

//Date: 2018-03-07
//Parm: 生产厂名称
//Desc: 获取ERP销售计划
function GetHhSalePlan(const nFactoryName: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetHhSalePlan, nFactoryName, '', @nOut);
end;

//Date: 2018-03-07
//Desc: 获取ERP销售物料
function SyncSMaterail(const nMID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncHhSaleMateriel, nMID, '', @nOut);
end;

//Date: 2018-03-08
//Parm: 客户ID
//Desc: 同步ERP销售客户
function SyncSCustomer(const nCusID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncHhCustomer, nCusID, '', @nOut);
end;

procedure SaveTruckPrePValue(const nTruck, nValue: string);
var nStr: string;
begin
  nStr := 'update %s set T_PrePValue=%s,T_PrePMan=''%s'',T_PrePTime=%s '
          + ' where t_truck=''%s'' and T_PrePUse=''%s''';
  nStr := format(nStr,[sTable_Truck,nValue,gSysParam.FUserName
                      ,sField_SQLServer_Now,nTruck,sflag_yes]);
  FDM.ExecuteSQL(nStr);
end;

function GetPrePValueSet: Double;
var nStr: string;
begin
  Result := 30;//init

  nStr := 'Select D_Value From $Table ' +
          'Where D_Name=''$Name'' and D_Memo=''$Memo''';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_SysParam),
                            MI('$Memo', sFlag_SetPValue)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
      nStr := Fields[0].AsString;
    if IsNumber(nStr,True) then
      Result := StrToFloatDef(nStr,30);
  end;
end;

//Date: 2014-09-18
//Parm: 车牌号;磅站通道
//Desc: 保存nTruck的预制皮重照片
function SaveTruckPrePicture(const nTruck: string;const nTunnel: PPTTunnelItem;
                            const nLogin: Integer): Boolean;
var nStr,nRID: string;
    nIdx: Integer;
    nList: TStrings;
begin
  Result := False;
  nRID := '';
  nStr := 'Select R_ID From %s Where T_Truck =''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_Truck, nTruck]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount <= 0 then
      Exit;
    nRID := Fields[0].AsString;
  end;

  nStr := 'Delete from %s where P_ID=''%s'' ';
  nStr := format(nStr,[sTable_Picture, nRID]);
  FDM.ExecuteSQL(nStr);

  if Assigned(nTunnel) then //过磅称重
  begin
    nList := TStringList.Create;
    try
      CapturePicture(nTunnel, nLogin, nList);
      //capture file

      for nIdx:=0 to nList.Count - 1 do
        SavePicture(nRID, nTruck, '', nList[nIdx]);
      //save file
    finally
      nList.Free;
    end;
  end;
end;

function InitCapture(const nTunnel: PPTTunnelItem; var nLogin: Integer): Boolean;
const
  cRetry = 2;
  //重试次数
var nStr: string;
    nIdx,nInt: Integer;
    nErr: Integer;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  Result := False;
  if not Assigned(nTunnel.FCamera) then Exit;
  //not camera

  try
    nLogin := -1;
    gCameraNetSDKMgr.NET_DVR_SetDevType(nTunnel.FCamera.FType);
    //xxxxx

    gCameraNetSDKMgr.NET_DVR_Init;
    //xxxxx

    for nIdx:=1 to cRetry do
    begin
      nLogin := gCameraNetSDKMgr.NET_DVR_Login(nTunnel.FCamera.FHost,
                   nTunnel.FCamera.FPort,
                   nTunnel.FCamera.FUser,
                   nTunnel.FCamera.FPwd, nInfo);
      //to login

      nErr := gCameraNetSDKMgr.NET_DVR_GetLastError;
      if nErr = 0 then break;

      if nIdx = cRetry then
      begin
        nStr := '登录摄像机[ %s.%d ]失败,错误码: %d';
        nStr := Format(nStr, [nTunnel.FCamera.FHost, nTunnel.FCamera.FPort, nErr]);
        WriteLog(nStr);
        if nLogin > -1 then
         gCameraNetSDKMgr.NET_DVR_Logout(nLogin);
        gCameraNetSDKMgr.NET_DVR_Cleanup();
        Exit;
      end;
    end;
    Result := True;
  except

  end;
end;

function FreeCapture(nLogin: Integer): Boolean;
begin
  Result := False;
  try
    if nLogin > -1 then
     gCameraNetSDKMgr.NET_DVR_Logout(nLogin);
    gCameraNetSDKMgr.NET_DVR_Cleanup();

    Result := True;
  except

  end;
end;

procedure UpdateTruckStatus(const nID: string);
var nStr: string;
begin
  nStr := 'update %s set D_Status=''%s'',D_NextStatus=''%s'''
          + ' where D_ID=''%s''';
  nStr := format(nStr,[sTable_OrderDtl,sFlag_TruckBFM,
                       sFlag_TruckBFM,nID]);
  FDM.ExecuteSQL(nStr);
end;

//Date: 2018-03-13
//Parm: 提货ID
//Desc: 同步ERP销售明细
function SyncHhSaleDetail(const nDID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncHhSaleDetail, nDID, '', @nOut);
end;

//Desc: 获取毛重限值
function GetMaxMValue(const nID: string): Double;
var nStr: string;
begin
  Result := 0;

  nStr := 'Select L_MValueMax From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsFloat;
  //xxxxx
end;

//Desc: 获取订单余量
function GetSaleOrderRestValue(const nID: string): Double;
var nStr: string;
begin
  Result := 0;

  nStr := 'Select (O_PlanRemain - O_Freeze) As O_RestValue From %s Where O_Order=''%s''';
  nStr := Format(nStr, [sTable_SalesOrder, nID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := FieldByName('O_RestValue').AsFloat;
  //xxxxx
end;

//Desc: 临时订单业务车辆是否可以上磅
function IsTruckCanPound(const nItem: TLadingBillItem): Boolean;
var nStr,nPreFix: string;
begin
  Result := False;

  nPreFix := 'WY';
  nStr := 'Select B_Prefix From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nPreFix := Fields[0].AsString;
  end;

  if Pos(nPreFix,nItem.FZhiKa) <= 0 then
    Exit;

  nStr := 'Select *, (O_PlanAmount - O_Freeze - O_HasDone - O_StopAmount) '+
          ' As O_RestValue From %s Where O_Order=''%s''';
  nStr := Format(nStr, [sTable_SalesOrder, nItem.FZhiKa]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    WriteLog('订单'+nItem.FZhiKa+'余量:'+FieldByName('O_RestValue').AsString);
    if FieldByName('O_RestValue').AsFloat > nItem.FValue then
      Result := True;
  end;

  if Result then
  begin
    nStr := 'Update %s Set O_Freeze=O_Freeze+(%.2f) Where O_Order=''%s''';
    nStr := Format(nStr, [sTable_SalesOrder, nItem.FValue,
            nItem.FZhiKa]);
    FDM.ExecuteSQL(nStr);
  end;

end;

//Date: 2018-03-22
//Parm: 物料编号;客户名称;开单量
//Desc: 获取批次号
function GetBatchCode(const nStockNo,nCusName: string; nValue: Double): string;
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['StockNo'] := nStockNo;
    nList.Values['CusName'] := nCusName;

    nStr := FloatToStr(nValue);

    if CallBusinessCommand(cBC_GetStockBatcode, nList.Text, nStr, @nOut) then
      Result := nOut.FData;
    //xxxxx
  finally
    nList.Free;
  end;
end;

//Date: 2018-03-22
//Parm: 物料名称;物料种类
//Desc: 获取物料编号
function GetStockNo(const nStockName,nStockType: string): string;
var nStr: string;
begin
  Result := '';

  nStr := 'Select D_ParamB From %s Where D_Name = ''%s'' ' +
          'And D_Memo=''%s'' and D_Value like ''%%%s%%''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_StockItem,
                        nStockType,
                        Trim(nStockName)]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
      Result := Fields[0].AsString;
  end;
end;

//Date: 2017-11-22
//Parm: 交货单号,商城申请单
//Desc: 插入删除推送消息
procedure SaveWebOrderDelMsg(const nLID, nBillType: string);
var nStr, nWebOrderID: string;
    nBool: Boolean;
begin
  nStr := 'Select WOM_WebOrderID From %s Where WOM_LID=''%s'' ';
  nStr := Format(nStr, [sTable_WebOrderMatch, nLID]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount <= 0 then
    begin
      WriteLog('查询商城申请单失败:' + nStr);
      Exit;
    end;
    //手工单
    nWebOrderID := Fields[0].AsString;
  end;

  nStr := 'Insert Into %s(WOM_WebOrderID,WOM_LID,WOM_StatusType,' +
          'WOM_MsgType,WOM_BillType) Values(''%s'',''%s'',%d,' +
          '%d,''%s'')';
  nStr := Format(nStr, [sTable_WebOrderMatch, nWebOrderID, nLID, c_WeChatStatusDeleted,
          cSendWeChatMsgType_DelBill, nBillType]);
  FDM.ExecuteSQL(nStr);
end;

function GetMinNetValue: Double;
var nStr: string;
begin
  Result := 2000;//init

  nStr := 'Select D_Value From $Table ' +
          'Where D_Name=''$Name'' and D_Memo=''$Memo''';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_SysParam),
                            MI('$Memo', sFlag_MinNetValue)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
      nStr := Fields[0].AsString;
    if IsNumber(nStr,True) then
      Result := StrToFloatDef(nStr,2000);
  end;
end;

//Desc: 查询外运业务完成量
function GetSaleOrderDoneValue(const nOID: string): string;
var nStr,nPreFix: string;
begin
  Result := '';

  nPreFix := 'WY';
  nStr := 'Select B_Prefix From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nPreFix := Fields[0].AsString;
  end;

  if Pos(nPreFix,nOID) <= 0 then
    Exit;

  nStr := 'Select Sum(P_MValue-P_PValue)'+
          ' From %s a,%s b Where (a.P_OrderBak = b.L_ID or a.P_Bill = b.L_ID)' +
          ' And b.L_Zhika=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, sTable_Bill, nOID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
  end;
end;

//Desc: 查询外运业务冻结量
function GetSaleOrderFreezeValue(const nOID: string): string;
var nStr,nPreFix: string;
begin
  Result := '';

  nPreFix := 'WY';
  nStr := 'Select B_Prefix From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nPreFix := Fields[0].AsString;
  end;

  if Pos(nPreFix,nOID) <= 0 then
    Exit;

  nStr := 'Select Sum(L_Value) From %s Where L_Status <> ''%s''' +
          ' And L_Zhika=''%s''';
  nStr := Format(nStr, [sTable_Bill, sFlag_TruckOut, nOID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
  end;
end;

//Desc: 检查车辆是否存在未注销磁卡的提货单(针对外运业务)
function CheckTruckCard(const nTruck: string; var nLID: string): Boolean;
var nStr: string;
begin
  Result := True;

  nStr := 'Select L_Card, L_ID From %s Where L_Truck=''%s''';
  nStr := Format(nStr, [sTable_Bill, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin

    First;

    while not Eof do
    begin
      if Length(Fields[0].AsString) > 0 then
      begin
        nLID := Fields[1].AsString;
        Result := False;
        Exit;
      end;
      Next;
    end;
  end;
end;

//Desc: 检查是否为临时订单
function IsOtherOrder(const nItem: TLadingBillItem): Boolean;
var nStr,nPreFix: string;
begin
  Result := False;

  nPreFix := 'WY';
  nStr := 'Select B_Prefix From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nPreFix := Fields[0].AsString;
  end;

  if Pos(nPreFix,nItem.FZhiKa) <= 0 then
    Exit;

  Result := True;
end;

//Date: 2018-04-03
//Parm: 提货单号
//Desc: 验证车辆是否出厂超时
function IsTruckTimeOut(const nLID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_TruckTimeOut, nLID, '', @nOut);
  //xxxxx
end;

function GetEventDept: string;
var nStr: string;
begin
  Result := sFlag_DepDaTing;//init

  nStr := 'Select D_Value From $Table ' +
          'Where D_Name=''$Name'' and D_Memo=''$Memo''';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_SysParam),
                            MI('$Memo', sFlag_EventDept)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
      Result := Fields[0].AsString;
  end;
end;


//Date: 2018-02-06
//Parm: 供应商ID
//Desc: 同步ERP采购供应商
function SyncPProviderWSDL(const nProID: string): Boolean;
var nOut: TWorkerHHJYData;
begin
  Result := CallBusinessHHJY(cBC_SyncHhProvider, nProID, '', '', @nOut, False);
end;

//Date: 2018-02-06
//Parm: 供应商,物料,计划年月
//Desc: 获取ERP采购进厂计划
function GetHhOrderPlanWSDL(const nStr: string): string;
var nOut: TWorkerHHJYData;
begin
  if CallBusinessHHJY(cBC_GetHhOrderPlan, nStr, '', '', @nOut) then
    Result := nOut.FData
  else Result := '';
end;

//Date: 2018-03-23
//Parm: 客户ID,公司ID,物料ID,包装类型ID
//Desc: 获取ERP委托车辆
function GetHhSaleWTTruckWSDL(const nStr: string): string;
var nOut: TWorkerHHJYData;
begin
  if CallBusinessHHJY(cBC_SyncHhSaleWTTruck, nStr, '', '', @nOut) then
    Result := nOut.FData
  else Result := '';
end;

//Date: 2018-02-08
//Parm: 物料,计划年月
//Desc: 获取ERP采购内倒进厂计划
function GetHhNeiDaoOrderPlanWSDL(const nStr: string): string;
var nOut: TWorkerHHJYData;
begin
  if CallBusinessHHJY(cBC_GetHhNeiDaoOrderPlan, nStr, '', '', @nOut) then
    Result := nOut.FData
  else Result := '';
end;

//Date: 2018-02-06
//Parm: 采购明细ID
//Desc: 同步ERP采购磅单
function SyncHhOrderDataWSDL(const nDID: string): Boolean;
var nOut: TWorkerHHJYData;
begin
  Result := CallBusinessHHJY(cBC_SyncHhOrderPoundData, nDID, '', '', @nOut);
end;

//Date: 2018-02-08
//Parm: 磅单ID
//Desc: 同步ERP内倒采购磅单
function SyncHhNdOrderDataWSDL(const nDID: string): Boolean;
var nOut: TWorkerHHJYData;
begin
  Result := CallBusinessHHJY(cBC_SyncHhNdOrderPoundData, nDID, '', '', @nOut);
end;

//Date: 2018-03-06
//Parm: 磅单ID
//Desc: 同步ERP备品备件采购磅单
function SyncHhOtherOrderDataWSDL(const nDID: string): Boolean;
var nOut: TWorkerHHJYData;
begin
  Result := CallBusinessHHJY(cBC_SyncHhOtOrderPoundData, nDID, '', '', @nOut);
end;

//Date: 2018-03-07
//Parm: 生产厂名称
//Desc: 获取ERP销售计划
function GetHhSalePlanWSDL(const nWhere, nFactoryName: string): Boolean;
var nOut: TWorkerHHJYData;
begin
  Result := CallBusinessHHJY(cBC_GetHhSalePlan, nWhere, nFactoryName, '', @nOut, False);
end;

//Date: 2018-03-07
//Desc: 获取ERP销售物料
function SyncSMaterailWSDL(const nMID: string): Boolean;
var nOut: TWorkerHHJYData;
begin
  Result := CallBusinessHHJY(cBC_SyncHhSaleMateriel, nMID, '', '', @nOut, False);
end;

//Date: 2018-03-08
//Parm: 客户ID
//Desc: 同步ERP销售客户
function SyncSCustomerWSDL(const nCusID: string): Boolean;
var nOut: TWorkerHHJYData;
begin
  Result := CallBusinessHHJY(cBC_SyncHhCustomer, nCusID, '', '', @nOut, False);
end;

//Date: 2018-03-13
//Parm: 提货ID
//Desc: 同步ERP销售明细
function SyncHhSaleDetailWSDL(const nDID: string): Boolean;
var nOut: TWorkerHHJYData;
begin
  Result := CallBusinessHHJY(cBC_SyncHhSaleDetail, nDID, '', '', @nOut);
end;

//Date: 2018-03-13
//Parm: 提货ID
//Desc: 获取批次号
function GetHhSaleWareNumberWSDL(const nOrder, nValue: string;
                                 var nHint: string): string;
var nOut: TWorkerHHJYData;
    nStr: string;
    nList: TStrings;
    nEID, nEvent, nStockName, nStockType: string;
begin
  Result := '';
  nHint := '';
  nList := TStringList.Create;

  try
    nStr := 'Select O_FactoryID, O_StockID, O_PackingID, O_StockName,' +
            ' O_STockType From %s Where O_Order =''%s'' ';
    nStr := Format(nStr, [sTable_SalesOrder, nOrder]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nList.Values['FactoryID'] := Fields[0].AsString;
      nList.Values['StockID']   := Fields[1].AsString;
      nList.Values['PackingID'] := Fields[2].AsString;
      nStockName := Fields[3].AsString;
      nStockType := Fields[4].AsString;

      nStr := PackerEncodeStr(nList.Text);
      if CallBusinessHHJY(cBC_GetHhSaleWareNumber, nStr, '', '', @nOut, False) then
      begin
        nStr := PackerDecodeStr(nOut.FData);
        nList.Clear;
        nList.Text := nStr;
        try
          if IsNumber(nList.Values['FAmount'], True) and
             IsNumber(nList.Values['FDeliveryAmount'], True) then
          begin
            if StrToFloat(nList.Values['FAmount']) -
               StrToFloat(nList.Values['FDeliveryAmount']) -
               StrToFloat(nValue) >= 0 then
            begin
              Result := nList.Values['FWareNumber'];
            end;
          end;
        except
        end;
      end
      else
      begin
        nHint := PackerDecodeStr(nOut.FData);
      end;
    end
    else
    begin
      nHint := '订单[ %s ]不存在';
      nHint := Format(nHint,[nOrder]);
      Exit;
    end;

    if Result = '' then
    begin
      nEID := nList.Values['FactoryID'] +
              nList.Values['StockID'] +
              nList.Values['PackingID'];

      nStr := 'Delete From %s Where E_ID=''%s''';
      nStr := Format(nStr, [sTable_ManualEvent, nEID]);

      FDM.ExecuteSQL(nStr);

      nEvent := '水泥品种[ %s ]的批次编号已用尽,请化验室尽快补录';
      nEvent := Format(nEvent,[nStockname + nStockType]);

      nStr := MakeSQLByStr([
          SF('E_ID', nEID),
          SF('E_Key', ''),
          SF('E_From', sFlag_DepDaTing),
          SF('E_Event', nEvent),
          SF('E_Solution', sFlag_Solution_OK),
          SF('E_Departmen', sFlag_DepHauYanShi),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, '', True);
      FDM.ExecuteSQL(nStr);
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2018-03-13
//Parm: 提货ID
//Desc: 获取批次号
function PoundVerifyHhSalePlanWSDL(const nLID: string; nValue: Double;
                                   nPriceDate:string;
                                 var nHint: string): Boolean;
var nOut: TWorkerHHJYData;
    nStr: string;
    nList: TStrings;
begin
  Result := False;
  nHint := '';
  nList := TStringList.Create;

  try
    if not CallBusinessHHJY(cBC_IsHhSaleDetailExits
           ,PackerEncodeStr(nLID),'','',@nOut) then
    begin
      nHint := '获取提货单[ %s ]提货ID失败,请尝试重新上传提货单.';
      nHint := Format(nHint, [nLID]);
      Exit;
    end;
    nList.Text := PackerDecodeStr(nOut.FData);

    if not IsNumber(nList.Values['FGoodsPrice'], True) then
    begin
      nHint := '获取提货单[ %s ]单价[ %s ]异常,请核对.';
      nHint := Format(nHint, [nLID, nList.Values['FGoodsPrice']]);
      Exit;
    end;

    nList.Values['FPriceDate'] := nPriceDate;
    nList.Values['FPoundValue'] := FloatToStr(nValue);
    nList.Values['FMoney'] := Format('%.2f', [StrToFloat(nList.Values['FGoodsPrice'])
                                              * nValue]);

    nStr := PackerEncodeStr(nList.Text);
    if  not CallBusinessHHJY(cBC_PoundVerifyHhSalePlan, nStr, '', '', @nOut, False) then
    begin
      nHint := '提货单[ %s ]重车过磅校验失败.原因为:[ 账户资金不足 ]';
      nHint := Format(nHint, [nLID]);
      Exit;
    end;
    Result := True;
  finally
    nList.Free;
  end;
end;


function GetCusID(const nCusName :string): string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select top 1 C_ID From %s Where C_Name =''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_Customer, nCusName]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsString;
  //xxxxx
end;

function IsMulMaoStock(const nStockNo :string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Value=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundMultiM, nStockNo]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := True;
  //xxxxx
end;

function IsAsternStock(const nStockName :string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Value=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundAsternM, nStockName]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := True;
  //xxxxx
end;

end.
