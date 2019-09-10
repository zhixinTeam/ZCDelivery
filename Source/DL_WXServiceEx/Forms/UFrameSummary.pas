{*******************************************************************************
  作者: dmzn@163.com 2013-11-27
  描述: 运行摘要
*******************************************************************************}
unit UFrameSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFrameBase, ExtCtrls, Grids, ValEdit, UZnValueList;

{$I Link.Inc}
type
  TfFrameSummary = class(TfFrameBase)
    ListSummary: TZnValueList;
    TimerMon: TTimer;
    procedure TimerMonTimer(Sender: TObject);
  private
    { Private declarations }
    FSummaryChanged: Boolean;
    procedure NewSummaryItem(const nKey,nFlag: string;
     nImage: Integer = cIcon_Key);
    procedure UpdateItem(const nFlag,nValue: string;
     nImage: Integer = cIcon_Value);
    procedure UpdateSummary(const nNewItem: Boolean);
    //更新摘要
    procedure LoadConfig(const nLoad: Boolean);
    //界面配置
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, IniFiles, UMgrControl, UMgrDBConn, USAPConnection, UMgrParam,
  UROModule, USmallFunc, USysLoger, UMITConst;

//Desc: 记录日志
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFrameSummary, '运行时摘要', nEvent);
end;

class function TfFrameSummary.FrameID: integer;
begin
  Result := cFI_FrameSummary;
end;

procedure TfFrameSummary.OnCreateFrame;
begin
  inherited;
  Name := MakeFrameName(FrameID);
  ListSummary.DoubleBuffered := True;

  LoadConfig(True);
  UpdateSummary(True);
end;

//Desc: 刷新服务状态
procedure TfFrameSummary.OnDestroyFrame;
begin
  inherited;
  LoadConfig(False);
end;

procedure TfFrameSummary.LoadConfig(const nLoad: Boolean);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    if nLoad then
    begin
      ListSummary.ColWidths[0] := nIni.ReadInteger(Name, 'ListCol0', 100);
    end else
    begin
      nIni.WriteInteger(Name, 'ListCol0', ListSummary.ColWidths[0]);
    end;
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameSummary.TimerMonTimer(Sender: TObject);
begin
  {$IFNDEF DEBUG}
  if not Application.Active then Exit;
  {$ENDIF}

  if Parent.Controls[Parent.ControlCount - 1] = Self then
    UpdateSummary(False);
  //xxxxx
end;

//Desc: 添加列表项
procedure TfFrameSummary.NewSummaryItem(const nKey, nFlag: string;
  nImage: Integer);
var nPic: PZnVLPicture;
begin
  nPic := ListSummary.AddPicture(nKey, '', nFlag);
  if nImage < 0 then
    nImage := FDM.BaseIconRandomIndex;
  //xxxxx

  nPic.FKey.FLoop := 1;
  nPic.FKey.FIcon := TBitmap.Create;
  FDM.ImageBase.GetBitmap(nImage, nPic.FKey.FIcon);

  nPic.FValue.FLoop := 1;
  nPic.FValue.FIcon := TBitmap.Create;
end;

//Desc: 更新列表项数据
procedure TfFrameSummary.UpdateItem(const nFlag,nValue: string;
  nImage: Integer);
var nData: PZnVLData;
    nPic: PZnVLPicture;
begin
  nData := ListSummary.FindData(nFlag);
  nPic := nData.FData;

  if nImage < 0 then
    nImage := FDM.BaseIconRandomIndex;
  //xxxx

  if (nPic.FValue.FText <> nValue) or (nPic.FValue.FFlag <> nImage) then
  begin
    FSummaryChanged := True;
    nPic.FValue.FText := nValue;

    if nPic.FValue.FFlag <> nImage then
    begin
      nPic.FValue.FFlag := nImage;
      FDM.ImageBase.GetBitmap(nImage, nPic.FValue.FIcon);
    end;
  end;
end;

//Desc: 更新列表
procedure TfFrameSummary.UpdateSummary(const nNewItem: Boolean);
var nStr: string;
    nIdx: Integer;

    function ItemFlag: string;
    begin
      Result := nStr + IntToStr(nIdx);
      Inc(nIdx);
    end;
