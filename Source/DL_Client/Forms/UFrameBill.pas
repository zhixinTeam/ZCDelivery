{*******************************************************************************
  作者: dmzn@163.com 2017-09-22
  描述: 开提货单
*******************************************************************************}
unit UFrameBill;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxCheckBox, cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameBill = class(TfFrameNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    Edit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N5: TMenuItem;
    dxLayout1Item10: TdxLayoutItem;
    CheckDelete: TcxCheckBox;
    N6: TMenuItem;
    N7: TMenuItem;
    N2: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N15: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure CheckDeleteClick(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //时间区间
    FUseDate: Boolean;
    //使用区间
    FPreFix: string;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure AfterInitFormData; override;
    {*查询SQL*}
    procedure SendMsgToWebMall(const nBillno:string);
    function ModifyWebOrderStatus(const nLId:string) : Boolean;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, UMgrRemotePrint, USysLoger,
  UBusinessPacker;

//------------------------------------------------------------------------------
class function TfFrameBill.FrameID: integer;
begin
  Result := cFI_FrameBill;
end;

procedure TfFrameBill.OnCreateFrame;
var nStr: string;
begin
  inherited;
  FPreFix := 'WY';
  nStr := 'Select B_Prefix From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    FPreFix := Fields[0].AsString;
  end;
  FUseDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameBill.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameBill.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  FEnableBackDB := True;

  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $Bill ' +
            ' Left Join $ZK on O_Order=L_ZhiKa ';
  //提货单

  if (nWhere = '') or FUseDate then
  begin
    Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')';
    nStr := ' And ';
  end else nStr := ' Where ';

  if nWhere <> '' then
    Result := Result + nStr + '(' + nWhere + ')';
  //xxxxx

  Result := MacroValue(Result, [MI('$ZK', sTable_SalesOrder),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx

  if CheckDelete.Checked then
       Result := MacroValue(Result, [MI('$Bill', sTable_BillBak)])
  else Result := MacroValue(Result, [MI('$Bill', sTable_Bill)]);
end;

procedure TfFrameBill.AfterInitFormData;
begin
  FUseDate := True;
end;

function TfFrameBill.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'L_Price';
end;

//Desc: 执行查询
procedure TfFrameBill.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FUseDate := Length(EditLID.Text) <= 3;
    FWhere := 'L_ID like ''%' + EditLID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FUseDate := Length(EditCard.Text) <= 3;
    FWhere := Format('L_Truck like ''%%%s%%''', [EditCard.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 未开始提货的提货单
procedure TfFrameBill.N4Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('(L_Status=''%s'')', [sFlag_BillNew]);
   20: FWhere := 'L_OutFact Is Null'
   else Exit;
  end;

  FUseDate := False;
  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameBill.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: 查询删除
procedure TfFrameBill.CheckDeleteClick(Sender: TObject);
begin
  InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: 开提货单
procedure TfFrameBill.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormBill, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 删除
procedure TfFrameBill.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := '确定要删除编号为[ %s ]的单据吗?';
  nStr := Format(nStr, [SQLQuery.FieldByName('L_ID').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;

  if DeleteBill(SQLQuery.FieldByName('L_ID').AsString) then
  begin
    InitFormData(FWhere);
    ShowMsg('提货单已删除', sHint);
    try
      SaveWebOrderDelMsg(SQLQuery.FieldByName('L_ID').AsString,sFlag_Sale);
    except
    end;
    //插入删除推送
  end;
end;

//Desc: 打印提货单
procedure TfFrameBill.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintBillReport(nStr, False);
  end;
end;

procedure TfFrameBill.PMenu1Popup(Sender: TObject);
begin
  //N2.Enabled := BtnEdit.Enabled;
  //修改车牌
  N6.Enabled := BtnEdit.Enabled;
  //修改卸货点
end;

//Desc: 修改未进厂车牌号
procedure TfFrameBill.N2Click(Sender: TObject);
var nStr,nTruck: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_Truck').AsString;
    nTruck := nStr;
    if not ShowInputBox('请输入新的车牌号码:', '修改', nTruck, 15) then Exit;

    if (nTruck = '') or (nStr = nTruck) then Exit;
    //无效或一致

    nStr := SQLQuery.FieldByName('L_ID').AsString;
    if ChangeLadingTruckNo(nStr, nTruck) then
    begin
      nStr := '修改车牌号[ %s -> %s ].';
      nStr := Format(nStr, [SQLQuery.FieldByName('L_Truck').AsString, nTruck]);
      FDM.WriteSysLog(sFlag_BillItem, SQLQuery.FieldByName('L_ID').AsString, nStr, False);

      InitFormData(FWhere);
      ShowMsg('车牌号修改成功', sHint);
    end;
  end;
end;

//Desc: 修改卸货点
procedure TfFrameBill.N6Click(Sender: TObject);
var nStr: string;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FParamA := SQLQuery.FieldByName('L_Unloading').AsString;
    CreateBaseFormItem(cFI_FormGetUnloading, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOk) then Exit;

    nStr := 'Update %s Set L_Unloading=''%s'' Where R_ID=%s';
    nStr := Format(nStr, [sTable_Bill, nP.FParamB,
            SQLQuery.FieldByName('R_ID').AsString]);
    //xxxxx

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
    ShowMsg('卸货点修改成功', sHint);
  end;
end;

procedure TfFrameBill.N15Click(Sender: TObject);
var nStr,nID: string;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要勘误的记录', sHint);
    Exit;
  end;

  if Pos(FPreFix,SQLQuery.FieldByName('L_ZhiKa').AsString) > 0 then
  begin
    ShowMsg('矿山外运业务请在(报表查询--矿山外运发货明细)进行勘误', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('L_ID').AsString;

  nList := TStringList.Create;
  try
    nList.Add(nID);

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;
    CreateBaseFormItem(cFI_FormSaleKw, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;

  finally
    nList.Free;
  end;

end;

procedure TfFrameBill.N7Click(Sender: TObject);
var nStr,nP: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要打印的记录', sHint);
    Exit;
  end;

  nStr := '是否在远程打印[ %s.%s ]单据?';
  nStr := Format(nStr, [SQLQuery.FieldByName('L_ID').AsString,
                        SQLQuery.FieldByName('L_Truck').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;

  if gRemotePrinter.RemoteHost.FPrinter = '' then
       nP := ''
  else nP := #9 + gRemotePrinter.RemoteHost.FPrinter;

  nStr := SQLQuery.FieldByName('L_ID').AsString + nP + #7 + sFlag_Sale;
  gRemotePrinter.PrintBill(nStr);
end;

procedure TfFrameBill.SendMsgToWebMall(const nBillno: string);
var
  nStr:string;
  nList: TStrings;
begin
  nList := TStringList.Create;
  try
    //加载提货单信息
    nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusName,L_Type,L_StockNo,' +
            'L_StockName,L_Truck,L_Value,L_Card,L_Price ' +
            'From $Bill b ';
    //xxxxx

    nStr := nStr + 'Where L_ID=''$CD''';

    nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$CD', nBillno)]);
    //xxxxx

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        nStr := '交货单[ %s ]已无效.';

        nStr := Format(nStr, [nBillno]);
        gSysLoger.AddLog(TfFrameBill,'SendMsgToWebMall',nStr);
        Exit;
      end;

      First;

      while not Eof do
      begin
        nList.Clear;

        nList.Values['CusID']      := FieldByName('L_CusID').AsString;
        nList.Values['MsgType']    := IntToStr(cSendWeChatMsgType_DelBill);
        nList.Values['BillID']     := FieldByName('L_ID').AsString;
        nList.Values['Card']       := FieldByName('L_Card').AsString;
        nList.Values['Truck']      := FieldByName('L_Truck').AsString;
        nList.Values['StockNo']    := FieldByName('L_StockNo').AsString;
        nList.Values['StockName']  := FieldByName('L_StockName').AsString;
        nList.Values['CusName']    := FieldByName('L_CusName').AsString;
        nList.Values['Value']      := FieldByName('L_Value').AsString;

        nStr := PackerEncodeStr(nList.Text);

        nStr := send_event_msg(nStr);
        gSysLoger.AddLog(TfFrameBill,'SendMsgToWebMall',nStr);

        Next;
      end;
    end;
  finally
    nList.Free;
  end;
end;

function TfFrameBill.ModifyWebOrderStatus(const nLId: string):Boolean;
var
  nWebOrderId:string;
  nXmlStr,nData,nSql:string;
  nList: TStrings;
begin
  Result := False;
  nList := TStringList.Create;

  try
    nWebOrderId := '';
    //查询网上商城订单
//    nSql := 'select WOM_WebOrderID from %s where WOM_LID=''%s''';
//    nSql := Format(nSql,[sTable_WebOrderMatch,nLId]);
    with FDM.QueryTemp(nSql) do
    begin
      if recordcount>0 then
      begin
        nWebOrderId := FieldByName('WOM_WebOrderID').asstring;
      end;
    end;
    if nWebOrderId='' then Exit;

    nList.Clear;
    nList.Values['WOM_WebOrderID'] := nWebOrderId;
    nList.Values['WOM_LID']:= nLId;
    nList.Values['WOM_StatusType']:= IntToStr(c_WeChatStatusDeleted);

    nXmlStr := PackerEncodeStr(nList.Text);

    nData := complete_shoporders(nXmlStr);
    gSysLoger.AddLog(TfFrameBill,'ModifyWebOrderStatus',nData);

    if nData <> sFlag_Yes then
    begin
      Exit;
    end;
    Result:= True;
  finally
    nList.Free;
  end;
end;

procedure TfFrameBill.N8Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintCNSReport(nStr, False);
  end;
end;

procedure TfFrameBill.N10Click(Sender: TObject);
var nStr,nID: string;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要修改的记录', sHint);
    Exit;
  end;

  if Length(SQLQuery.FieldByName('L_MValue').AsString) > 0 then
  begin
    ShowMsg('车辆已过毛重,请进行提货勘误', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('L_ID').AsString;

  nList := TStringList.Create;
  try
    nList.Add(nID);

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;
    CreateBaseFormItem(cFI_FormSaleModifyStock, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;

  finally
    nList.Free;
  end;
end;

procedure TfFrameBill.N12Click(Sender: TObject);
var nStr,nID: string;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要补单的记录', sHint);
    Exit;
  end;

  if Pos(FPreFix,SQLQuery.FieldByName('L_ZhiKa').AsString) <= 0 then
  begin
    ShowMsg('非矿山外运提货单,不能进行补单', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('L_ID').AsString;

  nList := TStringList.Create;
  try
    nList.Add(nID);

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;
    CreateBaseFormItem(cFI_FormSaleBuDanOther, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;

  finally
    nList.Free;
  end;
end;

procedure TfFrameBill.N13Click(Sender: TObject);
var nStr,nStatus: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要修改的记录', sHint);
    Exit;
  end;

  if Pos(FPreFix,SQLQuery.FieldByName('L_ZhiKa').AsString) <= 0 then
  begin
    ShowMsg('非矿山外运提货单,不能进行修改', sHint);
    Exit;
  end;

  nStr := '修改提货单当前状态[ %s -> %s ].确定要修改吗?';
  nStr := Format(nStr, [SQLQuery.FieldByName('L_Status').AsString, sFlag_TruckOut]);
  if not QueryDlg(nStr, sHint) then Exit;

  nStr := 'Update %s Set L_Status=''%s'',L_NextStatus='''' ' +
          'Where L_ID=''%s''';

  nStr := Format(nStr, [sTable_Bill, sFlag_TruckOut,
                        SQLQuery.FieldByName('L_ID').AsString]);
  FDM.ExecuteSQL(nStr);
  
  InitFormData(FWhere);
  ShowMsg('提货单状态修改成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameBill, TfFrameBill.FrameID);
end.
