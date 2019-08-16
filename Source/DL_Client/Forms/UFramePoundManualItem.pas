{*******************************************************************************
  作者: dmzn@163.com 2014-06-10
  描述: 手动称重通道项
*******************************************************************************}
unit UFramePoundManualItem;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrPoundTunnels, UBusinessConst, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Menus, ExtCtrls, cxCheckBox,
  StdCtrls, cxButtons, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLabel,
  ULEDFont, cxRadioGroup, UFrameBase;

type
  TfFrameManualPoundItem = class(TBaseFrame)
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
    BtnReadNumber: TcxButton;
    BtnReadCard: TcxButton;
    BtnSave: TcxButton;
    BtnNext: TcxButton;
    Timer1: TTimer;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
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
    procedure Timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure EditBillKeyPress(Sender: TObject; var Key: Char);
    procedure EditBillPropertiesEditValueChanged(Sender: TObject);
    procedure BtnReadNumberClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure RadioPDClick(Sender: TObject);
    procedure EditTruckKeyPress(Sender: TObject; var Key: Char);
    procedure EditMValuePropertiesEditValueChanged(Sender: TObject);
    procedure EditMIDPropertiesChange(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BtnReadCardClick(Sender: TObject);
  private
    { Private declarations }
    FCardUsed: string;
    //卡片类型
    FPoundTunnel: PPTTunnelItem;
    //磅站通道
    FLastGS,FLastBT,FLastBQ: Int64;
    //上次活动
    FBillItems: TLadingBillItems;
    FUIData,FInnerData: TLadingBillItem;
    //称重数据
    FListA: TStrings;
    //数据列表
    procedure InitUIData;
    procedure SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
    //界面数据
    procedure SetImageStatus(const nImage: TImage; const nOff: Boolean);
    //设置状态
    procedure SetTunnel(const nTunnel: PPTTunnelItem);
    //关联通道
    procedure OnPoundData(const nValue: Double);
    //读取磅重
    procedure LoadBillItems(const nCard: string);
    //读取交货单
    procedure LoadTruckPoundItem(const nTruck: string);
    //读取车辆称重
    function SavePoundSale: Boolean;
    function SavePoundData: Boolean;
    //保存称重     
    procedure PlayVoice(const nStrtext: string);
    //播放语音
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
  ULibFun, UAdjustForm, UFormBase, UMgrTruckProbe, UMgrRemoteVoice,
  UMgrVoiceNet, UDataModule, UFormWait, USysBusiness, USysConst, USysDB;

const
  cFlag_ON    = 10;
  cFlag_OFF   = 20;

class function TfFrameManualPoundItem.FrameID: integer;
begin
  Result := 0;
end;

procedure TfFrameManualPoundItem.OnCreateFrame;
begin
  inherited;
  FListA := TStringList.Create;

  FPoundTunnel := nil;
  InitUIData;
end;

procedure TfFrameManualPoundItem.OnDestroyFrame;
begin
  gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
  //关闭表头端口

  AdjustStringsItem(EditMID.Properties.Items, True);
  AdjustStringsItem(EditPID.Properties.Items, True);

  FListA.Free;
  inherited;
end;

//Desc: 设置运行状态图标
procedure TfFrameManualPoundItem.SetImageStatus(const nImage: TImage;
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

//------------------------------------------------------------------------------
//Desc: 初始化界面
procedure TfFrameManualPoundItem.InitUIData;
var nStr: string;
    nEx: TDynamicStrArray;
begin
  SetLength(nEx, 1);
  nStr := 'M_ID=Select M_ID,M_Name From %s Order By M_ID ASC';
  nStr := Format(nStr, [sTable_Materails]);

  nEx[0] := 'M_ID';
  FDM.FillStringsData(EditMID.Properties.Items, nStr, 0, '', nEx);
  AdjustCXComboBoxItem(EditMID, False);

  nStr := 'P_ID=Select P_ID,P_Name From %s Order By P_ID ASC';
  nStr := Format(nStr, [sTable_Provider]);
  
  nEx[0] := 'P_ID';
  FDM.FillStringsData(EditPID.Properties.Items, nStr, 0, '', nEx);
  AdjustCXComboBoxItem(EditPID, False);
end;

//Desc: 重置界面数据
procedure TfFrameManualPoundItem.SetUIData(const nReset,nOnlyData: Boolean);
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

    FCardUsed := '';

    FUIData := nItem;
    FInnerData := nItem;
    if nOnlyData then Exit;

    SetLength(FBillItems, 0);
    EditValue.Text := '0.00';
    EditBill.Properties.Items.Clear;

    gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
    //关闭表头端口
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

    BtnSave.Enabled := FTruck <> '';
    BtnReadCard.Enabled := FTruck = '';
    BtnReadNumber.Enabled := FTruck <> '';

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
procedure TfFrameManualPoundItem.LoadBillItems(const nCard: string);
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nBills: TLadingBillItems;
    nIsPreTruck:Boolean;
    nPrePValue: Double;
    nPrePMan: string;
    nPrePTime: TDateTime;
begin
  if nCard = '' then
  begin
    EditBill.SetFocus;
    EditBill.SelectAll;
    ShowMsg('请输入磁卡号', sHint); Exit;
  end;

  FCardUsed := GetCardUsed(nCard);
  if FCardUsed=sFlag_Mul then
  begin
    if not GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills) then
    begin
      SetUIData(True);
      Exit;
    end;
  end
  else
  begin
    if ((FCardUsed=sFlag_Provide) and (not GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills)))
      or
      ((FCardUsed <> sFlag_Provide) and (not GetLadingBills(nCard, sFlag_TruckBFP, nBills)))
    then
    begin
      SetUIData(True);
      Exit;
    end;
  end;

  nIsPreTruck := getPrePInfo(nBills[0].FTruck,nPrePValue,nPrePMan,nPrePTime);
  nHint := '';
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    if (FNextStatus=sFlag_TruckNone) and (FCardUsed=sFlag_Sale) then
    begin
      if SaveLadingBills(sFlag_TruckIn, nBills) then
      begin
        ShowMsg('车辆进厂成功', sHint);
        LoadBillItems(nCard);
        Exit;
      end else
      begin
        ShowMsg('车辆进厂失败', sHint);
        SetUIData(True);
        Exit;
      end;
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
        SetUIData(True);
        Exit;
      end;
    end;
    //长期卡+预置皮重
    if (FCtype=sFlag_CardGuDing) and nIsPreTruck then
    begin
      //皮重过期或皮重为0，则重新保存皮重
      if nPrePValue<0.00001 then
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
    else  if (FCardUsed=sFlag_Mul) and (FPoundIdx > 1) then
    begin
      getLastPInfo(nBills[0].FID,nPrePValue,nPrePMan,nPrePTime);
      with nBills[0] do
      begin
        FPData.FValue := nPrePValue;
        FPData.FOperator := nPrePMan;
        FPData.FDate := nPrePTime;
      end;
    end
    else begin
      if (FStatus <> sFlag_TruckBFP) and (FNextStatus = sFlag_TruckZT) then
        FNextStatus := sFlag_TruckBFP;
      //状态校正
    end;
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
  end;

  if nInt = 0 then
  begin
    nHint := '该车辆当前不能过磅,详情如下: ' + #13#10#13#10 + nHint;
    ShowDlg(nHint, sHint);
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

  if not FPoundTunnel.FUserInput then
    gPoundTunnelManager.ActivePort(FPoundTunnel.FID, OnPoundData, True);
  //xxxxx
