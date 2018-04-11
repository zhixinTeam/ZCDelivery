{*******************************************************************************
  作者: juner11212436@163.com 2017-12-28
  描述: 自助办卡窗口--单厂版
*******************************************************************************}
unit uZXNewPurchaseCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, Menus, StdCtrls, cxButtons, cxGroupBox,
  cxRadioGroup, cxTextEdit, cxCheckBox, ExtCtrls, dxLayoutcxEditAdapters,
  dxLayoutControl, cxDropDownEdit, cxMaskEdit, cxButtonEdit,
  USysConst, cxListBox, ComCtrls,Uszttce_api,Contnrs,UFormCtrl;

type
  TfFormNewPurchaseCard = class(TForm)
    editWebOrderNo: TcxTextEdit;
    labelIdCard: TcxLabel;
    btnQuery: TcxButton;
    PanelTop: TPanel;
    PanelBody: TPanel;
    dxLayout1: TdxLayoutControl;
    BtnOK: TButton;
    BtnExit: TButton;
    EditValue: TcxTextEdit;
    EditProv: TcxTextEdit;
    EditID: TcxTextEdit;
    EditProduct: TcxTextEdit;
    EditTruck: TcxButtonEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxGroupLayout1Group2: TdxLayoutGroup;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item9: TdxLayoutItem;
    dxlytmLayout1Item3: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxlytmLayout1Item12: TdxLayoutItem;
    dxLayout1Item8: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    pnlMiddle: TPanel;
    cxLabel1: TcxLabel;
    lvOrders: TListView;
    Label1: TLabel;
    btnClear: TcxButton;
    TimerAutoClose: TTimer;
    EditYear: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditModel: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    EditKD: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item6: TdxLayoutItem;
    chkIfPrint: TcxCheckBox;
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure editWebOrderNoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FSzttceApi:TSzttceApi; //发卡机驱动
    FAutoClose:Integer; //窗口自动关闭倒计时（分钟）
    FWebOrderIndex:Integer; //商城订单索引
    FWebOrderItems:array of stMallPurchaseItem; //商城订单数组
    FMaxQuantity:Double; //合同剩余量
    Fbegin:TDateTime;
    FProID: string;
    procedure InitListView;
    procedure SetControlsReadOnly;
    procedure Writelog(nMsg:string);
    function DownloadOrder(const nCard:string):Boolean;
    procedure AddListViewItem(var nWebOrderItem:stMallPurchaseItem);
    procedure LoadSingleOrder;
    function IsRepeatCard(const nWebOrderItem:string):Boolean;
    function CheckOrderValidate(var nWebOrderItem:stMallPurchaseItem):Boolean;
    function SaveBillProxy:Boolean;
    function SaveWebOrderMatch(const nBillID,nWebOrderID,nBillType:string):Boolean;
    function VerifyCtrl(Sender: TObject; var nHint: string): Boolean;
  public
    { Public declarations }
    procedure SetControlsClear;
    property SzttceApi:TSzttceApi read FSzttceApi write FSzttceApi;
  end;

var
  fFormNewPurchaseCard: TfFormNewPurchaseCard;

implementation
uses
  ULibFun,UBusinessPacker,USysLoger,UBusinessConst,UFormMain,USysBusiness,USysDB,
  UAdjustForm,UFormBase,UDataReport,UDataModule,NativeXml,UMgrK720Reader,UFormWait,
  DateUtils;
{$R *.dfm}

{ TfFormNewPurchaseCard }

procedure TfFormNewPurchaseCard.SetControlsClear;
var
  i:Integer;
  nComp:TComponent;
begin
  editWebOrderNo.Clear;
  for i := 0 to dxLayout1.ComponentCount-1 do
  begin
    nComp := dxLayout1.Components[i];
    if nComp is TcxTextEdit then
    begin
      TcxTextEdit(nComp).Clear;
    end;
  end;
end;

procedure TfFormNewPurchaseCard.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormNewPurchaseCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=  caFree;
  fFormNewPurchaseCard := nil;
end;

