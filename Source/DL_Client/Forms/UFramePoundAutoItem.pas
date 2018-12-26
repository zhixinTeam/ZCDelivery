{*******************************************************************************
  作者: dmzn@163.com 2017-10-06
  描述: 自动称重通道项
*******************************************************************************}
unit UFramePoundAutoItem;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrPoundTunnels, UBusinessConst, UFrameBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, StdCtrls,
  UTransEdit, ExtCtrls, cxRadioGroup, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, ULEDFont, DateUtils;

type
  TfFrameAutoPoundItem = class(TBaseFrame)
    GroupBox1: TGroupBox;
    EditValue: TLEDFontNum;
    GroupBox3: TGroupBox;
    ImageGS: TImage;
    Label16: TLabel;
    Label17: TLabel;
    ImageBT: TImage;
    Label18: TLabel;
    ImageBQ: TImage;
    ImageOff: TImage;
    ImageOn: TImage;
    HintLabel: TcxLabel;
    EditTruck: TcxComboBox;
    EditMID: TcxComboBox;
    EditPID: TcxComboBox;
    EditMValue: TcxTextEdit;
    EditPValue: TcxTextEdit;
    EditJValue: TcxTextEdit;
    Timer1: TTimer;
    EditBill: TcxComboBox;
    EditZValue: TcxTextEdit;
    GroupBox2: TGroupBox;
    RadioPD: TcxRadioButton;
    RadioCC: TcxRadioButton;
    EditMemo: TcxTextEdit;
    EditWValue: TcxTextEdit;
    RadioLS: TcxRadioButton;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    Timer2: TTimer;
    Timer_ReadCard: TTimer;
    TimerDelay: TTimer;
    MemoLog: TZnTransMemo;
    Timer_SaveFail: TTimer;
    ckCloseAll: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer_ReadCardTimer(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
    procedure Timer_SaveFailTimer(Sender: TObject);
    procedure EditBillKeyPress(Sender: TObject; var Key: Char);
    procedure ckCloseAllClick(Sender: TObject);
  private
    { Private declarations }
    FCardUsed: string;
    //卡片类型
    FLEDContent: string;
    //显示屏内容
    FIsWeighting, FIsSaving: Boolean;
    //称重标识,保存标识
    FPoundTunnel: PPTTunnelItem;
    //磅站通道
    FLastGS,FLastBT,FLastBQ: Int64;
    //上次活动
    FBillItems: TLadingBillItems;
    FUIData,FInnerData: TLadingBillItem;
    //称重数据
    FLastCardDone: Int64;
    FLastCard, FCardTmp, FLastReader: string;
    //上次卡号, 临时卡号, 读卡器编号
    FSampleIndex: Integer;
    FValueSamples: array of Double;
    //数据采样
    FBarrierGate: Boolean;
    //是否采用道闸
    FEmptyPoundInit, FDoneEmptyPoundInit: Int64;
    //空磅计时,过磅保存后空磅
    FEmptyPoundIdleLong, FEmptyPoundIdleShort: Int64;
    //空磅等待时长
    FLogin: Integer;
    //摄像机登陆
    FSampleNum: Integer;
    //当前采样次数
    FSaveResult: Boolean;
    //保存结果
    FDept: string;
    //事件推送部门
    FIdx: Integer;
    procedure SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
    //界面数据
    procedure SetImageStatus(const nImage: TImage; const nOff: Boolean);
    //设置状态
    procedure SetTunnel(const nTunnel: PPTTunnelItem);
    //关联通道
    procedure OnPoundDataEvent(const nValue: Double);
    procedure OnPoundData(const nValue: Double);
    //读取磅重
    procedure LoadBillItems(const nCard: string);
    //读取交货单
    procedure InitSamples;
    procedure AddSample(const nValue: Double);
    function IsValidSamaple: Boolean;
    //处理采样
    function SavePoundSale: Boolean;
    function SavePoundData: Boolean;
    //保存称重
    procedure WriteLog(nEvent: string);
    //记录日志
    procedure PlayVoice(const nContent: string);
    //播放语音
    procedure LEDDisplay(const nContent: string);
    //LED显示
  public
    { Public declarations }
    class function FrameID: integer; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    //子类继承
    property PoundTunnel: PPTTunnelItem read FPoundTunnel write SetTunnel;
    //属性相关
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UFormBase, UMgrTruckProbe, UMgrRemoteVoice, UMgrVoiceNet,
  UMgrLEDDisp, UDataModule, USysBusiness, USysLoger, USysConst, USysDB;

const
  cFlag_ON    = 10;
  cFlag_OFF   = 20;

class function TfFrameAutoPoundItem.FrameID: integer;
begin
  Result := 0;
end;

procedure TfFrameAutoPoundItem.OnCreateFrame;
begin
  inherited;
  FPoundTunnel := nil;
  FIsWeighting := False;

  FLEDContent := '';
  FEmptyPoundInit := 0;
  FLogin := -1;
  FDept := GetEventDept;
end;

procedure TfFrameAutoPoundItem.OnDestroyFrame;
begin
  gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
  //关闭表头端口
  FreeCapture(FLogin);
  inherited;
end;

//Desc: 设置运行状态图标
procedure TfFrameAutoPoundItem.SetImageStatus(const nImage: TImage;
  const nOff: Boolean);
begin
  if nOff then
  begin
    if nImage.Tag <> cFlag_OFF then
    begin
      nImage.Tag := cFlag_OFF;
      nImage.Picture.Bitmap := ImageOff.Picture.Bitmap;
    end;
  end else
  begin
    if nImage.Tag <> cFlag_ON then
    begin
      nImage.Tag := cFlag_ON;
      nImage.Picture.Bitmap := ImageOn.Picture.Bitmap;
    end;
  end;
end;

procedure TfFrameAutoPoundItem.WriteLog(nEvent: string);
var nInt: Integer;
begin
  with MemoLog do
  try
    Lines.BeginUpdate;
    if Lines.Count > 20 then
     for nInt:=1 to 10 do
      Lines.Delete(0);
    //清理多余

    Lines.Add(DateTime2Str(Now) + #9 + nEvent);
  finally
    Lines.EndUpdate;
    Perform(EM_SCROLLCARET,0,0);
    Application.ProcessMessages;
  end;
end;

procedure WriteSysLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFrameAutoPoundItem, '自动称重业务', nEvent);
end;

//------------------------------------------------------------------------------
//Desc: 更新运行状态
procedure TfFrameAutoPoundItem.Timer1Timer(Sender: TObject);
begin
  SetImageStatus(ImageGS, GetTickCount - FLastGS > 5 * 1000);
  SetImageStatus(ImageBT, GetTickCount - FLastBT > 5 * 1000);
  SetImageStatus(ImageBQ, GetTickCount - FLastBQ > 5 * 1000);
end;

//Desc: 关闭红绿灯
procedure TfFrameAutoPoundItem.Timer2Timer(Sender: TObject);
begin
  Timer2.Tag := Timer2.Tag + 1;
  if Timer2.Tag < 10 then Exit;

  Timer2.Tag := 0;
  Timer2.Enabled := False;

  {$IFNDEF DEBUG}
  {$IFNDEF MITTruckProber}
  gProberManager.TunnelOC(FPoundTunnel.FID,False);
  {$ENDIF}
  {$ENDIF}
end;

//Desc: 设置通道
procedure TfFrameAutoPoundItem.SetTunnel(const nTunnel: PPTTunnelItem);
begin
  FBarrierGate := False;
  FEmptyPoundIdleLong := -1;
  FEmptyPoundIdleShort:= -1;

  FPoundTunnel := nTunnel;
  SetUIData(True);

  if not InitCapture(FPoundTunnel,FLogin) then
    WriteLog('通道:'+ FPoundTunnel.FID+'初始化失败,错误码:'+IntToStr(FLogin))
  else
    WriteLog('通道:'+ FPoundTunnel.FID+'初始化成功,登陆ID:'+IntToStr(FLogin));

  if Assigned(FPoundTunnel.FOptions) then
  with FPoundTunnel.FOptions do
  begin
    FBarrierGate := Values['BarrierGate'] = sFlag_Yes;
    FEmptyPoundIdleLong := StrToInt64Def(Values['EmptyIdleLong'], 60);
    FEmptyPoundIdleShort:= StrToInt64Def(Values['EmptyIdleShort'], 5);
  end;
end;

//Desc: 重置界面数据
procedure TfFrameAutoPoundItem.SetUIData(const nReset,nOnlyData: Boolean);
var nStr: string;
    nInt: Integer;
    nVal: Double;
    nItem: TLadingBillItem;
begin
  if nReset then
  begin
    FillChar(nItem, SizeOf(nItem), #0);
    //init

    with nItem do
    begin
      FPModel := sFlag_PoundPD;
      FFactory := gSysParam.FFactNum;
    end;

    FUIData := nItem;
    FInnerData := nItem;
    if nOnlyData then Exit;

    SetLength(FBillItems, 0);
    EditValue.Text := '0.00';
    EditBill.Properties.Items.Clear;

    FIsSaving    := False;
    FEmptyPoundInit := 0;

    if not FIsWeighting then
    begin
      gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
      //关闭表头端口

      Timer_ReadCard.Enabled := True;
      //启动读卡
    end;
  end;

  with FUIData do
  begin
    EditBill.Text := FID;
    EditTruck.Text := FTruck;
    EditMID.Text := FStockName;
    EditPID.Text := FCusName;

    EditMValue.Text := Format('%.2f', [FMData.FValue]);
    EditPValue.Text := Format('%.2f', [FPData.FValue]);
    EditZValue.Text := Format('%.2f', [FValue]);

    if (FValue > 0) and (FMData.FValue > 0) and (FPData.FValue > 0) then
    begin
      nVal := FMData.FValue - FPData.FValue;
      EditJValue.Text := Format('%.2f', [nVal]);
      EditWValue.Text := Format('%.2f', [FValue - nVal]);
    end else
    begin
      EditJValue.Text := '0.00';
      EditWValue.Text := '0.00';
    end;

    RadioPD.Checked := FPModel = sFlag_PoundPD;
    RadioCC.Checked := FPModel = sFlag_PoundCC;
    RadioLS.Checked := FPModel = sFlag_PoundLS;

    RadioLS.Enabled := (FPoundID = '') and (FID = '');
    //已称过重量或销售,禁用临时模式
    RadioCC.Enabled := FID <> '';
    //只有销售有出厂模式

    EditBill.Properties.ReadOnly := (FID = '') and (FTruck <> '');
    EditTruck.Properties.ReadOnly := FTruck <> '';
    EditMID.Properties.ReadOnly := (FID <> '') or (FPoundID <> '');
    EditPID.Properties.ReadOnly := (FID <> '') or (FPoundID <> '');
    //可输入项调整

    EditMemo.Properties.ReadOnly := True;
    EditMValue.Properties.ReadOnly := not FPoundTunnel.FUserInput;
    EditPValue.Properties.ReadOnly := not FPoundTunnel.FUserInput;
    EditJValue.Properties.ReadOnly := True;
    EditZValue.Properties.ReadOnly := True;
    EditWValue.Properties.ReadOnly := True;
    //可输入量调整

    if FTruck = '' then
    begin
      EditMemo.Text := '';
      Exit;
    end;
  end;

  nInt := Length(FBillItems);
  if nInt > 0 then
  begin
    if nInt > 1 then
         nStr := '销售并单'
    else nStr := '销售';

    if (FCardUsed = sFlag_Provide) or (FCardUsed = sFlag_Mul) then nStr := '供应';

    if FUIData.FNextStatus = sFlag_TruckBFP then
    begin
      RadioCC.Enabled := False;
      EditMemo.Text := nStr + '称皮重';
    end else
    begin
      RadioCC.Enabled := True;
      EditMemo.Text := nStr + '称毛重';
    end;
  end else
  begin
    if RadioLS.Checked then
      EditMemo.Text := '车辆临时称重';
    //xxxxx

    if RadioPD.Checked then
      EditMemo.Text := '车辆配对称重';
    //xxxxx
  end;
end;

//Date: 2014-09-19
//Parm: 磁卡或交货单号
//Desc: 读取nCard对应的交货单
procedure TfFrameAutoPoundItem.LoadBillItems(const nCard: string);
var nRet: Boolean;
    nIdx,nInt: Integer;
    nBills: TLadingBillItems;
    nStr,nHint, nVoice: string;
    nIsPreTruck:Boolean;
    nPrePValue: Double;
    nPrePMan: string;
    nPrePTime: TDateTime;
begin
  nStr := Format('读取到卡号[ %s ],开始执行业务.', [nCard]);
  WriteLog(nStr);
  WriteSysLog(nStr);

  FCardUsed := GetCardUsed(nCard);
  if (FCardUsed = sFlag_Provide) or (FCardUsed = sFlag_Mul) then
       nRet := GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills)
  else nRet := GetLadingBills(nCard, sFlag_TruckBFP, nBills);

  if (not nRet) or (Length(nBills) < 1) then
  begin
    nVoice := '读取磁卡信息失败,请联系管理员';
    PlayVoice(nVoice);

    WriteLog(nVoice);
    WriteSysLog(nVoice);
    SetUIData(True);
    Exit;
  end;

  nIsPreTruck := getPrePInfo(nBills[0].FTruck,nPrePValue,nPrePMan,nPrePTime);
  nHint := '';
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    {$IFDEF AutoTruckIn}
    if ((FNextStatus=sFlag_TruckNone) or (FStatus=sFlag_TruckNone))
        and (FCardUsed=sFlag_Mul) then
    begin
      if SavePurchaseOrders(sFlag_TruckIn, nBills) then
      begin
        ShowMsg('车辆进厂成功', sHint);
        LoadBillItems(FCardTmp);
        Exit;
      end else
      begin
        ShowMsg('车辆进厂失败', sHint);

        nVoice := '车辆进厂失败,请联系管理员';
        PlayVoice(nVoice);

        WriteLog(nVoice);
        WriteSysLog(nVoice);
        SetUIData(True);
        Exit;
      end;
    end;
    if ((FNextStatus=sFlag_TruckNone) or (FStatus=sFlag_TruckNone))
        and (FCardUsed=sFlag_Provide) and (FCtype=sFlag_CardLinShi) then
    begin
      if SavePurchaseOrders(sFlag_TruckIn, nBills) then
      begin
        ShowMsg('车辆进厂成功', sHint);
        LoadBillItems(FCardTmp);
        Exit;
      end else
      begin
        ShowMsg('车辆进厂失败', sHint);

        nVoice := '车辆进厂失败,请联系管理员';
        PlayVoice(nVoice);

        WriteLog(nVoice);
        WriteSysLog(nVoice);
        SetUIData(True);
        Exit;
      end;
    end;
    if ((FNextStatus=sFlag_TruckNone) or (FStatus=sFlag_TruckOut))
        and (FCardUsed=sFlag_Provide) and (FCtype=sFlag_CardGuDing) then
    begin
      if SavePurchaseOrders(sFlag_TruckIn, nBills) then
      begin
        ShowMsg('车辆进厂成功', sHint);
        LoadBillItems(FCardTmp);
        Exit;
      end else
      begin
        ShowMsg('车辆进厂失败', sHint);

        nVoice := '车辆进厂失败,请联系管理员';
        PlayVoice(nVoice);

        WriteLog(nVoice);
        WriteSysLog(nVoice);
        SetUIData(True);
        Exit;
      end;
    end;
    if ((FNextStatus=sFlag_TruckNone) or (FStatus=sFlag_TruckNone))
      and (FCardUsed=sFlag_Sale) then
    begin
      if SaveLadingBills(sFlag_TruckIn, nBills) then
      begin
        ShowMsg('车辆进厂成功', sHint);
        LoadBillItems(FCardTmp);
        Exit;
      end else
      begin
        ShowMsg('车辆进厂失败', sHint);
        nVoice := '车辆进厂失败,请联系管理员';
        PlayVoice(nVoice);

        WriteSysLog(nVoice);

        SetUIData(True);
        Exit;
      end;
    end;
    {$ELSE}
    if ((FNextStatus=sFlag_TruckNone) or (FStatus=sFlag_TruckOut))
        and (FCardUsed=sFlag_Provide) and (FCtype=sFlag_CardGuDing) then
    begin
      if SavePurchaseOrders(sFlag_TruckIn, nBills) then
      begin
        ShowMsg('车辆进厂成功', sHint);
        LoadBillItems(FCardTmp);
        Exit;
      end else
      begin
        ShowMsg('车辆进厂失败', sHint);

        nVoice := '车辆进厂失败,请联系管理员';
        PlayVoice(nVoice);

        WriteLog(nVoice);
        WriteSysLog(nVoice);
        SetUIData(True);
        Exit;
      end;
    end;
    if (FNextStatus=sFlag_TruckNone) and (FCardUsed=sFlag_Sale)
       and IsOtherOrder(nBills[nIdx]) then//矿山外运自动进厂
    begin
      if SaveLadingBills(sFlag_TruckIn, nBills) then
      begin
        ShowMsg('车辆进厂成功', sHint);
        LoadBillItems(FCardTmp);
        Exit;
      end else
      begin
        ShowMsg('车辆进厂失败', sHint);
        nVoice := '车辆进厂失败,请联系管理员';
        PlayVoice(nVoice);

        WriteLog(nVoice);
        WriteSysLog(nVoice);

        SetUIData(True);
        Exit;
      end;
    end;
    {$ENDIF}
    WriteSysLog('交货单状态:'+'内倒:'+FNeiDao+'当前:'+FStatus+'下一状态:'+FNextStatus);
    if (FStatus = sFlag_TruckBFM) and (FCardUsed = sFlag_Sale)
       and IsMulMaoStock(FStockNo) then
    begin
      FStatus := sFlag_TruckFH;
      FNextStatus := sFlag_TruckBFM;
      WriteSysLog('交货单状态调整:'+'允许多次过重:Y,当前:'+FStatus+'下一状态:'+FNextStatus);
    end;
    if FNeiDao=sflag_yes then
    begin
      if ((FStatus=sFlag_TruckOut)
          or ((FStatus = sFlag_TruckBFM) and (FNextStatus = sFlag_TruckOut))
          or ((FStatus = sFlag_TruckBFM) and (FNextStatus = sFlag_TruckBFP))) then
      begin
        FStatus := sFlag_TruckIn;
        FNextStatus := sFlag_TruckBFP;
        FillChar(FPData, SizeOf(FPData), 0);
        FillChar(FMData, SizeOf(FMData), 0);
      end;
    end;
    if (FStatus = sFlag_TruckOut) and (FCardUsed = sFlag_Sale) then
    begin
      if IsTruckCanPound(nBills[nIdx]) then
      begin
        FStatus := sFlag_TruckIn;
        FNextStatus := sFlag_TruckBFP;
        FillChar(FPData, SizeOf(FPData), 0);
        FillChar(FMData, SizeOf(FMData), 0);
      end
      else
      begin
        ShowMsg('订单余量不足',sHint);
        nVoice := '订单余量不足,请联系管理员';
        PlayVoice(nVoice);

        WriteLog(nVoice);
        WriteSysLog(nVoice);
        SetUIData(True);
        Exit;
      end;
    end;
    //长期卡+预置皮重
    if (FCtype=sFlag_CardGuDing) and nIsPreTruck then
    begin
      //皮重过期或皮重为0，则重新保存皮重
      if nPrePValue < 0.00001 then
      begin
        FStatus := sFlag_TruckIn;
        FNextStatus := sFlag_TruckBFP;
        FillChar(FPData, SizeOf(FPData), 0);
        FillChar(FMData, SizeOf(FMData), 0);
      end
      //皮重有效，保存毛重
      else begin
        FNextStatus := sFlag_TruckBFM;
        with nBills[0] do
        begin
          FPData.FValue := nPrePValue;
          FPData.FOperator := nPrePMan;
          FPData.FDate := nPrePTime;
        end;
      end;
    end
    else
    if (FCardUsed=sFlag_Mul) and (FPoundIdx > 1) then
    begin
      getLastPInfo(nBills[0].FID,nPrePValue,nPrePMan,nPrePTime);
      with nBills[0] do
      begin
        FPData.FValue := nPrePValue;
        FPData.FOperator := nPrePMan;
        FPData.FDate := nPrePTime;
      end;
    end
    else if (FStatus <> sFlag_TruckBFP) and (FNextStatus = sFlag_TruckZT) then
      FNextStatus := sFlag_TruckBFP;
    //状态校正

    FSelected := (FNextStatus = sFlag_TruckBFP) or
                 (FNextStatus = sFlag_TruckBFM);
    //可称重状态判定

    if FSelected then
    begin
      Inc(nInt);
      Continue;
    end;

    nStr := '※.单号:[ %s ] 状态:[ %-6s -> %-6s ]   ';
    if nIdx < High(nBills) then nStr := nStr + #13#10;

    nStr := Format(nStr, [FID,
            TruckStatusToStr(FStatus), TruckStatusToStr(FNextStatus)]);
    nHint := nHint + nStr;

    nVoice := '车辆 %s 不能过磅,应该去 %s ';
    nVoice := Format(nVoice, [FTruck, TruckStatusToStr(FNextStatus)]);
  end;

  if nInt = 0 then
  begin
    PlayVoice(nVoice);
    //车辆状态异常

    nHint := '该车辆当前不能过磅,详情如下: ' + #13#10#13#10 + nHint;
    WriteSysLog(nStr);
    SetUIData(True);
    Exit;
  end;

  EditBill.Properties.Items.Clear;
  SetLength(FBillItems, nInt);
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    if FSelected then
    begin
      FPoundID := '';
      //该标记有特殊用途

      if nInt = 0 then
           FInnerData := nBills[nIdx]
      else FInnerData.FValue := FInnerData.FValue + FValue;
      //累计量

      EditBill.Properties.Items.Add(FID);
      FBillItems[nInt] := nBills[nIdx];
      Inc(nInt);
    end;
  end;

  FInnerData.FPModel := sFlag_PoundPD;
  //默认配对模式
  if FInnerData.FYSValid = sFlag_Yes then
    FInnerData.FPModel := sFlag_PoundCC;
  //空车出厂模式

  FUIData := FInnerData;
  SetUIData(False);

  nInt := GetTruckLastTime(FUIData.FTruck);
  if (nInt > 0) and (nInt < FPoundTunnel.FCardInterval) then
  begin
    nStr := '磅站[ %s.%s ]: 车辆[ %s ]需等待 %d 秒后才能过磅';
    nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
            FUIData.FTruck, FPoundTunnel.FCardInterval - nInt]);
    WriteSysLog(nStr);
    SetUIData(True);
    Exit;
  end;
  //指定时间内车辆禁止过磅

  InitSamples;
  //初始化样本

  if not FPoundTunnel.FUserInput then
  if not gPoundTunnelManager.ActivePort(FPoundTunnel.FID,
         OnPoundDataEvent, True) then
  begin
    nHint := '连接地磅表头失败，请联系管理员检查硬件连接';
    WriteSysLog(nHint);

    nVoice := nHint;
    PlayVoice(nVoice);

    SetUIData(True);
    Exit;
  end;

  Timer_ReadCard.Enabled := False;
  FDoneEmptyPoundInit := 0;
  FIsWeighting := True;
  FSampleNum := 0;
  FSaveResult := True;
  //停止读卡,开始称重

  if FBarrierGate then
  begin
    nStr := '[n1]%s刷卡成功请上磅,并熄火停车';
    nStr := Format(nStr, [FUIData.FTruck]);
    PlayVoice(nStr);
    //读卡成功，语音提示

    {$IFNDEF DEBUG}
    OpenDoorByReader(FLastReader);
    //打开主道闸
    {$ENDIF}
  end;
  //车辆上磅
