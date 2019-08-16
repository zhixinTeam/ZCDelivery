{*******************************************************************************
  作者: juner11212436@163.com 2019-02-21
  描述: 车辆限载管理
*******************************************************************************}
unit UFormTruckXz;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox, cxSpinEdit, cxTimeEdit;

type
  TfFormTruckXz = class(TfFormNormal)
    CheckValid: TcxCheckBox;
    dxLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    EditDefXz: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    ChkUseXz: TcxCheckBox;
    dxLayout1Item3: TdxLayoutItem;
    EditCus: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    EditXz: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditBegin: TcxTimeEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditEnd: TcxTimeEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditCusPropertiesChange(Sender: TObject);
  protected
    { Protected declarations }
    FTruckID: string;
    procedure LoadFormData(const nID: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst;

type
  TCusItem = record
    FID   : string;
    FName : string;
  end;

var
  gCusItems: array of TCusItem;
  //客户列表

class function TfFormTruckXz.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;
  
  with TfFormTruckXz.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      Caption := '车辆限载 - 添加';
      FTruckID := '';
    end;

    if nP.FCommand = cCmd_EditData then
    begin
      Caption := '车辆限载 - 修改';
      FTruckID := nP.FParamA;
    end;

    LoadFormData(FTruckID); 
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormTruckXz.FormID: integer;
begin
  Result := cFI_FormTruckXz;
end;

procedure TfFormTruckXz.LoadFormData(const nID: string);
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select * From %s Where X_CusName=''%s''';
  nStr := Format(nStr, [sTable_TruckXz, sFlag_TruckXzTotal]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      if FieldByName('X_Valid').AsString = sFlag_Yes then
        ChkUseXz.Checked := True;
      EditDefXz.Text := FieldByName('X_XzValue').AsString;
    end;
  end;

  EditCus.Properties.Items.Clear;
  nStr := 'Select C_ID, C_Name From %s  ';
  nStr := Format(nStr, [sTable_Customer]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      SetLength(gCusItems, RecordCount);

      nIdx := 0;
      try
        EditCus.Properties.BeginUpdate;

        First;

        while not Eof do
        begin
          if (Fields[0].AsString = '') or (Fields[1].AsString = '') then
          begin
            Next;
            Continue;
          end;
          with gCusItems[nIdx] do
          begin
            FID := Fields[0].AsString;
            FName := Fields[1].AsString;
          end;

          Inc(nIdx);
          EditCus.Properties.Items.Add(Fields[1].AsString);
          Next;
        end;
      finally
        EditCus.Properties.EndUpdate;
      end;
    end;
  end;

  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_TruckType]);

  EditType.Properties.Items.Clear;

  with FDM.QueryTemp(nStr) do
  begin

    First;

    while not Eof do
    begin
      EditType.Properties.Items.Add(Fields[0].AsString);
      Next;
    end;
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_TruckXz, nID]);
    FDM.QueryTemp(nStr);
  end;

  with FDM.SqlTemp do
  begin
    if (nID = '') or (RecordCount < 1) then
    begin
      CheckValid.Checked := True;
      Exit;
    end;

    EditCus.Text := FieldByName('X_CusName').AsString;

    EditCus.ItemIndex := EditCus.SelectedItem;
    EditXz.Text := FieldByName('X_XzValue').AsString;
    EditBegin.Text := FieldByName('X_BeginTime').AsString;
    EditEnd.Text := FieldByName('X_EndTime').AsString;
    EditMemo.Text := FieldByName('X_Memo').AsString;
    EditType.Text := FieldByName('X_TruckType').AsString;
    CheckValid.Checked := FieldByName('X_Valid').AsString = sFlag_Yes;
  end;
end;

//Desc: 保存
procedure TfFormTruckXz.BtnOKClick(Sender: TObject);
var nStr,nCID,nV,nVTotal: string;
    nVal, nValDefXz: Double;
begin
  if not IsNumber(Trim(EditDefXz.Text), True) then
  begin
    ActiveControl := EditDefXz;
    ShowMsg('请输入有效默认限载吨位', sHint);
    Exit;
  end;

  if Trim(EditCus.Text) = '' then
  begin
    ActiveControl := EditCus;
    ShowMsg('请选择客户', sHint);
    Exit;
  end;

  if not IsNumber(Trim(EditXz.Text), True) then
  begin
    ActiveControl := EditXz;
    ShowMsg('请输入有效限载吨位', sHint);
    Exit;
  end;

  if Trim(EditBegin.Text) = '' then
  begin
    ActiveControl := EditBegin;
    ShowMsg('请输入有效起始时间', sHint);
    Exit;
  end;

  if Trim(EditEnd.Text) = '' then
  begin
    ActiveControl := EditEnd;
    ShowMsg('请输入有效结束时间', sHint);
    Exit;
  end;

  if ChkUseXz.Checked then
       nVTotal := sFlag_Yes
  else nVTotal := sFlag_No;

  nValDefXz := StrToFloatDef(Trim(EditDefXz.Text), 49);

  nStr := SF('X_CusName', sFlag_TruckXzTotal);
  nStr := MakeSQLByStr([SF('X_XzValue', nValDefXz, sfVal),
          SF('X_CusName', sFlag_TruckXzTotal),
          SF('X_Valid', nVTotal)
          ], sTable_TruckXz, nStr, False);

  if FDM.ExecuteSQL(nStr) <= 0 then
  begin
    nStr := MakeSQLByStr([SF('X_XzValue', nValDefXz, sfVal),
        SF('X_CusName', sFlag_TruckXzTotal),
        SF('X_Valid', nVTotal)
        ], sTable_TruckXz, '', True);
    FDM.ExecuteSQL(nStr);
  end;

  if CheckValid.Checked then
       nV := sFlag_Yes
  else nV := sFlag_No;

  if FTruckID = '' then
       nStr := ''
  else nStr := SF('R_ID', FTruckID, sfVal);

  nVal := StrToFloatDef(Trim(EditXz.Text), 0);

  nStr := MakeSQLByStr([SF('X_CusID', gCusItems[EditCus.ItemIndex].FID),
          SF('X_CusName', gCusItems[EditCus.ItemIndex].FName),
          SF('X_Valid', nV),
          SF('X_XzValue', nVal, sfVal),
          SF('X_BeginTime', EditBegin.Text),
          SF('X_EndTime', EditEnd.Text),
          SF('X_TruckType', EditType.Text),
          SF('X_Memo', EditMemo.Text)
          ], sTable_TruckXz, nStr, FTruckID = '');
  FDM.ExecuteSQL(nStr);

  ModalResult := mrOk;
  ShowMsg('车辆限载信息保存成功', sHint);
end;

procedure TfFormTruckXz.EditCusPropertiesChange(Sender: TObject);
var nIdx : Integer;
    nStr: string;
begin
  for nIdx := 0 to EditCus.Properties.Items.Count - 1 do
  begin;
    if Pos(EditCus.Text,EditCus.Properties.Items.Strings[nIdx]) > 0 then
    begin
      EditCus.SelectedItem := nIdx;
      Break;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTruckXz, TfFormTruckXz.FormID);
end.
