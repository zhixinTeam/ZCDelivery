{*******************************************************************************
  作者: dmzn@163.com 2017-09-21
  描述: 业务常量定义

  备注:
  *.所有In/Out数据,最好带有TBWDataBase基数据,且位于第一个元素.
*******************************************************************************}
unit UBusinessConst;

interface

uses
  Classes, SysUtils, UBusinessPacker, ULibFun, USysDB;

const
  {*channel type*}
  cBus_Channel_Connection     = $0002;
  cBus_Channel_Business       = $0005;

  {*query field define*}
  cQF_Bill                    = $0001;
  
  {*business command*}
  cBC_GetSerialNO             = $0001;   //获取串行编号
  cBC_ServerNow               = $0002;   //服务器当前时间
  cBC_IsSystemExpired         = $0003;   //系统是否已过期
  cBC_GetCardUsed             = $0004;   //获取卡片类型
  cBC_UserLogin               = $0005;   //用户登录
  cBC_UserLogOut              = $0006;   //用户注销

  cBC_SaveTruckInfo           = $0013;   //保存车辆信息
  cBC_UpdateTruckInfo         = $0017;   //保存车辆信息
  cBC_GetTruckPoundData       = $0015;   //获取车辆称重数据
  cBC_SaveTruckPoundData      = $0016;   //保存车辆称重数据

  cBC_SaveBills               = $0020;   //保存交货单列表
  cBC_DeleteBill              = $0021;   //删除交货单
  cBC_PostBill                = $0022;   //过账交货单
  cBC_ReverseBill             = $0023;   //冲销交货单
  cBC_SaleAdjust              = $0024;   //销售调拨
  cBC_SaveBillCard            = $0025;   //绑定交货单磁卡
  cBC_LogoffCard              = $0026;   //注销磁卡
  cBC_SaveBillLSCard          = $0027;   //绑定厂内零售磁卡
  cBC_ModifyBillTruck         = $0028;   //修改车牌号

  cBC_GetPostBills            = $0030;   //获取岗位交货单
  cBC_SavePostBills           = $0031;   //保存岗位交货单
  cBC_ChangeDispatchMode      = $0032;   //切换调度模式

  cBC_SaveOrder               = $0040;
  cBC_DeleteOrder             = $0041;
  cBC_SaveOrderCard           = $0042;
  cBC_LogOffOrderCard         = $0043;
  cBC_GetPostOrders           = $0044;   //获取岗位采购单
  cBC_SavePostOrders          = $0045;   //保存岗位采购单
  cBC_SaveOrderBase           = $0046;   //保存采购申请单
  cBC_DeleteOrderBase         = $0047;   //删除采购申请单
  cBC_GetGYOrderValue         = $0048;   //获取已收货量

  cBC_GetPoundCard            = $0054;   //获取磅站卡号
  cBC_GetQueueData            = $0055;   //获取队列数据
  cBC_PrintCode               = $0056;   //喷码:发送喷码
  cBC_PrintFixCode            = $0057;   //喷码:固定喷码
  cBC_PrinterEnable           = $0058;   //喷码:启停
  cBC_GetStockBatcode         = $0059;   //获取批次编号

  cBC_JSStart                 = $0060;   //计数:启动
  cBC_JSStop                  = $0061;   //计数:停止
  cBC_JSPause                 = $0062;   //计数:暂停
  cBC_JSGetStatus             = $0063;   //计数:状态
  cBC_SaveCountData           = $0064;   //计数:保存
  cBC_RemoteExecSQL           = $0065;

  cBC_IsTunnelOK              = $0075;   //车检:通道判断
  cBC_TunnelOC                = $0076;   //车检:通道开合
  cBC_PlayVoice               = $0077;   //语音:播发语音
  cBC_OpenDoorByReader        = $0078;   //道闸:抬杆
  cBC_ShowTxt                 = $0079;   //车检:发送小屏

  cBC_VerifySnapTruck         = $0081;   //车牌比对
  cBC_TruckTimeOut            = $0082;   //散装车辆出厂超时

  cBC_SyncHhSaleMateriel      = $0091;   //同步销售物料
  cBC_SyncHhProvideMateriel   = $0092;   //同步采购物料
  cBC_SyncHhCustomer          = $0093;   //同步销售客户
  cBC_SyncHhProvider          = $0094;   //同步采购供应商
  cBC_GetHhOrderPlan          = $0095;   //获取采购进厂计划
  cBC_SyncHhOrderPoundData    = $0096;   //上传采购磅单
  cBC_GetHhNeiDaoOrderPlan    = $0097;   //获取采购内倒进厂计划
  cBC_SyncHhNdOrderPoundData  = $0098;   //上传采购内倒磅单
  cBC_SyncHhOtOrderPoundData  = $0099;   //上传采购临时磅单
  cBC_GetHhSalePlan           = $0100;   //获取销售计划
  cBC_SyncHhSaleDetail        = $0101;   //上传销售发货明细
  cBC_SyncHhSaleWTTruck       = $0102;   //获取销售委托车辆
  cBC_PoundVerifyHhSalePlan   = $0103;   //销售计划过磅校验
  cBC_BillVerifyHhSalePlan    = $0104;   //销售计划开单校验
  cBC_IsHhSaleDetailExits     = $0105;   //查询发货明细
  cBC_GetHhSaleDetailID       = $0106;   //获取新增发货明细ID
  cBC_GetHhSaleWareNumber     = $0107;   //获取批次号

  cBC_IsHhOrderDetailExits    = $0108;   //查询普通原材料采购单明细
  cBC_GetHhOrderDetailID      = $0109;   //获取新增普通原材料采购单明细ID

  cBC_IsHhNdOrderDetailExits  = $0110;   //查询内倒原材料采购单明细
  cBC_GetHhNdOrderDetailID    = $0111;   //获取新增内倒原材料采购单明细ID

  cBC_IsHhOtherOrderDetailExits= $0112;  //查询临时称重采购单明细
  cBC_GetHhOtherOrderDetailID = $0113;   //获取新增临时称重采购单明细ID

  cBC_SyncHhSaleWareNumber    = $0114;   //同步批次号
  cBC_GetHhSaleRealPrice      = $0115;   //获取最新价格

  cBC_NewHhWTDetail           = $0116;   //生成派车单

  cBC_WX_VerifPrintCode       = $0501;   //微信：验证喷码信息
  cBC_WX_WaitingForloading    = $0502;   //微信：工厂待装查询
  cBC_WX_BillSurplusTonnage   = $0503;   //微信：网上订单可下单数量查询
  cBC_WX_GetOrderInfo         = $0504;   //微信：获取订单信息
  cBC_WX_GetOrderList         = $0505;   //微信：获取订单列表
  cBC_WX_GetPurchaseContract  = $0506;   //微信：获取采购合同列表

  cBC_WX_getCustomerInfo      = $0507;   //微信：获取客户注册信息
  cBC_WX_get_Bindfunc         = $0508;   //微信：客户与微信账号绑定
  cBC_WX_send_event_msg       = $0509;   //微信：发送消息
  cBC_WX_edit_shopclients     = $0510;   //微信：新增商城用户
  cBC_WX_edit_shopgoods       = $0511;   //微信：添加商品
  cBC_WX_get_shoporders       = $0512;   //微信：获取订单信息
  cBC_WX_complete_shoporders  = $0513;   //微信：修改订单状态
  cBC_WX_get_shoporderbyNO    = $0514;   //微信：根据订单号获取订单信息
  cBC_WX_get_shopPurchasebyNO = $0515;   //微信：根据订单号获取订单信息
  cBC_WX_ModifyWebOrderStatus = $0516;   //微信：修改网上订单状态
  cBC_WX_CreatLadingOrder     = $0517;   //微信：创建交货单
  cBC_WX_GetCusMoney          = $0518;   //微信：获取客户资金
  cBC_WX_GetInOutFactoryTotal = $0519;   //微信：获取进出厂统计
  cBC_WX_GetAuditTruck        = $0520;   //微信：获取审核车辆
  cBC_WX_UpLoadAuditTruck     = $0521;   //微信：审核车辆结果上传
  cBC_WX_DownLoadPic          = $0522;   //微信：下载图片
  cBC_WX_get_shoporderbyTruck = $0523;   //微信：根据车牌号获取订单信息