end;

//------------------------------------------------------------------------------
//Desc: 由定时读取交货单
procedure TfFrameAutoPoundItem.Timer_ReadCardTimer(Sender: TObject);
var nStr,nCard: string;
    nLast, nDoneTmp: Int64;
begin
  if gSysParam.FIsManual then Exit;
  Timer_ReadCard.Tag := Timer_ReadCard.Tag + 1;
  if Timer_ReadCard.Tag < 5 then Exit;

  Timer_ReadCard.Tag := 0;
  if FIsWeighting then Exit;

  try
    WriteLog('正在读取磁卡号.');
    {$IFDEF DEBUG}
    nCard := '333';
    {$ELSE}
    nCard := Trim(ReadPoundCard(FPoundTunnel.FID, FLastReader));
    {$ENDIF}
    if nCard = '' then Exit;

    if nCard <> FLastCard then
         nDoneTmp := 0
    else nDoneTmp := FLastCardDone;
    //新卡时重置

    {$IFDEF DEBUG}
    nStr := '磅站[ %s.%s ]: 读取到新卡号::: %s =>旧卡号::: %s';
    nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
            nCard, FLastCard]);
    WriteSysLog(nStr);
    {$ENDIF}

    nLast := Trunc((GetTickCount - nDoneTmp) / 1000);
    if (nDoneTmp <> 0) and (nLast < FPoundTunnel.FCardInterval)  then
    begin
      nStr := '磅站[ %s.%s ]: 磁卡[ %s ]需等待 %d 秒后才能过磅';
      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
              nCard, FPoundTunnel.FCardInterval - nLast]);
      WriteSysLog(nStr);
      Exit;
    end;

    FCardTmp := nCard;
    EditBill.Text := nCard;
    LoadBillItems(EditBill.Text);
  except
    on E: Exception do
    begin
      nStr := Format('磅站[ %s.%s ]: ',[FPoundTunnel.FID,
              FPoundTunnel.FName]) + E.Message;
      WriteSysLog(nStr);

      SetUIData(True);
      //错误则重置
    end;
  end;