end;

//Date: 2014-09-25
//Parm: 车牌号
//Desc: 读取nTruck的称重信息
procedure TfFrameManualPoundItem.LoadTruckPoundItem(const nTruck: string);
var nData: TLadingBillItems;
begin
  if nTruck = '' then
  begin
    EditTruck.SetFocus;
    EditTruck.SelectAll;
    ShowMsg('请输入车牌号', sHint); Exit;
  end;

  if not GetTruckPoundItem(nTruck, nData) then
  begin
    SetUIData(True);
    Exit;
  end;

  FInnerData := nData[0];   
  FUIData := FInnerData;
  SetUIData(False);

  if not FPoundTunnel.FUserInput then
    gPoundTunnelManager.ActivePort(FPoundTunnel.FID, OnPoundData, True);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 更新运行状态
procedure TfFrameManualPoundItem.Timer1Timer(Sender: TObject);
begin
  SetImageStatus(ImageGS, GetTickCount - FLastGS > 5 * 1000);
  SetImageStatus(ImageBT, GetTickCount - FLastBT > 5 * 1000);
  SetImageStatus(ImageBQ, GetTickCount - FLastBQ > 5 * 1000);
end;

//Desc: 关闭红绿灯
procedure TfFrameManualPoundItem.Timer2Timer(Sender: TObject);
begin
  Timer2.Tag := Timer2.Tag + 1;
  if Timer2.Tag < 10 then Exit;

  Timer2.Tag := 0;
  Timer2.Enabled := False;

  {$IFNDEF MITTruckProber}
  gProberManager.TunnelOC(FPoundTunnel.FID,False);
  {$ENDIF} //中间件华益驱动自带关闭功能
