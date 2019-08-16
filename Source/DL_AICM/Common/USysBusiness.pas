{*******************************************************************************
  作者: dmzn@163.com 2010-3-8
  描述: 系统业务处理
*******************************************************************************}
unit USysBusiness;

interface
{$I Link.inc}
uses
  Windows, DB, Classes, Controls, SysUtils, UBusinessPacker, UBusinessWorker,
  UBusinessConst, ULibFun, UAdjustForm, UFormCtrl, UDataModule, UDataReport,
  UFormBase, cxMCListBox, UMgrPoundTunnels, UMgrCamera, USysConst, HKVNetSDK,
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

//------------------------------------------------------------------------------
function AdjustHintToRead(const nHint: string): string;
//调整提示内容
function WorkPCHasPopedom: Boolean;
//验证主机是否已授权
function GetSysValidDate: Integer;
//获取系统有效期
function GetTruckEmptyValue(nTruck: string): Double;
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
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
//载入客户信息

function SaveBill(const nBillData: string): string;
//保存交货单
function DeleteBill(const nBill: string): Boolean;
//删除交货单
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
//更改提货车辆
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
//交货单调拨
function SetBillCard(const nBill,nTruck,nNewCard: string; nVerify: Boolean): Boolean;
//为交货单办理磁卡
function SaveBillCard(const nBill, nCard: string): Boolean;
//保存交货单磁卡
function LogoutBillCard(const nCard: string): Boolean;
//注销指定磁卡
function SetTruckRFIDCard(nTruck: string; var nRFIDCard: string;
  var nIsUse: string; nOldCard: string=''): Boolean;

function GetLadingBills(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//获取指定岗位的交货单列表
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
//载入单据信息到列表
function SaveLadingBills(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil): Boolean;
//保存指定岗位的交货单

function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
//获取指定车辆的已称皮重信息
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems): Boolean;
//保存车辆过磅记录
function ReadPoundCard(const nTunnel: string; nReadOnly: String = ''): string;
//读取指定磅站读头上的卡号
procedure CapturePicture(const nTunnel: PPTTunnelItem; const nList: TStrings);
//抓拍指定通道

function SaveOrderBase(const nOrderData: string): string;
//保存采购申请单
function DeleteOrderBase(const nOrder: string): Boolean;
//删除采购申请单
function SaveOrder(const nOrderData: string): string;
//保存采购单
function DeleteOrder(const nOrder: string): Boolean;
//删除采购单
//function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
////更改提货车辆
function SetOrderCard(const nOrder,nTruck,nNewCard: string; nVerify: Boolean): Boolean;
//为采购单办理磁卡
function SaveOrderCard(const nOrder, nCard: string): Boolean;
//保存采购单磁卡
function LogoutOrderCard(const nCard: string): Boolean;
//注销指定磁卡
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
//修改车牌号
function GetGYOrderBaseValue(const nOrder: string): string;
//获取采购申请单发货信息

function GetPurchaseOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//获取指定岗位的采购单列表
function SavePurchaseOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil): Boolean;
//保存指定岗位的采购单

procedure LoadOrderItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);

function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean = False): Boolean;
//读取车辆队列
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
//启停喷码机
function ChangeDispatchMode(const nMode: Byte): Boolean;
//切换调度模式

function GetHYMaxValue: Double;
function GetHYValueByStockNo(const nNo: string): Double;
//获取化验单已开量
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
//打印提货单
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
//打印榜单
function PrintHeGeReport(const nBill: string; var nHint: string;
 const nPrinter: string = ''): Boolean;
//化验单,合格证
function PrintBillLoadReport(nBill: string; const nAsk: Boolean): Boolean;
//打印物资发货单
function PrintBillFYDReport(const nBill: string;  const nAsk: Boolean): Boolean;
//打印现场发运单

function getCustomerInfo(const nXmlStr: string): string;
//获取客户注册信息

function get_Bindfunc(const nXmlStr: string): string;
//客户与微信账号绑定

function send_event_msg(const nXmlStr: string): string;
//发送消息

function edit_shopclients(const nXmlStr: string): string;
//新增商城用户

function edit_shopgoods(const nXmlStr: string): string;
//添加商品

function get_shoporders(const nXmlStr: string): string;
//获取订单信息