type
  PWorkerQueryFieldData = ^TWorkerQueryFieldData;
  TWorkerQueryFieldData = record
    FBase     : TBWDataBase;
    FType     : Integer;           //类型
    FData     : string;            //数据
  end;

  PWorkerBusinessCommand = ^TWorkerBusinessCommand;
  TWorkerBusinessCommand = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //命令
    FData     : string;            //数据
    FExtParam : string;            //参数
  end;

  TWorkerSapURL = record
    FSapName: string;              //函数名
    FSapURL: string;               //业务地址
    FSapParam: string;             //业务参数
    FSapMethod: string;            //业务方法
    FEncodeURL: Boolean;           //加密地址
    FEncodeXML: Boolean;           //加密XML
  end;

  TTWorkerSapURLs = array of TWorkerSapURL;
  //地址列表

  TPoundStationData = record
    FStation  : string;            //磅站标识
    FValue    : Double;           //皮重
    FDate     : TDateTime;        //称重日期
    FOperator : string;           //操作员
  end;

  PLadingBillItem = ^TLadingBillItem;
  TLadingBillItem = record
    FID         : string;          //交货单号
    FNewID      : string;          //过账单号
    FZhiKa      : string;          //纸卡编号
    FCusID      : string;          //客户编号
    FCusName    : string;          //客户名称
    FTruck      : string;          //车牌号码

    FType       : string;          //品种类型
    FStockNo    : string;          //品种编号
    FStockName  : string;          //品种名称
    FValue      : Double;          //提货量
    FPrice      : Double;          //提货单价

    FCard       : string;          //磁卡号
    FIsVIP      : string;          //通道类型
    FStatus     : string;          //当前状态
    FNextStatus : string;          //下一状态

    FPData      : TPoundStationData; //称皮
    FMData      : TPoundStationData; //称毛
    FFactory    : string;          //工厂编号
    FPModel     : string;          //称重模式
    FPType      : string;          //业务类型
    FPoundID    : string;          //称重记录
    FSelected   : Boolean;         //选中状态

    FYSValid    : string;          //验收结果，Y验收成功；N拒收；
    FKZValue    : Double;          //供应扣除
    FPrintHY    : Boolean;         //打印化验单
    FHYDan      : string;          //化验单号
    FMemo       : string;          //动作备注
    FWebOrderID : string;          //商城申请单
    FNeiDao     : string;          //内倒
    Fexpiretime : string;
    FCtype      : string;          //卡类型；'L'：临时；'G'：固定
    FPoundIdx   : Integer;          //多物料称重顺序
    FPoundMax   : Integer;          //多物料称重总次数
    FPrintBD    : Boolean;         //打印磅单
  end;

  TLadingBillItems = array of TLadingBillItem;
  //交货单列表

  PWorkerWebChatData = ^TWorkerWebChatData;
  TWorkerWebChatData = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //类型
    FData     : string;            //数据
    FExtParam : string;            //参数
    FRemoteUL : string;            //工厂服务器UL
  end;

  PWorkerHHJYData = ^TWorkerHHJYData;
  TWorkerHHJYData = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //类型
    FData     : string;            //数据
    FExtParam : string;            //参数
    FRemoteUL : string;            //工厂服务器UL
  end;

procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
//解析由业务对象返回的交货单数据
function CombineBillItmes(const nItems: TLadingBillItems): string;
//合并交货单数据为业务对象能处理的字符串

var
  gSapURLs: TTWorkerSapURLs;       //业务列表
  gSapURLInited: Integer = 0;      //是否初始化

resourcestring
  {*common function*}
  sSys_SweetHeart             = 'Sys_SweetHeart';       //心跳指令
  sSys_BasePacker             = 'Sys_BasePacker';       //基本封包器

  {*PBWDataBase.FParam*}
  sParam_NoHintOnError        = 'NHE';                  //不提示错误

  {*plug module id*}
  sPlug_ModuleBus             = '{DF261765-48DC-411D-B6F2-0B37B14E014E}';
                                                        //业务模块
  sPlug_ModuleHD              = '{B584DCD6-40E5-413C-B9F3-6DD75AEF1C62}';
                                                        //硬件守护
  sPlug_ModuleRemote          = '{B584DCD7-40E5-413C-B9F3-6DD75AEF1C63}';
                                                        //MIT互相访问

  {*sap mit function name*}
  sSAP_ServiceStatus          = 'SAP_ServiceStatus';    //服务状态
  sSAP_ReadXSSaleOrder        = 'SAP_Read_XSSaleOrder'; //销售订单
  sSAP_CreateSaleBill         = 'SAP_Create_SaleBill';  //创建交货单
  sSAP_ModifySaleBill         = 'SAP_Modify_SaleBill';  //修改交货单
  sSAP_DeleteSaleBill         = 'SAP_Delete_SaleBill';  //删除交货单
  sSAP_PickSaleBill           = 'SAP_Pick_SaleBill';    //拣配交货单
  sSAP_PostSaleBill           = 'SAP_Post_SaleBill';    //过账交货单
  sSAP_ReverseSaleBill        = 'SAP_Reverse_SaleBill'; //冲销交货单
  sSAP_ReadSaleBill           = 'SAP_Read_SaleBill';    //读取交货单

  {*business mit function name*}
  sBus_ServiceStatus          = 'Bus_ServiceStatus';    //服务状态
  sBus_GetQueryField          = 'Bus_GetQueryField';    //查询的字段

  sBus_ReadXSSaleOrder        = 'Bus_Read_XSSaleOrder'; //销售订单
  sBus_CreateSaleBill         = 'Bus_Create_SaleBill';  //创建交货单
  sBus_ModifySaleBill         = 'Bus_Modify_SaleBill';  //修改交货单
  sBus_DeleteSaleBill         = 'Bus_Delete_SaleBill';  //删除交货单
  sBus_PickSaleBill           = 'Bus_Pick_SaleBill';    //拣配交货单
  sBus_PostSaleBill           = 'Bus_Post_SaleBill';    //过账交货单
  sBus_ReverseSaleBill        = 'Bus_Reverse_SaleBill'; //冲销交货单
  sBus_ReadSaleBill           = 'Bus_Read_SaleBill';    //读取交货单

  sBus_BusinessSaleBill       = 'Bus_BusinessSaleBill'; //交货单相关
  sBus_BusinessCommand        = 'Bus_BusinessCommand';  //业务指令
  sBus_HardwareCommand        = 'Bus_HardwareCommand';  //硬件指令
  sBus_BusinessWebchat        = 'Bus_BusinessWebchat';  //Web平台服务
  sBus_BusinessPurchase       = 'Bus_BusinessPurchase'; //采购单相关
  sBus_BusinessHHJY           = 'Bus_BusinessHHJY';     //恒河久远接口服务

  {*client function name*}
  sCLI_ServiceStatus          = 'CLI_ServiceStatus';    //服务状态
  sCLI_GetQueryField          = 'CLI_GetQueryField';    //查询的字段

  sCLI_BusinessSaleBill       = 'CLI_BusinessSaleBill'; //交货单业务
  sCLI_BusinessCommand        = 'CLI_BusinessCommand';  //业务指令
  sCLI_HardwareCommand        = 'CLI_HardwareCommand';  //硬件指令
  sCLI_BusinessWebchat        = 'CLI_BusinessWebchat';  //Web平台服务
  sCLI_BusinessPurchaseOrder  = 'CLI_BusinessPurchaseOrder'; //采购单相关
  sCLI_BusinessHHJY           = 'CLI_BusinessHHJY';     //恒河久远接口服务