end;

//Desc: 表头数据
procedure TfFrameManualPoundItem.OnPoundData(const nValue: Double);
begin
  FLastBT := GetTickCount;
  EditValue.Text := Format('%.2f', [nValue]);
end;

//Desc: 设置通道
procedure TfFrameManualPoundItem.SetTunnel(const nTunnel: PPTTunnelItem);
begin
  FPoundTunnel := nTunnel;
  SetUIData(True);
end;

//Desc: 控制红绿灯
procedure TfFrameManualPoundItem.N1Click(Sender: TObject);
begin
  N1.Checked := not N1.Checked;
  //status change

  {$IFDEF MITTruckProber}
  TunnelOC(FPoundTunnel.FID, N1.Checked);
  {$ELSE}
  gProberManager.TunnelOC(FPoundTunnel.FID, N1.Checked);
  {$ENDIF}
end;

//Desc: 关闭称重页面
procedure TfFrameManualPoundItem.N3Click(Sender: TObject);
var nP: TWinControl;
begin
  nP := Parent;
  while Assigned(nP) do
  begin
    if (nP is TBaseFrame) and
       (TBaseFrame(nP).FrameID = cFI_FramePoundManual) then
    begin
      TBaseFrame(nP).Close();
      Exit;
    end;

    nP := nP.Parent;
  end;
end;

//Desc: 继续按钮
procedure TfFrameManualPoundItem.BtnNextClick(Sender: TObject);
begin
  SetUIData(True);
end;

procedure TfFrameManualPoundItem.EditBillKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if EditBill.Properties.ReadOnly then Exit;

    EditBill.Text := Trim(EditBill.Text);
    LoadBillItems(EditBill.Text);
  end;
end;

