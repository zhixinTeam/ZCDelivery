{*******************************************************************************
  作者: dmzn@163.com 2017-09-27
  描述: 开提货单
*******************************************************************************}
unit UFormGetZhiKa;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UBusinessConst, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMCListBox,
  dxLayoutControl, StdCtrls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, ADODB, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Menus, cxButtons, DateUtils;

type
  TfFormGetZhiKa = class(TfFormNormal)
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    GridOrders: TcxGrid;
    dxLayout1Item3: TdxLayoutItem;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    EditCus: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxView1Column1: TcxGridDBColumn;
    cxView1Column2: TcxGridDBColumn;
    cxView1Column3: TcxGridDBColumn;
    cxView1Column4: TcxGridDBColumn;
    cxView1Column5: TcxGridDBColumn;
    cxView1Column6: TcxGridDBColumn;
    cxView1Column7: TcxGridDBColumn;
    cxView1Column8: TcxGridDBColumn;
    cxView1Column9: TcxGridDBColumn;
    cxView1Column10: TcxGridDBColumn;
    cxView1Column11: TcxGridDBColumn;
    cxView1Column12: TcxGridDBColumn;
    cxView1Column13: TcxGridDBColumn;
    cxView1Column14: TcxGridDBColumn;
    cxView1Column15: TcxGridDBColumn;
    cxView1Column16: TcxGridDBColumn;
    EditCusList: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    BtnSearch: TcxButton;
    dxLayout1Item6: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditCusPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditCusListPropertiesChange(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
  protected
    { Private declarations }
    FListA: TStrings;
    FBillItem: PLadingBillItem;
    //订单数据
    procedure InitFormData(const nCusName: string);
    //初始化
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst,
  USysBusiness, UBusinessPacker;

class function TfFormGetZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormGetZhiKa.Create(Application) do
  try
    Caption := '销售订单';
    FBillItem := nP.FParamE;
    {$IFDEF SyncDataByDataBase}
    if not GetHhSalePlan('') then
    begin
      ShowMsg('获取销售计划失败',sHint);
      Exit;
    end;

    InitFormData('');
    {$ENDIF}

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormGetZhiKa.FormID: integer;
begin
  Result := cFI_FormGetZhika;
end;

procedure TfFormGetZhiKa.FormCreate(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  FListA := TStringList.Create;
  dxGroup1.AlignVert := avClient;
  LoadFormConfig(Self);

  for nIdx:=0 to cxView1.ColumnCount-1 do
    cxView1.Columns[nIdx].Tag := nIdx;
  InitTableView(Name, cxView1);

  {$IFDEF UseWXERP}
    dxLayout1Item4.Visible := False;
    dxLayout1Item5.Visible := True;
    dxLayout1Item6.Visible := True;
  {$ELSE}
    {$IFDEF SyncDataByWSDL}
    dxLayout1Item4.Visible := False;
    dxLayout1Item5.Visible := True;
    dxLayout1Item6.Visible := True;
    {$ELSE}
    dxLayout1Item4.Visible := True;
    dxLayout1Item5.Visible := False;
    dxLayout1Item6.Visible := False;
    {$ENDIF}
  {$ENDIF}
end;

procedure TfFormGetZhiKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(FListA);
  SaveFormConfig(Self);
  SaveUserDefineTableView(Name, cxView1);
end;

//------------------------------------------------------------------------------
procedure TfFormGetZhiKa.InitFormData(const nCusName: string);
var nStr: string;
begin
  nStr := 'Select * From %s Where O_Valid=''%s'' and O_PlanRemain > 0 ';
  nStr := Format(nStr, [sTable_SalesOrder, sFlag_Yes]);
  
  if nCusName <> '' then
    nStr := nStr + ' And (' + nCusName + ')';
  FDM.QueryData(ADOQuery1, nStr);

  if ADOQuery1.Active and (ADOQuery1.RecordCount = 1) then
  begin
    ActiveControl := BtnOK;
  end else
  begin
    {$IFDEF UseWXERP}
      ActiveControl := EditCusList;
      EditCusList.SelectAll;
    {$ELSE}
      {$IFDEF SyncDataByWSDL}
      ActiveControl := EditCusList;
      EditCusList.SelectAll;
      {$ELSE}
      ActiveControl := EditCus;
      EditCus.SelectAll;
      {$ENDIF}
    {$ENDIF}
  end;
end;

procedure TfFormGetZhiKa.EditCusPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr,nWhere: string;
    nIdx: Integer;
begin
  if AButtonIndex = 1 then
  begin
    InitFormData('');
    ShowMsg('刷新成功', sHint);
    Exit;
  end;

  EditCus.Text := Trim(EditCus.Text);
  if EditCus.Text = '' then
  begin
    ShowMsg('请输入客户名称', sHint);
    Exit;
  end;

  SplitStr(EditCus.Text, FListA, 0, #32);
  if FListA.Count > 1 then
   for nIdx:=FListA.Count-1 downto 0 do
    if Trim(FListA[nIdx]) = '' then FListA.Delete(nIdx);
  //清理空参数

  nWhere := '';
  if FListA.Count > 0 then
  begin
    nStr := 'O_CusName Like ''%%%s%%'' Or O_CusPY Like ''%%%s%%''';
    nWhere := Format(nStr, [FListA[0], FListA[0]]);
  end; //客户名

  if FListA.Count > 1 then
  begin
    nStr := ' And O_StockName Like ''%%%s%%''';
    nWhere := nWhere + Format(nStr, [FListA[1]]);
  end; //品种名

  if FListA.Count > 2 then
  begin
    if CompareText(FListA[2], 'D') = 0 then
         nStr := '袋装'
    else nStr := '散装';

    nStr := Format(' And O_StockType=''%s''', [nStr]);
    nWhere := nWhere + nStr;
  end; //包装类型

  InitFormData(nWhere);
end;

procedure TfFormGetZhiKa.BtnOKClick(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount < 0 then
  begin
    ShowMsg('请选择订单', sHint);
    Exit;
  end;

  with ADOQuery1,FBillItem^ do
  begin
    FZhiKa       := FieldByName('O_Order').AsString;
    FType        := FieldByName('O_StockType').AsString;
    if Pos('袋' , FType) > 0 then
         FType := sFlag_Dai
    else FType := sFlag_San;
    {$IFDEF UseWXERP}
    FStockNo     := FieldByName('O_StockID').AsString;
    {$ELSE}
    FStockNo     := GetStockNo(FieldByName('O_StockName').AsString,
                               FType);
    {$ENDIF}
    FStockName   := FieldByName('O_StockName').AsString;
    FCusID       := '';
    FCusName     := FieldByName('O_CusName').AsString;

    {$IFDEF SyncDataByWSDL}//接口模式下开单即推单 订单量会实时扣减
    FValue       := FieldByName('O_PlanRemain').AsFloat;
    FCusID     := FieldByName('O_CusID').AsString;
    {$ELSE}
    FValue       := FieldByName('O_PlanRemain').AsFloat -
                    FieldByName('O_Freeze').AsFloat;
    {$ENDIF}
    FStatus      := '';
    FNextStatus  := FieldByName('O_Company').AsString;
    FPrice       := FieldByName('O_Price').AsFloat;
    FSaleMan     := FieldByName('O_SaleMan').AsString;
  end;

  ModalResult := mrOk;
end;

procedure TfFormGetZhiKa.EditCusListPropertiesChange(Sender: TObject);
var nIdx : Integer;
    nStr : string;
begin
  EditCusList.Properties.Items.Clear;
  nStr := 'Select C_Name From %s Where C_Name Like ''%%%s%%'' or C_PY Like ''%%%s%%'' ';
  nStr := Format(nStr, [sTable_Customer, EditCusList.Text, EditCusList.Text]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      try
        EditCusList.Properties.BeginUpdate;

        First;

        while not Eof do
        begin
          EditCusList.Properties.Items.Add(Fields[0].AsString);
          Next;
        end;
      finally
        EditCusList.Properties.EndUpdate;
      end;
    end;
  end;
  for nIdx := 0 to EditCusList.Properties.Items.Count - 1 do
  begin;
    if Pos(EditCusList.Text,EditCusList.Properties.Items.Strings[nIdx]) > 0 then
    begin
      EditCusList.SelectedItem := nIdx;
      Break;
    end;
  end;
end;

procedure TfFormGetZhiKa.BtnSearchClick(Sender: TObject);
var nStr, nCusID, nBeginDate, nEndDate: string;
begin
  {$IFDEF UseWXERP}
    GetLoginToken(gSysParam.FWXZhangHu,gSysParam.FWXMiMa);
    nStr := '';
    if Trim(EditCusList.Text) <> '' then
    begin
      nStr := Trim(EditCusList.Text);
    end;
    nStr := PackerEncodeStr(nStr);
    if not SyncWXSaleInfo(nStr) then
    begin
      ShowMsg('获取销售计划失败',sHint);
      Exit;
    end;
  {$ELSE}
    if EditCusList.Text = '' then
    begin
      nStr := '请选择客户';
      EditCusList.SetFocus;
      ShowMsg(nStr, sHint);
      Exit;
    end;
    nCusID := GetCusID(EditCusList.Text);
    if nCusID = '' then
    begin
      nStr := '未找到[ %s ]对应的客户ID';
      nStr := Format(nStr, [EditCusList.Text]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    nBeginDate := FormatDateTime('YYYY-MM-DD HH:MM:SS', IncMonth(Now, -2));
    nEndDate   := FormatDateTime('YYYY-MM-DD', IncDay(Now, -1)) + ' 00:00:00';

  {$IFDEF SaleFilterBeginDate}
  nStr := 'FCustomerID = ''%s'' and FStatus = ''1'' ' +
          'and FRemainAmount >= 0 and FBeginDate >= ''%s'' and FEndDate >= ''%s'' ';
  nStr := Format(nStr, [nCusID, nBeginDate, nEndDate]);
  {$ELSE}
  nStr := 'FCustomerID = ''%s'' and FStatus = ''1'' ' +
          'and FRemainAmount >= 0 ';
  nStr := Format(nStr, [nCusID]);
  {$ENDIF}

    nStr := PackerEncodeStr(nStr);
    if not GetHhSalePlanWSDL(nStr, '') then
    begin
      ShowMsg('获取销售计划失败',sHint);
      Exit;
    end;
  {$ENDIF}
  nStr := 'O_CusName Like ''%%%s%%'' Or O_CusPY Like ''%%%s%%''';
  nStr := Format(nStr, [EditCusList.Text, EditCusList.Text]);
  InitFormData(nStr);
end;

initialization
  gControlManager.RegCtrl(TfFormGetZhiKa, TfFormGetZhiKa.FormID);
end.