function get_shoporderbyno(const nXmlStr: string): string;
//根据订单号获取订单信息

function get_shopPurchaseByno(const nXmlStr:string):string;
//根据货单号获取供货信息
function GetStockNo(const nStockName,nStockType: string): string;
//获取物料编号
function GetHhSalePlan(const nFactoryName: string): Boolean;
//获取ERP销售计划
function GetHhOrderPlan(const nStr: string): string;
//获取ERP采购进厂计划
function GetHhOrderPlanWSDL(const nStr: string): string;
//获取ERP采购进厂计划
function GetOrderOtherInfo(const nID: string;
                           var nModel,nYear,nKD,nProID,nProName,nStockName: string): Boolean;
//获取订单型号 矿点 记账年月
function GetHhSaleWareNumberWSDL(const nOrder, nValue: string;
                                 var nHint: string): string;
//Desc: 获取批次号
function NewHhWTDetailWSDL(const nOrder, nTruck, nValue: string;
                                 var nHint: string): string;
//Desc: 生成派车单并返回单号
function ReVerifySalePlanWSDL(const nOrder, nValue: string;
                                 var nHint: string): string;
//Desc: 重新同步销售订单状态
function KDVerifyHhSalePlanWSDL(const nPrice, nValue: Double;
                                   nPriceDate:string;
                                 var nHint: string): Boolean;
function SaveHYData(const nHYDan: string): Boolean;
//Desc: 读取ERP批次记录
function PrintHuaYanReport(const nBill: string; var nHint: string;
 const nPrinter: string = ''): Boolean;
//打印标识为nHID的化验单

function CallBusinessCommand(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
function IsCardValid(const nCard: string): Boolean;
function IFHasBill(const nTruck: string; var nID: string): Boolean;
//车辆是否存在未完成提货单
function IFHasOrder(const nTruck: string; var nID: string): Boolean;
//车辆是否存在未完成采购单
function IsPurOrderHasControl(nProID,nStockNo: string): Boolean;
function GetMaxLadeValue(const nTruck: string): Double;
function GetMinLadeValue: Double;
implementation
uses
  UWaitItem;
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

//------------------------------------------------------------------------------
//Desc: 车辆有效皮重
function GetTruckEmptyValue(nTruck: string): Double;
var nStr: string;
begin
  nStr := 'Select T_PValue From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsFloat
  else Result := 0;
end;

//Date: 2014-09-05
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

//Date: 2014-09-05
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

//Date: 2014-09-05
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

//Date: 2014-10-01
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

//Date: 2014-09-04
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

//------------------------------------------------------------------------------
//Date: 2014-06-19
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

//Date: 2014-06-19
//Parm: 通道;列表
//Desc: 抓拍nTunnel的图像
procedure CapturePicture(const nTunnel: PPTTunnelItem; const nList: TStrings);
const
  cRetry = 2;
  //重试次数
var nStr: string;
    nIdx,nInt: Integer;
    nLogin,nErr: Integer;
    nPic: NET_DVR_JPEGPARA;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  nList.Clear;
  if not Assigned(nTunnel.FCamera) then Exit;
  //not camera

  if not DirectoryExists(gSysParam.FPicPath) then
    ForceDirectories(gSysParam.FPicPath);
  //new dir

  if gSysParam.FPicBase >= 100 then
    gSysParam.FPicBase := 0;
  //clear buffer

  nLogin := -1;
  NET_DVR_Init();
  try
    for nIdx:=1 to cRetry do
    begin
      nLogin := NET_DVR_Login(PChar(nTunnel.FCamera.FHost),
                   nTunnel.FCamera.FPort,
                   PChar(nTunnel.FCamera.FUser),
                   PChar(nTunnel.FCamera.FPwd), @nInfo);
      //to login

      nErr := NET_DVR_GetLastError;
      if nErr = 0 then break;

      if nIdx = cRetry then
      begin
        nStr := '登录摄像机[ %s.%d ]失败,错误码: %d';
        nStr := Format(nStr, [nTunnel.FCamera.FHost, nTunnel.FCamera.FPort, nErr]);
        WriteLog(nStr);
        Exit;
      end;
    end;

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

        NET_DVR_CaptureJPEGPicture(nLogin, nTunnel.FCameraTunnels[nIdx],
                                   @nPic, PChar(nStr));
        //capture pic

        nErr := NET_DVR_GetLastError;
        if nErr = 0 then
        begin
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
  finally
    if nLogin > -1 then
      NET_DVR_Logout(nLogin);
    NET_DVR_Cleanup();
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-4-13
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

//Desc: 载入nCID客户的信息到nList中,并返回数据集
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
var nStr: string;
begin
  nStr := 'Select cus.*,S_Name as C_SaleName From $Cus cus ' +
          ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ' +
          'Where C_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$Cus', sTable_Customer), MI('$ID', nCID),
          MI('$SM', sTable_Salesman)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with nList.Items,Result do
  begin
    Add('客户编号:' + nList.Delimiter + FieldByName('C_ID').AsString);
    Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('企业法人:' + nList.Delimiter + FieldByName('C_FaRen').AsString + ' ');
    Add('联系方式:' + nList.Delimiter + FieldByName('C_Phone').AsString + ' ');
    Add('所属业务员:' + nList.Delimiter + FieldByName('C_SaleName').AsString);
  end else
  begin
    Result := nil;
    nHint := '客户信息已丢失';
  end;