procedure TfFormNewPurchaseCard.btnClearClick(Sender: TObject);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  editWebOrderNo.Clear;
  ActiveControl := editWebOrderNo;
end;

procedure TfFormNewPurchaseCard.FormShow(Sender: TObject);
begin
  SetControlsReadOnly;
  btnOK.Enabled := False;
  EditTruck.Properties.Buttons[0].Visible := False;

  FAutoClose := gSysParam.FAutoClose_Mintue;
  TimerAutoClose.Interval := 60*1000;
  TimerAutoClose.Enabled := True;
end;

procedure TfFormNewPurchaseCard.TimerAutoCloseTimer(Sender: TObject);
begin
  if FAutoClose=0 then
  begin
    TimerAutoClose.Enabled := False;
    Close;
  end;
  Dec(FAutoClose);
end;

procedure TfFormNewPurchaseCard.btnQueryClick(Sender: TObject);
var
  nCardNo,nStr:string;
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  btnQuery.Enabled := False;
  try
    nCardNo := Trim(editWebOrderNo.Text);
    if nCardNo='' then
    begin
      nStr := '请先输入或扫描货单号';
      ShowMsg(nStr,sHint);
      Writelog(nStr);
      Exit;
    end;
    lvOrders.Items.Clear;
    if not DownloadOrder(nCardNo) then Exit;
    btnOK.Enabled := True;
  finally
    btnQuery.Enabled := True;
  end;
end;

procedure TfFormNewPurchaseCard.BtnOKClick(Sender: TObject);
begin
  BtnOK.Enabled := False;
  try
    if not SaveBillProxy then Exit;
    Close;
  finally
    BtnOK.Enabled := True;
  end;
end;

procedure TfFormNewPurchaseCard.InitListView;
var
  col:TListColumn;
begin
  lvOrders.ViewStyle := vsReport;
  col := lvOrders.Columns.Add;
  col.Caption := '商城货单编号';
  col.Width := 270;

  col := lvOrders.Columns.Add;
  col.Caption := '合同编号';
  col.Width := 150;

  col := lvOrders.Columns.Add;
  col.Caption := '物料名称';
  col.Width := 200;

  col := lvOrders.Columns.Add;
  col.Caption := '供货车辆';
  col.Width := 200;

  col := lvOrders.Columns.Add;
  col.Caption := '办理吨数';
  col.Width := 150;
end;

procedure TfFormNewPurchaseCard.SetControlsReadOnly;
var
  i:Integer;
  nComp:TComponent;
begin
  for i := 0 to dxLayout1.ComponentCount-1 do
  begin
    nComp := dxLayout1.Components[i];
    if nComp is TcxTextEdit then
    begin
      TcxTextEdit(nComp).Properties.ReadOnly := True;
    end;
  end;
end;

procedure TfFormNewPurchaseCard.FormCreate(Sender: TObject);
begin
  if not Assigned(FDR) then
  begin
    FDR := TFDR.Create(Application);
  end;
  editWebOrderNo.Properties.MaxLength := gSysParam.FWebOrderLength;
  InitListView;
  gSysParam.FUserID := 'AICM';
end;

procedure TfFormNewPurchaseCard.Writelog(nMsg: string);
var
  nStr:string;
begin
  nStr := 'weborder[%s]contractcode[%s]provname[%s]productname[%s]:';
  nStr := Format(nStr,[editWebOrderNo.Text,EditID.Text,EditProv.Text,EditProduct.Text]);
  gSysLoger.AddLog(nStr+nMsg);
end;

function TfFormNewPurchaseCard.DownloadOrder(const nCard: string): Boolean;
var
  nXmlStr,nData:string;
  nListA,nListB:TStringList;
  i:Integer;
  nWebOrderCount:Integer;
