{*******************************************************************************
  作者: juner11212436@163.com 2018/04/08
  描述: 销售外运补单
*******************************************************************************}
unit UFormSaleBuDanOther;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxLabel,
  dxLayoutcxEditAdapters, cxCheckBox, cxCalendar, ComCtrls, cxListView;

type
  TfFormSaleBuDanOther = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    ListQuery: TcxListView;
    EditPValue: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditMValue: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditPTime: TcxDateEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditMTime: TcxDateEdit;
    dxLayout1Item8: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FListA: TStrings;
    procedure InitFormData;
    //初始化界面
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
  UBusinessConst, UFormCtrl;

var
  gBillItem: TLadingBillItem;
  //提单数据


class function TfFormSaleBuDanOther.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr, nModifyStr: string;
    nP: PFormCommandParam;
    nList: TStrings;
    nDef: TLadingBillItem;
begin
  Result := nil;

  if Assigned(nParam) then
       nP := nParam
  else Exit;

  nModifyStr := nP.FParamA;

  with TfFormSaleBuDanOther.Create(Application) do
  try
    Caption := '销售补单';

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

class function TfFormSaleBuDanOther.FormID: integer;
begin
  Result := cFI_FormSaleBuDanOther;
end;

procedure TfFormSaleBuDanOther.FormCreate(Sender: TObject);
begin
  FListA    := TStringList.Create;
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  dxGroup1.AlignHorz := ahClient;
end;

procedure TfFormSaleBuDanOther.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FListA.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormSaleBuDanOther.InitFormData;
var nStr: string;
    nIdx: Integer;
begin
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
        Caption := FieldByName('L_ZhiKa').AsString;
        SubItems.Add(FieldByName('L_ID').AsString);
        SubItems.Add(FieldByName('L_Truck').AsString);
        SubItems.Add(FieldByName('L_StockNo').AsString);
        SubItems.Add(FieldByName('L_StockName').AsString);
        SubItems.Add(FieldByName('L_Type').AsString);
        SubItems.Add(FieldByName('L_CusName').AsString);
        ImageIndex := cItemIconIndex;
      end;
      EditTruck.Text := FieldByName('L_Truck').AsString;
      EditPValue.Text := '0';
      EditMValue.Text := '0';
      EditPTime.Date := Now;
      EditMTime.Date := Now;
    end;
  end;
  if ListQuery.Items.Count>0 then
    ListQuery.ItemIndex := 0;
  BtnOK.Enabled := ListQuery.Items.Count>0;
end;

//Desc: 保存
procedure TfFormSaleBuDanOther.BtnOKClick(Sender: TObject);
var nStr,nSQL,nPID: string;
    nIdx: Integer;
    nValue: Double;
begin
  if not QueryDlg('确定要进行数据补录吗?', sHint) then Exit;

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
  nValue := StrToFloat(EditMValue.Text) - StrToFloat(EditPValue.Text);

  for nIdx := 0 to ListQuery.Items.Count - 1 do
  with ListQuery.Items[nIdx] do
  begin
    nPID := GetSerialNo(sFlag_BusGroup, sFlag_PoundID, True);
    if nPID = '' then
    begin
      ShowMsg('磅单号生成失败',sHint);
      Exit;
    end;

    nStr := MakeSQLByStr([
            SF('P_ID', nPID),
            SF('P_Type', sFlag_Sale),
            SF('P_Truck', SubItems[1]),
            SF('P_CusID', ''),
            SF('P_CusName', SubItems[5]),
            SF('P_MID', SubItems[2]),
            SF('P_MName', SubItems[3]),
            SF('P_MType', SubItems[4]),
            SF('P_LimValue', nValue),
            SF('P_PValue', StrToFloat(EditPValue.Text), sfVal),
            SF('P_PDate', EditPTime.Text),
            SF('P_PMan', gSysParam.FUserID),
            SF('P_MValue', StrToFloat(EditMValue.Text), sfVal),
            SF('P_MDate', EditMTime.Text),
            SF('P_MMan', gSysParam.FUserID),
            SF('P_FactID', 'AHZC'),
            SF('P_Direction', '出厂'),
            SF('P_PModel', sFlag_TruckBFP),
            SF('P_Status', sFlag_TruckBFP),
            SF('P_Valid', sFlag_Yes),
            SF('P_BDAX', 3, sfVal),
            SF('P_OrderBak', SubItems[0]),
            SF('P_PrintNum', 1, sfVal)
            ], sTable_PoundLog, '', True);

    if FDM.ExecuteSQL(nStr) > 0 then
    begin
      nStr := 'Update %s Set O_HasDone=O_HasDone+(%.2f) Where O_Order=''%s''';
      nStr := Format(nStr, [sTable_SalesOrder, nValue, Caption]);
      FDM.ExecuteSQL(nStr); //已发

      nValue := 0;
      nStr := 'Select O_PlanAmount, O_HasDone From %s Where O_Order=''%s''';
      nStr := Format(nStr, [sTable_SalesOrder, Caption]);

      with FDM.QueryTemp(nStr) do
      if RecordCount > 0 then
      begin
        nValue := Fields[0].AsFloat - Fields[1].AsFloat;
      end;
      nStr := 'Update %s Set O_PlanDone=O_HasDone,' +
              'O_PlanRemain=''%s'' Where O_Order=''%s''';
      nStr := Format(nStr, [sTable_SalesOrder, FloatToStr(nValue), Caption]);
      FDM.ExecuteSQL(nStr);
    end;
  end;

  ModalResult := mrOK;
  nStr := '补单完成,新称重单据流水号为:' + nPID;
  ShowMsg(nStr, sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormSaleBuDanOther, TfFormSaleBuDanOther.FormID);
end.