end;

//Date: 2014-09-25
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

//Date: 2014-09-25
//Parm: 称重数据
//Desc: 保存nData称重数据
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems): Boolean;
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
    CapturePicture(nTunnel, nList);
    //capture file

    for nIdx:=0 to nList.Count - 1 do
      SavePicture(nOut.FData, nData[0].FTruck,
                              nData[0].FStockName, nList[nIdx]);
    //save file
  finally
    nList.Free;
  end;
end;

//Date: 2014-10-02
//Parm: 通道号
//Desc: 读取nTunnel读头上的卡号
function ReadPoundCard(const nTunnel: string; nReadOnly: String = ''): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessHardware(cBC_GetPoundCard, nTunnel, nReadOnly, @nOut, False) then
       Result := nOut.FData
  else Result := '';
end;

//------------------------------------------------------------------------------
//Date: 2014-10-01
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

//Date: 2014-10-01
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

//Date: 2014-10-07
//Parm: 调度模式
//Desc: 切换系统调度模式为nMode
function ChangeDispatchMode(const nMode: Byte): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessHardware(cBC_ChangeDispatchMode, IntToStr(nMode), '',
            @nOut);
  //xxxxx
end;

//Date: 2014-09-15
//Parm: 开单数据
//Desc: 保存交货单,返回交货单号列表
function SaveBill(const nBillData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessSaleBill(cBC_SaveBills, nBillData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-15
//Parm: 交货单号
//Desc: 删除nBillID单据
function DeleteBill(const nBill: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_DeleteBill, nBill, '', @nOut);
end;

//Date: 2014-09-15
//Parm: 交货单;新车牌
//Desc: 修改nBill的车牌为nTruck.
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_ModifyBillTruck, nBill, nTruck, @nOut);
end;

//Date: 2014-09-30
//Parm: 交货单;纸卡
//Desc: 将nBill调拨给nNewZK的客户
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaleAdjust, nBill, nNewZK, @nOut);
end;

//Date: 2014-09-17
//Parm: 交货单;车牌号;校验制卡开关
//Desc: 为nBill交货单制卡
function SetBillCard(const nBill,nTruck,nNewCard: string; nVerify: Boolean): Boolean;
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
  np.FParamD := nNewCard;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2014-09-17
