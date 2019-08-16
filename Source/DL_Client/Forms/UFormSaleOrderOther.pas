{*******************************************************************************
  作者: dmzn@163.com 2016-10-26
  描述: 关联磁卡
*******************************************************************************}
unit UFormSaleOrderOther;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CPort, CPortTypes, UFormNormal, UFormBase, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit,
  dxLayoutControl, StdCtrls, cxGraphics, cxMemo, cxMaskEdit, cxDropDownEdit,
  cxCheckBox;

type
  TfFormSaleOrderOther = class(TfFormNormal)
    EditPAmount: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditFName: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Item7: TdxLayoutItem;
    EditMName: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item13: TdxLayoutItem;
    EditDAmount: TcxTextEdit;
    EditOID: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditSAmount: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    ChkValid: TcxCheckBox;
    dxLayout1Item11: TdxLayoutItem;
    EditCName: TcxComboBox;
    dxLayout1Item9: TdxLayoutItem;
    EditFAmount: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    BtnDone: TButton;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    BtnFreeze: TButton;
    dxLayout1Item16: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCNamePropertiesChange(Sender: TObject);
    procedure BtnDoneClick(Sender: TObject);
    procedure BtnFreezeClick(Sender: TObject);
  private
    { Private declarations }
    FParam: PFormCommandParam;
    FOldPAmount: string;
    //旧订单量
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
  IniFiles, ULibFun, UMgrControl, USysBusiness, USmallFunc, USysConst,USysDB,
  UDataModule, UFormCtrl;

class function TfFormSaleOrderOther.FormID: integer;
begin
  Result := CFI_FormSaleOrderOther;
end;

class function TfFormSaleOrderOther.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;

  with TfFormSaleOrderOther.Create(Application) do
  try
    FParam := nParam;
    InitFormData;

    FParam.FParamA := ShowModal;
    FParam.FCommand := cCmd_ModalResult;
  finally
    Free;
  end;
end;

procedure TfFormSaleOrderOther.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfFormSaleOrderOther.InitFormData;
var nStr: string;
begin
  ActiveControl := EditOID;
  with EditType.Properties do
  begin
    Items.Add('散装');
    Items.Add('包装');
    EditType.ItemIndex := 0;
  end;

  EditCName.Properties.Items.Clear;
  nStr := 'Select C_Name From %s Where C_Name is not null ';
  nStr := Format(nStr, [sTable_Customer]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      try
        EditCName.Properties.BeginUpdate;

        First;

        while not Eof do
        begin
          EditCName.Properties.Items.Add(Fields[0].AsString);
          Next;
        end;
      finally
        EditCName.Properties.EndUpdate;
      end;
    end;
  end;

  EditMName.Properties.Items.Clear;
  nStr := 'Select D_Value,D_Memo,D_ParamB From $Table ' +
          'Where D_Name=''$Name'' Order By D_Index ASC';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_StockItem)]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin

      First;

      while not Eof do
      begin
        EditMName.Properties.Items.Add(Fields[0].AsString);
        Next;
      end;
    end;
  end;

  if FParam.FCommand = cCmd_AddData then
  begin
    dxLayout1Item8.Visible := False;
  end else
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_SalesOrder, FParam.FParamA]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('数据丢失', sHint);
        BtnOK.Enabled := False;
        Exit;
      end;

      EditOID.Text := FieldByName('O_Order').AsString;
      EditOID.Properties.ReadOnly := True;
      EditCName.Text := FieldByName('O_CusName').AsString;

      EditMName.Text := FieldByName('O_StockName').AsString;

      EditFName.Text := FieldByName('O_Factory').AsString;

      if Pos('散',FieldByName('O_StockType').AsString) > 0 then
           EditType.ItemIndex := 0
      else EditType.ItemIndex := 1;

      EditPAmount.Text := FieldByName('O_PlanAmount').AsString;
      FOldPAmount      := FieldByName('O_PlanAmount').AsString;
      EditDAmount.Text := FieldByName('O_HasDone').AsString;
      EditFAmount.Text := FieldByName('O_Freeze').AsString;
    end;
  end;
