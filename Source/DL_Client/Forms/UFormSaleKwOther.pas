{*******************************************************************************
  作者: juner11212436@163.com 2018/03/15
  描述: 销售外运勘误
*******************************************************************************}
unit UFormSaleKwOther;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxLabel,
  dxLayoutcxEditAdapters, cxCheckBox, cxCalendar, ComCtrls, cxListView;

type
  TfFormSaleKwOther = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    ListQuery: TcxListView;
    EditPValue: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditMValue: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FListA: TStrings;
    FOldValue: Double;
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


class function TfFormSaleKwOther.CreateForm(const nPopedom: string;
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

  with TfFormSaleKwOther.Create(Application) do
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

class function TfFormSaleKwOther.FormID: integer;
begin
  Result := cFI_FormSaleKwOther;
end;

procedure TfFormSaleKwOther.FormCreate(Sender: TObject);
begin
  FListA    := TStringList.Create;
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  dxGroup1.AlignHorz := ahClient;
end;

procedure TfFormSaleKwOther.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FListA.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormSaleKwOther.InitFormData;
var nStr: string;
    nIdx: Integer;
begin
  for nIdx := 0 to FListA.Count - 1 do
  begin
    nStr := 'select * From %s where P_ID = ''%s'' ';

    nStr := Format(nStr,[sTable_PoundLog,FListA.Strings[nIdx]]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
        Continue;

      with ListQuery.Items.Add do
      begin
        Caption := FieldByName('P_ID').AsString;
        SubItems.Add(FieldByName('P_Truck').AsString);
        SubItems.Add(FieldByName('P_MName').AsString);
        if FieldByName('P_MType').AsString = sFlag_Dai then
          nStr := '袋装'
        else
          nStr := '散装';
        SubItems.Add(nStr);
        SubItems.Add(FieldByName('P_OrderBak').AsString);
        SubItems.Add(FieldByName('P_CusName').AsString);
        SubItems.Add(FieldByName('P_PValue').AsString);
        SubItems.Add(FieldByName('P_MValue').AsString);
        ImageIndex := cItemIconIndex;
      end;
      EditTruck.Text := FieldByName('P_Truck').AsString;
      EditPValue.Text := FieldByName('P_PValue').AsString;
      EditMValue.Text := FieldByName('P_MValue').AsString;
      if (EditPValue.Text = '') or (EditMValue.Text = '') then
        FOldValue := 0
      else
        FOldValue := FieldByName('P_MValue').AsFloat -
                     FieldByName('P_PValue').AsFloat;
    end;
  end;
  if ListQuery.Items.Count>0 then
    ListQuery.ItemIndex := 0;
  BtnOK.Enabled := ListQuery.Items.Count>0;
end;

//Desc: 保存
procedure TfFormSaleKwOther.BtnOKClick(Sender: TObject);
var nStr,nSQL,nStockNo: string;
    nIdx: Integer;
    nValue,nNewValue: Double;
    nOrder, nLID: string;
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

  if StrToFloat(EditMValue.Text) < StrToFloat(EditPValue.Text) then
  begin
    EditMValue.SetFocus;
    nStr := '毛重不能小于皮重';
    ShowMsg(nStr,sHint);
    Exit;
  end;

  nNewValue := StrToFloat(EditMValue.Text) - StrToFloat(EditPValue.Text);

  nValue := nNewValue - FOldValue;

  for nIdx := 0 to FListA.Count - 1 do
  begin
    nStr := 'select * From %s a, %s b'+
    ' where (a.L_ID=b.P_OrderBak or a.L_ID=b.P_Bill) and b.P_ID = ''%s'' ';

    nStr := Format(nStr,[sTable_Bill,sTable_PoundLog,FListA.Strings[nIdx]]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        nStr := '未查询到符合条件记录';
        ShowMsg(nStr,sHint);
        Exit;
      end;
      nOrder := FieldByName('L_ZhiKa').AsString;
      nLID   := FieldByName('L_ID').AsString;
    end;

    if FDM.QueryTemp(nStr).FieldByName('P_MValue').AsString = '' then
    begin
      nSQL := 'Update %s Set P_PValue=''%s'',P_MValue=''%s'',P_MMan=''%s'',P_MDate=P_PDate,'+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'',P_OrderBak=''%s'',P_Bill=null Where P_ID=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog,EditPValue.Text,
                                            EditMValue.Text,
                                            gSysParam.FUserID,
                                            gSysParam.FUserID,
                                            sField_SQLServer_Now,
                                            Trim(EditTruck.Text),
                                            nLID,
                                            FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end
    else
    begin
      nSQL := 'Update %s Set P_PValue=''%s'',P_MValue=''%s'',P_KwMan=''%s'',P_KwDate=%s,'+
              ' P_Truck=''%s'',P_OrderBak=''%s'',P_Bill=null Where P_ID=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog,EditPValue.Text,
                                            EditMValue.Text,
                                            gSysParam.FUserID,
                                            sField_SQLServer_Now,
                                            Trim(EditTruck.Text),
                                            nLID,
                                            FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end;

    if nValue <> 0 then//净重发生变化
    begin
      nStr := 'Update %s Set O_HasDone=O_HasDone+(%.2f) Where O_Order=''%s''';
      nStr := Format(nStr, [sTable_SalesOrder, nValue, nOrder]);
      FDM.ExecuteSQL(nStr); //已发
    end;
    WriteOptionLog(FListA.Strings[nIdx], nIdx);
  end;

  ModalResult := mrOK;
  nStr := '勘误完成';
  ShowMsg(nStr, sHint);
end;

procedure TfFormSaleKwOther.WriteOptionLog(const LID: string;nIdx: Integer);
var nEvent: string;
begin
  nEvent := '';

  try
    with ListQuery.Items[nIdx] do
    begin
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
        nEvent := '磅单 [ %s ] 参数已被修改:' + nEvent;
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
  gControlManager.RegCtrl(TfFormSaleKwOther, TfFormSaleKwOther.FormID);
end.
