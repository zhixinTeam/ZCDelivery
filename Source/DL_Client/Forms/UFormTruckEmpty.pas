{*******************************************************************************
  作者: fendou116688@163.com 2016/4/6
  描述: 空车出厂放行
*******************************************************************************}
unit UFormTruckEmpty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, cxTextEdit,
  cxListView, cxMCListBox, dxLayoutControl, StdCtrls;

type
  TfFormTruckEmpty = class(TfFormNormal)
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
  USysBusiness, USysDB, USysConst, UFormBase;

var
  gBills: TLadingBillItems;
  //提货单列表

class function TfFormTruckEmpty.FormID: integer;
begin
  Result := cFI_FormTruckEmpty;
end;

class function TfFormTruckEmpty.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
    nStr,nHint: string;
    nIdx: Integer;
    nRet: Boolean;
begin
  Result := nil;
  nStr := '';

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;

  while True do
  begin
    try
      CreateBaseFormItem(cFI_FormReadCard, nPopedom, nP);
      if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

      nStr := Trim(nP.FParamB);
      if nStr = '' then Continue;

      nRet := GetLadingBills(nStr, sFlag_TruckZT, gBills);
      if nRet and (Length(gBills)>0) then Break;
    finally
      if not Assigned(nParam) then Dispose(nP);
    end;
  end;

  nHint := '';
  for nIdx:=Low(gBills) to High(gBills) do
  if gBills[nIdx].FStatus = sFlag_TruckNone then
  begin
    nStr := '※.单号:[ %s ] 状态:[ %-6s -> %-6s ]   ';
    if nIdx < High(gBills) then nStr := nStr + #13#10;

    nStr := Format(nStr, [gBills[nIdx].FID,
            TruckStatusToStr(gBills[nIdx].FStatus),
            TruckStatusToStr(gBills[nIdx].FNextStatus)]);
    nHint := nHint + nStr;
  end else gBills[nIdx].FYSValid := sFlag_Yes;

  if nHint <> '' then
  begin
    nHint := '该车辆当前不能空车出厂,详情如下: ' + #13#10#13#10 + nHint;
    ShowDlg(nHint, sHint);
    Exit;
  end;

  with TfFormTruckEmpty.Create(Application) do
  begin
    Caption := '空车出厂';
    InitFormData;
    ShowModal;
    Free;
  end;
end;

procedure TfFormTruckEmpty.FormCreate(Sender: TObject);
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

procedure TfFormTruckEmpty.FormClose(Sender: TObject;
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
procedure TfFormTruckEmpty.InitFormData;
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
    Data := Pointer(nIdx);
  end;

  ListBill.ItemIndex := 0;
end;

procedure TfFormTruckEmpty.ListBillSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var nIdx: Integer;
begin
  if Selected and Assigned(Item) then
  begin
    nIdx := Integer(Item.Data);


    with gBills[nIdx] do
    begin
      LayItem1.Caption := '交货单号:';
      EditBill.Text := FID;
      EditCus.Text := FCusName;

      LoadBillItemToMC(gBills[nIdx], ListInfo.Items, ListInfo.Delimiter);
    end;
  end;
end;

procedure TfFormTruckEmpty.ListInfoClick(Sender: TObject);
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

procedure TfFormTruckEmpty.BtnOKClick(Sender: TObject);
var nRet: Boolean;
    nNext: String;
begin
  if gBills[0].FType = sFlag_Dai then
       nNext := sFlag_TruckZT
  else nNext := sFlag_TruckFH;

  nRet := SaveLadingBills(nNext, gBills);

  if nRet then
  begin
    ShowMsg('允许车辆空车出厂成功', sHint);
    ModalResult := mrOk;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTruckEmpty, TfFormTruckEmpty.FormID);
end.
