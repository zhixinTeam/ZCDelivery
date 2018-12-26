{*******************************************************************************
  作者: fendou116688@163.com 2015/9/19
  描述: 办理采购订单绑定磁卡
*******************************************************************************}
unit UFormPurchaseOrder;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxLabel,
  dxLayoutcxEditAdapters, cxCheckBox, cxCalendar;

type
  TfFormPurchaseOrder = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    EditValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditMate: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditID: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditProvider: TcxTextEdit;
    dxlytmLayout1Item3: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxlytmLayout1Item12: TdxLayoutItem;
    EditCardType: TcxComboBox;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    chkNeiDao: TcxCheckBox;
    dxLayout1Item6: TdxLayoutItem;
    editMemo: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    EditOppositeValue: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    dtexpiretime: TcxDateEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditShip: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    chkIfPrint: TcxCheckBox;
    dxLayout1Item13: TdxLayoutItem;
    EditModel: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditKD: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    EditYear: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditLadingKeyPress(Sender: TObject; var Key: Char);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditCardTypePropertiesChange(Sender: TObject);
  protected
    { Protected declarations }
    FCardData, FListA: TStrings;
    //卡片数据
    FNewBillID: string;
    //新提单号
    FBuDanFlag: string;
    //补单标记
    FYSTDList:TStrings;
    
    procedure InitFormData;
    //初始化界面
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, DB, IniFiles, UMgrControl, UAdjustForm, UFormBase, UBusinessPacker,
  UDataModule, USysBusiness, USysDB, USysGrid, USysConst,DateUtils;

var
  gForm: TfFormPurchaseOrder = nil;
  //全局使用

class function TfFormPurchaseOrder.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nP: PFormCommandParam;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;

  try
    CreateBaseFormItem(cFI_FormGetPOrderBase, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    nStr := nP.FParamB;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormPurchaseOrder.Create(Application) do
  try
    Caption := '开采购单';
    ActiveControl := EditTruck;

    FCardData.Text := PackerDecodeStr(nStr);
    InitFormData;

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;

      if FParamA = mrOK then
           FParamB := FNewBillID
      else FParamB := '';
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormPurchaseOrder.FormID: integer;
begin
  Result := cFI_FormOrder;
end;

procedure TfFormPurchaseOrder.FormCreate(Sender: TObject);
begin
  FListA    := TStringList.Create;
  FCardData := TStringList.Create;
  FYSTDList := TStringlist.Create;
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  dxLayout1Item7.Visible := False;
  chkIfPrint.Checked := True;
end;

procedure TfFormPurchaseOrder.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FListA.Free;
  FCardData.Free;
  FYSTDList.Free;
end;

//Desc: 回车键
procedure TfFormPurchaseOrder.EditLadingKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    if Sender = EditValue then
         BtnOK.Click
    else Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  if (Sender = EditTruck) and (Key = Char(VK_SPACE)) then
  begin
    Key := #0;
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
      EditTruck.Text := nP.FParamB;
    EditTruck.SelectAll;
  end;
end;

procedure TfFormPurchaseOrder.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nChar: Char;
begin
  nChar := Char(VK_SPACE);
  EditLadingKeyPress(EditTruck, nChar);
end;

//------------------------------------------------------------------------------
procedure TfFormPurchaseOrder.InitFormData;
begin
  with FCardData do
  begin
    EditID.Text       := Values['SQ_ID'];
    EditProvider.Text := Values['SQ_ProName'];
    EditMate.Text     := Values['SQ_StockName'];
//    EditValue.Text    := Values['SQ_RestValue'];
    EditValue.Text    := '50.00';
    editMemo.Text     := Values['SQ_Memo'];
    chkNeiDao.Checked := Pos('内倒',Values['SQ_PurchType']) > 0;
    chkNeiDao.Visible := False;
    EditModel.Text    := Values['SQ_Model'];
    EditKD.Text       := Values['SQ_KD'];
    EditYear.Text     := Values['SQ_Year'];
  end;
  if GetCardGInvalid then
  begin
    dtexpiretime.Date := IncSecond(date+1, -1);
    dxLayout1Item7.Visible := True;
  end
  else
  begin
    dtexpiretime.Date := IncYear(Now, 50);
    dxLayout1Item7.Visible := False;
  end;
  EditShip.Text := GetShipName(EditMate.Text);
end;

function TfFormPurchaseOrder.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nVal: Double;
  nStr:string;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '车牌号长度应大于2位';
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True);
    nHint := '请填写有效的办理量';
    if not Result then Exit;