end;

//Desc: 保存销售
function TfFrameAutoPoundItem.SavePoundSale: Boolean;
var nStr, nHint: string;
    nVal,nNet: Double;
    nIdx: Integer;
begin
  Result := False;
  //init

  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
  begin
    if FUIData.FPData.FValue <= 0 then
    begin
      WriteLog('请先称量皮重');
      Exit;
    end;

    nNet := GetTruckEmptyValue(FUIData.FTruck);
    nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

    if (nNet > 0) and (gSysParam.FTruckPWuCha > 0) and
       (Abs(nVal) > gSysParam.FTruckPWuCha) then
    with FUIData do
    begin
      {$IFDEF AutoPoundInManual}
      nStr := '车辆[%s]实时皮重误差较大,请通知司机检查车厢';
      nStr := Format(nStr, [FTruck]);
      PlayVoice(nStr);

      nStr := '车辆[ %s ]实时皮重误差较大,详情如下:' + #13#10#13#10 +
              '※.实时皮重: %.2f吨' + #13#10 +
              '※.历史皮重: %.2f吨' + #13#10 +
              '※.误差量: %.2f公斤' + #13#10#13#10 +
              '是否继续保存?';
      nStr := Format(nStr, [FTruck, FPData.FValue, nNet, nVal]);
      if not QueryDlg(nStr, sAsk) then Exit;
      {$ELSE}
      nStr := '车辆[ %s ]实时皮重误差较大,详情如下:' + #13#10 +
              '※.实时皮重: %.2f吨' + #13#10 +
              '※.历史皮重: %.2f吨' + #13#10 +
              '※.误差量: %.2f公斤' + #13#10 +
              '允许过磅,请选是;禁止过磅,请选否.';
      nStr := Format(nStr, [FTruck, FPData.FValue, nNet, nVal]);

      if not VerifyManualEventRecord(FID + sFlag_ManualB, nStr) then
      begin
        AddManualEventRecord(FID + sFlag_ManualB, FTruck, nStr,
            sFlag_DepBangFang, sFlag_Solution_YN, sFlag_DepDaTing, True);
        WriteSysLog(nStr);

        nStr := '[n1]%s皮重超出预警,请下磅联系开票员处理后再次过磅';
        nStr := Format(nStr, [FTruck]);
        PlayVoice(nStr);
        Exit;
      end;
      {$ENDIF}
    end;
  end else
  begin
    if FUIData.FMData.FValue <= 0 then
    begin
      WriteLog('请先称量毛重');
      Exit;
    end;
  end;

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) and
     (FUIData.FPModel <> sFlag_PoundCC) then //有净重,非出厂模式
  begin

    nNet := GetMaxMValue(FUIData.FID);

    if (nNet > 0) and (nNet < FUIData.FMData.FValue) then
    with FUIData do
    begin
      nStr := GetTruckNO(FTruck) + '重量  ' + GetValue(FMData.FValue);
      for nIdx := 1 to 3 do
      begin
        {$IFDEF MITTruckProber}
        ProberShowTxt(FPoundTunnel.FID, nStr);
        {$ELSE}
        gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
        {$ENDIF}
      end;

      nStr := '车辆[ %s ]毛重超出开票毛重限值,详情如下:' + #13#10 +
              '※.物料名称: [ %s ]' + #13#10 +
              '※.车辆毛重: %.2f吨' + #13#10 +
              '※.开票限值: %.2f吨' + #13#10 +
              '允许过磅,请选是;禁止过磅,请选否.';
      nStr := Format(nStr, [FTruck, FStockName, FMData.FValue, nNet]);

      if not VerifyManualEventRecord(FID + sFlag_ManualB, nStr) then
      begin
        AddManualEventRecord(FID + sFlag_ManualB, FTruck, nStr,
            sFlag_DepBangFang, sFlag_Solution_YN, sFlag_DepDaTing, True);
        WriteSysLog(nStr);

        nStr := '[n1]%s毛重超出开票限值,请下磅联系开票员处理后再次过磅';
        nStr := Format(nStr, [FTruck]);
        PlayVoice(nStr);

        Exit;
      end;
    end;

    with FUIData do
    begin
      nNet := Abs(FUIData.FMData.FValue - FUIData.FPData.FValue);
      nNet := nNet * 1000;
      //净重
      nVal := GetMinNetValue;
      //过磅最小称重限值
      if nNet < nVal then
      begin
        nStr := GetTruckNO(FTruck) + '重量  ' + GetValue(FMData.FValue);
        for nIdx := 1 to 3 do
        begin
          {$IFDEF MITTruckProber}
          ProberShowTxt(FPoundTunnel.FID, nStr);
          {$ELSE}
          gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
          {$ENDIF}
        end;

        nStr := '车辆[ %s ]净重小于过磅净重限值,详情如下:' + #13#10 +
                '※.物料名称: [ %s ]' + #13#10 +
                '※.车辆净重: %.2f公斤' + #13#10 +
                '※.过磅净重限值: %.2f公斤' + #13#10 +
                '允许过磅,请选是;禁止过磅,请选否.';
        nStr := Format(nStr, [FTruck, FStockName, nNet, nVal]);

        if not VerifyManualEventRecord(FID + sFlag_ManualB, nStr) then
        begin
          AddManualEventRecord(FID + sFlag_ManualB, FTruck, nStr,
              sFlag_DepBangFang, sFlag_Solution_YN, sFlag_DepDaTing, True);
          WriteSysLog(nStr);

          nStr := '[n1]%s净重小于过磅净重限值,请下磅联系开票员处理后再次过磅';
          nStr := Format(nStr, [FTruck]);
          PlayVoice(nStr);

          Exit;
        end;
      end;
    end;

    {$IFDEF SyncDataByWSDL}
    with FUIData do
    begin
      if FType = sFlag_San then
        nNet := Abs(FUIData.FMData.FValue - FUIData.FPData.FValue)
      else
        nNet := FUIData.FValue;
      //净重
      if not PoundVerifyHhSalePlanWSDL(FUIData.FID, nNet, '', nHint) then
      begin
        nStr := GetTruckNO(FTruck) + '重量  ' + GetValue(FMData.FValue);
        for nIdx := 1 to 3 do
        begin
          {$IFDEF MITTruckProber}
          ProberShowTxt(FPoundTunnel.FID, nStr);
          {$ELSE}
          gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
          {$ENDIF}
        end;

        nStr := '车辆[ %s ]过磅校验失败,详情如下:' + #13#10 +
                '※.物料名称: [ %s ]' + #13#10 +
                '※.车辆净重: %.2f吨' + #13#10 +
                '※.详细原因为:[ %s ].';
        nStr := Format(nStr, [FTruck, FStockName, nNet, nHint]);

        if not VerifyManualEventRecord(FID + sFlag_ManualB, nStr) then
        begin
          AddManualEventRecord(FID + sFlag_ManualB, FTruck, nStr,
              sFlag_DepBangFang, sFlag_Solution_OK, sFlag_DepDaTing, True);
          WriteSysLog(nStr);

          nStr := '[n1]%s重车过磅订单校验失败,请下磅联系开票员处理后再次过磅';
          nStr := Format(nStr, [FTruck]);
          PlayVoice(nStr);

          Exit;
        end;
      end;
    end;
    {$ELSE}
    with FUIData do
    if FType = sFlag_San then
    begin
      nNet := FUIData.FMData.FValue - FUIData.FPData.FValue - FInnerData.FValue;
      //净重与票重之差
      nVal := GetSaleOrderRestValue(FUIData.FZhiKa);
      //订单可用量
      if nNet > nVal then
      begin
        nStr := GetTruckNO(FTruck) + '重量  ' + GetValue(FMData.FValue);
        for nIdx := 1 to 3 do
        begin
          {$IFDEF MITTruckProber}
          ProberShowTxt(FPoundTunnel.FID, nStr);
          {$ELSE}
          gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
          {$ENDIF}
        end;

        nStr := '车辆[ %s ]净重超出订单可用量,详情如下:' + #13#10 +
                '※.物料名称: [ %s ]' + #13#10 +
                '※.车辆净重: %.2f吨' + #13#10 +
                '※.订单可用量: %.2f吨' + #13#10 +
                '请联系客户补量或通知司机卸货.';
        nStr := Format(nStr, [FTruck, FStockName, nNet, nVal]);

        if not VerifyManualEventRecord(FID + sFlag_ManualB, nStr) then
        begin
          AddManualEventRecord(FID + sFlag_ManualB, FTruck, nStr,
              sFlag_DepBangFang, sFlag_Solution_OK, sFlag_DepDaTing, True);
          WriteSysLog(nStr);

          nStr := '[n1]%s净重超出订单可用量,请下磅联系开票员处理后再次过磅';
          nStr := Format(nStr, [FTruck]);
          PlayVoice(nStr);

          Exit;
        end;
      end;
    end;
    {$ENDIF}

    nNet := FUIData.FMData.FValue - FUIData.FPData.FValue;
    //净重
    nVal := nNet * 1000 - FInnerData.FValue * 1000;
    //与开票量误差(公斤)

    with gSysParam,FBillItems[0] do
    begin
      {$IFDEF DaiStepWuCha}
      if FType = sFlag_Dai then
      begin
        GetPoundAutoWuCha(FPoundDaiZ, FPoundDaiF, FInnerData.FValue);
        //计算误差
      end;
      {$ELSE}
      if FDaiPercent and (FType = sFlag_Dai) then
      begin
        if nVal > 0 then
             FPoundDaiZ := Float2Float(FInnerData.FValue * FPoundDaiZ_1 * 1000,
                                       cPrecision, False)
        else FPoundDaiF := Float2Float(FInnerData.FValue * FPoundDaiF_1 * 1000,
                                       cPrecision, False);
      end;
      {$ENDIF}

      if nVal <> 0 then
      if ((FType = sFlag_Dai) and (
          ((nVal > 0) and (FPoundDaiZ > 0) and (nVal > FPoundDaiZ)) or
          ((nVal < 0) and (FPoundDaiF > 0) and (-nVal > FPoundDaiF)))) then
      begin
        {$IFDEF AutoPoundInManual}
        nStr := '车辆[%s]实际装车量误差较大,请去包装点包.';
        nStr := Format(nStr, [FTruck]);
        PlayVoice(nStr);

        nStr := '车辆[ %s ]实际装车量误差较大,详情如下:' + #13#10#13#10 +
                '※.开单量: %.2f吨' + #13#10 +
                '※.装车量: %.2f吨' + #13#10 +
                '※.误差量: %.2f公斤';
        //xxxxx

        if FDaiWCStop then
        begin
          nStr := nStr + #13#10#13#10 + '请通知司机点验包数.';
          nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, nVal]);

          ShowDlg(nStr, sHint);
          Exit;
        end else
        begin
          nStr := nStr + #13#10#13#10 + '是否继续保存?';
          nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, nVal]);
          if not QueryDlg(nStr, sAsk) then Exit;
        end;
        {$ELSE}
        nStr := '车辆[ %s ]实际装车量误差较大,详情如下:' + #13#10 +
                '※.物料名称: [ %s ]' + #13#10 +
                '※.开单量: %.2f吨' + #13#10 +
                '※.装车量: %.2f吨' + #13#10 +
                '※.误差量: %.2f公斤' + #13#10 +
                '检测完毕后,请点确认重新过磅.';
        nStr := Format(nStr, [FTruck, FStockName, FInnerData.FValue, nNet, nVal]);

        if not VerifyManualEventRecord(FID + sFlag_ManualC, nStr) then
        begin
          AddManualEventRecord(FID + sFlag_ManualC, FTruck, nStr,
            sFlag_DepBangFang, sFlag_Solution_YN, FDept, True);
          WriteSysLog(nStr);

          nStr := '车辆[n1]%s净重[n2]%.2f吨,开票量[n2]%.2f吨,'+
                  '误差量[n2]%.2f公斤,请去包装点包';
          nStr := Format(nStr, [FTruck, nNet, FInnerData.FValue, nVal]);
          PlayVoice(nStr);

          if nVal < 0 then
            nStr := GetTruckNO(FTruck) + '补包  ' + GetValue(Abs(nVal))
          else
            nStr := GetTruckNO(FTruck) + '卸包  ' + GetValue(nVal);

          for nIdx := 1 to 3 do
          begin
            {$IFDEF MITTruckProber}
            ProberShowTxt(FPoundTunnel.FID, nStr);
            {$ELSE}
            gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
            {$ENDIF}
          end;

          Exit;
        end;
        {$ENDIF}
      end;

      if (FType = sFlag_San) and IsStrictSanValue and
         FloatRelation(FValue, nNet, rtLess, cPrecision) then
      begin
        nStr := '车辆[n1]%s[p500]净重[n2]%.2f吨[p500]开票量[n2]%.2f吨,请卸货';
        nStr := Format(nStr, [FTruck, Float2Float(nNet, cPrecision, True),
                Float2Float(FValue, cPrecision, True)]);
        //xxxxx

        WriteSysLog(nStr);
        PlayVoice(nStr);
        Exit;
      end;
    end;
  end;

  {$IFNDEF AutoPoundInManual}
  if (FUIData.FPModel = sFlag_PoundCC) and
     (FUIData.FNextStatus = sFlag_TruckBFM) then //出厂模式,过重车
  with FUIData do
  begin
    nNet := FUIData.FMData.FValue - FUIData.FPData.FValue;
    nNet := Trunc(nNet * 1000);
    //净重

    if nNet > 0 then
    if nNet > gSysParam.FEmpTruckWc then
    begin
      nVal := nNet - gSysParam.FEmpTruckWc;
      nStr := '车辆[n1]%s[p500]空车出厂超差[n2]%.2f公斤,请司机联系司磅管理员检查车厢';
      nStr := Format(nStr, [FBillItems[0].FTruck, Float2Float(nVal, cPrecision, True)]);
      WriteSysLog(nStr);
      PlayVoice(nStr);
      Exit;
    end;
    FUIData.FMData.FValue := FUIData.FPData.FValue;