procedure TfFrameManualPoundItem.EditTruckKeyPress(Sender: TObject;
  var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;
    if EditTruck.Properties.ReadOnly then Exit;

    EditTruck.Text := Trim(EditTruck.Text);
    LoadTruckPoundItem(EditTruck.Text);
  end;

  if Key = Char(VK_SPACE) then
  begin
    Key := #0;
    if EditTruck.Properties.ReadOnly then Exit;
    
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
      EditTruck.Text := nP.FParamB;
    EditTruck.SelectAll;
  end;
end;

procedure TfFrameManualPoundItem.EditBillPropertiesEditValueChanged(
  Sender: TObject);
begin
  if EditBill.Properties.Items.Count > 0 then
  begin
    if EditBill.ItemIndex < 0 then
    begin
      EditBill.Text := FUIData.FID;
      Exit;
    end;

    with FBillItems[EditBill.ItemIndex] do
    begin
      if FUIData.FID = FID then Exit;
      //同单号
      
      FUIData.FID := FID;
      FUIData.FCusName := FCusName;
      FUIData.FStockName := FStockName;
    end;

    SetUIData(False);
    //ui
  end;
end;

//Desc: 读数
procedure TfFrameManualPoundItem.BtnReadNumberClick(Sender: TObject);
var nVal: Double;
begin
  if not IsNumber(EditValue.Text, True) then Exit;
  nVal := StrToFloat(EditValue.Text);

  if (Length(FBillItems) > 0) and (FCardUsed <> sFlag_Provide) and (FCardUsed <> sFlag_Mul) then
  begin
    if FBillItems[0].FNextStatus = sFlag_TruckBFP then
         FUIData.FPData.FValue := nVal
    else FUIData.FMData.FValue := nVal;
  end else
  begin
    if FInnerData.FPData.FValue > 0 then
    begin
      if nVal <= FInnerData.FPData.FValue then
      begin
        FUIData.FPData := FInnerData.FMData;
        FUIData.FMData := FInnerData.FPData;

        FUIData.FPData.FValue := nVal;
        FUIData.FNextStatus := sFlag_TruckBFP;
        //切换为称皮重
      end else
      begin
        FUIData.FPData := FInnerData.FPData;
        FUIData.FMData := FInnerData.FMData;

        FUIData.FMData.FValue := nVal;
        FUIData.FNextStatus := sFlag_TruckBFM;
        //切换为称毛重
      end;
    end else FUIData.FPData.FValue := nVal;
  end;

  SetUIData(False); 
end;

//Desc: 由读头指定交货单
procedure TfFrameManualPoundItem.BtnReadCardClick(Sender: TObject);
var nStr, nReader, nCard: string;
    nInit: Int64;
    nChar: Char;
begin
  nCard := '';
  try
    BtnReadCard.Enabled := False;
    nInit := GetTickCount;

    while GetTickCount - nInit < 5 * 1000 do
    begin
      ShowWaitForm(ParentForm, '正在读卡', False);
      nStr := ReadPoundCard(FPoundTunnel.FID, nReader);

      if nStr <> '' then
      begin
        nCard := nStr;
        Break;
      end else Sleep(1000);
    end;

    if nCard = '' then Exit;
    EditBill.Text := nCard;
    nChar := #13;
    EditBillKeyPress(nil, nChar);
  finally
    CloseWaitForm;
    if nCard = '' then
    begin
      BtnReadCard.Enabled := True;
      ShowMsg('没有读取成功,请重试', sHint);
    end;
  end;
end;

procedure TfFrameManualPoundItem.RadioPDClick(Sender: TObject);
begin
  if RadioPD.Checked then
    FUIData.FPModel := sFlag_PoundPD;
  if RadioCC.Checked then
    FUIData.FPModel := sFlag_PoundCC;
  if RadioLS.Checked then
    FUIData.FPModel := sFlag_PoundLS;
  //切换模式

  SetUIData(False);
end;

procedure TfFrameManualPoundItem.EditMValuePropertiesEditValueChanged(
  Sender: TObject);
var nVal: Double;
    nEdit: TcxTextEdit;
begin
  nEdit := Sender as TcxTextEdit;
  if not IsNumber(nEdit.Text, True) then Exit;
  nVal := StrToFloat(nEdit.Text);

  if Sender = EditPValue then
    FUIData.FPData.FValue := nVal;
  //xxxxx

  if Sender = EditMValue then
    FUIData.FMData.FValue := nVal;
  SetUIData(False);
end;

procedure TfFrameManualPoundItem.EditMIDPropertiesChange(Sender: TObject);
begin
  if Sender = EditMID then
  begin
    if not EditMID.Focused then Exit;
    //非操作人员调整
    EditMID.Text := Trim(EditMID.Text);

    if EditMID.ItemIndex < 0 then
    begin
      FUIData.FStockNo := '';
      FUIData.FStockName := EditMID.Text;
    end else
    begin
      FUIData.FStockNo := GetCtrlData(EditMID);
      FUIData.FStockName := EditMID.Text;
    end;
  end else

  if Sender = EditPID then
  begin
    if not EditPID.Focused then Exit;
    //非操作人员调整
    EditPID.Text := Trim(EditPID.Text);

    if EditPID.ItemIndex < 0 then
    begin
      FUIData.FCusID := '';
      FUIData.FCusName := EditPID.Text;
    end else
    begin
      FUIData.FCusID := GetCtrlData(EditPID);
      FUIData.FCusName := EditPID.Text;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 原材料或临时
function TfFrameManualPoundItem.SavePoundData: Boolean;
var nNextStatus: string;
    nIsPreTruck:Boolean;
    nPrePValue: Double;
    nPrePMan: string;
    nPrePTime: TDateTime;
begin
  Result := False;
  //init

  if (FUIData.FPData.FValue <= 0) and (FUIData.FMData.FValue <= 0) then
  begin
    ShowMsg('请先称重', sHint);
    Exit;
  end;

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) then
  begin
    if FUIData.FPData.FValue > FUIData.FMData.FValue then
    begin
      ShowMsg('皮重应小于毛重', sHint);
      Exit;
    end;
  end;

  if (Length(FBillItems)>0) and ((FCardUsed = sFlag_Provide) or (FCardUsed = sFlag_Mul)) then
    nNextStatus := FBillItems[0].FNextStatus;

  SetLength(FBillItems, 1);
  FBillItems[0] := FUIData;
  //复制用户界面数据

  with FBillItems[0] do
  begin
    FFactory := gSysParam.FFactNum;
    //xxxxx
    nIsPreTruck := getPrePInfo(FTruck,nPrePValue,nPrePMan,nPrePTime);
    //长期卡+预置皮重
    if (FCtype=sFlag_CardGuDing) and nIsPreTruck then
    begin
      //皮重为0，则重新保存皮重
      if (StrToFloatDef(EditValue.Text,0) < GetPrePValueSet) then
      begin
        SaveTruckPrePValue(FTruck,EditValue.Text);
        UpdateTruckStatus(FUIData.FID);
        Exit;
      end;
    end;

    if FNextStatus = sFlag_TruckBFP then
         FPData.FStation := FPoundTunnel.FID
    else FMData.FStation := FPoundTunnel.FID;
  end;

  if (FCardUsed = sFlag_Provide) or (FCardUsed = sFlag_Mul) then
       Result := SavePurchaseOrders(nNextStatus, FBillItems,FPoundTunnel)
  else Result := SaveTruckPoundItem(FPoundTunnel, FBillItems);
  //保存称重