implementation

//Date: 2017-09-17
//Parm: 交货单数据;解析结果
//Desc: 解析nData为结构化列表数据
procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
var nStr: string;
    nIdx,nInt: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(nData);
    //bill list
    nInt := 0;
    SetLength(nItems, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      //bill item

      with nListB,nItems[nInt] do
      begin
        FID         := Values['ID'];
        FNewID      := Values['NewID'];
        FZhiKa      := Values['ZhiKa'];
        FCusID      := Values['CusID'];
        FCusName    := Values['CusName'];
        FTruck      := Values['Truck'];

        FType       := Values['Type'];
        FStockNo    := Values['StockNo'];
        FStockName  := Values['StockName'];

        FCard       := Values['Card'];
        FIsVIP      := Values['IsVIP'];
        FStatus     := Values['Status'];
        FNextStatus := Values['NextStatus'];

        FFactory    := Values['Factory'];
        FPModel     := Values['PModel'];
        FPType      := Values['PType'];
        FPoundID    := Values['PoundID'];
        FSelected   := Values['Selected'] = sFlag_Yes;

        with FPData do
        begin
          FStation  := Values['PStation'];
          FDate     := Str2DateTime(Values['PDate']);
          FOperator := Values['PMan'];

          nStr := Trim(Values['PValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FPData.FValue := StrToFloat(nStr)
          else FPData.FValue := 0;
        end;

        with FMData do
        begin
          FStation  := Values['MStation'];
          FDate     := Str2DateTime(Values['MDate']);
          FOperator := Values['MMan'];

          nStr := Trim(Values['MValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FMData.FValue := StrToFloat(nStr)
          else FMData.FValue := 0;
        end;

        nStr := Trim(Values['Value']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FValue := StrToFloat(nStr)
        else FValue := 0;

        nStr := Trim(Values['Price']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FPrice := StrToFloat(nStr)
        else FPrice := 0;

        nStr := Trim(Values['KZValue']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FKZValue := StrToFloat(nStr)
        else FKZValue := 0;

        FYSValid := Values['YSValid'];
        FPrintHY := Values['PrintHY'] = sFlag_Yes;
        FHYDan   := Values['HYDan'];
        FMemo    := Values['Memo'];
        FWebOrderID := Values['WebOrderID'];
        FNeiDao  := Values['NeiDao'];
        Fexpiretime := Values['expiretime'];
        FCtype := Values['ctype'];
        FPoundIdx := StrToIntDef(Values['PoundIdx'],0);
        FPoundMax := StrToIntDef(Values['PoundMax'],0);
        FPrintBD := Values['PrintBD'] = sFlag_Yes;
      end;

      Inc(nInt);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;
end;

//Date: 2017-09-18
//Parm: 交货单列表
//Desc: 将nItems合并为业务对象能处理的
function CombineBillItmes(const nItems: TLadingBillItems): string;
var nIdx: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    Result := '';
    nListA.Clear;
    nListB.Clear;

    for nIdx:=Low(nItems) to High(nItems) do
    with nItems[nIdx] do
    begin
      if not FSelected then Continue;
      //ignored

      with nListB do
      begin
        Values['ID']         := FID;
        Values['NewID']      := FNewID;
        Values['ZhiKa']      := FZhiKa;
        Values['CusID']      := FCusID;
        Values['CusName']    := FCusName;
        Values['Truck']      := FTruck;

        Values['Type']       := FType;
        Values['StockNo']    := FStockNo;
        Values['StockName']  := FStockName;
        Values['Value']      := FloatToStr(FValue);
        Values['Price']      := FloatToStr(FPrice);

        Values['Card']       := FCard;
        Values['IsVIP']      := FIsVIP;
        Values['Status']     := FStatus;
        Values['NextStatus'] := FNextStatus;

        Values['Factory']    := FFactory;
        Values['PModel']     := FPModel;
        Values['PType']      := FPType;
        Values['PoundID']    := FPoundID;

        with FPData do
        begin
          Values['PStation'] := FStation;
          Values['PValue']   := FloatToStr(FPData.FValue);
          Values['PDate']    := DateTime2Str(FDate);
          Values['PMan']     := FOperator;
        end;

        with FMData do
        begin
          Values['MStation'] := FStation;
          Values['MValue']   := FloatToStr(FMData.FValue);
          Values['MDate']    := DateTime2Str(FDate);
          Values['MMan']     := FOperator;
        end;

        if FSelected then
             Values['Selected'] := sFlag_Yes
        else Values['Selected'] := sFlag_No;

        Values['KZValue']    := FloatToStr(FKZValue);
        Values['YSValid']    := FYSValid;
        Values['Memo']       := FMemo;
        Values['WebOrderID'] := FWebOrderID;
        if FPrintHY then
             Values['PrintHY'] := sFlag_Yes
        else Values['PrintHY'] := sFlag_No;
        Values['HYDan']    := FHYDan;
        Values['NeiDao']   := FNeiDao;
        Values['expiretime'] := Fexpiretime;
        Values['ctype'] := FCtype;
        Values['PoundIdx'] := IntToStr(FPoundIdx);
        Values['PoundMax'] := IntToStr(FPoundMax);
        if FPrintBD then
             Values['PrintBD'] := sFlag_Yes
        else Values['PrintBD'] := sFlag_No;
      end;

      nListA.Add(PackerEncodeStr(nListB.Text));
      //add bill
    end;

    Result := PackerEncodeStr(nListA.Text);
    //pack all
  finally
    nListB.Free;
    nListA.Free;
  end;
end;

end.