//    nStr := '车辆[ %s ]正在空车出厂,详情如下:' + #13#10 +
//            '※.单据号: %s' + #13#10 +
//            '※.开单量: %.2f吨' + #13#10 +
//            '※.净  重: %.2f公斤' + #13#10 +
//            '请确认净重无误后,执行删单操作.';
//    nStr := Format(nStr, [FTruck, FID, FValue, nNet]);
//
//    AddManualEventRecord(FID + sFlag_ManualD, FTruck, nStr,
//      sFlag_DepBangFang , sFlag_Solution_OK, sFlag_DepDaTing, True);
    //xxxxx
  end;
  {$ENDIF}

  with FBillItems[0] do
  begin
    FPModel := FUIData.FPModel;
    FFactory := gSysParam.FFactNum;

    with FPData do
    begin
      FStation := FPoundTunnel.FID;
      FValue := FUIData.FPData.FValue;
      FOperator := gSysParam.FUserID;
    end;

    with FMData do
    begin
      FStation := FPoundTunnel.FID;
      FValue := FUIData.FMData.FValue;
      FOperator := gSysParam.FUserID;
    end;

    FPoundID := sFlag_Yes;
    //标记该项有称重数据
    FSaveResult := SaveLadingBills(FNextStatus, FBillItems, FPoundTunnel, FLogin);
    Result := FSaveResult;
    //保存称重
  end;