end;

//Desc: 保存订单
procedure TfFormSaleOrderOther.BtnOKClick(Sender: TObject);
var nStr,nMType,nID,nValid,nEvent: string;
    nVal: Double;
begin
  EditFName.Text := Trim(EditFName.Text);
  if EditFName.Text = '' then
  begin
    ActiveControl := EditFName;

    ShowMsg('请输入生产场地', sHint);
    Exit;
  end;

  EditPAmount.Text := Trim(EditPAmount.Text);
  if not IsNumber(EditPAmount.Text,True) then
  begin
    ActiveControl := EditPAmount;
    EditPAmount.SelectAll;

    ShowMsg('请输入有效计划数量', sHint);
    Exit;
  end;

  EditDAmount.Text := Trim(EditDAmount.Text);
  if not IsNumber(EditDAmount.Text,True) then
  begin
    ActiveControl := EditDAmount;
    EditDAmount.SelectAll;

    ShowMsg('请输入有效完成数量', sHint);
    Exit;
  end;

  EditSAmount.Text := Trim(EditSAmount.Text);
  if not IsNumber(EditSAmount.Text,True) then
  begin
    ActiveControl := EditSAmount;
    EditSAmount.SelectAll;

    ShowMsg('请输入有效停单数量', sHint);
    Exit;
  end;

  try
    nVal := StrToFloat(EditPAmount.Text) - StrToFloat(EditDAmount.Text);
  except
    nVal := 0;
  end;

  if EditType.ItemIndex = 0 then
       nMType := '散装'
  else nMType := '袋装';

  if ChkValid.Checked then
       nValid := sFlag_Yes
  else nValid := sFlag_No;

  if FParam.FCommand = cCmd_AddData then
  begin

    nID := GetSerialNo(sFlag_BusGroup, sFlag_SaleOrderOther, True);
    if nID = '' then
    begin
      ShowMsg('订单号生成失败',sHint);
      Exit;
    end;

    nStr := MakeSQLByStr([
            SF('O_Order', nID),
            SF('O_CusName', EditCName.Text),
            SF('O_CusPY', GetPinYinOfStr(EditCName.Text)),
            SF('O_Lading', '自提'),
            SF('O_Factory', EditFName.Text),
            SF('O_StockName', EditMName.Text),
            SF('O_StockType', nMType),
            SF('O_PlanAmount', EditPAmount.Text),
            SF('O_PlanDone', EditDAmount.Text),
            SF('O_PlanRemain', nVal, sfVal),
            SF('O_Freeze', 0, sfVal),
            SF('O_HasDone', EditDAmount.Text),
            SF('O_StopAmount', EditSAmount.Text),
            SF('O_Valid', nValid),
            SF('O_Create', sField_SQLServer_Now, sfVal)
            ], sTable_SalesOrder, '', True);
    FDM.ExecuteSQL(nStr);

    nEvent := '添加临时订单[ %s ]信息,订单量[ %s ]吨';
    nEvent := Format(nEvent, [nID,EditPAmount.Text]);
    FDM.WriteSysLog(sFlag_SaleOrderItem, nID, nEvent);
  end else
  begin
    nStr := MakeSQLByStr([
            SF('O_CusName', EditCName.Text),
            SF('O_CusPY', GetPinYinOfStr(EditCName.Text)),
            SF('O_Lading', '自提'),
            SF('O_Factory', EditFName.Text),
            SF('O_StockName', EditMName.Text),
            SF('O_StockType', nMType),
            SF('O_PlanAmount', EditPAmount.Text),
            SF('O_PlanDone', EditDAmount.Text),
            SF('O_PlanRemain', nVal, sfVal),
            SF('O_HasDone', EditDAmount.Text),
            SF('O_StopAmount', EditSAmount.Text),
            SF('O_Valid', nValid),
            SF('O_Create', sField_SQLServer_Now, sfVal)
            ], sTable_SalesOrder, 'R_ID=' + FParam.FParamA, False);
    FDM.ExecuteSQL(nStr);

    if FOldPAmount <> Trim(EditPAmount.Text) then
    begin
      nEvent := '修改临时订单[ %s ]信息,原始订单量[ %s ]吨,新订单量[ %s ]吨';
      nEvent := Format(nEvent, [EditOID.Text,FOldPAmount,EditPAmount.Text]);
      FDM.WriteSysLog(sFlag_SaleOrderItem, EditOID.Text, nEvent);
    end;

  end;

  ShowMsg('保存完成',sHint);
  ModalResult := mrOk;
  //done

