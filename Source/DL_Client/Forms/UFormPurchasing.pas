{*******************************************************************************
  作者: fendou116688@163.com 2015/8/8
  描述: 采购验收
*******************************************************************************}
unit UFormPurchasing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  USysBusiness, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, cxTextEdit,
  cxListView, cxMCListBox, dxLayoutControl, StdCtrls, cxCheckBox;

type
  TfFormPurchasing = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    ListInfo: TcxMCListBox;
    dxLayout1Item3: TdxLayoutItem;
    ListBill: TcxListView;
    dxLayout1Item7: TdxLayoutItem;
    EditCus: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditBill: TcxTextEdit;
    LayItem1: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditKZValue: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    YSValid: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBillSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListInfoClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditKZValuePropertiesEditValueChanged(Sender: TObject);
  protected
    { Protected declarations }
    FItemIndex: Integer;
    procedure InitFormData;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormInputbox, USysGrid, UBusinessConst,
  USysDB, USysConst;

var
  gBills: TLadingBillItems;
  //提货单列表

class function TfFormPurchasing.FormID: integer;
begin
  Result := cFI_FormPurchase;
end;

class function TfFormPurchasing.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr,nHint: string;
    nIdx,nInt: Integer;
begin
  Result := nil;
  nStr := '';

  while True do
  begin
    if not ShowInputBox('请输入采购磁卡号:', '现场验收', nStr) then Exit;
    nStr := Trim(nStr);

    if nStr = '' then Continue;
    if GetPurchaseOrders(nStr, sFlag_TruckXH, gBills) then Break;
  end;

  nInt := 0 ;
  nHint := '';

  for nIdx:=Low(gBills) to High(gBills) do
  with gBills[nIdx] do
  begin
    FSelected := (FNextStatus = sFlag_TruckXH) or (FNextStatus = sFlag_TruckBFM);
    if FSelected then
    begin
      Inc(nInt);
      Continue;
    end;

    nStr := '※.单号:[ %s ] 状态:[ %-6s -> %-6s ]   ';
    if nIdx < High(gBills) then nStr := nStr + #13#10;

    nStr := Format(nStr, [FID,
            TruckStatusToStr(FStatus), TruckStatusToStr(FNextStatus)]);
    nHint := nHint + nStr;
  end;

  if (nHint <> '') and (nInt = 0) then
  begin
    nHint := '该车辆当前不能验收,详情如下: ' + #13#10#13#10 + nHint;
    ShowDlg(nHint, sHint);
    Exit;
  end;

  with TfFormPurchasing.Create(Application) do
  begin
    Caption := '现场验收';
    InitFormData;
    ShowModal;
    Free;
  end;
end;

procedure TfFormPurchasing.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FItemIndex := -1;
  //xxxxx

  dxGroup1.AlignVert := avClient;
  dxLayout1Item3.AlignVert := avClient;
  //client align
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormPurchasing.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormPurchasing.InitFormData;
var nIdx: Integer;
begin
  ListBill.Clear;

  for nIdx:=Low(gBills) to High(gBills) do
  with ListBill.Items.Add,gBills[nIdx] do
  begin
    Caption := FID;
    SubItems.Add(Format('%.3f', [FValue]));
    SubItems.Add(FStockName);
    ImageIndex := 11;
    EditMemo.Text := FMemo;

    Data := Pointer(nIdx);
  end;

  ListBill.ItemIndex := 0;
end;

procedure TfFormPurchasing.ListBillSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var nIdx: Integer;
begin
  if Selected and Assigned(Item) then
  begin
    nIdx := Integer(Item.Data);
    LoadOrderItemToMC(gBills[nIdx], ListInfo.Items, ListInfo.Delimiter);

    with gBills[nIdx] do
    begin
      LayItem1.Caption := '派车单号:';
      EditBill.Text := FID;
      EditCus.Text := FCusName;

      EditKZValue.Text := FloatToStr(FKZValue);
      EditMemo.Text := FMemo;
      YSValid.Checked := FYSValid = sFlag_No;
    end;

    FItemIndex := nIdx;
  end;
end;

procedure TfFormPurchasing.ListInfoClick(Sender: TObject);
var nStr: string;
    nPos: Integer;
begin
  if ListInfo.ItemIndex > -1 then
  begin
    nStr := ListInfo.Items[ListInfo.ItemIndex];
    nPos := Pos(':', nStr);
    if nPos < 1 then Exit;

    LayItem1.Caption := Copy(nStr, 1, nPos);
    nPos := Pos(ListInfo.Delimiter, nStr);

    System.Delete(nStr, 1, nPos);
    EditBill.Text := Trim(nStr);
  end;
end;

procedure TfFormPurchasing.BtnOKClick(Sender: TObject);
begin
  with gBills[0] do
  begin
    if YSValid.Checked then
          FYSValid := sFlag_NO
    else  FYSValid := sFlag_Yes;
  end;

  if SavePurchaseOrders(sFlag_TruckXH, gBills) then
  begin
    ShowMsg('原材料验收成功', sHint);
    ModalResult := mrOk;
  end;
end;

procedure TfFormPurchasing.EditKZValuePropertiesEditValueChanged(
  Sender: TObject);
begin
  if (FItemIndex >= 0) and IsNumber(EditKZValue.Text, True) then
  begin
    gBills[FItemIndex].FKZValue := StrToFloatDef(EditKZValue.Text, 0);
    gBills[FItemIndex].FMemo := EditMemo.Text;

    if not (EditKZValue.IsFocused or EditMemo.IsFocused) then
      FItemIndex := -1;
    //xxxxx
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormPurchasing, TfFormPurchasing.FormID);
end.
