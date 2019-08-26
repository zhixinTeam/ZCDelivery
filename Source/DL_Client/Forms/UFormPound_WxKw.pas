{*******************************************************************************
  作者: juner11212436@163.com 2018/03/15
  描述: 磅单勘误
*******************************************************************************}
unit UFormPound_WxKw;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxLabel,
  dxLayoutcxEditAdapters, cxCheckBox, cxCalendar, ComCtrls, cxListView;

type
  TfFormPound_WxKw = class(TfFormNormal)
    EditStockNo: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    editMemo: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    ListQuery: TcxListView;
    EditPValue: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditMValue: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    chkReSync: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    nP_Type, nP_Order : string;
    FListA  : TStrings;

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
  UDataModule, USysBusiness, USysDB, USysGrid, USysConst,DateUtils;


class function TfFormPound_WxKw.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr, nModifyStr: string;
    nP: PFormCommandParam;
    nList: TStrings;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  if Assigned(nParam) then
       nP := nParam
  else Exit;

  nModifyStr := nP.FParamA;

  with TfFormPound_WxKw.Create(Application) do
  try
    Caption := '磅单勘误';

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

class function TfFormPound_WxKw.FormID: integer;
begin
  Result := cFI_FormPound_WxKw;
end;

procedure TfFormPound_WxKw.FormCreate(Sender: TObject);
begin
  FListA    := TStringList.Create;
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  dxGroup1.AlignHorz := ahClient;
end;

procedure TfFormPound_WxKw.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FListA.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormPound_WxKw.InitFormData;
var nStr: string;
    nIdx: Integer;
begin
  for nIdx := 0 to FListA.Count - 1 do
  begin
    nStr := 'select * From %s c where c.P_ID = ''%s'' ';

    nStr := Format(nStr,[sTable_PoundLog,FListA.Strings[nIdx]]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
        Continue;

      with ListQuery.Items.Add do
      begin
        Caption := FieldByName('P_ID').AsString;
        SubItems.Add(FieldByName('P_Truck').AsString);
        SubItems.Add(FieldByName('P_Type').AsString);
        SubItems.Add(FieldByName('P_PValue').AsString);
        SubItems.Add(FieldByName('P_MValue').AsString);
        SubItems.Add(FieldByName('P_MID').AsString);
        SubItems.Add(FieldByName('P_MName').AsString);
        ImageIndex := cItemIconIndex;
      end;
      nP_Type           := FieldByName('P_Type').AsString;
      nP_Order          := FieldByName('P_Order').AsString;
      EditTruck.Text    := FieldByName('P_Truck').AsString;
      EditPValue.Text   := FieldByName('P_PValue').AsString;
      EditMValue.Text   := FieldByName('P_MValue').AsString;
      EditStockNo.Text  := FieldByName('P_MID').AsString;
    end;
  end;
  if ListQuery.Items.Count>0 then
    ListQuery.ItemIndex := 0;
  BtnOK.Enabled := ListQuery.Items.Count>0;
end;

//Desc: 保存
procedure TfFormPound_WxKw.BtnOKClick(Sender: TObject);
var nStr,nSQL,nOID,nDID: string;
    nIdx: Integer;
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

  for nIdx := 0 to FListA.Count - 1 do
  begin
    nSQL := 'Update %s Set P_PValue=''%s'',P_MValue=''%s'','+
            ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_ID=''%s''';
    nSQL := Format(nSQL, [sTable_PoundLog,EditPValue.Text,
                                          EditMValue.Text,
                                          gSysParam.FUserID,
                                          sField_SQLServer_Now,
                                          Trim(EditTruck.Text),
                                          FListA.Strings[nIdx]]);
    FDM.ExecuteSQL(nSQL);


    if chkReSync.Checked then
    begin
      nSQL := 'Update %s Set P_BDAX = 0 Where P_ID=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog,FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end;
    WriteOptionLog(FListA.Strings[nIdx], nIdx);

    if  nP_Type = 'P' then
    begin
      nSQL := ' Select D_OID  from %s where D_ID = ''%s'' ';
      nSQL := Format(nSQL,[sTable_OrderDtl,nP_Order]);
      with FDM.QueryTemp(nSQL) do
      begin
        if RecordCount < 1 then
          Continue;

        nDID := FieldByName('D_OID').AsString;

        nStr := ' Update P_OrderDtl Set D_Truck=''%s'',D_PValue=''%s'',D_MValue=''%s'', '
          +' D_Value = isnull(D_MValue,0)-isnull(D_PValue,0) Where D_ID=''%s''';
        nStr := Format(nStr, [Trim(EditTruck.Text),Trim(EditPValue.Text),Trim(EditMValue.Text)
                ,Trim(nP_Order)]);
        FDM.ExecuteSQL(nStr);

        nStr := ' Update P_Order Set O_Truck=''%s'' Where O_ID = ''%s'' ';
        nStr := Format(nStr, [Trim(EditTruck.Text),Trim(nDID)]);
        FDM.ExecuteSQL(nStr);
      end;
    end
    else
    begin
      nSQL := ' Select P_BILL  from %s where P_ID = ''%s'' ';
      nSQL := Format(nSQL,[sTable_PoundLog,FListA.Strings[nIdx]]);
      with FDM.QueryTemp(nSQL) do
      begin
        if RecordCount < 1 then
          Continue;

        nDID := FieldByName('P_BILL').AsString;

        nStr := ' Update S_Bill Set L_Truck=''%s'',L_PValue=''%s'',L_MValue=''%s'', '
          +' L_Value = isnull(L_MValue,0)-isnull(L_PValue,0) Where L_ID = ''%s'' ';
        nStr := Format(nStr, [Trim(EditTruck.Text),Trim(EditPValue.Text),Trim(EditMValue.Text)
                ,Trim(nDID)]);
        FDM.ExecuteSQL(nStr);
      end;
    end;
  end;

  ModalResult := mrOK;
  if chkReSync.Checked then
    nStr := '勘误完成,请重新上传'
  else
    nStr := '勘误完成';
  ShowMsg(nStr, sHint);
end;

procedure TfFormPound_WxKw.WriteOptionLog(const LID: string;nIdx: Integer);
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
      if SubItems[2] <> EditPValue.Text then
      begin
        nEvent := nEvent + '皮重由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[2], EditPValue.Text]);
      end;
      if SubItems[3] <> EditMValue.Text then
      begin
        nEvent := nEvent + '毛重由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[3], EditMValue.Text]);
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
  gControlManager.RegCtrl(TfFormPound_WxKw, TfFormPound_WxKw.FormID);
end.