begin
  Result := False;
  FWebOrderIndex := 0;
  nXmlStr := PackerEncodeStr(nCard);

  FBegin := now;
  nData := get_shopPurchaseByno(nXmlStr);
  if nData='' then
  begin
    ShowMsg('未查询到网上商城货单详细信息，请检查货单号是否正确',sHint);
    Writelog('未查询到网上商城货单详细信息，请检查货单号是否正确');
    Exit;
  end;

  Writelog('TfFormNewPurchaseCard.DownloadOrder(nCard='''+nCard+''') 查询商城订单-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  //解析网城订单信息
  Writelog('get_shopPurchaseByno res:'+nData);
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := nData;

    nWebOrderCount := nListA.Count;
    SetLength(FWebOrderItems,nWebOrderCount);
    for i := 0 to nWebOrderCount-1 do
    begin
      nListB.Text := PackerDecodeStr(nListA.Strings[i]);
      FWebOrderItems[i].FOrder_id := nListB.Values['ordernumber'];
      FWebOrderItems[i].Fpurchasecontract_no := nListB.Values['fac_order_no'];
      FWebOrderItems[i].FgoodsID := nListB.Values['goodsID'];
      FWebOrderItems[i].FGoodsname := nListB.Values['goodsname'];
      FWebOrderItems[i].FData := nListB.Values['data'];
      FWebOrderItems[i].Ftracknumber := nListB.Values['tracknumber'];
      AddListViewItem(FWebOrderItems[i]);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;
  LoadSingleOrder;
end;

procedure TfFormNewPurchaseCard.AddListViewItem(
  var nWebOrderItem: stMallPurchaseItem);
var
  nListItem:TListItem;
begin
  nListItem := lvOrders.Items.Add;
  nlistitem.Caption := nWebOrderItem.FOrder_id;

  nlistitem.SubItems.Add(nWebOrderItem.Fpurchasecontract_no);
  nlistitem.SubItems.Add(nWebOrderItem.FGoodsname);
  nlistitem.SubItems.Add(nWebOrderItem.Ftracknumber);
  nlistitem.SubItems.Add(nWebOrderItem.FData);
end;

procedure TfFormNewPurchaseCard.LoadSingleOrder;
var
  nOrderItem:stMallPurchaseItem;
  nRepeat:Boolean;
  nWebOrderID,nModel,nYear,nKD,nProName:string;
  nMsg:string;
begin
  nOrderItem := FWebOrderItems[FWebOrderIndex];
  nWebOrderID := nOrderItem.FOrder_id;
  FBegin := now;
  nRepeat := IsRepeatCard(nWebOrderID);

  if nRepeat then
  begin
    nMsg := '此货单已成功办卡，请勿重复操作';
    ShowMsg(nMsg,sHint);
    Writelog(nMsg);
    Exit;
  end;

  //填充界面信息
  //基本信息
  EditID.Text := nOrderItem.Fpurchasecontract_no;
  EditProv.Text := nOrderItem.FProvName;
  EditProduct.Text := nOrderItem.FGoodsname;
  //货单信息
  EditTruck.Text := nOrderItem.Ftracknumber;
  EditValue.Text := nOrderItem.FData;

  FWebOrderItems[FWebOrderIndex] := nOrderItem;
  if not GetOrderOtherInfo(EditID.Text,nModel,nYear,nKD,FProID,nProName) then
  begin
    ShowMsg('查询订单附加信息失败',sHint);
    nRepeat := False;
  end;

  if nYear = '' then
  begin
    ShowMsg('查询订单附加信息失败',sHint);
    nRepeat := False;
  end;

  EditModel.Text := nModel;
  EditYear.Text  := nYear;
  EditKD.Text    := nKD;
  EditProv.Text  := nProName;

  BtnOK.Enabled := not nRepeat;
end;

function TfFormNewPurchaseCard.IsRepeatCard(
  const nWebOrderItem: string): Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := 'select * from %s where WOM_WebOrderID=''%s'' ';
  nStr := Format(nStr,[sTable_WebOrderMatch,nWebOrderItem]);
  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount>0 then
    begin
      Result := True;
    end;
  end;
end;

function TfFormNewPurchaseCard.CheckOrderValidate(var nWebOrderItem: stMallPurchaseItem): Boolean;
var
  nStr:string;
  nwebOrderValue:Double;
  nMsg:string;
begin
  Result := False;

  //查询采购申请单
  nStr := 'select b_proid as provider_code,b_proname as provider_name,b_stockno as con_materiel_Code,b_restvalue as con_remain_quantity from %s where b_id=''%s''';
  nStr := Format(nStr,[sTable_OrderBase,nWebOrderItem.Fpurchasecontract_no]);
  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount<=0 then
    begin
      nMsg := '采购合同编号有误或采购合同已被删除[%s]。';
      nMsg := Format(nMsg,[nWebOrderItem.Fpurchasecontract_no]);
      ShowMsg(nMsg,sError);
      Writelog(nMsg);
      Exit;
    end;

    nWebOrderItem.FProvID := FieldByName('provider_code').AsString;
    nWebOrderItem.FProvName := FieldByName('provider_name').AsString;

    if nWebOrderItem.FGoodsID<>FieldByName('con_materiel_Code').AsString then
    begin
      nMsg := '商城货单中原材料[%s]有误。';
      nMsg := Format(nMsg,[nWebOrderItem.FGoodsname]);
      ShowMsg(nMsg,sError);
      Writelog(nMsg);
      Exit;
    end;

    nwebOrderValue := StrToFloatDef(nWebOrderItem.FData,0);
    FMaxQuantity := FieldByName('con_remain_quantity').AsFloat;

  //    if (nwebOrderValue<=0.00001) then
  //    begin
  //      nMsg := '货单中提货数量格式有误。';
  //      ShowMsg(nMsg,sError);
  //      Writelog(nMsg);
  //      Exit;
  //    end;

    if nwebOrderValue-FMaxQuantity>0.00001 then
    begin
      nMsg := '商城货单中提货数量有误，最多可提货数量为[%f]。';
      nMsg := Format(nMsg,[FMaxQuantity]);
      ShowMsg(nMsg,sError);
      Writelog(nMsg);
      Exit;
    end;
  end;
  Result := True;
end;

function TfFormNewPurchaseCard.SaveBillProxy: Boolean;
var
  nHint:string;
  nWebOrderID:string;
  nList: TStrings;
  nOrderItem:stMallPurchaseItem;
  nOrder:string;
  nNewCardNo:string;
  nidx:Integer;
  i:Integer;
  nRet:Boolean;
begin
  Result := False;
  nOrderItem := FWebOrderItems[FWebOrderIndex];
  nWebOrderID := editWebOrderNo.Text;

  if EditID.Text='' then
  begin
    ShowMsg('未查询网上货单',sHint);
    Writelog('未查询网上货单');
    Exit;
  end;

  if not VerifyCtrl(EditTruck,nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;

  if not VerifyCtrl(EditValue,nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;

  nNewCardNo := '';
  FBegin := Now;

  //连续三次读卡均失败，则回收卡片，重新发卡
  for i := 0 to 3 do
  begin
    for nIdx:=0 to 3 do
    if gMgrK720Reader.ReadCard(nNewCardNo) then Break
    else Sleep(500);
    //连续三次读卡,成功则退出。
    if nNewCardNo<>'' then Break;
    gMgrK720Reader.RecycleCard;
  end;

  if nNewCardNo = '' then
  begin
    ShowDlg('卡箱异常,请查看是否有卡.', sWarn, Self.Handle);
    Exit;
  end;

  nNewCardNo := gMgrK720Reader.ParseCardNO(nNewCardNo);
  WriteLog(nNewCardNo);
  //解析卡片
  writelog('TfFormNewPurchaseCard.SaveBillProxy 发卡机读卡-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');

  nList := TStringList.Create;
  try
    nList.Values['SQID'] := EditID.Text;
    nList.Values['Area'] := '';
    nList.Values['Truck'] := Trim(EditTruck.Text);
    nList.Values['Project'] := EditID.Text;
    nList.Values['CardType'] := 'L';

    nList.Values['ProviderID'] := FProID;
    nList.Values['ProviderName'] := EditProv.Text;
    nList.Values['StockNO'] := nOrderItem.FGoodsID;
    nList.Values['StockName'] := nOrderItem.FGoodsname;
    nList.Values['Value'] := EditValue.Text;
    nList.Values['Model'] := EditModel.Text;
    nList.Values['KD'] := EditKD.Text;
    nList.Values['Year'] := EditYear.Text;
    nList.Values['NeiDao'] := sFlag_No;
    nList.Values['OppositeValue'] := '0.00';
    nList.Values['expiretime'] := '0';
    if chkIfPrint.Checked then
      nList.Values['PrintBD'] := sFlag_Yes
    else
      nList.Values['PrintBD'] := sFlag_No;
    nList.Values['WebOrderID'] := nWebOrderID;

    FBegin := Now;
    nOrder := SaveOrder(PackerEncodeStr(nList.Text));
    if nOrder='' then
    begin
      nHint := '保存采购单失败';
      ShowMsg(nHint,sError);
      Writelog(nHint);
      Exit;
    end;
    writelog('TfFormNewPurchaseCard.SaveBillProxy 保存采购单-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');

    FBegin := Now;
    SaveWebOrderMatch(nOrder,nWebOrderID,sFlag_Provide);
    writelog('TfFormNewPurchaseCard.SaveBillProxy 保存商城订单号-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  finally
    nList.Free;
  end;

  ShowMsg('采购单保存成功', sHint);

  FBegin := Now;
  nRet := SaveOrderCard(nOrder,nNewCardNo);
  if nRet then
  begin
    nRet := False;
    for nIdx := 0 to 3 do
    begin
      nRet := gMgrK720Reader.SendReaderCmd('FC0');
      if nRet then Break;

      Sleep(500);
    end;
    //发卡
  end;

  if nRet then
  begin
    nHint := '商城货单号['+editWebOrderNo.Text+']发卡成功,卡号['+nNewCardNo+'],请收好您的卡片';
    WriteLog(nHint);
    ShowMsg(nHint,sWarn);
  end
  else begin
    gMgrK720Reader.RecycleCard;

    nHint := '商城货单号[%s]卡号 [%s] 关联采购订单 [%s] 失败，请到开票窗口重新关联。';
    nHint := Format(nHint,[editWebOrderNo.Text,nNewCardNo,nOrder]);
    Writelog(nHint);
    ShowMsg(nHint,sHint);
  end;
  writelog('TfFormNewPurchaseCard.SaveBillProxy 发卡机出卡并关联磁卡号-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  if nRet then Close;
end;

function TfFormNewPurchaseCard.SaveWebOrderMatch(const nBillID,
  nWebOrderID,nBillType: string): Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := MakeSQLByStr([
  SF('WOM_WebOrderID'   , nWebOrderID),
  SF('WOM_LID'          , nBillID),
  SF('WOM_StatusType'   , c_WeChatStatusCreateCard),
  SF('WOM_MsgType'      , cSendWeChatMsgType_AddBill),
  SF('WOM_BillType'     , nBillType),
  SF('WOM_deleted'     , sFlag_No)
  ], sTable_WebOrderMatch, '', True);
  fdm.ADOConn.BeginTrans;
  try
    fdm.ExecuteSQL(nStr);
    fdm.ADOConn.CommitTrans;
    Result := True;
  except
    fdm.ADOConn.RollbackTrans;
  end;
end;

function TfFormNewPurchaseCard.VerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
  nStr:string;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    if not Result then
    begin
      nHint := '车牌号长度应大于2位';
      Writelog(nHint);
      Exit;
    end;
  end;

  if Sender = EditValue then
  begin
//    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    Result := IsNumber(EditValue.Text, True);
    if not Result then
    begin
      nHint := '请填写有效的办理量';
      Writelog(nHint);
      Exit;
    end;
  end;
end;

procedure TfFormNewPurchaseCard.editWebOrderNoKeyPress(Sender: TObject;
  var Key: Char);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  if Key=Char(vk_return) then
  begin
    key := #0;
    btnQuery.Click;
  end;
end;

end.