//Parm: 交货单号;磁卡
//Desc: 绑定nBill.nCard
function SaveBillCard(const nBill, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaveBillCard, nBill, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: 磁卡号
//Desc: 注销nCard
function LogoutBillCard(const nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_LogoffCard, nCard, '', @nOut);
end;

//Date: 2014-09-17
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

//Date: 2014-09-18
//Parm: 岗位;交货单列表;磅站通道
//Desc: 保存nPost岗位上的交货单数据
function SaveLadingBills(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem): Boolean;
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
      CapturePicture(nTunnel, nList);
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

//------------------------------------------------------------------------------
//Date: 2015/9/19
//Parm: 
//Desc: 保存采购申请单
function SaveOrderBase(const nOrderData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrderBase, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

function DeleteOrderBase(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrderBase, nOrder, '', @nOut);
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

//Date: 2014-09-15
//Parm: 交货单号
//Desc: 删除nBillID单据
function DeleteOrder(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrder, nOrder, '', @nOut);
end;

//Date: 2014-09-17
//Parm: 交货单;车牌号;校验制卡开关
//Desc: 为nBill交货单制卡
function SetOrderCard(const nOrder,nTruck,nNewCard: string; nVerify: Boolean): Boolean;
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
  np.FParamD := nNewCard;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2014-09-17
//Parm: 交货单号;磁卡
//Desc: 绑定nBill.nCard
function SaveOrderCard(const nOrder, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_SaveOrderCard, nOrder, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: 磁卡号
//Desc: 注销nCard
function LogoutOrderCard(const nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_LogOffOrderCard, nCard, '', @nOut);
end;

//Date: 2014-09-15
//Parm: 交货单;新车牌
//Desc: 修改nOrder的车牌为nTruck.
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_ModifyBillTruck, nOrder, nTruck, @nOut);
end;

//------------------------------------------------------------------------------
//Date: 2015/9/20
//Parm: 供应订单编号
//Desc: 获取采购申请单发货信息
function GetGYOrderBaseValue(const nOrder: string): string;
var nOut: TWorkerBusinessCommand;
begin
   if CallBusinessPurchaseOrder(cBC_GetGYOrderValue, nOrder, '', @nOut) and
     (nOut.FData<>'') then
        Result := PackerDecodeStr(nOut.FData)
   else Result := '';
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
 const nTunnel: PPTTunnelItem): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessPurchaseOrder(cBC_SavePostOrders, nStr, nPost, @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  if Assigned(nTunnel) then //过磅称重
  begin
    nList := TStringList.Create;
    try
      CapturePicture(nTunnel, nList);
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

//Date: 2014-09-17
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

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Report1.PrintOptions.Printer := gSysParam.FCardPrinter;
//  FDR.ShowReport;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;


//Date: 2016-8-10
//Parm: 交货单号;提示
//Desc: 打印nBill单号的发运单
function PrintBillFYDReport(const nBill: string;  const nAsk: Boolean): Boolean;
var nStr: string;
    nDS: TDataSet;
    nParam: TReportParamItem;
begin
  Result := False;

//  if nAsk then
//  begin
//    nStr := '是否要打印现场发运单?';
//    if not QueryDlg(nStr, sAsk) then Exit;
//  end;

  nStr := 'Select * From %s  Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  nDS := FDM.QueryTemp(nStr);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nStr := '交货单[ %s ] 已无效!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + 'Report\BillFYD.fr3';
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
  FDR.Report1.PrintOptions.Printer := gSysParam.FCardPrinter;
//  FDR.ShowReport;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2012-4-15
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

//Desc: 打印过路单
function PrintBillLoadReport(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印过路单?';
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

  nStr := gPath + sReportDir + 'BillLoad.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'HKRecords';
  nParam.FValue := '';

  if FDM.SqlTemp.FieldByName('L_HKRecord').AsString<>'' then
  begin
    nStr := 'Select * From %s b Where L_HKRecord =''%s''';
    nStr := Format(nStr, [sTable_Bill,
            FDM.SqlTemp.FieldByName('L_HKRecord').AsString]);
    //xxxxx

    if FDM.QuerySQL(nStr).RecordCount > 0 then
      with FDM.SqlQuery do
      while not Eof do
      try
        nStr := FieldByName('L_ID').AsString;  
        nParam.FValue := nParam.FValue + nStr + '.';
      finally
        Next;
      end;
  end else FDM.SqlQuery := FDM.SqlTemp;
  FDR.AddParamItem(nParam);  

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
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
  else if Pos('a32', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan32_psa.fr3'
  else if Pos('32', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan32.fr3'
  else if Pos('42', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42.fr3'
  else if Pos('52', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan52.5.fr3'
  else Result := '';
end;

//Desc: 打印标识为nID的合格证
function PrintHeGeReport(const nBill: string; var nHint: string;
 const nPrinter: string = ''): Boolean;
var nStr,nSR: string;
begin
  Result := False;

  nStr := 'Select * From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nHint := '提货单[ %s ]没有对应的合格证';
    nHint := Format(nHint, [nBill]);
    Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  if nPrinter = '' then
       FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
  else FDR.Report1.PrintOptions.Printer := nPrinter;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2015/1/18
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

//获取客户注册信息
function getCustomerInfo(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WX_getCustomerInfo, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//客户与微信账号绑定
function get_Bindfunc(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WX_get_Bindfunc, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//发送消息
function send_event_msg(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WX_send_event_msg, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//新增商城用户
function edit_shopclients(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WX_edit_shopclients, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//添加商品
function edit_shopgoods(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WX_edit_shopgoods, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//获取订单信息
function get_shoporders(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessWechat(cBC_WX_get_shoporders, nXmlStr, '', '', @nOut,False) then
    Result := nOut.FData;
end;

//根据订单号获取订单信息
function get_shoporderbyno(const nXmlStr: string): string;
var nOut: TWorkerWebChatData;
begin
  Result := '';
  if CallBusinessWechat(cBC_WX_get_shoporderbyNO, nXmlStr, '', '' , @nOut,False) then
    Result := nOut.FData;
end;

//根据货单号获取供货信息
function get_shopPurchaseByno(const nXmlStr:string):string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessWechat(cBC_WX_get_shopPurchasebyNO, nXmlStr, '', '', @nOut,False) then
    Result := nOut.FData;
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

//Date: 2018-03-07
//Parm: 生产厂名称
//Desc: 获取ERP销售计划
function GetHhSalePlan(const nFactoryName: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetHhSalePlan, nFactoryName, '', @nOut);
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

//Date: 2018-03-22
//Parm: 原材料订单ID
//Desc: 获取订单型号 矿点 记账年月
function GetOrderOtherInfo(const nID: string;
                           var nModel,nYear,nKD,nProID,nProName,nStockName: string): Boolean;
var nStr, nData,nDate: string;
    nIdx, nOrderCount: Integer;
    nListA, nListB: TStrings;
    nBeginDate, nEndDate : TDateTime;
begin
  Result := False;
  nModel := '';
  nYear  := '';
  nKD    := '';
  nStockName := '';

  nDate := FormatDateTime('MM',Now);

  try
    if StrToInt(nDate) = 25 then
    begin
      nStr := 'Select D_Value From %s Where D_Name=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_NoOrderCardTime]);

      with FDM.QueryTemp(nStr) do
      if RecordCount > 0 then
      begin
        nDate := FormatDateTime('YYYY-MM-DD',Now) + ' ' + Fields[0].AsString;
      end
      else
        nDate := FormatDateTime('YYYY-MM-DD',Now) + ' 23:59:59';

      nBeginDate := StrToDateTime(nDate);
      nEndDate := StrToDateTime(FormatDateTime('YYYY-MM-DD',Now) + ' 23:59:59');

      if (Now > nBeginDate) and (Now < nEndDate) then
      begin
        ShowMsg('当前时间段禁止办卡,请等待', sHint);
        Exit;
      end;
    end;
  except
  end;


  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    try
      nDate := FormatDateTime('YYYY-MM-',Now) + '26';
      if Now > StrToDate(nDate) then
       nDate := FormatDateTime('YYYY-MM',IncMonth(Now))
      else
       nDate := FormatDateTime('YYYY-MM',Now);
    except
       nDate := FormatDateTime('YYYY-MM',Now);
    end;

    {$IFDEF SyncDataByWSDL}
    nStr := 'FEntryPlanNumber = ''%s'' ';
    nStr := Format(nStr, [nID]);

    nStr := PackerEncodeStr(nStr);

    nData := GetHhOrderPlanWSDL(nStr);

    if nData = '' then
    begin
      Exit;
    end;

    nListB.Text := PackerDecodeStr(nData);

    nModel    := nListB.Values['FModel'];
    nKD       := nListB.Values['FProducerName'];
    nYear     := nListB.Values['FYearPeriod'];                                   
    nProID    := nListB.Values['FMaterialProviderID'];
    nProName  := nListB.Values['FMaterialProviderName'];
    nStockName:= nListB.Values['FMaterielName'];
    if nYear <> nDate then
    begin
      nData := '当前记账年月[ %s ]与采购订单[ %s ]所属计划年月不一致,采购订单可能已失效';
      nData := Format(nData,[nDate, nID, nYear]);
      WriteLog(nData);

      ShowMsg('申请单已失效,请重新下单', sHint);
      Exit;
    end;
    Result := True;
    {$ELSE}
    nListA.Values['YearPeriod'] := nDate;

    nStr := PackerEncodeStr(nListA.Text);

    nData := GetHhOrderPlan(nStr);

    if nData = '' then
    begin
      Exit;
    end;

    nListA.Text := PackerDecodeStr(nData);
    nOrderCount := nListA.Count;
    for nIdx := 0 to nOrderCount-1 do
    begin
      nListB.Text := PackerDecodeStr(nListA.Strings[nIdx]);
      if Trim(nID) = nListB.Values['Order'] then
      begin
        nModel    := nListB.Values['Model'];
        nKD       := nListB.Values['KD'];
        nYear     := nDate;
        nProID    := nListB.Values['ProID'];
        nProName  := nListB.Values['ProName'];
        nStockName:= nListB.Values['StockName'];
        Result := True;
        Break;
      end;
    end;
    {$ENDIF}
  finally
    nListA.Free;
    nListB.Free;
  end;
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
    nRestVal, nWarnVal: Double;
begin
  Result := '';
  nHint := '';
  nList := TStringList.Create;
  nRestVal := 0;
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
            nRestVal := StrToFloat(nList.Values['FAmount']) -
               StrToFloat(nList.Values['FDeliveryAmount']) -
               StrToFloat(nValue);
            if nRestVal >= 0 then
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
    end
    else
    begin
      nWarnVal := 200;
      nStr := 'Select D_Value From %s Where D_Name=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_HYDanWarnVal]);

      with FDM.QueryTemp(nStr) do
      if RecordCount > 0 then
      begin
        nWarnVal := Fields[0].AsFloat;
      end;
      //xxxxx
      if nRestVal <= nWarnVal then
      begin
        nEID := nList.Values['FactoryID'] +
                nList.Values['StockID'] +
                nList.Values['PackingID'] + 'BZ';

        nStr := 'Delete From %s Where E_ID=''%s''';
        nStr := Format(nStr, [sTable_ManualEvent, nEID]);

        FDM.ExecuteSQL(nStr);

        nEvent := '水泥品种[ %s ]的批次编号可用量[ %.2f ],请化验室提前准备';
        nEvent := Format(nEvent,[nStockname + nStockType, nRestVal]);

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

        nStr := MakeSQLByStr([
            SF('E_ID', nEID),
            SF('E_Key', ''),
            SF('E_From', sFlag_DepDaTing),
            SF('E_Event', nEvent),
            SF('E_Solution', sFlag_Solution_OK),
            SF('E_Departmen', sFlag_DepDaTing),
            SF('E_Date', sField_SQLServer_Now, sfVal)
            ], sTable_ManualEvent, '', True);
        FDM.ExecuteSQL(nStr);
      end;
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2018-11-29
//Desc: 生成派车单并返回单号
function NewHhWTDetailWSDL(const nOrder, nTruck, nValue: string;
                                 var nHint: string): string;
var nOut: TWorkerHHJYData;
    nStr: string;
    nList: TStrings;
begin
  Result := '';
  nHint := '';
  nList := TStringList.Create;

  try
    nList.Values['FConsignPlanNumber'] := nOrder;
    nList.Values['Truck']   := nTruck;
    nList.Values['Value'] := nValue;

    nStr := PackerEncodeStr(nList.Text);
    if  CallBusinessHHJY(cBC_NewHhWTDetail, nStr, '', '', @nOut, False) then
    begin
      Result := nOut.FData;
    end
    else
    begin
      nHint := nOut.FData;
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2019-01-04
//Parm: OrderNum
//Desc: 重新同步销售订单状态
function ReVerifySalePlanWSDL(const nOrder, nValue: string;
                                 var nHint: string): string;
var nOut: TWorkerHHJYData;
    nStr: string;
    nList: TStrings;
    nStatus: string;
begin
  Result := '';
  nHint := '';

//  nStr := 'Select O_Valid From %s Where O_Order =''%s'' ';
//  nStr := Format(nStr, [sTable_SalesOrder, nOrder]);
//
//  with FDM.QueryTemp(nStr) do
//  begin
//    if RecordCount <= 0 then
//      Exit;
//    if Fields[0].AsString = sFlag_Yes then//有效
//      Exit;
//  end;


  nList := TStringList.Create;

  try
    nStr := 'FBillCode = ''%s''';
    nStr := Format(nStr, [nOrder]);

    nStr := PackerEncodeStr(nStr);

    if not CallBusinessHHJY(cBC_GetHhSalePlan, nStr, '', '', @nOut, False) then
    begin
      nHint := '获取当前订单[ %s ]信息失败.';
      nHint := Format(nHint, [nOrder]);
      Exit;
    end;

    nList.Text := PackerDecodeStr(nOut.FData);

    if nList.Values['FStatus'] = '1' then
      nStatus := sFlag_Yes
    else
      nStatus := sFlag_No;

    nStr := 'Update %s Set O_Valid=''%s'' Where O_Order =''%s''';
    nStr := Format(nStr, [sTable_SalesOrder, nStatus, nOrder]);

    WriteLog('更新销售订单状态:' + nStr);
    FDM.ExecuteSQL(nStr);

    if nList.Values['FStatus'] <> '1' then
    begin
      nHint := '订单[ %s ]已失效,请联系管理员.';
      nHint := Format(nHint, [nOrder]);
      Exit;
    end;

    if not IsNumber(nList.Values['FRemainAmount'], True) then
    begin
      nHint := '订单[ %s ]可用量[ %s ]非法数字,请联系管理员.';
      nHint := Format(nHint, [nOrder, nList.Values['FRemainAmount']]);
      Exit;
    end;

    if StrToFloat(nValue) > StrToFloat(nList.Values['FRemainAmount']) then
    begin
      nHint := '订单[ %s ]可用量[ %s ]小于当前开单量[ %s ],无法开单.';
      nHint := Format(nHint, [nOrder, nList.Values['FRemainAmount'], nValue]);
      Exit;
    end;
    nHint := '';
  finally
    nList.Free;
  end;
end;

//Date: 2019-06-13
//Parm: 提货ID
//Desc: 开单校验客户资金
function KDVerifyHhSalePlanWSDL(const nPrice, nValue: Double;
                                   nPriceDate:string;
                                 var nHint: string): Boolean;
var nOut: TWorkerHHJYData;
    nStr: string;
    nList: TStrings;
begin
  WriteLog('开单资金校验:价格' + FloatToStr(nPrice) + '提货量:' +
           FloatToStr(nValue));
  Result := False;
  nHint := '';
  nList := TStringList.Create;

  try
    nList.Values['FPriceDate'] := nPriceDate;
    nList.Values['FPoundValue'] := FloatToStr(nValue);
    nList.Values['FMoney'] := Format('%.2f', [nPrice * nValue]);

    nStr := PackerEncodeStr(nList.Text);
    if  not CallBusinessHHJY(cBC_PoundVerifyHhSalePlan, nStr, '', '', @nOut, False) then
    begin
      WriteLog('开单失败:' + nOut.FData);
      nHint := '开单失败.[ 订单异常或账户资金不足 ]';
      Exit;
    end;
    Result := True;
  finally
    nList.Free;
  end;
end;

//Date: 2018-02-06
//Parm: 化验单
//Desc: 读取ERP批次记录
function SaveHYData(const nHYDan: string): Boolean;
var nOut: TWorkerHHJYData;
    nlist : tstrings;
begin
  Result := False;

  nlist := TStringList.Create;
  try
    nlist.Values['HYDan'] := nHYDan;

    Result := CallBusinessHHJY(cBC_SaveHhHyData,
                               PackerEncodeStr(nlist.Text), '', '', @nOut, False);
  finally
    nlist.Free;
  end;
end;

//Desc: 打印标识为nHID的化验单
function PrintHuaYanReport(const nBill: string; var nHint: string;
 const nPrinter: string = ''): Boolean;
var nStr: string;
    nSPCount, nDPCount, nPCount: Integer;
begin
  nHint := '';
  Result := False;

  nSPCount := 5;
  nStr := 'Select D_Value From %s ' +
          ' Where D_Name = ''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_AICMHYSanPCount]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nSPCount := Fields[0].AsInteger;
    end;
  end;

  nDPCount := 5;
  nStr := 'Select D_Value From %s ' +
          ' Where D_Name = ''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_AICMHYDaiPCount]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nDPCount := Fields[0].AsInteger;
    end;
  end;

  nStr := 'Select sr.*,sb.* From %s sr ' +
          ' Left Join %s sb on sr.R_SerialNo=sb.L_HYDan ' +
          ' Where sb.L_ID = ''%s''';
  nStr := Format(nStr, [sTable_StockRecord, sTable_Bill, nBill]);

  WriteLog('化验单查询:'+nStr);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nHint := '提货单[ %s ]没有对应的化验单';
      nHint := Format(nHint, [nBill]);
      Exit;
    end;

    if FieldByName('L_Type').AsString = sFlag_Dai then
      nPCount := nDPCount
    else
      nPCount := nSPCount;

    if FieldByName('L_HyPrintCount').AsInteger >= nPCount then
    begin
      nHint :='超出设定打印次数,请联系管理员';
      Exit
    end;

    nStr := FieldByName('L_StockName').AsString;
    nStr := GetReportFileByStock(nStr);

    if not FDR.LoadReportFile(nStr) then
    begin
      nHint := '无法正确加载报表文件: ' + nStr;
      Exit;
    end;

    if nPrinter = '' then
         FDR.Report1.PrintOptions.Printer := 'My_Default_HYPrinter'
    else FDR.Report1.PrintOptions.Printer := nPrinter;

    FDR.Dataset1.DataSet := FDM.SQLTemp;
//    FDR.ShowReport;
    FDR.PrintReport;
    Result := FDR.PrintSuccess;

    if Result then
    begin
      nStr := 'Update %s Set L_HyPrintCount=L_HyPrintCount + 1 ' +
              'Where L_ID=''%s''';
      nStr := Format(nStr, [sTable_Bill, nBill]);
      FDM.ExecuteSQL(nStr);
    end;
  end;
end;

function IsCardValid(const nCard: string): Boolean;
var
  nSql:string;
begin
  Result := False;

  nSql := 'select C_Card2,C_Card3 from %s where C_Card = ''%s'' ';
  nSql := Format(nSql,[sTable_Card,nCard]);

  with FDM.QueryTemp(nSql) do
  begin
    if recordcount>0 then
    begin
      if (Trim(Fields[0].AsString) <> '') or (Trim(Fields[1].AsString) <> '')then
      begin
        Result := True;
      end;
    end;
  end;
end;

//车辆是否存在未完成提货单
function IFHasBill(const nTruck: string; var nID: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr :='select L_ID from %s where L_Status <> ''%s'' and L_Truck =''%s'' ';
  nStr := Format(nStr, [sTable_Bill, sFlag_TruckOut, nTruck]);
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nID := Fields[0].AsString;
    Result := True;
  end;
end;

//车辆是否存在未完成采购单
function IFHasOrder(const nTruck: string; var nID: string): Boolean;
var nStr: string;
begin
  Result      := False;
  //采购主表有磁卡号
  nStr :='select O_ID from %s where O_Truck =''%s'' and O_Card<> '''' and O_Card is not null ';
  nStr := Format(nStr, [sTable_Order, nTruck]);
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nID := Fields[0].AsString;
    Result := True;
  end;
end;

function IsPurOrderHasControl(nProID,nStockNo: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr := 'Select * From %s Where C_CusName=''%s''';
  nStr := Format(nStr, [sTable_PMaterailControl, sFlag_PMaterailControl]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount <= 0 then
      Exit;

    if FieldByName('C_Valid').AsString <> sFlag_Yes then
      Exit;
  end;

  nStr := 'Select C_Valid From %s Where C_CusID=''%s'' and C_StockNo=''%s''';
  nStr := Format(nStr, [sTable_PMaterailControl, nProID, nStockNo]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString = sFlag_Yes;
  end;
end;

function GetMaxLadeValue(const nTruck: string): Double;
var nStr: string;
begin
  Result := 0;

  nStr := 'Select T_MaxLadeValue From %s ' +
          'Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTruck]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nStr := Fields[0].AsString;
      if IsNumber(nStr,True) then
        Result := StrToFloat(nStr);
    end;
  end;
end;

function GetMinLadeValue: Double;
var nStr: string;
begin
  Result := 0;

  nStr := 'Select D_Value From %s ' +
          'Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SanMinKDValue]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nStr := Fields[0].AsString;
      if IsNumber(nStr,True) then
        Result := StrToFloat(nStr);
    end;
  end;
end;

end.
