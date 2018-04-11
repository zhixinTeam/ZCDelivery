{*******************************************************************************
  作者: dmzn@163.com 2010-3-14
  描述: 车辆进厂
*******************************************************************************}
unit UFormTruckIn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, cxTextEdit,
  cxListView, cxMCListBox, dxLayoutControl, StdCtrls;

type
  TfFormTruckIn = class(TfFormNormal)
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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBillSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListInfoClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
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
  USysBusiness, USysDB, USysConst;

var
  gCardUsed: string;
  gBills: TLadingBillItems;
  //提货单列表

class function TfFormTruckIn.FormID: integer;
begin
  Result := cFI_FormTruckIn;
end;

class function TfFormTruckIn.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr,nHint: string;
    nIdx: Integer;
    nRet: Boolean;
begin
  Result := nil;
  nStr := '';

  while True do
  begin
    if not ShowInputBox('请输入提货磁卡号:', '进厂', nStr) then Exit;
    nStr := Trim(nStr);

    if nStr = '' then Continue;

    gCardUsed := GetCardUsed(nStr);
    if (gCardUsed = sFlag_Provide) or (gCardUsed = sFlag_Mul) then
         nRet := GetPurchaseOrders(nStr, sFlag_TruckIn, gBills)
    else nRet := GetLadingBills(nStr, sFlag_TruckIn, gBills);

    if nRet and (Length(gBills)>0) then Break;
  end;

  nHint := '';
  for nIdx:=Low(gBills) to High(gBills) do
  if gBills[nIdx].FStatus <> sFlag_TruckNone then
  begin
    nStr := '※.单号:[ %s ] 状态:[ %-6s -> %-6s ]   ';
    if nIdx < High(gBills) then nStr := nStr + #13#10;

    nStr := Format(nStr, [gBills[nIdx].FID,
            TruckStatusToStr(gBills[nIdx].FStatus),
            TruckStatusToStr(gBills[nIdx].FNextStatus)]);
    nHint := nHint + nStr;
  end;

  if nHint <> '' then
  begin
    nHint := '该车辆当前不能进厂,详情如下: ' + #13#10#13#10 + nHint;
    ShowDlg(nHint, sHint);
    Exit;
  end;

  with TfFormTruckIn.Create(Application) do
  begin
    Caption := '车辆进厂';
    InitFormData;
    ShowModal;
    Free;
  end;
end;

procedure TfFormTruckIn.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
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

procedure TfFormTruckIn.FormClose(Sender: TObject;
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
procedure TfFormTruckIn.InitFormData;
var nIdx: Integer;
begin
  ListBill.Clear;

  for nIdx:=Low(gBills) to High(gBills) do
  with ListBill.Items.Add,gBills[nIdx] do
  begin
    if (gCardUsed = sFlag_Provide) then
         Caption := FZhiKa
    else Caption := FID;
    SubItems.Add(Format('%.3f', [FValue]));
    SubItems.Add(FStockName);

    ImageIndex := 11;
    Data := Pointer(nIdx);
  end;

  ListBill.ItemIndex := 0;
end;

procedure TfFormTruckIn.ListBillSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var nIdx: Integer;
begin
  if Selected and Assigned(Item) then
  begin
    nIdx := Integer(Item.Data);


    with gBills[nIdx] do
    begin
      if (gCardUsed = sFlag_Provide) then
      begin
        LayItem1.Caption := '采购单号:';
        EditBill.Text := FZhiKa;

        //LoadOrderItemToMC(gBills[nIdx], ListInfo.Items, ListInfo.Delimiter);
      end
      else
      if (gCardUsed = sFlag_Mul) then
      begin
        LayItem1.Caption := '采购单号:';
        EditBill.Text := FID;

        LoadOrderItemToMC(gBills[nIdx], ListInfo.Items, ListInfo.Delimiter);
      end
      else
      begin
        LayItem1.Caption := '交货单号:';
        EditBill.Text := FID;

        LoadBillItemToMC(gBills[nIdx], ListInfo.Items, ListInfo.Delimiter);
      end;

      EditCus.Text := FCusName;
    end;
  end;
end;

procedure TfFormTruckIn.ListInfoClick(Sender: TObject);
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

procedure TfFormTruckIn.BtnOKClick(Sender: TObject);
var nRet: Boolean;
begin
  if (gCardUsed = sFlag_Provide) or (gCardUsed = sFlag_Mul) then
       nRet := SavePurchaseOrders(sFlag_TruckIn, gBills)
  else nRet := SaveLadingBills(sFlag_TruckIn, gBills);

  if nRet then
  begin
    ShowMsg('车辆进厂成功', sHint);
    ModalResult := mrOk;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTruckIn, TfFormTruckIn.FormID);
end.