end;

//Desc: 保存销售
function TfFrameManualPoundItem.SavePoundSale: Boolean;
var nStr: string;
    nVal,nNet: Double;
begin
  Result := False;
  //init

  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
  begin
    if FUIData.FPData.FValue <= 0 then
    begin
      ShowMsg('请先称量皮重', sHint);
      Exit;
    end;

    nNet := GetTruckEmptyValue(FUIData.FTruck, FUIData.FType);
    nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

    if (nNet > 0) and (Abs(nVal) > gSysParam.FPoundSanF) then
    begin
      nStr := '车辆[ %s ]实时皮重误差较大,详情如下:' + #13#10#13#10 +
              '※.实时皮重: %.2f吨' + #13#10 +
              '※.历史皮重: %.2f吨' + #13#10 +
              '※.误差量: %.2f公斤' + #13#10#13#10 +
              '是否继续保存?';
      nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
              nNet, nVal]);
      if not QueryDlg(nStr, sAsk) then Exit;
    end;  
  end else
  begin
    if FUIData.FMData.FValue <= 0 then
    begin
      ShowMsg('请先称量毛重', sHint);
      Exit;
    end;
  end;

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) and
       (FUIData.FPModel <> sFlag_PoundCC) then //有净重,非出厂模式
  begin
    if FUIData.FPData.FValue > FUIData.FMData.FValue then
    begin
      ShowMsg('皮重应小于毛重', sHint);
      Exit;
    end;

    nNet := FUIData.FMData.FValue - FUIData.FPData.FValue;
    //净重
    nVal := nNet * 1000 - FInnerData.FValue * 1000;
    //与开票量误差(公斤)

    with gSysParam,FBillItems[0] do
    begin
      if FDaiPercent and (FType = sFlag_Dai) then
      begin
        if nVal > 0 then
             FPoundDaiZ := Float2Float(FInnerData.FValue * FPoundDaiZ_1 * 1000,
                                       cPrecision, False)
        else FPoundDaiF := Float2Float(FInnerData.FValue * FPoundDaiF_1 * 1000,
                                       cPrecision, False);
      end;

      if ((FType = sFlag_Dai) and (
          ((nVal > 0) and (FPoundDaiZ > 0) and (nVal > FPoundDaiZ)) or
          ((nVal < 0) and (FPoundDaiF > 0) and (-nVal > FPoundDaiF)))) or
         ((FType = sFlag_San) and (
          (nVal < 0) and (FPoundSanF > 0) and (-nVal > FPoundSanF))) then
      begin
        nStr := '车辆[ %s ]实际装车量误差较大,详情如下:' + #13#10#13#10 +
                '※.开单量: %.2f吨' + #13#10 +
                '※.装车量: %.2f吨' + #13#10 +
                '※.误差量: %.2f公斤';

        if FDaiWCStop and (FType = sFlag_Dai) then
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
      end;

      if (FType = sFlag_San) and IsStrictSanValue and
         FloatRelation(FValue, nNet, rtLess, cPrecision) then
      begin
        nStr := '车辆[n1]%s[p500]净重[n2]%.2f吨[p500]开票量[n2]%.2f吨,请卸货';
        nStr := Format(nStr, [FTruck, Float2Float(nNet, cPrecision, True),
                Float2Float(FValue, cPrecision, True)]);

        ShowDlg(nStr, sHint);
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
      PlayVoice(nStr);
      Exit;
    end;

    nStr := '车辆[ %s ]正在空车出厂,详情如下:' + #13#10 +
            '※.单据号: %s' + #13#10 +
            '※.开单量: %.2f吨' + #13#10 +
            '※.净  重: %.2f公斤' + #13#10 +
            '请确认净重无误后,执行删单操作.';
    nStr := Format(nStr, [FTruck, FID, FValue, nNet]);

    AddManualEventRecord(FID + sFlag_ManualD, FTruck, nStr,
      sFlag_DepBangFang , sFlag_Solution_OK, sFlag_DepDaTing, True);
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
    Result := SaveLadingBills(FNextStatus, FBillItems, FPoundTunnel);
    //保存称重
  end;
