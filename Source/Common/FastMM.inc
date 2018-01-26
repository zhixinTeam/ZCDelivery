{*******************************************************************************
  作者: dmzn@163.com 2013-11-30
  描述: 本单元用于设置内存管理器选项.

  备注:
  *.内存管理器FastMM4必须是.dpr项目的第一个uses才会生效.
  *.FastMM4加载完默认的FastMM4Options.inc后,使用本单元做参数调整,以适应程序要求.
  *.每组参数有"define"启用和"undef"禁用两种选择.
  *.带有"//+"表示默认已启用,"//-"表示默认已关闭.
*******************************************************************************}

{-----------------------------Debugging Options-------------------------------}
//-
{$define NoMessageBoxes}
{.$undef NoMessageBoxes}

//-
{$define FullDebugMode}
{.$undef FullDebugMode}

  //+
  {.$define RawStackTraces}
  {.$undef RawStackTraces}

  //-
  {.$define CatchUseOfFreedInterfaces}
  {.$undef CatchUseOfFreedInterfaces}

  //+
  {.$define LogErrorsToFile}
  {.$undef LogErrorsToFile}

  //+
  {.$define LogMemoryLeakDetailToFile}
  {$undef LogMemoryLeakDetailToFile}

  //-
  {$define ClearLogFileOnStartup}
  {.$undef ClearLogFileOnStartup}

  //-
  {.$define LoadDebugDLLDynamically}
  {.$undef LoadDebugDLLDynamically}

    //-
    {.$define DoNotInstallIfDLLMissing}
    {.$undef DoNotInstallIfDLLMissing}

  //+
  {.$define AlwaysAllocateTopDown}
  {.$undef AlwaysAllocateTopDown}

  //-
  {.$define DisableLoggingOfMemoryDumps}
  {.$undef DisableLoggingOfMemoryDumps}

  //+
  {.$define SuppressFreeMemErrorsInsideException}
  {.$undef SuppressFreeMemErrorsInsideException}

  //-
  {.$define FullDebugModeCallBacks}
  {.$undef FullDebugModeCallBacks}

{---------------------------Memory Leak Reporting-----------------------------}
//+
{.$define EnableMemoryLeakReporting}
{.$undef EnableMemoryLeakReporting}

  //+
  {.$define HideExpectedLeaksRegisteredByPointer}
  {.$undef HideExpectedLeaksRegisteredByPointer}

  //-
  {.$define RequireIDEPresenceForLeakReporting}
  {.$undef RequireIDEPresenceForLeakReporting}

  //+
  {.$define RequireDebuggerPresenceForLeakReporting}
  {$undef RequireDebuggerPresenceForLeakReporting}

  //-
  {.$define RequireDebugInfoForLeakReporting}
  {.$undef RequireDebugInfoForLeakReporting}

  //-
  {.$define ManualLeakReportingControl}
  {.$undef ManualLeakReportingControl}

  //-
  {$define HideMemoryLeakHintMessage}
  {.$undef HideMemoryLeakHintMessage}

{-----------------------Memory Manager Sharing Options------------------------}
//-
{$define ShareMM}
{.$undef ShareMM}

  //-
  {$define ShareMMIfLibrary}
  {.$undef ShareMMIfLibrary}

//-
{$define AttemptToUseSharedMM}
{.$undef AttemptToUseSharedMM}

//+
{.$define EnableBackwardCompatibleMMSharing}
{.$undef EnableBackwardCompatibleMMSharing}
