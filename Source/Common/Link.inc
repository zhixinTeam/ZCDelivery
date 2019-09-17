//----------------------------------- 通用 -------------------------------------
{.$DEFINE DEBUG}
//调试模式

{.$DEFINE TrialVersion}
//试用版本

{$DEFINE UseReport}
//报表支持

{.$DEFINE RandomID}
//使用随机编号

{$DEFINE cxLibrary42}
//Ver4.2编译环境

{.$DEFINE EnableBackupDB}
//备用数据库支持
{.$DEFINE EnableDoubleDB}
//双数据库支持

//---------------------------------- 中间件 ------------------------------------
{.$DEFINE ClientMon}
//进程守护客户端

{$DEFINE HardMon}
//编译硬件守护

{.$DEFINE GenRODL}
//生成RODL资源

{$DEFINE COM_MIT}
//定义系统模式

//通用中间件
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //启用数据库支持
  {.$DEFINE BusLog}
  //打印业务日志
  {$DEFINE ChannelPool}
  //启用通道支持
  {.$DEFINE AutoChannel}
  //启用通道平衡
  {.$DEFINE SAP}
  //启用SAP支持
  {.$DEFINE ClientMon}
  //支持守护服务
{$ENDIF}

//--------------------------------- 特定系统 -----------------------------------
{.$DEFINE COMMON}
//通用版本

{$DEFINE GXBL}
//特定系统

//安徽中材
{$IFDEF AHZC}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE AppAtTaskBar}
  //状态栏显示
  {.$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE TruckProberEx}
  //车检判断Ex
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {.$DEFINE DaiOpenBackWhenError}
  //包装错误抬后杆
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE PrintHYEach}
  //随车开化验单
  {$DEFINE HeGeZhengOnly}
  //随车开单时只打合格证
  {$DEFINE HeGeZhengSimpleData}
  //使用简单合格证数据(无检验结果)
  {$DEFINE JSTruck}
  //格式化计数器车牌
  {$DEFINE SyncRemote}
  //远程同步
  {$DEFINE MicroMsg}
  //微信
  {$DEFINE GetTruckNoFromERP}
  //从ERP委托单获取车号
  {$DEFINE SyncDataByDataBase}
  //通过访问数据库进行数据交互
  {$DEFINE TruckOutTimeOut}
  //车辆出厂超时
{$ENDIF}

//株洲中材
{$IFDEF ZZZC}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE AppAtTaskBar}
  //状态栏显示
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {.$DEFINE TruckProberEx}
  //车检判断Ex
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {.$DEFINE DaiOpenBackWhenError}
  //包装错误抬后杆
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {.$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE HeGeZhengOnly}
  //随车开单时只打合格证
  {.$DEFINE HeGeZhengSimpleData}
  //使用简单合格证数据(无检验结果)
  {$DEFINE JSTruck}
  //格式化计数器车牌
  {$DEFINE SyncRemote}
  //远程同步
  {$DEFINE MicroMsg}
  //微信
  {$DEFINE GetTruckNoFromERP}
  //从ERP委托单获取车号
  {$DEFINE SyncDataByWSDL}
  //通过接口进行数据交互
  {$DEFINE AutoTruckIn}
  //车辆自动进厂
  {$DEFINE SaleOpenBackWhenError}
  //销售异常过磅抬后杆
  {$DEFINE OrderControl}
  //原材料进厂控制
  {$DEFINE LadeControl}
  //销售开单量控制
  {$DEFINE WaitLoadEx}
  //袋装车辆查询EX
  {$DEFINE RemoteSnap}
  //车牌识别
{$ENDIF}

//广西北流
{$IFDEF GXBL}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE AppAtTaskBar}
  //状态栏显示
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {.$DEFINE TruckProberEx}
  //车检判断Ex
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {.$DEFINE DaiOpenBackWhenError}
  //包装错误抬后杆
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE PrintHYEach}
  //随车开化验单
  {$DEFINE HeGeZhengOnly}
  //随车开单时只打合格证
  {$DEFINE HeGeZhengSimpleData}
  //使用简单合格证数据(无检验结果)
  {$DEFINE JSTruck}
  //格式化计数器车牌
  {$DEFINE SyncRemote}
  //远程同步
  {$DEFINE MicroMsg}
  //微信
  {$DEFINE UseWXERP}
   //使用问信ERP接口
  {$DEFINE UseEnableStruck}
   //启用车牌识别
  {$DEFINE UseLBCModbus}
  //启用链板秤装车
  {$DEFINE FixLoad}
  //转子秤定制装车
 {$DEFINE MoreNumZDLine}
  //数量达一定值指定通道
 {$DEFINE NoUsePlayVoice}
  //屏蔽一些语音播报
 {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
 {$DEFINE UseFliterRefresh}
  //使用筛选刷新功能  
 {$DEFINE Between2BillTime}
//使用出厂一段时间内不能办卡功能
{$ENDIF}


