{*******************************************************************************
  作者: dmzn@163.com 2012-2-24
  描述: 运行时日志
*******************************************************************************}
unit UFrameRunLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameBase, ExtCtrls, StdCtrls;

type
  TfFrameRunLog = class(TfFrameBase)
    Panel1: TPanel;
    MemoLog: TMemo;
    Bevel1: TBevel;
    Check1: TCheckBox;
    BtnClear: TButton;
    BtnCopy: TButton;
    procedure BtnCopyClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure Check1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ShowLog(const nStr: string);
  public
    { Public declarations }
    class function FrameID: integer; override;
    procedure OnDestroyFrame; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysLoger, UMITConst;

class function TfFrameRunLog.FrameID: integer;
begin
  Result := cFI_FrameRunlog;
end;

procedure TfFrameRunLog.OnDestroyFrame;
begin
  gSysLoger.LogSync := False;
  gSysLoger.LogEvent := nil;
  inherited;
end;

procedure TfFrameRunLog.BtnCopyClick(Sender: TObject);
begin
  MemoLog.CopyToClipboard;
  ShowMsg('已复制到粘贴板', sHint);
end;

procedure TfFrameRunLog.BtnClearClick(Sender: TObject);
begin
  MemoLog.Lines.BeginUpdate;
  MemoLog.Clear;
  MemoLog.Lines.EndUpdate;
end;

procedure TfFrameRunLog.Check1Click(Sender: TObject);
begin
  gSysLoger.LogEvent := ShowLog;
  gSysLoger.LogSync := Check1.Checked;
end;

procedure TfFrameRunLog.ShowLog(const nStr: string);
var nIdx: Integer;
begin
  MemoLog.Lines.BeginUpdate;
  try
    MemoLog.Lines.Insert(0, nStr);
    if MemoLog.Lines.Count > 100 then
     for nIdx:=MemoLog.Lines.Count - 1 downto 50 do
      MemoLog.Lines.Delete(nIdx);
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameRunLog, TfFrameRunLog.FrameID);
end.
