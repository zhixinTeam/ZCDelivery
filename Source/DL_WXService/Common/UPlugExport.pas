{*******************************************************************************
  作者: dmzn@163.com 2013-11-22
  描述: 模块输出函数
*******************************************************************************}
unit UPlugExport;

interface

uses
  Windows, Classes, UMgrPlug, UMgrControl, UBusinessPacker, UBusinessWorker,
  UPlugModule, UEventWorker, USysLoger;

procedure BackupEnvironment(const nNewEnv: PPlugEnvironment); stdcall;
procedure LoadModuleWorker(var nWorker: TPlugEventWorkerClass); stdcall;
procedure LibraryEntity(const nReason: Integer);
//入口函数

implementation

var
  gIsBackup: Boolean = False;
  gPlugEnv: TPlugEnvironment;
  //模块环境

//Date: 2013-11-23
//Parm: 环境参数
//Desc: 备份当前参数,使用nNewEnv参数
procedure BackupEnvironment(const nNewEnv: PPlugEnvironment); stdcall;
begin
  if not gIsBackup then
  begin
    gPlugEnv.FExtendObjects := TStringList.Create;
    //env extend

    TPlugManager.EnvAction(@gPlugEnv, True);
    TPlugManager.EnvAction(nNewEnv, False);
    gIsBackup := True;

    gPlugEnv.FCtrlManager.MoveTo(gControlManager);
    gPlugEnv.FPackerManager.MoveTo(gBusinessPackerManager);
    gPlugEnv.FWorkerManager.MoveTo(gBusinessWorkerManager);
    //移交数据
  end;
end;

//Desc: 恢复环境参数
procedure RestoreEnvironment;
begin
  if gIsBackup then
  begin
    TPlugManager.EnvAction(@gPlugEnv, False);
    //restore all param
    gPlugEnv.FExtendObjects.Free;
    //release extend
  end;
end;

procedure LoadModuleWorker(var nWorker: TPlugEventWorkerClass); stdcall;
begin
  nWorker := TPlugWorker;
end;

procedure LibraryEntity(const nReason: Integer);
begin
  case nReason of
   DLL_PROCESS_DETACH : RestoreEnvironment;
   DLL_THREAD_ATTACH : IsMultiThread := True;
  end;
end;

end.
