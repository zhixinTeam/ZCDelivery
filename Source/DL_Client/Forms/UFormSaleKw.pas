{*******************************************************************************
  作者: juner11212436@163.com 2018/03/15
  描述: 销售勘误
*******************************************************************************}
unit UFormSaleKw;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxLabel,
  dxLayoutcxEditAdapters, cxCheckBox, cxCalendar, ComCtrls, cxListView;

type
  TfFormSaleKw = class(TfFormNormal)
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
    EditMValue: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    chkReSync: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditValue: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item14: TdxLayoutItem;
    cxLabel3: TcxLabel;
    dxLayout1Item15: TdxLayoutItem;
    cxLabel4: TcxLabel;
    dxLayout1Item16: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FListA: TStrings;
    FOldValue: Double;
    FOldBatchCode: string;
    FOldZhiKa: string;
    procedure InitFormData;
    //初始化界面
    procedure WriteOptionLog(const LID: string; nIdx: Integer);
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


class function TfFormSaleKw.CreateForm(const nPopedom: string;
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
//    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then
//    begin
//      gBillItem := nil;
//    end
//    else
      gBillItem := nDef;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormSaleKw.Create(Application) do
  try
    Caption := '销售勘误';

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

class function TfFormSaleKw.FormID: integer;
begin
  Result := cFI_FormSaleKw;
end;

procedure TfFormSaleKw.FormCreate(Sender: TObject);
begin
  FListA    := TStringList.Create;
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  dxGroup1.AlignHorz := ahClient;
end;

procedure TfFormSaleKw.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FListA.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormSaleKw.InitFormData;
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
        SubItems.Add(FieldByName('L_MValue').AsString);
        ImageIndex := cItemIconIndex;
      end;
      EditTruck.Text := FieldByName('L_Truck').AsString;
      EditPValue.Text := FieldByName('L_PValue').AsString;
      EditMValue.Text := FieldByName('L_MValue').AsString;
      FOldValue := FieldByName('L_Value').AsFloat;
      FOldBatchCode := FieldByName('L_HYDan').AsString;
      FOldZhiKa := FieldByName('L_ZhiKa').AsString;
      if Length(FieldByName('L_OutFact').AsString) > 0 then
      begin
        dxLayout1Item8.Visible := True;
        dxLayout1Item11.Visible := True;
        dxLayout1Item14.Visible := True;
        dxLayout1Item15.Visible := True;
        dxLayout1Item16.Visible := True;
      end
      else
      begin
        dxLayout1Item8.Visible := False;
        dxLayout1Item11.Visible := False;
        dxLayout1Item14.Visible := False;
        dxLayout1Item15.Visible := False;
        dxLayout1Item16.Visible := False;
      end;
    end;
  end;
  if ListQuery.Items.Count>0 then
    ListQuery.ItemIndex := 0;
  BtnOK.Enabled := ListQuery.Items.Count>0;
end;

//Desc: 保存
procedure TfFormSaleKw.BtnOKClick(Sender: TObject);
var nStr,nSQL,nStockNo: string;
    nIdx: Integer;
    nValue,nNewValue: Double;
    nNewBatchCode: string;
begin
  if not QueryDlg('确定要修改上述磅单数据吗?', sHint) then Exit;

  if not IsNumber(EditPValue.Text,True) then
  begin
    EditPValue.SetFocus;
    nStr := '请输入有效皮重';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  if not IsNumber(EditMValue.Text,True) then
  begin
    EditMValue.SetFocus;
    nStr := '请输入有效毛重';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  if StrToFloat(EditMValue.Text) <= StrToFloat(EditPValue.Text) then
  begin
    EditMValue.SetFocus;
    nStr := '毛重不能小于皮重';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  nNewValue := StrToFloat(EditMValue.Text) - StrToFloat(EditPValue.Text);
  if gBillItem.FZhiKa <> '' then
  if nNewValue > gBillItem.FValue then
  begin
    EditMValue.SetFocus;
    nStr := '订单余量不足,无法勘误';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  nValue := nNewValue - FOldValue;

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
              ' L_Truck=''%s'',L_PValue=''%s'',L_MValue=''%s'',L_Value=''%s'','+
              ' L_CusName=''%s'',L_CusPY=''%s'',L_Type=''%s'',L_HYDan=''%s'','+
              ' L_Order=''%s'' Where L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill, gBillItem.FStockNo,
                                          gBillItem.FStockName,
                                          gBillItem.FZhiKa,
                                          Trim(EditTruck.Text),
                                          Trim(EditPValue.Text),
                                          Trim(EditMValue.Text),
                                          FloatToStr(nNewValue),
                                          gBillItem.FCusName,
                                          GetPinYinOfStr(gBillItem.FCusName,),
                                          gBillItem.FType,
                                          nNewBatchCode,
                                          gBillItem.FZhiKa,
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);


      nSQL := 'Update %s Set P_MID=''%s'', P_MName=''%s'', P_MType=''%s'','+
              ' P_CusName=''%s'',P_PValue=''%s'',P_MValue=''%s'','+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_Bill=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog, gBillItem.FStockNo,
                                          gBillItem.FStockName,
                                          gBillItem.FType,
                                          gBillItem.FCusName,
                                          EditPValue.Text,
                                          EditMValue.Text,
                                          gSysParam.FUserID,
                                          sField_SQLServer_Now,
                                          Trim(EditTruck.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);

      if dxLayout1Item8.Visible then//出厂
      begin
        nStr := 'Update %s Set O_HasDone=O_HasDone-(%.2f) Where O_Order=''%s''';
        nStr := Format(nStr, [sTable_SalesOrder, FOldValue, FOldZhiKa]);
        FDM.ExecuteSQL(nStr); //已发
      end else
      begin
        nStr := 'Update %s Set O_Freeze=O_Freeze-(%.2f) Where O_Order=''%s''';
        nStr := Format(nStr, [sTable_SalesOrder, FOldValue, FOldZhiKa]);
        FDM.ExecuteSQL(nStr); //冻结
      end;

      nStr := 'Update %s Set B_HasUse=B_HasUse-(%.2f) Where B_Batcode=''%s''';
      nStr := Format(nStr, [sTable_StockBatcode, FOldValue, FOldBatchCode]);
      FDM.ExecuteSQL(nStr);
      //释放使用的批次号

      nStr := 'Update %s Set R_Used=R_Used-(%.2f) Where R_Batcode=''%s''';
      nStr := Format(nStr, [sTable_BatRecord, FOldValue, FOldBatchCode]);
      FDM.ExecuteSQL(nStr);
      //释放批次记录使用量


      if dxLayout1Item8.Visible then//出厂
      begin
        nStr := 'Update %s Set O_HasDone=O_HasDone+(%.2f) Where O_Order=''%s''';
        nStr := Format(nStr, [sTable_SalesOrder, nNewValue, gBillItem.FZhiKa]);
        FDM.ExecuteSQL(nStr); //已发
      end else
      begin
        nStr := 'Update %s Set O_Freeze=O_Freeze+(%.2f) Where O_Order=''%s''';
        nStr := Format(nStr, [sTable_SalesOrder, nNewValue, gBillItem.FZhiKa]);
        FDM.ExecuteSQL(nStr); //冻结
      end;

      nStr := 'Update %s Set B_HasUse=B_HasUse+(%.2f) Where B_Batcode=''%s''';
      nStr := Format(nStr, [sTable_StockBatcode, nNewValue, nNewBatchCode]);
      FDM.ExecuteSQL(nStr);
      //增加使用的批次号

      nStr := 'Update %s Set R_Used=R_Used+(%.2f) Where R_Batcode=''%s''';
      nStr := Format(nStr, [sTable_BatRecord, nNewValue, nNewBatchCode]);
      FDM.ExecuteSQL(nStr);
      //增加批次记录使用量

      nSQL := 'Update %s Set H_CusName=''%s'',H_SerialNo=''%s'','+
              ' H_Value=''%s'',H_Truck=''%s'' Where H_Bill=''%s''';
      nSQL := Format(nSQL, [sTable_StockHuaYan,
                                          gBillItem.FCusName,
                                          nNewBatchCode,
                                          FloatToStr(nNewValue),
                                          Trim(EditTruck.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end
    else
    begin
      nSQL := 'Update %s Set L_Truck=''%s'',L_PValue=''%s'','+
              ' L_MValue=''%s'',L_Value=''%s'' Where L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill, Trim(EditTruck.Text),
                                          Trim(EditPValue.Text),
                                          Trim(EditMValue.Text),
                                          FloatToStr(nNewValue),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);

      nSQL := 'Update %s Set P_PValue=''%s'',P_MValue=''%s'','+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_Bill=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog,EditPValue.Text,
                                            EditMValue.Text,
                                            gSysParam.FUserID,
                                            sField_SQLServer_Now,
                                            Trim(EditTruck.Text),
                                            FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);

      if nValue <> 0 then//净重发生变化
      begin
        if dxLayout1Item8.Visible then//出厂
        begin
          nStr := 'Update %s Set O_HasDone=O_HasDone+(%.2f) Where O_Order=''%s''';
          nStr := Format(nStr, [sTable_SalesOrder, nValue, FOldZhiKa]);
          FDM.ExecuteSQL(nStr); //已发
        end else
        begin
          nStr := 'Update %s Set O_Freeze=O_Freeze+(%.2f) Where O_Order=''%s''';
          nStr := Format(nStr, [sTable_SalesOrder, nValue, FOldZhiKa]);
          FDM.ExecuteSQL(nStr); //冻结
        end;

        nStr := 'Update %s Set B_HasUse=B_HasUse+(%.2f) Where B_Batcode=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, nValue, FOldBatchCode]);
        FDM.ExecuteSQL(nStr);
        //增加使用的批次号

        nStr := 'Update %s Set R_Used=R_Used+(%.2f) Where R_Batcode=''%s''';
        nStr := Format(nStr, [sTable_BatRecord, nValue, FOldBatchCode]);
        FDM.ExecuteSQL(nStr);
        //增加批次记录使用量

        nSQL := 'Update %s Set H_Value=''%s'',H_Truck=''%s'' Where H_Bill=''%s''';
        nSQL := Format(nSQL, [sTable_StockHuaYan,
                                            FloatToStr(nNewValue),
                                            Trim(EditTruck.Text),
                                            FListA.Strings[nIdx]]);
        FDM.ExecuteSQL(nSQL);
      end;
    end;

    if chkReSync.Checked then
    begin
      nSQL := 'Update %s Set L_BDAX = 0 Where L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill,FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end;
    WriteOptionLog(FListA.Strings[nIdx], nIdx);
  end;

  ModalResult := mrOK;
  if chkReSync.Checked then
    nStr := '勘误完成,请在发货明细重新上传'
  else
    nStr := '勘误完成';
  ShowMsg(nStr, sHint);
end;

procedure TfFormSaleKw.WriteOptionLog(const LID: string;nIdx: Integer);
var nEvent: string;
begin
  nEvent := '';

  try
    with ListQuery.Items[nIdx] do
    begin
      if EditID.Text <> SubItems[3] then
      begin
        nEvent := nEvent + '订单号由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[3], EditID.Text]);
      end;
      if EditCName.Text <> SubItems[4] then
      begin
        nEvent := nEvent + '客户名称由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[4], EditCName.Text]);
      end;
      if SubItems[1] <> EditMate.Text then
      begin
        nEvent := nEvent + '物料由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[1], EditMate.Text]);
      end;
      if SubItems[0] <> EditTruck.Text then
      begin
        nEvent := nEvent + '车牌号由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[0], EditTruck.Text]);
      end;
      if SubItems[5] <> EditPValue.Text then
      begin
        nEvent := nEvent + '皮重由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[5], EditPValue.Text]);
      end;
      if SubItems[6] <> EditMValue.Text then
      begin
        nEvent := nEvent + '毛重由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[6], EditMValue.Text]);
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
  except
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormSaleKw, TfFormSaleKw.FormID);
end.