end;

//------------------------------------------------------------------------------
//Desc: 原材料或临时
function TfFrameAutoPoundItem.SavePoundData: Boolean;
var nNextStatus: string;
    nIsPreTruck:Boolean;
    nPrePValue: Double;
    nPrePMan: string;
    nPrePTime: TDateTime;
    nIdx: Integer;
begin
  Result := False;
  //init
  with FUIData do
  begin
    nIsPreTruck := getPrePInfo(FTruck,nPrePValue,nPrePMan,nPrePTime);
    //长期卡+预置皮重
    if (FCtype=sFlag_CardGuDing) and nIsPreTruck then
    begin
      //重量小于设定，则重新保存皮重
      if (StrToFloatDef(EditValue.Text,0) < GetPrePValueSet) then
      begin
        SaveTruckPrePValue(FTruck,EditValue.Text);
        UpdateTruckStatus(FUIData.FID);
        SaveTruckPrePicture(FTruck,FPoundTunnel,FLogin);

        Result := True;
        Exit;
      end;
    end;
  end;

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) then
  begin
    if FUIData.FPData.FValue > FUIData.FMData.FValue then
    begin
      WriteLog('皮重应小于毛重');
      Exit;
    end;
  end;

  nNextStatus := FBillItems[0].FNextStatus;
  //暂存过磅状态

  SetLength(FBillItems, 1);
  FBillItems[0] := FUIData;
  //复制用户界面数据

  with FBillItems[0] do
  begin
    FFactory := gSysParam.FFactNum;
    //xxxxx

    if FNextStatus = sFlag_TruckBFP then
         FPData.FStation := FPoundTunnel.FID
    else FMData.FStation := FPoundTunnel.FID;
  end;

  FSaveResult := SavePurchaseOrders(nNextStatus, FBillItems,FPoundTunnel,FLogin);
  Result := FSaveResult;
  //保存称重
