{*******************************************************************************
  作者: juner11212436@163.com 2018-03-23
  描述: 获取委托函车牌号
*******************************************************************************}
unit UFormGetWTTruck;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxCheckBox, Menus,
  cxLabel, cxListView, cxTextEdit, cxMaskEdit, cxButtonEdit,
  dxLayoutControl, StdCtrls;

type
  TfFormGetWTTruck = class(TfFormNormal)
    EditTruck: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListTruck: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListTruckKeyPress(Sender: TObject; var Key: Char);
    procedure ListTruckDblClick(Sender: TObject);
    procedure EditTruckPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    function QueryTruckFromERP(const nOrder: string): Boolean;
    //查询ERP委托车辆
    function QueryTruckFromWSDL(const nOrder: string): Boolean;
    //查询ERP委托车辆(调用接口)
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormBase, USysGrid, USysDB, USysConst,
  USysBusiness, UDataModule, UFormInputbox, UBusinessPacker;

class function TfFormGetWTTruck.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetWTTruck.Create(Application) do
  try
    Caption := '选择车辆';
    {N1.Enabled := gSysParam.FIsAdmin;
    N2.Enabled := N1.Enabled;
    N4.Enabled := N1.Enabled;
    N5.Enabled := N1.Enabled;}
    {$IFDEF SyncDataByWSDL}
    QueryTruckFromWSDL(nP.FParamA);
    {$ELSE}
    QueryTruckFromERP(nP.FParamA);
    {$ENDIF}
    
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin
      nP.FParamB := ListTruck.Items[ListTruck.ItemIndex].Caption;
      nP.FParamC := ListTruck.Items[ListTruck.ItemIndex].SubItems[0];
      nP.FParamD := ListTruck.Items[ListTruck.ItemIndex].SubItems[1];
    end;
  finally
    Free;
  end;
end;

class function TfFormGetWTTruck.FormID: integer;
begin
  Result := cFI_FormGetWTTruck;
end;

procedure TfFormGetWTTruck.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormGetWTTruck.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormGetWTTruck.ListTruckKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    if ListTruck.ItemIndex > -1 then
      ModalResult := mrOk;
    //xxxxx
  end;
end;

procedure TfFormGetWTTruck.ListTruckDblClick(Sender: TObject);
begin
  if ListTruck.ItemIndex > -1 then
    ModalResult := mrOk;
  //xxxxx
end;

procedure TfFormGetWTTruck.BtnOKClick(Sender: TObject);
begin
  if ListTruck.ItemIndex > -1 then
       ModalResult := mrOk
  else ShowMsg('请在查询结果中选择', sHint);
end;

function TfFormGetWTTruck.QueryTruckFromERP(const nOrder: string): Boolean;
var nStr, nQuery, nData: string;
    nIdx, nOrderCount: Integer;
    nListA, nListB: TStrings;
begin
  Result := False;
  ListTruck.Items.Clear;

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nStr := 'Select * From %s Where O_Order=''%s''';
    nStr := Format(nStr, [sTable_SalesOrder, nOrder]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount <= 0 then
      begin
        nStr := '未查询到订单[ %s ]信息';
        nStr := Format(nStr, [nOrder]);
        ShowMsg(nStr,sHint);
        Exit;
      end;
      nListA.Values['CusID'] := FieldByName('O_CusID').AsString;
      nListA.Values['CompanyID'] := FieldByName('O_CompanyID').AsString;
      nListA.Values['StockID'] := FieldByName('O_StockID').AsString;
      nListA.Values['PackingID'] := FieldByName('O_PackingID').AsString;
    end;

    nStr := PackerEncodeStr(nListA.Text);

    nData := GetHhSaleWTTruck(nStr);

    if nData = '' then
    begin
      nStr := '未查询到订单[ %s ]相关委托函信息';
      nStr := Format(nStr, [nOrder]);
      ShowMsg(nStr,sHint);
      Exit;
    end;

    nListA.Text := PackerDecodeStr(nData);
    nOrderCount := nListA.Count;
    for nIdx := 0 to nOrderCount-1 do
    begin
      nListB.Text := PackerDecodeStr(nListA.Strings[nIdx]);

      with ListTruck.Items.Add do
      begin
        Caption := nListB.Values['Truck'];
        SubItems.Add(nListB.Values['Value']);
        SubItems.Add(nListB.Values['FBillNumber']);
        ImageIndex := 11;
        StateIndex := ImageIndex;
      end;
    end;
    if ListTruck.Items.Count>0 then
    begin
      ActiveControl := ListTruck;
      ListTruck.ItemIndex := 0;
      ListTruck.ItemFocused := ListTruck.TopItem;
    end;
    Result := True;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

function TfFormGetWTTruck.QueryTruckFromWSDL(const nOrder: string): Boolean;
var nStr, nQuery, nData: string;
    nIdx, nOrderCount: Integer;
    nListA, nListB: TStrings;
begin
  Result := False;
  ListTruck.Items.Clear;

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nStr := 'Select * From %s Where O_Order=''%s''';
    nStr := Format(nStr, [sTable_SalesOrder, nOrder]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount <= 0 then
      begin
        nStr := '未查询到订单[ %s ]信息';
        nStr := Format(nStr, [nOrder]);
        ShowMsg(nStr,sHint);
        Exit;
      end;
      nListA.Values['CusID'] := FieldByName('O_CusID').AsString;
      nListA.Values['SaleManID'] := FieldByName('O_SaleMan').AsString;
      nListA.Values['StockID'] := FieldByName('O_StockID').AsString;
      nListA.Values['PackingID'] := FieldByName('O_PackingID').AsString;
    end;

    nStr := PackerEncodeStr(nListA.Text);

    nData := GetHhSaleWTTruckWSDL(nStr);

    if nData = '' then
    begin
      nStr := '未查询到订单[ %s ]相关委托函信息';
      nStr := Format(nStr, [nOrder]);
      ShowMsg(nStr,sHint);
      Exit;
    end;

    nListA.Text := PackerDecodeStr(nData);
    nOrderCount := nListA.Count;
    for nIdx := 0 to nOrderCount-1 do
    begin
      nListB.Text := PackerDecodeStr(nListA.Strings[nIdx]);

      with ListTruck.Items.Add do
      begin
        Caption := nListB.Values['FTransportation'];
        SubItems.Add(nListB.Values['FAmount']);
        SubItems.Add(nListB.Values['FScheduleVanID']);
        ImageIndex := 11;
        StateIndex := ImageIndex;
      end;
    end;
    if ListTruck.Items.Count>0 then
    begin
      ActiveControl := ListTruck;
      ListTruck.ItemIndex := 0;
      ListTruck.ItemFocused := ListTruck.TopItem;
    end;
    Result := True;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

procedure TfFormGetWTTruck.EditTruckPropertiesChange(Sender: TObject);
var nIdx : Integer;
begin
  if Trim(EditTruck.Text) = '' then
    Exit;
  for nIdx := 0 to ListTruck.Items.Count - 1 do
  begin;
    if Pos(EditTruck.Text,ListTruck.Items[nIdx].Caption) > 0 then
    begin
      ListTruck.ItemIndex := nIdx;
      Break;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormGetWTTruck, TfFormGetWTTruck.FormID);
end.