begin
  if nNewItem then
  begin
    ListSummary.TitleCaptions.Clear;
    //默认表头

    nIdx := 1;
    nStr := 'srv_status';
    
    ListSummary.AddData('运行信息', '', nil, nStr, vtGroup);
    NewSummaryItem('服务状态', ItemFlag);
    NewSummaryItem('启动参数', ItemFlag);
    NewSummaryItem('HTTP状态', ItemFlag);
    NewSummaryItem('HTTP端口', ItemFlag);
    NewSummaryItem('HTTP连接', ItemFlag);
    NewSummaryItem('HTTP活动', ItemFlag);
    NewSummaryItem('HTTP峰值', ItemFlag);
    NewSummaryItem('TCP.状态', ItemFlag);
    NewSummaryItem('TCP.端口', ItemFlag);
    NewSummaryItem('TCP.连接', ItemFlag);
    NewSummaryItem('TCP.活动', ItemFlag);
    NewSummaryItem('TCP.峰值', ItemFlag);
    NewSummaryItem('连接请求', ItemFlag);
    NewSummaryItem('业务请求', ItemFlag);
    NewSummaryItem('请求错误', ItemFlag);

    {$IFDEF DBPool}
    nIdx := 1;
    nStr := 'db_status';

    ListSummary.AddData('DB连接池', '', nil, nStr, vtGroup);
    NewSummaryItem('请求总数', ItemFlag);
    NewSummaryItem('请求错误', ItemFlag);
    NewSummaryItem('连接参数', ItemFlag);
    NewSummaryItem('连接分组', ItemFlag);
    NewSummaryItem('连接对象', ItemFlag);
    NewSummaryItem('已连对象', ItemFlag);
    NewSummaryItem('分组复用', ItemFlag);
    NewSummaryItem('当前队列', ItemFlag);
    NewSummaryItem('队列峰值', ItemFlag);
    NewSummaryItem('峰值时间', ItemFlag);
    {$ENDIF}

    {$IFDEF SAP}
    nIdx := 1;
    nStr := 'sap_status';

    ListSummary.AddData('SAP连接池', '', nil, nStr, vtGroup);
    NewSummaryItem('请求总数', ItemFlag);
    NewSummaryItem('请求错误', ItemFlag);
    NewSummaryItem('连接参数', ItemFlag);
    NewSummaryItem('连接对象', ItemFlag);
    NewSummaryItem('已连对象', ItemFlag);
    NewSummaryItem('连接次数', ItemFlag);
    NewSummaryItem('复用对象', ItemFlag);
    NewSummaryItem('当前队列', ItemFlag);
    NewSummaryItem('连接峰值', ItemFlag);
    NewSummaryItem('峰值时间', ItemFlag);
    NewSummaryItem('单队峰值', ItemFlag);
    NewSummaryItem('峰值时间', ItemFlag);
    {$ENDIF}

    Exit;
  end;

  FSummaryChanged := False;
  //update flag
  
  with ROModule.LockModuleStatus^ do
  try
    nIdx := 1;
    nStr := 'srv_status';

    if FSrvTCP or FSrvHttp then
         UpdateItem(ItemFlag, '已启动', cIcon_Run)
    else UpdateItem(ItemFlag, '关闭', cIcon_Stop);

    if gSysParam.FParam = '' then
         UpdateItem(ItemFlag, '无')
    else UpdateItem(ItemFlag, gSysParam.FParam);

    if FSrvHttp then
         UpdateItem(ItemFlag, '已启动', cIcon_Run)
    else UpdateItem(ItemFlag, '关闭', cIcon_Stop);

    with gParamManager do
    begin
      if Assigned(ActiveParam) and Assigned(ActiveParam.FPerform) then
           UpdateItem(ItemFlag, IntToStr(ActiveParam.FPerform.FPortHttp))
      else UpdateItem(ItemFlag, '未知');
    end;

    UpdateItem(ItemFlag, Format('%d 次', [FNumHttpTotal]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumHttpActive]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumHttpMax]));

    if FSrvTCP then
         UpdateItem(ItemFlag, '已启动', cIcon_Run)
    else UpdateItem(ItemFlag, '关闭', cIcon_Stop);

    with gParamManager do
    begin
      if Assigned(ActiveParam) and Assigned(ActiveParam.FPerform) then
           UpdateItem(ItemFlag, IntToStr(ActiveParam.FPerform.FPortTCP))
      else UpdateItem(ItemFlag, '未知');
    end;

    UpdateItem(ItemFlag, Format('%d 次', [FNumTCPTotal]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumTCPActive]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumTCPMax]));
    
    UpdateItem(ItemFlag, Format('%d 次', [FNumConnection]));
    UpdateItem(ItemFlag, Format('%d 次', [FNumBusiness]));
    UpdateItem(ItemFlag, Format('%d 次', [FNumActionError]));
  finally
    ROModule.ReleaseStatusLock;
  end;

  {$IFDEF DBPool}
  with gDBConnManager.Status do
  begin
    nIdx := 1;
    nStr := 'db_status';

    UpdateItem(ItemFlag, Format('%d 次', [FNumObjRequest]));
    UpdateItem(ItemFlag, Format('%d 次', [FNumObjRequestErr]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumConnParam]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumConnItem]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumConnObj]));

    UpdateItem(ItemFlag, Format('%d 个', [FNumObjConned]));
    UpdateItem(ItemFlag, Format('%d 次', [FNumObjReUsed]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumObjWait]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumWaitMax]));
    UpdateItem(ItemFlag, Format('%s', [DateTime2Str(FNumMaxTime)]));
  end;
  {$ENDIF}

  {$IFDEF SAP}
  with gSAPConnectionManager.Status do
  begin
    nIdx := 1;
    nStr := 'sap_status';

    UpdateItem(ItemFlag, Format('%d 次', [FNumConnRequest]));
    UpdateItem(ItemFlag, Format('%d 次', [FNumRequestErr]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumConnParam]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumConnItem]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumConned]));
    UpdateItem(ItemFlag, Format('%d 次', [FNumConnTotal]));

    UpdateItem(ItemFlag, Format('%d 次', [FNumReUsed]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumWait]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumConnMax]));
    UpdateItem(ItemFlag, Format('%s', [DateTime2Str(FTimeConnMax)]));
    UpdateItem(ItemFlag, Format('%d 个', [FNumWaitMax]));
    UpdateItem(ItemFlag, Format('%s', [DateTime2Str(FTimeWaitMax)]));
  end;
  {$ENDIF}

  if FSummaryChanged then
    ListSummary.Invalidate;
  //refresh
end;

initialization
  gControlManager.RegCtrl(TfFrameSummary, TfFrameSummary.FrameID);
end.