end;

//Desc: 读取表头数据
procedure TfFrameAutoPoundItem.OnPoundDataEvent(const nValue: Double);
begin
  try
    if FIsSaving then Exit;
    //正在保存。。。

    OnPoundData(nValue);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      SetUIData(True);
    end;
  end;
end;

//Desc: 处理表头数据
procedure TfFrameAutoPoundItem.OnPoundData(const nValue: Double);
var nStr: string;
    nRet: Boolean;
    nInt: Int64;
    nPrePValue: Double;
    nPrePMan: string;
    nPrePTime: TDateTime;
    nIdx: Integer;
begin
  FLastBT := GetTickCount;
  EditValue.Text := Format('%.2f', [nValue]);

  if not FIsWeighting then Exit;
  //不在称重中
  if gSysParam.FIsManual then Exit;
  //手动时无效

  if nValue < FPoundTunnel.FPort.FMinValue then //空磅
  begin
    if FEmptyPoundInit = 0 then
      FEmptyPoundInit := GetTickCount;
    nInt := GetTickCount - FEmptyPoundInit;

    if (nInt > FEmptyPoundIdleLong * 1000) then
    begin
      FIsWeighting :=False;
      Timer_SaveFail.Enabled := True;

      WriteSysLog('刷卡后司机无响应,退出称重.');
      Exit;
    end;
    //上磅时间,延迟重置

    if (nInt > FEmptyPoundIdleShort * 1000) and   //保证空磅
       (FDoneEmptyPoundInit>0) and (GetTickCount-FDoneEmptyPoundInit>nInt) then
    begin
      FIsWeighting :=False;
      Timer_SaveFail.Enabled := True;

      WriteSysLog('司机已下磅,退出称重.');
      Exit;
    end;
    //上次保存成功后,空磅超时,认为车辆下磅

    Exit;
  end else
  begin
    FEmptyPoundInit := 0;
    if FDoneEmptyPoundInit > 0 then
      FDoneEmptyPoundInit := GetTickCount;
    //车辆称重完毕后，未下磅
  end;

  AddSample(nValue);
  if not IsValidSamaple then Exit;
  //样本验证不通过

  if Length(FBillItems) < 1 then Exit;
  //无称重数据

  if (FCardUsed = sFlag_Provide) or (FCardUsed = sFlag_Mul) then
  begin
    if FInnerData.FPData.FValue > 0 then
    begin
      if nValue <= FInnerData.FPData.FValue then
      begin
        FUIData.FPData := FInnerData.FMData;
        FUIData.FMData := FInnerData.FPData;

        FUIData.FPData.FValue := nValue;
        FUIData.FNextStatus := sFlag_TruckBFP;
        //切换为称皮重
      end else
      begin
        FUIData.FPData := FInnerData.FPData;
        FUIData.FMData := FInnerData.FMData;

        FUIData.FMData.FValue := nValue;
        FUIData.FNextStatus := sFlag_TruckBFM;
        //切换为称毛重
      end;
    end else FUIData.FPData.FValue := nValue;
  end else
  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
       FUIData.FPData.FValue := nValue
  else FUIData.FMData.FValue := nValue;

  SetUIData(False);
  //更新界面

  {$IFNDEF DEBUG}
  {$IFDEF MITTruckProber}
  if not IsTunnelOK(FPoundTunnel.FID) then
  {$ELSE}
    {$IFNDEF TruckProberEx}
    if not gProberManager.IsTunnelOK(FPoundTunnel.FID) then
    {$ELSE}
    if not gProberManager.IsTunnelOKEx(FPoundTunnel.FID) then
    {$ENDIF}
  {$ENDIF}
  begin
    nStr := '车辆未停到位,请移动车辆.';
    WriteSysLog(nStr);
    PlayVoice(nStr);

    InitSamples;
    Exit;
  end;
  {$ENDIF}

  FIsSaving := True;
  if (FCardUsed = sFlag_Provide) or (FCardUsed = sFlag_Mul) then
       nRet := SavePoundData
  else nRet := SavePoundSale;

  if nRet then
  begin
    nStr := GetTruckNO(FUIData.FTruck) + '重量  ' + GetValue(nValue);
    WriteSysLog(nStr);
    for nIdx := 1 to 3 do
    begin
      {$IFDEF MITTruckProber}
      ProberShowTxt(FPoundTunnel.FID, nStr);
      {$ELSE}
      gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
      {$ENDIF}
    end;
    TimerDelay.Enabled := True;
  end else
  begin
    if not FSaveResult then
    begin
      nStr := GetTruckNO(FUIData.FTruck) + '数据保存失败';
      for nIdx := 1 to 3 do
      begin
        {$IFDEF MITTruckProber}
        ProberShowTxt(FPoundTunnel.FID, nStr);
        {$ELSE}
        gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
        {$ENDIF}
      end;

      with FUIData do
      begin
        nStr := '车辆[ %s ]数据保存失败,详情如下:' + #13#10 +
                '※.物料名称: [ %s ]' + #13#10 +
                '※.车辆重量: %s吨' + #13#10 +
                '请进行人工干预.';
        nStr := Format(nStr, [FTruck, FStockName, EditValue.Text]);

        if not VerifyManualEventRecord(FID + sFlag_ManualB, nStr) then
        begin
          AddManualEventRecord(FID + sFlag_ManualB, FTruck, nStr,
              sFlag_DepBangFang, sFlag_Solution_OK, sFlag_DepDaTing, True);
          WriteSysLog(nStr);
        end;
      end;
    end;

    Timer_SaveFail.Enabled := True;
  end;

  if FBarrierGate then
  begin
    nInt := 0;
    {$IFDEF DaiOpenBackWhenError}
    if (not nRet) and (FUIData.FType = sFlag_Dai) then
    begin
      nInt := 10;
      OpenDoorByReader(FLastReader, sFlag_Yes); //打开主道闸(后杆)
    end;
    {$ENDIF}

    {$IFDEF SaleOpenBackWhenError}
    if not nRet then
    begin
      nInt := 10;
      OpenDoorByReader(FLastReader, sFlag_Yes); //打开主道闸(后杆)
    end;
    {$ENDIF}

    if IsAsternStock(FUIData.FStockName) then
    begin
      nInt := 10;
      OpenDoorByReader(FLastReader, sFlag_Yes); //打开主道闸(后杆)
    end;

    if (nInt = 0) and FSaveResult then
      OpenDoorByReader(FLastReader, sFlag_No);
    //打开副道闸
  end;