end;

//Desc: 保存称重
procedure TfFrameManualPoundItem.BtnSaveClick(Sender: TObject);
var nBool: Boolean;
begin
  {$IFNDEF DEBUG}
  {$IFDEF MITTruckProber}
  if not IsTunnelOK(FPoundTunnel.FID) then
  {$ELSE}
  if not gProberManager.IsTunnelOK(FPoundTunnel.FID) then
  {$ENDIF}
  begin
    ShowMsg('车辆未站稳,请稍后', sHint);
    Exit;
  end;
  {$ENDIF}

  nBool := False;
  try
    BtnSave.Enabled := False;
    ShowWaitForm(ParentForm, '正在保存称重', True);

    if (Length(FBillItems) > 0) and (FCardUsed=sFlag_Sale) then
         nBool := SavePoundSale
    else nBool := SavePoundData;

    if nBool then
    begin
      PlayVoice(#9 + FUIData.FTruck);
      //播放语音

      Timer2.Enabled := True;

      {$IFNDEF DEBUG}
      {$IFDEF MITTruckProber}
      TunnelOC(FPoundTunnel.FID, True);
      {$ELSE}
      gProberManager.TunnelOC(FPoundTunnel.FID, True);
      {$ENDIF}
      {$ENDIF}

      //开红绿灯
      gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
      //关闭表头

      if (FUIData.FPoundID <> '') or RadioCC.Checked then
        PrintPoundReport(FUIData.FPoundID, True);
      //原料或出厂模式

      SetUIData(True);
      BroadcastFrameCommand(Self, cCmd_RefreshData);
      ShowMsg('称重保存完毕', sHint);
    end;
  finally
    BtnSave.Enabled := not nBool;
    CloseWaitForm;
  end;
end;

procedure TfFrameManualPoundItem.PlayVoice(const nStrtext: string);
begin
  if (Assigned(FPoundTunnel.FOptions)) and
     (CompareText('NET', FPoundTunnel.FOptions.Values['Voice']) = 0) then
       gNetVoiceHelper.PlayVoice(nStrtext, FPoundTunnel.FID, 'pound')
  else gVoiceHelper.PlayVoice(nStrtext);
end;

end.

