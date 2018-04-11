unit UMgrKCDF360;

interface

const
  cKCDF720_DLL = 'K720_Dll.dll';

  function K720_GetSysVersion(nHandle: Cardinal; nVersion:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_GetSysVersion';

//  功能:	打开串口，默认的波特率"9600, n, 8, 1"
//  参数:	[in]*nPort			要打开的串口，例如打开com1，则nPort 存储"COM1"
//  返回值:	正确返回串口的句柄；错误=0
  function K720_CommOpen(nPort:string):Cardinal; stdcall;
    External cKCDF720_DLL name'K720_CommOpen';

//  功能：	关闭当前打开的串口
//  参数：	[in]nHandle		要关闭的串口的句柄
//  返回值：	正确=0，错误=非0
  function K720_CommClose(nHandle: Cardinal):Integer; stdcall;
    External cKCDF720_DLL name'K720_CommClose';

//  功能：	获取K720机器的版本信息，对应协议中"GV"这条命令
//  参数[in]nHandle		已经打开的串口的句柄
//      [in]nAddr		机器的地址，有效取值（0到15）
//      [out]nVersion		存机器的版本信息，读取成功会存储版本信息，
//  如 "TTCE_K720_V2.**"
//  返回值：	正确=0，错误=非0
  function K720_GetVersion(nHandle: Cardinal; nAddr: Integer; nVersion:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_GetVersion';

//  功能：	高级查询，D1801状态信息，返回4字节的状态信息，对应协议中"AP"这条指令
//  参数[in]nHandle		已经打开的串口的句柄
//      [in]nAddr		机器的地址，有效取值（0到15）
//      [out]nStatus		存储D1801状态信息，返回4个字节，详情请参K720照通讯协议
//      [out]nRecord	存储该条命令的通讯记录
//
//  返回值：	正确=0，错误=非0
  function K720_SensorQuery(nHandle: Cardinal; nAddr: Integer;
    nStatus: PAnsiChar; nRecord:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_SensorQuery';

//  功能：	发送D1801的操作命令
//  参数[in]nHandle		已经打开的串口的句柄
//      [in]nAddr		机器的地址，有效取值（0到15）
//      [in]nCmd		存储命令字符串
//      [in]nCmdLen		命令字符串口的长度
//      [out]nRecord	存储该条命令的通讯记录
//
//  返回值：	正确=0，错误=非0
//  （注：	此函数可以执行命令如下：
//    K720_SendCmd(ComHandle, MacAddr, "DC", 2)	发卡（到取卡位置）
//    K720_SendCmd(ComHandle, MacAddr, "CP", 2)	收卡
//    K720_SendCmd(ComHandle, MacAddr, "RS", 2)	复位
//    K720_SendCmd(ComHandle, MacAddr, "BE", 2)	允许蜂鸣（卡少，卡空，出错蜂鸣器会报警）
//    K720_SendCmd(ComHandle, MacAddr, "BD", 2)	停止蜂鸣器工作
//    K720_SendCmd(ComHandle, MacAddr, "CS0", 3)	设置机器通讯为波特率1200bps
//    K720_SendCmd(ComHandle, MacAddr, "CS1", 3)	设置机器通讯为波特率2400bps
//    K720_SendCmd(ComHandle, MacAddr, "CS2", 3)	设置机器通讯为波特率4800bps
//    K720_SendCmd(ComHandle, MacAddr, "CS3", 3)	设置机器通讯为波特率9600bps
//    K720_SendCmd(ComHandle, MacAddr, "CS4", 3)	设置机器通讯为波特率19200bps
//    K720_SendCmd(ComHandle, MacAddr, "CS5", 3)	设置机器通讯为波特率38400bps
//    K720_SendCmd(ComHandle, MacAddr, "FC6", 3)	发卡到传感器2
//    K720_SendCmd(ComHandle, MacAddr, "FC7", 3)	发卡到读卡位置
//    K720_SendCmd(ComHandle, MacAddr, "FC8", 3)	前端进卡
//    K720_SendCmd(ComHandle, MacAddr, "FC0", 3)	发卡到取卡位置
//    K720_SendCmd(ComHandle, MacAddr, "FC4", 3)	发卡到卡口外
//    K720_SendCmd(ComHandle, MacAddr, "LPX",3)	设置闪灯频率,其中X=1-14表示1秒闪烁X次
//                        X=15-28,表示(X-13)秒闪烁1次
//    建议使用标准的9600的波特率通讯，否则速率太低，可能影响命令发送和接受
  function K720_SendCmd(nHandle: Cardinal; nAddr: Integer;
    nCmd: string; nCmdLen: Integer; nRecord:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_SendCmd';

//  功能：	S70 卡寻卡
//  参数[in]nHandle	 已经打开的串口的句
//      [in]nAddr		机器的地址，有效取值（0到15）
//      [out]nRecrod	存储该条命令的通讯记录
//  返回值： 正确=0，错误=非 0

  function K720_S70DetectCard(nHandle: Cardinal; nAddr: Integer; nRecrod:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_S70DetectCard';

//  功能：	S70 卡读取 ID 号
//  参数：[in]nHandle			已经打开的串口的句柄
//        [in]nAddr           机器地址，有限取值(0-15)
//        [out]nCardID			存储读取的 卡片 ID 号
//        [out]nRecord		存储该条命令的通讯记录
//  返回值： 正确=0，错误=非 0

  function K720_S70GetCardID(nHandle: Cardinal; nAddr: Integer;
    nCardID: PAnsiChar; nRecord:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_S70GetCardID';

//  功能：	S50 卡寻卡
//  参数[in]nHandle	 已经打开的串口的句
//      [in]nAddr		机器的地址，有效取值（0到15）
//      [out]nRecrod	存储该条命令的通讯记录
//  返回值： 正确=0，错误=非 0

  function K720_S50DetectCard(nHandle: Cardinal; nAddr: Integer; nRecrod:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_S50DetectCard';

//  功能S50 读取序列号
//  参数[in]ComHandle                 已经打开的串口的句柄
//      [in]MacAddr           机器地址，有限取值(0-15)
//      [out]_CardID		存储卡片序号 [out]RecrodInfo	 存储该条命令的通讯记录
//  返回值： 正确=0，错误=非 0

  function K720_S50GetCardID(nHandle: Cardinal; nAddr: Integer;
    nCardID: PAnsiChar; nRecord:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_S50GetCardID';

//  功能：	获取发卡以及回收卡计数
//  参数[in]nHandle		已经打开的串口的句柄
//      [in]nAddr		机器的地址，有效取值（0到15）
//      [out]nData		存储计数数据，前十个字节记录发卡数量最后一个字节记录回收卡数量
//      [out]nRecord	存储该条命令的通讯记录
//
//  返回值：	正确=0，错误=非0

  function K720_GetCountSum(nHandle: Cardinal; nAddr: Integer;
    nData: PAnsiChar; nRecord:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_GetCountSum';

//  功能：	清除发卡计数
//  参数[in]nHandle		已经打开的串口的句柄
//      [in]nAddr		机器的地址，有效取值（0到15）
//      [out]nRecord	存储该条命令的通讯记录
//
//  返回值：	正确=0，错误=非0

  function K720_ClearSendCount(nHandle: Cardinal; nAddr: Integer;
    nRecord:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_ClearSendCount';

//  功能：	清除回收卡计数
//  参数[in]nHandle		已经打开的串口的句柄
//      [in]nAddr		机器的地址，有效取值（0到15）
//      [out]nRecord	存储该条命令的通讯记录
//
//  返回值：	正确=0，错误=非0
  function K720_ClearRecycleCount(nHandle: Cardinal; nAddr: Integer;
    nRecord:PAnsiChar):Integer; stdcall;
    External cKCDF720_DLL name'K720_ClearRecycleCount';

implementation

end.