end;

procedure TfFrameAutoPoundItem.TimerDelayTimer(Sender: TObject);
var nStr: string;
begin
  try
    TimerDelay.Enabled := False;
    WriteSysLog(Format('对车辆[ %s ]称重完毕.', [FUIData.FTruck]));

    FLastCard     := FCardTmp;
    FLastCardDone := GetTickCount;
    FDoneEmptyPoundInit := GetTickCount;
    //保存状态

    if (FCardUsed = sFlag_Sale) and (FUIData.FType = sFlag_San) and
       (FUIData.FNextStatus = sFlag_TruckBFM) then
    begin
      nStr := '车辆[n1]%s毛重[n2]%.2f吨[p500]净重[n2]%.2f吨,请下磅';
      nStr := Format(nStr, [FUIData.FTruck,
              Float2Float(FUIData.FMData.FValue, 1000),
              Float2Float(FUIData.FMData.FValue - FUIData.FPData.FValue, 1000)]);
      PlayVoice(nStr);
    end else PlayVoice(#9 + FUIData.FTruck);
    //播放语音

    if not FBarrierGate then
      FIsWeighting := False;
    //磅上无道闸时，即时过磅完毕

    {$IFNDEF DEBUG}
    {$IFDEF MITTruckProber}
    TunnelOC(FPoundTunnel.FID, True);
    {$ELSE}
    gProberManager.TunnelOC(FPoundTunnel.FID, True);
    {$ENDIF} //开红绿灯
    {$ENDIF}

    Timer2.Enabled := True;
    SetUIData(True);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化样本
procedure TfFrameAutoPoundItem.InitSamples;
var nIdx: Integer;
begin
  SetLength(FValueSamples, FPoundTunnel.FSampleNum);
  FSampleIndex := Low(FValueSamples);

  for nIdx:=High(FValueSamples) downto FSampleIndex do
    FValueSamples[nIdx] := 0;
  //xxxxx
end;

//Desc: 添加采样
procedure TfFrameAutoPoundItem.AddSample(const nValue: Double);
begin
  FValueSamples[FSampleIndex] := nValue;
  Inc(FSampleIndex);

  if FSampleIndex >= FPoundTunnel.FSampleNum then
    FSampleIndex := Low(FValueSamples);
  //循环索引
end;

//Desc: 验证采样是否稳定
function TfFrameAutoPoundItem.IsValidSamaple: Boolean;
var nIdx: Integer;
    nVal: Integer;
begin
  Result := False;

  for nIdx:=FPoundTunnel.FSampleNum-1 downto 1 do
  begin
    if FValueSamples[nIdx] < 0.02 then Exit;
    //样本不完整

    nVal := Trunc(FValueSamples[nIdx] * 1000 - FValueSamples[nIdx-1] * 1000);
    if Abs(nVal) >= FPoundTunnel.FSampleFloat then Exit;
    //浮动值过大
  end;

  Result := True;
end;

procedure TfFrameAutoPoundItem.PlayVoice(const nContent: string);
begin
  {$IFNDEF DEBUG}
  if (Assigned(FPoundTunnel.FOptions)) and
     (CompareText('NET', FPoundTunnel.FOptions.Values['Voice']) = 0) then
       gNetVoiceHelper.PlayVoice(nContent, FPoundTunnel.FID, 'pound')
  else gVoiceHelper.PlayVoice(nContent);
  {$ENDIF}
end;

procedure TfFrameAutoPoundItem.LEDDisplay(const nContent: string);
begin
  {$IFNDEF DEBUG}
  WriteSysLog(Format('LEDDisplay:%s.%s', [FPoundTunnel.FID, nContent]));
  if Assigned(FPoundTunnel.FOptions) And
     (UpperCase(FPoundTunnel.FOptions.Values['LEDEnable'])='Y') then
  begin
    if FLEDContent = nContent then Exit;
    FLEDContent := nContent;
    gDisplayManager.Display(FPoundTunnel.FID, nContent);
  end;
  {$ENDIF}
end;

procedure TfFrameAutoPoundItem.Timer_SaveFailTimer(Sender: TObject);
begin
  inherited;
  try
    FDoneEmptyPoundInit := GetTickCount;
    Timer_SaveFail.Enabled := False;
    SetUIData(True);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

procedure TfFrameAutoPoundItem.EditBillKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  try
    Key := #0;
    EditBill.Text := Trim(EditBill.Text);

    if FIsWeighting or EditBill.Properties.ReadOnly or
       (EditBill.Text = '') then
    begin
      SwitchFocusCtrl(ParentForm, True);
      Exit;
    end;

    {$IFDEF DEBUG}
    FCardTmp := EditBill.Text;
    LoadBillItems(EditBill.Text);
    {$ENDIF}
  finally
    EditBill.Enabled := True;
  end;
end;

procedure TfFrameAutoPoundItem.ckCloseAllClick(Sender: TObject);
var nP: TWinControl;
begin
  nP := Parent;

  if ckCloseAll.Checked then
  while Assigned(nP) do
  begin
    if (nP is TBaseFrame) and
       (TBaseFrame(nP).FrameID = cFI_FramePoundAuto) then
    begin
      TBaseFrame(nP).Close();
      Exit;
    end;

    nP := nP.Parent;
  end;
end;

end.