end;

procedure TfFormSaleOrderOther.EditCNamePropertiesChange(Sender: TObject);
var nIdx : Integer;
begin
  for nIdx := 0 to EditCName.Properties.Items.Count - 1 do
  begin;
    if Pos(EditCName.Text,EditCName.Properties.Items.Strings[nIdx]) > 0 then
    begin
      EditCName.SelectedItem := nIdx;
      Break;
    end;
  end;
end;

procedure TfFormSaleOrderOther.BtnDoneClick(Sender: TObject);
var nStr, nValue : string;
    nVal: Double;
begin
  if FParam.FCommand = cCmd_AddData then
  begin
    ShowMsg('新增订单无需调整',sHint);
    Exit;
  end;

  nValue := GetSaleOrderDoneValue(EditOID.Text, EditCName.Text, EditMName.Text);

  if nValue = '' then
  begin
    ShowMsg('查询完成量为空',sHint);
    Exit;
  end;

  nStr := '调整完成量[ %s -> %s ].确定要修改吗?';
  nStr := Format(nStr, [EditDAmount.Text, nValue]);
  if not QueryDlg(nStr, sHint) then Exit;

  nStr := 'Update %s Set O_HasDone=%s,O_PlanDone=''%s'' Where O_Order=''%s''';
  nStr := Format(nStr, [sTable_SalesOrder, nValue, nValue, EditOID.Text]);
  FDM.ExecuteSQL(nStr);

  nStr := 'Select O_PlanAmount, O_HasDone From %s Where O_Order=''%s''';
  nStr := Format(nStr, [sTable_SalesOrder, EditOID.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nVal := Fields[0].AsFloat - Fields[1].AsFloat;
  end;

  nStr := 'Update %s Set O_PlanRemain=''%s'' Where O_Order=''%s''';
  nStr := Format(nStr, [sTable_SalesOrder, FloatToStr(nVal), EditOID.Text]);
  FDM.ExecuteSQL(nStr);

  EditDAmount.Text := nValue;

  ShowMsg('修改完成',sHint);
end;

procedure TfFormSaleOrderOther.BtnFreezeClick(Sender: TObject);
var nStr, nValue : string;
begin
  if FParam.FCommand = cCmd_AddData then
  begin
    ShowMsg('新增订单无需调整',sHint);
    Exit;
  end;

  nValue := GetSaleOrderFreezeValue(EditOID.Text);

  if nValue = '' then
  begin
    ShowMsg('查询冻结量为空',sHint);
    Exit;
  end;

  nStr := '调整冻结量[ %s -> %s ].确定要修改吗?';
  nStr := Format(nStr, [EditFAmount.Text, nValue]);
  if not QueryDlg(nStr, sHint) then Exit;

  nStr := 'Update %s Set O_Freeze=%s Where O_Order=''%s''';
  nStr := Format(nStr, [sTable_SalesOrder, nValue,
          EditOID.Text]);
  FDM.ExecuteSQL(nStr);

  EditFAmount.Text := nValue;
  ShowMsg('修改完成',sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormSaleOrderOther, TfFormSaleOrderOther.FormID);
end.
