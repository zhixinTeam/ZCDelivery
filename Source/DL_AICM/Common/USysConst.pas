{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls,UBusinessPacker, Messages;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引
  cRecMenuMax           = 5;                         //最近使用导航区最大条目数
  
  cShouJuIDLength       = 7;                         //财务收据标识长度
  cItemIconIndex        = 11;                        //默认的提货单列表图标

  cSendWeChatMsgType_AddBill     = 1; //开提货单
  cSendWeChatMsgType_OutFactory  = 2; //车辆出厂
  cSendWeChatMsgType_Report      = 3; //报表
  cSendWeChatMsgType_DelBill     = 4; //删提货单

  c_WeChatStatusCreateCard       = 0; //订单已办卡
  c_WeChatStatusFinished         = 1; //订单已完成
  WM_HAVE_CARD          = WM_USER + 1 ;
const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //系统日志
  cFI_FrameViewLog      = $0002;                     //本地日志
  cFI_FrameAuthorize    = $0003;                     //系统授权

  cFI_FrameCustomer     = $0004;                     //客户管理
  cFI_FrameSalesMan     = $0005;                     //业务员
  cFI_FrameSaleContract = $0006;                     //销售合同
  cFI_FrameZhiKa        = $0007;                     //办理纸卡
  cFI_FrameMakeCard     = $0012;                     //办理磁卡
  cFI_FrameBill         = $0013;                     //开提货单
  cFI_FrameBillQuery    = $0014;                     //开单查询
  cFI_FrameMakeOCard    = $0015;                     //办理采购磁卡

  cFI_FrameShouJu       = $0020;                     //收据查询
  cFI_FrameZhiKaVerify  = $0021;                     //纸卡审核
  cFI_FramePayment      = $0022;                     //销售回款
  cFI_FrameCusCredit    = $0023;                     //信用管理

  cFI_FrameLadingDai    = $0030;                     //袋装提货
  cFI_FramePoundQuery   = $0031;                     //磅房查询
  cFI_FrameFangHuiQuery = $0032;                     //放灰查询
  cFI_FrameZhanTaiQuery = $0033;                     //栈台查询
  cFI_FrameZTDispatch   = $0034;                     //栈台调度
  cFI_FramePoundManual  = $0035;                     //手动称重
  cFI_FramePoundAuto    = $0036;                     //自动称重

  cFI_FrameStock        = $0042;                     //品种管理
  cFI_FrameStockRecord  = $0043;                     //检验记录
  cFI_FrameStockHuaYan  = $0045;                     //开化验单
  cFI_FrameStockHY_Each = $0046;                     //随车开单

  cFI_FrameTruckQuery   = $0050;                     //车辆查询
  cFI_FrameCusAccountQuery = $0051;                  //客户账户
  cFI_FrameCusInOutMoney   = $0052;                  //出入金明细
  cFI_FrameSaleTotalQuery  = $0053;                  //累计发货
  cFI_FrameSaleDetailQuery = $0054;                  //发货明细
  cFI_FrameZhiKaDetail  = $0055;                     //纸卡明细
  cFI_FrameDispatchQuery = $0056;                    //调度查询
  cFI_FrameOrderDetailQuery = $0057;                 //采购明细

  cFI_FrameSaleInvoice  = $0061;                     //发票管理
  cFI_FrameMakeInvoice  = $0062;                     //开具发票
  cFI_FrameInvoiceWeek  = $0063;                     //结算周期
  cFI_FrameSaleZZ       = $0065;                     //销售扎账
  cFI_FrameSaleJS       = $0069;                     //销售结算

  cFI_FrameTrucks       = $0070;                     //车辆档案

  cFI_FrameTransBase    = $0093;                     //短倒办理
  cFI_FrameTransferDetailQuery = $0094;              //短倒明细查询

  cFI_FrameProvider     = $0102;                     //供应
  cFI_FrameProvideLog   = $0105;                     //供应日志
  cFI_FrameMaterails    = $0106;                     //原材料
  cFI_FrameOrder        = $0107;                     //采购订单
  cFI_FrameOrderBase    = $0108;                     //采购申请单
  cFI_FrameOrderDetail  = $0109;                     //采购明细

  cFI_FrameWXAccount    = $0110;                     //微信账户
  cFI_FrameWXSendLog    = $0111;                     //发送日志
  cFI_FrameYTBatchcode  = $0112;                     //云天批次编号记录 
  cFI_FrameZTLines      = $0113;                     //栈台信息
  cFI_FrameSPrice       = $0114;                     //销售单价
  cFI_FrameWXBind       = $0115;                     //发送日志  

  cFI_FormMemo          = $1000;                     //备注窗口
  cFI_FormBackup        = $1001;                     //数据备份
  cFI_FormRestore       = $1002;                     //数据恢复
  cFI_FormIncInfo       = $1003;                     //公司信息
  cFI_FormChangePwd     = $1005;                     //修改密码

  cFI_FormBaseInfo      = $1006;                     //基本信息
  cFI_FormCustomer      = $1007;                     //客户资料
  cFI_FormSaleMan       = $1008;                     //业务员
  cFI_FormSaleContract  = $1009;                     //销售合同
  cFI_FormZhiKa         = $1010;                     //纸卡办理
  cFI_FormZhiKaParam    = $1011;                     //纸卡参数
  cFI_FormGetZhika      = $1012;                     //选择纸卡
  cFI_FormMakeCard      = $1013;                     //办理磁卡
  cFI_FormMakeRFIDCard  = $1014;                     //办理电子标签

  cFI_FormBill          = $1016;                     //开提货单
  cFI_FormBillNew       = $1017;                     //读取订单
  cFI_FormZhiKaVerify   = $1018;                     //纸卡审核
  cFI_FormCusCredit     = $1019;                     //信用变动
  cFI_FormPayment       = $1020;                     //销售回款
  cFI_FormTruckIn       = $1021;                     //车辆进厂
  cFI_FormTruckOut      = $1022;                     //车辆出厂
  cFI_FormVerifyCard    = $1023;                     //磁卡验证
  cFI_FormAutoBFP       = $1024;                     //自动过皮
  cFI_FormBangFangP     = $1025;                     //称量皮重
  cFI_FormBangFangM     = $1026;                     //称量毛重
  cFI_FormLadDai        = $1027;                     //袋装提货
  cFI_FormLadSan        = $1028;                     //散装提货
  cFI_FormJiShuQi       = $1029;                     //计数管理
  cFI_FormBFWuCha       = $1030;                     //净重误差
  cFI_FormZhiKaQuery    = $1031;                     //卡片信息
  cFI_FormBuDan         = $1032;                     //销售补单
  cFI_FormZhiKaInfoExt1 = $1033;                     //纸卡扩展
  cFI_FormZhiKaInfoExt2 = $1034;                     //纸卡扩展
  cFI_FormZhiKaAdjust   = $1035;                     //纸卡调整
  cFI_FormZhiKaFixMoney = $1036;                     //限提金额
  cFI_FormSaleAdjust    = $1037;                     //销售调剂
  cFI_FormEditPrice     = $1040;                     //提货单价
  cFI_FormGetProvider   = $1041;                     //选择供应商
  cFI_FormGetMeterail   = $1042;                     //选择原材料
  cFI_FormTruckEmpty    = $1043;                     //空车出厂
  cFI_FormReadCard      = $1044;                     //读取磁卡
  cFI_FormZTLine        = $1045;                     //装车线

  cFI_FormGetTruck      = $1047;                     //选择车辆
  cFI_FormGetContract   = $1048;                     //选择合同
  cFI_FormGetCustom     = $1049;                     //选择客户
  cFI_FormGetStockNo    = $1050;                     //选择编号
  cFI_FormProvider      = $1051;                     //供应商
  cFI_FormMaterails     = $1052;                     //原材料
  cFI_FormOrder         = $1053;                     //采购订单
  cFI_FormOrderBase     = $1054;                     //采购订单
  cFI_FormPurchase      = $1055;                     //采购验收
  cFI_FormGetPOrderBase = $1056;                     //采购订单
  cFI_FormGetYTBatch    = $1057;                     //获取云天批次

  cFI_FormStockParam    = $1065;                     //品种管理
  cFI_FormStockHuaYan   = $1066;                     //开化验单
  cFI_FormStockHY_Each  = $1067;                     //随车开单

  cFI_FormPaymentZK     = $1068;                     //纸卡回款
  cFI_FormFreezeZK      = $1069;                     //冻结纸卡
  cFI_FormAdjustPrice   = $1070;                     //纸卡调价

  cFI_FormTrucks        = $1071;                     //车辆档案

  cFI_FormInvoiceWeek   = $1075;                     //结算周期
  cFI_FormSaleInvoice   = $1076;                     //发票管理
  cFI_FormMakeInvoice   = $1077;                     //开具发票
  cFI_FormViewInvoices  = $1078;                     //开票列表
  cFI_FormSaleZZALL     = $1079;                     //扎账(全部)
  cFI_FormSaleZZCus     = $1080;                     //扎账(客户)
  cFI_FormInvGetWeek    = $1081;                     //选择周期
  cFI_FormInvAdjust     = $1082;                     //修改申请量

  cFI_FormAuthorize     = $1090;                     //安全验证
  cFI_FormWXAccount     = $1091;                     //微信账户
  cFI_FormWXSendlog     = $1092;                     //微信日志

  cFI_FormTransBase     = $1093;                     //短倒办理

  cFI_FormSPrice        = $1094;                     //销售单价
  cFI_FormWeixinBind    = $1095;                     //微信账号绑定

  cFI_FormBarCodePrint  = $1096;                     //扫码打印化验单  

  {*Command*}
  cCmd_RefreshData      = $0002;                     //刷新数据
  cCmd_ViewSysLog       = $0003;                     //系统日志

  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_ViewData         = $1006;                     //查看数据
  cCmd_GetData          = $1007;                     //选择数据

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容
    FFactory    : string;                            //工厂ID

    FUserID     : string;                            //用户标识
    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FGroupID    : string;                            //所在组
    FIsAdmin    : Boolean;                           //是否管理员
    FIsNormal   : Boolean;                           //帐户是否正常

    FRecMenuMax : integer;                           //导航栏个数
    FIconFile   : string;                            //图标配置文件
    FUsesBackDB : Boolean;                           //使用备份库

    FLocalIP    : string;                            //本机IP
    FLocalMAC   : string;                            //本机MAC
    FLocalName  : string;                            //本机名称
    FHardMonURL : string;                            //硬件守护
    FWechatURL  : string;                            //微信服务
    FHHJYURL    : string;                            //恒河久远接口服务

    FFactNum    : string;                            //工厂编号
    FSerialID   : string;                            //电脑编号
    FIsManual   : Boolean;                           //手动过磅
    FAutoPound  : Boolean;                           //自动称重

    FPoundDaiZ  : Double;
    FPoundDaiZ_1: Double;                            //袋装正误差
    FPoundDaiF  : Double;
    FPoundDaiF_1: Double;                            //袋装负误差
    FDaiPercent : Boolean;                           //按比例计算偏差
    FDaiWCStop  : Boolean;                           //不允许袋装偏差
    FPoundSanF  : Double;                            //散装负误差
    FPicBase    : Integer;                           //图片索引
    FPicPath    : string;                            //图片目录
    FVoiceUser  : Integer;                           //语音计数
    FProberUser : Integer;                           //检测器技术

    FAppFlag    : string;                            //程序标识
    FHYDanPrinter:string;                            //指定化验单打印的打印机
    FCardPrinter:string;                             //指定小票打印机
    FCanCreateCard:Boolean;                          //是否允许自助办卡
    FSanZhuangACIM:Boolean;                          //散装是否允许自助办卡
    FAutoClose_Mintue:Integer;                       //用户自助办卡窗口自动关闭时间
    FWebOrderLength:Integer;                         //微信商城订单长度
    FQCReportFR3Map:TStrings;                        //品种与打印模板映射
    FShuLiaoNeedBatchCode:Boolean;                   //熟料是否需要出厂编号
    FReadInsertCard:Boolean;                         //插入磁卡查询
    FEnablePurchaseMultipleCard:Boolean;             //采购允许办理多卡
    FTTCEK720ID : string;                            //指定发卡机
  end;
  //系统参数

  TModuleItemType = (mtFrame, mtForm);
  //模块类型

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //菜单名称
    FModule: integer;                                //模块标识
    FItemType: TModuleItemType;                      //模块类型
  end;

  PMallOrderItem = ^stMallOrderItem;
  stMallOrderItem = record
    FCusID:string;
    FCusName:string;  
    FOrder_id:string;
    FOrdernumber:string;
    FGoodsID:string;
    FGoodstype:string;
    FGoodsname:string;
    FData:string;
    Ftracknumber:string;
    FYunTianOrderId:string;//云天系统订单号
  end;
  //网上商城订单明细

  PMallPurchaseItem = ^stMallPurchaseItem;
  stMallPurchaseItem = record
    FOrder_id:string; //商城ID
    FProvID:string; //供应商ID
    FProvName:string; //供应商名称
    FGoodsID:string;  //物料编号
    FGoodsname:string; //物料名称
    FData:string; //数量
    Ftracknumber:string; //车牌号
    Fpurchasecontract_no:string;//合同编号
  end;
  //网上商城供货单明细

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gMenuModule: TList = nil;                          //菜单模块映射表
  gCard: string;
//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sImageDir           = 'Images\';                   //图片目录
  sReportDir          = 'Report\';                   //报表目录
  sBackupDir          = 'Backup\';                   //备份目录
  sBackupFile         = 'Bacup.idx';                 //备份索引
  sCameraDir          = 'Camera\';                   //抓拍目录

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节
  sDBConfig           = 'DBConn.ini';                //数据连接
  sDBConfig_bk        = 'isbk';                      //备份库

  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件 

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

implementation

//------------------------------------------------------------------------------
//Desc: 添加菜单模块映射项
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: 菜单模块映射表
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('MAIN_A01', cFI_FormIncInfo, mtForm);
  AddMenuModuleItem('MAIN_A02', cFI_FrameSysLog);
  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  AddMenuModuleItem('MAIN_A04', cFI_FormRestore, mtForm);
  AddMenuModuleItem('MAIN_A05', cFI_FormChangePwd, mtForm);
  AddMenuModuleItem('MAIN_A07', cFI_FrameAuthorize);
  AddMenuModuleItem('MAIN_A08', cFI_FrameSPrice);

  AddMenuModuleItem('MAIN_B01', cFI_FormBaseInfo, mtForm);
  AddMenuModuleItem('MAIN_B02', cFI_FrameCustomer);
  AddMenuModuleItem('MAIN_B03', cFI_FrameSalesMan);
  AddMenuModuleItem('MAIN_B04', cFI_FrameSaleContract);

  AddMenuModuleItem('MAIN_C01', cFI_FrameZhiKaVerify);
  AddMenuModuleItem('MAIN_C02', cFI_FramePayment);
  AddMenuModuleItem('MAIN_C03', cFI_FrameCusCredit);
  AddMenuModuleItem('MAIN_C04', cFI_FrameSaleInvoice);
  AddMenuModuleItem('MAIN_C05', cFI_FrameMakeInvoice);
  AddMenuModuleItem('MAIN_C06', cFI_FrameInvoiceWeek);
  AddMenuModuleItem('MAIN_C07', cFI_FrameShouJu);
  AddMenuModuleItem('MAIN_C08', cFI_FrameSaleZZ);

  AddMenuModuleItem('MAIN_D01', cFI_FormZhiKa, mtForm);
  AddMenuModuleItem('MAIN_D02', cFI_FrameMakeCard);
  AddMenuModuleItem('MAIN_D03', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D04', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D05', cFI_FrameZhiKa);
  AddMenuModuleItem('MAIN_D06', cFI_FrameBill);
  AddMenuModuleItem('MAIN_D07', cFI_FrameTrucks);
  AddMenuModuleItem('MAIN_D08', cFI_FrameYTBatchcode);

  AddMenuModuleItem('MAIN_E01', cFI_FramePoundManual);
  AddMenuModuleItem('MAIN_E02', cFI_FramePoundAuto);
  AddMenuModuleItem('MAIN_E03', cFI_FramePoundQuery);

  AddMenuModuleItem('MAIN_F01', cFI_FormLadDai, mtForm);
  AddMenuModuleItem('MAIN_F02', cFI_FormTruckEmpty, mtForm);
  AddMenuModuleItem('MAIN_F03', cFI_FrameZhanTaiQuery);
  AddMenuModuleItem('MAIN_F04', cFI_FrameZTDispatch);
  AddMenuModuleItem('MAIN_F05', cFI_FormPurchase, mtForm);
  AddMenuModuleItem('MAIN_F06', cFI_FrameZTLines);

  AddMenuModuleItem('MAIN_G01', cFI_FormLadSan, mtForm);
  AddMenuModuleItem('MAIN_G02', cFI_FrameFangHuiQuery);

  AddMenuModuleItem('MAIN_K01', cFI_FrameStock);
  AddMenuModuleItem('MAIN_K02', cFI_FrameStockRecord);
  AddMenuModuleItem('MAIN_K03', cFI_FrameStockHuaYan);
  AddMenuModuleItem('MAIN_K04', cFI_FormStockHuaYan, mtForm);
  AddMenuModuleItem('MAIN_K05', cFI_FormStockHY_Each, mtForm);
  AddMenuModuleItem('MAIN_K06', cFI_FrameStockHY_Each);

  AddMenuModuleItem('MAIN_L01', cFI_FrameTruckQuery);
  AddMenuModuleItem('MAIN_L02', cFI_FrameCusAccountQuery);
  AddMenuModuleItem('MAIN_L03', cFI_FrameCusInOutMoney);
  AddMenuModuleItem('MAIN_L05', cFI_FrameDispatchQuery);
  AddMenuModuleItem('MAIN_L06', cFI_FrameSaleDetailQuery);
  AddMenuModuleItem('MAIN_L07', cFI_FrameSaleTotalQuery);
  AddMenuModuleItem('MAIN_L08', cFI_FrameZhiKaDetail);
  AddMenuModuleItem('MAIN_L09', cFI_FrameOrderDetailQuery);
  AddMenuModuleItem('MAIN_L11', cFI_FrameTransferDetailQuery);

  AddMenuModuleItem('MAIN_L12', cFI_FrameQueryWXSynInfo);

  AddMenuModuleItem('MAIN_H01', cFI_FormTruckIn, mtForm);
  AddMenuModuleItem('MAIN_H02', cFI_FormTruckOut, mtForm);
  AddMenuModuleItem('MAIN_H03', cFI_FrameTruckQuery);

  AddMenuModuleItem('MAIN_M01', cFI_FrameProvider);
  AddMenuModuleItem('MAIN_M02', cFI_FrameMaterails);
  AddMenuModuleItem('MAIN_M03', cFI_FrameMakeOCard); 
  AddMenuModuleItem('MAIN_M04', cFI_FrameOrder);
  AddMenuModuleItem('MAIN_M05', cFI_FormTransBase, mtForm);
  AddMenuModuleItem('MAIN_M06', cFI_FrameTransBase);
  AddMenuModuleItem('MAIN_M08', cFI_FrameOrderDetail);
  AddMenuModuleItem('MAIN_M09', cFI_FrameOrderBase);

  AddMenuModuleItem('MAIN_W01', cFI_FrameWXAccount);
  AddMenuModuleItem('MAIN_W02', cFI_FrameWXSendLog);
  AddMenuModuleItem('MAIN_W03', cFI_FrameWXBind);  
end;

//Desc: 清理模块列表
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  InitMenuModuleList;
finalization
  ClearMenuModuleList;
end.