//    nVal := StrToFloat(EditValue.Text);
//    Result := FloatRelation(nVal, StrToFloat(FCardData.Values['SQ_RestValue']),
//              rtLE);
//    nHint := '已超出剩余交货量';
  end;

//  if Sender = comboxYSTD then
//  begin
//    Result := comboxYSTD.ItemIndex >= 0;
//    nHint := '请选择验收通道';
//  end;

  nStr := 'select * from %s where isnull(o_card,'''')<>'''' and o_truck=''%s''';
  nStr := Format(nStr,[sTable_Order,EditTruck.Text]);
  if FDM.QuerySQL(nStr).RecordCount>0 then
  begin
    Result := False;
    nHint := '车辆 ['+EditTruck.Text+'] 已办理磁卡，请勿重复办理';
  end;
end;

//Desc: 保存
procedure TfFormPurchaseOrder.BtnOKClick(Sender: TObject);
var nOrder, nCardType: string;
begin
  if not IsDataValid then Exit;
  //check valid

  with FListA do
  begin
    Clear;
    Values['SQID']          := FCardData.Values['SQ_ID'];

    Values['Area']          := FCardData.Values['SQ_Area'];
    Values['Truck']         := Trim(EditTruck.Text);
    Values['Project']       := FCardData.Values['SQ_ID'];

    {$IFDEF GLPURCH}
    if gSysParam.FIsAdmin then
      nCardType               := GetCtrlData(EditCardType)
    else
      nCardType               := 'L';
    {$ELSE}
    nCardType               := GetCtrlData(EditCardType);
    {$ENDIF}
    Values['CardType']      := nCardType;

    Values['SaleID']        := FCardData.Values['SQ_SaleID'];
    Values['SaleMan']       := FCardData.Values['SQ_SaleName'];

    Values['ProviderID']    := FCardData.Values['SQ_ProID'];
    Values['ProviderName']  := FCardData.Values['SQ_ProName'];

    Values['StockNO']       := FCardData.Values['SQ_StockNo'];
    Values['StockName']     := FCardData.Values['SQ_StockName'];

    if nCardType='L' then
          Values['Value']   := EditValue.Text
    else  Values['Value']   := '0.00';
    Values['RecID']         := FCardData.Values['SQ_RecID'];
    if chkNeiDao.Checked then
      Values['NeiDao'] := sFlag_Yes
    else
      Values['NeiDao'] := sFlag_No;
    Values['OppositeValue'] := EditOppositeValue.Text;
    Values['expiretime'] := '0';

    if nCardType='G' then
    begin
      Values['expiretime'] := floatToStr(dtexpiretime.Date);
    end;
    Values['ShipName'] := EditShip.Text;
    Values['Model'] := EditModel.Text;
    Values['KD'] := EditKD.Text;
    Values['Year'] := EditYear.Text;
    Values['Memo'] := editMemo.Text;
    if chkIfPrint.Checked then
      Values['PrintBD'] := sFlag_Yes
    else
      Values['PrintBD'] := sFlag_No;
  end;

  nOrder := SaveOrder(PackerEncodeStr(FListA.Text));
  if nOrder='' then Exit;

  SetOrderCard(nOrder, FListA.Values['Truck'], True);
  //办理磁卡

  ModalResult := mrOK;
  ShowMsg('采购订单保存成功', sHint);
end;

procedure TfFormPurchaseOrder.EditCardTypePropertiesChange(
  Sender: TObject);
begin
  dxLayout1Item7.Visible := GetCtrlData(EditCardType)='G';
end;

initialization
  gControlManager.RegCtrl(TfFormPurchaseOrder, TfFormPurchaseOrder.FormID);
end.
