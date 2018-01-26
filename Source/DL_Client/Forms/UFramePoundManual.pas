{*******************************************************************************
  作者: dmzn@163.com 2014-06-10
  描述: 手动称重
*******************************************************************************}
unit UFramePoundManual;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ADODB, ExtCtrls, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxSplitter, Menus;

type
  TfFramePoundManual = class(TBaseFrame)
    WorkPanel: TScrollBox;
    Timer1: TTimer;
    cxSplitter1: TcxSplitter;
    SQLQuery: TADOQuery;
    DataSource1: TDataSource;
    cxGrid1: TcxGrid;
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure WorkPanelMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadPoundItems;
    //载入通道
    procedure LoadPoundData(const nWhere: string = '');
    //载入数据
  public
    { Public declarations }
    class function FrameID: integer; override;
    function FrameTitle: string; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function DealCommand(Sender: TObject; const nCmd: integer): integer; override;
    //子类继承
  end;

implementation

{$R *.dfm}

uses
  IniFiles, UlibFun, UMgrControl, UMgrPoundTunnels, UFramePoundManualItem,
  UMgrTruckProbe, UMgrRemoteVoice, UMgrVoiceNet, UDataModule, UFormWait,
  USysDataDict, USysGrid, USysLoger, USysConst, USysDB;

class function TfFramePoundManual.FrameID: integer;
begin
  Result := cFI_FramePoundManual;
end;

function TfFramePoundManual.FrameTitle: string;
begin
  Result := '称重 - 人工';
end;

procedure TfFramePoundManual.OnCreateFrame;
var nInt: Integer;
    nIni: TIniFile;
begin
  inherited;
  gSysParam.FIsManual := True;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nInt := nIni.ReadInteger(Name, 'GridHeight', 0);
    if nInt > 20 then
      cxGrid1.Height := nInt;
    //xxxxx

    gSysEntityManager.BuildViewColumn(cxView1, 'MAIN_E03');
    InitTableView(Name, cxView1, nIni);
  finally
    nIni.Free;
  end;

  if not Assigned(gPoundTunnelManager) then
  begin
    gPoundTunnelManager := TPoundTunnelManager.Create;
    gPoundTunnelManager.LoadConfig(gPath + 'Tunnels.xml');
  end;

  {$IFNDEF MITTruckProber}
    if not Assigned(gProberManager) then
    begin
      gProberManager := TProberManager.Create;
      gProberManager.LoadConfig(gPath + 'TruckProber.xml');
    end;
    
    Inc(gSysParam.FProberUser);
    gProberManager.StartProber;
  {$ENDIF}

  if gSysParam.FVoiceUser < 1 then
  begin
    Inc(gSysParam.FVoiceUser);
    gVoiceHelper.LoadConfig(gPath + 'Voice.xml');
    gVoiceHelper.StartVoice;

    if FileExists(gPath + 'NetVoice.xml') then
    begin
      if not Assigned(gNetVoiceHelper) then
        gNetVoiceHelper := TNetVoiceManager.Create;
      gNetVoiceHelper.LoadConfig(gPath + 'NetVoice.xml');
      gNetVoiceHelper.StartVoice;
    end;
  end;
end;

procedure TfFramePoundManual.OnDestroyFrame;
var nIni: TIniFile;
begin
  gSysParam.FIsManual := False;
  //关闭手动称重

  Dec(gSysParam.FVoiceUser);
  if gSysParam.FVoiceUser < 1 then
  begin
    if Assigned(gNetVoiceHelper) then gNetVoiceHelper.StopVoice;

    gVoiceHelper.StopVoice;
    //xxxxx
  end;          

  {$IFNDEF MITTruckProber}
    Dec(gSysParam.FProberUser);
    {$IFNDEF HR1847}
    if gSysParam.FProberUser < 1 then
      gProberManager.StopProber;
    //xxxxx
    {$ENDIF}
  {$ENDIF}

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteInteger(Name, 'GridHeight', cxGrid1.Height);
    SaveUserDefineTableView(Name, cxView1, nIni);
  finally
    nIni.Free;
  end;

  inherited;
end;

function TfFramePoundManual.DealCommand(Sender: TObject;
  const nCmd: integer): integer;
begin
  if (Sender is TfFrameManualPoundItem) and (nCmd = cCmd_RefreshData) then
    LoadPoundData;
  Result := 0;
end;

//------------------------------------------------------------------------------
//Desc: 延时载入通道
procedure TfFramePoundManual.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if gSysParam.FFactNum = '' then
  begin
    ShowDlg('系统需要授权才能称重,请联系管理员.', sHint);
    Exit;
  end;

  LoadPoundItems;
  LoadPoundData;
end;

//Desc: 支持滚轮
procedure TfFramePoundManual.WorkPanelMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  with WorkPanel do
    VertScrollBar.Position := VertScrollBar.Position - WheelDelta;
  //xxxxx
end;

//Desc: 载入通道
procedure TfFramePoundManual.LoadPoundItems;
var nIdx: Integer;
    nT: PPTTunnelItem;
begin
  with gPoundTunnelManager do
  begin
    for nIdx:=0 to Tunnels.Count - 1 do
    begin
      nT := Tunnels[nIdx];
      //tunnel

      with TfFrameManualPoundItem.Create(Self) do
      begin
        Name := 'fFrameManualPoundItem' + IntToStr(nIdx);
        Parent := WorkPanel;

        Align := alTop;
        HintLabel.Caption := nT.FName;
        PoundTunnel := nT;
      end;
    end;
  end;
end;

//Desc: 载入数据
procedure TfFramePoundManual.LoadPoundData(const nWhere: string);
var nStr: string;
begin
  ShowWaitForm(ParentForm, '读取数据');
  try
    nStr := 'Select * From $TB Where (P_PDate Is Null Or P_MDate Is Null)' +
            ' And (P_PDate > $Now-2 Or P_MDate > $Now-2) And (P_PModel<>''$Tmp'')';
    nStr := MacroValue(nStr, [MI('$TB', sTable_PoundLog),
            MI('$Now', sField_SQLServer_Now), MI('$Tmp', sFlag_PoundLS)]);
    //xxxxx

    if nWhere <> '' then
      nStr := nStr + ' And (' + nWhere + ')';
    FDM.QueryData(SQLQuery, nStr, False);
  finally
    CloseWaitForm;
  end;
end;

procedure TfFramePoundManual.N1Click(Sender: TObject);
begin
  LoadPoundData('');
end;

initialization
  gControlManager.RegCtrl(TfFramePoundManual, TfFramePoundManual.FrameID);
end.
