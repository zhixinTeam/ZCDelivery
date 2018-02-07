{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引
  cRecMenuMax           = 5;                         //最近使用导航区最大条目数
  cItemIconIndex        = 11;                        //默认的提货单列表图标

const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //系统日志
  cFI_FrameViewLog      = $0002;                     //本地日志
  cFI_FrameAuthorize    = $0003;                     //系统授权

  cFI_FrameCustomer     = $0010;                     //客户管理
  cFI_FrameSalesMan     = $0011;                     //业务员
  cFI_FrameMakeCard     = $0012;                     //办理磁卡
  cFI_FrameBill         = $0013;                     //开提货单
  cFI_FrameBillPost     = $0015;                     //手动过账

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
  cFI_FrameBatch        = $0047;                     //批次管理
  cFI_FrameBatchRecord  = $0048;                     //批次回单

  cFI_FrameTruckQuery   = $0050;                     //车辆查询
  cFI_FrameDispatchQuery = $0051;                    //调度查询
  cFI_FrameSaleTotalQuery  = $0052;                  //累计发货
  cFI_FrameSaleDetailQuery = $0053;                  //发货明细
  cFI_FrameOrderDetailQuery = $0057;                 //采购明细

  cFI_FrameProvider     = $0061;                     //供应
  cFI_FrameMaterails    = $0062;                     //原材料
  cFI_FrameMakeOCard    = $0064;                     //办理采购磁卡
  cFI_FrameOrder        = $0107;                     //采购订单
  cFI_FrameOrderDetail  = $0109;                     //采购明细
  cFI_FrameQPoundTemp   = $1112;                      //临时称重
  CFI_FormMakeCardOther = $1113;                     //临时称重业务
  cFI_FormGetPOrderBase = $1156;                     //采购订单
  cFI_FormPurchase      = $1155;                     //采购验收  

  cFI_FrameTrucks       = $0070;                     //车辆档案
  cFI_FrameUnloading    = $0071;                     //卸货地点
  cFI_FrameTodo         = $0072;                     //待处理事件
  cFI_FrameWXAccount    = $0073;                     //微信账户
  cFI_FrameWXSendLog    = $0074;                     //发送日志

  cFI_FormMemo          = $1000;                     //备注窗口
  cFI_FormBackup        = $1001;                     //数据备份
  cFI_FormRestore       = $1002;                     //数据恢复
  cFI_FormIncInfo       = $1003;                     //公司信息
  cFI_FormChangePwd     = $1005;                     //修改密码
  cFI_FormOptions       = $1006;                     //参数选项

  cFI_FormBaseInfo      = $1017;                     //基本信息
  cFI_FormCustomer      = $1018;                     //客户资料
  cFI_FormSaleMan       = $1009;                     //业务员
  cFI_FormBill          = $1020;                     //开提货单
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
  cFI_FormBuDan         = $1032;                     //销售补单

  cFI_FormMakeCard      = $1040;                     //办理磁卡
  cFI_FormMakeRFIDCard  = $1041;                     //办理电子标签
  cFI_FormMakeLSCard    = $1042;                     //厂内零售办卡
  cFI_FormSaleAdjust    = $1043;                     //销售调剂
  cFI_FormTruckEmpty    = $1044;                     //空车出厂
  cFI_FormReadCard      = $1045;                     //读取磁卡
  cFI_FormZTLine        = $1046;                     //装车线

  cFI_FormGetZhika      = $1050;                     //选择纸卡
  cFI_FormGetTruck      = $1051;                     //选择车辆
  cFI_FormGetContract   = $1052;                     //选择合同
  cFI_FormGetCustom     = $1053;                     //选择客户
  cFI_FormGetStockNo    = $1054;                     //选择编号
  cFI_FormGetUnloading  = $1055;                     //卸货地点
  cFI_FormProvider      = $1056;                     //供应商
  cFI_FormMaterails     = $1057;                     //原材料
  cFI_FormGetWXAccount  = $1058;                     //获取商城注册信息

  cFI_FormBatch         = $1060;                     //批次管理
  cFI_FormStockParam    = $1061;                     //品种管理
  cFI_FormStockHuaYan   = $1062;                     //开化验单
  cFI_FormStockHY_Each  = $1062;                     //随车开单

  cFI_FormTrucks        = $1070;                     //车辆档案
  cFI_FormAuthorize     = $1071;                     //安全验证
  cFI_FormWXAccount     = $1072;                     //微信账户
  cFI_FormWXSendlog     = $1073;                     //微信日志
  cFI_FormTodo          = $1074;                     //需干预事件
  cFI_FormTodoSend      = $1075;                     //推送事件

  cFI_FormOrder         = $1083;                     //采购订单

  {*Command*}
  cCmd_RefreshData      = $0002;                     //刷新数据
  cCmd_ViewSysLog       = $0003;                     //系统日志

  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_ViewData         = $1006;                     //查看数据
  cCmd_GetData          = $1007;                     //选择数据

  cSendWeChatMsgType_AddBill=1; //开提货单
  cSendWeChatMsgType_OutFactory=2; //车辆出厂
  cSendWeChatMsgType_Report=3; //报表
  cSendWeChatMsgType_DelBill=4; //删提货单

  c_WeChatStatusCreateCard=0;  //订单已办卡
  c_WeChatStatusFinished=1;  //订单已完成
  c_WeChatStatusDeleted=2;  //订单已删除

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

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
    FMITServURL : string;                            //业务服务
    FHardMonURL : string;                            //硬件守护
    FWechatURL  : string;                            //微信服务

    FFactNum    : string;                            //工厂编号
    FSerialID   : string;                            //电脑编号
    FDepartment : string;                            //所属部门
    FIsManual   : Boolean;                           //手动过磅
    FAutoPound  : Boolean;                           //自动称重

    FPoundDaiZ  : Double;
    FPoundDaiZ_1: Double;                            //袋装正误差
    FPoundDaiF  : Double;
    FPoundDaiF_1: Double;                            //袋装负误差
    FDaiPercent : Boolean;                           //按比例计算偏差
    FDaiWCStop  : Boolean;                           //不允许袋装偏差
    FPoundSanF  : Double;                            //散装负误差
    FTruckPWuCha: Double;                            //空车皮误差
    FPicBase    : Integer;                           //图片索引
    FPicPath    : string;                            //图片目录
    FVoiceUser  : Integer;                           //语音计数
    FProberUser : Integer;                           //检测器技术

    FPrinterBill: string;                            //小票打印机
    FPrinterHYDan : string;                          //化验单打印机 
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

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gMenuModule: TList = nil;                          //菜单模块映射表

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
  AddMenuModuleItem('MAIN_A06', cFI_FormOptions, mtForm);
  AddMenuModuleItem('MAIN_A07', cFI_FrameAuthorize);
  AddMenuModuleItem('MAIN_A08', cFI_FormTodo, mtForm);
  AddMenuModuleItem('MAIN_A09', cFI_FrameTodo);

  AddMenuModuleItem('MAIN_B01', cFI_FormBaseInfo, mtForm);
  AddMenuModuleItem('MAIN_B02', cFI_FrameCustomer);
  AddMenuModuleItem('MAIN_B03', cFI_FrameSalesMan);
  AddMenuModuleItem('MAIN_B04', cFI_FrameTrucks);
  AddMenuModuleItem('MAIN_B05', cFI_FrameUnloading);

  AddMenuModuleItem('MAIN_D02', cFI_FrameMakeCard);
  AddMenuModuleItem('MAIN_D03', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D04', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D06', cFI_FrameBill);
  AddMenuModuleItem('MAIN_D08', cFI_FormTruckEmpty, mtForm);
  AddMenuModuleItem('MAIN_D10', cFI_FrameBillPost);

  AddMenuModuleItem('MAIN_E01', cFI_FramePoundManual);
  AddMenuModuleItem('MAIN_E02', cFI_FramePoundAuto);
  AddMenuModuleItem('MAIN_E03', cFI_FramePoundQuery);

  AddMenuModuleItem('MAIN_F01', cFI_FormLadDai, mtForm);
  AddMenuModuleItem('MAIN_F03', cFI_FrameZhanTaiQuery);
  AddMenuModuleItem('MAIN_F04', cFI_FrameZTDispatch);

  AddMenuModuleItem('MAIN_G01', cFI_FormLadSan, mtForm);
  AddMenuModuleItem('MAIN_G02', cFI_FrameFangHuiQuery);

  AddMenuModuleItem('MAIN_K01', cFI_FrameStock);
  AddMenuModuleItem('MAIN_K02', cFI_FrameStockRecord);
  AddMenuModuleItem('MAIN_K03', cFI_FrameStockHuaYan);
  AddMenuModuleItem('MAIN_K04', cFI_FormStockHuaYan, mtForm);
  AddMenuModuleItem('MAIN_K05', cFI_FormStockHY_Each, mtForm);
  AddMenuModuleItem('MAIN_K06', cFI_FrameBatchRecord);
  AddMenuModuleItem('MAIN_K07', cFI_FrameBatch);
  AddMenuModuleItem('MAIN_K08', cFI_FormBatch, mtForm);

  AddMenuModuleItem('MAIN_L01', cFI_FrameTruckQuery);
  AddMenuModuleItem('MAIN_L05', cFI_FrameDispatchQuery);
  AddMenuModuleItem('MAIN_L06', cFI_FrameSaleDetailQuery);
  AddMenuModuleItem('MAIN_L07', cFI_FrameSaleTotalQuery);
  AddMenuModuleItem('MAIN_L10', cFI_FrameOrderDetailQuery);

  AddMenuModuleItem('MAIN_H01', cFI_FormTruckIn, mtForm);
  AddMenuModuleItem('MAIN_H02', cFI_FormTruckOut, mtForm);
  AddMenuModuleItem('MAIN_H03', cFI_FrameTruckQuery);

  AddMenuModuleItem('MAIN_J01', cFI_FrameTrucks);

  AddMenuModuleItem('MAIN_M01', cFI_FrameProvider);
  AddMenuModuleItem('MAIN_M02', cFI_FrameMaterails);
  AddMenuModuleItem('MAIN_M03', cFI_FrameMakeOCard); 
  AddMenuModuleItem('MAIN_M04', cFI_FrameOrder);
  AddMenuModuleItem('MAIN_M08', cFI_FrameOrderDetail);
  AddMenuModuleItem('MAIN_M13', cFI_FrameQPoundTemp);  
  AddMenuModuleItem('MAIN_F05', cFI_FormPurchase,mtForm);

  AddMenuModuleItem('MAIN_W01', cFI_FrameWXAccount);
  AddMenuModuleItem('MAIN_W02', cFI_FrameWXSendLog);
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


