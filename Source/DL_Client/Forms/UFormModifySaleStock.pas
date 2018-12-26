{*******************************************************************************
  作者: juner11212436@163.com 2018/03/28
  描述: 销售修改物料
*******************************************************************************}
unit UFormModifySaleStock;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxLabel,
  dxLayoutcxEditAdapters, cxCheckBox, cxCalendar, ComCtrls, cxListView;

type
  TfFormModifySaleStock = class(TfFormNormal)
    EditMate: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditID: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditCName: TcxTextEdit;
    dxlytmLayout1Item3: TdxLayoutItem;
    editMemo: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    ListQuery: TcxListView;
    EditType: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditPValue: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditLValue: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditMValueMax: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FListA: TStrings;
    FOldValue, FOldPValue: Double;
    FOldBatchCode: string;
    FOldZhiKa, FOldTruck, FOldMValueMax: string;
    procedure InitFormData;
    //初始化界面
    procedure WriteOptionLog(const LID: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, DB, IniFiles, UMgrControl, UAdjustForm, UFormBase, UBusinessPacker,
  UDataModule, USysBusiness, USysDB, USysGrid, USysConst,DateUtils,
  UBusinessConst;

var
  gBillItem: TLadingBillItem;
  //提单数据


class function TfFormModifySaleStock.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr, nModifyStr: string;
    nP: PFormCommandParam;
    nList: TStrings;
    nDef: TLadingBillItem;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  if Assigned(nParam) then
       nP := nParam
  else Exit;

  nModifyStr := nP.FParamA;

  try
    FillChar(nDef, SizeOf(nDef), #0);
    nP.FParamE := @nDef;

    CreateBaseFormItem(cFI_FormGetZhika, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
      gBillItem := nDef;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormModifySaleStock.Create(Application) do
  try
    Caption := '销售修改物料';

    FListA.Text := nModifyStr;
    InitFormData;

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;

      if FParamA = mrOK then
           FParamB := ''
      else FParamB := '';
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormModifySaleStock.FormID: integer;
begin
  Result := cFI_FormSaleModifyStock;
end;

procedure TfFormModifySaleStock.FormCreate(Sender: TObject);
begin
  FListA    := TStringList.Create;
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  dxGroup1.AlignHorz := ahClient;
end;

procedure TfFormModifySaleStock.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FListA.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormModifySaleStock.InitFormData;
var nStr: string;
    nIdx: Integer;
begin
  with gBillItem do
  begin
    if gBillItem.FZhiKa <> '' then
    begin
      EditID.Text       := FZhiKa;
      EditCName.Text    := FCusName;
      EditMate.Text     := FStockName;
      if FType = sFlag_Dai then nStr := '袋装' else nStr := '散装';
      EditType.Text     := nStr;
      EditValue.Text     := FloatToStr(FValue);
    end;
  end;
  for nIdx := 0 to FListA.Count - 1 do
  begin
    nStr := 'select * From %s where L_ID = ''%s'' ';

    nStr := Format(nStr,[sTable_Bill,FListA.Strings[nIdx]]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
        Continue;

      with ListQuery.Items.Add do
      begin
        Caption := FieldByName('L_ID').AsString;
        SubItems.Add(FieldByName('L_Truck').AsString);
        SubItems.Add(FieldByName('L_StockName').AsString);
        if FieldByName('L_Type').AsString = sFlag_Dai then
          nStr := '袋装'
        else
          nStr := '散装';
        SubItems.Add(nStr);
        SubItems.Add(FieldByName('L_ZhiKa').AsString);
        SubItems.Add(FieldByName('L_CusName').AsString);
        SubItems.Add(FieldByName('L_PValue').AsString);
        SubItems.Add(FieldByName('L_Value').AsString);
        ImageIndex := cItemIconIndex;
      end;
      EditTruck.Text := FieldByName('L_Truck').AsString;
      FOldTruck := FieldByName('L_Truck').AsString;
      if Length(FieldByName('L_PValue').AsString) > 0 then
        EditPValue.Text := FieldByName('L_PValue').AsString
      else
        EditPValue.Text := '0';
      EditLValue.Text := FieldByName('L_Value').AsString;
      EditMValueMax.Text := FieldByName('L_MValueMax').AsString;
      FOldValue := FieldByName('L_Value').AsFloat;
      FOldPValue := FieldByName('L_PValue').AsFloat;
      FOldMValueMax := FieldByName('L_MValueMax').AsString;
      FOldBatchCode := FieldByName('L_HYDan').AsString;
      FOldZhiKa := FieldByName('L_ZhiKa').AsString;
    end;
  end;
  if ListQuery.Items.Count>0 then
    ListQuery.ItemIndex := 0;
  BtnOK.Enabled := ListQuery.Items.Count>0;
end;

//Desc: 保存
procedure TfFormModifySaleStock.BtnOKClick(Sender: TObject);
var nStr,nSQL,nStockNo,nStockName,nHint: string;
    nIdx: Integer;
    nValue,nNewValue: Double;
    nNewBatchCode: string;
begin
  if not QueryDlg('确定要修改上述提货单数据吗?', sHint) then Exit;

  if not IsNumber(EditPValue.Text,True) then
  begin
    EditPValue.SetFocus;
    nStr := '请输入有效皮重';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  if not IsNumber(EditLValue.Text,True) then
  begin
    EditLValue.SetFocus;
    nStr := '请输入有效提货量';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  if Length(EditMValueMax.Text) > 0 then
  if not IsNumber(EditMValueMax.Text,True) then
  begin
    EditMValueMax.SetFocus;
    nStr := '请输入有效毛重限值';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  nNewValue := StrToFloat(EditLValue.Text);
  if nNewValue > gBillItem.FValue then
  begin
    EditLValue.SetFocus;
    nStr := '订单余量不足,无法修改';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  nValue := nNewValue - FOldValue;

  {$IFDEF SyncDataByDataBase}
  for nIdx := 0 to FListA.Count - 1 do
  begin
    if Length(EditID.Text) > 0 then//更换订单
    begin
      nStr := 'Select D_ParamB From %s Where D_Name = ''%s'' ' +
              'And D_Memo=''%s'' and D_Value like ''%%%s%%''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_StockItem,
                            gBillItem.FType,
                            Trim(gBillItem.FStockName)]);

      with FDM.QueryTemp(nStr) do
      begin
        if RecordCount < 1 then
        begin
          ShowMsg('未查询到物料编号',sHint);
          Exit;
        end;
        gBillItem.FStockNo := Fields[0].AsString;
      end;

      nNewBatchCode := GetBatchCode(gBillItem.FStockNo,
                                    gBillItem.FCusName,
                                    nNewValue);

      if nNewBatchCode = '' then
      begin
        ShowMsg('获取批次号失败',sHint);
        Exit;
      end;

      nSQL := 'Update %s Set L_StockNo=''%s'',L_StockName=''%s'',L_ZhiKa=''%s'','+
              ' L_Truck=''%s'',L_PValue=''%s'',L_Value=''%s'','+
              ' L_CusName=''%s'',L_CusPY=''%s'',L_Type=''%s'',L_HYDan=''%s'','+
              ' L_Order=''%s'',L_MValueMax=''%s'' Where L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill, gBillItem.FStockNo,
                                          gBillItem.FStockName,
                                          gBillItem.FZhiKa,
                                          Trim(EditTruck.Text),
                                          Trim(EditPValue.Text),
                                          FloatToStr(nNewValue),
                                          gBillItem.FCusName,
                                          GetPinYinOfStr(gBillItem.FCusName,),
                                          gBillItem.FType,
                                          nNewBatchCode,
                                          gBillItem.FZhiKa,
                                          Trim(EditMValueMax.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);


      nSQL := 'Update %s Set P_MID=''%s'', P_MName=''%s'', P_MType=''%s'','+
              ' P_CusName=''%s'',P_PValue=''%s'','+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_Bill=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog, gBillItem.FStockNo,
                                          gBillItem.FStockName,
                                          gBillItem.FType,
                                          gBillItem.FCusName,
                                          EditPValue.Text,
                                          gSysParam.FUserID,
                                          sField_SQLServer_Now,
                                          Trim(EditTruck.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);

      nStr := 'Update %s Set O_Freeze=O_Freeze-(%.2f) Where O_Order=''%s''';
      nStr := Format(nStr, [sTable_SalesOrder, FOldValue, FOldZhiKa]);
      FDM.ExecuteSQL(nStr); //冻结

      nStr := 'Update %s Set B_HasUse=B_HasUse-(%.2f) Where B_Batcode=''%s''';
      nStr := Format(nStr, [sTable_StockBatcode, FOldValue, FOldBatchCode]);
      FDM.ExecuteSQL(nStr);
      //释放使用的批次号

      nStr := 'Update %s Set R_Used=R_Used-(%.2f) Where R_Batcode=''%s''';
      nStr := Format(nStr, [sTable_BatRecord, FOldValue, FOldBatchCode]);
      FDM.ExecuteSQL(nStr);
      //释放批次记录使用量


      nStr := 'Update %s Set O_Freeze=O_Freeze+(%.2f) Where O_Order=''%s''';
      nStr := Format(nStr, [sTable_SalesOrder, nNewValue, gBillItem.FZhiKa]);
      FDM.ExecuteSQL(nStr); //冻结

      nStr := 'Update %s Set B_HasUse=B_HasUse+(%.2f) Where B_Batcode=''%s''';
      nStr := Format(nStr, [sTable_StockBatcode, nNewValue, nNewBatchCode]);
      FDM.ExecuteSQL(nStr);
      //增加使用的批次号

      nStr := 'Update %s Set R_Used=R_Used+(%.2f) Where R_Batcode=''%s''';
      nStr := Format(nStr, [sTable_BatRecord, nNewValue, nNewBatchCode]);
      FDM.ExecuteSQL(nStr);
      //增加批次记录使用量

    end
    else
    begin
      nSQL := 'Update %s Set L_Truck=''%s'',L_PValue=''%s'','+
              ' L_Value=''%s'',L_MValueMax=''%s'' Where L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill, Trim(EditTruck.Text),
                                          Trim(EditPValue.Text),
                                          FloatToStr(nNewValue),
                                          Trim(EditMValueMax.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);

      nSQL := 'Update %s Set P_PValue=''%s'','+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_Bill=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog,EditPValue.Text,
                                            gSysParam.FUserID,
                                            sField_SQLServer_Now,
                                            Trim(EditTruck.Text),
                                            FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);

      if nValue <> 0 then//净重发生变化
      begin
        nStr := 'Update %s Set O_Freeze=O_Freeze+(%.2f) Where O_Order=''%s''';
        nStr := Format(nStr, [sTable_SalesOrder, nValue, FOldZhiKa]);
        FDM.ExecuteSQL(nStr); //冻结

        nStr := 'Update %s Set B_HasUse=B_HasUse+(%.2f) Where B_Batcode=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, nValue, FOldBatchCode]);
        FDM.ExecuteSQL(nStr);
        //增加使用的批次号

        nStr := 'Update %s Set R_Used=R_Used+(%.2f) Where R_Batcode=''%s''';
        nStr := Format(nStr, [sTable_BatRecord, nValue, FOldBatchCode]);
        FDM.ExecuteSQL(nStr);
        //增加批次记录使用量
      end;
    end;
    WriteOptionLog(FListA.Strings[nIdx]);
  end;
  {$ELSE}
  for nIdx := 0 to FListA.Count - 1 do
  begin
    if Length(EditID.Text) > 0 then//更换订单
    begin
      nStr := 'select L_StockName From %s where L_ID = ''%s'' ';

      nStr := Format(nStr,[sTable_Bill,FListA.Strings[nIdx]]);

      with FDM.QueryTemp(nStr) do
      begin
        if RecordCount < 1 then
        begin
          ShowMsg('未查询到提货单详细信息',sHint);
          Exit;
        end;
        nStockName := Fields[0].AsString;
      end;

      if nStockName <> gBillItem.FStockName then
      begin
        nNewBatchCode := GetHhSaleWareNumberWSDL(gBillItem.FZhiKa, EditLValue.Text, nHint);
        if nNewBatchCode = '' then
        begin
          ShowMsg('获取批次号失败:' + nHint,sHint);
          Exit;
        end;
      end;
      nStr := 'Select D_ParamB From %s Where D_Name = ''%s'' ' +
              'And D_Memo=''%s'' and D_Value like ''%%%s%%''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_StockItem,
                            gBillItem.FType,
                            Trim(gBillItem.FStockName)]);

      with FDM.QueryTemp(nStr) do
      begin
        if RecordCount < 1 then
        begin
          ShowMsg('未查询到物料编号',sHint);
          Exit;
        end;
        gBillItem.FStockNo := Fields[0].AsString;
      end;

      nSQL := 'Update %s Set L_StockNo=''%s'',L_StockName=''%s'',L_ZhiKa=''%s'','+
              ' L_Truck=''%s'',L_PValue=''%s'',L_Value=''%s'','+
              ' L_CusName=''%s'',L_CusPY=''%s'',L_Type=''%s'',L_HYDan=''%s'','+
              ' L_Order=''%s'',L_MValueMax=''%s'' Where L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill, gBillItem.FStockNo,
                                          gBillItem.FStockName,
                                          gBillItem.FZhiKa,
                                          Trim(EditTruck.Text),
                                          Trim(EditPValue.Text),
                                          FloatToStr(nNewValue),
                                          gBillItem.FCusName,
                                          GetPinYinOfStr(gBillItem.FCusName,),
                                          gBillItem.FType,
                                          nNewBatchCode,
                                          gBillItem.FZhiKa,
                                          Trim(EditMValueMax.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);


      nSQL := 'Update %s Set P_MID=''%s'', P_MName=''%s'', P_MType=''%s'','+
              ' P_CusName=''%s'',P_PValue=''%s'','+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_Bill=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog, gBillItem.FStockNo,
                                          gBillItem.FStockName,
                                          gBillItem.FType,
                                          gBillItem.FCusName,
                                          EditPValue.Text,
                                          gSysParam.FUserID,
                                          sField_SQLServer_Now,
                                          Trim(EditTruck.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end
    else
    begin
      nSQL := 'Update %s Set L_Truck=''%s'',L_PValue=''%s'','+
              ' L_Value=''%s'',L_MValueMax=''%s'' Where L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill, Trim(EditTruck.Text),
                                          Trim(EditPValue.Text),
                                          FloatToStr(nNewValue),
                                          Trim(EditMValueMax.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);

      nSQL := 'Update %s Set P_PValue=''%s'','+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_Bill=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog,EditPValue.Text,
                                            gSysParam.FUserID,
                                            sField_SQLServer_Now,
                                            Trim(EditTruck.Text),
                                            FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end;
    WriteOptionLog(FListA.Strings[nIdx]);
  end;
  {$ENDIF}

  ModalResult := mrOK;
  nStr := '修改完成';
  ShowMsg(nStr, sHint);
end;

procedure TfFormModifySaleStock.WriteOptionLog(const LID: string);
var nEvent: string;
begin
  nEvent := '';

  begin
    if EditID.Text <> '' then
    begin
      nEvent := nEvent + '订单号由 [ %s ] --> [ %s ];';
      nEvent := Format(nEvent, [FOldZhiKa, EditID.Text]);
    end;
    if FOldTruck <> EditTruck.Text then
    begin
      nEvent := nEvent + '车牌号由 [ %s ] --> [ %s ];';
      nEvent := Format(nEvent, [FOldTruck, EditTruck.Text]);
    end;
    if FOldValue <> StrToFloatDef(EditLValue.Text,0) then
    begin
      nEvent := nEvent + '开单量由 [ %.2f ] --> [ %s ];';
      nEvent := Format(nEvent, [FOldValue, EditLValue.Text]);
    end;
    if FOldPValue <> StrToFloatDef(EditPValue.Text,0) then
    begin
      nEvent := nEvent + '皮重由 [ %.2f ] --> [ %s ];';
      nEvent := Format(nEvent, [FOldPValue, EditPValue.Text]);
    end;
    if FOldMValueMax <> EditMValueMax.Text then
    begin
      nEvent := nEvent + '毛重上限由 [ %s ] --> [ %s ];';
      nEvent := Format(nEvent, [FOldMValueMax, EditMValueMax.Text]);
    end;

    if nEvent <> '' then
    begin
      nEvent := '提货单 [ %s ] 参数已被修改:' + nEvent;
      nEvent := Format(nEvent, [LID]);
    end;
  end;

  if nEvent <> '' then
  begin
    FDM.WriteSysLog(sFlag_BillItem, LID, nEvent);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormModifySaleStock, TfFormModifySaleStock.FormID);
end.
